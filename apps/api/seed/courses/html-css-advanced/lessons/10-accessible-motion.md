A notification slides in from the bottom of the screen, overshoots, settles, and pulses once for attention. It looks expensive. For most people it is a pleasant half-second. For someone with a vestibular disorder, the same movement can feel like the floor tilting, and the feeling can last long after the animation ends. Motion is not a neutral layer of polish; it is sensory input, and some of your users cannot opt out of the page.

The good news is that accessible motion is not motion with the life removed. It is motion with a fallback: the same information, delivered without the travel. This lesson covers the preference that asks for that fallback, the focus system that keyboard users depend on, and the loading states that make a page feel fast without making anyone ill.

## Motion is an input

The vestibular system is the part of the inner ear that tells you which way is down. Large movement on a two-dimensional screen — parallax, zoom, spin, a full-screen slide — can conflict with that signal. The result is dizziness, nausea, headache and unsteadiness. The effect is not proportional to how tasteful the easing curve is, and it is not limited to people with a diagnosis. Concussion recovery, migraine, pregnancy and some medications all change the threshold.

WCAG treats this seriously. Success criterion 2.3.3, *Animation from Interactions*, asks that motion triggered by interaction can be disabled unless it is essential. Criterion 2.2.2 asks for a way to pause, stop or hide moving content that starts automatically and lasts more than five seconds. The platform gives you the signal to do both: `prefers-reduced-motion`.

```css
@media (prefers-reduced-motion: reduce) {
  .card { animation: none; }
}
```

That query reflects an operating-system setting. On macOS it is System Settings → Accessibility → Display → Reduce motion; on Windows, Settings → Accessibility → Visual effects → Animation effects; on iOS and Android it lives in accessibility settings. The user has already told the system once. Your page should listen rather than ask again with its own toggle.

> **Under the hood:** `prefers-reduced-motion` has two meaningful values: `no-preference` and `reduce`. The first is the default, but treat it as “no explicit preference”, not as “this person loves parallax”. The setting can be on for reasons that have nothing to do with vestibular health — battery saving, motion sensitivity from a migraine, or a shared device.

## What to remove, what to keep

“Reduced motion” is a slightly misleading name. The useful question is not *should there be animation?* but *which part of this animation carries the meaning?* Almost always the meaning is the state change, not the journey to the new state.

| Effect | Under `reduce` | Why |
|---|---|---|
| Slide, zoom, spin, parallax | Remove or make instant | Large screen movement is the trigger |
| Fade or color change | Keep, often shorter | Communicates change without travel |
| Progress spinner | Keep, but calm it | Still communicates “working” |
| Hover lift | Remove the lift, keep the shadow | Feedback survives without movement |
| Skeleton shimmer | Replace with a static block | The shimmer is decoration |

Here is an entrance that keeps its personality for everyone else and becomes an instant appearance for anyone who asked for less. Run it, then read the media block at the bottom. Nothing in that block hides the notice or changes its final position; it only cancels the journey.

```html run
<article class="notice">
  <p class="eyebrow">New reply</p>
  <h2>Mara answered your trail question</h2>
  <p>“The north ridge is passable, but take the lower path after rain.”</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .notice {
    max-width: 32rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #0f172a; color: #cbd5e1;
    box-shadow: 0 24px 48px -24px rgb(15 23 42 / 0.55);
    animation: notice-in 520ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .35rem; color: #5eead4; font-size: .75rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .6rem; color: #f8fafc; font-size: 1.4rem; letter-spacing: -.02em; }
  p { margin: 0; line-height: 1.6; }
  @keyframes notice-in {
    from { opacity: 0; transform: translateY(56px) scale(.98); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
  @media (prefers-reduced-motion: reduce) {
    .notice { animation: none; }
  }
</style>
```

The final state is expressed by the element's own styles, not by the last keyframe. That is the important structural detail. If the notice were invisible by default and only the animation made it visible, `animation: none` would leave a blank space. With `animation-fill-mode: both` the animation controls opacity while it runs, but when it is removed the base `opacity: 1` applies. Design the resting state first, then animate *from* somewhere else.

Duration is part of the contract. Feedback such as a button press should land in 100–150 ms. A state transition feels responsive at 200–300 ms. An entrance can take 300–500 ms. Functional motion that lasts longer than a second starts to feel like waiting, and anything that loops for more than five seconds needs a pause control. Slow movement is not automatically gentler: a long, drifting parallax can be more disorienting than a quick, small transition.

Hover effects deserve the same treatment. The lift below is a small translation, but it is repeated every time a pointer crosses the card, and it is easy to remove without losing the affordance:

```html run
<a class="route-card" href="#guide">
  <span>
    <strong>North ridge in autumn</strong>
    <small>9.4 km · moderate · 3 hours</small>
  </span>
  <span class="arrow" aria-hidden="true">→</span>
</a>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .route-card {
    display: flex; align-items: center; justify-content: space-between;
    max-width: 34rem; padding: 1.25rem 1.4rem; border: 1px solid #e2e8f0;
    border-radius: 14px; background: #fff; color: #0f172a; text-decoration: none;
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.06);
    transition: transform 220ms ease, box-shadow 220ms ease;
  }
  .route-card small { display: block; margin-top: .3rem; color: #475569; }
  .arrow { color: #0f766e; font-size: 1.4rem; }
  .route-card:hover { transform: translateY(-4px); box-shadow: 0 16px 30px -18px rgb(15 23 42 / 0.45); }
  @media (prefers-reduced-motion: reduce) {
    .route-card { transition: box-shadow 220ms ease; }
    .route-card:hover { transform: none; }
  }
</style>
```

The card still responds to hover through its shadow. A person using reduced motion gets the same “this is interactive” signal without the card appearing to lift off the page.

> **Pitfall:** The popular reset `* { animation-duration: .01ms !important; transition-duration: .01ms !important; }` does stop motion, but it also disables useful feedback, can fire `animationend` handlers almost immediately, and leaves `animation-delay` untouched. Prefer targeting the few selectors that actually travel. If you do use a global reset, pair it with `animation-delay: 0ms` and accept that you have traded nuance for coverage.

## Challenge: calm the panel

This panel currently rises 48 pixels and fades in. For visitors who prefer reduced motion, it should appear directly in its final position and at full opacity — no travel, no fade. Add the media query and the rule that neutralises the entrance.

```html exercise id=calm-the-panel title="Calm the entrance"
<article class="panel">
  <p class="eyebrow">Saved</p>
  <h2>Your route is in the notebook</h2>
  <p>You can add notes from the trail or from the car park.</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .panel {
    max-width: 30rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #fff; border: 1px solid #e2e8f0;
    box-shadow: 0 18px 40px -26px rgb(15 23 42 / .4);
    animation: panel-rise 600ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .3rem; color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .5rem; font-size: 1.35rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @keyframes panel-rise {
    from { opacity: 0; transform: translateY(48px); }
    to { opacity: 1; transform: translateY(0); }
  }
  /* TODO: add a prefers-reduced-motion block. */
</style>
--- solution
<article class="panel">
  <p class="eyebrow">Saved</p>
  <h2>Your route is in the notebook</h2>
  <p>You can add notes from the trail or from the car park.</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .panel {
    max-width: 30rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #fff; border: 1px solid #e2e8f0;
    box-shadow: 0 18px 40px -26px rgb(15 23 42 / .4);
    animation: panel-rise 600ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .3rem; color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .5rem; font-size: 1.35rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @keyframes panel-rise {
    from { opacity: 0; transform: translateY(48px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @media (prefers-reduced-motion: reduce) {
    .panel { animation: none; }
  }
</style>
--- test
assertExists(".panel", "Keep the panel in the page.");
const sheets = [];
for (const sheet of document.styleSheets) {
  try { sheets.push(...sheet.cssRules); } catch (error) {}
}
const reduce = sheets.find((rule) => rule.type === 4 && /prefers-reduced-motion/.test(rule.conditionText) && /reduce/.test(rule.conditionText));
assert(reduce, "Add an @media (prefers-reduced-motion: reduce) block that targets the panel.");
assert(reduce.cssRules.length > 0, "The reduced-motion block is empty. Put the panel rule inside it.");
reduce.media.mediaText = "all";
assertStyle(".panel", "transform", "none", "With reduced motion, the panel should sit in its final position instead of translating into place.");
assertStyle(".panel", "opacity", "1", "The panel should be fully opaque when the entrance animation is removed.");
--- hint
The query is `@media (prefers-reduced-motion: reduce)`. Put it after the keyframes so you can read the file top to bottom.
--- hint
Inside the block, target `.panel` and cancel the animation with `animation: none;`. The element's base styles already describe the final state.
```

The tests look for the media block in the parsed stylesheet, then temporarily force it on. That is the same trade-off a real audit makes when it cannot change your operating system: it checks that the reduced branch exists and that it produces the right resting state. Notice what the test does *not* require: it does not demand a particular property. `animation: none` is the direct fix, but a short opacity-only replacement would also be a legitimate answer if it left the panel at full opacity with no translation.

## Focus is a location

Keyboard users do not experience your layout in the same order as a mouse user. They experience it as a sequence of stops. Browsers draw the focus ring; CSS can make it beautiful or delete it. Deleting it is the single most common accessibility regression in a design refresh.

`:focus-visible` exists to solve a real tension. A mouse click on a button should not leave a ring behind; a Tab press should. The browser applies a heuristic: if the last interaction was keyboard-like, focusable elements match `:focus-visible`; text inputs match even after a click, because you are about to type. Style `:focus-visible`, not `:focus`, when you want a keyboard-specific ring:

```css
.button:focus-visible {
  outline: 3px solid #0f766e;
  outline-offset: 3px;
}
```

Three pixels is a comfortable target. Two is the practical minimum. The ring must also have at least 3:1 contrast against the colours on both sides of it, which is why a dark ring over a dark button can disappear even though it is technically present. A two-tone ring solves that without guessing the background:

```css
.button:focus-visible {
  outline: 3px solid #0f766e;
  outline-offset: 2px;
  box-shadow: 0 0 0 5px #fff;
}
```

The outline sits away from the control; the white shadow sits behind it. One of the two will contrast with whatever surface the button lands on. If you use `box-shadow` alone, remember it is not drawn in forced-colours mode the way an outline is.

Focus *order* is determined by the DOM, not by what you see. `tabindex="1"` and above creates a second, parallel order that almost never matches the visual one and is nearly impossible to maintain. Avoid positive tabindex entirely. More subtly, CSS can reorder elements visually without changing the tab sequence: `flex-direction: row-reverse`, `order`, and grid placement all move pixels, not focus. If the visual order and the DOM order disagree, keyboard users will jump around the page. Fix the DOM, or accept the order you have.

A skip link is the cheapest focus improvement you can ship. It is the first focusable thing in the document, it is visually hidden until focused, and it jumps to the main content so a keyboard user does not have to Tab through the entire navigation on every visit.

```html run
<a class="skip" href="#main">Skip to content</a>
<header class="site-header">
  <a class="brand" href="#">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main" tabindex="-1">
  <h1>Trail notes</h1>
  <p>Use Tab to reach the skip link, then press Enter. The ring is the browser telling you where you are.</p>
  <a class="cta" href="#subscribe">Get the weekly note</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .skip {
    position: absolute; left: 1rem; top: -4rem; z-index: 10;
    padding: .65rem 1rem; border-radius: 8px; background: #0f172a; color: #fff;
    font-weight: 600; text-decoration: none; transition: top 150ms ease;
  }
  .skip:focus { top: 1rem; }
  .site-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
  nav { display: flex; gap: 1rem; }
  a { color: #0f172a; }
  .brand { font-weight: 800; text-decoration: none; letter-spacing: -.02em; }
  main { max-width: 38rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .75rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
  .cta { display: inline-block; margin-top: .5rem; padding: .7rem 1rem; border-radius: 10px; background: #0f766e; color: #fff; font-weight: 600; text-decoration: none; }
  a:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; border-radius: 4px; }
  @media (prefers-reduced-motion: reduce) {
    .skip { transition: none; }
  }
</style>
```

`tabindex="-1"` on `<main>` is deliberate. It makes the element programmatically focusable without adding it to the Tab order, so following the skip link moves focus into the content instead of merely scrolling the viewport. The skip link itself uses `:focus` rather than `:focus-visible`, because it must also appear if someone clicks it and then tabs backward.

## Challenge: a ring you can see

The call to action below has no custom focus style. Build one that is visible against the page and against the button, stays clear of the text, and does not depend on colour alone. The tests focus the link and inspect the computed ring.

```html exercise id=focus-ring-visible title="A ring you can see"
<main class="panel">
  <h1>Walk the coast path</h1>
  <p>Six days, five villages, one very good bakery.</p>
  <a class="cta" href="#book">Book a place</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .panel { max-width: 30rem; margin: 3rem auto; padding: 2rem; border-radius: 18px; background: #fff; }
  h1 { margin: 0 0 .5rem; font-size: 1.8rem; color: #0f172a; }
  p { margin: 0 0 1.25rem; color: #475569; line-height: 1.6; }
  .cta { display: inline-block; padding: .8rem 1.1rem; border-radius: 10px; background: #0f172a; color: #fff; font-weight: 600; text-decoration: none; }
  /* TODO: add a keyboard focus ring with thickness and breathing room. */
</style>
--- solution
<main class="panel">
  <h1>Walk the coast path</h1>
  <p>Six days, five villages, one very good bakery.</p>
  <a class="cta" href="#book">Book a place</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .panel { max-width: 30rem; margin: 3rem auto; padding: 2rem; border-radius: 18px; background: #fff; }
  h1 { margin: 0 0 .5rem; font-size: 1.8rem; color: #0f172a; }
  p { margin: 0 0 1.25rem; color: #475569; line-height: 1.6; }
  .cta { display: inline-block; padding: .8rem 1.1rem; border-radius: 10px; background: #0f172a; color: #fff; font-weight: 600; text-decoration: none; }
  .cta:focus-visible {
    outline: 3px solid #b45309;
    outline-offset: 3px;
    box-shadow: 0 0 0 6px #fff;
  }
</style>
--- test
const cta = query(".cta");
cta.focus();
assert(document.activeElement === cta, "The call to action should be reachable and focusable.");
const style = getComputedStyle(cta);
const width = parseFloat(style.outlineWidth) || 0;
const hasOutline = style.outlineStyle !== "none" && width >= 3;
const hasShadow = style.boxShadow !== "none";
assert(hasOutline || hasShadow, "After focus, the link needs a visible ring at least 3px thick. A colour change alone is not enough.");
const offset = parseFloat(style.outlineOffset) || 0;
assert(offset >= 2 || hasShadow, "Move the focus ring at least 2px away from the text, or use a shadow ring that surrounds it.");
assert(style.outlineStyle !== "none" || hasShadow, "The focused link has no visible indicator.");
--- hint
Use `.cta:focus-visible` so the ring appears for keyboard users without lingering after a mouse click.
--- hint
A 3px `outline` with `outline-offset: 3px` covers both the thickness and the breathing room. A second white `box-shadow` ring keeps it visible on dark surfaces.
```

The test accepts an outline or a shadow ring because both are legitimate techniques. What it will not accept is a subtle colour shift: colour alone fails the “not by colour alone” rule, and it also fails anyone who cannot perceive that particular hue difference.

## Debug: the outline that vanished

A design system reset removed focus outlines globally to make screenshots look clean. The result is a page that is fully usable with a mouse and unusable with a keyboard. Find the rule and replace it with something that keeps the visual polish without deleting the indicator.

```html debug id=focus-lost title="The outline that vanished"
<header class="bar">
  <a class="brand" href="#main">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main">
  <h1>Where the path goes</h1>
  <p>Every link on this page is a stop in the keyboard sequence.</p>
</main>

<style>
  *:focus { outline: none; }
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .bar { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.5rem; background: #0f172a; }
  .brand { color: #fff; font-weight: 800; text-decoration: none; }
  nav { display: flex; gap: 1rem; }
  nav a { color: #cbd5e1; text-decoration: none; }
  main { max-width: 36rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .5rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
</style>
--- solution
<header class="bar">
  <a class="brand" href="#main">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main">
  <h1>Where the path goes</h1>
  <p>Every link on this page is a stop in the keyboard sequence.</p>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .bar { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.5rem; background: #0f172a; }
  .brand { color: #fff; font-weight: 800; text-decoration: none; }
  nav { display: flex; gap: 1rem; }
  nav a { color: #cbd5e1; text-decoration: none; }
  main { max-width: 36rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .5rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
  a:focus-visible {
    outline: 3px solid #fbbf24;
    outline-offset: 3px;
    border-radius: 3px;
  }
</style>
--- test
const links = [...document.querySelectorAll("a")];
assert(links.length >= 3, "Keep the brand and both navigation links.");
for (const link of links) {
  link.focus();
  assert(document.activeElement === link, `The link labelled "${normalize(link.textContent)}" should be reachable with Tab.`);
  const style = getComputedStyle(link);
  const width = parseFloat(style.outlineWidth) || 0;
  const hasOutline = style.outlineStyle !== "none" && width >= 2;
  const hasShadow = style.boxShadow !== "none";
  assert(hasOutline || hasShadow, `The link labelled "${normalize(link.textContent)}" has no visible focus indicator. Restore a ring for keyboard users.`);
}
--- hint
The universal `*:focus` rule near the top of the stylesheet is the culprit. It matches every focused element, including links.
--- hint
Delete that rule. Then add `a:focus-visible` with a 3px outline and an offset. Do not simply set `outline: auto` on `:focus`; the original problem was the global reset, not the property.
```

> **In the wild:** Many CSS resets still contain `:focus { outline: none; }` or `:focus { outline: 0; }`. If you inherit a codebase, grep for `outline: none` before you audit anything else. The fix is usually two lines, and it restores the entire keyboard experience.

## Smooth scrolling is still motion

`scroll-behavior: smooth` looks like a small, tasteful default. On a long page it can turn a single anchor click into a two-second journey across thousands of pixels, which is exactly the kind of full-viewport movement that triggers vestibular symptoms. It also delays the destination, so a keyboard user who pressed Enter may think the link failed.

The fix is one media query. Keep smooth scrolling for people who have not asked for less, and switch to an instant jump for anyone who has:

```css
html { scroll-behavior: smooth; scroll-padding-top: 5rem; }

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
}
```

`scroll-padding-top` is not an accessibility requirement, but it is part of making anchor navigation feel finished: it leaves room for a sticky header so the heading does not land underneath it. `scroll-margin-top` does the same job on the target element. Use one consistently.

```html run
<nav class="toc" aria-label="On this page">
  <a href="#gear">Gear</a>
  <a href="#weather">Weather</a>
  <a href="#return">Getting back</a>
</nav>
<main>
  <section id="gear">
    <h2>Gear</h2>
    <p>Boots, a shell, and a head torch even in summer.</p>
  </section>
  <section id="weather">
    <h2>Weather</h2>
    <p>Conditions change fast above the tree line. Check the forecast twice.</p>
  </section>
  <section id="return">
    <h2>Getting back</h2>
    <p>The last bus leaves at 18:10. Do not treat that as a suggestion.</p>
  </section>
</main>

<style>
  html { scroll-behavior: smooth; scroll-padding-top: 5rem; }
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .toc { position: sticky; top: 0; display: flex; gap: 1rem; padding: 1rem 1.5rem; background: #0f172a; z-index: 2; }
  .toc a { color: #e2e8f0; text-decoration: none; font-weight: 600; font-size: .9rem; }
  main { max-width: 36rem; padding: 1rem 1.5rem 4rem; }
  section { min-height: 52vh; padding-top: 1rem; scroll-margin-top: 4rem; }
  h2 { margin: 0 0 .5rem; font-size: 1.6rem; }
  p { color: #475569; line-height: 1.65; }
  a:focus-visible { outline: 3px solid #fbbf24; outline-offset: 3px; }
  @media (prefers-reduced-motion: reduce) {
    html { scroll-behavior: auto; }
  }
</style>
```

> **Pitfall:** `scroll-behavior: smooth` applies to programmatic scrolling too, including `element.scrollIntoView()` and `window.scrollTo()`. A media query on `html` is the broadest fix, but component code that calls `scrollIntoView({ behavior: "smooth" })` still needs its own reduced-motion check. CSS cannot override an explicit behaviour passed in JavaScript.

## Perceived speed

Motion is also a performance tool. The numbers most product teams use come from response-time research: under about 100 ms feels instant, under a second keeps a flow intact, and around ten seconds is the limit of attention. Loading states live in the gap between those numbers.

A skeleton screen is a promise about the shape of what is coming. It works when its blocks match the final layout, so the content does not jump when it arrives. A shimmer makes the wait feel alive; under reduced motion, the shimmer should stop while the skeleton remains. The static blocks still say “content is loading” through their shape, and `aria-busy="true"` says it to assistive technology.

```html run
<article class="skeleton-card" aria-busy="true" aria-label="Loading trail conditions">
  <div class="skeleton line title"></div>
  <div class="skeleton line"></div>
  <div class="skeleton line short"></div>
  <div class="skeleton block"></div>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .skeleton-card { max-width: 30rem; margin: 0 auto; padding: 1.5rem; border-radius: 16px; background: #fff; border: 1px solid #e2e8f0; }
  .skeleton {
    border-radius: 7px;
    background: linear-gradient(90deg, #e2e8f0 25%, #f8fafc 37%, #e2e8f0 63%);
    background-size: 400% 100%;
    animation: shimmer 1.4s ease infinite;
  }
  .line { height: 12px; margin-bottom: .8rem; }
  .line.title { width: 58%; height: 22px; margin-bottom: 1.2rem; }
  .line.short { width: 36%; }
  .block { height: 120px; margin-top: 1.4rem; }
  @keyframes shimmer {
    from { background-position: 100% 0; }
    to { background-position: 0 0; }
  }
  @media (prefers-reduced-motion: reduce) {
    .skeleton { animation: none; background: #e2e8f0; }
  }
</style>
```

Optimistic UI is the other half of perceived speed: show the result immediately, then reconcile with the server. A “Saved” label that appears the instant you press the button feels faster than a spinner that tells the truth. The pattern is only acceptable if failure is visible and recoverable. If the request fails, replace the optimistic state with an error and a retry — do not leave a checkmark on a change that never happened. The CSS can style both states; the state machine belongs in JavaScript.

> **Tip:** Put loading states on a slightly slower timer than you think you need. A spinner that flashes for 80 ms is worse than no spinner: it draws the eye, disappears before it is understood, and makes the wait feel longer. Show a skeleton immediately if you know the layout; show a spinner only after 300–500 ms of genuine waiting.

## Testing with reduced motion

You cannot verify this by reading the media query. You have to run the page in the condition.

1. Open DevTools → Rendering → *Emulate CSS media feature prefers-reduced-motion* and choose `reduce`.
2. Reload. Every entrance should be in its final position. Nothing should be invisible or half-faded.
3. Tab through the page with the mouse untouched. Every stop needs a visible ring, and the order should match the visual order.
4. Try the skip link as the very first Tab stop.
5. Click an in-page anchor. With reduced motion on, it should jump rather than glide.
6. Check loading states. The skeleton may stay; the shimmer must not.

Automated checks can catch the easy half. In a test, force the media rule on by setting `rule.media.mediaText = "all"` — as the challenge above does — or run a browser with the preference enabled. Then assert computed `transform`, `opacity` and `animation-name`. Assertions on CSS text alone are brittle: they cannot tell whether the rule actually wins the cascade.

Now predict what a reduced-motion visitor sees. Read the media block before you choose.

```html predict id=reduced-motion-banner title="What does the reduced-motion visitor see?"
<div class="banner">
  <strong>Weekend workshops are open.</strong>
  <a href="#book">Book a place</a>
</div>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .banner {
    max-width: 30rem; margin: 0 auto; padding: 1rem 1.25rem;
    display: flex; justify-content: space-between; gap: 1rem; align-items: center;
    border-radius: 12px; background: #0f766e; color: #fff;
    animation: drop-in 500ms ease-out both;
  }
  .banner a { color: #fff; font-weight: 700; }
  @keyframes drop-in {
    from { opacity: 0; transform: translateY(-64px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @media (prefers-reduced-motion: reduce) {
    .banner { animation: none; }
  }
</style>
--- options
* The banner is visible immediately in its final position, with no slide or fade
The banner slides down over half a second, then stays
The banner stays invisible because the animation never runs
The banner slides up from below the footer and stops in the middle
--- explain
`animation: none` cancels the keyframes entirely, so the element falls back to its own styles: default `opacity: 1` and no transform. The banner appears instantly where it belongs. This is why the resting state must be correct without the animation. If the base rule had been `opacity: 0`, cancelling the animation would leave an invisible banner — a far worse failure than the motion itself.
```

## Recap

- Motion is sensory input. Large travel, zoom, spin and parallax can trigger vestibular symptoms; `prefers-reduced-motion: reduce` is the user's request to remove them.
- Remove the journey, keep the meaning. Fade, colour and immediate state changes usually survive; translation, scale and loops usually do not.
- Design the resting state first. `animation: none` should leave the element visible and correctly placed, not blank.
- `:focus-visible` gives keyboard users a ring without punishing mouse users. Never remove an outline without replacing it with something at least as visible.
- Focus order follows the DOM. Positive `tabindex` and CSS reordering break the sequence; skip links repair the most common case.
- `scroll-behavior: smooth` is motion too. Turn it off under `reduce`, and keep skeleton motion calm while preserving the loading signal.

**Up next:** forms that feel premium — accessible labels, native validation states and custom controls that keep their keyboard behaviour.
