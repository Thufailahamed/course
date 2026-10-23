"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { ShieldCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Field, Input } from "@/components/ui/input";
import { api, ApiError } from "@/lib/api";

export default function VerifyCertificatePage() {
  const router = useRouter();
  const [id, setId] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  return (
    <div>
      <div className="container-page flex flex-col items-center py-20 sm:py-28">
        <span className="flex size-14 items-center justify-center rounded-full border border-border bg-surface text-foreground/75 shadow-card">
          <ShieldCheck className="size-6" strokeWidth={1.75} />
        </span>
        <h1 className="mt-6 text-center text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[2.75rem]">Verify a certificate</h1>
        <p className="mt-4 max-w-md text-center text-[16px] leading-relaxed text-muted-foreground">Enter the credential ID printed on a Latent certificate to confirm it's authentic.</p>
        <form
          className="card mt-10 w-full max-w-md p-6 sm:p-7"
          onSubmit={async (e) => {
            e.preventDefault();
            const clean = id.trim().toUpperCase();
            if (!clean) return setError("Enter a credential ID");
            setLoading(true);
            setError(null);
            try {
              await api.get(`/certificates/${encodeURIComponent(clean)}`);
              router.push(`/certificates/${encodeURIComponent(clean)}`);
            } catch (err) {
              setError(err instanceof ApiError && err.status === 404 ? "No certificate found with that ID" : "Couldn't verify right now. Please try again.");
              setLoading(false);
            }
          }}
        >
          <Field label="Credential ID" error={error} hint="Looks like LT-XXXXXXXXXX">
            {(p) => <Input {...p} value={id} onChange={(e) => setId(e.target.value)} placeholder="LT-DEMO7Q2K9X" className="font-mono uppercase" autoFocus />}
          </Field>
          <Button type="submit" size="lg" className="mt-5 w-full" loading={loading}>
            Verify certificate
          </Button>
        </form>
      </div>
    </div>
  );
}
