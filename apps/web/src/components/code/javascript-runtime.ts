"use client";

import type { CodeRuntime, PyVar, RunOptions, RunResult, RuntimeState, StreamChunk } from "./runtime-types";

/* ────────────────────────────────────────────────────────────
 * In-browser JavaScript. The browser's own engine runs lesson code
 * inside a module Web Worker (no download, no install). The worker
 * speaks the same protocol as the Python one, and the kernel
 * (public/runtime/js-kernel.mjs) is shared with the Node validator.
 * Debugger traces are not recorded for JavaScript.
 * ──────────────────────────────────────────────────────────── */

const WORKER_URL = "/runtime/js-worker.js?v=1";

type Request =
  | { op: "reset"; setup: string[] }
  | { op: "run"; code: string; ns?: "kernel" | "fresh"; setup?: string[] }
  | { op: "check"; code: string; test: string | null; setup?: string[] }
  | { op: "complete"; expr: string };

interface Pending {
  tag: string;
  request: Request;
  resolve: (r: unknown) => void;
  onStream?: (c: StreamChunk) => void;
}

const VERSIONS = { runtime: "JavaScript (ES2024)", packages: "built in, nothing to install" };

const interrupted = (): RunResult => ({
  ok: false,
  value: null,
  error: { ename: "KeyboardInterrupt", evalue: "Execution stopped", line: null, file: null, traceback: "KeyboardInterrupt: execution was stopped" },
  images: [],
  stdout: "",
  stderr: "",
  duration: 0,
});

export class JavaScriptRuntime implements CodeRuntime {
  private worker: Worker | null = null;
  private seq = 0;
  private pending = new Map<number, Pending>();
  private listeners = new Set<() => void>();
  private setup: string[] = [];
  private owner: string | null = null;
  private ready: Promise<void> | null = null;
  private resolveReady: (() => void) | null = null;
  state: RuntimeState = { phase: "idle", message: "", versions: null, interruptible: false, running: null, queued: [], vars: [], generation: 0 };

  subscribe = (fn: () => void) => {
    this.listeners.add(fn);
    return () => this.listeners.delete(fn);
  };

  private set(patch: Partial<RuntimeState>) {
    this.state = { ...this.state, ...patch };
    this.listeners.forEach((l) => l());
  }

  /** Starts the worker (idempotent). Resolves once the kernel is ready. */
  start(): Promise<void> {
    if (this.ready) return this.ready;
    this.ready = new Promise((resolve) => (this.resolveReady = resolve));
    this.set({ phase: "loading", message: "Starting JavaScript" });
    const worker = new Worker(WORKER_URL, { type: "module" });
    this.worker = worker;
    worker.onmessage = (e: MessageEvent) => this.onMessage(e.data);
    worker.onerror = (e) => this.set({ phase: "error", message: e.message || "The JavaScript worker crashed" });
    worker.postMessage({ type: "init" });
    return this.ready;
  }

  private onMessage(msg: { type: string; [k: string]: unknown }) {
    if (msg.type === "status") {
      const phase = msg.phase as RuntimeState["phase"];
      this.set({ phase, message: String(msg.message ?? ""), versions: phase === "ready" ? VERSIONS : this.state.versions });
      if (phase === "ready") this.resolveReady?.();
      return;
    }
    const p = this.pending.get(msg.id as number);
    if (!p) return;
    if (msg.type === "stream") p.onStream?.({ name: msg.name as StreamChunk["name"], text: String(msg.text) });
    if (msg.type === "reply") {
      this.pending.delete(msg.id as number);
      const response = msg.response as RunResult & { vars?: PyVar[] };
      if (response?.vars && (p.request.op === "reset" || (p.request.op === "run" && p.request.ns !== "fresh"))) this.set({ vars: response.vars });
      this.advance();
      p.resolve(response);
    }
  }

  /** Marks the next queued request as running (the worker executes in order). */
  private advance() {
    const next = [...this.pending.values()][0];
    this.set({ running: next?.tag ?? null, queued: [...this.pending.values()].slice(1).map((p) => p.tag) });
  }

  private async call<T>(tag: string, request: Request, onStream?: (c: StreamChunk) => void): Promise<T> {
    await this.start();
    const id = ++this.seq;
    return new Promise<T>((resolve) => {
      this.pending.set(id, { tag, request, resolve: resolve as (r: unknown) => void, onStream });
      this.advance();
      this.worker!.postMessage({ type: "call", id, request });
    });
  }

  /** Claims the runtime for a lesson and runs its setup cells. No-op if already owned. */
  async attach(owner: string, setup: string[]) {
    if (this.owner === owner && JSON.stringify(setup) === JSON.stringify(this.setup)) return;
    this.owner = owner;
    this.setup = setup;
    await this.restart();
  }

  async restart() {
    const res = await this.call<{ ok: boolean }>("__reset__", { op: "reset", setup: this.setup });
    this.set({ generation: this.state.generation + 1 });
    return res;
  }

  run(tag: string, code: string, opts: RunOptions = {}, onStream?: (c: StreamChunk) => void) {
    return this.call<RunResult>(tag, { op: "run", code, ns: opts.fresh ? "fresh" : "kernel", setup: this.setup }, onStream);
  }

  check(tag: string, code: string, test: string | null, _opts?: RunOptions, onStream?: (c: StreamChunk) => void) {
    return this.call<RunResult>(tag, { op: "check", code, test, setup: this.setup }, onStream);
  }

  /** Completions for global names; gives up quickly if the runtime is busy. */
  async complete(expr: string): Promise<{ label: string; type: string }[]> {
    if (this.state.phase !== "ready" || this.state.running) return [];
    const timeout = new Promise<{ items: [] }>((r) => setTimeout(() => r({ items: [] }), 400));
    const res = await Promise.race([this.call<{ items: { label: string; type: string }[] }>("__complete__", { op: "complete", expr }), timeout]);
    return res.items ?? [];
  }

  /**
   * Stops running code. The engine can't be interrupted from the page, so the
   * worker is replaced and the lesson's setup runs again.
   */
  async stop() {
    if (!this.pending.size) return;
    const stuck = [...this.pending.values()];
    this.pending.clear();
    this.worker?.terminate();
    this.worker = null;
    this.ready = null;
    this.set({ running: null, queued: [], vars: [], phase: "loading", message: "Restarting JavaScript" });
    stuck.forEach((p) => p.resolve(p.request.op === "complete" ? { items: [] } : interrupted()));
    await this.start();
    await this.restart();
  }
}
