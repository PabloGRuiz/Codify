-- ==============================================================================
-- 🚀 CODIFY SEED: 12 - PERMISOS RLS Y SINCRONIZACIÓN DE PERFILES
-- ==============================================================================
-- Este script soluciona la visibilidad de usuarios en el Panel de Administración:
-- 1. Permite que todos los usuarios autenticados puedan leer perfiles (o admins lean todo).
-- 2. Permite a los admins actualizar el rol de cualquier usuario.
-- 3. Inserta perfiles para cualquier usuario de auth.users que no tenga perfil aún.
-- ==============================================================================

-- 1. Habilitar RLS en profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Política de Lectura: Todos los usuarios autenticados pueden ver perfiles
DROP POLICY IF EXISTS "Perfiles visibles para todos los autenticados" ON public.profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;

CREATE POLICY "Perfiles visibles para todos los autenticados"
ON public.profiles
FOR SELECT
TO authenticated
USING (true);

-- 3. Política de Actualización: Cada usuario puede actualizar su propio perfil,
-- y los administradores pueden actualizar cualquier perfil (para cambiar roles, XP, etc.)
DROP POLICY IF EXISTS "Usuarios actualizan propio perfil y admins todo" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;

CREATE POLICY "Usuarios actualizan propio perfil y admins todo"
ON public.profiles
FOR UPDATE
TO authenticated
USING (
  auth.uid() = id 
  OR EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- 4. Sincronizar perfiles faltantes desde auth.users
-- (En caso de que usuarios como Ruiz Pablo o cuentas previas no tengan fila en profiles)
INSERT INTO public.profiles (id, username, role, level, xp, reputation_stars)
SELECT 
  u.id,
  COALESCE(u.raw_user_meta_data->>'username', split_part(u.email, '@', 1), 'Coder'),
  'student',
  1,
  0,
  0
FROM auth.users u
LEFT JOIN public.profiles p ON p.id = u.id
WHERE p.id IS NULL;
