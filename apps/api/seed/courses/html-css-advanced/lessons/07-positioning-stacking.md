Normal flow is the layout the browser would choose if you said nothing. Block boxes stack vertically, inline boxes run along a line, and every box takes up exactly the space its content needs. Most of the time that is the correct layout. Positioning becomes necessary when you need a badge on a card, a header that stays visible, a menu that overlaps the page, or a dialog above everything else.

The trouble starts when positioning is used as a shortcut for layout. An absolutely positioned element is removed from flow, so it no longer pushes its neighbours around; a `z-index` arms race begins the moment two positioned elements overlap. This lesson builds the model underneath both: what a positioned element is positioned *against*, and which stacking context actually decides who paints on top.

## Normal flow is the baseline

In normal flow, a block-level element's width is constrained by its containing block and its height is decided by its content. Its siblings sit above and below it. Inline elements sit on a line, wrap at spaces, and reserve only the width of their text.

`position: relative` is the gentlest departure from that model. The element is still laid out exactly where it would have been, and it still reserves its original space. The `top`, `right`, `bottom` and `left` values (or the logical `inset-*` equivalents) then shift the painted box without moving its neighbours. That is why a relatively positioned element can overlap the next paragraph while leaving a gap where it used to be.

```html run
<figure class="photo">
  <div class="sky" aria-hidden="true"></div>
  <figcaption class="caption">Kinder Scout, 6:12am</figcaption>
</figure>
<p class="note">The caption is positioned against the figure, not against the page.</p>

<style>
  body { margin: 0; padding: 28px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .photo {
    position: relative;
    max-width: 520px;
    margin: 0;
    border-radius: 14px;
    overflow: hidden;
  }
  .sky {
    height: 240px;
    background: linear-gradient(160deg, #0f172a, #0f766e 60%, #f59e0b);
  }
  .caption {
    position: absolute;
    left: 16px;
    bottom: 16px;
    padding: 6px 10px;
    border-radius: 999px;
    background: rgb(15 23 42 / 0.8);
    color: white;
    font-size: 13px;
  }
  .note { max-width: 520px; color: #475569; line-height: 1.5; }
</style>
```

The figure is the **containing block** for the caption. Remove `position: relative` from `.photo` and the caption would position itself against the initial containing block — the viewport-sized box at the root of the document — and appear in the bottom-left corner of the page. The gradient would still be there; the caption would simply belong to a different coordinate system.

## The containing block is the contract

For an absolutely positioned element, the containing block is the padding box of the nearest ancestor whose `position` is not `static`. If no such ancestor exists, it is the initial containing block. This is the single most useful rule in the lesson: **absolute positioning is relative to an ancestor, not to the element before it in the markup.**

```html run
<div class="field">
  <label for="email">Work email</label>
  <div class="control">
    <input id="email" type="email" placeholder="you@studio.co">
    <button class="help" type="button" aria-label="Email help">?</button>
    <div class="tooltip" role="tooltip">We only use this for receipts and build alerts.</div>
  </div>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .field { max-width: 380px; }
  label { display: block; margin-bottom: 8px; font-weight: 600; color: #0f172a; }
  .control { position: relative; }
  input { width: 100%; box-sizing: border-box; padding: 12px 44px 12px 14px; border: 1px solid #cbd5e1; border-radius: 10px; font: inherit; }
  .help {
    position: absolute; top: 50%; right: 10px; translate: 0 -50%;
    width: 28px;
    height: 28px;
    border: 0;
    border-radius: 50%;
    background: #0f172a;
    color: white;
    font-weight: 700;
    cursor: help;
  }
  .tooltip {
    position: absolute;
    top: calc(100% + 8px);
    left: 0;
    padding: 10px 12px;
    border-radius: 8px;
    background: #0f172a;
    color: #e2e8f0;
    font-size: 13px;
    line-height: 1.4;
  }
</style>
```

The button and tooltip both use `.control` as their containing block. The button is centred vertically with `top: 50%` and `translate: 0 -50%`; the tooltip starts just below the control with `top: calc(100% + 8px)`. Neither of those percentages refers to the input, the label or the viewport. They refer to the padding box of `.control`.

A few consequences follow:

- If you forget `position: relative` on the parent, the element escapes to the nearest positioned ancestor — often the page — and lands somewhere surprising when the page scrolls.
- `position: fixed` is similar, but its containing block is the viewport unless an ancestor has a `transform`, `filter`, `perspective`, `contain` or `will-change` that creates a containing block. That exception is a common source of "why is my fixed header moving with the page?"
- Absolute positioning does not reserve space. If the positioned element is the only thing giving a container height, the container collapses.

> **Pitfall:** `inset: 0` on an absolutely positioned element makes it fill its containing block only when the element has no width or height constraints that fight it. For a centred box, `inset: 0; width: 240px; height: 120px; margin: auto;` is a legitimate pattern, but `display: grid; place-items: center` is usually easier to read.

## Challenge: a badge in the corner

Product cards often need a small status marker: "New", "Low stock", "Staff pick". The badge should sit in the top-right corner of the card without pushing the heading or the description around. The card already has the right size and spacing; the badge is currently an ordinary inline element at the end of the content.

Make the card the badge's containing block and pin the badge to the top-right corner with a 12-pixel inset.

```html exercise id=position-card-badge title="Pin a badge to the card corner"
<article class="card">
  <p class="eyebrow">Trailhead Coffee</p>
  <h2>Winter blend</h2>
  <p>Dark chocolate, dried cherry and a finish that lasts longer than the walk home.</p>
  <span class="badge">New</span>
</article>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    width: 360px;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: white;
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 999px;
    background: #b45309;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
</style>
--- solution
<article class="card">
  <p class="eyebrow">Trailhead Coffee</p>
  <h2>Winter blend</h2>
  <p>Dark chocolate, dried cherry and a finish that lasts longer than the walk home.</p>
  <span class="badge">New</span>
</article>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    position: relative;
    width: 360px;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: white;
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .badge {
    position: absolute;
    top: 12px;
    right: 12px;
    display: inline-block;
    padding: 4px 10px;
    border-radius: 999px;
    background: #b45309;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
</style>
--- test
assertStyle(".card", "position", "relative");
assertStyle(".badge", "position", "absolute");
const card = query(".card").getBoundingClientRect();
const badge = query(".badge").getBoundingClientRect();
assert(badge.width < card.width / 2, "The badge should stay compact, not stretch across the card.");
const topGap = badge.top - card.top;
const rightGap = card.right - badge.right;
assert(topGap >= 0 && topGap <= 24, `The badge's top edge is ${Math.round(topGap)}px from the card's top edge. Pin it near the corner.`);
assert(rightGap >= 0 && rightGap <= 24, `The badge's right edge is ${Math.round(rightGap)}px from the card's right edge. Pin it near the corner.`);
assertColor(".badge", "background-color", "#b45309");
--- hint
The badge needs to be positioned against the card, so the card must become its containing block.
--- hint
Add `position: relative` to `.card`, then `position: absolute; top: 12px; right: 12px` to `.badge`.
```

A badge in the corner is a small example of a large principle: position the *relationship*, not the pixels. The card owns the coordinate system; the badge declares where it sits inside it. Move the card and the badge follows. Change the card's width and the badge stays pinned to the right edge.

## Sticky is a hybrid

`position: sticky` starts in normal flow and behaves like `relative` until the element crosses a threshold inside its nearest scrolling ancestor. Then it behaves like `fixed` for as long as its containing block remains in view. When the parent scrolls out, the sticky element goes with it. That last clause is what separates sticky from fixed.

```html run
<div class="frame">
  <header class="frame-header">Trailhead / Build log</header>
  <main class="frame-body">
    <p>08:02 — Deploy started.</p>
    <p>08:03 — Assets uploaded.</p>
    <p>08:04 — Cache warmed in three regions.</p>
    <p>08:05 — Health checks passed.</p>
    <p>08:06 — Traffic shifted to the new release.</p>
    <p>08:07 — Queue drained.</p>
    <p>08:08 — Deploy complete.</p>
  </main>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .frame {
    max-width: 620px;
    height: 280px;
    overflow: auto;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .frame-header {
    position: sticky;
    top: 0;
    z-index: 2;
    padding: 14px 18px;
    background: #0f172a;
    color: white;
    font-weight: 700;
  }
  .frame-body { padding: 4px 18px 18px; color: #334155; line-height: 1.6; }
</style>
```

Scroll the frame and the header stays at the top. It is not fixed to the browser window; it is stuck to the top of the scroll container. The requirements are precise:

1. A threshold is set: `top`, `bottom`, `left` or `right`. Without one, sticky behaves like relative.
2. The element has a scrolling ancestor. If no ancestor scrolls, the page is the scroll container and the element sticks relative to the viewport.
3. The containing block is taller than the sticky element, so there is room to stick before the parent leaves.
4. No ancestor between the element and the scroll container has an `overflow` value that creates an unexpected scroll container. `overflow: hidden` is a frequent culprit.

> **Tip:** A sticky element inside a flex or grid container may stretch to the container's cross size, leaving no room to move. Set `align-self: start` so it keeps its content height.

## Challenge: a sticky site header

Build a header that stays at the top of the page while the article scrolls underneath it. The header already has the dark visual treatment, but it is only relatively positioned, so it scrolls away with the content. It also needs to paint above the article.

The test scrolls the page and checks where the header ends up, so a header that merely has `top: 0` without `position: sticky` will not pass.

```html exercise id=position-sticky-header title="Keep the header at the top"
<header class="site-header">
  <strong>Trailhead Field Notes</strong>
  <nav><a href="#">Archive</a> <a href="#">About</a></nav>
</header>
<main>
  <section><h1>Why the long way round is usually right</h1><p>An essay in four uphill sections.</p></section>
  <section><h2>One: the car park</h2><p>Every walk begins with a decision you cannot undo.</p></section>
  <section><h2>Two: the ridge</h2><p>The wind arrives before the view does.</p></section>
  <section><h2>Three: the descent</h2><p>Knees complain. The light compensates.</p></section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .site-header {
    position: relative;
    top: 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    padding: 16px 24px;
    background: #0f172a;
    color: white;
  }
  .site-header a { color: #cbd5e1; text-decoration: none; margin-left: 12px; }
  main { max-width: 720px; margin: 0 auto; padding: 24px; }
  section { min-height: 280px; border-bottom: 1px solid #e2e8f0; }
  h1, h2 { letter-spacing: -0.02em; }
  p { color: #475569; line-height: 1.6; }
</style>
--- solution
<header class="site-header">
  <strong>Trailhead Field Notes</strong>
  <nav><a href="#">Archive</a> <a href="#">About</a></nav>
</header>
<main>
  <section><h1>Why the long way round is usually right</h1><p>An essay in four uphill sections.</p></section>
  <section><h2>One: the car park</h2><p>Every walk begins with a decision you cannot undo.</p></section>
  <section><h2>Two: the ridge</h2><p>The wind arrives before the view does.</p></section>
  <section><h2>Three: the descent</h2><p>Knees complain. The light compensates.</p></section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .site-header {
    position: sticky;
    top: 0;
    z-index: 10;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    padding: 16px 24px;
    background: #0f172a;
    color: white;
  }
  .site-header a { color: #cbd5e1; text-decoration: none; margin-left: 12px; }
  main { max-width: 720px; margin: 0 auto; padding: 24px; }
  section { min-height: 280px; border-bottom: 1px solid #e2e8f0; }
  h1, h2 { letter-spacing: -0.02em; }
  p { color: #475569; line-height: 1.6; }
</style>
--- test
assertStyle(".site-header", "position", "sticky");
assertStyle(".site-header", "top", "0px");
const z = Number(getComputedStyle(query(".site-header")).zIndex);
assert(z >= 10, `The header's z-index is ${z}. It needs to sit above the scrolling article.`);
window.scrollTo(0, 300);
const top = query(".site-header").getBoundingClientRect().top;
assert(Math.abs(top) < 2, `After scrolling 300px, the header sits ${Math.round(top)}px from the top of the viewport. It should stick at the top.`);
assertColor(".site-header", "background-color", "#0f172a");
--- hint
`position: relative` shifts an element but still lets it scroll away. You need the value that switches between relative and fixed as the page moves.
--- hint
Use `position: sticky`, keep `top: 0`, and give the header a `z-index` so the article cannot paint over it.
```

The `z-index` is not decoration. A sticky header is still in flow, and later content can paint over it if the header has no stacking position. Raising it above the article is part of making the pattern work, not an optional flourish.

## z-index is local, not global

`z-index` only sorts elements **within the same stacking context**. A stacking context is a self-contained layer: everything inside it is painted as one unit relative to its siblings, and no child can escape to outrank an element outside the context, no matter how large its `z-index` is.

A stacking context is created by more things than `position: absolute` plus `z-index`:

- the root element
- a positioned element with a `z-index` other than `auto`
- a fixed or sticky element
- a flex or grid item with a `z-index` other than `auto`
- `opacity` less than `1`
- `transform`, `filter`, `perspective`, `clip-path` or `backdrop-filter` with a value other than `none`
- `isolation: isolate`
- `will-change` naming a property that would create one
- `contain: layout`, `contain: paint` or `contain: strict`

```html run
<div class="stage">
  <div class="context">
    <span class="context-label">parent · isolation: isolate</span>
    <div class="high">child · z-index: 99</div>
  </div>
  <div class="low">sibling · z-index: 1</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stage { position: relative; height: 260px; max-width: 600px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .context {
    position: absolute; top: 28px; left: 28px;
    width: 320px; height: 170px;
    padding: 12px;
    border-radius: 10px;
    background: #e2e8f0;
    isolation: isolate;
  }
  .context-label { color: #475569; font-size: 13px; }
  .high {
    position: absolute; top: 58px; left: 128px;
    z-index: 99;
    padding: 14px 18px;
    border-radius: 8px;
    background: #0f766e;
    color: white;
  }
  .low {
    position: absolute;
    top: 120px;
    left: 220px;
    z-index: 1;
    padding: 14px 18px;
    border-radius: 8px;
    background: #b45309;
    color: white;
  }
</style>
```

The teal child has `z-index: 99`, the amber sibling has `z-index: 1`, and the amber sibling still paints on top. The parent's `isolation: isolate` created a stacking context at the parent's level; the child's 99 only sorts it against other children *inside* that context. To the outside world, the whole teal group is one layer, and the amber sibling is a higher layer.

This is why "just add `z-index: 9999`" fails so often in real code. The element with the enormous number is trapped inside a card that has `transform: translateY(0)`, a wrapper with `opacity: 0.99`, or a parent that became a stacking context for an unrelated animation. The fix is not a bigger number; it is to move the element to the right context, raise the context itself, or remove the property that created the context by accident.

> **Under the hood:** Within a stacking context, the browser paints in layers: the context's own background and borders, negative `z-index` children, in-flow blocks, floats, inline content, positioned children with `z-index: auto` or `0`, and finally positive `z-index` children. That order is why a positioned element with `z-index: -1` can disappear behind its parent's background but still sit above the page background.

## Debug: the dropdown behind the theme button

The "Filters" menu opens over a page toolbar, but the dark "Dark mode" button is painted on top of the menu. The menu has `z-index: 100`, so the number is not the problem. A little reveal animation left `opacity: 0.99` on the menu wrapper, which quietly turned the wrapper into a stacking context and trapped the dropdown inside it.

Fix the stacking relationship so the menu paints above the theme button. You can remove the accidental context or raise the wrapper's own layer; both are valid. The test finds the point where the two boxes overlap and asks the browser what is actually on top.

```html debug id=position-trapped-dropdown title="The dropdown is behind its sibling"
<div class="toolbar">
  <div class="menu-wrap">
    <button class="menu-button" type="button">Filters</button>
    <div class="dropdown">
      <a href="#">All projects</a>
      <a href="#">Recently updated</a>
      <a href="#">Archived</a>
    </div>
  </div>
  <button class="theme-toggle" type="button">Dark mode</button>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { position: relative; display: flex; gap: 12px; }
  .menu-wrap { position: relative; opacity: 0.99; }
  .menu-button, .theme-toggle {
    height: 44px; padding: 0 18px; border: 1px solid #cbd5e1;
    border-radius: 10px; background: white; font: inherit; font-weight: 600; cursor: pointer;
  }
  .dropdown {
    position: absolute; top: 44px; left: 0; z-index: 100;
    width: 280px; padding: 8px; border: 1px solid #cbd5e1;
    border-radius: 12px; background: white; box-shadow: 0 18px 40px rgb(15 23 42 / 0.18);
  }
  .dropdown a {
    display: block; padding: 9px 10px; border-radius: 8px;
    color: #0f172a; text-decoration: none;
  }
  .theme-toggle {
    position: absolute; top: 44px; left: 190px; z-index: 2;
    background: #0f172a; color: white; border-color: #0f172a;
  }
</style>
--- solution
<div class="toolbar">
  <div class="menu-wrap">
    <button class="menu-button" type="button">Filters</button>
    <div class="dropdown">
      <a href="#">All projects</a>
      <a href="#">Recently updated</a>
      <a href="#">Archived</a>
    </div>
  </div>
  <button class="theme-toggle" type="button">Dark mode</button>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { position: relative; display: flex; gap: 12px; }
  .menu-wrap { position: relative; z-index: 10; }
  .menu-button, .theme-toggle {
    height: 44px; padding: 0 18px; border: 1px solid #cbd5e1;
    border-radius: 10px; background: white; font: inherit; font-weight: 600; cursor: pointer;
  }
  .dropdown {
    position: absolute; top: 44px; left: 0; z-index: 100;
    width: 280px; padding: 8px; border: 1px solid #cbd5e1;
    border-radius: 12px; background: white; box-shadow: 0 18px 40px rgb(15 23 42 / 0.18);
  }
  .dropdown a {
    display: block; padding: 9px 10px; border-radius: 8px;
    color: #0f172a; text-decoration: none;
  }
  .theme-toggle {
    position: absolute; top: 44px; left: 190px; z-index: 2;
    background: #0f172a; color: white; border-color: #0f172a;
  }
</style>
--- test
assertVisible(".dropdown");
const menu = query(".dropdown");
const theme = query(".theme-toggle");
const a = menu.getBoundingClientRect();
const b = theme.getBoundingClientRect();
const left = Math.max(a.left, b.left);
const right = Math.min(a.right, b.right);
const top = Math.max(a.top, b.top);
const bottom = Math.min(a.bottom, b.bottom);
assert(right - left > 20 && bottom - top > 10, "The dropdown and the theme button should overlap; keep the layout as it is.");
const hit = document.elementFromPoint(left + 5, top + 5);
const hitName = hit ? (hit.className || hit.tagName) : "nothing";
assert(menu === hit || menu.contains(hit), `Where the menu overlaps the theme button, the browser paints ${hitName}. The dropdown needs to be above it.`);
--- hint
The dropdown has a large `z-index`, but its parent has `opacity: 0.99`. Look up what `opacity` less than 1 does to the parent's place in the stacking order.
--- hint
Either remove the opacity from `.menu-wrap`, or give `.menu-wrap` a `z-index` greater than the theme button's `z-index` while it remains positioned.
```

The lesson generalises: when a `z-index` "does not work", inspect the ancestors before changing the number. Ask which ancestor creates a stacking context, and whether the element that should be underneath is actually outside that context. The browser is not ignoring you; it is sorting at a different level.

```html predict id=position-transform-trap title="Which element paints on top?"
<div class="stage">
  <div class="card">
    <span class="badge">New</span>
  </div>
  <div class="note">Draft saved</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stage { position: relative; height: 240px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .card {
    position: absolute; top: 40px; left: 32px;
    width: 240px; height: 120px;
    border-radius: 12px;
    background: #e2e8f0;
    transform: translateY(0);
  }
  .badge {
    position: absolute; top: -12px; right: -12px;
    z-index: 5;
    padding: 6px 10px;
    border-radius: 999px;
    background: #0f766e;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
  .note {
    position: absolute; top: 20px; left: 170px;
    z-index: 1;
    padding: 12px 16px;
    border-radius: 8px;
    background: #f59e0b;
    color: #0f172a;
    font-weight: 600;
  }
</style>
--- options
* The note paints above the badge, because the card's transform traps the badge in a lower stacking context
The badge paints above the note, because its z-index is 5 and the note's is 1
The two elements blend, because both have a z-index
The badge is invisible, because z-index only works on the page root
--- explain
`transform: translateY(0)` is not a no-op for stacking. It creates a stacking context on `.card` at the card's level in the parent context. The badge's `z-index: 5` only competes with other children inside that card. The note is a sibling of the card in the root context, with `z-index: 1`, so it paints above the entire card, badge included. Removing the transform would let the badge's 5 compete globally and win.

## Overlays and dialogs

A visual overlay is easy: a fixed element with `inset: 0`, a translucent background and a centred panel. An accessible modal is harder, because it is a behaviour contract, not a paint order. The background must become inert, focus must move into the dialog and stay there, Escape must close it, and closing must return focus to the control that opened it.

```html run
<p class="page-copy">The report is ready to publish. Review the summary before it goes live.</p>

<div class="backdrop">
  <section class="dialog">
    <p class="eyebrow">Publish report</p>
    <h2>Send to the team?</h2>
    <p>Everyone in the analytics group will get an email with a link to this snapshot.</p>
    <div class="actions">
      <button class="secondary" type="button">Keep editing</button>
      <button class="primary" type="button">Publish</button>
    </div>
  </section>
</div>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .page-copy { max-width: 520px; color: #334155; line-height: 1.6; }
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 100;
    display: grid;
    place-items: center;
    padding: 16px;
    background: rgb(2 6 23 / 0.62);
  }
  .dialog {
    width: min(420px, 100%);
    padding: 24px;
    border-radius: 16px;
    background: white;
    box-shadow: 0 24px 60px rgb(2 6 23 / 0.3);
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .dialog h2 { margin: 0 0 8px; color: #0f172a; }
  .dialog p { margin: 0 0 20px; color: #475569; line-height: 1.5; }
  .actions { display: flex; justify-content: flex-end; gap: 8px; }
  button { padding: 10px 14px; border-radius: 9px; border: 1px solid #cbd5e1; font: inherit; font-weight: 600; cursor: pointer; }
  .secondary { background: white; color: #0f172a; }
  .primary { background: #0f766e; border-color: #0f766e; color: white; }
</style>
```

This is the visual layer only. In production, reach for the native `<dialog>` element and `showModal()`. A modal dialog is promoted to the browser's **top layer**, so it paints above every stacking context without a `z-index` arms race. The browser also makes the rest of the document inert, moves focus into the dialog, closes on Escape and restores focus on close. `::backdrop` styles the layer behind it.

If you must build a custom dialog with a `div`, you are taking on all of that behaviour: `role="dialog"`, `aria-modal="true"`, `aria-labelledby`, focus trapping, Escape handling, scroll locking and focus restoration. A translucent rectangle with a high `z-index` is not a dialog; it is a picture of one.

> **Pitfall:** Do not put `aria-hidden="true"` on the page behind a visual overlay while leaving its links and buttons focusable. That combination hides content from screen readers but leaves it reachable by keyboard, which is worse than doing nothing.

## Avoiding layout hacks

Positioning is seductive because it can place anything anywhere. The cost is that the result no longer responds to its content. A few habits keep that cost under control:

- Use `position: relative` only to establish a containing block or a stacking context, not to nudge elements into place. If you find yourself writing `top: -3px` to align text, check `align-items`, `line-height` or `vertical-align` first.
- Use absolute positioning for things that genuinely overlay: badges, tooltips, menus, close buttons, decorative layers. Keep the underlying layout in flow so the container still has a height.
- Use `position: fixed` for persistent chrome, and remember that a transformed ancestor can capture it. Prefer a top-level portal or the native top layer for modals.
- Use `z-index` within a known context. Name the layers in comments or custom properties (`--layer-header`, `--layer-menu`, `--layer-modal`) instead of inventing 9999.
- Do not use absolute positioning to build a two-column page. Grid and flexbox keep the columns in flow and let them respond to content.

> **In the wild:** Design systems often define a small set of layer tokens and forbid arbitrary `z-index` values. The constraint is not bureaucracy; it is the only reliable way to keep a dropdown, a sticky header and a modal from fighting when they appear on the same screen.

## Recap

- Normal flow is the default and usually the right layout. Positioning is for relationships that flow cannot express.
- `relative` shifts the painted box but keeps the original space. `absolute` removes the box from flow and uses the nearest positioned ancestor's padding box.
- `fixed` uses the viewport unless an ancestor creates a containing block with `transform`, `filter`, `perspective`, `contain` or `will-change`.
- `sticky` needs a threshold, a scrolling ancestor and room in its containing block.
- A stacking context is atomic. A child's `z-index` cannot escape it; `transform`, `opacity`, `filter` and `isolation` create contexts silently.
- Native `<dialog>` with `showModal()` gives you the top layer, focus management and Escape for free. A styled `div` gives you only the picture.
- Prefer flow layout, named layer tokens and small, intentional overlays over absolute positioning and escalating `z-index` values.

**Up next:** responsive systems — container queries that respond to a component's own width, fluid type with `clamp()`, and logical properties that survive a change of writing direction.

