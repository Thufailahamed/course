"use client";

import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/primitives";
import { cn } from "@/lib/utils";

export function Faq({ items, className }: { items: { q: string; a: React.ReactNode }[]; className?: string }) {
  return (
    <Accordion type="single" collapsible className={cn("divide-y divide-border border-y border-border", className)}>
      {items.map((item, i) => (
        <AccordionItem key={i} value={`q${i}`}>
          <AccordionTrigger>{item.q}</AccordionTrigger>
          <AccordionContent className="max-w-2xl pr-8 text-[14.5px] leading-relaxed text-muted-foreground">{item.a}</AccordionContent>
        </AccordionItem>
      ))}
    </Accordion>
  );
}
