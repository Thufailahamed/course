"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import type { PricingConfig, SessionUser } from "@latent/shared";
import { api, ApiError } from "./api";

export const qk = {
  session: ["session"] as const,
  config: ["config"] as const,
  enrollments: ["me", "enrollments"] as const,
  wishlist: ["me", "wishlist"] as const,
  stats: ["me", "stats"] as const,
  orders: ["me", "orders"] as const,
  certificates: ["me", "certificates"] as const,
  subscription: ["me", "subscription"] as const,
};

export function useSession() {
  const q = useQuery({
    queryKey: qk.session,
    queryFn: () => api.get<{ user: SessionUser | null }>("/auth/me").then((r) => r.user),
    staleTime: 60_000,
  });
  return { user: q.data ?? null, loading: q.isPending, refetch: q.refetch };
}

export function useConfig() {
  return useQuery({ queryKey: qk.config, queryFn: () => api.get<PricingConfig>("/config"), staleTime: Infinity });
}

export function useLogout() {
  const qc = useQueryClient();
  const router = useRouter();
  return useMutation({
    mutationFn: () => api.post("/auth/logout"),
    onSuccess: () => {
      qc.setQueryData(qk.session, null);
      qc.removeQueries({ queryKey: ["me"] });
      router.push("/");
      router.refresh();
    },
  });
}

/** Optimistic wishlist toggle. Redirects to login when signed out. */
export function useWishlistToggle() {
  const qc = useQueryClient();
  const router = useRouter();
  const { user } = useSession();
  return useMutation({
    mutationFn: async ({ courseId, on }: { courseId: string; on: boolean }) => {
      if (!user) {
        router.push(`/login?next=${encodeURIComponent(location.pathname)}`);
        throw new ApiError("Sign in to save courses", 401);
      }
      return on ? api.post(`/me/wishlist/${courseId}`) : api.delete(`/me/wishlist/${courseId}`);
    },
    onSuccess: (_d, { on }) => {
      qc.invalidateQueries({ queryKey: qk.wishlist });
      toast.success(on ? "Saved to your wishlist" : "Removed from wishlist");
    },
    onError: (e) => {
      if (e instanceof ApiError && e.status !== 401) toast.error(e.message);
    },
  });
}

/** Shows a toast for any thrown error; pass to useMutation's onError. */
export function toastError(e: unknown) {
  toast.error(e instanceof Error ? e.message : "Something went wrong");
}
