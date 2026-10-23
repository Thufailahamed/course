import { and, asc, count, eq, inArray, sql } from "drizzle-orm";
import type { DrizzleD1Database } from "drizzle-orm/d1";
import type { CourseCard, CurriculumSection } from "@latent/shared";
import * as schema from "../db/schema";
import { categories, certificates, courses, enrollments, lessonProgress, lessons, sections, users } from "../db/schema";
import { newId } from "./crypto";
import { nowIso } from "./http";

type DB = DrizzleD1Database<typeof schema>;

export const mediaUrl = (key: string | null | undefined) => (key ? `/api/media/${key}` : null);

/** Columns needed to build a `CourseCard`. Join users (instructor) and categories. */
export const cardColumns = {
  id: courses.id,
  slug: courses.slug,
  title: courses.title,
  subtitle: courses.subtitle,
  level: courses.level,
  priceCents: courses.priceCents,
  compareAtPriceCents: courses.compareAtPriceCents,
  currency: courses.currency,
  thumbnailKey: courses.thumbnailKey,
  accent: courses.accent,
  ratingAvg: courses.ratingAvg,
  ratingCount: courses.ratingCount,
  studentsCount: courses.studentsCount,
  lessonsCount: courses.lessonsCount,
  durationMinutes: courses.durationMinutes,
  featured: courses.featured,
  tags: courses.tags,
  updatedAt: courses.updatedAt,
  categorySlug: categories.slug,
  categoryName: categories.name,
  instructorId: users.id,
  instructorName: users.name,
  instructorAvatar: users.avatarUrl,
  instructorHeadline: users.headline,
};

export function cardQuery(db: DB) {
  return db
    .select(cardColumns)
    .from(courses)
    .innerJoin(users, eq(users.id, courses.instructorId))
    .leftJoin(categories, eq(categories.id, courses.categoryId));
}

export type CardRow = Awaited<ReturnType<ReturnType<typeof cardQuery>["all"]>>[number];

export function toCard(r: CardRow): CourseCard {
  return {
    id: r.id,
    slug: r.slug,
    title: r.title,
    subtitle: r.subtitle,
    level: r.level,
    priceCents: r.priceCents,
    compareAtPriceCents: r.compareAtPriceCents,
    currency: r.currency,
    thumbnailUrl: mediaUrl(r.thumbnailKey),
    accent: r.accent,
    ratingAvg: Math.round(r.ratingAvg * 10) / 10,
    ratingCount: r.ratingCount,
    studentsCount: r.studentsCount,
    lessonsCount: r.lessonsCount,
    durationMinutes: r.durationMinutes,
    featured: r.featured,
    bestseller: r.studentsCount >= 5000 && r.ratingAvg >= 4.6,
    tags: r.tags ?? [],
    category: r.categorySlug && r.categoryName ? { slug: r.categorySlug, name: r.categoryName } : null,
    instructor: { id: r.instructorId, name: r.instructorName, avatarUrl: r.instructorAvatar, headline: r.instructorHeadline },
    updatedAt: r.updatedAt,
  };
}

export async function getCards(db: DB, ids: string[]): Promise<CourseCard[]> {
  if (!ids.length) return [];
  const rows = await cardQuery(db).where(inArray(courses.id, ids)).all();
  const byId = new Map(rows.map((r) => [r.id, toCard(r)]));
  return ids.map((id) => byId.get(id)).filter((c): c is CourseCard => !!c);
}

export async function getCurriculum(db: DB, courseId: string) {
  const [secs, less] = await Promise.all([
    db.select().from(sections).where(eq(sections.courseId, courseId)).orderBy(asc(sections.position)).all(),
    db
      .select({
        id: lessons.id,
        sectionId: lessons.sectionId,
        title: lessons.title,
        type: lessons.type,
        durationSeconds: lessons.durationSeconds,
        isPreview: lessons.isPreview,
        position: lessons.position,
        videoUrl: lessons.videoUrl,
        videoKey: lessons.videoKey,
      })
      .from(lessons)
      .where(eq(lessons.courseId, courseId))
      .orderBy(asc(lessons.position))
      .all(),
  ]);
  return secs.map((s) => ({
    id: s.id,
    title: s.title,
    position: s.position,
    lessons: less
      .filter((l) => l.sectionId === s.id)
      .map((l) => ({
        id: l.id,
        title: l.title,
        type: l.type,
        durationSeconds: l.durationSeconds,
        isPreview: l.isPreview,
        position: l.position,
        hasVideo: !!(l.videoUrl || l.videoKey),
      })),
  }));
}

export const stripCurriculum = (secs: Awaited<ReturnType<typeof getCurriculum>>): CurriculumSection[] =>
  secs.map((s) => ({ ...s, lessons: s.lessons.map(({ hasVideo: _h, ...l }) => l) }));

/** Ordered lesson ids across all sections. */
export function flatLessonIds(secs: { lessons: { id: string }[] }[]) {
  return secs.flatMap((s) => s.lessons.map((l) => l.id));
}

export async function recomputeCourseStats(db: DB, courseId: string) {
  const agg = await db
    .select({ n: count(), secs: sql<number>`coalesce(sum(${lessons.durationSeconds}),0)` })
    .from(lessons)
    .where(eq(lessons.courseId, courseId))
    .get();
  await db
    .update(courses)
    .set({ lessonsCount: agg?.n ?? 0, durationMinutes: Math.round((agg?.secs ?? 0) / 60), updatedAt: nowIso() })
    .where(eq(courses.id, courseId));
}

export async function recomputeRating(db: DB, courseId: string) {
  await db.run(sql`
    UPDATE courses SET
      rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = ${courseId}), 0),
      rating_count = (SELECT count(*) FROM reviews WHERE course_id = ${courseId})
    WHERE id = ${courseId}`);
}

export async function enroll(db: DB, userId: string, courseId: string, source: "purchase" | "subscription" | "free" | "admin") {
  const existing = await db
    .select({ id: enrollments.id })
    .from(enrollments)
    .where(and(eq(enrollments.userId, userId), eq(enrollments.courseId, courseId)))
    .get();
  if (existing) return false;
  await db.batch([
    db.insert(enrollments).values({ id: newId("enr"), userId, courseId, source, lastActivityAt: nowIso() }).onConflictDoNothing(),
    db.update(courses).set({ studentsCount: sql`${courses.studentsCount} + 1` }).where(eq(courses.id, courseId)),
  ]);
  return true;
}

/**
 * Recomputes an enrollment's progress from lesson_progress and issues a
 * certificate the first time every lesson is complete.
 */
export async function recomputeProgress(db: DB, userId: string, courseId: string) {
  const [total, done] = await Promise.all([
    db.select({ n: count() }).from(lessons).where(eq(lessons.courseId, courseId)).get(),
    db
      .select({ n: count() })
      .from(lessonProgress)
      .innerJoin(lessons, eq(lessons.id, lessonProgress.lessonId))
      .where(and(eq(lessonProgress.userId, userId), eq(lessonProgress.courseId, courseId), eq(lessonProgress.completed, true)))
      .get(),
  ]);
  const t = total?.n ?? 0;
  const d = done?.n ?? 0;
  const pct = t ? Math.round((d / t) * 100) : 0;
  const complete = t > 0 && d >= t;

  const enr = await db
    .select({ id: enrollments.id, completedAt: enrollments.completedAt })
    .from(enrollments)
    .where(and(eq(enrollments.userId, userId), eq(enrollments.courseId, courseId)))
    .get();
  if (!enr) return { progressPercent: pct, completed: complete, certificateId: null as string | null };

  await db
    .update(enrollments)
    .set({ progressPercent: pct, completedAt: complete ? (enr.completedAt ?? nowIso()) : null })
    .where(eq(enrollments.id, enr.id));

  let certificateId: string | null = null;
  if (complete) {
    const existing = await db
      .select({ id: certificates.id })
      .from(certificates)
      .where(and(eq(certificates.userId, userId), eq(certificates.courseId, courseId)))
      .get();
    certificateId = existing?.id ?? newId("LT", 12).toUpperCase().replace("_", "-");
    if (!existing) await db.insert(certificates).values({ id: certificateId, userId, courseId }).onConflictDoNothing();
  }
  return { progressPercent: pct, completed: complete, certificateId };
}
