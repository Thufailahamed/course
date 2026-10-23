"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { Check, Gauge, Maximize, Minimize, Pause, Play, RotateCcw, RotateCw, SkipForward, Volume1, Volume2, VolumeX } from "lucide-react";
import { DropdownMenu as DM } from "radix-ui";
import { cn, formatSeconds } from "@/lib/utils";
import type { PlayerApi, ProgressResult } from "./types";

const SPEEDS = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
const SAVE_EVERY_MS = 15_000;
const COMPLETE_AT = 0.9;
const UP_NEXT_SECONDS = 8;

function isTyping(el: EventTarget | null) {
  const t = el as HTMLElement | null;
  return !!t && (t.tagName === "INPUT" || t.tagName === "TEXTAREA" || t.tagName === "SELECT" || t.isContentEditable);
}

export function embedUrl(src: string): string | null {
  const yt = src.match(/(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([\w-]{11})/);
  if (yt) return `https://www.youtube-nocookie.com/embed/${yt[1]}?rel=0&modestbranding=1`;
  const vimeo = src.match(/vimeo\.com\/(?:video\/)?(\d+)/);
  if (vimeo) return `https://player.vimeo.com/video/${vimeo[1]}`;
  return null;
}

interface VideoPlayerProps {
  src: string;
  lessonId: string;
  startAt: number;
  alreadyCompleted: boolean;
  nextTitle: string | null;
  onNext: () => void;
  onResult: (r: ProgressResult) => void;
  playerRef: React.MutableRefObject<PlayerApi | null>;
}

export function VideoPlayer({ src, lessonId, startAt, alreadyCompleted, nextTitle, onNext, onResult, playerRef }: VideoPlayerProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const wrapRef = useRef<HTMLDivElement>(null);
  const [playing, setPlaying] = useState(false);
  const [started, setStarted] = useState(false);
  const [time, setTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [buffered, setBuffered] = useState(0);
  const [volume, setVolume] = useState(1);
  const [muted, setMuted] = useState(false);
  const [speed, setSpeed] = useState(1);
  const [fullscreen, setFullscreen] = useState(false);
  const [controlsVisible, setControlsVisible] = useState(true);
  const [hover, setHover] = useState<{ x: number; t: number } | null>(null);
  const [flash, setFlash] = useState<{ key: number; label: string } | null>(null);
  const [upNext, setUpNext] = useState<number | null>(null);
  const [waiting, setWaiting] = useState(false);

  // Progress tracking state lives in refs so the save loop doesn't re-render.
  const watched = useRef(0);
  const lastT = useRef(0);
  const completed = useRef(alreadyCompleted);
  const hideTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const lastSaved = useRef(startAt);
  const onResultRef = useRef(onResult);
  onResultRef.current = onResult;

  const save = useCallback(
    (extra: { completed?: boolean } = {}) => {
      const v = videoRef.current;
      if (!v) return;
      const watchedSeconds = Math.min(3600, Math.round(watched.current));
      if (!watchedSeconds && !extra.completed && Math.abs(v.currentTime - lastSaved.current) < 3) return;
      watched.current -= watchedSeconds;
      lastSaved.current = v.currentTime;
      fetch(`/api/learn/lessons/${lessonId}/progress`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ positionSeconds: Math.floor(v.currentTime), watchedSeconds, ...extra }),
        keepalive: true,
      })
        .then((r) => (r.ok ? r.json() : null))
        .then((r: ProgressResult | null) => r && onResultRef.current(r))
        .catch(() => {});
    },
    [lessonId],
  );
  // Imperative API for notes (timestamped notes + seeking).
  useEffect(() => {
    playerRef.current = {
      getTime: () => videoRef.current?.currentTime ?? 0,
      seek: (t) => {
        const v = videoRef.current;
        if (!v) return;
        v.currentTime = t;
        void v.play();
        wrapRef.current?.scrollIntoView({ behavior: "smooth", block: "center" });
      },
      pause: () => videoRef.current?.pause(),
    };
    return () => {
      playerRef.current = null;
    };
  }, [playerRef]);

  // Periodic save while playing + flush on tab hide / unmount.
  useEffect(() => {
    const id = setInterval(() => {
      if (videoRef.current && !videoRef.current.paused) save();
    }, SAVE_EVERY_MS);
    const onHide = () => document.visibilityState === "hidden" && save();
    document.addEventListener("visibilitychange", onHide);
    window.addEventListener("pagehide", onHide);
    return () => {
      clearInterval(id);
      document.removeEventListener("visibilitychange", onHide);
      window.removeEventListener("pagehide", onHide);
      save();
    };
  }, [save]);

  useEffect(() => {
    try {
      const s = Number(localStorage.getItem("latent-speed"));
      if (SPEEDS.includes(s)) setSpeed(s);
      const vol = localStorage.getItem("latent-volume");
      if (vol !== null) setVolume(Math.max(0, Math.min(1, Number(vol))));
    } catch {}
  }, []);

  useEffect(() => {
    if (videoRef.current) videoRef.current.playbackRate = speed;
  }, [speed]);
  useEffect(() => {
    if (!videoRef.current) return;
    videoRef.current.volume = volume;
    videoRef.current.muted = muted;
  }, [volume, muted]);

  useEffect(() => {
    const onFs = () => setFullscreen(document.fullscreenElement === wrapRef.current);
    document.addEventListener("fullscreenchange", onFs);
    return () => document.removeEventListener("fullscreenchange", onFs);
  }, []);

  const showFlash = (label: string) => setFlash({ key: Date.now(), label });
  useEffect(() => {
    if (!flash) return;
    const t = setTimeout(() => setFlash(null), 650);
    return () => clearTimeout(t);
  }, [flash]);

  const togglePlay = useCallback(() => {
    const v = videoRef.current;
    if (!v) return;
    if (v.paused) void v.play();
    else v.pause();
  }, []);
  const skip = useCallback((delta: number) => {
    const v = videoRef.current;
    if (!v) return;
    v.currentTime = Math.max(0, Math.min(v.duration || 0, v.currentTime + delta));
    showFlash(delta > 0 ? `+${delta}s` : `${delta}s`);
  }, []);
  const toggleFullscreen = useCallback(() => {
    if (document.fullscreenElement) void document.exitFullscreen();
    else void wrapRef.current?.requestFullscreen?.();
  }, []);

  const changeSpeed = (s: number) => {
    setSpeed(s);
    try {
      localStorage.setItem("latent-speed", String(s));
    } catch {}
  };
  const changeVolume = (v: number) => {
    setVolume(v);
    setMuted(v === 0);
    try {
      localStorage.setItem("latent-volume", String(v));
    } catch {}
  };

  // Keyboard shortcuts.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (isTyping(e.target) || e.metaKey || e.ctrlKey || e.altKey) return;
      const k = e.key.toLowerCase();
      if (k === " " || k === "k") {
        e.preventDefault();
        togglePlay();
      } else if (k === "j") skip(-10);
      else if (k === "l") skip(10);
      else if (k === "arrowleft") {
        e.preventDefault();
        skip(-5);
      } else if (k === "arrowright") {
        e.preventDefault();
        skip(5);
      } else if (k === "arrowup") {
        e.preventDefault();
        changeVolume(Math.min(1, volume + 0.1));
        showFlash(`Volume ${Math.round(Math.min(1, volume + 0.1) * 100)}%`);
      } else if (k === "arrowdown") {
        e.preventDefault();
        changeVolume(Math.max(0, volume - 0.1));
        showFlash(`Volume ${Math.round(Math.max(0, volume - 0.1) * 100)}%`);
      } else if (k === "f") toggleFullscreen();
      else if (k === "m") setMuted((m) => !m);
      else if (k === ">" || k === ".") {
        const i = SPEEDS.indexOf(speed);
        if (i < SPEEDS.length - 1) {
          changeSpeed(SPEEDS[i + 1]!);
          showFlash(`${SPEEDS[i + 1]}×`);
        }
      } else if (k === "<" || k === ",") {
        const i = SPEEDS.indexOf(speed);
        if (i > 0) {
          changeSpeed(SPEEDS[i - 1]!);
          showFlash(`${SPEEDS[i - 1]}×`);
        }
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [togglePlay, skip, toggleFullscreen, volume, speed]);

  // Auto-hide controls while playing.
  const poke = useCallback(() => {
    setControlsVisible(true);
    if (hideTimer.current) clearTimeout(hideTimer.current);
    hideTimer.current = setTimeout(() => {
      if (videoRef.current && !videoRef.current.paused) setControlsVisible(false);
    }, 2600);
  }, []);
  useEffect(() => () => void (hideTimer.current && clearTimeout(hideTimer.current)), []);

  // "Up next" countdown.
  useEffect(() => {
    if (upNext === null) return;
    if (upNext <= 0) {
      setUpNext(null);
      onNext();
      return;
    }
    const t = setTimeout(() => setUpNext((n) => (n === null ? null : n - 1)), 1000);
    return () => clearTimeout(t);
  }, [upNext, onNext]);

  const onTimeUpdate = () => {
    const v = videoRef.current!;
    const t = v.currentTime;
    const delta = t - lastT.current;
    if (!v.paused && delta > 0 && delta < 2) watched.current += delta / (v.playbackRate || 1);
    lastT.current = t;
    setTime(t);
    if (!completed.current && v.duration && t / v.duration >= COMPLETE_AT) {
      completed.current = true;
      save({ completed: true });
    }
  };

  const progressPct = duration ? (time / duration) * 100 : 0;
  const bufferedPct = duration ? (buffered / duration) * 100 : 0;
  const VolIcon = muted || volume === 0 ? VolumeX : volume < 0.5 ? Volume1 : Volume2;
  const showControls = controlsVisible || !playing;

  return (
    <div
      ref={wrapRef}
      className={cn("group/player relative aspect-video w-full select-none overflow-hidden bg-black", fullscreen ? "rounded-none" : "", !showControls && "cursor-none")}
      onMouseMove={poke}
      onMouseLeave={() => playing && setControlsVisible(false)}
    >
      <video
        ref={videoRef}
        src={src}
        className="absolute inset-0 size-full"
        playsInline
        preload="metadata"
        onClick={togglePlay}
        onDoubleClick={toggleFullscreen}
        onPlay={() => {
          setPlaying(true);
          setStarted(true);
          setUpNext(null);
          poke();
        }}
        onPause={() => {
          setPlaying(false);
          setControlsVisible(true);
          save();
        }}
        onWaiting={() => setWaiting(true)}
        onPlaying={() => setWaiting(false)}
        onCanPlay={() => setWaiting(false)}
        onLoadedMetadata={(e) => {
          const v = e.currentTarget;
          setDuration(v.duration);
          v.playbackRate = speed;
          if (startAt > 3 && startAt < v.duration * 0.95) {
            v.currentTime = startAt;
            lastT.current = startAt;
            setTime(startAt);
          }
        }}
        onDurationChange={(e) => setDuration(e.currentTarget.duration)}
        onProgress={(e) => {
          const b = e.currentTarget.buffered;
          if (b.length) setBuffered(b.end(b.length - 1));
        }}
        onTimeUpdate={onTimeUpdate}
        onEnded={() => {
          save(completed.current ? {} : { completed: true });
          completed.current = true;
          if (nextTitle) setUpNext(UP_NEXT_SECONDS);
        }}
      />

      {/* Big center play before first start */}
      {!started && (
        <button onClick={togglePlay} className="absolute inset-0 z-10 flex items-center justify-center bg-[radial-gradient(circle_at_center,transparent,rgba(0,0,0,0.45))]" aria-label="Play video">
          <span className="flex size-16 items-center justify-center rounded-full bg-white text-foreground shadow-2xl">
            <Play className="ml-1 size-8 fill-current" />
          </span>
          {startAt > 3 && <span className="absolute bottom-20 rounded-full bg-black/50 px-3 py-1.5 text-xs font-medium text-white backdrop-blur-md">Resume from {formatSeconds(startAt)}</span>}
        </button>
      )}

      {waiting && started && (
        <div className="pointer-events-none absolute inset-0 z-10 flex items-center justify-center">
          <span className="size-12 animate-spin rounded-full border-[3px] border-white/20 border-t-white" />
        </div>
      )}

      {flash && (
        <div key={flash.key} className="pointer-events-none absolute left-1/2 top-1/2 z-20 -translate-x-1/2 -translate-y-1/2 animate-[fade-up_0.3s_ease-out] rounded-2xl bg-black/60 px-5 py-3 text-lg font-semibold text-white backdrop-blur-md">
          {flash.label}
        </div>
      )}

      {/* Up next overlay */}
      {upNext !== null && nextTitle && (
        <div className="absolute inset-0 z-30 flex items-center justify-center bg-black/75 p-6 backdrop-blur-sm">
          <div className="w-full max-w-sm text-center text-white">
            <p className="text-sm font-medium text-white/60">Up next in {upNext}s</p>
            <p className="mt-2 text-xl font-semibold tracking-tight">{nextTitle}</p>
            <div className="mx-auto mt-5 h-1 w-48 overflow-hidden rounded-full bg-white/20">
              <div className="h-full bg-white transition-[width] duration-1000 ease-linear" style={{ width: `${((UP_NEXT_SECONDS - upNext) / UP_NEXT_SECONDS) * 100}%` }} />
            </div>
            <div className="mt-6 flex justify-center gap-2">
              <button onClick={() => setUpNext(null)} className="rounded-xl bg-white/10 px-4 py-2.5 text-sm font-medium ring-1 ring-white/20 hover:bg-white/20">
                Cancel
              </button>
              <button
                onClick={() => {
                  setUpNext(null);
                  onNext();
                }}
                className="inline-flex items-center gap-2 rounded-xl bg-white px-4 py-2.5 text-sm font-semibold text-black hover:bg-white/90"
              >
                <SkipForward className="size-4" /> Play now
              </button>
            </div>
            <button
              onClick={() => {
                setUpNext(null);
                const v = videoRef.current;
                if (v) {
                  v.currentTime = 0;
                  void v.play();
                }
              }}
              className="mt-4 inline-flex items-center gap-1.5 text-xs text-white/60 hover:text-white"
            >
              <RotateCcw className="size-3.5" /> Replay
            </button>
          </div>
        </div>
      )}

      {/* Controls */}
      <div
        className={cn(
          "absolute inset-x-0 bottom-0 z-20 bg-gradient-to-t from-black/85 via-black/40 to-transparent px-3 pb-2.5 pt-14 text-white transition-opacity duration-300 sm:px-4",
          started && showControls ? "opacity-100" : "pointer-events-none opacity-0",
        )}
      >
        {/* Scrubber */}
        <div
          className="group/scrub relative mb-1.5 flex h-4 items-center"
          onMouseMove={(e) => {
            const r = e.currentTarget.getBoundingClientRect();
            const f = Math.max(0, Math.min(1, (e.clientX - r.left) / r.width));
            setHover({ x: f * 100, t: f * duration });
          }}
          onMouseLeave={() => setHover(null)}
        >
          <div className="relative h-1 w-full overflow-hidden rounded-full bg-white/20 transition-[height] group-hover/scrub:h-1.5">
            <div className="absolute inset-y-0 left-0 bg-white/35" style={{ width: `${bufferedPct}%` }} />
            <div className="absolute inset-y-0 left-0 bg-accent" style={{ width: `${progressPct}%` }} />
          </div>
          <div
            className="pointer-events-none absolute top-1/2 size-3.5 -translate-x-1/2 -translate-y-1/2 scale-0 rounded-full bg-white shadow transition-transform group-hover/scrub:scale-100"
            style={{ left: `${progressPct}%` }}
          />
          {hover && (
            <div className="pointer-events-none absolute -top-8 -translate-x-1/2 rounded-md bg-black/80 px-2 py-1 font-mono text-[11px] tabular-nums" style={{ left: `${hover.x}%` }}>
              {formatSeconds(hover.t)}
            </div>
          )}
          <input
            type="range"
            min={0}
            max={duration || 0}
            step={0.1}
            value={time}
            onChange={(e) => {
              const v = videoRef.current;
              if (v) v.currentTime = Number(e.target.value);
              setTime(Number(e.target.value));
            }}
            aria-label="Seek"
            aria-valuetext={`${formatSeconds(time)} of ${formatSeconds(duration)}`}
            className="absolute inset-0 w-full cursor-pointer opacity-0"
          />
        </div>

        <div className="flex items-center gap-1 sm:gap-2">
          <CtrlButton label={playing ? "Pause (k)" : "Play (k)"} onClick={togglePlay}>
            {playing ? <Pause className="fill-current" /> : <Play className="fill-current" />}
          </CtrlButton>
          <CtrlButton label="Back 10s (j)" onClick={() => skip(-10)}>
            <RotateCcw />
          </CtrlButton>
          <CtrlButton label="Forward 10s (l)" onClick={() => skip(10)}>
            <RotateCw />
          </CtrlButton>
          <div className="group/vol flex items-center">
            <CtrlButton label="Mute (m)" onClick={() => setMuted((m) => !m)}>
              <VolIcon />
            </CtrlButton>
            <input
              type="range"
              min={0}
              max={1}
              step={0.05}
              value={muted ? 0 : volume}
              onChange={(e) => changeVolume(Number(e.target.value))}
              aria-label="Volume"
              className="hidden h-1 w-0 cursor-pointer accent-white transition-[width] duration-200 group-hover/vol:w-20 sm:block"
            />
          </div>
          <span className="ml-1 font-mono text-xs tabular-nums text-white/85">
            {formatSeconds(time)} <span className="text-white/45">/ {formatSeconds(duration)}</span>
          </span>

          <div className="ml-auto flex items-center gap-1">
            {nextTitle && (
              <CtrlButton label="Next lesson" onClick={onNext}>
                <SkipForward />
              </CtrlButton>
            )}
            <DM.Root modal={false}>
              <DM.Trigger asChild>
                <button className="inline-flex h-9 items-center gap-1 rounded-lg px-2 text-xs font-semibold tabular-nums hover:bg-white/15" aria-label="Playback speed">
                  <Gauge className="size-4" />
                  {speed}×
                </button>
              </DM.Trigger>
              {/* Portal into the player so the menu stays visible in fullscreen. */}
              <DM.Portal container={wrapRef.current}>
                <DM.Content align="end" side="top" sideOffset={8} className="z-50 w-36 rounded-xl border border-white/10 bg-black/85 p-1 text-white shadow-2xl backdrop-blur-md">
                  <DM.Label className="px-2.5 py-1.5 text-[11px] font-medium text-white/50">Playback speed</DM.Label>
                  {SPEEDS.map((sp) => (
                    <DM.Item
                      key={sp}
                      onSelect={() => changeSpeed(sp)}
                      className="flex cursor-pointer items-center justify-between rounded-lg px-2.5 py-1.5 text-sm tabular-nums outline-none data-[highlighted]:bg-white/15"
                    >
                      {sp === 1 ? "Normal" : `${sp}×`}
                      {sp === speed && <Check className="size-4 text-accent" />}
                    </DM.Item>
                  ))}
                </DM.Content>
              </DM.Portal>
            </DM.Root>
            <CtrlButton label={fullscreen ? "Exit fullscreen (f)" : "Fullscreen (f)"} onClick={toggleFullscreen}>
              {fullscreen ? <Minimize /> : <Maximize />}
            </CtrlButton>
          </div>
        </div>
      </div>
    </div>
  );
}

function CtrlButton({ label, onClick, children }: { label: string; onClick: () => void; children: React.ReactNode }) {
  return (
    <button onClick={onClick} aria-label={label} title={label} className="inline-flex size-9 items-center justify-center rounded-lg transition hover:bg-white/15 active:scale-90 [&_svg]:size-[18px]">
      {children}
    </button>
  );
}

/** YouTube / Vimeo lessons: embedded, completion is manual. */
export function EmbedPlayer({ url, title }: { url: string; title: string }) {
  return (
    <div className="relative aspect-video w-full overflow-hidden bg-black">
      <iframe src={url} title={title} className="absolute inset-0 size-full" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen" allowFullScreen />
    </div>
  );
}
