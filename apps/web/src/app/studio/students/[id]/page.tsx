"use client";

import Link from "next/link";
import { use, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowLeft, BookOpen, Calendar, Mail, Plus, Receipt, Sparkles } from "lucide-react";
import type { CourseCard, Order, Paginated, Role } from "@latent/shared";
import { AdminOnly, ConfirmDialog, money, useConfirm } from "@/components/studio/kit";
import { RoleSelect } from "@/components/studio/role-select";
import { OrderStatusBadge } from "@/components/studio/order-status";
import { useStudioUser } from "@/components/studio/shell";
import { Button } from "@/components/ui/button";
import { Avatar, EmptyState, ProgressBar } from "@/components/ui/display";
import { Select } from "@/components/ui/input";
import { Badge, Card, CardHeader, Dialog, DialogContent } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

interface Detail {
  user: { id: string; name: string; email: string; role: Role; avatarUrl: string | null; headline: string | null; createdAt: string };
  enrollments: { courseId: string; title: string; slug: string; progressPercent: number; source: string; createdAt: string }[];
  orders: Order[];
  subscription: { plan: string; status: string; currentPeriodEnd: string | null; cancelAtPeriodEnd: boolean } | null;
}

function StudentDetail({ id }: { id: string }) {
  const qc = useQueryClient();
  const { user: me } = useStudioUser();
  const [granting, setGranting] = useState(false);
  const [courseId, setCourseId] = useState("");
  const revoke = useConfirm<Detail["enrollments"][number]>();

  const { data, isPending, error } = useQuery({ queryKey: ["admin", "user", id], queryFn: () => api.get<Detail>(`/admin/users/${id}`) });
  const courses = useQuery({
    queryKey: ["admin", "courses", "all"],
    queryFn: () => api.get<Paginated<CourseCard>>("/admin/courses?pageSize=100").then((r) => r.items),
    enabled: granting,
  });

  const refresh = () => qc.invalidateQueries({ queryKey: ["admin", "user", id] });
  const grant = useMutation({
    mutationFn: () => api.post(`/admin/users/${id}/enrollments`, { courseId }),
    onSuccess: () => {
      toast.success("Access granted");
      setGranting(false);
      setCourseId("");
      refresh();
    },
    onError: toastError,
  });
  const remove = useMutation({
    mutationFn: (cid: string) => api.delete(`/admin/users/${id}/enrollments/${cid}`),
    onSuccess: () => {
      toast.success("Access revoked");
      revoke.close();
      refresh();
    },
    onError: toastError,
  });

  if (error) return <EmptyState title="User not found" description={error.message} className="mt-10" />;
  if (isPending || !data)
    return (
      <div className="space-y-6">
        <div className="skeleton h-28 rounded-2xl" />
        <div className="skeleton h-72 rounded-2xl" />
      </div>
    );

  const { user, enrollments, orders, subscription } = data;
  const owned = new Set(enrollments.map((e) => e.courseId));
  const spent = orders.filter((o) => o.status === "paid").reduce((s, o) => s + o.totalCents, 0);

  return (
    <>
      <Link href="/studio/students" className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground">
        <ArrowLeft className="size-4" /> All students
      </Link>
      <Card className="mb-6 flex flex-col gap-5 p-6 sm:flex-row sm:items-center">
        <Avatar name={user.name} src={user.avatarUrl} size={64} />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <h1 className="text-[1.6rem] leading-tight tracking-[-0.025em]">{user.name}</h1>
            {subscription && ["active", "trialing"].includes(subscription.status) && (
              <Badge variant="primary">
                <Sparkles /> Pro · {subscription.plan}
              </Badge>
            )}
          </div>
          {user.headline && <p className="mt-0.5 text-sm text-muted-foreground">{user.headline}</p>}
          <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm text-subtle-foreground">
            <a href={`mailto:${user.email}`} className="inline-flex items-center gap-1.5 hover:text-foreground">
              <Mail className="size-3.5" /> {user.email}
            </a>
            <span className="inline-flex items-center gap-1.5">
              <Calendar className="size-3.5" /> Joined {formatDate(user.createdAt)}
            </span>
          </div>
        </div>
        <div className="flex items-center gap-6">
          <div>
            <div className="text-xs text-subtle-foreground">Lifetime spend</div>
            <div className="text-2xl font-semibold tabular-nums tracking-[-0.03em]">{money(spent)}</div>
          </div>
          <div>
            <div className="mb-1 text-xs text-subtle-foreground">Role</div>
            <RoleSelect userId={user.id} role={user.role} disabled={user.id === me.id} />
          </div>
        </div>
      </Card>

      <div className="grid gap-6 xl:grid-cols-2">
        <Card className="overflow-hidden">
          <CardHeader
            title="Course access"
            description={`${enrollments.length} enrollments`}
            action={
              <Button size="sm" variant="secondary" onClick={() => setGranting(true)}>
                <Plus /> Grant access
              </Button>
            }
          />
          {enrollments.length === 0 ? (
            <EmptyState icon={<BookOpen />} title="Not enrolled in any course" className="m-5 py-10" />
          ) : (
            <ul className="divide-y divide-border">
              {enrollments.map((e) => (
                <li key={e.courseId} className="flex items-center gap-4 px-5 py-3.5">
                  <div className="min-w-0 flex-1">
                    <Link href={`/courses/${e.slug}`} target="_blank" className="line-clamp-1 text-sm font-medium hover:text-accent">
                      {e.title}
                    </Link>
                    <div className="mt-1.5 flex items-center gap-3">
                      <ProgressBar value={e.progressPercent} size="sm" className="max-w-40" />
                      <span className="text-xs tabular-nums text-subtle-foreground">{e.progressPercent}%</span>
                      <Badge size="sm" className="capitalize">
                        {e.source}
                      </Badge>
                    </div>
                  </div>
                  <Button variant="ghost" size="xs" className="hover:bg-danger-soft hover:text-danger" onClick={() => revoke.ask(e)}>
                    Revoke
                  </Button>
                </li>
              ))}
            </ul>
          )}
        </Card>

        <Card className="overflow-hidden">
          <CardHeader title="Orders" description={`${orders.length} total`} />
          {orders.length === 0 ? (
            <EmptyState icon={<Receipt />} title="No orders" className="m-5 py-10" />
          ) : (
            <ul className="divide-y divide-border">
              {orders.map((o) => (
                <li key={o.id} className="flex items-center gap-4 px-5 py-3.5">
                  <div className="min-w-0 flex-1">
                    <div className="line-clamp-1 text-sm font-medium">{o.items.map((i) => i.title).join(", ")}</div>
                    <div className="mt-0.5 font-mono text-xs text-subtle-foreground">
                      {o.id} · {formatDate(o.createdAt)}
                    </div>
                  </div>
                  <OrderStatusBadge status={o.status} />
                  <span className="w-20 text-right text-sm font-medium tabular-nums">{money(o.totalCents, o.currency)}</span>
                </li>
              ))}
            </ul>
          )}
          {subscription && (
            <div className="border-t border-border px-5 py-4 text-sm">
              <span className="text-subtle-foreground">Subscription: </span>
              <span className="font-medium capitalize">
                {subscription.plan} · {subscription.status}
              </span>
              {subscription.currentPeriodEnd && (
                <span className="text-subtle-foreground">
                  {" "}
                  · {subscription.cancelAtPeriodEnd ? "ends" : "renews"} {formatDate(subscription.currentPeriodEnd)}
                </span>
              )}
            </div>
          )}
        </Card>
      </div>

      <Dialog open={granting} onOpenChange={setGranting}>
        <DialogContent title="Grant course access" description={`Enroll ${user.name} in a course for free.`}>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              if (courseId) grant.mutate();
            }}
            className="space-y-5"
          >
            <Select value={courseId} onChange={(e) => setCourseId(e.target.value)} disabled={courses.isPending}>
              <option value="">{courses.isPending ? "Loading courses…" : "Choose a course"}</option>
              {courses.data
                ?.filter((c) => !owned.has(c.id))
                .map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.title}
                  </option>
                ))}
            </Select>
            <div className="flex justify-end gap-2">
              <Button type="button" variant="secondary" onClick={() => setGranting(false)}>
                Cancel
              </Button>
              <Button type="submit" disabled={!courseId} loading={grant.isPending}>
                Grant access
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
      <ConfirmDialog
        open={revoke.open}
        onOpenChange={(o) => !o && revoke.close()}
        title="Revoke access?"
        description={`${user.name} will lose access to "${revoke.target?.title}". Paid orders are not refunded automatically.`}
        confirmLabel="Revoke access"
        loading={remove.isPending}
        onConfirm={() => revoke.target && remove.mutate(revoke.target.courseId)}
      />
    </>
  );
}

export default function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  return (
    <AdminOnly>
      <StudentDetail id={id} />
    </AdminOnly>
  );
}
