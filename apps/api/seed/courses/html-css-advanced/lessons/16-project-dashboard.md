A dashboard is a layout system under pressure. The labels change length, the numbers grow, the table has more columns than you planned, and someone opens it on a 13-inch laptop with the sidebar pinned. A page that only looks right with the sample data is not a dashboard; it is a screenshot.

This capstone builds one complete page: an app shell, accessible navigation, four stat cards with trends, a CSS-only bar chart, a data table, and a recent activity list. Everything is HTML and CSS. No chart library, no script, no layout that collapses the moment the content disagrees with it.

## Start with regions, not rectangles

Before a single color, decide what the page *is*. A dashboard has a navigation region, a top bar, a main region, and within main, a summary, a chart, a table and an activity feed. Those are landmarks and sections, not divs with vibes. The app shell then places them with Grid.

The shell uses named areas because the layout has a clear topology: the sidebar spans both rows, the top bar sits above main, and main takes the rest. `minmax(0, 1fr)` is doing quiet but essential work. A bare `1fr` has an automatic minimum of `min-content`, so a wide table can force the main column wider than the viewport. `minmax(0, 1fr)` lets the column shrink and hands overflow control to the component that needs it.

```html run
<a class="skip-link" href="#main">Skip to content</a>
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#" aria-current="page">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <label class="search"><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label>
    <button class="user" type="button">AM · Avery Moss</button>
  </header>
  <main class="main" id="main" tabindex="-1">
    <h1>Overview</h1>
  </main>
</div>

<style>
  :root { --ink: #0f172a; --muted: #64748b; --line: #e2e8f0; --bg: #f1f5f9; }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--bg); color: var(--ink); font-family: ui-sans-serif, system-ui, sans-serif; }
  .skip-link { position: absolute; left: -9999px; top: 8px; padding: 10px 14px; background: #fff; border-radius: 8px; } .skip-link:focus { left: 8px; z-index: 5; }
  .app { display: grid; grid-template-columns: 240px minmax(0, 1fr); grid-template-rows: auto 1fr; grid-template-areas: "sidebar topbar" "sidebar main"; min-height: 100vh; }
  .sidebar { grid-area: sidebar; display: flex; flex-direction: column; gap: 28px; padding: 24px 20px; background: #0f172a; color: #e2e8f0; }
  .brand { color: #fff; font-weight: 750; letter-spacing: -0.02em; text-decoration: none; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar nav a { padding: 8px 10px; border-radius: 8px; color: #cbd5e1; text-decoration: none; font-size: 0.9rem; }
  .sidebar nav a[aria-current="page"] { background: #1e293b; color: #fff; }
  .topbar { grid-area: topbar; display: flex; align-items: center; justify-content: space-between; gap: 16px; padding: 14px 24px; background: #fff; border-bottom: 1px solid var(--line); }
  .search input { width: min(360px, 42vw); min-height: 40px; padding: 0 12px; border: 1px solid var(--line); border-radius: 10px; background: #f8fafc; }
  .user { padding: 8px 12px; border: 1px solid var(--line); border-radius: 999px; background: #fff; font-weight: 600; }
  .main { grid-area: main; min-width: 0; padding: 32px; }
  h1 { margin: 0; font-size: 2rem; letter-spacing: -0.03em; }
  :focus-visible { outline: 3px solid #a5b4fc; outline-offset: 2px; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
  @media (max-width: 820px) { .app { grid-template-columns: 1fr; grid-template-areas: "topbar" "sidebar" "main"; } }
</style>
```

Two accessibility decisions are structural, not decorative. The skip link is the first focusable thing on the page, and it targets `<main id="main" tabindex="-1">`, so keyboard users can bypass the navigation. The current navigation item uses `aria-current="page"` instead of a `.active` class, so the state is announced, not just colored. The search input has a real `<label>`; a placeholder is not a name.

> **Tip:** `aria-current="page"` is for the link that represents the current page. Use `aria-current="step"` for a step in a process, or `aria-current="location"` for a location in a navigation tree. Do not use color as the only signal.

## Stat cards: numbers with context

A stat card is a small composition: a label, a value, and a comparison. The label is a heading because it names the metric. The value is emphasized text, not a heading, because it is data. The trend is the part most dashboards get wrong: a green arrow and a red arrow are invisible to a person who cannot distinguish those colors, and a bare percentage does not say whether it is good or bad.

Use a `data-trend` attribute for styling, but include an arrow and a text alternative in the markup. The arrow gives a shape cue; the screen-reader text gives the direction in words. "Up 12.4%" is a fact. "Good" is an interpretation, and it depends on the metric: rising churn is not a win.

```html run
<section class="stats" aria-label="Key metrics">
  <article class="stat">
    <h3>Revenue</h3>
    <p class="stat-value">$48,290</p>
    <p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4% <span class="sr-only">increase from last month</span></p>
  </article>
  <article class="stat">
    <h3>Active accounts</h3>
    <p class="stat-value">2,184</p>
    <p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1% <span class="sr-only">increase from last month</span></p>
  </article>
  <article class="stat">
    <h3>Conversion</h3>
    <p class="stat-value">3.8%</p>
    <p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0% <span class="sr-only">unchanged from last month</span></p>
  </article>
  <article class="stat">
    <h3>Churn</h3>
    <p class="stat-value">1.2%</p>
    <p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3% <span class="sr-only">decrease from last month</span></p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat h3 { margin: 0; color: #64748b; font-size: 0.72rem; font-weight: 650; letter-spacing: 0.08em; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 1.9rem; font-weight: 750; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
  .trend { display: inline-flex; align-items: center; gap: 6px; margin: 0; padding: 3px 8px; border-radius: 999px; font-size: 0.78rem; font-weight: 650; }
  .trend[data-trend="up"] { color: #047857; background: #ecfdf5; }
  .trend[data-trend="down"] { color: #b91c1c; background: #fef2f2; }
  .trend[data-trend="flat"] { color: #475569; background: #f1f5f9; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
</style>
```

`font-variant-numeric: tabular-nums` keeps columns of figures aligned, which matters the moment values sit in a table or a row of cards. The trend pill is allowed to be colored because it is not the only signal: the arrow and the hidden sentence carry the same information.

> **Pitfall:** "Down" is not always bad. Churn going down is excellent; refunds going down might be excellent or suspicious. Keep the interpretation in the product copy, not in a hard-coded green/red rule.

## A chart without JavaScript

A bar chart is a set of rectangles with heights. You do not need a chart library to draw rectangles. The CSS-only version uses one flex row, one custom property per bar, and `height: calc(var(--value) * 1%)`. The value drives the geometry; the label sits above the bar; the axis is a separate row so the bars stay aligned.

Accessibility is the part a library usually handles for you. If the chart is made of divs, give the whole figure `role="img"` and a label that summarizes the trend. Keep the visible values in the bars, and keep the axis readable. If exact values matter, the table below the chart is the real source of truth; the chart is a visual summary.

```html run
<figure class="panel chart-panel">
  <figcaption>
    <h2>Revenue by week</h2>
    <p>Last 6 weeks · USD</p>
  </figcaption>
  <div class="chart" role="img" aria-label="Bar chart: weekly revenue rises from 24,000 to 49,000 dollars over six weeks">
    <div class="bar" style="--value: 49"><span>$24k</span></div>
    <div class="bar" style="--value: 63"><span>$31k</span></div>
    <div class="bar" style="--value: 57"><span>$28k</span></div>
    <div class="bar" style="--value: 80"><span>$39k</span></div>
    <div class="bar" style="--value: 90"><span>$44k</span></div>
    <div class="bar" style="--value: 100"><span>$49k</span></div>
  </div>
  <div class="axis" aria-hidden="true"><span>W1</span><span>W2</span><span>W3</span><span>W4</span><span>W5</span><span>W6</span></div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 720px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .chart-panel figcaption { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; margin-bottom: 18px; }
  .chart-panel h2 { margin: 0; font-size: 1.1rem; }
  .chart-panel p { margin: 0; color: #64748b; font-size: 0.8rem; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; padding-top: 28px; border-bottom: 1px solid #e2e8f0; }
  .bar { position: relative; flex: 1; height: calc(var(--value) * 1%); background: linear-gradient(180deg, #818cf8, #4f46e5); border-radius: 8px 8px 2px 2px; }
  .bar span { position: absolute; bottom: 100%; left: 0; right: 0; margin-bottom: 6px; text-align: center; color: #64748b; font-size: 0.7rem; }
  .axis { display: flex; gap: 8px; margin-top: 8px; }
  .axis span { flex: 1; text-align: center; color: #94a3b8; font-size: 0.7rem; }
</style>
```

The chart is honest about what it is: a picture of a trend, not a precision instrument. The `aria-label` names the direction and the endpoints. The visible labels give the rough values. The table in the next section gives the exact numbers, with headers that a screen reader can associate with each cell.

> **Under the hood:** `height: calc(var(--value) * 1%)` resolves against the chart's content box because the chart has a definite height. If the chart height were `auto`, the percentage would have nothing to resolve against and the bars would collapse.

## A table that can scroll

Tables are not old-fashioned. A table is the correct element when the data has rows and columns, and a dashboard without one is usually hiding the real numbers behind cards. The essentials are a `<caption>`, `<th scope="col">` for column headers, `<th scope="row">` for row headers, and a wrapper that allows horizontal scrolling on narrow screens.

The wrapper is where most table layouts break. If the table has `min-width: 560px` and its parent is a grid column with the default `min-width: auto`, the column refuses to shrink and the whole page scrolls sideways. Put `overflow-x: auto` on the wrapper and `min-width: 0` on the grid child. The table can then be wider than the phone without dragging the page with it.

```html run
<section class="panel">
  <h2>Top campaigns</h2>
  <div class="table-wrap">
    <table>
      <caption>Top campaigns by revenue, last 30 days</caption>
      <thead>
        <tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr>
      </thead>
      <tbody>
        <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
        <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
        <tr><th scope="row">Trail pass</th><td>Paid social</td><td>$6,800</td><td>$11,300</td></tr>
      </tbody>
    </table>
  </div>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 760px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .panel h2 { margin: 0 0 16px; font-size: 1.1rem; }
  .table-wrap { overflow-x: auto; }
  table { width: 100%; min-width: 560px; border-collapse: collapse; font-size: 0.9rem; }
  caption { padding-bottom: 12px; text-align: left; color: #64748b; font-size: 0.8rem; }
  th, td { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { color: #64748b; font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; }
  tbody th { font-weight: 600; }
  td:last-child { font-variant-numeric: tabular-nums; }
</style>
```

On a wide screen the table fills its panel. On a narrow screen the wrapper scrolls, the caption stays with the table, and the page itself does not move. That is the correct tradeoff: a table is allowed to scroll inside its own region; the page is not.

## Recent activity: time is data

An activity feed is a list of events. Use an ordered or unordered list, a `<time datetime="...">` element, and a short text description. The avatar is decorative if the person's name is already in the text; mark it `aria-hidden="true"` so a screen reader does not announce a meaningless pair of initials.

```html run
<section class="panel">
  <h2>Recent activity</h2>
  <ul class="activity">
    <li><span class="avatar" aria-hidden="true">JL</span><p><strong>Jordan Lee</strong> exported the Q3 report <time datetime="2026-10-23T09:42">Today, 09:42</time></p></li>
    <li><span class="avatar" aria-hidden="true">SK</span><p><strong>Samira Khan</strong> changed the revenue target <time datetime="2026-10-22T16:08">Yesterday, 16:08</time></p></li>
    <li><span class="avatar" aria-hidden="true">AM</span><p><strong>Avery Moss</strong> invited two analysts <time datetime="2026-10-22T11:15">Yesterday, 11:15</time></p></li>
  </ul>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 640px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .panel h2 { margin: 0 0 16px; font-size: 1.1rem; }
  .activity { display: grid; gap: 14px; margin: 0; padding: 0; list-style: none; }
  .activity li { display: flex; align-items: flex-start; gap: 10px; }
  .avatar { display: grid; place-items: center; width: 32px; height: 32px; flex: none; border-radius: 50%; background: #e0e7ff; color: #3730a3; font-size: 0.7rem; font-weight: 700; }
  .activity p { margin: 0; color: #475569; font-size: 0.9rem; line-height: 1.5; }
  .activity strong { color: #0f172a; }
  time { color: #94a3b8; font-size: 0.78rem; white-space: nowrap; }
</style>
```

The `datetime` attribute gives machines a precise timestamp while the visible text stays human. "Yesterday" is friendly; `2026-10-22T16:08` is unambiguous across time zones, locales and future readers.

## Challenge: build the app shell

The starter has the right regions but no layout system, no skip link and no current-page state. Turn it into a two-column Grid shell at 1100 px, give the search input a real name, and make the navigation state accessible.

```html exercise id=dashboard-app-shell title="Build the app shell"
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <input type="search" placeholder="Search metrics">
    <button class="user" type="button">Avery Moss</button>
  </header>
  <main class="main">
    <h1>Overview</h1>
  </main>
</div>

<style>
  body { margin: 0; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .app { padding: 20px; }
  .sidebar { padding: 20px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 8px; margin-top: 20px; }
  .sidebar a { color: #cbd5e1; }
  .topbar { display: flex; gap: 12px; padding: 16px; background: #fff; }
  .main { padding: 24px; }
</style>
--- solution
<a class="skip-link" href="#main">Skip to content</a>
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#" aria-current="page">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <label class="search"><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label>
    <button class="user" type="button">Avery Moss</button>
  </header>
  <main class="main" id="main" tabindex="-1">
    <h1>Overview</h1>
  </main>
</div>

<style>
  body { margin: 0; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .app { display: grid; grid-template-columns: 240px minmax(0, 1fr); grid-template-rows: auto 1fr; grid-template-areas: "sidebar topbar" "sidebar main"; min-height: 100vh; }
  .sidebar { grid-area: sidebar; padding: 20px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 8px; margin-top: 20px; }
  .sidebar a { color: #cbd5e1; text-decoration: none; }
  .sidebar a[aria-current="page"] { color: #fff; font-weight: 700; }
  .topbar { grid-area: topbar; display: flex; align-items: center; gap: 12px; padding: 16px; background: #fff; border-bottom: 1px solid #e2e8f0; }
  .main { grid-area: main; min-width: 0; padding: 24px; }
  .skip-link { position: absolute; left: -9999px; top: 8px; padding: 10px 14px; background: #fff; border-radius: 8px; } .skip-link:focus { left: 8px; z-index: 5; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
  :focus-visible { outline: 3px solid #a5b4fc; outline-offset: 2px; }
</style>
--- test
assertStyle(".app", "display", "grid");
const tracks = getComputedStyle(query(".app")).gridTemplateColumns.split(" ").filter(Boolean);
assert(tracks.length === 2, `At 1100px the app shell should have two columns (sidebar and main); found ${tracks.length}.`);
assertExists("a.skip-link[href='#main']", "Add a skip link that targets the main region");
assertExists("#main", "Give the main region id='main'");
assertAttr("nav a[aria-current='page']", "aria-current", "page");
assertCount("nav a[aria-current='page']", 1, "Exactly one navigation link should be the current page");
assertExists(".topbar input[type='search']", "Keep the search input in the top bar");
const input = query(".topbar input[type='search']");
assert((input.labels && input.labels.length > 0) || input.getAttribute("aria-label"), "Give the search input an accessible name with a label or aria-label");
assertStyle(".topbar", "display", "flex");
assertFocusable("a.skip-link");
assertNoOverflow("The dashboard should not scroll sideways at 1100px.");
--- hint
Use `display: grid` on `.app` with `grid-template-columns: 240px minmax(0, 1fr)` and named areas for the sidebar, top bar and main.
--- hint
Put `<a class="skip-link" href="#main">` before the shell, add `id="main"` to `<main>`, and put `aria-current="page"` on Overview.
--- hint
Wrap the search input in a `<label>` with visually hidden text, or give it an `aria-label`. The top bar should compute to `display: flex`.
```

## Challenge: stat cards and a chart

Build four stat cards and a six-bar chart. Each card needs a heading, a value and a trend that does not rely on color alone. Each bar gets its height from a custom property. The tests check the structure, the accessible trend text and that the bars actually differ in height.

```html exercise id=dashboard-stats-chart title="Build the stat cards and chart"
<section class="stats">
  <article class="stat"><h3>Revenue</h3><p class="stat-value">$48,290</p></article>
  <article class="stat"><h3>Active accounts</h3><p class="stat-value">2,184</p></article>
</section>
<figure class="chart-panel">
  <figcaption>Revenue by week</figcaption>
  <div class="chart">
    <div class="bar" style="--value: 60"></div>
    <div class="bar" style="--value: 60"></div>
    <div class="bar" style="--value: 60"></div>
  </div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat, .chart-panel { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat h3 { margin: 0; color: #64748b; font-size: 12px; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 30px; font-weight: 700; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; max-width: 600px; }
  .bar { flex: 1; height: calc(var(--value) * 1%); background: #4f46e5; border-radius: 6px 6px 0 0; }
</style>
--- solution
<section class="stats" aria-label="Key metrics">
  <article class="stat"><h3>Revenue</h3><p class="stat-value">$48,290</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4% <span class="sr-only">increase from last month</span></p></article>
  <article class="stat"><h3>Active accounts</h3><p class="stat-value">2,184</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1% <span class="sr-only">increase from last month</span></p></article>
  <article class="stat"><h3>Conversion</h3><p class="stat-value">3.8%</p><p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0% <span class="sr-only">unchanged from last month</span></p></article>
  <article class="stat"><h3>Churn</h3><p class="stat-value">1.2%</p><p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3% <span class="sr-only">decrease from last month</span></p></article>
</section>
<figure class="chart-panel">
  <figcaption><h2>Revenue by week</h2></figcaption>
  <div class="chart" role="img" aria-label="Weekly revenue rises from 24,000 to 49,000 dollars over six weeks">
    <div class="bar" style="--value: 49"><span>$24k</span></div>
    <div class="bar" style="--value: 63"><span>$31k</span></div>
    <div class="bar" style="--value: 57"><span>$28k</span></div>
    <div class="bar" style="--value: 80"><span>$39k</span></div>
    <div class="bar" style="--value: 90"><span>$44k</span></div>
    <div class="bar" style="--value: 100"><span>$49k</span></div>
  </div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat, .chart-panel { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat { min-width: 0; }
  .stat h3 { margin: 0; color: #64748b; font-size: 12px; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 30px; font-weight: 700; font-variant-numeric: tabular-nums; }
  .trend { display: inline-flex; gap: 6px; margin: 0; padding: 3px 8px; border-radius: 999px; font-size: 12px; font-weight: 650; }
  .trend[data-trend="up"] { color: #047857; background: #ecfdf5; }
  .trend[data-trend="down"] { color: #b91c1c; background: #fef2f2; }
  .trend[data-trend="flat"] { color: #475569; background: #f1f5f9; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; max-width: 600px; padding-top: 24px; }
  .bar { position: relative; flex: 1; height: calc(var(--value) * 1%); background: #4f46e5; border-radius: 6px 6px 0 0; }
  .bar span { position: absolute; bottom: 100%; left: 0; right: 0; margin-bottom: 6px; text-align: center; color: #64748b; font-size: 11px; }
  .chart-panel { margin-top: 16px; }
  .chart-panel h2 { margin: 0; font-size: 18px; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
</style>
--- test
assertCount(".stats .stat", 4, "The dashboard needs four stat cards");
Array.from(document.querySelectorAll(".stat")).forEach((card, index) => {
  const name = card.querySelector("h3");
  const value = card.querySelector(".stat-value");
  const trend = card.querySelector(".trend");
  assert(name, `Stat card ${index + 1} needs a heading that names the metric`);
  assert(value, `Stat card ${index + 1} needs a .stat-value`);
  assert(trend, `Stat card ${index + 1} needs a .trend`);
  assert(trend.getAttribute("data-trend"), `Stat card ${index + 1} needs a data-trend state`);
  assert(/[↑↓→]/.test(trend.textContent), `Stat card ${index + 1} needs an arrow or shape cue, not color alone`);
  assert(/increase|decrease|unchanged/i.test(trend.textContent), `Stat card ${index + 1} needs a text alternative such as "increase from last month"`);
});
assertCount(".chart .bar", 6, "The chart needs six weekly bars");
assertAttr(".chart", "role", "img");
assert((query(".chart").getAttribute("aria-label") || "").length > 20, "Give the chart an aria-label that summarizes the trend");
const heights = Array.from(document.querySelectorAll(".chart .bar")).map((bar) => Math.round(bar.getBoundingClientRect().height));
assert(new Set(heights).size >= 3, `The bars should encode different values; the heights found were ${heights.join(", ")}.`);
--- hint
Use an `<article class="stat">` with an `<h3>`, a `.stat-value`, and a `.trend` carrying `data-trend="up|down|flat"`.
--- hint
Include an arrow (`↑`, `↓` or `→`) and a visually hidden phrase such as "increase from last month" inside each trend.
--- hint
Set `--value` on each bar and use `height: calc(var(--value) * 1%)`; the chart needs a definite height for that percentage to resolve.
```

## Debug: the dashboard that overflows at 380px

This preview is a 380 px container standing in for a narrow phone. The app shell has a fixed 220 px sidebar and a 560 px table, so the frame scrolls sideways and the table drags the whole layout with it. The shell should collapse to one column at this container width, and the table should scroll inside its own wrapper. Fix both without changing the table's minimum width.

```html debug id=dashboard-narrow-overflow title="The dashboard that overflows at 380px"
<div class="frame">
  <div class="app">
    <aside class="sidebar">
      <strong>Nimbus</strong>
      <nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a></nav>
    </aside>
    <main class="main">
      <h1>Overview</h1>
      <div class="table-wrap">
        <table>
          <caption>Top campaigns</caption>
          <thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead>
          <tbody>
            <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
            <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</div>

<style>
  body { margin: 0; padding: 20px; background: #e2e8f0; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .frame { width: 380px; margin: 0 auto; background: #f1f5f9; border: 1px solid #cbd5e1; }
  .app { display: grid; grid-template-columns: 220px minmax(560px, 1fr); min-height: 520px; }
  .sidebar { padding: 16px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 6px; margin-top: 12px; }
  .sidebar a { color: #cbd5e1; font-size: 13px; }
  .main { min-width: 0; padding: 16px; }
  h1 { margin: 0 0 12px; font-size: 22px; }
  .table-wrap { }
  table { width: 100%; min-width: 560px; border-collapse: collapse; background: #fff; }
  th, td { padding: 8px; border-bottom: 1px solid #e2e8f0; text-align: left; font-size: 12px; }
</style>
--- solution
<div class="frame">
  <div class="app">
    <aside class="sidebar">
      <strong>Nimbus</strong>
      <nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a></nav>
    </aside>
    <main class="main">
      <h1>Overview</h1>
      <div class="table-wrap">
        <table>
          <caption>Top campaigns</caption>
          <thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead>
          <tbody>
            <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
            <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</div>

<style>
  body { margin: 0; padding: 20px; background: #e2e8f0; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .frame { width: 380px; margin: 0 auto; background: #f1f5f9; border: 1px solid #cbd5e1; container-type: inline-size; }
  .app { display: grid; grid-template-columns: 220px minmax(560px, 1fr); min-height: 520px; }
  .sidebar { padding: 16px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 6px; margin-top: 12px; }
  .sidebar a { color: #cbd5e1; font-size: 13px; }
  .main { min-width: 0; padding: 16px; }
  h1 { margin: 0 0 12px; font-size: 22px; }
  .table-wrap { overflow-x: auto; }
  table { width: 100%; min-width: 560px; border-collapse: collapse; background: #fff; }
  th, td { padding: 8px; border-bottom: 1px solid #e2e8f0; text-align: left; font-size: 12px; }
  @container (max-width: 620px) {
    .app { grid-template-columns: 1fr; }
    .sidebar { display: flex; align-items: center; gap: 16px; }
    .sidebar nav { grid-auto-flow: column; margin-top: 0; }
  }
</style>
--- test
const frame = query(".frame");
assert(frame.scrollWidth <= frame.clientWidth + 1, `The 380px frame overflows: ${frame.scrollWidth}px of content in ${frame.clientWidth}px. Collapse the shell and contain the table.`);
assertStyle(".table-wrap", "overflow-x", "auto");
const tracks = getComputedStyle(query(".app")).gridTemplateColumns.split(" ").filter(Boolean);
assert(tracks.length === 1, `At this container width the app shell should have one column; found ${tracks.length}.`);
assertExists("table caption", "Keep the table's caption");
assertCount("th[scope='col']", 4, "All four column headers need scope='col'");
assertCount("th[scope='row']", 2, "Each row header needs scope='row'");
assertNoOverflow("The page should not scroll sideways at 1100px.");
--- hint
The frame is 380px wide, but the viewport is 1100px. A media query will not see the frame's width; make `.frame` a container and use `@container`.
--- hint
Add `container-type: inline-size` to `.frame`, then inside `@container (max-width: 620px)` set `.app { grid-template-columns: 1fr; }`.
--- hint
The table can stay 560px wide if `.table-wrap { overflow-x: auto; }` contains it. The shell needs one column; the table needs its own scrollbar.
```

## Predict: which layout wins?

```html predict id=dashboard-container-query title="One column or two?"
<section class="panel">
  <div class="grid">
    <article>One</article>
    <article>Two</article>
    <article>Three</article>
    <article>Four</article>
  </div>
</section>
<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { width: 420px; container-type: inline-size; padding: 16px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
  .grid article { padding: 16px; background: #eef2ff; border-radius: 10px; }
  @container (max-width: 600px) { .grid { grid-template-columns: 1fr; } }
</style>
--- options
* One column, because the panel is 420px wide
Two columns, because the viewport is 1100px
Three columns, because the gallery is inside a grid
The cards disappear because no media query matches
--- explain
`@container` queries the nearest container, not the viewport. The panel declares `container-type: inline-size` and is 420px wide, so the `max-width: 600px` condition matches and the grid collapses to one column — even though the browser window is 1100px wide. A media query here would see 1100px and keep two columns, which is the bug container queries were designed to fix.
```

## Putting it together

The complete page combines the shell, the cards, the chart, the table and the activity list. Notice what is *not* there: no absolute positioning for the layout, no fixed heights on the main region, no JavaScript, and no color-only state. The responsive rule collapses the shell at 820px, the stat grid reflows on its own, and the table keeps its own overflow.

```html run
<a class="skip" href="#main">Skip to content</a>
<div class="app">
  <aside class="side"><strong>Nimbus</strong><nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a><a href="#">Customers</a><a href="#">Settings</a></nav></aside>
  <header class="top"><label><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label><button class="user" type="button">Avery Moss</button></header>
  <main class="main" id="main">
    <h1>Overview</h1><p class="lede">Monday to today, across every active campaign.</p>
    <section class="stats" aria-label="Key metrics">
      <article class="stat"><h3>Revenue</h3><p class="value">$48,290</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4%<span class="sr-only"> increase</span></p></article><article class="stat"><h3>Active accounts</h3><p class="value">2,184</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1%<span class="sr-only"> increase</span></p></article><article class="stat"><h3>Conversion</h3><p class="value">3.8%</p><p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0%<span class="sr-only"> unchanged</span></p></article><article class="stat"><h3>Churn</h3><p class="value">1.2%</p><p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3%<span class="sr-only"> decrease</span></p></article>
    </section>
    <div class="lower">
      <figure class="panel"><figcaption><h2>Revenue by week</h2><p>Last 6 weeks · USD</p></figcaption>
        <div class="chart" role="img" aria-label="Weekly revenue rises from 24,000 to 49,000 dollars over six weeks"><div class="bar" style="--value:49"><span>$24k</span></div><div class="bar" style="--value:63"><span>$31k</span></div><div class="bar" style="--value:57"><span>$28k</span></div><div class="bar" style="--value:80"><span>$39k</span></div><div class="bar" style="--value:90"><span>$44k</span></div><div class="bar" style="--value:100"><span>$49k</span></div></div>
        <div class="axis" aria-hidden="true"><span>W1</span><span>W2</span><span>W3</span><span>W4</span><span>W5</span><span>W6</span></div>
      </figure>
      <section class="panel"><h2>Top campaigns</h2><div class="table-wrap"><table><caption>Top campaigns by revenue</caption><thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead><tbody><tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr><tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr><tr><th scope="row">Trail pass</th><td>Paid social</td><td>$6,800</td><td>$11,300</td></tr></tbody></table></div></section>
    </div>
    <section class="panel"><h2>Recent activity</h2><ul class="activity"><li><span class="avatar" aria-hidden="true">JL</span><p><strong>Jordan Lee</strong> exported the Q3 report <time datetime="2026-10-23T09:42">Today, 09:42</time></p></li><li><span class="avatar" aria-hidden="true">SK</span><p><strong>Samira Khan</strong> changed the revenue target <time datetime="2026-10-22T16:08">Yesterday, 16:08</time></p></li><li><span class="avatar" aria-hidden="true">AM</span><p><strong>Avery Moss</strong> invited two analysts <time datetime="2026-10-22T11:15">Yesterday, 11:15</time></p></li></ul></section>
  </main>
</div>

<style>
  :root { --ink:#0f172a; --muted:#64748b; --line:#e2e8f0; --bg:#f1f5f9; --brand:#4f46e5; }
  * { box-sizing: border-box; } body { margin:0; background:var(--bg); color:var(--ink); font-family:ui-sans-serif,system-ui,sans-serif; }
  .skip { position:absolute; left:-9999px; top:8px; padding:10px 14px; background:#fff; border-radius:8px; } .skip:focus { left:8px; z-index:5; }
  .app { display:grid; grid-template-columns:230px minmax(0,1fr); grid-template-rows:auto 1fr; grid-template-areas:"side top" "side main"; min-height:100vh; }
  .side { grid-area:side; display:flex; flex-direction:column; gap:24px; padding:22px 18px; background:#0f172a; color:#e2e8f0; } .side strong { color:#fff; }
  .side nav { display:grid; gap:6px; } .side a { padding:7px 9px; border-radius:8px; color:#cbd5e1; text-decoration:none; font-size:.86rem; } .side a[aria-current="page"] { background:#1e293b; color:#fff; }
  .top { grid-area:top; display:flex; align-items:center; justify-content:space-between; gap:16px; padding:14px 22px; background:#fff; border-bottom:1px solid var(--line); } .top input { min-height:38px; width:min(320px,40vw); padding:0 12px; border:1px solid var(--line); border-radius:10px; background:#f8fafc; } .user { padding:6px 10px; border:1px solid var(--line); border-radius:999px; background:#fff; font-weight:600; }
  .main { grid-area:main; min-width:0; padding:26px; } h1 { margin:0 0 4px; font-size:30px; letter-spacing:-.03em; } .lede { margin:0 0 22px; color:var(--muted); }
  .stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(170px,1fr)); gap:12px; } .stat,.panel { padding:16px; background:#fff; border:1px solid var(--line); border-radius:14px; }
  .stat h3 { margin:0; color:var(--muted); font-size:11px; letter-spacing:.08em; text-transform:uppercase; } .value { margin:6px 0; font-size:26px; font-weight:750; font-variant-numeric:tabular-nums; }
  .trend { display:inline-block; margin:0; padding:2px 7px; border-radius:999px; font-size:12px; font-weight:650; } .trend[data-trend="up"] { color:#047857; background:#ecfdf5; } .trend[data-trend="down"] { color:#b91c1c; background:#fef2f2; } .trend[data-trend="flat"] { color:#475569; background:#f1f5f9; }
  .lower { display:grid; grid-template-columns:1.3fr 1fr; gap:12px; margin:12px 0; } .chart { display:flex; align-items:flex-end; gap:7px; height:170px; padding-top:24px; border-bottom:1px solid var(--line); }
  .bar { position:relative; flex:1; height:calc(var(--value)*1%); background:linear-gradient(#818cf8,#4f46e5); border-radius:6px 6px 2px 2px; } .bar span { position:absolute; bottom:100%; left:0; right:0; text-align:center; font-size:10px; color:var(--muted); }
  .axis { display:flex; gap:7px; margin-top:6px; } .axis span { flex:1; text-align:center; font-size:10px; color:#94a3b8; }
  .table-wrap { overflow-x:auto; margin-top:8px; } table { width:100%; min-width:420px; border-collapse:collapse; font-size:12px; } th,td { padding:7px 6px; border-bottom:1px solid var(--line); text-align:left; } th { color:var(--muted); font-weight:600; }
  .activity { display:grid; gap:10px; margin:10px 0 0; padding:0; list-style:none; } .activity li { display:flex; align-items:flex-start; gap:8px; font-size:12px; } .activity p { margin:0; color:#475569; line-height:1.5; } .avatar { display:grid; place-items:center; width:28px; height:28px; flex:none; border-radius:50%; background:#e0e7ff; color:#3730a3; font-size:10px; font-weight:700; }
  :focus-visible { outline:3px solid #a5b4fc; outline-offset:2px; } .sr-only { position:absolute; width:1px; height:1px; overflow:hidden; clip-path:inset(50%); white-space:nowrap; }
  @media (max-width:820px) { .app { grid-template-columns:1fr; grid-template-areas:"top" "side" "main"; } .side { gap:16px; } .side nav { grid-auto-flow:column; overflow-x:auto; } .lower { grid-template-columns:1fr; } }
</style>
```

> **Tip:** At 1100 px the shell has two tracks. At 820 px it becomes one. The stat grid does not need a media query because `auto-fit` and `minmax` already respond to available width. Use the simplest mechanism that expresses the behavior.

## Recap

- Build the app shell from named Grid areas, and use `minmax(0, 1fr)` so a wide child cannot force the page wider.
- The skip link, `aria-current="page"` and a labelled search input are part of the layout, not an accessibility afterthought.
- Stat cards need a heading, a value and a trend with an arrow plus text, not color alone.
- A CSS-only chart is a row of proportional bars with a definite height and an `aria-label`; the table remains the exact source of data.
- Tables need a caption, `scope` on headers and an `overflow-x: auto` wrapper. `min-width: 0` on the grid child is what lets the wrapper do its job.
- Activity feeds use lists and `<time datetime>`; decorative avatars are hidden from assistive technology.
- Collapse the shell with a media query at a width the layout actually needs, and let the card grid reflow with `auto-fit`.
- Test at 1100 px for the desktop composition and at a narrow width for the collapsed one. A dashboard that only works at one width is unfinished.

**Up next:** the second capstone. You will extract this visual language into a reusable design system: tokens, themes, button variants, form states, cards, badges and a component gallery organized with `@layer`.
