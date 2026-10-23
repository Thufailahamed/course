import Link from "next/link";
import { Logo } from "./logo";

const COLUMNS = [
  {
    title: "Learn",
    links: [
      ["All courses", "/courses"],
      ["Learning paths", "/paths"],
      ["LLMs & GenAI", "/courses?category=generative-ai"],
      ["Deep learning", "/courses?category=deep-learning"],
      ["Free courses", "/courses?price=free"],
    ],
  },
  {
    title: "Platform",
    links: [
      ["Pricing", "/pricing"],
      ["Latent for Teams", "/teams"],
      ["Instructors", "/instructors"],
      ["Verify a certificate", "/certificates/verify"],
    ],
  },
  {
    title: "Company",
    links: [
      ["About", "/about"],
      ["Terms of service", "/terms"],
      ["Privacy policy", "/privacy"],
      ["Contact", "/teams#contact"],
    ],
  },
];

export function SiteFooter() {
  return (
    <footer className="mt-24 border-t border-border bg-surface">
      <div className="container-page grid gap-12 py-16 md:grid-cols-[1.5fr_repeat(3,1fr)] lg:py-20">
        <div className="max-w-sm">
          <Logo />
          <p className="mt-4 text-[14px] leading-relaxed text-muted-foreground">
            Hands-on courses in machine learning and AI engineering, built by practitioners, with an AI tutor in every lesson.
          </p>
          <p className="mt-6 inline-flex items-center gap-2 text-xs text-subtle-foreground">
            <span className="size-1.5 rounded-full bg-success" /> All systems operational
          </p>
        </div>
        {COLUMNS.map((col) => (
          <div key={col.title}>
            <h4 className="text-[13px] font-semibold">{col.title}</h4>
            <ul className="mt-4 space-y-2.5">
              {col.links.map(([label, href]) => (
                <li key={href}>
                  <Link href={href} className="text-[13.5px] text-muted-foreground transition-colors hover:text-foreground">
                    {label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="border-t border-border">
        <div className="container-page flex flex-col items-center justify-between gap-3 py-6 text-xs text-subtle-foreground sm:flex-row">
          <p>© {new Date().getFullYear()} Latent Academy. All rights reserved.</p>
          <p>Built on Cloudflare · Next.js · Hono</p>
        </div>
      </div>
    </footer>
  );
}
