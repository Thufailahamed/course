"use client";

import { useQuery } from "@tanstack/react-query";
import { Heart } from "lucide-react";
import type { CourseCard } from "@latent/shared";
import { api } from "@/lib/api";
import { qk, useSession, useWishlistToggle } from "@/lib/hooks";
import { cn } from "@/lib/utils";

export function useWishlistIds() {
  const { user } = useSession();
  const q = useQuery({
    queryKey: qk.wishlist,
    queryFn: () => api.get<{ items: CourseCard[] }>("/me/wishlist").then((r) => r.items),
    enabled: !!user,
  });
  return new Set((q.data ?? []).map((c) => c.id));
}

export function WishlistButton({ courseId, className, variant = "overlay" }: { courseId: string; className?: string; variant?: "overlay" | "outline" }) {
  const ids = useWishlistIds();
  const toggle = useWishlistToggle();
  const on = ids.has(courseId);
  return (
    <button
      type="button"
      onClick={(e) => {
        e.preventDefault();
        e.stopPropagation();
        toggle.mutate({ courseId, on: !on });
      }}
      aria-pressed={on}
      aria-label={on ? "Remove from wishlist" : "Save to wishlist"}
      className={cn(
        "inline-flex items-center justify-center rounded-full transition-colors active:scale-95",
        variant === "overlay" ? "size-8 bg-surface/95 text-foreground shadow-card hover:bg-surface" : "size-10.5 rounded-lg border border-border-strong bg-surface text-foreground shadow-card hover:bg-surface-2",
        className,
      )}
    >
      <Heart className={cn("size-4 transition", on && "fill-danger text-danger")} />
    </button>
  );
}
