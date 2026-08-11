"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { BookOpen, Check, Lock, Play, Star, Trophy, Zap, ShieldCheck } from "lucide-react";
import Link from "next/link";

interface ChallengeNode {
  id: string;
  title: string;
  description: string;
  order_index: number;
  xp_reward: number;
  theory?: string;
}

export function LearningPath() {
  const { user } = useUser();
  const [challenges, setChallenges] = useState<ChallengeNode[]>([]);
  const [completedIds, setCompletedIds] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchPathData();
  }, [user]);

  const fetchPathData = async () => {
    try {
      // 1. Fetch logic challenges ordered by order_index
      const { data: challengesData, error: chError } = await supabase
        .from("challenges")
        .select("*")
        .eq("challenge_type", "logic")
        .order("order_index", { ascending: true });

      if (chError) console.error("Error fetching challenges:", chError.message || chError);
      if (challengesData) setChallenges(challengesData);

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

  if (loading) {
    return (
      <Card className="p-8 text-center text-zinc-400 font-sans glass animate-pulse">
        Cargando Tablero de Niveles...
      </Card>
    );
  }

  const completedCount = challenges.filter((c) => completedIds.includes(c.id)).length;
  const totalCount = challenges.length;
  const progressPercent = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;

  return (
    <Card className="p-8 glass-panel border-t-4 border-t-primary relative overflow-hidden space-y-8">
      {/* Header section */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-white/10 pb-6">
        <div>
          <div className="flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-wider mb-1">
            <ShieldCheck size={16} />
            <span>Segmento 1: Nivel Inicial</span>
          </div>
          <h2 className="text-2xl font-heading font-bold text-white">Fundamentos de Programación</h2>
          <p className="text-sm text-zinc-400 mt-1">
            Aprende desde lo más básico (variables) hasta crear tu primer algoritmo con funciones y bucles.
          </p>
        </div>

        {/* Segment Progress Indicator */}
        <div className="bg-black/40 p-4 rounded-xl border border-white/10 flex items-center gap-4 shrink-0">
          <div className="text-right">
            <span className="text-xs text-zinc-400 block font-semibold">Progreso Segmento</span>
            <span className="text-lg font-bold text-white">
              {completedCount} / {totalCount} <span className="text-xs text-primary">({progressPercent}%)</span>
            </span>
          </div>
          <div className="w-12 h-12 rounded-full border-4 border-primary/30 flex items-center justify-center relative">
            <div
              className="absolute inset-0 rounded-full border-4 border-primary transition-all duration-700"
              style={{
                clipPath: `inset(0 ${100 - progressPercent}% 0 0)`,
              }}
            ></div>
            <Star className="text-primary fill-primary" size={20} />
          </div>
        </div>
      </div>

      {/* Duolingo Winding Tree Board */}
      <div className="relative py-6 max-w-lg mx-auto flex flex-col items-center gap-10">
        {challenges.length === 0 ? (
          <div className="text-center text-zinc-400 py-8">
            <p>No se encontraron niveles en el segmento.</p>
            <p className="text-xs mt-2">Ejecuta el script SQL `beginner_curriculum.sql` en Supabase.</p>
          </div>
        ) : (
          challenges.map((node, index) => {
            const isCompleted = completedIds.includes(node.id);
            // Unlocked if it's the first node OR if the previous node is completed
            const isUnlocked = index === 0 || completedIds.includes(challenges[index - 1].id);
            const isTrophy = index === challenges.length - 1;

            // Stagger position left, center, right for Duolingo winding effect
            const alignments = ["self-start ml-8", "self-center", "self-end mr-8", "self-center", "self-center"];
            const alignClass = alignments[index % alignments.length];

            return (
              <div key={node.id} className={`relative flex flex-col items-center ${alignClass} group z-10`}>
                
                {/* Connecting glowing line to next node */}
                {index < challenges.length - 1 && (
                  <div className="absolute top-16 left-1/2 -translate-x-1/2 w-1 h-12 bg-gradient-to-b from-primary/50 to-primary/10 -z-10" />
                )}

                {/* Node Button Circle */}
                {isUnlocked ? (
                  <Link href={`/ide/${node.id}`}>
                    <button
                      className={`w-20 h-20 rounded-full flex flex-col items-center justify-center transition-all duration-300 transform group-hover:scale-110 shadow-2xl relative ${
                        isCompleted
                          ? "bg-emerald-500/20 border-4 border-emerald-400 text-emerald-400 shadow-[0_0_20px_rgba(52,211,153,0.3)]"
                          : "bg-primary/30 border-4 border-primary text-white shadow-[0_0_25px_rgba(139,92,246,0.5)] animate-pulse"
                      }`}
                    >
                      {isCompleted ? (
                        <Check size={32} className="stroke-[3]" />
                      ) : isTrophy ? (
                        <Trophy size={32} className="text-yellow-400 fill-yellow-400 animate-bounce" />
                      ) : (
                        <Zap size={30} className="fill-primary" />
                      )}
                      
                      {/* Floating XP badge */}
                      <span className="absolute -bottom-2 bg-black border border-white/20 px-2 py-0.5 rounded-full text-[10px] font-bold text-primary shadow-md">
                        +{node.xp_reward} XP
                      </span>
                    </button>
                  </Link>
                ) : (
                  /* Locked Node */
                  <div className="w-20 h-20 rounded-full bg-zinc-900 border-4 border-zinc-700 text-zinc-600 flex flex-col items-center justify-center cursor-not-allowed opacity-60 relative">
                    <Lock size={26} />
                    <span className="absolute -bottom-2 bg-zinc-950 border border-zinc-800 px-2 py-0.5 rounded-full text-[10px] text-zinc-500 font-bold">
                      Bloqueado
                    </span>
                  </div>
                )}

                {/* Node Info Label */}
                <div className="mt-4 text-center max-w-[180px]">
                  <h4 className="font-heading font-bold text-sm text-white group-hover:text-primary transition-colors">
                    {node.title}
                  </h4>
                  <span className="text-[11px] text-zinc-400 block line-clamp-1 mt-0.5">
                    {isCompleted ? "✅ Completado" : isUnlocked ? "⚡ Listo para empezar" : "🔒 Completa el nivel anterior"}
                  </span>
                </div>

              </div>
            );
          })
        )}
      </div>
    </Card>
  );
}
