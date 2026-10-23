"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Dialog as D } from "radix-ui";
import {
  ArrowRight,
  Award,
  BookOpen,
  ChevronDown,
  CreditCard,
  Heart,
  LayoutDashboard,
  LogOut,
  Menu,
  Search,
  Settings,
  ShoppingBag,
  Sparkles,
  Wand2,
} from "lucide-react";
import type { Category, CourseCard } from "@latent/shared";
import { api, qs } from "@/lib/api";
import { useCart } from "@/lib/cart";
import { useLogout, useSession } from "@/lib/hooks";
import { cn, formatPrice } from "@/lib/utils";
import { CourseCover } from "./course-cover";
import { Logo } from "./logo";
import { Button } from "./ui/button";
import { Avatar } from "./ui/display";
import { Badge, Dialog, Dropdown, DropdownContent, DropdownItem, DropdownLabel, DropdownSeparator, DropdownTrigger, SheetContent } from "./ui/primitives";

const NAV = [
  { href: "/courses", label: "Courses" },
  { href: "/paths", label: "Paths" },
  { href: "/pricing", label: "Pricing" },
  { href: "/teams", label: "For Teams" },
];

export function SiteHeader() {
  const [scrolled, setScrolled] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setSearchOpen((o) => !o);
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  return (
    <header className={cn("sticky top-0 z-40 transition-[background-color,border-color] duration-300", scrolled ? "glass border-b border-border" : "border-b border-transparent bg-background")}>
      <div className="container-page flex h-16 items-center gap-8">
        <Logo />
        <nav className="hidden items-center gap-0.5 lg:flex">
          <CategoriesMenu />
          {NAV.map((n) => (
            <Link
              key={n.href}
              href={n.href}
              className={cn(
                "rounded-md px-3 py-1.5 text-[14px] font-medium transition-colors",
                pathname.startsWith(n.href) ? "text-foreground" : "text-muted-foreground hover:text-foreground",
              )}
            >
              {n.label}
            </Link>
          ))}
        </nav>

        <div className="ml-auto flex items-center gap-1.5 sm:gap-2">
          <button
            onClick={() => setSearchOpen(true)}
            className="hidden h-9 w-60 items-center gap-2 rounded-lg border border-border bg-surface-2/70 pl-3 pr-1.5 text-[13px] text-subtle-foreground transition hover:border-border-strong hover:text-muted-foreground md:flex"
          >
            <Search className="size-4" />
            <span>Search courses…</span>
            <span className="kbd ml-auto">Ctrl K</span>
          </button>
          <Button variant="ghost" size="icon" className="md:hidden" onClick={() => setSearchOpen(true)} aria-label="Search">
            <Search />
          </Button>
          <CartButton />
          <UserArea />
          <MobileNav />
        </div>
      </div>
      <SearchPalette open={searchOpen} onOpenChange={setSearchOpen} />
    </header>
  );
}

function CategoriesMenu() {
  const { data } = useQuery({ queryKey: ["categories"], queryFn: () => api.get<{ items: Category[] }>("/categories").then((r) => r.items), staleTime: 300_000 });
  return (
    <Dropdown modal={false}>
      <DropdownTrigger className="inline-flex items-center gap-1 rounded-md px-3 py-1.5 text-[14px] font-medium text-muted-foreground outline-none transition-colors hover:text-foreground data-[state=open]:bg-surface-2 data-[state=open]:text-foreground">
        Explore <ChevronDown className="size-3.5 transition-transform [[data-state=open]>&]:rotate-180" />
      </DropdownTrigger>
      <DropdownContent align="start" className="w-[600px] p-2">
        <p className="px-2.5 pb-1.5 pt-1.5 text-xs font-medium text-muted-foreground">Topics</p>
        <div className="grid grid-cols-2 gap-1">
          {(data ?? []).map((c) => (
            <DropdownItem key={c.id} asChild className="items-start py-2.5">
              <Link href={`/courses?category=${c.slug}`}>
                <div>
                  <div className="font-medium">{c.name}</div>
                  <div className="mt-0.5 line-clamp-1 text-xs text-subtle-foreground">{c.description}</div>
                </div>
              </Link>
            </DropdownItem>
          ))}
        </div>
        <DropdownSeparator />
        <DropdownItem asChild className="justify-between">
          <Link href="/courses">
            <span className="font-medium">Browse the full catalog</span>
            <ArrowRight />
          </Link>
        </DropdownItem>
      </DropdownContent>
    </Dropdown>
  );
}

function CartButton() {
  const count = useCart((s) => s.items.length);
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  return (
    <Button variant="ghost" size="icon" asChild>
      <Link href="/cart" aria-label="Cart" className="relative">
        <ShoppingBag />
        {mounted && count > 0 && (
          <span className="absolute right-1 top-1 flex size-4 items-center justify-center rounded-full bg-accent text-[10px] font-semibold text-white">{count}</span>
        )}
      </Link>
    </Button>
  );
}

function UserArea() {
  const { user, loading } = useSession();
  const logout = useLogout();
  if (loading) return <div className="skeleton size-9 rounded-full" />;
  if (!user)
    return (
      <div className="hidden items-center gap-2 sm:flex">
        <Button variant="ghost" size="sm" asChild>
          <Link href="/login">Log in</Link>
        </Button>
        <Button size="sm" asChild>
          <Link href="/signup">Get started</Link>
        </Button>
      </div>
    );
  const staff = user.role !== "student";
  return (
    <div className="flex items-center gap-2">
      <Button variant="secondary" size="sm" asChild className="hidden lg:inline-flex">
        <Link href="/dashboard">My learning</Link>
      </Button>
      <Dropdown>
        <DropdownTrigger className="rounded-full outline-none ring-offset-2 ring-offset-background focus-visible:ring-2 focus-visible:ring-ring" aria-label="Account menu">
          <Avatar name={user.name} src={user.avatarUrl} size={34} />
        </DropdownTrigger>
        <DropdownContent align="end" className="w-64">
          <div className="flex items-center gap-3 px-2.5 py-2.5">
            <Avatar name={user.name} src={user.avatarUrl} size={40} />
            <div className="min-w-0">
              <div className="truncate text-sm font-semibold">{user.name}</div>
              <div className="truncate text-xs text-subtle-foreground">{user.email}</div>
            </div>
          </div>
          {user.hasPro && (
            <div className="mx-2.5 mb-2">
              <Badge variant="primary" size="sm">
                <Sparkles /> Pro member
              </Badge>
            </div>
          )}
          <DropdownSeparator />
          <DropdownItem asChild>
            <Link href="/dashboard">
              <LayoutDashboard /> Dashboard
            </Link>
          </DropdownItem>
          <DropdownItem asChild>
            <Link href="/my-courses">
              <BookOpen /> My courses
            </Link>
          </DropdownItem>
          <DropdownItem asChild>
            <Link href="/my-courses?tab=wishlist">
              <Heart /> Wishlist
            </Link>
          </DropdownItem>
          <DropdownItem asChild>
            <Link href="/certificates">
              <Award /> Certificates
            </Link>
          </DropdownItem>
          <DropdownSeparator />
          {staff && (
            <>
              <DropdownLabel>Studio</DropdownLabel>
              <DropdownItem asChild>
                <Link href="/studio">
                  <Wand2 /> Creator studio
                </Link>
              </DropdownItem>
              <DropdownSeparator />
            </>
          )}
          <DropdownItem asChild>
            <Link href="/account">
              <Settings /> Account settings
            </Link>
          </DropdownItem>
          <DropdownItem asChild>
            <Link href="/account/billing">
              <CreditCard /> Billing
            </Link>
          </DropdownItem>
          <DropdownSeparator />
          <DropdownItem danger onSelect={() => logout.mutate()}>
            <LogOut /> Log out
          </DropdownItem>
        </DropdownContent>
      </Dropdown>
    </div>
  );
}

function MobileNav() {
  const [open, setOpen] = useState(false);
  const { user } = useSession();
  const pathname = usePathname();
  useEffect(() => setOpen(false), [pathname]);
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <D.Trigger asChild>
        <Button variant="ghost" size="icon" className="lg:hidden" aria-label="Open menu">
          <Menu />
        </Button>
      </D.Trigger>
      <SheetContent title="Menu">
        <nav className="flex flex-col gap-1 p-4">
          {[{ href: "/", label: "Home" }, ...NAV, ...(user ? [{ href: "/dashboard", label: "My learning" }] : [])].map((n) => (
            <Link key={n.href} href={n.href} className="rounded-lg px-3 py-2.5 text-[15px] font-medium hover:bg-surface-2">
              {n.label}
            </Link>
          ))}
        </nav>
        {!user && (
          <div className="mt-auto grid gap-2 border-t border-border p-4">
            <Button asChild size="lg">
              <Link href="/signup">Get started — it's free</Link>
            </Button>
            <Button asChild size="lg" variant="secondary">
              <Link href="/login">Log in</Link>
            </Button>
          </div>
        )}
      </SheetContent>
    </Dialog>
  );
}

function SearchPalette({ open, onOpenChange }: { open: boolean; onOpenChange: (o: boolean) => void }) {
  const [q, setQ] = useState("");
  const [debounced, setDebounced] = useState("");
  const [active, setActive] = useState(0);
  const router = useRouter();

  useEffect(() => {
    const t = setTimeout(() => setDebounced(q.trim()), 160);
    return () => clearTimeout(t);
  }, [q]);
  useEffect(() => {
    if (!open) setQ("");
  }, [open]);

  const { data, isFetching } = useQuery({
    queryKey: ["suggest", debounced],
    queryFn: () => api.get<{ courses: CourseCard[]; categories: { slug: string; name: string }[] }>(`/search/suggest${qs({ q: debounced })}`),
    enabled: debounced.length > 0,
    placeholderData: (prev) => prev,
  });
  const results = debounced ? (data?.courses ?? []) : [];
  useEffect(() => setActive(0), [debounced]);

  const go = (href: string) => {
    onOpenChange(false);
    router.push(href);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <D.Portal>
        <D.Overlay className="fixed inset-0 z-50 bg-[oklch(0.15_0.01_265/0.4)] backdrop-blur-[2px]" />
        <D.Content className="fixed left-1/2 top-[12vh] z-50 w-[calc(100%-2rem)] max-w-2xl -translate-x-1/2 overflow-hidden rounded-2xl border border-border bg-surface shadow-[0_24px_64px_-16px_oklch(0.2_0.01_265/0.3)] outline-none data-[state=open]:animate-[fade-up_0.2s_ease-out]">
          <D.Title className="sr-only">Search courses</D.Title>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              const pick = results[active];
              go(pick ? `/courses/${pick.slug}` : `/courses${qs({ q })}`);
            }}
            className="flex items-center gap-3 border-b border-border px-5"
          >
            <Search className="size-5 text-subtle-foreground" />
            <input
              autoFocus
              value={q}
              onChange={(e) => setQ(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "ArrowDown") {
                  e.preventDefault();
                  setActive((a) => Math.min(a + 1, results.length - 1));
                } else if (e.key === "ArrowUp") {
                  e.preventDefault();
                  setActive((a) => Math.max(a - 1, 0));
                }
              }}
              placeholder="Search for transformers, RAG, PyTorch…"
              className="h-16 flex-1 bg-transparent text-base outline-none placeholder:text-subtle-foreground"
            />
            {isFetching && <span className="size-2 animate-pulse rounded-full bg-primary" />}
            <span className="kbd">Esc</span>
          </form>
          <div className="max-h-[60vh] overflow-y-auto p-2">
            {!debounced && (
              <div className="p-3">
                <p className="mb-3 px-1 text-xs font-medium text-muted-foreground">Popular searches</p>
                <div className="flex flex-wrap gap-2">
                  {["LLMs", "PyTorch", "RAG", "Agents", "Computer vision", "MLOps", "Transformers", "Math"].map((t) => (
                    <button key={t} onClick={() => setQ(t)} className="rounded-md border border-border bg-surface px-2.5 py-1 text-[13px] text-muted-foreground transition hover:border-border-strong hover:bg-surface-2 hover:text-foreground">
                      {t}
                    </button>
                  ))}
                </div>
              </div>
            )}
            {debounced && data?.categories?.length ? (
              <div className="px-2 pb-1 pt-2">
                {data.categories.map((c) => (
                  <button key={c.slug} onClick={() => go(`/courses?category=${c.slug}`)} className="flex w-full items-center gap-2 rounded-xl px-3 py-2 text-left text-sm hover:bg-surface-2">
                    <Badge variant="primary" size="sm">
                      Category
                    </Badge>
                    {c.name}
                  </button>
                ))}
              </div>
            ) : null}
            {results.map((c, i) => (
              <button
                key={c.id}
                onMouseEnter={() => setActive(i)}
                onClick={() => go(`/courses/${c.slug}`)}
                className={cn("flex w-full items-center gap-3 rounded-xl p-2 text-left transition-colors", i === active && "bg-surface-2")}
              >
                <CourseCover seed={c.slug} hue={c.accent} src={c.thumbnailUrl} className="aspect-[16/10] w-20 shrink-0 rounded-md" />
                <div className="min-w-0 flex-1">
                  <div className="truncate text-sm font-medium">{c.title}</div>
                  <div className="truncate text-xs text-subtle-foreground">
                    {c.instructor.name} · {c.category?.name}
                  </div>
                </div>
                <span className="text-sm font-medium tabular-nums text-muted-foreground">{formatPrice(c.priceCents, c.currency)}</span>
              </button>
            ))}
            {debounced && !isFetching && results.length === 0 && <div className="px-4 py-10 text-center text-sm text-muted-foreground">No courses match "{debounced}"</div>}
            {debounced && results.length > 0 && (
              <button onClick={() => go(`/courses${qs({ q })}`)} className="mt-1 flex w-full items-center justify-between rounded-xl px-3 py-3 text-sm text-primary hover:bg-surface-2">
                See all results for "{q}" <ArrowRight className="size-4" />
              </button>
            )}
          </div>
        </D.Content>
      </D.Portal>
    </Dialog>
  );
}
