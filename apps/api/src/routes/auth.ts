import { Hono } from "hono";
import { and, eq, gt, ne } from "drizzle-orm";
import { changePasswordSchema, forgotPasswordSchema, loginSchema, registerSchema, resetPasswordSchema } from "@latent/shared";
import { passwordResets, sessions, users } from "../db/schema";
import type { AppEnv } from "../env";
import { createSession, destroySession, requireUser, toSessionUser } from "../lib/auth";
import { hashPassword, newId, randomToken, sha256, verifyPassword } from "../lib/crypto";
import { emailLayout, sendEmail } from "../lib/email";
import { body, fail, nowIso } from "../lib/http";
import { rateLimit } from "../lib/ratelimit";

export const auth = new Hono<AppEnv>()
  .post("/register", body(registerSchema), async (c) => {
    await rateLimit(c, "register", 10, 3600);
    const { name, email, password } = c.req.valid("json");
    const db = c.var.db;
    const exists = await db.select({ id: users.id }).from(users).where(eq(users.email, email)).get();
    if (exists) fail(409, "An account with this email already exists", "email_taken");
    const id = newId("usr");
    await db.insert(users).values({ id, name, email, passwordHash: await hashPassword(password) });
    await createSession(c, id);
    const user = await db.select().from(users).where(eq(users.id, id)).get();
    c.executionCtx.waitUntil(
      sendEmail(c.env, {
        to: email,
        subject: `Welcome to ${c.env.APP_NAME}`,
        html: emailLayout(
          c.env,
          `Welcome aboard, ${name.split(" ")[0]}`,
          "Your account is ready. Explore our catalog of hands-on AI and machine learning courses, built by practitioners.",
          { label: "Browse courses", url: `${c.env.APP_URL}/courses` },
        ),
      }),
    );
    return c.json({ user: await toSessionUser(c, user!) }, 201);
  })

  .post("/login", body(loginSchema), async (c) => {
    await rateLimit(c, "login", 20, 900);
    const { email, password } = c.req.valid("json");
    const user = await c.var.db.select().from(users).where(eq(users.email, email)).get();
    if (!user || !(await verifyPassword(password, user.passwordHash))) fail(401, "Incorrect email or password", "invalid_credentials");
    await createSession(c, user.id);
    return c.json({ user: await toSessionUser(c, user) });
  })

  .post("/logout", async (c) => {
    await destroySession(c);
    return c.json({ ok: true });
  })

  .get("/me", async (c) => {
    const u = c.var.user;
    return c.json({ user: u ? await toSessionUser(c, u) : null });
  })

  .post("/forgot-password", body(forgotPasswordSchema), async (c) => {
    await rateLimit(c, "forgot", 5, 3600);
    const { email } = c.req.valid("json");
    const user = await c.var.db.select().from(users).where(eq(users.email, email.toLowerCase())).get();
    if (user) {
      const token = randomToken(32);
      await c.var.db.insert(passwordResets).values({
        id: await sha256(token),
        userId: user.id,
        expiresAt: new Date(Date.now() + 3600_000).toISOString(),
      });
      const url = `${c.env.APP_URL}/reset-password?token=${token}`;
      c.executionCtx.waitUntil(
        sendEmail(c.env, {
          to: user.email,
          subject: "Reset your password",
          html: emailLayout(c.env, "Reset your password", "This link is valid for one hour. If you didn't request it, you can ignore this email.", {
            label: "Choose a new password",
            url,
          }),
        }),
      );
    }
    // Same response either way so emails can't be enumerated.
    return c.json({ ok: true });
  })

  .post("/reset-password", body(resetPasswordSchema), async (c) => {
    const { token, password } = c.req.valid("json");
    const db = c.var.db;
    const row = await db
      .select()
      .from(passwordResets)
      .where(and(eq(passwordResets.id, await sha256(token)), gt(passwordResets.expiresAt, nowIso())))
      .get();
    if (!row) fail(400, "This reset link is invalid or has expired", "invalid_token");
    await db.batch([
      db.update(users).set({ passwordHash: await hashPassword(password), updatedAt: nowIso() }).where(eq(users.id, row.userId)),
      db.delete(passwordResets).where(eq(passwordResets.userId, row.userId)),
      db.delete(sessions).where(eq(sessions.userId, row.userId)),
    ]);
    await createSession(c, row.userId);
    return c.json({ ok: true });
  })

  .patch("/password", body(changePasswordSchema), async (c) => {
    const user = requireUser(c);
    const { currentPassword, newPassword } = c.req.valid("json");
    if (!(await verifyPassword(currentPassword, user.passwordHash))) fail(400, "Your current password is incorrect", "invalid_password");
    const db = c.var.db;
    await db.batch([
      db.update(users).set({ passwordHash: await hashPassword(newPassword), updatedAt: nowIso() }).where(eq(users.id, user.id)),
      // Sign out every other device.
      db.delete(sessions).where(and(eq(sessions.userId, user.id), ne(sessions.id, c.var.sessionId!))),
    ]);
    return c.json({ ok: true });
  });
