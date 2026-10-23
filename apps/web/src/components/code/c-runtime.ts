"use client";

import { cProgram } from "@latent/shared";
import type { CodeRuntime, PyError, RunOptions, RunResult, RuntimeState, StreamChunk } from "./runtime-types";

/* ────────────────────────────────────────────────────────────
 * In-browser C. Clang 22 runs as WebAssembly inside a classic Web
 * Worker (public/runtime/c-worker.js): each request compiles the
 * program, links it against WASI libc, and runs it with the cell's
 * stdin. Programs are compiled from source every time, so there is
 * no shared state between cells; setup cells are prepended instead.
 *
 * A call that runs longer than CALL_TIMEOUT_MS (an infinite loop,
 * say) stops the worker, and the next call starts a fresh one.
 * ──────────────────────────────────────────────────────────── */

const WORKER_URL = "/runtime/c-worker.js?v=1";
const CALL_TIMEOUT_MS = 20_000;
const VERSIONS = { runtime: "C (Clang 22, WebAssembly)", packages: "built in, nothing to install" };

/** What the worker sends back for one compile-and-run request. */
interface Raw {
  compiled: boolean;
  exitCode: number | null;
  stdout: string;
  stderr: string;
  errors: string[];
  duration: number;
  crashed?: boolean;
  timedOut?: boolean;
  stopped?: boolean;
}

interface Pending {
  tag: string;
  resolve: (r: Raw) => void;
  timer: ReturnType<typeof setTimeout>;
}

const empty = (patch: Partial<Raw>): Raw => ({ compiled: false, exitCode: null, stdout: "", stderr: "", errors: [], duration: 0, ...patch });

function toResult(raw: Raw, codeLine: number, mode: "run" | "check"): RunResult {
  const base = { value: null, images: [], stdout: raw.stdout, stderr: raw.stderr, duration: raw.duration };
  const fail = (error: PyError, message: string | null = null): RunResult => ({ ...base, ok: false, error, passed: false, message });

  if (raw.timedOut) {
    return fail({ ename: "TimeoutError", evalue: "Stopped after 20 seconds", line: null, file: null, traceback: "The program ran for more than 20 seconds. Check that every loop has an update that eventually ends it." });
  }
  if (raw.stopped) {
    return fail({ ename: "KeyboardInterrupt", evalue: "Execution stopped", line: null, file: null, traceback: "Execution was stopped." });
  }
  if (!raw.compiled) {
    const first = raw.errors.find((l) => /: error:/.test(l)) ?? raw.errors[0] ?? "The program did not compile";
    const at = /main\.c:(\d+):\d+: error/.exec(raw.errors.join("\n"));
    const cellLine = at ? Number(at[1]) - codeLine + 1 : 0;
    const line = cellLine >= 1 ? cellLine : null;
    const evalue = first.replace(/^main\.c:\d+:\d+: /, "");
    return fail({ ename: "CompileError", evalue, line, file: line ? "<cell>" : null, traceback: raw.errors.join("\n") }, `Does not compile: ${evalue}`);
  }
  if (raw.crashed) {
    const evalue = "The program crashed";
    return { ...base, ok: false, error: { ename: "RuntimeError", evalue, line: null, file: null, traceback: raw.stderr }, passed: false, message: mode === "check" ? evalue : null };
  }
  if (mode === "check") {
    if (raw.exitCode === 0) return { ...base, ok: true, error: null, passed: true, message: null };
    const failed = raw.stdout.split("\n").find((l) => l.startsWith("FAILED: "));
    const reason = failed ? failed.slice("FAILED: ".length) : raw.stderr.trim().split("\n")[0] || `The tests exited with status ${raw.exitCode}`;
    return { ...base, ok: false, error: null, passed: false, message: reason };
  }
  if (raw.exitCode !== 0) {
    return { ...base, ok: false, error: { ename: "ExitStatus", evalue: `Program exited with status ${raw.exitCode}`, line: null, file: null, traceback: `The program returned ${raw.exitCode} from main.` } };
  }
  return { ...base, ok: true, error: null };
}

export class CRuntime implements CodeRuntime {
  private worker: Worker | null = null;
  private seq = 0;
  private pending = new Map<number, Pending>();
  private listeners = new Set<() => void>();
  private setup: string[] = [];
  private owner: string | null = null;
  private ready: Promise<void> | null = null;
  private resolveReady: (() => void) | null = null;
  state: RuntimeState = { phase: "idle", message: "", versions: null, interruptible: true, running: null, queued: [], vars: [], generation: 0 };

  subscribe = (fn: () => void) => {
    this.listeners.add(fn);
    return () => this.listeners.delete(fn);
  };

  private set(patch: Partial<RuntimeState>) {
    this.state = { ...this.state, ...patch };
    this.listeners.forEach((l) => l());
  }

  /** Starts the worker (idempotent). Resolves once the compiler is ready or has failed. */
  start(): Promise<void> {
    if (this.ready) return this.ready;
    this.ready = new Promise((resolve) => (this.resolveReady = resolve));
    this.set({ phase: "loading", message: "Starting the C compiler" });
    const worker = new Worker(WORKER_URL);
    this.worker = worker;
    worker.onmessage = (e: MessageEvent) => this.onMessage(e.data);
    worker.onerror = (e) => {
      this.set({ phase: "error", message: e.message || "The C worker crashed" });
      this.resolveReady?.();
    };
    worker.postMessage({ type: "init" });
    return this.ready;
  }

  private onMessage(msg: { type: string; [k: string]: unknown }) {
    if (msg.type === "status") {
      const phase = msg.phase as RuntimeState["phase"];
      this.set({ phase, message: String(msg.message ?? ""), versions: phase === "ready" ? VERSIONS : this.state.versions });
      if (phase === "ready" || phase === "error") this.resolveReady?.();
      return;
    }
    if (msg.type === "reply") {
      const id = msg.id as number;
      const p = this.pending.get(id);
      if (!p) return;
      clearTimeout(p.timer);
      this.pending.delete(id);
      this.advance();
      p.resolve(msg.response as Raw);
    }
  }

  /** Marks the next queued request as running (the worker answers in order). */
  private advance() {
    const all = [...this.pending.values()];
    this.set({ running: all[0]?.tag ?? null, queued: all.slice(1).map((p) => p.tag) });
  }

  /** Stops the worker and resolves every waiting call. `timedOutId` names the call that ran too long. */
  private kill(timedOutId: number | null) {
    const stuck = [...this.pending.entries()];
    this.pending.clear();
    this.worker?.terminate();
    this.worker = null;
    this.ready = null;
    this.set({ running: null, queued: [], phase: "idle", message: "" });
    for (const [id, p] of stuck) {
      clearTimeout(p.timer);
      p.resolve(empty({ timedOut: id === timedOutId, stopped: id !== timedOutId }));
    }
  }

  private async call(tag: string, source: string): Promise<Raw> {
    await this.start();
    if (this.state.phase === "error") return empty({ errors: [this.state.message] });
    const id = ++this.seq;
    return new Promise<Raw>((resolve) => {
      const timer = setTimeout(() => this.kill(id), CALL_TIMEOUT_MS);
      this.pending.set(id, { tag, resolve, timer });
      this.advance();
      this.worker!.postMessage({ type: "call", id, source });
    });
  }

  /** Claims the runtime for a lesson and remembers its setup cells. */
  async attach(owner: string, setup: string[]) {
    if (this.owner === owner && JSON.stringify(setup) === JSON.stringify(this.setup)) return;
    this.owner = owner;
    this.setup = setup;
    await this.restart();
  }

  async restart() {
    this.set({ generation: this.state.generation + 1 });
    return { ok: true };
  }

  async run(tag: string, code: string, _opts?: RunOptions, _onStream?: (c: StreamChunk) => void): Promise<RunResult> {
    const program = cProgram(this.setup, code);
    return toResult(await this.call(tag, program.source), program.codeLine, "run");
  }

  async check(tag: string, code: string, test: string | null, _opts?: RunOptions, _onStream?: (c: StreamChunk) => void): Promise<RunResult> {
    const program = cProgram(this.setup, code, test ?? "");
    return toResult(await this.call(tag, program.source), program.codeLine, "check");
  }

  /** C has no completion engine in the browser; the editor falls back to its keyword list. */
  async complete(_expr: string): Promise<{ label: string; type: string }[]> {
    return [];
  }

  /** Stops running code by replacing the worker. */
  async stop() {
    if (!this.pending.size) return;
    this.kill(null);
  }
}
