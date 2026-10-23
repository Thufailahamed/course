// Validates an interactive course: structure, quizzes, and every cell executed
// with the browser kernel (apps/web/public/runtime/kernel.py) under CPython.
//
//   node seed/courses/validate.mjs numpy [lesson-file-filter] [--verbose] [--cpython]
//
// By default cells run inside Pyodide, the exact runtime learners get (wasm32:
// default int is int32, no floating-point warnings). --cpython runs them with
// $PYTHON instead, which is faster but only approximates the browser.
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { lessonCells } from "../../../../packages/shared/src/interactive.ts";
import { runJavaScript } from "./validate_js.mjs";
import { runJava } from "./validate_java.mjs";
import { runC } from "./validate_c.mjs";
import { runHtml } from "./validate_html.mjs";

const here = dirname(fileURLToPath(import.meta.url));
const args = process.argv.slice(2);
const verbose = args.includes("--verbose");
const useCpython = args.includes("--cpython");
const [courseDir = "numpy", filter] = args.filter((a) => !a.startsWith("--"));
const root = join(here, courseDir);
const { sections, course } = await import(`./${courseDir}/course.mjs`);
const isJavaScript = course?.codeLanguage === "javascript";
const isJava = course?.codeLanguage === "java";
const isC = course?.codeLanguage === "c";
const isHtml = course?.codeLanguage === "html";
const expectedLanguage = isJava ? "java" : isJavaScript ? "javascript" : isC ? "c" : isHtml ? "html" : "python";
const kernelDir = resolve(here, "../../../web/public/runtime");

const problems = [];
const warn = [];
const lessons = [];
let challenges = 0;
let predicts = 0;
let runCells = 0;

for (const section of sections) {
  for (const l of section.lessons) {
    if (filter && !(l.quiz ?? l.file).includes(filter)) continue;
    if (l.quiz) {
      const path = join(root, "quizzes", l.quiz);
      if (!existsSync(path)) {
        problems.push(`${l.quiz}: missing quiz file`);
        continue;
      }
      let qs;
      try {
        qs = JSON.parse(readFileSync(path, "utf8"));
      } catch (e) {
        problems.push(`${l.quiz}: invalid JSON (${e.message})`);
        continue;
      }
      if (!Array.isArray(qs) || qs.length < 4) problems.push(`${l.quiz}: needs at least 4 questions`);
      qs.forEach((q, i) => {
        if (!q.prompt || !Array.isArray(q.options) || q.options.length < 3 || q.options.length > 6) problems.push(`${l.quiz} #${i + 1}: needs a prompt and 3–6 options`);
        if (!(Number.isInteger(q.answerIndex) && q.answerIndex >= 0 && q.answerIndex < q.options.length)) problems.push(`${l.quiz} #${i + 1}: bad answerIndex`);
        if (!q.explanation) problems.push(`${l.quiz} #${i + 1}: missing explanation`);
        if (new Set(q.options).size !== q.options.length) problems.push(`${l.quiz} #${i + 1}: duplicate options`);
      });
      continue;
    }
    const path = join(root, "lessons", l.file);
    if (!existsSync(path)) {
      problems.push(`${l.file}: missing lesson file`);
      continue;
    }
    const md = readFileSync(path, "utf8");
    const cells = lessonCells(md);
    const ids = new Set();
    for (const c of cells) {
      if (ids.has(c.id)) problems.push(`${l.file} ${c.id}: duplicate id`);
      ids.add(c.id);
      if (c.kind === "exercise" || c.kind === "debug") {
        challenges++;
        if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(c.id) || c.id.startsWith(c.kind + "-")) problems.push(`${l.file} ${c.id}: challenges need an explicit kebab-case id=`);
        if (!c.title) problems.push(`${l.file} ${c.id}: missing title=`);
        if (!c.test) problems.push(`${l.file} ${c.id}: missing --- test`);
        if (!c.solution) problems.push(`${l.file} ${c.id}: missing --- solution`);
        if (!c.hints.length) problems.push(`${l.file} ${c.id}: add at least one --- hint`);
      }
      if (c.kind === "predict") {
        predicts++;
        if (c.options.length < 3) problems.push(`${l.file} ${c.id}: predict needs 3–4 options`);
        if (!c.explain) problems.push(`${l.file} ${c.id}: predict needs --- explain`);
      }
      if (c.kind === "run") runCells++;
      if (c.language !== expectedLanguage) problems.push(`${l.file} ${c.id}: ${c.language} cell in a ${expectedLanguage} lesson`);
      const lines = c.code.split("\n").length;
      if (lines > 40) warn.push(`${l.file} ${c.id}: ${lines} lines; consider splitting`);
    }
    const n = (k) => cells.filter((c) => c.kind === k).length;
    if (isC) {
      if (l.file !== "01-welcome.md" && n("predict") < 3) problems.push(`${l.file}: C lessons need at least 3 predict questions (has ${n("predict")})`);
    } else if (l.file !== "01-welcome.md") {
      if (n("exercise") + n("debug") < 3) problems.push(`${l.file}: needs at least 3 challenges (has ${n("exercise") + n("debug")})`);
      if (n("debug") < 1) problems.push(`${l.file}: needs at least 1 debug challenge`);
      if (n("predict") < 1) problems.push(`${l.file}: needs at least 1 predict cell`);
      if (n("run") < 4) problems.push(`${l.file}: needs at least 4 runnable examples (has ${n("run")})`);
    }
    if (/```(python|js|javascript|java|html) (run|exercise|debug|predict|setup)[^\n]*\n(?:(?!```)[\s\S])*$/.test(md)) problems.push(`${l.file}: unclosed cell fence`);
    if (md.length > 95000) problems.push(`${l.file}: content exceeds 95k characters`);
    lessons.push({ file: l.file, cells });
  }
}

async function runInPyodide(job) {
  const { loadPyodide } = await import("pyodide");
  const py = await loadPyodide({ packageCacheDir: join(here, "../../node_modules/.cache/pyodide"), stdout: () => {}, stderr: () => {} });
  await py.loadPackage("numpy", { messageCallback: () => {} });
  const code = job.lessons.flatMap((l) => l.cells.flatMap((c) => [c.code, c.solution ?? "", c.test ?? ""])).join("\n");
  await py.loadPackagesFromImports(code, { messageCallback: () => {} });
  py.FS.mkdirTree("/home/pyodide/validator");
  py.FS.writeFile("/home/pyodide/validator/kernel.py", readFileSync(join(kernelDir, "kernel.py"), "utf8"));
  py.FS.writeFile("/home/pyodide/validator/validate_runner.py", readFileSync(join(here, "validate_runner.py"), "utf8"));
  py.globals.set("JOB", JSON.stringify({ ...job, kernel: "/home/pyodide/validator" }));
  return JSON.parse(py.runPython("import sys, json; sys.path.insert(0, '/home/pyodide/validator'); import validate_runner; json.dumps(validate_runner.run_job(json.loads(JOB)))"));
}

function runInCpython(job) {
  const proc = spawnSync(process.env.PYTHON ?? "python", [join(here, "validate_runner.py")], { input: JSON.stringify(job), encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });
  if (proc.status !== 0) {
    console.error(proc.stderr || proc.error);
    process.exit(2);
  }
  return JSON.parse(proc.stdout);
}

const job = { kernel: kernelDir, lessons };
const { results } = isHtml
  ? await runHtml(job)
  : isC
    ? await runC(job)
    : isJava ? await runJava(job) : isJavaScript ? await runJavaScript({ ...job, kernel: kernelDir }) : useCpython ? runInCpython(job) : await runInPyodide(job);
for (const r of results) {
  const bad = r.findings.filter((f) => !f.ok);
  for (const f of r.findings) {
    if (!f.ok) problems.push(`${r.file} ${f.cell}: ${f.message}`);
    else if (f.warn) warn.push(`${r.file} ${f.cell}: ${f.message}`);
    else if (verbose && f.info) console.log(`  ${r.file} ${f.cell}: ${f.message}`);
  }
  console.log(`${bad.length ? "✗" : "✓"} ${r.file}  (${r.findings.filter((f) => !f.info && !f.warn).length} checks${bad.length ? `, ${bad.length} failed` : ""})`);
}

console.log(`\n${lessons.length} lessons · ${runCells} runnable cells · ${challenges} challenges · ${predicts} predict questions`);
if (warn.length) console.log(`\nWarnings:\n  ${warn.join("\n  ")}`);
if (problems.length) {
  console.log(`\nProblems (${problems.length}):\n  ${problems.join("\n  ")}`);
  process.exit(1);
}
console.log("\nAll checks passed.");
