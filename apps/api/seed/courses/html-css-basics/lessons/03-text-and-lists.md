Most of the web is still text. A recipe, a product page, a review, a set of trail notes: strip away the layout and what remains is words arranged into headings, paragraphs, lists and quotations. HTML's job is to say what each piece of text *is*, so a browser, a search engine and a screen reader can all agree on its role.

That distinction matters more than it sounds. Two pieces of text can look identical on screen and mean completely different things. A bold word might be important, or it might just be a keyword. A list might have an order, or it might be a bag of ingredients. This lesson gives you the inline vocabulary and the list structures that make those distinctions explicit — and shows you when the browser's default styling is helping you and when it is lying to you.

## Strong is a meaning. Bold is a look.

`<strong>` marks text as important, serious or urgent. The browser makes it bold by default, and screen readers may add emphasis when they announce it. Use it when losing the word would change the meaning of the sentence:

```html run
<h1>Allergen notice</h1>
<p><strong>This loaf contains hazelnuts.</strong> The kitchen also handles sesame and milk.</p>
<p><b>New</b> on the autumn menu: hazelnut and pear tart.</p>
```

The second sentence uses `<b>`, which draws attention without claiming importance: a keyword in a summary or a product name. It is bold too, but it carries no extra weight in the document's meaning. If you are reaching for bold purely because a word should stand out visually, ask whether it is important. If it is, use `strong`; if it is only a typographic offset, use `b` — or better, use CSS later and leave the HTML honest.

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

Use the review URL `https://theweekendtable.example/reviews/moss-and-pine` in the blockquote's `cite` attribute. The visible source is *The Weekend Table*, and the review date is 12 October 2026.

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
assertAttr("blockquote", "cite", "https://theweekendtable.example/reviews/moss-and-pine", "Point the blockquote's cite attribute at the review URL.");
assertText("cite", "The Weekend Table", "The cite element should name the publication, not the person who said it.");
assertExists("time[datetime='2026-10-12']", "Add a time element with datetime='2026-10-12'.");
--- hint
A long quotation is a block-level element, so it sits outside the paragraph you are replacing. The source line can stay in its own paragraph.
--- hint
Put the review text inside `<blockquote cite="…"><p>…</p></blockquote>`, then follow it with a paragraph containing `<cite>` and `<time>`.
--- hint
The `time` element's visible text can be “12 October 2026”; the machine-readable version belongs in `datetime="2026-10-12"`.
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

> **Pitfall:** Never place an `<li>` directly inside a `<ul>`'s parent, or directly in the body. An `<li>` without a list around it is invalid, and the browser has to guess what you meant. The guess is rarely the structure you wanted.

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
assertAttr("abbr", "title", "extra virgin olive oil", "The abbreviation should expand to 'extra virgin olive oil' in its title attribute.");
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
