import type { Context } from "hono";
import type { AppEnv } from "../env";
import { fail } from "./http";

/**
 * Fixed-window rate limiter on KV. KV is eventually consistent, so this is a
 * best-effort abuse guard rather than an exact quota.
 */
export async function rateLimit(c: Context<AppEnv>, bucket: string, limit: number, windowSeconds: number) {
  const who = c.var.user?.id ?? c.req.header("cf-connecting-ip") ?? "anon";
  const windowId = Math.floor(Date.now() / 1000 / windowSeconds);
  const key = `rl:${bucket}:${who}:${windowId}`;
  const current = Number((await c.env.KV.get(key)) ?? 0);
  if (current >= limit) fail(429, "Too many requests — please slow down and try again shortly", "rate_limited");
  await c.env.KV.put(key, String(current + 1), { expirationTtl: Math.max(60, windowSeconds * 2) });
}
