import ReactMarkdown from "react-markdown";
import rehypeHighlight from "rehype-highlight";
import rehypeKatex from "rehype-katex";
import remarkGfm from "remark-gfm";
import remarkMath from "remark-math";
import { cn } from "@/lib/utils";

/** Renders lesson/course Markdown with GFM, KaTeX math and syntax highlighting. */
export function Markdown({ children, className, size = "base" }: { children: string; className?: string; size?: "sm" | "base" | "lg" }) {
  return (
    <div
      className={cn(
        "prose prose-latent max-w-none prose-code:before:content-none prose-code:after:content-none prose-blockquote:not-italic [&_blockquote_p:first-of-type]:before:content-none [&_blockquote_p:last-of-type]:after:content-none prose-headings:font-semibold prose-headings:tracking-[-0.02em] prose-a:font-medium prose-a:underline prose-a:decoration-accent/30 prose-a:underline-offset-4 hover:prose-a:decoration-accent prose-img:rounded-xl",
        size === "sm" && "prose-sm",
        size === "lg" && "prose-lg",
        className,
      )}
    >
      <ReactMarkdown remarkPlugins={[remarkGfm, remarkMath]} rehypePlugins={[rehypeKatex, [rehypeHighlight, { detect: true, ignoreMissing: true }]]}>
        {children}
      </ReactMarkdown>
    </div>
  );
}
