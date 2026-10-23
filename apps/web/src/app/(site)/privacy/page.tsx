import type { Metadata } from "next";
import { LegalPage } from "@/components/marketing/legal-page";

export const metadata: Metadata = { title: "Privacy policy" };

const BODY = `
We built Latent to collect as little personal data as we need to teach you well. This policy explains what we collect and why.

## What we collect
- **Account data** — your name, email and password (stored only as a salted hash).
- **Learning data** — enrollments, lesson progress, quiz attempts, notes and Q&A posts, so we can save your progress and issue certificates.
- **Payment data** — handled by Stripe. We never see or store your full card number.
- **Usage data** — basic logs used to keep the service secure and reliable.

## How we use it
To provide courses, track progress, issue certificates, send receipts and important account emails, prevent abuse, and improve our content. We don't sell your personal data.

## AI tutor
Messages you send to the AI tutor are processed to generate a response, along with the content of the lesson you're viewing. We don't use your conversations to train models.

## Cookies
We use a single essential, httpOnly session cookie to keep you signed in, and local storage for preferences and your cart.

## Your choices
You can update your profile at any time, export your data, or ask us to delete your account by contacting us.

## Contact
Privacy questions? Reach us via the [contact form](/teams#contact).
`;

export default function PrivacyPage() {
  return <LegalPage title="Privacy policy" updated="October 1, 2026" body={BODY} />;
}
