"use client";

import { motion, useMotionValue, useReducedMotion, useSpring, useTransform } from "motion/react";
import { useEffect, useRef, useState } from "react";
import { Check, ChevronRight, Flame, MousePointerClick, Sparkles } from "lucide-react";

const TOKENS = ["The", "model", "learns", "to", "attend", "to", "context"];

// Attention weights per query token (rows) — hand-tuned to look plausible.
const WEIGHTS = [
  [0.9, 0.05, 0.02, 0.01, 0.01, 0.005, 0.005],
  [0.35, 0.55, 0.05, 0.02, 0.01, 0.01, 0.01],
  [0.1, 0.6, 0.22, 0.03, 0.02, 0.02, 0.01],
  [0.05, 0.15, 0.4, 0.3, 0.05, 0.03, 0.02],
  [0.04, 0.38, 0.18, 0.08, 0.26, 0.03, 0.03],
  [0.02, 0.05, 0.1, 0.1, 0.48, 0.2, 0.05],
  [0.03, 0.3, 0.08, 0.04, 0.3, 0.1, 0.15],
];

const OUTLINE = [
  { t: "Queries, keys and values", done: true },
  { t: "Scaled dot-product attention", active: true },
  { t: "Multi-head attention" },
  { t: "Positional encodings" },
];

const EASE = [0.22, 1, 0.36, 1] as const;

/** Product-style hero composition: a lesson window with a live attention diagram.
 * Tilts toward the cursor; hovering a token (or a heatmap row) takes over from the autoplay. */
export function HeroVisual() {
  const reduce = useReducedMotion();
  const [q, setQ] = useState(4);
  const [pausedUntil, setPausedUntil] = useState(0);
  useEffect(() => {
    if (reduce) return;
    const t = setInterval(() => {
      if (Date.now() > pausedUntil) setQ((x) => (x + 1) % TOKENS.length);
    }, 2400);
    return () => clearInterval(t);
  }, [reduce, pausedUntil]);
  const pick = (i: number) => {
    setQ(i);
    setPausedUntil(Date.now() + 6000);
  };

  // Cursor tilt
  const box = useRef<HTMLDivElement>(null);
  const px = useMotionValue(0);
  const py = useMotionValue(0);
  const rotateY = useSpring(useTransform(px, [-0.5, 0.5], [-7, 7]), { stiffness: 150, damping: 18 });
  const rotateX = useSpring(useTransform(py, [-0.5, 0.5], [6, -6]), { stiffness: 150, damping: 18 });
  const onMove = (e: React.PointerEvent) => {
    if (reduce || !box.current) return;
    const r = box.current.getBoundingClientRect();
    px.set((e.clientX - r.left) / r.width - 0.5);
    py.set((e.clientY - r.top) / r.height - 0.5);
  };
  const onLeave = () => {
    px.set(0);
    py.set(0);
  };

  const w = WEIGHTS[q]!;
  const xs = TOKENS.map((_, i) => 34 + i * 62);

  return (
    <div ref={box} onPointerMove={onMove} onPointerLeave={onLeave} className="relative mx-auto w-full max-w-[580px] select-none [perspective:1400px]">
      {/* Floating chips */}
      <FloatChip className="-left-8 -top-9 hidden lg:flex" delay={1.4} duration={7}>
        <span className="flex size-7 items-center justify-center rounded-full bg-go text-white shadow-[0_2px_0_0_var(--go-edge)]">
          <Check className="size-4" strokeWidth={3} />
        </span>
        <span>
          <span className="block font-semibold text-foreground">Checkpoint passed</span>
          <span className="text-subtle-foreground">+20 XP · Attention basics</span>
        </span>
      </FloatChip>
      <FloatChip className="-bottom-11 -right-5 hidden sm:flex" delay={1.6} duration={6}>
        <span className="flex size-7 items-center justify-center rounded-full bg-[oklch(0.75_0.17_55)] text-white shadow-[0_2px_0_0_oklch(0.6_0.16_45)]">
          <Flame className="size-4" />
        </span>
        <span className="font-semibold text-foreground">
          12-day streak
        </span>
      </FloatChip>
      <FloatChip className="-bottom-11 left-6 hidden sm:flex" delay={1.8} duration={8}>
        <MousePointerClick className="size-4 text-accent" />
        <span className="text-muted-foreground">
          <span className="font-semibold text-foreground">Try it:</span> hover a token
        </span>
      </FloatChip>

      <motion.div
        initial={reduce ? false : { opacity: 0, y: 40, rotateX: 18, scale: 0.94 }}
        animate={{ opacity: 1, y: 0, rotateX: 0, scale: 1 }}
        transition={{ duration: 1.1, delay: 0.35, ease: EASE }}
        style={{ transformStyle: "preserve-3d" }}
      >
      <motion.div
        style={{ rotateX, rotateY, transformStyle: "preserve-3d" }}
        className="relative overflow-hidden rounded-[20px] border border-border-strong bg-surface shadow-[0_1px_2px_oklch(0.2_0.01_265/0.06),0_40px_80px_-30px_oklch(0.3_0.08_262/0.35)]"
      >
        {/* Window bar */}
        <div className="flex items-center gap-2 border-b border-border bg-surface-2/70 px-4 py-2.5 text-[11.5px] text-muted-foreground">
          <span>Transformers from Scratch</span>
          <ChevronRight className="size-3 text-subtle-foreground" />
          <span className="text-foreground">Lesson 3.2</span>
          <span className="ml-auto font-mono text-[10.5px] text-subtle-foreground">head 4 / 8</span>
        </div>

        <div className="grid sm:grid-cols-[1fr_168px]">
          <div className="p-5">
            <p className="text-[11.5px] font-medium text-accent">Interactive figure</p>
            <h3 className="mt-1 text-[15px] font-semibold tracking-[-0.015em]">Scaled dot-product attention</h3>

            {/* Attention arcs */}
            <div className="mt-4 rounded-xl border border-border bg-background/60 p-2.5">
              <svg viewBox="0 0 440 150" className="w-full" aria-label="Attention visualization">
                {xs.map((x, i) => {
                  if (i === q) return null;
                  const x0 = xs[q]!;
                  const mid = (x0 + x) / 2;
                  const height = 22 + Math.abs(x - x0) * 0.32;
                  return (
                    <motion.path
                      key={`${q}-${i}`}
                      d={`M ${x0} 104 Q ${mid} ${104 - height * 1.6} ${x} 104`}
                      fill="none"
                      stroke="var(--accent)"
                      strokeLinecap="round"
                      initial={reduce ? false : { pathLength: 0, opacity: 0 }}
                      animate={{ pathLength: 1, opacity: 0.18 + w[i]! * 1.3 }}
                      transition={{ duration: 0.9, delay: i * 0.05, ease: "easeOut" }}
                      strokeWidth={1 + w[i]! * 8}
                    />
                  );
                })}
                {TOKENS.map((t, i) => (
                  <g key={t + i} onPointerEnter={() => pick(i)} onClick={() => pick(i)} className="cursor-pointer">
                    <rect
                      x={xs[i]! - 28}
                      y={110}
                      width={56}
                      height={26}
                      rx={13}
                      fill={i === q ? "var(--accent)" : "var(--surface)"}
                      stroke={i === q ? "var(--accent)" : "var(--border-strong)"}
                      className="transition-all duration-500"
                    />
                    <text x={xs[i]} y={127} textAnchor="middle" fontSize="11" fontFamily="var(--font-mono)" fill={i === q ? "var(--primary-foreground)" : "var(--muted-foreground)"}>
                      {t}
                    </text>
                  </g>
                ))}
              </svg>
            </div>

            {/* Heatmap + code */}
            <div className="mt-3 grid grid-cols-[auto_1fr] gap-3">
              <div className="grid grid-cols-7 gap-[3px] rounded-xl border border-border bg-background/60 p-2.5" aria-hidden>
                {WEIGHTS.flatMap((row, r) =>
                  row.map((v, c) => (
                    <span
                      key={`${r}-${c}`}
                      onPointerEnter={() => pick(r)}
                      className="size-[11px] cursor-pointer rounded-[2px] transition-all duration-500 sm:size-3"
                      style={{
                        background: `color-mix(in oklch, var(--accent) ${Math.round(Math.min(1, v * 1.5) * 100)}%, var(--surface-2))`,
                        opacity: r === q ? 1 : 0.45,
                      }}
                    />
                  )),
                )}
              </div>
              <pre className="overflow-hidden rounded-xl border border-border bg-background/60 p-3 font-mono text-[10.5px] leading-[1.75] text-muted-foreground sm:text-[11px]">
                <span className="text-[oklch(0.5_0.17_300)]">def</span> <span className="text-foreground">attention</span>(q, k, v):{"\n"}
                {"  "}s = q @ k.T / <span className="text-accent">√d</span>{"\n"}
                {"  "}<span className="text-[oklch(0.5_0.17_300)]">return</span> softmax(s) @ v
              </pre>
            </div>
          </div>

          {/* Outline rail */}
          <aside className="hidden border-l border-border bg-surface-2/40 p-4 sm:block">
            <p className="text-[11.5px] font-medium text-muted-foreground">Module 3</p>
            <ol className="mt-3 space-y-2.5">
              {OUTLINE.map((o, i) => (
                <li key={o.t} className="flex gap-2 text-[11.5px] leading-snug">
                  <span
                    className={
                      o.done
                        ? "mt-px flex size-4 shrink-0 items-center justify-center rounded-full bg-go text-white"
                        : o.active
                          ? "mt-px flex size-4 shrink-0 items-center justify-center rounded-full border-[1.5px] border-accent"
                          : "mt-px flex size-4 shrink-0 items-center justify-center rounded-full border border-border-strong"
                    }
                  >
                    {o.done ? <Check className="size-2.5" strokeWidth={3} /> : o.active ? <span className="size-1.5 rounded-full bg-accent" /> : null}
                  </span>
                  <span className={o.active ? "font-medium text-foreground" : "text-muted-foreground"}>
                    <span className="mr-1 font-mono text-[10px] text-subtle-foreground">3.{i + 1}</span>
                    {o.t}
                  </span>
                </li>
              ))}
            </ol>
            <div className="mt-5 border-t border-border pt-4">
              <div className="flex items-center justify-between text-[10.5px] text-subtle-foreground">
                <span>Course progress</span>
                <span className="font-mono">64%</span>
              </div>
              <div className="mt-1.5 h-1 overflow-hidden rounded-full bg-surface-3">
                <motion.div
                  className="h-full rounded-full bg-accent"
                  initial={reduce ? false : { width: "18%" }}
                  animate={{ width: "64%" }}
                  transition={{ duration: 2, delay: 0.5, ease: [0.22, 1, 0.36, 1] }}
                />
              </div>
            </div>
          </aside>
        </div>

        {/* Tutor annotation */}
        <div className="flex items-start gap-3 border-t border-border bg-surface-2 px-5 py-3.5">
          <span className="mt-0.5 flex size-6 shrink-0 items-center justify-center rounded-full bg-accent text-white">
            <Sparkles className="size-3" />
          </span>
          <p className="text-[12.5px] leading-relaxed text-muted-foreground">
            <span className="font-semibold text-foreground">Atlas, your tutor</span> — dividing by <span className="font-mono text-foreground">√d</span> keeps the softmax from saturating as dimensions grow.
            <span className="ml-0.5 inline-block h-3.5 w-[2px] translate-y-0.5 animate-blink bg-accent" />
          </p>
        </div>
      </motion.div>
      </motion.div>

    </div>
  );
}

function FloatChip({ children, className, delay, duration }: { children: React.ReactNode; className?: string; delay: number; duration: number }) {
  const reduce = useReducedMotion();
  return (
    <motion.div
      initial={reduce ? false : { opacity: 0, scale: 0.8, y: 10 }}
      animate={{ opacity: 1, scale: 1, y: 0 }}
      transition={{ delay, type: "spring", stiffness: 260, damping: 20 }}
      className={`absolute z-10 ${className}`}
      style={{ transform: "translateZ(60px)" }}
    >
      <div
        className="flex items-center gap-2.5 rounded-2xl border border-border bg-surface/95 px-3 py-2 text-[12px] leading-tight shadow-[0_12px_32px_-12px_oklch(0.2_0.02_265/0.35)] backdrop-blur animate-float"
        style={{ animationDuration: `${duration}s`, animationDelay: `${delay}s` }}
      >
        {children}
      </div>
    </motion.div>
  );
}
