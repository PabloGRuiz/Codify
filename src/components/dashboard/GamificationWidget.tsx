import { Card } from "@/components/ui/Card";
import { Flame, ShieldCheck, ChevronRight } from "lucide-react";

interface GamificationWidgetProps {
  setShowStreakModal: (show: boolean) => void;
  streak: number;
  currentLevel: number;
  currentXp: number;
  xpProgressInLevel: number;
  xpRequiredForNext: number;
  progressPercentage: number;
  setActiveDashboardTab: (tab: "roadmap" | "arena" | "news" | "quests") => void;
}

export function GamificationWidget({
  setShowStreakModal,
  streak,
  currentLevel,
  currentXp,
  xpProgressInLevel,
  xpRequiredForNext,
  progressPercentage,
  setActiveDashboardTab
}: GamificationWidgetProps) {
  return (
    <div className="space-y-6">
      {/* 1. Fire Streak Hero Card */}
      <Card 
        onClick={() => setShowStreakModal(true)}
        className="p-6 glass border-orange-500/30 hover:border-orange-500/60 transition-all cursor-pointer group relative overflow-hidden shadow-[0_0_30px_rgba(249,115,22,0.1)]"
      >
        <div className="absolute top-0 right-0 w-32 h-32 bg-orange-500/10 blur-[40px] rounded-full pointer-events-none" />
        
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2 text-orange-400 font-bold text-xs uppercase tracking-wider">
            <Flame size={16} className="fill-orange-400 animate-pulse" />
            <span>Racha Activa</span>
          </div>
          <span className="text-xs text-zinc-400 group-hover:text-orange-300 font-medium flex items-center gap-1 transition-colors">
            Ver detalle <ChevronRight size={14} />
          </span>
        </div>

        <div className="flex items-center gap-4 mb-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-orange-500 via-amber-500 to-yellow-400 flex items-center justify-center text-white shadow-lg border-2 border-orange-300 group-hover:scale-105 transition-transform">
            <Flame size={32} className="fill-white" />
          </div>
          <div>
            <div className="text-3xl font-heading font-bold text-white leading-none mb-1">
              {streak} {streak === 1 ? "Día" : "Días"}
            </div>
            <p className="text-xs text-zinc-400">
              {streak >= 7 ? "¡Multiplicador x1.5 activo!" : streak >= 3 ? "¡Multiplicador x1.2 activo!" : "¡Sigue programando hoy!"}
            </p>
          </div>
        </div>

        <div className="w-full bg-black/40 rounded-xl p-2.5 flex items-center justify-between text-xs text-zinc-300 border border-white/5 font-mono">
          <span className="flex items-center gap-1 text-orange-400">
            <ShieldCheck size={14} /> Protector activado
          </span>
          <span className="text-zinc-500">Hoy: Completado</span>
        </div>
      </Card>

      {/* 2. Level & XP Progress Card */}
      <Card className="p-6 glass border-t-4 border-t-primary">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-primary/20 text-primary font-bold flex items-center justify-center text-sm font-mono border border-primary/30">
              {currentLevel}
            </div>
            <div>
              <h4 className="font-heading font-bold text-sm text-white">Nivel {currentLevel}</h4>
              <p className="text-[11px] text-zinc-400 font-mono">Desarrollador Junior</p>
            </div>
          </div>
          <span className="text-xs font-bold text-primary font-mono">{currentXp} XP</span>
        </div>

        <div className="space-y-1.5">
          <div className="flex justify-between text-[11px] text-zinc-400 font-mono">
            <span>Progreso al Nivel {currentLevel + 1}</span>
            <span>{xpProgressInLevel} / {xpRequiredForNext} XP</span>
          </div>
          <div className="h-2 w-full bg-black/60 rounded-full overflow-hidden border border-white/5">
            <div 
              className="h-full bg-gradient-to-r from-primary to-accent transition-all duration-500"
              style={{ width: `${progressPercentage}%` }}
            />
          </div>
        </div>
      </Card>

      {/* 3. Daily Quests Widget */}
      <Card className="p-6 glass">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-heading font-bold text-base">Misiones Diarias</h3>
          <button 
            onClick={() => setActiveDashboardTab("quests")}
            className="text-xs text-primary font-bold hover:underline"
          >
            Ver todas →
          </button>
        </div>

        <ul className="space-y-4">
          {[
            { title: "Inicia sesión a diario", xp: 25, progress: 1, total: 1, done: true },
            { title: "Resuelve 1 lección hoy", xp: 50, progress: currentXp > 0 ? 1 : 0, total: 1, done: currentXp > 0 },
            { title: "Acumula 100 XP", xp: 100, progress: Math.min(100, currentXp), total: 100, done: currentXp >= 100 },
          ].map((mission, i) => (
            <li key={i} className="flex items-start gap-3">
              <div className={`w-5 h-5 rounded-full border flex items-center justify-center mt-0.5 flex-shrink-0 ${mission.done ? 'bg-emerald-500 border-emerald-400 text-black shadow-[0_0_10px_rgba(52,211,153,0.3)]' : 'border-zinc-500 bg-zinc-900/50'}`}>
                {mission.done && <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>}
              </div>
              <div className="flex-1">
                <div className="flex justify-between items-start mb-1">
                  <p className={`text-xs font-medium ${mission.done ? 'text-zinc-400' : 'text-zinc-200'}`}>{mission.title}</p>
                  <p className={`text-xs font-bold font-mono ${mission.done ? 'text-emerald-400' : 'text-primary'}`}>+{mission.xp} XP</p>
                </div>
                <div className="h-1.5 w-full bg-black/50 rounded-full overflow-hidden mt-1">
                  <div 
                    className={`h-full transition-all duration-500 ${mission.done ? 'bg-emerald-400' : 'bg-primary'}`}
                    style={{ width: `${(mission.progress / mission.total) * 100}%` }}
                  />
                </div>
              </div>
            </li>
          ))}
        </ul>
      </Card>
    </div>
  );
}
