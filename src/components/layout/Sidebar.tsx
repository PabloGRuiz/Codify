"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Code2, LayoutDashboard, TerminalSquare, LogOut, Menu, X } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";

export function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { profile } = useUser();
  const [isOpen, setIsOpen] = useState(false);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/auth");
  };

  const navItems = [
    { name: "Dashboard", href: "/", icon: <LayoutDashboard size={20} /> },
    { name: "Laboratorio Web", href: "/web", icon: <Code2 size={20} /> },
    { name: "IDE Algorítmico", href: "/ide", icon: <TerminalSquare size={20} /> },
  ];

  // XP Formula: Every level requires (level * 100) XP.
  const currentLevel = profile?.level || 1;
  const currentXp = profile?.xp || 0;
  const xpRequiredForNext = currentLevel * 100;
  const xpPercentage = Math.min(100, (currentXp / xpRequiredForNext) * 100);

  return (
    <>
      {/* Mobile Hamburger Button */}
      <button 
        onClick={() => setIsOpen(true)}
        className="md:hidden fixed top-4 left-4 z-40 p-2 bg-black/50 backdrop-blur-md rounded-lg border border-white/10 text-white hover:text-primary transition-colors"
      >
        <Menu size={24} />
      </button>

      {/* Mobile Overlay */}
      {isOpen && (
        <div 
          className="md:hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-40 transition-opacity"
          onClick={() => setIsOpen(false)}
        />
      )}

      {/* Sidebar Panel */}
      <aside 
        className={`w-64 h-screen glass border-r border-border fixed left-0 top-0 flex flex-col py-6 z-50 transition-transform duration-300 ease-in-out ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        } md:translate-x-0`}
      >
        <div className="px-6 mb-10 flex items-center justify-between">
          <div className="flex items-center gap-3 cursor-pointer">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-accent flex items-center justify-center animate-glow">
              <Code2 className="text-white" size={20} />
            </div>
            <span className="font-heading font-bold text-2xl bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">
              Codify
            </span>
          </div>

          {/* Close button for mobile */}
          <button onClick={() => setIsOpen(false)} className="md:hidden text-zinc-400 hover:text-white">
            <X size={24} />
          </button>
        </div>

        <nav className="flex-1 px-4 space-y-2">
          {navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link key={item.name} href={item.href} onClick={() => setIsOpen(false)}>
                <motion.div
                  whileHover={{ x: 5 }}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg cursor-pointer transition-colors ${
                    isActive
                      ? "bg-primary/20 text-primary border border-primary/30"
                      : "text-zinc-400 hover:text-white hover:bg-white/5"
                  }`}
                >
                  {item.icon}
                  <span className="font-medium font-sans">{item.name}</span>
                </motion.div>
              </Link>
            );
          })}
        </nav>

        <div className="px-6 mt-auto space-y-3">
          <div className="p-4 rounded-xl glass-panel">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-semibold text-zinc-300">
                {profile?.username ? `@${profile.username}` : "Coder"}
              </span>
              <span className="text-xs text-primary font-bold">Nivel {currentLevel}</span>
            </div>
            <div className="text-xs text-zinc-400 mb-2">{currentXp} / {xpRequiredForNext} XP</div>
            <div className="h-2 w-full bg-black/50 rounded-full overflow-hidden">
              <div 
                className="h-full bg-gradient-to-r from-primary to-accent transition-all duration-500"
                style={{ width: `${xpPercentage}%` }}
              ></div>
            </div>
          </div>
          
          <button 
            onClick={handleLogout}
            className="flex items-center gap-3 text-zinc-400 hover:text-red-400 w-full px-4 py-2 transition-colors text-sm font-medium"
          >
            <LogOut size={18} />
            <span>Cerrar Sesión</span>
          </button>
        </div>
      </aside>
    </>
  );
}
