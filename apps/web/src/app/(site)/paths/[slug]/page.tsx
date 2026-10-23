import type { Metadata } from "next";
import Link from "next/link";
import { ArrowRight, Award, BookOpen, ChevronRight, Clock } from "lucide-react";
import type { LearningPath } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { PriceTag } from "@/components/course-card";
import { Button } from "@/components/ui/button";
import { RatingInline } from "@/components/ui/display";
import { serverApiOr404, serverApiSafe } from "@/lib/server";
import { formatDuration, formatPrice, LEVEL_LABELS } from "@/lib/utils";

type Props = { params: Promise<{ slug: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const p = await serverApiSafe<LearningPath>(`/paths/${slug}`);
  return p ? { title: p.title, description: p.subtitle ?? undefined } : { title: "Path not found" };
}

export default async function PathPage({ params }: Props) {
  const { slug } = await params;
  const path = await serverApiOr404<LearningPath>(`/paths/${slug}`);
  const courses = path.courses ?? [];
  const total = courses.reduce((s, c) => s + c.priceCents, 0);

  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page grid gap-12 py-14 sm:py-20 lg:grid-cols-[1.4fr_1fr] lg:items-center">
          <div>
            <nav aria-label="Breadcrumb" className="mb-8 flex items-center gap-1.5 text-sm text-muted-foreground">
              <Link href="/paths" className="hover:text-foreground">
                Learning paths
              </Link>
              <ChevronRight className="size-3.5" />
              <span className="text-foreground">{path.title}</span>
            </nav>
            <p className="text-sm font-semibold text-accent">
              Career path <span className="mx-1 font-normal text-subtle-foreground">·</span> {LEVEL_LABELS[path.level]}
            </p>
            <h1 className="mt-3 max-w-3xl text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">{path.title}</h1>
            {path.subtitle && <p className="mt-5 max-w-2xl text-[16.5px] leading-relaxed text-muted-foreground">{path.subtitle}</p>}
            <div className="mt-8 flex flex-wrap items-center gap-x-6 gap-y-2 text-sm text-muted-foreground">
              {[
                [BookOpen, `${path.coursesCount} courses`],
                [Clock, formatDuration(path.durationMinutes)],
                [Award, `${path.coursesCount} certificates`],
              ].map(([Icon, label]) => {
                const I = Icon as typeof Clock;
                return (
                  <span key={label as string} className="inline-flex items-center gap-2">
                    <I className="size-4 text-subtle-foreground" /> {label as string}
                  </span>
                );
              })}
            </div>
          </div>
          <CourseCover seed={`path-${path.slug}`} hue={path.accent} variant="network" className="hidden aspect-[4/3] rounded-xl border border-border shadow-card lg:block" />
        </div>
      </section>

      <div className="container-page grid gap-12 py-14 lg:grid-cols-[1fr_340px]">
        <div>
          {path.description && <p className="mb-12 max-w-3xl text-[16px] leading-relaxed text-muted-foreground">{path.description}</p>}
          <h2 className="mb-8 text-2xl tracking-[-0.025em]">The path, step by step</h2>
          <ol className="relative space-y-6 before:absolute before:bottom-6 before:left-[15px] before:top-6 before:w-px before:bg-border-strong">
            {courses.map((c, i) => (
              <li key={c.id} className="relative flex gap-5">
                <span className="relative z-10 mt-4 flex size-8 shrink-0 items-center justify-center rounded-full border border-border-strong bg-surface text-[13px] font-semibold tabular-nums text-foreground">
                  {i + 1}
                </span>
                <Link href={`/courses/${c.slug}`} className="group flex flex-1 flex-col gap-4 rounded-xl border border-border bg-surface p-4 shadow-card transition hover:border-border-strong hover:shadow-card-lg sm:flex-row">
                  <CourseCover seed={c.slug} hue={c.accent} src={c.thumbnailUrl} className="aspect-video w-full shrink-0 rounded-lg sm:w-48" />
                  <div className="min-w-0 flex-1">
                    <p className="text-xs text-muted-foreground">{LEVEL_LABELS[c.level]}</p>
                    <h3 className="mt-1 text-[16px] font-semibold leading-snug tracking-[-0.015em]">{c.title}</h3>
                    {c.subtitle && <p className="mt-1 line-clamp-2 text-sm text-muted-foreground">{c.subtitle}</p>}
                    <div className="mt-3 flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-subtle-foreground">
                      <RatingInline value={c.ratingAvg} count={c.ratingCount} />
                      <span>{formatDuration(c.durationMinutes)}</span>
                      <span>{c.lessonsCount} lessons</span>
                    </div>
                  </div>
                  <div className="shrink-0 sm:text-right">
                    <PriceTag priceCents={c.priceCents} compareAtPriceCents={c.compareAtPriceCents} currency={c.currency} />
                  </div>
                </Link>
              </li>
            ))}
          </ol>
        </div>
        <aside>
          <div className="sticky top-24 overflow-hidden rounded-xl bg-ink p-7 text-ink-foreground">
            <p className="text-sm font-semibold text-[oklch(0.75_0.13_259)]">Latent Pro</p>
            <h3 className="mt-2 text-xl font-semibold leading-tight tracking-[-0.025em]">Get the whole path with Pro</h3>
            <p className="mt-3 text-sm leading-relaxed text-ink-foreground/65">
              All {courses.length} courses (<span className="tabular-nums">{formatPrice(total)}</span> if bought separately) are included in a Latent Pro membership, plus every other course in the catalog.
            </p>
            <Button className="mt-7 w-full bg-white text-ink shadow-none hover:bg-white/90" size="lg" asChild>
              <Link href="/pricing">
                See Pro plans <ArrowRight />
              </Link>
            </Button>
            {courses[0] && (
              <Button className="mt-2 w-full text-ink-foreground/80 ring-1 ring-white/15 hover:bg-white/10 hover:text-ink-foreground" variant="ghost" size="lg" asChild>
                <Link href={`/courses/${courses[0].slug}`}>Start with course 1</Link>
              </Button>
            )}
          </div>
        </aside>
      </div>
    </div>
  );
}
