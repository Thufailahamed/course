"use client";

import Link from "next/link";
import { useMemo } from "react";
import { Award, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent } from "@/components/ui/primitives";

const COLORS = ["var(--primary)", "var(--accent)", "oklch(0.75 0.13 259)", "var(--subtle-foreground)", "var(--surface-3)"];

/** CSS-only confetti burst; pieces fly outward from the center of the dialog. */
function Burst() {
  const pieces = useMemo(
    () =>
      Array.from({ length: 56 }, (_, i) => {
        const angle = (i / 56) * Math.PI * 2 + Math.random() * 0.4;
        const dist = 140 + Math.random() * 180;
        return {
          x: Math.cos(angle) * dist,
          y: Math.sin(angle) * dist - 40,
          r: Math.random() * 720 - 360,
          w: 5 + Math.random() * 6,
          h: 8 + Math.random() * 10,
          delay: Math.random() * 0.15,
          color: COLORS[i % COLORS.length],
          round: i % 4 === 0,
        };
      }),
    [],
  );
  return (
    <div className="pointer-events-none absolute left-1/2 top-24 z-0" aria-hidden>
      <style>{`@keyframes latent-burst{0%{transform:translate(0,0) rotate(0);opacity:1}80%{opacity:1}100%{transform:translate(var(--x),calc(var(--y) + 120px)) rotate(var(--r));opacity:0}}`}</style>
      {pieces.map((p, i) => (
        <span
          key={i}
          className="absolute block"
          style={
            {
              width: p.w,
              height: p.round ? p.w : p.h,
              borderRadius: p.round ? 999 : 2,
              background: p.color,
              "--x": `${p.x}px`,
              "--y": `${p.y}px`,
              "--r": `${p.r}deg`,
              animation: `latent-burst 1.6s cubic-bezier(0.15,0.7,0.3,1) ${p.delay}s both`,
            } as React.CSSProperties
          }
        />
      ))}
    </div>
  );
}

export function CelebrationDialog({ certificateId, courseTitle, onClose }: { certificateId: string | null; courseTitle: string; onClose: () => void }) {
  return (
    <Dialog open={!!certificateId} onOpenChange={(o) => !o && onClose()}>
      <DialogContent size="md" className="overflow-hidden text-center">
        {certificateId && <Burst />}
        <div className="relative z-10 pt-4">
          <div className="mx-auto flex size-16 items-center justify-center rounded-full bg-accent text-white shadow-card-lg ring-[6px] ring-accent-soft">
            <Award className="size-7" strokeWidth={1.75} />
          </div>
          <p className="mt-6 text-sm font-medium text-accent">Course complete</p>
          <h2 className="mt-2 text-[1.75rem] leading-tight">Congratulations, you did it.</h2>
          <p className="mx-auto mt-3 max-w-sm text-sm leading-relaxed text-muted-foreground">
            You've finished every lesson in <span className="font-medium text-foreground">{courseTitle}</span>. Your verified certificate is ready to share.
          </p>
          <div className="mt-7 flex flex-col justify-center gap-2 sm:flex-row">
            <Button asChild size="lg">
              <Link href={`/certificates/${certificateId}`}>
                View certificate <ArrowRight />
              </Link>
            </Button>
            <Button size="lg" variant="secondary" onClick={onClose}>
              Keep reviewing
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
