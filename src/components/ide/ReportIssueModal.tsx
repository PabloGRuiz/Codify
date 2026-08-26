"use client";

import { useState } from "react";
import { 
  AlertTriangle, 
  X, 
  Send, 
  CheckCircle2, 
  BookOpen, 
  HelpCircle, 
  Terminal, 
  Type, 
  MessageSquare 
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/Button";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { ReportType } from "@/types";

interface ReportIssueModalProps {
  isOpen: boolean;
  onClose: () => void;
  challengeId: string;
  challengeTitle: string;
  challengeType: string;
  courseId?: string;
}

export function ReportIssueModal({
  isOpen,
  onClose,
  challengeId,
  challengeTitle,
  challengeType,
  courseId,
}: ReportIssueModalProps) {
  const { user } = useUser();
  const [reportType, setReportType] = useState<ReportType>(
    challengeType === "quiz" ? "quiz_error" : "test_code_error"
  );
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const resetForm = () => {
    setTitle("");
    setDescription("");
    setIsSubmitted(false);
    setErrorMessage("");
  };

  const handleClose = () => {
    resetForm();
    onClose();
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) {
      setErrorMessage("Debes iniciar sesión para enviar un reporte.");
      return;
    }
    if (!title.trim() || !description.trim()) {
      setErrorMessage("Por favor completa el título y la descripción.");
      return;
    }

    setIsSubmitting(true);
    setErrorMessage("");

    try {
      const { error } = await supabase.from("content_reports").insert({
        user_id: user.id,
        challenge_id: challengeId,
        course_id: courseId || null,
        report_type: reportType,
        title: title.trim(),
        description: description.trim(),
        status: "pending",
      });

      if (error) throw error;
      setIsSubmitted(true);
      setTimeout(() => {
        handleClose();
      }, 2500);
    } catch (err: any) {
      console.error("Error enviando reporte:", err);
      setErrorMessage(err.message || "Error al enviar el reporte. Inténtalo nuevamente.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const categories = [
    {
      id: "theory_error" as ReportType,
      label: "Error en la Teoría",
      desc: "Explicación confusa, concepto erróneo o código de ejemplo con fallo.",
      icon: <BookOpen size={16} className="text-indigo-400" />,
    },
    {
      id: "quiz_error" as ReportType,
      label: "Error en Cuestionario / Quiz",
      desc: "Pregunta mal formulada, respuesta incorrecta marcada como buena.",
      icon: <HelpCircle size={16} className="text-emerald-400" />,
    },
    {
      id: "test_code_error" as ReportType,
      label: "Error en Tests de Código",
      desc: "El evaluador falla con código correcto o assert defectuoso.",
      icon: <Terminal size={16} className="text-yellow-400" />,
    },
    {
      id: "typo" as ReportType,
      label: "Tipografía / Redacción",
      desc: "Falta ortográfica, enlace roto o problema de visualización.",
      icon: <Type size={16} className="text-sky-400" />,
    },
    {
      id: "other" as ReportType,
      label: "Otro Problema",
      desc: "Cualquier otra inconsistencia o sugerencia de mejora.",
      icon: <MessageSquare size={16} className="text-purple-400" />,
    },
  ];

  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md">
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 15 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 10 }}
          className="relative w-full max-w-xl bg-[#0e0e14] border border-white/15 rounded-3xl p-6 sm:p-8 shadow-2xl shadow-black/90 overflow-hidden"
        >
          {/* Header */}
          <div className="flex items-center justify-between pb-4 border-b border-white/10">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-400 flex items-center justify-center shadow-lg shadow-amber-500/10">
                <AlertTriangle size={20} />
              </div>
              <div>
                <h3 className="text-lg font-heading font-bold text-white">Reportar Problema en el Reto</h3>
                <p className="text-xs text-zinc-400 line-clamp-1">
                  {challengeTitle}
                </p>
              </div>
            </div>

            <button
              onClick={handleClose}
              className="p-2 text-zinc-400 hover:text-white rounded-lg hover:bg-white/5 transition-colors"
            >
              <X size={18} />
            </button>
          </div>

          {/* Success Screen */}
          {isSubmitted ? (
            <div className="py-12 text-center space-y-4">
              <div className="w-16 h-16 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 flex items-center justify-center mx-auto shadow-lg shadow-emerald-500/20 animate-bounce">
                <CheckCircle2 size={32} />
              </div>
              <h4 className="text-xl font-bold text-white font-heading">¡Reporte Enviado con Éxito!</h4>
              <p className="text-sm text-zinc-400 max-w-sm mx-auto leading-relaxed">
                Gracias por ayudarnos a mejorar la calidad del contenido de Codify. Nuestro equipo técnico lo revisará pronto.
              </p>
            </div>
          ) : (
            /* Form Screen */
            <form onSubmit={handleSubmit} className="space-y-5 pt-4">
              {errorMessage && (
                <div className="p-3 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-xs font-semibold">
                  {errorMessage}
                </div>
              )}

              {/* Categoría */}
              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400 mb-2">
                  Tipo de Inconsistencia:
                </label>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  {categories.map((cat) => (
                    <button
                      key={cat.id}
                      type="button"
                      onClick={() => setReportType(cat.id)}
                      className={`p-3 rounded-xl border text-left transition-all flex items-start gap-2.5 ${
                        reportType === cat.id
                          ? "bg-amber-500/10 border-amber-500/50 shadow-md shadow-amber-500/10"
                          : "bg-black/30 border-white/5 hover:border-white/20 hover:bg-black/50"
                      }`}
                    >
                      <div className="mt-0.5">{cat.icon}</div>
                      <div>
                        <div className={`text-xs font-bold ${reportType === cat.id ? "text-amber-300" : "text-zinc-200"}`}>
                          {cat.label}
                        </div>
                        <div className="text-[10px] text-zinc-500 line-clamp-1 mt-0.5">
                          {cat.desc}
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* Título Breve */}
              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400 mb-1.5">
                  Título Resumido:
                </label>
                <input
                  type="text"
                  required
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  placeholder="Ej: La pregunta 2 marca incorrecta la opción verdadera"
                  className="w-full p-3 rounded-xl bg-black/40 border border-white/10 text-white text-xs sm:text-sm outline-none focus:border-amber-500 transition-colors"
                />
              </div>

              {/* Descripción Detallada */}
              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400 mb-1.5">
                  Detalle del Error o Sugerencia:
                </label>
                <textarea
                  required
                  rows={3}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Explica qué ocurrió, qué esperabas y cómo crees que debería corregirse..."
                  className="w-full p-3 rounded-xl bg-black/40 border border-white/10 text-white text-xs sm:text-sm outline-none focus:border-amber-500 transition-colors"
                />
              </div>

              {/* Acciones */}
              <div className="flex items-center justify-end gap-3 pt-2">
                <Button
                  type="button"
                  variant="secondary"
                  size="sm"
                  onClick={handleClose}
                  disabled={isSubmitting}
                >
                  Cancelar
                </Button>
                <Button
                  type="submit"
                  size="sm"
                  isLoading={isSubmitting}
                  leftIcon={<Send size={14} />}
                  className="bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20"
                >
                  Enviar Reporte
                </Button>
              </div>
            </form>
          )}
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
