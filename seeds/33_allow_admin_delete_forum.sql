-- ==============================================================================
-- 🛡️ SGFC SEED: 33 - HABILITAR ELIMINACIÓN DE PUBLICACIONES EN EL FORO (RLS)
-- ==============================================================================
-- Permite a los Administradores (y a los autores de la publicación) eliminar hilos
-- y respuestas en el foro comunitario.
-- ==============================================================================

-- 1. Políticas de eliminación para HILOS (forum_threads)
DROP POLICY IF EXISTS "Admins y autores pueden eliminar hilos" ON public.forum_threads;
CREATE POLICY "Admins y autores pueden eliminar hilos" ON public.forum_threads
FOR DELETE USING (
  auth.uid() = author_id
  OR EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role IN ('admin', 'profesor')
  )
);

-- 2. Políticas de eliminación para RESPUESTAS (forum_posts)
DROP POLICY IF EXISTS "Admins y autores pueden eliminar posts" ON public.forum_posts;
CREATE POLICY "Admins y autores pueden eliminar posts" ON public.forum_posts
FOR DELETE USING (
  auth.uid() = author_id
  OR EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role IN ('admin', 'profesor')
  )
);
