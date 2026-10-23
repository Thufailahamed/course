"use client";

import { buildHtmlDocument, buildHtmlTestDocument } from "@latent/shared";
import type { CodeRuntime, RunOptions, RunResult, RuntimeState, StreamChunk } from "./runtime-types";

/* ────────────────────────────────────────────────────────────
 * HTML & CSS lessons render in the browser itself. Examples are
 * shown in a sandboxed iframe; challenge checks run JavaScript
 * assertions inside a second, throwaway iframe so getComputedStyle
 * sees the real cascade. Nothing is downloaded and nothing is sent
 * to a server.
 * ──────────────────────────────────────────────────────────── */

const VERSIONS = { runtime: "HTML5 + CSS3", packages: "your browser's engine, nothing to install" };
const CHECK_TIMEOUT = 5000;

const empty = (): RunResult => ({
  ok: true,
  value: null,
  error: null,
  images: [],
  stdout: "",
  stderr: "",
  duration: 0,
  previewHtml: null,
});

export class HtmlRuntime implements CodeRuntime {
  private listeners = new Set<() => void>();
  private queue: Promise<unknown> = Promise.resolve();
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
    if (this.state.phase === "ready") return Promise.resolve();
    this.set({ phase: "ready", message: "", versions: VERSIONS });
    return Promise.resolve();
  }

  attach(_owner: string, _setup: string[]) {
    return this.start();
  }

  async restart() {
    this.set({ generation: this.state.generation + 1, vars: [], running: null, queued: [] });
  }

  private async serial<T>(tag: string, work: () => Promise<T>): Promise<T> {
    await this.start();
    this.set({ running: tag, queued: [] });
    const next = this.queue.then(work);
    this.queue = next.then(
      () => undefined,
      () => undefined,
    );
    try {
      return await next;
    } finally {
      this.set({ running: null });
    }
  }

  run(tag: string, code: string, _opts: RunOptions = {}, _onStream?: (c: StreamChunk) => void) {
    return this.serial(tag, async () => {
      const started = performance.now();
      return {
        ...empty(),
        previewHtml: buildHtmlDocument(code),
        duration: performance.now() - started,
      };
    });
  }

  check(tag: string, code: string, test: string | null, _opts: RunOptions = {}, _onStream?: (c: StreamChunk) => void) {
    return this.serial(tag, async () => {
      const started = performance.now();
      if (!test) return { ...empty(), ok: false, passed: false, message: "This challenge has no tests yet.", duration: 0 };
      const previewHtml = buildHtmlDocument(code);
      const result = await this.runInFrame(buildHtmlTestDocument(code, test));
      return {
        ...empty(),
        ok: result.passed,
        passed: result.passed,
        message: result.message,
        previewHtml,
        duration: performance.now() - started,
      };
    });
  }

  /** Runs the generated document in a sandboxed iframe and waits for its report. */
  private runInFrame(document: string): Promise<{ passed: boolean; message: string | null }> {
    return new Promise((resolve) => {
      const frame = window.document.createElement("iframe");
      frame.setAttribute("sandbox", "allow-scripts");
      frame.setAttribute("title", "Hidden HTML checker");
      frame.setAttribute("tabindex", "-1");
      frame.setAttribute("aria-hidden", "true");
      // Keep the frame laid out but out of sight. `visibility: hidden` makes
      // Chrome report zero-sized rects inside the frame, which breaks the
      // visibility and layout assertions; opacity does not affect layout.
      frame.style.cssText = "position:fixed;left:-10000px;top:0;width:1100px;height:900px;border:0;opacity:0;pointer-events:none;";
      let settled = false;

      const done = (result: { passed: boolean; message: string | null }) => {
        if (settled) return;
        settled = true;
        window.removeEventListener("message", onMessage);
        window.clearTimeout(timeout);
        frame.remove();
        resolve(result);
      };

      const onMessage = (event: MessageEvent) => {
        if (event.source !== frame.contentWindow) return;
        const data = event.data as { __latentHtml?: boolean; passed?: boolean; message?: string | null };
        if (!data?.__latentHtml) return;
        done({ passed: !!data.passed, message: data.message ?? null });
      };

      const timeout = window.setTimeout(() => {
        done({ passed: false, message: "The check took too long. Keep the page simple and try again." });
      }, CHECK_TIMEOUT);

      window.addEventListener("message", onMessage);
      frame.srcdoc = document;
      window.document.body.appendChild(frame);
    });
  }

  complete(_expr: string) {
    return Promise.resolve([]);
  }

  stop() {
    return Promise.resolve();
  }
}
