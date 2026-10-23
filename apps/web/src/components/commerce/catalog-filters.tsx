"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState, useTransition } from "react";
import { Dialog as D } from "radix-ui";
import { Search, SlidersHorizontal, Star, X } from "lucide-react";
import type { Category } from "@latent/shared";
import { LEVELS } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Input, Select } from "@/components/ui/input";
import { Checkbox, Dialog, SheetContent } from "@/components/ui/primitives";
import { cn, LEVEL_LABELS } from "@/lib/utils";

const SORTS = [
  ["popular", "Most popular"],
  ["rating", "Highest rated"],
  ["newest", "Newest"],
  ["price-asc", "Price: low to high"],
  ["price-desc", "Price: high to low"],
] as const;

const DURATIONS = [
  ["short", "Under 3 hours"],
  ["medium", "3–10 hours"],
  ["long", "10+ hours"],
] as const;

/** Hook to read/write catalog filters in the URL. */
function useFilters() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [pending, start] = useTransition();
  const set = (patch: Record<string, string | null>) => {
    const next = new URLSearchParams(params.toString());
    for (const [k, v] of Object.entries(patch)) {
      if (v === null || v === "") next.delete(k);
      else next.set(k, v);
    }
    if (!("page" in patch)) next.delete("page");
    start(() => router.push(`${pathname}${next.size ? `?${next}` : ""}`, { scroll: false }));
  };
  const list = (k: string) => (params.get(k)?.split(",").filter(Boolean) ?? []) as string[];
  const toggle = (k: string, v: string) => {
    const cur = list(k);
    set({ [k]: (cur.includes(v) ? cur.filter((x) => x !== v) : [...cur, v]).join(",") || null });
  };
  return { params, set, list, toggle, pending };
}

export function CatalogSearch() {
  const { params, set } = useFilters();
  const [q, setQ] = useState(params.get("q") ?? "");
  useEffect(() => setQ(params.get("q") ?? ""), [params]);
  return (
    <form
      role="search"
      onSubmit={(e) => {
        e.preventDefault();
        set({ q: q.trim() || null });
      }}
      className="relative w-full max-w-xl"
    >
      <Input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search courses, topics, instructors…" icon={<Search />} className="h-12 pr-24" aria-label="Search courses" />
      <Button type="submit" size="sm" className="absolute right-2 top-2">
        Search
      </Button>
    </form>
  );
}

export function SortSelect() {
  const { params, set } = useFilters();
  return (
    <div className="flex items-center gap-2">
      <label htmlFor="sort" className="hidden text-sm text-muted-foreground sm:block">
        Sort by
      </label>
      <Select id="sort" value={params.get("sort") ?? "popular"} onChange={(e) => set({ sort: e.target.value === "popular" ? null : e.target.value })} className="h-10 w-48">
        {SORTS.map(([v, l]) => (
          <option key={v} value={v}>
            {l}
          </option>
        ))}
      </Select>
    </div>
  );
}

function FilterGroup({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <fieldset className="border-b border-border pb-6 last:border-0">
      <legend className="mb-2.5 text-[13px] font-semibold text-foreground">{title}</legend>
      <div className="space-y-1">{children}</div>
    </fieldset>
  );
}

function CheckRow({ checked, onChange, label, count }: { checked: boolean; onChange: () => void; label: React.ReactNode; count?: number }) {
  return (
    <label className="flex cursor-pointer items-center gap-3 rounded-lg px-2 py-1.5 text-sm text-muted-foreground transition-colors hover:bg-surface-2 hover:text-foreground">
      <Checkbox checked={checked} onCheckedChange={onChange} />
      <span className={cn("flex-1", checked && "text-foreground")}>{label}</span>
      {count !== undefined && <span className="text-xs tabular-nums text-subtle-foreground">{count}</span>}
    </label>
  );
}

function RadioRow({ checked, onChange, label, name }: { checked: boolean; onChange: () => void; label: React.ReactNode; name: string }) {
  return (
    <label className="flex cursor-pointer items-center gap-3 rounded-lg px-2 py-1.5 text-sm text-muted-foreground transition-colors hover:bg-surface-2 hover:text-foreground">
      <input type="radio" name={name} checked={checked} onChange={onChange} className="size-4 accent-[var(--primary)]" />
      <span className={cn("flex-1", checked && "text-foreground")}>{label}</span>
    </label>
  );
}

export function FilterPanel({ categories }: { categories: Category[] }) {
  const { params, set, list, toggle } = useFilters();
  const cats = list("category");
  const levels = list("level");
  return (
    <div className="space-y-6">
      <FilterGroup title="Topic">
        {categories.map((c) => (
          <CheckRow key={c.id} checked={cats.includes(c.slug)} onChange={() => toggle("category", c.slug)} label={c.name} count={c.coursesCount} />
        ))}
      </FilterGroup>
      <FilterGroup title="Level">
        {LEVELS.map((l) => (
          <CheckRow key={l} checked={levels.includes(l)} onChange={() => toggle("level", l)} label={LEVEL_LABELS[l]} />
        ))}
      </FilterGroup>
      <FilterGroup title="Rating">
        {["4.5", "4", "3.5"].map((r) => (
          <RadioRow
            key={r}
            name="rating"
            checked={params.get("rating") === r}
            onChange={() => set({ rating: r })}
            label={
              <span className="inline-flex items-center gap-1.5">
                <Star className="size-3.5 fill-star text-star" strokeWidth={0} /> {r} & up
              </span>
            }
          />
        ))}
        {params.get("rating") && (
          <button onClick={() => set({ rating: null })} className="px-2 text-xs text-accent hover:underline">
            Any rating
          </button>
        )}
      </FilterGroup>
      <FilterGroup title="Duration">
        {DURATIONS.map(([v, l]) => (
          <RadioRow key={v} name="duration" checked={params.get("duration") === v} onChange={() => set({ duration: params.get("duration") === v ? null : v })} label={l} />
        ))}
      </FilterGroup>
      <FilterGroup title="Price">
        {[
          [null, "All"],
          ["paid", "Paid"],
          ["free", "Free"],
        ].map(([v, l]) => (
          <RadioRow key={l} name="price" checked={(params.get("price") ?? null) === v} onChange={() => set({ price: v })} label={l} />
        ))}
      </FilterGroup>
    </div>
  );
}

export function ActiveFilters({ categories }: { categories: Category[] }) {
  const { params, set, list, toggle } = useFilters();
  const chips: { label: string; clear: () => void }[] = [];
  const q = params.get("q");
  if (q) chips.push({ label: `"${q}"`, clear: () => set({ q: null }) });
  for (const c of list("category")) chips.push({ label: categories.find((x) => x.slug === c)?.name ?? c, clear: () => toggle("category", c) });
  for (const l of list("level")) chips.push({ label: LEVEL_LABELS[l as keyof typeof LEVEL_LABELS] ?? l, clear: () => toggle("level", l) });
  if (params.get("rating")) chips.push({ label: `${params.get("rating")}+ stars`, clear: () => set({ rating: null }) });
  const dur = DURATIONS.find(([v]) => v === params.get("duration"));
  if (dur) chips.push({ label: dur[1], clear: () => set({ duration: null }) });
  if (params.get("price")) chips.push({ label: params.get("price") === "free" ? "Free" : "Paid", clear: () => set({ price: null }) });
  if (!chips.length) return null;
  return (
    <div className="flex flex-wrap items-center gap-2">
      {chips.map((c) => (
        <button key={c.label} onClick={c.clear} className="inline-flex h-7 items-center gap-1.5 rounded-md border border-border bg-surface px-2.5 text-[13px] shadow-card transition hover:border-border-strong">
          {c.label} <X className="size-3.5" />
        </button>
      ))}
      <button onClick={() => set({ q: null, category: null, level: null, rating: null, duration: null, price: null })} className="ml-1 text-sm text-accent hover:underline">
        Clear all
      </button>
    </div>
  );
}

export function MobileFilters({ categories }: { categories: Category[] }) {
  const [open, setOpen] = useState(false);
  const { params } = useFilters();
  const count = ["category", "level", "rating", "duration", "price"].filter((k) => params.get(k)).length;
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <D.Trigger asChild>
        <Button variant="secondary" className="lg:hidden">
          <SlidersHorizontal /> Filters {count > 0 && <span className="rounded bg-foreground px-1.5 text-[11px] text-background">{count}</span>}
        </Button>
      </D.Trigger>
      <SheetContent side="left" title="Filters">
        <div className="flex-1 overflow-y-auto p-5">
          <FilterPanel categories={categories} />
        </div>
        <div className="border-t border-border p-4">
          <Button className="w-full" size="lg" onClick={() => setOpen(false)}>
            Show results
          </Button>
        </div>
      </SheetContent>
    </Dialog>
  );
}
