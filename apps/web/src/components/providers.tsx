"use client";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Tooltip } from "radix-ui";
import { Toaster } from "sonner";
import { useState } from "react";
import { ApiError } from "@/lib/api";

export function Providers({ children }: { children: React.ReactNode }) {
  const [client] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 30_000,
            refetchOnWindowFocus: false,
            retry: (count, err) => !(err instanceof ApiError && err.status < 500) && count < 2,
          },
        },
      }),
  );
  return (
      <QueryClientProvider client={client}>
        <Tooltip.Provider delayDuration={200}>
          {children}
          <Toaster
            position="bottom-right"
            toastOptions={{
              classNames: {
                toast: "!bg-surface !border-border-strong !text-foreground !rounded-xl !shadow-card-lg !font-sans",
                description: "!text-muted-foreground",
              },
            }}
          />
        </Tooltip.Provider>
      </QueryClientProvider>
  );
}
