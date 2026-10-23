"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { ChevronLeft, ChevronRight, ChevronsLeft, FastForward, Layers, SquareTerminal, X } from "lucide-react";
import { Tooltip } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";
import { ErrorCard, ValueChip } from "./cell-output";
import type { PyError, TraceStep } from "./runtime";

export interface DebugSession {
  steps: TraceStep[];
  output: string;
  index: number;
  truncated: boolean;
  error: PyError | null;
}

/** Next step index paused on a breakpoint (or the last step). */
export function nextBreakpoint(steps: TraceStep[], from: number, breakpoints: number[]) {
  const set = new Set(breakpoints);
  for (let i = from + 1; i < steps.length; i++) if (steps[i]!.event === "line" && steps[i]!.line && set.has(steps[i]!.line!)) return i;
  return steps.length - 1;
}

function describeStep(step: TraceStep) {
  const where = step.func === "<module>" ? "" : ` in ${step.func}()`;
  switch (step.event) {
    case "line":
      return `About to run line ${step.line}${where}`;
    case "return":
      return `Returning from ${step.func === "<module>" ? "the cell" : `${step.func}()`}`;
    case "exception":
      return `Exception on line ${step.line}${where}`;
    case "end":
      return "Finished: final state";
  }
}

export function DebuggerPanel({ session, onIndex, breakpoints, onExit }: { session: DebugSession; onIndex: (i: number) => void; breakpoints: number[]; onExit: () => void }) {
  const { steps, index, output } = session;
  const step = steps[index]!;
  const prev = index > 0 ? steps[index - 1] : null;
  const total = steps.length;
  const ref = useRef<HTMLDivElement>(null);
  const [showBackground, setShowBackground] = useState(false);

  // Variables that existed before this run and never change during it (e.g. from earlier cells) are tucked away.
  const background = useMemo(() => {
    const first = steps[0]?.vars ?? {};
    return new Set(Object.keys(first).filter((name) => steps.every((st) => !st.vars[name] || (st.vars[name]!.repr === first[name]!.repr && st.vars[name]!.type === first[name]!.type))));
  }, [steps]);

  useEffect(() => {
    ref.current?.focus({ preventScroll: true });
  }, []);

  const go = (i: number) => onIndex(Math.max(0, Math.min(total - 1, i)));
  const onKey = (e: React.KeyboardEvent) => {
    if (e.target instanceof HTMLInputElement && e.target.type === "range") return;
    if (e.key === "ArrowRight" || e.key === "F10") (e.preventDefault(), go(index + 1));
    else if (e.key === "ArrowLeft") (e.preventDefault(), go(index - 1));
    else if (e.key === "F8") (e.preventDefault(), go(nextBreakpoint(steps, index, breakpoints)));
    else if (e.key === "Home") (e.preventDefault(), go(0));
    else if (e.key === "End") (e.preventDefault(), go(total - 1));
    else if (e.key === "Escape") (e.preventDefault(), onExit());
  };

  // Variables, with change markers relative to the previous step in the same frame.
  const rows = useMemo(() => {
    const sameFrame = prev && prev.func === step.func && prev.stack.length === step.stack.length;
    return Object.entries(step.vars).filter(([name]) => showBackground || !background.has(name)).map(([name, v]) => {
      const before = sameFrame ? prev!.vars[name] : undefined;
      const status: "new" | "changed" | "same" = !sameFrame ? "same" : !before ? "new" : before.repr !== v.repr || before.type !== v.type ? "changed" : "same";
      return { name, v, status };
    });
  }, [step, prev, showBackground, background]);
  const hidden = Object.keys(step.vars).filter((n) => background.has(n)).length;

  const shown = output.slice(0, step.out);
  const stack = step.stack.length ? step.stack : [{ func: "<module>", line: step.line ?? 0 }];

  return (
    <div ref={ref} tabIndex={-1} onKeyDown={onKey} className="border-t border-accent/25 bg-[oklch(0.54_0.2_259/0.035)] outline-none" aria-label="Debugger">
      {/* Controls */}
      <div className="flex flex-wrap items-center gap-x-3 gap-y-2 border-b border-border px-3 py-2">
        <span className="inline-flex items-center gap-1.5 rounded-md bg-accent px-2 py-0.5 text-[11px] font-semibold uppercase tracking-wide text-white">Debugging</span>
        <div className="flex items-center gap-0.5">
          <DbgButton label="Restart (Home)" onClick={() => go(0)} disabled={index === 0}>
            <ChevronsLeft />
          </DbgButton>
          <DbgButton label="Step back (←)" onClick={() => go(index - 1)} disabled={index === 0}>
            <ChevronLeft />
          </DbgButton>
          <DbgButton label="Step (→ or F10)" onClick={() => go(index + 1)} disabled={index >= total - 1} primary>
            <ChevronRight />
          </DbgButton>
          <DbgButton label={breakpoints.length ? "Continue to next breakpoint (F8)" : "Run to end (F8)"} onClick={() => go(nextBreakpoint(steps, index, breakpoints))} disabled={index >= total - 1}>
            <FastForward />
          </DbgButton>
        </div>
        <div className="min-w-0 flex-1 text-[12.5px] font-medium text-foreground">
          <span className="tabular-nums text-subtle-foreground">
            {index + 1}/{total}
          </span>
          <span className="mx-2 text-border-strong">·</span>
          {describeStep(step)}
        </div>
        <button onClick={onExit} className="inline-flex h-7 items-center gap-1 rounded-md px-2 text-xs font-medium text-muted-foreground transition hover:bg-surface hover:text-foreground">
          <X className="size-3.5" /> Exit <span className="kbd ml-1 hidden sm:inline-flex">Esc</span>
        </button>
      </div>
      <div className="px-3 pt-2">
        <input
          type="range"
          min={0}
          max={total - 1}
          value={index}
          onChange={(e) => go(Number(e.target.value))}
          className="h-1.5 w-full cursor-pointer accent-[var(--accent)]"
          aria-label="Execution timeline"
        />
        <TimelineMarks steps={steps} breakpoints={breakpoints} />
      </div>

      <div className="grid gap-px bg-border md:grid-cols-[1.4fr_1fr]">
        {/* Variables */}
        <div className="min-w-0 bg-surface">
          <div className="flex items-center justify-between px-3.5 pb-1.5 pt-3 text-[11px] font-semibold uppercase tracking-wide text-subtle-foreground">
            <span>Variables{step.func !== "<module>" ? ` · ${step.func}()` : ""}</span>
            {hidden > 0 && (
              <button onClick={() => setShowBackground((v) => !v)} className="font-medium normal-case tracking-normal text-accent hover:underline">
                {showBackground ? "Hide" : "Show"} {hidden} unchanged from earlier
              </button>
            )}
          </div>
          <div className="max-h-64 overflow-auto pb-2">
            {rows.length === 0 ? (
              <p className="px-3.5 py-2 text-[12.5px] text-subtle-foreground">{hidden ? "No variables created by this cell yet." : "No variables yet."}</p>
            ) : (
              <table className="w-full text-left font-mono text-[12px]">
                <tbody>
                  {rows.map(({ name, v, status }) => (
                    <tr key={name} className={cn("align-top transition-colors", status === "changed" && "bg-warning-soft", status === "new" && "bg-success-soft")}>
                      <td className="w-px whitespace-nowrap py-1 pl-3.5 pr-3 font-semibold text-foreground">
                        {name}
                        {status !== "same" && <span className={cn("ml-1.5 align-middle font-sans text-[9.5px] font-semibold uppercase", status === "new" ? "text-success" : "text-warning")}>{status}</span>}
                      </td>
                      <td className="py-1 pr-3.5">
                        {(v.kind === "ndarray" || v.kind === "collection") && <ValueChip value={v} className="mb-0.5 block" />}
                        <pre className="max-h-28 overflow-auto whitespace-pre-wrap break-all text-foreground/85">{v.repr}</pre>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
            {step.event === "return" && step.value && (
              <div className="mx-3.5 mt-2 rounded-md border border-accent/20 bg-accent-soft px-2.5 py-1.5 font-mono text-[12px]">
                <span className="font-sans text-[11px] font-semibold text-accent">Return value</span>
                <pre className="whitespace-pre-wrap break-all">{step.value.repr}</pre>
              </div>
            )}
            {step.event === "exception" && step.exc && <p className="mx-3.5 mt-2 rounded-md bg-danger-soft px-2.5 py-1.5 font-mono text-[12px] text-danger">{step.exc}</p>}
          </div>
        </div>

        {/* Stack + output */}
        <div className="flex min-w-0 flex-col gap-px bg-border">
          <div className="bg-surface px-3.5 pb-2.5 pt-3">
            <div className="mb-1.5 flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-subtle-foreground">
              <Layers className="size-3" /> Call stack
            </div>
            <ol className="space-y-0.5 font-mono text-[12px]">
              {stack
                .slice()
                .reverse()
                .map((f, i) => (
                  <li key={i} className={cn("flex justify-between gap-2 rounded px-1.5 py-0.5", i === 0 ? "bg-accent-soft text-foreground" : "text-muted-foreground")}>
                    <span>{f.func === "<module>" ? "cell" : `${f.func}()`}</span>
                    <span className="text-subtle-foreground">line {f.line}</span>
                  </li>
                ))}
            </ol>
          </div>
          <div className="flex-1 bg-surface px-3.5 pb-3 pt-3">
            <div className="mb-1.5 flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-subtle-foreground">
              <SquareTerminal className="size-3" /> Output so far
            </div>
            <pre className="max-h-32 overflow-auto whitespace-pre-wrap break-words font-mono text-[12px] text-foreground/85">{shown || <span className="text-subtle-foreground">—</span>}</pre>
          </div>
        </div>
      </div>
      {session.truncated && <p className="border-t border-border bg-warning-soft px-3.5 py-2 text-xs text-warning">Stopped recording after {total - 1} steps. Use smaller inputs to trace the whole run.</p>}
      {session.error && index === total - 1 && (
        <div className="border-t border-border bg-surface p-3">
          <ErrorCard error={session.error} compact />
        </div>
      )}
    </div>
  );
}

function TimelineMarks({ steps, breakpoints }: { steps: TraceStep[]; breakpoints: number[] }) {
  const set = new Set(breakpoints);
  const marks = steps.map((s, i) => ({ i, bp: s.event === "line" && s.line != null && set.has(s.line), exc: s.event === "exception" })).filter((m) => m.bp || m.exc);
  if (!marks.length || steps.length < 2) return <div className="h-2" />;
  return (
    <div className="relative mx-[7px] h-2">
      {marks.slice(0, 200).map((m) => (
        <span key={m.i} className={cn("absolute top-0.5 size-1 -translate-x-1/2 rounded-full", m.exc ? "bg-danger" : "bg-danger/60")} style={{ left: `${(m.i / (steps.length - 1)) * 100}%` }} />
      ))}
    </div>
  );
}

function DbgButton({ label, onClick, disabled, primary, children }: { label: string; onClick: () => void; disabled?: boolean; primary?: boolean; children: React.ReactNode }) {
  return (
    <Tooltip content={label}>
      <button
        onClick={onClick}
        disabled={disabled}
        aria-label={label}
        className={cn(
          "inline-flex size-7 items-center justify-center rounded-md transition disabled:opacity-35 [&_svg]:size-4",
          primary ? "bg-accent text-white hover:brightness-110" : "text-muted-foreground hover:bg-surface hover:text-foreground",
        )}
      >
        {children}
      </button>
    </Tooltip>
  );
}
