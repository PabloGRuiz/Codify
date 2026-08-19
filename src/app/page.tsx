"use client";

import { useState, useEffect } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Code2, Play, Star, Zap, Map, Trophy, Gift } from "lucide-react";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { LearningPath } from "@/components/roadmap/LearningPath";
import { QuestsHub } from "@/components/dashboard/QuestsHub";
import Link from "next/link";

export default function Home() {
  const { user, profile } = useUser();
  const { isCollapsed } = useSidebar();
  const [activeDashboardTab, setActiveDashboardTab] = useState<"roadmap" | "quests">("roadmap");

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        {/* Background glow effects */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[120px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-6 lg:p-8 overflow-y-auto z-10 relative space-y-8">
          
          {/* Header & Main Tabs */}
          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-white/10 pb-6">
            <div>
              <h1 className="text-3xl lg:text-4xl font-heading font-bold text-white mb-2">
                ¡Hola de nuevo, {profile?.username || "Coder"}! 👋
              </h1>
              <p className="text-zinc-400 font-sans text-base lg:text-lg">
                Tu camino hacia la maestría en programación continúa. ¿Listo para el próximo nivel?
              </p>
            </div>

            {/* Dashboard Tabs Selector */}
            <div className="flex items-center bg-black/60 p-1.5 rounded-2xl border border-white/10 shrink-0 self-start md:self-auto">
              <button
                onClick={() => setActiveDashboardTab("roadmap")}
                className={`flex items-center gap-2 px-5 py-2 rounded-xl font-bold text-sm transition-all ${
                  activeDashboardTab === "roadmap"
                    ? "bg-gradient-to-r from-primary to-accent text-white shadow-lg"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                <Map size={16} /> 🗺️ Ruta de Niveles
              </button>
              <button
                onClick={() => setActiveDashboardTab("quests")}
                className={`flex items-center gap-2 px-5 py-2 rounded-xl font-bold text-sm transition-all ${
                  activeDashboardTab === "quests"
                    ? "bg-gradient-to-r from-primary to-accent text-white shadow-lg"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                <Gift size={16} /> ⚡ Retos y Misiones
              </button>
            </div>
          </div>

          {/* TAB 1: ROADMAP & SIDEBAR WIDGETS */}
          {activeDashboardTab === "roadmap" ? (
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Left Area: Duolingo-style Learning Path Board & Quick Tools */}
              <div className="lg:col-span-2 space-y-8">
                <LearningPath />

                {/* Quick Actions / Micro-environments */}
                <div>
                  <h3 className="text-xl font-heading font-bold text-white mb-4">Entornos Rápidos</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <Link href="/web">
                      <Card className="p-6 hover:border-primary/50 transition-colors cursor-pointer group glass h-full">
                        <div className="w-12 h-12 rounded-lg bg-blue-500/20 text-blue-400 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                          <Code2 size={24} />
                        </div>
                        <h4 className="font-bold text-lg mb-2">Prototipado Web</h4>
                        <p className="text-sm text-zinc-400">Entorno HTML/CSS/JS con vista previa en vivo.</p>
                      </Card>
                    </Link>
                    
                    <Link href="/ide">
                      <Card className="p-6 hover:border-accent/50 transition-colors cursor-pointer group glass h-full">
                        <div className="w-12 h-12 rounded-lg bg-yellow-500/20 text-yellow-400 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                          <Zap size={24} />
                        </div>
                        <h4 className="font-bold text-lg mb-2">Algoritmia & POO</h4>
                        <p className="text-sm text-zinc-400">Lista completa de retos y validaciones ocultas.</p>
                      </Card>
                    </Link>
                  </div>
                </div>
              </div>

              {/* Right Sidebar Widgets */}
              <div className="space-y-6">
                <Card className="p-6 glass border-t-4 border-t-accent">
                  <div className="flex items-center justify-between mb-4">
                    <h3 className="font-heading font-bold text-lg">Misiones Diarias</h3>
                    <button 
                      onClick={() => setActiveDashboardTab("quests")}
                      className="text-xs text-primary font-bold hover:underline"
                    >
                      Ver todas →
                    </button>
                  </div>

                  <ul className="space-y-5">
                    {[
                      { title: "Inicia sesión diario", xp: 25, progress: 1, total: 1, done: true },
                      { title: "Resuelve 1 lección hoy", xp: 50, progress: (profile?.xp || 0) > 0 ? 1 : 0, total: 1, done: (profile?.xp || 0) > 0 },
                      { title: "Acumula 100 XP hoy", xp: 100, progress: Math.min(100, profile?.xp || 0), total: 100, done: (profile?.xp || 0) >= 100 },
                    ].map((mission, i) => (
                      <li key={i} className="flex items-start gap-3">
                        <div className={`w-5 h-5 rounded-full border flex items-center justify-center mt-0.5 flex-shrink-0 ${mission.done ? 'bg-emerald-500 border-emerald-400 text-black shadow-[0_0_10px_rgba(52,211,153,0.3)]' : 'border-zinc-500 bg-zinc-900/50'}`}>
                          {mission.done && <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>}
                        </div>
                        <div className="flex-1">
                          <div className="flex justify-between items-start mb-1">
                            <p className={`text-sm font-medium ${mission.done ? 'text-zinc-400' : 'text-zinc-200'}`}>{mission.title}</p>
                            <p className={`text-xs font-bold ${mission.done ? 'text-emerald-400' : 'text-primary'}`}>+{mission.xp} XP</p>
                          </div>
                          <div className="h-1.5 w-full bg-black/50 rounded-full overflow-hidden mt-1.5">
                            <div 
                              className={`h-full transition-all duration-500 ${mission.done ? 'bg-emerald-400' : 'bg-accent shadow-[0_0_10px_rgba(56,189,248,0.5)]'}`}
                              style={{ width: `${(mission.progress / mission.total) * 100}%` }}
                            ></div>
                          </div>
                          <p className="text-[10px] text-zinc-500 mt-1 text-right">{mission.progress} / {mission.total}</p>
                        </div>
                      </li>
                    ))}
                  </ul>
                </Card>

                <Card className="p-6 glass">
                  <h3 className="font-heading font-bold text-lg mb-4">Tus Estadísticas</h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="bg-black/20 p-4 rounded-xl border border-white/5 flex flex-col items-center">
                      <span className="text-2xl font-bold text-white mb-1">{profile?.streak_days || 1}</span>
                      <span className="text-xs text-zinc-400 uppercase tracking-wider">Racha Días</span>
                    </div>
                    <div className="bg-black/20 p-4 rounded-xl border border-white/5 flex flex-col items-center">
                      <span className="text-2xl font-bold text-white mb-1">{profile?.xp || 0}</span>
                      <span className="text-xs text-zinc-400 uppercase tracking-wider">Puntos XP</span>
                    </div>
                  </div>
                </Card>
              </div>
            </div>
          ) : (
            /* TAB 2: QUESTS & CHALLENGES HUB */
            <QuestsHub />
          )}

        </main>
      </div>
    </div>
  );
}
