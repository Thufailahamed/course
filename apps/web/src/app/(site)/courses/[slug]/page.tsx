import type { Metadata } from "next";
import Link from "next/link";
import { BarChart3, Check, ChevronRight, Clock, Globe, PlayCircle, RefreshCw, Star, Target, Users } from "lucide-react";
import type { CourseCard as Course, CourseDetail, Paginated } from "@latent/shared";
import { CourseCard } from "@/components/course-card";
import { CoursePreviewProvider, PreviewTrigger } from "@/components/commerce/course-preview";
import { Curriculum } from "@/components/commerce/curriculum";
import { MobilePurchaseBar, PurchaseCard } from "@/components/commerce/purchase-card";
import { CourseReviews } from "@/components/commerce/reviews";
import { Markdown } from "@/components/markdown";
import { Avatar, Stars } from "@/components/ui/display";
import { Badge } from "@/components/ui/primitives";
import { serverApiOr404, serverApiSafe } from "@/lib/server";
import { formatDate, formatDuration, formatNumber, LEVEL_LABELS } from "@/lib/utils";

type Props = { params: Promise<{ slug: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const course = await serverApiSafe<CourseDetail>(`/courses/${slug}`);
  if (!course) return { title: "Course not found" };
  return {
    title: course.title,
    description: course.subtitle ?? undefined,
    openGraph: { title: course.title, description: course.subtitle ?? undefined, type: "website" },
  };
}

export default async function CoursePage({ params }: Props) {
  const { slug } = await params;
  const course = await serverApiOr404<CourseDetail>(`/courses/${slug}`);
  const related = course.category
    ? await serverApiSafe<Paginated<Course>>(`/courses?category=${course.category.slug}&exclude=${course.id}&pageSize=3`)
    : null;
  const moreRelated =
    (related?.items.length ?? 0) < 3 ? await serverApiSafe<Paginated<Course>>(`/courses?exclude=${course.id}&pageSize=6&sort=rating`) : null;
  const relatedItems = [...(related?.items ?? []), ...(moreRelated?.items ?? []).filter((c) => !related?.items.some((r) => r.id === c.id))].slice(0, 3);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Course",
    name: course.title,
    description: course.subtitle,
    provider: { "@type": "Organization", name: "Latent" },
    ...(course.ratingCount ? { aggregateRating: { "@type": "AggregateRating", ratingValue: course.ratingAvg, ratingCount: course.ratingCount } } : {}),
  };

  return (
    <CoursePreviewProvider course={course}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <div className="relative -mt-16">
      {/* ── Hero ───────────────────────────────────────── */}
      <section className="relative overflow-hidden border-b border-border bg-surface pt-16">
        <div className="container-page relative grid gap-10 py-12 lg:grid-cols-[1fr_380px] lg:py-20">
          <div className="min-w-0 animate-fade-up">
            <nav aria-label="Breadcrumb" className="mb-6 flex flex-wrap items-center gap-1.5 text-sm text-muted-foreground">
              <Link href="/courses" className="hover:text-foreground">
                Courses
              </Link>
              {course.category && (
                <>
                  <ChevronRight className="size-3.5" />
                  <Link href={`/courses?category=${course.category.slug}`} className="hover:text-foreground">
                    {course.category.name}
                  </Link>
                </>
              )}
            </nav>
            <div className="mb-4 flex flex-wrap gap-2">
              {course.bestseller && <Badge variant="bestseller">Bestseller</Badge>}
              {course.featured && <Badge>Featured</Badge>}
              <Badge variant="outline">{LEVEL_LABELS[course.level]}</Badge>
            </div>
            <h1 className="text-[2.1rem] leading-[1.12] tracking-[-0.035em] sm:text-[2.75rem]">{course.title}</h1>
            {course.subtitle && <p className="mt-4 max-w-3xl text-[16.5px] leading-relaxed text-muted-foreground">{course.subtitle}</p>}

            <div className="mt-6 flex flex-wrap items-center gap-x-6 gap-y-3 text-sm">
              {course.ratingCount > 0 && (
                <a href="#reviews" className="inline-flex items-center gap-2 hover:underline">
                  <span className="font-semibold tabular-nums">{course.ratingAvg.toFixed(1)}</span>
                  <Stars value={course.ratingAvg} />
                  <span className="text-muted-foreground">({course.ratingCount.toLocaleString()} ratings)</span>
                </a>
              )}
              <span className="inline-flex items-center gap-1.5 text-muted-foreground">
                <Users className="size-4" /> {formatNumber(course.studentsCount)} learners
              </span>
            </div>

            <div className="mt-6 flex items-center gap-3">
              <Avatar name={course.instructor.name} src={course.instructor.avatarUrl} size={40} />
              <div className="text-sm">
                <p className="text-muted-foreground">
                  Taught by{" "}
                  <Link href={`/instructors/${course.instructor.id}`} className="font-semibold text-foreground hover:underline">
                    {course.instructor.name}
                  </Link>
                </p>
                <p className="text-xs text-subtle-foreground">{course.instructor.headline}</p>
              </div>
            </div>

            <div className="mt-10 grid grid-cols-2 border-t border-border sm:grid-cols-4">
              {[
                [Clock, formatDuration(course.durationMinutes), "Total length"],
                [PlayCircle, String(course.lessonsCount), "Lessons"],
                [BarChart3, LEVEL_LABELS[course.level], "Level"],
                [RefreshCw, formatDate(course.updatedAt, { month: "short", year: "numeric" }), "Last updated"],
              ].map(([Icon, v, l]) => {
                const I = Icon as typeof Clock;
                return (
                  <div key={l as string} className="py-4 pr-4 sm:border-l sm:border-border sm:pl-5 sm:first:border-l-0 sm:first:pl-0">
                    <I className="size-4 text-subtle-foreground" />
                    <div className="mt-2.5 text-[15px] font-semibold">{v as string}</div>
                    <div className="text-xs text-subtle-foreground">{l as string}</div>
                  </div>
                );
              })}
            </div>
            <div className="mt-6 lg:hidden">
              <PreviewTrigger className="inline-flex items-center gap-2 text-sm font-medium text-accent hover:underline">
                <PlayCircle className="size-4" /> Watch the preview
              </PreviewTrigger>
            </div>
          </div>
          <div className="hidden lg:block" />
        </div>
      </section>

      {/* ── Body ───────────────────────────────────────── */}
      <div className="container-page grid gap-10 pb-28 pt-10 lg:grid-cols-[1fr_380px] lg:pb-10">
        <div className="min-w-0 space-y-14">
          <div className="lg:hidden">
            <PurchaseCard course={course} />
          </div>

          {course.whatYouLearn.length > 0 && (
            <section className="card p-6 sm:p-8">
              <h2 className="text-xl tracking-[-0.025em]">What you&apos;ll learn</h2>
              <ul className="mt-6 grid gap-x-8 gap-y-4 sm:grid-cols-2">
                {course.whatYouLearn.map((item) => (
                  <li key={item} className="flex gap-3 text-[14.5px] leading-relaxed text-foreground/80">
                    <span className="mt-1 flex shrink-0 text-accent">
                      <Check className="size-4" strokeWidth={2.25} />
                    </span>
                    {item}
                  </li>
                ))}
              </ul>
            </section>
          )}

          {course.tags.length > 0 && (
            <section>
              <h2 className="mb-4 text-xl tracking-[-0.025em]">Skills you&apos;ll gain</h2>
              <div className="flex flex-wrap gap-2">
                {course.tags.map((t) => (
                  <Link key={t} href={`/courses?q=${encodeURIComponent(t)}`} className="rounded-md border border-border bg-surface px-3 py-1.5 text-[13.5px] shadow-card transition hover:border-border-strong hover:bg-surface-2">
                    {t}
                  </Link>
                ))}
              </div>
            </section>
          )}

          <section id="curriculum" className="scroll-mt-24">
            <h2 className="mb-2 text-xl tracking-[-0.025em]">Curriculum</h2>
            <Curriculum sections={course.sections} />
          </section>

          <section className="grid gap-6 md:grid-cols-2">
            {course.requirements.length > 0 && (
              <div>
                <h2 className="text-lg tracking-[-0.02em]">Requirements</h2>
                <ul className="mt-4 space-y-3">
                  {course.requirements.map((r) => (
                    <li key={r} className="flex gap-3 text-[15px] text-muted-foreground">
                      <span className="mt-2.5 h-px w-3 shrink-0 bg-foreground/40" />
                      {r}
                    </li>
                  ))}
                </ul>
              </div>
            )}
            {course.targetAudience.length > 0 && (
              <div>
                <h2 className="text-lg tracking-[-0.02em]">Who this course is for</h2>
                <ul className="mt-4 space-y-3">
                  {course.targetAudience.map((r) => (
                    <li key={r} className="flex gap-3 text-[15px] text-muted-foreground">
                      <Target className="mt-1 size-4 shrink-0 text-subtle-foreground" />
                      {r}
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </section>

          {course.description && (
            <section>
              <h2 className="mb-4 text-xl tracking-[-0.025em]">Description</h2>
              <Markdown>{course.description}</Markdown>
              <p className="mt-6 inline-flex items-center gap-2 text-sm text-subtle-foreground">
                <Globe className="size-4" /> Taught in {course.language}
              </p>
            </section>
          )}

          <section>
            <h2 className="mb-6 text-xl tracking-[-0.025em]">Your instructor</h2>
            <div className="card p-6 sm:p-8">
              <div className="flex flex-col gap-5 sm:flex-row sm:items-center">
                <Avatar name={course.instructor.name} src={course.instructor.avatarUrl} size={72} />
                <div>
                  <Link href={`/instructors/${course.instructor.id}`} className="text-lg font-semibold tracking-[-0.02em] hover:underline">
                    {course.instructor.name}
                  </Link>
                  <p className="mt-1 text-sm text-muted-foreground">{course.instructor.headline}</p>
                  <div className="mt-3 flex flex-wrap gap-x-5 gap-y-1 text-sm text-subtle-foreground">
                    {!!course.instructor.ratingAvg && (
                      <span className="inline-flex items-center gap-1.5">
                        <Star className="size-4 fill-star text-star" strokeWidth={0} /> {course.instructor.ratingAvg} instructor rating
                      </span>
                    )}
                    <span className="inline-flex items-center gap-1.5">
                      <Users className="size-4" /> {formatNumber(course.instructor.studentsCount ?? 0)} learners
                    </span>
                    <span className="inline-flex items-center gap-1.5">
                      <PlayCircle className="size-4" /> {course.instructor.coursesCount} courses
                    </span>
                  </div>
                </div>
              </div>
              {course.instructor.bio && <p className="mt-6 text-[15px] leading-relaxed text-muted-foreground">{course.instructor.bio}</p>}
            </div>
          </section>

          <section id="reviews" className="scroll-mt-24">
            <h2 className="mb-6 text-xl tracking-[-0.025em]">Learner reviews</h2>
            <CourseReviews course={course} />
          </section>
        </div>

        <div className="hidden lg:block" />
      </div>

      {/* Desktop purchase card: a column spanning hero + body so it starts in the
          hero and stays sticky through the content, whatever the hero's height. */}
      <div className="pointer-events-none absolute inset-0 z-10 hidden lg:block">
        <div className="container-page grid h-full grid-cols-[1fr_380px] gap-10 pb-10 pt-32">
          <div />
          <aside>
            <div className="pointer-events-auto sticky top-24">
              <PurchaseCard course={course} />
            </div>
          </aside>
        </div>
      </div>
      </div>

      {relatedItems.length > 0 && (
        <section className="container-page pb-10 pt-6">
          <h2 className="text-xl tracking-[-0.025em]">You might also like</h2>
          <div className="mt-6 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {relatedItems.map((c) => (
              <CourseCard key={c.id} course={c} />
            ))}
          </div>
        </section>
      )}

      <MobilePurchaseBar course={course} />
    </CoursePreviewProvider>
  );
}
