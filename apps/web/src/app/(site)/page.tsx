import Link from "next/link";
import { ArrowRight, Award, BookOpenCheck, Check, Code2, Flame, LineChart, MessagesSquare, RefreshCw, Sparkles } from "lucide-react";
import type { Category, CourseCard as Course, Instructor, LearningPath, Paginated, PricingConfig, Review } from "@latent/shared";
import { InstructorCard, PathCard } from "@/components/marketing/cards";
import { CategoryIcon } from "@/components/marketing/category-icon";
import { Faq } from "@/components/marketing/faq";
import { FAQ_ITEMS } from "@/components/marketing/faq-data";
import { CountUp } from "@/components/marketing/home/count-up";
import { DescentPlayground } from "@/components/marketing/home/descent-playground";
import { FeaturedCourses } from "@/components/marketing/home/featured-courses";
import { Marquee, ScrollProgress, SpotlightGrid, Stagger } from "@/components/marketing/home/effects";
import { Hero } from "@/components/marketing/home/hero";
import { LearnStory } from "@/components/marketing/home/learn-story";
import { Reveal } from "@/components/marketing/reveal";
import { TestimonialMarquee } from "@/components/marketing/testimonials";
import { SectionHeading } from "@/components/ui/display";
import { serverApiSafe } from "@/lib/server";
import { formatPrice } from "@/lib/utils";

type Stats = { courses: number; hours: number; learners: number; reviews: number; avgRating: number };

const COMPANIES = ["Northwind", "Acme Robotics", "Helix Bio", "Quanta", "Lumen Labs", "Vertex AI Co.", "Orbital", "Fathom"];

const TILES = [
  "bg-accent shadow-[0_3px_0_0_var(--accent-edge)]",
  "bg-go shadow-[0_3px_0_0_var(--go-edge)]",
  "bg-[oklch(0.6_0.2_300)] shadow-[0_3px_0_0_oklch(0.47_0.19_300)]",
  "bg-[oklch(0.75_0.17_55)] shadow-[0_3px_0_0_oklch(0.6_0.16_45)]",
  "bg-[oklch(0.64_0.2_350)] shadow-[0_3px_0_0_oklch(0.5_0.19_350)]",
  "bg-[oklch(0.62_0.13_200)] shadow-[0_3px_0_0_oklch(0.5_0.12_205)]",
];

const FEATURES = [
  { icon: Code2, title: "Hands-on notebooks", body: "Every concept becomes code you run yourself. Download notebooks and build real projects." },
  { icon: BookOpenCheck, title: "Checkpoints & quizzes", body: "Graded checkpoints with instant explanations lock in understanding before you move on." },
  { icon: LineChart, title: "Progress & streaks", body: "Pick up exactly where you left off, track your streak and see your learning momentum." },
  { icon: Award, title: "Verifiable certificates", body: "Earn a certificate with a public verification link for every course you complete." },
  { icon: MessagesSquare, title: "Instructor Q&A", body: "Ask questions on any lesson and get answers from instructors and a community of peers." },
  { icon: RefreshCw, title: "Lifetime updates", body: "AI moves fast. Courses are refreshed continuously, and every update is yours to keep." },
];

export default async function Home() {
  const [stats, featured, categories, paths, instructors, reviews, config] = await Promise.all([
    serverApiSafe<Stats>("/stats"),
    serverApiSafe<Paginated<Course>>("/courses?featured=1&pageSize=6"),
    serverApiSafe<{ items: Category[] }>("/categories"),
    serverApiSafe<{ items: LearningPath[] }>("/paths"),
    serverApiSafe<{ items: Instructor[] }>("/instructors"),
    serverApiSafe<{ items: (Review & { course: { title: string; slug: string } })[] }>("/reviews/featured"),
    serverApiSafe<PricingConfig>("/config"),
  ]);

  const learners = stats?.learners ?? 0;

  return (
    <>
      <ScrollProgress />

      {/* ── Hero ─────────────────────────────────────────── */}
      <Hero learners={learners} rating={stats?.avgRating ?? 4.8} />

      {/* ── Trust strip ──────────────────────────────────── */}
      <section className="border-b border-border bg-background py-10">
        <p className="text-center text-[13px] font-medium text-subtle-foreground">Learners from teams at</p>
        <Marquee duration={36} className="mt-6">
          {COMPANIES.map((c, i) => (
            <span
              key={c}
              className={
                ["font-bold tracking-[-0.04em]", "font-semibold uppercase tracking-[0.08em] text-[15px]", "font-medium tracking-[-0.02em]", "font-extrabold tracking-[-0.05em]"][i % 4] +
                " mx-8 whitespace-nowrap text-xl text-subtle-foreground/80 transition-colors hover:text-foreground sm:mx-11"
              }
            >
              {c}
            </span>
          ))}
        </Marquee>
      </section>

      {/* ── Playground ───────────────────────────────────── */}
      <section className="container-page py-24">
        <Reveal>
          <SectionHeading
            align="center"
            eyebrow="Learn by doing"
            title={
              <>
                Don&apos;t just read about it. <span className="font-serif font-normal italic text-accent">Play with it.</span>
              </>
            }
            description="This is a real figure from our Deep Learning course. Every lesson is full of them."
          />
        </Reveal>
        <Reveal delay={0.1} className="mt-12">
          <DescentPlayground />
        </Reveal>
      </section>

      {/* ── Featured courses ─────────────────────────────── */}
      <section className="relative pb-28">
        <div aria-hidden className="pointer-events-none absolute inset-x-0 top-24 h-[420px] bg-[radial-gradient(60%_60%_at_50%_40%,oklch(0.57_0.21_262/0.06),transparent)]" />
        <div className="container-page relative">
          <Reveal>
            <div className="flex flex-col gap-6 sm:flex-row sm:items-end sm:justify-between">
              <div className="max-w-2xl">
                <p className="inline-flex items-center gap-2 rounded-full bg-accent-soft px-3 py-1 text-[13px] font-semibold text-accent">
                  <Flame className="size-3.5" /> Featured
                </p>
                <h2 className="mt-4 text-[2.1rem] font-bold leading-[1.05] tracking-[-0.045em] sm:text-[2.9rem]">
                  Courses learners <span className="font-serif font-normal italic text-accent">recommend</span> most
                </h2>
                <p className="mt-4 max-w-xl text-[16px] leading-relaxed text-muted-foreground">Deep, project-driven programs that take you from fundamentals to production.</p>
              </div>
              <Link href="/courses" className="btn-3d btn-3d-white group shrink-0">
                View all courses <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
              </Link>
            </div>
          </Reveal>
          <FeaturedCourses courses={featured?.items ?? []} />
        </div>
      </section>

      {/* ── How you learn ────────────────────────────────── */}
      <section className="border-y border-border bg-surface">
        <div className="container-page pt-24">
          <Reveal>
            <SectionHeading
              align="center"
              eyebrow="How you learn"
              title={
                <>
                  Built for <span className="font-serif font-normal italic text-accent">understanding</span>, not just completion
                </>
              }
              description="One loop, repeated every few minutes: understand, run, prove it, ask."
            />
          </Reveal>
          <div className="mt-10 lg:mt-0">
            <LearnStory />
          </div>
        </div>
      </section>

      {/* ── Stats ────────────────────────────────────────── */}
      <section className="container-page py-24">
        <Stagger className="grid grid-cols-2 gap-4 lg:grid-cols-4">
          {[
            { v: <CountUp value={learners} suffix="+" />, l: "Learners enrolled", t: TILES[0]! },
            { v: <CountUp value={stats?.courses ?? 12} compact={false} />, l: "Expert-led courses", t: TILES[1]! },
            { v: <CountUp value={stats?.hours ?? 40} compact={false} suffix="+" />, l: "Hours of content", t: TILES[2]! },
            { v: <CountUp value={stats?.avgRating ?? 4.8} decimals={1} suffix=" / 5" />, l: "Average rating", t: TILES[3]! },
          ].map(({ v, l, t }) => (
            <div key={l} className="card-3d h-full p-6 sm:p-8">
              <span className={`block h-2 w-10 rounded-full ${t}`} />
              <div className="mt-6 text-[2.2rem] font-bold leading-none tracking-[-0.045em] sm:text-[2.9rem]">{v}</div>
              <div className="mt-2.5 text-[14px] text-muted-foreground">{l}</div>
            </div>
          ))}
        </Stagger>
      </section>

      {/* ── Topics ───────────────────────────────────────── */}
      <section className="container-page pb-24">
        <Reveal>
          <SectionHeading eyebrow="Topics" title="Browse by topic" description="From linear algebra to autonomous agents. Pick a subject and go deep." />
        </Reveal>
        <SpotlightGrid className="mt-10">
          <Stagger className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3" gap={0.05}>
            {(categories?.items ?? []).map((c, i) => (
              <Link
                key={c.id}
                href={`/courses?category=${c.slug}`}
                className="spotlight group flex h-full items-center gap-4 rounded-[20px] border-2 border-line-3d bg-surface p-4 shadow-[0_4px_0_0_var(--line-3d)] transition-all duration-200 hover:-translate-y-1 hover:border-accent/40 hover:shadow-[0_5px_0_0_var(--accent-soft)]"
              >
                <span className={`flex size-11 shrink-0 items-center justify-center rounded-[14px] text-white transition-transform duration-300 group-hover:-rotate-6 group-hover:scale-110 ${TILES[i % TILES.length]}`}>
                  <CategoryIcon name={c.icon} className="size-5" />
                </span>
                <div className="min-w-0 flex-1">
                  <div className="text-[15px] font-bold tracking-[-0.015em]">{c.name}</div>
                  <div className="truncate text-[13px] text-muted-foreground">{c.description}</div>
                </div>
                <span className="flex h-7 min-w-7 shrink-0 items-center justify-center rounded-full bg-surface-2 px-2 text-xs font-semibold tabular-nums text-muted-foreground transition-colors group-hover:bg-accent group-hover:text-white">
                  {c.coursesCount}
                </span>
              </Link>
            ))}
          </Stagger>
        </SpotlightGrid>
      </section>

      {/* ── Features ─────────────────────────────────────── */}
      <section className="container-page pb-24">
        <Reveal>
          <SectionHeading align="center" eyebrow="Everything included" title="All the tools to go from curious to capable" />
        </Reveal>
        <SpotlightGrid className="mt-12">
          <Stagger className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {FEATURES.map(({ icon: Icon, title, body }, i) => (
              <div key={title} className="spotlight card-3d group h-full p-7 transition-transform duration-300 hover:-translate-y-1">
                <span className={`flex size-11 items-center justify-center rounded-[14px] text-white transition-transform duration-300 group-hover:-rotate-6 group-hover:scale-110 ${TILES[i % TILES.length]}`}>
                  <Icon className="size-5" />
                </span>
                <h3 className="mt-5 text-[17px] font-bold tracking-[-0.02em]">{title}</h3>
                <p className="mt-2 text-[14.5px] leading-relaxed text-muted-foreground">{body}</p>
              </div>
            ))}
          </Stagger>
        </SpotlightGrid>
      </section>

      {/* ── Paths ────────────────────────────────────────── */}
      {!!paths?.items.length && (
        <section className="container-page pb-24">
          <Reveal>
            <SectionHeading
              eyebrow="Learning paths"
              title="A clear road to your next role"
              description="Curated sequences of courses that build on each other, designed around real job requirements."
              action={
                <Link href="/paths" className="btn-3d btn-3d-white group">
                  All paths <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
                </Link>
              }
            />
          </Reveal>
          <Stagger className="mt-10 grid gap-5 md:grid-cols-3">
            {paths.items.map((p) => (
              <div key={p.id} className="h-full transition-transform duration-300 hover:-translate-y-1.5">
                <PathCard path={p} className="h-full" />
              </div>
            ))}
          </Stagger>
        </section>
      )}

      {/* ── Instructors ──────────────────────────────────── */}
      {!!instructors?.items.length && (
        <section className="container-page pb-24">
          <Reveal>
            <SectionHeading
              eyebrow="Instructors"
              title="Taught by practitioners"
              description="Researchers and engineers who have trained frontier models and built ML systems at scale."
              action={
                <Link href="/instructors" className="btn-3d btn-3d-white group">
                  All instructors <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
                </Link>
              }
            />
          </Reveal>
          <Stagger className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {instructors.items.slice(0, 6).map((ins) => (
              <div key={ins.id} className="h-full transition-transform duration-300 hover:-translate-y-1.5">
                <InstructorCard instructor={ins} className="h-full" />
              </div>
            ))}
          </Stagger>
        </section>
      )}

      {/* ── Testimonials ─────────────────────────────────── */}
      {!!reviews?.items.length && (
        <section className="overflow-hidden border-y border-border bg-surface-2/50 py-24">
          <div className="container-page">
            <Reveal>
              <SectionHeading
                align="center"
                eyebrow="Reviews"
                title={
                  <>
                    Loved by people who <span className="font-serif font-normal italic text-accent">ship</span>
                  </>
                }
              />
            </Reveal>
          </div>
          <div className="mt-12">
            <TestimonialMarquee reviews={reviews.items} />
          </div>
        </section>
      )}

      {/* ── Pro teaser ───────────────────────────────────── */}
      <section className="container-page py-24">
        <Reveal>
          <div className="relative overflow-hidden rounded-[28px] bg-ink text-ink-foreground shadow-[0_6px_0_0_oklch(0.08_0.005_270)]">
            <div aria-hidden className="pointer-events-none absolute -left-24 -top-24 size-[420px] rounded-full bg-[oklch(0.57_0.21_262/0.35)] blur-[100px] animate-float" style={{ animationDuration: "9s" }} />
            <div aria-hidden className="pointer-events-none absolute -bottom-32 right-0 size-[380px] rounded-full bg-[oklch(0.7_0.19_145/0.22)] blur-[100px] animate-float" style={{ animationDuration: "11s" }} />
            <div aria-hidden className="pointer-events-none absolute inset-0 bg-[radial-gradient(oklch(1_0_0/0.07)_1px,transparent_1.3px)] [background-size:24px_24px] [mask-image:radial-gradient(ellipse_at_center,#000,transparent_75%)]" />
            <div className="relative grid gap-10 p-8 sm:p-12 lg:grid-cols-[1.3fr_1fr] lg:items-center lg:p-16">
              <div>
                <p className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-[13px] font-semibold text-white/90">
                  <Sparkles className="size-3.5 text-[oklch(0.85_0.12_80)]" /> Latent Pro
                </p>
                <h2 className="mt-5 text-[2.3rem] font-bold leading-[1.05] tracking-[-0.04em] sm:text-[3.2rem]">
                  Every course. <span className="font-serif font-normal italic text-[oklch(0.8_0.12_262)]">One membership.</span>
                </h2>
                <p className="mt-5 max-w-lg text-[16px] leading-relaxed text-ink-foreground/65">
                  Unlimited access to the entire catalog, every new release, all learning paths and certificates, for less than the price of two courses a year.
                </p>
                <div className="mt-9 flex flex-col gap-3.5 sm:flex-row">
                  <Link href="/pricing" className="btn-3d btn-3d-green group h-12 px-6 text-[15px]">
                    See plans <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
                  </Link>
                  <Link href="/teams" className="btn-3d btn-3d-ghost-dark h-12 px-6 text-[15px] ring-1 ring-white/15">
                    Latent for Teams
                  </Link>
                </div>
              </div>
              <div className="rounded-[22px] border border-white/10 bg-white/[0.05] p-6 backdrop-blur sm:p-8">
                <div className="flex items-baseline gap-1.5">
                  <span className="text-[3.2rem] font-bold leading-none tracking-[-0.05em]">{formatPrice(Math.round((config?.proYearlyCents ?? 24900) / 12), config?.currency)}</span>
                  <span className="text-ink-foreground/55">/ month</span>
                </div>
                <p className="mt-2 text-[13px] text-ink-foreground/50">Billed annually at {formatPrice(config?.proYearlyCents ?? 24900, config?.currency)}</p>
                <ul className="mt-6 space-y-3.5 border-t border-white/10 pt-6 text-[14.5px]">
                  {["All current & future courses", "Every learning path", "Unlimited AI tutor", "Certificates of completion", "Cancel anytime"].map((f) => (
                    <li key={f} className="flex items-center gap-3">
                      <span className="flex size-5 items-center justify-center rounded-full bg-go text-white">
                        <Check className="size-3" strokeWidth={3.5} />
                      </span>
                      {f}
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </Reveal>
      </section>

      {/* ── FAQ ──────────────────────────────────────────── */}
      <section className="container-page grid gap-10 pb-24 lg:grid-cols-[1fr_1.7fr] lg:gap-16">
        <Reveal>
          <SectionHeading eyebrow="FAQ" title="Frequently asked questions" description="Can't find what you're looking for? Our team is happy to help." />
          <Link href="/teams#contact" className="btn-3d btn-3d-white mt-7">
            Contact us
          </Link>
        </Reveal>
        <Reveal delay={0.1}>
          <Faq items={FAQ_ITEMS} />
        </Reveal>
      </section>

      {/* ── Final CTA ────────────────────────────────────── */}
      <section className="container-page pb-6">
        <Reveal>
          <div className="relative overflow-hidden rounded-[28px] border-2 border-line-3d bg-surface px-6 py-16 text-center shadow-[0_5px_0_0_var(--line-3d)] sm:px-12 sm:py-20">
            <div aria-hidden className="bg-dots pointer-events-none absolute inset-0" />
            <div aria-hidden className="pointer-events-none absolute left-1/2 top-0 size-[500px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[oklch(0.57_0.21_262/0.12)] blur-[90px]" />
            <div className="relative">
              <h2 className="mx-auto max-w-2xl text-[2.3rem] font-bold leading-[1.05] tracking-[-0.045em] sm:text-[3.4rem]">
                Your first lesson is <span className="font-serif font-normal italic text-accent">five minutes</span> away.
              </h2>
              <p className="mx-auto mt-5 max-w-lg text-[16px] text-muted-foreground">Create a free account and begin with Python for Data Science. No credit card required.</p>
              <div className="mt-9 flex flex-col justify-center gap-3.5 sm:flex-row">
                <Link href="/signup" className="btn-3d btn-3d-green group h-12 px-7 text-[15px]">
                  Get started for free <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
                </Link>
                <Link href="/courses" className="btn-3d btn-3d-white h-12 px-7 text-[15px]">
                  Browse courses
                </Link>
              </div>
            </div>
          </div>
        </Reveal>
      </section>
    </>
  );
}
