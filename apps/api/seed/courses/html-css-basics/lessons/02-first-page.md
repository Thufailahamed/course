A web page is a text file with a very particular grammar. That is the whole trick. The browser reads your file from top to bottom, turns each tag into an element in a tree, and paints the result. You can build a complete, valid page in about ten lines — and once you can see the tree in your head, every layout problem becomes easier to reason about.

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

The browser's default styles make an `h1` larger than an `h2`, and an `h2` larger than a paragraph. That is a useful preview of importance, not a rule you must keep. In lesson 11 you will take full control of the size while keeping the outline correct.

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
The number in the tag is the heading level, and the browser's default stylesheet gives higher-level headings larger type. The *order* on the page does not change that. Later you will replace these defaults with a designed type scale, but the semantic level stays the same.
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
assertExists("p strong", "Wrap the word 'open' in a strong element");
assertText("p strong", "open", "The strong element should contain the word 'open'");
assertExists("p em", "Wrap the word 'today' in an em element");
assertText("p em", "today", "The em element should contain the word 'today'");
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
assertText("h1", "Field notes", "The h1 should contain only the words 'Field notes'");
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
