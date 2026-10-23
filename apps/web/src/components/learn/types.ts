import type { LearnCourse, LearnLesson, LearnSection } from "@latent/shared";

/** Response of POST /learn/lessons/:id/progress. */
export interface ProgressResult {
  lessonCompleted: boolean;
  positionSeconds: number;
  /** -1 when the course progress wasn't recomputed (completion state unchanged). */
  courseProgress: number;
  courseCompleted: boolean;
  certificateId: string | null;
}

export interface PlayerApi {
  getTime: () => number;
  seek: (t: number) => void;
  pause: () => void;
}

export interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

export const learnKey = (slug: string) => ["learn", slug] as const;
export const lessonKey = (id: string) => ["lesson", id] as const;

export function findLesson(course: LearnCourse, lessonId: string | null | undefined): { lesson: LearnLesson; section: LearnSection; index: number } | null {
  if (!lessonId) return null;
  let index = 0;
  for (const section of course.sections)
    for (const lesson of section.lessons) {
      if (lesson.id === lessonId) return { lesson, section, index };
      index++;
    }
  return null;
}

export function firstIncompleteLesson(course: LearnCourse): string | null {
  const all = course.sections.flatMap((s) => s.lessons);
  return (all.find((l) => !l.progress?.completed) ?? all[0])?.id ?? null;
}
