"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { cn } from "@/lib/utils";

/**
 * Hand-built, single-series SVG charts. One hue (accent) per chart, so no
 * legend — the card title names the series. Hairline grid, 2px line, 10% area
 * wash, ≤24px columns with 4px rounded caps, crosshair / per-bar tooltips,
 * keyboard navigable (←/→), and a table view for non-visual access.
 */

export interface Point {
  date: string; // YYYY-MM-DD
  value: number;
}

function useWidth<T extends HTMLElement>() {
  const ref = useRef<T>(null);
  const [width, setWidth] = useState(0);
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const ro = new ResizeObserver(([entry]) => setWidth(entry!.contentRect.width));
    ro.observe(el);
    setWidth(el.getBoundingClientRect().width);
    return () => ro.disconnect();
  }, []);
  return [ref, width] as const;
}

function niceStep(raw: number) {
  const pow = Math.pow(10, Math.floor(Math.log10(raw)));
  const n = raw / pow;
  return (n <= 1 ? 1 : n <= 2 ? 2 : n <= 2.5 ? 2.5 : n <= 5 ? 5 : 10) * pow;
}

function niceTicks(max: number, count = 4) {
  if (max <= 0) return [0, 1];
  const step = niceStep(max / count);
  const top = Math.ceil(max / step) * step;
  const ticks: number[] = [];
  for (let v = 0; v <= top + step / 2; v += step) ticks.push(v);
  return ticks;
}

const shortDate = (d: string) => new Date(`${d}T00:00:00Z`).toLocaleDateString("en-US", { month: "short", day: "numeric", timeZone: "UTC" });
const longDate = (d: string) => new Date(`${d}T00:00:00Z`).toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric", year: "numeric", timeZone: "UTC" });

const PAD = { top: 14, right: 14, bottom: 28, left: 52 };

export function TimeSeriesChart({
  data,
  kind,
  height = 260,
  formatValue,
  formatTick,
  seriesLabel,
  dim,
  showTable,
}: {
  data: Point[];
  kind: "area" | "columns";
  height?: number;
  formatValue: (v: number) => string;
  formatTick?: (v: number) => string;
  seriesLabel: string;
  dim?: boolean;
  showTable?: boolean;
}) {
  const [wrapRef, width] = useWidth<HTMLDivElement>();
  const [hover, setHover] = useState<number | null>(null);

  const geo = useMemo(() => {
    const w = Math.max(width, 280);
    const innerW = w - PAD.left - PAD.right;
    const innerH = height - PAD.top - PAD.bottom;
    const max = Math.max(0, ...data.map((d) => d.value));
    const ticks = niceTicks(max);
    const top = ticks[ticks.length - 1] || 1;
    const n = data.length;
    const band = n ? innerW / n : innerW;
    const x = (i: number) => (kind === "columns" ? PAD.left + band * i + band / 2 : PAD.left + (n <= 1 ? innerW / 2 : (innerW * i) / (n - 1)));
    const y = (v: number) => PAD.top + innerH - (v / top) * innerH;
    return { w, innerW, innerH, ticks, top, band, x, y };
  }, [width, height, data, kind]);

  const labelEvery = Math.max(1, Math.ceil(data.length / Math.max(2, Math.floor(geo.innerW / 90))));
  const tick = formatTick ?? formatValue;

  const linePath = data.map((d, i) => `${i ? "L" : "M"}${geo.x(i).toFixed(1)},${geo.y(d.value).toFixed(1)}`).join(" ");
  const areaPath = data.length ? `${linePath} L${geo.x(data.length - 1).toFixed(1)},${geo.y(0)} L${geo.x(0).toFixed(1)},${geo.y(0)} Z` : "";

  const indexFromX = (clientX: number, rect: DOMRect) => {
    const px = clientX - rect.left;
    if (kind === "columns") return Math.max(0, Math.min(data.length - 1, Math.floor((px - PAD.left) / geo.band)));
    const t = (px - PAD.left) / geo.innerW;
    return Math.max(0, Math.min(data.length - 1, Math.round(t * (data.length - 1))));
  };

  const barW = Math.min(24, Math.max(2, geo.band - 2));
  const active = hover !== null ? data[hover] : null;

  if (showTable) {
    return (
      <div className="max-h-[280px] overflow-auto rounded-[10px] border border-border">
        <table className="w-full text-[13px]">
          <thead>
            <tr>
              <th className="sticky top-0 bg-surface-2 px-3 py-2 text-left text-xs font-medium text-muted-foreground">Date</th>
              <th className="sticky top-0 bg-surface-2 px-3 py-2 text-right text-xs font-medium text-muted-foreground">{seriesLabel}</th>
            </tr>
          </thead>
          <tbody>
            {[...data].reverse().map((d) => (
              <tr key={d.date} className="border-t border-border">
                <td className="px-3 py-1.5 text-muted-foreground">{longDate(d.date)}</td>
                <td className="px-3 py-1.5 text-right tabular-nums">{formatValue(d.value)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div ref={wrapRef} className={cn("relative w-full transition-opacity duration-300", dim && "opacity-50")} style={{ height }}>
      {width > 0 && (
        <svg
          width={geo.w}
          height={height}
          role="img"
          aria-label={`${seriesLabel} over time`}
          tabIndex={0}
          className="block touch-pan-y outline-none focus-visible:rounded-lg focus-visible:ring-2 focus-visible:ring-ring"
          onPointerMove={(e) => setHover(indexFromX(e.clientX, e.currentTarget.getBoundingClientRect()))}
          onPointerLeave={() => setHover(null)}
          onBlur={() => setHover(null)}
          onKeyDown={(e) => {
            if (e.key === "ArrowRight") setHover((h) => Math.min(data.length - 1, (h ?? -1) + 1));
            else if (e.key === "ArrowLeft") setHover((h) => Math.max(0, (h ?? data.length) - 1));
          }}
        >
          {/* grid + y ticks */}
          {geo.ticks.map((t) => (
            <g key={t}>
              <line x1={PAD.left} x2={geo.w - PAD.right} y1={geo.y(t)} y2={geo.y(t)} stroke="var(--border)" strokeWidth={1} shapeRendering="crispEdges" />
              <text x={PAD.left - 10} y={geo.y(t)} dy="0.32em" textAnchor="end" className="fill-subtle-foreground text-[11px] tabular-nums">
                {tick(t)}
              </text>
            </g>
          ))}
          {/* x labels */}
          {data.map((d, i) =>
            i % labelEvery === 0 ? (
              <text key={d.date} x={geo.x(i)} y={height - 8} textAnchor="middle" className="fill-subtle-foreground text-[11px]">
                {shortDate(d.date)}
              </text>
            ) : null,
          )}

          {kind === "area" ? (
            <>
              <path d={areaPath} fill="var(--accent)" fillOpacity={0.08} />
              <path d={linePath} fill="none" stroke="var(--accent)" strokeWidth={1.75} strokeLinejoin="round" strokeLinecap="round" />
              {hover !== null && active && (
                <>
                  <line x1={geo.x(hover)} x2={geo.x(hover)} y1={PAD.top} y2={geo.y(0)} stroke="var(--border-strong)" strokeWidth={1} shapeRendering="crispEdges" />
                  <circle cx={geo.x(hover)} cy={geo.y(active.value)} r={6} fill="var(--surface)" />
                  <circle cx={geo.x(hover)} cy={geo.y(active.value)} r={4} fill="var(--accent)" />
                </>
              )}
            </>
          ) : (
            data.map((d, i) => {
              const x0 = geo.x(i) - barW / 2;
              const y0 = geo.y(d.value);
              const h = geo.y(0) - y0;
              const r = Math.min(4, barW / 2, h);
              const path = h <= 0 ? "" : `M${x0},${geo.y(0)} V${y0 + r} Q${x0},${y0} ${x0 + r},${y0} H${x0 + barW - r} Q${x0 + barW},${y0} ${x0 + barW},${y0 + r} V${geo.y(0)} Z`;
              return (
                <g key={d.date}>
                  {path && <path d={path} fill="var(--accent)" fillOpacity={hover === null || hover === i ? 0.85 : 0.35} className="transition-[fill-opacity] duration-150" />}
                </g>
              );
            })
          )}
          {/* baseline */}
          <line x1={PAD.left} x2={geo.w - PAD.right} y1={geo.y(0)} y2={geo.y(0)} stroke="var(--border-strong)" strokeWidth={1} shapeRendering="crispEdges" />
        </svg>
      )}
      {active && hover !== null && (
        <div
          className="pointer-events-none absolute z-10 min-w-36 rounded-lg border border-border bg-surface px-3 py-2 shadow-card-lg"
          style={{
            left: Math.min(Math.max(geo.x(hover) - 72, 0), geo.w - 150),
            top: Math.max(0, geo.y(active.value) - 70),
          }}
        >
          <div className="text-[15px] font-semibold tabular-nums tracking-[-0.02em]">{formatValue(active.value)}</div>
          <div className="mt-0.5 flex items-center gap-1.5 text-xs text-muted-foreground">
            <span className="h-0.5 w-3 rounded-full bg-accent" />
            {seriesLabel} · {shortDate(active.date)}
          </div>
        </div>
      )}
    </div>
  );
}
