"use client";

import { motion, AnimatePresence } from "framer-motion";
import { Flame, X, Trophy, ShieldCheck, Zap, Calendar, Sparkles, Check } from "lucide-react";
import { Button } from "@/components/ui/Button";

interface StreakModalProps {
  isOpen: boolean;
  onClose: () => void;
  streakDays: number;
  xpPoints: number;
}

export function StreakModal({ isOpen, onClose, streakDays, xpPoints }: StreakModalProps) {
  if (!isOpen) return null;

  const currentDayIndex = (new Date().getDay() + 6) % 7; // 0 = Lunes, 6 = Domingo
  const days = ["L", "M", "M", "J", "V", "S", "D"];

  // Multiplier calculation
  let multiplier = "x1.0";
  let multiplierLabel = "Base";
  if (streakDays >= 7) {
    multiplier = "x1.5";
    multiplierLabel = "¡Bonus Fuego Máximo!";
  } else if (streakDays >= 3) {
    multiplier = "x1.2";
    multiplierLabel = "Bonus Racha Caliente";
  }

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4">
        <motion.div
          initial={{ opacity: 0, scale: 0.9, y: 20 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.9, y: 20 }}
          className="bg-zinc-900 border border-orange-500/30 rounded-3xl p-6 sm:p-8 max-w-md w-full shadow-[0_0_60px_rgba(249,115,22,0.2)] relative overflow-hidden text-center"
        >
          {/* Background fire glow */}
          <div className="absolute top-[-50px] left-1/2 -translate-x-1/2 w-64 h-64 bg-orange-500/20 blur-[80px] rounded-full pointer-events-none" />

          {/* Close button */}
          <button
            onClick={onClose}
            className="absolute top-4 right-4 p-2 text-zinc-400 hover:text-white rounded-full hover:bg-white/10 transition-colors z-10"
          >
            <X size={20} />
          </button>

          {/* Giant Animated Flame Icon */}
          <div className="relative w-24 h-24 mx-auto mb-4 flex items-center justify-center">
            <div className="absolute inset-0 bg-gradient-to-t from-orange-600 to-yellow-400 rounded-full blur-xl opacity-60 animate-pulse" />
            <div className="w-20 h-20 rounded-2xl bg-gradient-to-tr from-orange-500 via-amber-500 to-yellow-400 flex items-center justify-center shadow-lg border-2 border-orange-300 relative z-10 transform -rotate-3 hover:rotate-0 transition-transform">
              <Flame size={48} className="text-white fill-white drop-shadow-md" />
            </div>
          </div>

          <h2 className="text-3xl font-heading font-bold text-white mb-1">
            ¡{streakDays} {streakDays === 1 ? "Día" : "Días"} de Racha! 🔥
          </h2>
          <p className="text-zinc-400 text-sm mb-6">
            Programar a diario acelera tu memoria muscular y retención conceptual.
          </p>

          {/* 7-Day Week Calendar */}
          <div className="bg-black/50 border border-white/10 rounded-2xl p-4 mb-6">
            <div className="flex items-center justify-between gap-1 sm:gap-2">
              {days.map((day, idx) => {
                const isActive = idx <= currentDayIndex;
                const isToday = idx === currentDayIndex;

                return (
                  <div key={idx} className="flex flex-col items-center gap-1.5 flex-1">
                    <span className="text-[11px] font-bold text-zinc-400">{day}</span>
                    <div
                      className={`w-9 h-9 sm:w-10 sm:h-10 rounded-xl flex items-center justify-center text-xs font-bold transition-all ${
                        isToday
                          ? "bg-gradient-to-tr from-orange-500 to-amber-400 text-white shadow-[0_0_15px_rgba(249,115,22,0.6)] border-2 border-orange-200 scale-105"
                          : isActive
                          ? "bg-orange-500/20 text-orange-400 border border-orange-500/30"
                          : "bg-white/5 text-zinc-600 border border-white/5"
                      }`}
                    >
                      {isActive ? (
                        <Check size={16} strokeWidth={3} className={isToday ? "text-white" : "text-orange-400"} />
                      ) : (
                        <span className="text-zinc-600">•</span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Multiplier & Perk Card */}
          <div className="grid grid-cols-2 gap-3 mb-6">
            <div className="bg-orange-500/10 border border-orange-500/20 rounded-xl p-3.5 flex flex-col items-center">
              <div className="flex items-center gap-1 text-orange-400 text-xs font-bold mb-1">
                <Zap size={14} className="fill-orange-400" />
                <span>Multiplicador</span>
              </div>
              <span className="text-xl font-bold text-white font-mono">{multiplier}</span>
              <span className="text-[10px] text-zinc-400 mt-0.5">{multiplierLabel}</span>
            </div>

            <div className="bg-blue-500/10 border border-blue-500/20 rounded-xl p-3.5 flex flex-col items-center">
              <div className="flex items-center gap-1 text-blue-400 text-xs font-bold mb-1">
                <ShieldCheck size={14} />
                <span>Protector</span>
              </div>
              <span className="text-xl font-bold text-white font-mono">Activo</span>
              <span className="text-[10px] text-zinc-400 mt-0.5">Racha Segura</span>
            </div>
          </div>

          {/* Action button */}
          <Button 
            size="lg" 
            onClick={onClose}
            className="w-full bg-gradient-to-r from-orange-500 to-amber-500 hover:from-orange-600 hover:to-amber-600 text-white font-bold border-none shadow-[0_0_25px_rgba(249,115,22,0.4)]"
          >
            ¡A Seguir Programando! 🚀
          </Button>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
