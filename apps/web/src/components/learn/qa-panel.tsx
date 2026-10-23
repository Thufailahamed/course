"use client";

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { MessageCircleQuestion, MessageSquare, Plus, Trash2 } from "lucide-react";
import type { Discussion } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Avatar, EmptyState } from "@/components/ui/display";
import { Input, Textarea } from "@/components/ui/input";
import { Badge, Skeleton } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError, useSession } from "@/lib/hooks";
import { cn, timeAgo } from "@/lib/utils";
import { useLearn } from "./learn-context";

type Author = Discussion["user"];

function AuthorLine({ user, createdAt, lessonTitle }: { user: Author; createdAt: string; lessonTitle?: string | null }) {
  const staff = user.role !== "student";
  return (
    <div className="flex min-w-0 flex-wrap items-center gap-x-2 gap-y-1 text-xs text-subtle-foreground">
      <span className="font-medium text-foreground">{user.name}</span>
      {staff && (
        <Badge variant="primary" size="sm">
          {user.role === "admin" ? "Staff" : "Instructor"}
        </Badge>
      )}
      <span>{timeAgo(createdAt)}</span>
      {lessonTitle && <span className="truncate rounded-md bg-surface-2 px-1.5 py-0.5">{lessonTitle}</span>}
    </div>
  );
}

export function QaPanel({ lessonId }: { lessonId: string }) {
  const { course } = useLearn();
  const { user } = useSession();
  const qc = useQueryClient();
  const [scope, setScope] = useState<"lesson" | "all">("lesson");
  const [composing, setComposing] = useState(false);
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [replyTo, setReplyTo] = useState<string | null>(null);
  const [reply, setReply] = useState("");

  const key = ["discussions", course.id, scope === "lesson" ? lessonId : "all"];
  const { data, isPending } = useQuery({
    queryKey: key,
    queryFn: () => api.get<{ items: Discussion[] }>(`/learn/courses/${course.id}/discussions${scope === "lesson" ? `?lessonId=${lessonId}` : ""}`).then((r) => r.items),
  });
  const refresh = () => qc.invalidateQueries({ queryKey: ["discussions", course.id] });

  const ask = useMutation({
    mutationFn: () => api.post(`/learn/courses/${course.id}/discussions`, { lessonId, title: title || null, body }),
    onSuccess: () => {
      setTitle("");
      setBody("");
      setComposing(false);
      void refresh();
    },
    onError: toastError,
  });
  const answer = useMutation({
    mutationFn: (parentId: string) => api.post(`/learn/courses/${course.id}/discussions`, { parentId, lessonId, body: reply }),
    onSuccess: () => {
      setReply("");
      setReplyTo(null);
      void refresh();
    },
    onError: toastError,
  });
  const remove = useMutation({ mutationFn: (id: string) => api.delete(`/learn/discussions/${id}`), onSuccess: refresh, onError: toastError });

  const canDelete = (u: Author) => !!user && (u.id === user.id || user.role !== "student");

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex gap-1 rounded-xl border border-border bg-surface-2 p-1 text-sm">
          {(["lesson", "all"] as const).map((s) => (
            <button
              key={s}
              onClick={() => setScope(s)}
              className={cn("h-8 rounded-lg px-3 font-medium transition", scope === s ? "bg-surface text-foreground shadow-card" : "text-muted-foreground hover:text-foreground")}
            >
              {s === "lesson" ? "This lesson" : "Whole course"}
            </button>
          ))}
        </div>
        {!composing && (
          <Button size="sm" onClick={() => setComposing(true)}>
            <Plus /> Ask a question
          </Button>
        )}
      </div>

      {composing && (
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (body.trim().length >= 2) ask.mutate();
          }}
          className="card space-y-3 p-4 sm:p-5"
        >
          <Input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Summarize your question" aria-label="Question title" maxLength={160} autoFocus />
          <Textarea value={body} onChange={(e) => setBody(e.target.value)} placeholder="Add details: what you tried, code, error messages…" aria-label="Question details" />
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" size="sm" onClick={() => setComposing(false)}>
              Cancel
            </Button>
            <Button type="submit" size="sm" loading={ask.isPending} disabled={body.trim().length < 2}>
              Post question
            </Button>
          </div>
        </form>
      )}

      {isPending ? (
        <div className="space-y-3">
          <Skeleton className="h-28" />
          <Skeleton className="h-28" />
        </div>
      ) : !data?.length ? (
        <EmptyState
          icon={<MessageCircleQuestion />}
          title={scope === "lesson" ? "No questions on this lesson yet" : "No questions yet"}
          description="Be the first to ask — instructors and fellow learners answer here."
        />
      ) : (
        <ul className="space-y-4">
          {data.map((d) => (
            <li key={d.id} className="card p-5">
              <div className="flex gap-3">
                <Avatar name={d.user.name} src={d.user.avatarUrl} size={36} />
                <div className="min-w-0 flex-1">
                  <div className="flex items-start gap-2">
                    <AuthorLine user={d.user} createdAt={d.createdAt} lessonTitle={scope === "all" ? d.lessonTitle : null} />
                    {canDelete(d.user) && (
                      <button onClick={() => remove.mutate(d.id)} className="ml-auto rounded-md p-1 text-subtle-foreground hover:bg-danger-soft hover:text-danger" aria-label="Delete question">
                        <Trash2 className="size-3.5" />
                      </button>
                    )}
                  </div>
                  {d.title && <h4 className="mt-2 font-semibold leading-snug">{d.title}</h4>}
                  <p className="mt-1.5 whitespace-pre-wrap text-sm leading-relaxed text-muted-foreground">{d.body}</p>

                  {d.replies.length > 0 && (
                    <ul className="mt-4 space-y-4 border-l-2 border-border pl-4">
                      {d.replies.map((r) => (
                        <li key={r.id} className={cn("flex gap-3", r.user.role !== "student" && "rounded-lg bg-surface-2 p-3")}>
                          <Avatar name={r.user.name} src={r.user.avatarUrl} size={28} />
                          <div className="min-w-0 flex-1">
                            <div className="flex items-start gap-2">
                              <AuthorLine user={r.user} createdAt={r.createdAt} />
                              {canDelete(r.user) && (
                                <button onClick={() => remove.mutate(r.id)} className="ml-auto rounded-md p-1 text-subtle-foreground hover:bg-danger-soft hover:text-danger" aria-label="Delete reply">
                                  <Trash2 className="size-3.5" />
                                </button>
                              )}
                            </div>
                            <p className="mt-1 whitespace-pre-wrap text-sm leading-relaxed">{r.body}</p>
                          </div>
                        </li>
                      ))}
                    </ul>
                  )}

                  {replyTo === d.id ? (
                    <form
                      onSubmit={(e) => {
                        e.preventDefault();
                        if (reply.trim().length >= 2) answer.mutate(d.id);
                      }}
                      className="mt-4 space-y-2"
                    >
                      <Textarea value={reply} onChange={(e) => setReply(e.target.value)} placeholder="Write a reply…" aria-label="Reply" autoFocus className="min-h-20" />
                      <div className="flex justify-end gap-2">
                        <Button type="button" size="sm" variant="ghost" onClick={() => setReplyTo(null)}>
                          Cancel
                        </Button>
                        <Button type="submit" size="sm" loading={answer.isPending} disabled={reply.trim().length < 2}>
                          Reply
                        </Button>
                      </div>
                    </form>
                  ) : (
                    <button
                      onClick={() => {
                        setReplyTo(d.id);
                        setReply("");
                      }}
                      className="mt-3 inline-flex items-center gap-1.5 text-xs font-medium text-muted-foreground hover:text-foreground"
                    >
                      <MessageSquare className="size-3.5" />
                      {d.replies.length ? `${d.replies.length} ${d.replies.length === 1 ? "reply" : "replies"} · Reply` : "Reply"}
                    </button>
                  )}
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
