import type { CellLanguage, JavaBody } from "@latent/shared";

/* ────────────────────────────────────────────────────────────
 * Shared shape of every in-browser language runtime.
 * Python runs in a Web Worker (Pyodide); Java runs on the main
 * thread through CheerpJ. The UI only depends on this contract.
 * ──────────────────────────────────────────────────────────── */

export interface PyValue {
  type: string;
  kind: "ndarray" | "scalar" | "function" | "class" | "collection" | "value";
  repr: string;
  shape?: number[];
  dtype?: string;
  nbytes?: number;
  length?: number;
}

export interface PyVar extends PyValue {
  name: string;
}

export interface PyError {
  ename: string;
  evalue: string;
  line: number | null;
  file: string | null;
  traceback: string;
}

export interface TraceStep {
  line: number | null;
  event: "line" | "return" | "exception" | "end";
  func: string;
  stack: { func: string; line: number }[];
  vars: Record<string, PyValue>;
  /** Characters of output written before this step. */
  out: number;
  value?: PyValue;
  exc?: string;
}

export interface RunResult {
  ok: boolean;
  value: PyValue | null;
  error: PyError | null;
  images: string[];
  stdout: string;
  stderr: string;
  duration: number;
  /** HTML & CSS lessons: a complete, sandbox-ready document to preview. */
  previewHtml?: string | null;
  count?: number;
  vars?: PyVar[];
  steps?: TraceStep[] | null;
  output?: string;
  truncatedSteps?: boolean;
  /** Challenge checks only. */
  passed?: boolean;
  message?: string | null;
}

export type StreamChunk = { name: "stdout" | "stderr"; text: string };

export interface RuntimeState {
  phase: "idle" | "loading" | "ready" | "error";
  message: string;
  versions: { runtime: string; packages: string } | null;
  interruptible: boolean;
  /** Tag of the request currently executing (usually a cell id). */
  running: string | null;
  queued: string[];
  vars: PyVar[];
  /** Bumped whenever the runtime is reset (restart or lesson change). */
  generation: number;
}

export interface RunOptions {
  /** A fresh namespace, used for challenges and predictions. */
  fresh?: boolean;
  /** Python only: record trace steps for the debugger. */
  trace?: boolean;
  /** Java only: whether code is a snippet or a complete source file. */
  body?: JavaBody;
}

export interface CodeRuntime {
  state: RuntimeState;
  subscribe(fn: () => void): () => void;
  start(): Promise<void>;
  attach(owner: string, setup: string[]): Promise<unknown>;
  restart(): Promise<unknown>;
  run(tag: string, code: string, opts?: RunOptions, onStream?: (c: StreamChunk) => void): Promise<RunResult>;
  check(tag: string, code: string, test: string | null, opts?: RunOptions, onStream?: (c: StreamChunk) => void): Promise<RunResult>;
  complete(expr: string): Promise<{ label: string; type: string }[]>;
  stop(): Promise<void>;
}

export type Language = CellLanguage;
