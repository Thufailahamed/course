A page with no CSS is not neutral. The browser is making hundreds of decisions on your behalf: Times New Roman, 16px text, blue links, eight pixels of margin around the body. Those defaults were useful in 1995. They are not a design.

This is the handover. You will write your first rules, target the right elements, choose colors that hold together, and understand the cascade — the set of rules that decides which declaration wins when two of them disagree. The cascade is the part beginners skip and then spend years fighting.

## A stylesheet is a list of rules

A CSS rule has two parts. The **selector** says which elements the rule is about. The **declaration block** says what to do to them. Inside the block, each line is a **declaration**: a property, a colon, a value, and a semicolon.

```html run
<h1>Trailhead Coffee</h1>
<p class="lede">Small-batch coffee for people who walk up hills.</p>
<p>Open Tuesday to Saturday, 8am until the beans run out.</p>

<style>
  h1 {
    color: #0f172a;
    font-family: Georgia, serif;
  }

  .lede {
    color: #0f766e;
    font-size: 1.125rem;
  }

  p {
    line-height: 1.6;
  }
</style>
```

The `h1` selector is an **element selector**: every `h1` on the page gets those declarations. `.lede` is a **class selector**: it matches any element with `class="lede"`. The dot is part of the selector syntax, not part of the class name in the HTML.

Most stylesheets live in a `<style>` element in the document's `<head>`. In these lessons the style element can sit beside the markup so you can see both at once. The browser reads the whole document first, then paints, so the order of the `<style>` element and the markup does not matter. The order of rules *inside* the stylesheet does.

There is a third place to put CSS: the `style` attribute directly on an element.

```html
<p style="color: #b91c1c;">This paragraph carries its own color.</p>
```

That is an **inline style**. It applies to one element only and cannot be reused. Inline styles also sit very high in the cascade, which makes them hard to override later. Avoid them in normal page work. They survive in HTML email, where stylesheets are unreliable, and in quick experiments where you intend to throw the result away.

> **Tip:** A declaration missing its semicolon can swallow the next property. If a rule seems to ignore one line, check the line above it first.

## Element, class and id selectors

Three selectors cover most of the CSS you will write.

```html run
<p>A plain paragraph with the browser's default look.</p>
<p class="note">A note with a warm background.</p>
<p class="note" id="urgent">The same note, marked urgent.</p>

<style>
  p {
    color: #334155;
    line-height: 1.55;
  }

  .note {
    padding: 8px 12px;
    background: #fef3c7;
  }

  #urgent {
    border-left: 4px solid #b45309;
  }
</style>
```

An **element selector** (`p`) is broad. Useful for a baseline, dangerous when it is the only tool you use: every paragraph on the site inherits the decision.

A **class selector** (`.note`) is reusable. The same class can appear on ten elements, and the style stays consistent. This is the workhorse of CSS. Name classes for meaning — `.note`, `.card`, `.price` — not for appearance like `.yellow-box`, because the appearance will change and the name will become a lie.

An **id selector** (`#urgent`) matches one element with that `id`. Ids are unique in a valid document, and they are also used for in-page links and JavaScript hooks. They work in CSS, but they carry a lot of weight in the cascade. Prefer a class for styling, and keep ids for anchors and behaviour.

> **Pitfall:** Class and id names are case-sensitive in HTML. `.Card` does not match `class="card"`. Tag names are not: `P` and `p` select the same element. This asymmetry causes more silent bugs than almost anything else in this lesson.

## Grouping and descendant selectors

Two pieces of selector syntax save a lot of repetition.

```html run
<nav class="menu">
  <a href="#coffee">Coffee</a>
  <a href="#brew">Brew guides</a>
  <a href="#visit">Visit</a>
</nav>

<h2>This week at the bar</h2>
<p>We are pouring a washed Ethiopian and a very sticky natural from Brazil.</p>

<style>
  h1, h2 {
    font-family: Georgia, serif;
    letter-spacing: -0.02em;
  }

  .menu {
    padding: 12px 0;
    border-bottom: 1px solid #e2e8f0;
  }

  .menu a {
    margin-right: 16px;
    color: #0f766e;
    font-weight: 600;
    text-decoration: none;
  }

  .menu a:hover {
    text-decoration: underline;
  }
</style>
```

The comma in `h1, h2` **groups** selectors. Both headings receive the same declarations. Grouping is not inheritance; it is simply a shorthand for writing the same block twice.

A space is a **descendant combinator**. `.menu a` means "every `a` that is somewhere inside an element with class `menu`". It does not require the link to be a direct child. If you need that stricter relationship, use `>`: `.menu > a`. Descendant selectors keep styles scoped, so a link in the footer does not accidentally pick up the navigation style.

`.menu a:hover` adds a **pseudo-class**. `:hover` matches while the pointer is over the element. There are pseudo-classes for focus, visited links, first children, invalid form fields and more. They are still selectors, and they still obey the cascade.

## Challenge: a card with a hover state

Build a card that uses the class selector, not the element selector. The card needs `24px` of padding, a `1px` border, a `16px` border radius and a `#f8fafc` background. On hover, its background should become `#e2e8f0`.

```html exercise id=card-hover title="Style a card and its hover state"
<article class="card">
  <p class="eyebrow">Field note</p>
  <h2>Grind size is a dial, not a rule</h2>
  <p>Start coarse, adjust fine, and taste the difference before you change anything else.</p>
</article>

<style>
  /* TODO: style .card, then give .card:hover a darker background */
</style>
--- solution
<article class="card">
  <p class="eyebrow">Field note</p>
  <h2>Grind size is a dial, not a rule</h2>
  <p>Start coarse, adjust fine, and taste the difference before you change anything else.</p>
</article>

<style>
  .card {
    max-width: 26rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #f8fafc;
  }

  .card:hover {
    background: #e2e8f0;
  }

  .eyebrow {
    margin: 0 0 4px;
    color: #b45309;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  .card h2 {
    margin: 0 0 8px;
    color: #0f172a;
    font-size: 1.25rem;
  }

  .card p {
    margin: 0;
    color: #475569;
    line-height: 1.55;
  }
</style>
--- test
assertExists(".card", "Add an element with class card so the selector has something to match.");
assertStyle(".card", "padding", "24px", "The card's padding is not 24px yet. Padding goes inside the card, around its content.");
assertStyle(".card", "border-radius", "16px", "Round the card's corners with border-radius: 16px.");
assertColor(".card", "background-color", "#f8fafc", "The card background should be #f8fafc at rest.");
const hoverRules = [];
for (const sheet of document.styleSheets) {
  for (const rule of sheet.cssRules) {
    if (rule.selectorText && /\.card:hover/.test(rule.selectorText)) hoverRules.push(rule);
  }
}
assert(hoverRules.length > 0, "Add a .card:hover rule. The card needs a different background while the pointer is over it.");
const hover = hoverRules[0];
const hoverBackground = hover.style.backgroundColor || hover.style.background;
assert(hoverBackground, "The .card:hover rule should set a background color.");
const probe = document.createElement("span");
probe.style.color = hoverBackground;
document.body.appendChild(probe);
const resolved = getComputedStyle(probe).color;
probe.remove();
assert(resolved === "rgb(226, 232, 240)", `The hover background resolves to ${resolved}. Use #e2e8f0 so the change is visible but still calm.`);
--- hint
Start with one rule for `.card`. Put padding, border, border-radius and background inside the same declaration block.
--- hint
A hover state is a separate rule: `.card:hover { background: #e2e8f0; }`. It does not go inside the first block.
--- hint
The class in the HTML is `card`, lowercase, and the selector must be `.card` with a dot. Check both spellings before changing anything else.
```

## Declarations, colors and text

CSS has a property for almost everything you can see. `color` sets text color. `background-color` sets the area behind the text. They are different properties, and only one of them inherits by default.

Colors can be written in several notations, and the browser treats equivalent values identically.

```html run
<div class="swatches">
  <div class="swatch named">tomato</div>
  <div class="swatch hex">#0f766e</div>
  <div class="swatch rgb">rgb(180, 83, 9)</div>
  <div class="swatch hsl">hsl(199 89% 48%)</div>
</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .swatch {
    display: inline-block;
    margin: 4px;
    padding: 16px 20px;
    border-radius: 8px;
    color: white;
    font-weight: 600;
  }

  .named { background-color: tomato; }
  .hex { background-color: #0f766e; }
  .rgb { background-color: rgb(180, 83, 9); }
  .hsl { background-color: hsl(199 89% 48%); }
</style>
```

- **Named colors** (`tomato`, `rebeccapurple`, `teal`) are readable and fine for demos. There are only 148 of them, so a real palette quickly runs out.
- **Hex** (`#0f766e`) is compact and everywhere. The six digits are pairs for red, green and blue. A shorter form like `#fff` expands to `#ffffff`.
- **`rgb()`** takes three channels from 0 to 255. It is easier to reason about when you are adjusting one channel at a time.
- **`hsl()`** takes hue in degrees, saturation and lightness as percentages. It is the best notation for building a palette: keep the hue, then vary lightness for hover states and muted text.

Opacity is a separate channel. `rgb(15 118 110 / 0.5)` and `#0f766e80` both produce a half-transparent teal. Use transparency when you genuinely need to see through a color; otherwise pick a solid color so contrast stays predictable.

`font-family` takes a list, not a single font. The browser uses the first one it can find. The final item should be a **generic family** — `serif`, `sans-serif` or `monospace` — so the page still has a sensible voice if the named fonts are missing.

## Inheritance: some properties flow down the tree

If you set `color` on a parent, its children usually inherit it. That is why you can set a text color once on `body` and have the whole page follow. `font-family`, `font-size` and `line-height` inherit too. `background-color`, `border`, `padding` and `margin` do not.

```html run
<article class="note">
  <h2>The inherited voice</h2>
  <p>This paragraph inherits the article's color and font. A <strong>strong phrase</strong> can still override the color, and this <a href="#source">link</a> asks to inherit it too.</p>
</article>

<style>
  body {
    margin: 0;
    padding: 24px;
    background: #f1f5f9;
  }

  .note {
    max-width: 34rem;
    padding: 20px;
    background: white;
    color: #334155;
    font-family: Georgia, serif;
  }

  .note strong {
    color: #b45309;
  }

  .note a {
    color: inherit;
  }
</style>
```

Inheritance only applies when the child has no declaration of its own. The `strong` rule sets a color directly, so it wins over the inherited one. The link is a special case: the browser's default stylesheet already gives links a color, so without `color: inherit` the link would stay blue. Setting `color: inherit` explicitly tells the link to take its parent's color.

> **Under the hood:** The browser has a default stylesheet called the **user agent stylesheet**. It is where heading sizes, list indentation, link colors and the body's 8px margin come from. Your stylesheet is an **author stylesheet**, and author declarations beat browser defaults at the same importance level. That is why one `body { margin: 0; }` is enough to remove the default gap.

## The cascade: which rule wins

When two declarations set the same property on the same element, the browser resolves the conflict with the cascade. For beginner CSS, three questions are enough:

1. **Is one declaration from a more specific selector?** Specificity beats source order.
2. **If specificity is equal, which rule comes later?** The later rule wins.
3. **Did either declaration use `!important`?** That changes the answer, and usually for the worse.

```html run
<p class="notice">The beans arrive on Thursday.</p>

<style>
  p {
    color: #334155;
  }

  .notice {
    color: #b45309;
  }

  .notice {
    color: #0f766e;
  }
</style>
```

All three rules match the paragraph. The element rule loses to the class rule on specificity. The two class rules have equal specificity, so the one written later wins and the text is teal. Delete the last rule and it becomes amber. That is source order doing its job.

Specificity is often summarised as a score:

| Selector | Specificity | Beats |
|---|---|---|
| `p` | 0-0-1 | browser defaults only |
| `.notice` | 0-1-0 | any number of element selectors |
| `#urgent` | 1-0-0 | any number of classes |
| `style="…"` | inline | author stylesheets |
| `color: red !important` | important | normal declarations |

The numbers are not a point total. One id always beats any number of classes; one class always beats any number of elements. `#intro p` beats `.lede` because the id comes first in the comparison, even though the class selector looks more specific to a human.

> **Pitfall:** `!important` does not mean "this is the most important rule in the design". It means "skip the normal cascade". It makes the next change harder, can override a user's accessibility settings, and usually hides a selector problem that will come back. Use it as a last resort, not as a way to win an argument with your own stylesheet.

## Debug: the rule with the wrong case

This card was supposed to have a warm background and generous padding, but it renders plain. The CSS looks correct at a glance. Find the mismatch and fix it.

```html debug id=case-sensitive-card title="The stylesheet that missed the card"
<article class="card">
  <p class="eyebrow">Steam</p>
  <h2>Milk, without the drama</h2>
  <p>Oat, whole or none. All three are welcome, and none of them need a lecture.</p>
</article>

<style>
  .Card {
    padding: 28px;
    border-radius: 12px;
    background: #fff7ed;
  }

  .Card h2 {
    margin: 0 0 8px;
    color: #9a3412;
  }

  .Card p {
    margin: 0;
    color: #57534e;
    line-height: 1.55;
  }
</style>
--- solution
<article class="card">
  <p class="eyebrow">Steam</p>
  <h2>Milk, without the drama</h2>
  <p>Oat, whole or none. All three are welcome, and none of them need a lecture.</p>
</article>

<style>
  .card {
    padding: 28px;
    border-radius: 12px;
    background: #fff7ed;
  }

  .card h2 {
    margin: 0 0 8px;
    color: #9a3412;
  }

  .card p {
    margin: 0;
    color: #57534e;
    line-height: 1.55;
  }
</style>
--- test
assertExists(".card", "Keep the article's class card so the styles have a target.");
assertColor(".card", "background-color", "#fff7ed", "The card is still transparent. Its selector does not match the class in the HTML.");
assertStyle(".card", "padding", "28px", "The card should have 28px of padding once the selector matches.");
assertColor(".card h2", "color", "#9a3412", "The heading inside the card should be #9a3412.");
--- hint
The HTML says `class="card"` and the CSS says `.Card`. CSS class selectors are case-sensitive.
--- hint
Change every `.Card` selector to `.card`. There are three rules to update.
```

## Debug: the rule that keeps losing

Here the lede paragraph should be dark and slightly larger than body text. It has a class and a rule, but the text stays grey. The problem is not a typo; it is the cascade.

```html debug id=specificity-trap title="The lede that will not go dark"
<section id="intro">
  <p class="lede">A quieter morning, one cup at a time.</p>
  <p>We open at eight. The first batch lands at ten past.</p>
</section>

<style>
  #intro p {
    color: #64748b;
  }

  .lede {
    color: #0f172a;
    font-size: 1.15rem;
    font-weight: 600;
  }
</style>
--- solution
<section id="intro">
  <p class="lede">A quieter morning, one cup at a time.</p>
  <p>We open at eight. The first batch lands at ten past.</p>
</section>

<style>
  #intro p {
    color: #64748b;
  }

  #intro .lede {
    color: #0f172a;
    font-size: 1.15rem;
    font-weight: 600;
  }
</style>
--- test
assertColor(".lede", "color", "#0f172a", "The lede is still grey, so the id rule is winning. Raise the class rule's specificity or stop targeting the paragraph through the id.");
assertStyle(".lede", "font-size", "18.4px", "Keep the lede at 1.15rem once the color is fixed.");
assertColor("#intro p:not(.lede)", "color", "#64748b", "The second paragraph should stay muted grey.");
--- hint
Compare `#intro p` with `.lede`. Count the selector parts: the first one contains an id. One id beats any number of classes.
--- hint
You can make the class rule more specific by scoping it under the section: `#intro .lede`. That has the id plus a class, so it outranks `#intro p`.
--- hint
Keep both paragraphs in mind. Changing the id rule itself might make the second paragraph dark too.
```

## Predict: which color wins?

Read the stylesheet before you run it. The paragraph has an id, a class, and three competing rules.

```html predict id=which-color-wins title="Which color wins?"
<p id="lead" class="text">One paragraph, four opinions.</p>

<style>
  p {
    color: #64748b;
  }

  .text {
    color: #b45309;
  }

  #lead {
    color: #0f766e;
  }

  .text {
    color: #be123c;
  }
</style>
--- options
* Teal, because the id selector has the highest specificity
Crimson, because the last class rule comes later in the stylesheet
Amber, because a class selector beats an element selector and ids are only for links
Slate, because the p selector applies directly to the paragraph
--- explain
The id selector `#lead` has specificity 1-0-0, which outranks every class selector on the page. The second `.text` rule does come later, but source order only decides between declarations of equal specificity. The paragraph is teal. This is exactly why styling with ids gets painful: the only ways to override that rule are another id, an inline style, or `!important`.
```

## Recap

- A rule is a selector plus a declaration block; each declaration is a property and a value.
- `<style>` keeps CSS with the document; inline `style` is powerful and hard to reuse.
- Element selectors are broad, classes are reusable, ids are unique and heavy in the cascade.
- Group selectors with commas; scope them with descendant spaces or `>`.
- `color` and `font-family` inherit; `background-color`, borders and spacing do not.
- The cascade compares importance, then specificity, then source order. `!important` is a shortcut that makes later work harder.
- Class selectors are case-sensitive in HTML. `.Card` is not `.card`.

**Up next:** the box model — why a 300px card with 24px padding refuses to be 300px wide, and how `box-sizing: border-box` fixes it.
