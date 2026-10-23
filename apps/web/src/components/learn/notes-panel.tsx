"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Clock, NotebookPen, Pencil, Trash2 } from "lucide-react";
import type { Note } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Textarea } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { cn, formatSeconds, timeAgo } from "@/lib/utils";
import { useLearn } from "./learn-context";

export function NotesPanel({ lessonId, isVideo }: { lessonId: string; isVideo: boolean }) {
  const { course, slug, player } = useLearn();
  const qc = useQueryClient();
  const router = useRouter();
  const key = ["notes", course.id];
  const [scope, setScope] = useState<"lesson" | "all">("lesson");
  const [draft, setDraft] = useState("");
  const [stamp, setStamp] = useState<number | null>(null);
  const [editing, setEditing] = useState<{ id: string; body: string } | null>(null);

  const { data: notes, isPending } = useQuery({
    queryKey: key,
    queryFn: () => api.get<{ items: Note[] }>(`/learn/courses/${course.id}/notes`).then((r) => r.items),
  });

  const create = useMutation({
    mutationFn: () => api.post(`/learn/courses/${course.id}/notes`, { lessonId, body: draft, positionSeconds: isVideo ? Math.floor(stamp ?? player.current?.getTime() ?? 0) : null }),
    onSuccess: () => {
      setDraft("");
      setStamp(null);
      void qc.invalidateQueries({ queryKey: key });
    },
    onError: toastError,
  });
  const update = useMutation({
    mutationFn: (n: { id: string; body: string }) => api.patch(`/learn/notes/${n.id}`, { body: n.body }),
    onSuccess: () => {
      setEditing(null);
      void qc.invalidateQueries({ queryKey: key });
    },
    onError: toastError,
  });
  const remove = useMutation({
    mutationFn: (id: string) => api.delete(`/learn/notes/${id}`),
    onMutate: (id) => qc.setQueryData<Note[]>(key, (prev) => prev?.filter((n) => n.id !== id)),
    onError: (e) => {
      toastError(e);
      void qc.invalidateQueries({ queryKey: key });
    },
  });

  const visible = (notes ?? []).filter((n) => scope === "all" || n.lessonId === lessonId);

  const jump = (n: Note) => {
    if (n.lessonId === lessonId) {
      if (n.positionSeconds !== null) player.current?.seek(n.positionSeconds);
    } else router.push(`/learn/${slug}/${n.lessonId}${n.positionSeconds ? `?t=${n.positionSeconds}` : ""}`);
  };

  return (
    <div className="space-y-6">
      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (draft.trim()) create.mutate();
        }}
        className="card overflow-hidden"
      >
        <Textarea
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onFocus={() => isVideo && stamp === null && setStamp(Math.floor(player.current?.getTime() ?? 0))}
          onKeyDown={(e) => {
            if (e.key === "Enter" && (e.metaKey || e.ctrlKey) && draft.trim()) create.mutate();
          }}
          placeholder="Write a note… (Ctrl + Enter to save)"
          aria-label="New note"
          className="min-h-24 rounded-none border-0 bg-transparent shadow-none focus:ring-0"
        />
        <div className="flex items-center justify-between gap-3 border-t border-border bg-surface-2/50 px-3 py-2">
          {isVideo ? (
            <span className="inline-flex items-center gap-1.5 rounded-lg bg-accent-soft px-2 py-1 font-mono text-xs text-accent">
              <Clock className="size-3.5" /> at {formatSeconds(stamp ?? player.current?.getTime() ?? 0)}
            </span>
          ) : (
            <span className="text-xs text-subtle-foreground">Notes are private to you</span>
          )}
          <Button size="sm" type="submit" disabled={!draft.trim()} loading={create.isPending}>
            Save note
          </Button>
        </div>
      </form>

      <div className="flex items-center justify-between">
        <div className="flex gap-1 rounded-xl border border-border bg-surface-2 p-1 text-sm">
          {(["lesson", "all"] as const).map((s) => (
            <button
              key={s}
              onClick={() => setScope(s)}
              className={cn("h-8 rounded-lg px-3 font-medium transition", scope === s ? "bg-surface text-foreground shadow-card" : "text-muted-foreground hover:text-foreground")}
            >
              {s === "lesson" ? "This lesson" : "All lessons"}
            </button>
          ))}
        </div>
        <span className="text-xs text-subtle-foreground">{visible.length} notes</span>
      </div>

      {isPending ? (
        <div className="space-y-3">
          <Skeleton className="h-20" />
          <Skeleton className="h-20" />
        </div>
      ) : visible.length === 0 ? (
        <EmptyState icon={<NotebookPen />} title="No notes yet" description={isVideo ? "Notes are stamped with the video time — click one later to jump right back." : "Capture key ideas as you read. They're private to you."} />
      ) : (
        <ul className="space-y-3">
          {visible.map((n) => (
            <li key={n.id} className="group card p-4">
              <div className="flex items-center gap-2 text-xs text-subtle-foreground">
                {n.positionSeconds !== null && (
                  <button onClick={() => jump(n)} className="inline-flex items-center gap-1 rounded-md bg-accent-soft px-1.5 py-0.5 font-mono text-accent hover:bg-accent hover:text-white">
                    <Clock className="size-3" /> {formatSeconds(n.positionSeconds)}
                  </button>
                )}
                {scope === "all" && n.lessonTitle && (
                  <button onClick={() => jump(n)} className="truncate hover:text-foreground">
                    {n.lessonTitle}
                  </button>
                )}
                <span className="ml-auto shrink-0">{timeAgo(n.createdAt)}</span>
                <div className="flex shrink-0 gap-0.5 opacity-0 transition group-hover:opacity-100 group-focus-within:opacity-100">
                  <button onClick={() => setEditing({ id: n.id, body: n.body })} className="rounded-md p-1 hover:bg-surface-2 hover:text-foreground" aria-label="Edit note">
                    <Pencil className="size-3.5" />
                  </button>
                  <button onClick={() => remove.mutate(n.id)} className="rounded-md p-1 hover:bg-danger-soft hover:text-danger" aria-label="Delete note">
                    <Trash2 className="size-3.5" />
                  </button>
                </div>
              </div>
              {editing?.id === n.id ? (
                <div className="mt-3 space-y-2">
                  <Textarea value={editing.body} onChange={(e) => setEditing({ ...editing, body: e.target.value })} autoFocus aria-label="Edit note" />
                  <div className="flex justify-end gap-2">
                    <Button size="sm" variant="ghost" onClick={() => setEditing(null)}>
                      Cancel
                    </Button>
                    <Button size="sm" onClick={() => update.mutate(editing)} loading={update.isPending} disabled={!editing.body.trim()}>
                      Save
                    </Button>
                  </div>
                </div>
              ) : (
                <p className="mt-2 whitespace-pre-wrap text-sm leading-relaxed">{n.body}</p>
              )}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
