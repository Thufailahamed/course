"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Award, Bot, Bug, Check, Clock, FileText, Infinity as InfinityIcon, Link2, ListChecks, Play, PlayCircle, ShieldCheck, ShoppingBag, Sparkles, SquareTerminal } from "lucide-react";
import type { CourseDetail } from "@latent/shared";
import { CourseCover } from "@/components/course-cover";
import { PriceTag } from "@/components/course-card";
import { WishlistButton } from "@/components/wishlist-button";
import { Button } from "@/components/ui/button";
import { ProgressBar } from "@/components/ui/display";
import { api } from "@/lib/api";
import { useCart } from "@/lib/cart";
import { toastError, useSession } from "@/lib/hooks";
import { cn, discountPercent, formatDuration } from "@/lib/utils";
import { PreviewTrigger } from "./course-preview";

function useCourseActions(course: CourseDetail) {
  const router = useRouter();
  const qc = useQueryClient();
  const { user } = useSession();
  const cart = useCart();
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  const inCart = mounted && cart.items.some((i) => i.id === course.id);

  const enroll = useMutation({
    mutationFn: () => api.post<{ slug: string }>(`/courses/${course.id}/enroll`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["me"] });
      toast.success("You're enrolled. Let's go!");
      router.push(`/learn/${course.slug}`);
    },
    onError: toastError,
  });

  const requireLogin = () => {
    if (user) return false;
    router.push(`/login?next=${encodeURIComponent(`/courses/${course.slug}`)}`);
    return true;
  };

  return {
    enrolled: !!course.viewer?.enrolled,
    pro: !!course.viewer?.hasAccessViaPro,
    free: course.priceCents === 0,
    inCart,
    enroll: () => !requireLogin() && enroll.mutate(),
    enrolling: enroll.isPending,
    addToCart: () => {
      cart.add(course);
      toast.success("Added to cart", { action: { label: "View cart", onClick: () => router.push("/cart") } });
    },
    buyNow: () => {
      cart.add(course);
      router.push("/cart");
    },
    goToCourse: () => router.push(`/learn/${course.slug}`),
  };
}

function PrimaryActions({ course, compact }: { course: CourseDetail; compact?: boolean }) {
  const a = useCourseActions(course);
  const size = compact ? "md" : "lg";
  if (a.enrolled)
    return (
      <Button size={size} className="w-full" onClick={a.goToCourse}>
        <Play className="fill-current" /> {course.viewer!.progressPercent > 0 ? "Continue learning" : "Start learning"}
      </Button>
    );
  if (a.free)
    return (
      <Button size={size} className="w-full" onClick={a.enroll} loading={a.enrolling}>
        Enroll for free
      </Button>
    );
  if (a.pro)
    return (
      <Button size={size} className="w-full" onClick={a.enroll} loading={a.enrolling}>
        <Sparkles /> Start with Pro
      </Button>
    );
  return (
    <div className={cn("grid gap-2.5", compact && "grid-cols-2")}>
      {a.inCart ? (
        <Button size={size} className="w-full" asChild>
          <Link href="/cart">
            <ShoppingBag /> Go to cart
          </Link>
        </Button>
      ) : (
        <Button size={size} className="w-full" onClick={a.addToCart}>
          <ShoppingBag /> Add to cart
        </Button>
      )}
      <Button size={size} variant="secondary" className="w-full" onClick={a.buyNow}>
        Buy now
      </Button>
    </div>
  );
}

export function PurchaseCard({ course }: { course: CourseDetail }) {
  const lessons = course.sections.flatMap((s) => s.lessons);
  const videos = lessons.filter((l) => l.type === "video");
  const articles = lessons.filter((l) => l.type === "article").length;
  const quizzes = lessons.filter((l) => l.type === "quiz").length;
  const interactive = lessons.filter((l) => l.type === "interactive").length;
  const videoMinutes = Math.round(videos.reduce((n, l) => n + l.durationSeconds, 0) / 60);
  const off = discountPercent(course.priceCents, course.compareAtPriceCents);
  const enrolled = !!course.viewer?.enrolled;

  const share = async () => {
    try {
      await navigator.clipboard.writeText(location.href);
      toast.success("Link copied to clipboard");
    } catch {
      toast.error("Couldn't copy link");
    }
  };

  return (
    <div className="overflow-hidden rounded-xl border border-border bg-surface shadow-card-lg">
      <PreviewTrigger className="group relative block w-full border-b border-border">
        <CourseCover seed={course.slug} hue={course.accent} src={course.thumbnailUrl} className="aspect-video" />
        <span className="absolute inset-0 flex items-center justify-center transition group-hover:bg-black/10">
          <span className="inline-flex h-9 items-center gap-2 rounded-lg bg-surface/95 pl-1.5 pr-3.5 text-[13px] font-medium text-foreground shadow-card-lg transition group-hover:bg-surface">
            <span className="flex size-6 items-center justify-center rounded-md bg-foreground text-background">
              <Play className="ml-px size-3 fill-current" />
            </span>
            Preview this course
          </span>
        </span>
      </PreviewTrigger>

      <div className="p-6">
        {enrolled ? (
          <div className="mb-5">
            <div className="mb-2 flex items-center justify-between text-sm">
              <span className="font-medium">Your progress</span>
              <span className="tabular-nums text-muted-foreground">{course.viewer!.progressPercent}%</span>
            </div>
            <ProgressBar value={course.viewer!.progressPercent} />
          </div>
        ) : (
          <div className="mb-5">
            <div className="flex flex-wrap items-center gap-3">
              <PriceTag priceCents={course.priceCents} compareAtPriceCents={course.compareAtPriceCents} currency={course.currency} size="lg" />
              {off > 0 && <span className="rounded-md bg-accent-soft px-1.5 py-0.5 text-xs font-semibold text-accent">{off}% off</span>}
            </div>
            {course.viewer?.hasAccessViaPro && <p className="mt-2 text-sm text-accent">Included with your Pro membership</p>}
          </div>
        )}

        <div className="flex gap-2.5">
          <div className="flex-1">
            <PrimaryActions course={course} />
          </div>
          {!enrolled && (
            <div className="self-start">
              <WishlistButton courseId={course.id} variant="outline" />
            </div>
          )}
        </div>

        {!enrolled && !course.viewer?.hasAccessViaPro && course.priceCents > 0 && (
          <Link href="/pricing" className="mt-4 flex items-center justify-center gap-2 rounded-lg border border-border bg-surface-2 px-3 py-2.5 text-[13px] text-muted-foreground transition hover:bg-surface-3 hover:text-foreground">
            <Sparkles className="size-3.5 text-accent" /> Or get this + every course with <span className="font-semibold text-foreground">Pro</span>
          </Link>
        )}

        <p className="mt-4 flex items-center justify-center gap-1.5 text-xs text-subtle-foreground">
          <ShieldCheck className="size-3.5" /> 30-day money-back guarantee
        </p>

        <div className="mt-6 border-t border-border pt-5">
          <p className="mb-3.5 text-[13px] font-semibold">This course includes</p>
          <ul className="space-y-2.5 text-sm text-muted-foreground">
            {[
              ...(interactive ? [[SquareTerminal, `${interactive} interactive coding lessons`], [Bug, "Runnable code, checked by tests, right in your browser"]] : []),
              ...(videos.length ? [[PlayCircle, `${formatDuration(videoMinutes)} of on-demand video`]] : []),
              ...(articles ? [[FileText, `${articles} in-depth articles & notebooks`]] : []),
              ...(quizzes ? [[ListChecks, `${quizzes} graded ${quizzes === 1 ? "quiz" : "quizzes"}`]] : []),
              [Bot, "AI tutor in every lesson"],
              [Award, "Certificate of completion"],
              [InfinityIcon, "Lifetime access & updates"],
            ].map(([Icon, label]) => {
              const I = Icon as typeof Clock;
              return (
                <li key={label as string} className="flex items-center gap-3">
                  <I className="size-4 shrink-0 text-subtle-foreground" />
                  {label as string}
                </li>
              );
            })}
          </ul>
        </div>
        <button onClick={share} className="mt-5 flex w-full items-center justify-center gap-2 rounded-lg py-2 text-sm font-medium text-muted-foreground transition hover:bg-surface-2 hover:text-foreground">
          <Link2 className="size-4" /> Share course
        </button>
      </div>
    </div>
  );
}

/** Fixed bottom bar on small screens. */
export function MobilePurchaseBar({ course }: { course: CourseDetail }) {
  const enrolled = !!course.viewer?.enrolled;
  return (
    <div className="glass fixed inset-x-0 bottom-0 z-30 border-t border-border p-3 lg:hidden">
      <div className="mx-auto flex max-w-xl items-center gap-3">
        {!enrolled && (
          <div className="shrink-0">
            <PriceTag priceCents={course.priceCents} compareAtPriceCents={course.compareAtPriceCents} currency={course.currency} />
          </div>
        )}
        <div className="flex-1">
          <MobileAction course={course} />
        </div>
      </div>
    </div>
  );
}

function MobileAction({ course }: { course: CourseDetail }) {
  const a = useCourseActions(course);
  if (a.enrolled) return <Button className="w-full" onClick={a.goToCourse}>Continue learning</Button>;
  if (a.free || a.pro)
    return (
      <Button className="w-full" onClick={a.enroll} loading={a.enrolling}>
        {a.free ? "Enroll for free" : "Start with Pro"}
      </Button>
    );
  return a.inCart ? (
    <Button className="w-full" asChild>
      <Link href="/cart">
        <Check /> In cart · Checkout
      </Link>
    </Button>
  ) : (
    <Button className="w-full" onClick={a.addToCart}>
      <ShoppingBag /> Add to cart
    </Button>
  );
}
