import Link from "next/link";
import { cn } from "@/lib/utils";

export function LogoMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 32 32" className={cn("size-7", className)} aria-hidden>
      <rect width="32" height="32" rx="7" fill="var(--primary)" />
      <path d="M11 8.5v15h10.5" fill="none" stroke="var(--primary-foreground)" strokeWidth="2.6" strokeLinecap="square" />
      <circle cx="20.5" cy="12" r="2.5" fill="var(--accent)" />
    </svg>
  );
}

export function Logo({ className, href = "/" }: { className?: string; href?: string }) {
  return (
    <Link href={href} className={cn("group inline-flex items-center gap-2", className)} aria-label="Latent home">
      <LogoMark className="size-[26px]" />
      <span className="text-[17px] font-semibold tracking-[-0.03em]">Latent</span>
    </Link>
  );
}
