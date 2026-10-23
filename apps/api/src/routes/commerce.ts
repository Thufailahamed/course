import { Hono, type Context } from "hono";
import { and, desc, eq, inArray, sql } from "drizzle-orm";
import type { Plan } from "@latent/shared";
import { checkoutSchema, couponCheckSchema, formatPrice, subscribeSchema } from "@latent/shared";
import { coupons, courses, enrollments, orderItems, orders, subscriptions, users } from "../db/schema";
import type { AppEnv, Bindings, UserRow } from "../env";
import { hasActivePro, requireUser } from "../lib/auth";
import { enroll } from "../lib/courses";
import { newId } from "../lib/crypto";
import { emailLayout, sendEmail } from "../lib/email";
import { body, fail, nowIso } from "../lib/http";
import { stripe, stripeEnabled, verifyStripeSignature } from "../lib/stripe";

type Ctx = Context<AppEnv>;
type DB = AppEnv["Variables"]["db"];

/* ── Pricing ─────────────────────────────────────────────── */

async function findCoupon(db: DB, code: string) {
  const coupon = await db.select().from(coupons).where(eq(coupons.code, code.trim().toUpperCase())).get();
  if (!coupon || !coupon.active) return { coupon: null, error: "This code isn't valid" };
  if (coupon.expiresAt && coupon.expiresAt < nowIso()) return { coupon: null, error: "This code has expired" };
  if (coupon.maxRedemptions && coupon.redemptions >= coupon.maxRedemptions) return { coupon: null, error: "This code has been fully redeemed" };
  return { coupon, error: null };
}

export async function priceCart(db: DB, userId: string | null, courseIds: string[], couponCode?: string | null) {
  const unique = [...new Set(courseIds)];
  const rows = unique.length
    ? await db
        .select({ id: courses.id, title: courses.title, slug: courses.slug, priceCents: courses.priceCents, currency: courses.currency })
        .from(courses)
        .where(and(inArray(courses.id, unique), eq(courses.status, "published")))
        .all()
    : [];
  const owned = userId
    ? new Set(
        (
          await db
            .select({ id: enrollments.courseId })
            .from(enrollments)
            .where(and(eq(enrollments.userId, userId), inArray(enrollments.courseId, unique.length ? unique : [""])))
            .all()
        ).map((r) => r.id),
      )
    : new Set<string>();
  const items = rows.filter((r) => !owned.has(r.id));
  const subtotalCents = items.reduce((s, i) => s + i.priceCents, 0);

  let discountCents = 0;
  let couponError: string | null = null;
  let appliedCoupon: typeof coupons.$inferSelect | null = null;
  if (couponCode) {
    const { coupon, error } = await findCoupon(db, couponCode);
    if (!coupon) couponError = error;
    else {
      const eligible = coupon.courseId ? items.filter((i) => i.id === coupon.courseId) : items;
      const base = eligible.reduce((s, i) => s + i.priceCents, 0);
      if (!eligible.length || base === 0) couponError = "This code doesn't apply to the items in your cart";
      else {
        discountCents = coupon.percentOff ? Math.round((base * coupon.percentOff) / 100) : Math.min(base, coupon.amountOffCents ?? 0);
        appliedCoupon = coupon;
      }
    }
  }
  return {
    items,
    skipped: rows.filter((r) => owned.has(r.id)).map((r) => r.id),
    subtotalCents,
    discountCents,
    totalCents: Math.max(0, subtotalCents - discountCents),
    currency: items[0]?.currency ?? "USD",
    coupon: appliedCoupon ? { code: appliedCoupon.code, percentOff: appliedCoupon.percentOff, amountOffCents: appliedCoupon.amountOffCents } : null,
    couponError,
  };
}

/* ── Fulfilment ──────────────────────────────────────────── */

export async function fulfillOrder(env: Bindings, db: DB, orderId: string, paymentIntent?: string | null) {
  const order = await db.select().from(orders).where(eq(orders.id, orderId)).get();
  if (!order || order.status === "paid") return;
  await db
    .update(orders)
    .set({ status: "paid", paidAt: nowIso(), stripePaymentIntent: paymentIntent ?? order.stripePaymentIntent })
    .where(eq(orders.id, orderId));
  const items = await db.select().from(orderItems).where(eq(orderItems.orderId, orderId)).all();
  if (order.kind === "courses") {
    for (const item of items) if (item.courseId) await enroll(db, order.userId, item.courseId, "purchase");
  }
  if (order.couponCode) {
    await db
      .update(coupons)
      .set({ redemptions: sql`${coupons.redemptions} + 1` })
      .where(eq(coupons.code, order.couponCode));
  }
  const user = await db.select().from(users).where(eq(users.id, order.userId)).get();
  if (user) {
    const lines = items.map((i) => `<tr><td style="padding:6px 0">${i.title}</td><td style="text-align:right">${formatPrice(i.priceCents, order.currency)}</td></tr>`).join("");
    await sendEmail(env, {
      to: user.email,
      subject: `Your ${env.APP_NAME} receipt`,
      html: emailLayout(
        env,
        "Thanks for your purchase",
        `<table style="width:100%;color:#d4d4e0">${lines}<tr><td style="padding-top:12px;border-top:1px solid #333">Total</td><td style="text-align:right;padding-top:12px;border-top:1px solid #333"><b>${formatPrice(order.totalCents, order.currency)}</b></td></tr></table>`,
        { label: "Start learning", url: `${env.APP_URL}/dashboard` },
      ),
    });
  }
}

export async function refundOrder(env: Bindings, db: DB, orderId: string) {
  const order = await db.select().from(orders).where(eq(orders.id, orderId)).get();
  if (!order || order.status !== "paid") return false;
  if (stripeEnabled(env) && order.stripePaymentIntent) {
    await stripe(env, "POST", "/refunds", { payment_intent: order.stripePaymentIntent });
  }
  await db.update(orders).set({ status: "refunded" }).where(eq(orders.id, orderId));
  if (order.kind === "courses") {
    const items = await db.select({ courseId: orderItems.courseId }).from(orderItems).where(eq(orderItems.orderId, orderId)).all();
    for (const { courseId } of items) {
      if (!courseId) continue;
      const removed = await db
        .delete(enrollments)
        .where(and(eq(enrollments.userId, order.userId), eq(enrollments.courseId, courseId), eq(enrollments.source, "purchase")))
        .returning({ id: enrollments.id });
      if (removed.length) await db.update(courses).set({ studentsCount: sql`max(0, ${courses.studentsCount} - 1)` }).where(eq(courses.id, courseId));
    }
  }
  return true;
}

async function ensureCustomer(c: Ctx, user: UserRow) {
  if (user.stripeCustomerId) return user.stripeCustomerId;
  const customer = await stripe<{ id: string }>(c.env, "POST", "/customers", { email: user.email, name: user.name, metadata: { user_id: user.id } });
  await c.var.db.update(users).set({ stripeCustomerId: customer.id }).where(eq(users.id, user.id));
  return customer.id;
}

function planPrice(env: Bindings, plan: Plan) {
  return plan === "monthly" ? Number(env.PRO_MONTHLY_CENTS) : Number(env.PRO_YEARLY_CENTS);
}

function periodEnd(plan: Plan) {
  const d = new Date();
  if (plan === "monthly") d.setUTCMonth(d.getUTCMonth() + 1);
  else d.setUTCFullYear(d.getUTCFullYear() + 1);
  return d.toISOString();
}

async function syncStripeSubscription(env: Bindings, db: DB, sub: any, userId?: string, plan?: Plan) {
  const end = sub.current_period_end ?? sub.items?.data?.[0]?.current_period_end;
  const values = {
    status: sub.status as string,
    currentPeriodEnd: end ? new Date(end * 1000).toISOString() : null,
    cancelAtPeriodEnd: !!sub.cancel_at_period_end,
    updatedAt: nowIso(),
  };
  const existing = await db.select().from(subscriptions).where(eq(subscriptions.stripeSubscriptionId, sub.id)).get();
  if (existing) await db.update(subscriptions).set(values).where(eq(subscriptions.id, existing.id));
  else if (userId) {
    const interval = sub.items?.data?.[0]?.price?.recurring?.interval;
    await db.insert(subscriptions).values({
      id: newId("sub"),
      userId,
      plan: plan ?? (interval === "year" ? "yearly" : "monthly"),
      stripeSubscriptionId: sub.id,
      ...values,
    });
  }
}

/* ── Routes ──────────────────────────────────────────────── */

export const commerce = new Hono<AppEnv>()
  .post("/checkout/quote", body(couponCheckSchema.partial({ code: true })), async (c) => {
    const { courseIds, code } = c.req.valid("json");
    return c.json(await priceCart(c.var.db, c.var.user?.id ?? null, courseIds ?? [], code));
  })

  .post("/checkout", body(checkoutSchema), async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    const { courseIds, couponCode } = c.req.valid("json");
    const quote = await priceCart(db, user.id, courseIds, couponCode);
    if (!quote.items.length) fail(400, "Your cart has no purchasable courses — you may already own them", "empty_cart");
    if (couponCode && quote.couponError) fail(400, quote.couponError, "invalid_coupon");

    const orderId = newId("ord");
    // Spread the discount over line items so Stripe totals match ours.
    let remaining = quote.discountCents;
    const lines = quote.items.map((item, i) => {
      const share = i === quote.items.length - 1 ? remaining : Math.round((item.priceCents / quote.subtotalCents) * quote.discountCents);
      remaining -= share;
      return { ...item, chargedCents: Math.max(0, item.priceCents - share) };
    });

    await db.batch([
      db.insert(orders).values({
        id: orderId,
        userId: user.id,
        kind: "courses",
        status: "pending",
        subtotalCents: quote.subtotalCents,
        discountCents: quote.discountCents,
        totalCents: quote.totalCents,
        currency: quote.currency,
        couponCode: quote.coupon?.code ?? null,
      }),
      ...lines.map((l) => db.insert(orderItems).values({ id: newId("oi"), orderId, courseId: l.id, title: l.title, priceCents: l.priceCents })),
    ]);

    const successUrl = `${c.env.APP_URL}/checkout/success?order=${orderId}`;
    if (quote.totalCents === 0 || !stripeEnabled(c.env)) {
      await fulfillOrder(c.env, db, orderId);
      return c.json({ orderId, url: successUrl, mode: "demo" });
    }

    const session = await stripe<{ id: string; url: string }>(c.env, "POST", "/checkout/sessions", {
      mode: "payment",
      customer: await ensureCustomer(c, user),
      client_reference_id: user.id,
      success_url: `${successUrl}&session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${c.env.APP_URL}/cart?canceled=1`,
      metadata: { order_id: orderId, user_id: user.id },
      payment_intent_data: { metadata: { order_id: orderId } },
      line_items: lines.map((l) => ({
        quantity: 1,
        price_data: { currency: quote.currency.toLowerCase(), unit_amount: l.chargedCents, product_data: { name: l.title, metadata: { course_id: l.id } } },
      })),
    });
    await db.update(orders).set({ stripeSessionId: session.id }).where(eq(orders.id, orderId));
    return c.json({ orderId, url: session.url, mode: "stripe" });
  })

  .post("/checkout/subscribe", body(subscribeSchema), async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    if (await hasActivePro(c, user.id)) fail(409, "You already have an active Pro membership", "already_subscribed");
    const { plan } = c.req.valid("json");
    const amount = planPrice(c.env, plan);
    const orderId = newId("ord");
    const title = `${c.env.APP_NAME} Pro — ${plan === "monthly" ? "Monthly" : "Annual"}`;
    await db.batch([
      db.insert(orders).values({ id: orderId, userId: user.id, kind: "subscription", status: "pending", subtotalCents: amount, totalCents: amount, currency: c.env.CURRENCY }),
      db.insert(orderItems).values({ id: newId("oi"), orderId, courseId: null, title, priceCents: amount }),
    ]);
    const successUrl = `${c.env.APP_URL}/checkout/success?order=${orderId}&pro=1`;

    if (!stripeEnabled(c.env)) {
      await db.insert(subscriptions).values({ id: newId("sub"), userId: user.id, plan, status: "active", currentPeriodEnd: periodEnd(plan) });
      await fulfillOrder(c.env, db, orderId);
      return c.json({ orderId, url: successUrl, mode: "demo" });
    }

    const session = await stripe<{ id: string; url: string }>(c.env, "POST", "/checkout/sessions", {
      mode: "subscription",
      customer: await ensureCustomer(c, user),
      client_reference_id: user.id,
      success_url: `${successUrl}&session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${c.env.APP_URL}/pricing?canceled=1`,
      metadata: { order_id: orderId, user_id: user.id, plan },
      subscription_data: { metadata: { user_id: user.id, plan } },
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: c.env.CURRENCY.toLowerCase(),
            unit_amount: amount,
            recurring: { interval: plan === "monthly" ? "month" : "year" },
            product_data: { name: title },
          },
        },
      ],
    });
    await db.update(orders).set({ stripeSessionId: session.id }).where(eq(orders.id, orderId));
    return c.json({ orderId, url: session.url, mode: "stripe" });
  })

  .post("/billing/subscription/:action{cancel|resume}", async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    const cancel = c.req.param("action") === "cancel";
    const sub = await db
      .select()
      .from(subscriptions)
      .where(and(eq(subscriptions.userId, user.id), inArray(subscriptions.status, ["active", "trialing", "past_due"])))
      .orderBy(desc(subscriptions.createdAt))
      .get();
    if (!sub) fail(404, "No active membership found");
    if (sub.stripeSubscriptionId && stripeEnabled(c.env)) {
      const updated = await stripe(c.env, "POST", `/subscriptions/${sub.stripeSubscriptionId}`, { cancel_at_period_end: cancel });
      await syncStripeSubscription(c.env, db, updated);
    } else {
      await db.update(subscriptions).set({ cancelAtPeriodEnd: cancel, updatedAt: nowIso() }).where(eq(subscriptions.id, sub.id));
    }
    return c.json({ ok: true });
  })

  .post("/billing/portal", async (c) => {
    const user = requireUser(c);
    if (!stripeEnabled(c.env) || !user.stripeCustomerId) fail(400, "Billing portal is available once you've made a card payment");
    const session = await stripe<{ url: string }>(c.env, "POST", "/billing_portal/sessions", {
      customer: user.stripeCustomerId,
      return_url: `${c.env.APP_URL}/account/billing`,
    });
    return c.json({ url: session.url });
  })

  /** Confirms a Stripe session on the success page (covers webhook latency in dev). */
  .post("/checkout/confirm", async (c) => {
    const user = requireUser(c);
    const { orderId } = await c.req.json<{ orderId: string }>();
    const order = await c.var.db
      .select()
      .from(orders)
      .where(and(eq(orders.id, orderId), eq(orders.userId, user.id)))
      .get();
    if (!order) fail(404, "Order not found");
    if (order.status === "pending" && order.stripeSessionId && stripeEnabled(c.env)) {
      const s = await stripe(c.env, "GET", `/checkout/sessions/${order.stripeSessionId}`);
      if (s.payment_status === "paid" || s.status === "complete") {
        if (s.mode === "subscription" && s.subscription) {
          const sub = await stripe(c.env, "GET", `/subscriptions/${s.subscription}`);
          await syncStripeSubscription(c.env, c.var.db, sub, user.id, s.metadata?.plan);
        }
        await fulfillOrder(c.env, c.var.db, order.id, s.payment_intent);
      }
    }
    const fresh = await c.var.db.select({ status: orders.status, kind: orders.kind }).from(orders).where(eq(orders.id, orderId)).get();
    return c.json(fresh);
  })

  .post("/webhooks/stripe", async (c) => {
    const secret = c.env.STRIPE_WEBHOOK_SECRET;
    if (!secret) fail(400, "Webhooks not configured");
    const payload = await c.req.text();
    if (!(await verifyStripeSignature(payload, c.req.header("stripe-signature"), secret))) fail(400, "Invalid signature");
    const event = JSON.parse(payload) as { type: string; data: { object: any } };
    const obj = event.data.object;
    const db = c.var.db;

    switch (event.type) {
      case "checkout.session.completed":
      case "checkout.session.async_payment_succeeded": {
        if (obj.payment_status !== "paid" && obj.mode !== "subscription") break;
        if (obj.mode === "subscription" && obj.subscription) {
          const sub = await stripe(c.env, "GET", `/subscriptions/${obj.subscription}`);
          await syncStripeSubscription(c.env, db, sub, obj.metadata?.user_id, obj.metadata?.plan);
        }
        if (obj.metadata?.order_id) await fulfillOrder(c.env, db, obj.metadata.order_id, obj.payment_intent);
        break;
      }
      case "customer.subscription.updated":
      case "customer.subscription.deleted":
        await syncStripeSubscription(c.env, db, obj, obj.metadata?.user_id, obj.metadata?.plan);
        break;
      case "charge.refunded": {
        if (!obj.payment_intent) break;
        const order = await db.select().from(orders).where(eq(orders.stripePaymentIntent, obj.payment_intent)).get();
        if (order?.status === "paid") {
          // Stripe already refunded; only revoke locally.
          await db.update(orders).set({ stripePaymentIntent: null }).where(eq(orders.id, order.id));
          await refundOrder(c.env, db, order.id);
        }
        break;
      }
    }
    return c.json({ received: true });
  });
