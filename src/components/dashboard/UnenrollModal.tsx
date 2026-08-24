"use client";

import { motion, AnimatePresence } from "framer-motion";
import { AlertTriangle, X, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/Button";

interface UnenrollModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => Promise<void>;
  courseTitle: string;
  isProcessing: boolean;
}

export function UnenrollModal({
  isOpen,
  onClose,
  onConfirm,
  courseTitle,
  isProcessing,
}: UnenrollModalProps) {
  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4">
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 15 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 15 }}
          className="bg-zinc-900 border border-red-500/30 rounded-3xl p-6 sm:p-8 max-w-md w-full shadow-[0_0_50px_rgba(239,68,68,0.2)] relative overflow-hidden text-center"
        >
          {/* Ambient red glow */}
          <div className="absolute top-[-50px] left-1/2 -translate-x-1/2 w-64 h-64 bg-red-500/15 blur-[80px] rounded-full pointer-events-none" />

          {/* Close button */}
          <button
            onClick={onClose}
            disabled={isProcessing}
            className="absolute top-4 right-4 p-2 text-zinc-400 hover:text-white rounded-full hover:bg-white/10 transition-colors z-10 disabled:opacity-50"
          >
            <X size={20} />
          </button>

          {/* Icon Header */}
          <div className="relative w-16 h-16 mx-auto mb-4 flex items-center justify-center">
            <div className="absolute inset-0 bg-red-600/30 rounded-2xl blur-lg animate-pulse" />
            <div className="w-14 h-14 rounded-2xl bg-red-500/20 border-2 border-red-500/40 flex items-center justify-center text-red-400 relative z-10 shadow-lg">
              <AlertTriangle size={28} />
            </div>
          </div>

          <h2 className="text-2xl font-heading font-bold text-white mb-2">
            ¿Abandonar curso activo?
          </h2>

          <p className="text-zinc-300 font-medium text-sm mb-2 px-2">
            Estás a punto de quitar <span className="text-white font-bold">"{courseTitle}"</span> de tus cursos activos.
          </p>

          <p className="text-zinc-500 text-xs mb-6 px-4">
            💡 Nota: Tu progreso completado y puntos XP acumulados se mantendrán a salvo si decides volver a matricularte más tarde.
          </p>

          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <Button
              variant="secondary"
              onClick={onClose}
              disabled={isProcessing}
              className="flex-1 order-2 sm:order-1"
            >
              Cancelar
            </Button>
            <Button
              variant="danger"
              onClick={onConfirm}
              isLoading={isProcessing}
              leftIcon={<Trash2 size={16} />}
              className="flex-1 order-1 sm:order-2"
            >
              Abandonar
            </Button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
