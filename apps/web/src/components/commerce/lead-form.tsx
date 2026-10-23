"use client";

import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { CheckCircle2 } from "lucide-react";
import { leadSchema } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Field, Input, Select, Textarea } from "@/components/ui/input";
import { api, ApiError } from "@/lib/api";

export function LeadForm() {
  const [form, setForm] = useState({ name: "", email: "", company: "", teamSize: "10-50", message: "" });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const submit = useMutation({
    mutationFn: (data: unknown) => api.post("/leads", data as Record<string, unknown>),
    onError: (e) => setErrors(e instanceof ApiError && e.fields ? e.fields : { _: e instanceof Error ? e.message : "Something went wrong" }),
  });
  const set = (k: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => setForm((f) => ({ ...f, [k]: e.target.value }));

  if (submit.isSuccess)
    return (
      <div className="flex flex-col items-center py-12 text-center">
        <span className="flex size-14 items-center justify-center rounded-full border border-border bg-success-soft text-success">
          <CheckCircle2 className="size-7" />
        </span>
        <h3 className="mt-5 text-xl font-semibold tracking-[-0.02em]">Thanks, {form.name.split(" ")[0]}!</h3>
        <p className="mt-2 max-w-sm text-muted-foreground">Our team will be in touch within one business day to learn about your goals.</p>
      </div>
    );

  return (
    <form
      className="grid gap-4 sm:grid-cols-2"
      onSubmit={(e) => {
        e.preventDefault();
        const parsed = leadSchema.safeParse({ ...form, company: form.company || null, message: form.message || null });
        if (!parsed.success) return setErrors(Object.fromEntries(parsed.error.issues.map((i) => [i.path.join("."), i.message])));
        setErrors({});
        submit.mutate(parsed.data);
      }}
    >
      <Field label="Full name" error={errors.name}>
        {(p) => <Input {...p} value={form.name} onChange={set("name")} autoComplete="name" />}
      </Field>
      <Field label="Work email" error={errors.email}>
        {(p) => <Input {...p} type="email" value={form.email} onChange={set("email")} autoComplete="email" />}
      </Field>
      <Field label="Company" optional error={errors.company}>
        {(p) => <Input {...p} value={form.company} onChange={set("company")} autoComplete="organization" />}
      </Field>
      <Field label="Team size" error={errors.teamSize}>
        {(p) => (
          <Select {...p} value={form.teamSize} onChange={set("teamSize")}>
            {["5-10", "10-50", "50-200", "200-1000", "1000+"].map((s) => (
              <option key={s} value={s}>
                {s} people
              </option>
            ))}
          </Select>
        )}
      </Field>
      <Field label="What are you hoping to achieve?" optional error={errors.message} className="sm:col-span-2">
        {(p) => <Textarea {...p} value={form.message} onChange={set("message")} rows={4} placeholder="e.g. Upskill our data team on LLM engineering by Q3" />}
      </Field>
      {errors._ && <p className="text-sm text-danger sm:col-span-2">{errors._}</p>}
      <Button type="submit" size="lg" loading={submit.isPending} className="sm:col-span-2">
        Request a demo
      </Button>
      <p className="text-center text-xs text-subtle-foreground sm:col-span-2">We'll only use your details to contact you about Latent for Teams.</p>
    </form>
  );
}
