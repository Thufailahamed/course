"use client";

import Link from "next/link";
import { useRef, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { toast } from "sonner";
import { Archive, CheckCircle2, Circle, ExternalLink, ImagePlus, Rocket, Trash2, X } from "lucide-react";
import type { AdminCourse, Category, CourseStatus, Level } from "@latent/shared";
import { LEVELS, LEVEL_LABELS, slugify } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { PriceTag } from "@/components/course-card";
import { Button } from "@/components/ui/button";
import { Field, Input, Select, Textarea } from "@/components/ui/input";
import { Badge, Card, Switch } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { cn, discountPercent } from "@/lib/utils";
import { ListEditor, MarkdownEditor, MoneyInput, TagInput } from "./kit";

export interface CourseForm {
  title: string;
  slug: string;
  subtitle: string;
  description: string;
  categoryId: string | null;
  level: Level;
  language: string;
  tags: string[];
  accent: number;
  thumbnailKey: string | null;
  previewVideoUrl: string;
  whatYouLearn: string[];
  requirements: string[];
  targetAudience: string[];
  priceCents: number;
  compareAtPriceCents: number | null;
  featured: boolean;
}

export function formFromCourse(c: AdminCourse): CourseForm {
  return {
    title: c.title,
    slug: c.slug,
    subtitle: c.subtitle ?? "",
    description: c.description ?? "",
    categoryId: c.categoryId,
    level: c.level,
    language: c.language,
    tags: c.tags,
    accent: c.accent,
    thumbnailKey: c.thumbnailKey,
    previewVideoUrl: c.previewVideoUrl ?? "",
    whatYouLearn: c.whatYouLearn,
    requirements: c.requirements,
    targetAudience: c.targetAudience,
    priceCents: c.priceCents,
    compareAtPriceCents: c.compareAtPriceCents,
    featured: c.featured,
  };
}

/** Only the fields that changed, normalized for the API. */
export function diffForm(a: CourseForm, b: CourseForm) {
  const out: Record<string, unknown> = {};
  for (const key of Object.keys(b) as (keyof CourseForm)[]) {
    if (JSON.stringify(a[key]) === JSON.stringify(b[key])) continue;
    let v: unknown = b[key];
    if (Array.isArray(v)) v = v.map((s: string) => s.trim()).filter(Boolean);
    if (key === "subtitle" || key === "previewVideoUrl") v = (v as string).trim() || null;
    if (key === "slug") v = slugify(v as string);
    out[key] = v;
  }
  return out;
}

type Setter = <K extends keyof CourseForm>(key: K, value: CourseForm[K]) => void;

function Section({ title, description, children, aside }: { title: string; description?: string; children: React.ReactNode; aside?: React.ReactNode }) {
  return (
    <Card className="p-5 sm:p-6">
      <div className="mb-5 flex items-start justify-between gap-4">
        <div>
          <h3 className="text-[15px] font-semibold">{title}</h3>
          {description && <p className="mt-1 text-sm text-muted-foreground">{description}</p>}
        </div>
        {aside}
      </div>
      <div className="space-y-5">{children}</div>
    </Card>
  );
}

/* ── Details ────────────────────────────────────────────── */

export function DetailsPanel({ form, set }: { form: CourseForm; set: Setter }) {
  const { data: categories } = useQuery({ queryKey: ["categories"], queryFn: () => api.get<{ items: Category[] }>("/categories").then((r) => r.items), staleTime: 300_000 });
  const fileRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);

  const upload = async (file: File) => {
    setUploading(true);
    try {
      const fd = new FormData();
      fd.append("file", file);
      fd.append("kind", "image");
      const res = await api.post<{ key: string }>("/admin/uploads", fd);
      set("thumbnailKey", res.key);
      toast.success("Thumbnail uploaded — save to apply");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Upload failed");
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="grid gap-6 xl:grid-cols-[1fr_360px]">
      <div className="space-y-6">
        <Section title="Basics" description="What learners see first in the catalog and search.">
          <Field label="Title">{(p) => <Input {...p} value={form.title} onChange={(e) => set("title", e.target.value)} maxLength={140} />}</Field>
          <Field label="URL slug" hint={`latent.dev/courses/${slugify(form.slug) || "…"}`}>
            {(p) => <Input {...p} value={form.slug} onChange={(e) => set("slug", e.target.value.toLowerCase().replace(/[^a-z0-9-]/g, "-"))} className="font-mono text-[13px]" />}
          </Field>
          <Field label="Subtitle" hint={`${form.subtitle.length}/240`}>
            {(p) => <Textarea {...p} rows={2} className="min-h-0" value={form.subtitle} onChange={(e) => set("subtitle", e.target.value)} maxLength={240} />}
          </Field>
          <div className="grid gap-5 sm:grid-cols-3">
            <Field label="Category">
              {(p) => (
                <Select {...p} value={form.categoryId ?? ""} onChange={(e) => set("categoryId", e.target.value || null)}>
                  <option value="">Uncategorized</option>
                  {categories?.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </Select>
              )}
            </Field>
            <Field label="Level">
              {(p) => (
                <Select {...p} value={form.level} onChange={(e) => set("level", e.target.value as Level)}>
                  {LEVELS.map((l) => (
                    <option key={l} value={l}>
                      {LEVEL_LABELS[l]}
                    </option>
                  ))}
                </Select>
              )}
            </Field>
            <Field label="Language">{(p) => <Input {...p} value={form.language} onChange={(e) => set("language", e.target.value)} />}</Field>
          </div>
          <Field label="Tags" hint="Used for search. Up to 12.">
            {() => <TagInput value={form.tags} onChange={(v) => set("tags", v)} />}
          </Field>
        </Section>

        <Section title="Description" description="The long-form course page copy. Markdown supported.">
          <MarkdownEditor value={form.description} onChange={(v) => set("description", v)} rows={16} placeholder="## About this course…" />
        </Section>

        <Section title="Outcomes & audience">
          <Field label="What learners will learn">{() => <ListEditor value={form.whatYouLearn} onChange={(v) => set("whatYouLearn", v)} placeholder="e.g. Build a transformer from scratch" />}</Field>
          <Field label="Requirements">{() => <ListEditor value={form.requirements} onChange={(v) => set("requirements", v)} placeholder="e.g. Comfortable with Python" />}</Field>
          <Field label="Who this course is for">{() => <ListEditor value={form.targetAudience} onChange={(v) => set("targetAudience", v)} placeholder="e.g. Backend engineers moving into ML" />}</Field>
        </Section>
      </div>

      <div className="space-y-6 xl:sticky xl:top-24 xl:self-start">
        <Section title="Cover" description="Upload an image or use generative art in your accent color.">
          <div className="relative overflow-hidden rounded-2xl border border-border">
            <CourseCover seed={form.slug || "draft"} hue={form.accent} src={form.thumbnailKey ? `/api/media/${form.thumbnailKey}` : null} className="aspect-[16/9]" />
            {form.thumbnailKey && (
              <button
                onClick={() => set("thumbnailKey", null)}
                className="absolute right-2 top-2 rounded-md border border-border bg-surface p-1.5 text-foreground shadow-card transition hover:bg-surface-2"
                aria-label="Remove thumbnail"
              >
                <X className="size-4" />
              </button>
            )}
          </div>
          <input
            ref={fileRef}
            type="file"
            accept="image/png,image/jpeg,image/webp"
            className="hidden"
            onChange={(e) => {
              const f = e.target.files?.[0];
              if (f) upload(f);
              e.target.value = "";
            }}
          />
          <Button variant="secondary" className="w-full" loading={uploading} onClick={() => fileRef.current?.click()}>
            <ImagePlus /> {form.thumbnailKey ? "Replace image" : "Upload image"}
          </Button>
          <Field label="Accent hue" hint="Drives the generated cover and highlights.">
            {(p) => (
              <div className="flex items-center gap-3">
                <input
                  {...p}
                  type="range"
                  min={0}
                  max={360}
                  value={form.accent}
                  onChange={(e) => set("accent", Number(e.target.value))}
                  className="h-2 flex-1 cursor-pointer appearance-none rounded-full accent-[var(--accent)]"
                  style={{
                    background: `linear-gradient(90deg, ${Array.from({ length: 13 }, (_, i) => `oklch(0.42 0.07 ${i * 30})`).join(",")})`,
                  }}
                />
                <span className="w-10 text-right font-mono text-xs tabular-nums text-muted-foreground">{form.accent}°</span>
              </div>
            )}
          </Field>
        </Section>
        <Section title="Promo video" description="Shown on the course page. MP4 or HLS URL.">
          <Field label="Preview video URL" optional>
            {(p) => <Input {...p} value={form.previewVideoUrl} onChange={(e) => set("previewVideoUrl", e.target.value)} placeholder="https://…/trailer.mp4" />}
          </Field>
          {form.previewVideoUrl.trim() && (
            <video src={form.previewVideoUrl} controls className="aspect-video w-full rounded-xl border border-border bg-black" preload="metadata" />
          )}
        </Section>
      </div>
    </div>
  );
}

/* ── Pricing ────────────────────────────────────────────── */

export function PricingPanel({ form, set, isAdmin, currency }: { form: CourseForm; set: Setter; isAdmin: boolean; currency: string }) {
  const free = form.priceCents === 0;
  const off = discountPercent(form.priceCents, form.compareAtPriceCents);
  return (
    <div className="grid gap-6 lg:grid-cols-[1fr_340px]">
      <Section title="Price" description="One-time purchase with lifetime access. Pro members get every course included.">
        <label className="flex items-center justify-between gap-4 rounded-xl border border-border bg-surface-2/50 px-4 py-3">
          <div>
            <div className="text-sm font-medium">Free course</div>
            <div className="text-xs text-muted-foreground">Anyone signed in can enroll at no cost.</div>
          </div>
          <Switch checked={free} onCheckedChange={(on) => (on ? (set("priceCents", 0), set("compareAtPriceCents", null)) : set("priceCents", 4900))} />
        </label>
        {!free && (
          <div className="grid gap-5 sm:grid-cols-2">
            <Field label="Price (USD)">{(p) => <MoneyInput {...p} cents={form.priceCents} onChange={(c) => set("priceCents", c ?? 0)} />}</Field>
            <Field label="Compare-at price" optional hint="Shown struck through when higher than the price.">
              {(p) => <MoneyInput {...p} cents={form.compareAtPriceCents} onChange={(c) => set("compareAtPriceCents", c)} />}
            </Field>
          </div>
        )}
        {isAdmin && (
          <label className="flex items-center justify-between gap-4 rounded-xl border border-border bg-surface-2/50 px-4 py-3">
            <div>
              <div className="text-sm font-medium">Featured course</div>
              <div className="text-xs text-muted-foreground">Highlighted on the homepage and ranked first in "Popular".</div>
            </div>
            <Switch checked={form.featured} onCheckedChange={(v) => set("featured", v)} />
          </label>
        )}
      </Section>
      <Section title="Preview">
        <div className="rounded-2xl border border-border bg-surface-2 p-5">
          <PriceTag priceCents={form.priceCents} compareAtPriceCents={form.compareAtPriceCents} currency={currency} size="lg" />
          {off > 0 && (
            <Badge variant="danger" className="mt-3">
              {off}% off
            </Badge>
          )}
          <p className="mt-4 text-xs text-subtle-foreground">Coupons are applied at checkout on top of this price.</p>
        </div>
      </Section>
    </div>
  );
}

/* ── Publish ────────────────────────────────────────────── */

export function PublishPanel({
  course,
  form,
  dirty,
  onStatus,
  statusPending,
  onDelete,
}: {
  course: AdminCourse;
  form: CourseForm;
  dirty: boolean;
  onStatus: (s: CourseStatus) => void;
  statusPending: boolean;
  onDelete: () => void;
}) {
  const lessons = course.sections.flatMap((s) => s.lessons);
  const missingVideo = lessons.filter((l) => l.type === "video" && !l.hasVideo).length;
  const checks = [
    { ok: form.title.trim().length >= 3, label: "Course title", hint: "At least 3 characters" },
    { ok: form.subtitle.trim().length >= 20, label: "Compelling subtitle", hint: "20+ characters" },
    { ok: form.description.trim().length >= 200, label: "Detailed description", hint: "200+ characters" },
    { ok: !!form.categoryId, label: "Category selected" },
    { ok: form.whatYouLearn.length >= 3, label: "At least 3 learning outcomes" },
    { ok: lessons.length >= 1, label: "At least one lesson", required: true },
    { ok: missingVideo === 0, label: "Every video lesson has a video", hint: missingVideo ? `${missingVideo} missing` : undefined },
    { ok: !!form.thumbnailKey, label: "Custom thumbnail", hint: "Optional — generated art is used otherwise", optional: true },
  ];
  const score = checks.filter((c) => c.ok).length;

  const statuses: { value: CourseStatus; title: string; desc: string; icon: React.ReactNode }[] = [
    { value: "draft", title: "Draft", desc: "Only you and admins can see it.", icon: <Circle /> },
    { value: "published", title: "Published", desc: "Live in the catalog and purchasable.", icon: <Rocket /> },
    { value: "archived", title: "Archived", desc: "Hidden from the catalog; enrolled learners keep access.", icon: <Archive /> },
  ];

  return (
    <div className="grid gap-6 lg:grid-cols-[1fr_380px]">
      <div className="space-y-6">
        <Section title="Visibility" aside={course.status === "published" && <Badge variant="success">Live</Badge>}>
          {dirty && <p className="rounded-xl bg-warning-soft px-4 py-3 text-sm text-warning">You have unsaved changes. Save them before changing visibility so learners see the latest version.</p>}
          <div className="grid gap-3 sm:grid-cols-3">
            {statuses.map((s) => (
              <button
                key={s.value}
                disabled={statusPending || course.status === s.value}
                onClick={() => onStatus(s.value)}
                className={cn(
                  "rounded-2xl border p-4 text-left transition-all [&_svg]:size-4",
                  course.status === s.value ? "border-foreground bg-surface shadow-[0_0_0_1px_var(--foreground)]" : "border-border hover:border-border-strong hover:bg-surface-2",
                )}
              >
                <div className={cn("mb-3 flex size-8 items-center justify-center rounded-md", course.status === s.value ? "bg-primary text-primary-foreground" : "bg-surface-2 text-muted-foreground")}>{s.icon}</div>
                <div className="text-sm font-semibold">{s.title}</div>
                <div className="mt-1 text-xs text-muted-foreground">{s.desc}</div>
              </button>
            ))}
          </div>
          <Button variant="secondary" asChild>
            <Link href={`/courses/${course.slug}`} target="_blank">
              <ExternalLink /> Open course page
            </Link>
          </Button>
        </Section>

        <Card className="border-danger/30 p-5 sm:p-6">
          <h3 className="text-[15px] font-semibold text-danger">Danger zone</h3>
          <p className="mt-1 text-sm text-muted-foreground">Permanently delete this course and its curriculum. Courses with paid orders can only be archived.</p>
          <Button variant="danger-soft" className="mt-4" onClick={onDelete}>
            <Trash2 /> Delete course
          </Button>
        </Card>
      </div>

      <Section title="Launch checklist" description={`${score} of ${checks.length} complete`}>
        <div className="h-1.5 overflow-hidden rounded-full bg-surface-3">
          <div className="h-full rounded-full bg-success transition-[width] duration-500" style={{ width: `${(score / checks.length) * 100}%` }} />
        </div>
        <ul className="space-y-3">
          {checks.map((c) => (
            <li key={c.label} className="flex items-start gap-3">
              {c.ok ? <CheckCircle2 className="mt-0.5 size-4 shrink-0 text-success" /> : <Circle className={cn("mt-0.5 size-4 shrink-0", c.required ? "text-danger" : "text-subtle-foreground")} />}
              <div>
                <div className={cn("text-sm", c.ok ? "text-foreground" : "text-muted-foreground")}>
                  {c.label}
                  {c.required && !c.ok && <span className="ml-1.5 text-xs text-danger">Required</span>}
                </div>
                {c.hint && !c.ok && <div className="text-xs text-subtle-foreground">{c.hint}</div>}
              </div>
            </li>
          ))}
        </ul>
      </Section>
    </div>
  );
}


