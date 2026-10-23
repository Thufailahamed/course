"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { BookOpen, Check, MessageCircle, Play, Sparkles, Target } from "lucide-react";
import { cn } from "@/lib/utils";

const EASE = [0.22, 1, 0.36, 1] as const;

const STEPS = [
  {
    icon: BookOpen,
    tone: "bg-accent shadow-[0_3px_0_0_var(--accent-edge)]",
    kicker: "01 · Understand",
    title: "Start with intuition, not jargon",
    body: "Short, visual explanations build the mental model first. The math arrives once it has somewhere to land.",
  },
  {
    icon: Play,
    tone: "bg-[oklch(0.6_0.2_300)] shadow-[0_3px_0_0_oklch(0.47_0.19_300)]",
    kicker: "02 · Run",
    title: "Run real code right in the lesson",
    body: "Python, Java, C and JavaScript run in your browser. No setup, no installs. Edit anything and run it again.",
  },
  {
    icon: Target,
    tone: "bg-go shadow-[0_3px_0_0_var(--go-edge)]",
    kicker: "03 · Prove it",
    title: "Lock it in with challenges",
    body: "Every few minutes you solve something. Instant feedback tells you exactly what's off, with hints when you need them.",
  },
  {
    icon: MessageCircle,
    tone: "bg-[oklch(0.75_0.17_55)] shadow-[0_3px_0_0_oklch(0.6_0.16_45)]",
    kicker: "04 · Ask",
    title: "Get unstuck with Atlas, any hour",
    body: "Your AI tutor sees the lesson and your code. It nudges instead of handing over answers, so the learning stays yours.",
  },
];

/** Scroll-driven walkthrough: text steps scroll by while the matching scene stays pinned beside them. */
export function LearnStory() {
  const [active, setActive] = useState(0);
  const refs = useRef<(HTMLDivElement | null)[]>([]);

  useEffect(() => {
    const io = new IntersectionObserver(
      (entries) => {
        for (const e of entries) if (e.isIntersecting) setActive(Number((e.target as HTMLElement).dataset.step));
      },
      { rootMargin: "-48% 0px -48% 0px" },
    );
    refs.current.forEach((el) => el && io.observe(el));
    return () => io.disconnect();
  }, []);

  return (
    <div className="grid gap-10 lg:grid-cols-[1fr_1.1fr] lg:gap-16">
      {/* Steps */}
      <div className="relative">
        <div aria-hidden className="absolute bottom-[18vh] left-[21px] top-[18vh] hidden w-[3px] rounded-full bg-surface-3 lg:block">
          <motion.div className="w-full rounded-full bg-accent" animate={{ height: `${((active + 1) / STEPS.length) * 100}%` }} transition={{ duration: 0.6, ease: EASE }} />
        </div>
        {STEPS.map((s, i) => (
          <div
            key={s.title}
            ref={(el) => {
              refs.current[i] = el;
            }}
            data-step={i}
            className="flex min-h-[auto] flex-col justify-center py-8 lg:min-h-[72vh] lg:py-0"
          >
            <div className={cn("flex gap-5 transition-opacity duration-500", active === i ? "opacity-100" : "lg:opacity-35")}>
              <span className={cn("relative z-[1] flex size-11 shrink-0 items-center justify-center rounded-[14px] text-white transition-transform duration-500", s.tone, active === i && "lg:scale-110")}>
                <s.icon className="size-5" strokeWidth={2.25} />
              </span>
              <div className="max-w-md">
                <p className="text-[12px] font-bold uppercase tracking-[0.1em] text-subtle-foreground">{s.kicker}</p>
                <h3 className="mt-2 text-[1.65rem] font-bold leading-[1.12] tracking-[-0.035em] sm:text-[2rem]">{s.title}</h3>
                <p className="mt-3 text-[16px] leading-relaxed text-muted-foreground">{s.body}</p>
              </div>
            </div>
            <div className="mt-8 lg:hidden">
              <Scene step={i} />
            </div>
          </div>
        ))}
      </div>

      {/* Pinned scene */}
      <div className="hidden lg:block">
        <div className="sticky top-[calc(50vh-230px)] h-[460px]">
          <div aria-hidden className="absolute -inset-10 rounded-[40px] bg-[radial-gradient(closest-side,var(--accent-soft),transparent)]" />
          <AnimatePresence mode="wait">
            <motion.div
              key={active}
              initial={{ opacity: 0, y: 24, scale: 0.97 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: -16, scale: 0.98 }}
              transition={{ duration: 0.45, ease: EASE }}
              className="relative h-full"
            >
              <Scene step={active} />
            </motion.div>
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}

function Scene({ step }: { step: number }) {
  return (
    <div className="card-3d flex h-full min-h-[360px] flex-col overflow-hidden">
      {step === 0 && <ReadScene />}
      {step === 1 && <CodeScene />}
      {step === 2 && <CheckScene />}
      {step === 3 && <TutorScene />}
    </div>
  );
}

function SceneBar({ label }: { label: string }) {
  return (
    <div className="flex items-center gap-2 border-b-2 border-line-3d px-5 py-3 text-[12px] font-semibold text-muted-foreground">
      <span className="flex gap-1.5">
        <span className="size-2.5 rounded-full bg-[oklch(0.68_0.17_25)]/80" />
        <span className="size-2.5 rounded-full bg-[oklch(0.8_0.14_80)]/80" />
        <span className="size-2.5 rounded-full bg-[oklch(0.72_0.15_150)]/80" />
      </span>
      <span className="ml-2">{label}</span>
    </div>
  );
}

function ReadScene() {
  const reduce = useReducedMotion();
  return (
    <>
      <SceneBar label="Lesson 2.1 · Gradient descent" />
      <div className="flex flex-1 flex-col justify-center gap-6 p-7">
        <h4 className="text-[22px] font-bold tracking-[-0.03em]">Walk downhill, one step at a time</h4>
        <svg viewBox="0 0 400 130" className="w-full">
          <path d="M10 20 C 90 20, 120 115, 200 115 S 320 30, 390 20" fill="none" stroke="var(--line-3d)" strokeWidth="6" strokeLinecap="round" />
          <motion.path
            d="M10 20 C 90 20, 120 115, 200 115"
            fill="none"
            stroke="var(--accent)"
            strokeWidth="6"
            strokeLinecap="round"
            initial={reduce ? false : { pathLength: 0 }}
            animate={{ pathLength: 1 }}
            transition={{ duration: 1.4, ease: "easeInOut" }}
          />
          <motion.circle r="10" fill="var(--go)" stroke="white" strokeWidth="3" initial={reduce ? false : { cx: 10, cy: 20 }} animate={{ cx: 200, cy: 115 }} transition={{ duration: 1.4, ease: "easeInOut" }} />
        </svg>
        <div className="rounded-2xl bg-surface-2 px-5 py-4 text-center font-serif text-[26px] italic">
          θ ← θ − <span className="text-accent">η</span> ∇L(θ)
        </div>
      </div>
    </>
  );
}

const CODE = ["for step in range(100):", "    grad = loss.backward()", "    w -= lr * grad", "print(f\"loss: {loss:.3f}\")"];

function CodeScene() {
  const reduce = useReducedMotion();
  const total = CODE.join("\n").length;
  const [n, setN] = useState(reduce ? total : 0);
  useEffect(() => {
    if (reduce) return;
    const t = setInterval(() => setN((x) => (x >= total ? x : x + 2)), 28);
    return () => clearInterval(t);
  }, [reduce, total]);
  const typed = CODE.join("\n").slice(0, n);
  return (
    <div className="code-surface flex flex-1 flex-col">
      <div className="flex items-center gap-2 border-b border-[var(--code-border)] px-5 py-3 font-mono text-[12px] text-[var(--code-muted)]">
        <span className="flex gap-1.5">
          <span className="size-2.5 rounded-full bg-[oklch(0.68_0.17_25)]/85" />
          <span className="size-2.5 rounded-full bg-[oklch(0.8_0.14_80)]/85" />
          <span className="size-2.5 rounded-full bg-[oklch(0.72_0.15_150)]/85" />
        </span>
        <span className="ml-2">train.py</span>
      </div>
      <pre className="flex-1 p-6 font-mono text-[14.5px] leading-[1.9] text-[var(--code-fg)]">
        {typed}
        <span className="ml-0.5 inline-block h-4 w-[2px] translate-y-0.5 animate-blink bg-[var(--code-fg)]" />
      </pre>
      <div className="flex items-center gap-3 border-t border-[var(--code-border)] px-5 py-4">
        <span className="btn-3d btn-3d-sm btn-3d-green pointer-events-none">
          <Play className="size-3 fill-current" /> Run
        </span>
        <AnimatePresence>
          {n >= total && (
            <motion.span initial={{ opacity: 0, x: -8 }} animate={{ opacity: 1, x: 0 }} className="font-mono text-[13px] text-[var(--code-string)]">
              loss: 0.042 ✓ <span className="text-[var(--code-faint)]">· 38 ms</span>
            </motion.span>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

function CheckScene() {
  const [checked, setChecked] = useState(false);
  useEffect(() => {
    const t = setTimeout(() => setChecked(true), 900);
    return () => clearTimeout(t);
  }, []);
  return (
    <>
      <div className="flex items-start gap-4 px-6 pb-4 pt-6">
        <span className="flex size-11 shrink-0 items-center justify-center rounded-[14px] bg-accent text-white shadow-[0_3px_0_0_var(--accent-edge)]">
          <Target className="size-5" />
        </span>
        <div>
          <p className="text-[12px] font-bold uppercase tracking-[0.08em] text-accent">Challenge</p>
          <h4 className="text-[18px] font-bold tracking-[-0.025em]">What happens if η is too large?</h4>
        </div>
      </div>
      <div className="grid flex-1 content-start gap-3 px-6">
        {["The loss converges faster", "Steps overshoot and the loss diverges", "Nothing changes"].map((o, i) => {
          const right = i === 1;
          return (
            <motion.div
              key={o}
              animate={checked && right ? { scale: [1, 1.03, 1] } : {}}
              transition={{ duration: 0.4 }}
              className={cn(
                "flex items-center gap-3 rounded-2xl border-2 px-4 py-3 text-[14px] font-medium transition-colors duration-300",
                checked && right ? "border-go bg-go-soft shadow-[0_3px_0_0_var(--go-edge)]" : "border-line-3d bg-surface shadow-[0_3px_0_0_var(--line-3d)]",
                checked && !right && "opacity-50",
              )}
            >
              <span className={cn("flex size-7 items-center justify-center rounded-lg border-2 text-[12px] font-bold", checked && right ? "border-go bg-go text-white" : "border-line-3d text-subtle-foreground")}>
                {checked && right ? <Check className="size-3.5" strokeWidth={3} /> : "ABC"[i]}
              </span>
              {o}
            </motion.div>
          );
        })}
      </div>
      <AnimatePresence>
        {checked && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ type: "spring", stiffness: 300, damping: 24 }} className="mt-5 flex items-center gap-4 bg-go-soft px-6 py-4">
            <span className="flex size-10 items-center justify-center rounded-full bg-go text-white shadow-[0_3px_0_0_var(--go-edge)]">
              <Check className="size-5" strokeWidth={3.25} />
            </span>
            <div>
              <p className="text-[17px] font-bold text-go-edge">Correct!</p>
              <p className="text-[13px] text-muted-foreground">Big steps jump right past the minimum.</p>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}

const CHAT = [
  { me: true, text: "Why does my loss bounce around instead of going down?" },
  { me: false, text: "Your learning rate (0.9) is large for this surface, so each step overshoots. What happens if you halve it?" },
  { me: true, text: "It converges now!" },
];

function TutorScene() {
  const [shown, setShown] = useState(1);
  useEffect(() => {
    const t = setInterval(() => setShown((n) => Math.min(CHAT.length, n + 1)), 1100);
    return () => clearInterval(t);
  }, []);
  return (
    <>
      <div className="flex items-center gap-2.5 border-b-2 border-line-3d px-5 py-3">
        <span className="flex size-7 items-center justify-center rounded-full bg-accent text-white">
          <Sparkles className="size-3.5" />
        </span>
        <span className="text-[14px] font-bold">Atlas</span>
        <span className="ml-auto text-[12px] text-subtle-foreground">sees Lesson 2.1 + your code</span>
      </div>
      <div className="flex flex-1 flex-col justify-end gap-3 p-6">
        {CHAT.slice(0, shown).map((m, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 12, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            transition={{ type: "spring", stiffness: 320, damping: 26 }}
            className={cn(
              "max-w-[85%] rounded-2xl px-4 py-2.5 text-[14px] leading-relaxed",
              m.me ? "ml-auto rounded-br-md bg-ink text-ink-foreground" : "rounded-bl-md bg-surface-2 text-foreground/85",
            )}
          >
            {m.text}
          </motion.div>
        ))}
        {shown < CHAT.length && (
          <div className={cn("flex w-fit gap-1 rounded-2xl bg-surface-2 px-4 py-3", CHAT[shown]!.me && "ml-auto bg-ink")}>
            {[0, 1, 2].map((d) => (
              <motion.span key={d} className={cn("size-1.5 rounded-full", CHAT[shown]!.me ? "bg-white/70" : "bg-subtle-foreground")} animate={{ y: [0, -4, 0] }} transition={{ duration: 0.6, repeat: Infinity, delay: d * 0.12 }} />
            ))}
          </div>
        )}
      </div>
    </>
  );
}
