"use client";

import { useState, useEffect } from "react";
import { useParams, useRouter } from "next/navigation";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
import { getLevelInfo } from "@/lib/gamification";
import { 
  User, 
  Trophy, 
  Flame, 
  Zap, 
  CheckCircle2, 
  Calendar, 
  ShieldCheck, 
  Code2, 
  Award, 
  ArrowLeft,
  Star,
  BookOpen,
  GraduationCap,
  Sparkles,
  MessageSquare
} from "lucide-react";
import Link from "next/link";
import { UserCertification } from "@/types";

interface TargetProfile {
  id: string;
  username: string;
  avatar_url?: string;
  reputation_stars: number;
  xp: number;
  level: number;
  streak_days: number;
  role?: string;
  created_at?: string;
}

interface CompletedChallenge {
  id: string;
  challenge_id: string;
  completed_at: string;
  challenges: {
    title: string;
    xp_reward: number;
    challenge_type: string;
  };
}

export default function PublicProfilePage() {
  const { id } = useParams();
  const router = useRouter();
  const { user } = useUser();
  const { isCollapsed } = useSidebar();

  const [targetProfile, setTargetProfile] = useState<TargetProfile | null>(null);
  const [completedChallenges, setCompletedChallenges] = useState<CompletedChallenge[]>([]);
  const [userCerts, setUserCerts] = useState<UserCertification[]>([]);
  const [coursesStats, setCoursesStats] = useState<{ totalEnrolled: number; completedCourses: number }>({
    totalEnrolled: 0,
    completedCourses: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (id) {
      fetchUserProfile();
    }
  }, [id]);

  const fetchUserProfile = async () => {
    setLoading(true);
    try {
      // 1. Fetch Profile by UUID or Username
      let query = supabase
        .from("profiles")
        .select("id, username, avatar_url, reputation_stars, xp, level, streak_days, role, created_at");

      // Check if it's UUID format
      const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(String(id));
      if (isUUID) {
        query = query.eq("id", id);
      } else {
        query = query.eq("username", id);
      }

      const { data: profData, error: profError } = await query.single();
      if (profError || !profData) {
        throw new Error("Perfil no encontrado");
      }

      setTargetProfile({
        ...profData,
        reputation_stars: profData.reputation_stars || 0,
        xp: profData.xp || 0,
        streak_days: profData.streak_days || 0,
        level: profData.level || 1,
      });

      const targetUserId = profData.id;

      // 2. Fetch completed challenges
      const { data: progressData } = await supabase
        .from("user_progress")
        .select("id, challenge_id, completed_at, challenges(title, xp_reward, challenge_type)")
        .eq("user_id", targetUserId)
        .eq("status", "completed")
        .order("completed_at", { ascending: false });

      if (progressData) {
        setCompletedChallenges(progressData as any);
      }

      // 3. Fetch courses completion stats
      const { data: enrollmentsData } = await supabase
        .from("course_enrollments")
        .select("*, courses(*, modules(id, challenges(id)))")
        .eq("user_id", targetUserId);

      if (enrollmentsData && enrollmentsData.length > 0) {
        const completedChallengeIds = new Set((progressData || []).map((p: any) => p.challenge_id));
        let finishedCount = 0;

        enrollmentsData.forEach((enr: any) => {
          const course = enr.courses;
          let totalCourseChallenges = 0;
          let userCompletedInCourse = 0;

          if (course?.modules && Array.isArray(course.modules)) {
            course.modules.forEach((mod: any) => {
              if (mod.challenges && Array.isArray(mod.challenges)) {
                totalCourseChallenges += mod.challenges.length;
                mod.challenges.forEach((ch: any) => {
                  if (completedChallengeIds.has(ch.id)) {
                    userCompletedInCourse++;
                  }
                });
              }
            });
          }

          if (totalCourseChallenges > 0 && userCompletedInCourse >= totalCourseChallenges) {
            finishedCount++;
          }
        });

        setCoursesStats({
          totalEnrolled: enrollmentsData.length,
          completedCourses: finishedCount,
        });
      }

      // 4. Fetch User Certifications
      const { data: certsData } = await supabase
        .from("user_certifications")
        .select("*, certification:certifications(*)")
        .eq("user_id", targetUserId)
        .order("issued_at", { ascending: false });

      if (certsData) {
        setUserCerts(certsData as any);
      }

    } catch (err) {
      console.error("Error al cargar perfil de usuario:", err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center text-white font-sans">
        <div className="flex flex-col items-center gap-3">
          <div className="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
          <p className="text-sm font-mono text-zinc-400">Cargando perfil público...</p>
        </div>
      </div>
    );
  }

  if (!targetProfile) {
    return (
      <div className="min-h-screen bg-background flex">
        <Sidebar />
        <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen`}>
          <Topbar />
          <div className="flex-1 p-8 text-center pt-24 max-w-md mx-auto">
            <User size={64} className="mx-auto text-zinc-600 mb-4" />
            <h1 className="text-2xl text-white font-bold mb-2">Usuario no encontrado</h1>
            <p className="text-zinc-400 text-sm mb-6">El perfil que buscas no existe o ha sido modificado.</p>
            <Button onClick={() => router.push("/foro")} className="bg-blue-600 hover:bg-blue-500">
              <ArrowLeft size={16} className="mr-2" /> Volver al Foro
            </Button>
          </div>
        </div>
      </div>
    );
  }

  const levelInfo = getLevelInfo(targetProfile.xp);
  const currentLevel = levelInfo.level;
  const currentXp = levelInfo.totalXp;
  const streak = targetProfile.streak_days;
  const completedCount = completedChallenges.length;
  const reputation = targetProfile.reputation_stars;

  // Medallas calculadas dinámicamente según el progreso real
  const badges = [
    { 
      title: "Primer Paso", 
      desc: "Completó su primera lección", 
      icon: <CheckCircle2 size={24} className="text-emerald-400" />, 
      unlocked: completedCount >= 1 
    },
    { 
      title: "Constancia Activa", 
      desc: "Mantuvo una racha de 3 o más días", 
      icon: <Flame size={24} className="text-orange-400" />, 
      unlocked: streak >= 3 
    },
    { 
      title: "Mente Analítica", 
      desc: "Completó más de 5 lecciones", 
      icon: <Zap size={24} className="text-yellow-400" />, 
      unlocked: completedCount >= 5 
    },
    { 
      title: "Arquitecto de Sistemas", 
      desc: "Alcanzó el Nivel 3 o superior", 
      icon: <Trophy size={24} className="text-purple-400" />, 
      unlocked: currentLevel >= 3 
    },
    { 
      title: "Mentor Comunitario", 
      desc: "Obtuvo reputación positiva en el foro", 
      icon: <Star size={24} className="text-yellow-400 fill-yellow-400/30" />, 
      unlocked: reputation >= 3 
    },
    { 
      title: "Graduado Especialista", 
      desc: "Completó al 100% al menos 1 curso", 
      icon: <GraduationCap size={24} className="text-indigo-400" />, 
      unlocked: coursesStats.completedCourses >= 1 
    },
  ];

  const isOwnProfile = user?.id === targetProfile.id;

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        
        {/* Background glow effects */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-blue-600/15 blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-purple-600/15 blur-[120px] pointer-events-none" />
        
        <Topbar />

        <main className="flex-1 p-6 lg:p-8 overflow-y-auto z-10 relative space-y-8 max-w-6xl mx-auto w-full">
          
          {/* Back button */}
          <div>
            <button 
              onClick={() => router.back()} 
              className="inline-flex items-center text-sm font-medium text-zinc-400 hover:text-blue-400 transition-colors"
            >
              <ArrowLeft size={16} className="mr-2" /> Volver atrás
            </button>
          </div>

          {/* Main Profile Header Card */}
          <Card className="p-6 md:p-8 glass relative overflow-hidden border-blue-500/20 shadow-2xl">
            <div className="flex flex-col md:flex-row items-center md:items-start gap-6 relative z-10">
              
              {/* Avatar Container */}
              <div className="w-24 h-24 md:w-28 md:h-28 rounded-full bg-gradient-to-tr from-blue-500 to-purple-600 p-[3px] shadow-[0_0_25px_rgba(59,130,246,0.3)] shrink-0">
                <div className="w-full h-full rounded-full bg-secondary flex items-center justify-center overflow-hidden">
                  {targetProfile.avatar_url ? (
                    <img src={targetProfile.avatar_url} alt="Avatar" className="w-full h-full object-cover" />
                  ) : (
                    <User size={48} className="text-zinc-400" />
                  )}
                </div>
              </div>

              {/* User Information */}
              <div className="flex-1 text-center md:text-left space-y-2">
                <div className="flex flex-col md:flex-row md:items-center gap-2 md:gap-4">
                  <div className="flex items-center justify-center md:justify-start gap-2">
                    <h1 className="text-2xl md:text-3xl font-heading font-bold text-white">
                      {targetProfile.username}
                    </h1>
                    {isOwnProfile && (
                      <span className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-full bg-blue-500/20 text-blue-300 border border-blue-500/30">
                        Tú
                      </span>
                    )}
                  </div>
                  
                  <div className="flex flex-wrap items-center justify-center md:justify-start gap-2">
                    <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-blue-500/20 text-blue-400 border border-blue-500/30">
                      <ShieldCheck size={14} /> Nivel {currentLevel}
                    </span>

                    {(targetProfile.role === 'admin' || targetProfile.role === 'profesor') && (
                      <span className="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 uppercase tracking-wider">
                        {targetProfile.role === 'admin' ? 'Administrador' : 'Profesor'}
                      </span>
                    )}
                  </div>
                </div>

                <div className="flex flex-wrap items-center justify-center md:justify-start gap-4 text-sm text-zinc-400 pt-2">
                  <div className="flex items-center gap-1.5 text-yellow-400 font-bold bg-yellow-500/10 px-3 py-1 rounded-lg border border-yellow-500/20">
                    <Star size={16} className="fill-yellow-400" />
                    <span>{reputation} {reputation === 1 ? 'Estrella de Reputación' : 'Estrellas de Reputación'}</span>
                  </div>

                  <div className="flex items-center gap-1.5 text-xs text-zinc-400">
                    <Calendar size={14} />
                    <span>
                      {targetProfile.created_at 
                        ? `Miembro desde ${new Date(targetProfile.created_at).toLocaleDateString('es-ES', { month: 'long', year: 'numeric' })}` 
                        : 'Miembro de Codify'}
                    </span>
                  </div>
                </div>
              </div>

              {/* Level & XP Progress Card */}
              <div className="w-full md:w-64 p-4 rounded-2xl bg-black/40 border border-white/10 space-y-3 shrink-0 shadow-lg">
                <div className="flex justify-between items-center text-xs">
                  <span className="text-zinc-400 font-semibold">Progreso de Nivel</span>
                  <span className="text-blue-400 font-bold">{levelInfo.xpInLevel} / {levelInfo.xpRequiredForNextLevel} XP</span>
                </div>
                <div className="h-3 w-full bg-black/60 rounded-full overflow-hidden p-0.5 border border-white/5">
                  <div
                    className="h-full bg-gradient-to-r from-blue-500 to-purple-500 rounded-full transition-all duration-500 shadow-[0_0_10px_rgba(59,130,246,0.5)]"
                    style={{ width: `${levelInfo.progressPercentage}%` }}
                  />
                </div>
                <p className="text-[11px] text-zinc-500 text-center">
                  Faltan {levelInfo.xpRemaining} XP para el Nivel {currentLevel + 1}
                </p>
              </div>

            </div>
          </Card>

          {/* Quick Statistics Grid */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1 hover:border-yellow-500/40 transition-colors">
              <Zap size={24} className="text-yellow-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{currentXp}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Puntos XP</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1 hover:border-orange-500/40 transition-colors">
              <Flame size={24} className="text-orange-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{streak}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Días de Racha</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1 hover:border-emerald-500/40 transition-colors">
              <CheckCircle2 size={24} className="text-emerald-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{completedCount}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Retos Resueltos</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1 hover:border-indigo-500/40 transition-colors">
              <GraduationCap size={24} className="text-indigo-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{coursesStats.completedCourses} / {coursesStats.totalEnrolled}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Cursos Completados</span>
            </Card>
          </div>

          {/* Official Certifications Section */}
          {userCerts.length > 0 && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
                  <GraduationCap className="text-amber-400" size={24} />
                  <span>Certificaciones Oficiales de Codify</span>
                  <span className="px-2 py-0.5 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono border border-amber-500/30">
                    {userCerts.length}
                  </span>
                </h3>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {userCerts.map((uc) => (
                  <Card
                    key={uc.id}
                    className="p-5 glass-panel border-2 border-amber-500/30 hover:border-amber-500/60 transition-all space-y-4 shadow-xl relative overflow-hidden"
                  >
                    <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/10 rounded-full blur-2xl pointer-events-none" />

                    <div className="flex items-start justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-2xl bg-amber-500/20 border border-amber-400 text-amber-400 flex items-center justify-center shrink-0 shadow-lg shadow-amber-500/20">
                          <Award size={26} />
                        </div>
                        <div>
                          <span className="text-[10px] uppercase font-bold tracking-wider text-amber-400 bg-amber-500/15 px-2.5 py-0.5 rounded-full border border-amber-500/30">
                            Aprobado • {uc.score}%
                          </span>
                          <h4 className="font-bold text-white text-base mt-1 line-clamp-1">
                            {uc.certification?.title || "Certificado Oficial"}
                          </h4>
                          <p className="text-[11px] text-zinc-400 font-mono">
                            Emitido el {new Date(uc.issued_at).toLocaleDateString("es-ES")}
                          </p>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center justify-between pt-2 border-t border-white/10 text-xs">
                      <span className="text-zinc-500 font-mono text-[11px]">
                        ID: <strong className="text-zinc-300">{uc.verification_code}</strong>
                      </span>
                      <Link href={`/certificados/${uc.verification_code}`}>
                        <Button
                          size="sm"
                          className="bg-amber-500 hover:bg-amber-600 text-black font-bold text-xs shadow-lg shadow-amber-500/20"
                        >
                          Ver Diploma 📜
                        </Button>
                      </Link>
                    </div>
                  </Card>
                ))}
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            {/* Left 2 Cols: Badges & Achievements */}
            <div className="lg:col-span-2 space-y-6">
              <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
                <Award className="text-blue-400" size={22} />
                <span>Insignias & Logros ({badges.filter(b => b.unlocked).length}/{badges.length})</span>
              </h3>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {badges.map((badge, idx) => (
                  <Card 
                    key={idx} 
                    className={`p-5 flex items-start gap-4 transition-all ${
                      badge.unlocked 
                        ? "glass border-blue-500/30 hover:border-blue-500/60" 
                        : "bg-black/20 border-white/5 opacity-50 grayscale"
                    }`}
                  >
                    <div className={`p-3 rounded-2xl shrink-0 ${badge.unlocked ? "bg-blue-500/20 border border-blue-500/30" : "bg-zinc-800"}`}>
                      {badge.icon}
                    </div>
                    <div>
                      <h4 className="font-bold text-white text-base">{badge.title}</h4>
                      <p className="text-xs text-zinc-400 mt-1">{badge.desc}</p>
                      <span className={`inline-block text-[10px] font-bold mt-2 px-2 py-0.5 rounded ${badge.unlocked ? "bg-emerald-500/20 text-emerald-400" : "bg-zinc-700 text-zinc-400"}`}>
                        {badge.unlocked ? "DESBLOQUEADO" : "BLOQUEADO"}
                      </span>
                    </div>
                  </Card>
                ))}
              </div>
            </div>

            {/* Right Col: Completed Challenges History */}
            <div className="space-y-6">
              <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
                <Code2 className="text-purple-400" size={22} />
                <span>Actividad Reciente</span>
              </h3>

              <Card className="p-6 glass space-y-4 border-white/5">
                {completedChallenges.length === 0 ? (
                  <div className="text-center text-zinc-500 py-8 text-sm">
                    Este usuario aún no tiene lecciones completadas registradas.
                  </div>
                ) : (
                  <ul className="space-y-3 max-h-96 overflow-y-auto pr-1 custom-scrollbar">
                    {completedChallenges.slice(0, 15).map((item) => (
                      <li key={item.id} className="p-3 bg-black/40 rounded-xl border border-white/5 flex items-center justify-between text-xs">
                        <div className="min-w-0 pr-2">
                          <p className="font-bold text-white truncate">{item.challenges?.title || "Lección completada"}</p>
                          <span className="text-[10px] text-zinc-500 font-mono">
                            {new Date(item.completed_at).toLocaleDateString("es-ES")}
                          </span>
                        </div>
                        <span className="text-emerald-400 font-bold bg-emerald-500/10 px-2 py-1 rounded border border-emerald-500/20 shrink-0 font-mono">
                          +{item.challenges?.xp_reward || 25} XP
                        </span>
                      </li>
                    ))}
                  </ul>
                )}
              </Card>
            </div>

          </div>

        </main>
      </div>
    </div>
  );
}
