"use client";

import Link from "next/link";
import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowRight, CreditCard, ExternalLink, Printer, Receipt, Sparkles } from "lucide-react";
import type { Order, OrderStatus, Subscription } from "@latent/shared";
import { LogoMark } from "@/components/logo";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Badge, Card, CardHeader, Dialog, DialogContent, Skeleton } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { qk, toastError, useConfig, useSession } from "@/lib/hooks";
import { formatDate, formatPrice } from "@/lib/utils";

const STATUS: Record<OrderStatus, { label: string; variant: "success" | "warning" | "danger" | "default" }> = {
  paid: { label: "Paid", variant: "success" },
  pending: { label: "Pending", variant: "warning" },
  refunded: { label: "Refunded", variant: "default" },
  failed: { label: "Failed", variant: "danger" },
};

export default function BillingPage() {
  const qc = useQueryClient();
  const { refetch: refetchSession } = useSession();
  const { data: config } = useConfig();
  const [receipt, setReceipt] = useState<Order | null>(null);
  const [confirmCancel, setConfirmCancel] = useState(false);

  const { data: sub, isPending: loadingSub } = useQuery({
    queryKey: qk.subscription,
    queryFn: () => api.get<{ subscription: Subscription | null }>("/me/subscription").then((r) => r.subscription),
  });
  const { data: orders, isPending: loadingOrders } = useQuery({
    queryKey: qk.orders,
    queryFn: () => api.get<{ items: Order[] }>("/me/orders").then((r) => r.items),
  });

  const subAction = useMutation({
    mutationFn: (action: "cancel" | "resume") => api.post(`/billing/subscription/${action}`),
    onSuccess: (_d, action) => {
      setConfirmCancel(false);
      void qc.invalidateQueries({ queryKey: qk.subscription });
      void refetchSession();
      toast.success(action === "cancel" ? "Your membership will end at the close of this billing period" : "Welcome back — your membership will renew");
    },
    onError: toastError,
  });
  const portal = useMutation({
    mutationFn: () => api.post<{ url: string }>("/billing/portal"),
    onSuccess: ({ url }) => {
      location.href = url;
    },
    onError: toastError,
  });

  const active = sub && ["active", "trialing", "past_due"].includes(sub.status);

  return (
    <div className="space-y-6">
      {/* Membership */}
      <Card className="overflow-hidden">
        <CardHeader
          title="Membership"
          description="Latent Pro gives you unlimited access to every course."
          action={
            config?.paymentsMode === "stripe" && (
              <Button variant="secondary" size="sm" onClick={() => portal.mutate()} loading={portal.isPending}>
                <CreditCard /> Payment methods <ExternalLink className="!size-3.5" />
              </Button>
            )
          }
        />
        {loadingSub ? (
          <div className="p-6">
            <Skeleton className="h-20" />
          </div>
        ) : active && sub ? (
          <div className="p-6">
            <div className="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
              <div className="flex items-center gap-4">
                <span className="flex size-11 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                  <Sparkles className="size-5" />
                </span>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="font-semibold">Latent Pro · {sub.plan === "monthly" ? "Monthly" : "Annual"}</span>
                    <Badge variant={sub.cancelAtPeriodEnd ? "warning" : sub.status === "past_due" ? "danger" : "success"} size="sm">
                      {sub.cancelAtPeriodEnd ? "Canceling" : sub.status === "past_due" ? "Past due" : "Active"}
                    </Badge>
                  </div>
                  <p className="mt-0.5 text-sm text-muted-foreground">
                    {sub.cancelAtPeriodEnd ? "Access ends" : "Renews"} on {formatDate(sub.currentPeriodEnd, { month: "long", day: "numeric", year: "numeric" })}
                    {config && !sub.cancelAtPeriodEnd && ` · ${formatPrice(sub.plan === "monthly" ? config.proMonthlyCents : config.proYearlyCents, config.currency)}/${sub.plan === "monthly" ? "mo" : "yr"}`}
                  </p>
                </div>
              </div>
              {sub.cancelAtPeriodEnd ? (
                <Button onClick={() => subAction.mutate("resume")} loading={subAction.isPending}>
                  Resume membership
                </Button>
              ) : (
                <Button variant="ghost" onClick={() => setConfirmCancel(true)}>
                  Cancel membership
                </Button>
              )}
            </div>
          </div>
        ) : (
          <div className="flex flex-col gap-4 p-6 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <p className="font-medium">You're on pay-per-course</p>
              <p className="mt-0.5 text-sm text-muted-foreground">Upgrade to Pro for every course, path and future release.</p>
            </div>
            <Button asChild>
              <Link href="/pricing">
                See Pro plans <ArrowRight />
              </Link>
            </Button>
          </div>
        )}
      </Card>

      {/* Orders */}
      <Card>
        <CardHeader title="Order history" description="Receipts for every purchase on your account." />
        {loadingOrders ? (
          <div className="space-y-3 p-6">
            {[0, 1, 2].map((i) => (
              <Skeleton key={i} className="h-12" />
            ))}
          </div>
        ) : !orders?.length ? (
          <div className="p-6">
            <EmptyState icon={<Receipt />} title="No orders yet" description="Your receipts will appear here after your first purchase." className="border-0 py-10" />
          </div>
        ) : (
          <ul className="divide-y divide-border">
            {orders.map((o) => (
              <li key={o.id} className="flex flex-wrap items-center gap-x-4 gap-y-2 px-6 py-4">
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-medium">{o.items.map((i) => i.title).join(", ")}</p>
                  <p className="mt-0.5 text-xs text-subtle-foreground">
                    {formatDate(o.createdAt)} · <span className="font-mono">{o.id}</span>
                  </p>
                </div>
                <Badge variant={STATUS[o.status].variant} size="sm">
                  {STATUS[o.status].label}
                </Badge>
                <span className="w-20 text-right text-sm font-semibold tabular-nums">{formatPrice(o.totalCents, o.currency)}</span>
                <Button variant="ghost" size="sm" onClick={() => setReceipt(o)}>
                  <Receipt /> Receipt
                </Button>
              </li>
            ))}
          </ul>
        )}
      </Card>

      {/* Cancel confirm */}
      <Dialog open={confirmCancel} onOpenChange={setConfirmCancel}>
        <DialogContent size="sm" title="Cancel your membership?" description="You'll keep Pro access until the end of your current billing period. You can resume any time before then.">
          <div className="flex justify-end gap-2">
            <Button variant="ghost" onClick={() => setConfirmCancel(false)}>
              Keep Pro
            </Button>
            <Button variant="danger" onClick={() => subAction.mutate("cancel")} loading={subAction.isPending}>
              Cancel membership
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* Receipt */}
      <Dialog open={!!receipt} onOpenChange={(o) => !o && setReceipt(null)}>
        <DialogContent size="md">
          {receipt && <ReceiptView order={receipt} />}
        </DialogContent>
      </Dialog>
    </div>
  );
}

function ReceiptView({ order }: { order: Order }) {
  return (
    <div id="receipt" className="space-y-6">
      <div className="flex items-start justify-between">
        <div className="flex items-center gap-2.5">
          <LogoMark />
          <div>
            <p className="text-base font-semibold leading-tight tracking-[-0.02em]">Latent</p>
            <p className="text-xs text-subtle-foreground">Receipt</p>
          </div>
        </div>
        <Badge variant={STATUS[order.status].variant}>{STATUS[order.status].label}</Badge>
      </div>
      <dl className="grid grid-cols-2 gap-4 rounded-xl border border-border bg-surface-2 p-4 text-sm">
        <div>
          <dt className="text-xs text-subtle-foreground">Order</dt>
          <dd className="mt-0.5 break-all font-mono text-xs">{order.id}</dd>
        </div>
        <div>
          <dt className="text-xs text-subtle-foreground">Date</dt>
          <dd className="mt-0.5">{formatDate(order.paidAt ?? order.createdAt, { month: "long", day: "numeric", year: "numeric" })}</dd>
        </div>
      </dl>
      <table className="w-full text-sm">
        <tbody className="divide-y divide-border">
          {order.items.map((i, idx) => (
            <tr key={idx}>
              <td className="py-2.5 pr-4">
                {i.slug ? (
                  <Link href={`/courses/${i.slug}`} className="hover:text-accent">
                    {i.title}
                  </Link>
                ) : (
                  i.title
                )}
              </td>
              <td className="py-2.5 text-right tabular-nums">{formatPrice(i.priceCents, order.currency)}</td>
            </tr>
          ))}
        </tbody>
        <tfoot className="text-muted-foreground">
          <tr className="border-t border-border-strong">
            <td className="pt-3">Subtotal</td>
            <td className="pt-3 text-right tabular-nums">{formatPrice(order.subtotalCents, order.currency)}</td>
          </tr>
          {order.discountCents > 0 && (
            <tr>
              <td className="pt-1.5">Discount {order.couponCode && <span className="font-mono text-xs">({order.couponCode})</span>}</td>
              <td className="pt-1.5 text-right tabular-nums text-success">−{formatPrice(order.discountCents, order.currency)}</td>
            </tr>
          )}
          <tr className="text-foreground">
            <td className="pt-3 font-semibold">Total</td>
            <td className="pt-3 text-right text-lg font-semibold tabular-nums tracking-[-0.02em]">{formatPrice(order.totalCents, order.currency)}</td>
          </tr>
        </tfoot>
      </table>
      <div className="flex justify-end">
        <Button variant="secondary" size="sm" onClick={() => window.print()}>
          <Printer /> Print
        </Button>
      </div>
    </div>
  );
}
