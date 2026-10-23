Two pages can have identical markup and feel completely different. One looks like a document that escaped from a law office; the other looks designed. The difference is rarely a dramatic image or a fancy font. It is a handful of typographic decisions: a typeface with a point of view, a heading that is allowed to be large, body text with room to breathe, a line length that does not exhaust the eye, and a palette with more thought behind it than "black on white".

This lesson is about those decisions. You will learn the properties that set type, how line height actually works, how to measure a readable line, and how to build a small color system with custom properties. None of it requires a design degree. It requires noticing what the browser does by default and choosing something better.

## Start with a font stack

`font-family` takes a list. The browser tries each font from left to right and uses the first one installed on the reader's machine. The last item should be a generic family, so there is always a sensible fallback.

```html run
<p class="sans">System sans: clear, neutral, at home in an interface.</p>
<p class="serif">Georgia serif: slower, warmer, made for reading.</p>
<p class="mono">Monospace: every character the same width, useful for code.</p>

<style>
  body {
    margin: 0;
    padding: 32px;
    background: #f8fafc;
    color: #1e293b;
  }

  p {
    margin: 0 0 16px;
    font-size: 1.125rem;
    line-height: 1.6;
  }

  .sans {
    font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
  }

  .serif {
    font-family: Georgia, "Times New Roman", serif;
  }

  .mono {
    font-family: ui-monospace, "SF Mono", Menlo, monospace;
  }
</style>
```

`system-ui` resolves to the operating system's interface font: San Francisco on a Mac, Segoe UI on Windows, Roboto on many Android devices. It loads instantly because it is already there. That is why dashboards and product pages use it so often.

A serif stack like `Georgia, "Times New Roman", serif` is a different voice. Georgia was designed for screens, with a large x-height and sturdy strokes. It remains one of the most reliable reading fonts on the web. The quotes around `"Times New Roman"` are required because the name contains spaces.

A monospace stack is for code, tabular numbers and anything where character width should not change. Do not set a whole article in monospace unless the article is about terminals.

> **Tip:** Fonts are a performance decision. Every custom font is a file the reader must download before the text can render in its final form. The stacks above cost nothing and still look intentional. If you do use a custom font later, self-host it and subset it.

## Size, weight and style

`font-size` sets the size of the text. `rem` is relative to the root font size, which is 16px by default, so `1rem` is 16px and `2.5rem` is 40px. `em` is relative to the current element's font size, which makes it useful for spacing that should scale with the text but confusing when nested.

`font-weight` sets boldness on a scale from 100 to 900. In practice, 400 is regular, 600 is semibold and 700 is bold. A font only has the weights it ships with; if you ask for 600 and the font has only 400 and 700, the browser may synthesise something in between. `font-style: italic` asks for the italic cut, or slants the regular cut if there is none.

```html run
<h1 class="display">A quieter kind of loud</h1>
<p class="lede">A room, a record and a pot of coffee that is slightly too strong.</p>
<p class="meta">Field notes · 6 minute read</p>

<style>
  body { margin: 0; padding: 40px; background: #fbf7ef; color: #292524; font-family: Georgia, "Times New Roman", serif; }

  .display {
    max-width: 12ch;
    margin: 0 0 20px;
    font-size: 3.5rem;
    font-weight: 700;
    line-height: 1.05;
    letter-spacing: -0.035em;
  }

  .lede {
    max-width: 34rem;
    margin: 0 0 24px;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.55;
    color: #57534e;
  }

  .meta {
    margin: 0;
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: #0f766e;
  }
</style>
```

Three details are doing a lot of work. The heading is large and tightly spaced, because display type at 56px needs less air between lines than body text at 18px. The lede is italic and slightly muted, which separates it from the body without making it smaller. The meta line is small, uppercase, letter-spaced and sans-serif, so it reads as a label rather than a sentence.

That last combination is worth memorising: **small uppercase labels need letter-spacing**. Capital letters are designed to sit next to lowercase letters. When everything is uppercase, the gaps disappear and the line becomes a grey bar. `letter-spacing: 0.08em` to `0.14em` restores the rhythm.

## Line height is vertical rhythm

`line-height` sets the height of a line box. It accepts a length (`24px`), a percentage, or a plain number (`1.5`). The plain number is special: it is a **multiplier** that is recalculated for each element's font size.

```html run
<p class="unitless">Unitless: the spacing grows with the type. At 24px, a line height of 1.5 gives 36px between baselines.</p>
<p class="fixed">Fixed: the spacing stays at 24px no matter how large the text becomes, so the lines start to crowd.</p>

<style>
  body {
    margin: 0;
    padding: 32px;
    background: #f8fafc;
    font-family: Georgia, serif;
    color: #1e293b;
  }

  p {
    max-width: 32rem;
    font-size: 24px;
  }

  .unitless {
    line-height: 1.5;
  }

  .fixed {
    line-height: 24px;
  }
</style>
```

The unitless paragraph gets 36px line boxes. The fixed paragraph gets 24px line boxes around 24px text — technically readable, but cramped, and it would break completely at 32px.

Use a unitless number for anything that inherits: body copy around `1.5` to `1.7`, headings around `1.05` to `1.25`. A length can be useful for a single component where you need a precise baseline, but it does not adapt when the font size changes.

`line-height` also inherits, and the unitless value inherits as a number, not as a computed length. That means a child with a larger font automatically gets proportionally more line height. This is the main reason the unitless form is the professional default.

> **Pitfall:** `line-height: 1.2` on 16px body text gives 19.2px lines, which is too tight for paragraphs. Save tight leading for headings, where the lines are short and the type is large.

## Challenge: an editorial article

Build a small editorial page. The heading should be a display size of at least `40px`. The body copy should sit in a column roughly 60–70 characters wide, with a line height of at least `1.6`. The quote should be highlighted with a `#f1f5f9` background and a `4px` teal left border.

The starter has the content but no styles.

```html exercise id=editorial-article title="Set an editorial article"
<article class="story">
  <p class="kicker">The long read</p>
  <h1>The case for taking the slow train</h1>
  <p class="standfirst">Six hours, three changes and a window that actually opens.</p>
  <p>The fast train gets there first. The slow train gets there better. That is the entire argument, and it survives contact with reality more often than you would expect.</p>
  <blockquote>You do not see a country properly until you have watched it from a seat that reclines.</blockquote>
  <p>There is a particular kind of attention that only appears when the arrival time stops being the point.</p>
</article>

<style>
  /* TODO: set the type, measure and quote treatment */
</style>
--- solution
<article class="story">
  <p class="kicker">The long read</p>
  <h1>The case for taking the slow train</h1>
  <p class="standfirst">Six hours, three changes and a window that actually opens.</p>
  <p>The fast train gets there first. The slow train gets there better. That is the entire argument, and it survives contact with reality more often than you would expect.</p>
  <blockquote>You do not see a country properly until you have watched it from a seat that reclines.</blockquote>
  <p>There is a particular kind of attention that only appears when the arrival time stops being the point.</p>
</article>

<style>
  body {
    margin: 0;
    background: #fbf7ef;
    color: #292524;
    font-family: Georgia, "Times New Roman", serif;
  }

  .story {
    box-sizing: border-box;
    max-width: 66ch;
    margin: 0 auto;
    padding: 56px 24px;
  }

  .kicker {
    margin: 0 0 8px;
    color: #0f766e;
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
  }

  h1 {
    margin: 0 0 16px;
    font-size: clamp(2.5rem, 6vw, 4rem);
    line-height: 1.05;
    letter-spacing: -0.03em;
  }

  .standfirst {
    margin: 0 0 28px;
    color: #57534e;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.5;
  }

  p {
    margin: 0 0 20px;
    line-height: 1.65;
  }

  blockquote {
    margin: 32px 0;
    padding: 20px 24px;
    border-left: 4px solid #0f766e;
    background: #f1f5f9;
    color: #1f2937;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.5;
  }
</style>
--- test
assertExists("h1", "Keep the article's h1 so there is a display heading to size.");
const heading = getComputedStyle(query("h1"));
assert(parseFloat(heading.fontSize) >= 40, `The heading renders at ${heading.fontSize}. A display heading should be at least 40px.`);
const story = query(".story");
const storyStyle = getComputedStyle(story);
const measure = parseFloat(storyStyle.maxWidth);
assert(Number.isFinite(measure) && measure >= 480 && measure <= 800, `The article measures ${storyStyle.maxWidth} across. Aim for a readable column, roughly 60–70 characters.`);
const bodyParagraph = query(".story p:not(.kicker):not(.standfirst)");
const bodyStyle = getComputedStyle(bodyParagraph);
const bodySize = parseFloat(bodyStyle.fontSize);
const bodyLeading = parseFloat(bodyStyle.lineHeight);
assert(bodyLeading / bodySize >= 1.55, `Body lines are ${(bodyLeading / bodySize).toFixed(2)} times the font size. Give paragraphs at least 1.6.`);
assertColor("blockquote", "background-color", "#f1f5f9", "The pull quote should sit on a #f1f5f9 background.");
assertStyle("blockquote", "border-left-width", "4px", "Give the quote a 4px left border in the teal accent.");
assertNoOverflow("The article should not cause horizontal scrolling.");
--- hint
Start with the page: `body` margin, background and a serif stack. Then cap `.story` with `max-width: 66ch` and center it with `margin: 0 auto`.
--- hint
The heading needs a large `font-size` and a tight `line-height`. Body paragraphs need `line-height: 1.65` or similar.
--- hint
For the quote, combine `background: #f1f5f9`, `border-left: 4px solid #0f766e`, padding and a little margin.
```

## The small controls that finish the type

Four properties handle most of the remaining detail:

- `letter-spacing` adds space between characters. Use a little for uppercase labels, and negative values for large display headings.
- `text-align` sets horizontal alignment. Left is the safe default for body text; centered is for short headings and invitations, not paragraphs; justified text creates uneven gaps on the web because browsers do not hyphenate reliably.
- `text-transform` changes case visually (`uppercase`, `lowercase`, `capitalize`) without changing the underlying text. Be careful: a screen reader may still read the original case, and uppercase words can be spelled out letter by letter in some contexts.
- `text-decoration` controls underlines. If you remove an underline from a link, replace it with another clear signal: weight, color and a visible focus state.

```html run
<article class="story">
  <p class="kicker">Field notes</p>
  <h2>The long way to the coast</h2>
  <p class="intro">A slower route, a heavier pack, and a better view.</p>
  <p>The path leaves the village behind the bakery and climbs through hazel for an hour before it decides to become a path again.</p>
  <p><a href="#route">Read the route notes</a></p>
  <p class="signoff">— from the notebook</p>
</article>

<style>
  body { margin: 0; padding: 32px; background: #fbf7ef; color: #292524; font-family: Georgia, "Times New Roman", serif; }

  .story { max-width: 62ch; }

  .kicker {
    margin: 0 0 8px; color: #0f766e; font-family: system-ui, sans-serif;
    font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase;
  }

  h2 { margin: 0 0 12px; font-size: 2.25rem; line-height: 1.1; letter-spacing: -0.03em; }

  p { margin: 0 0 16px; line-height: 1.65; }

  .intro { color: #57534e; font-size: 1.2rem; font-style: italic; }

  a { color: #0f766e; font-weight: 600; text-decoration-thickness: 2px; text-underline-offset: 3px; }

  .signoff { text-align: right; font-style: italic; color: #78716c; }
</style>
```

The `max-width: 62ch` is the key line. `ch` is the width of the "0" character in the current font, so `62ch` is roughly 62 characters. For a serif body face, 60–70ch is a comfortable measure. At 1100px wide, this column stops growing long before the paragraph becomes a single endless line.

`text-decoration-thickness` and `text-underline-offset` are small refinements that make links look intentional rather than default. They are optional, but they show how much control CSS gives you over details people feel before they notice.

## Color is a system, not a pick

Contrast is the first question, not the last. The Web Content Accessibility Guidelines (WCAG) set minimum contrast ratios:

- **4.5:1** for normal body text.
- **3:1** for large text (roughly 24px regular, or 18.66px bold) and for meaningful interface boundaries.
- More is better. Black on white is 21:1. A pleasant dark grey on warm paper is often 10:1 or more.

Low-contrast grey text is the most common accessibility failure on the web, and it is almost always a design decision rather than an accident. `#94a3b8` on white looks refined in a mockup and becomes unreadable in sunlight. Check contrast with a real tool, not by eye.

Semantic color choices make a palette easier to reason about. Name colors by job, not by hue:

- `--ink` for primary text.
- `--paper` for the page background.
- `--muted` for secondary text.
- `--accent` for links and actions.
- `--danger` for destructive actions, not for decoration.

CSS custom properties let you define those values once and reuse them. They are ordinary properties that happen to start with `--`, and they inherit like `color` does.

```html run
<article class="post">
  <p class="eyebrow">Palette</p>
  <h2>One accent, used with intent</h2>
  <p>The link and the label share a color because they share a job: they are the things you can act on.</p>
  <p><a href="#notes">Read the notes</a></p>
</article>

<style>
  :root {
    --ink: #1f2937;
    --paper: #fbf7ef;
    --muted: #57534e;
    --accent: #b45309;
  }

  body { margin: 0; padding: 48px 24px; background: var(--paper); color: var(--ink); font-family: Georgia, "Times New Roman", serif; }

  .post { max-width: 38rem; margin: 0 auto; }

  .eyebrow {
    margin: 0 0 8px;
    color: var(--accent);
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  h2 { margin: 0 0 12px; font-size: 2rem; line-height: 1.15; }

  p { margin: 0 0 16px; color: var(--muted); line-height: 1.6; }

  a { color: var(--accent); font-weight: 600; }
</style>
```

`:root` is the document's root element, the `html` element. Custom properties defined there are available everywhere. `var(--accent)` reads the value. You can provide a fallback: `var(--accent, #b45309)` uses the second value if the variable is missing.

The real advantage appears when the palette changes. A dark section can redefine `--paper` and `--ink` on itself, and every child that uses `var()` follows. You edit one block instead of hunting through the stylesheet.

> **Pitfall:** A custom property is not automatically accessible just because it is a variable. `--muted: #cbd5e1` on white is still unreadable. The variable makes the system consistent; it does not make the color choice good.

## Challenge: build a palette with custom properties

Define three custom properties on `:root` — `--ink`, `--paper` and `--accent` — and use them throughout the card. The page background should be `--paper`, the heading and body text should be `--ink`, and the eyebrow and link should be `--accent`.

Use `#1f2937` for ink, `#fbf7ef` for paper and `#b45309` for the accent.

```html exercise id=palette-system title="A palette with custom properties"
<article class="post">
  <p class="eyebrow">Studio notes</p>
  <h2>Better shelves, fewer decisions</h2>
  <p>One material, one finish, one place for everything. The constraint is the design.</p>
  <p><a href="#process">See how the shelves are made</a></p>
</article>

<style>
  /* TODO: define --ink, --paper and --accent on :root, then use var() */
</style>
--- solution
<article class="post">
  <p class="eyebrow">Studio notes</p>
  <h2>Better shelves, fewer decisions</h2>
  <p>One material, one finish, one place for everything. The constraint is the design.</p>
  <p><a href="#process">See how the shelves are made</a></p>
</article>

<style>
  :root {
    --ink: #1f2937;
    --paper: #fbf7ef;
    --accent: #b45309;
  }

  body {
    margin: 0;
    padding: 48px 24px;
    background: var(--paper);
    color: var(--ink);
    font-family: Georgia, "Times New Roman", serif;
  }

  .post {
    max-width: 38rem;
    margin: 0 auto;
  }

  .eyebrow {
    margin: 0 0 8px;
    color: var(--accent);
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  h2 {
    margin: 0 0 12px;
    color: var(--ink);
    font-size: 2rem;
    line-height: 1.15;
  }

  p {
    margin: 0 0 16px;
    line-height: 1.6;
  }

  a {
    color: var(--accent);
    font-weight: 600;
  }
</style>
--- test
const rootStyle = getComputedStyle(document.documentElement);
const bodyStyle = getComputedStyle(document.body);
const readVariable = (name) => (rootStyle.getPropertyValue(name) || bodyStyle.getPropertyValue(name)).trim();
const ink = readVariable("--ink");
const paper = readVariable("--paper");
const accent = readVariable("--accent");
assert(ink, "Define --ink on :root with the primary text color.");
assert(paper, "Define --paper on :root with the page background color.");
assert(accent, "Define --accent on :root with the link and label color.");
assertColor("body", "background-color", paper, "The page background should use var(--paper).");
assertColor("h2", "color", ink, "The heading should use var(--ink).");
assertColor(".eyebrow", "color", accent, "The eyebrow should use var(--accent).");
assertColor("a", "color", accent, "The link should use var(--accent) too, so actions share one color.");
--- hint
Put the variables in a `:root { ... }` block at the top of the stylesheet: `--ink: #1f2937;` and so on.
--- hint
Read a variable with `color: var(--ink);` and `background: var(--paper);`. The name includes the two dashes.
--- hint
Use the accent for both `.eyebrow` and `a`. Reusing the same variable is the point of the exercise.
```

## Debug: the unreadable summary

This summary is set at 24px with `line-height: 1.2` and a pale grey that disappears into the white page. The type is large enough to feel important, but the lines are cramped and the contrast is below every useful threshold. Fix the leading and the color.

```html debug id=unreadable-summary title="The summary nobody can read"
<p class="summary">We read every note, every complaint and every unlikely suggestion. Then we make the coffee, because that is the part we can control.</p>

<style>
  body {
    margin: 0;
    padding: 48px;
    background: #ffffff;
    font-family: Georgia, "Times New Roman", serif;
  }

  .summary {
    max-width: 30rem;
    margin: 0;
    font-size: 24px;
    line-height: 1.2;
    color: #94a3b8;
  }
</style>
--- solution
<p class="summary">We read every note, every complaint and every unlikely suggestion. Then we make the coffee, because that is the part we can control.</p>

<style>
  body {
    margin: 0;
    padding: 48px;
    background: #ffffff;
    font-family: Georgia, "Times New Roman", serif;
  }

  .summary {
    max-width: 30rem;
    margin: 0;
    font-size: 24px;
    line-height: 1.65;
    color: #334155;
  }
</style>
--- test
const paragraph = query(".summary");
const paragraphStyle = getComputedStyle(paragraph);
const fontSize = parseFloat(paragraphStyle.fontSize);
const lineHeight = parseFloat(paragraphStyle.lineHeight);
assert(Number.isFinite(lineHeight), "The line height should resolve to a real length. Use a unitless number such as 1.65.");
const leading = lineHeight / fontSize;
assert(leading >= 1.5, `The summary has ${leading.toFixed(2)} lines of height for each line of text. At 24px, that is cramped. Use at least 1.5.`);
function rgbParts(value) {
  const numbers = value.match(/[\d.]+/g);
  return numbers ? numbers.slice(0, 3).map(Number) : null;
}
function luminance(rgb) {
  const channels = rgb.map((value) => {
    const c = value / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
const foreground = rgbParts(paragraphStyle.color);
const background = rgbParts(getComputedStyle(document.body).backgroundColor);
const lighter = Math.max(luminance(foreground), luminance(background));
const darker = Math.min(luminance(foreground), luminance(background));
const contrast = (lighter + 0.05) / (darker + 0.05);
assert(contrast >= 4.5, `The summary text has a contrast ratio of ${contrast.toFixed(2)}:1 against the page. Body copy should reach 4.5:1, and this pale grey does not.`);
--- hint
Two separate properties are wrong: the spacing between lines and the color of the text.
--- hint
Try `line-height: 1.65` for the leading. For the color, go darker than `#94a3b8` — `#334155` is a calm slate that passes comfortably.
--- hint
Keep the font size and the maximum width. A darker color and a unitless line height are enough to fix the reading experience.
```

## Fluid type with clamp()

A fixed heading size that looks right on a laptop is often too large on a phone. `clamp()` lets a value grow with the viewport but never smaller than a minimum or larger than a maximum.

```html run
<h1 class="hero">Built for the long way round</h1>
<p class="deck">A slower guide to the roads the motorway forgot.</p>

<style>
  body { margin: 0; padding: 48px 24px; background: #0f172a; color: #f8fafc; font-family: system-ui, sans-serif; }

  .hero {
    max-width: 16ch;
    margin: 0 0 20px;
    font-size: clamp(2rem, 7vw, 5rem);
    line-height: 1.02;
    letter-spacing: -0.04em;
  }

  .deck {
    max-width: 34rem;
    margin: 0;
    color: #cbd5e1;
    font-size: clamp(1rem, 2vw, 1.25rem);
    line-height: 1.55;
  }
</style>
```

The heading is `clamp(2rem, 7vw, 5rem)`. At a narrow width, 7% of the viewport is small, so the minimum of 2rem wins. On a wide screen, the preferred value would grow past 5rem, so the maximum stops it. Between those points, the type scales smoothly.

Read it as: **never smaller than the first value, never larger than the last, and otherwise the middle value**. The middle value can be a viewport unit, a percentage or a `calc()` expression.

Clamp is not a substitute for a type scale. Set a sensible minimum, choose a maximum that suits the longest heading, and test at both ends. Do not clamp body text below 16px; small type is not elegant, it is just hard to read.

> **Under the hood:** `vw` is 1% of the viewport width. On a 1100px preview, `7vw` is 77px, just under the 80px maximum, so the heading is already near its largest size. Drag the preview to phone width and the minimum takes over. The browser recalculates the value as the viewport changes, with no media query required.

## Predict: which line box grows?

Both paragraphs start at 20px. One gets a unitless line height and one gets a fixed length. Then the first paragraph's font size changes.

```html predict id=line-height-multiplier title="Unitless versus fixed line height"
<p class="unitless">Unitless line height</p>
<p class="fixed">Fixed line height</p>

<style>
  p {
    font-size: 20px;
  }

  .unitless {
    line-height: 1.5;
  }

  .fixed {
    line-height: 24px;
  }

  .unitless {
    font-size: 32px;
  }
</style>
--- options
* The unitless paragraph: 1.5 × 32px = 48px, while the fixed paragraph stays at 24px
The fixed paragraph: 24px is larger than 1.5
Both paragraphs: the first font-size rule fixes the line height at 30px
The unitless paragraph: 1.5 × 20px = 30px, because line height uses the first font size
--- explain
A unitless line height is a multiplier resolved against the element's final font size. The later `font-size: 32px` wins, so the line box becomes 1.5 × 32 = 48px. The fixed 24px line height does not care about the font size and stays 24px, which is why fixed lengths are risky on text that inherits or changes size.
```

## Recap

- A font stack lists fonts from most to least preferred and ends in a generic family. `system-ui`, Georgia and monospace stacks cover most needs.
- Use `rem` for sizes, numeric weights for boldness, and italic sparingly.
- Unitless `line-height` scales with font size; fixed lengths do not. Use 1.5–1.7 for body copy and tighter values for display headings.
- Keep body text around 60–70 characters with `max-width` in `ch`.
- Letter-space uppercase labels; do not remove link underlines without a replacement.
- WCAG AA asks for 4.5:1 contrast on normal text and 3:1 on large text. Check it rather than trusting your eye.
- Custom properties create a palette you can change in one place.
- `clamp(min, preferred, max)` makes type fluid without losing its limits.

**Up next:** Flexbox — putting boxes in a row, controlling alignment, and building the navigation bar that every page eventually needs.
