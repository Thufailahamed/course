import type { Bindings } from "../env";
import { hmacSha256Hex, timingSafeEqual } from "./crypto";

/** Minimal Stripe REST client (fetch-based, Workers-friendly). */

type Params = Record<string, unknown>;

function encode(params: Params, prefix = "", out: string[] = []): string[] {
  for (const [k, v] of Object.entries(params)) {
    if (v === undefined || v === null) continue;
    const key = prefix ? `${prefix}[${k}]` : k;
    if (Array.isArray(v)) {
      v.forEach((item, i) => {
        if (typeof item === "object" && item !== null) encode(item as Params, `${key}[${i}]`, out);
        else out.push(`${encodeURIComponent(`${key}[${i}]`)}=${encodeURIComponent(String(item))}`);
      });
    } else if (typeof v === "object") {
      encode(v as Params, key, out);
    } else {
      out.push(`${encodeURIComponent(key)}=${encodeURIComponent(String(v))}`);
    }
  }
  return out;
}

export async function stripe<T = any>(env: Bindings, method: "GET" | "POST" | "DELETE", path: string, params?: Params): Promise<T> {
  if (!env.STRIPE_SECRET_KEY) throw new Error("Stripe is not configured");
  const qs = params ? encode(params).join("&") : "";
  const url = `https://api.stripe.com/v1${path}${method === "GET" && qs ? `?${qs}` : ""}`;
  const res = await fetch(url, {
    method,
    headers: {
      Authorization: `Bearer ${env.STRIPE_SECRET_KEY}`,
      "Content-Type": "application/x-www-form-urlencoded",
      "Stripe-Version": "2025-09-30.clover",
    },
    body: method === "GET" ? undefined : qs,
  });
  const data = (await res.json()) as any;
  if (!res.ok) throw new Error(data?.error?.message ?? `Stripe error ${res.status}`);
  return data as T;
}

export const stripeEnabled = (env: Bindings) => !!env.STRIPE_SECRET_KEY;

/** Verifies a `Stripe-Signature` header (v1 scheme, 5 minute tolerance). */
export async function verifyStripeSignature(payload: string, header: string | undefined, secret: string): Promise<boolean> {
  if (!header) return false;
  const parts = Object.fromEntries(
    header.split(",").map((p) => {
      const [k, ...rest] = p.split("=");
      return [k, rest.join("=")];
    }),
  ) as Record<string, string>;
  const t = parts.t;
  const sigs = header
    .split(",")
    .filter((p) => p.startsWith("v1="))
    .map((p) => p.slice(3));
  if (!t || !sigs.length) return false;
  if (Math.abs(Date.now() / 1000 - Number(t)) > 300) return false;
  const expected = new TextEncoder().encode(await hmacSha256Hex(secret, `${t}.${payload}`));
  return sigs.some((s) => timingSafeEqual(new TextEncoder().encode(s), expected));
}
