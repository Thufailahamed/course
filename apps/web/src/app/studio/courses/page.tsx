"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense, useEffect, useState } from "react";
import { keepPreviousData, useMutation, useQuery } from "@tanstack/react-query";
import { BookOpen, ExternalLink, PencilLine, Plus, Search } from "lucide-react";
import type { CourseCard, CourseStatus, Paginated } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { EmptyRow, money, PageHeader, Pagination, Segmented, SkeletonRows, StatusBadge, Table, TableCard, Td, Th, Tr, useDebounced } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { Field, Input } from "@/components/ui/input";
import { Dialog, DialogContent, Tooltip } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate, formatDuration, formatNumber, formatPrice } from "@/lib/utils";

type Row = CourseCard & { status: CourseStatus; revenueCents: number };

function CoursesPage() {
  const params = useSearchParams();
  const router = useRouter();
  const [status, setStatus] = useState<"" | CourseStatus>("");
  const [q, setQ] = useState("");
  const [page, setPage] = useState(1);
  const [creating, setCreating] = useState(params.get("new") === "1");
  const query = useDebounced(q);
  useEffect(() => setPage(1), [query, status]);

  const { data, isPending } = useQuery({
    queryKey: ["admin", "courses", { status, query, page }],
    queryFn: () => api.get<Paginated<Row>>(`/admin/courses?pageSize=20&page=${page}${status ? `&status=${status}` : ""}${query ? `&q=${encodeURIComponent(query)}` : ""}`),
    placeholderData: keepPreviousData,
  });

  return (
    <>
      <PageHeader
        title="Courses"
        description="Create, edit and publish your courses."
        actions={
          <Button onClick={() => setCreating(true)}>
            <Plus /> New course
          </Button>
        }
      />
      <TableCard
        toolbar={
          <>
            <Segmented
              value={status}
              onChange={setStatus}
              options={[
                { value: "", label: "All" },
                { value: "published", label: "Published" },
                { value: "draft", label: "Drafts" },
                { value: "archived", label: "Archived" },
              ]}
            />
            <div className="sm:ml-auto sm:w-72">
              <Input icon={<Search />} placeholder="Search courses" value={q} onChange={(e) => setQ(e.target.value)} className="h-9" />
            </div>
          </>
        }
        footer={data && <Pagination page={data.page} pageCount={data.pageCount} total={data.total} onPage={setPage} label="courses" />}
      >
        <Table>
          <thead>
            <tr>
              <Th>Course</Th>
              <Th>Status</Th>
              <Th align="right">Price</Th>
              <Th align="right">Students</Th>
              <Th align="right">Rating</Th>
              <Th align="right">Revenue</Th>
              <Th>Updated</Th>
              <Th align="right">
                <span className="sr-only">Actions</span>
              </Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={8} />}
            {data?.items.length === 0 && (
              <EmptyRow cols={8} icon={<BookOpen />} title={query || status ? "No courses match" : "No courses yet"} description="Create your first course to get started." />
            )}
            {data?.items.map((c) => (
              <Tr key={c.id} onClick={() => router.push(`/studio/courses/${c.id}`)}>
                <Td>
                  <div className="flex items-center gap-3">
                    <CourseCover seed={c.slug} hue={c.accent} src={c.thumbnailUrl} className="aspect-[16/10] w-16 shrink-0 rounded-lg" />
                    <div className="min-w-0">
                      <div className="line-clamp-1 font-medium">{c.title}</div>
                      <div className="mt-0.5 text-xs text-subtle-foreground">
                        {c.lessonsCount} lessons · {formatDuration(c.durationMinutes)}
                        {c.category && ` · ${c.category.name}`}
                      </div>
                    </div>
                  </div>
                </Td>
                <Td>
                  <StatusBadge status={c.status} />
                </Td>
                <Td align="right">{formatPrice(c.priceCents, c.currency)}</Td>
                <Td align="right" className="text-muted-foreground">
                  {formatNumber(c.studentsCount)}
                </Td>
                <Td align="right" className="text-muted-foreground">
                  {c.ratingAvg ? `${c.ratingAvg.toFixed(1)} (${c.ratingCount})` : "—"}
                </Td>
                <Td align="right" className="font-medium">
                  {money(c.revenueCents)}
                </Td>
                <Td className="whitespace-nowrap text-muted-foreground">{formatDate(c.updatedAt)}</Td>
                <Td align="right">
                  <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                    <Tooltip content="Edit">
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link href={`/studio/courses/${c.id}`} aria-label="Edit course">
                          <PencilLine />
                        </Link>
                      </Button>
                    </Tooltip>
                    <Tooltip content="View on site">
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link href={`/courses/${c.slug}`} target="_blank" aria-label="View on site">
                          <ExternalLink />
                        </Link>
                      </Button>
                    </Tooltip>
                  </div>
                </Td>
              </Tr>
            ))}
          </tbody>
        </Table>
      </TableCard>
      <NewCourseDialog open={creating} onOpenChange={setCreating} />
    </>
  );
}

function NewCourseDialog({ open, onOpenChange }: { open: boolean; onOpenChange: (o: boolean) => void }) {
  const router = useRouter();
  const [title, setTitle] = useState("");
  const create = useMutation({
    mutationFn: () => api.post<{ id: string; slug: string }>("/admin/courses", { title: title.trim() }),
    onSuccess: ({ id }) => {
      onOpenChange(false);
      router.push(`/studio/courses/${id}`);
    },
    onError: toastError,
  });
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent title="Create a new course" description="Give it a working title — you can change everything later.">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (title.trim().length >= 3) create.mutate();
          }}
          className="space-y-5"
        >
          <Field label="Course title" hint="At least 3 characters">
            {(p) => <Input {...p} autoFocus value={title} onChange={(e) => setTitle(e.target.value)} placeholder="e.g. Practical Reinforcement Learning" />}
          </Field>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" loading={create.isPending} disabled={title.trim().length < 3}>
              Create course
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export default function Page() {
  return (
    <Suspense>
      <CoursesPage />
    </Suspense>
  );
}
