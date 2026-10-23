import Link from "next/link";
import { ArrowRight, Star } from "lucide-react";
import type { Instructor, LearningPath } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { Avatar } from "@/components/ui/display";
import { cn, formatDuration, formatNumber, LEVEL_LABELS } from "@/lib/utils";

export function PathCard({ path, className }: { path: LearningPath; className?: string }) {
  return (
    <Link
      href={`/paths/${path.slug}`}
      className={cn(
        "group relative flex flex-col overflow-hidden rounded-xl border border-border bg-surface shadow-card transition-[box-shadow,border-color] duration-200 hover:border-border-strong hover:shadow-card-lg",
        className,
      )}
    >
      <div className="overflow-hidden border-b border-border">
        <CourseCover seed={`path-${path.slug}`} hue={path.accent} variant="network" className="aspect-[16/8] transition-transform duration-700 ease-out group-hover:scale-[1.02]" />
      </div>
      <div className="flex flex-1 flex-col p-5">
        <p className="text-xs text-muted-foreground">
          Career path · {LEVEL_LABELS[path.level]}
        </p>
        <h3 className="mt-1.5 text-lg font-semibold leading-snug tracking-[-0.02em]">{path.title}</h3>
        {path.subtitle && <p className="mt-1.5 text-[13.5px] leading-relaxed text-muted-foreground">{path.subtitle}</p>}
        <div className="mt-auto flex items-center justify-between pt-5 text-[13px]">
          <span className="text-muted-foreground">
            {path.coursesCount} courses · {formatDuration(path.durationMinutes)}
          </span>
          <span className="inline-flex items-center gap-1 font-medium text-foreground">
            View path <ArrowRight className="size-3.5 transition-transform group-hover:translate-x-0.5" />
          </span>
        </div>
      </div>
    </Link>
  );
}

export function InstructorCard({ instructor, className }: { instructor: Instructor; className?: string }) {
  return (
    <Link
      href={`/instructors/${instructor.id}`}
      className={cn("group flex flex-col rounded-xl border border-border bg-surface p-5 shadow-card transition-[box-shadow,border-color] duration-200 hover:border-border-strong hover:shadow-card-lg", className)}
    >
      <div className="flex items-center gap-3.5">
        <Avatar name={instructor.name} src={instructor.avatarUrl} size={48} />
        <div className="min-w-0">
          <h3 className="truncate text-[15px] font-semibold tracking-[-0.01em]">{instructor.name}</h3>
          <p className="line-clamp-1 text-[13px] text-muted-foreground">{instructor.headline}</p>
        </div>
      </div>
      {instructor.bio && <p className="mt-4 line-clamp-3 text-[13.5px] leading-relaxed text-muted-foreground">{instructor.bio}</p>}
      <div className="mt-auto pt-5">
        <div className="flex items-center gap-4 border-t border-border pt-4 text-xs text-muted-foreground">
        {!!instructor.ratingAvg && (
          <span className="inline-flex items-center gap-1 font-medium text-foreground">
            <Star className="size-3.5 fill-star text-star" /> {Number(instructor.ratingAvg).toFixed(1)}
          </span>
        )}
        <span>{formatNumber(Number(instructor.studentsCount ?? 0))} learners</span>
        <span>{instructor.coursesCount} courses</span>
      </div>
      </div>
    </Link>
  );
}
