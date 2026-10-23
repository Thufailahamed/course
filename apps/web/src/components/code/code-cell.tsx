"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import { toast } from "sonner";
import { Bug, Check, CheckCircle2, ChevronDown, Copy, Eye, EyeOff, FlaskConical, Lightbulb, MoreHorizontal, Play, RotateCcw, Sparkles, Square, Target, XCircle } from "lucide-react";
import type { LessonCell } from "@latent/shared";
import { Markdown } from "@/components/markdown";
import { Button } from "@/components/ui/button";
import { Spinner } from "@/components/ui/spinner";
import { Badge, Dropdown, DropdownContent, DropdownItem, DropdownSeparator, DropdownTrigger, Tooltip } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";
import { CellOutput, formatMs, inlineCode, type CellRun } from "./cell-output";
import { CodeEditor, LANGUAGE_NAME } from "./code-editor";
import { DebuggerPanel, nextBreakpoint, type DebugSession } from "./debugger-panel";
import { clip, codePrompt, useDraft, useInteractive } from "./interactive-context";
import { getRuntime, useRuntimeState, type PyError, type RunResult } from "./runtime";

type CheckState = { passed: boolean; message: string | null; result: RunResult };

const darkBtn = "inline-flex h-8 items-center gap-1.5 rounded-lg px-3 text-[12.5px] font-medium transition-colors disabled:pointer-events-none disabled:opacity-50";

const KIND_META = {
  exercise: { label: "Challenge", icon: Target, tone: "text-accent", badge: "accent" as const },
  debug: { label: "Debug challenge", icon: Bug, tone: "text-warning", badge: "warning" as const },
};

export function CodeCell({ cell }: { cell: LessonCell }) {
  const ctx = useInteractive();
  const language = ctx.language;
  const isJava = language === "java";
  /** HTML re-renders instantly and has no process to stop. */
  const isStatic = isJava || language === "html";
  /** The step-through debugger records Python traces only. */
  const hasDebugger = language === "python";
  const rt = useRuntimeState(language);
  const challenge = cell.kind === "exercise" || cell.kind === "debug";
  const saved = ctx.exercises[cell.id];
  const [code, setCode] = useDraft(ctx.scope, cell.id, cell.code, saved?.code);
  const [run, setRun] = useState<CellRun | null>(null);
  const [check, setCheck] = useState<CheckState | null>(null);
  const [debug, setDebug] = useState<DebugSession | null>(null);
  const [breakpoints, setBreakpoints] = useState<number[]>([]);
  const [hints, setHints] = useState(0);
  const [solution, setSolution] = useState<{ open: boolean; code: string | null; loading: boolean }>({ open: false, code: null, loading: false });
  const [busy, setBusy] = useState<null | "run" | "check" | "trace">(null);
  const [solved, setSolved] = useState(!!saved?.passed);
  const [justSolved, setJustSolved] = useState(false);
  const [failedChecks, setFailedChecks] = useState(0);

  useEffect(() => setSolved(!!saved?.passed), [saved?.passed]);
  // A kernel restart invalidates outputs of cells that ran in it.
  const generation = useRef(rt.generation);
  useEffect(() => {
    if (rt.generation !== generation.current && !challenge) setRun(null);
    generation.current = rt.generation;
  }, [rt.generation, challenge]);

  const runtime = typeof window !== "undefined" ? getRuntime(language) : null;

  const doRun = useCallback(async (): Promise<boolean> => {
    if (!runtime) return false;
    setDebug(null);
    setCheck(null);
    setBusy("run");
    setRun({ status: "queued", mode: "run", chunks: [], result: null });
    const result = await runtime.run(cell.id, code, { fresh: challenge, body: cell.body }, (chunk) => setRun((r) => (r ? { ...r, status: "running", chunks: [...r.chunks, chunk] } : r)));
    setRun({ status: "done", mode: "run", chunks: [], result });
    setBusy(null);
    return result.ok || cell.expectError;
  }, [runtime, cell.id, cell.body, cell.expectError, code, challenge]);

  const { register } = ctx;
  const runRef = useRef(doRun);
  runRef.current = doRun;
  useEffect(() => (cell.kind === "run" ? register(cell.id, () => runRef.current()) : undefined), [cell.id, cell.kind, register]);

  const doDebug = async () => {
    if (!runtime || !hasDebugger) return;
    setCheck(null);
    setBusy("trace");
    setRun({ status: "queued", mode: "trace", chunks: [], result: null });
    const result = await runtime.run(cell.id, code, { fresh: challenge, trace: true }, (chunk) => setRun((r) => (r ? { ...r, status: "running", chunks: [...r.chunks, chunk] } : r)));
    setBusy(null);
    if (!result.steps || result.steps.length <= 1) {
      // Nothing to step through (e.g. a SyntaxError): show the normal output.
      setRun({ status: "done", mode: "run", chunks: [], result });
      if (result.ok) toast("Nothing to step through", { description: "This cell has no executable lines." });
      return;
    }
    setRun(null);
    const steps = result.steps;
    const firstBp = breakpoints.length ? nextBreakpoint(steps, -1, breakpoints) : 0;
    setDebug({ steps, output: result.output ?? "", index: firstBp === steps.length - 1 && breakpoints.length ? 0 : firstBp, truncated: !!result.truncatedSteps, error: result.error });
  };

  const doCheck = async () => {
    if (!runtime || !cell.test) return;
    setDebug(null);
    setBusy("check");
    setRun({ status: "queued", mode: "check", chunks: [], result: null });
    const result = await runtime.check(cell.id, code, cell.test, { body: cell.body }, (chunk) => setRun((r) => (r ? { ...r, status: "running", chunks: [...r.chunks, chunk] } : r)));
    setBusy(null);
    const passed = !!result.passed;
    setRun({ status: "done", mode: "check", chunks: [], result });
    setCheck({ passed, message: result.message ?? null, result });
    if (passed) {
      if (!solved) {
        setJustSolved(true);
        setTimeout(() => setJustSolved(false), 2400);
      }
      setSolved(true);
    } else setFailedChecks((n) => n + 1);
    void ctx.submit(cell.id, code, passed);
  };

  const explain = ctx.explain;
  const explainError = explain
    ? (e: PyError) =>
        explain(
          `I ran this code in the lesson and got an error. Explain what went wrong and how to fix it — don't just rewrite everything.\n\n${codePrompt(code, language)}\n\nError:\n\`\`\`\n${clip(e.traceback || `${e.ename}: ${e.evalue}`, 1200)}\n\`\`\``,
        )
    : undefined;

  const reset = () => {
    const previous = code;
    setCode(cell.code);
    setRun(null);
    setCheck(null);
    setDebug(null);
    toast("Code reset to the original", { action: { label: "Undo", onClick: () => setCode(previous) } });
  };

  const revealSolution = async () => {
    if (solution.code) return setSolution((s) => ({ ...s, open: !s.open }));
    setSolution({ open: true, code: null, loading: true });
    try {
      setSolution({ open: true, code: await ctx.getSolution(cell), loading: false });
    } catch {
      setSolution({ open: false, code: null, loading: false });
      toast.error("Couldn't load the solution");
    }
  };

  const toggleBreakpoint = (line: number) => setBreakpoints((b) => (b.includes(line) ? b.filter((x) => x !== line) : [...b, line].sort((a, z) => a - z)));
  const running = busy !== null;
  const isRunningNow = running && rt.running === cell.id;
  const errorLine = !debug && run?.status === "done" && run.result?.error?.file === "<cell>" ? run.result.error.line : null;
  const modified = code !== cell.code;
  const meta = challenge ? KIND_META[cell.kind as "exercise" | "debug"] : null;

  if (cell.kind === "setup") return <SetupCell cell={cell} />;

  return (
    <motion.div
      layout="position"
      className={cn(
        "not-prose group/cell relative my-10 overflow-hidden rounded-[22px] border-2 bg-surface transition-[border-color,box-shadow] duration-300",
        solved && challenge
          ? "border-go shadow-[0_4px_0_0_var(--go-edge)]"
          : debug
            ? "border-accent shadow-[0_4px_0_0_var(--accent-edge)]"
            : meta
              ? "border-line-3d shadow-[0_4px_0_0_var(--line-3d)]"
              : "border-[var(--code-bg)] shadow-[0_4px_0_0_oklch(0.12_0.006_270)]",
      )}
      data-cell={cell.id}
    >
      {/* Challenge header */}
      {meta && (
        <div className="flex items-start gap-4 px-5 pb-4 pt-5">
          <span
            className={cn(
              "flex size-11 shrink-0 items-center justify-center rounded-[14px] text-white",
              solved ? "bg-go shadow-[0_3px_0_0_var(--go-edge)]" : cell.kind === "debug" ? "bg-[oklch(0.75_0.16_65)] shadow-[0_3px_0_0_oklch(0.6_0.15_55)]" : "bg-accent shadow-[0_3px_0_0_var(--accent-edge)]",
            )}
          >
            {solved ? <Check className="size-5" strokeWidth={3} /> : <meta.icon className="size-5" strokeWidth={2.25} />}
          </span>
          <div className="min-w-0 flex-1">
            <div className="flex flex-wrap items-center gap-2">
              <span className={cn("text-[12px] font-bold uppercase tracking-[0.08em]", solved ? "text-go-edge" : meta.tone)}>{meta.label}</span>
              {solved && (
                <Badge variant="success" size="sm">
                  <CheckCircle2 /> Solved
                </Badge>
              )}
            </div>
            {cell.title && <h4 className="mt-0.5 text-[18px] font-bold leading-snug tracking-[-0.025em] text-foreground">{cell.title}</h4>}
            {cell.kind === "debug" && !solved && <p className="mt-1 text-[13.5px] leading-relaxed text-muted-foreground">This code has a bug. Run or debug it, find the problem, fix it, then check your fix.</p>}
          </div>
          <CellMenu onReset={reset} modified={modified} code={code} onSolution={cell.hasSolution ? revealSolution : undefined} solutionOpen={solution.open} />
        </div>
      )}

      <div className={cn("code-surface", meta && "mx-2.5 overflow-hidden rounded-2xl", meta && !debug && !hints && !check && !run && !solution.open && "mb-2.5")}>
        {/* Window chrome */}
        <div className="flex h-11 items-center gap-3 border-b border-[var(--code-border)] px-4">
          <div className="flex items-center gap-1.5" aria-hidden>
            <span className="size-2.5 rounded-full bg-[oklch(0.68_0.17_25)]/85" />
            <span className="size-2.5 rounded-full bg-[oklch(0.8_0.14_80)]/85" />
            <span className="size-2.5 rounded-full bg-[oklch(0.72_0.15_150)]/85" />
          </div>
          <span className="font-mono text-[12px] text-[var(--code-fg)]/90">Main.{language === "java" ? "java" : language === "python" ? "py" : language === "javascript" ? "js" : language === "html" ? "html" : "c"}</span>
          {modified && <span className="size-1.5 rounded-full bg-[var(--code-number)]" title="Edited" />}
          {cell.expectError && <span className="rounded-full bg-[oklch(0.8_0.14_80/0.14)] px-2 py-0.5 text-[10.5px] font-medium text-[var(--code-number)]">Raises an error on purpose</span>}

          <div className="ml-auto flex items-center gap-0.5">
            <span className="mr-1.5 font-mono text-[11px] tabular-nums text-[var(--code-faint)]">In [{run?.result?.count ?? " "}]</span>
            <Tooltip content="Copy code">
              <button
                type="button"
                onClick={() => void navigator.clipboard?.writeText(code).then(() => toast.success("Code copied"))}
                className="inline-flex size-7 items-center justify-center rounded-md text-[var(--code-muted)] transition hover:bg-white/8 hover:text-[var(--code-fg)]"
                aria-label="Copy code"
              >
                <Copy className="size-3.5" />
              </button>
            </Tooltip>
            {!meta && <CellMenu onReset={reset} modified={modified} code={code} dark />}
          </div>
        </div>

        {/* Editor */}
        <CodeEditor
          value={code}
          language={language}
          onChange={(v) => {
            setCode(v);
            if (debug) setDebug(null);
          }}
          onRun={() => !running && void doRun()}
          onCheck={challenge ? () => !running && void doCheck() : undefined}
          readOnly={!!debug}
          breakpoints={hasDebugger ? breakpoints : undefined}
          onToggleBreakpoint={hasDebugger ? toggleBreakpoint : undefined}
          activeLine={debug ? (debug.steps[debug.index]?.line ?? null) : null}
          errorLine={errorLine}
          ariaLabel={cell.title ?? `${LANGUAGE_NAME[language]} code`}
        />

        {/* Toolbar */}
        <div className="flex flex-wrap items-center gap-2 border-t border-[var(--code-border)] bg-[var(--code-bg-2)]/60 px-3 pb-3.5 pt-3">
          {isRunningNow && !isStatic ? (
            <button type="button" onClick={() => void getRuntime(language).stop()} className="btn-3d btn-3d-sm [--b3d-bg:oklch(0.62_0.21_25)] [--b3d-edge:oklch(0.48_0.19_25)] [--b3d-fg:#fff]">
              <Square className="size-3 fill-current" /> Stop
            </button>
          ) : (
            <button
              type="button"
              onClick={() => void doRun()}
              disabled={running}
              className={cn("btn-3d btn-3d-sm", challenge ? "btn-3d-ghost-dark" : "btn-3d-green")}
            >
              {busy === "run" && !isRunningNow ? <Spinner className="size-3.5" /> : <Play className="size-3 fill-current" />}
              <span>Run</span>
              <kbd className="hidden font-mono text-[10px] opacity-60 sm:inline">⇧↵</kbd>
            </button>
          )}
          {hasDebugger && (
            <Tooltip content="Step through line by line. Click the gutter to add breakpoints.">
              <button
                type="button"
                onClick={() => (debug ? setDebug(null) : void doDebug())}
                disabled={running && busy !== "trace"}
                aria-pressed={!!debug}
                className={cn(darkBtn, debug ? "bg-[oklch(0.7_0.12_255/0.22)] text-[oklch(0.85_0.08_255)]" : "text-[var(--code-muted)] hover:bg-white/8 hover:text-[var(--code-fg)]")}
              >
                {busy === "trace" ? <Spinner className="size-3.5" /> : <Bug className="size-3.5" />} {debug ? "Stop debugging" : "Debug"}
              </button>
            </Tooltip>
          )}
          {challenge && cell.hints.length > 0 && (
            <button
              type="button"
              onClick={() => setHints((h) => Math.min(cell.hints.length, h + 1))}
              disabled={hints >= cell.hints.length}
              className={cn(darkBtn, "text-[var(--code-muted)] hover:bg-white/8 hover:text-[var(--code-fg)]")}
            >
              <Lightbulb className="size-3.5 text-[var(--code-number)]" /> {hints === 0 ? "Hint" : hints < cell.hints.length ? "Next hint" : "No more hints"}
              {cell.hints.length > 1 && <span className="tabular-nums text-[var(--code-faint)]">{Math.min(hints, cell.hints.length)}/{cell.hints.length}</span>}
            </button>
          )}
          <div className="ml-auto flex items-center gap-2">
            {run?.status === "done" && run.result && (
              <span className="inline-flex items-center gap-1.5 font-mono text-[11px] tabular-nums text-[var(--code-faint)]">
                <span className={cn("size-1.5 rounded-full", run.result.ok ? "bg-[var(--code-string)]" : "bg-[oklch(0.68_0.2_25)]")} /> {formatMs(run.result.duration)}
              </span>
            )}
            {challenge && cell.test && (
              <button
                type="button"
                onClick={() => void doCheck()}
                disabled={running}
                className="btn-3d btn-3d-sm btn-3d-green px-4"
              >
                {busy === "check" ? <Spinner className="size-3.5" /> : <Check className="size-3.5" strokeWidth={2.5} />}
                <span>{solved ? "Check again" : "Check"}</span>
                <kbd className="hidden font-mono text-[10px] opacity-50 sm:inline">⌘⇧↵</kbd>
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Debugger */}
      {debug && <DebuggerPanel session={debug} onIndex={(index) => setDebug((d) => (d ? { ...d, index } : d))} breakpoints={breakpoints} onExit={() => setDebug(null)} />}

      {/* Hints */}
      <AnimatePresence initial={false}>
        {hints > 0 && (
          <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden border-t border-border">
            <ol className="space-y-2 bg-warning-soft/40 px-4 py-3">
              {cell.hints.slice(0, hints).map((h, i) => (
                <li key={i} className="flex gap-2.5 text-[13.5px]">
                  <span className="mt-0.5 flex size-5 shrink-0 items-center justify-center rounded-full bg-warning-soft text-[11px] font-semibold text-warning">{i + 1}</span>
                  <Markdown size="sm" className="min-w-0 flex-1 prose-p:my-0 prose-pre:my-2">
                    {h}
                  </Markdown>
                </li>
              ))}
              {explain && hints >= cell.hints.length && (
                <li>
                  <button
                    onClick={() => explain(`I'm stuck on the challenge "${cell.title ?? "this exercise"}". Here's my current code. Give me a nudge in the right direction without giving away the full answer.\n\n${codePrompt(code, language)}`)}
                    className="ml-7 inline-flex items-center gap-1.5 text-[13px] font-medium text-accent hover:underline"
                  >
                    <Sparkles className="size-3.5" /> Still stuck? Ask Atlas for a nudge
                  </button>
                </li>
              )}
            </ol>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Check result */}
      {check && <CheckBanner check={check} justSolved={justSolved} canReveal={cell.hasSolution && failedChecks >= 1 && !solution.open} onReveal={revealSolution} />}

      {/* Output */}
      {run && !debug && (run.mode !== "check" || !check || check.result.error || run.result?.stdout || run.result?.value || run.result?.previewHtml || run.result?.images.length) ? (
        <div className="bg-surface">
          <div className="flex items-center gap-2 px-5 pb-0.5 pt-3 text-[11px] font-medium uppercase tracking-[0.12em] text-subtle-foreground">
            <span>Output</span>
            <span className="h-px flex-1 bg-border" />
          </div>
          <CellOutput run={run} onExplain={explainError} onDebug={hasDebugger ? () => void doDebug() : undefined} />
        </div>
      ) : null}

      {/* Solution */}
      <AnimatePresence initial={false}>
        {solution.open && (
          <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden border-t border-border">
            <div className="bg-surface-2/50">
              <div className="flex items-center gap-2 px-4 pt-3 text-[12px] font-semibold text-muted-foreground">
                <Eye className="size-3.5" /> Reference solution
                <div className="ml-auto flex gap-1">
                  {solution.code && (
                    <Button
                      size="xs"
                      variant="secondary"
                      onClick={() => {
                        const previous = code;
                        setCode(solution.code!);
                        toast("Solution loaded into the editor", { action: { label: "Undo", onClick: () => setCode(previous) } });
                      }}
                    >
                      Use this code
                    </Button>
                  )}
                  <Button size="xs" variant="ghost" onClick={() => setSolution((s) => ({ ...s, open: false }))}>
                    <EyeOff /> Hide
                  </Button>
                </div>
              </div>
              {solution.loading ? <div className="skeleton m-4 h-16" /> : solution.code ? <CodeEditor value={solution.code} language={language} readOnly kernelCompletion={false} ariaLabel="Solution code" /> : null}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}

function CheckBanner({ check, justSolved, canReveal, onReveal }: { check: CheckState; justSolved: boolean; canReveal: boolean; onReveal: () => void }) {
  if (check.passed)
    return (
      <div className="relative flex items-center gap-4 overflow-hidden bg-go-soft px-5 py-4">
        <motion.span initial={justSolved ? { scale: 0.4, rotate: -20 } : false} animate={{ scale: 1, rotate: 0 }} transition={{ type: "spring", stiffness: 500, damping: 18 }} className="flex size-11 shrink-0 items-center justify-center rounded-full bg-go text-white shadow-[0_3px_0_0_var(--go-edge)]">
          <Check className="size-6" strokeWidth={3.25} />
        </motion.span>
        <div className="min-w-0">
          <p className="text-[18px] font-bold tracking-[-0.02em] text-go-edge">{justSolved ? "Nailed it!" : "Correct!"}</p>
          <p className="text-[13.5px] text-muted-foreground">All checks passed and your solution is saved. Keep experimenting if you like.</p>
        </div>
        {justSolved && <Sparkle />}
      </div>
    );
  return (
    <div className="flex items-start gap-4 bg-danger-soft px-5 py-4">
      <span className="flex size-11 shrink-0 items-center justify-center rounded-full bg-danger text-white shadow-[0_3px_0_0_oklch(0.45_0.18_27)]">
        <XCircle className="size-6" strokeWidth={2.5} />
      </span>
      <div className="min-w-0 flex-1 pt-0.5">
        <p className="text-[18px] font-bold tracking-[-0.02em] text-danger">{check.result.error ? "Your code raised an error" : "Not quite"}</p>
        {check.message && <p className="mt-0.5 text-[13px] leading-relaxed text-muted-foreground" dangerouslySetInnerHTML={{ __html: inlineCode(check.message) }} />}
        {check.result.error && <p className="mt-0.5 text-[13px] text-muted-foreground">Fix the error below, then check again.</p>}
      </div>
      {canReveal && (
        <button onClick={onReveal} className="btn-3d btn-3d-sm btn-3d-white mt-1 shrink-0">
          Show solution
        </button>
      )}
    </div>
  );
}

function Sparkle() {
  return (
    <div aria-hidden className="pointer-events-none absolute inset-0">
      {Array.from({ length: 14 }).map((_, i) => (
        <motion.span
          key={i}
          className="absolute size-1.5 rounded-full"
          style={{ left: 28, top: "50%", background: ["var(--success)", "var(--accent)", "var(--star)"][i % 3] }}
          initial={{ x: 0, y: 0, opacity: 1, scale: 1 }}
          animate={{ x: Math.cos((i / 14) * Math.PI * 2) * (40 + (i % 3) * 18) + 20, y: Math.sin((i / 14) * Math.PI * 2) * (22 + (i % 4) * 8), opacity: 0, scale: 0.4 }}
          transition={{ duration: 0.9, ease: "easeOut" }}
        />
      ))}
    </div>
  );
}

function CellMenu({ onReset, modified, code, onSolution, solutionOpen, dark }: { onReset: () => void; modified: boolean; code: string; onSolution?: () => void; solutionOpen?: boolean; dark?: boolean }) {
  return (
    <Dropdown>
      <DropdownTrigger asChild>
        <button className={cn("inline-flex size-7 shrink-0 items-center justify-center rounded-md transition", dark ? "text-[var(--code-muted)] hover:bg-white/8 hover:text-[var(--code-fg)]" : "text-muted-foreground hover:bg-surface-2 hover:text-foreground")} aria-label="Cell options">
          <MoreHorizontal className="size-4" />
        </button>
      </DropdownTrigger>
      <DropdownContent align="end" className="w-52">
        <DropdownItem
          onSelect={() => {
            void navigator.clipboard?.writeText(code).then(() => toast.success("Code copied"));
          }}
        >
          <Copy /> Copy code
        </DropdownItem>
        <DropdownItem onSelect={onReset} disabled={!modified}>
          <RotateCcw /> Reset to original
        </DropdownItem>
        {onSolution && (
          <>
            <DropdownSeparator />
            <DropdownItem onSelect={onSolution}>
              <Eye /> {solutionOpen ? "Hide solution" : "Show solution"}
            </DropdownItem>
          </>
        )}
      </DropdownContent>
    </Dropdown>
  );
}

function SetupCell({ cell }: { cell: LessonCell }) {
  const ctx = useInteractive();
  const [open, setOpen] = useState(false);
  return (
    <div className="not-prose my-6 overflow-hidden rounded-xl border border-dashed border-border-strong bg-surface-2/40">
      <button onClick={() => setOpen((o) => !o)} className="flex w-full items-center gap-2.5 px-4 py-2.5 text-left text-[13px] text-muted-foreground transition hover:text-foreground" aria-expanded={open}>
        <FlaskConical className="size-4 text-subtle-foreground" />
        <span className="font-medium">Lesson setup</span>
        <span className="text-subtle-foreground">· runs automatically before every cell and challenge</span>
        <ChevronDown className={cn("ml-auto size-4 transition-transform", open && "rotate-180")} />
      </button>
      {open && (
        <div className="border-t border-border bg-surface">
          <CodeEditor value={cell.code} language={ctx.language} readOnly kernelCompletion={false} ariaLabel="Lesson setup code" />
        </div>
      )}
    </div>
  );
}
