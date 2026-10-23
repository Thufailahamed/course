"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import { Braces, ListRestart, Play, Square, Variable } from "lucide-react";
import { CHALLENGE_KINDS, parseLesson, type CellLanguage, type ExerciseState, type LessonCell } from "@latent/shared";
import { Markdown } from "@/components/markdown";
import { Button } from "@/components/ui/button";
import { Spinner } from "@/components/ui/spinner";
import { Dialog, SheetContent, Tooltip } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";
import { ValueChip } from "./cell-output";
import { CodeCell } from "./code-cell";
import { InteractiveContext, type InteractiveContextValue } from "./interactive-context";
import { PredictCell } from "./predict-cell";
import { LANGUAGE_NAME } from "./code-editor";
import { getRuntime, useRuntimeState } from "./runtime";

export interface InteractiveLessonProps {
  scope: string;
  content: string;
  exercises: Record<string, ExerciseState> | null;
  submit: (cellId: string, code: string, passed: boolean) => Promise<void>;
  getSolution: (cell: LessonCell) => Promise<string>;
  explain?: (prompt: string) => void;
  /** Rendered after the lesson body with the learner's challenge progress. */
  footer?: (p: { solved: number; total: number }) => React.ReactNode;
  /** Offset for the sticky kernel bar. */
  stickyTop?: string;
}

export function InteractiveLesson({ scope, content, exercises, submit, getSolution, explain, footer, stickyTop = "top-0" }: InteractiveLessonProps) {
  const blocks = useMemo(() => parseLesson(content), [content]);
  const cells = useMemo(() => blocks.flatMap((b) => (b.type === "cell" ? [b.cell] : [])), [blocks]);
  const setup = useMemo(() => cells.filter((c) => c.kind === "setup").map((c) => c.code), [cells]);
  const challenges = useMemo(() => cells.filter((c) => CHALLENGE_KINDS.includes(c.kind)), [cells]);
  const language: CellLanguage = useMemo(() => cells.find((c) => c.kind !== "setup")?.language ?? "python", [cells]);

  const [passed, setPassed] = useState<Set<string>>(() => new Set(Object.entries(exercises ?? {}).flatMap(([id, s]) => (s.passed ? [id] : []))));
  useEffect(() => {
    setPassed((p) => new Set([...p, ...Object.entries(exercises ?? {}).flatMap(([id, s]) => (s.passed ? [id] : []))]));
  }, [exercises]);

  // Boot the lesson's runtime and give it this lesson's namespace.
  useEffect(() => {
    void getRuntime(language).attach(scope, setup);
  }, [scope, setup, language]);

  const runners = useRef(new Map<string, () => Promise<boolean>>());
  const register = useCallback((cellId: string, run: () => Promise<boolean>) => {
    runners.current.set(cellId, run);
    return () => void runners.current.delete(cellId);
  }, []);

  const ctx = useMemo<InteractiveContextValue>(
    () => ({
      scope,
      language,
      exercises: exercises ?? {},
      submit: async (cellId, code, ok) => {
        if (ok) setPassed((p) => new Set(p).add(cellId));
        await submit(cellId, code, ok);
      },
      getSolution,
      explain,
      register,
    }),
    [scope, language, exercises, submit, getSolution, explain, register],
  );

  const [runningAll, setRunningAll] = useState(false);
  const runAll = async () => {
    setRunningAll(true);
    try {
      for (const cell of cells) {
        const run = runners.current.get(cell.id);
        if (!run) continue;
        document.querySelector(`[data-cell="${CSS.escape(cell.id)}"]`)?.scrollIntoView({ block: "nearest", behavior: "smooth" });
        if (!(await run())) {
          toast.error("Stopped at a cell that raised an error");
          break;
        }
      }
    } finally {
      setRunningAll(false);
    }
  };

  const solved = challenges.filter((c) => passed.has(c.id)).length;

  return (
    <InteractiveContext.Provider value={ctx}>
      <KernelBar language={language} solved={solved} total={challenges.length} onRunAll={runAll} runningAll={runningAll} stickyTop={stickyTop} />
      <div className="pb-6 pt-4">
        {blocks.map((b, i) =>
          b.type === "markdown" ? (
            <Markdown
              key={i}
              size="lg"
              className="prose-editorial prose-pre:my-5 prose-blockquote:rounded-r-xl prose-blockquote:border-l-2 prose-blockquote:border-accent prose-blockquote:bg-accent-soft/50 prose-blockquote:px-5 prose-blockquote:py-1 prose-blockquote:font-normal prose-blockquote:text-[0.95em]"
            >
              {b.text}
            </Markdown>
          ) : b.cell.kind === "predict" ? (
            <PredictCell key={b.cell.id} cell={b.cell} />
          ) : (
            <CodeCell key={b.cell.id} cell={b.cell} />
          ),
        )}
      </div>
      {footer?.({ solved, total: challenges.length })}
    </InteractiveContext.Provider>
  );
}

function KernelBar({ language, solved, total, onRunAll, runningAll, stickyTop }: { language: CellLanguage; solved: number; total: number; onRunAll: () => void; runningAll: boolean; stickyTop: string }) {
  const rt = useRuntimeState(language);
  const [varsOpen, setVarsOpen] = useState(false);
  const isJava = language === "java";
  const isHtml = language === "html";
  const isStatic = isJava || isHtml;
  const busy = !!rt.running && rt.running !== "__complete__";
  const dot = rt.phase === "ready" ? (busy ? "bg-warning" : "bg-success") : rt.phase === "error" ? "bg-danger" : "bg-subtle-foreground";

  return (
    <>
      <div className={cn("sticky z-20 -mx-2 bg-gradient-to-b from-background via-background/85 to-transparent pb-3 pt-3 sm:-mx-3", stickyTop)}>
        <div className="flex h-[54px] items-center justify-between gap-3 rounded-[18px] border-2 border-line-3d bg-surface/90 pl-4 pr-2 shadow-[0_3px_0_0_var(--line-3d)] backdrop-blur-xl backdrop-saturate-150">
          <div className="flex min-w-0 items-center gap-3">
            <span className="relative flex size-2 shrink-0">
              {(rt.phase === "loading" || busy) && <span className={cn("absolute inline-flex size-full animate-ping rounded-full opacity-75", dot)} />}
              <span className={cn("relative inline-flex size-2 rounded-full", dot)} />
            </span>
            <div className="min-w-0 truncate text-[13px]">
              {rt.phase === "ready" ? (
                <>
                  <span className="font-medium text-foreground">{busy ? "Running…" : LANGUAGE_NAME[language]}</span>
                  {!busy && <span className="text-subtle-foreground"> ready</span>}
                </>
              ) : rt.phase === "error" ? (
                <span className="font-medium text-danger" title={rt.message}>
                  {LANGUAGE_NAME[language]} failed to load
                </span>
              ) : (
                <span className="font-medium text-foreground">{rt.phase === "idle" ? `Starting ${LANGUAGE_NAME[language]}` : rt.message || `Starting ${LANGUAGE_NAME[language]}`}…</span>
              )}
            </div>
            {rt.phase === "ready" && rt.versions && (
              <Tooltip content="Runs privately in an isolated web worker in your browser">
                <span className="hidden h-6 items-center rounded-full bg-surface-2 px-2.5 font-mono text-[11px] text-muted-foreground md:inline-flex">{rt.versions.runtime}</span>
              </Tooltip>
            )}
          </div>

          <div className="ml-auto flex shrink-0 items-center gap-1">
            {total > 0 && (
              <Tooltip content={`${solved} of ${total} challenges solved`}>
                <div className="mr-1.5 flex items-center gap-2.5 text-[12.5px]">
                  <span className="hidden items-center gap-1 sm:flex" aria-hidden>
                    {Array.from({ length: total }).map((_, i) => (
                      <span key={i} className={cn("h-2.5 w-5 rounded-full transition-colors duration-500", i < solved ? "bg-go" : "bg-surface-3")} />
                    ))}
                  </span>
                  <span className="tabular-nums text-muted-foreground">
                    <span className="font-semibold text-foreground">{solved}</span>/{total}
                    <span className="hidden sm:inline"> solved</span>
                  </span>
                </div>
              </Tooltip>
            )}
            {busy && !isStatic && (
              <Tooltip content="Stop the running code">
                <Button size="xs" variant="danger-soft" onClick={() => void getRuntime(language).stop()} className="h-9 rounded-full px-3.5">
                  <Square className="fill-current" /> Stop
                </Button>
              </Tooltip>
            )}
            {!isStatic && (
              <>
                <Tooltip content="Restart the kernel and clear all variables">
                  <Button
                    size="icon-sm"
                    variant="ghost"
                    disabled={rt.phase !== "ready"}
                    onClick={async () => {
                      await getRuntime(language).restart();
                      toast.success("Kernel restarted", { description: "All variables were cleared." });
                    }}
                    className="size-9 rounded-full text-muted-foreground hover:text-foreground"
                    aria-label="Restart kernel"
                  >
                    <ListRestart className="size-4" />
                  </Button>
                </Tooltip>
                <Tooltip content="Kernel variables">
                  <Button size="xs" variant="ghost" onClick={() => setVarsOpen(true)} className="h-9 rounded-full px-3 text-muted-foreground hover:text-foreground">
                    <Variable className="size-3.5" />
                    <span className="font-mono text-[11px] tabular-nums">{rt.vars.length}</span>
                  </Button>
                </Tooltip>
              </>
            )}
            <Tooltip content="Run every example cell from the top">
              <button type="button" onClick={onRunAll} disabled={runningAll || rt.phase === "error"} className="btn-3d btn-3d-sm btn-3d-blue ml-1 h-9 -translate-y-px">
                {runningAll ? <Spinner className="size-3.5" /> : <Play className="size-3 fill-current" />} Run all
              </button>
            </Tooltip>
          </div>
        </div>
      </div>

      <Dialog open={varsOpen} onOpenChange={setVarsOpen}>
        <SheetContent side="right" title="Kernel variables" className="w-[min(460px,94vw)]">
          <div className="flex-1 overflow-y-auto">
            {rt.vars.length === 0 ? (
              <div className="flex flex-col items-center px-8 py-16 text-center">
                <Braces className="size-8 text-subtle-foreground" />
                <p className="mt-3 text-sm font-medium">No variables yet</p>
                <p className="mt-1 text-[13px] text-muted-foreground">Run a cell and the variables it creates will show up here.</p>
              </div>
            ) : (
              <ul className="divide-y divide-border">
                {rt.vars.map((v) => (
                  <li key={v.name} className="px-5 py-3">
                    <div className="flex items-baseline justify-between gap-3">
                      <span className="font-mono text-[13px] font-semibold">{v.name}</span>
                      <ValueChip value={v} />
                    </div>
                    <pre className="mt-1.5 max-h-40 overflow-auto whitespace-pre-wrap break-all rounded-md bg-surface-2 px-2.5 py-2 font-mono text-[12px] leading-relaxed text-foreground/85">{v.repr}</pre>
                  </li>
                ))}
              </ul>
            )}
          </div>
          <p className="shrink-0 border-t border-border px-5 py-3 text-xs text-subtle-foreground">Example cells share this namespace, like a notebook. Challenges run in a fresh namespace so they can be checked fairly.</p>
        </SheetContent>
      </Dialog>
    </>
  );
}
