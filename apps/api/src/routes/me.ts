import { Hono } from "hono";
import { and, count, desc, eq, gte, inArray, isNotNull, sql, type SQL } from "drizzle-orm";
import type { Enrollment, LearningStats, Order } from "@latent/shared";
import { updateProfileSchema } from "@latent/shared";
import { activity, certificates, courses, enrollments, lessonProgress, orderItems, orders, subscriptions, users, wishlist } from "../db/schema";
import type { AppEnv } from "../env";
import { authed, requireUser, toSessionUser } from "../lib/auth";
import { getCards } from "../lib/courses";
import { newId } from "../lib/crypto";
import { body, fail, nowIso } from "../lib/http";

const IMAGE_TYPES = ["image/png", "image/jpeg", "image/webp", "image/gif"];

export async function loadOrders(c: { var: AppEnv["Variables"] }, where: SQL | undefined, limit = 100): Promise<Order[]> {
  const db = c.var.db;
  const rows = await db.select().from(orders).where(where).orderBy(desc(orders.createdAt)).limit(limit).all();
  if (!rows.length) return [];
  const items = await db
    .select({ orderId: orderItems.orderId, courseId: orderItems.courseId, title: orderItems.title, priceCents: orderItems.priceCents, slug: courses.slug })
    .from(orderItems)
    .leftJoin(courses, eq(courses.id, orderItems.courseId))
    .where(inArray(orderItems.orderId, rows.map((r) => r.id)))
    .all();
  return rows.map((o) => ({
    id: o.id,
    status: o.status,
    kind: o.kind,
    subtotalCents: o.subtotalCents,
    discountCents: o.discountCents,
    totalCents: o.totalCents,
    currency: o.currency,
    couponCode: o.couponCode,
    createdAt: o.createdAt,
    paidAt: o.paidAt,
    items: items
      .filter((i) => i.orderId === o.id)
      .map((i) => ({ courseId: i.courseId ?? "", title: i.title, priceCents: i.priceCents, slug: i.slug ?? undefined })),
  }));
}

export const me = new Hono<AppEnv>()
  .use(authed)

  .patch("/", body(updateProfileSchema), async (c) => {
    const user = requireUser(c);
    const data = c.req.valid("json");
    await c.var.db.update(users).set({ ...data, updatedAt: nowIso() }).where(eq(users.id, user.id));
    const updated = await c.var.db.select().from(users).where(eq(users.id, user.id)).get();
    return c.json({ user: await toSessionUser(c, updated!) });
  })

  .post("/avatar", async (c) => {
    const user = requireUser(c);
    const form = await c.req.formData();
    const file = form.get("file");
    if (!(file instanceof File)) fail(400, "No file uploaded");
    if (!IMAGE_TYPES.includes(file.type)) fail(415, "Upload a PNG, JPG, WebP or GIF image");
    if (file.size > 4 * 1024 * 1024) fail(413, "Avatar must be under 4 MB");
    const key = `avatars/${user.id}/${newId()}.${file.type.split("/")[1]}`;
    await c.env.MEDIA.put(key, file.stream(), { httpMetadata: { contentType: file.type, cacheControl: "public, max-age=31536000, immutable" } });
    const avatarUrl = `/api/media/${key}`;
    await c.var.db.update(users).set({ avatarUrl, updatedAt: nowIso() }).where(eq(users.id, user.id));
    return c.json({ avatarUrl });
  })

  .get("/enrollments", async (c) => {
    const user = requireUser(c);
    const rows = await c.var.db
      .select()
      .from(enrollments)
      .where(eq(enrollments.userId, user.id))
      .orderBy(desc(sql`coalesce(${enrollments.lastActivityAt}, ${enrollments.createdAt})`))
      .all();
    const cards = await getCards(c.var.db, rows.map((r) => r.courseId));
    const byId = new Map(cards.map((x) => [x.id, x]));
    const items: Enrollment[] = rows
      .filter((r) => byId.has(r.courseId))
      .map((r) => ({
        courseId: r.courseId,
        enrolledAt: r.createdAt,
        completedAt: r.completedAt,
        progressPercent: r.progressPercent,
        lastLessonId: r.lastLessonId,
        lastActivityAt: r.lastActivityAt,
        course: byId.get(r.courseId)!,
      }));
    return c.json({ items });
  })

  .get("/wishlist", async (c) => {
    const user = requireUser(c);
    const rows = await c.var.db.select().from(wishlist).where(eq(wishlist.userId, user.id)).orderBy(desc(wishlist.createdAt)).all();
    return c.json({ items: await getCards(c.var.db, rows.map((r) => r.courseId)) });
  })

  .post("/wishlist/:courseId", async (c) => {
    const user = requireUser(c);
    const courseId = c.req.param("courseId");
    const course = await c.var.db.select({ id: courses.id }).from(courses).where(eq(courses.id, courseId)).get();
    if (!course) fail(404, "Course not found");
    await c.var.db.insert(wishlist).values({ userId: user.id, courseId }).onConflictDoNothing();
    return c.json({ ok: true, inWishlist: true });
  })

  .delete("/wishlist/:courseId", async (c) => {
    const user = requireUser(c);
    await c.var.db.delete(wishlist).where(and(eq(wishlist.userId, user.id), eq(wishlist.courseId, c.req.param("courseId"))));
    return c.json({ ok: true, inWishlist: false });
  })

  .get("/orders", async (c) => {
    const user = requireUser(c);
    return c.json({ items: await loadOrders(c, eq(orders.userId, user.id)) });
  })

  .get("/orders/:id", async (c) => {
    const user = requireUser(c);
    const [order] = await loadOrders(c, and(eq(orders.id, c.req.param("id")), eq(orders.userId, user.id)), 1);
    if (!order) fail(404, "Order not found");
    return c.json({ order });
  })

  .get("/certificates", async (c) => {
    const user = requireUser(c);
    const rows = await c.var.db
      .select({ id: certificates.id, issuedAt: certificates.issuedAt, courseId: certificates.courseId })
      .from(certificates)
      .where(eq(certificates.userId, user.id))
      .orderBy(desc(certificates.issuedAt))
      .all();
    const cards = await getCards(c.var.db, rows.map((r) => r.courseId));
    const byId = new Map(cards.map((x) => [x.id, x]));
    return c.json({
      items: rows.filter((r) => byId.has(r.courseId)).map((r) => ({ id: r.id, issuedAt: r.issuedAt, course: byId.get(r.courseId)! })),
    });
  })

  .get("/subscription", async (c) => {
    const user = requireUser(c);
    const sub = await c.var.db
      .select()
      .from(subscriptions)
      .where(eq(subscriptions.userId, user.id))
      .orderBy(desc(subscriptions.createdAt))
      .get();
    return c.json({
      subscription: sub
        ? { id: sub.id, plan: sub.plan, status: sub.status, currentPeriodEnd: sub.currentPeriodEnd, cancelAtPeriodEnd: sub.cancelAtPeriodEnd }
        : null,
    });
  })

  .get("/stats", async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    const since = new Date(Date.now() - 182 * 864e5).toISOString().slice(0, 10);
    const [enr, certs, lessonsDone, act, allDays] = await Promise.all([
      db
        .select({
          total: count(),
          completed: sql<number>`sum(case when ${enrollments.completedAt} is not null then 1 else 0 end)`,
        })
        .from(enrollments)
        .where(eq(enrollments.userId, user.id))
        .get(),
      db.select({ n: count() }).from(certificates).where(eq(certificates.userId, user.id)).get(),
      db
        .select({ n: count() })
        .from(lessonProgress)
        .where(and(eq(lessonProgress.userId, user.id), eq(lessonProgress.completed, true), isNotNull(lessonProgress.completedAt)))
        .get(),
      db.select().from(activity).where(and(eq(activity.userId, user.id), gte(activity.date, since))).all(),
      db.select({ date: activity.date, seconds: activity.seconds }).from(activity).where(eq(activity.userId, user.id)).orderBy(activity.date).all(),
    ]);

    const byDate = new Map(act.map((a) => [a.date, a]));
    const days: LearningStats["activity"] = [];
    for (let i = 181; i >= 0; i--) {
      const d = new Date(Date.now() - i * 864e5).toISOString().slice(0, 10);
      const a = byDate.get(d);
      days.push({ date: d, lessons: a?.lessons ?? 0, minutes: Math.round((a?.seconds ?? 0) / 60) });
    }

    // Streaks over every active day.
    const activeDays = new Set(allDays.map((d) => d.date));
    let current = 0;
    for (let i = 0; ; i++) {
      const d = new Date(Date.now() - i * 864e5).toISOString().slice(0, 10);
      if (activeDays.has(d)) current++;
      else if (i > 0) break; // allow today to be empty
      if (i > 3650) break;
    }
    let longest = 0;
    let run = 0;
    let prev: number | null = null;
    for (const d of allDays) {
      const t = Date.parse(d.date);
      run = prev !== null && t - prev === 864e5 ? run + 1 : 1;
      longest = Math.max(longest, run);
      prev = t;
    }

    const total = enr?.total ?? 0;
    const completed = Number(enr?.completed ?? 0);
    const stats: LearningStats = {
      enrolled: total,
      completed,
      inProgress: total - completed,
      certificates: certs?.n ?? 0,
      lessonsCompleted: lessonsDone?.n ?? 0,
      minutesLearned: Math.round(allDays.reduce((s, d) => s + d.seconds, 0) / 60),
      currentStreak: current,
      longestStreak: Math.max(longest, current),
      activity: days,
    };
    return c.json(stats);
  });
