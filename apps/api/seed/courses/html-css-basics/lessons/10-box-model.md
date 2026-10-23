Here is the bug that teaches the box model. A designer asks for a 300px card. You set `width: 300px`, add `24px` of padding and a `1px` border, and the card renders 350px wide. Nothing is broken. You asked for a 300px *content* box, and the browser politely added the padding and border around it.

Almost every "why does nothing line up?" moment in CSS comes back to this. Once you can see the four nested boxes around every element — content, padding, border, margin — layout stops being guesswork. You stop nudging numbers and start predicting them.

## Four boxes around every element

Every element generates a rectangular box. The box has four layers:

- **Content** is the text, image or child elements. Its size is what `width` and `height` normally control.
- **Padding** is space inside the box, between the content and the border. It takes the element's background color.
- **Border** is the visible edge. It also takes the background color underneath it, unless the border itself has one.
- **Margin** is space outside the border. It is always transparent and pushes other elements away.

```html run
<div class="stage">
  <div class="box">
    <span>content</span>
  </div>
</div>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
  }

  .stage {
    padding: 40px;
    background: #f1f5f9;
  }

  .box {
    width: 240px;
    margin: 32px auto;
    padding: 24px;
    border: 6px solid #0f766e;
    background: #ccfbf1;
  }

  .box span {
    display: block;
    padding: 8px;
    background: white;
  }
</style>
```

The white area is the content. The pale teal ring is padding. The dark teal edge is the border. The grey band around it is the margin, showing the stage background through transparent space. Change the padding to `0` and the content moves outward; the border stays where it is. Change the margin to `0` and the whole box moves.

Padding and margin are not interchangeable. Padding is part of the element and takes its background. Margin is outside the element and never paints. If you want a card's text to breathe, use padding. If you want two cards to separate, use margin (or, later, `gap`).

## Width is a promise about the content box

By default, `box-sizing` is `content-box`. That means `width: 300px` makes the *content* 300px. Padding and border are added on top, so the visible box is wider than 300px.

```html run
<div class="card content">content-box</div>
<div class="card border">border-box</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .card {
    width: 200px;
    margin-bottom: 16px;
    padding: 20px;
    border: 5px solid #0f766e;
    background: #ccfbf1;
  }

  .border {
    box-sizing: border-box;
  }
</style>
```

Both rules say `width: 200px`. The first card's border box is 250px: 200 content + 40 padding + 10 border. The second card's border box is exactly 200px, because `border-box` includes padding and border in the width. The content area shrinks to 150px instead.

`border-box` is usually the more intuitive model. When you say a card is 300px, you mean the thing you can see and measure. Most modern codebases set it globally:

```css
*, *::before, *::after {
  box-sizing: border-box;
}
```

That one rule prevents an entire category of overflow bugs. It does not include margin: a 300px card with `margin: 24px` still occupies 348px of horizontal space in its parent.

## Check the box, not the number

When a box is wider than expected, resist the urge to change the number until you know which box you are measuring. The border box is the useful measurement: content width plus left and right padding plus left and right border. Margin sits outside it.

A 300px content box with 24px padding and a 1px border has a border box of 300 + 48 + 2 = 350px. Add 16px of margin on each side and it occupies 382px of horizontal space in its parent. The inspector's box-model overlay shows all four layers in different colours; use it before doing arithmetic in your head.

With `border-box`, the formula changes: the declared width *is* the border box, and the content area absorbs the padding and border. A 300px border-box card with the same padding and border has 250px of content. That is usually the trade you want: the outside stays predictable, and the text area takes the difference.

> **Pitfall:** `box-sizing` affects width and height, not margin. If a row of three 300px cards plus two 24px gaps does not fit a 960px container, border-box will not save you. The margins are still outside the boxes.

## Challenge: a card that stays exactly 300px

Build the card so its **border box** is exactly 300px wide, including `24px` of padding on every side and a `1px` border. Use `border-box`, and give it a `#ffffff` background.

```html exercise id=exact-card-width title="A 300px card that is actually 300px"
<article class="card">
  <h2>Roast schedule</h2>
  <p>Mondays and Thursdays, early enough that the neighbours complain.</p>
</article>

<style>
  .card {
    /* TODO: make the border box exactly 300px, including padding and border */
  }
</style>
--- solution
<article class="card">
  <h2>Roast schedule</h2>
  <p>Mondays and Thursdays, early enough that the neighbours complain.</p>
</article>

<style>
  .card {
    box-sizing: border-box;
    width: 300px;
    padding: 24px;
    border: 1px solid #cbd5e1;
    background: #ffffff;
  }

  .card h2 {
    margin: 0 0 8px;
    font-size: 1.2rem;
  }

  .card p {
    margin: 0;
    color: #475569;
    line-height: 1.55;
  }
</style>
--- test
const card = query(".card");
const rect = card.getBoundingClientRect();
assert(Math.abs(rect.width - 300) <= 1, `The card renders ${Math.round(rect.width)}px wide. Its border box should be exactly 300px, padding and border included.`);
assertStyle(".card", "box-sizing", "border-box", "Set box-sizing: border-box so width includes padding and border.");
assertStyle(".card", "padding", "24px", "The card still needs 24px of padding on every side.");
assertStyle(".card", "border-top-width", "1px", "Give the card a 1px border.");
assertColor(".card", "background-color", "#ffffff", "The card background should be white.");
--- hint
Without help, `width: 300px` plus `24px` padding and a `1px` border produces a 350px box.
--- hint
`box-sizing: border-box` makes the declared width include padding and border. Then 300px really is 300px.
--- hint
Put `box-sizing: border-box; width: 300px;` in the same `.card` rule, then add padding and border as usual.
```

## Centering with auto margins

A block-level element with a width narrower than its container will sit on the left by default. Setting the left and right margins to `auto` splits the leftover space equally and centers it.

```html run
<main class="page">
  <p class="eyebrow">The weekly</p>
  <h1>Notes from the counter</h1>
  <p>This column has a maximum width and automatic side margins. On a wide screen it stays readable. On a narrow one it shrinks.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    box-sizing: border-box;
    max-width: 560px;
    margin: 0 auto;
    padding: 40px 24px;
    background: white;
  }

  .eyebrow {
    margin: 0;
    color: #b45309;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }
</style>
```

`max-width` is better than `width` here. `width: 560px` would force a 560px column even on a 400px phone, causing horizontal scrolling. `max-width` says "grow to 560px, but never wider than the space available". The `margin: 0 auto` does the centering.

Auto margins only center a block-level box that has a definite width smaller than its container. An inline element ignores them. A block with `width: auto` fills the container, so there is no leftover space to divide.

The browser also gives `body` a default margin of 8px. That gap is why a full-bleed header often has a thin strip of background around it. Most stylesheets start with `body { margin: 0; }`; the preview here does exactly that.

```html run
<!doctype html>
<html lang="en">
  <head>
    <style>
      body {
        border: 4px dashed #f59e0b;
        background: #fffbeb;
        font-family: system-ui, sans-serif;
      }

      .inner {
        padding: 16px;
        background: white;
      }
    </style>
  </head>
  <body>
    <div class="inner">
      The dashed line is the body. The gap outside it is the browser's default 8px margin. Set body margin to 0 and the dashed line meets the edge of the page.
    </div>
  </body>
</html>
```

> **Tip:** When a centered container looks slightly off, inspect the `body`. The default margin is small enough to miss and large enough to matter.

## Challenge: center a readable column

Center the `.page` column with a maximum width of `640px`. Keep `24px` of horizontal padding, and make sure that padding does not make the column wider than 640px. The body already has its margin removed.

```html exercise id=centered-column title="Center a readable column"
<main class="page">
  <h1>Trail notes</h1>
  <p>Three days on the ridge, two wrong turns and one extremely good sandwich.</p>
  <p>The page should sit in the middle of the viewport, with equal space on both sides.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    /* TODO: cap the width at 640px, center it, and keep the padding inside that width */
  }
</style>
--- solution
<main class="page">
  <h1>Trail notes</h1>
  <p>Three days on the ridge, two wrong turns and one extremely good sandwich.</p>
  <p>The page should sit in the middle of the viewport, with equal space on both sides.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    box-sizing: border-box;
    max-width: 640px;
    margin: 0 auto;
    padding: 48px 24px;
    background: white;
  }
</style>
--- test
assertStyle(".page", "max-width", "640px", "Cap the column with max-width: 640px.");
const page = query(".page");
const rect = page.getBoundingClientRect();
assert(Math.abs(rect.width - 640) <= 1, `The column renders ${Math.round(rect.width)}px wide. With border-box, 640px should include the 24px side padding.`);
const bodyRect = document.body.getBoundingClientRect();
const leftGap = rect.left - bodyRect.left;
const rightGap = bodyRect.right - rect.right;
assert(Math.abs(leftGap - rightGap) <= 2, `The column has ${Math.round(leftGap)}px on the left and ${Math.round(rightGap)}px on the right. Auto side margins should make those equal.`);
assertStyle("body", "margin-left", "0px", "Remove the body's default margin so the centering is measured against the viewport.");
--- hint
`max-width` caps the size; `margin: 0 auto` centers the leftover space.
--- hint
If you add horizontal padding without `box-sizing: border-box`, the visible column becomes 688px wide.
--- hint
Use `box-sizing: border-box; max-width: 640px; margin: 0 auto; padding: 48px 24px;` in `.page`.
```

## Display changes the rules

The `display` property decides how a box participates in layout. Three values cover the basics.

```html run
<p>
  Read the <a class="inline" href="#guide">inline note</a>,
  then the <span class="inline-block">inline-block box</span>
  and finally the block below.
</p>

<div class="block">A block box takes its own line.</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    line-height: 1.8;
  }

  .inline {
    padding: 8px 14px;
    background: #fef3c7;
  }

  .inline-block {
    display: inline-block;
    width: 150px;
    padding: 8px;
    background: #ccfbf1;
    text-align: center;
  }

  .block {
    width: 220px;
    padding: 12px;
    background: #e0f2fe;
  }
</style>
```

A **block** box starts on a new line and fills the available width by default, even if its content is short. Headings, paragraphs, sections and divs are blocks. Width, height, padding and margins all work normally.

An **inline** box flows with the text, like a word. Links, spans, strong and em are inline. Horizontal padding and margins work, but vertical padding paints outside the line box without pushing the lines apart. Setting `width` or `height` on an inline element does nothing.

An **inline-block** box sits in the text flow like an inline element, but accepts width, height, padding and margins like a block. It is useful for small badges and buttons that need real dimensions without starting a new line.

> **Under the hood:** Every element has a default `display` value from the browser's stylesheet. That is why a `div` stacks and a `span` does not. Your CSS can change the value, but it cannot change the element's meaning. A `span` styled as a block is still not a heading to a screen reader.

## When content does not fit

A fixed height plus content that is too tall creates overflow. The `overflow` property decides what happens to the excess.

```html run
<div class="window">
  <p>Roasting is mostly listening. First crack sounds like a small, dry snap. Second crack is faster and darker, and by then the sugars are already turning. If you wait too long the roast tastes like the inside of a chimney.</p>
  <p>The useful skill is not memorising times. It is noticing the gap between what you expected and what the beans are doing.</p>
</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: Georgia, serif;
    background: #f8fafc;
  }

  .window {
    width: 280px;
    height: 110px;
    padding: 12px;
    border: 1px solid #cbd5e1;
    overflow: auto;
    background: white;
  }
</style>
```

`overflow: visible` is the default: the content spills out and can overlap whatever is below. `overflow: hidden` clips the excess, which is occasionally useful for decorative shapes but dangerous for text and focus outlines. `overflow: auto` adds a scrollbar only when the content needs one. `overflow: scroll` always reserves one.

Do not use a fixed height on a text container unless you genuinely want a scrolling region. Let the content define the height, then use `max-height` if you need a ceiling.

## Debug: the card that spills out of its parent

The panel is 600px wide with 24px padding. The card inside is set to `width: 100%`, but it sticks out past the panel's right edge. Find the box-model mistake and fix it without changing the panel.

```html debug id=padding-overflow title="The card that overflows its parent"
<main class="panel">
  <article class="card">
    <h2>Subscription, sorted</h2>
    <p>Two bags a month, roasted on Monday and posted the same afternoon.</p>
  </article>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .panel {
    width: 600px;
    padding: 24px;
    background: #e2e8f0;
  }

  .card {
    width: 100%;
    padding: 32px;
    border: 2px solid #0f766e;
    background: white;
  }
</style>
--- solution
<main class="panel">
  <article class="card">
    <h2>Subscription, sorted</h2>
    <p>Two bags a month, roasted on Monday and posted the same afternoon.</p>
  </article>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .panel {
    width: 600px;
    padding: 24px;
    background: #e2e8f0;
  }

  .card {
    box-sizing: border-box;
    width: 100%;
    padding: 32px;
    border: 2px solid #0f766e;
    background: white;
  }
</style>
--- test
const panel = query(".panel");
const card = query(".card");
const panelStyle = getComputedStyle(panel);
const panelRect = panel.getBoundingClientRect();
const contentWidth = panelRect.width - parseFloat(panelStyle.paddingLeft) - parseFloat(panelStyle.paddingRight);
const cardRect = card.getBoundingClientRect();
assert(cardRect.width <= contentWidth + 1, `The card renders ${Math.round(cardRect.width)}px wide inside a ${Math.round(contentWidth)}px content area. Its padding and border are being added on top of width: 100%.`);
assert(cardRect.width >= contentWidth - 1, `The card should still fill the panel's content width, about ${Math.round(contentWidth)}px.`);
assert(cardRect.right <= panelRect.right - parseFloat(panelStyle.paddingRight) + 1, "The card's right edge is still past the panel's content edge. Bring it back inside.");
--- hint
The panel's content box is 600px wide. The card is 100% of that, then 64px of padding and 4px of border are added.
--- hint
`box-sizing: border-box` makes `width: 100%` include the padding and border, so the card stops at 600px.
--- hint
Add `box-sizing: border-box;` to `.card`. You should not need to change the panel at all.
```

## Margins collapse

Vertical margins behave differently from horizontal ones. When two block siblings meet, their adjacent vertical margins **collapse**: the gap is the larger of the two margins, not the sum.

```html run
<section class="stack">
  <div class="panel first">First panel</div>
  <div class="panel second">Second panel</div>
</section>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .stack {
    padding: 24px;
    background: #f1f5f9;
  }

  .panel {
    padding: 12px;
    border: 1px solid #cbd5e1;
    background: white;
  }

  .first { margin-bottom: 48px; }
  .second { margin-top: 16px; }
</style>
```

The gap between the panels is 48px, not 64px. The two margins overlap and the bigger one wins. If both were 24px, the gap would be 24px.

Collapsing only happens vertically between block boxes in normal flow. It does not happen horizontally, and it does not happen in flex or grid layouts. Margins can also collapse between a parent and its first or last child when there is no border or padding in between, which is why a heading sometimes pushes its whole container down instead of adding space inside it.

The practical rule: do not stack margins and expect them to add up. Pick one direction — usually `margin-bottom` — or use `gap` when you get to flexbox and grid.

## Predict: how wide is the ticket?

Read the rule carefully. The element has no other width-related styles.

```html predict id=content-box-width title="The content-box ticket"
<div class="ticket">Boarding pass</div>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
  }

  .ticket {
    width: 300px;
    padding: 20px;
    border: 5px solid #0f766e;
    background: #ccfbf1;
  }
</style>
--- options
* 350px — width covers only the content, so padding and border are added around it
300px — width always means the full visible box
330px — the padding is included but the border is not
340px — only the horizontal padding on one side is added
--- explain
The default is `box-sizing: content-box`. `width: 300px` sets the content area. Padding adds 20px on each side (40px total), and the border adds 5px on each side (10px total). The border box is 300 + 40 + 10 = 350px. If the rule included `box-sizing: border-box`, the answer would be 300px and the content would shrink to 250px.
```

## Recap

- Every element has a content box, padding, a border and a margin.
- `width` and `height` describe the content box unless you change `box-sizing`.
- `box-sizing: border-box` makes width include padding and border; it does not include margin.
- `margin: 0 auto` centers a block with a definite width; `max-width` keeps it from overflowing small screens.
- Block elements stack and fill; inline elements flow with text; inline-block does both.
- `overflow` controls what happens when content is larger than its box.
- Adjacent vertical margins collapse to the larger value, not the sum.
- The browser gives `body` an 8px margin. Most stylesheets remove it.

**Up next:** typography and color — font stacks, line height, readable measure, contrast, and a palette built from custom properties.
