"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { Pause, Play, RotateCcw, StepForward } from "lucide-react";
import { cn } from "@/lib/utils";

/** A loss surface with a shallow local minimum on the right and a deeper one on the left. */
const f = (x: number) => 0.12 * x ** 4 - 0.9 * x ** 2 + 0.35 * x + 2.2;
const df = (x: number) => 0.48 * x ** 3 - 1.8 * x + 0.35;

const W = 560;
const H = 300;
const X0 = -3.1;
const X1 = 3.1;
const Y0 = -0.6;
const Y1 = 5.4;
const sx = (x: number) => ((x - X0) / (X1 - X0)) * W;
const sy = (y: number) => H - ((y - Y0) / (Y1 - Y0)) * H;
const START = 2.75;
const LIMIT = 3.05;

type Outcome = "running" | "local" | "global" | "diverged";

/** Interactive gradient descent: pick a learning rate, click the curve to drop the ball, then step or play. */
export function DescentPlayground() {
  const reduce = useReducedMotion();
  const [lr, setLr] = useState(0.12);
  const [path, setPath] = useState<number[]>([START]);
  const [playing, setPlaying] = useState(false);
  const x = path[path.length - 1]!;
  const diverged = Math.abs(x) > LIMIT;
  const settled = !diverged && path.length > 1 && Math.abs(df(x) * lr) < 0.002;
  const outcome: Outcome = diverged ? "diverged" : settled ? (x < 0 ? "global" : "local") : "running";

  const curve = useMemo(() => {
    let d = "";
    for (let i = 0; i <= 160; i++) {
      const xv = X0 + ((X1 - X0) * i) / 160;
      d += `${i ? "L" : "M"}${sx(xv).toFixed(1)} ${sy(f(xv)).toFixed(1)}`;
    }
    return d;
  }, []);

  const step = () =>
    setPath((p) => {
      const cur = p[p.length - 1]!;
      if (Math.abs(cur) > LIMIT) return p;
      const next = cur - lr * df(cur);
      return [...p, Math.max(-LIMIT - 0.4, Math.min(LIMIT + 0.4, next))].slice(-60);
    });

  const stepRef = useRef(step);
  stepRef.current = step;
  useEffect(() => {
    if (!playing) return;
    const t = setInterval(() => stepRef.current(), reduce ? 60 : 320);
    return () => clearInterval(t);
  }, [playing, reduce]);
  useEffect(() => {
    if (outcome !== "running") setPlaying(false);
  }, [outcome]);

  const reset = (start = START) => {
    setPlaying(false);
    setPath([start]);
  };
  const svgRef = useRef<SVGSVGElement>(null);
  const dropAt = (e: React.MouseEvent) => {
    const r = svgRef.current!.getBoundingClientRect();
    const xv = X0 + ((e.clientX - r.left) / r.width) * (X1 - X0);
    reset(Math.max(-2.95, Math.min(2.95, xv)));
  };

  const bx = sx(Math.max(X0, Math.min(X1, x)));
  const by = sy(Math.min(Y1, f(Math.max(X0, Math.min(X1, x)))));
  const lrTone = lr < 0.06 ? "Cautious" : lr < 0.35 ? "Balanced" : lr < 0.8 ? "Bold" : "Reckless";

  return (
    <div className="card-3d grid overflow-hidden lg:grid-cols-[1fr_1.35fr]">
      {/* Controls */}
      <div className="flex flex-col p-7 sm:p-9">
        <p className="text-[12px] font-bold uppercase tracking-[0.1em] text-accent">Try it · Gradient descent</p>
        <h3 className="mt-2 text-[1.75rem] font-bold leading-[1.1] tracking-[-0.035em]">Feel the idea before you formalize it.</h3>
        <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">
          Every Latent lesson has figures you can poke. Set a learning rate, <span className="font-medium text-foreground">click anywhere on the curve</span> to drop the ball, and watch it roll downhill.
        </p>

        <div className="mt-7">
          <div className="flex items-baseline justify-between">
            <label htmlFor="lr" className="text-[13px] font-semibold">
              Learning rate <span className="font-mono text-accent">η = {lr.toFixed(2)}</span>
            </label>
            <span className={cn("text-[12px] font-semibold", lr < 0.8 ? "text-muted-foreground" : "text-danger")}>{lrTone}</span>
          </div>
          <input
            id="lr"
            type="range"
            min={0.02}
            max={1.1}
            step={0.01}
            value={lr}
            onChange={(e) => {
              setLr(Number(e.target.value));
              reset(path[0]);
            }}
            className="mt-3 h-2 w-full cursor-pointer appearance-none rounded-full bg-surface-3 accent-[var(--accent)] [&::-webkit-slider-thumb]:size-5 [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:border-[3px] [&::-webkit-slider-thumb]:border-white [&::-webkit-slider-thumb]:bg-accent [&::-webkit-slider-thumb]:shadow-[0_2px_0_0_var(--accent-edge),0_0_0_1px_var(--accent-edge)]"
          />
        </div>

        <div className="mt-6 flex flex-wrap gap-2.5">
          <button type="button" onClick={() => setPlaying((p) => !p)} disabled={outcome !== "running"} className="btn-3d btn-3d-sm btn-3d-blue px-4">
            {playing ? <Pause className="size-3.5 fill-current" /> : <Play className="size-3.5 fill-current" />} {playing ? "Pause" : "Play"}
          </button>
          <button type="button" onClick={step} disabled={playing || outcome !== "running"} className="btn-3d btn-3d-sm btn-3d-white">
            <StepForward className="size-3.5" /> Step
          </button>
          <button type="button" onClick={() => reset(path[0])} className="btn-3d btn-3d-sm btn-3d-white">
            <RotateCcw className="size-3.5" /> Reset
          </button>
        </div>

        <dl className="mt-auto grid grid-cols-3 gap-3 pt-8 text-center">
          {[
            ["Step", String(path.length - 1)],
            ["Loss", diverged ? "∞" : f(x).toFixed(3)],
            ["Gradient", diverged ? "—" : df(x).toFixed(2)],
          ].map(([k, v]) => (
            <div key={k} className="rounded-2xl bg-surface-2 px-2 py-3">
              <dt className="text-[11px] font-semibold uppercase tracking-[0.08em] text-subtle-foreground">{k}</dt>
              <dd className="mt-1 font-mono text-[17px] font-semibold tabular-nums text-foreground">{v}</dd>
            </div>
          ))}
        </dl>
      </div>

      {/* Plot */}
      <div className="relative border-t-2 border-line-3d bg-[linear-gradient(180deg,var(--surface-2),var(--surface))] p-4 sm:p-6 lg:border-l-2 lg:border-t-0">
        <div className="bg-dots pointer-events-none absolute inset-0 opacity-70" aria-hidden />
        <svg ref={svgRef} viewBox={`0 -20 ${W} ${H + 64}`} className="relative w-full cursor-crosshair" onClick={dropAt} role="img" aria-label="Loss curve with a ball performing gradient descent">
          <defs>
            <linearGradient id="loss-fill" x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor="var(--accent)" stopOpacity="0.16" />
              <stop offset="100%" stopColor="var(--accent)" stopOpacity="0" />
            </linearGradient>
          </defs>
          <path d={`${curve} L ${W} ${H + 20} L 0 ${H + 20} Z`} fill="url(#loss-fill)" />
          <motion.path
            d={curve}
            fill="none"
            stroke="var(--accent)"
            strokeWidth={3.5}
            strokeLinecap="round"
            initial={reduce ? false : { pathLength: 0 }}
            whileInView={{ pathLength: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 1.4, ease: "easeInOut" }}
          />
          {/* Minima markers */}
          {[
            [-2.04, "global min"],
            [1.84, "local min"],
          ].map(([mx, label]) => (
            <g key={label as string}>
              <line x1={sx(mx as number)} x2={sx(mx as number)} y1={sy(f(mx as number)) + 10} y2={H + 14} stroke="var(--border-strong)" strokeDasharray="3 4" />
              <text x={sx(mx as number)} y={H + 30} textAnchor="middle" fontSize="12" fill="var(--subtle-foreground)" fontFamily="var(--font-mono)">
                {label}
              </text>
            </g>
          ))}
          {/* Trail */}
          {path.slice(0, -1).map((p, i) =>
            Math.abs(p) <= X1 ? (
              <g key={i}>
                {i > 0 && Math.abs(path[i - 1]!) <= X1 && (
                  <line x1={sx(path[i - 1]!)} y1={sy(f(path[i - 1]!))} x2={sx(p)} y2={sy(f(p))} stroke="var(--go)" strokeOpacity={0.35} strokeWidth={2} strokeDasharray="2 4" />
                )}
                <circle cx={sx(p)} cy={sy(f(p))} r={4} fill="var(--go)" fillOpacity={0.25 + (i / path.length) * 0.5} />
              </g>
            ) : null,
          )}
          {/* Ball */}
          <motion.g animate={{ x: bx, y: by }} initial={false} transition={{ type: "spring", stiffness: 140, damping: 16 }}>
            <circle r={18} fill="var(--go)" fillOpacity={0.18} />
            <circle r={11} fill="var(--go)" stroke="white" strokeWidth={3} style={{ filter: "drop-shadow(0 3px 0 var(--go-edge))" }} />
          </motion.g>
        </svg>

        <AnimatePresence>
          {outcome !== "running" && (
            <motion.div
              key={outcome}
              initial={{ opacity: 0, y: 12, scale: 0.96 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 8 }}
              className={cn(
                "absolute inset-x-6 bottom-6 rounded-2xl border-2 px-4 py-3 text-[13.5px] backdrop-blur",
                outcome === "global" && "border-go bg-surface/90 text-foreground shadow-[0_4px_0_0_var(--go-edge)]",
                outcome === "local" && "border-[oklch(0.78_0.15_70)] bg-surface/90 text-foreground shadow-[0_4px_0_0_oklch(0.65_0.15_60)]",
                outcome === "diverged" && "border-danger/60 bg-surface/90 text-foreground shadow-[0_4px_0_0_var(--danger)]",
              )}
            >
              <span className="font-bold">
                {outcome === "global" ? "Found the global minimum." : outcome === "local" ? "Stuck in a local minimum." : "Diverged!"}
              </span>{" "}
              {outcome === "global"
                ? `Converged in ${path.length - 1} steps.`
                : outcome === "local"
                  ? "Try a bigger learning rate, or drop the ball further left."
                  : "The learning rate is too high, so each step overshoots. Turn it down."}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
