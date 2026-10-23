"use client";

import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Dialog as D } from "radix-ui";
import { Award, ChevronLeft, ListTree, PanelLeftClose, PanelLeftOpen, Sparkles } from "lucide-react";
import type { LearnCourse } from "@latent/shared";
import { LogoMark } from "@/components/logo";
import { Button } from "@/components/ui/button";
import { ProgressRing } from "@/components/ui/display";
import { Dialog, SheetContent, Tooltip } from "@/components/ui/primitives";
import { PageSpinner } from "@/components/ui/spinner";
import { api, ApiError } from "@/lib/api";
import { qk } from "@/lib/hooks";
import { cn } from "@/lib/utils";
import { AiTutor } from "./ai-tutor";
import { CelebrationDialog } from "./celebration";
import { Curriculum } from "./curriculum";
import { LearnContext, type LearnContextValue } from "./learn-context";
import { findLesson, learnKey, type ChatMessage, type PlayerApi, type ProgressResult } from "./types";

export function LearnShell({ slug, children }: { slug: string; children: React.ReactNode }) {
  const router = useRouter();
  const qc = useQueryClient();
  const params = useParams<{ lessonId?: string }>();
  const activeLessonId = params.lessonId ?? null;

  const { data: course, error } = useQuery({
    queryKey: learnKey(slug),
    queryFn: () => api.get<LearnCourse>(`/learn/${slug}`),
  });

  useEffect(() => {
    if (!(error instanceof ApiError)) return;
    if (error.status === 401) router.replace(`/login?next=${encodeURIComponent(location.pathname)}`);
    else if (error.status === 403 || error.status === 404) router.replace(`/courses/${slug}`);
  }, [error, router, slug]);

  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [mobileCurriculum, setMobileCurriculum] = useState(false);
  const [tutorOpen, setTutorOpen] = useState(false);
  const [pendingPrompt, setPendingPrompt] = useState<string | null>(null);
  const [chats, setChats] = useState<Record<string, ChatMessage[]>>({});
  const [celebrate, setCelebrate] = useState<string | null>(null);
  const narrow = useNarrow();
  const player = useRef<PlayerApi | null>(null);
  const courseRef = useRef(course);
  courseRef.current = course;

  // Remember sidebar preference.
  useEffect(() => {
    try {
      if (localStorage.getItem("latent-sidebar") === "closed") setSidebarOpen(false);
    } catch {}
  }, []);
  const toggleSidebar = () =>
    setSidebarOpen((o) => {
      try {
        localStorage.setItem("latent-sidebar", o ? "closed" : "open");
      } catch {}
      return !o;
    });

  // Keyboard shortcuts: ⌘B for sidebar, ⌘J for Atlas tutor.
  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "b") {
        e.preventDefault();
        toggleSidebar();
      } else if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "j") {
        e.preventDefault();
        setTutorOpen((o) => !o);
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  const handleProgress = useCallback(
    (lessonId: string, result: ProgressResult) => {
      const prev = courseRef.current;
      // Optimistically reflect the lesson state in the sidebar.
      qc.setQueryData<LearnCourse>(learnKey(slug), (c) => {
        if (!c) return c;
        let completed = 0;
        const sections = c.sections.map((s) => ({
          ...s,
          lessons: s.lessons.map((l) => {
            const next = l.id === lessonId ? { ...l, progress: { completed: result.lessonCompleted, positionSeconds: result.positionSeconds } } : l;
            if (next.progress?.completed) completed++;
            return next;
          }),
        }));
        return {
          ...c,
          sections,
          completedLessons: completed,
          progressPercent: c.totalLessons ? Math.round((completed / c.totalLessons) * 100) : 0,
          certificateId: result.certificateId ?? c.certificateId,
        };
      });
      if (result.courseProgress >= 0) {
        void qc.invalidateQueries({ queryKey: learnKey(slug) });
        void qc.invalidateQueries({ queryKey: qk.enrollments });
        void qc.invalidateQueries({ queryKey: qk.stats });
      }
      if (result.courseCompleted && result.certificateId && !prev?.certificateId) {
        setCelebrate(result.certificateId);
        void qc.invalidateQueries({ queryKey: qk.certificates });
      }
    },
    [qc, slug],
  );

  const ctx = useMemo<LearnContextValue | null>(
    () =>
      course
        ? {
            slug,
            course,
            activeLessonId,
            handleProgress,
            player,
            tutorOpen,
            openTutor: (prompt) => {
              setTutorOpen(true);
              if (prompt) setPendingPrompt(prompt);
            },
            closeTutor: () => setTutorOpen(false),
            chats,
            setChat: (key, updater) => setChats((c) => ({ ...c, [key]: updater(c[key] ?? []) })),
            pendingPrompt,
            clearPendingPrompt: () => setPendingPrompt(null),
          }
        : null,
    [course, slug, activeLessonId, handleProgress, tutorOpen, chats, pendingPrompt],
  );

  if (!course || !ctx) {
    return (
      <div className="flex h-dvh flex-col">
        <div className="h-14 border-b border-border" />
        <PageSpinner />
      </div>
    );
  }

  const active = findLesson(course, activeLessonId);

  return (
    <LearnContext.Provider value={ctx}>
      <div className="flex h-dvh flex-col overflow-hidden bg-background">
        {/* Top bar */}
        <header className="sticky top-0 z-30 flex h-[60px] shrink-0 items-center gap-2 border-b border-border bg-surface/80 px-3 backdrop-blur-xl backdrop-saturate-150 sm:gap-3 sm:px-5">
          <Tooltip content="Back to dashboard" side="bottom">
            <Link
              href="/dashboard"
              className="group flex h-9 items-center gap-1 rounded-[10px] pl-1.5 pr-1 text-muted-foreground transition-colors hover:bg-surface-2 hover:text-foreground"
              aria-label="Back to dashboard"
            >
              <ChevronLeft className="size-4 transition-transform duration-200 group-hover:-translate-x-0.5" />
              <LogoMark className="size-6" />
            </Link>
          </Tooltip>

          <Tooltip content={sidebarOpen ? "Hide curriculum (⌘B)" : "Show curriculum (⌘B)"} side="bottom">
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={toggleSidebar}
              className="hidden rounded-[10px] text-subtle-foreground hover:text-foreground lg:inline-flex"
              aria-label="Toggle curriculum"
            >
              {sidebarOpen ? <PanelLeftClose className="size-[18px]" strokeWidth={1.75} /> : <PanelLeftOpen className="size-[18px]" strokeWidth={1.75} />}
            </Button>
          </Tooltip>

          <Button
            variant="ghost"
            size="icon-sm"
            onClick={() => setMobileCurriculum(true)}
            className="rounded-[10px] text-subtle-foreground hover:text-foreground lg:hidden"
            aria-label="Open curriculum"
          >
            <ListTree className="size-[18px]" strokeWidth={1.75} />
          </Button>

          <div className="mx-1.5 hidden h-6 w-px bg-border sm:block" />

          {/* Breadcrumbs & Title */}
          <nav aria-label="Breadcrumb" className="flex min-w-0 flex-1 items-center gap-2 text-[13px]">
            <Link href="/dashboard" className="hidden font-medium text-subtle-foreground transition-colors hover:text-foreground md:inline">
              My learning
            </Link>
            <span className="hidden text-border-strong md:inline">/</span>
            <Link href={`/courses/${course.slug}`} className="min-w-0 truncate font-medium tracking-[-0.01em] text-foreground transition-colors hover:text-accent">
              {course.title}
            </Link>
          </nav>

          {/* Section progress: one segment per lesson, like steps on a path */}
          {active && (
            <div className="hidden shrink-0 items-center gap-3 lg:flex">
              <span className="text-[12px] font-semibold tabular-nums text-subtle-foreground">
                {active.section.lessons.findIndex((l) => l.id === active.lesson.id) + 1}
                <span className="font-medium">/{active.section.lessons.length}</span>
              </span>
              <div className="flex w-[min(320px,24vw)] items-center gap-1">
                {active.section.lessons.map((l) => {
                  const isActive = l.id === active.lesson.id;
                  return (
                    <Link
                      key={l.id}
                      href={`/learn/${course.slug}/${l.id}`}
                      title={l.title}
                      aria-label={l.title}
                      aria-current={isActive ? "step" : undefined}
                      className={cn(
                        "h-2.5 flex-1 rounded-full transition-all duration-300 hover:scale-y-125",
                        l.progress?.completed ? "bg-go" : isActive ? "bg-accent shadow-[0_0_0_3px_var(--accent-soft)]" : "bg-surface-3 hover:bg-line-3d",
                      )}
                    />
                  );
                })}
              </div>
            </div>
          )}

          <div className="ml-auto flex shrink-0 items-center gap-2 sm:gap-2.5">
            {/* Progress */}
            <Tooltip content={`${course.completedLessons} of ${course.totalLessons} lessons complete`} side="bottom">
              <div className="hidden h-9 items-center gap-2.5 rounded-full border border-border bg-surface pl-1 pr-3.5 md:flex">
                <ProgressRing value={course.progressPercent} size={28} stroke={2.5}>
                  <span className="text-[9px] font-semibold tabular-nums tracking-tight text-foreground">{course.progressPercent}</span>
                </ProgressRing>
                <span className="text-[12.5px] leading-none">
                  <span className="font-semibold tabular-nums text-foreground">{course.completedLessons}</span>
                  <span className="text-subtle-foreground"> / {course.totalLessons} lessons</span>
                </span>
              </div>
            </Tooltip>

            {course.certificateId && (
              <Button variant="secondary" size="sm" asChild className="h-9 rounded-full">
                <Link href={`/certificates/${course.certificateId}`}>
                  <Award className="size-3.5 text-star" />
                  <span className="hidden sm:inline">Certificate</span>
                </Link>
              </Button>
            )}

            {/* Ask Atlas AI button */}
            <button
              type="button"
              onClick={() => setTutorOpen((o) => !o)}
              aria-pressed={tutorOpen}
              className={cn("btn-3d btn-3d-sm group pl-3 pr-1.5", tutorOpen ? "btn-3d-blue" : "")}
            >
              <Sparkles className={cn("size-3.5 transition-transform duration-300 group-hover:rotate-12", tutorOpen ? "text-white" : "text-[oklch(0.85_0.12_80)]")} />
              <span>Ask Atlas</span>
              <kbd className="hidden h-6 items-center rounded-lg bg-white/15 px-1.5 font-mono text-[10.5px] text-white/80 sm:inline-flex">⌘J</kbd>
            </button>
          </div>
        </header>

        <div className="flex min-h-0 flex-1">
          {/* Curriculum (desktop) */}
          <aside className={cn("hidden shrink-0 overflow-hidden border-r border-border bg-surface transition-[width] duration-300 lg:block", sidebarOpen ? "w-[320px]" : "w-0 border-r-0")}>
            <div className="h-full w-[320px]">
              <Curriculum course={course} activeLessonId={activeLessonId} />
            </div>
          </aside>

          <main id="lesson-main" className="min-w-0 flex-1 overflow-y-auto">
            {children}
          </main>

          {/* AI tutor (desktop: docked) */}
          <aside className={cn("hidden shrink-0 overflow-hidden border-l border-border transition-[width] duration-300 xl:block", tutorOpen ? "w-[400px]" : "w-0 border-l-0")}>
            <div className="h-full w-[400px]">{tutorOpen && !narrow && <AiTutor lessonId={activeLessonId} lessonTitle={active?.lesson.title} onClose={() => setTutorOpen(false)} />}</div>
          </aside>
        </div>
      </div>

      {/* Curriculum (mobile) */}
      <Dialog open={mobileCurriculum} onOpenChange={setMobileCurriculum}>
        <SheetContent side="left" className="w-[min(360px,92vw)]">
          <Curriculum course={course} activeLessonId={activeLessonId} onNavigate={() => setMobileCurriculum(false)} />
        </SheetContent>
      </Dialog>

      {/* AI tutor (below xl: slide-over) */}
      <TutorSheet open={tutorOpen && narrow} onOpenChange={setTutorOpen} lessonId={activeLessonId} lessonTitle={active?.lesson.title} />

      <CelebrationDialog certificateId={celebrate} courseTitle={course.title} onClose={() => setCelebrate(null)} />
    </LearnContext.Provider>
  );
}

/** True below the xl breakpoint, where the tutor is a slide-over instead of a docked panel. */
function useNarrow() {
  const [narrow, setNarrow] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia("(max-width: 1279px)");
    const update = () => setNarrow(mq.matches);
    update();
    mq.addEventListener("change", update);
    return () => mq.removeEventListener("change", update);
  }, []);
  return narrow;
}

function TutorSheet({ open, onOpenChange, lessonId, lessonTitle }: { open: boolean; onOpenChange: (o: boolean) => void; lessonId: string | null; lessonTitle?: string }) {
  return (
    <D.Root open={open} onOpenChange={onOpenChange}>
      <D.Portal>
        <D.Overlay className="fixed inset-0 z-50 bg-[oklch(0.15_0.01_265/0.4)] backdrop-blur-[2px]" />
        <D.Content className="fixed inset-y-0 right-0 z-50 w-[min(420px,100vw)] border-l border-border shadow-card-lg outline-none" aria-describedby={undefined}>
          <D.Title className="sr-only">Atlas AI tutor</D.Title>
          <AiTutor lessonId={lessonId} lessonTitle={lessonTitle} onClose={() => onOpenChange(false)} />
        </D.Content>
      </D.Portal>
    </D.Root>
  );
}
