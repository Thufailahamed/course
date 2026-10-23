// Runs HTML & CSS lesson cells in headless Chrome. Challenge tests are the
// same JavaScript assertions learners run in the browser, so computed styles,
// layout and the DOM behave exactly as they do in the lesson.
//
// Job:    { lessons: [{ file, cells: [...] }] }
// Result: { results: [{ file, findings: [{ cell, ok, message, warn?, info? }] }] }
import { existsSync } from "node:fs";
import { buildHtmlDocument, buildHtmlTestDocument } from "../../../../packages/shared/src/html-harness.ts";

const CHECK_TIMEOUT = 6000;

function chromeCandidates() {
  const candidates = [];
  if (process.env.CHROME_PATH) candidates.push(process.env.CHROME_PATH);
  if (process.platform === "darwin") {
    candidates.push("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome");
    candidates.push("/Applications/Chromium.app/Contents/MacOS/Chromium");
  }
  if (process.platform === "linux") {
    candidates.push("/usr/bin/google-chrome", "/usr/bin/chromium", "/usr/bin/chromium-browser");
  }
  if (process.platform === "win32") {
    candidates.push("C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe");
    candidates.push("C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe");
  }
  return candidates;
}

async function launchBrowser() {
  const { chromium } = await import("playwright-core");
  const tried = [];
  for (const executablePath of chromeCandidates()) {
    if (!existsSync(executablePath)) continue;
    tried.push(executablePath);
    try {
      return await chromium.launch({ executablePath, headless: true, args: ["--disable-gpu", "--no-sandbox"] });
    } catch (error) {
      tried.push(`failed: ${error.message}`);
    }
  }
  try {
    return await chromium.launch({ headless: true, args: ["--disable-gpu", "--no-sandbox"] });
  } catch (error) {
    tried.push(`playwright default: ${error.message}`);
  }
  throw new Error(`Could not launch Chrome. Set CHROME_PATH.\n${tried.join("\n")}`);
}

async function render(page, html) {
  await page.setContent(html, { waitUntil: "load" });
  await page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(resolve))));
}

async function runTest(page, code, test) {
  await render(page, buildHtmlTestDocument(code, test));
  try {
    const handle = await page.waitForFunction(() => window.__latentResult, null, { timeout: CHECK_TIMEOUT, polling: 50 });
    return await handle.jsonValue();
  } catch {
    return { passed: false, message: "The check timed out before it produced a result." };
  }
}

const errorText = (r) => (r?.message ? r.message : "unknown error");

export async function runHtml(job) {
  const browser = await launchBrowser();
  const page = await browser.newPage({ viewport: { width: 1100, height: 900 } });
  const results = [];

  try {
    for (const lesson of job.lessons) {
      const findings = [];
      const add = (cell, ok, message, extra = {}) => findings.push({ cell, ok, message, ...extra });

      for (const c of lesson.cells) {
        const cid = c.id;
        if (c.kind === "setup") {
          add(cid, false, "HTML lessons do not use setup cells; put shared styles in each cell");
          continue;
        }
        if (c.kind === "run") {
          if (c.expectError) add(cid, false, "`error` is not supported on HTML run cells");
          else {
            await render(page, buildHtmlDocument(c.code, { csp: false }));
            const hasBody = await page.evaluate(() => document.body && document.body.childElementCount >= 0);
            add(cid, hasBody, "renders");
            if (!c.code.trim()) add(cid, false, "empty run cell");
          }
        } else if (c.kind === "exercise" || c.kind === "debug") {
          if (!c.test) {
            add(cid, false, "missing --- test");
            continue;
          }
          if (!c.solution) {
            add(cid, false, "missing --- solution");
            continue;
          }
          const solved = await runTest(page, c.solution, c.test);
          add(cid, !!solved.passed, solved.passed ? "solution passes" : `solution FAILS: ${errorText(solved)}`);
          const starter = await runTest(page, c.code, c.test);
          add(cid, !starter.passed, starter.passed ? "starter code already PASSES the tests" : "starter fails as expected");
          if (!starter.passed) findings.push({ cell: cid, ok: true, info: true, message: `starter feedback: ${errorText(starter)}` });
        } else if (c.kind === "predict") {
          const correct = c.options.filter((o) => o.correct);
          if (correct.length !== 1) add(cid, false, "needs exactly one `* ` option");
          if (c.options.length < 3) add(cid, false, "predict needs at least 3 options");
          if (!c.explain) add(cid, false, "predict needs --- explain");
          await render(page, buildHtmlDocument(c.code, { csp: false }));
          const hasPreview = await page.evaluate(() => document.body !== null);
          add(cid, hasPreview, hasPreview ? "preview renders" : "preview failed");
        }
      }
      results.push({ file: lesson.file, findings });
    }
  } finally {
    await page.close();
    await browser.close();
  }

  return { results };
}
