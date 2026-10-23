"use client";

import { useEffect, useRef } from "react";
import { autocompletion, closeBrackets, closeBracketsKeymap, completeFromList, completionKeymap, type CompletionContext, type CompletionResult } from "@codemirror/autocomplete";
import { defaultKeymap, history, historyKeymap, indentWithTab } from "@codemirror/commands";
import { html } from "@codemirror/lang-html";
import { java } from "@codemirror/lang-java";
import { javascript } from "@codemirror/lang-javascript";
import { globalCompletion, localCompletionSource, python } from "@codemirror/lang-python";
import { bracketMatching, HighlightStyle, indentOnInput, indentUnit, syntaxHighlighting } from "@codemirror/language";
import { highlightSelectionMatches } from "@codemirror/search";
import { Compartment, EditorState, RangeSet, StateEffect, StateField, type Extension } from "@codemirror/state";
import { Decoration, drawSelection, EditorView, gutter, GutterMarker, highlightActiveLine, keymap, lineNumbers, placeholder as placeholderExt } from "@codemirror/view";
import { tags as t } from "@lezer/highlight";
import type { CellLanguage } from "@latent/shared";
import { cn } from "@/lib/utils";
import { getRuntime } from "./runtime";

export const LANGUAGE_NAME: Record<CellLanguage, string> = { python: "Python", java: "Java", javascript: "JavaScript", c: "C", html: "HTML & CSS" };

export interface CodeEditorProps {
  value: string;
  /** Syntax mode. Python by default. */
  language?: CellLanguage;
  onChange?: (value: string) => void;
  readOnly?: boolean;
  /** Shift+Enter / Ctrl+Enter. */
  onRun?: () => void;
  /** Ctrl+Shift+Enter. */
  onCheck?: () => void;
  breakpoints?: number[];
  onToggleBreakpoint?: (line: number) => void;
  /** Line paused on in the debugger. */
  activeLine?: number | null;
  errorLine?: number | null;
  placeholder?: string;
  ariaLabel?: string;
  className?: string;
  /** Use kernel-backed autocompletion. */
  kernelCompletion?: boolean;
}

/* ── decorations ─────────────────────────────────────────── */

const setActive = StateEffect.define<number | null>();
const setError = StateEffect.define<number | null>();
const setBreakpoints = StateEffect.define<number[]>();

const activeDeco = Decoration.line({ class: "cm-debug-line" });
const errorDeco = Decoration.line({ class: "cm-error-line" });

function lineField(effect: typeof setActive, deco: Decoration) {
  return StateField.define<{ line: number | null; set: RangeSet<Decoration> }>({
    create: () => ({ line: null, set: Decoration.none }),
    update(value, tr) {
      let line = value.line;
      for (const e of tr.effects) if (e.is(effect)) line = e.value;
      if (line === value.line && !tr.docChanged) return value;
      if (line == null || line < 1 || line > tr.state.doc.lines) return { line, set: Decoration.none };
      return { line, set: Decoration.set([deco.range(tr.state.doc.line(line).from)]) };
    },
    provide: (f) => EditorView.decorations.from(f, (v) => v.set),
  });
}

const activeField = lineField(setActive, activeDeco);
const errorField = lineField(setError, errorDeco);

class BreakpointMarker extends GutterMarker {
  toDOM() {
    const el = document.createElement("span");
    el.className = "cm-bp-dot";
    return el;
  }
}
class ArrowMarker extends GutterMarker {
  toDOM() {
    const el = document.createElement("span");
    el.className = "cm-bp-arrow";
    el.textContent = "▶";
    return el;
  }
}
const bpMarker = new BreakpointMarker();
const arrowMarker = new ArrowMarker();

const breakpointField = StateField.define<number[]>({
  create: () => [],
  update(value, tr) {
    for (const e of tr.effects) if (e.is(setBreakpoints)) return e.value;
    return value;
  },
});

function breakpointGutter(toggle: React.RefObject<((line: number) => void) | undefined>) {
  return gutter({
    class: "cm-bp-gutter",
    markers: (view) => {
      const lines = new Set(view.state.field(breakpointField));
      const active = view.state.field(activeField).line;
      const marks = [];
      for (let n = 1; n <= view.state.doc.lines; n++) {
        if (n === active) marks.push(arrowMarker.range(view.state.doc.line(n).from));
        else if (lines.has(n)) marks.push(bpMarker.range(view.state.doc.line(n).from));
      }
      return RangeSet.of(marks);
    },
    initialSpacer: () => bpMarker,
    domEventHandlers: {
      mousedown(view, block) {
        if (!toggle.current) return false;
        toggle.current(view.state.doc.lineAt(block.from).number);
        return true;
      },
    },
  });
}

/* ── theme ───────────────────────────────────────────────── */

const highlight = HighlightStyle.define([
  { tag: [t.keyword, t.controlKeyword, t.operatorKeyword, t.definitionKeyword, t.moduleKeyword, t.modifier], color: "var(--code-keyword)" },
  { tag: [t.string, t.special(t.string)], color: "var(--code-string)" },
  { tag: [t.number, t.bool, t.null], color: "var(--code-number)" },
  { tag: [t.comment, t.lineComment, t.blockComment], color: "var(--code-comment)", fontStyle: "italic" },
  { tag: [t.function(t.variableName), t.function(t.propertyName)], color: "var(--code-function)" },
  { tag: [t.definition(t.variableName), t.definition(t.function(t.variableName))], color: "var(--code-function)" },
  { tag: [t.className, t.definition(t.className), t.typeName], color: "var(--code-type)" },
  { tag: t.self, color: "var(--code-keyword)", fontStyle: "italic" },
  { tag: [t.operator, t.punctuation, t.bracket, t.separator], color: "var(--code-punct)" },
  { tag: t.propertyName, color: "var(--code-property)" },
  { tag: [t.tagName], color: "var(--code-keyword)" },
  { tag: [t.attributeName], color: "var(--code-number)" },
]);

const theme = EditorView.theme(
  {
    "&": { fontSize: "13.5px", backgroundColor: "transparent", color: "var(--code-fg)" },
    "&.cm-focused": { outline: "none" },
    ".cm-scroller": { fontFamily: "var(--font-mono)", lineHeight: "1.75", overflowX: "auto", fontVariantLigatures: "contextual" },
    ".cm-content": { padding: "16px 0", caretColor: "var(--code-fg)" },
    ".cm-line": { padding: "0 20px 0 10px" },
    ".cm-gutters": { backgroundColor: "transparent", border: "none", color: "var(--code-faint)", paddingLeft: "8px" },
    ".cm-lineNumbers .cm-gutterElement": { padding: "0 6px 0 4px", minWidth: "24px", fontSize: "12px" },
    ".cm-activeLine": { backgroundColor: "var(--code-line)" },
    ".cm-activeLineGutter": { backgroundColor: "transparent", color: "var(--code-muted)" },
    ".cm-cursor": { borderLeftColor: "var(--code-fg)", borderLeftWidth: "2px" },
    "&.cm-focused .cm-selectionBackground, .cm-selectionBackground, ::selection": { backgroundColor: "oklch(0.7 0.12 255 / 0.28) !important" },
    ".cm-matchingBracket": { backgroundColor: "oklch(1 0 0 / 0.08)", outline: "1px solid oklch(1 0 0 / 0.22)", color: "inherit !important" },
    ".cm-selectionMatch": { backgroundColor: "oklch(0.8 0.12 75 / 0.16)" },
    ".cm-placeholder": { color: "var(--code-faint)" },
    ".cm-debug-line": { backgroundColor: "oklch(0.7 0.14 255 / 0.16)", boxShadow: "inset 2px 0 0 oklch(0.75 0.14 255)" },
    ".cm-error-line": { backgroundColor: "oklch(0.65 0.2 25 / 0.16)", boxShadow: "inset 2px 0 0 oklch(0.7 0.19 25)" },
    ".cm-bp-gutter": { width: "18px", cursor: "pointer" },
    ".cm-bp-gutter .cm-gutterElement": { display: "flex", alignItems: "center", justifyContent: "center" },
    ".cm-bp-dot": { display: "block", width: "9px", height: "9px", borderRadius: "999px", backgroundColor: "oklch(0.68 0.2 25)", boxShadow: "0 0 0 3px oklch(0.68 0.2 25 / 0.22)" },
    ".cm-bp-arrow": { fontSize: "9px", color: "oklch(0.78 0.14 255)", lineHeight: "1" },
    ".cm-tooltip": { border: "1px solid var(--code-border)", backgroundColor: "var(--code-bg-2)", color: "var(--code-fg)", borderRadius: "10px", boxShadow: "0 12px 32px -8px oklch(0 0 0 / 0.5)", overflow: "hidden" },
    ".cm-tooltip-autocomplete ul li": { fontFamily: "var(--font-mono)", fontSize: "12.5px", padding: "4px 10px !important" },
    ".cm-tooltip-autocomplete ul li[aria-selected]": { backgroundColor: "oklch(0.7 0.12 255 / 0.25)", color: "var(--code-fg)" },
    ".cm-completionIcon": { opacity: "0.6" },
    ".cm-completionDetail": { fontStyle: "normal", color: "var(--code-muted)", marginLeft: "8px" },
  },
  { dark: true },
);

/* ── completion ──────────────────────────────────────────── */

const JAVA_KEYWORDS = [
  "abstract", "assert", "boolean", "break", "byte", "case", "catch", "char", "class", "const", "continue", "default", "do", "double", "else", "enum", "extends", "final", "finally", "float", "for", "if", "implements", "import", "instanceof", "int", "interface", "long", "new", "package", "private", "protected", "public", "return", "short", "static", "strictfp", "super", "switch", "synchronized", "this", "throw", "throws", "transient", "try", "void", "volatile", "while",
];
const JAVA_TYPES = [
  "String", "Integer", "Long", "Double", "Boolean", "Character", "Object", "List", "ArrayList", "Map", "HashMap", "Set", "HashSet", "Collections", "Arrays", "Math", "System", "Scanner", "StringBuilder", "Exception", "RuntimeException", "Override",
];
const javaCompletions = completeFromList([
  ...JAVA_KEYWORDS.map((label) => ({ label, type: "keyword" })),
  ...JAVA_TYPES.map((label) => ({ label, type: "type" })),
]);

async function kernelSource(ctx: CompletionContext): Promise<CompletionResult | null> {
  const word = ctx.matchBefore(/[A-Za-z_][\w.]*$/);
  if (!word || (word.from === word.to && !ctx.explicit)) return null;
  const text = word.text;
  const dot = text.lastIndexOf(".");
  if (dot < 0 && text.length < 2 && !ctx.explicit) return null;
  const items = await getRuntime().complete(text);
  if (!items.length) return dot < 0 ? (globalCompletion(ctx) as CompletionResult | null) : null;
  return {
    from: word.from + dot + 1,
    options: items.map((i) => ({ label: i.label, type: i.type === "builtin" ? "function" : i.type, boost: i.label.startsWith("_") ? -10 : 0 })),
    validFor: /^\w*$/,
  };
}

/* ── component ───────────────────────────────────────────── */

export function CodeEditor({ value, language = "python", onChange, readOnly, onRun, onCheck, breakpoints, onToggleBreakpoint, activeLine = null, errorLine = null, placeholder, ariaLabel, className, kernelCompletion = true }: CodeEditorProps) {
  const host = useRef<HTMLDivElement>(null);
  const view = useRef<EditorView | null>(null);
  const handlers = useRef({ onChange, onRun, onCheck });
  handlers.current = { onChange, onRun, onCheck };
  const toggleRef = useRef(onToggleBreakpoint);
  toggleRef.current = onToggleBreakpoint;
  const readOnlyComp = useRef(new Compartment());

  useEffect(() => {
    const run = () => {
      handlers.current.onRun?.();
      return !!handlers.current.onRun;
    };
    const extensions: Extension[] = [
      breakpointField,
      activeField,
      errorField,
      ...(toggleRef.current ? [breakpointGutter(toggleRef)] : []),
      lineNumbers(),
      history(),
      drawSelection(),
      indentUnit.of("    "),
      EditorState.tabSize.of(4),
      indentOnInput(),
      bracketMatching(),
      closeBrackets(),
      highlightActiveLine(),
      highlightSelectionMatches(),
      language === "java" ? java() : language === "python" ? python() : language === "html" ? html() : javascript(),
      syntaxHighlighting(highlight),
      autocompletion({
        override:
          language === "java"
            ? [javaCompletions]
            : language === "javascript" || language === "c" || language === "html"
              ? undefined
              : kernelCompletion
              ? [kernelSource, localCompletionSource]
              : [localCompletionSource, globalCompletion],
        activateOnTyping: true,
        icons: true,
      }),
      keymap.of([
        { key: "Shift-Enter", run, preventDefault: true },
        { key: "Mod-Enter", run, preventDefault: true },
        { key: "Mod-Shift-Enter", run: () => (handlers.current.onCheck?.(), !!handlers.current.onCheck), preventDefault: true },
        ...closeBracketsKeymap,
        ...completionKeymap,
        ...defaultKeymap,
        ...historyKeymap,
        indentWithTab,
      ]),
      theme,
      readOnlyComp.current.of([EditorState.readOnly.of(!!readOnly), EditorView.editable.of(!readOnly)]),
      EditorView.updateListener.of((u) => {
        if (u.docChanged) handlers.current.onChange?.(u.state.doc.toString());
      }),
      EditorView.contentAttributes.of({ "aria-label": ariaLabel ?? `${LANGUAGE_NAME[language]} code editor`, spellcheck: "false", autocorrect: "off", autocapitalize: "off" }),
    ];
    if (placeholder) extensions.push(placeholderExt(placeholder));
    const v = new EditorView({ parent: host.current!, state: EditorState.create({ doc: value, extensions }) });
    view.current = v;
    return () => {
      v.destroy();
      view.current = null;
    };
    // The editor is created once per language; other props are synced through effects.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [language]);

  useEffect(() => {
    const v = view.current;
    if (v && v.state.doc.toString() !== value) v.dispatch({ changes: { from: 0, to: v.state.doc.length, insert: value } });
  }, [value]);

  useEffect(() => {
    view.current?.dispatch({ effects: readOnlyComp.current.reconfigure([EditorState.readOnly.of(!!readOnly), EditorView.editable.of(!readOnly)]) });
  }, [readOnly]);

  useEffect(() => {
    const v = view.current;
    if (!v) return;
    v.dispatch({ effects: [setActive.of(activeLine), setError.of(errorLine), setBreakpoints.of(breakpoints ?? [])] });
    if (activeLine && activeLine <= v.state.doc.lines) {
      const pos = v.state.doc.line(activeLine).from;
      v.dispatch({ effects: EditorView.scrollIntoView(pos, { y: "nearest" }) });
    }
  }, [activeLine, errorLine, breakpoints]);

  return <div ref={host} className={cn("code-surface min-w-0 [&_.cm-editor]:max-h-[560px]", className)} />;
}
