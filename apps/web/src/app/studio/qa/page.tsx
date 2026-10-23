"use client";

import Link from "next/link";
import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { CheckCircle2, CornerDownRight, ExternalLink, MessageSquareText, Send } from "lucide-react";
import { PageHeader, Segmented } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { Avatar, EmptyState } from "@/components/ui/display";
import { Textarea } from "@/components/ui/input";
import { Badge } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { timeAgo } from "@/lib/utils";

interface Thread {
  id: string;
  title: string | null;
  body: string;
  createdAt: string;
  lessonId: string | null;
  lessonTitle: string | null;
  course: { id: string; title: string; slug: string };
  user: { id: string; name: string; avatarUrl: string | null };
  replies: number;
}

export default function QAInboxPage() {
  const [filter, setFilter] = useState<"unanswered" | "all">("unanswered");
  const { data, isPending } = useQuery({
    queryKey: ["admin", "discussions", filter],
    queryFn: () => api.get<{ items: Thread[] }>(`/admin/discussions${filter === "unanswered" ? "?unanswered=1" : ""}`).then((r) => r.items),
  });

  return (
    <>
      <PageHeader title="Q&A inbox" description="Questions from learners across your courses. Instructor replies are highlighted for everyone." />
      <div className="mb-5 flex items-center gap-3">
        <Segmented
          value={filter}
          onChange={setFilter}
          options={[
            { value: "unanswered", label: "Needs a reply" },
            { value: "all", label: "All questions" },
          ]}
        />
        {data && <span className="text-sm text-subtle-foreground">{data.length} threads</span>}
      </div>
      {isPending && (
        <div className="space-y-3">
          {Array.from({ length: 4 }, (_, i) => (
            <div key={i} className="skeleton h-32 rounded-2xl" />
          ))}
        </div>
      )}
      {data?.length === 0 && (
        <EmptyState
          icon={filter === "unanswered" ? <CheckCircle2 /> : <MessageSquareText />}
          title={filter === "unanswered" ? "Inbox zero" : "No questions yet"}
          description={filter === "unanswered" ? "Every question has an instructor reply. Nice work." : "Questions learners ask in the player will show up here."}
        />
      )}
      <div className="space-y-3">
        {data?.map((t) => (
          <ThreadCard key={t.id} thread={t} />
        ))}
      </div>
    </>
  );
}

function ThreadCard({ thread: t }: { thread: Thread }) {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [body, setBody] = useState("");
  const reply = useMutation({
    mutationFn: () => api.post(`/learn/courses/${t.course.id}/discussions`, { parentId: t.id, body: body.trim(), lessonId: t.lessonId }),
    onSuccess: () => {
      toast.success("Reply posted");
      setBody("");
      setOpen(false);
      qc.invalidateQueries({ queryKey: ["admin", "discussions"] });
    },
    onError: toastError,
  });
  const playerHref = t.lessonId ? `/learn/${t.course.slug}/${t.lessonId}` : `/learn/${t.course.slug}`;

  return (
    <article className="card p-5">
      <div className="flex items-start gap-3">
        <Avatar name={t.user.name} src={t.user.avatarUrl} size={36} />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-x-2 gap-y-1 text-sm">
            <span className="font-medium">{t.user.name}</span>
            <span className="text-subtle-foreground">· {timeAgo(t.createdAt)}</span>
            {t.replies > 0 ? (
              <Badge size="sm">{t.replies} repl{t.replies === 1 ? "y" : "ies"}</Badge>
            ) : (
              <Badge variant="warning" size="sm">
                Unanswered
              </Badge>
            )}
          </div>
          <div className="mt-1 flex flex-wrap items-center gap-1.5 text-xs text-subtle-foreground">
            <span className="text-accent">{t.course.title}</span>
            {t.lessonTitle && <span>· {t.lessonTitle}</span>}
          </div>
          {t.title && <h3 className="mt-3 font-semibold">{t.title}</h3>}
          <p className="mt-1.5 whitespace-pre-line text-sm leading-relaxed text-muted-foreground">{t.body}</p>

          {open ? (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                if (body.trim().length >= 2) reply.mutate();
              }}
              className="mt-4 space-y-2"
            >
              <div className="flex items-start gap-2">
                <CornerDownRight className="mt-3 size-4 shrink-0 text-subtle-foreground" />
                <Textarea autoFocus value={body} onChange={(e) => setBody(e.target.value)} rows={3} placeholder="Write a helpful answer…" />
              </div>
              <div className="flex justify-end gap-2">
                <Button type="button" variant="ghost" size="sm" onClick={() => setOpen(false)}>
                  Cancel
                </Button>
                <Button type="submit" size="sm" loading={reply.isPending} disabled={body.trim().length < 2}>
                  <Send /> Post reply
                </Button>
              </div>
            </form>
          ) : (
            <div className="mt-4 flex flex-wrap gap-2">
              <Button size="sm" variant="secondary" onClick={() => setOpen(true)}>
                <CornerDownRight /> Reply
              </Button>
              <Button size="sm" variant="ghost" asChild>
                <Link href={playerHref} target="_blank">
                  <ExternalLink /> Open in player
                </Link>
              </Button>
            </div>
          )}
        </div>
      </div>
    </article>
  );
}
