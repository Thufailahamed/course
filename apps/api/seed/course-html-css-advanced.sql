DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_advanced');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_advanced');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_advanced');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_html_css_advanced');

DELETE FROM discussions WHERE course_id = 'crs_html_css_advanced';

DELETE FROM certificates WHERE course_id = 'crs_html_css_advanced';

DELETE FROM enrollments WHERE course_id = 'crs_html_css_advanced';

DELETE FROM reviews WHERE course_id = 'crs_html_css_advanced';

DELETE FROM wishlist WHERE course_id = 'crs_html_css_advanced';

DELETE FROM path_courses WHERE course_id = 'crs_html_css_advanced';

DELETE FROM coupons WHERE course_id = 'crs_html_css_advanced';

DELETE FROM lessons WHERE course_id = 'crs_html_css_advanced';

DELETE FROM sections WHERE course_id = 'crs_html_css_advanced';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_html_css_advanced';

DELETE FROM courses WHERE id = 'crs_html_css_advanced';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_web-development', 'web-development', 'Web Development', 'HTML, CSS and JavaScript — design and build for the browser.', 'globe', 10);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_html_css_advanced', 'html-css-advanced', 'HTML & CSS Advanced: Systems, Motion & Modern Layout', 'Master the cascade, build resilient layout systems and ship accessible, animated interfaces that hold up in production.', 'Beginner CSS teaches you properties. Advanced CSS teaches you the **system underneath them**: the cascade, formatting contexts, intrinsic sizing, containment and the tiny set of rules that explain a thousand layout bugs.

## Go from "it works on my screen" to "it works everywhere"

- **Real computed styles, real rendering.** Every challenge runs in the browser and is checked against the DOM, so you learn what the engine actually does.
- **The cascade, demystified.** Specificity, inheritance, `@layer`, `:where()` and `!important` — with a decision framework you can use at work.
- **Layout that survives content.** Flexbox and Grid deep dives, including the min-content traps, `minmax()`, `auto-fit` and container queries.
- **Motion with judgement.** Transforms, keyframes, view transitions, timing and reduced-motion support.
- **Accessibility and performance as engineering.** Contrast, focus management, ARIA rules, responsive images, font loading and layout shift.

## Two production-grade capstones

Build a **responsive analytics dashboard** with a sidebar, fluid cards and accessible data tables, then extract the visual language into a **reusable design system** with tokens, components and a dark theme. Both projects are checked by the same DOM assertions used throughout the course.

## Who this is for

If you can make a page but sometimes feel like you are guessing at `z-index`, `min-width: auto`, or why a grid track refuses to shrink, this course is for you.', 'cat_web-development', 'usr_noah', 'advanced', 'English', 0, NULL, 'USD', NULL, NULL, 265, 'published', 0, '["Reason about the cascade, specificity, inheritance and modern cascade layers instead of fighting them","Build themeable interfaces with custom properties, design tokens and dark mode","Use :is(), :where(), :has() and container queries to write smaller, more resilient CSS","Master Flexbox and Grid, including minmax(), auto-fit, named areas and intrinsic sizing","Create motion that feels expensive and respects prefers-reduced-motion","Audit and fix accessibility, focus order, contrast and performance on real pages","Ship a responsive analytics dashboard and a reusable design system"]', '["Comfortable with HTML elements and basic CSS selectors","Our HTML & CSS Basics course, or equivalent experience","A modern browser (Chrome, Safari, Firefox or Edge)"]', '["Front-end developers who can build a page but want to understand why it breaks","Designers moving into design engineering and component work","Full-stack engineers who want to ship polished, accessible interfaces","Anyone preparing for senior front-end interviews or design-system work"]', '["CSS Architecture","Grid","Container Queries","Accessibility","Animation","Design Systems"]', 455, 22, 0, 0, 9860, '2025-06-10T06:04:01.393Z', '2025-05-11T06:04:01.393Z', '2026-10-18T06:04:01.393Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_html_css_advanced_1', 'crs_html_css_advanced', 'The Cascade, Mastered', 0, '2026-06-25T06:04:01.393Z'),
('sec_html_css_advanced_2', 'crs_html_css_advanced', 'Layout Mastery', 1, '2026-06-25T06:04:01.393Z'),
('sec_html_css_advanced_3', 'crs_html_css_advanced', 'Motion & Interaction', 2, '2026-06-25T06:04:01.393Z'),
('sec_html_css_advanced_4', 'crs_html_css_advanced', 'Accessibility & Performance', 3, '2026-06-25T06:04:01.393Z'),
('sec_html_css_advanced_5', 'crs_html_css_advanced', 'Modern CSS & Capstones', 4, '2026-06-25T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_1_1', 'sec_html_css_advanced_1', 'crs_html_css_advanced', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'If you can build a page, you have already met the hard part: HTML and CSS are forgiving enough to let almost anything render. The next level is different. It is not memorizing more properties. It is understanding **why** a layout collapses, why a rule loses, why a component that looked perfect in isolation breaks inside a sidebar, and why an animation that feels delightful to you makes someone else dizzy.

This course is about the system underneath the properties. Every challenge runs in the browser and is checked against the real DOM and real computed styles, so the feedback is the engine''s answer, not an approximation.

## The three questions behind every CSS bug

When something looks wrong, the useful move is not to add another rule. It is to ask:

1. **Which declaration won, and why?** The cascade, specificity, inheritance and layers decide the value that is actually applied.
2. **What formatting context is this box in?** Flex, Grid, block flow and positioning each have their own rules about sizing, alignment and overflow.
3. **What is the available space, and what is the content''s minimum?** Most responsive bugs are a disagreement between a container''s size and the intrinsic size of its contents.

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
- **Predict questions** ask you to commit to the engine''s behaviour before running. Being wrong is useful; the explanation is where the model gets corrected.

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
', 1, '[]', '[{"title":"MDN: CSS cascade and inheritance","url":"https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_cascade"},{"title":"MDN: CSS container queries","url":"https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_queries"},{"title":"WCAG 2.2 quick reference","url":"https://www.w3.org/WAI/WCAG22/quickref/"}]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_1_2', 'sec_html_css_advanced_1', 'crs_html_css_advanced', 'Cascade, specificity and inheritance: the real rules', 'interactive', 1, 1440, NULL, NULL, 'A button has two classes: `button` and `text-muted`. The utility is supposed to mute the label, but the component''s white text wins. Someone adds `!important`. A week later the dark theme cannot override the button without another `!important`, and the design system starts to calcify. The problem was never the button. It was a misunderstanding of the cascade.

CSS is not a list of rules applied from top to bottom. It is a ranking system. For every element and every property, the browser gathers every declaration that could apply, sorts those declarations by a fixed set of criteria, and uses the winner. Once you can name the criteria in order, most "CSS is haunted" moments turn into ordinary debugging.

## The cascade is a ranking, not a fight

A declaration is one property-value pair inside a rule. A rule is a selector plus a block of declarations. Many rules can target the same element, and many declarations can set the same property. The cascade decides which one survives.

The sort happens roughly in this order:

1. **Origin and importance.** User-agent styles, user styles, author styles and `!important` declarations have a defined precedence.
2. **Element-attached styles.** A `style` attribute on the element beats ordinary author selectors.
3. **Cascade layers.** Within an origin, declarations in layers are ordered by layer, not by selector strength.
4. **Specificity.** How strong the selector is.
5. **Source order.** The later declaration wins when everything else ties.

There is also *scope proximity* after specificity, which matters for `@scope`. You can go a long way without it, but knowing it exists prevents the false belief that specificity is always the final tiebreak.

> **Under the hood:** The browser does not compare whole rules. It compares declarations for one property on one element, then moves to the next property. A rule can win `color` and lose `margin` on the same element.

## Origin and importance come first

Every stylesheet has an origin. The browser''s own stylesheet is the **user-agent** origin. A reader''s custom stylesheet is the **user** origin. Your page''s stylesheet is the **author** origin. For normal declarations, author styles beat user styles, and user styles beat user-agent styles. That is why `h1 { color: #0f172a }` overrides the browser''s default heading color.

`!important` does not simply mean "stronger". It changes the origin ordering. For important declarations, the order reverses: important user-agent beats important user, which beats important author. Transitions sit above everything, and animations sit between normal author and important author declarations. This is deliberate. It lets a reader''s accessibility stylesheet override a site that has gone wild with `!important`.

In day-to-day author CSS, the practical summary is: **normal author beats normal user-agent; important author beats normal author; user important beats author important.** The last part is why `!important` is a promise you cannot easily take back.

## Specificity is a three-column score

Specificity is usually written as three numbers: `(ids, classes, types)`.

- **IDs** count in the first column: `#main`.
- **Classes, attributes and pseudo-classes** count in the second: `.card`, `[aria-current]`, `:hover`.
- **Type selectors and pseudo-elements** count in the third: `article`, `::before`.

The universal selector `*` contributes nothing. Combinators like `>`, `+` and `~` contribute nothing. A selector such as `.nav a` scores `(0, 1, 1)`. `.danger` scores `(0, 1, 0)`, so `.nav a` wins even if `.danger` appears later.

| Selector | IDs | Classes / attributes / pseudo-classes | Types / pseudo-elements |
|---|---:|---:|---:|
| `p` | 0 | 0 | 1 |
| `.nav a` | 0 | 1 | 1 |
| `.nav a:hover` | 0 | 1 | 2 |
| `#main .nav a` | 1 | 1 | 1 |
| `:where(#main) a` | 0 | 0 | 1 |

The old "specificity is worth 1000 points" explanation is a convenient lie. A selector with one ID always beats a selector with any number of classes, no matter how the points add up. Compare tuples, not totals.

Modern functional pseudo-classes change the calculation in ways that matter:

- `:is()`, `:not()` and `:has()` take the specificity of their **most specific argument**. `:is(.card, #hero)` scores like `#hero`.
- `:where()` always contributes **zero**, no matter what is inside it.
- `:nth-child()` contributes the pseudo-class itself plus the most specific selector in its `of` list.

Inline styles are not part of the three-column score. They are element-attached declarations and beat ordinary author selectors. An important author declaration still beats a normal inline style, which is one reason `!important` is so disruptive.

```html run
<div class="swatches">
  <p class="note">A class selector</p>
  <p class="note" id="featured">An ID selector</p>
  <p class="note" style="color: #b45309">An inline style</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  p { margin: 0 0 8px; color: #475569; }
  .note { color: #0f766e; }
  #featured { color: #1d4ed8; }
</style>
```

The first paragraph is teal because the class beats the type selector. The second is blue because the ID beats the class. The third is amber because the inline style beats both. If you add `!important` to the class rule, it will beat the inline style and the ID, which is exactly the kind of escalation that makes a stylesheet hard to reason about.

> **Pitfall:** A selector that does not match is irrelevant. `#checkout .button` does not beat `.button` on an element outside `#checkout`; it simply never enters the comparison.

## Layers: ordering by architecture, not selector strength

Cascade layers let you decide which *category* of CSS wins before specificity is considered. Declare the order once:

```css
@layer reset, base, layout, components, utilities;
```

For normal declarations, a later layer beats an earlier layer. Unlayered normal declarations beat every layered declaration. Within a layer, specificity and source order still apply normally. Layers are global to the origin, and the first time a layer name appears establishes its position in the order. A later `@layer utilities { ... }` block does not move utilities to the end if utilities was already declared earlier.

This is the architecture most design systems want: reset first, base element styles next, layout, components, then utilities. A component can use a simple class selector and still beat a utility, because the component layer comes after the utility layer. You are no longer forced to inflate selectors or reach for `!important`.

```html run
<div class="stack">
  <span class="badge muted">Layered component wins</span>
  <span class="badge muted unlayered">Unlayered wins</span>
</div>
<style>
  @layer utilities, components;
  @layer utilities { .muted { color: #64748b; } }
  @layer components {
    .badge { color: #0f766e; background: #ccfbf1; padding: 8px 12px; border-radius: 999px; }
  }
  .unlayered { color: #b45309; background: #fffbeb; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 8px; justify-items: start; }
</style>
```

Both badges carry `.badge` and `.muted`. In the first, the component layer is later than the utility layer, so the component''s teal wins even though `.muted` would win on source order alone. In the second, the unlayered `.unlayered` rule wins because unlayered normal declarations sit above all layers.

`!important` reverses layer order. An important declaration in an earlier layer beats an important declaration in a later layer, and unlayered important declarations are the weakest of the important author declarations. That inversion is intentional: it gives lower-priority layers an escape hatch. It also means layers and `!important` combine into a system that is easy to get wrong if you add importance casually.

```html run
<div class="tag">Which layer wins when both are important?</div>
<style>
  @layer base, theme;
  @layer base { .tag { color: #b91c1c !important; } }
  @layer theme { .tag { color: #0f766e !important; } }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .tag { padding: 10px 14px; background: #fef2f2; border-radius: 8px; }
</style>
```

The text is red. For normal declarations, `theme` is later and would win. For important declarations, the order reverses, so `base` wins. If you remember only one thing about layers: normal order flows forward, important order flows backward.

## Source order is the last tiebreak

When two declarations share an origin, importance, layer and specificity, the one that appears later wins. That is all source order does. It is not a way to make a rule "more important" than a more specific rule.

This is why moving a rule down can fix a bug today and create a different bug tomorrow. Source order is a legitimate tool when the selectors are genuinely equal, but it is a fragile substitute for lowering specificity or organizing layers.

## Inheritance is not the cascade

Some properties inherit from parent to child: `color`, `font-family`, `font-size`, `line-height`, `letter-spacing`, `visibility`, `cursor` and `list-style`. Others do not: `margin`, `padding`, `border`, `background`, `width`, `height`, `display`. An inherited value is not a winning declaration. It is the value an element uses when no declaration wins for that property.

This distinction explains a common confusion. Setting `color` on a section changes every descendant that has no `color` declaration of its own. Setting `border` on the section changes only the section. The child does not get a border unless you ask for one.

Four keywords let you take control:

| Keyword | On an inherited property | On a non-inherited property |
|---|---|---|
| `inherit` | Takes the parent''s computed value | Takes the parent''s computed value |
| `initial` | Resets to the property''s initial value | Resets to the property''s initial value |
| `unset` | Behaves like `inherit` | Behaves like `initial` |
| `revert` | Rolls back to the previous origin | Rolls back to the previous origin |

`initial` is the property''s initial value, not the browser''s default for that element. `display: initial` is `inline`, not `block`, even on a `div`. `revert` is usually what people mean when they want "the browser default back": it discards author declarations and returns to the user-agent or user origin. `revert-layer` rolls back to the previous cascade layer.

```html run
<div class="panel">
  <p class="inherited">Inherited from the panel</p>
  <p class="explicit">Explicitly inherited</p>
  <p class="reset">Reset with initial</p>
  <p class="reverted">Rolled back with revert</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .panel { color: #0f766e; border: 2px solid #0f766e; padding: 16px; }
  p { margin: 0 0 8px; }
  .explicit { color: inherit; }
  .reset { color: initial; }
  .reverted { color: revert; }
</style>
```

The first two paragraphs are teal. The third is black because `color`''s initial value is the canvas text colour. The fourth is also black because `revert` returns to the user-agent colour. If you put `border: initial` on a child, the border disappears; if you put `border: inherit`, the child takes the parent''s border.

> **Pitfall:** `all: unset` looks like a clean reset, but it resets every property, including `display`, and it does not reset custom properties. It is rarely what a component wants. Use targeted resets.

## `:where()` is how you make a reset step aside

A reset should set sensible defaults without outranking the component that uses it. `:where()` is the tool for that. It matches exactly like its argument but contributes zero specificity, so a later class can win without a selector arms race.

```html run
<article class="prose">
  <h2>An ordinary heading</h2>
  <p>Body copy with a little breathing room.</p>
  <h2 class="feature">A featured heading</h2>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose :where(h2) { margin: 0 0 8px; color: #475569; font-size: 1.125rem; }
  .feature { color: #0f766e; font-size: 1.75rem; }
</style>
```

The reset has the specificity of `.prose` alone because `:where(h2)` contributes nothing. `.feature` ties on the class count and comes later, so the featured heading turns teal and grows. Replace `:where(h2)` with `h2` and the reset becomes `.prose h2`, which beats `.feature` and flattens the design. That is the entire argument for `:where()` in a reset.

## Challenge: resolve a conflict without `!important`

The danger link below is supposed to be red. The `.nav a` rule is more specific than `.danger`, so the link stays slate. Fix it without `!important`, and keep the ordinary links slate.

```html exercise id=cascade-danger-link title="Resolve the conflict without !important"
<nav class="nav" aria-label="Account">
  <a href="#journal">Journal</a>
  <a href="#delete" class="danger">Delete account</a>
</nav>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .nav { display: flex; gap: 16px; }
  .nav a { color: #334155; font-weight: 600; }
  .danger { color: #b91c1c; }
  /* TODO: make the danger link red without changing the ordinary links. */
</style>
--- solution
<nav class="nav" aria-label="Account">
  <a href="#journal">Journal</a>
  <a href="#delete" class="danger">Delete account</a>
</nav>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .nav { display: flex; gap: 16px; }
  .nav a { color: #334155; font-weight: 600; }
  .nav a.danger { color: #b91c1c; }
</style>
--- test
assertColor(".nav a:not(.danger)", "color", "#334155", "Ordinary nav links should stay slate.");
assertColor(".nav .danger", "color", "#b91c1c", "The danger link still computes to the nav colour. .nav a scores (0, 1, 1); .danger scores (0, 1, 0). Raise the danger selector''s specificity, or put both rules in layers.");
assertStyle(".nav .danger", "font-weight", "600", "Keep the nav''s font weight; the danger rule should only change colour.");
var css = Array.prototype.map.call(document.querySelectorAll("style"), function (sheet) { return sheet.textContent; }).join("\n");
assert(!/!important/.test(css), "Solve this with specificity or source order, not !important. The test can see it in the stylesheet.");
--- hint
Compare the two selectors as tuples. `.nav a` is (0, 1, 1); `.danger` is (0, 1, 0).
--- hint
A selector such as `.nav a.danger` scores (0, 2, 1) and still only targets the danger link.
--- hint
Change `.danger` to `.nav a.danger`, or put both the nav rule and the danger rule in layers and make the danger layer later.
```

## Challenge: let a component override a utility with layers

The heading and the eyebrow both use the `.text-muted` utility. The component''s `.card-title` rule is in the `components` layer, but the utility is in a later layer, so the heading is muted. Establish the layer order so components beat utilities, without removing either rule from its layer.

```html exercise id=cascade-layer-order title="Put components above utilities"
<div class="card">
  <p class="eyebrow text-muted">Design system</p>
  <h2 class="card-title text-muted">A component should win</h2>
</div>
<style>
  @layer components {
    .card-title { color: #0f172a; }
  }
  @layer utilities {
    .text-muted { color: #64748b; }
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .card { max-width: 28rem; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; }
  .eyebrow { margin: 0 0 6px; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .card-title { margin: 0; font-size: 1.5rem; }
  /* TODO: declare the layer order so components outrank utilities. */
</style>
--- solution
<div class="card">
  <p class="eyebrow text-muted">Design system</p>
  <h2 class="card-title text-muted">A component should win</h2>
</div>
<style>
  @layer utilities, components;
  @layer components {
    .card-title { color: #0f172a; }
  }
  @layer utilities {
    .text-muted { color: #64748b; }
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .card { max-width: 28rem; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px; }
  .eyebrow { margin: 0 0 6px; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .card-title { margin: 0; font-size: 1.5rem; }
</style>
--- test
assertColor(".card-title", "color", "#0f172a", "The card title is still muted. The utilities layer is currently later than components, so .text-muted wins the normal cascade.");
assertColor(".eyebrow", "color", "#64748b", "The eyebrow should still use the muted utility. Keep both rules in their layers.");
assertStyle(".card-title", "font-size", "24px", "Keep the title size; this challenge is about layer order, not typography.");
--- hint
A layer''s order is set the first time its name appears. You can declare both names before either block.
--- hint
`@layer utilities, components;` puts utilities first and components last.
--- hint
Put that statement at the top of the stylesheet, then check that `.text-muted` still styles the eyebrow.
```

## Debug: the callout that lost to an ID

The callout''s text should be amber, but it is slate. The panel''s `#sidebar p` rule is more specific than `.callout`, so the intended colour never wins. Fix the cascade without deleting the panel''s base text styles.

```html debug id=cascade-sidebar-note title="The callout that lost to an ID"
<aside id="sidebar" class="sidebar">
  <p class="callout">Your export is ready. <a href="#download">Download it</a>.</p>
</aside>
<style>
  #sidebar p { color: #475569; line-height: 1.6; }
  .callout { color: #b45309; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- solution
<aside id="sidebar" class="sidebar">
  <p class="callout">Your export is ready. <a href="#download">Download it</a>.</p>
</aside>
<style>
  .sidebar :where(p) { color: #475569; line-height: 1.6; }
  .callout { color: #b45309; background: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- test
assertColor(".callout", "color", "#b45309", "The callout text is still slate. #sidebar p scores (1, 0, 1); .callout scores (0, 1, 0), so the ID rule wins before source order matters.");
assertColor(".callout", "background-color", "#fffbeb", "Keep the callout background; only the text colour is losing.");
assertStyle(".callout", "border-left-width", "4px", "Keep the amber border on the callout.");
var lineHeight = parseFloat(getComputedStyle(query(".callout")).lineHeight);
assert(lineHeight > 20, "Keep the panel''s comfortable line-height; it currently computes to " + lineHeight + "px.");
--- hint
Run it and compare the callout''s computed colour with the colour you wrote. The background and border work; only `color` is being overridden.
--- hint
The competing selector contains an ID. Either lower its specificity or raise the callout''s specificity.
--- hint
Changing `#sidebar p` to `.sidebar :where(p)` drops the ID weight while keeping the base text styles. `#sidebar .callout` also works.
```

## Predict: which declaration wins?

Read the layer order, then choose the colour of the paragraph. The answer is decided by the layer step, not by which rule looks most specific.

```html predict id=cascade-predict-unlayered title="Which colour reaches the paragraph?"
<article class="card">
  <p class="tag">Which colour wins?</p>
</article>
<style>
  @layer base, theme;
  @layer theme { p { color: #0f766e; } }
  @layer base { p { color: #b91c1c; } }
  p { color: #1d4ed8; }
</style>
--- options
* Blue
Red
Teal
It depends on the order of the two @layer blocks
--- explain
Unlayered normal author declarations beat every layered normal declaration, regardless of specificity or source order. The unlayered `p` rule wins, so the text is blue. If the unlayered rule disappeared, layer order would decide: `base` comes before `theme`, so `theme` would win and the text would be teal. The ordering of the blocks themselves does not reorder the layers; the `@layer base, theme;` statement does.
```

## Recap

- The cascade sorts declarations by origin and importance, then element-attached styles, then layers, then specificity, then source order.
- Specificity is a tuple of IDs, classes/attributes/pseudo-classes, and types/pseudo-elements. Compare it column by column.
- `:is()`, `:not()` and `:has()` adopt their most specific argument; `:where()` contributes zero.
- Normal layers flow forward: later layers win. Important layers flow backward, and unlayered important declarations are weakest.
- Inheritance is separate from the cascade. `inherit`, `initial`, `unset` and `revert` let you choose where a value comes from.
- `!important` is not a fix for a specificity problem. It changes the origin ordering and makes every later override harder.

**Up next:** custom properties and design tokens — how to make one declaration drive a theme, a component and a spacing scale without repeating yourself.
', 1, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_1_3', 'sec_html_css_advanced_1', 'crs_html_css_advanced', 'Custom properties and design tokens', 'interactive', 2, 1320, NULL, NULL, 'The first dark mode is usually a pile of overrides. Every card, button and border gets a second rule, and the two sets drift apart within a month. The second dark mode is a handful of custom properties: one set on `:root`, one set on `.theme-dark`, and every component reads from the same names.

Custom properties are the part of CSS that behaves most like a programming language, but they are still CSS. They cascade, they inherit, and they can be scoped to a subtree. Understanding that model is the difference between a token system that scales and a drawer full of names nobody trusts.

## A custom property is a named value

A custom property is a declaration whose name starts with two hyphens:

```css
:root {
  --color-accent: #0f766e;
  --space-2: 8px;
}
```

Read it with `var()`:

```css
.button {
  background: var(--color-accent);
  padding: var(--space-2) calc(var(--space-2) * 2);
}
```

That is the whole syntax. The important part is the semantics. A custom property is not a Sass variable that disappears at build time. It lives on an element, participates in the cascade, and inherits to descendants by default. If three ancestors declare `--color-accent`, the nearest ancestor with a winning declaration supplies the value for that subtree.

Names are case-sensitive: `--color-accent` and `--Color-Accent` are different tokens. Values are stored as token streams, not as typed values. A custom property can hold a colour, a length, a shadow, a font stack, or a fragment such as `1px solid currentColor`. It cannot be concatenated into a property name, and a stored declaration fragment cannot be expanded into a declaration; `--rule: color: red` is just a string of tokens, not something CSS will apply.

```html run
<div class="cards">
  <article class="card" style="--accent: #0f766e">
    <p class="eyebrow">Field notes</p>
    <h2>Ridge trail</h2>
    <a href="#">Read the entry</a>
  </article>
  <article class="card" style="--accent: #b45309">
    <p class="eyebrow">Workshop</p>
    <h2>Joint geometry</h2>
    <a href="#">See the bench</a>
  </article>
  <article class="card">
    <p class="eyebrow">No accent</p>
    <h2>Fallback card</h2>
    <a href="#">Default link</a>
  </article>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; max-width: 880px; }
  .card { padding: 16px; border: 1px solid #e2e8f0; border-top: 4px solid var(--accent, #94a3b8); border-radius: 12px; background: #fff; }
  .eyebrow { margin: 0 0 4px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent, #64748b); }
  .card h2 { margin: 0 0 8px; font-size: 1.1rem; }
  .card a { color: var(--accent, #475569); font-weight: 600; }
</style>
```

The two inline `--accent` declarations are inherited by the card''s heading, eyebrow and link. The third card has no `--accent`, so every `var()` falls back to its second argument. Notice that the token is declared once on the card and consumed in three places. That is the first useful property of tokens: one decision, many consumers.

> **Under the hood:** `var()` substitution happens at computed-value time. The custom property itself is computed first, then the substitution happens for the property that uses it. If the substituted result is invalid for that property, the declaration becomes invalid at computed-value time.

## Global tokens belong on `:root`

`:root` matches the document''s root element, normally `<html>`. It is the highest point in the inheritance tree, so a token declared there is available everywhere unless a closer ancestor overrides it. That makes it the right place for the small set of decisions that define the product: surface, text, accent, border, radius, and a spacing scale.

Name tokens by role, not by value. `--color-surface` survives a rebrand; `--color-white` becomes a lie the moment the dark theme uses it. `--space-2` is stable across density modes; `--padding-16` is a number pretending to be a decision.

There are two common tiers:

- **Primitive tokens** describe the raw palette and scale: `--teal-700`, `--slate-100`, `--space-4`.
- **Semantic tokens** describe how the product uses them: `--color-accent`, `--color-surface`, `--color-text-muted`.

Components should consume semantic tokens. Primitives are an implementation detail of the theme. If every component reads `--teal-700` directly, a theme change becomes a search-and-replace exercise.

> **Pitfall:** Token soup. A token for every property on every component feels systematic and is usually the opposite. If a value appears once and never themes, write the value. Tokenise decisions that repeat, that need to change together, or that form a public API for other components.

A useful test is to ask what would change if the value changed. If the answer is "nothing outside this one card", it is a local value, not a global token. If the answer is "the whole product shifts", it is a semantic token. If the answer is "the palette changes but the role does not", it is a primitive that should probably be hidden behind a semantic token. That test keeps the token set small enough to read.

Names should describe the job, not the colour or size. `--color-surface` can be white in the light theme and near-black in the dark theme. `--space-3` can be 12px in a compact theme and 16px in a comfortable one. A token named `--color-white` cannot survive either change without becoming false. The same rule applies to component tokens: `--button-bg` is a role; `--button-teal` is a value that will not age well.

Here is the same panel in two themes. The markup is identical; only the token values change.

```html run
<div class="themes">
  <section class="surface">
    <p class="label">Light</p>
    <h2>Monthly report</h2>
    <p>Revenue is up 12% against the same week last month.</p>
    <button type="button">Export</button>
  </section>
  <section class="surface theme-dark">
    <p class="label">Dark</p>
    <h2>Monthly report</h2>
    <p>Revenue is up 12% against the same week last month.</p>
    <button type="button">Export</button>
  </section>
</div>
<style>
  :root {
    --color-surface: #ffffff;
    --color-ink: #0f172a;
    --color-muted: #64748b;
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
  }
  .theme-dark {
    --color-surface: #0f172a;
    --color-ink: #e2e8f0;
    --color-muted: #94a3b8;
    --color-accent: #5eead4;
    --color-on-accent: #042f2e;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #e2e8f0; }
  .themes { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; max-width: 880px; }
  .surface { padding: 20px; border-radius: 16px; background: var(--color-surface); color: var(--color-ink); }
  .label { margin: 0 0 6px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--color-muted); }
  .surface h2 { margin: 0 0 8px; font-size: 1.25rem; }
  .surface p { margin: 0 0 16px; line-height: 1.5; }
  .surface button { border: 0; border-radius: 8px; padding: 8px 14px; background: var(--color-accent); color: var(--color-on-accent); font: inherit; font-weight: 600; }
</style>
```

The `.theme-dark` class does not restyle the panel''s children. It redefines four tokens on the section, and the children inherit the new values. This is why a theme can be a class on any subtree, not just on `<body>`.

That override is just the cascade. `--color-accent` on `.theme-dark` is an ordinary declaration that wins for that element and inherits to its descendants. If a component declares its own `--color-accent`, that declaration wins for the component''s subtree, which is exactly how a one-off accent can coexist with a theme. If someone puts `!important` on a root token, it jumps ahead of the ordinary theme override and the theme stops working. Treat tokens as declarations, not as constants.

> **Tip:** When a token "has the wrong value", walk up the DOM from the element that uses it and look for the nearest ancestor with a winning declaration. The problem is almost always scope, not `var()`.

## Fallbacks cover missing tokens, not invalid values

`var(--token, fallback)` uses the fallback when the custom property is not defined, or when its value is the guaranteed-invalid value. A nested fallback is allowed:

```css
color: var(--chip-ink, var(--color-ink, #0f172a));
```

The fallback is not a safety net for a token that exists but has an invalid value. If `--gap: 12` is defined and you write `gap: var(--gap, 16px)`, the substitution produces `gap: 12`, which is invalid. The declaration becomes invalid at computed-value time and `gap` falls back to its initial value, **not** to `16px`. The fallback is for absence, not for bad data.

This matters when tokens come from a CMS, a theme editor, or a component API. Validate values at the point where they enter the system; do not expect `var()` to repair them.

```html run
<div class="chips">
  <span class="chip">Default</span>
  <span class="chip" style="--chip-bg: #ccfbf1; --chip-ink: #0f766e; --chip-pad: 6px 10px">Custom</span>
  <span class="chip" style="--chip-bg: #fef3c7">Partial</span>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .chips { display: flex; gap: 8px; }
  .chip { padding: var(--chip-pad, 8px 14px); background: var(--chip-bg, #e2e8f0); color: var(--chip-ink, #0f172a); border-radius: 999px; font-weight: 600; }
</style>
```

The second chip overrides all three tokens. The third overrides only the background, so the padding and ink come from fallbacks. The first uses all three fallbacks. That is the intended use of `var()` fallbacks: optional overrides with a sensible baseline.

Custom properties are values, not a general-purpose preprocessor. They cannot appear in selectors, property names, or at-rule conditions. `@media (min-width: var(--breakpoint))` does not work, because the media query is parsed before custom properties are resolved. Breakpoints have to be literals, or generated by a build step. The same parse-time boundary applies anywhere CSS needs a concrete value before the cascade runs.

That boundary is useful. Tokens are for values that flow through the DOM: colours, spacing, radii, shadows, type sizes, component states. They are not a way to make CSS Turing-complete. Keeping them at the value layer is what makes them predictable.

## Scope component tokens to the component

Global semantic tokens are the theme. Component tokens are the component''s API. A button can define its own defaults and let variants override only the tokens:

```css
.button {
  --button-bg: var(--color-accent);
  --button-ink: var(--color-on-accent);
  background: var(--button-bg);
  color: var(--button-ink);
}

.button--danger {
  --button-bg: var(--color-danger);
  --button-ink: var(--color-on-danger);
}
```

The component''s rules never change. The variant changes two values, and every descendant that reads those tokens follows. This pattern keeps variants from turning into a matrix of property overrides.

There is a scoping rule hiding in that example. A custom property declared on `.button` is inherited by the button''s children, but not by its siblings. If you declare `--button-bg` on a toolbar and the button is outside the toolbar, the button never sees it. That is not a bug in custom properties; it is the same inheritance model as `color`.

```html run
<div class="row">
  <button class="btn" type="button">Save</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--danger" type="button">Delete</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
</div>
<style>
  :root {
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
    --color-danger: #b91c1c;
    --color-on-danger: #ffffff;
    --color-ink: #0f172a;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 8px; flex-wrap: wrap; }
  .btn {
    --btn-bg: var(--color-accent);
    --btn-ink: var(--color-on-accent);
    --btn-border: transparent;
    background: var(--btn-bg);
    color: var(--btn-ink);
    border: 2px solid var(--btn-border);
    border-radius: 10px;
    padding: 10px 16px;
    font: inherit;
    font-weight: 600;
  }
  .btn--secondary { --btn-bg: #e2e8f0; --btn-ink: var(--color-ink); }
  .btn--danger { --btn-bg: var(--color-danger); --btn-ink: var(--color-on-danger); }
  .btn--ghost { --btn-bg: transparent; --btn-ink: var(--color-ink); --btn-border: #cbd5e1; }
</style>
```

Only the token declarations differ between variants. The background, text colour and border rules are written once. That is the shape of a maintainable component API: properties are stable, tokens are the variation points.

## Typed properties with `@property`

By default a custom property is untyped and inherits. `@property` lets you register it with a syntax, an initial value, and an inheritance rule:

```css
@property --lift {
  syntax: "<length>";
  inherits: false;
  initial-value: 0px;
}
```

Three things change. The browser validates assigned values against the syntax; an invalid value falls back to the initial value instead of poisoning the property. The initial value is well defined even when nothing sets the token. And `inherits: false` stops the value from leaking into descendants, which is useful for component-local state.

Registered properties can also be animated. That is the feature that makes `transition: --lift 180ms` meaningful; unregistered custom properties cannot be interpolated.

```html run
<div class="lift-row">
  <article class="lift-card" tabindex="0">
    <p class="eyebrow">Typed property</p>
    <h2>Hover or focus me</h2>
    <p>The card lifts by a registered length.</p>
  </article>
</div>
<style>
  @property --lift {
    syntax: "<length>";
    inherits: false;
    initial-value: 0px;
  }
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .lift-row { display: flex; justify-content: center; }
  .lift-card {
    --lift: 0px;
    width: 300px;
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #ffffff;
    transform: translateY(calc(var(--lift) * -1));
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.08);
    transition: --lift 180ms ease, box-shadow 180ms ease;
  }
  .lift-card:hover, .lift-card:focus-visible {
    --lift: 6px;
    box-shadow: 0 12px 24px rgb(15 23 42 / 0.14);
  }
  .eyebrow { margin: 0 0 6px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #0f766e; }
  .lift-card h2 { margin: 0 0 6px; font-size: 1.15rem; }
  .lift-card p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

> **In the wild:** Design systems often expose component tokens as documented custom properties. A button might accept `--button-bg`, `--button-ink` and `--button-radius` without ever exposing its internal padding or border styles. That is a contract, not an implementation detail.

Registration is a commitment. The `syntax` descriptor uses the same value grammar as CSS: `<length>`, `<color>`, `<number>`, `<percentage>`, `<angle>` and so on. The initial value must match the syntax, and `inherits` should be stated explicitly because it changes how the value moves through the tree. A browser that does not understand `@property` ignores the registration and treats the token as unregistered, so keep a `var()` fallback if you still support an older engine.

## Challenge: build a themeable button with semantic tokens

Two panels should share one button component. The light panel uses the default tokens; the dark panel overrides them. Define `--color-surface`, `--color-text`, `--color-accent` and `--color-on-accent` on `:root`, override those tokens in `.theme-dark`, and make both the panel and the button read from those names.

```html exercise id=tokens-themeable-button title="A button that follows its theme"
<div class="panel">
  <p class="eyebrow">Light</p>
  <button class="btn" type="button">Save changes</button>
</div>
<div class="panel theme-dark">
  <p class="eyebrow">Dark</p>
  <button class="btn" type="button">Save changes</button>
</div>
<style>
  /* Target palette
     light: surface #f8fafc, text #0f172a, accent #0f766e, on-accent #ffffff
     dark:  surface #0f172a, text #e2e8f0, accent #5eead4, on-accent #042f2e
     TODO: define the semantic tokens on :root, override them in .theme-dark,
     then make .panel and .btn consume the tokens. */
  .panel { padding: 20px; background: #f8fafc; color: #0f172a; }
  .btn { border: 0; border-radius: 999px; padding: 12px 20px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 16px; max-width: 420px; }
  .eyebrow { margin: 0 0 10px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
</style>
--- solution
<div class="panel">
  <p class="eyebrow">Light</p>
  <button class="btn" type="button">Save changes</button>
</div>
<div class="panel theme-dark">
  <p class="eyebrow">Dark</p>
  <button class="btn" type="button">Save changes</button>
</div>
<style>
  :root {
    --color-surface: #f8fafc;
    --color-text: #0f172a;
    --color-accent: #0f766e;
    --color-on-accent: #ffffff;
  }
  .theme-dark {
    --color-surface: #0f172a;
    --color-text: #e2e8f0;
    --color-accent: #5eead4;
    --color-on-accent: #042f2e;
  }
  .panel { padding: 20px; background: var(--color-surface); color: var(--color-text); }
  .btn { border: 0; border-radius: 999px; padding: 12px 20px; background: var(--color-accent); color: var(--color-on-accent); font: inherit; font-weight: 600; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 16px; max-width: 420px; }
  .eyebrow { margin: 0 0 10px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
</style>
--- test
function tokenColor(selector, name) {
  var value = getComputedStyle(query(selector)).getPropertyValue(name).trim();
  assert(value, "Define " + name + " on " + selector + " so the button can inherit it.");
  var probe = document.createElement("span");
  probe.style.color = value;
  document.body.appendChild(probe);
  var result = getComputedStyle(probe).color;
  probe.remove();
  return result;
}
assertColor(".theme-dark .btn", "background-color", "#5eead4", "The dark button is still teal. Override --color-accent on .theme-dark; the button should inherit the new value.");
assertColor(".theme-dark .btn", "color", "#042f2e", "The dark button label should use --color-on-accent. It currently reads " + getComputedStyle(query(".theme-dark .btn")).color + ".");
assertColor(".panel:not(.theme-dark) .btn", "background-color", "#0f766e", "The light button should keep the default accent.");
assertColor(".panel:not(.theme-dark) .btn", "color", "#ffffff", "The light button label should stay white.");
assertColor(".theme-dark", "background-color", "#0f172a", "The dark panel is still light. Make .panel read --color-surface.");
assert(tokenColor(":root", "--color-surface") === "rgb(248, 250, 252)", "Set --color-surface on :root to #f8fafc; the token should resolve to rgb(248, 250, 252).");
assert(tokenColor(".theme-dark", "--color-accent") === "rgb(94, 234, 212)", "Override --color-accent in .theme-dark with #5eead4 so descendants inherit it.");
--- hint
Start with the two token blocks. `:root` holds the light values; `.theme-dark` overrides the same names with dark values.
--- hint
The button should not contain any literal theme colours after the refactor. `background` and `color` should read `var(--color-accent)` and `var(--color-on-accent)`.
--- hint
Set `--color-surface` to `#f8fafc` on `:root` and `#0f172a` on `.theme-dark`. Then give `.panel` `background: var(--color-surface)` and `color: var(--color-text)`.
```

## Challenge: build a compact spacing scale

The invoice currently uses ad-hoc spacing values. Define a four-step scale on `:root` — `--space-1: 4px`, `--space-2: 8px`, `--space-3: 16px`, `--space-4: 24px` — then use it for the card padding, the heading''s bottom margin, the paragraph''s bottom margin and the button''s padding.

```html exercise id=tokens-spacing-scale title="One scale, four decisions"
<section class="invoice">
  <h2>Invoice #1042</h2>
  <p>Due on 30 October. Late payments attract a 2% fee.</p>
  <button class="pay" type="button">Pay invoice</button>
</section>
<style>
  /* TODO: define --space-1 through --space-4 on :root,
     then use the scale below. */
  .invoice { padding: 20px; }
  .invoice h2 { margin: 0 0 12px; }
  .invoice p { margin: 0 0 20px; }
  .invoice .pay { padding: 10px 18px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .invoice { max-width: 420px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; }
  .invoice h2 { font-size: 1.25rem; }
  .invoice p { color: #475569; line-height: 1.5; }
  .invoice .pay { border: 0; border-radius: 8px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
</style>
--- solution
<section class="invoice">
  <h2>Invoice #1042</h2>
  <p>Due on 30 October. Late payments attract a 2% fee.</p>
  <button class="pay" type="button">Pay invoice</button>
</section>
<style>
  :root {
    --space-1: 4px;
    --space-2: 8px;
    --space-3: 16px;
    --space-4: 24px;
  }
  .invoice { padding: var(--space-4); }
  .invoice h2 { margin: 0 0 var(--space-2); }
  .invoice p { margin: 0 0 var(--space-3); }
  .invoice .pay { padding: var(--space-2) var(--space-3); }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .invoice { max-width: 420px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 14px; }
  .invoice h2 { font-size: 1.25rem; }
  .invoice p { color: #475569; line-height: 1.5; }
  .invoice .pay { border: 0; border-radius: 8px; background: #0f766e; color: #ffffff; font: inherit; font-weight: 600; }
</style>
--- test
function space(name, expected) {
  var actual = getComputedStyle(query(":root")).getPropertyValue(name).trim();
  assert(actual === expected, "Set " + name + " to " + expected + " on :root; it currently reads " + (actual || "nothing") + ".");
}
space("--space-1", "4px");
space("--space-2", "8px");
space("--space-3", "16px");
space("--space-4", "24px");
assertStyle(".invoice", "padding", "24px", "The invoice should use the largest step for its padding.");
assertStyle(".invoice h2", "margin-bottom", "8px", "The heading should sit 8px above the paragraph.");
assertStyle(".invoice p", "margin-bottom", "16px", "The paragraph should leave 16px before the button.");
assertStyle(".invoice .pay", "padding", "8px 16px", "The button padding should use two steps from the scale.");
--- hint
The scale is a vocabulary, not a set of names for specific properties. `--space-2` means "one small step", wherever that step is needed.
--- hint
Use `var(--space-4)` for the card padding, `var(--space-2)` under the heading, and `var(--space-3)` under the paragraph.
--- hint
The button uses two tokens: `padding: var(--space-2) var(--space-3);` gives 8px top/bottom and 16px left/right.
```

## Debug: the token declared on the wrong branch

The Preview button inside the toolbar is styled correctly. The Save button below it is transparent. The tokens are declared on `.toolbar`, but the Save button is a sibling of the toolbar, not a descendant, so it never inherits them. Move the tokens somewhere both buttons can see, without hard-coding the values on each button.

```html debug id=tokens-orphan-variable title="The token that never arrived"
<div class="toolbar">
  <span class="toolbar-label">Workspace</span>
  <button class="btn" type="button">Preview</button>
</div>
<button class="btn" type="button">Save changes</button>
<style>
  .toolbar {
    --btn-bg: #0f766e;
    --btn-ink: #ffffff;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    background: #f1f5f9;
    border-radius: 10px;
  }
  .btn {
    border: 0;
    border-radius: 8px;
    padding: 10px 16px;
    background: var(--btn-bg, transparent);
    color: var(--btn-ink, #0f172a);
    font: inherit;
    font-weight: 600;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; justify-items: start; }
</style>
--- solution
<div class="toolbar">
  <span class="toolbar-label">Workspace</span>
  <button class="btn" type="button">Preview</button>
</div>
<button class="btn" type="button">Save changes</button>
<style>
  :root {
    --btn-bg: #0f766e;
    --btn-ink: #ffffff;
  }
  .toolbar {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    background: #f1f5f9;
    border-radius: 10px;
  }
  .btn {
    border: 0;
    border-radius: 8px;
    padding: 10px 16px;
    background: var(--btn-bg, transparent);
    color: var(--btn-ink, #0f172a);
    font: inherit;
    font-weight: 600;
  }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; justify-items: start; }
</style>
--- test
assertColor(".toolbar .btn", "background-color", "#0f766e", "The Preview button inside the toolbar should keep its teal background.");
assertColor("body > .btn", "background-color", "#0f766e", "The standalone Save button is transparent. A custom property on .toolbar cannot reach a sibling element.");
assertColor("body > .btn", "color", "#ffffff", "The standalone button''s label is still dark. Its ink token has the same scoping problem.");
var inherited = getComputedStyle(query("body > .btn")).getPropertyValue("--btn-bg").trim();
assert(inherited !== "", "The standalone button still has no --btn-bg in scope. Move the token to a shared ancestor, or declare it on .btn itself.");
--- hint
Custom properties inherit down the tree. Walk from the Save button up to the nearest ancestor that declares `--btn-bg`. There isn''t one.
--- hint
`body` and `:root` are ancestors of both buttons. Move the two token declarations there.
--- hint
You can also declare `--btn-bg` and `--btn-ink` on `.btn`, but then the toolbar cannot override them for a variant without a more specific selector.
```

## Predict: what does the badge inherit?

The badge has no `--tone` of its own. Read the nested structure and choose the colour it will use.

```html predict id=tokens-predict-inheritance title="Which tone reaches the badge?"
<div class="outer" style="--tone: #0f766e">
  <div class="middle" style="--tone: #b45309">
    <div class="inner">
      <span class="badge">Status</span>
    </div>
  </div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .badge { color: var(--tone, #64748b); font-weight: 700; }
</style>
--- options
* Amber
Teal
Slate
It depends on which declaration appears first in the stylesheet
--- explain
Custom properties are inherited. The badge looks up the tree and finds the nearest ancestor with a winning `--tone` declaration, which is `.middle` with `#b45309`. The outer teal value is farther away and loses. Source order is irrelevant because the two declarations are on different elements. If the middle token were removed, the badge would inherit teal; if both were removed, it would use the slate fallback.
```

## Recap

- A custom property is a cascading, inheriting value, not a build-time variable. Read it with `var()`.
- Put global semantic tokens on `:root`, and override them on a theme class to re-skin a subtree.
- Fallbacks cover a missing token, not a token whose value is invalid for the property.
- Scope component tokens to the component or a shared ancestor. Siblings do not inherit from each other.
- Name tokens by role (`--color-surface`) rather than value (`--color-white`), and avoid token soup.
- Register a custom property with `@property` when you need validation, a reliable initial value, no inheritance, or animation.

**Up next:** modern selectors — `:is()`, `:where()`, `:has()` and the relational patterns that remove state classes and specificity fights.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_1_4', 'sec_html_css_advanced_1', 'crs_html_css_advanced', 'Modern selectors: :is(), :where(), :has() and relational CSS', 'interactive', 3, 1320, NULL, NULL, 'A form row can turn red when the input inside it is invalid. A card can grow a shadow only when it contains an image. A navigation link can style itself from `aria-current="page"` without a single class toggle. None of this needs JavaScript, and none of it needs a selector that repeats the entire ancestor chain.

Modern selectors are relational. They let CSS ask questions about structure and state, then style the element that answers. The result is less markup, fewer state classes, and fewer specificity accidents. The trade-off is that you need to know exactly which element a selector is matching.

## `:is()` groups selectors without repeating the ancestor

Before `:is()`, styling several headings inside an article looked like this:

```css
.post h2,
.post h3,
.post h4 { color: #0f766e; }
```

With `:is()`:

```css
.post :is(h2, h3, h4) { color: #0f766e; }
```

The matching behaviour is the same. The difference is maintenance and specificity. `:is()` takes the specificity of its **most specific argument**. If one argument is an ID, the whole `:is()` scores like that ID, even for elements that match a type selector. That is usually a reason to keep IDs out of `:is()`.

| Selector | Specificity | Why |
|---|---|---|
| `.post :is(h2, .lead)` | `(0, 2, 0)` | `.post` plus the most specific argument, `.lead` |
| `.post :where(h2, #lead)` | `(0, 1, 0)` | `:where()` contributes nothing |
| `.card:has(> img.hero)` | `(0, 2, 1)` | `.card` plus `img.hero` |
| `a:not([aria-current])` | `(0, 1, 1)` | the type selector plus the attribute |

`:where()` has the same matching behaviour but contributes **zero specificity**. It is the tool for resets, normalization and low-priority defaults. A component class can override a `:where()` rule without knowing anything about the reset''s selector.

Both `:is()` and `:where()` use **forgiving parsing**. If one argument is invalid or unsupported, the browser drops that argument and keeps the rest. A plain selector list is not forgiving: one invalid selector invalidates the entire rule. That difference is a common source of "the CSS disappeared" bugs.

```html run
<article class="post">
  <h2>Field notes</h2>
  <p>Three days on the ridge, one very heavy rucksack. <a href="#">Read the route</a>.</p>
  <h3 class="quiet">Packing list</h3>
  <p class="quiet">The list is intentionally quiet.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 40rem; }
  .post :is(h2, h3, a):not(.quiet) { color: #0f766e; }
  .post .quiet { color: #64748b; }
</style>
```

The `h2`, the `h3` and the link are all matched by `:is(h2, h3, a)`. The `:not(.quiet)` then removes the quiet heading, and the separate `.quiet` rule keeps it muted. Without `:not()`, the quiet heading would be teal like the others.

> **Pitfall:** `:is()` cannot contain pseudo-elements. `:is(p::before)` is invalid. Use a normal selector list for pseudo-elements.

## `:not()` is a filter, not a reset

`:not()` matches an element that does **not** match any selector in its argument list. It accepts a list, so `:not(.disabled, [aria-disabled="true"])` is valid. Its specificity is the most specific selector in the list, just like `:is()`.

Use `:not()` to narrow a rule, not to undo a rule. A selector such as `a:not(.button)` is a clear statement: style links that are not buttons. A selector such as `*:not(.everything)` is a sign that the stylesheet has lost control of its defaults. `:not()` also does not make a selector cheaper; the browser still evaluates the full compound selector. Use it for clarity, not as an optimisation.

## `:has()` styles the element that contains a match

`:has()` is the relational selector people used to call "the parent selector". It matches an element if any relative selector inside the parentheses matches, starting from that element. The combinator at the start of the argument controls the relationship:

- `.card:has(img)` — the card contains an image anywhere.
- `.card:has(> img)` — the image is a direct child of the card.
- `label:has(+ input)` — the label is immediately followed by an input.
- `form:has(input:invalid)` — the form contains at least one invalid input.

The specificity of `:has()` is the specificity of its most specific argument, plus whatever else is in the selector. It cannot contain pseudo-elements.

`:has()` is most useful for state that is already expressed in the DOM: validity, checked state, open state, focus, the presence of an icon, a selected row. It is not a replacement for a class when the server already knows the state. It is also worth being careful with very large, constantly mutating DOM trees; a relational selector can be more expensive than a class toggle. For ordinary forms and components, the convenience is worth it.

The relative selector can also point sideways. `label:has(+ input:invalid)` matches a label whose immediately following sibling is an invalid input. The subject is still the label before `:has()`; the combinator describes where to look. That makes `:has()` useful for form layouts where the label and control are siblings rather than nested.

```html run
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
  <label class="check">
    <input type="checkbox" checked>
    <span>Send me the weekly digest</span>
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  .field:has(input:invalid) { border-color: #b91c1c; background: #fef2f2; }
  .field:has(input:valid) { border-color: #0f766e; }
  .check { display: flex; align-items: center; gap: 8px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .check:has(input:checked) { border-color: #0f766e; background: #f0fdfa; }
</style>
```

The email field is invalid because the value is not an email address. Its row turns red. The name field is valid, so its row turns teal. The checkbox row is tinted because the checkbox is checked. No class changes, no event listeners, no JavaScript.

> **In the wild:** `:has()` is excellent for "error state on the field wrapper" because the invalid control is nested inside the label. It also lets a card react to a featured image without a `.has-image` class from the CMS.

## Counting with `:nth-child(An+B of S)`

`:nth-child()` has a powerful form that is easy to miss:

```css
.row:nth-child(2n of .row) { background: #f1f5f9; }
```

The `of S` part filters the siblings to those matching `S`, then counts those matches. It is not "the second child if it also matches". It is "the second element among the siblings that match `S`". That distinction matters when other elements are mixed into the same parent.

| Selector | What it selects |
|---|---|
| `:nth-child(3)` | the third child, whatever it is |
| `:nth-child(2n)` | every even child |
| `:nth-child(2n+1)` | every odd child |
| `:nth-child(-n+3)` | the first three children |
| `:nth-child(2n of .row)` | every second element whose class includes `row` |

`:nth-of-type()` is different again: it counts siblings of the same element type (`li`, `p`, `div`), not siblings that match a class. Use `:nth-of-type()` when the tag is the meaningful category; use `:nth-child(... of S)` when a class or attribute is the meaningful category.

```html run
<ol class="ledger">
  <li class="row">Invoice 01</li>
  <li class="row">Invoice 02</li>
  <li class="note">A note that is not a row</li>
  <li class="row">Invoice 03</li>
  <li class="row">Invoice 04</li>
  <li class="row">Invoice 05</li>
</ol>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .ledger { list-style: none; margin: 0; padding: 0; max-width: 420px; border: 1px solid #e2e8f0; border-radius: 10px; overflow: hidden; }
  .row, .note { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; }
  .row:nth-child(odd of .row) { background: #f1f5f9; }
  .note { color: #b45309; font-style: italic; }
</style>
```

Invoices 01, 03 and 05 are tinted. The note is ignored by the `of .row` filter, so it does not shift the count. Without `of .row`, `:nth-child(odd)` would count every child, and the note would take one of the odd positions.

## Attribute selectors read state directly

Attributes are part of the DOM, so CSS can read them without a class. This is especially useful for accessibility state and data attributes:

```css
a[aria-current="page"] { font-weight: 700; }
.disclosure[data-state="open"] .panel { display: block; }
input[disabled] { opacity: 0.6; }
[data-role="alert" i] { border-left: 4px solid #b45309; }
```

`[aria-current]` matches any element with the attribute, regardless of value. `[aria-current="page"]` matches the exact value. The `i` flag makes the value comparison case-insensitive. Attribute selectors have class-level specificity: `(0, 1, 0)`. Values are case-sensitive by default, so `[data-state="open"]` will not match `data-state="Open"` unless you add the `i` flag.

`:focus-within` matches an element when it or any descendant has focus. It is the natural way to highlight a composite field, a card with a link, or a search box when the input inside is focused. `:focus-visible` is a different tool: it matches the element that received focus when the browser judges that a focus indicator should be visible. Use `:focus-within` for the container''s state and `:focus-visible` for the control''s ring.

`:empty` matches an element with no children and no text; whitespace counts as text, so `<p> </p>` is not empty.

```html run
<nav class="nav" aria-label="Primary">
  <a href="#" aria-current="page">Notes</a>
  <a href="#">Archive</a>
</nav>
<div class="disclosure" data-state="open">
  <button type="button" aria-expanded="true">Filters</button>
  <div class="panel">Three active filters</div>
</div>
<div class="disclosure" data-state="closed">
  <button type="button" aria-expanded="false">Sort</button>
  <div class="panel">Newest first</div>
</div>
<label class="search">
  <span>Search</span>
  <input type="search" placeholder="Type to search" autofocus>
</label>
<p class="empty"></p>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; display: grid; gap: 12px; max-width: 420px; }
  .nav { display: flex; gap: 16px; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; }
  .nav a { color: #475569; text-decoration: none; }
  .nav a[aria-current="page"] { color: #0f766e; font-weight: 700; }
  .disclosure { border: 1px solid #e2e8f0; border-radius: 10px; padding: 10px 12px; }
  .disclosure .panel { display: none; margin-top: 6px; color: #475569; }
  .disclosure[data-state="open"] .panel { display: block; }
  .search { display: grid; gap: 4px; padding: 10px 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .search:focus-within { border-color: #0f766e; box-shadow: 0 0 0 3px #ccfbf1; }
  .search span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .search input { border: 0; font: inherit; background: transparent; }
  .empty { margin: 0; }
  .empty:empty::before { content: "No notes yet"; color: #64748b; }
</style>
```

The current page link is teal and bold because of `[aria-current="page"]`. Only the open disclosure shows its panel. The search wrapper gets a focus ring from `:focus-within` when the input receives focus. The empty paragraph renders the placeholder from `:empty::before`.

> **Pitfall:** `:empty` does not ignore whitespace. If your template prints a newline or a space between the tags, the element is not empty and the rule will not match.

## Selector lists are not forgiving

A normal selector list is all-or-nothing. One invalid selector invalidates the entire rule. This is why a single unsupported pseudo-class can make a perfectly good `.notice-title` rule disappear:

```css
.notice-title, :blank { color: #b45309; } /* the whole rule is dropped */
```

`:is()` and `:where()` are forgiving. The invalid argument is discarded, and the rest of the list still works:

```css
:is(.notice-title, :blank) { color: #b45309; } /* .notice-title survives */
```

That is a useful compatibility tool, not a licence to leave typos in production. If a selector is invalid, you want to know. The forgiving list is for progressive enhancement: use a new pseudo-class where it is supported, and keep the valid fallback working everywhere else.

```html run
<div class="stack">
  <p class="strict">This rule was dropped</p>
  <p class="forgiving">This rule survived</p>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stack p { padding: 10px 12px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; }
  .strict, :blank { color: #b91c1c; }
  :is(.forgiving, :blank) { color: #0f766e; }
</style>
```

The first paragraph stays black because `:blank` is unsupported in this browser and invalidates the whole `.strict, :blank` rule. The second is teal because `:is()` drops the unsupported argument and keeps `.forgiving`.

Forgiving parsing is useful, but it is also quiet. A typo inside `:is()` does not produce an error; it simply stops matching. During development, check the selector in DevTools or with `CSS.supports("selector(:is(...))")`. Keep the forgiving list for deliberate progressive enhancement, not for hiding mistakes.

## Challenge: style the row, not the input

Use `:has()` to give the row containing an invalid email a red border and a pale red background, and the row containing a valid name a teal border. The inputs themselves should stay unstyled.

```html exercise id=selectors-invalid-row title="Style the row from its input"
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  /* Target: invalid border #b91c1c, invalid background #fef2f2, valid border #0f766e.
     TODO: style .field when its input is invalid, and again when it is valid. */
</style>
--- solution
<form class="form">
  <label class="field">
    <span>Email</span>
    <input type="email" required value="not-an-email">
  </label>
  <label class="field">
    <span>Name</span>
    <input type="text" required value="Ada Lovelace">
  </label>
</form>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .form { display: grid; gap: 12px; max-width: 420px; }
  .field { display: grid; gap: 6px; padding: 12px; border: 2px solid #cbd5e1; border-radius: 10px; }
  .field span { font-size: 0.8rem; font-weight: 700; color: #475569; }
  .field input { border: 0; background: transparent; font: inherit; }
  .field:has(input:invalid) { border-color: #b91c1c; background: #fef2f2; }
  .field:has(input:valid) { border-color: #0f766e; }
</style>
--- test
assertColor(".field:has(input:invalid)", "border-top-color", "#b91c1c", "The row with the invalid email should have a red border. It currently computes to " + getComputedStyle(query(".field:has(input:invalid)")).borderTopColor + ".");
assertColor(".field:has(input:invalid)", "background-color", "#fef2f2", "Give the invalid row a pale red background.");
assertColor(".field:has(input:valid)", "border-top-color", "#0f766e", "The row with the valid name should have a teal border. Style it with :has(input:valid).");
assertStyle(".field input", "border-top-width", "0px", "The input itself should stay unstyled; the row is doing the work.");
--- hint
The row is a `label` with class `field`. The input is its descendant, so the relational selector starts from `.field`.
--- hint
`.field:has(input:invalid)` matches the row, not the input. Set `border-color` and `background` on that selector.
--- hint
Add a second rule for `.field:has(input:valid)` so the valid row gets a teal border instead of staying slate.
```

## Challenge: make a reset step aside with `:where()`

The prose reset styles every heading inside `.prose`, including the featured title. Because `.prose h2` is more specific than `.featured-title`, the component''s colour and size lose. Rewrite the reset with `:where()` so ordinary headings keep the reset and the featured heading keeps its component styles.

```html exercise id=selectors-where-reset title="A reset that cannot outrank a component"
<article class="prose">
  <h2>Field notes</h2>
  <p>Short dispatches from the workshop and the trail.</p>
  <h2 class="featured-title">The long way round</h2>
  <p>Some routes are worth the extra day.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose h2 { margin: 0 0 12px; color: #475569; font-size: 1.125rem; }
  .featured-title { color: #0f172a; font-size: 1.75rem; }
  /* TODO: rewrite the reset so it still styles ordinary h2 elements
     but cannot outrank .featured-title. */
</style>
--- solution
<article class="prose">
  <h2>Field notes</h2>
  <p>Short dispatches from the workshop and the trail.</p>
  <h2 class="featured-title">The long way round</h2>
  <p>Some routes are worth the extra day.</p>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; max-width: 38rem; }
  .prose :where(h2) { margin: 0 0 12px; color: #475569; font-size: 1.125rem; }
  .featured-title { color: #0f172a; font-size: 1.75rem; }
</style>
--- test
assertColor(".featured-title", "color", "#0f172a", "The featured title is still slate. .prose h2 scores (0, 1, 1) and beats .featured-title at (0, 1, 0).");
assertStyle(".featured-title", "font-size", "28px", "The featured title should keep its 1.75rem size, not the reset''s 1.125rem.");
assertColor(".prose h2:not(.featured-title)", "color", "#475569", "Ordinary prose headings should still get the reset colour.");
assertStyle(".prose h2:not(.featured-title)", "font-size", "18px", "Ordinary prose headings should still get the reset size.");
--- hint
You want the reset selector to keep matching `h2` but contribute no specificity for the `h2` part.
--- hint
`:where(h2)` has zero specificity. The surrounding `.prose` still contributes one class.
--- hint
Change `.prose h2` to `.prose :where(h2)`. The reset and `.featured-title` then tie at (0, 1, 0), and the later component rule wins.
```

## Debug: the rule that vanished

The notice heading should be amber, but it is black. The stylesheet contains `.notice-title, :blank`, and this browser does not support `:blank`. A plain selector list is not forgiving, so the entire rule was dropped. Fix it so the valid selector applies, and keep the notice panel styling.

```html debug id=selectors-forgiving-list title="The rule that vanished"
<div class="notice">
  <h2 class="notice-title">Export ready</h2>
  <p>Your archive is ready to download.</p>
</div>
<style>
  .notice-title, :blank { color: #b45309; }
  .notice { padding: 16px; border: 1px solid #fcd34d; background: #fffbeb; border-radius: 10px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- solution
<div class="notice">
  <h2 class="notice-title">Export ready</h2>
  <p>Your archive is ready to download.</p>
</div>
<style>
  :is(.notice-title, :blank) { color: #b45309; }
  .notice { padding: 16px; border: 1px solid #fcd34d; background: #fffbeb; border-radius: 10px; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
</style>
--- test
assertColor(".notice-title", "color", "#b45309", "The heading is still black. The selector list contains :blank, which this browser does not support, so the entire rule is invalid and never applies.");
assertColor(".notice", "background-color", "#fffbeb", "Keep the notice panel''s background.");
assertStyle(".notice", "padding", "16px", "Keep the notice panel''s padding.");
--- hint
The heading rule is the one that disappeared, not the panel rule. Compare the two selectors.
--- hint
A selector list separated by commas is unforgiving: if one selector is invalid, the whole rule is discarded.
--- hint
Wrap the list in `:is(...)` or `:where(...)`, or remove `:blank`. Both make `.notice-title` valid again.
```

## Predict: which figures get the outline?

The rule uses `:has(> img)`. The combinator inside `:has()` decides whether a nested image counts. Choose the figures that match.

```html predict id=selectors-predict-has-child title="Which figures match :has(> img)?"
<div class="gallery">
  <figure class="shot">
    <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''120'' height=''80''%3E%3Crect width=''120'' height=''80'' fill=''%23cbd5e1''/%3E%3C/svg%3E" alt="" width="120" height="80">
    <figcaption>Direct child</figcaption>
  </figure>
  <figure class="shot">
    <div class="frame">
      <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''120'' height=''80''%3E%3Crect width=''120'' height=''80'' fill=''%23cbd5e1''/%3E%3C/svg%3E" alt="" width="120" height="80">
    </div>
    <figcaption>Nested</figcaption>
  </figure>
  <figure class="shot">
    <img src="data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''120'' height=''80''%3E%3Crect width=''120'' height=''80'' fill=''%23cbd5e1''/%3E%3C/svg%3E" alt="" width="120" height="80">
    <figcaption>Direct child, with caption</figcaption>
  </figure>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; }
  .gallery { display: flex; gap: 16px; flex-wrap: wrap; }
  .shot { margin: 0; padding: 8px; border: 2px dashed #cbd5e1; border-radius: 10px; }
  .shot figcaption { margin-top: 6px; font-size: 0.8rem; color: #475569; }
  .shot:has(> img) { outline: 4px solid #0f766e; outline-offset: 4px; }
</style>
--- options
* The first and third figures
Only the first figure
All three figures
Only the second figure
--- explain
`>` inside `:has()` means "a direct child". The first and third figures contain an `img` as a direct child, so they match. The second figure contains the image inside `.frame`, which is a descendant but not a direct child, so it does not match. Removing the `>` would make all three match, because the image is still inside each figure.
```

## Recap

- `:is()` groups selectors and takes the specificity of its most specific argument; `:where()` always contributes zero.
- `:not()` excludes a selector list. Use it to narrow a rule, not to undo a stylesheet.
- `:has()` matches an element based on what it contains. The combinator inside controls the relationship.
- `:nth-child(An+B of S)` counts only siblings that match `S`; `:nth-of-type()` counts by element type.
- Attribute selectors, `:focus-within` and `:empty` read state and structure without extra classes.
- Plain selector lists are unforgiving. `:is()` and `:where()` keep the valid parts working.

**Up next:** Flexbox in depth — growth, shrinkage, and the `min-content` trap that makes a `flex: 1` child refuse to shrink.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_1_5', 'sec_html_css_advanced_1', 'crs_html_css_advanced', 'Checkpoint: the cascade, mastered', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which declaration wins in this stylesheet?\n\n```\n#hero .title { color: red; }\n.page .title { color: blue; }\n```","options":["The blue rule, because it comes later","The red rule, because the ID adds more specificity","Neither; the declarations cancel out","The browser picks randomly"],"answerIndex":1,"explanation":"`#hero .title` has one ID and one class; `.page .title` has two classes. An ID point outranks any number of class points, so red wins before source order is considered. `!important` would change the result, but should not be the first tool you reach for."},{"id":"q2","prompt":"What is the main effect of `:where()`?","options":["It makes a selector match only on wide screens","It matches like `:is()` but contributes zero specificity","It removes the element from the accessibility tree","It applies styles only when the element is empty"],"answerIndex":1,"explanation":"`:where()` takes a selector list and matches the same way as `:is()`, but its specificity is always zero. That makes it useful in resets and base styles that should be easy for component styles to override."},{"id":"q3","prompt":"In `@layer reset, base, components, utilities;`, which layer wins when specificity is equal?","options":["`reset`, because it is first","`utilities`, because later layers override earlier ones","The layer declared last in the CSS file, regardless of the statement","All layers have equal priority"],"answerIndex":1,"explanation":"The order in the `@layer` statement establishes priority: later layers override earlier ones for normal declarations. The statement itself can appear near the top of the file, which is the point — you control the cascade without relying on source order throughout the stylesheet."},{"id":"q4","prompt":"Which property is inherited by default?","options":["`border`","`padding`","`font-family`","`display`"],"answerIndex":2,"explanation":"Typography properties such as `font-family`, `font-size`, `line-height` and `color` inherit. Box and layout properties such as border, padding and display do not. Inheritance is why setting a font stack on `body` reaches most text without repeating the rule."},{"id":"q5","prompt":"What does `var(--color-brand, #0f766e)` do if `--color-brand` is not defined?","options":["Throws a CSS parse error","Uses `#0f766e` as the fallback","Removes the property","Inherits the value from the nearest sibling"],"answerIndex":1,"explanation":"The second argument to `var()` is the fallback used when the custom property is invalid, unset or not inherited. Note that a defined-but-invalid value does not trigger the fallback in the same way; the property becomes invalid at computed-value time."},{"id":"q6","prompt":"A component defines `--space: 1rem` on `.card`. What happens to a child of `.card` that uses `padding: var(--space)`?","options":["It inherits `1rem` from `.card`","It falls back to the initial value because custom properties do not inherit","It causes a circular dependency","It only works if the child also declares `--space`"],"answerIndex":0,"explanation":"Custom properties inherit like ordinary inherited properties. Declaring `--space` on `.card` makes it available to descendants. That is why component-scoped tokens work, and why a token declared on a sibling is not visible."},{"id":"q7","prompt":"Which selector matches a `<form>` that contains an invalid input?","options":["`form:invalid`","`form:has(input:invalid)`","`form:invalid input`","`input:has(form:invalid)`"],"answerIndex":1,"explanation":"`:has()` lets an element match based on its descendants. `form:has(input:invalid)` selects the form when it contains an invalid input. `form:invalid` only matches if the form element itself is a form control, which it is not."},{"id":"q8","prompt":"Why is `:is(.a, .b)` often safer than writing `.a, .b` when one selector is unsupported?","options":["`:is()` is faster in every browser","An invalid selector in a plain list invalidates the entire rule; `:is()` uses forgiving parsing","`:is()` disables specificity","Plain selector lists cannot contain classes"],"answerIndex":1,"explanation":"In a plain selector list, one invalid selector makes the whole rule invalid. `:is()` and `:where()` use forgiving selector parsing, so the valid selectors still match. This is useful for progressive enhancement with newer pseudo-classes."},{"id":"q9","prompt":"What does `revert` do in a declaration?","options":["It restores the value from the previous cascade origin (for example, the browser default) rather than from the parent","It is identical to `inherit`","It deletes the element","It forces the declaration to win with `!important`"],"answerIndex":0,"explanation":"`revert` rolls the property back to the value it would have had from a lower-priority origin, such as the user-agent stylesheet. `inherit` explicitly takes the parent''s computed value, and `unset` acts like `inherit` for inherited properties and `initial` for others."},{"id":"q10","prompt":"When is `!important` most defensible?","options":["Whenever a selector is not winning","For a small set of utility or accessibility rules that must override third-party or inline styles, with the tradeoff documented","On every declaration in a design system","To avoid learning specificity"],"answerIndex":1,"explanation":"`!important` removes a declaration from the normal specificity contest and makes future overrides harder. It is sometimes justified for utilities, reduced-motion overrides or third-party CSS you cannot edit, but it should be deliberate and rare, not a substitute for understanding the cascade."}]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_2_1', 'sec_html_css_advanced_2', 'crs_html_css_advanced', 'Flexbox in depth: growth, shrinkage and the min-content trap', 'interactive', 0, 1440, NULL, NULL, 'Flexbox is not a grid with one dimension. It is a distribution algorithm. You give it a row or a column, a set of base sizes, and some rules about how to divide the space that is left. Most Flexbox bugs come from forgetting which of those three things the browser is actually solving.

The most famous bug is the `flex: 1` child that refuses to shrink. It is not refusing. It is respecting a minimum size you did not know it had. Once you can see the base size, the free space and the automatic minimum, the layout stops being mysterious.

## The axis comes first

Every Flexbox layout has a **main axis** and a **cross axis**. `flex-direction` decides which is which:

- `row` (the default): main axis horizontal, cross axis vertical.
- `column`: main axis vertical, cross axis horizontal.
- `row-reverse` and `column-reverse`: same axes, opposite direction.

The alignment properties follow the axes, not the screen. `justify-content` distributes items along the **main** axis. `align-items` aligns items along the **cross** axis. This is why `justify-content: center` centres horizontally in a row but vertically in a column.

`align-content` is different again: it distributes the **lines** created by `flex-wrap` along the cross axis. It has no effect on a single-line flex container. `align-self` overrides `align-items` for one item.

```html run
<div class="toolbar">
  <strong class="brand">Trailhead</strong>
  <nav class="links"><a href="#">Notes</a><a href="#">Routes</a></nav>
  <button type="button">New note</button>
</div>
<div class="toolbar column">
  <strong class="brand">Column direction</strong>
  <nav class="links"><a href="#">Notes</a><a href="#">Routes</a></nav>
  <button type="button">New note</button>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; display: grid; gap: 16px; max-width: 760px; }
  .toolbar { display: flex; justify-content: space-between; align-items: center; gap: 16px; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .toolbar.column { flex-direction: column; align-items: flex-start; }
  .brand { color: #0f172a; }
  .links { display: flex; gap: 12px; }
  .links a { color: #0f766e; text-decoration: none; font-weight: 600; }
</style>
```

In the row, `justify-content: space-between` pushes the brand and the button to the edges, and `align-items: center` keeps everything on the vertical centre line. In the column, the same `space-between` distributes along the vertical axis, and `align-items: flex-start` packs the items to the left. The property names did not change; the axes did.

> **Tip:** If `justify-content` seems to do the wrong thing, check `flex-direction` before you check the value. A column layout swaps the meaning of every alignment property.

## Growing and shrinking: basis first, then free space

Each flex item starts from its **flex base size**, determined by `flex-basis` (or `width`/`height` if `flex-basis` is `auto`). The browser sums those base sizes and the gaps, subtracts the total from the container, and calls the result **free space**.

- If free space is positive, `flex-grow` factors divide it.
- If free space is negative, `flex-shrink` factors decide who gives up space, weighted by base size. The scaled shrink factor is `flex-shrink` multiplied by the base size, so a wide item gives up more than a narrow item with the same shrink value.
- If free space is zero, nothing grows or shrinks.

The `flex` shorthand sets grow, shrink and basis in one declaration:

| Shorthand | Equivalent | What it means |
|---|---|---|
| `flex: 1` | `1 1 0%` | Share space equally from a zero base |
| `flex: auto` | `1 1 auto` | Grow and shrink from the content size |
| `flex: none` | `0 0 auto` | Keep the natural size; do not grow or shrink |
| `flex: initial` | `0 1 auto` | Do not grow, but allow shrinking |
| `flex: 2` | `2 1 0%` | Take twice the share of a `flex: 1` sibling |

The difference between `flex: 1` and `flex: auto` is the base. With `flex: 1`, every item starts at zero and the grow factors decide the final widths, so equal factors produce equal widths even if the content differs. With `flex: auto`, the content size is the starting point, so a longer label starts wider and then shares the remaining space.

`flex-basis` is not a synonym for `width`. It sets the initial main size used by the flex algorithm; the used size can still be constrained by `min-width`, `max-width` and the item''s content. When `flex-basis` is `auto`, the browser looks at the item''s `width` (or `height` in a column), then falls back to the content size. `box-sizing: border-box` makes the basis include padding and border, which is usually what you want when you reason about percentages.

```html run
<div class="row">
  <div class="cell a">A · grow 1</div>
  <div class="cell b">B · grow 2</div>
  <div class="cell c">C · grow 1</div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; width: 600px; max-width: 100%; border: 1px solid #cbd5e1; border-radius: 10px; overflow: hidden; background: #ffffff; }
  .cell { flex: 1 1 100px; box-sizing: border-box; padding: 18px 8px; text-align: center; font-weight: 600; }
  .a { background: #ccfbf1; color: #0f766e; }
  .b { flex-grow: 2; background: #0f766e; color: #ffffff; }
  .c { background: #e2e8f0; color: #0f172a; }
</style>
```

The row is 600px wide. Each item has a 100px basis, so the base total is 300px and the free space is 300px. The grow factors are 1, 2 and 1, a total of 4. The free space splits into 75px, 150px and 75px. Add the basis back and the widths are 175px, 250px and 175px. B is not twice as wide as A in total; it receives twice the *free space*. That distinction is the source of a thousand "why is my sidebar not 25%" questions.

> **Pitfall:** `flex: 1` sets `flex-basis: 0%`, not `auto`. If you want content to influence the starting width, use `flex: auto` or write the basis explicitly.

## The min-content trap

A flex item has an automatic minimum size on the main axis: `min-width: auto` in a row, `min-height: auto` in a column. In most cases that minimum is the item''s **min-content size** — the smallest width the content can take without overflowing. A long unbroken word, a `<pre>` block, an image, or a table can make that minimum much larger than you expect.

`flex-shrink` cannot shrink an item below its minimum. So a `flex: 1` child with a long email address will refuse to shrink, and the row will overflow. The fix is usually two parts:

```css
.body {
  min-width: 0;
}
.email {
  overflow-wrap: anywhere;
}
```

`min-width: 0` removes the automatic minimum and lets the flex item become narrower than its content''s min-content size. Then you need a strategy for the content: wrap it, clip it with `overflow: hidden`, add `text-overflow: ellipsis`, or let it scroll with `overflow-x: auto`. Setting `overflow` to anything other than `visible` also changes the automatic minimum size in modern browsers, but explicit `min-width: 0` is easier to read and reason about.

```html run
<div class="compare">
  <section class="panel">
    <p class="tag">Without min-width: 0</p>
    <div class="row">
      <div class="avatar">AR</div>
      <div class="body"><p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p></div>
    </div>
  </section>
  <section class="panel">
    <p class="tag">With min-width: 0</p>
    <div class="row fixed">
      <div class="avatar">AR</div>
      <div class="body"><p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p></div>
    </div>
  </section>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .compare { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; max-width: 900px; }
  .panel { min-width: 0; padding: 12px; border: 2px dashed #cbd5e1; border-radius: 12px; background: #ffffff; }
  .tag { margin: 0 0 10px; font-size: 0.75rem; font-weight: 700; color: #475569; }
  .row { display: flex; gap: 12px; }
  .avatar { flex: none; display: grid; place-items: center; width: 44px; height: 44px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; font-size: 0.8rem; }
  .body { flex: 1; }
  .fixed .body { min-width: 0; }
  .email { margin: 0; color: #475569; font-size: 0.9rem; }
  .fixed .email { overflow-wrap: anywhere; }
</style>
```

In the left panel the email''s min-content width wins, and the text spills past the card. In the right panel `min-width: 0` lets the body shrink, and `overflow-wrap: anywhere` gives the long address somewhere to break. The text is not smaller; the container is finally allowed to be smaller than the text''s longest word.

> **Under the hood:** The automatic minimum is not always exactly min-content. It can be the specified size, the transferred size from an aspect ratio, or zero when the item has `overflow` other than `visible`. For everyday layout work, "min-content unless you opt out" is the right mental model.

In a column, the equivalent trap is `min-height: auto`. A flex column with a scrolling panel or a nested grid can refuse to shrink vertically for exactly the same reason. Set `min-height: 0` on the column item and give the inner scroller `overflow-y: auto`.

## Wrapping, gaps and changing order

`flex-wrap: wrap` lets items move onto new lines when they run out of main-axis space. Once there is more than one line, `align-content` controls how those lines are distributed on the cross axis. `gap` is subtracted from the container''s space before free space is distributed; it is not a margin on the items, and it does not appear between the item and the container edge.

`order` changes the visual order of flex items without changing the DOM order, the tab order or the order a screen reader announces. That makes it dangerous for meaningful content. Use it for purely visual rearrangements, or better, change the markup. If the order matters to a keyboard user, it should be the same in the DOM.

`align-self` lets one item break from the container''s `align-items` rule. An auto margin is another single-item tool: `margin-left: auto` absorbs all the free space to the left of an item, pushing it to the right.

```html run
<div class="tags">
  <span class="tag">research</span>
  <span class="tag">field notes</span>
  <span class="tag pinned">pinned</span>
  <span class="tag">packing</span>
  <span class="tag">weather</span>
  <span class="tag">routes</span>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .tags { display: flex; flex-wrap: wrap; gap: 8px 12px; align-content: space-between; width: 300px; height: 190px; padding: 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .tag { padding: 6px 10px; border-radius: 999px; background: #e2e8f0; color: #0f172a; font-size: 0.8rem; font-weight: 600; }
  .pinned { order: -1; align-self: flex-start; background: #ccfbf1; color: #0f766e; }
</style>
```

The tags wrap into several lines inside a fixed-height box. `align-content: space-between` spreads those lines vertically. The pinned tag has `order: -1`, so it appears first visually even though it is third in the markup, and `align-self: flex-start` keeps it at the top of its line.

`align-content` only has work to do once there are multiple lines. With `flex-wrap: nowrap`, or with content that fits on one line, it is ignored. If a wrapped layout has uneven vertical gaps, check whether `align-content` is stretching the lines rather than the items inside them.

> **In the wild:** A search toolbar is a classic flex layout: brand `flex: none`, search `flex: 1`, actions `flex: none`, one `gap`. The same pattern powers media objects, button groups and pagination.

## When Flexbox is the wrong tool

Flexbox is excellent for one-dimensional problems: toolbars, navigation, button groups, media objects, centring a single item, distributing a row of cards. It is the wrong tool when you need rows and columns to agree.

- **Two-dimensional grids.** If the item in row two, column three must line up with row one, column three, use CSS Grid.
- **Page layout with named regions.** Grid''s `grid-template-areas` expresses the page structure directly.
- **Overlapping content.** Grid or positioning, not flex.
- **Masonry or packed layouts.** Grid or a dedicated masonry layout, not `flex-wrap`.

The test is simple: if you find yourself nesting flex containers and setting percentage widths to force alignment, you are building a grid. Use one.

```html run
<div class="grid">
  <article class="card"><h2>Starter</h2><p>For one person and a side project.</p></article>
  <article class="card"><h2>Studio</h2><p>For a small team shipping every week.</p></article>
  <article class="card"><h2>Studio plus</h2><p>For a team that needs a shared library and review.</p></article>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; max-width: 820px; }
  .card { padding: 16px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff; }
  .card h2 { margin: 0 0 6px; font-size: 1.05rem; }
  .card p { margin: 0; color: #475569; line-height: 1.45; }
</style>
```

This is a two-dimensional layout. The cards share a row and their heights align because the grid owns the rows. A `flex-wrap` version would align each line independently, which is fine for tags but wrong for a pricing table.

## Challenge: a toolbar where search grows

Lay out the toolbar with Flexbox. The search field should take the remaining space, the brand and actions should keep their natural width, and the whole bar should stay on one line with a 12px gap.

```html exercise id=flex-toolbar title="A toolbar that knows who grows"
<header class="toolbar">
  <a class="brand" href="#">Trailhead</a>
  <label class="search">
    <span class="visually-hidden">Search</span>
    <input type="search" placeholder="Search notes">
  </label>
  <div class="actions">
    <button type="button">Filter</button>
    <button type="button">New note</button>
  </div>
</header>
<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { max-width: 880px; margin: 24px auto; padding: 0 16px; }
  .brand { color: #0f172a; font-weight: 700; text-decoration: none; }
  .search input { width: 100%; box-sizing: border-box; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .actions button { padding: 9px 12px; border: 0; border-radius: 8px; background: #e2e8f0; font: inherit; font-weight: 600; }
  /* TODO: display the toolbar as a row, centre the items, add a 12px gap,
     let the search field grow, and keep the actions at their natural width. */
</style>
--- solution
<header class="toolbar">
  <a class="brand" href="#">Trailhead</a>
  <label class="search">
    <span class="visually-hidden">Search</span>
    <input type="search" placeholder="Search notes">
  </label>
  <div class="actions">
    <button type="button">Filter</button>
    <button type="button">New note</button>
  </div>
</header>
<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { display: flex; align-items: center; gap: 12px; max-width: 880px; margin: 24px auto; padding: 0 16px; }
  .brand { flex: none; color: #0f172a; font-weight: 700; text-decoration: none; }
  .search { flex: 1 1 auto; min-width: 0; }
  .search input { width: 100%; box-sizing: border-box; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .actions { display: flex; flex: none; gap: 8px; }
  .actions button { padding: 9px 12px; border: 0; border-radius: 8px; background: #e2e8f0; font: inherit; font-weight: 600; }
</style>
--- test
assertStyle(".toolbar", "display", "flex", "The toolbar is still a block. Give it display: flex.");
assertStyle(".toolbar", "align-items", "center", "Centre the items on the cross axis with align-items: center.");
assertStyle(".toolbar", "gap", "12px", "The toolbar should use a 12px gap between its three children.");
assertStyle(".search", "flex-grow", "1", "The search field should grow into the remaining space. Give it flex: 1 or flex-grow: 1.");
assertStyle(".actions", "flex-shrink", "0", "The actions should keep their natural width. flex: none sets shrink to 0; it currently computes to " + getComputedStyle(query(".actions")).flexShrink + ".");
var searchBox = query(".search").getBoundingClientRect();
var actionsBox = query(".actions").getBoundingClientRect();
assert(searchBox.width > 300, "The search field should take the remaining width, but it computes to " + Math.round(searchBox.width) + "px.");
assert(searchBox.width > actionsBox.width * 2, "The search field should be much wider than the action group. Check which child is growing.");
assertNoOverflow("The toolbar should fit inside the page without horizontal scrolling.");
--- hint
Start with `display: flex`, `align-items: center` and `gap: 12px` on the toolbar.
--- hint
`flex: none` on the actions means "do not grow, do not shrink". That is what you want for the buttons.
--- hint
Give the search wrapper `flex: 1` (or `flex: 1 1 auto`) and add `min-width: 0` so the input can shrink on narrow screens.
```

## Challenge: the card that will not break

The email address is one long unbroken token. Its min-content width is forcing the `.body` flex item wider than the card. Let the body shrink and break the address so it wraps inside the card.

```html exercise id=flex-long-word title="Break the long address"
<article class="card">
  <div class="avatar" aria-hidden="true">AR</div>
  <div class="body">
    <h2>Alex Rivera</h2>
    <p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { display: flex; gap: 16px; width: 340px; padding: 16px; border: 1px solid #cbd5e1; border-radius: 12px; background: #ffffff; }
  .avatar { flex: none; display: grid; place-items: center; width: 48px; height: 48px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; }
  .body { flex: 1; }
  .body h2 { margin: 0; font-size: 1.1rem; }
  .email { margin: 4px 0 0; color: #475569; }
  /* TODO: let the body shrink, then let the address break inside it. */
</style>
--- solution
<article class="card">
  <div class="avatar" aria-hidden="true">AR</div>
  <div class="body">
    <h2>Alex Rivera</h2>
    <p class="email">alex.rivera@supercalifragilisticexpialidocious-studio.example</p>
  </div>
</article>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { display: flex; gap: 16px; width: 340px; padding: 16px; border: 1px solid #cbd5e1; border-radius: 12px; background: #ffffff; }
  .avatar { flex: none; display: grid; place-items: center; width: 48px; height: 48px; border-radius: 50%; background: #0f172a; color: #ffffff; font-weight: 700; }
  .body { flex: 1; min-width: 0; }
  .body h2 { margin: 0; font-size: 1.1rem; }
  .email { margin: 4px 0 0; color: #475569; overflow-wrap: anywhere; }
</style>
--- test
var card = query(".card");
assert(card.scrollWidth <= card.clientWidth + 1, "The card''s content is still wider than its box (scrollWidth " + card.scrollWidth + " vs clientWidth " + card.clientWidth + "). The long email is setting a min-content width.");
var body = query(".body");
assert(body.getBoundingClientRect().right <= card.getBoundingClientRect().right + 1, "The body still extends past the card''s right edge. Let the flex item shrink with min-width: 0.");
var email = query(".email");
assert(email.getBoundingClientRect().height > 30, "The email is still on one line. Give it overflow-wrap: anywhere or another breaking strategy so it wraps.");
assertNoOverflow("The page should not scroll sideways.");
--- hint
The automatic minimum size of a flex item is `min-width: auto`. That is what is holding the body open.
--- hint
Set `min-width: 0` on `.body` first. The item can now shrink, but the unbroken email still overflows inside it.
--- hint
Add `overflow-wrap: anywhere` to the email. `word-break: break-word` or `overflow-wrap: break-word` also work once the body can shrink.
```

## Debug: the panel that refuses to shrink

The two-column shell overflows its 880px container. The sidebar is fixed, and `.main` is `flex: 1`, but the long command inside the `<pre>` is setting the main panel''s min-content width. Let the main panel shrink, and keep the command on one line by letting it scroll inside the code block.

```html debug id=flex-nested-panel title="The panel that refuses to shrink"
<div class="shell">
  <aside class="sidebar">
    <p class="label">Workspace</p>
    <nav><a href="#">Deployments</a><a href="#">Logs</a></nav>
  </aside>
  <main class="main">
    <h1>Deploy log</h1>
    <pre>git push origin release/2026-10-23 --force-with-lease --no-verify --set-upstream</pre>
  </main>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .shell { display: flex; gap: 16px; max-width: 880px; margin: 0 auto; }
  .sidebar { flex: 0 0 220px; padding: 16px; background: #f1f5f9; border-radius: 12px; }
  .label { margin: 0 0 8px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #64748b; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar a { color: #0f766e; text-decoration: none; font-weight: 600; }
  .main { flex: 1; padding: 20px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; }
  .main h1 { margin: 0; font-size: 1.3rem; }
  .main pre { margin: 12px 0 0; padding: 12px; background: #0f172a; color: #e2e8f0; border-radius: 8px; }
  /* TODO: the main panel should shrink to fit the shell, and the command
     should scroll inside the pre instead of stretching the panel. */
</style>
--- solution
<div class="shell">
  <aside class="sidebar">
    <p class="label">Workspace</p>
    <nav><a href="#">Deployments</a><a href="#">Logs</a></nav>
  </aside>
  <main class="main">
    <h1>Deploy log</h1>
    <pre>git push origin release/2026-10-23 --force-with-lease --no-verify --set-upstream</pre>
  </main>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .shell { display: flex; gap: 16px; max-width: 880px; margin: 0 auto; }
  .sidebar { flex: 0 0 220px; padding: 16px; background: #f1f5f9; border-radius: 12px; }
  .label { margin: 0 0 8px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #64748b; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar a { color: #0f766e; text-decoration: none; font-weight: 600; }
  .main { flex: 1; min-width: 0; padding: 20px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; }
  .main h1 { margin: 0; font-size: 1.3rem; }
  .main pre { margin: 12px 0 0; padding: 12px; background: #0f172a; color: #e2e8f0; border-radius: 8px; overflow-x: auto; }
  /* The main panel can now shrink, and the pre owns the extra width. */
</style>
--- test
var shell = query(".shell");
assert(shell.scrollWidth <= shell.clientWidth + 1, "The shell is still wider than its 880px container (scrollWidth " + shell.scrollWidth + " vs clientWidth " + shell.clientWidth + "). The pre''s min-content width is holding .main open.");
var main = query(".main");
assert(main.getBoundingClientRect().right <= shell.getBoundingClientRect().right + 1, "The main panel still sticks out past the shell''s right edge. Give the flex item min-width: 0.");
var pre = query(".main pre");
var overflowX = getComputedStyle(pre).overflowX;
assert(overflowX === "auto" || overflowX === "scroll", "Let the command scroll inside the pre. Its overflow-x computes to " + overflowX + ".");
assert(pre.scrollWidth > pre.clientWidth, "The command should be wider than the pre''s visible box so it has something to scroll.");
--- hint
Run it and resize the preview. The sidebar stays 220px; the main panel is the one refusing to give up width.
--- hint
`min-width: auto` on `.main` resolves to the min-content width of the long `<pre>` line.
--- hint
Set `min-width: 0` on `.main` and `overflow-x: auto` on the pre. Then the panel fits and the command scrolls.
```

## Predict: how does the free space split?

The row is 600px wide. Each item starts from a 100px basis and has `box-sizing: border-box`. Read the grow factors, then choose the final widths.

```html predict id=flex-predict-free-space title="How does the free space split?"
<div class="row">
  <div class="cell a">A</div>
  <div class="cell b">B</div>
  <div class="cell c">C</div>
</div>
<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; width: 600px; }
  .cell { flex: 1 1 100px; box-sizing: border-box; padding: 18px 0; text-align: center; font-weight: 700; }
  .a { background: #ccfbf1; color: #0f766e; }
  .b { flex-grow: 2; background: #0f766e; color: #ffffff; }
  .c { background: #e2e8f0; color: #0f172a; }
</style>
--- options
* A 175px, B 250px, C 175px
A 150px, B 300px, C 150px
A 200px, B 200px, C 200px
A 100px, B 400px, C 100px
--- explain
The three 100px bases total 300px, leaving 300px of free space. The grow factors are 1, 2 and 1, a total of 4. A and C each receive one quarter of the free space (75px), so they end at 175px. B receives two quarters (150px), so it ends at 250px. If the basis were 0, the widths would be 150px, 300px and 150px instead. Grow distributes free space, not the total width.
```

## Recap

- `flex-direction` defines the main and cross axes; `justify-content` works on the main axis, `align-items` on the cross axis.
- Items start from `flex-basis`, then share positive free space by `flex-grow` and negative free space by `flex-shrink`.
- `flex: 1` means `1 1 0%`. `flex: auto` means `1 1 auto`. The difference is the starting size.
- A flex item''s automatic minimum is usually its min-content size. `min-width: 0` (or `min-height: 0`) removes that floor; then choose how the content wraps, clips or scrolls.
- `gap` is subtracted before free space is distributed. `order` and `align-self` change presentation, not DOM order.
- If rows and columns must align, reach for Grid. Flexbox is for one-dimensional distribution.

**Up next:** Grid in depth — intrinsic tracks, `minmax()`, named areas and the layouts that Flexbox should not be asked to solve.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_2_2', 'sec_html_css_advanced_2', 'crs_html_css_advanced', 'Grid in depth: intrinsic tracks, minmax and named areas', 'interactive', 1, 1560, NULL, NULL, 'Grid is not a box of columns. It is a set of relationships between tracks, and the browser resolves those relationships with a real sizing algorithm. That distinction is why two grids that look identical in a mock-up behave completely differently when a product name is forty characters long, when a card is missing, or when the sidebar is collapsed.

The goal is to build a mental model of how Grid sizes tracks, where extra space goes, and why an innocent `1fr` can push a layout off-screen. You will use that model to build dashboards, editorial pages and card systems that survive real content.

## Two grids: explicit and implicit

Everything you write in `grid-template-columns` and `grid-template-rows` describes the **explicit grid**. It is the part of the layout you planned. When items are placed outside those tracks, the browser creates the **implicit grid** to hold them. Implicit tracks are real tracks, but they are sized by `grid-auto-rows` and `grid-auto-columns`, not by the template.

```html run
<div class="board">
  <div class="cell">01</div>
  <div class="cell">02</div>
  <div class="cell">03</div>
  <div class="cell">04</div>
  <div class="cell">05</div>
  <div class="cell">06</div>
  <div class="cell">07</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .board {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-auto-rows: 84px;
    gap: 10px;
    max-width: 620px;
  }
  .cell {
    display: grid;
    place-items: center;
    border-radius: 10px;
    background: #0f172a;
    color: #e2e8f0;
    font-variant-numeric: tabular-nums;
  }
</style>
```

Seven items in a three-column grid need three rows. The third row exists only because the seventh item needed somewhere to go, and `grid-auto-rows: 84px` gives every implicit row that fixed height. Delete that declaration and the row would shrink to fit its content. Add a fourth item to the first row and the browser would create a fourth *column* instead, unless you also set `grid-auto-columns` or change `grid-auto-flow`.

Ask one question first: **is the track explicit or implicit?** Explicit tracks are sized by the template; implicit tracks by `grid-auto-*` and the content that landed there. Most "why is this row a different height?" bugs are one of those two answers.

> **Tip:** `grid-auto-rows: minmax(84px, auto)` is often more useful than a fixed height. It guarantees a minimum rhythm while still letting a row grow when its content needs more room.

## Track sizes are a negotiation

Grid resolves track sizes in stages. Roughly: it first works out the largest and smallest size each item can tolerate, then distributes the available space according to the track list, and finally stretches `auto` and `fr` tracks to fill what is left. The keywords below are the vocabulary for that negotiation.

| Value | What it asks for |
|---|---|
| `min-content` | The narrowest the track can be without its content overflowing, usually the longest word. |
| `max-content` | The width the content would take if it never wrapped. |
| `fit-content(20rem)` | A size between `min-content` and `max-content`, capped at the limit. |
| `minmax(12rem, 1fr)` | At least `12rem`, then share leftover space as a fraction. |
| `auto` | Content-driven minimum, then as much as the content wants. |
| `1fr` | A share of the free space, with an automatic minimum you will meet shortly. |

```html run
<div class="ledger">
  <div class="label">Account balance</div>
  <div class="amount">£128.40</div>
  <div class="note">Renewal on 14 November. Card ending 4402.</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .ledger {
    display: grid;
    grid-template-columns: min-content max-content minmax(12rem, 1fr);
    gap: 16px;
    max-width: 760px;
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .label { font-weight: 600; color: #0f172a; }
  .amount { color: #0f766e; font-variant-numeric: tabular-nums; }
  .note { color: #475569; line-height: 1.5; }
</style>
```

The first column is only as wide as the longest word in "Account balance" — so the label wraps onto two lines. The second is exactly as wide as the amount needs, no more. The third has a floor of `12rem` and then absorbs the rest of the row. Change the first track to `max-content` and the label will sit on one line, stealing width from the note.

`fit-content()` is the polite version of `max-content`: take what you need up to a limit, never less than the minimum. It suits tag lists and sidebars whose width should follow content without becoming absurd; `minmax()` still gives you explicit control at both ends.

> **Under the hood:** The specification calls this the *track sizing algorithm*. It runs multiple passes because a track''s size can depend on items in other tracks, especially when spans and intrinsic keywords are involved. You do not need to memorise the passes, but knowing that sizing is a negotiation — not a single width calculation — explains why adding one long word can resize three columns at once.

## The trap inside `1fr`

Here is the sentence that saves hours: **`1fr` means `minmax(auto, 1fr)`, and that `auto` minimum is content-based.** A flexible track can refuse to shrink below the min-content size of its contents. A long URL, a build hash, a German compound noun or a table of numbers can therefore hold a track open like a wedge.

```html run
<div class="inbox bad">
  <div class="rail">Inbox</div>
  <div class="message">
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </div>
  <div class="meta">2m ago</div>
</div>

<div class="inbox good">
  <div class="rail">Inbox</div>
  <div class="message">
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </div>
  <div class="meta">2m ago</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .inbox {
    display: grid;
    grid-template-columns: 96px 1fr 72px;
    gap: 12px;
    width: 100%;
    max-width: 620px;
    margin-bottom: 16px;
    padding: 14px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    background: white;
  }
  .inbox.good { grid-template-columns: 96px minmax(0, 1fr) 72px; }
  .rail { font-weight: 700; color: #0f172a; }
  .message code { font-family: ui-monospace, monospace; font-size: 13px; color: #334155; }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
```

Both cards use the same markup and the same long string. The first one loses its timestamp off the right edge because the middle track grew to fit the unbroken hash. The second uses `minmax(0, 1fr)`, which replaces the automatic minimum with zero. The track can now shrink to the space available, and the content is clipped by the card''s `overflow: hidden`.

The structural fix is `minmax(0, 1fr)`; `min-width: 0` on the item does the same job locally. `overflow-wrap: anywhere` changes the content''s min-content contribution but also changes how the text reads. `overflow: hidden` hides the symptom, not the cause.

> **Pitfall:** This is the same automatic-minimum problem that makes a flex item refuse to shrink in lesson 05. The mechanism is shared, the keywords are different, and the fix — remove the automatic minimum — is the same idea.

## Debug: the column that will not shrink

This build-log panel has three tracks: a fixed rail, a flexible middle column and a fixed metadata column. The middle column is supposed to absorb the remaining 348 pixels. Instead it has grown to fit a hash that must stay on one line, and the right-hand column has been pushed out of the panel.

Fix the track sizing so the middle column can shrink, and keep the long hash inside its own column with a horizontal scrollbar. The fix is small: one track declaration and one overflow rule.

```html debug id=grid-unshrinkable-column title="The middle column will not shrink"
<div class="panel">
  <nav class="rail">Build log</nav>
  <main class="thread">
    <p>Artifact uploaded</p>
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </main>
  <aside class="meta">2 minutes ago</aside>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    display: grid;
    grid-template-columns: 150px 1fr 150px;
    gap: 16px;
    width: 680px;
    max-width: 100%;
    padding: 16px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .rail { font-weight: 700; color: #0f172a; }
  .thread p { margin: 0 0 8px; color: #334155; }
  .thread code {
    display: block;
    white-space: nowrap;
    font-family: ui-monospace, monospace;
    font-size: 13px;
    color: #475569;
  }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
--- solution
<div class="panel">
  <nav class="rail">Build log</nav>
  <main class="thread">
    <p>Artifact uploaded</p>
    <code>sha256:9f2c1d7a4b8e0c6f3a5d9e2b7c4f8a1d6e3b9c5f2a7d4e8b1c6f9a3d5e2b7c4f</code>
  </main>
  <aside class="meta">2 minutes ago</aside>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    display: grid;
    grid-template-columns: 150px minmax(0, 1fr) 150px;
    gap: 16px;
    width: 680px;
    max-width: 100%;
    padding: 16px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .rail { font-weight: 700; color: #0f172a; }
  .thread p { margin: 0 0 8px; color: #334155; }
  .thread code {
    display: block;
    overflow-x: auto;
    white-space: nowrap;
    font-family: ui-monospace, monospace;
    font-size: 13px;
    color: #475569;
  }
  .meta { color: #64748b; font-size: 13px; text-align: right; }
</style>
--- test
const thread = query(".thread").getBoundingClientRect();
assert(thread.width < 400, `The middle column is ${Math.round(thread.width)}px wide inside a 680px panel. It is still being held open by the long hash.`);
const panel = query(".panel");
assert(panel.scrollWidth <= panel.clientWidth + 1, `The panel''s content is ${panel.scrollWidth - panel.clientWidth}px wider than its box. Let the middle track shrink and contain the long line.`);
--- hint
The middle track is `1fr`. What automatic minimum does a flexible track get, and what content is setting that minimum?
--- hint
Use `minmax(0, 1fr)` for the middle column. Then let the `<code>` element scroll horizontally so the hash does not spill into the metadata column.
```

The test checks overflow at the panel level as well as track width: a correctly sized track can still let code paint outside its box. The layout fix and the containment fix are separate jobs.

## Filling the row: `auto-fit` and `auto-fill`

`repeat(auto-fill, minmax(130px, 1fr))` asks the browser to fit as many 130-pixel tracks as possible into the row, then share any leftover space between them. `auto-fit` starts the same way, but after placing the items it **collapses the empty repeated tracks to zero** and lets the remaining tracks absorb their space.

```html run
<p class="label">auto-fill: empty tracks keep their space</p>
<div class="gallery fill">
  <div class="tile">North</div><div class="tile">South</div>
  <div class="tile">East</div><div class="tile">West</div>
</div>

<p class="label">auto-fit: empty tracks collapse</p>
<div class="gallery fit">
  <div class="tile">North</div><div class="tile">South</div>
  <div class="tile">East</div><div class="tile">West</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .label { margin: 0 0 8px; color: #475569; font-size: 14px; font-weight: 600; }
  .gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
    gap: 10px;
    max-width: 720px;
    margin-bottom: 24px;
  }
  .gallery.fit { grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); }
  .tile { padding: 24px 12px; border-radius: 10px; background: #0f766e; color: white; text-align: center; }
</style>
```

At this width the `auto-fill` row can hold five tracks but only four items exist, so one empty track remains and the four tiles keep their narrower width. In the `auto-fit` row the empty track collapses, the grid keeps four tracks, and each tile grows to roughly a quarter of the row. With enough items to fill every track, the two values look identical.

`auto-fill` suits a stable grid rhythm and cards that should not balloon when the list is short. `auto-fit` suits a small, variable set that should fill the row. Neither is "more modern"; they answer different questions about empty space.

```html predict id=grid-autofit-empty-tracks title="What happens to the empty tracks?"
<div class="row fit">
  <div class="card">One</div><div class="card">Two</div>
</div>
<div class="row fill">
  <div class="card">One</div><div class="card">Two</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 8px;
    width: 620px;
    max-width: 100%;
    margin-bottom: 16px;
  }
  .row.fit { grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); }
  .card { padding: 20px; border-radius: 10px; background: #1e293b; color: white; text-align: center; }
</style>
--- options
* The auto-fit cards stretch to fill the row; the auto-fill cards stay near their minimum width with empty tracks at the end
The auto-fill cards stretch to fill the row; the auto-fit cards stay near their minimum width with empty tracks at the end
Both rows look identical, because both recipes use the same `minmax(140px, 1fr)`
--- explain
Both grids begin with the same number of tracks: four can fit across 620 pixels. `auto-fill` keeps all four, so the two cards occupy two tracks and the other two remain empty. `auto-fit` collapses the empty tracks after placement, leaving two tracks that share the full row. That is why `auto-fit` makes a short list look deliberate and `auto-fill` makes it look like a grid waiting for more items.
```

## Challenge: an editorial grid with a featured story

Magazine layouts are rarely a uniform grid of equal cards. The lead story takes two columns, the rest take one, and the whole thing stays aligned. Build that with `grid-template-columns` and a span on the featured card.

The section already has five `.story` articles and a three-column grid. The first article has the `featured` class but no span yet, so all five cards are currently the same width.

```html exercise id=grid-editorial-feature title="Make the lead story span two columns"
<section class="editorial">
  <article class="story featured">
    <p class="kicker">Field notes</p>
    <h2>The long way to Kinder Scout</h2>
    <p>Two days, one bothy and an unreasonable amount of flapjack.</p>
  </article>
  <article class="story"><h2>Weather window</h2><p>Why the forecast lied.</p></article>
  <article class="story"><h2>Pack light</h2><p>Ten things you can leave behind.</p></article>
  <article class="story"><h2>Tea stops</h2><p>Three bothies worth the detour.</p></article>
  <article class="story"><h2>Night navigation</h2><p>A compass is still allowed.</p></article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .editorial {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
  }
  .story {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .story h2 { margin: 0 0 8px; font-size: 1.15rem; color: #0f172a; }
  .story p { margin: 0; color: #475569; line-height: 1.5; }
  .featured { background: #0f172a; }
  .featured h2, .featured p { color: #f8fafc; }
  .kicker { margin-bottom: 8px !important; color: #5eead4 !important; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  /* TODO: make .featured span two columns */
</style>
--- solution
<section class="editorial">
  <article class="story featured">
    <p class="kicker">Field notes</p>
    <h2>The long way to Kinder Scout</h2>
    <p>Two days, one bothy and an unreasonable amount of flapjack.</p>
  </article>
  <article class="story"><h2>Weather window</h2><p>Why the forecast lied.</p></article>
  <article class="story"><h2>Pack light</h2><p>Ten things you can leave behind.</p></article>
  <article class="story"><h2>Tea stops</h2><p>Three bothies worth the detour.</p></article>
  <article class="story"><h2>Night navigation</h2><p>A compass is still allowed.</p></article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .editorial {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
  }
  .story {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .story h2 { margin: 0 0 8px; font-size: 1.15rem; color: #0f172a; }
  .story p { margin: 0; color: #475569; line-height: 1.5; }
  .featured { grid-column: span 2; background: #0f172a; }
  .featured h2, .featured p { color: #f8fafc; }
  .kicker { margin-bottom: 8px !important; color: #5eead4 !important; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
</style>
--- test
assertStyle(".editorial", "display", "grid");
assertCount(".story", 5, "Keep all five story cards");
const featured = query(".featured").getBoundingClientRect();
const ordinary = query(".story:not(.featured)").getBoundingClientRect();
assert(featured.width > ordinary.width * 1.8, `The featured story is ${Math.round(featured.width)}px wide and a normal story is ${Math.round(ordinary.width)}px. The lead should be roughly twice as wide.`);
assertColor(".featured", "background-color", "#0f172a");
--- hint
The grid already has three equal columns. The featured card needs to occupy two of them, starting from the first column.
--- hint
Set `grid-column: span 2` on `.featured`. If you prefer explicit lines, `grid-column: 1 / span 2` does the same thing.
```

The span belongs to the card, not the grid. The container defines the track system; each item chooses how much of it to occupy. The same idea scales to full-width quotes and two-row sidebars.

> **In the wild:** Editorial grids usually combine spanning with `grid-auto-flow: dense` so that a tall feature does not leave a hole beside it. Dense packing is powerful and easy to misuse, which is why the next section treats it as an accessibility decision rather than a styling trick.

## Names: lines first, areas second

Grid gives you two naming systems, and they solve different problems. **Named lines** label the boundaries between tracks, which is useful when an item needs to start or end at a structural edge. **Named areas** label rectangles of cells, which is useful when the layout itself has a name — header, sidebar, content, footer.

```html run
<div class="layout">
  <header class="topbar">Trailhead / Overview</header>
  <aside class="sidebar">Filters and saved views</aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18% and the espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .layout {
    display: grid;
    grid-template-columns: [sidebar-start] 180px [sidebar-end main-start] minmax(0, 1fr) [main-end];
    grid-template-rows: auto 1fr;
    grid-template-areas:
      "topbar topbar"
      "sidebar content";
    gap: 12px;
    max-width: 860px;
    min-height: 340px;
  }
  .topbar { grid-area: topbar; }
  .sidebar { grid-area: sidebar; }
  .content { grid-area: content; }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 10px;
    background: white;
    border: 1px solid #e2e8f0;
  }
  .topbar { background: #0f172a; color: #f8fafc; font-weight: 700; }
  .sidebar { color: #475569; }
  .content h2 { margin: 0 0 8px; color: #0f172a; }
  .content p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The areas describe the shape at a glance: the top bar spans both columns, the sidebar sits under the left, the content under the right. Every row must have the same number of columns, and each named area must form a rectangle; a name split into two disconnected places is rejected.

Named lines solve a different problem. `grid-column: sidebar-end / main-end` places an item at structural boundaries without counting tracks. Line names can repeat, and one bracket can hold several names; areas are for the big picture, lines for the exceptions.

> **Tip:** Use `grid-template-areas` when the layout has a stable shape and the names are meaningful to the team. Use explicit line numbers when the layout is generated or when the areas would be mostly dots. Both are clearer than counting `1 / 3` in your head.

## Challenge: a dashboard with named areas

Build the shell of an analytics dashboard. The top bar must span the full width, the sidebar must sit on the left, and the content must fill the rest of the row beneath the top bar. The markup already has the three regions and the dark visual style; the grid is currently a single column, so everything stacks.

Use `grid-template-areas` for the shape and assign each region to its area. Keep the 12-pixel gap and the 220-pixel sidebar.

```html exercise id=grid-dashboard-areas title="Lay out the dashboard shell"
<div class="dashboard">
  <header class="topbar">Trailhead Analytics</header>
  <aside class="sidebar">
    <p>Overview</p>
    <p>Traffic</p>
    <p>Revenue</p>
  </aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18%. The espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #020617; color: #e2e8f0; }
  .dashboard {
    display: grid;
    gap: 12px;
    padding: 16px;
    min-height: 420px;
    /* TODO: add columns, rows and named areas */
  }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 12px;
    background: #1e293b;
  }
  .topbar { font-weight: 700; }
  .sidebar p { margin: 0 0 10px; color: #94a3b8; }
  .content h2 { margin: 0 0 8px; font-size: 1.15rem; }
  .content p { margin: 0; color: #cbd5e1; line-height: 1.5; }
</style>
--- solution
<div class="dashboard">
  <header class="topbar">Trailhead Analytics</header>
  <aside class="sidebar">
    <p>Overview</p>
    <p>Traffic</p>
    <p>Revenue</p>
  </aside>
  <main class="content">
    <h2>This week</h2>
    <p>Visitors are up 18%. The espresso queue is down to four minutes.</p>
  </main>
</div>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #020617; color: #e2e8f0; }
  .dashboard {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr);
    grid-template-rows: auto 1fr;
    grid-template-areas:
      "topbar topbar"
      "sidebar content";
    gap: 12px;
    padding: 16px;
    min-height: 420px;
  }
  .topbar { grid-area: topbar; }
  .sidebar { grid-area: sidebar; }
  .content { grid-area: content; }
  .topbar, .sidebar, .content {
    padding: 16px;
    border-radius: 12px;
    background: #1e293b;
  }
  .topbar { font-weight: 700; }
  .sidebar p { margin: 0 0 10px; color: #94a3b8; }
  .content h2 { margin: 0 0 8px; font-size: 1.15rem; }
  .content p { margin: 0; color: #cbd5e1; line-height: 1.5; }
</style>
--- test
assertStyle(".dashboard", "display", "grid");
const dash = query(".dashboard").getBoundingClientRect();
const header = query(".topbar").getBoundingClientRect();
const sidebar = query(".sidebar").getBoundingClientRect();
const content = query(".content").getBoundingClientRect();
assert(header.width > dash.width * 0.9, `The top bar is ${Math.round(header.width)}px wide inside a ${Math.round(dash.width)}px dashboard. It should span both columns.`);
assert(header.bottom <= sidebar.top + 1, "The sidebar should start below the top bar, not beside it.");
assert(Math.abs(sidebar.top - content.top) < 2, "The sidebar and content should share the same row.");
assert(sidebar.right <= content.left, "The sidebar should sit to the left of the content.");
assertColor(".topbar", "background-color", "#1e293b");
--- hint
Start with two columns: `220px` and `minmax(0, 1fr)`. The top bar needs to occupy both.
--- hint
Write the areas as `"topbar topbar"` on the first row and `"sidebar content"` on the second, then give each child `grid-area`.
```

The `minmax(0, 1fr)` in the content column matters for the same reason it did in the inbox example. A dashboard is full of long labels, URLs and numbers; the last thing you want is the sidebar pushed off-screen by an unbroken metric name.

## Dense packing and the reading order

By default, Grid places items in source order and moves forward when a cell is occupied, leaving holes when a spanning item blocks the next slot. `grid-auto-flow: dense` tells the browser to go back and fill those holes with later, smaller items.

```html run
<div class="mosaic">
  <div class="tile wide">01 · wide</div>
  <div class="tile">02</div>
  <div class="tile tall">03 · tall</div>
  <div class="tile">04</div>
  <div class="tile">05</div>
  <div class="tile wide">06 · wide</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .mosaic {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: 82px;
    grid-auto-flow: row dense;
    gap: 8px;
    max-width: 720px;
  }
  .tile {
    display: grid;
    place-items: center;
    padding: 8px;
    border-radius: 10px;
    background: #1e293b;
    color: #e2e8f0;
    font-size: 13px;
  }
  .wide { grid-column: span 2; }
  .tall { grid-row: span 2; background: #0f766e; }
</style>
```

Remove `dense` and item 06 lands on a later row, leaving a hole. Add it back and a later item fills the gap. That is right for a photo mosaic or decorative bento box, and wrong for a list of interactive cards or anything navigated in sequence.

Dense packing changes only the **visual** order. DOM order, tab order and screen-reader order stay as authored, so a keyboard user can jump across the grid and a screen-reader user hears a sequence that does not match the picture. WCAG''s meaningful-sequence and focus-order rules are about the order people experience.

> **Pitfall:** Never use `dense` to make a content list "fit better". Use it when the items are decorative or equivalent, or when you have deliberately authored the DOM in the reading order you want and the visual reflow is cosmetic.

## Subgrid, where supported

A nested grid normally gets its own tracks, so three cards side by side cannot align their headings, body copy and footers with each other. **Subgrid** lets a child grid borrow the parent''s tracks instead. The child spans some parent tracks and then opts into them with `grid-template-columns: subgrid` or `grid-template-rows: subgrid`.

```html run
<div class="cards">
  <article class="card">
    <h2>Starter</h2>
    <p>One location, two staff and a very short menu.</p>
    <footer>From £9 / month</footer>
  </article>
  <article class="card">
    <h2>Studio</h2>
    <p>Everything in Starter, plus wholesale ordering and a second location.</p>
    <footer>From £29 / month</footer>
  </article>
  <article class="card">
    <h2>Roastery</h2>
    <p>Production planning, batch tracking and a direct line to the roaster.</p>
    <footer>From £79 / month</footer>
  </article>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cards {
    display: grid;
    grid-template: repeat(3, auto) / repeat(3, minmax(0, 1fr));
    gap: 16px;
    max-width: 900px;
  }
  .card {
    display: grid;
    grid-row: span 3;
    grid-template-rows: subgrid;
    gap: 8px;
    padding: 18px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
  }
  .card h2 { margin: 0; font-size: 1.1rem; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .card footer { align-self: end; color: #0f766e; font-weight: 600; }
</style>
```

Each card spans three parent rows and reuses them as its own. The heading row is as tall as the tallest heading, the copy row as tall as the longest copy, and every footer sits on the same baseline. Without subgrid, the cards look fine alone but drift apart as soon as one description is longer.

Subgrid is supported in current Chrome, Firefox and Safari, but recent enough that production code should provide a fallback or treat it as progressive enhancement. It also couples the child to the parent''s tracks, so it is a poor fit for a component dropped into arbitrary containers.

## When Grid is overkill

Grid is the right tool when you have a genuine two-dimensional relationship: rows and columns that must align, items that span, overlapping layers or a layout with named regions. It is the wrong tool when you have a single axis of content that should wrap naturally. A row of tags, a toolbar, a breadcrumb trail and a stack of form fields are usually better served by flexbox or normal flow.

Two smells are worth recognising. A grid with one `1fr` column is a stack; `display: block` or flex with `gap` says so more clearly. A grid where every child needs unique `grid-column` and `grid-row` is really a set of positioned pieces, and absolute positioning or a simpler flex layout may be easier to maintain.

> **Under the hood:** Grid and flexbox are not competitors. A grid item can be a flex container, and a flex item can be a grid container. The useful question is not "which one is modern?" but "is the relationship primarily two-dimensional and track-based, or one-dimensional and content-driven?"

## Recap

- The explicit grid is what you declare; the implicit grid is what the browser creates for overflow items. `grid-auto-rows` and `grid-auto-columns` size the latter.
- `min-content`, `max-content`, `fit-content()` and `minmax()` describe constraints, not fixed widths. The track sizing algorithm resolves them against the content.
- `1fr` carries an automatic minimum. Use `minmax(0, 1fr)` or `min-width: 0` when a track must be allowed to shrink.
- `auto-fill` preserves empty tracks; `auto-fit` collapses them and lets the remaining tracks grow.
- `grid-template-areas` describes the shape; named lines describe the boundaries. Both beat counting track numbers.
- `dense` changes visual order only. Use it for decorative mosaics, not for sequences people navigate.
- Subgrid aligns nested content to the parent''s tracks where supported. Grid is overkill for a one-dimensional stack.

**Up next:** positioning and stacking — how elements leave normal flow, which ancestor becomes their containing block, and why `z-index: 9999` still loses to a parent with `transform`.


', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_2_3', 'sec_html_css_advanced_2', 'crs_html_css_advanced', 'Positioning and stacking: absolute, sticky and z-index', 'interactive', 2, 1320, NULL, NULL, 'Normal flow is the layout the browser would choose if you said nothing. Block boxes stack vertically, inline boxes run along a line, and every box takes up exactly the space its content needs. Most of the time that is the correct layout. Positioning becomes necessary when you need a badge on a card, a header that stays visible, a menu that overlaps the page, or a dialog above everything else.

The trouble starts when positioning is used as a shortcut for layout. An absolutely positioned element is removed from flow, so it no longer pushes its neighbours around; a `z-index` arms race begins the moment two positioned elements overlap. This lesson builds the model underneath both: what a positioned element is positioned *against*, and which stacking context actually decides who paints on top.

## Normal flow is the baseline

In normal flow, a block-level element''s width is constrained by its containing block and its height is decided by its content. Its siblings sit above and below it. Inline elements sit on a line, wrap at spaces, and reserve only the width of their text.

`position: relative` is the gentlest departure from that model. The element is still laid out exactly where it would have been, and it still reserves its original space. The `top`, `right`, `bottom` and `left` values (or the logical `inset-*` equivalents) then shift the painted box without moving its neighbours. That is why a relatively positioned element can overlap the next paragraph while leaving a gap where it used to be.

```html run
<figure class="photo">
  <div class="sky" aria-hidden="true"></div>
  <figcaption class="caption">Kinder Scout, 6:12am</figcaption>
</figure>
<p class="note">The caption is positioned against the figure, not against the page.</p>

<style>
  body { margin: 0; padding: 28px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .photo {
    position: relative;
    max-width: 520px;
    margin: 0;
    border-radius: 14px;
    overflow: hidden;
  }
  .sky {
    height: 240px;
    background: linear-gradient(160deg, #0f172a, #0f766e 60%, #f59e0b);
  }
  .caption {
    position: absolute;
    left: 16px;
    bottom: 16px;
    padding: 6px 10px;
    border-radius: 999px;
    background: rgb(15 23 42 / 0.8);
    color: white;
    font-size: 13px;
  }
  .note { max-width: 520px; color: #475569; line-height: 1.5; }
</style>
```

The figure is the **containing block** for the caption. Remove `position: relative` from `.photo` and the caption would position itself against the initial containing block — the viewport-sized box at the root of the document — and appear in the bottom-left corner of the page. The gradient would still be there; the caption would simply belong to a different coordinate system.

## The containing block is the contract

For an absolutely positioned element, the containing block is the padding box of the nearest ancestor whose `position` is not `static`. If no such ancestor exists, it is the initial containing block. This is the single most useful rule in the lesson: **absolute positioning is relative to an ancestor, not to the element before it in the markup.**

```html run
<div class="field">
  <label for="email">Work email</label>
  <div class="control">
    <input id="email" type="email" placeholder="you@studio.co">
    <button class="help" type="button" aria-label="Email help">?</button>
    <div class="tooltip" role="tooltip">We only use this for receipts and build alerts.</div>
  </div>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .field { max-width: 380px; }
  label { display: block; margin-bottom: 8px; font-weight: 600; color: #0f172a; }
  .control { position: relative; }
  input { width: 100%; box-sizing: border-box; padding: 12px 44px 12px 14px; border: 1px solid #cbd5e1; border-radius: 10px; font: inherit; }
  .help {
    position: absolute; top: 50%; right: 10px; translate: 0 -50%;
    width: 28px;
    height: 28px;
    border: 0;
    border-radius: 50%;
    background: #0f172a;
    color: white;
    font-weight: 700;
    cursor: help;
  }
  .tooltip {
    position: absolute;
    top: calc(100% + 8px);
    left: 0;
    padding: 10px 12px;
    border-radius: 8px;
    background: #0f172a;
    color: #e2e8f0;
    font-size: 13px;
    line-height: 1.4;
  }
</style>
```

The button and tooltip both use `.control` as their containing block. The button is centred vertically with `top: 50%` and `translate: 0 -50%`; the tooltip starts just below the control with `top: calc(100% + 8px)`. Neither of those percentages refers to the input, the label or the viewport. They refer to the padding box of `.control`.

A few consequences follow:

- If you forget `position: relative` on the parent, the element escapes to the nearest positioned ancestor — often the page — and lands somewhere surprising when the page scrolls.
- `position: fixed` is similar, but its containing block is the viewport unless an ancestor has a `transform`, `filter`, `perspective`, `contain` or `will-change` that creates a containing block. That exception is a common source of "why is my fixed header moving with the page?"
- Absolute positioning does not reserve space. If the positioned element is the only thing giving a container height, the container collapses.

> **Pitfall:** `inset: 0` on an absolutely positioned element makes it fill its containing block only when the element has no width or height constraints that fight it. For a centred box, `inset: 0; width: 240px; height: 120px; margin: auto;` is a legitimate pattern, but `display: grid; place-items: center` is usually easier to read.

## Challenge: a badge in the corner

Product cards often need a small status marker: "New", "Low stock", "Staff pick". The badge should sit in the top-right corner of the card without pushing the heading or the description around. The card already has the right size and spacing; the badge is currently an ordinary inline element at the end of the content.

Make the card the badge''s containing block and pin the badge to the top-right corner with a 12-pixel inset.

```html exercise id=position-card-badge title="Pin a badge to the card corner"
<article class="card">
  <p class="eyebrow">Trailhead Coffee</p>
  <h2>Winter blend</h2>
  <p>Dark chocolate, dried cherry and a finish that lasts longer than the walk home.</p>
  <span class="badge">New</span>
</article>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    width: 360px;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: white;
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 999px;
    background: #b45309;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
</style>
--- solution
<article class="card">
  <p class="eyebrow">Trailhead Coffee</p>
  <h2>Winter blend</h2>
  <p>Dark chocolate, dried cherry and a finish that lasts longer than the walk home.</p>
  <span class="badge">New</span>
</article>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card {
    position: relative;
    width: 360px;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: white;
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  .badge {
    position: absolute;
    top: 12px;
    right: 12px;
    display: inline-block;
    padding: 4px 10px;
    border-radius: 999px;
    background: #b45309;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
</style>
--- test
assertStyle(".card", "position", "relative");
assertStyle(".badge", "position", "absolute");
const card = query(".card").getBoundingClientRect();
const badge = query(".badge").getBoundingClientRect();
assert(badge.width < card.width / 2, "The badge should stay compact, not stretch across the card.");
const topGap = badge.top - card.top;
const rightGap = card.right - badge.right;
assert(topGap >= 0 && topGap <= 24, `The badge''s top edge is ${Math.round(topGap)}px from the card''s top edge. Pin it near the corner.`);
assert(rightGap >= 0 && rightGap <= 24, `The badge''s right edge is ${Math.round(rightGap)}px from the card''s right edge. Pin it near the corner.`);
assertColor(".badge", "background-color", "#b45309");
--- hint
The badge needs to be positioned against the card, so the card must become its containing block.
--- hint
Add `position: relative` to `.card`, then `position: absolute; top: 12px; right: 12px` to `.badge`.
```

A badge in the corner is a small example of a large principle: position the *relationship*, not the pixels. The card owns the coordinate system; the badge declares where it sits inside it. Move the card and the badge follows. Change the card''s width and the badge stays pinned to the right edge.

## Sticky is a hybrid

`position: sticky` starts in normal flow and behaves like `relative` until the element crosses a threshold inside its nearest scrolling ancestor. Then it behaves like `fixed` for as long as its containing block remains in view. When the parent scrolls out, the sticky element goes with it. That last clause is what separates sticky from fixed.

```html run
<div class="frame">
  <header class="frame-header">Trailhead / Build log</header>
  <main class="frame-body">
    <p>08:02 — Deploy started.</p>
    <p>08:03 — Assets uploaded.</p>
    <p>08:04 — Cache warmed in three regions.</p>
    <p>08:05 — Health checks passed.</p>
    <p>08:06 — Traffic shifted to the new release.</p>
    <p>08:07 — Queue drained.</p>
    <p>08:08 — Deploy complete.</p>
  </main>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .frame {
    max-width: 620px;
    height: 280px;
    overflow: auto;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .frame-header {
    position: sticky;
    top: 0;
    z-index: 2;
    padding: 14px 18px;
    background: #0f172a;
    color: white;
    font-weight: 700;
  }
  .frame-body { padding: 4px 18px 18px; color: #334155; line-height: 1.6; }
</style>
```

Scroll the frame and the header stays at the top. It is not fixed to the browser window; it is stuck to the top of the scroll container. The requirements are precise:

1. A threshold is set: `top`, `bottom`, `left` or `right`. Without one, sticky behaves like relative.
2. The element has a scrolling ancestor. If no ancestor scrolls, the page is the scroll container and the element sticks relative to the viewport.
3. The containing block is taller than the sticky element, so there is room to stick before the parent leaves.
4. No ancestor between the element and the scroll container has an `overflow` value that creates an unexpected scroll container. `overflow: hidden` is a frequent culprit.

> **Tip:** A sticky element inside a flex or grid container may stretch to the container''s cross size, leaving no room to move. Set `align-self: start` so it keeps its content height.

## Challenge: a sticky site header

Build a header that stays at the top of the page while the article scrolls underneath it. The header already has the dark visual treatment, but it is only relatively positioned, so it scrolls away with the content. It also needs to paint above the article.

The test scrolls the page and checks where the header ends up, so a header that merely has `top: 0` without `position: sticky` will not pass.

```html exercise id=position-sticky-header title="Keep the header at the top"
<header class="site-header">
  <strong>Trailhead Field Notes</strong>
  <nav><a href="#">Archive</a> <a href="#">About</a></nav>
</header>
<main>
  <section><h1>Why the long way round is usually right</h1><p>An essay in four uphill sections.</p></section>
  <section><h2>One: the car park</h2><p>Every walk begins with a decision you cannot undo.</p></section>
  <section><h2>Two: the ridge</h2><p>The wind arrives before the view does.</p></section>
  <section><h2>Three: the descent</h2><p>Knees complain. The light compensates.</p></section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .site-header {
    position: relative;
    top: 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    padding: 16px 24px;
    background: #0f172a;
    color: white;
  }
  .site-header a { color: #cbd5e1; text-decoration: none; margin-left: 12px; }
  main { max-width: 720px; margin: 0 auto; padding: 24px; }
  section { min-height: 280px; border-bottom: 1px solid #e2e8f0; }
  h1, h2 { letter-spacing: -0.02em; }
  p { color: #475569; line-height: 1.6; }
</style>
--- solution
<header class="site-header">
  <strong>Trailhead Field Notes</strong>
  <nav><a href="#">Archive</a> <a href="#">About</a></nav>
</header>
<main>
  <section><h1>Why the long way round is usually right</h1><p>An essay in four uphill sections.</p></section>
  <section><h2>One: the car park</h2><p>Every walk begins with a decision you cannot undo.</p></section>
  <section><h2>Two: the ridge</h2><p>The wind arrives before the view does.</p></section>
  <section><h2>Three: the descent</h2><p>Knees complain. The light compensates.</p></section>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .site-header {
    position: sticky;
    top: 0;
    z-index: 10;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    padding: 16px 24px;
    background: #0f172a;
    color: white;
  }
  .site-header a { color: #cbd5e1; text-decoration: none; margin-left: 12px; }
  main { max-width: 720px; margin: 0 auto; padding: 24px; }
  section { min-height: 280px; border-bottom: 1px solid #e2e8f0; }
  h1, h2 { letter-spacing: -0.02em; }
  p { color: #475569; line-height: 1.6; }
</style>
--- test
assertStyle(".site-header", "position", "sticky");
assertStyle(".site-header", "top", "0px");
const z = Number(getComputedStyle(query(".site-header")).zIndex);
assert(z >= 10, `The header''s z-index is ${z}. It needs to sit above the scrolling article.`);
window.scrollTo(0, 300);
const top = query(".site-header").getBoundingClientRect().top;
assert(Math.abs(top) < 2, `After scrolling 300px, the header sits ${Math.round(top)}px from the top of the viewport. It should stick at the top.`);
assertColor(".site-header", "background-color", "#0f172a");
--- hint
`position: relative` shifts an element but still lets it scroll away. You need the value that switches between relative and fixed as the page moves.
--- hint
Use `position: sticky`, keep `top: 0`, and give the header a `z-index` so the article cannot paint over it.
```

The `z-index` is not decoration. A sticky header is still in flow, and later content can paint over it if the header has no stacking position. Raising it above the article is part of making the pattern work, not an optional flourish.

## z-index is local, not global

`z-index` only sorts elements **within the same stacking context**. A stacking context is a self-contained layer: everything inside it is painted as one unit relative to its siblings, and no child can escape to outrank an element outside the context, no matter how large its `z-index` is.

A stacking context is created by more things than `position: absolute` plus `z-index`:

- the root element
- a positioned element with a `z-index` other than `auto`
- a fixed or sticky element
- a flex or grid item with a `z-index` other than `auto`
- `opacity` less than `1`
- `transform`, `filter`, `perspective`, `clip-path` or `backdrop-filter` with a value other than `none`
- `isolation: isolate`
- `will-change` naming a property that would create one
- `contain: layout`, `contain: paint` or `contain: strict`

```html run
<div class="stage">
  <div class="context">
    <span class="context-label">parent · isolation: isolate</span>
    <div class="high">child · z-index: 99</div>
  </div>
  <div class="low">sibling · z-index: 1</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stage { position: relative; height: 260px; max-width: 600px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .context {
    position: absolute; top: 28px; left: 28px;
    width: 320px; height: 170px;
    padding: 12px;
    border-radius: 10px;
    background: #e2e8f0;
    isolation: isolate;
  }
  .context-label { color: #475569; font-size: 13px; }
  .high {
    position: absolute; top: 58px; left: 128px;
    z-index: 99;
    padding: 14px 18px;
    border-radius: 8px;
    background: #0f766e;
    color: white;
  }
  .low {
    position: absolute;
    top: 120px;
    left: 220px;
    z-index: 1;
    padding: 14px 18px;
    border-radius: 8px;
    background: #b45309;
    color: white;
  }
</style>
```

The teal child has `z-index: 99`, the amber sibling has `z-index: 1`, and the amber sibling still paints on top. The parent''s `isolation: isolate` created a stacking context at the parent''s level; the child''s 99 only sorts it against other children *inside* that context. To the outside world, the whole teal group is one layer, and the amber sibling is a higher layer.

This is why "just add `z-index: 9999`" fails so often in real code. The element with the enormous number is trapped inside a card that has `transform: translateY(0)`, a wrapper with `opacity: 0.99`, or a parent that became a stacking context for an unrelated animation. The fix is not a bigger number; it is to move the element to the right context, raise the context itself, or remove the property that created the context by accident.

> **Under the hood:** Within a stacking context, the browser paints in layers: the context''s own background and borders, negative `z-index` children, in-flow blocks, floats, inline content, positioned children with `z-index: auto` or `0`, and finally positive `z-index` children. That order is why a positioned element with `z-index: -1` can disappear behind its parent''s background but still sit above the page background.

## Debug: the dropdown behind the theme button

The "Filters" menu opens over a page toolbar, but the dark "Dark mode" button is painted on top of the menu. The menu has `z-index: 100`, so the number is not the problem. A little reveal animation left `opacity: 0.99` on the menu wrapper, which quietly turned the wrapper into a stacking context and trapped the dropdown inside it.

Fix the stacking relationship so the menu paints above the theme button. You can remove the accidental context or raise the wrapper''s own layer; both are valid. The test finds the point where the two boxes overlap and asks the browser what is actually on top.

```html debug id=position-trapped-dropdown title="The dropdown is behind its sibling"
<div class="toolbar">
  <div class="menu-wrap">
    <button class="menu-button" type="button">Filters</button>
    <div class="dropdown">
      <a href="#">All projects</a>
      <a href="#">Recently updated</a>
      <a href="#">Archived</a>
    </div>
  </div>
  <button class="theme-toggle" type="button">Dark mode</button>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { position: relative; display: flex; gap: 12px; }
  .menu-wrap { position: relative; opacity: 0.99; }
  .menu-button, .theme-toggle {
    height: 44px; padding: 0 18px; border: 1px solid #cbd5e1;
    border-radius: 10px; background: white; font: inherit; font-weight: 600; cursor: pointer;
  }
  .dropdown {
    position: absolute; top: 44px; left: 0; z-index: 100;
    width: 280px; padding: 8px; border: 1px solid #cbd5e1;
    border-radius: 12px; background: white; box-shadow: 0 18px 40px rgb(15 23 42 / 0.18);
  }
  .dropdown a {
    display: block; padding: 9px 10px; border-radius: 8px;
    color: #0f172a; text-decoration: none;
  }
  .theme-toggle {
    position: absolute; top: 44px; left: 190px; z-index: 2;
    background: #0f172a; color: white; border-color: #0f172a;
  }
</style>
--- solution
<div class="toolbar">
  <div class="menu-wrap">
    <button class="menu-button" type="button">Filters</button>
    <div class="dropdown">
      <a href="#">All projects</a>
      <a href="#">Recently updated</a>
      <a href="#">Archived</a>
    </div>
  </div>
  <button class="theme-toggle" type="button">Dark mode</button>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toolbar { position: relative; display: flex; gap: 12px; }
  .menu-wrap { position: relative; z-index: 10; }
  .menu-button, .theme-toggle {
    height: 44px; padding: 0 18px; border: 1px solid #cbd5e1;
    border-radius: 10px; background: white; font: inherit; font-weight: 600; cursor: pointer;
  }
  .dropdown {
    position: absolute; top: 44px; left: 0; z-index: 100;
    width: 280px; padding: 8px; border: 1px solid #cbd5e1;
    border-radius: 12px; background: white; box-shadow: 0 18px 40px rgb(15 23 42 / 0.18);
  }
  .dropdown a {
    display: block; padding: 9px 10px; border-radius: 8px;
    color: #0f172a; text-decoration: none;
  }
  .theme-toggle {
    position: absolute; top: 44px; left: 190px; z-index: 2;
    background: #0f172a; color: white; border-color: #0f172a;
  }
</style>
--- test
assertVisible(".dropdown");
const menu = query(".dropdown");
const theme = query(".theme-toggle");
const a = menu.getBoundingClientRect();
const b = theme.getBoundingClientRect();
const left = Math.max(a.left, b.left);
const right = Math.min(a.right, b.right);
const top = Math.max(a.top, b.top);
const bottom = Math.min(a.bottom, b.bottom);
assert(right - left > 20 && bottom - top > 10, "The dropdown and the theme button should overlap; keep the layout as it is.");
const hit = document.elementFromPoint(left + 5, top + 5);
const hitName = hit ? (hit.className || hit.tagName) : "nothing";
assert(menu === hit || menu.contains(hit), `Where the menu overlaps the theme button, the browser paints ${hitName}. The dropdown needs to be above it.`);
--- hint
The dropdown has a large `z-index`, but its parent has `opacity: 0.99`. Look up what `opacity` less than 1 does to the parent''s place in the stacking order.
--- hint
Either remove the opacity from `.menu-wrap`, or give `.menu-wrap` a `z-index` greater than the theme button''s `z-index` while it remains positioned.
```

The lesson generalises: when a `z-index` "does not work", inspect the ancestors before changing the number. Ask which ancestor creates a stacking context, and whether the element that should be underneath is actually outside that context. The browser is not ignoring you; it is sorting at a different level.

```html predict id=position-transform-trap title="Which element paints on top?"
<div class="stage">
  <div class="card">
    <span class="badge">New</span>
  </div>
  <div class="note">Draft saved</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stage { position: relative; height: 240px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .card {
    position: absolute; top: 40px; left: 32px;
    width: 240px; height: 120px;
    border-radius: 12px;
    background: #e2e8f0;
    transform: translateY(0);
  }
  .badge {
    position: absolute; top: -12px; right: -12px;
    z-index: 5;
    padding: 6px 10px;
    border-radius: 999px;
    background: #0f766e;
    color: white;
    font-size: 12px;
    font-weight: 700;
  }
  .note {
    position: absolute; top: 20px; left: 170px;
    z-index: 1;
    padding: 12px 16px;
    border-radius: 8px;
    background: #f59e0b;
    color: #0f172a;
    font-weight: 600;
  }
</style>
--- options
* The note paints above the badge, because the card''s transform traps the badge in a lower stacking context
The badge paints above the note, because its z-index is 5 and the note''s is 1
The two elements blend, because both have a z-index
The badge is invisible, because z-index only works on the page root
--- explain
`transform: translateY(0)` is not a no-op for stacking. It creates a stacking context on `.card` at the card''s level in the parent context. The badge''s `z-index: 5` only competes with other children inside that card. The note is a sibling of the card in the root context, with `z-index: 1`, so it paints above the entire card, badge included. Removing the transform would let the badge''s 5 compete globally and win.

## Overlays and dialogs

A visual overlay is easy: a fixed element with `inset: 0`, a translucent background and a centred panel. An accessible modal is harder, because it is a behaviour contract, not a paint order. The background must become inert, focus must move into the dialog and stay there, Escape must close it, and closing must return focus to the control that opened it.

```html run
<p class="page-copy">The report is ready to publish. Review the summary before it goes live.</p>

<div class="backdrop">
  <section class="dialog">
    <p class="eyebrow">Publish report</p>
    <h2>Send to the team?</h2>
    <p>Everyone in the analytics group will get an email with a link to this snapshot.</p>
    <div class="actions">
      <button class="secondary" type="button">Keep editing</button>
      <button class="primary" type="button">Publish</button>
    </div>
  </section>
</div>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .page-copy { max-width: 520px; color: #334155; line-height: 1.6; }
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 100;
    display: grid;
    place-items: center;
    padding: 16px;
    background: rgb(2 6 23 / 0.62);
  }
  .dialog {
    width: min(420px, 100%);
    padding: 24px;
    border-radius: 16px;
    background: white;
    box-shadow: 0 24px 60px rgb(2 6 23 / 0.3);
  }
  .eyebrow { margin: 0 0 6px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .dialog h2 { margin: 0 0 8px; color: #0f172a; }
  .dialog p { margin: 0 0 20px; color: #475569; line-height: 1.5; }
  .actions { display: flex; justify-content: flex-end; gap: 8px; }
  button { padding: 10px 14px; border-radius: 9px; border: 1px solid #cbd5e1; font: inherit; font-weight: 600; cursor: pointer; }
  .secondary { background: white; color: #0f172a; }
  .primary { background: #0f766e; border-color: #0f766e; color: white; }
</style>
```

This is the visual layer only. In production, reach for the native `<dialog>` element and `showModal()`. A modal dialog is promoted to the browser''s **top layer**, so it paints above every stacking context without a `z-index` arms race. The browser also makes the rest of the document inert, moves focus into the dialog, closes on Escape and restores focus on close. `::backdrop` styles the layer behind it.

If you must build a custom dialog with a `div`, you are taking on all of that behaviour: `role="dialog"`, `aria-modal="true"`, `aria-labelledby`, focus trapping, Escape handling, scroll locking and focus restoration. A translucent rectangle with a high `z-index` is not a dialog; it is a picture of one.

> **Pitfall:** Do not put `aria-hidden="true"` on the page behind a visual overlay while leaving its links and buttons focusable. That combination hides content from screen readers but leaves it reachable by keyboard, which is worse than doing nothing.

## Avoiding layout hacks

Positioning is seductive because it can place anything anywhere. The cost is that the result no longer responds to its content. A few habits keep that cost under control:

- Use `position: relative` only to establish a containing block or a stacking context, not to nudge elements into place. If you find yourself writing `top: -3px` to align text, check `align-items`, `line-height` or `vertical-align` first.
- Use absolute positioning for things that genuinely overlay: badges, tooltips, menus, close buttons, decorative layers. Keep the underlying layout in flow so the container still has a height.
- Use `position: fixed` for persistent chrome, and remember that a transformed ancestor can capture it. Prefer a top-level portal or the native top layer for modals.
- Use `z-index` within a known context. Name the layers in comments or custom properties (`--layer-header`, `--layer-menu`, `--layer-modal`) instead of inventing 9999.
- Do not use absolute positioning to build a two-column page. Grid and flexbox keep the columns in flow and let them respond to content.

> **In the wild:** Design systems often define a small set of layer tokens and forbid arbitrary `z-index` values. The constraint is not bureaucracy; it is the only reliable way to keep a dropdown, a sticky header and a modal from fighting when they appear on the same screen.

## Recap

- Normal flow is the default and usually the right layout. Positioning is for relationships that flow cannot express.
- `relative` shifts the painted box but keeps the original space. `absolute` removes the box from flow and uses the nearest positioned ancestor''s padding box.
- `fixed` uses the viewport unless an ancestor creates a containing block with `transform`, `filter`, `perspective`, `contain` or `will-change`.
- `sticky` needs a threshold, a scrolling ancestor and room in its containing block.
- A stacking context is atomic. A child''s `z-index` cannot escape it; `transform`, `opacity`, `filter` and `isolation` create contexts silently.
- Native `<dialog>` with `showModal()` gives you the top layer, focus management and Escape for free. A styled `div` gives you only the picture.
- Prefer flow layout, named layer tokens and small, intentional overlays over absolute positioning and escalating `z-index` values.

**Up next:** responsive systems — container queries that respond to a component''s own width, fluid type with `clamp()`, and logical properties that survive a change of writing direction.

', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_2_4', 'sec_html_css_advanced_2', 'crs_html_css_advanced', 'Responsive systems: container queries, fluid type and logical properties', 'interactive', 3, 1440, NULL, NULL, 'A component does not know how wide the viewport is. It knows how much room its parent gave it. That distinction is the difference between a card that looks right on the marketing site and the same card looking broken inside a 320-pixel sidebar. Media queries answer the first question; container queries answer the second.

This lesson builds a responsive system rather than a set of breakpoints. You will make components respond to their own space, let type scale fluidly between a floor and a ceiling, use logical properties so the layout survives a change of writing direction, and respect the two preferences users actually set: less motion and a dark interface.

## Media queries answer the viewport

A media query is a condition on the **viewport** (and on user preferences, input capabilities and media type). It is excellent for page-level decisions: whether the navigation becomes a drawer, whether a hero uses a two-column layout, whether print styles apply. It is the wrong tool for a reusable component, because the component may appear in a wide main column and a narrow sidebar on the same screen.

```html run
<div class="row">
  <div class="slot narrow">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div>
        <h2>Ada Rao</h2>
        <p>Design engineer</p>
      </div>
    </article>
  </div>
  <div class="slot wide">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div>
        <h2>Ada Rao</h2>
        <p>Design engineer</p>
      </div>
    </article>
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; align-items: flex-start; }
  .slot { padding: 8px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .narrow { width: 300px; }
  .wide { width: 600px; }
  .profile { padding: 16px; border-radius: 12px; background: white; border: 1px solid #e2e8f0; }
  .avatar { display: grid; place-items: center; width: 56px; height: 56px; border-radius: 50%; background: #0f172a; color: white; font-weight: 700; }
  .profile h2 { margin: 0 0 4px; font-size: 1.1rem; color: #0f172a; }
  .profile p { margin: 0; color: #64748b; }
  @media (min-width: 700px) {
    .profile { display: grid; grid-template-columns: 56px 1fr; gap: 16px; align-items: center; }
  }
</style>
```

Both profiles switched to the horizontal layout at the same moment, because the viewport is 1100 pixels wide. The left slot is only 300 pixels wide, so the horizontal layout is cramped and the name has less room than it needs. The viewport gave the component information that was true for the page but false for the component.

> **Pitfall:** Adding more media queries does not fix this. You would need a query for every context the component might appear in, and the component would still break the first time a designer put it somewhere new. The missing information is the container''s width.

## Container queries answer the component

A container query asks an ancestor for its size. You opt an element into being a **query container** with `container-type`, then write `@container` rules that apply to its descendants. The nearest ancestor with the required containment is the one that answers.

```html run
<div class="row">
  <div class="slot narrow">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div><h2>Ada Rao</h2><p>Design engineer</p></div>
    </article>
  </div>
  <div class="slot wide">
    <article class="profile">
      <div class="avatar" aria-hidden="true">AR</div>
      <div><h2>Ada Rao</h2><p>Design engineer</p></div>
    </article>
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .row { display: flex; gap: 24px; align-items: flex-start; }
  .slot {
    container: profile / inline-size;
    padding: 8px;
    border: 1px dashed #cbd5e1;
    border-radius: 12px;
  }
  .narrow { width: 300px; }
  .wide { width: 600px; }
  .profile { padding: 16px; border-radius: 12px; background: white; border: 1px solid #e2e8f0; }
  .avatar { display: grid; place-items: center; width: 56px; height: 56px; border-radius: 50%; background: #0f172a; color: white; font-weight: 700; }
  .profile h2 { margin: 0 0 4px; font-size: 1.1rem; color: #0f172a; }
  .profile p { margin: 0; color: #64748b; }
  @container profile (min-width: 420px) {
    .profile { display: grid; grid-template-columns: 56px 1fr; gap: 16px; align-items: center; }
  }
</style>
```

Now the left profile stays vertical and the right one goes horizontal, even though both are on the same page at the same viewport width. The `container` shorthand sets a name (`profile`) and a type (`inline-size`). The name is optional; it becomes essential when nested containers could answer the same query.

`container-type: inline-size` applies **inline-size containment**: the container''s inline size must not depend on its contents. In a horizontal writing mode that means its width. This is what makes the query possible without a circular dependency, but it also means the container needs a width from its parent — a grid track, a flex basis, a fixed width, or normal block flow. A container with `display: inline` and no width has nothing useful to report.

There are two practical rules that prevent most container-query bugs:

- A container query styles descendants, never the container itself. Put `container-type` on a wrapper, then query from the card inside it.
- The query measures the container''s **content box**. Padding and borders reduce the inline size the query sees.
- `cqi` is one percent of the nearest query container''s inline size. It is useful for spacing or type that should scale with the component rather than the viewport.

> **Under the hood:** `container-type: size` contains both axes and lets you query height as well as width, but the element then needs an explicit height. Most component queries should use `inline-size`; height-based queries are rare and much easier to get wrong.

## Predict: which query applies?

```html predict id=responsive-container-query title="Which container rule wins at 480px?"
<div class="panel">
  <p class="status">All systems normal</p>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .panel {
    container-type: inline-size;
    width: 480px;
    box-sizing: border-box;
    padding: 20px;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    background: white;
  }
  .status { margin: 0; color: #64748b; }
  @container (min-width: 360px) {
    .status { color: #0f766e; font-weight: 700; }
  }
  @container (min-width: 520px) {
    .status { color: #b91c1c; }
  }
</style>
--- options
* The status is teal and bold, because only the 360px query matches
The status is red, because the 520px query is more specific
The status stays grey, because the panel is exactly 480px
Both queries match, so the text alternates between teal and red
--- explain
Container queries are independent conditions, not a ladder of breakpoints. At a 440px content width (480px minus 40px of padding), the 360px query is true and the 520px query is false. Only one rule applies, so the status is teal and bold. If both matched, normal cascade order would decide; there is no special "larger query wins" rule.
```

## Challenge: make the card respond to its container

The card below already has a thumbnail and a body. It is set up to go horizontal when there is room, but the rule is a viewport media query, so both cards switch at 1100 pixels even though the left wrapper is only 300 pixels wide. Move the decision to the container.

Keep the existing markup and visual styles. Change the query so the 620-pixel card is horizontal and the 300-pixel card stays stacked. The wrappers already declare `container-type: inline-size`; you need to replace the media query with a container query and choose a sensible threshold.

```html exercise id=responsive-container-card title="Let the card respond to its container"
<div class="card-wrap narrow">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<div class="card-wrap wide">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<style>
  * { box-sizing: border-box; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card-wrap { container-type: inline-size; margin-bottom: 24px; }
  .narrow { width: 300px; }
  .wide { width: 620px; }
  .card { display: grid; gap: 16px; padding: 20px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { height: 120px; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .eyebrow { margin: 0 0 4px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .body h2 { margin: 0 0 6px; color: #0f172a; }
  .body p:last-child { margin: 0; color: #475569; line-height: 1.5; }
  @media (min-width: 700px) {
    .card { grid-template-columns: 150px 1fr; align-items: center; }
  }
</style>
--- solution
<div class="card-wrap narrow">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<div class="card-wrap wide">
  <article class="card">
    <div class="thumb" aria-hidden="true"></div>
    <div class="body">
      <p class="eyebrow">Trail notes</p>
      <h2>Kinder Scout at dawn</h2>
      <p>Nine kilometres, one very short sunrise and a flask that leaked.</p>
    </div>
  </article>
</div>

<style>
  * { box-sizing: border-box; }
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card-wrap { container-type: inline-size; margin-bottom: 24px; }
  .narrow { width: 300px; }
  .wide { width: 620px; }
  .card { display: grid; gap: 16px; padding: 20px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { height: 120px; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .eyebrow { margin: 0 0 4px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
  .body h2 { margin: 0 0 6px; color: #0f172a; }
  .body p:last-child { margin: 0; color: #475569; line-height: 1.5; }
  @container (min-width: 420px) {
    .card { grid-template-columns: 150px 1fr; align-items: center; }
  }
</style>
--- test
assertStyle(".card-wrap", "container-type", "inline-size");
const narrowThumb = query(".narrow .thumb").getBoundingClientRect();
const narrowBody = query(".narrow .body").getBoundingClientRect();
const wideThumb = query(".wide .thumb").getBoundingClientRect();
const wideBody = query(".wide .body").getBoundingClientRect();
assert(narrowBody.top >= narrowThumb.bottom - 1, "In the 300px container the body is still beside the thumbnail. It should stack below it.");
assert(wideBody.left >= wideThumb.right + 8, "In the 620px container the body should sit to the right of the thumbnail, not below it.");
assertColor(".wide .card", "background-color", "#ffffff");
--- hint
The wrapper is already a query container. The card needs a rule that responds to the wrapper''s width, not the viewport''s.
--- hint
Replace `@media (min-width: 700px)` with `@container (min-width: 420px)`. The `.card` selector stays the same because the query applies to the container''s descendants.
```

The threshold is a design decision, not a magic number. What matters is that the card has enough room for a 150-pixel thumbnail, a gap and a readable measure of text. A container query lets that decision travel with the component instead of being tied to the screen it happens to be on.

## Fluid type with `clamp()`

Breakpoints are a blunt instrument for typography. A headline that jumps from 32 to 48 pixels at exactly 768 pixels looks like a decision someone made in a meeting. Fluid type lets the size move continuously between a minimum and a maximum, with a preferred value that responds to the viewport.

`clamp(min, preferred, max)` returns the preferred value, pushed up to the minimum if it is too small and down to the maximum if it is too large. The preferred value is usually a mix of `rem` and `vw`: the `vw` makes it fluid, and the `rem` keeps it connected to the user''s font size.

```html run
<h1 class="hero-title">The long way round</h1>
<p class="meta">A field guide to taking the scenic route, for people who still read the signs.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .hero-title {
    margin: 0 0 12px;
    max-width: 16ch;
    font-size: clamp(2.5rem, 1.5rem + 4vw, 5rem);
    line-height: 1.02;
    letter-spacing: -0.04em;
  }
  .meta { max-width: 46ch; margin: 0; color: #475569; line-height: 1.6; }
</style>
```

At 1100 pixels the preferred value is `24px + 44px`, so the headline lands around 68 pixels: above the 40-pixel floor, below the 80-pixel ceiling. Shrink the preview and it slides down toward 40; widen it and it stops at 80. No breakpoint is involved.

Three rules keep fluid type readable:

- **Use `rem` in the minimum and maximum.** A pure `vw` formula ignores the user''s text-size setting and can fail a zoom test. `2.5rem` respects the root font size.
- **Choose a minimum that still fits the smallest supported screen.** A 16-character headline at 40 pixels may still wrap to four lines on a 320-pixel phone; test it.
- **Keep the preferred term simple.** `1.5rem + 4vw` is readable. A chain of three `calc()` expressions is a sign that the type scale needs a designer, not more arithmetic.

> **Pitfall:** If the minimum is larger than the maximum, `clamp()` does not "fix" the order. The minimum wins, because the function is defined as `max(min, min(preferred, max))`. If the preferred expression is invalid, the whole declaration is dropped and the element falls back to its inherited or user-agent size. Both mistakes look like "the font size is ignoring me."

## Challenge: a fluid hero headline

The hero already has the copy and the layout. The headline is stuck at 28 pixels, which is fine on a phone and far too timid on a desktop. Give it a fluid size that stays readable on small screens and grows to a confident display size on wide ones.

Use `clamp()` with a minimum of `2rem`, a preferred value of `1rem + 3.5vw`, and a maximum of `4.5rem`. At this viewport the result should land between 48 and 62 pixels.

```html exercise id=responsive-fluid-hero title="Give the hero a fluid headline"
<section class="hero">
  <p class="eyebrow">Field notes · Issue 14</p>
  <h1 class="hero-title">The long way round is usually the right way</h1>
  <p class="lede">A slower route, a heavier pack and a better story at the end of it.</p>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 900px; }
  .eyebrow { margin: 0 0 10px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .hero-title {
    margin: 0 0 16px;
    max-width: 18ch;
    color: #0f172a;
    font-size: 28px;
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 48ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- solution
<section class="hero">
  <p class="eyebrow">Field notes · Issue 14</p>
  <h1 class="hero-title">The long way round is usually the right way</h1>
  <p class="lede">A slower route, a heavier pack and a better story at the end of it.</p>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .hero { max-width: 900px; }
  .eyebrow { margin: 0 0 10px; color: #0f766e; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  .hero-title {
    margin: 0 0 16px;
    max-width: 18ch;
    color: #0f172a;
    font-size: clamp(2rem, 1rem + 3.5vw, 4.5rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .lede { max-width: 48ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- test
const title = query(".hero-title");
const size = parseFloat(getComputedStyle(title).fontSize);
assert(size >= 48 && size <= 62, `At this viewport the headline computes to ${size}px. The fluid range should put it between 48 and 62px.`);
let cssText = "";
for (const sheet of Array.from(document.styleSheets)) {
  try {
    for (const rule of Array.from(sheet.cssRules)) cssText += rule.cssText + " ";
  } catch (error) {}
}
assert(/clamp\(/.test(cssText), "The headline size should come from clamp(), so it can scale between a minimum and a maximum instead of sitting at one fixed value.");
assertColor(".hero-title", "color", "#0f172a");
--- hint
Replace the fixed `28px` with a `clamp()` whose middle term mixes `rem` and `vw`.
--- hint
`clamp(2rem, 1rem + 3.5vw, 4.5rem)` gives you the floor, the fluid middle and the ceiling. Keep the line-height and letter-spacing you already have.
```

The test reads the computed size at 1100 pixels, which is why the expected range is narrow. The stylesheet check is there because a fixed `54px` would happen to pass the geometry check at this one width while failing the actual goal: a size that responds to the viewport.

## Debug: the headline that will not scale

This display headline is supposed to be fluid, but it renders at the browser''s default heading size. The `clamp()` middle term has a syntax error, so the browser throws away the entire `font-size` declaration. Fix the expression.

The intended formula is `clamp(2rem, 1rem + 3vw, 4rem)`. At 1100 pixels that should land near 49 pixels, not 32.

```html debug id=responsive-broken-clamp title="The headline ignores its clamp"
<h1 class="display">Trail notes for the long way round</h1>
<p class="standfirst">A slower route, a heavier pack and a better story at the end of it.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .display {
    max-width: 14ch;
    margin: 0 0 16px;
    color: #0f172a;
    font-size: clamp(2rem, 1rem +, 4rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .standfirst { max-width: 46ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- solution
<h1 class="display">Trail notes for the long way round</h1>
<p class="standfirst">A slower route, a heavier pack and a better story at the end of it.</p>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .display {
    max-width: 14ch;
    margin: 0 0 16px;
    color: #0f172a;
    font-size: clamp(2rem, 1rem + 3vw, 4rem);
    line-height: 1.04;
    letter-spacing: -0.04em;
  }
  .standfirst { max-width: 46ch; margin: 0; color: #475569; font-size: 1.05rem; line-height: 1.6; }
</style>
--- test
const size = parseFloat(getComputedStyle(query(".display")).fontSize);
assert(size >= 45 && size <= 53, `The headline computes to ${size}px. The intended clamp should land near 49px at this width; the current declaration is being dropped.`);
assertColor(".display", "color", "#0f172a");
--- hint
Open the preview and inspect the headline. If the size looks like the browser''s default `h1`, the declaration probably never parsed.
--- hint
The middle term `1rem +` is incomplete. It needs a value after the plus sign before the comma: `1rem + 3vw`.
```

The browser does not warn you about an invalid declaration. It parses the rule, finds the value invalid, drops that declaration and moves on. The only symptom is the fallback: in this case the user-agent `h1` size. A missing closing parenthesis or a stray comma produces the same silent failure.

## Viewport units and the mobile chrome problem

`100vh` sounds like "the height of the screen". On a phone it has historically meant the height of the **largest** viewport, the one you get after the address bar hides. A hero set to `100vh` therefore extends under the browser chrome, and the bottom of the content is hidden until the user scrolls. The modern viewport units fix that by naming the three sizes explicitly.

```html run
<section class="masthead">
  <p class="kicker">Issue 14 · Field notes</p>
  <h1>Walk until the map runs out.</h1>
  <p class="intro">A slower route, a heavier pack and a better story at the end of it.</p>
</section>
<p class="below">The next section starts after the masthead. The masthead uses the dynamic viewport unit, so it is never taller than the visible screen.</p>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .masthead {
    display: grid;
    align-content: center;
    min-height: 60vh;
    min-height: 60dvh;
    padding: 32px;
    background: linear-gradient(150deg, #0f172a, #0f766e);
    color: white;
  }
  .kicker { margin: 0 0 12px; font-size: 12px; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; color: #99f6e4; }
  .masthead h1 { max-width: 14ch; margin: 0 0 12px; font-size: clamp(2.5rem, 1.5rem + 4vw, 5rem); line-height: 1.02; letter-spacing: -0.04em; }
  .intro { max-width: 44ch; margin: 0; color: #ccfbf1; line-height: 1.6; }
  .below { max-width: 620px; margin: 0; padding: 24px 32px; color: #475569; line-height: 1.6; }
</style>
```

The three units are:

| Unit | Meaning |
|---|---|
| `svh` | Small viewport height: the screen with the browser chrome visible. |
| `lvh` | Large viewport height: the screen with the chrome hidden. |
| `dvh` | Dynamic viewport height: changes as the chrome shows or hides. |

Use `svh` when you need a guaranteed fit, `lvh` when you are deliberately filling the screen, and `dvh` when you want the layout to track the visible area. `dvh` updates during scrolling, which can cause extra layout work; do not use it on every element. Always keep a `vh` fallback immediately before it for older engines.

> **Pitfall:** Avoid `width: 100vw` for full-width elements. `vw` includes the vertical scrollbar in some desktop browsers, so a `100vw` element can create horizontal overflow. Use `width: 100%` or the parent''s block size instead.

## Aspect ratio and a responsive spacing scale

`aspect-ratio` reserves space before an image or video loads, which prevents the layout from jumping when the media arrives. It also lets a decorative panel keep a deliberate shape as its width changes. If you set both the width and the height, `aspect-ratio` is ignored; it is a preference, not a command.

```html run
<div class="gallery">
  <article class="tile">
    <div class="thumb" aria-hidden="true"></div>
    <h2>Ridge line</h2>
    <p>A steady climb with a view that arrives all at once.</p>
  </article>
  <article class="tile">
    <div class="thumb alt" aria-hidden="true"></div>
    <h2>Valley floor</h2>
    <p>An easier walk, a longer lunch and more birds.</p>
  </article>
</div>

<style>
  :root { --gap: clamp(12px, 1rem + 1vw, 24px); }
  body { margin: 0; padding: var(--gap); font-family: system-ui, sans-serif; background: #f8fafc; }
  .gallery { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: var(--gap); max-width: 820px; }
  .tile { padding: var(--gap); border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .thumb { aspect-ratio: 16 / 9; border-radius: 10px; background: linear-gradient(135deg, #0f172a, #0f766e); }
  .thumb.alt { background: linear-gradient(135deg, #7c2d12, #f59e0b); }
  .tile h2 { margin: 12px 0 6px; font-size: 1.1rem; color: #0f172a; }
  .tile p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

The spacing token is a small responsive system of its own. `clamp(12px, 1rem + 1vw, 24px)` grows with the viewport but never collapses below 12 pixels or balloons past 24. Use a handful of these tokens for section padding, card gaps and page gutters instead of writing a new media query for every spacing value.

For replaced content, pair the ratio with `object-fit`:

```css
.thumb img { width: 100%; height: 100%; object-fit: cover; }
```

The ratio decides the box; `object-fit` decides how the image fills it without distortion.

## Logical properties survive a change of direction

Physical properties name sides: `margin-left`, `padding-top`, `border-right`. Logical properties name **axes**: inline (the direction text runs) and block (the direction lines stack). In English, inline is left-to-right and block is top-to-bottom. In Arabic or Hebrew, inline is right-to-left. In vertical writing modes, the axes rotate again.

```html run
<div class="stack">
  <div class="callout" dir="ltr">
    <strong>Left-to-right:</strong> the accent sits on the inline-start edge.
  </div>
  <div class="callout" dir="rtl">
    <strong>Right-to-left:</strong> the same CSS puts the accent on the other side.
  </div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .stack { display: grid; gap: 12px; max-width: 560px; }
  .callout {
    border-inline-start: 4px solid #0f766e;
    padding-inline: 16px;
    padding-block: 12px;
    margin-inline-start: 8px;
    border-radius: 8px;
    background: white;
    color: #334155;
    line-height: 1.5;
    text-align: start;
  }
</style>
```

The CSS is identical for both boxes. Only the `dir` attribute changes, and the accent, padding and margin follow the writing direction. The same vocabulary scales to sizes: `inline-size` is the width in a horizontal writing mode, `block-size` is the height, and `inset-inline-start` replaces `left` when you mean "the start of the line" rather than "the left of the screen".

Adopting logical properties is mostly a naming discipline. Start with the properties you use most — `margin-inline`, `padding-block`, `inset-inline`, `border-inline-start` — and use physical properties only when you genuinely mean a physical side, such as a shadow that must fall downward regardless of direction.

## Preferences are part of the system

Two media queries deserve a place in every component library: `prefers-reduced-motion` and `prefers-color-scheme`. The first is an accessibility requirement, not a nicety. The second is an expectation users have learned from their operating system.

```html run
<article class="notice">
  <h2>Your export is ready</h2>
  <p>The CSV contains 14,208 rows and is available for the next 24 hours.</p>
  <button type="button">Download CSV</button>
</article>

<style>
  :root {
    color-scheme: light dark;
    --page: #f8fafc;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
  }
  @media (prefers-color-scheme: dark) {
    :root { --page: #020617; --surface: #0f172a; --text: #e2e8f0; --muted: #94a3b8; }
  }
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: var(--page); color: var(--text); }
  .notice {
    max-width: 480px;
    padding: 24px;
    border: 1px solid color-mix(in srgb, var(--muted) 30%, transparent);
    border-radius: 14px;
    background: var(--surface);
    color: var(--text);
    transition: background-color 200ms ease, color 200ms ease;
  }
  .notice h2 { margin: 0 0 8px; font-size: 1.2rem; }
  .notice p { margin: 0 0 18px; color: var(--muted); line-height: 1.5; }
  .notice button { padding: 10px 14px; border: 0; border-radius: 9px; background: #0f766e; color: white; font: inherit; font-weight: 600; cursor: pointer; }
  @media (prefers-reduced-motion: reduce) {
    .notice { transition: none; }
  }
</style>
```

`color-scheme: light dark` tells the browser the page supports both schemes and lets it style form controls, scrollbars and the canvas to match. The custom properties swap the surface and text colours; `color-mix()` derives a border without a fourth token. The reduced-motion query removes the colour transition for people who have asked the system to minimise animation.

> **Tip:** Test both preferences in the browser''s rendering panel. In Chrome DevTools, open **Rendering**, then set **Emulate CSS media feature prefers-color-scheme** and **prefers-reduced-motion**. Testing only the default state is how a dark theme ships with unreadable grey text.

## Testing at multiple widths

A responsive system is not verified by resizing the browser once. Test at least three viewport widths — 320, 768 and 1440 pixels — and, separately, at the container widths your components actually encounter. The component that looks fine at 1440 may sit in a 280-pixel sidebar on that same screen.

A practical checklist:

- At 320 pixels, does anything overflow horizontally? Check long words, code blocks, tables and fixed-width media.
- At 200% zoom, does the layout still work, or does it assume a desktop viewport and clip?
- Does every interactive element remain reachable by keyboard, and does the focus ring remain visible?
- Do images reserve their space with `aspect-ratio` or explicit dimensions, so the page does not shift while loading?
- Does the component still look intentional when its container is much narrower or wider than the viewport?
- With reduced motion and dark mode enabled, are the final states still visible and legible?

> **In the wild:** Design systems often ship a "container test bench": the same component rendered at 280, 420, 640 and 960 pixels on one page. It catches container-query assumptions faster than any amount of viewport resizing, and it becomes a visual regression target for the team.

## Recap

- Media queries answer the viewport; container queries answer the component''s nearest query container.
- `container-type: inline-size` makes an element a query container. Query its descendants, not itself, and remember that padding reduces the content-box width.
- `clamp(min, preferred, max)` creates fluid type with a floor and a ceiling. Use `rem` in the min and max, and keep the preferred term simple.
- `svh`, `lvh` and `dvh` describe the small, large and dynamic viewport. Avoid `100vw` for full-width blocks.
- `aspect-ratio` reserves space and prevents layout shift; `object-fit` controls how replaced content fills the box.
- Logical properties (`margin-inline`, `padding-block`, `inset-inline`) follow the writing direction instead of the physical screen.
- Respect `prefers-reduced-motion` and `prefers-color-scheme`, and test components at container widths, not just viewport widths.

**Up next:** motion — transitions, transforms and keyframes that make state changes legible without making the interface feel like a slideshow.



', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_2_5', 'sec_html_css_advanced_2', 'crs_html_css_advanced', 'Checkpoint: layout mastery', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `flex-basis` set?","options":["The minimum width of every child","The initial main-size of a flex item before free space is distributed","The cross-axis alignment","The number of items per row"],"answerIndex":1,"explanation":"`flex-basis` is the item''s starting size along the main axis. Growth and shrinkage are calculated from that basis. It behaves like a width for a row, but is axis-aware, and `flex: 1` sets it to `0%`."},{"id":"q2","prompt":"A flex item with a long unbreakable word overflows its container. Which fix targets the usual cause?","options":["Add `overflow: hidden` to every child","Set `min-width: 0` on the flex item so it can shrink below its min-content size","Change `display: flex` to `display: block`","Add `flex-wrap: nowrap`"],"answerIndex":1,"explanation":"Flex items have `min-width: auto`, which prevents them from shrinking below their min-content size. A long word sets that size. `min-width: 0` (or `overflow: hidden`/`overflow-wrap`) lets the item shrink. `overflow: hidden` alone hides content instead of solving the sizing."},{"id":"q3","prompt":"Three items have `flex-grow: 1`, `2` and `1` with `flex-basis: 0`. How is the free space divided?","options":["Equally, one third each","25%, 50%, 25%","50%, 25%, 25%","It depends only on content size"],"answerIndex":1,"explanation":"With a zero basis, the grow factors share the free space in proportion: 1 + 2 + 1 = 4, so the items get 1/4, 2/4 and 1/4 of the space. If the basis were `auto`, existing content size would be added before distributing the remainder."},{"id":"q4","prompt":"What is the difference between `auto-fit` and `auto-fill` in a grid?","options":["They are identical","`auto-fit` collapses empty tracks; `auto-fill` keeps them, so items may not expand to fill the row","`auto-fill` only works with flexbox","`auto-fit` disables `minmax()`"],"answerIndex":1,"explanation":"Both create as many tracks as fit. `auto-fill` leaves empty tracks in place, so the existing items keep their track width. `auto-fit` collapses the empty tracks and lets the remaining tracks grow, which is usually what you want for a responsive card grid."},{"id":"q5","prompt":"Why does `grid-template-columns: repeat(3, 1fr)` sometimes overflow?","options":["`1fr` is not a valid unit","The `1fr` minimum is `auto`, so a long word can force a track wider than its share; use `minmax(0, 1fr)`","Grid always overflows with three columns","You must add `grid-auto-flow: column`"],"answerIndex":1,"explanation":"A bare `1fr` is effectively `minmax(auto, 1fr)`. The `auto` minimum respects min-content, so unbreakable content can push a track wider and overflow the grid. `minmax(0, 1fr)` sets a zero minimum and allows the track to shrink, with wrapping or truncation handling the content."},{"id":"q6","prompt":"What does `grid-template-areas` give you that line numbers do not?","options":["Faster rendering","A visual, named map of the layout that is easier to read and rearrange","Automatic responsive behaviour","The ability to use flexbox inside grid"],"answerIndex":1,"explanation":"Named areas let you draw the layout as a grid of names and assign children with `grid-area`. The CSS visually resembles the result, and rearranging areas for a breakpoint is less error-prone than editing line numbers. It does not add responsiveness by itself."},{"id":"q7","prompt":"Which condition is required for `position: sticky` to work?","options":["A parent with `overflow: visible` and a specified inset such as `top: 0`","`z-index: 9999`","`display: flex` on the parent","A fixed height on the element"],"answerIndex":0,"explanation":"Sticky positioning needs a scroll container and an inset (`top`, `bottom`, etc.) to know when to stick. An ancestor with `overflow: hidden`, `auto` or `scroll` can become the scroll container and change the behaviour. `z-index` may affect stacking but is not what enables sticking."},{"id":"q8","prompt":"A child with `z-index: 9999` still appears behind a sibling. What is the likely reason?","options":["z-index only accepts values below 100","The child is inside a parent that creates a stacking context, so it cannot paint above elements outside that context","The child needs `position: fixed`","z-index does not apply to positioned elements"],"answerIndex":1,"explanation":"A stacking context is an isolated painting layer. If an ancestor creates one (for example with `transform`, `opacity` below 1, `filter` or `isolation`), descendants'' z-index values are resolved inside it and cannot escape above sibling contexts. Raise or restructure the context rather than inflating the number."},{"id":"q9","prompt":"What does a container query respond to?","options":["The viewport width only","The size of the nearest ancestor with `container-type` set","The number of children in the container","The user''s color scheme"],"answerIndex":1,"explanation":"Container queries let a component respond to its own available space rather than the viewport. You declare `container-type: inline-size` on an ancestor and use `@container (min-width: …)`. This makes components reusable in sidebars and wide main columns without viewport-specific overrides."},{"id":"q10","prompt":"Which pair are logical properties?","options":["`margin-left` and `margin-right`","`margin-inline-start` and `padding-block-end`","`top` and `left`","`width` and `height`"],"answerIndex":1,"explanation":"Logical properties map to the writing mode and direction rather than physical sides. `margin-inline-start` is the start edge of the inline axis, which may be left or right depending on direction. `padding-block-end` is the end of the block axis. They make layouts work across languages more naturally."}]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_3_1', 'sec_html_css_advanced_3', 'crs_html_css_advanced', 'Motion: transitions, transforms and keyframes', 'interactive', 0, 1440, NULL, NULL, 'Motion is feedback. A button that lifts under the pointer says "I am clickable"; a panel that fades in says "this content just arrived"; a skeleton that shimmers says "the data is coming". The same motion, overdone or applied to everything, says "the designer discovered animation". The difference is not taste. It is whether the movement carries information the interface would otherwise have to state in words.

This lesson covers the two engines behind interface motion: **transitions**, which interpolate between two states, and **animations**, which play a sequence of keyframes. You will learn the properties that control them, the timing functions that give them character, the transforms that keep them cheap, and the accessibility rules that keep them from making people ill.

## Transitions describe a change

A transition is a bridge between two states. You declare which properties can animate, how long the trip takes, how it accelerates and whether it waits. Something else changes the state — a hover, a focus, a class added by JavaScript — and the browser fills in the frames between the old value and the new one.

```html run
<a class="cta" href="#">Read the field notes <span aria-hidden="true">→</span></a>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .cta {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 14px 20px;
    border-radius: 10px;
    background: #0f172a;
    color: white;
    font-weight: 600;
    text-decoration: none;
    transition: transform 180ms ease, background-color 180ms ease;
  }
  .cta:hover { background: #0f766e; transform: translateY(-2px); }
  .cta:focus-visible { outline: 3px solid #f59e0b; outline-offset: 3px; }
</style>
```

Hover the button, then tab to it. The colour and the lift are not separate animations; they are two properties transitioning from their default values to the values in `:hover`. The `transition` shorthand takes a property, a duration and a timing function. Add a fourth value for a delay.

Transitions are deliberately limited. They need a before and an after, and they only animate properties that the browser can interpolate. `transform`, `opacity`, `color`, `background-color`, `filter` and most length values interpolate smoothly. `display` does not, historically: switching from `display: none` to `display: block` removes the element from the transition before it can start. Modern CSS can opt into discrete transitions with `transition-behavior: allow-discrete` and `@starting-style`, but those are advanced tools for entry animations, not a reason to animate `display` everywhere.

> **Tip:** Put the transition on the base state, not only on `:hover`. If the transition lives only in the hover rule, the element animates in but snaps back out when the pointer leaves.

## Keyframes tell a longer story

A transition can only move between two values. An animation can define as many stops as it needs, run on its own, repeat, alternate and hold its final state. The sequence lives in `@keyframes`, and an element opts in with the `animation` shorthand.

```html run
<p class="status"><span class="dot" aria-hidden="true"></span> All systems normal</p>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .status { display: flex; align-items: center; gap: 10px; color: #0f172a; font-weight: 600; }
  .dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: #0f766e;
    animation: pulse 1.8s ease-in-out infinite;
  }
  @keyframes pulse {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.6); opacity: 0.45; }
  }
</style>
```

The `animation` shorthand packs several longhands into one line. The order is flexible, but the first time value is the duration and the second is the delay. The longhands are worth knowing because debugging is easier when you can name the part that is wrong:

| Longhand | What it controls |
|---|---|
| `animation-name` | The `@keyframes` block to run. |
| `animation-duration` | How long one cycle takes. |
| `animation-timing-function` | How progress is distributed across the cycle. |
| `animation-delay` | How long to wait before the first cycle. |
| `animation-iteration-count` | How many cycles; `infinite` never stops. |
| `animation-direction` | `normal`, `reverse`, `alternate`, `alternate-reverse`. |
| `animation-fill-mode` | Which values apply before and after the animation. |
| `animation-play-state` | `running` or `paused`. |

The pulse is a loop: `infinite` repeats the cycle forever. A one-shot entrance animation would use `1` instead. `alternate` makes every other cycle run backwards, which is often what you want for a breathing or loading indicator.

> **Under the hood:** The browser samples the keyframes and interpolates between them, then hands the result to the compositor when the animated properties allow it. That is why `transform` and `opacity` are cheap: the compositor can animate them without recalculating layout or repainting the page.

## Timing functions give motion character

The timing function decides how the animated value is distributed over time. `linear` moves at a constant speed. `ease` starts slowly, speeds up and slows down. `ease-in` starts slowly; `ease-out` ends slowly. A `cubic-bezier()` lets you draw the curve yourself with two control points.

```html run
<div class="track"><div class="bar linear">linear</div></div>
<div class="track"><div class="bar ease">ease</div></div>
<div class="track"><div class="bar snap">steps(6)</div></div>
<div class="track"><div class="bar spring">cubic-bezier</div></div>

<style>
  body { margin: 0; padding: 28px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .track { width: 420px; max-width: 100%; margin-bottom: 12px; padding: 6px; border-radius: 10px; background: #e2e8f0; }
  .bar {
    width: 120px;
    padding: 10px 0;
    border-radius: 7px;
    background: #0f766e;
    color: white;
    font-size: 12px;
    font-weight: 700;
    text-align: center;
    animation: slide 1.8s infinite alternate;
  }
  .linear { animation-timing-function: linear; }
  .ease { animation-timing-function: ease; }
  .snap { animation-timing-function: steps(6, end); background: #b45309; }
  .spring { animation-timing-function: cubic-bezier(0.2, 1.6, 0.4, 1); background: #0f172a; }
  @keyframes slide {
    from { transform: translateX(0); }
    to { transform: translateX(260px); }
  }
</style>
```

The four bars travel the same distance in the same time, but they do not feel the same. `linear` is mechanical; `ease` is the browser''s default compromise; `steps(6, end)` jumps in six discrete positions, like a mechanical counter; the cubic-bezier overshoots because its second control point has a y value above 1, then settles back.

For interface motion, two curves cover most needs: a gentle ease-out for elements entering, and a faster ease-in for elements leaving. Entering content should decelerate into place; leaving content should accelerate away. A modal that eases in over 240ms and out over 160ms feels responsive because the exit does not make the user wait.

> **Pitfall:** `steps()` is not a synonym for "choppy". It is the correct tool for a ticking counter, a typewriter reveal or a sprite-sheet animation. Using it on a menu makes the menu look broken.

## Challenge: a loading skeleton with a shimmer

A skeleton screen communicates shape before content arrives. The grey blocks reserve the layout; the shimmer says the page is working rather than frozen. Build a shimmer with a gradient background, a background size larger than the element, and an animation that moves the gradient across it.

The markup is a single `.skeleton` block. The starter has a flat grey background and no animation. Give it a linear gradient with a lighter highlight, set `background-size` to `200% 100%`, and animate `background-position` from the right side to the left on a loop.

```html exercise id=motion-skeleton-shimmer title="Build a loading skeleton shimmer"
<div class="card" aria-busy="true">
  <div class="skeleton"></div>
  <div class="line short"></div>
  <div class="line"></div>
</div>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { width: 360px; padding: 18px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .skeleton {
    height: 180px;
    margin-bottom: 14px;
    border-radius: 10px;
    background: #e2e8f0;
  }
  .line { height: 12px; margin-top: 10px; border-radius: 999px; background: #e2e8f0; }
  .line.short { width: 55%; }
</style>
--- solution
<div class="card" aria-busy="true">
  <div class="skeleton"></div>
  <div class="line short"></div>
  <div class="line"></div>
</div>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .card { width: 360px; padding: 18px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .skeleton {
    height: 180px;
    margin-bottom: 14px;
    border-radius: 10px;
    background: linear-gradient(100deg, #e2e8f0 20%, #f8fafc 40%, #e2e8f0 60%);
    background-size: 200% 100%;
    animation: shimmer 1.4s linear infinite;
  }
  .line { height: 12px; margin-top: 10px; border-radius: 999px; background: #e2e8f0; }
  .line.short { width: 55%; }
  @keyframes shimmer {
    from { background-position: 150% 0; }
    to { background-position: -50% 0; }
  }
</style>
--- test
const skeleton = query(".skeleton");
const style = getComputedStyle(skeleton);
assert(style.animationName !== "none", "The skeleton has no animation. It needs a keyframes animation that moves the highlight.");
assert(style.animationIterationCount === "infinite", `The animation runs ${style.animationIterationCount} time(s). A loading shimmer should loop until the content arrives.`);
assert(style.backgroundImage.includes("linear-gradient"), "The skeleton background is still a flat colour. Use a linear-gradient so there is a highlight to move.");
assert(style.backgroundSize.includes("200%"), `The background-size computes to ${style.backgroundSize}. Make it wider than the element so the gradient can travel.`);
const duration = parseFloat(style.animationDuration);
assert(duration >= 0.8 && duration <= 3, `The animation duration is ${duration}s. A shimmer usually lands between 0.8s and 3s.`);
--- hint
The moving part is not the element; it is the gradient''s position inside the element. Start with a wide gradient and animate `background-position`.
--- hint
Use `background: linear-gradient(100deg, #e2e8f0 20%, #f8fafc 40%, #e2e8f0 60%); background-size: 200% 100%;` and animate `background-position` from `150% 0` to `-50% 0`.
```

The `aria-busy="true"` on the card is not decoration. It tells assistive technology that the region is updating, so a screen-reader user is not told that an empty card is the final content. The visual shimmer is for sighted users; the state is for everyone.

> **Under the hood:** `background-position` is a paint property, so a large shimmer repaints its area every frame. For a full-page skeleton, animate a pseudo-element''s `transform` over a static gradient instead, and keep the moving layer small.

## Transforms move without moving the layout

A transform changes how an element is painted, not where it sits in the layout. Its siblings keep their positions, the document does not reflow, and the compositor can often handle the change on its own. That makes `transform` and `opacity` the two properties to reach for when motion needs to be smooth.

```html run
<div class="scene">
  <article class="tilt">
    <span class="chip">3D</span>
    <h2>Ridge line</h2>
    <p>A steady climb with a view that arrives all at once.</p>
  </article>
</div>

<style>
  body { margin: 0; padding: 48px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .scene { perspective: 900px; max-width: 360px; }
  .tilt {
    position: relative;
    padding: 24px;
    border-radius: 16px;
    background: white;
    border: 1px solid #e2e8f0;
    box-shadow: 0 18px 40px rgb(15 23 42 / 0.12);
    transform-style: preserve-3d;
    transition: transform 320ms cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .tilt:hover { transform: rotateX(6deg) rotateY(-10deg) translateY(-4px); }
  .chip {
    position: absolute;
    top: 14px;
    right: 14px;
    padding: 4px 8px;
    border-radius: 999px;
    background: #0f766e;
    color: white;
    font-size: 11px;
    font-weight: 700;
  }
  .tilt h2 { margin: 0 0 8px; color: #0f172a; }
  .tilt p { margin: 0; color: #475569; line-height: 1.5; }
</style>
```

Hover the card. `perspective` on the parent gives the rotation depth; without it, `rotateY` is a flat horizontal squash. `transform-style: preserve-3d` keeps child elements in the same 3D space, which matters when you add layers. The transform order is `rotateX`, then `rotateY`, then `translateY`; matrix multiplication is not commutative, so swapping two functions produces a different result.

`transform-origin` sets the pivot. The default is the centre of the element (`50% 50%`). A menu that should unfold from its trigger uses `transform-origin: top left`; a card that should swing from its left edge uses `transform-origin: left center`. The origin is part of the animation''s meaning, not a detail you add at the end.

> **Under the hood:** A transform creates a stacking context and a containing block for fixed and absolutely positioned descendants. That is why a transformed ancestor can capture a `position: fixed` child. Motion and stacking are the same system seen from different angles.

## Stagger with `animation-delay`

A list of cards that all animate at once looks like a single block. A short stagger makes the eye follow the sequence and gives the interface a sense of arrival. You do not need JavaScript: put an index in a custom property and multiply it in `animation-delay`.

```html run
<ul class="feed">
  <li style="--i: 0"><strong>08:02</strong> Deploy started</li>
  <li style="--i: 1"><strong>08:03</strong> Assets uploaded</li>
  <li style="--i: 2"><strong>08:04</strong> Cache warmed</li>
  <li style="--i: 3"><strong>08:05</strong> Health checks passed</li>
</ul>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .feed { max-width: 420px; margin: 0; padding: 0; list-style: none; }
  .feed li {
    margin-bottom: 10px;
    padding: 14px 16px;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    background: white;
    color: #334155;
    animation: rise 520ms cubic-bezier(0.2, 0.8, 0.2, 1) both;
    animation-delay: calc(var(--i) * 80ms);
  }
  .feed strong { color: #0f172a; margin-right: 8px; font-variant-numeric: tabular-nums; }
  @keyframes rise {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
</style>
```

The `--i` values are 0, 1, 2 and 3, so the delays are 0, 80, 160 and 240 milliseconds. The total sequence is under 800 milliseconds including the animation duration, which is short enough to feel like a single gesture rather than a wait. If the list has twenty items, cap the delay: `animation-delay: calc(min(var(--i), 6) * 70ms)` keeps the last item from arriving a second and a half late.

`animation-fill-mode: both` is doing two jobs here. **Backwards** applies the first keyframe during the delay, so items three and four are invisible instead of flashing at full opacity and then fading in. **Forwards** keeps the final keyframe after the animation ends, so the item does not snap back to its pre-animation state. `forwards` alone would still flash during the delay; `both` covers both ends.

## Challenge: a staggered card entrance

Build a three-card entrance. Each card should rise and fade in, and the cards should arrive one after another rather than all at once. The markup already gives each card an index in `--i`; the starter has no animation at all.

Keep the entrance under a second in total and make sure the cards remain visible after the animation finishes. The test inspects the computed animation properties, so a transition triggered by a class will not be enough.

```html exercise id=motion-staggered-entrance title="Make the cards arrive in sequence"
<section class="grid">
  <article class="card" style="--i: 0">
    <h2>Starter</h2>
    <p>One location, two staff and a very short menu.</p>
  </article>
  <article class="card" style="--i: 1">
    <h2>Studio</h2>
    <p>Wholesale ordering and a second location.</p>
  </article>
  <article class="card" style="--i: 2">
    <h2>Roastery</h2>
    <p>Production planning and batch tracking.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; max-width: 860px; }
  .card { padding: 20px; border: 1px solid #e2e8f0; border-radius: 14px; background: white; }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  /* TODO: add a keyframes entrance and stagger it with --i */
</style>
--- solution
<section class="grid">
  <article class="card" style="--i: 0">
    <h2>Starter</h2>
    <p>One location, two staff and a very short menu.</p>
  </article>
  <article class="card" style="--i: 1">
    <h2>Studio</h2>
    <p>Wholesale ordering and a second location.</p>
  </article>
  <article class="card" style="--i: 2">
    <h2>Roastery</h2>
    <p>Production planning and batch tracking.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 32px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; max-width: 860px; }
  .card {
    padding: 20px;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    background: white;
    animation: rise 520ms cubic-bezier(0.2, 0.8, 0.2, 1) both;
    animation-delay: calc(var(--i) * 90ms);
  }
  .card h2 { margin: 0 0 8px; color: #0f172a; }
  .card p { margin: 0; color: #475569; line-height: 1.5; }
  @keyframes rise {
    from { opacity: 0; transform: translateY(14px); }
    to { opacity: 1; transform: translateY(0); }
  }
</style>
--- test
const cards = Array.from(document.querySelectorAll(".card"));
assert(cards.length === 3, "Keep all three cards");
const styles = cards.map((card) => getComputedStyle(card));
assert(styles.every((style) => style.animationName !== "none"), "The cards have no keyframes animation. Each card needs an entrance.");
const fills = styles.map((style) => style.animationFillMode);
assert(fills.every((fill) => fill === "both" || fill === "forwards"), `The fill modes compute to ${fills.join(", ")}. The cards should stay at their final state after the entrance.`);
const delays = styles.map((style) => parseFloat(style.animationDelay));
assert(delays[1] > delays[0] && delays[2] > delays[1], `The delays are ${delays.join(", ")}s. Each card should start slightly after the one before.`);
assert(parseFloat(styles[0].animationDuration) >= 0.2, "The entrance is too fast to read. Give it a duration above 0.2s.");
assertColor(".card", "background-color", "#ffffff");
--- hint
Define a `@keyframes` block that moves from `opacity: 0` and a small `translateY` to `opacity: 1` and no offset.
--- hint
Use `animation: rise 520ms ... both;` on `.card`, then stagger it with `animation-delay: calc(var(--i) * 90ms)`.
```

The `--i` custom property is the whole stagger. The CSS does not know how many cards exist, and the markup does not know the animation timing. Adding a fourth card only requires `--i: 3`; the sequence extends itself.

## When the animation ends: `animation-fill-mode`

Fill mode answers a question that surprises almost everyone the first time: **what happens after the last keyframe?** By default, the answer is "the element returns to the styles it had before the animation". That is fine when the base styles already match the final keyframe, and wrong when they do not.

- `none` (default): the animation''s values apply only while it is running.
- `forwards`: the last keyframe''s values persist after the animation finishes.
- `backwards`: the first keyframe''s values apply during the delay before the animation starts.
- `both`: backwards during the delay, forwards after the end.

The most common bug is a toast or dialog that fades and slides into place, then vanishes at the end because the base state is `opacity: 0` and no fill mode was set. The animation did its job; the cascade then put the element back where it started.

## Debug: the toast that disappears

This toast is supposed to slide in and stay visible. It appears for 600 milliseconds and then vanishes. The keyframes are correct, the duration is correct, and the timing function is fine. The missing piece is the rule that keeps the final keyframe applied after the animation ends.

Add the fill mode so the toast remains visible. The base state is intentionally transparent, because the entrance should start from nothing; do not "fix" the bug by making the base state opaque.

```html debug id=motion-toast-fill-mode title="The toast vanishes after it arrives"
<div class="toast" role="status">
  <strong>Draft saved</strong>
  <span>Your changes are safe.</span>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toast {
    display: flex;
    flex-direction: column;
    gap: 2px;
    max-width: 320px;
    padding: 14px 18px;
    border-radius: 12px;
    background: #0f172a;
    color: white;
    opacity: 0;
    transform: translateY(10px);
    animation: toast-in 600ms cubic-bezier(0.2, 0.8, 0.2, 1);
  }
  .toast strong { font-size: 14px; }
  .toast span { color: #cbd5e1; font-size: 13px; }
  @keyframes toast-in {
    to { opacity: 1; transform: translateY(0); }
  }
</style>
--- solution
<div class="toast" role="status">
  <strong>Draft saved</strong>
  <span>Your changes are safe.</span>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .toast {
    display: flex;
    flex-direction: column;
    gap: 2px;
    max-width: 320px;
    padding: 14px 18px;
    border-radius: 12px;
    background: #0f172a;
    color: white;
    opacity: 0;
    transform: translateY(10px);
    animation: toast-in 600ms cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
  }
  .toast strong { font-size: 14px; }
  .toast span { color: #cbd5e1; font-size: 13px; }
  @keyframes toast-in {
    to { opacity: 1; transform: translateY(0); }
  }
</style>
--- test
const style = getComputedStyle(query(".toast"));
assert(style.animationName !== "none", "The toast should keep its keyframes animation.");
const fill = style.animationFillMode;
assert(fill === "forwards" || fill === "both", `The toast''s animation-fill-mode computes to ${fill}. After the last keyframe it falls back to opacity: 0.`);
assert(parseFloat(style.animationDuration) > 0.2, "The toast should still animate in; do not shorten the duration to zero.");
assertColor(".toast", "background-color", "#0f172a");
--- hint
Run the cell and watch the toast. It arrives, then disappears when the animation ends. Which longhand decides what happens after the final keyframe?
--- hint
Add `forwards` to the `animation` shorthand, or set `animation-fill-mode: forwards`.
```

The test checks the computed fill mode because it is the property that prevents the bug. In a real review you would also watch the animation, because a computed value can be right while the visual result is wrong for another reason. The two checks answer different questions.

```html predict id=motion-forwards-final-state title="Where does the chip end up?"
<div class="track">
  <div class="chip">Saved</div>
</div>

<style>
  body { margin: 0; padding: 24px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .track { position: relative; height: 90px; border: 1px dashed #cbd5e1; border-radius: 12px; }
  .chip {
    position: absolute;
    top: 26px;
    left: 16px;
    padding: 8px 14px;
    border-radius: 999px;
    background: #b91c1c;
    color: white;
    font-weight: 700;
    animation: slide 800ms ease-out forwards;
  }
  @keyframes slide {
    to { transform: translateX(160px); background: #0f766e; }
  }
</style>
--- options
* It stays 160px to the right and turns teal
It returns to the left edge and turns red
It stays 160px to the right but turns red
It disappears when the animation ends
--- explain
`forwards` keeps the values from the final keyframe after the animation finishes. The chip remains translated 160px and keeps the teal background declared in `to`. Without `forwards`, it would snap back to its base position and red background. With `backwards`, the first keyframe would apply during the delay, but the final state would still depend on the fill mode.

## Reduced motion is not optional

For some people, large movement triggers nausea, dizziness or migraine. The operating system exposes that preference as `prefers-reduced-motion: reduce`, and the browser passes it to CSS. Respecting it is part of shipping motion, not a separate accessibility project.

```html run
<div class="banner">
  <span class="dot" aria-hidden="true"></span>
  <p>Syncing your notes…</p>
</div>

<style>
  body { margin: 0; padding: 40px; font-family: system-ui, sans-serif; background: #f8fafc; }
  .banner {
    display: flex;
    align-items: center;
    gap: 12px;
    max-width: 360px;
    padding: 16px 18px;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    background: white;
    transition: background-color 200ms ease;
  }
  .banner p { margin: 0; color: #334155; }
  .dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: #0f766e;
    animation: pulse 1.6s ease-in-out infinite;
  }
  @keyframes pulse {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.7); opacity: 0.4; }
  }
  @media (prefers-reduced-motion: reduce) {
    .banner { transition: none; }
    .dot { animation: none; opacity: 1; transform: none; }
  }
</style>
```

The reduced-motion block does not remove the information; it removes the movement. The dot is still there, still teal, still next to the status text. That is the correct pattern. Do not hide an element or leave it at `opacity: 0` because an entrance animation was disabled. The reduced-motion state must be a complete, usable final state.

Not all motion needs to disappear. A short opacity fade is usually harmless; a full-screen parallax, a bouncing loader or a card that flies in from off-screen is not. A common compromise is to keep colour and opacity changes, remove transforms and looping animations, and shorten durations to near zero. The decision belongs to the component, not to a global `* { animation: none !important; }` rule that can break state.

> **Tip:** Test with the preference enabled, not just by reading the media query. In Chrome DevTools, open **Rendering** and set **Emulate CSS media feature prefers-reduced-motion** to `reduce`. Then use the interface: does anything still move, flash or loop?

## A note on view transitions

The View Transitions API lets the browser animate between two DOM states, or between two pages, without you writing the intermediate frames. For same-document transitions, JavaScript calls `document.startViewTransition(() => updateTheDom())`; elements with a `view-transition-name` are captured before and after, and the browser cross-fades or morphs between them. For cross-document navigation, both documents opt in with:

```css
@view-transition { navigation: auto; }
```

The browser then animates the old page out and the new page in, and you can style the generated pseudo-elements (`::view-transition-old(root)`, `::view-transition-new(root)`) with ordinary CSS. Support is good in current Chrome and Safari and improving in Firefox, but the correct posture is progressive enhancement: the navigation must work perfectly when the API is absent.

View transitions are not a substitute for a clear state change. They are a polish layer on top of navigation that already makes sense. They also respect the same accessibility rules: wrap the transition styles in a reduced-motion query and keep the duration short.

> **In the wild:** The most convincing view transitions are small and structural: a thumbnail expands into a detail image, a card title moves into the page heading, a filter chip becomes the active filter. The least convincing ones animate the entire page for every click.

## Recap

- Transitions interpolate between two states and need a trigger. Put the transition on the base state so the return trip animates too.
- Animations play `@keyframes` on their own. The shorthand controls name, duration, timing, delay, iteration, direction and fill.
- `cubic-bezier()` shapes acceleration; `steps()` is for discrete changes such as counters and sprite frames.
- `transform` and `opacity` are the compositor-friendly properties. Transform order and `transform-origin` change the meaning of the motion.
- Stagger with a custom property and `animation-delay: calc(var(--i) * 90ms)`, and cap the delay for long lists.
- `animation-fill-mode: forwards` keeps the final keyframe; `both` also applies the first keyframe during the delay. Missing fill mode is why entrances snap back.
- Reduced motion removes movement, not information. View transitions are progressive enhancement, not a requirement for navigation.

**Up next:** making motion accessible in depth — focus visibility, perceived speed, loading states and the interaction details that decide whether an interface feels fast or merely animated.



', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_3_2', 'sec_html_css_advanced_3', 'crs_html_css_advanced', 'Motion for everyone: focus, reduced motion and perceived speed', 'interactive', 1, 1200, NULL, NULL, 'A notification slides in from the bottom of the screen, overshoots, settles, and pulses once for attention. It looks expensive. For most people it is a pleasant half-second. For someone with a vestibular disorder, the same movement can feel like the floor tilting, and the feeling can last long after the animation ends. Motion is not a neutral layer of polish; it is sensory input, and some of your users cannot opt out of the page.

The good news is that accessible motion is not motion with the life removed. It is motion with a fallback: the same information, delivered without the travel. This lesson covers the preference that asks for that fallback, the focus system that keyboard users depend on, and the loading states that make a page feel fast without making anyone ill.

## Motion is an input

The vestibular system is the part of the inner ear that tells you which way is down. Large movement on a two-dimensional screen — parallax, zoom, spin, a full-screen slide — can conflict with that signal. The result is dizziness, nausea, headache and unsteadiness. The effect is not proportional to how tasteful the easing curve is, and it is not limited to people with a diagnosis. Concussion recovery, migraine, pregnancy and some medications all change the threshold.

WCAG treats this seriously. Success criterion 2.3.3, *Animation from Interactions*, asks that motion triggered by interaction can be disabled unless it is essential. Criterion 2.2.2 asks for a way to pause, stop or hide moving content that starts automatically and lasts more than five seconds. The platform gives you the signal to do both: `prefers-reduced-motion`.

```css
@media (prefers-reduced-motion: reduce) {
  .card { animation: none; }
}
```

That query reflects an operating-system setting. On macOS it is System Settings → Accessibility → Display → Reduce motion; on Windows, Settings → Accessibility → Visual effects → Animation effects; on iOS and Android it lives in accessibility settings. The user has already told the system once. Your page should listen rather than ask again with its own toggle.

> **Under the hood:** `prefers-reduced-motion` has two meaningful values: `no-preference` and `reduce`. The first is the default, but treat it as “no explicit preference”, not as “this person loves parallax”. The setting can be on for reasons that have nothing to do with vestibular health — battery saving, motion sensitivity from a migraine, or a shared device.

## What to remove, what to keep

“Reduced motion” is a slightly misleading name. The useful question is not *should there be animation?* but *which part of this animation carries the meaning?* Almost always the meaning is the state change, not the journey to the new state.

| Effect | Under `reduce` | Why |
|---|---|---|
| Slide, zoom, spin, parallax | Remove or make instant | Large screen movement is the trigger |
| Fade or color change | Keep, often shorter | Communicates change without travel |
| Progress spinner | Keep, but calm it | Still communicates “working” |
| Hover lift | Remove the lift, keep the shadow | Feedback survives without movement |
| Skeleton shimmer | Replace with a static block | The shimmer is decoration |

Here is an entrance that keeps its personality for everyone else and becomes an instant appearance for anyone who asked for less. Run it, then read the media block at the bottom. Nothing in that block hides the notice or changes its final position; it only cancels the journey.

```html run
<article class="notice">
  <p class="eyebrow">New reply</p>
  <h2>Mara answered your trail question</h2>
  <p>“The north ridge is passable, but take the lower path after rain.”</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .notice {
    max-width: 32rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #0f172a; color: #cbd5e1;
    box-shadow: 0 24px 48px -24px rgb(15 23 42 / 0.55);
    animation: notice-in 520ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .35rem; color: #5eead4; font-size: .75rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .6rem; color: #f8fafc; font-size: 1.4rem; letter-spacing: -.02em; }
  p { margin: 0; line-height: 1.6; }
  @keyframes notice-in {
    from { opacity: 0; transform: translateY(56px) scale(.98); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
  @media (prefers-reduced-motion: reduce) {
    .notice { animation: none; }
  }
</style>
```

The final state is expressed by the element''s own styles, not by the last keyframe. That is the important structural detail. If the notice were invisible by default and only the animation made it visible, `animation: none` would leave a blank space. With `animation-fill-mode: both` the animation controls opacity while it runs, but when it is removed the base `opacity: 1` applies. Design the resting state first, then animate *from* somewhere else.

Duration is part of the contract. Feedback such as a button press should land in 100–150 ms. A state transition feels responsive at 200–300 ms. An entrance can take 300–500 ms. Functional motion that lasts longer than a second starts to feel like waiting, and anything that loops for more than five seconds needs a pause control. Slow movement is not automatically gentler: a long, drifting parallax can be more disorienting than a quick, small transition.

Hover effects deserve the same treatment. The lift below is a small translation, but it is repeated every time a pointer crosses the card, and it is easy to remove without losing the affordance:

```html run
<a class="route-card" href="#guide">
  <span>
    <strong>North ridge in autumn</strong>
    <small>9.4 km · moderate · 3 hours</small>
  </span>
  <span class="arrow" aria-hidden="true">→</span>
</a>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .route-card {
    display: flex; align-items: center; justify-content: space-between;
    max-width: 34rem; padding: 1.25rem 1.4rem; border: 1px solid #e2e8f0;
    border-radius: 14px; background: #fff; color: #0f172a; text-decoration: none;
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.06);
    transition: transform 220ms ease, box-shadow 220ms ease;
  }
  .route-card small { display: block; margin-top: .3rem; color: #475569; }
  .arrow { color: #0f766e; font-size: 1.4rem; }
  .route-card:hover { transform: translateY(-4px); box-shadow: 0 16px 30px -18px rgb(15 23 42 / 0.45); }
  @media (prefers-reduced-motion: reduce) {
    .route-card { transition: box-shadow 220ms ease; }
    .route-card:hover { transform: none; }
  }
</style>
```

The card still responds to hover through its shadow. A person using reduced motion gets the same “this is interactive” signal without the card appearing to lift off the page.

> **Pitfall:** The popular reset `* { animation-duration: .01ms !important; transition-duration: .01ms !important; }` does stop motion, but it also disables useful feedback, can fire `animationend` handlers almost immediately, and leaves `animation-delay` untouched. Prefer targeting the few selectors that actually travel. If you do use a global reset, pair it with `animation-delay: 0ms` and accept that you have traded nuance for coverage.

## Challenge: calm the panel

This panel currently rises 48 pixels and fades in. For visitors who prefer reduced motion, it should appear directly in its final position and at full opacity — no travel, no fade. Add the media query and the rule that neutralises the entrance.

```html exercise id=calm-the-panel title="Calm the entrance"
<article class="panel">
  <p class="eyebrow">Saved</p>
  <h2>Your route is in the notebook</h2>
  <p>You can add notes from the trail or from the car park.</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .panel {
    max-width: 30rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #fff; border: 1px solid #e2e8f0;
    box-shadow: 0 18px 40px -26px rgb(15 23 42 / .4);
    animation: panel-rise 600ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .3rem; color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .5rem; font-size: 1.35rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @keyframes panel-rise {
    from { opacity: 0; transform: translateY(48px); }
    to { opacity: 1; transform: translateY(0); }
  }
  /* TODO: add a prefers-reduced-motion block. */
</style>
--- solution
<article class="panel">
  <p class="eyebrow">Saved</p>
  <h2>Your route is in the notebook</h2>
  <p>You can add notes from the trail or from the car park.</p>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .panel {
    max-width: 30rem; margin: 0 auto; padding: 1.5rem;
    border-radius: 18px; background: #fff; border: 1px solid #e2e8f0;
    box-shadow: 0 18px 40px -26px rgb(15 23 42 / .4);
    animation: panel-rise 600ms cubic-bezier(.2, .8, .2, 1) both;
  }
  .eyebrow { margin: 0 0 .3rem; color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  h2 { margin: 0 0 .5rem; font-size: 1.35rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.55; }
  @keyframes panel-rise {
    from { opacity: 0; transform: translateY(48px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @media (prefers-reduced-motion: reduce) {
    .panel { animation: none; }
  }
</style>
--- test
assertExists(".panel", "Keep the panel in the page.");
const sheets = [];
for (const sheet of document.styleSheets) {
  try { sheets.push(...sheet.cssRules); } catch (error) {}
}
const reduce = sheets.find((rule) => rule.type === 4 && /prefers-reduced-motion/.test(rule.conditionText) && /reduce/.test(rule.conditionText));
assert(reduce, "Add an @media (prefers-reduced-motion: reduce) block that targets the panel.");
assert(reduce.cssRules.length > 0, "The reduced-motion block is empty. Put the panel rule inside it.");
reduce.media.mediaText = "all";
assertStyle(".panel", "transform", "none", "With reduced motion, the panel should sit in its final position instead of translating into place.");
assertStyle(".panel", "opacity", "1", "The panel should be fully opaque when the entrance animation is removed.");
--- hint
The query is `@media (prefers-reduced-motion: reduce)`. Put it after the keyframes so you can read the file top to bottom.
--- hint
Inside the block, target `.panel` and cancel the animation with `animation: none;`. The element''s base styles already describe the final state.
```

The tests look for the media block in the parsed stylesheet, then temporarily force it on. That is the same trade-off a real audit makes when it cannot change your operating system: it checks that the reduced branch exists and that it produces the right resting state. Notice what the test does *not* require: it does not demand a particular property. `animation: none` is the direct fix, but a short opacity-only replacement would also be a legitimate answer if it left the panel at full opacity with no translation.

## Focus is a location

Keyboard users do not experience your layout in the same order as a mouse user. They experience it as a sequence of stops. Browsers draw the focus ring; CSS can make it beautiful or delete it. Deleting it is the single most common accessibility regression in a design refresh.

`:focus-visible` exists to solve a real tension. A mouse click on a button should not leave a ring behind; a Tab press should. The browser applies a heuristic: if the last interaction was keyboard-like, focusable elements match `:focus-visible`; text inputs match even after a click, because you are about to type. Style `:focus-visible`, not `:focus`, when you want a keyboard-specific ring:

```css
.button:focus-visible {
  outline: 3px solid #0f766e;
  outline-offset: 3px;
}
```

Three pixels is a comfortable target. Two is the practical minimum. The ring must also have at least 3:1 contrast against the colours on both sides of it, which is why a dark ring over a dark button can disappear even though it is technically present. A two-tone ring solves that without guessing the background:

```css
.button:focus-visible {
  outline: 3px solid #0f766e;
  outline-offset: 2px;
  box-shadow: 0 0 0 5px #fff;
}
```

The outline sits away from the control; the white shadow sits behind it. One of the two will contrast with whatever surface the button lands on. If you use `box-shadow` alone, remember it is not drawn in forced-colours mode the way an outline is.

Focus *order* is determined by the DOM, not by what you see. `tabindex="1"` and above creates a second, parallel order that almost never matches the visual one and is nearly impossible to maintain. Avoid positive tabindex entirely. More subtly, CSS can reorder elements visually without changing the tab sequence: `flex-direction: row-reverse`, `order`, and grid placement all move pixels, not focus. If the visual order and the DOM order disagree, keyboard users will jump around the page. Fix the DOM, or accept the order you have.

A skip link is the cheapest focus improvement you can ship. It is the first focusable thing in the document, it is visually hidden until focused, and it jumps to the main content so a keyboard user does not have to Tab through the entire navigation on every visit.

```html run
<a class="skip" href="#main">Skip to content</a>
<header class="site-header">
  <a class="brand" href="#">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main" tabindex="-1">
  <h1>Trail notes</h1>
  <p>Use Tab to reach the skip link, then press Enter. The ring is the browser telling you where you are.</p>
  <a class="cta" href="#subscribe">Get the weekly note</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .skip {
    position: absolute; left: 1rem; top: -4rem; z-index: 10;
    padding: .65rem 1rem; border-radius: 8px; background: #0f172a; color: #fff;
    font-weight: 600; text-decoration: none; transition: top 150ms ease;
  }
  .skip:focus { top: 1rem; }
  .site-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0; }
  nav { display: flex; gap: 1rem; }
  a { color: #0f172a; }
  .brand { font-weight: 800; text-decoration: none; letter-spacing: -.02em; }
  main { max-width: 38rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .75rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
  .cta { display: inline-block; margin-top: .5rem; padding: .7rem 1rem; border-radius: 10px; background: #0f766e; color: #fff; font-weight: 600; text-decoration: none; }
  a:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; border-radius: 4px; }
  @media (prefers-reduced-motion: reduce) {
    .skip { transition: none; }
  }
</style>
```

`tabindex="-1"` on `<main>` is deliberate. It makes the element programmatically focusable without adding it to the Tab order, so following the skip link moves focus into the content instead of merely scrolling the viewport. The skip link itself uses `:focus` rather than `:focus-visible`, because it must also appear if someone clicks it and then tabs backward.

## Challenge: a ring you can see

The call to action below has no custom focus style. Build one that is visible against the page and against the button, stays clear of the text, and does not depend on colour alone. The tests focus the link and inspect the computed ring.

```html exercise id=focus-ring-visible title="A ring you can see"
<main class="panel">
  <h1>Walk the coast path</h1>
  <p>Six days, five villages, one very good bakery.</p>
  <a class="cta" href="#book">Book a place</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .panel { max-width: 30rem; margin: 3rem auto; padding: 2rem; border-radius: 18px; background: #fff; }
  h1 { margin: 0 0 .5rem; font-size: 1.8rem; color: #0f172a; }
  p { margin: 0 0 1.25rem; color: #475569; line-height: 1.6; }
  .cta { display: inline-block; padding: .8rem 1.1rem; border-radius: 10px; background: #0f172a; color: #fff; font-weight: 600; text-decoration: none; }
  /* TODO: add a keyboard focus ring with thickness and breathing room. */
</style>
--- solution
<main class="panel">
  <h1>Walk the coast path</h1>
  <p>Six days, five villages, one very good bakery.</p>
  <a class="cta" href="#book">Book a place</a>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f1f5f9; }
  .panel { max-width: 30rem; margin: 3rem auto; padding: 2rem; border-radius: 18px; background: #fff; }
  h1 { margin: 0 0 .5rem; font-size: 1.8rem; color: #0f172a; }
  p { margin: 0 0 1.25rem; color: #475569; line-height: 1.6; }
  .cta { display: inline-block; padding: .8rem 1.1rem; border-radius: 10px; background: #0f172a; color: #fff; font-weight: 600; text-decoration: none; }
  .cta:focus-visible {
    outline: 3px solid #b45309;
    outline-offset: 3px;
    box-shadow: 0 0 0 6px #fff;
  }
</style>
--- test
const cta = query(".cta");
cta.focus();
assert(document.activeElement === cta, "The call to action should be reachable and focusable.");
const style = getComputedStyle(cta);
const width = parseFloat(style.outlineWidth) || 0;
const hasOutline = style.outlineStyle !== "none" && width >= 3;
const hasShadow = style.boxShadow !== "none";
assert(hasOutline || hasShadow, "After focus, the link needs a visible ring at least 3px thick. A colour change alone is not enough.");
const offset = parseFloat(style.outlineOffset) || 0;
assert(offset >= 2 || hasShadow, "Move the focus ring at least 2px away from the text, or use a shadow ring that surrounds it.");
assert(style.outlineStyle !== "none" || hasShadow, "The focused link has no visible indicator.");
--- hint
Use `.cta:focus-visible` so the ring appears for keyboard users without lingering after a mouse click.
--- hint
A 3px `outline` with `outline-offset: 3px` covers both the thickness and the breathing room. A second white `box-shadow` ring keeps it visible on dark surfaces.
```

The test accepts an outline or a shadow ring because both are legitimate techniques. What it will not accept is a subtle colour shift: colour alone fails the “not by colour alone” rule, and it also fails anyone who cannot perceive that particular hue difference.

## Debug: the outline that vanished

A design system reset removed focus outlines globally to make screenshots look clean. The result is a page that is fully usable with a mouse and unusable with a keyboard. Find the rule and replace it with something that keeps the visual polish without deleting the indicator.

```html debug id=focus-lost title="The outline that vanished"
<header class="bar">
  <a class="brand" href="#main">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main">
  <h1>Where the path goes</h1>
  <p>Every link on this page is a stop in the keyboard sequence.</p>
</main>

<style>
  *:focus { outline: none; }
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .bar { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.5rem; background: #0f172a; }
  .brand { color: #fff; font-weight: 800; text-decoration: none; }
  nav { display: flex; gap: 1rem; }
  nav a { color: #cbd5e1; text-decoration: none; }
  main { max-width: 36rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .5rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
</style>
--- solution
<header class="bar">
  <a class="brand" href="#main">Fieldwork</a>
  <nav aria-label="Primary">
    <a href="#routes">Routes</a>
    <a href="#journal">Journal</a>
  </nav>
</header>
<main id="main">
  <h1>Where the path goes</h1>
  <p>Every link on this page is a stop in the keyboard sequence.</p>
</main>

<style>
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .bar { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.5rem; background: #0f172a; }
  .brand { color: #fff; font-weight: 800; text-decoration: none; }
  nav { display: flex; gap: 1rem; }
  nav a { color: #cbd5e1; text-decoration: none; }
  main { max-width: 36rem; padding: 3rem 1.5rem; }
  h1 { margin: 0 0 .5rem; font-size: 2rem; }
  p { color: #475569; line-height: 1.6; }
  a:focus-visible {
    outline: 3px solid #fbbf24;
    outline-offset: 3px;
    border-radius: 3px;
  }
</style>
--- test
const links = [...document.querySelectorAll("a")];
assert(links.length >= 3, "Keep the brand and both navigation links.");
for (const link of links) {
  link.focus();
  assert(document.activeElement === link, `The link labelled "${normalize(link.textContent)}" should be reachable with Tab.`);
  const style = getComputedStyle(link);
  const width = parseFloat(style.outlineWidth) || 0;
  const hasOutline = style.outlineStyle !== "none" && width >= 2;
  const hasShadow = style.boxShadow !== "none";
  assert(hasOutline || hasShadow, `The link labelled "${normalize(link.textContent)}" has no visible focus indicator. Restore a ring for keyboard users.`);
}
--- hint
The universal `*:focus` rule near the top of the stylesheet is the culprit. It matches every focused element, including links.
--- hint
Delete that rule. Then add `a:focus-visible` with a 3px outline and an offset. Do not simply set `outline: auto` on `:focus`; the original problem was the global reset, not the property.
```

> **In the wild:** Many CSS resets still contain `:focus { outline: none; }` or `:focus { outline: 0; }`. If you inherit a codebase, grep for `outline: none` before you audit anything else. The fix is usually two lines, and it restores the entire keyboard experience.

## Smooth scrolling is still motion

`scroll-behavior: smooth` looks like a small, tasteful default. On a long page it can turn a single anchor click into a two-second journey across thousands of pixels, which is exactly the kind of full-viewport movement that triggers vestibular symptoms. It also delays the destination, so a keyboard user who pressed Enter may think the link failed.

The fix is one media query. Keep smooth scrolling for people who have not asked for less, and switch to an instant jump for anyone who has:

```css
html { scroll-behavior: smooth; scroll-padding-top: 5rem; }

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
}
```

`scroll-padding-top` is not an accessibility requirement, but it is part of making anchor navigation feel finished: it leaves room for a sticky header so the heading does not land underneath it. `scroll-margin-top` does the same job on the target element. Use one consistently.

```html run
<nav class="toc" aria-label="On this page">
  <a href="#gear">Gear</a>
  <a href="#weather">Weather</a>
  <a href="#return">Getting back</a>
</nav>
<main>
  <section id="gear">
    <h2>Gear</h2>
    <p>Boots, a shell, and a head torch even in summer.</p>
  </section>
  <section id="weather">
    <h2>Weather</h2>
    <p>Conditions change fast above the tree line. Check the forecast twice.</p>
  </section>
  <section id="return">
    <h2>Getting back</h2>
    <p>The last bus leaves at 18:10. Do not treat that as a suggestion.</p>
  </section>
</main>

<style>
  html { scroll-behavior: smooth; scroll-padding-top: 5rem; }
  body { margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .toc { position: sticky; top: 0; display: flex; gap: 1rem; padding: 1rem 1.5rem; background: #0f172a; z-index: 2; }
  .toc a { color: #e2e8f0; text-decoration: none; font-weight: 600; font-size: .9rem; }
  main { max-width: 36rem; padding: 1rem 1.5rem 4rem; }
  section { min-height: 52vh; padding-top: 1rem; scroll-margin-top: 4rem; }
  h2 { margin: 0 0 .5rem; font-size: 1.6rem; }
  p { color: #475569; line-height: 1.65; }
  a:focus-visible { outline: 3px solid #fbbf24; outline-offset: 3px; }
  @media (prefers-reduced-motion: reduce) {
    html { scroll-behavior: auto; }
  }
</style>
```

> **Pitfall:** `scroll-behavior: smooth` applies to programmatic scrolling too, including `element.scrollIntoView()` and `window.scrollTo()`. A media query on `html` is the broadest fix, but component code that calls `scrollIntoView({ behavior: "smooth" })` still needs its own reduced-motion check. CSS cannot override an explicit behaviour passed in JavaScript.

## Perceived speed

Motion is also a performance tool. The numbers most product teams use come from response-time research: under about 100 ms feels instant, under a second keeps a flow intact, and around ten seconds is the limit of attention. Loading states live in the gap between those numbers.

A skeleton screen is a promise about the shape of what is coming. It works when its blocks match the final layout, so the content does not jump when it arrives. A shimmer makes the wait feel alive; under reduced motion, the shimmer should stop while the skeleton remains. The static blocks still say “content is loading” through their shape, and `aria-busy="true"` says it to assistive technology.

```html run
<article class="skeleton-card" aria-busy="true" aria-label="Loading trail conditions">
  <div class="skeleton line title"></div>
  <div class="skeleton line"></div>
  <div class="skeleton line short"></div>
  <div class="skeleton block"></div>
</article>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f1f5f9; font-family: system-ui, sans-serif; }
  .skeleton-card { max-width: 30rem; margin: 0 auto; padding: 1.5rem; border-radius: 16px; background: #fff; border: 1px solid #e2e8f0; }
  .skeleton {
    border-radius: 7px;
    background: linear-gradient(90deg, #e2e8f0 25%, #f8fafc 37%, #e2e8f0 63%);
    background-size: 400% 100%;
    animation: shimmer 1.4s ease infinite;
  }
  .line { height: 12px; margin-bottom: .8rem; }
  .line.title { width: 58%; height: 22px; margin-bottom: 1.2rem; }
  .line.short { width: 36%; }
  .block { height: 120px; margin-top: 1.4rem; }
  @keyframes shimmer {
    from { background-position: 100% 0; }
    to { background-position: 0 0; }
  }
  @media (prefers-reduced-motion: reduce) {
    .skeleton { animation: none; background: #e2e8f0; }
  }
</style>
```

Optimistic UI is the other half of perceived speed: show the result immediately, then reconcile with the server. A “Saved” label that appears the instant you press the button feels faster than a spinner that tells the truth. The pattern is only acceptable if failure is visible and recoverable. If the request fails, replace the optimistic state with an error and a retry — do not leave a checkmark on a change that never happened. The CSS can style both states; the state machine belongs in JavaScript.

> **Tip:** Put loading states on a slightly slower timer than you think you need. A spinner that flashes for 80 ms is worse than no spinner: it draws the eye, disappears before it is understood, and makes the wait feel longer. Show a skeleton immediately if you know the layout; show a spinner only after 300–500 ms of genuine waiting.

## Testing with reduced motion

You cannot verify this by reading the media query. You have to run the page in the condition.

1. Open DevTools → Rendering → *Emulate CSS media feature prefers-reduced-motion* and choose `reduce`.
2. Reload. Every entrance should be in its final position. Nothing should be invisible or half-faded.
3. Tab through the page with the mouse untouched. Every stop needs a visible ring, and the order should match the visual order.
4. Try the skip link as the very first Tab stop.
5. Click an in-page anchor. With reduced motion on, it should jump rather than glide.
6. Check loading states. The skeleton may stay; the shimmer must not.

Automated checks can catch the easy half. In a test, force the media rule on by setting `rule.media.mediaText = "all"` — as the challenge above does — or run a browser with the preference enabled. Then assert computed `transform`, `opacity` and `animation-name`. Assertions on CSS text alone are brittle: they cannot tell whether the rule actually wins the cascade.

Now predict what a reduced-motion visitor sees. Read the media block before you choose.

```html predict id=reduced-motion-banner title="What does the reduced-motion visitor see?"
<div class="banner">
  <strong>Weekend workshops are open.</strong>
  <a href="#book">Book a place</a>
</div>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .banner {
    max-width: 30rem; margin: 0 auto; padding: 1rem 1.25rem;
    display: flex; justify-content: space-between; gap: 1rem; align-items: center;
    border-radius: 12px; background: #0f766e; color: #fff;
    animation: drop-in 500ms ease-out both;
  }
  .banner a { color: #fff; font-weight: 700; }
  @keyframes drop-in {
    from { opacity: 0; transform: translateY(-64px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @media (prefers-reduced-motion: reduce) {
    .banner { animation: none; }
  }
</style>
--- options
* The banner is visible immediately in its final position, with no slide or fade
The banner slides down over half a second, then stays
The banner stays invisible because the animation never runs
The banner slides up from below the footer and stops in the middle
--- explain
`animation: none` cancels the keyframes entirely, so the element falls back to its own styles: default `opacity: 1` and no transform. The banner appears instantly where it belongs. This is why the resting state must be correct without the animation. If the base rule had been `opacity: 0`, cancelling the animation would leave an invisible banner — a far worse failure than the motion itself.
```

## Recap

- Motion is sensory input. Large travel, zoom, spin and parallax can trigger vestibular symptoms; `prefers-reduced-motion: reduce` is the user''s request to remove them.
- Remove the journey, keep the meaning. Fade, colour and immediate state changes usually survive; translation, scale and loops usually do not.
- Design the resting state first. `animation: none` should leave the element visible and correctly placed, not blank.
- `:focus-visible` gives keyboard users a ring without punishing mouse users. Never remove an outline without replacing it with something at least as visible.
- Focus order follows the DOM. Positive `tabindex` and CSS reordering break the sequence; skip links repair the most common case.
- `scroll-behavior: smooth` is motion too. Turn it off under `reduce`, and keep skeleton motion calm while preserving the loading signal.

**Up next:** forms that feel premium — accessible labels, native validation states and custom controls that keep their keyboard behaviour.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_3_3', 'sec_html_css_advanced_3', 'crs_html_css_advanced', 'Forms that feel premium: validation, states and custom controls', 'interactive', 2, 1320, NULL, NULL, 'A form is the most expensive surface in an interface. It is where someone types a card number, chooses a delivery slot, or asks for help at 2am. Every unnecessary field, every ambiguous label and every red border that appears before the visitor has done anything costs trust. Premium forms are not decorated forms. They are forms that answer three questions at every moment: what do you want from me, is what I typed acceptable, and what happens if it is not?

HTML gives you most of the machinery for free: labels, autofill, constraint validation and keyboard behaviour. CSS gives you the states. The work is in the timing and the semantics — knowing which state to show, when to show it, and what to do when the native control is not the shape you want.

## The anatomy of a field

Every field has four parts, whether or not you draw them:

1. A **label** that says what the field is for.
2. A **control** that accepts the value.
3. A **hint** with information needed before typing — format, privacy, where the value goes.
4. An **error** that explains what went wrong after validation.

The label must be a real `<label>` associated with the control, either by wrapping it or by `for="id"`. That association is not cosmetic. It gives the control its accessible name, makes the label text clickable, and lets voice-control users say “click Email address”. A placeholder is not a label. It disappears the moment someone types, it is usually rendered at low contrast, and some screen readers do not announce it reliably. Use a visible label, and use the placeholder only for a short example that is genuinely optional.

Hints and errors are connected with `aria-describedby`, which takes one or more ids. The accessible description is announced after the label, so it should read as a sentence that adds to the label rather than repeats it. `aria-invalid="true"` marks the field as failed for assistive technology; the visible message does the explaining.

```html run
<form class="account" novalidate>
  <div class="field">
    <label for="email">Email address</label>
    <input
      id="email"
      name="email"
      type="email"
      autocomplete="email"
      inputmode="email"
      value="sam@"
      aria-invalid="true"
      aria-describedby="email-hint email-error"
    >
    <p class="hint" id="email-hint">We use this for receipts and nothing else.</p>
    <p class="error" id="email-error">
      <span class="error-mark" aria-hidden="true">!</span>
      Enter a complete address, like sam@example.com.
    </p>
  </div>
  <button type="submit">Save changes</button>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .account { max-width: 28rem; margin: 0 auto; padding: 1.75rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .field { display: grid; gap: .4rem; }
  label { font-weight: 650; color: #0f172a; }
  input {
    width: 100%; box-sizing: border-box; padding: .7rem .8rem;
    border: 2px solid #b91c1c; border-radius: 9px; background: #fef2f2;
    font: inherit; color: #0f172a;
  }
  input:focus-visible { outline: 3px solid #b45309; outline-offset: 2px; }
  .hint { margin: 0; color: #475569; font-size: .85rem; line-height: 1.45; }
  .error { display: flex; gap: .45rem; margin: .1rem 0 0; color: #b91c1c; font-size: .85rem; font-weight: 600; line-height: 1.45; }
  .error-mark { display: grid; place-items: center; width: 1.1rem; height: 1.1rem; flex: none; margin-top: .1rem; border-radius: 50%; background: #b91c1c; color: #fff; font-size: .7rem; }
  button { margin-top: 1.4rem; padding: .75rem 1rem; border: 0; border-radius: 9px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; cursor: pointer; }
  button:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

This example is frozen in its error state so you can inspect the structure. In a real form the hint is always present and the error appears only after the visitor has had a chance to answer. Notice that the error has an icon and a sentence, not just a red border. The border is reinforcement; the text is the message.

> **Pitfall:** `placeholder="Email"` with no label is not a shortcut, it is a bug. The field becomes anonymous as soon as it has content, and the person returning to correct a typo has to remember what the box wanted. If the design genuinely needs a compact field, use a visually hidden `<label>` rather than deleting the label.

When you do use a placeholder as an example, style it deliberately. It is text, so it needs 4.5:1 against the field background:

```css
input::placeholder {
  color: #64748b; /* 4.76:1 on white */
  opacity: 1;    /* Firefox dims placeholders by default */
}
```

The `opacity: 1` matters. Firefox applies a default opacity to placeholder text, so a colour that passes in Chrome can fail there. Check the contrast against the field''s actual background, not the page behind it.

## Native states and the timing problem

Browsers expose constraint validation through pseudo-classes. Some are static facts about the markup; some depend on what the user has done.

| Selector | Matches when |
|---|---|
| `:required` | The control has the `required` attribute |
| `:optional` | It does not |
| `:valid` / `:invalid` | The current value satisfies or violates its constraints |
| `:user-valid` / `:user-invalid` | The user has interacted and the value is valid or invalid |
| `:placeholder-shown` | A text control is showing its placeholder, i.e. empty |
| `:disabled` / `:read-only` | The control cannot be edited |
| `:checked` / `:indeterminate` | Checkbox or radio state |

`:disabled` is not a styling convenience. It removes the control from the tab order, from constraint validation and from the submitted form data, so use it only when the action is genuinely unavailable in this state — not as a substitute for a permission check. `:read-only` keeps a value visible and focusable while preventing edits, which is usually the better choice for something the user needs to copy.

The important trap is that `:invalid` is true from the first paint. An empty `required` email field is invalid before the visitor has typed a character. If you write `input:invalid { border-color: red; }`, the form greets everyone with an error they have not made. That is not strict validation; it is an accusation.

`:user-invalid` waits. It matches after the user has interacted with the control and left it in an invalid state — on blur, or on an attempted submit in most browsers. That is usually the correct moment for inline feedback. Keep `:invalid` for the error summary after submission, when you genuinely want to show every outstanding problem.

```html run
<form class="compare">
  <div class="field eager">
    <label for="eager">Styled with :invalid</label>
    <input id="eager" type="email" required placeholder="you@example.com">
    <p>The red border is there before you type.</p>
  </div>
  <div class="field patient">
    <label for="patient">Styled with :user-invalid</label>
    <input id="patient" type="email" required placeholder="you@example.com">
    <p>The border waits until you leave the field.</p>
  </div>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .compare { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.25rem; max-width: 44rem; margin: 0 auto; }
  .field { padding: 1.25rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; }
  label { display: block; margin-bottom: .45rem; font-weight: 650; color: #0f172a; }
  input { width: 100%; box-sizing: border-box; padding: .65rem .75rem; border: 2px solid #cbd5e1; border-radius: 8px; font: inherit; }
  input:focus-visible { outline: 3px solid #b45309; outline-offset: 2px; }
  .field p { margin: .55rem 0 0; color: #475569; font-size: .8rem; line-height: 1.4; }
  .eager input:invalid { border-color: #b91c1c; background: #fef2f2; }
  .patient input:user-invalid { border-color: #b91c1c; background: #fef2f2; }
</style>
```

Type a partial address into each field and then click outside. The left field is red from the start; the right one stays neutral until you leave it empty or malformed. The lesson is not “never use `:invalid`”. It is that a selector which is true at time zero should not be your first line of feedback.

> **Under the hood:** Constraint validation runs continuously, even with `novalidate` on the form. `novalidate` only stops the browser from blocking submission and showing its own bubble; the pseudo-classes still reflect the constraints. That is why you can style `:invalid` and handle submission yourself.

## Predict: before and after interaction

The form below has just loaded in a browser where the visitor has not clicked or typed anything. Both rules paint the same colour, so the visual result is not the question. The question is which selector is actually matching.

```html predict id=validation-timing title="Which selector matches on first paint?"
<form>
  <label for="email">Email address</label>
  <input id="email" type="email" required>
</form>

<style>
  body { padding: 2rem; font-family: system-ui, sans-serif; }
  label { display: block; margin-bottom: .4rem; font-weight: 650; }
  input { padding: .65rem .75rem; border: 2px solid #cbd5e1; border-radius: 8px; font: inherit; }
  input:invalid { border-color: #b91c1c; }
  input:user-invalid { border-color: #b91c1c; }
</style>
--- options
* `:invalid` only
`:user-invalid` only
Both selectors
Neither selector
--- explain
The field is empty and required, so it is invalid immediately — `:invalid` matches from the first paint. `:user-invalid` requires interaction, and the visitor has not interacted yet, so it does not match. The border still looks red because the `:invalid` rule is doing the painting. This is exactly why the common `input:invalid { border-color: red }` snippet makes forms look broken on load.
```

## Errors that explain

A useful error has three jobs: say which field failed, say what is wrong, and say what would fix it. “Invalid input” does none of them. “Enter a date after today” does all three in six words.

Put the message next to the field and connect it with `aria-describedby`. Keep it in the DOM only while the error is active, or toggle `hidden`; a permanently present error that is merely coloured grey will still be announced as a description. Use `aria-invalid="true"` while the error is showing and remove it when the value becomes valid.

On long forms, add an error summary at the top after submission. It lists every problem as a link to the field, receives focus, and is announced once. `role="alert"` makes the insertion assertive; a summary is worth the interruption because the submit attempt produced no visible result otherwise. Inline messages can then be quieter.

```html
<div class="error-summary" role="alert" tabindex="-1">
  <h2>2 fields need attention</h2>
  <ul>
    <li><a href="#email">Email address: enter a complete address</a></li>
    <li><a href="#postcode">Postcode: use the format SW1A 1AA</a></li>
  </ul>
</div>
```

Do not attach `aria-live` to every field. As someone types, each keystroke can change validity, and a live region on six fields turns the form into a running commentary. Announce on blur or on submit, not on every character.

> **Tip:** Write errors in the same voice as the rest of the product, and never blame the person. “That postcode does not look complete” is easier to act on than “INVALID FORMAT”. The technical cause belongs in your logs, not in the interface.

## Autofill, keyboards and the cost of guessing

`autocomplete` is the highest-leverage attribute in forms. Correct tokens let password managers, address books and browser autofill do their job in one tap. `autocomplete="off"` is widely ignored for good reason; users want autofill, and browsers protect it. Use the specific token instead: `email`, `username`, `current-password`, `new-password`, `given-name`, `family-name`, `street-address`, `postal-code`, `cc-number`, `one-time-code`.

`inputmode` chooses the on-screen keyboard without changing validation. A one-time code should be `inputmode="numeric"` even when its `type` is `text`, because `type="number"` adds spinners, allows exponent notation and strips leading zeros. A phone number is `type="tel"` with `inputmode="tel"`. An email is `type="email"` with `inputmode="email"`; the type gives you a coarse validity check, the inputmode gives the keyboard.

```html run
<form class="shipping">
  <div class="field">
    <label for="first">First name</label>
    <input id="first" name="firstName" autocomplete="given-name">
  </div>
  <div class="field">
    <label for="last">Last name</label>
    <input id="last" name="lastName" autocomplete="family-name">
  </div>
  <div class="field full">
    <label for="street">Street address</label>
    <input id="street" name="street" autocomplete="street-address">
  </div>
  <div class="field">
    <label for="postcode">Postcode</label>
    <input id="postcode" name="postcode" autocomplete="postal-code" inputmode="numeric" spellcheck="false">
  </div>
  <div class="field">
    <label for="phone">Phone</label>
    <input id="phone" name="phone" type="tel" autocomplete="tel" inputmode="tel">
  </div>
  <button type="submit">Continue to payment</button>
</form>
<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .shipping {
    display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.1rem 1.25rem;
    max-width: 40rem; margin: 0 auto;
    padding: 1.75rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff;
  }
  .field { display: grid; gap: .35rem; min-width: 0; } .field.full { grid-column: 1 / -1; }
  label { font-weight: 650; color: #0f172a; font-size: .9rem; }
  input {
    width: 100%; box-sizing: border-box; padding: .65rem .75rem;
    border: 1.5px solid #cbd5e1; border-radius: 8px; font: inherit; color: #0f172a; background: #fff;
  }
  input:focus-visible { outline: 3px solid #b45309; outline-offset: 2px; border-color: #0f766e; }
  button { grid-column: 1 / -1; justify-self: start; padding: .75rem 1.1rem; border: 0; border-radius: 9px; background: #0f766e; color: #fff; font: inherit; font-weight: 650; cursor: pointer; }
  button:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

`minmax(0, 1fr)` matters. `1fr` has an automatic minimum of `min-content`, and a long email address or a postcode with no spaces can force a grid column wider than its share, producing sideways scroll. `minmax(0, 1fr)` lets the track shrink and the input wrap or scroll internally. If a textarea or notes field should span both columns, `grid-column: 1 / -1` says so once and survives a change in column count better than hard-coding `grid-column: span 2`.

## Custom controls without losing the control

Native checkboxes and radios are fast, familiar and accessible. Try `accent-color` before you reach for a custom design. It themes the native control in one declaration, keeps the platform''s high-contrast behaviour, and inherits into children, so you can set it once on `:root`:

```html run
<fieldset class="prefs">
  <legend>Trail alerts</legend>
  <label><input type="checkbox" checked> New routes near me</label>
  <label><input type="checkbox"> Closures and diversions</label>
  <label><input type="radio" name="frequency" checked> Weekly</label>
  <label><input type="radio" name="frequency"> Monthly</label>
  <label class="range-label" for="radius">Alert radius</label>
  <input id="radius" type="range" min="1" max="50" value="12">
</fieldset>

<style>
  :root { accent-color: #0f766e; }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .prefs { max-width: 26rem; margin: 0 auto; display: grid; gap: .65rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  legend { padding: 0 .35rem; font-weight: 750; }
  label { display: flex; align-items: center; gap: .6rem; }
  input[type="range"] { width: 100%; }
  input:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
```

When the design genuinely needs a custom shape, `appearance: none` removes the native painting but keeps the element''s semantics and keyboard behaviour. Do not replace the input with a `<span>`; style the input itself. The essential rules:

- The input stays in the DOM and stays focusable. `display: none` removes it from the accessibility tree and the tab order.
- The input has a real box: width, height and a border. The focus ring is drawn on that box.
- `:checked` changes the fill, and `::before` draws the check or dot. Pseudo-elements on a replaced control work reliably once `appearance: none` is set.
- The `<label>` is the hit target. Padding on the label gives you a large click area without hiding the control.
- A radio group is a `<fieldset>` with a `<legend>`, and every radio shares a `name`. Native arrow-key navigation only works when the inputs are actually focusable.

```html run
<fieldset class="choices">
  <legend>How should we contact you?</legend>
  <label class="check">
    <input type="checkbox" name="updates" checked>
    <span>Send me the weekly trail note</span>
  </label>
  <label class="check">
    <input type="radio" name="channel" value="email" checked>
    <span>Email</span>
  </label>
  <label class="check">
    <input type="radio" name="channel" value="sms">
    <span>SMS</span>
  </label>
</fieldset>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .choices { max-width: 28rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  legend { padding: 0 .35rem; font-weight: 750; }
  .check { display: flex; align-items: center; gap: .75rem; padding: .55rem .25rem; cursor: pointer; border-radius: 8px; }
  .check input {
    appearance: none; width: 22px; height: 22px; flex: none; margin: 0;
    display: grid; place-content: center;
    border: 2px solid #64748b; background: #fff; cursor: pointer;
  }
  .check input[type="checkbox"] { border-radius: 6px; }
  .check input[type="radio"] { border-radius: 50%; }
  .check input::before { content: ""; opacity: 0; }
  .check input[type="checkbox"]::before { width: 11px; height: 6px; border-left: 2.5px solid #fff; border-bottom: 2.5px solid #fff; transform: rotate(-45deg) translateY(-1px); }
  .check input[type="radio"]::before { width: 10px; height: 10px; border-radius: 50%; background: #fff; }
  .check input:checked { background: #0f766e; border-color: #0f766e; }
  .check input:checked::before { opacity: 1; }
  .check input:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
  .check:has(input:focus-visible) { background: #f1f5f9; }
</style>
```

Note the last rule. The focus ring is on the input, which is the thing that actually has focus; the row background is a secondary cue for anyone who finds a 22px ring hard to spot. This is the right order of operations. The control owns the state; the label decorates around it.

## Challenge: the two-column signup

Build a signup form with real labels, a two-column grid, and an email field whose hint is connected with `aria-describedby`. The starter uses placeholders as labels and stacks everything in one column. Replace the placeholders with labels, wire up the description, and let CSS Grid do the layout.

```html exercise id=two-column-signup title="The two-column signup"
<form class="signup">
  <div class="field">
    <input type="text" placeholder="First name">
  </div>
  <div class="field">
    <input type="email" placeholder="Email address">
  </div>
  <div class="field">
    <input type="text" placeholder="Favourite trail">
  </div>
  <button type="submit">Join the list</button>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .signup { max-width: 42rem; margin: 0 auto; padding: 1.75rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .field { margin-bottom: 1rem; }
  input { width: 100%; box-sizing: border-box; padding: .7rem .8rem; border: 1.5px solid #cbd5e1; border-radius: 8px; font: inherit; }
  button { padding: .75rem 1rem; border: 0; border-radius: 9px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; }
  /* TODO: make .signup a two-column grid with a sensible gap. */
</style>
--- solution
<form class="signup">
  <div class="field">
    <label for="first-name">First name</label>
    <input id="first-name" name="firstName" type="text" autocomplete="given-name">
  </div>
  <div class="field">
    <label for="email">Email address</label>
    <input id="email" name="email" type="email" autocomplete="email" inputmode="email" aria-describedby="email-hint">
    <p class="hint" id="email-hint">One note each Friday. No trail spam.</p>
  </div>
  <div class="field full">
    <label for="trail">Favourite trail</label>
    <input id="trail" name="trail" type="text" autocomplete="off">
  </div>
  <button type="submit">Join the list</button>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .signup {
    display: grid; grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.1rem 1.25rem; max-width: 42rem; margin: 0 auto;
    padding: 1.75rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff;
  }
  .field { display: grid; gap: .35rem; min-width: 0; }
  .field.full { grid-column: 1 / -1; }
  label { font-weight: 650; color: #0f172a; font-size: .9rem; }
  input { width: 100%; box-sizing: border-box; padding: .7rem .8rem; border: 1.5px solid #cbd5e1; border-radius: 8px; font: inherit; }
  input:focus-visible { outline: 3px solid #b45309; outline-offset: 2px; border-color: #0f766e; }
  .hint { margin: 0; color: #475569; font-size: .8rem; line-height: 1.4; }
  button { grid-column: 1 / -1; justify-self: start; padding: .75rem 1rem; border: 0; border-radius: 9px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; }
  button:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- test
const form = query(".signup");
assertStyle(".signup", "display", "grid", "Lay the form out with CSS Grid.");
const columns = getComputedStyle(form).gridTemplateColumns.trim().split(/\s+/);
assert(columns.length === 2, `The form should have two columns at this width, but it has ${columns.length}.`);
const inputs = [...form.querySelectorAll("input")];
assert(inputs.length >= 3, "Keep all three fields in the form.");
for (const input of inputs) {
  assert(input.labels && input.labels.length > 0, `The field for "${input.name || input.placeholder || "unknown"}" needs a real <label> associated with it.`);
}
const email = query(''input[type="email"]'');
assertAttr(''input[type="email"]'', "autocomplete", "email");
const describedBy = email.getAttribute("aria-describedby");
assert(describedBy, "Connect the email hint to the field with aria-describedby.");
const hint = document.getElementById(describedBy.split(/\s+/)[0]);
assert(hint, `aria-describedby points to "${describedBy}", but no element has that id.`);
assert(normalize(hint.textContent).length > 0, "The email hint should contain text that explains how the address is used.");
assertFocusable(''button[type="submit"]'', "Keep a focusable submit button.");
--- hint
Start from the markup: every `<input>` needs an `id` and a `<label for="…">`. Then give the email hint an `id` and list it in `aria-describedby` on the input.
--- hint
For the grid, set `display: grid` and `grid-template-columns: repeat(2, minmax(0, 1fr))` on `.signup`. Let the trail field and the button span both columns with `grid-column: 1 / -1`.
```

The `minmax(0, 1fr)` detail is what keeps a long email address from widening its column. Without it, the grid track''s automatic minimum is the input''s min-content width, and the form can develop a horizontal scrollbar on a narrow laptop. The test checks the number of tracks, not a specific pixel width, so any two-column arrangement at 1100px passes.

## Challenge: a custom checkbox that keeps focus

Style the checkbox below so it has a 22px custom box, a clearly different checked state, and a real keyboard focus ring. The input must remain the interactive element; the label is just the hit area.

```html exercise id=custom-checkbox-focus title="A checkbox with a real focus ring"
<label class="check">
  <input type="checkbox" name="updates">
  <span>Send me the weekly trail note</span>
</label>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .check { display: flex; align-items: center; gap: .7rem; max-width: 24rem; margin: 0 auto; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; cursor: pointer; }
  /* TODO: style the real input with appearance: none, a checked state and :focus-visible. */
</style>
--- solution
<label class="check">
  <input type="checkbox" name="updates">
  <span>Send me the weekly trail note</span>
</label>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .check { display: flex; align-items: center; gap: .7rem; max-width: 24rem; margin: 0 auto; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 12px; background: #fff; cursor: pointer; }
  .check input {
    appearance: none; width: 22px; height: 22px; flex: none; margin: 0;
    display: grid; place-content: center;
    border: 2px solid #64748b; border-radius: 6px; background: #fff;
    cursor: pointer;
  }
  .check input::before {
    content: ""; width: 11px; height: 6px;
    border-left: 2.5px solid #fff; border-bottom: 2.5px solid #fff;
    transform: rotate(-45deg) translateY(-1px); opacity: 0;
  }
  .check input:checked { background: #0f766e; border-color: #0f766e; }
  .check input:checked::before { opacity: 1; }
  .check input:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- test
const box = query(''input[type="checkbox"]'');
assertStyle(''input[type="checkbox"]'', "appearance", "none", "Use appearance: none on the real checkbox so you can draw the custom box.");
const size = box.getBoundingClientRect();
assert(size.width >= 18 && size.height >= 18, `The checkbox box should be at least 18px square, but it measures ${Math.round(size.width)} × ${Math.round(size.height)}.`);
box.focus();
assert(document.activeElement === box, "The real checkbox must still be able to receive focus.");
const focused = getComputedStyle(box);
const ringWidth = parseFloat(focused.outlineWidth) || 0;
assert((focused.outlineStyle !== "none" && ringWidth >= 2) || focused.boxShadow !== "none", "The focused checkbox needs a visible ring at least 2px thick, or a shadow ring.");
const unchecked = getComputedStyle(box).backgroundColor;
const label = query("label.check");
label.click();
assert(box.checked, "Clicking the label should toggle the checkbox.");
const checked = getComputedStyle(box).backgroundColor;
assert(checked !== unchecked, "The checked state should be visually different from the unchecked state, not just a different border colour.");
--- hint
Keep the `<input>` in the DOM. Set `appearance: none` on it, give it a width and height, and draw the check with `::before`.
--- hint
Use `.check input:checked { background: #0f766e; }` and `.check input:focus-visible { outline: 3px solid …; outline-offset: 3px; }`. Do not hide the input with `display: none`.
```

The test clicks the label rather than the input, which verifies the association the way a user experiences it. It also reads the computed background before and after checking, so a solution that only changes the border colour does not pass. The state has to be visible at a glance, not inferred from a one-pixel outline.

## Debug: the radio group that fell out of the tab order

This radio group looks right and works with a mouse. It cannot be reached with a keyboard. The custom dots are spans, and the real inputs were hidden with `display: none` to get rid of the native circles. Find the cause and make the real radios the controls again.

```html debug id=radio-focus-lost title="The radio group that fell out of the tab order"
<fieldset class="choices">
  <legend>How do you want updates?</legend>
  <label class="choice">
    <input type="radio" name="cadence" value="weekly" checked>
    <span class="dot" aria-hidden="true"></span>
    <span>Weekly digest</span>
  </label>
  <label class="choice">
    <input type="radio" name="cadence" value="monthly">
    <span class="dot" aria-hidden="true"></span>
    <span>Monthly digest</span>
  </label>
  <label class="choice">
    <input type="radio" name="cadence" value="never">
    <span class="dot" aria-hidden="true"></span>
    <span>Only essentials</span>
  </label>
</fieldset>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .choices { max-width: 28rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  legend { padding: 0 .35rem; font-weight: 750; }
  .choice { display: flex; align-items: center; gap: .75rem; padding: .55rem .25rem; cursor: pointer; }
  .choice input { display: none; }
  .choice .dot { width: 20px; height: 20px; flex: none; border: 2px solid #94a3b8; border-radius: 50%; background: #fff; }
  .choice input:checked + .dot { border-color: #0f766e; box-shadow: inset 0 0 0 5px #0f766e; }
  .choice:has(input:checked) { font-weight: 650; }
</style>
--- solution
<fieldset class="choices">
  <legend>How do you want updates?</legend>
  <label class="choice">
    <input type="radio" name="cadence" value="weekly" checked>
    <span>Weekly digest</span>
  </label>
  <label class="choice">
    <input type="radio" name="cadence" value="monthly">
    <span>Monthly digest</span>
  </label>
  <label class="choice">
    <input type="radio" name="cadence" value="never">
    <span>Only essentials</span>
  </label>
</fieldset>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .choices { max-width: 28rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  legend { padding: 0 .35rem; font-weight: 750; }
  .choice { display: flex; align-items: center; gap: .75rem; padding: .55rem .25rem; cursor: pointer; }
  .choice input {
    appearance: none; width: 20px; height: 20px; flex: none; margin: 0;
    display: grid; place-content: center;
    border: 2px solid #64748b; border-radius: 50%; background: #fff;
    cursor: pointer;
  }
  .choice input::before { content: ""; width: 10px; height: 10px; border-radius: 50%; background: #fff; opacity: 0; }
  .choice input:checked { background: #0f766e; border-color: #0f766e; }
  .choice input:checked::before { opacity: 1; }
  .choice input:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
  .choice:has(input:checked) { font-weight: 650; }
</style>
--- test
const radios = [...document.querySelectorAll(''input[type="radio"]'')];
assert(radios.length === 3, "Keep all three radio inputs.");
for (const radio of radios) {
  radio.focus();
  assert(document.activeElement === radio, `The "${radio.value}" radio cannot receive focus. Hiding the real input with display: none removes it from the tab order.`);
  const box = radio.getBoundingClientRect();
  assert(box.width > 0 && box.height > 0, `The "${radio.value}" radio should have a visible box; it currently measures ${Math.round(box.width)} × ${Math.round(box.height)}.`);
  const style = getComputedStyle(radio);
  const width = parseFloat(style.outlineWidth) || 0;
  const hasRing = (style.outlineStyle !== "none" && width >= 2) || style.boxShadow !== "none";
  assert(hasRing, `The "${radio.value}" radio has no visible focus ring. Focus must be visible on the control that receives it.`);
}
assertCount("fieldset .dot", 0, "Remove the fake dot spans; the real radio should draw its own indicator.");
--- hint
The inputs are still in the DOM, but `display: none` removes them from both the accessibility tree and the focus order. The span is what people see, and a span cannot receive focus.
--- hint
Delete `display: none` and style the input itself with `appearance: none`, width, height and a circular border. Put the inner dot on `input::before`, and add `input:focus-visible`.
```

> **In the wild:** Hiding a native control and drawing a fake one beside it is one of the most common accessibility regressions in design systems. The fake control passes visual review, and the bug only appears when someone tries to use the form without a mouse. If a component library does this, check whether the real input is merely visually hidden but still focusable, and whether the focus ring is drawn somewhere the user can see it.

## Challenge: the form that ends with a value

One last exercise in reading state. The form below is complete except for the error message. Add a visible inline error for the email field, connect it with `aria-describedby`, and make sure the red border and the message appear only when the field is actually invalid and the user has interacted. The tests set a partial address and check the structure; they do not require a particular class name.

Because an automated check cannot produce the trusted keyboard interaction that `:user-invalid` waits for, the solution pairs it with `:invalid:not(:placeholder-shown)`. That is not a test trick: it is a real fallback for browsers that do not support `:user-invalid`, and it gives you a way to verify the error state without a human at the keyboard. In production, put `:user-invalid` first and let the fallback cover the rest.

```html exercise id=inline-error-message title="An error you can read"
<form class="invite">
  <div class="field">
    <label for="invite-email">Email address</label>
    <input id="invite-email" name="email" type="email" required placeholder="sam@example.com" aria-describedby="invite-error">
    <p class="error" id="invite-error" hidden></p>
  </div>
  <button type="submit">Send invite</button>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .invite { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .field { display: grid; gap: .4rem; }
  label { font-weight: 650; color: #0f172a; }
  input { padding: .7rem .8rem; border: 2px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .error { margin: 0; color: #b91c1c; font-size: .85rem; font-weight: 600; }
  button { margin-top: 1rem; padding: .7rem 1rem; border: 0; border-radius: 8px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; }
  /* TODO: style the invalid state and reveal the message. */
</style>
--- solution
<form class="invite">
  <div class="field">
    <label for="invite-email">Email address</label>
    <input id="invite-email" name="email" type="email" required placeholder="sam@example.com" aria-describedby="invite-error">
    <p class="error" id="invite-error">Enter a complete address, like sam@example.com.</p>
  </div>
  <button type="submit">Send invite</button>
</form>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .invite { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #fff; }
  .field { display: grid; gap: .4rem; }
  label { font-weight: 650; color: #0f172a; }
  input { padding: .7rem .8rem; border: 2px solid #cbd5e1; border-radius: 8px; font: inherit; }
  .error { display: none; margin: 0; color: #b91c1c; font-size: .85rem; font-weight: 600; }
  input:user-invalid,
  input:invalid:not(:placeholder-shown) { border-color: #b91c1c; background: #fef2f2; }
  input:user-invalid:focus-visible,
  input:invalid:not(:placeholder-shown):focus-visible { outline: 3px solid #b45309; outline-offset: 2px; }
  .field:has(input:user-invalid) .error,
  .field:has(input:invalid:not(:placeholder-shown)) .error { display: block; }
  button { margin-top: 1rem; padding: .7rem 1rem; border: 0; border-radius: 8px; background: #0f172a; color: #fff; font: inherit; font-weight: 650; }
  button:focus-visible { outline: 3px solid #b45309; outline-offset: 3px; }
</style>
--- test
const input = query(''input[type="email"]'');
const describedBy = input.getAttribute("aria-describedby");
assert(describedBy, "The email field should point at its error message with aria-describedby.");
const error = document.getElementById(describedBy);
assert(error, `aria-describedby points to "${describedBy}", but no element has that id.`);
assertText("#" + describedBy, "Enter a complete address, like sam@example.com.", "The inline error should explain how to fix the address.");
const rules = [];
for (const sheet of document.styleSheets) {
  try { rules.push(...sheet.cssRules); } catch (error) {}
}
const css = rules.map((rule) => rule.cssText).join(" ");
assert(css.includes(":user-invalid"), "Use :user-invalid for the interaction-timed error state.");
input.value = "sam@";
input.dispatchEvent(new Event("input", { bubbles: true }));
assert(input.matches(":invalid"), "The partial address should make the field invalid.");
assert(!input.matches(":placeholder-shown"), "The field should no longer be showing its placeholder.");
assert(getComputedStyle(error).display !== "none", "The error message should become visible once the field holds an invalid value. Pair :user-invalid with the :invalid:not(:placeholder-shown) fallback so the state is observable.");
assertColor(''input[type="email"]'', "border-top-color", "#b91c1c", "The invalid field should also have a visible red border.");
--- hint
Use `input:user-invalid` rather than plain `input:invalid`; the latter is true on page load and would reveal the message before the visitor has typed.
--- hint
Reveal the paragraph with both selectors: `.field:has(input:user-invalid) .error, .field:has(input:invalid:not(:placeholder-shown)) .error { display: block; }`. The second selector is the fallback automated tests can trigger, and it also covers browsers without `:user-invalid`.
```

## Recap

- Every field needs a persistent label, a control, a hint and an error message. A placeholder is none of those.
- `:invalid` is true before interaction; `:user-invalid` waits for the user. Use the patient selector for inline feedback and the eager one for submit summaries.
- Connect hints and errors with `aria-describedby`, set `aria-invalid` while an error is active, and make the message explain the fix.
- Use specific `autocomplete` tokens and `inputmode` instead of guessing at keyboards. `type="number"` is a poor fit for codes and phone numbers.
- `accent-color` is the cheapest way to brand native controls. If you use `appearance: none`, keep the real input focusable and draw the ring on it.
- Lay forms out with Grid and `minmax(0, 1fr)`, and let wide fields span with `grid-column: 1 / -1`.

**Up next:** the accessibility tree — how browsers turn your markup into something a screen reader can navigate, and when ARIA helps versus when it lies.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_3_4', 'sec_html_css_advanced_3', 'crs_html_css_advanced', 'Checkpoint: motion & interaction', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the main difference between a transition and an animation?","options":["Transitions can only animate colors; animations can animate anything","A transition animates between two states in response to a change; an animation can define multiple keyframes and run independently","Animations do not support timing functions","Transitions require JavaScript"],"answerIndex":1,"explanation":"Transitions interpolate from an old value to a new value when a property changes, such as on hover. Animations use `@keyframes` to describe multiple stages and can run on their own with iteration, direction and fill modes. Both can be pure CSS."},{"id":"q2","prompt":"What does `animation-fill-mode: forwards` do?","options":["It reverses the animation","It keeps the final keyframe''s styles applied after the animation ends","It makes the animation loop forever","It delays the animation start"],"answerIndex":1,"explanation":"Without a fill mode, an element snaps back to its pre-animation styles when the animation ends. `forwards` retains the last keyframe. `backwards` applies the first keyframe during the delay, and `both` does both."},{"id":"q3","prompt":"In `cubic-bezier(0.2, 0.8, 0.2, 1)`, what does the curve control?","options":["The animation''s color interpolation","The pace of the animation over time","The number of keyframes","The element''s z-index during animation"],"answerIndex":1,"explanation":"A cubic Bézier defines the timing function: how much of the change happens at each point in time. It can create ease-in, ease-out, overshoot or a custom feel. It does not change what is animated, only the pacing."},{"id":"q4","prompt":"How should a large translate-and-scale entrance animation respond to `prefers-reduced-motion: reduce`?","options":["Ignore it and run the animation anyway","Replace the movement with an instant change or a short opacity fade","Slow the animation down to ten seconds","Make the animation repeat"],"answerIndex":1,"explanation":"Reduced motion is a request to avoid vestibular triggers such as large movement, scaling, parallax and spinning. A short opacity fade or an immediate state change preserves the content and feedback without the motion. Slowing it down can make it worse."},{"id":"q5","prompt":"Why use `:focus-visible` instead of `:focus` for a custom focus ring?","options":["`:focus` does not work on buttons","`:focus-visible` generally shows the ring for keyboard navigation while avoiding it after a mouse click","`:focus-visible` removes focus from the tab order","They are identical in every browser"],"answerIndex":1,"explanation":"`:focus` matches whenever an element has focus, including after a click. `:focus-visible` matches when the browser determines that a visible focus indicator is helpful, usually for keyboard users. It lets you keep a polished mouse experience without sacrificing keyboard accessibility."},{"id":"q6","prompt":"What is the advantage of `:user-invalid` over `:invalid` for form styling?","options":["It only matches after the user has interacted with the field, avoiding red errors on a pristine form","It validates the value on the server","It disables native validation","It only works on checkboxes"],"answerIndex":0,"explanation":"`:invalid` can match immediately on page load for an empty required field, which feels like the form is shouting before the user has done anything. `:user-invalid` waits until the user has interacted and the value is still invalid. Browser support is good in modern engines."},{"id":"q7","prompt":"You style a custom checkbox with `appearance: none`. What must you preserve?","options":["The default browser border","A visible focus indicator and the native checked/disabled semantics","A JavaScript click handler","The `size` attribute"],"answerIndex":1,"explanation":"`appearance: none` removes the native look, not the semantics. Keep the input focusable, show a clear focus style, and reflect `:checked` and `:disabled` visually. Use the real input (or a label connected to it) so keyboard and screen-reader users still get the control."},{"id":"q8","prompt":"How should an inline form error be associated with its input?","options":["Put the error in a `<div>` after the form and hope it is noticed","Give the error an `id` and reference it from the input''s `aria-describedby`","Set the error as the input''s placeholder","Use `aria-hidden=\"true\"` on the error"],"answerIndex":1,"explanation":"`aria-describedby` points to the error text, so assistive technology announces it when the field receives focus. The error should also be visible and specific. A placeholder disappears and is not a reliable error channel; hiding the error from assistive tech makes it useless."},{"id":"q9","prompt":"Why is placeholder text often a contrast problem?","options":["Placeholders are always black","Browsers often render placeholders at a lower opacity, which can fall below the 4.5:1 AA threshold","Placeholders cannot be styled","Placeholders only appear in dark mode"],"answerIndex":1,"explanation":"The default placeholder color is intentionally muted, and some browsers apply opacity on top. That can produce low contrast. Check the actual rendered color and never use a placeholder as the only label — when the user types, the hint disappears."},{"id":"q10","prompt":"What does `accent-color` do?","options":["Changes the page''s background","Sets the accent color used by native controls such as checkboxes, radio buttons and range inputs","Applies a CSS filter to images","Sets the focus ring width"],"answerIndex":1,"explanation":"`accent-color` themes the built-in UI of native form controls in supporting browsers. It is a small, accessible way to make controls match a brand without rebuilding them. It does not replace custom focus styles or contrast checks."}]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_4_1', 'sec_html_css_advanced_4', 'crs_html_css_advanced', 'Semantics, ARIA and the accessibility tree', 'interactive', 0, 1440, NULL, NULL, 'A screen reader does not read your HTML file. It reads a second tree that the browser builds from it: the accessibility tree. Each node in that tree has a role, a name, a state and sometimes a value. “Button, Save changes, pressed” is a node. “Group, blank” is what a styled `<div>` becomes when it has no semantics. The visual result can be identical. The experience is not.

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

> **Under the hood:** The accessibility tree is computed, not authored. The same DOM can produce different trees in different browsers, especially for edge cases in ARIA. That is why “it works in Chrome” is not an accessibility test. Roles, names and states are the stable contract; the exact announcement order is the screen reader''s business.

## Landmarks and headings

Landmark elements are the page''s table of contents. `<header>` is a banner, `<nav>` is navigation, `<main>` is the main content, `<aside>` is complementary, `<footer>` is content information. A `<form>` becomes a form landmark only when it has an accessible name; a `<section>` becomes a region only when it has one too. That naming rule is deliberate: an unnamed region is noise, not orientation.

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
3. Native naming — `<label>`, `<legend>`, `alt`, or the element''s own text content.
4. `title` — a last resort that many screen readers ignore.

`aria-labelledby` wins over `aria-label`. That is useful when the best name lives elsewhere on the page: a “Delete” button inside a dialog can point at the dialog title, so it is announced as “Delete project” rather than a bare “Delete”. It is dangerous when the referenced element changes or disappears; the button''s name goes with it. Prefer a visible `<label>` or the button''s own text when you can.

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

The “Delete” button''s visible text is part of its accessible name (“Delete project”), which satisfies the Label in Name rule: someone using voice control can say the visible word and still hit the control. If the accessible name were only “Remove”, the visible label and the spoken label would disagree, and voice control would fail.

> **Pitfall:** `aria-label` overrides visible text. A button that says “Submit” but has `aria-label="Send application"` is announced as “Send application”, while a sighted colleague reading over the user''s shoulder sees “Submit”. Keep the visible words inside the accessible name, or drop the override.

## Predict: what is this button called?

Read the markup carefully. The button has visible text, but another name source has higher priority.

```html predict id=accessible-name-precedence title="What is the button''s accessible name?"
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
`aria-labelledby="dialog-title"` points at the `<h2>`, so the button''s name is computed from that heading''s text: “Delete project”. The visible word “Delete” is ignored for naming because `aria-labelledby` has higher priority than the element''s contents. This is a legitimate pattern when the surrounding context is essential, but it must not contradict the visible label: “Delete project” still contains “Delete”, so voice control can find it.
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

Only add a state if the element''s role supports it. `aria-expanded` on a plain `<div>` does nothing useful; on a `<button>` that controls a panel it tells the screen reader “collapsed” or “expanded”. `aria-controls` is a relationship hint; support is uneven, so do not rely on it as the only connection. The panel should still follow the button in the DOM and be labelled by it.

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

This card is marked `aria-hidden="true"` because the same product appears in a featured slot elsewhere on the page. The card also contains the only link to the product''s visit page. A screen-reader user can still Tab to the link, but hears nothing when they get there. Fix the hiding so the card is announced and the decorative mark stays out of the tree.

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
assert(link.closest(''[aria-hidden="true"]'') === null, "The visit link is inside an aria-hidden subtree, so it is focusable but silent. Remove aria-hidden from the card.");
assertText(".card a", "Plan a visit", "Keep the visible link text.");
assertVisible(".card", "The card should remain visible.");
assertAttr(".mark", "aria-hidden", "true", "Keep the decorative star hidden from assistive technology.");
assertFocusable(".card a", "The visit link should stay reachable with Tab.");
--- hint
The link''s ancestor has `aria-hidden="true"`. Everything inside that subtree is removed from the accessibility tree, including the heading, paragraph and link.
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
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_4_2', 'sec_html_css_advanced_4', 'crs_html_css_advanced', 'Color systems, contrast and dark mode', 'interactive', 1, 1320, NULL, NULL, 'Colour is the first thing a page says and the last thing teams systematise. A brand palette arrives as a folder of hex codes, gets sprinkled through components, and six months later nobody can change the warning colour without breaking a checkout badge. Dark mode makes the problem visible: the same hex that looked confident on white turns into a muddy smudge on near-black, and the “inverted” theme looks like a photograph negative.

The fix is two ideas working together. A **perceptual colour space** lets you build scales where equal steps look equal. A **semantic token layer** lets components ask for “surface” and “text” instead of memorising a hex value. Contrast is the constraint that keeps both honest. Once those three are in place, dark mode is a token swap rather than a second stylesheet.

## Colour spaces: why `hsl` lies

Hex, `rgb()` and `hsl()` all describe colours in sRGB. They are precise, but they are not perceptually uniform. In HSL, lightness is a mathematical coordinate, not a measure of how bright the colour looks. `hsl(60 100% 50%)` is a luminous yellow; `hsl(240 100% 50%)` at the same lightness is a deep blue that reads much darker. Build a scale by changing `l` and the steps will feel uneven, especially across hues.

`oklch()` is built on perceptual lightness. The three coordinates are lightness (`0`–`1`), chroma (roughly, colourfulness) and hue angle. Two colours with the same `L` look similarly light, even when their hues are far apart. That makes it a better space for generating tints, shades and hover states:

```css
:root {
  --brand: oklch(0.62 0.14 180);
  --brand-hover: oklch(from var(--brand) calc(l - 0.08) c h);
  --brand-soft: oklch(from var(--brand) 0.94 calc(c * 0.35) h);
}
```

The `from` syntax is **relative colour syntax**: it takes an existing colour and lets you adjust its channels. It is supported in current Chrome, Safari and Firefox; if you need older browsers, generate the same values at build time or provide a fallback declaration before the relative one. `color-mix(in oklch, var(--brand), white 80%)` is the other useful primitive for tints without a preprocessor.

```html run
<div class="swatches">
  <div class="swatch hsl-1"><span>hsl 220</span></div>
  <div class="swatch hsl-2"><span>hsl 20</span></div>
  <div class="swatch hsl-3"><span>hsl 140</span></div>
  <div class="swatch ok-1"><span>oklch 250</span></div>
  <div class="swatch ok-2"><span>oklch 30</span></div>
  <div class="swatch ok-3"><span>oklch 140</span></div>
</div>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .swatches { display: grid; grid-template-columns: repeat(3, 1fr); gap: .75rem; max-width: 42rem; margin: 0 auto; }
  .swatch { display: grid; place-items: end start; min-height: 110px; padding: .75rem; border-radius: 12px; color: #fff; font-size: .8rem; font-weight: 700; }
  .hsl-1 { background: hsl(220 80% 55%); }
  .hsl-2 { background: hsl(20 80% 55%); }
  .hsl-3 { background: hsl(140 80% 55%); }
  .ok-1 { background: oklch(0.62 0.16 250); }
  .ok-2 { background: oklch(0.62 0.16 30); }
  .ok-3 { background: oklch(0.62 0.16 140); }
</style>
```

The top row is HSL at a constant lightness; the bottom row is OKLCH at a constant `L`. The bottom row reads as one family. The top row does not: the yellow-green is much lighter than the blue, even though the numbers claim otherwise. That is the whole argument for perceptual spaces in one image.

> **Under the hood:** `oklch()` can describe colours outside sRGB. On a wide-gamut display, a high-chroma value may render more vividly than the same value on an sRGB screen. Browsers gamut-map out-of-range colours rather than clipping them, so the result stays usable, but “exact” brand matching still belongs in a calibrated colour pipeline, not in a CSS variable.

## Semantic tokens, not colour names

A design system needs three layers, not one:

1. **Primitives** describe what a colour is: `--teal-700`, `--slate-50`, `--amber-500`.
2. **Semantic tokens** describe what a colour does: `--color-bg`, `--color-surface`, `--color-text`, `--color-text-muted`, `--color-border`, `--color-accent`, `--color-danger`, `--color-focus`.
3. **Component tokens** are optional aliases for a single component: `--button-bg`, `--button-fg`.

Components consume semantic tokens. They never reach for a primitive directly, and they never hard-code a hex. The theme changes the semantic values; the component rules stay still. This is what makes dark mode a ten-line change instead of an audit.

```html run
<div class="themes">
  <section class="theme">
    <p class="label">Light theme</p>
    <article class="card">
      <span class="eyebrow">Revenue</span>
      <strong>$48,210</strong>
      <p>Up 12.4% from last month.</p>
    </article>
  </section>
  <section class="theme" data-theme="dark">
    <p class="label">Dark theme</p>
    <article class="card">
      <span class="eyebrow">Revenue</span>
      <strong>$48,210</strong>
      <p>Up 12.4% from last month.</p>
    </article>
  </section>
</div>

<style>
  :root {
    --bg: #f8fafc; --surface: #ffffff;
    --text: #0f172a; --muted: #475569; --border: #e2e8f0;
    --accent: #0f766e;
  }
  [data-theme="dark"] {
    --bg: #0b1020; --surface: #111827;
    --text: #f8fafc; --muted: #cbd5e1; --border: #334155;
    --accent: #5eead4;
  }
  body { margin: 0; padding: 2rem; background: #e2e8f0; font-family: system-ui, sans-serif; }
  .themes { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1rem; max-width: 42rem; margin: 0 auto; }
  .theme { padding: 1.25rem; border-radius: 16px; background: var(--bg); color: var(--text); }
  .label { margin: 0 0 .75rem; color: var(--muted); font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  .card { display: grid; gap: .35rem; padding: 1.25rem; border: 1px solid var(--border); border-radius: 12px; background: var(--surface); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 1.9rem; letter-spacing: -.03em; }
  .card p { margin: 0; color: var(--muted); font-size: .9rem; }
</style>
```

A nested `data-theme="dark"` on the second section redefines the tokens for that subtree. Custom properties inherit, so every descendant resolves `var(--surface)` against the nearest definition. That property is why theme scoping works on a component preview, a settings panel, or a single demo card — not just the whole document.

> **Pitfall:** Do not mix token layers. A component that uses `var(--slate-900)` for text cannot be themed by changing `--color-text`; it will stay dark in dark mode. The primitive is allowed to exist, but components should not know its name.

## Contrast is luminance, not hue

WCAG contrast is a ratio between relative luminance values, from 1:1 (identical) to 21:1 (black on white). The thresholds depend on the size and weight of the text:

| Content | AA minimum | AAA minimum |
|---|---|---|
| Normal text | 4.5:1 | 7:1 |
| Large text (24px, or 18.66px bold) | 3:1 | 4.5:1 |
| Icons, focus rings, control boundaries | 3:1 | — |

The formula is `(L1 + 0.05) / (L2 + 0.05)`, where `L1` is the lighter relative luminance. You do not need to compute it by hand; every browser''s DevTools shows the ratio for a selected text colour, and the `assertColor` helper in this course checks the computed value. What you do need is the habit of checking the **composited** colour. Text over a translucent surface is not contrasting against the token you wrote; it is contrasting against whatever ends up behind it.

```html run
<div class="badges">
  <p class="badge pass"><span aria-hidden="true">✓</span> Paid · 4.86:1</p>
  <p class="badge large"><span aria-hidden="true">✓</span> Large label · 4.38:1</p>
  <p class="badge fail"><span aria-hidden="true">!</span> Review · 2.07:1</p>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badges { display: grid; gap: .75rem; max-width: 26rem; margin: 0 auto; }
  .badge { display: flex; align-items: center; gap: .5rem; margin: 0; padding: .65rem .85rem; border-radius: 10px; font-weight: 650; }
  .pass { background: #ccfbf1; color: #0f766e; }
  .large { background: #ffedd5; color: #b45309; font-size: 20px; font-weight: 700; }
  .fail { background: #fffbeb; color: #f59e0b; }
</style>
```

The first badge passes AA for normal text. The second is large and bold, so 4.38:1 clears the 3:1 large-text threshold — but only because of its size and weight. The third fails even the large-text threshold. A colour can feel “warm” or “on brand” and still be unreadable; contrast does not negotiate with taste.

> **Tip:** Placeholder text is text. It needs 4.5:1 against the field background, not the faint grey that most browsers default to. If the placeholder is the only hint, fix the contrast and add a real label; if it is an example, make it optional and keep it readable.

## Dark mode without a second design

There are two related mechanisms. `prefers-color-scheme` reads the operating-system preference. A class or `data-theme` attribute lets the product override it. Use both: the media query provides a sensible default, and the attribute supports an explicit choice.

```css
:root {
  color-scheme: light;
  --bg: #f8fafc;
  --surface: #ffffff;
  --text: #0f172a;
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    color-scheme: dark;
    --bg: #0b1020;
    --surface: #111827;
    --text: #f8fafc;
  }
}

[data-theme="dark"] {
  color-scheme: dark;
  --bg: #0b1020;
  --surface: #111827;
  --text: #f8fafc;
}
```

The `:not([data-theme="light"])` guard is what allows a user on a dark OS to force the light theme. Without it, the media rule would keep winning and the toggle would only work in one direction. The explicit `[data-theme="dark"]` rule handles the opposite case: a light OS with a dark preference stored by the product.

`color-scheme` is not decoration. It tells the browser which palette to use for scrollbars, form controls, spellcheck underlines and the canvas behind the page. Set it alongside your tokens, or a dark page will still have a white scrollbar and white native inputs.

> **Pitfall:** `:root` and an attribute selector can have the same specificity. Order matters. Put the explicit theme rules after the media query, and test both directions: light OS + dark attribute, and dark OS + light attribute. A theme that only works in the direction you developed it is a theme with a bug.

## Surfaces and shadows in the dark

Light interfaces create depth with shadows. Dark interfaces cannot rely on the same trick: a black shadow on a near-black background is invisible. Elevation in dark mode comes from **lighter surfaces plus borders**, with a tinted shadow as a subtle finishing touch. The higher the surface, the lighter it gets.

Do not use pure black for the page or pure white for the text. Pure black makes every border and shadow disappear; pure white on black produces halation, a glowing edge that makes long text tiring. A near-black with a blue cast and an off-white with a little warmth read as designed rather than default.

```html run
<div class="dark-room">
  <article class="surface one">
    <span>Surface 1</span>
    <p>Page-level cards sit closest to the background.</p>
  </article>
  <article class="surface two">
    <span>Surface 2</span>
    <p>Popovers and menus lift one step.</p>
  </article>
  <article class="surface three">
    <span>Surface 3</span>
    <p>Dialogs and command palettes lift again.</p>
  </article>
</div>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #0b1020; font-family: system-ui, sans-serif; color: #e5e7eb; }
  .dark-room { display: grid; gap: 1rem; max-width: 38rem; margin: 0 auto; }
  .surface { padding: 1.1rem 1.25rem; border: 1px solid #26324a; border-radius: 14px; }
  .surface span { font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; color: #94a3b8; }
  .surface p { margin: .35rem 0 0; color: #cbd5e1; line-height: 1.55; }
  .one { background: #111827; box-shadow: 0 12px 28px -20px rgb(2 6 23 / .9); }
  .two { background: #172033; box-shadow: 0 18px 36px -22px rgb(2 6 23 / .95); }
  .three { background: #1e293b; box-shadow: 0 24px 48px -24px rgb(2 6 23 / 1); }
</style>
```

The shadow is tinted with the background hue (`rgb(2 6 23 / …)`), not pure black. It is quiet, but it keeps the card from looking pasted on. The border does most of the separation work. This is the opposite of light mode, where the shadow carries the depth and the border is often optional.

Saturated accents also need recalibration. A deep teal that looks rich on white can vibrate against a dark surface, while a lighter, less chromatic version reads as the same brand colour. OKLCH makes that adjustment mechanical: raise `L`, lower `C`, keep `H`. The dark theme''s `--accent` in the token example does exactly that.

## Colour is not the only signal

Roughly one in twelve men and a smaller share of women have some form of colour-vision deficiency. Red-green is the most common; blue-yellow is rarer; complete colour blindness is rarer still. The practical consequence is not “red and green look identical to everyone”. It is that a red dot and a green dot can become the same brownish dot, especially at small sizes, and a link that is distinguished only by hue can disappear into body text.

Never use colour alone to carry status, required-ness, error or selection. Pair it with at least one other channel:

- An icon or shape: ✓, !, ×, a filled versus outlined dot.
- Text: “Paid”, “Overdue”, “Optional”.
- Position: the error message below the field, the selected tab with an underline.
- Pattern or texture: for charts, not for body text.

```html run
<ul class="orders">
  <li class="ok"><span class="mark" aria-hidden="true">✓</span> Delivered</li>
  <li class="warn"><span class="mark" aria-hidden="true">!</span> Delayed</li>
  <li class="bad"><span class="mark" aria-hidden="true">×</span> Cancelled</li>
</ul>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; color: #0f172a; }
  .orders { display: grid; gap: .6rem; max-width: 24rem; margin: 0 auto; padding: 0; list-style: none; }
  .orders li { display: flex; align-items: center; gap: .65rem; padding: .75rem .9rem; border: 1px solid #e2e8f0; border-radius: 10px; background: #fff; font-weight: 650; }
  .mark { display: grid; place-items: center; width: 1.3rem; height: 1.3rem; border-radius: 50%; font-size: .75rem; }
  .ok .mark { background: #dcfce7; color: #166534; }
  .warn .mark { background: #fef3c7; color: #92400e; }
  .bad .mark { background: #fee2e2; color: #991b1b; }
</style>
```

Remove the marks and the list still says “Delivered”, “Delayed” and “Cancelled” in words. Remove the words and the marks still carry meaning. That redundancy is the point. A colour-blind user, a user in grayscale, and a user reading in bright sunlight all get the same answer.

> **In the wild:** Forced-colours mode replaces your palette with the user''s system colours. `box-shadow` and background images often disappear, while `outline` and borders remain. This is why a focus ring made only of `box-shadow` can vanish for the people who need it most. Keep a real `outline` as the primary indicator.

## Predict: which token wins?

The document has `data-theme="dark"` on the wrapper. The operating system is in light mode. Read the cascade before you choose.

```html predict id=dark-token-cascade title="Which surface wins in dark mode?"
<div class="app" data-theme="dark">
  <article class="card">
    <span>Revenue</span>
    <strong>$48,210</strong>
  </article>
</div>

<style>
  :root { --surface: #ffffff; --text: #0f172a; }
  @media (prefers-color-scheme: dark) {
    :root { --surface: #111827; --text: #e5e7eb; }
  }
  [data-theme="dark"] { --surface: #1e293b; --text: #f8fafc; }
  body { margin: 0; padding: 3rem 1.5rem; background: #e2e8f0; font-family: system-ui, sans-serif; }
  .app { max-width: 26rem; margin: 0 auto; padding: 1.25rem; border-radius: 16px; background: var(--surface); }
  .card { display: grid; gap: .35rem; padding: 1.25rem; border: 1px solid #334155; border-radius: 12px; background: var(--surface); color: var(--text); }
  span { font-size: .75rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; opacity: .7; }
  strong { font-size: 1.8rem; }
</style>
--- options
* `#1e293b`, because the explicit dark theme overrides the root tokens
`#ffffff`, because the operating system is in light mode
`#111827`, because the media query always wins in dark mode
Transparent, because no token is defined on the card
--- explain
The media query does not match on a light OS, so the root stays `#ffffff`. The `[data-theme="dark"]` rule then redefines the tokens on the wrapper, and the card inherits them: `#1e293b`. If the OS were dark, both the media rule and the attribute rule would apply; the attribute rule comes later and wins the tie, so the explicit choice still takes precedence.
```

## Testing both themes

A theme is a state, so it needs state testing, not a screenshot of the default.

1. **DevTools → Rendering → Emulate CSS media feature `prefers-color-scheme`.** Check light and dark without changing your OS.
2. **Toggle the attribute in the console.** `document.documentElement.dataset.theme = "dark"` is usually enough. Check the opposite override too: dark OS with `data-theme="light"`.
3. **Check contrast in both.** A token pair that passes in light can fail in dark, especially muted text and borders. Use the DevTools contrast readout on real text, not on the token swatch.
4. **Check non-text contrast.** Focus rings, checkbox borders, input boundaries and icons need 3:1 against their adjacent colours. A 3:1 focus ring on a 3:1 border is not automatically visible; it needs to separate from both the control and the page.
5. **Check forced colours and grayscale.** In DevTools, emulate `forced-colors: active` and check that controls, focus and status still make sense. Then use a colour-blindness simulator or a grayscale filter to see whether any status is carried by hue alone.
6. **Read the computed values.** In a test, toggle the theme attribute and assert the resolved `background-color` and `color`, not the custom-property string. Tokens are inputs; computed colours are the output users see.

## Challenge: a card that changes its clothes

Build the token layer for a small analytics card. The light theme uses `#ffffff` for the surface, `#0f172a` for the text and `#0f766e` for the accent. A `data-theme="dark"` attribute on the root should switch the surface to `#111827`, the text to `#f8fafc`, the accent to `#5eead4`, and set `color-scheme: dark` so native UI follows. The card must consume only semantic tokens.

```html exercise id=theme-token-card title="A card that changes its clothes"
<article class="card">
  <span class="eyebrow">Revenue</span>
  <strong>$48,210</strong>
  <p>Up 12.4% from last month.</p>
</article>

<style>
  :root {
    color-scheme: light;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
    --accent: #0f766e;
  }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: var(--surface); color: var(--text); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 2rem; letter-spacing: -.03em; }
  p { margin: 0; color: var(--muted); line-height: 1.55; }
  /* TODO: add a data-theme="dark" token block. */
</style>
--- solution
<article class="card">
  <span class="eyebrow">Revenue</span>
  <strong>$48,210</strong>
  <p>Up 12.4% from last month.</p>
</article>

<style>
  :root {
    color-scheme: light;
    --surface: #ffffff;
    --text: #0f172a;
    --muted: #475569;
    --accent: #0f766e;
  }
  [data-theme="dark"] {
    color-scheme: dark;
    --surface: #111827;
    --text: #f8fafc;
    --muted: #cbd5e1;
    --accent: #5eead4;
  }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; display: grid; gap: .35rem; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: var(--surface); color: var(--text); }
  .eyebrow { color: var(--accent); font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  strong { font-size: 2rem; letter-spacing: -.03em; }
  p { margin: 0; color: var(--muted); line-height: 1.55; }
</style>
--- test
assertColor(".card", "background-color", "#ffffff", "The light theme surface should be #ffffff.");
assertColor(".card", "color", "#0f172a", "The light theme text should be #0f172a.");
assertColor(".eyebrow", "color", "#0f766e", "The light theme accent should come from a semantic token, not a hard-coded hex.");
document.documentElement.setAttribute("data-theme", "dark");
assertColor(".card", "background-color", "#111827", "With data-theme=\"dark\", the card should use the dark surface #111827.");
assertColor(".card", "color", "#f8fafc", "With the dark theme, the text should switch to #f8fafc instead of staying dark.");
assertColor(".eyebrow", "color", "#5eead4", "The accent also needs a dark-theme value; deep teal loses contrast on a dark surface.");
const scheme = getComputedStyle(document.documentElement).colorScheme;
assert(scheme.includes("dark"), "Set color-scheme: dark in the dark theme so scrollbars and native controls follow it.");
--- hint
Add `[data-theme="dark"] { … }` after `:root`. Redefine `--surface`, `--text`, `--muted` and `--accent`, and set `color-scheme: dark`.
--- hint
The card already reads `var(--surface)`, `var(--text)` and `var(--accent)`. You only need the token block; do not add new component colour declarations.
```

The test changes the attribute and reads the computed colours, so it verifies the cascade rather than the presence of a particular custom property. That is the useful level of abstraction: a component may rename its tokens tomorrow, but “the card is light on light and dark on dark” is the behaviour the user sees.

## Challenge: a badge you can actually read

This status badge fails contrast badly. Choose a foreground colour that reaches at least 4.5:1 against its existing background, while keeping the visible label. The badge already uses text, so the status is not conveyed by colour alone; the job here is legibility.

```html exercise id=status-badge-contrast title="A badge you can actually read"
<p class="badge">Pending review</p>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badge { display: inline-block; margin: 0; padding: .4rem .7rem; border-radius: 999px; background: #fef3c7; color: #f59e0b; font-size: .85rem; font-weight: 700; }
</style>
--- solution
<p class="badge">Pending review</p>

<style>
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; font-family: system-ui, sans-serif; }
  .badge { display: inline-block; margin: 0; padding: .4rem .7rem; border-radius: 999px; background: #fef3c7; color: #92400e; font-size: .85rem; font-weight: 700; }
</style>
--- test
const badge = query(".badge");
assertText(".badge", "Pending review", "Keep the visible status label.");
function luminance(rgb) {
  const channels = rgb.map((value) => {
    const c = value / 255;
    return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
function ratio(foreground, background) {
  const a = luminance(foreground);
  const b = luminance(background);
  return (Math.max(a, b) + 0.05) / (Math.min(a, b) + 0.05);
}
function channels(value) {
  return getComputedStyle(badge)[value].match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
}
const contrast = ratio(channels("color"), channels("backgroundColor"));
assert(contrast >= 4.5, `The badge text is only ${contrast.toFixed(2)}:1 against its background. Normal text needs at least 4.5:1.`);
--- hint
The background is already light amber. You need a much darker foreground; the current amber is too close to the background in luminance.
--- hint
Try a deep brown such as `#92400e`. That computes to roughly 6.4:1 against `#fef3c7` — comfortably above 4.5:1 without changing the background.
```

## Debug: the dark theme with light-theme text

The dark surfaces are in place, but the text was never migrated. The headings and paragraphs still carry the light theme''s near-black values, so they almost disappear against the dark card. Fix the theme so every piece of text is readable, and set `color-scheme` for native UI.

```html debug id=dark-inherited-text title="The dark theme with light-theme text"
<article class="card">
  <span class="eyebrow">Trail status</span>
  <h2>North ridge open</h2>
  <p>The lower path is muddy after rain. The ridge is dry and clear.</p>
</article>

<style>
  :root { color-scheme: light; }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; color: #0f172a; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #ffffff; }
  .eyebrow { color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.4rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.6; }
  [data-theme="dark"] body { background: #0b1020; }
  [data-theme="dark"] .card { background: #111827; border-color: #334155; }
</style>
--- solution
<article class="card">
  <span class="eyebrow">Trail status</span>
  <h2>North ridge open</h2>
  <p>The lower path is muddy after rain. The ridge is dry and clear.</p>
</article>

<style>
  :root { color-scheme: light; }
  body { margin: 0; padding: 3rem 1.5rem; background: #f8fafc; color: #0f172a; font-family: system-ui, sans-serif; }
  .card { max-width: 26rem; margin: 0 auto; padding: 1.5rem; border: 1px solid #e2e8f0; border-radius: 16px; background: #ffffff; }
  .eyebrow { color: #0f766e; font-size: .72rem; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; }
  h2 { margin: .35rem 0 .5rem; font-size: 1.4rem; color: #0f172a; }
  p { margin: 0; color: #475569; line-height: 1.6; }
  [data-theme="dark"] { color-scheme: dark; }
  [data-theme="dark"] body { background: #0b1020; }
  [data-theme="dark"] .card { background: #111827; border-color: #334155; }
  [data-theme="dark"] .eyebrow { color: #5eead4; }
  [data-theme="dark"] h2 { color: #f8fafc; }
  [data-theme="dark"] p { color: #cbd5e1; }
</style>
--- test
document.documentElement.setAttribute("data-theme", "dark");
const card = query(".card");
assertColor(".card", "background-color", "#111827", "The dark card should use the dark surface.");
function luminance(value) {
  const match = value.match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
  const channels = match.map((channel) => {
    const c = channel / 255;
    return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}
function contrastOf(selector) {
  const fg = luminance(getComputedStyle(query(selector)).color);
  const bg = luminance(getComputedStyle(card).backgroundColor);
  return (Math.max(fg, bg) + 0.05) / (Math.min(fg, bg) + 0.05);
}
const heading = contrastOf(".card h2");
const body = contrastOf(".card p");
assert(heading >= 4.5, `The dark-theme heading is only ${heading.toFixed(2)}:1 against the card. Give it a light text colour.`);
assert(body >= 4.5, `The dark-theme paragraph is only ${body.toFixed(2)}:1 against the card. Do not leave light-theme muted text in the dark theme.`);
const scheme = getComputedStyle(document.documentElement).colorScheme;
assert(scheme.includes("dark"), "Set color-scheme: dark on the dark theme.");
--- hint
The card background changes, but `h2` and `p` have explicit light-theme colours. Inheritance alone cannot fix an explicit value.
--- hint
Add overrides such as `[data-theme="dark"] h2 { color: #f8fafc; }` and `[data-theme="dark"] p { color: #cbd5e1; }`. Set `[data-theme="dark"] { color-scheme: dark; }` too.
```

> **Pitfall:** A theme audit that only checks the page background will miss exactly this bug. Text colours, borders, icons, disabled states and focus rings each have their own contrast requirement. Toggle the theme and walk the page with the contrast checker, not just the hero section.

## Recap

- `hsl` is intuitive but not perceptually uniform. `oklch()` gives you equal-looking steps and predictable hover and tint scales.
- Keep primitives separate from semantic tokens. Components ask for `--color-surface`, not `--slate-900`, so a theme can change underneath them.
- AA is 4.5:1 for normal text, 3:1 for large text and non-text UI. Contrast is computed against the final composited background, not the token in isolation.
- Support both `prefers-color-scheme` and an explicit `data-theme`, with a guard that lets either override win. Set `color-scheme` so native UI follows.
- Dark elevation comes from lighter surfaces and borders; shadows are tinted and quiet. Avoid pure black and pure white for large areas.
- Never carry status by hue alone. Pair colour with text, icons, position or pattern, and check both themes in forced-colours and grayscale.

**Up next:** performance as a design constraint — critical CSS, font loading, responsive images and the layout shifts that make a fast page feel slow.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_4_3', 'sec_html_css_advanced_4', 'crs_html_css_advanced', 'Performance: critical CSS, fonts, responsive images and CLS', 'interactive', 2, 1440, NULL, NULL, 'A fast page is not a page with fewer features. It is a page that decides what the browser needs *first*, and refuses to make it wait for everything else. That decision is made in HTML and CSS long before a single byte of JavaScript runs: which styles are critical, which font may swap, which image candidate fits the slot, and how much space every piece of media reserves before it arrives.

This lesson is about the critical path: the work between a request and the first useful paint. You will learn why CSS blocks rendering, how to make fonts behave, how `srcset` and `picture` actually choose files, and how to stop images from shoving your layout around. You will also learn when *not* to optimize, because a performance technique applied without measurement is just another bug waiting to happen.

## What happens before the first paint

The browser receives HTML and starts building the DOM. When it finds a stylesheet, it builds the CSSOM, and rendering waits until both trees are ready. That is why CSS is called **render-blocking**: a slow stylesheet delays every pixel, even the pixels it does not style. Images and fonts are different. They are fetched in parallel, and the page can paint without them, but their arrival can still change the layout or the text you see.

The fastest page is usually the one that paints a useful, stable version early. That means the above-the-fold layout should depend on a small amount of CSS, and everything else can arrive later.

```html run
<header class="hero">
  <p class="kicker">Trail notes · 14</p>
  <h1>Weather that changes plans.</h1>
  <p class="lede">A field guide to the week the forecast gave up. Pack for four seasons and a very long lunch.</p>
</header>
<section class="below">
  <h2>What is below the fold</h2>
  <p>This section can wait. The hero above already gives the page a usable shape.</p>
</section>

<style>
  /* Critical: reset, type, and the hero only. */
  body { margin: 0; font-family: ui-sans-serif, system-ui, sans-serif; background: #f8fafc; color: #0f172a; }
  .hero { max-width: 52rem; margin: 0 auto; padding: 4rem 1.5rem 2rem; }
  .kicker { margin: 0 0 0.75rem; color: #0f766e; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
  h1 { margin: 0 0 1rem; font-size: clamp(2.4rem, 7vw, 4.5rem); line-height: 0.98; letter-spacing: -0.05em; }
  .lede { max-width: 36rem; margin: 0; color: #475569; font-size: 1.1rem; line-height: 1.6; }
  /* Non-critical: this can be discovered later. */
  .below { max-width: 52rem; margin: 0 auto; padding: 2rem 1.5rem 4rem; border-top: 1px solid #e2e8f0; }
</style>
```

The split is not about which rules are "important" to you. It is about which rules are needed to paint the first screen. A footer, a modal and a comments widget are not critical, even if they are important to the product.

> **Under the hood:** The browser can discover images while it parses HTML, but it cannot know where they go until CSS gives it a layout. That is why an image can be downloaded and still cause a shift when it finally gets a box.

## Critical CSS is a budget, not a trick

Inlining the CSS for the first screen removes a round trip. The common pattern is to inline the critical rules in `<head>`, then load the rest without blocking the first paint. On a large site, that "rest" is a real file with caching and versioning; in a lesson, we can only show the shape of the decision.

The tradeoff is maintenance. Inlined CSS is duplicated in every HTML response and cannot be cached separately. If you inline too much, every page carries CSS it does not use. If you inline too little, the first paint waits on a network request. The useful question is not "how do I inline everything?" but "what is the smallest set of rules that makes the first screen look intentional?"

> **Pitfall:** Do not inline a full design system to win a Lighthouse point. A 40 KB inline block that delays HTML parsing on every navigation can be slower than one cached file.

## Fonts: make the fallback acceptable

A web font is a layout risk disguised as a download. While it loads, the browser has three choices: hide the text (`block`), show a fallback immediately (`swap`), or show a fallback and swap when the font arrives (`fallback`/`optional`). `font-display` chooses the policy per `@font-face`.

```html run
<p class="display">Trailhead Coffee</p>
<p class="body">Small-batch coffee for people who walk up hills, with a fallback that appears immediately.</p>

<style>
  @font-face {
    font-family: "Trailhead Display";
    src: local("Georgia"), local("Times New Roman");
    font-display: swap;
  }

  :root {
    --font-display: "Trailhead Display", Georgia, "Times New Roman", serif;
    --font-body: ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif;
  }

  body { margin: 0; padding: 2rem; background: #f4f1ea; color: #1f2937; font-family: var(--font-body); }
  .display { margin: 0 0 1rem; font-family: var(--font-display); font-size: clamp(2.5rem, 8vw, 5rem); line-height: 0.95; letter-spacing: -0.04em; }
  .body { max-width: 34rem; margin: 0; color: #57534e; font-size: 1.05rem; line-height: 1.6; }
</style>
```

`font-display: swap` is usually the right default for body text: the reader sees content immediately. The cost is a visible swap, and a swap can move text if the fallback has very different metrics. You can reduce that jump by choosing a fallback with a similar x-height and width, or by using `size-adjust` and `ascent-override` on a fallback `@font-face`. The goal is not a perfect match; it is a jump small enough that nobody loses their place.

`preload` is for fonts you know the first screen needs, and it is easy to overuse. A preloaded font competes with CSS and the largest image for bandwidth. Preload one display face, not five weights. And prefer a local stack when the brand can tolerate it: a system font costs zero bytes and zero milliseconds.

> **Tip:** `font-display: optional` is a strong choice for decorative type. If the font misses a very short window, the page keeps the fallback for that visit and avoids a late swap entirely.

## Responsive images: let the browser choose

An `<img>` with one `src` asks every device to download the same file. `srcset` gives the browser candidates; `sizes` tells it how wide the image will be laid out, so it can estimate the pixels it needs. The browser combines that slot width with the device pixel ratio and picks a candidate. It is a hint, not a command.

```html run
<figure class="shot">
  <img
    src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg=="
    srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg== 400w,
            data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMjAwIDkwMCI+PHJlY3Qgd2lkdGg9IjEyMDAiIGhlaWdodD0iOTAwIiBmaWxsPSIjNDMzOGNhIi8+PC9zdmc+ 1200w,
            data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNjAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjYwMCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg== 800w"
    sizes="(min-width: 760px) 50vw, 100vw"
    width="1200" height="900"
    alt="A ridge line at dusk"
    loading="lazy"
    decoding="async">
  <figcaption>At this width the 800w candidate fits the 50vw slot.</figcaption>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .shot { max-width: 640px; margin: 0; }
  .shot img { display: block; width: 100%; height: auto; border-radius: 16px; }
  figcaption { margin-top: 0.75rem; color: #64748b; font-size: 0.875rem; }
</style>
```

The `sizes` value describes **layout width**, not the image''s intrinsic width. `(min-width: 760px) 50vw` means "on a wide screen this image occupies half the viewport." At 1100 px, that is a 550 px slot. With a 1× display, the browser wants at least 550 px, so the 800w candidate is the sensible choice. On a 2× phone the same slot needs 1100 px, and the 1200w candidate wins.

> **Pitfall:** A wrong `sizes` value is worse than no `sizes` at all. If you claim the image is 300 px wide when it renders at 900 px, the browser downloads a file that looks soft and then scales it up.

Candidates do not have to be in numeric order, and the browser does not simply take the last one. It evaluates descriptors and picks the smallest suitable candidate, with some allowance for quality. That is why you can list `400w`, `1200w`, `800w` and still get the 800w file.

## Challenge: build a responsive trip image

The starter has a fixed image with good alt text and dimensions. Add a `srcset` with 400w, 800w and 1200w candidates, a `sizes` value that describes the layout, and lazy/async hints. The data URIs are already in the file; reuse them.

```html exercise id=responsive-trip-image title="Build a responsive trip image"
<figure class="trip">
  <img
    src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg=="
    alt="A ridge line at dusk"
    width="400" height="300">
  <figcaption>Ridge line at dusk</figcaption>
</figure>

<style>
  body { margin: 0; padding: 2rem; font-family: ui-sans-serif, system-ui, sans-serif; background: #f8fafc; }
  .trip { max-width: 720px; margin: 0; }
  .trip img { display: block; width: 100%; height: auto; border-radius: 14px; }
  figcaption { margin-top: 0.75rem; color: #64748b; font-size: 0.875rem; }
</style>
--- solution
<figure class="trip">
  <img
    src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg=="
    srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg== 400w,
            data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMjAwIDkwMCI+PHJlY3Qgd2lkdGg9IjEyMDAiIGhlaWdodD0iOTAwIiBmaWxsPSIjNDMzOGNhIi8+PC9zdmc+ 1200w,
            data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNjAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjYwMCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg== 800w"
    sizes="(min-width: 720px) 50vw, 100vw"
    alt="A ridge line at dusk"
    width="800" height="600"
    loading="lazy"
    decoding="async">
  <figcaption>Ridge line at dusk</figcaption>
</figure>

<style>
  body { margin: 0; padding: 2rem; font-family: ui-sans-serif, system-ui, sans-serif; background: #f8fafc; }
  .trip { max-width: 720px; margin: 0; }
  .trip img { display: block; width: 100%; height: auto; border-radius: 14px; }
  figcaption { margin-top: 0.75rem; color: #64748b; font-size: 0.875rem; }
</style>
--- test
const img = query(".trip img");
assertAttr(".trip img", "alt", "A ridge line at dusk");
const srcset = img.getAttribute("srcset") || "";
assert(srcset.split(",").filter(Boolean).length >= 3, "The srcset should contain three candidates (400w, 800w and 1200w)");
assert(/400w/.test(srcset) && /800w/.test(srcset) && /1200w/.test(srcset), "Use width descriptors: 400w, 800w and 1200w");
const sizes = img.getAttribute("sizes") || "";
assert(sizes.includes("vw"), "The sizes attribute should describe the layout width in viewport units");
assertAttr(".trip img", "loading", "lazy");
assertAttr(".trip img", "decoding", "async");
assert(img.getAttribute("width") && img.getAttribute("height"), "Keep width and height so the browser can reserve space");
--- hint
`srcset` lists candidate files with `w` descriptors. `sizes` tells the browser how wide the image will render.
--- hint
Use `sizes="(min-width: 720px) 50vw, 100vw"`: half the viewport on a wide screen, full width on a narrow one.
--- hint
Add `loading="lazy"` and `decoding="async"` to the `<img>`, and keep the width and height attributes.
```

## Lazy loading is not free

`loading="lazy"` tells the browser to defer images that are far from the viewport. That is excellent for a long gallery and dangerous for the largest image on the first screen. If the hero image is lazy, the browser waits until layout is nearly done before it starts the download, and your LCP gets worse. Mark above-the-fold images `loading="eager"` (or omit the attribute) and reserve lazy loading for the content below.

`decoding="async"` lets the browser decode an image off the main thread. It is a hint for non-critical images. For an image that must be ready for the first paint, synchronous decoding can be better; for a gallery further down, async keeps scrolling smooth. Again: the attribute is a decision, not a badge.

## Reserve the space: CLS

Cumulative Layout Shift measures how much visible content moves unexpectedly. The classic cause is an image with no dimensions: the browser paints the text, the image arrives, and everything below it jumps. Width and height attributes give the browser an intrinsic aspect ratio before the file arrives. Modern CSS can do the same with `aspect-ratio`, which is useful when the media is cropped or responsive.

```html run
<section class="feed">
  <article class="story">
    <div class="media">
      <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNTAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjUwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==" width="800" height="500" alt="A green valley">
    </div>
    <h2>Space is reserved before the image loads</h2>
    <p>The caption below the media does not move when the file arrives.</p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .feed { max-width: 560px; margin: 0 auto; }
  .story { padding: 1rem; border: 1px solid #e2e8f0; border-radius: 18px; background: white; }
  .media { aspect-ratio: 16 / 10; overflow: hidden; border-radius: 12px; background: #e2e8f0; }
  .media img { display: block; width: 100%; height: 100%; object-fit: cover; }
  h2 { margin: 1rem 0 0.35rem; font-size: 1.25rem; }
  p { margin: 0; color: #64748b; line-height: 1.5; }
</style>
```

The `width` and `height` attributes are not a suggestion to render at 800 × 500. They tell the browser the aspect ratio, and CSS scales the image. `aspect-ratio` on the wrapper reserves the box even before the image has loaded, which also gives you a neutral placeholder color.

> **Pitfall:** `height: auto` with no dimensions is the layout-shift recipe. If you must support images with unknown dimensions, put them in a fixed-ratio container and crop with `object-fit: cover`.

## Challenge: stop the story card from jumping

This card renders an image with no reserved space. The headline and body text jump down when the image loads. Add dimensions to the image and a stable media box. The tests accept either intrinsic width/height attributes or a computed aspect ratio on the image or its container.

```html exercise id=reserve-story-space title="Stop the story card from jumping"
<article class="story">
  <div class="media">
    <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNTAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjUwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==" alt="A green valley">
  </div>
  <h2>A quiet valley</h2>
  <p>Text that should not move when the photograph arrives.</p>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .story { max-width: 560px; margin: 0 auto; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 18px; background: white; }
  .media img { display: block; width: 100%; }
  h2 { margin: 1rem 0 0.35rem; font-size: 1.25rem; }
  p { margin: 0; color: #64748b; line-height: 1.5; }
</style>
--- solution
<article class="story">
  <div class="media">
    <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNTAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjUwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==" width="800" height="500" alt="A green valley">
  </div>
  <h2>A quiet valley</h2>
  <p>Text that should not move when the photograph arrives.</p>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .story { max-width: 560px; margin: 0 auto; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 18px; background: white; }
  .media { aspect-ratio: 16 / 10; overflow: hidden; border-radius: 12px; background: #e2e8f0; }
  .media img { display: block; width: 100%; height: 100%; object-fit: cover; }
  h2 { margin: 1rem 0 0.35rem; font-size: 1.25rem; }
  p { margin: 0; color: #64748b; line-height: 1.5; }
</style>
--- test
const img = query(".story img");
assertAttr(".story img", "alt", "A green valley");
const hasDimensions = img.getAttribute("width") && img.getAttribute("height");
const imgRatio = getComputedStyle(img).aspectRatio;
const media = query(".story .media");
const mediaRatio = getComputedStyle(media).aspectRatio;
const ratioReserved = [imgRatio, mediaRatio].some((value) => value && value !== "auto");
assert(hasDimensions || ratioReserved, "Reserve the image''s box with width/height attributes or an aspect-ratio on the image or its container");
assert(query(".story").getBoundingClientRect().height > 250, "The card should have a stable, visible media area");
--- hint
Add the image''s real `width` and `height` attributes. That gives the browser the aspect ratio before the file loads.
--- hint
You can also give `.media` an `aspect-ratio` and let the image fill it with `width: 100%; height: 100%; object-fit: cover`.
```

## Art direction is a different problem

`srcset` chooses a resolution. `<picture>` chooses a **composition**. If a wide landscape crop turns a portrait subject into a tiny dot on a phone, you need different files, not smaller versions of the same file. `<source>` elements carry `media` conditions, and the browser uses the first one that matches. The `<img>` is both the fallback and the accessible image, and it must come last.

```html run
<picture class="banner">
  <source media="(max-width: 699px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0ODAgNjQwIj48cmVjdCB3aWR0aD0iNDgwIiBoZWlnaHQ9IjY0MCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==">
  <source media="(min-width: 700px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==">
  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==" alt="The studio at golden hour" width="960" height="480" loading="lazy" decoding="async">
</picture>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .banner img { display: block; width: 100%; max-width: 720px; height: auto; border-radius: 18px; }
</style>
```

At 1100 px, both the `min-width` source and the fallback are wide; the first matching source wins. At 500 px, the `max-width` source wins and the composition changes. The order of `<source>` elements matters because the first match wins — put the narrow, more specific art direction before the broad fallback, or make the conditions mutually exclusive as above.

> **Under the hood:** The `<img>` is not optional inside `<picture>`. It supplies the alt text, the intrinsic dimensions and the fallback when no source matches. A `<picture>` without an `<img>` is invalid and may not render at all.

## Debug: the picture that ignored its sources

This banner is supposed to use a portrait crop on phones and a wide crop on desktop. Instead, the fallback image always wins. Run it, inspect the markup, and fix the element order. The tests also expect the loading hints to survive the repair.

```html debug id=picture-fallback-order title="The picture that ignored its sources"
<picture class="banner">
  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==" alt="The studio at golden hour" width="960" height="480" loading="lazy" decoding="async">
  <source media="(max-width: 699px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0ODAgNjQwIj48cmVjdCB3aWR0aD0iNDgwIiBoZWlnaHQ9IjY0MCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==">
  <source media="(min-width: 700px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==">
</picture>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .banner img { display: block; width: 100%; max-width: 720px; height: auto; border-radius: 18px; }
</style>
--- solution
<picture class="banner">
  <source media="(max-width: 699px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0ODAgNjQwIj48cmVjdCB3aWR0aD0iNDgwIiBoZWlnaHQ9IjY0MCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg==">
  <source media="(min-width: 700px)" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==">
  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5NjAgNDgwIj48cmVjdCB3aWR0aD0iOTYwIiBoZWlnaHQ9IjQ4MCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg==" alt="The studio at golden hour" width="960" height="480" loading="lazy" decoding="async">
</picture>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .banner img { display: block; width: 100%; max-width: 720px; height: auto; border-radius: 18px; }
</style>
--- test
const picture = query("picture.banner");
assertCount("picture.banner source", 2, "Keep both art-directed sources");
const children = Array.from(picture.children).map((el) => el.tagName.toLowerCase());
assert(children[children.length - 1] === "img", "The img fallback must be the last child of picture. Move it after the sources.");
const sources = Array.from(picture.querySelectorAll("source"));
assert(sources.some((s) => (s.media || "").includes("min-width")), "Keep a source for wide screens");
assert(sources.some((s) => (s.media || "").includes("max-width")), "Keep a source for narrow screens");
assertAttr("picture.banner img", "loading", "lazy");
assertAttr("picture.banner img", "decoding", "async");
assertAttr("picture.banner img", "alt", "The studio at golden hour");
--- hint
A `<picture>` chooses among the `<source>` elements that come *before* its `<img>`. Anything after the image is ignored.
--- hint
Move the entire `<img>` line below the two `<source>` lines. Do not delete it: it carries the alt text and the fallback.
```

## Predict: which candidate wins?

Read the `sizes` value before you look at the picture. The image occupies a 600 px slot on a wide screen, and the display is 1×.

```html predict id=srcset-candidate title="Which image candidate wins?"
<img
  src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg=="
  srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iIzBmNzY2ZSIvPjwvc3ZnPg== 400w,
          data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMjAwIDkwMCI+PHJlY3Qgd2lkdGg9IjEyMDAiIGhlaWdodD0iOTAwIiBmaWxsPSIjNDMzOGNhIi8+PC9zdmc+ 1200w,
          data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4MDAgNjAwIj48cmVjdCB3aWR0aD0iODAwIiBoZWlnaHQ9IjYwMCIgZmlsbD0iI2I0NTMwOSIvPjwvc3ZnPg== 800w"
  sizes="(min-width: 900px) 600px, 100vw"
  alt="A demonstration image"
  width="800" height="600"
  style="display:block;width:100%;max-width:600px;height:auto">
--- options
* The 800w amber image
The 400w teal image
The 1200w indigo image
All three, one after another
--- explain
`sizes` says the image will occupy 600 CSS pixels on a wide screen. At a device pixel ratio of 1, the browser needs at least 600 pixels, so it chooses the smallest candidate that covers the slot: 800w. The 400w file would be soft; the 1200w file would waste bytes. On a 2× screen the same slot needs 1200 pixels, so the 1200w candidate would win. The order of the candidates in the attribute does not decide the winner — the descriptors do.
```

## Containment: skip work that is off-screen

`content-visibility: auto` lets the browser skip layout and paint for content that is far outside the viewport. On a long article, that can make the first render much cheaper. `contain-intrinsic-size` supplies a placeholder size so the scrollbar does not jump wildly as sections are skipped and rendered.

```html run
<main class="notes">
  <section class="note">
    <h2>Day one: the long ridge</h2>
    <p>We started before the light and finished after it. The middle was mostly weather.</p>
  </section>
  <section class="note">
    <h2>Day two: the longer ridge</h2>
    <p>The forecast promised sun. The forecast was optimistic.</p>
  </section>
  <section class="note">
    <h2>Day three: the café</h2>
    <p>A strategic withdrawal, a very good pastry, and no regrets.</p>
  </section>
  <section class="note">
    <h2>Day four: home</h2>
    <p>The boots dried out somewhere around the third motorway services.</p>
  </section>
</main>

<style>
  body { margin: 0; background: #f8fafc; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .notes { max-width: 44rem; margin: 0 auto; padding: 2rem 1.5rem; }
  .note { content-visibility: auto; contain-intrinsic-size: auto 170px; padding: 1.5rem 0; border-bottom: 1px solid #e2e8f0; }
  h2 { margin: 0 0 0.5rem; font-size: 1.35rem; }
  p { margin: 0; color: #475569; line-height: 1.6; }
</style>
```

The tradeoff is real. Skipped content can affect find-in-page, accessibility navigation and scrollbar accuracy. If your intrinsic size is too small, the scrollbar jumps when a section renders. If it is too large, the page feels longer than it is. Use containment on long, self-contained sections, not on your navigation or hero.

## Measure, then decide

Open DevTools and use the tools that answer the question you actually have:

- **Performance panel** for a trace: when did CSS arrive, when did the font swap, when did the image decode, when was the first paint?
- **Network panel** for the waterfall and priority: is the hero image competing with a preloaded font?
- **Layout Shift regions** in the Rendering drawer to see what moved.
- **Lighthouse** for a second opinion, not a verdict. A score is a summary of a lab run, not your users'' experience.

The metrics that matter in the field are LCP (largest contentful paint), CLS (layout shift) and INP (interaction latency). This course cannot run a field study, but the mental model is enough: optimize the element that is actually late, not the one that is easiest to change.

> **In the wild:** Most "performance work" on real teams starts with a budget: for example, "the hero image must be under 200 KB and the LCP must be under 2.5 seconds on a mid-range phone." A budget turns a vague virtue into a design constraint you can test.

## When optimization is premature

Optimization is premature when you cannot name the metric you are improving. Inlining CSS for a page with no network latency, lazy-loading an image that is already in the first viewport, or preloading every font weight "just in case" can make the experience worse. The same is true of `content-visibility`: on a short page it adds complexity and can break focus or search.

Start with the default that is already good: semantic HTML, a local font stack, dimensions on media, one well-sized image. Measure on a slow connection. Fix the largest delay. Then stop, because every additional technique is another thing your team has to understand.

## Recap

- CSS is render-blocking; inline only the rules the first screen needs, and cache the rest.
- `font-display: swap` gets text on screen early; choose fallback metrics to reduce the swap.
- `srcset` + `sizes` let the browser choose a file based on layout width and pixel density.
- `<picture>` is for art direction; `<source>` elements must come before the `<img>` fallback.
- `loading="lazy"` and `decoding="async"` are for below-the-fold media, not the hero.
- Width/height attributes and `aspect-ratio` reserve space before an image arrives, which prevents CLS.
- `content-visibility` is containment for long pages, with real tradeoffs for search and scroll stability.
- Measure the metric before you optimize it. A performance technique without a measurement is a guess.

**Up next:** modern CSS as a design material — native nesting, perceptually uniform color, scroll snap and feature queries that let you ship enhancements without breaking the baseline.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_4_4', 'sec_html_css_advanced_4', 'crs_html_css_advanced', 'Checkpoint: accessibility & performance', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"How is a button''s accessible name usually computed?","options":["From its `id` attribute only","From its visible text, or from `aria-labelledby`/`aria-label` when those are present","From its CSS class name","From the color of the button"],"answerIndex":1,"explanation":"The accessible name comes from the element''s contents first, such as the text inside a `<button>`. `aria-labelledby` can point to another element, and `aria-label` can provide a string. IDs and class names are not names; they are hooks for CSS and scripting."},{"id":"q2","prompt":"Why is `aria-hidden=\"true\"` on a focusable link dangerous?","options":["It makes the link load faster","The link is removed from the accessibility tree but can still receive keyboard focus, leaving keyboard users on an invisible control","It changes the link''s destination","It disables the link''s hover state"],"answerIndex":1,"explanation":"`aria-hidden` hides content from assistive technology, but it does not remove it from the tab order. A focusable element that is hidden from the accessibility tree becomes a trap: keyboard users can focus it, but screen readers cannot explain it. Never hide focusable content this way."},{"id":"q3","prompt":"A `<div role=\"button\">` needs more than a role. What must you add?","options":["Only a hover style","Keyboard focusability, Enter/Space activation and the correct disabled/expanded semantics","A `title` attribute","A second nested div"],"answerIndex":1,"explanation":"A role only tells assistive technology what the element is. A real button is focusable, activates with Enter and Space, and exposes native state. Reimplementing all of that on a div is easy to get wrong; use a `<button>` whenever possible."},{"id":"q4","prompt":"Which attribute communicates whether a disclosure is open?","options":["`aria-open`","`aria-expanded`","`aria-visible`","`aria-checked`"],"answerIndex":1,"explanation":"`aria-expanded=\"true|false\"` tells assistive technology whether the controlled content is expanded. It is commonly used on a button that toggles a menu or panel, often paired with `aria-controls`. The visual state and the attribute must stay in sync."},{"id":"q5","prompt":"What is the WCAG AA minimum contrast ratio for normal-sized text?","options":["2:1","3:1","4.5:1","7:1"],"answerIndex":2,"explanation":"AA requires 4.5:1 for normal text and 3:1 for large text. AAA raises those to 7:1 and 4.5:1. Non-text UI components and graphical objects also need 3:1 against adjacent colors. Always test the actual rendered pair."},{"id":"q6","prompt":"Which media query targets a user who prefers a dark color scheme?","options":["`@media (dark-mode: true)`","`@media (prefers-color-scheme: dark)`","`@media (color: dark)`","`@media (theme: night)`"],"answerIndex":1,"explanation":"`prefers-color-scheme: dark` reflects the operating system or browser preference. Pair it with a class-based theme toggle if the product allows manual overrides, and keep the tokens semantic so both themes stay consistent."},{"id":"q7","prompt":"Why should status not be communicated by color alone?","options":["Color always fails WCAG","People with color vision deficiencies or monochrome displays may not perceive the difference; add text, an icon or a pattern","Color increases page weight","Screen readers cannot read colored text"],"answerIndex":1,"explanation":"Color can be a useful cue, but it must not be the only one. A red dot for \"error\" is ambiguous to someone who cannot distinguish red from green. Add a label, icon or shape so the meaning survives without color perception."},{"id":"q8","prompt":"What is the purpose of `srcset` on an `<img>`?","options":["It adds a caption","It offers multiple image sources so the browser can choose an appropriate resolution or format","It lazy-loads JavaScript","It makes every image the same size"],"answerIndex":1,"explanation":"`srcset` provides a set of candidate images with descriptors such as `1x`/`2x` or widths. Combined with `sizes`, the browser chooses the best candidate for the viewport and pixel density. This avoids sending a huge image to a small screen."},{"id":"q9","prompt":"How does `font-display: swap` help perceived performance?","options":["It downloads the font faster","It shows fallback text immediately and swaps in the custom font when it loads","It removes the need for a fallback stack","It makes the font smaller"],"answerIndex":1,"explanation":"`swap` avoids invisible text while a font is loading: the fallback renders immediately, then the custom face replaces it. That improves perceived speed but can cause a visible reflow. Pair it with a well-matched fallback stack and font metrics overrides to reduce layout shift."},{"id":"q10","prompt":"What does `content-visibility: auto` do?","options":["Hides content from screen readers","Lets the browser skip rendering work for offscreen content, with `contain-intrinsic-size` reducing layout jumps","Loads images from another domain","Disables CSS animations"],"answerIndex":1,"explanation":"`content-visibility: auto` allows the browser to skip layout and painting for content outside the viewport until it is needed. `contain-intrinsic-size` gives the browser a placeholder size so scrollbars and layout remain stable. It can improve rendering performance on long pages, but test it with find-in-page and accessibility tools."}]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_5_1', 'sec_html_css_advanced_5', 'crs_html_css_advanced', 'Modern CSS: nesting, color functions, scroll snap and @supports', 'interactive', 0, 1320, NULL, NULL, 'CSS used to be a language you wrote *around* your markup. Modern CSS is a language you can write *with* it: nesting keeps a component''s rules together, color functions describe intent instead of hex codes, scroll snap turns a long strip into a usable gallery, and feature queries let you ship an enhancement without abandoning the baseline.

None of these features is decoration. Each one removes a category of glue code or a class of bug. The craft is knowing which parts are safe to adopt, which need a fallback, and where an older technique is still the clearer choice.

## Nesting: proximity without surprise

Native nesting lets a rule live inside another rule and inherit its scope. `&` refers to the parent selector, so `& h2` means "an `h2` inside this component." The compiled meaning is close to the flat selector you would have written before, but the source stays readable: the card''s padding, heading, tag and link are one block instead of four scattered selectors.

```html run
<article class="note-card">
  <p class="eyebrow">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p>Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; color: #1f2937; }
  .note-card {
    max-width: 34rem;
    padding: 1.5rem;
    border: 1px solid #d6d3d1;
    border-radius: 20px;
    background: #fffdf8;
    transition: border-color 160ms ease;

    & .eyebrow {
      margin: 0 0 0.5rem;
      color: #b45309;
      font-size: 0.72rem;
      font-weight: 700;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }

    & h2 { margin: 0 0 0.5rem; font-size: 1.6rem; letter-spacing: -0.03em; }
    & p { margin: 0 0 1rem; color: #57534e; line-height: 1.6; }
    & .cta { color: #0f766e; font-weight: 650; text-decoration: none; }
    &:hover { border-color: #0f766e; }
  }
</style>
```

Two details matter. First, a nested selector that omits `&` is still relative to the parent; `.note-card { p { ... } }` means `.note-card p`, not a global `p`. Second, `&` takes the specificity of the parent selector, similar to `:is()`. If the parent selector is a list, `&` uses the most specific selector in that list. That is useful, but it also means nesting can quietly raise specificity.

> **Pitfall:** Nesting is not a license to recreate a five-level Sass tree. If a selector needs four levels to find its target, the component probably needs a class, not a deeper nest. Deep nesting makes overrides harder and hides which element you are actually styling.

## Color that describes a relationship

Hex codes are absolute. Design systems need relationships: a softer version of the brand, a text color that works on a tinted surface, a hover state that is darker but still the same hue. `oklch()` describes color by lightness, chroma and hue, which makes those relationships easier to reason about. Relative color syntax goes further: it derives a new color from an existing token.

```html run
<div class="swatches">
  <div class="swatch brand">Brand</div>
  <div class="swatch soft">Soft</div>
  <div class="swatch mixed">Mixed</div>
</div>

<style>
  :root { --brand: oklch(55% 0.16 255); }
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .swatches { display: flex; flex-wrap: wrap; gap: 0.75rem; }
  .swatch { display: grid; place-items: center; min-width: 9rem; min-height: 5rem; border-radius: 14px; font-weight: 650; }

  .brand { background: #2563eb; background: var(--brand); color: #fff; }

  .soft {
    background: #dbeafe;
    background: oklch(from var(--brand) 93% calc(c * 0.25) h);
    color: #1e3a8a;
    color: oklch(from var(--brand) 32% c h);
  }

  .mixed {
    background: #93c5fd;
    background: color-mix(in oklab, var(--brand) 60%, #f59e0b);
    color: #172554;
  }
</style>
```

`oklch()` is **perceptually uniform**: the same lightness value looks roughly equally light across hues, which is not true of `hsl()`. That makes it a better space for generating tints, shades and accessible pairs. Relative syntax `oklch(from var(--brand) 93% calc(c * 0.25) h)` says: take the brand, keep its hue, reduce its chroma, and raise its lightness to 93%.

`color-mix()` is for blending two known colors. `color-mix(in oklab, var(--brand) 60%, #f59e0b)` produces a color that is 60% brand and 40% amber, mixed in a perceptual space. Use it for hover states, tinted badges and translucent overlays: `color-mix(in srgb, var(--brand) 12%, transparent)` is a clean way to make a brand wash without inventing another token.

> **Under the hood:** Browsers that support `oklch()` can render a wider gamut than sRGB on capable displays. Always keep a fallback declaration first. The fallback is not an insult to modern browsers; it is the baseline that lets an old browser show a usable page.

## Aspect ratio and scroll snap

`aspect-ratio` is the quiet workhorse of media layout. It reserves a box from a width or height, so a gallery can crop images consistently and a video can keep its shape before it loads. Combined with `object-fit: cover`, it gives you a stable frame with no magic numbers.

Scroll snap is the other half of a good horizontal gallery. The scroll container declares an axis and a strictness; each child declares where it wants to land. The browser handles momentum, touch and keyboard scrolling. You do not need a carousel library for a row of cards.

```html run
<section class="rail" tabindex="0" aria-label="Recent studio work">
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#0f172a"/><circle cx="200" cy="48" r="22" fill="#fbbf24"/><path d="M0 150 L80 70 L140 130 L200 84 L260 142 V180 H0Z" fill="#0f766e"/></svg>
    <figcaption>Ridge study</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#e7e5e4"/><rect x="38" y="38" width="184" height="104" rx="10" fill="#b45309"/><path d="M60 120 L105 70 L140 104 L172 64 L200 120Z" fill="#fff7ed"/></svg>
    <figcaption>Studio wall</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#dbeafe"/><path d="M0 132 Q70 58 140 118 T260 96 V180 H0Z" fill="#2563eb"/><circle cx="72" cy="54" r="20" fill="#f59e0b"/></svg>
    <figcaption>Blue hour</figcaption>
  </figure>
  <figure class="slide">
    <svg viewBox="0 0 260 180" aria-hidden="true"><rect width="260" height="180" fill="#f5f5f4"/><rect x="42" y="48" width="70" height="84" rx="6" fill="#0f766e"/><rect x="124" y="72" width="94" height="60" rx="6" fill="#1f2937"/></svg>
    <figcaption>Two blocks</figcaption>
  </figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .rail {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    scroll-padding: 1rem;
    overscroll-behavior-inline: contain;
    border: 1px solid #e7e5e4;
    border-radius: 20px;
    background: #fff;
  }
  .rail:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  .slide { flex: 0 0 260px; margin: 0; scroll-snap-align: start; }
  .slide svg { display: block; width: 100%; aspect-ratio: 13 / 9; border-radius: 12px; }
  figcaption { margin-top: 0.6rem; color: #57534e; font-size: 0.85rem; }
</style>
```

`scroll-snap-type: x mandatory` tells the container to always settle on a snap point after scrolling. `mandatory` is confident, but it can trap a user between two tall panels; `proximity` is gentler. `scroll-snap-align: start` aligns the child''s start edge with the container''s snap area. `scroll-padding` keeps the first and last cards from touching the edge.

> **Tip:** A scrollable region should be reachable by keyboard. `tabindex="0"` on the container, plus a visible `:focus-visible` ring, makes the gallery usable without a mouse. Do not remove the scrollbar without providing another affordance.

## Challenge: a nested card component

Build the card from the first example, but write the child rules *inside* `.card` with `&`. The tests check the rendered result and that the stylesheet actually uses nesting.

```html exercise id=nested-field-card title="Build a nested card component"
<article class="card">
  <p class="tag">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p class="intro">Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; }
  /* TODO: style .card, then nest .tag, h2, p and .cta with & */
</style>
--- solution
<article class="card">
  <p class="tag">Field note</p>
  <h2>A quieter kind of grid</h2>
  <p class="intro">Fewer borders, more space, and a column that knows when to stop growing.</p>
  <a class="cta" href="#">Read the note</a>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f4f1ea; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card {
    max-width: 34rem;
    padding: 24px;
    border: 1px solid #d6d3d1;
    border-radius: 16px;
    background: #fffdf8;
    & .tag { margin: 0 0 8px; color: #b45309; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
    & h2 { margin: 0 0 8px; font-size: 24px; line-height: 1.2; }
    & p { margin: 0 0 16px; color: #57534e; line-height: 1.6; }
    & .cta { color: #0f766e; font-weight: 600; text-decoration: none; }
    &:hover { border-color: #0f766e; }
  }
</style>
--- test
assertStyle(".card", "padding", "24px");
assertStyle(".card", "border-radius", "16px");
assertColor(".card", "background-color", "#fffdf8");
assertStyle(".card h2", "margin-top", "0px");
assertStyle(".card h2", "font-size", "24px");
assertColor(".card .intro", "color", "#57534e");
assertColor(".card .tag", "color", "#b45309");
assertStyle(".card .tag", "text-transform", "uppercase");
assertStyle(".card .cta", "text-decoration-line", "none");
const css = Array.from(document.querySelectorAll("style")).map((s) => s.textContent).join("\n");
assert(css.includes("&"), "Use native nesting: put the child rules inside .card and reference the parent with &");
--- hint
Start with `.card { padding: 24px; border-radius: 16px; background: #fffdf8; }` and then add child rules inside the same block.
--- hint
`& .tag`, `& h2`, `& p` and `& .cta` keep the selectors scoped to the card.
--- hint
The heading needs `margin: 0 0 8px` and a `font-size` of `24px`; the paragraph should compute to `#57534e`.
```

## `:has()` in a real component

You have met `:has()` as a selector. The useful pattern is a **state container**: the ancestor reacts to a control inside it, and the components update without JavaScript or a pile of sibling selectors. A filterable gallery is a natural fit.

```html run
<section class="catalog">
  <div class="filters" role="group" aria-label="Filter by tone">
    <label><input type="radio" name="tone" value="all" checked> All</label>
    <label><input type="radio" name="tone" value="warm" id="warm"> Warm</label>
    <label><input type="radio" name="tone" value="cool" id="cool"> Cool</label>
  </div>
  <div class="grid">
    <article class="tile" data-tone="warm"><h2>Clay</h2><p>Warm, matte, honest.</p></article>
    <article class="tile" data-tone="cool"><h2>Slate</h2><p>Cool, quiet, precise.</p></article>
    <article class="tile" data-tone="warm"><h2>Amber</h2><p>A little sunlight in a box.</p></article>
    <article class="tile" data-tone="cool"><h2>Pine</h2><p>Deep green with a blue edge.</p></article>
  </div>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .catalog { max-width: 52rem; margin: 0 auto; }
  .filters { display: flex; gap: 1rem; margin-bottom: 1rem; color: #475569; font-size: 0.9rem; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 0.75rem; }
  .tile { padding: 1rem; border: 1px solid #e2e8f0; border-radius: 14px; background: #fff; transition: opacity 160ms ease, filter 160ms ease; }
  .tile h2 { margin: 0 0 0.25rem; font-size: 1rem; }
  .tile p { margin: 0; color: #64748b; font-size: 0.85rem; }
  .catalog:has(#warm:checked) .tile:not([data-tone="warm"]) { opacity: 0.25; filter: grayscale(1); }
  .catalog:has(#cool:checked) .tile:not([data-tone="cool"]) { opacity: 0.25; filter: grayscale(1); }
  @media (prefers-reduced-motion: reduce) { .tile { transition: none; } }
</style>
```

The filter is a radio group, so it is keyboard-accessible by default. The CSS reads the checked state from the ancestor and dims the tiles that do not match. No hidden classes, no event listeners, no state to synchronize. The tradeoff is that the filter state is visual only: the dimmed tiles are still in the accessibility tree. If the filter were a real product feature, you would also update the result count in text and consider whether hiding versus dimming is the honest interaction.

> **In the wild:** `:has()` is often used for form validation (`form:has(input:invalid)`), card layouts that react to an image, and navigation that highlights a section. It is powerful precisely because it lets a parent respond to a child.

## `@supports`: enhance, do not require

`@supports` asks the browser whether it understands a declaration. The base style goes outside the query; the enhancement goes inside. That order is the whole technique. If the enhancement is the only definition, an unsupported browser gets nothing.

```html run
<p class="badge">Progressive enhancement</p>
<p class="badge badge--quiet">The base style always renders</p>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .badge {
    display: inline-block;
    margin: 0 0 0.75rem;
    padding: 0.45rem 0.8rem;
    border: 1px solid #cbd5e1;
    border-radius: 999px;
    background: #e2e8f0;
    color: #0f172a;
    font-size: 0.8rem;
    font-weight: 650;
  }
  .badge--quiet { background: #fff; color: #475569; }

  @supports (color: oklch(50% 0.1 200)) {
    .badge {
      border-color: oklch(85% 0.05 200);
      background: oklch(94% 0.035 200);
      color: oklch(30% 0.06 200);
    }
  }
</style>
```

`@supports` can test a property-value pair, a selector with `selector(:has(*))`, or a negation with `not`. It cannot test whether a feature is *good* or whether the user wants it. Use it for visual upgrades, not for core layout. A page whose navigation only works when `@supports (display: grid)` passes is a page that is broken for someone.

`@starting-style` and view transitions are in the same category: enhancements. `@starting-style` gives an element an initial style for its first rendered frame, which lets a dialog or popover animate in without JavaScript. Same-document view transitions can animate between states when the DOM changes; cross-document transitions are arriving in browsers but still need a fallback. Both should sit behind a feature query or a `@media (prefers-reduced-motion: no-preference)` guard.

> **Pitfall:** Do not put the base declaration inside `@supports not (...)`. It reads as defensive, but it inverts the logic: the fallback becomes the special case, and a browser that supports neither branch gets nothing.

## Challenge: build a snap gallery

The starter is a horizontal row with overflow. Add scroll snapping, padding, and a focus ring so the row works with touch and keyboard. The tests check the computed snap behavior and that the content is actually wider than the viewport.

```html exercise id=studio-snap-gallery title="Build a snap gallery"
<section class="gallery" tabindex="0" aria-label="Studio work">
  <figure class="slide"><span>01</span><figcaption>Ridge study</figcaption></figure>
  <figure class="slide"><span>02</span><figcaption>Studio wall</figcaption></figure>
  <figure class="slide"><span>03</span><figcaption>Blue hour</figcaption></figure>
  <figure class="slide"><span>04</span><figcaption>Two blocks</figcaption></figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .gallery { display: flex; gap: 16px; overflow-x: auto; padding: 16px; border: 1px solid #e7e5e4; border-radius: 20px; background: #fff; }
  .slide { display: grid; place-items: center; flex: 0 0 260px; height: 180px; margin: 0; border-radius: 14px; background: #e7e5e4; color: #57534e; }
  .slide span { font-size: 2rem; font-weight: 700; }
  figcaption { font-size: 0.8rem; }
</style>
--- solution
<section class="gallery" tabindex="0" aria-label="Studio work">
  <figure class="slide"><span>01</span><figcaption>Ridge study</figcaption></figure>
  <figure class="slide"><span>02</span><figcaption>Studio wall</figcaption></figure>
  <figure class="slide"><span>03</span><figcaption>Blue hour</figcaption></figure>
  <figure class="slide"><span>04</span><figcaption>Two blocks</figcaption></figure>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #fafaf9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .gallery {
    display: flex;
    gap: 16px;
    overflow-x: auto;
    padding: 16px;
    scroll-snap-type: x mandatory;
    scroll-padding: 16px;
    overscroll-behavior-inline: contain;
    border: 1px solid #e7e5e4;
    border-radius: 20px;
    background: #fff;
  }
  .gallery:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }
  .slide { display: grid; place-items: center; flex: 0 0 260px; height: 180px; margin: 0; scroll-snap-align: start; border-radius: 14px; background: #e7e5e4; color: #57534e; }
  .slide span { font-size: 2rem; font-weight: 700; }
  figcaption { font-size: 0.8rem; }
</style>
--- test
const gallery = query(".gallery");
assertStyle(".gallery", "display", "flex");
assertStyle(".gallery", "scroll-snap-type", "x mandatory");
assertStyle(".gallery", "overflow-x", "auto");
assertCount(".gallery .slide", 4, "Keep all four slides in the gallery");
assertFocusable(".gallery", "The scroll container should be reachable with the Tab key");
const slides = Array.from(document.querySelectorAll(".gallery .slide"));
slides.forEach((slide) => {
  const align = getComputedStyle(slide).scrollSnapAlign;
  assert(align === "start" || align === "center" || align === "end", `Each slide needs a scroll-snap-align; one computes to ${align}`);
});
assert(gallery.scrollWidth > gallery.clientWidth, "The gallery should actually overflow horizontally so there is something to snap through");
--- hint
Put `scroll-snap-type: x mandatory` on `.gallery`, and `scroll-snap-align: start` on each `.slide`.
--- hint
`scroll-padding` keeps the first card away from the edge. `overscroll-behavior-inline: contain` stops the scroll from chaining to the page.
--- hint
Keep `tabindex="0"` on the gallery and add `.gallery:focus-visible { outline: 3px solid #0f766e; outline-offset: 3px; }`.
```

## Debug: the nested selector that went too far

This card contains an intro paragraph and a nested pull quote. The quote is supposed to stay muted and italic, but the card''s `& p` rule reaches inside it and makes the quote text dark. Fix the nesting so the intro is dark and the quote keeps its own style.

```html debug id=nested-quote-scope title="The nested selector that went too far"
<article class="card">
  <h2>Field notes from the ridge</h2>
  <p class="intro">The weather turned at lunch, as it always does on this side of the valley.</p>
  <blockquote class="quote">
    <p>We ate sandwiches under a rock and pretended this was the plan.</p>
  </blockquote>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; color: #64748b; font-family: ui-sans-serif, system-ui, sans-serif; }
  .quote { margin: 0; padding-left: 1rem; border-left: 3px solid #cbd5e1; }
  .quote p { color: #64748b; font-style: italic; }
  .card {
    max-width: 36rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    & h2 { margin: 0 0 8px; font-size: 24px; color: #0f172a; }
    & p { margin: 0; color: #0f172a; line-height: 1.6; }
  }
</style>
--- solution
<article class="card">
  <h2>Field notes from the ridge</h2>
  <p class="intro">The weather turned at lunch, as it always does on this side of the valley.</p>
  <blockquote class="quote">
    <p>We ate sandwiches under a rock and pretended this was the plan.</p>
  </blockquote>
</article>

<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; color: #64748b; font-family: ui-sans-serif, system-ui, sans-serif; }
  .quote { margin: 0; padding-left: 1rem; border-left: 3px solid #cbd5e1; }
  .quote p { color: #64748b; font-style: italic; }
  .card {
    max-width: 36rem;
    padding: 24px;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    background: #fff;
    & h2 { margin: 0 0 8px; font-size: 24px; color: #0f172a; }
    & > p { margin: 0; color: #0f172a; line-height: 1.6; }
  }
</style>
--- test
assertColor(".card > .intro", "color", "#0f172a");
assertColor(".quote p", "color", "#64748b");
assertStyle(".quote p", "font-style", "italic");
assertStyle(".card", "padding", "24px");
assertStyle(".card", "border-radius", "16px");
--- hint
`& p` means "any paragraph inside the card," including paragraphs inside a nested component.
--- hint
You want only the card''s own intro paragraph. Use the child combinator: `& > p`.
--- hint
Keep the quote rule outside `.card`; it should win for the quote because it is more specific to that component.
```

## Predict: what does color-mix produce?

```html predict id=color-mix-chip title="What color is the chip?"
<p class="chip">Seasonal</p>
<style>
  body { margin: 0; padding: 2rem; background: #f8fafc; font-family: ui-sans-serif, system-ui, sans-serif; }
  .chip {
    display: inline-block;
    padding: 0.5rem 0.9rem;
    border-radius: 999px;
    background: color-mix(in srgb, #f59e0b 55%, #ffffff);
    color: #431407;
    font-weight: 650;
  }
</style>
--- options
* A pale amber, lighter than the original
A saturated orange, darker than the original
Pure white
A dark brown
--- explain
`color-mix(in srgb, #f59e0b 55%, #ffffff)` mixes 55% amber with 45% white in the sRGB color space. Adding white raises all three channels, so the result is a tint: a pale amber. Mixing in `oklab` would produce a different, more perceptually even tint, but it would still be lighter. The percentage is the share of the first color, not the amount of white.
```

## Recap

- Native nesting keeps a component''s rules together; `&` refers to the parent, and omitted `&` still means "inside this parent."
- Nesting does not make a selector local: `& p` reaches nested components, so use `& > p` or a class when the scope matters.
- `oklch()` gives perceptual lightness; relative color syntax derives tints and shades from one brand token.
- `color-mix()` blends two colors in a chosen space; keep a fallback declaration before it.
- `aspect-ratio` reserves a media box; scroll snap makes a horizontal rail usable without a carousel library.
- `:has()` lets a container react to a child''s state, which is ideal for filters, forms and layout variants.
- `@supports` is for enhancements. The baseline belongs outside the query.
- `@starting-style` and view transitions are polish, not prerequisites. Guard them and respect reduced motion.

**Up next:** the first capstone. You will turn these primitives into a complete analytics dashboard: an app shell, accessible navigation, stat cards, a CSS-only chart and a data table that survives a narrow screen.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_5_2', 'sec_html_css_advanced_5', 'crs_html_css_advanced', 'Project: a responsive analytics dashboard', 'interactive', 1, 2640, NULL, NULL, 'A dashboard is a layout system under pressure. The labels change length, the numbers grow, the table has more columns than you planned, and someone opens it on a 13-inch laptop with the sidebar pinned. A page that only looks right with the sample data is not a dashboard; it is a screenshot.

This capstone builds one complete page: an app shell, accessible navigation, four stat cards with trends, a CSS-only bar chart, a data table, and a recent activity list. Everything is HTML and CSS. No chart library, no script, no layout that collapses the moment the content disagrees with it.

## Start with regions, not rectangles

Before a single color, decide what the page *is*. A dashboard has a navigation region, a top bar, a main region, and within main, a summary, a chart, a table and an activity feed. Those are landmarks and sections, not divs with vibes. The app shell then places them with Grid.

The shell uses named areas because the layout has a clear topology: the sidebar spans both rows, the top bar sits above main, and main takes the rest. `minmax(0, 1fr)` is doing quiet but essential work. A bare `1fr` has an automatic minimum of `min-content`, so a wide table can force the main column wider than the viewport. `minmax(0, 1fr)` lets the column shrink and hands overflow control to the component that needs it.

```html run
<a class="skip-link" href="#main">Skip to content</a>
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#" aria-current="page">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <label class="search"><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label>
    <button class="user" type="button">AM · Avery Moss</button>
  </header>
  <main class="main" id="main" tabindex="-1">
    <h1>Overview</h1>
  </main>
</div>

<style>
  :root { --ink: #0f172a; --muted: #64748b; --line: #e2e8f0; --bg: #f1f5f9; }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--bg); color: var(--ink); font-family: ui-sans-serif, system-ui, sans-serif; }
  .skip-link { position: absolute; left: -9999px; top: 8px; padding: 10px 14px; background: #fff; border-radius: 8px; } .skip-link:focus { left: 8px; z-index: 5; }
  .app { display: grid; grid-template-columns: 240px minmax(0, 1fr); grid-template-rows: auto 1fr; grid-template-areas: "sidebar topbar" "sidebar main"; min-height: 100vh; }
  .sidebar { grid-area: sidebar; display: flex; flex-direction: column; gap: 28px; padding: 24px 20px; background: #0f172a; color: #e2e8f0; }
  .brand { color: #fff; font-weight: 750; letter-spacing: -0.02em; text-decoration: none; }
  .sidebar nav { display: grid; gap: 6px; }
  .sidebar nav a { padding: 8px 10px; border-radius: 8px; color: #cbd5e1; text-decoration: none; font-size: 0.9rem; }
  .sidebar nav a[aria-current="page"] { background: #1e293b; color: #fff; }
  .topbar { grid-area: topbar; display: flex; align-items: center; justify-content: space-between; gap: 16px; padding: 14px 24px; background: #fff; border-bottom: 1px solid var(--line); }
  .search input { width: min(360px, 42vw); min-height: 40px; padding: 0 12px; border: 1px solid var(--line); border-radius: 10px; background: #f8fafc; }
  .user { padding: 8px 12px; border: 1px solid var(--line); border-radius: 999px; background: #fff; font-weight: 600; }
  .main { grid-area: main; min-width: 0; padding: 32px; }
  h1 { margin: 0; font-size: 2rem; letter-spacing: -0.03em; }
  :focus-visible { outline: 3px solid #a5b4fc; outline-offset: 2px; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
  @media (max-width: 820px) { .app { grid-template-columns: 1fr; grid-template-areas: "topbar" "sidebar" "main"; } }
</style>
```

Two accessibility decisions are structural, not decorative. The skip link is the first focusable thing on the page, and it targets `<main id="main" tabindex="-1">`, so keyboard users can bypass the navigation. The current navigation item uses `aria-current="page"` instead of a `.active` class, so the state is announced, not just colored. The search input has a real `<label>`; a placeholder is not a name.

> **Tip:** `aria-current="page"` is for the link that represents the current page. Use `aria-current="step"` for a step in a process, or `aria-current="location"` for a location in a navigation tree. Do not use color as the only signal.

## Stat cards: numbers with context

A stat card is a small composition: a label, a value, and a comparison. The label is a heading because it names the metric. The value is emphasized text, not a heading, because it is data. The trend is the part most dashboards get wrong: a green arrow and a red arrow are invisible to a person who cannot distinguish those colors, and a bare percentage does not say whether it is good or bad.

Use a `data-trend` attribute for styling, but include an arrow and a text alternative in the markup. The arrow gives a shape cue; the screen-reader text gives the direction in words. "Up 12.4%" is a fact. "Good" is an interpretation, and it depends on the metric: rising churn is not a win.

```html run
<section class="stats" aria-label="Key metrics">
  <article class="stat">
    <h3>Revenue</h3>
    <p class="stat-value">$48,290</p>
    <p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4% <span class="sr-only">increase from last month</span></p>
  </article>
  <article class="stat">
    <h3>Active accounts</h3>
    <p class="stat-value">2,184</p>
    <p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1% <span class="sr-only">increase from last month</span></p>
  </article>
  <article class="stat">
    <h3>Conversion</h3>
    <p class="stat-value">3.8%</p>
    <p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0% <span class="sr-only">unchanged from last month</span></p>
  </article>
  <article class="stat">
    <h3>Churn</h3>
    <p class="stat-value">1.2%</p>
    <p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3% <span class="sr-only">decrease from last month</span></p>
  </article>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat h3 { margin: 0; color: #64748b; font-size: 0.72rem; font-weight: 650; letter-spacing: 0.08em; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 1.9rem; font-weight: 750; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
  .trend { display: inline-flex; align-items: center; gap: 6px; margin: 0; padding: 3px 8px; border-radius: 999px; font-size: 0.78rem; font-weight: 650; }
  .trend[data-trend="up"] { color: #047857; background: #ecfdf5; }
  .trend[data-trend="down"] { color: #b91c1c; background: #fef2f2; }
  .trend[data-trend="flat"] { color: #475569; background: #f1f5f9; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
</style>
```

`font-variant-numeric: tabular-nums` keeps columns of figures aligned, which matters the moment values sit in a table or a row of cards. The trend pill is allowed to be colored because it is not the only signal: the arrow and the hidden sentence carry the same information.

> **Pitfall:** "Down" is not always bad. Churn going down is excellent; refunds going down might be excellent or suspicious. Keep the interpretation in the product copy, not in a hard-coded green/red rule.

## A chart without JavaScript

A bar chart is a set of rectangles with heights. You do not need a chart library to draw rectangles. The CSS-only version uses one flex row, one custom property per bar, and `height: calc(var(--value) * 1%)`. The value drives the geometry; the label sits above the bar; the axis is a separate row so the bars stay aligned.

Accessibility is the part a library usually handles for you. If the chart is made of divs, give the whole figure `role="img"` and a label that summarizes the trend. Keep the visible values in the bars, and keep the axis readable. If exact values matter, the table below the chart is the real source of truth; the chart is a visual summary.

```html run
<figure class="panel chart-panel">
  <figcaption>
    <h2>Revenue by week</h2>
    <p>Last 6 weeks · USD</p>
  </figcaption>
  <div class="chart" role="img" aria-label="Bar chart: weekly revenue rises from 24,000 to 49,000 dollars over six weeks">
    <div class="bar" style="--value: 49"><span>$24k</span></div>
    <div class="bar" style="--value: 63"><span>$31k</span></div>
    <div class="bar" style="--value: 57"><span>$28k</span></div>
    <div class="bar" style="--value: 80"><span>$39k</span></div>
    <div class="bar" style="--value: 90"><span>$44k</span></div>
    <div class="bar" style="--value: 100"><span>$49k</span></div>
  </div>
  <div class="axis" aria-hidden="true"><span>W1</span><span>W2</span><span>W3</span><span>W4</span><span>W5</span><span>W6</span></div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 720px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .chart-panel figcaption { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; margin-bottom: 18px; }
  .chart-panel h2 { margin: 0; font-size: 1.1rem; }
  .chart-panel p { margin: 0; color: #64748b; font-size: 0.8rem; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; padding-top: 28px; border-bottom: 1px solid #e2e8f0; }
  .bar { position: relative; flex: 1; height: calc(var(--value) * 1%); background: linear-gradient(180deg, #818cf8, #4f46e5); border-radius: 8px 8px 2px 2px; }
  .bar span { position: absolute; bottom: 100%; left: 0; right: 0; margin-bottom: 6px; text-align: center; color: #64748b; font-size: 0.7rem; }
  .axis { display: flex; gap: 8px; margin-top: 8px; }
  .axis span { flex: 1; text-align: center; color: #94a3b8; font-size: 0.7rem; }
</style>
```

The chart is honest about what it is: a picture of a trend, not a precision instrument. The `aria-label` names the direction and the endpoints. The visible labels give the rough values. The table in the next section gives the exact numbers, with headers that a screen reader can associate with each cell.

> **Under the hood:** `height: calc(var(--value) * 1%)` resolves against the chart''s content box because the chart has a definite height. If the chart height were `auto`, the percentage would have nothing to resolve against and the bars would collapse.

## A table that can scroll

Tables are not old-fashioned. A table is the correct element when the data has rows and columns, and a dashboard without one is usually hiding the real numbers behind cards. The essentials are a `<caption>`, `<th scope="col">` for column headers, `<th scope="row">` for row headers, and a wrapper that allows horizontal scrolling on narrow screens.

The wrapper is where most table layouts break. If the table has `min-width: 560px` and its parent is a grid column with the default `min-width: auto`, the column refuses to shrink and the whole page scrolls sideways. Put `overflow-x: auto` on the wrapper and `min-width: 0` on the grid child. The table can then be wider than the phone without dragging the page with it.

```html run
<section class="panel">
  <h2>Top campaigns</h2>
  <div class="table-wrap">
    <table>
      <caption>Top campaigns by revenue, last 30 days</caption>
      <thead>
        <tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr>
      </thead>
      <tbody>
        <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
        <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
        <tr><th scope="row">Trail pass</th><td>Paid social</td><td>$6,800</td><td>$11,300</td></tr>
      </tbody>
    </table>
  </div>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 760px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .panel h2 { margin: 0 0 16px; font-size: 1.1rem; }
  .table-wrap { overflow-x: auto; }
  table { width: 100%; min-width: 560px; border-collapse: collapse; font-size: 0.9rem; }
  caption { padding-bottom: 12px; text-align: left; color: #64748b; font-size: 0.8rem; }
  th, td { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; text-align: left; }
  thead th { color: #64748b; font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; }
  tbody th { font-weight: 600; }
  td:last-child { font-variant-numeric: tabular-nums; }
</style>
```

On a wide screen the table fills its panel. On a narrow screen the wrapper scrolls, the caption stays with the table, and the page itself does not move. That is the correct tradeoff: a table is allowed to scroll inside its own region; the page is not.

## Recent activity: time is data

An activity feed is a list of events. Use an ordered or unordered list, a `<time datetime="...">` element, and a short text description. The avatar is decorative if the person''s name is already in the text; mark it `aria-hidden="true"` so a screen reader does not announce a meaningless pair of initials.

```html run
<section class="panel">
  <h2>Recent activity</h2>
  <ul class="activity">
    <li><span class="avatar" aria-hidden="true">JL</span><p><strong>Jordan Lee</strong> exported the Q3 report <time datetime="2026-10-23T09:42">Today, 09:42</time></p></li>
    <li><span class="avatar" aria-hidden="true">SK</span><p><strong>Samira Khan</strong> changed the revenue target <time datetime="2026-10-22T16:08">Yesterday, 16:08</time></p></li>
    <li><span class="avatar" aria-hidden="true">AM</span><p><strong>Avery Moss</strong> invited two analysts <time datetime="2026-10-22T11:15">Yesterday, 11:15</time></p></li>
  </ul>
</section>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { max-width: 640px; padding: 24px; background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; }
  .panel h2 { margin: 0 0 16px; font-size: 1.1rem; }
  .activity { display: grid; gap: 14px; margin: 0; padding: 0; list-style: none; }
  .activity li { display: flex; align-items: flex-start; gap: 10px; }
  .avatar { display: grid; place-items: center; width: 32px; height: 32px; flex: none; border-radius: 50%; background: #e0e7ff; color: #3730a3; font-size: 0.7rem; font-weight: 700; }
  .activity p { margin: 0; color: #475569; font-size: 0.9rem; line-height: 1.5; }
  .activity strong { color: #0f172a; }
  time { color: #94a3b8; font-size: 0.78rem; white-space: nowrap; }
</style>
```

The `datetime` attribute gives machines a precise timestamp while the visible text stays human. "Yesterday" is friendly; `2026-10-22T16:08` is unambiguous across time zones, locales and future readers.

## Challenge: build the app shell

The starter has the right regions but no layout system, no skip link and no current-page state. Turn it into a two-column Grid shell at 1100 px, give the search input a real name, and make the navigation state accessible.

```html exercise id=dashboard-app-shell title="Build the app shell"
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <input type="search" placeholder="Search metrics">
    <button class="user" type="button">Avery Moss</button>
  </header>
  <main class="main">
    <h1>Overview</h1>
  </main>
</div>

<style>
  body { margin: 0; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .app { padding: 20px; }
  .sidebar { padding: 20px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 8px; margin-top: 20px; }
  .sidebar a { color: #cbd5e1; }
  .topbar { display: flex; gap: 12px; padding: 16px; background: #fff; }
  .main { padding: 24px; }
</style>
--- solution
<a class="skip-link" href="#main">Skip to content</a>
<div class="app">
  <aside class="sidebar">
    <a class="brand" href="#">Nimbus</a>
    <nav aria-label="Primary">
      <a href="#" aria-current="page">Overview</a>
      <a href="#">Reports</a>
      <a href="#">Customers</a>
      <a href="#">Settings</a>
    </nav>
  </aside>
  <header class="topbar">
    <label class="search"><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label>
    <button class="user" type="button">Avery Moss</button>
  </header>
  <main class="main" id="main" tabindex="-1">
    <h1>Overview</h1>
  </main>
</div>

<style>
  body { margin: 0; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .app { display: grid; grid-template-columns: 240px minmax(0, 1fr); grid-template-rows: auto 1fr; grid-template-areas: "sidebar topbar" "sidebar main"; min-height: 100vh; }
  .sidebar { grid-area: sidebar; padding: 20px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 8px; margin-top: 20px; }
  .sidebar a { color: #cbd5e1; text-decoration: none; }
  .sidebar a[aria-current="page"] { color: #fff; font-weight: 700; }
  .topbar { grid-area: topbar; display: flex; align-items: center; gap: 12px; padding: 16px; background: #fff; border-bottom: 1px solid #e2e8f0; }
  .main { grid-area: main; min-width: 0; padding: 24px; }
  .skip-link { position: absolute; left: -9999px; top: 8px; padding: 10px 14px; background: #fff; border-radius: 8px; } .skip-link:focus { left: 8px; z-index: 5; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
  :focus-visible { outline: 3px solid #a5b4fc; outline-offset: 2px; }
</style>
--- test
assertStyle(".app", "display", "grid");
const tracks = getComputedStyle(query(".app")).gridTemplateColumns.split(" ").filter(Boolean);
assert(tracks.length === 2, `At 1100px the app shell should have two columns (sidebar and main); found ${tracks.length}.`);
assertExists("a.skip-link[href=''#main'']", "Add a skip link that targets the main region");
assertExists("#main", "Give the main region id=''main''");
assertAttr("nav a[aria-current=''page'']", "aria-current", "page");
assertCount("nav a[aria-current=''page'']", 1, "Exactly one navigation link should be the current page");
assertExists(".topbar input[type=''search'']", "Keep the search input in the top bar");
const input = query(".topbar input[type=''search'']");
assert((input.labels && input.labels.length > 0) || input.getAttribute("aria-label"), "Give the search input an accessible name with a label or aria-label");
assertStyle(".topbar", "display", "flex");
assertFocusable("a.skip-link");
assertNoOverflow("The dashboard should not scroll sideways at 1100px.");
--- hint
Use `display: grid` on `.app` with `grid-template-columns: 240px minmax(0, 1fr)` and named areas for the sidebar, top bar and main.
--- hint
Put `<a class="skip-link" href="#main">` before the shell, add `id="main"` to `<main>`, and put `aria-current="page"` on Overview.
--- hint
Wrap the search input in a `<label>` with visually hidden text, or give it an `aria-label`. The top bar should compute to `display: flex`.
```

## Challenge: stat cards and a chart

Build four stat cards and a six-bar chart. Each card needs a heading, a value and a trend that does not rely on color alone. Each bar gets its height from a custom property. The tests check the structure, the accessible trend text and that the bars actually differ in height.

```html exercise id=dashboard-stats-chart title="Build the stat cards and chart"
<section class="stats">
  <article class="stat"><h3>Revenue</h3><p class="stat-value">$48,290</p></article>
  <article class="stat"><h3>Active accounts</h3><p class="stat-value">2,184</p></article>
</section>
<figure class="chart-panel">
  <figcaption>Revenue by week</figcaption>
  <div class="chart">
    <div class="bar" style="--value: 60"></div>
    <div class="bar" style="--value: 60"></div>
    <div class="bar" style="--value: 60"></div>
  </div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat, .chart-panel { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat h3 { margin: 0; color: #64748b; font-size: 12px; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 30px; font-weight: 700; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; max-width: 600px; }
  .bar { flex: 1; height: calc(var(--value) * 1%); background: #4f46e5; border-radius: 6px 6px 0 0; }
</style>
--- solution
<section class="stats" aria-label="Key metrics">
  <article class="stat"><h3>Revenue</h3><p class="stat-value">$48,290</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4% <span class="sr-only">increase from last month</span></p></article>
  <article class="stat"><h3>Active accounts</h3><p class="stat-value">2,184</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1% <span class="sr-only">increase from last month</span></p></article>
  <article class="stat"><h3>Conversion</h3><p class="stat-value">3.8%</p><p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0% <span class="sr-only">unchanged from last month</span></p></article>
  <article class="stat"><h3>Churn</h3><p class="stat-value">1.2%</p><p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3% <span class="sr-only">decrease from last month</span></p></article>
</section>
<figure class="chart-panel">
  <figcaption><h2>Revenue by week</h2></figcaption>
  <div class="chart" role="img" aria-label="Weekly revenue rises from 24,000 to 49,000 dollars over six weeks">
    <div class="bar" style="--value: 49"><span>$24k</span></div>
    <div class="bar" style="--value: 63"><span>$31k</span></div>
    <div class="bar" style="--value: 57"><span>$28k</span></div>
    <div class="bar" style="--value: 80"><span>$39k</span></div>
    <div class="bar" style="--value: 90"><span>$44k</span></div>
    <div class="bar" style="--value: 100"><span>$49k</span></div>
  </div>
</figure>

<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; color: #0f172a; font-family: ui-sans-serif, system-ui, sans-serif; }
  .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 16px; max-width: 1000px; }
  .stat, .chart-panel { padding: 20px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .stat { min-width: 0; }
  .stat h3 { margin: 0; color: #64748b; font-size: 12px; text-transform: uppercase; }
  .stat-value { margin: 8px 0; font-size: 30px; font-weight: 700; font-variant-numeric: tabular-nums; }
  .trend { display: inline-flex; gap: 6px; margin: 0; padding: 3px 8px; border-radius: 999px; font-size: 12px; font-weight: 650; }
  .trend[data-trend="up"] { color: #047857; background: #ecfdf5; }
  .trend[data-trend="down"] { color: #b91c1c; background: #fef2f2; }
  .trend[data-trend="flat"] { color: #475569; background: #f1f5f9; }
  .chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; max-width: 600px; padding-top: 24px; }
  .bar { position: relative; flex: 1; height: calc(var(--value) * 1%); background: #4f46e5; border-radius: 6px 6px 0 0; }
  .bar span { position: absolute; bottom: 100%; left: 0; right: 0; margin-bottom: 6px; text-align: center; color: #64748b; font-size: 11px; }
  .chart-panel { margin-top: 16px; }
  .chart-panel h2 { margin: 0; font-size: 18px; }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
</style>
--- test
assertCount(".stats .stat", 4, "The dashboard needs four stat cards");
Array.from(document.querySelectorAll(".stat")).forEach((card, index) => {
  const name = card.querySelector("h3");
  const value = card.querySelector(".stat-value");
  const trend = card.querySelector(".trend");
  assert(name, `Stat card ${index + 1} needs a heading that names the metric`);
  assert(value, `Stat card ${index + 1} needs a .stat-value`);
  assert(trend, `Stat card ${index + 1} needs a .trend`);
  assert(trend.getAttribute("data-trend"), `Stat card ${index + 1} needs a data-trend state`);
  assert(/[↑↓→]/.test(trend.textContent), `Stat card ${index + 1} needs an arrow or shape cue, not color alone`);
  assert(/increase|decrease|unchanged/i.test(trend.textContent), `Stat card ${index + 1} needs a text alternative such as "increase from last month"`);
});
assertCount(".chart .bar", 6, "The chart needs six weekly bars");
assertAttr(".chart", "role", "img");
assert((query(".chart").getAttribute("aria-label") || "").length > 20, "Give the chart an aria-label that summarizes the trend");
const heights = Array.from(document.querySelectorAll(".chart .bar")).map((bar) => Math.round(bar.getBoundingClientRect().height));
assert(new Set(heights).size >= 3, `The bars should encode different values; the heights found were ${heights.join(", ")}.`);
--- hint
Use an `<article class="stat">` with an `<h3>`, a `.stat-value`, and a `.trend` carrying `data-trend="up|down|flat"`.
--- hint
Include an arrow (`↑`, `↓` or `→`) and a visually hidden phrase such as "increase from last month" inside each trend.
--- hint
Set `--value` on each bar and use `height: calc(var(--value) * 1%)`; the chart needs a definite height for that percentage to resolve.
```

## Debug: the dashboard that overflows at 380px

This preview is a 380 px container standing in for a narrow phone. The app shell has a fixed 220 px sidebar and a 560 px table, so the frame scrolls sideways and the table drags the whole layout with it. The shell should collapse to one column at this container width, and the table should scroll inside its own wrapper. Fix both without changing the table''s minimum width.

```html debug id=dashboard-narrow-overflow title="The dashboard that overflows at 380px"
<div class="frame">
  <div class="app">
    <aside class="sidebar">
      <strong>Nimbus</strong>
      <nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a></nav>
    </aside>
    <main class="main">
      <h1>Overview</h1>
      <div class="table-wrap">
        <table>
          <caption>Top campaigns</caption>
          <thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead>
          <tbody>
            <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
            <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</div>

<style>
  body { margin: 0; padding: 20px; background: #e2e8f0; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .frame { width: 380px; margin: 0 auto; background: #f1f5f9; border: 1px solid #cbd5e1; }
  .app { display: grid; grid-template-columns: 220px minmax(560px, 1fr); min-height: 520px; }
  .sidebar { padding: 16px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 6px; margin-top: 12px; }
  .sidebar a { color: #cbd5e1; font-size: 13px; }
  .main { min-width: 0; padding: 16px; }
  h1 { margin: 0 0 12px; font-size: 22px; }
  .table-wrap { }
  table { width: 100%; min-width: 560px; border-collapse: collapse; background: #fff; }
  th, td { padding: 8px; border-bottom: 1px solid #e2e8f0; text-align: left; font-size: 12px; }
</style>
--- solution
<div class="frame">
  <div class="app">
    <aside class="sidebar">
      <strong>Nimbus</strong>
      <nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a></nav>
    </aside>
    <main class="main">
      <h1>Overview</h1>
      <div class="table-wrap">
        <table>
          <caption>Top campaigns</caption>
          <thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead>
          <tbody>
            <tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr>
            <tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</div>

<style>
  body { margin: 0; padding: 20px; background: #e2e8f0; font-family: ui-sans-serif, system-ui, sans-serif; color: #0f172a; }
  .frame { width: 380px; margin: 0 auto; background: #f1f5f9; border: 1px solid #cbd5e1; container-type: inline-size; }
  .app { display: grid; grid-template-columns: 220px minmax(560px, 1fr); min-height: 520px; }
  .sidebar { padding: 16px; background: #0f172a; color: #e2e8f0; }
  .sidebar nav { display: grid; gap: 6px; margin-top: 12px; }
  .sidebar a { color: #cbd5e1; font-size: 13px; }
  .main { min-width: 0; padding: 16px; }
  h1 { margin: 0 0 12px; font-size: 22px; }
  .table-wrap { overflow-x: auto; }
  table { width: 100%; min-width: 560px; border-collapse: collapse; background: #fff; }
  th, td { padding: 8px; border-bottom: 1px solid #e2e8f0; text-align: left; font-size: 12px; }
  @container (max-width: 620px) {
    .app { grid-template-columns: 1fr; }
    .sidebar { display: flex; align-items: center; gap: 16px; }
    .sidebar nav { grid-auto-flow: column; margin-top: 0; }
  }
</style>
--- test
const frame = query(".frame");
assert(frame.scrollWidth <= frame.clientWidth + 1, `The 380px frame overflows: ${frame.scrollWidth}px of content in ${frame.clientWidth}px. Collapse the shell and contain the table.`);
assertStyle(".table-wrap", "overflow-x", "auto");
const tracks = getComputedStyle(query(".app")).gridTemplateColumns.split(" ").filter(Boolean);
assert(tracks.length === 1, `At this container width the app shell should have one column; found ${tracks.length}.`);
assertExists("table caption", "Keep the table''s caption");
assertCount("th[scope=''col'']", 4, "All four column headers need scope=''col''");
assertCount("th[scope=''row'']", 2, "Each row header needs scope=''row''");
assertNoOverflow("The page should not scroll sideways at 1100px.");
--- hint
The frame is 380px wide, but the viewport is 1100px. A media query will not see the frame''s width; make `.frame` a container and use `@container`.
--- hint
Add `container-type: inline-size` to `.frame`, then inside `@container (max-width: 620px)` set `.app { grid-template-columns: 1fr; }`.
--- hint
The table can stay 560px wide if `.table-wrap { overflow-x: auto; }` contains it. The shell needs one column; the table needs its own scrollbar.
```

## Predict: which layout wins?

```html predict id=dashboard-container-query title="One column or two?"
<section class="panel">
  <div class="grid">
    <article>One</article>
    <article>Two</article>
    <article>Three</article>
    <article>Four</article>
  </div>
</section>
<style>
  body { margin: 0; padding: 2rem; background: #f1f5f9; font-family: ui-sans-serif, system-ui, sans-serif; }
  .panel { width: 420px; container-type: inline-size; padding: 16px; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; }
  .grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
  .grid article { padding: 16px; background: #eef2ff; border-radius: 10px; }
  @container (max-width: 600px) { .grid { grid-template-columns: 1fr; } }
</style>
--- options
* One column, because the panel is 420px wide
Two columns, because the viewport is 1100px
Three columns, because the gallery is inside a grid
The cards disappear because no media query matches
--- explain
`@container` queries the nearest container, not the viewport. The panel declares `container-type: inline-size` and is 420px wide, so the `max-width: 600px` condition matches and the grid collapses to one column — even though the browser window is 1100px wide. A media query here would see 1100px and keep two columns, which is the bug container queries were designed to fix.
```

## Putting it together

The complete page combines the shell, the cards, the chart, the table and the activity list. Notice what is *not* there: no absolute positioning for the layout, no fixed heights on the main region, no JavaScript, and no color-only state. The responsive rule collapses the shell at 820px, the stat grid reflows on its own, and the table keeps its own overflow.

```html run
<a class="skip" href="#main">Skip to content</a>
<div class="app">
  <aside class="side"><strong>Nimbus</strong><nav aria-label="Primary"><a href="#" aria-current="page">Overview</a><a href="#">Reports</a><a href="#">Customers</a><a href="#">Settings</a></nav></aside>
  <header class="top"><label><span class="sr-only">Search</span><input type="search" placeholder="Search metrics"></label><button class="user" type="button">Avery Moss</button></header>
  <main class="main" id="main">
    <h1>Overview</h1><p class="lede">Monday to today, across every active campaign.</p>
    <section class="stats" aria-label="Key metrics">
      <article class="stat"><h3>Revenue</h3><p class="value">$48,290</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 12.4%<span class="sr-only"> increase</span></p></article><article class="stat"><h3>Active accounts</h3><p class="value">2,184</p><p class="trend" data-trend="up"><span aria-hidden="true">↑</span> 4.1%<span class="sr-only"> increase</span></p></article><article class="stat"><h3>Conversion</h3><p class="value">3.8%</p><p class="trend" data-trend="flat"><span aria-hidden="true">→</span> 0.0%<span class="sr-only"> unchanged</span></p></article><article class="stat"><h3>Churn</h3><p class="value">1.2%</p><p class="trend" data-trend="down"><span aria-hidden="true">↓</span> 0.3%<span class="sr-only"> decrease</span></p></article>
    </section>
    <div class="lower">
      <figure class="panel"><figcaption><h2>Revenue by week</h2><p>Last 6 weeks · USD</p></figcaption>
        <div class="chart" role="img" aria-label="Weekly revenue rises from 24,000 to 49,000 dollars over six weeks"><div class="bar" style="--value:49"><span>$24k</span></div><div class="bar" style="--value:63"><span>$31k</span></div><div class="bar" style="--value:57"><span>$28k</span></div><div class="bar" style="--value:80"><span>$39k</span></div><div class="bar" style="--value:90"><span>$44k</span></div><div class="bar" style="--value:100"><span>$49k</span></div></div>
        <div class="axis" aria-hidden="true"><span>W1</span><span>W2</span><span>W3</span><span>W4</span><span>W5</span><span>W6</span></div>
      </figure>
      <section class="panel"><h2>Top campaigns</h2><div class="table-wrap"><table><caption>Top campaigns by revenue</caption><thead><tr><th scope="col">Campaign</th><th scope="col">Channel</th><th scope="col">Spend</th><th scope="col">Revenue</th></tr></thead><tbody><tr><th scope="row">Spring launch</th><td>Email</td><td>$4,200</td><td>$18,400</td></tr><tr><th scope="row">Field notes</th><td>Organic</td><td>$1,100</td><td>$12,850</td></tr><tr><th scope="row">Trail pass</th><td>Paid social</td><td>$6,800</td><td>$11,300</td></tr></tbody></table></div></section>
    </div>
    <section class="panel"><h2>Recent activity</h2><ul class="activity"><li><span class="avatar" aria-hidden="true">JL</span><p><strong>Jordan Lee</strong> exported the Q3 report <time datetime="2026-10-23T09:42">Today, 09:42</time></p></li><li><span class="avatar" aria-hidden="true">SK</span><p><strong>Samira Khan</strong> changed the revenue target <time datetime="2026-10-22T16:08">Yesterday, 16:08</time></p></li><li><span class="avatar" aria-hidden="true">AM</span><p><strong>Avery Moss</strong> invited two analysts <time datetime="2026-10-22T11:15">Yesterday, 11:15</time></p></li></ul></section>
  </main>
</div>

<style>
  :root { --ink:#0f172a; --muted:#64748b; --line:#e2e8f0; --bg:#f1f5f9; --brand:#4f46e5; }
  * { box-sizing: border-box; } body { margin:0; background:var(--bg); color:var(--ink); font-family:ui-sans-serif,system-ui,sans-serif; }
  .skip { position:absolute; left:-9999px; top:8px; padding:10px 14px; background:#fff; border-radius:8px; } .skip:focus { left:8px; z-index:5; }
  .app { display:grid; grid-template-columns:230px minmax(0,1fr); grid-template-rows:auto 1fr; grid-template-areas:"side top" "side main"; min-height:100vh; }
  .side { grid-area:side; display:flex; flex-direction:column; gap:24px; padding:22px 18px; background:#0f172a; color:#e2e8f0; } .side strong { color:#fff; }
  .side nav { display:grid; gap:6px; } .side a { padding:7px 9px; border-radius:8px; color:#cbd5e1; text-decoration:none; font-size:.86rem; } .side a[aria-current="page"] { background:#1e293b; color:#fff; }
  .top { grid-area:top; display:flex; align-items:center; justify-content:space-between; gap:16px; padding:14px 22px; background:#fff; border-bottom:1px solid var(--line); } .top input { min-height:38px; width:min(320px,40vw); padding:0 12px; border:1px solid var(--line); border-radius:10px; background:#f8fafc; } .user { padding:6px 10px; border:1px solid var(--line); border-radius:999px; background:#fff; font-weight:600; }
  .main { grid-area:main; min-width:0; padding:26px; } h1 { margin:0 0 4px; font-size:30px; letter-spacing:-.03em; } .lede { margin:0 0 22px; color:var(--muted); }
  .stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(170px,1fr)); gap:12px; } .stat,.panel { padding:16px; background:#fff; border:1px solid var(--line); border-radius:14px; }
  .stat h3 { margin:0; color:var(--muted); font-size:11px; letter-spacing:.08em; text-transform:uppercase; } .value { margin:6px 0; font-size:26px; font-weight:750; font-variant-numeric:tabular-nums; }
  .trend { display:inline-block; margin:0; padding:2px 7px; border-radius:999px; font-size:12px; font-weight:650; } .trend[data-trend="up"] { color:#047857; background:#ecfdf5; } .trend[data-trend="down"] { color:#b91c1c; background:#fef2f2; } .trend[data-trend="flat"] { color:#475569; background:#f1f5f9; }
  .lower { display:grid; grid-template-columns:1.3fr 1fr; gap:12px; margin:12px 0; } .chart { display:flex; align-items:flex-end; gap:7px; height:170px; padding-top:24px; border-bottom:1px solid var(--line); }
  .bar { position:relative; flex:1; height:calc(var(--value)*1%); background:linear-gradient(#818cf8,#4f46e5); border-radius:6px 6px 2px 2px; } .bar span { position:absolute; bottom:100%; left:0; right:0; text-align:center; font-size:10px; color:var(--muted); }
  .axis { display:flex; gap:7px; margin-top:6px; } .axis span { flex:1; text-align:center; font-size:10px; color:#94a3b8; }
  .table-wrap { overflow-x:auto; margin-top:8px; } table { width:100%; min-width:420px; border-collapse:collapse; font-size:12px; } th,td { padding:7px 6px; border-bottom:1px solid var(--line); text-align:left; } th { color:var(--muted); font-weight:600; }
  .activity { display:grid; gap:10px; margin:10px 0 0; padding:0; list-style:none; } .activity li { display:flex; align-items:flex-start; gap:8px; font-size:12px; } .activity p { margin:0; color:#475569; line-height:1.5; } .avatar { display:grid; place-items:center; width:28px; height:28px; flex:none; border-radius:50%; background:#e0e7ff; color:#3730a3; font-size:10px; font-weight:700; }
  :focus-visible { outline:3px solid #a5b4fc; outline-offset:2px; } .sr-only { position:absolute; width:1px; height:1px; overflow:hidden; clip-path:inset(50%); white-space:nowrap; }
  @media (max-width:820px) { .app { grid-template-columns:1fr; grid-template-areas:"top" "side" "main"; } .side { gap:16px; } .side nav { grid-auto-flow:column; overflow-x:auto; } .lower { grid-template-columns:1fr; } }
</style>
```

> **Tip:** At 1100 px the shell has two tracks. At 820 px it becomes one. The stat grid does not need a media query because `auto-fit` and `minmax` already respond to available width. Use the simplest mechanism that expresses the behavior.

## Recap

- Build the app shell from named Grid areas, and use `minmax(0, 1fr)` so a wide child cannot force the page wider.
- The skip link, `aria-current="page"` and a labelled search input are part of the layout, not an accessibility afterthought.
- Stat cards need a heading, a value and a trend with an arrow plus text, not color alone.
- A CSS-only chart is a row of proportional bars with a definite height and an `aria-label`; the table remains the exact source of data.
- Tables need a caption, `scope` on headers and an `overflow-x: auto` wrapper. `min-width: 0` on the grid child is what lets the wrapper do its job.
- Activity feeds use lists and `<time datetime>`; decorative avatars are hidden from assistive technology.
- Collapse the shell with a media query at a width the layout actually needs, and let the card grid reflow with `auto-fit`.
- Test at 1100 px for the desktop composition and at a narrow width for the collapsed one. A dashboard that only works at one width is unfinished.

**Up next:** the second capstone. You will extract this visual language into a reusable design system: tokens, themes, button variants, form states, cards, badges and a component gallery organized with `@layer`.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z'),
('les_html_css_advanced_5_3', 'sec_html_css_advanced_5', 'crs_html_css_advanced', 'Project: a reusable design system', 'interactive', 2, 2760, NULL, NULL, 'A design system is not a folder of components. It is a set of decisions that stay true when different people build different screens: what "surface" means, how much space a section gets, which blue is the action color, and what a disabled button looks like at 2am. The CSS is the enforcement mechanism; the contract is the point.

This capstone builds that contract. You will define tokens for color, spacing, radius, shadow and type, wire light and dark themes, build button variants and a form field with a real error state, compose a card and a badge, and arrange everything in a responsive gallery. The page is both the product and its documentation.

## Tokens: name the decision, not the value

A raw value like `#4f46e5` tells you nothing about where it is allowed. A token like `--color-brand` tells you the role. Start with a small set of **semantic** tokens: background, surface, text, muted text, border, brand, on-brand, danger, success. Components consume those names. If the brand changes, one token changes and every component follows.

There is a useful distinction between **primitive** tokens (`--indigo-600: #4f46e5`) and **semantic** tokens (`--color-brand: var(--indigo-600)`). Primitives are the palette; semantics are the API. Most components should use semantics. A palette token is fine inside a theme definition, but a button should not care that the brand happens to be indigo this quarter.

```html run
<section class="compare">
  <article class="panel theme-light">
    <p class="label">Light</p>
    <h2>Paper</h2>
    <p>Warm, low-contrast surfaces for long reading sessions.</p>
    <span class="chip">--color-brand</span>
  </article>
  <article class="panel theme-dark">
    <p class="label">Dark</p>
    <h2>Night</h2>
    <p>The same components, remapped by one class.</p>
    <span class="chip">--color-brand</span>
  </article>
</section>

<style>
  @layer tokens, components;
  @layer tokens {
    :root {
      --color-bg: #f6f5f2; --color-surface: #fffdf9; --color-text: #1c1917; --color-muted: #57534e;
      --color-border: #d6d3d1; --color-brand: #4f46e5; --space-5: 24px; --radius-lg: 20px;
      --shadow-md: 0 12px 32px rgb(28 25 23 / 0.12); --text-lg: 1.25rem;
    }
    .theme-dark {
      --color-bg: #0b1120; --color-surface: #111c33; --color-text: #e2e8f0; --color-muted: #94a3b8;
      --color-border: #24324a; --color-brand: #818cf8; --shadow-md: 0 12px 32px rgb(0 0 0 / 0.35);
    }
  }
  @layer components {
    body { margin: 0; padding: 32px; background: var(--color-bg); color: var(--color-text); font-family: ui-sans-serif, system-ui, sans-serif; }
    .compare { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; max-width: 760px; }
    .panel { padding: var(--space-5); border: 1px solid var(--color-border); border-radius: var(--radius-lg); background: var(--color-surface); color: var(--color-text); box-shadow: var(--shadow-md); }
    .label { margin: 0 0 8px; color: var(--color-muted); font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase; }
    .panel h2 { margin: 0 0 8px; font-size: var(--text-lg); }
    .panel p { margin: 0 0 16px; color: var(--color-muted); line-height: 1.6; }
    .chip { display: inline-block; padding: 4px 9px; border-radius: 999px; background: var(--color-brand); color: #fff; font-size: 0.72rem; font-weight: 650; }
    .theme-dark .chip { color: #0b1120; }
  }
</style>
```

`@layer tokens, components;` declares the order once. Tokens are resolved first, then components. Layer order is independent of where the blocks appear; that is what makes it a useful architecture tool rather than another specificity trick.

> **Pitfall:** Unlayered CSS beats every layer. If a stray `.button { background: red; }` sits outside your layers, it wins no matter how carefully you ordered them. Put the whole system in layers, and reserve unlayered CSS for the rare intentional override.

## Themes: remap, do not repaint

Dark mode done badly is a second stylesheet. Dark mode done well is the same components with different token values. The component rules never mention white or black; they mention `--color-surface` and `--color-text`. The theme changes the values, and the components keep working.

There are two entry points. The user''s operating-system preference comes through `prefers-color-scheme`. An explicit choice — a theme switch, a marketing page with a dark hero, a documentation panel — comes through a class such as `.theme-dark`. Both can coexist: the media query sets the default, and the class overrides it.

```css
:root {
  --color-bg: #f6f5f2;
  --color-text: #1c1917;
}
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #0b1120;
    --color-text: #e2e8f0;
  }
}
.theme-dark {
  --color-bg: #0b1120;
  --color-text: #e2e8f0;
}
```

The duplication is deliberate: the media query is the default, and the class is an explicit override. Keep the dark values in one place if you can, or use `light-dark()` with `color-scheme: light dark`; the important rule is that components consume semantic tokens, not fixed colors.

Also set `color-scheme: light` or `color-scheme: dark` on the theme. It tells the browser how to render form controls, scrollbars and default UI, and it prevents a dark page with a blinding white select box.

> **Tip:** Do not test dark mode by inverting colors. Test it by reading the token values and checking contrast. A lighter brand color often needs a darker "on-brand" text color; a dark surface often needs a lighter border, not the same border at 20% opacity.

## A scale beats a hundred decisions

Spacing, radius, shadow and type need scales for the same reason color does: consistency is cheaper than taste applied one property at a time. A four-pixel base with steps at 8, 12, 16, 24, 32 and 48 covers most layouts. Three radii — small, medium, large — cover most components. Two shadows — a quiet border shadow and a lifted card shadow — cover most depth.

```html run
<section class="sheet">
  <div class="type">
    <p class="eyebrow">Type scale</p>
    <p class="display">Display 40</p>
    <p class="title">Title 28</p>
    <p class="body">Body 16. Long-form text with a comfortable measure and a line height that lets the eye rest.</p>
  </div>
  <div class="tokens">
    <p class="eyebrow">Space</p>
    <div class="space"><span>8</span><i style="--w: 8px"></i></div>
    <div class="space"><span>16</span><i style="--w: 16px"></i></div>
    <div class="space"><span>24</span><i style="--w: 24px"></i></div>
    <div class="space"><span>32</span><i style="--w: 32px"></i></div>
    <p class="eyebrow radii-label">Radius and shadow</p>
    <div class="radii"><i class="r-sm"></i><i class="r-md"></i><i class="r-lg"></i><i class="r-shadow"></i></div>
  </div>
</section>

<style>
  :root {
    --ink: #1c1917; --muted: #57534e; --line: #d6d3d1; --brand: #4f46e5;
    --space-2: 8px; --space-4: 16px; --space-5: 24px; --space-6: 32px;
    --radius-sm: 8px; --radius-md: 12px; --radius-lg: 20px;
    --shadow-sm: 0 1px 2px rgb(28 25 23 / 0.08); --shadow-md: 0 12px 32px rgb(28 25 23 / 0.12);
    --text-2xl: 2.5rem; --text-xl: 1.75rem; --text-md: 1rem;
  }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--ink); font-family: ui-sans-serif, system-ui, sans-serif; }
  .sheet { display: grid; grid-template-columns: 1.2fr 1fr; gap: 32px; max-width: 900px; }
  .eyebrow { margin: 0 0 12px; color: var(--muted); font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase; }
  .display { margin: 0; font-size: var(--text-2xl); font-weight: 750; letter-spacing: -0.04em; }
  .title { margin: 8px 0 0; font-size: var(--text-xl); letter-spacing: -0.02em; }
  .body { max-width: 34rem; margin: 16px 0 0; color: var(--muted); font-size: var(--text-md); line-height: 1.65; }
  .tokens { padding: 24px; border: 1px solid var(--line); border-radius: var(--radius-lg); background: #fffdf9; box-shadow: var(--shadow-sm); }
  .space { display: flex; align-items: center; gap: 12px; margin: 8px 0; color: var(--muted); font-size: 0.75rem; }
  .space i { display: block; width: var(--w); height: 12px; border-radius: 3px; background: var(--brand); }
  .radii-label { margin-top: 24px; } .radii { display: flex; align-items: center; gap: 10px; }
  .radii i { display: block; width: 42px; height: 42px; background: #eef2ff; border: 1px solid #c7d2fe; }
  .r-sm { border-radius: var(--radius-sm); } .r-md { border-radius: var(--radius-md); } .r-lg { border-radius: var(--radius-lg); }
  .r-shadow { border: 0 !important; border-radius: var(--radius-md); background: #fff !important; box-shadow: var(--shadow-md); }
</style>
```

The exact numbers matter less than the commitment. Once three radii exist, a fourth needs a reason. Once the type scale has six steps, a seventh needs a reason. This is how a system stays coherent when five people add components in the same quarter.

## Buttons: variants are a contract

A button has a job. The primary variant is the one action you want most people to take on a screen; there should usually be one. Secondary is a safe alternative. Ghost is for low-emphasis actions inside dense UI. The variants should differ in weight, not just hue, and every one needs the same geometry so a row of buttons does not wobble.

States are part of the component, not an afterthought. Hover is a hint; `:focus-visible` is a requirement. Use `:focus-visible`, not `:focus`, so a mouse click does not leave a ring behind. The ring needs contrast against both the button and the page, and `outline-offset` keeps it from disappearing into the border. Disabled buttons should look unavailable and be removed from the tab order; a native `disabled` attribute does both.

```html run
<div class="actions">
  <button class="btn btn--primary" type="button">Save changes</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
  <button class="btn btn--primary" type="button" disabled>Publish</button>
</div>

<style>
  :root { --brand: #4f46e5; --brand-strong: #4338ca; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; --muted: #57534e; }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--text); font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; align-items: center; gap: 10px; }
  .btn { display: inline-flex; align-items: center; justify-content: center; min-height: 44px; padding: 0 18px; border: 1px solid transparent; border-radius: 999px; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif; cursor: pointer; transition: background-color 150ms ease, border-color 150ms ease, transform 150ms ease; }
  .btn--primary { background: var(--brand); color: #fff; }
  .btn--primary:hover { background: var(--brand-strong); }
  .btn--secondary { background: var(--surface); color: var(--text); border-color: var(--line); }
  .btn--secondary:hover { border-color: var(--brand); }
  .btn--ghost { background: transparent; color: var(--brand); }
  .btn--ghost:hover { background: #eef2ff; }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 55%, transparent); outline-offset: 3px; }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }
  .btn:active { transform: translateY(1px); }
  @media (prefers-reduced-motion: reduce) { .btn { transition: none; } }
</style>
```

The active state is a one-pixel translate, which is enough to feel physical without turning the interface into a toy. The disabled state uses opacity plus `cursor: not-allowed`; the native attribute prevents focus and activation, so there is no half-disabled state to explain.

> **Pitfall:** A `div` with `role="button"` needs a tabindex, key handlers and disabled-state management. A real `<button>` already has all three. Use the element unless you have a very specific reason not to.

## Forms: the error is part of the label

A field is a label, a control, optional help text, and an error. The error must be programmatically associated with the input, not just placed below it in red. `aria-invalid="true"` announces the invalid state; `aria-describedby` points at the error text so a screen reader reads it with the field. The visible label must be a real `<label for="...">`, not a placeholder.

The error should also have a shape cue, such as an icon or the word "Error", because color alone is not enough. The border can change, but the text carries the meaning.

```html run
<article class="card">
  <div class="card-head">
    <span class="badge">Draft</span>
    <span class="badge badge--success">Autosaved</span>
  </div>
  <h2>Invite a teammate</h2>
  <p>They will get access to the current workspace.</p>
  <form class="form">
    <div class="field">
      <label for="invite-email">Email address</label>
      <input id="invite-email" name="email" type="email" value="sam@" aria-invalid="true" aria-describedby="invite-error">
      <p class="error" id="invite-error"><span aria-hidden="true">!</span> Enter a complete email address, including the domain.</p>
    </div>
    <button class="btn btn--primary" type="submit">Send invite</button>
  </form>
</article>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --line: #d6d3d1; --brand: #4f46e5; --danger: #b91c1c; --radius-lg: 20px; --radius-sm: 8px; --shadow-md: 0 12px 32px rgb(28 25 23 / 0.1); }
  body { margin: 0; padding: 32px; background: #f6f5f2; color: var(--text); font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--line); border-radius: var(--radius-lg); background: var(--surface); box-shadow: var(--shadow-md); }
  .card-head { display: flex; gap: 8px; margin-bottom: 16px; }
  .badge { display: inline-flex; align-items: center; padding: 4px 9px; border-radius: 999px; background: #eef2ff; color: #3730a3; font-size: 0.72rem; font-weight: 700; }
  .badge--success { background: #ecfdf5; color: #047857; }
  .card h2 { margin: 0 0 6px; font-size: 1.35rem; letter-spacing: -0.02em; }
  .card > p { margin: 0 0 20px; color: var(--muted); line-height: 1.55; }
  .form { display: grid; gap: 16px; }
  .field { display: grid; gap: 6px; }
  .field label { font-size: 0.85rem; font-weight: 650; }
  .field input { min-height: 44px; padding: 0 12px; border: 1px solid var(--line); border-radius: var(--radius-sm); background: #fff; color: var(--text); font: inherit; }
  .field input:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 45%, transparent); outline-offset: 2px; border-color: var(--brand); }
  .field input[aria-invalid="true"] { border-color: var(--danger); }
  .error { display: flex; gap: 6px; margin: 0; color: var(--danger); font-size: 0.78rem; line-height: 1.45; }
  .error span { display: grid; place-items: center; width: 16px; height: 16px; flex: none; border-radius: 50%; background: var(--danger); color: #fff; font-size: 0.65rem; font-weight: 800; }
  .btn { min-height: 44px; padding: 0 18px; border: 0; border-radius: 999px; background: var(--brand); color: #fff; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif; cursor: pointer; }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 45%, transparent); outline-offset: 3px; }
</style>
```

The error text says what to do, not just that something is wrong. "Enter a complete email address, including the domain" is actionable. "Invalid input" is a riddle. The icon is redundant with the text on purpose; redundancy is how accessible design survives a grayscale screenshot.

## Challenge: build the token layer and a dark theme

The starter has a light surface, but no spacing, radius or shadow tokens, and `.theme-dark` never remaps the semantic colors. Add the missing tokens, define a dark surface and text, and make `.surface` consume them. The tests read the token values at runtime, so any coherent dark palette is accepted.

```html exercise id=design-token-theme title="Build the token layer and dark theme"
<section class="theme-dark">
  <article class="surface">
    <h2>Evening mode</h2>
    <p>The same component, a different set of decisions.</p>
  </article>
</section>

<style>
  :root {
    --color-bg: #f6f5f2;
    --color-surface: #fffdf9;
    --color-text: #1c1917;
    --color-muted: #57534e;
    --color-brand: #4f46e5;
    /* TODO: add --space-4, --radius-md and --shadow-card */
  }
  .theme-dark {
    /* TODO: remap the semantic colors for a dark surface */
  }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .surface {
    max-width: 420px;
    padding: var(--space-4);
    border-radius: var(--radius-md);
    background: var(--color-surface);
    color: var(--color-text);
    box-shadow: var(--shadow-card);
  }
  .surface h2 { margin: 0 0 8px; }
  .surface p { margin: 0; color: var(--color-muted); line-height: 1.6; }
</style>
--- solution
<section class="theme-dark">
  <article class="surface">
    <h2>Evening mode</h2>
    <p>The same component, a different set of decisions.</p>
  </article>
</section>

<style>
  :root {
    --color-bg: #f6f5f2;
    --color-surface: #fffdf9;
    --color-text: #1c1917;
    --color-muted: #57534e;
    --color-brand: #4f46e5;
    --space-4: 16px;
    --radius-md: 12px;
    --shadow-card: 0 12px 32px rgb(0 0 0 / 0.18);
  }
  .theme-dark {
    --color-bg: #0b1120;
    --color-surface: #111c33;
    --color-text: #e2e8f0;
    --color-muted: #94a3b8;
    --color-brand: #818cf8;
  }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .surface {
    max-width: 420px;
    padding: var(--space-4);
    border-radius: var(--radius-md);
    background: var(--color-surface);
    color: var(--color-text);
    box-shadow: var(--shadow-card);
  }
  .surface h2 { margin: 0 0 8px; }
  .surface p { margin: 0; color: var(--color-muted); line-height: 1.6; }
</style>
--- test
const root = getComputedStyle(document.documentElement);
["--space-4", "--radius-md", "--shadow-card"].forEach((name) => {
  assert(root.getPropertyValue(name).trim(), `Define ${name} on :root so components can share it`);
});
const theme = query(".theme-dark");
const surfaceToken = getComputedStyle(theme).getPropertyValue("--color-surface").trim();
const textToken = getComputedStyle(theme).getPropertyValue("--color-text").trim();
assert(surfaceToken && surfaceToken !== "#fffdf9", "Remap --color-surface inside .theme-dark; it still inherits the light value");
assertColor(".theme-dark .surface", "background-color", surfaceToken);
assertColor(".theme-dark .surface", "color", textToken);
assertStyle(".surface", "padding", "16px");
assertStyle(".surface", "border-radius", "12px");
--- hint
Add `--space-4: 16px`, `--radius-md: 12px` and a shadow token such as `0 12px 32px rgb(0 0 0 / 0.18)` to `:root`.
--- hint
Inside `.theme-dark`, redefine `--color-surface` and `--color-text` (and optionally `--color-muted` and `--color-brand`).
--- hint
The component already uses the variables. Once `.theme-dark` changes them, the surface updates without a single component rule changing.
```

## Challenge: build accessible button variants

Build primary, secondary and ghost buttons with a disabled example. The tests check that the variants compute to different surfaces, that the primary has enough height, that the disabled button is really disabled, and that the stylesheet includes a `:focus-visible` rule.

```html exercise id=design-button-variants title="Build accessible button variants"
<div class="actions">
  <button class="btn" type="button">Save changes</button>
  <button class="btn" type="button" disabled>Delete</button>
</div>

<style>
  :root { --brand: #4f46e5; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; }
  body { margin: 0; padding: 32px; background: #f6f5f2; font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; gap: 10px; }
  .btn { padding: 10px 16px; border: 1px solid var(--line); border-radius: 999px; background: #e2e8f0; color: var(--text); }
</style>
--- solution
<div class="actions">
  <button class="btn btn--primary" type="button">Save changes</button>
  <button class="btn btn--secondary" type="button">Preview</button>
  <button class="btn btn--ghost" type="button">Cancel</button>
  <button class="btn btn--primary" type="button" disabled>Publish</button>
</div>

<style>
  :root { --brand: #4f46e5; --brand-strong: #4338ca; --surface: #fffdf9; --text: #1c1917; --line: #d6d3d1; }
  body { margin: 0; padding: 32px; background: #f6f5f2; font-family: ui-sans-serif, system-ui, sans-serif; }
  .actions { display: flex; flex-wrap: wrap; gap: 10px; }
  .btn {
    display: inline-flex; align-items: center; justify-content: center;
    min-height: 44px; padding: 0 18px; border: 1px solid transparent;
    border-radius: 999px; font: 650 0.9rem/1 ui-sans-serif, system-ui, sans-serif;
    cursor: pointer;
  }
  .btn--primary { background: var(--brand); color: #fff; }
  .btn--primary:hover { background: var(--brand-strong); }
  .btn--secondary { background: var(--surface); color: var(--text); border-color: var(--line); }
  .btn--ghost { background: transparent; color: var(--brand); }
  .btn:focus-visible { outline: 3px solid color-mix(in srgb, var(--brand) 55%, transparent); outline-offset: 3px; }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }
</style>
--- test
assertExists(".btn--primary", "Add a primary button variant");
assertExists(".btn--secondary", "Add a secondary button variant");
assertExists(".btn--ghost", "Add a ghost button variant");
const backgrounds = [".btn--primary", ".btn--secondary", ".btn--ghost"].map((selector) => getComputedStyle(query(selector)).backgroundColor);
assert(new Set(backgrounds).size === 3, `The three variants should look different; their backgrounds are ${backgrounds.join(", ")}.`);
assertStyle(".btn--primary", "min-height", "44px");
assertColor(".btn--primary", "color", "#ffffff");
assertColor(".btn--secondary", "color", "#1c1917");
assertFocusable(".btn--primary");
const disabled = query(".btn[disabled]");
assert(disabled.disabled, "Keep the native disabled attribute on the unavailable action");
assert(parseFloat(getComputedStyle(disabled).opacity) < 1, "A disabled button should look unavailable, not identical to an enabled one");
const css = Array.from(document.querySelectorAll("style")).map((s) => s.textContent).join("\n");
assert(css.includes(":focus-visible"), "Add a :focus-visible rule so keyboard users can see where focus is");
--- hint
Use `.btn--primary`, `.btn--secondary` and `.btn--ghost` classes on the same `.btn` base.
--- hint
Give every variant `min-height: 44px`; the primary needs a filled background, the secondary a surface and border, and the ghost a transparent background.
--- hint
Add `.btn:focus-visible { outline: 3px solid ...; outline-offset: 3px; }` and keep the native `disabled` attribute on the last button.
```

## Debug: the card that stayed light

The dark theme remaps the surface and text tokens, but this card hard-codes a white background and then inherits the dark theme''s light text. The result is nearly unreadable. Fix the component so it consumes the theme tokens, and repair the badge and paragraph while you are there.

```html debug id=design-dark-card-contrast title="The card that stayed light"
<section class="theme-dark">
  <article class="card">
    <span class="badge">Live</span>
    <h2>Night shift</h2>
    <p>The dashboard after dark, with the same components and a different set of token values.</p>
  </article>
</section>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --border: #d6d3d1; --brand: #4f46e5; }
  .theme-dark { --surface: #111c33; --text: #e2e8f0; --muted: #94a3b8; --border: #24324a; --brand: #818cf8; }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--border); border-radius: 16px; background: #ffffff; color: var(--text); }
  .card h2 { margin: 8px 0; }
  .card p { margin: 0; color: var(--muted); line-height: 1.6; }
  .badge { display: inline-block; padding: 4px 9px; border-radius: 999px; background: #eef2ff; color: #3730a3; font-size: 12px; font-weight: 700; }
</style>
--- solution
<section class="theme-dark">
  <article class="card">
    <span class="badge">Live</span>
    <h2>Night shift</h2>
    <p>The dashboard after dark, with the same components and a different set of token values.</p>
  </article>
</section>

<style>
  :root { --surface: #fffdf9; --text: #1c1917; --muted: #57534e; --border: #d6d3d1; --brand: #4f46e5; }
  .theme-dark { --surface: #111c33; --text: #e2e8f0; --muted: #94a3b8; --border: #24324a; --brand: #818cf8; }
  body { margin: 0; padding: 32px; background: #0b1120; font-family: ui-sans-serif, system-ui, sans-serif; }
  .card { max-width: 440px; padding: 24px; border: 1px solid var(--border); border-radius: 16px; background: var(--surface); color: var(--text); }
  .card h2 { margin: 8px 0; }
  .card p { margin: 0; color: var(--muted); line-height: 1.6; }
  .badge { display: inline-block; padding: 4px 9px; border-radius: 999px; background: color-mix(in srgb, var(--brand) 16%, var(--surface)); color: var(--brand); font-size: 12px; font-weight: 700; }
</style>
--- test
const theme = query(".theme-dark");
const surface = getComputedStyle(theme).getPropertyValue("--surface").trim();
const text = getComputedStyle(theme).getPropertyValue("--text").trim();
const muted = getComputedStyle(theme).getPropertyValue("--muted").trim();
assertColor(".theme-dark .card", "background-color", surface);
assertColor(".theme-dark .card", "color", text);
assertColor(".theme-dark .card p", "color", muted);
assertColor(".theme-dark .badge", "color", getComputedStyle(theme).getPropertyValue("--brand").trim());
const rgb = (value) => value.match(/\d+(\.\d+)?/g).slice(0, 3).map(Number);
const luminance = (value) => {
  const [r, g, b] = rgb(value).map((channel) => {
    const c = channel / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};
const contrast = (a, b) => {
  const [lighter, darker] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (lighter + 0.05) / (darker + 0.05);
};
const cardStyle = getComputedStyle(query(".card"));
const ratio = contrast(cardStyle.color, cardStyle.backgroundColor);
assert(ratio >= 4.5, `The card text has ${ratio.toFixed(1)}:1 contrast against its surface; aim for at least 4.5:1.`);
const paragraphStyle = getComputedStyle(query(".card p"));
assert(contrast(paragraphStyle.color, paragraphStyle.backgroundColor) >= 4.5, "The paragraph text should also meet 4.5:1 against the card surface");
--- hint
`background: #ffffff` is a hard-coded light surface. Replace it with `var(--surface)`.
--- hint
The text color already uses `var(--text)`, so once the background follows the theme the contrast returns. Do the same for `.card p` with `var(--muted)`.
--- hint
The badge can use `color-mix(in srgb, var(--brand) 16%, var(--surface))` with `color: var(--brand)` so it adapts to the theme too.
```

## Predict: which layer wins?

```html predict id=design-layer-order title="Which background wins?"
<p class="pill">Layer test</p>
<style>
  @layer base, components;
  @layer base { .pill { background: #d6d3d1; color: #1c1917; } }
  @layer components { .pill { background: #4f46e5; color: #fff; } }
  .pill { display: inline-block; padding: 8px 14px; border-radius: 999px; background: #f59e0b; color: #1c1917; font-family: ui-sans-serif, system-ui, sans-serif; font-weight: 650; }
</style>
--- options
* Amber, because unlayered styles beat every layer
Indigo, because components is the last layer
Slate, because base is the first layer
The browser averages the three backgrounds
--- explain
`@layer base, components;` sets the order, so indigo would beat slate if both were layered. But the final `.pill` rule is **unlayered**. Normal unlayered declarations have higher priority than every layer, so amber wins. This is why a design system should either put all component CSS in layers or clearly reserve unlayered rules for intentional overrides.
```

## The complete gallery

This page is the system''s home: a masthead, a token shelf, a button row, a field with an error, cards and badges. The gallery uses `repeat(auto-fit, minmax(...))` so the same markup goes from one column to three without a breakpoint. The whole thing sits inside `@layer tokens, base, components, utilities`.

```html run
<header class="masthead">
  <p class="eyebrow">Lumen system · v1.0</p>
  <h1>One language, many surfaces.</h1>
  <p class="lede">Tokens, buttons, fields and cards. Change the theme, not the components.</p>
</header>
<section class="gallery">
  <article class="panel"><h2>Buttons</h2><div class="row"><button class="btn btn--primary" type="button">Save</button><button class="btn btn--secondary" type="button">Preview</button><button class="btn btn--ghost" type="button">Cancel</button></div></article>
  <article class="panel"><h2>Field</h2><div class="field"><label for="demo-email">Email</label><input id="demo-email" type="email" value="sam@" aria-invalid="true" aria-describedby="demo-error"><p class="error" id="demo-error"><span aria-hidden="true">!</span> Add the domain after the @.</p></div></article>
  <article class="panel"><span class="badge">New</span><h2>Card</h2><p>A composed surface: border, radius, shadow and type all come from tokens.</p></article>
  <article class="panel theme-dark"><span class="badge">Dark</span><h2>Same components</h2><p>The class changes the token values; nothing inside is repainted.</p></article>
</section>

<style>
  @layer tokens, base, components, utilities;
  @layer tokens {
    :root { --bg:#f6f5f2; --surface:#fffdf9; --text:#1c1917; --muted:#57534e; --border:#d6d3d1; --brand:#4f46e5; --space-4:16px; --space-5:24px; --radius-md:12px; --radius-lg:20px; --shadow-md:0 12px 32px rgb(28 25 23 / .12); }
    @media (prefers-color-scheme: dark) { :root { --bg:#0b1120; --surface:#111c33; --text:#e2e8f0; --muted:#94a3b8; --border:#24324a; --brand:#818cf8; } }
    .theme-dark { --bg:#0b1120; --surface:#111c33; --text:#e2e8f0; --muted:#94a3b8; --border:#24324a; --brand:#818cf8; }
  }
  @layer base {
    * { box-sizing:border-box; } body { margin:0; padding:32px; background:var(--bg); color:var(--text); font-family:ui-sans-serif,system-ui,sans-serif; }
    h1 { margin:0 0 8px; font-size:clamp(2rem,5vw,3.5rem); line-height:1; letter-spacing:-.04em; } h2 { margin:8px 0; font-size:1.15rem; }
  }
  @layer components {
    .masthead { max-width:980px; margin:0 auto 24px; } .eyebrow { margin:0 0 10px; color:var(--muted); font-size:.72rem; letter-spacing:.14em; text-transform:uppercase; } .lede { max-width:44rem; margin:0; color:var(--muted); line-height:1.6; }
    .gallery { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:16px; max-width:980px; margin:0 auto; }
    .panel { padding:var(--space-5); border:1px solid var(--border); border-radius:var(--radius-lg); background:var(--surface); color:var(--text); box-shadow:var(--shadow-md); } .panel > p { margin:0; color:var(--muted); line-height:1.6; }
    .row { display:flex; flex-wrap:wrap; gap:8px; } .btn { min-height:44px; padding:0 16px; border:1px solid transparent; border-radius:999px; font:650 .85rem/1 ui-sans-serif,system-ui,sans-serif; cursor:pointer; }
    .btn--primary { background:var(--brand); color:#fff; } .btn--secondary { background:var(--surface); color:var(--text); border-color:var(--border); } .btn--ghost { background:transparent; color:var(--brand); }
    .btn:focus-visible { outline:3px solid color-mix(in srgb,var(--brand) 55%,transparent); outline-offset:3px; }
    .field { display:grid; gap:6px; } .field label { font-size:.85rem; font-weight:650; } .field input { min-height:44px; padding:0 10px; border:1px solid var(--border); border-radius:var(--radius-md); background:var(--surface); color:var(--text); font:inherit; } .field input[aria-invalid="true"] { border-color:#b91c1c; }
    .error { display:flex; gap:6px; margin:0; color:#b91c1c; font-size:.76rem; } .error span { display:grid; place-items:center; width:16px; height:16px; flex:none; border-radius:50%; background:#b91c1c; color:#fff; font-size:.65rem; font-weight:800; }
    .badge { display:inline-block; padding:4px 9px; border-radius:999px; background:color-mix(in srgb,var(--brand) 16%,var(--surface)); color:var(--brand); font-size:.72rem; font-weight:700; }
  }
  @layer utilities { .sr-only { position:absolute; width:1px; height:1px; overflow:hidden; clip-path:inset(50%); white-space:nowrap; } }
</style>
```

The dark panel is a local theme: `.theme-dark` sits on the article and remaps the tokens for that subtree only. The rest of the page follows the operating-system preference through the `prefers-color-scheme` block. That is the whole theme model in one page.

> **In the wild:** Design systems fail more often from too many options than from too few. A button with twelve variants, six radii and four shadows is not flexible; it is a set of decisions nobody can remember. Start with a small contract and add a variant only when a real screen needs it.

## Recap

- Tokens name decisions. Components consume semantic tokens, not raw hex values.
- `@layer` sets cascade order once; unlayered CSS still wins, so keep the system inside layers.
- Themes remap tokens. `prefers-color-scheme` is the default; `.theme-dark` is an explicit override.
- Spacing, radius, shadow and type need small scales, not unlimited choices.
- Buttons need variants with equal geometry, a visible `:focus-visible` ring, and a real disabled state.
- Fields need a `<label>`, `aria-invalid`, `aria-describedby` and error text that says what to do.
- Cards and badges compose the same tokens; a badge is not a new color system.
- A responsive gallery can use `auto-fit` and `minmax` instead of a breakpoint for every column count.
- Test computed colors, focusability and contrast. A design system that only looks right in light mode is half a system.

**Up next:** the final checkpoint. You will review the cascade, layout, motion, accessibility and the two capstones, then take the course exam.
', 0, '[]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_html_css_advanced_5_4', 'sec_html_css_advanced_5', 'crs_html_css_advanced', 'Final exam: HTML & CSS Advanced', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which declaration correctly uses a CSS custom property?","options":["`color: --brand;`","`color: var(--brand);`","`color: custom(--brand);`","`color: property(--brand);`"],"answerIndex":1,"explanation":"Custom properties are read with `var(--name)`. They can be declared, inherited and overridden just like other properties. A bare `--brand` on the right-hand side is not a value."},{"id":"q2","prompt":"What is the result of `color: var(--brand, #0f766e)` when `--brand` is defined as `not-a-color`?","options":["The fallback `#0f766e` is used","The property becomes invalid at computed-value time and falls back to inherited or initial color","The browser throws a JavaScript error","The text becomes transparent"],"answerIndex":1,"explanation":"The fallback is for an *undefined* property, not an invalid value. A defined custom property with an invalid value makes the declaration invalid at computed-value time; the property resolves as `unset` (inherited or initial), not to the `var()` fallback. This is a common debugging trap."},{"id":"q3","prompt":"In `@layer reset, base, components, utilities;`, which layer has the highest priority for normal declarations?","options":["`reset`","`base`","`components`","`utilities`"],"answerIndex":3,"explanation":"Later layers override earlier ones for normal declarations. The order in the initial `@layer` statement defines the priority. `!important` reverses layer order, which is one of the subtle parts of cascade layers."},{"id":"q4","prompt":"Which selector matches a card only when it contains a featured image?","options":["`.card:has(img.featured)`","`.card:contains(img.featured)`","`.card img.featured`","`.card + img.featured`"],"answerIndex":0,"explanation":"`:has()` is the relational pseudo-class: it matches an element based on its descendants or siblings. `.card img.featured` styles the image inside a card, not the card itself. `:contains()` is not a standard CSS selector."},{"id":"q5","prompt":"What does `minmax(0, 1fr)` fix in a grid track?","options":["It forces the track to always be 0px","It lets the track shrink below its min-content width instead of overflowing","It adds a 1px border","It creates a minimum of one column"],"answerIndex":1,"explanation":"A bare `1fr` has an `auto` minimum, which can be as wide as the content''s min-content size. `minmax(0, 1fr)` sets the minimum to zero so the track can shrink and the content can wrap or truncate. This is the standard fix for grid overflow."},{"id":"q6","prompt":"A `position: sticky` header scrolls away with the page. What is a likely cause?","options":["The header is missing `top: 0` or an ancestor has `overflow: hidden/auto`","The header needs `position: fixed`","The header has too much padding","Sticky only works in Grid"],"answerIndex":0,"explanation":"Sticky requires an inset (`top`, `bottom`, etc.) to define when it sticks. It also sticks relative to its nearest scrolling ancestor; an ancestor with `overflow: hidden`, `auto` or `scroll` can become that container and break the expected behaviour. Check both."},{"id":"q7","prompt":"Why can `z-index: 9999` fail to bring an element above a sibling?","options":["z-index has a maximum of 10","An ancestor creates a stacking context, trapping the element below sibling contexts","The element needs `position: absolute`","Only Flexbox supports z-index"],"answerIndex":1,"explanation":"Stacking contexts isolate their descendants. If an ancestor has `transform`, `opacity < 1`, `filter`, `isolation`, `contain` and similar properties, descendants cannot paint above elements in a higher sibling context. Raise the ancestor''s context or move the overlay in the DOM."},{"id":"q8","prompt":"What does `container-type: inline-size` enable?","options":["Viewport-based media queries","Container queries based on the element''s inline size","A fixed-width grid","Automatic image compression"],"answerIndex":1,"explanation":"It establishes an inline-size query container, allowing descendants to use `@container (min-width: …)`. This makes a component respond to the space it is placed in rather than the viewport, which is essential for reusable cards, sidebars and design systems."},{"id":"q9","prompt":"Which property would you use for spacing that should adapt to right-to-left writing modes?","options":["`margin-left`","`margin-inline-start`","`padding-top`","`border-right`"],"answerIndex":1,"explanation":"`margin-inline-start` maps to the start edge of the inline axis. In a left-to-right language that is the left side; in right-to-left it is the right side. Logical properties reduce the need for direction-specific overrides."},{"id":"q10","prompt":"What is the best use of `prefers-reduced-motion`?","options":["Disable the entire site","Reduce or replace large motion while preserving state feedback and content","Force all animations to loop","Only apply it to video elements"],"answerIndex":1,"explanation":"The preference is about motion, not about removing functionality. Keep necessary feedback, but replace large translations, scaling, parallax and spinning with instant changes or short opacity fades. Test the reduced-motion path as deliberately as the default one."},{"id":"q11","prompt":"Which is the most robust way to make a card''s text readable on both light and dark themes?","options":["Hard-code `color: black` on the card","Use semantic color tokens such as `--color-text` and `--color-surface` that are redefined per theme","Add `filter: invert(1)` in dark mode","Use a different HTML file for dark mode"],"answerIndex":1,"explanation":"Semantic tokens describe the role (text, surface, border, accent) rather than a fixed color. A theme redefines those tokens; components stay unchanged. Hard-coded black text breaks on dark surfaces, and `filter: invert` inverts images and other content unpredictably."},{"id":"q12","prompt":"What does `content-visibility: auto` risk if you skip `contain-intrinsic-size`?","options":["Nothing; it is always safe","Offscreen content may have an unknown size, causing layout jumps or inaccurate scrollbars as it renders","It blocks all CSS animations","It hides content permanently"],"answerIndex":1,"explanation":"Skipping rendering for offscreen content means the browser needs an estimated size to reserve space. Without `contain-intrinsic-size`, that estimate can be wrong, causing scroll position jumps and layout shift as sections come into view. Measure representative content and provide a sensible size."}]', '[]', '2026-06-25T06:04:01.393Z', '2026-10-19T06:04:01.393Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_frontend_engineer', 'crs_html_css_advanced', 1);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_1', 'usr_seed000001', 'crs_html_css_advanced', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-28T01:04:01.393Z', '2026-09-28T01:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000001');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_2', 'usr_seed00000t', 'crs_html_css_advanced', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-07-31T02:04:01.393Z', '2026-07-31T02:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000t');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_3', 'usr_seed00000u', 'crs_html_css_advanced', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-27T07:04:01.393Z', '2026-09-27T07:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_4', 'usr_seed00000w', 'crs_html_css_advanced', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-08-01T14:04:01.393Z', '2026-08-01T14:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000w');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_5', 'usr_seed00001g', 'crs_html_css_advanced', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-12T15:04:01.393Z', '2026-10-12T15:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001g');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_6', 'usr_seed00001m', 'crs_html_css_advanced', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-19T16:04:01.393Z', '2026-10-19T16:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001m');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_7', 'usr_seed00002l', 'crs_html_css_advanced', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-08-03T12:04:01.393Z', '2026-08-03T12:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002l');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_8', 'usr_seed00002p', 'crs_html_css_advanced', 4, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-09-15T22:04:01.393Z', '2026-09-15T22:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002p');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_9', 'usr_seed00002z', 'crs_html_css_advanced', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-08-12T07:04:01.393Z', '2026-08-12T07:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_html_css_advanced_10', 'usr_seed00004b', 'crs_html_css_advanced', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-09-08T09:04:01.393Z', '2026-09-08T09:04:01.393Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004b');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_html_css_advanced'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_html_css_advanced') WHERE id = 'crs_html_css_advanced';
