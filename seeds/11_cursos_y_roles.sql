-- ==============================================================================
-- 🚀 CODIFY SEED: 11 - CURSOS Y ROLES (RBAC)
-- ==============================================================================
-- Este script realiza la migración estructural para soportar Multi-Cursos y 
-- permisos de Administrador/Profesor.
-- ==============================================================================

DO $$
DECLARE
  default_course_id UUID;
BEGIN

  -- 1. Añadir el sistema de roles a los perfiles de usuario
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'profiles' 
      AND column_name = 'role'
  ) THEN
    ALTER TABLE public.profiles ADD COLUMN role VARCHAR(50) DEFAULT 'student';
  END IF;

  -- 2. Crear la tabla de Cursos si no existe
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
      AND table_name = 'courses'
  ) THEN
    CREATE TABLE public.courses (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      image_url TEXT,
      author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
      status VARCHAR(20) DEFAULT 'published',
      tags TEXT[] DEFAULT '{}',
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;

  -- 3. Modificar la tabla de módulos para enlazarlos a un curso
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'modules' 
      AND column_name = 'course_id'
  ) THEN
    ALTER TABLE public.modules ADD COLUMN course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE;
  END IF;

  -- 4. Crear tabla de inscripciones a cursos (Enrollments)
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
      AND table_name = 'course_enrollments'
  ) THEN
    CREATE TABLE public.course_enrollments (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
      course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
      enrolled_at TIMESTAMPTZ DEFAULT NOW(),
      status VARCHAR(20) DEFAULT 'active',
      UNIQUE(user_id, course_id)
    );
  END IF;

  -- 5. Crear el Curso Principal por Defecto
  INSERT INTO public.courses (title, description, tags, status)
  VALUES (
    'Desarrollo Web Full Stack con IA',
    'El bootcamp definitivo para dominar la programación moderna. Aprende desde las bases hasta arquitecturas avanzadas con asistencia de IA integrada.',
    ARRAY['Práctico', 'Web', 'FullStack'],
    'published'
  )
  RETURNING id INTO default_course_id;

  -- 6. Enlazar TODOS los módulos existentes al nuevo Curso Principal
  UPDATE public.modules SET course_id = default_course_id WHERE course_id IS NULL;

  -- 7. (Opcional) Auto-inscribir a los usuarios existentes que ya tengan progreso
  -- Todos los usuarios que hayan hecho un reto, los inscribimos al curso principal
  INSERT INTO public.course_enrollments (user_id, course_id)
  SELECT DISTINCT up.user_id, default_course_id 
  FROM public.user_progress up
  ON CONFLICT (user_id, course_id) DO NOTHING;

END $$;

-- ==============================================================================
-- ASIGNACIÓN DEL ROL ADMIN (Instrucción Manual)
-- ==============================================================================
-- Cuando registres tu cuenta Admin (o si ya la tienes registrada), ejecuta este 
-- comando reemplazando 'Admin' por el username exacto que registraste:
--
-- UPDATE public.profiles SET role = 'admin' WHERE username = 'Admin';
-- ==============================================================================
