"use client";

import { useEffect, useRef, useState } from "react";
import { animate, useInView, useReducedMotion } from "motion/react";
import { formatNumber } from "@/lib/utils";

/** Counts up to `value` the first time it scrolls into view. */
export function CountUp({ value, decimals = 0, suffix = "", compact = true, className }: { value: number; decimals?: number; suffix?: string; compact?: boolean; className?: string }) {
  const ref = useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true, margin: "-40px" });
  const reduce = useReducedMotion();
  const [n, setN] = useState(reduce ? value : 0);

  useEffect(() => {
    if (!inView || reduce) return setN(value);
    const controls = animate(0, value, { duration: 1.8, ease: [0.16, 1, 0.3, 1], onUpdate: setN });
    return () => controls.stop();
  }, [inView, value, reduce]);

  const text = decimals ? n.toFixed(decimals) : compact ? formatNumber(Math.round(n)) : Math.round(n).toLocaleString();
  return (
    <span ref={ref} className={className} style={{ fontVariantNumeric: "tabular-nums" }}>
      {text}
      {suffix}
    </span>
  );
}
