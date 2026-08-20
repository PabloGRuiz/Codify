"use client";

import { useState } from "react";
import { Bell, Flame, User } from "lucide-react";
import Link from "next/link";
import { useUser } from "@/hooks/useUser";
import { StreakModal } from "@/components/dashboard/StreakModal";

export function Topbar() {
  const { profile } = useUser();
  const [showStreakModal, setShowStreakModal] = useState(false);
  const streak = profile?.streak_days || 1;

  return (
    <>
      <header className="h-20 w-full glass border-b border-border flex items-center justify-between px-6 lg:px-8 z-40 sticky top-0">
        <div className="flex-1">
          {/* Breadcrumbs or greeting */}
        </div>

        <div className="flex items-center gap-3 lg:gap-5">
          {/* Real Interactive Streak Indicator */}
          <button
            onClick={() => setShowStreakModal(true)}
            className="flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-orange-500/10 hover:bg-orange-500/20 border border-orange-500/30 text-orange-400 shadow-[0_0_20px_rgba(249,115,22,0.15)] hover:scale-105 transition-all cursor-pointer group"
            title="Ver tu progreso de racha diaria"
          >
            <Flame size={18} className="fill-orange-400 animate-pulse text-orange-400 group-hover:scale-110 transition-transform" />
            <span className="text-sm font-bold font-mono">{streak} {streak === 1 ? "Día" : "Días"}</span>
          </button>

          {/* Notifications Icon Placeholder */}
          <button className="relative p-2 text-zinc-400 hover:text-white transition-colors rounded-lg hover:bg-white/5">
            <Bell size={20} />
            <span className="absolute top-2 right-2 w-2 h-2 rounded-full bg-primary animate-pulse"></span>
          </button>

          {/* User Profile Avatar Link */}
          <Link href="/profile">
            <div className="flex items-center gap-3 p-1 rounded-full hover:bg-white/5 transition-colors cursor-pointer group">
              <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-accent to-primary p-[2px] shadow-lg group-hover:scale-105 transition-transform">
                <div className="w-full h-full rounded-full bg-secondary flex items-center justify-center overflow-hidden">
                  {profile?.avatar_url ? (
                    <img src={profile.avatar_url} alt="Avatar" className="w-full h-full object-cover" />
                  ) : (
                    <User size={18} className="text-zinc-300" />
                  )}
                </div>
              </div>
              <span className="text-sm font-medium text-white hidden md:inline font-sans pr-1">
                {profile?.username || "Perfil"}
              </span>
            </div>
          </Link>
        </div>
      </header>

      {/* Interactive Streak Modal */}
      <StreakModal
        isOpen={showStreakModal}
        onClose={() => setShowStreakModal(false)}
        streakDays={streak}
        xpPoints={profile?.xp || 0}
      />
    </>
  );
}
