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
import { useEnrollments } from "@/hooks/useEnrollments";
import { QuestsHub } from "@/components/dashboard/QuestsHub";
import { TechNewsFeed } from "@/components/dashboard/TechNewsFeed";
import { DailyCodingArena } from "@/components/dashboard/DailyCodingArena";
import { StreakModal } from "@/components/dashboard/StreakModal";
import { RoadmapView } from "@/components/dashboard/RoadmapView";
import { GamificationWidget } from "@/components/dashboard/GamificationWidget";
import { getLevelInfo } from "@/lib/gamification";
import Link from "next/link";
import { Swords } from "lucide-react";

export default function Home() {
  const { user, profile, loading: userLoading } = useUser();
  const { isCollapsed } = useSidebar();
  const router = useRouter();
  const [activeDashboardTab, setActiveDashboardTab] = useState<"roadmap" | "arena" | "news" | "quests">("roadmap");
  const [showStreakModal, setShowStreakModal] = useState(false);
  const { 
    enrollments, 
    loading: loadingEnrollments, 
    unenrollCourse,
    certifiedCourseIds 
  } = useEnrollments(user?.id, userLoading);

  useEffect(() => {
    if (!userLoading && !loadingEnrollments && enrollments.length === 0 && user) {
      router.push("/cursos");
    }
  }, [enrollments, loadingEnrollments, userLoading, user, router]);

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
              <RoadmapView 
                enrollments={enrollments} 
                loadingEnrollments={loadingEnrollments} 
                onUnenroll={unenrollCourse}
                certifiedCourseIds={certifiedCourseIds}
              />
              <GamificationWidget 
                setShowStreakModal={setShowStreakModal}
                streak={streak}
                currentLevel={currentLevel}
                currentXp={currentXp}
                xpProgressInLevel={xpProgressInLevel}
                xpRequiredForNext={xpRequiredForNext}
                progressPercentage={progressPercentage}
                setActiveDashboardTab={setActiveDashboardTab}
              />
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
