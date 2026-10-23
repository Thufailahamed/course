"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { Suspense, useEffect, useRef } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, useReducedMotion } from "motion/react";
import { ArrowRight, CheckCircle2, Clock, Sparkles } from "lucide-react";
import type { Order } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { PageSpinner } from "@/components/ui/spinner";
import { api } from "@/lib/api";
import { useCart } from "@/lib/cart";
import { qk } from "@/lib/hooks";
import { formatPrice } from "@/lib/utils";

export default function SuccessPage() {
  return (
    <Suspense fallback={<PageSpinner />}>
      <Success />
    </Suspense>
  );
}

function Confetti() {
  const reduce = useReducedMotion();
  if (reduce) return null;
  const pieces = Array.from({ length: 36 }, (_, i) => i);
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden>
      {pieces.map((i) => {
        const left = (i * 37) % 100;
        const color = ["oklch(0.54 0.2 259)", "oklch(0.2 0.006 270)", "oklch(0.76 0.16 72)", "oklch(0.7 0.12 259)", "oklch(0.56 0.13 155)"][i % 5];
        return (
          <motion.span
            key={i}
            className="absolute top-0 block h-2.5 w-1.5 rounded-sm"
            style={{ left: `${left}%`, background: color }}
            initial={{ y: -20, opacity: 0, rotate: 0 }}
            animate={{ y: 520, opacity: [0, 1, 1, 0], rotate: 360 + i * 20, x: ((i % 7) - 3) * 18 }}
            transition={{ duration: 2.4 + (i % 5) * 0.3, delay: (i % 9) * 0.08, ease: "easeOut" }}
          />
        );
      })}
    </div>
  );
}

function Success() {
  const params = useSearchParams();
  const orderId = params.get("order");
  const pro = params.get("pro") === "1";
  const clear = useCart((s) => s.clear);
  const qc = useQueryClient();
  const cleared = useRef(false);

  const confirm = useQuery({
    queryKey: ["confirm", orderId],
    queryFn: () => api.post<{ status: string; kind: string }>("/checkout/confirm", { orderId }),
    enabled: !!orderId,
    refetchInterval: (q) => (q.state.data?.status === "pending" ? 2000 : false),
  });
  const paid = confirm.data?.status === "paid";

  const order = useQuery({
    queryKey: ["order", orderId, paid],
    queryFn: () => api.get<{ order: Order }>(`/me/orders/${orderId}`).then((r) => r.order),
    enabled: paid,
  });

  useEffect(() => {
    if (paid && !cleared.current) {
      cleared.current = true;
      if (!pro) clear();
      qc.invalidateQueries({ queryKey: qk.session });
      qc.invalidateQueries({ queryKey: ["me"] });
    }
  }, [paid, pro, clear, qc]);

  if (!orderId)
    return (
      <div className="container-page py-24 text-center">
        <p className="text-muted-foreground">No order found.</p>
        <Button className="mt-6" asChild>
          <Link href="/dashboard">Go to dashboard</Link>
        </Button>
      </div>
    );

  const first = order.data?.items.find((i) => i.slug);

  return (
    <div className="relative">
      {paid && <Confetti />}
      <div className="container-page relative flex flex-col items-center py-20 text-center sm:py-28">
        {!paid ? (
          <>
            <span className="flex size-16 items-center justify-center rounded-full border border-border bg-surface text-muted-foreground shadow-card">
              <Clock className="size-7" />
            </span>
            <h1 className="mt-6 text-[2rem] leading-tight tracking-[-0.035em]">Confirming your payment…</h1>
            <p className="mt-3 text-muted-foreground">This usually takes a few seconds. Please don't close this tab.</p>
          </>
        ) : (
          <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }} className="flex flex-col items-center">
            <span className="flex size-16 items-center justify-center rounded-full bg-success-soft text-success">
              {pro ? <Sparkles className="size-7" /> : <CheckCircle2 className="size-8" strokeWidth={1.75} />}
            </span>
            <h1 className="mt-6 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">
              {pro ? (
                <>
                  Welcome to Pro
                </>
              ) : (
                <>
                  You're in. Let's learn.
                </>
              )}
            </h1>
            <p className="mt-4 max-w-lg text-[16.5px] leading-relaxed text-muted-foreground">
              {pro ? "Every course in the catalog is now unlocked. Pick anything and start learning." : "Your purchase is complete and your courses are ready. A receipt is on its way to your inbox."}
            </p>

            {order.data && (
              <div className="card mt-10 w-full max-w-md p-6 text-left">
                <p className="text-[13px] text-muted-foreground">Order <span className="font-mono text-foreground">{order.data.id}</span></p>
                <ul className="mt-4 space-y-2 text-sm">
                  {order.data.items.map((i) => (
                    <li key={i.title} className="flex justify-between gap-4">
                      <span className="text-muted-foreground">{i.title}</span>
                      <span className="tabular-nums">{formatPrice(i.priceCents, order.data!.currency)}</span>
                    </li>
                  ))}
                </ul>
                {order.data.discountCents > 0 && (
                  <div className="mt-2 flex justify-between text-sm text-success">
                    <span>Discount {order.data.couponCode && `(${order.data.couponCode})`}</span>
                    <span>−{formatPrice(order.data.discountCents, order.data.currency)}</span>
                  </div>
                )}
                <div className="mt-4 flex items-baseline justify-between border-t border-border pt-4 font-medium">
                  <span>Total paid</span>
                  <span className="text-xl font-semibold tabular-nums tracking-[-0.03em]">{formatPrice(order.data.totalCents, order.data.currency)}</span>
                </div>
              </div>
            )}

            <div className="mt-10 flex flex-col gap-3 sm:flex-row">
              {first?.slug && !pro ? (
                <Button size="lg" asChild>
                  <Link href={`/learn/${first.slug}`}>
                    Start “{first.title.length > 28 ? `${first.title.slice(0, 28)}…` : first.title}” <ArrowRight />
                  </Link>
                </Button>
              ) : (
                <Button size="lg" asChild>
                  <Link href="/courses">
                    Explore the catalog <ArrowRight />
                  </Link>
                </Button>
              )}
              <Button size="lg" variant="secondary" asChild>
                <Link href="/dashboard">Go to my dashboard</Link>
              </Button>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
}
