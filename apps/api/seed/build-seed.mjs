// Generates seed/seed.sql from seed/content.mjs. Deterministic (seeded RNG).
// Usage: node seed/build-seed.mjs && wrangler d1 execute latent-db --local --file=seed/seed.sql
import { pbkdf2Sync, randomBytes } from "node:crypto";
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import * as data from "./content.mjs";
import * as numpyCourse from "./courses/numpy/course.mjs";
import * as mathForMachineLearningCourse from "./courses/math-for-machine-learning/course.mjs";
import * as deepLearningFoundationsCourse from "./courses/deep-learning-foundations/course.mjs";
import * as transformersFromScratchCourse from "./courses/transformers-from-scratch/course.mjs";
import * as reinforcementLearningEssentialsCourse from "./courses/reinforcement-learning-essentials/course.mjs";
import * as machineLearningAZCourse from "./courses/machine-learning-a-z/course.mjs";
import * as pythonForDataScienceCourse from "./courses/python-for-data-science/course.mjs";
import * as pythonBasicsCourse from "./courses/python-basics/course.mjs";
import * as javascriptBasicsCourse from "./courses/javascript-basics/course.mjs";
import * as javascriptAdvancedCourse from "./courses/javascript-advanced/course.mjs";
import * as javaBasicsCourse from "./courses/java-basics/course.mjs";
import * as cBasicsCourse from "./courses/c-basics/course.mjs";
import * as cAdvancedCourse from "./courses/c-advanced/course.mjs";
import * as htmlCssBasicsCourse from "./courses/html-css-basics/course.mjs";
import * as htmlCssAdvancedCourse from "./courses/html-css-advanced/course.mjs";
import { CHALLENGE_KINDS, lessonCells } from "../../../packages/shared/src/interactive.ts";

const here = dirname(fileURLToPath(import.meta.url));

/* Interactive courses are authored as files: seed/courses/<name>/{course.mjs, lessons/*.md, quizzes/*.json}. */
const interactiveCourses = [
  ["numpy", numpyCourse],
  ["math-for-machine-learning", mathForMachineLearningCourse],
  ["deep-learning-foundations", deepLearningFoundationsCourse],
  ["transformers-from-scratch", transformersFromScratchCourse],
  ["reinforcement-learning-essentials", reinforcementLearningEssentialsCourse],
  ["machine-learning-a-z", machineLearningAZCourse],
  ["python-for-data-science", pythonForDataScienceCourse],
  ["python-basics", pythonBasicsCourse],
  ["javascript-basics", javascriptBasicsCourse],
  ["javascript-advanced", javascriptAdvancedCourse],
  ["java-basics", javaBasicsCourse],
  ["c-basics", cBasicsCourse],
  ["c-advanced", cAdvancedCourse],
  ["html-css-basics", htmlCssBasicsCourse],
  ["html-css-advanced", htmlCssAdvancedCourse],
].map(([dir, m]) => ({
  ...m.course,
  interactive: { key: dir.replace(/-/g, "_"), dir: join(here, "courses", dir), sections: m.sections, resources: m.resources ?? [] },
}));
const allCourses = [...data.courses, ...interactiveCourses];
const QUIZ_INTRO = "Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.";

let seed = 42;
const rand = () => ((seed = (seed * 1664525 + 1013904223) % 4294967296) / 4294967296);
const pick = (arr) => arr[Math.floor(rand() * arr.length)];
const int = (min, max) => Math.floor(rand() * (max - min + 1)) + min;

let idCounter = 0;
const id = (prefix) => `${prefix}_seed${(idCounter++).toString(36).padStart(6, "0")}`;

const b64url = (buf) => buf.toString("base64").replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
const hash = (password) => {
  const salt = randomBytes(16);
  const h = pbkdf2Sync(password, salt, 100000, 32, "sha256");
  return `pbkdf2$100000$${b64url(salt)}$${b64url(h)}`;
};

const q = (v) => {
  if (v === null || v === undefined) return "NULL";
  if (typeof v === "boolean") return v ? "1" : "0";
  if (typeof v === "number") return String(v);
  if (typeof v === "object") return `'${JSON.stringify(v).replace(/'/g, "''")}'`;
  return `'${String(v).replace(/'/g, "''")}'`;
};

const out = [];
function insert(table, rows) {
  if (!rows.length) return;
  const cols = Object.keys(rows[0]);
  // Up to 50 rows per statement, and well under D1's ~100 KB statement limit.
  const flush = (values) => values.length && out.push(`INSERT INTO ${table} (${cols.join(", ")}) VALUES\n${values.join(",\n")};`);
  let values = [];
  let size = 0;
  for (const r of rows) {
    const v = `(${cols.map((c) => q(r[c])).join(", ")})`;
    if (values.length && (values.length >= 50 || size + v.length > 80_000)) {
      flush(values);
      values = [];
      size = 0;
    }
    values.push(v);
    size += v.length;
  }
  flush(values);
}

const NOW = Date.now();
const daysAgo = (d, jitterHours = 0) => new Date(NOW - d * 864e5 - jitterHours * 3600e3).toISOString();

/* ── wipe ───────────────────────────────────────────────── */
for (const t of [
  "exercise_progress", "activity", "quiz_attempts", "notes", "discussions", "certificates", "lesson_progress", "enrollments", "reviews", "wishlist",
  "order_items", "orders", "coupons", "subscriptions", "path_courses", "paths", "lessons", "sections", "courses", "categories",
  "sessions", "password_resets", "leads", "users",
]) out.push(`DELETE FROM ${t};`);

/* ── users ──────────────────────────────────────────────── */
const users = [];
const admin = { id: "usr_admin", email: "admin@latent.dev", name: "Avery Admin", password_hash: hash("admin12345"), role: "admin", headline: "Head of Learning", bio: null, created_at: daysAgo(400) };
const student = { id: "usr_student", email: "student@latent.dev", name: "Jordan Rivera", password_hash: hash("student12345"), role: "student", headline: "Software Engineer", bio: "Backend engineer learning ML one lesson at a time.", created_at: daysAgo(120) };
users.push(admin, student);

const instructorIds = {};
const instructorHash = hash("instructor12345");
for (const ins of data.instructors) {
  const uid = `usr_${ins.key}`;
  instructorIds[ins.key] = uid;
  users.push({ id: uid, email: ins.email, name: ins.name, password_hash: instructorHash, role: "instructor", headline: ins.headline, bio: ins.bio, created_at: daysAgo(380) });
}

const learnerHash = hash("learner12345");
const learners = [];
for (let i = 0; i < 160; i++) {
  const name = `${pick(data.firstNames)} ${pick(data.lastNames)}`;
  const u = {
    id: id("usr"),
    email: `learner${i + 1}@example.com`,
    name,
    password_hash: learnerHash,
    role: "student",
    headline: pick(data.headlines),
    bio: null,
    created_at: daysAgo(int(0, 180), int(0, 23)),
  };
  learners.push(u);
  users.push(u);
}
insert("users", users.map((u) => ({ ...u, updated_at: u.created_at })));

/* ── categories ─────────────────────────────────────────── */
const catIds = {};
insert(
  "categories",
  data.categories.map(([slug, name, description, icon], i) => {
    catIds[slug] = `cat_${slug}`;
    return { id: `cat_${slug}`, slug, name, description, icon, sort_order: i };
  }),
);

/* ── courses, sections, lessons ─────────────────────────── */
const courseRows = [];
const sectionRows = [];
const lessonRows = [];
const courseLessons = {}; // courseId -> lesson ids in order
const courseBySlug = {};
let videoIdx = 0;

function articleFor(course, title, type) {
  if (data.articleBodies[title]) return data.articleBodies[title];
  const intro =
    type === "video"
      ? `In this lesson we cover **${title.toLowerCase()}** — a core building block of *${course.title}*. Watch the video, then use these notes to review.`
      : `This reading covers **${title.toLowerCase()}** in depth. Work through the example, then try the exercise at the end.`;
  return `${intro}

## Key ideas

- Why ${title.toLowerCase()} matters in practice, and where it shows up in real systems
- The core intuition, followed by the precise definition
- Common pitfalls and how to recognise them early

## Worked example

\`\`\`python
${course.snippet}
\`\`\`

## Try it yourself

1. Run the example above in a fresh notebook.
2. Change one hyperparameter or input and predict what will happen *before* running it.
3. Write two sentences explaining the result in your own words — then ask the AI tutor to check your reasoning.

> **Remember:** understanding beats memorisation. If something feels unclear, post it in the Q&A tab.`;
}

const lessonContent = {}; // lessonId -> content (interactive lessons)

function addInteractiveSections(c, courseId) {
  let totalSeconds = 0;
  c.interactive.sections.forEach((section, si) => {
    // Stable, course-scoped ids: re-seeding keeps learners' progress attached.
    const sectionId = `sec_${c.interactive.key}_${si + 1}`;
    sectionRows.push({ id: sectionId, course_id: courseId, title: section.title, position: si, created_at: daysAgo(120) });
    section.lessons.forEach((spec, li) => {
      const lessonId = `les_${c.interactive.key}_${si + 1}_${li + 1}`;
      courseLessons[courseId].push(lessonId);
      const isQuiz = !!spec.quiz;
      const content = isQuiz ? QUIZ_INTRO : readFileSync(join(c.interactive.dir, "lessons", spec.file), "utf8");
      if (!isQuiz) lessonContent[lessonId] = content;
      const durationSeconds = isQuiz ? 420 : spec.minutes * 60;
      totalSeconds += durationSeconds;
      lessonRows.push({
        id: lessonId,
        section_id: sectionId,
        course_id: courseId,
        title: spec.title,
        type: isQuiz ? "quiz" : "interactive",
        position: li,
        duration_seconds: durationSeconds,
        video_url: null,
        video_key: null,
        content,
        is_preview: !!spec.preview,
        quiz: isQuiz
          ? JSON.parse(readFileSync(join(c.interactive.dir, "quizzes", spec.quiz), "utf8")).map((q, qi) => ({ id: `q${qi + 1}`, prompt: q.prompt, options: q.options, answerIndex: q.answerIndex, explanation: q.explanation }))
          : [],
        resources: si === 0 && li === 0 ? c.interactive.resources : [],
        created_at: daysAgo(120),
        updated_at: daysAgo(4),
      });
    });
  });
  return { totalSeconds, lessonsCount: courseLessons[courseId].length };
}

for (const [ci, c] of allCourses.entries()) {
  const courseId = `crs_${c.slug.replace(/-/g, "_")}`;
  courseBySlug[c.slug] = courseId;
  courseLessons[courseId] = [];
  let totalSeconds = 0;
  let lessonsCount = 0;
  if (c.interactive) ({ totalSeconds, lessonsCount } = addInteractiveSections(c, courseId));
  else c.sections.forEach(([sTitle, specs], si) => {
    const sectionId = id("sec");
    sectionRows.push({ id: sectionId, course_id: courseId, title: sTitle, position: si, created_at: daysAgo(300) });
    specs.forEach((spec, li) => {
      const [kind, title, minutes] = spec.split("|");
      const type = kind === "v" ? "video" : kind === "a" ? "article" : "quiz";
      const lessonId = id("les");
      const durationSeconds = type === "quiz" ? 300 : Number(minutes) * 60 + int(0, 59);
      totalSeconds += durationSeconds;
      lessonsCount++;
      courseLessons[courseId].push(lessonId);
      const quiz =
        type === "quiz"
          ? c.quiz.map(([prompt, options, answerIndex, explanation], qi) => ({ id: `q${qi + 1}`, prompt, options, answerIndex, explanation }))
          : [];
      lessonRows.push({
        id: lessonId,
        section_id: sectionId,
        course_id: courseId,
        title,
        type,
        position: li,
        duration_seconds: durationSeconds,
        video_url: type === "video" ? data.sampleVideo(videoIdx++) : null,
        video_key: null,
        content: type === "quiz" ? `Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.` : articleFor(c, title, type),
        is_preview: si === 0 && li < 2,
        quiz,
        resources:
          li === 0
            ? [
                { title: "Lesson notebook (.ipynb)", url: "https://github.com/" },
                { title: "Slides (PDF)", url: "https://example.com/slides.pdf" },
              ]
            : [],
        created_at: daysAgo(300),
        updated_at: daysAgo(30),
      });
    });
  });
  const publishedDaysAgo = 40 + ci * 23;
  courseRows.push({
    id: courseId,
    slug: c.slug,
    title: c.title,
    subtitle: c.subtitle,
    description: c.description ?? `${c.subtitle}\n\n## About this course\n\n**${c.title}** is a hands-on program designed and taught by practitioners. Every module pairs a clear explanation with code you write yourself, so you leave with skills — not just notes.\n\n### How it works\n\n- **Short, focused lessons** with downloadable notebooks\n- **Checkpoints and quizzes** to lock in understanding\n- **An AI teaching assistant** that knows the course material and answers questions 24/7\n- **A verifiable certificate** when you complete every lesson\n\n### Why learn with us\n\nThe field moves quickly, so we update our courses continuously as tools and best practices evolve. You get lifetime access to every update.`,
    category_id: catIds[c.category],
    instructor_id: instructorIds[c.instructor],
    level: c.level,
    language: "English",
    price_cents: c.price,
    compare_at_price_cents: c.compareAt,
    currency: "USD",
    thumbnail_key: null,
    preview_video_url: c.interactive ? null : data.sampleVideo(ci),
    accent: c.accent,
    status: "published",
    featured: c.featured,
    what_you_learn: c.learn,
    requirements: c.requirements,
    target_audience: c.audience,
    tags: c.tags,
    duration_minutes: Math.round(totalSeconds / 60),
    lessons_count: lessonsCount,
    rating_avg: 0,
    rating_count: 0,
    students_count: c.students,
    published_at: daysAgo(publishedDaysAgo),
    created_at: daysAgo(publishedDaysAgo + 30),
    updated_at: daysAgo(int(1, 20)),
  });
}

// One draft course so the studio shows the draft workflow.
const draftId = "crs_draft_multimodal";
courseRows.push({
  ...courseRows[0],
  id: draftId,
  slug: "multimodal-ai-systems",
  title: "Multimodal AI Systems",
  subtitle: "Combine vision, audio and language models into a single product experience.",
  category_id: catIds["generative-ai"],
  instructor_id: instructorIds.sofia,
  level: "intermediate",
  price_cents: 0,
  compare_at_price_cents: null,
  accent: 185,
  status: "draft",
  featured: false,
  tags: ["Multimodal", "Vision-Language", "Audio"],
  duration_minutes: 0,
  lessons_count: 0,
  students_count: 0,
  published_at: null,
});
sectionRows.push({ id: id("sec"), course_id: draftId, title: "Getting started", position: 0, created_at: daysAgo(5) });

insert("courses", courseRows);
insert("sections", sectionRows);
insert("lessons", lessonRows);

/* ── paths ──────────────────────────────────────────────── */
const pathRows = [];
const pathCourseRows = [];
data.paths.forEach((p, i) => {
  const pid = `pth_${p.slug.replace(/-/g, "_")}`;
  pathRows.push({ id: pid, slug: p.slug, title: p.title, subtitle: p.subtitle, description: p.description, accent: p.accent, level: p.level, position: i, created_at: daysAgo(200) });
  p.courses.forEach((slug, position) => pathCourseRows.push({ path_id: pid, course_id: courseBySlug[slug], position }));
});
insert("paths", pathRows);
insert("path_courses", pathCourseRows);

/* ── coupons ────────────────────────────────────────────── */
insert("coupons", [
  { id: "cpn_launch", code: "LAUNCH30", percent_off: 30, amount_off_cents: null, max_redemptions: 1000, redemptions: 0, expires_at: null, active: true, course_id: null, created_at: daysAgo(60) },
  { id: "cpn_student", code: "STUDENT50", percent_off: 50, amount_off_cents: null, max_redemptions: null, redemptions: 0, expires_at: null, active: true, course_id: null, created_at: daysAgo(30) },
  { id: "cpn_llm", code: "LLM20", percent_off: null, amount_off_cents: 2000, max_redemptions: 200, redemptions: 0, expires_at: null, active: true, course_id: courseBySlug["llm-engineering"], created_at: daysAgo(10) },
]);

/* ── orders, enrollments, reviews ───────────────────────── */
const orders = [];
const orderItems = [];
const enrollments = [];
const reviews = [];
const enrolledPairs = new Set();
const couponUse = {};

function addEnrollment(userId, courseId, createdAt, source, progress = 0) {
  const key = `${userId}:${courseId}`;
  if (enrolledPairs.has(key)) return false;
  enrolledPairs.add(key);
  enrollments.push({
    id: id("enr"),
    user_id: userId,
    course_id: courseId,
    source,
    progress_percent: progress,
    last_lesson_id: null,
    last_activity_at: createdAt,
    completed_at: progress === 100 ? createdAt : null,
    created_at: createdAt,
  });
  return true;
}

for (const u of learners) {
  // Every course is free, so learners join by enrolling: the seed has no orders, coupons or revenue.
  const nEnrollments = int(1, 3);
  for (let k = 0; k < nEnrollments; k++) {
    // Skew enrollments toward recent days so the activity chart trends up.
    const age = Math.floor(Math.pow(rand(), 1.6) * 90);
    const course = pick(allCourses);
    addEnrollment(u.id, courseBySlug[course.slug], daysAgo(age, int(0, 23)), "free", pick([0, 8, 25, 40, 60, 85, 100]));
  }
  if (rand() < 0.5) addEnrollment(u.id, courseBySlug["python-for-data-science"], daysAgo(int(0, 120)), "free", pick([0, 30, 100]));
}

// Reviews from enrolled learners.
for (const e of enrollments) {
  if (rand() > 0.42) continue;
  const r = rand();
  const rating = r < 0.68 ? 5 : r < 0.92 ? 4 : r < 0.98 ? 3 : 2;
  const [title, body] = rating >= 4 ? pick(data.reviewTemplates.slice(0, 9)) : data.reviewTemplates[9];
  reviews.push({
    id: id("rev"),
    user_id: e.user_id,
    course_id: e.course_id,
    rating,
    title,
    body: rating < 4 ? "Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot." : body,
    created_at: e.created_at,
    updated_at: e.created_at,
  });
}

/* ── demo student: enrolled, mid-way, with a streak ─────── */
const demoCourses = [
  ["deep-learning-foundations", 0.45],
  ["llm-engineering", 0.15],
  ["python-for-data-science", 1],
  ["numpy-mastery", 0.1],
  ["python-basics", 0.3],
  ["java-basics", 0.12],
  ["html-css-basics", 0.18],
];
const progressRows = [];
const exerciseRows = [];
const certRows = [];
for (const [slug, frac] of demoCourses) {
  const cid = courseBySlug[slug];
  const lids = courseLessons[cid];
  const done = Math.round(lids.length * frac);
  addEnrollment(student.id, cid, daysAgo(60), "free", Math.round((done / lids.length) * 100));
  const enr = enrollments[enrollments.length - 1];
  enr.last_lesson_id = lids[Math.min(done, lids.length - 1)];
  enr.last_activity_at = daysAgo(slug === "deep-learning-foundations" ? 0 : 3);
  lids.slice(0, done).forEach((lid, i) => {
    progressRows.push({ user_id: student.id, lesson_id: lid, course_id: cid, completed: true, position_seconds: 0, completed_at: daysAgo(Math.max(0, 50 - i)), updated_at: daysAgo(Math.max(0, 50 - i)) });
    // Completed interactive lessons come with their challenges solved.
    for (const cell of lessonCells(lessonContent[lid] ?? "").filter((x) => CHALLENGE_KINDS.includes(x.kind)))
      exerciseRows.push({ user_id: student.id, lesson_id: lid, cell_id: cell.id, code: cell.solution, passed: true, attempts: 2, solved_at: daysAgo(Math.max(0, 50 - i)), updated_at: daysAgo(Math.max(0, 50 - i)) });
  });
  if (frac === 1) certRows.push({ id: "LT-DEMO7Q2K9X", user_id: student.id, course_id: cid, issued_at: daysAgo(20) });
}

const activityRows = [];
for (let d = 0; d < 150; d++) {
  // Recent unbroken streak, sparser further back.
  const active = d < 9 || rand() < 0.45;
  if (!active) continue;
  activityRows.push({ user_id: student.id, date: daysAgo(d).slice(0, 10), lessons: int(1, 4), seconds: int(900, 4800) });
}

insert("orders", orders);
insert("order_items", orderItems);
insert("enrollments", enrollments);
insert("reviews", reviews);
insert("lesson_progress", progressRows);
insert("exercise_progress", exerciseRows);
insert("certificates", certRows);
insert("activity", activityRows);
insert("wishlist", [
  { user_id: student.id, course_id: courseBySlug["transformers-from-scratch"], created_at: daysAgo(5) },
  { user_id: student.id, course_id: courseBySlug["building-ai-agents"], created_at: daysAgo(2) },
]);

/* ── a few Q&A threads ──────────────────────────────────── */
const dlf = courseBySlug["deep-learning-foundations"];
const dlfLessons = courseLessons[dlf];
const disc = [];
const q1 = id("dsc");
disc.push({ id: q1, course_id: dlf, lesson_id: dlfLessons[8], user_id: learners[0].id, parent_id: null, title: "Why does sigmoid cause vanishing gradients?", body: "In the backprop lesson the gradient through sigmoid gets tiny for large |z|. Is this why ReLU is preferred in hidden layers?", created_at: daysAgo(6) });
disc.push({ id: id("dsc"), course_id: dlf, lesson_id: dlfLessons[8], user_id: instructorIds.maya, parent_id: q1, title: null, body: "Exactly right! σ'(z) peaks at 0.25 and approaches 0 as |z| grows, so multiplying many of them shrinks gradients exponentially. ReLU's gradient is 1 for positive inputs, which keeps signal flowing. We revisit this in the normalization lesson.", created_at: daysAgo(5) });
const q2 = id("dsc");
disc.push({ id: q2, course_id: dlf, lesson_id: dlfLessons[12], user_id: learners[3].id, parent_id: null, title: "Loss stuck at 2.30 on CIFAR-10", body: "My loss stays at ~2.30 no matter what. I'm using AdamW with lr=0.1. Any ideas?", created_at: daysAgo(2) });
const q3 = id("dsc");
disc.push({ id: q3, course_id: dlf, lesson_id: null, user_id: learners[7].id, parent_id: null, title: "Recommended follow-up course?", body: "Loving this course! Should I take Transformers from Scratch next or LLM Engineering?", created_at: daysAgo(1) });
insert("discussions", disc);

insert("leads", [
  { id: id("lead"), name: "Priya Nair", email: "priya@acme-robotics.example", company: "Acme Robotics", team_size: "50-200", message: "We'd like to upskill our perception team in computer vision and MLOps.", created_at: daysAgo(3) },
  { id: id("lead"), name: "Tom Becker", email: "tom@northwind.example", company: "Northwind Analytics", team_size: "10-50", message: "Interested in an LLM engineering cohort for our data team.", created_at: daysAgo(9) },
]);

/* ── denormalized aggregates ────────────────────────────── */
out.push(`UPDATE courses SET
  rating_avg = coalesce((SELECT avg(rating) FROM reviews r WHERE r.course_id = courses.id), 0),
  rating_count = (SELECT count(*) FROM reviews r WHERE r.course_id = courses.id);`);
for (const [code, n] of Object.entries(couponUse)) out.push(`UPDATE coupons SET redemptions = ${n} WHERE code = '${code}';`);

writeFileSync(join(here, "seed.sql"), out.join("\n\n") + "\n");

// `--course <slug>`: SQL that adds or refreshes one course in an existing database without wiping it.
const onlyIdx = process.argv.indexOf("--course");
if (onlyIdx > 0) {
  const slug = process.argv[onlyIdx + 1];
  const cid = courseBySlug[slug];
  if (!cid) throw new Error(`Unknown course slug: ${slug}`);
  out.length = 0;
  const lessonIds = `(SELECT id FROM lessons WHERE course_id = '${cid}')`;
  for (const t of ["exercise_progress", "quiz_attempts", "notes", "lesson_progress"]) out.push(`DELETE FROM ${t} WHERE lesson_id IN ${lessonIds};`);
  for (const t of ["discussions", "certificates", "enrollments", "reviews", "wishlist", "path_courses", "coupons", "lessons", "sections"]) out.push(`DELETE FROM ${t} WHERE course_id = '${cid}';`);
  out.push(`UPDATE order_items SET course_id = NULL WHERE course_id = '${cid}';`);
  out.push(`DELETE FROM courses WHERE id = '${cid}';`);
  const mine = (rows) => rows.filter((r) => r.course_id === cid);
  // The course's category may be new to the target database.
  const courseRow = courseRows.find((r) => r.id === cid);
  data.categories.forEach(([catSlug, name, description, icon], i) => {
    if (catIds[catSlug] === courseRow.category_id)
      out.push(`INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES (${[catIds[catSlug], catSlug, name, description, icon, i].map(q).join(", ")});`);
  });
  insert("courses", [courseRow]);
  insert("sections", mine(sectionRows));
  insert("lessons", mine(lessonRows));
  insert("path_courses", mine(pathCourseRows));
  insert("enrollments", mine(enrollments).filter((e) => e.user_id === student.id).map((e) => ({ ...e, id: `enr_${cid}_demo` })));
  insert("lesson_progress", mine(progressRows));
  insert("exercise_progress", exerciseRows.filter((r) => courseLessons[cid].includes(r.lesson_id)));
  // Reviews only for reviewers that exist in the target database.
  for (const [i, review] of mine(reviews).entries()) {
    const r = { ...review, id: `rev_${cid}_${i + 1}` };
    const cols = Object.keys(r);
    out.push(`INSERT INTO reviews (${cols.join(", ")}) SELECT ${cols.map((c) => q(r[c])).join(", ")} WHERE EXISTS (SELECT 1 FROM users WHERE id = ${q(r.user_id)});`);
  }
  out.push(`UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = '${cid}'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = '${cid}') WHERE id = '${cid}';`);
  writeFileSync(join(here, `course-${slug}.sql`), out.join("\n\n") + "\n");
  console.log(`course-${slug}.sql: ${mine(lessonRows).length} lessons; other courses are untouched`);
}
console.log(
  `seed.sql: ${users.length} users, ${courseRows.length} courses, ${lessonRows.length} lessons, ${orders.length} orders, ${enrollments.length} enrollments, ${reviews.length} reviews`,
);
