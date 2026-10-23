Accessibility is often described as a set of extra features: a skip link here, an ARIA label there, a contrast check before launch. In practice, most of it comes from using the elements you already have, correctly. A real `<button>` is keyboard-operable before you write a line of JavaScript. A proper heading order gives a screen reader a table of contents for free. A `<label>` connected to the right input is the difference between a form that works with a screen reader and one that reads like an unlabelled box.

This lesson is an audit. You will look at a page the way assistive technology sees it: the document language, landmarks, heading order, link text, image descriptions, form labels, keyboard focus and contrast. Then you will fix the failures that are invisible in a screenshot but obvious the moment someone navigates without a mouse.

## Start with language and landmarks

The `<html lang="en">` attribute tells a screen reader which language rules to use for pronunciation. Without it, a page may be read with the wrong accent or the wrong dictionary. The value should be the language of the content, not the country where the server runs.

Landmarks are the second layer. `<header>`, `<nav>`, `<main>` and `<footer>` give the page a structure that assistive technology can jump between. A skip link lets a keyboard user jump past a long navigation to the main content. It should be the first focusable thing on the page, and it should appear when it receives focus.

```html run
<!doctype html>
<html lang="en">
  <head>
    <title>Fern &amp; Field</title>
    <style>
      body { margin: 0; font-family: system-ui, sans-serif; color: #1e293b; }
      .skip-link { position: fixed; top: -5rem; left: 1rem; padding: 0.7rem 1rem; border-radius: 0 0 8px 8px; background: #0f172a; color: white; font-weight: 600; }
      .skip-link:focus { top: 0; }
      .site-header { display: flex; justify-content: space-between; align-items: center; padding: 1rem 2rem; border-bottom: 1px solid #e2e8f0; }
      .brand { margin: 0; font-weight: 700; }
      nav a { margin-left: 1rem; color: #0f766e; font-weight: 600; }
      nav a[aria-current="page"] { color: #0f172a; text-decoration: none; }
      main { max-width: 40rem; margin: 3rem auto; padding: 0 1.5rem; }
      h1 { margin: 0 0 0.75rem; font-size: 2.4rem; letter-spacing: -0.03em; }
      footer { padding: 1.5rem 2rem; border-top: 1px solid #e2e8f0; color: #64748b; }
    </style>
  </head>
  <body>
    <a class="skip-link" href="#main">Skip to main content</a>
    <header class="site-header">
      <p class="brand">Fern &amp; Field</p>
      <nav aria-label="Primary">
        <a href="#shop">Shop</a>
        <a href="#journal" aria-current="page">Journal</a>
        <a href="#visit">Visit</a>
      </nav>
    </header>
    <main id="main" tabindex="-1">
      <h1>Journal</h1>
      <p>Notes from the nursery, written between waterings.</p>
    </main>
    <footer>
      <p>Open Thursday to Sunday, 9am–4pm.</p>
    </footer>
  </body>
</html>
```

The skip link is visually hidden by moving it above the viewport, not with `display: none`. A hidden-with-display link cannot receive focus. When it is focused, `top: 0` brings it into view. The `tabindex="-1"` on `<main>` is what lets the link move focus to the main content, not just scroll to it. Negative tabindex makes an element programmatically focusable without adding it to the normal Tab order.

The `aria-current="page"` on the Journal link is one of the few ARIA attributes worth adding by hand: it tells assistive technology which link represents the current page. The `aria-label="Primary"` on the nav is useful because a page can have several navigation regions, and "Primary" distinguishes this one from a footer nav or a breadcrumb.

## Headings are a map

Screen reader users often navigate by heading, jumping from section to section instead of reading every paragraph. That only works if the headings describe the actual outline: one `<h1>` for the page, `<h2>` for major sections, `<h3>` for subsections. Skipping from `h1` to `h4` because `h4` happens to be the size you want breaks the map.

```html run
<article>
  <h1>Repotting a fern</h1>
  <p>A fern that has outgrown its pot tells you in yellow leaves and roots at the surface.</p>
  <p>New to this? <a href="#guide">Read the full repotting guide</a> before you start.</p>

  <h2>What you need</h2>
  <ul>
    <li>A pot one size larger</li>
    <li>Free-draining compost</li>
    <li>Something to cover the table</li>
  </ul>

  <h3>Choosing a pot</h3>
  <p>Too much extra soil stays wet and rots the roots. One size up is enough.</p>

  <h2>Aftercare</h2>
  <p>Water thoroughly, then leave the fern in indirect light for a week.</p>
</article>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; line-height: 1.6; }
  article { max-width: 38rem; }
  h1 { font-size: 2.2rem; letter-spacing: -0.03em; }
  h2 { margin-top: 2rem; }
  h3 { margin-top: 1.5rem; }
  a { color: #0f766e; font-weight: 600; }
</style>
```

The link text here is "Read the full repotting guide". Out of context — in a list of links that a screen reader can announce — it still says what it does. "Click here" or "Read more" does not. If a design needs a short visible label, the surrounding sentence or an `aria-label` can supply the missing context, but visible specific text is almost always better.

> **Tip:** Open a page and read only its headings. If the result sounds like a coherent outline, the heading structure is doing its job. If it sounds like a list of font sizes, fix the levels before touching the CSS.

## Images need a purpose

Every `<img>` needs an `alt` attribute, but the right value depends on why the image is there. A content image gets a description of what it shows and why it matters. A decorative image gets `alt=""`, which tells assistive technology to skip it. A logo inside a link gets alt text that names the destination, not the shape of the logo.

```html run
<figure>
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='360'%3E%3Crect width='640' height='360' fill='%23ecfdf5'/%3E%3Cpath d='M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260' fill='%230f766e'/%3E%3Cpath d='M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260' fill='%23134e4a'/%3E%3Cpath d='M280 240 L360 240 L345 330 L295 330 Z' fill='%23c2410c'/%3E%3C/svg%3E" alt="A fern with two green fronds in a terracotta pot" width="640" height="360">
  <figcaption>Two fronds, halfway through their first spring.</figcaption>
</figure>

<p>Our winter notes are below the divider.</p>
<img class="divider" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='8'%3E%3Crect width='640' height='8' fill='%23cbd5e1'/%3E%3C/svg%3E" alt="">

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  figure { margin: 0 0 1.5rem; max-width: 38rem; }
  img { display: block; width: 100%; height: auto; border-radius: 12px; }
  figcaption { margin-top: 0.5rem; color: #64748b; font-size: 0.9rem; }
  .divider { margin-top: 1.5rem; border-radius: 0; }
</style>
```

"Image of a fern" is not useful alt text; the word "image" adds nothing, and the description does not say what is happening. "A fern with two green fronds in a terracotta pot" gives someone who cannot see it the same information the picture carries. The divider is decorative: `alt=""` is correct, and adding `aria-hidden="true"` would be redundant.

> **Pitfall:** An empty `alt` is not the same as a missing `alt`. Missing alt makes a screen reader announce the file name, which is usually a string of numbers. Empty alt explicitly says "skip this image."

## Use the element that already does the job

A `<button>` is not just a styled rectangle. It is focusable with Tab, activates with Enter and Space, exposes a button role to assistive technology, and participates in forms correctly. A `<div>` with the same CSS has none of that. It looks like a button in a screenshot and behaves like a paragraph in real use.

```html run
<button class="action" type="button">Add to basket</button>
<div class="action fake">Add to basket</div>
<p class="note">The two controls look identical. Try reaching each one with Tab.</p>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  .action { display: inline-block; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  .action:focus-visible { outline: 3px solid #0f172a; outline-offset: 3px; }
  .fake { margin-left: 0.5rem; }
  .note { margin-top: 1rem; color: #64748b; font-size: 0.9rem; }
</style>
```

Only the first control is in the Tab order. Only the first one responds to the keyboard. Only the first one is announced as a button. This is the first rule of ARIA in action: if HTML already has an element for the job, use it. ARIA can describe a div as a button, but it cannot give the div the browser behaviour that a button gets for free.

```html predict id=accessible-button-predict title="Which one is announced as a button?"
<button class="action" type="button">Save</button>
<a class="action" href="#save">Save</a>
<div class="action">Save</div>
<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; }
  .action { display: inline-block; margin-right: 0.5rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; text-decoration: none; }
</style>
--- options
* Only the button element
Only the link, because it has an href
The button and the div with the button styling
All three, because they look the same
--- explain
A native `<button>` exposes the button role automatically. An `<a href>` exposes a link, even when it is styled to look like a button. The `<div>` has no role at all, so it is exposed as generic text. CSS changes appearance, not meaning. Adding `role="button"` to the div would change what assistive technology calls it, but the div would still lack the keyboard behaviour of a real button.
```

## ARIA fills gaps, it does not create semantics

ARIA is useful when HTML has no native element for the job: naming an icon-only button, describing a region, marking the current page in a set of links, or associating an error message with an input. It is not a substitute for the right element. `role="button"` on a div is a promise you then have to keep with keyboard handlers; a real button keeps it for you.

```html run
<nav aria-label="Breadcrumb">
  <ol>
    <li><a href="#home">Home</a></li>
    <li><a href="#journal">Journal</a></li>
    <li><a href="#ferns" aria-current="page">Ferns</a></li>
  </ol>
</nav>

<button class="icon-button" type="button" aria-label="Close the basket">
  <span aria-hidden="true">×</span>
</button>

<label for="postcode">Postcode</label>
<input id="postcode" name="postcode" aria-describedby="postcode-hint">
<p id="postcode-hint">We only deliver within 20 miles.</p>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  nav ol { display: flex; gap: 0.5rem; padding: 0; list-style: none; }
  nav a { color: #0f766e; font-weight: 600; }
  .icon-button { margin: 1.5rem 0; width: 2.5rem; height: 2.5rem; border: 1px solid #cbd5e1; border-radius: 50%; background: white; font-size: 1.25rem; cursor: pointer; }
  label { display: block; margin-bottom: 0.35rem; font-weight: 600; }
  input { width: 100%; max-width: 18rem; padding: 0.6rem 0.7rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  #postcode-hint { color: #64748b; font-size: 0.85rem; }
</style>
```

The breadcrumb nav has an `aria-label` because "Breadcrumb" is a useful name for that region. The icon button's visible content is a multiplication sign, which is meaningless as a name, so `aria-label="Close the basket"` supplies one; the `×` is decorative and hidden from assistive technology. The postcode input uses a real `<label for="postcode">`, so it has a name; `aria-describedby` then adds the delivery hint as extra context. A placeholder or a nearby paragraph would not give the field a name on its own. None of these are hacks around missing HTML; they are additions for cases HTML cannot express on its own.

> **Under the hood:** ARIA changes the accessibility tree, not the DOM. `role="button"` changes how a node is announced, but it does not add a click handler, a focus ring or Space/Enter activation. That gap is why the first rule exists: use the native element, then add ARIA only for the parts HTML does not cover.

## Contrast and focus are part of the content

Text needs enough contrast against its background to be readable. The usual threshold is 4.5:1 for normal text and 3:1 for large text (roughly 24px, or 18.7px bold) and for interface boundaries. A pale grey paragraph on white can look elegant in a mock-up and disappear on a laptop in daylight. Color is also not the only signal: an error that is only red is invisible to someone who cannot distinguish red from green.

```html run
<div class="panel">
  <p class="low">Low contrast: a pale grey on white.</p>
  <p class="high">High contrast: dark ink on white.</p>
  <p><a class="low-link" href="#notes">Read more</a> · <a class="high-link" href="#notes">Read more</a></p>
</div>
<button type="button">Tab to me</button>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; color: #1e293b; }
  .panel { max-width: 34rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 12px; background: white; }
  .low { color: #94a3b8; }
  .high { color: #1e293b; }
  .low-link { color: #94a3b8; }
  .high-link { color: #0f766e; font-weight: 600; }
  a:focus-visible, button:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  button { margin-top: 1.5rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f172a; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
```

The pale text is not a style choice you should copy; it is there so you can see the difference. The dark link and the dark paragraph pass comfortably. The focus ring is deliberately thick and offset so it does not disappear into the button's edge. `:focus-visible` is the right default for interactive elements: it shows the ring for keyboard users and usually hides it for mouse clicks, which keeps the design calm without taking the keyboard cue away.

> **Tip:** Do not test contrast by eye. Use a contrast checker with the actual foreground and background values, including the text over a tinted card or a gradient. If the text sits on an image, the image is part of the background too.

## Challenge: add a skip link and a focus target

Add a skip link as the first focusable element in the page. It should say `Skip to main content`, point to `#main`, and be off-screen until it receives focus. Give the `<main>` element `id="main"` and `tabindex="-1"` so the link can move focus there.

```html exercise id=accessible-skip-link title="Add a skip link"
<header class="site-header">
  <nav aria-label="Primary">
    <a href="#shop">Shop</a>
    <a href="#journal">Journal</a>
  </nav>
</header>

<main>
  <h1>Journal</h1>
  <p>Notes from the nursery, written between waterings.</p>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #1e293b; }
  .site-header { padding: 1rem 2rem; border-bottom: 1px solid #e2e8f0; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  main { max-width: 40rem; margin: 3rem auto; padding: 0 1.5rem; }
</style>
--- solution
<a class="skip-link" href="#main">Skip to main content</a>

<header class="site-header">
  <nav aria-label="Primary">
    <a href="#shop">Shop</a>
    <a href="#journal">Journal</a>
  </nav>
</header>

<main id="main" tabindex="-1">
  <h1>Journal</h1>
  <p>Notes from the nursery, written between waterings.</p>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #1e293b; }
  .skip-link { position: fixed; top: -5rem; left: 1rem; padding: 0.7rem 1rem; border-radius: 0 0 8px 8px; background: #0f172a; color: white; font-weight: 600; }
  .skip-link:focus { top: 0; }
  .site-header { padding: 1rem 2rem; border-bottom: 1px solid #e2e8f0; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  main { max-width: 40rem; margin: 3rem auto; padding: 0 1.5rem; }
</style>
--- test
assertExists("a.skip-link", "Add a link with class skip-link");
assertText("a.skip-link", "Skip to main content", "The skip link should read: Skip to main content");
assertAttr("a.skip-link", "href", "#main", "The skip link should point to #main");
assertExists("main#main", "Give the main element id=\"main\"");
const main = query("main#main");
const tabindex = main.getAttribute("tabindex");
assert(tabindex !== null && Number(tabindex) < 0, "Give main tabindex=\"-1\" so the skip link can move focus there");
const link = query("a.skip-link");
const focusables = Array.from(document.querySelectorAll("a[href], button, input, select, textarea, [tabindex]")).filter((el) => el.tabIndex >= 0);
assert(focusables[0] === link, "The skip link must be the first focusable element on the page, before the nav links");
const atRest = link.getBoundingClientRect();
const offscreen = atRest.bottom <= 0 || atRest.right <= 0 || atRest.top >= window.innerHeight || atRest.left >= window.innerWidth;
assert(offscreen, "At rest, the skip link should be out of sight. Move it off-screen, not display: none");
link.focus();
assert(document.activeElement === link, "The skip link should be able to receive focus");
assertVisible(".skip-link", "When focused, the skip link should be visible, not just present in the layout");
const focused = link.getBoundingClientRect();
const inView = focused.top >= 0 && focused.left >= 0 && focused.bottom <= window.innerHeight && focused.right <= window.innerWidth;
assert(inView, "When focused, the skip link should appear fully inside the viewport. Use :focus to bring it back");
link.click();
assert(document.activeElement === main, "Activating the skip link should move focus to main, not just scroll the page. Check that main has tabindex=\"-1\"");
--- hint
Put the link immediately inside `<body>`, before the header.
--- hint
Hide it with `position: fixed` and a negative `top`, then use `.skip-link:focus { top: 0; }` to reveal it.
--- hint
`main` needs `id="main"` and `tabindex="-1"`; the link needs `href="#main"` and class `skip-link`.
```

## Challenge: replace the fake button

This control looks like a button, has `role="button"` and is in the Tab order, but it is still a `<div>`. Replace it with a real `<button>` that keeps the visible text `Save draft`, stays focusable, and keeps the green background and white label.

```html exercise id=accessible-real-button title="Make the fake button real"
<div class="save" role="button" tabindex="0">Save draft</div>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; }
  .save { display: inline-block; padding: 0.75rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
--- solution
<button class="save" type="button">Save draft</button>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; }
  .save { padding: 0.75rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
--- test
const control = query(".save");
assert(control.tagName === "BUTTON", "A div with role=\"button\" is still a div. Use a real button element");
assertText(".save", "Save draft", "Keep the visible text: Save draft");
assertFocusable(".save", "The save control should be reachable with the Tab key");
assertColor(".save", "background-color", "#0f766e", "Keep the green background");
assertColor(".save", "color", "#ffffff", "Keep the white label text");
--- hint
Change the opening `<div class="save" role="button" tabindex="0">` to `<button class="save" type="button">` and update the closing tag.
--- hint
A real button already handles Tab, Enter and Space; you do not need `role` or `tabindex`.
```

## Debug: three quiet accessibility failures

This page looks fine. It has a header, a navigation, an image, a heading and a link. Three things are wrong:

- the navigation has no accessible name;
- the image says `alt="image"`;
- the "Read more" link is too pale against the white page.

Fix all three. The link needs a contrast ratio of at least 4.5:1 against the page background. The text "Read more" is also vague out of context; rewriting it is a good extra step, but the audit here is checking the contrast.

```html debug id=accessible-audit title="Audit the nursery page"
<header>
  <nav>
    <a href="#home">Home</a>
    <a href="#journal">Journal</a>
  </nav>
</header>

<main>
  <h1>Notes from the nursery</h1>
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='360'%3E%3Crect width='640' height='360' fill='%23ecfdf5'/%3E%3Cpath d='M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260' fill='%230f766e'/%3E%3Cpath d='M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260' fill='%23134e4a'/%3E%3Cpath d='M280 240 L360 240 L345 330 L295 330 Z' fill='%23c2410c'/%3E%3C/svg%3E" alt="image" width="640" height="360">
  <p>Our ferns spend the winter in the polytunnel. <a class="read-more" href="#winter">Read more</a></p>
</main>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; background: #ffffff; color: #1e293b; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  img { display: block; width: 100%; max-width: 38rem; height: auto; margin: 1rem 0; border-radius: 12px; }
  .read-more { color: #94a3b8; }
</style>
--- solution
<header>
  <nav aria-label="Primary">
    <a href="#home">Home</a>
    <a href="#journal">Journal</a>
  </nav>
</header>

<main>
  <h1>Notes from the nursery</h1>
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='360'%3E%3Crect width='640' height='360' fill='%23ecfdf5'/%3E%3Cpath d='M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260' fill='%230f766e'/%3E%3Cpath d='M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260' fill='%23134e4a'/%3E%3Cpath d='M280 240 L360 240 L345 330 L295 330 Z' fill='%23c2410c'/%3E%3C/svg%3E" alt="A fern with two green fronds in a terracotta pot" width="640" height="360">
  <p>Our ferns spend the winter in the polytunnel. <a class="read-more" href="#winter">Read the winter notes</a></p>
</main>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; background: #ffffff; color: #1e293b; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  img { display: block; width: 100%; max-width: 38rem; height: auto; margin: 1rem 0; border-radius: 12px; }
  .read-more { color: #0f172a; }
</style>
--- test
const nav = query("nav");
const labelledBy = nav.getAttribute("aria-labelledby");
const namedBy = (nav.getAttribute("aria-label") || "").trim();
const namedByElement = labelledBy ? document.getElementById(labelledBy) : null;
assert(namedBy.length > 0 || namedByElement, "The navigation has no accessible name. Add aria-label=\"Primary\" to the nav");
const image = query("img");
const alt = (image.getAttribute("alt") || "").trim();
assert(alt.length >= 5, "The image still has alt=\"image\". Describe what the photo shows");
assert(!/^image\b/i.test(alt), "The alt text should not start with 'image'. Describe the content instead");
function parseRgb(value) {
  return value.match(/[\d.]+/g).slice(0, 3).map(Number);
}
function channel(value) {
  const c = value / 255;
  return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
}
function luminance(rgb) {
  return 0.2126 * channel(rgb[0]) + 0.7152 * channel(rgb[1]) + 0.0722 * channel(rgb[2]);
}
const linkRgb = parseRgb(getComputedStyle(query(".read-more")).color);
const bodyBg = getComputedStyle(document.body).backgroundColor;
const bgRgb = bodyBg === "rgba(0, 0, 0, 0)" ? [255, 255, 255] : parseRgb(bodyBg);
const light = Math.max(luminance(linkRgb), luminance(bgRgb));
const dark = Math.min(luminance(linkRgb), luminance(bgRgb));
const ratio = (light + 0.05) / (dark + 0.05);
assert(ratio >= 4.5, "The 'Read more' link has a contrast ratio of " + ratio.toFixed(1) + ":1 against the page. Normal text needs at least 4.5:1");
--- hint
The nav is a landmark, but it has no name. `aria-label="Primary"` gives it one.
--- hint
Replace `alt="image"` with a short description of what the picture shows, not the word "image".
--- hint
Darken `.read-more`. `#94a3b8` is far too pale on white; `#0f172a` passes comfortably.
```

## Recap

- `<html lang="en">` tells assistive technology how to pronounce the page.
- `<header>`, `<nav>`, `<main>` and `<footer>` are landmarks; a skip link should be the first focusable element and reveal itself on focus.
- Headings form an outline. Keep one `h1`, do not skip levels, and make link text meaningful out of context.
- `alt` describes the content and purpose of an image; `alt=""` marks a decorative image; never use `alt="image"`.
- Use a real `<button>` instead of a clickable `<div>`. It is focusable, keyboard-operable and announced correctly.
- ARIA is for gaps HTML cannot fill: `aria-label`, `aria-describedby`, `aria-current`. Do not use it to fake a native element.
- Normal text needs about 4.5:1 contrast; large text and UI boundaries need about 3:1.
- Keep a visible `:focus-visible` ring. Keyboard users need to see where they are.

**Up next:** CSS foundations — selectors, colors and the cascade, where the structure you have built finally gets a visual language.
