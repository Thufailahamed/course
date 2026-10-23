"use client";

import { useMemo, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Download, Inbox, Search } from "lucide-react";
import type { Lead } from "@latent/shared";
import { AdminOnly, downloadCsv, EmptyRow, PageHeader, SkeletonRows, Table, TableCard, Td, Th, Tr } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge, Dialog, DialogContent } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { formatDate, timeAgo } from "@/lib/utils";

function LeadsPage() {
  const [q, setQ] = useState("");
  const [open, setOpen] = useState<Lead | null>(null);
  const { data, isPending } = useQuery({ queryKey: ["admin", "leads"], queryFn: () => api.get<{ items: Lead[] }>("/admin/leads").then((r) => r.items) });
  const rows = useMemo(() => {
    const t = q.trim().toLowerCase();
    return (data ?? []).filter((l) => !t || [l.name, l.email, l.company ?? ""].some((s) => s.toLowerCase().includes(t)));
  }, [data, q]);

  return (
    <>
      <PageHeader
        title="Team leads"
        description="Inquiries from the For Teams page."
        actions={
          <Button
            variant="secondary"
            disabled={!rows.length}
            onClick={() =>
              downloadCsv(`latent-leads-${new Date().toISOString().slice(0, 10)}.csv`, [
                ["Name", "Email", "Company", "Team size", "Message", "Received"],
                ...rows.map((l) => [l.name, l.email, l.company, l.teamSize, l.message, l.createdAt]),
              ])
            }
          >
            <Download /> Export CSV
          </Button>
        }
      />
      <TableCard
        toolbar={
          <div className="w-full sm:w-80">
            <Input icon={<Search />} placeholder="Search name, email or company" value={q} onChange={(e) => setQ(e.target.value)} className="h-9" />
          </div>
        }
      >
        <Table>
          <thead>
            <tr>
              <Th>Contact</Th>
              <Th>Company</Th>
              <Th>Team size</Th>
              <Th>Message</Th>
              <Th>Received</Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={5} rows={4} />}
            {!isPending && rows.length === 0 && <EmptyRow cols={5} icon={<Inbox />} title="No leads yet" description="Submissions from the Teams contact form will appear here." />}
            {rows.map((l) => (
              <Tr key={l.id} onClick={() => setOpen(l)}>
                <Td>
                  <div className="font-medium">{l.name}</div>
                  <div className="text-xs text-subtle-foreground">{l.email}</div>
                </Td>
                <Td>{l.company ?? "—"}</Td>
                <Td>{l.teamSize ? <Badge size="sm">{l.teamSize}</Badge> : "—"}</Td>
                <Td className="max-w-sm truncate text-muted-foreground">{l.message ?? "—"}</Td>
                <Td className="whitespace-nowrap text-muted-foreground">{timeAgo(l.createdAt)}</Td>
              </Tr>
            ))}
          </tbody>
        </Table>
      </TableCard>
      <Dialog open={!!open} onOpenChange={(o) => !o && setOpen(null)}>
        <DialogContent title={open?.name} description={open ? `${open.company ?? "No company"} · ${formatDate(open.createdAt)}` : undefined}>
          {open && (
            <div className="space-y-4">
              <dl className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <dt className="text-xs text-subtle-foreground">Email</dt>
                  <dd className="mt-0.5 break-all">{open.email}</dd>
                </div>
                <div>
                  <dt className="text-xs text-subtle-foreground">Team size</dt>
                  <dd className="mt-0.5">{open.teamSize ?? "—"}</dd>
                </div>
              </dl>
              <div className="whitespace-pre-line rounded-xl bg-surface-2/60 p-4 text-sm leading-relaxed text-muted-foreground">{open.message || "No message."}</div>
              <Button asChild className="w-full">
                <a href={`mailto:${open.email}?subject=${encodeURIComponent("Latent for Teams")}`}>Reply by email</a>
              </Button>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </>
  );
}

export default function Page() {
  return (
    <AdminOnly>
      <LeadsPage />
    </AdminOnly>
  );
}
