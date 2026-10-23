"use client";

import { useState } from "react";
import { AlertTriangle, Bug, ChevronDown, Lightbulb, Sparkles } from "lucide-react";
import { cn } from "@/lib/utils";
import { errorTip } from "./error-tips";
import { PreviewFrame } from "./preview-frame";
import type { PyError, PyValue, RunResult, StreamChunk } from "./runtime";

export interface CellRun {
  status: "queued" | "running" | "done";
  mode: "run" | "check" | "trace";
  chunks: StreamChunk[];
  result: RunResult | null;
}

export function ValueChip({ value, className }: { value: PyValue; className?: string }) {
  const parts =
    value.kind === "ndarray"
      ? [`ndarray`, `shape (${value.shape!.join(", ")}${value.shape!.length === 1 ? "," : ""})`, value.dtype!]
      : value.kind === "scalar"
        ? [value.dtype!]
        : value.kind === "collection"
          ? [value.type, `len ${value.length}`]
          : [value.type];
  return (
    <span className={cn("inline-flex items-center gap-1.5 font-mono text-[11px] text-subtle-foreground", className)}>
      {parts.map((p, i) => (
        <span key={i} className={cn(i === 0 && "font-medium text-muted-foreground")}>
          {i > 0 && <span className="mr-1.5 text-border-strong">·</span>}
          {p}
        </span>
      ))}
    </span>
  );
}

/** Merges consecutive stream chunks with the same name. */
function mergeChunks(chunks: StreamChunk[]) {
  const out: StreamChunk[] = [];
  for (const c of chunks) {
    const last = out[out.length - 1];
    if (last && last.name === c.name) last.text += c.text;
    else out.push({ ...c });
  }
  return out;
}

export function CellOutput({ run, onExplain, onDebug }: { run: CellRun; onExplain?: (e: PyError) => void; onDebug?: () => void }) {
  const r = run.result;
  // While running we show live chunks; afterwards the final result (stdout + stderr) is authoritative.
  const streams = mergeChunks(run.status === "done" && r ? [...(r.stdout ? [{ name: "stdout" as const, text: r.stdout }] : []), ...(r.stderr ? [{ name: "stderr" as const, text: r.stderr }] : [])] : run.chunks);
  const hasAnything = streams.length > 0 || r?.value || r?.error || r?.previewHtml || (r?.images.length ?? 0) > 0;

  if (run.status !== "done" && !streams.length) {
    return (
      <div className="flex items-center gap-2 px-4 py-3 font-mono text-[12px] text-subtle-foreground">
        <span className="relative flex size-2">
          <span className="absolute inline-flex size-full animate-ping rounded-full bg-accent/50" />
          <span className="relative inline-flex size-2 rounded-full bg-accent" />
        </span>
        {run.status === "queued" ? "Queued, waiting for the kernel…" : "Running…"}
      </div>
    );
  }
  if (!hasAnything) {
    return <div className="px-4 py-2.5 font-mono text-[12px] text-subtle-foreground">✓ Ran without output{r ? ` · ${formatMs(r.duration)}` : ""}</div>;
  }

  return (
    <div className="space-y-3 px-4 py-3">
      {r?.previewHtml && <PreviewFrame html={r.previewHtml} />}
      {streams.map((s, i) => (
        <pre key={i} className={cn("max-h-80 overflow-auto whitespace-pre-wrap break-words font-mono text-[12.5px] leading-relaxed", s.name === "stderr" ? "text-warning" : "text-foreground/90")}>
          {s.text}
        </pre>
      ))}
      {r?.images.map((src, i) => (
        // eslint-disable-next-line @next/next/no-img-element
        <img key={i} src={`data:image/png;base64,${src}`} alt={`Figure ${i + 1}`} className="max-w-full rounded-lg border border-border bg-white" />
      ))}
      {r?.value && (
        <div className="min-w-0">
          <ValueChip value={r.value} className="mb-1" />
          <pre className="max-h-96 overflow-auto font-mono text-[12.5px] leading-relaxed text-foreground">{r.value.repr}</pre>
        </div>
      )}
      {r?.error && <ErrorCard error={r.error} onExplain={onExplain} onDebug={onDebug} />}
    </div>
  );
}

export function ErrorCard({ error, onExplain, onDebug, compact }: { error: PyError; onExplain?: (e: PyError) => void; onDebug?: () => void; compact?: boolean }) {
  const [showTrace, setShowTrace] = useState(false);
  const tip = errorTip(error);
  const where = error.line ? (error.file === "<setup>" ? "in lesson setup" : `line ${error.line}`) : null;
  return (
    <div className="overflow-hidden rounded-lg border border-danger/25 bg-danger-soft">
      <div className="flex items-start gap-2.5 px-3.5 py-3">
        <AlertTriangle className="mt-0.5 size-4 shrink-0 text-danger" />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-baseline gap-x-2">
            <span className="font-mono text-[13px] font-semibold text-danger">{error.ename}</span>
            {where && <span className="text-[11.5px] font-medium text-danger/70">{where}</span>}
          </div>
          {error.evalue && <p className="mt-0.5 break-words font-mono text-[12.5px] leading-relaxed text-foreground/85">{error.evalue}</p>}
        </div>
      </div>
      {tip && !compact && (
        <div className="flex gap-2.5 border-t border-danger/15 bg-surface/60 px-3.5 py-2.5 text-[13px] leading-relaxed text-muted-foreground">
          <Lightbulb className="mt-0.5 size-4 shrink-0 text-warning" />
          <p dangerouslySetInnerHTML={{ __html: inlineCode(tip) }} />
        </div>
      )}
      <div className="flex flex-wrap items-center gap-1 border-t border-danger/15 px-2 py-1.5">
        {onExplain && (
          <button onClick={() => onExplain(error)} className="inline-flex h-7 items-center gap-1.5 rounded-md px-2 text-xs font-medium text-accent transition hover:bg-surface">
            <Sparkles className="size-3.5" /> Explain with Atlas
          </button>
        )}
        {onDebug && error.ename !== "SyntaxError" && error.ename !== "KeyboardInterrupt" && (
          <button onClick={onDebug} className="inline-flex h-7 items-center gap-1.5 rounded-md px-2 text-xs font-medium text-muted-foreground transition hover:bg-surface hover:text-foreground">
            <Bug className="size-3.5" /> Step through to the error
          </button>
        )}
        {error.traceback && (
          <button onClick={() => setShowTrace((s) => !s)} className="ml-auto inline-flex h-7 items-center gap-1 rounded-md px-2 text-xs font-medium text-muted-foreground transition hover:bg-surface hover:text-foreground" aria-expanded={showTrace}>
            Traceback <ChevronDown className={cn("size-3.5 transition-transform", showTrace && "rotate-180")} />
          </button>
        )}
      </div>
      {showTrace && <pre className="max-h-72 overflow-auto border-t border-danger/15 bg-surface px-3.5 py-3 font-mono text-[12px] leading-relaxed text-foreground/85">{error.traceback}</pre>}
    </div>
  );
}

/** Renders `code` spans in tip text (tips are static strings we control). */
export function inlineCode(s: string) {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/`([^`]+)`/g, '<code class="rounded border border-border bg-surface-2 px-1 py-px font-mono text-[0.9em] text-foreground">$1</code>');
}

export function formatMs(ms: number) {
  if (ms < 1) return "<1 ms";
  if (ms < 1000) return `${Math.round(ms)} ms`;
  return `${(ms / 1000).toFixed(ms < 10000 ? 2 : 1)} s`;
}
