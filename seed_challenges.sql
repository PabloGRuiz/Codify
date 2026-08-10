-- Actualización del esquema: Soporte para Unit Tests Ocultos
ALTER TABLE public.challenges 
ADD COLUMN test_code TEXT;

-- Creación de Módulos Base
INSERT INTO public.modules (title, description, difficulty_level)
VALUES 
  ('Fundamentos de JavaScript', 'Aprende las bases de la lógica de programación y la sintaxis de JS.', 1),
  ('Prototipado Web Básico', 'Crea tus primeras interfaces con HTML y CSS.', 1)
RETURNING id; 
-- (Nota: Para los retos a continuación, asegúrate de que el module_id coincida. Aquí usaremos consultas dinámicas).

-- Insertar Retos Base para el módulo de JavaScript
DO $$
DECLARE
  js_module_id UUID;
  web_module_id UUID;
BEGIN
  SELECT id INTO js_module_id FROM public.modules WHERE title = 'Fundamentos de JavaScript' LIMIT 1;
  SELECT id INTO web_module_id FROM public.modules WHERE title = 'Prototipado Web Básico' LIMIT 1;

  -- Reto 1: Suma de Pares (Lógica)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    js_module_id,
    'Suma de Pares',
    'Escribe una función llamada sumarPares(numeros) que reciba un arreglo de números y devuelva la suma de todos los números pares.',
    'logic',
    'function sumarPares(numeros) {
  // Tu código aquí
  return 0;
}',
    'function sumarPares(numeros) {
  return numeros.filter(n => n % 2 === 0).reduce((a, b) => a + b, 0);
}',
    '// Unit Tests Ocultos
const assert = (condition, message) => { if (!condition) throw new Error(message); };
assert(sumarPares([1, 2, 3, 4]) === 6, "Falla en arreglo simple [1, 2, 3, 4]");
assert(sumarPares([1, 3, 5]) === 0, "Falla en arreglo sin pares");
assert(sumarPares([10, 20]) === 30, "Falla en arreglo de solo pares");
console.log("¡Todos los tests pasaron!");
',
    50,
    1
  );

  -- Reto 2: Invertir Cadena (Lógica)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    js_module_id,
    'Invertir Texto',
    'Escribe una función invertirCadena(texto) que devuelva el texto al revés.',
    'logic',
    'function invertirCadena(texto) {
  // Tu código aquí
  return "";
}',
    'function invertirCadena(texto) {
  return texto.split("").reverse().join("");
}',
    'const assert = (condition, message) => { if (!condition) throw new Error(message); };
assert(invertirCadena("hola") === "aloh", "Falla con la palabra hola");
assert(invertirCadena("Javascript") === "tpircsavaJ", "Falla con Javascript");
console.log("¡Todos los tests pasaron!");
',
    30,
    2
  );

END $$;
