import { Hono, type Context } from "hono";
import { and, asc, count, desc, eq, gte, inArray, isNull, like, lt, max, or, sql, type SQL } from "drizzle-orm";
import type { AdminCourse, AdminLesson, AdminOverview, AdminUser, Coupon } from "@latent/shared";
import {
  adminUserUpdateSchema,
  categoryUpsertSchema,
  couponUpsertSchema,
  courseUpsertSchema,
  lessonUpsertSchema,
  pathUpsertSchema,
  reorderSchema,
  sectionUpsertSchema,
  slugify,
} from "@latent/shared";
import {
  categories,
  coupons,
  courses,
  discussions,
  enrollments,
  leads,
  lessons,
  orderItems,
  orders,
  pathCourses,
  paths,
  reviews,
  sections,
  subscriptions,
  users,
} from "../db/schema";
import type { AppEnv } from "../env";
import { adminOnly, requireUser, staffOnly } from "../lib/auth";
import { cardQuery, enroll, getCurriculum, recomputeCourseStats, recomputeRating, toCard } from "../lib/courses";
import { newId } from "../lib/crypto";
import { body, fail, notFound, nowIso, paginated, parsePage } from "../lib/http";
import { refundOrder } from "./commerce";
import { loadOrders } from "./me";

type Ctx = Context<AppEnv>;

const courseRevenue = sql<number>`coalesce((select sum(oi.price_cents) from order_items oi join orders o on o.id = oi.order_id where oi.course_id = "courses"."id" and o.status = 'paid'),0)`;

const isAdmin = (c: Ctx) => c.var.user?.role === "admin";

/** Course filter for the signed-in staff member (admins see everything). */
const courseScope = (c: Ctx): SQL | undefined => (isAdmin(c) ? undefined : eq(courses.instructorId, requireUser(c).id));

async function ownedCourse(c: Ctx, courseId: string) {
  const course = await c.var.db.select().from(courses).where(eq(courses.id, courseId)).get();
  if (!course) notFound("Course");
  if (!isAdmin(c) && course.instructorId !== requireUser(c).id) fail(403, "You can only manage your own courses");
  return course;
}

async function ownedSection(c: Ctx, sectionId: string) {
  const s = await c.var.db.select().from(sections).where(eq(sections.id, sectionId)).get();
  if (!s) notFound("Section");
  await ownedCourse(c, s.courseId);
  return s;
}

async function ownedLesson(c: Ctx, lessonId: string) {
  const l = await c.var.db.select().from(lessons).where(eq(lessons.id, lessonId)).get();
  if (!l) notFound("Lesson");
  await ownedCourse(c, l.courseId);
  return l;
}

async function uniqueSlug(c: Ctx, table: typeof courses | typeof paths | typeof categories, base: string, ignoreId?: string) {
  let slug = base || "untitled";
  for (let i = 2; ; i++) {
    const hit = await c.var.db.select({ id: table.id }).from(table).where(eq(table.slug, slug)).get();
    if (!hit || hit.id === ignoreId) return slug;
    slug = `${base}-${i}`;
  }
}

const toAdminLesson = (l: typeof lessons.$inferSelect): AdminLesson => ({
  id: l.id,
  sectionId: l.sectionId,
  courseId: l.courseId,
  title: l.title,
  type: l.type,
  position: l.position,
  durationSeconds: l.durationSeconds,
  videoUrl: l.videoUrl,
  videoKey: l.videoKey,
  content: l.content,
  isPreview: l.isPreview,
  quiz: l.quiz,
  resources: l.resources,
});

const UPLOAD_KINDS = {
  image: { prefix: "images", types: ["image/png", "image/jpeg", "image/webp", "image/gif", "image/svg+xml"], max: 10 * 1024 * 1024 },
  video: { prefix: "videos", types: ["video/mp4", "video/webm", "video/quicktime"], max: 95 * 1024 * 1024 },
  file: { prefix: "files", types: [] as string[], max: 50 * 1024 * 1024 },
} as const;

function uploadKey(kind: keyof typeof UPLOAD_KINDS, filename: string) {
  const ext = filename.includes(".") ? filename.split(".").pop()!.toLowerCase().replace(/[^a-z0-9]/g, "") : "bin";
  const base = slugify(filename.replace(/\.[^.]+$/, "")) || "upload";
  return `${UPLOAD_KINDS[kind].prefix}/${new Date().toISOString().slice(0, 7)}/${newId()}-${base}.${ext}`;
}

export const admin = new Hono<AppEnv>()
  .use(staffOnly)

  /* ── Overview / analytics ─────────────────────────────── */

  .get("/overview", async (c) => {
    const db = c.var.db;
    const days = Math.min(365, Math.max(7, Number(c.req.query("days")) || 30));
    const now = Date.now();
    const start = new Date(now - days * 864e5).toISOString();
    const prevStart = new Date(now - 2 * days * 864e5).toISOString();
    const scope = courseScope(c);
    const admin = isAdmin(c);

    // Revenue: admins see order totals; instructors see their course line items.
    const revenueBetween = async (from: string, to?: string) => {
      const range = and(eq(orders.status, "paid"), gte(orders.paidAt, from), to ? lt(orders.paidAt, to) : undefined);
      if (admin) {
        return db.select({ cents: sql<number>`coalesce(sum(${orders.totalCents}),0)`, n: count() }).from(orders).where(range).get();
      }
      return db
        .select({ cents: sql<number>`coalesce(sum(${orderItems.priceCents}),0)`, n: sql<number>`count(distinct ${orders.id})` })
        .from(orderItems)
        .innerJoin(orders, eq(orders.id, orderItems.orderId))
        .innerJoin(courses, eq(courses.id, orderItems.courseId))
        .where(and(range, scope))
        .get();
    };
    const enrollBetween = (from: string, to?: string) =>
      db
        .select({ n: count() })
        .from(enrollments)
        .innerJoin(courses, eq(courses.id, enrollments.courseId))
        .where(and(gte(enrollments.createdAt, from), to ? lt(enrollments.createdAt, to) : undefined, scope))
        .get();
    const signupsBetween = (from: string, to?: string) =>
      db
        .select({ n: count() })
        .from(users)
        .where(and(gte(users.createdAt, from), to ? lt(users.createdAt, to) : undefined))
        .get();

    const [rev, revPrev, enr, enrPrev, su, suPrev, subs, students, pub, rating, revenueDaily, enrollDaily, signupDaily, top] = await Promise.all([
      revenueBetween(start),
      revenueBetween(prevStart, start),
      enrollBetween(start),
      enrollBetween(prevStart, start),
      signupsBetween(start),
      signupsBetween(prevStart, start),
      db.select({ n: count() }).from(subscriptions).where(inArray(subscriptions.status, ["active", "trialing"])).get(),
      db.select({ n: count() }).from(users).where(eq(users.role, "student")).get(),
      db.select({ n: count() }).from(courses).where(and(eq(courses.status, "published"), scope)).get(),
      db
        .select({ avg: sql<number>`coalesce(avg(${reviews.rating}),0)` })
        .from(reviews)
        .innerJoin(courses, eq(courses.id, reviews.courseId))
        .where(scope)
        .get(),
      admin
        ? db
            .select({ d: sql<string>`substr(${orders.paidAt},1,10)`, cents: sql<number>`sum(${orders.totalCents})` })
            .from(orders)
            .where(and(eq(orders.status, "paid"), gte(orders.paidAt, start)))
            .groupBy(sql`1`)
            .all()
        : db
            .select({ d: sql<string>`substr(${orders.paidAt},1,10)`, cents: sql<number>`sum(${orderItems.priceCents})` })
            .from(orderItems)
            .innerJoin(orders, eq(orders.id, orderItems.orderId))
            .innerJoin(courses, eq(courses.id, orderItems.courseId))
            .where(and(eq(orders.status, "paid"), gte(orders.paidAt, start), scope))
            .groupBy(sql`1`)
            .all(),
      db
        .select({ d: sql<string>`substr(${enrollments.createdAt},1,10)`, n: count() })
        .from(enrollments)
        .innerJoin(courses, eq(courses.id, enrollments.courseId))
        .where(and(gte(enrollments.createdAt, start), scope))
        .groupBy(sql`1`)
        .all(),
      db
        .select({ d: sql<string>`substr(${users.createdAt},1,10)`, n: count() })
        .from(users)
        .where(gte(users.createdAt, start))
        .groupBy(sql`1`)
        .all(),
      db
        .select({
          id: courses.id,
          title: courses.title,
          slug: courses.slug,
          accent: courses.accent,
          ratingAvg: courses.ratingAvg,
          enrollments: courses.studentsCount,
          revenueCents: courseRevenue,
        })
        .from(courses)
        .where(scope)
        .orderBy(desc(courseRevenue), desc(courses.studentsCount))
        .limit(6)
        .all(),
    ]);

    const rmap = new Map(revenueDaily.map((r) => [r.d, Number(r.cents)]));
    const emap = new Map(enrollDaily.map((r) => [r.d, r.n]));
    const smap = new Map(signupDaily.map((r) => [r.d, r.n]));
    const series: AdminOverview["series"] = [];
    for (let i = days - 1; i >= 0; i--) {
      const d = new Date(now - i * 864e5).toISOString().slice(0, 10);
      series.push({ date: d, revenueCents: rmap.get(d) ?? 0, enrollments: emap.get(d) ?? 0, signups: smap.get(d) ?? 0 });
    }

    const recentReviews = await db
      .select({
        r: reviews,
        u: { id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline },
        course: { title: courses.title, slug: courses.slug },
      })
      .from(reviews)
      .innerJoin(users, eq(users.id, reviews.userId))
      .innerJoin(courses, eq(courses.id, reviews.courseId))
      .where(scope)
      .orderBy(desc(reviews.createdAt))
      .limit(5)
      .all();

    const recentOrders = admin ? await loadOrders(c, eq(orders.status, "paid"), 8) : [];
    if (recentOrders.length) {
      const people = await db
        .select({ id: users.id, name: users.name, email: users.email, orderId: orders.id })
        .from(orders)
        .innerJoin(users, eq(users.id, orders.userId))
        .where(inArray(orders.id, recentOrders.map((o) => o.id)))
        .all();
      for (const o of recentOrders) {
        const p = people.find((x) => x.orderId === o.id);
        if (p) o.user = { id: p.id, name: p.name, email: p.email };
      }
    }

    const overview: AdminOverview = {
      kpis: {
        revenueCents: Number(rev?.cents ?? 0),
        revenuePrevCents: Number(revPrev?.cents ?? 0),
        orders: Number(rev?.n ?? 0),
        ordersPrev: Number(revPrev?.n ?? 0),
        newStudents: su?.n ?? 0,
        newStudentsPrev: suPrev?.n ?? 0,
        enrollments: enr?.n ?? 0,
        enrollmentsPrev: enrPrev?.n ?? 0,
        activeSubscriptions: subs?.n ?? 0,
        totalStudents: students?.n ?? 0,
        publishedCourses: pub?.n ?? 0,
        avgRating: Math.round(Number(rating?.avg ?? 0) * 10) / 10,
      },
      series,
      topCourses: top.map((t) => ({ ...t, revenueCents: Number(t.revenueCents), ratingAvg: Math.round(t.ratingAvg * 10) / 10 })),
      recentOrders,
      recentReviews: recentReviews.map(({ r, u, course }) => ({ id: r.id, rating: r.rating, title: r.title, body: r.body, createdAt: r.createdAt, user: u, course })),
    };
    return c.json(overview);
  })

  /* ── Courses ───────────────────────────────────────────── */

  .get("/courses", async (c) => {
    const q = c.req.query();
    const { page, pageSize, offset } = parsePage(q, 20, 100);
    const where = and(
      courseScope(c),
      q.status ? eq(courses.status, q.status as "draft") : undefined,
      q.q ? like(sql`lower(${courses.title})`, `%${q.q.toLowerCase()}%`) : undefined,
    );
    const [rows, total] = await Promise.all([
      c.var.db
        .select({ id: courses.id })
        .from(courses)
        .where(where)
        .orderBy(desc(courses.updatedAt))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db.select({ n: count() }).from(courses).where(where).get(),
    ]);
    const ids = rows.map((r) => r.id);
    const cards = ids.length ? await cardQuery(c.var.db).where(inArray(courses.id, ids)).all() : [];
    const meta = ids.length
      ? await c.var.db
          .select({
            id: courses.id,
            status: courses.status,
            revenueCents: courseRevenue,
          })
          .from(courses)
          .where(inArray(courses.id, ids))
          .all()
      : [];
    const items = ids
      .map((id) => {
        const card = cards.find((x) => x.id === id);
        const m = meta.find((x) => x.id === id);
        return card && m ? { ...toCard(card), status: m.status, revenueCents: Number(m.revenueCents) } : null;
      })
      .filter(Boolean);
    return c.json(paginated(items, total?.n ?? 0, page, pageSize));
  })

  .post("/courses", body(courseUpsertSchema), async (c) => {
    const user = requireUser(c);
    const d = c.req.valid("json");
    const id = newId("crs");
    const slug = await uniqueSlug(c, courses, d.slug ?? slugify(d.title));
    await c.var.db.insert(courses).values({
      id,
      slug,
      title: d.title,
      subtitle: d.subtitle ?? null,
      description: d.description ?? "",
      categoryId: d.categoryId ?? null,
      instructorId: user.id,
      level: d.level ?? "all",
      priceCents: d.priceCents ?? 0,
      accent: d.accent ?? Math.floor(Math.random() * 360),
      status: "draft",
    });
    // Start with an empty first section so the builder isn't blank.
    await c.var.db.insert(sections).values({ id: newId("sec"), courseId: id, title: "Getting started", position: 0 });
    return c.json({ id, slug }, 201);
  })

  .get("/courses/:id", async (c) => {
    const course = await ownedCourse(c, c.req.param("id"));
    const card = await cardQuery(c.var.db).where(eq(courses.id, course.id)).get();
    const rev = await c.var.db
      .select({ cents: sql<number>`coalesce(sum(${orderItems.priceCents}),0)` })
      .from(orderItems)
      .innerJoin(orders, eq(orders.id, orderItems.orderId))
      .where(and(eq(orderItems.courseId, course.id), eq(orders.status, "paid")))
      .get();
    const result: AdminCourse = {
      ...toCard(card!),
      status: course.status,
      revenueCents: Number(rev?.cents ?? 0),
      description: course.description,
      language: course.language,
      previewVideoUrl: course.previewVideoUrl,
      thumbnailKey: course.thumbnailKey,
      categoryId: course.categoryId,
      whatYouLearn: course.whatYouLearn,
      requirements: course.requirements,
      targetAudience: course.targetAudience,
      sections: await getCurriculum(c.var.db, course.id),
      createdAt: course.createdAt,
      publishedAt: course.publishedAt,
    };
    return c.json(result);
  })

  .patch("/courses/:id", body(courseUpsertSchema.partial()), async (c) => {
    const course = await ownedCourse(c, c.req.param("id"));
    const d = c.req.valid("json");
    const patch: Partial<typeof courses.$inferInsert> = { ...d, updatedAt: nowIso() };
    if (d.slug && d.slug !== course.slug) patch.slug = await uniqueSlug(c, courses, d.slug, course.id);
    if (d.featured !== undefined && !isAdmin(c)) delete patch.featured;
    if (d.status === "published" && course.status !== "published") {
      const n = await c.var.db.select({ n: count() }).from(lessons).where(eq(lessons.courseId, course.id)).get();
      if (!n?.n) fail(400, "Add at least one lesson before publishing", "no_lessons");
      patch.publishedAt = course.publishedAt ?? nowIso();
    }
    await c.var.db.update(courses).set(patch).where(eq(courses.id, course.id));
    return c.json({ ok: true, slug: patch.slug ?? course.slug });
  })

  .delete("/courses/:id", async (c) => {
    const course = await ownedCourse(c, c.req.param("id"));
    const sold = await c.var.db
      .select({ n: count() })
      .from(orderItems)
      .innerJoin(orders, eq(orders.id, orderItems.orderId))
      .where(and(eq(orderItems.courseId, course.id), eq(orders.status, "paid")))
      .get();
    if (sold?.n) fail(409, "This course has paid orders. Archive it instead so learners keep access.", "has_orders");
    await c.var.db.delete(courses).where(eq(courses.id, course.id));
    return c.json({ ok: true });
  })

  /* ── Curriculum ────────────────────────────────────────── */

  .post("/courses/:id/sections", body(sectionUpsertSchema), async (c) => {
    const course = await ownedCourse(c, c.req.param("id"));
    const last = await c.var.db.select({ p: max(sections.position) }).from(sections).where(eq(sections.courseId, course.id)).get();
    const id = newId("sec");
    await c.var.db.insert(sections).values({ id, courseId: course.id, title: c.req.valid("json").title, position: (last?.p ?? -1) + 1 });
    return c.json({ id }, 201);
  })

  .patch("/sections/:id", body(sectionUpsertSchema), async (c) => {
    const s = await ownedSection(c, c.req.param("id"));
    await c.var.db.update(sections).set({ title: c.req.valid("json").title }).where(eq(sections.id, s.id));
    return c.json({ ok: true });
  })

  .delete("/sections/:id", async (c) => {
    const s = await ownedSection(c, c.req.param("id"));
    await c.var.db.delete(sections).where(eq(sections.id, s.id));
    await recomputeCourseStats(c.var.db, s.courseId);
    return c.json({ ok: true });
  })

  .post("/courses/:id/reorder", body(reorderSchema), async (c) => {
    const course = await ownedCourse(c, c.req.param("id"));
    const db = c.var.db;
    const { sections: order } = c.req.valid("json");
    const stmts = order.flatMap((s, si) => [
      db.update(sections).set({ position: si }).where(and(eq(sections.id, s.id), eq(sections.courseId, course.id))),
      ...s.lessonIds.map((lid, li) =>
        db.update(lessons).set({ position: li, sectionId: s.id }).where(and(eq(lessons.id, lid), eq(lessons.courseId, course.id))),
      ),
    ]);
    if (stmts.length) await db.batch(stmts as [any, ...any[]]);
    return c.json({ ok: true });
  })

  .post("/sections/:id/lessons", body(lessonUpsertSchema), async (c) => {
    const s = await ownedSection(c, c.req.param("id"));
    const d = c.req.valid("json");
    const last = await c.var.db.select({ p: max(lessons.position) }).from(lessons).where(eq(lessons.sectionId, s.id)).get();
    const id = newId("les");
    await c.var.db.insert(lessons).values({
      id,
      sectionId: s.id,
      courseId: s.courseId,
      title: d.title,
      type: d.type ?? "video",
      position: (last?.p ?? -1) + 1,
      durationSeconds: d.durationSeconds ?? 0,
      videoUrl: d.videoUrl ?? null,
      videoKey: d.videoKey ?? null,
      content: d.content ?? null,
      isPreview: d.isPreview ?? false,
      quiz: d.quiz ?? [],
      resources: d.resources ?? [],
    });
    await recomputeCourseStats(c.var.db, s.courseId);
    return c.json({ id }, 201);
  })

  .get("/lessons/:id", async (c) => c.json(toAdminLesson(await ownedLesson(c, c.req.param("id")))))

  .patch("/lessons/:id", body(lessonUpsertSchema.partial()), async (c) => {
    const l = await ownedLesson(c, c.req.param("id"));
    const d = c.req.valid("json");
    if (d.quiz) for (const q of d.quiz) if (q.answerIndex >= q.options.length) fail(422, `Question "${q.prompt.slice(0, 40)}" has no valid correct answer`);
    await c.var.db.update(lessons).set({ ...d, updatedAt: nowIso() }).where(eq(lessons.id, l.id));
    if (d.durationSeconds !== undefined) await recomputeCourseStats(c.var.db, l.courseId);
    const fresh = await c.var.db.select().from(lessons).where(eq(lessons.id, l.id)).get();
    return c.json(toAdminLesson(fresh!));
  })

  .delete("/lessons/:id", async (c) => {
    const l = await ownedLesson(c, c.req.param("id"));
    await c.var.db.delete(lessons).where(eq(lessons.id, l.id));
    await recomputeCourseStats(c.var.db, l.courseId);
    return c.json({ ok: true });
  })

  /* ── Uploads to R2 ─────────────────────────────────────── */

  .post("/uploads", async (c) => {
    const form = await c.req.formData();
    const file = form.get("file");
    const kind = (form.get("kind") as keyof typeof UPLOAD_KINDS) || "image";
    const rule = UPLOAD_KINDS[kind];
    if (!rule) fail(400, "Unknown upload kind");
    if (!(file instanceof File)) fail(400, "No file uploaded");
    if (rule.types.length && !(rule.types as readonly string[]).includes(file.type)) fail(415, `Unsupported ${kind} type: ${file.type || "unknown"}`);
    if (file.size > rule.max) fail(413, `File is too large for a direct upload (max ${Math.round(rule.max / 1048576)} MB). Use multipart upload.`);
    const key = uploadKey(kind, file.name);
    await c.env.MEDIA.put(key, file.stream(), {
      httpMetadata: { contentType: file.type || "application/octet-stream", cacheControl: kind === "image" ? "public, max-age=31536000, immutable" : undefined },
      customMetadata: { uploadedBy: requireUser(c).id, originalName: file.name.slice(0, 200) },
    });
    return c.json({ key, url: `/api/media/${key}`, size: file.size, contentType: file.type }, 201);
  })

  .post("/uploads/multipart", async (c) => {
    const { filename, contentType, kind = "video" } = await c.req.json<{ filename: string; contentType: string; kind?: keyof typeof UPLOAD_KINDS }>();
    if (!UPLOAD_KINDS[kind]) fail(400, "Unknown upload kind");
    const key = uploadKey(kind, filename);
    const upload = await c.env.MEDIA.createMultipartUpload(key, { httpMetadata: { contentType } });
    return c.json({ key, uploadId: upload.uploadId });
  })

  .put("/uploads/multipart/:uploadId/:part", async (c) => {
    const key = c.req.query("key");
    if (!key || !c.req.raw.body) fail(400, "Missing key or body");
    const upload = c.env.MEDIA.resumeMultipartUpload(key, c.req.param("uploadId"));
    // Buffer the part: proxied bodies arrive without a known length, which R2 requires. Parts are ~10 MB.
    const part = await upload.uploadPart(Number(c.req.param("part")), await c.req.arrayBuffer());
    return c.json(part);
  })

  .post("/uploads/multipart/:uploadId/complete", async (c) => {
    const { key, parts } = await c.req.json<{ key: string; parts: R2UploadedPart[] }>();
    const upload = c.env.MEDIA.resumeMultipartUpload(key, c.req.param("uploadId"));
    const obj = await upload.complete(parts);
    return c.json({ key, url: `/api/media/${key}`, size: obj.size });
  })

  .delete("/uploads/multipart/:uploadId", async (c) => {
    const key = c.req.query("key");
    if (key) await c.env.MEDIA.resumeMultipartUpload(key, c.req.param("uploadId")).abort();
    return c.json({ ok: true });
  })

  /* ── Q&A inbox ─────────────────────────────────────────── */

  .get("/discussions", async (c) => {
    const unanswered = c.req.query("unanswered") === "1";
    const rows = await c.var.db
      .select({
        id: discussions.id,
        title: discussions.title,
        body: discussions.body,
        createdAt: discussions.createdAt,
        lessonId: discussions.lessonId,
        lessonTitle: lessons.title,
        course: { id: courses.id, title: courses.title, slug: courses.slug },
        user: { id: users.id, name: users.name, avatarUrl: users.avatarUrl },
        replies: sql<number>`(select count(*) from discussions r where r.parent_id = "discussions"."id")`,
      })
      .from(discussions)
      .innerJoin(courses, eq(courses.id, discussions.courseId))
      .innerJoin(users, eq(users.id, discussions.userId))
      .leftJoin(lessons, eq(lessons.id, discussions.lessonId))
      .where(
        and(
          isNull(discussions.parentId),
          courseScope(c),
          unanswered ? sql`not exists (select 1 from discussions r join users ru on ru.id = r.user_id where r.parent_id = "discussions"."id" and ru.role != 'student')` : undefined,
        ),
      )
      .orderBy(desc(discussions.createdAt))
      .limit(100)
      .all();
    return c.json({ items: rows });
  })

  /* ── Reviews moderation ────────────────────────────────── */

  .get("/reviews", async (c) => {
    const q = c.req.query();
    const { page, pageSize, offset } = parsePage(q, 20);
    const where = and(courseScope(c), q.rating ? eq(reviews.rating, Number(q.rating)) : undefined, q.courseId ? eq(reviews.courseId, q.courseId) : undefined);
    const [rows, total] = await Promise.all([
      c.var.db
        .select({
          r: reviews,
          u: { id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline },
          course: { id: courses.id, title: courses.title, slug: courses.slug },
        })
        .from(reviews)
        .innerJoin(users, eq(users.id, reviews.userId))
        .innerJoin(courses, eq(courses.id, reviews.courseId))
        .where(where)
        .orderBy(desc(reviews.createdAt))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db.select({ n: count() }).from(reviews).innerJoin(courses, eq(courses.id, reviews.courseId)).where(where).get(),
    ]);
    return c.json(
      paginated(
        rows.map(({ r, u, course }) => ({ id: r.id, rating: r.rating, title: r.title, body: r.body, createdAt: r.createdAt, user: u, course })),
        total?.n ?? 0,
        page,
        pageSize,
      ),
    );
  })

  .delete("/reviews/:id", async (c) => {
    const r = await c.var.db.select().from(reviews).where(eq(reviews.id, c.req.param("id"))).get();
    if (!r) notFound("Review");
    await ownedCourse(c, r.courseId);
    await c.var.db.delete(reviews).where(eq(reviews.id, r.id));
    await recomputeRating(c.var.db, r.courseId);
    return c.json({ ok: true });
  })

  /* ── Admin-only: users, orders, coupons, taxonomy ─────── */

  .get("/users", adminOnly, async (c) => {
    const q = c.req.query();
    const { page, pageSize, offset } = parsePage(q, 20);
    const where = and(
      q.role ? eq(users.role, q.role as "student") : undefined,
      q.q ? or(like(sql`lower(${users.name})`, `%${q.q.toLowerCase()}%`), like(users.email, `%${q.q.toLowerCase()}%`)) : undefined,
    );
    const [rows, total] = await Promise.all([
      c.var.db
        .select({
          id: users.id,
          name: users.name,
          email: users.email,
          role: users.role,
          avatarUrl: users.avatarUrl,
          createdAt: users.createdAt,
          enrollments: sql<number>`(select count(*) from enrollments e where e.user_id = "users"."id")`,
          spentCents: sql<number>`(select coalesce(sum(o.total_cents),0) from orders o where o.user_id = "users"."id" and o.status = 'paid')`,
          hasPro: sql<number>`exists (select 1 from subscriptions s where s.user_id = "users"."id" and s.status in ('active','trialing'))`,
        })
        .from(users)
        .where(where)
        .orderBy(desc(users.createdAt))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db.select({ n: count() }).from(users).where(where).get(),
    ]);
    const items: AdminUser[] = rows.map((r) => ({ ...r, spentCents: Number(r.spentCents), hasPro: !!r.hasPro }));
    return c.json(paginated(items, total?.n ?? 0, page, pageSize));
  })

  .get("/users/:id", adminOnly, async (c) => {
    const u = await c.var.db.select().from(users).where(eq(users.id, c.req.param("id"))).get();
    if (!u) notFound("User");
    const enr = await c.var.db
      .select({ courseId: enrollments.courseId, title: courses.title, slug: courses.slug, progressPercent: enrollments.progressPercent, source: enrollments.source, createdAt: enrollments.createdAt })
      .from(enrollments)
      .innerJoin(courses, eq(courses.id, enrollments.courseId))
      .where(eq(enrollments.userId, u.id))
      .orderBy(desc(enrollments.createdAt))
      .all();
    const sub = await c.var.db.select().from(subscriptions).where(eq(subscriptions.userId, u.id)).orderBy(desc(subscriptions.createdAt)).get();
    return c.json({
      user: { id: u.id, name: u.name, email: u.email, role: u.role, avatarUrl: u.avatarUrl, headline: u.headline, createdAt: u.createdAt },
      enrollments: enr,
      orders: await loadOrders(c, eq(orders.userId, u.id)),
      subscription: sub ?? null,
    });
  })

  .patch("/users/:id", adminOnly, body(adminUserUpdateSchema), async (c) => {
    const id = c.req.param("id");
    if (id === requireUser(c).id) fail(400, "You can't change your own role");
    await c.var.db.update(users).set({ role: c.req.valid("json").role, updatedAt: nowIso() }).where(eq(users.id, id));
    return c.json({ ok: true });
  })

  .post("/users/:id/enrollments", adminOnly, async (c) => {
    const { courseId } = await c.req.json<{ courseId: string }>();
    await enroll(c.var.db, c.req.param("id"), courseId, "admin");
    return c.json({ ok: true }, 201);
  })

  .delete("/users/:id/enrollments/:courseId", adminOnly, async (c) => {
    const removed = await c.var.db
      .delete(enrollments)
      .where(and(eq(enrollments.userId, c.req.param("id")), eq(enrollments.courseId, c.req.param("courseId"))))
      .returning({ id: enrollments.id });
    if (removed.length)
      await c.var.db
        .update(courses)
        .set({ studentsCount: sql`max(0, ${courses.studentsCount} - 1)` })
        .where(eq(courses.id, c.req.param("courseId")));
    return c.json({ ok: true });
  })

  .get("/orders", adminOnly, async (c) => {
    const q = c.req.query();
    const { page, pageSize, offset } = parsePage(q, 20);
    const where = and(
      q.status ? eq(orders.status, q.status as "paid") : undefined,
      q.q ? or(like(users.email, `%${q.q.toLowerCase()}%`), like(orders.id, `%${q.q}%`)) : undefined,
    );
    const [ids, total, sums] = await Promise.all([
      c.var.db
        .select({ id: orders.id })
        .from(orders)
        .innerJoin(users, eq(users.id, orders.userId))
        .where(where)
        .orderBy(desc(orders.createdAt))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db.select({ n: count() }).from(orders).innerJoin(users, eq(users.id, orders.userId)).where(where).get(),
      c.var.db
        .select({
          paid: sql<number>`coalesce(sum(case when ${orders.status}='paid' then ${orders.totalCents} end),0)`,
          refunded: sql<number>`coalesce(sum(case when ${orders.status}='refunded' then ${orders.totalCents} end),0)`,
        })
        .from(orders)
        .get(),
    ]);
    const list = ids.length ? await loadOrders(c, inArray(orders.id, ids.map((i) => i.id)), pageSize) : [];
    const people = ids.length
      ? await c.var.db
          .select({ orderId: orders.id, id: users.id, name: users.name, email: users.email })
          .from(orders)
          .innerJoin(users, eq(users.id, orders.userId))
          .where(inArray(orders.id, ids.map((i) => i.id)))
          .all()
      : [];
    for (const o of list) {
      const p = people.find((x) => x.orderId === o.id);
      if (p) o.user = { id: p.id, name: p.name, email: p.email };
    }
    return c.json({ ...paginated(list, total?.n ?? 0, page, pageSize), totals: { paidCents: Number(sums?.paid ?? 0), refundedCents: Number(sums?.refunded ?? 0) } });
  })

  .post("/orders/:id/refund", adminOnly, async (c) => {
    const ok = await refundOrder(c.env, c.var.db, c.req.param("id"));
    if (!ok) fail(400, "Only paid orders can be refunded");
    return c.json({ ok: true });
  })

  .get("/coupons", adminOnly, async (c) => {
    const rows = await c.var.db
      .select({ c: coupons, courseTitle: courses.title })
      .from(coupons)
      .leftJoin(courses, eq(courses.id, coupons.courseId))
      .orderBy(desc(coupons.createdAt))
      .all();
    const items: Coupon[] = rows.map(({ c: x, courseTitle }) => ({ ...x, courseTitle }));
    return c.json({ items });
  })

  .post("/coupons", adminOnly, body(couponUpsertSchema), async (c) => {
    const d = c.req.valid("json");
    const exists = await c.var.db.select({ id: coupons.id }).from(coupons).where(eq(coupons.code, d.code)).get();
    if (exists) fail(409, "A coupon with this code already exists");
    const id = newId("cpn");
    await c.var.db.insert(coupons).values({
      id,
      code: d.code,
      percentOff: d.percentOff ?? null,
      amountOffCents: d.amountOffCents ?? null,
      maxRedemptions: d.maxRedemptions ?? null,
      expiresAt: d.expiresAt ?? null,
      active: d.active ?? true,
      courseId: d.courseId ?? null,
    });
    return c.json({ id }, 201);
  })

  .patch("/coupons/:id", adminOnly, async (c) => {
    const d = await c.req.json<{ active?: boolean; maxRedemptions?: number | null; expiresAt?: string | null }>();
    await c.var.db
      .update(coupons)
      .set({
        ...(d.active !== undefined && { active: d.active }),
        ...(d.maxRedemptions !== undefined && { maxRedemptions: d.maxRedemptions }),
        ...(d.expiresAt !== undefined && { expiresAt: d.expiresAt }),
      })
      .where(eq(coupons.id, c.req.param("id")));
    return c.json({ ok: true });
  })

  .delete("/coupons/:id", adminOnly, async (c) => {
    await c.var.db.delete(coupons).where(eq(coupons.id, c.req.param("id")));
    return c.json({ ok: true });
  })

  .post("/categories", adminOnly, body(categoryUpsertSchema), async (c) => {
    const d = c.req.valid("json");
    const id = newId("cat");
    const last = await c.var.db.select({ p: max(categories.sortOrder) }).from(categories).get();
    await c.var.db.insert(categories).values({
      id,
      name: d.name,
      slug: await uniqueSlug(c, categories, d.slug ?? slugify(d.name)),
      description: d.description ?? null,
      icon: d.icon ?? null,
      sortOrder: (last?.p ?? 0) + 1,
    });
    return c.json({ id }, 201);
  })

  .patch("/categories/:id", adminOnly, body(categoryUpsertSchema.partial()), async (c) => {
    const d = c.req.valid("json");
    const id = c.req.param("id");
    await c.var.db
      .update(categories)
      .set({ ...d, ...(d.slug && { slug: await uniqueSlug(c, categories, d.slug, id) }) })
      .where(eq(categories.id, id));
    return c.json({ ok: true });
  })

  .delete("/categories/:id", adminOnly, async (c) => {
    await c.var.db.delete(categories).where(eq(categories.id, c.req.param("id")));
    return c.json({ ok: true });
  })

  .get("/paths", adminOnly, async (c) => {
    const [rows, links] = await Promise.all([
      c.var.db.select().from(paths).orderBy(asc(paths.position)).all(),
      c.var.db.select().from(pathCourses).orderBy(asc(pathCourses.position)).all(),
    ]);
    return c.json({ items: rows.map((p) => ({ ...p, courseIds: links.filter((l) => l.pathId === p.id).map((l) => l.courseId) })) });
  })

  .post("/paths", adminOnly, body(pathUpsertSchema), async (c) => {
    const d = c.req.valid("json");
    const id = newId("pth");
    const last = await c.var.db.select({ p: max(paths.position) }).from(paths).get();
    await c.var.db.insert(paths).values({
      id,
      slug: await uniqueSlug(c, paths, d.slug ?? slugify(d.title)),
      title: d.title,
      subtitle: d.subtitle ?? null,
      description: d.description ?? null,
      accent: d.accent ?? 260,
      level: d.level ?? "all",
      position: (last?.p ?? 0) + 1,
    });
    if (d.courseIds?.length) await c.var.db.insert(pathCourses).values(d.courseIds.map((courseId, position) => ({ pathId: id, courseId, position })));
    return c.json({ id }, 201);
  })

  .patch("/paths/:id", adminOnly, body(pathUpsertSchema.partial()), async (c) => {
    const id = c.req.param("id");
    const { courseIds, ...d } = c.req.valid("json");
    if (Object.keys(d).length)
      await c.var.db
        .update(paths)
        .set({ ...d, ...(d.slug && { slug: await uniqueSlug(c, paths, d.slug, id) }) })
        .where(eq(paths.id, id));
    if (courseIds) {
      await c.var.db.delete(pathCourses).where(eq(pathCourses.pathId, id));
      if (courseIds.length) await c.var.db.insert(pathCourses).values(courseIds.map((courseId, position) => ({ pathId: id, courseId, position })));
    }
    return c.json({ ok: true });
  })

  .delete("/paths/:id", adminOnly, async (c) => {
    await c.var.db.delete(paths).where(eq(paths.id, c.req.param("id")));
    return c.json({ ok: true });
  })

  .get("/leads", adminOnly, async (c) => {
    const items = await c.var.db.select().from(leads).orderBy(desc(leads.createdAt)).limit(500).all();
    return c.json({ items });
  });
