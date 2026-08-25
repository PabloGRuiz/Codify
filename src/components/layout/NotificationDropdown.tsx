"use client";

import { useState, useRef, useEffect } from "react";
import { useRouter } from "next/navigation";
import { 
  Bell, 
  Check, 
  CheckCheck, 
  GraduationCap, 
  MessageSquare, 
  Sparkles, 
  Trophy, 
  Trash2, 
  ExternalLink,
  X
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { formatDistanceToNow } from "date-fns";
import { es } from "date-fns/locale";
import { useNotifications } from "@/hooks/useNotifications";
import { Notification } from "@/types";

export function NotificationDropdown() {
  const router = useRouter();
  const [isOpen, setIsOpen] = useState(false);
  const [filter, setFilter] = useState<"all" | "unread">("all");
  const dropdownRef = useRef<HTMLDivElement>(null);

  const { 
    notifications, 
    loading, 
    unreadCount, 
    markAsRead, 
    markAllAsRead, 
    deleteNotification 
  } = useNotifications();

  // Cerrar al hacer clic fuera del menú
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const filteredNotifications = filter === "unread" 
    ? notifications.filter(n => !n.read) 
    : notifications;

  const handleNotificationClick = async (notification: Notification) => {
    if (!notification.read) {
      await markAsRead(notification.id);
    }
    if (notification.link) {
      setIsOpen(false);
      router.push(notification.link);
    }
  };

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case "course":
        return (
          <div className="w-9 h-9 rounded-xl bg-indigo-500/20 border border-indigo-500/30 text-indigo-400 flex items-center justify-center shrink-0">
            <GraduationCap size={18} />
          </div>
        );
      case "forum":
        return (
          <div className="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/30 text-emerald-400 flex items-center justify-center shrink-0">
            <MessageSquare size={18} />
          </div>
        );
      case "achievement":
        return (
          <div className="w-9 h-9 rounded-xl bg-yellow-500/20 border border-yellow-500/30 text-yellow-400 flex items-center justify-center shrink-0">
            <Trophy size={18} />
          </div>
        );
      case "system":
      default:
        return (
          <div className="w-9 h-9 rounded-xl bg-purple-500/20 border border-purple-500/30 text-purple-400 flex items-center justify-center shrink-0">
            <Sparkles size={18} />
          </div>
        );
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Botón de la Campana */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`relative p-2.5 rounded-xl transition-all flex items-center justify-center ${
          isOpen 
            ? "bg-white/15 text-white shadow-lg shadow-primary/20 border border-white/20" 
            : "text-zinc-400 hover:text-white hover:bg-white/5 border border-transparent"
        }`}
        title="Notificaciones"
        aria-label="Abrir notificaciones"
      >
        <Bell size={20} className={unreadCount > 0 ? "text-primary animate-bounce-short" : ""} />
        
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 min-w-[20px] h-5 px-1 bg-gradient-to-r from-primary to-accent text-white text-[11px] font-black rounded-full flex items-center justify-center shadow-[0_0_12px_rgba(139,92,246,0.8)] border border-[#09090b]">
            {unreadCount > 9 ? "9+" : unreadCount}
          </span>
        )}
      </button>

      {/* Menú Desplegable Flotante */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 8, scale: 0.95 }}
            transition={{ duration: 0.15, ease: "easeOut" }}
            className="absolute right-0 mt-3 w-80 sm:w-96 max-w-[calc(100vw-2rem)] bg-[#0d0d12]/95 backdrop-blur-xl border border-white/15 rounded-2xl shadow-2xl shadow-black/80 z-50 overflow-hidden flex flex-col"
          >
            {/* Header del Dropdown */}
            <div className="p-4 border-b border-white/10 flex items-center justify-between bg-black/40">
              <div className="flex items-center gap-2">
                <Bell size={18} className="text-primary" />
                <h3 className="font-heading font-bold text-white text-base">Notificaciones</h3>
                {unreadCount > 0 && (
                  <span className="px-2 py-0.5 rounded-full bg-primary/20 text-primary border border-primary/30 text-xs font-bold font-mono">
                    {unreadCount} nuevas
                  </span>
                )}
              </div>

              {unreadCount > 0 && (
                <button
                  onClick={markAllAsRead}
                  className="text-xs font-semibold text-zinc-400 hover:text-primary transition-colors flex items-center gap-1.5 px-2 py-1 rounded-lg hover:bg-white/5"
                  title="Marcar todas como leídas"
                >
                  <CheckCheck size={14} />
                  <span>Leídas</span>
                </button>
              )}
            </div>

            {/* Pestañas de Filtro */}
            <div className="flex items-center px-4 pt-3 pb-2 gap-2 border-b border-white/5 bg-black/20">
              <button
                onClick={() => setFilter("all")}
                className={`text-xs font-bold px-3 py-1.5 rounded-lg transition-all ${
                  filter === "all"
                    ? "bg-white/10 text-white shadow-sm"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                Todas ({notifications.length})
              </button>
              <button
                onClick={() => setFilter("unread")}
                className={`text-xs font-bold px-3 py-1.5 rounded-lg transition-all ${
                  filter === "unread"
                    ? "bg-white/10 text-white shadow-sm"
                    : "text-zinc-400 hover:text-white"
                }`}
              >
                No leídas ({unreadCount})
              </button>
            </div>

            {/* Lista de Notificaciones con Scroll */}
            <div className="max-h-[380px] overflow-y-auto divide-y divide-white/5 custom-scrollbar">
              {loading ? (
                <div className="p-8 flex flex-col items-center justify-center gap-3 text-zinc-400">
                  <div className="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin" />
                  <span className="text-xs">Cargando notificaciones...</span>
                </div>
              ) : filteredNotifications.length === 0 ? (
                <div className="p-8 text-center space-y-2">
                  <div className="w-12 h-12 rounded-full bg-white/5 border border-white/10 flex items-center justify-center mx-auto text-zinc-500">
                    <Bell size={20} />
                  </div>
                  <p className="text-sm font-bold text-zinc-300">
                    {filter === "unread" ? "No tienes notificaciones pendientes" : "Sin notificaciones"}
                  </p>
                  <p className="text-xs text-zinc-500">
                    Te avisaremos aquí cuando haya nuevos cursos o respuestas a tus consultas.
                  </p>
                </div>
              ) : (
                filteredNotifications.map((n) => {
                  let timeAgo = "";
                  try {
                    timeAgo = formatDistanceToNow(new Date(n.created_at), { addSuffix: true, locale: es });
                  } catch (e) {
                    timeAgo = "recientemente";
                  }

                  return (
                    <div
                      key={n.id}
                      onClick={() => handleNotificationClick(n)}
                      className={`p-4 flex items-start gap-3.5 transition-colors cursor-pointer group relative ${
                        !n.read 
                          ? "bg-primary/5 hover:bg-primary/10" 
                          : "hover:bg-white/5 opacity-80 hover:opacity-100"
                      }`}
                    >
                      {/* Icono temático */}
                      {getNotificationIcon(n.type)}

                      {/* Contenido */}
                      <div className="flex-1 min-w-0 pr-4">
                        <div className="flex items-center gap-2 mb-1">
                          <h4 className={`text-xs font-bold leading-tight line-clamp-1 ${!n.read ? "text-white" : "text-zinc-300"}`}>
                            {n.title}
                          </h4>
                        </div>
                        <p className="text-xs text-zinc-400 line-clamp-2 leading-relaxed mb-1.5">
                          {n.message}
                        </p>
                        <span className="text-[10px] text-zinc-500 font-mono block">
                          {timeAgo}
                        </span>
                      </div>

                      {/* Indicador de no leído */}
                      {!n.read && (
                        <span className="w-2 h-2 rounded-full bg-primary shrink-0 self-center shadow-[0_0_8px_rgba(139,92,246,1)]" />
                      )}

                      {/* Botón rápido de eliminar */}
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          deleteNotification(n.id);
                        }}
                        className="opacity-0 group-hover:opacity-100 p-1 text-zinc-500 hover:text-red-400 rounded transition-all absolute right-3 top-3"
                        title="Eliminar notificación"
                      >
                        <Trash2 size={13} />
                      </button>
                    </div>
                  );
                })
              )}
            </div>

            {/* Footer */}
            {notifications.length > 0 && (
              <div className="p-2.5 border-t border-white/10 bg-black/40 text-center">
                <span className="text-[11px] text-zinc-500">
                  Haz clic en cualquier aviso para ir al contenido
                </span>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
