A form row can turn red when the input inside it is invalid. A card can grow a shadow only when it contains an image. A navigation link can style itself from `aria-current="page"` without a single class toggle. None of this needs JavaScript, and none of it needs a selector that repeats the entire ancestor chain.

Modern selectors are relational. They let CSS ask questions about structure and state, then style the element that answers. The result is less markup, fewer state classes, and fewer specificity accidents. The trade-off is that you need to know exactly which element a selector is matching.

## `:is()` groups selectors without repeating the ancestor

Before `:is()`, styling several headings inside an article looked like this:

```css
.post h2,
.post h3,
.post h4 { color: #0f766e; }
```

With `:is()`:

```css
.post :is(h2, h3, h4) { color: #0f766e; }
```

The matching behaviour is the same. The difference is maintenance and specificity. `:is()` takes the specificity of its **most specific argument**. If one argument is an ID, the whole `:is()` scores like that ID, even for elements that match a type selector. That is usually a reason to keep IDs out of `:is()`.

| Selector | Specificity | Why |
|---|---|---|
| `.post :is(h2, .lead)` | `(0, 2, 0)` | `.post` plus the most specific argument, `.lead` |
| `.post :where(h2, #lead)` | `(0, 1, 0)` | `:where()` contributes nothing |
| `.card:has(> img.hero)` | `(0, 2, 1)` | `.card` plus `img.hero` |
| `a:not([aria-current])` | `(0, 1, 1)` | the type selector plus the attribute |

`:where()` has the same matching behaviour but contributes **zero specificity**. It is the tool for resets, normalization and low-priority defaults. A component class can override a `:where()` rule without knowing anything about the reset's selector.

Both `:is()` and `:where()` use **forgiving parsing**. If one argument is invalid or unsupported, the browser drops that argument and keeps the rest. A plain selector list is not forgiving: one invalid selector invalidates the entire rule. That difference is a common source of "the CSS disappeared" bugs.

```html run
<article class="post">
  <h2>Field notes</h2>
  <p>Three days on the ridge, one very heavy rucksack. <a href="#">Read the route</a>.</p>
  <h3 class="quiet">Packing list</h3>
  <p class="quiet">The list is intentionally quiet.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 40rem; }
  .post :is(h2, h3, a):not(.quiet) { color: #0f766e; }
  .post .quiet { color: #64748b; }
</style>
```

The `h2`, the `h3` and the link are all matched by `:is(h2, h3, a)`. The `:not(.quiet)` then removes the quiet heading, and the separate `.quiet` rule keeps it muted. Without `:not()`, the quiet heading would be teal like the others.

> **Pitfall:** `:is()` cannot contain pseudo-elements. `:is(p::before)` is invalid. Use a normal selector list for pseudo-elements.

## `:not()` is a filter, not a reset

`:not()` matches an element that does **not** match any selector in its argument list. It accepts a list, so `:not(.disabled, [aria-disabled="true"])` is valid. Its specificity is the most specific selector in the list, just like `:is()`.

Use `:not()` to narrow a rule, not to undo a rule. A selector such as `a:not(.button)` is a clear statement: style links that are not buttons. A selector such as `*:not(.everything)` is a sign that the stylesheet has lost control of its defaults. `:not()` also does not make a selector cheaper; the browser still evaluates the full compound selector. Use it for clarity, not as an optimisation.

## `:has()` styles the element that contains a match

`:has()` is the relational selector people used to call "the parent selector". It matches an element if any relative selector inside the parentheses matches, starting from that element. The combinator at the start of the argument controls the relationship:

- `.card:has(img)` — the card contains an image anywhere.
- `.card:has(> img)` — the image is a direct child of the card.
- `label:has(+ input)` — the label is immediately followed by an input.
- `form:has(input:invalid)` — the form contains at least one invalid input.

The specificity of `:has()` is the specificity of its most specific argument, plus whatever else is in the selector. It cannot contain pseudo-elements.

`:has()` is most useful for state that is already expressed in the DOM: validity, checked state, open state, focus, the presence of an icon, a selected row. It is not a replacement for a class when the server already knows the state. It is also worth being careful with very large, constantly mutating DOM trees; a relational selector can be more expensive than a class toggle. For ordinary forms and components, the convenience is worth it.

The relative selector can also point sideways. `label:has(+ input:invalid)` matches a label whose immediately following sibling is an invalid input. The subject is still the label before `:has()`; the combinator describes where to look. That makes `:has()` useful for form layouts where the label and control are siblings rather than nested.

```html run
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
  <label class="check">
    <input type="checkbox" checked>
    <span>Send me the weekly digest</span>
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  .field:has(input:invalid) { border-color: #b91c1c; background: #fef2f2; }
  .field:has(input:valid) { border-color: #0f766e; }
  .check { display: flex; align-items: center; gap: 8px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .check:has(input:checked) { border-color: #0f766e; background: #f0fdfa; }
</style>
```

The email field is invalid because the value is not an email address. Its row turns red. The name field is valid, so its row turns teal. The checkbox row is tinted because the checkbox is checked. No class changes, no event listeners, no JavaScript.

> **In the wild:** `:has()` is excellent for "error state on the field wrapper" because the invalid control is nested inside the label. It also lets a card react to a featured image without a `.has-image` class from the CMS.

## Counting with `:nth-child(An+B of S)`

`:nth-child()` has a powerful form that is easy to miss:

```css
.row:nth-child(2n of .row) { background: #f1f5f9; }
```

The `of S` part filters the siblings to those matching `S`, then counts those matches. It is not "the second child if it also matches". It is "the second element among the siblings that match `S`". That distinction matters when other elements are mixed into the same parent.

| Selector | What it selects |
|---|---|
| `:nth-child(3)` | the third child, whatever it is |
| `:nth-child(2n)` | every even child |
| `:nth-child(2n+1)` | every odd child |
| `:nth-child(-n+3)` | the first three children |
| `:nth-child(2n of .row)` | every second element whose class includes `row` |

`:nth-of-type()` is different again: it counts siblings of the same element type (`li`, `p`, `div`), not siblings that match a class. Use `:nth-of-type()` when the tag is the meaningful category; use `:nth-child(... of S)` when a class or attribute is the meaningful category.

```html run
<ol class="ledger">
  <li class="row">Invoice 01</li>
  <li class="row">Invoice 02</li>
  <li class="note">A note that is not a row</li>
  <li class="row">Invoice 03</li>
  <li class="row">Invoice 04</li>
  <li class="row">Invoice 05</li>
</ol>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .ledger { list-style: none; margin: 0; padding: 0; max-width: 420px; border: 1px solid #e2e8f0; border-radius: 10px; overflow: hidden; }
  .row, .note { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; }
  .row:nth-child(odd of .row) { background: #f1f5f9; }
  .note { color: #b45309; font-style: italic; }
</style>
```

Invoices 01, 03 and 05 are tinted. The note is ignored by the `of .row` filter, so it does not shift the count. Without `of .row`, `:nth-child(odd)` would count every child, and the note would take one of the odd positions.

## Attribute selectors read state directly

Attributes are part of the DOM, so CSS can read them without a class. This is especially useful for accessibility state and data attributes:

```css
a[aria-current="page"] { font-weight: 700; }
.disclosure[data-state="open"] .panel { display: block; }
input[disabled] { opacity: 0.6; }
[data-role="alert" i] { border-left: 4px solid #b45309; }
```

`[aria-current]` matches any element with the attribute, regardless of value. `[aria-current="page"]` matches the exact value. The `i` flag makes the value comparison case-insensitive. Attribute selectors have class-level specificity: `(0, 1, 0)`. Values are case-sensitive by default, so `[data-state="open"]` will not match `data-state="Open"` unless you add the `i` flag.

`:focus-within` matches an element when it or any descendant has focus. It is the natural way to highlight a composite field, a card with a link, or a search box when the input inside is focused. `:focus-visible` is a different tool: it matches the element that received focus when the browser judges that a focus indicator should be visible. Use `:focus-within` for the container's state and `:focus-visible` for the control's ring.

`:empty` matches an element with no children and no text; whitespace counts as text, so `<p> </p>` is not empty.

```html run
<nav class="nav" aria-label="Primary">
  <a href="#" aria-current="page">Notes</a>
  <a href="#">Archive</a>
</nav>
<div class="disclosure" data-state="open">
  <button type="button" aria-expanded="true">Filters</button>
  <div class="panel">Three active filters</div>
</div>
<div class="disclosure" data-state="closed">
  <button type="button" aria-expanded="false">Sort</button>
  <div class="panel">Newest first</div>
</div>
<label class="search">
  <span>Search</span>
  <input type="search" placeholder="Type to search" autofocus>
</label>
<p class="empty"></p>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; max-width: 420px; }
  .nav { display: flex; gap: 16px; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; }
  .nav a { color: #475569; text-decoration: none; }
  .nav a[aria-current="page"] { color: #0f766e; font-weight: 700; }
  .disclosure { border: 1px solid #e2e8f0; border-radius: 10px; padding: 10px 12px; }
  .disclosure .panel { display: none; margin-top: 6px; color: #475569; }
  .disclosure[data-state="open"] .panel { display: block; }
  .search { display: grid; gap: 4px; padding: 10px 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .search:focus-within { border-color: #0f766e; box-shadow: 0 0 0 3px #ccfbf1; }
  .search span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .search input { border: 0; font: inherit; background: transparent; }
  .empty { margin: 0; }
  .empty:empty::before { content: "No notes yet"; color: #64748b; }
</style>
```

The current page link is teal and bold because of `[aria-current="page"]`. Only the open disclosure shows its panel. The search wrapper gets a focus ring from `:focus-within` when the input receives focus. The empty paragraph renders the placeholder from `:empty::before`.

> **Pitfall:** `:empty` does not ignore whitespace. If your template prints a newline or a space between the tags, the element is not empty and the rule will not match.

## Selector lists are not forgiving

A normal selector list is all-or-nothing. One invalid selector invalidates the entire rule. This is why a single unsupported pseudo-class can make a perfectly good `.notice-title` rule disappear:

```css
.notice-title, :blank { color: #b45309; } /* the whole rule is dropped */
```

`:is()` and `:where()` are forgiving. The invalid argument is discarded, and the rest of the list still works:

```css
:is(.notice-title, :blank) { color: #b45309; } /* .notice-title survives */
```

That is a useful compatibility tool, not a licence to leave typos in production. If a selector is invalid, you want to know. The forgiving list is for progressive enhancement: use a new pseudo-class where it is supported, and keep the valid fallback working everywhere else.

```html run
<div class="stack">
  <p class="strict">This rule was dropped</p>
  <p class="forgiving">This rule survived</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stack p { padding: 10px 12px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; }
  .strict, :blank { color: #b91c1c; }
  :is(.forgiving, :blank) { color: #0f766e; }
</style>
```

The first paragraph stays black because `:blank` is unsupported in this browser and invalidates the whole `.strict, :blank` rule. The second is teal because `:is()` drops the unsupported argument and keeps `.forgiving`.

Forgiving parsing is useful, but it is also quiet. A typo inside `:is()` does not produce an error; it simply stops matching. During development, check the selector in DevTools or with `CSS.supports("selector(:is(...))")`. Keep the forgiving list for deliberate progressive enhancement, not for hiding mistakes.

## Challenge: style the row, not the input

Use `:has()` to give the row containing an invalid email a red border and a pale red background, and the row containing a valid name a teal border. The inputs themselves should stay unstyled.

```html exercise id=selectors-invalid-row title="Style the row from its input"
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  /* Target: invalid border #b91c1c, invalid background #fef2f2, valid border #0f766e.
     TODO: style .field when its input is invalid, and again when it is valid. */
</style>
--- solution
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  .field:has(input:invalid) { border-color: #b91c1c; background: #fef2f2; }
  .field:has(input:valid) { border-color: #0f766e; }
</style>
--- test
assertColor(".field:has(input:invalid)", "border-top-color", "#b91c1c", "The row with the invalid email should have a red border. It currently computes to " + getComputedStyle(query(".field:has(input:invalid)")).borderTopColor + ".");
assertColor(".field:has(input:invalid)", "background-color", "#fef2f2", "Give the invalid row a pale red background.");
assertColor(".field:has(input:valid)", "border-top-color", "#0f766e", "The row with the valid name should have a teal border. Style it with :has(input:valid).");
assertStyle(".field input", "border-top-width", "0px", "The input itself should stay unstyled; the row is doing the work.");
--- hint
The row is a `label` with class `field`. The input is its descendant, so the relational selector starts from `.field`.
--- hint
`.field:has(input:invalid)` matches the row, not the input. Set `border-color` and `background` on that selector.
--- hint
Add a second rule for `.field:has(input:valid)` so the valid row gets a teal border instead of staying slate.
```

## Challenge: make a reset step aside with `:where()`

The prose reset styles every heading inside `.prose`, including the featured title. Because `.prose h2` is more specific than `.featured-title`, the component's colour and size lose. Rewrite the reset with `:where()` so ordinary headings keep the reset and the featured heading keeps its component styles.

```html exercise id=selectors-where-reset title="A reset that cannot outrank a component"
<article class="prose">
  <h2>Field notes</h2>
  <p>Short dispatches from the workshop and the trail.</p>
  <h2 class="featured-title">The long way round</h2>
  <p>Some routes are worth the extra day.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose h2 { margin: 0 0 12px; color: #475569; font-size: 1.125rem; }
  .featured-title { color: #0f172a; font-size: 1.75rem; }
  /* TODO: rewrite the reset so it still styles ordinary h2 elements
     but cannot outrank .featured-title. */
</style>
--- solution
<article class="prose">
  <h2>Field notes</h2>
  <p>Short dispatches from the workshop and the trail.</p>
  <h2 class="featured-title">The long way round</h2>
  <p>Some routes are worth the extra day.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose :where(h2) { margin: 0 0 12px; color: #475569; font-size: 1.125rem; }
  .featured-title { color: #0f172a; font-size: 1.75rem; }
</style>
--- test
assertColor(".featured-title", "color", "#0f172a", "The featured title is still slate. .prose h2 scores (0, 1, 1) and beats .featured-title at (0, 1, 0).");
assertStyle(".featured-title", "font-size", "28px", "The featured title should keep its 1.75rem size, not the reset's 1.125rem.");
assertColor(".prose h2:not(.featured-title)", "color", "#475569", "Ordinary prose headings should still get the reset colour.");
assertStyle(".prose h2:not(.featured-title)", "font-size", "18px", "Ordinary prose headings should still get the reset size.");
--- hint
You want the reset selector to keep matching `h2` but contribute no specificity for the `h2` part.
--- hint
`:where(h2)` has zero specificity. The surrounding `.prose` still contributes one class.
--- hint
Change `.prose h2` to `.prose :where(h2)`. The reset and `.featured-title` then tie at (0, 1, 0), and the later component rule wins.
```

## Debug: the rule that vanished

The notice heading should be amber, but it is black. The stylesheet contains `.notice-title, :blank`, and this browser does not support `:blank`. A plain selector list is not forgiving, so the entire rule was dropped. Fix it so the valid selector applies, and keep the notice panel styling.

```html debug id=selectors-forgiving-list title="The rule that vanished"
<div class="notice">
  <h2 class="notice-title">Export ready</h2>
  <p>Your archive is ready to download.</p>
</div>
<style>
  .notice-title, :blank { color: #b45309; }
  .notice { padding: 16px; border: 1px solid #fcd34d; background: #fffbeb; border-radius: 10px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- solution
<div class="notice">
  <h2 class="notice-title">Export ready</h2>
  <p>Your archive is ready to download.</p>
</div>
<style>
  :is(.notice-title, :blank) { color: #b45309; }
  .notice { padding: 16px; border: 1px solid #fcd34d; background: #fffbeb; border-radius: 10px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- test
assertColor(".notice-title", "color", "#b45309", "The heading is still black. The selector list contains :blank, which this browser does not support, so the entire rule is invalid and never applies.");
assertColor(".notice", "background-color", "#fffbeb", "Keep the notice panel's background.");
assertStyle(".notice", "padding", "16px", "Keep the notice panel's padding.");
--- hint
The heading rule is the one that disappeared, not the panel rule. Compare the two selectors.
--- hint
A selector list separated by commas is unforgiving: if one selector is invalid, the whole rule is discarded.
--- hint
Wrap the list in `:is(...)` or `:where(...)`, or remove `:blank`. Both make `.notice-title` valid again.
```

## Predict: which figures get the outline?

The rule uses `:has(> img)`. The combinator inside `:has()` decides whether a nested image counts. Choose the figures that match.

```html predict id=selectors-predict-has-child title="Which figures match :has(> img)?"
<div class="gallery">
  <figure class="shot">
    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='80'%3E%3Crect width='120' height='80' fill='%23cbd5e1'/%3E%3C/svg%3E" alt="" width="120" height="80">
    <figcaption>Direct child</figcaption>
  </figure>
  <figure class="shot">
    <div class="frame">
      <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='80'%3E%3Crect width='120' height='80' fill='%23cbd5e1'/%3E%3C/svg%3E" alt="" width="120" height="80">
    </div>
    <figcaption>Nested</figcaption>
  </figure>
  <figure class="shot">
    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='80'%3E%3Crect width='120' height='80' fill='%23cbd5e1'/%3E%3C/svg%3E" alt="" width="120" height="80">
    <figcaption>Direct child, with caption</figcaption>
  </figure>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .gallery { display: flex; gap: 16px; flex-wrap: wrap; }
  .shot { margin: 0; padding: 8px; border: 2px dashed #cbd5e1; border-radius: 10px; }
  .shot figcaption { margin-top: 6px; font-size: 0.8rem; color: #475569; }
  .shot:has(> img) { outline: 4px solid #0f766e; outline-offset: 4px; }
</style>
--- options
* The first and third figures
Only the first figure
All three figures
Only the second figure
--- explain
`>` inside `:has()` means "a direct child". The first and third figures contain an `img` as a direct child, so they match. The second figure contains the image inside `.frame`, which is a descendant but not a direct child, so it does not match. Removing the `>` would make all three match, because the image is still inside each figure.
```

## Recap

- `:is()` groups selectors and takes the specificity of its most specific argument; `:where()` always contributes zero.
- `:not()` excludes a selector list. Use it to narrow a rule, not to undo a stylesheet.
- `:has()` matches an element based on what it contains. The combinator inside controls the relationship.
- `:nth-child(An+B of S)` counts only siblings that match `S`; `:nth-of-type()` counts by element type.
- Attribute selectors, `:focus-within` and `:empty` read state and structure without extra classes.
- Plain selector lists are unforgiving. `:is()` and `:where()` keep the valid parts working.

**Up next:** Flexbox in depth — growth, shrinkage, and the `min-content` trap that makes a `flex: 1` child refuse to shrink.
