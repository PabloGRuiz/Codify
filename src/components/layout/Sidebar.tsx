"use client";

import { motion } from "framer-motion";
import { 
  Code2, 
  LayoutDashboard, 
  LogOut, 
  Menu, 
  X, 
  PanelLeftClose, 
  PanelLeftOpen,
  User as UserIcon,
  MessageSquare,
  Star
} from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";
import { useSidebar } from "@/context/SidebarContext";
import { getLevelInfo } from "@/lib/gamification";

export function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { profile } = useUser();
  const { isCollapsed, toggleCollapse, isMobileOpen, setIsMobileOpen } = useSidebar();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/auth");
  };

  const navItems = [
    { name: "Dashboard", href: "/", icon: <LayoutDashboard size={20} /> },
    { name: "Laboratorio Web", href: "/web", icon: <Code2 size={20} /> },
    { name: "Foro Comunitario", href: "/foro", icon: <MessageSquare size={20} /> },
  ];

  const levelInfo = getLevelInfo(profile?.xp);
  const currentLevel = levelInfo.level;
  const currentStars = profile?.reputation_stars || 0;
  const xpPercentage = levelInfo.progressPercentage;

  return (
    <>
      {/* Mobile Hamburger Button */}
      <button 
        onClick={() => setIsMobileOpen(true)}
        className="md:hidden fixed top-4 left-4 z-40 p-2 bg-black/50 backdrop-blur-md rounded-lg border border-white/10 text-white hover:text-primary transition-colors shadow-lg"
        title="Abrir menú"
      >
        <Menu size={24} />
      </button>

      {/* Mobile Overlay */}
      {isMobileOpen && (
        <div 
          className="md:hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-40 transition-opacity"
          onClick={() => setIsMobileOpen(false)}
        />
      )}

      {/* Sidebar Panel */}
      <aside 
        className={`h-screen glass border-r border-border fixed left-0 top-0 flex flex-col py-6 z-50 transition-all duration-300 ease-in-out ${
          isMobileOpen ? "translate-x-0 w-64" : "-translate-x-full"
        } md:translate-x-0 ${isCollapsed ? "md:w-20" : "md:w-64"}`}
      >
        {/* Header with Logo and Collapse Toggle */}
        <div className={`px-4 mb-8 flex items-center ${isCollapsed ? "justify-center" : "justify-between"}`}>
          <Link href="/" className="flex items-center gap-3 cursor-pointer overflow-hidden">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-accent flex items-center justify-center animate-glow shrink-0">
              <Code2 className="text-white" size={20} />
            </div>
            {!isCollapsed && (
              <span className="font-heading font-bold text-2xl bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent whitespace-nowrap">
                Codify
              </span>
            )}
          </Link>

          {/* Desktop Collapse Toggle Button */}
          <button
            onClick={toggleCollapse}
            className="hidden md:flex p-1.5 rounded-lg text-zinc-400 hover:text-white hover:bg-white/10 transition-colors"
            title={isCollapsed ? "Expandir barra lateral" : "Colapsar barra lateral"}
          >
            {isCollapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
          </button>

          {/* Mobile Close Button */}
          <button 
            onClick={() => setIsMobileOpen(false)} 
            className="md:hidden text-zinc-400 hover:text-white"
          >
            <X size={24} />
          </button>
        </div>

        {/* Navigation items */}
        <nav className="flex-1 px-3 space-y-2">
          {navItems.map((item) => {
            const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`);
            return (
              <Link 
                key={item.name} 
                href={item.href} 
                onClick={() => setIsMobileOpen(false)}
                title={isCollapsed ? item.name : undefined}
              >
                <motion.div
                  whileHover={{ x: isCollapsed ? 0 : 4 }}
                  className={`flex items-center gap-3 px-3.5 py-3 rounded-xl cursor-pointer transition-all ${
                    isCollapsed ? "justify-center" : ""
                  } ${
                    isActive
                      ? "bg-primary/20 text-primary border border-primary/30 font-bold shadow-lg"
                      : "text-zinc-400 hover:text-white hover:bg-white/5 font-medium"
                  }`}
                >
                  <div className="shrink-0">{item.icon}</div>
                  {!isCollapsed && (
                    <span className="font-sans whitespace-nowrap text-sm">{item.name}</span>
                  )}
                </motion.div>
              </Link>
            );
          })}
        </nav>

        {/* Footer Profile & Logout */}
        <div className="px-3 mt-auto space-y-3">
          <Link 
            href="/profile" 
            onClick={() => setIsMobileOpen(false)}
            title={isCollapsed ? `Nivel ${currentLevel} - ${profile?.username || "Coder"} (${currentStars} ⭐)` : undefined}
          >
            <div className={`p-3 rounded-xl glass-panel hover:border-primary/50 transition-all cursor-pointer group ${
              isCollapsed ? "flex flex-col items-center justify-center gap-1.5" : ""
            }`}>
              {isCollapsed ? (
                <div className="flex flex-col items-center">
                  <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-accent to-primary p-[2px]">
                    <div className="w-full h-full rounded-full bg-secondary flex items-center justify-center overflow-hidden">
                      {profile?.avatar_url ? (
                        <img src={profile.avatar_url} alt="Avatar" className="w-full h-full object-cover" />
                      ) : (
                        <UserIcon size={14} className="text-zinc-300" />
                      )}
                    </div>
                  </div>
                  <div className="flex flex-col items-center mt-1">
                    <span className="text-[10px] text-primary font-bold">Nv {currentLevel}</span>
                    <span className="text-[10px] text-yellow-500 font-bold flex items-center"><Star size={8} className="fill-yellow-500 mr-0.5" />{currentStars}</span>
                  </div>
                </div>
              ) : (
                <>
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-semibold text-zinc-300 group-hover:text-primary transition-colors truncate">
                      {profile?.username ? `@${profile.username}` : "Coder"}
                    </span>
                    <span className="text-xs text-primary font-bold shrink-0">Nivel {currentLevel}</span>
                  </div>
                  <div className="flex justify-between items-center text-xs mb-2">
                    <span className="text-zinc-400">{levelInfo.xpInLevel} / {levelInfo.xpRequiredForNextLevel} XP</span>
                    <span className="flex items-center gap-1 text-yellow-500 font-bold bg-yellow-500/10 px-1.5 py-0.5 rounded border border-yellow-500/20" title="Puntos de Reputación en el Foro">
                      <Star size={12} className="fill-yellow-500" /> {currentStars}
                    </span>
                  </div>
                  <div className="h-2 w-full bg-black/50 rounded-full overflow-hidden">
                    <div 
                      className="h-full bg-gradient-to-r from-primary to-accent transition-all duration-500"
                      style={{ width: `${xpPercentage}%` }}
                    ></div>
                  </div>
                </>
              )}
            </div>
          </Link>
          
          <button 
            onClick={handleLogout}
            className={`flex items-center gap-3 text-zinc-400 hover:text-red-400 w-full p-2.5 transition-colors text-sm font-medium rounded-xl hover:bg-red-500/10 ${
              isCollapsed ? "justify-center" : "px-3"
            }`}
            title={isCollapsed ? "Cerrar Sesión" : undefined}
          >
            <LogOut size={18} className="shrink-0" />
            {!isCollapsed && <span>Cerrar Sesión</span>}
          </button>
        </div>
      </aside>
    </>
  );
}
