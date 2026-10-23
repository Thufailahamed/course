A button that does nothing on hover feels broken. A form field with no visible focus ring is unusable if you cannot use a mouse. Interaction states are how the interface answers the person using it. Hover says *I heard you*. Focus says *you are here*. Active says *the press registered*. Disabled says *not this one, not yet*.

This lesson turns those answers into a small, consistent system: hover, focus, active and disabled states; transitions that make changes legible rather than sluggish; movement with `transform` instead of layout properties; and respect for people who ask their operating system for less motion. The goal is restraint: every effect should have a job.

## States are the interface talking back

A control has a **default** state and several temporary ones, each triggered differently and distinct for a reason.

| State | Trigger | What it should communicate |
|---|---|---|
| Default | Nothing happening | This is available |
| `:hover` | Pointer over the element | This is the thing you are about to act on |
| `:focus` | Keyboard focus, or programmatic focus | Keyboard input will go here |
| `:focus-visible` | Focus where a visible indicator is warranted | The same, without a ring on every mouse click |
| `:active` | Mouse button or key held down | The press has been received |
| `:disabled` | The `disabled` attribute is present | This action is unavailable |

Hover is a convenience, never the only route; a hover-only menu is unusable on a phone. Focus is not optional: if someone tabs to a link, they must see where they are. Active is brief, but it separates a physical-feeling button from a painted rectangle. Disabled promises the control will not fire, and must look unavailable without becoming unreadable.

Run this state system. Hover the first button, press it, then tab through the controls:

```html run
<div class="actions">
  <button class="btn">Save changes</button>
  <button class="btn btn-quiet" disabled>Publish</button>
</div>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .actions { display: flex; gap: 0.75rem; }
  .btn {
    padding: 0.7rem 1.15rem;
    border: 1px solid #0f172a;
    border-radius: 10px;
    background: #0f172a;
    color: #fff;
    font: inherit;
    font-weight: 600;
    cursor: pointer;
    transition: transform 180ms ease, box-shadow 180ms ease, background 180ms ease;
  }
  .btn:hover { transform: translateY(-2px); box-shadow: 0 8px 18px rgb(15 23 42 / 0.18); }
  .btn:active { transform: translateY(0) scale(0.98); box-shadow: none; }
  .btn:focus-visible { outline: 3px solid #0d9488; outline-offset: 3px; }
  .btn:disabled { cursor: not-allowed; opacity: 0.45; transform: none; box-shadow: none; }
  .btn-quiet { background: #fff; color: #0f172a; border-color: #cbd5e1; }
</style>
```

Three rules do most of the work. `cursor: pointer` tells a mouse user the element is clickable. `transition` makes the change between states readable rather than instantaneous. `:focus-visible` draws a ring only when the browser believes a visible indicator is needed, which usually means keyboard navigation. The disabled button keeps its shape and label but loses its weight; a control that vanishes is harder to understand than one that is clearly unavailable.

Order matters. These selectors have equal specificity, so when two states apply at once, the later rule wins. The order above — base, hover, active, focus, disabled — is deliberate: disabled stays disabled-looking while hovered, and press overrides the hover lift.

```html predict id=hover-and-focus title="Hovered and focused at the same time"
<style>
  .btn { background: #0f172a; color: white; padding: 12px 20px; border: 0; }
  .btn:hover { background: #0f766e; }
  .btn:focus { background: #b45309; }
</style>
<button class="btn">Book a table</button>
--- options
* The background is #b45309: both states match, and the later :focus rule wins
The background is #0f766e: hover is more specific than focus
The background is #0f172a: the base rule always wins
The two backgrounds blend into a third colour
--- explain
Both pseudo-classes match at the same time, and they have equal specificity — one class plus one pseudo-class. The cascade therefore falls back to source order, and `:focus` comes last, so its background wins. The other properties still merge: if `:hover` set a shadow and `:focus` did not, the shadow would remain. This is why the order of your state rules is part of the design, not an accident. Note that this example uses `:focus`, which matches mouse focus too. `:focus-visible` would behave differently: a mouse click on the button would normally not match it.
```

> **Under the hood:** `:focus-visible` is a heuristic, not a different kind of focus. The element is focused either way. The browser decides whether drawing attention to that focus is helpful. Text inputs usually match `:focus-visible` even when clicked, because the user is about to type. A button clicked with a mouse usually does not, because the user already knows where they clicked. Keyboard focus almost always matches.

## Hover should suggest, not surprise

A hover state previews an action. On a card, a small lift and a deeper shadow say *this whole surface is one thing, and it is clickable*. On a link, a colour change and an underline say *this word goes somewhere*. Neither needs drama: two to six pixels is enough. A card that jumps across the screen makes the pointer feel unstable.

This card lifts as a unit. Its illustration is inline SVG, so there is nothing to load. Hover it, then tab to the link inside:

```html run
<article class="card">
  <div class="art" aria-hidden="true">
    <svg viewBox="0 0 320 160" role="presentation">
      <rect width="320" height="160" fill="#ccfbf1"/>
      <path d="M0 132 L90 58 L150 108 L214 44 L320 120 V160 H0Z" fill="#0f766e"/>
      <circle cx="258" cy="42" r="18" fill="#fbbf24"/>
    </svg>
  </div>
  <div class="body">
    <p class="eyebrow">Field guide</p>
    <h2>Six walks near Sheffield</h2>
    <a href="#walks">Open the guide <span aria-hidden="true">→</span></a>
  </div>
</article>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .card {
    max-width: 22rem; overflow: hidden; border: 1px solid #e2e8f0; border-radius: 16px;
    background: #fff; transition: transform 240ms cubic-bezier(.2,.8,.2,1), box-shadow 240ms ease;
  }
  @media (hover: hover) and (pointer: fine) {
    .card:hover { transform: translateY(-6px); box-shadow: 0 18px 40px rgb(15 23 42 / 0.16); }
  }
  .card:focus-within { outline: 3px solid #0d9488; outline-offset: 3px; }
  .art svg { display: block; width: 100%; height: auto; }
  .body { padding: 1.1rem 1.25rem 1.35rem; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h2 { margin: 0 0 0.9rem; font-size: 1.25rem; }
  a { color: #0f172a; font-weight: 650; text-decoration-thickness: 1px; text-underline-offset: 3px; }
  a:hover { color: #0f766e; }
</style>
```

Two details make the card solid. The transition sits on the card's **base** rule, not on `:hover`, so the lift is smooth both entering and leaving. And the focus ring sits on the card rather than the link: `:focus-within` draws it when anything inside receives keyboard focus, which is easier to see than an underline on one word.

> **Pitfall:** Do not put essential information behind hover. A hover-only tooltip is invisible to touch users and keyboard navigators. If the information matters, put it in the page or reveal it on focus too.

Wrapping the lift in `@media (hover: hover) and (pointer: fine)` is a small act of care. Touch screens sometimes keep a hover state after a tap, leaving a card raised until the user taps elsewhere; the query checks for a precise pointer before applying a hover-only effect.

## Challenge: lift a card with intent

This project card already has its artwork and typography. Add a transition on `transform` and `box-shadow`, then a `:hover` state that lifts the card by four pixels and gives it a soft shadow. Keep the movement subtle.

```html exercise id=card-lift-transition title="Give the project card a hover lift"
<article class="card">
  <div class="art" aria-hidden="true">
    <svg viewBox="0 0 320 140" role="presentation">
      <rect width="320" height="140" fill="#e2e8f0"/>
      <path d="M0 118 L76 54 L132 96 L196 38 L320 110 V140 H0Z" fill="#475569"/>
    </svg>
  </div>
  <div class="body">
    <p class="tag">Field note</p>
    <h2>Three bothies, one weekend</h2>
    <p>A short guide to sleeping cheaply above the tree line.</p>
  </div>
</article>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { max-width: 23rem; overflow: hidden; border: 1px solid #e2e8f0; border-radius: 18px; background: #fff; }
  .art svg { display: block; width: 100%; height: auto; }
  .body { padding: 1.25rem; }
  .tag { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  h2 { margin: 0 0 0.5rem; font-size: 1.3rem; }
  p:last-child { margin: 0; color: #475569; line-height: 1.55; }
  /* TODO: transition transform and box-shadow on .card,
     then add a .card:hover rule that lifts it and adds a shadow */
</style>
--- solution
<article class="card">
  <div class="art" aria-hidden="true">
    <svg viewBox="0 0 320 140" role="presentation">
      <rect width="320" height="140" fill="#e2e8f0"/>
      <path d="M0 118 L76 54 L132 96 L196 38 L320 110 V140 H0Z" fill="#475569"/>
    </svg>
  </div>
  <div class="body">
    <p class="tag">Field note</p>
    <h2>Three bothies, one weekend</h2>
    <p>A short guide to sleeping cheaply above the tree line.</p>
  </div>
</article>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    max-width: 23rem; overflow: hidden; border: 1px solid #e2e8f0; border-radius: 18px;
    background: #fff; transition: transform 220ms ease, box-shadow 220ms ease;
  }
  .card:hover { transform: translateY(-4px); box-shadow: 0 14px 30px rgb(15 23 42 / 0.12); }
  .art svg { display: block; width: 100%; height: auto; }
  .body { padding: 1.25rem; }
  .tag { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  h2 { margin: 0 0 0.5rem; font-size: 1.3rem; }
  p:last-child { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- test
function allRules() {
  const out = [];
  for (const sheet of document.styleSheets) {
    const walk = (rules) => {
      for (const rule of rules) {
        if (rule.selectorText) out.push(rule);
        if (rule.cssRules) walk(rule.cssRules);
      }
    };
    walk(sheet.cssRules);
  }
  return out;
}
assertExists(".card", "Keep the card element");
const cardStyle = getComputedStyle(query(".card"));
assert(/transform/.test(cardStyle.transitionProperty), `The card should transition transform; it currently transitions "${cardStyle.transitionProperty}".`);
assert(/box-shadow/.test(cardStyle.transitionProperty), `The card should transition box-shadow; it currently transitions "${cardStyle.transitionProperty}".`);
assert(parseFloat(cardStyle.transitionDuration) >= 0.1, "The transition should last at least 0.1s so the lift is visible.");
const hover = allRules().find((rule) => rule.selectorText && /\.card:hover/.test(rule.selectorText));
assert(hover, "Add a .card:hover rule that changes the card.");
assert(/translateY/.test(hover.style.transform), "Lift the card with a translateY value on hover.");
assert(hover.style.boxShadow && hover.style.boxShadow !== "none", "Add a box-shadow on hover so the card separates from the page.");
--- hint
Put `transition` on `.card` itself, not on `.card:hover`, so the effect animates both entering and leaving the hover state.
--- hint
Use `transition: transform 220ms ease, box-shadow 220ms ease;` and a hover rule with `transform: translateY(-4px)` plus a shadow such as `0 14px 30px rgb(15 23 42 / 0.12)`.
```

## Focus is a promise you make to keyboard users

Every browser draws a focus indicator for a reason. Press Tab and the page moves a cursor that is invisible to a mouse user but essential to anyone who cannot use one. Removing it without a replacement is one of the most common accessibility failures on the web, and usually accidental: a designer finds the default outline ugly, adds `outline: none`, and never notices the page has become impossible to navigate.

The default outline is not beautiful, but it works. Replace it rather than removing it, and use `:focus-visible` so the ring appears for keyboard focus, not every mouse click:

```html run
<form class="panel">
  <h2>Trail notes, once a month</h2>
  <label for="email">Email address</label>
  <input id="email" type="email" placeholder="you@example.com">
  <button class="btn" type="submit">Subscribe</button>
  <p class="fine">No feed. <a href="#privacy">Read the privacy note</a>.</p>
</form>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .panel {
    max-width: 26rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px;
    background: #fff; transition: border-color 160ms ease, box-shadow 160ms ease;
  }
  .panel:focus-within { border-color: #0f766e; box-shadow: 0 0 0 4px rgb(15 118 110 / 0.12); }
  h2 { margin: 0 0 1rem; font-size: 1.25rem; }
  label { display: block; margin-bottom: 0.4rem; font-size: 0.85rem; font-weight: 650; }
  input {
    width: 100%; box-sizing: border-box; padding: 0.7rem 0.8rem; border: 1px solid #cbd5e1;
    border-radius: 8px; font: inherit; background: #f8fafc;
  }
  input:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; border-color: #0f766e; }
  .btn {
    margin-top: 0.75rem; padding: 0.7rem 1.1rem; border: 0; border-radius: 8px;
    background: #0f172a; color: #fff; font: inherit; font-weight: 650; cursor: pointer;
  }
  .btn:focus-visible, .fine a:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  .fine { margin: 0.9rem 0 0; color: #64748b; font-size: 0.82rem; }
  .fine a { color: #0f766e; }
</style>
```

Tab through this form after clicking outside it. The input, button and privacy link each get a thick teal ring with a three-pixel gap. That gap is `outline-offset`; it stops the ring from disappearing into a dark border. On a dark background, use a light ring, or a two-tone ring made from an outline plus a `box-shadow` in the opposite colour.

`:focus-within` is the group version. It styles an ancestor when a descendant has focus, letting the panel brighten when the user enters it. The panel border change is subtle and the input outline is strong; together they show *where* focus is without making the entire card flash.

> **Pitfall:** `outline: none` and `outline: 0` do the same damage. Written on `:focus` without a replacement, either one loses the page for keyboard users. If a custom ring is invisible on some background, fix the ring, not the focus.

## Debug: the link that lost its keyboard focus

This navigation works with a mouse: links turn teal and underline on hover. With a keyboard, nothing visible happens. Run it, press Tab a few times, find the rule that suppresses focus and restore a visible indicator.

```html debug id=link-keyboard-focus title="Restore the keyboard focus ring"
<nav class="links" aria-label="Lesson sections">
  <a class="link" href="#outline">Outline</a>
  <a class="link" href="#examples">Examples</a>
  <a class="link" href="#recap">Recap</a>
</nav>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .links { display: flex; gap: 1.5rem; }
  .link {
    color: #0f172a; font-weight: 600; text-decoration: none;
    transition: color 150ms ease;
  }
  .link:hover { color: #0f766e; text-decoration: underline; text-underline-offset: 4px; }
  .link:focus { outline: none; }
</style>
--- solution
<nav class="links" aria-label="Lesson sections">
  <a class="link" href="#outline">Outline</a>
  <a class="link" href="#examples">Examples</a>
  <a class="link" href="#recap">Recap</a>
</nav>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .links { display: flex; gap: 1.5rem; }
  .link {
    color: #0f172a; font-weight: 600; text-decoration: none;
    transition: color 150ms ease; border-radius: 2px;
  }
  .link:hover { color: #0f766e; text-decoration: underline; text-underline-offset: 4px; }
  .link:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
</style>
--- test
function allRules() {
  const out = [];
  for (const sheet of document.styleSheets) {
    const walk = (rules) => {
      for (const rule of rules) {
        if (rule.selectorText) out.push(rule);
        if (rule.cssRules) walk(rule.cssRules);
      }
    };
    walk(sheet.cssRules);
  }
  return out;
}
assertCount(".link", 3, "Keep all three navigation links");
for (const link of document.querySelectorAll(".link")) {
  assert(link.tabIndex >= 0, "Every link should stay reachable with the Tab key");
}
const rules = allRules();
const hover = rules.find((rule) => rule.selectorText && /\.link:hover/.test(rule.selectorText));
assert(hover, "Keep the hover state that already works.");
const focusRules = rules.filter((rule) => rule.selectorText && /:focus/.test(rule.selectorText));
const suppressed = focusRules.find((rule) =>
  rule.style.outlineStyle === "none" || rule.style.outline === "none" ||
  rule.style.outlineWidth === "0px" || rule.style.outline === "0"
);
assert(!suppressed, "A focus rule still switches the outline off. Remove it or replace it with a visible focus ring.");
const visible = focusRules.find((rule) => /:focus-visible/.test(rule.selectorText));
if (visible) {
  const hasOutline = visible.style.outlineStyle !== "none" && parseFloat(visible.style.outlineWidth) >= 2;
  const hasShadow = visible.style.boxShadow && visible.style.boxShadow !== "none";
  assert(hasOutline || hasShadow, "Your :focus-visible rule needs a ring at least 2px thick, or a strong box-shadow.");
}
--- hint
Hover is not the problem. Look for a rule that applies when the link has keyboard focus.
--- hint
Delete `.link:focus { outline: none; }`. That restores the browser's default ring. For a designed ring, replace it with `.link:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }`.
--- hint
Never remove a focus indicator without putting a visible one back. A safe pattern is to keep the `:focus` rule out of the stylesheet entirely and style `:focus-visible` instead.
```

## Transitions have four dials

A transition is four decisions, and each changes how the movement feels:

| Longhand | Example | What it controls |
|---|---|---|
| `transition-property` | `transform` | Which property animates |
| `transition-duration` | `180ms` | How long the change takes |
| `transition-timing-function` | `ease-out` | How the speed changes over time |
| `transition-delay` | `40ms` | How long to wait before starting |

The shorthand packs them in that order: `transition: transform 180ms ease-out 40ms;`. For several properties, separate the whole set with commas: `transition: transform 200ms ease, box-shadow 200ms ease;`. Use longhands when properties need different durations.

Duration is the dial people notice first. Under about 100ms the change feels instant; 150–250ms feels responsive but deliberate; beyond 400ms the interface feels like it is deliberating. A short delay can sequence several moving things, but on hover it usually reads as lag. Keep delays at zero unless they do real choreography.

Timing functions shape the speed. `ease-out` starts quickly and settles, suited to elements arriving under the pointer. `ease-in` starts slowly and accelerates, which can feel unresponsive on hover. A custom curve such as `cubic-bezier(.2, .8, .2, 1)` gives a crisp start and a soft landing. `linear` suits continuous progress, not buttons.

```html run
<p class="hint">Hover each chip. Same five-pixel lift, three different timings.</p>
<div class="row">
  <button class="chip chip-a">Fast · 120ms</button>
  <button class="chip chip-b">Standard · 220ms</button>
  <button class="chip chip-c">Delayed · 600ms + 120ms</button>
</div>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hint { margin: 0 0 1rem; color: #475569; font-size: 0.9rem; }
  .row { display: flex; flex-wrap: wrap; gap: 0.75rem; }
  .chip {
    padding: 0.75rem 1rem; border: 1px solid #cbd5e1; border-radius: 999px;
    background: #fff; color: #0f172a; font: inherit; font-weight: 600; cursor: pointer;
    transition-property: transform, background-color, border-color;
    transition-duration: 120ms;
    transition-timing-function: ease-out;
  }
  .chip:hover { transform: translateY(-5px); background: #ccfbf1; border-color: #0f766e; }
  .chip-b { transition-duration: 220ms; transition-timing-function: cubic-bezier(.2, .8, .2, 1); }
  .chip-c { transition-duration: 600ms; transition-delay: 120ms; transition-timing-function: linear; }
</style>
```

The first chip answers immediately, the second feels considered, and the third feels broken even though nothing is technically wrong: the user has moved on before the interface finishes.

> **Pitfall:** Avoid `transition: all`. It animates properties you did not intend, including ones that trigger layout. Name the properties, and if the list grows past three, ask whether all of them need to move.

## Challenge: a button that answers back

Build the interaction states for a primary button. It needs a pointer cursor, a transition on `transform` and `box-shadow`, a hover lift of a few pixels, a pressed state that settles back down, and a `:focus-visible` ring at least three pixels thick. Keep the timing between 150ms and 250ms.

```html exercise id=button-hover-focus title="Build a button with hover and focus states"
<button class="btn" type="button">Start the walk</button>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .btn {
    padding: 0.8rem 1.4rem;
    border: 0;
    border-radius: 999px;
    background: #0f172a;
    color: #fff;
    font: inherit;
    font-weight: 650;
  }
  /* TODO: add a pointer cursor, a transition, a hover lift,
     a pressed state and a visible :focus-visible ring */
</style>
--- solution
<button class="btn" type="button">Start the walk</button>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .btn {
    padding: 0.8rem 1.4rem;
    border: 0;
    border-radius: 999px;
    background: #0f172a;
    color: #fff;
    font: inherit;
    font-weight: 650;
    cursor: pointer;
    transition: transform 180ms ease, box-shadow 180ms ease;
  }
  .btn:hover { transform: translateY(-3px); box-shadow: 0 10px 22px rgb(15 23 42 / 0.2); }
  .btn:active { transform: translateY(0) scale(0.98); box-shadow: none; }
  .btn:focus-visible { outline: 3px solid #0d9488; outline-offset: 3px; }
</style>
--- test
function allRules() {
  const out = [];
  for (const sheet of document.styleSheets) {
    const walk = (rules) => {
      for (const rule of rules) {
        if (rule.selectorText) out.push(rule);
        if (rule.cssRules) walk(rule.cssRules);
      }
    };
    walk(sheet.cssRules);
  }
  return out;
}
assertExists(".btn", "Keep the button");
assertFocusable(".btn", "The button should be reachable with the Tab key.");
assertStyle(".btn", "cursor", "pointer", "A clickable button should show a pointer cursor.");
const style = getComputedStyle(query(".btn"));
assert(/transform/.test(style.transitionProperty), `Transition transform, not just "${style.transitionProperty}".`);
assert(parseFloat(style.transitionDuration) >= 0.15, "The transition should last at least 150ms.");
const rules = allRules();
const hover = rules.find((rule) => rule.selectorText && /\.btn:hover/.test(rule.selectorText));
assert(hover, "Add a .btn:hover rule.");
assert(/translateY/.test(hover.style.transform), "Lift the button with translateY on hover.");
const focus = rules.find((rule) => rule.selectorText && /\.btn:focus-visible/.test(rule.selectorText));
assert(focus, "Add a .btn:focus-visible rule so keyboard users can see where they are.");
const hasOutline = focus.style.outlineStyle !== "none" && parseFloat(focus.style.outlineWidth) >= 3;
const hasShadow = focus.style.boxShadow && focus.style.boxShadow !== "none";
assert(hasOutline || hasShadow, "The focus ring should be at least 3px thick, or a strong box-shadow.");
assert(!rules.some((rule) =>
  rule.selectorText && /:focus/.test(rule.selectorText) &&
  (rule.style.outline === "none" || rule.style.outlineStyle === "none")
), "Do not remove the focus outline without a replacement.");
--- hint
Start with `cursor: pointer;` and `transition: transform 180ms ease, box-shadow 180ms ease;` on `.btn`.
--- hint
The hover rule should set `transform: translateY(-3px)` and a shadow. The active rule can return to `translateY(0) scale(0.98)`.
--- hint
Use `.btn:focus-visible { outline: 3px solid #0d9488; outline-offset: 3px; }`. The offset keeps the ring clear of the button's edge.
```

## Transform moves paint, not the page

`transform` is the workhorse of interface motion because it does not change layout. `translateY(-4px)` shifts painted pixels without reflowing siblings. `margin-top: -4px` or `top: -4px` forces the browser to recalculate the layout, risking a stutter. `opacity` is equally cheap. `width`, `height`, `top` and `left` are not.

The three transforms you will use most:

- `translateY(-4px)` lifts; `translateX(4px)` nudges sideways. Percentages are relative to the element's own size, so `translateY(-50%)` is a common centring trick.
- `scale(0.98)` presses in. Stay close to `1`; scaling far from real size makes text and borders blurry while the animation runs.
- `rotate(-4deg)` tilts a stamp or badge. It is expressive, so use it sparingly.

Transforms combine in order: `translateY(-4px) rotate(-2deg)` lifts first, then tilts. The `transform-origin` decides the pivot point; the default is the centre. None of this changes document flow, which is why it is safe for hover and press states.

> **Under the hood:** The browser can hand transform and opacity changes to the compositor, a separate thread that paints layers without rebuilding the page. That is why a transform animation stays smooth while a `width` animation drops frames. Avoid `will-change` everywhere; it reserves memory, and too much makes performance worse.

## Motion with manners

Some people experience dizziness, nausea or migraine from large movement, parallax and loops. CSS can read the operating system setting with `prefers-reduced-motion`. Respect it by removing movement that could make someone unwell, while keeping the feedback that says what happened.

This notice has three motions: a pulsing dot, a sideways nudge on hover, and a rotating stamp. With reduced motion enabled, the movement stops but the border colour still responds.

```html run
<a class="notice" href="#dates">
  <span class="dot" aria-hidden="true"></span>
  <span><strong>Autumn dates are open.</strong> Twelve places, no queue.</span>
  <span class="stamp" aria-hidden="true">NEW</span>
</a>

<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .notice {
    display: flex; align-items: center; gap: 0.85rem; max-width: 34rem; padding: 1rem 1.15rem;
    border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; color: #0f172a;
    text-decoration: none; transition: transform 200ms ease, border-color 200ms ease;
  }
  .notice:hover { transform: translateX(4px); border-color: #0f766e; }
  .dot { width: 9px; height: 9px; flex: none; border-radius: 50%; background: #0d9488; animation: pulse 2s ease-in-out infinite; }
  .stamp {
    margin-left: auto; padding: 0.2rem 0.45rem; border: 1px solid currentColor; border-radius: 4px;
    color: #b45309; font-size: 0.65rem; font-weight: 800; letter-spacing: 0.08em;
    transform: rotate(-4deg); transition: transform 200ms ease;
  }
  .notice:hover .stamp { transform: rotate(0deg) scale(1.05); }
  @keyframes pulse { 50% { opacity: 0.35; } }
  @media (prefers-reduced-motion: reduce) {
    .notice, .stamp { transition: none; }
    .notice:hover { transform: none; }
    .stamp { transform: none; }
    .dot { animation: none; }
  }
</style>
```

The reduced-motion block is targeted, not a blanket ban. It removes the nudge, tilt, scale and pulse but leaves the colour and border changes that confirm hover. A blanket `* { animation: none !important; transition: none !important; }` is tempting, but it can freeze a loading spinner into a misleading still image. Name what moves and give each one a still alternative.

> **Tip:** Test reduced motion by enabling "Reduce motion" in your operating system, then reload. On macOS it is in Accessibility → Display; on Windows, Settings → Accessibility → Visual effects. The query follows the system setting, not a browser toggle.

## Make it intentional

Decorative motion exists because a page felt plain; intentional motion is feedback tied to an action. Before shipping an interaction, run through this list:

1. **Every control has the states it needs.** Links need hover and focus; buttons need hover, focus, active and disabled; inputs need focus and, where relevant, invalid and disabled.
2. **Focus is at least as visible as hover.** A mouse user can see the pointer; a keyboard user cannot. The ring is their pointer.
3. **Movement is small and fast.** Two to six pixels, 120–250ms, and a curve that settles. If the animation draws more attention than the action, it is too much.
4. **Nothing moves the layout.** Use `transform` and `opacity`. Do not animate `margin`, `width` or `top` for a hover effect.
5. **Colour changes survive contrast checks.** A teal that works at rest can fail on the hover background; check the pair, not just the default.
6. **Reduced motion is handled.** Remove large movement and loops; keep the state change.
7. **The keyboard path works.** Tab through the page and confirm you never lose your place. Then try it at 200% zoom.

Pick two durations and one easing curve, then reuse them: 120ms for colour and small shifts, 200ms for lifts, and `cubic-bezier(.2, .8, .2, 1)` for anything that travels. Consistency makes a set of interactions feel designed rather than assembled.

## Recap

- `:hover` is a pointer preview, `:focus` is keyboard location, `:active` is the press, `:disabled` is unavailability. They can apply at the same time; source order decides conflicts.
- `:focus-visible` lets you draw a ring for keyboard users without ringing every mouse click. Never remove focus without a visible replacement.
- Transitions are property, duration, timing function and delay. Keep durations short, avoid `all`, and use delay only for real choreography.
- `transform` and `opacity` animate without reflowing the page. `translateY`, `scale` and `rotate` cover most interface motion.
- `prefers-reduced-motion: reduce` asks for less movement, not less feedback. Keep the colour, border and text changes.
- Intentional states are consistent, contrast-safe and tested with a keyboard, a touch screen and reduced motion enabled.

**Up next:** the first capstone. You will build a complete personal profile page — semantic landmarks, an accessible nav, a profile header, a selected-work grid, a contact section and a mobile-first responsive layout — using the interaction states from this lesson as the finishing layer.
