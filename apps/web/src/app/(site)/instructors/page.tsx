import type { Metadata } from "next";
import type { Instructor } from "@latent/shared";
import { InstructorCard } from "@/components/marketing/cards";
import { Reveal } from "@/components/marketing/reveal";
import { serverApiSafe } from "@/lib/server";

export const metadata: Metadata = { title: "Instructors", description: "Meet the researchers and engineers who teach on Latent." };

export default async function InstructorsPage() {
  const items = (await serverApiSafe<{ items: Instructor[] }>("/instructors"))?.items ?? [];
  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page py-14 sm:py-20">
          <p className="text-sm font-semibold text-accent">Instructors</p>
          <h1 className="mt-3 max-w-3xl text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">Taught by people who build it</h1>
          <p className="mt-5 max-w-2xl text-[16.5px] leading-relaxed text-muted-foreground">
            Our instructors have trained frontier models, shipped ML systems to hundreds of millions of users and taught at top universities.
          </p>
        </div>
      </section>
      <section className="container-page grid gap-5 py-14 sm:grid-cols-2 lg:grid-cols-3">
        {items.map((ins, i) => (
          <Reveal key={ins.id} delay={(i % 3) * 0.06}>
            <InstructorCard instructor={ins} className="h-full" />
          </Reveal>
        ))}
      </section>
    </div>
  );
}
