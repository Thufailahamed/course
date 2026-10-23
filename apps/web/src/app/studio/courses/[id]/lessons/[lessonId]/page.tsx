"use client";

import Link from "next/link";
import { use, useEffect, useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowLeft, ChevronLeft, ChevronRight, Cloud, ExternalLink, Link2, Plus, Trash2, X } from "lucide-react";
import type { AdminCourse, AdminLesson, LessonType, QuizQuestion, Resource } from "@latent/shared";
import { formatSeconds } from "@latent/shared";
import { LESSON_ICONS } from "@/components/studio/curriculum";
import { InteractiveAuthoring } from "@/components/studio/interactive-tools";
import { MarkdownEditor, Segmented } from "@/components/studio/kit";
import { QuizBuilder, quizProblems } from "@/components/studio/quiz-builder";
import { VideoUploader } from "@/components/studio/video-uploader";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Field, Input } from "@/components/ui/input";
import { Badge, Card, Switch } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { cn } from "@/lib/utils";

type Form = Omit<AdminLesson, "id" | "sectionId" | "courseId" | "position">;

const toForm = (l: AdminLesson): Form => ({
  title: l.title,
  type: l.type,
  durationSeconds: l.durationSeconds,
  videoUrl: l.videoUrl,
  videoKey: l.videoKey,
  content: l.content,
  isPreview: l.isPreview,
  quiz: l.quiz,
  resources: l.resources,
});

function parseDuration(text: string): number | null {
  const t = text.trim();
  if (!t) return 0;
  const parts = t.split(":").map((p) => Number(p));
  if (parts.some((n) => !Number.isFinite(n) || n < 0)) return null;
  return parts.reduce((acc, n) => acc * 60 + n, 0);
}

function Panel({ title, description, children, aside }: { title: string; description?: string; children: React.ReactNode; aside?: React.ReactNode }) {
  return (
    <Card className="p-5 sm:p-6">
      <div className="mb-5 flex items-start justify-between gap-3">
        <div>
          <h3 className="text-[15px] font-semibold">{title}</h3>
          {description && <p className="mt-1 text-sm text-muted-foreground">{description}</p>}
        </div>
        {aside}
      </div>
      {children}
    </Card>
  );
}

export default function LessonEditorPage({ params }: { params: Promise<{ id: string; lessonId: string }> }) {
  const { id, lessonId } = use(params);
  const qc = useQueryClient();

  const lessonQ = useQuery({ queryKey: ["admin", "lesson", lessonId], queryFn: () => api.get<AdminLesson>(`/admin/lessons/${lessonId}`) });
  const courseQ = useQuery({ queryKey: ["admin", "course", id], queryFn: () => api.get<AdminCourse>(`/admin/courses/${id}`) });

  const initial = useMemo(() => (lessonQ.data ? toForm(lessonQ.data) : null), [lessonQ.data]);
  const [form, setForm] = useState<Form | null>(null);
  const [durationText, setDurationText] = useState("");
  const [videoMode, setVideoMode] = useState<"upload" | "url">("upload");

  useEffect(() => {
    if (!initial) return;
    setForm(initial);
    setDurationText(initial.durationSeconds ? formatSeconds(initial.durationSeconds) : "");
    setVideoMode(initial.videoUrl && !initial.videoKey ? "url" : "upload");
  }, [initial]);

  const set = <K extends keyof Form>(k: K, v: Form[K]) => setForm((f) => (f ? { ...f, [k]: v } : f));

  const changes = useMemo(() => {
    if (!initial || !form) return {};
    const out: Partial<Form> = {};
    for (const k of Object.keys(form) as (keyof Form)[]) if (JSON.stringify(form[k]) !== JSON.stringify(initial[k])) (out as Record<string, unknown>)[k] = form[k];
    return out;
  }, [initial, form]);
  const dirty = Object.keys(changes).length > 0;

  useEffect(() => {
    if (!dirty) return;
    const warn = (e: BeforeUnloadEvent) => e.preventDefault();
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [dirty]);

  const save = useMutation({
    mutationFn: () => {
      const payload: Record<string, unknown> = { ...changes };
      if (payload.content !== undefined) payload.content = (payload.content as string | null)?.trim() ? payload.content : null;
      if (payload.videoUrl !== undefined) payload.videoUrl = (payload.videoUrl as string | null)?.trim() || null;
      if (payload.resources) payload.resources = (payload.resources as Resource[]).filter((r) => r.title.trim() && r.url.trim());
      if (payload.quiz) payload.quiz = (payload.quiz as QuizQuestion[]).map((q) => ({ ...q, explanation: q.explanation?.trim() || undefined }));
      return api.patch<AdminLesson>(`/admin/lessons/${lessonId}`, payload);
    },
    onSuccess: (fresh) => {
      qc.setQueryData(["admin", "lesson", lessonId], fresh);
      qc.invalidateQueries({ queryKey: ["admin", "course", id] });
      toast.success("Lesson saved");
    },
    onError: toastError,
  });

  const problems = form?.type === "quiz" ? quizProblems(form.quiz) : [];
  const trySave = () => {
    if (!form?.title.trim()) return toast.error("Lesson title is required");
    if (problems.length) return toast.error(problems[0]);
    save.mutate();
  };

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "s") {
        e.preventDefault();
        if (dirty && !save.isPending) trySave();
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  });

  const flat = courseQ.data?.sections.flatMap((s) => s.lessons.map((l) => ({ ...l, sectionTitle: s.title }))) ?? [];
  const idx = flat.findIndex((l) => l.id === lessonId);
  const prev = idx > 0 ? flat[idx - 1] : null;
  const next = idx >= 0 && idx < flat.length - 1 ? flat[idx + 1] : null;

  if (lessonQ.error)
    return (
      <EmptyState
        title="Lesson not found"
        description={lessonQ.error.message}
        className="mt-10"
        action={
          <Button asChild variant="secondary">
            <Link href={`/studio/courses/${id}`}>Back to course</Link>
          </Button>
        }
      />
    );

  if (!form || !lessonQ.data)
    return (
      <div className="space-y-6">
        <div className="skeleton h-8 w-72" />
        <div className="skeleton h-64" />
        <div className="skeleton h-96" />
      </div>
    );

  const Icon = LESSON_ICONS[form.type];
  const videoPreview = form.videoKey ? `/api/stream/${lessonId}` : form.videoUrl?.trim() || null;

  return (
    <div className="pb-24">
      <Link href={`/studio/courses/${id}`} className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground">
        <ArrowLeft className="size-4" /> {courseQ.data?.title ?? "Back to course"}
      </Link>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center">
        <span className="flex size-11 shrink-0 items-center justify-center rounded-lg border border-border bg-surface-2 text-muted-foreground">
          <Icon className="size-5" />
        </span>
        <div className="min-w-0 flex-1">
          <h1 className="truncate text-[1.6rem] leading-tight tracking-[-0.025em]">{form.title || "Untitled lesson"}</h1>
          <p className="mt-0.5 text-sm text-muted-foreground">
            {idx >= 0 ? `Lesson ${idx + 1} of ${flat.length} · ${flat[idx]?.sectionTitle}` : "Lesson"}
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-2">
          <Button variant="secondary" size="icon" disabled={!prev} asChild={!!prev} aria-label="Previous lesson">
            {prev ? (
              <Link href={`/studio/courses/${id}/lessons/${prev.id}`}>
                <ChevronLeft />
              </Link>
            ) : (
              <ChevronLeft />
            )}
          </Button>
          <Button variant="secondary" size="icon" disabled={!next} asChild={!!next} aria-label="Next lesson">
            {next ? (
              <Link href={`/studio/courses/${id}/lessons/${next.id}`}>
                <ChevronRight />
              </Link>
            ) : (
              <ChevronRight />
            )}
          </Button>
          {courseQ.data && (
            <Button variant="secondary" asChild>
              <Link href={`/learn/${courseQ.data.slug}/${lessonId}`} target="_blank">
                <ExternalLink /> Open in player
              </Link>
            </Button>
          )}
          <Button onClick={trySave} loading={save.isPending} disabled={!dirty}>
            Save
          </Button>
        </div>
      </div>

      <div className="grid gap-6 xl:grid-cols-[1fr_340px]">
        <div className="space-y-6">
          {form.type === "video" && (
            <Panel
              title="Video"
              description="Upload to Cloudflare R2 (streamed with access control) or link an external MP4/HLS file."
              aside={
                <Segmented
                  value={videoMode}
                  onChange={setVideoMode}
                  options={[
                    { value: "upload", label: <><Cloud className="size-3.5" /> Upload</> },
                    { value: "url", label: <><Link2 className="size-3.5" /> URL</> },
                  ]}
                />
              }
            >
              <div className="space-y-4">
                {videoPreview && (
                  <div className="relative overflow-hidden rounded-2xl border border-border bg-black">
                    <video key={videoPreview} src={videoPreview} controls preload="metadata" className="aspect-video w-full" />
                    <div className="absolute left-3 top-3 flex gap-2">
                      <Badge size="sm" className="border-0 bg-black/55 text-white">
                        {form.videoKey ? "Hosted on R2" : "External URL"}
                      </Badge>
                    </div>
                  </div>
                )}
                {videoMode === "upload" ? (
                  <>
                    <VideoUploader
                      onUploaded={({ key, durationSeconds }) => {
                        setForm((f) => (f ? { ...f, videoKey: key, videoUrl: null, durationSeconds: durationSeconds ?? f.durationSeconds } : f));
                        if (durationSeconds) setDurationText(formatSeconds(durationSeconds));
                      }}
                    />
                    {form.videoKey && (
                      <div className="flex items-center justify-between gap-3 rounded-xl bg-surface-2/60 px-4 py-2.5 text-xs">
                        <span className="truncate font-mono text-subtle-foreground">{form.videoKey}</span>
                        <Button variant="ghost" size="xs" onClick={() => set("videoKey", null)}>
                          <X /> Remove
                        </Button>
                      </div>
                    )}
                  </>
                ) : (
                  <Field label="Video URL" hint="Direct link to an MP4 or HLS (.m3u8) file. Clears any uploaded video.">
                    {(p) => (
                      <Input
                        {...p}
                        value={form.videoUrl ?? ""}
                        onChange={(e) => setForm((f) => (f ? { ...f, videoUrl: e.target.value, videoKey: e.target.value.trim() ? null : f.videoKey } : f))}
                        placeholder="https://…/lesson.mp4"
                      />
                    )}
                  </Field>
                )}
              </div>
            </Panel>
          )}

          {form.type === "quiz" ? (
            <Panel title="Quiz questions" description="Learners need 70% to pass; passing marks the lesson complete.">
              <QuizBuilder value={form.quiz} onChange={(q) => set("quiz", q)} />
              {problems.length > 0 && (
                <ul className="mt-4 space-y-1 rounded-xl bg-warning-soft px-4 py-3 text-sm text-warning">
                  {problems.slice(0, 4).map((p) => (
                    <li key={p}>• {p}</li>
                  ))}
                </ul>
              )}
            </Panel>
          ) : null}

          <Panel
            title={form.type === "article" ? "Article" : form.type === "quiz" ? "Instructions" : form.type === "interactive" ? "Interactive lesson" : "Lesson notes"}
            description={
              form.type === "video"
                ? "Shown below the video. Also gives the AI tutor context for this lesson."
                : form.type === "interactive"
                  ? "Markdown with live code cells for Python, JavaScript, Java, C and HTML/CSS. Learners run and debug them in the browser; solving every challenge completes the lesson."
                  : "Markdown with code blocks and LaTeX math ($…$)."
            }
          >
            {form.type === "interactive" && (
              <div className="mb-5">
                <InteractiveAuthoring content={form.content ?? ""} onChange={(v) => set("content", v)} lessonId={lessonId} />
              </div>
            )}
            <MarkdownEditor value={form.content ?? ""} onChange={(v) => set("content", v)} rows={form.type === "article" ? 22 : form.type === "interactive" ? 30 : 12} />
          </Panel>
        </div>

        <div className="space-y-6 xl:sticky xl:top-24 xl:self-start">
          <Panel title="Settings">
            <div className="space-y-5">
              <Field label="Title">{(p) => <Input {...p} value={form.title} onChange={(e) => set("title", e.target.value)} />}</Field>
              <Field label="Type">
                {() => (
                  <Segmented
                    value={form.type}
                    onChange={(t: LessonType) => set("type", t)}
                    className="grid w-full grid-cols-2 [&>button]:justify-center"
                    options={(["video", "article", "quiz", "interactive"] as const).map((t) => {
                      const I = LESSON_ICONS[t];
                      return { value: t, label: <><I className="size-3.5" /> <span className="capitalize">{t}</span></> };
                    })}
                  />
                )}
              </Field>
              <Field label="Duration" hint={form.type === "video" ? "mm:ss — auto-filled from uploads" : "Estimated time, mm:ss"} error={parseDuration(durationText) === null ? "Use mm:ss or h:mm:ss" : null}>
                {(p) => (
                  <Input
                    {...p}
                    value={durationText}
                    onChange={(e) => {
                      setDurationText(e.target.value);
                      const s = parseDuration(e.target.value);
                      if (s !== null) set("durationSeconds", Math.round(s));
                    }}
                    placeholder="12:30"
                    className="font-mono tabular-nums"
                  />
                )}
              </Field>
              <label className="flex items-center justify-between gap-4 rounded-xl border border-border bg-surface-2/50 px-4 py-3">
                <div>
                  <div className="text-sm font-medium">Free preview</div>
                  <div className="text-xs text-muted-foreground">Anyone can watch this from the course page.</div>
                </div>
                <Switch checked={form.isPreview} onCheckedChange={(v) => set("isPreview", v)} />
              </label>
            </div>
          </Panel>

          <Panel title="Resources" description="Notebooks, slides, papers and links.">
            <div className="space-y-3">
              {form.resources.map((r, i) => (
                <div key={i} className="space-y-2 rounded-xl border border-border p-3">
                  <div className="flex items-center gap-2">
                    <Input value={r.title} onChange={(e) => set("resources", form.resources.map((x, j) => (j === i ? { ...x, title: e.target.value } : x)))} placeholder="Title" className="h-9" />
                    <Button variant="ghost" size="icon-sm" onClick={() => set("resources", form.resources.filter((_, j) => j !== i))} aria-label="Remove resource" className="hover:bg-danger-soft hover:text-danger">
                      <Trash2 />
                    </Button>
                  </div>
                  <Input value={r.url} onChange={(e) => set("resources", form.resources.map((x, j) => (j === i ? { ...x, url: e.target.value } : x)))} placeholder="https://…" className="h-9 font-mono text-xs" />
                </div>
              ))}
              <Button variant="secondary" size="sm" onClick={() => set("resources", [...form.resources, { title: "", url: "" }])}>
                <Plus /> Add resource
              </Button>
            </div>
          </Panel>
        </div>
      </div>

      <div className={cn("fixed inset-x-0 bottom-0 z-30 transition-all duration-300 lg:left-[260px]", dirty ? "translate-y-0 opacity-100" : "pointer-events-none translate-y-full opacity-0")} aria-hidden={!dirty}>
        <div className="mx-auto mb-4 flex w-[calc(100%-2rem)] max-w-3xl items-center gap-3 rounded-xl border border-border bg-surface px-4 py-2.5 shadow-[0_12px_32px_-12px_oklch(0.2_0.01_265/0.28)] sm:px-5">
          <span className="size-2 shrink-0 animate-pulse rounded-full bg-warning" />
          <p className="min-w-0 flex-1 truncate text-sm font-medium">Unsaved changes</p>
          <Button
            variant="ghost"
            size="sm"
            onClick={() => {
              if (!initial) return;
              setForm(initial);
              setDurationText(initial.durationSeconds ? formatSeconds(initial.durationSeconds) : "");
            }}
          >
            Discard
          </Button>
          <Button size="sm" onClick={trySave} loading={save.isPending}>
            Save lesson
          </Button>
        </div>
      </div>
    </div>
  );
}
