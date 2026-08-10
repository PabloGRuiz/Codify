"use client";

import { useState, useEffect } from "react";
import dynamic from "next/dynamic";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Play, Code2, Monitor, Braces, Paintbrush } from "lucide-react";

// Deshabilitar SSR para Monaco Editor para evitar errores de hidratación
const CodeEditor = dynamic(() => import("@/components/ide/CodeEditor").then(mod => mod.CodeEditor), { ssr: false });

export default function WebPrototypingPage() {
  const [html, setHtml] = useState("<h1>¡Hola, Codify!</h1>\n<p>Este es tu primer prototipo web.</p>");
  const [css, setCss] = useState("body {\n  font-family: sans-serif;\n  display: flex;\n  flex-direction: column;\n  align-items: center;\n  justify-content: center;\n  height: 100vh;\n  margin: 0;\n  background: #f4f4f5;\n}\n\nh1 {\n  color: #8b5cf6;\n}\np {\n  color: #52525b;\n}");
  const [js, setJs] = useState("console.log('¡Prototipo cargado!');");
  
  const [activeTab, setActiveTab] = useState<"html" | "css" | "js">("html");
  const [srcDoc, setSrcDoc] = useState("");

  const runCode = () => {
    const document = `
      <!DOCTYPE html>
      <html lang="es">
        <head>
          <style>${css}</style>
        </head>
        <body>
          ${html}
          <script>${js}<\/script>
        </body>
      </html>
    `;
    setSrcDoc(document);
  };

  useEffect(() => {
    // Initial run
    runCode();
  }, []);

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className="ml-64 flex-1 flex flex-col h-screen overflow-hidden">
        
        {/* Header / Topbar */}
        <header className="h-16 w-full glass border-b border-border flex items-center justify-between px-6 shrink-0">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-blue-500/20 flex items-center justify-center">
              <Monitor size={18} className="text-blue-400" />
            </div>
            <h1 className="font-heading font-bold text-lg text-white">Laboratorio Web</h1>
          </div>
          
          <Button size="sm" onClick={runCode} leftIcon={<Play size={16} />} className="shadow-[0_0_15px_rgba(16,185,129,0.3)] bg-success hover:bg-[#059669] text-white border-success">
            Ejecutar Código
          </Button>
        </header>

        {/* Main IDE Workspace */}
        <main className="flex-1 flex overflow-hidden">
          
          {/* Left Panel: Editor */}
          <div className="w-1/2 h-full flex flex-col border-r border-border bg-[#09090b]">
            {/* Editor Tabs */}
            <div className="flex h-12 border-b border-border bg-[#09090b] shrink-0">
              <button
                onClick={() => setActiveTab("html")}
                className={`flex-1 flex items-center justify-center gap-2 font-medium transition-colors border-b-2 ${activeTab === "html" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
              >
                <Code2 size={16} /> index.html
              </button>
              <button
                onClick={() => setActiveTab("css")}
                className={`flex-1 flex items-center justify-center gap-2 font-medium transition-colors border-b-2 border-l border-l-border ${activeTab === "css" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
              >
                <Paintbrush size={16} /> styles.css
              </button>
              <button
                onClick={() => setActiveTab("js")}
                className={`flex-1 flex items-center justify-center gap-2 font-medium transition-colors border-b-2 border-l border-l-border ${activeTab === "js" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
              >
                <Braces size={16} /> script.js
              </button>
            </div>

            {/* Editor Area */}
            <div className="flex-1 p-4 bg-[#09090b]">
              {activeTab === "html" && (
                <CodeEditor language="html" value={html} onChange={(v) => setHtml(v || "")} />
              )}
              {activeTab === "css" && (
                <CodeEditor language="css" value={css} onChange={(v) => setCss(v || "")} />
              )}
              {activeTab === "js" && (
                <CodeEditor language="javascript" value={js} onChange={(v) => setJs(v || "")} />
              )}
            </div>
          </div>

          {/* Right Panel: Live Preview */}
          <div className="w-1/2 h-full bg-white relative">
            <iframe
              srcDoc={srcDoc}
              title="Live Preview"
              sandbox="allow-scripts"
              className="w-full h-full border-none bg-white"
            />
            {/* Small floating badge */}
            <div className="absolute top-4 right-4 bg-black/60 backdrop-blur-md px-3 py-1.5 rounded-full text-xs text-white font-mono border border-white/10 pointer-events-none shadow-lg">
              Vista Previa en Vivo
            </div>
          </div>

        </main>
      </div>
    </div>
  );
}
