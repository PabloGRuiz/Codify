-- ==============================================================================
-- 🚀 CODIFY SEED: 22 - SISTEMA INTEGRAL DE NOTIFICACIONES EN TIEMPO REAL
-- ==============================================================================
-- Crea la tabla de notificaciones, políticas RLS, triggers para respuestas
-- en el foro y nuevos cursos, además de la función de difusión global.
-- ==============================================================================

-- 1. Crear tabla de Notificaciones
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL, -- 'course', 'forum', 'system', 'achievement'
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  link TEXT,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de RLS
DROP POLICY IF EXISTS "Usuarios pueden ver sus propias notificaciones" ON public.notifications;
DROP POLICY IF EXISTS "Usuarios pueden actualizar sus propias notificaciones" ON public.notifications;
DROP POLICY IF EXISTS "Permitir insercion de notificaciones" ON public.notifications;
DROP POLICY IF EXISTS "Usuarios pueden borrar sus propias notificaciones" ON public.notifications;

CREATE POLICY "Usuarios pueden ver sus propias notificaciones" ON public.notifications 
  FOR SELECT TO authenticated 
  USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propias notificaciones" ON public.notifications 
  FOR UPDATE TO authenticated 
  USING (auth.uid() = user_id) 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Permitir insercion de notificaciones" ON public.notifications 
  FOR INSERT TO authenticated 
  WITH CHECK (true);

CREATE POLICY "Usuarios pueden borrar sus propias notificaciones" ON public.notifications 
  FOR DELETE TO authenticated 
  USING (auth.uid() = user_id);

-- 4. Índices para consultas de alta velocidad
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON public.notifications (user_id, read);
CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON public.notifications (user_id, created_at DESC);

-- 5. Trigger: Notificar al autor del hilo cuando alguien responde en el foro
CREATE OR REPLACE FUNCTION public.handle_forum_reply_notification()
RETURNS TRIGGER AS $$
DECLARE
  v_thread_author_id UUID;
  v_thread_title TEXT;
  v_replier_username TEXT;
BEGIN
  -- Obtener autor y título del hilo correspondiente
  SELECT author_id, title INTO v_thread_author_id, v_thread_title
  FROM public.forum_threads
  WHERE id = NEW.thread_id;

  -- Solo notificar si quien responde NO es el mismo autor de la pregunta
  IF v_thread_author_id IS NOT NULL AND v_thread_author_id != NEW.author_id THEN
    SELECT username INTO v_replier_username
    FROM public.profiles
    WHERE id = NEW.author_id;

    INSERT INTO public.notifications (user_id, type, title, message, link)
    VALUES (
      v_thread_author_id,
      'forum',
      'Nueva respuesta en tu consulta 💬',
      COALESCE('@' || v_replier_username, 'Un usuario') || ' respondió a tu publicación "' || LEFT(v_thread_title, 40) || '..."',
      '/foro/' || NEW.thread_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_forum_reply_notification ON public.forum_posts;
CREATE TRIGGER trg_forum_reply_notification
  AFTER INSERT ON public.forum_posts
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_forum_reply_notification();

-- 6. Trigger: Notificar a todos los usuarios cuando se publica un nuevo curso
CREATE OR REPLACE FUNCTION public.handle_new_course_notification()
RETURNS TRIGGER AS $$
BEGIN
  -- Solo emitir notificación si el curso está publicado
  IF NEW.status = 'published' THEN
    INSERT INTO public.notifications (user_id, type, title, message, link)
    SELECT 
      p.id,
      'course',
      '¡Nuevo Curso Disponible! 🚀',
      'Se ha publicado el curso "' || NEW.title || '". ¡Comienza a aprender ahora!',
      '/cursos/' || NEW.id || '/preview'
    FROM public.profiles p;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_new_course_notification ON public.courses;
CREATE TRIGGER trg_new_course_notification
  AFTER INSERT ON public.courses
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_course_notification();

-- 7. Stored Procedure: Difusión global de anuncios del sistema
CREATE OR REPLACE FUNCTION public.broadcast_system_notification(
  p_title TEXT,
  p_message TEXT,
  p_link TEXT DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
  v_count INTEGER;
BEGIN
  INSERT INTO public.notifications (user_id, type, title, message, link)
  SELECT 
    p.id,
    'system',
    p_title,
    p_message,
    p_link
  FROM public.profiles p;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. Notificación inicial de bienvenida al sistema de notificaciones para todos los usuarios
DO $$
BEGIN
  PERFORM public.broadcast_system_notification(
    '¡Sistema de Notificaciones Activo! 🔔',
    'Bienvenido a la nueva experiencia interactiva. Ahora recibirás avisos en tiempo real sobre nuevos cursos, respuestas en el foro y novedades del sistema.',
    '/cursos'
  );
END $$;
