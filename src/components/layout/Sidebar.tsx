"use client";

import { motion } from "framer-motion";
import { Code2, LayoutDashboard, TerminalSquare, LogOut } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";

export function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { profile } = useUser();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/auth");
  };

  const navItems = [
    { name: "Dashboard", href: "/", icon: <LayoutDashboard size={20} /> },
    { name: "Laboratorio Web", href: "/web", icon: <Code2 size={20} /> },
    { name: "IDE Algorítmico", href: "/ide", icon: <TerminalSquare size={20} /> },
  ];

  return (
    <aside className="w-64 h-screen glass border-r border-border fixed left-0 top-0 flex flex-col py-6 z-50">
      <div className="px-6 mb-10 flex items-center gap-3 cursor-pointer">
        <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-accent flex items-center justify-center animate-glow">
          <Code2 className="text-white" size={20} />
        </div>
        <span className="font-heading font-bold text-2xl bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">
          Codify
        </span>
      </div>

      <nav className="flex-1 px-4 space-y-2">
        {navItems.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link key={item.name} href={item.href}>
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
            <span className="text-xs text-primary font-bold">Nivel {profile?.level || 1}</span>
          </div>
          <div className="text-xs text-zinc-400 mb-2">{profile?.xp || 0} / 500 XP</div>
          <div className="h-2 w-full bg-black/50 rounded-full overflow-hidden">
            <div 
              className="h-full bg-gradient-to-r from-primary to-accent transition-all duration-500"
              style={{ width: `${Math.min(100, ((profile?.xp || 0) / 500) * 100)}%` }}
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
  );
}
