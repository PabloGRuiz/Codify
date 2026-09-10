"use client";

import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { 
  Swords, 
  Zap, 
  CheckCircle2, 
  Play, 
  Sparkles, 
  Flame, 
  Trophy, 
  Target, 
  RotateCw, 
  Layers, 
  Database, 
  Cpu, 
  Radio, 
  Network, 
  Code2,
  Shield,
  Crown
} from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { getArenaRankInfo } from "@/lib/gamification";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import Link from "next/link";

interface Challenge {
  id: string;
  title: string;
  description: string;
  xp_reward: number;
  order_index: number;
  challenge_type?: string;
  module_id?: string;
  rank?: "bronce" | "plata" | "oro";
  completed?: boolean;
}

export function DailyCodingArena() {
  const router = useRouter();
  const { user, profile } = useUser();
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [loading, setLoading] = useState(true);
  const [isQueueing, setIsQueueing] = useState(false);
  const [queueStatus, setQueueStatus] = useState("Buscando oponente...");
  const [queueMode, setQueueMode] = useState<"ranked" | "casual">("ranked");
  const [syncedStreak, setSyncedStreak] = useState<number | null>(null);

  const activeStreak = syncedStreak !== null ? syncedStreak : (profile?.arena_streak ?? 0);
  const rankInfo = getArenaRankInfo(profile?.arena_rank, activeStreak);
  const currentRank = profile?.arena_rank?.toLowerCase() || "unranked";
  const isSilverOrAbove = currentRank === "plata" || currentRank === "oro";
  const isGold = currentRank === "oro";

  // Auto-corrección: Si el usuario acaba de promocionar a Oro pero su racha en DB quedó en 3 por la promoción anterior
  useEffect(() => {
    if (user && profile?.arena_rank === "oro" && (profile?.arena_streak ?? 0) === 3 && syncedStreak === null) {
      supabase
        .from("profiles")
        .update({ arena_streak: 0 })
        .eq("id", user.id)
        .then(({ error }) => {
          if (!error) {
            setSyncedStreak(0);
          }
        });
    }
  }, [user, profile?.arena_rank, profile?.arena_streak, syncedStreak]);

  // Cargar todos los módulos de la arena para tener disponibles los distintos tiers
  useEffect(() => {
    const fetchArenaChallenges = async () => {
      setLoading(true);
      try {
        const eligibleTitles: string[] = [
          "Arena de Retos: Rango Bronce",
          "Arena Algorítmica & Speed Coding",
          "Arena de Retos: Rango Plata",
          "Arena de Retos: Rango Oro",
        ];

        const { data: arenaModules, error: modulesError } = await supabase
          .from("modules")
          .select("id, title")
          .in("title", eligibleTitles);

        if (modulesError || !arenaModules || arenaModules.length === 0) {
          setLoading(false);
          return;
        }

        const moduleIds = arenaModules.map((m) => m.id);
        const moduleRankMap: Record<string, "bronce" | "plata" | "oro"> = {};
        arenaModules.forEach((m) => {
          if (m.title.includes("Plata")) {
            moduleRankMap[m.id] = "plata";
          } else if (m.title.includes("Oro")) {
            moduleRankMap[m.id] = "oro";
          } else {
            moduleRankMap[m.id] = "bronce";
          }
        });

        const { data: challengesData, error } = await supabase
          .from("challenges")
          .select("id, title, description, xp_reward, order_index, challenge_type, module_id")
          .in("module_id", moduleIds)
          .order("order_index", { ascending: true });

        if (error || !challengesData || challengesData.length === 0) {
          setLoading(false);
          return;
        }

        if (user) {
          const ids = challengesData.map((c) => c.id);
          const { data: progressData } = await supabase
            .from("user_progress")
            .select("challenge_id, status")
            .eq("user_id", user.id)
            .eq("status", "completed")
            .in("challenge_id", ids);

          const completedSet = new Set(progressData?.map((p) => p.challenge_id) || []);
          setChallenges(
            challengesData.map((c) => ({
              ...c,
              rank: moduleRankMap[c.module_id] || "bronce",
              completed: completedSet.has(c.id),
            }))
          );
        } else {
          setChallenges(
            challengesData.map((c) => ({
              ...c,
              rank: moduleRankMap[c.module_id] || "bronce",
            }))
          );
        }
      } catch (err) {
        console.error("Error cargando pool de retos de la arena:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchArenaChallenges();
  }, [user, currentRank]);

  // Clasificación de retos por tier
  const bronzeChallenges = challenges.filter((c) => c.rank === "bronce");
  const silverChallenges = challenges.filter((c) => c.rank === "plata");
  const goldChallenges = challenges.filter((c) => c.rank === "oro");

  // Definir el pool activo:
  // 1. En Modo Clasificatorio:
  //    - Si NO está en promoción: SOLO retos de su rango actual
  //    - Si ESTÁ en promoción (streak >= 3): retos del TIER SIGUIENTE
  // 2. En Modo Casual (Práctica Libre):
  //    - Retos de su rango actual Y de todos los rangos anteriores desbloqueados
  let activePool: Challenge[] = [];
  if (queueMode === "ranked") {
    if (rankInfo.inPromotion) {
      if (rankInfo.rank === "bronce") {
        activePool = silverChallenges.length > 0 ? silverChallenges : bronzeChallenges;
      } else if (rankInfo.rank === "plata") {
        activePool = goldChallenges.length > 0 ? goldChallenges : silverChallenges;
      } else {
        activePool = goldChallenges.length > 0 ? goldChallenges : silverChallenges;
      }
    } else {
      if (rankInfo.rank === "plata") {
        activePool = silverChallenges;
      } else if (rankInfo.rank === "oro") {
        activePool = goldChallenges.length > 0 ? goldChallenges : silverChallenges;
      } else {
        activePool = bronzeChallenges;
      }
    }
  } else {
    // Cola Casual: incluye su rango actual y los anteriores
    if (rankInfo.rank === "oro") {
      activePool = [...goldChallenges, ...silverChallenges, ...bronzeChallenges];
    } else if (rankInfo.rank === "plata") {
      activePool = [...silverChallenges, ...bronzeChallenges];
    } else {
      activePool = bronzeChallenges;
    }
  }

  const completedCount = activePool.filter((c) => c.completed).length;

  // Manejo del Matchmaking
  const handleStartMatchmaking = () => {
    if (activePool.length === 0) return;
    setIsQueueing(true);

    let statusSteps: string[] = [];

    if (queueMode === "casual") {
      statusSteps = [
        "Conectando a la red casual de práctica...",
        "Seleccionando reto de entrenamiento (Racha protegida)...",
        "¡Desafío encontrado! Preparando sala casual...",
      ];
    } else if (rankInfo.inPromotion) {
      statusSteps = [
        "🔥 Verificando credenciales de Fase de Promoción...",
        `⚔️ Buscando examen de ascenso en Rango ${rankInfo.nextRankLabel}...`,
        "¡Examen de Promoción emparejado! Que comience el duelo...",
      ];
    } else {
      statusSteps = [
        "Conectando a la red clasificatoria...",
        `Seleccionando reto exclusivo de Rango ${rankInfo.label}...`,
        "¡Desafío emparejado! Preparando sala del reto...",
      ];
    }

    statusSteps.forEach((msg, idx) => {
      setTimeout(() => {
        setQueueStatus(msg);
      }, idx * 500);
    });

    setTimeout(() => {
      const uncompleted = activePool.filter((c) => !c.completed);
      const pool = uncompleted.length > 0 ? uncompleted : activePool;
      const picked = pool[Math.floor(Math.random() * pool.length)];

      router.push(`/ide/${picked.id}?mode=${queueMode}`);
    }, 1600);
  };

  const getCategoryBadge = (title: string, challengeType?: string) => {
    const lower = title.toLowerCase();
    if (lower.startsWith("sistemas operativos") || lower.startsWith("concurrencia") || lower.startsWith("sistemas & concurrencia")) {
      return { text: "Sistemas & SO", color: "bg-red-500/20 text-red-400 border-red-500/30", icon: Cpu };
    }
    if (lower.startsWith("arquitectura distribuida") || lower.startsWith("arquitectura backend")) {
      return { text: "Arquitectura", color: "bg-purple-500/20 text-purple-400 border-purple-500/30", icon: Layers };
    }
    if (lower.startsWith("ciberseguridad") || lower.startsWith("criptografía")) {
      return { text: "Ciberseguridad", color: "bg-teal-500/20 text-teal-400 border-teal-500/30", icon: Shield };
    }
    if (lower.startsWith("estructuras de datos")) {
      return { text: "Estructuras de Datos", color: "bg-violet-500/20 text-violet-400 border-violet-500/30", icon: Layers };
    }
    if (lower.startsWith("redes avanzadas")) {
      return { text: "Redes Avanzadas", color: "bg-cyan-500/20 text-cyan-400 border-cyan-500/30", icon: Network };
    }
    if (lower.startsWith("bases de datos")) {
      return { text: "Bases de Datos", color: "bg-amber-500/20 text-amber-400 border-amber-500/30", icon: Database };
    }
    if (lower.startsWith("redes")) {
      return { text: "Redes & OSI", color: "bg-cyan-500/20 text-cyan-400 border-cyan-500/30", icon: Network };
    }
    if (lower.startsWith("hardware")) {
      return { text: "Arquitectura HW", color: "bg-blue-500/20 text-blue-400 border-blue-500/30", icon: Cpu };
    }
    if (lower.startsWith("electrónica")) {
      return { text: "Electrónica", color: "bg-orange-500/20 text-orange-400 border-orange-500/30", icon: Radio };
    }
    if (lower.startsWith("algoritmos") || lower.startsWith("lógica de código")) {
      return { text: "Algoritmos", color: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30", icon: Code2 };
    }
    if (lower.startsWith("lógica proposicional")) {
      return { text: "Lógica Proposicional", color: "bg-purple-500/20 text-purple-400 border-purple-500/30", icon: Layers };
    }
    if (lower.startsWith("fundamentos it")) {
      return { text: "Fundamentos IT", color: "bg-indigo-500/20 text-indigo-400 border-indigo-500/30", icon: Layers };
    }
    if (challengeType === "quiz") {
      return { text: "Cuestionario", color: "bg-indigo-500/20 text-indigo-400 border-indigo-500/30", icon: Target };
    }
    return { text: "Código", color: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30", icon: Code2 };
  };

  return (
    <div className="space-y-6">
      {/* 🎮 SELECTOR DE MODALIDAD: RANKED VS CASUAL */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2 p-1.5 bg-black/40 border border-white/10 rounded-2xl backdrop-blur-md">
          <button
            type="button"
            onClick={() => setQueueMode("ranked")}
            className={`flex items-center gap-2.5 px-4 sm:px-5 py-2.5 rounded-xl text-xs sm:text-sm font-bold font-heading transition-all ${
              queueMode === "ranked"
                ? (rankInfo.inPromotion
                    ? "bg-gradient-to-r from-amber-500 via-orange-500 to-red-500 text-black shadow-lg shadow-amber-500/30 ring-2 ring-amber-300 scale-105"
                    : "bg-red-600 text-white shadow-lg shadow-red-600/30 ring-2 ring-red-500/40")
                : "text-muted hover:text-white hover:bg-white/5"
            }`}
          >
            <Swords size={16} className={queueMode === "ranked" ? "animate-pulse" : ""} />
            <span>Cola Clasificatoria</span>
            {rankInfo.inPromotion && (
              <span className="bg-black/90 text-amber-300 text-[10px] uppercase px-2 py-0.5 rounded-full font-mono font-black animate-bounce shadow">
                PROMO
              </span>
            )}
          </button>

          <button
            type="button"
            onClick={() => setQueueMode("casual")}
            className={`flex items-center gap-2.5 px-4 sm:px-5 py-2.5 rounded-xl text-xs sm:text-sm font-bold font-heading transition-all ${
              queueMode === "casual"
                ? "bg-blue-600 text-white shadow-lg shadow-blue-600/30 ring-2 ring-blue-500/40"
                : "text-muted hover:text-white hover:bg-white/5"
            }`}
          >
            <Shield size={16} />
            <span>Cola Casual (Práctica Libre)</span>
            <span className="bg-blue-500/20 text-blue-300 text-[10px] uppercase px-2 py-0.5 rounded-full font-mono hidden sm:inline">
              Sin Riesgo
            </span>
          </button>
        </div>

        <div className="text-xs font-mono text-muted flex items-center gap-2 bg-card/60 border border-border px-3.5 py-2 rounded-xl">
          {queueMode === "ranked" ? (
            rankInfo.inPromotion ? (
              <span className="text-amber-400 font-bold flex items-center gap-1.5 animate-pulse">
                <Crown size={15} /> ¡Fase de Promoción Activa!
              </span>
            ) : (
              <span className="text-red-400 font-medium flex items-center gap-1.5">
                <Swords size={15} /> Clasificatoria (Suma Racha)
              </span>
            )
          ) : (
            <span className="text-blue-400 font-medium flex items-center gap-1.5">
              <Shield size={15} /> Racha Clasificatoria Protegida
            </span>
          )}
        </div>
      </div>

      {/* 🎮 HERO BANNER DINÁMICO SEGÚN MODO */}
      <div 
        className={`border rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl backdrop-blur-xl transition-all duration-500 ${
          queueMode === "casual"
            ? "bg-gradient-to-br from-blue-950/60 via-slate-950/60 to-indigo-950/60 border-blue-500/30"
            : rankInfo.inPromotion
            ? "bg-gradient-to-br from-amber-950/70 via-red-950/50 to-slate-950/70 border-amber-500/50 shadow-[0_0_50px_rgba(245,158,11,0.2)]"
            : "bg-gradient-to-br from-red-950/50 via-purple-950/40 to-slate-950/60 border-red-500/30"
        }`}
      >
        <div className="absolute top-0 right-0 w-96 h-96 bg-gradient-to-b from-red-500/15 to-purple-500/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute -bottom-10 -left-10 w-72 h-72 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />

        <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-8 relative z-10">
          <div className="space-y-3 max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider border">
              {queueMode === "casual" ? (
                <div className="flex items-center gap-2 text-blue-400 border-blue-500/30 bg-blue-500/10">
                  <Shield size={14} />
                  <span>Cola Casual • Práctica Multirango sin Riesgo</span>
                </div>
              ) : rankInfo.inPromotion ? (
                <div className="flex items-center gap-2 text-amber-300 border-amber-500/40 bg-amber-500/20 font-black">
                  <Crown size={14} className="animate-bounce text-amber-400" />
                  <span>Examen de Ascenso • Fase de Promoción</span>
                </div>
              ) : (
                <div className="flex items-center gap-2 text-red-400 border-red-500/30 bg-red-500/10">
                  <Swords size={14} className="animate-pulse" />
                  <span>Arena Clasificatoria • Racha de Ascenso</span>
                </div>
              )}
            </div>

            <h2 className="text-3xl lg:text-4xl font-heading font-extrabold text-foreground tracking-tight">
              {queueMode === "casual" ? (
                "Entrena y Perfecciona sin Límites 🛡️"
              ) : rankInfo.inPromotion ? (
                `¡Desafío de Promoción a ${rankInfo.nextRankLabel}! 👑`
              ) : (
                "Entra en Cola y Conquista la Liga ⚡"
              )}
            </h2>

            <p className="text-muted font-sans text-sm sm:text-base leading-relaxed">
              {queueMode === "casual" ? (
                <>
                  Practica con retos de tu rango (<strong className="text-blue-400">{rankInfo.label}</strong>) y de rangos anteriores ya desbloqueados. Suma XP y domina los desafíos <strong className="text-emerald-400">sin arriesgar tu racha clasificatoria</strong>.
                </>
              ) : rankInfo.inPromotion ? (
                <>
                  ¡Racha de 3 victorias conseguida! Para sellar tu ascenso a <strong className="text-amber-400">{rankInfo.nextRankLabel}</strong>, debes vencer este examen del tier superior. Si ganas, asciendes con racha limpia de 0/3 en tu nueva liga.
                </>
              ) : rankInfo.rank === "oro" ? (
                <>
                  Compite en la máxima categoría (<strong className="text-amber-400">Oro</strong>). Enfréntate a desafíos avanzados de concurrencia, sistemas distribuidos y bases de datos para defender tu <strong className="text-amber-400">racha invicto</strong>.
                </>
              ) : (
                <>
                  Juega retos exclusivos de tu rango (<strong className="text-amber-400">{rankInfo.label}</strong>). Logra <strong className="text-amber-400">3 victorias consecutivas</strong> para desbloquear tu Desafío de Promoción al siguiente rango.
                </>
              )}
            </p>

            {/* Rango y Racha Visual */}
            <div className="flex flex-wrap items-center gap-4 pt-2">
              <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                <span className="text-muted">
                  {rankInfo.rank === "oro" ? "Racha Invicto:" : "Racha Clasificatoria:"}
                </span>
                <span className="font-bold text-amber-400 flex items-center gap-1">
                  <Flame size={14} className="fill-amber-400" />
                  {rankInfo.rank === "unranked" 
                    ? "0/1 para Bronce" 
                    : rankInfo.rank === "oro"
                    ? `${rankInfo.streak} Victorias (Cumbre)`
                    : rankInfo.inPromotion 
                    ? "3/3 (En Promoción)" 
                    : `${rankInfo.streak}/3 Victorias`}
                </span>
              </div>

              {rankInfo.nextRankLabel && (
                <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                  <span className="text-muted">Objetivo de Ascenso:</span>
                  <span className="font-bold text-foreground flex items-center gap-1">
                    <Trophy size={14} className="text-primary" />
                    {rankInfo.nextRankLabel}
                  </span>
                </div>
              )}

              <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                <span className="text-muted">Pool en Cola:</span>
                <span className="font-bold text-primary">
                  {queueMode === "casual"
                    ? rankInfo.rank === "plata" 
                      ? "Plata + Bronce (Práctica)" 
                      : rankInfo.rank === "oro" 
                      ? "Oro + Plata + Bronce" 
                      : "Bronce (Práctica)"
                    : rankInfo.inPromotion
                    ? `Tier Superior (${rankInfo.nextRankLabel})`
                    : `Exclusivo ${rankInfo.label}`}
                </span>
              </div>
            </div>
          </div>

          {/* TARJETA DE ESTADO DE RANGO Y BOTÓN DE COLA */}
          <div className="w-full lg:w-auto flex flex-col sm:flex-row lg:flex-col items-stretch lg:items-end gap-4 shrink-0">
            {/* Medalla de Rango */}
            <div className={`flex items-center gap-4 px-5 py-4 rounded-2xl border ${rankInfo.color} shadow-xl backdrop-blur-md`}>
              <span className="text-4xl drop-shadow-md">{rankInfo.badge}</span>
              <div>
                <span className="text-[10px] uppercase font-bold text-muted block font-mono">
                  Tu Rango Actual
                </span>
                <span className="text-xl font-heading font-extrabold text-foreground">
                  {rankInfo.label}
                </span>
                <span className="text-xs text-muted block mt-0.5">
                  {completedCount} superados en este pool
                </span>
              </div>
            </div>

            {/* BOTÓN EMPAREJAR DESAFÍO (QUEUE BUTTON) */}
            <Button
              onClick={handleStartMatchmaking}
              disabled={isQueueing || loading || activePool.length === 0}
              className={`relative group overflow-hidden px-8 py-6 rounded-2xl text-white font-heading font-extrabold text-base lg:text-lg shadow-xl transition-all duration-300 hover:scale-[1.02] active:scale-[0.98] ${
                queueMode === "casual"
                  ? "bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 hover:from-blue-500 hover:to-indigo-500 shadow-blue-500/25"
                  : rankInfo.inPromotion
                  ? "bg-gradient-to-r from-amber-500 via-orange-600 to-red-600 hover:from-amber-400 hover:to-red-500 shadow-amber-500/40 ring-2 ring-amber-300"
                  : "bg-gradient-to-r from-red-600 via-purple-600 to-primary hover:from-red-500 hover:to-primary shadow-red-500/25"
              }`}
            >
              <span className="absolute inset-0 bg-white/20 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 ease-in-out" />
              <div className="flex items-center justify-center gap-3 relative z-10">
                {isQueueing ? (
                  <>
                    <RotateCw className="animate-spin text-white" size={20} />
                    <span>{queueStatus}</span>
                  </>
                ) : queueMode === "casual" ? (
                  <>
                    <Shield size={22} className="group-hover:scale-110 transition-transform duration-300" />
                    <span>BUSCAR RETO CASUAL 🎯</span>
                  </>
                ) : rankInfo.inPromotion ? (
                  <>
                    <Crown size={22} className="group-hover:rotate-12 transition-transform duration-300 text-amber-200" />
                    <span>⚔️ JUGAR DESAFÍO DE PROMOCIÓN ({rankInfo.nextRankLabel?.toUpperCase()}) ⚡</span>
                  </>
                ) : (
                  <>
                    <Swords size={22} className="group-hover:rotate-12 transition-transform duration-300" />
                    <span>BUSCAR RETO CLASIFICATORIO ⚡</span>
                  </>
                )}
              </div>
            </Button>
          </div>
        </div>

        {/* Barra de Racha Hacia el Ascenso */}
        <div className="mt-8 pt-6 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3 w-full sm:w-auto">
            <span className="text-xs font-bold font-mono text-muted uppercase">
              {rankInfo.rank === "oro" ? "Racha en la Cumbre:" : "Progreso al Ascenso:"}
            </span>
            {rankInfo.rank === "oro" ? (
              <div className="flex items-center gap-2">
                <div className="px-3 py-1 bg-amber-500/10 border border-amber-500/30 rounded-lg text-amber-400 font-mono font-bold text-xs flex items-center gap-1.5">
                  <Flame size={14} className="fill-amber-400" />
                  <span>{rankInfo.streak} Victorias Consecutivas</span>
                </div>
                <span className="text-xs text-muted ml-2">
                  👑 ¡Rango Máximo Alcanzado! Defiende tu racha invicto en la cima de Codify.
                </span>
              </div>
            ) : (
              <>
                <div className="flex items-center gap-2">
                  {[1, 2, 3].map((node) => {
                    const filled = rankInfo.rank !== "unranked" && rankInfo.streak >= node;
                    const isPromoNode = node === 3 && rankInfo.inPromotion;
                    return (
                      <div
                        key={node}
                        className={`w-7 h-7 rounded-lg flex items-center justify-center text-xs font-bold font-mono transition-all ${
                          isPromoNode
                            ? "bg-gradient-to-r from-amber-400 to-orange-500 text-black shadow-lg shadow-amber-500/50 scale-110 ring-2 ring-amber-300 animate-pulse"
                            : filled
                            ? "bg-amber-500 text-black shadow-lg shadow-amber-500/30 scale-105 ring-2 ring-amber-400"
                            : "bg-white/10 text-muted border border-white/10"
                        }`}
                      >
                        {isPromoNode ? "⚔️" : filled ? "✓" : node}
                      </div>
                    );
                  })}
                </div>
                <span className="text-xs text-muted ml-2 hidden md:inline">
                  {rankInfo.rank === "unranked"
                    ? "Gana 1 reto para clasificar a Bronce"
                    : rankInfo.inPromotion
                    ? "🔥 ¡Racha 3/3 completa! Desafío de promoción activo."
                    : rankInfo.streak === 2
                    ? "🔥 ¡A 1 victoria de la Fase de Promoción!"
                    : `${3 - rankInfo.streak} victorias restantes para la promoción`}
                </span>
              </>
            )}
          </div>

          <div className="text-xs text-muted font-mono flex items-center gap-2">
            <Sparkles size={14} className="text-amber-400" />
            <span>3 intentos por reto en el IDE</span>
          </div>
        </div>
      </div>

      {/* POPUP DE MATCHMAKING EN VIVO */}
      <AnimatePresence>
        {isQueueing && (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="fixed inset-0 bg-black/80 backdrop-blur-md z-50 flex items-center justify-center p-4"
          >
            <div className="bg-card border border-red-500/40 p-8 rounded-3xl max-w-md w-full text-center space-y-6 shadow-2xl relative overflow-hidden">
              <div className="absolute -top-20 -right-20 w-48 h-48 bg-red-500/20 rounded-full blur-2xl pointer-events-none" />
              
              <div className="relative mx-auto w-24 h-24 flex items-center justify-center">
                <div className="absolute inset-0 rounded-full border-4 border-red-500/20 border-t-red-500 animate-spin" />
                <div className="absolute inset-2 rounded-full border-4 border-purple-500/20 border-b-purple-500 animate-spin [animation-direction:reverse] [animation-duration:1.5s]" />
                {queueMode === "casual" ? (
                  <Shield size={36} className="text-blue-400 animate-bounce" />
                ) : rankInfo.inPromotion ? (
                  <Crown size={36} className="text-amber-400 animate-bounce" />
                ) : (
                  <Swords size={36} className="text-red-400 animate-bounce" />
                )}
              </div>

              <div>
                <h3 className="text-2xl font-heading font-extrabold text-foreground mb-1">
                  Emparejando Desafío
                </h3>
                <p className="text-sm text-muted font-mono animate-pulse">
                  {queueStatus}
                </p>
              </div>

              <div className="flex items-center justify-center gap-2 text-xs font-mono text-amber-400 bg-amber-500/10 py-2 px-4 rounded-xl border border-amber-500/20">
                <Zap size={14} />
                <span>
                  {queueMode === "casual" 
                    ? "Modalidad: Práctica Casual (Segura)" 
                    : rankInfo.inPromotion 
                    ? `¡Desafío de Promoción a ${rankInfo.nextRankLabel}!` 
                    : `Rango Activo: ${rankInfo.label}`}
                </span>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* PANEL DE INTELIGENCIA DE LIGA & REGLAS CLASIFICATORIAS */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Tarjeta 1: Disciplinas */}
        <Card className="p-6 glass border-border space-y-4 shadow-sm">
          <div className="flex items-center gap-2 text-primary font-bold text-sm">
            <Layers size={18} />
            <span>
              {queueMode === "casual"
                ? "Disciplinas de Práctica Libre"
                : rankInfo.inPromotion
                ? `Examen de Ascenso (${rankInfo.nextRankLabel})`
                : `Disciplinas de tu Liga (${rankInfo.label})`}
            </span>
          </div>
          <p className="text-xs text-muted leading-relaxed">
            {rankInfo.inPromotion && queueMode === "ranked"
              ? `El desafío de promoción evaluará tus conocimientos en los temas avanzados de Rango ${rankInfo.nextRankLabel}:`
              : `Las siguientes áreas temáticas forman parte del catálogo activo de este modo:`}
          </p>

          <div className="space-y-2 pt-1">
            {(isGold || (rankInfo.inPromotion && rankInfo.rank === "plata" && queueMode === "ranked")) ? (
              <>
                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-red-500/10 border border-red-500/20 text-xs">
                  <Cpu size={15} className="text-red-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Concurrencia & Sistemas Operativos</span>
                    <span className="text-[11px] text-muted">Condiciones de Coffman, Mutex vs Semáforos, TLB</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-purple-500/10 border border-purple-500/20 text-xs">
                  <Layers size={15} className="text-purple-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Arquitectura Distribuida</span>
                    <span className="text-[11px] text-muted">Teorema CAP, Idempotency Keys, Circuit Breaker</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/20 text-xs">
                  <Database size={15} className="text-amber-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Bases de Datos Avanzadas</span>
                    <span className="text-[11px] text-muted">MVCC en PostgreSQL, Niveles ANSI SQL, Sharding</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-teal-500/10 border border-teal-500/20 text-xs">
                  <Shield size={15} className="text-teal-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Ciberseguridad & Criptografía</span>
                    <span className="text-[11px] text-muted">TLS Híbrido, Hashing con Argon2/Bcrypt, HttpOnly</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-xs">
                  <Network size={15} className="text-cyan-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Redes & Transporte HTTP/3</span>
                    <span className="text-[11px] text-muted">Subnetting CIDR, QUIC sobre UDP, HOL Blocking</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-xs">
                  <Code2 size={15} className="text-emerald-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Algoritmos de Nivel Superior</span>
                    <span className="text-[11px] text-muted">Kadane O(N), Ciclos en Grafos, LRU Cache, Token Bucket</span>
                  </div>
                </div>
              </>
            ) : ((rankInfo.inPromotion && rankInfo.rank === "bronce" && queueMode === "ranked") || isSilverOrAbove) ? (
              <>
                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/20 text-xs">
                  <Database size={15} className="text-amber-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Bases de Datos</span>
                    <span className="text-[11px] text-muted">ACID vs BASE, Índices B-Tree, Normalización</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-xs">
                  <Network size={15} className="text-cyan-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Redes & Modelo OSI</span>
                    <span className="text-[11px] text-muted">Troubleshooting en 7 capas, Handshake TCP, DNS</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-blue-500/10 border border-blue-500/20 text-xs">
                  <Cpu size={15} className="text-blue-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Hardware & Arquitectura</span>
                    <span className="text-[11px] text-muted">Cachés L1/L2/L3, CPU vs GPU, Cuellos de botella</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-orange-500/10 border border-orange-500/20 text-xs">
                  <Radio size={15} className="text-orange-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Electrónica Básica</span>
                    <span className="text-[11px] text-muted">Ley de Ohm, Pines flotantes, Pull-Up/Down</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-xs">
                  <Code2 size={15} className="text-emerald-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Algoritmos O(N) & Big-O</span>
                    <span className="text-[11px] text-muted">Two-Sum, Búsqueda Binaria, Matrices 2D</span>
                  </div>
                </div>
              </>
            ) : (
              <>
                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-xs">
                  <Network size={15} className="text-cyan-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Redes Básicas</span>
                    <span className="text-[11px] text-muted">Puertos estándar, IPs privadas vs públicas, Gateways</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-purple-500/10 border border-purple-500/20 text-xs">
                  <Layers size={15} className="text-purple-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Lógica Proposicional</span>
                    <span className="text-[11px] text-muted">Operador XOR, Tablas de verdad, Compuertas lógicas</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/20 text-xs">
                  <Target size={15} className="text-indigo-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Fundamentos IT</span>
                    <span className="text-[11px] text-muted">Comandos de terminal CLI, memoria y periféricos</span>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-xs">
                  <Code2 size={15} className="text-emerald-400 shrink-0" />
                  <div>
                    <span className="font-bold text-foreground block">Lógica de Código Base</span>
                    <span className="text-[11px] text-muted">Par o impar, sumatorias, filtros y strings</span>
                  </div>
                </div>
              </>
            )}

            {queueMode === "casual" && isSilverOrAbove && (
              <div className="flex items-center gap-2 p-2 rounded-xl bg-blue-500/10 border border-blue-500/20 text-xs text-blue-300 font-medium mt-2">
                <Shield size={14} className="shrink-0 text-blue-400" />
                <span>Incluye también rotación de retos de Bronce para entrenamiento rápido.</span>
              </div>
            )}
          </div>
        </Card>

        {/* Tarjeta 2: Reglas de Emparejamiento */}
        <Card className="p-6 glass border-border space-y-4 shadow-sm">
          <div className="flex items-center gap-2 text-amber-400 font-bold text-sm">
            <Target size={18} />
            <span>Reglas de Combate Clasificatorio</span>
          </div>
          <p className="text-xs text-muted leading-relaxed">
            Las normas que rigen el sistema competitivo y de entrenamiento:
          </p>

          <div className="space-y-3 pt-1 text-xs">
            <div className="flex items-start gap-3">
              <span className="w-5 h-5 rounded-full bg-primary/20 text-primary flex items-center justify-center font-bold text-[10px] shrink-0 mt-0.5">
                1
              </span>
              <p className="text-muted leading-relaxed">
                <strong className="text-foreground">Colas Clasificatoria vs Casual:</strong> En clasificatoria compites exclusivamente con retos de tu nivel para sumar racha. En casual entrenas con retos de tu nivel y anteriores sin riesgo.
              </p>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-5 h-5 rounded-full bg-primary/20 text-primary flex items-center justify-center font-bold text-[10px] shrink-0 mt-0.5">
                2
              </span>
              <p className="text-muted leading-relaxed">
                <strong className="text-foreground">Fase de Promoción (3/3):</strong> Al lograr 3 victorias consecutivas, tu próxima partida será un Desafío de Promoción del tier superior.
              </p>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-5 h-5 rounded-full bg-primary/20 text-primary flex items-center justify-center font-bold text-[10px] shrink-0 mt-0.5">
                3
              </span>
              <p className="text-muted leading-relaxed">
                <strong className="text-foreground">Ascenso Limpio:</strong> Si vences el desafío de promoción, asciendes de rango y tu racha arranca en 0/3 en tu nuevo tier.
              </p>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-5 h-5 rounded-full bg-primary/20 text-primary flex items-center justify-center font-bold text-[10px] shrink-0 mt-0.5">
                4
              </span>
              <p className="text-muted leading-relaxed">
                <strong className="text-foreground">3 Vidas por Desafío:</strong> Dispones de 3 intentos antes de que el reto se considere fallido (lo que reinicia tu racha a 0/3).
              </p>
            </div>
          </div>
        </Card>

        {/* Tarjeta 3: Estadísticas & Preparación */}
        <Card className="p-6 glass border-border space-y-4 shadow-sm flex flex-col justify-between">
          <div className="space-y-4">
            <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm">
              <Trophy size={18} />
              <span>Tu Rendimiento en {rankInfo.label}</span>
            </div>

            <div className="grid grid-cols-2 gap-3 pt-1">
              <div className="bg-card/70 border border-border p-3.5 rounded-2xl text-center space-y-1">
                <span className="text-[10px] font-mono font-bold text-muted uppercase block">Dominados</span>
                <span className="text-2xl font-heading font-extrabold text-foreground block">
                  {completedCount}
                </span>
                <span className="text-[10px] text-emerald-400 font-mono">
                  {activePool.length > 0 ? `${Math.round((completedCount / activePool.length) * 100)}% dominado` : "0%"}
                </span>
              </div>

              <div className="bg-card/70 border border-border p-3.5 rounded-2xl text-center space-y-1">
                <span className="text-[10px] font-mono font-bold text-muted uppercase block">Pool Activo</span>
                <span className="text-2xl font-heading font-extrabold text-foreground block">
                  {activePool.length}
                </span>
                <span className="text-[10px] text-muted font-mono">
                  {queueMode === "casual" ? "Entrenamiento" : rankInfo.inPromotion ? "Tier Superior" : "Clasificatorio"}
                </span>
              </div>
            </div>

            <div className="p-3.5 rounded-2xl bg-secondary/50 border border-border text-xs space-y-2">
              <div className="flex items-center justify-between font-mono text-[11px]">
                <span className="text-muted">
                  {rankInfo.rank === "oro" ? "Racha Invicto:" : "Racha Clasificatoria:"}
                </span>
                <span className="font-bold text-amber-400">
                  {rankInfo.rank === "oro"
                    ? `${rankInfo.streak} Victorias`
                    : rankInfo.inPromotion
                    ? "3 / 3 (Promoción)"
                    : `${rankInfo.streak} / 3`}
                </span>
              </div>
              <div className="w-full h-1.5 bg-black/40 rounded-full overflow-hidden">
                <div 
                  className={`h-full transition-all duration-300 ${
                    rankInfo.rank === "oro"
                      ? "bg-gradient-to-r from-amber-400 to-amber-200"
                      : rankInfo.inPromotion 
                      ? "bg-gradient-to-r from-amber-400 via-orange-500 to-red-500 animate-pulse" 
                      : "bg-gradient-to-r from-amber-500 to-primary"
                  }`}
                  style={{ width: `${rankInfo.rank === "oro" ? Math.min(100, Math.max(8, rankInfo.streak * 20)) : (rankInfo.streak / 3) * 100}%` }}
                />
              </div>
            </div>
          </div>

          <div className="pt-2">
            <Button
              onClick={handleStartMatchmaking}
              disabled={isQueueing || loading || activePool.length === 0}
              className={`w-full text-white font-bold py-3 text-xs shadow-md flex items-center justify-center gap-2 ${
                queueMode === "casual"
                  ? "bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500"
                  : rankInfo.inPromotion
                  ? "bg-gradient-to-r from-amber-500 to-red-600 hover:from-amber-400 hover:to-red-500"
                  : "bg-gradient-to-r from-red-600 to-purple-600 hover:from-red-500 hover:to-purple-500"
              }`}
            >
              <Play size={14} className="fill-white" />
              <span>
                {queueMode === "casual" 
                  ? "Entrenar en Cola Casual" 
                  : rankInfo.inPromotion 
                  ? "Jugar Desafío de Promoción" 
                  : "Entrar en Cola Clasificatoria"}
              </span>
            </Button>
          </div>
        </Card>
      </div>
    </div>
  );
}
