Every website you have ever used — a bank, a booking app, this course — is a conversation between three languages. **HTML** says what each thing *is*. **CSS** says what it *looks like*. **JavaScript** (later) says what it *does*. This course is about the first two: the layers that decide whether a page is understandable, accessible and pleasant to look at.

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
