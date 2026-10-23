"use client";

import Link from "next/link";
import { RotateCcw } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function GlobalError({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  return (
    <div className="flex min-h-[70dvh] flex-col items-center justify-center px-6 text-center">
      <p className="text-sm font-semibold text-danger">Something went wrong</p>
      <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[2.75rem]">
        We hit an unexpected gradient
      </h1>
      <p className="mx-auto mt-4 max-w-md text-muted-foreground">
        {process.env.NODE_ENV === "development" ? error.message : "Please try again. If it keeps happening, contact support."}
      </p>
      <div className="mt-8 flex gap-3">
        <Button onClick={reset} size="lg">
          <RotateCcw /> Try again
        </Button>
        <Button asChild size="lg" variant="secondary">
          <Link href="/">Go home</Link>
        </Button>
      </div>
    </div>
  );
}
