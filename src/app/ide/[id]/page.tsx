"use client";

import { useState, useEffect } from "react";
import dynamic from "next/dynamic";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Play, TerminalSquare, RefreshCw, CheckCircle2, AlertCircle, ArrowLeft } from "lucide-react";

// Deshabilitar SSR para Monaco Editor
const CodeEditor = dynamic(() => import("@/components/ide/CodeEditor").then(mod => mod.CodeEditor), { ssr: false });
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import Link from "next/link";
import { useParams } from "next/navigation";

export default function ChallengeIDEPage() {
  const { id } = useParams();
  const { user, profile } = useUser();
  const [challenge, setChallenge] = useState<any>(null);
  const [code, setCode] = useState("");
  const [logs, setLogs] = useState<string[]>([]);
  const [isRunning, setIsRunning] = useState(false);
  const [status, setStatus] = useState<"idle" | "success" | "error">("idle");
  const [isCompleted, setIsCompleted] = useState(false);

  useEffect(() => {
    const fetchChallenge = async () => {
      const { data } = await supabase.from("challenges").select("*").eq("id", id).single();
      if (data) {
        setChallenge(data);
        setCode(data.initial_code || "");
      }
    };
    if (id) fetchChallenge();
  }, [id]);

  const runCodeAndTests = async () => {
    if (!challenge) return;
    setIsRunning(true);
    setLogs([]);
    setStatus("idle");

    const capturedLogs: string[] = [];
    const originalLog = console.log;
    const originalError = console.error;

    console.log = (...args: any[]) => {
      capturedLogs.push(args.map(a => typeof a === "object" ? JSON.stringify(a, null, 2) : String(a)).join(" "));
      originalLog(...args);
    };
    console.error = (...args: any[]) => {
      capturedLogs.push(`[ERROR] ${args.map(a => String(a)).join(" ")}`);
      originalError(...args);
    };

    let passed = false;
    try {
      // Unimos el código del usuario con los tests unitarios ocultos
      const fullCode = `${code}\n\n${challenge.test_code || ""}`;
      const runFn = new Function(fullCode);
      runFn(); 
      setLogs([...capturedLogs, "✅ ¡Todos los tests ocultos pasaron exitosamente!"]);
      setStatus("success");
      passed = true;
    } catch (err: any) {
      setLogs([...capturedLogs, `❌ Error en los tests: ${err.message}`]);
      setStatus("error");
    } finally {
      console.log = originalLog;
      console.error = originalError;
      setIsRunning(false);
    }

    // Si pasó y está logueado, damos XP
    if (passed && user && !isCompleted) {
      try {
        await supabase.from("user_progress").insert({
          user_id: user.id,
          challenge_id: challenge.id,
          status: "completed",
          code_snapshot: code,
          completed_at: new Date().toISOString()
        });
        
        const newXp = (profile?.xp || 0) + challenge.xp_reward;
        const newLevel = Math.floor(newXp / 100) + 1; // Cada 100 XP es 1 nivel
        
        await supabase.from("profiles").update({
          xp: newXp,
          level: newLevel
        }).eq("id", user.id);
        
        setIsCompleted(true);
        alert(`¡Reto completado! Has ganado ${challenge.xp_reward} XP. Tu código ha sido guardado en la base de datos.`);
      } catch (e) {
        console.error("Error guardando progreso", e);
      }
    }
  };

  if (!challenge) return <div className="min-h-screen bg-background flex items-center justify-center text-white">Cargando entorno del reto...</div>;

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="ml-64 flex-1 flex flex-col h-screen overflow-hidden">
        
        {/* Header */}
        <header className="h-16 w-full glass border-b border-border flex items-center justify-between px-6 shrink-0">
          <div className="flex items-center gap-4">
            <Link href="/ide" className="text-zinc-400 hover:text-white transition-colors flex items-center gap-2">
              <ArrowLeft size={16} /> Volver
            </Link>
            <div className="w-px h-6 bg-white/10 mx-2"></div>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-yellow-500/20 flex items-center justify-center">
                <TerminalSquare size={18} className="text-yellow-400" />
              </div>
              <h1 className="font-heading font-bold text-lg text-white">{challenge.title}</h1>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <span className="text-primary font-bold text-sm bg-primary/10 px-3 py-1.5 rounded-full border border-primary/20">
              Premio: {challenge.xp_reward} XP
            </span>
            <Button size="sm" variant="secondary" onClick={() => setLogs([])} leftIcon={<RefreshCw size={14} />}>
              Limpiar Consola
            </Button>
            <Button size="sm" onClick={runCodeAndTests} isLoading={isRunning} leftIcon={<Play size={16} />} className="shadow-[0_0_15px_rgba(139,92,246,0.3)]">
              Ejecutar Tests Ocultos
            </Button>
          </div>
        </header>

        {/* Workspace: Split Vertically */}
        <main className="flex-1 flex flex-col overflow-hidden p-4 gap-4 bg-[#09090b]">
          
          <div className="text-zinc-300 text-sm bg-black/40 p-4 rounded-xl border border-white/5 flex gap-4 items-start shrink-0">
            <div className="w-8 h-8 rounded-full bg-blue-500/20 flex items-center justify-center text-blue-400 shrink-0">
              ℹ️
            </div>
            <div>
              <h3 className="font-bold text-white mb-1">Misión:</h3>
              <p className="opacity-90">{challenge.description}</p>
            </div>
          </div>

          {/* Top Panel: Monaco Editor */}
          <div className="flex-1 relative min-h-[40%]">
            <CodeEditor language="javascript" value={code} onChange={(v) => setCode(v || "")} />
          </div>

          {/* Bottom Panel: Interactive Terminal Console */}
          <div className="h-48 rounded-xl bg-black border border-border flex flex-col overflow-hidden font-mono text-sm shadow-xl shrink-0">
            <div className="h-9 bg-zinc-900/80 px-4 flex items-center justify-between border-b border-zinc-800 text-xs text-zinc-400">
              <div className="flex items-center gap-2">
                <TerminalSquare size={14} />
                <span>Salida de Consola y Validaciones</span>
              </div>
              {status === "success" && (
                <span className="flex items-center gap-1 text-emerald-400">
                  <CheckCircle2 size={13} /> Pasó las validaciones
                </span>
              )}
              {status === "error" && (
                <span className="flex items-center gap-1 text-red-400">
                  <AlertCircle size={13} /> Errores encontrados
                </span>
              )}
            </div>

            <div className="flex-1 p-4 overflow-y-auto space-y-1 text-zinc-300">
              {logs.length === 0 ? (
                <div className="text-zinc-600 italic">Haz clic en "Ejecutar Tests Ocultos" cuando termines de programar tu solución...</div>
              ) : (
                logs.map((log, index) => (
                  <div 
                    key={index} 
                    className={log.includes("❌") || log.startsWith("[ERROR]") || log.startsWith("[Exception Error]") ? "text-red-400" : (log.includes("✅") ? "text-emerald-400 font-bold" : "text-emerald-300")}
                  >
                    {log}
                  </div>
                ))
              )}
            </div>
          </div>

        </main>
      </div>
    </div>
  );
}
