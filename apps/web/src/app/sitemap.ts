import type { MetadataRoute } from "next";
import type { CourseCard, LearningPath, Paginated } from "@latent/shared";
import { serverApiSafe } from "@/lib/server";

export const dynamic = "force-dynamic";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000";
  const [courses, paths] = await Promise.all([
    serverApiSafe<Paginated<CourseCard>>("/courses?pageSize=48"),
    serverApiSafe<{ items: LearningPath[] }>("/paths"),
  ]);
  const staticRoutes = ["", "/courses", "/paths", "/pricing", "/teams", "/instructors", "/about"].map((p) => ({
    url: `${base}${p}`,
    changeFrequency: "weekly" as const,
    priority: p === "" ? 1 : 0.7,
  }));
  return [
    ...staticRoutes,
    ...(courses?.items ?? []).map((c) => ({ url: `${base}/courses/${c.slug}`, lastModified: c.updatedAt, priority: 0.8 })),
    ...(paths?.items ?? []).map((p) => ({ url: `${base}/paths/${p.slug}`, priority: 0.6 })),
  ];
}
