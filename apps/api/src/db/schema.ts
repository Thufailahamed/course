import { sql } from "drizzle-orm";
import { index, integer, primaryKey, real, sqliteTable, text, uniqueIndex } from "drizzle-orm/sqlite-core";
import type { Level, LessonType, CourseStatus, OrderStatus, Role, QuizQuestion, Resource, Plan } from "@latent/shared";

const id = () => text("id").primaryKey();
const createdAt = () =>
  text("created_at")
    .notNull()
    .default(sql`(strftime('%Y-%m-%dT%H:%M:%fZ','now'))`);
const updatedAt = () =>
  text("updated_at")
    .notNull()
    .default(sql`(strftime('%Y-%m-%dT%H:%M:%fZ','now'))`);
const json = <T>(name: string) => text(name, { mode: "json" }).$type<T>();

export const users = sqliteTable(
  "users",
  {
    id: id(),
    email: text("email").notNull(),
    name: text("name").notNull(),
    passwordHash: text("password_hash").notNull(),
    role: text("role").$type<Role>().notNull().default("student"),
    avatarUrl: text("avatar_url"),
    headline: text("headline"),
    bio: text("bio"),
    stripeCustomerId: text("stripe_customer_id"),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (t) => [uniqueIndex("users_email_idx").on(t.email)],
);

export const sessions = sqliteTable(
  "sessions",
  {
    id: id(), // sha-256 of the session token
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    expiresAt: text("expires_at").notNull(),
    userAgent: text("user_agent"),
    createdAt: createdAt(),
  },
  (t) => [index("sessions_user_idx").on(t.userId)],
);

export const passwordResets = sqliteTable("password_resets", {
  id: id(), // sha-256 of token
  userId: text("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  expiresAt: text("expires_at").notNull(),
  createdAt: createdAt(),
});

export const categories = sqliteTable(
  "categories",
  {
    id: id(),
    slug: text("slug").notNull(),
    name: text("name").notNull(),
    description: text("description"),
    icon: text("icon"),
    sortOrder: integer("sort_order").notNull().default(0),
    createdAt: createdAt(),
  },
  (t) => [uniqueIndex("categories_slug_idx").on(t.slug)],
);

export const courses = sqliteTable(
  "courses",
  {
    id: id(),
    slug: text("slug").notNull(),
    title: text("title").notNull(),
    subtitle: text("subtitle"),
    description: text("description").notNull().default(""),
    categoryId: text("category_id").references(() => categories.id, { onDelete: "set null" }),
    instructorId: text("instructor_id")
      .notNull()
      .references(() => users.id),
    level: text("level").$type<Level>().notNull().default("all"),
    language: text("language").notNull().default("English"),
    priceCents: integer("price_cents").notNull().default(0),
    compareAtPriceCents: integer("compare_at_price_cents"),
    currency: text("currency").notNull().default("USD"),
    thumbnailKey: text("thumbnail_key"),
    previewVideoUrl: text("preview_video_url"),
    accent: integer("accent").notNull().default(250),
    status: text("status").$type<CourseStatus>().notNull().default("draft"),
    featured: integer("featured", { mode: "boolean" }).notNull().default(false),
    whatYouLearn: json<string[]>("what_you_learn").notNull().default(sql`'[]'`),
    requirements: json<string[]>("requirements").notNull().default(sql`'[]'`),
    targetAudience: json<string[]>("target_audience").notNull().default(sql`'[]'`),
    tags: json<string[]>("tags").notNull().default(sql`'[]'`),
    durationMinutes: integer("duration_minutes").notNull().default(0),
    lessonsCount: integer("lessons_count").notNull().default(0),
    ratingAvg: real("rating_avg").notNull().default(0),
    ratingCount: integer("rating_count").notNull().default(0),
    studentsCount: integer("students_count").notNull().default(0),
    publishedAt: text("published_at"),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (t) => [
    uniqueIndex("courses_slug_idx").on(t.slug),
    index("courses_status_idx").on(t.status),
    index("courses_category_idx").on(t.categoryId),
    index("courses_instructor_idx").on(t.instructorId),
  ],
);

export const sections = sqliteTable(
  "sections",
  {
    id: id(),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    position: integer("position").notNull().default(0),
    createdAt: createdAt(),
  },
  (t) => [index("sections_course_idx").on(t.courseId)],
);

export const lessons = sqliteTable(
  "lessons",
  {
    id: id(),
    sectionId: text("section_id")
      .notNull()
      .references(() => sections.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    type: text("type").$type<LessonType>().notNull().default("video"),
    position: integer("position").notNull().default(0),
    durationSeconds: integer("duration_seconds").notNull().default(0),
    videoUrl: text("video_url"),
    videoKey: text("video_key"),
    content: text("content"),
    isPreview: integer("is_preview", { mode: "boolean" }).notNull().default(false),
    quiz: json<QuizQuestion[]>("quiz").notNull().default(sql`'[]'`),
    resources: json<Resource[]>("resources").notNull().default(sql`'[]'`),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (t) => [index("lessons_section_idx").on(t.sectionId), index("lessons_course_idx").on(t.courseId)],
);

export const enrollments = sqliteTable(
  "enrollments",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    source: text("source").$type<"purchase" | "subscription" | "free" | "admin">().notNull(),
    progressPercent: integer("progress_percent").notNull().default(0),
    lastLessonId: text("last_lesson_id"),
    lastActivityAt: text("last_activity_at"),
    completedAt: text("completed_at"),
    createdAt: createdAt(),
  },
  (t) => [uniqueIndex("enrollments_user_course_idx").on(t.userId, t.courseId), index("enrollments_course_idx").on(t.courseId)],
);

export const lessonProgress = sqliteTable(
  "lesson_progress",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    lessonId: text("lesson_id")
      .notNull()
      .references(() => lessons.id, { onDelete: "cascade" }),
    courseId: text("course_id").notNull(),
    completed: integer("completed", { mode: "boolean" }).notNull().default(false),
    positionSeconds: integer("position_seconds").notNull().default(0),
    completedAt: text("completed_at"),
    updatedAt: updatedAt(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.lessonId] }), index("progress_user_course_idx").on(t.userId, t.courseId)],
);

/** Per-learner state of each challenge cell in an interactive lesson. */
export const exerciseProgress = sqliteTable(
  "exercise_progress",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    lessonId: text("lesson_id")
      .notNull()
      .references(() => lessons.id, { onDelete: "cascade" }),
    cellId: text("cell_id").notNull(),
    code: text("code"),
    passed: integer("passed", { mode: "boolean" }).notNull().default(false),
    attempts: integer("attempts").notNull().default(0),
    solvedAt: text("solved_at"),
    updatedAt: updatedAt(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.lessonId, t.cellId] })],
);

export const activity = sqliteTable(
  "activity",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    date: text("date").notNull(), // YYYY-MM-DD (UTC)
    lessons: integer("lessons").notNull().default(0),
    seconds: integer("seconds").notNull().default(0),
  },
  (t) => [primaryKey({ columns: [t.userId, t.date] })],
);

export const quizAttempts = sqliteTable(
  "quiz_attempts",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    lessonId: text("lesson_id")
      .notNull()
      .references(() => lessons.id, { onDelete: "cascade" }),
    score: integer("score").notNull(),
    total: integer("total").notNull(),
    answers: json<Record<string, number>>("answers").notNull(),
    createdAt: createdAt(),
  },
  (t) => [index("quiz_user_lesson_idx").on(t.userId, t.lessonId)],
);

export const reviews = sqliteTable(
  "reviews",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    rating: integer("rating").notNull(),
    title: text("title"),
    body: text("body").notNull(),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (t) => [uniqueIndex("reviews_user_course_idx").on(t.userId, t.courseId), index("reviews_course_idx").on(t.courseId)],
);

export const wishlist = sqliteTable(
  "wishlist",
  {
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.courseId] })],
);

export const orders = sqliteTable(
  "orders",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id),
    kind: text("kind").$type<"courses" | "subscription">().notNull().default("courses"),
    status: text("status").$type<OrderStatus>().notNull().default("pending"),
    subtotalCents: integer("subtotal_cents").notNull(),
    discountCents: integer("discount_cents").notNull().default(0),
    totalCents: integer("total_cents").notNull(),
    currency: text("currency").notNull().default("USD"),
    couponCode: text("coupon_code"),
    stripeSessionId: text("stripe_session_id"),
    stripePaymentIntent: text("stripe_payment_intent"),
    paidAt: text("paid_at"),
    createdAt: createdAt(),
  },
  (t) => [index("orders_user_idx").on(t.userId), index("orders_status_idx").on(t.status), index("orders_session_idx").on(t.stripeSessionId)],
);

export const orderItems = sqliteTable(
  "order_items",
  {
    id: id(),
    orderId: text("order_id")
      .notNull()
      .references(() => orders.id, { onDelete: "cascade" }),
    courseId: text("course_id").references(() => courses.id, { onDelete: "set null" }),
    title: text("title").notNull(),
    priceCents: integer("price_cents").notNull(),
  },
  (t) => [index("order_items_order_idx").on(t.orderId), index("order_items_course_idx").on(t.courseId)],
);

export const coupons = sqliteTable(
  "coupons",
  {
    id: id(),
    code: text("code").notNull(),
    percentOff: integer("percent_off"),
    amountOffCents: integer("amount_off_cents"),
    maxRedemptions: integer("max_redemptions"),
    redemptions: integer("redemptions").notNull().default(0),
    expiresAt: text("expires_at"),
    active: integer("active", { mode: "boolean" }).notNull().default(true),
    courseId: text("course_id").references(() => courses.id, { onDelete: "cascade" }),
    createdAt: createdAt(),
  },
  (t) => [uniqueIndex("coupons_code_idx").on(t.code)],
);

export const subscriptions = sqliteTable(
  "subscriptions",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    plan: text("plan").$type<Plan>().notNull(),
    status: text("status").notNull(), // active | trialing | past_due | canceled
    stripeSubscriptionId: text("stripe_subscription_id"),
    currentPeriodEnd: text("current_period_end"),
    cancelAtPeriodEnd: integer("cancel_at_period_end", { mode: "boolean" }).notNull().default(false),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (t) => [index("subscriptions_user_idx").on(t.userId), index("subscriptions_stripe_idx").on(t.stripeSubscriptionId)],
);

export const certificates = sqliteTable(
  "certificates",
  {
    id: id(), // public verification code
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    issuedAt: text("issued_at")
      .notNull()
      .default(sql`(strftime('%Y-%m-%dT%H:%M:%fZ','now'))`),
  },
  (t) => [uniqueIndex("certificates_user_course_idx").on(t.userId, t.courseId)],
);

export const notes = sqliteTable(
  "notes",
  {
    id: id(),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    lessonId: text("lesson_id")
      .notNull()
      .references(() => lessons.id, { onDelete: "cascade" }),
    body: text("body").notNull(),
    positionSeconds: integer("position_seconds"),
    createdAt: createdAt(),
  },
  (t) => [index("notes_user_course_idx").on(t.userId, t.courseId)],
);

export const discussions = sqliteTable(
  "discussions",
  {
    id: id(),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    lessonId: text("lesson_id").references(() => lessons.id, { onDelete: "set null" }),
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    parentId: text("parent_id"),
    title: text("title"),
    body: text("body").notNull(),
    createdAt: createdAt(),
  },
  (t) => [index("discussions_course_idx").on(t.courseId), index("discussions_parent_idx").on(t.parentId)],
);

export const paths = sqliteTable(
  "paths",
  {
    id: id(),
    slug: text("slug").notNull(),
    title: text("title").notNull(),
    subtitle: text("subtitle"),
    description: text("description"),
    accent: integer("accent").notNull().default(260),
    level: text("level").$type<Level>().notNull().default("all"),
    position: integer("position").notNull().default(0),
    createdAt: createdAt(),
  },
  (t) => [uniqueIndex("paths_slug_idx").on(t.slug)],
);

export const pathCourses = sqliteTable(
  "path_courses",
  {
    pathId: text("path_id")
      .notNull()
      .references(() => paths.id, { onDelete: "cascade" }),
    courseId: text("course_id")
      .notNull()
      .references(() => courses.id, { onDelete: "cascade" }),
    position: integer("position").notNull().default(0),
  },
  (t) => [primaryKey({ columns: [t.pathId, t.courseId] })],
);

export const leads = sqliteTable("leads", {
  id: id(),
  name: text("name").notNull(),
  email: text("email").notNull(),
  company: text("company"),
  teamSize: text("team_size"),
  message: text("message"),
  createdAt: createdAt(),
});
