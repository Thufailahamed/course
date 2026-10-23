import type { LearningStats } from "@latent/shared";
import { cn } from "@/lib/utils";

const LEVELS = [0, 15, 30, 60];
const DAY_LABELS = ["", "Mon", "", "Wed", "", "Fri", ""];

function level(minutes: number, lessons: number) {
  if (!minutes && !lessons) return 0;
  if (minutes < LEVELS[1]!) return 1;
  if (minutes < LEVELS[2]!) return 2;
  if (minutes < LEVELS[3]!) return 3;
  return 4;
}

const FILL = ["var(--surface-3)", "color-mix(in oklch, var(--accent) 22%, var(--surface-2))", "color-mix(in oklch, var(--accent) 48%, var(--surface-2))", "color-mix(in oklch, var(--accent) 74%, var(--surface-2))", "var(--accent)"];

/** GitHub-style heatmap: one column per week (Sun→Sat), oldest week on the left. */
export function ActivityHeatmap({ activity, className }: { activity: LearningStats["activity"]; className?: string }) {
  if (!activity.length) return null;
  const firstDow = new Date(`${activity[0]!.date}T00:00:00Z`).getUTCDay();
  const cells: (LearningStats["activity"][number] | null)[] = [...Array(firstDow).fill(null), ...activity];
  const weeks: (typeof cells)[] = [];
  for (let i = 0; i < cells.length; i += 7) weeks.push(cells.slice(i, i + 7));

  const months: { index: number; label: string }[] = [];
  weeks.forEach((w, i) => {
    const first = w.find(Boolean);
    if (!first) return;
    const d = new Date(`${first.date}T00:00:00Z`);
    const label = d.toLocaleDateString("en-US", { month: "short", timeZone: "UTC" });
    if (!months.length || months[months.length - 1]!.label !== label) months.push({ index: i, label });
  });

  const activeDays = activity.filter((a) => a.lessons || a.minutes).length;

  return (
    <div className={cn("w-full", className)}>
      <div className="overflow-x-auto pb-1 [scrollbar-width:none]">
        <div className="inline-flex min-w-full flex-col gap-1.5">
          <div className="relative ml-8 h-4 text-[10px] text-subtle-foreground">
            {months.map((m) => (
              <span key={`${m.label}-${m.index}`} className="absolute" style={{ left: m.index * 15 }}>
                {m.label}
              </span>
            ))}
          </div>
          <div className="flex gap-[3px]">
            <div className="mr-1 flex w-7 flex-col gap-[3px] text-[10px] leading-3 text-subtle-foreground">
              {DAY_LABELS.map((d, i) => (
                <span key={i} className="h-3">
                  {d}
                </span>
              ))}
            </div>
            {weeks.map((w, wi) => (
              <div key={wi} className="flex flex-col gap-[3px]">
                {Array.from({ length: 7 }, (_, di) => {
                  const c = w[di];
                  if (!c) return <span key={di} className="size-3" />;
                  const lv = level(c.minutes, c.lessons);
                  const label = `${new Date(`${c.date}T00:00:00Z`).toLocaleDateString("en-US", { month: "short", day: "numeric", timeZone: "UTC" })}: ${
                    lv ? `${c.minutes} min, ${c.lessons} lesson${c.lessons === 1 ? "" : "s"}` : "no activity"
                  }`;
                  return <span key={di} title={label} aria-label={label} className="size-3 rounded-[2.5px] ring-inset transition-shadow hover:ring-1 hover:ring-foreground/40" style={{ background: FILL[lv] }} />;
                })}
              </div>
            ))}
          </div>
        </div>
      </div>
      <div className="mt-3 flex items-center justify-between text-[11px] text-subtle-foreground">
        <span>{activeDays} active days in the last 6 months</span>
        <span className="flex items-center gap-1">
          Less
          {FILL.map((f, i) => (
            <span key={i} className="size-2.5 rounded-[2px]" style={{ background: f }} />
          ))}
          More
        </span>
      </div>
    </div>
  );
}
