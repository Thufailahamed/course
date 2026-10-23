Colour is the first thing a page says and the last thing teams systematise. A brand palette arrives as a folder of hex codes, gets sprinkled through components, and six months later nobody can change the warning colour without breaking a checkout badge. Dark mode makes the problem visible: the same hex that looked confident on white turns into a muddy smudge on near-black, and the “inverted” theme looks like a photograph negative.

The fix is two ideas working together. A **perceptual colour space** lets you build scales where equal steps look equal. A **semantic token layer** lets components ask for “surface” and “text” instead of memorising a hex value. Contrast is the constraint that keeps both honest. Once those three are in place, dark mode is a token swap rather than a second stylesheet.

## Colour spaces: why `hsl` lies

Hex, `rgb()` and `hsl()` all describe colours in sRGB. They are precise, but they are not perceptually uniform. In HSL, lightness is a mathematical coordinate, not a measure of how bright the colour looks. `hsl(60 100% 50%)` is a luminous yellow; `hsl(240 100% 50%)` at the same lightness is a deep blue that reads much darker. Build a scale by changing `l` and the steps will feel uneven, especially across hues.

`oklch()` is built on perceptual lightness. The three coordinates are lightness (`0`–`1`), chroma (roughly, colourfulness) and hue angle. Two colours with the same `L` look similarly light, even when their hues are far apart. That makes it a better space for generating tints, shades and hover states:

```css
:root {
  --brand: oklch(0.62 0.14 180);
  --brand-hover: oklch(from var(--brand) calc(l - 0.08) c h);
  --brand-soft: oklch(from var(--brand) 0.94 calc(c * 0.35) h);
}
```

The `from` syntax is **relative colour syntax**: it takes an existing colour and lets you adjust its channels. It is supported in current Chrome, Safari and Firefox; if you need older browsers, generate the same values at build time or provide a fallback declaration before the relative one. `color-mix(in oklch, var(--brand), white 80%)` is the other useful primitive for tints without a preprocessor.

```html run
<div class="swatches">
  <div class="swatch hsl-1"><span>hsl 220</span></div>
  <div class="swatch hsl-2"><span>hsl 20</span></div>
  <div class="swatch hsl-3"><span>hsl 140</span></div>
  <div class="swatch ok-1"><span>oklch 250</span></div>
  <div class="swatch ok-2"><span>oklch 30</span></div>
  <div class="swatch ok-3"><span>oklch 140</span></div>
</div>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .swatches { display: grid; grid-template-columns: repeat(3, 1fr); gap: .75rem; max-width: 42rem; margin: 0 auto; }
  .swatch { display: grid; place-items: end start; min-height: 110px; padding: .75rem; border-radius: 12px; color: #fff; font-size: .8rem; font-weight: 700; }
  .hsl-1 { background: hsl(220 80% 55%); }
  .hsl-2 { background: hsl(20 80% 55%); }
  .hsl-3 { background: hsl(140 80% 55%); }
  .ok-1 { background: oklch(0.62 0.16 250); }
  .ok-2 { background: oklch(0.62 0.16 30); }
  .ok-3 { background: oklch(0.62 0.16 140); }
</style>
```

The top row is HSL at a constant lightness; the bottom row is OKLCH at a constant `L`. The bottom row reads as one family. The top row does not: the yellow-green is much lighter than the blue, even though the numbers claim otherwise. That is the whole argument for perceptual spaces in one image.

> **Under the hood:** `oklch()` can describe colours outside sRGB. On a wide-gamut display, a high-chroma value may render more vividly than the same value on an sRGB screen. Browsers gamut-map out-of-range colours rather than clipping them, so the result stays usable, but “exact” brand matching still belongs in a calibrated colour pipeline, not in a CSS variable.

## Semantic tokens, not colour names

A design system needs three layers, not one:

1. **Primitives** describe what a colour is: `--teal-700`, `--slate-50`, `--amber-500`.
2. **Semantic tokens** describe what a colour does: `--color-bg`, `--color-surface`, `--color-text`, `--color-text-muted`, `--color-border`, `--color-accent`, `--color-danger`, `--color-focus`.
3. **Component tokens** are optional aliases for a single component: `--button-bg`, `--button-fg`.

Components consume semantic tokens. They never reach for a primitive directly, and they never hard-code a hex. The theme changes the semantic values; the component rules stay still. This is what makes dark mode a ten-line change instead of an audit.

```html run
<div class="themes">
  <section class="theme">
    <p class="label">Light theme</p>
    <article class="card">
      <span class="eyebrow">Revenue</span>
      <strong>$48,210</strong>
      <p>Up 12.4% from last month.</p>
    </article>
  </section>
  <section class="theme" data-theme="dark">
    <p class="label">Dark theme</p>
    <article class="card">
      <span class="eyebrow">Revenue</span>
      <strong>$48,210</strong>
      <p>Up 12.4% from last month.</p>
    </article>
  </section>
</div>

<style>
  :root {
    --bg: #f8fafc; --surface: #ffffff;
    --text: #0f172a; --muted: #475569; --border: #e2e8f0;
    --accent: #0f766e;
  }
  [data-theme="dark"] {
    --bg: #0b1020; --surface: #111827;
    --text: #f8fafc; --muted: #cbd5e1; --border: #334155;
    --accent: #5eead4;
  }
  body { margin: 0; padding: 2rem; background: #e2e8f0; font-family: system-ui, sans-serif; }
  .themes { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1rem; max-width: 42rem; margin: 0 auto; }
  .theme { padding: 1.25rem; border-radius: 16px; background: var(--bg); color: var(--text); }
  .label { margin: 0 0 .75rem; color: var(--muted); font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  .card { display: grid; gap: .35rem; padding: 1.25rem; border: 1px solid var(--border); border-radius: 12px; background: var(--surface); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 1.9rem; letter-spacing: -.03em; }
  .card p { margin: 0; color: var(--muted); font-size: .9rem; }
</style>
```

A nested `data-theme="dark"` on the second section redefines the tokens for that subtree. Custom properties inherit, so every descendant resolves `var(--surface)` against the nearest definition. That property is why theme scoping works on a component preview, a settings panel, or a single demo card — not just the whole document.

> **Pitfall:** Do not mix token layers. A component that uses `var(--slate-900)` for text cannot be themed by changing `--color-text`; it will stay dark in dark mode. The primitive is allowed to exist, but components should not know its name.

## Contrast is luminance, not hue

WCAG contrast is a ratio between relative luminance values, from 1:1 (identical) to 21:1 (black on white). The thresholds depend on the size and weight of the text:

| Content | AA minimum | AAA minimum |
|---|---|---|
| Normal text | 4.5:1 | 7:1 |
| Large text (24px, or 18.66px bold) | 3:1 | 4.5:1 |
| Icons, focus rings, control boundaries | 3:1 | — |

The formula is `(L1 + 0.05) / (L2 + 0.05)`, where `L1` is the lighter relative luminance. You do not need to compute it by hand; every browser's DevTools shows the ratio for a selected text colour, and the `assertColor` helper in this course checks the computed value. What you do need is the habit of checking the **composited** colour. Text over a translucent surface is not contrasting against the token you wrote; it is contrasting against whatever ends up behind it.

```html run
<div class="badges">
  <p class="badge pass"><span aria-hidden="true">✓</span> Paid · 4.86:1</p>
  <p class="badge large"><span aria-hidden="true">✓</span> Large label · 4.38:1</p>
  <p class="badge fail"><span aria-hidden="true">!</span> Review · 2.07:1</p>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badges { display: grid; gap: .75rem; max-width: 26rem; margin: 0 auto; }
  .badge { display: flex; align-items: center; gap: .5rem; margin: 0; padding: .65rem .85rem; border-radius: 10px; font-weight: 650; }
  .pass { background: #ccfbf1; color: #0f766e; }
  .large { background: #ffedd5; color: #b45309; font-size: 20px; font-weight: 700; }
  .fail { background: #fffbeb; color: #f59e0b; }
</style>
```

The first badge passes AA for normal text. The second is large and bold, so 4.38:1 clears the 3:1 large-text threshold — but only because of its size and weight. The third fails even the large-text threshold. A colour can feel “warm” or “on brand” and still be unreadable; contrast does not negotiate with taste.

> **Tip:** Placeholder text is text. It needs 4.5:1 against the field background, not the faint grey that most browsers default to. If the placeholder is the only hint, fix the contrast and add a real label; if it is an example, make it optional and keep it readable.

## Dark mode without a second design

There are two related mechanisms. `prefers-color-scheme` reads the operating-system preference. A class or `data-theme` attribute lets the product override it. Use both: the media query provides a sensible default, and the attribute supports an explicit choice.

```css
:root {
  color-scheme: light;
  --bg: #f8fafc;
  --surface: #ffffff;
  --text: #0f172a;
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    color-scheme: dark;
    --bg: #0b1020;
    --surface: #111827;
    --text: #f8fafc;
  }
}

[data-theme="dark"] {
  color-scheme: dark;
  --bg: #0b1020;
  --surface: #111827;
  --text: #f8fafc;
}
```

The `:not([data-theme="light"])` guard is what allows a user on a dark OS to force the light theme. Without it, the media rule would keep winning and the toggle would only work in one direction. The explicit `[data-theme="dark"]` rule handles the opposite case: a light OS with a dark preference stored by the product.

`color-scheme` is not decoration. It tells the browser which palette to use for scrollbars, form controls, spellcheck underlines and the canvas behind the page. Set it alongside your tokens, or a dark page will still have a white scrollbar and white native inputs.

> **Pitfall:** `:root` and an attribute selector can have the same specificity. Order matters. Put the explicit theme rules after the media query, and test both directions: light OS + dark attribute, and dark OS + light attribute. A theme that only works in the direction you developed it is a theme with a bug.

## Surfaces and shadows in the dark

Light interfaces create depth with shadows. Dark interfaces cannot rely on the same trick: a black shadow on a near-black background is invisible. Elevation in dark mode comes from **lighter surfaces plus borders**, with a tinted shadow as a subtle finishing touch. The higher the surface, the lighter it gets.

Do not use pure black for the page or pure white for the text. Pure black makes every border and shadow disappear; pure white on black produces halation, a glowing edge that makes long text tiring. A near-black with a blue cast and an off-white with a little warmth read as designed rather than default.

```html run
<div class="dark-room">
  <article class="surface one">
    <span>Surface 1</span>
    <p>Page-level cards sit closest to the background.</p>
  </article>
  <article class="surface two">
    <span>Surface 2</span>
    <p>Popovers and menus lift one step.</p>
  </article>
  <article class="surface three">
    <span>Surface 3</span>
    <p>Dialogs and command palettes lift again.</p>
  </article>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #0b1020; font-family: system-ui, sans-serif; color: #e5e7eb; }
  .dark-room { display: grid; gap: 1rem; max-width: 38rem; margin: 0 auto; }
  .surface { padding: 1.1rem 1.25rem; border: 1px solid #26324a; border-radius: 14px; }
  .surface span { font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; color: #94a3b8; }
  .surface p { margin: .35rem 0 0; color: #cbd5e1; line-height: 1.55; }
  .one { background: #111827; box-shadow: 0 12px 28px -20px rgb(2 6 23 / .9); }
  .two { background: #172033; box-shadow: 0 18px 36px -22px rgb(2 6 23 / .95); }
  .three { background: #1e293b; box-shadow: 0 24px 48px -24px rgb(2 6 23 / 1); }
</style>
```

The shadow is tinted with the background hue (`rgb(2 6 23 / …)`), not pure black. It is quiet, but it keeps the card from looking pasted on. The border does most of the separation work. This is the opposite of light mode, where the shadow carries the depth and the border is often optional.

Saturated accents also need recalibration. A deep teal that looks rich on white can vibrate against a dark surface, while a lighter, less chromatic version reads as the same brand colour. OKLCH makes that adjustment mechanical: raise `L`, lower `C`, keep `H`. The dark theme's `--accent` in the token example does exactly that.

## Colour is not the only signal

Roughly one in twelve men and a smaller share of women have some form of colour-vision deficiency. Red-green is the most common; blue-yellow is rarer; complete colour blindness is rarer still. The practical consequence is not “red and green look identical to everyone”. It is that a red dot and a green dot can become the same brownish dot, especially at small sizes, and a link that is distinguished only by hue can disappear into body text.

Never use colour alone to carry status, required-ness, error or selection. Pair it with at least one other channel:

- An icon or shape: ✓, !, ×, a filled versus outlined dot.
- Text: “Paid”, “Overdue”, “Optional”.
- Position: the error message below the field, the selected tab with an underline.
- Pattern or texture: for charts, not for body text.

```html run
<ul class="orders">
  <li class="ok"><span class="mark" aria-hidden="true">✓</span> Delivered</li>
  <li class="warn"><span class="mark" aria-hidden="true">!</span> Delayed</li>
  <li class="bad"><span class="mark" aria-hidden="true">×</span> Cancelled</li>
</ul>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .orders { display: grid; gap: .6rem; max-width: 24rem; margin: 0 auto; padding: 0; list-style: none; }
  .orders li { display: flex; align-items: center; gap: .65rem; padding: .75rem .9rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; font-weight: 650; }
  .mark { display: grid; place-items: center; width: 1.3rem; height: 1.3rem; border-radius: 50%; font-size: .75rem; }
  .ok .mark { background: #dcfce7; color: #166534; }
  .warn .mark { background: #fef3c7; color: #92400e; }
  .bad .mark { background: #fee2e2; color: #991b1b; }
</style>
```

Remove the marks and the list still says “Delivered”, “Delayed” and “Cancelled” in words. Remove the words and the marks still carry meaning. That redundancy is the point. A colour-blind user, a user in grayscale, and a user reading in bright sunlight all get the same answer.

> **In the wild:** Forced-colours mode replaces your palette with the user's system colours. `box-shadow` and background images often disappear, while `outline` and borders remain. This is why a focus ring made only of `box-shadow` can vanish for the people who need it most. Keep a real `outline` as the primary indicator.

## Predict: which token wins?

The document has `data-theme="dark"` on the wrapper. The operating system is in light mode. Read the cascade before you choose.

```html predict id=dark-token-cascade title="Which surface wins in dark mode?"
<div class="app" data-theme="dark">
  <article class="card">
    <span>Revenue</span>
    <strong>$48,210</strong>
  </article>
</div>

<style>
  :root { --surface: #ffffff; --text: #0f172a; }
  @media (prefers-color-scheme: dark) {
    :root { --surface: #111827; --text: #e5e7eb; }
  }
  [data-theme="dark"] { --surface: #1e293b; --text: #f8fafc; }
  body { margin: 0; padding: 3rem 1.5rem; background: #e2e8f0; font-family: system-ui, sans-serif; }
  .app { max-width: 26rem; margin: 0 auto; padding: 1.25rem; border-radius: 16px; background: var(--surface); }
  .card { display: grid; gap: .35rem; padding: 1.25rem; border: 1px solid #334155; border-radius: 12px; background: var(--surface); color: var(--text); }
  span { font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; opacity: .7; }
  strong { font-size: 1.8rem; }
</style>
--- options
* `#1e293b`, because the explicit dark theme overrides the root tokens
`#ffffff`, because the operating system is in light mode
`#111827`, because the media query always wins in dark mode
Transparent, because no token is defined on the card
--- explain
The media query does not match on a light OS, so the root stays `#ffffff`. The `[data-theme="dark"]` rule then redefines the tokens on the wrapper, and the card inherits them: `#1e293b`. If the OS were dark, both the media rule and the attribute rule would apply; the attribute rule comes later and wins the tie, so the explicit choice still takes precedence.
```

## Testing both themes

A theme is a state, so it needs state testing, not a screenshot of the default.

1. **DevTools → Rendering → Emulate CSS media feature `prefers-color-scheme`.** Check light and dark without changing your OS.
2. **Toggle the attribute in the console.** `document.documentElement.dataset.theme = "dark"` is usually enough. Check the opposite override too: dark OS with `data-theme="light"`.
3. **Check contrast in both.** A token pair that passes in light can fail in dark, especially muted text and borders. Use the DevTools contrast readout on real text, not on the token swatch.
4. **Check non-text contrast.** Focus rings, checkbox borders, input boundaries and icons need 3:1 against their adjacent colours. A 3:1 focus ring on a 3:1 border is not automatically visible; it needs to separate from both the control and the page.
5. **Check forced colours and grayscale.** In DevTools, emulate `forced-colors: active` and check that controls, focus and status still make sense. Then use a colour-blindness simulator or a grayscale filter to see whether any status is carried by hue alone.
6. **Read the computed values.** In a test, toggle the theme attribute and assert the resolved `background-color` and `color`, not the custom-property string. Tokens are inputs; computed colours are the output users see.

## Challenge: a card that changes its clothes

Build the token layer for a small analytics card. The light theme uses `#ffffff` for the surface, `#0f172a` for the text and `#0f766e` for the accent. A `data-theme="dark"` attribute on the root should switch the surface to `#111827`, the text to `#f8fafc`, the accent to `#5eead4`, and set `color-scheme: dark` so native UI follows. The card must consume only semantic tokens.

```html exercise id=theme-token-card title="A card that changes its clothes"
<article class="card">
  <span class="eyebrow">Revenue</span>
  <strong>$48,210</strong>
  <p>Up 12.4% from last month.</p>
</article>

<style>
  :root {
    color-scheme: light;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
    --accent: #0f766e;
  }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: var(--surface); color: var(--text); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 2rem; letter-spacing: -.03em; }
  p { margin: 0; color: var(--muted); line-height: 1.55; }
  /* TODO: add a data-theme="dark" token block. */
</style>
--- solution
<article class="card">
  <span class="eyebrow">Revenue</span>
  <strong>$48,210</strong>
  <p>Up 12.4% from last month.</p>
</article>

<style>
  :root {
    color-scheme: light;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
    --accent: #0f766e;
  }
  [data-theme="dark"] {
    color-scheme: dark;
    --surface: #111827;
    --text: #f8fafc;
    --muted: #cbd5e1;
    --accent: #5eead4;
  }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: var(--surface); color: var(--text); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 2rem; letter-spacing: -.03em; }
  p { margin: 0; color: var(--muted); line-height: 1.55; }
</style>
--- test
assertColor(".card", "background-color", "#ffffff", "The light theme surface should be #ffffff.");
assertColor(".card", "color", "#0f172a", "The light theme text should be #0f172a.");
assertColor(".eyebrow", "color", "#0f766e", "The light theme accent should come from a semantic token, not a hard-coded hex.");
document.documentElement.setAttribute("data-theme", "dark");
assertColor(".card", "background-color", "#111827", "With data-theme=\"dark\", the card should use the dark surface #111827.");
assertColor(".card", "color", "#f8fafc", "With the dark theme, the text should switch to #f8fafc instead of staying dark.");
assertColor(".eyebrow", "color", "#5eead4", "The accent also needs a dark-theme value; deep teal loses contrast on a dark surface.");
const scheme = getComputedStyle(document.documentElement).colorScheme;
assert(scheme.includes("dark"), "Set color-scheme: dark in the dark theme so scrollbars and native controls follow it.");
--- hint
Add `[data-theme="dark"] { … }` after `:root`. Redefine `--surface`, `--text`, `--muted` and `--accent`, and set `color-scheme: dark`.
--- hint
The card already reads `var(--surface)`, `var(--text)` and `var(--accent)`. You only need the token block; do not add new component colour declarations.
```

The test changes the attribute and reads the computed colours, so it verifies the cascade rather than the presence of a particular custom property. That is the useful level of abstraction: a component may rename its tokens tomorrow, but “the card is light on light and dark on dark” is the behaviour the user sees.

## Challenge: a badge you can actually read

This status badge fails contrast badly. Choose a foreground colour that reaches at least 4.5:1 against its existing background, while keeping the visible label. The badge already uses text, so the status is not conveyed by colour alone; the job here is legibility.

```html exercise id=status-badge-contrast title="A badge you can actually read"
<p class="badge">Pending review</p>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badge { display: inline-block; margin: 0; padding: .4rem .7rem; border-radius: 999px; background: #fef3c7; color: #f59e0b; font-size: .85rem; font-weight: 700; }
</style>
--- solution
<p class="badge">Pending review</p>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badge { display: inline-block; margin: 0; padding: .4rem .7rem; border-radius: 999px; background: #fef3c7; color: #92400e; font-size: .85rem; font-weight: 700; }
</style>
--- test
const badge = query(".badge");
assertText(".badge", "Pending review", "Keep the visible status label.");
function luminance(rgb) {
  const channels = rgb.map((value) => {
    const c = value / 255;
    return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
function ratio(foreground, background) {
  const a = luminance(foreground);
  const b = luminance(background);
  return (Math.max(a, b) + 0.05) / (Math.min(a, b) + 0.05);
}
function channels(value) {
  return getComputedStyle(badge)[value].match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
}
const contrast = ratio(channels("color"), channels("backgroundColor"));
assert(contrast >= 4.5, `The badge text is only ${contrast.toFixed(2)}:1 against its background. Normal text needs at least 4.5:1.`);
--- hint
The background is already light amber. You need a much darker foreground; the current amber is too close to the background in luminance.
--- hint
Try a deep brown such as `#92400e`. That computes to roughly 6.4:1 against `#fef3c7` — comfortably above 4.5:1 without changing the background.
```

## Debug: the dark theme with light-theme text

The dark surfaces are in place, but the text was never migrated. The headings and paragraphs still carry the light theme's near-black values, so they almost disappear against the dark card. Fix the theme so every piece of text is readable, and set `color-scheme` for native UI.

```html debug id=dark-inherited-text title="The dark theme with light-theme text"
<article class="card">
  <span class="eyebrow">Trail status</span>
  <h2>North ridge open</h2>
  <p>The lower path is muddy after rain. The ridge is dry and clear.</p>
</article>

<style>
  :root { color-scheme: light; }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; color: #0f172a; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #ffffff; }
  .eyebrow { color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.4rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.6; }
  [data-theme="dark"] body { background: #0b1020; }
  [data-theme="dark"] .card { background: #111827; border-color: #334155; }
</style>
--- solution
<article class="card">
  <span class="eyebrow">Trail status</span>
  <h2>North ridge open</h2>
  <p>The lower path is muddy after rain. The ridge is dry and clear.</p>
</article>

<style>
  :root { color-scheme: light; }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; color: #0f172a; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #ffffff; }
  .eyebrow { color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.4rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.6; }
  [data-theme="dark"] { color-scheme: dark; }
  [data-theme="dark"] body { background: #0b1020; }
  [data-theme="dark"] .card { background: #111827; border-color: #334155; }
  [data-theme="dark"] .eyebrow { color: #5eead4; }
  [data-theme="dark"] h2 { color: #f8fafc; }
  [data-theme="dark"] p { color: #cbd5e1; }
</style>
--- test
document.documentElement.setAttribute("data-theme", "dark");
const card = query(".card");
assertColor(".card", "background-color", "#111827", "The dark card should use the dark surface.");
function luminance(value) {
  const match = value.match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
  const channels = match.map((channel) => {
    const c = channel / 255;
    return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
function contrastOf(selector) {
  const fg = luminance(getComputedStyle(query(selector)).color);
  const bg = luminance(getComputedStyle(card).backgroundColor);
  return (Math.max(fg, bg) + 0.05) / (Math.min(fg, bg) + 0.05);
}
const heading = contrastOf(".card h2");
const body = contrastOf(".card p");
assert(heading >= 4.5, `The dark-theme heading is only ${heading.toFixed(2)}:1 against the card. Give it a light text colour.`);
assert(body >= 4.5, `The dark-theme paragraph is only ${body.toFixed(2)}:1 against the card. Do not leave light-theme muted text in the dark theme.`);
const scheme = getComputedStyle(document.documentElement).colorScheme;
assert(scheme.includes("dark"), "Set color-scheme: dark on the dark theme.");
--- hint
The card background changes, but `h2` and `p` have explicit light-theme colours. Inheritance alone cannot fix an explicit value.
--- hint
Add overrides such as `[data-theme="dark"] h2 { color: #f8fafc; }` and `[data-theme="dark"] p { color: #cbd5e1; }`. Set `[data-theme="dark"] { color-scheme: dark; }` too.
```

> **Pitfall:** A theme audit that only checks the page background will miss exactly this bug. Text colours, borders, icons, disabled states and focus rings each have their own contrast requirement. Toggle the theme and walk the page with the contrast checker, not just the hero section.

## Recap

- `hsl` is intuitive but not perceptually uniform. `oklch()` gives you equal-looking steps and predictable hover and tint scales.
- Keep primitives separate from semantic tokens. Components ask for `--color-surface`, not `--slate-900`, so a theme can change underneath them.
- AA is 4.5:1 for normal text, 3:1 for large text and non-text UI. Contrast is computed against the final composited background, not the token in isolation.
- Support both `prefers-color-scheme` and an explicit `data-theme`, with a guard that lets either override win. Set `color-scheme` so native UI follows.
- Dark elevation comes from lighter surfaces and borders; shadows are tinted and quiet. Avoid pure black and pure white for large areas.
- Never carry status by hue alone. Pair colour with text, icons, position or pattern, and check both themes in forced-colours and grayscale.

**Up next:** performance as a design constraint — critical CSS, font loading, responsive images and the layout shifts that make a fast page feel slow.
