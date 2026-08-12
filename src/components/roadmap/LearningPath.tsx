"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Check, Lock, Play, Star, Trophy, Zap, ShieldCheck, ArrowRight, BookOpen } from "lucide-react";
import Link from "next/link";

interface ChallengeNode {
  id: string;
  module_id: string;
  title: string;
  description: string;
  order_index: number;
  xp_reward: number;
  theory?: string;
}

interface ModuleInfo {
  id: string;
  title: string;
  description: string;
}

export function LearningPath() {
  const { user } = useUser();
  const [modules, setModules] = useState<ModuleInfo[]>([]);
  const [selectedModuleId, setSelectedModuleId] = useState<string>("");
  const [challenges, setChallenges] = useState<ChallengeNode[]>([]);
  const [completedIds, setCompletedIds] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchModulesAndProgress();
  }, [user]);

  useEffect(() => {
    if (selectedModuleId) {
      fetchChallengesForModule(selectedModuleId);
    }
  }, [selectedModuleId]);

  const fetchModulesAndProgress = async () => {
    try {
      // 1. Fetch modules
      const { data: modulesData, error: modError } = await supabase
        .from("modules")
        .select("*")
        .order("created_at", { ascending: true });

      if (modError) console.error("Error fetching modules:", modError.message || modError);
      
      if (modulesData && modulesData.length > 0) {
        setModules(modulesData);
        let defaultModId = "";
        
        if (typeof window !== "undefined") {
          const saved = localStorage.getItem("codify_last_module");
          if (saved && modulesData.some(m => m.id === saved)) {
            defaultModId = saved;
          }
        }
        
        if (!defaultModId) {
          const beginnerMod = modulesData.find((m) => m.title.toLowerCase().includes("inicial") || m.title.toLowerCase().includes("cero"));
          defaultModId = beginnerMod ? beginnerMod.id : modulesData[0].id;
        }
        
        setSelectedModuleId(defaultModId);
      }

      // 2. Fetch user completed challenges if logged in
      if (user) {
        const { data: progData, error: prError } = await supabase
          .from("user_progress")
          .select("challenge_id")
          .eq("user_id", user.id)
          .eq("status", "completed");

        if (prError) console.error("Error fetching progress:", prError.message || prError);
        if (progData) {
          setCompletedIds(progData.map((p) => p.challenge_id));
        }
      }
    } catch (e: any) {
      console.error("Unexpected error in LearningPath:", e?.message || String(e));
    } finally {
      setLoading(false);
    }
  };

  const fetchChallengesForModule = async (moduleId: string) => {
    try {
      const { data: challengesData, error: chError } = await supabase
        .from("challenges")
        .select("*")
        .eq("module_id", moduleId)
        .order("order_index", { ascending: true });

      if (chError) console.error("Error fetching challenges:", chError.message || chError);
      if (challengesData) setChallenges(challengesData);
    } catch (e: any) {
      console.error("Error loading module challenges:", e?.message || String(e));
    }
  };

  if (loading) {
    return (
      <Card className="p-8 glass-panel border-t-4 border-t-primary space-y-8 shadow-2xl animate-pulse">
        <div className="flex flex-col md:flex-row justify-between md:items-center pb-6 border-b border-white/10 gap-6">
          <div className="space-y-3">
            <div className="h-4 w-32 bg-white/10 rounded"></div>
            <div className="h-8 w-64 bg-white/10 rounded"></div>
            <div className="h-4 w-48 bg-white/10 rounded"></div>
          </div>
          <div className="h-20 w-40 bg-white/10 rounded-xl"></div>
        </div>
        <div className="space-y-4 max-w-3xl mx-auto py-2">
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="flex items-start gap-6">
              <div className="flex flex-col items-center pt-1">
                <div className="w-14 h-14 rounded-2xl bg-white/10"></div>
                {i < 4 && <div className="w-0.5 h-14 my-2 bg-white/5"></div>}
              </div>
              <div className="flex-1 h-28 sm:h-24 bg-white/5 rounded-2xl border border-white/5"></div>
            </div>
          ))}
        </div>
      </Card>
    );
  }

  const activeModule = modules.find((m) => m.id === selectedModuleId);
  const completedCount = challenges.filter((c) => completedIds.includes(c.id)).length;
  const totalCount = challenges.length;
  const progressPercent = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;

  return (
    <Card className="p-8 glass-panel border-t-4 border-t-primary relative overflow-hidden space-y-8 shadow-2xl">
      
      {/* Header section */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 border-b border-white/10 pb-6">
        <div className="space-y-2">
          <div className="flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-wider">
            <ShieldCheck size={16} />
            <span>Ruta de Aprendizaje Interactiva</span>
          </div>

          {/* Module Selector Dropdown if multiple modules exist */}
          {modules.length > 1 ? (
            <select
              value={selectedModuleId}
              onChange={(e) => {
                const newId = e.target.value;
                setSelectedModuleId(newId);
                if (typeof window !== "undefined") {
                  localStorage.setItem("codify_last_module", newId);
                }
              }}
              className="bg-black/60 text-white font-heading font-bold text-xl p-2 rounded-lg border border-white/20 outline-none focus:border-primary max-w-full"
            >
              {modules.map((m) => (
                <option key={m.id} value={m.id}>
                  {m.title}
                </option>
              ))}
            </select>
          ) : (
            <h2 className="text-2xl font-heading font-bold text-white">
              {activeModule?.title || "Curso Inicial: Aprende a Programar desde Cero"}
            </h2>
          )}

          <p className="text-sm text-zinc-400 max-w-xl">
            {activeModule?.description || "Domina las bases de la programación paso a paso."}
          </p>
        </div>

        {/* Segment Progress Indicator */}
        <div className="bg-black/50 p-4 rounded-xl border border-white/10 flex items-center gap-4 shrink-0 shadow-lg">
          <div className="text-right">
            <span className="text-xs text-zinc-400 block font-semibold">Progreso del Módulo</span>
            <span className="text-xl font-bold text-white font-mono">
              {completedCount} / {totalCount} <span className="text-xs text-primary font-sans">({progressPercent}%)</span>
            </span>
          </div>
          <div className="w-14 h-14 rounded-full border-4 border-primary/20 flex items-center justify-center relative bg-black/40">
            <Star className="text-primary fill-primary animate-pulse" size={24} />
          </div>
        </div>
      </div>

      {/* Timeline Roadmap View */}
      <div className="space-y-4 max-w-3xl mx-auto py-2">
        {challenges.length === 0 ? (
          <div className="text-center text-zinc-400 py-12 space-y-3">
            <BookOpen size={36} className="mx-auto text-zinc-600" />
            <p className="text-base font-semibold">No se encontraron niveles en este módulo.</p>
            <p className="text-xs text-zinc-500">Ejecuta el script SQL `beginner_curriculum.sql` en tu panel de Supabase.</p>
          </div>
        ) : (
          challenges.map((node, index) => {
            const isCompleted = completedIds.includes(node.id);
            const isUnlocked = index === 0 || completedIds.includes(challenges[index - 1].id);
            const isTrophy = index === challenges.length - 1;

            return (
              <div key={node.id} className="relative flex items-start gap-6 group">
                
                {/* Left Timeline Column: Icon Node + Connector Line */}
                <div className="flex flex-col items-center shrink-0 pt-1">
                  {/* Node Circle Icon */}
                  {isUnlocked ? (
                    <Link href={`/ide/${node.id}`}>
                      <button
                        className={`w-14 h-14 rounded-2xl flex items-center justify-center transition-all duration-300 transform group-hover:scale-110 shadow-xl relative ${
                          isCompleted
                            ? "bg-emerald-500/20 border-2 border-emerald-400 text-emerald-400 shadow-[0_0_20px_rgba(52,211,153,0.3)]"
                            : "bg-primary/20 border-2 border-primary text-primary shadow-[0_0_20px_rgba(139,92,246,0.4)] animate-pulse"
                        }`}
                      >
                        {isCompleted ? (
                          <Check size={26} className="stroke-[3]" />
                        ) : isTrophy ? (
                          <Trophy size={26} className="text-yellow-400 fill-yellow-400" />
                        ) : (
                          <Zap size={24} className="fill-primary" />
                        )}
                      </button>
                    </Link>
                  ) : (
                    /* Locked Node Circle */
                    <div className="w-14 h-14 rounded-2xl bg-zinc-900/80 border border-zinc-800 text-zinc-600 flex items-center justify-center cursor-not-allowed opacity-60">
                      <Lock size={20} />
                    </div>
                  )}

                  {/* Vertical Connector Line to Next Node */}
                  {index < challenges.length - 1 && (
                    <div className={`w-0.5 h-14 my-2 transition-colors ${isCompleted ? 'bg-emerald-400/50' : 'bg-white/10'}`} />
                  )}
                </div>

                {/* Right Column: Interactive Level Card */}
                <div
                  className={`flex-1 p-5 rounded-2xl border transition-all flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-lg ${
                    isCompleted
                      ? "bg-emerald-950/10 border-emerald-500/20"
                      : isUnlocked
                      ? "bg-black/50 border-white/10 hover:border-primary/50 hover:bg-black/70"
                      : "bg-black/20 border-white/5 opacity-50 cursor-not-allowed"
                  }`}
                >
                  <div className="space-y-1">
                    <div className="flex items-center gap-2">
                      <span className="text-[11px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-white/5 text-zinc-400 border border-white/5">
                        Nivel {index + 1}
                      </span>
                      {isTrophy && (
                        <span className="text-[11px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-yellow-500/20 text-yellow-400 border border-yellow-500/30">
                          🏆 Reto Final
                        </span>
                      )}
                    </div>
                    <h3 className="font-heading font-bold text-lg text-white group-hover:text-primary transition-colors">
                      {node.title}
                    </h3>
                    <p className="text-xs text-zinc-400 line-clamp-2">
                      {node.description}
                    </p>
                  </div>

                  <div className="shrink-0 flex items-center gap-3">
                    <span className="text-xs font-bold text-primary bg-primary/10 px-3 py-1.5 rounded-full border border-primary/20">
                      +{node.xp_reward} XP
                    </span>

                    {isUnlocked ? (
                      <Link href={`/ide/${node.id}`}>
                        <Button
                          size="sm"
                          rightIcon={<ArrowRight size={14} />}
                          className={isCompleted ? "bg-emerald-500 hover:bg-emerald-600 text-black font-bold border-none" : ""}
                        >
                          {isCompleted ? "Repasar" : "Comenzar"}
                        </Button>
                      </Link>
                    ) : (
                      <Button size="sm" variant="secondary" disabled className="opacity-50">
                        Bloqueado
                      </Button>
                    )}
                  </div>
                </div>

              </div>
            );
          })
        )}
      </div>

    </Card>
  );
}
