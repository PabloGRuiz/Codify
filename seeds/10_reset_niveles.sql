-- ==============================================================================
-- 🔄 CODIFY: RESET DE NIVELES Y XP (CONSERVANDO PROGRESO DE MÓDULOS)
-- ==============================================================================
-- Este script resetea el nivel y la experiencia en la tabla "profiles" a Nivel 1 (0 XP)
-- SIN TOCAR la tabla "user_progress", manteniendo todas tus lecciones y módulos 
-- completados tal como los tienes marcados.
-- ==============================================================================

-- 1. Resetear todos los perfiles a Nivel 1 con 0 XP acumulado

--UPDATE public.profiles
--SET 
  --xp = 0,
  --level = 1;

-- 2. (Opcional) Si en lugar de 0 XP prefieres sincronizar tu XP exacto 
-- sumando únicamente los retos que realmente tienes completados en user_progress,
-- puedes comentar el UPDATE de arriba y ejecutar este bloque:

UPDATE public.profiles p
SET 
  xp = COALESCE((
    SELECT SUM(c.xp_reward)
    FROM public.user_progress up
    JOIN public.challenges c ON up.challenge_id = c.id
    WHERE up.user_id = p.id AND up.status = 'completed'
  ), 0),
  level = 1;

