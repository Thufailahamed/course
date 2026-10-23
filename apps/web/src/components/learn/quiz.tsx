"use client";

import { useEffect, useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { ArrowLeft, ArrowRight, CheckCircle2, ListChecks, RotateCcw, Sparkles, Trophy, XCircle } from "lucide-react";
import type { LessonContent, QuizResult } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { ProgressRing } from "@/components/ui/display";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { cn } from "@/lib/utils";
import { useLearn } from "./learn-context";
import type { ProgressResult } from "./types";

const LETTERS = "ABCDEFGH";

/** Renders `inline code` spans in quiz text. */
function Rich({ text }: { text: string }) {
  return (
    <>
      {text.split(/(`[^`]+`)/g).map((part, i) =>
        part.length > 2 && part.startsWith("`") && part.endsWith("`") ? (
          <code key={i} className="rounded border border-border bg-surface-2 px-1 py-px font-mono text-[0.88em] text-foreground">
            {part.slice(1, -1)}
          </code>
        ) : (
          part
        ),
      )}
    </>
  );
}

type QuizResponse = QuizResult & { progress: ProgressResult | null };

export function Quiz({ lesson, onNext, onPassed }: { lesson: LessonContent; onNext: (() => void) | null; onPassed: () => void }) {
  const { handleProgress, openTutor } = useLearn();
  const questions = lesson.quiz ?? [];
  const [phase, setPhase] = useState<"intro" | "answering" | "result">("intro");
  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [result, setResult] = useState<QuizResponse | null>(null);

  const submit = useMutation({
    mutationFn: () => api.post<QuizResponse>(`/learn/lessons/${lesson.id}/quiz`, { answers }),
    onSuccess: (r) => {
      setResult(r);
      setPhase("result");
      if (r.progress) handleProgress(lesson.id, r.progress);
      if (r.passed) onPassed();
      document.getElementById("lesson-main")?.scrollTo({ top: 0, behavior: "smooth" });
    },
    onError: toastError,
  });

  const q = questions[step];
  const answeredAll = questions.every((x) => answers[x.id] !== undefined);

  // Number keys pick an option while answering.
  useEffect(() => {
    if (phase !== "answering" || !q) return;
    const onKey = (e: KeyboardEvent) => {
      const tag = (e.target as HTMLElement)?.tagName;
      if (tag === "INPUT" || tag === "TEXTAREA") return;
      const n = Number(e.key);
      if (n >= 1 && n <= q.options.length) setAnswers((a) => ({ ...a, [q.id]: n - 1 }));
      if (e.key === "Enter" && answers[q.id] !== undefined) {
        if (step < questions.length - 1) setStep(step + 1);
        else if (answeredAll) submit.mutate();
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [phase, q, step, answers, answeredAll, questions.length, submit]);

  const restart = () => {
    setAnswers({});
    setStep(0);
    setResult(null);
    setPhase("answering");
  };

  if (!questions.length) {
    return <div className="card p-10 text-center text-sm text-muted-foreground">This quiz has no questions yet.</div>;
  }

  if (phase === "intro") {
    const best = lesson.bestQuizScore;
    return (
      <div className="card relative overflow-hidden p-8 sm:p-12">
        <div className="relative">
          <span className="flex size-12 items-center justify-center rounded-full border border-border bg-surface-2 text-muted-foreground">
            <ListChecks className="size-5" />
          </span>
          <p className="mt-6 text-sm font-medium text-accent">Knowledge check</p>
          <h2 className="mt-2 text-[1.6rem] leading-tight sm:text-[1.9rem]">{lesson.title}</h2>
          <div className="mt-6 flex flex-wrap gap-2 text-sm">
            <span className="rounded-md border border-border bg-surface px-2.5 py-1 text-muted-foreground">{questions.length} questions</span>
            <span className="rounded-md border border-border bg-surface px-2.5 py-1 text-muted-foreground">70% to pass</span>
            <span className="rounded-md border border-border bg-surface px-2.5 py-1 text-muted-foreground">Unlimited retakes</span>
            {best && (
              <span className={cn("rounded-md px-2.5 py-1 font-medium", best.score / best.total >= 0.7 ? "bg-success-soft text-success" : "bg-warning-soft text-warning")}>
                Best: {best.score}/{best.total}
              </span>
            )}
          </div>
          <div className="mt-8 flex flex-wrap gap-3">
            <Button size="lg" onClick={() => setPhase("answering")}>
              {best ? "Retake quiz" : "Start quiz"} <ArrowRight />
            </Button>
            {best && best.score / best.total >= 0.7 && onNext && (
              <Button size="lg" variant="secondary" onClick={onNext}>
                Skip to next lesson
              </Button>
            )}
          </div>
        </div>
      </div>
    );
  }

  if (phase === "result" && result) {
    const pct = Math.round((result.score / result.total) * 100);
    const byId = new Map(result.results.map((r) => [r.questionId, r]));
    return (
      <div className="space-y-5">
        <div className={cn("card relative overflow-hidden p-8 sm:p-10", result.passed ? "ring-1 ring-success/30" : "ring-1 ring-warning/30")}>
          <div className="flex flex-col items-start gap-6 sm:flex-row sm:items-center">
            <ProgressRing value={pct} size={96} stroke={7}>
              <span className="text-2xl font-semibold tabular-nums tracking-[-0.03em]">{pct}%</span>
            </ProgressRing>
            <div className="flex-1">
              <div className={cn("inline-flex items-center gap-1.5 text-sm font-semibold", result.passed ? "text-success" : "text-warning")}>
                {result.passed ? <Trophy className="size-4" /> : <RotateCcw className="size-4" />}
                {result.passed ? "Passed" : "Not quite there"}
              </div>
              <h2 className="mt-1.5 text-[1.5rem] leading-tight">
                You scored {result.score} of {result.total}
              </h2>
              <p className="mt-1 text-sm text-muted-foreground">
                {result.passed ? "Great work — this lesson is now marked complete." : "You need 70% to pass. Review the explanations below and try again."}
              </p>
            </div>
            <div className="flex flex-wrap gap-2">
              <Button variant="secondary" onClick={restart}>
                <RotateCcw /> Retake
              </Button>
              {result.passed && onNext && (
                <Button onClick={onNext}>
                  Continue <ArrowRight />
                </Button>
              )}
            </div>
          </div>
        </div>

        {questions.map((question, qi) => {
          const r = byId.get(question.id);
          const picked = answers[question.id];
          return (
            <div key={question.id} className="card p-6">
              <div className="flex items-start gap-3">
                {r?.correct ? <CheckCircle2 className="mt-0.5 size-5 shrink-0 text-success" /> : <XCircle className="mt-0.5 size-5 shrink-0 text-danger" />}
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-medium text-subtle-foreground">Question {qi + 1}</p>
                  <p className="mt-1 font-medium leading-relaxed"><Rich text={question.prompt} /></p>
                  <ul className="mt-4 space-y-2">
                    {question.options.map((opt, oi) => {
                      const isAnswer = r?.answerIndex === oi;
                      const isPicked = picked === oi;
                      return (
                        <li
                          key={oi}
                          className={cn(
                            "flex items-center gap-3 rounded-xl border px-3.5 py-2.5 text-sm",
                            isAnswer ? "border-success/40 bg-success-soft text-foreground" : isPicked ? "border-danger/40 bg-danger-soft" : "border-border text-muted-foreground",
                          )}
                        >
                          <span className="text-xs font-medium text-subtle-foreground">{LETTERS[oi]}</span>
                          <span className="flex-1"><Rich text={opt} /></span>
                          {isAnswer && <span className="text-xs font-medium text-success">Correct answer</span>}
                          {isPicked && !isAnswer && <span className="text-xs font-medium text-danger">Your answer</span>}
                        </li>
                      );
                    })}
                  </ul>
                  {r?.explanation && <p className="mt-4 rounded-xl bg-surface-2 px-4 py-3 text-sm leading-relaxed text-muted-foreground"><Rich text={r.explanation} /></p>}
                  {!r?.correct && (
                    <button
                      onClick={() => openTutor(`I got this quiz question wrong: "${question.prompt}". Help me understand the concept behind the correct answer.`)}
                      className="mt-3 inline-flex items-center gap-1.5 text-xs font-medium text-accent hover:underline"
                    >
                      <Sparkles className="size-3.5" /> Ask Atlas to explain
                    </button>
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>
    );
  }

  // Answering
  return (
    <div className="card p-6 sm:p-10">
      <div className="flex items-center justify-between gap-4">
        <span className="text-xs font-medium text-muted-foreground">
          Question {step + 1} of {questions.length}
        </span>
        <div className="flex gap-1.5" aria-hidden>
          {questions.map((x, i) => (
            <button
              key={x.id}
              onClick={() => setStep(i)}
              className={cn("h-1.5 rounded-full transition-all", i === step ? "w-6 bg-accent" : answers[x.id] !== undefined ? "w-3 bg-accent/50" : "w-3 bg-surface-3")}
              tabIndex={-1}
            />
          ))}
        </div>
      </div>
      {q && (
        <div key={q.id} className="animate-[fade-up_0.35s_ease-out]">
          <h2 className="mt-5 text-[1.3rem] leading-snug tracking-[-0.02em] sm:text-[1.5rem]"><Rich text={q.prompt} /></h2>
          <div className="mt-7 grid gap-2.5" role="radiogroup" aria-label={q.prompt}>
            {q.options.map((opt, oi) => {
              const selected = answers[q.id] === oi;
              return (
                <button
                  key={oi}
                  role="radio"
                  aria-checked={selected}
                  onClick={() => setAnswers((a) => ({ ...a, [q.id]: oi }))}
                  className={cn(
                    "group flex items-center gap-4 rounded-xl border bg-surface px-4 py-3.5 text-left text-[15px] transition-all",
                    selected ? "border-accent bg-accent-soft shadow-[0_0_0_1px_var(--accent)]" : "border-border shadow-card hover:border-border-strong",
                  )}
                >
                  <span
                    className={cn(
                      "flex size-8 shrink-0 items-center justify-center rounded-md border text-xs font-semibold transition-colors",
                      selected ? "border-accent bg-accent text-white" : "border-border-strong text-subtle-foreground group-hover:text-foreground",
                    )}
                  >
                    {LETTERS[oi]}
                  </span>
                  <span className="flex-1"><Rich text={opt} /></span>
                </button>
              );
            })}
          </div>
        </div>
      )}
      <div className="mt-8 flex items-center justify-between gap-3 border-t border-border pt-6">
        <Button variant="ghost" onClick={() => setStep((s) => Math.max(0, s - 1))} disabled={step === 0}>
          <ArrowLeft /> Back
        </Button>
        <span className="hidden text-xs text-subtle-foreground sm:block">
          Press <span className="kbd">1</span>–<span className="kbd">{q?.options.length ?? 4}</span> to choose, <span className="kbd">Enter</span> to continue
        </span>
        {step < questions.length - 1 ? (
          <Button onClick={() => setStep((s) => s + 1)} disabled={!q || answers[q.id] === undefined}>
            Next <ArrowRight />
          </Button>
        ) : (
          <Button onClick={() => submit.mutate()} disabled={!answeredAll} loading={submit.isPending}>
            Submit answers
          </Button>
        )}
      </div>
    </div>
  );
}
