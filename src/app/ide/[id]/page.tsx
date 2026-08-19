"use client";

import { useState, useEffect } from "react";
import dynamic from "next/dynamic";
import ReactMarkdown from "react-markdown";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { 
  Play, 
  TerminalSquare, 
  CheckCircle2, 
  AlertCircle, 
  ArrowLeft, 
  BookOpen, 
  Code2, 
  ArrowRight, 
  Lightbulb, 
  Trophy, 
  Star,
  PanelLeftClose,
  PanelLeftOpen
} from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";

import { QuizRunner } from "@/components/ide/QuizRunner";

// Deshabilitar SSR para Monaco Editor con Loading State amigable
const CodeEditor = dynamic(
  () => import("@/components/ide/CodeEditor").then((mod) => mod.CodeEditor),
  {
    ssr: false,
    loading: () => (
      <div className="w-full h-full flex flex-col items-center justify-center bg-[#1e1e1e] text-zinc-500 gap-3">
        <div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
        <p className="text-sm font-mono">Inicializando Motor de Código...</p>
      </div>
    ),
  }
);

function TheoryRenderer({ content }: { content: string }) {
  if (!content) return null;

  return (
    <div className="space-y-4 font-sans text-zinc-300">
      <ReactMarkdown
        components={{
          h3: ({ children }) => (
            <h3 className="text-lg sm:text-xl font-heading font-bold text-white mt-6 mb-3 flex items-center gap-2 border-b border-white/10 pb-2">
              {children}
            </h3>
          ),
          strong: ({ children }) => (
            <strong className="text-primary font-bold bg-primary/10 px-1.5 py-0.5 rounded border border-primary/20">
              {children}
            </strong>
          ),
          p: ({ children }) => (
            <p className="text-sm sm:text-base text-zinc-300 leading-relaxed my-2.5 font-sans">
              {children}
            </p>
          ),
          ul: ({ children }) => (
            <ul className="space-y-1.5 my-3 pl-1 list-none">{children}</ul>
          ),
          li: ({ children }) => (
            <li className="flex items-start gap-2 text-zinc-200 text-sm sm:text-base">
              <span className="text-primary font-bold shrink-0 mt-0.5">•</span>
              <div>{children}</div>
            </li>
          ),
          pre: ({ children }) => <>{children}</>,
          code({ node, className, children, ...props }: any) {
            const match = /language-(\w+)/.exec(className || "");
            const codeString = String(children).replace(/\n$/, "");
            const isBlock = match || codeString.includes("\n");

            if (isBlock) {
              return (
                <div className="my-4 rounded-xl overflow-hidden border border-white/10 bg-[#0d0d11] font-mono text-xs sm:text-sm shadow-xl">
                  <div className="bg-black/60 px-3.5 py-1.5 border-b border-white/10 text-xs text-zinc-400 flex items-center justify-between">
                    <span className="font-bold text-primary tracking-wider uppercase text-[11px]">
                      {match ? match[1] : "CÓDIGO DE EJEMPLO"}
                    </span>
                    <span className="text-[10px] text-zinc-500 font-mono">EJEMPLO</span>
                  </div>
                  <pre className="p-3.5 overflow-x-auto text-emerald-300 font-mono leading-relaxed whitespace-pre m-0">
                    <code>{codeString}</code>
                  </pre>
                </div>
              );
            }

            // Inline code rendering (compact and clean)
            return (
              <code className="bg-primary/20 text-purple-300 border border-primary/30 px-1.5 py-0.5 rounded font-mono text-xs font-semibold mx-0.5 inline-block">
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
  const router = useRouter();
  const { user, profile } = useUser();
  const { isCollapsed, toggleCollapse } = useSidebar();
  const [challenge, setChallenge] = useState<any>(null);
  const [code, setCode] = useState("");
  const [logs, setLogs] = useState<string[]>([]);
  const [isRunning, setIsRunning] = useState(false);
  const [status, setStatus] = useState<"idle" | "success" | "error">("idle");
  const [isCompleted, setIsCompleted] = useState(false);
  const [activeTab, setActiveTab] = useState<"theory" | "code">("theory");
  const [showSuccessModal, setShowSuccessModal] = useState(false);

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
      capturedLogs.push(args.map((a) => (typeof a === "object" ? JSON.stringify(a, null, 2) : String(a))).join(" "));
      originalLog(...args);
    };
    console.error = (...args: any[]) => {
      capturedLogs.push(`[ERROR] ${args.map((a) => String(a)).join(" ")}`);
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

    if (passed && !isCompleted) {
      setShowSuccessModal(true);
      if (user) {
        try {
          await supabase.from("user_progress").insert({
            user_id: user.id,
            challenge_id: challenge.id,
            status: "completed",
            code_snapshot: code,
            completed_at: new Date().toISOString(),
          });

          const newXp = (profile?.xp || 0) + challenge.xp_reward;
          const newLevel = Math.floor(newXp / 100) + 1;

          await supabase.from("profiles").update({ xp: newXp, level: newLevel }).eq("id", user.id);
          setIsCompleted(true);
        } catch (e) {
          console.error("Error guardando progreso", e);
        }
      }
    }
  };

  if (!challenge)
    return (
      <div className="min-h-screen bg-background flex flex-col items-center justify-center text-white gap-4">
        <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
        <p className="font-mono text-zinc-400">Cargando Lección...</p>
      </div>
    );

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col h-screen overflow-hidden transition-all duration-300`}>
        {/* Header */}
        <header className="h-16 w-full glass border-b border-border flex items-center justify-between px-4 lg:px-6 shrink-0 z-20 pl-16 md:pl-6">
          <div className="flex items-center gap-2 lg:gap-4">
            <Link href="/" className="text-zinc-400 hover:text-white transition-colors flex items-center gap-2 font-sans text-sm hidden sm:flex">
              <ArrowLeft size={16} /> Volver
            </Link>
            <div className="w-px h-6 bg-white/10 mx-2 hidden sm:block"></div>
            
            {/* Quick sidebar toggle on desktop header */}
            <button
              onClick={toggleCollapse}
              className="hidden md:flex p-1.5 rounded-lg text-zinc-400 hover:text-white hover:bg-white/10 transition-colors"
              title={isCollapsed ? "Expandir barra lateral" : "Colapsar barra lateral"}
            >
              {isCollapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
            </button>

            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-yellow-500/20 flex items-center justify-center shrink-0">
                <TerminalSquare size={18} className="text-yellow-400" />
              </div>
              <h1 className="font-heading font-bold text-base lg:text-lg text-white line-clamp-1">{challenge.title}</h1>
            </div>
          </div>

          {/* Mobile Navigation Tabs (Hidden on Desktop, where it's Side-by-Side) */}
          <div className="lg:hidden flex items-center bg-black/40 p-1 rounded-lg border border-white/10">
            <button
              onClick={() => setActiveTab("theory")}
              className={`flex items-center gap-1 px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                activeTab === "theory" ? "bg-primary text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <BookOpen size={14} /> <span className="hidden sm:inline">Teoría</span>
            </button>
            <button
              onClick={() => setActiveTab("code")}
              className={`flex items-center gap-1 px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                activeTab === "code" ? "bg-primary text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <Code2 size={14} /> <span className="hidden sm:inline">Código</span>
            </button>
          </div>

          <div className="flex items-center gap-4">
            <span className="text-primary font-bold text-xs lg:text-sm bg-primary/10 px-2 lg:px-3 py-1 lg:py-1.5 rounded-full border border-primary/20 hidden sm:block">
              +{challenge.xp_reward} XP
            </span>
            {challenge.challenge_type !== "quiz" && (
              <div className={`${activeTab === "code" ? "block" : "hidden lg:block"}`}>
                <Button size="sm" onClick={runCodeAndTests} isLoading={isRunning} leftIcon={<Play size={16} />} className="shadow-[0_0_15px_rgba(139,92,246,0.3)]">
                  <span className="hidden sm:inline">Ejecutar Tests</span>
                  <span className="sm:hidden">Ejecutar</span>
                </Button>
              </div>
            )}
          </div>
        </header>

        {/* Main Content Area: Quiz vs Code IDE */}
        {challenge.challenge_type === "quiz" ? (
          <main className="flex-1 p-4 lg:p-6 bg-[#09090b]">
            <QuizRunner
              questions={[
                {
                  id: "q1",
                  question: challenge.description || "¿Cuál es la sintaxis correcta?",
                  options: ["Opción A (Incorrecta)", "Opción B (Correcta)", "Opción C", "Opción D"],
                  correctIndex: 1,
                  explanation: "La opción B es la respuesta pedagógicamente correcta según la teoría mostrada."
                }
              ]}
              xpReward={challenge.xp_reward || 50}
              onComplete={() => setShowSuccessModal(true)}
            />
          </main>
        ) : (
          /* Main Content Area: Side-by-Side on Desktop, Tabs on Mobile */
          <main className="flex-1 overflow-hidden p-0 lg:p-4 bg-[#09090b] flex flex-col lg:flex-row gap-0 lg:gap-4 relative">
            
            {/* LEFT PANEL: Theory (Hidden on mobile if Code tab active) */}
            <div
              className={`w-full lg:w-[45%] xl:w-[40%] flex-col h-full bg-[#0d0d11] lg:rounded-2xl lg:border lg:border-white/10 overflow-hidden ${
                activeTab === "theory" ? "flex" : "hidden lg:flex"
              }`}
            >
              <div className="p-6 h-full flex flex-col overflow-y-auto custom-scrollbar">
                <div className="flex items-center gap-3 text-accent font-semibold mb-6">
                  <Lightbulb size={24} />
                  <span className="uppercase tracking-wider text-xs font-bold">Concepto & Lección</span>
                </div>
                <h2 className="text-2xl font-heading font-bold text-white mb-6">{challenge.title}</h2>
                <TheoryRenderer content={challenge.theory || challenge.description} />
                
                {/* Mobile next button */}
                <div className="pt-8 pb-4 lg:hidden">
                  <Button size="lg" onClick={() => setActiveTab("code")} rightIcon={<ArrowRight size={18} />} className="w-full shadow-lg">
                    Ir a Programar
                  </Button>
                </div>
              </div>
            </div>

            {/* RIGHT PANEL: Code & Terminal (Hidden on mobile if Theory tab active) */}
            <div
              className={`w-full lg:w-[55%] xl:w-[60%] flex-col h-full gap-2 lg:gap-4 ${
                activeTab === "code" ? "flex" : "hidden lg:flex"
              }`}
            >
              {/* Mobile instructions hint */}
              <div className="lg:hidden p-3 bg-blue-900/20 text-blue-300 text-xs flex items-center justify-between border-b border-blue-500/20">
                <span className="line-clamp-1">{challenge.description}</span>
                <button onClick={() => setActiveTab("theory")} className="font-bold underline shrink-0 ml-2">Ver Teoría</button>
              </div>

              {/* Top Right: Monaco Editor */}
              <div className="flex-1 relative lg:rounded-2xl overflow-hidden border-y lg:border border-white/10 shadow-lg">
                <CodeEditor language="javascript" value={code} onChange={(v) => setCode(v || "")} />
              </div>

              {/* Bottom Right: Interactive Terminal Console */}
              <div className="h-48 lg:h-56 lg:rounded-2xl bg-black border-t lg:border border-white/10 flex flex-col overflow-hidden font-mono text-sm shadow-xl shrink-0">
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

                <div className="flex-1 p-4 overflow-y-auto space-y-1 text-zinc-300 custom-scrollbar">
                  {logs.length === 0 ? (
                    <div className="text-zinc-600 italic">Haz clic en "Ejecutar Tests" cuando termines tu solución...</div>
                  ) : (
                    logs.map((log, index) => (
                      <div
                        key={index}
                        className={
                          log.includes("❌") || log.startsWith("[ERROR]")
                            ? "text-red-400"
                            : log.includes("✅")
                            ? "text-emerald-400 font-bold"
                            : "text-emerald-300"
                        }
                      >
                        {log}
                      </div>
                    ))
                  )}
                </div>
              </div>
            </div>
          </main>
        )}
      </div>

      {/* SUCCESS CELEBRATION MODAL (Replaces alert()) */}
      <AnimatePresence>
        {showSuccessModal && (
          <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="fixed inset-0 z-[100] bg-black/80 backdrop-blur-sm flex items-center justify-center p-4"
          >
            <motion.div
              initial={{ scale: 0.8, y: 50 }}
              animate={{ scale: 1, y: 0 }}
              transition={{ type: "spring", bounce: 0.5 }}
              className="bg-zinc-900 border-2 border-emerald-500/50 p-8 rounded-3xl shadow-[0_0_50px_rgba(16,185,129,0.2)] max-w-sm w-full text-center relative overflow-hidden"
            >
              {/* Confetti / Glow backdrop */}
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-emerald-500/20 blur-[60px] rounded-full pointer-events-none" />

              <div className="w-20 h-20 bg-emerald-500/20 rounded-full flex items-center justify-center mx-auto mb-6 border-4 border-emerald-500 shadow-[0_0_20px_rgba(16,185,129,0.4)] relative z-10">
                <Trophy size={40} className="text-emerald-400" />
              </div>
              
              <h2 className="text-3xl font-heading font-bold text-white mb-2 relative z-10">¡Nivel Superado!</h2>
              <p className="text-zinc-400 mb-6 relative z-10">Has resuelto el reto perfectamente.</p>

              <div className="bg-black/50 border border-emerald-500/20 rounded-xl p-4 flex items-center justify-center gap-3 mb-8 relative z-10">
                <Star size={24} className="text-yellow-400 fill-yellow-400" />
                <span className="text-2xl font-bold text-emerald-400">+{challenge.xp_reward} XP</span>
              </div>

              <div className="flex flex-col gap-3 relative z-10">
                <Button 
                  size="lg" 
                  onClick={() => router.push("/")}
                  className="w-full bg-emerald-500 hover:bg-emerald-600 text-black font-bold border-none"
                >
                  Continuar al Tablero
                </Button>
                <button 
                  onClick={() => setShowSuccessModal(false)}
                  className="text-sm text-zinc-400 hover:text-white transition-colors mt-2"
                >
                  Quedarme viendo el código
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
