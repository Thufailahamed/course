"use client";

import { toast } from "sonner";
import { Download, Link2, Share2 } from "lucide-react";
import { Button } from "@/components/ui/button";

export function CertificateActions({ title }: { title: string }) {
  const copy = async () => {
    try {
      await navigator.clipboard.writeText(location.href);
      toast.success("Verification link copied");
    } catch {
      toast.error("Couldn't copy link");
    }
  };
  const share = async () => {
    if (navigator.share) {
      try {
        await navigator.share({ title, url: location.href });
      } catch {}
    } else copy();
  };
  return (
    <div className="flex flex-wrap gap-2 print:hidden">
      <Button onClick={() => window.print()}>
        <Download /> Download PDF
      </Button>
      <Button variant="secondary" onClick={copy}>
        <Link2 /> Copy link
      </Button>
      <Button variant="secondary" onClick={share}>
        <Share2 /> Share
      </Button>
    </div>
  );
}
