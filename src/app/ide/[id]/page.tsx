"use client";

import { useState, useEffect } from "react";
import dynamic from "next/dynamic";
import ReactMarkdown from "react-markdown";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Play, TerminalSquare, RefreshCw, CheckCircle2, AlertCircle, ArrowLeft, BookOpen, Code2, ArrowRight, Lightbulb } from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import Link from "next/link";
import { useParams } from "next/navigation";

// Deshabilitar SSR para Monaco Editor
const CodeEditor = dynamic(() => import("@/components/ide/CodeEditor").then(mod => mod.CodeEditor), { ssr: false });

function TheoryRenderer({ content }: { content: string }) {
  if (!content) return null;

  return (
    <div className="space-y-4 font-sans text-zinc-300">
      <ReactMarkdown
        components={{
          h3: ({ children }) => (
            <h3 className="text-xl font-heading font-bold text-white mt-6 mb-3 flex items-center gap-2 border-b border-white/10 pb-2">
              {children}
            </h3>
          ),
          strong: ({ children }) => (
            <strong className="text-primary font-bold bg-primary/10 px-2 py-0.5 rounded border border-primary/20">
              {children}
            </strong>
          ),
          p: ({ children }) => (
            <p className="text-base text-zinc-300 leading-relaxed my-3 font-sans">
              {children}
            </p>
          ),
          ul: ({ children }) => (
            <ul className="space-y-2 my-4 pl-2 list-none">
              {children}
            </ul>
          ),
          li: ({ children }) => (
            <li className="flex items-start gap-2 text-zinc-200 text-base">
              <span className="text-primary font-bold shrink-0 mt-1">•</span>
              <div>{children}</div>
            </li>
          ),
          pre: ({ children }) => <>{children}</>,
          code({ node, inline, className, children, ...props }: any) {
            const match = /language-(\w+)/.exec(className || "");
            const codeString = String(children).replace(/\n$/, "");
            
            if (!inline) {
              return (
                <span className="block my-5 rounded-xl overflow-hidden border border-white/10 bg-[#0d0d11] font-mono text-sm shadow-xl">
                  <span className="bg-black/60 px-4 py-2 border-b border-white/10 text-xs text-zinc-400 flex items-center justify-between">
                    <span className="font-bold text-primary tracking-wider uppercase">
                      {match ? match[1] : "CÓDIGO DE EJEMPLO"}
                    </span>
                    <span className="text-[10px] text-zinc-500 font-mono">EJEMPLO INTERACTIVO</span>
                  </span>
                  <pre className="p-4 overflow-x-auto text-emerald-300 font-mono text-sm leading-relaxed border-none">
                    <code>{codeString}</code>
                  </pre>
                </span>
              );
            }

            return (
              <code className="bg-primary/20 text-primary border border-primary/30 px-2 py-0.5 rounded font-mono text-sm font-semibold">
                {children}
              </code>
            );
          },
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}

export default function ChallengeIDEPage() {
  const { id } = useParams();
  const { user, profile } = useUser();
  const [challenge, setChallenge] = useState<any>(null);
  const [code, setCode] = useState("");
  const [logs, setLogs] = useState<string[]>([]);
  const [isRunning, setIsRunning] = useState(false);
  const [status, setStatus] = useState<"idle" | "success" | "error">("idle");
  const [isCompleted, setIsCompleted] = useState(false);
  const [activeTab, setActiveTab] = useState<"theory" | "code">("theory");

  useEffect(() => {
    const fetchChallenge = async () => {
      const { data } = await supabase.from("challenges").select("*").eq("id", id).single();
      if (data) {
        setChallenge(data);
        setCode(data.initial_code || "");
        if (!data.theory) {
          setActiveTab("code");
        }
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
        const newLevel = Math.floor(newXp / 100) + 1;
        
        await supabase.from("profiles").update({
          xp: newXp,
          level: newLevel
        }).eq("id", user.id);
        
        setIsCompleted(true);
        alert(`¡Reto completado! Has ganado ${challenge.xp_reward} XP.`);
      } catch (e) {
        console.error("Error guardando progreso", e);
      }
    }
  };

  if (!challenge) return <div className="min-h-screen bg-background flex items-center justify-center text-white font-sans">Cargando micro-lección...</div>;

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="ml-64 flex-1 flex flex-col h-screen overflow-hidden">
        
        {/* Header */}
        <header className="h-16 w-full glass border-b border-border flex items-center justify-between px-6 shrink-0 z-20">
          <div className="flex items-center gap-4">
            <Link href="/ide" className="text-zinc-400 hover:text-white transition-colors flex items-center gap-2 font-sans text-sm">
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
          
          {/* Navigation Tabs between Theory and Practical Code */}
          <div className="flex items-center bg-black/40 p-1 rounded-lg border border-white/10">
            <button
              onClick={() => setActiveTab("theory")}
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-all ${
                activeTab === "theory"
                  ? "bg-primary text-white shadow-lg"
                  : "text-zinc-400 hover:text-white"
              }`}
            >
              <BookOpen size={15} /> 1. Lección Teórica
            </button>
            <button
              onClick={() => setActiveTab("code")}
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-all ${
                activeTab === "code"
                  ? "bg-primary text-white shadow-lg"
                  : "text-zinc-400 hover:text-white"
              }`}
            >
              <Code2 size={15} /> 2. Reto Práctico
            </button>
          </div>

          <div className="flex items-center gap-4">
            <span className="text-primary font-bold text-sm bg-primary/10 px-3 py-1.5 rounded-full border border-primary/20">
              +{challenge.xp_reward} XP
            </span>
            {activeTab === "code" && (
              <Button size="sm" onClick={runCodeAndTests} isLoading={isRunning} leftIcon={<Play size={16} />} className="shadow-[0_0_15px_rgba(139,92,246,0.3)]">
                Ejecutar Tests
              </Button>
            )}
          </div>
        </header>

        {/* Main Content Area */}
        <main className="flex-1 overflow-hidden p-6 bg-[#09090b]">
          {activeTab === "theory" ? (
            /* TAB 1: TEORÍA Y CONCEPTO */
            <div className="max-w-4xl mx-auto h-full flex flex-col justify-between overflow-y-auto pr-2">
              <div className="space-y-6 py-4">
                <div className="flex items-center gap-3 text-accent font-semibold">
                  <Lightbulb size={24} />
                  <span className="uppercase tracking-wider text-xs font-bold">Concepto & Lección Rápida</span>
                </div>

                <h2 className="text-3xl font-heading font-bold text-white">{challenge.title}</h2>

                <Card className="p-8 glass-panel border-l-4 border-l-primary space-y-4 shadow-2xl">
                  <TheoryRenderer content={challenge.theory || challenge.description} />
                </Card>
              </div>

              <div className="pt-6 pb-4 flex justify-end border-t border-white/10 shrink-0">
                <Button 
                  size="lg" 
                  onClick={() => setActiveTab("code")} 
                  rightIcon={<ArrowRight size={18} />}
                  className="shadow-[0_0_25px_rgba(139,92,246,0.5)] bg-gradient-to-r from-primary to-accent"
                >
                  ¡Entendido! Ir a la Práctica
                </Button>
              </div>
            </div>
          ) : (
            /* TAB 2: CÓDIGO Y PRÁCTICA */
            <div className="h-full flex flex-col gap-4">
              <div className="text-zinc-300 text-sm bg-black/40 p-4 rounded-xl border border-white/5 flex items-center justify-between shrink-0">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-full bg-blue-500/20 flex items-center justify-center text-blue-400 shrink-0">
                    ℹ️
                  </div>
                  <div>
                    <h3 className="font-bold text-white mb-0.5">Misión:</h3>
                    <p className="opacity-90">{challenge.description}</p>
                  </div>
                </div>
                <button 
                  onClick={() => setActiveTab("theory")}
                  className="text-xs text-primary hover:underline font-semibold shrink-0 ml-4 flex items-center gap-1.5 bg-primary/10 px-3 py-1.5 rounded-lg border border-primary/20"
                >
                  <BookOpen size={14} /> Repasar Teoría
                </button>
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
                    <span className="flex items-center gap-1 text-emerald-400 font-bold">
                      <CheckCircle2 size={13} /> Pasó las validaciones
                    </span>
                  )}
                  {status === "error" && (
                    <span className="flex items-center gap-1 text-red-400 font-bold">
                      <AlertCircle size={13} /> Errores encontrados
                    </span>
                  )}
                </div>

                <div className="flex-1 p-4 overflow-y-auto space-y-1 text-zinc-300">
                  {logs.length === 0 ? (
                    <div className="text-zinc-600 italic">Haz clic en "Ejecutar Tests" cuando termines de programar tu solución...</div>
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
            </div>
          )}
        </main>
      </div>
    </div>
  );
}
