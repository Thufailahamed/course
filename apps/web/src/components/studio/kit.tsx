"use client";

import { useEffect, useRef, useState } from "react";
import { ArrowDownRight, ArrowUpRight, ChevronLeft, ChevronRight, Lock, Plus, Trash2, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input, Textarea } from "@/components/ui/input";
import { Markdown } from "@/components/markdown";
import { EmptyState } from "@/components/ui/display";
import { Dialog, DialogContent } from "@/components/ui/primitives";
import type { CourseStatus } from "@latent/shared";
import { Badge } from "@/components/ui/primitives";
import { cn, formatPrice } from "@/lib/utils";
import { useStudioUser } from "./shell";

/* ── Page header ────────────────────────────────────────── */

export function PageHeader({ title, description, actions, className }: { title: React.ReactNode; description?: React.ReactNode; actions?: React.ReactNode; className?: string }) {
  return (
    <div className={cn("mb-7 flex flex-col gap-4 border-b border-border pb-6 sm:mb-8 sm:flex-row sm:items-end sm:justify-between", className)}>
      <div className="min-w-0">
        <h1 className="text-[1.5rem] leading-tight tracking-[-0.025em] sm:text-[1.6rem]">{title}</h1>
        {description && <p className="mt-2 text-sm text-muted-foreground">{description}</p>}
      </div>
      {actions && <div className="flex shrink-0 flex-wrap items-center gap-2">{actions}</div>}
    </div>
  );
}

/* ── Tables ─────────────────────────────────────────────── */

export function TableCard({ children, className, toolbar, footer }: { children: React.ReactNode; className?: string; toolbar?: React.ReactNode; footer?: React.ReactNode }) {
  return (
    <div className={cn("card overflow-hidden", className)}>
      {toolbar && <div className="flex flex-col gap-3 border-b border-border px-4 py-3 sm:flex-row sm:items-center">{toolbar}</div>}
      <div className="max-h-[70vh] overflow-auto">{children}</div>
      {footer && <div className="border-t border-border px-4 py-3">{footer}</div>}
    </div>
  );
}

export function Table({ children, className }: { children: React.ReactNode; className?: string }) {
  return <table className={cn("w-full min-w-[720px] border-collapse text-[13px]", className)}>{children}</table>;
}

export function Th({ children, className, align = "left" }: { children?: React.ReactNode; className?: string; align?: "left" | "right" | "center" }) {
  return (
    <th
      className={cn(
        "sticky top-0 z-[1] whitespace-nowrap border-b border-border bg-surface-2 px-4 py-2.5 text-xs font-medium text-muted-foreground",
        { left: "text-left", right: "text-right", center: "text-center" }[align],
        className,
      )}
    >
      {children}
    </th>
  );
}

export function Td({ children, className, align = "left", colSpan }: { children?: React.ReactNode; className?: string; align?: "left" | "right" | "center"; colSpan?: number }) {
  return (
    <td colSpan={colSpan} className={cn("border-b border-border px-4 py-3 align-middle", { left: "text-left", right: "text-right tabular-nums", center: "text-center" }[align], className)}>
      {children}
    </td>
  );
}

export function Tr({ children, className, onClick }: { children: React.ReactNode; className?: string; onClick?: () => void }) {
  return (
    <tr onClick={onClick} className={cn("transition-colors hover:bg-surface-2/50 [&:last-child>td]:border-b-0", onClick && "cursor-pointer", className)}>
      {children}
    </tr>
  );
}

export function SkeletonRows({ cols, rows = 6 }: { cols: number; rows?: number }) {
  return (
    <>
      {Array.from({ length: rows }, (_, r) => (
        <tr key={r}>
          {Array.from({ length: cols }, (_, c) => (
            <td key={c} className="border-b border-border px-4 py-3.5">
              <div className={cn("skeleton h-4", c === 0 ? "w-48" : "w-16")} />
            </td>
          ))}
        </tr>
      ))}
    </>
  );
}

export function EmptyRow({ cols, title, description, icon }: { cols: number; title: string; description?: string; icon?: React.ReactNode }) {
  return (
    <tr>
      <td colSpan={cols} className="p-6">
        <EmptyState title={title} description={description} icon={icon} className="border-0 py-10" />
      </td>
    </tr>
  );
}

export function Pagination({ page, pageCount, total, onPage, label = "results" }: { page: number; pageCount: number; total: number; onPage: (p: number) => void; label?: string }) {
  return (
    <div className="flex items-center justify-between gap-3 text-sm">
      <span className="text-subtle-foreground">
        <span className="tabular-nums text-muted-foreground">{total.toLocaleString()}</span> {label}
      </span>
      <div className="flex items-center gap-2">
        <span className="tabular-nums text-subtle-foreground">
          Page {page} of {pageCount}
        </span>
        <Button variant="secondary" size="icon-sm" disabled={page <= 1} onClick={() => onPage(page - 1)} aria-label="Previous page">
          <ChevronLeft />
        </Button>
        <Button variant="secondary" size="icon-sm" disabled={page >= pageCount} onClick={() => onPage(page + 1)} aria-label="Next page">
          <ChevronRight />
        </Button>
      </div>
    </div>
  );
}

/* ── Filter tabs (segmented) ────────────────────────────── */

export function Segmented<T extends string>({ value, onChange, options, className }: { value: T; onChange: (v: T) => void; options: { value: T; label: React.ReactNode }[]; className?: string }) {
  return (
    <div role="tablist" className={cn("inline-flex w-fit items-center gap-0.5 rounded-lg border border-border bg-surface-2 p-0.5", className)}>
      {options.map((o) => (
        <button
          key={o.value}
          role="tab"
          aria-selected={o.value === value}
          onClick={() => onChange(o.value)}
          className={cn(
            "inline-flex h-7 items-center gap-1.5 whitespace-nowrap rounded-md px-3 text-[13px] font-medium transition-colors",
            o.value === value ? "bg-surface text-foreground shadow-[0_0_0_1px_var(--border),0_1px_2px_0_oklch(0.2_0.01_265/0.08)]" : "text-muted-foreground hover:text-foreground",
          )}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

/* ── Debounced value ────────────────────────────────────── */

export function useDebounced<T>(value: T, ms = 250) {
  const [v, setV] = useState(value);
  useEffect(() => {
    const t = setTimeout(() => setV(value), ms);
    return () => clearTimeout(t);
  }, [value, ms]);
  return v;
}

/* ── Confirm dialog ─────────────────────────────────────── */

export function ConfirmDialog({
  open,
  onOpenChange,
  title,
  description,
  confirmLabel = "Confirm",
  danger = true,
  loading,
  onConfirm,
}: {
  open: boolean;
  onOpenChange: (o: boolean) => void;
  title: string;
  description?: React.ReactNode;
  confirmLabel?: string;
  danger?: boolean;
  loading?: boolean;
  onConfirm: () => void;
}) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent size="sm" title={title} description={description}>
        <div className="flex justify-end gap-2">
          <Button variant="secondary" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button variant={danger ? "danger" : "primary"} loading={loading} onClick={onConfirm}>
            {confirmLabel}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}

/** Small hook bundling confirm-dialog state with the pending target. */
export function useConfirm<T>() {
  const [target, setTarget] = useState<T | null>(null);
  return { target, open: target !== null, ask: (t: T) => setTarget(t), close: () => setTarget(null) };
}

/* ── KPI tile with delta vs previous period ─────────────── */

export function Kpi({ label, value, current, previous, periodLabel, icon, loading }: { label: string; value: React.ReactNode; current?: number; previous?: number; periodLabel?: string; icon?: React.ReactNode; loading?: boolean }) {
  let delta: number | null = null;
  if (current !== undefined && previous !== undefined) delta = previous === 0 ? (current > 0 ? 100 : 0) : ((current - previous) / previous) * 100;
  const up = (delta ?? 0) >= 0;
  return (
    <div className="card p-5">
      <div className="flex items-center justify-between text-[13px] font-medium text-muted-foreground">
        <span>{label}</span>
        {icon && <span className="flex size-7 items-center justify-center rounded-md border border-border bg-surface-2 text-muted-foreground [&_svg]:size-3.5">{icon}</span>}
      </div>
      {loading ? <div className="skeleton mt-3 h-8 w-28" /> : <div className="mt-3 text-[1.75rem] font-semibold leading-none tabular-nums tracking-[-0.03em]">{value}</div>}
      {delta !== null && !loading && (
        <div className="mt-3 flex items-center gap-1.5 text-xs">
          <span className={cn("inline-flex items-center gap-0.5 font-medium tabular-nums", up ? "text-success" : "text-danger")}>
            {up ? <ArrowUpRight className="size-3" /> : <ArrowDownRight className="size-3" />}
            {up ? "+" : ""}
            {delta.toFixed(Math.abs(delta) < 10 ? 1 : 0)}%
          </span>
          <span className="text-subtle-foreground">{periodLabel}</span>
        </div>
      )}
    </div>
  );
}

/* ── String list editor ─────────────────────────────────── */

export function ListEditor({ value, onChange, placeholder, max = 30 }: { value: string[]; onChange: (v: string[]) => void; placeholder?: string; max?: number }) {
  const [draft, setDraft] = useState("");
  const add = () => {
    const v = draft.trim();
    if (!v || value.length >= max) return;
    onChange([...value, v]);
    setDraft("");
  };
  return (
    <div className="space-y-2">
      {value.map((item, i) => (
        <div key={i} className="group flex items-center gap-2">
          <span className="w-5 shrink-0 text-right text-xs tabular-nums text-subtle-foreground">{i + 1}.</span>
          <Input value={item} onChange={(e) => onChange(value.map((x, j) => (j === i ? e.target.value : x)))} className="h-10" />
          <Button type="button" variant="ghost" size="icon-sm" onClick={() => onChange(value.filter((_, j) => j !== i))} aria-label="Remove item">
            <X />
          </Button>
        </div>
      ))}
      <div className="flex items-center gap-2">
        <Input
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              e.preventDefault();
              add();
            }
          }}
          placeholder={placeholder}
          className="h-10"
        />
        <Button type="button" variant="secondary" size="sm" onClick={add} disabled={!draft.trim()}>
          <Plus /> Add
        </Button>
      </div>
    </div>
  );
}

/* ── Tag input ──────────────────────────────────────────── */

export function TagInput({ value, onChange, max = 12 }: { value: string[]; onChange: (v: string[]) => void; max?: number }) {
  const [draft, setDraft] = useState("");
  const commit = () => {
    const v = draft.trim().replace(/,$/, "");
    if (v && !value.includes(v) && value.length < max) onChange([...value, v]);
    setDraft("");
  };
  return (
    <div className="flex min-h-11 flex-wrap items-center gap-1.5 rounded-lg border border-input bg-surface px-2 py-1.5 focus-within:border-accent focus-within:ring-[3px] focus-within:ring-accent-soft">
      {value.map((t) => (
        <span key={t} className="inline-flex h-7 items-center gap-1 rounded-md border border-border bg-surface-2 pl-2.5 pr-1 text-xs font-medium">
          {t}
          <button type="button" onClick={() => onChange(value.filter((x) => x !== t))} className="rounded p-0.5 text-subtle-foreground hover:text-foreground" aria-label={`Remove ${t}`}>
            <X className="size-3" />
          </button>
        </span>
      ))}
      <input
        value={draft}
        onChange={(e) => setDraft(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter" || e.key === ",") {
            e.preventDefault();
            commit();
          } else if (e.key === "Backspace" && !draft && value.length) onChange(value.slice(0, -1));
        }}
        onBlur={commit}
        placeholder={value.length ? "" : "Add a tag and press Enter"}
        className="h-7 min-w-24 flex-1 bg-transparent px-1 text-sm outline-none placeholder:text-subtle-foreground"
      />
    </div>
  );
}

/* ── Markdown editor with preview ───────────────────────── */

export function MarkdownEditor({ value, onChange, rows = 14, placeholder }: { value: string; onChange: (v: string) => void; rows?: number; placeholder?: string }) {
  const [mode, setMode] = useState<"write" | "preview" | "split">("write");
  const ref = useRef<HTMLTextAreaElement>(null);
  return (
    <div className="overflow-hidden rounded-[10px] border border-input bg-surface">
      <div className="flex items-center justify-between border-b border-border bg-surface-2 px-2 py-1.5">
        <Segmented
          value={mode}
          onChange={setMode}
          className="border-0 bg-transparent p-0"
          options={[
            { value: "write", label: "Write" },
            { value: "preview", label: "Preview" },
            { value: "split", label: <span className="hidden sm:inline">Split</span> },
          ]}
        />
        <span className="px-2 text-xs text-subtle-foreground">Markdown, KaTeX and code supported</span>
      </div>
      <div className={cn("grid", mode === "split" && "md:grid-cols-2")}>
        {mode !== "preview" && (
          <Textarea
            ref={ref}
            value={value}
            onChange={(e) => onChange(e.target.value)}
            rows={rows}
            placeholder={placeholder}
            className="min-h-64 rounded-none border-0 font-mono text-[13px] shadow-none focus:ring-0"
          />
        )}
        {mode !== "write" && (
          <div className={cn("max-h-[560px] min-h-64 overflow-y-auto p-5", mode === "split" && "border-t border-border md:border-l md:border-t-0")}>
            {value.trim() ? <Markdown size="sm">{value}</Markdown> : <p className="text-sm text-subtle-foreground">Nothing to preview yet.</p>}
          </div>
        )}
      </div>
    </div>
  );
}

/* ── Admin-only gate for instructor accounts ────────────── */

export function AdminOnly({ children }: { children: React.ReactNode }) {
  const { isAdmin } = useStudioUser();
  if (isAdmin) return <>{children}</>;
  return <EmptyState icon={<Lock />} title="Admins only" description="This area is limited to platform administrators. Ask an admin if you need access." className="mt-10" />;
}

export function IconDelete({ onClick, label = "Delete" }: { onClick: () => void; label?: string }) {
  return (
    <Button variant="ghost" size="icon-sm" onClick={onClick} aria-label={label} className="hover:bg-danger-soft hover:text-danger">
      <Trash2 />
    </Button>
  );
}

/** Dollars input ↔ cents value. */
export function MoneyInput({ cents, onChange, ...props }: { cents: number | null; onChange: (c: number | null) => void } & Omit<React.InputHTMLAttributes<HTMLInputElement>, "onChange" | "value">) {
  const [text, setText] = useState(cents === null ? "" : (cents / 100).toFixed(2));
  useEffect(() => {
    const parsed = text === "" ? null : Math.round(Number(text) * 100);
    if (parsed !== cents) setText(cents === null ? "" : (cents / 100).toFixed(2));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cents]);
  return (
    <div className="relative">
      <span className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-sm text-subtle-foreground">$</span>
      <Input
        inputMode="decimal"
        value={text}
        onChange={(e) => {
          const t = e.target.value.replace(/[^0-9.]/g, "");
          setText(t);
          onChange(t === "" ? null : Math.round(Number(t) * 100));
        }}
        onBlur={() => setText(cents === null ? "" : (cents / 100).toFixed(2))}
        className="pl-7 tabular-nums"
        {...props}
      />
    </div>
  );
}

/** Downloads rows as a CSV file. */
export function downloadCsv(filename: string, rows: (string | number | null | undefined)[][]) {
  const esc = (v: string | number | null | undefined) => {
    const s = v === null || v === undefined ? "" : String(v);
    return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  const blob = new Blob([rows.map((r) => r.map(esc).join(",")).join("\n")], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

/* ── Course status badge ────────────────────────────────── */

export function StatusBadge({ status }: { status: CourseStatus }) {
  const map = { published: ["success", "Published"], draft: ["warning", "Draft"], archived: ["default", "Archived"] } as const;
  const [variant, label] = map[status];
  return (
    <Badge variant={variant} size="sm">
      <span className="size-1.5 rounded-full bg-current" />
      {label}
    </Badge>
  );
}

/** Money for reporting: unlike formatPrice, zero renders as $0 rather than "Free". */
export function money(cents: number, currency = "USD") {
  return cents === 0 ? formatPrice(1, currency).replace(/[d.,]+/, "0") : formatPrice(cents, currency);
}
