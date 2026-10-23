"use client";

import Link from "next/link";
import { useState } from "react";
import { toast } from "sonner";
import { Award, Check, Copy, ExternalLink } from "lucide-react";
import { useCertificates } from "@/components/learner/queries";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Skeleton } from "@/components/ui/primitives";
import { useSession } from "@/lib/hooks";
import { formatDate, formatDuration, LEVEL_LABELS } from "@/lib/utils";

export default function CertificatesPage() {
  const { data, isPending } = useCertificates();
  const { user } = useSession();
  const [copied, setCopied] = useState<string | null>(null);

  const copy = async (id: string) => {
    const url = `${location.origin}/certificates/${id}`;
    try {
      await navigator.clipboard.writeText(url);
      setCopied(id);
      toast.success("Certificate link copied");
      setTimeout(() => setCopied(null), 2000);
    } catch {
      toast.error("Couldn't copy — select the link manually");
    }
  };

  const linkedInUrl = (id: string, title: string, issuedAt: string) => {
    const d = new Date(issuedAt);
    const p = new URLSearchParams({
      startTask: "CERTIFICATION_NAME",
      name: title,
      organizationName: "Latent",
      issueYear: String(d.getFullYear()),
      issueMonth: String(d.getMonth() + 1),
      certUrl: `${location.origin}/certificates/${id}`,
      certId: id,
    });
    return `https://www.linkedin.com/profile/add?${p}`;
  };

  return (
    <div className="container-page py-10 sm:py-14">
      <h1 className="text-[1.75rem] leading-tight sm:text-[2rem]">
        Your certificates
      </h1>
      <p className="mt-3 text-muted-foreground">Verified credentials for every course you've completed. Share them anywhere.</p>

      <div className="mt-10 border-t border-border pt-10">
        {isPending ? (
          <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
            {[0, 1, 2].map((i) => (
              <Skeleton key={i} className="h-80 rounded-2xl" />
            ))}
          </div>
        ) : !data?.length ? (
          <EmptyState
            icon={<Award />}
            title="No certificates yet"
            description="Complete every lesson in a course to earn a verified certificate you can share with employers."
            action={
              <Button asChild>
                <Link href="/my-courses">Continue learning</Link>
              </Button>
            }
          />
        ) : (
          <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
            {data.map((c) => (
              <article key={c.id} className="card group overflow-hidden transition-shadow duration-300 hover:shadow-card-lg">
                {/* Mini certificate */}
                <Link href={`/certificates/${c.id}`} className="block p-4" aria-label={`View certificate for ${c.course.title}`}>
                  <div
                    className="relative aspect-[1.414/1] overflow-hidden rounded-lg border border-border-strong bg-surface p-5"
                  >
                    <div className="absolute inset-2 rounded-md border border-border" />
                    <div className="relative flex h-full flex-col">
                      <div className="flex items-center justify-between">
                        <span className="text-[11px] font-medium text-muted-foreground">Certificate of completion</span>
                        <span className="flex size-6 items-center justify-center rounded-full bg-accent text-white"><Award className="size-3.5" /></span>
                      </div>
                      <div className="mt-auto">
                        <p className="text-[11px] text-subtle-foreground">Awarded to</p>
                        <p className="text-xl font-semibold leading-tight tracking-[-0.025em]">{user?.name}</p>
                        <p className="mt-2 line-clamp-2 text-sm font-medium leading-snug">{c.course.title}</p>
                      </div>
                      <div className="mt-3 flex items-center justify-between border-t border-border pt-2 text-[10.5px] tabular-nums text-subtle-foreground">
                        <span>{c.id}</span>
                        <span>{formatDate(c.issuedAt)}</span>
                      </div>
                    </div>
                  </div>
                </Link>
                <div className="px-5 pb-5">
                  <p className="text-xs text-subtle-foreground">
                    {LEVEL_LABELS[c.course.level]} · {formatDuration(c.course.durationMinutes)} · {c.course.instructor.name}
                  </p>
                  <div className="mt-4 flex flex-wrap gap-2">
                    <Button asChild size="sm" className="flex-1">
                      <Link href={`/certificates/${c.id}`}>View</Link>
                    </Button>
                    <Button size="sm" variant="secondary" onClick={() => copy(c.id)} aria-label="Copy share link">
                      {copied === c.id ? <Check className="text-success" /> : <Copy />} Copy link
                    </Button>
                    <Button asChild size="sm" variant="outline">
                      <a href={linkedInUrl(c.id, c.course.title, c.issuedAt)} target="_blank" rel="noopener noreferrer">
                        <ExternalLink /> LinkedIn
                      </a>
                    </Button>
                  </div>
                </div>
              </article>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
