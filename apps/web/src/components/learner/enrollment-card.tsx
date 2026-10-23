import Link from "next/link";
import { Award, PlayCircle, RotateCcw } from "lucide-react";
import type { Enrollment } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { Button } from "@/components/ui/button";
import { ProgressBar, ProgressRing } from "@/components/ui/display";
import { cn, timeAgo } from "@/lib/utils";

export function EnrollmentCard({ enrollment, certificateId, className }: { enrollment: Enrollment; certificateId?: string; className?: string }) {
  const { course, progressPercent } = enrollment;
  const done = !!enrollment.completedAt || progressPercent >= 100;
  const started = progressPercent > 0;
  return (
    <article className={cn("group relative flex flex-col overflow-hidden rounded-xl border border-border bg-surface shadow-card transition-[box-shadow,border-color] duration-200 hover:border-border-strong hover:shadow-card-lg", className)}>
      <Link href={`/learn/${course.slug}`} className="absolute inset-0 z-10" aria-label={`Open ${course.title}`} />
      <div className="relative border-b border-border">
        <CourseCover seed={course.slug} hue={course.accent} src={course.thumbnailUrl} className="aspect-[16/8]" />
        <div className="absolute right-3 top-3 rounded-full bg-surface p-0.5 shadow-card">
          <ProgressRing value={progressPercent} size={38} stroke={3} className="text-foreground" />
        </div>
        {done && (
          <span className="absolute left-3 top-3 inline-flex items-center gap-1 rounded-md bg-surface px-2 py-0.5 text-[11px] font-semibold text-success shadow-card">
            <Award className="size-3" /> Completed
          </span>
        )}
      </div>
      <div className="flex flex-1 flex-col p-5">
        <h3 className="line-clamp-2 text-[16px] font-semibold leading-snug tracking-[-0.015em]">{course.title}</h3>
        <p className="mt-1 text-[13px] text-muted-foreground">{course.instructor.name}</p>
        <div className="mt-auto pt-5">
          <ProgressBar value={progressPercent} size="sm" />
          <div className="mt-2 flex items-center justify-between text-xs text-subtle-foreground">
            <span className="tabular-nums">{progressPercent}% complete</span>
            <span>{enrollment.lastActivityAt ? `Active ${timeAgo(enrollment.lastActivityAt)}` : `Enrolled ${timeAgo(enrollment.enrolledAt)}`}</span>
          </div>
          <div className="relative z-20 mt-4 flex gap-2">
            <Button asChild size="sm" variant={done ? "secondary" : "primary"} className="flex-1">
              <Link href={`/learn/${course.slug}`}>
                {done ? <RotateCcw /> : <PlayCircle />}
                {done ? "Review" : started ? "Resume" : "Start course"}
              </Link>
            </Button>
            {done && certificateId && (
              <Button asChild size="sm" variant="outline">
                <Link href={`/certificates/${certificateId}`}>
                  <Award className="text-star" /> Certificate
                </Link>
              </Button>
            )}
          </div>
        </div>
      </div>
    </article>
  );
}

export function EnrollmentCardSkeleton() {
  return (
    <div className="overflow-hidden rounded-xl border border-border bg-surface">
      <div className="skeleton aspect-[16/8] rounded-none" />
      <div className="space-y-3 p-5">
        <div className="skeleton h-3 w-24" />
        <div className="skeleton h-5 w-full" />
        <div className="skeleton mt-6 h-1.5 w-full" />
        <div className="skeleton h-9 w-full" />
      </div>
    </div>
  );
}
