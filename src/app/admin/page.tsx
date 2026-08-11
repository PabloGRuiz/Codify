"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { ShieldAlert, Plus } from "lucide-react";

export default function AdminPage() {
  const [modules, setModules] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  
  // New Challenge State
  const [moduleId, setModuleId] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [challengeType, setChallengeType] = useState("logic");
  const [initialCode, setInitialCode] = useState("");
  const [solutionCode, setSolutionCode] = useState("");
  const [testCode, setTestCode] = useState("");
  const [theory, setTheory] = useState("");
  const [xpReward, setXpReward] = useState("50");

  // New Module State
  const [newModuleTitle, setNewModuleTitle] = useState("");
  const [newModuleDescription, setNewModuleDescription] = useState("");
  const [newModuleDifficulty, setNewModuleDifficulty] = useState("1");

  useEffect(() => {
    fetchModules();
  }, []);

  const fetchModules = async () => {
    const { data } = await supabase.from("modules").select("*");
    if (data) {
      setModules(data);
      if (data.length > 0 && !moduleId) setModuleId(data[0].id);
    }
    setLoading(false);
  };

  const handleCreateModule = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.from("modules").insert({
      title: newModuleTitle,
      description: newModuleDescription,
      difficulty_level: parseInt(newModuleDifficulty),
    });

    if (error) {
      alert("Error al crear módulo: " + error.message);
    } else {
      alert("¡Módulo creado exitosamente!");
      setNewModuleTitle("");
      setNewModuleDescription("");
      fetchModules(); // Refresh modules list
    }
  };

  const handleCreateChallenge = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.from("challenges").insert({
      module_id: moduleId,
      title,
      description,
      theory,
      challenge_type: challengeType,
      initial_code: initialCode,
      solution_code: solutionCode,
      test_code: testCode,
      xp_reward: parseInt(xpReward),
    });

    if (error) {
      alert("Error al crear reto: " + error.message);
    } else {
      alert("¡Reto creado exitosamente!");
      setTitle("");
      setDescription("");
      setTheory("");
      setInitialCode("");
      setSolutionCode("");
      setTestCode("");
    }
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="ml-64 flex-1 p-8 overflow-y-auto">
        <header className="mb-8 flex items-center gap-3">
          <ShieldAlert className="text-danger" size={32} />
          <h1 className="text-3xl font-heading font-bold text-white">Panel de Administración</h1>
        </header>

        <div className="grid grid-cols-1 xl:grid-cols-2 gap-8">
          {/* Form to Create Module */}
          <Card className="p-6 glass-panel h-fit">
            <h2 className="text-xl font-bold mb-6 flex items-center gap-2 text-accent">
              <Plus size={20} />
              1. Crear Nuevo Módulo
            </h2>
            <form onSubmit={handleCreateModule} className="space-y-4">
              <div>
                <label className="block text-sm text-zinc-400 mb-1">Título del Módulo</label>
                <input required type="text" value={newModuleTitle} onChange={e => setNewModuleTitle(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent" placeholder="Ej: Fundamentos de JS" />
              </div>
              <div>
                <label className="block text-sm text-zinc-400 mb-1">Descripción</label>
                <textarea required value={newModuleDescription} onChange={e => setNewModuleDescription(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent h-24" />
              </div>
              <div>
                <label className="block text-sm text-zinc-400 mb-1">Nivel de Dificultad</label>
                <input required type="number" value={newModuleDifficulty} onChange={e => setNewModuleDifficulty(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent" />
              </div>
              <Button type="submit" className="w-full py-4 mt-4 bg-accent hover:bg-accent/80 text-white shadow-[0_0_15px_rgba(56,189,248,0.3)]">
                Crear Módulo Oficial
              </Button>
            </form>
          </Card>

          {/* Form to Create Challenge */}
          <Card className="p-6 glass-panel">
            <h2 className="text-xl font-bold mb-6 flex items-center gap-2 text-primary">
              <Plus size={20} />
              2. Crear Nuevo Reto
            </h2>
            <form onSubmit={handleCreateChallenge} className="space-y-4">
              <div>
                <label className="block text-sm text-zinc-400 mb-1">Módulo Asociado</label>
                <select 
                  value={moduleId} 
                  onChange={e => setModuleId(e.target.value)}
                  className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary"
                  required
                >
                  <option value="" disabled>Selecciona un módulo...</option>
                  {modules.map(m => (
                    <option key={m.id} value={m.id}>{m.title}</option>
                  ))}
                </select>
                {modules.length === 0 && (
                  <p className="text-xs text-danger mt-1">No hay módulos creados en la base de datos.</p>
                )}
              </div>
              
              <div>
                <label className="block text-sm text-zinc-400 mb-1">Título del Reto</label>
                <input required type="text" value={title} onChange={e => setTitle(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary" />
              </div>

              <div>
                <label className="block text-sm text-zinc-400 mb-1">Descripción Breve (Consigna)</label>
                <textarea required value={description} onChange={e => setDescription(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary h-20" />
              </div>

              <div>
                <label className="block text-sm text-zinc-400 mb-1">📚 Contenido Teórico / Micro-lección (Markdown/Texto)</label>
                <textarea value={theory} onChange={e => setTheory(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary h-36 font-mono text-sm" placeholder="Ejemplo: En este reto aprenderás qué es una función pura...&#10;&#10;Sintaxis:&#10;function miFuncion(a, b) { return a + b; }" />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-zinc-400 mb-1">Tipo de Entorno</label>
                  <select value={challengeType} onChange={e => setChallengeType(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary">
                    <option value="logic">Lógica Algorítmica (JS/Python)</option>
                    <option value="web">Prototipado Web (HTML/CSS/JS)</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-zinc-400 mb-1">XP de Recompensa</label>
                  <input required type="number" value={xpReward} onChange={e => setXpReward(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary" />
                </div>
              </div>

              <div>
                <label className="block text-sm text-zinc-400 mb-1">Código Inicial (Para el Estudiante)</label>
                <textarea value={initialCode} onChange={e => setInitialCode(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white font-mono text-sm h-32 outline-none focus:border-primary" />
              </div>

              <div>
                <label className="block text-sm text-zinc-400 mb-1">Código de Tests Unitarios Ocultos</label>
                <textarea value={testCode} onChange={e => setTestCode(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white font-mono text-sm h-32 outline-none focus:border-primary" placeholder="Ejemplo: const assert = (c, m) => { if(!c) throw new Error(m); };&#10;assert(miFuncion(2) === 4, 'Falla en el caso 2');" />
              </div>

              <Button type="submit" className="w-full py-4 mt-4">Crear Reto Oficial</Button>
            </form>
          </Card>
        </div>
      </div>
    </div>
  );
}
