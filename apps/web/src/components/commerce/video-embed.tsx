"use client";

import { cn } from "@/lib/utils";

function youtubeId(url: string) {
  const m = url.match(/(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([\w-]{6,})/);
  return m?.[1] ?? null;
}

/** Plays an mp4/webm/R2 stream URL natively, or embeds YouTube/Vimeo. */
export function VideoEmbed({ src, className, autoPlay = true, poster }: { src: string; className?: string; autoPlay?: boolean; poster?: string }) {
  const yt = youtubeId(src);
  const vimeo = src.match(/vimeo\.com\/(\d+)/)?.[1];
  const frame = yt ? `https://www.youtube-nocookie.com/embed/${yt}?autoplay=${autoPlay ? 1 : 0}&rel=0` : vimeo ? `https://player.vimeo.com/video/${vimeo}?autoplay=${autoPlay ? 1 : 0}` : null;
  return (
    <div className={cn("relative aspect-video w-full overflow-hidden rounded-xl bg-black", className)}>
      {frame ? (
        <iframe src={frame} className="absolute inset-0 size-full" allow="autoplay; fullscreen; picture-in-picture" allowFullScreen title="Video player" />
      ) : (
        <video key={src} src={src} poster={poster} className="absolute inset-0 size-full" controls autoPlay={autoPlay} playsInline controlsList="nodownload" />
      )}
    </div>
  );
}
