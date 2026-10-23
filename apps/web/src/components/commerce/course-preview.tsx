"use client";

import { createContext, useContext, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { FileText, ListChecks, Lock, Play, PlayCircle, SquareTerminal } from "lucide-react";
import { InteractiveLesson } from "@/components/code/interactive-lesson";
import type { CourseDetail, CurriculumLesson, LessonContent } from "@latent/shared";
import { Markdown } from "@/components/markdown";
import { Badge, Dialog, DialogContent } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { cn, formatSeconds } from "@/lib/utils";
import { VideoEmbed } from "./video-embed";

type Ctx = { open: (lessonId?: string | null) => void };
const PreviewCtx = createContext<Ctx>({ open: () => {} });
export const usePreview = () => useContext(PreviewCtx);

/** Holds the "preview this course" dialog; children can open it at a lesson. */
export function CoursePreviewProvider({ course, children }: { course: Pick<CourseDetail, "title" | "previewVideoUrl" | "sections">; children: React.ReactNode }) {
  const [state, setState] = useState<{ open: boolean; lessonId: string | null }>({ open: false, lessonId: null });
  const previews = course.sections.flatMap((s) => s.lessons.filter((l) => l.isPreview));
  return (
    <PreviewCtx.Provider value={{ open: (lessonId = null) => setState({ open: true, lessonId: lessonId ?? (course.previewVideoUrl ? null : (previews[0]?.id ?? null)) }) }}>
      {children}
      <Dialog open={state.open} onOpenChange={(open) => setState((s) => ({ ...s, open }))}>
        <DialogContent size="xl" title="Course preview" description={course.title} className="p-5 sm:p-6">
          {state.open && <PreviewBody course={course} previews={previews} lessonId={state.lessonId} onSelect={(id) => setState({ open: true, lessonId: id })} />}
        </DialogContent>
      </Dialog>
    </PreviewCtx.Provider>
  );
}

function PreviewBody({
  course,
  previews,
  lessonId,
  onSelect,
}: {
  course: Pick<CourseDetail, "previewVideoUrl">;
  previews: CurriculumLesson[];
  lessonId: string | null;
  onSelect: (id: string | null) => void;
}) {
  const { data: lesson, isPending } = useQuery({
    queryKey: ["preview-lesson", lessonId],
    queryFn: () => api.get<LessonContent>(`/learn/lessons/${lessonId}`),
    enabled: !!lessonId,
  });

  return (
    <div className="grid gap-5 lg:grid-cols-[1fr_280px]">
      <div className="min-w-0">
        {!lessonId ? (
          course.previewVideoUrl ? (
            <VideoEmbed src={course.previewVideoUrl} />
          ) : (
            <div className="flex aspect-video items-center justify-center rounded-xl bg-surface-2 text-sm text-muted-foreground">No trailer available</div>
          )
        ) : isPending ? (
          <div className="skeleton aspect-video rounded-xl" />
        ) : lesson?.type === "interactive" && lesson.content ? (
          <div className="max-h-[65vh] overflow-y-auto rounded-xl border border-border bg-background px-4 sm:px-6">
            <h3 className="pt-5 text-xl font-semibold tracking-[-0.02em]">{lesson.title}</h3>
            <p className="mb-3 text-[13px] text-muted-foreground">Free preview. Run and edit the code; enroll to save your progress.</p>
            <InteractiveLesson
              scope={`preview:${lesson.id}`}
              content={lesson.content}
              exercises={null}
              submit={async () => {}}
              getSolution={async (cell) => cell.solution ?? (await api.get<{ solution: string }>(`/learn/lessons/${lesson.id}/solutions/${encodeURIComponent(cell.id)}`)).solution}
            />
          </div>
        ) : lesson?.videoUrl ? (
          <VideoEmbed src={lesson.videoUrl} />
        ) : lesson?.content ? (
          <div className="max-h-[60vh] overflow-y-auto rounded-xl border border-border bg-surface-2 p-6">
            <h3 className="mb-4 text-xl font-semibold tracking-[-0.02em]">{lesson.title}</h3>
            <Markdown size="sm">{lesson.content}</Markdown>
          </div>
        ) : (
          <div className="flex aspect-video items-center justify-center rounded-xl bg-surface-2 text-sm text-muted-foreground">Preview unavailable</div>
        )}
        <p className="mt-3 text-sm font-medium">{lessonId ? lesson?.title : "Course trailer"}</p>
      </div>
      <div className="space-y-1.5">
        <p className="mb-3 text-[13px] font-semibold">Free previews</p>
        {course.previewVideoUrl && (
          <PreviewItem active={!lessonId} onClick={() => onSelect(null)} icon={<PlayCircle />} title="Course trailer" />
        )}
        {previews.map((l) => (
          <PreviewItem
            key={l.id}
            active={lessonId === l.id}
            onClick={() => onSelect(l.id)}
            icon={l.type === "video" ? <Play /> : l.type === "quiz" ? <ListChecks /> : l.type === "interactive" ? <SquareTerminal /> : <FileText />}
            title={l.title}
            meta={formatSeconds(l.durationSeconds)}
          />
        ))}
        <p className="flex items-center gap-2 pt-3 text-xs text-subtle-foreground">
          <Lock className="size-3.5" /> Enroll to unlock every lesson
        </p>
      </div>
    </div>
  );
}

function PreviewItem({ active, onClick, icon, title, meta }: { active: boolean; onClick: () => void; icon: React.ReactNode; title: string; meta?: string }) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "flex w-full items-center gap-3 rounded-lg border px-3 py-2.5 text-left text-sm transition [&_svg]:size-4",
        active ? "border-border bg-surface-2 text-foreground" : "border-transparent text-muted-foreground hover:bg-surface-2 hover:text-foreground",
      )}
    >
      <span className={cn("shrink-0", active ? "text-accent" : "text-subtle-foreground")}>{icon}</span>
      <span className="line-clamp-2 flex-1">{title}</span>
      {meta && <span className="shrink-0 text-xs tabular-nums text-subtle-foreground">{meta}</span>}
    </button>
  );
}

export function PreviewTrigger({ className, children, lessonId }: { className?: string; children: React.ReactNode; lessonId?: string }) {
  const { open } = usePreview();
  return (
    <button type="button" onClick={() => open(lessonId)} className={className}>
      {children}
    </button>
  );
}

export function PreviewBadge({ lessonId }: { lessonId: string }) {
  const { open } = usePreview();
  return (
    <button type="button" onClick={() => open(lessonId)} className="shrink-0">
      <Badge variant="outline" size="sm" className="cursor-pointer hover:bg-surface-2">
        Preview
      </Badge>
    </button>
  );
}
