"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { LearningPath } from "@/components/roadmap/LearningPath";
import { GraduationCap, ArrowLeft } from "lucide-react";
import Link from "next/link";
import { useUser } from "@/hooks/useUser";

export default function CourseDetailPage() {
  const routeParams = useParams();
  const id = routeParams?.id as string;
  const { isCollapsed } = useSidebar();
  const { user } = useUser();
  const [course, setCourse] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (id) {
      fetchCourseDetails();
    }
  }, [id]);

  const fetchCourseDetails = async () => {
    try {
      const { data, error } = await supabase
        .from("courses")
        .select("*")
        .eq("id", id)
        .single();
      
      if (error) throw error;
      setCourse(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        {/* Background ambient lighting */}
        <div className="absolute top-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[140px] pointer-events-none" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[140px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative">
          <div className="max-w-6xl mx-auto">
            
            {loading ? (
              <div className="flex justify-center p-20">
                <div className="w-10 h-10 rounded-full border-4 border-primary border-t-transparent animate-spin"></div>
              </div>
            ) : course ? (
              <>
                <Link href="/cursos" className="inline-flex items-center text-sm font-bold text-zinc-400 hover:text-white transition-colors mb-6">
                  <ArrowLeft size={16} className="mr-1" /> Volver al Catálogo
                </Link>

                <div className="mb-8 border-b border-white/10 pb-8">
                  <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/20 text-primary font-bold text-xs uppercase tracking-wider mb-4 border border-primary/30">
                    <GraduationCap size={16} /> <span>Curso Oficial</span>
                  </div>
                  <h1 className="text-3xl lg:text-4xl font-heading font-black text-white mb-4">
                    {course.title}
                  </h1>
                  <p className="text-lg text-zinc-400 max-w-3xl">
                    {course.description}
                  </p>
                </div>

                <div className="mt-8">
                  <h2 className="text-2xl font-bold text-white mb-6">Ruta de Aprendizaje</h2>
                  <LearningPath courseId={id} />
                </div>
              </>
            ) : (
              <div className="text-center py-20">
                <h2 className="text-2xl font-bold text-white mb-2">Curso no encontrado</h2>
                <p className="text-zinc-400">El curso que buscas no existe o fue eliminado.</p>
              </div>
            )}

          </div>
        </main>
      </div>
    </div>
  );
}
