"use client";

import { useState, useEffect } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import { supabase } from "@/lib/supabase";
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
  Edit3, 
  ArrowLeft 
} from "lucide-react";
import Link from "next/link";

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

export default function ProfilePage() {
  const { user, profile, loading } = useUser();
  const { isCollapsed } = useSidebar();
  const [completedList, setCompletedList] = useState<CompletedChallenge[]>([]);
  const [isEditing, setIsEditing] = useState(false);
  const [newUsername, setNewUsername] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (profile?.username) {
      setNewUsername(profile.username);
    }
  }, [profile]);

  useEffect(() => {
    const fetchHistory = async () => {
      if (!user) return;
      try {
        const { data, error } = await supabase
          .from("user_progress")
          .select("id, challenge_id, completed_at, challenges(title, xp_reward, challenge_type)")
          .eq("user_id", user.id)
          .eq("status", "completed")
          .order("completed_at", { ascending: false });

        if (error) console.error("Error obteniendo historial:", error);
        if (data) setCompletedList(data as any);
      } catch (e) {
        console.error("Error cargando historial de retos:", e);
      }
    };

    fetchHistory();
  }, [user]);

  const handleSaveProfile = async () => {
    if (!user || !newUsername.trim()) return;
    setSaving(true);
    try {
      await supabase
        .from("profiles")
        .update({ username: newUsername.trim() })
        .eq("id", user.id);

      setIsEditing(false);
      window.location.reload();
    } catch (e) {
      console.error("Error guardando perfil:", e);
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center text-white font-sans">
        <div className="flex flex-col items-center gap-3">
          <div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
          <p className="text-sm font-mono text-zinc-400">Cargando Perfil...</p>
        </div>
      </div>
    );
  }

  const currentLevel = profile?.level || 1;
  const currentXp = profile?.xp || 0;
  const xpRequiredForNext = currentLevel * 100;
  const streak = profile?.streak_days || 1;
  const completedCount = completedList.length;

  const badges = [
    { title: "Primer Paso", desc: "Completaste tu primera lección", icon: <CheckCircle2 size={24} className="text-emerald-400" />, unlocked: completedCount >= 1 },
    { title: "Constante", desc: "Alcanzaste 3 días de racha", icon: <Flame size={24} className="text-orange-400" />, unlocked: streak >= 3 },
    { title: "Maestro de Lógica", desc: "Completaste 5 lecciones", icon: <Zap size={24} className="text-yellow-400" />, unlocked: completedCount >= 5 },
    { title: "Arquitecto POO", desc: "Nivel 3 alcanzado", icon: <Trophy size={24} className="text-purple-400" />, unlocked: currentLevel >= 3 },
  ];

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        
        {/* Background glow effects */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[120px] pointer-events-none" />
        
        <Topbar />

        <main className="flex-1 p-6 lg:p-8 overflow-y-auto z-10 relative space-y-8 max-w-6xl mx-auto w-full">
          
          {/* Header Link Back */}
          <div className="flex items-center gap-4">
            <Link href="/" className="text-zinc-400 hover:text-white transition-colors flex items-center gap-2 font-sans text-sm">
              <ArrowLeft size={16} /> Volver al Dashboard
            </Link>
          </div>

          {/* User Hero Banner Card */}
          <Card className="p-6 lg:p-8 glass-panel border-t-4 border-t-primary relative overflow-hidden shadow-2xl">
            <div className="flex flex-col md:flex-row items-center md:items-start gap-6">
              
              {/* Avatar */}
              <div className="w-24 h-24 rounded-full bg-gradient-to-tr from-accent to-primary p-[3px] shadow-[0_0_30px_rgba(139,92,246,0.3)] shrink-0">
                <div className="w-full h-full rounded-full bg-secondary flex items-center justify-center overflow-hidden bg-black/60">
                  {profile?.avatar_url ? (
                    <img src={profile.avatar_url} alt="Avatar" className="w-full h-full object-cover" />
                  ) : (
                    <User size={40} className="text-zinc-300" />
                  )}
                </div>
              </div>

              {/* User Info */}
              <div className="flex-1 text-center md:text-left space-y-2">
                <div className="flex flex-col md:flex-row md:items-center gap-3">
                  {isEditing ? (
                    <div className="flex items-center gap-2">
                      <input
                        type="text"
                        value={newUsername}
                        onChange={(e) => setNewUsername(e.target.value)}
                        className="bg-black/60 border border-white/20 px-3 py-1.5 rounded-lg text-white font-bold text-xl outline-none focus:border-primary"
                      />
                      <Button size="sm" onClick={handleSaveProfile} isLoading={saving}>
                        Guardar
                      </Button>
                      <button onClick={() => setIsEditing(false)} className="text-xs text-zinc-400 hover:underline">
                        Cancelar
                      </button>
                    </div>
                  ) : (
                    <div className="flex items-center justify-center md:justify-start gap-3">
                      <h1 className="text-3xl font-heading font-bold text-white">
                        {profile?.username || "Coder"}
                      </h1>
                      <button 
                        onClick={() => setIsEditing(true)}
                        className="p-1.5 rounded-lg bg-white/5 hover:bg-white/10 text-zinc-400 hover:text-white transition-colors"
                        title="Editar nombre"
                      >
                        <Edit3 size={16} />
                      </button>
                    </div>
                  )}
                  
                  <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/20 text-primary border border-primary/30 text-xs font-bold w-fit mx-auto md:mx-0">
                    <ShieldCheck size={14} /> Nivel {currentLevel}
                  </span>
                </div>

                <p className="text-zinc-400 text-sm">{user?.email || "Usuario de Codify"}</p>
                <div className="flex items-center justify-center md:justify-start gap-2 text-xs text-zinc-500 pt-1">
                  <Calendar size={14} />
                  <span>Miembro activo en la plataforma</span>
                </div>
              </div>

              {/* Level & XP Progress Card */}
              <div className="w-full md:w-64 p-4 rounded-2xl bg-black/40 border border-white/10 space-y-3 shrink-0 shadow-lg">
                <div className="flex justify-between items-center text-xs">
                  <span className="text-zinc-400 font-semibold">Progreso de Nivel</span>
                  <span className="text-primary font-bold">{currentXp} / {xpRequiredForNext} XP</span>
                </div>
                <div className="h-3 w-full bg-black/60 rounded-full overflow-hidden p-0.5 border border-white/5">
                  <div
                    className="h-full bg-gradient-to-r from-primary to-accent rounded-full transition-all duration-500 shadow-[0_0_10px_rgba(139,92,246,0.5)]"
                    style={{ width: `${Math.min(100, (currentXp / xpRequiredForNext) * 100)}%` }}
                  />
                </div>
                <p className="text-[11px] text-zinc-500 text-center">
                  Faltan {Math.max(0, xpRequiredForNext - currentXp)} XP para el Nivel {currentLevel + 1}
                </p>
              </div>

            </div>
          </Card>

          {/* Quick Statistics Grid */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1">
              <Zap size={24} className="text-yellow-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{currentXp}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Puntos XP</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1">
              <Flame size={24} className="text-orange-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{streak}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Días de Racha</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1">
              <CheckCircle2 size={24} className="text-emerald-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{completedCount}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Retos Resueltos</span>
            </Card>

            <Card className="p-5 glass flex flex-col items-center justify-center text-center space-y-1">
              <Trophy size={24} className="text-purple-400 mb-1" />
              <span className="text-3xl font-heading font-bold text-white">{currentLevel}</span>
              <span className="text-xs text-zinc-400 uppercase tracking-wider font-medium">Nivel Actual</span>
            </Card>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            {/* Left 2 Cols: Badges & Achievements */}
            <div className="lg:col-span-2 space-y-6">
              <h3 className="text-xl font-heading font-bold text-white flex items-center gap-2">
                <Award className="text-primary" size={22} />
                <span>Insignias & Logros</span>
              </h3>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {badges.map((badge, idx) => (
                  <Card 
                    key={idx} 
                    className={`p-5 flex items-start gap-4 transition-all ${
                      badge.unlocked 
                        ? "glass border-primary/30" 
                        : "bg-black/20 border-white/5 opacity-50 grayscale"
                    }`}
                  >
                    <div className={`p-3 rounded-2xl shrink-0 ${badge.unlocked ? "bg-primary/20 border border-primary/30" : "bg-zinc-800"}`}>
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
                <Code2 className="text-accent" size={22} />
                <span>Historial Reciente</span>
              </h3>

              <Card className="p-6 glass space-y-4">
                {completedList.length === 0 ? (
                  <div className="text-center text-zinc-500 py-8 text-sm">
                    Aún no has completado lecciones. ¡Empieza hoy en el Dashboard!
                  </div>
                ) : (
                  <ul className="space-y-3 max-h-96 overflow-y-auto pr-1 custom-scrollbar">
                    {completedList.map((item) => (
                      <li key={item.id} className="p-3 bg-black/40 rounded-xl border border-white/5 flex items-center justify-between text-xs">
                        <div>
                          <p className="font-bold text-white line-clamp-1">{item.challenges?.title || "Lección completada"}</p>
                          <span className="text-[10px] text-zinc-500 font-mono">
                            {new Date(item.completed_at).toLocaleDateString("es-ES")}
                          </span>
                        </div>
                        <span className="text-emerald-400 font-bold bg-emerald-500/10 px-2 py-1 rounded border border-emerald-500/20 shrink-0">
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
