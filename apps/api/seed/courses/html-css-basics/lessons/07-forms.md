A form is a conversation with a stranger. You ask for an email address, a date, a delivery note; they decide whether the conversation is worth continuing. Most of that decision happens before anyone types: a field without a visible label looks like homework, a button that submits when it should not can wipe a half-finished order, and an error message that only changes color is invisible to plenty of people.

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

The `for` attribute on the label and the `id` on the input are a pair. When they match, clicking the label focuses the input, tapping the label on a phone opens the right keyboard, and a screen reader announces the label as the field's name. When they do not match, the label becomes decoration.

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
A label's `for` attribute must match an input's `id` exactly. The first label points at `email`, but the first input's id is `contact-email`, so the browser has nothing to focus. The `name` attributes do not help: they are for the server, not for label association. The second label works because `for="backup-email"` matches `id="backup-email"`.
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
    <p class="eyebrow">Don't do this</p>
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

The `aria-describedby` attribute points at the hint paragraph. Unlike a placeholder, the hint is not a label: it adds an explanation after the field's name. We will use it properly for error text below.

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
assert(label.getAttribute("for") === input.id, "The label's for attribute must match the input's id");
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

> **Pitfall:** The default is easy to forget because the markup looks identical. If a button is not the form's main action, write `type="button"` even if you have not added JavaScript yet. The attribute documents the intent.

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

There are two ways to label a radio or checkbox. The compact one wraps the input in the label, so the text and the control are one clickable unit. The explicit one uses a separate `<label for="...">` and an `id` on the input. Both work; pick one and stay consistent within a form. Keep the legend short — it is the group's name, not a place for a paragraph of instructions. Put longer guidance just below the legend or connect it to the group with `aria-describedby`.

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
assertCount("form.grind-form fieldset input[type='radio']", 3, "All three radio inputs belong inside the fieldset");
const radios = Array.from(document.querySelectorAll("form.grind-form fieldset input[type='radio']"));
const groupName = radios[0].name;
assert(groupName && radios.every((radio) => radio.name === groupName), "All three radios need the same non-empty name so only one can be chosen");
assert(radios.every((radio) => document.querySelector('label[for="' + radio.id + '"]')), "Keep a label connected to every radio input");
assertCount("form.grind-form input[type='radio']", 3, "Do not leave a radio outside the fieldset");
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

The field's accessible description is now "We send one receipt. No marketing. That address needs an @ and a domain." That is a lot to hear on every focus, so keep the static hint short and only add the error when it is relevant. In a real form, JavaScript would add `aria-invalid` and unhide the error after validation; the markup contract stays the same. Since this course does not use scripts yet, the demo shows the error state directly.

`aria-describedby` is not a substitute for a label. The label names the field; the description adds detail. If the only text near an input is an error message, the field still has no name. Use a visible `<label>` first, then connect the hint or error. Native validation is also deliberately conservative: it can catch a missing required value or an obviously malformed email, but it cannot know that a date is fully booked or a coupon has expired. Let the browser handle the cheap checks and write your own messages for the rules it cannot see.

`:focus-visible` is the browser's way of saying "this focus should be obvious." It matches keyboard focus, not every mouse click. Style it with a clear outline and an offset so the ring does not disappear into the border. Never remove an outline without providing an equally visible replacement.

> **In the wild:** Well-designed checkout forms put the label above the field, keep help text close, and place the error directly under the control it belongs to. The visual order and the DOM order should agree, because keyboard and screen-reader users move through the page in DOM order, not in the order that looks nicest.

## Debug: the label that points at nothing

This delivery form has two bugs. The Email label points at an id that does not exist, so clicking it does nothing. The "Add another address" button has no `type`, so inside the form it defaults to `submit` and sends the details instead of adding a row.

Fix both. You can either change the label's `for` or the input's `id`; make them match exactly.

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
const input = query("input[name='email']");
assert(input.id, "The email input needs an id");
assert(label.htmlFor === input.id, "The Email label still points at an id that does not exist");
assert(label.control === input, "The label is not connected to the email input. Make for and id match.");
label.click();
assert(document.activeElement === input, "Clicking the Email label did not focus the email field. Make for and id match.");
const add = query("button.add");
assert(add.getAttribute("type") === "button", "The 'Add another address' button is still a submit button. Give it type=\"button\" so it cannot send the form.");
assertText("button.add", "Add another address", "Keep the secondary button's visible text");
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
