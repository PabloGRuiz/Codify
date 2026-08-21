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
import { getDailyChallengeIndices } from "@/lib/gamification";
import Link from "next/link";

interface Challenge {
  id: string;
  title: string;
  description: string;
  xp_reward: number;
  order_index: number;
  completed?: boolean;
}

export function DailyCodingArena() {
  const { user } = useUser();
  const [dailyChallenges, setDailyChallenges] = useState<Challenge[]>([]);
  const [loading, setLoading] = useState(true);
  const [timeLeft, setTimeLeft] = useState("");

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

  // Fetch Arena challenges and rotate 3 daily
  useEffect(() => {
    const fetchArenaChallenges = async () => {
      setLoading(true);
      try {
        // 1. Get default base module (Logic & IT Fundamentals)
        const { data: defaultModule } = await supabase
          .from("modules")
          .select("id")
          .eq("title", "Arena de Lógica y Fundamentos")
          .single();

        let allowedModuleIds: string[] = [];
        if (defaultModule) {
          allowedModuleIds.push(defaultModule.id);
        }

        // 2. Get user enrolled courses to unlock advanced challenges
        if (user) {
          const { data: enrollments } = await supabase
            .from("course_enrollments")
            .select("courses(modules(id))")
            .eq("user_id", user.id);
          
          if (enrollments) {
            enrollments.forEach((enr: any) => {
              if (enr.courses?.modules) {
                enr.courses.modules.forEach((m: any) => {
                  allowedModuleIds.push(m.id);
                });
              }
            });
          }
        }

        // 3. Fallback to Speed Coding only if no logic module exists and user not logged in
        if (allowedModuleIds.length === 0) {
           const { data: speedModule } = await supabase
            .from("modules")
            .select("id")
            .eq("title", "Arena Algorítmica & Speed Coding")
            .single();
           if (speedModule) allowedModuleIds.push(speedModule.id);
        }

        if (allowedModuleIds.length === 0) {
          setLoading(false);
          return;
        }

        // 4. Get all allowed challenges
        const { data: challengesData, error } = await supabase
          .from("challenges")
          .select("id, title, description, xp_reward, order_index")
          .in("module_id", allowedModuleIds)
          .order("order_index", { ascending: true });

        if (error || !challengesData || challengesData.length === 0) {
          setLoading(false);
          return;
        }

        // 5. Deterministic rotation of 3 challenges for today
        const indices = getDailyChallengeIndices(challengesData.length);
        const selected = indices.map((idx) => challengesData[idx]);

        // 6. Check user completions if logged in
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

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-red-950/40 via-purple-950/30 to-blue-950/30 border border-red-500/20 rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl">
        <div className="absolute top-0 right-0 w-64 h-64 bg-red-500/10 rounded-full blur-3xl pointer-events-none" />
        
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
          <div>
            <div className="flex items-center gap-2 text-red-400 text-xs font-bold uppercase tracking-wider mb-2">
              <Swords size={16} className="animate-pulse" />
              <span>Formación Diaria Activa</span>
            </div>
            <h2 className="text-2xl lg:text-3xl font-heading font-bold text-white mb-2">
              3 Retos de Lógica y Especialidad ⚡
            </h2>
            <p className="text-zinc-400 font-sans text-sm max-w-xl">
              Mejora tus habilidades como responsable informático resolviendo cuestionarios de lógica, fundamentos IT y ejercicios prácticos de los cursos en los que estás inscrito.
            </p>
          </div>

          <div className="flex items-center gap-4 shrink-0 bg-black/40 border border-white/10 px-5 py-3.5 rounded-2xl">
            <Clock size={20} className="text-red-400 animate-spin [animation-duration:8s]" />
            <div>
              <span className="text-[10px] uppercase font-bold text-zinc-500 block font-mono">
                Próxima rotación en
              </span>
              <span className="text-sm lg:text-base font-bold font-mono text-white">
                {timeLeft || "00h 00m 00s"}
              </span>
            </div>
          </div>
        </div>

        {/* Progress bar */}
        <div className="mt-6 pt-6 border-t border-white/10 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <span className="text-xs font-semibold text-zinc-300">Progreso Diario:</span>
            <span className="text-xs font-bold font-mono text-red-400">{completedTodayCount} de 3 completados</span>
          </div>
          <div className="flex-1 max-w-xs h-2 bg-black/60 rounded-full overflow-hidden border border-white/5">
            <div 
              className="h-full bg-gradient-to-r from-red-500 via-purple-500 to-primary transition-all duration-500"
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
              <div className="h-6 w-3/4 bg-white/10 rounded-lg" />
              <div className="h-12 w-full bg-white/5 rounded-lg" />
              <div className="h-10 w-full bg-white/10 rounded-xl" />
            </Card>
          ))
        ) : dailyChallenges.length === 0 ? (
          <div className="col-span-3 text-center py-12 bg-black/20 rounded-2xl border border-white/5 p-6">
            <Code2 size={40} className="mx-auto text-zinc-600 mb-3" />
            <h4 className="text-lg font-bold text-white mb-1">Retos en preparación</h4>
            <p className="text-sm text-zinc-400">
              Ejecuta el script <code className="text-primary font-mono">seeds/09_retos_algoritmicos_diarios.sql</code> en Supabase para activar los 10 retos de la Arena.
            </p>
          </div>
        ) : (
          dailyChallenges.map((challenge, idx) => (
            <Card 
              key={challenge.id} 
              className={`p-6 glass flex flex-col justify-between transition-all relative overflow-hidden group hover:border-red-500/40 hover:scale-[1.02] ${
                challenge.completed ? "border-emerald-500/30 bg-emerald-950/10" : "border-white/10"
              }`}
            >
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-mono font-bold px-2.5 py-1 rounded-lg bg-red-500/10 text-red-400 border border-red-500/20">
                    Reto #{idx + 1}
                  </span>
                  
                  <div className="flex items-center gap-1.5 text-yellow-400 font-bold text-xs font-mono bg-yellow-500/10 px-2 py-0.5 rounded-full border border-yellow-500/20">
                    <Zap size={12} className="fill-yellow-400" />
                    +{challenge.xp_reward} XP
                  </div>
                </div>

                <div>
                  <h3 className="font-heading font-bold text-lg text-white group-hover:text-red-300 transition-colors">
                    {challenge.title}
                  </h3>
                  <p className="text-xs text-zinc-400 mt-1 line-clamp-2 leading-relaxed">
                    {challenge.description}
                  </p>
                </div>
              </div>

              <div className="mt-6 pt-4 border-t border-white/5">
                {challenge.completed ? (
                  <Link href={`/ide/${challenge.id}`} className="w-full block">
                    <Button variant="outline" className="w-full border-emerald-500/40 text-emerald-400 hover:bg-emerald-500/10 flex items-center justify-center gap-2">
                      <CheckCircle2 size={16} /> Resuelto (Repetir)
                    </Button>
                  </Link>
                ) : (
                  <Link href={`/ide/${challenge.id}`} className="w-full block">
                    <Button className="w-full bg-gradient-to-r from-red-600 to-purple-600 hover:from-red-500 hover:to-purple-500 text-white font-bold flex items-center justify-center gap-2 shadow-[0_0_15px_rgba(220,38,38,0.25)]">
                      <Play size={16} className="fill-white" /> Resolver Reto ⚡
                    </Button>
                  </Link>
                )}
              </div>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
