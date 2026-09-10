-- ==============================================================================
-- 🛡️ SGFC SEED: 34 - REINICIO LIMPIO DE RACHA AL ASCENDER A ORO
-- ==============================================================================
-- Corrige los perfiles en Rango Oro que ascendieron desde Plata conservando
-- erróneamente la racha residual de la fase de promoción (3).
-- Arranca su racha en 0 para que puedan competir por su racha invicto en la cima.
-- ==============================================================================

UPDATE public.profiles
SET arena_streak = 0
WHERE arena_rank = 'oro' AND arena_streak >= 3;
