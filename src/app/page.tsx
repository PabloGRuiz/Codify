"use client";

import { useState, useEffect } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Code2, Play, Star, Zap, Map } from "lucide-react";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";
import { LearningPath } from "@/components/roadmap/LearningPath";
import Link from "next/link";

export default function Home() {
  const { user, profile } = useUser();
  const [modules, setModules] = useState<any[]>([]);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const { data, error } = await supabase.from("modules").select("*").limit(1);
        if (error) console.error("Error fetching dashboard modules:", error.message || error);
        if (data) setModules(data);
      } catch (e: any) {
        console.error("Dashboard data fetch error:", e?.message || String(e));
      }
    };
    fetchDashboardData();
  }, []);

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="md:ml-64 ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden">
        {/* Background glow effects */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[120px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-8 overflow-y-auto z-10 relative">
          <header className="mb-10">
            <h1 className="text-4xl font-heading font-bold text-white mb-2">
              ¡Hola de nuevo, {profile?.username || "Coder"}! 👋
            </h1>
            <p className="text-zinc-400 font-sans text-lg">Tu camino hacia la maestría en programación continúa. ¿Listo para el próximo nivel?</p>
          </header>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Left Area: Duolingo-style Learning Path Board & Quick Tools */}
            <div className="lg:col-span-2 space-y-8">
              
              {/* Duolingo-style Winding Level Path */}
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
                <h3 className="font-heading font-bold text-lg mb-4">Misiones Diarias</h3>
                <ul className="space-y-5">
                  {[
                    { title: "Completa 1 reto de lógica", xp: 50, progress: 0, total: 1, done: false },
                    { title: "Gana 100 XP hoy", xp: 100, progress: 25, total: 100, done: false },
                    { title: "Inicia sesión", xp: 25, progress: 1, total: 1, done: true },
                  ].map((mission, i) => (
                    <li key={i} className="flex items-start gap-3">
                      <div className={`w-5 h-5 rounded-full border flex items-center justify-center mt-0.5 flex-shrink-0 ${mission.done ? 'bg-success border-success text-black shadow-[0_0_10px_rgba(52,211,153,0.3)]' : 'border-zinc-500 bg-zinc-900/50'}`}>
                        {mission.done && <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>}
                      </div>
                      <div className="flex-1">
                        <div className="flex justify-between items-start mb-1">
                          <p className={`text-sm font-medium ${mission.done ? 'text-zinc-500' : 'text-zinc-200'}`}>{mission.title}</p>
                          <p className={`text-xs font-bold ${mission.done ? 'text-zinc-600' : 'text-primary'}`}>+{mission.xp} XP</p>
                        </div>
                        <div className="h-1.5 w-full bg-black/50 rounded-full overflow-hidden mt-1.5">
                          <div 
                            className={`h-full transition-all duration-500 ${mission.done ? 'bg-zinc-600' : 'bg-accent shadow-[0_0_10px_rgba(56,189,248,0.5)]'}`}
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
        </main>
      </div>
    </div>
  );
}
