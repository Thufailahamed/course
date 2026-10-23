# Authoring interactive courses

Interactive lessons are Markdown files with live code cells. Python runs in the browser on Pyodide (Python 3.14, NumPy 2.4); JavaScript runs natively; Java and C run in WebAssembly toolchains; HTML & CSS renders in a sandboxed live preview. The seed validator executes each cell with the same engine learners get (including `apps/web/public/runtime/kernel.py` for Python), so a lesson that validates here behaves identically in the browser.

```
seed/courses/<course>/course.mjs        metadata + outline (sections → lesson files / quiz files)
seed/courses/<course>/lessons/NN-*.md   lesson bodies
seed/courses/<course>/quizzes/sN.json   [{ prompt, options[], answerIndex, explanation }]
```

Validate before seeding (use an interpreter with the NumPy version Pyodide ships):

```
PYTHON=/path/to/python node seed/courses/validate.mjs numpy [file-filter] [--verbose]
```

## Cell syntax

| Fence | Meaning |
|---|---|
| ` ```python run ` | Example. Runs in the lesson's shared kernel, in order, like a notebook. |
| ` ```python run error ` | Example that raises on purpose (shown with a badge). |
| ` ```python setup ` | Hidden setup, run before the kernel starts and before every challenge/predict. |
| ` ```python exercise id=… title="…" ` | Coding challenge with hidden tests. |
| ` ```python debug id=… title="…" ` | Buggy code the learner must fix; checked by tests. |
| ` ```python predict id=… title="…" ` | Multiple-choice "what does this output?" question. |

Inside a cell, lines `--- solution`, `--- test`, `--- hint` (repeatable), `--- options` and `--- explain` start sections. The text before the first section is the starting code. A plain ` ```python ` fence (no kind) is a static, non-runnable snippet.

**Semantics**

- Every namespace starts with `import numpy as np` plus all setup cells.
- Challenges and predicts run in a **fresh** namespace: setup → learner code → tests. They cannot see variables from example cells, so the starter code must define everything it needs (or rely on setup).
- Tests are Python statements, usually `assert cond, "message"`. The first failing assert's message is shown to the learner. `_stdout` holds everything the learner's code printed.
- A `NameError` inside tests is reported as "Your code needs to define `x`."
- Predict: the **correct option must equal the real output exactly** (stdout, stripped, then the repr of the last expression if any). Each option is one line, so predicted outputs must be single-line. Prefix the correct option with `* `.

## Browser runtime facts

The validator runs cells inside Pyodide, so these hold in validation too:

- **wasm32:** the default integer (`np.array([1]).dtype`, `np.arange`, `np.intp`, index results) is **int32**, not int64. Integer sums overflow silently at scale (`np.arange(100_000).sum()` wraps). Never hard-code `int64` for default ints; pass `dtype=` when it matters, and test with `np.issubdtype(x.dtype, np.integer)`.
- **No floating-point warnings:** division by zero, invalid operations and float overflow produce `inf`/`nan` silently, and `np.errstate(...="raise")` does not raise. Integer *scalar* overflow and "Mean of empty slice" still warn.
- Speed is roughly 2–5× slower than desktop CPython; the 1500 ms slow-cell limit is measured in Pyodide.

## Simulated keyboard (`input()`)

The browser can't pause for typing, so a raw `input()` call would hang. Lessons that use `input()` (Python Basics 08 and 29) shadow it with a hidden setup cell that reads answers queued by `type_answers("Ada", "36")`, echoing each prompt and answer like a terminal would. Copy that setup cell verbatim into any new lesson that needs input, and explain it once in the prose. Because setup also runs before every challenge, tests can call `type_answers(...)` again before re-running a learner's function on fresh input. When the queue is empty, `input()` raises `EOFError` with a hint, and the error card shows a matching tip.

## Quality bar (enforced by the validator where possible)

Each regular lesson has: ≥ 4 runnable examples, ≥ 3 challenges, of which ≥ 1 is a debug challenge, and ≥ 1 predict cell. Every challenge has an id, a title, a solution, tests and at least one hint. Solutions must pass; starter code must fail.

**Lesson shape**

1. A 1–2 paragraph hook: why this matters in real work, and what you'll be able to do.
2. Concept sections (`##`), each with a short explanation followed immediately by a small runnable example. Intuition first, then precise rules.
3. Challenges interleaved where the concept was just taught. Don't save them all for the end.
4. Callouts as blockquotes: `> **Tip:**`, `> **Pitfall:**`, `> **Under the hood:**`, `> **In the wild:**` (how this shows up in pandas, scikit-learn or PyTorch).
5. `## Recap` with 4–6 bullets, then a single `**Up next:**` line.

**Voice.** Warm, precise and expert. Second person, short paragraphs, no filler ("In this lesson we will…"). Explain *why*, not just *what*. Use tables for comparisons and KaTeX (`$…$`) where math genuinely helps.

**Cells**

- Short and focused: aim for ≤ 15 lines and never more than 40. One idea per cell.
- Deterministic: seed randomness (`np.random.default_rng(0)`). Keep each cell well under a second; Pyodide is 2–5× slower than CPython.
- Make output self-explanatory: label prints (`print("shape:", a.shape)`) or end with an expression.
- No network, no `input()`, no threads, no real files (use `io.StringIO` / `io.BytesIO`; the virtual filesystem is fine for `np.save`).
- matplotlib is available (`import matplotlib.pyplot as plt` … `plt.show()`). Use it sparingly, where a picture teaches.

**Challenges**

- Starter code uses `...` placeholders and `# TODO` comments, and makes the goal unambiguous: name the variables to define and what they should hold.
- The first test asserts usually catch untouched placeholders: `assert result is not ..., "Replace the ... with your code"`.
- Test behavior, not one specific implementation: check type, shape, dtype and values (`np.allclose`, `np.array_equal`). Accept every reasonable correct solution.
- Prevent hard-coding where it matters: recompute the expected value from inputs, or check against a second input inside the test (for example, call the learner's function on fresh data).
- Failure messages must help without giving the answer away: "`result` should have shape (3, 4) but has (4, 3)".
- Hints progress from a conceptual nudge, to the relevant function, to an almost-answer. Never paste the full solution in a hint.
- Debug challenges contain one or two *realistic* bugs that NumPy users actually hit: an accidental view, the wrong axis, an integer dtype truncating, broadcasting a `(n,)` against `(n, 1)`, `and` vs `&`, an off-by-one slice, in-place operations on a shared array, or `==` on floats. The buggy code should run, or fail with a believable error, and its symptom should be discoverable with Run or Debug. The fix should be small.

# Java courses

Java courses use the same file layout and cell kinds, with the fence language `java`. Lessons use one language throughout. The browser runs a real OpenJDK 8 compiler and JVM through CheerpJ, so the first cell in a session may take a few seconds to boot.

```
```java run                          snippet, wrapped in public class Main { public static void main ... }
```java run class                    complete source file (must declare public class Main)
```java exercise id=� title="�"      snippet challenge, tests appended to main
```java exercise class id=� title="�" complete-source challenge, tests in a generated LatentTest
```java debug id=� title="�"         buggy code the learner must fix
```java predict id=� title="�"       one-line output question
```

Order matters in the info string: the kind comes first, then the `class` flag. Inside a cell, `--- solution`, `--- test`, `--- hint`, `--- options` and `--- explain` work as in Python.

**Snippet vs class mode**

- A plain `run` / `exercise` / `debug` / `predict` cell is a **snippet**: statements only, not method or class declarations. Use it for the first two sections.
- Add `class` when the cell must declare methods, fields, constructors or several classes. Write a complete `public class Main`; the runtime supplies the `package` line.
- Every generated file auto-imports `java.util.*`, `java.io.*`, `java.nio.file.*`, `java.math.*` and `java.time.*`. Do not write a `package` declaration.
- The runtime is **Java 8**. Avoid `var`, `List.of`, `Map.of`, text blocks, switch expressions and `String.isBlank` / `String.repeat`.

**Tests**

Snippet tests run in the same `main`, so they can read learner variables directly. Class tests run in `LatentTest`; call static members as `Main.method(...)`, instantiate classes directly, and call `__runMain()` when the test needs to execute `Main.main` and inspect its output. Helpers:

- `__check(boolean condition, String message)` � fail the test with a readable message.
- `__out()` � captured stdout, with CRLF normalised to LF.
- `__runMain()` � class mode only: reset the capture buffer and invoke `Main.main` by reflection.

Tests must not print. Compare output with `__out().trim()` and put expected strings on one line with `\n` escapes. Predict options are single-line, so the predicted program must print one line; if the natural output has several lines, join them with a separator in the program.

**Validation**

```
JAVAC=/path/to/javac JAVA=/path/to/java node seed/courses/validate.mjs java-basics
```

The validator compiles with `--release 8` and runs every solution, starter, predict and run cell. Without `javac` it still performs the structural checks but skips execution. Java has no interrupt/step API in the browser, so Java lessons hide Stop, Restart, variables and the debugger.

# JavaScript courses

JavaScript courses use the same file layout and the same cell kinds, with the fence language `js` instead of `python`. Use one language per lesson. Cells run in the browser's own JavaScript engine inside a Web Worker (no Pyodide, no install), and `node seed/courses/validate.mjs <course>` checks them with the same kernel (`apps/web/public/runtime/js-kernel.mjs`).

```
```js run                                   example, shared with the lesson's other run cells
```js setup                                 hidden, runs before every cell and challenge
```js exercise id=… title="…"               coding challenge checked by tests
```js debug id=… title="…"                  buggy code the learner must fix
```js predict id=… title="…"                "what does this print?" (exact console output)
```

Sections inside a cell (`--- solution`, `--- test`, `--- hint`, `--- options`, `--- explain`) work exactly as in Python. Mark the correct predict option with `* `.

**Semantics**

- **Shared scope.** Run cells share one global scope, like a notebook. The runtime keeps top-level `const`, `let` and `class` declarations alive across cells, so a later cell can use them. Write declarations at column 0 (the runtime rewrites them to `var` internally). Don't put them inside a template literal or inside a multi-line string.
- **`await` in run cells.** A cell that contains `await` runs in its own async scope. Its declarations are local to that cell, so use `globalThis.name = …` if a later cell needs the value. Prefer `setup` cells for shared async state.
- **Run output.** Each `console.log` line is streamed. The cell's value is the completion value of its last expression, shown as a repr (for example `[ 1, 2, 3 ]` or `'hi'`), so end cells with an expression when it helps.
- **Challenges** run in a fresh scope: setup → learner code → tests. Tests can call `assert(condition, "message")`, `assertEqual(actual, expected, "message")` (deep structural equality), read `_stdout` (everything logged so far, trimmed), and use `await`. A `ReferenceError` in a test is reported as "Your code needs to define `x`."
- **Predict** cells compare the trimmed console output, line by line, with the correct option. Keep predicted output to one line, and avoid objects in predict cells, since the formatting is a detail the learner shouldn't need to memorize. Use `JSON.stringify` or template strings when the output is structured.
- **Printing rules** (what `console.log` shows): strings print raw; numbers, booleans, `null`, `undefined`, and `-0` print as `String(v)`; arrays and objects print as `[ 1, 'a' ]` and `{ a: 1, b: 'x' }` (nested strings in single quotes, `[]` and `{}` when empty, deeper than 2 levels collapses to `[Array]` / `[Object]`); functions print as `[Function: name]`; `Map(2) { 'a' => 1 }`; `Set(2) { 1, 2 }`; dates print ISO strings; errors print `Name: message`.
- **Environment.** No `prompt()`, `alert()`, `require`, `import`, `fetch`, `document`, `window` or Node APIs. Lessons speak through `console.log` and return values. Use `Math.random` only through a seeded generator written in the lesson, and never print the current date or local-time strings (use `toISOString()` and UTC methods), so output is identical for every learner.
- **Timing.** A challenge that doesn't finish in 8 seconds fails with a friendly message. Keep async demos under a second, and use small delays (10–100 ms).

**Starter code**

JavaScript has no `...` placeholder, so starters use a visible stub that makes the tests fail:

```js exercise id=sum-numbers title="Sum an array"
function sumNumbers(numbers) {
  // TODO: return the sum of every number in `numbers`
  return null;
}
--- solution
function sumNumbers(numbers) {
  return numbers.reduce((total, n) => total + n, 0);
}
--- test
assert(sumNumbers([1, 2, 3]) === 6, "sumNumbers([1, 2, 3]) should return 6");
assert(sumNumbers([10, -4]) === 6, "Negative numbers should be added too");
assert(sumNumbers([]) === 0, "An empty array should sum to 0");
--- hint
Start from `0` and add each element to a running total, or look at `Array.prototype.reduce`.
--- hint
`numbers.reduce((total, n) => total + n, 0)` does the whole job in one expression.
```

**Validator checks for JS** (same as Python): every challenge's solution passes and its starter fails; every predict's marked option equals the real output; every run cell runs; and each cell finishes in under 1.5 seconds.

**JS voice and quality bar.** Everything in the Python guide applies: hook, intuition-first sections, challenges right after the concept, callouts, recap, "Up next". Be precise about JavaScript semantics, and call out the pitfalls that real developers hit: `==` coercion, `var` hoisting, `this` in callbacks, floating-point sums, `sort()` comparing strings by default, mutation of shared arrays and objects, and `await` that's missing. Never write a challenge that passes if the learner hard-codes the answer. Test with new inputs.

# HTML & CSS courses

HTML & CSS courses use the fence `html` and the same cell kinds. Examples and challenges render in a **sandboxed live preview** in the learner's browser; challenge tests are JavaScript assertions that run against the real DOM and computed styles, so no CSS engine is approximated.

```
```html run                              complete page or fragment; scripts are stripped
```html exercise id=… title="…"         build markup/styles; checked by JS DOM assertions
```html debug id=… title="…"            broken HTML/CSS the learner fixes
```html predict id=… title="…"          "how will this render?" (preview + explanation)
```

Sections inside a cell (`--- solution`, `--- test`, `--- hint`, `--- options`, `--- explain`) work exactly as in Python. Mark the correct predict option with `* `.

**Semantics**

- A fragment is wrapped in a complete document automatically. A full document (starting with `<!doctype html>` or `<html>`) is used as-is.
- Previews are sandboxed with scripts disabled, so lessons teach HTML and CSS, not JavaScript. Do not write cells that depend on scripts.
- Each challenge runs in its own throwaway iframe at 1100 × 900 px, then runs the tests. `getComputedStyle`, `getBoundingClientRect`, `matchMedia` and the rest of the DOM API are available.
- Keep examples self-contained. Use inline SVG or data URIs for images; network images may be blocked by the preview CSP.
- CSS computed values are exact: `display` is `flex`, but a color is `rgb(…)`. Prefer the `assertColor` helper over `assertStyle` for colors.

**Test helpers**

```js
assert(condition, "friendly message")
assertExists(".card", "Add a card")
assertNotExists(".old")
assertCount("li", 3, "The list should have three items")
assertText("h1", "Hello, world")
assertAttr("img", "alt", "A cat asleep on a keyboard")
assertStyle(".card", "border-radius", "12px")
assertColor(".card", "background-color", "#0f172a")
assertVisible(".cta")
assertNoOverflow("The page should not scroll sideways")
assertFocusable("input[name=email]")
query(".card")             // returns the element
normalize("  a   b ")      // "a b"
```

Tests can contain arbitrary JavaScript. A thrown error fails the challenge and its message is shown to the learner, so write assertions that explain *what* is wrong without giving away the answer. Test behaviour and new inputs, not one specific implementation:

```html exercise id=feature-card title="Build a feature card"
<article class="card">
  <h2>Starter</h2>
</article>
<style>
  /* TODO */
</style>
--- solution
<article class="card">
  <h2>Fast by default</h2>
  <p>Ship a page that loads in under a second.</p>
</article>
<style>
  .card { padding: 24px; border-radius: 16px; background: #f8fafc; }
</style>
--- test
assertExists(".card", "Add an element with class card");
assertCount(".card h2", 1, "The card needs exactly one heading");
assertStyle(".card", "padding", "24px");
assertColor(".card", "background-color", "#f8fafc");
--- hint
Style the `.card` class, not the element directly.
```

**Validation**

```
node seed/courses/validate.mjs html-css-basics
```

The validator runs every solution, starter, predict and run cell in headless Chrome through the same test harness learners use. It needs a local Chrome (or Playwright's Chromium); set `CHROME_PATH` if necessary.

# C courses

C courses use the fence `c` and the same cell kinds. Cells compile and run with Clang 22 as WebAssembly (`@live-codes/clang-wasm`): in the browser the lesson loads the compiler from jsDelivr in a worker, and `node seed/courses/validate.mjs <course>` runs the same compiler, so every answer is checked for real.

```
```c run                                  complete program; shows stdout, stderr and compile errors
```c run error                            program that fails on purpose (must fail to compile or exit non-zero)
```c setup                                hidden declarations, prepended to every cell in the lesson
```c exercise id=… title="…"              learner writes functions; tests run in a generated main()
```c debug id=… title="…"                 buggy code the learner fixes; checked by the same tests
```c predict id=… title="…"               "what does this print?" (compared with the real output)
```

**Semantics**

- Each cell is a separate program. Variables do not carry from one cell to the next, so put shared declarations in a `setup` cell.
- A `run` cell is a complete program with its own `main`. A `predict` cell is too, and its marked option must equal the program's stdout exactly. An option that says "compile error" passes only when the program does not compile.
- Challenge tests are C statements placed inside a generated `int main(void)`. Check values with `CHECK(condition, "message")`, which prints `FAILED: message` and exits with status 1. Do not use `assert`: a failed assert traps in WebAssembly and loses its output.
- Learners' code in challenges must not define `main`.
- Stdin is empty in every cell, so do not write cells that wait for input.
- A call that runs longer than 20 seconds in the browser is stopped.
- The validator checks that each challenge's starter fails its tests and its solution passes, and that each predict's marked option matches the real output.
