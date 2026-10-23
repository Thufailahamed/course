"use client";

import { useState } from "react";
import { ExternalLink, Monitor, RotateCw, Smartphone, Tablet } from "lucide-react";
import { cn } from "@/lib/utils";

const DEVICES = [
  { id: "desktop", label: "Desktop", icon: Monitor, width: "100%" },
  { id: "tablet", label: "Tablet", icon: Tablet, width: "768px" },
  { id: "phone", label: "Phone", icon: Smartphone, width: "390px" },
] as const;

type Device = (typeof DEVICES)[number]["id"];

/** Sandboxed live preview for HTML & CSS cells. Scripts never run here. */
export function PreviewFrame({ html, title }: { html: string; title?: string }) {
  const [device, setDevice] = useState<Device>("desktop");
  const [reload, setReload] = useState(0);
  const current = DEVICES.find((d) => d.id === device) ?? DEVICES[0];

  const openStandalone = () => {
    const blob = new Blob([html], { type: "text/html" });
    const url = URL.createObjectURL(blob);
    window.open(url, "_blank", "noopener,noreferrer");
    window.setTimeout(() => URL.revokeObjectURL(url), 60_000);
  };

  return (
    <div className="overflow-hidden rounded-lg border border-border-strong bg-surface shadow-[inset_0_1px_0_oklch(1_0_0_/_0.6)]">
      <div className="flex items-center gap-2 border-b border-border bg-surface-2/70 px-2.5 py-1.5">
        <span className="flex items-center gap-1.5" aria-hidden>
          <span className="size-2 rounded-full bg-[oklch(0.66_0.19_25)]" />
          <span className="size-2 rounded-full bg-[oklch(0.8_0.16_82)]" />
          <span className="size-2 rounded-full bg-[oklch(0.7_0.17_150)]" />
        </span>
        <span className="ml-1 text-[11px] font-semibold uppercase tracking-[0.08em] text-subtle-foreground">Live preview</span>
        <span className="hidden text-[11px] text-subtle-foreground sm:inline">· sandboxed</span>

        <div className="ml-auto flex items-center gap-0.5">
          <div className="mr-1 hidden items-center gap-0.5 rounded-md border border-border bg-surface p-0.5 sm:flex" role="group" aria-label="Preview width">
            {DEVICES.map((d) => (
              <button
                key={d.id}
                type="button"
                onClick={() => setDevice(d.id)}
                title={d.label}
                aria-label={`${d.label} width`}
                aria-pressed={device === d.id}
                className={cn(
                  "inline-flex size-6 items-center justify-center rounded transition",
                  device === d.id ? "bg-accent-soft text-accent" : "text-subtle-foreground hover:bg-surface-2 hover:text-foreground",
                )}
              >
                <d.icon className="size-3.5" />
              </button>
            ))}
          </div>
          <button type="button" onClick={() => setReload((n) => n + 1)} title="Reload preview" aria-label="Reload preview" className="inline-flex size-6 items-center justify-center rounded text-subtle-foreground transition hover:bg-surface-3 hover:text-foreground">
            <RotateCw className="size-3.5" />
          </button>
          <button type="button" onClick={openStandalone} title="Open preview in a new tab" aria-label="Open preview in a new tab" className="inline-flex size-6 items-center justify-center rounded text-subtle-foreground transition hover:bg-surface-3 hover:text-foreground">
            <ExternalLink className="size-3.5" />
          </button>
        </div>
      </div>

      <div className="bg-[oklch(0.955_0.004_265)] bg-[radial-gradient(oklch(0.6_0.01_265_/_0.12)_1px,transparent_1px)] [background-size:14px_14px]">
        <div className={cn("mx-auto transition-[width] duration-300", current.width !== "100%" && "border-x border-border")} style={{ width: current.width, maxWidth: "100%" }}>
          <iframe
            key={`${device}-${reload}`}
            title={title ?? "HTML and CSS preview"}
            srcDoc={html}
            sandbox=""
            referrerPolicy="no-referrer"
            className="block h-[340px] w-full bg-white sm:h-[380px]"
          />
        </div>
      </div>
    </div>
  );
}
