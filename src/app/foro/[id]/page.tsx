"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { useSidebar } from "@/context/SidebarContext";
import { useUser } from "@/hooks/useUser";
import { supabase } from "@/lib/supabase";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { 
  ArrowLeft, 
  MessageSquare, 
  User, 
  Star, 
  Clock, 
  Send,
  ThumbsUp,
  ThumbsDown,
  CheckCircle2,
  MoreVertical
} from "lucide-react";
import { formatDistanceToNow } from "date-fns";
import { es } from "date-fns/locale";
import Link from "next/link";
import { ShieldCheck } from "lucide-react";

interface Thread {
  id: string;
  title: string;
  content: string;
  created_at: string;
  tags: string[];
  author?: {
    id: string;
    username: string;
    avatar_url?: string;
    reputation_stars?: number;
    role?: string;
  };
}

interface Post {
  id: string;
  content: string;
  created_at: string;
  author?: {
    id: string;
    username: string;
    avatar_url?: string;
    reputation_stars?: number;
    role?: string;
  };
  upvotes: number;
  downvotes: number;
  is_solution: boolean;
  user_vote?: number; // 1 (up), -1 (down), or undefined
}

export default function ThreadDetailPage() {
  const { id } = useParams();
  const router = useRouter();
  const { isCollapsed } = useSidebar();
  const { user } = useUser();
  
  const [thread, setThread] = useState<Thread | null>(null);
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState(true);
  const [newPostContent, setNewPostContent] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (id) {
      fetchThreadAndPosts();
    }
  }, [id, user]);

  const fetchThreadAndPosts = async () => {
    setLoading(true);
    try {
      // 1. Fetch thread
      const { data: threadData, error: threadError } = await supabase
        .from("forum_threads")
        .select(`
          id, title, content, created_at, tags, author_id,
          author:profiles(id, username, avatar_url, reputation_stars, role)
        `)
        .eq("id", id)
        .single();

      if (threadError) throw threadError;
      
      const threadAuthor = Array.isArray(threadData.author) ? threadData.author[0] : threadData.author;
      setThread({
        ...threadData,
        author: threadAuthor || {
          id: threadData.author_id || "",
          username: "Coder",
          avatar_url: "",
          reputation_stars: 0,
          role: "student"
        }
      });

      // 2. Fetch posts
      const { data: postsData, error: postsError } = await supabase
        .from("forum_posts")
        .select(`
          id, content, created_at, upvotes, downvotes, is_solution, author_id,
          author:profiles(id, username, avatar_url, reputation_stars, role)
        `)
        .eq("thread_id", id)
        .order("is_solution", { ascending: false })
        .order("upvotes", { ascending: false })
        .order("created_at", { ascending: true });

      if (postsError) throw postsError;

      let formattedPosts: Post[] = (postsData || []).map((p: any) => {
        const authorObj = Array.isArray(p.author) ? p.author[0] : p.author;
        return {
          id: p.id,
          content: p.content,
          created_at: p.created_at,
          upvotes: p.upvotes || 0,
          downvotes: p.downvotes || 0,
          is_solution: Boolean(p.is_solution),
          author: authorObj || {
            id: p.author_id || "",
            username: "Coder",
            avatar_url: "",
            reputation_stars: 0,
            role: "student"
          }
        };
      });

      // 3. Fetch user votes if logged in
      if (user && formattedPosts.length > 0) {
        const postIds = formattedPosts.map(p => p.id);
        const { data: votesData } = await supabase
          .from("forum_votes")
          .select("post_id, vote_type")
          .in("post_id", postIds)
          .eq("user_id", user.id);

        if (votesData) {
          const voteMap = new Map(votesData.map(v => [v.post_id, v.vote_type]));
          formattedPosts = formattedPosts.map(p => ({
            ...p,
            user_vote: voteMap.get(p.id)
          }));
        }
      }

      setPosts(formattedPosts);
    } catch (err) {
      console.error("Error fetching thread details:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreatePost = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !newPostContent.trim()) return;

    setIsSubmitting(true);
    try {
      const { error } = await supabase.from("forum_posts").insert({
        thread_id: id,
        content: newPostContent.trim(),
        author_id: user.id
      });

      if (error) throw error;
      setNewPostContent("");
      await fetchThreadAndPosts();
    } catch (err) {
      console.error("Error creating post:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleVote = async (postId: string, voteType: 1 | -1, currentVote?: number, authorId?: string) => {
    if (!user) return alert("Debes iniciar sesión para votar.");
    if (authorId && user.id === authorId) return alert("No puedes votar tus propias respuestas.");

    try {
      // Optimistic UI update
      setPosts(currentPosts => currentPosts.map(p => {
        if (p.id === postId) {
          let newUpvotes = p.upvotes || 0;
          let newDownvotes = p.downvotes || 0;
          let newUserVote: number | undefined = voteType;

          if (currentVote === 1) newUpvotes--;
          if (currentVote === -1) newDownvotes--;

          if (currentVote === voteType) {
            newUserVote = undefined;
          } else {
            if (voteType === 1) newUpvotes++;
            if (voteType === -1) newDownvotes++;
          }

          return { ...p, upvotes: Math.max(0, newUpvotes), downvotes: Math.max(0, newDownvotes), user_vote: newUserVote };
        }
        return p;
      }));

      if (currentVote === voteType) {
        await supabase.from("forum_votes").delete().match({ post_id: postId, user_id: user.id });
      } else if (currentVote) {
        await supabase.from("forum_votes").update({ vote_type: voteType }).match({ post_id: postId, user_id: user.id });
      } else {
        await supabase.from("forum_votes").insert({ post_id: postId, user_id: user.id, vote_type: voteType });
      }
    } catch (err) {
      console.error("Error voting:", err);
      fetchThreadAndPosts();
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex">
        <Sidebar />
        <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen`}>
          <Topbar />
          <div className="flex-1 p-8 flex items-center justify-center">
            <div className="w-8 h-8 rounded-full border-4 border-blue-500 border-t-transparent animate-spin"></div>
          </div>
        </div>
      </div>
    );
  }

  if (!thread) {
    return (
      <div className="min-h-screen bg-background flex">
        <Sidebar />
        <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen`}>
          <Topbar />
          <div className="flex-1 p-8 text-center pt-24">
            <h1 className="text-2xl text-white font-bold">Consulta no encontrada</h1>
            <Button onClick={() => router.push("/foro")} className="mt-4">Volver al Foro</Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        <div className="absolute top-[5%] right-[-10%] w-[40%] h-[40%] rounded-full bg-blue-600/10 blur-[150px] pointer-events-none" />
        
        <Topbar />
        
        <main className="flex-1 p-4 lg:p-8 overflow-y-auto z-10 relative">
          <div className="max-w-4xl mx-auto">
            
            {/* Header / Back */}
            <div className="mb-6">
              <Link href="/foro" className="inline-flex items-center text-sm font-medium text-zinc-400 hover:text-blue-400 transition-colors">
                <ArrowLeft size={16} className="mr-2" /> Volver al foro
              </Link>
            </div>

            {/* Original Thread Question */}
            <Card className="p-6 md:p-8 mb-8 border-blue-500/20 bg-blue-900/10 shadow-lg relative overflow-hidden">
              <div className="absolute top-0 left-0 w-1 h-full bg-blue-500" />
              
              <h1 className="text-2xl md:text-3xl font-heading font-bold text-white mb-4">
                {thread.title}
              </h1>

              {/* Thread Meta */}
              <div className="flex flex-wrap items-center gap-4 text-sm text-zinc-400 mb-6 pb-6 border-b border-white/10">
                <div className="flex items-center gap-2">
                  {thread.author?.avatar_url ? (
                    <img src={thread.author.avatar_url} alt="avatar" className="w-6 h-6 rounded-full object-cover" />
                  ) : (
                    <div className="w-6 h-6 rounded-full bg-zinc-800 flex items-center justify-center"><User size={12} /></div>
                  )}
                  <div className="flex flex-col">
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-zinc-200">{thread.author?.username || "Usuario"}</span>
                      {(thread.author?.role === 'admin' || thread.author?.role === 'profesor') && (
                        <span className="flex items-center gap-1 text-[10px] uppercase px-1.5 py-0.5 bg-indigo-500/20 text-indigo-300 rounded border border-indigo-500/30 font-bold" title="Staff">
                          <ShieldCheck size={12} />
                          {thread.author.role === 'admin' ? 'Admin' : 'Profesor'}
                        </span>
                      )}
                    </div>
                    <span className="text-yellow-500 font-bold flex items-center text-xs mt-0.5">
                      <Star size={12} className="fill-yellow-500 mr-1" />{thread.author?.reputation_stars || 0}
                    </span>
                  </div>
                </div>
                <span className="flex items-center gap-1">
                  <Clock size={14} /> {formatDistanceToNow(new Date(thread.created_at), { addSuffix: true, locale: es })}
                </span>
                
                <div className="flex items-center gap-2 ml-auto">
                  {thread.tags && thread.tags.map((tag, i) => (
                    <span key={i} className="px-2 py-1 bg-blue-500/20 text-blue-300 rounded-md font-mono text-xs">#{tag}</span>
                  ))}
                </div>
              </div>

              <div className="prose prose-invert max-w-none font-mono text-sm leading-relaxed whitespace-pre-wrap text-zinc-300">
                {thread.content}
              </div>
            </Card>

            {/* Answers Section */}
            <h3 className="text-xl font-heading font-bold text-white mb-6 flex items-center gap-2">
              <MessageSquare size={20} className="text-blue-400" /> 
              {posts.length} {posts.length === 1 ? 'Respuesta' : 'Respuestas'}
            </h3>

            <div className="space-y-6 mb-12">
              {posts.map((post) => {
                const totalScore = (post.upvotes || 0) - (post.downvotes || 0);
                const isAuthor = Boolean(user?.id && post.author?.id && user.id === post.author.id);
                const isThreadAuthor = Boolean(post.author?.id && thread.author?.id && post.author.id === thread.author.id);
                
                return (
                  <Card key={post.id} className={`p-4 md:p-6 flex flex-col md:flex-row gap-4 md:gap-6 ${post.is_solution ? 'border-emerald-500/40 bg-emerald-900/5' : 'border-white/5'}`}>
                    
                    {/* Voting Column */}
                    <div className="flex md:flex-col items-center justify-start md:w-16 shrink-0 bg-black/20 p-2 md:p-4 rounded-xl border border-white/5 gap-2">
                      <button 
                        onClick={() => handleVote(post.id, 1, post.user_vote, post.author?.id)}
                        disabled={isAuthor}
                        className={`p-1.5 rounded-full transition-all ${post.user_vote === 1 ? 'bg-blue-500/20 text-blue-400' : isAuthor ? 'text-zinc-600' : 'text-zinc-400 hover:bg-white/10 hover:text-white'}`}
                        title={isAuthor ? "No puedes votar tu respuesta" : "Buena respuesta"}
                      >
                        <ThumbsUp size={20} className={post.user_vote === 1 ? 'fill-blue-400/20' : ''} />
                      </button>
                      
                      <span className={`text-lg font-bold font-mono ${totalScore > 0 ? 'text-emerald-400' : totalScore < 0 ? 'text-red-400' : 'text-zinc-300'}`}>
                        {totalScore > 0 ? `+${totalScore}` : totalScore}
                      </span>
                      
                      <button 
                        onClick={() => handleVote(post.id, -1, post.user_vote, post.author?.id)}
                        disabled={isAuthor}
                        className={`p-1.5 rounded-full transition-all ${post.user_vote === -1 ? 'bg-red-500/20 text-red-400' : isAuthor ? 'text-zinc-600' : 'text-zinc-400 hover:bg-white/10 hover:text-white'}`}
                        title={isAuthor ? "No puedes votar tu respuesta" : "Mala respuesta"}
                      >
                        <ThumbsDown size={20} className={post.user_vote === -1 ? 'fill-red-400/20' : ''} />
                      </button>
                      
                      {post.is_solution && (
                        <div className="mt-2 text-emerald-500" title="Solución Aceptada">
                          <CheckCircle2 size={24} className="fill-emerald-500/20" />
                        </div>
                      )}
                    </div>

                    {/* Content Column */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between mb-4 pb-4 border-b border-white/5">
                        <div className="flex items-center gap-3">
                          {post.author?.avatar_url ? (
                            <img src={post.author.avatar_url} alt="avatar" className="w-8 h-8 rounded-full object-cover" />
                          ) : (
                            <div className="w-8 h-8 rounded-full bg-zinc-800 flex items-center justify-center"><User size={14} /></div>
                          )}
                          <div>
                            <div className="flex items-center gap-2">
                              <span className="font-bold text-zinc-200">{post.author?.username || "Usuario"}</span>
                              {(post.author?.role === 'admin' || post.author?.role === 'profesor') && (
                                <span className="flex items-center gap-1 text-[10px] uppercase px-1.5 py-0.5 bg-indigo-500/20 text-indigo-300 rounded border border-indigo-500/30 font-bold" title="Staff">
                                  <ShieldCheck size={12} />
                                  {post.author.role === 'admin' ? 'Admin' : 'Profesor'}
                                </span>
                              )}
                              {isThreadAuthor && (
                                <span className="text-[10px] uppercase px-1.5 py-0.5 bg-blue-500/20 text-blue-300 rounded font-bold">Autor</span>
                              )}
                            </div>
                            <span className="text-yellow-500 text-xs font-bold flex items-center">
                              <Star size={10} className="fill-yellow-500 mr-1" />{post.author?.reputation_stars || 0} Reputación
                            </span>
                          </div>
                        </div>
                        <div className="flex items-center gap-4 text-xs text-zinc-500">
                          <span>{formatDistanceToNow(new Date(post.created_at), { addSuffix: true, locale: es })}</span>
                          <button className="text-zinc-400 hover:text-white"><MoreVertical size={16}/></button>
                        </div>
                      </div>

                      <div className="prose prose-invert max-w-none font-mono text-sm leading-relaxed whitespace-pre-wrap text-zinc-300">
                        {post.content}
                      </div>
                    </div>
                  </Card>
                );
              })}
            </div>

            {/* Add Post Form */}
            <Card className="p-6 border-white/10 bg-black/40">
              <h3 className="text-lg font-heading font-bold text-white mb-4">Tu Respuesta</h3>
              
              {!user ? (
                <div className="text-center p-6 bg-white/5 rounded-xl border border-white/10">
                  <p className="text-zinc-400 mb-4">Debes iniciar sesión para publicar una respuesta y ganar reputación.</p>
                  <Button onClick={() => router.push("/auth")} className="bg-blue-600 hover:bg-blue-500">Iniciar Sesión</Button>
                </div>
              ) : (
                <form onSubmit={handleCreatePost}>
                  <textarea
                    placeholder="Escribe tu respuesta aquí. Sé claro y educado. Las buenas respuestas te otorgarán Estrellas ⭐..."
                    className="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 h-32 resize-none font-mono text-sm mb-4"
                    value={newPostContent}
                    onChange={(e) => setNewPostContent(e.target.value)}
                    required
                  />
                  <div className="flex justify-end">
                    <Button 
                      type="submit" 
                      disabled={isSubmitting || newPostContent.trim().length < 10}
                      className="bg-blue-600 hover:bg-blue-500 text-white font-bold"
                    >
                      {isSubmitting ? "Publicando..." : "Publicar Respuesta"}
                      {!isSubmitting && <Send size={16} className="ml-2" />}
                    </Button>
                  </div>
                </form>
              )}
            </Card>

          </div>
        </main>
      </div>
    </div>
  );
}
