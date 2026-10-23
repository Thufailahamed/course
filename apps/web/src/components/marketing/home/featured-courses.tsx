"use client";

import { useMemo, useState } from "react";
import { AnimatePresence, LayoutGroup, motion, useReducedMotion } from "motion/react";
import type { CourseCard as Course } from "@latent/shared";
import { CourseCard } from "@/components/course-card";
import { cn } from "@/lib/utils";
import { SpotlightGrid } from "./effects";

const EASE = [0.22, 1, 0.36, 1] as const;

/** Featured grid with category chips; cards re-flow with a shared layout animation when filtered. */
export function FeaturedCourses({ courses }: { courses: Course[] }) {
  const reduce = useReducedMotion();
  const [cat, setCat] = useState<string | null>(null);
  const cats = useMemo(() => {
    const seen = new Map<string, { slug: string; name: string; n: number }>();
    for (const c of courses) if (c.category) seen.set(c.category.slug, { ...c.category, n: (seen.get(c.category.slug)?.n ?? 0) + 1 });
    return [...seen.values()];
  }, [courses]);
  const shown = cat ? courses.filter((c) => c.category?.slug === cat) : courses;

  return (
    <LayoutGroup>
      {cats.length > 1 && (
        <div className="-mx-4 mt-9 flex gap-2 overflow-x-auto px-4 pb-2 pt-0.5 [mask-image:linear-gradient(to_right,#000_92%,transparent)] [scrollbar-width:none] sm:mx-0 sm:px-0" role="tablist" aria-label="Filter featured courses">
          {[{ slug: null as string | null, name: "All courses", n: courses.length }, ...cats].map((c) => {
            const on = cat === c.slug;
            return (
              <button
                key={c.slug ?? "all"}
                type="button"
                role="tab"
                aria-selected={on}
                onClick={() => setCat(c.slug)}
                className={cn(
                  "relative inline-flex h-10 shrink-0 items-center gap-2 rounded-full border-2 px-4 text-[13.5px] font-semibold transition-[color,border-color,transform] duration-200 active:translate-y-px",
                  on ? "border-transparent text-white" : "border-line-3d bg-surface text-muted-foreground hover:border-border-strong hover:text-foreground",
                )}
              >
                {on && (
                  <motion.span
                    layoutId="featured-chip"
                    className="absolute -inset-[2px] rounded-full bg-ink shadow-[0_3px_0_0_oklch(0.05_0_0)]"
                    transition={{ type: "spring", stiffness: 420, damping: 34 }}
                  />
                )}
                <span className="relative">{c.name}</span>
                <span className={cn("relative rounded-full px-1.5 text-[11px] tabular-nums", on ? "bg-white/15 text-white" : "bg-surface-2 text-subtle-foreground")}>{c.n}</span>
              </button>
            );
          })}
        </div>
      )}

      <SpotlightGrid className="mt-7">
        <motion.div layout={!reduce} className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <AnimatePresence mode="popLayout" initial={false}>
            {shown.map((c, i) => (
              <motion.div
                key={c.id}
                layout={!reduce}
                initial={reduce ? false : { opacity: 0, y: 30, scale: 0.96 }}
                whileInView={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, scale: 0.94, transition: { duration: 0.2 } }}
                viewport={{ once: true, margin: "-60px" }}
                transition={{ duration: 0.6, delay: (i % 3) * 0.08, ease: EASE }}
                className="h-full"
              >
                <CourseCard course={c} className="h-full" priority={i < 3} />
              </motion.div>
            ))}
          </AnimatePresence>
        </motion.div>
      </SpotlightGrid>
    </LayoutGroup>
  );
}
