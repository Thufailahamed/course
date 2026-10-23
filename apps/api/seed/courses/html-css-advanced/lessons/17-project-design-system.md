A design system is not a folder of components. It is a set of decisions that stay true when different people build different screens: what "surface" means, how much space a section gets, which blue is the action color, and what a disabled button looks like at 2am. The CSS is the enforcement mechanism; the contract is the point.

This capstone builds that contract. You will define tokens for color, spacing, radius, shadow and type, wire light and dark themes, build button variants and a form field with a real error state, compose a card and a badge, and arrange everything in a responsive gallery. The page is both the product and its documentation.

## Tokens: name the decision, not the value

A raw value like `#4f46e5` tells you nothing about where it is allowed. A token like `--color-brand` tells you the role. Start with a small set of **semantic** tokens: background, surface, text, muted text, border, brand, on-brand, danger, success. Components consume those names. If the brand changes, one token changes and every component follows.

There is a useful distinction between **primitive** tokens (`--indigo-600: #4f46e5`) and **semantic** tokens (`--color-brand: var(--indigo-600)`). Primitives are the palette; semantics are the API. Most components should use semantics. A palette token is fine inside a theme definition, but a button should not care that the brand happens to be indigo this quarter.

```html run
<section class="compare">
  <article class="panel theme-light">
    <p class="label">Light</p>
    <h2>Paper</h2>
    <p>Warm, low-contrast surfaces for long reading sessions.</p>
    <span class="chip">--color-brand</span>
  </article>
  <article class="panel theme-dark">
    <p class="label">Dark</p>
    <h2>Night</h2>
    <p>The same components, remapped by one class.</p>
    <span class="chip">--color-brand</span>
  </article>
</section>

<style>
  @layer tokens, components;
  @layer tokens {
    :root {
      --color-bg: #f6f5f2; --color-surface: #fffdf9; --color-text: #1c1917; --color-muted: #57534e;
      --color-border: #d6d3d1; --color-brand: #4f46e5; --space-5: 24px; --radius-lg: 20px;
      --shadow-md: 0 12px 32px rgb(28 25 23 / 0.12); --text-lg: 1.25rem;
    }
    .theme-dark {
      --color-bg: #0b1120; --color-surface: #111c33; --color-text: #e2e8f0; --color-muted: #94a3b8;
      --color-border: #24324a; --color-brand: #818cf8; --shadow-md: 0 12px 32px rgb(0 0 0 / 0.35);
    }
  }
  @layer components {
    body { margin: 0; padding: 32px; background: var(--color-bg); color: var(--color-text); font-family: ui-sans-serif, system-ui, sans-serif; }
    .compare { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; max-width: 760px; }
    .panel { padding: var(--space-5); border: 1px solid var(--color-border); border-radius: var(--radius-lg); background: var(--color-surface); color: var(--color-text); box-shadow: var(--shadow-md); }
    .label { margin: 0 0 8px; color: var(--color-muted); font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase; }
    .panel h2 { margin: 0 0 8px; font-size: var(--text-lg); }
    .panel p { margin: 0 0 16px; color: var(--color-muted); line-height: 1.6; }
    .chip { display: inline-block; padding: 4px 9px; border-radius: 999px; background: var(--color-brand); color: #fff; font-size: 0.72rem; font-weight: 650; }
    .theme-dark .chip { color: #0b1120; }
  }
</style>
```

`@layer tokens, components;` declares the order once. Tokens are resolved first, then components. Layer order is independent of where the blocks appear; that is what makes it a useful architecture tool rather than another specificity trick.

> **Pitfall:** Unlayered CSS beats every layer. If a stray `.button { background: red; }` sits outside your layers, it wins no matter how carefully you ordered them. Put the whole system in layers, and reserve unlayered CSS for the rare intentional override.

## Themes: remap, do not repaint

Dark mode done badly is a second stylesheet. Dark mode done well is the same components with different token values. The component rules never mention white or black; they mention `--color-surface` and `--color-text`. The theme changes the values, and the components keep working.

There are two entry points. The user's operating-system preference comes through `prefers-color-scheme`. An explicit choice — a theme switch, a marketing page with a dark hero, a documentation panel — comes through a class such as `.theme-dark`. Both can coexist: the media query sets the default, and the class overrides it.

```css
:root {
  --color-bg: #f6f5f2;
  --color-text: #1c1917;
}
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #0b1120;
    --color-text: #e2e8f0;
  }
}
.theme-dark {
  --color-bg: #0b1120;
  --color-text: #e2e8f0;
}
```

The duplication is deliberate: the media query is the default, and the class is an explicit override. Keep the dark values in one place if you can, or use `light-dark()` with `color-scheme: light dark`; the important rule is that components consume semantic tokens, not fixed colors.

Also set `color-scheme: light` or `color-scheme: dark` on the theme. It tells the browser how to render form controls, scrollbars and default UI, and it prevents a dark page with a blinding white select box.

> **Tip:** Do not test dark mode by inverting colors. Test it by reading the token values and checking contrast. A lighter brand color often needs a darker "on-brand" text color; a dark surface often needs a lighter border, not the same border at 20% opacity.

## A scale beats a hundred decisions

Spacing, radius, shadow and type need scales for the same reason color does: consistency is cheaper than taste applied one property at a time. A four-pixel base with steps at 8, 12, 16, 24, 32 and 48 covers most layouts. Three radii — small, medium, large — cover most components. Two shadows — a quiet border shadow and a lifted card shadow — cover most depth.

```html run
<section class="sheet">
  <div class="type">
    <p class="eyebrow">Type scale</p>
    <p class="display">Display 40</p>
    <p class="title">Title 28</p>
    <p class="body">Body 16. Long-form text with a comfortable measure and a line height that lets the eye rest.</p>
  </div>
  <div class="tokens">
    <p class="eyebrow">Space</p>
    <div class="space"><span>8</span><i style="--w: 8px"></i></div>
    <div class="space"><span>16</span><i style="--w: 16px"></i></div>
    <div class="space"><span>24</span><i style="--w: 24px"></i></div>
    <div class="space"><span>32</span><i style="--w: 32px"></i></div>
    <p class="eyebrow radii-label">Radius and shadow</p>
    <div class="radii"><i class="r-sm"></i><i class="r-md"></i><i class="r-lg"></i><i class="r-shadow"></i></div>
  </div>
</section>

<style>
  :root {
    --ink: #1c1917; --muted: #57534e; --line: #d6d3d1; --brand: #4f46e5;
    --space-2: 8px; --space-4: 16px; --space-5: 24px; --space-6: 32px;
    --radius-sm: 8px; --radius-md: 12px; --radius-lg: 20px;
    --shadow-sm: 0 1px 2px rgb(28 25 23 / 0.08); --shadow-md: 0 12px 32px rgb(28 25 23 / 0.12);
    --text-2xl: 2.5rem; --text-xl: 1.75rem; --text-md: 1rem;
  }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--ink); font-family: ui-sans-serif, system-ui, sans-serif; }
  .sheet { display: grid; grid-template-columns: 1.2fr 1fr; gap: 32px; max-width: 900px; }
  .eyebrow { margin: 0 0 12px; color: var(--muted); font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase; }
  .display { margin: 0; font-size: var(--text-2xl); font-weight: 750; letter-spacing: -0.04em; }
  .title { margin: 8px 0 0; font-size: var(--text-xl); letter-spacing: -0.02em; }
  .body { max-width: 34rem; margin: 16px 0 0; color: var(--muted); font-size: var(--text-md); line-height: 1.65; }
  .tokens { padding: 24px; border: 1px solid var(--line); border-radius: var(--radius-lg); background: #fffdf9; box-shadow: var(--shadow-sm); }
  .space { display: flex; align-items: center; gap: 12px; margin: 8px 0; color: var(--muted); font-size: 0.75rem; }
  .space i { display: block; width: var(--w); height: 12px; border-radius: 3px; background: var(--brand); }
  .radii-label { margin-top: 24px; } .radii { display: flex; align-items: center; gap: 10px; }
  .radii i { display: block; width: 42px; height: 42px; background: #eef2ff; border: 1px solid #c7d2fe; }
  .r-sm { border-radius: var(--radius-sm); } .r-md { border-radius: var(--radius-md); } .r-lg { border-radius: var(--radius-lg); }
  .r-shadow { border: 0 !important; border-radius: var(--radius-md); background: #fff !important; box-shadow: var(--shadow-md); }
</style>
```

The exact numbers matter less than the commitment. Once three radii exist, a fourth needs a reason. Once the type scale has six steps, a seventh needs a reason. This is how a system stays coherent when five people add components in the same quarter.

## Buttons: variants are a contract

A button has a job. The primary variant is the one action you want most people to take on a screen; there should usually be one. Secondary is a safe alternative. Ghost is for low-emphasis actions inside dense UI. The variants should differ in weight, not just hue, and every one needs the same geometry so a row of buttons does not wobble.

States are part of the component, not an afterthought. Hover is a hint; `:focus-visible` is a requirement. Use `:focus-visible`, not `:focus`, so a mouse click does not leave a ring behind. The ring needs contrast against both the button and the page, and `outline-offset` keeps it from disappearing into the border. Disabled buttons should look unavailable and be removed from the tab order; a native `disabled` attribute does both.

```html run
<div class="actions">
  <button class="btn btn--primary" type="button">Save changes</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
  <button class="btn btn--primary" type="button" disabled>Publish</button>
</div>

<style>
  :root { --brand: #4f46e5; --brand-strong: #4338ca; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; --muted: #57534e; }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--text); font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; align-items: center; gap: 10px; }
  .btn { display: inline-flex; align-items: center; justify-content: center; min-height: 44px; padding: 0 18px; border: 1px solid transparent; border-radius: 999px; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif; cursor: pointer; transition: background-color 150ms ease, border-color 150ms ease, transform 150ms ease; }
  .btn--primary { background: var(--brand); color: #fff; }
  .btn--primary:hover { background: var(--brand-strong); }
  .btn--secondary { background: var(--surface); color: var(--text); border-color: var(--line); }
  .btn--secondary:hover { border-color: var(--brand); }
  .btn--ghost { background: transparent; color: var(--brand); }
  .btn--ghost:hover { background: #eef2ff; }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 55%, transparent); outline-offset: 3px; }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }
  .btn:active { transform: translateY(1px); }
  @media (prefers-reduced-motion: reduce) { .btn { transition: none; } }
</style>
```

The active state is a one-pixel translate, which is enough to feel physical without turning the interface into a toy. The disabled state uses opacity plus `cursor: not-allowed`; the native attribute prevents focus and activation, so there is no half-disabled state to explain.

> **Pitfall:** A `div` with `role="button"` needs a tabindex, key handlers and disabled-state management. A real `<button>` already has all three. Use the element unless you have a very specific reason not to.

## Forms: the error is part of the label

A field is a label, a control, optional help text, and an error. The error must be programmatically associated with the input, not just placed below it in red. `aria-invalid="true"` announces the invalid state; `aria-describedby` points at the error text so a screen reader reads it with the field. The visible label must be a real `<label for="...">`, not a placeholder.

The error should also have a shape cue, such as an icon or the word "Error", because color alone is not enough. The border can change, but the text carries the meaning.

```html run
<article class="card">
  <div class="card-head">
    <span class="badge">Draft</span>
    <span class="badge badge--success">Autosaved</span>
  </div>
  <h2>Invite a teammate</h2>
  <p>They will get access to the current workspace.</p>
  <form class="form">
    <div class="field">
      <label for="invite-email">Email address</label>
      <input id="invite-email" name="email" type="email" value="sam@" aria-invalid="true" aria-describedby="invite-error">
      <p class="error" id="invite-error"><span aria-hidden="true">!</span> Enter a complete email address, including the domain.</p>
    </div>
    <button class="btn btn--primary" type="submit">Send invite</button>
  </form>
</article>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --line: #d6d3d1; --brand: #4f46e5; --danger: #b91c1c; --radius-lg: 20px; --radius-sm: 8px; --shadow-md: 0 12px 32px rgb(28 25 23 / 0.1); }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--text); font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--line); border-radius: var(--radius-lg); background: var(--surface); box-shadow: var(--shadow-md); }
  .card-head { display: flex; gap: 8px; margin-bottom: 16px; }
  .badge { display: inline-flex; align-items: center; padding: 4px 9px; border-radius: 999px; background: #eef2ff; color: #3730a3; font-size: 0.72rem; font-weight: 700; }
  .badge--success { background: #ecfdf5; color: #047857; }
  .card h2 { margin: 0 0 6px; font-size: 1.35rem; letter-spacing: -0.02em; }
  .card > p { margin: 0 0 20px; color: var(--muted); line-height: 1.55; }
  .form { display: grid; gap: 16px; }
  .field { display: grid; gap: 6px; }
  .field label { font-size: 0.85rem; font-weight: 650; }
  .field input { min-height: 44px; padding: 0 12px; border: 1px solid var(--line); border-radius: var(--radius-sm); background: #fff; color: var(--text); font: inherit; }
  .field input:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 45%, transparent); outline-offset: 2px; border-color: var(--brand); }
  .field input[aria-invalid="true"] { border-color: var(--danger); }
  .error { display: flex; gap: 6px; margin: 0; color: var(--danger); font-size: 0.78rem; line-height: 1.45; }
  .error span { display: grid; place-items: center; width: 16px; height: 16px; flex: none; border-radius: 50%; background: var(--danger); color: #fff; font-size: 0.65rem; font-weight: 800; }
  .btn { min-height: 44px; padding: 0 18px; border: 0; border-radius: 999px; background: var(--brand); color: #fff; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif; cursor: pointer; }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 45%, transparent); outline-offset: 3px; }
</style>
```

The error text says what to do, not just that something is wrong. "Enter a complete email address, including the domain" is actionable. "Invalid input" is a riddle. The icon is redundant with the text on purpose; redundancy is how accessible design survives a grayscale screenshot.

## Challenge: build the token layer and a dark theme

The starter has a light surface, but no spacing, radius or shadow tokens, and `.theme-dark` never remaps the semantic colors. Add the missing tokens, define a dark surface and text, and make `.surface` consume them. The tests read the token values at runtime, so any coherent dark palette is accepted.

```html exercise id=design-token-theme title="Build the token layer and dark theme"
<section class="theme-dark">
  <article class="surface">
    <h2>Evening mode</h2>
    <p>The same component, a different set of decisions.</p>
  </article>
</section>

<style>
  :root {
    --color-bg: #f6f5f2;
    --color-surface: #fffdf9;
    --color-text: #1c1917;
    --color-muted: #57534e;
    --color-brand: #4f46e5;
    /* TODO: add --space-4, --radius-md and --shadow-card */
  }
  .theme-dark {
    /* TODO: remap the semantic colors for a dark surface */
  }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .surface {
    max-width: 420px;
    padding: var(--space-4);
    border-radius: var(--radius-md);
    background: var(--color-surface);
    color: var(--color-text);
    box-shadow: var(--shadow-card);
  }
  .surface h2 { margin: 0 0 8px; }
  .surface p { margin: 0; color: var(--color-muted); line-height: 1.6; }
</style>
--- solution
<section class="theme-dark">
  <article class="surface">
    <h2>Evening mode</h2>
    <p>The same component, a different set of decisions.</p>
  </article>
</section>

<style>
  :root {
    --color-bg: #f6f5f2;
    --color-surface: #fffdf9;
    --color-text: #1c1917;
    --color-muted: #57534e;
    --color-brand: #4f46e5;
    --space-4: 16px;
    --radius-md: 12px;
    --shadow-card: 0 12px 32px rgb(0 0 0 / 0.18);
  }
  .theme-dark {
    --color-bg: #0b1120;
    --color-surface: #111c33;
    --color-text: #e2e8f0;
    --color-muted: #94a3b8;
    --color-brand: #818cf8;
  }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .surface {
    max-width: 420px;
    padding: var(--space-4);
    border-radius: var(--radius-md);
    background: var(--color-surface);
    color: var(--color-text);
    box-shadow: var(--shadow-card);
  }
  .surface h2 { margin: 0 0 8px; }
  .surface p { margin: 0; color: var(--color-muted); line-height: 1.6; }
</style>
--- test
const root = getComputedStyle(document.documentElement);
["--space-4", "--radius-md", "--shadow-card"].forEach((name) => {
  assert(root.getPropertyValue(name).trim(), `Define ${name} on :root so components can share it`);
});
const theme = query(".theme-dark");
const surfaceToken = getComputedStyle(theme).getPropertyValue("--color-surface").trim();
const textToken = getComputedStyle(theme).getPropertyValue("--color-text").trim();
assert(surfaceToken && surfaceToken !== "#fffdf9", "Remap --color-surface inside .theme-dark; it still inherits the light value");
assertColor(".theme-dark .surface", "background-color", surfaceToken);
assertColor(".theme-dark .surface", "color", textToken);
assertStyle(".surface", "padding", "16px");
assertStyle(".surface", "border-radius", "12px");
--- hint
Add `--space-4: 16px`, `--radius-md: 12px` and a shadow token such as `0 12px 32px rgb(0 0 0 / 0.18)` to `:root`.
--- hint
Inside `.theme-dark`, redefine `--color-surface` and `--color-text` (and optionally `--color-muted` and `--color-brand`).
--- hint
The component already uses the variables. Once `.theme-dark` changes them, the surface updates without a single component rule changing.
```

## Challenge: build accessible button variants

Build primary, secondary and ghost buttons with a disabled example. The tests check that the variants compute to different surfaces, that the primary has enough height, that the disabled button is really disabled, and that the stylesheet includes a `:focus-visible` rule.

```html exercise id=design-button-variants title="Build accessible button variants"
<div class="actions">
  <button class="btn" type="button">Save changes</button>
  <button class="btn" type="button" disabled>Delete</button>
</div>

<style>
  :root { --brand: #4f46e5; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; }
  body { margin: 0; padding: 32px; background: #f6f5f2; font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; gap: 10px; }
  .btn { padding: 10px 16px; border: 1px solid var(--line); border-radius: 999px; background: #e2e8f0; color: var(--text); }
</style>
--- solution
<div class="actions">
  <button class="btn btn--primary" type="button">Save changes</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
  <button class="btn btn--primary" type="button" disabled>Publish</button>
</div>

<style>
  :root { --brand: #4f46e5; --brand-strong: #4338ca; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; }
  body { margin: 0; padding: 32px; background: #f6f5f2; font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; gap: 10px; }
  .btn {
    display: inline-flex; align-items: center; justify-content: center;
    min-height: 44px; padding: 0 18px; border: 1px solid transparent;
    border-radius: 999px; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif;
    cursor: pointer;
  }
  .btn--primary { background: var(--brand); color: #fff; }
  .btn--primary:hover { background: var(--brand-strong); }
  .btn--secondary { background: var(--surface); color: var(--text); border-color: var(--line); }
  .btn--ghost { background: transparent; color: var(--brand); }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 55%, transparent); outline-offset: 3px; }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }
</style>
--- test
assertExists(".btn--primary", "Add a primary button variant");
assertExists(".btn--secondary", "Add a secondary button variant");
assertExists(".btn--ghost", "Add a ghost button variant");
const backgrounds = [".btn--primary", ".btn--secondary", ".btn--ghost"].map((selector) => getComputedStyle(query(selector)).backgroundColor);
assert(new Set(backgrounds).size === 3, `The three variants should look different; their backgrounds are ${backgrounds.join(", ")}.`);
assertStyle(".btn--primary", "min-height", "44px");
assertColor(".btn--primary", "color", "#ffffff");
assertColor(".btn--secondary", "color", "#1c1917");
assertFocusable(".btn--primary");
const disabled = query(".btn[disabled]");
assert(disabled.disabled, "Keep the native disabled attribute on the unavailable action");
assert(parseFloat(getComputedStyle(disabled).opacity) < 1, "A disabled button should look unavailable, not identical to an enabled one");
const css = Array.from(document.querySelectorAll("style")).map((s) => s.textContent).join("\n");
assert(css.includes(":focus-visible"), "Add a :focus-visible rule so keyboard users can see where focus is");
--- hint
Use `.btn--primary`, `.btn--secondary` and `.btn--ghost` classes on the same `.btn` base.
--- hint
Give every variant `min-height: 44px`; the primary needs a filled background, the secondary a surface and border, and the ghost a transparent background.
--- hint
Add `.btn:focus-visible { outline: 3px solid ...; outline-offset: 3px; }` and keep the native `disabled` attribute on the last button.
```

## Debug: the card that stayed light

The dark theme remaps the surface and text tokens, but this card hard-codes a white background and then inherits the dark theme's light text. The result is nearly unreadable. Fix the component so it consumes the theme tokens, and repair the badge and paragraph while you are there.

```html debug id=design-dark-card-contrast title="The card that stayed light"
<section class="theme-dark">
  <article class="card">
    <span class="badge">Live</span>
    <h2>Night shift</h2>
    <p>The dashboard after dark, with the same components and a different set of token values.</p>
  </article>
</section>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --border: #d6d3d1; --brand: #4f46e5; }
  .theme-dark { --surface: #111c33; --text: #e2e8f0; --muted: #94a3b8; --border: #24324a; --brand: #818cf8; }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--border); border-radius: 16px; background: #ffffff; color: var(--text); }
  .card h2 { margin: 8px 0; }
  .card p { margin: 0; color: var(--muted); line-height: 1.6; }
  .badge { display: inline-block; padding: 4px 9px; border-radius: 999px; background: #eef2ff; color: #3730a3; font-size: 12px; font-weight: 700; }
</style>
--- solution
<section class="theme-dark">
  <article class="card">
    <span class="badge">Live</span>
    <h2>Night shift</h2>
    <p>The dashboard after dark, with the same components and a different set of token values.</p>
  </article>
</section>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --border: #d6d3d1; --brand: #4f46e5; }
  .theme-dark { --surface: #111c33; --text: #e2e8f0; --muted: #94a3b8; --border: #24324a; --brand: #818cf8; }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--border); border-radius: 16px; background: var(--surface); color: var(--text); }
  .card h2 { margin: 8px 0; }
  .card p { margin: 0; color: var(--muted); line-height: 1.6; }
  .badge { display: inline-block; padding: 4px 9px; border-radius: 999px; background: color-mix(in srgb, var(--brand) 16%, var(--surface)); color: var(--brand); font-size: 12px; font-weight: 700; }
</style>
--- test
const theme = query(".theme-dark");
const surface = getComputedStyle(theme).getPropertyValue("--surface").trim();
const text = getComputedStyle(theme).getPropertyValue("--text").trim();
const muted = getComputedStyle(theme).getPropertyValue("--muted").trim();
assertColor(".theme-dark .card", "background-color", surface);
assertColor(".theme-dark .card", "color", text);
assertColor(".theme-dark .card p", "color", muted);
assertColor(".theme-dark .badge", "color", getComputedStyle(theme).getPropertyValue("--brand").trim());
const rgb = (value) => value.match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
const luminance = (value) => {
  const [r, g, b] = rgb(value).map((channel) => {
    const c = channel / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};
const contrast = (a, b) => {
  const [lighter, darker] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (lighter + 0.05) / (darker + 0.05);
};
const cardStyle = getComputedStyle(query(".card"));
const ratio = contrast(cardStyle.color, cardStyle.backgroundColor);
assert(ratio >= 4.5, `The card text has ${ratio.toFixed(1)}:1 contrast against its surface; aim for at least 4.5:1.`);
const paragraphStyle = getComputedStyle(query(".card p"));
assert(contrast(paragraphStyle.color, paragraphStyle.backgroundColor) >= 4.5, "The paragraph text should also meet 4.5:1 against the card surface");
--- hint
`background: #ffffff` is a hard-coded light surface. Replace it with `var(--surface)`.
--- hint
The text color already uses `var(--text)`, so once the background follows the theme the contrast returns. Do the same for `.card p` with `var(--muted)`.
--- hint
The badge can use `color-mix(in srgb, var(--brand) 16%, var(--surface))` with `color: var(--brand)` so it adapts to the theme too.
```

## Predict: which layer wins?

```html predict id=design-layer-order title="Which background wins?"
<p class="pill">Layer test</p>
<style>
  @layer base, components;
  @layer base { .pill { background: #d6d3d1; color: #1c1917; } }
  @layer components { .pill { background: #4f46e5; color: #fff; } }
  .pill { display: inline-block; padding: 8px 14px; border-radius: 999px; background: #f59e0b; color: #1c1917; font-family: ui-sans-serif, system-ui, sans-serif; font-weight: 650; }
</style>
--- options
* Amber, because unlayered styles beat every layer
Indigo, because components is the last layer
Slate, because base is the first layer
The browser averages the three backgrounds
--- explain
`@layer base, components;` sets the order, so indigo would beat slate if both were layered. But the final `.pill` rule is **unlayered**. Normal unlayered declarations have higher priority than every layer, so amber wins. This is why a design system should either put all component CSS in layers or clearly reserve unlayered rules for intentional overrides.
```

## The complete gallery

This page is the system's home: a masthead, a token shelf, a button row, a field with an error, cards and badges. The gallery uses `repeat(auto-fit, minmax(...))` so the same markup goes from one column to three without a breakpoint. The whole thing sits inside `@layer tokens, base, components, utilities`.

```html run
<header class="masthead">
  <p class="eyebrow">Lumen system · v1.0</p>
  <h1>One language, many surfaces.</h1>
  <p class="lede">Tokens, buttons, fields and cards. Change the theme, not the components.</p>
</header>
<section class="gallery">
  <article class="panel"><h2>Buttons</h2><div class="row"><button class="btn btn--primary" type="button">Save</button><button class="btn btn--secondary" type="button">Preview</button><button class="btn btn--ghost" type="button">Cancel</button></div></article>
  <article class="panel"><h2>Field</h2><div class="field"><label for="demo-email">Email</label><input id="demo-email" type="email" value="sam@" aria-invalid="true" aria-describedby="demo-error"><p class="error" id="demo-error"><span aria-hidden="true">!</span> Add the domain after the @.</p></div></article>
  <article class="panel"><span class="badge">New</span><h2>Card</h2><p>A composed surface: border, radius, shadow and type all come from tokens.</p></article>
  <article class="panel theme-dark"><span class="badge">Dark</span><h2>Same components</h2><p>The class changes the token values; nothing inside is repainted.</p></article>
</section>

<style>
  @layer tokens, base, components, utilities;
  @layer tokens {
    :root { --bg:#f6f5f2; --surface:#fffdf9; --text:#1c1917; --muted:#57534e; --border:#d6d3d1; --brand:#4f46e5; --space-4:16px; --space-5:24px; --radius-md:12px; --radius-lg:20px; --shadow-md:0 12px 32px rgb(28 25 23 / .12); }
    @media (prefers-color-scheme: dark) { :root { --bg:#0b1120; --surface:#111c33; --text:#e2e8f0; --muted:#94a3b8; --border:#24324a; --brand:#818cf8; } }
    .theme-dark { --bg:#0b1120; --surface:#111c33; --text:#e2e8f0; --muted:#94a3b8; --border:#24324a; --brand:#818cf8; }
  }
  @layer base {
    * { box-sizing:border-box; } body { margin:0; padding:32px; background:var(--bg); color:var(--text); font-family:ui-sans-serif,system-ui,sans-serif; }
    h1 { margin:0 0 8px; font-size:clamp(2rem,5vw,3.5rem); line-height:1; letter-spacing:-.04em; } h2 { margin:8px 0; font-size:1.15rem; }
  }
  @layer components {
    .masthead { max-width:980px; margin:0 auto 24px; } .eyebrow { margin:0 0 10px; color:var(--muted); font-size:.72rem; letter-spacing:.14em; text-transform:uppercase; } .lede { max-width:44rem; margin:0; color:var(--muted); line-height:1.6; }
    .gallery { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:16px; max-width:980px; margin:0 auto; }
    .panel { padding:var(--space-5); border:1px solid var(--border); border-radius:var(--radius-lg); background:var(--surface); color:var(--text); box-shadow:var(--shadow-md); } .panel > p { margin:0; color:var(--muted); line-height:1.6; }
    .row { display:flex; flex-wrap:wrap; gap:8px; } .btn { min-height:44px; padding:0 16px; border:1px solid transparent; border-radius:999px; font:650 .85rem/1 ui-sans-serif,system-ui,sans-serif; cursor:pointer; }
    .btn--primary { background:var(--brand); color:#fff; } .btn--secondary { background:var(--surface); color:var(--text); border-color:var(--border); } .btn--ghost { background:transparent; color:var(--brand); }
    .btn:focus-visible { outline:3px solid color-mix(in srgb,var(--brand) 55%,transparent); outline-offset:3px; }
    .field { display:grid; gap:6px; } .field label { font-size:.85rem; font-weight:650; } .field input { min-height:44px; padding:0 10px; border:1px solid var(--border); border-radius:var(--radius-md); background:var(--surface); color:var(--text); font:inherit; } .field input[aria-invalid="true"] { border-color:#b91c1c; }
    .error { display:flex; gap:6px; margin:0; color:#b91c1c; font-size:.76rem; } .error span { display:grid; place-items:center; width:16px; height:16px; flex:none; border-radius:50%; background:#b91c1c; color:#fff; font-size:.65rem; font-weight:800; }
    .badge { display:inline-block; padding:4px 9px; border-radius:999px; background:color-mix(in srgb,var(--brand) 16%,var(--surface)); color:var(--brand); font-size:.72rem; font-weight:700; }
  }
  @layer utilities { .sr-only { position:absolute; width:1px; height:1px; overflow:hidden; clip-path:inset(50%); white-space:nowrap; } }
</style>
```

The dark panel is a local theme: `.theme-dark` sits on the article and remaps the tokens for that subtree only. The rest of the page follows the operating-system preference through the `prefers-color-scheme` block. That is the whole theme model in one page.

> **In the wild:** Design systems fail more often from too many options than from too few. A button with twelve variants, six radii and four shadows is not flexible; it is a set of decisions nobody can remember. Start with a small contract and add a variant only when a real screen needs it.

## Recap

- Tokens name decisions. Components consume semantic tokens, not raw hex values.
- `@layer` sets cascade order once; unlayered CSS still wins, so keep the system inside layers.
- Themes remap tokens. `prefers-color-scheme` is the default; `.theme-dark` is an explicit override.
- Spacing, radius, shadow and type need small scales, not unlimited choices.
- Buttons need variants with equal geometry, a visible `:focus-visible` ring, and a real disabled state.
- Fields need a `<label>`, `aria-invalid`, `aria-describedby` and error text that says what to do.
- Cards and badges compose the same tokens; a badge is not a new color system.
- A responsive gallery can use `auto-fit` and `minmax` instead of a breakpoint for every column count.
- Test computed colors, focusability and contrast. A design system that only looks right in light mode is half a system.

**Up next:** the final checkpoint. You will review the cascade, layout, motion, accessibility and the two capstones, then take the course exam.
