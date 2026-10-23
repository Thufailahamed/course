Three links in a row. A logo pinned to the left and a menu pinned to the right. Three cards that share the width and stretch to the same height. For years, this kind of layout meant floats, clearfixes and a stack of negative margins. Flexbox turned it into a handful of declarations you can reason about.

Flexbox is a **one-dimensional** layout system. You put a set of items on a line, choose which way the line runs, then decide how the items share the space along it and how they align across it. That sounds narrow, but it covers navigation bars, card rows, media objects, toolbars and most of the small layouts inside a page. Once the axis model clicks, you stop guessing at margins.

## One axis at a time

You opt in by putting `display: flex` on a **container**. Its direct children become **flex items**. The container keeps its normal place in the document, but inside it the children are arranged by flex rules instead of the normal block flow.

Every flex container has two axes:

- The **main axis** is the direction the items flow. With the default `flex-direction: row`, it runs left to right.
- The **cross axis** is perpendicular to it. For a row, it runs top to bottom.

`gap` adds space *between* items without adding space around the outside. That is the detail that makes flexbox feel tidy: you no longer give every item a right margin and then remove the last one.

```html run
<header class="trail-bar">
  <span class="mark">Moss &amp; Pine</span>
  <span class="route">Edale · 12 km</span>
  <span class="weather">Cloud, 9°C</span>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .trail-bar {
    display: flex;
    gap: 1.5rem;
    align-items: center;
    padding: 1rem 1.5rem;
    background: #0f172a;
    color: #e2e8f0;
  }
  .mark { font-weight: 700; }
  .route, .weather { color: #94a3b8; font-size: 0.9rem; }
</style>
```

Remove `display: flex` and the three spans return to normal inline flow. They still sit on one line, but `gap` stops working and `align-items` has nothing to align. That is a useful experiment: flex is doing the spacing and vertical alignment, not the fact that spans are inline.

> **Under the hood:** A flex container creates a new **flex formatting context**. Margins between flex items do not collapse the way they do between block elements, and `vertical-align` no longer applies to the items. This is why a layout that looked fine with inline-block can shift when you switch it to flex.

## Which way the line runs

`flex-direction` changes the main axis:

| Value | Main axis | Typical use |
|---|---|---|
| `row` (default) | left to right | navigation, card rows, toolbars |
| `column` | top to bottom | stacked menus, card content |
| `row-reverse` | right to left | rare; visual order changes |
| `column-reverse` | bottom to top | rare; visual order changes |

Direction also changes what `justify-content` and `align-items` mean. In a row, `justify-content` works horizontally. In a column, it works vertically. That is the single most common source of confusion, and the reason to name the axes out loud before you debug.

By default, flex items try to fit on one line. They shrink if they can, and if they cannot, they overflow. `flex-wrap: wrap` lets them move onto a new line instead. Wrapping is what turns a rigid row into a tag cloud, a photo strip or a navigation bar that survives a narrow window.

```html run
<section class="notes">
  <h2>Trail notes</h2>
  <ul class="tags">
    <li>waterproofs</li>
    <li>map and compass</li>
    <li>extra socks</li>
    <li>flask</li>
    <li>dog treats</li>
  </ul>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  h2 { margin: 0 0 1rem; font-size: 1.1rem; }
  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    max-width: 24rem;
    margin: 0;
    padding: 0;
    list-style: none;
  }
  .tags li {
    padding: 0.35rem 0.75rem;
    border-radius: 999px;
    background: #ecfdf5;
    color: #065f46;
    font-size: 0.85rem;
  }
</style>
```

The tags wrap because the container is capped at `24rem`. Without `flex-wrap`, the list would stay on one line and the last tags would spill out of the container. That is the bug in the debug challenge below.

## Debug: the row that would not wrap

This card row looked fine on a wide monitor and breaks on a laptop. The cards have a fixed basis of `380px`, there are three of them, and the row is capped at `960px`. The maths does not fit, and because the row cannot wrap, the third card pushes the page sideways.

Run it, then drag the preview wider and narrower. The page should never scroll horizontally.

```html debug id=overflowing-card-row title="The row that would not wrap"
<section class="row">
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides, a sensible pace.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots and packs, ready for the weather.</p>
  </article>
  <article class="card">
    <h2>Trail notes</h2>
    <p>Routes tested every season by people who live here.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; max-width: 960px; margin: 0 auto; }
  .card {
    flex: 0 0 380px;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- solution
<section class="row">
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides, a sensible pace.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots and packs, ready for the weather.</p>
  </article>
  <article class="card">
    <h2>Trail notes</h2>
    <p>Routes tested every season by people who live here.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; flex-wrap: wrap; gap: 24px; max-width: 960px; margin: 0 auto; }
  .card {
    flex: 0 0 380px;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- test
assertStyle(".row", "display", "flex", "The row needs display: flex before wrapping can help.");
assertStyle(".row", "flex-wrap", "wrap", "The row is still nowrap, so the third card is pushed off the right edge. Let the row wrap.");
assertNoOverflow("The page still scrolls sideways. Check the row's width and whether it is allowed to wrap.");
const row = query(".row").getBoundingClientRect();
document.querySelectorAll(".card").forEach((card, index) => {
  const box = card.getBoundingClientRect();
  assert(box.right <= row.right + 1, "Card " + (index + 1) + " still extends past the row's right edge. Wrapping should bring it back inside.");
});
--- hint
The row has `display: flex`, but its default `flex-wrap` is `nowrap`. The three fixed cards cannot shrink below `380px`.
--- hint
Add `flex-wrap: wrap` to `.row`. The third card will move to a second line instead of widening the page.
--- hint
The finished rule starts `.row { display: flex; flex-wrap: wrap; gap: 24px; ... }`. Keep the fixed card width; the point is the wrapping, not the sizing.
```

> **Pitfall:** A flex item's default minimum width is its content's minimum size. A long unbroken word, a wide image or a `<pre>` block can stop an item from shrinking even when you set `flex: 1`. Set `min-width: 0` on the item when you genuinely need it to shrink.

## Alignment: the two questions

Every alignment decision starts with one question: *am I aligning along the main axis or across it?*

- `justify-content` distributes items along the **main axis**.
- `align-items` aligns items along the **cross axis**.

For a row, `justify-content: space-between` pushes the first item to the left edge and the last to the right edge. `align-items: center` lines the items up vertically in the middle of the row. Swap those two properties and you get a very different page.

The values worth knowing for `justify-content` are `flex-start`, `center`, `flex-end`, `space-between`, `space-around` and `space-evenly`. For `align-items`, the default is `stretch`, which makes items fill the cross axis. That default is why flex cards in a row end up the same height even when their text differs.

```html run
<div class="toolbar">
  <strong>Weekend walks</strong>
  <span class="count">3 saved</span>
</div>
<article class="note">
  <span class="pin" aria-hidden="true"></span>
  <div>
    <h2>Kinder Scout</h2>
    <p>Start early. The plateau is exposed, and the café closes at four.</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 34rem;
    padding: 0.75rem 1rem;
    border-radius: 10px;
    background: #0f172a;
    color: #fff;
  }
  .count { color: #94a3b8; font-size: 0.85rem; }
  .note {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    max-width: 34rem;
    margin-top: 1rem;
    padding: 1.25rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  .pin { flex: none; width: 12px; height: 12px; margin-top: 0.45rem; border-radius: 50%; background: #b45309; }
  h2 { margin: 0 0 0.35rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The pin uses `align-items: flex-start`, not `center`, because it should line up with the first line of the heading rather than float in the middle of a three-line block. The toolbar uses `center` because its two pieces are single lines. Alignment is a design decision, not a default you accept without looking.

```html predict id=flex-predict-space-between title="Where does space-between put three items?"
<div class="bar">
  <span>One</span>
  <span>Two</span>
  <span>Three</span>
</div>

<style>
  .bar { display: flex; justify-content: space-between; width: 30rem; padding: 0.75rem 1rem; background: #f1f5f9; }
</style>
--- options
* First at the left edge, last at the right edge, with equal gaps between the items
All three packed at the left edge, with equal gaps after them
Each item centred inside its own equal third of the bar
First at the left edge, second and third packed together at the right
--- explain
`space-between` puts the first item at the start and the last at the end, then divides the remaining free space equally *between* the items. There is no space before the first item or after the last. With three items you get two equal gaps. The middle item sits at the midpoint only when the first and last items happen to be the same width.
```

## Sizing: fixed, fluid and flex

Flexbox gives you three levers for how an item uses space:

- `flex-grow`: how much of the leftover space this item should take.
- `flex-shrink`: whether the item may shrink when space runs out.
- `flex-basis`: the starting size before growing or shrinking.

The shorthand `flex: 1` means `flex: 1 1 0%`. Every item with `flex: 1` starts from zero and then takes an equal share of the free space, which produces equal-width columns regardless of content. `flex: auto` means `flex: 1 1 auto`, so items start at their content size and only then share what is left. The difference matters when one card has a long heading.

A fixed sidebar uses `flex: 0 0 240px`: do not grow, do not shrink, start at 240 pixels. The main area uses `flex: 1` and absorbs the rest. That fixed-versus-fluid pairing is the backbone of dashboards, documentation sites and application shells.

```html run
<section class="cards">
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
    <p>Small groups, local guides, a sensible pace and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: flex; gap: 1rem; max-width: 60rem; margin: 0 auto; }
  .card {
    flex: 1;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
```

The third card has more text, but all three cards are the same width because `flex: 1` ignores content when distributing space. They are also the same height because `align-items` defaults to `stretch`. Remove `flex: 1` and each card shrinks to its content; the row stops looking like a row.

## Challenge: three equal cards

Build a row of three cards that share the available width and stretch to the same height. The starter already has the markup and the card styling; the row is still a normal block, so each card takes the full width.

Use `display: flex` on `.cards`, `gap` for the space between cards, and `flex: 1` on each card. Keep the row's maximum width at `60rem`.

```html exercise id=equal-card-row title="Three cards, one equal row"
<section class="cards">
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
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { max-width: 60rem; margin: 0 auto; }
  .card {
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- solution
<section class="cards">
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
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: flex; gap: 1rem; max-width: 60rem; margin: 0 auto; }
  .card {
    flex: 1;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- test
assertStyle(".cards", "display", "flex", "The cards are still stacked as blocks. Put display: flex on .cards.");
const cards = Array.from(document.querySelectorAll(".card"));
assert(cards.length === 3, "Keep exactly three cards in the row.");
const boxes = cards.map((card) => card.getBoundingClientRect());
const widths = boxes.map((box) => box.width);
const rounded = widths.map((width) => Math.round(width));
assert(Math.max(...widths) - Math.min(...widths) < 1.5, "The cards should share the width equally, but they are " + rounded.join("px, ") + "px wide. Use flex: 1 on each card.");
const heights = boxes.map((box) => box.height);
assert(Math.max(...heights) - Math.min(...heights) < 2, "The cards should stretch to the same height. Check that .cards still uses align-items: stretch (the default) and that no card has a fixed height.");
const row = query(".cards");
const rowStyle = getComputedStyle(row);
const gap = parseFloat(rowStyle.gap) || 0;
const contentWidth = row.getBoundingClientRect().width - parseFloat(rowStyle.paddingLeft) - parseFloat(rowStyle.paddingRight);
const used = widths.reduce((total, width) => total + width, 0) + gap * (cards.length - 1);
assert(Math.abs(contentWidth - used) <= 2, "The row leaves " + Math.round(contentWidth - used) + "px of unused space. flex: 1 should make the cards fill the whole row.");
assertColor(".card", "background-color", "#ffffff", "Keep the card background white so the row reads as three separate cards.");
--- hint
The parent is the flex container, not the cards. Start with `display: flex` on `.cards`.
--- hint
Add `gap: 1rem` to `.cards`, then `flex: 1` to `.card` so each card starts at zero and takes an equal share.
--- hint
Your `.card` rule needs `flex: 1` alongside the padding, border, radius and background that are already there.
```

> **In the wild:** A fixed sidebar plus a fluid main area is usually `flex: 0 0 240px` and `flex: 1`. When you see a layout where the sidebar mysteriously shrinks as the main content grows, the sidebar is missing `flex-shrink: 0` or is using `flex: 1` by mistake.

## Build a navigation bar

A navigation bar is the classic flexbox exercise because it combines everything above: a row, two groups, vertical centring and a little wrapping for narrow screens.

The pattern is simple. Put `display: flex` and `justify-content: space-between` on the bar. Put the brand first and the list of links second. Make the list itself a flex row with its own `gap`. Reset the list's default margin, padding and bullets.

```html run
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 1rem 2rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.5rem;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; flex-wrap: wrap; gap: 1.25rem; margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
  .links a:hover { color: #0f172a; }
</style>
```

`justify-content: space-between` works because there are exactly two children of `.nav`: the brand and the list. If you add a third child — a search box, say — the free space is distributed between all three, and the brand may no longer sit hard left. At that point a wrapper for the right-hand group, or a grid, is clearer than piling on margins.

> **Tip:** `flex-wrap: wrap` on the nav is a cheap responsive win. On a narrow screen the links drop to a second line instead of overflowing. It is not a substitute for a proper mobile menu, but it is a solid no-JavaScript baseline.

## Challenge: logo left, links right

Build the split navigation bar. The markup is already there: a brand link and an unordered list of four links inside `nav.nav`. The starter has no flex rules, so the brand and the list stack vertically and the links sit in a bulleted column.

Your job is to put the brand on the left, the links on the right and the links in a single horizontal row. Keep the existing colours and spacing.

```html exercise id=nav-split title="Logo left, links right"
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav { max-width: 64rem; margin: 0 auto; padding: 1rem 1.5rem; }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
</style>
--- solution
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 2rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.5rem;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; gap: 1.25rem; margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
</style>
--- test
assertStyle(".nav", "display", "flex", "The nav is still a block, so its children stack. Put display: flex on .nav.");
const navElement = query(".nav");
const navStyle = getComputedStyle(navElement);
const nav = navElement.getBoundingClientRect();
const contentLeft = nav.left + parseFloat(navStyle.paddingLeft);
const contentRight = nav.right - parseFloat(navStyle.paddingRight);
const brand = query(".brand").getBoundingClientRect();
const links = query(".links").getBoundingClientRect();
const anchors = Array.from(document.querySelectorAll(".links a")).map((a) => a.getBoundingClientRect());
assert(anchors.length === 4, "Keep all four navigation links.");
assert(brand.left - contentLeft < 12, "The brand should sit at the left edge of the nav, but it starts " + Math.round(brand.left - contentLeft) + "px in.");
assert(contentRight - links.right < 12, "The links should sit at the right edge of the nav, but they end " + Math.round(contentRight - links.right) + "px short.");
assert(brand.right < links.left, "The brand and the links are overlapping or touching. Give the two groups room and push them apart.");
const tops = anchors.map((box) => box.top);
assert(Math.max(...tops) - Math.min(...tops) < 2, "The links are still stacked vertically. Make the list itself a flex row.");
assertColor(".brand", "color", "#0f172a", "Keep the brand in the dark ink colour (#0f172a).");
--- hint
You need flex on two elements: the bar that holds the brand and list, and the list that holds the four links.
--- hint
`justify-content: space-between` on `.nav` pushes the brand left and the list right. `align-items: center` keeps them on the same vertical line.
--- hint
`.links` needs `display: flex` and a `gap`. The list's default padding and bullets are already reset for you.
```

## When Grid is the better tool

Flexbox is excellent at arranging items along one line. It is not the right tool for a layout that needs to align items in rows *and* columns, especially when the rows should share a consistent structure. If you find yourself nesting flex rows inside flex columns to fake a table, stop and reach for CSS Grid.

| Need | Better tool |
|---|---|
| Navbar, toolbar, button group | Flexbox |
| Three cards that share one row | Flexbox |
| Sidebar plus fluid main area | Flexbox or Grid |
| Photo gallery with aligned rows and columns | Grid |
| Whole-page layout with header, sidebar, main and footer | Grid |
| Centring one item in a box | Grid (`display: grid; place-items: center`) or flex with `justify-content` and `align-items` |

The two work together. A page shell might be a grid, while the navigation bar inside its header is flex. A card grid might be a grid, while the row of tags inside each card is flex. Choose per container, not per project.

> **Pitfall:** `justify-content` has no effect when the items already fill the main axis. If your `space-between` seems to do nothing, check whether the container is wider than its contents. A flex container that shrink-wraps its items has no free space to distribute.

## Recap

- `display: flex` turns a container's direct children into flex items along one main axis.
- `flex-direction` chooses the main axis; `justify-content` aligns along it, `align-items` across it.
- `gap` spaces items without outer margins; `flex-wrap` lets a row break onto new lines.
- `flex: 1` gives items equal shares of the free space; `flex: 0 0 240px` pins a fixed sidebar.
- A navbar is usually `display: flex; justify-content: space-between; align-items: center` with a nested flex list.
- Fixed-width rows need `flex-wrap` or a smaller basis, or they will push the page sideways.

**Up next:** CSS Grid, where you stop arranging one line at a time and start describing the whole layout at once.
