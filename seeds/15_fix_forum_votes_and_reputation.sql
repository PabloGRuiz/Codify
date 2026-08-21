-- ==============================================================================
-- 🚀 CODIFY SEED: 15 - FIX FORO VOTES, REPUTACIÓN Y TRIGGERS SECURITY DEFINER
-- ==============================================================================
-- Este script soluciona el problema de que los likes no incrementaban la reputación
-- ni guardaban los upvotes en Supabase debido a permisos de RLS en los triggers.
-- Al usar SECURITY DEFINER, el trigger se ejecuta con permisos de sistema para
-- actualizar los contadores de la respuesta y la reputación del autor correspondiente.
-- ==============================================================================

-- 1. Asegurar columna reputation_stars en profiles
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='reputation_stars') THEN
    ALTER TABLE public.profiles ADD COLUMN reputation_stars INTEGER DEFAULT 0;
  END IF;
END $$;

-- 2. Asegurar columnas upvotes y downvotes en forum_posts
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='forum_posts' AND column_name='upvotes') THEN
    ALTER TABLE public.forum_posts ADD COLUMN upvotes INTEGER DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='forum_posts' AND column_name='downvotes') THEN
    ALTER TABLE public.forum_posts ADD COLUMN downvotes INTEGER DEFAULT 0;
  END IF;
END $$;

-- 3. Trigger Function con SECURITY DEFINER para actualizar votos y reputación
CREATE OR REPLACE FUNCTION public.process_forum_vote() 
RETURNS trigger 
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  post_author UUID;
BEGIN
  -- Obtener el autor del post votado
  SELECT author_id INTO post_author 
  FROM public.forum_posts 
  WHERE id = COALESCE(NEW.post_id, OLD.post_id);

  IF TG_OP = 'INSERT' THEN
    IF NEW.vote_type = 1 THEN
      UPDATE public.forum_posts SET upvotes = COALESCE(upvotes, 0) + 1 WHERE id = NEW.post_id;
      IF post_author IS NOT NULL THEN
        UPDATE public.profiles SET reputation_stars = COALESCE(reputation_stars, 0) + 1 WHERE id = post_author;
      END IF;
    ELSE
      UPDATE public.forum_posts SET downvotes = COALESCE(downvotes, 0) + 1 WHERE id = NEW.post_id;
      IF post_author IS NOT NULL THEN
        UPDATE public.profiles SET reputation_stars = GREATEST(0, COALESCE(reputation_stars, 0) - 1) WHERE id = post_author;
      END IF;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.vote_type = 1 THEN
      UPDATE public.forum_posts SET upvotes = GREATEST(0, COALESCE(upvotes, 0) - 1) WHERE id = OLD.post_id;
      IF post_author IS NOT NULL THEN
        UPDATE public.profiles SET reputation_stars = GREATEST(0, COALESCE(reputation_stars, 0) - 1) WHERE id = post_author;
      END IF;
    ELSE
      UPDATE public.forum_posts SET downvotes = GREATEST(0, COALESCE(downvotes, 0) - 1) WHERE id = OLD.post_id;
      IF post_author IS NOT NULL THEN
        UPDATE public.profiles SET reputation_stars = COALESCE(reputation_stars, 0) + 1 WHERE id = post_author;
      END IF;
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Cambió su voto (ej. de -1 a 1 o viceversa)
    IF OLD.vote_type != NEW.vote_type THEN
      IF NEW.vote_type = 1 THEN
        UPDATE public.forum_posts 
        SET upvotes = COALESCE(upvotes, 0) + 1, 
            downvotes = GREATEST(0, COALESCE(downvotes, 0) - 1) 
        WHERE id = NEW.post_id;
        
        IF post_author IS NOT NULL THEN
          UPDATE public.profiles SET reputation_stars = COALESCE(reputation_stars, 0) + 2 WHERE id = post_author;
        END IF;
      ELSE
        UPDATE public.forum_posts 
        SET upvotes = GREATEST(0, COALESCE(upvotes, 0) - 1), 
            downvotes = COALESCE(downvotes, 0) + 1 
        WHERE id = NEW.post_id;
        
        IF post_author IS NOT NULL THEN
          UPDATE public.profiles SET reputation_stars = GREATEST(0, COALESCE(reputation_stars, 0) - 2) WHERE id = post_author;
        END IF;
      END IF;
    END IF;
  END IF;

  RETURN NULL; -- AFTER trigger
END;
$$;

-- 4. Recrear el trigger en forum_votes
DROP TRIGGER IF EXISTS process_forum_vote_trigger ON public.forum_votes;
CREATE TRIGGER process_forum_vote_trigger 
AFTER INSERT OR UPDATE OR DELETE ON public.forum_votes
FOR EACH ROW EXECUTE FUNCTION public.process_forum_vote();

-- 5. Asegurar políticas RLS para forum_votes y perfiles
ALTER TABLE public.forum_votes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Votos visibles para todos" ON public.forum_votes;
CREATE POLICY "Votos visibles para todos" ON public.forum_votes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Autenticados pueden votar" ON public.forum_votes;
CREATE POLICY "Autenticados pueden votar" ON public.forum_votes FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Autenticados pueden cambiar su voto" ON public.forum_votes;
CREATE POLICY "Autenticados pueden cambiar su voto" ON public.forum_votes FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Autenticados pueden quitar su voto" ON public.forum_votes;
CREATE POLICY "Autenticados pueden quitar su voto" ON public.forum_votes FOR DELETE USING (auth.uid() = user_id);

-- 6. Recalcular la reputación actual de los usuarios en base a los votos existentes para sincronizar
UPDATE public.profiles p
SET reputation_stars = COALESCE((
  SELECT COUNT(*) 
  FROM public.forum_votes v
  JOIN public.forum_posts post ON post.id = v.post_id
  WHERE post.author_id = p.id AND v.vote_type = 1
), 0) - COALESCE((
  SELECT COUNT(*) 
  FROM public.forum_votes v
  JOIN public.forum_posts post ON post.id = v.post_id
  WHERE post.author_id = p.id AND v.vote_type = -1
), 0);

UPDATE public.profiles SET reputation_stars = 0 WHERE reputation_stars < 0;
