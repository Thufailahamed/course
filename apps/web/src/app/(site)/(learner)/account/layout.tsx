import type { Metadata } from "next";
import { AccountNav } from "@/components/learner/account-nav";

export const metadata: Metadata = { title: "Account settings", robots: { index: false } };

export default function AccountLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="container-page py-10 sm:py-14">
      <h1 className="text-[1.75rem] leading-tight sm:text-[2rem]">Account settings</h1>
      <p className="mt-2 text-muted-foreground">Manage your profile, security and billing.</p>
      <div className="mt-8 grid gap-8 border-t border-border pt-8 md:grid-cols-[220px_1fr] lg:gap-14">
        <aside className="md:sticky md:top-24 md:self-start">
          <AccountNav />
        </aside>
        <div className="min-w-0 max-w-3xl">{children}</div>
      </div>
    </div>
  );
}
