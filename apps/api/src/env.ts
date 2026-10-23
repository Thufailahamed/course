import type { DrizzleD1Database } from "drizzle-orm/d1";
import type * as schema from "./db/schema";
import type { users } from "./db/schema";

export interface Bindings {
  DB: D1Database;
  MEDIA: R2Bucket;
  KV: KVNamespace;
  AI?: Ai;
  APP_URL: string;
  APP_NAME: string;
  CURRENCY: string;
  PRO_MONTHLY_CENTS: string;
  PRO_YEARLY_CENTS: string;
  AI_MODEL: string;
  STRIPE_SECRET_KEY?: string;
  STRIPE_WEBHOOK_SECRET?: string;
  RESEND_API_KEY?: string;
  EMAIL_FROM?: string;
}

export type UserRow = typeof users.$inferSelect;

export interface Variables {
  db: DrizzleD1Database<typeof schema>;
  user: UserRow | null;
  sessionId: string | null;
}

export type AppEnv = { Bindings: Bindings; Variables: Variables };
