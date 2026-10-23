"use client";

import Link from "next/link";
import { useState } from "react";
import { Check, ChevronDown, FileText, ListChecks, PlayCircle, SquareTerminal } from "lucide-react";
import type { LearnCourse, LessonType } from "@latent/shared";
import { cn, formatDuration, formatSeconds } from "@/lib/utils";

export const LESSON_ICON: Record<LessonType, typeof PlayCircle> = { video: PlayCircle, article: FileText, quiz: ListChecks, interactive: SquareTerminal };

export function Curriculum({ course, activeLessonId, onNavigate }: { course: LearnCourse; activeLessonId: string | null; onNavigate?: () => void }) {
  const [collapsed, setCollapsed] = useState<Set<string>>(new Set());
  const toggle = (id: string) =>
    setCollapsed((s) => {
      const next = new Set(s);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });

  let counter = 0;
  return (
    <div className="flex h-full flex-col bg-surface">
      {/* Header */}
      <div className="shrink-0 px-5 pb-5 pt-5">
        <p className="text-[11px] font-medium uppercase tracking-[0.12em] text-subtle-foreground">Course content</p>
        <div className="mt-3 flex items-end justify-between gap-3">
          <div className="flex items-baseline gap-1.5">
            <span className="text-[34px] font-bold leading-[0.9] tracking-[-0.04em] tabular-nums text-foreground">{course.progressPercent}%</span>
            <span className="text-[12.5px] text-subtle-foreground">complete</span>
          </div>
          <span className="pb-0.5 text-[12.5px] tabular-nums text-muted-foreground">
            <span className="font-medium text-foreground">{course.completedLessons}</span> of {course.totalLessons} lessons
          </span>
        </div>
        <div className="mt-4 h-3 overflow-hidden rounded-full bg-surface-3 p-[2px]">
          <div className="relative h-full min-w-2 rounded-full bg-go transition-[width] duration-700 ease-out" style={{ width: `${course.progressPercent}%` }}>
            <span className="absolute inset-x-1.5 top-[1px] h-[2px] rounded-full bg-white/40" />
          </div>
        </div>
      </div>

      {/* Sections and Lessons */}
      <div className="flex-1 overflow-y-auto border-t border-border pb-6">
        {course.sections.map((section, si) => {
          const done = section.lessons.filter((l) => l.progress?.completed).length;
          const secs = section.lessons.reduce((n, l) => n + l.durationSeconds, 0);
          const isCollapsed = collapsed.has(section.id);
          const allSectionDone = done === section.lessons.length && section.lessons.length > 0;

          return (
            <section key={section.id} className="border-b border-border last:border-b-0">
              <button
                onClick={() => toggle(section.id)}
                aria-expanded={!isCollapsed}
                className="group flex w-full items-start gap-3 px-5 pb-3 pt-4 text-left transition-colors hover:bg-surface-2/60"
              >
                <span
                  className={cn(
                    "flex size-8 shrink-0 items-center justify-center rounded-[10px] text-[12px] font-bold tabular-nums",
                    allSectionDone ? "bg-go-soft text-go-edge" : "bg-accent-soft text-accent",
                  )}
                >
                  {allSectionDone ? <Check className="size-4" strokeWidth={3} /> : si + 1}
                </span>
                <div className="min-w-0 flex-1">
                  <div className="text-[14px] font-bold leading-snug tracking-[-0.015em] text-foreground">{section.title}</div>
                  <div className="mt-1 flex items-center gap-1.5 text-[11.5px] tabular-nums text-subtle-foreground">
                    {allSectionDone ? (
                      <span className="font-semibold text-go-edge">Completed</span>
                    ) : (
                      <span>
                        {done}/{section.lessons.length} done
                      </span>
                    )}
                    <span className="text-border-strong">·</span>
                    <span>{formatDuration(Math.round(secs / 60))}</span>
                  </div>
                </div>
                <ChevronDown className={cn("mt-2 size-4 shrink-0 text-subtle-foreground transition-transform duration-200 group-hover:text-foreground", isCollapsed && "-rotate-90")} />
              </button>

              {!isCollapsed && (
                <ul className="relative px-2.5 pb-3">
                  {section.lessons.map((lesson, li) => {
                    counter++;
                    const Icon = LESSON_ICON[lesson.type];
                    const active = lesson.id === activeLessonId;
                    const completed = !!lesson.progress?.completed;
                    const last = li === section.lessons.length - 1;

                    return (
                      <li key={lesson.id} className="relative">
                        {/* Timeline rail */}
                        {!last && <span aria-hidden className={cn("absolute bottom-[-8px] left-[26px] top-[38px] w-[3px] rounded-full", completed ? "bg-go/45" : "bg-surface-3")} />}
                        <Link
                          href={`/learn/${course.slug}/${lesson.id}`}
                          onClick={onNavigate}
                          aria-current={active ? "page" : undefined}
                          className={cn(
                            "group relative flex items-start gap-3 rounded-2xl px-2.5 py-2 transition-colors duration-150",
                            active ? "bg-accent-soft" : "hover:bg-surface-2",
                          )}
                        >
                          <span className="relative z-[1] shrink-0">
                            {completed ? (
                              <span className="flex size-[30px] items-center justify-center rounded-full bg-go text-white shadow-[0_3px_0_0_var(--go-edge)]">
                                <Check className="size-4" strokeWidth={3.25} />
                              </span>
                            ) : (
                              <span
                                className={cn(
                                  "flex size-[30px] items-center justify-center rounded-full text-[12px] font-bold tabular-nums transition-transform duration-150 group-hover:-translate-y-px",
                                  active
                                    ? "bg-accent text-white shadow-[0_3px_0_0_var(--accent-edge),0_0_0_5px_var(--accent-soft)]"
                                    : "border-2 border-line-3d bg-surface text-subtle-foreground shadow-[0_3px_0_0_var(--line-3d)] group-hover:text-foreground",
                                )}
                              >
                                {counter}
                              </span>
                            )}
                          </span>

                          <span className="min-w-0 flex-1">
                            <span className={cn("block pt-[5px] text-[13.5px] leading-[1.35] tracking-[-0.01em]", active ? "font-bold text-foreground" : completed ? "text-muted-foreground" : "font-medium text-foreground/85 group-hover:text-foreground")}>
                              {lesson.title}
                            </span>
                            <span className="mt-1 flex items-center gap-1.5 text-[11.5px] tabular-nums text-subtle-foreground">
                              <Icon className={cn("size-3", active && "text-accent")} strokeWidth={2} />
                              <span>{lesson.type === "quiz" ? "Quiz" : lesson.type === "interactive" ? `${Math.max(1, Math.round(lesson.durationSeconds / 60))} min · Hands-on` : formatSeconds(lesson.durationSeconds)}</span>
                              {lesson.progress && !completed && lesson.type === "video" && lesson.progress.positionSeconds > 5 && (
                                <span className="font-medium text-accent">
                                  · {Math.min(99, Math.round((lesson.progress.positionSeconds / Math.max(1, lesson.durationSeconds)) * 100))}% watched
                                </span>
                              )}
                            </span>
                          </span>
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              )}
            </section>
          );
        })}
      </div>
    </div>
  );
}
