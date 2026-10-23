"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { use, useCallback, useEffect, useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ExternalLink, Layers, Rocket, Settings2, Tag } from "lucide-react";
import type { AdminCourse, CourseStatus } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { CurriculumBuilder } from "@/components/studio/curriculum";
import { DetailsPanel, diffForm, formFromCourse, PricingPanel, PublishPanel, type CourseForm } from "@/components/studio/course-form";
import { ConfirmDialog, StatusBadge } from "@/components/studio/kit";
import { useStudioUser } from "@/components/studio/shell";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/primitives";
import { api, ApiError } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

export default function CourseEditorPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const router = useRouter();
  const qc = useQueryClient();
  const { isAdmin } = useStudioUser();
  const [tab, setTab] = useState("details");
  const [confirmDelete, setConfirmDelete] = useState(false);

  const { data: course, error, isPending } = useQuery({
    queryKey: ["admin", "course", id],
    queryFn: () => api.get<AdminCourse>(`/admin/courses/${id}`),
  });

  const initial = useMemo(() => (course ? formFromCourse(course) : null), [course]);
  const [form, setForm] = useState<CourseForm | null>(null);
  useEffect(() => {
    if (initial) setForm(initial);
  }, [initial]);

  const changes = useMemo(() => (initial && form ? diffForm(initial, form) : {}), [initial, form]);
  const dirty = Object.keys(changes).length > 0;

  useEffect(() => {
    if (!dirty) return;
    const warn = (e: BeforeUnloadEvent) => e.preventDefault();
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [dirty]);

  const set = useCallback(<K extends keyof CourseForm>(key: K, value: CourseForm[K]) => setForm((f) => (f ? { ...f, [key]: value } : f)), []);

  const save = useMutation({
    mutationFn: () => api.patch<{ ok: true; slug: string }>(`/admin/courses/${id}`, changes),
    onSuccess: () => {
      toast.success("Changes saved");
      qc.invalidateQueries({ queryKey: ["admin", "course", id] });
      qc.invalidateQueries({ queryKey: ["admin", "courses"] });
    },
    onError: toastError,
  });

  const setStatus = useMutation({
    mutationFn: (status: CourseStatus) => api.patch(`/admin/courses/${id}`, { status }),
    onSuccess: (_d, status) => {
      toast.success(status === "published" ? "Course published 🎉" : status === "archived" ? "Course archived" : "Moved back to draft");
      qc.invalidateQueries({ queryKey: ["admin", "course", id] });
      qc.invalidateQueries({ queryKey: ["admin", "courses"] });
    },
    onError: toastError,
  });

  const remove = useMutation({
    mutationFn: () => api.delete(`/admin/courses/${id}`),
    onSuccess: () => {
      toast.success("Course deleted");
      qc.invalidateQueries({ queryKey: ["admin", "courses"] });
      router.push("/studio/courses");
    },
    onError: (e) => {
      setConfirmDelete(false);
      toastError(e);
    },
  });

  // Ctrl/Cmd+S saves.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "s") {
        e.preventDefault();
        if (dirty && !save.isPending) save.mutate();
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [dirty, save]);

  if (error)
    return (
      <EmptyState
        title={error instanceof ApiError && error.status === 403 ? "You can't edit this course" : "Course not found"}
        description={error.message}
        action={
          <Button asChild variant="secondary">
            <Link href="/studio/courses">Back to courses</Link>
          </Button>
        }
        className="mt-10"
      />
    );

  if (isPending || !course || !form)
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4">
          <div className="skeleton aspect-[16/10] w-28 rounded-xl" />
          <div className="space-y-2">
            <div className="skeleton h-7 w-80" />
            <div className="skeleton h-4 w-48" />
          </div>
        </div>
        <div className="skeleton h-11 w-96" />
        <div className="skeleton h-96" />
      </div>
    );

  return (
    <div className="pb-24">
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center">
        <CourseCover
          seed={form.slug || course.slug}
          hue={form.accent}
          src={form.thumbnailKey ? `/api/media/${form.thumbnailKey}` : null}
          className="aspect-[16/10] w-28 shrink-0 rounded-xl border border-border"
        />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <h1 className="truncate text-[1.6rem] leading-tight tracking-[-0.025em]">{form.title || "Untitled course"}</h1>
            <StatusBadge status={course.status} />
          </div>
          <p className="mt-1 text-sm text-muted-foreground">
            {course.lessonsCount} lessons · Updated {formatDate(course.updatedAt)}
            {course.publishedAt && ` · Published ${formatDate(course.publishedAt)}`}
          </p>
        </div>
        <div className="flex shrink-0 gap-2">
          <Button variant="secondary" asChild>
            <Link href={`/courses/${course.slug}`} target="_blank">
              <ExternalLink /> Preview
            </Link>
          </Button>
          {course.status !== "published" && (
            <Button onClick={() => setTab("publish")}>
              <Rocket /> Publish
            </Button>
          )}
        </div>
      </div>

      <Tabs value={tab} onValueChange={setTab}>
        <TabsList className="mb-6">
          <TabsTrigger value="details">
            <Settings2 /> Details
          </TabsTrigger>
          <TabsTrigger value="curriculum">
            <Layers /> Curriculum
            <span className="rounded-full bg-surface-2 px-1.5 text-[11px] tabular-nums text-muted-foreground">{course.lessonsCount}</span>
          </TabsTrigger>
          <TabsTrigger value="pricing">
            <Tag /> Pricing
          </TabsTrigger>
          <TabsTrigger value="publish">
            <Rocket /> Publish
          </TabsTrigger>
        </TabsList>
        <TabsContent value="details" className="outline-none">
          <DetailsPanel form={form} set={set} />
        </TabsContent>
        <TabsContent value="curriculum" className="outline-none">
          <CurriculumBuilder course={course} />
        </TabsContent>
        <TabsContent value="pricing" className="outline-none">
          <PricingPanel form={form} set={set} isAdmin={isAdmin} currency={course.currency} />
        </TabsContent>
        <TabsContent value="publish" className="outline-none">
          <PublishPanel course={course} form={form} dirty={dirty} onStatus={(s) => setStatus.mutate(s)} statusPending={setStatus.isPending} onDelete={() => setConfirmDelete(true)} />
        </TabsContent>
      </Tabs>

      {/* Sticky save bar */}
      <div
        className={`fixed inset-x-0 bottom-0 z-30 transition-all duration-300 lg:left-[260px] ${dirty ? "translate-y-0 opacity-100" : "pointer-events-none translate-y-full opacity-0"}`}
        aria-hidden={!dirty}
      >
        <div className="mx-auto mb-4 flex w-[calc(100%-2rem)] max-w-3xl items-center gap-3 rounded-xl border border-border bg-surface px-4 py-2.5 shadow-[0_12px_32px_-12px_oklch(0.2_0.01_265/0.28)] sm:px-5">
          <span className="size-2 shrink-0 animate-pulse rounded-full bg-warning" />
          <p className="min-w-0 flex-1 truncate text-sm">
            <span className="font-medium">Unsaved changes</span>
            <span className="hidden text-muted-foreground sm:inline"> · {Object.keys(changes).length} field{Object.keys(changes).length === 1 ? "" : "s"} edited</span>
          </p>
          <Button variant="ghost" size="sm" onClick={() => initial && setForm(initial)} disabled={save.isPending}>
            Discard
          </Button>
          <Button size="sm" onClick={() => save.mutate()} loading={save.isPending}>
            Save changes <span className="kbd hidden border-white/20 bg-white/10 text-white/80 sm:inline-flex">Ctrl S</span>
          </Button>
        </div>
      </div>

      <ConfirmDialog
        open={confirmDelete}
        onOpenChange={setConfirmDelete}
        title="Delete this course?"
        description="The course, its sections, lessons and all learner progress will be permanently deleted."
        confirmLabel="Delete permanently"
        loading={remove.isPending}
        onConfirm={() => remove.mutate()}
      />
    </div>
  );
}
