"use client";

import { useRef, useState } from "react";
import { toast } from "sonner";
import { CloudUpload, Film, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ProgressBar } from "@/components/ui/display";
import { api } from "@/lib/api";
import { cn } from "@/lib/utils";

const PART_SIZE = 10 * 1024 * 1024;

type UploadCtl = { canceled: boolean; xhr?: XMLHttpRequest; uploadId?: string; key?: string };

function putPart(url: string, blob: Blob, onProgress: (loaded: number) => void, signal: { xhr?: XMLHttpRequest }) {
  return new Promise<{ partNumber: number; etag: string }>((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    signal.xhr = xhr;
    xhr.open("PUT", url);
    xhr.responseType = "json";
    xhr.upload.onprogress = (e) => onProgress(e.loaded);
    xhr.onload = () => (xhr.status >= 200 && xhr.status < 300 ? resolve(xhr.response) : reject(new Error(xhr.response?.error ?? `Upload failed (${xhr.status})`)));
    xhr.onerror = () => reject(new Error("Network error during upload"));
    xhr.onabort = () => reject(new DOMException("Upload canceled", "AbortError"));
    xhr.send(blob);
  });
}

/** Reads a local video's duration (seconds) via a detached <video> element. */
function readDuration(file: File) {
  return new Promise<number | null>((resolve) => {
    const url = URL.createObjectURL(file);
    const v = document.createElement("video");
    v.preload = "metadata";
    v.onloadedmetadata = () => {
      URL.revokeObjectURL(url);
      resolve(Number.isFinite(v.duration) ? Math.round(v.duration) : null);
    };
    v.onerror = () => {
      URL.revokeObjectURL(url);
      resolve(null);
    };
    v.src = url;
  });
}

/**
 * Uploads a video to R2 through the API's multipart endpoints in 10 MB parts,
 * so files far beyond the Worker request-size limit work.
 */
export function VideoUploader({ onUploaded }: { onUploaded: (r: { key: string; durationSeconds: number | null; filename: string }) => void }) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [state, setState] = useState<{ file: File; progress: number } | null>(null);
  const [dragOver, setDragOver] = useState(false);
  const cancelRef = useRef<UploadCtl>({ canceled: false });

  const start = async (file: File) => {
    if (!file.type.startsWith("video/")) {
      toast.error("Choose a video file (MP4, WebM or MOV)");
      return;
    }
    const ctl: UploadCtl = { canceled: false };
    cancelRef.current = ctl;
    setState({ file, progress: 0 });
    try {
      const [duration, init] = await Promise.all([
        readDuration(file),
        api.post<{ key: string; uploadId: string }>("/admin/uploads/multipart", { filename: file.name, contentType: file.type, kind: "video" }),
      ]);
      ctl.uploadId = init.uploadId;
      ctl.key = init.key;
      const parts: { partNumber: number; etag: string }[] = [];
      const count = Math.ceil(file.size / PART_SIZE);
      let done = 0;
      for (let i = 0; i < count; i++) {
        if (ctl.canceled) throw new DOMException("Upload canceled", "AbortError");
        const blob = file.slice(i * PART_SIZE, Math.min(file.size, (i + 1) * PART_SIZE));
        const part = await putPart(
          `/api/admin/uploads/multipart/${init.uploadId}/${i + 1}?key=${encodeURIComponent(init.key)}`,
          blob,
          (loaded) => setState({ file, progress: ((done + loaded) / file.size) * 100 }),
          ctl,
        );
        done += blob.size;
        parts.push({ partNumber: part.partNumber, etag: part.etag });
      }
      await api.post(`/admin/uploads/multipart/${init.uploadId}/complete`, { key: init.key, parts });
      setState(null);
      toast.success("Video uploaded");
      onUploaded({ key: init.key, durationSeconds: duration, filename: file.name });
    } catch (e) {
      setState(null);
      if (ctl.uploadId && ctl.key) api.delete(`/admin/uploads/multipart/${ctl.uploadId}?key=${encodeURIComponent(ctl.key)}`).catch(() => {});
      if (e instanceof DOMException && e.name === "AbortError") toast("Upload canceled");
      else toast.error(e instanceof Error ? e.message : "Upload failed");
    }
  };

  const cancel = () => {
    cancelRef.current.canceled = true;
    cancelRef.current.xhr?.abort();
  };

  if (state) {
    const mb = (n: number) => (n / 1048576).toFixed(1);
    return (
      <div className="rounded-2xl border border-border bg-surface-2 p-5">
        <div className="flex items-center gap-3">
          <span className="flex size-10 items-center justify-center rounded-lg border border-border bg-surface text-muted-foreground">
            <Film className="size-4" />
          </span>
          <div className="min-w-0 flex-1">
            <div className="truncate text-sm font-medium">{state.file.name}</div>
            <div className="text-xs tabular-nums text-subtle-foreground">
              {mb((state.progress / 100) * state.file.size)} of {mb(state.file.size)} MB · {Math.floor(state.progress)}%
            </div>
          </div>
          <Button variant="ghost" size="sm" onClick={cancel}>
            <X /> Cancel
          </Button>
        </div>
        <ProgressBar value={state.progress} className="mt-4" size="md" />
      </div>
    );
  }

  return (
    <div
      onDragOver={(e) => {
        e.preventDefault();
        setDragOver(true);
      }}
      onDragLeave={() => setDragOver(false)}
      onDrop={(e) => {
        e.preventDefault();
        setDragOver(false);
        const f = e.dataTransfer.files[0];
        if (f) start(f);
      }}
      className={cn(
        "flex flex-col items-center justify-center rounded-2xl border border-dashed px-6 py-10 text-center transition-colors",
        dragOver ? "border-accent bg-accent-soft" : "border-border-strong bg-surface-2/60",
      )}
    >
      <span className="mb-3 flex size-11 items-center justify-center rounded-lg border border-border bg-surface text-muted-foreground">
        <CloudUpload className="size-5" />
      </span>
      <p className="text-sm font-medium">Drop a video here or browse</p>
      <p className="mt-1 text-xs text-subtle-foreground">MP4, WebM or MOV · uploaded securely to R2 in 10 MB parts</p>
      <input
        ref={inputRef}
        type="file"
        accept="video/mp4,video/webm,video/quicktime"
        className="hidden"
        onChange={(e) => {
          const f = e.target.files?.[0];
          if (f) start(f);
          e.target.value = "";
        }}
      />
      <Button variant="secondary" size="sm" className="mt-4" onClick={() => inputRef.current?.click()}>
        Choose file
      </Button>
    </div>
  );
}
