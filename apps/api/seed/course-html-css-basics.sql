DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_basics');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_basics');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_basics');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_basics');

DELETE FROM discussions WHERE course_id = 'crs_html_css_basics';

DELETE FROM certificates WHERE course_id = 'crs_html_css_basics';

DELETE FROM enrollments WHERE course_id = 'crs_html_css_basics';

DELETE FROM reviews WHERE course_id = 'crs_html_css_basics';

DELETE FROM wishlist WHERE course_id = 'crs_html_css_basics';

DELETE FROM path_courses WHERE course_id = 'crs_html_css_basics';

DELETE FROM coupons WHERE course_id = 'crs_html_css_basics';

DELETE FROM lessons WHERE course_id = 'crs_html_css_basics';

DELETE FROM sections WHERE course_id = 'crs_html_css_basics';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_html_css_basics';

DELETE FROM courses WHERE id = 'crs_html_css_basics';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_web-development', 'web-development', 'Web Development', 'HTML, CSS and JavaScript — design and build for the browser.', 'globe', 10);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_html_css_basics', 'html-css-basics', 'HTML & CSS Basics: The Interactive Course', 'Build real, beautiful web pages from your first tag. Write HTML and CSS in the browser and watch every change render instantly.', 'Most beginner web courses show you a finished page and ask you to copy it. This one gives you a **live browser preview under every example**, so you can change a line and see the consequence immediately.

## Learn by looking, changing and breaking

- **Every lesson is a live playground.** Write HTML and CSS, run it, and see the real page rendered by your browser. No setup, no build step, no guessing.
- **Dozens of hands-on challenges.** Each one is checked against the real DOM and real computed styles, not a screenshot or a multiple-choice quiz. Progressive hints appear when you are stuck.
- **Debug challenges.** Real beginner bugs — a missing closing tag, a broken selector, a margin that collapses, an image without `alt` — that you track down and fix.
- **Predict-the-render questions** train you to read CSS before you run it, which is the skill that separates people who guess from people who know.
- **A responsive preview toolbar.** Check every page at desktop, tablet and phone width without leaving the lesson.

## From a blank file to a real page

You start with `<h1>Hello, web</h1>` and finish with two portfolio-ready projects: a **personal profile page** with a responsive layout and a **product landing page** with a hero, feature grid, pricing cards and an accessible signup form.

## Built for what comes next

Everything here is the foundation for front-end development, design systems and JavaScript. When you are done, **HTML & CSS Advanced** picks up with the cascade, container queries, modern selectors, motion and production accessibility.', 'cat_web-development', 'usr_noah', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 198, 'published', 1, '["Structure pages with semantic HTML that browsers, search engines and screen readers understand","Style with selectors, the box model, typography and color until a page looks intentional","Build layouts with Flexbox and CSS Grid instead of fighting floats and margins","Make pages responsive with mobile-first media queries and fluid type","Create accessible links, images, forms and focus states from the start","Ship two complete projects: a personal profile page and a product landing page"]', '["No coding experience at all. We start with your first tag","A modern browser. Pages render live on the page, so there is nothing to install"]', '["Complete beginners who want to build for the web and understand what they are typing","Designers who want to turn mockups into working, responsive pages","Marketers and founders who need to edit a landing page without fear","Developers from other languages who want a precise, modern HTML and CSS foundation"]', '["HTML","CSS","Web Design","Frontend","Responsive","Beginner"]', 396, 23, 0, 0, 24680, '2025-07-03T06:04:01.135Z', '2025-06-03T06:04:01.135Z', '2026-10-17T06:04:01.135Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_html_css_basics_1', 'crs_html_css_basics', 'Getting Started', 0, '2026-06-25T06:04:01.135Z'),
('sec_html_css_basics_2', 'crs_html_css_basics', 'Links, Images & Structure', 1, '2026-06-25T06:04:01.135Z'),
('sec_html_css_basics_3', 'crs_html_css_basics', 'Forms & Accessibility', 2, '2026-06-25T06:04:01.135Z'),
('sec_html_css_basics_4', 'crs_html_css_basics', 'CSS Foundations', 3, '2026-06-25T06:04:01.135Z'),
('sec_html_css_basics_5', 'crs_html_css_basics', 'Layout & Responsive', 4, '2026-06-25T06:04:01.135Z'),
('sec_html_css_basics_6', 'crs_html_css_basics', 'Motion & Capstone Projects', 5, '2026-06-25T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_1_1', 'sec_html_css_basics_1', 'crs_html_css_basics', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Every website you have ever used — a bank, a booking app, this course — is a conversation between three languages. **HTML** says what each thing *is*. **CSS** says what it *looks like*. **JavaScript** (later) says what it *does*. This course is about the first two: the layers that decide whether a page is understandable, accessible and pleasant to look at.

You are not going to watch someone else build a page. Every lesson is a live playground. You will write real HTML and CSS, press **Run**, and see your browser render it immediately. When something looks wrong, you will change one line and watch the consequence. That loop — write, render, inspect, adjust — is how every professional front-end developer works.

## What you are looking at

Here is a complete, styled page. It contains a heading, a paragraph, a link and a CSS rule. Run it:

```html run
<main class="intro">
  <p class="eyebrow">Lesson 01</p>
  <h1>Hello, web.</h1>
  <p>This page is made of HTML and styled with CSS. You can change anything.</p>
  <a href="#details">Read the details</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; }
  .intro { max-width: 36rem; margin: 4rem auto; padding: 0 1.5rem; }
  .eyebrow { color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 { margin: 0.25rem 0 1rem; font-size: 3rem; letter-spacing: -0.04em; }
  p { color: #475569; line-height: 1.6; }
  a { color: #0f766e; font-weight: 600; }
</style>
```

The preview below the editor is a real browser frame. It is not a screenshot and it is not a mock-up. Change `Hello, web.` to your own name and run it again. Change `#f4f1ea` to `#111827` and notice that the text becomes hard to read — that is a contrast problem, and you will learn to fix it properly.

> **Tip:** The preview toolbar has desktop, tablet and phone widths. Most layout bugs are invisible on a wide screen and obvious on a narrow one. Get into the habit of checking both.

## How a lesson works

Each lesson has the same rhythm:

- **Short explanations** with a runnable example right underneath. Run every example. Reading code is not the same as predicting what it does.
- **Challenges** checked against the real page. Press **Check** when you think you are done. If it fails, the message tells you what the browser actually found.
- **Hints** that get progressively more specific. Try the challenge first, then take one hint at a time.
- **Debug challenges** where the code already runs but behaves wrongly. Finding a bug is a different skill from writing new code, and it is the skill you use most at work.
- **Predict-the-render questions** that ask you to choose what the browser will show *before* you run it.

There is no score to protect. You can break every cell in this course and nothing bad happens. Reset a cell from its menu whenever you want the original back.

## Predict before you run

Read this tiny page carefully. Where will the two boxes sit?

```html predict id=welcome-predict-inline title="Two boxes, one line?"
<div class="box">One</div>
<div class="box">Two</div>
<style>
  .box { display: inline-block; padding: 12px 20px; background: #e0f2fe; }
</style>
--- options
* Side by side on one line
Stacked vertically, each on its own line
Overlapping in the same spot
--- explain
An element with `display: inline-block` participates in the inline flow, so the two boxes sit next to each other. `div` elements are `block` by default — removing the CSS rule would stack them. This is the kind of before-and-after reasoning you will use constantly.
```

## What you will build

The course is a ladder. By the end you will have made:

1. A **personal profile page** with a responsive two-column layout, a photo, a project list and accessible contact links.
2. A **product landing page** with a hero, feature grid, pricing cards and a real signup form.

Here is a small taste of the first project. It is deliberately unfinished: the layout works, but the details are yours.

```html run
<article class="profile">
  <div class="avatar" aria-hidden="true">NB</div>
  <div>
    <h2>Noah Bennett</h2>
    <p class="role">Design engineer · Sheffield</p>
    <p>I build interfaces that are fast, accessible and a little more human than the average dashboard.</p>
    <a href="#">See my work →</a>
  </div>
</article>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .profile { display: flex; gap: 1.25rem; max-width: 34rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: white; }
  .avatar { display: grid; place-items: center; width: 64px; height: 64px; flex: none; border-radius: 50%; background: #0f172a; color: white; font-weight: 700; }
  h2 { margin: 0; font-size: 1.25rem; }
  .role { margin: 0.15rem 0 0.75rem; color: #0f766e; font-size: 0.85rem; font-weight: 600; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.55; }
  a { color: #0f172a; font-weight: 600; }
</style>
```

Nothing here is magic. The `display: flex` on `.profile` is what puts the avatar and the text side by side. The `gap` is what keeps them from touching. The `border-radius` is what makes the avatar a circle. Every one of those properties gets its own lesson, with challenges that make the behaviour stick.

> **Under the hood:** Your browser is already an extremely good HTML and CSS engine. The course does not bundle a fake renderer or approximate the result. The preview is the same engine that renders every site you visit.

## Recap

- HTML describes **structure and meaning**; CSS describes **presentation**.
- Every example in this course is live. Run it, edit it, break it.
- Challenges are checked against the real DOM and real computed styles, not against a picture.
- Debugging and predicting are core skills, not extras.
- The preview toolbar can simulate narrower screens, which is where layout problems show up first.

**Up next:** your first real page — the document skeleton, headings, paragraphs and the smallest HTML file that is still a valid website.
', 1, '[]', '[{"title":"MDN: HTML element reference","url":"https://developer.mozilla.org/en-US/docs/Web/HTML/Element"},{"title":"MDN: CSS reference","url":"https://developer.mozilla.org/en-US/docs/Web/CSS/Reference"},{"title":"WebAIM: Contrast checker","url":"https://webaim.org/resources/contrastchecker/"}]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_1_2', 'sec_html_css_basics_1', 'crs_html_css_basics', 'Your first page: elements, tags and structure', 'interactive', 1, 960, NULL, NULL, 'A web page is a text file with a very particular grammar. That is the whole trick. The browser reads your file from top to bottom, turns each tag into an element in a tree, and paints the result. You can build a complete, valid page in about ten lines — and once you can see the tree in your head, every layout problem becomes easier to reason about.

By the end of this lesson you will know the document skeleton, how tags and elements differ, how nesting works, and how to use headings and paragraphs without creating a page that reads like a ransom note.

## The smallest real page

Every page starts with the same skeleton. `<!doctype html>` tells the browser to use modern standards. `<html>` wraps everything. `<head>` holds information *about* the page. `<body>` holds what people actually see.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trailhead Coffee</title>
  </head>
  <body>
    <h1>Trailhead Coffee</h1>
    <p>Small-batch coffee for people who walk up hills.</p>
  </body>
</html>
```

Notice what the preview shows: only the heading and the paragraph. The `title` does not appear on the page; it appears in the browser tab, in bookmarks and in search results. The `meta charset` tells the browser how to decode the bytes of the file, which matters the moment your text contains an accent or an emoji. The viewport meta is what makes a page behave on a phone instead of pretending the screen is 980 pixels wide.

> **Pitfall:** A page without `<!doctype html>` still renders, but the browser falls back to "quirks mode", a compatibility mode with subtly different layout rules. Always include the doctype, even in a tiny demo.

## Tags, elements and nesting

A **tag** is the markup in angle brackets: `<p>` is an opening tag, `</p>` is a closing tag. The opening tag, the content and the closing tag together are an **element**:

```html run
<article>
  <h2>Three things in a bowl</h2>
  <p>Oats, yogurt and a genuinely unreasonable amount of blueberries.</p>
</article>
```

Elements can sit inside other elements. The outer element is the **parent**; the inner ones are its **children**. Here `<article>` is the parent of both the heading and the paragraph. That parent-child relationship is the structure the browser builds and the structure CSS later targets.

Some elements are **empty**: they have no closing tag because they never contain text. `<img>`, `<br>` and `<input>` are the common ones. In modern HTML you can write them as `<img>` or `<img />`; both mean the same thing.

Formatting is for humans. The browser collapses runs of spaces and newlines into a single space, so this:

```html
<p>One line</p><p>Another</p>
```

renders exactly like the indented version. Use indentation to show nesting, not to control spacing on the page. CSS does that job.

## Headings are an outline, not a font size

HTML gives you six heading levels, `<h1>` through `<h6>`. They are not a styling shortcut. They describe the *importance* of a section, and assistive technology can navigate a page by jumping between headings.

- One `<h1>` per page: the main topic.
- `<h2>` for major sections, `<h3>` for subsections of those.
- Never skip a level because it "looks better". Choose the level by meaning, then use CSS to size it.

```html run
<h1>Weekend in the Peak District</h1>
<p>A two-day walk with too many snacks and not enough water.</p>

<h2>Saturday: Edale to Kinder Scout</h2>
<p>An early start, a long climb and a very welcome flask of tea.</p>

<h3>What to pack</h3>
<p>Waterproofs, a map, and more food than you think you need.</p>
```

The browser''s default styles make an `h1` larger than an `h2`, and an `h2` larger than a paragraph. That is a useful preview of importance, not a rule you must keep. In lesson 11 you will take full control of the size while keeping the outline correct.

```html predict id=first-page-predict-size title="Which heading wins?"
<h1>Field notes</h1>
<h2>What the weather did</h2>
<h3>Tuesday</h3>
--- options
* The h1 is the largest, then the h2, then the h3
The h3 is the largest because it comes last
All three headings are the same size
Only the h1 renders
--- explain
The number in the tag is the heading level, and the browser''s default stylesheet gives higher-level headings larger type. The *order* on the page does not change that. Later you will replace these defaults with a designed type scale, but the semantic level stays the same.
```

> **Under the hood:** The browser turns your markup into a tree called the DOM — the Document Object Model. `<article>` becomes a node with two child nodes, the `h2` and the `p`. CSS selectors walk that tree, and the accessibility tree exposes it to screen readers. Almost everything in this course is a consequence of that tree.

## Paragraphs, line breaks and comments

A `<p>` is a paragraph of text. The browser adds space above and below it by default, because paragraphs are blocks. Use another `<p>` when you mean a new paragraph.

A `<br>` inserts a line break *inside* the same block. It is for things like postal addresses and song lyrics, not for spacing between paragraphs.

```html run
<p>
  The shop is open<br>
  Tuesday to Saturday<br>
  8am – 4pm
</p>

<p>We close for lunch when the dog insists.</p>

<!-- Comments disappear from the rendered page. They are notes for the next person. -->
```

You can leave a comment in HTML with `<!-- ... -->`. The browser ignores it. Use comments to explain *why* a piece of markup exists, not to describe what a tag obviously does.

## Challenge: set the tab title

Build a tiny page with a `<title>` of `Trailhead Coffee` and an `<h1>` of `Coffee, without ceremony.` The starter is missing both, so the challenge fails until you add them.

```html exercise id=first-page-title title="Set the tab title"
<!doctype html>
<html lang="en">
  <head>
    <!-- TODO: add a title -->
  </head>
  <body>
    <!-- TODO: add the heading -->
  </body>
</html>
--- solution
<!doctype html>
<html lang="en">
  <head>
    <title>Trailhead Coffee</title>
  </head>
  <body>
    <h1>Coffee, without ceremony.</h1>
  </body>
</html>
--- test
assert(document.title === "Trailhead Coffee", "The browser tab should read: Trailhead Coffee");
assertExists("h1", "Add an h1 heading inside the body");
assertText("h1", "Coffee, without ceremony.", "The heading should say: Coffee, without ceremony.");
--- hint
`<title>` belongs inside `<head>`, not in the body.
--- hint
Inside `<body>`, add `<h1>Coffee, without ceremony.</h1>`. Check the punctuation and the period.
```

## Challenge: add emphasis without adding meaning

Mark up this sentence with a paragraph containing `strong` around `open` and `em` around `today`:

> The bakery is **open** until late **today**.

The tests inspect the rendered element tree, so the tags must actually be in the markup — CSS that merely makes text bold will not pass.

```html exercise id=first-page-emphasis title="Emphasis with a reason"
<p>The bakery is open until late today.</p>
--- solution
<p>The bakery is <strong>open</strong> until late <em>today</em>.</p>
--- test
assertCount("p", 1, "Keep exactly one paragraph");
assertExists("p strong", "Wrap the word ''open'' in a strong element");
assertText("p strong", "open", "The strong element should contain the word ''open''");
assertExists("p em", "Wrap the word ''today'' in an em element");
assertText("p em", "today", "The em element should contain the word ''today''");
assertText("p", "The bakery is open until late today.", "The full sentence should still read correctly");
--- hint
`<strong>` means importance; `<em>` means stress emphasis. Both go inside the paragraph, around the words.
--- hint
Replace `open` with `<strong>open</strong>` and `today` with `<em>today</em>`, keeping the spaces around them.
```

## Debug: the heading that swallowed a paragraph

This page looks almost right, but the closing `</h1>` is missing. The browser recovers, but it puts the paragraph *inside* the heading, so the whole sentence becomes one enormous heading. Find the missing tag and fix the structure.

```html debug id=first-page-unclosed-heading title="The heading swallowed the paragraph"
<h1>Field notes
<p>Tuesday was cold, bright and full of sheep.</p>
--- solution
<h1>Field notes</h1>
<p>Tuesday was cold, bright and full of sheep.</p>
--- test
assertExists("h1", "Keep the h1 heading");
assertText("h1", "Field notes", "The h1 should contain only the words ''Field notes''");
assertExists("p", "Keep the paragraph");
assertText("p", "Tuesday was cold, bright and full of sheep.", "The paragraph text should be its own element");
assert(!document.querySelector("h1 p"), "The paragraph is still nested inside the heading. Close the h1 before it.");
--- hint
Run it and look at the preview. The paragraph is being rendered as part of the heading.
--- hint
Add `</h1>` immediately after the word `notes`.
```

## Putting it together

Here is a small About page. It uses only what you have learned so far: a document skeleton, headings, paragraphs, strong and em, a line break and a comment. No CSS yet.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>About · Moss & Pine</title>
  </head>
  <body>
    <h1>Moss & Pine</h1>
    <p><strong>We make small wooden things</strong> for people who like their furniture to outlive their phones.</p>

    <h2>How it started</h2>
    <p>In a shed, with one saw and <em>a lot</em> of stubbornness.</p>

    <h2>Visit</h2>
    <p>
      14 Mill Lane<br>
      Hebden Bridge<br>
      Open Friday to Sunday
    </p>
    <!-- The workshop cat is called Biscuit. She has no structural role. -->
  </body>
</html>
```

> **In the wild:** View source on any page you admire. You will see this same skeleton: doctype, head, title, meta tags, then a body full of nested elements. The details get more complex, but the shape never changes.

## Recap

- Every page has a skeleton: `<!doctype html>`, `<html lang="en">`, `<head>` and `<body>`.
- Tags mark up **elements**; elements nest into a tree. Empty elements like `<img>` and `<br>` have no closing tag.
- `<title>` names the document in the browser tab; `<h1>` names the visible page.
- Headings are an outline (`h1` → `h2` → `h3`), not a font-size menu.
- `<p>` is a paragraph; `<br>` is a line break inside one block.
- Close your elements. The browser will guess when you forget, and its guess is rarely the structure you meant.

**Up next:** text that carries meaning — lists, quotes, code and the inline elements that make a sentence say exactly what you mean.
', 1, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_1_3', 'sec_html_css_basics_1', 'crs_html_css_basics', 'Text that means something: headings, lists and emphasis', 'interactive', 2, 1080, NULL, NULL, 'Most of the web is still text. A recipe, a product page, a review, a set of trail notes: strip away the layout and what remains is words arranged into headings, paragraphs, lists and quotations. HTML''s job is to say what each piece of text *is*, so a browser, a search engine and a screen reader can all agree on its role.

That distinction matters more than it sounds. Two pieces of text can look identical on screen and mean completely different things. A bold word might be important, or it might just be a keyword. A list might have an order, or it might be a bag of ingredients. This lesson gives you the inline vocabulary and the list structures that make those distinctions explicit — and shows you when the browser''s default styling is helping you and when it is lying to you.

## Strong is a meaning. Bold is a look.

`<strong>` marks text as important, serious or urgent. The browser makes it bold by default, and screen readers may add emphasis when they announce it. Use it when losing the word would change the meaning of the sentence:

```html run
<h1>Allergen notice</h1>
<p><strong>This loaf contains hazelnuts.</strong> The kitchen also handles sesame and milk.</p>
<p><b>New</b> on the autumn menu: hazelnut and pear tart.</p>
```

The second sentence uses `<b>`, which draws attention without claiming importance: a keyword in a summary or a product name. It is bold too, but it carries no extra weight in the document''s meaning. If you are reaching for bold purely because a word should stand out visually, ask whether it is important. If it is, use `strong`; if it is only a typographic offset, use `b` — or better, use CSS later and leave the HTML honest.

> **Pitfall:** Do not use `<b>` as a shortcut for `<strong>` because it is shorter. The visual result is the same today, but the meaning is not. A screen reader user who navigates by emphasis will hear nothing at a `<b>`.

## Emphasis changes the sentence

`<em>` marks stress emphasis: the word the speaker would lean on. Move it around and the sentence changes meaning. That is the test for whether `em` belongs.

```html run
<p>I <em>never</em> said the cake was free.</p>
<p>I never said <em>the cake</em> was free.</p>
<p>I never said the cake was <em>free</em>.</p>
```

`<i>` is also italic by default, but it marks text in an alternate voice: a ship name, a foreign phrase, a technical term, a thought. It does not add emphasis. The *HMS Victory* is not more important than the sentence around it; it is simply a name that convention italicises.

> **Under the hood:** Browsers ship a default stylesheet — the "user agent stylesheet" — that gives `strong` and `b` `font-weight: bold`, and `em` and `i` `font-style: italic`. Those rules are why the two pairs look the same. The element names are what carry meaning.

## The rest of the inline vocabulary

Once you notice the pattern, the rest of the inline elements are easy: each one answers a question about a piece of text.

| Element | Answers | Example |
|---|---|---|
| `<small>` | Is this a side note or fine print? | Terms, legal lines, photo credits |
| `<mark>` | Is this relevant right now? | A search hit inside a paragraph |
| `<code>` | Is this code or a filename? | `brew --ratio 1:16` |
| `<kbd>` | Is this a key the user presses? | <kbd>Ctrl</kbd> + <kbd>K</kbd> |
| `<abbr>` | Is this an abbreviation? | EVOO, with the full phrase in `title` |
| `<time>` | Is this a date or time? | 20 October 2026, with a machine-readable `datetime` |
| `<blockquote>` | Is this a long quotation? | A review, an excerpt, a transcript |
| `<cite>` | What is the work being quoted? | The book, article or publication title |
| `<q>` | Is this a short inline quotation? | A phrase someone said |

A few of these deserve a closer look.

`<small>` is for side comments and small print, not for making important text visually smaller. `<mark>` is for relevance in the current context — the yellow highlighter look is a default, not a requirement. `<code>` and `<kbd>` are both monospace by default, but one is something a computer reads and the other is something a person presses. `<abbr title="extra virgin olive oil">EVOO</abbr>` gives the expansion on hover and to some assistive technology; it is not a substitute for explaining an abbreviation the first time in running text.

`<time datetime="2026-10-20">20 October 2026</time>` keeps the readable date for people and a standard format for machines. `<blockquote cite="https://example.com/review">` points at the source in the `cite` attribute, while `<cite>Roast Review</cite>` names the work in visible text. The attribute is metadata; the element is content. They are not interchangeable, and the `cite` attribute is not rendered by browsers.

`<q>` is the inline cousin of `blockquote`. The browser adds quotation marks for you, and it uses the language of the page to choose them. If you type the quotes yourself inside a `q`, you get doubles.

Here is the whole vocabulary in one realistic product note:

```html run
<h1>Trailhead Coffee: Ethiopian Guji</h1>
<p><small>Roasted 18 October. Best within six weeks of the roast date.</small></p>
<p>Notes of <mark>apricot</mark>, jasmine and brown sugar.</p>
<p>Brew at <code>1:16</code> coffee to water. Press <kbd>Space</kbd> to start the timer.</p>
<p>We buy through <abbr title="Fairtrade Labelling Organizations International">FLO</abbr>-certified cooperatives. Last cupped <time datetime="2026-10-20">20 October 2026</time>.</p>

<blockquote cite="https://example.com/guji-review">
  <p>Clean, sweet and almost tea-like, with a finish that outlasts the cup.</p>
  <p><cite>Roast Review</cite>, issue 42</p>
</blockquote>

<p>The importer calls it <q>the quietest coffee on the table</q>.</p>
```

> **Tip:** The `title` attribute on `abbr` is a bonus, not a guarantee. On touch screens there is no hover, and some screen readers ignore it. If the expansion is essential to understanding the page, write it out in the sentence as well.

## Challenge: quote a review with its source

A bakery has a review it wants to display properly. The starter flattens the quotation, the publication and the date into one paragraph. Rebuild it with a `blockquote`, a `cite` and a `time` element. Put the review sentence itself inside the blockquote, without the curly quote marks — the element already marks it as a quotation.

Use the review URL `https://theweekendtable.example/reviews/moss-and-pine` in the blockquote''s `cite` attribute. The visible source is *The Weekend Table*, and the review date is 12 October 2026.

```html exercise id=review-quote title="Quote a review with its source"
<h2>What people say</h2>
<p>“The best bread in Leeds. I drove across the city for a second loaf.” — The Weekend Table, 12 October 2026</p>
--- solution
<h2>What people say</h2>
<blockquote cite="https://theweekendtable.example/reviews/moss-and-pine">
  <p>The best bread in Leeds. I drove across the city for a second loaf.</p>
</blockquote>
<p><cite>The Weekend Table</cite>, <time datetime="2026-10-12">12 October 2026</time></p>
--- test
assertExists("blockquote", "Wrap the quotation in a blockquote element.");
assertText("blockquote p", "The best bread in Leeds. I drove across the city for a second loaf.", "The blockquote should contain the review exactly as written.");
assertAttr("blockquote", "cite", "https://theweekendtable.example/reviews/moss-and-pine", "Point the blockquote''s cite attribute at the review URL.");
assertText("cite", "The Weekend Table", "The cite element should name the publication, not the person who said it.");
assertExists("time[datetime=''2026-10-12'']", "Add a time element with datetime=''2026-10-12''.");
--- hint
A long quotation is a block-level element, so it sits outside the paragraph you are replacing. The source line can stay in its own paragraph.
--- hint
Put the review text inside `<blockquote cite="…"><p>…</p></blockquote>`, then follow it with a paragraph containing `<cite>` and `<time>`.
--- hint
The `time` element''s visible text can be “12 October 2026”; the machine-readable version belongs in `datetime="2026-10-12"`.
```

## Lists: order, no order, and pairs

HTML has three list types, and the choice is about meaning, not looks.

- `<ul>` is an unordered list: a collection where position carries no information. Ingredients, features, links, symptoms.
- `<ol>` is an ordered list: sequence matters. Steps, rankings, instructions, a top-ten countdown.
- `<dl>` is a description list: pairs of terms and descriptions. A glossary, a menu with prices, metadata.

Every list item is an `<li>`. An `<ol>` and `<ul>` may contain only `<li>` elements as direct children. A `<dl>` is slightly different: it groups one or more `<dt>` terms with one or more `<dd>` descriptions.

```html run
<h1>Lemon spaghetti for two</h1>
<p>Dinner in twenty minutes, with one pan and an unreasonable amount of lemon.</p>

<h2>Ingredients</h2>
<ul>
  <li>200 g spaghetti</li>
  <li>1 unwaxed lemon, zest and juice</li>
  <li>2 tbsp olive oil</li>
  <li>For the topping
    <ul>
      <li>30 g parmesan, finely grated</li>
      <li>1 tsp cracked black pepper</li>
    </ul>
  </li>
</ul>

<h2>Method</h2>
<ol>
  <li>Boil the pasta in well-salted water.</li>
  <li>Zest the lemon into the oil while the pasta cooks.</li>
  <li>Toss everything with a splash of pasta water.</li>
</ol>
```

The order of the ingredients does not change the dish. The order of the method does. That is the whole decision. If you can shuffle the items without changing the meaning, use `ul`; if position matters, use `ol`.

`<ol>` has a few useful attributes. `start="4"` begins at four, `reversed` counts down, and `value` on an individual `<li>` jumps to a specific number. Use them when the content genuinely continues or counts down, not to fake a design.

```html run
<h1>Three ways to brew</h1>
<ol>
  <li>Weigh the coffee.</li>
  <li>Heat the water to 94°C.</li>
  <li>Pour slowly, in circles.</li>
</ol>

<h2>A short history of the shop</h2>
<ol reversed>
  <li>We opened the second room.</li>
  <li>We bought the roaster.</li>
  <li>We started with one table and a kettle.</li>
</ol>
```

A description list is for pairs, not for layout. It is the right tool for a tasting menu, a glossary or a set of specifications:

```html run
<h1>Saturday cupping</h1>
<p>Three coffees, one table, no scores below seven.</p>

<dl>
  <dt>Ethiopia Guji</dt>
  <dd>Apricot, jasmine, a long sweet finish.</dd>
  <dt>Colombia Huila</dt>
  <dd>Red apple and caramel; the easy crowd-pleaser.</dd>
  <dt>Kenya Nyeri</dt>
  <dd>Blackcurrant and lime. Brace yourself.</dd>
</dl>

<style>
  dt { font-weight: 700; margin-top: 1rem; }
  dd { margin: 0.2rem 0 0; color: #475569; }
</style>
```

> **In the wild:** Navigation menus are lists of links. So are breadcrumbs, tag clouds and tables of contents. The list structure gives assistive technology a count and a boundary: "list, five items". CSS can later lay those items out in a row, and the meaning survives.

## Nesting a list without breaking it

A nested list belongs *inside* the list item it relates to. This is the structure that trips up almost every beginner:

```html
<ul>
  <li>Dinner
    <ul>
      <li>Pasta</li>
      <li>Salad</li>
    </ul>
  </li>
</ul>
```

The inner `<ul>` is a child of the outer `<li>`, before that `<li>` closes. If you close the item first, the nested list becomes a sibling of the item instead of part of it. It may still look indented, because the browser indents lists, but the relationship is gone. A screen reader will announce two separate lists rather than one item with sub-items.

> **Pitfall:** Never place an `<li>` directly inside a `<ul>`''s parent, or directly in the body. An `<li>` without a list around it is invalid, and the browser has to guess what you meant. The guess is rarely the structure you wanted.

## Challenge: build the ingredient list

Build the ingredient list for the lemon spaghetti. The main list needs four items: spaghetti, lemon, olive oil and a "For the topping" item. The topping item contains a nested list with parmesan and black pepper. Write the olive oil as the abbreviation **EVOO**, with `extra virgin olive oil` in its `title`.

```html exercise id=recipe-ingredients title="Build the ingredient list"
<h2>Ingredients</h2>
<ul>
  <li>200 g spaghetti</li>
  <!-- TODO: add the lemon, the oil with its abbreviation, and the nested topping list -->
</ul>
--- solution
<h2>Ingredients</h2>
<ul>
  <li>200 g spaghetti</li>
  <li>1 unwaxed lemon</li>
  <li>2 tbsp <abbr title="extra virgin olive oil">EVOO</abbr></li>
  <li>For the topping
    <ul>
      <li>30 g parmesan, finely grated</li>
      <li>1 tsp cracked black pepper</li>
    </ul>
  </li>
</ul>
--- test
const list = query("ul");
const items = Array.from(list.children).filter((el) => el.tagName === "LI");
assert(items.length === 4, `The main ingredient list should have 4 items, but it has ${items.length}.`);
const nested = list.querySelector("li ul");
assert(nested, "The topping ingredients should sit in a nested ul inside their own li.");
const nestedItems = Array.from(nested.children).filter((el) => el.tagName === "LI");
assert(nestedItems.length === 2, `The nested topping list should have 2 items, but it has ${nestedItems.length}.`);
assertAttr("abbr", "title", "extra virgin olive oil", "The abbreviation should expand to ''extra virgin olive oil'' in its title attribute.");
assertText("abbr", "EVOO", "The visible abbreviation should read EVOO.");
assert(/parmesan/i.test(list.textContent), "The nested list should include the parmesan.");
--- hint
The nested list is a whole `<ul>` inside the fourth `<li>`, after the words "For the topping".
--- hint
The olive oil item needs both the amount and the abbreviation: `2 tbsp <abbr title="extra virgin olive oil">EVOO</abbr>`.
--- hint
Close the nested `</ul>` before you close the fourth `</li>`. The outer list then closes after it.
```

## Predict: how does the nested list count?

Read the packing list before you run it. The outer list is ordered. What will the browser show for the markers?

```html predict id=nested-list-markers title="How does the nested list count?"
<h2>Packing</h2>
<ol>
  <li>Sleeping bag</li>
  <li>Clothing
    <ol>
      <li>Wool socks</li>
      <li>Rain shell</li>
    </ol>
  </li>
  <li>Snacks</li>
</ol>
--- options
* The outer list numbers 1., 2., 3.; the nested list starts again at 1. and numbers 1., 2.
The outer list numbers 1., 2., 3.; the nested list continues at 4. and 5.
The outer list uses bullets; only the nested list uses numbers.
All five items are numbered 1. through 5.
--- explain
The nested `<ol>` is its own list with its own counter, so it starts at 1. Its numbers are independent of the outer list. Use `start="4"` on the inner list only if you deliberately want it to continue the outer count.
```

## Debug: the list that escaped

This market list renders, but the structure is wrong. One item sits outside the list, and the rest are split across two lists. The page looks almost plausible, which is exactly why this bug survives review. Fix the markup so there is one unordered list with five items.

```html debug id=market-list-repair title="The list that escaped"
<h2>Saturday market</h2>
<ul>
  <li>Sourdough</li>
  <li>Olive oil</li>
</ul>
<li>Tomatoes</li>
<ul>
  <li>Basil</li>
  <li>Garlic</li>
</ul>
--- solution
<h2>Saturday market</h2>
<ul>
  <li>Sourdough</li>
  <li>Olive oil</li>
  <li>Tomatoes</li>
  <li>Basil</li>
  <li>Garlic</li>
</ul>
--- test
const lists = document.querySelectorAll("ul");
assert(lists.length === 1, `The page should have one unordered list, but it has ${lists.length}. Join the split lists.`);
const list = lists[0];
const items = Array.from(list.children).filter((el) => el.tagName === "LI");
assert(items.length === 5, `The market list should hold 5 items, but the ul contains ${items.length}.`);
const texts = items.map((li) => normalize(li.textContent));
["Sourdough", "Olive oil", "Tomatoes", "Basil", "Garlic"].forEach((item) => {
  assert(texts.includes(item), `The list is missing "${item}".`);
});
assert(document.querySelectorAll("body > li").length === 0, "An li is still sitting outside a ul. Every list item belongs inside a list.");
--- hint
Run it and look at the preview. The tomatoes look like a list item, but they are not inside the list.
--- hint
Move `<li>Tomatoes</li>` up into the first `<ul>`, then delete the second `<ul>` and move its two items into the same list.
```

## Breaks and rules: when a line is the content

`<br>` is a line break *inside* a block of text. It is correct when the line break is part of the content: a postal address, a poem, song lyrics, a signature. It is not a spacing tool. A run of `<br>` tags to push a paragraph down is a layout problem disguised as markup, and it will break the moment the text size changes.

`<hr>` is a thematic break between paragraphs or sections — a change of scene, a shift in topic. It is not a decorative divider. If you want a line for visual reasons, use a CSS border. If you want a new section, use a heading.

```html run
<h1>Visit the workshop</h1>
<address>
  Moss & Pine<br>
  14 Mill Lane<br>
  Hebden Bridge<br>
  West Yorkshire
</address>

<p>Open Friday to Sunday, 10am–4pm. The kettle is usually on.</p>

<hr>

<h2>Getting there</h2>
<p>The 596 bus stops at the end of the lane. There is a small car park behind the mill, but it fills up by eleven.</p>
```

The `<address>` element is for contact information for the nearest article or page, not for every address in the world. The `br` tags inside it are legitimate: an address is a set of lines, not a set of paragraphs. The `hr` marks a real change from visiting details to travel details.

## What the browser gives you for free

The default stylesheet gives every semantic element a look. Headings get sizes and margins, paragraphs get space, lists get markers and indentation, `strong` gets bold, `em` gets italic, `blockquote` gets an indent, `q` gets quotation marks, and `mark` gets a yellow background.

Those defaults are a useful preview of meaning, not a design system. They vary slightly between browsers, they ignore your brand, and they are easy to override. That is fine. The semantics stay in the DOM even after CSS changes every pixel.

```html run
<h1>Two lists, one meaning</h1>
<p>Both lists below are unordered. Only the second has been styled.</p>

<ul>
  <li>Whole beans</li>
  <li>Ground for filter</li>
  <li>Ground for espresso</li>
</ul>

<ul class="pills">
  <li>Whole beans</li>
  <li>Ground for filter</li>
  <li>Ground for espresso</li>
</ul>

<style>
  .pills { display: flex; gap: 0.5rem; padding: 0; list-style: none; }
  .pills li { padding: 0.45rem 0.8rem; border: 1px solid #0f766e; border-radius: 999px; color: #0f766e; }
</style>
```

> **Pitfall:** Do not choose an element for its default look. `<h4>` is not "small heading"; `<blockquote>` is not "indented paragraph"; `<ul>` is not "bullet decoration". Choose by meaning, then style with CSS. Lesson 09 starts that job properly.

## Recap

- `<strong>` means importance; `<b>` is a visual offset. `<em>` changes the emphasis of a sentence; `<i>` marks an alternate voice.
- `<small>`, `<mark>`, `<code>`, `<kbd>`, `<abbr>`, `<time>`, `<blockquote>`, `<cite>` and `<q>` each answer a specific question about text.
- Use `ul` when order does not matter, `ol` when it does, and `dl` for term-and-description pairs.
- A nested list goes inside its parent `<li>`, before that item closes. An `<li>` outside a list is invalid.
- `br` is for meaningful line breaks inside a block; `hr` is a thematic break, not a divider.
- Browser defaults show meaning, but CSS owns appearance. Never pick a tag just because it looks right.

**Up next:** links and images — how pages connect to each other, how a fragment jumps within a page, and how to describe a picture to someone who cannot see it.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_1_4', 'sec_html_css_basics_1', 'crs_html_css_basics', 'Checkpoint: getting started', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `<!doctype html>` do at the top of a document?","options":["It creates the page''s main heading","It tells the browser to use modern standards mode instead of quirks mode","It loads the browser''s default stylesheet","It is required for CSS to work at all"],"answerIndex":1,"explanation":"The doctype is a mode switch. Without it, browsers fall back to quirks mode, a compatibility mode with different box-sizing and layout rules. It does not create a heading or load CSS — those are separate jobs."},{"id":"q2","prompt":"Where does the `<title>` element belong?","options":["Inside `<body>`, at the top","Inside `<head>`","Inside the first `<h1>`","Anywhere; the browser moves it automatically"],"answerIndex":1,"explanation":"`<title>` describes the document itself, so it belongs in `<head>`. It appears in the browser tab, bookmarks and search results, not in the page body. Putting it in the body is invalid and browsers may move or ignore it."},{"id":"q3","prompt":"Which heading should name the main topic of a page?","options":["`<h6>`","`<h3>`","`<h1>`","Whichever heading is styled largest"],"answerIndex":2,"explanation":"`<h1>` is the top-level heading. Choose heading levels by meaning and document outline, not by the size the browser gives them. Styling can change the size later without changing the semantics."},{"id":"q4","prompt":"Which snippet nests the elements correctly?","options":["`<p>Hello <strong>world</p></strong>`","`<p>Hello <strong>world</strong></p>`","`<strong><p>Hello world</strong></p>`","`<p>Hello <strong>world</p>`"],"answerIndex":1,"explanation":"Elements must close in the reverse order they opened. The `strong` element opens inside the paragraph, so it must close before the paragraph does. The other options overlap tags or leave one unclosed."},{"id":"q5","prompt":"Which element creates a numbered list?","options":["`<ul>`","`<ol>`","`<dl>`","`<list>`"],"answerIndex":1,"explanation":"`<ol>` is an ordered list and displays numbers by default. `<ul>` is unordered and shows bullets. `<dl>` is a description list for term/definition pairs, and `<list>` is not an HTML element."},{"id":"q6","prompt":"What is the difference between `<strong>` and `<em>`?","options":["`<strong>` is bold and `<em>` is italic; both are purely visual","`<strong>` means importance and `<em>` means stress emphasis","`<strong>` is for headings and `<em>` is for paragraphs","They are identical and interchangeable"],"answerIndex":1,"explanation":"Browsers usually render `strong` bold and `em` italic, but the meaning matters more than the default look. `strong` marks importance; `em` marks stress emphasis that can change the sentence''s meaning. Screen readers can announce both."},{"id":"q7","prompt":"How does a browser treat this markup?\n\n```\n<p>One   line\nand another</p>\n```","options":["It preserves every space and line break exactly","It collapses the runs of whitespace into single spaces","It turns the line break into a `<br>`","It refuses to render the paragraph"],"answerIndex":1,"explanation":"HTML collapses consecutive spaces, tabs and newlines into one space. That is why indentation in your source does not create gaps on the page. Use CSS for spacing and `<br>` only for a meaningful line break such as a postal address."},{"id":"q8","prompt":"When is `<br>` the right choice?","options":["Between every two paragraphs to make them closer","Inside a postal address or a poem, where the line break is part of the content","To make a heading wrap on a narrow screen","To create space between two buttons"],"answerIndex":1,"explanation":"`<br>` represents a line break that belongs to the content, such as an address or song lyrics. For spacing between blocks, use margins; for wrapping text, let the browser wrap it. Using `<br>` for layout makes the page harder to style and to read."},{"id":"q9","prompt":"Which document skeleton is valid and complete?","options":["`<html><body><h1>Hi</h1></body></html>`","`<!doctype html><html lang=\"en\"><head><title>Hi</title></head><body><h1>Hi</h1></body></html>`","`<head><title>Hi</title></head><body><h1>Hi</h1></body>`","`<!doctype html><body><h1>Hi</h1></body>`"],"answerIndex":1,"explanation":"A complete modern document has the doctype, an `<html>` root with a language, a `<head>` with a title, and a `<body>`. The other snippets omit required parts; browsers may repair them, but you should not rely on that."},{"id":"q10","prompt":"Two headings use no CSS. Which renders larger by default?","options":["`<h2>`","`<h3>`","They are always the same size","`<h1>`"],"answerIndex":3,"explanation":"The browser''s default stylesheet gives higher-level headings larger font sizes: `h1` is largest, then `h2`, and so on. This is a visual hint about the outline, not the definition of the level. You can change the size with CSS while keeping the level."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_2_1', 'sec_html_css_basics_2', 'crs_html_css_basics', 'Links and images: connecting pages, describing pictures', 'interactive', 0, 1200, NULL, NULL, 'The web is not a shelf of separate pages. It is a web because pages point at each other. A link is the simplest user interface ever invented: one line of text, one destination, and a browser that handles the rest. Images are the other half of the same idea — they carry information that words alone would make clumsy, but only if you describe them for the people who cannot see them.

This lesson is about the two attributes that do most of that work: `href` and `alt`. You will learn how paths resolve, how a fragment jumps inside a page, why "click here" is a broken link label even when the link works, and how to write image markup that reserves space, loads sensibly and survives a broken connection. Every image in this lesson is an inline SVG data URI, so nothing depends on the network.

## A link is a promise about a destination

An anchor is written with `<a href="…">`. The `href` is the destination; the text between the tags is the label the user sees, clicks and hears. The browser turns the whole thing into a focusable link that can be opened with a mouse, the Enter key or a screen reader''s list of links.

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

`mailto:` opens the reader''s mail application with the address filled in. `tel:` opens the phone dialler on a device that has one. Both are ordinary links, so they get keyboard focus and can be activated like any other.

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

`target="_blank"` opens the destination in a new tab. Use it when leaving the current page would genuinely lose the reader''s place: a PDF, a reference, a third-party tool. Add `rel="noopener"` so the new page cannot reach back through `window.opener` and manipulate the page it came from. Modern browsers apply this protection automatically for `target="_blank"`, but writing it explicitly is still the habit you want, and it helps older browsers.

> **Pitfall:** Opening every external link in a new tab is not a kindness. It breaks the Back button''s meaning and can strand keyboard users in an unexpected window. Choose deliberately, and say so in the link text when it matters: "price list (PDF, opens in a new tab)".

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

> **Under the hood:** The accessibility tree exposes each link with an accessible name. For a text link, that name comes from its text content. For an image inside a link, it comes from the image''s `alt`. For an icon-only link with no text, you need `aria-label` — but that is a last resort, not a replacement for writing a label.

## Images: source, alternative and dimensions

An image is an empty element: `<img src="…" alt="…">`. `src` is the URL of the image file. `alt` is the text alternative — what the page says when the image cannot be seen. The attribute is required in practice even when its value is empty.

```html run
<figure>
  <img
    src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''400'' viewBox=''0 0 640 400''%3E%3Crect width=''640'' height=''400'' fill=''%23dbeafe''/%3E%3Ccircle cx=''498'' cy=''92'' r=''46'' fill=''%23f59e0b''/%3E%3Cpath d=''M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z'' fill=''%23134e4a''/%3E%3Cpath d=''M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
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

The `width` and `height` attributes are not a design decision. They tell the browser the image''s intrinsic dimensions, which lets it reserve the right amount of space before the image loads. Without them, the page jumps as images arrive — the layout shift people feel as "this site is broken". The numbers are unitless pixels. CSS can still make the image fluid with `width: 100%; height: auto` without changing the aspect ratio the browser reserved.

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
- **Functional**: if the image is the only content of a link or button, the alt text is the link''s label. Describe the destination or action, not the pixels. A link containing a map icon should say "View the trail map", not "Map icon".

```html run
<h2>Three jobs for an image</h2>

<figure>
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''240'' viewBox=''0 0 640 240''%3E%3Crect width=''640'' height=''240'' fill=''%23e0f2fe''/%3E%3Cpath d=''M0 190 L140 96 L280 178 L420 112 L640 204 L640 240 L0 240 Z'' fill=''%230f766e''/%3E%3C/svg%3E" alt="The Kinder Loop climbs 340 metres over 12 kilometres, with the steepest section between Edale and the ridge." width="640" height="240">
  <figcaption>Elevation profile of the Kinder Loop.</figcaption>
</figure>

<p>
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''64'' height=''64'' viewBox=''0 0 64 64''%3E%3Crect width=''64'' height=''64'' rx=''14'' fill=''%230f766e''/%3E%3Cpath d=''M18 40 L30 24 L38 34 L46 22'' stroke=''white'' stroke-width=''4'' fill=''none'' stroke-linecap=''round'' stroke-linejoin=''round''/%3E%3C/svg%3E" alt="" width="24" height="24">
  A decorative mark beside a paragraph. The empty alt keeps it out of the way.
</p>

<p>
  <a href="trail-guide.html">
    <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''64'' height=''64'' viewBox=''0 0 64 64''%3E%3Crect width=''64'' height=''64'' rx=''14'' fill=''%23f59e0b''/%3E%3Cpath d=''M20 18 H44 V46 H20 Z'' fill=''white''/%3E%3Cpath d=''M26 26 H38 M26 32 H38 M26 38 H34'' stroke=''%230f766e'' stroke-width=''3''/%3E%3C/svg%3E" alt="Trail guide: seven walks in the Peak District" width="24" height="24">
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

For a complex image — a chart with several series, a screenshot of an interface — a short alt may not be enough. Give the key takeaway in `alt`, then put the full description in nearby text, a table or a details element. Alt text is a replacement for the image''s *purpose*, not an exhaustive inventory of its pixels.

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
  src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''400'' viewBox=''0 0 640 400''%3E%3Crect width=''640'' height=''400'' fill=''%23dbeafe''/%3E%3Ccircle cx=''498'' cy=''92'' r=''46'' fill=''%23f59e0b''/%3E%3Cpath d=''M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z'' fill=''%23134e4a''/%3E%3Cpath d=''M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
  width="640" height="400">
--- solution
<h2>Kinder Scout at sunrise</h2>
<figure>
  <img
    src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''400'' viewBox=''0 0 640 400''%3E%3Crect width=''640'' height=''400'' fill=''%23dbeafe''/%3E%3Ccircle cx=''498'' cy=''92'' r=''46'' fill=''%23f59e0b''/%3E%3Cpath d=''M0 318 L150 178 L300 300 L430 214 L640 356 L640 400 L0 400 Z'' fill=''%23134e4a''/%3E%3Cpath d=''M0 356 L132 282 L284 348 L438 286 L640 388 L640 400 L0 400 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
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
assert(!/^(image|picture|photo) of/i.test(alt), "Do not start alt text with ''image of'' or ''photo of''. Screen readers already announce that it is an image.");
assert(!/^kinder scout at sunrise$/i.test(alt), "The alt text repeats the heading. Say what the picture actually shows.");
assertAttr("figure img", "width", "640", "Keep the intrinsic width so the browser can reserve space.");
assertAttr("figure img", "height", "400", "Keep the intrinsic height so the browser can reserve space.");
assertAttr("figure img", "loading", "lazy", "Add loading=''lazy'' so the image can wait until the reader approaches it.");
assertAttr("figure img", "decoding", "async", "Add decoding=''async'' to let the browser decode the image off the main thread.");
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
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''360'' viewBox=''0 0 640 360''%3E%3Crect width=''640'' height=''360'' fill=''%23dbeafe''/%3E%3Ccircle cx=''500'' cy=''80'' r=''42'' fill=''%23f59e0b''/%3E%3Cpath d=''M0 286 L150 160 L300 270 L430 192 L640 320 L640 360 L0 360 Z'' fill=''%23134e4a''/%3E%3C/svg%3E" width="640" height="360">
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
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''360'' viewBox=''0 0 640 360''%3E%3Crect width=''640'' height=''360'' fill=''%23dbeafe''/%3E%3Ccircle cx=''500'' cy=''80'' r=''42'' fill=''%23f59e0b''/%3E%3Cpath d=''M0 286 L150 160 L300 270 L430 192 L640 320 L640 360 L0 360 Z'' fill=''%23134e4a''/%3E%3C/svg%3E" alt="A pale sunrise over the dark Kinder Scout ridge, seen from the trail." width="640" height="360">
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
assert(!/^(image|picture|photo) of/i.test(alt), "Do not start alt text with ''image of''. The screen reader already says it is an image.");
const link = query("a");
const text = normalize(link.textContent);
assert(!/click here/i.test(text), "The link still uses ''click here''. Replace it with text that names the destination.");
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
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_2_2', 'sec_html_css_basics_2', 'crs_html_css_basics', 'Page structure: landmarks, sections and the document outline', 'interactive', 1, 1080, NULL, NULL, 'A page can look organised and still be a maze. Sighted users get clues from position, colour and size: the logo top-left, the menu across the top, the article in the middle, the small print at the bottom. A screen reader user gets none of that unless the markup says so. Landmarks are the names of the rooms. They let someone jump straight to the main content, skip the navigation, or find the complementary notes without reading the page from the first word.

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

> **Under the hood:** The accessibility tree is built from the DOM plus each element''s role and name. A `div` has a generic role and no name. A `header`, `nav` or `main` has a landmark role. That is why replacing divs with the right elements changes what a screen reader can do, even when the CSS is untouched.

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

`<header>` and `<footer>` are not limited to the top and bottom of the page. An article can have its own header and footer; a section can too. The landmark role changes with context: a `header` inside an `article` is that article''s header, not the page banner. A `footer` inside a section is that section''s footer, not the site-wide contentinfo.

`<nav>` is for *major* navigation, not every group of links. Two or three links in a paragraph do not need a nav. A page with a main menu and a separate table of contents should have two navs, each with a distinct accessible name:

```html
<nav aria-label="Main">…</nav>
<nav aria-label="On this page">…</nav>
```

`<main>` is the primary content. It should contain the page''s `h1` and the content a reader came for. It should not contain the site-wide header, navigation, sidebar or footer. A document should have one visible `<main>`; if you find yourself adding a second, you usually want an `<article>` or an `<aside>` instead.

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

**Headings form an outline.** Use one `h1` for the page''s main topic, `h2` for major sections, `h3` for subsections and so on. Do not skip levels to get a smaller font size. The heading level is the nesting level of the content; the size is CSS''s job. `section` does not automatically create a heading level, and a heading inside a section still needs the right number for its place in the document.

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
- A **section** is a part of something larger. It groups related content under a heading. "What you''ll learn" inside a workshop card is a section.
- An **aside** is a side note. Related links, an author bio, a pull quote. It supports the main content without being part of its argument.

```html run
<main class="page">
  <h1>Workshops</h1>

  <article class="card">
    <h2>Green wood stool</h2>
    <p>Two days in the workshop, one stool, and a lot of shavings.</p>
    <section aria-labelledby="stool-details">
      <h3 id="stool-details">What you''ll learn</h3>
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

The workshop card is an article because it is a complete listing that could appear on a workshops page, a category page or a newsletter. "What you''ll learn" is a section because it only makes sense inside that card. The note about the spoon-carving evening is an aside because it is related but not part of the workshop listing. The `aria-labelledby` on the section points at its heading, giving the region an explicit name.

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

Build the structure for a blog page. It needs a page header with a `nav` of three links, a `main` containing an `article` with the page''s `h1`, a page footer, and a skip link as the first link on the page.

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
assertAttr("main", "id", "main", "Give main id=''main'' so the skip link has a target.");
const skip = query(''a[href="#main"]'');
assert(skip === document.querySelector("a"), "The skip link should be the first link on the page, before the header.");
assertText(''a[href="#main"]'', "Skip to main content", "The skip link should read: Skip to main content.");
assertExists("header", "Use a header element for the page header.");
assertExists("nav", "Add a nav element for the main page links.");
const navLinks = Array.from(document.querySelectorAll("nav a"));
assert(navLinks.length >= 3, `The navigation should have at least 3 links, but it has ${navLinks.length}.`);
navLinks.forEach((a) => assert(normalize(a.textContent).length > 0, "Every navigation link needs text."));
assertExists("main article", "The article should sit inside main.");
assertExists("main h1", "The page''s h1 should be inside main.");
assertExists("main article h2, main article h1", "The article needs its own heading.");
assertExists("footer", "Use a footer element for the page footer.");
--- hint
The skip link goes first in the body, before the header. Its `href` and the main element''s `id` must match.
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
`main` is the landmark for the page''s primary content, and a screen reader user can jump straight to it. The article is one self-contained piece inside main; a section groups a theme within a larger page; a div has no landmark role at all.
```

## Challenge: choose article or section

This workshop card is built from divs. Make the card an `article`, because it is a self-contained listing that could appear on another page. Make the "What you''ll learn" block a `section` with its heading. Keep the existing text and list.

```html exercise id=workshop-card title="Choose article or section"
<main class="page">
  <h1>Workshops</h1>
  <div class="card">
    <h2>Green wood stool</h2>
    <p>Two days in the workshop, one stool, and a lot of shavings.</p>
    <div class="details">
      <h3>What you''ll learn</h3>
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
      <h3 id="stool-details">What you''ll learn</h3>
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
assertText("article.card h2", "Green wood stool", "Keep the workshop title as the card''s heading.");
const section = query("article.card section");
assert(section, "The ''What you''ll learn'' block should be a section inside the article.");
assertExists("article.card section h2, article.card section h3", "A section needs its own heading.");
assertText("article.card section h3", "What you''ll learn", "The section heading should remain ''What you''ll learn''.");
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
- Put the page''s `h1` in `main`, then use `h2` and `h3` in order. Heading levels are the outline; size is CSS.
- A `section` should have a heading. Add `aria-labelledby` when you want it announced as a named region; a `div` is the right choice when you only need a styling wrapper.
- `article` is self-contained; `section` is a part of something larger; `aside` is tangential.
- A skip link is the first focusable element, points at `#main`, and becomes visible on focus. Native landmarks are what screen readers list and jump between.

**Up next:** tables — the one place where rows, columns and headers are not just a layout convenience, and where a missing header makes the data unreadable.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_2_3', 'sec_html_css_basics_2', 'crs_html_css_basics', 'Tables: data that stays readable', 'interactive', 2, 1080, NULL, NULL, 'A train timetable, an invoice, a league table, a recipe conversion chart: they all share a shape. Every value means something only in relation to a row heading and a column heading. HTML has a dedicated element for exactly that relationship, and it is not a grid of boxes you style until it looks right. A real table tells the browser — and a screen reader — which cell is a header, which cells belong to it, and what the whole thing is about.

That structure is also what keeps a table readable when the data gets wider than the page. In this lesson you will build tables that survive long content, merged cells and small screens, and you will learn why the quickest-looking layout trick is the one that causes the most damage.

## A table is a relationship, not a layout

Use a table when the data has two axes: rows and columns that both carry meaning. A market schedule qualifies. A row of three feature cards does not. The difference is not visual — it is whether a cell''s meaning depends on its row and column headings.

```html run
<h1>Saturday at the market</h1>
<p>Three stalls, three jobs, one very early start.</p>

<table>
  <tr>
    <th scope="col">Stall</th>
    <th scope="col">Opens</th>
    <th scope="col">Closes</th>
  </tr>
  <tr>
    <th scope="row">Bread</th>
    <td>7:00</td>
    <td>13:00</td>
  </tr>
  <tr>
    <th scope="row">Flowers</th>
    <td>8:00</td>
    <td>12:30</td>
  </tr>
  <tr>
    <th scope="row">Coffee</th>
    <td>6:30</td>
    <td>14:00</td>
  </tr>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; }
  th, td { padding: 0.5rem 1rem; border-bottom: 1px solid #cbd5e1; text-align: left; }
  tr:first-child th { background: #f1f5f9; }
</style>
```

Every data cell here is meaningful because of two headers: the column tells you whether `7:00` is an opening or closing time, and the row tells you which stall it belongs to. That is the test. If the data becomes ambiguous without its headings, a table is probably right.

> **Pitfall:** Before CSS Grid existed, developers built entire page layouts with tables. The result looked fine and behaved badly: screen readers announced navigation as tabular data, responsive layouts became impossible, and one extra cell could shift the whole page. Never use a table to position things. Use it to describe data.

## The anatomy of a table

A table is built from rows. Inside each row, `th` marks a header cell and `td` marks a data cell. Around those rows, three optional groups add meaning: `thead` for the header row, `tbody` for the main data, and `tfoot` for totals or closing notes. A `caption` names the table and travels with it.

```html run
<table>
  <caption>Intro to screen printing — Saturday, 14 June</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Session</th>
      <th scope="col">Room</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">09:30</th>
      <td>Paper, ink and a very sharp squeegee</td>
      <td>Studio A</td>
    </tr>
    <tr>
      <th scope="row">11:00</th>
      <td>Preparing a screen</td>
      <td>Studio B</td>
    </tr>
    <tr>
      <th scope="row">13:30</th>
      <td>Printing your first layer</td>
      <td>Studio A</td>
    </tr>
  </tbody>
  <tfoot>
    <tr><th scope="row">Finish</th><td colspan="2">Bring your prints home — wear clothes you can ruin</td></tr>
  </tfoot>
</table>
<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { padding: 0 0 1rem; text-align: left; font-weight: 700; font-size: 1.1rem; }
  th, td { padding: 0.75rem 1rem; border-bottom: 1px solid #e2e8f0; text-align: left; vertical-align: top; }
  thead th { background: #0f172a; color: #f8fafc; }
  tfoot th, tfoot td { background: #f8fafc; font-weight: 600; }
</style>
```

`caption` is not a replacement for a heading. A page still needs its own `h1` and section headings. The caption belongs to the table the way a `figcaption` belongs to a figure: it describes the specific object, and assistive technology can announce it when someone enters the table.

The groups matter for more than styling. `thead` and `tfoot` tell the browser which rows are not ordinary data, which helps when a long table is printed or split across pages. `tbody` can appear more than once if a table has genuinely separate chunks of data, but most tables need one.

> **Under the hood:** The browser repairs table markup aggressively. A stray `td` can create an implicit row, a `tfoot` written before `tbody` may be moved, and a missing closing tag can restructure the whole grid. Validate your table structure rather than trusting the parser to guess.

## Headers need a scope

A visual header is only half the job. `scope` tells assistive technology whether a `th` describes the column below it or the row beside it. `scope="col"` is for the header row; `scope="row"` is for the first cell in a data row.

```html run
<table class="ledger">
  <caption>March studio expenses</caption>
  <thead>
    <tr>
      <th scope="col">Item</th>
      <th scope="col">Date</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Clay</th>
      <td>4 March</td>
      <td class="number">£86.00</td>
    </tr>
    <tr>
      <th scope="row">Glaze</th>
      <td>11 March</td>
      <td class="number">£42.50</td>
    </tr>
    <tr>
      <th scope="row">Kiln service</th>
      <td>19 March</td>
      <td class="number">£130.00</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  .ledger { border-collapse: collapse; width: 100%; max-width: 34rem; }
  .ledger caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  .ledger th, .ledger td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  .ledger thead th { background: #ecfdf5; color: #065f46; }
  .ledger .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
```

Without `scope`, a screen reader has to guess. With it, moving to `£42.50` can be announced as "Glaze, 11 March, £42.50" instead of a bare number. The attribute costs almost nothing and removes a whole class of ambiguity.

A useful test is to read a single data cell aloud with no visual context. If you cannot say which row and column it belongs to, the header relationships are incomplete. That is also why a header cannot be replaced by bold text or a shaded background: those are visual cues, and the accessibility tree never sees them.

Not every `th` needs to be in `thead`. The first cell of each body row is a header too, which is why it is a `th` with `scope="row"` rather than a `td`. If the top-left cell is empty because the table has both column and row headers, leave it as an empty `td` or give it a meaningful label such as "Item".

## Challenge: build a schedule table

Build a three-column schedule for a Saturday workshop. The table needs a caption that reads `Saturday studio schedule`, three column headers (`Time`, `Session`, `Room`) with the correct scope, and three sessions. The starter already has two sessions; add the third at `11:00`, called `Glazing`, in `Studio B`.

```html exercise id=tables-schedule title="Build a schedule table"
<table>
  <thead>
    <tr>
      <td>Time</td>
      <td>Session</td>
      <td>Room</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>09:00</td>
      <td>Doors open</td>
      <td>Atrium</td>
    </tr>
    <tr>
      <td>09:30</td>
      <td>Keynote</td>
      <td>Main hall</td>
    </tr>
  </tbody>
</table>
--- solution
<table>
  <caption>Saturday studio schedule</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Session</th>
      <th scope="col">Room</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>09:00</td>
      <td>Doors open</td>
      <td>Atrium</td>
    </tr>
    <tr>
      <td>09:30</td>
      <td>Keynote</td>
      <td>Main hall</td>
    </tr>
    <tr>
      <td>11:00</td>
      <td>Glazing</td>
      <td>Studio B</td>
    </tr>
  </tbody>
</table>
--- test
assertExists("table caption", "The table needs a caption that names the schedule");
assertText("table caption", "Saturday studio schedule", "The caption should read: Saturday studio schedule");
assertCount("table thead th", 3, "The header row needs three th cells, not td cells");
const headers = Array.from(document.querySelectorAll("table thead th"));
assert(headers.every((th) => th.getAttribute("scope") === "col"), "Each column header needs scope=\"col\" so assistive technology knows what it labels");
assertText("table thead th:nth-child(1)", "Time", "The first column header should read: Time");
assertText("table thead th:nth-child(2)", "Session", "The second column header should read: Session");
assertText("table thead th:nth-child(3)", "Room", "The third column header should read: Room");
assertCount("table tbody tr", 3, "The schedule should have three sessions in the body");
const last = document.querySelectorAll("table tbody tr")[2];
assertCount("table tbody tr:last-child > *", 3, "Each schedule row should still have exactly three cells");
assert(normalize(last.children[0].textContent) === "11:00", "The third session should start at 11:00");
assert(normalize(last.children[1].textContent) === "Glazing", "The third session should be called Glazing");
assert(normalize(last.children[2].textContent) === "Studio B", "The third session belongs in Studio B");
--- hint
A caption goes immediately inside the table, before the header row.
--- hint
The cells in the header row describe columns, so use `<th scope="col">` instead of `<td>`.
--- hint
Copy one of the existing body rows, then change its three values to 11:00, Glazing and Studio B.
```

## Merging cells with colspan and rowspan

Sometimes one cell really does cover several columns or rows. `colspan="2"` makes a cell stretch across two columns; `rowspan="2"` makes it stretch down two rows. The number counts columns or rows, not pixels, so the rest of the row has to add up.

```html run
<table>
  <caption>Pottery classes</caption>
  <thead>
    <tr>
      <th scope="col">Day</th>
      <th scope="col">Morning</th>
      <th scope="col">Afternoon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row" rowspan="2">Saturday</th>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
    <tr>
      <td colspan="2">Open studio — bring your own project</td>
    </tr>
    <tr>
      <th scope="row">Sunday</th>
      <td>Hand building</td>
      <td>Kiln loading</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 38rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  thead th { background: #f1f5f9; }
</style>
```

The Saturday header spans two rows, so the following row starts with the merged Saturday cell already in place. The open studio cell spans both the Morning and Afternoon columns, so it is the only cell in that row besides the row header. Read the rows as a grid: every row still accounts for three columns.

> **Pitfall:** Merged cells are hard to navigate with a keyboard or a screen reader, and they break simple copy-and-paste into a spreadsheet. Use them when the data genuinely merges — a lunch break that covers the whole afternoon, a date shared by two sessions — not to make a prettier header.

```html predict id=tables-colspan-predict title="What does colspan do to the row?"
<table>
  <caption>Workshop sign-ups</caption>
  <tr>
    <th scope="col">Name</th>
    <th scope="col">Morning</th>
    <th scope="col">Afternoon</th>
  </tr>
  <tr>
    <th scope="row">Ada</th>
    <td colspan="2">All-day pass</td>
  </tr>
  <tr>
    <th scope="row">Grace</th>
    <td>Wheel</td>
    <td>Glaze</td>
  </tr>
</table>
--- options
* Ada''s cell stretches across the Morning and Afternoon columns, so the row still accounts for three columns
Ada''s cell sits only in Morning, and the Afternoon cell is left empty
The table grows a fourth column to hold the extra cell
Every cell in Ada''s row merges into one wide column
--- explain
`colspan="2"` makes one cell occupy two column tracks. The cell does not add a fourth column; it consumes the two columns that follow it. That is why the row still lines up with the three headers above it. If you add up the widths and get more than the table has, the browser will create extra columns and the grid will look broken.
```

## Challenge: a totals row that belongs in tfoot

A totals row is not another data row. Put it in `tfoot`, give its label a `th` with `scope="row"`, and let the label span the first two columns so the number lands under `Amount`. Reuse the `number` class on the amount so it stays right-aligned with tabular figures.

The starter has the invoices but no footer. Add a `tfoot` with one row: a row header that says `Total outstanding` and spans two columns, followed by a data cell containing `£2,150`.

```html exercise id=tables-totals title="Add a totals row with tfoot"
<table>
  <caption>February invoices</caption>
  <thead>
    <tr>
      <th scope="col">Client</th>
      <th scope="col">Invoice</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Moss &amp; Pine</td>
      <td>#1042</td>
      <td class="number">£1,200</td>
    </tr>
    <tr>
      <td>Field Notes</td>
      <td>#1043</td>
      <td class="number">£650</td>
    </tr>
    <tr>
      <td>Atelier North</td>
      <td>#1044</td>
      <td class="number">£300</td>
    </tr>
  </tbody>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { background: #0f172a; color: #f8fafc; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
--- solution
<table>
  <caption>February invoices</caption>
  <thead>
    <tr>
      <th scope="col">Client</th>
      <th scope="col">Invoice</th>
      <th scope="col" class="number">Amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Moss &amp; Pine</td>
      <td>#1042</td>
      <td class="number">£1,200</td>
    </tr>
    <tr>
      <td>Field Notes</td>
      <td>#1043</td>
      <td class="number">£650</td>
    </tr>
    <tr>
      <td>Atelier North</td>
      <td>#1044</td>
      <td class="number">£300</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th scope="row" colspan="2">Total outstanding</th>
      <td class="number">£2,150</td>
    </tr>
  </tfoot>
</table>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  table { border-collapse: collapse; width: 100%; max-width: 40rem; }
  caption { text-align: left; font-weight: 700; padding-bottom: 0.75rem; }
  th, td { padding: 0.7rem 0.9rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { background: #0f172a; color: #f8fafc; }
  tfoot th, tfoot td { background: #f8fafc; font-weight: 700; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
--- test
assertExists("table tfoot", "A totals row belongs in tfoot, not at the end of tbody");
assertCount("table tfoot tr", 1, "tfoot should contain exactly one totals row");
const total = query("table tfoot th");
assert(total.getAttribute("scope") === "row", "The totals label is a row header, so it needs scope=\"row\"");
assertAttr("table tfoot th", "colspan", "2", "The label should span the Client and Invoice columns");
assertText("table tfoot th", "Total outstanding", "The totals label should read: Total outstanding");
assertText("table tfoot td", "£2,150", "The amount cell should show the sum: £2,150");
assertCount("table tfoot tr > *", 2, "The totals row has two cells: the spanning header and the amount");
assertStyle("table", "border-collapse", "collapse", "Collapse the table borders so the footer shares the same grid lines");
assertStyle("table tfoot tr > td:last-child", "text-align", "right", "Right-align the total so it lines up under the Amount column");
assertStyle("table tfoot tr > td:last-child", "font-variant-numeric", "tabular-nums", "Use tabular numbers so the total aligns with the amounts above");
--- hint
`tfoot` is a sibling of `tbody`, not a row inside it.
--- hint
The label is a `th` with `scope="row"`, and `colspan="2"` lets it cover the first two columns.
--- hint
The amount belongs in a `td` after the row header, so it sits under the Amount column.
```

## Making a wide table readable

A table can be structurally perfect and still unpleasant to read. The usual fixes are small: collapse the borders, give cells breathing room, align numbers to the right, and use a typeface where digits line up.

```html run
<div class="table-wrap">
  <table>
    <caption>Trail series standings</caption>
    <thead>
      <tr>
        <th scope="col">Runner</th>
        <th scope="col">Races</th>
        <th scope="col" class="number">Points</th>
      </tr>
    </thead>
    <tbody>
      <tr><th scope="row">Ada</th><td>6</td><td class="number">482</td></tr>
      <tr><th scope="row">Grace</th><td>5</td><td class="number">461</td></tr>
      <tr><th scope="row">Lin</th><td>6</td><td class="number">447</td></tr>
      <tr><th scope="row">Sam</th><td>4</td><td class="number">398</td></tr>
      <tr><th scope="row">Jo</th><td>6</td><td class="number">376</td></tr>
      <tr><th scope="row">Noor</th><td>5</td><td class="number">351</td></tr>
    </tbody>
  </table>
</div>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  .table-wrap { max-width: 36rem; max-height: 15rem; overflow: auto; border: 1px solid #cbd5e1; border-radius: 12px; }
  table { width: 100%; border-collapse: collapse; }
  caption { padding: 1rem; text-align: left; font-weight: 700; background: #f8fafc; }
  th, td { padding: 0.7rem 1rem; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { position: sticky; top: 0; background: #0f172a; color: #f8fafc; }
  tbody tr:nth-child(even) { background: #f8fafc; }
  .number { text-align: right; font-variant-numeric: tabular-nums; }
</style>
```

`border-collapse: collapse` makes adjacent borders share a single line instead of drawing two lines with a gap. Without it, every cell looks slightly heavier and the grid develops a double-border shimmer. `font-variant-numeric: tabular-nums` asks the font for fixed-width digits, so a column of prices or points lines up no matter which digits appear.

Keep the caption visible, even when the page already has a heading above the table. The caption is the only name the table itself carries into the accessibility tree. If the design cannot give it a full line, make it smaller or place it below the table with `caption-side: bottom`; do not remove it and hope the nearest heading does the job.

The sticky header is the one piece that needs a scroll container. The `thead th` cells use `position: sticky; top: 0` inside `.table-wrap`, whose `max-height` and `overflow: auto` create the scrolling box. Scroll the table and the column labels stay in view. The container also keeps a wide table from forcing the whole page sideways.

> **Tip:** On a phone, a five-column table rarely fits. Let the table scroll inside its own container, keep the first column visible if you can, and never shrink the text until it becomes unreadable. A horizontal scroll bar inside the table''s own container is far better than a page that scrolls sideways.

## Debug: the table that only looks like a table

This timetable renders convincingly. The first row is bold and shaded, and the first column reads like a set of labels. But every cell is a `td`, and the table has no caption. A screen reader gets a rectangle of values with no idea what any of them mean.

Fix the semantics without changing the visible data: add the caption `Weekly studio timetable`, make the top row column headers with `scope="col"`, and make the first cell of each body row a row header with `scope="row"`.

```html debug id=tables-missing-headers title="The table that only looks like a table"
<table class="timetable">
  <thead>
    <tr>
      <td>Day</td>
      <td>Morning</td>
      <td>Afternoon</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Monday</td>
      <td>Open studio</td>
      <td>Life drawing</td>
    </tr>
    <tr>
      <td>Tuesday</td>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
  </tbody>
</table>

<style>
  .timetable { border-collapse: collapse; width: 100%; max-width: 34rem; font-family: system-ui, sans-serif; }
  .timetable td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  .timetable tr:first-child td { background: #f1f5f9; font-weight: 700; }
</style>
--- solution
<table class="timetable">
  <caption>Weekly studio timetable</caption>
  <thead>
    <tr>
      <th scope="col">Day</th>
      <th scope="col">Morning</th>
      <th scope="col">Afternoon</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Monday</th>
      <td>Open studio</td>
      <td>Life drawing</td>
    </tr>
    <tr>
      <th scope="row">Tuesday</th>
      <td>Wheel throwing</td>
      <td>Glazing</td>
    </tr>
  </tbody>
</table>

<style>
  .timetable { border-collapse: collapse; width: 100%; max-width: 34rem; font-family: system-ui, sans-serif; }
  .timetable th, .timetable td { padding: 0.7rem 0.9rem; border: 1px solid #cbd5e1; text-align: left; }
  .timetable thead th { background: #f1f5f9; }
</style>
--- test
assertExists("table caption", "The table still has no caption, so nothing names what the timetable is for");
assertText("table caption", "Weekly studio timetable", "The caption should read: Weekly studio timetable");
assertCount("table thead th", 3, "The top row is still made of td cells. Use th for column headers");
const columns = Array.from(document.querySelectorAll("table thead th"));
assert(columns.every((cell) => cell.getAttribute("scope") === "col"), "Every column header needs scope=\"col\"");
assertCount("table tbody th", 2, "Each body row needs a row header for its day");
const rows = Array.from(document.querySelectorAll("table tbody th"));
assert(rows.every((cell) => cell.getAttribute("scope") === "row"), "Each day header needs scope=\"row\"");
assertCount("table tbody td", 4, "The four session cells should stay as data cells");
assertText("table tbody tr:first-child th", "Monday", "The first body row should still start with Monday");
assertText("table tbody tr:last-child th", "Tuesday", "The last body row should still start with Tuesday");
--- hint
Run it first. It looks fine, which is exactly the problem: visual boldness is not semantics.
--- hint
The top row describes columns; the first cell of each body row describes that row.
--- hint
Change the header-row cells to `<th scope="col">`, the day cells to `<th scope="row">`, and add a caption before `thead`.
```

## A short table checklist

Before you ship a table, read it the way a browser does:

- Does the data genuinely need two axes, or are you using a table for layout?
- Does it have a `caption` that names what the table contains?
- Is the header row inside `thead`, with `th scope="col"` on every column header?
- Does each data row have a `th scope="row"` if the first cell labels the row?
- Do `colspan` and `rowspan` values still add up to a consistent grid?
- Are numbers right-aligned and set with `tabular-nums` where columns are compared?
- Does a wide table scroll inside a container instead of pushing the page sideways?

None of these require JavaScript. They are all decisions in the markup and a few lines of CSS.

## Recap

- A table describes data with two axes. If the content is only a layout, use CSS.
- `caption`, `thead`, `tbody` and `tfoot` give the table a name and a structure that survives printing and assistive technology.
- `th` marks headers; `scope="col"` and `scope="row"` say which cells they describe.
- `colspan` and `rowspan` merge cells across columns and rows, and the rest of the grid must still add up.
- `border-collapse: collapse`, right-aligned `tabular-nums`, and a sticky `thead` make dense data easier to read.
- A table that looks right but uses only `td` cells is still inaccessible.

**Up next:** forms — the place where visitors stop reading and start typing, and where a missing label or the wrong button type quietly loses their data.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_2_4', 'sec_html_css_basics_2', 'crs_html_css_basics', 'Checkpoint: links, images & structure', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What happens when a visitor activates `<a href=\"#pricing\">Pricing</a>`?","options":["The browser loads a new page called pricing","The browser scrolls to the element whose `id` is `pricing` on the current page","It downloads the pricing file","Nothing happens unless JavaScript is enabled"],"answerIndex":1,"explanation":"A hash link targets an element by its `id` on the current page. The URL fragment `#pricing` matches `id=\"pricing\"`. Hash links are the standard way to build in-page navigation and skip links."},{"id":"q2","prompt":"Why add `rel=\"noopener\"` to a link with `target=\"_blank\"`?","options":["It makes the link open faster","It prevents the new page from accessing the original page through `window.opener`","It forces the link to open in the same tab","It adds a visible warning to the link"],"answerIndex":1,"explanation":"`noopener` severs the `window.opener` reference, so the new page cannot manipulate the original tab. Modern browsers imply it for `target=\"_blank\"`, but being explicit is still good practice and documents the intent."},{"id":"q3","prompt":"A page at `/blog/post.html` links to `../about.html`. Which file does that resolve to?","options":["`/blog/about.html`","`/about.html`","`/blog/post.html/about.html`","A file on another website"],"answerIndex":1,"explanation":"`..` moves up one directory from `/blog/` to the site root, so `../about.html` resolves to `/about.html`. A relative URL is resolved against the current document''s location, which makes it portable across domains."},{"id":"q4","prompt":"What is the best `alt` text for a decorative image that adds no information?","options":["`alt=\"image\"`","`alt=\"decorative\"`","`alt=\"\"` (an empty alt attribute)","Omit the alt attribute entirely"],"answerIndex":2,"explanation":"An empty `alt=\"\"` tells assistive technology to ignore the image, which is correct for decoration. Omitting the attribute is different: screen readers may announce the filename. `alt=\"image\"` adds noise without describing anything."},{"id":"q5","prompt":"Which element pairs an image with a visible caption?","options":["`<img>` with a `title` attribute","`<figure>` containing the `<img>` and a `<figcaption>`","`<caption>` next to the image","`<p>` with the image inside it"],"answerIndex":1,"explanation":"`<figure>` groups a self-contained piece of content with an optional `<figcaption>`. The caption is visible and programmatically associated with the figure. The `title` attribute is not a reliable caption; `<caption>` is for tables."},{"id":"q6","prompt":"Which landmark should wrap the primary content of a page?","options":["`<section>`","`<main>`","`<div class=\"main\">`","`<article>`"],"answerIndex":1,"explanation":"`<main>` is the landmark for the dominant content of the document, and there should be one per page. A `<div>` with a class has no semantics. `<article>` is for self-contained compositions, and `<section>` is a thematic grouping inside the page."},{"id":"q7","prompt":"How many `<main>` elements should a page normally have?","options":["As many as it has sections","Exactly one visible main landmark","One per article","None; `<main>` is obsolete"],"answerIndex":1,"explanation":"A page should expose one main landmark. If you need multiple content areas, use `<section>` or `<article>` inside `<main>`. Multiple `main` elements make the landmark navigation ambiguous for screen-reader users."},{"id":"q8","prompt":"In a data table, which markup associates a header cell with its column?","options":["`<td scope=\"col\">`","`<th scope=\"col\">`","`<thead>` alone","`<caption>`"],"answerIndex":1,"explanation":"A `<th>` is a header cell, and `scope=\"col\"` says it labels the column below it. A `<td>` is a data cell. `<thead>` groups rows but does not by itself tell assistive technology which cells are headers."},{"id":"q9","prompt":"What is the purpose of `<caption>` in a table?","options":["It styles the table border","It gives the table an accessible name and a visible title","It creates the first row of data","It makes the header row sticky"],"answerIndex":1,"explanation":"`<caption>` is the table''s title. It appears above the table by default and is announced as the table''s accessible name. Use it to say what the data represents, such as \"Opening hours by day\"."},{"id":"q10","prompt":"A card contains a title, a short summary and a link to a full article. Which element is the best fit?","options":["`<article>`","`<span>`","`<main>`","`<table>`"],"answerIndex":0,"explanation":"An `<article>` is a self-contained composition that could stand alone or be syndicated, which fits an article card. A `<span>` has no structural meaning, `<main>` is a page-level landmark, and a table is for tabular data, not layout."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_3_1', 'sec_html_css_basics_3', 'crs_html_css_basics', 'Forms: labels, inputs and buttons people can actually use', 'interactive', 0, 1200, NULL, NULL, 'A form is a conversation with a stranger. You ask for an email address, a date, a delivery note; they decide whether the conversation is worth continuing. Most of that decision happens before anyone types: a field without a visible label looks like homework, a button that submits when it should not can wipe a half-finished order, and an error message that only changes color is invisible to plenty of people.

HTML gives you the whole vocabulary for that conversation. In this lesson you will build forms with labels that actually connect to their inputs, choose input types that do real work on phones and in browsers, group related choices, and write error text that a screen reader can associate with the field it belongs to.

## A form is a container, a label and an input

The `<form>` element groups the controls that belong to one submission. Its `action` is the URL that receives the data and its `method` is how the data travels — usually `post` for anything that changes something. Inside, every control needs a `name`, because that is the key sent to the server. The `id` is for the page: it lets a label point at the control and lets CSS target it.

```html run
<form action="#" method="post">
  <h2>Get the Saturday letter</h2>
  <p>One email a week. New coffees, brewing notes, no noise.</p>

  <label for="newsletter-email">Email address</label>
  <input id="newsletter-email" name="email" type="email" autocomplete="email" required>

  <button type="submit">Subscribe</button>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; background: #f8fafc; }
  form { max-width: 26rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  h2 { margin: 0 0 0.35rem; font-size: 1.25rem; }
  p { margin: 0 0 1.25rem; color: #475569; line-height: 1.5; }
  label { display: block; margin-bottom: 0.4rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.7rem 0.8rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  button { margin-top: 1rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
```

The `for` attribute on the label and the `id` on the input are a pair. When they match, clicking the label focuses the input, tapping the label on a phone opens the right keyboard, and a screen reader announces the label as the field''s name. When they do not match, the label becomes decoration.

> **Tip:** `name` and `id` are not interchangeable. `name` is what the server receives; `id` is what the page uses to connect elements. A control can have both, and usually should.

```html predict id=forms-label-predict title="Which input does the label focus?"
<form>
  <label for="email">Work email</label>
  <input id="contact-email" name="contact" type="email">

  <label for="backup-email">Backup email</label>
  <input id="backup-email" name="backup" type="email">
</form>
--- options
* Nothing receives focus, because no element has id="email"
The first input, because it is the nearest one to the label
The second input, because its label is correctly connected
Both inputs receive focus at once
--- explain
A label''s `for` attribute must match an input''s `id` exactly. The first label points at `email`, but the first input''s id is `contact-email`, so the browser has nothing to focus. The `name` attributes do not help: they are for the server, not for label association. The second label works because `for="backup-email"` matches `id="backup-email"`.
```

## Placeholders are hints, not labels

A placeholder is the grey text inside an empty field. It can show the expected format — `e.g. repotting` — but it disappears the moment someone types, it is often too low-contrast to read, and it is not a reliable accessible name. The label stays visible above the field, so the question never disappears.

```html run
<form>
  <div class="field">
    <label for="article-search">Search the journal</label>
    <input id="article-search" name="q" type="search" placeholder="e.g. repotting" aria-describedby="search-hint">
    <p id="search-hint" class="hint">Searches titles, ingredients and notes.</p>
  </div>

  <div class="field bad">
    <p class="eyebrow">Don''t do this</p>
    <input type="search" placeholder="Search the journal">
  </div>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 28rem; }
  .field { margin-bottom: 1.5rem; }
  label { display: block; margin-bottom: 0.4rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.7rem 0.8rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  .hint { margin: 0.4rem 0 0; color: #64748b; font-size: 0.85rem; }
  .bad { padding: 1rem; border: 1px dashed #cbd5e1; border-radius: 10px; background: #f8fafc; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
</style>
```

The `aria-describedby` attribute points at the hint paragraph. Unlike a placeholder, the hint is not a label: it adds an explanation after the field''s name. We will use it properly for error text below.

> **Pitfall:** Replacing a label with a placeholder is one of the most common accessibility failures in checkout forms. It looks tidy in a mock-up and fails the moment the field has content, the moment the connection is slow, or the moment someone uses a screen reader.

## Input types do real work

`<input>` is one element with many personalities. The `type` changes the keyboard on a phone, the validation the browser applies, and the way assistive technology describes the field. `email` checks for an address-shaped value, `number` brings up a numeric keypad, `date` offers a date picker, and `password` masks what is typed.

```html run
<form>
  <h2>Book a table</h2>

  <label for="full-name">Full name</label>
  <input id="full-name" name="name" type="text" autocomplete="name" required>

  <label for="booking-email">Email</label>
  <input id="booking-email" name="email" type="email" autocomplete="email" required>

  <label for="booking-password">Password</label>
  <input id="booking-password" name="password" type="password" autocomplete="new-password" minlength="8" required>

  <label for="guests">Guests</label>
  <input id="guests" name="guests" type="number" min="1" max="8" value="2">

  <label for="booking-date">Date</label>
  <input id="booking-date" name="date" type="date">

  <button type="submit">Book a table</button>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 24rem; }
  label { display: block; margin: 0.9rem 0 0.35rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.65rem 0.75rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  button { margin-top: 1.25rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
```

`autocomplete` is not decoration either. A correct token such as `name`, `email`, `tel` or `new-password` lets a password manager or browser fill the field with the right value instead of guessing. On a phone, `type="email"` puts an `@` on the keyboard; `type="number"` usually shows digits; `type="date"` opens a date control. Choosing the type is part of designing the form, not an afterthought.

> **Under the hood:** Native validation runs before the form is submitted. `required` blocks an empty field, `type="email"` rejects a value without an address shape, and `minlength` or `min`/`max` enforce limits. The browser shows its own message and focuses the first invalid field. That is a useful baseline, not a replacement for clear help text.

## Challenge: a newsletter signup that works

Build a signup form with class `signup`. It needs a visible label that reads `Email address`, an email input with `name="email"`, `autocomplete="email"` and `required`, and a submit button that reads `Subscribe`.

The label must be connected to the input: clicking the label should focus the field.

```html exercise id=forms-newsletter title="Build a newsletter signup"
<form class="signup">
  <h2>Trail notes, once a month</h2>
  <p>Route ideas, new coffees and no spam.</p>
  <!-- TODO: add a label, an email input and a submit button -->
</form>
--- solution
<form class="signup">
  <h2>Trail notes, once a month</h2>
  <p>Route ideas, new coffees and no spam.</p>

  <label for="signup-email">Email address</label>
  <input id="signup-email" name="email" type="email" autocomplete="email" required>

  <button type="submit">Subscribe</button>
</form>
--- test
assertExists("form.signup", "Keep the form with class signup");
assertCount("form.signup input", 1, "The signup form needs exactly one input: the email field");
const label = query("form.signup label");
const input = query("form.signup input");
assertText("form.signup label", "Email address", "The visible label should read: Email address");
assertAttr("form.signup input", "type", "email", "Use type=\"email\" so phones show the right keyboard");
assertAttr("form.signup input", "name", "email", "Give the input name=\"email\" so the server receives a useful key");
assertAttr("form.signup input", "autocomplete", "email", "autocomplete=\"email\" lets the browser fill the field correctly");
assert(input.hasAttribute("required"), "The email field should be required");
assert(input.id, "Give the email input an id so the label can point at it");
assert(label.getAttribute("for") === input.id, "The label''s for attribute must match the input''s id");
assertCount("form.signup button", 1, "Add one submit button");
assertAttr("form.signup button", "type", "submit", "The button should explicitly submit the form");
assertText("form.signup button", "Subscribe", "The button should read: Subscribe");
label.click();
assert(document.activeElement === input, "Clicking the label should focus the email input. Check that for and id match.");
--- hint
Start with `<label for="signup-email">Email address</label>` and give the input `id="signup-email"`.
--- hint
The input needs `type="email"`, `name="email"`, `autocomplete="email"` and the `required` attribute.
--- hint
Finish with `<button type="submit">Subscribe</button>` inside the form.
```

## Buttons have a default job

A `<button>` inside a form is a submit button unless you say otherwise. That default is useful for the main action and dangerous for every secondary one. A "Clear", "Add another address" or "Show password" button without `type="button"` will submit the form, often navigating away or wiping the values the visitor just typed.

```html run
<form>
  <label for="coupon">Coupon code</label>
  <input id="coupon" name="coupon" type="text" autocomplete="off">

  <div class="actions">
    <button type="submit">Apply and continue</button>
    <button type="button" class="secondary">Clear</button>
  </div>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 24rem; }
  label { display: block; margin-bottom: 0.4rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.65rem 0.75rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  .actions { display: flex; gap: 0.6rem; margin-top: 1rem; }
  button { padding: 0.65rem 0.9rem; border: 1px solid #0f766e; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  .secondary { background: white; color: #0f766e; }
</style>
```

`type="submit"` is the main action: it validates the form and sends it. `type="button"` is an inert button for an action you will wire up later with JavaScript — clear a field, reveal a password, add another row. It does nothing by itself, which is exactly why it is safe. You can also use `<input type="submit" value="Subscribe">`, but `<button>` is more flexible because it can contain markup — and a `<button>` still defaults to `submit` when you omit the type.

> **Pitfall:** The default is easy to forget because the markup looks identical. If a button is not the form''s main action, write `type="button"` even if you have not added JavaScript yet. The attribute documents the intent.

## Group related controls

Radios are a single choice from a small set. Checkboxes are independent choices. Both need a shared `name` to be grouped, but radios with the same name can only have one selection, while checkboxes with the same name send multiple values. A `fieldset` with a `legend` gives the group a visible, announced label.

```html run
<form>
  <fieldset>
    <legend>Grind size</legend>
    <label><input type="radio" name="grind" value="whole" checked> Whole bean</label>
    <label><input type="radio" name="grind" value="filter"> Filter</label>
    <label><input type="radio" name="grind" value="espresso"> Espresso</label>
  </fieldset>

  <fieldset>
    <legend>Extras</legend>
    <label><input type="checkbox" name="extras" value="decaf"> Decaf</label>
    <label><input type="checkbox" name="extras" value="mug"> Reusable mug</label>
  </fieldset>

  <label for="brew">Brew method</label>
  <select id="brew" name="brew">
    <option>Pour-over</option>
    <option>French press</option>
    <option>Espresso</option>
  </select>

  <label for="notes">Delivery notes</label>
  <textarea id="notes" name="notes" rows="3"></textarea>

  <button type="submit">Place order</button>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 26rem; }
  fieldset { margin: 0 0 1.25rem; padding: 0.8rem 1rem; border: 1px solid #cbd5e1; border-radius: 10px; }
  legend { padding: 0 0.35rem; font-weight: 700; }
  fieldset label { display: block; margin: 0.35rem 0; }
  select, textarea { width: 100%; box-sizing: border-box; padding: 0.6rem 0.7rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  button { margin-top: 1rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
</style>
```

There are two ways to label a radio or checkbox. The compact one wraps the input in the label, so the text and the control are one clickable unit. The explicit one uses a separate `<label for="...">` and an `id` on the input. Both work; pick one and stay consistent within a form. Keep the legend short — it is the group''s name, not a place for a paragraph of instructions. Put longer guidance just below the legend or connect it to the group with `aria-describedby`.

`<select>` is for a longer, known list of options and takes a label like any other control. `<textarea>` is for multi-line text. Neither needs a `placeholder` to be usable; both need a visible label.

## Challenge: a radio group inside a fieldset

The starter has three grind options, but they are loose in the form. Wrap them in a single `fieldset` with a `legend` that reads `Grind size`. Keep the existing labels connected, and keep all three radios in the same group.

```html exercise id=forms-grind-group title="Group the grind options"
<form class="grind-form">
  <h2>Choose your grind</h2>

  <input type="radio" id="whole" name="grind" value="whole">
  <label for="whole">Whole bean</label>

  <input type="radio" id="filter" name="grind" value="filter">
  <label for="filter">Filter</label>

  <input type="radio" id="espresso" name="grind" value="espresso">
  <label for="espresso">Espresso</label>

  <button type="submit">Save</button>
</form>
--- solution
<form class="grind-form">
  <h2>Choose your grind</h2>

  <fieldset>
    <legend>Grind size</legend>

    <input type="radio" id="whole" name="grind" value="whole">
    <label for="whole">Whole bean</label>

    <input type="radio" id="filter" name="grind" value="filter">
    <label for="filter">Filter</label>

    <input type="radio" id="espresso" name="grind" value="espresso">
    <label for="espresso">Espresso</label>
  </fieldset>

  <button type="submit">Save</button>
</form>
--- test
assertCount("form.grind-form fieldset", 1, "Wrap the radio group in exactly one fieldset");
const fieldset = query("form.grind-form fieldset");
const legend = query("form.grind-form fieldset legend");
assertText("form.grind-form fieldset legend", "Grind size", "The legend should read: Grind size");
assert(legend === fieldset.firstElementChild, "The legend should be the first element inside the fieldset");
assertCount("form.grind-form fieldset input[type=''radio'']", 3, "All three radio inputs belong inside the fieldset");
const radios = Array.from(document.querySelectorAll("form.grind-form fieldset input[type=''radio'']"));
const groupName = radios[0].name;
assert(groupName && radios.every((radio) => radio.name === groupName), "All three radios need the same non-empty name so only one can be chosen");
assert(radios.every((radio) => document.querySelector(''label[for="'' + radio.id + ''"]'')), "Keep a label connected to every radio input");
assertCount("form.grind-form input[type=''radio'']", 3, "Do not leave a radio outside the fieldset");
--- hint
`fieldset` wraps the whole group; `legend` is its first child and names the group.
--- hint
Move the three input/label pairs inside the fieldset, leaving the heading and the submit button outside.
--- hint
The legend text must be exactly `Grind size`, and the radios keep `name="grind"`.
```

## Validation and error text people can understand

Native validation catches the obvious cases. Good forms go further: they explain what is wrong, where it is wrong, and how to fix it. `aria-describedby` connects a field to one or more pieces of helper text; `aria-invalid="true"` marks the field as currently invalid. The error is not just red — it is text, and the field points at it.

```html run
<form>
  <label for="receipt-email">Email for the receipt</label>
  <input id="receipt-email" name="email" type="email" autocomplete="email" required aria-describedby="email-help email-error" aria-invalid="true">
  <p id="email-help" class="hint">We send one receipt. No marketing.</p>
  <p id="email-error" class="error">That address needs an @ and a domain.</p>

  <label for="gift-note">Gift note <span class="optional">(optional)</span></label>
  <textarea id="gift-note" name="note" rows="2" maxlength="120"></textarea>

  <button type="submit">Pay £18</button>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 26rem; }
  label { display: block; margin: 0.9rem 0 0.35rem; font-weight: 600; font-size: 0.9rem; }
  input, textarea { width: 100%; box-sizing: border-box; padding: 0.65rem 0.75rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  .hint { margin: 0.4rem 0 0; color: #64748b; font-size: 0.85rem; }
  .error { margin: 0.25rem 0 0; color: #b91c1c; font-size: 0.85rem; font-weight: 600; }
  .optional { color: #64748b; font-weight: 400; }
  button { margin-top: 1.1rem; padding: 0.7rem 1rem; border: 0; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  input:focus-visible, textarea:focus-visible, button:focus-visible { outline: 3px solid #0f766e; outline-offset: 2px; }
</style>
```

The field''s accessible description is now "We send one receipt. No marketing. That address needs an @ and a domain." That is a lot to hear on every focus, so keep the static hint short and only add the error when it is relevant. In a real form, JavaScript would add `aria-invalid` and unhide the error after validation; the markup contract stays the same. Since this course does not use scripts yet, the demo shows the error state directly.

`aria-describedby` is not a substitute for a label. The label names the field; the description adds detail. If the only text near an input is an error message, the field still has no name. Use a visible `<label>` first, then connect the hint or error. Native validation is also deliberately conservative: it can catch a missing required value or an obviously malformed email, but it cannot know that a date is fully booked or a coupon has expired. Let the browser handle the cheap checks and write your own messages for the rules it cannot see.

`:focus-visible` is the browser''s way of saying "this focus should be obvious." It matches keyboard focus, not every mouse click. Style it with a clear outline and an offset so the ring does not disappear into the border. Never remove an outline without providing an equally visible replacement.

> **In the wild:** Well-designed checkout forms put the label above the field, keep help text close, and place the error directly under the control it belongs to. The visual order and the DOM order should agree, because keyboard and screen-reader users move through the page in DOM order, not in the order that looks nicest.

## Debug: the label that points at nothing

This delivery form has two bugs. The Email label points at an id that does not exist, so clicking it does nothing. The "Add another address" button has no `type`, so inside the form it defaults to `submit` and sends the details instead of adding a row.

Fix both. You can either change the label''s `for` or the input''s `id`; make them match exactly.

```html debug id=forms-broken-label title="The label that points at nothing"
<form class="profile-form">
  <h2>Delivery details</h2>

  <label for="email">Email</label>
  <input id="contact-email" name="email" type="email" autocomplete="email" required>

  <label for="phone">Phone</label>
  <input id="phone" name="phone" type="tel" autocomplete="tel">

  <div class="actions">
    <button class="save">Save details</button>
    <button class="add">Add another address</button>
  </div>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 26rem; }
  label { display: block; margin: 0.9rem 0 0.35rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.65rem 0.75rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  .actions { display: flex; gap: 0.6rem; margin-top: 1rem; }
  button { padding: 0.65rem 0.9rem; border: 1px solid #0f766e; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  .add { background: white; color: #0f766e; }
</style>
--- solution
<form class="profile-form">
  <h2>Delivery details</h2>

  <label for="email">Email</label>
  <input id="email" name="email" type="email" autocomplete="email" required>

  <label for="phone">Phone</label>
  <input id="phone" name="phone" type="tel" autocomplete="tel">

  <div class="actions">
    <button class="save" type="submit">Save details</button>
    <button class="add" type="button">Add another address</button>
  </div>
</form>

<style>
  body { margin: 2rem; font-family: system-ui, sans-serif; color: #1e293b; }
  form { max-width: 26rem; }
  label { display: block; margin: 0.9rem 0 0.35rem; font-weight: 600; font-size: 0.9rem; }
  input { width: 100%; box-sizing: border-box; padding: 0.65rem 0.75rem; border: 1px solid #94a3b8; border-radius: 8px; font: inherit; }
  .actions { display: flex; gap: 0.6rem; margin-top: 1rem; }
  button { padding: 0.65rem 0.9rem; border: 1px solid #0f766e; border-radius: 8px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  .add { background: white; color: #0f766e; }
</style>
--- test
const label = query("form.profile-form label");
const input = query("input[name=''email'']");
assert(input.id, "The email input needs an id");
assert(label.htmlFor === input.id, "The Email label still points at an id that does not exist");
assert(label.control === input, "The label is not connected to the email input. Make for and id match.");
label.click();
assert(document.activeElement === input, "Clicking the Email label did not focus the email field. Make for and id match.");
const add = query("button.add");
assert(add.getAttribute("type") === "button", "The ''Add another address'' button is still a submit button. Give it type=\"button\" so it cannot send the form.");
assertText("button.add", "Add another address", "Keep the secondary button''s visible text");
--- hint
Open the page and click the Email label. Nothing happens, because `for="email"` has no matching `id`.
--- hint
The secondary button needs `type="button"`; without a type, a button inside a form submits it.
--- hint
Make the email input `id="email"` (or change the label to `for="contact-email"`), then add `type="button"` to the add button.
```

## Recap

- A form groups controls; `action` and `method` decide where and how the data is sent.
- Every control needs a visible label. `for` on the label must match `id` on the control; `name` is the key the server receives.
- Placeholders are hints, not labels. They disappear and are not a reliable accessible name.
- Input `type` changes the keyboard, validation and assistive description; `autocomplete` helps browsers and password managers.
- A `<button>` inside a form defaults to `submit`. Use `type="button"` for secondary actions.
- `fieldset` and `legend` group related radios or checkboxes; a shared `name` makes radios mutually exclusive.
- `required`, `minlength`, `min`/`max` and `type="email"` give a useful validation baseline.
- Connect error text with `aria-describedby`, mark the invalid state with `aria-invalid`, and keep a visible `:focus-visible` ring.

**Up next:** accessibility as a whole-page habit — landmarks, heading order, link text, images and the small ARIA additions that fill genuine gaps instead of papering over broken HTML.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_3_2', 'sec_html_css_basics_3', 'crs_html_css_basics', 'Accessible HTML: the defaults that make a page usable by everyone', 'interactive', 1, 1200, NULL, NULL, 'Accessibility is often described as a set of extra features: a skip link here, an ARIA label there, a contrast check before launch. In practice, most of it comes from using the elements you already have, correctly. A real `<button>` is keyboard-operable before you write a line of JavaScript. A proper heading order gives a screen reader a table of contents for free. A `<label>` connected to the right input is the difference between a form that works with a screen reader and one that reads like an unlabelled box.

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
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''360''%3E%3Crect width=''640'' height=''360'' fill=''%23ecfdf5''/%3E%3Cpath d=''M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260'' fill=''%230f766e''/%3E%3Cpath d=''M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260'' fill=''%23134e4a''/%3E%3Cpath d=''M280 240 L360 240 L345 330 L295 330 Z'' fill=''%23c2410c''/%3E%3C/svg%3E" alt="A fern with two green fronds in a terracotta pot" width="640" height="360">
  <figcaption>Two fronds, halfway through their first spring.</figcaption>
</figure>

<p>Our winter notes are below the divider.</p>
<img class="divider" src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''8''%3E%3Crect width=''640'' height=''8'' fill=''%23cbd5e1''/%3E%3C/svg%3E" alt="">

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

The breadcrumb nav has an `aria-label` because "Breadcrumb" is a useful name for that region. The icon button''s visible content is a multiplication sign, which is meaningless as a name, so `aria-label="Close the basket"` supplies one; the `×` is decorative and hidden from assistive technology. The postcode input uses a real `<label for="postcode">`, so it has a name; `aria-describedby` then adds the delivery hint as extra context. A placeholder or a nearby paragraph would not give the field a name on its own. None of these are hacks around missing HTML; they are additions for cases HTML cannot express on its own.

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

The pale text is not a style choice you should copy; it is there so you can see the difference. The dark link and the dark paragraph pass comfortably. The focus ring is deliberately thick and offset so it does not disappear into the button''s edge. `:focus-visible` is the right default for interactive elements: it shows the ring for keyboard users and usually hides it for mouse clicks, which keeps the design calm without taking the keyboard cue away.

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
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''360''%3E%3Crect width=''640'' height=''360'' fill=''%23ecfdf5''/%3E%3Cpath d=''M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260'' fill=''%230f766e''/%3E%3Cpath d=''M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260'' fill=''%23134e4a''/%3E%3Cpath d=''M280 240 L360 240 L345 330 L295 330 Z'' fill=''%23c2410c''/%3E%3C/svg%3E" alt="image" width="640" height="360">
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
  <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''640'' height=''360''%3E%3Crect width=''640'' height=''360'' fill=''%23ecfdf5''/%3E%3Cpath d=''M320 250 C280 160 220 120 160 110 C220 180 250 230 300 260'' fill=''%230f766e''/%3E%3Cpath d=''M320 250 C360 150 420 120 480 110 C420 180 390 230 340 260'' fill=''%23134e4a''/%3E%3Cpath d=''M280 240 L360 240 L345 330 L295 330 Z'' fill=''%23c2410c''/%3E%3C/svg%3E" alt="A fern with two green fronds in a terracotta pot" width="640" height="360">
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
assert(!/^image\b/i.test(alt), "The alt text should not start with ''image''. Describe the content instead");
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
assert(ratio >= 4.5, "The ''Read more'' link has a contrast ratio of " + ratio.toFixed(1) + ":1 against the page. Normal text needs at least 4.5:1");
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
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_3_3', 'sec_html_css_basics_3', 'crs_html_css_basics', 'Checkpoint: forms & accessibility', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"How do you associate a `<label>` with an input?","options":["Give the label and input the same `name` attribute","Set the label''s `for` attribute to the input''s `id`","Put the label after the input and add `aria-hidden`","Set the input''s `type` to `label`"],"answerIndex":1,"explanation":"The label''s `for` value must match the input''s `id`. That association lets a click or tap on the label focus the input, and it gives assistive technology the input''s accessible name. `name` is for the submitted form data, not label association."},{"id":"q2","prompt":"Why is a placeholder not a replacement for a visible label?","options":["Placeholders are not supported in modern browsers","The placeholder disappears as soon as the user types, and its contrast is often poor","A placeholder cannot contain text","A placeholder prevents the form from submitting"],"answerIndex":1,"explanation":"A placeholder is a hint, not a label. It vanishes once the field has content, leaving the user to remember what the field was for, and its default contrast often fails accessibility requirements. Keep a persistent visible label."},{"id":"q3","prompt":"What is the default `type` of a `<button>` inside a form?","options":["`button`","`submit`","`reset`","`link`"],"answerIndex":1,"explanation":"A `<button>` defaults to `type=\"submit\"` inside a form, which can submit unexpectedly when you meant a secondary action. Set `type=\"button\"` for non-submit controls and `type=\"submit\"` for the real submission."},{"id":"q4","prompt":"How do two radio buttons become part of the same group?","options":["They share the same `id`","They share the same `name`","They are wrapped in the same `<label>`","They both have `type=\"radio\"`; that is enough"],"answerIndex":1,"explanation":"Radio buttons with the same `name` form a group where selecting one clears the others. Each radio still needs its own unique `id` so its label can point at it. `type=\"radio\"` alone does not group them."},{"id":"q5","prompt":"What does `<fieldset>` with a `<legend>` provide?","options":["A visual border and nothing else","A group for related controls with an accessible group name","A way to submit multiple forms at once","A replacement for every label"],"answerIndex":1,"explanation":"`<fieldset>` groups related form controls, and the first `<legend>` names the group. Screen readers announce the legend when users enter the group, which is especially valuable for radio and checkbox sets. It is semantic, not just decorative."},{"id":"q6","prompt":"What does the `required` attribute do?","options":["It makes the field read-only","It tells the browser the field must have a value before the form can be submitted","It changes the field''s type to email","It styles the label with an asterisk automatically"],"answerIndex":1,"explanation":"`required` enables native constraint validation: the browser blocks submission and shows a validation message when the field is empty. It does not replace server-side validation, and it does not add an asterisk for you."},{"id":"q7","prompt":"Which link text is the most accessible?","options":["`<a href=\"/pricing\">Click here</a>`","`<a href=\"/pricing\">Read more</a>`","`<a href=\"/pricing\">See pricing and plans</a>`","`<a href=\"/pricing\">Link</a>`"],"answerIndex":2,"explanation":"Screen-reader users often navigate by a list of links, where every \"click here\" sounds identical. The link text should describe the destination. \"See pricing and plans\" stands on its own even out of context."},{"id":"q8","prompt":"Why prefer `<button>` over a clickable `<div>`?","options":["A button is always faster to render","A button is focusable, keyboard-operable and announced correctly without extra code","A div cannot be styled","A button is the only element that can have a click handler"],"answerIndex":1,"explanation":"Native `<button>` gives you keyboard activation with Enter and Space, focus behaviour, disabled semantics and the correct role in the accessibility tree. A clickable div needs all of that reimplemented, and is usually broken for keyboard and screen-reader users."},{"id":"q9","prompt":"What is a skip link?","options":["A link that removes the page''s styles","A link near the start of the document that jumps keyboard users past repeated navigation to the main content","A link that skips the checkout step","A hidden link used only by search engines"],"answerIndex":1,"explanation":"A skip link is usually the first focusable element on the page and points to `#main` or similar. It lets keyboard and screen-reader users bypass a long navigation bar on every page. It should become visible when focused."},{"id":"q10","prompt":"Two colors have a contrast ratio of 3.2:1 for normal-sized body text. How does that compare with WCAG AA?","options":["It passes AA, which requires 3:1 for all text","It fails AA, which requires 4.5:1 for normal text","It passes only if the text is bold","Contrast ratios only apply to buttons"],"answerIndex":1,"explanation":"WCAG AA requires at least 4.5:1 for normal text and 3:1 for large text (roughly 18.66px bold or 24px regular). At 3.2:1, normal body text fails. Larger text at that ratio may pass, but check the actual size and weight."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_4_1', 'sec_html_css_basics_4', 'crs_html_css_basics', 'Your first stylesheet: selectors, colors and the cascade', 'interactive', 0, 1200, NULL, NULL, 'A page with no CSS is not neutral. The browser is making hundreds of decisions on your behalf: Times New Roman, 16px text, blue links, eight pixels of margin around the body. Those defaults were useful in 1995. They are not a design.

This is the handover. You will write your first rules, target the right elements, choose colors that hold together, and understand the cascade — the set of rules that decides which declaration wins when two of them disagree. The cascade is the part beginners skip and then spend years fighting.

## A stylesheet is a list of rules

A CSS rule has two parts. The **selector** says which elements the rule is about. The **declaration block** says what to do to them. Inside the block, each line is a **declaration**: a property, a colon, a value, and a semicolon.

```html run
<h1>Trailhead Coffee</h1>
<p class="lede">Small-batch coffee for people who walk up hills.</p>
<p>Open Tuesday to Saturday, 8am until the beans run out.</p>

<style>
  h1 {
    color: #0f172a;
    font-family: Georgia, serif;
  }

  .lede {
    color: #0f766e;
    font-size: 1.125rem;
  }

  p {
    line-height: 1.6;
  }
</style>
```

The `h1` selector is an **element selector**: every `h1` on the page gets those declarations. `.lede` is a **class selector**: it matches any element with `class="lede"`. The dot is part of the selector syntax, not part of the class name in the HTML.

Most stylesheets live in a `<style>` element in the document''s `<head>`. In these lessons the style element can sit beside the markup so you can see both at once. The browser reads the whole document first, then paints, so the order of the `<style>` element and the markup does not matter. The order of rules *inside* the stylesheet does.

There is a third place to put CSS: the `style` attribute directly on an element.

```html
<p style="color: #b91c1c;">This paragraph carries its own color.</p>
```

That is an **inline style**. It applies to one element only and cannot be reused. Inline styles also sit very high in the cascade, which makes them hard to override later. Avoid them in normal page work. They survive in HTML email, where stylesheets are unreliable, and in quick experiments where you intend to throw the result away.

> **Tip:** A declaration missing its semicolon can swallow the next property. If a rule seems to ignore one line, check the line above it first.

## Element, class and id selectors

Three selectors cover most of the CSS you will write.

```html run
<p>A plain paragraph with the browser''s default look.</p>
<p class="note">A note with a warm background.</p>
<p class="note" id="urgent">The same note, marked urgent.</p>

<style>
  p {
    color: #334155;
    line-height: 1.55;
  }

  .note {
    padding: 8px 12px;
    background: #fef3c7;
  }

  #urgent {
    border-left: 4px solid #b45309;
  }
</style>
```

An **element selector** (`p`) is broad. Useful for a baseline, dangerous when it is the only tool you use: every paragraph on the site inherits the decision.

A **class selector** (`.note`) is reusable. The same class can appear on ten elements, and the style stays consistent. This is the workhorse of CSS. Name classes for meaning — `.note`, `.card`, `.price` — not for appearance like `.yellow-box`, because the appearance will change and the name will become a lie.

An **id selector** (`#urgent`) matches one element with that `id`. Ids are unique in a valid document, and they are also used for in-page links and JavaScript hooks. They work in CSS, but they carry a lot of weight in the cascade. Prefer a class for styling, and keep ids for anchors and behaviour.

> **Pitfall:** Class and id names are case-sensitive in HTML. `.Card` does not match `class="card"`. Tag names are not: `P` and `p` select the same element. This asymmetry causes more silent bugs than almost anything else in this lesson.

## Grouping and descendant selectors

Two pieces of selector syntax save a lot of repetition.

```html run
<nav class="menu">
  <a href="#coffee">Coffee</a>
  <a href="#brew">Brew guides</a>
  <a href="#visit">Visit</a>
</nav>

<h2>This week at the bar</h2>
<p>We are pouring a washed Ethiopian and a very sticky natural from Brazil.</p>

<style>
  h1, h2 {
    font-family: Georgia, serif;
    letter-spacing: -0.02em;
  }

  .menu {
    padding: 12px 0;
    border-bottom: 1px solid #e2e8f0;
  }

  .menu a {
    margin-right: 16px;
    color: #0f766e;
    font-weight: 600;
    text-decoration: none;
  }

  .menu a:hover {
    text-decoration: underline;
  }
</style>
```

The comma in `h1, h2` **groups** selectors. Both headings receive the same declarations. Grouping is not inheritance; it is simply a shorthand for writing the same block twice.

A space is a **descendant combinator**. `.menu a` means "every `a` that is somewhere inside an element with class `menu`". It does not require the link to be a direct child. If you need that stricter relationship, use `>`: `.menu > a`. Descendant selectors keep styles scoped, so a link in the footer does not accidentally pick up the navigation style.

`.menu a:hover` adds a **pseudo-class**. `:hover` matches while the pointer is over the element. There are pseudo-classes for focus, visited links, first children, invalid form fields and more. They are still selectors, and they still obey the cascade.

## Challenge: a card with a hover state

Build a card that uses the class selector, not the element selector. The card needs `24px` of padding, a `1px` border, a `16px` border radius and a `#f8fafc` background. On hover, its background should become `#e2e8f0`.

```html exercise id=card-hover title="Style a card and its hover state"
<article class="card">
  <p class="eyebrow">Field note</p>
  <h2>Grind size is a dial, not a rule</h2>
  <p>Start coarse, adjust fine, and taste the difference before you change anything else.</p>
</article>

<style>
  /* TODO: style .card, then give .card:hover a darker background */
</style>
--- solution
<article class="card">
  <p class="eyebrow">Field note</p>
  <h2>Grind size is a dial, not a rule</h2>
  <p>Start coarse, adjust fine, and taste the difference before you change anything else.</p>
</article>

<style>
  .card {
    max-width: 26rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #f8fafc;
  }

  .card:hover {
    background: #e2e8f0;
  }

  .eyebrow {
    margin: 0 0 4px;
    color: #b45309;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  .card h2 {
    margin: 0 0 8px;
    color: #0f172a;
    font-size: 1.25rem;
  }

  .card p {
    margin: 0;
    color: #475569;
    line-height: 1.55;
  }
</style>
--- test
assertExists(".card", "Add an element with class card so the selector has something to match.");
assertStyle(".card", "padding", "24px", "The card''s padding is not 24px yet. Padding goes inside the card, around its content.");
assertStyle(".card", "border-radius", "16px", "Round the card''s corners with border-radius: 16px.");
assertColor(".card", "background-color", "#f8fafc", "The card background should be #f8fafc at rest.");
const hoverRules = [];
for (const sheet of document.styleSheets) {
  for (const rule of sheet.cssRules) {
    if (rule.selectorText && /\.card:hover/.test(rule.selectorText)) hoverRules.push(rule);
  }
}
assert(hoverRules.length > 0, "Add a .card:hover rule. The card needs a different background while the pointer is over it.");
const hover = hoverRules[0];
const hoverBackground = hover.style.backgroundColor || hover.style.background;
assert(hoverBackground, "The .card:hover rule should set a background color.");
const probe = document.createElement("span");
probe.style.color = hoverBackground;
document.body.appendChild(probe);
const resolved = getComputedStyle(probe).color;
probe.remove();
assert(resolved === "rgb(226, 232, 240)", `The hover background resolves to ${resolved}. Use #e2e8f0 so the change is visible but still calm.`);
--- hint
Start with one rule for `.card`. Put padding, border, border-radius and background inside the same declaration block.
--- hint
A hover state is a separate rule: `.card:hover { background: #e2e8f0; }`. It does not go inside the first block.
--- hint
The class in the HTML is `card`, lowercase, and the selector must be `.card` with a dot. Check both spellings before changing anything else.
```

## Declarations, colors and text

CSS has a property for almost everything you can see. `color` sets text color. `background-color` sets the area behind the text. They are different properties, and only one of them inherits by default.

Colors can be written in several notations, and the browser treats equivalent values identically.

```html run
<div class="swatches">
  <div class="swatch named">tomato</div>
  <div class="swatch hex">#0f766e</div>
  <div class="swatch rgb">rgb(180, 83, 9)</div>
  <div class="swatch hsl">hsl(199 89% 48%)</div>
</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .swatch {
    display: inline-block;
    margin: 4px;
    padding: 16px 20px;
    border-radius: 8px;
    color: white;
    font-weight: 600;
  }

  .named { background-color: tomato; }
  .hex { background-color: #0f766e; }
  .rgb { background-color: rgb(180, 83, 9); }
  .hsl { background-color: hsl(199 89% 48%); }
</style>
```

- **Named colors** (`tomato`, `rebeccapurple`, `teal`) are readable and fine for demos. There are only 148 of them, so a real palette quickly runs out.
- **Hex** (`#0f766e`) is compact and everywhere. The six digits are pairs for red, green and blue. A shorter form like `#fff` expands to `#ffffff`.
- **`rgb()`** takes three channels from 0 to 255. It is easier to reason about when you are adjusting one channel at a time.
- **`hsl()`** takes hue in degrees, saturation and lightness as percentages. It is the best notation for building a palette: keep the hue, then vary lightness for hover states and muted text.

Opacity is a separate channel. `rgb(15 118 110 / 0.5)` and `#0f766e80` both produce a half-transparent teal. Use transparency when you genuinely need to see through a color; otherwise pick a solid color so contrast stays predictable.

`font-family` takes a list, not a single font. The browser uses the first one it can find. The final item should be a **generic family** — `serif`, `sans-serif` or `monospace` — so the page still has a sensible voice if the named fonts are missing.

## Inheritance: some properties flow down the tree

If you set `color` on a parent, its children usually inherit it. That is why you can set a text color once on `body` and have the whole page follow. `font-family`, `font-size` and `line-height` inherit too. `background-color`, `border`, `padding` and `margin` do not.

```html run
<article class="note">
  <h2>The inherited voice</h2>
  <p>This paragraph inherits the article''s color and font. A <strong>strong phrase</strong> can still override the color, and this <a href="#source">link</a> asks to inherit it too.</p>
</article>

<style>
  body {
    margin: 0;
    padding: 24px;
    background: #f1f5f9;
  }

  .note {
    max-width: 34rem;
    padding: 20px;
    background: white;
    color: #334155;
    font-family: Georgia, serif;
  }

  .note strong {
    color: #b45309;
  }

  .note a {
    color: inherit;
  }
</style>
```

Inheritance only applies when the child has no declaration of its own. The `strong` rule sets a color directly, so it wins over the inherited one. The link is a special case: the browser''s default stylesheet already gives links a color, so without `color: inherit` the link would stay blue. Setting `color: inherit` explicitly tells the link to take its parent''s color.

> **Under the hood:** The browser has a default stylesheet called the **user agent stylesheet**. It is where heading sizes, list indentation, link colors and the body''s 8px margin come from. Your stylesheet is an **author stylesheet**, and author declarations beat browser defaults at the same importance level. That is why one `body { margin: 0; }` is enough to remove the default gap.

## The cascade: which rule wins

When two declarations set the same property on the same element, the browser resolves the conflict with the cascade. For beginner CSS, three questions are enough:

1. **Is one declaration from a more specific selector?** Specificity beats source order.
2. **If specificity is equal, which rule comes later?** The later rule wins.
3. **Did either declaration use `!important`?** That changes the answer, and usually for the worse.

```html run
<p class="notice">The beans arrive on Thursday.</p>

<style>
  p {
    color: #334155;
  }

  .notice {
    color: #b45309;
  }

  .notice {
    color: #0f766e;
  }
</style>
```

All three rules match the paragraph. The element rule loses to the class rule on specificity. The two class rules have equal specificity, so the one written later wins and the text is teal. Delete the last rule and it becomes amber. That is source order doing its job.

Specificity is often summarised as a score:

| Selector | Specificity | Beats |
|---|---|---|
| `p` | 0-0-1 | browser defaults only |
| `.notice` | 0-1-0 | any number of element selectors |
| `#urgent` | 1-0-0 | any number of classes |
| `style="…"` | inline | author stylesheets |
| `color: red !important` | important | normal declarations |

The numbers are not a point total. One id always beats any number of classes; one class always beats any number of elements. `#intro p` beats `.lede` because the id comes first in the comparison, even though the class selector looks more specific to a human.

> **Pitfall:** `!important` does not mean "this is the most important rule in the design". It means "skip the normal cascade". It makes the next change harder, can override a user''s accessibility settings, and usually hides a selector problem that will come back. Use it as a last resort, not as a way to win an argument with your own stylesheet.

## Debug: the rule with the wrong case

This card was supposed to have a warm background and generous padding, but it renders plain. The CSS looks correct at a glance. Find the mismatch and fix it.

```html debug id=case-sensitive-card title="The stylesheet that missed the card"
<article class="card">
  <p class="eyebrow">Steam</p>
  <h2>Milk, without the drama</h2>
  <p>Oat, whole or none. All three are welcome, and none of them need a lecture.</p>
</article>

<style>
  .Card {
    padding: 28px;
    border-radius: 12px;
    background: #fff7ed;
  }

  .Card h2 {
    margin: 0 0 8px;
    color: #9a3412;
  }

  .Card p {
    margin: 0;
    color: #57534e;
    line-height: 1.55;
  }
</style>
--- solution
<article class="card">
  <p class="eyebrow">Steam</p>
  <h2>Milk, without the drama</h2>
  <p>Oat, whole or none. All three are welcome, and none of them need a lecture.</p>
</article>

<style>
  .card {
    padding: 28px;
    border-radius: 12px;
    background: #fff7ed;
  }

  .card h2 {
    margin: 0 0 8px;
    color: #9a3412;
  }

  .card p {
    margin: 0;
    color: #57534e;
    line-height: 1.55;
  }
</style>
--- test
assertExists(".card", "Keep the article''s class card so the styles have a target.");
assertColor(".card", "background-color", "#fff7ed", "The card is still transparent. Its selector does not match the class in the HTML.");
assertStyle(".card", "padding", "28px", "The card should have 28px of padding once the selector matches.");
assertColor(".card h2", "color", "#9a3412", "The heading inside the card should be #9a3412.");
--- hint
The HTML says `class="card"` and the CSS says `.Card`. CSS class selectors are case-sensitive.
--- hint
Change every `.Card` selector to `.card`. There are three rules to update.
```

## Debug: the rule that keeps losing

Here the lede paragraph should be dark and slightly larger than body text. It has a class and a rule, but the text stays grey. The problem is not a typo; it is the cascade.

```html debug id=specificity-trap title="The lede that will not go dark"
<section id="intro">
  <p class="lede">A quieter morning, one cup at a time.</p>
  <p>We open at eight. The first batch lands at ten past.</p>
</section>

<style>
  #intro p {
    color: #64748b;
  }

  .lede {
    color: #0f172a;
    font-size: 1.15rem;
    font-weight: 600;
  }
</style>
--- solution
<section id="intro">
  <p class="lede">A quieter morning, one cup at a time.</p>
  <p>We open at eight. The first batch lands at ten past.</p>
</section>

<style>
  #intro p {
    color: #64748b;
  }

  #intro .lede {
    color: #0f172a;
    font-size: 1.15rem;
    font-weight: 600;
  }
</style>
--- test
assertColor(".lede", "color", "#0f172a", "The lede is still grey, so the id rule is winning. Raise the class rule''s specificity or stop targeting the paragraph through the id.");
assertStyle(".lede", "font-size", "18.4px", "Keep the lede at 1.15rem once the color is fixed.");
assertColor("#intro p:not(.lede)", "color", "#64748b", "The second paragraph should stay muted grey.");
--- hint
Compare `#intro p` with `.lede`. Count the selector parts: the first one contains an id. One id beats any number of classes.
--- hint
You can make the class rule more specific by scoping it under the section: `#intro .lede`. That has the id plus a class, so it outranks `#intro p`.
--- hint
Keep both paragraphs in mind. Changing the id rule itself might make the second paragraph dark too.
```

## Predict: which color wins?

Read the stylesheet before you run it. The paragraph has an id, a class, and three competing rules.

```html predict id=which-color-wins title="Which color wins?"
<p id="lead" class="text">One paragraph, four opinions.</p>

<style>
  p {
    color: #64748b;
  }

  .text {
    color: #b45309;
  }

  #lead {
    color: #0f766e;
  }

  .text {
    color: #be123c;
  }
</style>
--- options
* Teal, because the id selector has the highest specificity
Crimson, because the last class rule comes later in the stylesheet
Amber, because a class selector beats an element selector and ids are only for links
Slate, because the p selector applies directly to the paragraph
--- explain
The id selector `#lead` has specificity 1-0-0, which outranks every class selector on the page. The second `.text` rule does come later, but source order only decides between declarations of equal specificity. The paragraph is teal. This is exactly why styling with ids gets painful: the only ways to override that rule are another id, an inline style, or `!important`.
```

## Recap

- A rule is a selector plus a declaration block; each declaration is a property and a value.
- `<style>` keeps CSS with the document; inline `style` is powerful and hard to reuse.
- Element selectors are broad, classes are reusable, ids are unique and heavy in the cascade.
- Group selectors with commas; scope them with descendant spaces or `>`.
- `color` and `font-family` inherit; `background-color`, borders and spacing do not.
- The cascade compares importance, then specificity, then source order. `!important` is a shortcut that makes later work harder.
- Class selectors are case-sensitive in HTML. `.Card` is not `.card`.

**Up next:** the box model — why a 300px card with 24px padding refuses to be 300px wide, and how `box-sizing: border-box` fixes it.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_4_2', 'sec_html_css_basics_4', 'crs_html_css_basics', 'The box model: space, borders and why nothing lines up', 'interactive', 1, 1200, NULL, NULL, 'Here is the bug that teaches the box model. A designer asks for a 300px card. You set `width: 300px`, add `24px` of padding and a `1px` border, and the card renders 350px wide. Nothing is broken. You asked for a 300px *content* box, and the browser politely added the padding and border around it.

Almost every "why does nothing line up?" moment in CSS comes back to this. Once you can see the four nested boxes around every element — content, padding, border, margin — layout stops being guesswork. You stop nudging numbers and start predicting them.

## Four boxes around every element

Every element generates a rectangular box. The box has four layers:

- **Content** is the text, image or child elements. Its size is what `width` and `height` normally control.
- **Padding** is space inside the box, between the content and the border. It takes the element''s background color.
- **Border** is the visible edge. It also takes the background color underneath it, unless the border itself has one.
- **Margin** is space outside the border. It is always transparent and pushes other elements away.

```html run
<div class="stage">
  <div class="box">
    <span>content</span>
  </div>
</div>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
  }

  .stage {
    padding: 40px;
    background: #f1f5f9;
  }

  .box {
    width: 240px;
    margin: 32px auto;
    padding: 24px;
    border: 6px solid #0f766e;
    background: #ccfbf1;
  }

  .box span {
    display: block;
    padding: 8px;
    background: white;
  }
</style>
```

The white area is the content. The pale teal ring is padding. The dark teal edge is the border. The grey band around it is the margin, showing the stage background through transparent space. Change the padding to `0` and the content moves outward; the border stays where it is. Change the margin to `0` and the whole box moves.

Padding and margin are not interchangeable. Padding is part of the element and takes its background. Margin is outside the element and never paints. If you want a card''s text to breathe, use padding. If you want two cards to separate, use margin (or, later, `gap`).

## Width is a promise about the content box

By default, `box-sizing` is `content-box`. That means `width: 300px` makes the *content* 300px. Padding and border are added on top, so the visible box is wider than 300px.

```html run
<div class="card content">content-box</div>
<div class="card border">border-box</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .card {
    width: 200px;
    margin-bottom: 16px;
    padding: 20px;
    border: 5px solid #0f766e;
    background: #ccfbf1;
  }

  .border {
    box-sizing: border-box;
  }
</style>
```

Both rules say `width: 200px`. The first card''s border box is 250px: 200 content + 40 padding + 10 border. The second card''s border box is exactly 200px, because `border-box` includes padding and border in the width. The content area shrinks to 150px instead.

`border-box` is usually the more intuitive model. When you say a card is 300px, you mean the thing you can see and measure. Most modern codebases set it globally:

```css
*, *::before, *::after {
  box-sizing: border-box;
}
```

That one rule prevents an entire category of overflow bugs. It does not include margin: a 300px card with `margin: 24px` still occupies 348px of horizontal space in its parent.

## Check the box, not the number

When a box is wider than expected, resist the urge to change the number until you know which box you are measuring. The border box is the useful measurement: content width plus left and right padding plus left and right border. Margin sits outside it.

A 300px content box with 24px padding and a 1px border has a border box of 300 + 48 + 2 = 350px. Add 16px of margin on each side and it occupies 382px of horizontal space in its parent. The inspector''s box-model overlay shows all four layers in different colours; use it before doing arithmetic in your head.

With `border-box`, the formula changes: the declared width *is* the border box, and the content area absorbs the padding and border. A 300px border-box card with the same padding and border has 250px of content. That is usually the trade you want: the outside stays predictable, and the text area takes the difference.

> **Pitfall:** `box-sizing` affects width and height, not margin. If a row of three 300px cards plus two 24px gaps does not fit a 960px container, border-box will not save you. The margins are still outside the boxes.

## Challenge: a card that stays exactly 300px

Build the card so its **border box** is exactly 300px wide, including `24px` of padding on every side and a `1px` border. Use `border-box`, and give it a `#ffffff` background.

```html exercise id=exact-card-width title="A 300px card that is actually 300px"
<article class="card">
  <h2>Roast schedule</h2>
  <p>Mondays and Thursdays, early enough that the neighbours complain.</p>
</article>

<style>
  .card {
    /* TODO: make the border box exactly 300px, including padding and border */
  }
</style>
--- solution
<article class="card">
  <h2>Roast schedule</h2>
  <p>Mondays and Thursdays, early enough that the neighbours complain.</p>
</article>

<style>
  .card {
    box-sizing: border-box;
    width: 300px;
    padding: 24px;
    border: 1px solid #cbd5e1;
    background: #ffffff;
  }

  .card h2 {
    margin: 0 0 8px;
    font-size: 1.2rem;
  }

  .card p {
    margin: 0;
    color: #475569;
    line-height: 1.55;
  }
</style>
--- test
const card = query(".card");
const rect = card.getBoundingClientRect();
assert(Math.abs(rect.width - 300) <= 1, `The card renders ${Math.round(rect.width)}px wide. Its border box should be exactly 300px, padding and border included.`);
assertStyle(".card", "box-sizing", "border-box", "Set box-sizing: border-box so width includes padding and border.");
assertStyle(".card", "padding", "24px", "The card still needs 24px of padding on every side.");
assertStyle(".card", "border-top-width", "1px", "Give the card a 1px border.");
assertColor(".card", "background-color", "#ffffff", "The card background should be white.");
--- hint
Without help, `width: 300px` plus `24px` padding and a `1px` border produces a 350px box.
--- hint
`box-sizing: border-box` makes the declared width include padding and border. Then 300px really is 300px.
--- hint
Put `box-sizing: border-box; width: 300px;` in the same `.card` rule, then add padding and border as usual.
```

## Centering with auto margins

A block-level element with a width narrower than its container will sit on the left by default. Setting the left and right margins to `auto` splits the leftover space equally and centers it.

```html run
<main class="page">
  <p class="eyebrow">The weekly</p>
  <h1>Notes from the counter</h1>
  <p>This column has a maximum width and automatic side margins. On a wide screen it stays readable. On a narrow one it shrinks.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    box-sizing: border-box;
    max-width: 560px;
    margin: 0 auto;
    padding: 40px 24px;
    background: white;
  }

  .eyebrow {
    margin: 0;
    color: #b45309;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }
</style>
```

`max-width` is better than `width` here. `width: 560px` would force a 560px column even on a 400px phone, causing horizontal scrolling. `max-width` says "grow to 560px, but never wider than the space available". The `margin: 0 auto` does the centering.

Auto margins only center a block-level box that has a definite width smaller than its container. An inline element ignores them. A block with `width: auto` fills the container, so there is no leftover space to divide.

The browser also gives `body` a default margin of 8px. That gap is why a full-bleed header often has a thin strip of background around it. Most stylesheets start with `body { margin: 0; }`; the preview here does exactly that.

```html run
<!doctype html>
<html lang="en">
  <head>
    <style>
      body {
        border: 4px dashed #f59e0b;
        background: #fffbeb;
        font-family: system-ui, sans-serif;
      }

      .inner {
        padding: 16px;
        background: white;
      }
    </style>
  </head>
  <body>
    <div class="inner">
      The dashed line is the body. The gap outside it is the browser''s default 8px margin. Set body margin to 0 and the dashed line meets the edge of the page.
    </div>
  </body>
</html>
```

> **Tip:** When a centered container looks slightly off, inspect the `body`. The default margin is small enough to miss and large enough to matter.

## Challenge: center a readable column

Center the `.page` column with a maximum width of `640px`. Keep `24px` of horizontal padding, and make sure that padding does not make the column wider than 640px. The body already has its margin removed.

```html exercise id=centered-column title="Center a readable column"
<main class="page">
  <h1>Trail notes</h1>
  <p>Three days on the ridge, two wrong turns and one extremely good sandwich.</p>
  <p>The page should sit in the middle of the viewport, with equal space on both sides.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    /* TODO: cap the width at 640px, center it, and keep the padding inside that width */
  }
</style>
--- solution
<main class="page">
  <h1>Trail notes</h1>
  <p>Three days on the ridge, two wrong turns and one extremely good sandwich.</p>
  <p>The page should sit in the middle of the viewport, with equal space on both sides.</p>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f1f5f9;
  }

  .page {
    box-sizing: border-box;
    max-width: 640px;
    margin: 0 auto;
    padding: 48px 24px;
    background: white;
  }
</style>
--- test
assertStyle(".page", "max-width", "640px", "Cap the column with max-width: 640px.");
const page = query(".page");
const rect = page.getBoundingClientRect();
assert(Math.abs(rect.width - 640) <= 1, `The column renders ${Math.round(rect.width)}px wide. With border-box, 640px should include the 24px side padding.`);
const bodyRect = document.body.getBoundingClientRect();
const leftGap = rect.left - bodyRect.left;
const rightGap = bodyRect.right - rect.right;
assert(Math.abs(leftGap - rightGap) <= 2, `The column has ${Math.round(leftGap)}px on the left and ${Math.round(rightGap)}px on the right. Auto side margins should make those equal.`);
assertStyle("body", "margin-left", "0px", "Remove the body''s default margin so the centering is measured against the viewport.");
--- hint
`max-width` caps the size; `margin: 0 auto` centers the leftover space.
--- hint
If you add horizontal padding without `box-sizing: border-box`, the visible column becomes 688px wide.
--- hint
Use `box-sizing: border-box; max-width: 640px; margin: 0 auto; padding: 48px 24px;` in `.page`.
```

## Display changes the rules

The `display` property decides how a box participates in layout. Three values cover the basics.

```html run
<p>
  Read the <a class="inline" href="#guide">inline note</a>,
  then the <span class="inline-block">inline-block box</span>
  and finally the block below.
</p>

<div class="block">A block box takes its own line.</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: system-ui, sans-serif;
    line-height: 1.8;
  }

  .inline {
    padding: 8px 14px;
    background: #fef3c7;
  }

  .inline-block {
    display: inline-block;
    width: 150px;
    padding: 8px;
    background: #ccfbf1;
    text-align: center;
  }

  .block {
    width: 220px;
    padding: 12px;
    background: #e0f2fe;
  }
</style>
```

A **block** box starts on a new line and fills the available width by default, even if its content is short. Headings, paragraphs, sections and divs are blocks. Width, height, padding and margins all work normally.

An **inline** box flows with the text, like a word. Links, spans, strong and em are inline. Horizontal padding and margins work, but vertical padding paints outside the line box without pushing the lines apart. Setting `width` or `height` on an inline element does nothing.

An **inline-block** box sits in the text flow like an inline element, but accepts width, height, padding and margins like a block. It is useful for small badges and buttons that need real dimensions without starting a new line.

> **Under the hood:** Every element has a default `display` value from the browser''s stylesheet. That is why a `div` stacks and a `span` does not. Your CSS can change the value, but it cannot change the element''s meaning. A `span` styled as a block is still not a heading to a screen reader.

## When content does not fit

A fixed height plus content that is too tall creates overflow. The `overflow` property decides what happens to the excess.

```html run
<div class="window">
  <p>Roasting is mostly listening. First crack sounds like a small, dry snap. Second crack is faster and darker, and by then the sugars are already turning. If you wait too long the roast tastes like the inside of a chimney.</p>
  <p>The useful skill is not memorising times. It is noticing the gap between what you expected and what the beans are doing.</p>
</div>

<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: Georgia, serif;
    background: #f8fafc;
  }

  .window {
    width: 280px;
    height: 110px;
    padding: 12px;
    border: 1px solid #cbd5e1;
    overflow: auto;
    background: white;
  }
</style>
```

`overflow: visible` is the default: the content spills out and can overlap whatever is below. `overflow: hidden` clips the excess, which is occasionally useful for decorative shapes but dangerous for text and focus outlines. `overflow: auto` adds a scrollbar only when the content needs one. `overflow: scroll` always reserves one.

Do not use a fixed height on a text container unless you genuinely want a scrolling region. Let the content define the height, then use `max-height` if you need a ceiling.

## Debug: the card that spills out of its parent

The panel is 600px wide with 24px padding. The card inside is set to `width: 100%`, but it sticks out past the panel''s right edge. Find the box-model mistake and fix it without changing the panel.

```html debug id=padding-overflow title="The card that overflows its parent"
<main class="panel">
  <article class="card">
    <h2>Subscription, sorted</h2>
    <p>Two bags a month, roasted on Monday and posted the same afternoon.</p>
  </article>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .panel {
    width: 600px;
    padding: 24px;
    background: #e2e8f0;
  }

  .card {
    width: 100%;
    padding: 32px;
    border: 2px solid #0f766e;
    background: white;
  }
</style>
--- solution
<main class="panel">
  <article class="card">
    <h2>Subscription, sorted</h2>
    <p>Two bags a month, roasted on Monday and posted the same afternoon.</p>
  </article>
</main>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .panel {
    width: 600px;
    padding: 24px;
    background: #e2e8f0;
  }

  .card {
    box-sizing: border-box;
    width: 100%;
    padding: 32px;
    border: 2px solid #0f766e;
    background: white;
  }
</style>
--- test
const panel = query(".panel");
const card = query(".card");
const panelStyle = getComputedStyle(panel);
const panelRect = panel.getBoundingClientRect();
const contentWidth = panelRect.width - parseFloat(panelStyle.paddingLeft) - parseFloat(panelStyle.paddingRight);
const cardRect = card.getBoundingClientRect();
assert(cardRect.width <= contentWidth + 1, `The card renders ${Math.round(cardRect.width)}px wide inside a ${Math.round(contentWidth)}px content area. Its padding and border are being added on top of width: 100%.`);
assert(cardRect.width >= contentWidth - 1, `The card should still fill the panel''s content width, about ${Math.round(contentWidth)}px.`);
assert(cardRect.right <= panelRect.right - parseFloat(panelStyle.paddingRight) + 1, "The card''s right edge is still past the panel''s content edge. Bring it back inside.");
--- hint
The panel''s content box is 600px wide. The card is 100% of that, then 64px of padding and 4px of border are added.
--- hint
`box-sizing: border-box` makes `width: 100%` include the padding and border, so the card stops at 600px.
--- hint
Add `box-sizing: border-box;` to `.card`. You should not need to change the panel at all.
```

## Margins collapse

Vertical margins behave differently from horizontal ones. When two block siblings meet, their adjacent vertical margins **collapse**: the gap is the larger of the two margins, not the sum.

```html run
<section class="stack">
  <div class="panel first">First panel</div>
  <div class="panel second">Second panel</div>
</section>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
    background: #f8fafc;
  }

  .stack {
    padding: 24px;
    background: #f1f5f9;
  }

  .panel {
    padding: 12px;
    border: 1px solid #cbd5e1;
    background: white;
  }

  .first { margin-bottom: 48px; }
  .second { margin-top: 16px; }
</style>
```

The gap between the panels is 48px, not 64px. The two margins overlap and the bigger one wins. If both were 24px, the gap would be 24px.

Collapsing only happens vertically between block boxes in normal flow. It does not happen horizontally, and it does not happen in flex or grid layouts. Margins can also collapse between a parent and its first or last child when there is no border or padding in between, which is why a heading sometimes pushes its whole container down instead of adding space inside it.

The practical rule: do not stack margins and expect them to add up. Pick one direction — usually `margin-bottom` — or use `gap` when you get to flexbox and grid.

## Predict: how wide is the ticket?

Read the rule carefully. The element has no other width-related styles.

```html predict id=content-box-width title="The content-box ticket"
<div class="ticket">Boarding pass</div>

<style>
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
  }

  .ticket {
    width: 300px;
    padding: 20px;
    border: 5px solid #0f766e;
    background: #ccfbf1;
  }
</style>
--- options
* 350px — width covers only the content, so padding and border are added around it
300px — width always means the full visible box
330px — the padding is included but the border is not
340px — only the horizontal padding on one side is added
--- explain
The default is `box-sizing: content-box`. `width: 300px` sets the content area. Padding adds 20px on each side (40px total), and the border adds 5px on each side (10px total). The border box is 300 + 40 + 10 = 350px. If the rule included `box-sizing: border-box`, the answer would be 300px and the content would shrink to 250px.
```

## Recap

- Every element has a content box, padding, a border and a margin.
- `width` and `height` describe the content box unless you change `box-sizing`.
- `box-sizing: border-box` makes width include padding and border; it does not include margin.
- `margin: 0 auto` centers a block with a definite width; `max-width` keeps it from overflowing small screens.
- Block elements stack and fill; inline elements flow with text; inline-block does both.
- `overflow` controls what happens when content is larger than its box.
- Adjacent vertical margins collapse to the larger value, not the sum.
- The browser gives `body` an 8px margin. Most stylesheets remove it.

**Up next:** typography and color — font stacks, line height, readable measure, contrast, and a palette built from custom properties.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_4_3', 'sec_html_css_basics_4', 'crs_html_css_basics', 'Typography and color: making a page feel designed', 'interactive', 2, 1200, NULL, NULL, 'Two pages can have identical markup and feel completely different. One looks like a document that escaped from a law office; the other looks designed. The difference is rarely a dramatic image or a fancy font. It is a handful of typographic decisions: a typeface with a point of view, a heading that is allowed to be large, body text with room to breathe, a line length that does not exhaust the eye, and a palette with more thought behind it than "black on white".

This lesson is about those decisions. You will learn the properties that set type, how line height actually works, how to measure a readable line, and how to build a small color system with custom properties. None of it requires a design degree. It requires noticing what the browser does by default and choosing something better.

## Start with a font stack

`font-family` takes a list. The browser tries each font from left to right and uses the first one installed on the reader''s machine. The last item should be a generic family, so there is always a sensible fallback.

```html run
<p class="sans">System sans: clear, neutral, at home in an interface.</p>
<p class="serif">Georgia serif: slower, warmer, made for reading.</p>
<p class="mono">Monospace: every character the same width, useful for code.</p>

<style>
  body {
    margin: 0;
    padding: 32px;
    background: #f8fafc;
    color: #1e293b;
  }

  p {
    margin: 0 0 16px;
    font-size: 1.125rem;
    line-height: 1.6;
  }

  .sans {
    font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
  }

  .serif {
    font-family: Georgia, "Times New Roman", serif;
  }

  .mono {
    font-family: ui-monospace, "SF Mono", Menlo, monospace;
  }
</style>
```

`system-ui` resolves to the operating system''s interface font: San Francisco on a Mac, Segoe UI on Windows, Roboto on many Android devices. It loads instantly because it is already there. That is why dashboards and product pages use it so often.

A serif stack like `Georgia, "Times New Roman", serif` is a different voice. Georgia was designed for screens, with a large x-height and sturdy strokes. It remains one of the most reliable reading fonts on the web. The quotes around `"Times New Roman"` are required because the name contains spaces.

A monospace stack is for code, tabular numbers and anything where character width should not change. Do not set a whole article in monospace unless the article is about terminals.

> **Tip:** Fonts are a performance decision. Every custom font is a file the reader must download before the text can render in its final form. The stacks above cost nothing and still look intentional. If you do use a custom font later, self-host it and subset it.

## Size, weight and style

`font-size` sets the size of the text. `rem` is relative to the root font size, which is 16px by default, so `1rem` is 16px and `2.5rem` is 40px. `em` is relative to the current element''s font size, which makes it useful for spacing that should scale with the text but confusing when nested.

`font-weight` sets boldness on a scale from 100 to 900. In practice, 400 is regular, 600 is semibold and 700 is bold. A font only has the weights it ships with; if you ask for 600 and the font has only 400 and 700, the browser may synthesise something in between. `font-style: italic` asks for the italic cut, or slants the regular cut if there is none.

```html run
<h1 class="display">A quieter kind of loud</h1>
<p class="lede">A room, a record and a pot of coffee that is slightly too strong.</p>
<p class="meta">Field notes · 6 minute read</p>

<style>
  body { margin: 0; padding: 40px; background: #fbf7ef; color: #292524; font-family: Georgia, "Times New Roman", serif; }

  .display {
    max-width: 12ch;
    margin: 0 0 20px;
    font-size: 3.5rem;
    font-weight: 700;
    line-height: 1.05;
    letter-spacing: -0.035em;
  }

  .lede {
    max-width: 34rem;
    margin: 0 0 24px;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.55;
    color: #57534e;
  }

  .meta {
    margin: 0;
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: #0f766e;
  }
</style>
```

Three details are doing a lot of work. The heading is large and tightly spaced, because display type at 56px needs less air between lines than body text at 18px. The lede is italic and slightly muted, which separates it from the body without making it smaller. The meta line is small, uppercase, letter-spaced and sans-serif, so it reads as a label rather than a sentence.

That last combination is worth memorising: **small uppercase labels need letter-spacing**. Capital letters are designed to sit next to lowercase letters. When everything is uppercase, the gaps disappear and the line becomes a grey bar. `letter-spacing: 0.08em` to `0.14em` restores the rhythm.

## Line height is vertical rhythm

`line-height` sets the height of a line box. It accepts a length (`24px`), a percentage, or a plain number (`1.5`). The plain number is special: it is a **multiplier** that is recalculated for each element''s font size.

```html run
<p class="unitless">Unitless: the spacing grows with the type. At 24px, a line height of 1.5 gives 36px between baselines.</p>
<p class="fixed">Fixed: the spacing stays at 24px no matter how large the text becomes, so the lines start to crowd.</p>

<style>
  body {
    margin: 0;
    padding: 32px;
    background: #f8fafc;
    font-family: Georgia, serif;
    color: #1e293b;
  }

  p {
    max-width: 32rem;
    font-size: 24px;
  }

  .unitless {
    line-height: 1.5;
  }

  .fixed {
    line-height: 24px;
  }
</style>
```

The unitless paragraph gets 36px line boxes. The fixed paragraph gets 24px line boxes around 24px text — technically readable, but cramped, and it would break completely at 32px.

Use a unitless number for anything that inherits: body copy around `1.5` to `1.7`, headings around `1.05` to `1.25`. A length can be useful for a single component where you need a precise baseline, but it does not adapt when the font size changes.

`line-height` also inherits, and the unitless value inherits as a number, not as a computed length. That means a child with a larger font automatically gets proportionally more line height. This is the main reason the unitless form is the professional default.

> **Pitfall:** `line-height: 1.2` on 16px body text gives 19.2px lines, which is too tight for paragraphs. Save tight leading for headings, where the lines are short and the type is large.

## Challenge: an editorial article

Build a small editorial page. The heading should be a display size of at least `40px`. The body copy should sit in a column roughly 60–70 characters wide, with a line height of at least `1.6`. The quote should be highlighted with a `#f1f5f9` background and a `4px` teal left border.

The starter has the content but no styles.

```html exercise id=editorial-article title="Set an editorial article"
<article class="story">
  <p class="kicker">The long read</p>
  <h1>The case for taking the slow train</h1>
  <p class="standfirst">Six hours, three changes and a window that actually opens.</p>
  <p>The fast train gets there first. The slow train gets there better. That is the entire argument, and it survives contact with reality more often than you would expect.</p>
  <blockquote>You do not see a country properly until you have watched it from a seat that reclines.</blockquote>
  <p>There is a particular kind of attention that only appears when the arrival time stops being the point.</p>
</article>

<style>
  /* TODO: set the type, measure and quote treatment */
</style>
--- solution
<article class="story">
  <p class="kicker">The long read</p>
  <h1>The case for taking the slow train</h1>
  <p class="standfirst">Six hours, three changes and a window that actually opens.</p>
  <p>The fast train gets there first. The slow train gets there better. That is the entire argument, and it survives contact with reality more often than you would expect.</p>
  <blockquote>You do not see a country properly until you have watched it from a seat that reclines.</blockquote>
  <p>There is a particular kind of attention that only appears when the arrival time stops being the point.</p>
</article>

<style>
  body {
    margin: 0;
    background: #fbf7ef;
    color: #292524;
    font-family: Georgia, "Times New Roman", serif;
  }

  .story {
    box-sizing: border-box;
    max-width: 66ch;
    margin: 0 auto;
    padding: 56px 24px;
  }

  .kicker {
    margin: 0 0 8px;
    color: #0f766e;
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
  }

  h1 {
    margin: 0 0 16px;
    font-size: clamp(2.5rem, 6vw, 4rem);
    line-height: 1.05;
    letter-spacing: -0.03em;
  }

  .standfirst {
    margin: 0 0 28px;
    color: #57534e;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.5;
  }

  p {
    margin: 0 0 20px;
    line-height: 1.65;
  }

  blockquote {
    margin: 32px 0;
    padding: 20px 24px;
    border-left: 4px solid #0f766e;
    background: #f1f5f9;
    color: #1f2937;
    font-size: 1.25rem;
    font-style: italic;
    line-height: 1.5;
  }
</style>
--- test
assertExists("h1", "Keep the article''s h1 so there is a display heading to size.");
const heading = getComputedStyle(query("h1"));
assert(parseFloat(heading.fontSize) >= 40, `The heading renders at ${heading.fontSize}. A display heading should be at least 40px.`);
const story = query(".story");
const storyStyle = getComputedStyle(story);
const measure = parseFloat(storyStyle.maxWidth);
assert(Number.isFinite(measure) && measure >= 480 && measure <= 800, `The article measures ${storyStyle.maxWidth} across. Aim for a readable column, roughly 60–70 characters.`);
const bodyParagraph = query(".story p:not(.kicker):not(.standfirst)");
const bodyStyle = getComputedStyle(bodyParagraph);
const bodySize = parseFloat(bodyStyle.fontSize);
const bodyLeading = parseFloat(bodyStyle.lineHeight);
assert(bodyLeading / bodySize >= 1.55, `Body lines are ${(bodyLeading / bodySize).toFixed(2)} times the font size. Give paragraphs at least 1.6.`);
assertColor("blockquote", "background-color", "#f1f5f9", "The pull quote should sit on a #f1f5f9 background.");
assertStyle("blockquote", "border-left-width", "4px", "Give the quote a 4px left border in the teal accent.");
assertNoOverflow("The article should not cause horizontal scrolling.");
--- hint
Start with the page: `body` margin, background and a serif stack. Then cap `.story` with `max-width: 66ch` and center it with `margin: 0 auto`.
--- hint
The heading needs a large `font-size` and a tight `line-height`. Body paragraphs need `line-height: 1.65` or similar.
--- hint
For the quote, combine `background: #f1f5f9`, `border-left: 4px solid #0f766e`, padding and a little margin.
```

## The small controls that finish the type

Four properties handle most of the remaining detail:

- `letter-spacing` adds space between characters. Use a little for uppercase labels, and negative values for large display headings.
- `text-align` sets horizontal alignment. Left is the safe default for body text; centered is for short headings and invitations, not paragraphs; justified text creates uneven gaps on the web because browsers do not hyphenate reliably.
- `text-transform` changes case visually (`uppercase`, `lowercase`, `capitalize`) without changing the underlying text. Be careful: a screen reader may still read the original case, and uppercase words can be spelled out letter by letter in some contexts.
- `text-decoration` controls underlines. If you remove an underline from a link, replace it with another clear signal: weight, color and a visible focus state.

```html run
<article class="story">
  <p class="kicker">Field notes</p>
  <h2>The long way to the coast</h2>
  <p class="intro">A slower route, a heavier pack, and a better view.</p>
  <p>The path leaves the village behind the bakery and climbs through hazel for an hour before it decides to become a path again.</p>
  <p><a href="#route">Read the route notes</a></p>
  <p class="signoff">— from the notebook</p>
</article>

<style>
  body { margin: 0; padding: 32px; background: #fbf7ef; color: #292524; font-family: Georgia, "Times New Roman", serif; }

  .story { max-width: 62ch; }

  .kicker {
    margin: 0 0 8px; color: #0f766e; font-family: system-ui, sans-serif;
    font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase;
  }

  h2 { margin: 0 0 12px; font-size: 2.25rem; line-height: 1.1; letter-spacing: -0.03em; }

  p { margin: 0 0 16px; line-height: 1.65; }

  .intro { color: #57534e; font-size: 1.2rem; font-style: italic; }

  a { color: #0f766e; font-weight: 600; text-decoration-thickness: 2px; text-underline-offset: 3px; }

  .signoff { text-align: right; font-style: italic; color: #78716c; }
</style>
```

The `max-width: 62ch` is the key line. `ch` is the width of the "0" character in the current font, so `62ch` is roughly 62 characters. For a serif body face, 60–70ch is a comfortable measure. At 1100px wide, this column stops growing long before the paragraph becomes a single endless line.

`text-decoration-thickness` and `text-underline-offset` are small refinements that make links look intentional rather than default. They are optional, but they show how much control CSS gives you over details people feel before they notice.

## Color is a system, not a pick

Contrast is the first question, not the last. The Web Content Accessibility Guidelines (WCAG) set minimum contrast ratios:

- **4.5:1** for normal body text.
- **3:1** for large text (roughly 24px regular, or 18.66px bold) and for meaningful interface boundaries.
- More is better. Black on white is 21:1. A pleasant dark grey on warm paper is often 10:1 or more.

Low-contrast grey text is the most common accessibility failure on the web, and it is almost always a design decision rather than an accident. `#94a3b8` on white looks refined in a mockup and becomes unreadable in sunlight. Check contrast with a real tool, not by eye.

Semantic color choices make a palette easier to reason about. Name colors by job, not by hue:

- `--ink` for primary text.
- `--paper` for the page background.
- `--muted` for secondary text.
- `--accent` for links and actions.
- `--danger` for destructive actions, not for decoration.

CSS custom properties let you define those values once and reuse them. They are ordinary properties that happen to start with `--`, and they inherit like `color` does.

```html run
<article class="post">
  <p class="eyebrow">Palette</p>
  <h2>One accent, used with intent</h2>
  <p>The link and the label share a color because they share a job: they are the things you can act on.</p>
  <p><a href="#notes">Read the notes</a></p>
</article>

<style>
  :root {
    --ink: #1f2937;
    --paper: #fbf7ef;
    --muted: #57534e;
    --accent: #b45309;
  }

  body { margin: 0; padding: 48px 24px; background: var(--paper); color: var(--ink); font-family: Georgia, "Times New Roman", serif; }

  .post { max-width: 38rem; margin: 0 auto; }

  .eyebrow {
    margin: 0 0 8px;
    color: var(--accent);
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  h2 { margin: 0 0 12px; font-size: 2rem; line-height: 1.15; }

  p { margin: 0 0 16px; color: var(--muted); line-height: 1.6; }

  a { color: var(--accent); font-weight: 600; }
</style>
```

`:root` is the document''s root element, the `html` element. Custom properties defined there are available everywhere. `var(--accent)` reads the value. You can provide a fallback: `var(--accent, #b45309)` uses the second value if the variable is missing.

The real advantage appears when the palette changes. A dark section can redefine `--paper` and `--ink` on itself, and every child that uses `var()` follows. You edit one block instead of hunting through the stylesheet.

> **Pitfall:** A custom property is not automatically accessible just because it is a variable. `--muted: #cbd5e1` on white is still unreadable. The variable makes the system consistent; it does not make the color choice good.

## Challenge: build a palette with custom properties

Define three custom properties on `:root` — `--ink`, `--paper` and `--accent` — and use them throughout the card. The page background should be `--paper`, the heading and body text should be `--ink`, and the eyebrow and link should be `--accent`.

Use `#1f2937` for ink, `#fbf7ef` for paper and `#b45309` for the accent.

```html exercise id=palette-system title="A palette with custom properties"
<article class="post">
  <p class="eyebrow">Studio notes</p>
  <h2>Better shelves, fewer decisions</h2>
  <p>One material, one finish, one place for everything. The constraint is the design.</p>
  <p><a href="#process">See how the shelves are made</a></p>
</article>

<style>
  /* TODO: define --ink, --paper and --accent on :root, then use var() */
</style>
--- solution
<article class="post">
  <p class="eyebrow">Studio notes</p>
  <h2>Better shelves, fewer decisions</h2>
  <p>One material, one finish, one place for everything. The constraint is the design.</p>
  <p><a href="#process">See how the shelves are made</a></p>
</article>

<style>
  :root {
    --ink: #1f2937;
    --paper: #fbf7ef;
    --accent: #b45309;
  }

  body {
    margin: 0;
    padding: 48px 24px;
    background: var(--paper);
    color: var(--ink);
    font-family: Georgia, "Times New Roman", serif;
  }

  .post {
    max-width: 38rem;
    margin: 0 auto;
  }

  .eyebrow {
    margin: 0 0 8px;
    color: var(--accent);
    font-family: system-ui, sans-serif;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  h2 {
    margin: 0 0 12px;
    color: var(--ink);
    font-size: 2rem;
    line-height: 1.15;
  }

  p {
    margin: 0 0 16px;
    line-height: 1.6;
  }

  a {
    color: var(--accent);
    font-weight: 600;
  }
</style>
--- test
const rootStyle = getComputedStyle(document.documentElement);
const bodyStyle = getComputedStyle(document.body);
const readVariable = (name) => (rootStyle.getPropertyValue(name) || bodyStyle.getPropertyValue(name)).trim();
const ink = readVariable("--ink");
const paper = readVariable("--paper");
const accent = readVariable("--accent");
assert(ink, "Define --ink on :root with the primary text color.");
assert(paper, "Define --paper on :root with the page background color.");
assert(accent, "Define --accent on :root with the link and label color.");
assertColor("body", "background-color", paper, "The page background should use var(--paper).");
assertColor("h2", "color", ink, "The heading should use var(--ink).");
assertColor(".eyebrow", "color", accent, "The eyebrow should use var(--accent).");
assertColor("a", "color", accent, "The link should use var(--accent) too, so actions share one color.");
--- hint
Put the variables in a `:root { ... }` block at the top of the stylesheet: `--ink: #1f2937;` and so on.
--- hint
Read a variable with `color: var(--ink);` and `background: var(--paper);`. The name includes the two dashes.
--- hint
Use the accent for both `.eyebrow` and `a`. Reusing the same variable is the point of the exercise.
```

## Debug: the unreadable summary

This summary is set at 24px with `line-height: 1.2` and a pale grey that disappears into the white page. The type is large enough to feel important, but the lines are cramped and the contrast is below every useful threshold. Fix the leading and the color.

```html debug id=unreadable-summary title="The summary nobody can read"
<p class="summary">We read every note, every complaint and every unlikely suggestion. Then we make the coffee, because that is the part we can control.</p>

<style>
  body {
    margin: 0;
    padding: 48px;
    background: #ffffff;
    font-family: Georgia, "Times New Roman", serif;
  }

  .summary {
    max-width: 30rem;
    margin: 0;
    font-size: 24px;
    line-height: 1.2;
    color: #94a3b8;
  }
</style>
--- solution
<p class="summary">We read every note, every complaint and every unlikely suggestion. Then we make the coffee, because that is the part we can control.</p>

<style>
  body {
    margin: 0;
    padding: 48px;
    background: #ffffff;
    font-family: Georgia, "Times New Roman", serif;
  }

  .summary {
    max-width: 30rem;
    margin: 0;
    font-size: 24px;
    line-height: 1.65;
    color: #334155;
  }
</style>
--- test
const paragraph = query(".summary");
const paragraphStyle = getComputedStyle(paragraph);
const fontSize = parseFloat(paragraphStyle.fontSize);
const lineHeight = parseFloat(paragraphStyle.lineHeight);
assert(Number.isFinite(lineHeight), "The line height should resolve to a real length. Use a unitless number such as 1.65.");
const leading = lineHeight / fontSize;
assert(leading >= 1.5, `The summary has ${leading.toFixed(2)} lines of height for each line of text. At 24px, that is cramped. Use at least 1.5.`);
function rgbParts(value) {
  const numbers = value.match(/[\d.]+/g);
  return numbers ? numbers.slice(0, 3).map(Number) : null;
}
function luminance(rgb) {
  const channels = rgb.map((value) => {
    const c = value / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
const foreground = rgbParts(paragraphStyle.color);
const background = rgbParts(getComputedStyle(document.body).backgroundColor);
const lighter = Math.max(luminance(foreground), luminance(background));
const darker = Math.min(luminance(foreground), luminance(background));
const contrast = (lighter + 0.05) / (darker + 0.05);
assert(contrast >= 4.5, `The summary text has a contrast ratio of ${contrast.toFixed(2)}:1 against the page. Body copy should reach 4.5:1, and this pale grey does not.`);
--- hint
Two separate properties are wrong: the spacing between lines and the color of the text.
--- hint
Try `line-height: 1.65` for the leading. For the color, go darker than `#94a3b8` — `#334155` is a calm slate that passes comfortably.
--- hint
Keep the font size and the maximum width. A darker color and a unitless line height are enough to fix the reading experience.
```

## Fluid type with clamp()

A fixed heading size that looks right on a laptop is often too large on a phone. `clamp()` lets a value grow with the viewport but never smaller than a minimum or larger than a maximum.

```html run
<h1 class="hero">Built for the long way round</h1>
<p class="deck">A slower guide to the roads the motorway forgot.</p>

<style>
  body { margin: 0; padding: 48px 24px; background: #0f172a; color: #f8fafc; font-family: system-ui, sans-serif; }

  .hero {
    max-width: 16ch;
    margin: 0 0 20px;
    font-size: clamp(2rem, 7vw, 5rem);
    line-height: 1.02;
    letter-spacing: -0.04em;
  }

  .deck {
    max-width: 34rem;
    margin: 0;
    color: #cbd5e1;
    font-size: clamp(1rem, 2vw, 1.25rem);
    line-height: 1.55;
  }
</style>
```

The heading is `clamp(2rem, 7vw, 5rem)`. At a narrow width, 7% of the viewport is small, so the minimum of 2rem wins. On a wide screen, the preferred value would grow past 5rem, so the maximum stops it. Between those points, the type scales smoothly.

Read it as: **never smaller than the first value, never larger than the last, and otherwise the middle value**. The middle value can be a viewport unit, a percentage or a `calc()` expression.

Clamp is not a substitute for a type scale. Set a sensible minimum, choose a maximum that suits the longest heading, and test at both ends. Do not clamp body text below 16px; small type is not elegant, it is just hard to read.

> **Under the hood:** `vw` is 1% of the viewport width. On a 1100px preview, `7vw` is 77px, just under the 80px maximum, so the heading is already near its largest size. Drag the preview to phone width and the minimum takes over. The browser recalculates the value as the viewport changes, with no media query required.

## Predict: which line box grows?

Both paragraphs start at 20px. One gets a unitless line height and one gets a fixed length. Then the first paragraph''s font size changes.

```html predict id=line-height-multiplier title="Unitless versus fixed line height"
<p class="unitless">Unitless line height</p>
<p class="fixed">Fixed line height</p>

<style>
  p {
    font-size: 20px;
  }

  .unitless {
    line-height: 1.5;
  }

  .fixed {
    line-height: 24px;
  }

  .unitless {
    font-size: 32px;
  }
</style>
--- options
* The unitless paragraph: 1.5 × 32px = 48px, while the fixed paragraph stays at 24px
The fixed paragraph: 24px is larger than 1.5
Both paragraphs: the first font-size rule fixes the line height at 30px
The unitless paragraph: 1.5 × 20px = 30px, because line height uses the first font size
--- explain
A unitless line height is a multiplier resolved against the element''s final font size. The later `font-size: 32px` wins, so the line box becomes 1.5 × 32 = 48px. The fixed 24px line height does not care about the font size and stays 24px, which is why fixed lengths are risky on text that inherits or changes size.
```

## Recap

- A font stack lists fonts from most to least preferred and ends in a generic family. `system-ui`, Georgia and monospace stacks cover most needs.
- Use `rem` for sizes, numeric weights for boldness, and italic sparingly.
- Unitless `line-height` scales with font size; fixed lengths do not. Use 1.5–1.7 for body copy and tighter values for display headings.
- Keep body text around 60–70 characters with `max-width` in `ch`.
- Letter-space uppercase labels; do not remove link underlines without a replacement.
- WCAG AA asks for 4.5:1 contrast on normal text and 3:1 on large text. Check it rather than trusting your eye.
- Custom properties create a palette you can change in one place.
- `clamp(min, preferred, max)` makes type fluid without losing its limits.

**Up next:** Flexbox — putting boxes in a row, controlling alignment, and building the navigation bar that every page eventually needs.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_4_4', 'sec_html_css_basics_4', 'crs_html_css_basics', 'Checkpoint: CSS foundations', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which selector targets every element with `class=\"card\"`?","options":["`#card`","`.card`","`card`","`*card`"],"answerIndex":1,"explanation":"A class selector starts with a dot: `.card`. `#card` targets `id=\"card\"`. `card` targets `<card>` elements, which do not exist in HTML, and `*card` is not valid CSS."},{"id":"q2","prompt":"Which selector has the highest specificity?","options":["`article p`","`.intro`","`#hero`","`p`"],"answerIndex":2,"explanation":"IDs outrank classes, and classes outrank element selectors. `#hero` is an ID selector, so it wins over `.intro`, `article p` and `p`. Specificity is calculated before source order is considered."},{"id":"q3","prompt":"With `box-sizing: border-box`, what does `width: 300px` include?","options":["Only the content area","Content plus padding plus border, but not margin","Content plus padding plus border plus margin","Only the padding"],"answerIndex":1,"explanation":"`border-box` makes the declared width include content, padding and border. Margins sit outside the box and are not included. This is why many teams set `box-sizing: border-box` globally."},{"id":"q4","prompt":"A `content-box` element has `width: 300px; padding: 20px; border: 2px solid`. How wide is its visible box?","options":["300px","324px","344px","340px"],"answerIndex":2,"explanation":"With `content-box`, the width applies to content only. Total width is 300 + 20 + 20 (left and right padding) + 2 + 2 (left and right borders) = 344px. The margin, if any, would add space outside but does not change the border box width."},{"id":"q5","prompt":"How do you horizontally center a block element with a fixed `max-width`?","options":["`text-align: center` on the element","`margin-inline: auto` (or `margin: 0 auto`) with a width or max-width","`display: inline`","`vertical-align: middle`"],"answerIndex":1,"explanation":"Auto inline margins absorb the remaining horizontal space, centering the block within its containing block. `text-align: center` centers inline content inside the element, not the block itself. The element needs a width or max-width for the auto margins to have space to distribute."},{"id":"q6","prompt":"Which element generates a new line by default and accepts width and height?","options":["`<span>`","`<a>`","`<div>`","`<strong>`"],"answerIndex":2,"explanation":"`<div>` is `display: block` by default: it starts on a new line and fills the available width, and width/height apply. `<span>`, `<a>` and `<strong>` are inline by default, so width and height do not apply unless you change their display."},{"id":"q7","prompt":"Which property is inherited from a parent by default?","options":["`margin`","`border`","`color`","`padding`"],"answerIndex":2,"explanation":"Typography and color properties such as `color`, `font-family` and `line-height` inherit. Box properties such as margin, padding and border do not. That is why setting a font on `body` styles the whole page, while setting a margin on `body` does not add margins to every child."},{"id":"q8","prompt":"At `font-size: 20px`, what does `line-height: 1.5` compute to?","options":["1.5px","20px","30px","150px"],"answerIndex":2,"explanation":"A unitless line-height multiplies the element''s own font size: 20 × 1.5 = 30px. Unitless values are preferred because they recalculate for children with different font sizes. A fixed `line-height: 30px` would not adapt."},{"id":"q9","prompt":"Which declaration defines a CSS custom property?","options":["`color: --brand;`","`--brand: #0f766e;`","`var(--brand: #0f766e);`","`custom-property: brand #0f766e;`"],"answerIndex":1,"explanation":"Custom properties are declared like normal properties but their names start with `--`: `--brand: #0f766e;`. You read them with `var(--brand)`. They are inherited, which makes them useful for themes and design tokens."},{"id":"q10","prompt":"A paragraph has `color: #777` on a white background. What is the main accessibility concern?","options":["The color is too saturated","The contrast ratio may be below the 4.5:1 required for normal text","The paragraph will not inherit the color","Hex colors are not supported by screen readers"],"answerIndex":1,"explanation":"`#777` on white is roughly 4.48:1, just under the 4.5:1 AA threshold for normal text. It may pass for large text, but body copy should be darker. Always test the actual foreground and background pair, including opacity and overlays."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_5_1', 'sec_html_css_basics_5', 'crs_html_css_basics', 'Flexbox: rows, alignment and navigation bars', 'interactive', 0, 1320, NULL, NULL, 'Three links in a row. A logo pinned to the left and a menu pinned to the right. Three cards that share the width and stretch to the same height. For years, this kind of layout meant floats, clearfixes and a stack of negative margins. Flexbox turned it into a handful of declarations you can reason about.

Flexbox is a **one-dimensional** layout system. You put a set of items on a line, choose which way the line runs, then decide how the items share the space along it and how they align across it. That sounds narrow, but it covers navigation bars, card rows, media objects, toolbars and most of the small layouts inside a page. Once the axis model clicks, you stop guessing at margins.

## One axis at a time

You opt in by putting `display: flex` on a **container**. Its direct children become **flex items**. The container keeps its normal place in the document, but inside it the children are arranged by flex rules instead of the normal block flow.

Every flex container has two axes:

- The **main axis** is the direction the items flow. With the default `flex-direction: row`, it runs left to right.
- The **cross axis** is perpendicular to it. For a row, it runs top to bottom.

`gap` adds space *between* items without adding space around the outside. That is the detail that makes flexbox feel tidy: you no longer give every item a right margin and then remove the last one.

```html run
<header class="trail-bar">
  <span class="mark">Moss &amp; Pine</span>
  <span class="route">Edale · 12 km</span>
  <span class="weather">Cloud, 9°C</span>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .trail-bar {
    display: flex;
    gap: 1.5rem;
    align-items: center;
    padding: 1rem 1.5rem;
    background: #0f172a;
    color: #e2e8f0;
  }
  .mark { font-weight: 700; }
  .route, .weather { color: #94a3b8; font-size: 0.9rem; }
</style>
```

Remove `display: flex` and the three spans return to normal inline flow. They still sit on one line, but `gap` stops working and `align-items` has nothing to align. That is a useful experiment: flex is doing the spacing and vertical alignment, not the fact that spans are inline.

> **Under the hood:** A flex container creates a new **flex formatting context**. Margins between flex items do not collapse the way they do between block elements, and `vertical-align` no longer applies to the items. This is why a layout that looked fine with inline-block can shift when you switch it to flex.

## Which way the line runs

`flex-direction` changes the main axis:

| Value | Main axis | Typical use |
|---|---|---|
| `row` (default) | left to right | navigation, card rows, toolbars |
| `column` | top to bottom | stacked menus, card content |
| `row-reverse` | right to left | rare; visual order changes |
| `column-reverse` | bottom to top | rare; visual order changes |

Direction also changes what `justify-content` and `align-items` mean. In a row, `justify-content` works horizontally. In a column, it works vertically. That is the single most common source of confusion, and the reason to name the axes out loud before you debug.

By default, flex items try to fit on one line. They shrink if they can, and if they cannot, they overflow. `flex-wrap: wrap` lets them move onto a new line instead. Wrapping is what turns a rigid row into a tag cloud, a photo strip or a navigation bar that survives a narrow window.

```html run
<section class="notes">
  <h2>Trail notes</h2>
  <ul class="tags">
    <li>waterproofs</li>
    <li>map and compass</li>
    <li>extra socks</li>
    <li>flask</li>
    <li>dog treats</li>
  </ul>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  h2 { margin: 0 0 1rem; font-size: 1.1rem; }
  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    max-width: 24rem;
    margin: 0;
    padding: 0;
    list-style: none;
  }
  .tags li {
    padding: 0.35rem 0.75rem;
    border-radius: 999px;
    background: #ecfdf5;
    color: #065f46;
    font-size: 0.85rem;
  }
</style>
```

The tags wrap because the container is capped at `24rem`. Without `flex-wrap`, the list would stay on one line and the last tags would spill out of the container. That is the bug in the debug challenge below.

## Debug: the row that would not wrap

This card row looked fine on a wide monitor and breaks on a laptop. The cards have a fixed basis of `380px`, there are three of them, and the row is capped at `960px`. The maths does not fit, and because the row cannot wrap, the third card pushes the page sideways.

Run it, then drag the preview wider and narrower. The page should never scroll horizontally.

```html debug id=overflowing-card-row title="The row that would not wrap"
<section class="row">
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides, a sensible pace.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots and packs, ready for the weather.</p>
  </article>
  <article class="card">
    <h2>Trail notes</h2>
    <p>Routes tested every season by people who live here.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; max-width: 960px; margin: 0 auto; }
  .card {
    flex: 0 0 380px;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- solution
<section class="row">
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides, a sensible pace.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots and packs, ready for the weather.</p>
  </article>
  <article class="card">
    <h2>Trail notes</h2>
    <p>Routes tested every season by people who live here.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; flex-wrap: wrap; gap: 24px; max-width: 960px; margin: 0 auto; }
  .card {
    flex: 0 0 380px;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- test
assertStyle(".row", "display", "flex", "The row needs display: flex before wrapping can help.");
assertStyle(".row", "flex-wrap", "wrap", "The row is still nowrap, so the third card is pushed off the right edge. Let the row wrap.");
assertNoOverflow("The page still scrolls sideways. Check the row''s width and whether it is allowed to wrap.");
const row = query(".row").getBoundingClientRect();
document.querySelectorAll(".card").forEach((card, index) => {
  const box = card.getBoundingClientRect();
  assert(box.right <= row.right + 1, "Card " + (index + 1) + " still extends past the row''s right edge. Wrapping should bring it back inside.");
});
--- hint
The row has `display: flex`, but its default `flex-wrap` is `nowrap`. The three fixed cards cannot shrink below `380px`.
--- hint
Add `flex-wrap: wrap` to `.row`. The third card will move to a second line instead of widening the page.
--- hint
The finished rule starts `.row { display: flex; flex-wrap: wrap; gap: 24px; ... }`. Keep the fixed card width; the point is the wrapping, not the sizing.
```

> **Pitfall:** A flex item''s default minimum width is its content''s minimum size. A long unbroken word, a wide image or a `<pre>` block can stop an item from shrinking even when you set `flex: 1`. Set `min-width: 0` on the item when you genuinely need it to shrink.

## Alignment: the two questions

Every alignment decision starts with one question: *am I aligning along the main axis or across it?*

- `justify-content` distributes items along the **main axis**.
- `align-items` aligns items along the **cross axis**.

For a row, `justify-content: space-between` pushes the first item to the left edge and the last to the right edge. `align-items: center` lines the items up vertically in the middle of the row. Swap those two properties and you get a very different page.

The values worth knowing for `justify-content` are `flex-start`, `center`, `flex-end`, `space-between`, `space-around` and `space-evenly`. For `align-items`, the default is `stretch`, which makes items fill the cross axis. That default is why flex cards in a row end up the same height even when their text differs.

```html run
<div class="toolbar">
  <strong>Weekend walks</strong>
  <span class="count">3 saved</span>
</div>
<article class="note">
  <span class="pin" aria-hidden="true"></span>
  <div>
    <h2>Kinder Scout</h2>
    <p>Start early. The plateau is exposed, and the café closes at four.</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 34rem;
    padding: 0.75rem 1rem;
    border-radius: 10px;
    background: #0f172a;
    color: #fff;
  }
  .count { color: #94a3b8; font-size: 0.85rem; }
  .note {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    max-width: 34rem;
    margin-top: 1rem;
    padding: 1.25rem;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: #fff;
  }
  .pin { flex: none; width: 12px; height: 12px; margin-top: 0.45rem; border-radius: 50%; background: #b45309; }
  h2 { margin: 0 0 0.35rem; font-size: 1.1rem; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The pin uses `align-items: flex-start`, not `center`, because it should line up with the first line of the heading rather than float in the middle of a three-line block. The toolbar uses `center` because its two pieces are single lines. Alignment is a design decision, not a default you accept without looking.

```html predict id=flex-predict-space-between title="Where does space-between put three items?"
<div class="bar">
  <span>One</span>
  <span>Two</span>
  <span>Three</span>
</div>

<style>
  .bar { display: flex; justify-content: space-between; width: 30rem; padding: 0.75rem 1rem; background: #f1f5f9; }
</style>
--- options
* First at the left edge, last at the right edge, with equal gaps between the items
All three packed at the left edge, with equal gaps after them
Each item centred inside its own equal third of the bar
First at the left edge, second and third packed together at the right
--- explain
`space-between` puts the first item at the start and the last at the end, then divides the remaining free space equally *between* the items. There is no space before the first item or after the last. With three items you get two equal gaps. The middle item sits at the midpoint only when the first and last items happen to be the same width.
```

## Sizing: fixed, fluid and flex

Flexbox gives you three levers for how an item uses space:

- `flex-grow`: how much of the leftover space this item should take.
- `flex-shrink`: whether the item may shrink when space runs out.
- `flex-basis`: the starting size before growing or shrinking.

The shorthand `flex: 1` means `flex: 1 1 0%`. Every item with `flex: 1` starts from zero and then takes an equal share of the free space, which produces equal-width columns regardless of content. `flex: auto` means `flex: 1 1 auto`, so items start at their content size and only then share what is left. The difference matters when one card has a long heading.

A fixed sidebar uses `flex: 0 0 240px`: do not grow, do not shrink, start at 240 pixels. The main area uses `flex: 1` and absorbs the rest. That fixed-versus-fluid pairing is the backbone of dashboards, documentation sites and application shells.

```html run
<section class="cards">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides, a sensible pace and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: flex; gap: 1rem; max-width: 60rem; margin: 0 auto; }
  .card {
    flex: 1;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
```

The third card has more text, but all three cards are the same width because `flex: 1` ignores content when distributing space. They are also the same height because `align-items` defaults to `stretch`. Remove `flex: 1` and each card shrinks to its content; the row stops looking like a row.

## Challenge: three equal cards

Build a row of three cards that share the available width and stretch to the same height. The starter already has the markup and the card styling; the row is still a normal block, so each card takes the full width.

Use `display: flex` on `.cards`, `gap` for the space between cards, and `flex: 1` on each card. Keep the row''s maximum width at `60rem`.

```html exercise id=equal-card-row title="Three cards, one equal row"
<section class="cards">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { max-width: 60rem; margin: 0 auto; }
  .card {
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- solution
<section class="cards">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: flex; gap: 1rem; max-width: 60rem; margin: 0 auto; }
  .card {
    flex: 1;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: #fff;
  }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- test
assertStyle(".cards", "display", "flex", "The cards are still stacked as blocks. Put display: flex on .cards.");
const cards = Array.from(document.querySelectorAll(".card"));
assert(cards.length === 3, "Keep exactly three cards in the row.");
const boxes = cards.map((card) => card.getBoundingClientRect());
const widths = boxes.map((box) => box.width);
const rounded = widths.map((width) => Math.round(width));
assert(Math.max(...widths) - Math.min(...widths) < 1.5, "The cards should share the width equally, but they are " + rounded.join("px, ") + "px wide. Use flex: 1 on each card.");
const heights = boxes.map((box) => box.height);
assert(Math.max(...heights) - Math.min(...heights) < 2, "The cards should stretch to the same height. Check that .cards still uses align-items: stretch (the default) and that no card has a fixed height.");
const row = query(".cards");
const rowStyle = getComputedStyle(row);
const gap = parseFloat(rowStyle.gap) || 0;
const contentWidth = row.getBoundingClientRect().width - parseFloat(rowStyle.paddingLeft) - parseFloat(rowStyle.paddingRight);
const used = widths.reduce((total, width) => total + width, 0) + gap * (cards.length - 1);
assert(Math.abs(contentWidth - used) <= 2, "The row leaves " + Math.round(contentWidth - used) + "px of unused space. flex: 1 should make the cards fill the whole row.");
assertColor(".card", "background-color", "#ffffff", "Keep the card background white so the row reads as three separate cards.");
--- hint
The parent is the flex container, not the cards. Start with `display: flex` on `.cards`.
--- hint
Add `gap: 1rem` to `.cards`, then `flex: 1` to `.card` so each card starts at zero and takes an equal share.
--- hint
Your `.card` rule needs `flex: 1` alongside the padding, border, radius and background that are already there.
```

> **In the wild:** A fixed sidebar plus a fluid main area is usually `flex: 0 0 240px` and `flex: 1`. When you see a layout where the sidebar mysteriously shrinks as the main content grows, the sidebar is missing `flex-shrink: 0` or is using `flex: 1` by mistake.

## Build a navigation bar

A navigation bar is the classic flexbox exercise because it combines everything above: a row, two groups, vertical centring and a little wrapping for narrow screens.

The pattern is simple. Put `display: flex` and `justify-content: space-between` on the bar. Put the brand first and the list of links second. Make the list itself a flex row with its own `gap`. Reset the list''s default margin, padding and bullets.

```html run
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 1rem 2rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.5rem;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; flex-wrap: wrap; gap: 1.25rem; margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
  .links a:hover { color: #0f172a; }
</style>
```

`justify-content: space-between` works because there are exactly two children of `.nav`: the brand and the list. If you add a third child — a search box, say — the free space is distributed between all three, and the brand may no longer sit hard left. At that point a wrapper for the right-hand group, or a grid, is clearer than piling on margins.

> **Tip:** `flex-wrap: wrap` on the nav is a cheap responsive win. On a narrow screen the links drop to a second line instead of overflowing. It is not a substitute for a proper mobile menu, but it is a solid no-JavaScript baseline.

## Challenge: logo left, links right

Build the split navigation bar. The markup is already there: a brand link and an unordered list of four links inside `nav.nav`. The starter has no flex rules, so the brand and the list stack vertically and the links sit in a bulleted column.

Your job is to put the brand on the left, the links on the right and the links in a single horizontal row. Keep the existing colours and spacing.

```html exercise id=nav-split title="Logo left, links right"
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav { max-width: 64rem; margin: 0 auto; padding: 1rem 1.5rem; }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
</style>
--- solution
<header class="site-header">
  <nav class="nav" aria-label="Main">
    <a class="brand" href="#">Moss &amp; Pine</a>
    <ul class="links">
      <li><a href="#">Shop</a></li>
      <li><a href="#">Workshops</a></li>
      <li><a href="#">Journal</a></li>
      <li><a href="#">Visit</a></li>
    </ul>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .site-header { border-bottom: 1px solid #e2e8f0; background: #fff; }
  .nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 2rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.5rem;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; gap: 1.25rem; margin: 0; padding: 0; list-style: none; }
  .links a { color: #475569; font-size: 0.9rem; text-decoration: none; }
</style>
--- test
assertStyle(".nav", "display", "flex", "The nav is still a block, so its children stack. Put display: flex on .nav.");
const navElement = query(".nav");
const navStyle = getComputedStyle(navElement);
const nav = navElement.getBoundingClientRect();
const contentLeft = nav.left + parseFloat(navStyle.paddingLeft);
const contentRight = nav.right - parseFloat(navStyle.paddingRight);
const brand = query(".brand").getBoundingClientRect();
const links = query(".links").getBoundingClientRect();
const anchors = Array.from(document.querySelectorAll(".links a")).map((a) => a.getBoundingClientRect());
assert(anchors.length === 4, "Keep all four navigation links.");
assert(brand.left - contentLeft < 12, "The brand should sit at the left edge of the nav, but it starts " + Math.round(brand.left - contentLeft) + "px in.");
assert(contentRight - links.right < 12, "The links should sit at the right edge of the nav, but they end " + Math.round(contentRight - links.right) + "px short.");
assert(brand.right < links.left, "The brand and the links are overlapping or touching. Give the two groups room and push them apart.");
const tops = anchors.map((box) => box.top);
assert(Math.max(...tops) - Math.min(...tops) < 2, "The links are still stacked vertically. Make the list itself a flex row.");
assertColor(".brand", "color", "#0f172a", "Keep the brand in the dark ink colour (#0f172a).");
--- hint
You need flex on two elements: the bar that holds the brand and list, and the list that holds the four links.
--- hint
`justify-content: space-between` on `.nav` pushes the brand left and the list right. `align-items: center` keeps them on the same vertical line.
--- hint
`.links` needs `display: flex` and a `gap`. The list''s default padding and bullets are already reset for you.
```

## When Grid is the better tool

Flexbox is excellent at arranging items along one line. It is not the right tool for a layout that needs to align items in rows *and* columns, especially when the rows should share a consistent structure. If you find yourself nesting flex rows inside flex columns to fake a table, stop and reach for CSS Grid.

| Need | Better tool |
|---|---|
| Navbar, toolbar, button group | Flexbox |
| Three cards that share one row | Flexbox |
| Sidebar plus fluid main area | Flexbox or Grid |
| Photo gallery with aligned rows and columns | Grid |
| Whole-page layout with header, sidebar, main and footer | Grid |
| Centring one item in a box | Grid (`display: grid; place-items: center`) or flex with `justify-content` and `align-items` |

The two work together. A page shell might be a grid, while the navigation bar inside its header is flex. A card grid might be a grid, while the row of tags inside each card is flex. Choose per container, not per project.

> **Pitfall:** `justify-content` has no effect when the items already fill the main axis. If your `space-between` seems to do nothing, check whether the container is wider than its contents. A flex container that shrink-wraps its items has no free space to distribute.

## Recap

- `display: flex` turns a container''s direct children into flex items along one main axis.
- `flex-direction` chooses the main axis; `justify-content` aligns along it, `align-items` across it.
- `gap` spaces items without outer margins; `flex-wrap` lets a row break onto new lines.
- `flex: 1` gives items equal shares of the free space; `flex: 0 0 240px` pins a fixed sidebar.
- A navbar is usually `display: flex; justify-content: space-between; align-items: center` with a nested flex list.
- Fixed-width rows need `flex-wrap` or a smaller basis, or they will push the page sideways.

**Up next:** CSS Grid, where you stop arranging one line at a time and start describing the whole layout at once.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_5_2', 'sec_html_css_basics_5', 'crs_html_css_basics', 'CSS Grid: real two-dimensional layouts', 'interactive', 1, 1320, NULL, NULL, 'Flexbox arranges one line at a time. Grid describes the whole layout at once. That difference is not academic: it is the difference between nudging three cards until they line up and declaring three equal columns that every card, heading and gap obeys automatically.

CSS Grid is **two-dimensional**. You define columns and rows, and the browser turns them into a set of tracks and cells. Items can sit in a single cell, stretch across several, or be placed by name. It is the right tool for page shells, photo galleries, dashboards, pricing tables and any layout where things need to line up in both directions.

## The grid you describe

You opt in with `display: grid` on a container. Its direct children become **grid items**. The simplest grid names its columns and lets the items fill the cells in source order.

```html run
<section class="gallery">
  <article class="work">Ridge line <span>01</span></article>
  <article class="work">Pine shadow <span>02</span></article>
  <article class="work">Moorland <span>03</span></article>
  <article class="work">Dry stone <span>04</span></article>
  <article class="work">Low cloud <span>05</span></article>
  <article class="work">Footpath <span>06</span></article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .gallery {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    max-width: 54rem;
    margin: 0 auto;
  }
  .work {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    aspect-ratio: 4 / 3;
    padding: 1rem;
    border-radius: 12px;
    background: #0f766e;
    color: #fff;
    font-weight: 600;
  }
  .work:nth-child(2) { background: #b45309; }
  .work:nth-child(3) { background: #334155; }
  .work:nth-child(4) { background: #7c2d12; }
  .work:nth-child(5) { background: #065f46; }
  .work span { color: rgb(255 255 255 / 0.65); font-size: 0.8rem; }
</style>
```

The grid has three **columns** and as many **rows** as it needs. The browser places the six items left to right, top to bottom, and creates a new row when the first three cells are full. `gap: 12px` applies between columns and between rows; you do not need separate row and column margins.

The lines between tracks are called **grid lines**, and they are numbered from 1. A three-column grid has four vertical lines: line 1 is the left edge, line 4 the right edge. You will use those numbers when you place an item across tracks.

> **Under the hood:** Grid items are placed by a layout algorithm, not by floats or absolute positioning. The browser resolves the tracks first, then places the items, then sizes the rows. That is why a grid can align an item in row three with an item in row one without any shared wrapper.

## Tracks, fractions and minimums

`grid-template-columns` accepts a list of track sizes. You can use pixels, percentages, `auto`, `fr` or functions like `repeat()` and `minmax()`.

The `fr` unit means *a share of the free space* after fixed tracks and gaps have been subtracted. It is not a percentage. In `220px minmax(0, 1fr)`, the sidebar always gets 220 pixels and the main area gets everything else, whatever the viewport width.

`minmax(0, 1fr)` is a useful spelling of "one fraction, but allowed to shrink to zero". Plain `1fr` is really `minmax(auto, 1fr)`, and that `auto` minimum is the content''s minimum size. A long unbroken word or a wide image can therefore make a `1fr` track wider than you intended.

```html run
<div class="dashboard">
  <aside class="rail">
    <h2>Filters</h2>
    <p>Difficulty</p>
    <p>Distance</p>
    <p>Dog friendly</p>
  </aside>
  <main class="panel">
    <p class="eyebrow">Peak District</p>
    <h1>Routes near Edale</h1>
    <p>Twelve walks between four and fourteen kilometres, all reachable from the village.</p>
    <div class="stat">12 km · 480 m ascent · 4 hours</div>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .dashboard {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr);
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem;
  }
  .rail, .panel { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .rail h2 { margin: 0 0 1rem; font-size: 1rem; }
  .rail p { margin: 0 0 0.5rem; color: #475569; font-size: 0.9rem; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 0.75rem; font-size: 2rem; letter-spacing: -0.03em; }
  .panel > p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  .stat { padding: 0.75rem 1rem; border-radius: 8px; background: #f1f5f9; color: #334155; font-size: 0.85rem; font-weight: 600; }
</style>
```

Try changing `220px` to `30%`. The sidebar now depends on the container width, and the main column still absorbs the rest. Try changing `minmax(0, 1fr)` to `1fr` and paste a very long route name into the heading; at some widths the main column will refuse to shrink and the grid will overflow.

> **Pitfall:** `1fr` is not a guarantee that a track can shrink. Its automatic minimum is the largest minimum content size in that track. Use `minmax(0, 1fr)` when the content includes long words, code, URLs or wide media.

## Debug: the grid that grew sideways

This three-column card grid overflows the page. Each card contains a long, unbroken heading, and the columns are plain `1fr`. The browser respects the heading''s minimum width, so each track becomes about 657 pixels wide and the total grid is far wider than the window.

The fix is two small changes: let the tracks shrink with `minmax(0, 1fr)`, and let the headings break with `overflow-wrap: anywhere`. Neither one is enough on its own — the first gives the track permission to shrink, the second stops the text from spilling out of the narrower track.

```html debug id=grid-overflow-longword title="The grid that grew sideways"
<section class="grid">
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>A word that should never appear in a trail guide.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>And yet here it is, three times.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>The grid has to survive it.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 20px;
    max-width: 960px;
    margin: 0 auto;
  }
  .card { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 2rem; line-height: 1.1; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- solution
<section class="grid">
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>A word that should never appear in a trail guide.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>And yet here it is, three times.</p>
  </article>
  <article class="card">
    <h2>Pneumonoultramicroscopicsilicovolcanoconiosis</h2>
    <p>The grid has to survive it.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
    max-width: 960px;
    margin: 0 auto;
  }
  .card { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 2rem; line-height: 1.1; overflow-wrap: anywhere; }
  p { margin: 0; color: #475569; line-height: 1.5; }
</style>
--- test
assertNoOverflow("The page still scrolls sideways. The long headings are forcing the grid wider than the window.");
const grid = query(".grid");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "Keep three columns. The grid currently resolves to " + columns.length + " track(s).");
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect().width);
assert(Math.max(...cards) - Math.min(...cards) < 1.5, "The cards should stay equal width. The tracks are still being sized by their content.");
document.querySelectorAll(".card h2").forEach((heading, index) => {
  assert(heading.scrollWidth <= heading.clientWidth + 1, "The heading in card " + (index + 1) + " is wider than its card. Let the long word break inside the column.");
});
--- hint
The tracks are `1fr`, which means `minmax(auto, 1fr)`. The `auto` minimum is the long word''s width.
--- hint
Change the columns to `repeat(3, minmax(0, 1fr))` so the tracks may shrink below their content''s minimum.
--- hint
The headings also need `overflow-wrap: anywhere` so the word can break inside the narrower track. Use both fixes.
```

## Card grids that reflow

The most common grid in modern interfaces is a card grid that changes its column count without a media query. The pattern is:

```css
grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
```

Read it from the inside out. Each track must be at least 220 pixels and may grow to one fraction of the free space. `repeat()` asks the browser to fit as many of those tracks as possible into the container. `auto-fit` collapses any empty tracks at the end, letting the existing items stretch to fill the row.

`auto-fill` looks similar but keeps empty tracks, so a row with two cards can leave a gap where a third would fit. Use `auto-fit` when you want the cards to stretch; use `auto-fill` when you want a consistent track width and are happy with empty space.

```html run
<section class="grid">
  <article class="card">
    <h2>Espresso</h2>
    <p>Short, bright and made for the flask.</p>
  </article>
  <article class="card">
    <h2>Filter</h2>
    <p>A slower cup for a slower morning.</p>
  </article>
  <article class="card">
    <h2>Cold brew</h2>
    <p>Eighteen hours of patience in a bottle.</p>
  </article>
  <article class="card">
    <h2>Hot chocolate</h2>
    <p>For the people who came for the walk.</p>
  </article>
  <article class="card">
    <h2>Beans</h2>
    <p>Take the trail home with you.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
```

At a viewport of 1100 pixels the grid''s content area is capped at 1000 pixels. Four 220-pixel tracks plus three 20-pixel gaps need 940 pixels, so four columns fit. The remaining 60 pixels are shared between the four tracks. The fifth card moves to a second row and stretches to the full width because there are no other items beside it.

```html predict id=grid-predict-autofit-columns title="How many columns fit?"
<div class="grid">
  <article>One</article>
  <article>Two</article>
  <article>Three</article>
  <article>Four</article>
</div>

<style>
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 1rem;
    background: #f1f5f9;
  }
  article { padding: 1rem; background: #fff; }
</style>
--- options
* Four columns
Three columns
Five columns
One column
--- explain
The grid''s content area is 1000 pixels wide. Four tracks need 4 × 220 = 880 pixels, plus three 20-pixel gaps = 940 pixels, so four fit. Five tracks would need 1100 + 80 = 1180 pixels, which does not. The browser fits four and shares the leftover 60 pixels equally, making each track 235 pixels. At a narrower viewport the same declaration fits fewer columns with no media query.
```

## Challenge: a three-column card grid

Build a three-column card grid that would reflow to two and then one column on narrower screens. At the 1100-pixel test viewport, the cards should form exactly three equal columns.

Use `repeat(auto-fit, minmax(200px, 1fr))` and a `20px` gap. Keep the grid''s maximum width at `760px`. The starter has the cards and their styling but no grid layout.

```html exercise id=auto-fit-cards title="A card grid that reflows"
<section class="grid">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { max-width: 760px; margin: 0 auto; }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- solution
<section class="grid">
  <article class="card">
    <h2>Trailhead</h2>
    <p>Espresso, porridge and a bench with a view.</p>
  </article>
  <article class="card">
    <h2>Kit hire</h2>
    <p>Boots, packs and a map you can actually fold.</p>
  </article>
  <article class="card">
    <h2>Guided walks</h2>
    <p>Small groups, local guides and a flask of tea at the top.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    max-width: 760px;
    margin: 0 auto;
  }
  .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  h2 { margin: 0 0 0.45rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
</style>
--- test
assertStyle(".grid", "display", "grid", "The cards are still stacked as blocks. Put display: grid on .grid.");
const grid = query(".grid");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "At this width the grid should resolve to three columns, but it has " + columns.length + ". Check the minmax minimum and the grid''s maximum width.");
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect());
assert(cards.length === 3, "Keep exactly three cards.");
const widths = cards.map((box) => box.width);
assert(Math.max(...widths) - Math.min(...widths) < 1.5, "The three columns should be equal, but their widths are " + widths.map((width) => Math.round(width)).join("px, ") + "px. Use 1fr as the maximum.");
const gap = parseFloat(getComputedStyle(grid).gap);
assert(gap >= 15, "Add a visible gap between the cards. A 20px gap is a good start.");
assertNoOverflow("The cards should fit inside the page, not push it sideways.");
let css = "";
for (const sheet of Array.from(document.styleSheets)) {
  try {
    css += Array.from(sheet.cssRules).map((rule) => rule.cssText).join(" ");
  } catch (error) {}
}
assert(/auto-fit/.test(css), "The columns are not using auto-fit yet, so the grid cannot choose a new column count as space changes. Use repeat(auto-fit, minmax(200px, 1fr)).");
assert(/minmax\(\s*(200px|12\.5rem)/.test(css), "The track needs a minimum width. Use minmax(200px, 1fr) — or 12.5rem, which is the same size — inside repeat().");
assertColor(".card", "background-color", "#ffffff", "Keep the cards white so the grid edges stay readable.");
--- hint
The parent `.grid` needs `display: grid` before any column rules apply.
--- hint
Set `grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))` and `gap: 20px`.
--- hint
Keep `max-width: 760px` on `.grid`. At 760px, three 200px tracks plus two 20px gaps fit, which is why the browser chooses three columns.
```

## Placing items across lines

Auto-placement is convenient until one item needs more room. Grid gives every item a position on both axes. You can say "start at column line 1 and end at line 3", or the shorter "span two columns".

```css
.feature {
  grid-column: span 2;
}
```

Rows work the same way with `grid-row`. `grid-column: 2 / 4` starts at line 2 and ends at line 4, occupying the two tracks between them. The end line is exclusive, just like slicing a list.

```html run
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card"><h2>Edale loop</h2><p>4 km · easy</p></article>
  <article class="card"><h2>Mam Tor</h2><p>7 km · moderate</p></article>
  <article class="card"><h2>Stanage edge</h2><p>9 km · moderate</p></article>
  <article class="card"><h2>Derwent edge</h2><p>12 km · steady</p></article>
  <article class="card"><h2>Grindsbrook</h2><p>6 km · easy</p></article>
</section>
<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid; grid-template-columns: repeat(3, 1fr); grid-auto-rows: 150px;
    gap: 16px; max-width: 1000px; margin: 0 auto;
  }
  .feature { grid-column: span 2; grid-row: span 2; padding: 1.5rem; border-radius: 16px; background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.75rem; font-size: 1.8rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card { padding: 1rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
```

The feature occupies columns 1–2 and rows 1–2. The next two cards fill the third column, and the last three fill the bottom row. If you remove `grid-row: span 2`, the feature only takes the first row and the cards below it rearrange. Nothing about the markup changes; only the placement does.

> **Pitfall:** Auto-placement can leave holes. `grid-auto-flow: dense` lets later items backfill those holes, but it can reorder content visually. If reading order matters — and for most pages it does — leave dense packing off and design the placement deliberately.

## Challenge: the featured story

Build a magazine row where the first article spans two of the three columns and the other three cards fill the remaining space. The grid, cards and content are in place; the feature is still just one column wide.

Do not use a fixed pixel width. Span the grid tracks so the layout keeps working if the container changes size.

```html exercise id=magazine-feature title="A story that spans two columns"
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card">
    <h2>Edale loop</h2>
    <p>4 km · easy</p>
  </article>
  <article class="card">
    <h2>Mam Tor</h2>
    <p>7 km · moderate</p>
  </article>
  <article class="card">
    <h2>Stanage edge</h2>
    <p>9 km · moderate</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .feature, .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .feature { background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.5rem; font-size: 1.7rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
--- solution
<section class="magazine">
  <article class="feature">
    <p class="eyebrow">Featured route</p>
    <h2>Kinder Scout at first light</h2>
    <p>Up before the crowds, across the plateau, back before the café fills.</p>
  </article>
  <article class="card">
    <h2>Edale loop</h2>
    <p>4 km · easy</p>
  </article>
  <article class="card">
    <h2>Mam Tor</h2>
    <p>7 km · moderate</p>
  </article>
  <article class="card">
    <h2>Stanage edge</h2>
    <p>9 km · moderate</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .magazine {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    max-width: 1000px;
    margin: 0 auto;
  }
  .feature, .card { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .feature { grid-column: span 2; background: #0f172a; color: #e2e8f0; }
  .eyebrow { margin: 0 0 0.5rem; color: #5eead4; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .feature h2 { margin: 0 0 0.5rem; font-size: 1.7rem; letter-spacing: -0.02em; }
  .feature p { margin: 0; color: #cbd5e1; line-height: 1.55; }
  .card h2 { margin: 0 0 0.35rem; font-size: 1rem; }
  .card p { margin: 0; color: #64748b; font-size: 0.85rem; }
</style>
--- test
assertStyle(".magazine", "display", "grid", "The magazine still needs display: grid.");
const grid = query(".magazine");
const columns = getComputedStyle(grid).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 3, "Keep three grid columns. The layout currently resolves to " + columns.length + ".");
const feature = query(".feature").getBoundingClientRect();
const cards = Array.from(document.querySelectorAll(".card")).map((card) => card.getBoundingClientRect());
assert(cards.length === 3, "Keep all three supporting cards.");
const normal = cards[0].width;
assert(feature.width > normal * 1.8, "The featured story is only " + Math.round(feature.width) + "px wide, about the same as one card. Make it span two columns.");
assert(feature.width < normal * 2.25, "The featured story spans more than two columns. It should cover exactly two.");
assert(Math.abs(feature.top - cards[0].top) < 2, "The featured story should start on the same row as the first supporting card.");
assert(cards[1].top > feature.top + 10, "The second supporting card should move below the feature, not squeeze onto the first row.");
--- hint
The feature is a grid item. Its width is controlled by `grid-column`, not `width`.
--- hint
`grid-column: span 2` makes the item cover two tracks. `grid-column: 1 / 3` does the same thing by line number.
--- hint
Add `grid-column: span 2` to `.feature`. Keep the existing three equal columns and gap.
```

## Naming areas

Line numbers are precise but hard to read. `grid-template-areas` lets you draw the layout with names instead. Each quoted string is one row, each word is one cell, and repeating a name makes an area span cells. A dot represents an empty cell.

You then assign each item to a named area with `grid-area`. The result reads like a diagram, which is exactly what a page layout should be.

```html run
<div class="page">
  <header class="masthead">Moss &amp; Pine</header>
  <nav class="sections" aria-label="Sections">
    <a href="#">Shop</a>
    <a href="#">Workshops</a>
    <a href="#">Journal</a>
  </nav>
  <main class="content">
    <p class="eyebrow">Journal</p>
    <h1>What the rain taught us</h1>
    <p>Notes from a season of building things that live outside.</p>
  </main>
  <footer class="foot">Made in Hebden Bridge</footer>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .page {
    display: grid;
    grid-template-columns: 200px minmax(0, 1fr);
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
      "masthead masthead"
      "sections content"
      "foot foot";
    gap: 16px;
    min-height: 100vh;
    padding: 16px;
    box-sizing: border-box;
  }
  .masthead { grid-area: masthead; padding: 1rem; background: #0f172a; color: #fff; font-weight: 700; }
  .sections { grid-area: sections; display: flex; flex-direction: column; gap: 0.75rem; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; }
  .sections a { color: #475569; text-decoration: none; }
  .content { grid-area: content; padding: 2rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; }
  .content h1 { margin: 0 0 0.75rem; font-size: 2rem; letter-spacing: -0.03em; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .content p:last-child { margin: 0; color: #475569; line-height: 1.6; }
  .foot { grid-area: foot; padding: 0.75rem 1rem; color: #64748b; font-size: 0.85rem; }
</style>
```

The `grid-template-areas` declaration contains three rows. `masthead` spans both columns on the first row, `sections` sits in the left column on the second, `content` in the right, and `foot` spans the third. The area names do not have to match the element names, but matching them keeps the CSS readable.

On a narrow screen you can redraw the same page as one column without touching the markup:

```css
@media (max-width: 700px) {
  .page {
    grid-template-columns: 1fr;
    grid-template-areas: "masthead" "sections" "content" "foot";
  }
}
```

That is the whole responsive story: change the map, not the content. The next lesson is about the media query that triggers the change.

> **Tip:** Keep area names semantic (`masthead`, `content`, `foot`) rather than visual (`left`, `right`, `top`). Visual names become lies the moment the layout changes.

## Grid or flex?

Grid and flex solve different problems. Grid is for layout that has to line up across two axes. Flex is for a line of items that share space and align across that line.

| Situation | Better first choice |
|---|---|
| Whole-page shell: header, sidebar, main, footer | Grid, often with named areas |
| Card grid where rows and columns must align | Grid with `repeat(auto-fit, minmax(...))` |
| Featured item spanning columns or rows | Grid placement |
| Navbar or toolbar | Flex |
| Tag list that wraps | Flex |
| Centring a single item | Flex or grid; both are fine |
| Page shell with a flex navbar inside | Both, each in its own container |

Do not turn every container into a grid. A grid with one row and `grid-auto-flow: column` is usually a flexbox wearing a costume. Equally, do not nest three flex rows to build something that is obviously a table of cards. Pick the tool that matches the shape of the problem.

> **In the wild:** Product pages often use a grid shell at the top (header, gallery, buy box) and a flex row for the star rating or the quantity stepper. Design systems describe these as layout primitives: a `Stack` built on flex, a `Grid` built on grid. The names are the contract; the CSS is an implementation detail.

## Recap

- `display: grid` defines columns and rows; children fill the cells in source order.
- `repeat(3, 1fr)` creates three equal fractions of the free space, after gaps.
- `minmax(0, 1fr)` lets a track shrink below its content''s minimum; plain `1fr` does not.
- `repeat(auto-fit, minmax(220px, 1fr))` creates a responsive card grid without media queries.
- `grid-column` and `grid-row` place items across tracks; `span 2` is the short form.
- `grid-template-areas` draws a named layout; `grid-area` assigns items to it.
- Grid handles two-dimensional structure; flex handles a row or column of items. Use both.

**Up next:** responsive design — the viewport, media queries and fluid type that let one page work on every screen.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_5_3', 'sec_html_css_basics_5', 'crs_html_css_basics', 'Responsive design: one page on every screen', 'interactive', 2, 1320, NULL, NULL, 'A page is not a fixed canvas. The same markup meets a 390-pixel phone, a 768-pixel tablet, a 1440-pixel laptop and a wall-sized monitor. Responsive design is not a second mobile website hidden behind a redirect; it is one document that adapts as the space changes.

The browser gives you a small, precise toolkit for this: the viewport meta tag, media queries, fluid images and fluid type. None of them require JavaScript. Used together, they let a layout rearrange itself at the exact point where the current one stops working.

## Tell the browser you meant it

The first line of defence is in the `<head>`:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

Without it, a mobile browser assumes the page was designed for a desktop and lays it out in a virtual viewport around 980 pixels wide, then zooms out to fit. Text becomes tiny, tap targets become unusable, and your carefully written media queries never fire at the width you expected.

`width=device-width` tells the browser to use the device''s actual width in CSS pixels. `initial-scale=1` sets the starting zoom to 100%. Together they make the phone report a viewport of roughly 390 pixels instead of pretending to be a desktop.

```html run
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trailhead Coffee</title>
    <style>
      body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
      main { max-width: 36rem; margin: 0 auto; padding: 3rem 1.25rem; }
      h1 { margin: 0 0 1rem; font-size: 2.5rem; letter-spacing: -0.03em; }
      p { line-height: 1.6; color: #475569; }
    </style>
  </head>
  <body>
    <main>
      <h1>Coffee, without ceremony.</h1>
      <p>Small-batch coffee for people who walk up hills. Open Tuesday to Sunday, 8am to 4pm.</p>
    </main>
  </body>
</html>
```

Open this page in the phone width of the preview toolbar. The heading wraps, the paragraph fills the screen, and nothing is zoomed out. The `max-width` on `main` keeps the line length comfortable on a desktop without causing a tiny column on a phone.

> **Pitfall:** A missing viewport tag is easy to miss because the desktop preview looks perfect. If your media queries seem to be ignored on a real phone but work in the toolbar, check the `<head>` first.

## Mobile first, then add room

A **media query** applies a block of CSS only when a condition about the viewport is true. The most useful condition is width:

```css
@media (min-width: 640px) {
  .steps { grid-template-columns: 1fr 1fr; }
}
```

The mobile-first pattern starts with the narrow layout as the default. You write the single-column styles first, with no media query at all. Then you add `min-width` blocks that introduce columns, larger gaps and bigger type as more space becomes available.

This ordering has a practical benefit: the simplest layout is the one every browser gets, including old phones and unusual devices. The fancy layout is an enhancement, not a requirement.

```html run
<section class="steps">
  <article>
    <h2>Choose a route</h2>
    <p>Filter by distance, climb and whether the dog can come.</p>
  </article>
  <article>
    <h2>Check the weather</h2>
    <p>Wind on the tops matters more than the forecast in the valley.</p>
  </article>
  <article>
    <h2>Pack light</h2>
    <p>Water, layers, a map and more food than feels reasonable.</p>
  </article>
  <article>
    <h2>Tell someone</h2>
    <p>A route card on the kitchen table is still the best safety tool.</p>
  </article>
</section>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .steps { display: grid; gap: 16px; max-width: 1000px; margin: 0 auto; padding: 2rem 1.25rem; }
  .steps article { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; }
  h2 { margin: 0 0 0.5rem; font-size: 1.05rem; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @media (min-width: 640px) {
    .steps { grid-template-columns: 1fr 1fr; }
  }
</style>
```

At 1100 pixels you see two columns. At 390 pixels the same four cards stack. Nothing was removed or duplicated; the grid simply gained a second column when the viewport crossed 640 pixels.

A `min-width` query is inclusive: `min-width: 640px` applies at exactly 640 and above. That is why the breakpoints in a mobile-first stylesheet usually read like a ladder: 480, 640, 900, 1200.

## min-width or max-width?

Both directions work. They describe different starting points.

| Approach | Base styles | Query | Best for |
|---|---|---|---|
| Mobile first | Narrow layout | `min-width` adds complexity | New projects, performance, simple defaults |
| Desktop first | Wide layout | `max-width` removes complexity | Extending an existing desktop design |

A `max-width: 700px` query applies at 700 and *below*. It is the natural choice when the wide layout is already the default and you want to simplify as the screen shrinks. The next challenge uses that direction deliberately, so you can see both.

Do not mix the two approaches randomly in one stylesheet. If the base is narrow, use `min-width`; if the base is wide, use `max-width`. Mixing them makes it hard to answer the basic question: *what does this element look like at 500 pixels?* You have to read every rule and work out which conditions overlap.

> **Tip:** Media queries do not add specificity. When two conditions are both true, the later rule wins if the selectors have equal specificity. Put your queries in a sensible order — usually narrow to wide — and keep related rules together.

## Breakpoints belong to the content

There is no list of device widths you must support. A breakpoint is a decision about your design: the width at which the current layout stops looking good.

Start narrow. Widen the preview slowly. Watch the paragraph measure, the card widths and the navigation. The moment a line becomes too long to read, or a card becomes too narrow for its heading, you have found a breakpoint. Add a `min-width` query there.

This is why copying an "iPhone breakpoint" from a blog post is usually a mistake. Your phone-sized layout might break at 560 pixels and your tablet layout might be fine until 900. The content tells you; the device names do not.

The preview toolbar gives you desktop, tablet (768px) and phone (390px) widths. Use it as a quick sanity check, not as a substitute for dragging the edge of the window. Most layout bugs appear somewhere between the named sizes, not exactly at them.

```html predict id=responsive-predict-min-width title="Which padding wins at 1100px?"
<div class="notice">
  <strong>Trail closed</strong>
  <p>The lower path is flooded after rain.</p>
</div>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; }
  .notice { padding: 16px; border-radius: 12px; background: #e0f2fe; }
  @media (min-width: 700px) {
    .notice { padding: 32px; }
  }
</style>
--- options
* 32px, because the viewport is wider than 700px
16px, because the base rule is declared first
24px, the midpoint of the two rules
32px only when the viewport is narrower than 700px
--- explain
The test viewport is 1100 pixels wide, so `(min-width: 700px)` is true and the media block applies. The base `padding: 16px` is still there, but the later rule overrides it. If the viewport were 600 pixels, the condition would be false and the notice would keep 16px. `min-width` means "this width and up", not "below this width".
```

## Images that behave

A bitmap image has an intrinsic width. Drop a 1600-pixel photo into a 900-pixel column and the browser will happily let it overflow, because an image''s default `max-width` is `none`. The page starts scrolling sideways, which is the most common responsive bug on the web.

The fix is two declarations:

```css
img {
  max-width: 100%;
  height: auto;
}
```

`max-width: 100%` caps the image at its container''s width. `height: auto` lets the browser calculate the height from the image''s natural aspect ratio, so the picture is not squashed. Always keep the `width` and `height` attributes in the HTML as well; they reserve the right amount of space before the image loads and prevent the page from jumping.

```html run
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''1600'' height=''900''%3E%3Crect width=''1600'' height=''900'' fill=''%230f172a''/%3E%3Ccircle cx=''1180'' cy=''260'' r=''150'' fill=''%23fbbf24''/%3E%3Cpath d=''M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="hero-copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 60rem; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { display: block; max-width: 100%; height: auto; border-radius: 16px; }
  h1 { margin: 1.5rem 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
```

The image is 1600 pixels wide by nature. In the 1100-pixel preview it renders at the width of its container, with the height scaled to match. Narrow the preview to phone width and it keeps shrinking. The aspect ratio never changes.

> **Pitfall:** `height: auto` is not optional. If you set only `max-width: 100%` but leave a fixed height in CSS, the image is squashed as it gets narrower. If you set a fixed width in CSS, `max-width` may never come into play.

## Type that bends instead of breaking

Headlines are harder than images because text has to stay readable across a much wider range. A 56-pixel heading looks bold on a laptop and absurd on a phone. A 28-pixel heading looks fine on a phone and timid on a desktop.

`clamp()` solves this with three values: a minimum, a preferred value and a maximum.

```css
font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
```

The preferred value can mix units. Here `5vw` grows with the viewport and `1rem` keeps a readable floor. The browser picks whichever is larger between the minimum and the preferred value, then caps the result at the maximum. The text is fluid in between but never smaller than 2.25rem or larger than 4.5rem.

```html run
<header class="masthead">
  <p class="eyebrow">Trailhead Coffee</p>
  <h1>Big views, small batches.</h1>
  <p class="lede">A walk-up coffee counter at the edge of the Peak District. Open every day the weather allows.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede {
    max-width: 38rem;
    margin: 0;
    font-size: clamp(1rem, 1.5vw + 0.75rem, 1.25rem);
    line-height: 1.6;
    color: #475569;
  }
</style>
```

Use `clamp()` for display type and generous spacing, not for every font size. Body text is usually better with a fixed, comfortable size and a `max-width` on the column. Fluid type is a tool for the extremes, not a reason to make every paragraph resize with the window.

> **Under the hood:** `vw` is one percent of the viewport width. At 1100 pixels, `5vw` is 55 pixels. Adding `1rem` gives 71 pixels, which is below the 72-pixel maximum, so the heading renders at 71 pixels. At 390 pixels, `5vw` is 19.5 pixels plus 16 equals 35.5, below the 36-pixel minimum, so the minimum wins.

## A navigation bar without JavaScript

A full mobile menu usually needs a button and a little JavaScript to toggle it. But you can build a perfectly usable responsive navigation bar with CSS alone: stack the brand and links on narrow screens, then switch to a row when there is room.

The markup stays in a sensible reading order. The media query only changes direction and alignment.

```html run
<header class="header">
  <a class="brand" href="#">Moss &amp; Pine</a>
  <nav class="links" aria-label="Main">
    <a href="#">Shop</a>
    <a href="#">Workshops</a>
    <a href="#">Journal</a>
    <a href="#">Visit</a>
  </nav>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #fff; }
  .header {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #e2e8f0;
  }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .links { display: flex; flex-wrap: wrap; gap: 0.5rem 1.25rem; }
  .links a { color: #475569; font-size: 0.95rem; text-decoration: none; }
  .links a:hover { color: #0f172a; }
  @media (min-width: 700px) {
    .header { flex-direction: row; align-items: center; justify-content: space-between; }
  }
</style>
```

At phone width the brand sits above the links and the links wrap onto as many lines as they need. At 700 pixels and above the header becomes a row with the brand on the left and the navigation on the right. No script, no hidden duplicate menu, no layout shift.

This is a baseline, not a complete mobile navigation pattern. If you need a disclosure button, build it with a real `<button>`, `aria-expanded`, and JavaScript in the advanced course. The CSS-only version is a good default because it works before any script loads.

## Motion, gently

Some people experience dizziness, nausea or migraine from large motion, parallax and zooming transitions. Operating systems expose a setting for this, and CSS can respect it with `prefers-reduced-motion`.

The safest pattern is to make motion an enhancement inside `no-preference`, or to explicitly remove it inside `reduce`:

```css
@media (prefers-reduced-motion: reduce) {
  .card { transition: none; }
  .card:hover { transform: none; }
}
```

```html run
<article class="card">
  <p class="eyebrow">Workshop</p>
  <h2>Build a field notebook</h2>
  <p>Saturday, 10am. All materials included.</p>
  <a href="#">Reserve a place</a>
</article>

<style>
  body { margin: 0; padding: 2rem; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    max-width: 28rem;
    margin: 0 auto;
    padding: 1.5rem;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    transition: transform 0.25s ease, box-shadow 0.25s ease;
  }
  .card:hover { transform: translateY(-4px); box-shadow: 0 12px 30px rgb(15 23 42 / 0.12); }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h2 { margin: 0 0 0.5rem; font-size: 1.25rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.55; }
  a { color: #0f172a; font-weight: 600; }
  @media (prefers-reduced-motion: reduce) {
    .card { transition: none; }
    .card:hover { transform: none; }
  }
</style>
```

Hover the card with motion enabled and it lifts slightly. Turn on "Reduce motion" in your operating system, reload, and the lift disappears while the card remains fully usable. That is the point: remove the decoration, keep the information and the interaction.

> **Tip:** Test with the operating-system setting, not just by resizing the window. The media feature follows the user''s system preference, and it can change while the page is open.

## Challenge: stack at 700 pixels

This page has a two-column layout: a main article and a sidebar. At 1100 pixels it looks fine. Below 700 pixels the columns become too narrow to read.

Add a `max-width: 700px` media query that turns `.layout` into a single column. Keep the two-column layout as the default; this is the desktop-first direction, and the tests check that the breakpoint is actually there.

```html exercise id=stack-at-700 title="Stack the columns at 700px"
<div class="layout">
  <main>
    <p class="eyebrow">Field notes</p>
    <h1>What the rain taught us</h1>
    <p>Three seasons of building outdoor furniture has a way of simplifying your priorities. Water goes where it wants. Timber moves. Metal rusts quietly in the places you cannot see.</p>
    <p>So we changed the finish, raised the feet and stopped pretending that a cushion left outside all winter would be fine.</p>
  </main>
  <aside>
    <h2>Related</h2>
    <p>Choosing a weatherproof finish</p>
    <p>Repairing a split tenon</p>
  </aside>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem 1.25rem;
  }
  main, aside { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: 2rem; letter-spacing: -0.03em; }
  h2 { margin: 0 0 0.75rem; font-size: 1.1rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  aside p:last-child { margin-bottom: 0; }
</style>
--- solution
<div class="layout">
  <main>
    <p class="eyebrow">Field notes</p>
    <h1>What the rain taught us</h1>
    <p>Three seasons of building outdoor furniture has a way of simplifying your priorities. Water goes where it wants. Timber moves. Metal rusts quietly in the places you cannot see.</p>
    <p>So we changed the finish, raised the feet and stopped pretending that a cushion left outside all winter would be fine.</p>
  </main>
  <aside>
    <h2>Related</h2>
    <p>Choosing a weatherproof finish</p>
    <p>Repairing a split tenon</p>
  </aside>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem 1.25rem;
  }
  main, aside { padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  .eyebrow { margin: 0 0 0.35rem; color: #0f766e; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: 2rem; letter-spacing: -0.03em; }
  h2 { margin: 0 0 0.75rem; font-size: 1.1rem; }
  p { margin: 0 0 1rem; color: #475569; line-height: 1.6; }
  aside p:last-child { margin-bottom: 0; }
  @media (max-width: 700px) {
    .layout { grid-template-columns: 1fr; }
  }
</style>
--- test
assertStyle(".layout", "display", "grid", "The layout still needs display: grid.");
const layout = query(".layout");
const columns = getComputedStyle(layout).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 2, "At the 1100px test viewport the layout should still have two columns, but it resolves to " + columns.length + ". Keep the two-column default and add a max-width query.");
let found = false;
for (const sheet of Array.from(document.styleSheets)) {
  let rules;
  try { rules = sheet.cssRules; } catch (error) { continue; }
  for (const rule of Array.from(rules)) {
    if (rule.type !== 4 || !rule.media) continue;
    const match = /max-width\s*:\s*(\d+)px/.exec(rule.media.mediaText);
    if (!match) continue;
    const breakpoint = Number(match[1]);
    if (breakpoint < 650 || breakpoint > 750) continue;
    for (const inner of Array.from(rule.cssRules)) {
      if (!inner.selectorText || !inner.selectorText.includes(".layout")) continue;
      const declarations = inner.style.cssText.replace(/\s+/g, " ");
      if (/grid-template-columns\s*:\s*(1fr|100%|auto|repeat\(\s*1\s*,\s*(?:1fr|100%)\s*\)|minmax\(0(?:px)?,\s*1fr\))/.test(declarations)) found = true;
      if (/display\s*:\s*(block|flex)/.test(declarations)) found = true;
    }
  }
}
assert(found, "At 1100px the layout is two columns, but I could not find a max-width media query near 700px that collapses .layout to one column.");
--- hint
The default should stay as it is. You are adding one rule at the end of the stylesheet.
--- hint
Start with `@media (max-width: 700px) { ... }`, then target `.layout` inside it.
--- hint
Inside the query, set `.layout { grid-template-columns: 1fr; }`. That gives the grid one full-width track.
```

## Challenge: a fluid headline

The headline in this masthead uses a fixed `56px`. It is dramatic on a laptop and too large on a phone. Replace it with a `clamp()` expression that includes a `vw` value in the middle, so it scales with the viewport between a sensible minimum and maximum.

Keep the line height and letter spacing. The tests check that the declaration is fluid, not that you chose one particular size.

```html exercise id=fluid-headline title="A headline that scales"
<header class="masthead">
  <p class="eyebrow">Field notes</p>
  <h1>Big views, small batches, one very long walk.</h1>
  <p class="lede">Notes from a season of building, walking and drinking coffee at the edge of the Peak District.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: 56px;
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 38rem; margin: 0; font-size: 1.1rem; line-height: 1.6; color: #475569; }
</style>
--- solution
<header class="masthead">
  <p class="eyebrow">Field notes</p>
  <h1>Big views, small batches, one very long walk.</h1>
  <p class="lede">Notes from a season of building, walking and drinking coffee at the edge of the Peak District.</p>
</header>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f4f1ea; color: #1f2937; }
  .masthead { max-width: 64rem; margin: 0 auto; padding: 3rem 1.25rem; }
  .eyebrow { margin: 0 0 0.5rem; color: #b45309; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; }
  h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);
    line-height: 1.05;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 38rem; margin: 0; font-size: 1.1rem; line-height: 1.6; color: #475569; }
</style>
--- test
let css = "";
for (const sheet of Array.from(document.styleSheets)) {
  try { css += Array.from(sheet.cssRules).map((rule) => rule.cssText).join("\n"); } catch (error) {}
}
assert(/h1[^{}]*\{[^{}]*font-size\s*:\s*clamp\([^)]*\d+(?:\.\d+)?vw[^)]*\)/i.test(css), "The headline still uses a fixed font-size. Give h1 a clamp() value with a vw term in the middle, such as clamp(2.25rem, 5vw + 1rem, 4.5rem).");
const heading = query("h1");
const size = parseFloat(getComputedStyle(heading).fontSize);
assert(size >= 32 && size <= 96, "The headline computes to " + Math.round(size) + "px at this width, which is outside a comfortable display range. Check the clamp minimum and maximum.");
assertNoOverflow("The headline should wrap inside the masthead, not push the page sideways.");
assertText("h1", "Big views, small batches, one very long walk.", "Keep the headline text exactly as it is.");
--- hint
The value has three parts: a minimum, a preferred size and a maximum. Only the middle one needs `vw`.
--- hint
Try a minimum around `2.25rem`, a preferred value like `5vw + 1rem`, and a maximum around `4.5rem`.
--- hint
Replace `font-size: 56px;` with `font-size: clamp(2.25rem, 5vw + 1rem, 4.5rem);`.
```

## Debug: the photo that pushed the page sideways

This page scrolls sideways on a phone because the hero image has a fixed width of 1200 pixels. The container is capped at 960 pixels, so the image sticks out of the right edge and widens the whole document.

Fix the image so it fits its container without changing its aspect ratio. Do not crop it or hide the overflow; the whole photograph should remain visible.

```html debug id=sideways-photo title="The photo that pushed the page sideways"
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''1600'' height=''900''%3E%3Crect width=''1600'' height=''900'' fill=''%230f172a''/%3E%3Ccircle cx=''1180'' cy=''260'' r=''150'' fill=''%23fbbf24''/%3E%3Cpath d=''M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 960px; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { width: 1200px; height: 700px; border-radius: 16px; }
  .copy { max-width: 38rem; margin-top: 1.5rem; }
  h1 { margin: 0 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
--- solution
<article class="hero">
  <img
    src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''1600'' height=''900''%3E%3Crect width=''1600'' height=''900'' fill=''%230f172a''/%3E%3Ccircle cx=''1180'' cy=''260'' r=''150'' fill=''%23fbbf24''/%3E%3Cpath d=''M0 700 L420 430 L820 720 L1120 500 L1600 760 L1600 900 L0 900 Z'' fill=''%230f766e''/%3E%3C/svg%3E"
    width="1600"
    height="900"
    alt="A dark green ridge beneath a pale sky">
  <div class="copy">
    <h1>Walk further, pack lighter.</h1>
    <p>Routes, kit and coffee for people who prefer the long way round.</p>
  </div>
</article>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 960px; margin: 0 auto; padding: 2rem 1.25rem; }
  .hero img { display: block; width: 100%; max-width: 100%; height: auto; border-radius: 16px; }
  .copy { max-width: 38rem; margin-top: 1.5rem; }
  h1 { margin: 0 0 0.5rem; font-size: 2.2rem; letter-spacing: -0.03em; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
--- test
assertNoOverflow("The page still scrolls sideways. The image is wider than its container.");
const image = query(".hero img");
const hero = query(".hero");
const heroStyle = getComputedStyle(hero);
const contentWidth = hero.getBoundingClientRect().width - parseFloat(heroStyle.paddingLeft) - parseFloat(heroStyle.paddingRight);
const box = image.getBoundingClientRect();
assert(box.width <= contentWidth + 1, "The image renders " + Math.round(box.width) + "px wide inside a " + Math.round(contentWidth) + "px content area. Cap its width instead of fixing it to 1200px.");
assert(box.height > 100, "The image has collapsed to almost no height. Let the browser calculate it from the width.");
const naturalRatio = image.naturalWidth && image.naturalHeight ? image.naturalWidth / image.naturalHeight : 16 / 9;
const renderedRatio = box.width / box.height;
assert(Math.abs(renderedRatio - naturalRatio) < 0.03, "The image is stretched: it renders at " + renderedRatio.toFixed(2) + ":1 instead of its natural " + naturalRatio.toFixed(2) + ":1. Set height: auto.");
--- hint
The problem is the fixed `width: 1200px` and `height: 700px` on the image. A fixed width ignores the container.
--- hint
Use `max-width: 100%` so the image can never be wider than its parent.
--- hint
Set `height: auto` as well, so the image keeps its natural 16:9 shape instead of stretching.
```

> **In the wild:** Responsive images usually go further than `max-width`. The `<picture>` element and `srcset` let the browser choose a smaller file for a smaller screen, which saves bandwidth as well as layout trouble. You will meet those in the advanced course; `max-width: 100%; height: auto` remains the foundation underneath them.

## Recap

- The viewport meta tag makes a phone report its real width; without it, media queries fire at the wrong size.
- Mobile-first means narrow styles first, then `min-width` queries that add columns and space.
- `max-width` queries work the other way: wide styles first, then simplify below a breakpoint.
- Choose breakpoints where *your* content breaks, not at the dimensions of a particular phone.
- `max-width: 100%; height: auto` keeps images inside their container without distortion.
- `clamp(min, preferred, max)` gives display type a readable floor and ceiling; put a `vw` term in the middle.
- A CSS-only navigation can stack on narrow screens and become a row at a wider breakpoint.
- `prefers-reduced-motion: reduce` lets you remove decorative motion without removing function.

**Up next:** interaction polish — hover, focus, transitions and the small states that make a page feel finished.
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_5_4', 'sec_html_css_basics_5', 'crs_html_css_basics', 'Checkpoint: layout & responsive design', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In a flex container with the default settings, which way does the main axis run?","options":["Vertically, top to bottom","Horizontally, left to right in a left-to-right writing mode","Diagonally","It depends on the number of children"],"answerIndex":1,"explanation":"The default `flex-direction` is `row`, so the main axis runs horizontally and items are laid out left to right (in left-to-right writing modes). `justify-content` distributes items along that main axis."},{"id":"q2","prompt":"What is the difference between `justify-content` and `align-items`?","options":["They are aliases","`justify-content` aligns along the main axis; `align-items` aligns along the cross axis","`justify-content` only works in Grid","`align-items` changes the flex direction"],"answerIndex":1,"explanation":"`justify-content` positions items along the main axis (horizontal in a row). `align-items` positions them along the cross axis (vertical in a row). Swap to `flex-direction: column` and those axes swap too."},{"id":"q3","prompt":"Why prefer `gap` over margins between flex items?","options":["`gap` is the only property that works with flexbox","`gap` creates space only between items, without adding outer margins or collapsing","`gap` makes items equal width","`gap` is required for wrapping"],"answerIndex":1,"explanation":"`gap` adds space between tracks/items but not around the outside, and it does not collapse like margins. It keeps spacing logic in the container instead of scattering margin rules across children. Flexbox and Grid both support it."},{"id":"q4","prompt":"What does `flex: 1` on a flex child usually do?","options":["Fixes the child at 1px wide","Lets the child grow and shrink from a zero basis to share available space","Makes the child the first item","Turns the child into a flex container"],"answerIndex":1,"explanation":"`flex: 1` expands to `flex-grow: 1; flex-shrink: 1; flex-basis: 0%`. The zero basis means free space is distributed from the container''s full width, so equal `flex: 1` children tend to end up equal width (subject to min-content limits)."},{"id":"q5","prompt":"`grid-template-columns: repeat(3, 1fr)` creates what?","options":["Three equal-width tracks that share the available space","Three rows of fixed height","One column repeated three times","Three gaps between one column"],"answerIndex":0,"explanation":"`repeat(3, 1fr)` is shorthand for three `1fr` tracks. The `fr` unit distributes the free space after gaps and fixed tracks, so the three columns share the width equally."},{"id":"q6","prompt":"What does `grid-template-columns: repeat(auto-fit, minmax(220px, 1fr))` do?","options":["Always creates exactly 220 columns","Creates as many columns as fit at 220px minimum, then expands them to fill the row","Creates one column that is always 220px","Only works inside a flex container"],"answerIndex":1,"explanation":"`auto-fit` creates as many tracks as fit while respecting the `minmax` minimum, then collapses empty tracks. Each track grows up to `1fr` to fill the row. This is the basis of many responsive card grids without media queries."},{"id":"q7","prompt":"What is the usual advantage of a mobile-first media query?","options":["It loads faster because the CSS file is smaller","It starts with the simplest layout and adds complexity only when there is room","It only works on Android","It removes the need for a viewport meta tag"],"answerIndex":1,"explanation":"Mobile-first CSS starts with the base layout and uses `min-width` queries to enhance it as space increases. That keeps the constrained case simple and avoids undoing desktop styles. It does not remove the need for the viewport meta tag."},{"id":"q8","prompt":"Which rule keeps an image from overflowing its container on a narrow screen?","options":["`img { width: 800px; }`","`img { max-width: 100%; height: auto; }`","`img { position: absolute; }`","`img { display: block; }`"],"answerIndex":1,"explanation":"`max-width: 100%` caps the image at its container''s width, and `height: auto` preserves its aspect ratio. A fixed width larger than the container causes horizontal scrolling. `display: block` can remove inline whitespace but does not make the image responsive."},{"id":"q9","prompt":"What does `font-size: clamp(2rem, 6vw, 4rem)` mean?","options":["The font size is always 6vw","The size scales with the viewport between a 2rem minimum and a 4rem maximum","The size is chosen randomly between 2rem and 4rem","The size is 2rem on mobile and 4rem on desktop, with no values in between"],"answerIndex":1,"explanation":"`clamp(min, preferred, max)` keeps the fluid middle value within the two bounds. Here the preferred size is `6vw`; it never drops below 2rem or rises above 4rem. That produces fluid type without tiny or comically large text."},{"id":"q10","prompt":"Which selector shows a style only when a keyboard user focuses an element, not when it is clicked?","options":["`:hover`","`:active`","`:focus-visible`","`:visited`"],"answerIndex":2,"explanation":"`:focus-visible` matches when the browser judges that focus should be visibly indicated, typically after keyboard navigation. It avoids showing a focus ring after a mouse click while preserving it for keyboard users. Never remove focus styles without providing an equally visible replacement."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_6_1', 'sec_html_css_basics_6', 'crs_html_css_basics', 'Interaction polish: hover, focus and transitions', 'interactive', 0, 1080, NULL, NULL, 'A button that does nothing on hover feels broken. A form field with no visible focus ring is unusable if you cannot use a mouse. Interaction states are how the interface answers the person using it. Hover says *I heard you*. Focus says *you are here*. Active says *the press registered*. Disabled says *not this one, not yet*.

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

Two details make the card solid. The transition sits on the card''s **base** rule, not on `:hover`, so the lift is smooth both entering and leaving. And the focus ring sits on the card rather than the link: `:focus-within` draws it when anything inside receives keyboard focus, which is easier to see than an underline on one word.

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
Delete `.link:focus { outline: none; }`. That restores the browser''s default ring. For a designed ring, replace it with `.link:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }`.
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
Use `.btn:focus-visible { outline: 3px solid #0d9488; outline-offset: 3px; }`. The offset keeps the ring clear of the button''s edge.
```

## Transform moves paint, not the page

`transform` is the workhorse of interface motion because it does not change layout. `translateY(-4px)` shifts painted pixels without reflowing siblings. `margin-top: -4px` or `top: -4px` forces the browser to recalculate the layout, risking a stutter. `opacity` is equally cheap. `width`, `height`, `top` and `left` are not.

The three transforms you will use most:

- `translateY(-4px)` lifts; `translateX(4px)` nudges sideways. Percentages are relative to the element''s own size, so `translateY(-50%)` is a common centring trick.
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
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_6_2', 'sec_html_css_basics_6', 'crs_html_css_basics', 'Project: a personal profile page', 'interactive', 1, 1920, NULL, NULL, 'A capstone is where separate rules stop being exercises and become a page someone could actually use. This one is a personal profile: a page that has to answer three questions in under a minute. Who is this person? What have they made? How do I reach them? Everything else — the colours, the type, the spacing, the motion — exists to make those answers easy to find.

The subject is a fictional design engineer, Mara Okafor. You will build her page in stages, from an empty document to a responsive finish. Each stage adds one layer: structure, then a small design system, then the work grid, then the responsive behaviour that keeps the page readable on a phone. The final page uses semantic landmarks, CSS custom properties, Flexbox, Grid and a mobile-first media query. No JavaScript, no external images and no framework.

## Start with the skeleton

Before a single colour, decide what each part of the page *is*. A profile page has a natural shape:

- A `<header>` with the person''s name and a `<nav>` for the main sections.
- A `<main>` containing the profile introduction, selected work and contact details.
- A `<footer>` with the small print.

Those are landmarks, not styling hooks. A screen reader can jump between them, and a browser can identify the main content without guessing. The navigation gets an `aria-label` because a page can have more than one navigation region; the label tells assistive technology which one this is. Each link points at a real section id, so it works with a keyboard and does not depend on JavaScript.

The profile itself is a `<section>` with an `<h1>` for the name. The work and contact sections get `<h2>` headings. That gives the page a clean outline: one main heading, then two major sections. A section without a heading is just a rectangle; the heading is what makes it navigable.

Here is the skeleton. It is deliberately plain. Run it and use the preview''s phone width: the page already works at every size because it has not committed to a layout yet.

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

> **Tip:** Every `<section>` should have a heading or an accessible name. Here `aria-labelledby` points at the section''s own `<h2>`, which gives the region a name without duplicating text. This is the difference between a page that merely looks structured and one that is structured.

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
assert(name, "The profile needs an h1 with the person''s name.");
assert(normalize(name.textContent).length > 0, "The h1 should contain a name, not be empty.");
assertExists(".profile .avatar", "Add an avatar inside the profile section.");
const avatar = query(".profile .avatar");
assert(avatar.querySelector("svg") || normalize(avatar.textContent).length > 0, "Use initials or an inline SVG inside .avatar.");
assert(!document.querySelector(''.profile img[src^="http"]''), "Use initials or inline SVG instead of a network portrait.");
const avatarStyle = getComputedStyle(avatar);
assert(avatarStyle.width === avatarStyle.height, `The avatar should be square; it is ${avatarStyle.width} by ${avatarStyle.height}.`);
assertExists(".profile .role", "Add a .role line for the person''s title.");
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
      <p>A design system for a members'' club, from type scale to accessible form fields.</p>
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
      <p>A design system for a members'' club, from type scale to accessible form fields.</p>
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
  assert(normalize(link.textContent).length > 0, `Card ${index + 1}''s link needs a visible name.`);
  assert(link.tabIndex >= 0, `Card ${index + 1}''s link should be reachable with Tab.`);
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

The `mailto:` link is not a compromise. It opens the visitor''s mail client, works without a server, and does not pretend to be a form that silently loses messages. If you later add a form, this is still the fallback. The email address is long, so `overflow-wrap: anywhere` lets it break instead of pushing the page sideways on a narrow screen. That one line prevents a whole class of mobile bugs.

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

Two properties prevent most responsive overflow. `min-width: 0` on a flex child allows it to shrink below its content''s intrinsic width; without it, a long word can force the whole row wider than the screen. `overflow-wrap: anywhere` on long links and email addresses lets the text break when there is no other option. Use them together.

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
assertExists(".site-header h1", "Keep the person''s name in an h1");
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
      <article class="card"><p class="index">02</p><h3>Common Room</h3><p>A design system for a members'' club, from type scale to accessible form fields.</p><a href="#common-room">Read the case study</a></article>
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
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_basics_6_3', 'sec_html_css_basics_6', 'crs_html_css_basics', 'Project: a product landing page', 'interactive', 2, 2400, NULL, NULL, 'A landing page has one job: make an offer understandable and the next step obvious. The headline promises, the features supply proof, the pricing lowers the risk, and the signup asks for the smallest possible commitment. A section that does not help one of those jobs is decoration.

The product is **Fieldnote**, a fictional notes app for hikers: offline by default, built around coordinates, and quiet by design. The visual direction is a worn paper map rather than a generic software gradient — warm paper, deep forest green, a single amber accent, a serif display face paired with the system UI font. You will build it in stages: structure, hero, features, pricing, signup and the finished page. No JavaScript, no external images and no framework.

## A landing page is an argument

Start with the sections, not the styling. Each section is a claim, and the headings are the outline of the argument:

- **Header and nav:** who we are and where to go.
- **Hero:** the promise and the primary action.
- **Features:** three reasons to believe the promise.
- **Pricing:** what it costs, in plain language.
- **Signup:** the action, with as little friction as possible.
- **Footer:** the small print and the way back.

The document uses `<header>`, `<main>`, `<section>` and `<footer>`. The hero contains the only `<h1>`. Each later section has an `<h2>`, and each card inside it has an `<h3>`. That outline is what a screen reader user hears when they jump between headings, and it is also a useful test of whether the page''s argument is clear: read only the headings and see if the story still makes sense.

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

Build the hero''s copy and calls to action. Add a `.lede` subhead and two anchors: `.button-primary` for starting and `.button-secondary` for learning more. The primary need strong filled contrast; the secondary needs a visible border. Both need a `:focus-visible` ring and a padding that makes them easy to click.

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
  assert(icon.getAttribute("aria-hidden") === "true" || icon.getAttribute("role") === "presentation", `Feature ${index + 1}''s decorative icon should be hidden from assistive technology.`);
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
  assert(normalize(link.textContent).length > 0, `Plan ${index + 1}''s link needs a visible name.`);
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

The submit button says what happens next: "Create my notebook", not "Submit". It is a real `<button type="submit">` inside the form, because it submits data. The CTA links elsewhere on the page are anchors, because they navigate. This distinction is invisible to most visitors and essential to everyone using a keyboard, a screen reader or a browser''s form autofill.

The layout is a small Flexbox form: the field grows, the button keeps its natural width, and `flex-wrap` stacks them when the line gets tight. The input uses a 1rem font size so iOS does not zoom the page when it receives focus. The focus ring is a light amber that contrasts against the dark forest panel. Nothing here depends on JavaScript; the browser''s native validation is the first pass, and the server must still validate the address.

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

> **Pitfall:** A placeholder is not a label. It disappears as soon as the field has content, it often fails contrast, and it is not reliably announced as the field''s name. Keep the `<label>` visible and use the placeholder only for an example, as here. On a dark panel, make sure the input itself stays light; dark-on-dark form fields are a common contrast failure.

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
', 0, '[]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z'),
('les_html_css_basics_6_4', 'sec_html_css_basics_6', 'crs_html_css_basics', 'Final exam: HTML & CSS Basics', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which element describes the page itself in the browser tab?","options":["`<h1>`","`<title>`","`<header>`","`<meta name=\"description\">`"],"answerIndex":1,"explanation":"`<title>` belongs in `<head>` and names the document in the tab, bookmarks and search results. `<h1>` is the visible page heading, `<header>` is a page/section landmark, and the meta description is used by search engines but is not the tab title."},{"id":"q2","prompt":"Which combination is semantic and accessible for a site navigation bar?","options":["`<div class=\"nav\"><div>Home</div></div>`","`<nav aria-label=\"Main\"><a href=\"/\">Home</a></nav>`","`<menu><span>Home</span></menu>`","`<nav><div onclick=\"go()\">Home</div></nav>`"],"answerIndex":1,"explanation":"`<nav>` is the navigation landmark, an `aria-label` distinguishes multiple navs, and real `<a>` elements are focusable and keyboard-operable. Divs with click handlers are not links, and `<menu>` is for a list of commands, not site navigation."},{"id":"q3","prompt":"Which CSS declaration makes a block element include its padding and border inside its declared width?","options":["`box-sizing: content-box;`","`box-sizing: border-box;`","`display: inline-block;`","`overflow: hidden;`"],"answerIndex":1,"explanation":"`border-box` changes the box model so width and height include content, padding and border. `content-box` is the default and adds padding and border outside the declared width. `inline-block` changes display, not sizing."},{"id":"q4","prompt":"What is the visual result of `margin: 0 auto` on a block with `max-width: 60rem`?","options":["The block is centered horizontally within its container","The block''s text is centered","The block is pinned to the right edge","The block''s height is centered"],"answerIndex":0,"explanation":"Auto left and right margins split the remaining horizontal space, centering the block. `text-align: center` would center the inline content instead. The block needs a definite width or max-width for the auto margins to do anything."},{"id":"q5","prompt":"Which selector has higher specificity: `.card .title` or `#featured .title`?","options":["`.card .title`","`#featured .title`","They are equal","Specificity does not apply to descendant selectors"],"answerIndex":1,"explanation":"`#featured .title` contains one ID and one class, while `.card .title` contains two classes. One ID point beats any number of class points, so the ID selector wins regardless of source order."},{"id":"q6","prompt":"Which layout is the best fit for a page with a header, a sidebar and a main content area that must align in two dimensions?","options":["Flexbox on the body with `flex-wrap: wrap`","CSS Grid with named areas or explicit columns","Absolute positioning for all three regions","A table with three cells"],"answerIndex":1,"explanation":"Grid is designed for two-dimensional layout: columns and rows. Named areas make the page structure explicit and responsive. Flexbox is excellent for one-dimensional rows or columns, but a full page shell with a sidebar is usually clearer in Grid."},{"id":"q7","prompt":"What does `grid-template-columns: repeat(auto-fit, minmax(220px, 1fr))` do?","options":["Creates exactly one 220px column","Creates as many columns as fit at a 220px minimum and lets them grow to fill the row","Creates a fixed 220px gap","Only works with absolutely positioned children"],"answerIndex":1,"explanation":"`auto-fit` fits as many tracks as possible while respecting the `minmax` minimum, then expands them up to `1fr`. This produces a responsive card grid without explicit breakpoints. It is a Grid feature, not a Flexbox one."},{"id":"q8","prompt":"Why is `outline: none` on every focusable element a problem?","options":["It makes the page load slowly","It removes the visible indication of keyboard focus, making navigation impossible for many keyboard users","It changes the element''s width","It disables the element"],"answerIndex":1,"explanation":"The focus indicator tells keyboard users where they are. Removing it without a replacement fails WCAG and makes a page unusable for people who cannot use a mouse. If the default ring clashes with your design, replace it with a clearly visible custom focus style."},{"id":"q9","prompt":"Which rule keeps a responsive image from causing horizontal scrolling?","options":["`img { width: 1200px; }`","`img { max-width: 100%; height: auto; }`","`img { position: fixed; }`","`img { display: inline; }`"],"answerIndex":1,"explanation":"`max-width: 100%` caps the image at the container width, and `height: auto` preserves the aspect ratio. A fixed width wider than the viewport overflows. The other rules do not make the image responsive."},{"id":"q10","prompt":"What does the `alt` attribute provide?","options":["A tooltip that appears on hover","A text alternative for an image when it cannot be seen or when assistive technology reads it","The image''s file name for search engines","A caption below the image"],"answerIndex":1,"explanation":"`alt` is the image''s text alternative. Screen readers announce it, and browsers show it if the image fails to load. It is not a tooltip (`title`) or a visible caption (`figcaption`). Decorative images should use `alt=\"\"`."},{"id":"q11","prompt":"A form input has `id=\"email\"` and its label has `for=\"email\"`. What does this association enable?","options":["The browser validates the email format automatically","Clicking the label focuses the input, and the input gets the label''s text as its accessible name","The input is submitted even if empty","The label is hidden from screen readers"],"answerIndex":1,"explanation":"Matching `for` and `id` links the label to the control. That gives the input an accessible name and makes the label a larger click target. It does not by itself validate the value; that requires `type=\"email\"` and/or validation logic."},{"id":"q12","prompt":"Which approach best respects `prefers-reduced-motion`?","options":["Remove all CSS and JavaScript when it is enabled","Inside the media query, replace large movement with an instant or opacity-only change","Ignore it because it is only a preference","Double the animation duration"],"answerIndex":1,"explanation":"The media query asks for reduced motion, not no interface. Replace large translations, parallax or spinning with instant state changes or short opacity fades. That preserves the interaction while avoiding the motion that can trigger dizziness or nausea."}]', '[]', '2026-06-25T06:04:01.135Z', '2026-10-19T06:04:01.135Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_frontend_engineer', 'crs_html_css_basics', 0);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_html_css_basics_demo', 'usr_student', 'crs_html_css_basics', 'free', 17, 'les_html_css_basics_2_1', '2026-10-20T06:04:01.135Z', NULL, '2026-08-24T06:04:01.135Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_html_css_basics_1_1', 'crs_html_css_basics', 1, 0, '2026-09-03T06:04:01.135Z', '2026-09-03T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_2', 'crs_html_css_basics', 1, 0, '2026-09-04T06:04:01.135Z', '2026-09-04T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_3', 'crs_html_css_basics', 1, 0, '2026-09-05T06:04:01.135Z', '2026-09-05T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_4', 'crs_html_css_basics', 1, 0, '2026-09-06T06:04:01.135Z', '2026-09-06T06:04:01.135Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_html_css_basics_1_2', 'first-page-title', '<!doctype html>
<html lang="en">
  <head>
    <title>Trailhead Coffee</title>
  </head>
  <body>
    <h1>Coffee, without ceremony.</h1>
  </body>
</html>', 1, 2, '2026-09-04T06:04:01.135Z', '2026-09-04T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_2', 'first-page-emphasis', '<p>The bakery is <strong>open</strong> until late <em>today</em>.</p>', 1, 2, '2026-09-04T06:04:01.135Z', '2026-09-04T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_2', 'first-page-unclosed-heading', '<h1>Field notes</h1>
<p>Tuesday was cold, bright and full of sheep.</p>', 1, 2, '2026-09-04T06:04:01.135Z', '2026-09-04T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_3', 'review-quote', '<h2>What people say</h2>
<blockquote cite="https://theweekendtable.example/reviews/moss-and-pine">
  <p>The best bread in Leeds. I drove across the city for a second loaf.</p>
</blockquote>
<p><cite>The Weekend Table</cite>, <time datetime="2026-10-12">12 October 2026</time></p>', 1, 2, '2026-09-05T06:04:01.135Z', '2026-09-05T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_3', 'recipe-ingredients', '<h2>Ingredients</h2>
<ul>
  <li>200 g spaghetti</li>
  <li>1 unwaxed lemon</li>
  <li>2 tbsp <abbr title="extra virgin olive oil">EVOO</abbr></li>
  <li>For the topping
    <ul>
      <li>30 g parmesan, finely grated</li>
      <li>1 tsp cracked black pepper</li>
    </ul>
  </li>
</ul>', 1, 2, '2026-09-05T06:04:01.135Z', '2026-09-05T06:04:01.135Z'),
('usr_student', 'les_html_css_basics_1_3', 'market-list-repair', '<h2>Saturday market</h2>
<ul>
  <li>Sourdough</li>
  <li>Olive oil</li>
  <li>Tomatoes</li>
  <li>Basil</li>
  <li>Garlic</li>
</ul>', 1, 2, '2026-09-05T06:04:01.135Z', '2026-09-05T06:04:01.135Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_basics_1', 'usr_seed00000e', 'crs_html_css_basics', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-22T09:04:01.135Z', '2026-10-22T09:04:01.135Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000e');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_basics_2', 'usr_seed000013', 'crs_html_css_basics', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-20T04:04:01.135Z', '2026-10-20T04:04:01.135Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000013');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_basics_3', 'usr_seed00001n', 'crs_html_css_basics', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-01T13:04:01.135Z', '2026-10-01T13:04:01.135Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_basics_4', 'usr_seed00003q', 'crs_html_css_basics', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-07T15:04:01.135Z', '2026-08-07T15:04:01.135Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003q');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_html_css_basics'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_html_css_basics') WHERE id = 'crs_html_css_basics';
