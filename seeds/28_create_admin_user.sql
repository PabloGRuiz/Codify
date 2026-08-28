-- ==============================================================================
-- 🚀 CODIFY SEED: 28 - CREAR USUARIO ADMINISTRADOR DIRECTO
-- ==============================================================================
-- Credenciales:
-- Email:    admin@codify.com
-- Password: admin123
-- ==============================================================================

DO $$
DECLARE
  v_user_id UUID := gen_random_uuid();
  v_encrypted_pw TEXT;
BEGIN

  -- 1. Si ya existe un usuario con este email, eliminarlo para recrearlo limpio
  DELETE FROM auth.users WHERE email = 'admin@codify.com';
  DELETE FROM public.profiles WHERE username = 'Admin Codify' OR id = v_user_id;

  -- 2. Hashear la contraseña 'admin123' con bcrypt compatible con Supabase
  -- Requiere la extensión pgcrypto (activa por defecto en Supabase)
  v_encrypted_pw := crypt('admin123', gen_salt('bf', 10));

  -- 3. Insertar el usuario en auth.users con email confirmado
  INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    created_at,
    updated_at,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    v_user_id,
    'authenticated',
    'authenticated',
    'admin@codify.com',
    v_encrypted_pw,
    now(), -- Email verificado automáticamente
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"username":"Admin Codify"}'::jsonb,
    false,
    now(),
    now(),
    '',
    '',
    '',
    ''
  );

  -- 4. Crear su perfil asociado en public.profiles con rol 'admin'
  INSERT INTO public.profiles (
    id,
    username,
    role,
    level,
    xp,
    reputation_stars,
    streak_days,
    last_login
  ) VALUES (
    v_user_id,
    'Admin Codify',
    'admin',
    10,
    5000,
    10,
    7,
    now()
  )
  ON CONFLICT (id) DO UPDATE 
  SET role = 'admin',
      level = 10,
      xp = 5000;

END $$;
