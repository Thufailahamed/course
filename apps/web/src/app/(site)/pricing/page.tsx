import type { Metadata } from "next";
import { Check, Minus } from "lucide-react";
import type { PricingConfig } from "@latent/shared";
import { PricingPlans } from "@/components/commerce/pricing-plans";
import { Faq } from "@/components/marketing/faq";
import { SectionHeading } from "@/components/ui/display";
import { serverApiSafe } from "@/lib/server";

export const metadata: Metadata = { title: "Pricing", description: "Buy individual courses or get unlimited access to every course with Latent Pro." };

const ROWS: [string, boolean | string, boolean | string, boolean | string][] = [
  ["Courses included", "1 per purchase", "All courses", "All courses"],
  ["New releases", false, true, true],
  ["Learning paths", false, true, true],
  ["AI tutor", "That course", "Unlimited", "Unlimited"],
  ["Certificates", true, true, true],
  ["Instructor Q&A", true, "Priority", "Priority"],
  ["Team analytics", false, false, true],
  ["SSO & admin controls", false, false, true],
];

const FAQ = [
  { q: "Can I cancel Pro at any time?", a: "Yes. Cancel from your billing page and you'll keep access until the end of the period you've paid for. No questions asked." },
  { q: "What happens to my progress if I cancel?", a: "Your progress, notes and certificates are kept forever. If you resubscribe, you pick up exactly where you left off." },
  { q: "Should I buy a course or get Pro?", a: "If you're focused on one topic, buy the course and own it for life. If you plan to take two or more courses this year, Pro is the better value." },
  { q: "Do you offer student or regional discounts?", a: "Yes, we periodically run discounts for students and learners in many regions. Reach out with your details and we'll help." },
  { q: "What payment methods do you accept?", a: "All major credit and debit cards, plus Apple Pay and Google Pay, processed securely by Stripe." },
];

export default async function PricingPage() {
  const config = (await serverApiSafe<PricingConfig>("/config")) ?? { currency: "USD", proMonthlyCents: 2900, proYearlyCents: 24900, paymentsMode: "demo" as const };
  return (
    <div>
      <section>
        <div className="container-page pb-16 pt-14 sm:pt-20">
          <div className="mx-auto max-w-3xl text-center">
            <p className="text-sm font-semibold text-accent">Pricing</p>
            <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[3rem]">Invest in skills that compound</h1>
            <p className="mx-auto mt-5 max-w-xl text-[16.5px] leading-relaxed text-muted-foreground">Own a single course for life, or unlock the entire Latent catalog with Pro. Simple pricing, no surprises.</p>
          </div>
          <div className="mt-14">
            <PricingPlans config={config} />
          </div>
        </div>
      </section>

      <section className="container-page py-16">
        <SectionHeading align="center" title="Compare plans" />
        <div className="mt-10 overflow-x-auto rounded-xl border border-border bg-surface shadow-card">
          <table className="w-full min-w-[600px] text-sm">
            <thead>
              <tr className="border-b border-border text-left">
                <th className="p-4 px-5 text-xs font-medium text-muted-foreground">Feature</th>
                <th className="p-4 px-5 text-[14px] font-semibold">Single course</th>
                <th className="bg-surface-2 p-4 px-5 text-[14px] font-semibold">Pro</th>
                <th className="p-4 px-5 text-[14px] font-semibold">Teams</th>
              </tr>
            </thead>
            <tbody>
              {ROWS.map(([label, ...cells]) => (
                <tr key={label} className="border-b border-border last:border-0">
                  <td className="px-5 py-3.5 text-muted-foreground">{label}</td>
                  {cells.map((v, i) => (
                    <td key={i} className={i === 1 ? "bg-surface-2 px-5 py-3.5" : "px-5 py-3.5"}>
                      {v === true ? <Check className="size-4 text-accent" strokeWidth={2.5} aria-label="Included" /> : v === false ? <Minus className="size-4 text-subtle-foreground" aria-label="Not included" /> : v}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section className="container-page max-w-3xl py-16">
        <SectionHeading align="center" title="Pricing FAQ" />
        <Faq className="mt-10" items={FAQ} />
      </section>
    </div>
  );
}
