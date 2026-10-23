/* ────────────────────────────────────────────────────────────
 * HTML & CSS lesson harness
 *
 * Cells are complete documents or fragments. The preview is rendered
 * in a sandboxed <iframe> with scripts removed. Challenge tests are
 * JavaScript and run *inside* the rendered document, so they can use
 * the real DOM and getComputedStyle — no approximation of CSS.
 *
 * Test helpers available to authors:
 *   assert(condition, message)
 *   assertExists(selector, message?)
 *   assertNotExists(selector, message?)
 *   assertCount(selector, n, message?)
 *   assertText(selector, expected, message?)
 *   assertAttr(selector, name, expected, message?)
 *   assertStyle(selector, property, expected, message?)
 *   assertColor(selector, property, expected, message?)
 *   assertVisible(selector, message?)
 *   assertNoOverflow(message?)
 *   assertFocusable(selector, message?)
 *   query(selector)
 *   normalize(text)
 * ──────────────────────────────────────────────────────────── */

const HEAD =
  '<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">';

const PREVIEW_CSP =
  "default-src 'none'; style-src 'unsafe-inline'; img-src data: blob: https:; font-src data: https:; media-src https: blob:; form-action 'none'; base-uri 'none'";

const FULL_DOCUMENT = /<!doctype\s+html|<html[\s>]/i;

export interface HtmlDocumentOptions {
  /** Remove scripts, embedded frames, inline event handlers and javascript: URLs. Defaults to true. */
  sanitize?: boolean;
  /** Add a restrictive CSP to the preview. Defaults to true. */
  csp?: boolean;
}

/** True when the snippet already declares a complete document. */
export function isFullHtmlDocument(code: string) {
  return FULL_DOCUMENT.test(code);
}

/**
 * Removes active or externally-loading content so previews and checks only
 * render self-contained HTML + CSS. This is a safety net, not a substitute
 * for authoring responsibly.
 */
export function sanitizeHtml(code: string) {
  return code
    .replace(/<script\b[^>]*>[\s\S]*?<\/script\s*>/gi, "")
    .replace(/<script\b[^>]*\/?>/gi, "")
    .replace(/<meta\b[^>]*http-equiv\s*=\s*["']?content-security-policy["']?[^>]*>/gi, "")
    .replace(/<(iframe|object|embed|frame|frameset)\b[^>]*>[\s\S]*?<\/\1\s*>/gi, "")
    .replace(/<\/?(?:iframe|object|embed|frame|frameset|base|link)\b[^>]*\/?>/gi, "")
    .replace(/\son[a-z]+\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+)/gi, "")
    .replace(/\s(?:href|src)\s*=\s*(?:"javascript:[^"]*"|'javascript:[^']*'|javascript:[^\s>]+)/gi, "");
}

function injectIntoHead(document: string, html: string) {
  if (/<\/head\s*>/i.test(document)) return document.replace(/<\/head\s*>/i, `${html}</head>`);
  if (/<head\b[^>]*>/i.test(document)) return document.replace(/<head\b[^>]*>/i, (m) => `${m}${html}`);
  return document.replace(/<html\b[^>]*>/i, (m) => `${m}<head>${html}</head>`);
}

/** Wraps a fragment in a document, or returns a complete document unchanged. */
export function buildHtmlDocument(code: string, options: HtmlDocumentOptions = {}) {
  const sanitize = options.sanitize ?? true;
  const csp = options.csp ?? true;
  const source = sanitize ? sanitizeHtml(code) : code;
  const meta = `${HEAD}${csp ? `<meta http-equiv="Content-Security-Policy" content="${PREVIEW_CSP}">` : ""}<title>Lesson preview</title>`;

  if (isFullHtmlDocument(source)) return injectIntoHead(source, meta);

  return `<!doctype html><html lang="en"><head>${meta}</head><body>${source}</body></html>`;
}

const RUNNER = String.raw`
(function () {
  var testEl = document.getElementById("latent-test");
  var test = testEl ? JSON.parse(testEl.textContent || "\"\"") : "";
  var finished = false;

  function finish(result) {
    if (finished) return;
    finished = true;
    window.__latentResult = result;
    try {
      parent.postMessage({ __latentHtml: true, passed: !!result.passed, message: result.message || null }, "*");
    } catch (error) {}
  }

  function normalize(value) {
    return String(value == null ? "" : value).replace(/\s+/g, " ").trim();
  }

  function assert(condition, message) {
    if (!condition) throw new Error(message || "That check did not pass yet.");
  }

  function query(selector) {
    var el = document.querySelector(selector);
    assert(el, "No element matches '" + selector + "'.");
    return el;
  }

  function assertExists(selector, message) {
    assert(document.querySelector(selector), message || "Add an element that matches '" + selector + "'.");
  }

  function assertNotExists(selector, message) {
    assert(!document.querySelector(selector), message || "Remove the element that matches '" + selector + "'.");
  }

  function assertCount(selector, count, message) {
    var actual = document.querySelectorAll(selector).length;
    assert(actual === count, message || "Expected " + count + " elements matching '" + selector + "', found " + actual + ".");
  }

  function assertText(selector, expected, message) {
    var actual = normalize(query(selector).textContent);
    assert(actual === normalize(expected), message || "'" + selector + "' should read \"" + expected + "\", but it reads \"" + actual + "\".");
  }

  function assertAttr(selector, name, expected, message) {
    var actual = query(selector).getAttribute(name);
    assert(actual === expected, message || "'" + selector + "' should have " + name + "=\"" + expected + "\", but it has " + (actual === null ? "no such attribute" : "\"" + actual + "\"") + ".");
  }

  function cssValue(selector, property) {
    return getComputedStyle(query(selector)).getPropertyValue(property);
  }

  function assertStyle(selector, property, expected, message) {
    var actual = normalize(cssValue(selector, property));
    assert(actual === normalize(expected), message || "'" + selector + "' should have " + property + ": " + expected + ", but it computes to " + actual + ".");
  }

  function resolveColor(value) {
    var probe = document.createElement("span");
    probe.style.color = value;
    document.body.appendChild(probe);
    var resolved = getComputedStyle(probe).color;
    probe.remove();
    return resolved;
  }

  function assertColor(selector, property, expected, message) {
    var actual = cssValue(selector, property);
    var wanted = resolveColor(expected);
    assert(actual === wanted, message || "'" + selector + "' should have " + property + ": " + expected + ", but it computes to " + actual + ".");
  }

  function assertVisible(selector, message) {
    var el = query(selector);
    var style = getComputedStyle(el);
    var box = el.getBoundingClientRect();
    assert(
      style.display !== "none" && style.visibility !== "hidden" && Number(style.opacity) !== 0 && box.width > 0 && box.height > 0,
      message || "'" + selector + "' should be visible on the page."
    );
  }

  function assertNoOverflow(message) {
    var root = document.documentElement;
    assert(root.scrollWidth <= window.innerWidth + 1, message || "The page should not scroll sideways.");
  }

  function assertFocusable(selector, message) {
    var el = query(selector);
    assert(!el.disabled && el.tabIndex >= 0, message || "'" + selector + "' should be reachable with the Tab key.");
  }

  var helpers = {
    assert: assert,
    query: query,
    assertExists: assertExists,
    assertNotExists: assertNotExists,
    assertCount: assertCount,
    assertText: assertText,
    assertAttr: assertAttr,
    assertStyle: assertStyle,
    assertColor: assertColor,
    assertVisible: assertVisible,
    assertNoOverflow: assertNoOverflow,
    assertFocusable: assertFocusable,
    normalize: normalize
  };

  // Do not wait on requestAnimationFrame here: checks run in a hidden iframe,
  // where rAF may be throttled or paused. A zero-delay task is enough for the
  // parsed HTML and stylesheet to be laid out, and font loading is raced with
  // a short timeout so a missing font can never hang the check.
  Promise.resolve()
    .then(function () {
      return new Promise(function (resolve) {
        setTimeout(resolve, 0);
      });
    })
    .then(function () {
      var fonts = document.fonts && document.fonts.ready;
      if (!fonts) return undefined;
      return Promise.race([fonts, new Promise(function (resolve) { setTimeout(resolve, 250); })]);
    })
    .then(function () {
      var keys = Object.keys(helpers);
      var values = keys.map(function (key) { return helpers[key]; });
      var fn = new Function(keys.join(","), "return (async function () {\n" + test + "\n})();");
      return fn.apply(null, values);
    })
    .then(function () {
      finish({ passed: true, message: null });
    })
    .catch(function (error) {
      finish({ passed: false, message: error && error.message ? error.message : String(error) });
    });
})();
`;

/** Builds a self-checking document whose result lands on window.__latentResult. */
export function buildHtmlTestDocument(code: string, test: string) {
  const document = buildHtmlDocument(code, { sanitize: true, csp: false });
  const data = JSON.stringify(test).replace(/</g, "\\u003c");
  const payload = `<script id="latent-test" type="application/json">${data}</script><script>${RUNNER}</script>`;
  if (/<\/body\s*>/i.test(document)) return document.replace(/<\/body\s*>/i, `${payload}</body>`);
  return `${document}${payload}`;
}
