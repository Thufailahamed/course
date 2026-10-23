import type { Metadata } from "next";
import { LearnShell } from "@/components/learn/learn-shell";
import { RedirectToLogin } from "@/components/redirect-to-login";
import { getSession } from "@/lib/server";

export const metadata: Metadata = { title: "Learning", robots: { index: false } };

export default async function LearnLayout({ children, params }: { children: React.ReactNode; params: Promise<{ slug: string }> }) {
  const [{ slug }, user] = await Promise.all([params, getSession()]);
  if (!user) return <RedirectToLogin />;
  return <LearnShell slug={slug}>{children}</LearnShell>;
}
