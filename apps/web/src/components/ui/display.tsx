import { Star } from "lucide-react";
import { cn, hueFrom, initials } from "@/lib/utils";

/* ── Avatar: image, or initials on a hue gradient derived from the name ── */

export function Avatar({ name, src, size = 36, className, ring }: { name: string; src?: string | null; size?: number; className?: string; ring?: boolean }) {
  const hue = hueFrom(name);
  const style = { width: size, height: size, fontSize: Math.max(10, size * 0.38) };
  const ringCls = ring ? "ring-2 ring-surface" : "";
  if (src) {
    // eslint-disable-next-line @next/next/no-img-element
    return <img src={src} alt={name} style={style} className={cn("shrink-0 rounded-full object-cover", ringCls, className)} />;
  }
  return (
    <span
      aria-label={name}
      style={{ ...style, background: `oklch(0.9 0.045 ${hue})`, color: `oklch(0.36 0.08 ${hue})` }}
      className={cn("inline-flex shrink-0 select-none items-center justify-center rounded-full font-semibold tracking-tight", ringCls, className)}
    >
      {initials(name)}
    </span>
  );
}

/* ── Stars ──────────────────────────────────────────────── */

export function Stars({ value, size = 14, className }: { value: number; size?: number; className?: string }) {
  return (
    <span className={cn("inline-flex items-center gap-0.5", className)} aria-label={`${value.toFixed(1)} out of 5`}>
      {[0, 1, 2, 3, 4].map((i) => {
        const fill = Math.max(0, Math.min(1, value - i));
        return (
          <span key={i} className="relative inline-block" style={{ width: size, height: size }}>
            <Star className="absolute inset-0 text-surface-3" style={{ width: size, height: size }} fill="currentColor" strokeWidth={0} />
            <span className="absolute inset-0 overflow-hidden" style={{ width: `${fill * 100}%` }}>
              <Star className="text-star" style={{ width: size, height: size }} fill="currentColor" strokeWidth={0} />
            </span>
          </span>
        );
      })}
    </span>
  );
}

export function RatingInline({ value, count, className }: { value: number; count?: number; className?: string }) {
  if (!value) return <span className={cn("text-xs text-subtle-foreground", className)}>New</span>;
  return (
    <span className={cn("inline-flex items-center gap-1.5 text-sm", className)}>
      <span className="font-semibold tabular-nums text-foreground">{value.toFixed(1)}</span>
      <Stars value={value} size={13} />
      {count !== undefined && <span className="text-xs text-subtle-foreground">({count.toLocaleString()})</span>}
    </span>
  );
}

/* ── Progress ───────────────────────────────────────────── */

export function ProgressBar({ value, className, size = "md", tone = "primary" }: { value: number; className?: string; size?: "sm" | "md" | "lg"; tone?: "primary" | "success" }) {
  const v = Math.max(0, Math.min(100, value));
  return (
    <div
      role="progressbar"
      aria-valuenow={v}
      aria-valuemin={0}
      aria-valuemax={100}
      className={cn("w-full overflow-hidden rounded-full bg-surface-3", { sm: "h-1", md: "h-1.5", lg: "h-2" }[size], className)}
    >
      <div
        className={cn(
          "h-full rounded-full transition-[width] duration-700 ease-out",
          tone === "success" || v === 100 ? "bg-success" : "bg-accent",
        )}
        style={{ width: `${v}%` }}
      />
    </div>
  );
}

export function ProgressRing({ value, size = 44, stroke = 4, className, children }: { value: number; size?: number; stroke?: number; className?: string; children?: React.ReactNode }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const v = Math.max(0, Math.min(100, value));
  return (
    <span className={cn("relative inline-flex items-center justify-center", className)} style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="var(--surface-3)" strokeWidth={stroke} />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke={v === 100 ? "var(--success)" : "var(--accent)"}
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={c - (v / 100) * c}
          className="transition-[stroke-dashoffset] duration-700 ease-out"
        />
      </svg>
      <span className="absolute inset-0 flex items-center justify-center text-[11px] font-semibold tabular-nums">{children ?? `${Math.round(v)}%`}</span>
    </span>
  );
}


/* ── Empty state ────────────────────────────────────────── */

export function EmptyState({ icon, title, description, action, className }: { icon?: React.ReactNode; title: string; description?: React.ReactNode; action?: React.ReactNode; className?: string }) {
  return (
    <div className={cn("flex flex-col items-center justify-center rounded-2xl border border-border bg-surface px-6 py-16 text-center shadow-card", className)}>
      {icon && <div className="mb-4 flex size-10 items-center justify-center rounded-lg border border-border bg-surface-2 text-muted-foreground [&_svg]:size-[18px]">{icon}</div>}
      <h3 className="text-base font-semibold tracking-tight">{title}</h3>
      {description && <p className="mt-2 max-w-sm text-sm leading-relaxed text-muted-foreground">{description}</p>}
      {action && <div className="mt-6">{action}</div>}
    </div>
  );
}

/* ── Section heading used across marketing pages ────────── */

export function SectionHeading({ eyebrow, title, description, align = "left", className, action }: { eyebrow?: string; title: React.ReactNode; description?: React.ReactNode; align?: "left" | "center"; className?: string; action?: React.ReactNode }) {
  return (
    <div className={cn("flex flex-col gap-5", align === "center" ? "items-center text-center" : "sm:flex-row sm:items-end sm:justify-between", className)}>
      <div className={cn("max-w-2xl", align === "center" && "flex flex-col items-center")}>
        {eyebrow && <p className="mb-3 text-sm font-semibold text-accent">{eyebrow}</p>}
        <h2 className="text-[1.9rem] leading-[1.12] sm:text-[2.4rem]">{title}</h2>
        {description && <p className={cn("mt-4 max-w-xl text-[15px] leading-relaxed text-muted-foreground sm:text-base", align === "center" && "mx-auto")}>{description}</p>}
      </div>
      {action && <div className="shrink-0">{action}</div>}
    </div>
  );
}

/* ── Stat tile ──────────────────────────────────────────── */

export function StatTile({ label, value, icon, hint, className }: { label: string; value: React.ReactNode; icon?: React.ReactNode; hint?: React.ReactNode; className?: string }) {
  return (
    <div className={cn("card p-5", className)}>
      <div className="flex items-center justify-between">
        <span className="text-[13px] font-medium text-muted-foreground">{label}</span>
        {icon && <span className="flex size-7 items-center justify-center rounded-full bg-surface-2 text-muted-foreground [&_svg]:size-3.5">{icon}</span>}
      </div>
      <div className="mt-3 font-display text-[1.75rem] font-semibold leading-none tabular-nums tracking-tight">{value}</div>
      {hint && <div className="mt-2 text-xs text-subtle-foreground">{hint}</div>}
    </div>
  );
}
