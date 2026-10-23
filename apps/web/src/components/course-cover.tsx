import { cn, hueFrom } from "@/lib/utils";

/**
 * Deterministic generative cover art for a course. Same seed → same art on
 * server and client, so it's hydration-safe. An uploaded thumbnail wins.
 */

function rng(seed: number) {
  let s = seed || 1;
  return () => {
    s = (s * 1664525 + 1013904223) % 4294967296;
    return s / 4294967296;
  };
}

type Variant = "network" | "rings" | "waves" | "matrix" | "orbit";
const VARIANTS: Variant[] = ["network", "rings", "waves", "matrix", "orbit"];

export function CourseCover({
  seed,
  hue,
  src,
  title,
  className,
  variant,
  showLabel = false,
  label,
}: {
  seed: string;
  hue: number;
  src?: string | null;
  title?: string;
  className?: string;
  variant?: Variant;
  showLabel?: boolean;
  label?: string;
}) {
  if (src) {
    return (
      <div className={cn("relative overflow-hidden bg-surface-2", className)}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={src} alt={title ?? ""} className="absolute inset-0 size-full object-cover" loading="lazy" />
      </div>
    );
  }
  const h = hueFrom(seed);

  const v = variant ?? VARIANTS[h % VARIANTS.length]!;
  const id = `cv-${seed.replace(/[^a-z0-9]/gi, "")}`;

  // Book-cloth palette: a deep, low-chroma field with cream line work.
  return (
    <div className={cn("relative overflow-hidden", className)} style={{ background: `oklch(0.42 0.07 ${hue})` }} aria-hidden>
      <svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice" className="absolute inset-0 size-full">
        <defs>
          <linearGradient id={`${id}-bg`} x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stopColor={`oklch(0.46 0.075 ${hue})`} />
            <stop offset="1" stopColor={`oklch(0.36 0.06 ${hue})`} />
          </linearGradient>
          <linearGradient id={`${id}-line`} x1="0" y1="0" x2="1" y2="0">
            <stop offset="0" stopColor={`oklch(0.93 0.03 ${hue})`} stopOpacity="0" />
            <stop offset="0.5" stopColor={`oklch(0.93 0.03 ${hue})`} stopOpacity="0.9" />
            <stop offset="1" stopColor={`oklch(0.93 0.03 ${hue})`} stopOpacity="0" />
          </linearGradient>
        </defs>
        <rect width="400" height="225" fill={`url(#${id}-bg)`} />
        <Pattern variant={v} seed={h + hue * 7919} hue={hue} id={id} />
      </svg>
      {/* paper grain */}
      <div
        className="pointer-events-none absolute inset-0 opacity-[0.22] mix-blend-soft-light"
        style={{
          backgroundImage:
            "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")",
        }}
      />
      {showLabel && (label || title) && (
        <div className="absolute inset-x-0 bottom-0 p-4">
          <span className="font-mono text-[10px] uppercase tracking-[0.2em] text-white/75">{label ?? title}</span>
        </div>
      )}
    </div>
  );
}

function Pattern({ variant, seed, hue, id }: { variant: Variant; seed: number; hue: number; id: string }) {
  // Seeded here (not passed in) so repeated renders draw identical art.
  const rand = rng(seed);
  const light = `oklch(0.94 0.028 ${hue})`;
  switch (variant) {
    case "network": {
      const layers = [3, 5, 5, 4, 2];
      const nodes = layers.flatMap((n, li) =>
        Array.from({ length: n }, (_, i) => ({ x: 70 + li * 68, y: 112 + (i - (n - 1) / 2) * 34 + (rand() - 0.5) * 6, li })),
      );
      const edges: [typeof nodes[number], typeof nodes[number], number][] = [];
      for (const a of nodes) for (const b of nodes) if (b.li === a.li + 1 && rand() > 0.25) edges.push([a, b, rand()]);
      return (
        <g>
          {edges.map(([a, b, w], i) => (
            <line key={i} x1={a.x} y1={a.y} x2={b.x} y2={b.y} stroke={light} strokeOpacity={0.08 + w * 0.3} strokeWidth={0.6 + w * 0.8} />
          ))}
          {nodes.map((n, i) => (
            <g key={i}>
              <circle cx={n.x} cy={n.y} r={9} fill={light} fillOpacity={0.08} />
              <circle cx={n.x} cy={n.y} r={rand() > 0.7 ? 4.5 : 3} fill={light} fillOpacity={rand() > 0.6 ? 0.95 : 0.55} />
            </g>
          ))}
        </g>
      );
    }
    case "rings": {
      const cx = 260 + rand() * 60;
      const cy = 90 + rand() * 50;
      return (
        <g fill="none">
          {Array.from({ length: 9 }, (_, i) => (
            <circle key={i} cx={cx} cy={cy} r={18 + i * 19} stroke={light} strokeOpacity={0.5 - i * 0.045} strokeWidth={i % 3 === 0 ? 1.4 : 0.7} strokeDasharray={i % 2 ? "2 5" : undefined} />
          ))}
          {Array.from({ length: 6 }, (_, i) => {
            const a = rand() * Math.PI * 2;
            const r = 18 + Math.floor(rand() * 8) * 19;
            return <circle key={`d${i}`} cx={cx + Math.cos(a) * r} cy={cy + Math.sin(a) * r} r={3} fill={light} />;
          })}
          <circle cx={cx} cy={cy} r={6} fill={light} />
        </g>
      );
    }
    case "waves": {
      const amp = 14 + rand() * 12;
      const freq = 0.018 + rand() * 0.012;
      return (
        <g fill="none">
          {Array.from({ length: 14 }, (_, i) => {
            const phase = i * 0.35;
            const y0 = 40 + i * 12;
            let d = `M -10 ${y0}`;
            for (let x = 0; x <= 410; x += 10) d += ` L ${x} ${(y0 + Math.sin(x * freq + phase) * amp * (0.4 + i / 20)).toFixed(1)}`;
            return <path key={i} d={d} stroke={i === 7 ? `url(#${id}-line)` : light} strokeOpacity={i === 7 ? 1 : 0.1 + (i % 4) * 0.06} strokeWidth={i === 7 ? 2 : 0.8} />;
          })}
        </g>
      );
    }
    case "matrix": {
      const cells = [];
      for (let y = 0; y < 9; y++)
        for (let x = 0; x < 16; x++) {
          const r = rand();
          cells.push(<rect key={`${x}-${y}`} x={18 + x * 23.5} y={14 + y * 23} width={15} height={15} rx={3} fill={light} fillOpacity={r > 0.9 ? 0.85 : r > 0.7 ? 0.28 : 0.07} />);
        }
      return <g>{cells}</g>;
    }
    case "orbit":
    default: {
      const pts = Array.from({ length: 70 }, () => {
        const a = rand() * Math.PI * 2;
        const r = 30 + Math.pow(rand(), 0.7) * 150;
        return { x: 280 + Math.cos(a) * r * 1.3, y: 112 + Math.sin(a) * r * 0.55, s: rand() };
      });
      return (
        <g>
          <ellipse cx={280} cy={112} rx={190} ry={84} fill="none" stroke={light} strokeOpacity={0.18} />
          <ellipse cx={280} cy={112} rx={120} ry={52} fill="none" stroke={light} strokeOpacity={0.25} strokeDasharray="3 6" />
          {pts.map((p, i) => (
            <circle key={i} cx={p.x} cy={p.y} r={0.8 + p.s * 2.2} fill={light} fillOpacity={0.25 + p.s * 0.7} />
          ))}
          <circle cx={280} cy={112} r={14} fill={light} fillOpacity={0.9} />
          <circle cx={280} cy={112} r={30} fill={light} fillOpacity={0.12} />
        </g>
      );
    }
  }
}
