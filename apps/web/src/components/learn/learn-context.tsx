"use client";

import { createContext, useContext } from "react";
import type { LearnCourse } from "@latent/shared";
import type { ChatMessage, PlayerApi, ProgressResult } from "./types";

export interface LearnContextValue {
  slug: string;
  course: LearnCourse;
  activeLessonId: string | null;
  /** Applies a progress response: updates sidebar checks and triggers the completion celebration. */
  handleProgress: (lessonId: string, result: ProgressResult) => void;
  /** Imperative handle to the active video player (for notes timestamps). */
  player: React.MutableRefObject<PlayerApi | null>;
  tutorOpen: boolean;
  openTutor: (prompt?: string) => void;
  closeTutor: () => void;
  chats: Record<string, ChatMessage[]>;
  setChat: (key: string, updater: (prev: ChatMessage[]) => ChatMessage[]) => void;
  pendingPrompt: string | null;
  clearPendingPrompt: () => void;
}

export const LearnContext = createContext<LearnContextValue | null>(null);

export function useLearn() {
  const ctx = useContext(LearnContext);
  if (!ctx) throw new Error("useLearn must be used inside <LearnShell>");
  return ctx;
}
