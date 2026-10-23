// Runs Java lesson cells with a local JDK, using the same source wrappers
// and markers as the browser runtime (packages/shared/src/java-harness.ts).
// If javac is not installed the structural checks still run and execution is
// skipped, so CI without a JDK can validate the course.
//
//   JAVAC=/path/to/javac JAVA=/path/to/java node seed/courses/validate.mjs java-basics
import { spawnSync } from "node:child_process";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { javaClassOffset, javaClassTestSource, javaCompileError, javaMainCheckSource, javaMainRunSource, javaMarkers, javaPackagePrefix, javaRuntimeError } from "../../../../packages/shared/src/java-harness.ts";

const javac = process.env.JAVAC ?? "javac";
const java = process.env.JAVA ?? "java";
const enabled = spawnSync(javac, ["-version"], { encoding: "utf8" }).status === 0;

function run(cmd, args, cwd) {
  return spawnSync(cmd, args, { cwd, encoding: "utf8", timeout: 8000, maxBuffer: 8 * 1024 * 1024 });
}

let runDirSeq = 0;

function compileAndRun(files, pkg, mainClass, offset, codeLines, dir) {
  const work = join(dir, `run${runDirSeq++}`);
  mkdirSync(work, { recursive: true });
  for (const f of files) writeFileSync(join(work, f.name), f.source);
  const names = files.map((f) => f.name);
  const c = run(javac, ["--release", "8", "-d", work, "-Xlint:none", ...names], work);
  return { compile: c, pkg, mainClass, offset, codeLines, dir: work };
}

function execute(source, pkg, mainClass, offset, codeLines, dir) {
  const built = compileAndRun(source, pkg, mainClass, offset, codeLines, dir);
  if (built.compile.status !== 0) {
    return { ok: false, error: javaCompileError(`${built.compile.stdout}\n${built.compile.stderr}`, offset, codeLines), stdout: "", raw: "" };
  }
  const r = run(java, ["-cp", built.dir, `${pkg}.${mainClass}`], built.dir);
  const raw = `${r.stdout}${r.stderr}`;
  if (r.status !== 0) return { ok: false, error: javaRuntimeError(raw, offset, codeLines), stdout: "", raw };
  return { ok: true, error: null, stdout: raw.trimEnd(), raw };
}

const trim = (s) => s.replace(/\s+$/, "").trim();

export async function runJava(job) {
  if (!enabled) {
    return { results: job.lessons.map((l) => ({ file: l.file, findings: [{ cell: "—", ok: true, info: true, message: "javac not found; execution skipped" }] })) };
  }

  const dir = mkdtempSync(join(tmpdir(), "latent-java-"));
  const results = [];
  try {
    for (const lesson of job.lessons) {
      const findings = [];
      const add = (cell, ok, message, extra = {}) => findings.push({ cell, ok, message, ...extra });
      let n = 0;
      for (const c of lesson.cells) {
        const pkg = `latent${n++}`;
        if (c.language !== "java") {
          add(c.id, false, `Expected a Java cell, found ${c.language}`);
          continue;
        }
        if (c.kind === "setup") continue;

        if (c.kind === "run") {
          const isClass = c.body === "class";
          const source = isClass ? [{ name: "Main.java", source: `${javaPackagePrefix(pkg)}${c.code}\n` }] : [{ name: "Main.java", source: javaMainRunSource(pkg, c.code).source }];
          const offset = isClass ? javaClassOffset(pkg) : javaMainRunSource(pkg, c.code).offset;
          const r = execute(source, pkg, "Main", offset, c.code.split("\n").length, dir);
          if (c.expectError) add(c.id, !r.ok, r.ok ? "Marked `error` but ran without raising" : `Raises ${r.error?.ename} as intended`);
          else add(c.id, r.ok, r.ok ? "Runs cleanly" : `${r.error?.ename}: ${r.error?.evalue}`);
          continue;
        }

        if (c.kind === "exercise" || c.kind === "debug") {
          if (!c.test) {
            add(c.id, false, "Missing `--- test` section");
            continue;
          }
          if (!c.solution) {
            add(c.id, false, "Missing `--- solution` section");
            continue;
          }
          const check = (code, label) => {
            const isClass = c.body === "class";
            const snippet = isClass ? null : javaMainCheckSource(pkg, code, c.test);
            const files = isClass
              ? [
                  { name: "Main.java", source: `${javaPackagePrefix(pkg)}${code}\n` },
                  { name: "LatentTest.java", source: javaClassTestSource(pkg, c.test) },
                ]
              : [{ name: "Main.java", source: snippet.source }];
            const offset = isClass ? javaClassOffset(pkg) : snippet.offset;
            const r = execute(files, pkg, isClass ? "LatentTest" : "Main", offset, code.split("\n").length, dir);
            const markers = javaMarkers(r.raw);
            if (label === "solution") {
              add(c.id, markers.pass, markers.pass ? "Solution passes the tests" : `Solution fails: ${markers.message ?? r.error?.evalue ?? "no pass marker"}`);
            } else {
              add(c.id, !markers.pass, markers.pass ? "Starter code already passes; tighten the tests" : "Starter code fails, as it should");
            }
          };
          check(c.solution, "solution");
          check(c.code, "starter");
          continue;
        }

        if (c.kind === "predict") {
          const correct = c.options.filter((o) => o.correct);
          if (correct.length !== 1) {
            add(c.id, false, "Mark exactly one option with `* `");
            continue;
          }
          const isClass = c.body === "class";
          const source = isClass ? [{ name: "Main.java", source: `${javaPackagePrefix(pkg)}${c.code}\n` }] : [{ name: "Main.java", source: javaMainRunSource(pkg, c.code).source }];
          const offset = isClass ? javaClassOffset(pkg) : javaMainRunSource(pkg, c.code).offset;
          const r = execute(source, pkg, "Main", offset, c.code.split("\n").length, dir);
          const actual = trim(r.stdout);
          const expected = trim(correct[0].text);
          add(c.id, r.ok && actual === expected, r.ok ? (actual === expected ? "Correct option matches the real output" : `Real output is "${actual}"`) : `${r.error?.ename}: ${r.error?.evalue}`);
        }
      }
      results.push({ file: lesson.file, findings });
    }
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
  return { results };
}
