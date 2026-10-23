"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowLeft, Eye, EyeOff, KeyRound, Lock, Mail, MailCheck, User } from "lucide-react";
import type { ZodType } from "zod";
import type { SessionUser } from "@latent/shared";
import { forgotPasswordSchema, loginSchema, registerSchema, resetPasswordSchema } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { Field, Input } from "@/components/ui/input";
import { api, ApiError } from "@/lib/api";
import { qk } from "@/lib/hooks";
import { cn } from "@/lib/utils";

function safeNext(next: string | null) {
  return next && next.startsWith("/") && !next.startsWith("//") ? next : "/dashboard";
}

function validate<T>(schema: ZodType<T>, data: unknown): { data?: T; errors: Record<string, string> } {
  const r = schema.safeParse(data);
  if (r.success) return { data: r.data, errors: {} };
  const errors: Record<string, string> = {};
  for (const i of r.error.issues) errors[i.path.join(".")] ??= i.message;
  return { errors };
}

function errorsFrom(e: unknown): Record<string, string> {
  if (e instanceof ApiError) return e.fields ?? { _: e.message };
  return { _: "Something went wrong. Please try again." };
}

export function AuthHeader({ title, subtitle }: { title: React.ReactNode; subtitle: React.ReactNode }) {
  return (
    <div className="mb-8">
      <h1 className="text-[1.75rem] leading-tight tracking-[-0.03em]">{title}</h1>
      <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">{subtitle}</p>
    </div>
  );
}

function FormError({ message }: { message?: string }) {
  if (!message) return null;
  return (
    <div role="alert" className="rounded-[10px] border border-danger/25 bg-danger-soft px-3.5 py-2.5 text-sm text-danger">
      {message}
    </div>
  );
}

function PasswordInput(props: React.InputHTMLAttributes<HTMLInputElement>) {
  const [show, setShow] = useState(false);
  return (
    <div className="relative">
      <Input {...props} type={show ? "text" : "password"} icon={<Lock />} className="pr-11" />
      <button
        type="button"
        onClick={() => setShow((s) => !s)}
        className="absolute right-2 top-1/2 -translate-y-1/2 rounded-md p-1.5 text-subtle-foreground transition hover:text-foreground"
        aria-label={show ? "Hide password" : "Show password"}
      >
        {show ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
      </button>
    </div>
  );
}

function useAuthSuccess() {
  const qc = useQueryClient();
  const router = useRouter();
  const params = useSearchParams();
  return (user: SessionUser | null) => {
    qc.setQueryData(qk.session, user);
    qc.invalidateQueries({ queryKey: qk.session });
    qc.removeQueries({ queryKey: ["me"] });
    const fallback = user && user.role !== "student" && !params.get("next") ? "/studio" : "/dashboard";
    router.push(params.get("next") ? safeNext(params.get("next")) : fallback);
    router.refresh();
  };
}

const DEMO = [
  { label: "Student", email: "student@latent.dev", password: "student12345" },
  { label: "Admin", email: "admin@latent.dev", password: "admin12345" },
];

export function LoginForm() {
  const params = useSearchParams();
  const [form, setForm] = useState({ email: "", password: "" });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const onSuccess = useAuthSuccess();
  const login = useMutation({
    mutationFn: (d: unknown) => api.post<{ user: SessionUser }>("/auth/login", d as Record<string, unknown>),
    onSuccess: ({ user }) => {
      toast.success(`Welcome back, ${user.name.split(" ")[0]}`);
      onSuccess(user);
    },
    onError: (e) => setErrors(errorsFrom(e)),
  });

  return (
    <>
      <AuthHeader
        title={
          <>
            Welcome back
          </>
        }
        subtitle="Sign in to continue learning."
      />
      <form
        noValidate
        className="space-y-4"
        onSubmit={(e) => {
          e.preventDefault();
          const { data, errors } = validate(loginSchema, form);
          setErrors(errors);
          if (data) login.mutate(data);
        }}
      >
        <FormError message={errors._} />
        <Field label="Email" error={errors.email}>
          {(p) => <Input {...p} type="email" autoComplete="email" icon={<Mail />} value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} placeholder="you@company.com" autoFocus />}
        </Field>
        <Field
          label={
            <span className="flex w-full items-center justify-between">
              Password
              <Link href="/forgot-password" className="text-xs font-normal text-accent hover:underline">
                Forgot password?
              </Link>
            </span>
          }
          error={errors.password}
        >
          {(p) => <PasswordInput {...p} autoComplete="current-password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} placeholder="••••••••" />}
        </Field>
        <Button type="submit" size="lg" className="w-full" loading={login.isPending}>
          Sign in
        </Button>
      </form>

      <div className="mt-6 rounded-xl border border-border bg-surface-2 p-4">
        <p className="text-xs font-medium text-muted-foreground">Demo accounts (click to fill)</p>
        <div className="mt-3 grid grid-cols-2 gap-2">
          {DEMO.map((d) => (
            <button
              key={d.email}
              type="button"
              onClick={() => setForm({ email: d.email, password: d.password })}
              className="rounded-lg border border-border bg-surface px-3 py-2 text-left shadow-card transition hover:border-border-strong"
            >
              <span className="block text-sm font-medium">{d.label}</span>
              <span className="block truncate font-mono text-[11px] text-subtle-foreground">{d.email}</span>
            </button>
          ))}
        </div>
      </div>

      <p className="mt-8 text-center text-sm text-muted-foreground">
        New to Latent?{" "}
        <Link href={`/signup${params.get("next") ? `?next=${encodeURIComponent(params.get("next")!)}` : ""}`} className="font-medium text-accent hover:underline">
          Create an account
        </Link>
      </p>
    </>
  );
}

function strength(pw: string) {
  let s = 0;
  if (pw.length >= 8) s++;
  if (pw.length >= 12) s++;
  if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) s++;
  if (/\d/.test(pw)) s++;
  if (/[^A-Za-z0-9]/.test(pw)) s++;
  return Math.min(4, s);
}

function StrengthMeter({ password }: { password: string }) {
  if (!password) return null;
  const s = strength(password);
  const labels = ["Too weak", "Weak", "Okay", "Strong", "Excellent"];
  const colors = ["bg-danger", "bg-danger", "bg-warning", "bg-success", "bg-success"];
  return (
    <div className="mt-2" aria-live="polite">
      <div className="flex gap-1">
        {[0, 1, 2, 3].map((i) => (
          <span key={i} className={cn("h-1 flex-1 rounded-full transition-colors", i < s ? colors[s] : "bg-surface-3")} />
        ))}
      </div>
      <p className="mt-1 text-xs text-subtle-foreground">{labels[s]}</p>
    </div>
  );
}

export function SignupForm() {
  const params = useSearchParams();
  const [form, setForm] = useState({ name: "", email: "", password: "" });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const onSuccess = useAuthSuccess();
  const register = useMutation({
    mutationFn: (d: unknown) => api.post<{ user: SessionUser }>("/auth/register", d as Record<string, unknown>),
    onSuccess: ({ user }) => {
      toast.success("Your account is ready — welcome to Latent!");
      onSuccess(user);
    },
    onError: (e) => setErrors(errorsFrom(e)),
  });
  return (
    <>
      <AuthHeader
        title={
          <>
            Start learning today
          </>
        }
        subtitle="Create a free account — no credit card required."
      />
      <form
        noValidate
        className="space-y-4"
        onSubmit={(e) => {
          e.preventDefault();
          const { data, errors } = validate(registerSchema, form);
          setErrors(errors);
          if (data) register.mutate(data);
        }}
      >
        <FormError message={errors._} />
        <Field label="Full name" error={errors.name}>
          {(p) => <Input {...p} autoComplete="name" icon={<User />} value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} placeholder="Ada Lovelace" autoFocus />}
        </Field>
        <Field label="Email" error={errors.email}>
          {(p) => <Input {...p} type="email" autoComplete="email" icon={<Mail />} value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} placeholder="you@company.com" />}
        </Field>
        <Field label="Password" error={errors.password}>
          {(p) => (
            <div>
              <PasswordInput {...p} autoComplete="new-password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} placeholder="At least 8 characters" />
              <StrengthMeter password={form.password} />
            </div>
          )}
        </Field>
        <Button type="submit" size="lg" className="w-full" loading={register.isPending}>
          Create account
        </Button>
      </form>
      <p className="mt-8 text-center text-sm text-muted-foreground">
        Already have an account?{" "}
        <Link href={`/login${params.get("next") ? `?next=${encodeURIComponent(params.get("next")!)}` : ""}`} className="font-medium text-accent hover:underline">
          Sign in
        </Link>
      </p>
    </>
  );
}

export function ForgotPasswordForm() {
  const [email, setEmail] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const send = useMutation({
    mutationFn: (d: unknown) => api.post("/auth/forgot-password", d as Record<string, unknown>),
    onError: (e) => setErrors(errorsFrom(e)),
  });

  if (send.isSuccess)
    return (
      <div className="text-center">
        <span className="mx-auto flex size-14 items-center justify-center rounded-full border border-success/20 bg-success-soft text-success">
          <MailCheck className="size-6" />
        </span>
        <h1 className="mt-6 text-[1.75rem] leading-tight">Check your inbox</h1>
        <p className="mt-3 text-muted-foreground">
          If an account exists for <span className="font-medium text-foreground">{email}</span>, we've sent a link to reset your password. It's valid for one hour.
        </p>
        <Button variant="secondary" className="mt-8" asChild>
          <Link href="/login">
            <ArrowLeft /> Back to sign in
          </Link>
        </Button>
      </div>
    );

  return (
    <>
      <span className="mb-6 flex size-11 items-center justify-center rounded-lg border border-border bg-surface text-muted-foreground shadow-card">
        <KeyRound className="size-[18px]" />
      </span>
      <AuthHeader title="Forgot your password?" subtitle="Enter your email and we'll send you a reset link." />
      <form
        noValidate
        className="space-y-4"
        onSubmit={(e) => {
          e.preventDefault();
          const { data, errors } = validate(forgotPasswordSchema, { email });
          setErrors(errors);
          if (data) send.mutate(data);
        }}
      >
        <FormError message={errors._} />
        <Field label="Email" error={errors.email}>
          {(p) => <Input {...p} type="email" autoComplete="email" icon={<Mail />} value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@company.com" autoFocus />}
        </Field>
        <Button type="submit" size="lg" className="w-full" loading={send.isPending}>
          Send reset link
        </Button>
      </form>
      <Link href="/login" className="mt-8 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="size-4" /> Back to sign in
      </Link>
    </>
  );
}

export function ResetPasswordForm() {
  const params = useSearchParams();
  const router = useRouter();
  const qc = useQueryClient();
  const token = params.get("token") ?? "";
  const [form, setForm] = useState({ password: "", confirm: "" });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const reset = useMutation({
    mutationFn: (d: unknown) => api.post("/auth/reset-password", d as Record<string, unknown>),
    onSuccess: () => {
      toast.success("Password updated — you're signed in");
      qc.invalidateQueries({ queryKey: qk.session });
      router.push("/dashboard");
      router.refresh();
    },
    onError: (e) => setErrors(errorsFrom(e)),
  });

  if (!token)
    return (
      <div className="text-center">
        <h1 className="text-[1.75rem]">Invalid reset link</h1>
        <p className="mt-2 text-muted-foreground">This link is missing its token. Request a new one.</p>
        <Button className="mt-6" asChild>
          <Link href="/forgot-password">Request new link</Link>
        </Button>
      </div>
    );

  return (
    <>
      <AuthHeader title="Choose a new password" subtitle="Make it at least 8 characters. You'll be signed out on other devices." />
      <form
        noValidate
        className="space-y-4"
        onSubmit={(e) => {
          e.preventDefault();
          if (form.password !== form.confirm) return setErrors({ confirm: "Passwords don't match" });
          const { data, errors } = validate(resetPasswordSchema, { token, password: form.password });
          setErrors(errors);
          if (data) reset.mutate(data);
        }}
      >
        <FormError message={errors._ ?? errors.token} />
        <Field label="New password" error={errors.password}>
          {(p) => (
            <div>
              <PasswordInput {...p} autoComplete="new-password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} autoFocus />
              <StrengthMeter password={form.password} />
            </div>
          )}
        </Field>
        <Field label="Confirm password" error={errors.confirm}>
          {(p) => <PasswordInput {...p} autoComplete="new-password" value={form.confirm} onChange={(e) => setForm({ ...form, confirm: e.target.value })} />}
        </Field>
        <Button type="submit" size="lg" className="w-full" loading={reset.isPending}>
          Update password
        </Button>
      </form>
    </>
  );
}
