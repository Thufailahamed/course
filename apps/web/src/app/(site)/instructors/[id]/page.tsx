import type { Metadata } from "next";
import type { CourseCard as Course, Instructor } from "@latent/shared";
import { CourseCard } from "@/components/course-card";
import { Avatar } from "@/components/ui/display";
import { serverApiOr404, serverApiSafe } from "@/lib/server";
import { formatNumber } from "@/lib/utils";

type Data = { instructor: Instructor & { reviewsCount: number }; courses: Course[] };
type Props = { params: Promise<{ id: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const d = await serverApiSafe<Data>(`/instructors/${id}`);
  return d ? { title: d.instructor.name, description: d.instructor.headline ?? undefined } : { title: "Instructor" };
}

export default async function InstructorPage({ params }: Props) {
  const { id } = await params;
  const { instructor: ins, courses } = await serverApiOr404<Data>(`/instructors/${id}`);
  return (
    <div>
      <section className="border-b border-border bg-surface">
        <div className="container-page flex flex-col gap-8 py-16 sm:flex-row sm:items-center sm:gap-10 sm:py-20">
          <Avatar name={ins.name} src={ins.avatarUrl} size={112} className="ring-1 ring-border" />
          <div className="min-w-0">
            <p className="text-sm font-semibold text-accent">Instructor</p>
            <h1 className="mt-2 text-[2.25rem] leading-[1.1] tracking-[-0.035em] sm:text-[2.75rem]">{ins.name}</h1>
            <p className="mt-2 max-w-2xl text-[16px] text-muted-foreground">{ins.headline}</p>
          </div>
        </div>
        <div className="container-page">
          <dl className="grid grid-cols-2 border-t border-border sm:grid-cols-4">
            {[
              [`${formatNumber(ins.studentsCount ?? 0)}`, "Learners"],
              [ins.ratingAvg ? ins.ratingAvg.toFixed(1) : "—", "Avg rating"],
              [formatNumber(ins.reviewsCount ?? 0), "Reviews"],
              [String(ins.coursesCount ?? courses.length), "Courses"],
            ].map(([v, l]) => (
              <div key={l} className="flex flex-col-reverse py-6 pr-6 sm:border-l sm:border-border sm:px-6 sm:first:border-l-0 sm:first:pl-0">
                <dt className="mt-1 text-[13px] text-muted-foreground">{l}</dt>
                <dd className="text-[1.75rem] font-semibold tabular-nums tracking-[-0.035em]">{v}</dd>
              </div>
            ))}
          </dl>
        </div>
      </section>
      <div className="container-page grid gap-12 py-14 lg:grid-cols-[320px_1fr]">
        <aside>
          <h2 className="text-xl tracking-[-0.02em]">About</h2>
          <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">{ins.bio ?? "No bio yet."}</p>
        </aside>
        <div>
          <h2 className="text-xl tracking-[-0.02em]">Courses by {ins.name.split(" ").slice(-1)[0]}</h2>
          <div className="mt-6 grid gap-5 sm:grid-cols-2">
            {courses.map((c) => (
              <CourseCard key={c.id} course={c} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
