Grid is not a box of columns. It is a set of relationships between tracks, and the browser resolves those relationships with a real sizing algorithm. That distinction is why two grids that look identical in a mock-up behave completely differently when a product name is forty characters long, when a card is missing, or when the sidebar is collapsed.

The goal is to build a mental model of how Grid sizes tracks, where extra space goes, and why an innocent `1fr` can push a layout off-screen. You will use that model to build dashboards, editorial pages and card systems that survive real content.

## Two grids: explicit and implicit

Everything you write in `grid-template-columns` and `grid-template-rows` describes the **explicit grid**. It is the part of the layout you planned. When items are placed outside those tracks, the browser creates the **implicit grid** to hold them. Implicit tracks are real tracks, but they are sized by `grid-auto-rows` and `grid-auto-columns`, not by the template.

```html run
<div class="board">
  <div class="cell">01</div>
  <div class="cell">02</div>
  <div class="cell">03</div>
  <div class="cell">04</div>
  <div class="cell">05</div>
  <div class="cell">06</div>
  <div class="cell">07</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .board {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-auto-rows: 84px;
    gap: 10px;
    max-width: 620px;
  }
  .cell {
    display: grid;
    place-items: center;
    border-radius: 10px;
    background: #0f172a;
    color: #e2e8f0;
    font-variant-numeric: tabular-nums;
  }
</style>
```

Seven items in a three-column grid need three rows. The third row exists only because the seventh item needed somewhere to go, and `grid-auto-rows: 84px` gives every implicit row that fixed height. Delete that declaration and the row would shrink to fit its content. Add a fourth item to the first row and the browser would create a fourth *column* instead, unless you also set `grid-auto-columns` or change `grid-auto-flow`.

Ask one question first: **is the track explicit or implicit?** Explicit tracks are sized by the template; implicit tracks by `grid-auto-*` and the content that landed there. Most "why is this row a different height?" bugs are one of those two answers.

> **Tip:** `grid-auto-rows: minmax(84px, auto)` is often more useful than a fixed height. It guarantees a minimum rhythm while still letting a row grow when its content needs more room.

## Track sizes are a negotiation

Grid resolves track sizes in stages. Roughly: it first works out the largest and smallest size each item can tolerate, then distributes the available space according to the track list, and finally stretches `auto` and `fr` tracks to fill what is left. The keywords below are the vocabulary for that negotiation.

| Value | What it asks for |
|---|---|
| `min-content` | The narrowest the track can be without its content overflowing, usually the longest word. |
| `max-content` | The width the content would take if it never wrapped. |
| `fit-content(20rem)` | A size between `min-content` and `max-content`, capped at the limit. |
| `minmax(12rem, 1fr)` | At least `12rem`, then share leftover space as a fraction. |
| `auto` | Content-driven minimum, then as much as the content wants. |
| `1fr` | A share of the free space, with an automatic minimum you will meet shortly. |

```html run
<div class="ledger">
  <div class="label">Account balance</div>
  <div class="amount">£128.40</div>
  <div class="note">Renewal on 14 November. Card ending 4402.</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .ledger {
    display: grid;
    grid-template-columns: min-content max-content minmax(12rem, 1fr);
    gap: 16px;
    max-width: 760px;
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .label { font-weight: 600; color: #0f172a; }
  .amount { color: #0f766e; font-variant-numeric: tabular-nums; }
  .note { color: #475569; line-height: 1.5; }
</style>
```

The first column is only as wide as the longest word in "Account balance" — so the label wraps onto two lines. The second is exactly as wide as the amount needs, no more. The third has a floor of `12rem` and then absorbs the rest of the row. Change the first track to `max-content` and the label will sit on one line, stealing width from the note.

`fit-content()` is the polite version of `max-content`: take what you need up to a limit, never less than the minimum. It suits tag lists and sidebars whose width should follow content without becoming absurd; `minmax()` still gives you explicit control at both ends.

> **Under the hood:** The specification calls this the *track sizing algorithm*. It runs multiple passes because a track's size can depend on items in other tracks, especially when spans and intrinsic keywords are involved. You do not need to memorise the passes, but knowing that sizing is a negotiation — not a single width calculation — explains why adding one long word can resize three columns at once.

## The trap inside `1fr`

Here is the sentence that saves hours: **`1fr` means `minmax(auto, 1fr)`, and that `auto` minimum is content-based.** A flexible track can refuse to shrink below the min-content size of its contents. A long URL, a build hash, a German compound noun or a table of numbers can therefore hold a track open like a wedge.

```html run
<div class="inbox bad">
  <div class="rail">Inbox</div>
  <div class="message">
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </div>
  <div class="meta">2m ago</div>
</div>

<div class="inbox good">
  <div class="rail">Inbox</div>
  <div class="message">
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </div>
  <div class="meta">2m ago</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .inbox {
    display: grid;
    grid-template-columns: 96px 1fr 72px;
    gap: 12px;
    width: 100%;
    max-width: 620px;
    margin-bottom: 16px;
    padding: 14px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    background: white;
  }
  .inbox.good { grid-template-columns: 96px minmax(0, 1fr) 72px; }
  .rail { font-weight: 700; color: #0f172a; }
  .message code { font-family: ui-monospace, monospace; font-size: 13px; color: #334155; }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
```

Both cards use the same markup and the same long string. The first one loses its timestamp off the right edge because the middle track grew to fit the unbroken hash. The second uses `minmax(0, 1fr)`, which replaces the automatic minimum with zero. The track can now shrink to the space available, and the content is clipped by the card's `overflow: hidden`.

The structural fix is `minmax(0, 1fr)`; `min-width: 0` on the item does the same job locally. `overflow-wrap: anywhere` changes the content's min-content contribution but also changes how the text reads. `overflow: hidden` hides the symptom, not the cause.

> **Pitfall:** This is the same automatic-minimum problem that makes a flex item refuse to shrink in lesson 05. The mechanism is shared, the keywords are different, and the fix — remove the automatic minimum — is the same idea.

## Debug: the column that will not shrink

This build-log panel has three tracks: a fixed rail, a flexible middle column and a fixed metadata column. The middle column is supposed to absorb the remaining 348 pixels. Instead it has grown to fit a hash that must stay on one line, and the right-hand column has been pushed out of the panel.

Fix the track sizing so the middle column can shrink, and keep the long hash inside its own column with a horizontal scrollbar. The fix is small: one track declaration and one overflow rule.

```html debug id=grid-unshrinkable-column title="The middle column will not shrink"
<div class="panel">
  <nav class="rail">Build log</nav>
  <main class="thread">
    <p>Artifact uploaded</p>
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </main>
  <aside class="meta">2 minutes ago</aside>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    display: grid;
    grid-template-columns: 150px 1fr 150px;
    gap: 16px;
    width: 680px;
    max-width: 100%;
    padding: 16px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .rail { font-weight: 700; color: #0f172a; }
  .thread p { margin: 0 0 8px; color: #334155; }
  .thread code {
    display: block;
    white-space: nowrap;
    font-family: ui-monospace, monospace;
    font-size: 13px;
    color: #475569;
  }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
--- solution
<div class="panel">
  <nav class="rail">Build log</nav>
  <main class="thread">
    <p>Artifact uploaded</p>
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </main>
  <aside class="meta">2 minutes ago</aside>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    display: grid;
    grid-template-columns: 150px minmax(0, 1fr) 150px;
    gap: 16px;
    width: 680px;
    max-width: 100%;
    padding: 16px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .rail { font-weight: 700; color: #0f172a; }
  .thread p { margin: 0 0 8px; color: #334155; }
  .thread code {
    display: block;
    overflow-x: auto;
    white-space: nowrap;
    font-family: ui-monospace, monospace;
    font-size: 13px;
    color: #475569;
  }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
--- test
const thread = query(".thread").getBoundingClientRect();
assert(thread.width < 400, `The middle column is ${Math.round(thread.width)}px wide inside a 680px panel. It is still being held open by the long hash.`);
const panel = query(".panel");
assert(panel.scrollWidth <= panel.clientWidth + 1, `The panel's content is ${panel.scrollWidth - panel.clientWidth}px wider than its box. Let the middle track shrink and contain the long line.`);
--- hint
The middle track is `1fr`. What automatic minimum does a flexible track get, and what content is setting that minimum?
--- hint
Use `minmax(0, 1fr)` for the middle column. Then let the `<code>` element scroll horizontally so the hash does not spill into the metadata column.
```

The test checks overflow at the panel level as well as track width: a correctly sized track can still let code paint outside its box. The layout fix and the containment fix are separate jobs.

## Filling the row: `auto-fit` and `auto-fill`

`repeat(auto-fill, minmax(130px, 1fr))` asks the browser to fit as many 130-pixel tracks as possible into the row, then share any leftover space between them. `auto-fit` starts the same way, but after placing the items it **collapses the empty repeated tracks to zero** and lets the remaining tracks absorb their space.

```html run
<p class="label">auto-fill: empty tracks keep their space</p>
<div class="gallery fill">
  <div class="tile">North</div><div class="tile">South</div>
  <div class="tile">East</div><div class="tile">West</div>
</div>

<p class="label">auto-fit: empty tracks collapse</p>
<div class="gallery fit">
  <div class="tile">North</div><div class="tile">South</div>
  <div class="tile">East</div><div class="tile">West</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .label { margin: 0 0 8px; color: #475569; font-size: 14px; font-weight: 600; }
  .gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
    gap: 10px;
    max-width: 720px;
    margin-bottom: 24px;
  }
  .gallery.fit { grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); }
  .tile { padding: 24px 12px; border-radius: 10px; background: #0f766e; color: white; text-align: center; }
</style>
```

At this width the `auto-fill` row can hold five tracks but only four items exist, so one empty track remains and the four tiles keep their narrower width. In the `auto-fit` row the empty track collapses, the grid keeps four tracks, and each tile grows to roughly a quarter of the row. With enough items to fill every track, the two values look identical.

`auto-fill` suits a stable grid rhythm and cards that should not balloon when the list is short. `auto-fit` suits a small, variable set that should fill the row. Neither is "more modern"; they answer different questions about empty space.

```html predict id=grid-autofit-empty-tracks title="What happens to the empty tracks?"
<div class="row fit">
  <div class="card">One</div><div class="card">Two</div>
</div>
<div class="row fill">
  <div class="card">One</div><div class="card">Two</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 8px;
    width: 620px;
    max-width: 100%;
    margin-bottom: 16px;
  }
  .row.fit { grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); }
  .card { padding: 20px; border-radius: 10px; background: #1e293b; color: white; text-align: center; }
</style>
--- options
* The auto-fit cards stretch to fill the row; the auto-fill cards stay near their minimum width with empty tracks at the end
The auto-fill cards stretch to fill the row; the auto-fit cards stay near their minimum width with empty tracks at the end
Both rows look identical, because both recipes use the same `minmax(140px, 1fr)`
--- explain
Both grids begin with the same number of tracks: four can fit across 620 pixels. `auto-fill` keeps all four, so the two cards occupy two tracks and the other two remain empty. `auto-fit` collapses the empty tracks after placement, leaving two tracks that share the full row. That is why `auto-fit` makes a short list look deliberate and `auto-fill` makes it look like a grid waiting for more items.
```

## Challenge: an editorial grid with a featured story

Magazine layouts are rarely a uniform grid of equal cards. The lead story takes two columns, the rest take one, and the whole thing stays aligned. Build that with `grid-template-columns` and a span on the featured card.

The section already has five `.story` articles and a three-column grid. The first article has the `featured` class but no span yet, so all five cards are currently the same width.

```html exercise id=grid-editorial-feature title="Make the lead story span two columns"
<section class="editorial">
  <article class="story featured">
    <p class="kicker">Field notes</p>
    <h2>The long way to Kinder Scout</h2>
    <p>Two days, one bothy and an unreasonable amount of flapjack.</p>
  </article>
  <article class="story"><h2>Weather window</h2><p>Why the forecast lied.</p></article>
  <article class="story"><h2>Pack light</h2><p>Ten things you can leave behind.</p></article>
  <article class="story"><h2>Tea stops</h2><p>Three bothies worth the detour.</p></article>
  <article class="story"><h2>Night navigation</h2><p>A compass is still allowed.</p></article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .editorial {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
  }
  .story {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .story h2 { margin: 0 0 8px; font-size: 1.15rem; color: #0f172a; }
  .story p { margin: 0; color: #475569; line-height: 1.5; }
  .featured { background: #0f172a; }
  .featured h2, .featured p { color: #f8fafc; }
  .kicker { margin-bottom: 8px !important; color: #5eead4 !important; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  /* TODO: make .featured span two columns */
</style>
--- solution
<section class="editorial">
  <article class="story featured">
    <p class="kicker">Field notes</p>
    <h2>The long way to Kinder Scout</h2>
    <p>Two days, one bothy and an unreasonable amount of flapjack.</p>
  </article>
  <article class="story"><h2>Weather window</h2><p>Why the forecast lied.</p></article>
  <article class="story"><h2>Pack light</h2><p>Ten things you can leave behind.</p></article>
  <article class="story"><h2>Tea stops</h2><p>Three bothies worth the detour.</p></article>
  <article class="story"><h2>Night navigation</h2><p>A compass is still allowed.</p></article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .editorial {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
  }
  .story {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .story h2 { margin: 0 0 8px; font-size: 1.15rem; color: #0f172a; }
  .story p { margin: 0; color: #475569; line-height: 1.5; }
  .featured { grid-column: span 2; background: #0f172a; }
  .featured h2, .featured p { color: #f8fafc; }
  .kicker { margin-bottom: 8px !important; color: #5eead4 !important; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
</style>
--- test
assertStyle(".editorial", "display", "grid");
assertCount(".story", 5, "Keep all five story cards");
const featured = query(".featured").getBoundingClientRect();
const ordinary = query(".story:not(.featured)").getBoundingClientRect();
assert(featured.width > ordinary.width * 1.8, `The featured story is ${Math.round(featured.width)}px wide and a normal story is ${Math.round(ordinary.width)}px. The lead should be roughly twice as wide.`);
assertColor(".featured", "background-color", "#0f172a");
--- hint
The grid already has three equal columns. The featured card needs to occupy two of them, starting from the first column.
--- hint
Set `grid-column: span 2` on `.featured`. If you prefer explicit lines, `grid-column: 1 / span 2` does the same thing.
```

The span belongs to the card, not the grid. The container defines the track system; each item chooses how much of it to occupy. The same idea scales to full-width quotes and two-row sidebars.

> **In the wild:** Editorial grids usually combine spanning with `grid-auto-flow: dense` so that a tall feature does not leave a hole beside it. Dense packing is powerful and easy to misuse, which is why the next section treats it as an accessibility decision rather than a styling trick.

## Names: lines first, areas second

Grid gives you two naming systems, and they solve different problems. **Named lines** label the boundaries between tracks, which is useful when an item needs to start or end at a structural edge. **Named areas** label rectangles of cells, which is useful when the layout itself has a name — header, sidebar, content, footer.

```html run
<div class="layout">
  <header class="topbar">Trailhead / Overview</header>
  <aside class="sidebar">Filters and saved views</aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18% and the espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: [sidebar-start] 180px [sidebar-end main-start] minmax(0, 1fr) [main-end];
    grid-template-rows: auto 1fr;
    grid-template-areas:
      "topbar topbar"
      "sidebar content";
    gap: 12px;
    max-width: 860px;
    min-height: 340px;
  }
  .topbar { grid-area: topbar; }
  .sidebar { grid-area: sidebar; }
  .content { grid-area: content; }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 10px;
    background: white;
    border: 1px solid #e2e8f0;
  }
  .topbar { background: #0f172a; color: #f8fafc; font-weight: 700; }
  .sidebar { color: #475569; }
  .content h2 { margin: 0 0 8px; color: #0f172a; }
  .content p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The areas describe the shape at a glance: the top bar spans both columns, the sidebar sits under the left, the content under the right. Every row must have the same number of columns, and each named area must form a rectangle; a name split into two disconnected places is rejected.

Named lines solve a different problem. `grid-column: sidebar-end / main-end` places an item at structural boundaries without counting tracks. Line names can repeat, and one bracket can hold several names; areas are for the big picture, lines for the exceptions.

> **Tip:** Use `grid-template-areas` when the layout has a stable shape and the names are meaningful to the team. Use explicit line numbers when the layout is generated or when the areas would be mostly dots. Both are clearer than counting `1 / 3` in your head.

## Challenge: a dashboard with named areas

Build the shell of an analytics dashboard. The top bar must span the full width, the sidebar must sit on the left, and the content must fill the rest of the row beneath the top bar. The markup already has the three regions and the dark visual style; the grid is currently a single column, so everything stacks.

Use `grid-template-areas` for the shape and assign each region to its area. Keep the 12-pixel gap and the 220-pixel sidebar.

```html exercise id=grid-dashboard-areas title="Lay out the dashboard shell"
<div class="dashboard">
  <header class="topbar">Trailhead Analytics</header>
  <aside class="sidebar">
    <p>Overview</p>
    <p>Traffic</p>
    <p>Revenue</p>
  </aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18%. The espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #020617; color: #e2e8f0; }
  .dashboard {
    display: grid;
    gap: 12px;
    padding: 16px;
    min-height: 420px;
    /* TODO: add columns, rows and named areas */
  }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 12px;
    background: #1e293b;
  }
  .topbar { font-weight: 700; }
  .sidebar p { margin: 0 0 10px; color: #94a3b8; }
  .content h2 { margin: 0 0 8px; font-size: 1.15rem; }
  .content p { margin: 0; color: #cbd5e1; line-height: 1.5; }
</style>
--- solution
<div class="dashboard">
  <header class="topbar">Trailhead Analytics</header>
  <aside class="sidebar">
    <p>Overview</p>
    <p>Traffic</p>
    <p>Revenue</p>
  </aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18%. The espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #020617; color: #e2e8f0; }
  .dashboard {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr);
    grid-template-rows: auto 1fr;
    grid-template-areas:
      "topbar topbar"
      "sidebar content";
    gap: 12px;
    padding: 16px;
    min-height: 420px;
  }
  .topbar { grid-area: topbar; }
  .sidebar { grid-area: sidebar; }
  .content { grid-area: content; }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 12px;
    background: #1e293b;
  }
  .topbar { font-weight: 700; }
  .sidebar p { margin: 0 0 10px; color: #94a3b8; }
  .content h2 { margin: 0 0 8px; font-size: 1.15rem; }
  .content p { margin: 0; color: #cbd5e1; line-height: 1.5; }
</style>
--- test
assertStyle(".dashboard", "display", "grid");
const dash = query(".dashboard").getBoundingClientRect();
const header = query(".topbar").getBoundingClientRect();
const sidebar = query(".sidebar").getBoundingClientRect();
const content = query(".content").getBoundingClientRect();
assert(header.width > dash.width * 0.9, `The top bar is ${Math.round(header.width)}px wide inside a ${Math.round(dash.width)}px dashboard. It should span both columns.`);
assert(header.bottom <= sidebar.top + 1, "The sidebar should start below the top bar, not beside it.");
assert(Math.abs(sidebar.top - content.top) < 2, "The sidebar and content should share the same row.");
assert(sidebar.right <= content.left, "The sidebar should sit to the left of the content.");
assertColor(".topbar", "background-color", "#1e293b");
--- hint
Start with two columns: `220px` and `minmax(0, 1fr)`. The top bar needs to occupy both.
--- hint
Write the areas as `"topbar topbar"` on the first row and `"sidebar content"` on the second, then give each child `grid-area`.
```

The `minmax(0, 1fr)` in the content column matters for the same reason it did in the inbox example. A dashboard is full of long labels, URLs and numbers; the last thing you want is the sidebar pushed off-screen by an unbroken metric name.

## Dense packing and the reading order

By default, Grid places items in source order and moves forward when a cell is occupied, leaving holes when a spanning item blocks the next slot. `grid-auto-flow: dense` tells the browser to go back and fill those holes with later, smaller items.

```html run
<div class="mosaic">
  <div class="tile wide">01 · wide</div>
  <div class="tile">02</div>
  <div class="tile tall">03 · tall</div>
  <div class="tile">04</div>
  <div class="tile">05</div>
  <div class="tile wide">06 · wide</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .mosaic {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: 82px;
    grid-auto-flow: row dense;
    gap: 8px;
    max-width: 720px;
  }
  .tile {
    display: grid;
    place-items: center;
    padding: 8px;
    border-radius: 10px;
    background: #1e293b;
    color: #e2e8f0;
    font-size: 13px;
  }
  .wide { grid-column: span 2; }
  .tall { grid-row: span 2; background: #0f766e; }
</style>
```

Remove `dense` and item 06 lands on a later row, leaving a hole. Add it back and a later item fills the gap. That is right for a photo mosaic or decorative bento box, and wrong for a list of interactive cards or anything navigated in sequence.

Dense packing changes only the **visual** order. DOM order, tab order and screen-reader order stay as authored, so a keyboard user can jump across the grid and a screen-reader user hears a sequence that does not match the picture. WCAG's meaningful-sequence and focus-order rules are about the order people experience.

> **Pitfall:** Never use `dense` to make a content list "fit better". Use it when the items are decorative or equivalent, or when you have deliberately authored the DOM in the reading order you want and the visual reflow is cosmetic.

## Subgrid, where supported

A nested grid normally gets its own tracks, so three cards side by side cannot align their headings, body copy and footers with each other. **Subgrid** lets a child grid borrow the parent's tracks instead. The child spans some parent tracks and then opts into them with `grid-template-columns: subgrid` or `grid-template-rows: subgrid`.

```html run
<div class="cards">
  <article class="card">
    <h2>Starter</h2>
    <p>One location, two staff and a very short menu.</p>
    <footer>From £9 / month</footer>
  </article>
  <article class="card">
    <h2>Studio</h2>
    <p>Everything in Starter, plus wholesale ordering and a second location.</p>
    <footer>From £29 / month</footer>
  </article>
  <article class="card">
    <h2>Roastery</h2>
    <p>Production planning, batch tracking and a direct line to the roaster.</p>
    <footer>From £79 / month</footer>
  </article>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards {
    display: grid;
    grid-template: repeat(3, auto) / repeat(3, minmax(0, 1fr));
    gap: 16px;
    max-width: 900px;
  }
  .card {
    display: grid;
    grid-row: span 3;
    grid-template-rows: subgrid;
    gap: 8px;
    padding: 18px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .card h2 { margin: 0; font-size: 1.1rem; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .card footer { align-self: end; color: #0f766e; font-weight: 600; }
</style>
```

Each card spans three parent rows and reuses them as its own. The heading row is as tall as the tallest heading, the copy row as tall as the longest copy, and every footer sits on the same baseline. Without subgrid, the cards look fine alone but drift apart as soon as one description is longer.

Subgrid is supported in current Chrome, Firefox and Safari, but recent enough that production code should provide a fallback or treat it as progressive enhancement. It also couples the child to the parent's tracks, so it is a poor fit for a component dropped into arbitrary containers.

## When Grid is overkill

Grid is the right tool when you have a genuine two-dimensional relationship: rows and columns that must align, items that span, overlapping layers or a layout with named regions. It is the wrong tool when you have a single axis of content that should wrap naturally. A row of tags, a toolbar, a breadcrumb trail and a stack of form fields are usually better served by flexbox or normal flow.

Two smells are worth recognising. A grid with one `1fr` column is a stack; `display: block` or flex with `gap` says so more clearly. A grid where every child needs unique `grid-column` and `grid-row` is really a set of positioned pieces, and absolute positioning or a simpler flex layout may be easier to maintain.

> **Under the hood:** Grid and flexbox are not competitors. A grid item can be a flex container, and a flex item can be a grid container. The useful question is not "which one is modern?" but "is the relationship primarily two-dimensional and track-based, or one-dimensional and content-driven?"

## Recap

- The explicit grid is what you declare; the implicit grid is what the browser creates for overflow items. `grid-auto-rows` and `grid-auto-columns` size the latter.
- `min-content`, `max-content`, `fit-content()` and `minmax()` describe constraints, not fixed widths. The track sizing algorithm resolves them against the content.
- `1fr` carries an automatic minimum. Use `minmax(0, 1fr)` or `min-width: 0` when a track must be allowed to shrink.
- `auto-fill` preserves empty tracks; `auto-fit` collapses them and lets the remaining tracks grow.
- `grid-template-areas` describes the shape; named lines describe the boundaries. Both beat counting track numbers.
- `dense` changes visual order only. Use it for decorative mosaics, not for sequences people navigate.
- Subgrid aligns nested content to the parent's tracks where supported. Grid is overkill for a one-dimensional stack.

**Up next:** positioning and stacking — how elements leave normal flow, which ancestor becomes their containing block, and why `z-index: 9999` still loses to a parent with `transform`.


