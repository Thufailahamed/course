Flexbox arranges one line at a time. Grid describes the whole layout at once. That difference is not academic: it is the difference between nudging three cards until they line up and declaring three equal columns that every card, heading and gap obeys automatically.

CSS Grid is **two-dimensional**. You define columns and rows, and the browser turns them into a set of tracks and cells. Items can sit in a single cell, stretch across several, or be placed by name. It is the right tool for page shells, photo galleries, dashboards, pricing tables and any layout where things need to line up in both directions.

## The grid you describe

You opt in with `display: grid` on a container. Its direct children become **grid items**. The simplest grid names its columns and lets the items fill the cells in source order.

```html run
<section class="gallery">
  <article class="work">Ridge line <span>01</span></article>
  <article class="work">Pine shadow <span>02</span></article>
  <article class="work">Moorland <span>03</span></article>
  <article class="work">Dry stone <span>04</span></article>
  <article class="work">Low cloud <span>05</span></article>
  <article class="work">Footpath <span>06</span></article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .gallery {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    max-width: 54rem;
    margin: 0 auto;
  }
  .work {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    aspect-ratio: 4 / 3;
    padding: 1rem;
    border-radius: 12px;
    background: #0f766e;
    color: #fff;
    font-weight: 600;
  }
  .work:nth-child(2) { background: #b45309; }
  .work:nth-child(3) { background: #334155; }
  .work:nth-child(4) { background: #7c2d12; }
  .work:nth-child(5) { background: #065f46; }
  .work span { color: rgb(255 255 255 / 0.65); font-size: 0.8rem; }
</style>
```

The grid has three **columns** and as many **rows** as it needs. The browser places the six items left to right, top to bottom, and creates a new row when the first three cells are full. `gap: 12px` applies between columns and between rows; you do not need separate row and column margins.

The lines between tracks are called **grid lines**, and they are numbered from 1. A three-column grid has four vertical lines: line 1 is the left edge, line 4 the right edge. You will use those numbers when you place an item across tracks.

> **Under the hood:** Grid items are placed by a layout algorithm, not by floats or absolute positioning. The browser resolves the tracks first, then places the items, then sizes the rows. That is why a grid can align an item in row three with an item in row one without any shared wrapper.

## Tracks, fractions and minimums

`grid-template-columns` accepts a list of track sizes. You can use pixels, percentages, `auto`, `fr` or functions like `repeat()` and `minmax()`.

The `fr` unit means *a share of the free space* after fixed tracks and gaps have been subtracted. It is not a percentage. In `220px minmax(0, 1fr)`, the sidebar always gets 220 pixels and the main area gets everything else, whatever the viewport width.

`minmax(0, 1fr)` is a useful spelling of "one fraction, but allowed to shrink to zero". Plain `1fr` is really `minmax(auto, 1fr)`, and that `auto` minimum is the content's minimum size. A long unbroken word or a wide image can therefore make a `1fr` track wider than you intended.

```html run
<div class="dashboard">
  <aside class="rail">
    <h2>Filters</h2>
    <p>Difficulty</p>
    <p>Distance</p>
    <p>Dog friendly</p>
  </aside>
  <main class="panel">
    <p class="eyebrow">Peak District</p>
    <h1>Routes near Edale</h1>
    <p>Twelve walks between four and fourteen kilometres, all reachable from the village.</p>
    <div class="stat">12 km · 480 m ascent · 4 hours</div>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .dashboard {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr);
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem;
  }
  .rail, .panel { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .rail h2 { margin: 0 0 1rem; font-size: 1rem; }
  .rail p { margin: 0 0 0.5rem; color: #475569; font-size: 0.9rem; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 0.75rem; font-size: 2rem; letter-spacing: -0.03em; }
  .panel > p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  .stat { padding: 0.75rem 1rem; border-radius: 8px; background: #f1f5f9; color: #334155; font-size: 0.85rem; font-weight: 600; }
</style>
```

Try changing `220px` to `30%`. The sidebar now depends on the container width, and the main column still absorbs the rest. Try changing `minmax(0, 1fr)` to `1fr` and paste a very long route name into the heading; at some widths the main column will refuse to shrink and the grid will overflow.

> **Pitfall:** `1fr` is not a guarantee that a track can shrink. Its automatic minimum is the largest minimum content size in that track. Use `minmax(0, 1fr)` when the content includes long words, code, URLs or wide media.

## Debug: the grid that grew sideways

This three-column card grid overflows the page. Each card contains a long, unbroken heading, and the columns are plain `1fr`. The browser respects the heading's minimum width, so each track becomes about 657 pixels wide and the total grid is far wider than the window.

The fix is two small changes: let the tracks shrink with `minmax(0, 1fr)`, and let the headings break with `overflow-wrap: anywhere`. Neither one is enough on its own — the first gives the track permission to shrink, the second stops the text from spilling out of the narrower track.

```html debug id=grid-overflow-longword title="The grid that grew sideways"
<section class="grid">
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>A word that should never appear in a trail guide.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>And yet here it is, three times.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>The grid has to survive it.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 20px;
    max-width: 960px;
    margin: 0 auto;
  }
  .card { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 2rem; line-height: 1.1; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- solution
<section class="grid">
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>A word that should never appear in a trail guide.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>And yet here it is, three times.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>The grid has to survive it.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
    max-width: 960px;
    margin: 0 auto;
  }
  .card { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 2rem; line-height: 1.1; overflow-wrap: anywhere; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- test
assertNoOverflow("The page still scrolls sideways. The long headings are forcing the grid wider than the window.");
const grid = query(".grid");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "Keep three columns. The grid currently resolves to " + columns.length + " track(s).");
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect().width);
assert(Math.max(...cards) - Math.min(...cards) < 1.5, "The cards should stay equal width. The tracks are still being sized by their content.");
document.querySelectorAll(".card h2").forEach((heading, index) => {
  assert(heading.scrollWidth <= heading.clientWidth + 1, "The heading in card " + (index + 1) + " is wider than its card. Let the long word break inside the column.");
});
--- hint
The tracks are `1fr`, which means `minmax(auto, 1fr)`. The `auto` minimum is the long word's width.
--- hint
Change the columns to `repeat(3, minmax(0, 1fr))` so the tracks may shrink below their content's minimum.
--- hint
The headings also need `overflow-wrap: anywhere` so the word can break inside the narrower track. Use both fixes.
```

## Card grids that reflow

The most common grid in modern interfaces is a card grid that changes its column count without a media query. The pattern is:

```css
grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
```

Read it from the inside out. Each track must be at least 220 pixels and may grow to one fraction of the free space. `repeat()` asks the browser to fit as many of those tracks as possible into the container. `auto-fit` collapses any empty tracks at the end, letting the existing items stretch to fill the row.

`auto-fill` looks similar but keeps empty tracks, so a row with two cards can leave a gap where a third would fit. Use `auto-fit` when you want the cards to stretch; use `auto-fill` when you want a consistent track width and are happy with empty space.

```html run
<section class="grid">
  <article class="card">
    <h2>Espresso</h2>
    <p>Short, bright and made for the flask.</p>
  </article>
  <article class="card">
    <h2>Filter</h2>
    <p>A slower cup for a slower morning.</p>
  </article>
  <article class="card">
    <h2>Cold brew</h2>
    <p>Eighteen hours of patience in a bottle.</p>
  </article>
  <article class="card">
    <h2>Hot chocolate</h2>
    <p>For the people who came for the walk.</p>
  </article>
  <article class="card">
    <h2>Beans</h2>
    <p>Take the trail home with you.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
```

At a viewport of 1100 pixels the grid's content area is capped at 1000 pixels. Four 220-pixel tracks plus three 20-pixel gaps need 940 pixels, so four columns fit. The remaining 60 pixels are shared between the four tracks. The fifth card moves to a second row and stretches to the full width because there are no other items beside it.

```html predict id=grid-predict-autofit-columns title="How many columns fit?"
<div class="grid">
  <article>One</article>
  <article>Two</article>
  <article>Three</article>
  <article>Four</article>
</div>

<style>
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 1rem;
    background: #f1f5f9;
  }
  article { padding: 1rem; background: #fff; }
</style>
--- options
* Four columns
Three columns
Five columns
One column
--- explain
The grid's content area is 1000 pixels wide. Four tracks need 4 × 220 = 880 pixels, plus three 20-pixel gaps = 940 pixels, so four fit. Five tracks would need 1100 + 80 = 1180 pixels, which does not. The browser fits four and shares the leftover 60 pixels equally, making each track 235 pixels. At a narrower viewport the same declaration fits fewer columns with no media query.
```

## Challenge: a three-column card grid

Build a three-column card grid that would reflow to two and then one column on narrower screens. At the 1100-pixel test viewport, the cards should form exactly three equal columns.

Use `repeat(auto-fit, minmax(200px, 1fr))` and a `20px` gap. Keep the grid's maximum width at `760px`. The starter has the cards and their styling but no grid layout.

```html exercise id=auto-fit-cards title="A card grid that reflows"
<section class="grid">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { max-width: 760px; margin: 0 auto; }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- solution
<section class="grid">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    max-width: 760px;
    margin: 0 auto;
  }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- test
assertStyle(".grid", "display", "grid", "The cards are still stacked as blocks. Put display: grid on .grid.");
const grid = query(".grid");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "At this width the grid should resolve to three columns, but it has " + columns.length + ". Check the minmax minimum and the grid's maximum width.");
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect());
assert(cards.length === 3, "Keep exactly three cards.");
const widths = cards.map((box) => box.width);
assert(Math.max(...widths) - Math.min(...widths) < 1.5, "The three columns should be equal, but their widths are " + widths.map((width) => Math.round(width)).join("px, ") + "px. Use 1fr as the maximum.");
const gap = parseFloat(getComputedStyle(grid).gap);
assert(gap >= 15, "Add a visible gap between the cards. A 20px gap is a good start.");
assertNoOverflow("The cards should fit inside the page, not push it sideways.");
let css = "";
for (const sheet of Array.from(document.styleSheets)) {
  try {
    css += Array.from(sheet.cssRules).map((rule) => rule.cssText).join(" ");
  } catch (error) {}
}
assert(/auto-fit/.test(css), "The columns are not using auto-fit yet, so the grid cannot choose a new column count as space changes. Use repeat(auto-fit, minmax(200px, 1fr)).");
assert(/minmax\(\s*(200px|12\.5rem)/.test(css), "The track needs a minimum width. Use minmax(200px, 1fr) — or 12.5rem, which is the same size — inside repeat().");
assertColor(".card", "background-color", "#ffffff", "Keep the cards white so the grid edges stay readable.");
--- hint
The parent `.grid` needs `display: grid` before any column rules apply.
--- hint
Set `grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))` and `gap: 20px`.
--- hint
Keep `max-width: 760px` on `.grid`. At 760px, three 200px tracks plus two 20px gaps fit, which is why the browser chooses three columns.
```

## Placing items across lines

Auto-placement is convenient until one item needs more room. Grid gives every item a position on both axes. You can say "start at column line 1 and end at line 3", or the shorter "span two columns".

```css
.feature {
  grid-column: span 2;
}
```

Rows work the same way with `grid-row`. `grid-column: 2 / 4` starts at line 2 and ends at line 4, occupying the two tracks between them. The end line is exclusive, just like slicing a list.

```html run
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card"><h2>Edale loop</h2><p>4 km · easy</p></article>
  <article class="card"><h2>Mam Tor</h2><p>7 km · moderate</p></article>
  <article class="card"><h2>Stanage edge</h2><p>9 km · moderate</p></article>
  <article class="card"><h2>Derwent edge</h2><p>12 km · steady</p></article>
  <article class="card"><h2>Grindsbrook</h2><p>6 km · easy</p></article>
</section>
<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid; grid-template-columns: repeat(3, 1fr); grid-auto-rows: 150px;
    gap: 16px; max-width: 1000px; margin: 0 auto;
  }
  .feature { grid-column: span 2; grid-row: span 2; padding: 1.5rem; border-radius: 16px; background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.75rem; font-size: 1.8rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card { padding: 1rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
```

The feature occupies columns 1–2 and rows 1–2. The next two cards fill the third column, and the last three fill the bottom row. If you remove `grid-row: span 2`, the feature only takes the first row and the cards below it rearrange. Nothing about the markup changes; only the placement does.

> **Pitfall:** Auto-placement can leave holes. `grid-auto-flow: dense` lets later items backfill those holes, but it can reorder content visually. If reading order matters — and for most pages it does — leave dense packing off and design the placement deliberately.

## Challenge: the featured story

Build a magazine row where the first article spans two of the three columns and the other three cards fill the remaining space. The grid, cards and content are in place; the feature is still just one column wide.

Do not use a fixed pixel width. Span the grid tracks so the layout keeps working if the container changes size.

```html exercise id=magazine-feature title="A story that spans two columns"
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card">
    <h2>Edale loop</h2>
    <p>4 km · easy</p>
  </article>
  <article class="card">
    <h2>Mam Tor</h2>
    <p>7 km · moderate</p>
  </article>
  <article class="card">
    <h2>Stanage edge</h2>
    <p>9 km · moderate</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .feature, .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .feature { background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.5rem; font-size: 1.7rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
--- solution
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card">
    <h2>Edale loop</h2>
    <p>4 km · easy</p>
  </article>
  <article class="card">
    <h2>Mam Tor</h2>
    <p>7 km · moderate</p>
  </article>
  <article class="card">
    <h2>Stanage edge</h2>
    <p>9 km · moderate</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .feature, .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .feature { grid-column: span 2; background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.5rem; font-size: 1.7rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
--- test
assertStyle(".magazine", "display", "grid", "The magazine still needs display: grid.");
const grid = query(".magazine");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "Keep three grid columns. The layout currently resolves to " + columns.length + ".");
const feature = query(".feature").getBoundingClientRect();
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect());
assert(cards.length === 3, "Keep all three supporting cards.");
const normal = cards[0].width;
assert(feature.width > normal * 1.8, "The featured story is only " + Math.round(feature.width) + "px wide, about the same as one card. Make it span two columns.");
assert(feature.width < normal * 2.25, "The featured story spans more than two columns. It should cover exactly two.");
assert(Math.abs(feature.top - cards[0].top) < 2, "The featured story should start on the same row as the first supporting card.");
assert(cards[1].top > feature.top + 10, "The second supporting card should move below the feature, not squeeze onto the first row.");
--- hint
The feature is a grid item. Its width is controlled by `grid-column`, not `width`.
--- hint
`grid-column: span 2` makes the item cover two tracks. `grid-column: 1 / 3` does the same thing by line number.
--- hint
Add `grid-column: span 2` to `.feature`. Keep the existing three equal columns and gap.
```

## Naming areas

Line numbers are precise but hard to read. `grid-template-areas` lets you draw the layout with names instead. Each quoted string is one row, each word is one cell, and repeating a name makes an area span cells. A dot represents an empty cell.

You then assign each item to a named area with `grid-area`. The result reads like a diagram, which is exactly what a page layout should be.

```html run
<div class="page">
  <header class="masthead">Moss &amp; Pine</header>
  <nav class="sections" aria-label="Sections">
    <a href="#">Shop</a>
    <a href="#">Workshops</a>
    <a href="#">Journal</a>
  </nav>
  <main class="content">
    <p class="eyebrow">Journal</p>
    <h1>What the rain taught us</h1>
    <p>Notes from a season of building things that live outside.</p>
  </main>
  <footer class="foot">Made in Hebden Bridge</footer>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .page {
    display: grid;
    grid-template-columns: 200px minmax(0, 1fr);
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
      "masthead masthead"
      "sections content"
      "foot foot";
    gap: 16px;
    min-height: 100vh;
    padding: 16px;
    box-sizing: border-box;
  }
  .masthead { grid-area: masthead; padding: 1rem; background: #0f172a; color: #fff; font-weight: 700; }
  .sections { grid-area: sections; display: flex; flex-direction: column; gap: 0.75rem; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; }
  .sections a { color: #475569; text-decoration: none; }
  .content { grid-area: content; padding: 2rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; }
  .content h1 { margin: 0 0 0.75rem; font-size: 2rem; letter-spacing: -0.03em; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .content p:last-child { margin: 0; color: #475569; line-height: 1.6; }
  .foot { grid-area: foot; padding: 0.75rem 1rem; color: #64748b; font-size: 0.85rem; }
</style>
```

The `grid-template-areas` declaration contains three rows. `masthead` spans both columns on the first row, `sections` sits in the left column on the second, `content` in the right, and `foot` spans the third. The area names do not have to match the element names, but matching them keeps the CSS readable.

On a narrow screen you can redraw the same page as one column without touching the markup:

```css
@media (max-width: 700px) {
  .page {
    grid-template-columns: 1fr;
    grid-template-areas: "masthead" "sections" "content" "foot";
  }
}
```

That is the whole responsive story: change the map, not the content. The next lesson is about the media query that triggers the change.

> **Tip:** Keep area names semantic (`masthead`, `content`, `foot`) rather than visual (`left`, `right`, `top`). Visual names become lies the moment the layout changes.

## Grid or flex?

Grid and flex solve different problems. Grid is for layout that has to line up across two axes. Flex is for a line of items that share space and align across that line.

| Situation | Better first choice |
|---|---|
| Whole-page shell: header, sidebar, main, footer | Grid, often with named areas |
| Card grid where rows and columns must align | Grid with `repeat(auto-fit, minmax(...))` |
| Featured item spanning columns or rows | Grid placement |
| Navbar or toolbar | Flex |
| Tag list that wraps | Flex |
| Centring a single item | Flex or grid; both are fine |
| Page shell with a flex navbar inside | Both, each in its own container |

Do not turn every container into a grid. A grid with one row and `grid-auto-flow: column` is usually a flexbox wearing a costume. Equally, do not nest three flex rows to build something that is obviously a table of cards. Pick the tool that matches the shape of the problem.

> **In the wild:** Product pages often use a grid shell at the top (header, gallery, buy box) and a flex row for the star rating or the quantity stepper. Design systems describe these as layout primitives: a `Stack` built on flex, a `Grid` built on grid. The names are the contract; the CSS is an implementation detail.

## Recap

- `display: grid` defines columns and rows; children fill the cells in source order.
- `repeat(3, 1fr)` creates three equal fractions of the free space, after gaps.
- `minmax(0, 1fr)` lets a track shrink below its content's minimum; plain `1fr` does not.
- `repeat(auto-fit, minmax(220px, 1fr))` creates a responsive card grid without media queries.
- `grid-column` and `grid-row` place items across tracks; `span 2` is the short form.
- `grid-template-areas` draws a named layout; `grid-area` assigns items to it.
- Grid handles two-dimensional structure; flex handles a row or column of items. Use both.

**Up next:** responsive design — the viewport, media queries and fluid type that let one page work on every screen.
