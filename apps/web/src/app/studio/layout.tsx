import type { Metadata } from "next";
import { StudioShell } from "@/components/studio/shell";
import { requireStaff } from "@/lib/server";

export const metadata: Metadata = { title: { default: "Studio", template: "%s · Studio · Latent" } };

export default async function StudioLayout({ children }: { children: React.ReactNode }) {
  const user = await requireStaff("/studio");
  return <StudioShell user={user}>{children}</StudioShell>;
}
