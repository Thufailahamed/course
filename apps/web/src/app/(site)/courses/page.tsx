import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { ArrowUpRight, ChevronLeft, ChevronRight, Layers, SearchX } from "lucide-react";
import type { Category, CourseCard as Course, Paginated } from "@latent/shared";
import { CourseCard, CourseCardSkeleton } from "@/components/course-card";
import { ActiveFilters, CatalogSearch, FilterPanel, MobileFilters, SortSelect } from "@/components/commerce/catalog-filters";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { serverApi, serverApiSafe } from "@/lib/server";
import { cn } from "@/lib/utils";

export const metadata: Metadata = {
  title: "Browse courses",
  description: "Explore expert-led courses in machine learning, deep learning, LLMs, computer vision, MLOps and more.",
};

type SP = Record<string, string | string[] | undefined>;
const KEYS = ["q", "category", "level", "price", "rating", "duration", "sort", "page"] as const;

function toQuery(sp: SP, patch: Record<string, string | null> = {}) {
  const p = new URLSearchParams();
  for (const k of KEYS) {
    const v = k in patch ? patch[k] : sp[k];
    if (typeof v === "string" && v) p.set(k, v);
  }
  return p;
}

export default async function CoursesPage({ searchParams }: { searchParams: Promise<SP> }) {
  const sp = await searchParams;
  const categories = (await serverApiSafe<{ items: Category[] }>("/categories"))?.items ?? [];
  const activeCats = typeof sp.category === "string" ? sp.category.split(",") : [];
  const single = activeCats.length === 1 ? categories.find((c) => c.slug === activeCats[0]) : undefined;
  const q = typeof sp.q === "string" ? sp.q : "";
  const totalCourses = categories.reduce((sum, c) => sum + c.coursesCount, 0);

  return (
    <div>
      <section className="relative overflow-hidden border-b border-border">
        <div
          aria-hidden
          className="pointer-events-none absolute inset-0 bg-[radial-gradient(55%_90%_at_92%_0%,oklch(0.57_0.21_262/0.13),transparent_70%),radial-gradient(45%_70%_at_0%_100%,oklch(0.7_0.19_145/0.09),transparent_70%)]"
        />
        <div className="container-page relative pb-12 pt-10 sm:pb-16 sm:pt-14">
          <nav aria-label="Breadcrumb" className="mb-8 flex items-center gap-1.5 text-sm text-subtle-foreground">
            <Link href="/" className="transition-colors hover:text-foreground">
              Home
            </Link>
            <ChevronRight className="size-3.5" />
            <Link href="/courses" className="transition-colors hover:text-foreground">
              Courses
            </Link>
            {single && (
              <>
                <ChevronRight className="size-3.5" />
                <span className="text-foreground">{single.name}</span>
              </>
            )}
          </nav>

          <div className="grid gap-10 lg:grid-cols-[1fr_auto] lg:items-end">
            <div className="max-w-3xl">
              <span className="inline-flex items-center gap-2 rounded-full border border-border bg-surface px-3 py-1 text-[12px] font-semibold tracking-[0.02em] text-muted-foreground shadow-2xs">
                <span className="size-1.5 rounded-full bg-go" />
                {single ? "Topic" : "Course catalog"}
              </span>
              <h1 className="mt-5 font-serif text-[3rem] leading-[1] tracking-[-0.025em] text-foreground sm:text-[4.25rem]">
                {single ? (
                  single.name
                ) : q ? (
                  <>
                    Results for <span className="italic text-accent">“{q}”</span>
                  </>
                ) : (
                  <>
                    Explore the <span className="italic">catalog</span>
                  </>
                )}
              </h1>
              <p className="mt-5 max-w-2xl text-[17px] leading-relaxed text-muted-foreground">
                {single?.description ?? "Hands-on courses across machine learning, deep learning, generative AI, agents and production ML."}
              </p>
            </div>

            {!single && totalCourses > 0 && (
              <dl className="flex gap-3">
                <Stat label="Courses" value={totalCourses} />
                <Stat label="Topics" value={categories.length} />
              </dl>
            )}
          </div>

          <div className="mt-10">
            <CatalogSearch />
          </div>

          {!single && categories.length > 0 && (
            <div className="mt-6 flex flex-wrap gap-2">
              {categories.map((c) => (
                <Link
                  key={c.id}
                  href={`/courses?category=${c.slug}`}
                  className="inline-flex h-8 items-center gap-1.5 rounded-full border border-border bg-surface px-3.5 text-[13px] font-medium text-muted-foreground shadow-2xs transition hover:border-border-strong hover:text-foreground"
                >
                  {c.name}
                  <ArrowUpRight className="size-3.5 opacity-50" />
                </Link>
              ))}
            </div>
          )}
        </div>
      </section>

      <div className="container-page grid gap-12 py-12 lg:grid-cols-[260px_1fr]">
        <aside className="hidden lg:block">
          <div className="sticky top-24 max-h-[calc(100dvh-7rem)] overflow-y-auto rounded-2xl border border-border bg-surface p-5 shadow-card">
            <div className="mb-5 flex items-center gap-2 text-[13px] font-semibold uppercase tracking-[0.08em] text-subtle-foreground">
              <Layers className="size-3.5" /> Refine
            </div>
            <FilterPanel categories={categories} />
          </div>
        </aside>
        <div className="min-w-0">
          <Suspense key={toQuery(sp).toString()} fallback={<ResultsSkeleton />}>
            <Results sp={sp} categories={categories} />
          </Suspense>
        </div>
      </div>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="min-w-[120px] rounded-2xl border border-border bg-surface px-5 py-4 shadow-card">
      <dt className="text-[12px] font-semibold uppercase tracking-[0.08em] text-subtle-foreground">{label}</dt>
      <dd className="mt-1 text-[2rem] font-semibold leading-none tracking-[-0.03em] tabular-nums text-foreground">{value}</dd>
    </div>
  );
}

async function Results({ sp, categories }: { sp: SP; categories: Category[] }) {
  const query = toQuery(sp);
  query.set("pageSize", "12");
  const data = await serverApi<Paginated<Course>>(`/courses?${query}`);
  const page = data.page;

  return (
    <>
      <div className="mb-5 flex flex-wrap items-center justify-between gap-3 border-b border-border pb-5">
        <div className="flex items-center gap-3">
          <MobileFilters categories={categories} />
          <p className="text-[15px] text-muted-foreground">
            <span className="font-semibold tabular-nums text-foreground">{data.total}</span> {data.total === 1 ? "course" : "courses"}
          </p>
        </div>
        <SortSelect />
      </div>
      <div className="mb-8">
        <ActiveFilters categories={categories} />
      </div>

      {data.items.length === 0 ? (
        <EmptyState
          icon={<SearchX />}
          title="No courses match those filters"
          description="Try removing a filter or searching for a broader topic like “deep learning” or “LLMs”."
          action={
            <Button variant="secondary" asChild>
              <Link href="/courses">Reset filters</Link>
            </Button>
          }
        />
      ) : (
        <div className="grid gap-x-6 gap-y-8 sm:grid-cols-2 xl:grid-cols-3">
          {data.items.map((c) => (
            <CourseCard key={c.id} course={c} />
          ))}
        </div>
      )}

      {data.pageCount > 1 && (
        <nav aria-label="Pagination" className="mt-16 flex items-center justify-center gap-1.5">
          <PageLink sp={sp} page={page - 1} disabled={page <= 1} label="Previous">
            <ChevronLeft className="size-4" />
          </PageLink>
          {Array.from({ length: data.pageCount }, (_, i) => i + 1)
            .filter((p) => p === 1 || p === data.pageCount || Math.abs(p - page) <= 1)
            .map((p, i, arr) => (
              <span key={p} className="flex items-center gap-1.5">
                {i > 0 && p - arr[i - 1]! > 1 && <span className="px-1 text-subtle-foreground">…</span>}
                <PageLink sp={sp} page={p} active={p === page} label={`Page ${p}`}>
                  {p}
                </PageLink>
              </span>
            ))}
          <PageLink sp={sp} page={page + 1} disabled={page >= data.pageCount} label="Next">
            <ChevronRight className="size-4" />
          </PageLink>
        </nav>
      )}
    </>
  );
}

function PageLink({ sp, page, children, disabled, active, label }: { sp: SP; page: number; children: React.ReactNode; disabled?: boolean; active?: boolean; label: string }) {
  const cls = cn(
    "inline-flex size-10 items-center justify-center rounded-xl border text-sm font-medium tabular-nums transition",
    active ? "border-ink bg-ink text-ink-foreground shadow-[0_3px_0_0_oklch(0.05_0_0)]" : "border-border bg-surface shadow-2xs hover:border-border-strong hover:text-foreground",
    disabled && "pointer-events-none opacity-40",
  );
  if (disabled)
    return (
      <span aria-disabled className={cls} aria-label={label}>
        {children}
      </span>
    );
  return (
    <Link href={`/courses?${toQuery(sp, { page: page === 1 ? null : String(page) })}`} className={cls} aria-label={label} aria-current={active ? "page" : undefined}>
      {children}
    </Link>
  );
}

function ResultsSkeleton() {
  return (
    <>
      <div className="mb-5 flex items-center justify-between border-b border-border pb-5">
        <div className="skeleton h-5 w-28" />
        <div className="skeleton h-10 w-48" />
      </div>
      <div className="grid gap-x-6 gap-y-8 sm:grid-cols-2 xl:grid-cols-3">
        {Array.from({ length: 6 }, (_, i) => (
          <CourseCardSkeleton key={i} />
        ))}
      </div>
    </>
  );
}
