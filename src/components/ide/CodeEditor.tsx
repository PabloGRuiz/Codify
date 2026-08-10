"use client";

import Editor, { useMonaco } from "@monaco-editor/react";
import { useEffect } from "react";

interface CodeEditorProps {
  language: string;
  value: string;
  onChange: (value: string | undefined) => void;
  readOnly?: boolean;
}

export function CodeEditor({ language, value, onChange, readOnly = false }: CodeEditorProps) {
  const monaco = useMonaco();

  useEffect(() => {
    if (monaco) {
      monaco.editor.defineTheme("premiumDark", {
        base: "vs-dark",
        inherit: true,
        rules: [],
        colors: {
          "editor.background": "#09090b", // Background matching globals.css
          "editor.lineHighlightBackground": "#ffffff0a",
          "editorLineNumber.foreground": "#52525b",
          "editorIndentGuide.background": "#27272a",
        },
      });
      monaco.editor.setTheme("premiumDark");
    }
  }, [monaco]);

  return (
    <div className="w-full h-full rounded-xl overflow-hidden border border-border shadow-lg">
      <Editor
        height="100%"
        language={language}
        value={value}
        theme="premiumDark"
        onChange={onChange}
        options={{
          minimap: { enabled: false },
          fontSize: 15,
          fontFamily: "'Geist Mono', 'Fira Code', monospace",
          padding: { top: 20, bottom: 20 },
          readOnly,
          smoothScrolling: true,
          cursorBlinking: "smooth",
          formatOnPaste: true,
        }}
        loading={
          <div className="flex items-center justify-center h-full text-primary font-sans animate-pulse">
            Iniciando Entorno...
          </div>
        }
      />
    </div>
  );
}
