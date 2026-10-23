import Link from "next/link";
import { ArrowRight, BarChart3, Clock, Flame, PlayCircle, Star, Users } from "lucide-react";
import type { CourseCard as Course } from "@latent/shared";
import { cn, discountPercent, formatDuration, formatNumber, formatPrice, LEVEL_LABELS } from "@/lib/utils";
import { CourseCover } from "./course-cover";
import { Avatar, RatingInline } from "./ui/display";
import { WishlistButton } from "./wishlist-button";

export function PriceTag({ priceCents, compareAtPriceCents, currency, size = "md", className }: { priceCents: number; compareAtPriceCents: number | null; currency: string; size?: "sm" | "md" | "lg"; className?: string }) {
  const off = discountPercent(priceCents, compareAtPriceCents);
  return (
    <span className={cn("inline-flex items-baseline gap-2", className)}>
      <span
        className={cn(
          "font-semibold tabular-nums tracking-tight",
          { sm: "text-sm", md: "text-[15px]", lg: "text-[2rem] font-semibold leading-none tracking-[-0.03em]" }[size],
          priceCents === 0 && "text-success",
        )}
      >
        {formatPrice(priceCents, currency)}
      </span>
      {off > 0 && compareAtPriceCents && (
        <span className={cn("tabular-nums text-subtle-foreground line-through decoration-subtle-foreground/60", size === "lg" ? "text-base" : "text-xs")}>{formatPrice(compareAtPriceCents, currency)}</span>
      )}
    </span>
  );
}

export function CourseCard({ course, className, priority }: { course: Course; className?: string; priority?: boolean }) {
  const off = discountPercent(course.priceCents, course.compareAtPriceCents);
  return (
    <article
      className={cn(
        "spotlight group relative flex flex-col rounded-[24px] border-2 border-line-3d bg-surface p-2 shadow-[0_4px_0_0_var(--line-3d)] transition-[transform,box-shadow,border-color] duration-300 ease-out hover:-translate-y-1.5 hover:border-[oklch(0.57_0.21_262/0.35)] hover:shadow-[0_6px_0_0_oklch(0.57_0.21_262/0.22),0_24px_40px_-24px_oklch(0.4_0.12_262/0.35)]",
        className,
      )}
      data-priority={priority ? "" : undefined}
    >
      <Link href={`/courses/${course.slug}`} className="absolute inset-0 z-10 rounded-[22px]" aria-label={course.title} />

      {/* Cover */}
      <div className="relative overflow-hidden rounded-[18px]">
        <CourseCover seed={course.slug} hue={course.accent} src={course.thumbnailUrl} title={course.title} className="aspect-[16/9.5] transition-transform duration-700 ease-out group-hover:scale-[1.06]" />
        <div aria-hidden className="pointer-events-none absolute inset-0 bg-[linear-gradient(180deg,transparent_45%,oklch(0.15_0.02_265/0.55))]" />
        <div className="absolute left-3 top-3 z-20 flex gap-1.5">
          {course.bestseller && (
            <span className="inline-flex h-6 items-center gap-1 rounded-full bg-[oklch(0.86_0.15_85)] px-2.5 text-[11.5px] font-bold text-[oklch(0.32_0.08_60)] shadow-[0_2px_0_0_oklch(0.68_0.14_70)]">
              <Flame className="size-3" strokeWidth={2.5} /> Bestseller
            </span>
          )}
          {course.priceCents === 0 && <span className="inline-flex h-6 items-center rounded-full bg-go px-2.5 text-[11.5px] font-bold text-white shadow-[0_2px_0_0_var(--go-edge)]">Free</span>}
        </div>
        <div className="absolute right-3 top-3 z-20 translate-y-1 opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100 focus-within:translate-y-0 focus-within:opacity-100">
          <WishlistButton courseId={course.id} />
        </div>
        {/* Meta chips on the art */}
        <div className="absolute inset-x-3 bottom-3 z-[1] flex items-center gap-1.5 text-[11.5px] font-semibold text-white">
          <span className="inline-flex h-6 items-center gap-1 rounded-full bg-white/18 px-2.5 backdrop-blur-md">
            <BarChart3 className="size-3" strokeWidth={2.5} /> {LEVEL_LABELS[course.level]}
          </span>
          <span className="inline-flex h-6 items-center gap-1 rounded-full bg-white/18 px-2.5 tabular-nums backdrop-blur-md">
            <Clock className="size-3" strokeWidth={2.5} /> {formatDuration(course.durationMinutes)}
          </span>
          <span className="ml-auto hidden h-6 items-center gap-1 rounded-full bg-white/18 px-2.5 tabular-nums backdrop-blur-md min-[380px]:inline-flex">
            <PlayCircle className="size-3" strokeWidth={2.5} /> {course.lessonsCount}
          </span>
        </div>
      </div>

      {/* Body */}
      <div className="flex flex-1 flex-col px-3 pb-3 pt-4">
        {course.category && <p className="text-[12px] font-bold uppercase tracking-[0.08em] text-accent">{course.category.name}</p>}
        <h3 className="mt-1.5 line-clamp-2 text-[18px] font-bold leading-[1.25] tracking-[-0.025em] text-foreground transition-colors group-hover:text-accent">{course.title}</h3>
        {course.subtitle && <p className="mt-2 line-clamp-2 text-[14px] leading-relaxed text-muted-foreground">{course.subtitle}</p>}

        <div className="mt-4 flex items-center gap-2.5">
          <Avatar name={course.instructor.name} src={course.instructor.avatarUrl} size={28} ring />
          <div className="min-w-0 flex-1 leading-tight">
            <div className="truncate text-[13px] font-semibold text-foreground">{course.instructor.name}</div>
            <div className="mt-0.5 inline-flex items-center gap-1 text-[12px] text-subtle-foreground">
              <Users className="size-3" /> {formatNumber(course.studentsCount)} learners
            </div>
          </div>
          {course.ratingAvg > 0 ? (
            <span className="inline-flex shrink-0 items-center gap-1 rounded-full bg-[oklch(0.95_0.06_85)] px-2 py-1 text-[12.5px] font-bold tabular-nums text-[oklch(0.42_0.1_70)]">
              <Star className="size-3.5 fill-star text-star" strokeWidth={0} />
              {course.ratingAvg.toFixed(1)}
              <span className="font-medium text-[oklch(0.55_0.08_70)]">({course.ratingCount})</span>
            </span>
          ) : (
            <span className="shrink-0 rounded-full bg-accent-soft px-2 py-1 text-[12px] font-bold text-accent">New</span>
          )}
        </div>

        {/* Price + CTA */}
        <div className="mt-auto flex items-center gap-3 pt-5">
          <div className="flex min-w-0 flex-1 items-baseline gap-2">
            <span className={cn("text-[22px] font-bold leading-none tracking-[-0.03em] tabular-nums", course.priceCents === 0 && "text-go-edge")}>{formatPrice(course.priceCents, course.currency)}</span>
            {off > 0 && course.compareAtPriceCents && (
              <>
                <span className="text-[13px] tabular-nums text-subtle-foreground line-through">{formatPrice(course.compareAtPriceCents, course.currency)}</span>
                <span className="rounded-full bg-go-soft px-1.5 py-0.5 text-[11px] font-bold text-go-edge">−{off}%</span>
              </>
            )}
          </div>
          <span
            aria-hidden
            className="flex h-10 shrink-0 items-center gap-1.5 overflow-hidden rounded-[12px] bg-ink px-3 text-[13px] font-semibold text-ink-foreground shadow-[0_3px_0_0_oklch(0.05_0_0)] transition-all duration-300 group-hover:bg-accent group-hover:shadow-[0_3px_0_0_var(--accent-edge)]"
          >
            <span className="max-w-0 overflow-hidden whitespace-nowrap opacity-0 transition-all duration-300 group-hover:max-w-[5rem] group-hover:opacity-100">View course</span>
            <ArrowRight className="size-4 transition-transform duration-300 group-hover:translate-x-0.5" strokeWidth={2.5} />
          </span>
        </div>
      </div>
    </article>
  );
}

/** Compact horizontal row: search results, cart, paths. */
export function CourseRow({ course, className, action }: { course: Course; className?: string; action?: React.ReactNode }) {
  return (
    <div className={cn("group relative flex gap-4 rounded-xl border border-border bg-surface p-3 shadow-card transition hover:border-border-strong hover:shadow-card-lg sm:p-3.5", className)}>
      <Link href={`/courses/${course.slug}`} className="absolute inset-0 rounded-xl" aria-label={course.title} />
      <CourseCover seed={course.slug} hue={course.accent} src={course.thumbnailUrl} className="aspect-[16/10] w-32 shrink-0 rounded-lg sm:w-44" />
      <div className="flex min-w-0 flex-1 flex-col py-0.5">
        <h3 className="line-clamp-2 text-[15px] font-semibold leading-snug tracking-[-0.01em]">{course.title}</h3>
        <p className="mt-1 truncate text-[13px] text-muted-foreground">{course.instructor.name}</p>
        <div className="mt-auto flex flex-wrap items-center gap-x-3 gap-y-1 pt-2 text-xs text-subtle-foreground">
          <RatingInline value={course.ratingAvg} count={course.ratingCount} />
          <span className="inline-flex items-center gap-1">
            <BarChart3 className="size-3.5" />
            {LEVEL_LABELS[course.level]}
          </span>
          <span>{formatDuration(course.durationMinutes)}</span>
        </div>
      </div>
      <div className="relative z-10 flex shrink-0 flex-col items-end justify-between py-0.5">
        <PriceTag priceCents={course.priceCents} compareAtPriceCents={course.compareAtPriceCents} currency={course.currency} />
        {action}
      </div>
    </div>
  );
}

export function CourseCardSkeleton() {
  return (
    <div className="rounded-[24px] border-2 border-line-3d bg-surface p-2 shadow-[0_4px_0_0_var(--line-3d)]">
      <div className="skeleton aspect-[16/9.5] rounded-[18px]" />
      <div className="space-y-3 px-3 pb-3 pt-4">
        <div className="skeleton h-3 w-24" />
        <div className="skeleton h-5 w-full" />
        <div className="skeleton h-4 w-3/4" />
        <div className="skeleton mt-6 h-8 w-full" />
      </div>
    </div>
  );
}
