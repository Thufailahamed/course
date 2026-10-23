"use client";

import { cva, type VariantProps } from "class-variance-authority";
import { Accordion as A, Checkbox as CB, Dialog as D, DropdownMenu as DM, Popover as P, Switch as SW, Tabs as T, Tooltip as TT } from "radix-ui";
import { Check, ChevronDown, X } from "lucide-react";
import { forwardRef } from "react";
import { cn } from "@/lib/utils";

/* ── Badge ──────────────────────────────────────────────── */

export const badgeVariants = cva("inline-flex items-center gap-1 whitespace-nowrap rounded-md font-medium [&_svg]:size-3", {
  variants: {
    variant: {
      default: "border border-border bg-surface-2 text-muted-foreground",
      primary: "bg-accent-soft text-accent",
      accent: "bg-accent-soft text-accent",
      success: "bg-success-soft text-success",
      warning: "bg-warning-soft text-warning",
      danger: "bg-danger-soft text-danger",
      outline: "border border-border-strong bg-surface text-foreground",
      solid: "bg-foreground text-background",
      bestseller: "bg-[oklch(0.95_0.07_90)] text-[oklch(0.42_0.1_70)]",
    },
    size: { sm: "h-5 px-2 text-[11px]", md: "h-6 px-2.5 text-[12px]", lg: "h-7 px-3 text-[13px]" },
  },
  defaultVariants: { variant: "default", size: "md" },
});

export function Badge({ className, variant, size, ...props }: React.HTMLAttributes<HTMLSpanElement> & VariantProps<typeof badgeVariants>) {
  return <span className={cn(badgeVariants({ variant, size }), className)} {...props} />;
}

/* ── Card ───────────────────────────────────────────────── */

export function Card({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("card", className)} {...props} />;
}

export function CardHeader({ title, description, action, className }: { title: React.ReactNode; description?: React.ReactNode; action?: React.ReactNode; className?: string }) {
  return (
    <div className={cn("flex items-start justify-between gap-4 border-b border-border px-5 py-4 sm:px-6", className)}>
      <div className="min-w-0">
        <h3 className="text-[15px] font-semibold text-foreground">{title}</h3>
        {description && <p className="mt-0.5 text-sm text-muted-foreground">{description}</p>}
      </div>
      {action}
    </div>
  );
}

export function Separator({ className, vertical }: { className?: string; vertical?: boolean }) {
  return <div role="separator" className={cn(vertical ? "w-px self-stretch" : "h-px w-full", "bg-border", className)} />;
}

export function Skeleton({ className }: { className?: string }) {
  return <div className={cn("skeleton", className)} />;
}

/* ── Dialog & Sheet ─────────────────────────────────────── */

export const Dialog = D.Root;
export const DialogTrigger = D.Trigger;
export const DialogClose = D.Close;

export const DialogContent = forwardRef<
  HTMLDivElement,
  React.ComponentPropsWithoutRef<typeof D.Content> & { title?: React.ReactNode; description?: React.ReactNode; size?: "sm" | "md" | "lg" | "xl"; hideClose?: boolean }
>(({ className, children, title, description, size = "md", hideClose, ...props }, ref) => (
  <D.Portal>
    <D.Overlay className="fixed inset-0 z-50 bg-[oklch(0.15_0.01_265/0.4)] backdrop-blur-[2px] data-[state=open]:animate-[fade-up_0.2s_ease-out]" />
    <D.Content
      ref={ref}
      className={cn(
        "fixed left-1/2 top-1/2 z-50 max-h-[90dvh] w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2 overflow-y-auto rounded-2xl border border-border bg-surface p-6 shadow-[0_24px_64px_-16px_oklch(0.2_0.01_265/0.3)] outline-none data-[state=open]:animate-[fade-up_0.25s_cubic-bezier(0.22,1,0.36,1)] sm:p-7",
        { sm: "max-w-sm", md: "max-w-lg", lg: "max-w-2xl", xl: "max-w-4xl" }[size],
        className,
      )}
      {...props}
    >
      {(title || description) && (
        <div className="mb-5 pr-8">
          {title && <D.Title className="text-lg font-semibold tracking-tight">{title}</D.Title>}
          {description && <D.Description className="mt-1 text-sm text-muted-foreground">{description}</D.Description>}
        </div>
      )}
      {!title && <D.Title className="sr-only">Dialog</D.Title>}
      {children}
      {!hideClose && (
        <D.Close className="absolute right-4 top-4 rounded-lg p-1.5 text-muted-foreground transition hover:bg-surface-2 hover:text-foreground" aria-label="Close">
          <X className="size-4" />
        </D.Close>
      )}
    </D.Content>
  </D.Portal>
));
DialogContent.displayName = "DialogContent";

export const SheetContent = forwardRef<HTMLDivElement, React.ComponentPropsWithoutRef<typeof D.Content> & { side?: "left" | "right"; title?: string }>(
  ({ className, children, side = "right", title, ...props }, ref) => (
    <D.Portal>
      <D.Overlay className="fixed inset-0 z-50 bg-[oklch(0.15_0.01_265/0.4)] backdrop-blur-[2px]" />
      <D.Content
        ref={ref}
        className={cn(
          "fixed inset-y-0 z-50 flex w-[min(420px,92vw)] flex-col border-border-strong bg-surface shadow-card-lg outline-none",
          side === "right" ? "right-0 border-l" : "left-0 border-r",
          className,
        )}
        {...props}
      >
        <D.Title className={title ? "flex h-14 shrink-0 items-center border-b border-border px-5 text-[15px] font-semibold" : "sr-only"}>{title ?? "Panel"}</D.Title>
        {children}
        <D.Close className="absolute right-3 top-3 rounded-lg p-2 text-muted-foreground hover:bg-surface-2 hover:text-foreground" aria-label="Close">
          <X className="size-4" />
        </D.Close>
      </D.Content>
    </D.Portal>
  ),
);
SheetContent.displayName = "SheetContent";

/* ── Dropdown menu ──────────────────────────────────────── */

export const Dropdown = DM.Root;
export const DropdownTrigger = DM.Trigger;
export const DropdownContent = forwardRef<HTMLDivElement, React.ComponentPropsWithoutRef<typeof DM.Content>>(({ className, sideOffset = 8, ...props }, ref) => (
  <DM.Portal>
    <DM.Content
      ref={ref}
      sideOffset={sideOffset}
      className={cn("z-50 min-w-48 overflow-hidden rounded-xl border border-border bg-surface p-1.5 shadow-card-lg data-[state=open]:animate-[fade-up_0.15s_ease-out]", className)}
      {...props}
    />
  </DM.Portal>
));
DropdownContent.displayName = "DropdownContent";

export const DropdownItem = forwardRef<HTMLDivElement, React.ComponentPropsWithoutRef<typeof DM.Item> & { danger?: boolean }>(({ className, danger, ...props }, ref) => (
  <DM.Item
    ref={ref}
    className={cn(
      "flex cursor-pointer select-none items-center gap-2.5 rounded-lg px-2.5 py-2 text-sm outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:size-4 [&_svg]:text-subtle-foreground",
      danger ? "text-danger data-[highlighted]:bg-danger-soft [&_svg]:text-danger" : "text-foreground data-[highlighted]:bg-surface-2",
      className,
    )}
    {...props}
  />
));
DropdownItem.displayName = "DropdownItem";

export function DropdownSeparator() {
  return <DM.Separator className="-mx-1.5 my-1.5 h-px bg-border" />;
}
export function DropdownLabel({ children }: { children: React.ReactNode }) {
  return <DM.Label className="px-2.5 py-1.5 text-xs font-medium text-subtle-foreground">{children}</DM.Label>;
}

/* ── Popover ────────────────────────────────────────────── */

export const Popover = P.Root;
export const PopoverTrigger = P.Trigger;
export const PopoverAnchor = P.Anchor;
export const PopoverContent = forwardRef<HTMLDivElement, React.ComponentPropsWithoutRef<typeof P.Content>>(({ className, sideOffset = 8, ...props }, ref) => (
  <P.Portal>
    <P.Content ref={ref} sideOffset={sideOffset} className={cn("z-50 rounded-xl border border-border bg-surface p-4 shadow-card-lg outline-none", className)} {...props} />
  </P.Portal>
));
PopoverContent.displayName = "PopoverContent";

/* ── Tabs ───────────────────────────────────────────────── */

export const Tabs = T.Root;
export const TabsContent = T.Content;

export function TabsList({ className, variant = "underline", ...props }: React.ComponentPropsWithoutRef<typeof T.List> & { variant?: "underline" | "pill" }) {
  return (
    <T.List
      className={cn(
        "flex items-center overflow-x-auto [scrollbar-width:none]",
        variant === "underline" ? "gap-6 border-b border-border" : "w-fit gap-0.5 rounded-lg border border-border bg-surface-2 p-0.5",
        className,
      )}
      data-variant={variant}
      {...props}
    />
  );
}

export function TabsTrigger({ className, variant = "underline", ...props }: React.ComponentPropsWithoutRef<typeof T.Trigger> & { variant?: "underline" | "pill" }) {
  return (
    <T.Trigger
      className={cn(
        "inline-flex shrink-0 items-center gap-2 whitespace-nowrap text-sm font-medium transition-colors [&_svg]:size-4",
        variant === "underline"
          ? "relative -mb-px h-11 border-b-2 border-transparent text-muted-foreground hover:text-foreground data-[state=active]:border-foreground data-[state=active]:text-foreground"
          : "h-7.5 rounded-md px-3 text-muted-foreground hover:text-foreground data-[state=active]:bg-surface data-[state=active]:text-foreground data-[state=active]:shadow-[0_1px_2px_0_oklch(0.2_0.01_265/0.1),0_0_0_1px_var(--border)]",
        className,
      )}
      {...props}
    />
  );
}

/* ── Accordion ──────────────────────────────────────────── */

export const Accordion = A.Root;
export const AccordionItem = A.Item;
export function AccordionTrigger({ className, children, ...props }: React.ComponentPropsWithoutRef<typeof A.Trigger>) {
  return (
    <A.Header className="flex">
      <A.Trigger className={cn("group flex flex-1 items-center justify-between gap-4 py-5 text-left text-[15.5px] font-medium transition-colors hover:text-foreground", className)} {...props}>
        {children}
        <ChevronDown className="size-4 shrink-0 text-subtle-foreground transition-transform duration-300 group-data-[state=open]:rotate-180" />
      </A.Trigger>
    </A.Header>
  );
}
export function AccordionContent({ className, children, ...props }: React.ComponentPropsWithoutRef<typeof A.Content>) {
  return (
    <A.Content className="overflow-hidden data-[state=closed]:animate-[accordion-up_0.2s_ease-out] data-[state=open]:animate-[accordion-down_0.25s_ease-out]" {...props}>
      <div className={cn("pb-4", className)}>{children}</div>
    </A.Content>
  );
}

/* ── Switch & Checkbox ──────────────────────────────────── */

export function Switch({ className, ...props }: React.ComponentPropsWithoutRef<typeof SW.Root>) {
  return (
    <SW.Root
      className={cn(
        "relative inline-flex h-6 w-10 shrink-0 items-center rounded-full border border-border-strong bg-surface-3 transition-colors data-[state=checked]:border-primary data-[state=checked]:bg-primary",
        className,
      )}
      {...props}
    >
      <SW.Thumb className="block size-4.5 translate-x-0.5 rounded-full bg-white shadow transition-transform data-[state=checked]:translate-x-[18px]" />
    </SW.Root>
  );
}

export function Checkbox({ className, ...props }: React.ComponentPropsWithoutRef<typeof CB.Root>) {
  return (
    <CB.Root
      className={cn(
        "flex size-[18px] shrink-0 items-center justify-center rounded-[5px] border border-[oklch(0.2_0.01_265/0.28)] bg-surface transition-colors data-[state=checked]:border-primary data-[state=checked]:bg-primary",
        className,
      )}
      {...props}
    >
      <CB.Indicator>
        <Check className="size-3 text-white" strokeWidth={3} />
      </CB.Indicator>
    </CB.Root>
  );
}

/* ── Tooltip ────────────────────────────────────────────── */

export function Tooltip({ content, children, side = "top" }: { content: React.ReactNode; children: React.ReactNode; side?: "top" | "bottom" | "left" | "right" }) {
  return (
    <TT.Root>
      <TT.Trigger asChild>{children}</TT.Trigger>
      <TT.Portal>
        <TT.Content side={side} sideOffset={6} className="z-[60] rounded-md bg-foreground px-2.5 py-1.5 text-xs font-medium text-background shadow-card-lg">
          {content}
        </TT.Content>
      </TT.Portal>
    </TT.Root>
  );
}
