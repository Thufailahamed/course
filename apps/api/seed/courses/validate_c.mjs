// Runs every C cell through the same Clang 22 toolchain the browser uses (@live-codes/clang-wasm),
// with programs built by the same code the browser uses (packages/shared/src/c-harness.ts).
//   predict    the marked option must equal what the program prints, or say "compile error" when it does not compile
//   run        compiles and runs (must fail on purpose when marked `error`)
//   exercise   the starter must fail its tests and the solution must pass them
//   debug      the buggy code must fail its tests and the fix must pass them
import { createCompiler } from "@live-codes/clang-wasm";
import { cProgram } from "../../../../packages/shared/src/c-harness.ts";

const passes = (run) => run.exitCode === 0;

export async function runC(job) {
  const compiler = await createCompiler("c");
  // A thrown error means the program ran and trapped: a crash, which the browser reports the same way.
  const compile = async (source) => {
    try {
      return await compiler.run(source, "");
    } catch (err) {
      return { exitCode: 1, stdout: "", stderr: `The program crashed: ${err.message}`, errors: [], crashed: true };
    }
  };
  const results = [];

  for (const l of job.lessons) {
    const findings = [];
    const setup = l.cells.filter((c) => c.kind === "setup").map((c) => c.code);

    for (const c of l.cells) {
      if (c.kind === "setup") continue;

      if (c.kind === "predict") {
        const correct = c.options.find((o) => o.correct);
        if (!correct) {
          findings.push({ cell: c.id, ok: false, message: "no correct option marked" });
          continue;
        }
        const run = await compile(cProgram(setup, c.code).source);
        const compiled = run.exitCode !== null;
        const actual = run.stdout.replace(/\s+$/, "");
        let ok;
        let message;
        if (/compile error/i.test(correct.text)) {
          ok = !compiled;
          message = compiled ? `expected a compile error but it compiled; printed ${JSON.stringify(actual)}` : "compile error as predicted";
        } else if (!compiled) {
          ok = false;
          message = `does not compile: ${run.errors.find((e) => /error/.test(e)) ?? run.errors[0] ?? "unknown error"}`;
        } else {
          ok = actual === correct.text.trim();
          message = ok ? "output matches" : `marked ${JSON.stringify(correct.text)} but the program prints ${JSON.stringify(actual)}`;
        }
        findings.push({ cell: c.id, ok, message, info: ok });
        continue;
      }

      if (c.kind === "run") {
        const run = await compile(cProgram(setup, c.code).source);
        const compiled = run.exitCode !== null;
        const ok = c.expectError ? !compiled || !passes(run) : compiled && passes(run);
        findings.push({ cell: c.id, ok, message: ok ? "runs as expected" : `does not run as expected: ${run.errors[0] ?? `exit status ${run.exitCode}`}`, info: ok });
        continue;
      }

      if (c.kind === "exercise" || c.kind === "debug") {
        if (!c.test || !c.solution) {
          findings.push({ cell: c.id, ok: false, message: "challenge needs a test and a solution" });
          continue;
        }
        const starter = await compile(cProgram(setup, c.code, c.test).source);
        const fix = await compile(cProgram(setup, c.solution, c.test).source);
        const starterFails = !(starter.exitCode !== null && passes(starter));
        const solutionPasses = fix.exitCode !== null && passes(fix);
        const ok = starterFails && solutionPasses;
        const message = ok
          ? "starter fails and solution passes"
          : !solutionPasses
            ? `solution fails: ${fix.errors[0] ?? fix.stderr.trim().split("\n")[0] ?? `exit status ${fix.exitCode}`}`
            : "starter already passes its tests";
        findings.push({ cell: c.id, ok, message, info: ok });
      }
    }
    results.push({ file: l.file, findings });
  }
  return { results };
}
