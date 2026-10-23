"use client";

import { useEffect, useRef, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Camera, Sparkles } from "lucide-react";
import type { SessionUser } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/display";
import { Field, Input, Textarea } from "@/components/ui/input";
import { Badge, Card, CardHeader, Skeleton } from "@/components/ui/primitives";
import { api, ApiError } from "@/lib/api";
import { qk, toastError, useSession } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

export default function ProfilePage() {
  const { user, loading } = useSession();
  const qc = useQueryClient();
  const fileRef = useRef<HTMLInputElement>(null);
  const [form, setForm] = useState({ name: "", headline: "", bio: "" });
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (user) setForm({ name: user.name, headline: user.headline ?? "", bio: user.bio ?? "" });
  }, [user]);

  const save = useMutation({
    mutationFn: () => api.patch<{ user: SessionUser }>("/me", { name: form.name, headline: form.headline || null, bio: form.bio || null }),
    onSuccess: ({ user: u }) => {
      qc.setQueryData(qk.session, u);
      setErrors({});
      toast.success("Profile updated");
    },
    onError: (e) => {
      if (e instanceof ApiError && e.fields) setErrors(e.fields);
      toastError(e);
    },
  });

  const upload = useMutation({
    mutationFn: (file: File) => {
      const fd = new FormData();
      fd.append("file", file);
      return api.post<{ avatarUrl: string }>("/me/avatar", fd);
    },
    onSuccess: ({ avatarUrl }) => {
      qc.setQueryData<SessionUser | null>(qk.session, (u) => (u ? { ...u, avatarUrl } : u));
      toast.success("Photo updated");
    },
    onError: toastError,
  });

  if (loading || !user) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-36 rounded-2xl" />
        <Skeleton className="h-80 rounded-2xl" />
      </div>
    );
  }

  const dirty = form.name !== user.name || form.headline !== (user.headline ?? "") || form.bio !== (user.bio ?? "");

  return (
    <div className="space-y-6">
      <Card>
        <div className="flex flex-col gap-5 p-6 sm:flex-row sm:items-center">
          <div className="relative w-fit">
            <Avatar name={user.name} src={user.avatarUrl} size={80} />
            <button
              onClick={() => fileRef.current?.click()}
              disabled={upload.isPending}
              className="absolute -bottom-1 -right-1 flex size-8 items-center justify-center rounded-full border-2 border-surface bg-foreground text-background shadow-card transition hover:bg-primary-hover disabled:opacity-60"
              aria-label="Change photo"
            >
              <Camera className="size-3.5" />
            </button>
            <input
              ref={fileRef}
              type="file"
              accept="image/png,image/jpeg,image/webp,image/gif"
              className="hidden"
              onChange={(e) => {
                const f = e.target.files?.[0];
                if (f) {
                  if (f.size > 4 * 1024 * 1024) toast.error("Please choose an image under 4 MB");
                  else upload.mutate(f);
                }
                e.target.value = "";
              }}
            />
          </div>
          <div className="min-w-0 flex-1">
            <div className="flex flex-wrap items-center gap-2">
              <h2 className="text-xl leading-tight tracking-[-0.025em]">{user.name}</h2>
              {user.hasPro && (
                <Badge variant="primary" size="sm">
                  <Sparkles /> Pro
                </Badge>
              )}
              {user.role !== "student" && (
                <Badge variant="outline" size="sm" className="capitalize">
                  {user.role}
                </Badge>
              )}
            </div>
            <p className="text-sm text-muted-foreground">{user.email}</p>
            <p className="mt-1 text-xs text-subtle-foreground">Member since {formatDate(user.createdAt, { month: "long", year: "numeric" })}</p>
          </div>
          <Button variant="secondary" size="sm" onClick={() => fileRef.current?.click()} loading={upload.isPending}>
            Upload photo
          </Button>
        </div>
      </Card>

      <Card>
        <CardHeader title="Public profile" description="Shown on your reviews, Q&A posts and certificates." />
        <form
          onSubmit={(e) => {
            e.preventDefault();
            save.mutate();
          }}
          className="space-y-5 p-6"
        >
          <Field label="Full name" error={errors.name} hint="This is the name printed on your certificates.">
            {(p) => <Input {...p} value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} autoComplete="name" required />}
          </Field>
          <Field label="Headline" optional error={errors.headline}>
            {(p) => <Input {...p} value={form.headline} onChange={(e) => setForm({ ...form, headline: e.target.value })} placeholder="e.g. ML Engineer at Acme" maxLength={120} />}
          </Field>
          <Field label="Bio" optional error={errors.bio} hint={`${form.bio.length}/2000`}>
            {(p) => <Textarea {...p} value={form.bio} onChange={(e) => setForm({ ...form, bio: e.target.value })} rows={5} maxLength={2000} placeholder="A few words about you and what you're learning." />}
          </Field>
          <Field label="Email" hint="Contact support to change the email on your account.">
            {(p) => <Input {...p} value={user.email} disabled readOnly />}
          </Field>
          <div className="flex justify-end gap-2 border-t border-border pt-5">
            <Button type="button" variant="ghost" disabled={!dirty} onClick={() => setForm({ name: user.name, headline: user.headline ?? "", bio: user.bio ?? "" })}>
              Reset
            </Button>
            <Button type="submit" loading={save.isPending} disabled={!dirty || form.name.trim().length < 2}>
              Save changes
            </Button>
          </div>
        </form>
      </Card>
    </div>
  );
}
