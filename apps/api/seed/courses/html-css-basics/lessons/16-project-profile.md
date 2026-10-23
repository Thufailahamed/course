A capstone is where separate rules stop being exercises and become a page someone could actually use. This one is a personal profile: a page that has to answer three questions in under a minute. Who is this person? What have they made? How do I reach them? Everything else — the colours, the type, the spacing, the motion — exists to make those answers easy to find.

The subject is a fictional design engineer, Mara Okafor. You will build her page in stages, from an empty document to a responsive finish. Each stage adds one layer: structure, then a small design system, then the work grid, then the responsive behaviour that keeps the page readable on a phone. The final page uses semantic landmarks, CSS custom properties, Flexbox, Grid and a mobile-first media query. No JavaScript, no external images and no framework.

## Start with the skeleton

Before a single colour, decide what each part of the page *is*. A profile page has a natural shape:

- A `<header>` with the person's name and a `<nav>` for the main sections.
- A `<main>` containing the profile introduction, selected work and contact details.
- A `<footer>` with the small print.

Those are landmarks, not styling hooks. A screen reader can jump between them, and a browser can identify the main content without guessing. The navigation gets an `aria-label` because a page can have more than one navigation region; the label tells assistive technology which one this is. Each link points at a real section id, so it works with a keyboard and does not depend on JavaScript.

The profile itself is a `<section>` with an `<h1>` for the name. The work and contact sections get `<h2>` headings. That gives the page a clean outline: one main heading, then two major sections. A section without a heading is just a rectangle; the heading is what makes it navigable.

Here is the skeleton. It is deliberately plain. Run it and use the preview's phone width: the page already works at every size because it has not committed to a layout yet.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mara Okafor · Design engineer</title>
  </head>
  <body>
    <a class="skip" href="#main">Skip to content</a>
    <header class="site-header">
      <p class="wordmark">Mara Okafor</p>
      <nav aria-label="Primary">
        <a href="#work">Work</a>
        <a href="#about">About</a>
        <a href="#contact">Contact</a>
      </nav>
    </header>
    <main id="main">
      <section id="about" class="profile" aria-labelledby="profile-name">
        <div class="avatar" aria-hidden="true">MO</div>
        <div class="identity">
          <h1 id="profile-name">Mara Okafor</h1>
          <p class="role">Design engineer · Lisbon</p>
          <p class="bio">I design and build calm, accessible interfaces for teams that care about the details.</p>
        </div>
      </section>
      <section id="work" aria-labelledby="work-title">
        <h2 id="work-title">Selected work</h2>
        <p>Three project cards will live here.</p>
      </section>
      <section id="contact" aria-labelledby="contact-title">
        <h2 id="contact-title">Contact</h2>
        <p>Open to selected projects. <a href="mailto:hello@maraokafor.example">hello@maraokafor.example</a></p>
      </section>
    </main>
    <footer><p>© 2026 Mara Okafor.</p></footer>
  </body>
</html>
```

Two details are easy to miss. The skip link is the first focusable element on the page; on a long page it lets keyboard users jump past the navigation. It will be visually hidden until focused. The avatar is a `<div>` with initials and `aria-hidden="true"`. Initials are honest, load instantly, scale perfectly and avoid the awkwardness of a stock portrait. If you use an inline SVG instead, give it a `<title>` or mark it decorative. Never make the page depend on a network portrait to feel complete.

> **Tip:** Every `<section>` should have a heading or an accessible name. Here `aria-labelledby` points at the section's own `<h2>`, which gives the region a name without duplicating text. This is the difference between a page that merely looks structured and one that is structured.

## Choose a small system before you decorate

The fastest way to make a page look unfinished is to choose colours one at a time. The second fastest is to choose a different spacing value for every gap. A small design system fixes both problems before they start.

Three decisions carry most of the visual quality:

1. **A restrained palette.** One ink colour for text, one muted colour for secondary text, one paper colour for the page, one card colour, one line colour and one accent. That is six values, and every one of them has a job. The accent is for links and emphasis, not for large backgrounds unless the contrast is checked.
2. **A type scale.** A display size for the name, a section size for headings, a body size and a small size for labels. `clamp()` lets the display size grow with the viewport without a media query: `clamp(2rem, 6vw, 3.5rem)` is never smaller than 2rem, never larger than 3.5rem, and scales in between.
3. **A spacing scale.** Pick a few steps — 0.5rem, 1rem, 1.5rem, 2.5rem — and use them everywhere. Random values like 17px and 23px are why pages feel slightly off without an obvious reason.

Store the palette and spacing in CSS custom properties on `:root`. Custom properties are inherited, so a component can read `var(--accent)` without knowing where it was defined. They also give you one place to change a colour later, and they make a dark theme a matter of overriding a handful of values rather than hunting through every rule.

```html run
<header class="site-header">
  <p class="wordmark">Mara Okafor</p>
  <nav aria-label="Primary">
    <a href="#work">Work</a>
    <a href="#about">About</a>
    <a href="#contact">Contact</a>
  </nav>
</header>
<main class="wrap">
  <section id="about" class="profile" aria-labelledby="profile-name">
    <div class="avatar" aria-hidden="true">MO</div>
    <div class="identity">
      <h1 id="profile-name">Mara Okafor</h1>
      <p class="role">Design engineer · Lisbon</p>
      <p class="bio">I design and build calm, accessible interfaces for teams that care about the details.</p>
    </div>
  </section>
</main>
<style>
  :root { --ink: #0f172a; --muted: #475569; --paper: #f8fafc; --card: #fff; --line: #e2e8f0; --accent: #0f766e; }
  :root { --space-1: 0.5rem; --space-2: 1rem; --space-3: 1.5rem; --space-4: 2.5rem; --step-0: 1rem; --step-1: 1.25rem; --step-2: 1.75rem; --step-3: clamp(2rem, 6vw, 3.5rem); }
  * { box-sizing: border-box; }
  body { margin: 0; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: var(--paper); }
  a { color: var(--accent); }
  :focus-visible { outline: 3px solid var(--accent); outline-offset: 3px; }
  .wrap { width: min(100% - 2rem, 64rem); margin-inline: auto; }
  .site-header { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: var(--space-2); padding-block: var(--space-3); border-bottom: 1px solid var(--line); }
  .wordmark { margin: 0; font-weight: 750; letter-spacing: -0.02em; }
  nav { display: flex; gap: var(--space-3); font-size: 0.9rem; font-weight: 600; }
  nav a { color: var(--ink); text-decoration: none; }
  nav a:hover { color: var(--accent); text-decoration: underline; text-underline-offset: 4px; }
  main { padding-block: var(--space-4); }
  .profile { display: flex; flex-direction: column; align-items: flex-start; gap: var(--space-3); }
  .avatar { display: grid; place-items: center; width: 88px; height: 88px; flex: none; border-radius: 24px; background: var(--ink); color: #fff; font-size: 1.4rem; font-weight: 750; }
  h1 { margin: 0; font-size: var(--step-3); line-height: 1.02; letter-spacing: -0.045em; }
  .role { margin: var(--space-1) 0 0; color: var(--accent); font-weight: 650; }
  .bio { max-width: 44ch; margin: var(--space-2) 0 0; color: var(--muted); }
</style>
```

Notice that the profile stacks at every width in this cell. That is not a missing media query; it is the mobile layout. A narrow screen gets the avatar above the text, which is exactly right. Later, one `min-width` rule will turn it into a row when there is room. Starting from the narrow layout and adding complexity is what mobile-first means in practice.

The header is already fluid. `flex-wrap: wrap` lets the name and navigation sit on separate lines when they must. `justify-content: space-between` pushes them apart when they fit. None of that requires a breakpoint.

> **Pitfall:** A `max-width` with no horizontal padding gives the text a comfortable line length on a large screen, but on a phone it touches both edges. The `min(100% - 2rem, 64rem)` pattern in `.wrap` solves both: it reserves a one-rem gutter on each side and stops growing at 64rem.

## Challenge: the identity block

Build the profile header and its navigation. The header must contain a `<nav>` with an `aria-label`, three links (Work, About, Contact), and a profile section with an avatar, an `<h1>`, a `.role` line and a `.bio` paragraph. The avatar can be initials or an inline SVG, but it must not be a network image.

```html exercise id=profile-identity title="Build the profile header and accessible nav"
<header class="site-header">
  <p class="wordmark">Mara Okafor</p>
  <nav>
    <!-- TODO: label the nav and add three section links -->
  </nav>
</header>
<main>
  <section class="profile">
    <!-- TODO: add an avatar, an h1, a .role and a .bio -->
  </section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; }
  .site-header { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 1rem; max-width: 64rem; margin: 0 auto; padding: 1.5rem; }
  .profile { display: flex; align-items: flex-start; gap: 1.5rem; max-width: 64rem; margin: 0 auto; padding: 3rem 1.5rem; }
  .avatar { display: grid; place-items: center; width: 80px; height: 80px; flex: none; border-radius: 22px; background: #0f172a; color: #fff; font-weight: 700; }
  .identity { min-width: 0; }
  h1 { margin: 0; font-size: 2.5rem; letter-spacing: -0.03em; }
  .role { margin: 0.25rem 0 0; color: #0f766e; font-weight: 600; }
  .bio { max-width: 40ch; margin: 0.75rem 0 0; color: #475569; line-height: 1.6; }
</style>
--- solution
<header class="site-header">
  <p class="wordmark">Mara Okafor</p>
  <nav aria-label="Primary">
    <a href="#work">Work</a>
    <a href="#about">About</a>
    <a href="#contact">Contact</a>
  </nav>
</header>
<main>
  <section class="profile">
    <div class="avatar" aria-hidden="true">MO</div>
    <div class="identity">
      <h1>Mara Okafor</h1>
      <p class="role">Design engineer · Lisbon</p>
      <p class="bio">I design and build calm, accessible interfaces for teams that care about the details.</p>
    </div>
  </section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; }
  .site-header { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 1rem; max-width: 64rem; margin: 0 auto; padding: 1.5rem; }
  .profile { display: flex; align-items: flex-start; gap: 1.5rem; max-width: 64rem; margin: 0 auto; padding: 3rem 1.5rem; }
  .avatar { display: grid; place-items: center; width: 80px; height: 80px; flex: none; border-radius: 22px; background: #0f172a; color: #fff; font-weight: 700; }
  .identity { min-width: 0; }
  h1 { margin: 0; font-size: 2.5rem; letter-spacing: -0.03em; }
  .role { margin: 0.25rem 0 0; color: #0f766e; font-weight: 600; }
  .bio { max-width: 40ch; margin: 0.75rem 0 0; color: #475569; line-height: 1.6; }
</style>
--- test
assertExists("header.site-header", "Keep the page header");
assertExists("header.site-header nav", "Put the main navigation inside the header");
const nav = query("header.site-header nav");
const label = nav.getAttribute("aria-label");
assert(label && label.trim().length > 0, "Give the nav an aria-label such as Primary so screen readers can tell it apart.");
assertCount("header.site-header nav a", 3, "The navigation should have three links: Work, About and Contact.");
for (const link of document.querySelectorAll("header.site-header nav a")) {
  assert(link.getAttribute("href"), "Every navigation link needs an href that points at a section.");
  assert(normalize(link.textContent).length > 0, "Every navigation link needs a visible name.");
  assert(link.tabIndex >= 0, "Navigation links should be reachable with the Tab key.");
}
assertExists("main", "Wrap the page content in a main element");
const profile = query(".profile");
const name = profile.querySelector("h1");
assert(name, "The profile needs an h1 with the person's name.");
assert(normalize(name.textContent).length > 0, "The h1 should contain a name, not be empty.");
assertExists(".profile .avatar", "Add an avatar inside the profile section.");
const avatar = query(".profile .avatar");
assert(avatar.querySelector("svg") || normalize(avatar.textContent).length > 0, "Use initials or an inline SVG inside .avatar.");
assert(!document.querySelector('.profile img[src^="http"]'), "Use initials or inline SVG instead of a network portrait.");
const avatarStyle = getComputedStyle(avatar);
assert(avatarStyle.width === avatarStyle.height, `The avatar should be square; it is ${avatarStyle.width} by ${avatarStyle.height}.`);
assertExists(".profile .role", "Add a .role line for the person's title.");
assertExists(".profile .bio", "Add a .bio paragraph with a short introduction.");
assertStyle(".profile", "display", "flex", "Lay the avatar and identity out with Flexbox.");
assert(parseFloat(getComputedStyle(profile).gap) > 0, "Add a gap between the avatar and the identity block.");
--- hint
The nav needs `aria-label="Primary"`. Inside it, add anchors whose `href` values match the section ids: `#work`, `#about`, `#contact`.
--- hint
The profile section should contain `<div class="avatar" aria-hidden="true">MO</div>` and an identity wrapper with an `<h1>`, `<p class="role">` and `<p class="bio">`.
--- hint
Keep the existing `.profile { display: flex; }` rule. The test only checks the structure and the gap, not a particular font or colour.
```

## Selected work is proof, not a gallery

Three project cards are enough. A profile page is not an archive; it is an argument. Each card should answer three questions: what is it, what problem did it solve, and where can I read more? Keep the description to one or two sentences. The link needs a specific name — "Read the Harbour case study" is better than "Read more", because a screen reader can hear a list of links and still know each destination.

Use a Grid for the cards. Grid gives every card in a row the same height automatically, which keeps the links aligned even when one description is longer. Inside each card, Flexbox with `flex-direction: column` lets the link sit at the bottom: `margin-top: auto` absorbs the leftover space. That is a small layout trick with a large visual payoff.

The grid is mobile-first. One column is the default. At `min-width: 40rem` it becomes two columns, and at `min-width: 60rem` it becomes three. No `max-width` query is needed, and no device is singled out by name.

```html run
<section id="work" class="work wrap" aria-labelledby="work-title">
  <h2 id="work-title">Selected work</h2>
  <p class="lede">Three projects, three different problems.</p>
  <div class="work-grid">
    <article class="card">
      <p class="index">01</p><h3>Harbour</h3>
      <p>A booking flow for a coastal hostel, rebuilt around one decision per screen.</p>
      <a href="#harbour">Read the case study <span aria-hidden="true">→</span></a>
    </article>
    <article class="card">
      <p class="index">02</p><h3>Common Room</h3>
      <p>A design system for a members' club, from type scale to accessible form fields.</p>
      <a href="#common-room">Read the case study <span aria-hidden="true">→</span></a>
    </article>
    <article class="card">
      <p class="index">03</p><h3>Slow Sunday</h3>
      <p>An editorial site for a food writer, built to load in under a second.</p>
      <a href="#slow-sunday">Read the case study <span aria-hidden="true">→</span></a>
    </article>
  </div>
</section>
<style>
  :root { --ink: #0f172a; --muted: #475569; --paper: #f8fafc; --card: #fff; --line: #e2e8f0; --accent: #0f766e; }
  * { box-sizing: border-box; }
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: var(--paper); }
  .wrap { max-width: 64rem; margin-inline: auto; }
  h2 { margin: 0; font-size: 1.75rem; letter-spacing: -0.02em; }
  .lede { margin: 0.35rem 0 1.5rem; color: var(--muted); }
  .work-grid { display: grid; gap: 1rem; }
  .card { display: flex; flex-direction: column; gap: 0.5rem; padding: 1.25rem; border: 1px solid var(--line); border-radius: 16px; background: var(--card); transition: transform 180ms ease, box-shadow 180ms ease; }
  .index { margin: 0; color: var(--accent); font-size: 0.75rem; font-weight: 750; letter-spacing: 0.1em; }
  .card h3, .card p { margin: 0; }
  .card p:not(.index) { color: var(--muted); }
  .card a { margin-top: auto; padding-top: 0.5rem; color: var(--accent); font-weight: 650; }
  .card:hover { transform: translateY(-3px); box-shadow: 0 12px 30px rgb(15 23 42 / 0.08); }
  @media (min-width: 40rem) { .work-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .work-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
```

The `.card a` rule has `margin-top: auto`. Because the card is a column flex container, that auto margin pushes the link to the bottom of the card, and because Grid stretches every card to the row height, all three links line up. The cards do not need fixed heights, and the layout survives longer copy.

> **Tip:** If you make the whole card clickable with a stretched pseudo-element, keep the real link in the markup and put the overlay behind the text. Do not wrap a card in an `<a>` that contains headings and paragraphs; the accessible name becomes the entire card, and nested interactive content becomes ambiguous.

## Challenge: three cards, one grid

Build the Selected work section. It needs an `<h2>`, a `.work-grid` container and three `.card` articles. Each card needs an `<h3>`, a short paragraph and a link with a real `href`. The grid must be one column on narrow screens, two at `40rem` and three at `60rem`.

```html exercise id=profile-work-grid title="Build the selected work grid"
<section id="work" class="wrap" aria-labelledby="work-title">
  <h2 id="work-title">Selected work</h2>
  <div class="work-grid">
    <!-- TODO: add three .card articles with an h3, a paragraph and a link -->
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; line-height: 1.6; }
  .wrap { max-width: 64rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-size: 1.75rem; }
  .work-grid { display: grid; gap: 1rem; }
  .card { display: flex; flex-direction: column; gap: 0.5rem; padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .card h3, .card p { margin: 0; }
  .card p { color: #475569; }
  .card a { margin-top: auto; padding-top: 0.5rem; color: #0f766e; font-weight: 650; }
  @media (min-width: 40rem) { .work-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .work-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
--- solution
<section id="work" class="wrap" aria-labelledby="work-title">
  <h2 id="work-title">Selected work</h2>
  <div class="work-grid">
    <article class="card">
      <h3>Harbour</h3>
      <p>A booking flow for a coastal hostel, rebuilt around one decision per screen.</p>
      <a href="#harbour">Read the Harbour case study</a>
    </article>
    <article class="card">
      <h3>Common Room</h3>
      <p>A design system for a members' club, from type scale to accessible form fields.</p>
      <a href="#common-room">Read the Common Room case study</a>
    </article>
    <article class="card">
      <h3>Slow Sunday</h3>
      <p>An editorial site for a food writer, built to load in under a second.</p>
      <a href="#slow-sunday">Read the Slow Sunday case study</a>
    </article>
  </div>
</section>

<style>
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; line-height: 1.6; }
  .wrap { max-width: 64rem; margin: 0 auto; }
  h2 { margin: 0 0 1.5rem; font-size: 1.75rem; }
  .work-grid { display: grid; gap: 1rem; }
  .card { display: flex; flex-direction: column; gap: 0.5rem; padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .card h3, .card p { margin: 0; }
  .card p { color: #475569; }
  .card a { margin-top: auto; padding-top: 0.5rem; color: #0f766e; font-weight: 650; }
  @media (min-width: 40rem) { .work-grid { grid-template-columns: repeat(2, 1fr); } }
  @media (min-width: 60rem) { .work-grid { grid-template-columns: repeat(3, 1fr); } }
</style>
--- test
assertExists("#work", "Keep the Selected work section.");
const section = query("#work");
assert(section.querySelector("h2"), "Give the section an h2 heading.");
assertCount("#work .card", 3, "The section needs exactly three cards.");
for (const [index, card] of [...document.querySelectorAll("#work .card")].entries()) {
  assert(card.querySelector("h3"), `Card ${index + 1} needs an h3 project title.`);
  assert(card.querySelector("p"), `Card ${index + 1} needs a short description paragraph.`);
  const link = card.querySelector("a[href]");
  assert(link, `Card ${index + 1} needs a link with a real href.`);
  assert(normalize(link.textContent).length > 0, `Card ${index + 1}'s link needs a visible name.`);
  assert(link.tabIndex >= 0, `Card ${index + 1}'s link should be reachable with Tab.`);
}
const grid = query(".work-grid");
assertStyle(".work-grid", "display", "grid", "Lay the cards out with CSS Grid.");
const columns = getComputedStyle(grid).gridTemplateColumns.split(" ").filter(Boolean);
assert(columns.length === 3, `At this width the grid should show three columns; it currently has ${columns.length}.`);
assert(parseFloat(getComputedStyle(grid).gap) >= 8, "Add a visible gap between the cards.");
assertNoOverflow("The project grid should not make the page scroll sideways.");
--- hint
Use three `<article class="card">` elements inside `.work-grid`. Each one gets an `<h3>`, a `<p>` and an `<a href="...">`.
--- hint
The starter already contains the grid and the two media queries. Your job is the card markup, not a new layout system.
--- hint
Keep the link inside the card so it can receive focus normally. `margin-top: auto` on `.card a` will align the links when the descriptions differ in length.
```

## Contact should feel like an invitation

Most portfolio contact sections are an afterthought: a small line at the bottom, a generic form, an email address in 12px grey. This is the one place where the page asks the visitor to do something. Give it weight. A dark panel creates a clear ending, and the email address itself can be the largest link on the page.

The `mailto:` link is not a compromise. It opens the visitor's mail client, works without a server, and does not pretend to be a form that silently loses messages. If you later add a form, this is still the fallback. The email address is long, so `overflow-wrap: anywhere` lets it break instead of pushing the page sideways on a narrow screen. That one line prevents a whole class of mobile bugs.

```html run
<section id="contact" class="contact-wrap" aria-labelledby="contact-title">
  <div class="contact">
    <p class="eyebrow">Contact</p>
    <h2 id="contact-title">Have a project in mind?</h2>
    <p>I take on two or three collaborations a year. Tell me what you are making.</p>
    <a class="email" href="mailto:hello@maraokafor.example">hello@maraokafor.example</a>
  </div>
</section>
<footer class="footer">
  <p>© 2026 Mara Okafor · Lisbon</p>
  <a href="#main">Back to top</a>
</footer>
<style>
  :root { --ink: #0f172a; --muted: #475569; --accent: #0f766e; }
  * { box-sizing: border-box; }
  body { margin: 0; padding: 3rem 1.5rem; font-family: system-ui, sans-serif; line-height: 1.6; color: var(--ink); background: #f8fafc; }
  a { color: var(--accent); }
  :focus-visible { outline: 3px solid var(--accent); outline-offset: 3px; }
  .contact-wrap { max-width: 64rem; margin-inline: auto; }
  .contact { padding: clamp(1.5rem, 5vw, 3rem); border-radius: 24px; background: var(--ink); color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #99f6e4; font-size: 0.72rem; font-weight: 750; letter-spacing: 0.14em; text-transform: uppercase; }
  .contact h2 { margin: 0; color: #fff; font-size: clamp(1.6rem, 5vw, 2.5rem); letter-spacing: -0.03em; }
  .contact p { max-width: 48ch; margin: 0.75rem 0 0; }
  .email { display: inline-block; margin-top: 1.25rem; color: #99f6e4; font-size: clamp(1.05rem, 3.5vw, 1.5rem); font-weight: 700; overflow-wrap: anywhere; }
  .footer { display: flex; flex-wrap: wrap; justify-content: space-between; gap: 1rem; max-width: 64rem; margin: 0 auto; padding: 2rem 0 0; color: var(--muted); font-size: 0.85rem; }
  .footer p { margin: 0; }
</style>
```

The footer is deliberately quiet. It should not compete with the contact panel, but it still needs to be readable and its link needs a focus state. Small text is still text; 0.85rem is a floor, not a target.

## Make it responsive on purpose

Responsive design is not a list of device widths. It is a series of decisions about when the current layout stops working. For this page there are two honest breakpoints:

- **40rem:** the work cards have enough room for two columns, and the profile header can probably become a row. Below that, a row would squeeze the bio into a narrow strip.
- **60rem:** three project cards fit comfortably. Above that, the page is capped at 64rem so lines do not become unreadably long.

The base styles are the narrow ones. Media queries use `min-width` and add complexity as space becomes available. This is easier to maintain than starting with a desktop layout and trying to undo it, because every rule you add has a clear condition.

Two properties prevent most responsive overflow. `min-width: 0` on a flex child allows it to shrink below its content's intrinsic width; without it, a long word can force the whole row wider than the screen. `overflow-wrap: anywhere` on long links and email addresses lets the text break when there is no other option. Use them together.

> **Pitfall:** `display: none` is not a responsive strategy. Hiding the navigation on a phone and relying on JavaScript to build a menu means the links disappear when the script fails. With three links, wrapping is simpler, more accessible and faster.

```html predict id=profile-mobile-first title="Which layout appears at which width?"
<header class="profile">
  <div class="avatar" aria-hidden="true">MO</div>
  <div><h1>Mara Okafor</h1><p class="role">Design engineer</p></div>
</header>
<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; }
  .profile { display: flex; flex-direction: column; gap: 1rem; }
  @media (min-width: 700px) { .profile { flex-direction: row; align-items: center; } }
  .avatar { display: grid; place-items: center; width: 72px; height: 72px; border-radius: 20px; background: #0f172a; color: #fff; font-weight: 700; }
  h1, p { margin: 0; }
</style>
--- options
* Stacked at 500px, side by side at 900px
Side by side at 500px, stacked at 900px
Stacked at both widths
Side by side at both widths
--- explain
The base rule is `flex-direction: column`, so the narrow layout stacks. The media query only applies from 700px upward, where it switches to a row. This is mobile-first: the simple, narrow layout is the default, and the wider layout is the enhancement. If you reversed the query to `max-width: 700px`, the desktop layout would be the default and the phone layout would be the special case.
```

## Debug: the header that refuses to stack

This profile header works beautifully on a wide screen. On a phone-width preview, the avatar and the text stay in a row and squeeze each other until the bio becomes a narrow column of words. The media query is there, but it only changes the gap. Run it, switch the preview to phone width, and find the missing rule.

```html debug id=profile-mobile-stack title="Make the profile header stack on narrow screens"
<header class="site-header">
  <div class="avatar" aria-hidden="true">MO</div>
  <div class="identity">
    <h1>Mara Okafor</h1>
    <p class="role">Design engineer · Lisbon</p>
    <p class="bio">I build calm, accessible interfaces for teams that care about the details.</p>
  </div>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; line-height: 1.6; }
  .site-header {
    display: flex;
    align-items: center;
    gap: 2rem;
    max-width: 60rem;
    margin: 3rem auto;
    padding: 0 1.5rem;
  }
  .avatar { display: grid; place-items: center; width: 88px; height: 88px; flex: none; border-radius: 24px; background: #0f172a; color: #fff; font-size: 1.4rem; font-weight: 700; }
  .identity { min-width: 0; }
  h1 { margin: 0; font-size: clamp(2rem, 6vw, 3.5rem); line-height: 1.02; letter-spacing: -0.045em; }
  .role { margin: 0.35rem 0 0; color: #0f766e; font-weight: 600; }
  .bio { max-width: 44ch; margin: 0.75rem 0 0; color: #475569; }
  @media (max-width: 640px) {
    .site-header { gap: 1rem; }
    .bio { max-width: none; }
  }
</style>
--- solution
<header class="site-header">
  <div class="avatar" aria-hidden="true">MO</div>
  <div class="identity">
    <h1>Mara Okafor</h1>
    <p class="role">Design engineer · Lisbon</p>
    <p class="bio">I build calm, accessible interfaces for teams that care about the details.</p>
  </div>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; color: #0f172a; background: #f8fafc; line-height: 1.6; }
  .site-header {
    display: flex;
    align-items: center;
    gap: 2rem;
    max-width: 60rem;
    margin: 3rem auto;
    padding: 0 1.5rem;
  }
  .avatar { display: grid; place-items: center; width: 88px; height: 88px; flex: none; border-radius: 24px; background: #0f172a; color: #fff; font-size: 1.4rem; font-weight: 700; }
  .identity { min-width: 0; }
  h1 { margin: 0; font-size: clamp(2rem, 6vw, 3.5rem); line-height: 1.02; letter-spacing: -0.045em; }
  .role { margin: 0.35rem 0 0; color: #0f766e; font-weight: 600; }
  .bio { max-width: 44ch; margin: 0.75rem 0 0; color: #475569; }
  @media (max-width: 640px) {
    .site-header { flex-direction: column; align-items: flex-start; gap: 1rem; }
    .bio { max-width: none; }
  }
</style>
--- test
function styleEntries() {
  const entries = [];
  for (const sheet of document.styleSheets) {
    const walk = (rules, query) => {
      for (const rule of rules) {
        if (rule.media) walk(rule.cssRules, `${query} ${rule.media.mediaText}`.trim());
        else if (rule.selectorText) entries.push({ selector: rule.selectorText, style: rule.style, query });
      }
    };
    walk(sheet.cssRules, "");
  }
  return entries;
}
assertExists(".site-header", "Keep the profile header");
assertExists(".site-header h1", "Keep the person's name in an h1");
assertStyle(".site-header", "display", "flex", "The profile header should use Flexbox.");
const desktop = getComputedStyle(query(".site-header")).flexDirection;
assert(desktop === "row", `At desktop width the avatar and text should sit side by side; they currently use ${desktop}.`);
const entries = styleEntries();
const narrowColumn = entries.some((entry) =>
  /max-width/.test(entry.query) && /\.site-header/.test(entry.selector) && entry.style.flexDirection === "column"
);
const mobileFirst = entries.some((entry) =>
  !entry.query && /\.site-header/.test(entry.selector) && entry.style.flexDirection === "column"
) && entries.some((entry) =>
  /min-width/.test(entry.query) && /\.site-header/.test(entry.selector) && entry.style.flexDirection === "row"
);
assert(narrowColumn || mobileFirst, "Below 640px the header still lays out as a row. Add flex-direction: column in the narrow media query, or switch to a mobile-first column base with a min-width row.");
assertNoOverflow("The profile header should not make the page scroll sideways.");
--- hint
The hover and desktop styles are fine. The bug is in the `max-width: 640px` block: it changes the gap but never changes the direction.
--- hint
Add `flex-direction: column;` and `align-items: flex-start;` to `.site-header` inside the media query.
--- hint
If you prefer mobile-first, put `flex-direction: column` on the base `.site-header` and add a `@media (min-width: 640px)` rule that sets `flex-direction: row`. Either approach is valid; the test accepts both.
```

## The finished page

Here is the whole page with every layer in place: tokens, the header, the stacked-then-row profile, the three-column work grid, the contact panel, the footer and the interaction states. The final cell is a fragment; the skeleton at the top of the lesson is the full document, and you would put this body inside it. Resize the preview from phone to desktop and watch the same content recompose rather than break.

```html run
<header class="site-header wrap">
  <p class="wordmark">Mara Okafor</p>
  <nav aria-label="Primary"><a href="#work">Work</a> <a href="#about">About</a> <a href="#contact">Contact</a></nav>
</header>
<main id="main" class="wrap">
  <section id="about" class="profile" aria-labelledby="profile-name">
    <div class="avatar" aria-hidden="true">MO</div>
    <div><h1 id="profile-name">Mara Okafor</h1><p class="role">Design engineer · Lisbon</p><p class="bio">I build calm, accessible interfaces for teams that care about the details.</p></div>
  </section>
  <section id="work" aria-labelledby="work-title">
    <h2 id="work-title">Selected work</h2>
    <div class="work-grid">
      <article class="card"><p class="index">01</p><h3>Harbour</h3><p>A booking flow for a coastal hostel, rebuilt around one decision per screen.</p><a href="#harbour">Read the case study</a></article>
      <article class="card"><p class="index">02</p><h3>Common Room</h3><p>A design system for a members' club, from type scale to accessible form fields.</p><a href="#common-room">Read the case study</a></article>
      <article class="card"><p class="index">03</p><h3>Slow Sunday</h3><p>An editorial site for a food writer, built to load in under a second.</p><a href="#slow-sunday">Read the case study</a></article>
    </div>
  </section>
  <section id="contact" class="contact" aria-labelledby="contact-title">
    <h2 id="contact-title">Have a project in mind?</h2>
    <p>I take on two or three collaborations a year. Tell me what you are making.</p>
    <a class="email" href="mailto:hello@maraokafor.example">hello@maraokafor.example</a>
  </section>
</main>
<footer class="footer wrap"><p>© 2026 Mara Okafor · Lisbon</p><a href="#main">Back to top</a></footer>
<style>
  :root { --ink:#0f172a; --muted:#475569; --paper:#f8fafc; --card:#fff; --line:#e2e8f0; --accent:#0f766e; } * { box-sizing:border-box; }
  body { margin:0; font-family:system-ui,sans-serif; line-height:1.6; color:var(--ink); background:var(--paper); } a { color:var(--accent); } :focus-visible { outline:3px solid var(--accent); outline-offset:3px; }
  .wrap { width:min(100% - 2rem,64rem); margin-inline:auto; } .site-header { display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:1rem; padding-block:1.25rem; border-bottom:1px solid var(--line); }
  .wordmark { margin:0; font-weight:750; letter-spacing:-.02em; } nav { display:flex; gap:1rem; font-size:.9rem; font-weight:600; } nav a { color:var(--ink); text-decoration:none; }
  nav a:hover { color:var(--accent); text-decoration:underline; text-underline-offset:4px; } main { padding-block:clamp(2rem,6vw,4rem); }
  .profile { display:flex; flex-direction:column; align-items:flex-start; gap:1.5rem; } .avatar { display:grid; place-items:center; width:88px; height:88px; flex:none; border-radius:24px; background:var(--ink); color:#fff; font-size:1.4rem; font-weight:750; }
  h1 { margin:0; font-size:clamp(2rem,6vw,3.5rem); line-height:1.02; letter-spacing:-.045em; } .role { margin:.4rem 0 0; color:var(--accent); font-weight:650; } .bio { max-width:44ch; margin:.8rem 0 0; color:var(--muted); } section { margin-top:clamp(2.5rem,6vw,4rem); } h2 { font-size:1.35rem; letter-spacing:-.02em; } .work-grid { display:grid; gap:1rem; }
  .card { display:flex; flex-direction:column; gap:.5rem; padding:1.25rem; border:1px solid var(--line); border-radius:16px; background:var(--card); transition:transform 180ms ease,box-shadow 180ms ease; }
  .card h3,.card p { margin:0; } .card p { color:var(--muted); } .card a { margin-top:auto; padding-top:.5rem; font-weight:650; }
  .card:hover { transform:translateY(-3px); box-shadow:0 12px 30px rgb(15 23 42 / .08); } .contact { padding:1.5rem; border-radius:20px; background:var(--ink); color:#e2e8f0; }
  .contact a { color:#99f6e4; font-size:clamp(1.1rem,4vw,1.6rem); font-weight:700; overflow-wrap:anywhere; } .footer { display:flex; flex-wrap:wrap; justify-content:space-between; gap:1rem; padding-block:2rem; color:var(--muted); font-size:.85rem; }
  @media (min-width:40rem) { .profile { flex-direction:row; align-items:center; gap:2rem; } .work-grid { grid-template-columns:repeat(2,1fr); } }
  @media (min-width:60rem) { .work-grid { grid-template-columns:repeat(3,1fr); } }
</style>
```

The page now has a clear reading order and visual order, and they match. The header introduces the person, the work provides evidence, the contact panel asks for the next step, and the footer closes the page. On a phone the sequence survives; only the geometry changes.

## Finishing checks

Before calling a profile page done, run these checks:

1. **Tab through the entire page.** The skip link appears first, every nav link gets a ring, each project link is reachable, and the email is reachable. You never lose your place.
2. **Resize to 320px.** There is no horizontal scrollbar. The email breaks if it must. The header wraps rather than overflowing.
3. **Zoom to 200%.** Text grows without overlapping. Nothing is positioned in a way that depends on a fixed pixel height.
4. **Check contrast.** Body text against the page, muted text against the page, accent links against both the page and the dark contact panel. The teal link colour will not pass on every background; on the dark panel, the lighter mint is the correct choice.
5. **Read the outline.** One `h1`, two `h2`s, no skipped levels, and every section has a name.
6. **Turn on reduced motion.** The card lift disappears or becomes instant; the content remains.

## Recap

- Semantic landmarks — `header`, `nav`, `main`, `section`, `footer` — make the page navigable before CSS is involved.
- Design tokens on `:root` give the palette, spacing and type scale one source of truth.
- Mobile-first CSS starts with the narrow, stacked layout and adds columns at `min-width` breakpoints.
- Grid makes the project cards share a row height; Flexbox aligns the contents inside each card.
- Accessible navigation needs a label, real links, matching section ids and visible focus.
- A contact section is an invitation. Make the email large, readable and safe to wrap.

**Up next:** the final capstone. You will build a complete product landing page — hero, feature grid, pricing cards and an accessible signup form — and apply the same system thinking to a page whose job is to make one clear offer.
