"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { Sidebar } from "@/components/layout/Sidebar";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { useRouter } from "next/navigation";
import { useUser } from "@/hooks/useUser";
import { useSidebar } from "@/context/SidebarContext";
import { ShieldAlert, Plus, Users, BookOpen, Sparkles, Check, Trash2, Award, Zap, Copy, GraduationCap, Edit2, Save, X, Tag, Bell, Send, Megaphone, Eye, Lock } from "lucide-react";
import Link from "next/link";

export default function AdminPage() {
  const router = useRouter();
  const { isCollapsed } = useSidebar();
  const { user, isProfesor, isAdmin, loading: userLoading } = useUser();
  const [activeTab, setActiveTab] = useState<"courses" | "content" | "users" | "notifications" | "ai_prompt">("courses");
  
  // Data States
  const [courses, setCourses] = useState<any[]>([]);
  const [modules, setModules] = useState<any[]>([]);
  const [challenges, setChallenges] = useState<any[]>([]);
  const [profiles, setProfiles] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  // New Course Form State
  const [newCourseTitle, setNewCourseTitle] = useState("");
  const [newCourseDesc, setNewCourseDesc] = useState("");
  const [newCourseSummary, setNewCourseSummary] = useState("");
  const [newCourseTags, setNewCourseTags] = useState("");
  const [newCoursePrereqId, setNewCoursePrereqId] = useState("");
  const [newCourseMinLevel, setNewCourseMinLevel] = useState("1");

  // Edit Course Form State
  const [editingCourseId, setEditingCourseId] = useState<string | null>(null);
  const [editCourseTitle, setEditCourseTitle] = useState("");
  const [editCourseDesc, setEditCourseDesc] = useState("");
  const [editCourseSummary, setEditCourseSummary] = useState("");
  const [editCourseTags, setEditCourseTags] = useState("");
  const [editCoursePrereqId, setEditCoursePrereqId] = useState("");
  const [editCourseMinLevel, setEditCourseMinLevel] = useState("1");

  // New Module Form State
  const [courseId, setCourseId] = useState("");
  const [newModuleTitle, setNewModuleTitle] = useState("");
  const [newModuleDescription, setNewModuleDescription] = useState("");
  const [newModuleDifficulty, setNewModuleDifficulty] = useState("1");

  // New Challenge Form State
  const [moduleId, setModuleId] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [challengeType, setChallengeType] = useState("logic");
  const [initialCode, setInitialCode] = useState("");
  const [solutionCode, setSolutionCode] = useState("");
  const [testCode, setTestCode] = useState("");
  const [theory, setTheory] = useState("");
  const [xpReward, setXpReward] = useState("50");
  const [orderIndex, setOrderIndex] = useState("1");

  // User Test Actions State
  const [selectedUserId, setSelectedUserId] = useState("");
  const [addXpAmount, setAddXpAmount] = useState("100");
  const [selectedChallengeToComplete, setSelectedChallengeToComplete] = useState("");

  // Broadcast Announcement State
  const [announcementTitle, setAnnouncementTitle] = useState("");
  const [announcementMessage, setAnnouncementMessage] = useState("");
  const [announcementLink, setAnnouncementLink] = useState("");
  const [isBroadcasting, setIsBroadcasting] = useState(false);

  const [copiedPrompt, setCopiedPrompt] = useState(false);

  useEffect(() => {
    if (!userLoading && !isProfesor) {
      router.push("/");
    }
  }, [userLoading, isProfesor, router]);

  useEffect(() => {
    if (isProfesor) {
      fetchAdminData();
    }
  }, [isProfesor]);

  const fetchAdminData = async () => {
    setLoading(true);
    try {
      // 0. Fetch courses
      const { data: cData } = await supabase.from("courses").select("*").order("created_at", { ascending: true });
      if (cData) {
        setCourses(cData);
        if (cData.length > 0 && !courseId) setCourseId(cData[0].id);
      }

      // 1. Fetch modules
      const { data: modData } = await supabase.from("modules").select("*, courses(title)").order("created_at", { ascending: true });
      if (modData) {
        setModules(modData);
        if (modData.length > 0 && !moduleId) setModuleId(modData[0].id);
      }

      // 2. Fetch challenges
      const { data: chData } = await supabase.from("challenges").select("*, modules(title)").order("created_at", { ascending: false });
      if (chData) setChallenges(chData);

      // 3. Fetch profiles
      const { data: profData } = await supabase.from("profiles").select("*").order("xp", { ascending: false });
      if (profData) {
        setProfiles(profData);
        if (profData.length > 0 && !selectedUserId) setSelectedUserId(profData[0].id);
      }
    } catch (e: any) {
      console.error("Error fetching admin data:", e?.message || String(e));
    } finally {
      setLoading(false);
    }
  };

  const handleCreateCourse = async (e: React.FormEvent) => {
    e.preventDefault();
    const parsedTags = newCourseTags
      .split(",")
      .map((t) => t.trim())
      .filter(Boolean);

    const { error } = await supabase.from("courses").insert({
      title: newCourseTitle,
      description: newCourseDesc,
      summary: newCourseSummary || null,
      tags: parsedTags,
      prerequisite_course_id: newCoursePrereqId || null,
      min_level: parseInt(newCourseMinLevel) || 1,
      author_id: user?.id,
      status: 'published'
    });

    if (error) {
      alert("Error al crear curso: " + error.message);
    } else {
      alert("¡Curso creado exitosamente!");
      setNewCourseTitle("");
      setNewCourseDesc("");
      setNewCourseSummary("");
      setNewCourseTags("");
      setNewCoursePrereqId("");
      setNewCourseMinLevel("1");
      fetchAdminData();
    }
  };

  const startEditingCourse = (course: any) => {
    setEditingCourseId(course.id);
    setEditCourseTitle(course.title || "");
    setEditCourseDesc(course.description || "");
    setEditCourseSummary(course.summary || "");
    setEditCourseTags(Array.isArray(course.tags) ? course.tags.join(", ") : "");
    setEditCoursePrereqId(course.prerequisite_course_id || "");
    setEditCourseMinLevel(String(course.min_level || 1));
  };

  const cancelEditingCourse = () => {
    setEditingCourseId(null);
    setEditCourseTitle("");
    setEditCourseDesc("");
    setEditCourseSummary("");
    setEditCourseTags("");
    setEditCoursePrereqId("");
    setEditCourseMinLevel("1");
  };

  const handleUpdateCourse = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCourseId) return;

    const parsedTags = editCourseTags
      .split(",")
      .map((t) => t.trim())
      .filter(Boolean);

    const { error } = await supabase
      .from("courses")
      .update({
        title: editCourseTitle,
        description: editCourseDesc,
        summary: editCourseSummary || null,
        tags: parsedTags,
        prerequisite_course_id: editCoursePrereqId || null,
        min_level: parseInt(editCourseMinLevel) || 1,
      })
      .eq("id", editingCourseId);

    if (error) {
      alert("Error al actualizar curso: " + error.message);
    } else {
      alert("¡Curso actualizado exitosamente!");
      cancelEditingCourse();
      fetchAdminData();
    }
  };

  const handleCreateModule = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!courseId) return alert("Selecciona un curso primero");
    
    const { error } = await supabase.from("modules").insert({
      course_id: courseId,
      title: newModuleTitle,
      description: newModuleDescription,
      difficulty_level: parseInt(newModuleDifficulty),
    });

    if (error) {
      alert("Error al crear módulo: " + error.message);
    } else {
      alert("¡Módulo creado exitosamente!");
      setNewModuleTitle("");
      setNewModuleDescription("");
      fetchAdminData();
    }
  };

  const handleCreateChallenge = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.from("challenges").insert({
      module_id: moduleId,
      title,
      description,
      theory,
      challenge_type: challengeType,
      initial_code: initialCode,
      solution_code: solutionCode,
      test_code: testCode,
      xp_reward: parseInt(xpReward),
      order_index: parseInt(orderIndex),
    });

    if (error) {
      alert("Error al crear reto: " + error.message);
    } else {
      alert("¡Reto creado exitosamente!");
      setTitle("");
      setDescription("");
      setTheory("");
      setInitialCode("");
      setSolutionCode("");
      setTestCode("");
      fetchAdminData();
    }
  };

  const handleDeleteCourse = async (id: string, courseTitle: string) => {
    if (!confirm(`¿Estás seguro de que deseas eliminar el curso "${courseTitle}"? Se eliminarán también todos sus módulos y retos asociados.`)) {
      return;
    }
    const { error } = await supabase.from("courses").delete().eq("id", id);
    if (error) {
      alert("Error al eliminar el curso: " + error.message);
    } else {
      fetchAdminData();
    }
  };

  const handleDeleteChallenge = async (id: string) => {
    if (!confirm("¿Estás seguro de eliminar este reto?")) return;
    const { error } = await supabase.from("challenges").delete().eq("id", id);
    if (error) {
      alert("Error al eliminar: " + error.message);
    } else {
      fetchAdminData();
    }
  };

  const handleChangeRole = async (userId: string, newRole: string) => {
    if (!isAdmin) return;
    try {
      const { error } = await supabase.from("profiles").update({ role: newRole }).eq("id", userId);
      if (error) throw error;
      fetchAdminData();
    } catch (err) {
      console.error(err);
      alert("Error al cambiar rol");
    }
  };

  // Test Actions: Manual XP & Level Assignment
  const handleAssignXp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedUserId) return alert("Selecciona un usuario");

    const targetUser = profiles.find((p) => p.id === selectedUserId);
    if (!targetUser) return;

    const added = parseInt(addXpAmount);
    const newXp = (targetUser.xp || 0) + added;
    const newLevel = Math.floor(newXp / 100) + 1;

    const { error } = await supabase
      .from("profiles")
      .update({ xp: newXp, level: newLevel })
      .eq("id", selectedUserId);

    if (error) {
      alert("Error al asignar XP: " + error.message);
    } else {
      alert(`¡+${added} XP asignados con éxito a @${targetUser.username}! Nivel actualizado a ${newLevel}.`);
      fetchAdminData();
    }
  };

  // Test Actions: Force Complete Challenge for Testing Roadmap
  const handleForceCompleteChallenge = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedUserId || !selectedChallengeToComplete) return alert("Selecciona usuario y reto");

    const { error } = await supabase.from("user_progress").upsert({
      user_id: selectedUserId,
      challenge_id: selectedChallengeToComplete,
      status: "completed",
      completed_at: new Date().toISOString(),
    });

    if (error) {
      alert("Error al completar reto: " + error.message);
    } else {
      alert("¡Reto marcado como completado para pruebas! Puedes ver el tablero desbloqueado.");
    }
  };

  // Broadcast Notification to All Users
  const handleBroadcastNotification = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!announcementTitle.trim() || !announcementMessage.trim()) {
      return alert("El título y el mensaje son obligatorios");
    }

    setIsBroadcasting(true);
    try {
      // 1. Intentar llamar al stored procedure
      const { data, error } = await supabase.rpc("broadcast_system_notification", {
        p_title: announcementTitle.trim(),
        p_message: announcementMessage.trim(),
        p_link: announcementLink.trim() || null,
      });

      if (error) throw error;
      alert(`¡Notificación enviada exitosamente a ${data || "todos los"} usuarios! 📢`);
      setAnnouncementTitle("");
      setAnnouncementMessage("");
      setAnnouncementLink("");
    } catch (err: any) {
      console.warn("RPC broadcast_system_notification fallback:", err?.message);
      // 2. Fallback manual con insert múltiple
      try {
        const { data: profs } = await supabase.from("profiles").select("id");
        if (profs && profs.length > 0) {
          const rows = profs.map((p) => ({
            user_id: p.id,
            type: "system",
            title: announcementTitle.trim(),
            message: announcementMessage.trim(),
            link: announcementLink.trim() || null,
          }));
          const { error: insertErr } = await supabase.from("notifications").insert(rows);
          if (insertErr) throw insertErr;

          alert(`¡Notificación emitida a ${profs.length} usuarios exitosamente! 📢`);
          setAnnouncementTitle("");
          setAnnouncementMessage("");
          setAnnouncementLink("");
        } else {
          alert("No se encontraron usuarios para notificar");
        }
      } catch (fallbackErr: any) {
        alert("Error al emitir notificación: " + (fallbackErr.message || err.message));
      }
    } finally {
      setIsBroadcasting(false);
    }
  };

  // AI Prompt Template
  const aiPromptText = `Actúa como un Diseñador Curricular de Programación y Experto en JavaScript para la plataforma gamificada "Codify".

Necesito que generes el contenido completo para un nuevo MÓDULO de aprendizaje y sus 5 RETOS progresivos en formato de script SQL de PostgreSQL para insertar directamente en Supabase.

TEMA DEL MÓDULO SOLICITADO:
"[REEMPLAZAR: Ej. Programación Orientada a Objetos en JavaScript / Manipulación del DOM]"

DIFICULTAD: 2

ESTRUCTURA REQUERIDA PARA CADA UNO DE LOS 5 RETOS:
1. 'order_index' (del 1 al 5).
2. 'title': Nombre corto y atractivo (Ej: "Lección 1: Clases y Constructores").
3. 'description': Consigna clara y directa del reto.
4. 'theory': Micro-lección teórica en formato Markdown con:
   - Explicación sencilla del concepto.
   - Símbolo 💡, 📝, 🎯.
   - Bloque de código de ejemplo estilizado (\`\`\`js ... \`\`\`).
5. 'initial_code': Código base para el estudiante.
6. 'solution_code': Código solución ideal.
7. 'test_code': Test unitario oculto que valida el resultado con:
   const assert = (c, m) => { if (!c) throw new Error(m); };
   assert(...);
8. 'xp_reward': Recompensa progresiva (Ej: 25, 30, 40, 50, 75).

REGLA CRÍTICA DE SINTAXIS SQL:
Utiliza Dollar Quoting ($THEORY$, $CODE$, $TEST$) para todas las cadenas multilínea y evitar errores de escape de comillas en Postgres.

Genera el script SQL completo listo para copiar y pegar.`;

  const copyPromptToClipboard = () => {
    navigator.clipboard.writeText(aiPromptText);
    setCopiedPrompt(true);
    setTimeout(() => setCopiedPrompt(false), 2500);
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 p-8 overflow-y-auto transition-all duration-300`}>
        
        {/* Header */}
        <header className="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-white/10 pb-6">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-xl bg-danger/20 flex items-center justify-center text-danger border border-danger/30">
              <ShieldAlert size={28} />
            </div>
            <div>
              <h1 className="text-3xl font-heading font-bold text-white">Panel de Administración</h1>
              <p className="text-sm text-zinc-400">Gestiona contenido, asigna XP y genera cursos con IA.</p>
            </div>
          </div>

          {/* Admin Navigation Tabs */}
          <div className="flex flex-wrap items-center bg-black/60 p-1 rounded-xl border border-white/10 shrink-0 gap-1">
            <button
              onClick={() => setActiveTab("courses")}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                activeTab === "courses" ? "bg-indigo-600 text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <GraduationCap size={16} /> Cursos Principales
            </button>
            <button
              onClick={() => setActiveTab("content")}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                activeTab === "content" ? "bg-primary text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <BookOpen size={16} /> Módulos & Retos
            </button>
            {isAdmin && (
              <button
                onClick={() => setActiveTab("users")}
                className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                  activeTab === "users" ? "bg-emerald-500 text-white shadow-lg" : "text-zinc-400 hover:text-white"
                }`}
              >
                <Users size={16} /> Usuarios & Roles
              </button>
            )}
            <button
              onClick={() => setActiveTab("notifications")}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                activeTab === "notifications" ? "bg-amber-500 text-white shadow-lg shadow-amber-500/20" : "text-zinc-400 hover:text-white"
              }`}
            >
              <Bell size={16} /> Difusión & Anuncios
            </button>
            <button
              onClick={() => setActiveTab("ai_prompt")}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all ${
                activeTab === "ai_prompt" ? "bg-accent text-white shadow-lg" : "text-zinc-400 hover:text-white"
              }`}
            >
              <Sparkles size={16} /> Generador IA
            </button>
          </div>
        </header>

        {userLoading || loading ? (
          <div className="flex items-center justify-center p-20">
            <div className="w-8 h-8 rounded-full border-4 border-indigo-500 border-t-transparent animate-spin"></div>
          </div>
        ) : (
          <>
            {/* TAB 0: CURSOS */}
            {activeTab === "courses" && (
              <div className="space-y-8">
                <Card className="p-6 glass-panel border-t-4 border-t-indigo-500 space-y-4">
                  <h2 className="text-xl font-bold flex items-center gap-2 text-indigo-400">
                    <Plus size={20} />
                    Crear Nuevo Curso Global
                  </h2>
                  <form onSubmit={handleCreateCourse} className="space-y-4">
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">Título del Curso</label>
                      <input required type="text" value={newCourseTitle} onChange={(e) => setNewCourseTitle(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500" placeholder="Ej: Bootcamp Full Stack con Python" />
                    </div>
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">Descripción Breve (Catálogo)</label>
                      <textarea required value={newCourseDesc} onChange={(e) => setNewCourseDesc(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500 h-20" placeholder="Ej: Aprende Python, FastAPI, IA desde cero..." />
                    </div>
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">
                        Resumen Detallado / Ficha Técnica (Markdown para Preview)
                      </label>
                      <textarea
                        value={newCourseSummary}
                        onChange={(e) => setNewCourseSummary(e.target.value)}
                        className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500 h-32 font-mono text-xs"
                        placeholder="## 🚀 Acerca del Curso&#10;Explica a fondo los objetivos pedagógicos, prerrequisitos, público objetivo..."
                      />
                    </div>
                    <div>
                      <div className="flex items-center justify-between mb-1">
                        <label className="block text-sm text-zinc-400">Etiquetas / Tags (Separadas por coma)</label>
                        <div className="flex gap-2">
                          <button
                            type="button"
                            onClick={() => {
                              const current = newCourseTags ? newCourseTags.split(",").map(s => s.trim()) : [];
                              if (!current.includes("Práctico")) current.unshift("Práctico");
                              setNewCourseTags(current.join(", "));
                            }}
                            className="text-xs px-2 py-0.5 rounded bg-indigo-500/20 text-indigo-300 hover:bg-indigo-500/30 border border-indigo-500/30 transition-all"
                          >
                            + Práctico
                          </button>
                          <button
                            type="button"
                            onClick={() => {
                              const current = newCourseTags ? newCourseTags.split(",").map(s => s.trim()) : [];
                              if (!current.includes("Teórico")) current.unshift("Teórico");
                              setNewCourseTags(current.join(", "));
                            }}
                            className="text-xs px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 hover:bg-emerald-500/30 border border-emerald-500/30 transition-all"
                          >
                            + Teórico
                          </button>
                        </div>
                      </div>
                      <input
                        type="text"
                        value={newCourseTags}
                        onChange={(e) => setNewCourseTags(e.target.value)}
                        className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500"
                        placeholder="Ej: Teórico, Redes, Telecomunicaciones, Cisco"
                      />
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm text-zinc-400 mb-1">
                          🔒 Curso Prerrequisito (Opcional)
                        </label>
                        <select
                          value={newCoursePrereqId}
                          onChange={(e) => setNewCoursePrereqId(e.target.value)}
                          className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500 text-sm"
                        >
                          <option value="">-- Sin prerrequisito (Curso Inicial) --</option>
                          {courses.map((c) => (
                            <option key={c.id} value={c.id}>
                              {c.title}
                            </option>
                          ))}
                        </select>
                      </div>

                      <div>
                        <label className="block text-sm text-zinc-400 mb-1">
                          ⭐ Nivel de Jugador Mínimo
                        </label>
                        <input
                          type="number"
                          min="1"
                          max="100"
                          value={newCourseMinLevel}
                          onChange={(e) => setNewCourseMinLevel(e.target.value)}
                          className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-indigo-500 text-sm"
                        />
                      </div>
                    </div>

                    <Button type="submit" className="w-full py-3 bg-indigo-600 hover:bg-indigo-500 text-white">
                      Publicar Curso
                    </Button>
                  </form>
                </Card>

                <Card className="p-6 glass-panel space-y-4">
                  <h3 className="text-lg font-bold text-white">Cursos Existentes ({courses.length})</h3>
                  <div className="divide-y divide-white/10">
                    {courses.map((c) => (
                      <div key={c.id} className="py-4">
                        {editingCourseId === c.id ? (
                          /* Edit Course Form */
                          <form onSubmit={handleUpdateCourse} className="p-4 rounded-xl bg-black/40 border border-indigo-500/30 space-y-4">
                            <div className="flex items-center justify-between border-b border-white/10 pb-2">
                              <span className="text-sm font-bold text-indigo-400 flex items-center gap-2">
                                <Edit2 size={16} /> Editando Curso: {c.title}
                              </span>
                              <button
                                type="button"
                                onClick={cancelEditingCourse}
                                className="text-zinc-400 hover:text-white p-1 rounded-md transition-colors"
                              >
                                <X size={18} />
                              </button>
                            </div>

                            <div>
                              <label className="block text-xs text-zinc-400 mb-1">Título</label>
                              <input
                                type="text"
                                required
                                value={editCourseTitle}
                                onChange={(e) => setEditCourseTitle(e.target.value)}
                                className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-sm outline-none focus:border-indigo-500"
                              />
                            </div>

                            <div>
                              <label className="block text-xs text-zinc-400 mb-1">Descripción Breve</label>
                              <textarea
                                required
                                value={editCourseDesc}
                                onChange={(e) => setEditCourseDesc(e.target.value)}
                                className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-sm outline-none focus:border-indigo-500 h-16"
                              />
                            </div>

                            <div>
                              <label className="block text-xs text-zinc-400 mb-1">
                                Resumen Detallado / Ficha Técnica (Markdown)
                              </label>
                              <textarea
                                value={editCourseSummary}
                                onChange={(e) => setEditCourseSummary(e.target.value)}
                                className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-xs font-mono outline-none focus:border-indigo-500 h-28"
                                placeholder="## 🚀 Acerca del Curso..."
                              />
                            </div>

                            <div>
                              <div className="flex items-center justify-between mb-1">
                                <label className="block text-xs text-zinc-400">Etiquetas (Separadas por comas)</label>
                                <div className="flex gap-2">
                                  <button
                                    type="button"
                                    onClick={() => {
                                      const current = editCourseTags ? editCourseTags.split(",").map(s => s.trim()) : [];
                                      if (!current.includes("Práctico")) current.unshift("Práctico");
                                      setEditCourseTags(current.join(", "));
                                    }}
                                    className="text-xs px-2 py-0.5 rounded bg-indigo-500/20 text-indigo-300 hover:bg-indigo-500/30 border border-indigo-500/30 transition-all"
                                  >
                                    + Práctico
                                  </button>
                                  <button
                                    type="button"
                                    onClick={() => {
                                      const current = editCourseTags ? editCourseTags.split(",").map(s => s.trim()) : [];
                                      if (!current.includes("Teórico")) current.unshift("Teórico");
                                      setEditCourseTags(current.join(", "));
                                    }}
                                    className="text-xs px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 hover:bg-emerald-500/30 border border-emerald-500/30 transition-all"
                                  >
                                    + Teórico
                                  </button>
                                </div>
                              </div>
                              <input
                                type="text"
                                value={editCourseTags}
                                onChange={(e) => setEditCourseTags(e.target.value)}
                                className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-sm outline-none focus:border-indigo-500"
                                placeholder="Ej: Teórico, Redes, OSI"
                              />
                            </div>

                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                              <div>
                                <label className="block text-xs text-zinc-400 mb-1">
                                  🔒 Curso Prerrequisito
                                </label>
                                <select
                                  value={editCoursePrereqId}
                                  onChange={(e) => setEditCoursePrereqId(e.target.value)}
                                  className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-xs outline-none focus:border-indigo-500"
                                >
                                  <option value="">-- Sin prerrequisito --</option>
                                  {courses
                                    .filter((co) => co.id !== editingCourseId)
                                    .map((co) => (
                                      <option key={co.id} value={co.id}>
                                        {co.title}
                                      </option>
                                    ))}
                                </select>
                              </div>

                              <div>
                                <label className="block text-xs text-zinc-400 mb-1">
                                  ⭐ Nivel Mínimo Requerido
                                </label>
                                <input
                                  type="number"
                                  min="1"
                                  max="100"
                                  value={editCourseMinLevel}
                                  onChange={(e) => setEditCourseMinLevel(e.target.value)}
                                  className="w-full p-2.5 rounded-lg bg-black/60 border border-white/10 text-white text-xs outline-none focus:border-indigo-500"
                                />
                              </div>
                            </div>

                            <div className="flex justify-end gap-2 pt-2">
                              <Button
                                type="button"
                                variant="outline"
                                size="sm"
                                onClick={cancelEditingCourse}
                              >
                                Cancelar
                              </Button>
                              <Button
                                type="submit"
                                size="sm"
                                className="bg-indigo-600 hover:bg-indigo-500 text-white"
                                leftIcon={<Save size={16} />}
                              >
                                Guardar Cambios
                              </Button>
                            </div>
                          </form>
                        ) : (
                          /* Course Row */
                          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                            <div className="flex-1">
                              <div className="flex flex-wrap items-center gap-2 mb-2">
                                <span className="text-xs font-bold text-indigo-400 bg-indigo-500/10 px-2 py-0.5 rounded uppercase">
                                  {c.status || "published"}
                                </span>

                                {c.min_level > 1 && (
                                  <span className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-md bg-purple-500/20 text-purple-300 border border-purple-500/30">
                                    ⭐ Nivel {c.min_level}
                                  </span>
                                )}

                                {c.prerequisite_course_id && (
                                  <span className="text-[10px] uppercase font-bold px-2 py-0.5 rounded-md bg-amber-500/20 text-amber-300 border border-amber-500/30 flex items-center gap-1">
                                    <Lock size={10} /> Correlativo
                                  </span>
                                )}

                                {Array.isArray(c.tags) && c.tags.map((tag: string) => {
                                  const isTeorico = tag.toLowerCase() === 'teórico' || tag.toLowerCase() === 'teorico';
                                  const isPractico = tag.toLowerCase() === 'práctico' || tag.toLowerCase() === 'practico';
                                  let tagStyle = "bg-white/5 text-zinc-400 border border-white/10";
                                  if (isTeorico) tagStyle = "bg-emerald-500/20 text-emerald-400 border border-emerald-500/30";
                                  else if (isPractico) tagStyle = "bg-indigo-500/20 text-indigo-400 border border-indigo-500/30";

                                  return (
                                    <span key={tag} className={`text-[10px] uppercase font-bold px-2 py-0.5 rounded-md ${tagStyle}`}>
                                      {tag}
                                    </span>
                                  );
                                })}
                              </div>
                              <h4 className="font-bold text-white text-lg">{c.title}</h4>
                              <p className="text-sm text-zinc-400 mt-1">{c.description}</p>
                            </div>
                            
                            {(isAdmin || isProfesor) && (
                              <div className="flex items-center gap-2 shrink-0 flex-wrap">
                                <Link
                                  href={`/cursos/${c.id}/preview`}
                                  target="_blank"
                                  className="px-3 py-2 rounded-lg bg-white/5 hover:bg-white/10 text-zinc-300 hover:text-white border border-white/10 transition-colors flex items-center gap-1.5 text-xs font-bold"
                                  title="Ver ficha de previsualización"
                                >
                                  <Eye size={15} />
                                  <span>Ficha</span>
                                </Link>
                                <button 
                                  onClick={() => startEditingCourse(c)}
                                  className="px-3 py-2 rounded-lg bg-indigo-500/10 hover:bg-indigo-500/20 text-indigo-400 hover:text-indigo-300 border border-indigo-500/20 transition-colors flex items-center gap-1.5 text-xs font-bold"
                                  title="Editar curso, resumen y etiquetas"
                                >
                                  <Edit2 size={15} />
                                  <span>Editar</span>
                                </button>
                                <button 
                                  onClick={() => handleDeleteCourse(c.id, c.title)}
                                  className="px-3 py-2 rounded-lg bg-red-500/10 hover:bg-red-500/20 text-red-400 hover:text-red-300 border border-red-500/20 transition-colors flex items-center gap-1.5 text-xs font-bold"
                                  title="Eliminar curso"
                                >
                                  <Trash2 size={15} />
                                  <span>Eliminar</span>
                                </button>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </Card>
              </div>
            )}

            {/* TAB 1: GESTIÓN DE CONTENIDO & RETOS */}
            {activeTab === "content" && (
          <div className="space-y-8">
            <div className="grid grid-cols-1 xl:grid-cols-2 gap-8">
              {/* Form to Create Module */}
              <Card className="p-6 glass-panel h-fit border-t-4 border-t-accent space-y-4">
                <h2 className="text-xl font-bold flex items-center gap-2 text-accent">
                  <Plus size={20} />
                  1. Crear Nuevo Módulo para un Curso
                </h2>
                <form onSubmit={handleCreateModule} className="space-y-4">
                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Curso al que pertenece</label>
                    <select
                      value={courseId}
                      onChange={(e) => setCourseId(e.target.value)}
                      className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent"
                      required
                    >
                      <option value="" disabled>Selecciona un curso...</option>
                      {courses.map((c) => (
                        <option key={c.id} value={c.id}>{c.title}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Título del Módulo</label>
                    <input required type="text" value={newModuleTitle} onChange={(e) => setNewModuleTitle(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent" placeholder="Ej: Programación Orientada a Objetos" />
                  </div>
                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Descripción</label>
                    <textarea required value={newModuleDescription} onChange={(e) => setNewModuleDescription(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent h-24" placeholder="Ej: Domina clases, objetos, herencia y encapsulamiento..." />
                  </div>
                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Nivel de Dificultad</label>
                    <input required type="number" value={newModuleDifficulty} onChange={(e) => setNewModuleDifficulty(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-accent" />
                  </div>
                  <Button type="submit" className="w-full py-3 bg-accent hover:bg-accent/80 text-white shadow-[0_0_15px_rgba(56,189,248,0.3)]">
                    Crear Módulo
                  </Button>
                </form>
              </Card>

              {/* Form to Create Challenge */}
              <Card className="p-6 glass-panel border-t-4 border-t-primary space-y-4">
                <h2 className="text-xl font-bold flex items-center gap-2 text-primary">
                  <Plus size={20} />
                  2. Crear Nuevo Reto / Lección
                </h2>
                <form onSubmit={handleCreateChallenge} className="space-y-4">
                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Módulo Asociado</label>
                    <select
                      value={moduleId}
                      onChange={(e) => setModuleId(e.target.value)}
                      className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary"
                      required
                    >
                      <option value="" disabled>Selecciona un módulo...</option>
                      {modules.map((m) => (
                        <option key={m.id} value={m.id}>{m.title}</option>
                      ))}
                    </select>
                  </div>

                  <div className="grid grid-cols-3 gap-4">
                    <div className="col-span-2">
                      <label className="block text-sm text-zinc-400 mb-1">Título del Reto</label>
                      <input required type="text" value={title} onChange={(e) => setTitle(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary" placeholder="Ej: Lección 1: Clases y Objetos" />
                    </div>
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">Orden (Index)</label>
                      <input required type="number" value={orderIndex} onChange={(e) => setOrderIndex(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary" />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Descripción Breve (Consigna)</label>
                    <textarea required value={description} onChange={(e) => setDescription(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary h-20" />
                  </div>

                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">📚 Contenido Teórico / Micro-lección (Markdown/Texto)</label>
                    <textarea value={theory} onChange={(e) => setTheory(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary h-36 font-mono text-sm" placeholder="### 💡 Concepto..." />
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">Tipo de Entorno</label>
                      <select value={challengeType} onChange={(e) => setChallengeType(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary">
                        <option value="logic">Lógica Algorítmica (JS)</option>
                        <option value="web">Prototipado Web (HTML/CSS/JS)</option>
                        <option value="quiz">Quiz / Cuestionario Teórico</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm text-zinc-400 mb-1">XP de Recompensa</label>
                      <input required type="number" value={xpReward} onChange={(e) => setXpReward(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white outline-none focus:border-primary" />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Código Inicial (Para el Estudiante)</label>
                    <textarea value={initialCode} onChange={(e) => setInitialCode(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white font-mono text-sm h-28 outline-none focus:border-primary" />
                  </div>

                  <div>
                    <label className="block text-sm text-zinc-400 mb-1">Código de Tests Unitarios Ocultos</label>
                    <textarea value={testCode} onChange={(e) => setTestCode(e.target.value)} className="w-full p-3 rounded-lg bg-black/40 border border-white/10 text-white font-mono text-sm h-28 outline-none focus:border-primary" placeholder="const assert = (c, m) => { if(!c) throw new Error(m); };" />
                  </div>

                  <Button type="submit" className="w-full py-4 mt-4">Crear Reto Oficial</Button>
                </form>
              </Card>
            </div>

            {/* List of Created Challenges */}
            <Card className="p-6 glass-panel space-y-4">
              <h3 className="text-lg font-bold text-white">Retos Registrados ({challenges.length})</h3>
              <div className="divide-y divide-white/10">
                {challenges.map((c) => (
                  <div key={c.id} className="py-4 flex items-center justify-between gap-4">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <span className="text-xs font-bold text-primary bg-primary/10 px-2 py-0.5 rounded">
                          {c.modules?.title || "Sin Módulo"}
                        </span>
                        <span className="text-xs text-zinc-500 font-mono">Orden: {c.order_index}</span>
                      </div>
                      <h4 className="font-bold text-white">{c.title}</h4>
                      <p className="text-xs text-zinc-400 line-clamp-1">{c.description}</p>
                    </div>
                    <div className="flex items-center gap-3">
                      <span className="text-xs text-emerald-400 font-bold">+{c.xp_reward} XP</span>
                      <button onClick={() => handleDeleteChallenge(c.id)} className="text-zinc-500 hover:text-danger p-2 transition-colors">
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {/* TAB 2: GESTIÓN DE USUARIOS & PRUEBAS */}
        {activeTab === "users" && (
          <div className="grid grid-cols-1 xl:grid-cols-2 gap-8">
            {/* User List & Manual XP Tool */}
            <Card className="p-6 glass-panel border-t-4 border-t-emerald-400 space-y-6">
              <h2 className="text-xl font-bold flex items-center gap-2 text-emerald-400">
                <Award size={20} />
                Asignación Manual de XP y Nivel
              </h2>

              <form onSubmit={handleAssignXp} className="space-y-4 bg-black/40 p-4 rounded-xl border border-white/10">
                <div>
                  <label className="block text-sm text-zinc-400 mb-1">Seleccionar Usuario</label>
                  <select
                    value={selectedUserId}
                    onChange={(e) => setSelectedUserId(e.target.value)}
                    className="w-full p-3 rounded-lg bg-black/60 border border-white/10 text-white outline-none focus:border-emerald-400"
                    required
                  >
                    {profiles.map((p) => (
                      <option key={p.id} value={p.id}>
                        @{p.username} - Nivel {p.level} ({p.xp} XP)
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm text-zinc-400 mb-1">Cantidad de XP a Sumar</label>
                  <input
                    type="number"
                    value={addXpAmount}
                    onChange={(e) => setAddXpAmount(e.target.value)}
                    className="w-full p-3 rounded-lg bg-black/60 border border-white/10 text-white outline-none focus:border-emerald-400"
                    required
                  />
                </div>

                <Button type="submit" className="w-full py-3 bg-emerald-500 hover:bg-emerald-600 text-black font-bold">
                  Sumar XP al Usuario
                </Button>
              </form>

              {/* Force Complete Challenge for Testing Roadmap */}
              <h2 className="text-xl font-bold flex items-center gap-2 text-yellow-400 pt-4 border-t border-white/10">
                <Zap size={20} />
                Completar Retos Forzado (Para Pruebas del Tablero)
              </h2>

              <form onSubmit={handleForceCompleteChallenge} className="space-y-4 bg-black/40 p-4 rounded-xl border border-white/10">
                <div>
                  <label className="block text-sm text-zinc-400 mb-1">Seleccionar Reto a Marcar como "Completado"</label>
                  <select
                    value={selectedChallengeToComplete}
                    onChange={(e) => setSelectedChallengeToComplete(e.target.value)}
                    className="w-full p-3 rounded-lg bg-black/60 border border-white/10 text-white outline-none focus:border-yellow-400"
                    required
                  >
                    <option value="" disabled>Selecciona un reto...</option>
                    {challenges.map((c) => (
                      <option key={c.id} value={c.id}>
                        [{c.modules?.title}] {c.title}
                      </option>
                    ))}
                  </select>
                </div>

                <Button type="submit" className="w-full py-3 bg-yellow-500 hover:bg-yellow-600 text-black font-bold">
                  Marcar Reto como Aprobado
                </Button>
              </form>
            </Card>

            {/* Profiles Table */}
            <Card className="p-6 glass-panel space-y-4">
              <h3 className="text-lg font-bold text-white">Usuarios Registrados ({profiles.length})</h3>
              <div className="divide-y divide-white/10">
                {profiles.map((p) => (
                  <div key={p.id} className="py-3 flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <h4 className="font-bold text-white">@{p.username}</h4>
                        <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase ${
                          p.role === 'admin' ? 'bg-red-500/20 text-red-400' :
                          p.role === 'profesor' ? 'bg-indigo-500/20 text-indigo-400' :
                          'bg-zinc-500/20 text-zinc-400'
                        }`}>
                          {p.role || 'student'}
                        </span>
                      </div>
                      <span className="text-xs text-zinc-400">ID: {p.id.slice(0, 8)}...</span>
                    </div>
                    
                    {isAdmin && (
                      <div className="mr-4">
                        <select 
                          className="bg-black/60 border border-white/20 rounded px-2 py-1 text-xs text-zinc-300 focus:outline-none focus:border-indigo-500 cursor-pointer"
                          value={p.role || 'student'}
                          onChange={(e) => handleChangeRole(p.id, e.target.value)}
                          disabled={p.id === user?.id}
                        >
                          <option value="student">Estudiante</option>
                          <option value="profesor">Profesor</option>
                          <option value="admin">Administrador</option>
                        </select>
                      </div>
                    )}

                    <div className="text-right">
                      <span className="text-sm font-bold text-primary block">Nivel {p.level}</span>
                      <span className="text-xs text-zinc-400">{p.xp} Puntos XP</span>
                    </div>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {/* TAB 3: DIFUSIÓN Y ANUNCIOS GLOBALES */}
        {activeTab === "notifications" && (
          <div className="max-w-4xl mx-auto space-y-6">
            <Card className="p-8 glass-panel border-t-4 border-t-amber-500 space-y-6 shadow-2xl">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-2xl bg-amber-500/20 text-amber-400 border border-amber-500/30 flex items-center justify-center">
                  <Megaphone size={24} />
                </div>
                <div>
                  <h2 className="text-2xl font-bold text-white">Difusión de Anuncios del Sistema</h2>
                  <p className="text-sm text-zinc-400">Envía un comunicado o notificación instantánea a toda la comunidad de Codify.</p>
                </div>
              </div>

              <form onSubmit={handleBroadcastNotification} className="space-y-4">
                <div>
                  <label className="block text-sm text-zinc-300 font-semibold mb-1">Título del Comunicado</label>
                  <input
                    type="text"
                    required
                    value={announcementTitle}
                    onChange={(e) => setAnnouncementTitle(e.target.value)}
                    placeholder="Ej: ¡Nueva actualización en la plataforma! 🚀"
                    className="w-full p-3.5 rounded-xl bg-black/50 border border-white/10 text-white text-sm outline-none focus:border-amber-500 transition-colors"
                  />
                </div>

                <div>
                  <label className="block text-sm text-zinc-300 font-semibold mb-1">Mensaje Detallado</label>
                  <textarea
                    required
                    rows={4}
                    value={announcementMessage}
                    onChange={(e) => setAnnouncementMessage(e.target.value)}
                    placeholder="Ej: Hemos renovado el catálogo de cursos y añadido el nuevo módulo de Telecomunicaciones. ¡Entra a explorarlo!"
                    className="w-full p-3.5 rounded-xl bg-black/50 border border-white/10 text-white text-sm outline-none focus:border-amber-500 transition-colors"
                  />
                </div>

                <div>
                  <label className="block text-sm text-zinc-300 font-semibold mb-1">Enlace de Destino (Opcional)</label>
                  <input
                    type="text"
                    value={announcementLink}
                    onChange={(e) => setAnnouncementLink(e.target.value)}
                    placeholder="Ej: /cursos o /foro"
                    className="w-full p-3.5 rounded-xl bg-black/50 border border-white/10 text-white text-sm outline-none focus:border-amber-500 transition-colors"
                  />
                </div>

                {/* Vista previa en vivo */}
                {announcementTitle && (
                  <div className="p-4 rounded-xl bg-black/40 border border-amber-500/30 space-y-2">
                    <span className="text-[11px] font-bold text-amber-400 uppercase tracking-wider block">
                      Vista previa de cómo lo verán los usuarios:
                    </span>
                    <div className="p-3 rounded-lg bg-purple-500/10 border border-purple-500/20 flex items-start gap-3">
                      <div className="w-8 h-8 rounded-lg bg-purple-500/20 text-purple-400 flex items-center justify-center shrink-0">
                        <Sparkles size={16} />
                      </div>
                      <div>
                        <h4 className="text-xs font-bold text-white">{announcementTitle}</h4>
                        <p className="text-xs text-zinc-400 mt-0.5">{announcementMessage || "Mensaje del anuncio..."}</p>
                      </div>
                    </div>
                  </div>
                )}

                <Button
                  type="submit"
                  disabled={isBroadcasting}
                  isLoading={isBroadcasting}
                  leftIcon={<Send size={18} />}
                  className="w-full py-4 bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20"
                >
                  {isBroadcasting ? "Transmitiendo a todos los usuarios..." : "Emitir Notificación Global 📢"}
                </Button>
              </form>
            </Card>
          </div>
        )}

        {/* TAB 4: PROMPT MAESTRO PARA IA (GEMINI / CHATGPT) */}
        {activeTab === "ai_prompt" && (
          <div className="max-w-4xl mx-auto space-y-6">
            <Card className="p-8 glass-panel border-l-4 border-l-accent space-y-6 shadow-2xl">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <Sparkles className="text-accent" size={28} />
                  <div>
                    <h2 className="text-2xl font-bold text-white">Prompt Maestro para Crear Contenido con IA</h2>
                    <p className="text-sm text-zinc-400">Copia este prompt, pégalo en Gemini o ChatGPT y genera nuevos cursos en 1 segundo.</p>
                  </div>
                </div>

                <Button onClick={copyPromptToClipboard} leftIcon={copiedPrompt ? <Check size={18} /> : <Copy size={18} />}>
                  {copiedPrompt ? "¡Copiado!" : "Copiar Prompt"}
                </Button>
              </div>

              <div className="bg-black/70 p-6 rounded-xl border border-white/10 font-mono text-sm text-emerald-300 leading-relaxed overflow-x-auto whitespace-pre-wrap max-h-[500px]">
                {aiPromptText}
              </div>
            </Card>
          </div>
        )}
        </>
        )}

      </div>
    </div>
  );
}
