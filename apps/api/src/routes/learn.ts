import { Hono, type Context } from "hono";
import { and, asc, desc, eq, inArray, isNull, sql } from "drizzle-orm";
import type { Discussion, ExerciseState, LearnCourse, LessonContent, Note, QuizResult } from "@latent/shared";
import { aiChatSchema, challengeIds, discussionSchema, exerciseSubmitSchema, findCell, noteSchema, progressSchema, quizSubmitSchema, stripSolutions } from "@latent/shared";
import {
  activity,
  certificates,
  courses,
  discussions,
  enrollments,
  exerciseProgress,
  lessonProgress,
  lessons,
  notes,
  quizAttempts,
  users,
} from "../db/schema";
import type { AppEnv, UserRow } from "../env";
import { hasActivePro, requireUser } from "../lib/auth";
import { enroll, flatLessonIds, getCurriculum, recomputeProgress } from "../lib/courses";
import { newId } from "../lib/crypto";
import { body, fail, notFound, nowIso, today } from "../lib/http";
import { rateLimit } from "../lib/ratelimit";

type Ctx = Context<AppEnv>;
type CourseRow = typeof courses.$inferSelect;

const PASS_RATIO = 0.7;

function isStaffFor(user: UserRow | null, course: CourseRow) {
  return !!user && (user.role === "admin" || (user.role === "instructor" && course.instructorId === user.id));
}

/** Returns whether the viewer can open paid lessons; auto-enrolls Pro members. */
async function resolveAccess(c: Ctx, course: CourseRow, opts: { autoEnroll?: boolean } = {}) {
  const user = c.var.user;
  if (!user) return { user: null, enrolled: false, access: false };
  const db = c.var.db;
  const enr = await db
    .select({ id: enrollments.id })
    .from(enrollments)
    .where(and(eq(enrollments.userId, user.id), eq(enrollments.courseId, course.id)))
    .get();
  if (enr) return { user, enrolled: true, access: true };
  if (course.status === "published" && (await hasActivePro(c, user.id))) {
    if (opts.autoEnroll) await enroll(db, user.id, course.id, "subscription");
    return { user, enrolled: !!opts.autoEnroll, access: true };
  }
  if (course.priceCents === 0 && course.status === "published") {
    if (opts.autoEnroll) await enroll(db, user.id, course.id, "free");
    return { user, enrolled: !!opts.autoEnroll, access: true };
  }
  return { user, enrolled: false, access: isStaffFor(user, course) };
}

async function getCourse(c: Ctx, where: ReturnType<typeof eq>) {
  const course = await c.var.db.select().from(courses).where(where).get();
  if (!course) notFound("Course");
  return course;
}

async function requireCourseAccess(c: Ctx, courseId: string) {
  requireUser(c);
  const course = await getCourse(c, eq(courses.id, courseId));
  const a = await resolveAccess(c, course);
  if (!a.access) fail(403, "Enroll in this course to continue", "not_enrolled");
  return { course, user: a.user! };
}

async function bumpActivity(c: Ctx, userId: string, seconds: number, lessonsDelta: number) {
  if (!seconds && !lessonsDelta) return;
  await c.var.db
    .insert(activity)
    .values({ userId, date: today(), seconds, lessons: lessonsDelta })
    .onConflictDoUpdate({
      target: [activity.userId, activity.date],
      set: { seconds: sql`${activity.seconds} + ${seconds}`, lessons: sql`${activity.lessons} + ${lessonsDelta}` },
    });
}

/** Marks a lesson complete/position and keeps enrollment + streak data in sync. */
async function saveProgress(c: Ctx, user: UserRow, lesson: typeof lessons.$inferSelect, input: { positionSeconds?: number; completed?: boolean; watchedSeconds?: number }) {
  const db = c.var.db;
  const prev = await db
    .select()
    .from(lessonProgress)
    .where(and(eq(lessonProgress.userId, user.id), eq(lessonProgress.lessonId, lesson.id)))
    .get();
  const completed = input.completed ?? prev?.completed ?? false;
  const newlyCompleted = completed && !prev?.completed;
  const position = Math.round(input.positionSeconds ?? prev?.positionSeconds ?? 0);
  const ts = nowIso();
  await db
    .insert(lessonProgress)
    .values({ userId: user.id, lessonId: lesson.id, courseId: lesson.courseId, completed, positionSeconds: position, completedAt: completed ? ts : null, updatedAt: ts })
    .onConflictDoUpdate({
      target: [lessonProgress.userId, lessonProgress.lessonId],
      set: { completed, positionSeconds: position, completedAt: completed ? (prev?.completedAt ?? ts) : null, updatedAt: ts },
    });
  await db
    .update(enrollments)
    .set({ lastLessonId: lesson.id, lastActivityAt: ts })
    .where(and(eq(enrollments.userId, user.id), eq(enrollments.courseId, lesson.courseId)));
  await bumpActivity(c, user.id, Math.round(input.watchedSeconds ?? 0), newlyCompleted ? 1 : 0);

  let result = { progressPercent: -1, completed: false, certificateId: null as string | null };
  if (completed !== (prev?.completed ?? false)) result = await recomputeProgress(db, user.id, lesson.courseId);
  return { lessonCompleted: completed, positionSeconds: position, courseProgress: result.progressPercent, courseCompleted: result.completed, certificateId: result.certificateId };
}

function lessonVideoUrl(l: { id: string; videoKey: string | null; videoUrl: string | null }) {
  return l.videoKey ? `/api/stream/${l.id}` : l.videoUrl;
}

export const learn = new Hono<AppEnv>()
  .post("/courses/:id/enroll", async (c) => {
    const user = requireUser(c);
    const course = await getCourse(c, eq(courses.id, c.req.param("id")));
    const a = await resolveAccess(c, course, { autoEnroll: true });
    if (!a.enrolled) {
      if (isStaffFor(user, course)) {
        await enroll(c.var.db, user.id, course.id, "admin");
      } else fail(402, "This course requires a purchase or a Pro membership", "payment_required");
    }
    return c.json({ ok: true, slug: course.slug });
  })

  .get("/learn/:slug", async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    const course = await getCourse(c, eq(courses.slug, c.req.param("slug")));
    const a = await resolveAccess(c, course, { autoEnroll: true });
    if (!a.access) fail(403, "Enroll in this course to start learning", "not_enrolled");

    const [curriculum, progress, enr, instructor, cert] = await Promise.all([
      getCurriculum(db, course.id),
      db
        .select({ lessonId: lessonProgress.lessonId, completed: lessonProgress.completed, positionSeconds: lessonProgress.positionSeconds })
        .from(lessonProgress)
        .where(and(eq(lessonProgress.userId, user.id), eq(lessonProgress.courseId, course.id)))
        .all(),
      db.select().from(enrollments).where(and(eq(enrollments.userId, user.id), eq(enrollments.courseId, course.id))).get(),
      db.select({ id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline }).from(users).where(eq(users.id, course.instructorId)).get(),
      db
        .select({ id: certificates.id })
        .from(certificates)
        .where(and(eq(certificates.userId, user.id), eq(certificates.courseId, course.id)))
        .get(),
    ]);
    const pmap = new Map(progress.map((p) => [p.lessonId, p]));
    const sections = curriculum.map((s) => ({
      id: s.id,
      title: s.title,
      position: s.position,
      lessons: s.lessons.map(({ hasVideo: _h, ...l }) => {
        const p = pmap.get(l.id);
        return { ...l, progress: p ? { completed: p.completed, positionSeconds: p.positionSeconds } : null };
      }),
    }));
    const totalLessons = sections.reduce((n, s) => n + s.lessons.length, 0);
    const completedLessons = sections.reduce((n, s) => n + s.lessons.filter((l) => l.progress?.completed).length, 0);
    const result: LearnCourse = {
      id: course.id,
      slug: course.slug,
      title: course.title,
      accent: course.accent,
      instructor: instructor!,
      sections,
      totalLessons,
      completedLessons,
      progressPercent: totalLessons ? Math.round((completedLessons / totalLessons) * 100) : 0,
      lastLessonId: enr?.lastLessonId ?? null,
      certificateId: cert?.id ?? null,
      enrolled: !!enr,
    };
    return c.json(result);
  })

  .get("/learn/lessons/:id", async (c) => {
    const db = c.var.db;
    const lesson = await db.select().from(lessons).where(eq(lessons.id, c.req.param("id"))).get();
    if (!lesson) notFound("Lesson");
    const course = await getCourse(c, eq(courses.id, lesson.courseId));
    const a = await resolveAccess(c, course);
    if (!a.access && !(lesson.isPreview && course.status === "published")) fail(403, "Enroll in this course to watch this lesson", "not_enrolled");

    const ids = flatLessonIds(await getCurriculum(db, course.id));
    const idx = ids.indexOf(lesson.id);
    const interactive = lesson.type === "interactive";
    const [progress, best, exerciseRows] = a.user
      ? await Promise.all([
          db
            .select({ completed: lessonProgress.completed, positionSeconds: lessonProgress.positionSeconds })
            .from(lessonProgress)
            .where(and(eq(lessonProgress.userId, a.user.id), eq(lessonProgress.lessonId, lesson.id)))
            .get(),
          lesson.type === "quiz"
            ? db
                .select({ score: quizAttempts.score, total: quizAttempts.total })
                .from(quizAttempts)
                .where(and(eq(quizAttempts.userId, a.user.id), eq(quizAttempts.lessonId, lesson.id)))
                .orderBy(desc(quizAttempts.score))
                .get()
            : Promise.resolve(undefined),
          interactive
            ? db
                .select()
                .from(exerciseProgress)
                .where(and(eq(exerciseProgress.userId, a.user.id), eq(exerciseProgress.lessonId, lesson.id)))
                .all()
            : Promise.resolve([]),
        ])
      : [undefined, undefined, []];
    const exercises: Record<string, ExerciseState> | null = interactive
      ? Object.fromEntries(exerciseRows.map((r) => [r.cellId, { passed: r.passed, code: r.code, attempts: r.attempts, solvedAt: r.solvedAt }]))
      : null;
    // Learners fetch solutions on demand; staff see the full source.
    const content = interactive && lesson.content && !isStaffFor(a.user, course) ? stripSolutions(lesson.content) : lesson.content;

    const result: LessonContent = {
      id: lesson.id,
      courseId: lesson.courseId,
      title: lesson.title,
      type: lesson.type,
      durationSeconds: lesson.durationSeconds,
      content,
      videoUrl: lessonVideoUrl(lesson),
      quiz: lesson.type === "quiz" ? lesson.quiz.map(({ answerIndex: _a, explanation: _e, ...q }) => q) : null,
      resources: lesson.resources,
      progress: progress ?? null,
      prevLessonId: idx > 0 ? ids[idx - 1]! : null,
      nextLessonId: idx >= 0 && idx < ids.length - 1 ? ids[idx + 1]! : null,
      bestQuizScore: best ?? null,
      exercises,
    };
    return c.json(result);
  })

  .post("/learn/lessons/:id/progress", body(progressSchema), async (c) => {
    const user = requireUser(c);
    const lesson = await c.var.db.select().from(lessons).where(eq(lessons.id, c.req.param("id"))).get();
    if (!lesson) notFound("Lesson");
    await requireCourseAccess(c, lesson.courseId);
    return c.json(await saveProgress(c, user, lesson, c.req.valid("json")));
  })

  .post("/learn/lessons/:id/quiz", body(quizSubmitSchema), async (c) => {
    const user = requireUser(c);
    const db = c.var.db;
    const lesson = await db.select().from(lessons).where(eq(lessons.id, c.req.param("id"))).get();
    if (!lesson || lesson.type !== "quiz") notFound("Quiz");
    await requireCourseAccess(c, lesson.courseId);
    const { answers } = c.req.valid("json");
    const results = lesson.quiz.map((q) => ({
      questionId: q.id,
      correct: answers[q.id] === q.answerIndex,
      answerIndex: q.answerIndex,
      explanation: q.explanation,
    }));
    const score = results.filter((r) => r.correct).length;
    const total = results.length;
    const passed = total > 0 && score / total >= PASS_RATIO;
    await db.insert(quizAttempts).values({ id: newId("qa"), userId: user.id, lessonId: lesson.id, score, total, answers });
    const progress = passed ? await saveProgress(c, user, lesson, { completed: true }) : null;
    const res: QuizResult & { progress: typeof progress } = { score, total, passed, results, progress };
    return c.json(res);
  })

  /* ── Interactive challenges ─────────────────────────────── */

  .post("/learn/lessons/:id/exercises/:cellId", body(exerciseSubmitSchema), async (c) => {
    await rateLimit(c, "exercise", 600, 3600);
    const user = requireUser(c);
    const db = c.var.db;
    const lesson = await db.select().from(lessons).where(eq(lessons.id, c.req.param("id"))).get();
    if (!lesson || lesson.type !== "interactive") notFound("Lesson");
    await requireCourseAccess(c, lesson.courseId);
    const cellId = c.req.param("cellId");
    const ids = challengeIds(lesson.content ?? "");
    if (!ids.includes(cellId)) notFound("Challenge");
    const { code, passed } = c.req.valid("json");

    // Checks run in the learner's browser, so a pass is self-reported; once solved it stays solved.
    const prev = await db
      .select()
      .from(exerciseProgress)
      .where(and(eq(exerciseProgress.userId, user.id), eq(exerciseProgress.lessonId, lesson.id), eq(exerciseProgress.cellId, cellId)))
      .get();
    const ts = nowIso();
    const nowPassed = passed || !!prev?.passed;
    const state = { code, passed: nowPassed, attempts: (prev?.attempts ?? 0) + 1, solvedAt: prev?.solvedAt ?? (passed ? ts : null), updatedAt: ts };
    await db
      .insert(exerciseProgress)
      .values({ userId: user.id, lessonId: lesson.id, cellId, ...state })
      .onConflictDoUpdate({ target: [exerciseProgress.userId, exerciseProgress.lessonId, exerciseProgress.cellId], set: state });

    let progress = null;
    if (passed && !prev?.passed) {
      const solved = await db
        .select({ cellId: exerciseProgress.cellId })
        .from(exerciseProgress)
        .where(and(eq(exerciseProgress.userId, user.id), eq(exerciseProgress.lessonId, lesson.id), eq(exerciseProgress.passed, true)))
        .all();
      const done = new Set(solved.map((r) => r.cellId));
      if (ids.every((id) => done.has(id))) progress = await saveProgress(c, user, lesson, { completed: true });
    }
    const exercise: ExerciseState = { passed: state.passed, code: state.code, attempts: state.attempts, solvedAt: state.solvedAt };
    return c.json({ exercise, progress });
  })

  .get("/learn/lessons/:id/solutions/:cellId", async (c) => {
    const lesson = await c.var.db.select().from(lessons).where(eq(lessons.id, c.req.param("id"))).get();
    if (!lesson || lesson.type !== "interactive") notFound("Lesson");
    await requireCourseAccess(c, lesson.courseId);
    const cell = findCell(lesson.content ?? "", c.req.param("cellId"));
    if (!cell?.solution) notFound("Solution");
    return c.json({ solution: cell.solution });
  })

  /* ── Notes ─────────────────────────────────────────────── */

  .get("/learn/courses/:courseId/notes", async (c) => {
    const { user } = await requireCourseAccess(c, c.req.param("courseId"));
    const rows = await c.var.db
      .select({ n: notes, lessonTitle: lessons.title })
      .from(notes)
      .innerJoin(lessons, eq(lessons.id, notes.lessonId))
      .where(and(eq(notes.userId, user.id), eq(notes.courseId, c.req.param("courseId"))))
      .orderBy(desc(notes.createdAt))
      .all();
    const items: Note[] = rows.map(({ n, lessonTitle }) => ({
      id: n.id,
      lessonId: n.lessonId,
      lessonTitle,
      body: n.body,
      positionSeconds: n.positionSeconds,
      createdAt: n.createdAt,
    }));
    return c.json({ items });
  })

  .post("/learn/courses/:courseId/notes", body(noteSchema), async (c) => {
    const { user, course } = await requireCourseAccess(c, c.req.param("courseId"));
    const d = c.req.valid("json");
    const id = newId("note");
    await c.var.db.insert(notes).values({ id, userId: user.id, courseId: course.id, lessonId: d.lessonId, body: d.body, positionSeconds: d.positionSeconds ?? null });
    return c.json({ id }, 201);
  })

  .patch("/learn/notes/:id", body(noteSchema.pick({ body: true })), async (c) => {
    const user = requireUser(c);
    await c.var.db
      .update(notes)
      .set({ body: c.req.valid("json").body })
      .where(and(eq(notes.id, c.req.param("id")), eq(notes.userId, user.id)));
    return c.json({ ok: true });
  })

  .delete("/learn/notes/:id", async (c) => {
    const user = requireUser(c);
    await c.var.db.delete(notes).where(and(eq(notes.id, c.req.param("id")), eq(notes.userId, user.id)));
    return c.json({ ok: true });
  })

  /* ── Q&A ───────────────────────────────────────────────── */

  .get("/learn/courses/:courseId/discussions", async (c) => {
    await requireCourseAccess(c, c.req.param("courseId"));
    const lessonId = c.req.query("lessonId");
    const db = c.var.db;
    const author = { id: users.id, name: users.name, avatarUrl: users.avatarUrl, headline: users.headline, role: users.role };
    const roots = await db
      .select({ d: discussions, u: author, lessonTitle: lessons.title })
      .from(discussions)
      .innerJoin(users, eq(users.id, discussions.userId))
      .leftJoin(lessons, eq(lessons.id, discussions.lessonId))
      .where(and(eq(discussions.courseId, c.req.param("courseId")), isNull(discussions.parentId), lessonId ? eq(discussions.lessonId, lessonId) : undefined))
      .orderBy(desc(discussions.createdAt))
      .limit(100)
      .all();
    const replies = roots.length
      ? await db
          .select({ d: discussions, u: author })
          .from(discussions)
          .innerJoin(users, eq(users.id, discussions.userId))
          .where(inArray(discussions.parentId, roots.map((r) => r.d.id)))
          .orderBy(asc(discussions.createdAt))
          .all()
      : [];
    const items: Discussion[] = roots.map(({ d, u, lessonTitle }) => ({
      id: d.id,
      lessonId: d.lessonId,
      lessonTitle,
      title: d.title,
      body: d.body,
      createdAt: d.createdAt,
      user: u,
      replies: replies
        .filter((r) => r.d.parentId === d.id)
        .map((r) => ({ id: r.d.id, lessonId: r.d.lessonId, title: null, body: r.d.body, createdAt: r.d.createdAt, user: r.u })),
    }));
    return c.json({ items });
  })

  .post("/learn/courses/:courseId/discussions", body(discussionSchema), async (c) => {
    await rateLimit(c, "discuss", 30, 3600);
    const { user, course } = await requireCourseAccess(c, c.req.param("courseId"));
    const d = c.req.valid("json");
    const id = newId("dsc");
    await c.var.db.insert(discussions).values({
      id,
      courseId: course.id,
      lessonId: d.lessonId ?? null,
      userId: user.id,
      parentId: d.parentId ?? null,
      title: d.parentId ? null : (d.title ?? null),
      body: d.body,
    });
    return c.json({ id }, 201);
  })

  .delete("/learn/discussions/:id", async (c) => {
    const user = requireUser(c);
    const row = await c.var.db.select().from(discussions).where(eq(discussions.id, c.req.param("id"))).get();
    if (!row) notFound("Post");
    if (row.userId !== user.id && user.role === "student") fail(403, "You can only delete your own posts");
    await c.var.db.batch([
      c.var.db.delete(discussions).where(eq(discussions.parentId, row.id)),
      c.var.db.delete(discussions).where(eq(discussions.id, row.id)),
    ]);
    return c.json({ ok: true });
  })

  /* ── AI tutor (Workers AI, streamed as SSE) ─────────────── */

  .post("/learn/courses/:courseId/ai", body(aiChatSchema), async (c) => {
    await rateLimit(c, "ai", 40, 3600);
    const { course } = await requireCourseAccess(c, c.req.param("courseId"));
    const { lessonId, messages } = c.req.valid("json");
    const lesson = lessonId
      ? await c.var.db
          .select({ title: lessons.title, type: lessons.type, content: lessons.content })
          .from(lessons)
          .where(and(eq(lessons.id, lessonId), eq(lessons.courseId, course.id)))
          .get()
      : undefined;

    const system = [
      `You are Atlas, the AI teaching assistant for the course "${course.title}" on ${c.env.APP_NAME}, an online academy for AI and machine learning.`,
      "Explain concepts clearly with intuition first, then math or code when useful. Use Markdown, short paragraphs, and fenced code blocks (Python by default).",
      "If a learner asks for answers to a graded quiz, guide them toward the reasoning instead of giving the letter answer.",
      "In interactive lessons learners run code in the browser: Python (Pyodide, NumPy preinstalled), JavaScript (the browser's own engine), Java, C, or HTML & CSS (rendered in a sandboxed live preview), depending on the lesson. Match the language of the lesson's code blocks. When they share code and an error, explain the cause, point to the line, and nudge them toward the fix; for graded challenges give hints, not a full solution, unless they explicitly ask for it.",
      "Stay on topic: AI, ML, data, math and programming. Be concise and encouraging.",
      lesson ? `The learner is currently on the lesson "${lesson.title}". Lesson notes (may be truncated):\n${(lesson.type === "interactive" ? stripSolutions(lesson.content ?? "") : (lesson.content ?? "")).slice(0, 6000)}` : "",
    ]
      .filter(Boolean)
      .join("\n\n");

    const sse = { "content-type": "text/event-stream", "cache-control": "no-cache", "x-accel-buffering": "no" };
    if (!c.env.AI) {
      // Local dev without Workers AI: reply in the same SSE format so the UI still works.
      const text =
        "The AI tutor isn't connected in this environment. Run the API with `pnpm --filter @latent/api dev:ai` after `wrangler login` (or deploy to Cloudflare) to enable Workers AI.";
      return new Response(`data: ${JSON.stringify({ response: text })}\n\ndata: [DONE]\n\n`, { headers: sse });
    }
    try {
      const stream = (await c.env.AI.run(c.env.AI_MODEL as Parameters<Ai["run"]>[0], {
        messages: [{ role: "system", content: system }, ...messages],
        stream: true,
        max_tokens: 1024,
      } as never)) as unknown as ReadableStream;
      return new Response(stream, {
        headers: { "content-type": "text/event-stream", "cache-control": "no-cache", "x-accel-buffering": "no" },
      });
    } catch (err) {
      console.error("[ai]", err);
      fail(503, "The AI tutor is unavailable right now. Please try again in a moment.", "ai_unavailable");
    }
  })

  /* ── Video streaming from R2 with range support ─────────── */

  .get("/stream/:lessonId", async (c) => {
    const lesson = await c.var.db.select().from(lessons).where(eq(lessons.id, c.req.param("lessonId"))).get();
    if (!lesson?.videoKey) notFound("Video");
    const course = await getCourse(c, eq(courses.id, lesson.courseId));
    const a = await resolveAccess(c, course);
    if (!a.access && !lesson.isPreview) fail(403, "Enroll in this course to watch this video", "not_enrolled");

    const range = c.req.header("range");
    const obj = await c.env.MEDIA.get(lesson.videoKey, range ? { range: c.req.raw.headers } : undefined);
    if (!obj) notFound("Video");
    const headers = new Headers();
    obj.writeHttpMetadata(headers);
    headers.set("accept-ranges", "bytes");
    headers.set("cache-control", "private, max-age=3600");
    headers.set("etag", obj.httpEtag);
    if (range && obj.range && "offset" in obj.range) {
      const offset = obj.range.offset ?? 0;
      const length = obj.range.length ?? obj.size - offset;
      headers.set("content-range", `bytes ${offset}-${offset + length - 1}/${obj.size}`);
      headers.set("content-length", String(length));
      return new Response(obj.body, { status: 206, headers });
    }
    headers.set("content-length", String(obj.size));
    return new Response(obj.body, { headers });
  });
