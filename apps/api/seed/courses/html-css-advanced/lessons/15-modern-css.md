CSS used to be a language you wrote *around* your markup. Modern CSS is a language you can write *with* it: nesting keeps a component's rules together, color functions describe intent instead of hex codes, scroll snap turns a long strip into a usable gallery, and feature queries let you ship an enhancement without abandoning the baseline.

None of these features is decoration. Each one removes a category of glue code or a class of bug. The craft is knowing which parts are safe to adopt, which need a fallback, and where an older technique is still the clearer choice.

## Nesting: proximity without surprise

Native nesting lets a rule live inside another rule and inherit its scope. `&` refers to the parent selector, so `& h2` means "an `h2` inside this component." The compiled meaning is close to the flat selector you would have written before, but the source stays readable: the card's padding, heading, tag and link are one block instead of four scattered selectors.

```html run
<article class="note-card">
  <p class="eyebrow">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p>Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; color: #1f2937; }
  .note-card {
    max-width: 34rem;
    padding: 1.5rem;
    border: 1px solid #d6d3d1;
    border-radius: 20px;
    background: #fffdf8;
    transition: border-color 160ms ease;

    & .eyebrow {
      margin: 0 0 0.5rem;
      color: #b45309;
      font-size: 0.72rem;
      font-weight: 700;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }

    & h2 { margin: 0 0 0.5rem; font-size: 1.6rem; letter-spacing: -0.03em; }
    & p { margin: 0 0 1rem; color: #57534e; line-height: 1.6; }
    & .cta { color: #0f766e; font-weight: 650; text-decoration: none; }
    &:hover { border-color: #0f766e; }
  }
</style>
```

Two details matter. First, a nested selector that omits `&` is still relative to the parent; `.note-card { p { ... } }` means `.note-card p`, not a global `p`. Second, `&` takes the specificity of the parent selector, similar to `:is()`. If the parent selector is a list, `&` uses the most specific selector in that list. That is useful, but it also means nesting can quietly raise specificity.

> **Pitfall:** Nesting is not a license to recreate a five-level Sass tree. If a selector needs four levels to find its target, the component probably needs a class, not a deeper nest. Deep nesting makes overrides harder and hides which element you are actually styling.

## Color that describes a relationship

Hex codes are absolute. Design systems need relationships: a softer version of the brand, a text color that works on a tinted surface, a hover state that is darker but still the same hue. `oklch()` describes color by lightness, chroma and hue, which makes those relationships easier to reason about. Relative color syntax goes further: it derives a new color from an existing token.

```html run
<div class="swatches">
  <div class="swatch brand">Brand</div>
  <div class="swatch soft">Soft</div>
  <div class="swatch mixed">Mixed</div>
</div>

<style>
  :root { --brand: oklch(55% 0.16 255); }
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .swatches { display: flex; flex-wrap: wrap; gap: 0.75rem; }
  .swatch { display: grid; place-items: center; min-width: 9rem; min-height: 5rem; border-radius: 14px; font-weight: 650; }

  .brand { background: #2563eb; background: var(--brand); color: #fff; }

  .soft {
    background: #dbeafe;
    background: oklch(from var(--brand) 93% calc(c * 0.25) h);
    color: #1e3a8a;
    color: oklch(from var(--brand) 32% c h);
  }

  .mixed {
    background: #93c5fd;
    background: color-mix(in oklab, var(--brand) 60%, #f59e0b);
    color: #172554;
  }
</style>
```

`oklch()` is **perceptually uniform**: the same lightness value looks roughly equally light across hues, which is not true of `hsl()`. That makes it a better space for generating tints, shades and accessible pairs. Relative syntax `oklch(from var(--brand) 93% calc(c * 0.25) h)` says: take the brand, keep its hue, reduce its chroma, and raise its lightness to 93%.

`color-mix()` is for blending two known colors. `color-mix(in oklab, var(--brand) 60%, #f59e0b)` produces a color that is 60% brand and 40% amber, mixed in a perceptual space. Use it for hover states, tinted badges and translucent overlays: `color-mix(in srgb, var(--brand) 12%, transparent)` is a clean way to make a brand wash without inventing another token.

> **Under the hood:** Browsers that support `oklch()` can render a wider gamut than sRGB on capable displays. Always keep a fallback declaration first. The fallback is not an insult to modern browsers; it is the baseline that lets an old browser show a usable page.

## Aspect ratio and scroll snap

`aspect-ratio` is the quiet workhorse of media layout. It reserves a box from a width or height, so a gallery can crop images consistently and a video can keep its shape before it loads. Combined with `object-fit: cover`, it gives you a stable frame with no magic numbers.

Scroll snap is the other half of a good horizontal gallery. The scroll container declares an axis and a strictness; each child declares where it wants to land. The browser handles momentum, touch and keyboard scrolling. You do not need a carousel library for a row of cards.

```html run
<section class="rail" tabindex="0" aria-label="Recent studio work">
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#0f172a"/><circle cx="200" cy="48" r="22" fill="#fbbf24"/><path d="M0 150 L80 70 L140 130 L200 84 L260 142 V180 H0Z" fill="#0f766e"/></svg>
    <figcaption>Ridge study</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#e7e5e4"/><rect x="38" y="38" width="184" height="104" rx="10" fill="#b45309"/><path d="M60 120 L105 70 L140 104 L172 64 L200 120Z" fill="#fff7ed"/></svg>
    <figcaption>Studio wall</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#dbeafe"/><path d="M0 132 Q70 58 140 118 T260 96 V180 H0Z" fill="#2563eb"/><circle cx="72" cy="54" r="20" fill="#f59e0b"/></svg>
    <figcaption>Blue hour</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#f5f5f4"/><rect x="42" y="48" width="70" height="84" rx="6" fill="#0f766e"/><rect x="124" y="72" width="94" height="60" rx="6" fill="#1f2937"/></svg>
    <figcaption>Two blocks</figcaption>
  </figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .rail {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    scroll-padding: 1rem;
    overscroll-behavior-inline: contain;
    border: 1px solid #e7e5e4;
    border-radius: 20px;
    background: #fff;
  }
  .rail:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  .slide { flex: 0 0 260px; margin: 0; scroll-snap-align: start; }
  .slide svg { display: block; width: 100%; aspect-ratio: 13 / 9; border-radius: 12px; }
  figcaption { margin-top: 0.6rem; color: #57534e; font-size: 0.85rem; }
</style>
```

`scroll-snap-type: x mandatory` tells the container to always settle on a snap point after scrolling. `mandatory` is confident, but it can trap a user between two tall panels; `proximity` is gentler. `scroll-snap-align: start` aligns the child's start edge with the container's snap area. `scroll-padding` keeps the first and last cards from touching the edge.

> **Tip:** A scrollable region should be reachable by keyboard. `tabindex="0"` on the container, plus a visible `:focus-visible` ring, makes the gallery usable without a mouse. Do not remove the scrollbar without providing another affordance.

## Challenge: a nested card component

Build the card from the first example, but write the child rules *inside* `.card` with `&`. The tests check the rendered result and that the stylesheet actually uses nesting.

```html exercise id=nested-field-card title="Build a nested card component"
<article class="card">
  <p class="tag">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p class="intro">Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; }
  /* TODO: style .card, then nest .tag, h2, p and .cta with & */
</style>
--- solution
<article class="card">
  <p class="tag">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p class="intro">Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card {
    max-width: 34rem;
    padding: 24px;
    border: 1px solid #d6d3d1;
    border-radius: 16px;
    background: #fffdf8;
    & .tag { margin: 0 0 8px; color: #b45309; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
    & h2 { margin: 0 0 8px; font-size: 24px; line-height: 1.2; }
    & p { margin: 0 0 16px; color: #57534e; line-height: 1.6; }
    & .cta { color: #0f766e; font-weight: 600; text-decoration: none; }
    &:hover { border-color: #0f766e; }
  }
</style>
--- test
assertStyle(".card", "padding", "24px");
assertStyle(".card", "border-radius", "16px");
assertColor(".card", "background-color", "#fffdf8");
assertStyle(".card h2", "margin-top", "0px");
assertStyle(".card h2", "font-size", "24px");
assertColor(".card .intro", "color", "#57534e");
assertColor(".card .tag", "color", "#b45309");
assertStyle(".card .tag", "text-transform", "uppercase");
assertStyle(".card .cta", "text-decoration-line", "none");
const css = Array.from(document.querySelectorAll("style")).map((s) => s.textContent).join("\n");
assert(css.includes("&"), "Use native nesting: put the child rules inside .card and reference the parent with &");
--- hint
Start with `.card { padding: 24px; border-radius: 16px; background: #fffdf8; }` and then add child rules inside the same block.
--- hint
`& .tag`, `& h2`, `& p` and `& .cta` keep the selectors scoped to the card.
--- hint
The heading needs `margin: 0 0 8px` and a `font-size` of `24px`; the paragraph should compute to `#57534e`.
```

## `:has()` in a real component

You have met `:has()` as a selector. The useful pattern is a **state container**: the ancestor reacts to a control inside it, and the components update without JavaScript or a pile of sibling selectors. A filterable gallery is a natural fit.

```html run
<section class="catalog">
  <div class="filters" role="group" aria-label="Filter by tone">
    <label><input type="radio" name="tone" value="all" checked> All</label>
    <label><input type="radio" name="tone" value="warm" id="warm"> Warm</label>
    <label><input type="radio" name="tone" value="cool" id="cool"> Cool</label>
  </div>
  <div class="grid">
    <article class="tile" data-tone="warm"><h2>Clay</h2><p>Warm, matte, honest.</p></article>
    <article class="tile" data-tone="cool"><h2>Slate</h2><p>Cool, quiet, precise.</p></article>
    <article class="tile" data-tone="warm"><h2>Amber</h2><p>A little sunlight in a box.</p></article>
    <article class="tile" data-tone="cool"><h2>Pine</h2><p>Deep green with a blue edge.</p></article>
  </div>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .catalog { max-width: 52rem; margin: 0 auto; }
  .filters { display: flex; gap: 1rem; margin-bottom: 1rem; color: #475569; font-size: 0.9rem; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 0.75rem; }
  .tile { padding: 1rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; transition: opacity 160ms ease, filter 160ms ease; }
  .tile h2 { margin: 0 0 0.25rem; font-size: 1rem; }
  .tile p { margin: 0; color: #64748b; font-size: 0.85rem; }
  .catalog:has(#warm:checked) .tile:not([data-tone="warm"]) { opacity: 0.25; filter: grayscale(1); }
  .catalog:has(#cool:checked) .tile:not([data-tone="cool"]) { opacity: 0.25; filter: grayscale(1); }
  @media (prefers-reduced-motion: reduce) { .tile { transition: none; } }
</style>
```

The filter is a radio group, so it is keyboard-accessible by default. The CSS reads the checked state from the ancestor and dims the tiles that do not match. No hidden classes, no event listeners, no state to synchronize. The tradeoff is that the filter state is visual only: the dimmed tiles are still in the accessibility tree. If the filter were a real product feature, you would also update the result count in text and consider whether hiding versus dimming is the honest interaction.

> **In the wild:** `:has()` is often used for form validation (`form:has(input:invalid)`), card layouts that react to an image, and navigation that highlights a section. It is powerful precisely because it lets a parent respond to a child.

## `@supports`: enhance, do not require

`@supports` asks the browser whether it understands a declaration. The base style goes outside the query; the enhancement goes inside. That order is the whole technique. If the enhancement is the only definition, an unsupported browser gets nothing.

```html run
<p class="badge">Progressive enhancement</p>
<p class="badge badge--quiet">The base style always renders</p>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .badge {
    display: inline-block;
    margin: 0 0 0.75rem;
    padding: 0.45rem 0.8rem;
    border: 1px solid #cbd5e1;
    border-radius: 999px;
    background: #e2e8f0;
    color: #0f172a;
    font-size: 0.8rem;
    font-weight: 650;
  }
  .badge--quiet { background: #fff; color: #475569; }

  @supports (color: oklch(50% 0.1 200)) {
    .badge {
      border-color: oklch(85% 0.05 200);
      background: oklch(94% 0.035 200);
      color: oklch(30% 0.06 200);
    }
  }
</style>
```

`@supports` can test a property-value pair, a selector with `selector(:has(*))`, or a negation with `not`. It cannot test whether a feature is *good* or whether the user wants it. Use it for visual upgrades, not for core layout. A page whose navigation only works when `@supports (display: grid)` passes is a page that is broken for someone.

`@starting-style` and view transitions are in the same category: enhancements. `@starting-style` gives an element an initial style for its first rendered frame, which lets a dialog or popover animate in without JavaScript. Same-document view transitions can animate between states when the DOM changes; cross-document transitions are arriving in browsers but still need a fallback. Both should sit behind a feature query or a `@media (prefers-reduced-motion: no-preference)` guard.

> **Pitfall:** Do not put the base declaration inside `@supports not (...)`. It reads as defensive, but it inverts the logic: the fallback becomes the special case, and a browser that supports neither branch gets nothing.

## Challenge: build a snap gallery

The starter is a horizontal row with overflow. Add scroll snapping, padding, and a focus ring so the row works with touch and keyboard. The tests check the computed snap behavior and that the content is actually wider than the viewport.

```html exercise id=studio-snap-gallery title="Build a snap gallery"
<section class="gallery" tabindex="0" aria-label="Studio work">
  <figure class="slide"><span>01</span><figcaption>Ridge study</figcaption></figure>
  <figure class="slide"><span>02</span><figcaption>Studio wall</figcaption></figure>
  <figure class="slide"><span>03</span><figcaption>Blue hour</figcaption></figure>
  <figure class="slide"><span>04</span><figcaption>Two blocks</figcaption></figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .gallery { display: flex; gap: 16px; overflow-x: auto; padding: 16px; border: 1px solid #e7e5e4; border-radius: 20px; background: #fff; }
  .slide { display: grid; place-items: center; flex: 0 0 260px; height: 180px; margin: 0; border-radius: 14px; background: #e7e5e4; color: #57534e; }
  .slide span { font-size: 2rem; font-weight: 700; }
  figcaption { font-size: 0.8rem; }
</style>
--- solution
<section class="gallery" tabindex="0" aria-label="Studio work">
  <figure class="slide"><span>01</span><figcaption>Ridge study</figcaption></figure>
  <figure class="slide"><span>02</span><figcaption>Studio wall</figcaption></figure>
  <figure class="slide"><span>03</span><figcaption>Blue hour</figcaption></figure>
  <figure class="slide"><span>04</span><figcaption>Two blocks</figcaption></figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .gallery {
    display: flex;
    gap: 16px;
    overflow-x: auto;
    padding: 16px;
    scroll-snap-type: x mandatory;
    scroll-padding: 16px;
    overscroll-behavior-inline: contain;
    border: 1px solid #e7e5e4;
    border-radius: 20px;
    background: #fff;
  }
  .gallery:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  .slide { display: grid; place-items: center; flex: 0 0 260px; height: 180px; margin: 0; scroll-snap-align: start; border-radius: 14px; background: #e7e5e4; color: #57534e; }
  .slide span { font-size: 2rem; font-weight: 700; }
  figcaption { font-size: 0.8rem; }
</style>
--- test
const gallery = query(".gallery");
assertStyle(".gallery", "display", "flex");
assertStyle(".gallery", "scroll-snap-type", "x mandatory");
assertStyle(".gallery", "overflow-x", "auto");
assertCount(".gallery .slide", 4, "Keep all four slides in the gallery");
assertFocusable(".gallery", "The scroll container should be reachable with the Tab key");
const slides = Array.from(document.querySelectorAll(".gallery .slide"));
slides.forEach((slide) => {
  const align = getComputedStyle(slide).scrollSnapAlign;
  assert(align === "start" || align === "center" || align === "end", `Each slide needs a scroll-snap-align; one computes to ${align}`);
});
assert(gallery.scrollWidth > gallery.clientWidth, "The gallery should actually overflow horizontally so there is something to snap through");
--- hint
Put `scroll-snap-type: x mandatory` on `.gallery`, and `scroll-snap-align: start` on each `.slide`.
--- hint
`scroll-padding` keeps the first card away from the edge. `overscroll-behavior-inline: contain` stops the scroll from chaining to the page.
--- hint
Keep `tabindex="0"` on the gallery and add `.gallery:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }`.
```

## Debug: the nested selector that went too far

This card contains an intro paragraph and a nested pull quote. The quote is supposed to stay muted and italic, but the card's `& p` rule reaches inside it and makes the quote text dark. Fix the nesting so the intro is dark and the quote keeps its own style.

```html debug id=nested-quote-scope title="The nested selector that went too far"
<article class="card">
  <h2>Field notes from the ridge</h2>
  <p class="intro">The weather turned at lunch, as it always does on this side of the valley.</p>
  <blockquote class="quote">
    <p>We ate sandwiches under a rock and pretended this was the plan.</p>
  </blockquote>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; color: #64748b; font-family: ui-sans-serif, system-ui, sans-serif; }
  .quote { margin: 0; padding-left: 1rem; border-left: 3px solid #cbd5e1; }
  .quote p { color: #64748b; font-style: italic; }
  .card {
    max-width: 36rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    & h2 { margin: 0 0 8px; font-size: 24px; color: #0f172a; }
    & p { margin: 0; color: #0f172a; line-height: 1.6; }
  }
</style>
--- solution
<article class="card">
  <h2>Field notes from the ridge</h2>
  <p class="intro">The weather turned at lunch, as it always does on this side of the valley.</p>
  <blockquote class="quote">
    <p>We ate sandwiches under a rock and pretended this was the plan.</p>
  </blockquote>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; color: #64748b; font-family: ui-sans-serif, system-ui, sans-serif; }
  .quote { margin: 0; padding-left: 1rem; border-left: 3px solid #cbd5e1; }
  .quote p { color: #64748b; font-style: italic; }
  .card {
    max-width: 36rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    & h2 { margin: 0 0 8px; font-size: 24px; color: #0f172a; }
    & > p { margin: 0; color: #0f172a; line-height: 1.6; }
  }
</style>
--- test
assertColor(".card > .intro", "color", "#0f172a");
assertColor(".quote p", "color", "#64748b");
assertStyle(".quote p", "font-style", "italic");
assertStyle(".card", "padding", "24px");
assertStyle(".card", "border-radius", "16px");
--- hint
`& p` means "any paragraph inside the card," including paragraphs inside a nested component.
--- hint
You want only the card's own intro paragraph. Use the child combinator: `& > p`.
--- hint
Keep the quote rule outside `.card`; it should win for the quote because it is more specific to that component.
```

## Predict: what does color-mix produce?

```html predict id=color-mix-chip title="What color is the chip?"
<p class="chip">Seasonal</p>
<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .chip {
    display: inline-block;
    padding: 0.5rem 0.9rem;
    border-radius: 999px;
    background: color-mix(in srgb, #f59e0b 55%, #ffffff);
    color: #431407;
    font-weight: 650;
  }
</style>
--- options
* A pale amber, lighter than the original
A saturated orange, darker than the original
Pure white
A dark brown
--- explain
`color-mix(in srgb, #f59e0b 55%, #ffffff)` mixes 55% amber with 45% white in the sRGB color space. Adding white raises all three channels, so the result is a tint: a pale amber. Mixing in `oklab` would produce a different, more perceptually even tint, but it would still be lighter. The percentage is the share of the first color, not the amount of white.
```

## Recap

- Native nesting keeps a component's rules together; `&` refers to the parent, and omitted `&` still means "inside this parent."
- Nesting does not make a selector local: `& p` reaches nested components, so use `& > p` or a class when the scope matters.
- `oklch()` gives perceptual lightness; relative color syntax derives tints and shades from one brand token.
- `color-mix()` blends two colors in a chosen space; keep a fallback declaration before it.
- `aspect-ratio` reserves a media box; scroll snap makes a horizontal rail usable without a carousel library.
- `:has()` lets a container react to a child's state, which is ideal for filters, forms and layout variants.
- `@supports` is for enhancements. The baseline belongs outside the query.
- `@starting-style` and view transitions are polish, not prerequisites. Guard them and respect reduced motion.

**Up next:** the first capstone. You will turn these primitives into a complete analytics dashboard: an app shell, accessible navigation, stat cards, a CSS-only chart and a data table that survives a narrow screen.
