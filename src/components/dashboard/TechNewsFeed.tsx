"use client";

import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { 
  Newspaper, 
  ExternalLink, 
  Clock, 
  Sparkles, 
  Tag, 
  RefreshCw, 
  Flame, 
  Bot, 
  Terminal, 
  Globe, 
  ArrowUpRight 
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

interface Article {
  id: number | string;
  title: string;
  description: string;
  url: string;
  cover_image: string | null;
  reading_time_minutes: number;
  published_at: string;
  tag_list: string[];
  user: {
    name: string;
    profile_image: string | null;
  };
  source: string;
}

const CATEGORIES = [
  { id: "all", label: "🔥 Destacadas", tag: "programming", icon: Flame },
  { id: "ai", label: "🤖 Inteligencia Artificial", tag: "ai", icon: Bot },
  { id: "python", label: "🐍 Python & Backend", tag: "python", icon: Terminal },
  { id: "webdev", label: "🌐 Frontend & Web", tag: "webdev", icon: Globe },
];

export function TechNewsFeed() {
  const [activeCategory, setActiveCategory] = useState("all");
  const [articles, setArticles] = useState<Article[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const fetchNews = async (tag: string) => {
    try {
      setLoading(true);
      const res = await fetch(`/api/news?tag=${tag}`);
      const data = await res.json();
      if (data.articles) {
        setArticles(data.articles);
      }
    } catch (err) {
      console.error("Error cargando noticias:", err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    const selected = CATEGORIES.find((c) => c.id === activeCategory);
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchNews(selected ? selected.tag : "programming");
  }, [activeCategory]);

  const handleRefresh = () => {
    setRefreshing(true);
    const selected = CATEGORIES.find((c) => c.id === activeCategory);
    fetchNews(selected ? selected.tag : "programming");
  };

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-blue-900/30 via-purple-900/20 to-zinc-900 border border-blue-500/20 rounded-3xl p-6 lg:p-8 relative overflow-hidden shadow-2xl">
        <div className="absolute right-[-20px] top-[-20px] w-64 h-64 bg-blue-500/10 blur-[80px] rounded-full pointer-events-none" />
        
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 relative z-10">
          <div>
            <div className="flex items-center gap-2 text-blue-400 text-xs font-bold uppercase tracking-wider mb-2">
              <Sparkles size={16} />
              <span>Pulso Tecnológico en Vivo</span>
            </div>
            <h2 className="text-2xl lg:text-3xl font-heading font-bold text-white mb-2">
              Noticias & Tendencias del Mundo Tech 📰
            </h2>
            <p className="text-zinc-400 text-sm max-w-2xl">
              Mantente al día con los últimos avances en Inteligencia Artificial, arquitectura backend y desarrollo de software seleccionados en tiempo real.
            </p>
          </div>

          <button
            onClick={handleRefresh}
            disabled={loading || refreshing}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 text-zinc-300 hover:text-white text-sm font-medium transition-all self-start md:self-auto shrink-0 disabled:opacity-50"
          >
            <RefreshCw size={16} className={refreshing || loading ? "animate-spin text-primary" : ""} />
            <span>Actualizar Noticias</span>
          </button>
        </div>

        {/* Category Pills */}
        <div className="flex items-center gap-2 overflow-x-auto pt-6 custom-scrollbar pb-1">
          {CATEGORIES.map((cat) => {
            const Icon = cat.icon;
            const isSelected = activeCategory === cat.id;
            return (
              <button
                key={cat.id}
                onClick={() => setActiveCategory(cat.id)}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-all ${
                  isSelected
                    ? "bg-primary text-white shadow-[0_0_15px_rgba(139,92,246,0.4)] border border-primary/50"
                    : "bg-black/40 text-zinc-400 hover:text-white hover:bg-white/5 border border-white/5"
                }`}
              >
                <Icon size={14} />
                <span>{cat.label}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* News Grid */}
      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5, 6].map((n) => (
            <div key={n} className="h-64 rounded-2xl bg-white/5 border border-white/5 animate-pulse p-6 flex flex-col justify-between">
              <div className="space-y-3">
                <div className="w-20 h-4 bg-white/10 rounded-full"></div>
                <div className="w-full h-6 bg-white/10 rounded-lg"></div>
                <div className="w-3/4 h-4 bg-white/10 rounded-lg"></div>
              </div>
              <div className="w-24 h-4 bg-white/10 rounded-full"></div>
            </div>
          ))}
        </div>
      ) : articles.length === 0 ? (
        <Card className="p-12 text-center text-zinc-400">
          <Newspaper size={48} className="mx-auto mb-4 text-zinc-600" />
          <p className="font-semibold text-lg text-white mb-1">No se encontraron artículos en esta categoría</p>
          <p className="text-sm">Prueba seleccionando otra categoría o actualizando el feed.</p>
        </Card>
      ) : (
        <motion.div 
          layout
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
        >
          <AnimatePresence>
            {articles.map((art, index) => (
              <motion.a
                key={art.id}
                href={art.url}
                target="_blank"
                rel="noopener noreferrer"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3, delay: index * 0.05 }}
                className="group block h-full"
              >
                <Card className="h-full p-6 glass hover:border-primary/50 transition-all duration-300 flex flex-col justify-between group-hover:-translate-y-1 relative overflow-hidden group-hover:shadow-[0_10px_30px_rgba(139,92,246,0.15)]">
                  {/* Subtle top indicator */}
                  <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-primary/40 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />

                  <div>
                    {/* Tags & Time */}
                    <div className="flex items-center justify-between gap-2 mb-3">
                      <div className="flex items-center gap-1.5 flex-wrap">
                        {art.tag_list.slice(0, 2).map((tag, i) => (
                          <span
                            key={i}
                            className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-white/5 text-purple-300 border border-purple-500/20"
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>
                      <div className="flex items-center gap-1 text-zinc-500 text-[11px] shrink-0">
                        <Clock size={12} />
                        <span>{art.reading_time_minutes} min</span>
                      </div>
                    </div>

                    {/* Title */}
                    <h3 className="font-heading font-bold text-base lg:text-lg text-white mb-2 line-clamp-2 group-hover:text-primary transition-colors flex items-start justify-between gap-2">
                      <span>{art.title}</span>
                      <ArrowUpRight size={18} className="text-zinc-500 group-hover:text-primary transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5 shrink-0 mt-0.5" />
                    </h3>

                    {/* Description */}
                    <p className="text-xs text-zinc-400 line-clamp-3 leading-relaxed mb-4">
                      {art.description}
                    </p>
                  </div>

                  {/* Author & Source Footer */}
                  <div className="pt-4 border-t border-white/5 flex items-center justify-between text-xs text-zinc-400">
                    <div className="flex items-center gap-2">
                      {art.user?.profile_image ? (
                        <img 
                          src={art.user.profile_image} 
                          alt={art.user.name} 
                          className="w-5 h-5 rounded-full object-cover border border-white/10" 
                        />
                      ) : (
                        <div className="w-5 h-5 rounded-full bg-primary/20 flex items-center justify-center text-[10px] font-bold text-primary">
                          {art.user?.name?.charAt(0) || "T"}
                        </div>
                      )}
                      <span className="font-medium text-zinc-300 line-clamp-1">{art.user?.name}</span>
                    </div>

                    <span className="text-[10px] text-zinc-500 font-mono flex items-center gap-1">
                      <span>Leer artículo</span>
                      <ExternalLink size={10} />
                    </span>
                  </div>
                </Card>
              </motion.a>
            ))}
          </AnimatePresence>
        </motion.div>
      )}
    </div>
  );
}
