"use client";

import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { FolderTree, PencilLine, Plus } from "lucide-react";
import type { Category } from "@latent/shared";
import { slugify } from "@latent/shared";
import { AdminOnly, ConfirmDialog, EmptyRow, IconDelete, PageHeader, SkeletonRows, Table, TableCard, Td, Th, Tr, useConfirm } from "@/components/studio/kit";
import { Button } from "@/components/ui/button";
import { Field, Input, Textarea } from "@/components/ui/input";
import { Dialog, DialogContent } from "@/components/ui/primitives";
import { api } from "@/lib/api";
import { toastError } from "@/lib/hooks";

function CategoriesPage() {
  const qc = useQueryClient();
  const [editing, setEditing] = useState<Category | "new" | null>(null);
  const del = useConfirm<Category>();
  const { data, isPending } = useQuery({ queryKey: ["categories"], queryFn: () => api.get<{ items: Category[] }>("/categories").then((r) => r.items) });
  const remove = useMutation({
    mutationFn: (id: string) => api.delete(`/admin/categories/${id}`),
    onSuccess: () => {
      toast.success("Category deleted");
      del.close();
      qc.invalidateQueries({ queryKey: ["categories"] });
    },
    onError: toastError,
  });

  return (
    <>
      <PageHeader
        title="Categories"
        description="Topics that organize the catalog and power the Explore menu."
        actions={
          <Button onClick={() => setEditing("new")}>
            <Plus /> New category
          </Button>
        }
      />
      <TableCard>
        <Table className="min-w-[600px]">
          <thead>
            <tr>
              <Th>Name</Th>
              <Th>Slug</Th>
              <Th>Description</Th>
              <Th align="right">Published courses</Th>
              <Th align="right">
                <span className="sr-only">Actions</span>
              </Th>
            </tr>
          </thead>
          <tbody>
            {isPending && <SkeletonRows cols={5} rows={5} />}
            {data?.length === 0 && <EmptyRow cols={5} icon={<FolderTree />} title="No categories yet" />}
            {data?.map((c) => (
              <Tr key={c.id}>
                <Td className="font-medium">{c.name}</Td>
                <Td className="font-mono text-xs text-muted-foreground">{c.slug}</Td>
                <Td className="max-w-md truncate text-muted-foreground">{c.description ?? "—"}</Td>
                <Td align="right">{c.coursesCount ?? 0}</Td>
                <Td align="right">
                  <div className="flex justify-end gap-1">
                    <Button variant="ghost" size="icon-sm" onClick={() => setEditing(c)} aria-label="Edit category">
                      <PencilLine />
                    </Button>
                    <IconDelete onClick={() => del.ask(c)} label="Delete category" />
                  </div>
                </Td>
              </Tr>
            ))}
          </tbody>
        </Table>
      </TableCard>
      <CategoryDialog category={editing} onClose={() => setEditing(null)} />
      <ConfirmDialog
        open={del.open}
        onOpenChange={(o) => !o && del.close()}
        title={`Delete "${del.target?.name}"?`}
        description="Courses in this category become uncategorized. They stay published."
        confirmLabel="Delete category"
        loading={remove.isPending}
        onConfirm={() => del.target && remove.mutate(del.target.id)}
      />
    </>
  );
}

function CategoryDialog({ category, onClose }: { category: Category | "new" | null; onClose: () => void }) {
  const qc = useQueryClient();
  const existing = category && category !== "new" ? category : null;
  const [name, setName] = useState("");
  const [slug, setSlug] = useState("");
  const [description, setDescription] = useState("");
  const [icon, setIcon] = useState("");
  useEffect(() => {
    setName(existing?.name ?? "");
    setSlug(existing?.slug ?? "");
    setDescription(existing?.description ?? "");
    setIcon(existing?.icon ?? "");
  }, [category]); // eslint-disable-line react-hooks/exhaustive-deps

  const save = useMutation({
    mutationFn: () => {
      const body = { name: name.trim(), slug: slugify(slug || name), description: description.trim() || null, icon: icon.trim() || null };
      return existing ? api.patch(`/admin/categories/${existing.id}`, body) : api.post("/admin/categories", body);
    },
    onSuccess: () => {
      toast.success(existing ? "Category updated" : "Category created");
      qc.invalidateQueries({ queryKey: ["categories"] });
      onClose();
    },
    onError: toastError,
  });

  return (
    <Dialog open={!!category} onOpenChange={(o) => !o && onClose()}>
      <DialogContent title={existing ? "Edit category" : "New category"}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            if (name.trim().length >= 2) save.mutate();
          }}
          className="space-y-5"
        >
          <Field label="Name">{(p) => <Input {...p} autoFocus value={name} onChange={(e) => setName(e.target.value)} placeholder="e.g. Reinforcement Learning" />}</Field>
          <div className="grid gap-5 sm:grid-cols-2">
            <Field label="Slug" hint={`/courses?category=${slugify(slug || name) || "…"}`}>
              {(p) => <Input {...p} value={slug} onChange={(e) => setSlug(e.target.value)} placeholder={slugify(name)} className="font-mono text-[13px]" />}
            </Field>
            <Field label="Icon" optional hint="lucide icon name, e.g. brain">
              {(p) => <Input {...p} value={icon} onChange={(e) => setIcon(e.target.value)} />}
            </Field>
          </div>
          <Field label="Description" optional>
            {(p) => <Textarea {...p} rows={3} value={description} onChange={(e) => setDescription(e.target.value)} maxLength={500} />}
          </Field>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" loading={save.isPending} disabled={name.trim().length < 2}>
              {existing ? "Save changes" : "Create category"}
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
      <CategoriesPage />
    </AdminOnly>
  );
}
