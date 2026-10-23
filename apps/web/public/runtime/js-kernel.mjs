/* Latent JavaScript kernel: the same request/response protocol as kernel.py, but it runs
 * code in the host's own JavaScript engine. Used by the browser worker (js-worker.js) and by
 * the Node validator (seed/courses/validate.mjs), so lessons behave the same in both.
 *
 * Requests (JSON, see handle()):
 *   reset {setup}                  wipe the shared scope, then run setup cells
 *   run {code, ns?, setup?}        ns "kernel" (default) shares the scope; "fresh" runs in its own scope
 *   check {code, test, setup?}     setup → learner code → tests, in a fresh scope
 *   vars {}                        the variables declared by run cells
 *   complete {expr}                global names that start with expr
 *
 * Top-level `const`, `let` and `class` are rewritten to `var` (and `class` to a `var`
 * expression) so later cells can see them. Cells that contain `await` run in their own
 * async scope, so their declarations stay local.
 */

const AsyncFunction = Object.getPrototypeOf(async function () {}).constructor;
const TIMEOUT_MS = 8000;
// The kernel's own timers are never tracked, even while a cell has patched setTimeout.
const realSetTimeout = globalThis.setTimeout.bind(globalThis);
const realClearTimeout = globalThis.clearTimeout.bind(globalThis);

class AssertionError extends Error {
  constructor(message) {
    super(message);
    this.name = "AssertionError";
  }
}

const assert = (condition, message = "An assertion failed") => {
  if (!condition) throw new AssertionError(message);
};

/* Deep structural equality for lesson tests (arrays, plain objects, Maps, Sets, Dates). */
const same = (a, b) => {
  if (Object.is(a, b)) return true;
  if (typeof a !== typeof b || a === null || b === null || typeof a !== "object") return false;
  if (Array.isArray(a) !== Array.isArray(b)) return false;
  if (a instanceof Date && b instanceof Date) return a.getTime() === b.getTime();
  if (a instanceof Map && b instanceof Map) return a.size === b.size && [...a].every(([k, v]) => b.has(k) && same(v, b.get(k)));
  if (a instanceof Set && b instanceof Set) return a.size === b.size && [...a].every((v) => b.has(v));
  const ka = Object.keys(a);
  const kb = Object.keys(b);
  return ka.length === kb.length && ka.every((k) => Object.hasOwn(b, k) && same(a[k], b[k]));
};

const assertEqual = (actual, expected, message) => {
  if (!same(actual, expected)) throw new AssertionError(`${message ? message + ": " : ""}expected ${inspect(expected)}, got ${inspect(actual)}`);
};

/* ── Formatting: the console.log rules documented in AUTHORING.md ─────────────── */

const IDENT = /^[A-Za-z_$][\w$]*$/;

export function inspect(v, depth = 0, seen = new Set(), top = false) {
  if (typeof v === "string") return top ? v : `'${v.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\n/g, "\\n")}'`;
  if (typeof v === "bigint") return `${v}n`;
  if (typeof v === "number") return Object.is(v, -0) ? "-0" : String(v);
  if (v === null || typeof v !== "object" && typeof v !== "function") return String(v);
  if (typeof v === "symbol") return v.toString();
  if (typeof v === "function") {
    if (/^class\b/.test(Function.prototype.toString.call(v))) return `[class ${v.name || "(anonymous)"}]`;
    return v.name ? `[Function: ${v.name}]` : "[Function (anonymous)]";
  }
  if (seen.has(v)) return "[Circular]";
  if (v instanceof Error) return `${v.name}: ${v.message}`;
  if (v instanceof Date) return Number.isNaN(v.getTime()) ? "Invalid Date" : v.toISOString();
  if (depth > 2) return Array.isArray(v) ? "[Array]" : "[Object]";
  seen.add(v);
  const child = (x) => inspect(x, depth + 1, seen);
  let out;
  if (Array.isArray(v)) {
    out = v.length ? `[ ${v.map(child).join(", ")} ]` : "[]";
  } else if (v instanceof Map) {
    const items = [...v].map(([k, x]) => `${child(k)} => ${child(x)}`);
    out = items.length ? `Map(${v.size}) { ${items.join(", ")} }` : `Map(0) {}`;
  } else if (v instanceof Set) {
    const items = [...v].map(child);
    out = items.length ? `Set(${v.size}) { ${items.join(", ")} }` : `Set(0) {}`;
  } else {
    const keys = Object.keys(v);
    const name = v.constructor && v.constructor !== Object ? `${v.constructor.name} ` : "";
    const items = keys.map((k) => `${IDENT.test(k) ? k : `'${k}'`}: ${child(v[k])}`);
    out = items.length ? `${name}{ ${items.join(", ")} }` : `${name}{}`;
  }
  seen.delete(v);
  return out;
}

/* A repr for the variables panel and run results, in the shape the UI expects. */
function describe(v) {
  const repr = inspect(v, 0, new Set(), false);
  const type = v === null ? "null" : Array.isArray(v) ? "Array" : typeof v === "object" ? (v.constructor?.name ?? "Object") : typeof v;
  let kind = "value";
  if (typeof v === "function") kind = /^class\b/.test(Function.prototype.toString.call(v)) ? "class" : "function";
  else if (v !== null && typeof v === "object") kind = "collection";
  else if (v !== undefined) kind = "scalar";
  const out = { type, kind, repr: repr.length > 400 ? repr.slice(0, 400) + "…" : repr };
  if (Array.isArray(v)) out.length = v.length;
  return out;
}

/* ── Scope and capture ─────────────────────────────────────────── */

let declared = new Set();
let emit = () => {};
let capture = null;

/**
 * Runs fn with console redirected and collects its output. Resolves to { value, acc }.
 * Enforces the time limit and always restores the console, even when the code never finishes.
 */
async function captured(fn) {
  const acc = { stdout: "", stderr: "" };
  const write = (name) => (...args) => {
    const text = args.map((a) => inspect(a, 0, new Set(), true)).join(" ") + "\n";
    acc[name] += text;
    emit(name, text);
  };
  const fake = { log: write("stdout"), info: write("stdout"), debug: write("stdout"), warn: write("stderr"), error: write("stderr") };
  const real = globalThis.console;
  const previous = capture;
  capture = acc;
  globalThis.console = { ...real, ...fake };

  // Timers scheduled by the cell are tracked so the cell's output includes what they log.
  const pendingTimers = new Set();
  const savedSetTimeout = globalThis.setTimeout;
  const savedClearTimeout = globalThis.clearTimeout;
  globalThis.setTimeout = (fn, ms = 0, ...args) => {
    const id = realSetTimeout(() => {
      pendingTimers.delete(id);
      fn(...args);
    }, ms);
    pendingTimers.add(id);
    return id;
  };
  globalThis.clearTimeout = (id) => {
    pendingTimers.delete(id);
    realClearTimeout(id);
  };
  const settle = async () => {
    while (pendingTimers.size) await new Promise((r) => realSetTimeout(r, 2));
    await new Promise((r) => realSetTimeout(r, 0));
  };

  try {
    const value = await timed(Promise.resolve().then(fn).then(async (v) => (await settle(), v)));
    return { value, acc };
  } catch (e) {
    throw Object.assign(e, { __acc: acc });
  } finally {
    globalThis.setTimeout = savedSetTimeout;
    globalThis.clearTimeout = savedClearTimeout;
    globalThis.console = real;
    capture = previous;
  }
}

/*
 * Rewrites top-level declarations so they survive across separate evaluations.
 * Only lines at brace depth 0 are rewritten, so a `const` inside a block keeps its
 * normal semantics (reassigning it still throws). Braces inside strings are not
 * skipped, which is fine for lesson code.
 */
function transform(code) {
  const names = [];
  let depth = 0;
  const out = code.split("\n").map((line) => {
    const topLevel = depth === 0;
    for (const ch of line) {
      if ("{([".includes(ch)) depth++;
      else if ("})]".includes(ch)) depth = Math.max(0, depth - 1);
    }
    if (!topLevel) return line;
    const decl = /^(const|let|var)\s+([A-Za-z_$][\w$]*)/.exec(line);
    if (decl) {
      names.push(decl[2]);
      return line.replace(/^(const|let|var)\s+/, "var ");
    }
    const cls = /^class\s+([A-Za-z_$][\w$]*)/.exec(line);
    if (cls) {
      names.push(cls[1]);
      return line.replace(/^class\s+([A-Za-z_$][\w$]*)/, "var $1 = class $1");
    }
    return line;
  });
  return { src: out.join("\n"), names };
}

const hasAwait = (code) => /\bawait\b/.test(code);

function describeError(e) {
  const ename = e?.name ?? "Error";
  const evalue = e?.message ?? String(e);
  return { ename, evalue, line: null, file: null, traceback: `${ename}: ${evalue}` };
}

function notFinished() {
  return new Error(`Your code took longer than ${TIMEOUT_MS / 1000} seconds to finish. Check for an infinite loop, or a missing \`await\`.`);
}

/** Runs code in the shared scope (or its own async scope when it contains await). */
async function runShared(code) {
  if (hasAwait(code)) {
    const { acc } = await captured(() => new AsyncFunction(code)());
    return { value: undefined, acc };
  }
  const { src, names } = transform(code);
  const { value, acc } = await captured(() => (0, eval)(src));
  names.forEach((n) => declared.add(n));
  return { value, acc };
}

const variables = () =>
  [...declared].flatMap((name) => {
    if (!(name in globalThis)) return [];
    return [{ name, ...describe(globalThis[name]) }];
  });

const ok = (extra) => ({ ok: true, value: null, error: null, images: [], stdout: "", stderr: "", duration: 0, steps: null, truncatedSteps: false, ...extra });
const fail = (error, extra = {}) => ({ ok: false, value: null, error: describeError(error), images: [], stdout: "", stderr: "", duration: 0, steps: null, truncatedSteps: false, ...extra });

async function timed(promise) {
  let timer;
  const limit = new Promise((_, reject) => (timer = realSetTimeout(() => reject(notFinished()), TIMEOUT_MS)));
  try {
    return await Promise.race([promise, limit]);
  } finally {
    realClearTimeout(timer);
  }
}

/* ── Operations ────────────────────────────────────────────────── */

async function reset(setup) {
  for (const name of declared) delete globalThis[name];
  declared = new Set();
  for (const code of setup ?? []) {
    try {
      await runShared(code);
    } catch (e) {
      return { ...fail(e), vars: variables() };
    }
  }
  return { ok: true, error: null, vars: variables() };
}

async function run({ code, ns, setup }) {
  const started = performance.now();
  const finish = (res) => ({ ...res, duration: performance.now() - started });
  if (ns === "fresh") {
    const body = [...(setup ?? []), code].join("\n;\n");
    try {
      const { acc } = await captured(() => new AsyncFunction("assert", "assertEqual", body)(assert, assertEqual));
      return finish(ok({ stdout: acc.stdout, stderr: acc.stderr }));
    } catch (e) {
      return finish(fail(e, { stdout: e.__acc?.stdout ?? "", stderr: e.__acc?.stderr ?? "" }));
    }
  }
  try {
    const { value, acc } = await runShared(code);
    return finish(ok({ value: value === undefined ? null : describe(value), stdout: acc.stdout, stderr: acc.stderr, vars: variables() }));
  } catch (e) {
    return finish(fail(e, { stdout: e.__acc?.stdout ?? "", stderr: e.__acc?.stderr ?? "", vars: variables() }));
  }
}

async function check({ code, test, setup }) {
  const started = performance.now();
  const body = [...(setup ?? []), code, "const _stdout = __stdout();", test ?? ""].join("\n;\n");
  let acc = { stdout: "", stderr: "" };
  const base = { stdout: "", stderr: "", images: [], value: null };
  try {
    const { acc: got } = await captured(() => {
      const fn = new AsyncFunction("assert", "assertEqual", "__stdout", body);
      return fn(assert, assertEqual, () => (capture ? capture.stdout.trim() : ""));
    });
    acc = got;
    return { ...base, ok: true, passed: true, message: null, error: null, stdout: acc.stdout, stderr: acc.stderr, duration: performance.now() - started };
  } catch (e) {
    acc = e.__acc ?? acc;
    const out = { ...base, stdout: acc.stdout, stderr: acc.stderr, duration: performance.now() - started };
    if (e instanceof AssertionError) return { ...out, ok: true, passed: false, message: e.message, error: null };
    if (e?.name === "ReferenceError") {
      const name = /(\w+) is not defined/.exec(e.message)?.[1];
      return { ...out, ok: false, passed: false, error: describeError(e), message: name ? `Your code needs to define \`${name}\`.` : `ReferenceError: ${e.message}` };
    }
    return { ...out, ok: false, passed: false, error: describeError(e), message: null };
  }
}

function complete(expr) {
  const prefix = String(expr ?? "");
  const names = new Set([...declared, ...Object.getOwnPropertyNames(globalThis)]);
  const items = [...names]
    .filter((n) => n.startsWith(prefix) && IDENT.test(n))
    .slice(0, 50)
    .map((label) => ({ label, type: typeof globalThis[label] === "function" ? "function" : "value" }));
  return { items };
}

/* ── Errors that escape from timers and callbacks ─────────────── */

/*
 * An error thrown from a setTimeout or an event callback never reaches the
 * cell that scheduled it. Catch it here so it can't stop the worker or the
 * validator, show it in the output, and let callers ask for it afterwards.
 */
const stray = [];
function onStray(error) {
  const text = error?.message ?? String(error);
  stray.push({ ename: error?.name ?? "Error", evalue: text });
  emit("stderr", `Uncaught ${error?.name ?? "Error"}: ${text}\n`);
}
if (typeof process !== "undefined" && typeof process.on === "function") {
  process.on("uncaughtException", onStray);
  process.on("unhandledRejection", onStray);
} else if (typeof self !== "undefined" && typeof self.addEventListener === "function") {
  self.addEventListener("error", (e) => {
    e.preventDefault();
    onStray(e.error ?? new Error(e.message));
  });
  self.addEventListener("unhandledrejection", (e) => {
    e.preventDefault();
    onStray(e.reason);
  });
}

/** Returns and clears the uncaught errors seen since the last call. */
export function takeStray() {
  return stray.splice(0);
}

/* ── Entry point, identical in the browser worker and under Node ─── */

export function setEmit(fn) {
  emit = fn ?? (() => {});
}

export async function handle(requestJson) {
  const request = typeof requestJson === "string" ? JSON.parse(requestJson) : requestJson;
  switch (request.op) {
    case "reset":
      return reset(request.setup);
    case "run":
      return run(request);
    case "check":
      return check(request);
    case "vars":
      return { ok: true, vars: variables() };
    case "complete":
      return complete(request.expr);
    default:
      return fail(new Error(`unknown op ${JSON.stringify(request.op)}`));
  }
}
