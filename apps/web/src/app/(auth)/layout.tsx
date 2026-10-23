import Link from "next/link";
import { Logo } from "@/components/logo";
import { Avatar, Stars } from "@/components/ui/display";

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="grid min-h-dvh lg:grid-cols-[1fr_1fr]">
      <div className="relative flex flex-col px-6 py-8 sm:px-10">
        <div className="flex items-center justify-between">
          <Logo />
          <Link href="/courses" className="text-sm text-muted-foreground transition hover:text-foreground">
            Browse courses
          </Link>
        </div>
        <div className="mx-auto flex w-full max-w-[400px] flex-1 flex-col justify-center py-12">{children}</div>
        <p className="text-center text-xs text-subtle-foreground">
          By continuing you agree to our{" "}
          <Link href="/terms" className="underline decoration-border-strong underline-offset-2 hover:text-foreground">
            Terms
          </Link>{" "}
          and{" "}
          <Link href="/privacy" className="underline decoration-border-strong underline-offset-2 hover:text-foreground">
            Privacy Policy
          </Link>
          .
        </p>
      </div>

      <aside className="relative hidden overflow-hidden bg-ink text-ink-foreground lg:flex lg:flex-col" aria-hidden>
        <div className="px-14 pt-12 text-sm text-ink-foreground/55">Learner stories</div>

        <div className="flex flex-1 flex-col justify-center px-14 py-12">
          <Stars value={5} />
          <blockquote className="mt-6 max-w-xl text-[1.5rem] font-medium leading-[1.4] tracking-[-0.02em] xl:text-[1.7rem]">
            I went from copying snippets to actually understanding transformers. The AI tutor felt like a mentor on call — I shipped our first RAG feature a month later.
          </blockquote>
          <div className="mt-10 flex items-center gap-4">
            <Avatar name="Priya Iyer" size={44} />
            <div>
              <p className="text-[15px] font-medium">Priya Iyer</p>
              <p className="text-sm text-ink-foreground/60">ML Engineer · LLM Engineering graduate</p>
            </div>
          </div>
        </div>

        <p className="border-t border-white/10 px-14 py-7 text-[13px] text-ink-foreground/50">Trusted by learners at Northwind, Helix Bio, Quanta and Lumen Labs.</p>
      </aside>
    </div>
  );
}
