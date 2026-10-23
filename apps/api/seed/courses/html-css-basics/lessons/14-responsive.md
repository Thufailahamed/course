A page is not a fixed canvas. The same markup meets a 390-pixel phone, a 768-pixel tablet, a 1440-pixel laptop and a wall-sized monitor. Responsive design is not a second mobile website hidden behind a redirect; it is one document that adapts as the space changes.

The browser gives you a small, precise toolkit for this: the viewport meta tag, media queries, fluid images and fluid type. None of them require JavaScript. Used together, they let a layout rearrange itself at the exact point where the current one stops working.

## Tell the browser you meant it

The first line of defence is in the `<head>`:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

Without it, a mobile browser assumes the page was designed for a desktop and lays it out in a virtual viewport around 980 pixels wide, then zooms out to fit. Text becomes tiny, tap targets become unusable, and your carefully written media queries never fire at the width you expected.

`width=device-width` tells the browser to use the device's actual width in CSS pixels. `initial-scale=1` sets the starting zoom to 100%. Together they make the phone report a viewport of roughly 390 pixels instead of pretending to be a desktop.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trailhead Coffee</title>
    <style>
      body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
      main { max-width: 36rem; margin: 0 auto; padding: 3rem 1.25rem; }
      h1 { margin: 0 0 1rem; font-size: 2.5rem; letter-spacing: -0.03em; }
      p { line-height: 1.6; color: #475569; }
    </style>
  </head>
  <body>
    <main>
      <h1>Coffee, without ceremony.</h1>
      <p>Small-batch coffee for people who walk up hills. Open Tuesday to Sunday, 8am to 4pm.</p>
    </main>
  </body>
</html>
```

Open this page in the phone width of the preview toolbar. The heading wraps, the paragraph fills the screen, and nothing is zoomed out. The `max-width` on `main` keeps the line length comfortable on a desktop without causing a tiny column on a phone.

> **Pitfall:** A missing viewport tag is easy to miss because the desktop preview looks perfect. If your media queries seem to be ignored on a real phone but work in the toolbar, check the `<head>` first.

## Mobile first, then add room

A **media query** applies a block of CSS only when a condition about the viewport is true. The most useful condition is width:

```css
@media (min-width: 640px) {
  .steps { grid-template-columns: 1fr 1fr; }
}
```

The mobile-first pattern starts with the narrow layout as the default. You write the single-column styles first, with no media query at all. Then you add `min-width` blocks that introduce columns, larger gaps and bigger type as more space becomes available.

This ordering has a practical benefit: the simplest layout is the one every browser gets, including old phones and unusual devices. The fancy layout is an enhancement, not a requirement.

```html run
<section class="steps">
  <article>
    <h2>Choose a route</h2>
    <p>Filter by distance, climb and whether the dog can come.</p>
  </article>
  <article>
    <h2>Check the weather</h2>
    <p>Wind on the tops matters more than the forecast in the valley.</p>
  </article>
  <article>
    <h2>Pack light</h2>
    <p>Water, layers, a map and more food than feels reasonable.</p>
  </article>
  <article>
    <h2>Tell someone</h2>
    <p>A route card on the kitchen table is still the best safety tool.</p>
  </article>
</section>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .steps { display: grid; gap: 16px; max-width: 1000px; margin: 0 auto; padding: 2rem 1.25rem; }
  .steps article { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @media (min-width: 640px) {
    .steps { grid-template-columns: 1fr 1fr; }
  }
</style>
```

At 1100 pixels you see two columns. At 390 pixels the same four cards stack. Nothing was removed or duplicated; the grid simply gained a second column when the viewport crossed 640 pixels.

A `min-width` query is inclusive: `min-width: 640px` applies at exactly 640 and above. That is why the breakpoints in a mobile-first stylesheet usually read like a ladder: 480, 640, 900, 1200.

## min-width or max-width?

Both directions work. They describe different starting points.

| Approach | Base styles | Query | Best for |
|---|---|---|---|
| Mobile first | Narrow layout | `min-width` adds complexity | New projects, performance, simple defaults |
| Desktop first | Wide layout | `max-width` removes complexity | Extending an existing desktop design |

A `max-width: 700px` query applies at 700 and *below*. It is the natural choice when the wide layout is already the default and you want to simplify as the screen shrinks. The next challenge uses that direction deliberately, so you can see both.

Do not mix the two approaches randomly in one stylesheet. If the base is narrow, use `min-width`; if the base is wide, use `max-width`. Mixing them makes it hard to answer the basic question: *what does this element look like at 500 pixels?* You have to read every rule and work out which conditions overlap.

> **Tip:** Media queries do not add specificity. When two conditions are both true, the later rule wins if the selectors have equal specificity. Put your queries in a sensible order — usually narrow to wide — and keep related rules together.

## Breakpoints belong to the content

There is no list of device widths you must support. A breakpoint is a decision about your design: the width at which the current layout stops looking good.

Start narrow. Widen the preview slowly. Watch the paragraph measure, the card widths and the navigation. The moment a line becomes too long to read, or a card becomes too narrow for its heading, you have found a breakpoint. Add a `min-width` query there.

This is why copying an "iPhone breakpoint" from a blog post is usually a mistake. Your phone-sized layout might break at 560 pixels and your tablet layout might be fine until 900. The content tells you; the device names do not.

The preview toolbar gives you desktop, tablet (768px) and phone (390px) widths. Use it as a quick sanity check, not as a substitute for dragging the edge of the window. Most layout bugs appear somewhere between the named sizes, not exactly at them.

```html predict id=responsive-predict-min-width title="Which padding wins at 1100px?"
<div class="notice">
  <strong>Trail closed</strong>
  <p>The lower path is flooded after rain.</p>
</div>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; }
  .notice { padding: 16px; border-radius: 12px; background: #e0f2fe; }
  @media (min-width: 700px) {
    .notice { padding: 32px; }
  }
</style>
--- options
* 32px, because the viewport is wider than 700px
16px, because the base rule is declared first
24px, the midpoint of the two rules
32px only when the viewport is narrower than 700px
--- explain
The test viewport is 1100 pixels wide, so `(min-width: 700px)` is true and the media block applies. The base `padding: 16px` is still there, but the later rule overrides it. If the viewport were 600 pixels, the condition would be false and the notice would keep 16px. `min-width` means "this width and up", not "below this width".
```

## Images that behave

A bitmap image has an intrinsic width. Drop a 1600-pixel photo into a 900-pixel column and the browser will happily let it overflow, because an image's default `max-width` is `none`. The page starts scrolling sideways, which is the most common responsive bug on the web.

The fix is two declarations:

```css
img {
  max-width: 100%;
  height: auto;
}
```

`max-width: 100%` caps the image at its container's width. `height: auto` lets the browser calculate the height from the image's natural aspect ratio, so the picture is not squashed. Always keep the `width` and `height` attributes in the HTML as well; they reserve the right amount of space before the image loads and prevent the page from jumping.

```html run
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='1600' height='900'%3E%3Crect width='1600' height='900' fill='%230f172a'/%3E%3Ccircle cx='1180' cy='260' r='150' fill='%23fbbf24'/%3E%3Cpath d='M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z' fill='%230f766e'/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="hero-copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 60rem; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { display: block; max-width: 100%; height: auto; border-radius: 16px; }
  h1 { margin: 1.5rem 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
```

The image is 1600 pixels wide by nature. In the 1100-pixel preview it renders at the width of its container, with the height scaled to match. Narrow the preview to phone width and it keeps shrinking. The aspect ratio never changes.

> **Pitfall:** `height: auto` is not optional. If you set only `max-width: 100%` but leave a fixed height in CSS, the image is squashed as it gets narrower. If you set a fixed width in CSS, `max-width` may never come into play.

## Type that bends instead of breaking

Headlines are harder than images because text has to stay readable across a much wider range. A 56-pixel heading looks bold on a laptop and absurd on a phone. A 28-pixel heading looks fine on a phone and timid on a desktop.

`clamp()` solves this with three values: a minimum, a preferred value and a maximum.

```css
font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
```

The preferred value can mix units. Here `5vw` grows with the viewport and `1rem` keeps a readable floor. The browser picks whichever is larger between the minimum and the preferred value, then caps the result at the maximum. The text is fluid in between but never smaller than 2.25rem or larger than 4.5rem.

```html run
<header class="masthead">
  <p class="eyebrow">Trailhead Coffee</p>
  <h1>Big views, small batches.</h1>
  <p class="lede">A walk-up coffee counter at the edge of the Peak District. Open every day the weather allows.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede {
    max-width: 38rem;
    margin: 0;
    font-size: clamp(1rem, 1.5vw + 0.75rem, 1.25rem);
    line-height: 1.6;
    color: #475569;
  }
</style>
```

Use `clamp()` for display type and generous spacing, not for every font size. Body text is usually better with a fixed, comfortable size and a `max-width` on the column. Fluid type is a tool for the extremes, not a reason to make every paragraph resize with the window.

> **Under the hood:** `vw` is one percent of the viewport width. At 1100 pixels, `5vw` is 55 pixels. Adding `1rem` gives 71 pixels, which is below the 72-pixel maximum, so the heading renders at 71 pixels. At 390 pixels, `5vw` is 19.5 pixels plus 16 equals 35.5, below the 36-pixel minimum, so the minimum wins.

## A navigation bar without JavaScript

A full mobile menu usually needs a button and a little JavaScript to toggle it. But you can build a perfectly usable responsive navigation bar with CSS alone: stack the brand and links on narrow screens, then switch to a row when there is room.

The markup stays in a sensible reading order. The media query only changes direction and alignment.

```html run
<header class="header">
  <a class="brand" href="#">Moss &amp; Pine</a>
  <nav class="links" aria-label="Main">
    <a href="#">Shop</a>
    <a href="#">Workshops</a>
    <a href="#">Journal</a>
    <a href="#">Visit</a>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #fff; }
  .header {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #e2e8f0;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; flex-wrap: wrap; gap: 0.5rem 1.25rem; }
  .links a { color: #475569; font-size: 0.95rem; text-decoration: none; }
  .links a:hover { color: #0f172a; }
  @media (min-width: 700px) {
    .header { flex-direction: row; align-items: center; justify-content: space-between; }
  }
</style>
```

At phone width the brand sits above the links and the links wrap onto as many lines as they need. At 700 pixels and above the header becomes a row with the brand on the left and the navigation on the right. No script, no hidden duplicate menu, no layout shift.

This is a baseline, not a complete mobile navigation pattern. If you need a disclosure button, build it with a real `<button>`, `aria-expanded`, and JavaScript in the advanced course. The CSS-only version is a good default because it works before any script loads.

## Motion, gently

Some people experience dizziness, nausea or migraine from large motion, parallax and zooming transitions. Operating systems expose a setting for this, and CSS can respect it with `prefers-reduced-motion`.

The safest pattern is to make motion an enhancement inside `no-preference`, or to explicitly remove it inside `reduce`:

```css
@media (prefers-reduced-motion: reduce) {
  .card { transition: none; }
  .card:hover { transform: none; }
}
```

```html run
<article class="card">
  <p class="eyebrow">Workshop</p>
  <h2>Build a field notebook</h2>
  <p>Saturday, 10am. All materials included.</p>
  <a href="#">Reserve a place</a>
</article>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    max-width: 28rem;
    margin: 0 auto;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    transition: transform 0.25s ease, box-shadow 0.25s ease;
  }
  .card:hover { transform: translateY(-4px); box-shadow: 0 12px 30px rgb(15 23 42 / 0.12); }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h2 { margin: 0 0 0.5rem; font-size: 1.25rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.55; }
  a { color: #0f172a; font-weight: 600; }
  @media (prefers-reduced-motion: reduce) {
    .card { transition: none; }
    .card:hover { transform: none; }
  }
</style>
```

Hover the card with motion enabled and it lifts slightly. Turn on "Reduce motion" in your operating system, reload, and the lift disappears while the card remains fully usable. That is the point: remove the decoration, keep the information and the interaction.

> **Tip:** Test with the operating-system setting, not just by resizing the window. The media feature follows the user's system preference, and it can change while the page is open.

## Challenge: stack at 700 pixels

This page has a two-column layout: a main article and a sidebar. At 1100 pixels it looks fine. Below 700 pixels the columns become too narrow to read.

Add a `max-width: 700px` media query that turns `.layout` into a single column. Keep the two-column layout as the default; this is the desktop-first direction, and the tests check that the breakpoint is actually there.

```html exercise id=stack-at-700 title="Stack the columns at 700px"
<div class="layout">
  <main>
    <p class="eyebrow">Field notes</p>
    <h1>What the rain taught us</h1>
    <p>Three seasons of building outdoor furniture has a way of simplifying your priorities. Water goes where it wants. Timber moves. Metal rusts quietly in the places you cannot see.</p>
    <p>So we changed the finish, raised the feet and stopped pretending that a cushion left outside all winter would be fine.</p>
  </main>
  <aside>
    <h2>Related</h2>
    <p>Choosing a weatherproof finish</p>
    <p>Repairing a split tenon</p>
  </aside>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem 1.25rem;
  }
  main, aside { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: 2rem; letter-spacing: -0.03em; }
  h2 { margin: 0 0 0.75rem; font-size: 1.1rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  aside p:last-child { margin-bottom: 0; }
</style>
--- solution
<div class="layout">
  <main>
    <p class="eyebrow">Field notes</p>
    <h1>What the rain taught us</h1>
    <p>Three seasons of building outdoor furniture has a way of simplifying your priorities. Water goes where it wants. Timber moves. Metal rusts quietly in the places you cannot see.</p>
    <p>So we changed the finish, raised the feet and stopped pretending that a cushion left outside all winter would be fine.</p>
  </main>
  <aside>
    <h2>Related</h2>
    <p>Choosing a weatherproof finish</p>
    <p>Repairing a split tenon</p>
  </aside>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem 1.25rem;
  }
  main, aside { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: 2rem; letter-spacing: -0.03em; }
  h2 { margin: 0 0 0.75rem; font-size: 1.1rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  aside p:last-child { margin-bottom: 0; }
  @media (max-width: 700px) {
    .layout { grid-template-columns: 1fr; }
  }
</style>
--- test
assertStyle(".layout", "display", "grid", "The layout still needs display: grid.");
const layout = query(".layout");
const columns = getComputedStyle(layout).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 2, "At the 1100px test viewport the layout should still have two columns, but it resolves to " + columns.length + ". Keep the two-column default and add a max-width query.");
let found = false;
for (const sheet of Array.from(document.styleSheets)) {
  let rules;
  try { rules = sheet.cssRules; } catch (error) { continue; }
  for (const rule of Array.from(rules)) {
    if (rule.type !== 4 || !rule.media) continue;
    const match = /max-width\s*:\s*(\d+)px/.exec(rule.media.mediaText);
    if (!match) continue;
    const breakpoint = Number(match[1]);
    if (breakpoint < 650 || breakpoint > 750) continue;
    for (const inner of Array.from(rule.cssRules)) {
      if (!inner.selectorText || !inner.selectorText.includes(".layout")) continue;
      const declarations = inner.style.cssText.replace(/\s+/g, " ");
      if (/grid-template-columns\s*:\s*(1fr|100%|auto|repeat\(\s*1\s*,\s*(?:1fr|100%)\s*\)|minmax\(0(?:px)?,\s*1fr\))/.test(declarations)) found = true;
      if (/display\s*:\s*(block|flex)/.test(declarations)) found = true;
    }
  }
}
assert(found, "At 1100px the layout is two columns, but I could not find a max-width media query near 700px that collapses .layout to one column.");
--- hint
The default should stay as it is. You are adding one rule at the end of the stylesheet.
--- hint
Start with `@media (max-width: 700px) { ... }`, then target `.layout` inside it.
--- hint
Inside the query, set `.layout { grid-template-columns: 1fr; }`. That gives the grid one full-width track.
```

## Challenge: a fluid headline

The headline in this masthead uses a fixed `56px`. It is dramatic on a laptop and too large on a phone. Replace it with a `clamp()` expression that includes a `vw` value in the middle, so it scales with the viewport between a sensible minimum and maximum.

Keep the line height and letter spacing. The tests check that the declaration is fluid, not that you chose one particular size.

```html exercise id=fluid-headline title="A headline that scales"
<header class="masthead">
  <p class="eyebrow">Field notes</p>
  <h1>Big views, small batches, one very long walk.</h1>
  <p class="lede">Notes from a season of building, walking and drinking coffee at the edge of the Peak District.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: 56px;
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 38rem; margin: 0; font-size: 1.1rem; line-height: 1.6; color: #475569; }
</style>
--- solution
<header class="masthead">
  <p class="eyebrow">Field notes</p>
  <h1>Big views, small batches, one very long walk.</h1>
  <p class="lede">Notes from a season of building, walking and drinking coffee at the edge of the Peak District.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 38rem; margin: 0; font-size: 1.1rem; line-height: 1.6; color: #475569; }
</style>
--- test
let css = "";
for (const sheet of Array.from(document.styleSheets)) {
  try { css += Array.from(sheet.cssRules).map((rule) => rule.cssText).join("\n"); } catch (error) {}
}
assert(/h1[^{}]*\{[^{}]*font-size\s*:\s*clamp\([^)]*\d+(?:\.\d+)?vw[^)]*\)/i.test(css), "The headline still uses a fixed font-size. Give h1 a clamp() value with a vw term in the middle, such as clamp(2.25rem, 5vw + 1rem, 4.5rem).");
const heading = query("h1");
const size = parseFloat(getComputedStyle(heading).fontSize);
assert(size >= 32 && size <= 96, "The headline computes to " + Math.round(size) + "px at this width, which is outside a comfortable display range. Check the clamp minimum and maximum.");
assertNoOverflow("The headline should wrap inside the masthead, not push the page sideways.");
assertText("h1", "Big views, small batches, one very long walk.", "Keep the headline text exactly as it is.");
--- hint
The value has three parts: a minimum, a preferred size and a maximum. Only the middle one needs `vw`.
--- hint
Try a minimum around `2.25rem`, a preferred value like `5vw + 1rem`, and a maximum around `4.5rem`.
--- hint
Replace `font-size: 56px;` with `font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);`.
```

## Debug: the photo that pushed the page sideways

This page scrolls sideways on a phone because the hero image has a fixed width of 1200 pixels. The container is capped at 960 pixels, so the image sticks out of the right edge and widens the whole document.

Fix the image so it fits its container without changing its aspect ratio. Do not crop it or hide the overflow; the whole photograph should remain visible.

```html debug id=sideways-photo title="The photo that pushed the page sideways"
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='1600' height='900'%3E%3Crect width='1600' height='900' fill='%230f172a'/%3E%3Ccircle cx='1180' cy='260' r='150' fill='%23fbbf24'/%3E%3Cpath d='M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z' fill='%230f766e'/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 960px; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { width: 1200px; height: 700px; border-radius: 16px; }
  .copy { max-width: 38rem; margin-top: 1.5rem; }
  h1 { margin: 0 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
--- solution
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='1600' height='900'%3E%3Crect width='1600' height='900' fill='%230f172a'/%3E%3Ccircle cx='1180' cy='260' r='150' fill='%23fbbf24'/%3E%3Cpath d='M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z' fill='%230f766e'/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 960px; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { display: block; width: 100%; max-width: 100%; height: auto; border-radius: 16px; }
  .copy { max-width: 38rem; margin-top: 1.5rem; }
  h1 { margin: 0 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
--- test
assertNoOverflow("The page still scrolls sideways. The image is wider than its container.");
const image = query(".hero img");
const hero = query(".hero");
const heroStyle = getComputedStyle(hero);
const contentWidth = hero.getBoundingClientRect().width - parseFloat(heroStyle.paddingLeft) - parseFloat(heroStyle.paddingRight);
const box = image.getBoundingClientRect();
assert(box.width <= contentWidth + 1, "The image renders " + Math.round(box.width) + "px wide inside a " + Math.round(contentWidth) + "px content area. Cap its width instead of fixing it to 1200px.");
assert(box.height > 100, "The image has collapsed to almost no height. Let the browser calculate it from the width.");
const naturalRatio = image.naturalWidth && image.naturalHeight ? image.naturalWidth / image.naturalHeight : 16 / 9;
const renderedRatio = box.width / box.height;
assert(Math.abs(renderedRatio - naturalRatio) < 0.03, "The image is stretched: it renders at " + renderedRatio.toFixed(2) + ":1 instead of its natural " + naturalRatio.toFixed(2) + ":1. Set height: auto.");
--- hint
The problem is the fixed `width: 1200px` and `height: 700px` on the image. A fixed width ignores the container.
--- hint
Use `max-width: 100%` so the image can never be wider than its parent.
--- hint
Set `height: auto` as well, so the image keeps its natural 16:9 shape instead of stretching.
```

> **In the wild:** Responsive images usually go further than `max-width`. The `<picture>` element and `srcset` let the browser choose a smaller file for a smaller screen, which saves bandwidth as well as layout trouble. You will meet those in the advanced course; `max-width: 100%; height: auto` remains the foundation underneath them.

## Recap

- The viewport meta tag makes a phone report its real width; without it, media queries fire at the wrong size.
- Mobile-first means narrow styles first, then `min-width` queries that add columns and space.
- `max-width` queries work the other way: wide styles first, then simplify below a breakpoint.
- Choose breakpoints where *your* content breaks, not at the dimensions of a particular phone.
- `max-width: 100%; height: auto` keeps images inside their container without distortion.
- `clamp(min, preferred, max)` gives display type a readable floor and ceiling; put a `vw` term in the middle.
- A CSS-only navigation can stack on narrow screens and become a row at a wider breakpoint.
- `prefers-reduced-motion: reduce` lets you remove decorative motion without removing function.

**Up next:** interaction polish — hover, focus, transitions and the small states that make a page feel finished.
