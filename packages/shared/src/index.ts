import { z } from "zod";

export * from "./interactive";
export * from "./java-harness";
export * from "./c-harness";
export * from "./html-harness";

/* ────────────────────────────────────────────────────────────
 * Enums
 * ──────────────────────────────────────────────────────────── */

export const ROLES = ["student", "instructor", "admin"] as const;
export type Role = (typeof ROLES)[number];

export const LEVELS = ["beginner", "intermediate", "advanced", "all"] as const;
export type Level = (typeof LEVELS)[number];

export const LESSON_TYPES = ["video", "article", "quiz", "interactive"] as const;
export type LessonType = (typeof LESSON_TYPES)[number];

export const COURSE_STATUSES = ["draft", "published", "archived"] as const;
export type CourseStatus = (typeof COURSE_STATUSES)[number];

export const ORDER_STATUSES = ["pending", "paid", "refunded", "failed"] as const;
export type OrderStatus = (typeof ORDER_STATUSES)[number];

export const PLANS = ["monthly", "yearly"] as const;
export type Plan = (typeof PLANS)[number];

export const SORTS = ["popular", "newest", "rating", "price-asc", "price-desc"] as const;
export type CourseSort = (typeof SORTS)[number];

export const LEVEL_LABELS: Record<Level, string> = {
  beginner: "Beginner",
  intermediate: "Intermediate",
  advanced: "Advanced",
  all: "All levels",
};

/* ────────────────────────────────────────────────────────────
 * Entities (API response shapes)
 * ──────────────────────────────────────────────────────────── */

export interface PublicUser {
  id: string;
  name: string;
  avatarUrl: string | null;
  headline: string | null;
}

export interface SessionUser extends PublicUser {
  email: string;
  role: Role;
  bio: string | null;
  createdAt: string;
  hasPro: boolean;
}

export interface Instructor extends PublicUser {
  bio: string | null;
  coursesCount?: number;
  studentsCount?: number;
  ratingAvg?: number;
}

export interface Category {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  icon: string | null;
  coursesCount?: number;
}

export interface CourseCard {
  id: string;
  slug: string;
  title: string;
  subtitle: string | null;
  level: Level;
  priceCents: number;
  compareAtPriceCents: number | null;
  currency: string;
  thumbnailUrl: string | null;
  accent: number;
  ratingAvg: number;
  ratingCount: number;
  studentsCount: number;
  lessonsCount: number;
  durationMinutes: number;
  featured: boolean;
  bestseller: boolean;
  tags: string[];
  category: { slug: string; name: string } | null;
  instructor: PublicUser;
  updatedAt: string;
}

export interface CurriculumLesson {
  id: string;
  title: string;
  type: LessonType;
  durationSeconds: number;
  isPreview: boolean;
  position: number;
}

export interface CurriculumSection {
  id: string;
  title: string;
  position: number;
  lessons: CurriculumLesson[];
}

export interface CourseDetail extends CourseCard {
  description: string;
  language: string;
  previewVideoUrl: string | null;
  whatYouLearn: string[];
  requirements: string[];
  targetAudience: string[];
  sections: CurriculumSection[];
  instructor: Instructor;
  ratingBreakdown: Record<"1" | "2" | "3" | "4" | "5", number>;
  publishedAt: string | null;
  viewer: {
    enrolled: boolean;
    inWishlist: boolean;
    hasAccessViaPro: boolean;
    progressPercent: number;
    reviewed: boolean;
  } | null;
}

export interface Review {
  id: string;
  rating: number;
  title: string | null;
  body: string;
  createdAt: string;
  user: PublicUser;
}

export interface QuizQuestion {
  id: string;
  prompt: string;
  options: string[];
  answerIndex: number;
  explanation?: string;
}

export interface Resource {
  title: string;
  url: string;
}

export interface LessonProgress {
  completed: boolean;
  positionSeconds: number;
}

export interface LearnLesson extends CurriculumLesson {
  progress: LessonProgress | null;
}

export interface LearnSection extends Omit<CurriculumSection, "lessons"> {
  lessons: LearnLesson[];
}

export interface LearnCourse {
  id: string;
  slug: string;
  title: string;
  accent: number;
  instructor: PublicUser;
  sections: LearnSection[];
  progressPercent: number;
  completedLessons: number;
  totalLessons: number;
  lastLessonId: string | null;
  certificateId: string | null;
  enrolled: boolean;
}

export interface LessonContent {
  id: string;
  courseId: string;
  title: string;
  type: LessonType;
  durationSeconds: number;
  content: string | null;
  /** Playable URL: external URL, or /api/stream/:lessonId for R2-hosted video. */
  videoUrl: string | null;
  /** Quiz questions; answerIndex/explanation are stripped for learners. */
  quiz: Omit<QuizQuestion, "answerIndex" | "explanation">[] | null;
  resources: Resource[];
  progress: LessonProgress | null;
  prevLessonId: string | null;
  nextLessonId: string | null;
  bestQuizScore: { score: number; total: number } | null;
  /** Interactive lessons: the learner's saved state per challenge cell. */
  exercises: Record<string, ExerciseState> | null;
}

export interface ExerciseState {
  passed: boolean;
  code: string | null;
  attempts: number;
  solvedAt: string | null;
}

export interface QuizResult {
  score: number;
  total: number;
  passed: boolean;
  results: { questionId: string; correct: boolean; answerIndex: number; explanation?: string }[];
}

export interface Note {
  id: string;
  lessonId: string;
  lessonTitle?: string;
  body: string;
  positionSeconds: number | null;
  createdAt: string;
}

export interface Discussion {
  id: string;
  lessonId: string | null;
  lessonTitle?: string | null;
  title: string | null;
  body: string;
  createdAt: string;
  user: PublicUser & { role: Role };
  replies: Omit<Discussion, "replies">[];
}

export interface Enrollment {
  courseId: string;
  enrolledAt: string;
  completedAt: string | null;
  progressPercent: number;
  lastLessonId: string | null;
  lastActivityAt: string | null;
  course: CourseCard;
}

export interface Certificate {
  id: string;
  issuedAt: string;
  user: { id: string; name: string };
  course: { id: string; slug: string; title: string; accent: number; durationMinutes: number; level: Level; lessonsCount: number };
  instructor: { name: string };
}

export interface OrderItem {
  courseId: string;
  title: string;
  priceCents: number;
  slug?: string;
}

export interface Order {
  id: string;
  status: OrderStatus;
  subtotalCents: number;
  discountCents: number;
  totalCents: number;
  currency: string;
  couponCode: string | null;
  createdAt: string;
  paidAt: string | null;
  kind: "courses" | "subscription";
  items: OrderItem[];
  user?: { id: string; name: string; email: string };
}

export interface Subscription {
  id: string;
  plan: Plan;
  status: string;
  currentPeriodEnd: string | null;
  cancelAtPeriodEnd: boolean;
}

export interface LearningStats {
  enrolled: number;
  completed: number;
  inProgress: number;
  certificates: number;
  lessonsCompleted: number;
  minutesLearned: number;
  currentStreak: number;
  longestStreak: number;
  /** Last 26 weeks of activity, oldest first. */
  activity: { date: string; lessons: number; minutes: number }[];
}

export interface LearningPath {
  id: string;
  slug: string;
  title: string;
  subtitle: string | null;
  description: string | null;
  accent: number;
  level: Level;
  coursesCount: number;
  durationMinutes: number;
  courses?: CourseCard[];
}

export interface Paginated<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  pageCount: number;
}

export interface PricingConfig {
  currency: string;
  proMonthlyCents: number;
  proYearlyCents: number;
  paymentsMode: "stripe" | "demo";
}

/* ── Admin ─────────────────────────────────────────────────── */

export interface AdminOverview {
  kpis: {
    revenueCents: number;
    revenuePrevCents: number;
    orders: number;
    ordersPrev: number;
    newStudents: number;
    newStudentsPrev: number;
    enrollments: number;
    enrollmentsPrev: number;
    activeSubscriptions: number;
    totalStudents: number;
    publishedCourses: number;
    avgRating: number;
  };
  series: { date: string; revenueCents: number; enrollments: number; signups: number }[];
  topCourses: { id: string; title: string; slug: string; accent: number; revenueCents: number; enrollments: number; ratingAvg: number }[];
  recentOrders: Order[];
  recentReviews: (Review & { course: { title: string; slug: string } })[];
}

export interface AdminCourse extends CourseCard {
  status: CourseStatus;
  revenueCents: number;
  description: string;
  language: string;
  previewVideoUrl: string | null;
  thumbnailKey: string | null;
  categoryId: string | null;
  whatYouLearn: string[];
  requirements: string[];
  targetAudience: string[];
  sections: (CurriculumSection & { lessons: (CurriculumLesson & { hasVideo: boolean })[] })[];
  createdAt: string;
  publishedAt: string | null;
}

export interface AdminLesson {
  id: string;
  sectionId: string;
  courseId: string;
  title: string;
  type: LessonType;
  position: number;
  durationSeconds: number;
  videoUrl: string | null;
  videoKey: string | null;
  content: string | null;
  isPreview: boolean;
  quiz: QuizQuestion[];
  resources: Resource[];
}

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: Role;
  avatarUrl: string | null;
  createdAt: string;
  enrollments: number;
  spentCents: number;
  hasPro: boolean;
}

export interface Coupon {
  id: string;
  code: string;
  percentOff: number | null;
  amountOffCents: number | null;
  maxRedemptions: number | null;
  redemptions: number;
  expiresAt: string | null;
  active: boolean;
  courseId: string | null;
  courseTitle?: string | null;
  createdAt: string;
}

export interface Lead {
  id: string;
  name: string;
  email: string;
  company: string | null;
  teamSize: string | null;
  message: string | null;
  createdAt: string;
}

/* ────────────────────────────────────────────────────────────
 * Request schemas (validated on the API, reused in forms)
 * ──────────────────────────────────────────────────────────── */

export const registerSchema = z.object({
  name: z.string().trim().min(2, "Please enter your full name").max(80),
  email: z.email("Enter a valid email").transform((e) => e.toLowerCase()),
  password: z.string().min(8, "Use at least 8 characters").max(128),
});

export const loginSchema = z.object({
  email: z.email("Enter a valid email").transform((e) => e.toLowerCase()),
  password: z.string().min(1, "Password is required"),
});

export const forgotPasswordSchema = z.object({ email: z.email() });

export const resetPasswordSchema = z.object({
  token: z.string().min(10),
  password: z.string().min(8).max(128),
});

export const changePasswordSchema = z.object({
  currentPassword: z.string().min(1),
  newPassword: z.string().min(8).max(128),
});

export const updateProfileSchema = z.object({
  name: z.string().trim().min(2).max(80).optional(),
  headline: z.string().trim().max(120).nullable().optional(),
  bio: z.string().trim().max(2000).nullable().optional(),
});

export const reviewSchema = z.object({
  rating: z.number().int().min(1).max(5),
  title: z.string().trim().max(120).nullable().optional(),
  body: z.string().trim().min(10, "Tell others a bit more (10+ characters)").max(4000),
});

export const progressSchema = z.object({
  positionSeconds: z.number().min(0).optional(),
  completed: z.boolean().optional(),
  watchedSeconds: z.number().min(0).max(3600).optional(),
});

export const quizSubmitSchema = z.object({
  answers: z.record(z.string(), z.number().int().min(0)),
});

export const exerciseSubmitSchema = z.object({
  code: z.string().max(20000),
  passed: z.boolean(),
});

export const noteSchema = z.object({
  lessonId: z.string(),
  body: z.string().trim().min(1).max(5000),
  positionSeconds: z.number().min(0).nullable().optional(),
});

export const discussionSchema = z.object({
  lessonId: z.string().nullable().optional(),
  parentId: z.string().nullable().optional(),
  title: z.string().trim().max(160).nullable().optional(),
  body: z.string().trim().min(2).max(5000),
});

export const aiChatSchema = z.object({
  lessonId: z.string().nullable().optional(),
  messages: z
    .array(z.object({ role: z.enum(["user", "assistant"]), content: z.string().max(4000) }))
    .min(1)
    .max(20),
});

export const checkoutSchema = z.object({
  courseIds: z.array(z.string()).min(1).max(50),
  couponCode: z.string().trim().max(40).nullable().optional(),
});

export const subscribeSchema = z.object({ plan: z.enum(PLANS) });

export const couponCheckSchema = z.object({
  code: z.string().trim().min(1).max(40),
  courseIds: z.array(z.string()).min(1),
});

export const leadSchema = z.object({
  name: z.string().trim().min(2).max(80),
  email: z.email(),
  company: z.string().trim().max(120).nullable().optional(),
  teamSize: z.string().trim().max(40).nullable().optional(),
  message: z.string().trim().max(4000).nullable().optional(),
});

/* ── Admin schemas ─────────────────────────────────────────── */

const stringList = z.array(z.string().trim().min(1).max(300)).max(30);

export const courseUpsertSchema = z.object({
  title: z.string().trim().min(3).max(140),
  slug: z
    .string()
    .trim()
    .regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/, "Lowercase letters, numbers and dashes")
    .max(120)
    .optional(),
  subtitle: z.string().trim().max(240).nullable().optional(),
  description: z.string().max(40000).optional(),
  categoryId: z.string().nullable().optional(),
  level: z.enum(LEVELS).optional(),
  language: z.string().max(40).optional(),
  priceCents: z.number().int().min(0).max(10_000_00).optional(),
  compareAtPriceCents: z.number().int().min(0).max(10_000_00).nullable().optional(),
  thumbnailKey: z.string().nullable().optional(),
  previewVideoUrl: z.string().max(1000).nullable().optional(),
  accent: z.number().int().min(0).max(360).optional(),
  featured: z.boolean().optional(),
  whatYouLearn: stringList.optional(),
  requirements: stringList.optional(),
  targetAudience: stringList.optional(),
  tags: z.array(z.string().trim().min(1).max(40)).max(12).optional(),
  status: z.enum(COURSE_STATUSES).optional(),
});

export const sectionUpsertSchema = z.object({ title: z.string().trim().min(1).max(160) });

export const quizQuestionSchema = z.object({
  id: z.string(),
  prompt: z.string().trim().min(1).max(1000),
  options: z.array(z.string().trim().min(1).max(500)).min(2).max(8),
  answerIndex: z.number().int().min(0),
  explanation: z.string().max(2000).optional(),
});

export const lessonUpsertSchema = z.object({
  title: z.string().trim().min(1).max(160),
  type: z.enum(LESSON_TYPES).optional(),
  durationSeconds: z.number().int().min(0).max(36000).optional(),
  videoUrl: z.string().max(1000).nullable().optional(),
  videoKey: z.string().max(500).nullable().optional(),
  content: z.string().max(100000).nullable().optional(),
  isPreview: z.boolean().optional(),
  quiz: z.array(quizQuestionSchema).max(50).optional(),
  resources: z.array(z.object({ title: z.string().min(1).max(200), url: z.string().min(1).max(1000) })).max(30).optional(),
});

export const reorderSchema = z.object({
  sections: z.array(z.object({ id: z.string(), lessonIds: z.array(z.string()) })),
});

export const couponUpsertSchema = z
  .object({
    code: z
      .string()
      .trim()
      .toUpperCase()
      .regex(/^[A-Z0-9_-]{3,40}$/, "3–40 chars: letters, numbers, - or _"),
    percentOff: z.number().int().min(1).max(100).nullable().optional(),
    amountOffCents: z.number().int().min(1).nullable().optional(),
    maxRedemptions: z.number().int().min(1).nullable().optional(),
    expiresAt: z.string().nullable().optional(),
    active: z.boolean().optional(),
    courseId: z.string().nullable().optional(),
  })
  .refine((c) => !!c.percentOff !== !!c.amountOffCents, {
    message: "Set either a percentage or a fixed amount",
    path: ["percentOff"],
  });

export const categoryUpsertSchema = z.object({
  name: z.string().trim().min(2).max(80),
  slug: z.string().trim().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/).max(80).optional(),
  description: z.string().trim().max(500).nullable().optional(),
  icon: z.string().trim().max(40).nullable().optional(),
});

export const pathUpsertSchema = z.object({
  title: z.string().trim().min(2).max(140),
  slug: z.string().trim().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/).max(120).optional(),
  subtitle: z.string().trim().max(240).nullable().optional(),
  description: z.string().trim().max(5000).nullable().optional(),
  accent: z.number().int().min(0).max(360).optional(),
  level: z.enum(LEVELS).optional(),
  courseIds: z.array(z.string()).max(30).optional(),
});

export const adminUserUpdateSchema = z.object({ role: z.enum(ROLES) });

/* ────────────────────────────────────────────────────────────
 * Helpers
 * ──────────────────────────────────────────────────────────── */

export function formatPrice(cents: number, currency = "USD"): string {
  if (cents === 0) return "Free";
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency,
    minimumFractionDigits: cents % 100 === 0 ? 0 : 2,
  }).format(cents / 100);
}

export function formatDuration(minutes: number): string {
  if (minutes < 60) return `${minutes}m`;
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return m ? `${h}h ${m}m` : `${h}h`;
}

export function formatSeconds(totalSeconds: number): string {
  const s = Math.max(0, Math.floor(totalSeconds));
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  const sec = s % 60;
  const pad = (n: number) => n.toString().padStart(2, "0");
  return h ? `${h}:${pad(m)}:${pad(sec)}` : `${m}:${pad(sec)}`;
}

export function slugify(input: string): string {
  return input
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 100);
}
