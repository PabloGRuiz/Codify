"use client";

import { useState, useEffect, useRef } from "react";
import dynamic from "next/dynamic";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
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
  PanelLeftOpen,
  Globe,
  RefreshCw,
  Eye,
  Flag,
  Paintbrush,
  Braces,
  RotateCcw,
  Database
} from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";

import { QuizRunner } from "@/components/ide/QuizRunner";
import { ReportIssueModal } from "@/components/ide/ReportIssueModal";
import { ProjectFileTree, getFileLanguage } from "@/components/ide/ProjectFileTree";
import { getLevelInfo } from "@/lib/gamification";

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

function formatMathAndMarkdown(content: string): string {
  if (!content) return "";

  return content
    .replace(/\\r\\n/g, "\n")
    .replace(/\\n/g, "\n")
    // Fix collapsed markdown table rows (where newlines were lost as "| |" or "||")
    .replace(/\|\s*\|\s*/g, "|\n| ")
    .replace(/\|\s*:\-\-/g, "\n| :--")
    // Mathematical & Big-O notation cleanups
    .replace(/\$\\log_2\(([^)]+)\)\s*\\approx\s*([^$]+)\$/g, "log₂($1) ≈ $2")
    .replace(/\$O\(\\log\s*N\)\$/gi, "`O(log N)`")
    .replace(/\$O\(N\s*\\log\s*N\)\$/gi, "`O(N log N)`")
    .replace(/\$O\(([^$]+)\)\$/g, "`O($1)`")
    .replace(/\$1\.000\.000\$/g, "1.000.000")
    .replace(/\$2\^8\s*=\s*256\$/g, "2⁸ = 256")
    .replace(/\$2\^(\w+)\$/g, "2^$1")
    .replace(/\$N\$/g, "*N*")
    .replace(/\\approx/g, "≈")
    .replace(/\\log_2/g, "log₂")
    .replace(/\\log/g, "log")
    .replace(/\\cdot/g, "·")
    .replace(/\\times/g, "×")
    .replace(/\\le(q)?/g, "≤")
    .replace(/\\ge(q)?/g, "≥")
    .replace(/\\ne(q)?/g, "≠")
    .replace(/\$([^$]+)\$/g, "$1");
}

function TheoryRenderer({ content }: { content: string }) {
  if (!content) return null;

  const formattedContent = formatMathAndMarkdown(content);

  return (
    <div className="space-y-4 font-sans text-zinc-300">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          h1: ({ children }) => (
            <h1 className="text-2xl sm:text-3xl font-heading font-black text-white mt-4 mb-3 border-b border-white/10 pb-2">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 className="text-xl sm:text-2xl font-heading font-bold text-indigo-400 mt-6 mb-3 border-b border-white/10 pb-2">
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 className="text-lg sm:text-xl font-heading font-bold text-white mt-5 mb-2.5 flex items-center gap-2 border-b border-white/10 pb-1.5">
              {children}
            </h3>
          ),
          h4: ({ children }) => (
            <h4 className="text-base font-heading font-bold text-purple-300 mt-4 mb-2">
              {children}
            </h4>
          ),
          strong: ({ children }) => (
            <strong className="text-white font-bold bg-white/10 px-1.5 py-0.5 rounded border border-white/15">
              {children}
            </strong>
          ),
          p: ({ children }) => (
            <p className="text-sm sm:text-base text-zinc-300 leading-relaxed my-3 font-sans">
              {children}
            </p>
          ),
          ul: ({ children }) => (
            <ul className="space-y-2 my-3 pl-2 list-none">{children}</ul>
          ),
          ol: ({ children }) => (
            <ol className="space-y-2 my-3 pl-4 list-decimal text-zinc-300">{children}</ol>
          ),
          li: ({ children }) => (
            <li className="flex items-start gap-2 text-zinc-200 text-sm sm:text-base leading-relaxed">
              <span className="text-primary font-bold shrink-0 mt-0.5">•</span>
              <div className="flex-1">{children}</div>
            </li>
          ),
          table: ({ children }) => (
            <div className="my-4 overflow-x-auto rounded-xl border border-white/10 bg-black/40 shadow-xl">
              <table className="w-full text-left text-sm text-zinc-300 border-collapse">
                {children}
              </table>
            </div>
          ),
          thead: ({ children }) => (
            <thead className="bg-white/5 border-b border-white/10 text-xs font-bold uppercase tracking-wider text-indigo-300">
              {children}
            </thead>
          ),
          tbody: ({ children }) => (
            <tbody className="divide-y divide-white/5">
              {children}
            </tbody>
          ),
          tr: ({ children }) => (
            <tr className="hover:bg-white/5 transition-colors">
              {children}
            </tr>
          ),
          th: ({ children }) => (
            <th className="px-4 py-3 font-bold text-white">
              {children}
            </th>
          ),
          td: ({ children }) => (
            <td className="px-4 py-2.5 text-zinc-300 text-xs sm:text-sm">
              {children}
            </td>
          ),
          blockquote: ({ children }) => (
            <blockquote className="my-4 border-l-4 border-indigo-500 bg-indigo-500/10 px-4 py-3 rounded-r-xl text-zinc-200 text-sm italic">
              {children}
            </blockquote>
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

            return (
              <code className="bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-1.5 py-0.5 rounded font-mono text-xs font-bold mx-0.5 inline-block shadow-sm">
                {children}
              </code>
            );
          },
        }}
      >
        {formattedContent}
      </ReactMarkdown>
    </div>
  );
}

const detectChallengeLanguage = (data: any): "html" | "css" | "javascript" | "python" | "cpp" | "sql" => {
  if (!data) return "javascript";
  if (data.language) return data.language;
  if (data.challenge_type === "web" || data.challenge_type === "html") return "html";
  if (data.challenge_type === "css") return "css";
  if (data.challenge_type === "python") return "python";
  if (data.challenge_type === "cpp") return "cpp";
  if (data.challenge_type === "sql") return "sql";

  const initial = (data.initial_code || "").trim();
  const title = (data.title || "").toLowerCase();
  const modTitle = (data.modules?.title || "").toLowerCase();

  if (
    initial.startsWith("<!DOCTYPE") ||
    initial.startsWith("<html") ||
    initial.startsWith("<div") ||
    initial.startsWith("<header") ||
    initial.startsWith("<main") ||
    initial.startsWith("<form") ||
    title.includes("html") ||
    modTitle.includes("html")
  ) {
    return "html";
  }
  if (
    initial.includes("@media") ||
    (initial.includes("{") && initial.includes(":") && !initial.includes("function") && !initial.includes("const") && !initial.includes("let")) ||
    title.includes("css") ||
    modTitle.includes("css")
  ) {
    return "css";
  }
  if (initial.includes("#include") || initial.includes("std::") || title.includes("c++") || modTitle.includes("c++")) {
    return "cpp";
  }
  if (initial.startsWith("def ") || initial.startsWith("import ") || title.includes("python") || modTitle.includes("python")) {
    return "python";
  }
  if (initial.toUpperCase().startsWith("SELECT") || title.includes("sql") || modTitle.includes("sql")) {
    return "sql";
  }
  return "javascript";
};

export default function ChallengeIDEPage() {
  const { id } = useParams();
  const router = useRouter();
  const { user, profile } = useUser();
  const { isCollapsed, toggleCollapse } = useSidebar();
  const [challenge, setChallenge] = useState<any>(null);
  const [files, setFiles] = useState<Record<string, string>>({ "index.html": "" });
  const [activeFile, setActiveFile] = useState("index.html");
  const [selectedLanguage, setSelectedLanguage] = useState<string>("html");
  const [logs, setLogs] = useState<string[]>([]);
  const [isRunning, setIsRunning] = useState(false);
  const [status, setStatus] = useState<"idle" | "success" | "error">("idle");
  const [isCompleted, setIsCompleted] = useState(false);
  const [activeTab, setActiveTab] = useState<"theory" | "code">("theory");
  const [bottomTab, setBottomTab] = useState<"console" | "preview">("console");
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [showReportModal, setShowReportModal] = useState(false);
  
  const iframeRef = useRef<HTMLIFrameElement>(null);

  // Helper para inicializar archivos desde initial_code
  const parseInitialFiles = (data: any): { files: Record<string, string>; activeFile: string } => {
    const raw = (data.initial_code || "").trim();
    if (raw.startsWith("{") && raw.includes('"files"')) {
      try {
        const parsed = JSON.parse(raw);
        if (parsed && typeof parsed.files === "object") {
          const fileKeys = Object.keys(parsed.files);
          const active = parsed.activeFile && parsed.files[parsed.activeFile] !== undefined
            ? parsed.activeFile
            : (fileKeys.includes("index.html") ? "index.html" : fileKeys[0] || "index.html");
          return { files: parsed.files, activeFile: active };
        }
      } catch (e) {
        console.error("Error al parsear proyecto JSON de reto", e);
      }
    }

    // Archivo único tradicional
    const lang = detectChallengeLanguage(data);
    let defaultFileName = "script.js";
    if (lang === "html" || data.challenge_type === "web") defaultFileName = "index.html";
    else if (lang === "css") defaultFileName = "styles.css";
    else if (lang === "python") defaultFileName = "main.py";
    else if (lang === "cpp") defaultFileName = "main.cpp";
    else if (lang === "sql") defaultFileName = "query.sql";

    return {
      files: { [defaultFileName]: data.initial_code || "" },
      activeFile: defaultFileName,
    };
  };

  useEffect(() => {
    const fetchChallenge = async () => {
      const { data } = await supabase.from("challenges").select("*, modules(id, course_id, title)").eq("id", id).single();
      if (data) {
        setChallenge(data);
        const { files: initFiles, activeFile: initActive } = parseInitialFiles(data);
        setFiles(initFiles);
        setActiveFile(initActive);
        const lang = getFileLanguage(initActive);
        setSelectedLanguage(lang);

        if (!data.theory) {
          setActiveTab("code");
        }
        if (data.challenge_type === "web" || lang === "html" || lang === "css") {
          setBottomTab("preview");
        }
      }
    };
    if (id) fetchChallenge();
  }, [id]);

  // Al cambiar de archivo activo, actualizar el lenguaje del editor
  const handleSelectFile = (fileName: string) => {
    setActiveFile(fileName);
    setSelectedLanguage(getFileLanguage(fileName));
  };

  // Crear un nuevo archivo en el proyecto
  const handleCreateFile = (fileName: string) => {
    let boilerplate = "";
    if (fileName.endsWith(".html")) {
      boilerplate = `<!DOCTYPE html>\n<html lang="es">\n<head>\n  <meta charset="UTF-8">\n  <title>Mi Proyecto</title>\n</head>\n<body>\n  \n</body>\n</html>`;
    } else if (fileName.endsWith(".css")) {
      boilerplate = `/* Estilos para ${fileName} */\n`;
    } else if (fileName.endsWith(".js")) {
      boilerplate = `// Lógica para ${fileName}\n`;
    }

    setFiles((prev) => ({
      ...prev,
      [fileName]: boilerplate,
    }));
    handleSelectFile(fileName);
  };

  // Eliminar un archivo
  const handleDeleteFile = (fileName: string) => {
    const updated = { ...files };
    delete updated[fileName];
    setFiles(updated);
    if (activeFile === fileName) {
      const remaining = Object.keys(updated);
      const nextActive = remaining.includes("index.html") ? "index.html" : remaining[0] || "index.html";
      handleSelectFile(nextActive);
    }
  };

  // Código del archivo activo
  const activeCode = files[activeFile] ?? "";

  const handleCodeChange = (newVal: string | undefined) => {
    const val = newVal || "";
    setFiles((prev) => ({
      ...prev,
      [activeFile]: val,
    }));
  };

  /**
   * Bundler virtual para compilar múltiples archivos HTML, CSS y JS en el iframe
   */
  const buildSandboxBundle = (virtualFiles: Record<string, string>): string => {
    let html = virtualFiles["index.html"] || "";

    // Si no hay index.html pero hay archivos, envolverlos
    if (!html) {
      const cssBlocks = Object.entries(virtualFiles)
        .filter(([name]) => name.endsWith(".css"))
        .map(([name, content]) => `<style data-virtual="${name}">\n${content}\n</style>`)
        .join("\n");

      const jsBlocks = Object.entries(virtualFiles)
        .filter(([name]) => name.endsWith(".js"))
        .map(([name, content]) => `<script data-virtual="${name}">\n${content}\n</script>`)
        .join("\n");

      return `
        <!DOCTYPE html>
        <html lang="es">
        <head>
          <meta charset="UTF-8">
          ${cssBlocks}
        </head>
        <body>
          <div id="sandbox-root"></div>
          ${jsBlocks}
        </body>
        </html>
      `;
    }

    // 1. Reemplazar <link rel="stylesheet" href="..."> por el CSS virtual inlined
    html = html.replace(/<link\s+[^>]*rel=["']stylesheet["'][^>]*>/gi, (match) => {
      const hrefMatch = match.match(/href=["']([^"']+)["']/i);
      if (hrefMatch && hrefMatch[1]) {
        const rawHref = hrefMatch[1].trim().replace(/^\.\//, "");
        // Buscar coincidencia exacta o por nombre base
        const matchedEntry = Object.entries(virtualFiles).find(([name]) => {
          return name === rawHref || name.endsWith(`/${rawHref}`) || rawHref.endsWith(name);
        });

        if (matchedEntry) {
          return `<style data-source="${matchedEntry[0]}">\n${matchedEntry[1]}\n</style>`;
        }
      }
      return match;
    });

    // 2. Reemplazar <script src="..."> por el JS virtual inlined
    html = html.replace(/<script\s+[^>]*src=["']([^"']+)["'][^>]*><\/script>/gi, (match, src) => {
      const rawSrc = src.trim().replace(/^\.\//, "");
      const matchedEntry = Object.entries(virtualFiles).find(([name]) => {
        return name === rawSrc || name.endsWith(`/${rawSrc}`) || rawSrc.endsWith(name);
      });

      if (matchedEntry) {
        return `<script data-source="${matchedEntry[0]}">\n${matchedEntry[1]}\n</script>`;
      }
      return match;
    });

    return html;
  };

  const initSandboxIframe = () => {
    if (iframeRef.current && iframeRef.current.contentDocument) {
      const doc = iframeRef.current.contentDocument;
      return { doc, win: iframeRef.current.contentWindow };
    }
    return { doc: document, win: window };
  };

  const handleChallengeComplete = async () => {
    if (!isCompleted) {
      setShowSuccessModal(true);
      if (user) {
        try {
          await supabase.from("user_progress").insert({
            user_id: user.id,
            challenge_id: challenge!.id,
            status: "completed",
            code_snapshot: JSON.stringify(files),
            completed_at: new Date().toISOString(),
          });

          const newXp = (profile?.xp || 0) + challenge!.xp_reward;
          const { level: newLevel } = getLevelInfo(newXp);

          await supabase.from("profiles").update({ xp: newXp, level: newLevel }).eq("id", user.id);
          setIsCompleted(true);
        } catch (e) {
          console.error("Error guardando progreso", e);
        }
      }
    }
  };

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
      // 1. Construir e inyectar el bundle virtual en el iframe sandbox
      const bundledHtml = buildSandboxBundle(files);
      const { doc: sandboxDoc, win: sandboxWin } = initSandboxIframe();

      if (iframeRef.current && iframeRef.current.contentDocument) {
        sandboxDoc.open();
        sandboxDoc.write(bundledHtml);
        sandboxDoc.close();
      }

      // 2. Ejecutar batería de tests sobre el proyecto
      if (challenge.test_code) {
        // Pasar el sistema de archivos virtuales, document y window al entorno de tests
        const testRunner = new Function("files", "document", "window", "code", challenge.test_code);
        testRunner(files, sandboxDoc, sandboxWin, activeCode);
      } else {
        // En caso de código JS único sin test específico
        const isJs = selectedLanguage === "javascript" || activeFile.endsWith(".js");
        if (isJs) {
          const runFn = new Function("document", "window", activeCode);
          runFn(sandboxDoc, sandboxWin);
        }
      }
      
      setLogs([...capturedLogs, "✅ ¡Todos los tests pasaron exitosamente!"]);
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

    if (passed) {
      await handleChallengeComplete();
    }
  };

  if (!challenge)
    return (
      <div className="min-h-screen bg-background flex flex-col items-center justify-center text-white gap-4">
        <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
        <p className="font-mono text-zinc-400">Cargando Lección...</p>
      </div>
    );

  const isWebChallenge = challenge.challenge_type === "web";

  let parsedQuestions = [];
  if (challenge.challenge_type === "quiz") {
    try {
      parsedQuestions = JSON.parse(challenge.test_code || "[]");
    } catch (e) {
      console.error("Failed to parse quiz questions");
    }
  }

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
              <div className={`w-8 h-8 rounded-lg ${isWebChallenge ? "bg-blue-500/20" : challenge.challenge_type === "quiz" ? "bg-emerald-500/20" : "bg-yellow-500/20"} flex items-center justify-center shrink-0`}>
                {isWebChallenge ? <Globe size={18} className="text-blue-400" /> : challenge.challenge_type === "quiz" ? <BookOpen size={18} className="text-emerald-400" /> : <TerminalSquare size={18} className="text-yellow-400" />}
              </div>
              <h1 className="font-heading font-bold text-base lg:text-lg text-white line-clamp-1">{challenge.title}</h1>
            </div>
          </div>

          {/* Mobile Navigation Tabs */}
          <div className="lg:hidden flex items-center bg-black/40 p-1 rounded-lg border border-white/10">
            <button
              onClick={() => setActiveTab("theory")}
              className={`flex items-center gap-1 px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                activeTab === "theory" ? "bg-primary text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <BookOpen size={14} /> <span className="hidden sm:inline">Teoría</span>
            </button>
            {challenge.challenge_type !== "quiz" && (
              <button
                onClick={() => setActiveTab("code")}
                className={`flex items-center gap-1 px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                  activeTab === "code" ? "bg-primary text-white shadow-lg" : "text-zinc-400 hover:text-white"
                }`}
              >
                <Code2 size={14} /> <span className="hidden sm:inline">Código</span>
              </button>
            )}
          </div>

          <div className="flex items-center gap-2 sm:gap-3">
            {/* Report Problem Button */}
            <button
              onClick={() => setShowReportModal(true)}
              className="p-1.5 sm:px-2.5 sm:py-1.5 rounded-lg sm:rounded-xl text-zinc-400 hover:text-amber-400 hover:bg-amber-500/10 border border-transparent hover:border-amber-500/20 transition-all flex items-center gap-1.5 text-xs font-semibold"
              title="Reportar un error o problema en este reto"
            >
              <Flag size={15} />
              <span className="hidden sm:inline">Reportar</span>
            </button>

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
          <main className="flex-1 p-0 lg:p-4 bg-[#09090b] flex flex-col lg:flex-row gap-0 lg:gap-4 relative overflow-hidden">
            
            {/* Theory Reading Panel */}
            <div className={`w-full lg:w-[45%] xl:w-[40%] flex-col h-full bg-[#0d0d11] lg:rounded-2xl lg:border lg:border-white/10 overflow-hidden ${activeTab === "theory" ? "flex" : "hidden lg:flex"}`}>
              <div className="p-6 h-full flex flex-col overflow-y-auto custom-scrollbar">
                <div className="flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-wider mb-6">
                  <BookOpen size={18} />
                  <span>Lección Teórica</span>
                </div>
                <TheoryRenderer content={challenge.theory || "No hay teoría provista para esta lección."} />
              </div>
            </div>

            {/* Quiz Runner Panel */}
            <div className={`w-full lg:flex-1 h-full flex-col relative bg-[#0d0d11] lg:rounded-2xl overflow-hidden lg:border lg:border-white/10 ${activeTab !== "theory" ? "flex" : "hidden lg:flex"}`}>
              <QuizRunner
                questions={parsedQuestions}
                xpReward={challenge.xp_reward || 50}
                onComplete={handleChallengeComplete}
              />
            </div>

          </main>
        ) : (
          /* Main Content Area: Side-by-Side on Desktop, Tabs on Mobile */
          <main className="flex-1 overflow-hidden p-0 lg:p-4 bg-[#09090b] flex flex-col lg:flex-row gap-0 lg:gap-4 relative">
            
            {/* LEFT PANEL: Theory */}
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

            {/* RIGHT PANEL: Code & Sandbox / Console */}
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

              {/* Top Right: Monaco Editor with Project File Tree & Toolbar */}
              <div className="flex-1 relative lg:rounded-2xl overflow-hidden border-y lg:border border-white/10 shadow-lg min-h-[280px] flex flex-col bg-[#09090b]">
                
                {/* Editor Tab & Project File Tree Header */}
                <div className="h-11 bg-black/70 border-b border-white/10 px-2 flex items-center justify-between text-xs shrink-0 select-none gap-2">
                  {/* Project File Tree Tabs */}
                  <div className="flex-1 min-w-0 h-full flex items-center">
                    <ProjectFileTree
                      files={files}
                      activeFile={activeFile}
                      onSelectFile={handleSelectFile}
                      onCreateFile={handleCreateFile}
                      onDeleteFile={handleDeleteFile}
                    />
                  </div>

                  {/* Actions & Language Info */}
                  <div className="flex items-center gap-1.5 shrink-0 pr-1">
                    {/* Reset Code Button */}
                    <button
                      type="button"
                      onClick={() => {
                        if (confirm("¿Deseas reiniciar todos los archivos del proyecto al estado inicial?")) {
                          const { files: initFiles, activeFile: initActive } = parseInitialFiles(challenge);
                          setFiles(initFiles);
                          setActiveFile(initActive);
                          setSelectedLanguage(getFileLanguage(initActive));
                        }
                      }}
                      className="flex items-center gap-1 px-2 py-1 rounded text-[11px] text-zinc-400 hover:text-white hover:bg-white/5 transition-colors"
                      title="Reiniciar archivos iniciales"
                    >
                      <RotateCcw size={12} />
                      <span className="hidden sm:inline">Reiniciar</span>
                    </button>

                    {/* Active Language Badge */}
                    <div className="flex items-center gap-1 bg-black/50 px-2 py-1 rounded-lg border border-white/10 text-[11px] font-mono font-bold text-indigo-300">
                      <span className="text-[9px] uppercase tracking-wider text-zinc-500 hidden sm:inline">Sintaxis:</span>
                      <span className="uppercase">{selectedLanguage}</span>
                    </div>
                  </div>
                </div>

                {/* Monaco Editor Container */}
                <div className="flex-1 w-full h-full">
                  <CodeEditor language={selectedLanguage} value={activeCode} onChange={handleCodeChange} />
                </div>
              </div>

              {/* Bottom Right: Interactive Terminal Console & Web Sandbox */}
              <div className="h-56 lg:h-64 lg:rounded-2xl bg-black border-t lg:border border-white/10 flex flex-col overflow-hidden font-mono text-sm shadow-xl shrink-0">
                
                {/* Bottom Bar Header with Tabs */}
                <div className="h-10 bg-zinc-900/90 px-3 flex items-center justify-between border-b border-zinc-800 text-xs text-zinc-400">
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => setBottomTab("console")}
                      className={`flex items-center gap-1.5 px-3 py-1 rounded-lg transition-colors ${
                        bottomTab === "console"
                          ? "bg-white/10 text-white font-bold"
                          : "text-zinc-400 hover:text-zinc-200"
                      }`}
                    >
                      <TerminalSquare size={14} />
                      <span>Consola & Tests</span>
                    </button>

                    {isWebChallenge && (
                      <button
                        onClick={() => setBottomTab("preview")}
                        className={`flex items-center gap-1.5 px-3 py-1 rounded-lg transition-colors ${
                          bottomTab === "preview"
                            ? "bg-blue-500/20 text-blue-400 font-bold border border-blue-500/30"
                            : "text-zinc-400 hover:text-blue-300"
                        }`}
                      >
                        <Globe size={14} />
                        <span>Vista Previa Web</span>
                      </button>
                    )}
                  </div>

                  {/* Status Indicator */}
                  <div>
                    {status === "success" && (
                      <span className="flex items-center gap-1 text-emerald-400 font-bold">
                        <CheckCircle2 size={13} /> Tests superados
                      </span>
                    )}
                    {status === "error" && (
                      <span className="flex items-center gap-1 text-red-400 font-bold">
                        <AlertCircle size={13} /> Error en validación
                      </span>
                    )}
                  </div>
                </div>

                {/* Tab 1: Terminal Console Logs */}
                <div className={`flex-1 p-4 overflow-y-auto space-y-1 text-zinc-300 custom-scrollbar ${
                  bottomTab === "console" ? "block" : "hidden"
                }`}>
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

                {/* Tab 2: Sandboxed Web Preview Iframe */}
                <div className={`flex-1 bg-[#0d0d11] relative overflow-hidden flex flex-col ${
                  bottomTab === "preview" ? "flex" : "hidden"
                }`}>
                  <div className="h-6 bg-black/60 border-b border-white/5 px-3 flex items-center gap-2 text-[10px] text-zinc-500 font-mono">
                    <span className="w-2 h-2 rounded-full bg-red-500/60 inline-block"></span>
                    <span className="w-2 h-2 rounded-full bg-yellow-500/60 inline-block"></span>
                    <span className="w-2 h-2 rounded-full bg-emerald-500/60 inline-block"></span>
                    <span className="ml-2 text-zinc-400 font-sans">http://sandbox.local/preview</span>
                  </div>
                  <iframe
                    ref={iframeRef}
                    id="ide-web-sandbox"
                    title="Live Web Sandbox"
                    className="w-full flex-1 border-none bg-transparent"
                  />
                </div>

              </div>
            </div>
          </main>
        )}
      </div>

      {/* Report Issue Modal */}
      {challenge && (
        <ReportIssueModal
          isOpen={showReportModal}
          onClose={() => setShowReportModal(false)}
          challengeId={challenge.id}
          challengeTitle={challenge.title}
          challengeType={challenge.challenge_type}
          courseId={challenge.modules?.course_id}
        />
      )}

      {/* SUCCESS CELEBRATION MODAL */}
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
