"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { PageSpinner } from "./ui/spinner";

/** Client redirect so the exact current URL (path + query) is preserved as `next`. */
export function RedirectToLogin() {
  const router = useRouter();
  useEffect(() => {
    router.replace(`/login?next=${encodeURIComponent(location.pathname + location.search)}`);
  }, [router]);
  return <PageSpinner />;
}
