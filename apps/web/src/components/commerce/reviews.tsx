"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { keepPreviousData, useMutation, useQuery } from "@tanstack/react-query";
import { toast } from "sonner";
import { MessageSquareText, PenLine, Star } from "lucide-react";
import type { CourseDetail, Paginated, Review } from "@latent/shared";
import { reviewSchema } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Field, Input, Textarea } from "@/components/ui/input";
import { Avatar, EmptyState, Stars } from "@/components/ui/display";
import { Dialog, DialogContent } from "@/components/ui/primitives";
import { api, ApiError, qs } from "@/lib/api";
import { cn, formatDate } from "@/lib/utils";

export function CourseReviews({ course }: { course: CourseDetail }) {
  const [rating, setRating] = useState<number | null>(null);
  const [page, setPage] = useState(1);
  const [writing, setWriting] = useState(false);
  const { data, isPending, refetch } = useQuery({
    queryKey: ["reviews", course.slug, rating, page],
    queryFn: () => api.get<Paginated<Review>>(`/courses/${course.slug}/reviews${qs({ rating, page, pageSize: 6 })}`),
    placeholderData: keepPreviousData,
  });
  const total = Object.values(course.ratingBreakdown).reduce((a, b) => a + b, 0);

  return (
    <div>
      <div className="card grid gap-8 p-6 sm:grid-cols-[auto_1fr] sm:p-8">
        <div className="flex flex-col items-center justify-center text-center sm:pr-8 sm:[border-right:1px_solid_var(--border)]">
          <div className="text-6xl font-semibold leading-none tracking-[-0.04em] tabular-nums">{course.ratingAvg ? course.ratingAvg.toFixed(1) : "—"}</div>
          <Stars value={course.ratingAvg} size={18} className="mt-2" />
          <p className="mt-2 text-sm text-muted-foreground">{course.ratingCount.toLocaleString()} ratings</p>
        </div>
        <div className="space-y-2">
          {[5, 4, 3, 2, 1].map((n) => {
            const count = course.ratingBreakdown[String(n) as "5"] ?? 0;
            const pct = total ? Math.round((count / total) * 100) : 0;
            return (
              <button
                key={n}
                onClick={() => {
                  setRating(rating === n ? null : n);
                  setPage(1);
                }}
                className={cn("flex w-full items-center gap-3 rounded-lg px-2 py-1 text-sm transition hover:bg-surface-2", rating === n && "bg-surface-2")}
                aria-pressed={rating === n}
              >
                <span className="flex w-10 items-center gap-1 text-muted-foreground">
                  {n} <Star className="size-3.5 fill-star text-star" strokeWidth={0} />
                </span>
                <span className="h-1.5 flex-1 overflow-hidden rounded-full bg-surface-3">
                  <span className="block h-full rounded-full bg-star transition-[width] duration-700" style={{ width: `${pct}%` }} />
                </span>
                <span className="w-10 text-right tabular-nums text-subtle-foreground">{pct}%</span>
              </button>
            );
          })}
        </div>
      </div>

      <div className="mt-6 flex flex-wrap items-center justify-between gap-3">
        <p className="text-sm text-muted-foreground">
          {rating ? `Showing ${rating}-star reviews` : "Most recent reviews"}
          {rating && (
            <button onClick={() => setRating(null)} className="ml-2 font-medium text-accent hover:underline">
              Show all
            </button>
          )}
        </p>
        {course.viewer?.enrolled && (
          <Button variant="secondary" size="sm" onClick={() => setWriting(true)}>
            <PenLine /> {course.viewer.reviewed ? "Edit your review" : "Write a review"}
          </Button>
        )}
      </div>

      <div className="mt-4 grid gap-4 md:grid-cols-2">
        {isPending
          ? Array.from({ length: 4 }, (_, i) => <div key={i} className="skeleton h-40 rounded-xl" />)
          : data?.items.map((r) => (
              <article key={r.id} className="card p-5">
                <div className="flex items-center gap-3">
                  <Avatar name={r.user.name} src={r.user.avatarUrl} size={38} />
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-semibold">{r.user.name}</p>
                    <div className="flex items-center gap-2">
                      <Stars value={r.rating} size={12} />
                      <span className="text-xs text-subtle-foreground">{formatDate(r.createdAt)}</span>
                    </div>
                  </div>
                </div>
                {r.title && <p className="mt-4 text-[15px] font-semibold leading-snug tracking-[-0.01em]">{r.title}</p>}
                <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">{r.body}</p>
              </article>
            ))}
      </div>
      {!isPending && !data?.items.length && <EmptyState className="mt-4" icon={<MessageSquareText />} title="No reviews yet" description="Be among the first learners to share your experience." />}
      {data && data.pageCount > 1 && (
        <div className="mt-6 flex items-center justify-center gap-3">
          <Button variant="secondary" size="sm" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>
            Previous
          </Button>
          <span className="text-sm tabular-nums text-muted-foreground">
            Page {page} of {data.pageCount}
          </span>
          <Button variant="secondary" size="sm" disabled={page >= data.pageCount} onClick={() => setPage((p) => p + 1)}>
            Next
          </Button>
        </div>
      )}

      <WriteReviewDialog
        open={writing}
        onOpenChange={setWriting}
        courseId={course.id}
        onDone={() => {
          setWriting(false);
          setRating(null);
          setPage(1);
          refetch();
        }}
      />
    </div>
  );
}

function WriteReviewDialog({ open, onOpenChange, courseId, onDone }: { open: boolean; onOpenChange: (o: boolean) => void; courseId: string; onDone: () => void }) {
  const router = useRouter();
  const [rating, setRating] = useState(5);
  const [hover, setHover] = useState(0);
  const [title, setTitle] = useState("");
  const [bodyText, setBody] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const submit = useMutation({
    mutationFn: (data: unknown) => api.post(`/courses/${courseId}/reviews`, data as Record<string, unknown>),
    onSuccess: () => {
      toast.success("Thanks for your review!");
      router.refresh();
      onDone();
    },
    onError: (e) => {
      if (e instanceof ApiError && e.fields) setErrors(e.fields);
      else toast.error(e instanceof Error ? e.message : "Couldn't post review");
    },
  });
  const labels = ["", "Poor", "Fair", "Good", "Great", "Outstanding"];

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent title="Rate this course" description="Your review helps other learners choose — and helps instructors improve.">
        <form
          className="space-y-5"
          onSubmit={(e) => {
            e.preventDefault();
            const parsed = reviewSchema.safeParse({ rating, title: title || null, body: bodyText });
            if (!parsed.success) {
              setErrors(Object.fromEntries(parsed.error.issues.map((i) => [i.path.join("."), i.message])));
              return;
            }
            setErrors({});
            submit.mutate(parsed.data);
          }}
        >
          <div className="flex flex-col items-center gap-2 rounded-xl bg-surface-2 py-5">
            <div className="flex gap-1" onMouseLeave={() => setHover(0)} role="radiogroup" aria-label="Rating">
              {[1, 2, 3, 4, 5].map((n) => (
                <button
                  type="button"
                  key={n}
                  role="radio"
                  aria-checked={rating === n}
                  aria-label={`${n} star${n > 1 ? "s" : ""}`}
                  onMouseEnter={() => setHover(n)}
                  onClick={() => setRating(n)}
                  className="p-1 transition-transform hover:scale-110"
                >
                  <Star className={cn("size-8 transition-colors", (hover || rating) >= n ? "fill-star text-star" : "text-subtle-foreground/50")} strokeWidth={1.5} />
                </button>
              ))}
            </div>
            <p className="text-sm font-medium text-muted-foreground">{labels[hover || rating]}</p>
          </div>
          <Field label="Headline" optional error={errors.title}>
            {(p) => <Input {...p} value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Sum it up in a few words" maxLength={120} />}
          </Field>
          <Field label="Your review" error={errors.body}>
            {(p) => <Textarea {...p} value={bodyText} onChange={(e) => setBody(e.target.value)} placeholder="What did you like? What could be better?" rows={5} />}
          </Field>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" loading={submit.isPending}>
              Post review
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}
