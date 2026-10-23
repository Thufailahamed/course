"use client";

import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { toast } from "sonner";
import { Eye, EyeOff, KeyRound, LogOut, ShieldCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Field, Input } from "@/components/ui/input";
import { Card, CardHeader } from "@/components/ui/primitives";
import { api, ApiError } from "@/lib/api";
import { useLogout } from "@/lib/hooks";
import { cn } from "@/lib/utils";

function strength(pw: string) {
  let s = 0;
  if (pw.length >= 8) s++;
  if (pw.length >= 12) s++;
  if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) s++;
  if (/\d/.test(pw)) s++;
  if (/[^A-Za-z0-9]/.test(pw)) s++;
  return Math.min(4, s);
}
const STRENGTH = ["Too weak", "Weak", "Fair", "Good", "Strong"];
const STRENGTH_COLOR = ["bg-danger", "bg-danger", "bg-warning", "bg-success", "bg-success"];

export default function SecurityPage() {
  const [current, setCurrent] = useState("");
  const [next, setNext] = useState("");
  const [confirm, setConfirm] = useState("");
  const [show, setShow] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const logout = useLogout();

  const change = useMutation({
    mutationFn: () => api.patch("/auth/password", { currentPassword: current, newPassword: next }),
    onSuccess: () => {
      setCurrent("");
      setNext("");
      setConfirm("");
      setError(null);
      toast.success("Password updated", { description: "You've been signed out on all other devices." });
    },
    onError: (e) => setError(e instanceof ApiError ? e.message : "Couldn't update password"),
  });

  const s = strength(next);
  const mismatch = confirm.length > 0 && confirm !== next;
  const valid = current && next.length >= 8 && next === confirm;

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader title="Change password" description="Use at least 8 characters. Changing it signs you out everywhere else." />
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (valid) change.mutate();
          }}
          className="space-y-5 p-6"
        >
          <Field label="Current password" error={error}>
            {(p) => <Input {...p} type={show ? "text" : "password"} value={current} onChange={(e) => setCurrent(e.target.value)} autoComplete="current-password" icon={<KeyRound />} required />}
          </Field>
          <Field label="New password">
            {(p) => (
              <div className="space-y-2">
                <div className="relative">
                  <Input {...p} type={show ? "text" : "password"} value={next} onChange={(e) => setNext(e.target.value)} autoComplete="new-password" minLength={8} required className="pr-11" />
                  <button type="button" onClick={() => setShow((v) => !v)} className="absolute right-3 top-1/2 -translate-y-1/2 rounded-md p-1 text-subtle-foreground hover:text-foreground" aria-label={show ? "Hide passwords" : "Show passwords"}>
                    {show ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
                  </button>
                </div>
                {next && (
                  <div className="flex items-center gap-3">
                    <div className="flex flex-1 gap-1">
                      {[0, 1, 2, 3].map((i) => (
                        <span key={i} className={cn("h-1 flex-1 rounded-full transition-colors", i < s ? STRENGTH_COLOR[s] : "bg-surface-3")} />
                      ))}
                    </div>
                    <span className="w-16 text-right text-xs text-subtle-foreground">{STRENGTH[s]}</span>
                  </div>
                )}
              </div>
            )}
          </Field>
          <Field label="Confirm new password" error={mismatch ? "Passwords don't match" : null}>
            {(p) => <Input {...p} type={show ? "text" : "password"} value={confirm} onChange={(e) => setConfirm(e.target.value)} autoComplete="new-password" required />}
          </Field>
          <div className="flex justify-end border-t border-border pt-5">
            <Button type="submit" loading={change.isPending} disabled={!valid}>
              Update password
            </Button>
          </div>
        </form>
      </Card>

      <Card>
        <CardHeader title="Sessions" description="Your account is protected with secure, httpOnly session cookies." />
        <div className="flex flex-col gap-4 p-6 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex items-center gap-3">
            <span className="flex size-10 items-center justify-center rounded-xl bg-success-soft text-success">
              <ShieldCheck className="size-5" />
            </span>
            <div>
              <p className="text-sm font-medium">This device</p>
              <p className="text-xs text-subtle-foreground">Signed in now</p>
            </div>
          </div>
          <Button variant="danger-soft" onClick={() => logout.mutate()} loading={logout.isPending}>
            <LogOut /> Sign out
          </Button>
        </div>
      </Card>
    </div>
  );
}
