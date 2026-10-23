The first dark mode is usually a pile of overrides. Every card, button and border gets a second rule, and the two sets drift apart within a month. The second dark mode is a handful of custom properties: one set on `:root`, one set on `.theme-dark`, and every component reads from the same names.

Custom properties are the part of CSS that behaves most like a programming language, but they are still CSS. They cascade, they inherit, and they can be scoped to a subtree. Understanding that model is the difference between a token system that scales and a drawer full of names nobody trusts.

## A custom property is a named value

A custom property is a declaration whose name starts with two hyphens:

```css
:root {
  --color-accent: #0f766e;
  --space-2: 8px;
}
```

Read it with `var()`:

```css
.button {
  background: var(--color-accent);
  padding: var(--space-2) calc(var(--space-2) * 2);
}
```

That is the whole syntax. The important part is the semantics. A custom property is not a Sass variable that disappears at build time. It lives on an element, participates in the cascade, and inherits to descendants by default. If three ancestors declare `--color-accent`, the nearest ancestor with a winning declaration supplies the value for that subtree.

Names are case-sensitive: `--color-accent` and `--Color-Accent` are different tokens. Values are stored as token streams, not as typed values. A custom property can hold a colour, a length, a shadow, a font stack, or a fragment such as `1px solid currentColor`. It cannot be concatenated into a property name, and a stored declaration fragment cannot be expanded into a declaration; `--rule: color: red` is just a string of tokens, not something CSS will apply.

```html run
<div class="cards">
  <article class="card" style="--accent: #0f766e">
    <p class="eyebrow">Field notes</p>
    <h2>Ridge trail</h2>
    <a href="#">Read the entry</a>
  </article>
  <article class="card" style="--accent: #b45309">
    <p class="eyebrow">Workshop</p>
    <h2>Joint geometry</h2>
    <a href="#">See the bench</a>
  </article>
  <article class="card">
    <p class="eyebrow">No accent</p>
    <h2>Fallback card</h2>
    <a href="#">Default link</a>
  </article>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; max-width: 880px; }
  .card { padding: 16px; border: 1px solid #e2e8f0; border-top: 4px solid var(--accent, #94a3b8); border-radius: 12px; background: #fff; }
  .eyebrow { margin: 0 0 4px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent, #64748b); }
  .card h2 { margin: 0 0 8px; font-size: 1.1rem; }
  .card a { color: var(--accent, #475569); font-weight: 600; }
</style>
```

The two inline `--accent` declarations are inherited by the card's heading, eyebrow and link. The third card has no `--accent`, so every `var()` falls back to its second argument. Notice that the token is declared once on the card and consumed in three places. That is the first useful property of tokens: one decision, many consumers.

> **Under the hood:** `var()` substitution happens at computed-value time. The custom property itself is computed first, then the substitution happens for the property that uses it. If the substituted result is invalid for that property, the declaration becomes invalid at computed-value time.

## Global tokens belong on `:root`

`:root` matches the document's root element, normally `<html>`. It is the highest point in the inheritance tree, so a token declared there is available everywhere unless a closer ancestor overrides it. That makes it the right place for the small set of decisions that define the product: surface, text, accent, border, radius, and a spacing scale.

Name tokens by role, not by value. `--color-surface` survives a rebrand; `--color-white` becomes a lie the moment the dark theme uses it. `--space-2` is stable across density modes; `--padding-16` is a number pretending to be a decision.

There are two common tiers:

- **Primitive tokens** describe the raw palette and scale: `--teal-700`, `--slate-100`, `--space-4`.
- **Semantic tokens** describe how the product uses them: `--color-accent`, `--color-surface`, `--color-text-muted`.

Components should consume semantic tokens. Primitives are an implementation detail of the theme. If every component reads `--teal-700` directly, a theme change becomes a search-and-replace exercise.

> **Pitfall:** Token soup. A token for every property on every component feels systematic and is usually the opposite. If a value appears once and never themes, write the value. Tokenise decisions that repeat, that need to change together, or that form a public API for other components.

A useful test is to ask what would change if the value changed. If the answer is "nothing outside this one card", it is a local value, not a global token. If the answer is "the whole product shifts", it is a semantic token. If the answer is "the palette changes but the role does not", it is a primitive that should probably be hidden behind a semantic token. That test keeps the token set small enough to read.

Names should describe the job, not the colour or size. `--color-surface` can be white in the light theme and near-black in the dark theme. `--space-3` can be 12px in a compact theme and 16px in a comfortable one. A token named `--color-white` cannot survive either change without becoming false. The same rule applies to component tokens: `--button-bg` is a role; `--button-teal` is a value that will not age well.

Here is the same panel in two themes. The markup is identical; only the token values change.

```html run
<div class="themes">
  <section class="surface">
    <p class="label">Light</p>
    <h2>Monthly report</h2>
    <p>Revenue is up 12% against the same week last month.</p>
    <button type="button">Export</button>
  </section>
  <section class="surface theme-dark">
    <p class="label">Dark</p>
    <h2>Monthly report</h2>
    <p>Revenue is up 12% against the same week last month.</p>
    <button type="button">Export</button>
  </section>
</div>
<style>
  :root {
    --color-surface: #ffffff;
    --color-ink: #0f172a;
    --color-muted: #64748b;
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
  }
  .theme-dark {
    --color-surface: #0f172a;
    --color-ink: #e2e8f0;
    --color-muted: #94a3b8;
    --color-accent: #5eead4;
    --color-on-accent: #042f2e;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #e2e8f0; }
  .themes { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; max-width: 880px; }
  .surface { padding: 20px; border-radius: 16px; background: var(--color-surface); color: var(--color-ink); }
  .label { margin: 0 0 6px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--color-muted); }
  .surface h2 { margin: 0 0 8px; font-size: 1.25rem; }
  .surface p { margin: 0 0 16px; line-height: 1.5; }
  .surface button { border: 0; border-radius: 8px; padding: 8px 14px; background: var(--color-accent); color: var(--color-on-accent); font: inherit; font-weight: 600; }
</style>
```

The `.theme-dark` class does not restyle the panel's children. It redefines four tokens on the section, and the children inherit the new values. This is why a theme can be a class on any subtree, not just on `<body>`.

That override is just the cascade. `--color-accent` on `.theme-dark` is an ordinary declaration that wins for that element and inherits to its descendants. If a component declares its own `--color-accent`, that declaration wins for the component's subtree, which is exactly how a one-off accent can coexist with a theme. If someone puts `!important` on a root token, it jumps ahead of the ordinary theme override and the theme stops working. Treat tokens as declarations, not as constants.

> **Tip:** When a token "has the wrong value", walk up the DOM from the element that uses it and look for the nearest ancestor with a winning declaration. The problem is almost always scope, not `var()`.

## Fallbacks cover missing tokens, not invalid values

`var(--token, fallback)` uses the fallback when the custom property is not defined, or when its value is the guaranteed-invalid value. A nested fallback is allowed:

```css
color: var(--chip-ink, var(--color-ink, #0f172a));
```

The fallback is not a safety net for a token that exists but has an invalid value. If `--gap: 12` is defined and you write `gap: var(--gap, 16px)`, the substitution produces `gap: 12`, which is invalid. The declaration becomes invalid at computed-value time and `gap` falls back to its initial value, **not** to `16px`. The fallback is for absence, not for bad data.

This matters when tokens come from a CMS, a theme editor, or a component API. Validate values at the point where they enter the system; do not expect `var()` to repair them.

```html run
<div class="chips">
  <span class="chip">Default</span>
  <span class="chip" style="--chip-bg: #ccfbf1; --chip-ink: #0f766e; --chip-pad: 6px 10px">Custom</span>
  <span class="chip" style="--chip-bg: #fef3c7">Partial</span>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .chips { display: flex; gap: 8px; }
  .chip { padding: var(--chip-pad, 8px 14px); background: var(--chip-bg, #e2e8f0); color: var(--chip-ink, #0f172a); border-radius: 999px; font-weight: 600; }
</style>
```

The second chip overrides all three tokens. The third overrides only the background, so the padding and ink come from fallbacks. The first uses all three fallbacks. That is the intended use of `var()` fallbacks: optional overrides with a sensible baseline.

Custom properties are values, not a general-purpose preprocessor. They cannot appear in selectors, property names, or at-rule conditions. `@media (min-width: var(--breakpoint))` does not work, because the media query is parsed before custom properties are resolved. Breakpoints have to be literals, or generated by a build step. The same parse-time boundary applies anywhere CSS needs a concrete value before the cascade runs.

That boundary is useful. Tokens are for values that flow through the DOM: colours, spacing, radii, shadows, type sizes, component states. They are not a way to make CSS Turing-complete. Keeping them at the value layer is what makes them predictable.

## Scope component tokens to the component

Global semantic tokens are the theme. Component tokens are the component's API. A button can define its own defaults and let variants override only the tokens:

```css
.button {
  --button-bg: var(--color-accent);
  --button-ink: var(--color-on-accent);
  background: var(--button-bg);
  color: var(--button-ink);
}

.button--danger {
  --button-bg: var(--color-danger);
  --button-ink: var(--color-on-danger);
}
```

The component's rules never change. The variant changes two values, and every descendant that reads those tokens follows. This pattern keeps variants from turning into a matrix of property overrides.

There is a scoping rule hiding in that example. A custom property declared on `.button` is inherited by the button's children, but not by its siblings. If you declare `--button-bg` on a toolbar and the button is outside the toolbar, the button never sees it. That is not a bug in custom properties; it is the same inheritance model as `color`.

```html run
<div class="row">
  <button class="btn" type="button">Save</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--danger" type="button">Delete</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
</div>
<style>
  :root {
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
    --color-danger: #b91c1c;
    --color-on-danger: #ffffff;
    --color-ink: #0f172a;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 8px; flex-wrap: wrap; }
  .btn {
    --btn-bg: var(--color-accent);
    --btn-ink: var(--color-on-accent);
    --btn-border: transparent;
    background: var(--btn-bg);
    color: var(--btn-ink);
    border: 2px solid var(--btn-border);
    border-radius: 10px;
    padding: 10px 16px;
    font: inherit;
    font-weight: 600;
  }
  .btn--secondary { --btn-bg: #e2e8f0; --btn-ink: var(--color-ink); }
  .btn--danger { --btn-bg: var(--color-danger); --btn-ink: var(--color-on-danger); }
  .btn--ghost { --btn-bg: transparent; --btn-ink: var(--color-ink); --btn-border: #cbd5e1; }
</style>
```

Only the token declarations differ between variants. The background, text colour and border rules are written once. That is the shape of a maintainable component API: properties are stable, tokens are the variation points.

## Typed properties with `@property`

By default a custom property is untyped and inherits. `@property` lets you register it with a syntax, an initial value, and an inheritance rule:

```css
@property --lift {
  syntax: "<length>";
  inherits: false;
  initial-value: 0px;
}
```

Three things change. The browser validates assigned values against the syntax; an invalid value falls back to the initial value instead of poisoning the property. The initial value is well defined even when nothing sets the token. And `inherits: false` stops the value from leaking into descendants, which is useful for component-local state.

Registered properties can also be animated. That is the feature that makes `transition: --lift 180ms` meaningful; unregistered custom properties cannot be interpolated.

```html run
<div class="lift-row">
  <article class="lift-card" tabindex="0">
    <p class="eyebrow">Typed property</p>
    <h2>Hover or focus me</h2>
    <p>The card lifts by a registered length.</p>
  </article>
</div>
<style>
  @property --lift {
    syntax: "<length>";
    inherits: false;
    initial-value: 0px;
  }
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .lift-row { display: flex; justify-content: center; }
  .lift-card {
    --lift: 0px;
    width: 300px;
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #ffffff;
    transform: translateY(calc(var(--lift) * -1));
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.08);
    transition: --lift 180ms ease, box-shadow 180ms ease;
  }
  .lift-card:hover, .lift-card:focus-visible {
    --lift: 6px;
    box-shadow: 0 12px 24px rgb(15 23 42 / 0.14);
  }
  .eyebrow { margin: 0 0 6px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #0f766e; }
  .lift-card h2 { margin: 0 0 6px; font-size: 1.15rem; }
  .lift-card p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

> **In the wild:** Design systems often expose component tokens as documented custom properties. A button might accept `--button-bg`, `--button-ink` and `--button-radius` without ever exposing its internal padding or border styles. That is a contract, not an implementation detail.

Registration is a commitment. The `syntax` descriptor uses the same value grammar as CSS: `<length>`, `<color>`, `<number>`, `<percentage>`, `<angle>` and so on. The initial value must match the syntax, and `inherits` should be stated explicitly because it changes how the value moves through the tree. A browser that does not understand `@property` ignores the registration and treats the token as unregistered, so keep a `var()` fallback if you still support an older engine.

## Challenge: build a themeable button with semantic tokens

Two panels should share one button component. The light panel uses the default tokens; the dark panel overrides them. Define `--color-surface`, `--color-text`, `--color-accent` and `--color-on-accent` on `:root`, override those tokens in `.theme-dark`, and make both the panel and the button read from those names.

```html exercise id=tokens-themeable-button title="A button that follows its theme"
<div class="panel">
  <p class="eyebrow">Light</p>
  <button class="btn" type="button">Save changes</button>
</div>
<div class="panel theme-dark">
  <p class="eyebrow">Dark</p>
  <button class="btn" type="button">Save changes</button>
</div>
<style>
  /* Target palette
     light: surface #f8fafc, text #0f172a, accent #0f766e, on-accent #ffffff
     dark:  surface #0f172a, text #e2e8f0, accent #5eead4, on-accent #042f2e
     TODO: define the semantic tokens on :root, override them in .theme-dark,
     then make .panel and .btn consume the tokens. */
  .panel { padding: 20px; background: #f8fafc; color: #0f172a; }
  .btn { border: 0; border-radius: 999px; padding: 12px 20px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 16px; max-width: 420px; }
  .eyebrow { margin: 0 0 10px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
</style>
--- solution
<div class="panel">
  <p class="eyebrow">Light</p>
  <button class="btn" type="button">Save changes</button>
</div>
<div class="panel theme-dark">
  <p class="eyebrow">Dark</p>
  <button class="btn" type="button">Save changes</button>
</div>
<style>
  :root {
    --color-surface: #f8fafc;
    --color-text: #0f172a;
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
  }
  .theme-dark {
    --color-surface: #0f172a;
    --color-text: #e2e8f0;
    --color-accent: #5eead4;
    --color-on-accent: #042f2e;
  }
  .panel { padding: 20px; background: var(--color-surface); color: var(--color-text); }
  .btn { border: 0; border-radius: 999px; padding: 12px 20px; background: var(--color-accent); color: var(--color-on-accent); font: inherit; font-weight: 600; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 16px; max-width: 420px; }
  .eyebrow { margin: 0 0 10px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
</style>
--- test
function tokenColor(selector, name) {
  var value = getComputedStyle(query(selector)).getPropertyValue(name).trim();
  assert(value, "Define " + name + " on " + selector + " so the button can inherit it.");
  var probe = document.createElement("span");
  probe.style.color = value;
  document.body.appendChild(probe);
  var result = getComputedStyle(probe).color;
  probe.remove();
  return result;
}
assertColor(".theme-dark .btn", "background-color", "#5eead4", "The dark button is still teal. Override --color-accent on .theme-dark; the button should inherit the new value.");
assertColor(".theme-dark .btn", "color", "#042f2e", "The dark button label should use --color-on-accent. It currently reads " + getComputedStyle(query(".theme-dark .btn")).color + ".");
assertColor(".panel:not(.theme-dark) .btn", "background-color", "#0f766e", "The light button should keep the default accent.");
assertColor(".panel:not(.theme-dark) .btn", "color", "#ffffff", "The light button label should stay white.");
assertColor(".theme-dark", "background-color", "#0f172a", "The dark panel is still light. Make .panel read --color-surface.");
assert(tokenColor(":root", "--color-surface") === "rgb(248, 250, 252)", "Set --color-surface on :root to #f8fafc; the token should resolve to rgb(248, 250, 252).");
assert(tokenColor(".theme-dark", "--color-accent") === "rgb(94, 234, 212)", "Override --color-accent in .theme-dark with #5eead4 so descendants inherit it.");
--- hint
Start with the two token blocks. `:root` holds the light values; `.theme-dark` overrides the same names with dark values.
--- hint
The button should not contain any literal theme colours after the refactor. `background` and `color` should read `var(--color-accent)` and `var(--color-on-accent)`.
--- hint
Set `--color-surface` to `#f8fafc` on `:root` and `#0f172a` on `.theme-dark`. Then give `.panel` `background: var(--color-surface)` and `color: var(--color-text)`.
```

## Challenge: build a compact spacing scale

The invoice currently uses ad-hoc spacing values. Define a four-step scale on `:root` — `--space-1: 4px`, `--space-2: 8px`, `--space-3: 16px`, `--space-4: 24px` — then use it for the card padding, the heading's bottom margin, the paragraph's bottom margin and the button's padding.

```html exercise id=tokens-spacing-scale title="One scale, four decisions"
<section class="invoice">
  <h2>Invoice #1042</h2>
  <p>Due on 30 October. Late payments attract a 2% fee.</p>
  <button class="pay" type="button">Pay invoice</button>
</section>
<style>
  /* TODO: define --space-1 through --space-4 on :root,
     then use the scale below. */
  .invoice { padding: 20px; }
  .invoice h2 { margin: 0 0 12px; }
  .invoice p { margin: 0 0 20px; }
  .invoice .pay { padding: 10px 18px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .invoice { max-width: 420px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; }
  .invoice h2 { font-size: 1.25rem; }
  .invoice p { color: #475569; line-height: 1.5; }
  .invoice .pay { border: 0; border-radius: 8px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
</style>
--- solution
<section class="invoice">
  <h2>Invoice #1042</h2>
  <p>Due on 30 October. Late payments attract a 2% fee.</p>
  <button class="pay" type="button">Pay invoice</button>
</section>
<style>
  :root {
    --space-1: 4px;
    --space-2: 8px;
    --space-3: 16px;
    --space-4: 24px;
  }
  .invoice { padding: var(--space-4); }
  .invoice h2 { margin: 0 0 var(--space-2); }
  .invoice p { margin: 0 0 var(--space-3); }
  .invoice .pay { padding: var(--space-2) var(--space-3); }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .invoice { max-width: 420px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; }
  .invoice h2 { font-size: 1.25rem; }
  .invoice p { color: #475569; line-height: 1.5; }
  .invoice .pay { border: 0; border-radius: 8px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
</style>
--- test
function space(name, expected) {
  var actual = getComputedStyle(query(":root")).getPropertyValue(name).trim();
  assert(actual === expected, "Set " + name + " to " + expected + " on :root; it currently reads " + (actual || "nothing") + ".");
}
space("--space-1", "4px");
space("--space-2", "8px");
space("--space-3", "16px");
space("--space-4", "24px");
assertStyle(".invoice", "padding", "24px", "The invoice should use the largest step for its padding.");
assertStyle(".invoice h2", "margin-bottom", "8px", "The heading should sit 8px above the paragraph.");
assertStyle(".invoice p", "margin-bottom", "16px", "The paragraph should leave 16px before the button.");
assertStyle(".invoice .pay", "padding", "8px 16px", "The button padding should use two steps from the scale.");
--- hint
The scale is a vocabulary, not a set of names for specific properties. `--space-2` means "one small step", wherever that step is needed.
--- hint
Use `var(--space-4)` for the card padding, `var(--space-2)` under the heading, and `var(--space-3)` under the paragraph.
--- hint
The button uses two tokens: `padding: var(--space-2) var(--space-3);` gives 8px top/bottom and 16px left/right.
```

## Debug: the token declared on the wrong branch

The Preview button inside the toolbar is styled correctly. The Save button below it is transparent. The tokens are declared on `.toolbar`, but the Save button is a sibling of the toolbar, not a descendant, so it never inherits them. Move the tokens somewhere both buttons can see, without hard-coding the values on each button.

```html debug id=tokens-orphan-variable title="The token that never arrived"
<div class="toolbar">
  <span class="toolbar-label">Workspace</span>
  <button class="btn" type="button">Preview</button>
</div>
<button class="btn" type="button">Save changes</button>
<style>
  .toolbar {
    --btn-bg: #0f766e;
    --btn-ink: #ffffff;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    background: #f1f5f9;
    border-radius: 10px;
  }
  .btn {
    border: 0;
    border-radius: 8px;
    padding: 10px 16px;
    background: var(--btn-bg, transparent);
    color: var(--btn-ink, #0f172a);
    font: inherit;
    font-weight: 600;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; justify-items: start; }
</style>
--- solution
<div class="toolbar">
  <span class="toolbar-label">Workspace</span>
  <button class="btn" type="button">Preview</button>
</div>
<button class="btn" type="button">Save changes</button>
<style>
  :root {
    --btn-bg: #0f766e;
    --btn-ink: #ffffff;
  }
  .toolbar {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    background: #f1f5f9;
    border-radius: 10px;
  }
  .btn {
    border: 0;
    border-radius: 8px;
    padding: 10px 16px;
    background: var(--btn-bg, transparent);
    color: var(--btn-ink, #0f172a);
    font: inherit;
    font-weight: 600;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; justify-items: start; }
</style>
--- test
assertColor(".toolbar .btn", "background-color", "#0f766e", "The Preview button inside the toolbar should keep its teal background.");
assertColor("body > .btn", "background-color", "#0f766e", "The standalone Save button is transparent. A custom property on .toolbar cannot reach a sibling element.");
assertColor("body > .btn", "color", "#ffffff", "The standalone button's label is still dark. Its ink token has the same scoping problem.");
var inherited = getComputedStyle(query("body > .btn")).getPropertyValue("--btn-bg").trim();
assert(inherited !== "", "The standalone button still has no --btn-bg in scope. Move the token to a shared ancestor, or declare it on .btn itself.");
--- hint
Custom properties inherit down the tree. Walk from the Save button up to the nearest ancestor that declares `--btn-bg`. There isn't one.
--- hint
`body` and `:root` are ancestors of both buttons. Move the two token declarations there.
--- hint
You can also declare `--btn-bg` and `--btn-ink` on `.btn`, but then the toolbar cannot override them for a variant without a more specific selector.
```

## Predict: what does the badge inherit?

The badge has no `--tone` of its own. Read the nested structure and choose the colour it will use.

```html predict id=tokens-predict-inheritance title="Which tone reaches the badge?"
<div class="outer" style="--tone: #0f766e">
  <div class="middle" style="--tone: #b45309">
    <div class="inner">
      <span class="badge">Status</span>
    </div>
  </div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .badge { color: var(--tone, #64748b); font-weight: 700; }
</style>
--- options
* Amber
Teal
Slate
It depends on which declaration appears first in the stylesheet
--- explain
Custom properties are inherited. The badge looks up the tree and finds the nearest ancestor with a winning `--tone` declaration, which is `.middle` with `#b45309`. The outer teal value is farther away and loses. Source order is irrelevant because the two declarations are on different elements. If the middle token were removed, the badge would inherit teal; if both were removed, it would use the slate fallback.
```

## Recap

- A custom property is a cascading, inheriting value, not a build-time variable. Read it with `var()`.
- Put global semantic tokens on `:root`, and override them on a theme class to re-skin a subtree.
- Fallbacks cover a missing token, not a token whose value is invalid for the property.
- Scope component tokens to the component or a shared ancestor. Siblings do not inherit from each other.
- Name tokens by role (`--color-surface`) rather than value (`--color-white`), and avoid token soup.
- Register a custom property with `@property` when you need validation, a reliable initial value, no inheritance, or animation.

**Up next:** modern selectors — `:is()`, `:where()`, `:has()` and the relational patterns that remove state classes and specificity fights.
