A fast page is not a page with fewer features. It is a page that decides what the browser needs *first*, and refuses to make it wait for everything else. That decision is made in HTML and CSS long before a single byte of JavaScript runs: which styles are critical, which font may swap, which image candidate fits the slot, and how much space every piece of media reserves before it arrives.

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

The `sizes` value describes **layout width**, not the image's intrinsic width. `(min-width: 760px) 50vw` means "on a wide screen this image occupies half the viewport." At 1100 px, that is a 550 px slot. With a 1× display, the browser wants at least 550 px, so the 800w candidate is the sensible choice. On a 2× phone the same slot needs 1100 px, and the 1200w candidate wins.

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
assert(hasDimensions || ratioReserved, "Reserve the image's box with width/height attributes or an aspect-ratio on the image or its container");
assert(query(".story").getBoundingClientRect().height > 250, "The card should have a stable, visible media area");
--- hint
Add the image's real `width` and `height` attributes. That gives the browser the aspect ratio before the file loads.
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
- **Lighthouse** for a second opinion, not a verdict. A score is a summary of a lab run, not your users' experience.

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
