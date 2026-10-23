The web is not a shelf of separate pages. It is a web because pages point at each other. A link is the simplest user interface ever invented: one line of text, one destination, and a browser that handles the rest. Images are the other half of the same idea — they carry information that words alone would make clumsy, but only if you describe them for the people who cannot see them.

This lesson is about the two attributes that do most of that work: `href` and `alt`. You will learn how paths resolve, how a fragment jumps inside a page, why "click here" is a broken link label even when the link works, and how to write image markup that reserves space, loads sensibly and survives a broken connection. Every image in this lesson is an inline SVG data URI, so nothing depends on the network.

## A link is a promise about a destination

An anchor is written with `<a href="…">`. The `href` is the destination; the text between the tags is the label the user sees, clicks and hears. The browser turns the whole thing into a focusable link that can be opened with a mouse, the Enter key or a screen reader's list of links.

```html run
<header class="site-header">
  <p class="brand">Moss & Pine</p>
  <nav aria-label="Main">
    <a href="index.html">Home</a>
    <a href="work.html">Work</a>
    <a href="journal/autumn.html">Journal</a>
    <a href="contact.html">Contact</a>
  </nav>
</header>

<p class="note">These are relative links. In the preview they point at pages that do not exist, so clicking one may show an error. The markup is what matters here.</p>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { max-width: 46rem; margin: 0 auto; }
  .brand { margin: 0 0 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  .note { max-width: 46rem; margin: 1.5rem auto 0; color: #475569; line-height: 1.6; }
</style>
```

An `<a>` without an `href` is not a link. It is a placeholder that cannot be reached with the Tab key and is not announced as a link. Do not use it for something that performs an action, and do not use a dead link to mark the current page in a menu; use `aria-current="page"` on a real link, or plain text. A link navigates; a button acts. That distinction matters more once JavaScript arrives, but the markup rule starts here.

## Relative, root-relative and absolute paths

The value of `href` can be one of three kinds of path, and the difference is where the browser starts looking.

| Kind | Example | Resolves from |
|---|---|---|
| Document-relative | `autumn.html`, `../work.html` | The URL of the current page |
| Root-relative | `/contact.html` | The root of the current site |
| Absolute | `https://example.com/contact` | The full URL, including the scheme and host |

Imagine you are on `https://mossandpine.example/journal/autumn.html`. A link to `autumn.html` stays in `/journal/`. A link to `../work.html` climbs one directory to `/work.html`. A link to `/contact.html` goes to the site root regardless of where the current page lives. A link to `https://example.com` leaves your site entirely.

Use document-relative paths for pages that travel together: a project folder you can move or rename without rewriting every link. Use root-relative paths for stable site-wide destinations such as the home page or the main stylesheet. Use absolute URLs for other sites. The tricky part is not the syntax; it is remembering which directory the browser considers "here".

> **Tip:** A trailing slash matters. `https://example.com/work` and `https://example.com/work/` can resolve to different resources. For a folder, keep the slash; for a file, use the filename.

## Fragments jump inside the same page

A link that starts with `#` points at an element on the current page whose `id` matches the rest of the value. `href="#hours"` jumps to `id="hours"`. The URL gains a fragment, the browser scrolls, and the Back button takes the reader back to where they were.

```html run
<nav aria-label="On this page">
  <a href="#hours">Opening hours</a>
  <a href="#travel">Getting here</a>
  <a href="#access">Access</a>
</nav>

<section id="hours">
  <h2>Opening hours</h2>
  <p>Friday to Sunday, 10am–4pm. Closed on bank holidays, unless the sun is out.</p>
</section>

<section id="travel">
  <h2>Getting here</h2>
  <p>The 596 bus stops at the end of Mill Lane. The nearest station is Hebden Bridge, twenty minutes on foot.</p>
</section>

<section id="access">
  <h2>Access</h2>
  <p>The workshop entrance is step-free. The upstairs studio is reached by a narrow staircase; ask us and we will bring the work down.</p>
</section>

<style>
  body { font-family: system-ui, sans-serif; max-width: 40rem; margin: 0 auto; padding: 2rem; line-height: 1.6; }
  nav a { margin-right: 1rem; color: #0f766e; font-weight: 600; }
  section { min-height: 17rem; padding-top: 1rem; border-top: 1px solid #e2e8f0; }
  h2 { margin-bottom: 0.4rem; }
</style>
```

The `id` is the target, not the `href`. Keep ids unique, descriptive and stable. `id="hours"` is better than `id="section2"`. If you change an id, every fragment link to it breaks — and unlike a missing page, a broken fragment gives the reader no error, just nothing.

`href="#"` scrolls to the top of the page, but it also adds a bare `#` to the URL and is easy to mistake for a real destination. If you want a "back to top" link, point it at an explicit `id="top"` on the header or main element.

## Email, phone and new tabs

`mailto:` opens the reader's mail application with the address filled in. `tel:` opens the phone dialler on a device that has one. Both are ordinary links, so they get keyboard focus and can be activated like any other.

```html run
<h1>Talk to the studio</h1>

<p>For commissions, email <a href="mailto:studio@mossandpine.example?subject=Commission%20enquiry">studio@mossandpine.example</a>.</p>
<p>Or call <a href="tel:+441422555014">01422 555 014</a>, Tuesday to Friday.</p>
<p>Our full price list is in the <a href="https://mossandpine.example/price-list.pdf" target="_blank" rel="noopener">studio price list (PDF, opens in a new tab)</a>.</p>

<style>
  body { font-family: system-ui, sans-serif; max-width: 38rem; margin: 3rem auto; padding: 0 1.5rem; line-height: 1.7; color: #1e293b; }
  a { color: #0f766e; }
</style>
```

The `mailto:` value can include a query string for a subject or body. Spaces and punctuation in those values should be percent-encoded; `%20` is a space. The `tel:` value should contain only digits and an optional leading `+` — no spaces or brackets. Put the readable format in the link text, not in the href.

`target="_blank"` opens the destination in a new tab. Use it when leaving the current page would genuinely lose the reader's place: a PDF, a reference, a third-party tool. Add `rel="noopener"` so the new page cannot reach back through `window.opener` and manipulate the page it came from. Modern browsers apply this protection automatically for `target="_blank"`, but writing it explicitly is still the habit you want, and it helps older browsers.

> **Pitfall:** Opening every external link in a new tab is not a kindness. It breaks the Back button's meaning and can strand keyboard users in an unexpected window. Choose deliberately, and say so in the link text when it matters: "price list (PDF, opens in a new tab)".

## Link text is the interface

Screen reader users often ask their software for a list of every link on the page. That list contains the link text and nothing else. If your page has twelve links that say "click here", the list is twelve identical entries. If your links say what they open, the list becomes a table of contents.

Good link text is specific enough to make sense out of context:

| Instead of | Write |
|---|---|
| Click here | Read the autumn journal |
| Read more | Read more about the workshop move |
| Download | Download the price list (PDF) |
| This page | See the 2026 exhibition dates |

The visible sentence still matters. "Read the autumn journal" is a decent link on its own; "Read the autumn journal for the full story" gives even more context. Do not hide the only description in a `title` attribute or an `aria-label` unless the visible text genuinely cannot carry it. The link text is the label everyone sees; make it do the work.

```html run
<h2>Before</h2>
<ul>
  <li><a href="guide.html">Click here</a> for the trail guide.</li>
  <li><a href="prices.html">Read more</a></li>
  <li><a href="contact.html">This page</a></li>
</ul>

<h2>After</h2>
<ul>
  <li><a href="guide.html">Read the Kinder Loop trail guide</a></li>
  <li><a href="prices.html">See workshop and commission prices</a></li>
  <li><a href="contact.html">Contact the studio</a></li>
</ul>

<style>
  body { font-family: system-ui, sans-serif; max-width: 38rem; margin: 2rem auto; padding: 0 1.5rem; line-height: 1.7; }
  a { color: #0f766e; }
</style>
```

> **Under the hood:** The accessibility tree exposes each link with an accessible name. For a text link, that name comes from its text content. For an image inside a link, it comes from the image's `alt`. For an icon-only link with no text, you need `aria-label` — but that is a last resort, not a replacement for writing a label.

## Images: source, alternative and dimensions

An image is an empty element: `<img src="…" alt="…">`. `src` is the URL of the image file. `alt` is the text alternative — what the page says when the image cannot be seen. The attribute is required in practice even when its value is empty.

```html run
<figure>
  <img
    src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='400' viewBox='0 0 640 400'%3E%3Crect width='640' height='400' fill='%23dbeafe'/%3E%3Ccircle cx='498' cy='92' r='46' fill='%23f59e0b'/%3E%3Cpath d='M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z' fill='%23134e4a'/%3E%3Cpath d='M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z' fill='%230f766e'/%3E%3C/svg%3E"
    alt="A pale sun rising over the dark ridge of Kinder Scout, with a green valley below."
    width="640" height="400" loading="lazy" decoding="async">
  <figcaption>The view from Kinder Scout at sunrise, looking down into the Edale valley.</figcaption>
</figure>

<style>
  body { font-family: system-ui, sans-serif; max-width: 40rem; margin: 2rem auto; padding: 0 1.5rem; background: #f8fafc; }
  figure { margin: 0; }
  img { display: block; width: 100%; height: auto; border-radius: 12px; }
  figcaption { margin-top: 0.6rem; color: #475569; font-size: 0.9rem; }
</style>
```

The `width` and `height` attributes are not a design decision. They tell the browser the image's intrinsic dimensions, which lets it reserve the right amount of space before the image loads. Without them, the page jumps as images arrive — the layout shift people feel as "this site is broken". The numbers are unitless pixels. CSS can still make the image fluid with `width: 100%; height: auto` without changing the aspect ratio the browser reserved.

`loading="lazy"` tells the browser to postpone an offscreen image until the reader approaches it. Use it for images further down a long page, not for the hero image at the top: delaying the largest visible image makes the page feel slower. `decoding="async"` is a hint that the browser may decode the image off the main thread; it is a small optimisation, not a guarantee.

> **Tip:** The data URI in this example is an SVG encoded directly in the `src`. The `#` in a hex colour becomes `%23`, and the angle brackets are percent-encoded. The browser decodes it back into an image. This keeps examples self-contained and avoids a network request.

## Figures and captions

`<figure>` groups content that is referenced from the main flow but could stand a little apart: a photograph, a chart, a diagram, a code sample. `<figcaption>` gives it a visible caption. The caption belongs inside the figure, usually as the first or last child.

A caption is not the same thing as alt text. The caption is visible to everyone and can add context, credit or interpretation. The alt text is what a screen reader announces in place of the image, and what appears if the file fails to load. Write both, but do not simply duplicate one in the other.

Not every image needs a figure. A small icon beside a label, a logo in a header, a decorative flourish: these are inline parts of the page, not standalone content. Use `figure` when the image is something the reader would point at and discuss.

## Alt text: informative, decorative, functional

The hardest part of `alt` is not syntax. It is deciding what the image is doing.

- **Informative**: describe the information the image conveys. "A pale sun rising over the dark ridge of Kinder Scout" tells a reader what the photo shows. Do not start with "Image of" or "Picture of" — the screen reader already says it is an image.
- **Decorative**: if the image adds no information, use `alt=""`. The empty value tells assistive technology to skip it. A missing `alt` is not the same: some browsers announce the filename, and validators flag it.
- **Functional**: if the image is the only content of a link or button, the alt text is the link's label. Describe the destination or action, not the pixels. A link containing a map icon should say "View the trail map", not "Map icon".

```html run
<h2>Three jobs for an image</h2>

<figure>
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='240' viewBox='0 0 640 240'%3E%3Crect width='640' height='240' fill='%23e0f2fe'/%3E%3Cpath d='M0 190 L140 96 L280 178 L420 112 L640 204 L640 240 L0 240 Z' fill='%230f766e'/%3E%3C/svg%3E" alt="The Kinder Loop climbs 340 metres over 12 kilometres, with the steepest section between Edale and the ridge." width="640" height="240">
  <figcaption>Elevation profile of the Kinder Loop.</figcaption>
</figure>

<p>
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='64' height='64' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%230f766e'/%3E%3Cpath d='M18 40 L30 24 L38 34 L46 22' stroke='white' stroke-width='4' fill='none' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E" alt="" width="24" height="24">
  A decorative mark beside a paragraph. The empty alt keeps it out of the way.
</p>

<p>
  <a href="trail-guide.html">
    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='64' height='64' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%23f59e0b'/%3E%3Cpath d='M20 18 H44 V46 H20 Z' fill='white'/%3E%3Cpath d='M26 26 H38 M26 32 H38 M26 38 H34' stroke='%230f766e' stroke-width='3'/%3E%3C/svg%3E" alt="Trail guide: seven walks in the Peak District" width="24" height="24">
  </a>
  Read the guide before you set off.
</p>

<style>
  body { font-family: system-ui, sans-serif; max-width: 42rem; margin: 2rem auto; padding: 0 1.5rem; line-height: 1.65; }
  figure { margin: 0 0 2rem; }
  img { max-width: 100%; height: auto; }
  figcaption { color: #475569; font-size: 0.9rem; }
</style>
```

For a complex image — a chart with several series, a screenshot of an interface — a short alt may not be enough. Give the key takeaway in `alt`, then put the full description in nearby text, a table or a details element. Alt text is a replacement for the image's *purpose*, not an exhaustive inventory of its pixels.

## Challenge: build a working navigation

The studio header currently lists its pages as plain text. Turn it into a navigation with four links: `index.html`, `work.html`, `contact.html` and an email link to `hello@mossandpine.example`. Give each link text that makes sense on its own.

```html exercise id=studio-navigation title="Build a working navigation"
<header class="site-header">
  <p class="brand">Moss & Pine</p>
  <p>Home · Work · Contact · hello@mossandpine.example</p>
</header>
--- solution
<header class="site-header">
  <p class="brand">Moss & Pine</p>
  <nav aria-label="Main">
    <a href="index.html">Home</a>
    <a href="work.html">See our work</a>
    <a href="contact.html">Contact the studio</a>
    <a href="mailto:hello@mossandpine.example">Email the studio</a>
  </nav>
</header>
--- test
assertExists("nav", "Wrap the page links in a nav element.");
const links = Array.from(document.querySelectorAll("nav a"));
assert(links.length >= 4, `The navigation should contain at least 4 links, but it has ${links.length}.`);
const hrefs = links.map((a) => (a.getAttribute("href") || "").replace(/^\.\//, ""));
["index.html", "work.html", "contact.html"].forEach((path) => {
  assert(hrefs.includes(path), `No link points to "${path}". The three page links should be relative paths.`);
});
const email = links.find((a) => (a.getAttribute("href") || "").startsWith("mailto:"));
assert(email, "Add a mailto: link for hello@mossandpine.example.");
assert((email.getAttribute("href") || "").includes("hello@mossandpine.example"), "The email link points somewhere else. Use mailto:hello@mossandpine.example.");
links.forEach((a) => {
  const text = normalize(a.textContent);
  assert(text.length > 0, "Every link needs visible text.");
  assert(!/click here/i.test(text), `"${text}" still uses "click here". Name the destination instead.`);
  assert(!/^(here|read more)$/i.test(text), `"${text}" does not describe a destination. Replace it with link text that works out of context.`);
});
--- hint
Keep the brand line, then add a `<nav>` around the four links.
--- hint
The email link uses `href="mailto:hello@mossandpine.example"`, not `href="hello@mossandpine.example"`.
--- hint
"See our work" is a stronger label than "Work" because it still makes sense when a screen reader reads the link list on its own.
```

## Predict: which link stays on this page?

Read the navigation. The page already contains a section with `id="hours"`. Which link jumps to that section without loading a different document?

```html predict id=fragment-target title="Which link stays on this page?"
<nav>
  <a href="#hours">Opening hours</a>
  <a href="hours.html">The hours page</a>
  <a href="https://example.com/hours">Hours on another site</a>
  <a href="mailto:hours@example.com">Email about hours</a>
</nav>

<section id="hours">
  <h2>Opening hours</h2>
  <p>Friday to Sunday, 10am–4pm.</p>
</section>
--- options
* The link with href="#hours"
The link with href="hours.html"
The link with href="https://example.com/hours"
The link with href="mailto:hours@example.com"
--- explain
A leading `#` means "a fragment of the current document". The browser looks for an element whose `id` is `hours` and scrolls to it. `hours.html` is a separate file, the absolute URL is a different site, and `mailto:` opens a mail client. Only the fragment link stays on the page.
```

## Challenge: add a figure with a caption

The trail page has a photograph but no figure, caption or useful alternative. Wrap the image in a `figure`, add the caption below it, and write alt text that describes what the photograph shows. On the full page this figure sits well below the fold, so keep the existing dimensions and add `loading="lazy"` and `decoding="async"`.

The caption should read exactly: **The view from Kinder Scout at sunrise, looking down into the Edale valley.**

```html exercise id=trail-figure title="Add a figure with a caption"
<h2>Kinder Scout at sunrise</h2>
<img
  src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='400' viewBox='0 0 640 400'%3E%3Crect width='640' height='400' fill='%23dbeafe'/%3E%3Ccircle cx='498' cy='92' r='46' fill='%23f59e0b'/%3E%3Cpath d='M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z' fill='%23134e4a'/%3E%3Cpath d='M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z' fill='%230f766e'/%3E%3C/svg%3E"
  width="640" height="400">
--- solution
<h2>Kinder Scout at sunrise</h2>
<figure>
  <img
    src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='400' viewBox='0 0 640 400'%3E%3Crect width='640' height='400' fill='%23dbeafe'/%3E%3Ccircle cx='498' cy='92' r='46' fill='%23f59e0b'/%3E%3Cpath d='M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z' fill='%23134e4a'/%3E%3Cpath d='M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z' fill='%230f766e'/%3E%3C/svg%3E"
    alt="A pale sun rising over the dark ridge of Kinder Scout, with a green valley below."
    width="640" height="400" loading="lazy" decoding="async">
  <figcaption>The view from Kinder Scout at sunrise, looking down into the Edale valley.</figcaption>
</figure>
--- test
assertExists("figure", "Wrap the image and its caption in a figure element.");
assertExists("figure img", "The image should sit inside the figure.");
const img = query("figure img");
const alt = normalize(img.getAttribute("alt") || "");
assert(alt.length >= 25, `The alt text is only ${alt.length} characters. Describe what the photograph shows, not just its title.`);
assert(!/^(image|picture|photo) of/i.test(alt), "Do not start alt text with 'image of' or 'photo of'. Screen readers already announce that it is an image.");
assert(!/^kinder scout at sunrise$/i.test(alt), "The alt text repeats the heading. Say what the picture actually shows.");
assertAttr("figure img", "width", "640", "Keep the intrinsic width so the browser can reserve space.");
assertAttr("figure img", "height", "400", "Keep the intrinsic height so the browser can reserve space.");
assertAttr("figure img", "loading", "lazy", "Add loading='lazy' so the image can wait until the reader approaches it.");
assertAttr("figure img", "decoding", "async", "Add decoding='async' to let the browser decode the image off the main thread.");
assertText("figcaption", "The view from Kinder Scout at sunrise, looking down into the Edale valley.", "The figcaption should match the caption exactly.");
--- hint
`<figure>` goes around the image, and `<figcaption>` is its last child. The alt text is an attribute on the image, not a paragraph.
--- hint
Describe the scene: the pale sun, the dark ridge, the green valley. Avoid "image of" and avoid copying the heading.
--- hint
Add `loading="lazy"` and `decoding="async"` to the `<img>` tag alongside `width` and `height`.
```

## Debug: the card that says nothing useful

This trail card renders, but two things are wrong. The photograph has no alternative, and the link says "click here". Both are invisible to someone who can see the card and use a mouse — which is exactly why they ship so often. Fix both, and leave the visible design alone.

```html debug id=trail-card-labels title="The card that says nothing useful"
<article class="card">
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='360' viewBox='0 0 640 360'%3E%3Crect width='640' height='360' fill='%23dbeafe'/%3E%3Ccircle cx='500' cy='80' r='42' fill='%23f59e0b'/%3E%3Cpath d='M0 286 L150 160 L300 270 L430 192 L640 320 L640 360 L0 360 Z' fill='%23134e4a'/%3E%3C/svg%3E" width="640" height="360">
  <h2>New: the Kinder Loop</h2>
  <p>A 12 km circuit from Edale, with one steep climb and a very good pub at the end.</p>
  <a href="trail-guide.html">click here</a>
</article>

<style>
  body { font-family: system-ui, sans-serif; background: #f8fafc; margin: 0; padding: 2rem; }
  .card { max-width: 34rem; margin: 0 auto; background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; }
  img { display: block; width: 100%; height: auto; }
  h2 { margin: 1rem 1.25rem 0.4rem; }
  p { margin: 0 1.25rem 1rem; color: #475569; line-height: 1.6; }
  a { display: inline-block; margin: 0 1.25rem 1.25rem; color: #0f766e; font-weight: 600; }
</style>
--- solution
<article class="card">
  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='640' height='360' viewBox='0 0 640 360'%3E%3Crect width='640' height='360' fill='%23dbeafe'/%3E%3Ccircle cx='500' cy='80' r='42' fill='%23f59e0b'/%3E%3Cpath d='M0 286 L150 160 L300 270 L430 192 L640 320 L640 360 L0 360 Z' fill='%23134e4a'/%3E%3C/svg%3E" alt="A pale sunrise over the dark Kinder Scout ridge, seen from the trail." width="640" height="360">
  <h2>New: the Kinder Loop</h2>
  <p>A 12 km circuit from Edale, with one steep climb and a very good pub at the end.</p>
  <a href="trail-guide.html">Read the Kinder Loop trail guide</a>
</article>

<style>
  body { font-family: system-ui, sans-serif; background: #f8fafc; margin: 0; padding: 2rem; }
  .card { max-width: 34rem; margin: 0 auto; background: white; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden; }
  img { display: block; width: 100%; height: auto; }
  h2 { margin: 1rem 1.25rem 0.4rem; }
  p { margin: 0 1.25rem 1rem; color: #475569; line-height: 1.6; }
  a { display: inline-block; margin: 0 1.25rem 1.25rem; color: #0f766e; font-weight: 600; }
</style>
--- test
const img = query("img");
assert(img.hasAttribute("alt"), "The image has no alt attribute. Add one that describes what the photograph shows.");
const alt = normalize(img.getAttribute("alt"));
assert(alt.length >= 20, `The alt text is only ${alt.length} characters. Describe the scene, not just the location.`);
assert(!/^(image|picture|photo) of/i.test(alt), "Do not start alt text with 'image of'. The screen reader already says it is an image.");
const link = query("a");
const text = normalize(link.textContent);
assert(!/click here/i.test(text), "The link still uses 'click here'. Replace it with text that names the destination.");
assert(/kinder|trail|guide|route/i.test(text), `"${text}" does not tell the reader what the link opens. Name the guide or the route.`);
assertAttr("a", "href", "trail-guide.html", "Keep the link pointing at trail-guide.html.");
--- hint
Two independent fixes: the `img` needs an `alt` attribute, and the link needs text that describes the trail guide.
--- hint
The alt text should describe the sunrise and the ridge, not repeat the card heading.
--- hint
Replace `click here` with something like "Read the Kinder Loop trail guide".
```

## Recap

- `href` can be document-relative, root-relative or absolute; a leading `#` jumps to an element with that `id` on the same page.
- `mailto:` and `tel:` are real links; `target="_blank"` opens a new tab and belongs with `rel="noopener"`.
- Link text is the accessible name. Name the destination, not the click.
- `img` needs `src` and `alt`; give it `width` and `height` when you know them, use `loading="lazy"` offscreen and `decoding="async"` as a hint.
- `figure` and `figcaption` are for self-contained media with a visible caption.
- Alt text describes purpose: informative images get a description, decorative images get `alt=""`, functional images describe the action.

**Up next:** page structure — headers, navigation, main content, sidebars and footers, and the landmarks that let assistive technology move around a page without reading every word.
