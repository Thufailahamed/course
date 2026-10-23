import type { Context, MiddlewareHandler } from "hono";
import { deleteCookie, getCookie, setCookie } from "hono/cookie";
import { and, eq, gt, inArray } from "drizzle-orm";
import type { Role, SessionUser } from "@latent/shared";
import { sessions, subscriptions, users } from "../db/schema";
import type { AppEnv, UserRow } from "../env";
import { randomToken, sha256 } from "./crypto";
import { fail } from "./http";

export const SESSION_COOKIE = "latent_session";
const SESSION_DAYS = 30;

function isSecure(c: Context<AppEnv>) {
  return c.env.APP_URL.startsWith("https://");
}

export async function createSession(c: Context<AppEnv>, userId: string) {
  const token = randomToken(32);
  const expiresAt = new Date(Date.now() + SESSION_DAYS * 864e5);
  await c.var.db.insert(sessions).values({
    id: await sha256(token),
    userId,
    expiresAt: expiresAt.toISOString(),
    userAgent: c.req.header("user-agent")?.slice(0, 300) ?? null,
  });
  setCookie(c, SESSION_COOKIE, token, {
    httpOnly: true,
    secure: isSecure(c),
    sameSite: "Lax",
    path: "/",
    expires: expiresAt,
  });
}

export async function destroySession(c: Context<AppEnv>) {
  if (c.var.sessionId) await c.var.db.delete(sessions).where(eq(sessions.id, c.var.sessionId));
  deleteCookie(c, SESSION_COOKIE, { path: "/", secure: isSecure(c) });
}

/** Resolves the session cookie (or `Authorization: Bearer`) into `c.var.user`. */
export const sessionMiddleware: MiddlewareHandler<AppEnv> = async (c, next) => {
  c.set("user", null);
  c.set("sessionId", null);
  const bearer = c.req.header("authorization")?.match(/^Bearer (.+)$/)?.[1];
  const token = getCookie(c, SESSION_COOKIE) ?? bearer;
  if (token) {
    const sid = await sha256(token);
    const row = await c.var.db
      .select({ user: users })
      .from(sessions)
      .innerJoin(users, eq(users.id, sessions.userId))
      .where(and(eq(sessions.id, sid), gt(sessions.expiresAt, new Date().toISOString())))
      .get();
    if (row) {
      c.set("user", row.user);
      c.set("sessionId", sid);
    }
  }
  await next();
};

export function requireUser(c: Context<AppEnv>): UserRow {
  const user = c.var.user;
  if (!user) fail(401, "Please sign in to continue", "unauthorized");
  return user;
}

export function requireRole(c: Context<AppEnv>, ...roles: Role[]): UserRow {
  const user = requireUser(c);
  if (!roles.includes(user.role)) fail(403, "You don't have permission to do that", "forbidden");
  return user;
}

export const authed: MiddlewareHandler<AppEnv> = async (c, next) => {
  requireUser(c);
  await next();
};

export const staffOnly: MiddlewareHandler<AppEnv> = async (c, next) => {
  requireRole(c, "instructor", "admin");
  await next();
};

export const adminOnly: MiddlewareHandler<AppEnv> = async (c, next) => {
  requireRole(c, "admin");
  await next();
};

export async function hasActivePro(c: Context<AppEnv>, userId: string): Promise<boolean> {
  const sub = await c.var.db
    .select({ id: subscriptions.id, end: subscriptions.currentPeriodEnd })
    .from(subscriptions)
    .where(and(eq(subscriptions.userId, userId), inArray(subscriptions.status, ["active", "trialing"])))
    .get();
  if (!sub) return false;
  return !sub.end || sub.end > new Date().toISOString();
}

export async function toSessionUser(c: Context<AppEnv>, u: UserRow): Promise<SessionUser> {
  return {
    id: u.id,
    name: u.name,
    email: u.email,
    role: u.role,
    avatarUrl: u.avatarUrl,
    headline: u.headline,
    bio: u.bio,
    createdAt: u.createdAt,
    hasPro: await hasActivePro(c, u.id),
  };
}
