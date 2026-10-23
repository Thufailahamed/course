import { Hono } from "hono";
import { cors } from "hono/cors";
import { HTTPException } from "hono/http-exception";
import { logger } from "hono/logger";
import { secureHeaders } from "hono/secure-headers";
import { drizzle } from "drizzle-orm/d1";
import * as schema from "./db/schema";
import type { AppEnv } from "./env";
import { sessionMiddleware } from "./lib/auth";
import { admin } from "./routes/admin";
import { auth } from "./routes/auth";
import { catalog } from "./routes/catalog";
import { commerce } from "./routes/commerce";
import { learn } from "./routes/learn";
import { me } from "./routes/me";

const app = new Hono<AppEnv>().basePath("/api");

app.use(logger());
app.use(secureHeaders({ crossOriginResourcePolicy: "cross-origin" }));
app.use(
  cors({
    origin: (origin, c) => (origin === c.env.APP_URL ? origin : null),
    credentials: true,
    allowMethods: ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"],
  }),
);
app.use(async (c, next) => {
  c.set("db", drizzle(c.env.DB, { schema }));
  await next();
});
app.use(sessionMiddleware);

app.get("/health", (c) => c.json({ ok: true, time: new Date().toISOString() }));

/** Public R2 media (thumbnails, avatars). Videos go through /stream with access checks. */
app.get("/media/*", async (c) => {
  const key = decodeURIComponent(c.req.path.replace(/^\/api\/media\//, ""));
  if (!key || key.startsWith("videos/") || key.includes("..")) return c.json({ error: "Not found" }, 404);
  const obj = await c.env.MEDIA.get(key);
  if (!obj) return c.json({ error: "Not found" }, 404);
  const headers = new Headers();
  obj.writeHttpMetadata(headers);
  headers.set("etag", obj.httpEtag);
  if (!headers.has("cache-control")) headers.set("cache-control", "public, max-age=86400");
  return new Response(obj.body, { headers });
});

app.route("/auth", auth);
app.route("/me", me);
app.route("/admin", admin);
app.route("/", catalog);
app.route("/", learn);
app.route("/", commerce);

app.notFound((c) => c.json({ error: "Not found", code: "not_found" }, 404));

app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return c.json({ error: err.message, code: (err.cause as string) ?? undefined }, err.status);
  }
  console.error(err);
  return c.json({ error: "Something went wrong on our side. Please try again.", code: "internal" }, 500);
});

export default app;
