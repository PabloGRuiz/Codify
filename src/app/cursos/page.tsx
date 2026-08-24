"use client";

import { useEffect, useState } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { BookOpen, Star, Users, ChevronRight, GraduationCap, CheckCircle2, Trash2, Lock, ShieldAlert } from "lucide-react";
import Link from "next/link";
import { useUser } from "@/hooks/useUser";
import { useEnrollments } from "@/hooks/useEnrollments";
import { UnenrollModal } from "@/components/dashboard/UnenrollModal";

export default function CatalogPage() {
  const { isCollapsed } = useSidebar();
  const { user, profile, loading: userLoading } = useUser();
  const { completedCourseIds, courseProgressMap } = useEnrollments(user?.id, userLoading);
  
  const [courses, setCourses] = useState<any[]>([]);
  const [enrolledCourseIds, setEnrolledCourseIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [courseToUnenroll, setCourseToUnenroll] = useState<{ id: string; title: string } | null>(null);
  const [isUnenrolling, setIsUnenrolling] = useState(false);

  useEffect(() => {
    fetchCoursesAndEnrollments();
  }, [user]);

  const fetchCoursesAndEnrollments = async () => {
    setLoading(true);
    try {
      // 1. Fetch published courses with prerequisite info
      const { data: coursesData } = await supabase
        .from("courses")
        .select(`
          *,
          modules(count),
          prerequisite_course:prerequisite_course_id(id, title)
        `)
        .eq("status", "published")
        .order("created_at", { ascending: false });

      if (coursesData) {
        setCourses(coursesData);
      }

      // 2. Fetch user enrollments if logged in
      if (user) {
        const { data: enrData } = await supabase
          .from("course_enrollments")
          .select("course_id")
          .eq("user_id", user.id);

        if (enrData) {
          setEnrolledCourseIds(new Set(enrData.map((e) => e.course_id)));
        }
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleEnroll = async (courseId: string) => {
    if (!user) return alert("Inicia sesión para matricularte.");
    try {
      const { error } = await supabase.from("course_enrollments").insert({
        user_id: user.id,
        course_id: courseId
      });
      if (error && error.code !== '23505') {
        throw error;
      }
      
      setEnrolledCourseIds((prev) => new Set([...prev, courseId]));
      window.location.href = `/cursos/${courseId}`;
    } catch (err) {
      console.error(err);
      alert("Error al matricularte. Intenta de nuevo.");
    }
  };

  const handleConfirmUnenroll = async () => {
    if (!courseToUnenroll || !user) return;
    setIsUnenrolling(true);
    try {
      const { error } = await supabase
        .from("course_enrollments")
        .delete()
        .eq("user_id", user.id)
        .eq("course_id", courseToUnenroll.id);

      if (error) throw error;

      setEnrolledCourseIds((prev) => {
        const next = new Set(prev);
        next.delete(courseToUnenroll.id);
        return next;
      });
      setCourseToUnenroll(null);
    } catch (err) {
      console.error("Error al desmatricularse:", err);
      alert("Error al abandonar el curso.");
    } finally {
      setIsUnenrolling(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        {/* Ambient background */}
        <div className="absolute top-0 right-0 w-[50%] h-[50%] rounded-full bg-indigo-500/10 blur-[120px] pointer-events-none" />
        <Topbar />
        
        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative">
          <div className="max-w-6xl mx-auto">
            
            <div className="text-center py-12 mb-8">
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-indigo-500/20 text-indigo-400 font-bold text-xs uppercase tracking-wider mb-6 border border-indigo-500/30">
                <GraduationCap size={16} /> <span>Codify Academy</span>
              </div>
              <h1 className="text-4xl md:text-5xl font-heading font-black text-white mb-6">
                Explora el Catálogo de <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-purple-400">Cursos</span>
              </h1>
              <p className="text-lg text-zinc-400 max-w-2xl mx-auto">
                Elige tu próximo camino de aprendizaje. Domina nuevas tecnologías a tu propio ritmo con nuestra currícula interactiva.
              </p>
            </div>

            {loading ? (
              <div className="flex justify-center p-20">
                <div className="w-10 h-10 rounded-full border-4 border-indigo-500 border-t-transparent animate-spin"></div>
              </div>
            ) : courses.length === 0 ? (
              <div className="text-center py-20 bg-white/5 rounded-2xl border border-white/10">
                <BookOpen size={48} className="mx-auto text-zinc-600 mb-4" />
                <h3 className="text-xl font-bold text-white mb-2">Aún no hay cursos disponibles</h3>
                <p className="text-zinc-400">Vuelve pronto para ver el nuevo contenido que estamos preparando.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {courses.map((course) => {
                  const isEnrolled = enrolledCourseIds.has(course.id);
                  const prereqId = course.prerequisite_course_id;
                  const prereqCompleted = !prereqId || completedCourseIds.has(prereqId);
                  const userLevel = profile?.level || Math.floor((profile?.xp || 0) / 100) + 1;
                  const levelMet = !course.min_level || userLevel >= course.min_level;
                  const isLocked = !isEnrolled && (!prereqCompleted || !levelMet);

                  const typeTag = course.tags?.find((t: string) => {
                    const lower = t.toLowerCase();
                    return lower === 'teórico' || lower === 'teorico' || lower === 'práctico' || lower === 'practico';
                  });
                  const otherTags = (course.tags || []).filter((t: string) => t !== typeTag).slice(0, 3);
                  const isTeorico = typeTag?.toLowerCase().includes('teor');

                  return (
                    <Card 
                      key={course.id} 
                      className={`p-6 glass-panel transition-all flex flex-col hover:-translate-y-1 hover:shadow-2xl cursor-default group relative ${
                        isLocked 
                          ? "border-amber-500/20 hover:border-amber-500/40 bg-zinc-950/60 opacity-90" 
                          : "border-white/10 hover:border-indigo-500/50 hover:shadow-indigo-500/10"
                      }`}
                    >
                      {/* Top Header: Icon + Status/Type Badges */}
                      <div className="flex items-center justify-between mb-4">
                        <Link href={`/cursos/${course.id}/preview`} className="group-hover:scale-105 transition-transform" title="Ver ficha del curso">
                          <div className={`w-12 h-12 rounded-xl flex items-center justify-center shrink-0 ${
                            isLocked
                              ? "bg-amber-500/15 text-amber-400 border border-amber-500/30"
                              : isTeorico 
                              ? "bg-emerald-500/20 text-emerald-400" 
                              : "bg-indigo-500/20 text-indigo-400"
                          }`}>
                            {isLocked ? <Lock size={22} /> : <BookOpen size={24} />}
                          </div>
                        </Link>
                        <div className="flex items-center gap-2 flex-wrap justify-end">
                          {isEnrolled && (
                            <span className="text-[10px] uppercase tracking-wider font-extrabold px-2.5 py-1 rounded-full border bg-emerald-500/20 text-emerald-400 border-emerald-500/30 flex items-center gap-1">
                              <CheckCircle2 size={12} /> Activo
                            </span>
                          )}
                          {isLocked && (
                            <span className="text-[10px] uppercase tracking-wider font-extrabold px-2.5 py-1 rounded-full border bg-amber-500/15 text-amber-400 border-amber-500/30 flex items-center gap-1">
                              <Lock size={12} /> Bloqueado
                            </span>
                          )}
                          {typeTag && (
                            <span className={`text-[10px] uppercase tracking-wider font-extrabold px-2.5 py-1 rounded-full border shadow-sm ${
                              isTeorico
                                ? "bg-emerald-500/20 text-emerald-300 border-emerald-500/30 shadow-[0_0_10px_rgba(16,185,129,0.2)]"
                                : "bg-indigo-500/20 text-indigo-300 border-indigo-500/30 shadow-[0_0_10px_rgba(99,102,241,0.2)]"
                            }`}>
                              {typeTag}
                            </span>
                          )}
                        </div>
                      </div>
                      
                      {/* Title & Description with Link to Preview */}
                      <Link href={`/cursos/${course.id}/preview`} className="block group/title">
                        <h3 className="text-xl font-bold text-white mb-2 group-hover/title:text-indigo-400 transition-colors line-clamp-1 flex items-center justify-between">
                          <span>{course.title}</span>
                          <span className="text-xs text-zinc-500 font-normal group-hover/title:text-indigo-300 opacity-0 group-hover:opacity-100 transition-opacity">
                            Ficha →
                          </span>
                        </h3>
                      </Link>
                      
                      <Link href={`/cursos/${course.id}/preview`} className="block flex-1">
                        <p className="text-sm text-zinc-400 mb-4 line-clamp-3 leading-relaxed hover:text-zinc-300 transition-colors">
                          {course.description}
                        </p>
                      </Link>
                      
                      {/* Prerequisites Banner if locked */}
                      {isLocked && (
                        <div className="mb-4 p-3 rounded-xl bg-amber-500/10 border border-amber-500/20 text-xs text-amber-300 space-y-1">
                          {!prereqCompleted && course.prerequisite_course && (
                            <div className="flex items-center gap-1.5">
                              <Lock size={13} className="shrink-0 text-amber-400" />
                              <span>
                                Requiere completar: <strong>{course.prerequisite_course.title}</strong> ({courseProgressMap[prereqId!] || 0}%)
                              </span>
                            </div>
                          )}
                          {!levelMet && (
                            <div className="flex items-center gap-1.5">
                              <ShieldAlert size={13} className="shrink-0 text-amber-400" />
                              <span>Requiere alcanzar el <strong>Nivel {course.min_level}</strong> (Tu nivel: {userLevel})</span>
                            </div>
                          )}
                        </div>
                      )}

                      {/* Topic Tags */}
                      {otherTags.length > 0 && (
                        <div className="flex flex-wrap gap-1.5 mb-5">
                          {otherTags.map((tag: string) => (
                            <span key={tag} className="text-[10px] font-semibold px-2 py-0.5 rounded-md bg-white/5 text-zinc-400 border border-white/10">
                              #{tag}
                            </span>
                          ))}
                        </div>
                      )}

                      {/* Footer info & action */}
                      <div className="flex items-center justify-between pt-4 border-t border-white/10 mt-auto gap-2">
                        <div className="flex items-center gap-2 text-xs text-zinc-400 font-semibold">
                          <span className="bg-white/5 px-2 py-1 rounded border border-white/5">{course.modules?.[0]?.count || 0} Módulos</span>
                          <Link 
                            href={`/cursos/${course.id}/preview`}
                            className="text-indigo-400 hover:text-indigo-300 font-medium hover:underline flex items-center gap-0.5"
                          >
                            Ver Resumen
                          </Link>
                        </div>
                        
                        <div className="flex items-center gap-2">
                          {isEnrolled ? (
                            <>
                              <button
                                onClick={() => setCourseToUnenroll({ id: course.id, title: course.title })}
                                title="Abandonar curso"
                                className="p-2 text-zinc-500 hover:text-red-400 hover:bg-red-500/10 rounded-lg transition-colors"
                              >
                                <Trash2 size={16} />
                              </button>
                              <Link href={`/cursos/${course.id}`}>
                                <Button className="bg-emerald-600 hover:bg-emerald-500 text-white shadow-lg shadow-emerald-500/20 py-1.5 px-4 h-auto text-sm">
                                  Continuar <ChevronRight size={16} className="ml-1" />
                                </Button>
                              </Link>
                            </>
                          ) : isLocked ? (
                            <Link href={prereqId ? `/cursos/${prereqId}` : `/cursos/${course.id}/preview`}>
                              <Button variant="secondary" className="border-amber-500/30 text-amber-300 hover:bg-amber-500/10 py-1.5 px-3 h-auto text-xs">
                                <Lock size={14} className="mr-1 text-amber-400" /> Requisitos
                              </Button>
                            </Link>
                          ) : (
                            <Button onClick={() => handleEnroll(course.id)} className="bg-indigo-600 hover:bg-indigo-500 text-white shadow-lg shadow-indigo-500/20 py-1.5 px-4 h-auto text-sm">
                              Iniciar <ChevronRight size={16} className="ml-1" />
                            </Button>
                          )}
                        </div>
                      </div>
                    </Card>
                  );
                })}
              </div>
            )}

          </div>
        </main>
      </div>

      {/* Unenroll confirmation modal */}
      <UnenrollModal
        isOpen={Boolean(courseToUnenroll)}
        onClose={() => setCourseToUnenroll(null)}
        onConfirm={handleConfirmUnenroll}
        courseTitle={courseToUnenroll?.title || ""}
        isProcessing={isUnenrolling}
      />
    </div>
  );
}
