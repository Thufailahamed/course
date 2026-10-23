import type { Review } from "@latent/shared";
import { Avatar, Stars } from "@/components/ui/display";
import { Marquee } from "./home/effects";

type FeaturedReview = Review & { course: { title: string; slug: string } };

function TestimonialCard({ r }: { r: FeaturedReview }) {
  return (
    <figure className="mx-2.5 flex h-full w-[min(380px,82vw)] shrink-0 flex-col rounded-[22px] border-2 border-line-3d bg-surface p-6 shadow-[0_4px_0_0_var(--line-3d)] transition-transform duration-300 hover:-translate-y-1">
      <Stars value={r.rating} size={13} />
      <blockquote className="mt-4 text-[14.5px] leading-relaxed text-foreground/85">
        {r.title && <span className="font-semibold text-foreground">{r.title}. </span>}
        {r.body}
      </blockquote>
      <figcaption className="mt-auto flex items-center gap-3 pt-6">
        <Avatar name={r.user.name} src={r.user.avatarUrl} size={32} />
        <div className="min-w-0">
          <div className="truncate text-[13.5px] font-medium">{r.user.name}</div>
          <div className="truncate text-xs text-muted-foreground">
            {r.user.headline} · {r.course.title}
          </div>
        </div>
      </figcaption>
    </figure>
  );
}

/** Two rows of featured reviews drifting in opposite directions; hover pauses a row. */
export function TestimonialMarquee({ reviews }: { reviews: FeaturedReview[] }) {
  if (!reviews.length) return null;
  const half = Math.ceil(reviews.length / 2);
  const rows = reviews.length > 3 ? [reviews.slice(0, half), reviews.slice(half)] : [reviews];
  return (
    <div className="space-y-5">
      {rows.map((row, i) => (
        <Marquee key={i} reverse={i === 1} duration={50 + i * 8} className="py-1.5">
          {[...row, ...row].map((r, k) => (
            <TestimonialCard key={`${r.id}-${k}`} r={r} />
          ))}
        </Marquee>
      ))}
    </div>
  );
}
