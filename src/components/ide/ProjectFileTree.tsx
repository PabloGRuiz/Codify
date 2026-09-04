"use client";

import React, { useState } from "react";
import { 
  FileCode, 
  FileText, 
  Folder, 
  FolderOpen, 
  Plus, 
  X, 
  Code2, 
  Paintbrush, 
  Braces, 
  Check, 
  Trash2 
} from "lucide-react";

interface ProjectFileTreeProps {
  files: Record<string, string>;
  activeFile: string;
  onSelectFile: (fileName: string) => void;
  onCreateFile: (fileName: string) => void;
  onDeleteFile?: (fileName: string) => void;
}

export function getFileIcon(fileName: string) {
  if (fileName.endsWith(".html")) return <Code2 size={14} className="text-orange-400 shrink-0" />;
  if (fileName.endsWith(".css")) return <Paintbrush size={14} className="text-blue-400 shrink-0" />;
  if (fileName.endsWith(".js") || fileName.endsWith(".ts")) return <Braces size={14} className="text-yellow-400 shrink-0" />;
  if (fileName.endsWith(".json")) return <FileCode size={14} className="text-emerald-400 shrink-0" />;
  return <FileText size={14} className="text-zinc-400 shrink-0" />;
}

export function getFileLanguage(fileName: string): string {
  if (fileName.endsWith(".html")) return "html";
  if (fileName.endsWith(".css")) return "css";
  if (fileName.endsWith(".js")) return "javascript";
  if (fileName.endsWith(".ts")) return "typescript";
  if (fileName.endsWith(".json")) return "json";
  if (fileName.endsWith(".py")) return "python";
  if (fileName.endsWith(".cpp")) return "cpp";
  if (fileName.endsWith(".sql")) return "sql";
  return "plaintext";
}

export function ProjectFileTree({
  files,
  activeFile,
  onSelectFile,
  onCreateFile,
  onDeleteFile,
}: ProjectFileTreeProps) {
  const [isCreating, setIsCreating] = useState(false);
  const [newFileName, setNewFileName] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  const fileNames = Object.keys(files);

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = newFileName.trim();
    if (!trimmed) {
      setIsCreating(false);
      return;
    }

    // Normalizar ruta (remover barras iniciales)
    const normalized = trimmed.replace(/^\/+/, "");

    if (files[normalized] !== undefined) {
      setErrorMessage("El archivo ya existe");
      return;
    }

    onCreateFile(normalized);
    setNewFileName("");
    setIsCreating(false);
    setErrorMessage("");
  };

  return (
    <div className="flex items-center gap-1.5 overflow-x-auto custom-scrollbar h-full px-2">
      {/* File Tabs */}
      {fileNames.map((fileName) => {
        const isActive = fileName === activeFile;
        return (
          <div
            key={fileName}
            onClick={() => onSelectFile(fileName)}
            className={`group relative flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-mono transition-all cursor-pointer border select-none shrink-0 ${
              isActive
                ? "bg-white/10 text-white font-bold border-white/20 shadow-sm"
                : "text-zinc-400 hover:text-zinc-200 hover:bg-white/5 border-transparent"
            }`}
          >
            {getFileIcon(fileName)}
            <span className="truncate max-w-[140px]">{fileName}</span>

            {/* Optional delete button if more than 1 file and not default */}
            {fileNames.length > 1 && onDeleteFile && fileName !== "index.html" && (
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  if (confirm(`¿Eliminar ${fileName}?`)) {
                    onDeleteFile(fileName);
                  }
                }}
                className="opacity-0 group-hover:opacity-100 hover:text-red-400 p-0.5 rounded transition-opacity ml-1"
                title="Eliminar archivo"
              >
                <X size={12} />
              </button>
            )}
          </div>
        );
      })}

      {/* New File Button / Input */}
      {isCreating ? (
        <form onSubmit={handleCreateSubmit} className="flex items-center gap-1 shrink-0 bg-black/60 border border-primary/40 rounded-lg px-2 py-0.5">
          <input
            type="text"
            value={newFileName}
            onChange={(e) => {
              setNewFileName(e.target.value);
              setErrorMessage("");
            }}
            placeholder="ej: css/styles.css"
            autoFocus
            className="bg-transparent text-xs text-white font-mono outline-none w-28 sm:w-36 py-0.5"
          />
          <button type="submit" className="text-emerald-400 hover:text-emerald-300 p-0.5" title="Crear">
            <Check size={13} />
          </button>
          <button
            type="button"
            onClick={() => {
              setIsCreating(false);
              setNewFileName("");
              setErrorMessage("");
            }}
            className="text-zinc-400 hover:text-zinc-300 p-0.5"
            title="Cancelar"
          >
            <X size={13} />
          </button>
        </form>
      ) : (
        <button
          type="button"
          onClick={() => setIsCreating(true)}
          className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg text-xs font-mono text-zinc-400 hover:text-white hover:bg-white/5 border border-dashed border-white/10 hover:border-white/20 transition-all shrink-0"
          title="Crear nuevo archivo (ej: css/styles.css, js/app.js)"
        >
          <Plus size={13} />
          <span className="hidden sm:inline">Nuevo Archivo</span>
        </button>
      )}

      {errorMessage && (
        <span className="text-[11px] text-red-400 font-sans shrink-0">{errorMessage}</span>
      )}
    </div>
  );
}
