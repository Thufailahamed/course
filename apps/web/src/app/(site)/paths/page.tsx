import type { Metadata } from "next";
import { Compass } from "lucide-react";
import type { LearningPath } from "@latent/shared";
import { PathCard } from "@/components/marketing/cards";
import { Reveal } from "@/components/marketing/reveal";
import { EmptyState } from "@/components/ui/display";
import { serverApiSafe } from "@/lib/server";

export const metadata: Metadata = {
  title: "Learning paths",
  description: "Curated sequences of courses that take you from fundamentals to a job-ready AI skill set.",
};

export default async function PathsPage() {
  const paths = (await serverApiSafe<{ items: LearningPath[] }>("/paths"))?.items ?? [];
  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page py-14 sm:py-20">
          <p className="text-sm font-semibold text-accent">Structured career paths</p>
          <h1 className="mt-3 max-w-3xl text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">Know exactly what to learn next</h1>
          <p className="mt-5 max-w-2xl text-[16.5px] leading-relaxed text-muted-foreground">
            Each path is a curated sequence of courses designed around the skills hiring managers actually look for, so you never wonder what comes next.
          </p>
        </div>
      </section>
      <section className="container-page py-14">
        {paths.length ? (
          <div className="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
            {paths.map((p, i) => (
              <Reveal key={p.id} delay={(i % 3) * 0.08}>
                <PathCard path={p} className="h-full" />
              </Reveal>
            ))}
          </div>
        ) : (
          <EmptyState icon={<Compass />} title="Paths are coming soon" description="We're curating our first learning paths. Check back shortly." />
        )}
      </section>
    </div>
  );
}
