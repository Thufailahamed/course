"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import type { Role } from "@latent/shared";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";

export function RoleSelect({ userId, role, disabled }: { userId: string; role: Role; disabled?: boolean }) {
  const qc = useQueryClient();
  const change = useMutation({
    mutationFn: (r: Role) => api.patch(`/admin/users/${userId}`, { role: r }),
    onSuccess: (_d, r) => {
      toast.success(`Role changed to ${r}`);
      qc.invalidateQueries({ queryKey: ["admin", "users"] });
      qc.invalidateQueries({ queryKey: ["admin", "user", userId] });
    },
    onError: toastError,
  });
  return (
    <select
      value={role}
      disabled={disabled || change.isPending}
      onClick={(e) => e.stopPropagation()}
      onChange={(e) => change.mutate(e.target.value as Role)}
      className="h-8 rounded-md border border-border bg-surface px-2.5 text-xs font-medium capitalize outline-none transition hover:border-border-strong focus:border-accent disabled:opacity-60"
      aria-label="Role"
    >
      <option value="student">Student</option>
      <option value="instructor">Instructor</option>
      <option value="admin">Admin</option>
    </select>
  );
}
