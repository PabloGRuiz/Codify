-- ==============================================================================
-- 🚀 CODIFY SEED: 18 - SISTEMA DE PRERREQUISITOS Y CORRELATIVIDADES DE CURSOS
-- ==============================================================================
-- Este script:
-- 1. Agrega las columnas 'prerequisite_course_id' y 'min_level' a 'courses'.
-- 2. Configura los primeros prerrequisitos para los cursos existentes.
-- ==============================================================================

DO $$
BEGIN

  -- 1. Añadir columna 'prerequisite_course_id' si no existe
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'courses' 
      AND column_name = 'prerequisite_course_id'
  ) THEN
    ALTER TABLE public.courses ADD COLUMN prerequisite_course_id UUID REFERENCES public.courses(id) ON DELETE SET NULL;
  END IF;

  -- 2. Añadir columna 'min_level' si no existe
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'courses' 
      AND column_name = 'min_level'
  ) THEN
    ALTER TABLE public.courses ADD COLUMN min_level INTEGER DEFAULT 1;
  END IF;

  -- 3. Configurar correlatividad ejemplo:
  -- "Fundamentos de la Programación Web" -> puede requerir "Fundamentos IT y Lógica" o Nivel 1
  -- "Desarrollo Web Full Stack con IA" -> requiere haber completado "Fundamentos de la Programación Web"
  UPDATE public.courses
  SET prerequisite_course_id = (SELECT id FROM public.courses WHERE title = 'Fundamentos de la Programación Web' LIMIT 1),
      min_level = 2
  WHERE title = 'Desarrollo Web Full Stack con IA';

END $$;
