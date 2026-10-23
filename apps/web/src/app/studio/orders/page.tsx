"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { keepPreviousData, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Receipt, RotateCcw, Search, Sparkles } from "lucide-react";
import type { Order, OrderStatus, Paginated } from "@latent/shared";
import {
  AdminOnly,
  ConfirmDialog,
  EmptyRow,
  money,
  PageHeader,
  Pagination,
  Segmented,
  SkeletonRows,
  Table,
  TableCard,
  Td,
  Th,
  Tr,
  useConfirm,
  useDebounced,
} from "@/components/studio/kit";
import { OrderStatusBadge } from "@/components/studio/order-status";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/display";
import { Input } from "@/components/ui/input";
import { Badge, Dialog, DialogContent, Separator } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

type OrdersResponse = Paginated<Order> & { totals: { paidCents: number; refundedCents: number } };

function OrdersPage() {
  const qc = useQueryClient();
  const [status, setStatus] = useState<"" | OrderStatus>("");
  const [q, setQ] = useState("");
  const [page, setPage] = useState(1);
  const [detail, setDetail] = useState<Order | null>(null);
  const refund = useConfirm<Order>();
  const query = useDebounced(q);
  useEffect(() => setPage(1), [query, status]);

  const { data, isPending } = useQuery({
    queryKey: ["admin", "orders", { status, query, page }],
    queryFn: () => api.get<OrdersResponse>(`/admin/orders?page=${page}&pageSize=20${status ? `&status=${status}` : ""}${query ? `&q=${encodeURIComponent(query)}` : ""}`),
    placeholderData: keepPreviousData,
  });

  const doRefund = useMutation({
    mutationFn: (id: string) => api.post(`/admin/orders/${id}/refund`),
    onSuccess: () => {
      toast.success("Order refunded and access revoked");
      refund.close();
      setDetail(null);
      qc.invalidateQueries({ queryKey: ["admin", "orders"] });
    },
    onError: toastError,
  });

  return (
    <>
      <PageHeader title="Orders" description="Every purchase and membership payment." />
      <div className="mb-4 grid gap-4 sm:grid-cols-3">
        {[
          { label: "Gross paid (all time)", value: data ? money(data.totals.paidCents) : null },
          { label: "Refunded (all time)", value: data ? money(data.totals.refundedCents) : null },
          { label: "Orders in view", value: data ? data.total.toLocaleString() : null },
        ].map((s) => (
          <div key={s.label} className="card px-5 py-4">
            <div className="text-xs text-muted-foreground">{s.label}</div>
            {s.value === null ? <div className="skeleton mt-1.5 h-6 w-24" /> : <div className="mt-1.5 text-2xl font-semibold tabular-nums leading-tight tracking-[-0.03em]">{s.value}</div>}
          </div>
        ))}
      </div>
      <TableCard
        toolbar={
          <>
            <Segmented
              value={status}
              onChange={setStatus}
              options={[
                { value: "", label: "All" },
                { value: "paid", label: "Paid" },
                { value: "pending", label: "Pending" },
                { value: "refunded", label: "Refunded" },
              ]}
            />
            <div className="sm:ml-auto sm:w-72">
              <Input icon={<Search />} placeholder="Search email or order ID" value={q} onChange={(e) => setQ(e.target.value)} className="h-9" />
            </div>
          </>
        }
        footer={data && <Pagination page={data.page} pageCount={data.pageCount} total={data.total} onPage={setPage} label="orders" />}
      >
        <Table>
          <thead>
            <tr>
              <Th>Order</Th>
              <Th>Customer</Th>
              <Th>Items</Th>
              <Th>Status</Th>
              <Th align="right">Total</Th>
              <Th>Date</Th>
              <Th align="right">
                <span className="sr-only">Actions</span>
              </Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={7} />}
            {data?.items.length === 0 && <EmptyRow cols={7} icon={<Receipt />} title="No orders found" />}
            {data?.items.map((o) => (
              <Tr key={o.id} onClick={() => setDetail(o)}>
                <Td className="font-mono text-xs text-muted-foreground">{o.id}</Td>
                <Td>
                  {o.user ? (
                    <div className="flex items-center gap-2.5">
                      <Avatar name={o.user.name} size={28} />
                      <div className="min-w-0">
                        <div className="truncate text-sm font-medium">{o.user.name}</div>
                        <div className="truncate text-xs text-subtle-foreground">{o.user.email}</div>
                      </div>
                    </div>
                  ) : (
                    "—"
                  )}
                </Td>
                <Td className="max-w-64">
                  <div className="flex items-center gap-1.5">
                    {o.kind === "subscription" && (
                      <Badge variant="primary" size="sm">
                        <Sparkles /> Pro
                      </Badge>
                    )}
                    <span className="truncate text-muted-foreground">{o.items.map((i) => i.title).join(", ")}</span>
                  </div>
                </Td>
                <Td>
                  <OrderStatusBadge status={o.status} />
                </Td>
                <Td align="right" className="font-medium">
                  {money(o.totalCents, o.currency)}
                  {o.couponCode && <div className="font-mono text-[11px] font-normal text-subtle-foreground">{o.couponCode}</div>}
                </Td>
                <Td className="whitespace-nowrap text-muted-foreground">{formatDate(o.createdAt)}</Td>
                <Td align="right">
                  {o.status === "paid" && (
                    <Button
                      variant="ghost"
                      size="xs"
                      onClick={(e) => {
                        e.stopPropagation();
                        refund.ask(o);
                      }}
                    >
                      <RotateCcw /> Refund
                    </Button>
                  )}
                </Td>
              </Tr>
            ))}
          </tbody>
        </Table>
      </TableCard>

      <Dialog open={!!detail} onOpenChange={(o) => !o && setDetail(null)}>
        <DialogContent title="Order details" description={detail?.id}>
          {detail && (
            <div className="space-y-5">
              <div className="flex items-center justify-between">
                {detail.user && (
                  <Link href={`/studio/students/${detail.user.id}`} className="flex items-center gap-3 hover:text-accent">
                    <Avatar name={detail.user.name} size={36} />
                    <div>
                      <div className="text-sm font-medium">{detail.user.name}</div>
                      <div className="text-xs text-subtle-foreground">{detail.user.email}</div>
                    </div>
                  </Link>
                )}
                <OrderStatusBadge status={detail.status} />
              </div>
              <div className="rounded-2xl border border-border">
                {detail.items.map((i, idx) => (
                  <div key={idx} className="flex items-center justify-between gap-4 border-b border-border px-4 py-3 text-sm last:border-0">
                    <span className="min-w-0 truncate">{i.title}</span>
                    <span className="tabular-nums">{money(i.priceCents, detail.currency)}</span>
                  </div>
                ))}
              </div>
              <dl className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <dt className="text-muted-foreground">Subtotal</dt>
                  <dd className="tabular-nums">{money(detail.subtotalCents, detail.currency)}</dd>
                </div>
                {detail.discountCents > 0 && (
                  <div className="flex justify-between">
                    <dt className="text-muted-foreground">Discount {detail.couponCode && <span className="font-mono text-xs">({detail.couponCode})</span>}</dt>
                    <dd className="tabular-nums text-success">−{money(detail.discountCents, detail.currency)}</dd>
                  </div>
                )}
                <Separator />
                <div className="flex justify-between text-base font-semibold">
                  <dt>Total</dt>
                  <dd className="tabular-nums">{money(detail.totalCents, detail.currency)}</dd>
                </div>
                <div className="flex justify-between text-xs text-subtle-foreground">
                  <dt>Created {formatDate(detail.createdAt, { month: "short", day: "numeric", year: "numeric", hour: "numeric", minute: "2-digit" })}</dt>
                  {detail.paidAt && <dd>Paid {formatDate(detail.paidAt, { month: "short", day: "numeric", year: "numeric", hour: "numeric", minute: "2-digit" })}</dd>}
                </div>
              </dl>
              {detail.status === "paid" && (
                <Button variant="danger-soft" className="w-full" onClick={() => refund.ask(detail)}>
                  <RotateCcw /> Refund order
                </Button>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>

      <ConfirmDialog
        open={refund.open}
        onOpenChange={(o) => !o && refund.close()}
        title={`Refund ${refund.target ? money(refund.target.totalCents, refund.target.currency) : ""}?`}
        description="The payment is refunded through Stripe (when configured) and course access granted by this order is revoked."
        confirmLabel="Refund order"
        loading={doRefund.isPending}
        onConfirm={() => refund.target && doRefund.mutate(refund.target.id)}
      />
    </>
  );
}

export default function Page() {
  return (
    <AdminOnly>
      <OrdersPage />
    </AdminOnly>
  );
}
