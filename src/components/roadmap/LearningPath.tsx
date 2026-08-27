"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Check, Lock, Play, Star, Trophy, Zap, ShieldCheck, ArrowRight, BookOpen, GraduationCap, Award, Sparkles, CheckCircle2 } from "lucide-react";
import Link from "next/link";
import { Certification, UserCertification } from "@/types";
import { ExamModal } from "@/components/certifications/ExamModal";

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
  challenges?: ChallengeNode[];
  totalChallenges?: number;
  completedChallenges?: number;
  isCompleted?: boolean;
  isUnlocked?: boolean;
  prevModuleTitle?: string;
}

export function LearningPath({ courseId }: { courseId?: string }) {
  const { user } = useUser();
  const [modules, setModules] = useState<ModuleInfo[]>([]);
  const [selectedModuleId, setSelectedModuleId] = useState<string>("");
  const [challenges, setChallenges] = useState<ChallengeNode[]>([]);
  const [completedIds, setCompletedIds] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  // Certifications State
  const [certification, setCertification] = useState<Certification | null>(null);
  const [userCert, setUserCert] = useState<UserCertification | null>(null);
  const [isExamOpen, setIsExamOpen] = useState(false);

  useEffect(() => {
    const fetchModulesAndProgress = async () => {
      setLoading(true);
      try {
        // 1. Fetch user completed challenges if logged in
        let completedSet = new Set<string>();
        if (user) {
          const { data: progData, error: prError } = await supabase
            .from("user_progress")
            .select("challenge_id")
            .eq("user_id", user.id)
            .eq("status", "completed");

          if (prError) console.error("Error fetching progress:", prError.message || prError);
          if (progData) {
            const cIds = progData.map((p) => p.challenge_id);
            setCompletedIds(cIds);
            completedSet = new Set(cIds);
          }
        }

        // 2. Fetch modules with nested challenges ordered chronologically
        let query = supabase
          .from("modules")
          .select("id, title, description, created_at, challenges(id, module_id, title, description, order_index, xp_reward, theory)")
          .order("created_at", { ascending: true });

        if (courseId) {
          query = query.eq("course_id", courseId);
        }
        
        const { data: modulesData, error: modError } = await query;

        if (modError) console.error("Error fetching modules:", modError.message || modError);
        
        if (modulesData && modulesData.length > 0) {
          let canUnlockNext = true;
          const processedModules: ModuleInfo[] = modulesData.map((mod: any, index: number) => {
            const sortedChallenges = (mod.challenges || []).sort(
              (a: ChallengeNode, b: ChallengeNode) => (a.order_index || 0) - (b.order_index || 0)
            );

            const totalChallenges = sortedChallenges.length;
            const completedChallenges = sortedChallenges.filter((c: ChallengeNode) =>
              completedSet.has(c.id)
            ).length;

            const isCompleted = totalChallenges > 0 && completedChallenges === totalChallenges;
            const isUnlocked = canUnlockNext;

            if (!isCompleted) {
              canUnlockNext = false;
            }

            return {
              id: mod.id,
              title: mod.title,
              description: mod.description,
              challenges: sortedChallenges,
              totalChallenges,
              completedChallenges,
              isCompleted,
              isUnlocked,
              prevModuleTitle: index > 0 ? modulesData[index - 1].title : undefined,
            };
          });

          setModules(processedModules);

          let defaultModId = "";
          if (typeof window !== "undefined") {
            const saved = localStorage.getItem(`codify_last_module_${courseId || "default"}`);
            if (saved) {
              const found = processedModules.find(m => m.id === saved);
              if (found && found.isUnlocked) {
                defaultModId = saved;
              }
            }
          }
          
          if (!defaultModId) {
            const activeOrFirst = processedModules.find(m => m.isUnlocked && !m.isCompleted) || processedModules[0];
            defaultModId = activeOrFirst?.id || processedModules[0].id;
          }
          
          setSelectedModuleId(defaultModId);
        } else {
          setModules([]);
          setSelectedModuleId("");
          setChallenges([]);
        }

        // 3. Fetch Certification if courseId exists
        if (courseId) {
          const { data: certData } = await supabase
            .from("certifications")
            .select("*, certification_questions(*)")
            .eq("course_id", courseId)
            .maybeSingle();

          if (certData) {
            setCertification(certData as any);

            // Check if user already holds this certification
            if (user) {
              const { data: uCertData } = await supabase
                .from("user_certifications")
                .select("*, certification:certifications(*)")
                .eq("user_id", user.id)
                .eq("certification_id", certData.id)
                .maybeSingle();

              if (uCertData) {
                setUserCert(uCertData as any);
              }
            }
          }
        }
      } catch (e: unknown) {
        const err = e as Error;
        console.error("Unexpected error in LearningPath:", err?.message || String(err));
      } finally {
        setLoading(false);
      }
    };

    fetchModulesAndProgress();
  }, [user, courseId]);

  useEffect(() => {
    if (!selectedModuleId || modules.length === 0) return;

    const currentMod = modules.find(m => m.id === selectedModuleId);
    if (currentMod && currentMod.challenges) {
      setChallenges(currentMod.challenges);
    } else {
      setChallenges([]);
    }
  }, [selectedModuleId, modules]);

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
  const isModuleLocked = activeModule && !activeModule.isUnlocked;

  return (
    <Card className="p-8 glass-panel border-t-4 border-t-primary relative overflow-hidden space-y-8 shadow-2xl">
      
      {/* Header section */}
      <div className="flex flex-col xl:flex-row xl:items-center justify-between gap-6 border-b border-white/10 pb-6">
        <div className="space-y-2 flex-1 min-w-0">
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
                  localStorage.setItem(`codify_last_module_${courseId || "default"}`, newId);
                }
              }}
              className="bg-black/60 text-white font-heading font-bold text-lg sm:text-xl p-2.5 rounded-xl border border-white/20 outline-none focus:border-primary w-full max-w-full lg:max-w-xl truncate cursor-pointer shadow-inner"
            >
              {modules.map((m) => (
                <option key={m.id} value={m.id} className="bg-zinc-900 text-white">
                  {m.isCompleted ? "✅ " : m.isUnlocked ? "📖 " : "🔒 "}
                  {m.title} {m.isUnlocked ? `(${m.completedChallenges}/${m.totalChallenges})` : "(Bloqueado)"}
                </option>
              ))}
            </select>
          ) : (
            <h2 className="text-2xl font-heading font-bold text-white truncate">
              {activeModule?.title || "Curso Inicial: Aprende a Programar desde Cero"}
            </h2>
          )}

          <p className="text-sm text-zinc-400 max-w-xl leading-relaxed">
            {activeModule?.description || "Domina las bases de la programación paso a paso."}
          </p>
        </div>

        {/* Segment Progress Indicator */}
        <div className="bg-black/50 p-4 rounded-xl border border-white/10 flex items-center justify-between xl:justify-start gap-4 shrink-0 shadow-lg self-start xl:self-auto w-full xl:w-auto">
          <div>
            <span className="text-xs text-zinc-400 block font-semibold">Progreso del Módulo</span>
            <span className="text-xl font-bold text-white font-mono">
              {completedCount} / {totalCount} <span className="text-xs text-primary font-sans">({progressPercent}%)</span>
            </span>
          </div>
          <div className="w-12 h-12 rounded-full border-4 border-primary/20 flex items-center justify-center relative bg-black/40 shrink-0">
            <Star className="text-primary fill-primary animate-pulse" size={22} />
          </div>
        </div>
      </div>

      {/* Locked Module View vs Challenges Roadmap */}
      {isModuleLocked ? (
        <div className="py-14 px-6 rounded-2xl bg-black/40 border border-amber-500/20 text-center space-y-6 max-w-2xl mx-auto shadow-2xl my-4">
          <div className="w-16 h-16 rounded-2xl bg-amber-500/10 border border-amber-500/30 text-amber-400 flex items-center justify-center mx-auto shadow-[0_0_30px_rgba(245,158,11,0.2)] animate-pulse">
            <Lock size={32} />
          </div>
          <div className="space-y-2">
            <h3 className="text-2xl font-heading font-bold text-white">Módulo Bloqueado 🔒</h3>
            <p className="text-sm text-zinc-400 max-w-md mx-auto leading-relaxed">
              Para desbloquear este módulo, primero debes completar el 100% de los retos del módulo anterior:
            </p>
            <div className="inline-block px-4 py-2 rounded-xl bg-white/5 border border-white/10 text-amber-300 font-bold text-sm shadow-inner mt-2">
              📖 {activeModule?.prevModuleTitle || "Módulo Anterior"}
            </div>
          </div>
          <div className="pt-2">
            <Button
              onClick={() => {
                const currentIndex = modules.findIndex((m) => m.id === activeModule?.id);
                if (currentIndex > 0) {
                  const prevMod = modules[currentIndex - 1];
                  setSelectedModuleId(prevMod.id);
                }
              }}
              className="bg-primary hover:bg-primary/80 text-white shadow-lg shadow-primary/20 px-6 py-2.5 h-auto text-sm font-bold"
              leftIcon={<ArrowRight size={16} />}
            >
              Completar Módulo Anterior 🚀
            </Button>
          </div>
        </div>
      ) : (
        /* Timeline Roadmap View */
        <div className="space-y-4 max-w-3xl mx-auto py-2">
          {challenges.length === 0 ? (
            <div className="text-center text-zinc-400 py-12 space-y-3">
              <BookOpen size={36} className="mx-auto text-zinc-600" />
              <p className="text-base font-semibold">No se encontraron niveles en este módulo.</p>
              <p className="text-xs text-zinc-500">Ejecuta el script SQL correspondiente en tu panel de Supabase.</p>
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

                    <div className="flex items-center gap-3 self-end sm:self-center shrink-0">
                      <span className="text-xs font-bold font-mono text-primary bg-primary/10 px-2.5 py-1 rounded-lg border border-primary/20">
                        +{node.xp_reward} XP
                      </span>
                      {isUnlocked && (
                        <Link href={`/ide/${node.id}`}>
                          <Button size="sm" className={isCompleted ? "bg-white/10 hover:bg-white/20 text-white" : "bg-primary hover:bg-primary/80 text-white shadow-lg shadow-primary/20"}>
                            {isCompleted ? "Repasar" : "Comenzar"}
                          </Button>
                        </Link>
                      )}
                    </div>
                  </div>
                </div>
              );
            })
          )}
        </div>
      )}

      {/* BANNER DE CERTIFICACIÓN OFICIAL */}
      {certification && (
        <div className="pt-4 border-t border-white/10">
          {userCert ? (
            /* CERTIFICADO YA OBTENIDO */
            <div className="p-6 rounded-2xl bg-gradient-to-r from-amber-500/15 via-emerald-500/10 to-amber-500/15 border border-amber-500/40 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-xl">
              <div className="flex items-center gap-4 text-center sm:text-left">
                <div className="w-14 h-14 rounded-2xl bg-amber-500/20 text-amber-400 border border-amber-500/40 flex items-center justify-center shrink-0 shadow-lg shadow-amber-500/20">
                  <Award size={30} />
                </div>
                <div>
                  <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2">
                    <span className="text-[10px] font-bold uppercase tracking-wider bg-amber-500/20 text-amber-300 px-2.5 py-0.5 rounded-full border border-amber-500/30">
                      Certificación Obtenida ✅
                    </span>
                    <span className="text-xs text-zinc-400 font-mono">
                      Nota: <strong className="text-emerald-400">{userCert.score}%</strong>
                    </span>
                  </div>
                  <h4 className="text-base sm:text-lg font-bold text-white mt-1">
                    {certification.title}
                  </h4>
                  <p className="text-xs text-zinc-400 font-mono">
                    ID de Verificación: {userCert.verification_code}
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-2 shrink-0">
                <Link href={`/certificados/${userCert.verification_code}`}>
                  <Button
                    size="sm"
                    className="bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20 text-xs"
                    leftIcon={<GraduationCap size={15} />}
                  >
                    Ver Diploma Oficial 📜
                  </Button>
                </Link>
              </div>
            </div>
          ) : modules.length > 0 && modules.every((m) => m.isCompleted) ? (
            /* CURSO 100% COMPLETADO - LISTO PARA EXAMEN */
            <div className="p-6 rounded-2xl bg-gradient-to-r from-amber-500/20 via-primary/20 to-amber-500/20 border-2 border-amber-500/50 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-2xl animate-pulse-slow">
              <div className="flex items-center gap-4 text-center sm:text-left">
                <div className="w-14 h-14 rounded-2xl bg-amber-500/20 text-amber-400 border border-amber-500/40 flex items-center justify-center shrink-0 shadow-[0_0_25px_rgba(245,158,11,0.3)] animate-bounce">
                  <GraduationCap size={32} />
                </div>
                <div>
                  <span className="text-[10px] font-bold uppercase tracking-wider bg-amber-500/20 text-amber-300 px-2.5 py-0.5 rounded-full border border-amber-500/40">
                    ¡Has completado todos los módulos! 🏆
                  </span>
                  <h4 className="text-base sm:text-lg font-bold text-white mt-1">
                    Rinde tu Examen de Certificación Oficial
                  </h4>
                  <p className="text-xs text-zinc-300 max-w-md">
                    Demuestra tu dominio técnico, obtén tu insignia y acredita tus competencias en tu perfil (+{certification.xp_reward} XP).
                  </p>
                </div>
              </div>

              <Button
                size="sm"
                onClick={() => setIsExamOpen(true)}
                leftIcon={<Sparkles size={16} />}
                className="bg-amber-500 hover:bg-amber-600 text-black font-black text-xs shadow-xl shadow-amber-500/30 px-4 py-2.5 shrink-0"
              >
                Rendir Examen 🚀
              </Button>
            </div>
          ) : null}
        </div>
      )}

      {/* Modal de Examen */}
      {certification && (
        <ExamModal
          isOpen={isExamOpen}
          onClose={() => setIsExamOpen(false)}
          certification={certification}
          courseTitle={modules[0]?.title || "Curso"}
          onCertificationAchieved={(newCert) => {
            setUserCert(newCert);
          }}
        />
      )}

    </Card>
  );
}
