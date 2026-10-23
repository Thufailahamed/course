"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { CourseCard } from "@latent/shared";

export type CartItem = Pick<
  CourseCard,
  "id" | "slug" | "title" | "priceCents" | "compareAtPriceCents" | "currency" | "accent" | "thumbnailUrl" | "level" | "lessonsCount" | "durationMinutes" | "ratingAvg" | "ratingCount"
> & { instructorName: string };

interface CartState {
  items: CartItem[];
  coupon: string | null;
  add: (course: CourseCard) => void;
  remove: (id: string) => void;
  clear: () => void;
  has: (id: string) => boolean;
  setCoupon: (code: string | null) => void;
}

export const useCart = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      coupon: null,
      add: (c) => {
        if (get().items.some((i) => i.id === c.id)) return;
        set((s) => ({
          items: [
            ...s.items,
            {
              id: c.id,
              slug: c.slug,
              title: c.title,
              priceCents: c.priceCents,
              compareAtPriceCents: c.compareAtPriceCents,
              currency: c.currency,
              accent: c.accent,
              thumbnailUrl: c.thumbnailUrl,
              level: c.level,
              lessonsCount: c.lessonsCount,
              durationMinutes: c.durationMinutes,
              ratingAvg: c.ratingAvg,
              ratingCount: c.ratingCount,
              instructorName: c.instructor.name,
            },
          ],
        }));
      },
      remove: (id) => set((s) => ({ items: s.items.filter((i) => i.id !== id) })),
      clear: () => set({ items: [], coupon: null }),
      has: (id) => get().items.some((i) => i.id === id),
      setCoupon: (coupon) => set({ coupon }),
    }),
    { name: "latent-cart" },
  ),
);
