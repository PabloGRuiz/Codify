-- Migración: Agregar columna 'theory' a la tabla challenges
ALTER TABLE public.challenges 
ADD COLUMN IF NOT EXISTS theory TEXT;
