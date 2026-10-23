"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { Check } from "lucide-react";
import type { Plan, PricingConfig } from "@latent/shared";
import { Button } from "@/components/ui/button";
import { api } from "@/lib/api";
import { toastError, useSession } from "@/lib/hooks";
import { cn, formatPrice } from "@/lib/utils";

export function PricingPlans({ config }: { config: PricingConfig }) {
  const [plan, setPlan] = useState<Plan>("yearly");
  const router = useRouter();
  const { user } = useSession();
  const monthlyEquivalent = Math.round(config.proYearlyCents / 12);
  const savings = Math.round((1 - config.proYearlyCents / (config.proMonthlyCents * 12)) * 100);

  const subscribe = useMutation({
    mutationFn: () => api.post<{ url: string }>("/checkout/subscribe", { plan }),
    onSuccess: ({ url }) => {
      location.href = url;
    },
    onError: toastError,
  });

  const onSubscribe = () => {
    if (!user) return router.push(`/signup?next=${encodeURIComponent("/pricing")}`);
    subscribe.mutate();
  };

  return (
    <div>
      <div className="flex justify-center">
        <div role="radiogroup" aria-label="Billing period" className="relative inline-flex rounded-lg border border-border bg-surface-2 p-0.5">
          {(["monthly", "yearly"] as const).map((p) => (
            <button
              key={p}
              role="radio"
              aria-checked={plan === p}
              onClick={() => setPlan(p)}
              className={cn("relative z-10 rounded-md px-4 py-1.5 text-sm font-medium transition-colors", plan === p ? "bg-surface text-foreground shadow-[0_1px_2px_0_oklch(0.2_0.01_265/0.1),0_0_0_1px_var(--border)]" : "text-muted-foreground hover:text-foreground")}
            >
              {p === "monthly" ? "Monthly" : "Yearly"}
              {p === "yearly" && savings > 0 && <span className="ml-2 rounded bg-accent-soft px-1.5 py-0.5 text-[11px] font-semibold text-accent">Save {savings}%</span>}
            </button>
          ))}
        </div>
      </div>

      <div className="mt-10 grid gap-5 lg:grid-cols-3">
        {/* Single course */}
        <PlanCard
          name="Single course"
          tagline="Own one course for life"
          price={<span className="text-[2.25rem] font-semibold leading-none tracking-[-0.035em]">From $69</span>}
          note="One-time payment per course"
          features={["Lifetime access to the course", "All future updates", "AI tutor for that course", "Certificate of completion", "30-day money-back guarantee"]}
          cta={
            <Button variant="secondary" size="lg" className="w-full" asChild>
              <Link href="/courses">Browse courses</Link>
            </Button>
          }
        />

        {/* Pro */}
        <PlanCard
          highlight
          name="Pro"
          tagline="Every course, one membership"
          price={
            <span className="flex items-baseline gap-2">
              <span className="text-[2.75rem] font-semibold leading-none tracking-[-0.04em] tabular-nums">{formatPrice(plan === "yearly" ? monthlyEquivalent : config.proMonthlyCents, config.currency)}</span>
              <span className="text-ink-foreground/55">/ month</span>
            </span>
          }
          note={plan === "yearly" ? `Billed ${formatPrice(config.proYearlyCents, config.currency)} yearly` : "Billed monthly · cancel anytime"}
          features={[
            "Unlimited access to all courses",
            "Every new course, on release",
            "All learning paths",
            "Unlimited AI tutor",
            "Certificates for every course",
            "Priority instructor Q&A",
          ]}
          cta={
            user?.hasPro ? (
              <Button variant="secondary" size="lg" className="w-full" asChild>
                <Link href="/account/billing">You're a Pro member · Manage</Link>
              </Button>
            ) : (
              <Button size="lg" className="w-full bg-white text-ink shadow-none hover:bg-white/90" onClick={onSubscribe} loading={subscribe.isPending}>
                Get Pro {plan === "yearly" ? "yearly" : "monthly"}
              </Button>
            )
          }
          footnote={config.paymentsMode === "demo" ? "Demo mode: no card is charged." : "Secure checkout by Stripe."}
        />

        {/* Teams */}
        <PlanCard
          name="Teams"
          tagline="Upskill your whole organization"
          price={<span className="text-[2.25rem] font-semibold leading-none tracking-[-0.035em]">Custom</span>}
          note="Volume pricing from 5 seats"
          features={["Everything in Pro, for every seat", "Team analytics & progress reports", "Private cohorts & custom paths", "SSO and centralized billing", "Dedicated success manager"]}
          cta={
            <Button variant="secondary" size="lg" className="w-full" asChild>
              <Link href="/teams#contact">Talk to sales</Link>
            </Button>
          }
        />
      </div>
    </div>
  );
}

function PlanCard({
  name,
  tagline,
  price,
  note,
  features,
  cta,
  highlight,
  footnote,
}: {
  name: string;
  tagline: string;
  price: React.ReactNode;
  note: string;
  features: string[];
  cta: React.ReactNode;
  highlight?: boolean;
  footnote?: string;
}) {
  return (
    <div
      className={cn(
        "relative flex flex-col rounded-xl border p-7",
        highlight ? "overflow-hidden border-transparent bg-ink text-ink-foreground shadow-card-lg" : "border-border bg-surface shadow-card",
      )}
    >
      <div className="flex items-center justify-between gap-3">
        <h3 className="text-[17px] font-semibold tracking-[-0.02em]">{name}</h3>
        {highlight && <span className="rounded-md bg-white/10 px-2 py-0.5 text-[11.5px] font-medium text-ink-foreground/85">Most popular</span>}
      </div>
      <p className={cn("mt-1 text-sm", highlight ? "text-ink-foreground/60" : "text-muted-foreground")}>{tagline}</p>
      <div className="mt-7">{price}</div>
      <p className={cn("mt-2 text-sm", highlight ? "text-ink-foreground/60" : "text-subtle-foreground")}>{note}</p>
      <div className="mt-7">{cta}</div>
      {footnote && <p className={cn("mt-3 text-center text-xs", highlight ? "text-ink-foreground/55" : "text-subtle-foreground")}>{footnote}</p>}
      <ul className={cn("mt-8 space-y-3 border-t pt-6 text-sm", highlight ? "border-white/10" : "border-border")}>
        {features.map((f) => (
          <li key={f} className="flex gap-3">
            <Check className={cn("mt-0.5 size-4 shrink-0", highlight ? "text-[oklch(0.75_0.13_259)]" : "text-accent")} strokeWidth={2.25} />
            <span className={highlight ? "text-ink-foreground/85" : "text-foreground/80"}>{f}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
