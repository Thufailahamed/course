import { notFound, redirect } from "next/navigation";
import type { LearnCourse } from "@latent/shared";
import { firstIncompleteLesson } from "@/components/learn/types";
import { serverApi, ServerApiError } from "@/lib/server";

// /learn/:slug → resume where the learner left off (or the first incomplete lesson).
export default async function LearnIndex({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  let course: LearnCourse;
  try {
    course = await serverApi<LearnCourse>(`/learn/${slug}`);
  } catch (e) {
    const status = e instanceof ServerApiError ? e.status : 500;
    if (status === 401) redirect(`/login?next=${encodeURIComponent(`/learn/${slug}`)}`);
    if (status === 403) redirect(`/courses/${slug}`);
    if (status === 404) notFound();
    throw e;
  }
  const all = course.sections.flatMap((s) => s.lessons);
  const last = all.find((l) => l.id === course.lastLessonId);
  const target = last && !(last.progress?.completed && course.progressPercent < 100) ? last.id : firstIncompleteLesson(course);
  if (!target) redirect(`/courses/${slug}`);
  redirect(`/learn/${slug}/${target}`);
}
