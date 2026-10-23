/* ────────────────────────────────────────────────────────────
 * Interactive lessons
 *
 * An interactive lesson is Markdown with executable cells, written as
 * fenced blocks whose info string names the language and cell kind:
 *
 *   ```python run                       runnable example (shared kernel)
 *   ```java run                         runnable Java snippet or program
 *   ```java run error                   example that raises on purpose
 *   ```python setup                     hidden code run before cells/challenges
 *   ```java exercise id=x title="…"     coding challenge checked by tests
 *   ```java debug id=x title="…"        buggy code the learner must fix
 *   ```java predict id=x title="…"      predict-the-output question
 *
 * Inside a cell, lines like `--- solution` start a section:
 *   solution · test · hint (repeatable) · options · explain
 * Text before the first section is the cell's starting code.
 * In `options`, prefix the correct line with `* `.
 *
 * Java cells run as snippets inside `main` by default. Add the `class` flag
 * (```java run class) when the cell is a complete source file instead.
 *
 * JavaScript cells use the fence `js` (or `javascript`) with the same kinds:
 * ```js run, ```js exercise id=x title="…", and so on.
 *
 * HTML cells (```html run) render in a sandboxed preview. Challenges are
 * checked with JavaScript DOM/CSS assertions (see html-harness.ts).
 *
 * C cells (```c predict) are predict-the-output questions only. There is no
 * C runtime in the browser, so the answer is revealed from `--- explain`.
 *
 * Dependency-free so the API, the web app and Node seed scripts
 * (via type stripping) can all import it.
 * ──────────────────────────────────────────────────────────── */

export const CELL_KINDS = ["run", "setup", "exercise", "debug", "predict"] as const;
export type CellKind = (typeof CELL_KINDS)[number];

export const CELL_LANGUAGES = ["python", "java", "javascript", "c", "html"] as const;
export type CellLanguage = (typeof CELL_LANGUAGES)[number];
export type JavaBody = "main" | "class";

/** Cell kinds that count toward lesson completion. */
export const CHALLENGE_KINDS: readonly CellKind[] = ["exercise", "debug"];

export interface PredictOption {
  text: string;
  correct: boolean;
}

export interface LessonCell {
  id: string;
  kind: CellKind;
  language: CellLanguage;
  title: string | null;
  /** Java cells: snippet inside `main`, or a complete source file. */
  body: JavaBody;
  /** Starter code (exercise), buggy code (debug) or example code. */
  code: string;
  /** `null` when stripped for learners; check `hasSolution`. */
  solution: string | null;
  hasSolution: boolean;
  test: string | null;
  hints: string[];
  options: PredictOption[];
  explain: string | null;
  /** `run` cell that raises on purpose. */
  expectError: boolean;
}

export type LessonBlock = { type: "markdown"; text: string } | { type: "cell"; cell: LessonCell };

const FENCE_OPEN = /^```(python|java|javascript|js|c|html)[ \t]+(run|setup|exercise|debug|predict)\b(.*)$/;
const FENCE_CLOSE = /^```\s*$/;
const SECTION = /^---[ \t]+(solution|test|hint|options|explain)[ \t]*$/;

function parseAttrs(s: string) {
  const attrs: Record<string, string> = {};
  const flags = new Set<string>();
  for (const m of s.matchAll(/([a-z][\w-]*)(?:=(?:"([^"]*)"|(\S+)))?/gi)) {
    if (m[2] !== undefined || m[3] !== undefined) attrs[m[1]!.toLowerCase()] = m[2] ?? m[3]!;
    else flags.add(m[1]!.toLowerCase());
  }
  return { attrs, flags };
}

const trimBlock = (lines: string[]) => lines.join("\n").replace(/^\n+|\s+$/g, "");

function buildCell(language: CellLanguage, kind: CellKind, info: string, body: string[], index: number): LessonCell {
  const { attrs, flags } = parseAttrs(info);
  const parts: { name: string; lines: string[] }[] = [{ name: "code", lines: [] }];
  for (const line of body) {
    const s = SECTION.exec(line);
    if (s) parts.push({ name: s[1]!, lines: [] });
    else parts[parts.length - 1]!.lines.push(line);
  }
  const get = (name: string) => parts.find((p) => p.name === name);
  const solution = get("solution");
  const options = get("options");
  return {
    id: attrs.id ?? `${kind}-${index + 1}`,
    kind,
    language,
    body: language === "java" && flags.has("class") ? "class" : "main",
    title: attrs.title ?? null,
    code: trimBlock(parts[0]!.lines),
    solution: solution ? trimBlock(solution.lines) || null : null,
    hasSolution: !!solution,
    test: get("test") ? trimBlock(get("test")!.lines) || null : null,
    hints: parts.filter((p) => p.name === "hint").map((p) => trimBlock(p.lines)).filter(Boolean),
    options: options
      ? options.lines
      .map((l) => l.trim())
      .filter(Boolean)
      .map((l) => (l.startsWith("* ") ? { text: l.slice(2).trim(), correct: true } : { text: l, correct: false }))
      : [],
    explain: get("explain") ? trimBlock(get("explain")!.lines) || null : null,
    expectError: flags.has("error"),
  };
}

/** Splits interactive lesson Markdown into prose and executable cells. */
export function parseLesson(content: string): LessonBlock[] {
  const lines = content.replace(/\r\n?/g, "\n").split("\n");
  const blocks: LessonBlock[] = [];
  let prose: string[] = [];
  let inOtherFence = false;
  let cellIndex = 0;
  const flushProse = () => {
    const text = prose.join("\n").trim();
    if (text) blocks.push({ type: "markdown", text });
    prose = [];
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!;
    const open = !inOtherFence ? FENCE_OPEN.exec(line) : null;
    if (open) {
      const body: string[] = [];
      let j = i + 1;
      while (j < lines.length && !FENCE_CLOSE.test(lines[j]!)) body.push(lines[j++]!);
      flushProse();
      const language = open[1] === "js" ? "javascript" : (open[1] as CellLanguage);
      blocks.push({ type: "cell", cell: buildCell(language, open[2] as CellKind, open[3] ?? "", body, cellIndex++) });
      i = j;
      continue;
    }
    if (/^\s*(```|~~~)/.test(line)) inOtherFence = !inOtherFence;
    prose.push(line);
  }
  flushProse();
  return blocks;
}

export const lessonCells = (content: string) => parseLesson(content).flatMap((b) => (b.type === "cell" ? [b.cell] : []));

export const challengeIds = (content: string) => lessonCells(content).filter((c) => CHALLENGE_KINDS.includes(c.kind)).map((c) => c.id);

/**
 * Removes solution bodies (keeping the `--- solution` marker so the
 * client knows one exists). Learners fetch solutions on demand.
 */
export function stripSolutions(content: string): string {
  const lines = content.replace(/\r\n?/g, "\n").split("\n");
  const out: string[] = [];
  let inCell = false;
  let inSolution = false;
  for (const line of lines) {
    if (!inCell) {
      if (FENCE_OPEN.test(line)) inCell = true;
      out.push(line);
      continue;
    }
    if (FENCE_CLOSE.test(line)) {
      inCell = inSolution = false;
      out.push(line);
      continue;
    }
    const s = SECTION.exec(line);
    if (s) {
      inSolution = s[1] === "solution";
      out.push(line);
      continue;
    }
    if (!inSolution) out.push(line);
  }
  return out.join("\n");
}

export function findCell(content: string, cellId: string): LessonCell | null {
  return lessonCells(content).find((c) => c.id === cellId) ?? null;
}
