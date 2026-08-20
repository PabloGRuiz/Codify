-- ==============================================================================
-- 💬 CODIFY SEED: MÓDULO FORO COMUNITARIO & REPUTACIÓN
-- ==============================================================================

-- 1. Añadir columna de reputación a perfiles (si no existe)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='reputation_stars') THEN
    ALTER TABLE public.profiles ADD COLUMN reputation_stars INTEGER DEFAULT 0;
  END IF;
END $$;

-- 2. Crear tabla de hilos (Threads)
CREATE TABLE IF NOT EXISTS public.forum_threads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  tags TEXT[] DEFAULT '{}',
  search_vector TSVECTOR,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índice para búsqueda Full-Text
CREATE INDEX IF NOT EXISTS forum_threads_search_idx ON public.forum_threads USING GIN (search_vector);

-- Trigger para actualizar el search_vector automáticamente
CREATE OR REPLACE FUNCTION public.forum_threads_search_trigger() RETURNS trigger AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('spanish', coalesce(NEW.title, '')), 'A') ||
    setweight(to_tsvector('spanish', coalesce(NEW.content, '')), 'B');
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tsvectorupdate ON public.forum_threads;
CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.forum_threads
FOR EACH ROW EXECUTE FUNCTION public.forum_threads_search_trigger();

-- 3. Crear tabla de respuestas (Posts)
CREATE TABLE IF NOT EXISTS public.forum_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES public.forum_threads(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  upvotes INTEGER DEFAULT 0,
  downvotes INTEGER DEFAULT 0,
  is_solution BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Crear tabla de votos (Votes)
CREATE TABLE IF NOT EXISTS public.forum_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES public.forum_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  vote_type INTEGER NOT NULL CHECK (vote_type = 1 OR vote_type = -1),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(post_id, user_id) -- Un usuario solo puede votar una vez por respuesta
);

-- Constraint: el autor no puede votar su propia respuesta
CREATE OR REPLACE FUNCTION public.check_vote_author() RETURNS trigger AS $$
DECLARE
  post_author UUID;
BEGIN
  SELECT author_id INTO post_author FROM public.forum_posts WHERE id = NEW.post_id;
  IF post_author = NEW.user_id THEN
    RAISE EXCEPTION 'No puedes votar tu propia respuesta.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_vote_author_trigger ON public.forum_votes;
CREATE TRIGGER check_vote_author_trigger BEFORE INSERT ON public.forum_votes
FOR EACH ROW EXECUTE FUNCTION public.check_vote_author();

-- 5. Trigger para actualizar contadores (Upvotes/Downvotes y Reputación)
CREATE OR REPLACE FUNCTION public.process_forum_vote() RETURNS trigger AS $$
DECLARE
  post_author UUID;
BEGIN
  -- Obtener el autor del post
  SELECT author_id INTO post_author FROM public.forum_posts WHERE id = COALESCE(NEW.post_id, OLD.post_id);

  IF TG_OP = 'INSERT' THEN
    IF NEW.vote_type = 1 THEN
      UPDATE public.forum_posts SET upvotes = upvotes + 1 WHERE id = NEW.post_id;
      UPDATE public.profiles SET reputation_stars = reputation_stars + 1 WHERE id = post_author;
    ELSE
      UPDATE public.forum_posts SET downvotes = downvotes + 1 WHERE id = NEW.post_id;
      UPDATE public.profiles SET reputation_stars = reputation_stars - 1 WHERE id = post_author;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.vote_type = 1 THEN
      UPDATE public.forum_posts SET upvotes = upvotes - 1 WHERE id = OLD.post_id;
      UPDATE public.profiles SET reputation_stars = reputation_stars - 1 WHERE id = post_author;
    ELSE
      UPDATE public.forum_posts SET downvotes = downvotes - 1 WHERE id = OLD.post_id;
      UPDATE public.profiles SET reputation_stars = reputation_stars + 1 WHERE id = post_author;
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Cambió su voto (ej. de -1 a 1)
    IF OLD.vote_type != NEW.vote_type THEN
      IF NEW.vote_type = 1 THEN
        UPDATE public.forum_posts SET upvotes = upvotes + 1, downvotes = downvotes - 1 WHERE id = NEW.post_id;
        UPDATE public.profiles SET reputation_stars = reputation_stars + 2 WHERE id = post_author;
      ELSE
        UPDATE public.forum_posts SET upvotes = upvotes - 1, downvotes = downvotes + 1 WHERE id = NEW.post_id;
        UPDATE public.profiles SET reputation_stars = reputation_stars - 2 WHERE id = post_author;
      END IF;
    END IF;
  END IF;

  RETURN NULL; -- AFTER trigger
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS process_forum_vote_trigger ON public.forum_votes;
CREATE TRIGGER process_forum_vote_trigger AFTER INSERT OR UPDATE OR DELETE ON public.forum_votes
FOR EACH ROW EXECUTE FUNCTION public.process_forum_vote();

-- ==============================================================================
-- POLÍTICAS RLS (Row Level Security)
-- ==============================================================================

-- Desactivar políticas anteriores si existen y activar RLS
ALTER TABLE public.forum_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.forum_votes ENABLE ROW LEVEL SECURITY;

-- Threads
DROP POLICY IF EXISTS "Hilos visibles para todos" ON public.forum_threads;
CREATE POLICY "Hilos visibles para todos" ON public.forum_threads FOR SELECT USING (true);

DROP POLICY IF EXISTS "Autenticados pueden crear hilos" ON public.forum_threads;
CREATE POLICY "Autenticados pueden crear hilos" ON public.forum_threads FOR INSERT WITH CHECK (auth.uid() = author_id);

-- Posts
DROP POLICY IF EXISTS "Posts visibles para todos" ON public.forum_posts;
CREATE POLICY "Posts visibles para todos" ON public.forum_posts FOR SELECT USING (true);

DROP POLICY IF EXISTS "Autenticados pueden crear posts" ON public.forum_posts;
CREATE POLICY "Autenticados pueden crear posts" ON public.forum_posts FOR INSERT WITH CHECK (auth.uid() = author_id);

-- Votes
DROP POLICY IF EXISTS "Votos visibles para todos" ON public.forum_votes;
CREATE POLICY "Votos visibles para todos" ON public.forum_votes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Autenticados pueden votar" ON public.forum_votes;
CREATE POLICY "Autenticados pueden votar" ON public.forum_votes FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Autenticados pueden cambiar su voto" ON public.forum_votes;
CREATE POLICY "Autenticados pueden cambiar su voto" ON public.forum_votes FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Autenticados pueden quitar su voto" ON public.forum_votes;
CREATE POLICY "Autenticados pueden quitar su voto" ON public.forum_votes FOR DELETE USING (auth.uid() = user_id);
