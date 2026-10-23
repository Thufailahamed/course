import { Markdown } from "@/components/markdown";

export function LegalPage({ title, updated, body }: { title: string; updated: string; body: string }) {
  return (
    <div className="container-page max-w-3xl py-16 sm:py-20">
      <p className="text-sm font-semibold text-accent">Legal</p>
      <h1 className="mt-3 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[2.75rem]">{title}</h1>
      <p className="mt-3 text-sm text-subtle-foreground">Last updated {updated}</p>
      <div className="mt-10 border-t border-border pt-10">
        <Markdown>{body}</Markdown>
      </div>
    </div>
  );
}
