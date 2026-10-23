import type { Metadata } from "next";
import Link from "next/link";
import { ArrowRight, Clock, Hammer, Lightbulb, Scale } from "lucide-react";
import { Reveal } from "@/components/marketing/reveal";
import { Button } from "@/components/ui/button";
import { SectionHeading } from "@/components/ui/display";
import { serverApiSafe } from "@/lib/server";
import { formatNumber } from "@/lib/utils";

export const metadata: Metadata = { title: "About", description: "Latent is an academy for the people building the next generation of AI." };

const VALUES = [
  { icon: Lightbulb, title: "Intuition first", body: "Every equation earns its place with a picture and an explanation you could repeat to a friend." },
  { icon: Hammer, title: "Learn by building", body: "Concepts become code you run yourself. No passive watching." },
  { icon: Scale, title: "Honest about trade-offs", body: "We teach what works in practice, including when not to use the shiny new thing." },
  { icon: Clock, title: "Respect your time", body: "Tight, focused lessons. No filler, no upsell interruptions." },
] as const;

export default async function AboutPage() {
  const stats = await serverApiSafe<{ courses: number; hours: number; learners: number; avgRating: number }>("/stats");
  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page grid gap-10 py-16 sm:py-24 lg:grid-cols-[1.2fr_1fr] lg:items-end">
          <div>
            <p className="text-sm font-semibold text-accent">About Latent</p>
            <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">An academy for the people building AI</h1>
          </div>
          <p className="text-[16px] leading-relaxed text-muted-foreground">
            Latent started with a simple frustration: the best AI knowledge lived in papers, scattered notebooks and the heads of a few practitioners. We bring it together into courses that are rigorous, practical and genuinely enjoyable.
          </p>
        </div>
      </section>

      <section className="container-page py-16">
        <dl className="grid grid-cols-2 overflow-hidden rounded-xl border border-border bg-surface shadow-card lg:grid-cols-4">
          {[
            [formatNumber(stats?.learners ?? 0), "Learners"],
            [String(stats?.courses ?? 0), "Courses"],
            [`${stats?.hours ?? 0}+`, "Hours of content"],
            [stats?.avgRating ? stats.avgRating.toFixed(1) : "—", "Average rating"],
          ].map(([v, l], i) => (
            <div
              key={l}
              className={["flex flex-col-reverse p-6 sm:p-8", i % 2 ? "border-l border-border" : "", i > 1 ? "border-t border-border lg:border-t-0" : "", i === 2 ? "lg:border-l" : ""].join(" ")}
            >
              <dt className="mt-2 text-[13.5px] text-muted-foreground">{l}</dt>
              <dd className="text-[2rem] font-semibold leading-none tabular-nums tracking-[-0.035em] sm:text-[2.5rem]">{v}</dd>
            </div>
          ))}
        </dl>
      </section>

      <section className="container-page py-12">
        <SectionHeading eyebrow="What we believe" title="How we teach" />
        <div className="mt-10 grid gap-x-10 gap-y-10 sm:grid-cols-2 lg:grid-cols-4">
          {VALUES.map(({ icon: Icon, title, body }, i) => (
            <Reveal key={title} delay={i * 0.05}>
              <span className="flex size-9 items-center justify-center rounded-lg border border-border bg-surface text-foreground/75 shadow-card">
                <Icon className="size-[18px]" />
              </span>
              <h3 className="mt-4 text-[15.5px] font-semibold tracking-[-0.015em]">{title}</h3>
              <p className="mt-1.5 text-[14px] leading-relaxed text-muted-foreground">{body}</p>
            </Reveal>
          ))}
        </div>
      </section>

      <section className="container-page py-16">
        <div className="overflow-hidden rounded-2xl bg-ink px-8 py-14 text-center text-ink-foreground sm:py-16">
          <h2 className="text-[2rem] leading-tight sm:text-[2.5rem]">Ready to start?</h2>
          <p className="mx-auto mt-3 max-w-md text-[15px] text-ink-foreground/65">Browse the catalog or meet the practitioners behind the courses.</p>
          <div className="mt-8 flex flex-col justify-center gap-3 sm:flex-row">
            <Button size="lg" className="bg-white text-ink shadow-none hover:bg-white/90" asChild>
              <Link href="/courses">
                Browse courses <ArrowRight />
              </Link>
            </Button>
            <Button size="lg" variant="ghost" className="text-ink-foreground/80 ring-1 ring-white/15 hover:bg-white/10 hover:text-ink-foreground" asChild>
              <Link href="/instructors">Meet the instructors</Link>
            </Button>
          </div>
        </div>
      </section>
    </div>
  );
}
