// Runs JavaScript lesson cells with the browser kernel (apps/web/public/runtime/js-kernel.mjs)
// under Node. Mirrors validate_runner.py: same job shape, same findings, same checks.
//
// Job:    { kernel: "<dir containing js-kernel.mjs>", lessons: [{ file, cells: [...] }] }
// Result: { results: [{ file, findings: [{ cell, ok, message, warn?, info? }] }] }
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const SLOW_MS = 1500;

const errorText = (r) => {
  const e = r.error ?? {};
  return `${e.ename}: ${e.evalue}`;
};

// Predict cells compare trimmed console output line by line, like the browser does.
const outputOf = (r) =>
  r.stdout
    .split("\n")
    .map((line) => line.trimEnd())
    .join("\n")
    .trim();

export async function runJavaScript(job) {
  const kernel = await import(pathToFileURL(join(job.kernel, "js-kernel.mjs")).href);
  const results = [];

  for (const lesson of job.lessons) {
    const findings = [];
    const add = (cell, ok, message, extra = {}) => findings.push({ cell, ok, message, ...extra });
    const cells = lesson.cells;
    const setup = cells.filter((c) => c.kind === "setup").map((c) => c.code);

    kernel.takeStray();
    const reset = await kernel.handle({ op: "reset", setup: [] });
    let setupOk = true;
    for (const code of setup) {
      const r = await kernel.handle({ op: "run", code });
      if (!r.ok) {
        add("setup", false, `setup failed: ${r.error.traceback}`);
        setupOk = false;
        break;
      }
    }
    if (!reset.ok || !setupOk) {
      results.push({ file: lesson.file, findings });
      continue;
    }

    for (const c of cells) {
      const cid = c.id;
      const t0 = performance.now();
      if (c.kind === "run") {
        const r = await kernel.handle({ op: "run", code: c.code });
        if (c.expectError) add(cid, !r.ok, r.ok ? "marked `error` but ran cleanly" : "raises as intended");
        else add(cid, r.ok, r.ok ? "runs" : errorText(r));
        if (r.ok && !c.expectError && !(outputOf(r) || r.value)) {
          findings.push({ cell: cid, ok: true, warn: true, message: "run cell produces no visible output; end with an expression or console.log()" });
        }
      } else if (c.kind === "exercise" || c.kind === "debug") {
        const s = await kernel.handle({ op: "check", code: c.solution ?? "", test: c.test, setup });
        add(cid, !!s.passed, s.passed ? "solution passes" : `solution FAILS: ${s.message ?? errorText(s)}`);
        const st = await kernel.handle({ op: "check", code: c.code, test: c.test, setup });
        add(cid, !st.passed, st.passed ? "starter code already PASSES the tests" : "starter fails as expected");
        if (!st.passed) findings.push({ cell: cid, ok: true, info: true, message: `starter feedback: ${st.message ?? errorText(st)}` });
      } else if (c.kind === "predict") {
        const correct = c.options.filter((o) => o.correct);
        const r = await kernel.handle({ op: "run", ns: "fresh", code: c.code, setup });
        const actual = outputOf(r);
        if (!r.ok) add(cid, false, errorText(r));
        else if (correct.length !== 1) add(cid, false, "needs exactly one `* ` option");
        else {
          const ok = actual === correct[0].text.trim();
          add(cid, ok, ok ? "correct option matches output" : `actual output ${JSON.stringify(actual)} != marked option ${JSON.stringify(correct[0].text)}`);
          const dupes = c.options.filter((o) => !o.correct && o.text.trim() === actual);
          if (dupes.length) add(cid, false, "a wrong option also equals the real output");
        }
      }
      for (const e of kernel.takeStray()) add(cid, false, `uncaught ${e.ename}: ${e.evalue} (thrown from a timer or callback)`);
      const ms = performance.now() - t0;
      if (ms > SLOW_MS) add(cid, false, `slow: ${ms.toFixed(0)} ms (keep cells snappy in the browser)`);
    }
    results.push({ file: lesson.file, findings });
  }
  return { results };
}
