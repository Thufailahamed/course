If you can build a page, you have already met the hard part: HTML and CSS are forgiving enough to let almost anything render. The next level is different. It is not memorizing more properties. It is understanding **why** a layout collapses, why a rule loses, why a component that looked perfect in isolation breaks inside a sidebar, and why an animation that feels delightful to you makes someone else dizzy.

This course is about the system underneath the properties. Every challenge runs in the browser and is checked against the real DOM and real computed styles, so the feedback is the engine's answer, not an approximation.

## The three questions behind every CSS bug

When something looks wrong, the useful move is not to add another rule. It is to ask:

1. **Which declaration won, and why?** The cascade, specificity, inheritance and layers decide the value that is actually applied.
2. **What formatting context is this box in?** Flex, Grid, block flow and positioning each have their own rules about sizing, alignment and overflow.
3. **What is the available space, and what is the content's minimum?** Most responsive bugs are a disagreement between a container's size and the intrinsic size of its contents.

That is the spine of the course. You will learn specific properties, but always in service of those questions.

## A preview of the difference

Here is a small component with a theme token, a fluid type scale and a focus state. Run it, then open the preview at phone width. It is deliberately simple, but every line is a decision:

```html run
<section class="card">
  <p class="eyebrow">Design system</p>
  <h1>A small surface with a lot of thought behind it.</h1>
  <p>Tokens describe intent. Components consume the tokens. Themes change the values, not the markup.</p>
  <a class="button" href="#details">Explore the system</a>
</section>

<style>
  :root {
    --color-surface: #ffffff;
    --color-text: #0f172a;
    --color-muted: #526077;
    --color-accent: #0f766e;
    --radius: 20px;
    --space: clamp(1.25rem, 4vw, 2.5rem);
  }
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #eef2f1; color: var(--color-text); }
  .card { max-width: 42rem; padding: var(--space); border-radius: var(--radius); background: var(--color-surface); box-shadow: 0 20px 45px -25px #0f172a66; }
  .eyebrow { margin: 0 0 0.75rem; color: var(--color-accent); font-size: 0.75rem; font-weight: 800; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: clamp(1.8rem, 5vw, 3rem); line-height: 1.05; letter-spacing: -0.04em; }
  p { margin: 0 0 1.5rem; color: var(--color-muted); line-height: 1.65; }
  .button { display: inline-flex; padding: 0.75rem 1rem; border-radius: 999px; background: var(--color-accent); color: white; font-weight: 700; text-decoration: none; }
  .button:focus-visible { outline: 3px solid #f59e0b; outline-offset: 3px; }
</style>
```

This is the kind of code you will write by the end: a component that is readable, themeable, responsive and keyboard-accessible without a framework. The interesting parts are not the colors. They are the token names, the fluid `clamp()`, the single focus rule and the fact that the markup did not change when the theme did.

```html predict id=advanced-welcome-predict-clamp title="What happens on a narrow screen?"
<h1 class="title">A fluid headline</h1>
<style>
  .title { font-size: clamp(2rem, 8vw, 4rem); }
</style>
--- options
* It scales down with the viewport until it reaches 2rem, then stops shrinking
It stays at 4rem on every screen
It becomes 8rem because `vw` is a multiplier
It only changes when JavaScript updates the window size
--- explain
`clamp(min, preferred, max)` keeps the preferred value between the bounds. At a narrow viewport, `8vw` falls below 2rem, so 2rem is the floor. At a wide viewport, the preferred value would exceed 4rem, so 4rem is the ceiling. That is fluid type without a pile of breakpoints.
```

## How this course works

- **Live preview under every example.** The frame is a real browser document, sandboxed and script-free. Change the code and run it. Use the desktop, tablet and phone buttons in the preview toolbar; a component that only works at one width is not finished.
- **Challenges are checked against the rendered page.** Tests use `getComputedStyle`, the DOM and layout measurements. You will get precise messages such as "the card computes to 340px, but its container is 320px wide".
- **Debug challenges** give you broken but realistic code. The bug might be a stacking context, a specificity conflict, an undefined token, an over-constrained flex item or a missing `min-width: 0`.
- **Predict questions** ask you to commit to the engine's behaviour before running. Being wrong is useful; the explanation is where the model gets corrected.

> **A note on copying:** The code in this course is designed to be read and modified. Type it out, change the values, break it, fix it. Passive reading produces the feeling of understanding without the ability to reproduce it.

## What you will build

Two capstones anchor the course:

1. A **responsive analytics dashboard** with a Grid app shell, accessible navigation, stat cards, a CSS-only chart, a data table and a layout that survives a narrow screen.
2. A **reusable design system** with tokens, themes, button variants, form states, cards and a component gallery organized with cascade layers.

Both are checked by the same kind of DOM assertions used in every lesson. They are not pixel-perfect screenshots; they are working pages with accessible structure and measured layout behaviour.

## What you need

You should be comfortable with HTML elements, basic selectors, the box model and either Flexbox or Grid. If those are still new, the HTML & CSS Basics course is the better starting point. You will not need JavaScript, a build tool or a design tool. A modern browser and the willingness to inspect what the browser actually computed are enough.

> **Under the hood:** The preview iframe is sandboxed with scripts disabled. That keeps the course focused on HTML and CSS, and it means no lesson can quietly rely on JavaScript. The challenge harness runs in a separate throwaway frame with the same markup and styles, then reads the real DOM. What you see is what is tested.

## Recap

- Advanced CSS is a small set of models: the cascade, formatting contexts, intrinsic sizing and available space.
- Every example is live, and the preview can be narrowed to reveal responsive failures.
- Challenges measure the rendered page, including computed styles and overflow.
- Debugging and prediction are the core skills; the properties are the vocabulary.
- The capstones turn the models into two production-shaped pages.

**Up next:** the cascade and specificity — not as a memorized scoreboard, but as a predictable system you can design with.
