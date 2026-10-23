"use client";

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Copy, Plus, TicketPercent } from "lucide-react";
import type { Coupon, CourseCard, Paginated } from "@latent/shared";
import { AdminOnly, ConfirmDialog, EmptyRow, IconDelete, money, MoneyInput, PageHeader, Segmented, SkeletonRows, Table, TableCard, Td, Th, Tr, useConfirm } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { ProgressBar } from "@/components/ui/display";
import { Field, Input, Select } from "@/components/ui/input";
import { Badge, Dialog, DialogContent, Switch, Tooltip } from "@/components/ui/primitives";
import { api, ApiError } from "@/lib/api";
import { toastError } from "@/lib/hooks";
import { formatDate } from "@/lib/utils";

function CouponsPage() {
  const qc = useQueryClient();
  const [creating, setCreating] = useState(false);
  const del = useConfirm<Coupon>();
  const { data, isPending } = useQuery({ queryKey: ["admin", "coupons"], queryFn: () => api.get<{ items: Coupon[] }>("/admin/coupons").then((r) => r.items) });
  const refresh = () => qc.invalidateQueries({ queryKey: ["admin", "coupons"] });

  const toggle = useMutation({
    mutationFn: ({ id, active }: { id: string; active: boolean }) => api.patch(`/admin/coupons/${id}`, { active }),
    onSuccess: refresh,
    onError: toastError,
  });
  const remove = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/coupons/${id}`),
    onSuccess: () => {
      toast.success("Coupon deleted");
      del.close();
      refresh();
    },
    onError: toastError,
  });

  const now = new Date().toISOString();
  return (
    <>
      <PageHeader
        title="Coupons"
        description="Discount codes learners enter at checkout."
        actions={
          <Button onClick={() => setCreating(true)}>
            <Plus /> New coupon
          </Button>
        }
      />
      <TableCard>
        <Table>
          <thead>
            <tr>
              <Th>Code</Th>
              <Th>Discount</Th>
              <Th>Applies to</Th>
              <Th>Redemptions</Th>
              <Th>Expires</Th>
              <Th>Active</Th>
              <Th align="right">
                <span className="sr-only">Actions</span>
              </Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={7} rows={4} />}
            {data?.length === 0 && <EmptyRow cols={7} icon={<TicketPercent />} title="No coupons yet" description="Create a code for launches, students or partners." />}
            {data?.map((c) => {
              const expired = !!c.expiresAt && c.expiresAt < now;
              const exhausted = !!c.maxRedemptions && c.redemptions >= c.maxRedemptions;
              return (
                <Tr key={c.id}>
                  <Td>
                    <div className="flex items-center gap-2">
                      <span className="rounded-lg border border-dashed border-border-strong bg-surface-2 px-2.5 py-1 font-mono text-[13px] font-semibold tracking-wide">{c.code}</span>
                      <Tooltip content="Copy code">
                        <button
                          onClick={() => {
                            navigator.clipboard.writeText(c.code);
                            toast.success("Copied");
                          }}
                          className="rounded-md p-1 text-subtle-foreground hover:text-foreground"
                          aria-label="Copy code"
                        >
                          <Copy className="size-3.5" />
                        </button>
                      </Tooltip>
                    </div>
                  </Td>
                  <Td className="font-medium">{c.percentOff ? `${c.percentOff}% off` : `${money(c.amountOffCents ?? 0)} off`}</Td>
                  <Td className="max-w-56 truncate text-muted-foreground">{c.courseTitle ?? "All courses"}</Td>
                  <Td>
                    <div className="w-36">
                      <div className="text-xs tabular-nums text-muted-foreground">
                        {c.redemptions.toLocaleString()} {c.maxRedemptions ? `/ ${c.maxRedemptions.toLocaleString()}` : "used"}
                      </div>
                      {c.maxRedemptions && <ProgressBar value={(c.redemptions / c.maxRedemptions) * 100} size="sm" className="mt-1.5" />}
                    </div>
                  </Td>
                  <Td className="whitespace-nowrap text-muted-foreground">
                    {c.expiresAt ? formatDate(c.expiresAt) : "Never"}
                    {(expired || exhausted) && (
                      <Badge variant="danger" size="sm" className="ml-2">
                        {expired ? "Expired" : "Used up"}
                      </Badge>
                    )}
                  </Td>
                  <Td>
                    <Switch checked={c.active} onCheckedChange={(active) => toggle.mutate({ id: c.id, active })} aria-label="Active" />
                  </Td>
                  <Td align="right">
                    <IconDelete onClick={() => del.ask(c)} label="Delete coupon" />
                  </Td>
                </Tr>
              );
            })}
          </tbody>
        </Table>
      </TableCard>
      <CouponDialog open={creating} onOpenChange={setCreating} onCreated={refresh} />
      <ConfirmDialog
        open={del.open}
        onOpenChange={(o) => !o && del.close()}
        title={`Delete ${del.target?.code}?`}
        description="Learners won't be able to use this code anymore. Past orders keep their discount."
        confirmLabel="Delete coupon"
        loading={remove.isPending}
        onConfirm={() => del.target && remove.mutate(del.target.id)}
      />
    </>
  );
}

function CouponDialog({ open, onOpenChange, onCreated }: { open: boolean; onOpenChange: (o: boolean) => void; onCreated: () => void }) {
  const [code, setCode] = useState("");
  const [kind, setKind] = useState<"percent" | "amount">("percent");
  const [percent, setPercent] = useState("20");
  const [amount, setAmount] = useState<number | null>(1000);
  const [max, setMax] = useState("");
  const [expires, setExpires] = useState("");
  const [courseId, setCourseId] = useState("");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const courses = useQuery({
    queryKey: ["admin", "courses", "all"],
    queryFn: () => api.get<Paginated<CourseCard>>("/admin/courses?pageSize=100").then((r) => r.items),
    enabled: open,
  });
  const create = useMutation({
    mutationFn: () =>
      api.post("/admin/coupons", {
        code: code.trim().toUpperCase(),
        percentOff: kind === "percent" ? Number(percent) : null,
        amountOffCents: kind === "amount" ? amount : null,
        maxRedemptions: max ? Number(max) : null,
        expiresAt: expires ? new Date(`${expires}T23:59:59`).toISOString() : null,
        courseId: courseId || null,
        active: true,
      }),
    onSuccess: () => {
      toast.success("Coupon created");
      onCreated();
      onOpenChange(false);
      setCode("");
      setErrors({});
    },
    onError: (e) => {
      if (e instanceof ApiError && e.fields) setErrors(e.fields);
      toastError(e);
    },
  });
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent title="New coupon" description="Codes are case-insensitive for learners.">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            create.mutate();
          }}
          className="space-y-5"
        >
          <Field label="Code" error={errors.code} hint="Letters, numbers, - and _">
            {(p) => (
              <div className="flex gap-2">
                <Input {...p} value={code} onChange={(e) => setCode(e.target.value.toUpperCase().replace(/[^A-Z0-9_-]/g, ""))} placeholder="SPRING25" className="font-mono uppercase tracking-wide" />
                <Button type="button" variant="secondary" onClick={() => setCode(`LATENT${Math.random().toString(36).slice(2, 6).toUpperCase()}`)}>
                  Generate
                </Button>
              </div>
            )}
          </Field>
          <div className="space-y-3">
            <Segmented
              value={kind}
              onChange={setKind}
              options={[
                { value: "percent", label: "Percentage" },
                { value: "amount", label: "Fixed amount" },
              ]}
            />
            {kind === "percent" ? (
              <Field label="Percent off" error={errors.percentOff}>
                {(p) => (
                  <div className="relative">
                    <Input {...p} type="number" min={1} max={100} value={percent} onChange={(e) => setPercent(e.target.value)} className="pr-8 tabular-nums" />
                    <span className="pointer-events-none absolute right-3.5 top-1/2 -translate-y-1/2 text-sm text-subtle-foreground">%</span>
                  </div>
                )}
              </Field>
            ) : (
              <Field label="Amount off">{(p) => <MoneyInput {...p} cents={amount} onChange={setAmount} />}</Field>
            )}
          </div>
          <div className="grid gap-5 sm:grid-cols-2">
            <Field label="Max redemptions" optional>
              {(p) => <Input {...p} type="number" min={1} value={max} onChange={(e) => setMax(e.target.value)} placeholder="Unlimited" />}
            </Field>
            <Field label="Expires on" optional>
              {(p) => <Input {...p} type="date" value={expires} onChange={(e) => setExpires(e.target.value)} />}
            </Field>
          </div>
          <Field label="Applies to">
            {(p) => (
              <Select {...p} value={courseId} onChange={(e) => setCourseId(e.target.value)}>
                <option value="">All courses</option>
                {courses.data?.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.title}
                  </option>
                ))}
              </Select>
            )}
          </Field>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" loading={create.isPending} disabled={code.length < 3}>
              Create coupon
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export default function Page() {
  return (
    <AdminOnly>
      <CouponsPage />
    </AdminOnly>
  );
}
