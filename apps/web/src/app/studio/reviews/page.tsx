"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { keepPreviousData, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Star } from "lucide-react";
import type { Paginated, Review } from "@latent/shared";
import { ConfirmDialog, IconDelete, PageHeader, Pagination, Segmented, useConfirm } from "@/components/studio/kit";
import { Avatar, EmptyState, Stars } from "@/components/ui/display";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

type Row = Review & { course: { id: string; title: string; slug: string } };

export default function ReviewsPage() {
  const qc = useQueryClient();
  const [rating, setRating] = useState("");
  const [page, setPage] = useState(1);
  const confirm = useConfirm<Row>();
  useEffect(() => setPage(1), [rating]);

  const { data, isPending } = useQuery({
    queryKey: ["admin", "reviews", rating, page],
    queryFn: () => api.get<Paginated<Row>>(`/admin/reviews?page=${page}&pageSize=20${rating ? `&rating=${rating}` : ""}`),
    placeholderData: keepPreviousData,
  });
  const remove = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/reviews/${id}`),
    onSuccess: () => {
      toast.success("Review removed");
      confirm.close();
      qc.invalidateQueries({ queryKey: ["admin", "reviews"] });
    },
    onError: toastError,
  });

  return (
    <>
      <PageHeader title="Reviews" description="What learners are saying. Remove reviews that break the community guidelines." />
      <div className="mb-5 overflow-x-auto">
        <Segmented
          value={rating}
          onChange={setRating}
          options={[
            { value: "", label: "All ratings" },
            ...[5, 4, 3, 2, 1].map((n) => ({
              value: String(n),
              label: (
                <>
                  {n} <Star className="size-3 fill-star text-star" />
                </>
              ),
            })),
          ]}
        />
      </div>
      {isPending && (
        <div className="grid gap-3 md:grid-cols-2">
          {Array.from({ length: 6 }, (_, i) => (
            <div key={i} className="skeleton h-40 rounded-2xl" />
          ))}
        </div>
      )}
      {data?.items.length === 0 && <EmptyState icon={<Star />} title="No reviews" description="No reviews match this filter yet." />}
      <div className="grid gap-3 md:grid-cols-2">
        {data?.items.map((r) => (
          <article key={r.id} className="card flex flex-col p-5">
            <div className="flex items-start gap-3">
              <Avatar name={r.user.name} src={r.user.avatarUrl} size={36} />
              <div className="min-w-0 flex-1">
                <div className="truncate text-sm font-medium">{r.user.name}</div>
                <div className="mt-0.5 flex items-center gap-2 text-xs text-subtle-foreground">
                  <Stars value={r.rating} size={12} /> {formatDate(r.createdAt)}
                </div>
              </div>
              <IconDelete onClick={() => confirm.ask(r)} label="Delete review" />
            </div>
            {r.title && <h3 className="mt-3 text-sm font-semibold">{r.title}</h3>}
            <p className="mt-1.5 line-clamp-4 text-sm leading-relaxed text-muted-foreground">{r.body}</p>
            <Link href={`/courses/${r.course.slug}`} target="_blank" className="mt-auto pt-3 text-xs font-medium text-accent hover:underline">
              {r.course.title}
            </Link>
          </article>
        ))}
      </div>
      {data && data.total > 0 && (
        <div className="card mt-4 px-4 py-3">
          <Pagination page={data.page} pageCount={data.pageCount} total={data.total} onPage={setPage} label="reviews" />
        </div>
      )}
      <ConfirmDialog
        open={confirm.open}
        onOpenChange={(o) => !o && confirm.close()}
        title="Delete this review?"
        description="The course rating will be recalculated. This can't be undone."
        confirmLabel="Delete review"
        loading={remove.isPending}
        onConfirm={() => confirm.target && remove.mutate(confirm.target.id)}
      />
    </>
  );
}
