import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Logo } from "@/components/logo";

export default function NotFound() {
  return (
    <div className="flex min-h-dvh flex-col items-center justify-center px-6 text-center">
      <div>
        <Logo className="mb-14 justify-center" />
        <p className="text-sm font-semibold text-accent">404</p>
        <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[2.75rem]">
          This page drifted out of distribution
        </h1>
        <p className="mx-auto mt-4 max-w-md text-[16px] text-muted-foreground">The page you're looking for doesn't exist or has moved.</p>
        <div className="mt-8 flex justify-center gap-3">
          <Button asChild size="lg"><Link href="/courses">Browse courses</Link></Button>
          <Button asChild size="lg" variant="secondary"><Link href="/">Go home</Link></Button>
        </div>
      </div>
    </div>
  );
}
