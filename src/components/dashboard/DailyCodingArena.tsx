"use client";

import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { 
  Swords, 
  Clock, 
  Zap, 
  CheckCircle2, 
  Play, 
  Sparkles, 
  Flame, 
  ArrowRight,
  Code2
} from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { getDailyChallengeIndices, getArenaRankInfo } from "@/lib/gamification";
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
  const { user, profile } = useUser();
  const [dailyChallenges, setDailyChallenges] = useState<Challenge[]>([]);
  const [loading, setLoading] = useState(true);
  const [timeLeft, setTimeLeft] = useState("");

  const rankInfo = getArenaRankInfo(profile?.arena_rank, profile?.arena_streak);

  // Countdown to midnight
  useEffect(() => {
    const updateCountdown = () => {
      const now = new Date();
      const midnight = new Date();
      midnight.setHours(24, 0, 0, 0);
      const diff = midnight.getTime() - now.getTime();

      const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
      const minutes = Math.floor((diff / 1000 / 60) % 60);
      const seconds = Math.floor((diff / 1000) % 60);

      setTimeLeft(
        `${hours.toString().padStart(2, "0")}h ${minutes
          .toString()
          .padStart(2, "0")}m ${seconds.toString().padStart(2, "0")}s`
      );
    };

    updateCountdown();
    const interval = setInterval(updateCountdown, 1000);
    return () => clearInterval(interval);
  }, []);

  // Fetch exclusive Arena challenges based on rank pool (defaults to Bronze pool)
  useEffect(() => {
    const fetchArenaChallenges = async () => {
      setLoading(true);
      try {
        // 1. Obtener módulo exclusivo de la Arena (Rango Bronce)
        let { data: arenaModule } = await supabase
          .from("modules")
          .select("id")
          .eq("title", "Arena de Retos: Rango Bronce")
          .maybeSingle();

        // Fallback al módulo previo si la semilla no se ha ejecutado aún
        if (!arenaModule) {
          const { data: fallbackModule } = await supabase
            .from("modules")
            .select("id")
            .eq("title", "Arena Algorítmica & Speed Coding")
            .maybeSingle();
          arenaModule = fallbackModule;
        }

        if (!arenaModule) {
          setLoading(false);
          return;
        }

        // 2. Obtener retos exclusivos del módulo de la Arena
        const { data: challengesData, error } = await supabase
          .from("challenges")
          .select("id, title, description, xp_reward, order_index, challenge_type")
          .eq("module_id", arenaModule.id)
          .order("order_index", { ascending: true });

        if (error || !challengesData || challengesData.length === 0) {
          setLoading(false);
          return;
        }

        // 3. Rotación determinista diaria de 3 retos a partir del banco
        const indices = getDailyChallengeIndices(challengesData.length);
        const selected = indices.map((idx) => challengesData[idx]);

        // 4. Verificar cuáles ha completado el usuario hoy
        if (user) {
          const ids = selected.map((c) => c.id);
          const { data: progressData } = await supabase
            .from("user_progress")
            .select("challenge_id, status")
            .eq("user_id", user.id)
            .eq("status", "completed")
            .in("challenge_id", ids);

          const completedSet = new Set(progressData?.map((p) => p.challenge_id) || []);
          setDailyChallenges(
            selected.map((c) => ({
              ...c,
              completed: completedSet.has(c.id),
            }))
          );
        } else {
          setDailyChallenges(selected);
        }
      } catch (err) {
        console.error("Error fetching daily arena challenges:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchArenaChallenges();
  }, [user]);

  const completedTodayCount = dailyChallenges.filter((c) => c.completed).length;

  const getCategoryBadge = (title: string, challengeType?: string) => {
    const lower = title.toLowerCase();
    if (lower.startsWith("redes")) {
      return { text: "Redes", color: "bg-cyan-500/20 text-cyan-400 border-cyan-500/30" };
    }
    if (lower.startsWith("lógica proposicional")) {
      return { text: "Lógica Proposicional", color: "bg-purple-500/20 text-purple-400 border-purple-500/30" };
    }
    if (lower.startsWith("fundamentos it")) {
      return { text: "Fundamentos IT", color: "bg-blue-500/20 text-blue-400 border-blue-500/30" };
    }
    if (challengeType === "quiz") {
      return { text: "Cuestionario", color: "bg-indigo-500/20 text-indigo-400 border-indigo-500/30" };
    }
    return { text: "Código JS", color: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30" };
  };

  return (
    <div className="space-y-6">
      {/* Header Banner with Rank Progression */}
      <div className="bg-gradient-to-r from-red-950/40 via-purple-950/30 to-blue-950/30 border border-red-500/20 rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl">
        <div className="absolute top-0 right-0 w-64 h-64 bg-red-500/10 rounded-full blur-3xl pointer-events-none" />
        
        <div className="flex flex-col md:flex-row md:items-start justify-between gap-6 relative z-10">
          <div>
            <div className="flex items-center gap-2 text-red-400 text-xs font-bold uppercase tracking-wider mb-2">
              <Swords size={16} className="animate-pulse" />
              <span>Arena de Retos Diarios Exclusivos</span>
            </div>
            <h2 className="text-2xl lg:text-3xl font-heading font-bold text-foreground mb-2">
              3 Retos Únicos por Rotación Diaria ⚡
            </h2>
            <p className="text-muted font-sans text-sm max-w-xl">
              Desafíos independientes no repetidos de los módulos: redes, lógica booleana, fundamentos IT y programación.
            </p>
          </div>

          {/* User Rank Card & Countdown Widget */}
          <div className="flex flex-wrap items-center gap-3 shrink-0">
            {/* Rank Card */}
            <div className={`flex items-center gap-3 px-4 py-3 rounded-2xl border ${rankInfo.color} shadow-lg backdrop-blur-sm`}>
              <span className="text-2xl">{rankInfo.badge}</span>
              <div>
                <span className="text-[10px] uppercase font-bold text-muted block font-mono">
                  Tu Rango Actual
                </span>
                <span className="text-sm font-heading font-bold text-foreground">
                  {rankInfo.label}
                </span>
              </div>
            </div>

            {/* Rotation Countdown */}
            <div className="flex items-center gap-3 bg-card border border-border px-4 py-3 rounded-2xl shadow-sm">
              <Clock size={18} className="text-red-400 animate-spin [animation-duration:8s]" />
              <div>
                <span className="text-[10px] uppercase font-bold text-muted block font-mono">
                  Rotación en
                </span>
                <span className="text-sm font-bold font-mono text-foreground">
                  {timeLeft || "00h 00m 00s"}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Promotion & Daily Progress Bar */}
        <div className="mt-6 pt-6 border-t border-border flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-4 flex-wrap">
            <div className="flex items-center gap-2">
              <span className="text-xs font-semibold text-foreground">Retos de hoy:</span>
              <span className="text-xs font-bold font-mono text-red-500">{completedTodayCount} de 3 resueltos</span>
            </div>

            {rankInfo.nextRankLabel && (
              <div className="flex items-center gap-2 pl-4 border-l border-border">
                <span className="text-xs text-muted">Ascenso a {rankInfo.nextRankLabel}:</span>
                <span className="text-xs font-bold font-mono text-amber-500">
                  {rankInfo.rank === "unranked" 
                    ? "Completa 1 reto para ser Bronce" 
                    : `${rankInfo.streak} / 3 victorias consecutivas`}
                </span>
              </div>
            )}
          </div>

          <div className="flex-1 max-w-xs h-2 bg-secondary rounded-full overflow-hidden border border-border">
            <div 
              className="h-full bg-gradient-to-r from-red-500 via-amber-500 to-primary transition-all duration-500"
              style={{ width: `${(completedTodayCount / 3) * 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Challenges Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 lg:gap-6">
        {loading ? (
          [1, 2, 3].map((n) => (
            <Card key={n} className="p-6 glass animate-pulse space-y-4">
              <div className="h-6 w-3/4 bg-secondary rounded-lg" />
              <div className="h-12 w-full bg-secondary/50 rounded-lg" />
              <div className="h-10 w-full bg-secondary rounded-xl" />
            </Card>
          ))
        ) : dailyChallenges.length === 0 ? (
          <div className="col-span-3 text-center py-12 bg-card rounded-2xl border border-border p-6 shadow-sm">
            <Code2 size={40} className="mx-auto text-muted mb-3" />
            <h4 className="text-lg font-bold text-foreground mb-1">Retos de Bronce en preparación</h4>
            <p className="text-sm text-muted">
              Ejecuta el script <code className="text-primary font-mono">seeds/29_arena_rangos_y_retos_bronce.sql</code> en Supabase para activar los 15 retos exclusivos de Bronce.
            </p>
          </div>
        ) : (
          dailyChallenges.map((challenge, idx) => {
            const catBadge = getCategoryBadge(challenge.title, challenge.challenge_type);

            return (
              <Card 
                key={challenge.id} 
                className={`p-6 glass flex flex-col justify-between transition-all relative overflow-hidden group hover:border-red-500/40 hover:-translate-y-1 shadow-sm ${
                  challenge.completed ? "border-emerald-500/30 bg-emerald-500/5" : "border-border"
                }`}
              >
                <div className="space-y-3">
                  <div className="flex items-center justify-between gap-2 flex-wrap">
                    <span className="text-xs font-mono font-bold px-2.5 py-1 rounded-lg bg-red-500/10 text-red-500 border border-red-500/20">
                      Reto #{idx + 1}
                    </span>
                    
                    <span className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md border ${catBadge.color}`}>
                      {catBadge.text}
                    </span>

                    <div className="flex items-center gap-1 text-amber-500 font-bold text-xs font-mono bg-yellow-500/10 px-2 py-0.5 rounded-full border border-yellow-500/20 ml-auto">
                      <Zap size={12} className="fill-amber-500" />
                      +{challenge.xp_reward} XP
                    </div>
                  </div>

                  <div>
                    <h3 className="font-heading font-bold text-lg text-foreground group-hover:text-red-500 transition-colors">
                      {challenge.title}
                    </h3>
                    <p className="text-xs text-muted mt-1 line-clamp-2 leading-relaxed">
                      {challenge.description}
                    </p>
                  </div>
                </div>

                <div className="mt-6 pt-4 border-t border-border">
                  {challenge.completed ? (
                    <Link href={`/ide/${challenge.id}`} className="w-full block">
                      <Button variant="outline" className="w-full border-emerald-500/40 text-emerald-500 hover:bg-emerald-500/10 flex items-center justify-center gap-2">
                        <CheckCircle2 size={16} /> Resuelto (Repetir)
                      </Button>
                    </Link>
                  ) : (
                    <Link href={`/ide/${challenge.id}`} className="w-full block">
                      <Button className="w-full bg-gradient-to-r from-red-600 to-purple-600 hover:from-red-500 hover:to-purple-500 text-white font-bold flex items-center justify-center gap-2 shadow-md">
                        <Play size={16} className="fill-white" /> Resolver Reto ⚡
                      </Button>
                    </Link>
                  )}
                </div>
              </Card>
            );
          })
        )}
      </div>
    </div>
  );
}
