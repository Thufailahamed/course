import { Hono } from "hono";
import { and, asc, count, desc, eq, gte, inArray, like, ne, or, sql, type SQL } from "drizzle-orm";
import type { CourseDetail, LearningPath, PricingConfig, Review } from "@latent/shared";
import { LEVELS, leadSchema, reviewSchema } from "@latent/shared";
import {
  categories,
  certificates,
  courses,
  enrollments,
  leads,
  pathCourses,
  paths,
  reviews,
  users,
  wishlist,
} from "../db/schema";
import type { AppEnv } from "../env";
import { hasActivePro, requireUser } from "../lib/auth";
import { cardQuery, getCards, getCurriculum, recomputeRating, stripCurriculum, toCard } from "../lib/courses";
import { newId } from "../lib/crypto";
import { body, fail, notFound, nowIso, paginated, parsePage } from "../lib/http";
import { rateLimit } from "../lib/ratelimit";
import { stripeEnabled } from "../lib/stripe";

const published = eq(courses.status, "published");

function sortOrder(sort: string | undefined) {
  switch (sort) {
    case "newest":
      return [desc(courses.publishedAt)];
    case "rating":
      return [desc(courses.ratingAvg), desc(courses.ratingCount)];
    case "price-asc":
      return [asc(courses.priceCents)];
    case "price-desc":
      return [desc(courses.priceCents)];
    default:
      return [desc(courses.featured), desc(courses.studentsCount)];
  }
}

async function pathSummaries(db: AppEnv["Variables"]["db"], where?: SQL) {
  const rows = await db
    .select({
      id: paths.id,
      slug: paths.slug,
      title: paths.title,
      subtitle: paths.subtitle,
      description: paths.description,
      accent: paths.accent,
      level: paths.level,
      coursesCount: sql<number>`count(${courses.id})`,
      durationMinutes: sql<number>`coalesce(sum(${courses.durationMinutes}),0)`,
    })
    .from(paths)
    .leftJoin(pathCourses, eq(pathCourses.pathId, paths.id))
    .leftJoin(courses, and(eq(courses.id, pathCourses.courseId), published))
    .where(where)
    .groupBy(paths.id)
    .orderBy(asc(paths.position))
    .all();
  return rows as LearningPath[];
}

export const catalog = new Hono<AppEnv>()
  .get("/config", (c) => {
    const config: PricingConfig = {
      currency: c.env.CURRENCY,
      proMonthlyCents: Number(c.env.PRO_MONTHLY_CENTS),
      proYearlyCents: Number(c.env.PRO_YEARLY_CENTS),
      paymentsMode: stripeEnabled(c.env) ? "stripe" : "demo",
    };
    return c.json(config);
  })

  .get("/categories", async (c) => {
    const rows = await c.var.db
      .select({
        id: categories.id,
        slug: categories.slug,
        name: categories.name,
        description: categories.description,
        icon: categories.icon,
        coursesCount: sql<number>`count(${courses.id})`,
      })
      .from(categories)
      .leftJoin(courses, and(eq(courses.categoryId, categories.id), published))
      .groupBy(categories.id)
      .orderBy(asc(categories.sortOrder), asc(categories.name))
      .all();
    return c.json({ items: rows });
  })

  .get("/courses", async (c) => {
    const q = c.req.query();
    const { page, pageSize, offset } = parsePage(q, 12, 48);
    const filters: (SQL | undefined)[] = [published];
    if (q.q?.trim()) {
      const term = `%${q.q.trim().toLowerCase()}%`;
      filters.push(
        or(
          like(sql`lower(${courses.title})`, term),
          like(sql`lower(coalesce(${courses.subtitle},''))`, term),
          like(sql`lower(${courses.tags})`, term),
          like(sql`lower(${users.name})`, term),
        ),
      );
    }
    if (q.category) filters.push(inArray(categories.slug, q.category.split(",")));
    if (q.level) {
      const lv = q.level.split(",").filter((l): l is (typeof LEVELS)[number] => (LEVELS as readonly string[]).includes(l));
      if (lv.length) filters.push(inArray(courses.level, lv));
    }
    if (q.price === "free") filters.push(eq(courses.priceCents, 0));
    if (q.price === "paid") filters.push(ne(courses.priceCents, 0));
    if (q.rating) filters.push(gte(courses.ratingAvg, Number(q.rating)));
    if (q.featured === "1") filters.push(eq(courses.featured, true));
    if (q.instructor) filters.push(eq(courses.instructorId, q.instructor));
    if (q.exclude) filters.push(ne(courses.id, q.exclude));
    if (q.duration === "short") filters.push(sql`${courses.durationMinutes} < 180`);
    if (q.duration === "medium") filters.push(sql`${courses.durationMinutes} between 180 and 600`);
    if (q.duration === "long") filters.push(sql`${courses.durationMinutes} > 600`);
    const where = and(...filters);

    const [rows, total] = await Promise.all([
      cardQuery(c.var.db)
        .where(where)
        .orderBy(...sortOrder(q.sort))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db
        .select({ n: count() })
        .from(courses)
        .innerJoin(users, eq(users.id, courses.instructorId))
        .leftJoin(categories, eq(categories.id, courses.categoryId))
        .where(where)
        .get(),
    ]);
    return c.json(paginated(rows.map(toCard), total?.n ?? 0, page, pageSize));
  })

  .get("/search/suggest", async (c) => {
    const term = c.req.query("q")?.trim().toLowerCase();
    if (!term) return c.json({ courses: [], categories: [] });
    const t = `%${term}%`;
    const [cs, cats] = await Promise.all([
      cardQuery(c.var.db)
        .where(and(published, or(like(sql`lower(${courses.title})`, t), like(sql`lower(${courses.tags})`, t))))
        .orderBy(desc(courses.studentsCount))
        .limit(6)
        .all(),
      c.var.db
        .select({ slug: categories.slug, name: categories.name })
        .from(categories)
        .where(like(sql`lower(${categories.name})`, t))
        .limit(3)
        .all(),
    ]);
    return c.json({ courses: cs.map(toCard), categories: cats });
  })

  .get("/courses/:slug", async (c) => {
    const db = c.var.db;
    const viewer = c.var.user;
    const staff = viewer && (viewer.role === "admin" || viewer.role === "instructor");
    const row = await db
      .select({ course: courses, instructor: users, categorySlug: categories.slug, categoryName: categories.name })
      .from(courses)
      .innerJoin(users, eq(users.id, courses.instructorId))
      .leftJoin(categories, eq(categories.id, courses.categoryId))
      .where(and(eq(courses.slug, c.req.param("slug")), staff ? undefined : published))
      .get();
    if (!row) notFound("Course");
    const { course, instructor } = row;

    const [curriculum, breakdownRows, instructorStats] = await Promise.all([
      getCurriculum(db, course.id),
      db.select({ rating: reviews.rating, n: count() }).from(reviews).where(eq(reviews.courseId, course.id)).groupBy(reviews.rating).all(),
      db
        .select({
          courses: count(),
          students: sql<number>`coalesce(sum(${courses.studentsCount}),0)`,
          rating: sql<number>`coalesce(avg(nullif(${courses.ratingAvg},0)),0)`,
        })
        .from(courses)
        .where(and(eq(courses.instructorId, instructor.id), published))
        .get(),
    ]);

    const ratingBreakdown = { "1": 0, "2": 0, "3": 0, "4": 0, "5": 0 } as CourseDetail["ratingBreakdown"];
    for (const b of breakdownRows) ratingBreakdown[String(b.rating) as "1"] = b.n;

    let viewerInfo: CourseDetail["viewer"] = null;
    if (viewer) {
      const [enr, wish, rev, pro] = await Promise.all([
        db
          .select({ p: enrollments.progressPercent })
          .from(enrollments)
          .where(and(eq(enrollments.userId, viewer.id), eq(enrollments.courseId, course.id)))
          .get(),
        db
          .select({ x: wishlist.courseId })
          .from(wishlist)
          .where(and(eq(wishlist.userId, viewer.id), eq(wishlist.courseId, course.id)))
          .get(),
        db
          .select({ id: reviews.id })
          .from(reviews)
          .where(and(eq(reviews.userId, viewer.id), eq(reviews.courseId, course.id)))
          .get(),
        hasActivePro(c, viewer.id),
      ]);
      viewerInfo = {
        enrolled: !!enr,
        inWishlist: !!wish,
        hasAccessViaPro: pro,
        progressPercent: enr?.p ?? 0,
        reviewed: !!rev,
      };
    }

    const card = toCard({
      ...course,
      categorySlug: row.categorySlug,
      categoryName: row.categoryName,
      instructorId: instructor.id,
      instructorName: instructor.name,
      instructorAvatar: instructor.avatarUrl,
      instructorHeadline: instructor.headline,
    });
    const detail: CourseDetail = {
      ...card,
      description: course.description,
      language: course.language,
      previewVideoUrl: course.previewVideoUrl,
      whatYouLearn: course.whatYouLearn,
      requirements: course.requirements,
      targetAudience: course.targetAudience,
      sections: stripCurriculum(curriculum),
      instructor: {
        id: instructor.id,
        name: instructor.name,
        avatarUrl: instructor.avatarUrl,
        headline: instructor.headline,
        bio: instructor.bio,
        coursesCount: instructorStats?.courses ?? 0,
        studentsCount: Number(instructorStats?.students ?? 0),
        ratingAvg: Math.round(Number(instructorStats?.rating ?? 0) * 10) / 10,
      },
      ratingBreakdown,
      publishedAt: course.publishedAt,
      viewer: viewerInfo,
    };
    return c.json(detail);
  })

  .get("/courses/:slug/reviews", async (c) => {
    const { page, pageSize, offset } = parsePage(c.req.query(), 10, 50);
    const course = await c.var.db.select({ id: courses.id }).from(courses).where(eq(courses.slug, c.req.param("slug"))).get();
    if (!course) notFound("Course");
    const rating = Number(c.req.query("rating")) || null;
    const where = and(eq(reviews.courseId, course.id), rating ? eq(reviews.rating, rating) : undefined);
    const [rows, total] = await Promise.all([
      c.var.db
        .select({ r: reviews, u: { id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline } })
        .from(reviews)
        .innerJoin(users, eq(users.id, reviews.userId))
        .where(where)
        .orderBy(desc(reviews.createdAt))
        .limit(pageSize)
        .offset(offset)
        .all(),
      c.var.db.select({ n: count() }).from(reviews).where(where).get(),
    ]);
    const items: Review[] = rows.map(({ r, u }) => ({ id: r.id, rating: r.rating, title: r.title, body: r.body, createdAt: r.createdAt, user: u }));
    return c.json(paginated(items, total?.n ?? 0, page, pageSize));
  })

  .post("/courses/:id/reviews", body(reviewSchema), async (c) => {
    const user = requireUser(c);
    const courseId = c.req.param("id");
    const db = c.var.db;
    const enr = await db
      .select({ id: enrollments.id })
      .from(enrollments)
      .where(and(eq(enrollments.userId, user.id), eq(enrollments.courseId, courseId)))
      .get();
    if (!enr) fail(403, "Enroll in this course to leave a review");
    const data = c.req.valid("json");
    await db
      .insert(reviews)
      .values({ id: newId("rev"), userId: user.id, courseId, rating: data.rating, title: data.title ?? null, body: data.body })
      .onConflictDoUpdate({
        target: [reviews.userId, reviews.courseId],
        set: { rating: data.rating, title: data.title ?? null, body: data.body, updatedAt: nowIso() },
      });
    await recomputeRating(db, courseId);
    return c.json({ ok: true }, 201);
  })

  .get("/instructors/:id", async (c) => {
    const u = await c.var.db.select().from(users).where(eq(users.id, c.req.param("id"))).get();
    if (!u || u.role === "student") notFound("Instructor");
    const rows = await cardQuery(c.var.db)
      .where(and(eq(courses.instructorId, u.id), published))
      .orderBy(desc(courses.studentsCount))
      .all();
    const cards = rows.map(toCard);
    const rated = cards.filter((x) => x.ratingCount);
    return c.json({
      instructor: {
        id: u.id,
        name: u.name,
        avatarUrl: u.avatarUrl,
        headline: u.headline,
        bio: u.bio,
        coursesCount: cards.length,
        studentsCount: cards.reduce((s, x) => s + x.studentsCount, 0),
        reviewsCount: cards.reduce((s, x) => s + x.ratingCount, 0),
        ratingAvg: rated.length ? Math.round((rated.reduce((s, x) => s + x.ratingAvg, 0) / rated.length) * 10) / 10 : 0,
      },
      courses: cards,
    });
  })

  .get("/instructors", async (c) => {
    const rows = await c.var.db
      .select({
        id: users.id,
        name: users.name,
        avatarUrl: users.avatarUrl,
        headline: users.headline,
        bio: users.bio,
        coursesCount: count(courses.id),
        studentsCount: sql<number>`coalesce(sum(${courses.studentsCount}),0)`,
        ratingAvg: sql<number>`round(coalesce(avg(nullif(${courses.ratingAvg},0)),0),1)`,
      })
      .from(users)
      .innerJoin(courses, and(eq(courses.instructorId, users.id), published))
      .groupBy(users.id)
      .orderBy(desc(sql`coalesce(sum(${courses.studentsCount}),0)`))
      .all();
    return c.json({ items: rows });
  })

  .get("/paths", async (c) => c.json({ items: await pathSummaries(c.var.db) }))

  .get("/paths/:slug", async (c) => {
    const [summary] = await pathSummaries(c.var.db, eq(paths.slug, c.req.param("slug")));
    if (!summary) notFound("Learning path");
    const ids = await c.var.db
      .select({ id: pathCourses.courseId })
      .from(pathCourses)
      .innerJoin(courses, and(eq(courses.id, pathCourses.courseId), published))
      .where(eq(pathCourses.pathId, summary.id))
      .orderBy(asc(pathCourses.position))
      .all();
    return c.json({ ...summary, courses: await getCards(c.var.db, ids.map((i) => i.id)) });
  })

  .get("/certificates/:id", async (c) => {
    const row = await c.var.db
      .select({
        id: certificates.id,
        issuedAt: certificates.issuedAt,
        userId: users.id,
        userName: users.name,
        course: courses,
      })
      .from(certificates)
      .innerJoin(users, eq(users.id, certificates.userId))
      .innerJoin(courses, eq(courses.id, certificates.courseId))
      .where(eq(certificates.id, c.req.param("id").toUpperCase()))
      .get();
    if (!row) notFound("Certificate");
    const instructor = await c.var.db.select({ name: users.name }).from(users).where(eq(users.id, row.course.instructorId)).get();
    return c.json({
      id: row.id,
      issuedAt: row.issuedAt,
      user: { id: row.userId, name: row.userName },
      course: {
        id: row.course.id,
        slug: row.course.slug,
        title: row.course.title,
        accent: row.course.accent,
        durationMinutes: row.course.durationMinutes,
        level: row.course.level,
        lessonsCount: row.course.lessonsCount,
      },
      instructor: { name: instructor?.name ?? "" },
    });
  })

  .get("/stats", async (c) => {
    const db = c.var.db;
    const [courseAgg, learners, reviewAgg] = await Promise.all([
      db
        .select({ n: count(), minutes: sql<number>`coalesce(sum(${courses.durationMinutes}),0)` })
        .from(courses)
        .where(published)
        .get(),
      db.select({ n: sql<number>`coalesce(sum(${courses.studentsCount}),0)` }).from(courses).where(published).get(),
      db.select({ n: count(), avg: sql<number>`coalesce(avg(${reviews.rating}),0)` }).from(reviews).get(),
    ]);
    return c.json({
      courses: courseAgg?.n ?? 0,
      hours: Math.round((courseAgg?.minutes ?? 0) / 60),
      learners: Number(learners?.n ?? 0),
      reviews: reviewAgg?.n ?? 0,
      avgRating: Math.round(Number(reviewAgg?.avg ?? 0) * 10) / 10,
    });
  })

  .get("/reviews/featured", async (c) => {
    const rows = await c.var.db
      .select({
        r: reviews,
        u: { id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline },
        course: { title: courses.title, slug: courses.slug },
      })
      .from(reviews)
      .innerJoin(users, eq(users.id, reviews.userId))
      .innerJoin(courses, eq(courses.id, reviews.courseId))
      .where(and(eq(reviews.rating, 5), sql`length(${reviews.body}) > 80`))
      .orderBy(desc(reviews.createdAt))
      .limit(9)
      .all();
    return c.json({
      items: rows.map(({ r, u, course }) => ({ id: r.id, rating: r.rating, title: r.title, body: r.body, createdAt: r.createdAt, user: u, course })),
    });
  })

  .post("/leads", body(leadSchema), async (c) => {
    await rateLimit(c, "leads", 5, 3600);
    const d = c.req.valid("json");
    await c.var.db.insert(leads).values({ id: newId("lead"), ...d, company: d.company ?? null, teamSize: d.teamSize ?? null, message: d.message ?? null });
    return c.json({ ok: true }, 201);
  });
