"use client";

import { useSyncExternalStore } from "react";
import type { CellLanguage } from "@latent/shared";
import { JavaRuntime } from "./java-runtime";
import { JavaScriptRuntime } from "./javascript-runtime";
import { CRuntime } from "./c-runtime";
import { HtmlRuntime } from "./html-runtime";
import type { CodeRuntime, PyError, PyVar, RunOptions, RunResult, RuntimeState, StreamChunk } from "./runtime-types";

export type { CodeRuntime, PyError, PyVar, PyValue, RunOptions, RunResult, RuntimeState, StreamChunk, TraceStep } from "./runtime-types";

/* ────────────────────────────────────────────────────────────
 * Browser runtimes. Python is Pyodide in a Web Worker; Java is
 * CheerpJ on the main thread. One instance per language per tab,
 * shared across lessons. Each lesson claims its runtime with
 * `attach`, which resets state for that lesson.
 * ──────────────────────────────────────────────────────────── */

const PYODIDE_URL = process.env.NEXT_PUBLIC_PYODIDE_URL ?? "https://cdn.jsdelivr.net/pyodide/v314.0.7/full/";
const WORKER_URL = "/runtime/python-worker.js?v=2";
const KERNEL_URL = "/runtime/kernel.py?v=2";

type Request =
  | { op: "reset"; setup: string[] }
  | { op: "run"; code: string; ns?: "kernel" | "fresh"; trace?: boolean; setup?: string[] }
  | { op: "check"; code: string; test: string | null; setup?: string[] }
  | { op: "vars" }
  | { op: "complete"; expr: string };

interface Pending {
  tag: string;
  request: Request;
  resolve: (r: unknown) => void;
  onStream?: (c: StreamChunk) => void;
}

const interrupted = (): RunResult => ({
  ok: false,
  value: null,
  error: { ename: "KeyboardInterrupt", evalue: "Execution stopped", line: null, file: null, traceback: "KeyboardInterrupt: execution was stopped" },
  images: [],
  stdout: "",
  stderr: "",
  duration: 0,
});

class PythonRuntime implements CodeRuntime {
  private worker: Worker | null = null;
  private seq = 0;
  private pending = new Map<number, Pending>();
  private interrupt: Uint8Array | null = null;
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

  /** Boots the worker (idempotent). Resolves once Python and NumPy are loaded. */
  start(): Promise<void> {
    if (this.ready) return this.ready;
    this.ready = new Promise((resolve) => (this.resolveReady = resolve));
    this.set({ phase: "loading", message: "Starting Python" });
    const worker = new Worker(WORKER_URL, { type: "module" });
    this.worker = worker;
    // A shared buffer lets us raise KeyboardInterrupt; it needs a cross-origin isolated page.
    if (typeof SharedArrayBuffer !== "undefined" && globalThis.crossOriginIsolated) this.interrupt = new Uint8Array(new SharedArrayBuffer(1));
    worker.onmessage = (e: MessageEvent) => this.onMessage(e.data);
    worker.onerror = (e) => this.set({ phase: "error", message: e.message || "The Python worker crashed" });
    worker.postMessage({ type: "init", indexURL: PYODIDE_URL, kernelURL: new URL(KERNEL_URL, location.href).href, interruptBuffer: this.interrupt ?? undefined });
    return this.ready;
  }

  private onMessage(msg: { type: string; [k: string]: unknown }) {
    if (msg.type === "status") {
      const phase = msg.phase as RuntimeState["phase"];
      const raw = msg.versions as { python?: string; numpy?: string } | undefined;
      this.set({
        phase,
        message: String(msg.message ?? ""),
        versions: raw?.python ? { runtime: `Python ${raw.python}`, packages: raw.numpy ? `NumPy ${raw.numpy}` : "standard library" } : this.state.versions,
        interruptible: !!msg.interruptible,
      });
      if (phase === "ready") this.resolveReady?.();
      return;
    }
    const p = this.pending.get(msg.id as number);
    if (!p) return;
    if (msg.type === "stream") p.onStream?.({ name: msg.name as StreamChunk["name"], text: String(msg.text) });
    if (msg.type === "reply") {
      this.pending.delete(msg.id as number);
      const response = msg.response as RunResult & { vars?: PyVar[] };
      if (response?.vars && (p.request.op === "reset" || (p.request.op === "run" && p.request.ns !== "fresh") || p.request.op === "vars")) this.set({ vars: response.vars });
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
    if (this.interrupt) this.interrupt[0] = 0;
    const id = ++this.seq;
    return new Promise<T>((resolve) => {
      this.pending.set(id, { tag, request, resolve: resolve as (r: unknown) => void, onStream });
      this.advance();
      this.worker!.postMessage({ type: "call", id, request });
    });
  }

  /** Claims the kernel for a lesson and runs its setup cells. No-op if already owned. */
  async attach(owner: string, setup: string[]) {
    if (this.owner === owner && JSON.stringify(setup) === JSON.stringify(this.setup)) return;
    this.owner = owner;
    this.setup = setup;
    await this.restart();
  }

  async restart() {
    const res = await this.call<{ ok: boolean; error?: PyError }>("__reset__", { op: "reset", setup: this.setup });
    this.set({ generation: this.state.generation + 1 });
    return res;
  }

  run(tag: string, code: string, opts: RunOptions = {}, onStream?: (c: StreamChunk) => void) {
    return this.call<RunResult>(tag, { op: "run", code, ns: opts.fresh ? "fresh" : "kernel", trace: opts.trace, setup: this.setup }, onStream);
  }

  check(tag: string, code: string, test: string | null, _opts: RunOptions = {}, onStream?: (c: StreamChunk) => void) {
    return this.call<RunResult>(tag, { op: "check", code, test, setup: this.setup }, onStream);
  }

  /** Completions from the live kernel; gives up quickly if Python is busy. */
  async complete(expr: string): Promise<{ label: string; type: string }[]> {
    if (this.state.phase !== "ready" || this.state.running) return [];
    const timeout = new Promise<{ items: [] }>((r) => setTimeout(() => r({ items: [] }), 400));
    const res = await Promise.race([this.call<{ items: { label: string; type: string }[] }>("__complete__", { op: "complete", expr }), timeout]);
    return res.items ?? [];
  }

  /**
   * Stops running code. Uses KeyboardInterrupt when the page is cross-origin
   * isolated; otherwise the worker is replaced and the kernel restarts.
   */
  async stop() {
    if (!this.pending.size) return;
    if (this.interrupt) {
      this.interrupt[0] = 2;
      return;
    }
    const stuck = [...this.pending.values()];
    this.pending.clear();
    this.worker?.terminate();
    this.worker = null;
    this.ready = null;
    this.set({ running: null, queued: [], vars: [], phase: "loading", message: "Restarting Python" });
    stuck.forEach((p) => p.resolve(p.request.op === "complete" ? { items: [] } : interrupted()));
    await this.start();
    await this.restart();
  }
}

let python: PythonRuntime | null = null;
let java: JavaRuntime | null = null;
let javascript: JavaScriptRuntime | null = null;
let c: CRuntime | null = null;
let html: HtmlRuntime | null = null;

export function getRuntime(language: CellLanguage = "python"): CodeRuntime {
  if (typeof window === "undefined") throw new Error(`The ${language} runtime only runs in the browser`);
  if (language === "java") return (java ??= new JavaRuntime());
  if (language === "javascript") return (javascript ??= new JavaScriptRuntime());
  if (language === "c") return (c ??= new CRuntime());
  if (language === "html") return (html ??= new HtmlRuntime());
  return (python ??= new PythonRuntime());
}

const SERVER_STATE: RuntimeState = { phase: "idle", message: "", versions: null, interruptible: false, running: null, queued: [], vars: [], generation: 0 };

export function useRuntimeState(language: CellLanguage = "python"): RuntimeState {
  return useSyncExternalStore(
    (fn) => getRuntime(language).subscribe(fn),
    () => getRuntime(language).state,
    () => SERVER_STATE,
  );
}
