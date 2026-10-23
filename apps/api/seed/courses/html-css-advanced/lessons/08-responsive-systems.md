A component does not know how wide the viewport is. It knows how much room its parent gave it. That distinction is the difference between a card that looks right on the marketing site and the same card looking broken inside a 320-pixel sidebar. Media queries answer the first question; container queries answer the second.

This lesson builds a responsive system rather than a set of breakpoints. You will make components respond to their own space, let type scale fluidly between a floor and a ceiling, use logical properties so the layout survives a change of writing direction, and respect the two preferences users actually set: less motion and a dark interface.

## Media queries answer the viewport

A media query is a condition on the **viewport** (and on user preferences, input capabilities and media type). It is excellent for page-level decisions: whether the navigation becomes a drawer, whether a hero uses a two-column layout, whether print styles apply. It is the wrong tool for a reusable component, because the component may appear in a wide main column and a narrow sidebar on the same screen.

```html run
<div class="row">
  <div class="slot narrow">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div>
        <h2>Ada Rao</h2>
        <p>Design engineer</p>
      </div>
    </article>
  </div>
  <div class="slot wide">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div>
        <h2>Ada Rao</h2>
        <p>Design engineer</p>
      </div>
    </article>
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; align-items: flex-start; }
  .slot { padding: 8px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .narrow { width: 300px; }
  .wide { width: 600px; }
  .profile { padding: 16px; border-radius: 12px; background: white; border: 1px solid #e2e8f0; }
  .avatar { display: grid; place-items: center; width: 56px; height: 56px; border-radius: 50%; background: #0f172a; color: white; font-weight: 700; }
  .profile h2 { margin: 0 0 4px; font-size: 1.1rem; color: #0f172a; }
  .profile p { margin: 0; color: #64748b; }
  @media (min-width: 700px) {
    .profile { display: grid; grid-template-columns: 56px 1fr; gap: 16px; align-items: center; }
  }
</style>
```

Both profiles switched to the horizontal layout at the same moment, because the viewport is 1100 pixels wide. The left slot is only 300 pixels wide, so the horizontal layout is cramped and the name has less room than it needs. The viewport gave the component information that was true for the page but false for the component.

> **Pitfall:** Adding more media queries does not fix this. You would need a query for every context the component might appear in, and the component would still break the first time a designer put it somewhere new. The missing information is the container's width.

## Container queries answer the component

A container query asks an ancestor for its size. You opt an element into being a **query container** with `container-type`, then write `@container` rules that apply to its descendants. The nearest ancestor with the required containment is the one that answers.

```html run
<div class="row">
  <div class="slot narrow">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div><h2>Ada Rao</h2><p>Design engineer</p></div>
    </article>
  </div>
  <div class="slot wide">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div><h2>Ada Rao</h2><p>Design engineer</p></div>
    </article>
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; align-items: flex-start; }
  .slot {
    container: profile / inline-size;
    padding: 8px;
    border: 1px dashed #cbd5e1;
    border-radius: 12px;
  }
  .narrow { width: 300px; }
  .wide { width: 600px; }
  .profile { padding: 16px; border-radius: 12px; background: white; border: 1px solid #e2e8f0; }
  .avatar { display: grid; place-items: center; width: 56px; height: 56px; border-radius: 50%; background: #0f172a; color: white; font-weight: 700; }
  .profile h2 { margin: 0 0 4px; font-size: 1.1rem; color: #0f172a; }
  .profile p { margin: 0; color: #64748b; }
  @container profile (min-width: 420px) {
    .profile { display: grid; grid-template-columns: 56px 1fr; gap: 16px; align-items: center; }
  }
</style>
```

Now the left profile stays vertical and the right one goes horizontal, even though both are on the same page at the same viewport width. The `container` shorthand sets a name (`profile`) and a type (`inline-size`). The name is optional; it becomes essential when nested containers could answer the same query.

`container-type: inline-size` applies **inline-size containment**: the container's inline size must not depend on its contents. In a horizontal writing mode that means its width. This is what makes the query possible without a circular dependency, but it also means the container needs a width from its parent — a grid track, a flex basis, a fixed width, or normal block flow. A container with `display: inline` and no width has nothing useful to report.

There are two practical rules that prevent most container-query bugs:

- A container query styles descendants, never the container itself. Put `container-type` on a wrapper, then query from the card inside it.
- The query measures the container's **content box**. Padding and borders reduce the inline size the query sees.
- `cqi` is one percent of the nearest query container's inline size. It is useful for spacing or type that should scale with the component rather than the viewport.

> **Under the hood:** `container-type: size` contains both axes and lets you query height as well as width, but the element then needs an explicit height. Most component queries should use `inline-size`; height-based queries are rare and much easier to get wrong.

## Predict: which query applies?

```html predict id=responsive-container-query title="Which container rule wins at 480px?"
<div class="panel">
  <p class="status">All systems normal</p>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    container-type: inline-size;
    width: 480px;
    box-sizing: border-box;
    padding: 20px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .status { margin: 0; color: #64748b; }
  @container (min-width: 360px) {
    .status { color: #0f766e; font-weight: 700; }
  }
  @container (min-width: 520px) {
    .status { color: #b91c1c; }
  }
</style>
--- options
* The status is teal and bold, because only the 360px query matches
The status is red, because the 520px query is more specific
The status stays grey, because the panel is exactly 480px
Both queries match, so the text alternates between teal and red
--- explain
Container queries are independent conditions, not a ladder of breakpoints. At a 440px content width (480px minus 40px of padding), the 360px query is true and the 520px query is false. Only one rule applies, so the status is teal and bold. If both matched, normal cascade order would decide; there is no special "larger query wins" rule.
```

## Challenge: make the card respond to its container

The card below already has a thumbnail and a body. It is set up to go horizontal when there is room, but the rule is a viewport media query, so both cards switch at 1100 pixels even though the left wrapper is only 300 pixels wide. Move the decision to the container.

Keep the existing markup and visual styles. Change the query so the 620-pixel card is horizontal and the 300-pixel card stays stacked. The wrappers already declare `container-type: inline-size`; you need to replace the media query with a container query and choose a sensible threshold.

```html exercise id=responsive-container-card title="Let the card respond to its container"
<div class="card-wrap narrow">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<div class="card-wrap wide">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<style>
  * { box-sizing: border-box; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card-wrap { container-type: inline-size; margin-bottom: 24px; }
  .narrow { width: 300px; }
  .wide { width: 620px; }
  .card { display: grid; gap: 16px; padding: 20px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { height: 120px; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .eyebrow { margin: 0 0 4px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .body h2 { margin: 0 0 6px; color: #0f172a; }
  .body p:last-child { margin: 0; color: #475569; line-height: 1.5; }
  @media (min-width: 700px) {
    .card { grid-template-columns: 150px 1fr; align-items: center; }
  }
</style>
--- solution
<div class="card-wrap narrow">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<div class="card-wrap wide">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<style>
  * { box-sizing: border-box; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card-wrap { container-type: inline-size; margin-bottom: 24px; }
  .narrow { width: 300px; }
  .wide { width: 620px; }
  .card { display: grid; gap: 16px; padding: 20px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { height: 120px; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .eyebrow { margin: 0 0 4px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .body h2 { margin: 0 0 6px; color: #0f172a; }
  .body p:last-child { margin: 0; color: #475569; line-height: 1.5; }
  @container (min-width: 420px) {
    .card { grid-template-columns: 150px 1fr; align-items: center; }
  }
</style>
--- test
assertStyle(".card-wrap", "container-type", "inline-size");
const narrowThumb = query(".narrow .thumb").getBoundingClientRect();
const narrowBody = query(".narrow .body").getBoundingClientRect();
const wideThumb = query(".wide .thumb").getBoundingClientRect();
const wideBody = query(".wide .body").getBoundingClientRect();
assert(narrowBody.top >= narrowThumb.bottom - 1, "In the 300px container the body is still beside the thumbnail. It should stack below it.");
assert(wideBody.left >= wideThumb.right + 8, "In the 620px container the body should sit to the right of the thumbnail, not below it.");
assertColor(".wide .card", "background-color", "#ffffff");
--- hint
The wrapper is already a query container. The card needs a rule that responds to the wrapper's width, not the viewport's.
--- hint
Replace `@media (min-width: 700px)` with `@container (min-width: 420px)`. The `.card` selector stays the same because the query applies to the container's descendants.
```

The threshold is a design decision, not a magic number. What matters is that the card has enough room for a 150-pixel thumbnail, a gap and a readable measure of text. A container query lets that decision travel with the component instead of being tied to the screen it happens to be on.

## Fluid type with `clamp()`

Breakpoints are a blunt instrument for typography. A headline that jumps from 32 to 48 pixels at exactly 768 pixels looks like a decision someone made in a meeting. Fluid type lets the size move continuously between a minimum and a maximum, with a preferred value that responds to the viewport.

`clamp(min, preferred, max)` returns the preferred value, pushed up to the minimum if it is too small and down to the maximum if it is too large. The preferred value is usually a mix of `rem` and `vw`: the `vw` makes it fluid, and the `rem` keeps it connected to the user's font size.

```html run
<h1 class="hero-title">The long way round</h1>
<p class="meta">A field guide to taking the scenic route, for people who still read the signs.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .hero-title {
    margin: 0 0 12px;
    max-width: 16ch;
    font-size: clamp(2.5rem, 1.5rem + 4vw, 5rem);
    line-height: 1.02;
    letter-spacing: -0.04em;
  }
  .meta { max-width: 46ch; margin: 0; color: #475569; line-height: 1.6; }
</style>
```

At 1100 pixels the preferred value is `24px + 44px`, so the headline lands around 68 pixels: above the 40-pixel floor, below the 80-pixel ceiling. Shrink the preview and it slides down toward 40; widen it and it stops at 80. No breakpoint is involved.

Three rules keep fluid type readable:

- **Use `rem` in the minimum and maximum.** A pure `vw` formula ignores the user's text-size setting and can fail a zoom test. `2.5rem` respects the root font size.
- **Choose a minimum that still fits the smallest supported screen.** A 16-character headline at 40 pixels may still wrap to four lines on a 320-pixel phone; test it.
- **Keep the preferred term simple.** `1.5rem + 4vw` is readable. A chain of three `calc()` expressions is a sign that the type scale needs a designer, not more arithmetic.

> **Pitfall:** If the minimum is larger than the maximum, `clamp()` does not "fix" the order. The minimum wins, because the function is defined as `max(min, min(preferred, max))`. If the preferred expression is invalid, the whole declaration is dropped and the element falls back to its inherited or user-agent size. Both mistakes look like "the font size is ignoring me."

## Challenge: a fluid hero headline

The hero already has the copy and the layout. The headline is stuck at 28 pixels, which is fine on a phone and far too timid on a desktop. Give it a fluid size that stays readable on small screens and grows to a confident display size on wide ones.

Use `clamp()` with a minimum of `2rem`, a preferred value of `1rem + 3.5vw`, and a maximum of `4.5rem`. At this viewport the result should land between 48 and 62 pixels.

```html exercise id=responsive-fluid-hero title="Give the hero a fluid headline"
<section class="hero">
  <p class="eyebrow">Field notes · Issue 14</p>
  <h1 class="hero-title">The long way round is usually the right way</h1>
  <p class="lede">A slower route, a heavier pack and a better story at the end of it.</p>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 900px; }
  .eyebrow { margin: 0 0 10px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .hero-title {
    margin: 0 0 16px;
    max-width: 18ch;
    color: #0f172a;
    font-size: 28px;
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 48ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- solution
<section class="hero">
  <p class="eyebrow">Field notes · Issue 14</p>
  <h1 class="hero-title">The long way round is usually the right way</h1>
  <p class="lede">A slower route, a heavier pack and a better story at the end of it.</p>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 900px; }
  .eyebrow { margin: 0 0 10px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .hero-title {
    margin: 0 0 16px;
    max-width: 18ch;
    color: #0f172a;
    font-size: clamp(2rem, 1rem + 3.5vw, 4.5rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 48ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- test
const title = query(".hero-title");
const size = parseFloat(getComputedStyle(title).fontSize);
assert(size >= 48 && size <= 62, `At this viewport the headline computes to ${size}px. The fluid range should put it between 48 and 62px.`);
let cssText = "";
for (const sheet of Array.from(document.styleSheets)) {
  try {
    for (const rule of Array.from(sheet.cssRules)) cssText += rule.cssText + " ";
  } catch (error) {}
}
assert(/clamp\(/.test(cssText), "The headline size should come from clamp(), so it can scale between a minimum and a maximum instead of sitting at one fixed value.");
assertColor(".hero-title", "color", "#0f172a");
--- hint
Replace the fixed `28px` with a `clamp()` whose middle term mixes `rem` and `vw`.
--- hint
`clamp(2rem, 1rem + 3.5vw, 4.5rem)` gives you the floor, the fluid middle and the ceiling. Keep the line-height and letter-spacing you already have.
```

The test reads the computed size at 1100 pixels, which is why the expected range is narrow. The stylesheet check is there because a fixed `54px` would happen to pass the geometry check at this one width while failing the actual goal: a size that responds to the viewport.

## Debug: the headline that will not scale

This display headline is supposed to be fluid, but it renders at the browser's default heading size. The `clamp()` middle term has a syntax error, so the browser throws away the entire `font-size` declaration. Fix the expression.

The intended formula is `clamp(2rem, 1rem + 3vw, 4rem)`. At 1100 pixels that should land near 49 pixels, not 32.

```html debug id=responsive-broken-clamp title="The headline ignores its clamp"
<h1 class="display">Trail notes for the long way round</h1>
<p class="standfirst">A slower route, a heavier pack and a better story at the end of it.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .display {
    max-width: 14ch;
    margin: 0 0 16px;
    color: #0f172a;
    font-size: clamp(2rem, 1rem +, 4rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .standfirst { max-width: 46ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- solution
<h1 class="display">Trail notes for the long way round</h1>
<p class="standfirst">A slower route, a heavier pack and a better story at the end of it.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .display {
    max-width: 14ch;
    margin: 0 0 16px;
    color: #0f172a;
    font-size: clamp(2rem, 1rem + 3vw, 4rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .standfirst { max-width: 46ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- test
const size = parseFloat(getComputedStyle(query(".display")).fontSize);
assert(size >= 45 && size <= 53, `The headline computes to ${size}px. The intended clamp should land near 49px at this width; the current declaration is being dropped.`);
assertColor(".display", "color", "#0f172a");
--- hint
Open the preview and inspect the headline. If the size looks like the browser's default `h1`, the declaration probably never parsed.
--- hint
The middle term `1rem +` is incomplete. It needs a value after the plus sign before the comma: `1rem + 3vw`.
```

The browser does not warn you about an invalid declaration. It parses the rule, finds the value invalid, drops that declaration and moves on. The only symptom is the fallback: in this case the user-agent `h1` size. A missing closing parenthesis or a stray comma produces the same silent failure.

## Viewport units and the mobile chrome problem

`100vh` sounds like "the height of the screen". On a phone it has historically meant the height of the **largest** viewport, the one you get after the address bar hides. A hero set to `100vh` therefore extends under the browser chrome, and the bottom of the content is hidden until the user scrolls. The modern viewport units fix that by naming the three sizes explicitly.

```html run
<section class="masthead">
  <p class="kicker">Issue 14 · Field notes</p>
  <h1>Walk until the map runs out.</h1>
  <p class="intro">A slower route, a heavier pack and a better story at the end of it.</p>
</section>
<p class="below">The next section starts after the masthead. The masthead uses the dynamic viewport unit, so it is never taller than the visible screen.</p>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .masthead {
    display: grid;
    align-content: center;
    min-height: 60vh;
    min-height: 60dvh;
    padding: 32px;
    background: linear-gradient(150deg, #0f172a, #0f766e);
    color: white;
  }
  .kicker { margin: 0 0 12px; font-size: 12px; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; color: #99f6e4; }
  .masthead h1 { max-width: 14ch; margin: 0 0 12px; font-size: clamp(2.5rem, 1.5rem + 4vw, 5rem); line-height: 1.02; letter-spacing: -0.04em; }
  .intro { max-width: 44ch; margin: 0; color: #ccfbf1; line-height: 1.6; }
  .below { max-width: 620px; margin: 0; padding: 24px 32px; color: #475569; line-height: 1.6; }
</style>
```

The three units are:

| Unit | Meaning |
|---|---|
| `svh` | Small viewport height: the screen with the browser chrome visible. |
| `lvh` | Large viewport height: the screen with the chrome hidden. |
| `dvh` | Dynamic viewport height: changes as the chrome shows or hides. |

Use `svh` when you need a guaranteed fit, `lvh` when you are deliberately filling the screen, and `dvh` when you want the layout to track the visible area. `dvh` updates during scrolling, which can cause extra layout work; do not use it on every element. Always keep a `vh` fallback immediately before it for older engines.

> **Pitfall:** Avoid `width: 100vw` for full-width elements. `vw` includes the vertical scrollbar in some desktop browsers, so a `100vw` element can create horizontal overflow. Use `width: 100%` or the parent's block size instead.

## Aspect ratio and a responsive spacing scale

`aspect-ratio` reserves space before an image or video loads, which prevents the layout from jumping when the media arrives. It also lets a decorative panel keep a deliberate shape as its width changes. If you set both the width and the height, `aspect-ratio` is ignored; it is a preference, not a command.

```html run
<div class="gallery">
  <article class="tile">
    <div class="thumb" aria-hidden="true"></div>
    <h2>Ridge line</h2>
    <p>A steady climb with a view that arrives all at once.</p>
  </article>
  <article class="tile">
    <div class="thumb alt" aria-hidden="true"></div>
    <h2>Valley floor</h2>
    <p>An easier walk, a longer lunch and more birds.</p>
  </article>
</div>

<style>
  :root { --gap: clamp(12px, 1rem + 1vw, 24px); }
  body { margin: 0; padding: var(--gap); font-family: system-ui, sans-serif; background: #f8fafc; }
  .gallery { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: var(--gap); max-width: 820px; }
  .tile { padding: var(--gap); border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { aspect-ratio: 16 / 9; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .thumb.alt { background: linear-gradient(135deg, #7c2d12, #f59e0b); }
  .tile h2 { margin: 12px 0 6px; font-size: 1.1rem; color: #0f172a; }
  .tile p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The spacing token is a small responsive system of its own. `clamp(12px, 1rem + 1vw, 24px)` grows with the viewport but never collapses below 12 pixels or balloons past 24. Use a handful of these tokens for section padding, card gaps and page gutters instead of writing a new media query for every spacing value.

For replaced content, pair the ratio with `object-fit`:

```css
.thumb img { width: 100%; height: 100%; object-fit: cover; }
```

The ratio decides the box; `object-fit` decides how the image fills it without distortion.

## Logical properties survive a change of direction

Physical properties name sides: `margin-left`, `padding-top`, `border-right`. Logical properties name **axes**: inline (the direction text runs) and block (the direction lines stack). In English, inline is left-to-right and block is top-to-bottom. In Arabic or Hebrew, inline is right-to-left. In vertical writing modes, the axes rotate again.

```html run
<div class="stack">
  <div class="callout" dir="ltr">
    <strong>Left-to-right:</strong> the accent sits on the inline-start edge.
  </div>
  <div class="callout" dir="rtl">
    <strong>Right-to-left:</strong> the same CSS puts the accent on the other side.
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stack { display: grid; gap: 12px; max-width: 560px; }
  .callout {
    border-inline-start: 4px solid #0f766e;
    padding-inline: 16px;
    padding-block: 12px;
    margin-inline-start: 8px;
    border-radius: 8px;
    background: white;
    color: #334155;
    line-height: 1.5;
    text-align: start;
  }
</style>
```

The CSS is identical for both boxes. Only the `dir` attribute changes, and the accent, padding and margin follow the writing direction. The same vocabulary scales to sizes: `inline-size` is the width in a horizontal writing mode, `block-size` is the height, and `inset-inline-start` replaces `left` when you mean "the start of the line" rather than "the left of the screen".

Adopting logical properties is mostly a naming discipline. Start with the properties you use most — `margin-inline`, `padding-block`, `inset-inline`, `border-inline-start` — and use physical properties only when you genuinely mean a physical side, such as a shadow that must fall downward regardless of direction.

## Preferences are part of the system

Two media queries deserve a place in every component library: `prefers-reduced-motion` and `prefers-color-scheme`. The first is an accessibility requirement, not a nicety. The second is an expectation users have learned from their operating system.

```html run
<article class="notice">
  <h2>Your export is ready</h2>
  <p>The CSV contains 14,208 rows and is available for the next 24 hours.</p>
  <button type="button">Download CSV</button>
</article>

<style>
  :root {
    color-scheme: light dark;
    --page: #f8fafc;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
  }
  @media (prefers-color-scheme: dark) {
    :root { --page: #020617; --surface: #0f172a; --text: #e2e8f0; --muted: #94a3b8; }
  }
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: var(--page); color: var(--text); }
  .notice {
    max-width: 480px;
    padding: 24px;
    border: 1px solid color-mix(in srgb, var(--muted) 30%, transparent);
    border-radius: 14px;
    background: var(--surface);
    color: var(--text);
    transition: background-color 200ms ease, color 200ms ease;
  }
  .notice h2 { margin: 0 0 8px; font-size: 1.2rem; }
  .notice p { margin: 0 0 18px; color: var(--muted); line-height: 1.5; }
  .notice button { padding: 10px 14px; border: 0; border-radius: 9px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  @media (prefers-reduced-motion: reduce) {
    .notice { transition: none; }
  }
</style>
```

`color-scheme: light dark` tells the browser the page supports both schemes and lets it style form controls, scrollbars and the canvas to match. The custom properties swap the surface and text colours; `color-mix()` derives a border without a fourth token. The reduced-motion query removes the colour transition for people who have asked the system to minimise animation.

> **Tip:** Test both preferences in the browser's rendering panel. In Chrome DevTools, open **Rendering**, then set **Emulate CSS media feature prefers-color-scheme** and **prefers-reduced-motion**. Testing only the default state is how a dark theme ships with unreadable grey text.

## Testing at multiple widths

A responsive system is not verified by resizing the browser once. Test at least three viewport widths — 320, 768 and 1440 pixels — and, separately, at the container widths your components actually encounter. The component that looks fine at 1440 may sit in a 280-pixel sidebar on that same screen.

A practical checklist:

- At 320 pixels, does anything overflow horizontally? Check long words, code blocks, tables and fixed-width media.
- At 200% zoom, does the layout still work, or does it assume a desktop viewport and clip?
- Does every interactive element remain reachable by keyboard, and does the focus ring remain visible?
- Do images reserve their space with `aspect-ratio` or explicit dimensions, so the page does not shift while loading?
- Does the component still look intentional when its container is much narrower or wider than the viewport?
- With reduced motion and dark mode enabled, are the final states still visible and legible?

> **In the wild:** Design systems often ship a "container test bench": the same component rendered at 280, 420, 640 and 960 pixels on one page. It catches container-query assumptions faster than any amount of viewport resizing, and it becomes a visual regression target for the team.

## Recap

- Media queries answer the viewport; container queries answer the component's nearest query container.
- `container-type: inline-size` makes an element a query container. Query its descendants, not itself, and remember that padding reduces the content-box width.
- `clamp(min, preferred, max)` creates fluid type with a floor and a ceiling. Use `rem` in the min and max, and keep the preferred term simple.
- `svh`, `lvh` and `dvh` describe the small, large and dynamic viewport. Avoid `100vw` for full-width blocks.
- `aspect-ratio` reserves space and prevents layout shift; `object-fit` controls how replaced content fills the box.
- Logical properties (`margin-inline`, `padding-block`, `inset-inline`) follow the writing direction instead of the physical screen.
- Respect `prefers-reduced-motion` and `prefers-color-scheme`, and test components at container widths, not just viewport widths.

**Up next:** motion — transitions, transforms and keyframes that make state changes legible without making the interface feel like a slideshow.



