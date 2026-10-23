"use client";

import Link from "next/link";
import { useState } from "react";
import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { ArrowRight, BookOpen, CreditCard, GraduationCap, Plus, Receipt, Sparkles, Star, Table2, Users } from "lucide-react";
import type { AdminOverview } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { TimeSeriesChart } from "@/components/studio/charts";
import { Kpi, money, PageHeader, Segmented } from "@/components/studio/kit";
import { useStudioUser } from "@/components/studio/shell";
import { Button } from "@/components/ui/button";
import { Avatar, Stars } from "@/components/ui/display";
import { Badge } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { cn, formatNumber, formatPrice, timeAgo } from "@/lib/utils";

type Range = "7" | "30" | "90";

const compactMoney = (cents: number) => {
  const d = cents / 100;
  if (d >= 1000) return `$${new Intl.NumberFormat("en-US", { notation: "compact", maximumFractionDigits: 1 }).format(d)}`;
  return `$${Math.round(d)}`;
};

function ChartCard({ title, subtitle, children, table, onToggleTable }: { title: string; subtitle: React.ReactNode; children: React.ReactNode; table: boolean; onToggleTable: () => void }) {
  return (
    <div className="card p-5 sm:p-6">
      <div className="mb-5 flex items-start justify-between gap-4">
        <div>
          <h3 className="text-[15px] font-semibold">{title}</h3>
          <div className="mt-1 text-sm text-muted-foreground">{subtitle}</div>
        </div>
        <Button variant="ghost" size="xs" onClick={onToggleTable} aria-pressed={table}>
          <Table2 /> {table ? "Chart" : "Table"}
        </Button>
      </div>
      {children}
    </div>
  );
}

export default function StudioOverview() {
  const { user, isAdmin } = useStudioUser();
  const [range, setRange] = useState<Range>("30");
  const [revTable, setRevTable] = useState(false);
  const [enrTable, setEnrTable] = useState(false);
  const { data, isPending, isFetching } = useQuery({
    queryKey: ["admin", "overview", range],
    queryFn: () => api.get<AdminOverview>(`/admin/overview?days=${range}`),
    placeholderData: keepPreviousData,
  });
  const k = data?.kpis;
  const period = `vs previous ${range} days`;
  const totalRevenue = data?.series.reduce((s, d) => s + d.revenueCents, 0) ?? 0;
  const totalEnroll = data?.series.reduce((s, d) => s + d.enrollments, 0) ?? 0;

  return (
    <>
      <PageHeader
        title={
          <>
            Good to see you, {user.name.replace(/^Dr\.\s*/, "").split(" ")[0]}
          </>
        }
        description={isAdmin ? "Here's how the academy is performing." : "Here's how your courses are performing."}
        actions={
          <Button asChild>
            <Link href="/studio/courses?new=1">
              <Plus /> New course
            </Link>
          </Button>
        }
      />

      {/* Filters: one row, above everything they scope */}
      <div className="mb-6 flex flex-wrap items-center gap-3">
        <Segmented
          value={range}
          onChange={setRange}
          options={[
            { value: "7", label: "Last 7 days" },
            { value: "30", label: "Last 30 days" },
            { value: "90", label: "Last 90 days" },
          ]}
        />
        {isFetching && !isPending && <span className="text-xs text-subtle-foreground">Updating…</span>}
      </div>

      <div className={cn("grid gap-4 sm:grid-cols-2 xl:grid-cols-4", isFetching && !isPending && "opacity-60 transition-opacity")}>
        <Kpi label="Revenue" icon={<CreditCard />} loading={isPending} value={money(k?.revenueCents ?? 0)} current={k?.revenueCents} previous={k?.revenuePrevCents} periodLabel={period} />
        <Kpi label="Orders" icon={<Receipt />} loading={isPending} value={formatNumber(k?.orders ?? 0)} current={k?.orders} previous={k?.ordersPrev} periodLabel={period} />
        <Kpi label="Enrollments" icon={<GraduationCap />} loading={isPending} value={formatNumber(k?.enrollments ?? 0)} current={k?.enrollments} previous={k?.enrollmentsPrev} periodLabel={period} />
        <Kpi label="New students" icon={<Users />} loading={isPending} value={formatNumber(k?.newStudents ?? 0)} current={k?.newStudents} previous={k?.newStudentsPrev} periodLabel={period} />
      </div>

      <div className="card mt-4 grid divide-y divide-border sm:grid-cols-3 sm:divide-x sm:divide-y-0">
        {[
          { label: "Active Pro members", value: formatNumber(k?.activeSubscriptions ?? 0), icon: <Sparkles /> },
          { label: "Published courses", value: formatNumber(k?.publishedCourses ?? 0), icon: <BookOpen /> },
          { label: "Average rating", value: k?.avgRating ? `${k.avgRating.toFixed(1)} / 5` : "—", icon: <Star /> },
        ].map((s) => (
          <div key={s.label} className="flex items-center gap-3.5 px-5 py-4">
            <span className="flex size-8 items-center justify-center rounded-md border border-border bg-surface-2 text-muted-foreground [&_svg]:size-3.5">{s.icon}</span>
            <div>
              <div className="text-[12.5px] text-muted-foreground">{s.label}</div>
              {isPending ? <div className="skeleton mt-1 h-5 w-16" /> : <div className="text-xl font-semibold tabular-nums leading-tight tracking-[-0.025em]">{s.value}</div>}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-6 grid gap-4 xl:grid-cols-5">
        <div className="xl:col-span-3">
          <ChartCard
            title="Revenue"
            subtitle={
              <>
                <span className="font-medium text-foreground">{money(totalRevenue)}</span> in the last {range} days
              </>
            }
            table={revTable}
            onToggleTable={() => setRevTable((t) => !t)}
          >
            {isPending ? (
              <div className="skeleton h-[260px]" />
            ) : (
              <TimeSeriesChart
                kind="area"
                seriesLabel="Revenue"
                data={(data?.series ?? []).map((d) => ({ date: d.date, value: d.revenueCents }))}
                formatValue={(v) => money(v)}
                formatTick={compactMoney}
                dim={isFetching}
                showTable={revTable}
              />
            )}
          </ChartCard>
        </div>
        <div className="xl:col-span-2">
          <ChartCard
            title="Enrollments"
            subtitle={
              <>
                <span className="font-medium text-foreground">{formatNumber(totalEnroll)}</span> new enrollments
              </>
            }
            table={enrTable}
            onToggleTable={() => setEnrTable((t) => !t)}
          >
            {isPending ? (
              <div className="skeleton h-[260px]" />
            ) : (
              <TimeSeriesChart
                kind="columns"
                seriesLabel="Enrollments"
                data={(data?.series ?? []).map((d) => ({ date: d.date, value: d.enrollments }))}
                formatValue={(v) => `${v.toLocaleString()} enrollment${v === 1 ? "" : "s"}`}
                formatTick={(v) => formatNumber(v)}
                dim={isFetching}
                showTable={enrTable}
              />
            )}
          </ChartCard>
        </div>
      </div>

      <div className="mt-6 grid gap-4 xl:grid-cols-5">
        <div className="card overflow-hidden xl:col-span-3">
          <div className="flex items-center justify-between border-b border-border px-5 py-4">
            <h3 className="text-[15px] font-semibold">Top courses</h3>
            <Button variant="ghost" size="xs" asChild>
              <Link href="/studio/courses">
                All courses <ArrowRight />
              </Link>
            </Button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full min-w-[520px] text-[13px]">
              <thead>
                <tr className="bg-surface-2 text-xs text-muted-foreground">
                  <th className="px-5 py-2.5 text-left font-medium">Course</th>
                  <th className="px-5 py-2.5 text-right font-medium">Students</th>
                  <th className="px-5 py-2.5 text-right font-medium">Rating</th>
                  <th className="px-5 py-2.5 text-right font-medium">Revenue</th>
                </tr>
              </thead>
              <tbody>
                {isPending
                  ? Array.from({ length: 5 }, (_, i) => (
                      <tr key={i} className="border-t border-border">
                        <td className="px-5 py-3" colSpan={4}>
                          <div className="skeleton h-8" />
                        </td>
                      </tr>
                    ))
                  : data?.topCourses.map((c, i) => (
                      <tr key={c.id} className="border-t border-border transition-colors hover:bg-surface-2/50">
                        <td className="px-5 py-3">
                          <Link href={`/studio/courses/${c.id}`} className="flex items-center gap-3">
                            <span className="w-4 text-xs tabular-nums text-subtle-foreground">{i + 1}</span>
                            <CourseCover seed={c.slug} hue={c.accent} className="aspect-[16/10] w-14 shrink-0 rounded-md" />
                            <span className="line-clamp-1 font-medium hover:text-accent">{c.title}</span>
                          </Link>
                        </td>
                        <td className="px-5 py-3 text-right tabular-nums text-muted-foreground">{formatNumber(c.enrollments)}</td>
                        <td className="px-5 py-3 text-right tabular-nums text-muted-foreground">{c.ratingAvg ? c.ratingAvg.toFixed(1) : "—"}</td>
                        <td className="px-5 py-3 text-right font-medium tabular-nums">{money(c.revenueCents)}</td>
                      </tr>
                    ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="card overflow-hidden xl:col-span-2">
          <div className="flex items-center justify-between border-b border-border px-5 py-4">
            <h3 className="text-[15px] font-semibold">{isAdmin ? "Recent orders" : "Recent reviews"}</h3>
            <Button variant="ghost" size="xs" asChild>
              <Link href={isAdmin ? "/studio/orders" : "/studio/reviews"}>
                View all <ArrowRight />
              </Link>
            </Button>
          </div>
          {isAdmin ? (
            <ul className="divide-y divide-border">
              {isPending &&
                Array.from({ length: 5 }, (_, i) => (
                  <li key={i} className="px-5 py-3">
                    <div className="skeleton h-9" />
                  </li>
                ))}
              {data?.recentOrders.map((o) => (
                <li key={o.id} className="flex items-center gap-3 px-5 py-3">
                  <Avatar name={o.user?.name ?? "?"} size={32} />
                  <div className="min-w-0 flex-1">
                    <div className="truncate text-sm font-medium">{o.user?.name ?? "Unknown"}</div>
                    <div className="truncate text-xs text-subtle-foreground">{o.items.map((i) => i.title).join(", ")}</div>
                  </div>
                  <div className="text-right">
                    <div className="text-sm font-medium tabular-nums">{money(o.totalCents, o.currency)}</div>
                    <div className="text-xs text-subtle-foreground">{timeAgo(o.paidAt ?? o.createdAt)}</div>
                  </div>
                </li>
              ))}
              {!isPending && !data?.recentOrders.length && <li className="px-5 py-10 text-center text-sm text-muted-foreground">No orders yet.</li>}
            </ul>
          ) : (
            <ReviewList reviews={data?.recentReviews ?? []} loading={isPending} />
          )}
        </div>
      </div>

      {isAdmin && (
        <div className="card mt-6 overflow-hidden">
          <div className="flex items-center justify-between border-b border-border px-5 py-4">
            <h3 className="text-[15px] font-semibold">Latest reviews</h3>
            <Button variant="ghost" size="xs" asChild>
              <Link href="/studio/reviews">
                Moderate <ArrowRight />
              </Link>
            </Button>
          </div>
          <ReviewList reviews={data?.recentReviews ?? []} loading={isPending} grid />
        </div>
      )}
    </>
  );
}

function ReviewList({ reviews, loading, grid }: { reviews: AdminOverview["recentReviews"]; loading: boolean; grid?: boolean }) {
  if (loading)
    return (
      <div className="space-y-3 p-5">
        {Array.from({ length: 3 }, (_, i) => (
          <div key={i} className="skeleton h-16" />
        ))}
      </div>
    );
  if (!reviews.length) return <p className="px-5 py-10 text-center text-sm text-muted-foreground">No reviews yet.</p>;
  return (
    <ul className={cn(grid ? "grid gap-px bg-border sm:grid-cols-2 lg:grid-cols-3" : "divide-y divide-border")}>
      {reviews.map((r) => (
        <li key={r.id} className="bg-surface px-5 py-4">
          <div className="flex items-center gap-2.5">
            <Avatar name={r.user.name} src={r.user.avatarUrl} size={28} />
            <div className="min-w-0 flex-1">
              <div className="truncate text-sm font-medium">{r.user.name}</div>
              <div className="truncate text-xs text-subtle-foreground">{r.course.title}</div>
            </div>
            <Stars value={r.rating} size={12} />
          </div>
          {r.title && <p className="mt-2.5 text-sm font-medium">{r.title}</p>}
          <p className="mt-1 line-clamp-2 text-sm text-muted-foreground">{r.body}</p>
          <div className="mt-2 flex items-center gap-2">
            <Badge size="sm">{timeAgo(r.createdAt)}</Badge>
          </div>
        </li>
      ))}
    </ul>
  );
}
