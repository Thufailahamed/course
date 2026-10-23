"use client";

import { useRef } from "react";
import { motion, useReducedMotion, useScroll, useSpring } from "motion/react";
import { cn } from "@/lib/utils";

/** Thin accent bar pinned to the top of the viewport that fills as you scroll. */
export function ScrollProgress() {
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, { stiffness: 120, damping: 24, mass: 0.3 });
  return <motion.div aria-hidden className="fixed inset-x-0 top-0 z-[60] h-[3px] origin-left bg-[linear-gradient(90deg,var(--accent),var(--go))]" style={{ scaleX }} />;
}

/** Infinite horizontal marquee. Children are rendered twice so the loop is seamless; hover pauses it. */
export function Marquee({ children, reverse, duration = 40, className }: { children: React.ReactNode; reverse?: boolean; duration?: number; className?: string }) {
  return (
    <div className={cn("group flex overflow-hidden mask-fade-x", className)}>
      {[0, 1].map((k) => (
        <div
          key={k}
          aria-hidden={k === 1}
          className="flex shrink-0 items-center animate-marquee group-hover:[animation-play-state:paused] motion-reduce:animate-none"
          style={{ animationDuration: `${duration}s`, animationDirection: reverse ? "reverse" : "normal" }}
        >
          {children}
        </div>
      ))}
    </div>
  );
}

/** Grid that lights up each `.spotlight` child under the cursor. */
export function SpotlightGrid({ children, className }: { children: React.ReactNode; className?: string }) {
  const ref = useRef<HTMLDivElement>(null);
  const reduce = useReducedMotion();
  const onMove = (e: React.PointerEvent) => {
    if (reduce) return;
    ref.current?.querySelectorAll<HTMLElement>(".spotlight").forEach((el) => {
      const r = el.getBoundingClientRect();
      el.style.setProperty("--mx", `${e.clientX - r.left}px`);
      el.style.setProperty("--my", `${e.clientY - r.top}px`);
    });
  };
  return (
    <div ref={ref} onPointerMove={onMove} className={className}>
      {children}
    </div>
  );
}

/** Staggers its direct children in as the group scrolls into view. */
export function Stagger({ children, className, gap = 0.07 }: { children: React.ReactNode[]; className?: string; gap?: number }) {
  const reduce = useReducedMotion();
  return (
    <motion.div className={className} initial={reduce ? false : "hidden"} whileInView="show" viewport={{ once: true, margin: "-80px" }} transition={{ staggerChildren: gap }}>
      {children.map((c, i) => (
        <motion.div
          key={i}
          className="h-full"
          variants={{ hidden: { opacity: 0, y: 26, scale: 0.98 }, show: { opacity: 1, y: 0, scale: 1, transition: { duration: 0.7, ease: [0.22, 1, 0.36, 1] } } }}
        >
          {c}
        </motion.div>
      ))}
    </motion.div>
  );
}
