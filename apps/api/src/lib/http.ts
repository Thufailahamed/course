import { HTTPException } from "hono/http-exception";
import type { ContentfulStatusCode } from "hono/utils/http-status";
import { zValidator } from "@hono/zod-validator";
import type { ZodType } from "zod";

export function fail(status: ContentfulStatusCode, message: string, code?: string): never {
  throw new HTTPException(status, { message, cause: code });
}

export function notFound(what = "Resource"): never {
  fail(404, `${what} not found`, "not_found");
}

/** JSON body validator that returns `{ error, fields }` on failure. */
export const body = <T extends ZodType>(schema: T) =>
  zValidator("json", schema, (result, c) => {
    if (!result.success) {
      const fields: Record<string, string> = {};
      for (const issue of result.error.issues) {
        const key = issue.path.join(".") || "_";
        fields[key] ??= issue.message;
      }
      return c.json({ error: Object.values(fields)[0] ?? "Invalid request", code: "validation", fields }, 422);
    }
  });

export const nowIso = () => new Date().toISOString();
export const today = () => new Date().toISOString().slice(0, 10);

export function parsePage(q: Record<string, string | undefined>, defaultSize = 12, maxSize = 100) {
  const page = Math.max(1, Number.parseInt(q.page ?? "1", 10) || 1);
  const pageSize = Math.min(maxSize, Math.max(1, Number.parseInt(q.pageSize ?? String(defaultSize), 10) || defaultSize));
  return { page, pageSize, offset: (page - 1) * pageSize };
}

export function paginated<T>(items: T[], total: number, page: number, pageSize: number) {
  return { items, total, page, pageSize, pageCount: Math.max(1, Math.ceil(total / pageSize)) };
}
