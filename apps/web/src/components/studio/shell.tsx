"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { createContext, useContext, useEffect, useState } from "react";
import { Dialog as D } from "radix-ui";
import {
  ArrowUpRight,
  BookOpen,
  FolderTree,
  Inbox,
  LayoutDashboard,
  LogOut,
  Mail,
  Menu,
  MessageSquareText,
  Receipt,
  Route,
  Star,
  TicketPercent,
  Users,
} from "lucide-react";
import type { SessionUser } from "@latent/shared";
import { Logo } from "@/components/logo";
import { Button } from "@/components/ui/button";
import { Avatar } from "@/components/ui/display";
import { Badge, Dialog, SheetContent } from "@/components/ui/primitives";
import { useLogout } from "@/lib/hooks";
import { cn } from "@/lib/utils";

const StudioUserContext = createContext<SessionUser | null>(null);

export function useStudioUser() {
  const u = useContext(StudioUserContext);
  if (!u) throw new Error("useStudioUser must be used inside the studio shell");
  return { user: u, isAdmin: u.role === "admin" };
}

type NavItem = { href: string; label: string; icon: React.ComponentType<{ className?: string }>; exact?: boolean };

const MAIN: NavItem[] = [
  { href: "/studio", label: "Overview", icon: LayoutDashboard, exact: true },
  { href: "/studio/courses", label: "Courses", icon: BookOpen },
  { href: "/studio/qa", label: "Q&A inbox", icon: MessageSquareText },
  { href: "/studio/reviews", label: "Reviews", icon: Star },
];

const ADMIN: NavItem[] = [
  { href: "/studio/students", label: "Students", icon: Users },
  { href: "/studio/orders", label: "Orders", icon: Receipt },
  { href: "/studio/coupons", label: "Coupons", icon: TicketPercent },
  { href: "/studio/categories", label: "Categories", icon: FolderTree },
  { href: "/studio/paths", label: "Learning paths", icon: Route },
  { href: "/studio/leads", label: "Team leads", icon: Inbox },
];

const CRUMB_LABELS: Record<string, string> = {
  studio: "Studio",
  courses: "Courses",
  lessons: "Lessons",
  qa: "Q&A inbox",
  reviews: "Reviews",
  students: "Students",
  orders: "Orders",
  coupons: "Coupons",
  categories: "Categories",
  paths: "Learning paths",
  leads: "Team leads",
};

function NavLinks({ items, pathname }: { items: NavItem[]; pathname: string }) {
  return (
    <ul className="space-y-0.5">
      {items.map((item) => {
        const active = item.exact ? pathname === item.href : pathname === item.href || pathname.startsWith(`${item.href}/`);
        const Icon = item.icon;
        return (
          <li key={item.href}>
            <Link
              href={item.href}
              className={cn(
                "group relative flex items-center gap-3 rounded-lg px-3 py-[7px] text-[13.5px] font-medium transition-colors",
                active
                  ? "bg-surface-3/70 text-foreground"
                  : "text-muted-foreground hover:bg-surface-2 hover:text-foreground",
              )}
            >
              <Icon className={cn("size-4 shrink-0 transition-colors", active ? "text-foreground" : "text-subtle-foreground group-hover:text-muted-foreground")} />
              {item.label}
            </Link>
          </li>
        );
      })}
    </ul>
  );
}

function SidebarContent({ user, pathname }: { user: SessionUser; pathname: string }) {
  const logout = useLogout();
  const isAdmin = user.role === "admin";
  return (
    <div className="flex h-full flex-col">
      <div className="flex h-16 shrink-0 items-center gap-2.5 px-5">
        <Logo href="/studio" />
        <Badge variant="outline" size="sm" className="text-muted-foreground">
          Studio
        </Badge>
      </div>
      <nav className="flex-1 space-y-6 overflow-y-auto px-3 py-4">
        <div>
          <p className="mb-1.5 px-3 text-xs font-medium text-subtle-foreground">Create</p>
          <NavLinks items={MAIN} pathname={pathname} />
        </div>
        {isAdmin && (
          <div>
            <p className="mb-1.5 px-3 text-xs font-medium text-subtle-foreground">Business</p>
            <NavLinks items={ADMIN} pathname={pathname} />
          </div>
        )}
      </nav>
      <div className="space-y-2 border-t border-border p-3">
        <Link href="/" className="flex items-center justify-between rounded-lg px-3 py-2 text-[13.5px] text-muted-foreground transition hover:bg-surface-2 hover:text-foreground">
          View site <ArrowUpRight className="size-4" />
        </Link>
        <div className="flex items-center gap-3 rounded-lg px-3 py-2">
          <Avatar name={user.name} src={user.avatarUrl} size={32} />
          <div className="min-w-0 flex-1">
            <div className="truncate text-sm font-medium">{user.name}</div>
            <div className="truncate text-xs capitalize text-subtle-foreground">{user.role}</div>
          </div>
          <button onClick={() => logout.mutate()} className="rounded-md p-1.5 text-subtle-foreground transition hover:bg-surface-2 hover:text-foreground" aria-label="Log out">
            <LogOut className="size-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

function Breadcrumbs({ pathname }: { pathname: string }) {
  const parts = pathname.split("/").filter(Boolean);
  const crumbs = parts.map((p, i) => ({ href: "/" + parts.slice(0, i + 1).join("/"), label: CRUMB_LABELS[p] ?? (p.length > 14 ? "Edit" : p) }));
  return (
    <nav aria-label="Breadcrumb" className="flex min-w-0 items-center gap-1.5 text-[13.5px]">
      {crumbs.map((c, i) => (
        <span key={c.href} className="flex min-w-0 items-center gap-1.5">
          {i > 0 && <span className="shrink-0 text-subtle-foreground/70">/</span>}
          {i === crumbs.length - 1 ? (
            <span className="truncate font-medium text-foreground">{c.label}</span>
          ) : (
            <Link href={c.href} className="truncate text-muted-foreground transition hover:text-foreground">
              {c.label}
            </Link>
          )}
        </span>
      ))}
    </nav>
  );
}

export function StudioShell({ user, children }: { user: SessionUser; children: React.ReactNode }) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);
  useEffect(() => setOpen(false), [pathname]);

  return (
    <StudioUserContext.Provider value={user}>
      <div className="min-h-dvh bg-background">
        <aside className="fixed inset-y-0 left-0 z-30 hidden w-[260px] border-r border-border bg-surface-2/50 lg:block">
          <SidebarContent user={user} pathname={pathname} />
        </aside>
        <div className="lg:pl-[260px]">
          <header className="glass sticky top-0 z-20 flex h-14 items-center gap-3 border-b border-border px-4 sm:px-6 lg:px-8">
            <Dialog open={open} onOpenChange={setOpen}>
              <D.Trigger asChild>
                <Button variant="ghost" size="icon-sm" className="lg:hidden" aria-label="Open navigation">
                  <Menu />
                </Button>
              </D.Trigger>
              <SheetContent side="left" className="w-[280px]">
                <SidebarContent user={user} pathname={pathname} />
              </SheetContent>
            </Dialog>
            <Breadcrumbs pathname={pathname} />
            <div className="ml-auto flex items-center gap-1">
              <Button variant="ghost" size="sm" asChild className="hidden sm:inline-flex">
                <a href="mailto:support@latent.dev">
                  <Mail /> Support
                </a>
              </Button>
            </div>
          </header>
          <main className="mx-auto w-full max-w-[1400px] px-4 py-7 sm:px-6 sm:py-10 lg:px-10">{children}</main>
        </div>
      </div>
    </StudioUserContext.Provider>
  );
}
