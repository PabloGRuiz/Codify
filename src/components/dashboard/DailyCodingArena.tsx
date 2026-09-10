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
  Code2
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
  completed?: boolean;
}

export function DailyCodingArena() {
  const router = useRouter();
  const { user, profile } = useUser();
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [loading, setLoading] = useState(true);
  const [isQueueing, setIsQueueing] = useState(false);
  const [queueStatus, setQueueStatus] = useState("Buscando oponente...");

  const rankInfo = getArenaRankInfo(profile?.arena_rank, profile?.arena_streak);
  const isSilver = profile?.arena_rank?.toLowerCase() === "plata";

  // Cargar el banco de retos del rango correspondiente
  useEffect(() => {
    const fetchArenaChallenges = async () => {
      setLoading(true);
      try {
        const targetTitle = isSilver 
          ? "Arena de Retos: Rango Plata" 
          : "Arena de Retos: Rango Bronce";

        let { data: arenaModule } = await supabase
          .from("modules")
          .select("id, title")
          .eq("title", targetTitle)
          .maybeSingle();

        // Fallback al otro módulo si aún no se corrió la semilla
        if (!arenaModule) {
          const fallbackTitle = isSilver 
            ? "Arena de Retos: Rango Bronce" 
            : "Arena Algorítmica & Speed Coding";

          const { data: fallbackModule } = await supabase
            .from("modules")
            .select("id, title")
            .eq("title", fallbackTitle)
            .maybeSingle();

          arenaModule = fallbackModule;
        }

        if (!arenaModule) {
          setLoading(false);
          return;
        }

        // Obtener todos los retos del módulo del rango actual
        const { data: challengesData, error } = await supabase
          .from("challenges")
          .select("id, title, description, xp_reward, order_index, challenge_type")
          .eq("module_id", arenaModule.id)
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
              completed: completedSet.has(c.id),
            }))
          );
        } else {
          setChallenges(challengesData);
        }
      } catch (err) {
        console.error("Error cargando pool de retos de la arena:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchArenaChallenges();
  }, [user, isSilver]);

  // Manejo de la Cola Clasificatoria (Matchmaking)
  const handleStartMatchmaking = () => {
    if (challenges.length === 0) return;
    setIsQueueing(true);

    const statusSteps = [
      "Conectando a la red clasificatoria...",
      `Seleccionando reto de Rango ${rankInfo.label}...`,
      "¡Desafío encontrado! Preparando sala de combate...",
    ];

    statusSteps.forEach((msg, idx) => {
      setTimeout(() => {
        setQueueStatus(msg);
      }, idx * 500);
    });

    setTimeout(() => {
      // Priorizar retos no completados; si todos están completados, sortear de todos
      const uncompleted = challenges.filter((c) => !c.completed);
      const pool = uncompleted.length > 0 ? uncompleted : challenges;
      const picked = pool[Math.floor(Math.random() * pool.length)];

      router.push(`/ide/${picked.id}`);
    }, 1600);
  };

  const getCategoryBadge = (title: string, challengeType?: string) => {
    const lower = title.toLowerCase();
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

  const completedCount = challenges.filter((c) => c.completed).length;

  return (
    <div className="space-y-6">
      {/* 🎮 HERO BANNER: COLA CLASIFICATORIA & MATCHMAKING */}
      <div className="bg-gradient-to-br from-red-950/50 via-purple-950/40 to-slate-950/60 border border-red-500/30 rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl backdrop-blur-xl">
        <div className="absolute top-0 right-0 w-96 h-96 bg-gradient-to-b from-red-500/15 to-purple-500/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute -bottom-10 -left-10 w-72 h-72 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />

        <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-8 relative z-10">
          <div className="space-y-3 max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-500/10 border border-red-500/30 text-red-400 text-xs font-bold uppercase tracking-wider">
              <Swords size={14} className="animate-pulse" />
              <span>Arena Clasificatoria • Matchmaking Ilimitado</span>
            </div>

            <h2 className="text-3xl lg:text-4xl font-heading font-extrabold text-foreground tracking-tight">
              Entra en Cola y Conquista la Liga ⚡
            </h2>

            <p className="text-muted font-sans text-sm sm:text-base leading-relaxed">
              Juega sin límites diarios. Cada reto superado suma a tu racha de ascenso. Logra <strong className="text-amber-400">3 victorias consecutivas</strong> para subir de rango en tiempo real.
            </p>

            {/* Rango y Racha Visual */}
            <div className="flex flex-wrap items-center gap-4 pt-2">
              <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                <span className="text-muted">Racha Actual:</span>
                <span className="font-bold text-amber-400 flex items-center gap-1">
                  <Flame size={14} className="fill-amber-400" />
                  {rankInfo.rank === "unranked" ? "0/1 para Bronce" : `${rankInfo.streak}/3 Victorias`}
                </span>
              </div>

              {rankInfo.nextRankLabel && (
                <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                  <span className="text-muted">Siguiente Rango:</span>
                  <span className="font-bold text-foreground flex items-center gap-1">
                    <Trophy size={14} className="text-primary" />
                    {rankInfo.nextRankLabel}
                  </span>
                </div>
              )}

              <div className="flex items-center gap-2 bg-card/80 border border-border px-3.5 py-2 rounded-xl text-xs font-mono">
                <span className="text-muted">Pool de Retos:</span>
                <span className="font-bold text-primary">
                  {isSilver ? "Plata (Avanzado)" : "Bronce (Fundamentos)"}
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
                  {completedCount} desafíos superados en esta liga
                </span>
              </div>
            </div>

            {/* BOTÓN EMPAREJAR DESAFÍO (QUEUE BUTTON) */}
            <Button
              onClick={handleStartMatchmaking}
              disabled={isQueueing || loading || challenges.length === 0}
              className="relative group overflow-hidden px-8 py-6 rounded-2xl bg-gradient-to-r from-red-600 via-purple-600 to-primary hover:from-red-500 hover:to-primary text-white font-heading font-extrabold text-base lg:text-lg shadow-xl hover:shadow-red-500/25 transition-all duration-300 hover:scale-[1.02] active:scale-[0.98]"
            >
              <span className="absolute inset-0 bg-white/20 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 ease-in-out" />
              <div className="flex items-center justify-center gap-3 relative z-10">
                {isQueueing ? (
                  <>
                    <RotateCw className="animate-spin text-white" size={20} />
                    <span>{queueStatus}</span>
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
            <span className="text-xs font-bold font-mono text-muted uppercase">Progreso al Ascenso:</span>
            <div className="flex items-center gap-2">
              {[1, 2, 3].map((node) => {
                const filled = rankInfo.rank !== "unranked" && rankInfo.streak >= node;
                return (
                  <div
                    key={node}
                    className={`w-6 h-6 rounded-lg flex items-center justify-center text-xs font-bold font-mono transition-all ${
                      filled
                        ? "bg-amber-500 text-black shadow-lg shadow-amber-500/30 scale-105 ring-2 ring-amber-400"
                        : "bg-white/10 text-muted border border-white/10"
                    }`}
                  >
                    {filled ? "✓" : node}
                  </div>
                );
              })}
            </div>
            <span className="text-xs text-muted ml-2 hidden md:inline">
              {rankInfo.rank === "unranked"
                ? "Gana 1 reto para clasificar a Bronce"
                : rankInfo.streak === 2
                ? "🔥 ¡A solo 1 victoria del ascenso!"
                : `${3 - rankInfo.streak} victorias consecutivas restantes`}
            </span>
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
                <Swords size={36} className="text-red-400 animate-bounce" />
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
                <span>Rango Activo: {rankInfo.label}</span>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* BANCO DE DESAFÍOS DISPONIBLES EN TU RANGO */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-xl font-heading font-bold text-foreground flex items-center gap-2">
              <span>Pool de Combates Disponibles</span>
              <span className="text-xs font-mono font-bold px-2 py-0.5 rounded-full bg-primary/10 text-primary border border-primary/20">
                {challenges.length} Retos
              </span>
            </h3>
            <p className="text-xs text-muted">
              Puedes entrar en cola automática arriba o seleccionar manualmente cualquier reto de tu rango.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {loading ? (
            [1, 2, 3, 4, 5, 6].map((n) => (
              <Card key={n} className="p-5 glass animate-pulse space-y-3">
                <div className="h-5 w-3/4 bg-secondary rounded-md" />
                <div className="h-10 w-full bg-secondary/50 rounded-md" />
                <div className="h-9 w-full bg-secondary rounded-lg" />
              </Card>
            ))
          ) : challenges.length === 0 ? (
            <div className="col-span-3 text-center py-12 bg-card rounded-2xl border border-border p-6 shadow-sm">
              <Code2 size={40} className="mx-auto text-muted mb-3" />
              <h4 className="text-lg font-bold text-foreground mb-1">Retos en preparación</h4>
              <p className="text-sm text-muted">
                Ejecuta la semilla SQL <code className="text-primary font-mono">seeds/31_arena_retos_plata_y_expansion_bronce.sql</code> en Supabase para activar todos los retos de la Arena.
              </p>
            </div>
          ) : (
            challenges.map((challenge, idx) => {
              const catBadge = getCategoryBadge(challenge.title, challenge.challenge_type);
              const IconComp = catBadge.icon;

              return (
                <Card 
                  key={challenge.id} 
                  className={`p-5 glass flex flex-col justify-between transition-all relative overflow-hidden group hover:border-red-500/40 hover:-translate-y-1 shadow-sm ${
                    challenge.completed ? "border-emerald-500/30 bg-emerald-500/5" : "border-border"
                  }`}
                >
                  <div className="space-y-3">
                    <div className="flex items-center justify-between gap-2 flex-wrap">
                      <span className="text-[11px] font-mono font-bold px-2 py-0.5 rounded-md bg-secondary text-muted">
                        #{idx + 1}
                      </span>
                      
                      <span className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md border flex items-center gap-1 ${catBadge.color}`}>
                        <IconComp size={11} />
                        {catBadge.text}
                      </span>

                      <div className="flex items-center gap-1 text-amber-500 font-bold text-xs font-mono bg-yellow-500/10 px-2 py-0.5 rounded-full border border-yellow-500/20 ml-auto">
                        <Zap size={11} className="fill-amber-500" />
                        +{challenge.xp_reward} XP
                      </div>
                    </div>

                    <div>
                      <h4 className="font-heading font-bold text-base text-foreground group-hover:text-red-400 transition-colors line-clamp-1">
                        {challenge.title}
                      </h4>
                      <p className="text-xs text-muted mt-1 line-clamp-2 leading-relaxed">
                        {challenge.description}
                      </p>
                    </div>
                  </div>

                  <div className="mt-5 pt-3 border-t border-border">
                    <Link href={`/ide/${challenge.id}`} className="w-full block">
                      {challenge.completed ? (
                        <Button variant="outline" size="sm" className="w-full border-emerald-500/40 text-emerald-400 hover:bg-emerald-500/10 flex items-center justify-center gap-1.5 text-xs">
                          <CheckCircle2 size={14} /> Resuelto (Repetir)
                        </Button>
                      ) : (
                        <Button size="sm" className="w-full bg-gradient-to-r from-red-600 to-purple-600 hover:from-red-500 hover:to-purple-500 text-white font-bold flex items-center justify-center gap-1.5 shadow-sm text-xs">
                          <Play size={13} className="fill-white" /> Combatir ⚡
                        </Button>
                      )}
                    </Link>
                  </div>
                </Card>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}
