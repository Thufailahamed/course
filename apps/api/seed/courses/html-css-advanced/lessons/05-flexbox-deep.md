Flexbox is not a grid with one dimension. It is a distribution algorithm. You give it a row or a column, a set of base sizes, and some rules about how to divide the space that is left. Most Flexbox bugs come from forgetting which of those three things the browser is actually solving.

The most famous bug is the `flex: 1` child that refuses to shrink. It is not refusing. It is respecting a minimum size you did not know it had. Once you can see the base size, the free space and the automatic minimum, the layout stops being mysterious.

## The axis comes first

Every Flexbox layout has a **main axis** and a **cross axis**. `flex-direction` decides which is which:

- `row` (the default): main axis horizontal, cross axis vertical.
- `column`: main axis vertical, cross axis horizontal.
- `row-reverse` and `column-reverse`: same axes, opposite direction.

The alignment properties follow the axes, not the screen. `justify-content` distributes items along the **main** axis. `align-items` aligns items along the **cross** axis. This is why `justify-content: center` centres horizontally in a row but vertically in a column.

`align-content` is different again: it distributes the **lines** created by `flex-wrap` along the cross axis. It has no effect on a single-line flex container. `align-self` overrides `align-items` for one item.

```html run
<div class="toolbar">
  <strong class="brand">Trailhead</strong>
  <nav class="links"><a href="#">Notes</a><a href="#">Routes</a></nav>
  <button type="button">New note</button>
</div>
<div class="toolbar column">
  <strong class="brand">Column direction</strong>
  <nav class="links"><a href="#">Notes</a><a href="#">Routes</a></nav>
  <button type="button">New note</button>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; display: grid; gap: 16px; max-width: 760px; }
  .toolbar { display: flex; justify-content: space-between; align-items: center; gap: 16px; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .toolbar.column { flex-direction: column; align-items: flex-start; }
  .brand { color: #0f172a; }
  .links { display: flex; gap: 12px; }
  .links a { color: #0f766e; text-decoration: none; font-weight: 600; }
</style>
```

In the row, `justify-content: space-between` pushes the brand and the button to the edges, and `align-items: center` keeps everything on the vertical centre line. In the column, the same `space-between` distributes along the vertical axis, and `align-items: flex-start` packs the items to the left. The property names did not change; the axes did.

> **Tip:** If `justify-content` seems to do the wrong thing, check `flex-direction` before you check the value. A column layout swaps the meaning of every alignment property.

## Growing and shrinking: basis first, then free space

Each flex item starts from its **flex base size**, determined by `flex-basis` (or `width`/`height` if `flex-basis` is `auto`). The browser sums those base sizes and the gaps, subtracts the total from the container, and calls the result **free space**.

- If free space is positive, `flex-grow` factors divide it.
- If free space is negative, `flex-shrink` factors decide who gives up space, weighted by base size. The scaled shrink factor is `flex-shrink` multiplied by the base size, so a wide item gives up more than a narrow item with the same shrink value.
- If free space is zero, nothing grows or shrinks.

The `flex` shorthand sets grow, shrink and basis in one declaration:

| Shorthand | Equivalent | What it means |
|---|---|---|
| `flex: 1` | `1 1 0%` | Share space equally from a zero base |
| `flex: auto` | `1 1 auto` | Grow and shrink from the content size |
| `flex: none` | `0 0 auto` | Keep the natural size; do not grow or shrink |
| `flex: initial` | `0 1 auto` | Do not grow, but allow shrinking |
| `flex: 2` | `2 1 0%` | Take twice the share of a `flex: 1` sibling |

The difference between `flex: 1` and `flex: auto` is the base. With `flex: 1`, every item starts at zero and the grow factors decide the final widths, so equal factors produce equal widths even if the content differs. With `flex: auto`, the content size is the starting point, so a longer label starts wider and then shares the remaining space.

`flex-basis` is not a synonym for `width`. It sets the initial main size used by the flex algorithm; the used size can still be constrained by `min-width`, `max-width` and the item's content. When `flex-basis` is `auto`, the browser looks at the item's `width` (or `height` in a column), then falls back to the content size. `box-sizing: border-box` makes the basis include padding and border, which is usually what you want when you reason about percentages.

```html run
<div class="row">
  <div class="cell a">A · grow 1</div>
  <div class="cell b">B · grow 2</div>
  <div class="cell c">C · grow 1</div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; width: 600px; max-width: 100%; border: 1px solid #cbd5e1; border-radius: 10px; overflow: hidden; background: #ffffff; }
  .cell { flex: 1 1 100px; box-sizing: border-box; padding: 18px 8px; text-align: center; font-weight: 600; }
  .a { background: #ccfbf1; color: #0f766e; }
  .b { flex-grow: 2; background: #0f766e; color: #ffffff; }
  .c { background: #e2e8f0; color: #0f172a; }
</style>
```

The row is 600px wide. Each item has a 100px basis, so the base total is 300px and the free space is 300px. The grow factors are 1, 2 and 1, a total of 4. The free space splits into 75px, 150px and 75px. Add the basis back and the widths are 175px, 250px and 175px. B is not twice as wide as A in total; it receives twice the *free space*. That distinction is the source of a thousand "why is my sidebar not 25%" questions.

> **Pitfall:** `flex: 1` sets `flex-basis: 0%`, not `auto`. If you want content to influence the starting width, use `flex: auto` or write the basis explicitly.

## The min-content trap

A flex item has an automatic minimum size on the main axis: `min-width: auto` in a row, `min-height: auto` in a column. In most cases that minimum is the item's **min-content size** — the smallest width the content can take without overflowing. A long unbroken word, a `<pre>` block, an image, or a table can make that minimum much larger than you expect.

`flex-shrink` cannot shrink an item below its minimum. So a `flex: 1` child with a long email address will refuse to shrink, and the row will overflow. The fix is usually two parts:

```css
.body {
  min-width: 0;
}
.email {
  overflow-wrap: anywhere;
}
```

`min-width: 0` removes the automatic minimum and lets the flex item become narrower than its content's min-content size. Then you need a strategy for the content: wrap it, clip it with `overflow: hidden`, add `text-overflow: ellipsis`, or let it scroll with `overflow-x: auto`. Setting `overflow` to anything other than `visible` also changes the automatic minimum size in modern browsers, but explicit `min-width: 0` is easier to read and reason about.

```html run
<div class="compare">
  <section class="panel">
    <p class="tag">Without min-width: 0</p>
    <div class="row">
      <div class="avatar">AR</div>
      <div class="body"><p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p></div>
    </div>
  </section>
  <section class="panel">
    <p class="tag">With min-width: 0</p>
    <div class="row fixed">
      <div class="avatar">AR</div>
      <div class="body"><p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p></div>
    </div>
  </section>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .compare { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; max-width: 900px; }
  .panel { min-width: 0; padding: 12px; border: 2px dashed #cbd5e1; border-radius: 12px; background: #ffffff; }
  .tag { margin: 0 0 10px; font-size: 0.75rem; font-weight: 700; color: #475569; }
  .row { display: flex; gap: 12px; }
  .avatar { flex: none; display: grid; place-items: center; width: 44px; height: 44px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; font-size: 0.8rem; }
  .body { flex: 1; }
  .fixed .body { min-width: 0; }
  .email { margin: 0; color: #475569; font-size: 0.9rem; }
  .fixed .email { overflow-wrap: anywhere; }
</style>
```

In the left panel the email's min-content width wins, and the text spills past the card. In the right panel `min-width: 0` lets the body shrink, and `overflow-wrap: anywhere` gives the long address somewhere to break. The text is not smaller; the container is finally allowed to be smaller than the text's longest word.

> **Under the hood:** The automatic minimum is not always exactly min-content. It can be the specified size, the transferred size from an aspect ratio, or zero when the item has `overflow` other than `visible`. For everyday layout work, "min-content unless you opt out" is the right mental model.

In a column, the equivalent trap is `min-height: auto`. A flex column with a scrolling panel or a nested grid can refuse to shrink vertically for exactly the same reason. Set `min-height: 0` on the column item and give the inner scroller `overflow-y: auto`.

## Wrapping, gaps and changing order

`flex-wrap: wrap` lets items move onto new lines when they run out of main-axis space. Once there is more than one line, `align-content` controls how those lines are distributed on the cross axis. `gap` is subtracted from the container's space before free space is distributed; it is not a margin on the items, and it does not appear between the item and the container edge.

`order` changes the visual order of flex items without changing the DOM order, the tab order or the order a screen reader announces. That makes it dangerous for meaningful content. Use it for purely visual rearrangements, or better, change the markup. If the order matters to a keyboard user, it should be the same in the DOM.

`align-self` lets one item break from the container's `align-items` rule. An auto margin is another single-item tool: `margin-left: auto` absorbs all the free space to the left of an item, pushing it to the right.

```html run
<div class="tags">
  <span class="tag">research</span>
  <span class="tag">field notes</span>
  <span class="tag pinned">pinned</span>
  <span class="tag">packing</span>
  <span class="tag">weather</span>
  <span class="tag">routes</span>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .tags { display: flex; flex-wrap: wrap; gap: 8px 12px; align-content: space-between; width: 300px; height: 190px; padding: 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .tag { padding: 6px 10px; border-radius: 999px; background: #e2e8f0; color: #0f172a; font-size: 0.8rem; font-weight: 600; }
  .pinned { order: -1; align-self: flex-start; background: #ccfbf1; color: #0f766e; }
</style>
```

The tags wrap into several lines inside a fixed-height box. `align-content: space-between` spreads those lines vertically. The pinned tag has `order: -1`, so it appears first visually even though it is third in the markup, and `align-self: flex-start` keeps it at the top of its line.

`align-content` only has work to do once there are multiple lines. With `flex-wrap: nowrap`, or with content that fits on one line, it is ignored. If a wrapped layout has uneven vertical gaps, check whether `align-content` is stretching the lines rather than the items inside them.

> **In the wild:** A search toolbar is a classic flex layout: brand `flex: none`, search `flex: 1`, actions `flex: none`, one `gap`. The same pattern powers media objects, button groups and pagination.

## When Flexbox is the wrong tool

Flexbox is excellent for one-dimensional problems: toolbars, navigation, button groups, media objects, centring a single item, distributing a row of cards. It is the wrong tool when you need rows and columns to agree.

- **Two-dimensional grids.** If the item in row two, column three must line up with row one, column three, use CSS Grid.
- **Page layout with named regions.** Grid's `grid-template-areas` expresses the page structure directly.
- **Overlapping content.** Grid or positioning, not flex.
- **Masonry or packed layouts.** Grid or a dedicated masonry layout, not `flex-wrap`.

The test is simple: if you find yourself nesting flex containers and setting percentage widths to force alignment, you are building a grid. Use one.

```html run
<div class="grid">
  <article class="card"><h2>Starter</h2><p>For one person and a side project.</p></article>
  <article class="card"><h2>Studio</h2><p>For a small team shipping every week.</p></article>
  <article class="card"><h2>Studio plus</h2><p>For a team that needs a shared library and review.</p></article>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; max-width: 820px; }
  .card { padding: 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .card h2 { margin: 0 0 6px; font-size: 1.05rem; }
  .card p { margin: 0; color: #475569; line-height: 1.45; }
</style>
```

This is a two-dimensional layout. The cards share a row and their heights align because the grid owns the rows. A `flex-wrap` version would align each line independently, which is fine for tags but wrong for a pricing table.

## Challenge: a toolbar where search grows

Lay out the toolbar with Flexbox. The search field should take the remaining space, the brand and actions should keep their natural width, and the whole bar should stay on one line with a 12px gap.

```html exercise id=flex-toolbar title="A toolbar that knows who grows"
<header class="toolbar">
  <a class="brand" href="#">Trailhead</a>
  <label class="search">
    <span class="visually-hidden">Search</span>
    <input type="search" placeholder="Search notes">
  </label>
  <div class="actions">
    <button type="button">Filter</button>
    <button type="button">New note</button>
  </div>
</header>
<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { max-width: 880px; margin: 24px auto; padding: 0 16px; }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .search input { width: 100%; box-sizing: border-box; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .actions button { padding: 9px 12px; border: 0; border-radius: 8px; background: #e2e8f0; font: inherit; font-weight: 600; }
  /* TODO: display the toolbar as a row, centre the items, add a 12px gap,
     let the search field grow, and keep the actions at their natural width. */
</style>
--- solution
<header class="toolbar">
  <a class="brand" href="#">Trailhead</a>
  <label class="search">
    <span class="visually-hidden">Search</span>
    <input type="search" placeholder="Search notes">
  </label>
  <div class="actions">
    <button type="button">Filter</button>
    <button type="button">New note</button>
  </div>
</header>
<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { display: flex; align-items: center; gap: 12px; max-width: 880px; margin: 24px auto; padding: 0 16px; }
  .brand { flex: none; color: #0f172a; font-weight: 700; text-decoration: none; }
  .search { flex: 1 1 auto; min-width: 0; }
  .search input { width: 100%; box-sizing: border-box; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .actions { display: flex; flex: none; gap: 8px; }
  .actions button { padding: 9px 12px; border: 0; border-radius: 8px; background: #e2e8f0; font: inherit; font-weight: 600; }
</style>
--- test
assertStyle(".toolbar", "display", "flex", "The toolbar is still a block. Give it display: flex.");
assertStyle(".toolbar", "align-items", "center", "Centre the items on the cross axis with align-items: center.");
assertStyle(".toolbar", "gap", "12px", "The toolbar should use a 12px gap between its three children.");
assertStyle(".search", "flex-grow", "1", "The search field should grow into the remaining space. Give it flex: 1 or flex-grow: 1.");
assertStyle(".actions", "flex-shrink", "0", "The actions should keep their natural width. flex: none sets shrink to 0; it currently computes to " + getComputedStyle(query(".actions")).flexShrink + ".");
var searchBox = query(".search").getBoundingClientRect();
var actionsBox = query(".actions").getBoundingClientRect();
assert(searchBox.width > 300, "The search field should take the remaining width, but it computes to " + Math.round(searchBox.width) + "px.");
assert(searchBox.width > actionsBox.width * 2, "The search field should be much wider than the action group. Check which child is growing.");
assertNoOverflow("The toolbar should fit inside the page without horizontal scrolling.");
--- hint
Start with `display: flex`, `align-items: center` and `gap: 12px` on the toolbar.
--- hint
`flex: none` on the actions means "do not grow, do not shrink". That is what you want for the buttons.
--- hint
Give the search wrapper `flex: 1` (or `flex: 1 1 auto`) and add `min-width: 0` so the input can shrink on narrow screens.
```

## Challenge: the card that will not break

The email address is one long unbroken token. Its min-content width is forcing the `.body` flex item wider than the card. Let the body shrink and break the address so it wraps inside the card.

```html exercise id=flex-long-word title="Break the long address"
<article class="card">
  <div class="avatar" aria-hidden="true">AR</div>
  <div class="body">
    <h2>Alex Rivera</h2>
    <p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { display: flex; gap: 16px; width: 340px; padding: 16px; border: 1px solid #cbd5e1; border-radius: 12px; background: #ffffff; }
  .avatar { flex: none; display: grid; place-items: center; width: 48px; height: 48px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; }
  .body { flex: 1; }
  .body h2 { margin: 0; font-size: 1.1rem; }
  .email { margin: 4px 0 0; color: #475569; }
  /* TODO: let the body shrink, then let the address break inside it. */
</style>
--- solution
<article class="card">
  <div class="avatar" aria-hidden="true">AR</div>
  <div class="body">
    <h2>Alex Rivera</h2>
    <p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { display: flex; gap: 16px; width: 340px; padding: 16px; border: 1px solid #cbd5e1; border-radius: 12px; background: #ffffff; }
  .avatar { flex: none; display: grid; place-items: center; width: 48px; height: 48px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; }
  .body { flex: 1; min-width: 0; }
  .body h2 { margin: 0; font-size: 1.1rem; }
  .email { margin: 4px 0 0; color: #475569; overflow-wrap: anywhere; }
</style>
--- test
var card = query(".card");
assert(card.scrollWidth <= card.clientWidth + 1, "The card's content is still wider than its box (scrollWidth " + card.scrollWidth + " vs clientWidth " + card.clientWidth + "). The long email is setting a min-content width.");
var body = query(".body");
assert(body.getBoundingClientRect().right <= card.getBoundingClientRect().right + 1, "The body still extends past the card's right edge. Let the flex item shrink with min-width: 0.");
var email = query(".email");
assert(email.getBoundingClientRect().height > 30, "The email is still on one line. Give it overflow-wrap: anywhere or another breaking strategy so it wraps.");
assertNoOverflow("The page should not scroll sideways.");
--- hint
The automatic minimum size of a flex item is `min-width: auto`. That is what is holding the body open.
--- hint
Set `min-width: 0` on `.body` first. The item can now shrink, but the unbroken email still overflows inside it.
--- hint
Add `overflow-wrap: anywhere` to the email. `word-break: break-word` or `overflow-wrap: break-word` also work once the body can shrink.
```

## Debug: the panel that refuses to shrink

The two-column shell overflows its 880px container. The sidebar is fixed, and `.main` is `flex: 1`, but the long command inside the `<pre>` is setting the main panel's min-content width. Let the main panel shrink, and keep the command on one line by letting it scroll inside the code block.

```html debug id=flex-nested-panel title="The panel that refuses to shrink"
<div class="shell">
  <aside class="sidebar">
    <p class="label">Workspace</p>
    <nav><a href="#">Deployments</a><a href="#">Logs</a></nav>
  </aside>
  <main class="main">
    <h1>Deploy log</h1>
    <pre>git push origin release/2026-10-23 --force-with-lease --no-verify --set-upstream</pre>
  </main>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .shell { display: flex; gap: 16px; max-width: 880px; margin: 0 auto; }
  .sidebar { flex: 0 0 220px; padding: 16px; background: #f1f5f9; border-radius: 12px; }
  .label { margin: 0 0 8px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #64748b; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar a { color: #0f766e; text-decoration: none; font-weight: 600; }
  .main { flex: 1; padding: 20px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; }
  .main h1 { margin: 0; font-size: 1.3rem; }
  .main pre { margin: 12px 0 0; padding: 12px; background: #0f172a; color: #e2e8f0; border-radius: 8px; }
  /* TODO: the main panel should shrink to fit the shell, and the command
     should scroll inside the pre instead of stretching the panel. */
</style>
--- solution
<div class="shell">
  <aside class="sidebar">
    <p class="label">Workspace</p>
    <nav><a href="#">Deployments</a><a href="#">Logs</a></nav>
  </aside>
  <main class="main">
    <h1>Deploy log</h1>
    <pre>git push origin release/2026-10-23 --force-with-lease --no-verify --set-upstream</pre>
  </main>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .shell { display: flex; gap: 16px; max-width: 880px; margin: 0 auto; }
  .sidebar { flex: 0 0 220px; padding: 16px; background: #f1f5f9; border-radius: 12px; }
  .label { margin: 0 0 8px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #64748b; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar a { color: #0f766e; text-decoration: none; font-weight: 600; }
  .main { flex: 1; min-width: 0; padding: 20px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; }
  .main h1 { margin: 0; font-size: 1.3rem; }
  .main pre { margin: 12px 0 0; padding: 12px; background: #0f172a; color: #e2e8f0; border-radius: 8px; overflow-x: auto; }
  /* The main panel can now shrink, and the pre owns the extra width. */
</style>
--- test
var shell = query(".shell");
assert(shell.scrollWidth <= shell.clientWidth + 1, "The shell is still wider than its 880px container (scrollWidth " + shell.scrollWidth + " vs clientWidth " + shell.clientWidth + "). The pre's min-content width is holding .main open.");
var main = query(".main");
assert(main.getBoundingClientRect().right <= shell.getBoundingClientRect().right + 1, "The main panel still sticks out past the shell's right edge. Give the flex item min-width: 0.");
var pre = query(".main pre");
var overflowX = getComputedStyle(pre).overflowX;
assert(overflowX === "auto" || overflowX === "scroll", "Let the command scroll inside the pre. Its overflow-x computes to " + overflowX + ".");
assert(pre.scrollWidth > pre.clientWidth, "The command should be wider than the pre's visible box so it has something to scroll.");
--- hint
Run it and resize the preview. The sidebar stays 220px; the main panel is the one refusing to give up width.
--- hint
`min-width: auto` on `.main` resolves to the min-content width of the long `<pre>` line.
--- hint
Set `min-width: 0` on `.main` and `overflow-x: auto` on the pre. Then the panel fits and the command scrolls.
```

## Predict: how does the free space split?

The row is 600px wide. Each item starts from a 100px basis and has `box-sizing: border-box`. Read the grow factors, then choose the final widths.

```html predict id=flex-predict-free-space title="How does the free space split?"
<div class="row">
  <div class="cell a">A</div>
  <div class="cell b">B</div>
  <div class="cell c">C</div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; width: 600px; }
  .cell { flex: 1 1 100px; box-sizing: border-box; padding: 18px 0; text-align: center; font-weight: 700; }
  .a { background: #ccfbf1; color: #0f766e; }
  .b { flex-grow: 2; background: #0f766e; color: #ffffff; }
  .c { background: #e2e8f0; color: #0f172a; }
</style>
--- options
* A 175px, B 250px, C 175px
A 150px, B 300px, C 150px
A 200px, B 200px, C 200px
A 100px, B 400px, C 100px
--- explain
The three 100px bases total 300px, leaving 300px of free space. The grow factors are 1, 2 and 1, a total of 4. A and C each receive one quarter of the free space (75px), so they end at 175px. B receives two quarters (150px), so it ends at 250px. If the basis were 0, the widths would be 150px, 300px and 150px instead. Grow distributes free space, not the total width.
```

## Recap

- `flex-direction` defines the main and cross axes; `justify-content` works on the main axis, `align-items` on the cross axis.
- Items start from `flex-basis`, then share positive free space by `flex-grow` and negative free space by `flex-shrink`.
- `flex: 1` means `1 1 0%`. `flex: auto` means `1 1 auto`. The difference is the starting size.
- A flex item's automatic minimum is usually its min-content size. `min-width: 0` (or `min-height: 0`) removes that floor; then choose how the content wraps, clips or scrolls.
- `gap` is subtracted before free space is distributed. `order` and `align-self` change presentation, not DOM order.
- If rows and columns must align, reach for Grid. Flexbox is for one-dimensional distribution.

**Up next:** Grid in depth — intrinsic tracks, `minmax()`, named areas and the layouts that Flexbox should not be asked to solve.
