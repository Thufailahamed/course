"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense, useEffect, useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowRight, BadgeCheck, Info, Lock, ShoppingBag, Tag, Trash2, X } from "lucide-react";
import { CourseCover } from "@/components/course-cover";
import { PriceTag } from "@/components/course-card";
import { Button } from "@/components/ui/button";
import { EmptyState, RatingInline } from "@/components/ui/display";
import { Input } from "@/components/ui/input";
import { PageSpinner } from "@/components/ui/spinner";
import { api } from "@/lib/api";
import { useCart } from "@/lib/cart";
import { toastError, useConfig, useSession } from "@/lib/hooks";
import { formatDuration, formatPrice, LEVEL_LABELS } from "@/lib/utils";

type Quote = {
  items: { id: string; title: string; priceCents: number }[];
  skipped: string[];
  subtotalCents: number;
  discountCents: number;
  totalCents: number;
  currency: string;
  coupon: { code: string; percentOff: number | null; amountOffCents: number | null } | null;
  couponError: string | null;
};

export default function CartPage() {
  return (
    <Suspense fallback={<PageSpinner />}>
      <Cart />
    </Suspense>
  );
}

function Cart() {
  const router = useRouter();
  const params = useSearchParams();
  const { user } = useSession();
  const { data: config } = useConfig();
  const { items, remove, coupon, setCoupon } = useCart();
  const [mounted, setMounted] = useState(false);
  const [code, setCode] = useState("");
  useEffect(() => setMounted(true), []);
  useEffect(() => {
    if (params.get("canceled")) toast.info("Checkout canceled — your cart is saved.");
  }, [params]);

  const ids = items.map((i) => i.id);
  const quote = useQuery({
    queryKey: ["quote", ids, coupon, user?.id],
    queryFn: () => api.post<Quote>("/checkout/quote", { courseIds: ids, code: coupon ?? undefined }),
    enabled: mounted && ids.length > 0,
    placeholderData: (p) => p,
  });

  useEffect(() => {
    if (quote.data?.couponError && coupon) {
      toast.error(quote.data.couponError);
      setCoupon(null);
    }
  }, [quote.data?.couponError, coupon, setCoupon]);

  const checkout = useMutation({
    mutationFn: () => api.post<{ url: string }>("/checkout", { courseIds: ids, couponCode: coupon }),
    onSuccess: ({ url }) => {
      location.href = url;
    },
    onError: toastError,
  });

  if (!mounted) return <PageSpinner />;

  const q = quote.data;
  const skipped = new Set(q?.skipped ?? []);
  const subtotal = q?.subtotalCents ?? items.reduce((s, i) => s + i.priceCents, 0);
  const compareTotal = items.filter((i) => !skipped.has(i.id)).reduce((s, i) => s + (i.compareAtPriceCents ?? i.priceCents), 0);
  const currency = q?.currency ?? items[0]?.currency ?? "USD";

  return (
    <div className="container-page py-12 sm:py-16">
      <h1 className="text-[2rem] leading-[1.15] tracking-[-0.035em] sm:text-[2.5rem]">Your cart</h1>
      <p className="mt-2 text-muted-foreground">
        {items.length} {items.length === 1 ? "course" : "courses"} in cart
      </p>

      {items.length === 0 ? (
        <EmptyState
          className="mt-10"
          icon={<ShoppingBag />}
          title="Your cart is empty"
          description="Find a course that moves you forward, or get every course with Pro."
          action={
            <div className="flex gap-2">
              <Button asChild>
                <Link href="/courses">Browse courses</Link>
              </Button>
              <Button variant="secondary" asChild>
                <Link href="/pricing">See Pro</Link>
              </Button>
            </div>
          }
        />
      ) : (
        <div className="mt-10 grid gap-10 lg:grid-cols-[1fr_380px]">
          <ul className="space-y-4">
            {items.map((i) => (
              <li key={i.id} className="card flex gap-4 p-3 sm:p-4">
                <Link href={`/courses/${i.slug}`} className="shrink-0">
                  <CourseCover seed={i.slug} hue={i.accent} src={i.thumbnailUrl} className="aspect-video w-28 rounded-lg sm:w-44" />
                </Link>
                <div className="flex min-w-0 flex-1 flex-col">
                  <Link href={`/courses/${i.slug}`} className="line-clamp-2 text-[15.5px] font-semibold leading-snug tracking-[-0.015em] hover:underline">
                    {i.title}
                  </Link>
                  <p className="mt-1 text-sm text-muted-foreground">By {i.instructorName}</p>
                  <div className="mt-2 flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-subtle-foreground">
                    <RatingInline value={i.ratingAvg} count={i.ratingCount} />
                    <span>{formatDuration(i.durationMinutes)}</span>
                    <span>{i.lessonsCount} lessons</span>
                    <span>{LEVEL_LABELS[i.level]}</span>
                  </div>
                  {skipped.has(i.id) && (
                    <p className="mt-2 inline-flex items-center gap-1.5 text-xs font-medium text-success">
                      <BadgeCheck className="size-3.5" /> You already own this course, so it won't be charged
                    </p>
                  )}
                  <button onClick={() => remove(i.id)} className="mt-auto inline-flex w-fit items-center gap-1.5 pt-3 text-xs font-medium text-muted-foreground transition hover:text-danger">
                    <Trash2 className="size-3.5" /> Remove
                  </button>
                </div>
                <div className="shrink-0 text-right">
                  <PriceTag priceCents={i.priceCents} compareAtPriceCents={i.compareAtPriceCents} currency={i.currency} />
                </div>
              </li>
            ))}
          </ul>

          <aside>
            <div className="sticky top-24 space-y-4">
              <div className="card p-6">
                <h2 className="text-lg tracking-[-0.02em]">Order summary</h2>
                <dl className="mt-5 space-y-3 text-sm">
                  {compareTotal > subtotal && (
                    <div className="flex justify-between text-muted-foreground">
                      <dt>Original price</dt>
                      <dd className="tabular-nums line-through">{formatPrice(compareTotal, currency)}</dd>
                    </div>
                  )}
                  <div className="flex justify-between">
                    <dt className="text-muted-foreground">Subtotal</dt>
                    <dd className="tabular-nums">{formatPrice(subtotal, currency)}</dd>
                  </div>
                  {q?.coupon && q.discountCents > 0 && (
                    <div className="flex justify-between text-success">
                      <dt className="inline-flex items-center gap-1.5">
                        <Tag className="size-3.5" /> {q.coupon.code}
                      </dt>
                      <dd className="tabular-nums">−{formatPrice(q.discountCents, currency)}</dd>
                    </div>
                  )}
                  <div className="flex items-baseline justify-between border-t border-border pt-4">
                    <dt className="font-medium">Total</dt>
                    <dd className="text-[1.75rem] font-semibold tabular-nums tracking-[-0.035em]">{quote.isFetching && !q ? "…" : formatPrice(q?.totalCents ?? subtotal, currency)}</dd>
                  </div>
                </dl>

                <div className="mt-5">
                  {coupon ? (
                    <div className="flex items-center justify-between rounded-lg border border-success/25 bg-success-soft px-3 py-2.5 text-sm">
                      <span className="inline-flex items-center gap-2 font-medium text-success">
                        <Tag className="size-4" /> {coupon} applied
                      </span>
                      <button onClick={() => setCoupon(null)} aria-label="Remove coupon" className="rounded p-1 text-muted-foreground hover:text-foreground">
                        <X className="size-4" />
                      </button>
                    </div>
                  ) : (
                    <form
                      className="flex gap-2"
                      onSubmit={(e) => {
                        e.preventDefault();
                        if (code.trim()) {
                          setCoupon(code.trim().toUpperCase());
                          setCode("");
                        }
                      }}
                    >
                      <Input value={code} onChange={(e) => setCode(e.target.value)} placeholder="Coupon code" aria-label="Coupon code" className="h-10 uppercase" />
                      <Button type="submit" variant="secondary" className="h-10">
                        Apply
                      </Button>
                    </form>
                  )}
                </div>

                <Button
                  size="lg"
                  className="mt-5 w-full"
                  loading={checkout.isPending}
                  disabled={!q || q.items.length === 0}
                  onClick={() => (user ? checkout.mutate() : router.push(`/login?next=${encodeURIComponent("/cart")}`))}
                >
                  <Lock /> {user ? "Checkout" : "Sign in to checkout"} <ArrowRight />
                </Button>
                {q && q.items.length === 0 && <p className="mt-2 text-center text-xs text-muted-foreground">You already own everything in your cart.</p>}
                <p className="mt-3 text-center text-xs text-subtle-foreground">30-day money-back guarantee · Secure payment</p>
              </div>

              {config?.paymentsMode === "demo" && (
                <div className="flex gap-3 rounded-xl border border-warning/30 bg-warning-soft p-4 text-sm">
                  <Info className="mt-0.5 size-4 shrink-0 text-warning" />
                  <p className="text-muted-foreground">
                    <span className="font-semibold text-foreground">Demo payments mode.</span> Stripe isn't configured, so checkout completes instantly without charging a card. Try code <span className="font-mono font-semibold text-foreground">LAUNCH30</span>.
                  </p>
                </div>
              )}

              <Link href="/pricing" className="block rounded-xl border border-border bg-surface-2 p-4 text-sm text-muted-foreground transition hover:bg-surface-3">
                <span className="font-semibold text-foreground">Taking 2+ courses this year?</span> Pro gives you every course for {formatPrice(Math.round((config?.proYearlyCents ?? 24900) / 12), config?.currency)}/mo.
              </Link>
            </div>
          </aside>
        </div>
      )}
    </div>
  );
}
