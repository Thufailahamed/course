import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { ChevronLeft, ChevronRight, SearchX } from "lucide-react";
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

  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page py-12 sm:py-16">
          <nav aria-label="Breadcrumb" className="mb-6 flex items-center gap-1.5 text-sm text-subtle-foreground">
            <Link href="/" className="hover:text-foreground">
              Home
            </Link>
            <ChevronRight className="size-3.5" />
            <Link href="/courses" className="hover:text-foreground">
              Courses
            </Link>
            {single && (
              <>
                <ChevronRight className="size-3.5" />
                <span className="text-foreground">{single.name}</span>
              </>
            )}
          </nav>
          <h1 className="text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">
            {single ? (
              single.name
            ) : q ? (
              <>
                Results for “{q}”
              </>
            ) : (
              <>
                Explore the catalog
              </>
            )}
          </h1>
          <p className="mt-4 max-w-2xl text-[16.5px] leading-relaxed text-muted-foreground">
            {single?.description ?? "Hands-on courses across machine learning, deep learning, generative AI, agents and production ML."}
          </p>
          <div className="mt-8">
            <CatalogSearch />
          </div>
        </div>
      </section>

      <div className="container-page grid gap-12 py-10 lg:grid-cols-[240px_1fr]">
        <aside className="hidden lg:block">
          <div className="sticky top-24 max-h-[calc(100dvh-7rem)] overflow-y-auto pr-2">
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

async function Results({ sp, categories }: { sp: SP; categories: Category[] }) {
  const query = toQuery(sp);
  query.set("pageSize", "12");
  const data = await serverApi<Paginated<Course>>(`/courses?${query}`);
  const page = data.page;

  return (
    <>
      <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <MobileFilters categories={categories} />
          <p className="text-sm text-muted-foreground">
            <span className="font-semibold text-foreground">{data.total}</span> {data.total === 1 ? "course" : "courses"}
          </p>
        </div>
        <SortSelect />
      </div>
      <div className="mb-6">
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
        <div className="grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
          {data.items.map((c) => (
            <CourseCard key={c.id} course={c} />
          ))}
        </div>
      )}

      {data.pageCount > 1 && (
        <nav aria-label="Pagination" className="mt-12 flex items-center justify-center gap-1.5">
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
    "inline-flex size-9 items-center justify-center rounded-lg border text-sm font-medium tabular-nums transition",
    active ? "border-foreground bg-foreground text-background" : "border-border bg-surface hover:border-border-strong",
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
      <div className="mb-6 flex items-center justify-between">
        <div className="skeleton h-5 w-28" />
        <div className="skeleton h-10 w-48" />
      </div>
      <div className="grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
        {Array.from({ length: 6 }, (_, i) => (
          <CourseCardSkeleton key={i} />
        ))}
      </div>
    </>
  );
}
