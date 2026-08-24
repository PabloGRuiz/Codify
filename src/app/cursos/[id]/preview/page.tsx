"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { useEnrollments } from "@/hooks/useEnrollments";
import Link from "next/link";
import ReactMarkdown from "react-markdown";
import { 
  ArrowLeft, 
  BookOpen, 
  GraduationCap, 
  CheckCircle2, 
  Zap, 
  Clock, 
  Layers, 
  Trophy, 
  Play, 
  ChevronRight,
  ShieldCheck,
  Sparkles,
  Award,
  Code2,
  FileQuestion,
  Lock,
  ShieldAlert
} from "lucide-react";

export default function CoursePreviewPage() {
  const routeParams = useParams();
  const id = routeParams?.id as string;
  const router = useRouter();
  const { isCollapsed } = useSidebar();
  const { user, profile, loading: userLoading } = useUser();
  const { completedCourseIds, courseProgressMap } = useEnrollments(user?.id, userLoading);

  const [course, setCourse] = useState<any>(null);
  const [modules, setModules] = useState<any[]>([]);
  const [isEnrolled, setIsEnrolled] = useState(false);
  const [loading, setLoading] = useState(true);
  const [enrolling, setEnrolling] = useState(false);

  useEffect(() => {
    if (id) {
      fetchCourseDetails();
    }
  }, [id, user]);

  const fetchCourseDetails = async () => {
    setLoading(true);
    try {
      // 1. Fetch course details with prerequisite course info
      const { data: courseData, error: courseErr } = await supabase
        .from("courses")
        .select(`
          *,
          prerequisite_course:prerequisite_course_id(id, title)
        `)
        .eq("id", id)
        .single();

      if (courseErr) throw courseErr;
      setCourse(courseData);

      // 2. Fetch modules with challenges
      const { data: modulesData, error: modErr } = await supabase
        .from("modules")
        .select(`
          *,
          challenges(*)
        `)
        .eq("course_id", id)
        .order("created_at", { ascending: true });

      if (!modErr && modulesData) {
        // Sort challenges by order_index inside each module
        const sortedModules = modulesData.map((m) => ({
          ...m,
          challenges: (m.challenges || []).sort(
            (a: any, b: any) => (a.order_index || 0) - (b.order_index || 0)
          ),
        }));
        setModules(sortedModules);
      }

      // 3. Check if user is enrolled
      if (user) {
        const { data: enrData } = await supabase
          .from("course_enrollments")
          .select("id")
          .eq("user_id", user.id)
          .eq("course_id", id)
          .maybeSingle();

        setIsEnrolled(Boolean(enrData));
      }
    } catch (err) {
      console.error("Error fetching course preview:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleEnrollAndStart = async () => {
    if (!user) {
      alert("Inicia sesión para matricularte en este curso.");
      router.push("/auth");
      return;
    }

    if (isEnrolled) {
      router.push(`/cursos/${id}`);
      return;
    }

    setEnrolling(true);
    try {
      const { error } = await supabase.from("course_enrollments").insert({
        user_id: user.id,
        course_id: id,
      });

      if (error && error.code !== "23505") {
        throw error;
      }

      setIsEnrolled(true);
      router.push(`/cursos/${id}`);
    } catch (err) {
      console.error("Error al matricularse:", err);
      alert("No se pudo completar la matrícula. Inténtalo de nuevo.");
    } finally {
      setEnrolling(false);
    }
  };

  const totalChallenges = modules.reduce(
    (acc, m) => acc + (m.challenges?.length || 0),
    0
  );

  const totalXp = modules.reduce(
    (acc, m) =>
      acc +
      (m.challenges || []).reduce(
        (sub: number, c: any) => sub + (c.xp_reward || 0),
        0
      ),
    0
  );

  const typeTag = course?.tags?.find((t: string) => {
    const lower = t.toLowerCase();
    return (
      lower === "teórico" ||
      lower === "teorico" ||
      lower === "práctico" ||
      lower === "practico"
    );
  });
  const otherTags = (course?.tags || []).filter((t: string) => t !== typeTag);
  const isTeorico = typeTag?.toLowerCase().includes("teor");

  const prereqId = course?.prerequisite_course_id;
  const prereqCompleted = !prereqId || completedCourseIds.has(prereqId);
  const userLevel = profile?.level || Math.floor((profile?.xp || 0) / 100) + 1;
  const levelMet = !course?.min_level || userLevel >= course.min_level;
  const isLocked = !isEnrolled && (!prereqCompleted || !levelMet);

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div
        className={`${
          isCollapsed ? "md:ml-20" : "md:ml-64"
        } ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}
      >
        {/* Ambient background glows */}
        <div className="absolute top-0 right-0 w-[50%] h-[50%] rounded-full bg-indigo-500/10 blur-[130px] pointer-events-none" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-purple-500/10 blur-[130px] pointer-events-none" />

        <Topbar />

        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative">
          <div className="max-w-6xl mx-auto space-y-8">
            {/* Breadcrumb Back Link */}
            <Link
              href="/cursos"
              className="inline-flex items-center text-sm font-bold text-zinc-400 hover:text-white transition-colors"
            >
              <ArrowLeft size={16} className="mr-1.5" /> Volver al Catálogo de Cursos
            </Link>

            {loading ? (
              <div className="flex justify-center p-20">
                <div className="w-10 h-10 rounded-full border-4 border-indigo-500 border-t-transparent animate-spin"></div>
              </div>
            ) : course ? (
              <>
                {/* Hero Header Card */}
                <div className="bg-gradient-to-r from-indigo-950/40 via-purple-950/30 to-zinc-900 border border-indigo-500/20 rounded-3xl p-6 sm:p-10 relative overflow-hidden shadow-2xl">
                  <div className="absolute right-[-20px] top-[-20px] w-64 h-64 bg-indigo-500/10 blur-[80px] rounded-full pointer-events-none" />

                  <div className="relative z-10 space-y-4">
                    {/* Badges */}
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-indigo-500/20 text-indigo-400 font-bold text-xs uppercase tracking-wider border border-indigo-500/30">
                        <GraduationCap size={14} /> <span>Codify Academy</span>
                      </span>

                      {typeTag && (
                        <span
                          className={`text-xs uppercase tracking-wider font-extrabold px-3 py-1 rounded-full border shadow-sm ${
                            isTeorico
                              ? "bg-emerald-500/20 text-emerald-300 border-emerald-500/30"
                              : "bg-indigo-500/20 text-indigo-300 border-indigo-500/30"
                          }`}
                        >
                          {typeTag}
                        </span>
                      )}

                      {isEnrolled && (
                        <span className="text-xs uppercase tracking-wider font-extrabold px-3 py-1 rounded-full border bg-emerald-500/20 text-emerald-400 border-emerald-500/30 flex items-center gap-1">
                          <CheckCircle2 size={13} /> Curso Activo
                        </span>
                      )}

                      {isLocked && (
                        <span className="text-xs uppercase tracking-wider font-extrabold px-3 py-1 rounded-full border bg-amber-500/20 text-amber-400 border-amber-500/30 flex items-center gap-1">
                          <Lock size={13} /> Bloqueado por Prerrequisitos
                        </span>
                      )}
                    </div>

                    {/* Title */}
                    <h1 className="text-3xl sm:text-5xl font-heading font-black text-white leading-tight">
                      {course.title}
                    </h1>

                    {/* Description */}
                    <p className="text-base sm:text-lg text-zinc-300 max-w-3xl leading-relaxed">
                      {course.description}
                    </p>

                    {/* Tags */}
                    {otherTags.length > 0 && (
                      <div className="flex flex-wrap gap-2 pt-2">
                        {otherTags.map((tag: string) => (
                          <span
                            key={tag}
                            className="text-xs font-semibold px-2.5 py-1 rounded-md bg-white/5 text-zinc-300 border border-white/10"
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>
                    )}
                  </div>
                </div>

                {/* Main Content Grid: Summary & Syllabus (Left) + CTA Sidebar (Right) */}
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                  
                  {/* Left Column: Summary & Detailed Modules Syllabus */}
                  <div className="lg:col-span-2 space-y-8">
                    
                    {/* 1. Resumen / Ficha Técnica del Curso */}
                    <Card className="p-6 sm:p-8 glass-panel border-white/10 space-y-6">
                      <div className="flex items-center gap-2 text-indigo-400 font-bold text-xs uppercase tracking-wider border-b border-white/10 pb-4">
                        <Sparkles size={16} />
                        <span>Resumen & Objetivos de Aprendizaje</span>
                      </div>

                      {course.summary ? (
                        <div className="prose prose-invert prose-indigo max-w-none text-zinc-300 space-y-4 font-sans leading-relaxed">
                          <ReactMarkdown
                            components={{
                              h2: ({ children }) => (
                                <h2 className="text-xl sm:text-2xl font-heading font-bold text-white mt-6 mb-3 flex items-center gap-2">
                                  {children}
                                </h2>
                              ),
                              h3: ({ children }) => (
                                <h3 className="text-lg font-heading font-bold text-indigo-300 mt-4 mb-2">
                                  {children}
                                </h3>
                              ),
                              p: ({ children }) => (
                                <p className="text-sm sm:text-base text-zinc-300 leading-relaxed mb-3">
                                  {children}
                                </p>
                              ),
                              ul: ({ children }) => (
                                <ul className="list-disc pl-5 space-y-1.5 text-sm sm:text-base text-zinc-300 mb-4">
                                  {children}
                                </ul>
                              ),
                              li: ({ children }) => <li>{children}</li>,
                              strong: ({ children }) => (
                                <strong className="text-white font-semibold">
                                  {children}
                                </strong>
                              ),
                            }}
                          >
                            {course.summary}
                          </ReactMarkdown>
                        </div>
                      ) : (
                        <div className="space-y-4 text-zinc-300">
                          <p className="text-base leading-relaxed">
                            {course.description}
                          </p>
                          <div className="p-4 rounded-xl bg-white/5 border border-white/10 text-sm text-zinc-400">
                            💡 Este curso incluye micro-lecciones interactivas, autoevaluaciones pedagógicas y retos de programación con retroalimentación instantánea en el navegador.
                          </div>
                        </div>
                      )}
                    </Card>

                    {/* 2. Temario / Estructura por Módulos */}
                    <div className="space-y-4">
                      <div className="flex items-center justify-between">
                        <h3 className="text-xl sm:text-2xl font-heading font-bold text-white flex items-center gap-2">
                          <Layers size={22} className="text-indigo-400" />
                          <span>Estructura del Curso ({modules.length} Módulos)</span>
                        </h3>
                        <span className="text-xs text-zinc-400 font-mono">
                          {totalChallenges} Retos en total
                        </span>
                      </div>

                      {modules.length === 0 ? (
                        <Card className="p-8 text-center text-zinc-400 glass">
                          <BookOpen size={36} className="mx-auto text-zinc-600 mb-2" />
                          <p>Los módulos de este curso se están publicando.</p>
                        </Card>
                      ) : (
                        <div className="space-y-4">
                          {modules.map((mod, modIdx) => (
                            <Card
                              key={mod.id}
                              className="p-5 sm:p-6 glass-panel border-white/10 hover:border-indigo-500/30 transition-all space-y-4"
                            >
                              {/* Module Header */}
                              <div className="flex items-start justify-between gap-4">
                                <div className="space-y-1">
                                  <div className="flex items-center gap-2">
                                    <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-indigo-500/20 text-indigo-300 border border-indigo-500/30">
                                      Módulo {modIdx + 1}
                                    </span>
                                    {mod.difficulty_level && (
                                      <span className="text-[10px] text-zinc-400 font-mono">
                                        Nivel {mod.difficulty_level}
                                      </span>
                                    )}
                                  </div>
                                  <h4 className="text-lg font-heading font-bold text-white">
                                    {mod.title}
                                  </h4>
                                  {mod.description && (
                                    <p className="text-xs text-zinc-400 line-clamp-2">
                                      {mod.description}
                                    </p>
                                  )}
                                </div>
                                <span className="text-xs font-bold text-zinc-400 font-mono bg-white/5 px-2.5 py-1 rounded-lg shrink-0">
                                  {mod.challenges?.length || 0} lecciones
                                </span>
                              </div>

                              {/* Challenge Nodes List inside Module */}
                              <div className="space-y-2 pt-2 border-t border-white/5">
                                {(mod.challenges || []).map((ch: any, chIdx: number) => {
                                  const isQuiz = ch.challenge_type === "quiz";
                                  const isWeb = ch.challenge_type === "web";

                                  return (
                                    <div
                                      key={ch.id}
                                      className="flex items-center justify-between p-2.5 rounded-xl bg-black/40 border border-white/5 text-xs text-zinc-300 hover:border-white/20 transition-colors"
                                    >
                                      <div className="flex items-center gap-2.5 min-w-0 pr-2">
                                        <div className="w-6 h-6 rounded-lg bg-white/5 text-zinc-400 flex items-center justify-center font-mono font-bold text-[11px] shrink-0">
                                          {ch.order_index || chIdx + 1}
                                        </div>
                                        <span className="truncate font-medium text-white">
                                          {ch.title}
                                        </span>
                                      </div>

                                      <div className="flex items-center gap-2 shrink-0">
                                        <span className={`text-[10px] font-semibold px-2 py-0.5 rounded border ${
                                          isQuiz
                                            ? "bg-purple-500/10 text-purple-300 border-purple-500/20"
                                            : isWeb
                                            ? "bg-blue-500/10 text-blue-300 border-blue-500/20"
                                            : "bg-emerald-500/10 text-emerald-300 border-emerald-500/20"
                                        }`}>
                                          {isQuiz ? "Cuestionario" : isWeb ? "Práctica Web" : "Código"}
                                        </span>
                                        {ch.xp_reward && (
                                          <span className="text-primary font-mono font-bold">
                                            +{ch.xp_reward} XP
                                          </span>
                                        )}
                                      </div>
                                    </div>
                                  );
                                })}
                              </div>
                            </Card>
                          ))}
                        </div>
                      )}
                    </div>

                  </div>

                  {/* Right Column: Enrollment Card & Meta Details */}
                  <div className="space-y-6 lg:sticky lg:top-8">
                    
                    {/* Action Enrollment Card */}
                    <Card className={`p-6 sm:p-8 glass-panel space-y-6 shadow-2xl relative overflow-hidden ${
                      isLocked ? "border-t-4 border-t-amber-500" : "border-t-4 border-t-indigo-500"
                    }`}>
                      <div className="space-y-2">
                        <span className="text-xs text-zinc-400 font-semibold uppercase tracking-wider">
                          Estado de Matrícula
                        </span>
                        <div className="flex items-center gap-2">
                          <div className={`w-3 h-3 rounded-full ${
                            isEnrolled 
                              ? "bg-emerald-400 animate-ping" 
                              : isLocked 
                              ? "bg-amber-400" 
                              : "bg-indigo-400"
                          }`} />
                          <span className="text-lg font-bold text-white">
                            {isEnrolled 
                              ? "Curso en tu lista activa" 
                              : isLocked 
                              ? "Curso Bloqueado" 
                              : "Disponible para iniciar"}
                          </span>
                        </div>
                      </div>

                      {/* Locked Prerequisites Box if applicable */}
                      {isLocked && (
                        <div className="p-4 rounded-xl bg-amber-500/10 border border-amber-500/20 text-xs text-amber-300 space-y-2">
                          <div className="font-bold flex items-center gap-1.5 text-amber-400">
                            <Lock size={14} /> Requisitos para desbloquear:
                          </div>
                          {!prereqCompleted && course.prerequisite_course && (
                            <div>
                              • Completar al 100%:{" "}
                              <Link 
                                href={`/cursos/${prereqId}`}
                                className="underline font-bold hover:text-white"
                              >
                                {course.prerequisite_course.title}
                              </Link>{" "}
                              (Progreso actual: {courseProgressMap[prereqId!] || 0}%)
                            </div>
                          )}
                          {!levelMet && (
                            <div>
                              • Nivel de jugador requerido: <strong>Nivel {course.min_level}</strong> (Tu nivel: {userLevel})
                            </div>
                          )}
                        </div>
                      )}

                      {/* Quick Meta List */}
                      <div className="space-y-3 pt-2 border-t border-white/10 text-sm">
                        <div className="flex items-center justify-between">
                          <span className="text-zinc-400 flex items-center gap-2">
                            <Layers size={16} className="text-indigo-400" /> Total Módulos
                          </span>
                          <span className="font-bold text-white font-mono">{modules.length}</span>
                        </div>

                        <div className="flex items-center justify-between">
                          <span className="text-zinc-400 flex items-center gap-2">
                            <BookOpen size={16} className="text-indigo-400" /> Lecciones & Retos
                          </span>
                          <span className="font-bold text-white font-mono">{totalChallenges}</span>
                        </div>

                        <div className="flex items-center justify-between">
                          <span className="text-zinc-400 flex items-center gap-2">
                            <Trophy size={16} className="text-yellow-400" /> Recompensa Total
                          </span>
                          <span className="font-bold text-primary font-mono">+{totalXp} XP</span>
                        </div>

                        <div className="flex items-center justify-between">
                          <span className="text-zinc-400 flex items-center gap-2">
                            <Clock size={16} className="text-indigo-400" /> Ritmo
                          </span>
                          <span className="font-bold text-white">100% Autodirigido</span>
                        </div>
                      </div>

                      {/* Primary CTA Button */}
                      {isLocked ? (
                        <Link href={prereqId ? `/cursos/${prereqId}` : "/cursos"} className="block w-full">
                          <Button
                            size="lg"
                            variant="secondary"
                            className="w-full font-bold text-base shadow-xl py-3.5 border-amber-500/30 text-amber-300 hover:bg-amber-500/10"
                            leftIcon={<Lock size={18} className="text-amber-400" />}
                          >
                            Ir al Curso Prerrequisito
                          </Button>
                        </Link>
                      ) : (
                        <Button
                          size="lg"
                          onClick={handleEnrollAndStart}
                          isLoading={enrolling}
                          className={`w-full font-bold text-base shadow-xl py-3.5 ${
                            isEnrolled
                              ? "bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white shadow-emerald-500/20"
                              : "bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-500 hover:to-purple-500 text-white shadow-indigo-500/30"
                          }`}
                          rightIcon={<ChevronRight size={18} />}
                        >
                          {isEnrolled ? "Continuar Aprendizaje" : "Matricularme e Iniciar"}
                        </Button>
                      )}

                      {/* Value props */}
                      <div className="space-y-2 pt-4 border-t border-white/10 text-xs text-zinc-400">
                        <div className="flex items-center gap-2">
                          <CheckCircle2 size={14} className="text-emerald-400 shrink-0" />
                          <span>Feedback en vivo y tests automatizados</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <CheckCircle2 size={14} className="text-emerald-400 shrink-0" />
                          <span>Puntos XP y subida de nivel garantizados</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <CheckCircle2 size={14} className="text-emerald-400 shrink-0" />
                          <span>Ruta desbloqueable paso a paso</span>
                        </div>
                      </div>
                    </Card>

                  </div>

                </div>
              </>
            ) : (
              <div className="text-center py-20 bg-white/5 rounded-3xl border border-white/10 p-8">
                <BookOpen size={48} className="mx-auto text-zinc-600 mb-4" />
                <h2 className="text-2xl font-bold text-white mb-2">Curso no encontrado</h2>
                <p className="text-zinc-400 mb-6">El curso solicitado no existe o fue desactivado.</p>
                <Link href="/cursos">
                  <Button variant="secondary">Volver al Catálogo</Button>
                </Link>
              </div>
            )}

          </div>
        </main>
      </div>
    </div>
  );
}
