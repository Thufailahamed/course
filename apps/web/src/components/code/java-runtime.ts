"use client";

import type { JavaBody } from "@latent/shared";
import { javaClassOffset, javaClassTestSource, javaCompileError, javaMainCheckSource, javaMainRunSource, javaMarkers, javaPackagePrefix, javaRuntimeError } from "@latent/shared";
import type { CodeRuntime, RunOptions, RunResult, RuntimeState, StreamChunk } from "./runtime-types";

/* ────────────────────────────────────────────────────────────
 * In-browser Java. CheerpJ runs a real JVM and javac as WebAssembly
 * on the main thread (it cannot run inside a Worker), so output is
 * read from CheerpJ's `#console` element and every run uses a fresh
 * package name to avoid the JVM reusing a previously loaded class.
 *
 * The source wrappers and output parsing live in
 * packages/shared/src/java-harness.ts so the Node validator compiles
 * and checks exactly what learners run.
 * ──────────────────────────────────────────────────────────── */

declare global {
  interface Window {
    cheerpjInit?: (opts?: Record<string, unknown>) => Promise<void>;
    cheerpjRunMain?: (mainClass: string, classPath: string, ...args: string[]) => Promise<number>;
    cheerpjCreateDisplay?: (width: number, height: number, element: HTMLElement) => void;
    cheerpjAddStringFile?: (path: string, data: Uint8Array) => void;
    cheerpOSAddStringFile?: (path: string, data: Uint8Array) => void;
  }
}

const CHEERPJ_BASE = (process.env.NEXT_PUBLIC_CHEERPJ_URL ?? "https://cjrtnc.leaningtech.com/4.3/").replace(/\/?$/, "/");
const TOOLS_JAR = "/app/runtime/java/tools.jar";
const CLASS_PATH = `${TOOLS_JAR}:/files/`;
const HOST_ID = "latent-java-host";

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

let runSeq = 0;

function loadScript(src: string) {
  return new Promise<void>((resolve, reject) => {
    const existing = document.querySelector<HTMLScriptElement>(`script[data-cheerpj]`);
    if (existing?.dataset.loaded === "true" || window.cheerpjInit) return resolve();
    if (existing) {
      existing.addEventListener("load", () => resolve(), { once: true });
      existing.addEventListener("error", () => reject(new Error("CheerpJ failed to load")), { once: true });
      return;
    }
    const script = document.createElement("script");
    script.src = src;
    script.async = true;
    script.dataset.cheerpj = "true";
    script.addEventListener(
      "load",
      () => {
        script.dataset.loaded = "true";
        resolve();
      },
      { once: true },
    );
    script.addEventListener("error", () => reject(new Error("CheerpJ failed to load")), { once: true });
    document.head.appendChild(script);
  });
}

interface ExecResult {
  exit: number;
  raw: string;
  duration: number;
}

export class JavaRuntime implements CodeRuntime {
  private listeners = new Set<() => void>();
  private ready: Promise<void> | null = null;
  private consoleEl: HTMLElement | null = null;
  private owner: string | null = null;
  private queue: { tag: string; job: () => Promise<RunResult>; resolve: (r: RunResult) => void }[] = [];
  private pumping = false;
  private runs = 0;

  state: RuntimeState = { phase: "idle", message: "", versions: null, interruptible: false, running: null, queued: [], vars: [], generation: 0 };

  subscribe = (fn: () => void) => {
    this.listeners.add(fn);
    return () => this.listeners.delete(fn);
  };

  private set(patch: Partial<RuntimeState>) {
    this.state = { ...this.state, ...patch };
    this.listeners.forEach((l) => l());
  }

  start(): Promise<void> {
    if (this.ready) return this.ready;
    this.ready = this.boot().catch((e) => {
      this.ready = null;
      this.set({ phase: "error", message: e instanceof Error ? e.message : "Java failed to load" });
      throw e;
    });
    return this.ready;
  }

  private async boot() {
    this.set({ phase: "loading", message: "Starting Java (downloading the compiler on first visit)" });
    this.ensureHost();
    await loadScript(`${CHEERPJ_BASE}loader.js`);
    if (!window.cheerpjInit) throw new Error("CheerpJ did not expose its runtime API");
    await window.cheerpjInit({ status: "none", version: 8 });
    if (!window.cheerpjRunMain) throw new Error("CheerpJ did not expose its execution API");
    const display = document.getElementById("latent-java-display");
    if (window.cheerpjCreateDisplay && display) window.cheerpjCreateDisplay(-1, -1, display);
    this.consoleEl!.innerHTML = "";
    this.set({ phase: "ready", message: "", versions: { runtime: "OpenJDK 8", packages: "javac" } });
  }

  private ensureHost() {
    let host = document.getElementById(HOST_ID);
    if (!host) {
      host = document.createElement("div");
      host.id = HOST_ID;
      host.setAttribute("aria-hidden", "true");
      host.style.cssText = "position:fixed;left:-100000px;top:0;width:1px;height:1px;overflow:hidden;pointer-events:none";
      host.innerHTML = `<div id="latent-java-display"></div><pre id="console"></pre>`;
      document.body.appendChild(host);
    }
    this.consoleEl = document.getElementById("console");
    if (!this.consoleEl) {
      const pre = document.createElement("pre");
      pre.id = "console";
      host.appendChild(pre);
      this.consoleEl = pre;
    }
  }

  private consoleText() {
    return this.consoleEl?.textContent ?? "";
  }

  private clearConsole() {
    if (this.consoleEl) this.consoleEl.innerHTML = "";
  }

  attach(owner: string, _setup: string[]) {
    if (this.owner !== owner) {
      this.owner = owner;
      this.set({ generation: this.state.generation + 1 });
    }
    void this.start().catch(() => {});
    return Promise.resolve({ ok: true });
  }

  restart() {
    this.set({ generation: this.state.generation + 1, vars: [] });
    return Promise.resolve({ ok: true });
  }

  stop() {
    // CheerpJ executes on the main thread and cannot be interrupted safely.
    return Promise.resolve();
  }

  complete() {
    return Promise.resolve([]);
  }

  run(tag: string, code: string, opts: RunOptions = {}, onStream?: (c: StreamChunk) => void) {
    return this.enqueue(tag, () => this.execute(tag, code, null, opts.body ?? "main", onStream));
  }

  check(tag: string, code: string, test: string | null, opts: RunOptions = {}, onStream?: (c: StreamChunk) => void) {
    return this.enqueue(tag, () => this.execute(tag, code, test, opts.body ?? "main", onStream));
  }

  private enqueue(tag: string, job: () => Promise<RunResult>) {
    return new Promise<RunResult>((resolve) => {
      this.queue.push({ tag, job, resolve });
      this.set({ queued: this.queue.map((q) => q.tag) });
      void this.pump();
    });
  }

  private async pump() {
    if (this.pumping) return;
    const next = this.queue.shift();
    if (!next) return;
    this.pumping = true;
    this.set({ running: next.tag, queued: this.queue.map((q) => q.tag) });
    try {
      await this.start();
      next.resolve(await next.job());
    } catch (e) {
      next.resolve(this.failure(e instanceof Error ? e.message : "Java failed to run"));
    } finally {
      this.pumping = false;
      this.set({ running: null, queued: this.queue.map((q) => q.tag) });
      if (this.queue.length) void this.pump();
    }
  }

  private async execute(tag: string, code: string, test: string | null, body: JavaBody, onStream?: (c: StreamChunk) => void): Promise<RunResult> {
    void tag;
    const started = performance.now();
    this.runs += 1;
    const pkg = `latent${++runSeq}`;
    const files: { name: string; source: string }[] = [];
    let mainClass = "Main";
    let offset = 0;
    let codeLines = code.split("\n").length;

    if (body === "class") {
      if (/^\s*package\s+/m.test(code)) {
        return this.failure("Remove the `package` declaration — the lesson supplies one.", { line: 1, file: "<cell>" });
      }
      if (!/\bclass\s+Main\b/.test(code)) {
        return this.failure("A class-mode cell needs a `public class Main`.", { line: 1, file: "<cell>" });
      }
      offset = javaClassOffset(pkg);
      files.push({ name: "Main.java", source: `${javaPackagePrefix(pkg)}${code}\n` });
      if (test) files.push({ name: "LatentTest.java", source: javaClassTestSource(pkg, test) });
      mainClass = test ? "LatentTest" : "Main";
    } else if (test) {
      const built = javaMainCheckSource(pkg, code, test);
      files.push({ name: "Main.java", source: built.source });
      offset = built.offset;
      codeLines = built.codeLines;
    } else {
      const built = javaMainRunSource(pkg, code);
      files.push({ name: "Main.java", source: built.source });
      offset = built.offset;
    }

    const addStringFile = window.cheerpOSAddStringFile ?? window.cheerpjAddStringFile;
    if (!addStringFile) return this.failure("CheerpJ did not expose its file API");
    for (const f of files) addStringFile(`/str/${f.name}`, new TextEncoder().encode(f.source));

    this.clearConsole();
    let compileExit = 0;
    try {
      compileExit = await window.cheerpjRunMain!("com.sun.tools.javac.Main", CLASS_PATH, ...files.map((f) => `/str/${f.name}`), "-d", "/files/", "-Xlint:none");
    } catch (e) {
      return this.failure(e instanceof Error ? e.message : "The Java compiler failed to start", { duration: performance.now() - started, count: this.runs });
    }
    await sleep(60);
    const compileRaw = this.consoleText();
    if (compileExit !== 0 || /\berror:/.test(compileRaw)) {
      return {
        ok: false,
        value: null,
        error: javaCompileError(compileRaw, offset, codeLines),
        images: [],
        stdout: "",
        stderr: "",
        duration: performance.now() - started,
        count: this.runs,
        vars: [],
      };
    }

    // Tests print their own markers; streaming them would leak the harness output.
    const exec = await this.execMain(pkg, mainClass, test ? undefined : onStream);
    const result = this.readResult(exec, test !== null, offset, codeLines);
    result.duration = performance.now() - started;
    result.count = this.runs;
    result.vars = [];
    return result;
  }

  private async execMain(pkg: string, className: string, onStream?: (c: StreamChunk) => void): Promise<ExecResult> {
    this.clearConsole();
    const started = performance.now();
    let seen = 0;
    const poll = onStream
      ? setInterval(() => {
          const text = this.consoleEl?.textContent ?? "";
          if (text.length > seen) {
            onStream({ name: "stdout", text: text.slice(seen) });
            seen = text.length;
          }
        }, 90)
      : null;
    let exit = 0;
    try {
      exit = await window.cheerpjRunMain!(`${pkg}.${className}`, "/files/");
    } catch (e) {
      exit = 1;
      this.consoleEl!.textContent += `\n${e instanceof Error ? e.message : "Java failed to run"}`;
    } finally {
      if (poll) clearInterval(poll);
    }
    await sleep(90);
    if (onStream) {
      const text = this.consoleEl?.textContent ?? "";
      if (text.length > seen) onStream({ name: "stdout", text: text.slice(seen) });
    }
    return { exit, raw: this.consoleText(), duration: performance.now() - started };
  }

  private readResult(exec: ExecResult, checked: boolean, offset: number, codeLines: number): RunResult {
    const raw = exec.raw;
    if (checked) {
      const markers = javaMarkers(raw);
      if (markers.pass) {
        return { ok: true, value: null, error: null, images: [], stdout: markers.stdout, stderr: "", duration: 0, passed: true, message: null };
      }
      if (markers.message !== null) {
        return { ok: false, value: null, error: null, images: [], stdout: markers.stdout, stderr: "", duration: 0, passed: false, message: markers.message };
      }
      const error = javaRuntimeError(raw, offset, codeLines);
      if (error) return { ok: false, value: null, error, images: [], stdout: "", stderr: "", duration: 0, passed: false, message: null };
      return {
        ok: false,
        value: null,
        error: null,
        images: [],
        stdout: markers.stdout,
        stderr: "",
        duration: 0,
        passed: false,
        message: markers.stdout ? "The program ended before every check ran." : "No output — did `main` finish before the checks ran?",
      };
    }

    const error = exec.exit !== 0 ? javaRuntimeError(raw, offset, codeLines) : null;
    return { ok: !error, value: null, error, images: [], stdout: raw.trimEnd(), stderr: "", duration: 0 };
  }

  private failure(message: string, extra: { duration?: number; count?: number; line?: number; file?: string } = {}): RunResult {
    return {
      ok: false,
      value: null,
      error: { ename: "RuntimeError", evalue: message, line: extra.line ?? null, file: extra.file ?? null, traceback: message },
      images: [],
      stdout: "",
      stderr: "",
      duration: extra.duration ?? 0,
      count: extra.count,
      vars: [],
    };
  }
}
