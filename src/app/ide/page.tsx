"use client";
import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { Sidebar } from "@/components/layout/Sidebar";
import { Card } from "@/components/ui/Card";
import Link from "next/link";
import { TerminalSquare, Play } from "lucide-react";

export default function IDEIndexPage() {
  const [challenges, setChallenges] = useState<any[]>([]);

  useEffect(() => {
    const fetchChallenges = async () => {
      const { data, error } = await supabase.from("challenges").select("*").eq("challenge_type", "logic").order("order_index", { ascending: true });
      if (error) {
        console.error("Error cargando retos:", error);
      }
      if (data) {
        setChallenges(data);
      }
    };
    fetchChallenges();
  }, []);

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="ml-64 flex-1 p-8">
        <header className="mb-8 flex items-center gap-3">
          <div className="w-12 h-12 rounded-xl bg-yellow-500/20 flex items-center justify-center">
            <TerminalSquare className="text-yellow-400" size={24} />
          </div>
          <div>
            <h1 className="text-3xl font-heading font-bold text-white">Retos Algorítmicos</h1>
            <p className="text-zinc-400">Resuelve problemas, pasa los tests ocultos y gana XP.</p>
          </div>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {challenges.length === 0 ? (
            <p className="text-zinc-400 col-span-full">No hay retos disponibles. Usa el panel de admin para crearlos.</p>
          ) : (
            challenges.map(c => (
              <Card key={c.id} className="p-6 glass-panel hover:border-primary/50 transition-colors flex flex-col h-full">
                <h2 className="text-xl font-bold text-white mb-2">{c.title}</h2>
                <p className="text-zinc-400 text-sm mb-6 line-clamp-3 flex-1">{c.description}</p>
                
                <div className="flex items-center justify-between pt-4 border-t border-white/5">
                  <span className="text-primary font-bold text-sm bg-primary/10 px-2 py-1 rounded">+{c.xp_reward} XP</span>
                  <Link href={`/ide/${c.id}`}>
                    <button className="flex items-center gap-2 bg-white text-black px-4 py-2 rounded-lg hover:bg-zinc-200 transition-colors text-sm font-semibold">
                      <Play size={14} className="fill-black" /> Resolver
                    </button>
                  </Link>
                </div>
              </Card>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
