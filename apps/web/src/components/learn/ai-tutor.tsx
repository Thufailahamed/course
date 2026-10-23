"use client";

import { useEffect, useRef, useState } from "react";
import { ArrowUp, BookOpenText, Code2, Eraser, Lightbulb, Square, X } from "lucide-react";
import { Markdown } from "@/components/markdown";
import { Button } from "@/components/ui/button";
import { Tooltip } from "@/components/ui/primitives";
import { streamSSE } from "@/lib/api";
import { cn } from "@/lib/utils";
import { useLearn } from "./learn-context";
import type { ChatMessage } from "./types";

const SUGGESTIONS = [
  { icon: BookOpenText, label: "Explain this lesson simply", prompt: "Explain the key ideas of this lesson simply, with an intuitive analogy." },
  { icon: Lightbulb, label: "Quiz me", prompt: "Quiz me with 3 short questions on this lesson, one at a time. Wait for my answer before revealing each solution." },
  { icon: Code2, label: "Give me a code example", prompt: "Give me a short, well-commented Python code example that illustrates this lesson." },
];

export function AtlasAvatar({ size = 32 }: { size?: number }) {
  return (
    <span
      className="inline-flex shrink-0 select-none items-center justify-center rounded-full bg-primary font-semibold leading-none text-primary-foreground"
      style={{ width: size, height: size, fontSize: size * 0.42 }}
    >
      A
    </span>
  );
}

export function AiTutor({ lessonId, lessonTitle, onClose }: { lessonId: string | null; lessonTitle?: string; onClose: () => void }) {
  const { course, chats, setChat, pendingPrompt, clearPendingPrompt } = useLearn();
  const key = lessonId ?? "course";
  const messages = chats[key] ?? [];
  const [input, setInput] = useState("");
  const [streaming, setStreaming] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const abortRef = useRef<AbortController | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
  }, [messages]);

  // Abort an in-flight answer when switching lessons or closing.
  useEffect(() => () => abortRef.current?.abort(), [key]);

  const send = async (text: string) => {
    const content = text.trim();
    if (!content || streaming) return;
    setError(null);
    setInput("");
    const history: ChatMessage[] = [...messages, { role: "user", content }];
    setChat(key, () => [...history, { role: "assistant", content: "" }]);
    setStreaming(true);
    const ctrl = new AbortController();
    abortRef.current = ctrl;
    try {
      await streamSSE(
        `/learn/courses/${course.id}/ai`,
        { lessonId, messages: history.slice(-12) },
        (token) =>
          setChat(key, (prev) => {
            const next = [...prev];
            const last = next[next.length - 1];
            if (last?.role === "assistant") next[next.length - 1] = { ...last, content: last.content + token };
            return next;
          }),
        ctrl.signal,
      );
    } catch (e) {
      if ((e as Error).name !== "AbortError") {
        setError((e as Error).message);
        // Drop the empty assistant bubble.
        setChat(key, (prev) => (prev[prev.length - 1]?.content === "" ? prev.slice(0, -1) : prev));
      }
    } finally {
      setStreaming(false);
      abortRef.current = null;
    }
  };

  useEffect(() => {
    if (pendingPrompt) {
      clearPendingPrompt();
      void send(pendingPrompt);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pendingPrompt]);

  return (
    <div className="flex h-full flex-col bg-surface">
      <div className="flex h-14 shrink-0 items-center gap-3 border-b border-border px-4">
        <AtlasAvatar size={30} />
        <div className="min-w-0 flex-1">
          <div className="text-sm font-semibold leading-tight">Atlas</div>
          <div className="truncate text-[11.5px] text-subtle-foreground">AI teaching assistant{lessonTitle ? ` · ${lessonTitle}` : ""}</div>
        </div>
        {messages.length > 0 && (
          <Tooltip content="Clear conversation">
            <Button variant="ghost" size="icon-sm" onClick={() => setChat(key, () => [])} aria-label="Clear conversation" disabled={streaming}>
              <Eraser />
            </Button>
          </Tooltip>
        )}
        <Button variant="ghost" size="icon-sm" onClick={onClose} aria-label="Close AI tutor">
          <X />
        </Button>
      </div>

      <div ref={scrollRef} className="flex-1 space-y-5 overflow-y-auto px-4 py-5" aria-live="polite">
        {messages.length === 0 && (
          <div className="flex flex-col items-center px-2 pt-6 text-center">
            <AtlasAvatar size={52} />
            <h3 className="mt-4 text-lg font-semibold tracking-[-0.02em]">Hi, I&apos;m Atlas</h3>
            <p className="mt-2 max-w-[17rem] text-sm leading-relaxed text-muted-foreground">I know this course inside out. Ask about concepts, math, code or anything you're stuck on.</p>
            <div className="mt-7 grid w-full divide-y divide-border overflow-hidden rounded-xl border border-border bg-surface shadow-card">
              {SUGGESTIONS.map((s) => (
                <button
                  key={s.label}
                  onClick={() => send(s.prompt)}
                  className="group flex items-center gap-3 px-3.5 py-3 text-left text-sm transition-colors hover:bg-surface-2"
                >
                  <s.icon className="size-4 shrink-0 text-subtle-foreground transition-colors group-hover:text-accent" />
                  {s.label}
                </button>
              ))}
            </div>
          </div>
        )}
        {messages.map((m, i) =>
          m.role === "user" ? (
            <div key={i} className="flex justify-end">
              <div className="max-w-[85%] whitespace-pre-wrap rounded-xl rounded-br-sm bg-primary px-3.5 py-2.5 text-sm leading-relaxed text-primary-foreground">{m.content}</div>
            </div>
          ) : (
            <div key={i} className="flex gap-2.5">
              <AtlasAvatar size={26} />
              <div className="min-w-0 flex-1 rounded-xl rounded-tl-sm bg-surface-2 px-3.5 py-2.5">
                {m.content ? (
                  <Markdown size="sm" className="prose-p:my-2 prose-pre:my-3">
                    {m.content}
                  </Markdown>
                ) : (
                  <span className="inline-flex gap-1 py-1.5" aria-label="Atlas is thinking">
                    {[0, 1, 2].map((d) => (
                      <span key={d} className="size-1.5 animate-bounce rounded-full bg-subtle-foreground" style={{ animationDelay: `${d * 0.15}s` }} />
                    ))}
                  </span>
                )}
              </div>
            </div>
          ),
        )}
        {error && <div className="rounded-lg border border-danger/25 bg-danger-soft px-3.5 py-2.5 text-sm text-danger">{error}</div>}
      </div>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          void send(input);
        }}
        className="shrink-0 border-t border-border p-3"
      >
        <div className="relative rounded-xl border border-input bg-surface shadow-card transition focus-within:border-accent focus-within:ring-[3px] focus-within:ring-accent-soft">
          <textarea
            ref={inputRef}
            value={input}
            onChange={(e) => {
              setInput(e.target.value);
              e.target.style.height = "auto";
              e.target.style.height = `${Math.min(160, e.target.scrollHeight)}px`;
            }}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                void send(input);
              }
            }}
            rows={1}
            placeholder="Ask Atlas anything…"
            aria-label="Message Atlas"
            className="block max-h-40 w-full resize-none bg-transparent px-3.5 py-3 pr-12 text-sm outline-none placeholder:text-subtle-foreground"
          />
          {streaming ? (
            <button type="button" onClick={() => abortRef.current?.abort()} aria-label="Stop generating" className="absolute bottom-2 right-2 flex size-8 items-center justify-center rounded-lg bg-foreground text-background">
              <Square className="size-3 fill-current" />
            </button>
          ) : (
            <button
              type="submit"
              disabled={!input.trim()}
              aria-label="Send"
              className={cn("absolute bottom-2 right-2 flex size-8 items-center justify-center rounded-lg transition", input.trim() ? "bg-primary text-primary-foreground" : "bg-surface-3 text-subtle-foreground")}
            >
              <ArrowUp className="size-4" />
            </button>
          )}
        </div>
        <p className="mt-2 px-1 text-[11px] text-subtle-foreground">Atlas can make mistakes. Verify important details against the lesson.</p>
      </form>
    </div>
  );
}
