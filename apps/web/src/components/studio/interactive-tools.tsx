"use client";

import { useState } from "react";
import { Bug, CheckCircle2, CircleAlert, Eye, FlaskConical, HelpCircle, Play, ShieldCheck, Target, XCircle } from "lucide-react";
import { lessonCells, type LessonCell } from "@latent/shared";
import { InteractiveLesson } from "@/components/code/interactive-lesson";
import { getRuntime, type RunResult } from "@/components/code/runtime";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";

type Template = { label: string; icon: typeof Play; snippet: string };

const PYTHON_TEMPLATES: Template[] = [
  { label: "Code cell", icon: Play, snippet: "```python run\nimport numpy as np\n\na = np.arange(5)\na\n```" },
  {
    label: "Challenge",
    icon: Target,
    snippet:
      '```python exercise id=my-challenge title="Describe the task"\n# Starter code shown to the learner\nresult = ...\n--- solution\nresult = np.arange(5)\n--- test\nassert isinstance(result, np.ndarray), "result should be a NumPy array"\nassert result.tolist() == [0, 1, 2, 3, 4], "result should contain 0..4"\n--- hint\nLook at `np.arange`.\n```',
  },
  {
    label: "Debug challenge",
    icon: Bug,
    snippet:
      '```python debug id=my-bug title="Fix the bug"\nscores = np.array([3, 4, 5])\nmean = scores.sum() / len(scores) + 1\n--- solution\nscores = np.array([3, 4, 5])\nmean = scores.sum() / len(scores)\n--- test\nassert mean == 4, "mean should be 4.0"\n--- hint\nWhat is the extra `+ 1` doing?\n```',
  },
  {
    label: "Predict",
    icon: HelpCircle,
    snippet: '```python predict id=my-predict title="What is the shape?"\na = np.zeros((2, 3))\nprint(a.T.shape)\n--- options\n(2, 3)\n* (3, 2)\n(6,)\n--- explain\n`.T` reverses the axes.\n```',
  },
  { label: "Setup", icon: FlaskConical, snippet: "```python setup\nrng = np.random.default_rng(0)\ndata = rng.normal(size=100)\n```" },
];

const HTML_TEMPLATES: Template[] = [
  {
    label: "Code cell",
    icon: Play,
    snippet:
      '```html run\n<section class="card">\n  <h2>Hello, web</h2>\n  <p>Every page starts with a few honest elements.</p>\n</section>\n<style>\n  .card { max-width: 28rem; padding: 1.5rem; border: 1px solid #d8dee9; border-radius: 12px; }\n</style>\n```',
  },
  {
    label: "Challenge",
    icon: Target,
    snippet:
      '```html exercise id=my-challenge title="Describe the task"\n<article class="card">\n  <h2>Starter markup</h2>\n</article>\n<style>\n  /* TODO: style the card */\n</style>\n--- solution\n<article class="card">\n  <h2>Starter markup</h2>\n</article>\n<style>\n  .card { padding: 24px; border-radius: 12px; background: #f8fafc; }\n</style>\n--- test\nassertExists(".card", "Add an element with class card");\nassertStyle(".card", "border-radius", "12px");\n--- hint\nApply the styles to the class selector `.card`.\n```',
  },
  {
    label: "Debug challenge",
    icon: Bug,
    snippet:
      '```html debug id=my-bug title="Fix the layout"\n<div class="row">\n  <div>One</div>\n  <div>Two</div>\n</div>\n<style>\n  .row { display: flex; flex-direction: column; }\n</style>\n--- solution\n<div class="row">\n  <div>One</div>\n  <div>Two</div>\n</div>\n<style>\n  .row { display: flex; flex-direction: row; gap: 12px; }\n</style>\n--- test\nassertStyle(".row", "display", "flex");\nassertStyle(".row", "flex-direction", "row");\n--- hint\nWhich flex direction places items side by side?\n```',
  },
  {
    label: "Predict",
    icon: HelpCircle,
    snippet:
      '```html predict id=my-predict title="How will this render?"\n<div class="box">A</div>\n<div class="box">B</div>\n<style>\n  .box { display: inline-block; padding: 8px; }\n</style>\n--- options\n* The boxes sit on the same line\nEach box takes the full width\nNothing renders\n--- explain\n`inline-block` keeps elements in the inline flow while allowing padding and width.\n```',
  },
];

function templatesFor(language: string) {
  return language === "html" ? HTML_TEMPLATES : PYTHON_TEMPLATES;
}

export function InteractiveAuthoring({ content, onChange, lessonId }: { content: string; onChange: (v: string) => void; lessonId: string }) {
  const [preview, setPreview] = useState(false);
  const cells = lessonCells(content);
  const language = cells.find((c) => c.kind !== "setup")?.language ?? "python";
  const templates = templatesFor(language);
  const counts = {
    run: cells.filter((c) => c.kind === "run").length,
    challenges: cells.filter((c) => c.kind === "exercise" || c.kind === "debug").length,
    predict: cells.filter((c) => c.kind === "predict").length,
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-1.5">
        <span className="mr-1 text-xs font-medium text-muted-foreground">Insert</span>
        {templates.map((t) => (
          <Button key={t.label} size="xs" variant="secondary" onClick={() => onChange(`${content.trimEnd()}\n\n${t.snippet}\n`)}>
            <t.icon /> {t.label}
          </Button>
        ))}
        <Button size="xs" className="ml-auto" onClick={() => setPreview(true)}>
          <Eye /> Preview & run
        </Button>
      </div>
      <div className="flex flex-wrap gap-x-4 gap-y-1 text-xs text-subtle-foreground">
        <span>{counts.run} code cells</span>
        <span>{counts.challenges} challenges</span>
        <span>{counts.predict} predict questions</span>
      </div>
      <Validator content={content} lessonId={lessonId} />
      <details className="rounded-xl border border-border bg-surface-2/50 px-4 py-3 text-[13px] text-muted-foreground">
        <summary className="cursor-pointer font-medium text-foreground">Cell syntax reference</summary>
        <div className="mt-3 space-y-2 leading-relaxed">
          <p>
            Write Markdown as usual. Fenced blocks opened with <code className="font-mono">```python run|setup|exercise|debug|predict</code>, <code className="font-mono">```js …</code> or <code className="font-mono">```html …</code> become live cells. Attributes: <code className="font-mono">id=</code> (stable, required for challenges), <code className="font-mono">title=&quot;…&quot;</code>, the flag{" "}
            <code className="font-mono">error</code> for example cells that raise on purpose, and <code className="font-mono">class</code> for Java cells that contain a complete source file. Keep one language per lesson.
          </p>
          <p>
            Inside a cell, <code className="font-mono">--- solution</code>, <code className="font-mono">--- test</code>, <code className="font-mono">--- hint</code> (repeatable), <code className="font-mono">--- options</code> (prefix the correct line with <code className="font-mono">* </code>) and{" "}
            <code className="font-mono">--- explain</code> start sections. Tests are Python <code className="font-mono">assert</code> statements with friendly messages; they can read <code className="font-mono">_stdout</code>. HTML tests are JavaScript and run against the rendered page
            with <code className="font-mono">assert</code>, <code className="font-mono">assertExists</code>, <code className="font-mono">assertText</code>, <code className="font-mono">assertStyle</code> and friends.
          </p>
          <p>Example cells share one kernel in order. Challenges and predictions run in a fresh namespace after the setup cells. Learners never receive solutions until they ask for them.</p>
        </div>
      </details>
      <Dialog open={preview} onOpenChange={setPreview}>
        <DialogContent size="xl" title="Learner preview" description="Exactly what learners see. Attempts aren't saved." className="p-0">
          <div className="max-h-[75vh] overflow-y-auto px-4 sm:px-8">
            {preview && <InteractiveLesson scope={`studio:${lessonId}`} content={content} exercises={null} submit={async () => {}} getSolution={async (c) => c.solution ?? ""} />}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

type Finding = { cell: string; ok: boolean; message: string };

const outputOf = (r: RunResult) =>
  [r.stdout.replace(/\s+$/, ""), r.value?.repr ?? ""]
    .filter(Boolean)
    .join("\n")
    .split("\n")
    .map((l) => l.trimEnd())
    .join("\n")
    .trim();

async function validate(content: string, lessonId: string): Promise<Finding[]> {
  const cells = lessonCells(content);
  const language = cells.find((c) => c.kind !== "setup")?.language ?? "python";
  const isHtml = language === "html";
  const rt = getRuntime(language);
  const setup = cells.filter((c) => c.kind === "setup").map((c) => c.code);
  await rt.attach(`validate:${lessonId}:${Date.now()}`, setup);
  const findings: Finding[] = [];
  const label = (c: LessonCell) => c.title ?? c.id;
  const ids = new Set<string>();
  for (const c of cells) {
    if (ids.has(c.id)) findings.push({ cell: c.id, ok: false, message: `Duplicate cell id "${c.id}"` });
    ids.add(c.id);
    if (c.kind === "run") {
      const r = await rt.run(c.id, c.code, { body: c.body });
      if (c.expectError) findings.push({ cell: label(c), ok: !r.ok, message: r.ok ? "Marked `error` but ran without raising" : `Raises ${r.error?.ename} as intended` });
      else findings.push({ cell: label(c), ok: r.ok, message: r.ok ? "Runs cleanly" : `${r.error?.ename}: ${r.error?.evalue}` });
    } else if (c.kind === "exercise" || c.kind === "debug") {
      if (!c.test) {
        findings.push({ cell: label(c), ok: false, message: "Missing `--- test` section" });
        continue;
      }
      if (!c.solution) findings.push({ cell: label(c), ok: false, message: "Missing `--- solution` section" });
      else {
        const s = await rt.check(c.id, c.solution, c.test, { body: c.body });
        findings.push({ cell: label(c), ok: !!s.passed, message: s.passed ? "Solution passes the tests" : `Solution fails: ${s.message ?? s.error?.evalue}` });
      }
      const starter = await rt.check(c.id, c.code, c.test, { body: c.body });
      findings.push({ cell: label(c), ok: !starter.passed, message: starter.passed ? "Starter code already passes; tighten the tests" : "Starter code fails, as it should" });
    } else if (c.kind === "predict") {
      const correct = c.options.filter((o) => o.correct);
      if (correct.length !== 1) {
        findings.push({ cell: label(c), ok: false, message: "Mark exactly one option with `* `" });
        continue;
      }
      if (isHtml) {
        const r = await rt.run(c.id, c.code, { fresh: true, body: c.body });
        findings.push({ cell: label(c), ok: r.ok && !!r.previewHtml, message: r.ok ? "Preview renders for the predict question" : r.message || `${r.error?.ename}: ${r.error?.evalue}` });
        continue;
      }
      const r = await rt.run(c.id, c.code, { fresh: true, body: c.body });
      const actual = outputOf(r);
      findings.push({ cell: label(c), ok: r.ok && actual === correct[0]!.text.trim(), message: r.ok ? (actual === correct[0]!.text.trim() ? "Correct option matches the real output" : `Real output is "${actual}"`) : r.message || `${r.error?.ename}: ${r.error?.evalue}` });
    }
  }
  return findings;
}

function Validator({ content, lessonId }: { content: string; lessonId: string }) {
  const [state, setState] = useState<{ running: boolean; findings: Finding[] | null }>({ running: false, findings: null });
  const failures = state.findings?.filter((f) => !f.ok) ?? [];
  return (
    <div className="rounded-xl border border-border">
      <div className="flex items-center gap-3 px-4 py-3">
        <ShieldCheck className="size-4 text-subtle-foreground" />
        <div className="min-w-0 flex-1">
          <p className="text-sm font-medium">Validate lesson</p>
          <p className="text-xs text-muted-foreground">Runs every cell, checks each solution passes and each starter fails, and verifies predict answers against real output.</p>
        </div>
        <Button size="sm" variant="secondary" loading={state.running} onClick={async () => {
          setState({ running: true, findings: null });
          try {
            setState({ running: false, findings: await validate(content, lessonId) });
          } catch {
            setState({ running: false, findings: [{ cell: "runtime", ok: false, message: "The runtime failed to start" }] });
          }
        }}>
          Validate
        </Button>
      </div>
      {state.findings && (
        <div className="border-t border-border px-4 py-3">
          <p className={cn("mb-2 flex items-center gap-2 text-sm font-medium", failures.length ? "text-danger" : "text-success")}>
            {failures.length ? <CircleAlert className="size-4" /> : <CheckCircle2 className="size-4" />}
            {failures.length ? `${failures.length} problem${failures.length > 1 ? "s" : ""} found` : `All ${state.findings.length} checks passed`}
          </p>
          <ul className="max-h-64 space-y-1 overflow-y-auto text-[12.5px]">
            {state.findings.map((f, i) => (
              <li key={i} className="flex items-start gap-2">
                {f.ok ? <CheckCircle2 className="mt-0.5 size-3.5 shrink-0 text-success" /> : <XCircle className="mt-0.5 size-3.5 shrink-0 text-danger" />}
                <span className="min-w-0">
                  <span className="font-mono text-foreground">{f.cell}</span> <span className="text-muted-foreground">· {f.message}</span>
                </span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
