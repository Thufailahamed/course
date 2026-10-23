A landing page has one job: make an offer understandable and the next step obvious. The headline promises, the features supply proof, the pricing lowers the risk, and the signup asks for the smallest possible commitment. A section that does not help one of those jobs is decoration.

The product is **Fieldnote**, a fictional notes app for hikers: offline by default, built around coordinates, and quiet by design. The visual direction is a worn paper map rather than a generic software gradient — warm paper, deep forest green, a single amber accent, a serif display face paired with the system UI font. You will build it in stages: structure, hero, features, pricing, signup and the finished page. No JavaScript, no external images and no framework.

## A landing page is an argument

Start with the sections, not the styling. Each section is a claim, and the headings are the outline of the argument:

- **Header and nav:** who we are and where to go.
- **Hero:** the promise and the primary action.
- **Features:** three reasons to believe the promise.
- **Pricing:** what it costs, in plain language.
- **Signup:** the action, with as little friction as possible.
- **Footer:** the small print and the way back.

The document uses `<header>`, `<main>`, `<section>` and `<footer>`. The hero contains the only `<h1>`. Each later section has an `<h2>`, and each card inside it has an `<h3>`. That outline is what a screen reader user hears when they jump between headings, and it is also a useful test of whether the page's argument is clear: read only the headings and see if the story still makes sense.

The hero calls to action are **links**, not buttons. They navigate within the page and can be opened, copied and followed without JavaScript. The only `<button>` belongs to the signup form, because it submits data. Styling a link as a button does not change what it is.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fieldnote · Notes for the long way round</title>
  </head>
  <body>
    <header class="site-header">
      <a class="brand" href="#top">Fieldnote</a>
      <nav aria-label="Primary"><a href="#features">Features</a> <a href="#pricing">Pricing</a> <a href="#signup">Start free</a></nav>
    </header>
    <main id="top">
      <section class="hero" aria-labelledby="hero-title">
        <p class="eyebrow">Notes for the long way round</p>
        <h1 id="hero-title">Keep the trail in your pocket.</h1>
        <p class="lede">Fieldnote is a quiet notebook for hikes: offline maps, coordinates, and the name of that bothy you almost missed.</p>
        <p class="actions"><a class="button-primary" href="#signup">Start a free notebook</a> <a class="button-secondary" href="#features">See how it works</a></p>
      </section>
      <section id="features" aria-labelledby="features-title">
        <h2 id="features-title">Built for weather and map margins</h2>
        <p>Three feature cards will live here.</p>
      </section>
      <section id="pricing" aria-labelledby="pricing-title">
        <h2 id="pricing-title">Simple plans for every trail</h2>
        <p>Three plan cards will live here.</p>
      </section>
      <section id="signup" aria-labelledby="signup-title">
        <h2 id="signup-title">Start with one page.</h2>
        <form>
          <label for="email">Email address</label>
          <input id="email" name="email" type="email" autocomplete="email" required>
          <button type="submit">Create my notebook</button>
        </form>
      </section>
    </main>
    <footer><p>© 2026 Fieldnote. Made for the long way round.</p></footer>
  </body>
</html>
```

This is not a wireframe with grey boxes. It uses realistic copy because headline and plan-name lengths determine whether the layout works. Lorem ipsum hides layout problems; real sentences expose them. Double a headline and you will learn more about your CSS than from polishing empty boxes.

> **Tip:** Read the page with CSS disabled. It should still make sense in order: brand, navigation, promise, proof, price, signup, footer. If the plain document already tells the story, the styled version has a solid foundation. If it does not, no amount of colour will fix it.

## The hero earns the scroll

A hero has one screen to answer three questions: what is this, who is it for, and what do I do next? The headline should make a promise a person can repeat. "Keep the trail in your pocket" says the product is with you, even when the signal is not. The subhead does the specific work: offline maps, coordinates, the name of the bothy. A vague headline followed by a vague subhead makes the visitor do the thinking.

The two calls to action are deliberately unequal. The primary action is filled forest green because starting is the main path. The secondary action is an outlined link because some people want proof before they commit. Two equally loud buttons create a choice without a recommendation. One primary action per screen is usually enough.

Typography carries most of the personality. Georgia, a serif on almost every system, is paired with the platform UI font for body copy. The combination costs nothing, renders immediately, and gives the page an editorial, map-journal feel. The headline uses `clamp(2.6rem, 7vw, 5rem)`, bold on a phone and generous on desktop without a breakpoint. Body copy is capped at 46 characters per line; long lines tire the reader even when the type is beautiful.

The illustration is inline SVG: a paper note on a topographic background. It is decorative, so the wrapper has `aria-hidden="true"` and the SVG has `role="presentation"`. It loads with the document, cannot break, and can be recoloured with the same palette as the rest of the page.

```html run
<section class="hero wrap" id="top">
  <div class="copy">
    <p class="eyebrow">Notes for the long way round</p>
    <h1>Keep the trail in your pocket.</h1>
    <p class="lede">Fieldnote is a quiet notebook for hikes: offline maps, coordinates, and the name of that bothy you almost missed.</p>
    <p class="actions">
      <a class="button primary" href="#signup">Start a free notebook</a>
      <a class="button secondary" href="#features">See how it works</a>
    </p>
  </div>
  <div class="art" aria-hidden="true">
    <svg viewBox="0 0 420 340" role="presentation">
      <rect width="420" height="340" rx="28" fill="#e7e1d3"/>
      <path d="M-20 260 C70 210 120 300 210 248 S350 174 450 214" fill="none" stroke="#a8b5a0" stroke-width="2"/>
      <path d="M-20 286 C80 238 130 324 220 270 S360 198 450 238" fill="none" stroke="#a8b5a0" stroke-width="1.5"/>
      <rect x="86" y="64" width="248" height="212" rx="18" fill="#fffdf6" stroke="#d8d2c4"/>
      <text x="116" y="108" font-family="Georgia, serif" font-size="22" fill="#1c2a24">Kinder edge</text>
      <text x="116" y="132" font-family="system-ui, sans-serif" font-size="12" fill="#68766b">53.38° N · 1.87° W</text>
      <path d="M116 158 h176 M116 180 h150 M116 202 h164" stroke="#c9c0ae" stroke-width="5" stroke-linecap="round"/>
      <circle cx="290" cy="230" r="14" fill="#d97706"/>
      <path d="M290 222 v16 M282 230 h16" stroke="#fffdf6" stroke-width="2"/>
    </svg>
  </div>
</section>
<style>
  :root { --ink: #1c2a24; --muted: #5b665e; --paper: #f6f3ec; --card: #fffdf6; --line: #d8d2c4; --forest: #1f4d3a; --amber: #b45309; --text-sm: 0.75rem; --text-lead: clamp(1.05rem, 2vw, 1.2rem); --text-display: clamp(2.6rem, 7vw, 5rem); } * { box-sizing: border-box; }
  body { margin: 0; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: var(--paper); }
  .wrap { width: min(100% - 2rem, 72rem); margin-inline: auto; } .hero { display: grid; gap: 2rem; align-items: center; padding-block: clamp(2.5rem, 8vw, 6rem); }
  .eyebrow { margin: 0 0 0.75rem; color: var(--amber); font-size: var(--text-sm); font-weight: 750; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 { margin: 0; font-family: Georgia, serif; font-size: var(--text-display); line-height: 0.98; letter-spacing: -0.04em; font-weight: 500; }
  .lede { max-width: 46ch; margin: 1.25rem 0 0; color: var(--muted); font-size: var(--text-lead); }
  .actions { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-top: 1.75rem; }
  .button { display: inline-flex; align-items: center; justify-content: center; padding: 0.8rem 1.2rem; border: 1px solid transparent; border-radius: 999px; font-weight: 650; text-decoration: none; transition: transform 160ms ease, background-color 160ms ease, border-color 160ms ease; }
  .primary { background: var(--forest); color: #fff; } .primary:hover { background: #163b2c; transform: translateY(-2px); }
  .secondary { border-color: var(--line); color: var(--ink); background: transparent; } .secondary:hover { border-color: var(--forest); background: #ece7db; }
  .button:focus-visible { outline: 3px solid var(--amber); outline-offset: 3px; }
  .art svg { display: block; width: 100%; height: auto; }
  @media (min-width: 52rem) { .hero { grid-template-columns: 1.15fr 0.85fr; } }
</style>
```

On a phone the hero is a single column: eyebrow, headline, subhead, actions, illustration. On a wide screen the copy and the illustration sit side by side, with the copy first in the DOM. That order matters: a screen reader and a keyboard user encounter the promise before the picture. The layout changes; the reading order does not.

> **Tip:** Every link styled as a button should keep a visible focus ring and a comfortable target. Padding of roughly 0.8rem by 1.2rem gives a target over 44px tall, which is the size a thumb can hit without precision.

## Challenge: the hero and its two actions

Build the hero's copy and calls to action. Add a `.lede` subhead and two anchors: `.button-primary` for starting and `.button-secondary` for learning more. The primary need strong filled contrast; the secondary needs a visible border. Both need a `:focus-visible` ring and a padding that makes them easy to click.

```html exercise id=hero-cta title="Build the hero with accessible CTA links"
<header class="site-header">
  <a class="brand" href="#top">Fieldnote</a>
  <nav aria-label="Primary">
    <a href="#features">Features</a>
    <a href="#pricing">Pricing</a>
    <a href="#signup">Start free</a>
  </nav>
</header>
<main>
  <section class="hero" id="top">
    <p class="eyebrow">Notes for the long way round</p>
    <h1>Keep the trail in your pocket.</h1>
    <!-- TODO: add a .lede subhead and two CTA links -->
  </section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; line-height: 1.6; }
  .site-header, .hero { max-width: 72rem; margin: 0 auto; padding: 1.5rem; }
  .site-header { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 1rem; border-bottom: 1px solid #d8d2c4; }
  .brand { color: #1c2a24; font-weight: 750; text-decoration: none; }
  nav { display: flex; gap: 1rem; font-size: 0.9rem; font-weight: 600; }
  nav a { color: #1c2a24; text-decoration: none; }
  .hero { padding-block: 4rem; }
  h1 { margin: 0; max-width: 12ch; font-family: Georgia, serif; font-weight: 500; font-size: clamp(2.6rem, 7vw, 5rem); line-height: 0.98; letter-spacing: -0.04em; }
  .lede { max-width: 46ch; margin: 1.25rem 0 0; color: #5b665e; font-size: 1.1rem; }
  .actions { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-top: 1.75rem; }
  .button-primary, .button-secondary { display: inline-flex; padding: 0.8rem 1.2rem; border: 1px solid transparent; border-radius: 999px; font-weight: 650; text-decoration: none; }
  /* TODO: fill the primary, outline the secondary, then add hover and focus-visible states */
</style>
--- solution
<header class="site-header">
  <a class="brand" href="#top">Fieldnote</a>
  <nav aria-label="Primary">
    <a href="#features">Features</a>
    <a href="#pricing">Pricing</a>
    <a href="#signup">Start free</a>
  </nav>
</header>
<main>
  <section class="hero" id="top">
    <p class="eyebrow">Notes for the long way round</p>
    <h1>Keep the trail in your pocket.</h1>
    <p class="lede">Fieldnote is a quiet notebook for hikes: offline maps, coordinates, and the name of that bothy you almost missed.</p>
    <p class="actions">
      <a class="button-primary" href="#signup">Start a free notebook</a>
      <a class="button-secondary" href="#features">See how it works</a>
    </p>
  </section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; line-height: 1.6; }
  .site-header, .hero { max-width: 72rem; margin: 0 auto; padding: 1.5rem; }
  .site-header { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 1rem; border-bottom: 1px solid #d8d2c4; }
  .brand { color: #1c2a24; font-weight: 750; text-decoration: none; }
  nav { display: flex; gap: 1rem; font-size: 0.9rem; font-weight: 600; }
  nav a { color: #1c2a24; text-decoration: none; }
  .hero { padding-block: 4rem; }
  h1 { margin: 0; max-width: 12ch; font-family: Georgia, serif; font-weight: 500; font-size: clamp(2.6rem, 7vw, 5rem); line-height: 0.98; letter-spacing: -0.04em; }
  .lede { max-width: 46ch; margin: 1.25rem 0 0; color: #5b665e; font-size: 1.1rem; }
  .actions { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-top: 1.75rem; }
  .button-primary, .button-secondary { display: inline-flex; padding: 0.8rem 1.2rem; border: 1px solid transparent; border-radius: 999px; font-weight: 650; text-decoration: none; transition: transform 160ms ease, background-color 160ms ease; }
  .button-primary { background: #1f4d3a; border-color: #1f4d3a; color: #fff; }
  .button-primary:hover { background: #163b2c; transform: translateY(-2px); }
  .button-secondary { border-color: #d8d2c4; color: #1c2a24; }
  .button-secondary:hover { border-color: #1f4d3a; background: #ece7db; }
  .button-primary:focus-visible, .button-secondary:focus-visible { outline: 3px solid #d97706; outline-offset: 3px; }
</style>
--- test
assertExists("header.site-header", "Keep the page header.");
const nav = query("header.site-header nav");
assert(nav.getAttribute("aria-label"), "The navigation needs an aria-label.");
assertCount("header.site-header nav a", 3, "Keep the three navigation links.");
assertExists(".hero", "Keep the hero section.");
assertExists(".hero h1", "The hero needs an h1.");
assert(normalize(query(".hero h1").textContent).length > 0, "The hero headline should contain real words.");
const lede = query(".hero .lede");
assert(normalize(lede.textContent).length > 30, "Write a .lede subhead that explains what the product does.");
for (const selector of [".button-primary", ".button-secondary"]) {
  const link = query(selector);
  assert(link.tagName === "A", `${selector} should be an anchor link, not a button.`);
  assert(link.getAttribute("href"), `${selector} needs a real href.`);
  assert(normalize(link.textContent).length > 0, `${selector} needs a visible name.`);
  assert(link.tabIndex >= 0, `${selector} should be reachable with the Tab key.`);
}
const primary = getComputedStyle(query(".button-primary"));
const secondary = getComputedStyle(query(".button-secondary"));
assert(primary.backgroundColor !== "rgba(0, 0, 0, 0)", "The primary CTA should have a filled background.");
assert(primary.backgroundColor !== secondary.backgroundColor, "The primary and secondary CTAs need distinct visual weight.");
assert(parseFloat(secondary.borderTopWidth) >= 1, "The secondary CTA needs a visible border.");
assert(parseFloat(primary.paddingTop) >= 8, "Give the CTAs enough padding to be comfortable targets.");
const focusRules = [];
for (const sheet of document.styleSheets) {
  const walk = (rules) => {
    for (const rule of rules) {
      if (rule.selectorText && /:focus-visible/.test(rule.selectorText) && /\.button/.test(rule.selectorText)) focusRules.push(rule);
      if (rule.cssRules) walk(rule.cssRules);
    }
  };
  walk(sheet.cssRules);
}
assert(focusRules.length > 0, "Add a :focus-visible rule for the CTA links.");
const ring = focusRules.some((rule) =>
  (rule.style.outlineStyle !== "none" && parseFloat(rule.style.outlineWidth) >= 2) ||
  (rule.style.boxShadow && rule.style.boxShadow !== "none")
);
assert(ring, "The focus state needs a visible ring at least 2px thick.");
assertNoOverflow("The hero should not make the page scroll sideways.");
--- hint
Add `<p class="lede">…</p>` under the headline, then a `.actions` paragraph with two anchors.
--- hint
The primary link goes to `#signup`; the secondary goes to `#features`. Give them classes `button-primary` and `button-secondary`.
--- hint
Fill the primary with forest green and white text. Give the secondary a transparent background and a 1px border. Add a shared `:focus-visible` outline in amber.
```

## Features are proof, not a specification sheet

A feature section is not the place to list everything the product can do. It is the place to answer the doubts raised by the headline. If Fieldnote promises to work without a signal, the first card should explain offline notes. If it promises to remember where you were, the second should explain coordinates. If it promises to be quiet, the third should explain syncing without a feed. Three cards, three doubts.

Each card follows the same shape: an icon, a short heading and two sentences. The icon is decorative, so it is hidden from assistive technology; the heading carries the meaning. Keep the stroke weight and icon size consistent, or the row starts to look assembled from different kits. A 28px icon in the amber accent is enough. It should support the heading, not replace it.

The grid is the same mobile-first pattern as the profile page: one column, two at `40rem`, three at `60rem`. Grid stretches the cards to equal height, so the descriptions can differ in length without leaving a ragged bottom edge. The icon, heading and paragraph stack inside each card with a simple block flow; no Flexbox is needed because there is nothing to distribute.

```html run
<section id="features" class="features wrap" aria-labelledby="features-title">
  <p class="eyebrow">Why Fieldnote</p>
  <h2 id="features-title">Built for weather and map margins</h2>
  <p class="lede">Three small decisions that matter when the path is longer than planned.</p>
  <div class="feature-grid">
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v12m0 0 4-4m-4 4-4-4M5 21h14"/></svg>
      <h3>Offline by default</h3>
      <p>Every note and map tile is stored on your phone. Airplane mode is not an error state.</p>
    </article>
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s7-6.2 7-12a7 7 0 1 0-14 0c0 5.8 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></svg>
      <h3>Coordinates that keep</h3>
      <p>Drop a pin with one thumb. Fieldnote records the grid reference, altitude and time.</p>
    </article>
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12a8 8 0 0 1 13.5-5.8L20 8M20 12a8 8 0 0 1-13.5 5.8L4 16"/><path d="M20 3v5h-5M4 21v-5h5"/></svg>
      <h3>One notebook, every device</h3>
      <p>Changes sync when you next have signal. There is no feed, no streak and no notification.</p>
    </article>
  </div>
</section>
<style>
  :root { --ink: #1c2a24; --muted: #5b665e; --paper: #f6f3ec; --card: #fffdf6; --line: #d8d2c4; --forest: #1f4d3a; --amber: #b45309; }
  * { box-sizing: border-box; }
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: var(--paper); }
  .wrap { max-width: 72rem; margin-inline: auto; }
  .eyebrow { margin: 0 0 0.5rem; color: var(--amber); font-size: 0.75rem; font-weight: 750; letter-spacing: 0.14em; text-transform: uppercase; }
  h2 { margin: 0; font-family: Georgia, serif; font-size: clamp(1.8rem, 4vw, 2.6rem); font-weight: 500; letter-spacing: -0.03em; }
  .lede { max-width: 52ch; margin: 0.6rem 0 1.75rem; color: var(--muted); }
  .feature-grid { display: grid; gap: 1rem; }
  .feature { padding: 1.5rem; border: 1px solid var(--line); border-radius: 18px; background: var(--card); }
  .feature svg { width: 28px; height: 28px; color: var(--amber); }
  .feature h3 { margin: 1rem 0 0.4rem; font-size: 1.1rem; }
  .feature p { margin: 0; color: var(--muted); }
  @media (min-width: 40rem) { .feature-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .feature-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
```

> **Pitfall:** An icon with no text label is not a feature. It is a guessing game. If the icon is the only content, give it an accessible name with `role="img"` and a `<title>`; if there is a heading beside it, mark the icon decorative and let the heading do the work. Do not leave an SVG announced as an unlabelled graphic.

## Challenge: the three-card feature grid

Build three feature cards inside `.feature-grid`. Each `.feature` needs a decorative inline SVG, an `<h3>` and a short paragraph. Use the three claims from the lesson: offline notes, saved coordinates and syncing. The grid must be one column by default, two at `40rem` and three at `60rem`.

```html exercise id=feature-grid title="Build the feature grid"
<section id="features" class="wrap" aria-labelledby="features-title">
  <h2 id="features-title">Built for weather and map margins</h2>
  <div class="feature-grid">
    <!-- TODO: add three .feature articles with an icon, h3 and p -->
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; line-height: 1.6; }
  .wrap { max-width: 72rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-family: Georgia, serif; font-weight: 500; font-size: 2rem; }
  .feature-grid { display: grid; gap: 1rem; }
  .feature { padding: 1.5rem; border: 1px solid #d8d2c4; border-radius: 18px; background: #fffdf6; }
  .feature svg { width: 28px; height: 28px; color: #d97706; }
  .feature h3 { margin: 1rem 0 0.4rem; }
  .feature p { margin: 0; color: #5b665e; }
  @media (min-width: 40rem) { .feature-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .feature-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
--- solution
<section id="features" class="wrap" aria-labelledby="features-title">
  <h2 id="features-title">Built for weather and map margins</h2>
  <div class="feature-grid">
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v12m0 0 4-4m-4 4-4-4M5 21h14"/></svg>
      <h3>Offline by default</h3>
      <p>Every note and map tile is stored on your phone. Airplane mode is not an error state.</p>
    </article>
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s7-6.2 7-12a7 7 0 1 0-14 0c0 5.8 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></svg>
      <h3>Coordinates that keep</h3>
      <p>Drop a pin with one thumb. Fieldnote records the grid reference, altitude and time.</p>
    </article>
    <article class="feature">
      <svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12a8 8 0 0 1 13.5-5.8L20 8M20 12a8 8 0 0 1-13.5 5.8L4 16"/><path d="M20 3v5h-5M4 21v-5h5"/></svg>
      <h3>One notebook, every device</h3>
      <p>Changes sync when you next have signal. There is no feed, no streak and no notification.</p>
    </article>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; line-height: 1.6; }
  .wrap { max-width: 72rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-family: Georgia, serif; font-weight: 500; font-size: 2rem; }
  .feature-grid { display: grid; gap: 1rem; }
  .feature { padding: 1.5rem; border: 1px solid #d8d2c4; border-radius: 18px; background: #fffdf6; }
  .feature svg { width: 28px; height: 28px; color: #d97706; }
  .feature h3 { margin: 1rem 0 0.4rem; }
  .feature p { margin: 0; color: #5b665e; }
  @media (min-width: 40rem) { .feature-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .feature-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
--- test
assertExists("#features", "Keep the features section.");
assert(query("#features h2"), "Give the features section an h2 heading.");
assertCount("#features .feature", 3, "The feature grid needs exactly three cards.");
for (const [index, card] of [...document.querySelectorAll("#features .feature")].entries()) {
  const icon = card.querySelector("svg");
  assert(icon, `Feature ${index + 1} needs an inline SVG icon.`);
  assert(icon.getAttribute("aria-hidden") === "true" || icon.getAttribute("role") === "presentation", `Feature ${index + 1}'s decorative icon should be hidden from assistive technology.`);
  assert(card.querySelector("h3"), `Feature ${index + 1} needs an h3 heading.`);
  assert(card.querySelector("p"), `Feature ${index + 1} needs a short description.`);
}
const grid = query(".feature-grid");
assertStyle(".feature-grid", "display", "grid", "Lay the feature cards out with CSS Grid.");
const columns = getComputedStyle(grid).gridTemplateColumns.split(" ").filter(Boolean);
assert(columns.length === 3, `At this width the grid should show three columns; it currently has ${columns.length}.`);
assert(parseFloat(getComputedStyle(grid).gap) >= 8, "Add a visible gap between the cards.");
assertNoOverflow("The feature grid should not make the page scroll sideways.");
--- hint
Use three `<article class="feature">` elements. Each one starts with an inline `<svg aria-hidden="true" …>`, then an `<h3>`, then a `<p>`.
--- hint
The starter already has the grid and the media queries. You only need to supply the three cards.
--- hint
A simple icon path is `<path d="M12 3v12m0 0 4-4m-4 4-4-4M5 21h14"/>` with `fill="none"` and `stroke="currentColor"`.
```

## Pricing lowers the risk

Pricing is reassurance, not a table of numbers. The visitor wants to know what it costs, what they get, and what happens if they choose wrong. Answer in plain language: "£4 per month" beats "£3.99/mo billed annually". A free plan is a real answer, not a trick. If there is a trial, say how long it lasts and whether a card is required.

Three plans are plenty for this page. The middle plan is featured because it is the one most people should consider, but it is not the only one that works. The badge says "Most popular" in words, not just a different border colour, so the emphasis survives greyscale and colour-vision differences. The featured card gets a stronger border and shadow, not a louder background that would break the reading rhythm.

Inside each card, the price is the visual anchor: a large serif numeral, a small unit beside it. The feature list stays short and concrete. The call to action sits at the bottom of every card, aligned by `margin-top: auto` because the cards are Flexbox columns. On a phone the cards stack; at `48rem` they become three columns. The layout is a grid, so a long feature list does not make one card taller than its neighbours.

```html run
<section id="pricing" class="pricing wrap" aria-labelledby="pricing-title">
  <p class="eyebrow">Pricing</p>
  <h2 id="pricing-title">Pay for the trail, not the seats.</h2>
  <p class="lede">Start free. Upgrade when the notebook earns it.</p>
  <div class="plans">
    <article class="plan">
      <h3>Cabin</h3>
      <p class="price"><strong>£0</strong> <span>forever</span></p>
      <ul><li>One notebook</li><li>Offline notes</li><li>Export anytime</li></ul>
      <a href="#signup">Start free</a>
    </article>
    <article class="plan featured">
      <p class="badge">Most popular</p>
      <h3>Trail</h3>
      <p class="price"><strong>£4</strong> <span>per month</span></p>
      <ul><li>Unlimited notebooks</li><li>Coordinates and photos</li><li>Sync on three devices</li></ul>
      <a href="#signup">Choose Trail</a>
    </article>
    <article class="plan">
      <h3>Expedition</h3>
      <p class="price"><strong>£9</strong> <span>per month</span></p>
      <ul><li>Everything in Trail</li><li>Shared trip notebooks</li><li>Longer map history</li></ul>
      <a href="#signup">Choose Expedition</a>
    </article>
  </div>
</section>
<style>
  :root { --ink:#1c2a24; --muted:#5b665e; --paper:#f6f3ec; --card:#fffdf6; --line:#d8d2c4; --forest:#1f4d3a; --amber:#b45309; --amber-bright:#d97706; } * { box-sizing:border-box; }
  body { margin:0; padding:3rem 1.5rem; font-family:system-ui,sans-serif; line-height:1.6; color:var(--ink); background:var(--paper); } .wrap { max-width:72rem; margin-inline:auto; }
  .eyebrow { margin:0 0 .5rem; color:var(--amber); font-size:.75rem; font-weight:750; letter-spacing:.14em; text-transform:uppercase; } h2 { margin:0; font-family:Georgia,serif; font-size:clamp(1.8rem,4vw,2.6rem); font-weight:500; letter-spacing:-.03em; }
  .lede { max-width:52ch; margin:.6rem 0 1.75rem; color:var(--muted); } .plans { display:grid; gap:1rem; }
  .plan { display:flex; flex-direction:column; padding:1.5rem; border:1px solid var(--line); border-radius:20px; background:var(--card); }
  .plan.featured { border-color:var(--forest); box-shadow:0 16px 40px rgb(31 77 58 / .12); } .badge { align-self:flex-start; margin:0 0 .75rem; padding:.2rem .5rem; border-radius:999px; background:var(--amber-bright); color:#2b1a03; font-size:.68rem; font-weight:750; letter-spacing:.08em; text-transform:uppercase; }
  .price { margin:.25rem 0 1rem; } .price strong { font-family:Georgia,serif; font-size:2.5rem; font-weight:500; letter-spacing:-.04em; } .price span { color:var(--muted); font-size:.85rem; }
  .plan ul { margin:0 0 1.25rem; padding-left:1.1rem; color:var(--muted); } .plan a { margin-top:auto; color:var(--forest); font-weight:650; }
  @media (min-width:48rem) { .plans { grid-template-columns:repeat(3,1fr); } }
</style>
```

> **Pitfall:** Do not make the featured plan the only one with a working link, and do not use a different button label for the same action. Consistency is part of trust. If every plan leads to the same signup, every link can say what happens next in the same way.

## Predict: the row that will not shrink

Read this before running it. The container is 420px wide. Each card has a flex basis of 180px and a shrink factor of 0. What happens when the cards do not fit?

```html predict id=pricing-row-overflow title="What happens to the pricing row?"
<div class="plans">
  <article class="plan">Cabin</article>
  <article class="plan">Trail</article>
  <article class="plan">Expedition</article>
</div>
<style>
  body { margin: 0; padding: 3rem; font-family: system-ui, sans-serif; }
  .plans { display: flex; gap: 12px; width: 420px; }
  .plan { flex: 1 0 180px; padding: 16px; border: 1px solid #cbd5e1; background: #fff; }
</style>
--- options
* The cards stay at least 180px wide and the row overflows horizontally
The cards shrink to 132px each and fit the row
The cards wrap onto a second line
The third card is hidden to make room
--- explain
`flex: 1 0 180px` means grow: 1, shrink: 0, basis: 180px. With three cards that is 540px of basis plus 24px of gaps, which is more than the 420px container. Because shrinking is forbidden, the items keep their width and overflow the row. If the container is the page body, this is exactly how a landing page develops a horizontal scrollbar on a phone. The fix is to allow wrapping (`flex-wrap: wrap`) or use a grid that can change its column count; shrinking alone would make the cards too narrow to read.
```

## Debug: the pricing row that overflows

This pricing section looks correct on a wide preview. Narrow the preview to phone width and the three cards stay in one row, pushing the third card off the screen. The page gains a horizontal scrollbar. Find the layout rule that prevents the cards from wrapping and fix it without changing the content.

```html debug id=pricing-overflow title="Fix the pricing row on narrow screens"
<section id="pricing" class="wrap" aria-labelledby="pricing-title">
  <h2 id="pricing-title">Simple plans for every trail</h2>
  <div class="plans">
    <article class="plan"><h3>Cabin</h3><p class="price">£0</p><a href="#signup">Start free</a></article>
    <article class="plan"><h3>Trail</h3><p class="price">£4</p><a href="#signup">Choose Trail</a></article>
    <article class="plan"><h3>Expedition</h3><p class="price">£9</p><a href="#signup">Choose Expedition</a></article>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; }
  .wrap { max-width: 72rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-family: Georgia, serif; font-weight: 500; }
  .plans { display: flex; gap: 1rem; }
  .plan { flex: 0 0 300px; padding: 1.5rem; border: 1px solid #d8d2c4; border-radius: 20px; background: #fffdf6; }
  .plan h3, .plan p { margin: 0 0 0.75rem; }
  .plan a { color: #1f4d3a; font-weight: 650; }
</style>
--- solution
<section id="pricing" class="wrap" aria-labelledby="pricing-title">
  <h2 id="pricing-title">Simple plans for every trail</h2>
  <div class="plans">
    <article class="plan"><h3>Cabin</h3><p class="price">£0</p><a href="#signup">Start free</a></article>
    <article class="plan"><h3>Trail</h3><p class="price">£4</p><a href="#signup">Choose Trail</a></article>
    <article class="plan"><h3>Expedition</h3><p class="price">£9</p><a href="#signup">Choose Expedition</a></article>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #1c2a24; background: #f6f3ec; }
  .wrap { max-width: 72rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-family: Georgia, serif; font-weight: 500; }
  .plans { display: flex; flex-wrap: wrap; gap: 1rem; }
  .plan { flex: 1 1 240px; padding: 1.5rem; border: 1px solid #d8d2c4; border-radius: 20px; background: #fffdf6; }
  .plan h3, .plan p { margin: 0 0 0.75rem; }
  .plan a { color: #1f4d3a; font-weight: 650; }
</style>
--- test
assertExists(".plans", "Keep the row of plan cards.");
assertCount(".plans .plan", 3, "The pricing section should keep all three plans.");
for (const [index, plan] of [...document.querySelectorAll(".plans .plan")].entries()) {
  assert(plan.querySelector("h3"), `Plan ${index + 1} needs an h3 name.`);
  const link = plan.querySelector("a[href]");
  assert(link, `Plan ${index + 1} needs a link.`);
  assert(normalize(link.textContent).length > 0, `Plan ${index + 1}'s link needs a visible name.`);
}
const plans = query(".plans");
const clone = plans.cloneNode(true);
const frame = document.createElement("div");
frame.style.width = "360px";
frame.style.maxWidth = "360px";
document.body.appendChild(frame);
frame.appendChild(clone);
const cloneStyle = getComputedStyle(clone);
assert(cloneStyle.display === "flex" || cloneStyle.display === "grid", "Keep the plans in a Flexbox or Grid layout.");
assert(cloneStyle.display === "grid" || cloneStyle.flexWrap === "wrap", "At narrow widths the plan cards should wrap onto more rows instead of staying in one row.");
const overflow = Math.round(clone.scrollWidth - clone.clientWidth);
assert(overflow <= 1, `At 360px wide, the plan row overflows by ${overflow}px. Let the cards wrap or use a grid that changes columns.`);
frame.remove();
assertNoOverflow("The pricing section should not make the page scroll sideways at desktop width.");
--- hint
The wide layout is fine. The problem is what happens when 3 × 300px plus gaps is wider than the screen.
--- hint
Add `flex-wrap: wrap` to `.plans`, and change `.plan` to `flex: 1 1 240px` so the cards can grow and shrink.
--- hint
A grid is also valid: `display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));` on `.plans`. The test accepts either solution.
```

## Signup: the smallest honest form

Every field is a reason to leave. This page needs an email address and nothing else. The label is visible, not a placeholder that disappears when someone types. The input uses `type="email"` for the @ key on mobile, `autocomplete="email"` for password managers, and `required` so the browser catches an empty submission. Help text is connected with `aria-describedby`, so a screen reader announces it with the field.

The submit button says what happens next: "Create my notebook", not "Submit". It is a real `<button type="submit">` inside the form, because it submits data. The CTA links elsewhere on the page are anchors, because they navigate. This distinction is invisible to most visitors and essential to everyone using a keyboard, a screen reader or a browser's form autofill.

The layout is a small Flexbox form: the field grows, the button keeps its natural width, and `flex-wrap` stacks them when the line gets tight. The input uses a 1rem font size so iOS does not zoom the page when it receives focus. The focus ring is a light amber that contrasts against the dark forest panel. Nothing here depends on JavaScript; the browser's native validation is the first pass, and the server must still validate the address.

```html run
<section id="signup" class="signup" aria-labelledby="signup-title">
  <div class="signup-inner wrap">
    <p class="eyebrow">Start here</p>
    <h2 id="signup-title">One page is enough.</h2>
    <p class="lede">Create a free notebook and take it on the next walk. No card, no feed.</p>
    <form class="signup-form" action="#" method="post">
      <div class="field">
        <label for="email">Email address</label>
        <input id="email" name="email" type="email" autocomplete="email" required placeholder="you@example.com" aria-describedby="email-help">
        <p class="help" id="email-help">One email a month. Unsubscribe anytime.</p>
      </div>
      <button class="button" type="submit">Create my notebook</button>
    </form>
  </div>
</section>
<style>
  :root { --ink: #1c2a24; --paper: #f6f3ec; --forest: #1f4d3a; --amber: #b45309; --amber-bright: #d97706; }
  * { box-sizing: border-box; }
  body { margin: 0; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: var(--paper); }
  .wrap { width: min(100% - 2rem, 72rem); margin-inline: auto; }
  .signup { background: var(--forest); color: #e8efe9; }
  .signup-inner { padding-block: clamp(2.5rem, 7vw, 5rem); }
  .eyebrow { margin: 0 0 0.5rem; color: #f5d7a1; font-size: 0.75rem; font-weight: 750; letter-spacing: 0.14em; text-transform: uppercase; }
  h2 { margin: 0; color: #fff; font-family: Georgia, serif; font-size: clamp(2rem, 5vw, 3.2rem); font-weight: 500; letter-spacing: -0.03em; }
  .lede { max-width: 48ch; margin: 0.65rem 0 0; color: #c9d6cc; }
  .signup-form { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 1rem; margin-top: 1.75rem; }
  .field { flex: 1 1 18rem; }
  label { display: block; margin-bottom: 0.4rem; color: #fff; font-size: 0.85rem; font-weight: 650; }
  input { width: 100%; padding: 0.8rem 0.9rem; border: 1px solid #9db2a3; border-radius: 10px; background: #fffdf6; color: var(--ink); font: inherit; font-size: 1rem; }
  input:focus-visible { outline: 3px solid #fcd34d; outline-offset: 3px; }
  .help { margin: 0.45rem 0 0; color: #c9d6cc; font-size: 0.78rem; }
  .button { padding: 0.8rem 1.2rem; border: 0; border-radius: 999px; background: var(--amber-bright); color: #2b1a03; font: inherit; font-weight: 700; cursor: pointer; transition: background-color 160ms ease, transform 160ms ease; }
  .button:hover { background: #f59e0b; transform: translateY(-2px); }
  .button:focus-visible { outline: 3px solid #fcd34d; outline-offset: 3px; }
</style>
```

> **Pitfall:** A placeholder is not a label. It disappears as soon as the field has content, it often fails contrast, and it is not reliably announced as the field's name. Keep the `<label>` visible and use the placeholder only for an example, as here. On a dark panel, make sure the input itself stays light; dark-on-dark form fields are a common contrast failure.

## The finished page

The final page combines every stage: the hero promises, the features prove, the pricing removes uncertainty, and the signup asks for one thing. The footer closes quietly. The system stays consistent: warm paper, forest green, amber highlights, serif display and UI body faces, `clamp()` spacing and a small set of radii.

```html run
<header class="site-header wrap"><a class="brand" href="#top">Fieldnote</a><nav aria-label="Primary"><a href="#features">Features</a><a href="#pricing">Pricing</a><a href="#signup">Start free</a></nav></header><main id="top">
  <section class="hero wrap" aria-labelledby="hero-title">
    <div><p class="eyebrow">Notes for the long way round</p><h1 id="hero-title">Keep the trail in your pocket.</h1><p class="lede">Fieldnote is a quiet notebook for hikes: offline maps, coordinates, and the name of that bothy you almost missed.</p><p class="actions"><a class="button primary" href="#signup">Start a free notebook</a><a class="button secondary" href="#features">See how it works</a></p></div>
    <div class="art" aria-hidden="true"><svg viewBox="0 0 420 340" role="presentation"><rect width="420" height="340" rx="28" fill="#e7e1d3"/><path d="M20 280 C100 220 160 310 250 250 S370 200 410 230" fill="none" stroke="#a8b5a0" stroke-width="2"/><rect x="96" y="72" width="228" height="196" rx="18" fill="#fffdf6" stroke="#d8d2c4"/><path d="M124 120h172M124 150h140M124 180h160" stroke="#c9c0ae" stroke-width="6" stroke-linecap="round"/><circle cx="286" cy="226" r="13" fill="#d97706"/></svg></div></section>
  <section id="features" class="wrap" aria-labelledby="features-title"><p class="eyebrow">Why Fieldnote</p><h2 id="features-title">Built for weather and map margins</h2>
    <div class="feature-grid">
      <article class="feature"><svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M12 3v12m0 0 4-4m-4 4-4-4M5 21h14"/></svg><h3>Offline by default</h3><p>Every note and map tile is stored on your phone. Airplane mode is not an error state.</p></article>
      <article class="feature"><svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M12 21s7-6.2 7-12a7 7 0 1 0-14 0c0 5.8 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></svg><h3>Coordinates that keep</h3><p>Drop a pin with one thumb. Fieldnote records the grid reference, altitude and time.</p></article>
      <article class="feature"><svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M4 12a8 8 0 0 1 13.5-5.8L20 8M20 12a8 8 0 0 1-13.5 5.8L4 16"/><path d="M20 3v5h-5M4 21v-5h5"/></svg><h3>One notebook, every device</h3><p>Changes sync when you next have signal. There is no feed, no streak and no notification.</p></article>
    </div></section>
  <section id="pricing" class="wrap" aria-labelledby="pricing-title"><p class="eyebrow">Pricing</p><h2 id="pricing-title">Pay for the trail, not the seats.</h2>
    <div class="plans">
      <article class="plan"><h3>Cabin</h3><p class="price"><strong>£0</strong> <span>forever</span></p><ul><li>One notebook</li><li>Offline notes</li><li>Export anytime</li></ul><a href="#signup">Start free</a></article>
      <article class="plan featured"><p class="badge">Most popular</p><h3>Trail</h3><p class="price"><strong>£4</strong> <span>per month</span></p><ul><li>Unlimited notebooks</li><li>Coordinates and photos</li><li>Sync on three devices</li></ul><a href="#signup">Choose Trail</a></article>
      <article class="plan"><h3>Expedition</h3><p class="price"><strong>£9</strong> <span>per month</span></p><ul><li>Everything in Trail</li><li>Shared trip notebooks</li><li>Longer map history</li></ul><a href="#signup">Choose Expedition</a></article>
    </div></section>
  <section id="signup" class="signup" aria-labelledby="signup-title"><div class="signup-inner wrap"><p class="eyebrow">Start here</p><h2 id="signup-title">One page is enough.</h2>
      <form class="signup-form" action="#" method="post"><div class="field"><label for="email">Email address</label><input id="email" name="email" type="email" autocomplete="email" required aria-describedby="email-help"><p class="help" id="email-help">One email a month. Unsubscribe anytime.</p></div><button class="button" type="submit">Create my notebook</button></form>
    </div></section>
</main><footer class="footer wrap"><p>© 2026 Fieldnote · Made for the long way round.</p><a href="#top">Back to top</a></footer>
<style>
  :root { --ink:#1c2a24; --muted:#5b665e; --paper:#f6f3ec; --card:#fffdf6; --line:#d8d2c4; --forest:#1f4d3a; --amber:#b45309; --amber-bright:#d97706; --text-sm:.75rem; --text-body:1rem; --text-lead:clamp(1.05rem,2vw,1.2rem); --text-h2:clamp(1.8rem,4vw,2.6rem); --text-display:clamp(2.6rem,7vw,5rem); } * { box-sizing:border-box; }
  body { margin:0; font-family:system-ui,sans-serif; line-height:1.6; color:var(--ink); background:var(--paper); } .wrap { width:min(100% - 2rem,72rem); margin-inline:auto; } a { color:var(--forest); } :focus-visible { outline:3px solid var(--amber); outline-offset:3px; }
  .site-header { display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:1rem; padding-block:1.25rem; border-bottom:1px solid var(--line); }
  .brand { color:var(--ink); font-weight:750; text-decoration:none; } nav { display:flex; gap:1rem; font-size:.9rem; font-weight:600; } nav a { color:var(--ink); text-decoration:none; } nav a:hover { color:var(--forest); text-decoration:underline; text-underline-offset:4px; }
  .hero { display:grid; gap:2rem; align-items:center; padding-block:clamp(2.5rem,8vw,6rem); } .eyebrow { margin:0 0 .6rem; color:var(--amber); font-size:var(--text-sm); font-weight:750; letter-spacing:.14em; text-transform:uppercase; }
  h1 { margin:0; font-family:Georgia,serif; font-size:var(--text-display); line-height:.98; letter-spacing:-.04em; font-weight:500; } .lede { max-width:46ch; margin:1.1rem 0 0; color:var(--muted); font-size:var(--text-lead); }
  .actions { display:flex; flex-wrap:wrap; gap:.75rem; margin-top:1.5rem; } .button { display:inline-flex; align-items:center; justify-content:center; padding:.8rem 1.2rem; border:1px solid transparent; border-radius:999px; font:inherit; font-weight:650; text-decoration:none; transition:transform 160ms ease,background-color 160ms ease; }
  .primary { background:var(--forest); color:#fff; } .secondary { border-color:var(--line); color:var(--ink); background:transparent; } .primary:hover { background:#163b2c; transform:translateY(-2px); } .secondary:hover { background:#ece7db; border-color:var(--forest); transform:translateY(-2px); } .primary:focus-visible,.secondary:focus-visible { outline:3px solid var(--amber); outline-offset:3px; }
  .art svg { display:block; width:100%; height:auto; } section.wrap { padding-block:clamp(2.5rem,7vw,5rem); } h2 { margin:0; font-family:Georgia,serif; font-size:var(--text-h2); font-weight:500; letter-spacing:-.03em; }
  .feature-grid { display:grid; gap:1rem; margin-top:1.5rem; } .feature { padding:1.5rem; border:1px solid var(--line); border-radius:18px; background:var(--card); } .feature svg { width:28px; height:28px; color:var(--amber); } .feature h3 { margin:1rem 0 .4rem; } .feature p { margin:0; color:var(--muted); }
  .plans { display:grid; gap:1rem; margin-top:1.5rem; } .plan { display:flex; flex-direction:column; padding:1.5rem; border:1px solid var(--line); border-radius:20px; background:var(--card); } .plan.featured { border-color:var(--forest); box-shadow:0 16px 40px rgb(31 77 58 / .12); } .badge { align-self:flex-start; margin:0 0 .75rem; padding:.2rem .5rem; border-radius:999px; background:var(--amber-bright); color:#2b1a03; font-size:.68rem; font-weight:750; text-transform:uppercase; } .price { margin:.25rem 0 1rem; } .price strong { font-family:Georgia,serif; font-size:2.5rem; font-weight:500; } .price span { color:var(--muted); font-size:.85rem; } .plan ul { margin:0 0 1.25rem; padding-left:1.1rem; color:var(--muted); } .plan a { margin-top:auto; color:var(--forest); font-weight:650; }
  .signup { background:var(--forest); color:#e8efe9; } .signup-inner { padding-block:clamp(2.5rem,7vw,5rem); } .signup h2 { color:#fff; } .signup .eyebrow { color:#f5d7a1; } .signup-form { display:flex; flex-wrap:wrap; align-items:flex-end; gap:1rem; margin-top:1.5rem; } .field { flex:1 1 18rem; } label { display:block; margin-bottom:.4rem; color:#fff; font-size:.85rem; font-weight:650; } input { width:100%; padding:.8rem .9rem; border:1px solid #9db2a3; border-radius:10px; background:#fffdf6; color:var(--ink); font:inherit; font-size:var(--text-body); } .help { margin:.45rem 0 0; color:#c9d6cc; font-size:.78rem; } .signup .button { background:var(--amber-bright); color:#2b1a03; cursor:pointer; } .signup .button:hover { background:#f59e0b; } .signup input:focus-visible,.signup .button:focus-visible { outline:3px solid #fcd34d; outline-offset:3px; }
  .footer { display:flex; flex-wrap:wrap; justify-content:space-between; gap:1rem; padding-block:2rem; color:var(--muted); font-size:.85rem; } .footer p { margin:0; }
  @media (min-width:40rem) { .feature-grid { grid-template-columns:repeat(2,1fr); } } @media (min-width:52rem) { .hero { grid-template-columns:1.15fr .85fr; } } @media (min-width:60rem) { .feature-grid,.plans { grid-template-columns:repeat(3,1fr); } }
</style>
```

The final cell is long because it is a complete page, not because the CSS is complicated. Read it in sections: tokens at the top, layout primitives next, then hero, features, pricing, signup and media queries. In a real project each section would live in its own file; in a lesson, keeping it in one place lets you see the whole system at once.

What makes it feel finished is not any single rule. It is the consistency: every section shares the same container width, every card shares the same border language, every heading uses the same serif, every interactive element uses the same amber focus ring, and every spacing value comes from the same rhythm. The responsive layer only changes column counts; the hierarchy survives at every width.

## Recap

- A landing page is an argument: promise, proof, price, action. Each section should earn its place.
- The hero needs one clear promise, one specific subhead and one primary action. Secondary actions should be visibly quieter.
- Features answer the doubts raised by the headline. Three specific cards beat a long list.
- Pricing should be plain, comparable and honest. Make the recommended plan clear in words, not colour alone.
- A signup form needs a visible label, the right input type, autocomplete, a specific submit label and a focus state. Validate on the server too.
- A design system is a small set of decisions repeated consistently: palette, type scale, spacing, radii, motion and focus.
- Mobile-first layout starts with the narrow composition and adds columns only when the content has room.

**Up next:** the final exam. You have the structure, the styling and the two capstones; the quiz checks the decisions behind them — semantics, the box model, layout, responsive behaviour, accessibility and the cascade.
