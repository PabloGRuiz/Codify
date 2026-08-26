-- ==============================================================================
-- 🚀 CODIFY SEED: 24 - SISTEMA DE REPORTES DE ERRORES Y FEEDBACK EN CURSOS
-- ==============================================================================
-- Crea la tabla de reportes de incidencias en material didáctico,
-- cuestionarios y validaciones de código con soporte para RLS y notificaciones.
-- ==============================================================================

-- 1. Crear tabla de reportes de contenido
CREATE TABLE IF NOT EXISTS public.content_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
  course_id UUID REFERENCES public.courses(id) ON DELETE SET NULL,
  report_type VARCHAR(50) NOT NULL, -- 'theory_error', 'quiz_error', 'test_code_error', 'typo', 'other'
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'in_review', 'resolved', 'dismissed'
  admin_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de RLS
DROP POLICY IF EXISTS "Usuarios pueden crear sus propios reportes" ON public.content_reports;
DROP POLICY IF EXISTS "Usuarios y admins pueden ver reportes" ON public.content_reports;
DROP POLICY IF EXISTS "Admins y profesores pueden actualizar reportes" ON public.content_reports;
DROP POLICY IF EXISTS "Admins pueden eliminar reportes" ON public.content_reports;

-- Insertar: Cualquier usuario autenticado puede enviar un reporte
CREATE POLICY "Usuarios pueden crear sus propios reportes" ON public.content_reports
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Lectura: Los usuarios ven sus reportes y los administradores/profesores ven todos
CREATE POLICY "Usuarios y admins pueden ver reportes" ON public.content_reports
  FOR SELECT TO authenticated
  USING (
    auth.uid() = user_id 
    OR EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role IN ('admin', 'profesor')
    )
  );

-- Actualización: Solo admins y profesores pueden gestionar el estado y notas
CREATE POLICY "Admins y profesores pueden actualizar reportes" ON public.content_reports
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role IN ('admin', 'profesor')
    )
  );

-- Eliminación: Solo administradores
CREATE POLICY "Admins pueden eliminar reportes" ON public.content_reports
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 4. Índices para consultas de alta velocidad
CREATE INDEX IF NOT EXISTS idx_content_reports_status ON public.content_reports(status);
CREATE INDEX IF NOT EXISTS idx_content_reports_challenge ON public.content_reports(challenge_id);
CREATE INDEX IF NOT EXISTS idx_content_reports_user ON public.content_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_content_reports_created ON public.content_reports(created_at DESC);

-- 5. Trigger: Notificar automáticamente al usuario cuando su reporte es marcado como 'resolved'
CREATE OR REPLACE FUNCTION public.handle_report_resolved_notification()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'resolved' AND (OLD.status IS DISTINCT FROM 'resolved') THEN
    INSERT INTO public.notifications (user_id, type, title, message, link)
    VALUES (
      NEW.user_id,
      'system',
      '¡Reporte de Contenido Resuelto! ✅',
      'Tu reporte sobre "' || LEFT(NEW.title, 40) || '" ha sido revisado y solucionado por el equipo técnico. ¡Muchas gracias por tu aporte a la comunidad!',
      CASE WHEN NEW.challenge_id IS NOT NULL THEN '/ide/' || NEW.challenge_id ELSE '/cursos' END
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_report_resolved_notification ON public.content_reports;
CREATE TRIGGER trg_report_resolved_notification
  AFTER UPDATE ON public.content_reports
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_report_resolved_notification();
