"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, Send, AlertCircle } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";

interface NuevoHiloModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export function NuevoHiloModal({ isOpen, onClose, onSuccess }: NuevoHiloModalProps) {
  const { user } = useUser();
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [tagsInput, setTagsInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) {
      setError("Debes iniciar sesión para publicar en el foro.");
      return;
    }

    if (title.trim().length < 10) {
      setError("El título debe ser más descriptivo (mínimo 10 caracteres).");
      return;
    }
    
    if (content.trim().length < 20) {
      setError("Por favor, detalla más tu consulta (mínimo 20 caracteres).");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const tags = tagsInput
        .split(",")
        .map(t => t.trim().toLowerCase().replace(/[^a-z0-9]/g, ''))
        .filter(t => t.length > 0)
        .slice(0, 3); // Max 3 tags

      const { error: insertError } = await supabase.from("forum_threads").insert({
        title: title.trim(),
        content: content.trim(),
        author_id: user.id,
        tags: tags
      });

      if (insertError) throw insertError;

      setTitle("");
      setContent("");
      setTagsInput("");
      onSuccess();
      onClose();
    } catch (err: any) {
      console.error("Error creating thread:", err);
      setError("Ocurrió un error al crear la consulta. Inténtalo de nuevo.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 10 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 10 }}
          className="bg-zinc-900 border border-white/10 rounded-2xl p-6 sm:p-8 max-w-2xl w-full shadow-2xl relative"
        >
          <button
            onClick={onClose}
            className="absolute top-4 right-4 p-2 text-zinc-400 hover:text-white rounded-full hover:bg-white/10 transition-colors"
          >
            <X size={20} />
          </button>

          <h2 className="text-2xl font-heading font-bold text-white mb-6">Nueva Consulta</h2>

          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="bg-red-500/10 border border-red-500/20 text-red-400 p-3 rounded-xl text-sm flex items-start gap-2">
                <AlertCircle size={16} className="mt-0.5 shrink-0" />
                <p>{error}</p>
              </div>
            )}

            <div>
              <label className="block text-sm font-medium text-zinc-400 mb-1">Título de tu pregunta</label>
              <input
                type="text"
                placeholder="Ej. ¿Cómo resuelvo el error 'CORS policy' en FastAPI?"
                className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                maxLength={150}
                required
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-zinc-400 mb-1">Descripción detallada</label>
              <textarea
                placeholder="Describe tu problema, qué intentaste hacer y qué código estás utilizando..."
                className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 h-40 resize-none font-mono text-sm"
                value={content}
                onChange={(e) => setContent(e.target.value)}
                required
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-zinc-400 mb-1">Etiquetas (Opcional, separadas por coma)</label>
              <input
                type="text"
                placeholder="Ej. python, fastapi, cors"
                className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 font-mono text-sm"
                value={tagsInput}
                onChange={(e) => setTagsInput(e.target.value)}
              />
            </div>

            <div className="flex justify-end gap-3 pt-4 border-t border-white/5">
              <Button type="button" variant="outline" onClick={onClose} disabled={loading}>
                Cancelar
              </Button>
              <Button type="submit" disabled={loading} className="bg-blue-600 hover:bg-blue-500 text-white">
                {loading ? "Publicando..." : "Publicar Consulta"}
                {!loading && <Send size={16} className="ml-2" />}
              </Button>
            </div>
          </form>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
