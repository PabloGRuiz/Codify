"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { 
  Code2, 
  Play, 
  Star, 
  Zap, 
  Map, 
  Trophy, 
  Gift, 
  Newspaper, 
  Flame, 
  Sparkles, 
  ChevronRight,
  TrendingUp,
  ShieldCheck
} from "lucide-react";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { QuestsHub } from "@/components/dashboard/QuestsHub";
import { TechNewsFeed } from "@/components/dashboard/TechNewsFeed";
import { DailyCodingArena } from "@/components/dashboard/DailyCodingArena";
import { StreakModal } from "@/components/dashboard/StreakModal";
import { getLevelInfo } from "@/lib/gamification";
import Link from "next/link";
import { Swords } from "lucide-react";

export default function Home() {
  const { user, profile, loading: userLoading } = useUser();
  const { isCollapsed } = useSidebar();
  const router = useRouter();
  const [activeDashboardTab, setActiveDashboardTab] = useState<"roadmap" | "arena" | "news" | "quests">("roadmap");
  const [showStreakModal, setShowStreakModal] = useState(false);
  const [enrollments, setEnrollments] = useState<any[]>([]);
  const [loadingEnrollments, setLoadingEnrollments] = useState(true);

  useEffect(() => {
    if (!userLoading) {
      if (!user) {
        setLoadingEnrollments(false);
        return;
      }
      
      const fetchEnrollments = async () => {
        try {
          // 1. Fetch user enrollments with courses, modules and challenges
          const { data: enrData, error: enrError } = await supabase
            .from("course_enrollments")
            .select("*, courses(*, modules(id, title, challenges(id)))")
            .eq("user_id", user.id);

          if (enrError) throw enrError;

          if (enrData && enrData.length > 0) {
            // 2. Fetch all completed challenges for this user
            const { data: userProg } = await supabase
              .from("user_progress")
              .select("challenge_id")
              .eq("user_id", user.id)
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
            router.push("/cursos");
          }
        } catch (err) {
          console.error("Error fetching enrollments:", err);
        } finally {
          setLoadingEnrollments(false);
        }
      };

      fetchEnrollments();
    }
  }, [user, userLoading, router]);

  const streak = profile?.streak_days || 1;
  const levelInfo = getLevelInfo(profile?.xp);
  const currentLevel = levelInfo.level;
  const currentXp = levelInfo.totalXp;
  const xpProgressInLevel = levelInfo.xpInLevel;
  const xpRequiredForNext = levelInfo.xpRequiredForNextLevel;
  const progressPercentage = levelInfo.progressPercentage;

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        {/* Background ambient lighting */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[140px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[140px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative space-y-6 lg:space-y-8">
          
          {/* Header Banner & Main Dashboard Navigation Tabs */}
          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-white/10 pb-6">
            <div>
              <div className="flex items-center gap-2 text-primary text-xs font-bold uppercase tracking-wider mb-2">
                <Sparkles size={16} />
                <span>Plataforma de Aprendizaje Activo</span>
              </div>
              <h1 className="text-3xl lg:text-4xl font-heading font-bold text-white mb-2">
                ¡Hola de nuevo, {profile?.username || "Developer"}! 👋
              </h1>
              <p className="text-zinc-400 font-sans text-sm lg:text-base max-w-2xl">
                Continúa construyendo tu carrera en tecnología: domina Python, APIs con FastAPI, JavaScript y Arquitectura de IA.
              </p>
            </div>

            {/* Main Tabs Selector */}
            <div className="flex items-center bg-black/60 p-1.5 rounded-2xl border border-white/10 shrink-0 self-start md:self-auto flex-wrap gap-1">
              <button
                onClick={() => setActiveDashboardTab("roadmap")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-xs sm:text-sm transition-all ${
                  activeDashboardTab === "roadmap"
                    ? "bg-gradient-to-r from-primary to-accent text-white shadow-[0_0_15px_rgba(139,92,246,0.4)]"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                <Map size={16} /> <span>Ruta de Niveles</span>
              </button>
              <button
                onClick={() => setActiveDashboardTab("arena")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-xs sm:text-sm transition-all ${
                  activeDashboardTab === "arena"
                    ? "bg-gradient-to-r from-red-600 to-purple-600 text-white shadow-[0_0_15px_rgba(220,38,38,0.4)]"
                    : "text-red-400/80 hover:text-red-300"
                }`}
              >
                <Swords size={16} /> <span>Arena Diaria ⚡</span>
              </button>
              <button
                onClick={() => setActiveDashboardTab("news")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-xs sm:text-sm transition-all ${
                  activeDashboardTab === "news"
                    ? "bg-gradient-to-r from-primary to-accent text-white shadow-[0_0_15px_rgba(139,92,246,0.4)]"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                <Newspaper size={16} /> <span>Pulso Tech</span>
              </button>
              <button
                onClick={() => setActiveDashboardTab("quests")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-xs sm:text-sm transition-all ${
                  activeDashboardTab === "quests"
                    ? "bg-gradient-to-r from-primary to-accent text-white shadow-[0_0_15px_rgba(139,92,246,0.4)]"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                <Gift size={16} /> <span>Misiones</span>
              </button>
            </div>
          </div>

          {/* TAB 1: ROADMAP & DASHBOARD STATS */}
          {activeDashboardTab === "roadmap" && (
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Left Column: Learning Roadmap & Quick Sandboxes */}
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
                  ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      {enrollments.map((enr) => {
                        const course = enr.courses;
                        if (!course) return null;
                        const progress = enr.calculated_progress || 0;
                        const typeTag = course.tags?.find((t: string) => {
                          const lower = t.toLowerCase();
                          return lower === 'teórico' || lower === 'teorico' || lower === 'práctico' || lower === 'practico';
                        });
                        const isTeorico = typeTag?.toLowerCase().includes('teor');

                        return (
                          <Link href={`/cursos/${course.id}`} key={course.id}>
                            <Card className="p-5 glass hover:border-primary/50 transition-all cursor-pointer hover:-translate-y-1 h-full flex flex-col group relative">
                              <div className="flex items-start justify-between mb-2">
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
              </div>

              {/* Right Column: Gamified Streak, Progress & Quests */}
              <div className="space-y-6">
                
                {/* 1. Fire Streak Hero Card */}
                <Card 
                  onClick={() => setShowStreakModal(true)}
                  className="p-6 glass border-orange-500/30 hover:border-orange-500/60 transition-all cursor-pointer group relative overflow-hidden shadow-[0_0_30px_rgba(249,115,22,0.1)]"
                >
                  <div className="absolute top-0 right-0 w-32 h-32 bg-orange-500/10 blur-[40px] rounded-full pointer-events-none" />
                  
                  <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center gap-2 text-orange-400 font-bold text-xs uppercase tracking-wider">
                      <Flame size={16} className="fill-orange-400 animate-pulse" />
                      <span>Racha Activa</span>
                    </div>
                    <span className="text-xs text-zinc-400 group-hover:text-orange-300 font-medium flex items-center gap-1 transition-colors">
                      Ver detalle <ChevronRight size={14} />
                    </span>
                  </div>

                  <div className="flex items-center gap-4 mb-4">
                    <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-orange-500 via-amber-500 to-yellow-400 flex items-center justify-center text-white shadow-lg border-2 border-orange-300 group-hover:scale-105 transition-transform">
                      <Flame size={32} className="fill-white" />
                    </div>
                    <div>
                      <div className="text-3xl font-heading font-bold text-white leading-none mb-1">
                        {streak} {streak === 1 ? "Día" : "Días"}
                      </div>
                      <p className="text-xs text-zinc-400">
                        {streak >= 7 ? "¡Multiplicador x1.5 activo!" : streak >= 3 ? "¡Multiplicador x1.2 activo!" : "¡Sigue programando hoy!"}
                      </p>
                    </div>
                  </div>

                  <div className="w-full bg-black/40 rounded-xl p-2.5 flex items-center justify-between text-xs text-zinc-300 border border-white/5 font-mono">
                    <span className="flex items-center gap-1 text-orange-400">
                      <ShieldCheck size={14} /> Protector activado
                    </span>
                    <span className="text-zinc-500">Hoy: Completado</span>
                  </div>
                </Card>

                {/* 2. Level & XP Progress Card */}
                <Card className="p-6 glass border-t-4 border-t-primary">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 rounded-lg bg-primary/20 text-primary font-bold flex items-center justify-center text-sm font-mono border border-primary/30">
                        {currentLevel}
                      </div>
                      <div>
                        <h4 className="font-heading font-bold text-sm text-white">Nivel {currentLevel}</h4>
                        <p className="text-[11px] text-zinc-400 font-mono">Desarrollador Junior</p>
                      </div>
                    </div>
                    <span className="text-xs font-bold text-primary font-mono">{currentXp} XP</span>
                  </div>

                  <div className="space-y-1.5">
                    <div className="flex justify-between text-[11px] text-zinc-400 font-mono">
                      <span>Progreso al Nivel {currentLevel + 1}</span>
                      <span>{xpProgressInLevel} / {xpRequiredForNext} XP</span>
                    </div>
                    <div className="h-2 w-full bg-black/60 rounded-full overflow-hidden border border-white/5">
                      <div 
                        className="h-full bg-gradient-to-r from-primary to-accent transition-all duration-500"
                        style={{ width: `${progressPercentage}%` }}
                      />
                    </div>
                  </div>
                </Card>

                {/* 3. Daily Quests Widget */}
                <Card className="p-6 glass">
                  <div className="flex items-center justify-between mb-4">
                    <h3 className="font-heading font-bold text-base">Misiones Diarias</h3>
                    <button 
                      onClick={() => setActiveDashboardTab("quests")}
                      className="text-xs text-primary font-bold hover:underline"
                    >
                      Ver todas →
                    </button>
                  </div>

                  <ul className="space-y-4">
                    {[
                      { title: "Inicia sesión a diario", xp: 25, progress: 1, total: 1, done: true },
                      { title: "Resuelve 1 lección hoy", xp: 50, progress: currentXp > 0 ? 1 : 0, total: 1, done: currentXp > 0 },
                      { title: "Acumula 100 XP", xp: 100, progress: Math.min(100, currentXp), total: 100, done: currentXp >= 100 },
                    ].map((mission, i) => (
                      <li key={i} className="flex items-start gap-3">
                        <div className={`w-5 h-5 rounded-full border flex items-center justify-center mt-0.5 flex-shrink-0 ${mission.done ? 'bg-emerald-500 border-emerald-400 text-black shadow-[0_0_10px_rgba(52,211,153,0.3)]' : 'border-zinc-500 bg-zinc-900/50'}`}>
                          {mission.done && <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>}
                        </div>
                        <div className="flex-1">
                          <div className="flex justify-between items-start mb-1">
                            <p className={`text-xs font-medium ${mission.done ? 'text-zinc-400' : 'text-zinc-200'}`}>{mission.title}</p>
                            <p className={`text-xs font-bold font-mono ${mission.done ? 'text-emerald-400' : 'text-primary'}`}>+{mission.xp} XP</p>
                          </div>
                          <div className="h-1.5 w-full bg-black/50 rounded-full overflow-hidden mt-1">
                            <div 
                              className={`h-full transition-all duration-500 ${mission.done ? 'bg-emerald-400' : 'bg-primary'}`}
                              style={{ width: `${(mission.progress / mission.total) * 100}%` }}
                            />
                          </div>
                        </div>
                      </li>
                    ))}
                  </ul>
                </Card>

              </div>
            </div>
          )}

          {/* TAB 2: DAILY CODING ARENA PVP RETOS */}
          {activeDashboardTab === "arena" && (
            <DailyCodingArena />
          )}

          {/* TAB 3: TECH NEWS FEED */}
          {activeDashboardTab === "news" && (
            <TechNewsFeed />
          )}

          {/* TAB 4: QUESTS & CHALLENGES HUB */}
          {activeDashboardTab === "quests" && (
            <QuestsHub />
          )}

        </main>
      </div>

      {/* Interactive Streak Modal */}
      <StreakModal
        isOpen={showStreakModal}
        onClose={() => setShowStreakModal(false)}
        streakDays={streak}
        xpPoints={currentXp}
      />
    </div>
  );
}
