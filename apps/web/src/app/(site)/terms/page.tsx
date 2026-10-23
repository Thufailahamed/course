import type { Metadata } from "next";
import { LegalPage } from "@/components/marketing/legal-page";

export const metadata: Metadata = { title: "Terms of service" };

const BODY = `
These terms govern your use of Latent ("we", "us"), including our website, courses and related services. By creating an account or purchasing a course you agree to them.

## Your account
You're responsible for keeping your login credentials secure and for activity under your account. You must be at least 16 years old to create an account.

## Courses and licenses
When you buy a course, we grant you a personal, non-transferable license to access it for as long as Latent operates the course. Pro membership grants access to the catalog while your subscription is active. You may not share accounts, resell content, or redistribute videos, notebooks or other materials.

## Payments and refunds
Prices are shown at checkout and payments are processed by Stripe. If you're not satisfied with a course, request a refund within **30 days** of purchase. Subscriptions renew automatically until canceled; canceling stops future renewals and you keep access until the end of the paid period.

## Acceptable use
Don't misuse the platform: no scraping, reverse engineering, harassment in Q&A, or attempts to bypass access controls. We may suspend accounts that violate these terms.

## AI tutor
The AI tutor generates responses automatically and can make mistakes. Treat its output as a learning aid, not authoritative advice.

## Changes
We may update these terms. If changes are material, we'll notify you by email or in-app before they take effect.

## Contact
Questions? Reach us via the [contact form](/teams#contact).
`;

export default function TermsPage() {
  return <LegalPage title="Terms of service" updated="October 1, 2026" body={BODY} />;
}
