import { useState } from "react";
import Link from "next/link";
import { Card } from "@/components/ui/Card";
import { Star, ChevronRight, Code2, Zap, Trash2, X } from "lucide-react";
import { UnenrollModal } from "./UnenrollModal";

interface RoadmapViewProps {
  loadingEnrollments: boolean;
  enrollments: any[];
  onUnenroll?: (courseId: string) => Promise<{ success: boolean; error?: any } | void>;
}

export function RoadmapView({ loadingEnrollments, enrollments, onUnenroll }: RoadmapViewProps) {
  const [courseToUnenroll, setCourseToUnenroll] = useState<{ id: string; title: string } | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);

  const handleConfirmUnenroll = async () => {
    if (!courseToUnenroll || !onUnenroll) return;
    setIsProcessing(true);
    try {
      await onUnenroll(courseToUnenroll.id);
      setCourseToUnenroll(null);
    } catch (err) {
      console.error("Error un-enrolling course:", err);
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="lg:col-span-2 space-y-8">
      {/* User Active Courses */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
            <Star className="text-primary fill-primary/20" size={24} /> Mis Cursos Activos
          </h3>
          <Link href="/cursos" className="text-sm font-bold text-primary hover:text-accent transition-colors flex items-center">
            Explorar más <ChevronRight size={16} />
          </Link>
        </div>
        
        {loadingEnrollments ? (
          <div className="h-40 glass rounded-2xl flex items-center justify-center border border-white/5">
            <div className="w-8 h-8 rounded-full border-2 border-primary border-t-transparent animate-spin"></div>
          </div>
        ) : enrollments.length === 0 ? (
          <div className="p-8 glass rounded-2xl border border-white/5 text-center space-y-3">
            <p className="text-zinc-400 text-sm">No tienes ningún curso activo en este momento.</p>
            <Link
              href="/cursos"
              className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-primary hover:bg-primary-hover text-white text-sm font-bold shadow-lg shadow-primary/20 transition-all"
            >
              Explorar Catálogo de Cursos <ChevronRight size={16} />
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {enrollments.map((enr) => {
              const course = enr.courses;
              if (!course) return null;
              const courseId = enr.course_id || course.id;
              const progress = enr.calculated_progress || 0;
              const typeTag = course.tags?.find((t: string) => {
                const lower = t.toLowerCase();
                return lower === 'teórico' || lower === 'teorico' || lower === 'práctico' || lower === 'practico';
              });
              const isTeorico = typeTag?.toLowerCase().includes('teor');

              return (
                <div key={courseId} className="relative group/wrapper h-full">
                  <Link href={`/cursos/${courseId}`} className="block h-full">
                    <Card className="p-5 glass hover:border-primary/50 transition-all cursor-pointer hover:-translate-y-1 h-full flex flex-col group relative">
                      <div className="flex items-start justify-between mb-2 pr-7">
                        <h4 className="font-bold text-white group-hover:text-primary transition-colors line-clamp-1 flex-1 pr-2">
                          {course.title}
                        </h4>
                        {typeTag && (
                          <span className={`text-[9px] uppercase font-extrabold px-2 py-0.5 rounded-md border shrink-0 ${
                            isTeorico
                              ? "bg-emerald-500/20 text-emerald-400 border-emerald-500/30"
                              : "bg-indigo-500/20 text-indigo-400 border-indigo-500/30"
                          }`}>
                            {typeTag}
                          </span>
                        )}
                      </div>
                      <p className="text-xs text-zinc-400 mb-4 line-clamp-2 flex-1">{course.description}</p>
                      <div className="mt-auto space-y-1.5">
                        <div className="flex justify-between text-xs font-semibold">
                          <span className="text-zinc-500">{enr.total_modules_count || 0} Módulos</span>
                          <span className={progress > 0 ? "text-emerald-400 font-bold" : "text-zinc-400 font-bold"}>
                            {progress}% Completado
                          </span>
                        </div>
                        <div className="h-1.5 w-full bg-black/50 rounded-full overflow-hidden border border-white/5">
                          <div
                            className={`h-full transition-all duration-1000 ${
                              progress === 100
                                ? "bg-emerald-500"
                                : "bg-gradient-to-r from-primary to-accent"
                            }`}
                            style={{ width: `${progress}%` }}
                          />
                        </div>
                      </div>
                    </Card>
                  </Link>

                  {/* Drop / Unenroll Course Action Button */}
                  {onUnenroll && (
                    <button
                      type="button"
                      onClick={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        setCourseToUnenroll({ id: courseId, title: course.title });
                      }}
                      title="Abandonar curso"
                      className="absolute top-3.5 right-3.5 p-1.5 text-zinc-500 hover:text-red-400 hover:bg-red-500/10 rounded-lg transition-all z-20 opacity-70 hover:opacity-100 group-hover/wrapper:opacity-100"
                    >
                      <Trash2 size={15} />
                    </button>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Quick Sandboxes */}
      <div>
        <h3 className="text-xl font-heading font-bold text-white mb-4">Entornos de Práctica</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Link href="/web">
            <Card className="p-6 hover:border-primary/50 transition-all cursor-pointer group glass h-full hover:-translate-y-1 duration-200">
              <div className="w-12 h-12 rounded-xl bg-blue-500/20 text-blue-400 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <Code2 size={24} />
              </div>
              <h4 className="font-bold text-lg mb-1 group-hover:text-primary transition-colors">Prototipado Web</h4>
              <p className="text-xs text-zinc-400">Sandbox HTML5, CSS3 y JavaScript con vista previa interactiva.</p>
            </Card>
          </Link>
          
          <Link href="/ide">
            <Card className="p-6 hover:border-accent/50 transition-all cursor-pointer group glass h-full hover:-translate-y-1 duration-200">
              <div className="w-12 h-12 rounded-xl bg-yellow-500/20 text-yellow-400 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <Zap size={24} />
              </div>
              <h4 className="font-bold text-lg mb-1 group-hover:text-accent transition-colors">Centro de Desafíos</h4>
              <p className="text-xs text-zinc-400">Banco de ejercicios de lógica, algoritmos y tests unitarios.</p>
            </Card>
          </Link>
        </div>
      </div>

      {/* Unenroll Confirmation Modal */}
      <UnenrollModal
        isOpen={Boolean(courseToUnenroll)}
        onClose={() => setCourseToUnenroll(null)}
        onConfirm={handleConfirmUnenroll}
        courseTitle={courseToUnenroll?.title || ""}
        isProcessing={isProcessing}
      />
    </div>
  );
}
