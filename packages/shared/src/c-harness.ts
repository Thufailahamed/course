/* ────────────────────────────────────────────────────────────
 * C program construction for interactive lessons.
 *
 * The browser runtime (apps/web/src/components/code/c-runtime.ts) and the Node
 * validator (apps/api/seed/courses/validate_c.mjs) both build programs here, so
 * a challenge that passes in the validator passes for learners too.
 *
 *   run cell        the cell's code, after any hidden setup cells, as a complete program
 *   challenge       the same, plus a generated `main` that runs the cell's test section
 *
 * Challenge tests are C statements. Use `CHECK(condition, "message")`: a failed
 * check prints its message and exits with status 1, so the learner sees the reason.
 * (`assert` is not used because a failed assert traps in WebAssembly and drops its output.)
 * Learners' code must not define `main` in challenges.
 * ──────────────────────────────────────────────────────────── */

export const C_TEST_HEADER = [
  "#include <stdio.h>",
  "#include <stdlib.h>",
  "#include <string.h>",
  "#define CHECK(condition, message) do { if (!(condition)) { printf(\"FAILED: %s\\n\", message); exit(1); } } while (0)",
  "",
].join("\n");

export interface CProgram {
  /** Full source handed to the compiler. */
  source: string;
  /** 1-based line in `source` where the cell's own code starts. */
  codeLine: number;
}

export function cProgram(setup: string[], code: string, test: string | null = null): CProgram {
  const head = (test === null ? "" : C_TEST_HEADER) + setup.map((s) => `${s}\n`).join("");
  const body = `${code}\n`;
  const tail = test === null ? "" : `\nint main(void) {\n${test}\nreturn 0;\n}\n`;
  const newlines = (head.match(/\n/g) ?? []).length;
  return { source: head + body + tail, codeLine: newlines + 1 };
}
