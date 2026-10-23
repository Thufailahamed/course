"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { CreditCard, ShieldCheck, UserRound } from "lucide-react";
import { cn } from "@/lib/utils";

const ITEMS = [
  { href: "/account", label: "Profile", icon: UserRound },
  { href: "/account/security", label: "Security", icon: ShieldCheck },
  { href: "/account/billing", label: "Billing & orders", icon: CreditCard },
];

export function AccountNav() {
  const pathname = usePathname();
  return (
    <nav className="-mx-1 flex gap-1 overflow-x-auto pb-1 md:mx-0 md:flex-col md:overflow-visible md:pb-0" aria-label="Account settings">
      {ITEMS.map((i) => {
        const active = pathname === i.href;
        return (
          <Link
            key={i.href}
            href={i.href}
            aria-current={active ? "page" : undefined}
            className={cn(
              "flex shrink-0 items-center gap-2.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors [&_svg]:size-4",
              active ? "bg-surface-3/70 text-foreground" : "text-muted-foreground hover:bg-surface-2 hover:text-foreground",
            )}
          >
            <i.icon className={active ? "text-foreground" : "text-subtle-foreground"} />
            {i.label}
          </Link>
        );
      })}
    </nav>
  );
}
