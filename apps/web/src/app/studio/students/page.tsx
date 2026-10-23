"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { RoleSelect } from "@/components/studio/role-select";
import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { Download, Search, Sparkles, Users } from "lucide-react";
import type { AdminUser, Paginated, Role } from "@latent/shared";
import { AdminOnly, downloadCsv, money, EmptyRow, PageHeader, Pagination, Segmented, SkeletonRows, Table, TableCard, Td, Th, Tr, useDebounced } from "@/components/studio/kit";
import { useStudioUser } from "@/components/studio/shell";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/display";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { formatDate } from "@/lib/utils";

function StudentsPage() {
  const router = useRouter();
  const { user: me } = useStudioUser();
  const [q, setQ] = useState("");
  const [role, setRole] = useState<"" | Role>("");
  const [page, setPage] = useState(1);
  const query = useDebounced(q);
  useEffect(() => setPage(1), [query, role]);

  const { data, isPending } = useQuery({
    queryKey: ["admin", "users", { query, role, page }],
    queryFn: () => api.get<Paginated<AdminUser>>(`/admin/users?page=${page}&pageSize=20${role ? `&role=${role}` : ""}${query ? `&q=${encodeURIComponent(query)}` : ""}`),
    placeholderData: keepPreviousData,
  });

  return (
    <>
      <PageHeader
        title="Students"
        description="Everyone with an account. Manage roles and course access."
        actions={
          <Button
            variant="secondary"
            disabled={!data?.items.length}
            onClick={() =>
              downloadCsv("students.csv", [
                ["Name", "Email", "Role", "Joined", "Enrollments", "Spent (USD)", "Pro"],
                ...(data?.items ?? []).map((u) => [u.name, u.email, u.role, u.createdAt, u.enrollments, (u.spentCents / 100).toFixed(2), u.hasPro ? "yes" : "no"]),
              ])
            }
          >
            <Download /> Export page
          </Button>
        }
      />
      <TableCard
        toolbar={
          <>
            <Segmented
              value={role}
              onChange={setRole}
              options={[
                { value: "", label: "Everyone" },
                { value: "student", label: "Students" },
                { value: "instructor", label: "Instructors" },
                { value: "admin", label: "Admins" },
              ]}
            />
            <div className="sm:ml-auto sm:w-72">
              <Input icon={<Search />} placeholder="Search name or email" value={q} onChange={(e) => setQ(e.target.value)} className="h-9" />
            </div>
          </>
        }
        footer={data && <Pagination page={data.page} pageCount={data.pageCount} total={data.total} onPage={setPage} label="people" />}
      >
        <Table>
          <thead>
            <tr>
              <Th>Person</Th>
              <Th>Role</Th>
              <Th>Membership</Th>
              <Th align="right">Courses</Th>
              <Th align="right">Lifetime spend</Th>
              <Th>Joined</Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={6} />}
            {data?.items.length === 0 && <EmptyRow cols={6} icon={<Users />} title="No people found" description="Try a different search or filter." />}
            {data?.items.map((u) => (
              <Tr key={u.id} onClick={() => router.push(`/studio/students/${u.id}`)}>
                <Td>
                  <div className="flex items-center gap-3">
                    <Avatar name={u.name} src={u.avatarUrl} size={34} />
                    <div className="min-w-0">
                      <div className="truncate font-medium">{u.name}</div>
                      <div className="truncate text-xs text-subtle-foreground">{u.email}</div>
                    </div>
                  </div>
                </Td>
                <Td>
                  <RoleSelect userId={u.id} role={u.role} disabled={u.id === me.id} />
                </Td>
                <Td>
                  {u.hasPro ? (
                    <Badge variant="primary" size="sm">
                      <Sparkles /> Pro
                    </Badge>
                  ) : (
                    <span className="text-xs text-subtle-foreground">Free</span>
                  )}
                </Td>
                <Td align="right">{u.enrollments}</Td>
                <Td align="right" className="font-medium">
                  {money(u.spentCents)}
                </Td>
                <Td className="whitespace-nowrap text-muted-foreground">{formatDate(u.createdAt)}</Td>
              </Tr>
            ))}
          </tbody>
        </Table>
      </TableCard>
    </>
  );
}

export default function Page() {
  return (
    <AdminOnly>
      <StudentsPage />
    </AdminOnly>
  );
}
