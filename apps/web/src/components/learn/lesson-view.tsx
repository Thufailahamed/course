"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useCallback, useEffect } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowLeft, ArrowRight, Award, Check, CheckCircle2, Clock, Download, ExternalLink, FileText, Link2, MessageSquare, NotebookPen, Sparkles, StickyNote, Target } from "lucide-react";
import type { ExerciseState, LessonCell, LessonContent } from "@latent/shared";
import { InteractiveLesson } from "@/components/code/interactive-lesson";
import { Markdown } from "@/components/markdown";
import { Button } from "@/components/ui/button";
import { Spinner } from "@/components/ui/spinner";
import { Avatar, EmptyState, ProgressBar } from "@/components/ui/display";
import { Skeleton, Tabs, TabsContent, TabsList, TabsTrigger, Tooltip } from "@/components/ui/primitives";
import { api, ApiError } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { cn, formatSeconds } from "@/lib/utils";
import { LESSON_ICON } from "./curriculum";
import { useLearn } from "./learn-context";
import { NotesPanel } from "./notes-panel";
import { QaPanel } from "./qa-panel";
import { Quiz } from "./quiz";
import { findLesson, lessonKey, type ProgressResult } from "./types";
import { embedUrl, EmbedPlayer, VideoPlayer } from "./video-player";

const fetchLesson = (id: string) => api.get<LessonContent>(`/learn/lessons/${id}`);

export function LessonView({ lessonId }: { lessonId: string }) {
  const { course, slug, handleProgress, player, openTutor } = useLearn();
  const router = useRouter();
  const qc = useQueryClient();
  const search = useSearchParams();
  const t = Number(search.get("t"));

  const { data: lesson, error, isPending } = useQuery({ queryKey: lessonKey(lessonId), queryFn: () => fetchLesson(lessonId) });

  useEffect(() => {
    if (error instanceof ApiError && (error.status === 403 || error.status === 404)) router.replace(`/courses/${slug}`);
  }, [error, router, slug]);

  // Start each lesson at the top, and warm up the next one.
  useEffect(() => {
    document.getElementById("lesson-main")?.scrollTo({ top: 0 });
  }, [lessonId]);
  useEffect(() => {
    if (lesson?.nextLessonId) void qc.prefetchQuery({ queryKey: lessonKey(lesson.nextLessonId), queryFn: () => fetchLesson(lesson.nextLessonId!) });
  }, [lesson?.nextLessonId, qc]);

  const meta = findLesson(course, lessonId);
  const completed = !!(meta?.lesson.progress?.completed ?? lesson?.progress?.completed);
  const next = lesson?.nextLessonId ? findLesson(course, lesson.nextLessonId) : null;
  const goNext = () => lesson?.nextLessonId && router.push(`/learn/${slug}/${lesson.nextLessonId}`);

  const applyResult = (r: ProgressResult) => {
    handleProgress(lessonId, r);
    qc.setQueryData<LessonContent>(lessonKey(lessonId), (l) => (l ? { ...l, progress: { completed: r.lessonCompleted, positionSeconds: r.positionSeconds } } : l));
  };

  const setComplete = useMutation({
    mutationFn: (value: boolean) => api.post<ProgressResult>(`/learn/lessons/${lessonId}/progress`, { completed: value }),
    onSuccess: applyResult,
    onError: toastError,
  });

  const submitExercise = useCallback(
    async (cellId: string, code: string, passed: boolean) => {
      try {
        const res = await api.post<{ exercise: ExerciseState; progress: ProgressResult | null }>(`/learn/lessons/${lessonId}/exercises/${encodeURIComponent(cellId)}`, { code, passed });
        qc.setQueryData<LessonContent>(lessonKey(lessonId), (l) => (l ? { ...l, exercises: { ...l.exercises, [cellId]: res.exercise } } : l));
        if (res.progress) {
          applyResult(res.progress);
          if (!res.progress.courseCompleted) toast.success("Lesson complete", { description: "You solved every challenge in this lesson." });
        }
      } catch (e) {
        // Previews (not enrolled) can still practise; attempts just aren't saved.
        if (!(e instanceof ApiError && (e.status === 401 || e.status === 403))) toastError(e);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [lessonId, qc],
  );

  const getSolution = useCallback(
    async (cell: LessonCell) => cell.solution ?? (await api.get<{ solution: string }>(`/learn/lessons/${lessonId}/solutions/${encodeURIComponent(cell.id)}`)).solution,
    [lessonId],
  );
  const explain = useCallback((prompt: string) => openTutor(prompt), [openTutor]);

  const completeAndContinue = async () => {
    if (!completed) {
      try {
        applyResult(await setComplete.mutateAsync(true));
      } catch {
        return;
      }
    }
    goNext();
  };

  if (isPending || !lesson) {
    if (meta && meta.lesson.type !== "video")
      return (
        <div className="mx-auto max-w-[860px] space-y-5 px-4 pt-10 sm:px-8 sm:pt-14">
          <Skeleton className="h-3 w-40" />
          <Skeleton className="h-14 w-4/5 rounded-xl" />
          <Skeleton className="mt-8 h-9 w-full rounded-full" />
          <Skeleton className="mt-6 h-4 w-full" />
          <Skeleton className="h-4 w-11/12" />
          <Skeleton className="mt-8 h-64 w-full rounded-2xl" />
        </div>
      );
    return (
      <div className="mx-auto max-w-5xl space-y-6 p-4 sm:p-8">
        <Skeleton className="aspect-video w-full rounded-xl" />
        <Skeleton className="h-8 w-2/3" />
        <Skeleton className="h-4 w-1/3" />
      </div>
    );
  }

  const Icon = LESSON_ICON[lesson.type];
  const interactive = lesson.type === "interactive";
  const readable = lesson.type === "article" || interactive;
  const embed = lesson.type === "video" && lesson.videoUrl ? embedUrl(lesson.videoUrl) : null;
  const startAt = t > 0 ? t : (lesson.progress?.positionSeconds ?? 0);
  const isVideo = lesson.type === "video" && !!lesson.videoUrl && !embed;

  return (
    <div>
      {/* Media stage */}
      {lesson.type === "video" && (
        <div className="bg-[oklch(0.14_0.005_270)]">
          <div className="mx-auto max-w-[1400px]">
            {embed ? (
              <EmbedPlayer url={embed} title={lesson.title} />
            ) : lesson.videoUrl ? (
              <VideoPlayer
                key={lesson.id}
                src={lesson.videoUrl}
                lessonId={lesson.id}
                startAt={startAt}
                alreadyCompleted={completed}
                nextTitle={next?.lesson.title ?? null}
                onNext={goNext}
                onResult={applyResult}
                playerRef={player}
              />
            ) : (
              <div className="flex aspect-video items-center justify-center text-sm text-white/60">Video coming soon</div>
            )}
          </div>
        </div>
      )}

      <div className={cn("mx-auto px-4 sm:px-8", lesson.type === "article" ? "max-w-3xl" : interactive ? "max-w-[860px]" : "max-w-5xl")}>
        {/* Title */}
        <header className={cn("flex flex-col items-center text-center", lesson.type === "video" ? "pb-8 pt-8" : "pb-10 pt-12 sm:pt-16")}>
          <div className="flex flex-wrap items-center justify-center gap-2">
            <span className={cn("flex size-10 items-center justify-center rounded-[13px] text-white", completed ? "bg-go shadow-[0_3px_0_0_var(--go-edge)]" : "bg-accent shadow-[0_3px_0_0_var(--accent-edge)]")}>
              {completed ? <Check className="size-5" strokeWidth={3} /> : <Icon className="size-5" strokeWidth={2.25} />}
            </span>
          </div>
          {meta && (
            <p className="mt-5 text-[13px] font-semibold text-accent">
              Section {course.sections.findIndex((s) => s.id === meta.section.id) + 1}
              <span className="mx-1.5 text-border-strong">·</span>
              <span className="text-muted-foreground">{meta.section.title}</span>
            </p>
          )}

          <h1 className="mt-3 max-w-[18ch] text-[2.4rem] font-bold leading-[1.04] tracking-[-0.045em] text-foreground text-balance sm:text-[3.2rem]">{lesson.title}</h1>

          <div className="mt-6 flex flex-wrap items-center justify-center gap-2 text-[13px] font-medium text-muted-foreground">
            <span className="inline-flex h-8 items-center gap-1.5 rounded-full bg-surface-2 px-3">
              <Icon className="size-3.5" strokeWidth={2.25} />
              {interactive ? "Interactive" : lesson.type === "quiz" ? "Quiz" : lesson.type === "video" ? "Video" : "Reading"}
            </span>
            {lesson.type !== "quiz" && lesson.durationSeconds > 0 && (
              <span className="inline-flex h-8 items-center gap-1.5 rounded-full bg-surface-2 px-3 tabular-nums">
                <Clock className="size-3.5" strokeWidth={2.25} />
                {lesson.type === "article" ? `${Math.max(1, Math.round(lesson.durationSeconds / 60))} min read` : interactive ? `${Math.max(1, Math.round(lesson.durationSeconds / 60))} min` : formatSeconds(lesson.durationSeconds)}
              </span>
            )}
            {meta && (
              <span className="inline-flex h-8 items-center rounded-full bg-surface-2 px-3 tabular-nums">
                Lesson {meta.index + 1} of {course.totalLessons}
              </span>
            )}
            {completed && (
              <span className="inline-flex h-8 items-center gap-1.5 rounded-full bg-go-soft px-3 font-semibold text-go-edge">
                <CheckCircle2 className="size-3.5" strokeWidth={2.5} /> Completed
              </span>
            )}
          </div>
        </header>

        {/* Article body */}
        {lesson.type === "article" && (
          <article className="py-10">
            <Markdown size="lg" className="prose-editorial">{lesson.content ?? ""}</Markdown>
            <div className="card mt-14 overflow-hidden border-border/80 shadow-card">
              <div className="h-1 bg-gradient-to-r from-accent via-indigo-500 to-emerald-500" />
              <div className="flex flex-col items-center gap-4 p-8 text-center">
                {completed ? (
                  <p className="inline-flex items-center gap-2 font-semibold text-emerald-600">
                    <CheckCircle2 className="size-5 text-emerald-500" /> You've completed this reading
                  </p>
                ) : (
                  <p className="font-semibold text-foreground">Finished reading?</p>
                )}
                <div className="flex flex-wrap justify-center gap-2">
                  <Button variant="secondary" size="sm" onClick={() => openTutor("Summarize this reading in 5 bullet points and highlight the one idea I should remember.")} className="shadow-2xs">
                    <Sparkles className="size-3.5 text-amber-500" /> Summarize with Atlas
                  </Button>
                  {lesson.nextLessonId ? (
                    <Button onClick={completeAndContinue} loading={setComplete.isPending} size="sm" className="shadow-2xs font-semibold">
                      {completed ? "Next lesson" : "Mark complete & continue"} <ArrowRight className="size-3.5" />
                    </Button>
                  ) : (
                    !completed && (
                      <Button onClick={() => setComplete.mutate(true)} loading={setComplete.isPending} size="sm">
                        Mark complete
                      </Button>
                    )
                  )}
                </div>
              </div>
            </div>
          </article>
        )}

        {/* Interactive */}
        {interactive && (
          <div>
            <InteractiveLesson
              key={lesson.id}
              scope={lesson.id}
              content={lesson.content ?? ""}
              exercises={lesson.exercises}
              submit={submitExercise}
              getSolution={getSolution}
              explain={explain}
              footer={({ solved, total }) => (
                <div className="card-3d relative mb-6 mt-14 overflow-hidden">
                  <div aria-hidden className="pointer-events-none absolute inset-x-0 top-0 h-44 bg-[radial-gradient(55%_100%_at_50%_0%,var(--go-soft),transparent)]" />
                  <div className="relative flex flex-col items-center px-6 py-12 text-center sm:px-12">
                    {completed ? (
                      <>
                        <span className="flex size-16 items-center justify-center rounded-full bg-go text-white shadow-[0_5px_0_0_var(--go-edge),0_0_0_10px_var(--go-soft)]">
                          <Check className="size-8" strokeWidth={3.25} />
                        </span>
                        <h3 className="mt-7 text-[1.9rem] font-bold leading-tight tracking-[-0.04em] text-foreground">Lesson complete!</h3>
                        <p className="mt-2 max-w-sm text-[15px] text-muted-foreground">Nicely done. Every concept and challenge here is in the bag.</p>
                      </>
                    ) : total > 0 ? (
                      <>
                        <div className="flex items-center gap-2.5">
                          {Array.from({ length: total }).map((_, i) => (
                            <span
                              key={i}
                              className={cn(
                                "flex size-12 items-center justify-center rounded-2xl transition-all duration-500",
                                i < solved ? "bg-go text-white shadow-[0_4px_0_0_var(--go-edge)]" : "border-2 border-line-3d bg-surface text-subtle-foreground shadow-[0_4px_0_0_var(--line-3d)]",
                              )}
                            >
                              {i < solved ? <Check className="size-5" strokeWidth={3.25} /> : <Target className="size-5" strokeWidth={2.25} />}
                            </span>
                          ))}
                        </div>
                        <h3 className="mt-7 text-[1.75rem] font-bold leading-tight tracking-[-0.04em] text-foreground">
                          {solved === 0 ? "Ready for the challenges?" : solved < total ? `${solved} of ${total} challenges solved` : "All challenges solved!"}
                        </h3>
                        <p className="mt-2 max-w-sm text-[15px] text-muted-foreground">Solve every challenge above to complete this lesson automatically.</p>
                      </>
                    ) : (
                      <>
                        <h3 className="text-[1.75rem] font-bold leading-tight tracking-[-0.04em] text-foreground">Done experimenting?</h3>
                        <p className="mt-2 text-[15px] text-muted-foreground">Move on to the next lesson, or test yourself with Atlas first.</p>
                      </>
                    )}

                    <div className="mt-9 flex flex-wrap justify-center gap-3">
                      <button type="button" onClick={() => openTutor("Quiz me with 3 short questions on this lesson's key ideas, one at a time.")} className="btn-3d btn-3d-white">
                        <Sparkles className="size-4 text-[oklch(0.72_0.16_70)]" /> Quiz me with Atlas
                      </button>
                      {lesson.nextLessonId ? (
                        <button type="button" onClick={completeAndContinue} disabled={setComplete.isPending} className="btn-3d btn-3d-green group px-6">
                          {completed ? "Next lesson" : "Complete & continue"} <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" strokeWidth={2.5} />
                        </button>
                      ) : (
                        !completed && (
                          <button type="button" onClick={() => setComplete.mutate(true)} disabled={setComplete.isPending} className="btn-3d btn-3d-green px-6">
                            Mark complete
                          </button>
                        )
                      )}
                    </div>
                  </div>
                </div>
              )}
            />
          </div>
        )}

        {/* Quiz */}
        {lesson.type === "quiz" && (
          <div className="py-8">
            <Quiz key={lesson.id} lesson={lesson} onNext={lesson.nextLessonId ? goNext : null} onPassed={() => qc.invalidateQueries({ queryKey: lessonKey(lessonId) })} />
          </div>
        )}

        {/* Tabs */}
        <Tabs defaultValue={lesson.type === "video" ? "overview" : "notes"} className="pt-2">
          <TabsList className="sticky top-0 z-10 bg-background">
            {lesson.type === "video" && (
              <TabsTrigger value="overview">
                <FileText /> Overview
              </TabsTrigger>
            )}
            <TabsTrigger value="notes">
              <NotebookPen /> Notes
            </TabsTrigger>
            <TabsTrigger value="qa">
              <MessageSquare /> Q&amp;A
            </TabsTrigger>
            <TabsTrigger value="resources">
              <Download /> Resources
              {lesson.resources.length > 0 && <span className="rounded-full bg-surface-3 px-1.5 text-[11px] tabular-nums">{lesson.resources.length}</span>}
            </TabsTrigger>
            <button onClick={() => openTutor()} className="ml-auto inline-flex h-11 shrink-0 items-center gap-1.5 text-sm font-medium text-accent hover:underline">
              <Sparkles className="size-4" /> Ask Atlas
            </button>
          </TabsList>

          {lesson.type === "video" && (
            <TabsContent value="overview" className="py-8">
              <div className="grid gap-10 lg:grid-cols-[1fr_280px]">
                <div>
                  {lesson.content ? <Markdown>{lesson.content}</Markdown> : <p className="text-sm text-muted-foreground">No notes for this lesson.</p>}
                </div>
                <aside className="space-y-4">
                  <div className="card p-5">
                    <p className="text-xs font-medium text-muted-foreground">Instructor</p>
                    <div className="mt-3 flex items-center gap-3">
                      <Avatar name={course.instructor.name} src={course.instructor.avatarUrl} size={40} />
                      <div className="min-w-0">
                        <div className="truncate text-sm font-semibold">{course.instructor.name}</div>
                        {course.instructor.headline && <div className="line-clamp-2 text-xs text-subtle-foreground">{course.instructor.headline}</div>}
                      </div>
                    </div>
                  </div>
                  <div className="card space-y-2 p-5">
                    <p className="text-xs font-medium text-muted-foreground">Stuck?</p>
                    {["Explain this lesson simply", "Give me a code example", "Quiz me on this"].map((p) => (
                      <button key={p} onClick={() => openTutor(p)} className="flex w-full items-center gap-2 rounded-lg px-2 py-1.5 text-left text-sm text-muted-foreground transition hover:bg-surface-2 hover:text-foreground">
                        <Sparkles className="size-3.5 text-accent" /> {p}
                      </button>
                    ))}
                  </div>
                  <div className="hidden rounded-xl border border-border bg-surface-2 p-4 text-xs leading-relaxed text-subtle-foreground lg:block">
                    <p className="mb-2 font-medium text-muted-foreground">Keyboard shortcuts</p>
                    <div className="grid grid-cols-[auto_1fr] gap-x-3 gap-y-1.5">
                      <span className="kbd">K</span> Play / pause
                      <span className="kbd">J / L</span> Back / forward 10s
                      <span className="kbd">← / →</span> Seek 5s
                      <span className="kbd">F</span> Fullscreen
                      <span className="kbd">M</span> Mute
                      <span className="kbd">&lt; / &gt;</span> Speed
                    </div>
                  </div>
                </aside>
              </div>
            </TabsContent>
          )}
          <TabsContent value="notes" className="py-8">
            <NotesPanel lessonId={lesson.id} isVideo={isVideo} />
          </TabsContent>
          <TabsContent value="qa" className="py-8">
            <QaPanel lessonId={lesson.id} />
          </TabsContent>
          <TabsContent value="resources" className="py-8">
            {lesson.resources.length === 0 ? (
              <EmptyState icon={<StickyNote />} title="No resources for this lesson" description="Downloadable notebooks, slides and links appear here when available." />
            ) : (
              <ul className="grid gap-3 sm:grid-cols-2">
                {lesson.resources.map((r) => (
                  <li key={r.url + r.title}>
                    <a href={r.url} target="_blank" rel="noopener noreferrer" className="card group flex items-center gap-3 p-4 transition-[border-color,box-shadow] hover:border-border-strong hover:shadow-card-lg">
                      <span className="flex size-10 shrink-0 items-center justify-center rounded-lg border border-border bg-surface-2 text-muted-foreground transition-colors group-hover:text-foreground">
                        <Link2 className="size-4" />
                      </span>
                      <span className="min-w-0 flex-1">
                        <span className="block truncate text-sm font-medium group-hover:text-accent">{r.title}</span>
                        <span className="block truncate text-xs text-subtle-foreground">{r.url.replace(/^https?:\/\//, "")}</span>
                      </span>
                      <ExternalLink className="size-4 shrink-0 text-subtle-foreground" />
                    </a>
                  </li>
                ))}
              </ul>
            )}
          </TabsContent>
        </Tabs>
      </div>

      {/* Action bar: always one tap from moving on */}
      <div className="sticky bottom-0 z-20 mt-10 border-t-2 border-line-3d bg-surface/90 backdrop-blur-xl">
        <div className="mx-auto flex max-w-[860px] items-center gap-3 px-4 pb-4 pt-3.5 sm:px-8">
          <Tooltip content="Previous lesson">
            <button
              type="button"
              disabled={!lesson.prevLessonId}
              onClick={() => router.push(`/learn/${slug}/${lesson.prevLessonId}`)}
              className="btn-3d btn-3d-white btn-3d-icon"
              aria-label="Previous lesson"
            >
              <ArrowLeft className="size-[18px]" strokeWidth={2.5} />
            </button>
          </Tooltip>

          {lesson.type !== "quiz" && (
            <button
              type="button"
              onClick={() => setComplete.mutate(!completed)}
              disabled={setComplete.isPending}
              aria-pressed={completed}
              className="group inline-flex h-11 items-center gap-2.5 rounded-xl px-2 text-[14px] font-semibold text-muted-foreground transition-colors hover:text-foreground"
            >
              <span
                className={cn(
                  "flex size-6 items-center justify-center rounded-full border-2 transition-all",
                  completed ? "border-go bg-go text-white" : "border-line-3d bg-surface group-hover:border-subtle-foreground",
                )}
              >
                {setComplete.isPending ? <Spinner className="size-3" /> : completed && <Check className="size-3.5" strokeWidth={3.5} />}
              </span>
              <span className="hidden sm:inline">{completed ? "Completed" : "Mark complete"}</span>
            </button>
          )}

          <div className="ml-auto">
            {lesson.nextLessonId ? (
              <button type="button" onClick={completeAndContinue} disabled={setComplete.isPending} className="btn-3d btn-3d-green group min-w-[180px] px-6">
                {completed || lesson.type === "quiz" ? "Continue" : "Complete & continue"}
                <ArrowRight className="size-[18px] transition-transform duration-200 group-hover:translate-x-0.5" strokeWidth={2.5} />
              </button>
            ) : course.certificateId ? (
              <Link href={`/certificates/${course.certificateId}`} className="btn-3d btn-3d-green px-6">
                <Award className="size-[18px]" /> View certificate
              </Link>
            ) : null}
          </div>
        </div>
      </div>
    </div>
  );
}
