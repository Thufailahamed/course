"use client";

import { useQuery } from "@tanstack/react-query";
import type { CourseCard, Enrollment, LearningStats } from "@latent/shared";
import { api } from "@/lib/api";
import { qk } from "@/lib/hooks";

export type EarnedCertificate = { id: string; issuedAt: string; course: CourseCard };

export const useEnrollments = () => useQuery({ queryKey: qk.enrollments, queryFn: () => api.get<{ items: Enrollment[] }>("/me/enrollments").then((r) => r.items) });

export const useStats = () => useQuery({ queryKey: qk.stats, queryFn: () => api.get<LearningStats>("/me/stats") });

export const useCertificates = () => useQuery({ queryKey: qk.certificates, queryFn: () => api.get<{ items: EarnedCertificate[] }>("/me/certificates").then((r) => r.items) });

export const useWishlist = () => useQuery({ queryKey: qk.wishlist, queryFn: () => api.get<{ items: CourseCard[] }>("/me/wishlist").then((r) => r.items) });

/** courseId → certificate id */
export function useCertificateMap() {
  const { data } = useCertificates();
  return new Map((data ?? []).map((c) => [c.course.id, c.id]));
}
