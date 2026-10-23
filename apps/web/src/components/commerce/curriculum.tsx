"use client";

import { useState } from "react";
import { Accordion as A } from "radix-ui";
import { ChevronDown, FileText, ListChecks, PlayCircle, SquareTerminal } from "lucide-react";
import type { CurriculumSection } from "@latent/shared";
import { cn, formatDuration, formatSeconds } from "@/lib/utils";
import { PreviewBadge } from "./course-preview";

export function Curriculum({ sections }: { sections: CurriculumSection[] }) {
  const [open, setOpen] = useState<string[]>(sections[0] ? [sections[0].id] : []);
  const total = sections.reduce((n, s) => n + s.lessons.length, 0);
  const seconds = sections.reduce((n, s) => n + s.lessons.reduce((m, l) => m + l.durationSeconds, 0), 0);
  const allOpen = open.length === sections.length;

  return (
    <div>
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2 text-sm text-muted-foreground">
        <p>
          {sections.length} sections · {total} lessons · {formatDuration(Math.round(seconds / 60))} total
        </p>
        <button onClick={() => setOpen(allOpen ? [] : sections.map((s) => s.id))} className="font-medium text-accent hover:underline">
          {allOpen ? "Collapse all" : "Expand all"}
        </button>
      </div>
      <A.Root type="multiple" value={open} onValueChange={setOpen} className="overflow-hidden rounded-xl border border-border bg-surface shadow-card">
        {sections.map((s) => {
          const secs = s.lessons.reduce((m, l) => m + l.durationSeconds, 0);
          return (
            <A.Item key={s.id} value={s.id} className="border-b border-border last:border-0">
              <A.Header>
                <A.Trigger className="group flex w-full items-center gap-4 px-5 py-4 text-left transition hover:bg-surface-2">
                  <ChevronDown className="size-4 shrink-0 text-subtle-foreground transition-transform duration-300 group-data-[state=open]:rotate-180" />
                  <span className="flex-1 text-[14.5px] font-semibold tracking-[-0.01em]">{s.title}</span>
                  <span className="hidden shrink-0 text-xs text-subtle-foreground sm:block">
                    {s.lessons.length} lessons · {formatDuration(Math.round(secs / 60))}
                  </span>
                </A.Trigger>
              </A.Header>
              <A.Content className="overflow-hidden data-[state=closed]:animate-[accordion-up_0.2s_ease-out] data-[state=open]:animate-[accordion-down_0.25s_ease-out]">
                <ul className="py-2">
                  {s.lessons.map((l) => {
                    const Icon = l.type === "video" ? PlayCircle : l.type === "quiz" ? ListChecks : l.type === "interactive" ? SquareTerminal : FileText;
                    return (
                      <li key={l.id} className="flex items-center gap-3 px-5 py-2.5 pl-12 text-sm">
                        <Icon className="size-4 shrink-0 text-subtle-foreground" />
                        <span className={cn("flex-1", l.isPreview ? "text-foreground" : "text-muted-foreground")}>{l.title}</span>
                        {l.isPreview && <PreviewBadge lessonId={l.id} />}
                        <span className="w-12 shrink-0 text-right text-xs tabular-nums text-subtle-foreground">{l.type === "quiz" ? "Quiz" : formatSeconds(l.durationSeconds)}</span>
                      </li>
                    );
                  })}
                </ul>
              </A.Content>
            </A.Item>
          );
        })}
      </A.Root>
    </div>
  );
}
