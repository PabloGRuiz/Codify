-- Deshabilitamos RLS temporalmente o añadimos políticas para que la app web pueda leer/escribir.
-- Opción recomendada para esta fase de desarrollo: Añadir políticas de acceso total para usuarios logueados.

-- Habilitar RLS en las tablas (por si acaso no estaban habilitadas explícitamente)
ALTER TABLE public.modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

-- Borrar políticas previas si existieran para no duplicar
DROP POLICY IF EXISTS "Acceso total modulos" ON public.modules;
DROP POLICY IF EXISTS "Acceso total retos" ON public.challenges;
DROP POLICY IF EXISTS "Acceso total progreso" ON public.user_progress;

-- Crear políticas para permitir a cualquier usuario logueado (authenticated) leer y escribir
CREATE POLICY "Acceso total modulos" ON public.modules FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Acceso total retos" ON public.challenges FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Acceso total progreso" ON public.user_progress FOR ALL TO authenticated USING (true) WITH CHECK (true);
