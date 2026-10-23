import type { NextRequest } from "next/server";
import { forwardToApi } from "@/lib/server";

// Same-origin proxy: /api/* → Hono API worker. Keeps auth cookies first-party
// and lets streaming (AI tutor SSE, video ranges) pass straight through.

const HOP_BY_HOP = ["connection", "keep-alive", "transfer-encoding", "upgrade", "host", "content-length", "expect"];

async function proxy(req: NextRequest) {
  const headers = new Headers(req.headers);
  for (const h of HOP_BY_HOP) headers.delete(h);
  headers.set("x-forwarded-host", req.headers.get("host") ?? "");

  const hasBody = !["GET", "HEAD"].includes(req.method);
  const upstream = await forwardToApi(`${req.nextUrl.pathname}${req.nextUrl.search}`, {
    method: req.method,
    headers,
    body: hasBody ? req.body : undefined,
    redirect: "manual",
    // Required by undici for streaming request bodies.
    ...(hasBody ? { duplex: "half" } : {}),
  } as RequestInit);

  const resHeaders = new Headers(upstream.headers);
  // fetch() already decoded the body; drop encoding headers so the browser doesn't decode twice.
  resHeaders.delete("content-encoding");
  if (upstream.headers.get("content-encoding")) resHeaders.delete("content-length");
  return new Response(upstream.body, { status: upstream.status, statusText: upstream.statusText, headers: resHeaders });
}

export const GET = proxy;
export const POST = proxy;
export const PUT = proxy;
export const PATCH = proxy;
export const DELETE = proxy;
export const HEAD = proxy;
export const OPTIONS = proxy;

export const dynamic = "force-dynamic";
