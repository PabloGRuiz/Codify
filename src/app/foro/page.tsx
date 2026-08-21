"use client";

import { useState, useEffect } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { 
  Search, 
  MessageSquare, 
  Plus, 
  MessageCircle, 
  User, 
  Star,
  Clock,
  ChevronRight,
  ShieldCheck
} from "lucide-react";
import { useSidebar } from "@/context/SidebarContext";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";
import Link from "next/link";
import { formatTimeAgo } from "@/lib/formatTime";
import { NuevoHiloModal } from "./NuevoHiloModal";

interface Thread {
  id: string;
  title: string;
  content: string;
  created_at: string;
  tags: string[];
  author_id?: string;
  author?: {
    id: string;
    username: string;
    avatar_url?: string;
    reputation_stars?: number;
    role?: string;
  };
  posts_count: number;
}

export default function ForoPage() {
  const { isCollapsed } = useSidebar();
  const { user } = useUser();
  const [threads, setThreads] = useState<Thread[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const fetchThreads = async (search = "") => {
    setLoading(true);
    try {
      let query = supabase
        .from("forum_threads")
        .select(`
          id, title, content, created_at, tags, author_id,
          author:profiles(id, username, avatar_url, reputation_stars, role),
          posts:forum_posts(count)
        `)
        .order("created_at", { ascending: false });

      if (search) {
        // Using PostgreSQL Full-Text Search via Supabase's textSearch
        query = query.textSearch("search_vector", search, {
          config: "spanish",
          type: "websearch"
        });
      }

      const { data, error } = await query.limit(20);

      if (error) throw error;

      const formattedThreads = (data || []).map((t: any) => {
        const authorObj = Array.isArray(t.author) ? t.author[0] : t.author;
        return {
          ...t,
          posts_count: t.posts ? (t.posts[0]?.count || 0) : 0,
          author: authorObj || {
            id: t.author_id || "",
            username: "Coder",
            avatar_url: "",
            reputation_stars: 0,
            role: "student"
          }
        };
      });

      setThreads(formattedThreads);
    } catch (err) {
      console.error("Error fetching threads:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // Debounce search
    const delayDebounceFn = setTimeout(() => {
      fetchThreads(searchTerm);
    }, 500);

    return () => clearTimeout(delayDebounceFn);
  }, [searchTerm]);

  const handleThreadCreated = () => {
    fetchThreads(searchTerm); // Refresh list
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        {/* Background ambient lighting */}
        <div className="absolute top-[10%] left-[-10%] w-[50%] h-[50%] rounded-full bg-blue-600/10 blur-[150px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative">
          
          <div className="max-w-5xl mx-auto space-y-6 lg:space-y-8">
            {/* Header & Search */}
            <div className="bg-gradient-to-r from-blue-900/30 to-purple-900/20 border border-blue-500/20 rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                <div>
                  <h1 className="text-3xl lg:text-4xl font-heading font-bold text-white mb-2 flex items-center gap-3">
                    <MessageSquare className="text-blue-400" /> Foro Comunitario
                  </h1>
                  <p className="text-zinc-400 font-sans text-sm lg:text-base max-w-xl">
                    Pregunta, debate y ayuda a otros desarrolladores. Las mejores respuestas te otorgan estrellas de reputación ⭐.
                  </p>
                </div>
                <Button 
                  onClick={() => setIsModalOpen(true)}
                  className="bg-blue-600 hover:bg-blue-500 text-white font-bold px-6 py-6 rounded-xl shadow-[0_0_20px_rgba(37,99,235,0.3)] shrink-0"
                >
                  <Plus size={20} className="mr-2" /> Nueva Consulta
                </Button>
              </div>

              {/* Search Bar */}
              <div className="mt-8 relative z-10">
                <div className="relative max-w-2xl">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <Search className="h-5 w-5 text-zinc-500" />
                  </div>
                  <input
                    type="text"
                    placeholder="Busca consultas por palabras clave, errores o temas..."
                    className="w-full bg-black/40 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder-zinc-500 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all shadow-inner"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                </div>
              </div>
            </div>

            {/* Thread List */}
            <div className="space-y-4">
              {loading ? (
                // Skeleton loading
                [1, 2, 3, 4].map((n) => (
                  <Card key={n} className="p-6 glass animate-pulse border-white/5">
                    <div className="h-6 w-3/4 bg-white/10 rounded-lg mb-3" />
                    <div className="h-4 w-full bg-white/5 rounded-lg mb-4" />
                    <div className="flex gap-4">
                      <div className="h-8 w-24 bg-white/10 rounded-full" />
                      <div className="h-8 w-24 bg-white/10 rounded-full" />
                    </div>
                  </Card>
                ))
              ) : threads.length === 0 ? (
                <div className="text-center py-16 bg-black/20 rounded-3xl border border-white/5">
                  <MessageCircle size={48} className="mx-auto text-zinc-600 mb-4" />
                  <h3 className="text-xl font-bold text-white mb-2">No se encontraron hilos</h3>
                  <p className="text-zinc-400">Intenta buscar con otras palabras o sé el primero en preguntar.</p>
                </div>
              ) : (
                threads.map((thread) => (
                  <Card key={thread.id} className="p-5 sm:p-6 glass hover:border-blue-500/40 hover:bg-white/[0.03] transition-all group mb-4 relative">
                    <div className="flex flex-col sm:flex-row gap-4 sm:gap-6">
                      {/* Stats left column */}
                      <div className="flex sm:flex-col items-center sm:items-end justify-start gap-4 sm:gap-2 shrink-0 sm:w-24">
                        <div className={`flex flex-col items-center justify-center p-2 rounded-xl border ${thread.posts_count > 0 ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-400" : "border-white/10 bg-black/40 text-zinc-400"} min-w-[60px]`}>
                          <span className="text-lg font-bold font-mono leading-none">{thread.posts_count}</span>
                          <span className="text-[10px] uppercase font-bold mt-1">Resp.</span>
                        </div>
                      </div>

                      {/* Content column */}
                      <div className="flex-1 min-w-0">
                        <Link href={`/foro/${thread.id}`} className="block group">
                          <h2 className="text-lg sm:text-xl font-heading font-bold text-blue-100 group-hover:text-blue-400 transition-colors mb-1 truncate">
                            {thread.title}
                          </h2>
                          <p className="text-sm text-zinc-400 line-clamp-2 mb-3">
                            {thread.content.length > 150 ? `${thread.content.substring(0, 150)}...` : thread.content}
                          </p>
                        </Link>

                        {/* Tags & Meta footer */}
                        <div className="flex flex-wrap items-center justify-between gap-4 text-xs mt-4">
                          <div className="flex items-center gap-2">
                            {thread.tags && thread.tags.length > 0 && thread.tags.map((tag, i) => (
                              <span key={i} className="px-2 py-1 bg-blue-500/10 border border-blue-500/20 text-blue-300 rounded-md font-mono">
                                #{tag}
                              </span>
                            ))}
                          </div>

                          <div className="flex items-center gap-4 text-zinc-500 shrink-0">
                            <span className="flex items-center gap-1">
                              <Clock size={12} /> {formatTimeAgo(thread.created_at)}
                            </span>
                            
                            <Link 
                              href={thread.author?.id ? `/profile/${thread.author.id}` : "#"}
                              className="flex items-center gap-2 hover:opacity-80 transition-opacity z-10 relative group/author"
                            >
                              {thread.author?.avatar_url ? (
                                <img src={thread.author.avatar_url} alt="avatar" className="w-5 h-5 rounded-full object-cover" />
                              ) : (
                                <div className="w-5 h-5 rounded-full bg-zinc-800 flex items-center justify-center"><User size={10} /></div>
                              )}
                              <div className="flex flex-col">
                                <div className="flex items-center gap-1.5">
                                  <span className="font-medium text-zinc-300 group-hover/author:text-blue-400 transition-colors">{thread.author?.username || "Usuario"}</span>
                                  {(thread.author?.role === 'admin' || thread.author?.role === 'profesor') && (
                                    <span className="text-indigo-400" title={thread.author.role === 'admin' ? 'Administrador' : 'Profesor'}>
                                      <ShieldCheck size={14} />
                                    </span>
                                  )}
                                </div>
                                <span className="text-yellow-500 font-bold flex items-center bg-yellow-500/10 px-1 rounded-sm w-fit mt-0.5"><Star size={10} className="fill-yellow-500 mr-0.5" />{thread.author?.reputation_stars || 0}</span>
                              </div>
                            </Link>
                          </div>
                        </div>
                      </div>
                    </div>
                  </Card>
                ))
              )}
            </div>
          </div>
        </main>
      </div>

      <NuevoHiloModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSuccess={handleThreadCreated}
      />
    </div>
  );
}
