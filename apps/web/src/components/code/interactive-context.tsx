"use client";

import { createContext, useCallback, useContext, useEffect, useRef, useState } from "react";
import type { CellLanguage, ExerciseState, LessonCell } from "@latent/shared";

export interface InteractiveContextValue {
  /** Scopes drafts and the kernel; a lesson id, or a studio preview key. */
  scope: string;
  /** Language of every cell in this lesson. */
  language: CellLanguage;
  exercises: Record<string, ExerciseState>;
  /** Persists a challenge attempt (no-op when the viewer can't save, e.g. previews). */
  submit: (cellId: string, code: string, passed: boolean) => Promise<void>;
  getSolution: (cell: LessonCell) => Promise<string>;
  /** Opens the AI tutor with a prompt; absent where there is no tutor. */
  explain?: (prompt: string) => void;
  /** `run` cells register so "Run all" can execute them in order. */
  register: (cellId: string, run: () => Promise<boolean>) => () => void;
}

export const InteractiveContext = createContext<InteractiveContextValue | null>(null);

export function useInteractive() {
  const ctx = useContext(InteractiveContext);
  if (!ctx) throw new Error("useInteractive must be used inside an interactive lesson");
  return ctx;
}

const draftKey = (scope: string, cellId: string) => `latent-code:${scope}:${cellId}`;

/** Code state for a cell, saved to localStorage as the learner types. */
export function useDraft(scope: string, cellId: string, initial: string, saved?: string | null) {
  const [code, setCode] = useState(initial);
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);

  useEffect(() => {
    let draft: string | null = null;
    try {
      draft = localStorage.getItem(draftKey(scope, cellId));
    } catch {}
    setCode(draft ?? saved ?? initial);
    // Only on mount / cell change: later prop changes must not clobber edits.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [scope, cellId]);

  const update = useCallback(
    (next: string) => {
      setCode(next);
      clearTimeout(timer.current);
      timer.current = setTimeout(() => {
        try {
          if (next === initial) localStorage.removeItem(draftKey(scope, cellId));
          else localStorage.setItem(draftKey(scope, cellId), next);
        } catch {}
      }, 300);
    },
    [scope, cellId, initial],
  );

  return [code, update] as const;
}

/** Clips text so tutor prompts stay under the API's 4,000-character message limit. */
export function clip(text: string, max: number) {
  return text.length <= max ? text : text.slice(0, max) + "\n… (truncated)";
}

export function codePrompt(code: string, language: CellLanguage = "python") {
  return "```" + language + "\n" + clip(code.trim(), 2400) + "\n```";
}
