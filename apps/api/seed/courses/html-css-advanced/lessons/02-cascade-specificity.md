A button has two classes: `button` and `text-muted`. The utility is supposed to mute the label, but the component's white text wins. Someone adds `!important`. A week later the dark theme cannot override the button without another `!important`, and the design system starts to calcify. The problem was never the button. It was a misunderstanding of the cascade.

CSS is not a list of rules applied from top to bottom. It is a ranking system. For every element and every property, the browser gathers every declaration that could apply, sorts those declarations by a fixed set of criteria, and uses the winner. Once you can name the criteria in order, most "CSS is haunted" moments turn into ordinary debugging.

## The cascade is a ranking, not a fight

A declaration is one property-value pair inside a rule. A rule is a selector plus a block of declarations. Many rules can target the same element, and many declarations can set the same property. The cascade decides which one survives.

The sort happens roughly in this order:

1. **Origin and importance.** User-agent styles, user styles, author styles and `!important` declarations have a defined precedence.
2. **Element-attached styles.** A `style` attribute on the element beats ordinary author selectors.
3. **Cascade layers.** Within an origin, declarations in layers are ordered by layer, not by selector strength.
4. **Specificity.** How strong the selector is.
5. **Source order.** The later declaration wins when everything else ties.

There is also *scope proximity* after specificity, which matters for `@scope`. You can go a long way without it, but knowing it exists prevents the false belief that specificity is always the final tiebreak.

> **Under the hood:** The browser does not compare whole rules. It compares declarations for one property on one element, then moves to the next property. A rule can win `color` and lose `margin` on the same element.

## Origin and importance come first

Every stylesheet has an origin. The browser's own stylesheet is the **user-agent** origin. A reader's custom stylesheet is the **user** origin. Your page's stylesheet is the **author** origin. For normal declarations, author styles beat user styles, and user styles beat user-agent styles. That is why `h1 { color: #0f172a }` overrides the browser's default heading color.

`!important` does not simply mean "stronger". It changes the origin ordering. For important declarations, the order reverses: important user-agent beats important user, which beats important author. Transitions sit above everything, and animations sit between normal author and important author declarations. This is deliberate. It lets a reader's accessibility stylesheet override a site that has gone wild with `!important`.

In day-to-day author CSS, the practical summary is: **normal author beats normal user-agent; important author beats normal author; user important beats author important.** The last part is why `!important` is a promise you cannot easily take back.

## Specificity is a three-column score

Specificity is usually written as three numbers: `(ids, classes, types)`.

- **IDs** count in the first column: `#main`.
- **Classes, attributes and pseudo-classes** count in the second: `.card`, `[aria-current]`, `:hover`.
- **Type selectors and pseudo-elements** count in the third: `article`, `::before`.

The universal selector `*` contributes nothing. Combinators like `>`, `+` and `~` contribute nothing. A selector such as `.nav a` scores `(0, 1, 1)`. `.danger` scores `(0, 1, 0)`, so `.nav a` wins even if `.danger` appears later.

| Selector | IDs | Classes / attributes / pseudo-classes | Types / pseudo-elements |
|---|---:|---:|---:|
| `p` | 0 | 0 | 1 |
| `.nav a` | 0 | 1 | 1 |
| `.nav a:hover` | 0 | 1 | 2 |
| `#main .nav a` | 1 | 1 | 1 |
| `:where(#main) a` | 0 | 0 | 1 |

The old "specificity is worth 1000 points" explanation is a convenient lie. A selector with one ID always beats a selector with any number of classes, no matter how the points add up. Compare tuples, not totals.

Modern functional pseudo-classes change the calculation in ways that matter:

- `:is()`, `:not()` and `:has()` take the specificity of their **most specific argument**. `:is(.card, #hero)` scores like `#hero`.
- `:where()` always contributes **zero**, no matter what is inside it.
- `:nth-child()` contributes the pseudo-class itself plus the most specific selector in its `of` list.

Inline styles are not part of the three-column score. They are element-attached declarations and beat ordinary author selectors. An important author declaration still beats a normal inline style, which is one reason `!important` is so disruptive.

```html run
<div class="swatches">
  <p class="note">A class selector</p>
  <p class="note" id="featured">An ID selector</p>
  <p class="note" style="color: #b45309">An inline style</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  p { margin: 0 0 8px; color: #475569; }
  .note { color: #0f766e; }
  #featured { color: #1d4ed8; }
</style>
```

The first paragraph is teal because the class beats the type selector. The second is blue because the ID beats the class. The third is amber because the inline style beats both. If you add `!important` to the class rule, it will beat the inline style and the ID, which is exactly the kind of escalation that makes a stylesheet hard to reason about.

> **Pitfall:** A selector that does not match is irrelevant. `#checkout .button` does not beat `.button` on an element outside `#checkout`; it simply never enters the comparison.

## Layers: ordering by architecture, not selector strength

Cascade layers let you decide which *category* of CSS wins before specificity is considered. Declare the order once:

```css
@layer reset, base, layout, components, utilities;
```

For normal declarations, a later layer beats an earlier layer. Unlayered normal declarations beat every layered declaration. Within a layer, specificity and source order still apply normally. Layers are global to the origin, and the first time a layer name appears establishes its position in the order. A later `@layer utilities { ... }` block does not move utilities to the end if utilities was already declared earlier.

This is the architecture most design systems want: reset first, base element styles next, layout, components, then utilities. A component can use a simple class selector and still beat a utility, because the component layer comes after the utility layer. You are no longer forced to inflate selectors or reach for `!important`.

```html run
<div class="stack">
  <span class="badge muted">Layered component wins</span>
  <span class="badge muted unlayered">Unlayered wins</span>
</div>
<style>
  @layer utilities, components;
  @layer utilities { .muted { color: #64748b; } }
  @layer components {
    .badge { color: #0f766e; background: #ccfbf1; padding: 8px 12px; border-radius: 999px; }
  }
  .unlayered { color: #b45309; background: #fffbeb; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 8px; justify-items: start; }
</style>
```

Both badges carry `.badge` and `.muted`. In the first, the component layer is later than the utility layer, so the component's teal wins even though `.muted` would win on source order alone. In the second, the unlayered `.unlayered` rule wins because unlayered normal declarations sit above all layers.

`!important` reverses layer order. An important declaration in an earlier layer beats an important declaration in a later layer, and unlayered important declarations are the weakest of the important author declarations. That inversion is intentional: it gives lower-priority layers an escape hatch. It also means layers and `!important` combine into a system that is easy to get wrong if you add importance casually.

```html run
<div class="tag">Which layer wins when both are important?</div>
<style>
  @layer base, theme;
  @layer base { .tag { color: #b91c1c !important; } }
  @layer theme { .tag { color: #0f766e !important; } }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .tag { padding: 10px 14px; background: #fef2f2; border-radius: 8px; }
</style>
```

The text is red. For normal declarations, `theme` is later and would win. For important declarations, the order reverses, so `base` wins. If you remember only one thing about layers: normal order flows forward, important order flows backward.

## Source order is the last tiebreak

When two declarations share an origin, importance, layer and specificity, the one that appears later wins. That is all source order does. It is not a way to make a rule "more important" than a more specific rule.

This is why moving a rule down can fix a bug today and create a different bug tomorrow. Source order is a legitimate tool when the selectors are genuinely equal, but it is a fragile substitute for lowering specificity or organizing layers.

## Inheritance is not the cascade

Some properties inherit from parent to child: `color`, `font-family`, `font-size`, `line-height`, `letter-spacing`, `visibility`, `cursor` and `list-style`. Others do not: `margin`, `padding`, `border`, `background`, `width`, `height`, `display`. An inherited value is not a winning declaration. It is the value an element uses when no declaration wins for that property.

This distinction explains a common confusion. Setting `color` on a section changes every descendant that has no `color` declaration of its own. Setting `border` on the section changes only the section. The child does not get a border unless you ask for one.

Four keywords let you take control:

| Keyword | On an inherited property | On a non-inherited property |
|---|---|---|
| `inherit` | Takes the parent's computed value | Takes the parent's computed value |
| `initial` | Resets to the property's initial value | Resets to the property's initial value |
| `unset` | Behaves like `inherit` | Behaves like `initial` |
| `revert` | Rolls back to the previous origin | Rolls back to the previous origin |

`initial` is the property's initial value, not the browser's default for that element. `display: initial` is `inline`, not `block`, even on a `div`. `revert` is usually what people mean when they want "the browser default back": it discards author declarations and returns to the user-agent or user origin. `revert-layer` rolls back to the previous cascade layer.

```html run
<div class="panel">
  <p class="inherited">Inherited from the panel</p>
  <p class="explicit">Explicitly inherited</p>
  <p class="reset">Reset with initial</p>
  <p class="reverted">Rolled back with revert</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .panel { color: #0f766e; border: 2px solid #0f766e; padding: 16px; }
  p { margin: 0 0 8px; }
  .explicit { color: inherit; }
  .reset { color: initial; }
  .reverted { color: revert; }
</style>
```

The first two paragraphs are teal. The third is black because `color`'s initial value is the canvas text colour. The fourth is also black because `revert` returns to the user-agent colour. If you put `border: initial` on a child, the border disappears; if you put `border: inherit`, the child takes the parent's border.

> **Pitfall:** `all: unset` looks like a clean reset, but it resets every property, including `display`, and it does not reset custom properties. It is rarely what a component wants. Use targeted resets.

## `:where()` is how you make a reset step aside

A reset should set sensible defaults without outranking the component that uses it. `:where()` is the tool for that. It matches exactly like its argument but contributes zero specificity, so a later class can win without a selector arms race.

```html run
<article class="prose">
  <h2>An ordinary heading</h2>
  <p>Body copy with a little breathing room.</p>
  <h2 class="feature">A featured heading</h2>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose :where(h2) { margin: 0 0 8px; color: #475569; font-size: 1.125rem; }
  .feature { color: #0f766e; font-size: 1.75rem; }
</style>
```

The reset has the specificity of `.prose` alone because `:where(h2)` contributes nothing. `.feature` ties on the class count and comes later, so the featured heading turns teal and grows. Replace `:where(h2)` with `h2` and the reset becomes `.prose h2`, which beats `.feature` and flattens the design. That is the entire argument for `:where()` in a reset.

## Challenge: resolve a conflict without `!important`

The danger link below is supposed to be red. The `.nav a` rule is more specific than `.danger`, so the link stays slate. Fix it without `!important`, and keep the ordinary links slate.

```html exercise id=cascade-danger-link title="Resolve the conflict without !important"
<nav class="nav" aria-label="Account">
  <a href="#journal">Journal</a>
  <a href="#delete" class="danger">Delete account</a>
</nav>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .nav { display: flex; gap: 16px; }
  .nav a { color: #334155; font-weight: 600; }
  .danger { color: #b91c1c; }
  /* TODO: make the danger link red without changing the ordinary links. */
</style>
--- solution
<nav class="nav" aria-label="Account">
  <a href="#journal">Journal</a>
  <a href="#delete" class="danger">Delete account</a>
</nav>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .nav { display: flex; gap: 16px; }
  .nav a { color: #334155; font-weight: 600; }
  .nav a.danger { color: #b91c1c; }
</style>
--- test
assertColor(".nav a:not(.danger)", "color", "#334155", "Ordinary nav links should stay slate.");
assertColor(".nav .danger", "color", "#b91c1c", "The danger link still computes to the nav colour. .nav a scores (0, 1, 1); .danger scores (0, 1, 0). Raise the danger selector's specificity, or put both rules in layers.");
assertStyle(".nav .danger", "font-weight", "600", "Keep the nav's font weight; the danger rule should only change colour.");
var css = Array.prototype.map.call(document.querySelectorAll("style"), function (sheet) { return sheet.textContent; }).join("\n");
assert(!/!important/.test(css), "Solve this with specificity or source order, not !important. The test can see it in the stylesheet.");
--- hint
Compare the two selectors as tuples. `.nav a` is (0, 1, 1); `.danger` is (0, 1, 0).
--- hint
A selector such as `.nav a.danger` scores (0, 2, 1) and still only targets the danger link.
--- hint
Change `.danger` to `.nav a.danger`, or put both the nav rule and the danger rule in layers and make the danger layer later.
```

## Challenge: let a component override a utility with layers

The heading and the eyebrow both use the `.text-muted` utility. The component's `.card-title` rule is in the `components` layer, but the utility is in a later layer, so the heading is muted. Establish the layer order so components beat utilities, without removing either rule from its layer.

```html exercise id=cascade-layer-order title="Put components above utilities"
<div class="card">
  <p class="eyebrow text-muted">Design system</p>
  <h2 class="card-title text-muted">A component should win</h2>
</div>
<style>
  @layer components {
    .card-title { color: #0f172a; }
  }
  @layer utilities {
    .text-muted { color: #64748b; }
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .card { max-width: 28rem; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; }
  .eyebrow { margin: 0 0 6px; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .card-title { margin: 0; font-size: 1.5rem; }
  /* TODO: declare the layer order so components outrank utilities. */
</style>
--- solution
<div class="card">
  <p class="eyebrow text-muted">Design system</p>
  <h2 class="card-title text-muted">A component should win</h2>
</div>
<style>
  @layer utilities, components;
  @layer components {
    .card-title { color: #0f172a; }
  }
  @layer utilities {
    .text-muted { color: #64748b; }
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .card { max-width: 28rem; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; }
  .eyebrow { margin: 0 0 6px; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .card-title { margin: 0; font-size: 1.5rem; }
</style>
--- test
assertColor(".card-title", "color", "#0f172a", "The card title is still muted. The utilities layer is currently later than components, so .text-muted wins the normal cascade.");
assertColor(".eyebrow", "color", "#64748b", "The eyebrow should still use the muted utility. Keep both rules in their layers.");
assertStyle(".card-title", "font-size", "24px", "Keep the title size; this challenge is about layer order, not typography.");
--- hint
A layer's order is set the first time its name appears. You can declare both names before either block.
--- hint
`@layer utilities, components;` puts utilities first and components last.
--- hint
Put that statement at the top of the stylesheet, then check that `.text-muted` still styles the eyebrow.
```

## Debug: the callout that lost to an ID

The callout's text should be amber, but it is slate. The panel's `#sidebar p` rule is more specific than `.callout`, so the intended colour never wins. Fix the cascade without deleting the panel's base text styles.

```html debug id=cascade-sidebar-note title="The callout that lost to an ID"
<aside id="sidebar" class="sidebar">
  <p class="callout">Your export is ready. <a href="#download">Download it</a>.</p>
</aside>
<style>
  #sidebar p { color: #475569; line-height: 1.6; }
  .callout { color: #b45309; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- solution
<aside id="sidebar" class="sidebar">
  <p class="callout">Your export is ready. <a href="#download">Download it</a>.</p>
</aside>
<style>
  .sidebar :where(p) { color: #475569; line-height: 1.6; }
  .callout { color: #b45309; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- test
assertColor(".callout", "color", "#b45309", "The callout text is still slate. #sidebar p scores (1, 0, 1); .callout scores (0, 1, 0), so the ID rule wins before source order matters.");
assertColor(".callout", "background-color", "#fffbeb", "Keep the callout background; only the text colour is losing.");
assertStyle(".callout", "border-left-width", "4px", "Keep the amber border on the callout.");
var lineHeight = parseFloat(getComputedStyle(query(".callout")).lineHeight);
assert(lineHeight > 20, "Keep the panel's comfortable line-height; it currently computes to " + lineHeight + "px.");
--- hint
Run it and compare the callout's computed colour with the colour you wrote. The background and border work; only `color` is being overridden.
--- hint
The competing selector contains an ID. Either lower its specificity or raise the callout's specificity.
--- hint
Changing `#sidebar p` to `.sidebar :where(p)` drops the ID weight while keeping the base text styles. `#sidebar .callout` also works.
```

## Predict: which declaration wins?

Read the layer order, then choose the colour of the paragraph. The answer is decided by the layer step, not by which rule looks most specific.

```html predict id=cascade-predict-unlayered title="Which colour reaches the paragraph?"
<article class="card">
  <p class="tag">Which colour wins?</p>
</article>
<style>
  @layer base, theme;
  @layer theme { p { color: #0f766e; } }
  @layer base { p { color: #b91c1c; } }
  p { color: #1d4ed8; }
</style>
--- options
* Blue
Red
Teal
It depends on the order of the two @layer blocks
--- explain
Unlayered normal author declarations beat every layered normal declaration, regardless of specificity or source order. The unlayered `p` rule wins, so the text is blue. If the unlayered rule disappeared, layer order would decide: `base` comes before `theme`, so `theme` would win and the text would be teal. The ordering of the blocks themselves does not reorder the layers; the `@layer base, theme;` statement does.
```

## Recap

- The cascade sorts declarations by origin and importance, then element-attached styles, then layers, then specificity, then source order.
- Specificity is a tuple of IDs, classes/attributes/pseudo-classes, and types/pseudo-elements. Compare it column by column.
- `:is()`, `:not()` and `:has()` adopt their most specific argument; `:where()` contributes zero.
- Normal layers flow forward: later layers win. Important layers flow backward, and unlayered important declarations are weakest.
- Inheritance is separate from the cascade. `inherit`, `initial`, `unset` and `revert` let you choose where a value comes from.
- `!important` is not a fix for a specificity problem. It changes the origin ordering and makes every later override harder.

**Up next:** custom properties and design tokens — how to make one declaration drive a theme, a component and a spacing scale without repeating yourself.
