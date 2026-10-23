A screen reader does not read your HTML file. It reads a second tree that the browser builds from it: the accessibility tree. Each node in that tree has a role, a name, a state and sometimes a value. “Button, Save changes, pressed” is a node. “Group, blank” is what a styled `<div>` becomes when it has no semantics. The visual result can be identical. The experience is not.

This is the layer where accessibility is won or lost. Most of it is not ARIA. It is choosing the element that already has the behaviour you want, naming it correctly, and exposing state when the interface changes. ARIA is the patch for the cases HTML cannot express — and a patch that is easy to apply in a way that makes things worse.

## From DOM to accessibility tree

The browser walks the DOM and maps elements to platform accessibility APIs. A `<button>` becomes a button node with a name, a pressed state and keyboard behaviour. A heading becomes a heading node with a level. An `<img alt="…">` becomes an image node with a name; an image with `alt=""` is ignored by most screen readers because it is decorative. Text nodes become static text.

Some nodes never make it into the tree. `display: none` removes a subtree. `visibility: hidden` does too. `aria-hidden="true"` removes a subtree from the accessibility tree while leaving it on screen. That is a powerful tool and a common footgun: it does not remove anything from the keyboard order.

Open DevTools, select an element, and look at the **Accessibility** pane: computed role, accessible name, description and states. If it says “generic” for something that looks like a button, a screen reader will not call it a button either.

```html run
<main class="page">
  <h1>Field notes</h1>
  <article class="note">
    <h2>What the rain did</h2>
    <p>The lower path held water for three days. The ridge was dry by Sunday.</p>
    <a href="#read">Read the full note</a>
  </article>
  <div class="note fake">
    <div class="title">What the wind did</div>
    <div>The exposed section was closed. The shelter stayed open.</div>
    <div class="link">Read the full note</div>
  </div>
</main>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .page { max-width: 38rem; margin: 0 auto; }
  h1 { margin: 0 0 1.5rem; font-size: 2rem; letter-spacing: -.03em; }
  .note { margin-bottom: 1rem; padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 .5rem; font-size: 1.15rem; }
  p { margin: 0 0 .75rem; color: #475569; line-height: 1.55; }
  a { color: #0f766e; font-weight: 650; }
  .title { margin-bottom: .5rem; font-size: 1.15rem; font-weight: 700; }
  .link { margin-top: .75rem; color: #0f766e; font-weight: 650; }
</style>
```

The two cards look the same. The first is an article with a heading, a paragraph and a link: three useful nodes, and a link that can be opened with Enter. The second is a pile of generic containers with text. There is no heading to jump to, no link to activate, and no article boundary. CSS gave it the appearance of structure; only HTML gives it the structure itself.

> **Under the hood:** The accessibility tree is computed, not authored. The same DOM can produce different trees in different browsers, especially for edge cases in ARIA. That is why “it works in Chrome” is not an accessibility test. Roles, names and states are the stable contract; the exact announcement order is the screen reader's business.

## Landmarks and headings

Landmark elements are the page's table of contents. `<header>` is a banner, `<nav>` is navigation, `<main>` is the main content, `<aside>` is complementary, `<footer>` is content information. A `<form>` becomes a form landmark only when it has an accessible name; a `<section>` becomes a region only when it has one too. That naming rule is deliberate: an unnamed region is noise, not orientation.

Give each landmark a name when there is more than one of its kind. Two navigation blocks — primary and footer — should be `aria-label="Primary"` and `aria-label="Footer"`. One `<main>` per page. The skip link you built earlier points at it.

Headings are the other navigation system. Screen-reader users move through a page by heading level the way sighted users scan bold text. A page with one `<h1>` and a clean `<h2>`/`<h3>` outline is easy to skim. A page that uses `<h4>` because it “looks right” breaks the outline. Style the size with CSS; choose the level by meaning.

```html run
<a class="skip" href="#main">Skip to content</a>
<header class="site-header">
  <a class="brand" href="#">Moss & Pine</a>
  <nav aria-label="Primary">
    <a href="#work">Work</a>
    <a href="#studio">Studio</a>
  </nav>
</header>
<main id="main">
  <h1>Furniture for long rooms</h1>
  <section aria-labelledby="work-title">
    <h2 id="work-title">Selected work</h2>
    <p>Three tables, one bench and a shelf that refuses to sag.</p>
  </section>
  <aside aria-label="Studio hours">
    <h2>Visit</h2>
    <p>Friday to Sunday, 10am–4pm.</p>
  </aside>
</main>
<footer>
  <nav aria-label="Footer">
    <a href="#contact">Contact</a>
    <a href="#shipping">Shipping</a>
  </nav>
</footer>
<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .skip { position: absolute; left: 1rem; top: -4rem; padding: .6rem 1rem; background: #0f172a; color: #fff; text-decoration: none; }
  .skip:focus { top: 1rem; }
  .site-header { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
  .brand { font-weight: 800; color: #0f172a; text-decoration: none; }
  nav { display: flex; gap: 1rem; }
  nav a { color: #0f766e; font-weight: 600; }
  main { max-width: 38rem; margin: 0 auto; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 1.5rem; font-size: 2rem; letter-spacing: -.03em; } h2 { margin: 0 0 .5rem; font-size: 1.2rem; }
  section, aside { margin-bottom: 1.5rem; padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  p { margin: 0; color: #475569; line-height: 1.6; }
  footer { padding: 1rem 1.5rem; border-top: 1px solid #e2e8f0; }
  a:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

> **Pitfall:** `aria-label` on a `<section>` or `<form>` creates a landmark. Without the label, the element is still a semantic section in the DOM but does not appear as a named region in the landmark list. If you are adding `aria-label` only to make a selector work, you are probably adding noise.

## Native elements are an API

A `<button>` is not a styled box. It is a contract:

- It is focusable and appears in the tab order.
- Enter and Space activate it.
- It exposes a button role and a disabled state.
- It participates in forms with a predictable `type`.
- It works with voice control, switch access and browser shortcuts.

A `<div role="button" tabindex="0">` gets the focus ring and the announced role, but none of the behaviour. The role says “button”; nothing makes it act like one. To be honest, you would have to add a click handler, a keydown handler for Enter and Space, a disabled state, and focus management — at which point you have reimplemented `<button>` badly.

The same logic applies everywhere. A link navigates; a button performs an action. Do not use an `<a href="#">` for “Save” just because it is already styled like a link. Use `<details>` and `<summary>` for disclosure instead of a div with a click handler. Use `<label>` for form labels. Use `<ul>` for lists. Native semantics are the shortest path to behaviour that survives a redesign.

```html run
<div class="compare">
  <section>
    <h2>Native button</h2>
    <button class="action" type="button">Save changes</button>
    <p>Tab to it. Press Enter or Space.</p>
  </section>
  <section>
    <h2>Div with a role</h2>
    <div class="action" role="button" tabindex="0">Save changes</div>
    <p>Tab to it. Press Enter or Space. Nothing happens.</p>
  </section>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .compare { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.25rem; max-width: 40rem; margin: 0 auto; }
  section { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 .75rem; font-size: 1.1rem; }
  .action { display: inline-block; padding: .7rem 1rem; border: 0; border-radius: 8px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; cursor: pointer; }
  p { margin: .85rem 0 0; color: #475569; font-size: .85rem; line-height: 1.45; }
  .action:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

> **In the wild:** A surprising number of design-system components are divs with roles and a keydown listener. They often work for Enter but forget Space, or they fire twice because the keydown handler also triggers a click. Every one of those bugs disappears with a `<button>`. The first rule of ARIA is: do not use ARIA when a native element already does the job.

## Debug: the button that was only a role

This toolbar control is announced as a button and can receive focus, but it cannot be activated from the keyboard. Replace it with the element that has the behaviour built in, without changing how it looks.

```html debug id=role-without-behaviour title="The button that was only a role"
<div class="toolbar">
  <span class="status">Draft saved locally</span>
  <div class="save" role="button" tabindex="0">Save changes</div>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 1rem; max-width: 34rem; margin: 0 auto; padding: 1rem 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  .status { color: #475569; font-size: .85rem; }
  .save { padding: .6rem .9rem; border-radius: 8px; background: #0f172a; color: #fff; font-weight: 650; cursor: pointer; }
  .save:focus { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- solution
<div class="toolbar">
  <span class="status">Draft saved locally</span>
  <button class="save" type="button">Save changes</button>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 1rem; max-width: 34rem; margin: 0 auto; padding: 1rem 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  .status { color: #475569; font-size: .85rem; }
  .save { padding: .6rem .9rem; border: 0; border-radius: 8px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; cursor: pointer; }
  .save:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- test
const save = query(".save");
assert(save.tagName === "BUTTON", `The save control is a <${save.tagName.toLowerCase()}>. A role announces a button but does not add keyboard activation. Use a real <button>.`);
assertAttr(".save", "type", "button", "Give the button type=\"button\" so it cannot submit a surrounding form by accident.");
assertFocusable(".save", "The save button should be reachable with Tab.");
assertText(".save", "Save changes", "Keep the visible label the same.");
--- hint
Find the element with `role="button"`. The role tells assistive technology what it is; it does not make the browser deliver Enter and Space activation.
--- hint
Replace the div with `<button class="save" type="button">Save changes</button>`. Add `border: 0` and `font: inherit` to the styles so it matches the old look.
```

## Accessible names

Every interactive node needs a name. The browser computes it in a defined order, and the differences matter:

1. `aria-labelledby` — references one or more ids; their text is concatenated in the order given.
2. `aria-label` — a string, used when there is no visible label to reference.
3. Native naming — `<label>`, `<legend>`, `alt`, or the element's own text content.
4. `title` — a last resort that many screen readers ignore.

`aria-labelledby` wins over `aria-label`. That is useful when the best name lives elsewhere on the page: a “Delete” button inside a dialog can point at the dialog title, so it is announced as “Delete project” rather than a bare “Delete”. It is dangerous when the referenced element changes or disappears; the button's name goes with it. Prefer a visible `<label>` or the button's own text when you can.

`aria-describedby` is the companion attribute for description, not naming. Point it at help text, a formatting hint or an error message when the name alone is not enough. The description is announced after the name and should add information rather than repeat the label. Keep the referenced element in the DOM; if it disappears, the description disappears with it.

Icon-only buttons need a name because there is no text to compute. Give the SVG `aria-hidden="true"` and `focusable="false"` so the icon is not announced, and put the name on the button:

```html
<button class="icon" type="button" aria-label="Close settings">
  <svg aria-hidden="true" focusable="false" viewBox="0 0 24 24">…</svg>
</button>
```

If the label should stay in the document, for translation or responsive copy, use visually hidden text instead of `aria-label`. The name stays in sync with the visible copy:

```html
<button class="icon" type="button">
  <svg aria-hidden="true" focusable="false" viewBox="0 0 24 24">…</svg>
  <span class="sr-only">Close settings</span>
</button>
```

```html run
<header class="panel">
  <h2 id="panel-title">Project settings</h2>
  <button class="icon" type="button" aria-label="Close settings">
    <svg aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="18" height="18">
      <path d="M5 5l14 14M19 5L5 19" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
    </svg>
  </button>
</header>
<div class="actions">
  <button class="secondary" type="button" aria-label="Delete project">Delete</button>
  <button class="primary" type="button">
    <svg aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="16" height="16">
      <path d="M5 12l5 5L20 7" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <span class="sr-only">Save changes</span>
  </button>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .panel { display: flex; align-items: center; justify-content: space-between; max-width: 30rem; margin: 0 auto; padding: 1rem 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px 12px 0 0; background: #fff; }
  h2 { margin: 0; font-size: 1.15rem; }
  .actions { display: flex; justify-content: flex-end; gap: .6rem; max-width: 30rem; margin: 0 auto; padding: 1rem 1.25rem; border: 1px solid #e2e8f0; border-top: 0; border-radius: 0 0 12px 12px; background: #fff; }
  button { font: inherit; font-weight: 650; cursor: pointer; border-radius: 8px; }
  .icon { display: grid; place-items: center; width: 36px; height: 36px; border: 1px solid #cbd5e1; background: #fff; color: #0f172a; }
  .secondary { padding: .6rem .9rem; border: 1px solid #cbd5e1; background: #fff; color: #b91c1c; }
  .primary { display: inline-flex; align-items: center; gap: .4rem; padding: .6rem .9rem; border: 0; background: #0f766e; color: #fff; }
  .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; border: 0; }
  button:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

The “Delete” button's visible text is part of its accessible name (“Delete project”), which satisfies the Label in Name rule: someone using voice control can say the visible word and still hit the control. If the accessible name were only “Remove”, the visible label and the spoken label would disagree, and voice control would fail.

> **Pitfall:** `aria-label` overrides visible text. A button that says “Submit” but has `aria-label="Send application"` is announced as “Send application”, while a sighted colleague reading over the user's shoulder sees “Submit”. Keep the visible words inside the accessible name, or drop the override.

## Predict: what is this button called?

Read the markup carefully. The button has visible text, but another name source has higher priority.

```html predict id=accessible-name-precedence title="What is the button's accessible name?"
<section class="dialog">
  <h2 id="dialog-title">Delete project</h2>
  <p>This removes the project and all of its notes.</p>
  <button class="danger" type="button" aria-labelledby="dialog-title">Delete</button>
</section>

<style>
  body { padding: 2rem; font-family: system-ui, sans-serif; }
  .dialog { max-width: 26rem; padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 .5rem; font-size: 1.2rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.5; }
  button { padding: .6rem .9rem; border: 1px solid #fca5a5; border-radius: 8px; background: #fef2f2; color: #b91c1c; font: inherit; font-weight: 650; }
</style>
--- options
* Delete project
Delete
Delete project Delete
The button has no accessible name
--- explain
`aria-labelledby="dialog-title"` points at the `<h2>`, so the button's name is computed from that heading's text: “Delete project”. The visible word “Delete” is ignored for naming because `aria-labelledby` has higher priority than the element's contents. This is a legitimate pattern when the surrounding context is essential, but it must not contradict the visible label: “Delete project” still contains “Delete”, so voice control can find it.
```

## States, relationships and live regions

A role describes what a thing is. A state describes what it is doing right now. The common states you will reach for:

| Attribute | Use |
|---|---|
| `aria-expanded="true/false"` | A disclosure, menu or combobox is open or closed |
| `aria-controls="id"` | The element this control operates on |
| `aria-current="page"` | The current item in a navigation set |
| `aria-pressed="true/false"` | A toggle button is on or off |
| `aria-selected` | The selected tab or option |
| `aria-live="polite"` | Announce changes when the user is idle |
| `aria-invalid="true"` | A form control failed validation |

Only add a state if the element's role supports it. `aria-expanded` on a plain `<div>` does nothing useful; on a `<button>` that controls a panel it tells the screen reader “collapsed” or “expanded”. `aria-controls` is a relationship hint; support is uneven, so do not rely on it as the only connection. The panel should still follow the button in the DOM and be labelled by it.

`aria-current="page"` is a small win that is easy to forget. It tells the user which item in a navigation set is the current page, instead of leaving them to infer it from colour.

`aria-live` is where good intentions go wrong. A live region announces changes to its contents. `polite` waits for a pause; `assertive` interrupts. `role="status"` is an implicit polite region; `role="alert"` is assertive. Keep the region in the DOM before the change, update its text after an action, and keep the message short.

```html run
<nav aria-label="Breadcrumb">
  <ol class="crumbs">
    <li><a href="#journal">Journal</a></li>
    <li><a href="#october" aria-current="page">October</a></li>
  </ol>
</nav>
<div class="status" role="status">
  <span class="dot" aria-hidden="true"></span>
  All changes saved
</div>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .crumbs { display: flex; gap: .5rem; margin: 0 0 1.25rem; padding: 0; list-style: none; font-size: .9rem; }
  .crumbs li + li::before { content: "/"; margin-right: .5rem; color: #94a3b8; }
  .crumbs a { color: #0f766e; }
  .crumbs [aria-current="page"] { color: #0f172a; font-weight: 700; text-decoration: none; }
  .status { display: inline-flex; align-items: center; gap: .5rem; padding: .55rem .8rem; border: 1px solid #bbf7d0; border-radius: 8px; background: #f0fdf4; color: #166534; font-size: .85rem; font-weight: 600; }
  .dot { width: 8px; height: 8px; border-radius: 50%; background: #16a34a; }
</style>
```

A live region that is inserted at the same moment as its message often announces nothing, because the screen reader never saw the empty region. Mount it once, then change the text. And do not put `aria-live` on a container that holds the whole page: every validation message, clock tick and hover card becomes an interruption.

> **Tip:** Use `role="status"` for “Saved”, “3 results” and other polite confirmations. Reserve `role="alert"` for errors that need immediate attention. If you find yourself adding `aria-live="assertive"` to a toast that also auto-dismisses in three seconds, reconsider both the urgency and the timer.

## Challenge: an honest disclosure

This panel is open, but its trigger is just a button with no state and no relationship to the panel. Make the semantics match what is on screen: a real button, `aria-expanded="true"`, `aria-controls` pointing at the panel, and a visible panel with the same id. The open state is expressed with a class in this static example; in production you would toggle the attribute and the class together.

```html exercise id=honest-disclosure title="An honest disclosure"
<section class="disclosure">
  <button class="trigger" type="button">Trail conditions</button>
  <div class="panel" id="conditions">
    <p>The north ridge is clear. The lower path is muddy after rain.</p>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .disclosure { max-width: 30rem; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; overflow: hidden; }
  .trigger { width: 100%; padding: 1rem 1.25rem; border: 0; background: #fff; color: #0f172a; font: inherit; font-weight: 700; text-align: left; cursor: pointer; }
  .panel { display: none; padding: 0 1.25rem 1.25rem; }
  .disclosure.is-open .panel { display: block; }
  .panel p { margin: 0; color: #475569; line-height: 1.6; }
  .trigger:focus-visible { outline: 3px solid #b45309; outline-offset: -3px; }
</style>
--- solution
<section class="disclosure is-open">
  <button class="trigger" type="button" aria-expanded="true" aria-controls="conditions">Trail conditions</button>
  <div class="panel" id="conditions">
    <p>The north ridge is clear. The lower path is muddy after rain.</p>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .disclosure { max-width: 30rem; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; overflow: hidden; }
  .trigger { width: 100%; padding: 1rem 1.25rem; border: 0; background: #fff; color: #0f172a; font: inherit; font-weight: 700; text-align: left; cursor: pointer; }
  .panel { display: none; padding: 0 1.25rem 1.25rem; }
  .disclosure.is-open .panel { display: block; }
  .panel p { margin: 0; color: #475569; line-height: 1.6; }
  .trigger:focus-visible { outline: 3px solid #b45309; outline-offset: -3px; }
</style>
--- test
const trigger = query(".trigger");
assert(trigger.tagName === "BUTTON", "The disclosure trigger should be a real button, not a div with a role.");
assertAttr(".trigger", "aria-expanded", "true", "The panel is open on screen, so the trigger should expose aria-expanded=\"true\".");
assertAttr(".trigger", "aria-controls", "conditions", "Point aria-controls at the id of the panel this button opens.");
assertExists("#conditions", "The panel needs the id that aria-controls references.");
assertVisible("#conditions", "The expanded panel should be visible. Add the open class to the section.");
assertFocusable(".trigger", "The trigger must stay reachable with Tab.");
assertText(".trigger", "Trail conditions", "Keep the visible trigger label.");
--- hint
Add the `is-open` class to the section so the panel displays, then add `aria-expanded="true"` and `aria-controls="conditions"` to the button.
--- hint
The panel already has `id="conditions"`. The relationship is only useful if the id in `aria-controls` matches exactly and the panel is actually visible when the state says it is expanded.
```

> **Under the hood:** `aria-expanded` does not open anything. It is a report of state, and the report must be updated by the same code that opens the panel. A common bug is an animated panel that opens visually while the button still says `aria-expanded="false"`. Screen-reader users then hear “collapsed” for content they can read. In this static exercise the class and the attribute are both authored by hand; in production they belong in one state update.

## ARIA anti-patterns

Most ARIA bugs are one of these:

- **A role without behaviour.** `role="button"` on a div, `role="checkbox"` on a span. The role is a promise the browser does not keep.
- **`aria-label` on a non-interactive element.** A heading with `aria-label` may be renamed, but a plain div with no role is still generic. Use visible text or a real element.
- **Redundant roles.** `role="navigation"` on `<nav>`, `role="button"` on `<button>`. Harmless, but noise that suggests the author did not trust the element.
- **`aria-hidden="true"` on focusable content.** The element disappears from the tree but stays in the tab order, producing a focus stop that announces nothing. Never do this. If you need to remove both, use `inert` or remove the element.
- **A live region for everything.** Whole-page `aria-live` turns the interface into a stream of interruptions.
- **A state that never changes.** `aria-expanded="false"` that stays false while the panel opens is worse than no ARIA, because it actively misleads.

> **Pitfall:** `aria-hidden="true"` does not remove an element from the keyboard order. `display: none`, `hidden`, or the `inert` attribute do. Use `aria-hidden` for decorative icons and duplicate text that has no focusable descendants, and use `inert` when you need to remove a whole region from both interaction and the accessibility tree.

## Debug: the hidden link

This card is marked `aria-hidden="true"` because the same product appears in a featured slot elsewhere on the page. The card also contains the only link to the product's visit page. A screen-reader user can still Tab to the link, but hears nothing when they get there. Fix the hiding so the card is announced and the decorative mark stays out of the tree.

```html debug id=aria-hidden-focus title="The hidden link"
<article class="card" aria-hidden="true">
  <div class="mark" aria-hidden="true">★</div>
  <h2>Moss & Pine</h2>
  <p>Small wooden furniture, made slowly in Hebden Bridge.</p>
  <a href="#visit">Plan a visit</a>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .mark { color: #b45309; font-size: 1.2rem; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.3rem; }
  p { margin: 0 0 .9rem; color: #475569; line-height: 1.55; }
  a { color: #0f766e; font-weight: 650; }
  a:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- solution
<article class="card">
  <div class="mark" aria-hidden="true">★</div>
  <h2>Moss & Pine</h2>
  <p>Small wooden furniture, made slowly in Hebden Bridge.</p>
  <a href="#visit">Plan a visit</a>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .mark { color: #b45309; font-size: 1.2rem; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.3rem; }
  p { margin: 0 0 .9rem; color: #475569; line-height: 1.55; }
  a { color: #0f766e; font-weight: 650; }
  a:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- test
const link = query(".card a");
assert(link.closest('[aria-hidden="true"]') === null, "The visit link is inside an aria-hidden subtree, so it is focusable but silent. Remove aria-hidden from the card.");
assertText(".card a", "Plan a visit", "Keep the visible link text.");
assertVisible(".card", "The card should remain visible.");
assertAttr(".mark", "aria-hidden", "true", "Keep the decorative star hidden from assistive technology.");
assertFocusable(".card a", "The visit link should stay reachable with Tab.");
--- hint
The link's ancestor has `aria-hidden="true"`. Everything inside that subtree is removed from the accessibility tree, including the heading, paragraph and link.
--- hint
Remove `aria-hidden` from the `<article>`, leaving it on the decorative `.mark`. Hiding a whole content card is almost never correct when it contains the only path to an action.
```

## Testing with the accessibility tree

The most useful test cannot be automated: use the page with a keyboard and a screen reader. On macOS, turn on VoiceOver with Cmd+F5 and navigate with Ctrl+Option+Arrow. Listen for the role, the name and the state at each stop. You will hear what static analysis misses: a heading read as a paragraph, a button named “icon”.

Between manual passes, automate the parts that are mechanical:

- Every form control has a label.
- Every button and link has a non-empty accessible name.
- Every `aria-controls` points at an existing id.
- No focusable element is inside `aria-hidden="true"`.
- No heading level is skipped, and there is exactly one `<h1>`.

Write them as DOM assertions; they catch common regressions, though not all of them. A component test that queries by role and name is also a useful constraint: if it is hard to find by role, it may be hard to find with a screen reader too.

## Recap

- Browsers build a separate accessibility tree with roles, names, states and relationships. Styling a div does not create semantics.
- Use landmarks and a clean heading outline so people can navigate the page without reading every word.
- Native elements come with behaviour. A role only changes the announcement; it does not add keyboard activation or state management.
- Accessible names are computed in priority order: `aria-labelledby`, then `aria-label`, then native naming, then `title`. Keep the visible label inside the accessible name.
- Expose state with `aria-expanded`, `aria-current`, `aria-pressed` and friends, and update it in the same place that changes the UI.
- `aria-live` is for small, meaningful updates. `aria-hidden` is for decorative or duplicate content, never for focusable elements.

**Up next:** colour as a system — perceptual colour spaces, contrast ratios and a dark theme that is more than an inverted light theme.
