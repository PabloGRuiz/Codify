import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import type { Course, Module, Challenge } from "@/types";

export function useEnrollments(userId: string | undefined, userLoading: boolean) {
  const [enrollments, setEnrollments] = useState<any[]>([]);
  const [certifiedCourseIds, setCertifiedCourseIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (userLoading) return;
    
    if (!userId) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setLoading(false);
      return;
    }

    const fetchEnrollments = async () => {
      try {
        setLoading(true);
        // 1. Fetch user enrollments with courses, modules and challenges
        const { data: enrData, error: enrError } = await supabase
          .from("course_enrollments")
          .select("*, courses(*, modules(id, title, challenges(id)))")
          .eq("user_id", userId);

        // Fetch User Certifications
        const { data: certsData } = await supabase
          .from("user_certifications")
          .select("certification:certifications(course_id)")
          .eq("user_id", userId);

        if (certsData) {
          const certCourseIds = certsData
            .map((c: any) => c.certification?.course_id)
            .filter(Boolean);
          setCertifiedCourseIds(new Set(certCourseIds));
        }

        if (enrError) throw enrError;

        if (enrData && enrData.length > 0) {
          // 2. Fetch all completed challenges for this user
          const { data: userProg } = await supabase
            .from("user_progress")
            .select("challenge_id")
            .eq("user_id", userId)
            .eq("status", "completed");

          const completedSet = new Set((userProg || []).map((p) => p.challenge_id));

          // 3. Compute real progress for each course
          const formatted = enrData.map((enr) => {
            const course = enr.courses;
            let totalChallenges = 0;
            let completedChallenges = 0;

            if (course?.modules && Array.isArray(course.modules)) {
              course.modules.forEach((mod: any) => {
                if (mod.challenges && Array.isArray(mod.challenges)) {
                  totalChallenges += mod.challenges.length;
                  mod.challenges.forEach((ch: any) => {
                    if (completedSet.has(ch.id)) {
                      completedChallenges++;
                    }
                  });
                }
              });
            }

            const calculatedPercent =
              totalChallenges > 0
                ? Math.round((completedChallenges / totalChallenges) * 100)
                : 0;

            return {
              ...enr,
              calculated_progress: calculatedPercent,
              total_modules_count: course?.modules?.length || 0,
              completed_challenges_count: completedChallenges,
              total_challenges_count: totalChallenges,
            };
          });

          setEnrollments(formatted);
        } else {
          setEnrollments([]);
        }
      } catch (err) {
        console.error("Error fetching enrollments:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchEnrollments();
  }, [userId, userLoading]);

  const unenrollCourse = async (courseId: string) => {
    if (!userId) return { success: false, error: "No user logged in" };

    try {
      const { error } = await supabase
        .from("course_enrollments")
        .delete()
        .eq("user_id", userId)
        .eq("course_id", courseId);

      if (error) throw error;

      // Optimistically update local enrollments state
      setEnrollments((prev) => prev.filter((enr) => (enr.course_id || enr.courses?.id) !== courseId));
      return { success: true };
    } catch (err: unknown) {
      console.error("Error al desmatricularse del curso:", err);
      return { success: false, error: err };
    }
  };

  const courseProgressMap = enrollments.reduce((acc, curr) => {
    const courseId = curr.course_id || curr.courses?.id;
    if (courseId) {
      acc[courseId] = curr.calculated_progress || 0;
    }
    return acc;
  }, {} as Record<string, number>);

  return {
    enrollments,
    loading,
    unenrollCourse,
    completedCourseIds: new Set(
      enrollments
        .filter((e) => e.calculated_progress === 100)
        .map((e) => e.course_id || e.courses?.id)
        .filter(Boolean)
    ),
    courseProgressMap,
    certifiedCourseIds
  };
}
