import type { Metadata } from "next";
import Link from "next/link";
import { BadgeCheck, CalendarDays, Clock, PlayCircle } from "lucide-react";
import type { Certificate } from "@latent/shared";
import { CertificateActions } from "@/components/commerce/certificate-actions";
import { LogoMark } from "@/components/logo";
import { serverApiOr404, serverApiSafe } from "@/lib/server";
import { formatDate, formatDuration, LEVEL_LABELS } from "@/lib/utils";

type Props = { params: Promise<{ id: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const c = await serverApiSafe<Certificate>(`/certificates/${id}`);
  return c ? { title: `${c.user.name} · ${c.course.title} certificate`, description: `Verified certificate of completion for ${c.course.title}.` } : { title: "Certificate" };
}

// The certificate is a document, so it keeps its own fixed print-safe palette.
const INK = "#18181b";
const ACCENT = "#2f6bf0";
const MUTED = "#6b6b74";

export default async function CertificatePage({ params }: Props) {
  const { id } = await params;
  const cert = await serverApiOr404<Certificate>(`/certificates/${id}`);

  return (
    <div className="container-page py-10 sm:py-14 print:p-0">
      <style>{`@media print { @page { size: landscape; margin: 0 } body { background: white !important } header, footer { display: none !important } }`}</style>

      <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between print:hidden">
        <div>
          <p className="inline-flex items-center gap-1.5 text-sm font-semibold text-success">
            <BadgeCheck className="size-3.5" /> Verified certificate
          </p>
          <h1 className="mt-2 text-[2rem] leading-tight tracking-[-0.035em] sm:text-[2.4rem]">{cert.course.title}</h1>
          <p className="mt-1 text-muted-foreground">
            Awarded to <span className="font-medium text-foreground">{cert.user.name}</span> on {formatDate(cert.issuedAt, { month: "long", day: "numeric", year: "numeric" })}
          </p>
        </div>
        <CertificateActions title={`${cert.course.title} — Latent certificate`} />
      </div>

      {/* Certificate */}
      <div className="mx-auto max-w-5xl overflow-x-auto print:max-w-none print:overflow-visible">
        <div
          className="relative mx-auto aspect-[1.414/1] w-full min-w-[640px] overflow-hidden rounded-xl border border-border shadow-card-lg print:min-w-0 print:rounded-none print:shadow-none"
          style={{ background: "#ffffff", color: INK }}
        >
          <div className="absolute inset-x-0 top-0 h-1.5" style={{ background: ACCENT }} />
          <div className="absolute inset-[3%] rounded-md border" style={{ borderColor: `${INK}1f` }} />

          <div className="relative flex h-full flex-col px-[9%] py-[7%]">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <LogoMark className="size-8" />
                <span className="text-xl font-semibold tracking-[-0.03em]">Latent</span>
              </div>
              <span className="font-mono text-[11px] tracking-[0.08em]" style={{ color: MUTED }}>
                Certificate · {cert.id}
              </span>
            </div>

            <div className="my-auto">
              <p className="text-xs font-semibold uppercase tracking-[0.2em]" style={{ color: ACCENT }}>
                Certificate of completion
              </p>
              <p className="mt-5 text-sm" style={{ color: MUTED }}>
                This certifies that
              </p>
              <p className="mt-2 text-[clamp(2.2rem,5.5vw,4rem)] font-semibold leading-[1.05] tracking-[-0.04em]">{cert.user.name}</p>
              <p className="mt-4 text-sm" style={{ color: MUTED }}>
                has successfully completed every lesson and assessment of
              </p>
              <p className="mt-1 text-[clamp(1.2rem,2.6vw,2rem)] font-semibold tracking-[-0.03em]">{cert.course.title}</p>
              <p className="mt-3 text-xs" style={{ color: MUTED }}>
                {LEVEL_LABELS[cert.course.level]} · {cert.course.lessonsCount} lessons · {formatDuration(cert.course.durationMinutes)} of instruction
              </p>
            </div>

            <div className="flex items-end justify-between gap-6">
              <div>
                <p className="text-lg font-medium leading-none tracking-[-0.02em]">{cert.instructor.name}</p>
                <div className="mt-2 h-px w-48" style={{ background: INK, opacity: 0.25 }} />
                <p className="mt-1.5 text-[11px] uppercase tracking-wider" style={{ color: MUTED }}>
                  Instructor
                </p>
              </div>
              <div className="relative flex size-24 shrink-0 items-center justify-center">
                <svg viewBox="0 0 100 100" className="absolute inset-0" aria-hidden>
                  <defs>
                    <path id="seal-circle" d="M50 50 m-38 0 a38 38 0 1 1 76 0 a38 38 0 1 1 -76 0" />
                  </defs>
                  <circle cx="50" cy="50" r="48" fill={INK} />
                  <circle cx="50" cy="50" r="44" fill="none" stroke={ACCENT} strokeOpacity="0.9" strokeDasharray="1 2" />
                  <text fontSize="7.5" fill="#ffffff" letterSpacing="2.2" fontWeight="600">
                    <textPath href="#seal-circle">LATENT · VERIFIED · LATENT · VERIFIED ·</textPath>
                  </text>
                </svg>
                <BadgeCheck className="relative size-9" style={{ color: "#ffffff" }} />
              </div>
              <div className="text-right">
                <p className="text-sm font-semibold">{formatDate(cert.issuedAt, { month: "long", day: "numeric", year: "numeric" })}</p>
                <div className="ml-auto mt-2 h-px w-40" style={{ background: INK, opacity: 0.25 }} />
                <p className="mt-1.5 text-[11px] uppercase tracking-wider" style={{ color: MUTED }}>
                  Date issued
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mx-auto mt-10 grid max-w-5xl gap-4 sm:grid-cols-3 print:hidden">
        {[
          [BadgeCheck, "Credential ID", cert.id],
          [CalendarDays, "Issued", formatDate(cert.issuedAt)],
          [Clock, "Course length", formatDuration(cert.course.durationMinutes)],
        ].map(([Icon, l, v]) => {
          const I = Icon as typeof Clock;
          return (
            <div key={l as string} className="card p-5">
              <I className="size-4 text-subtle-foreground" />
              <p className="mt-3 text-xs text-subtle-foreground">{l as string}</p>
              <p className="mt-0.5 font-mono text-sm font-medium">{v as string}</p>
            </div>
          );
        })}
      </div>
      <div className="mx-auto mt-6 flex max-w-5xl flex-col items-start justify-between gap-4 rounded-xl border border-border bg-surface-2 p-5 sm:flex-row sm:items-center print:hidden">
        <p className="text-sm text-muted-foreground">
          This certificate was issued by Latent and can be verified at this URL. It confirms completion of all lessons and graded assessments.
        </p>
        <Link href={`/courses/${cert.course.slug}`} className="inline-flex shrink-0 items-center gap-2 text-sm font-medium text-accent hover:underline">
          <PlayCircle className="size-4" /> View the course
        </Link>
      </div>
    </div>
  );
}
