"use client";

import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Flame, Trophy, CheckCircle2, Zap, Gift, Calendar, Clock, Star } from "lucide-react";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";

interface Quest {
  id: string;
  type: "daily" | "weekly";
  title: string;
  description: string;
  xpReward: number;
  progress: number;
  total: number;
  completed: boolean;
  claimed: boolean;
}

export function QuestsHub() {
  const { user, profile } = useUser();
  const [claimedIds, setClaimedIds] = useState<string[]>([]);
  const [claimingId, setClaimingId] = useState<string | null>(null);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const saved = localStorage.getItem("codify_claimed_quests");
      if (saved) {
        try {
          setClaimedIds(JSON.parse(saved));
        } catch (e) {
          console.error(e);
        }
      }
    }
  }, []);

  const streakDays = profile?.streak_days || 1;
  const currentXp = profile?.xp || 0;

  const dailyQuests: Quest[] = [
    {
      id: "daily_login",
      type: "daily",
      title: "Inicia Sesión Diario",
      description: "Entra a Codify hoy y mantén tu hábito de aprendizaje activo.",
      xpReward: 25,
      progress: 1,
      total: 1,
      completed: true,
      claimed: claimedIds.includes("daily_login"),
    },
    {
      id: "daily_1_challenge",
      type: "daily",
      title: "Resuelve 1 Lección Hoy",
      description: "Completa al menos 1 reto práctico o teórico en la plataforma.",
      xpReward: 50,
      progress: currentXp > 0 ? 1 : 0,
      total: 1,
      completed: currentXp > 0,
      claimed: claimedIds.includes("daily_1_challenge"),
    },
    {
      id: "daily_100_xp",
      type: "daily",
      title: "Acumula 100 XP Hoy",
      description: "Supera lecciones para obtener 100 puntos de experiencia.",
      xpReward: 100,
      progress: Math.min(100, currentXp),
      total: 100,
      completed: currentXp >= 100,
      claimed: claimedIds.includes("daily_100_xp"),
    },
  ];

  const weeklyQuests: Quest[] = [
    {
      id: "weekly_marathon",
      type: "weekly",
      title: "Maratón de Código Semanal",
      description: "Completa un total de 5 lecciones durante esta semana.",
      xpReward: 250,
      progress: Math.min(5, Math.floor(currentXp / 30)),
      total: 5,
      completed: currentXp >= 150,
      claimed: claimedIds.includes("weekly_marathon"),
    },
    {
      id: "weekly_streak_3",
      type: "weekly",
      title: "Constancia de Acero",
      description: "Mantén una racha ininterrumpida de 3 días consecutivos.",
      xpReward: 200,
      progress: Math.min(3, streakDays),
      total: 3,
      completed: streakDays >= 3,
      claimed: claimedIds.includes("weekly_streak_3"),
    },
    {
      id: "weekly_poo_master",
      type: "weekly",
      title: "Desarrollador Orientado a Objetos",
      description: "Avanza en las lecciones de Objetos Literales y Clases del Módulo POO.",
      xpReward: 150,
      progress: currentXp >= 200 ? 1 : 0,
      total: 1,
      completed: currentXp >= 200,
      claimed: claimedIds.includes("weekly_poo_master"),
    },
  ];

  const handleClaimReward = async (quest: Quest) => {
    if (!user || quest.claimed || !quest.completed) return;
    setClaimingId(quest.id);

    try {
      const newXp = (profile?.xp || 0) + quest.xpReward;
      const newLevel = Math.floor(newXp / 100) + 1;

      await supabase
        .from("profiles")
        .update({ xp: newXp, level: newLevel })
        .eq("id", user.id);

      const nextClaimed = [...claimedIds, quest.id];
      setClaimedIds(nextClaimed);

      if (typeof window !== "undefined") {
        localStorage.setItem("codify_claimed_quests", JSON.stringify(nextClaimed));
      }

      window.location.reload();
    } catch (e) {
      console.error("Error al reclamar recompensa:", e);
    } finally {
      setClaimingId(null);
    }
  };

  return (
    <div className="space-y-8">
      
      {/* Banner / Header */}
      <Card className="p-6 lg:p-8 glass-panel border-t-4 border-t-accent relative overflow-hidden shadow-2xl">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6">
          <div className="space-y-2">
            <div className="flex items-center gap-2 text-accent font-bold text-xs uppercase tracking-wider">
              <Gift size={16} />
              <span>Centro de Misiones y Recompensas</span>
            </div>
            <h2 className="text-3xl font-heading font-bold text-white">
              Retos Diarios y Semanales
            </h2>
            <p className="text-sm text-zinc-400 max-w-xl">
              Gana XP adicional completando objetivos del día y de la semana. ¡Reclama tus recompensas para subir de nivel rápidamente!
            </p>
          </div>

          <div className="bg-black/50 p-4 rounded-2xl border border-white/10 flex items-center gap-4 shrink-0 shadow-lg">
            <div className="text-right">
              <span className="text-xs text-zinc-400 block font-semibold">Tus Puntos XP</span>
              <span className="text-2xl font-bold text-white font-mono">{currentXp} XP</span>
            </div>
            <div className="w-12 h-12 rounded-xl bg-accent/20 border border-accent/40 flex items-center justify-center text-accent">
              <Trophy size={24} />
            </div>
          </div>
        </div>
      </Card>

      {/* SECTION 1: Daily Quests */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
            <Clock className="text-orange-400" size={20} />
            <span>Misiones Diarias (24 Horas)</span>
          </h3>
          <span className="text-xs text-zinc-400 bg-black/40 px-3 py-1 rounded-full border border-white/10 font-mono">
            Se reinician cada medianoche
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {dailyQuests.map((q) => (
            <Card key={q.id} className="p-6 glass flex flex-col justify-between space-y-4 relative overflow-hidden">
              <div className="space-y-2">
                <div className="flex justify-between items-start">
                  <span className="text-xs font-bold text-primary bg-primary/10 px-2.5 py-1 rounded-full border border-primary/20">
                    +{q.xpReward} XP
                  </span>
                  {q.claimed ? (
                    <span className="text-xs text-emerald-400 font-bold flex items-center gap-1">
                      <CheckCircle2 size={14} /> Reclamado
                    </span>
                  ) : q.completed ? (
                    <span className="text-xs text-yellow-400 font-bold animate-pulse">
                      ¡Completado!
                    </span>
                  ) : (
                    <span className="text-xs text-zinc-500 font-mono">
                      {q.progress} / {q.total}
                    </span>
                  )}
                </div>

                <h4 className="font-heading font-bold text-lg text-white">{q.title}</h4>
                <p className="text-xs text-zinc-400 leading-relaxed">{q.description}</p>
              </div>

              {/* Progress Bar & Action */}
              <div className="space-y-3 pt-2 border-t border-white/5">
                <div className="h-2 w-full bg-black/60 rounded-full overflow-hidden">
                  <div
                    className={`h-full transition-all duration-500 ${
                      q.completed ? "bg-emerald-400 shadow-[0_0_10px_rgba(52,211,153,0.5)]" : "bg-primary"
                    }`}
                    style={{ width: `${(q.progress / q.total) * 100}%` }}
                  />
                </div>

                {q.claimed ? (
                  <Button size="sm" variant="secondary" disabled className="w-full opacity-60">
                    Recompensa Reclamada
                  </Button>
                ) : q.completed ? (
                  <Button
                    size="sm"
                    onClick={() => handleClaimReward(q)}
                    isLoading={claimingId === q.id}
                    className="w-full bg-emerald-500 hover:bg-emerald-600 text-black font-bold border-none shadow-[0_0_20px_rgba(16,185,129,0.4)]"
                  >
                    🎁 Reclamar +{q.xpReward} XP
                  </Button>
                ) : (
                  <Button size="sm" variant="secondary" disabled className="w-full opacity-50">
                    En Progreso ({q.progress}/{q.total})
                  </Button>
                )}
              </div>
            </Card>
          ))}
        </div>
      </div>

      {/* SECTION 2: Weekly Challenges */}
      <div className="space-y-4 pt-4">
        <div className="flex items-center justify-between">
          <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
            <Calendar className="text-purple-400" size={20} />
            <span>Desafíos Semanales (Mayor Dificultad)</span>
          </h3>
          <span className="text-xs text-zinc-400 bg-black/40 px-3 py-1 rounded-full border border-white/10 font-mono">
            Premio especial de XP
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {weeklyQuests.map((q) => (
            <Card key={q.id} className="p-6 glass flex flex-col justify-between space-y-4 relative overflow-hidden border-l-4 border-l-purple-500">
              <div className="space-y-2">
                <div className="flex justify-between items-start">
                  <span className="text-xs font-bold text-purple-300 bg-purple-500/20 px-2.5 py-1 rounded-full border border-purple-500/30">
                    +{q.xpReward} XP
                  </span>
                  {q.claimed ? (
                    <span className="text-xs text-emerald-400 font-bold flex items-center gap-1">
                      <CheckCircle2 size={14} /> Reclamado
                    </span>
                  ) : q.completed ? (
                    <span className="text-xs text-yellow-400 font-bold animate-pulse">
                      ¡Listo!
                    </span>
                  ) : (
                    <span className="text-xs text-zinc-500 font-mono">
                      {q.progress} / {q.total}
                    </span>
                  )}
                </div>

                <h4 className="font-heading font-bold text-lg text-white">{q.title}</h4>
                <p className="text-xs text-zinc-400 leading-relaxed">{q.description}</p>
              </div>

              {/* Progress Bar & Action */}
              <div className="space-y-3 pt-2 border-t border-white/5">
                <div className="h-2 w-full bg-black/60 rounded-full overflow-hidden">
                  <div
                    className={`h-full transition-all duration-500 ${
                      q.completed ? "bg-emerald-400 shadow-[0_0_10px_rgba(52,211,153,0.5)]" : "bg-purple-500"
                    }`}
                    style={{ width: `${(q.progress / q.total) * 100}%` }}
                  />
                </div>

                {q.claimed ? (
                  <Button size="sm" variant="secondary" disabled className="w-full opacity-60">
                    Recompensa Reclamada
                  </Button>
                ) : q.completed ? (
                  <Button
                    size="sm"
                    onClick={() => handleClaimReward(q)}
                    isLoading={claimingId === q.id}
                    className="w-full bg-purple-500 hover:bg-purple-600 text-white font-bold border-none shadow-[0_0_20px_rgba(168,85,247,0.4)]"
                  >
                    🏆 Reclamar +{q.xpReward} XP
                  </Button>
                ) : (
                  <Button size="sm" variant="secondary" disabled className="w-full opacity-50">
                    En Progreso ({q.progress}/{q.total})
                  </Button>
                )}
              </div>
            </Card>
          ))}
        </div>
      </div>

    </div>
  );
}
