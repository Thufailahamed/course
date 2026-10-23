import type { Metadata } from "next";
import { Award, BarChart3, Check, KeyRound, Route, ShieldCheck, Users } from "lucide-react";
import { LeadForm } from "@/components/commerce/lead-form";
import { Reveal } from "@/components/marketing/reveal";
import { SectionHeading } from "@/components/ui/display";

export const metadata: Metadata = { title: "Latent for Teams", description: "Upskill your engineering and data teams in AI with Latent for Teams." };

const FEATURES = [
  { icon: Route, title: "Custom learning paths", body: "Assemble courses into paths that match your stack, roles and roadmap." },
  { icon: BarChart3, title: "Progress analytics", body: "See enrollments, completion and skill growth across teams at a glance." },
  { icon: Users, title: "Private cohorts", body: "Run instructor-led cohorts with live sessions and shared Q&A." },
  { icon: KeyRound, title: "SSO & provisioning", body: "SAML single sign-on and automated seat management." },
  { icon: ShieldCheck, title: "Enterprise security", body: "Data processing agreements, audit logs and SOC 2-aligned controls." },
  { icon: Award, title: "Certificates at scale", body: "Verifiable certificates for every course your people complete." },
] as const;

export default function TeamsPage() {
  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page grid gap-14 py-16 sm:py-20 lg:grid-cols-[1.1fr_1fr] lg:items-center">
          <div>
            <p className="text-sm font-semibold text-accent">Latent for Teams</p>
            <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">Make your team AI-native</h1>
            <p className="mt-5 max-w-xl text-[16.5px] leading-relaxed text-muted-foreground">
              Give engineers, analysts and product teams the practical AI skills to ship, with curated paths, progress analytics and dedicated support.
            </p>
            <dl className="mt-10 grid max-w-lg grid-cols-3 gap-6">
              {[
                ["3.2×", "faster onboarding to ML work"],
                ["87%", "course completion in cohorts"],
                ["40+", "hours of expert content"],
              ].map(([v, l]) => (
                <div key={l} className="flex flex-col-reverse">
                  <dt className="mt-1.5 text-[13px] leading-snug text-muted-foreground">{l}</dt>
                  <dd className="text-[1.9rem] font-semibold leading-none tabular-nums tracking-[-0.035em]">{v}</dd>
                </div>
              ))}
            </dl>
          </div>
          <div className="card p-6 sm:p-7">
            <div className="flex items-center justify-between border-b border-border pb-4">
              <p className="text-[15px] font-semibold tracking-[-0.015em]">Team progress</p>
              <p className="text-xs font-medium text-muted-foreground">This quarter</p>
            </div>
            <div className="divide-y divide-border">
              {[
                ["ML Platform", 82],
                ["Data Science", 67],
                ["Product Engineering", 54],
                ["Analytics", 41],
              ].map(([team, pct]) => (
                <div key={team as string} className="py-4">
                  <div className="flex items-center justify-between text-sm">
                    <span className="font-medium">{team}</span>
                    <span className="tabular-nums text-muted-foreground">{pct}%</span>
                  </div>
                  <div className="mt-2.5 h-1.5 overflow-hidden rounded-full bg-surface-3">
                    <div className="h-full rounded-full bg-accent" style={{ width: `${pct}%` }} />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="container-page py-20">
        <SectionHeading eyebrow="Built for organizations" title="Everything you need to upskill at scale" />
        <div className="mt-10 grid gap-x-10 gap-y-10 sm:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map(({ icon: Icon, title, body }, i) => (
            <Reveal key={title} delay={(i % 3) * 0.05}>
              <span className="flex size-9 items-center justify-center rounded-lg border border-border bg-surface text-foreground/75 shadow-card">
                <Icon className="size-[18px]" />
              </span>
              <h3 className="mt-4 text-[15.5px] font-semibold tracking-[-0.015em]">{title}</h3>
              <p className="mt-1.5 text-[14px] leading-relaxed text-muted-foreground">{body}</p>
            </Reveal>
          ))}
        </div>
      </section>

      <section id="contact" className="container-page scroll-mt-24 py-12">
        <div className="grid gap-10 rounded-2xl border border-border bg-surface p-7 shadow-card sm:p-10 lg:grid-cols-[1fr_1.3fr] lg:p-12">
          <div>
            <p className="text-sm font-semibold text-accent">Contact sales</p>
            <h2 className="mt-3 text-[1.9rem] leading-[1.12] sm:text-[2.25rem]">Let&apos;s build your AI curriculum</h2>
            <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">Tell us about your team and we&apos;ll put together a tailored plan, pricing and a free pilot for up to 10 seats.</p>
            <ul className="mt-7 space-y-3 text-[14px]">
              {["Free 14-day pilot", "Custom path design session", "Volume pricing from 5 seats", "Invoicing & purchase orders"].map((x) => (
                <li key={x} className="flex items-center gap-2.5">
                  <Check className="size-4 text-accent" strokeWidth={2.5} /> {x}
                </li>
              ))}
            </ul>
          </div>
          <LeadForm />
        </div>
      </section>
    </div>
  );
}
