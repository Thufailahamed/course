"use client";

import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { Suspense } from "react";
import { BookOpen, CheckCircle2, Heart, Layers, Loader } from "lucide-react";
import { CourseCard, CourseCardSkeleton } from "@/components/course-card";
import { EnrollmentCard, EnrollmentCardSkeleton } from "@/components/learner/enrollment-card";
import { useCertificateMap, useEnrollments, useWishlist } from "@/components/learner/queries";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/display";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/primitives";

const TABS = [
  { value: "all", label: "All courses", icon: Layers },
  { value: "in-progress", label: "In progress", icon: Loader },
  { value: "completed", label: "Completed", icon: CheckCircle2 },
  { value: "wishlist", label: "Wishlist", icon: Heart },
] as const;
type Tab = (typeof TABS)[number]["value"];

function MyCourses() {
  const search = useSearchParams();
  const router = useRouter();
  const pathname = usePathname();
  const tab = (TABS.some((t) => t.value === search.get("tab")) ? search.get("tab") : "all") as Tab;

  const { data: enrollments, isPending } = useEnrollments();
  const { data: wishlist, isPending: loadingWish } = useWishlist();
  const certs = useCertificateMap();

  const all = enrollments ?? [];
  const isDone = (e: (typeof all)[number]) => !!e.completedAt || e.progressPercent >= 100;
  const counts: Record<Tab, number> = {
    all: all.length,
    "in-progress": all.filter((e) => !isDone(e)).length,
    completed: all.filter(isDone).length,
    wishlist: wishlist?.length ?? 0,
  };
  const list = tab === "in-progress" ? all.filter((e) => !isDone(e)) : tab === "completed" ? all.filter(isDone) : all;

  return (
    <div className="container-page py-10 sm:py-14">
      <div className="flex flex-col gap-2">
        <h1 className="text-[1.75rem] leading-tight sm:text-[2rem]">
          My learning
        </h1>
        <p className="text-muted-foreground">Everything you're enrolled in, in one place.</p>
      </div>

      <Tabs value={tab} onValueChange={(v) => router.replace(v === "all" ? pathname : `${pathname}?tab=${v}`, { scroll: false })} className="mt-8">
        <TabsList>
          {TABS.map((t) => (
            <TabsTrigger key={t.value} value={t.value}>
              <t.icon /> {t.label}
              <span className="rounded-full bg-surface-3 px-1.5 text-[11px] tabular-nums text-muted-foreground">{counts[t.value]}</span>
            </TabsTrigger>
          ))}
        </TabsList>
      </Tabs>

      <div className="mt-8">
        {tab === "wishlist" ? (
          loadingWish ? (
            <Grid>{Array.from({ length: 4 }, (_, i) => <CourseCardSkeleton key={i} />)}</Grid>
          ) : !wishlist?.length ? (
            <EmptyState
              icon={<Heart />}
              title="Your wishlist is empty"
              description="Tap the heart on any course to save it for later."
              action={
                <Button asChild>
                  <Link href="/courses">Discover courses</Link>
                </Button>
              }
            />
          ) : (
            <Grid>
              {wishlist.map((c) => (
                <CourseCard key={c.id} course={c} />
              ))}
            </Grid>
          )
        ) : isPending ? (
          <Grid>{Array.from({ length: 4 }, (_, i) => <EnrollmentCardSkeleton key={i} />)}</Grid>
        ) : list.length === 0 ? (
          <EmptyState
            icon={tab === "completed" ? <CheckCircle2 /> : <BookOpen />}
            title={tab === "completed" ? "No completed courses yet" : tab === "in-progress" ? "Nothing in progress" : "You haven't enrolled in any courses"}
            description={tab === "completed" ? "Finish every lesson in a course to earn a verified certificate." : "Find a course that fits your goals and start learning today."}
            action={
              <Button asChild>
                <Link href="/courses">Browse courses</Link>
              </Button>
            }
          />
        ) : (
          <Grid>
            {list.map((e) => (
              <EnrollmentCard key={e.courseId} enrollment={e} certificateId={certs.get(e.courseId)} />
            ))}
          </Grid>
        )}
      </div>
    </div>
  );
}

function Grid({ children }: { children: React.ReactNode }) {
  return <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">{children}</div>;
}

export default function MyCoursesPage() {
  return (
    <Suspense>
      <MyCourses />
    </Suspense>
  );
}
