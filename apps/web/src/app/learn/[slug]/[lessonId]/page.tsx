"use client";

import { Suspense, use } from "react";
import { LessonView } from "@/components/learn/lesson-view";

export default function LessonPage({ params }: { params: Promise<{ slug: string; lessonId: string }> }) {
  const { lessonId } = use(params);
  return (
    <Suspense>
      <LessonView key={lessonId} lessonId={lessonId} />
    </Suspense>
  );
}
