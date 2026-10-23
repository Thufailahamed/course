Regular expressions have a reputation for being unreadable, and most of that reputation is earned by one-line patterns nobody can review. But the language is small. A handful of building blocks (character classes, quantifiers, groups, anchors and lookarounds) covers almost every real need in validation, parsing, log analysis and text cleanup. Once you can read the parts, a pattern stops being a riddle and becomes a specification.

This lesson teaches you to read and write patterns in pieces, to use the flags and methods correctly (including the `lastIndex` trap that breaks code in production), and to use replacement functions when a plain string replacement isn't enough.

## Literals, flags and the two ways to test

A regex literal is written between slashes, and flags follow the closing slash. The flags change how the whole pattern behaves:

| Flag | Effect |
|---|---|
| `i` | case-insensitive matching |
| `g` | global: find every match, not just the first (and remember where you stopped) |
| `m` | multiline: `^` and `$` match at line boundaries, not just the string's ends |
| `s` | dotAll: `.` also matches newline characters |
| `u` | unicode: treats the pattern as code points, enables `\p{...}` classes |
| `y` | sticky: the match must start exactly at `lastIndex` |

The flags matter more than they look. Here is `.` with and without `s`, and `^`/`$` with and without `m`:

```js run
console.log(/a.b/.test("a\nb"), /a.b/s.test("a\nb"));
console.log("line one\nline two".match(/^line \w+$/gm));
```

Without `m`, `^` and `$` would only match at the very start and end of the whole string, and the second line would match nothing.

Two methods do most of the work. `test` returns a boolean. `match` returns the match details, or `null`:

```js run
const phone = /\d{3}-\d{4}/;
console.log(phone.test("call 555-1234 now"));
console.log("call 555-1234 now".match(phone)[0]);
```

> **Tip:** Use `test` when you only need a yes or no. Use `match` (with or without `g`), `matchAll` or `exec` when you need the matched text or the groups.

## Reading a pattern: the building blocks

Read a pattern left to right, one token at a time. Each token is one of these:

- **Literal characters** match themselves. `\.` matches a real dot, because the dot is special otherwise.
- **Character classes** match one character from a set: `[aeiou]`, `[^0-9]` (anything but a digit), `\d`, `\w`, `\s`.
- **Quantifiers** repeat the token before them: `?` (0 or 1), `*` (0 or more), `+` (1 or more), `{2,4}` (between 2 and 4). Add `?` after a quantifier to make it lazy.
- **Groups** `(...)` capture the matched text. `(?:...)` groups without capturing. `(?<name>...)` captures under a name.
- **Anchors** `^` and `$` match the start and end. `\b` matches a word boundary.

Named groups are the single best readability tool. Compare the two versions of the same date parser:

```js run
const positional = /(\d{4})-(\d{2})-(\d{2})/;
const named = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;

console.log("2026-10-22".match(positional)[2]);
console.log("2026-10-22".match(named).groups.month);
```

The positional group `[2]` is a number you have to count. The named `groups.month` documents itself. In a long pattern, names are the difference between a maintainable parser and a mystery.

If a pattern is large, build it from named pieces with `String.raw`, so the backslashes survive and each part can be read on its own:

```js run
const part = {
  year: String.raw`(?<year>\d{4})`,
  month: String.raw`(?<month>\d{2})`,
  day: String.raw`(?<day>\d{2})`,
};
const isoDate = new RegExp(`^${part.year}-${part.month}-${part.day}$`);

console.log(isoDate.exec("2026-10-22").groups.month);
```

JavaScript has no verbose `x` flag for spaces and comments in patterns, so building from named parts is the closest idiomatic substitute.

## Finding every match

`matchAll` (or a `g` regex with `match`) returns every match. Use `matchAll` when you need the groups for each one, because it gives you the full match object each time:

```js run
const log = "[10:02] login ada\n[10:15] logout ada";
for (const m of log.matchAll(/\[(?<time>\d{2}:\d{2})\] (?<event>\w+)/g)) {
  console.log(m.groups.time, m.groups.event);
}
```

`matchAll` requires the `g` flag and throws a `TypeError` without it. That's a useful guardrail, because a missing `g` is a common silent bug with `match`.

## Lookahead and lookbehind: conditions without consuming text

A lookaround checks for a pattern around the match without including it in the result. Lookahead `(?=...)` looks forward, lookbehind `(?<=...)` looks backward, and the negated forms `(?!...)` and `(?<!...)` require the pattern to be absent.

Lookbehind is how you extract a number that has a currency symbol in front of it, without capturing the symbol:

```js run
const prices = "$4 and $12.50, plus 30 cents";
console.log(prices.match(/(?<=\$)\d+(\.\d+)?/g));
```

Lookahead is the natural tool for "all of these must be true somewhere in the string." Here, a password must contain a digit, a lowercase letter and an uppercase letter, and be at least eight characters:

```js run
const strong = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
console.log(["passWORD1", "password", "Sh0rt"].map((p) => strong.test(p)));
```

Each `(?=...)` checks one requirement from the same starting position, and none of them consumes characters. Then `.{8,}` consumes the whole string to check the length.

## Replacement: strings, backreferences and functions

`replace` accepts a string with special codes (`$1` for the first group, `$<name>` for a named group), or a function that computes each replacement:

```js run
const date = "2026-10-22";
console.log(date.replace(/(\d{4})-(\d{2})-(\d{2})/, "$3/$2/$1"));
console.log("3 apples, 12 pears".replace(/\d+/g, (n) => n * 2));
```

The function form is the one to reach for whenever the replacement depends on the match. It receives the whole match, then each group, and returns the text to insert. Strings handle reordering; functions handle logic.

> **Pitfall:** Replacement strings interpret `$` specially. If user input contains `$&` or `$1` and you use it in a replacement string, the input is treated as a pattern. Pass a function when the replacement text comes from data.

## The `lastIndex` trap

A regex with the `g` or `y` flag is stateful. It remembers where its last match ended, in `lastIndex`, and the next call to `test` or `exec` starts from there. The state belongs to the regex object, not to the string you're testing. Reuse the object across inputs and results start depending on the previous call.

```js predict id=predict-global-test title="The remembered position"
const re = /a/g;
console.log(re.test("banana"), re.lastIndex, re.test("banana"));
--- options
true 1 true
true 0 true
* true 2 true
true 2 false
--- explain
The first `test` finds the `a` at index 1 and sets `lastIndex` to 2. The second call starts searching at index 2, finds the `a` at index 3, and returns `true`. The arguments of `console.log` are evaluated left to right, so `lastIndex` is read between the two calls and prints 2. A fresh regex, or one without `g`, would return `true` both times with no state carried over.
```

```js debug id=stateful-filter title="Lines that go missing"
// Keep every line that contains "error".
function errorLines(lines) {
  const pattern = /error/g;
  return lines.filter((line) => pattern.test(line));
}
--- solution
function errorLines(lines) {
  const pattern = /error/;
  return lines.filter((line) => pattern.test(line));
}
--- test
assertEqual(errorLines(["error one", "error two", "all good"]), ["error one", "error two"], "Every line with 'error' should be kept");
assertEqual(errorLines(["error a", "error b", "error c"]), ["error a", "error b", "error c"], "Repeated matches should not skip lines");
assertEqual(errorLines([]), [], "No lines should give an empty result");
--- hint
The `g` flag makes `test` remember where it stopped in `lastIndex`. Think about what that does when the same regex is used for the next line.
--- hint
Remove the `g` flag. Without it, every `test` call starts searching at the beginning of its string.
```

> **Under the hood:** `lastIndex` is reset to 0 when a `test` or `exec` call fails, which is why the buggy filter sometimes works: it returns to the start after a miss. The bug appears only when two matches occur in a row, which is exactly what makes it hard to spot in a quick test.

## Exercises: parse, clean and fill

Strict validation means anchoring the pattern at both ends. Without `^` and `$`, `"2026-10-22 extra"` would pass as a date.

```js exercise id=parse-iso-date title="Parse a strict YYYY-MM-DD string"
function parseIsoDate(text) {
  // TODO: return { year, month, day } as numbers if `text` is exactly YYYY-MM-DD, otherwise null.
  // Use a named-group regex anchored at both ends.
  return null;
}
--- solution
function parseIsoDate(text) {
  const m = /^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})$/.exec(text);
  if (!m) return null;
  return { year: Number(m.groups.year), month: Number(m.groups.month), day: Number(m.groups.day) };
}
--- test
assertEqual(parseIsoDate("2026-10-22"), { year: 2026, month: 10, day: 22 }, "A valid date should parse into numbers");
assertEqual(parseIsoDate("1999-01-01"), { year: 1999, month: 1, day: 1 }, "Parse a second date too");
assertEqual(parseIsoDate("2026-10-22 extra"), null, "Trailing text should be rejected");
assertEqual(parseIsoDate("26-10-22"), null, "Two-digit years should be rejected");
assertEqual(parseIsoDate("x2026-10-22"), null, "Leading text should be rejected");
--- hint
Anchor the pattern with `^` and `$`, and read the parts with `(?<name>...)` groups, so you can write `m.groups.year`.
--- hint
`regex.exec(text)` returns `null` when nothing matches. When it does match, convert the three group strings with `Number`.
```

Slugs are a classic cleanup task: lowercase, collapse runs of unwanted characters into one separator, then trim the ends.

```js exercise id=slugify title="Turn a title into a URL slug"
function slugify(title) {
  // TODO: lowercase the title, turn each run of characters that are not a-z or 0-9
  // into one hyphen, and trim hyphens from both ends.
  return null;
}
--- solution
function slugify(title) {
  return title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
}
--- test
assertEqual(slugify("Hello, World!"), "hello-world", "Punctuation should become one hyphen");
assertEqual(slugify("  JavaScript & Regex 101 "), "javascript-regex-101", "Runs of spaces and symbols collapse, and ends are trimmed");
assertEqual(slugify("a---b"), "a-b", "Existing hyphens should collapse too");
assertEqual(slugify("!!!"), "", "A title with no letters or digits should give an empty slug");
--- hint
Use `replace` with a global regex for the runs of unwanted characters. `[^a-z0-9]` matches everything else, and `+` makes each run a single match.
--- hint
After the middle is clean, a second `replace` removes hyphens at the start or end. Anchors `^` and `$` with `-+` do that.
```

Templates are where the function form of `replace` earns its keep. The replacement depends on whether the name exists:

```js exercise id=fill-template title="Fill a template with a function replacer"
function fillTemplate(template, values) {
  // TODO: replace every {name} in `template` with values.name.
  // Leave names you don't have, such as {missing}, exactly as written.
  return null;
}
--- solution
function fillTemplate(template, values) {
  return template.replace(/\{(\w+)\}/g, (whole, name) => (name in values ? String(values[name]) : whole));
}
--- test
assertEqual(fillTemplate("Hi {name}, you owe {amount}", { name: "Ada", amount: 12 }), "Hi Ada, you owe 12", "Both placeholders should be filled");
assertEqual(fillTemplate("{a}{a}-{b}", { a: "x", b: "y" }), "xx-y", "Repeated placeholders should all be filled");
assertEqual(fillTemplate("Hello {missing}", {}), "Hello {missing}", "Unknown names should stay as written");
assertEqual(fillTemplate("no placeholders", { a: 1 }), "no placeholders", "Plain text should pass through");
--- hint
Pass a function as the second argument to `replace`. It receives the whole match and then each capture group, and whatever it returns becomes the replacement.
--- hint
Capture the name with `\{(\w+)\}`. In the callback, check `name in values`, and return `String(values[name])` or the original match.
```

> **In the wild:** Routers (Express and its relatives) compile paths like `/users/:id` into regular expressions, and bundlers use them to decide which files a loader handles. Template engines use exactly the replacement pattern above, and syntax highlighters are often just long lists of named groups.

## Recap

- Use `test` for yes or no, and `match`, `matchAll` or `exec` when you need the matched text.
- Read patterns one token at a time, and prefer named groups so the code documents itself.
- Anchor validation patterns with `^` and `$`, or they accept any text that contains a match.
- Lookbehind and lookahead check context without including it in the match.
- A `g` or `y` regex keeps `lastIndex` between calls. Don't reuse one across unrelated inputs in a `filter`.
- Use a replacement function whenever the output depends on the match or on data.

**Up next:** performance, where you'll learn to measure, memoize and debounce, and when a faster algorithm beats a faster loop.
