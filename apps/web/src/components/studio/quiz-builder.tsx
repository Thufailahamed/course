"use client";

import { ArrowDown, ArrowUp, Check, ListChecks, Plus, Trash2, X } from "lucide-react";
import type { QuizQuestion } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Input, Textarea } from "@/components/ui/input";
import { EmptyState } from "@/components/ui/display";
import { Tooltip } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";

const newQuestion = (): QuizQuestion => ({
  id: `q${Math.random().toString(36).slice(2, 9)}`,
  prompt: "",
  options: ["", ""],
  answerIndex: 0,
  explanation: "",
});

export function quizProblems(quiz: QuizQuestion[]) {
  const problems: string[] = [];
  quiz.forEach((q, i) => {
    if (!q.prompt.trim()) problems.push(`Question ${i + 1} needs a prompt`);
    if (q.options.filter((o) => o.trim()).length < 2) problems.push(`Question ${i + 1} needs at least 2 options`);
    if (q.options.some((o) => !o.trim())) problems.push(`Question ${i + 1} has an empty option`);
  });
  return problems;
}

export function QuizBuilder({ value, onChange }: { value: QuizQuestion[]; onChange: (q: QuizQuestion[]) => void }) {
  const update = (i: number, patch: Partial<QuizQuestion>) => onChange(value.map((q, j) => (j === i ? { ...q, ...patch } : q)));
  const move = (i: number, dir: -1 | 1) => {
    const j = i + dir;
    if (j < 0 || j >= value.length) return;
    const next = [...value];
    [next[i], next[j]] = [next[j]!, next[i]!];
    onChange(next);
  };

  return (
    <div className="space-y-4">
      {value.length === 0 && <EmptyState icon={<ListChecks />} title="No questions yet" description="Learners need 70% to pass. Add a few questions that check real understanding." />}
      {value.map((q, i) => (
        <div key={q.id} className="rounded-2xl border border-border bg-surface p-4 sm:p-5">
          <div className="mb-3 flex items-center gap-2">
            <span className="rounded-md border border-border bg-surface-2 px-2 py-0.5 text-[11px] font-medium tabular-nums text-muted-foreground">Q{i + 1}</span>
            <div className="ml-auto flex items-center gap-1">
              <Button variant="ghost" size="icon-sm" disabled={i === 0} onClick={() => move(i, -1)} aria-label="Move question up">
                <ArrowUp />
              </Button>
              <Button variant="ghost" size="icon-sm" disabled={i === value.length - 1} onClick={() => move(i, 1)} aria-label="Move question down">
                <ArrowDown />
              </Button>
              <Button variant="ghost" size="icon-sm" onClick={() => onChange(value.filter((_, j) => j !== i))} aria-label="Delete question" className="hover:bg-danger-soft hover:text-danger">
                <Trash2 />
              </Button>
            </div>
          </div>
          <Textarea value={q.prompt} onChange={(e) => update(i, { prompt: e.target.value })} placeholder="Question prompt" rows={2} className="min-h-0" />
          <div className="mt-3 space-y-2">
            {q.options.map((opt, oi) => {
              const correct = q.answerIndex === oi;
              return (
                <div key={oi} className="flex items-center gap-2">
                  <Tooltip content={correct ? "Correct answer" : "Mark as correct"}>
                    <button
                      type="button"
                      onClick={() => update(i, { answerIndex: oi })}
                      aria-pressed={correct}
                      aria-label={`Mark option ${oi + 1} as correct`}
                      className={cn(
                        "flex size-7 shrink-0 items-center justify-center rounded-full border transition-colors",
                        correct ? "border-success bg-success text-white" : "border-border-strong text-transparent hover:border-success hover:text-success",
                      )}
                    >
                      <Check className="size-3.5" strokeWidth={3} />
                    </button>
                  </Tooltip>
                  <Input
                    value={opt}
                    onChange={(e) => update(i, { options: q.options.map((o, k) => (k === oi ? e.target.value : o)) })}
                    placeholder={`Option ${oi + 1}`}
                    className={cn("h-10", correct && "border-success/50")}
                  />
                  <Button
                    variant="ghost"
                    size="icon-sm"
                    disabled={q.options.length <= 2}
                    onClick={() => {
                      const options = q.options.filter((_, k) => k !== oi);
                      const answerIndex = q.answerIndex === oi ? 0 : q.answerIndex > oi ? q.answerIndex - 1 : q.answerIndex;
                      update(i, { options, answerIndex });
                    }}
                    aria-label="Remove option"
                  >
                    <X />
                  </Button>
                </div>
              );
            })}
            {q.options.length < 8 && (
              <Button variant="ghost" size="xs" onClick={() => update(i, { options: [...q.options, ""] })} className="ml-9">
                <Plus /> Add option
              </Button>
            )}
          </div>
          <Input
            value={q.explanation ?? ""}
            onChange={(e) => update(i, { explanation: e.target.value })}
            placeholder="Explanation shown after answering (optional)"
            className="mt-3 h-10 text-[13px]"
          />
        </div>
      ))}
      <Button variant="secondary" onClick={() => onChange([...value, newQuestion()])}>
        <Plus /> Add question
      </Button>
    </div>
  );
}
