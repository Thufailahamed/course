"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowDown, ArrowUp, ExternalLink, PencilLine, Plus, Route, X } from "lucide-react";
import type { CourseCard, Level, Paginated } from "@latent/shared";
import { LEVELS, LEVEL_LABELS, slugify } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { AdminOnly, ConfirmDialog, IconDelete, PageHeader, useConfirm } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Field, Input, Select, Textarea } from "@/components/ui/input";
import { Badge, Dialog, DialogContent } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";

interface PathRow {
  id: string;
  slug: string;
  title: string;
  subtitle: string | null;
  description: string | null;
  accent: number;
  level: Level;
  courseIds: string[];
}

function useAllCourses(enabled = true) {
  return useQuery({
    queryKey: ["admin", "courses", "all"],
    queryFn: () => api.get<Paginated<CourseCard>>("/admin/courses?pageSize=100").then((r) => r.items),
    enabled,
  });
}

function PathsPage() {
  const qc = useQueryClient();
  const [editing, setEditing] = useState<PathRow | "new" | null>(null);
  const del = useConfirm<PathRow>();
  const { data, isPending } = useQuery({ queryKey: ["admin", "paths"], queryFn: () => api.get<{ items: PathRow[] }>("/admin/paths").then((r) => r.items) });
  const courses = useAllCourses();
  const byId = new Map((courses.data ?? []).map((c) => [c.id, c]));
  const remove = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/paths/${id}`),
    onSuccess: () => {
      toast.success("Path deleted");
      del.close();
      qc.invalidateQueries({ queryKey: ["admin", "paths"] });
    },
    onError: toastError,
  });

  return (
    <>
      <PageHeader
        title="Learning paths"
        description="Curated sequences of courses toward a career goal."
        actions={
          <Button onClick={() => setEditing("new")}>
            <Plus /> New path
          </Button>
        }
      />
      {isPending && (
        <div className="grid gap-4 lg:grid-cols-2">
          {Array.from({ length: 3 }, (_, i) => (
            <div key={i} className="skeleton h-56 rounded-2xl" />
          ))}
        </div>
      )}
      {data?.length === 0 && <EmptyState icon={<Route />} title="No learning paths yet" description="Group courses into a guided journey." />}
      <div className="grid gap-4 lg:grid-cols-2">
        {data?.map((p) => (
          <article key={p.id} className="card overflow-hidden">
            <div className="relative">
              <CourseCover seed={p.slug} hue={p.accent} variant="network" className="h-28" />
              <div className="absolute inset-x-0 bottom-0 flex items-end justify-between bg-gradient-to-t from-black/45 to-transparent p-4">
                <div>
                  <h3 className="text-lg font-semibold tracking-[-0.02em] text-white">{p.title}</h3>
                  {p.subtitle && <p className="line-clamp-1 text-sm text-white/75">{p.subtitle}</p>}
                </div>
                <Badge size="sm" className="border border-white/25 bg-transparent text-white/90">
                  {LEVEL_LABELS[p.level]}
                </Badge>
              </div>
            </div>
            <ol className="space-y-1.5 p-4">
              {p.courseIds.map((id, i) => (
                <li key={id} className="flex items-center gap-3 text-sm">
                  <span className="w-5 shrink-0 text-right text-xs tabular-nums text-subtle-foreground">{i + 1}.</span>
                  <span className="truncate">{byId.get(id)?.title ?? <span className="text-subtle-foreground">Loading…</span>}</span>
                </li>
              ))}
              {p.courseIds.length === 0 && <li className="text-sm text-subtle-foreground">No courses yet.</li>}
            </ol>
            <div className="flex items-center gap-2 border-t border-border px-4 py-3">
              <Button variant="secondary" size="sm" onClick={() => setEditing(p)}>
                <PencilLine /> Edit
              </Button>
              <Button variant="ghost" size="sm" asChild>
                <Link href={`/paths/${p.slug}`} target="_blank">
                  <ExternalLink /> View
                </Link>
              </Button>
              <div className="ml-auto">
                <IconDelete onClick={() => del.ask(p)} label="Delete path" />
              </div>
            </div>
          </article>
        ))}
      </div>
      <PathDialog path={editing} onClose={() => setEditing(null)} courses={courses.data ?? []} />
      <ConfirmDialog
        open={del.open}
        onOpenChange={(o) => !o && del.close()}
        title={`Delete "${del.target?.title}"?`}
        description="The courses themselves are not affected."
        confirmLabel="Delete path"
        loading={remove.isPending}
        onConfirm={() => del.target && remove.mutate(del.target.id)}
      />
    </>
  );
}

function PathDialog({ path, onClose, courses }: { path: PathRow | "new" | null; onClose: () => void; courses: CourseCard[] }) {
  const qc = useQueryClient();
  const existing = path && path !== "new" ? path : null;
  const [title, setTitle] = useState("");
  const [slug, setSlug] = useState("");
  const [subtitle, setSubtitle] = useState("");
  const [description, setDescription] = useState("");
  const [accent, setAccent] = useState(260);
  const [level, setLevel] = useState<Level>("all");
  const [ids, setIds] = useState<string[]>([]);
  const [pick, setPick] = useState("");

  useEffect(() => {
    setTitle(existing?.title ?? "");
    setSlug(existing?.slug ?? "");
    setSubtitle(existing?.subtitle ?? "");
    setDescription(existing?.description ?? "");
    setAccent(existing?.accent ?? 260);
    setLevel(existing?.level ?? "all");
    setIds(existing?.courseIds ?? []);
  }, [path]); // eslint-disable-line react-hooks/exhaustive-deps

  const byId = new Map(courses.map((c) => [c.id, c]));
  const move = (i: number, dir: -1 | 1) => {
    const j = i + dir;
    if (j < 0 || j >= ids.length) return;
    const next = [...ids];
    [next[i], next[j]] = [next[j]!, next[i]!];
    setIds(next);
  };

  const save = useMutation({
    mutationFn: () => {
      const body = { title: title.trim(), slug: slugify(slug || title), subtitle: subtitle.trim() || null, description: description.trim() || null, accent, level, courseIds: ids };
      return existing ? api.patch(`/admin/paths/${existing.id}`, body) : api.post("/admin/paths", body);
    },
    onSuccess: () => {
      toast.success(existing ? "Path updated" : "Path created");
      qc.invalidateQueries({ queryKey: ["admin", "paths"] });
      onClose();
    },
    onError: toastError,
  });

  return (
    <Dialog open={!!path} onOpenChange={(o) => !o && onClose()}>
      <DialogContent size="lg" title={existing ? "Edit learning path" : "New learning path"}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (title.trim().length >= 2) save.mutate();
          }}
          className="space-y-5"
        >
          <div className="grid gap-5 sm:grid-cols-2">
            <Field label="Title">{(p) => <Input {...p} value={title} onChange={(e) => setTitle(e.target.value)} placeholder="e.g. Computer Vision Engineer" />}</Field>
            <Field label="Slug">{(p) => <Input {...p} value={slug} onChange={(e) => setSlug(e.target.value)} placeholder={slugify(title)} className="font-mono text-[13px]" />}</Field>
          </div>
          <Field label="Subtitle" optional>
            {(p) => <Input {...p} value={subtitle} onChange={(e) => setSubtitle(e.target.value)} />}
          </Field>
          <Field label="Description" optional>
            {(p) => <Textarea {...p} rows={3} value={description} onChange={(e) => setDescription(e.target.value)} />}
          </Field>
          <div className="grid gap-5 sm:grid-cols-2">
            <Field label="Level">
              {(p) => (
                <Select {...p} value={level} onChange={(e) => setLevel(e.target.value as Level)}>
                  {LEVELS.map((l) => (
                    <option key={l} value={l}>
                      {LEVEL_LABELS[l]}
                    </option>
                  ))}
                </Select>
              )}
            </Field>
            <Field label={`Accent hue · ${accent}°`}>
              {(p) => (
                <div className="flex h-11 items-center gap-3">
                  <input {...p} type="range" min={0} max={360} value={accent} onChange={(e) => setAccent(Number(e.target.value))} className="flex-1 accent-[var(--accent)]" />
                  <CourseCover seed={slug || title || "path"} hue={accent} variant="network" className="h-9 w-16 shrink-0 rounded-md" />
                </div>
              )}
            </Field>
          </div>

          <div>
            <div className="mb-2 text-[13px] font-medium">Courses in order</div>
            <ol className="space-y-2">
              {ids.map((id, i) => {
                const c = byId.get(id);
                return (
                  <li key={id} className="flex items-center gap-3 rounded-xl border border-border bg-surface-2/40 px-3 py-2">
                    <span className="w-5 text-center text-xs font-semibold tabular-nums text-subtle-foreground">{i + 1}</span>
                    {c && <CourseCover seed={c.slug} hue={c.accent} src={c.thumbnailUrl} className="aspect-[16/10] w-12 shrink-0 rounded-md" />}
                    <span className="min-w-0 flex-1 truncate text-sm">{c?.title ?? id}</span>
                    <Button type="button" variant="ghost" size="icon-sm" disabled={i === 0} onClick={() => move(i, -1)} aria-label="Move up">
                      <ArrowUp />
                    </Button>
                    <Button type="button" variant="ghost" size="icon-sm" disabled={i === ids.length - 1} onClick={() => move(i, 1)} aria-label="Move down">
                      <ArrowDown />
                    </Button>
                    <Button type="button" variant="ghost" size="icon-sm" onClick={() => setIds(ids.filter((x) => x !== id))} aria-label="Remove">
                      <X />
                    </Button>
                  </li>
                );
              })}
            </ol>
            <div className="mt-2 flex gap-2">
              <Select value={pick} onChange={(e) => setPick(e.target.value)}>
                <option value="">Add a course…</option>
                {courses
                  .filter((c) => !ids.includes(c.id))
                  .map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.title}
                    </option>
                  ))}
              </Select>
              <Button
                type="button"
                variant="secondary"
                disabled={!pick}
                onClick={() => {
                  setIds([...ids, pick]);
                  setPick("");
                }}
              >
                <Plus /> Add
              </Button>
            </div>
          </div>

          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" loading={save.isPending} disabled={title.trim().length < 2}>
              {existing ? "Save changes" : "Create path"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export default function Page() {
  return (
    <AdminOnly>
      <PathsPage />
    </AdminOnly>
  );
}
