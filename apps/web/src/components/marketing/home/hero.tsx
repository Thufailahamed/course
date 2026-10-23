"use client";

import Link from "next/link";
import { useEffect, useRef } from "react";
import { motion, useMotionTemplate, useMotionValue, useReducedMotion, useSpring } from "motion/react";
import { ArrowRight, ChevronRight, Star } from "lucide-react";
import { HeroVisual } from "@/components/marketing/hero-visual";
import { Avatar } from "@/components/ui/display";
import { CountUp } from "./count-up";

const EASE = [0.22, 1, 0.36, 1] as const;
const LEAD = ["Learn", "AI", "from", "the", "people"];
const LEARNERS = ["Aisha Rahman", "Ben Carter", "Jia Wang", "Mateo Silva", "Priya Iyer"];

/** Landing hero: staggered headline, hand-drawn underline, cursor spotlight and the live lesson demo. */
export function Hero({ learners, rating }: { learners: number; rating: number }) {
  const reduce = useReducedMotion();
  const section = useRef<HTMLElement>(null);
  const mx = useSpring(useMotionValue(-999), { stiffness: 120, damping: 20 });
  const my = useSpring(useMotionValue(-999), { stiffness: 120, damping: 20 });
  const glow = useMotionTemplate`radial-gradient(520px circle at ${mx}px ${my}px, oklch(0.57 0.21 262 / 0.09), transparent 60%)`;

  useEffect(() => {
    const el = section.current;
    if (!el || reduce) return;
    const move = (e: PointerEvent) => {
      const r = el.getBoundingClientRect();
      mx.set(e.clientX - r.left);
      my.set(e.clientY - r.top);
    };
    el.addEventListener("pointermove", move);
    return () => el.removeEventListener("pointermove", move);
  }, [mx, my, reduce]);

  const word = (i: number) => ({
    initial: reduce ? false : { opacity: 0, y: 28, filter: "blur(10px)" },
    animate: { opacity: 1, y: 0, filter: "blur(0px)" },
    transition: { duration: 0.8, delay: 0.15 + i * 0.07, ease: EASE },
  });

  return (
    <section ref={section} className="relative overflow-hidden border-b border-border bg-surface">
      {/* Backdrop */}
      <div aria-hidden className="bg-dots pointer-events-none absolute inset-0" />
      <div aria-hidden className="pointer-events-none absolute -left-40 -top-40 size-[520px] rounded-full bg-[oklch(0.57_0.21_262/0.10)] blur-[110px]" />
      <div aria-hidden className="pointer-events-none absolute -right-32 top-1/3 size-[460px] rounded-full bg-[oklch(0.7_0.19_145/0.10)] blur-[110px]" />
      <motion.div aria-hidden className="pointer-events-none absolute inset-0" style={{ background: glow }} />

      <div className="container-page relative grid items-center gap-16 pb-24 pt-16 lg:grid-cols-[1fr_1.05fr] lg:gap-10 lg:pb-28 lg:pt-24">
        <div>
          <motion.div initial={reduce ? false : { opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, ease: EASE }}>
            <Link
              href="/courses/building-ai-agents"
              className="group inline-flex items-center gap-2 rounded-full border border-border bg-surface/80 py-1 pl-1 pr-3 text-[13px] text-muted-foreground shadow-2xs backdrop-blur transition hover:border-border-strong hover:text-foreground"
            >
              <span className="relative inline-flex items-center gap-1.5 rounded-full bg-accent px-2.5 py-0.5 text-[12px] font-semibold text-white">
                <span className="relative flex size-1.5">
                  <span className="absolute inline-flex size-full animate-ping rounded-full bg-white/80" />
                  <span className="relative inline-flex size-1.5 rounded-full bg-white" />
                </span>
                New
              </span>
              Building Reliable AI Agents
              <ChevronRight className="size-3.5 transition-transform group-hover:translate-x-0.5" />
            </Link>
          </motion.div>

          <h1 className="mt-7 text-[2.9rem] font-bold leading-[1.02] tracking-[-0.045em] sm:text-[3.8rem] lg:text-[4.4rem]">
            <span className="sr-only">Learn AI from the people who build it.</span>
            <span aria-hidden>
              {LEAD.map((w, i) => (
                <motion.span key={w} {...word(i)} className="mr-[0.22em] inline-block">
                  {w}
                </motion.span>
              ))}
              <motion.span {...word(LEAD.length)} className="mr-[0.22em] inline-block">
                who
              </motion.span>
              <motion.span {...word(LEAD.length + 1)} className="relative inline-block whitespace-nowrap font-serif font-normal italic tracking-[-0.02em] text-accent">
                build it.
                <svg viewBox="0 0 300 24" preserveAspectRatio="none" className="absolute -bottom-2 left-0 h-[0.32em] w-full overflow-visible">
                  <motion.path
                    d="M4 16 C 60 6, 120 4, 180 10 S 270 18, 296 8"
                    fill="none"
                    stroke="var(--go)"
                    strokeWidth="5"
                    strokeLinecap="round"
                    initial={reduce ? false : { pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ duration: 0.9, delay: 1.05, ease: "easeInOut" }}
                  />
                </svg>
              </motion.span>
            </span>
          </h1>

          <motion.p
            initial={reduce ? false : { opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.75, ease: EASE }}
            className="mt-7 max-w-[33rem] text-[17.5px] leading-relaxed text-muted-foreground"
          >
            In-depth, hands-on courses in machine learning, deep learning and LLM engineering, with an AI tutor beside you in every lesson.
          </motion.p>

          <motion.div
            initial={reduce ? false : { opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.9, ease: EASE }}
            className="mt-9 flex flex-col gap-3.5 sm:flex-row"
          >
            <Link href="/courses" className="btn-3d group h-12 px-6 text-[15px]">
              Explore courses <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
            </Link>
            <Link href="/paths" className="btn-3d btn-3d-white h-12 px-6 text-[15px]">
              View learning paths
            </Link>
          </motion.div>

          <motion.div initial={reduce ? false : { opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.8, delay: 1.1 }} className="mt-11 flex items-center gap-4">
            <div className="flex -space-x-2.5">
              {LEARNERS.map((n, i) => (
                <motion.span
                  key={n}
                  initial={reduce ? false : { opacity: 0, x: -8, scale: 0.8 }}
                  animate={{ opacity: 1, x: 0, scale: 1 }}
                  transition={{ delay: 1.15 + i * 0.06, type: "spring", stiffness: 300, damping: 20 }}
                >
                  <Avatar name={n} size={34} ring />
                </motion.span>
              ))}
            </div>
            <div className="text-[13.5px] leading-snug">
              <div className="flex items-center gap-1.5">
                <span className="flex text-star">
                  {[0, 1, 2, 3, 4].map((i) => (
                    <Star key={i} className="size-3.5 fill-current" strokeWidth={0} />
                  ))}
                </span>
                <span className="font-semibold text-foreground">{rating.toFixed(1)}</span>
              </div>
              <p className="text-muted-foreground">
                from <CountUp value={learners} className="font-semibold text-foreground" />+ learners
              </p>
            </div>
          </motion.div>
        </div>

        <HeroVisual />
      </div>
    </section>
  );
}
