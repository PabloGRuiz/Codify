-- SCRIPT PARA REINICIAR TODO EL PROGRESO Y ELIMINAR MÓDULOS REPETIDOS
-- ADVERTENCIA: Esto borrará el progreso de todos los usuarios y todos los módulos.
-- Úsalo para limpiar la base de datos de duplicados antes de volver a insertar los currículums.

-- 1. Borrar progreso de usuarios (evita errores de clave foránea)
DELETE FROM public.user_progress;

-- 2. Borrar todos los retos
DELETE FROM public.challenges;

-- 3. Borrar todos los módulos
DELETE FROM public.modules;

-- 4. Opcional: Reiniciar el nivel y XP de todos los usuarios a 1 y 0
UPDATE public.profiles SET xp = 0, level = 1;

-- ¡Listo! Ahora puedes volver a correr el archivo 'beginner_curriculum.sql' una sola vez.
