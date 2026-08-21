"use client";

import { useEffect, useState } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { BookOpen, Star, Users, ChevronRight, GraduationCap } from "lucide-react";
import Link from "next/link";
import { useUser } from "@/hooks/useUser";

export default function CatalogPage() {
  const { isCollapsed } = useSidebar();
  const { user } = useUser();
  const [courses, setCourses] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    setLoading(true);
    try {
      const { data } = await supabase
        .from("courses")
        .select(`
          *,
          modules(count)
        `)
        .eq("status", "published")
        .order("created_at", { ascending: false });

      if (data) {
        setCourses(data);
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
      // Create enrollment
      const { error } = await supabase.from("course_enrollments").insert({
        user_id: user.id,
        course_id: courseId
      });
      if (error && error.code !== '23505') { // 23505 is unique violation, meaning already enrolled
        throw error;
      }
      
      // Redirect to course detail (roadmap)
      window.location.href = `/cursos/${courseId}`;
    } catch (err) {
      console.error(err);
      alert("Error al matricularte. Intenta de nuevo.");
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
                  const typeTag = course.tags?.find((t: string) => {
                    const lower = t.toLowerCase();
                    return lower === 'teórico' || lower === 'teorico' || lower === 'práctico' || lower === 'practico';
                  });
                  const otherTags = (course.tags || []).filter((t: string) => t !== typeTag).slice(0, 3);
                  const isTeorico = typeTag?.toLowerCase().includes('teor');

                  return (
                    <Card key={course.id} className="p-6 glass-panel border-white/10 hover:border-indigo-500/50 transition-all flex flex-col hover:-translate-y-1 hover:shadow-2xl hover:shadow-indigo-500/10 cursor-default group">
                      {/* Top Header: Icon + Primary Type Badge */}
                      <div className="flex items-center justify-between mb-4">
                        <div className={`w-12 h-12 rounded-xl flex items-center justify-center shrink-0 ${isTeorico ? 'bg-emerald-500/20 text-emerald-400' : 'bg-indigo-500/20 text-indigo-400'}`}>
                          <BookOpen size={24} />
                        </div>
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
                      
                      {/* Title & Description */}
                      <h3 className="text-xl font-bold text-white mb-2 group-hover:text-indigo-400 transition-colors line-clamp-1">{course.title}</h3>
                      <p className="text-sm text-zinc-400 mb-4 line-clamp-3 leading-relaxed flex-1">{course.description}</p>
                      
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
                      <div className="flex items-center justify-between pt-4 border-t border-white/10 mt-auto">
                        <div className="flex items-center gap-2 text-xs text-zinc-400 font-semibold">
                          <span className="bg-white/5 px-2 py-1 rounded border border-white/5">{course.modules?.[0]?.count || 0} Módulos</span>
                        </div>
                        <Button onClick={() => handleEnroll(course.id)} className="bg-indigo-600 hover:bg-indigo-500 text-white shadow-lg shadow-indigo-500/20 py-1.5 px-4 h-auto text-sm">
                          Iniciar <ChevronRight size={16} className="ml-1" />
                        </Button>
                      </div>
                    </Card>
                  );
                })}
              </div>
            )}

          </div>
        </main>
      </div>
    </div>
  );
}
