A page can look organised and still be a maze. Sighted users get clues from position, colour and size: the logo top-left, the menu across the top, the article in the middle, the small print at the bottom. A screen reader user gets none of that unless the markup says so. Landmarks are the names of the rooms. They let someone jump straight to the main content, skip the navigation, or find the complementary notes without reading the page from the first word.

This lesson is about the structural elements that turn a pile of boxes into a document: `header`, `nav`, `main`, `section`, `article`, `aside`, `footer` and the two silent workhorses, `div` and `span`. You will build a real blog page, add a skip link, and fix a page that has two main content areas — a bug that is invisible on screen and obvious to assistive technology.

## Div soup looks fine

A `<div>` is a generic block container. A `<span>` is a generic inline container. Neither carries meaning. That is not a moral failing: they are the right tool when you need a hook for CSS or a wrapper for layout and no semantic element fits. The problem starts when *everything* is a div.

```html run
<div class="page">
  <div class="top">
    <div class="brand">Field notes</div>
    <div class="links"><span>Home</span> <span>Archive</span> <span>About</span></div>
  </div>
  <div class="content">
    <div class="post">
      <div class="title">Three ways to read a landscape</div>
      <div class="meta">18 October 2026</div>
      <div class="text">A ridge is not just a line on a map. It is a decision about where the water goes.</div>
    </div>
  </div>
  <div class="bottom">© 2026 Field notes</div>
</div>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .page { max-width: 42rem; margin: 0 auto; background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; }
  .top { display: flex; justify-content: space-between; padding: 1rem 1.25rem; border-bottom: 1px solid #e2e8f0; }
  .brand { font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .links span { margin-left: 1rem; color: #0f766e; font-weight: 600; }
  .content { padding: 1.5rem 1.25rem; }
  .title { font-size: 2rem; font-weight: 700; letter-spacing: -0.03em; }
  .meta { margin: 0.4rem 0 1rem; color: #64748b; font-size: 0.9rem; }
  .text { color: #334155; line-height: 1.65; }
  .bottom { padding: 1rem 1.25rem; border-top: 1px solid #e2e8f0; color: #64748b; font-size: 0.85rem; }
</style>
```

Nothing here is invalid HTML. It renders exactly as intended. But in the accessibility tree there is no banner, no navigation, no main content, no article, no footer, and no heading. The "links" are spans, so they are not focusable and cannot be opened. The title is a div with large text, so it is not a heading and cannot be jumped to. This is what people mean by "div soup": a page with a visual structure and no semantic one.

> **Under the hood:** The accessibility tree is built from the DOM plus each element's role and name. A `div` has a generic role and no name. A `header`, `nav` or `main` has a landmark role. That is why replacing divs with the right elements changes what a screen reader can do, even when the CSS is untouched.

## The landmarks, one by one

Here is the working vocabulary. Each element answers a different question about the region it wraps.

| Element | Role | Use it for |
|---|---|---|
| `<header>` | banner (when at page level) | Logo, site name, tagline, primary navigation |
| `<nav>` | navigation | Major groups of links: main menu, table of contents, footer links |
| `<main>` | main | The primary content of the page, once per page |
| `<aside>` | complementary | Related links, pull quotes, author notes, ads |
| `<footer>` | contentinfo (when at page level) | Copyright, contact details, legal links |
| `<section>` | region (when named) | A thematic group with its own heading |
| `<article>` | article | A self-contained composition: post, card, comment, widget |

`<header>` and `<footer>` are not limited to the top and bottom of the page. An article can have its own header and footer; a section can too. The landmark role changes with context: a `header` inside an `article` is that article's header, not the page banner. A `footer` inside a section is that section's footer, not the site-wide contentinfo.

`<nav>` is for *major* navigation, not every group of links. Two or three links in a paragraph do not need a nav. A page with a main menu and a separate table of contents should have two navs, each with a distinct accessible name:

```html
<nav aria-label="Main">…</nav>
<nav aria-label="On this page">…</nav>
```

`<main>` is the primary content. It should contain the page's `h1` and the content a reader came for. It should not contain the site-wide header, navigation, sidebar or footer. A document should have one visible `<main>`; if you find yourself adding a second, you usually want an `<article>` or an `<aside>` instead.

`<section>` is a thematic grouping. Give it a heading — without one it is just a div with a longer name. A heading alone does not give the section an accessible name, though: when you want the region announced, add `aria-labelledby` pointing at that heading. If you only need a styling wrapper and no heading, a `<div>` is the honest choice. `<article>` is stronger: it is a self-contained composition that could be syndicated or reused on another page. A blog post is an article. A product card is an article. A comment is an article, and comments can nest inside a comments section.

`<aside>` is for content that is related but tangential: related posts, a glossary, an author bio, a pull quote. If the reader skipped it, they would still understand the main content. `<footer>` closes a page or a section with metadata, credits or links.

> **Tip:** Native elements already have the right roles. You rarely need `role="banner"` or `role="main"` on a div. Prefer `<header>` and `<main>`; ARIA roles are a patch for when native HTML cannot express the structure, not a replacement for it.

## A page with rooms

Here is the same field-notes page, rebuilt with landmarks. The visual design is deliberately similar; the difference is in what the browser and assistive technology can see.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Field notes · Three ways to read a landscape</title>
  </head>
  <body>
    <header class="site-header">
      <p class="brand">Field notes</p>
      <nav aria-label="Main">
        <a href="index.html">Home</a>
        <a href="archive.html">Archive</a>
        <a href="about.html">About</a>
      </nav>
    </header>
    <main>
      <article>
        <h1>Three ways to read a landscape</h1>
        <p class="meta">18 October 2026</p>
        <p>A ridge is not just a line on a map. It is a decision about where the water goes.</p>
        <h2>Start with the ground</h2>
        <p>Look for the boggy patches. They tell you where the path will disappear after rain.</p>
      </article>
    </main>
    <footer>
      <p>© 2026 Field notes. Written on the 596 bus.</p>
    </footer>
    <style>
      body { margin: 0; font-family: system-ui, sans-serif; color: #1e293b; background: #f8fafc; }
      .site-header, main, footer { max-width: 42rem; margin: 0 auto; padding: 1.5rem; }
      .site-header { display: flex; justify-content: space-between; border-bottom: 1px solid #e2e8f0; }
      .brand { margin: 0; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
      nav a { margin-left: 1rem; color: #0f766e; font-weight: 600; }
      h1 { font-size: 2.25rem; letter-spacing: -0.03em; }
      .meta { color: #64748b; font-size: 0.9rem; }
      footer { color: #64748b; font-size: 0.85rem; border-top: 1px solid #e2e8f0; }
    </style>
  </body>
</html>
```

The page now has a banner, a navigation landmark, a main landmark, an article and a contentinfo footer. The `h1` is inside `main` and inside the article. A screen reader can list those landmarks and jump to any of them. The visual result is almost identical to the div version, which is the point: semantics are not decoration.

## One main, one outline

Two rules do most of the work in a well-structured page.

**One visible main per page.** The `<main>` element marks the primary content. It must not be nested inside a `header`, `nav`, `aside`, `footer` or `article`, and there should be exactly one of it. If a layout seems to need two, one of them is probably an article or an aside. The main element is also the target of the skip link, so its identity matters.

**Headings form an outline.** Use one `h1` for the page's main topic, `h2` for major sections, `h3` for subsections and so on. Do not skip levels to get a smaller font size. The heading level is the nesting level of the content; the size is CSS's job. `section` does not automatically create a heading level, and a heading inside a section still needs the right number for its place in the document.

Browsers never implemented the old HTML5 outline algorithm that was supposed to generate a document outline from sectioning elements. Screen readers navigate the `h1`–`h6` levels you actually write. That is why an `h2` followed by an `h4` is a real problem: the outline has a hole in it.

```html run
<main>
  <h1>Field notes from the ridge</h1>
  <p class="lede">Three hours of wind, one flask of tea, and a lesson about heather.</p>

  <section aria-labelledby="ridge">
    <h2 id="ridge">On the ridge</h2>
    <p>The path follows the wall for a mile before it turns north.</p>
    <h3>What the wind does</h3>
    <p>It pushes the grass flat and makes every conversation a shout.</p>
    <h3>What the heather hides</h3>
    <p>Grouse, mostly. Also a surprising number of lost gloves.</p>
  </section>

  <section aria-labelledby="car">
    <h2 id="car">Back at the car</h2>
    <p>The car park is free after six, which is the only reason we stayed so long.</p>
  </section>
</main>

<style>
  body { font-family: system-ui, sans-serif; max-width: 40rem; margin: 2rem auto; padding: 0 1.5rem; line-height: 1.65; color: #1e293b; }
  h1 { letter-spacing: -0.03em; }
  h2 { margin-top: 2rem; border-top: 1px solid #e2e8f0; padding-top: 1rem; }
  h3 { margin-bottom: 0.2rem; color: #0f766e; }
  .lede { color: #475569; font-size: 1.1rem; }
</style>
```

The two `section` elements are thematic parts of the same page. Each has an `h2`; the subsections inside the first have `h3`s. The hierarchy is visible in the markup, not just in the font sizes.

> **Pitfall:** A `section` without a heading is just a div with a longer name. If you cannot write a heading for it, ask whether it is really a section. A styling wrapper should stay a `div`.

## Article, section or aside?

This is the judgement call that trips up even experienced developers. The question is not "which one looks right?" but "what is this content *doing*?"

- An **article** is self-contained. If you copied it into a newsletter or another page, it would still make sense. A blog post, a product card, a comment, a widget.
- A **section** is a part of something larger. It groups related content under a heading. "What you'll learn" inside a workshop card is a section.
- An **aside** is a side note. Related links, an author bio, a pull quote. It supports the main content without being part of its argument.

```html run
<main class="page">
  <h1>Workshops</h1>

  <article class="card">
    <h2>Green wood stool</h2>
    <p>Two days in the workshop, one stool, and a lot of shavings.</p>
    <section aria-labelledby="stool-details">
      <h3 id="stool-details">What you'll learn</h3>
      <ul>
        <li>Sharpening a drawknife</li>
        <li>Reading the grain before you cut</li>
        <li>Finishing with oil and wax</li>
      </ul>
    </section>
  </article>

  <aside class="note">
    <h2>Also running</h2>
    <p>The spoon-carving evening is back in November. Bring a headtorch.</p>
  </aside>
</main>

<style>
  body { font-family: system-ui, sans-serif; background: #f8fafc; margin: 0; padding: 2rem; }
  .page { max-width: 42rem; margin: 0 auto; }
  .card { background: white; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; }
  .card h3 { margin-bottom: 0.4rem; color: #0f766e; }
  .card ul { margin-top: 0; color: #334155; line-height: 1.6; }
  .note { margin-top: 1.5rem; padding: 1rem 1.25rem; border-left: 4px solid #f59e0b; background: #fffbeb; }
  .note h2 { margin: 0 0 0.4rem; font-size: 1.1rem; }
</style>
```

The workshop card is an article because it is a complete listing that could appear on a workshops page, a category page or a newsletter. "What you'll learn" is a section because it only makes sense inside that card. The note about the spoon-carving evening is an aside because it is related but not part of the workshop listing. The `aria-labelledby` on the section points at its heading, giving the region an explicit name.

## Skip links and keyboard travel

A sighted mouse user can ignore the navigation and click the article. A keyboard user has to Tab through every link before reaching the content. A skip link is a normal anchor, placed first in the document, that jumps to the main content. It is hidden until it receives focus, then appears.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Skip link demo</title>
  </head>
  <body>
    <a class="skip-link" href="#main">Skip to main content</a>

    <header class="site-header">
      <p class="brand">Field notes</p>
      <nav aria-label="Main">
        <a href="index.html">Home</a>
        <a href="archive.html">Archive</a>
        <a href="about.html">About</a>
      </nav>
    </header>

    <main id="main" tabindex="-1">
      <h1>Reading the landscape</h1>
      <p>Click the preview, then press Tab. The skip link appears at the top left.</p>
      <h2>Start with the ground</h2>
      <p>Boggy patches tell you where the path will disappear after rain.</p>
    </main>

    <style>
      body { margin: 0; font-family: system-ui, sans-serif; color: #1e293b; }
      .skip-link { position: absolute; top: -4rem; left: 1rem; padding: 0.75rem 1rem; background: #0f172a; color: white; border-radius: 0 0 8px 8px; z-index: 10; }
      .skip-link:focus { top: 0; outline: 3px solid #f59e0b; }
      .site-header { display: flex; justify-content: space-between; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
      .brand { margin: 0; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
      nav a { margin-left: 1rem; color: #0f766e; font-weight: 600; }
      main { max-width: 42rem; margin: 0 auto; padding: 1.5rem; }
      h1 { font-size: 2rem; }
    </style>
  </body>
</html>
```

The link is first in the DOM, so it is the first thing Tab reaches. It is not `display: none` or `visibility: hidden` — those would make it unfocusable. It is moved offscreen with `top: -4rem` and brought back on `:focus`. The `href="#main"` matches `id="main"`, and `tabindex="-1"` lets the browser move focus into the main element rather than only scrolling to it.

> **Tip:** Put the skip link before the header, not after the navigation. Its whole purpose is to come before the thing it helps you skip. Keep the link text explicit: "Skip to main content" is better than "Skip".

## Challenge: build a field-notes page

Build the structure for a blog page. It needs a page header with a `nav` of three links, a `main` containing an `article` with the page's `h1`, a page footer, and a skip link as the first link on the page.

The skip link should say **Skip to main content** and point at `#main`. The main element needs `id="main"` and a `tabindex="-1"` so focus can land there.

```html exercise id=field-notes-page title="Build a field-notes page"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Field notes</title>
  </head>
  <body>
    <div class="header">
      <p class="brand">Field notes</p>
      <div class="nav">Home · Archive · About</div>
    </div>

    <div class="content">
      <div class="article">
        <div class="title">Three ways to read a landscape</div>
        <p>A ridge is not just a line on a map.</p>
      </div>
    </div>

    <div class="footer">© 2026 Field notes</div>
  </body>
</html>
--- solution
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Field notes</title>
  </head>
  <body>
    <a class="skip-link" href="#main">Skip to main content</a>

    <header class="site-header">
      <p class="brand">Field notes</p>
      <nav aria-label="Main">
        <a href="index.html">Home</a>
        <a href="archive.html">Archive</a>
        <a href="about.html">About</a>
      </nav>
    </header>

    <main id="main" tabindex="-1">
      <article>
        <h1>Three ways to read a landscape</h1>
        <p>A ridge is not just a line on a map.</p>
      </article>
    </main>

    <footer>
      <p>© 2026 Field notes</p>
    </footer>
  </body>
</html>
--- test
assertCount("main", 1, `The page should have one main element, but it has ${document.querySelectorAll("main").length}.`);
assertAttr("main", "id", "main", "Give main id='main' so the skip link has a target.");
const skip = query('a[href="#main"]');
assert(skip === document.querySelector("a"), "The skip link should be the first link on the page, before the header.");
assertText('a[href="#main"]', "Skip to main content", "The skip link should read: Skip to main content.");
assertExists("header", "Use a header element for the page header.");
assertExists("nav", "Add a nav element for the main page links.");
const navLinks = Array.from(document.querySelectorAll("nav a"));
assert(navLinks.length >= 3, `The navigation should have at least 3 links, but it has ${navLinks.length}.`);
navLinks.forEach((a) => assert(normalize(a.textContent).length > 0, "Every navigation link needs text."));
assertExists("main article", "The article should sit inside main.");
assertExists("main h1", "The page's h1 should be inside main.");
assertExists("main article h2, main article h1", "The article needs its own heading.");
assertExists("footer", "Use a footer element for the page footer.");
--- hint
The skip link goes first in the body, before the header. Its `href` and the main element's `id` must match.
--- hint
Replace the outer divs with `<header>`, `<nav>`, `<main>`, `<article>` and `<footer>`. The title div becomes the `h1`.
--- hint
The main element needs both `id="main"` and `tabindex="-1"`. Keep the skip link visually hidden with CSS later, but keep it first in the DOM.
```

## Predict: which landmark leads to the content?

Read the page structure. Which element is the best landmark for the primary content — the thing the reader came for?

```html predict id=primary-landmark title="Which landmark leads to the content?"
<header>
  <p>Field notes</p>
  <nav aria-label="Main"><a href="index.html">Home</a></nav>
</header>
<main>
  <h1>Three ways to read a landscape</h1>
  <article>
    <h2>Start with the ground</h2>
    <p>Look for the boggy patches.</p>
  </article>
</main>
<aside>
  <h2>About the author</h2>
  <p>Noah writes about walks and woodwork.</p>
</aside>
<footer>© 2026 Field notes</footer>
--- options
* The main element, because it marks the primary content of the page
The article element, because every page is an article
The section element, because it groups related content
A div with class="content", because it can hold anything
--- explain
`main` is the landmark for the page's primary content, and a screen reader user can jump straight to it. The article is one self-contained piece inside main; a section groups a theme within a larger page; a div has no landmark role at all.
```

## Challenge: choose article or section

This workshop card is built from divs. Make the card an `article`, because it is a self-contained listing that could appear on another page. Make the "What you'll learn" block a `section` with its heading. Keep the existing text and list.

```html exercise id=workshop-card title="Choose article or section"
<main class="page">
  <h1>Workshops</h1>
  <div class="card">
    <h2>Green wood stool</h2>
    <p>Two days in the workshop, one stool, and a lot of shavings.</p>
    <div class="details">
      <h3>What you'll learn</h3>
      <ul>
        <li>Sharpening a drawknife</li>
        <li>Reading the grain before you cut</li>
        <li>Finishing with oil and wax</li>
      </ul>
    </div>
  </div>
</main>
--- solution
<main class="page">
  <h1>Workshops</h1>
  <article class="card">
    <h2>Green wood stool</h2>
    <p>Two days in the workshop, one stool, and a lot of shavings.</p>
    <section aria-labelledby="stool-details">
      <h3 id="stool-details">What you'll learn</h3>
      <ul>
        <li>Sharpening a drawknife</li>
        <li>Reading the grain before you cut</li>
        <li>Finishing with oil and wax</li>
      </ul>
    </section>
  </article>
</main>
--- test
assertExists("article.card", "The workshop card should be an article: it is a self-contained listing.");
assertText("article.card h2", "Green wood stool", "Keep the workshop title as the card's heading.");
const section = query("article.card section");
assert(section, "The 'What you'll learn' block should be a section inside the article.");
assertExists("article.card section h2, article.card section h3", "A section needs its own heading.");
assertText("article.card section h3", "What you'll learn", "The section heading should remain 'What you'll learn'.");
assertCount("article.card li", 3, "Keep all three learning outcomes in the list.");
--- hint
The card is one complete workshop listing, so it is an `article`. The details block is only part of that article, so it is a `section`.
--- hint
Change `<div class="card">` to `<article class="card">` and `<div class="details">` to `<section>`.
--- hint
The section already has an `h3`. If you add `aria-labelledby`, point it at an `id` on that heading.
```

## Debug: the page with two mains

This field-notes page renders, but its structure has two problems. There are two `<main>` elements, and the page has no `h1` inside its main content. The navigation inside the first main is fine; a table of contents can live there. The author note is what should move out of the main flow.

```html debug id=two-mains title="The page with two mains"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Field notes</title>
  </head>
  <body>
    <header>
      <p class="brand">Field notes</p>
    </header>

    <main>
      <nav aria-label="On this page">
        <a href="#reading">Reading the landscape</a>
      </nav>
      <article id="reading">
        <h2>Three ways to read a landscape</h2>
        <p>A ridge is not just a line on a map.</p>
      </article>
    </main>

    <main class="sidebar">
      <h2>About the author</h2>
      <p>Noah writes about walks and woodwork.</p>
      <nav aria-label="Related">
        <a href="archive.html">More field notes</a>
      </nav>
    </main>

    <footer>© 2026 Field notes</footer>
  </body>
</html>
--- solution
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Field notes</title>
  </head>
  <body>
    <header>
      <p class="brand">Field notes</p>
    </header>

    <main>
      <h1>Field notes</h1>
      <nav aria-label="On this page">
        <a href="#reading">Reading the landscape</a>
      </nav>
      <article id="reading">
        <h2>Three ways to read a landscape</h2>
        <p>A ridge is not just a line on a map.</p>
      </article>
    </main>

    <aside class="sidebar">
      <h2>About the author</h2>
      <p>Noah writes about walks and woodwork.</p>
      <nav aria-label="Related">
        <a href="archive.html">More field notes</a>
      </nav>
    </aside>

    <footer>© 2026 Field notes</footer>
  </body>
</html>
--- test
const mains = document.querySelectorAll("main");
assert(mains.length === 1, `The page has ${mains.length} main elements. A document needs one primary main; the author note is not one.`);
assertCount("h1", 1, `The page should have exactly one h1, but it has ${document.querySelectorAll("h1").length}.`);
assertExists("main h1", "The h1 belongs inside main, as the top-level heading for the primary content.");
assertExists("aside", "The author note should become an aside, not a second main.");
assertExists("main article", "Keep the article inside main.");
assertExists("footer", "Keep the page footer.");
--- hint
One of the two `<main>` elements is really a sidebar. An author note that supports the article is an `<aside>`.
--- hint
The page also needs a visible `h1`. Put it at the top of the remaining main element, above the table of contents.
--- hint
Change the second `<main class="sidebar">` to `<aside class="sidebar">`, and add `<h1>Field notes</h1>` inside the first main.
```

## Recap

- `header`, `nav`, `main`, `aside` and `footer` create landmarks; `section` and `article` give structure inside them.
- Use one visible `main` per page, and keep it out of headers, navigation, asides, footers and articles.
- Put the page's `h1` in `main`, then use `h2` and `h3` in order. Heading levels are the outline; size is CSS.
- A `section` should have a heading. Add `aria-labelledby` when you want it announced as a named region; a `div` is the right choice when you only need a styling wrapper.
- `article` is self-contained; `section` is a part of something larger; `aside` is tangential.
- A skip link is the first focusable element, points at `#main`, and becomes visible on focus. Native landmarks are what screen readers list and jump between.

**Up next:** tables — the one place where rows, columns and headers are not just a layout convenience, and where a missing header makes the data unreadable.
