"use client";

import Link from "next/link";
import { useQuery } from "@tanstack/react-query";
import { ArrowRight, Award, BookOpen, Clock, Flame, GraduationCap, PlayCircle, Trophy } from "lucide-react";
import type { CourseCard as Course, Paginated } from "@latent/shared";
import { CourseCard, CourseCardSkeleton } from "@/components/course-card";
import { CourseCover } from "@/components/course-cover";
import { ActivityHeatmap } from "@/components/learner/activity-heatmap";
import { useEnrollments, useStats } from "@/components/learner/queries";
import { Button } from "@/components/ui/button";
import { EmptyState, ProgressBar, StatTile } from "@/components/ui/display";
import { Skeleton } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { useSession } from "@/lib/hooks";
import { formatDuration, timeAgo } from "@/lib/utils";

function greeting() {
  const h = new Date().getHours();
  return h < 5 ? "Burning the midnight oil" : h < 12 ? "Good morning" : h < 18 ? "Good afternoon" : "Good evening";
}

export default function DashboardPage() {
  const { user } = useSession();
  const { data: enrollments, isPending: loadingEnr } = useEnrollments();
  const { data: stats, isPending: loadingStats } = useStats();
  const { data: featured, isPending: loadingRec } = useQuery({
    queryKey: ["courses", "featured-dashboard"],
    queryFn: () => api.get<Paginated<Course>>("/courses?featured=1&pageSize=12").then((r) => r.items),
  });

  const enrolledIds = new Set((enrollments ?? []).map((e) => e.courseId));
  const recommended = (featured ?? []).filter((c) => !enrolledIds.has(c.id)).slice(0, 4);
  const inProgress = (enrollments ?? []).filter((e) => !e.completedAt && e.progressPercent < 100);
  const current = inProgress[0] ?? null;
  const firstName = user?.name.split(" ")[0] ?? "";
  const today = new Date().toLocaleDateString("en-US", { weekday: "long", month: "long", day: "numeric" });

  return (
    <div className="container-page py-10 sm:py-14">
      {/* Greeting */}
      <div className="flex flex-col gap-5 border-b border-border pb-8 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="text-sm text-muted-foreground" suppressHydrationWarning>
            {today}
          </p>
          <h1 className="mt-1.5 text-[1.75rem] leading-tight sm:text-[2rem]">
            {firstName ? (
              <>
                {greeting()}, {firstName}
              </>
            ) : (
              <span className="skeleton inline-block h-9 w-64 align-middle" />
            )}
          </h1>
        </div>
        {stats && stats.currentStreak > 0 && (
          <div className="inline-flex items-center gap-2 self-start rounded-lg border border-border bg-surface px-3 py-1.5 text-sm font-medium shadow-card sm:self-auto">
            <Flame className="size-4 fill-[oklch(0.7_0.17_50)] text-[oklch(0.65_0.18_45)]" /> {stats.currentStreak}-day streak
          </div>
        )}
      </div>

      {/* Continue learning */}
      <section className="mt-8">
        {loadingEnr ? (
          <Skeleton className="h-64 rounded-xl" />
        ) : current ? (
          <div className="card group relative grid overflow-hidden transition-shadow duration-300 hover:shadow-card-lg md:grid-cols-[minmax(0,440px)_1fr]">
            <Link href={`/learn/${current.course.slug}`} className="absolute inset-0 z-10" aria-label={`Resume ${current.course.title}`} />
            <CourseCover seed={current.course.slug} hue={current.course.accent} src={current.course.thumbnailUrl} className="aspect-[16/9] md:aspect-auto md:h-full" />
            <div className="flex flex-col p-6 sm:p-9">
              <p className="text-sm font-medium text-accent">Continue learning</p>
              <h2 className="mt-2 text-[1.5rem] leading-snug tracking-[-0.025em]">{current.course.title}</h2>
              <p className="mt-2 text-sm text-muted-foreground">
                {current.course.instructor.name}
                {current.lastActivityAt && ` · last studied ${timeAgo(current.lastActivityAt)}`}
              </p>
              <div className="mt-auto pt-8">
                <div className="flex items-baseline justify-between gap-4">
                  <span className="text-2xl font-semibold tabular-nums tracking-[-0.035em]">{current.progressPercent}%</span>
                  <span className="text-right text-xs text-subtle-foreground">
                    {Math.round((current.progressPercent / 100) * current.course.lessonsCount)} of {current.course.lessonsCount} lessons ·{" "}
                    {formatDuration(Math.round(current.course.durationMinutes * (1 - current.progressPercent / 100)))} left
                  </span>
                </div>
                <ProgressBar value={current.progressPercent} className="mt-3" />
                <Button size="lg" className="relative z-20 mt-7 w-full sm:w-auto" asChild>
                  <Link href={`/learn/${current.course.slug}`}>
                    <PlayCircle /> Resume lesson
                  </Link>
                </Button>
              </div>
            </div>
          </div>
        ) : (
          <EmptyState
            icon={<GraduationCap />}
            title={enrollments?.length ? "You've completed everything you're enrolled in" : "Start your first course"}
            description={enrollments?.length ? "Impressive. Pick your next challenge from the catalog." : "Explore hands-on courses in machine learning, deep learning, LLMs and more."}
            action={
              <Button asChild>
                <Link href="/courses">
                  Browse courses <ArrowRight />
                </Link>
              </Button>
            }
          />
        )}
      </section>

      {/* Stats */}
      <section className="mt-6 grid grid-cols-2 gap-3 lg:grid-cols-4">
        {loadingStats || !stats ? (
          Array.from({ length: 4 }, (_, i) => <Skeleton key={i} className="h-[116px] rounded-xl" />)
        ) : (
          <>
            <StatTile icon={<Flame />} label="Current streak" value={`${stats.currentStreak} ${stats.currentStreak === 1 ? "day" : "days"}`} hint={`Longest: ${stats.longestStreak} days`} />
            <StatTile icon={<Clock />} label="Time learned" value={formatDuration(stats.minutesLearned)} hint="All time" />
            <StatTile icon={<BookOpen />} label="Lessons completed" value={stats.lessonsCompleted.toLocaleString()} hint={`${stats.inProgress} courses in progress`} />
            <StatTile icon={<Award />} label="Certificates" value={stats.certificates} hint={`${stats.completed} courses completed`} />
          </>
        )}
      </section>

      <div className="mt-6 grid gap-6 lg:grid-cols-[1.35fr_1fr]">
        {/* Activity */}
        <section className="card p-6">
          <div className="mb-6 flex items-start justify-between gap-4">
            <div>
              <h2 className="text-[17px] leading-tight tracking-[-0.02em]">Learning activity</h2>
              <p className="mt-1 text-sm text-muted-foreground">Consistency beats intensity.</p>
            </div>
            {stats && (
              <span className="inline-flex shrink-0 items-center gap-1.5 text-xs text-subtle-foreground">
                <Trophy className="size-3.5 text-star" /> Best streak {stats.longestStreak}d
              </span>
            )}
          </div>
          {stats ? <ActivityHeatmap activity={stats.activity} /> : <Skeleton className="h-28" />}
        </section>

        {/* In progress */}
        <section className="card flex flex-col p-6">
          <div className="mb-3 flex items-center justify-between">
            <h2 className="text-[17px] leading-tight tracking-[-0.02em]">In progress</h2>
            <Link href="/my-courses" className="text-sm font-medium text-accent hover:underline">
              View all
            </Link>
          </div>
          {loadingEnr ? (
            <div className="space-y-4">
              {[0, 1, 2].map((i) => (
                <Skeleton key={i} className="h-14" />
              ))}
            </div>
          ) : inProgress.length === 0 ? (
            <p className="py-8 text-center text-sm text-muted-foreground">Nothing in progress right now.</p>
          ) : (
            <ul className="divide-y divide-border">
              {inProgress.slice(0, 4).map((e) => (
                <li key={e.courseId}>
                  <Link href={`/learn/${e.course.slug}`} className="group flex items-center gap-3.5 py-3">
                    <CourseCover seed={e.course.slug} hue={e.course.accent} src={e.course.thumbnailUrl} className="aspect-square w-11 shrink-0 rounded-lg" />
                    <div className="min-w-0 flex-1">
                      <div className="truncate text-sm font-medium transition-colors group-hover:text-accent">{e.course.title}</div>
                      <div className="mt-2 flex items-center gap-2.5">
                        <ProgressBar value={e.progressPercent} size="sm" className="flex-1" />
                        <span className="w-8 text-right text-[11px] tabular-nums text-subtle-foreground">{e.progressPercent}%</span>
                      </div>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </section>
      </div>

      {/* Pro upsell */}
      {user && !user.hasPro && (
        <section className="relative mt-6 overflow-hidden rounded-xl bg-ink p-7 text-ink-foreground sm:p-10">
          <div className="flex flex-col gap-6 md:flex-row md:items-center md:justify-between">
            <div className="max-w-xl">
              <p className="text-sm font-semibold text-[oklch(0.75_0.13_259)]">Latent Pro</p>
              <h2 className="mt-2 text-[1.6rem] leading-tight">Unlock every course, path and certificate.</h2>
              <p className="mt-3 text-sm leading-relaxed text-ink-foreground/65">One membership, the whole catalog, plus new courses the day they launch.</p>
            </div>
            <Button size="lg" className="bg-white text-ink shadow-none hover:bg-white/90" asChild>
              <Link href="/pricing">
                Explore Pro <ArrowRight />
              </Link>
            </Button>
          </div>
        </section>
      )}

      {/* Recommended */}
      <section className="mt-16">
        <div className="mb-7 flex items-end justify-between">
          <div>
            <h2 className="text-[1.4rem] leading-tight">Recommended for you</h2>
            <p className="mt-1.5 text-sm text-muted-foreground">Hand-picked courses to take your skills further.</p>
          </div>
          <Link href="/courses" className="hidden text-sm font-medium text-accent hover:underline sm:block">
            Browse catalog
          </Link>
        </div>
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {loadingRec ? Array.from({ length: 4 }, (_, i) => <CourseCardSkeleton key={i} />) : recommended.map((c) => <CourseCard key={c.id} course={c} />)}
        </div>
      </section>
    </div>
  );
}
