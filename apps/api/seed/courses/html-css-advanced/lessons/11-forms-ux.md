A form is the most expensive surface in an interface. It is where someone types a card number, chooses a delivery slot, or asks for help at 2am. Every unnecessary field, every ambiguous label and every red border that appears before the visitor has done anything costs trust. Premium forms are not decorated forms. They are forms that answer three questions at every moment: what do you want from me, is what I typed acceptable, and what happens if it is not?

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

The `opacity: 1` matters. Firefox applies a default opacity to placeholder text, so a colour that passes in Chrome can fail there. Check the contrast against the field's actual background, not the page behind it.

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

Native checkboxes and radios are fast, familiar and accessible. Try `accent-color` before you reach for a custom design. It themes the native control in one declaration, keeps the platform's high-contrast behaviour, and inherits into children, so you can set it once on `:root`:

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

When the design genuinely needs a custom shape, `appearance: none` removes the native painting but keeps the element's semantics and keyboard behaviour. Do not replace the input with a `<span>`; style the input itself. The essential rules:

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
const email = query('input[type="email"]');
assertAttr('input[type="email"]', "autocomplete", "email");
const describedBy = email.getAttribute("aria-describedby");
assert(describedBy, "Connect the email hint to the field with aria-describedby.");
const hint = document.getElementById(describedBy.split(/\s+/)[0]);
assert(hint, `aria-describedby points to "${describedBy}", but no element has that id.`);
assert(normalize(hint.textContent).length > 0, "The email hint should contain text that explains how the address is used.");
assertFocusable('button[type="submit"]', "Keep a focusable submit button.");
--- hint
Start from the markup: every `<input>` needs an `id` and a `<label for="…">`. Then give the email hint an `id` and list it in `aria-describedby` on the input.
--- hint
For the grid, set `display: grid` and `grid-template-columns: repeat(2, minmax(0, 1fr))` on `.signup`. Let the trail field and the button span both columns with `grid-column: 1 / -1`.
```

The `minmax(0, 1fr)` detail is what keeps a long email address from widening its column. Without it, the grid track's automatic minimum is the input's min-content width, and the form can develop a horizontal scrollbar on a narrow laptop. The test checks the number of tracks, not a specific pixel width, so any two-column arrangement at 1100px passes.

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
const box = query('input[type="checkbox"]');
assertStyle('input[type="checkbox"]', "appearance", "none", "Use appearance: none on the real checkbox so you can draw the custom box.");
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
const radios = [...document.querySelectorAll('input[type="radio"]')];
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
const input = query('input[type="email"]');
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
assertColor('input[type="email"]', "border-top-color", "#b91c1c", "The invalid field should also have a visible red border.");
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
