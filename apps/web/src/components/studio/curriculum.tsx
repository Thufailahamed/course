"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import {
  AlertTriangle,
  ArrowDown,
  ArrowUp,
  Eye,
  FileText,
  GripVertical,
  ListChecks,
  MoreHorizontal,
  PencilLine,
  PlayCircle,
  Plus,
  SquareTerminal,
  Trash2,
} from "lucide-react";
import type { AdminCourse, CurriculumLesson, LessonType } from "@latent/shared";
import { formatDuration, formatSeconds } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { EmptyState } from "@/components/ui/display";
import { Badge, Dropdown, DropdownContent, DropdownItem, DropdownSeparator, DropdownTrigger, Tooltip } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { cn } from "@/lib/utils";
import { ConfirmDialog, Segmented, useConfirm } from "./kit";

type Lesson = CurriculumLesson & { hasVideo: boolean };
type Section = { id: string; title: string; position: number; lessons: Lesson[] };
type Sections = Section[];

export const LESSON_ICONS: Record<LessonType, React.ComponentType<{ className?: string }>> = {
  video: PlayCircle,
  article: FileText,
  quiz: ListChecks,
  interactive: SquareTerminal,
};

type Drag = { kind: "lesson"; id: string } | { kind: "section"; id: string } | null;
type Indicator = { kind: "lesson"; sectionId: string; index: number } | { kind: "section"; index: number } | null;

export function CurriculumBuilder({ course }: { course: AdminCourse }) {
  const qc = useQueryClient();
  const [secs, setSecs] = useState<Sections>(course.sections as Sections);
  const drag = useRef<Drag>(null);
  const [dragging, setDragging] = useState<Drag>(null);
  const [indicator, setIndicator] = useState<Indicator>(null);
  const [newSection, setNewSection] = useState("");
  const confirmSection = useConfirm<Sections[number]>();
  const confirmLesson = useConfirm<Lesson>();

  useEffect(() => setSecs(course.sections as Sections), [course.sections]);

  const refresh = () => qc.invalidateQueries({ queryKey: ["admin", "course", course.id] });

  const reorder = useMutation({
    mutationFn: (next: Sections) => api.post(`/admin/courses/${course.id}/reorder`, { sections: next.map((s) => ({ id: s.id, lessonIds: s.lessons.map((l) => l.id) })) }),
    onSuccess: refresh,
    onError: (e) => {
      toastError(e);
      setSecs(course.sections as Sections);
    },
  });
  const commit = (next: Sections) => {
    setSecs(next);
    reorder.mutate(next);
  };

  const addSection = useMutation({
    mutationFn: (title: string) => api.post(`/admin/courses/${course.id}/sections`, { title }),
    onSuccess: () => {
      setNewSection("");
      refresh();
    },
    onError: toastError,
  });
  const deleteSection = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/sections/${id}`),
    onSuccess: () => {
      confirmSection.close();
      toast.success("Section deleted");
      refresh();
    },
    onError: toastError,
  });
  const deleteLesson = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/lessons/${id}`),
    onSuccess: () => {
      confirmLesson.close();
      toast.success("Lesson deleted");
      refresh();
    },
    onError: toastError,
  });

  /* ── move helpers ─────────────────────────────────────── */

  const moveLesson = (lessonId: string, toSection: string, toIndex: number) => {
    let moving: Lesson | undefined;
    let fromSection = "";
    let fromIndex = -1;
    const stripped = secs.map((s) => {
      const i = s.lessons.findIndex((l) => l.id === lessonId);
      if (i === -1) return s;
      moving = s.lessons[i];
      fromSection = s.id;
      fromIndex = i;
      return { ...s, lessons: s.lessons.filter((l) => l.id !== lessonId) };
    });
    if (!moving) return;
    const idx = fromSection === toSection && fromIndex < toIndex ? toIndex - 1 : toIndex;
    if (fromSection === toSection && idx === fromIndex) return;
    commit(stripped.map((s) => (s.id === toSection ? { ...s, lessons: [...s.lessons.slice(0, idx), moving!, ...s.lessons.slice(idx)] } : s)));
  };

  const moveSection = (sectionId: string, toIndex: number) => {
    const from = secs.findIndex((s) => s.id === sectionId);
    if (from === -1) return;
    const idx = from < toIndex ? toIndex - 1 : toIndex;
    if (idx === from) return;
    const next = secs.filter((s) => s.id !== sectionId);
    next.splice(idx, 0, secs[from]!);
    commit(next);
  };

  const endDrag = () => {
    drag.current = null;
    setDragging(null);
    setIndicator(null);
  };

  const onDrop = () => {
    const d = drag.current;
    const ind = indicator;
    endDrag();
    if (!d || !ind) return;
    if (d.kind === "lesson" && ind.kind === "lesson") moveLesson(d.id, ind.sectionId, ind.index);
    if (d.kind === "section" && ind.kind === "section") moveSection(d.id, ind.index);
  };

  const totalLessons = secs.reduce((n, s) => n + s.lessons.length, 0);
  const totalSeconds = secs.reduce((n, s) => n + s.lessons.reduce((m, l) => m + l.durationSeconds, 0), 0);

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-border bg-surface-2 px-5 py-3.5 text-[13px]">
        <div className="flex flex-wrap items-center gap-x-5 gap-y-1 text-muted-foreground">
          <span>
            <span className="font-semibold text-foreground tabular-nums">{secs.length}</span> sections
          </span>
          <span>
            <span className="font-semibold text-foreground tabular-nums">{totalLessons}</span> lessons
          </span>
          <span>
            <span className="font-semibold text-foreground tabular-nums">{formatDuration(Math.round(totalSeconds / 60))}</span> total
          </span>
        </div>
        <span className="flex items-center gap-1.5 text-xs text-subtle-foreground">
          <GripVertical className="size-3.5" /> Drag to reorder lessons and sections
          {reorder.isPending && <span className="ml-2 text-accent">Saving…</span>}
        </span>
      </div>

      {secs.length === 0 && <EmptyState title="No sections yet" description="Sections group related lessons. Add your first one below." />}

      <div
        onDragOver={(e) => {
          if (drag.current?.kind === "section") e.preventDefault();
        }}
        onDrop={onDrop}
        className="space-y-4"
      >
        {secs.map((section, si) => (
          <div key={section.id}>
            {indicator?.kind === "section" && indicator.index === si && <DropLine />}
            <SectionCard
              section={section}
              index={si}
              course={course}
              isDragging={dragging?.kind === "section" && dragging.id === section.id}
              lessonDragging={dragging?.kind === "lesson" ? dragging.id : null}
              indicator={indicator?.kind === "lesson" && indicator.sectionId === section.id ? indicator.index : null}
              onSectionDragStart={() => {
                drag.current = { kind: "section", id: section.id };
                setDragging(drag.current);
              }}
              onSectionDragOver={(after) => {
                if (drag.current?.kind === "section") setIndicator({ kind: "section", index: after ? si + 1 : si });
              }}
              onLessonDragStart={(id) => {
                drag.current = { kind: "lesson", id };
                setDragging(drag.current);
              }}
              onLessonDragOver={(index) => {
                if (drag.current?.kind === "lesson") setIndicator({ kind: "lesson", sectionId: section.id, index });
              }}
              onDrop={onDrop}
              onDragEnd={endDrag}
              onMoveLesson={(lessonId, dir) => {
                const i = section.lessons.findIndex((l) => l.id === lessonId);
                if (dir === -1 && i > 0) moveLesson(lessonId, section.id, i - 1);
                else if (dir === 1 && i < section.lessons.length - 1) moveLesson(lessonId, section.id, i + 2);
                else if (dir === -1 && si > 0) moveLesson(lessonId, secs[si - 1]!.id, secs[si - 1]!.lessons.length);
                else if (dir === 1 && si < secs.length - 1) moveLesson(lessonId, secs[si + 1]!.id, 0);
              }}
              onMoveSection={(dir) => moveSection(section.id, dir === -1 ? si - 1 : si + 2)}
              canMoveUp={si > 0}
              canMoveDown={si < secs.length - 1}
              onDeleteSection={() => confirmSection.ask(section)}
              onDeleteLesson={(l) => confirmLesson.ask(l)}
              onChanged={refresh}
            />
            {indicator?.kind === "section" && indicator.index === secs.length && si === secs.length - 1 && <DropLine />}
          </div>
        ))}
      </div>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (newSection.trim()) addSection.mutate(newSection.trim());
        }}
        className="flex flex-col gap-2 rounded-2xl border border-dashed border-border-strong p-4 sm:flex-row"
      >
        <Input value={newSection} onChange={(e) => setNewSection(e.target.value)} placeholder={`Section ${secs.length + 1} title, e.g. "Training at scale"`} className="h-10" />
        <Button type="submit" variant="secondary" loading={addSection.isPending} disabled={!newSection.trim()}>
          <Plus /> Add section
        </Button>
      </form>

      <ConfirmDialog
        open={confirmSection.open}
        onOpenChange={(o) => !o && confirmSection.close()}
        title={`Delete "${confirmSection.target?.title}"?`}
        description={`This also deletes its ${confirmSection.target?.lessons.length ?? 0} lessons and learners' progress on them. This can't be undone.`}
        confirmLabel="Delete section"
        loading={deleteSection.isPending}
        onConfirm={() => confirmSection.target && deleteSection.mutate(confirmSection.target.id)}
      />
      <ConfirmDialog
        open={confirmLesson.open}
        onOpenChange={(o) => !o && confirmLesson.close()}
        title={`Delete "${confirmLesson.target?.title}"?`}
        description="Learners' progress, notes and quiz attempts for this lesson will be removed."
        confirmLabel="Delete lesson"
        loading={deleteLesson.isPending}
        onConfirm={() => confirmLesson.target && deleteLesson.mutate(confirmLesson.target.id)}
      />
    </div>
  );
}

function DropLine() {
  return <div className="my-1 h-0.5 rounded-full bg-accent shadow-[0_0_0_3px_var(--accent-soft)]" />;
}

function SectionCard({
  section,
  index,
  course,
  isDragging,
  lessonDragging,
  indicator,
  onSectionDragStart,
  onSectionDragOver,
  onLessonDragStart,
  onLessonDragOver,
  onDrop,
  onDragEnd,
  onMoveLesson,
  onMoveSection,
  canMoveUp,
  canMoveDown,
  onDeleteSection,
  onDeleteLesson,
  onChanged,
}: {
  section: Sections[number];
  index: number;
  course: AdminCourse;
  isDragging: boolean;
  lessonDragging: string | null;
  indicator: number | null;
  onSectionDragStart: () => void;
  onSectionDragOver: (after: boolean) => void;
  onLessonDragStart: (id: string) => void;
  onLessonDragOver: (index: number) => void;
  onDrop: () => void;
  onDragEnd: () => void;
  onMoveLesson: (id: string, dir: -1 | 1) => void;
  onMoveSection: (dir: -1 | 1) => void;
  canMoveUp: boolean;
  canMoveDown: boolean;
  onDeleteSection: () => void;
  onDeleteLesson: (l: Lesson) => void;
  onChanged: () => void;
}) {
  const [editing, setEditing] = useState(false);
  const [title, setTitle] = useState(section.title);
  const [adding, setAdding] = useState(false);
  const [lessonTitle, setLessonTitle] = useState("");
  const [lessonType, setLessonType] = useState<LessonType>("video");
  const cardRef = useRef<HTMLDivElement>(null);

  useEffect(() => setTitle(section.title), [section.title]);

  const rename = useMutation({
    mutationFn: (t: string) => api.patch(`/admin/sections/${section.id}`, { title: t }),
    onSuccess: () => {
      setEditing(false);
      onChanged();
    },
    onError: toastError,
  });
  const addLesson = useMutation({
    mutationFn: () => api.post(`/admin/sections/${section.id}/lessons`, { title: lessonTitle.trim(), type: lessonType }),
    onSuccess: () => {
      setLessonTitle("");
      setAdding(false);
      toast.success("Lesson added");
      onChanged();
    },
    onError: toastError,
  });

  const saveTitle = () => {
    const t = title.trim();
    if (!t || t === section.title) {
      setTitle(section.title);
      setEditing(false);
      return;
    }
    rename.mutate(t);
  };

  const secSeconds = section.lessons.reduce((n, l) => n + l.durationSeconds, 0);

  return (
    <div
      ref={cardRef}
      onDragOver={(e) => {
        const rect = cardRef.current!.getBoundingClientRect();
        onSectionDragOver(e.clientY > rect.top + rect.height / 2);
      }}
      className={cn("card overflow-hidden transition-opacity", isDragging && "opacity-40")}
    >
      <div className="flex items-center gap-2 border-b border-border bg-surface-2/40 px-3 py-2.5 sm:px-4">
        <span
          draggable
          onDragStart={(e) => {
            e.dataTransfer.effectAllowed = "move";
            e.dataTransfer.setData("text/plain", section.id);
            onSectionDragStart();
          }}
          onDragEnd={onDragEnd}
          className="cursor-grab rounded-md p-1 text-subtle-foreground hover:bg-surface-3 hover:text-foreground active:cursor-grabbing"
          aria-label="Drag section"
        >
          <GripVertical className="size-4" />
        </span>
        <span className="text-xs font-medium tabular-nums text-subtle-foreground">Section {index + 1}</span>
        {editing ? (
          <Input
            autoFocus
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            onBlur={saveTitle}
            onKeyDown={(e) => {
              if (e.key === "Enter") saveTitle();
              if (e.key === "Escape") {
                setTitle(section.title);
                setEditing(false);
              }
            }}
            className="h-8 max-w-md text-sm font-semibold"
          />
        ) : (
          <button onClick={() => setEditing(true)} className="group flex min-w-0 items-center gap-1.5 rounded-md px-1 text-left text-sm font-semibold hover:text-accent">
            <span className="truncate">{section.title}</span>
            <PencilLine className="size-3.5 shrink-0 opacity-0 transition group-hover:opacity-100" />
          </button>
        )}
        <span className="ml-auto hidden shrink-0 text-xs text-subtle-foreground sm:inline">
          {section.lessons.length} lessons · {formatDuration(Math.round(secSeconds / 60))}
        </span>
        <Dropdown>
          <DropdownTrigger asChild>
            <Button variant="ghost" size="icon-sm" aria-label="Section actions">
              <MoreHorizontal />
            </Button>
          </DropdownTrigger>
          <DropdownContent align="end">
            <DropdownItem onSelect={() => setEditing(true)}>
              <PencilLine /> Rename
            </DropdownItem>
            <DropdownItem disabled={!canMoveUp} onSelect={() => onMoveSection(-1)}>
              <ArrowUp /> Move up
            </DropdownItem>
            <DropdownItem disabled={!canMoveDown} onSelect={() => onMoveSection(1)}>
              <ArrowDown /> Move down
            </DropdownItem>
            <DropdownSeparator />
            <DropdownItem danger onSelect={onDeleteSection}>
              <Trash2 /> Delete section
            </DropdownItem>
          </DropdownContent>
        </Dropdown>
      </div>

      <ul
        onDragOver={(e) => {
          if (!lessonDragging) return;
          e.preventDefault();
          e.stopPropagation();
          if (section.lessons.length === 0) onLessonDragOver(0);
        }}
        onDrop={(e) => {
          e.stopPropagation();
          onDrop();
        }}
        className={cn("min-h-12", lessonDragging && section.lessons.length === 0 && "bg-accent-soft")}
      >
        {section.lessons.length === 0 && !lessonDragging && <li className="px-5 py-4 text-sm text-subtle-foreground">No lessons yet — add one below or drag one here.</li>}
        {section.lessons.map((l, li) => {
          const Icon = LESSON_ICONS[l.type];
          return (
            <li key={l.id}>
              {indicator === li && <DropLine />}
              <div
                draggable
                onDragStart={(e) => {
                  e.stopPropagation();
                  e.dataTransfer.effectAllowed = "move";
                  e.dataTransfer.setData("text/plain", l.id);
                  onLessonDragStart(l.id);
                }}
                onDragEnd={onDragEnd}
                onDragOver={(e) => {
                  if (!lessonDragging) return;
                  e.preventDefault();
                  e.stopPropagation();
                  const rect = e.currentTarget.getBoundingClientRect();
                  onLessonDragOver(e.clientY > rect.top + rect.height / 2 ? li + 1 : li);
                }}
                className={cn(
                  "group flex items-center gap-3 border-b border-border px-3 py-2.5 transition-colors last:border-b-0 hover:bg-surface-2/60 sm:px-4",
                  lessonDragging === l.id && "opacity-40",
                )}
              >
                <GripVertical className="size-4 shrink-0 cursor-grab text-subtle-foreground opacity-50 group-hover:opacity-100" />
                <span className="flex size-8 shrink-0 items-center justify-center rounded-lg bg-surface-2 text-muted-foreground">
                  <Icon className="size-4" />
                </span>
                <Link href={`/studio/courses/${course.id}/lessons/${l.id}`} className="min-w-0 flex-1">
                  <div className="truncate text-sm font-medium hover:text-accent">{l.title}</div>
                  <div className="mt-0.5 flex items-center gap-2 text-xs capitalize text-subtle-foreground">
                    {l.type}
                    {l.durationSeconds > 0 && <span className="tabular-nums normal-case">· {formatSeconds(l.durationSeconds)}</span>}
                  </div>
                </Link>
                <div className="flex shrink-0 items-center gap-1.5">
                  {l.isPreview && (
                    <Badge variant="accent" size="sm">
                      <Eye /> Preview
                    </Badge>
                  )}
                  {l.type === "video" && !l.hasVideo && (
                    <Tooltip content="This video lesson has no video yet">
                      <Badge variant="warning" size="sm">
                        <AlertTriangle /> No video
                      </Badge>
                    </Tooltip>
                  )}
                  <Dropdown>
                    <DropdownTrigger asChild>
                      <Button variant="ghost" size="icon-sm" aria-label="Lesson actions">
                        <MoreHorizontal />
                      </Button>
                    </DropdownTrigger>
                    <DropdownContent align="end">
                      <DropdownItem asChild>
                        <Link href={`/studio/courses/${course.id}/lessons/${l.id}`}>
                          <PencilLine /> Edit lesson
                        </Link>
                      </DropdownItem>
                      <DropdownItem onSelect={() => onMoveLesson(l.id, -1)}>
                        <ArrowUp /> Move up
                      </DropdownItem>
                      <DropdownItem onSelect={() => onMoveLesson(l.id, 1)}>
                        <ArrowDown /> Move down
                      </DropdownItem>
                      <DropdownSeparator />
                      <DropdownItem danger onSelect={() => onDeleteLesson(l)}>
                        <Trash2 /> Delete lesson
                      </DropdownItem>
                    </DropdownContent>
                  </Dropdown>
                </div>
              </div>
              {indicator === section.lessons.length && li === section.lessons.length - 1 && <DropLine />}
            </li>
          );
        })}
      </ul>

      <div className="border-t border-border p-3">
        {adding ? (
          <form
            onSubmit={(e) => {
              e.preventDefault();
              if (lessonTitle.trim()) addLesson.mutate();
            }}
            className="flex flex-col gap-2 lg:flex-row lg:items-center"
          >
            <Segmented
              value={lessonType}
              onChange={setLessonType}
              options={[
                { value: "video", label: <><PlayCircle className="size-3.5" /> Video</> },
                { value: "article", label: <><FileText className="size-3.5" /> Article</> },
                { value: "quiz", label: <><ListChecks className="size-3.5" /> Quiz</> },
                { value: "interactive", label: <><SquareTerminal className="size-3.5" /> Interactive</> },
              ]}
            />
            <Input autoFocus value={lessonTitle} onChange={(e) => setLessonTitle(e.target.value)} placeholder="Lesson title" className="h-10 flex-1" />
            <div className="flex gap-2">
              <Button type="button" variant="ghost" onClick={() => setAdding(false)}>
                Cancel
              </Button>
              <Button type="submit" loading={addLesson.isPending} disabled={!lessonTitle.trim()}>
                Add lesson
              </Button>
            </div>
          </form>
        ) : (
          <Button variant="ghost" size="sm" onClick={() => setAdding(true)} className="text-accent hover:text-accent">
            <Plus /> Add lesson
          </Button>
        )}
      </div>
    </div>
  );
}
