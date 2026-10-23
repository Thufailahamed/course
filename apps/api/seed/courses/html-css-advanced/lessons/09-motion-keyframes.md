Motion is feedback. A button that lifts under the pointer says "I am clickable"; a panel that fades in says "this content just arrived"; a skeleton that shimmers says "the data is coming". The same motion, overdone or applied to everything, says "the designer discovered animation". The difference is not taste. It is whether the movement carries information the interface would otherwise have to state in words.

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

The four bars travel the same distance in the same time, but they do not feel the same. `linear` is mechanical; `ease` is the browser's default compromise; `steps(6, end)` jumps in six discrete positions, like a mechanical counter; the cubic-bezier overshoots because its second control point has a y value above 1, then settles back.

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
The moving part is not the element; it is the gradient's position inside the element. Start with a wide gradient and animate `background-position`.
--- hint
Use `background: linear-gradient(100deg, #e2e8f0 20%, #f8fafc 40%, #e2e8f0 60%); background-size: 200% 100%;` and animate `background-position` from `150% 0` to `-50% 0`.
```

The `aria-busy="true"` on the card is not decoration. It tells assistive technology that the region is updating, so a screen-reader user is not told that an empty card is the final content. The visual shimmer is for sighted users; the state is for everyone.

> **Under the hood:** `background-position` is a paint property, so a large shimmer repaints its area every frame. For a full-page skeleton, animate a pseudo-element's `transform` over a static gradient instead, and keep the moving layer small.

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

`transform-origin` sets the pivot. The default is the centre of the element (`50% 50%`). A menu that should unfold from its trigger uses `transform-origin: top left`; a card that should swing from its left edge uses `transform-origin: left center`. The origin is part of the animation's meaning, not a detail you add at the end.

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

- `none` (default): the animation's values apply only while it is running.
- `forwards`: the last keyframe's values persist after the animation finishes.
- `backwards`: the first keyframe's values apply during the delay before the animation starts.
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
assert(fill === "forwards" || fill === "both", `The toast's animation-fill-mode computes to ${fill}. After the last keyframe it falls back to opacity: 0.`);
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



