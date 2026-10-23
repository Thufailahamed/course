"use client";

import { useState } from "react";
import { motion } from "motion/react";
import { Check, HelpCircle, RotateCcw, X } from "lucide-react";
import type { LessonCell } from "@latent/shared";
import { Markdown } from "@/components/markdown";
import { cn } from "@/lib/utils";
import { CellOutput, type CellRun } from "./cell-output";
import { CodeEditor } from "./code-editor";
import { useInteractive } from "./interactive-context";
import { getRuntime } from "./runtime";

const LETTERS = "ABCDEFGH";

/** "What does this print?": pick an answer, then the code runs to reveal the truth. */
export function PredictCell({ cell }: { cell: LessonCell }) {
  const ctx = useInteractive();
  const storageKey = `latent-predict:${ctx.scope}:${cell.id}`;
  const [choice, setChoice] = useState<number | null>(() => {
    try {
      const v = typeof window !== "undefined" ? localStorage.getItem(storageKey) : null;
      return v === null ? null : Number(v);
    } catch {
      return null;
    }
  });
  const [run, setRun] = useState<CellRun | null>(null);
  const revealed = choice !== null;
  const correctIndex = cell.options.findIndex((o) => o.correct);
  const right = revealed && choice === correctIndex;

  const execute = async () => {
    setRun({ status: "queued", mode: "run", chunks: [], result: null });
    const result = await getRuntime(ctx.language).run(cell.id, cell.code, { fresh: true, body: cell.body });
    setRun({ status: "done", mode: "run", chunks: [], result });
  };

  const pick = (i: number) => {
    if (revealed) return;
    setChoice(i);
    try {
      localStorage.setItem(storageKey, String(i));
    } catch {}
    void execute();
  };

  const retry = () => {
    setChoice(null);
    setRun(null);
    try {
      localStorage.removeItem(storageKey);
    } catch {}
  };

  return (
    <div className={cn("not-prose my-10 overflow-hidden rounded-[22px] border-2 bg-surface", revealed ? (right ? "border-go shadow-[0_4px_0_0_var(--go-edge)]" : "border-[oklch(0.78_0.15_70)] shadow-[0_4px_0_0_oklch(0.65_0.15_60)]") : "border-line-3d shadow-[0_4px_0_0_var(--line-3d)]")}>
      <div className="flex items-start gap-4 px-5 pb-4 pt-5">
        <span className="flex size-11 shrink-0 items-center justify-center rounded-[14px] bg-[oklch(0.6_0.2_300)] text-white shadow-[0_3px_0_0_oklch(0.47_0.19_300)]">
          <HelpCircle className="size-5" strokeWidth={2.25} />
        </span>
        <div className="min-w-0 flex-1">
          <span className="text-[12px] font-bold uppercase tracking-[0.08em] text-[oklch(0.55_0.2_300)]">Predict the output</span>
          <h4 className="mt-0.5 text-[18px] font-bold leading-snug tracking-[-0.025em]">{cell.title ?? "What will this code produce?"}</h4>
        </div>
        {revealed && (
          <button onClick={retry} className="inline-flex h-7 shrink-0 items-center gap-1.5 rounded-md px-2 text-xs font-medium text-muted-foreground transition hover:bg-surface-3 hover:text-foreground">
            <RotateCcw className="size-3.5" /> Try again
          </button>
        )}
      </div>
      <div className="mx-2.5 overflow-hidden rounded-2xl">
        <CodeEditor value={cell.code} language={ctx.language} readOnly kernelCompletion={false} ariaLabel="Code to predict" />
      </div>
      <div className="grid gap-3 p-4 pb-5 sm:grid-cols-2" role="radiogroup" aria-label="Answer options">
        {cell.options.map((o, i) => {
          const isChoice = choice === i;
          const state = !revealed ? "idle" : o.correct ? "correct" : isChoice ? "wrong" : "dim";
          return (
            <button
              key={i}
              role="radio"
              aria-checked={isChoice}
              onClick={() => pick(i)}
              disabled={revealed}
              className={cn(
                "group flex items-center gap-3 rounded-2xl border-2 px-4 py-3.5 text-left transition-all duration-100 enabled:active:translate-y-[3px] enabled:active:shadow-none",
                state === "idle" && "border-line-3d bg-surface shadow-[0_3px_0_0_var(--line-3d)] hover:border-accent/60 hover:bg-accent-soft/40 hover:shadow-[0_3px_0_0_var(--accent)]",
                state === "correct" && "border-go bg-go-soft shadow-[0_3px_0_0_var(--go-edge)]",
                state === "wrong" && "border-danger/60 bg-danger-soft shadow-[0_3px_0_0_var(--danger)]",
                state === "dim" && "border-border bg-surface opacity-55",
              )}
            >
              <span
                className={cn(
                  "flex size-7 shrink-0 items-center justify-center rounded-lg border-2 text-[12px] font-bold",
                  state === "correct" ? "border-go bg-go text-white" : state === "wrong" ? "border-danger bg-danger text-white" : "border-border-strong text-subtle-foreground group-hover:border-accent group-hover:text-accent",
                )}
              >
                {state === "correct" ? <Check className="size-3" strokeWidth={3} /> : state === "wrong" ? <X className="size-3" strokeWidth={3} /> : LETTERS[i]}
              </span>
              <pre className="min-w-0 flex-1 whitespace-pre-wrap break-words font-mono text-[13.5px] font-medium leading-relaxed">{o.text}</pre>
            </button>
          );
        })}
      </div>
      {revealed && (
        <motion.div initial={{ opacity: 0, y: -4 }} animate={{ opacity: 1, y: 0 }} className="border-t border-border">
          <div className={cn("px-5 py-4", right ? "bg-go-soft" : "bg-warning-soft/60")}>
            <p className={cn("text-[18px] font-bold tracking-[-0.02em]", right ? "text-go-edge" : "text-foreground")}>{right ? "Correct!" : `Not quite. The answer is ${LETTERS[correctIndex]}.`}</p>
            {cell.explain && (
              <Markdown size="sm" className="mt-1 prose-p:my-1">
                {cell.explain}
              </Markdown>
            )}
          </div>
          {run && (
            <div className="border-t border-border bg-[oklch(0.985_0.002_265)]">
              <div className="px-4 pt-2.5 text-[11px] font-semibold uppercase tracking-wide text-subtle-foreground">Actual output</div>
              <CellOutput run={run} />
            </div>
          )}
        </motion.div>
      )}
    </div>
  );
}
