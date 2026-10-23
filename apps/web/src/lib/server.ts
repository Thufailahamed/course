import "server-only";
import { cookies } from "next/headers";
import { notFound, redirect } from "next/navigation";
import type { SessionUser } from "@latent/shared";

type Fetcher = { fetch: typeof fetch };

const API_ORIGIN = process.env.API_URL ?? "http://127.0.0.1:8787";

/** The API service binding when running on Cloudflare, otherwise null (local dev). */
async function apiBinding(): Promise<Fetcher | null> {
  // `next dev` talks to `wrangler dev` over HTTP (API_URL).
  if (process.env.NODE_ENV === "development") return null;
  try {
    const { getCloudflareContext } = await import("@opennextjs/cloudflare");
    const { env } = await getCloudflareContext({ async: true });
    return ((env as Record<string, unknown>).API as Fetcher) ?? null;
  } catch {
    return null;
  }
}

/** Forwards a request to the API worker (binding in prod, API_URL in dev). */
export async function forwardToApi(path: string, init: RequestInit) {
  const binding = await apiBinding();
  const url = `${binding ? "https://api.internal" : API_ORIGIN}${path}`;
  return binding ? binding.fetch(url, init) : fetch(url, init);
}

export class ServerApiError extends Error {
  constructor(
    message: string,
    public status: number,
  ) {
    super(message);
  }
}

/** Server-side GET with the visitor's cookies, for Server Components. */
export async function serverApi<T>(path: string): Promise<T> {
  const cookie = (await cookies()).toString();
  const res = await forwardToApi(`/api${path}`, {
    headers: cookie ? { cookie } : undefined,
    cache: "no-store",
  });
  if (!res.ok) {
    let msg = `API ${res.status}`;
    try {
      msg = (await res.json()).error ?? msg;
    } catch {}
    throw new ServerApiError(msg, res.status);
  }
  return res.json() as Promise<T>;
}

/** Like serverApi, but turns a 404 into Next's notFound(). */
export async function serverApiOr404<T>(path: string): Promise<T> {
  try {
    return await serverApi<T>(path);
  } catch (e) {
    if (e instanceof ServerApiError && e.status === 404) notFound();
    throw e;
  }
}

/** Same as serverApi but returns null instead of throwing. */
export async function serverApiSafe<T>(path: string): Promise<T | null> {
  try {
    return await serverApi<T>(path);
  } catch {
    return null;
  }
}

export async function getSession(): Promise<SessionUser | null> {
  const data = await serverApiSafe<{ user: SessionUser | null }>("/auth/me");
  return data?.user ?? null;
}

/** Redirects to /login (preserving the destination) when signed out. */
export async function requireSession(next: string): Promise<SessionUser> {
  const user = await getSession();
  if (!user) redirect(`/login?next=${encodeURIComponent(next)}`);
  return user;
}

export async function requireStaff(next: string): Promise<SessionUser> {
  const user = await requireSession(next);
  if (user.role === "student") redirect("/dashboard");
  return user;
}
