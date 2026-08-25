"use client";

import { useState, useEffect, useCallback } from "react";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { Notification } from "@/types";

export function useNotifications() {
  const { user } = useUser();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchNotifications = useCallback(async () => {
    if (!user) {
      setNotifications([]);
      setLoading(false);
      return;
    }

    try {
      const { data, error } = await supabase
        .from("notifications")
        .select("*")
        .eq("user_id", user.id)
        .order("created_at", { ascending: false })
        .limit(40);

      if (error) throw error;
      setNotifications(data || []);
    } catch (err) {
      console.error("Error cargando notificaciones:", err);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    fetchNotifications();

    if (!user) return;

    // Suscripción en tiempo real a nuevas notificaciones
    const channel = supabase
      .channel(`user-notifications-${user.id}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "notifications",
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          const newNotif = payload.new as Notification;
          setNotifications((prev) => [newNotif, ...prev.filter((n) => n.id !== newNotif.id)]);
        }
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "notifications",
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          const updated = payload.new as Notification;
          setNotifications((prev) =>
            prev.map((n) => (n.id === updated.id ? updated : n))
          );
        }
      )
      .on(
        "postgres_changes",
        {
          event: "DELETE",
          schema: "public",
          table: "notifications",
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          const deletedId = payload.old.id;
          setNotifications((prev) => prev.filter((n) => n.id !== deletedId));
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [user, fetchNotifications]);

  const markAsRead = async (id: string) => {
    if (!user) return;

    // Actualización optimista
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, read: true } : n))
    );

    try {
      const { error } = await supabase
        .from("notifications")
        .update({ read: true })
        .eq("id", id)
        .eq("user_id", user.id);

      if (error) throw error;
    } catch (err) {
      console.error("Error al marcar notificación como leída:", err);
      fetchNotifications();
    }
  };

  const markAllAsRead = async () => {
    if (!user || notifications.length === 0) return;

    // Actualización optimista
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));

    try {
      const { error } = await supabase
        .from("notifications")
        .update({ read: true })
        .eq("user_id", user.id)
        .eq("read", false);

      if (error) throw error;
    } catch (err) {
      console.error("Error al marcar todas las notificaciones como leídas:", err);
      fetchNotifications();
    }
  };

  const deleteNotification = async (id: string) => {
    if (!user) return;

    // Actualización optimista
    setNotifications((prev) => prev.filter((n) => n.id !== id));

    try {
      const { error } = await supabase
        .from("notifications")
        .delete()
        .eq("id", id)
        .eq("user_id", user.id);

      if (error) throw error;
    } catch (err) {
      console.error("Error al eliminar notificación:", err);
      fetchNotifications();
    }
  };

  const unreadCount = notifications.filter((n) => !n.read).length;

  return {
    notifications,
    loading,
    unreadCount,
    markAsRead,
    markAllAsRead,
    deleteNotification,
    refetch: fetchNotifications,
  };
}
