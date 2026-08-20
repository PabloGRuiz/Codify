-- ==============================================================================
-- ⚔️ CODIFY SEED: ARENA ALGORÍTMICA & RETOS DIARIOS PVP (10 RETOS)
-- ==============================================================================
-- Este script crea el módulo de Speed Coding / Retos Diarios.
-- 100% INDEPENDIENTE e IDEMPOTENTE.
-- ==============================================================================

DO $$
DECLARE
  arena_module_id UUID;
BEGIN

  -- 1. Limpieza segura previa del módulo
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Arena Algorítmica & Speed Coding'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Arena Algorítmica & Speed Coding'
  );
  DELETE FROM public.modules WHERE title = 'Arena Algorítmica & Speed Coding';

  -- 2. Creación del Módulo Arena
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Arena Algorítmica & Speed Coding',
    'Colección de retos algorítmicos rápidos y optimizados para rotación diaria, entrenamiento de agilidad mental y futuros Duelos de Código PvP.',
    1
  )
  RETURNING id INTO arena_module_id;


  -- ============================================================================
  -- RETO 1: Invertir una Cadena de Texto (Reverse String)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Invertir una Cadena (Reverse String)',
    'Escribe una función que reciba una cadena de texto y devuelva sus caracteres en orden inverso.',
    '### 💡 Analogía: El Espejo de Texto
Invertir una cadena es uno de los calentamientos algorítmicos más populares en entrevistas técnicas.

### 📝 Estrategias Posibles
1. **Método Funcional:** Convertir en array (`split("")`), invertir (`reverse()`) y unir (`join("")`).
2. **Bucle For Clásico:** Recorrer desde el final hacia el inicio acumulando caracteres.

### 🎯 Tu Misión
Implementa `reverseString(str)` para que devuelva la palabra al revés.',
    'javascript',
    'function reverseString(str) {
  // Tu código aquí
}',
    'function reverseString(str) {
  return str.split("").reverse().join("");
}',
    'test("Invertir texto simple", () => {
  expect(reverseString("hola")).toBe("aloh");
});
test("Invertir palabra larga", () => {
  expect(reverseString("javascript")).toBe("tpircsavaj");
});
test("Manejar strings con espacios", () => {
  expect(reverseString("codify pvp")).toBe("pvp yfidoc");
});',
    75,
    1
  );


  -- ============================================================================
  -- RETO 2: El Clásico FizzBuzz
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'El Clásico FizzBuzz',
    'Retorna "Fizz" si es múltiplo de 3, "Buzz" si es múltiplo de 5, "FizzBuzz" si es múltiplo de ambos, o el número como string si no.',
    '### 💡 Analogía: El Juego de Aplausos
FizzBuzz es el estándar dorado de agilidad lógica condicional.

### ⚠️ Error Común
Comprobar `n % 3 === 0` primero antes de comprobar si es múltiplo de **ambos** (15). El orden de los `if` determina el éxito.

### 🎯 Tu Misión
Crea la función `fizzBuzz(n)` que retorne el valor correcto según las reglas.',
    'javascript',
    'function fizzBuzz(n) {
  // Tu código aquí
}',
    'function fizzBuzz(n) {
  if (n % 15 === 0) return "FizzBuzz";
  if (n % 3 === 0) return "Fizz";
  if (n % 5 === 0) return "Buzz";
  return String(n);
}',
    'test("Múltiplo de 3", () => {
  expect(fizzBuzz(9)).toBe("Fizz");
});
test("Múltiplo de 5", () => {
  expect(fizzBuzz(10)).toBe("Buzz");
});
test("Múltiplo de 3 y 5", () => {
  expect(fizzBuzz(15)).toBe("FizzBuzz");
});
test("No múltiplo", () => {
  expect(fizzBuzz(7)).toBe("7");
});',
    75,
    2
  );


  -- ============================================================================
  -- RETO 3: Detector de Palíndromos
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Detector de Palíndromos',
    'Verifica si una palabra se lee exactamente igual de izquierda a derecha que de derecha a izquierda.',
    '### 💡 Concepto
Un palíndromo es una palabra o frase simétrica (ej: "radar", "reconocer", "ana").

### 🎯 Tu Misión
Implementa `isPalindrome(str)` ignorando mayúsculas/minúsculas. Debe retornar `true` o `false`.',
    'javascript',
    'function isPalindrome(str) {
  // Tu código aquí
}',
    'function isPalindrome(str) {
  const clean = str.toLowerCase();
  return clean === clean.split("").reverse().join("");
}',
    'test("Palíndromo simple", () => {
  expect(isPalindrome("radar")).toBe(true);
});
test("Palíndromo con mayúsculas", () => {
  expect(isPalindrome("Reconocer")).toBe(true);
});
test("No es palíndromo", () => {
  expect(isPalindrome("codify")).toBe(false);
});',
    75,
    3
  );


  -- ============================================================================
  -- RETO 4: Suma de Dos Números (Find Pair Sum)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Suma de Dos Números (Find Pair)',
    'Dado un array de números y un número objetivo, encuentra la primera pareja de dos números que sumen el objetivo.',
    '### 💡 Concepto
El problema clásico Two-Sum es la base de la búsqueda asociativa y tablas hash.

### 🎯 Tu Misión
Crea la función `findPair(numbers, target)` que devuelva un array `[a, b]` con los dos números que suman `target`, o `null` si no existen.',
    'javascript',
    'function findPair(numbers, target) {
  // Tu código aquí
}',
    'function findPair(numbers, target) {
  const seen = new Set();
  for (const num of numbers) {
    const diff = target - num;
    if (seen.has(diff)) {
      return [diff, num];
    }
    seen.add(num);
  }
  return null;
}',
    'test("Encontrar pareja básica", () => {
  expect(findPair([1, 4, 6, 9], 10)).toEqual([4, 6]);
});
test("Pareja con negativos", () => {
  expect(findPair([-3, 5, 8, 2], 5)).toEqual([-3, 8]);
});
test("Sin pareja existente", () => {
  expect(findPair([1, 2, 3], 100)).toBe(null);
});',
    75,
    4
  );


  -- ============================================================================
  -- RETO 5: Contador de Vocales
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Contador de Vocales',
    'Cuenta cuántas vocales (a, e, i, o, u) contiene una cadena de texto, sin importar mayúsculas.',
    '### 💡 Concepto
Procesamiento de texto simple con regex o filtros de conjuntos.

### 🎯 Tu Misión
Crea la función `countVowels(str)` que retorne el número entero de vocales presentes.',
    'javascript',
    'function countVowels(str) {
  // Tu código aquí
}',
    'function countVowels(str) {
  const matches = str.match(/[aeiouáéíóú]/gi);
  return matches ? matches.length : 0;
}',
    'test("Contar vocales en palabra", () => {
  expect(countVowels("Javascript")).toBe(3);
});
test("Contar con mayúsculas y acentos", () => {
  expect(countVowels("CÓDIGO activo")).toBe(6);
});
test("Sin vocales", () => {
  expect(countVowels("rhythm")).toBe(0);
});',
    75,
    5
  );


  -- ============================================================================
  -- RETO 6: Encontrar el Número Máximo
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Encontrar el Número Máximo',
    'Encuentra y retorna el valor numérico más alto dentro de un array sin usar Math.max(...array) directo.',
    '### 💡 Concepto
Búsqueda de extremos e iteración básica de colecciones.

### 🎯 Tu Misión
Implementa `findMax(numbers)` para devolver el número más grande del array.',
    'javascript',
    'function findMax(numbers) {
  // Tu código aquí
}',
    'function findMax(numbers) {
  let max = numbers[0];
  for (let i = 1; i < numbers.length; i++) {
    if (numbers[i] > max) max = numbers[i];
  }
  return max;
}',
    'test("Array estándar", () => {
  expect(findMax([12, 45, 8, 99, 23])).toBe(99);
});
test("Array con números negativos", () => {
  expect(findMax([-10, -50, -3, -20])).toBe(-3);
});
test("Array de un solo elemento", () => {
  expect(findMax([42])).toBe(42);
});',
    75,
    6
  );


  -- ============================================================================
  -- RETO 7: Factorial Recursivo o Iterativo
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Cálculo de Factorial',
    'Calcula el factorial de un número n (n! = n * (n-1) * ... * 1). Ten en cuenta que 0! = 1.',
    '### 💡 Concepto
El cálculo de factoriales es el ejemplo fundamental de recursión y bucles acumuladores.

### 🎯 Tu Misión
Implementa la función `factorial(n)` para cualquier entero no negativo `n`.',
    'javascript',
    'function factorial(n) {
  // Tu código aquí
}',
    'function factorial(n) {
  if (n <= 1) return 1;
  let result = 1;
  for (let i = 2; i <= n; i++) {
    result *= i;
  }
  return result;
}',
    'test("Factorial de 5", () => {
  expect(factorial(5)).toBe(120);
});
test("Factorial de 0", () => {
  expect(factorial(0)).toBe(1);
});
test("Factorial de 3", () => {
  expect(factorial(3)).toBe(6);
});',
    75,
    7
  );


  -- ============================================================================
  -- RETO 8: Filtrar Números Pares
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Filtrar Números Pares',
    'Filtra un array de números devolviendo únicamente los elementos que son pares.',
    '### 💡 Concepto
Uso del operador módulo `% 2 === 0` para discriminación de paridad.

### 🎯 Tu Misión
Crea la función `filterEvens(numbers)` que devuelva un nuevo array solo con los números pares.',
    'javascript',
    'function filterEvens(numbers) {
  // Tu código aquí
}',
    'function filterEvens(numbers) {
  return numbers.filter(n => n % 2 === 0);
}',
    'test("Filtrar lista mixta", () => {
  expect(filterEvens([1, 2, 3, 4, 5, 6])).toEqual([2, 4, 6]);
});
test("Lista sin pares", () => {
  expect(filterEvens([1, 3, 5, 7])).toEqual([]);
});
test("Lista con negativos pares", () => {
  expect(filterEvens([-4, -3, 0, 2])).toEqual([-4, 0, 2]);
});',
    75,
    8
  );


  -- ============================================================================
  -- RETO 9: Capitalizar Palabras (Title Case)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Capitalizar Palabras (Title Case)',
    'Convierte la primera letra de cada palabra de una frase en mayúscula y el resto en minúscula.',
    '### 💡 Concepto
Manipulación de substrings y formateo visual de texto.

### 🎯 Tu Misión
Implementa `capitalizeWords(sentence)` para formatear la frase en Title Case.',
    'javascript',
    'function capitalizeWords(sentence) {
  // Tu código aquí
}',
    'function capitalizeWords(sentence) {
  return sentence
    .toLowerCase()
    .split(" ")
    .map(w => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}',
    'test("Frase en minúsculas", () => {
  expect(capitalizeWords("aprende a programar")).toBe("Aprende A Programar");
});
test("Frase con mayúsculas locas", () => {
  expect(capitalizeWords("cODiFy eS gENiAL")).toBe("Codify Es Genial");
});',
    75,
    9
  );


  -- ============================================================================
  -- RETO 10: Eliminar Duplicados de un Array
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    arena_module_id,
    'Eliminar Duplicados de un Array',
    'Recibe un array con posibles elementos repetidos y devuelve un nuevo array con elementos únicos en el orden original.',
    '### 💡 Concepto
Estructuras de datos `Set` o filtrado por `indexOf`.

### 🎯 Tu Misión
Crea la función `removeDuplicates(items)` que elimine cualquier valor duplicado.',
    'javascript',
    'function removeDuplicates(items) {
  // Tu código aquí
}',
    'function removeDuplicates(items) {
  return Array.from(new Set(items));
}',
    'test("Array de números con duplicados", () => {
  expect(removeDuplicates([1, 2, 2, 3, 4, 4, 5])).toEqual([1, 2, 3, 4, 5]);
});
test("Array de strings", () => {
  expect(removeDuplicates(["a", "b", "a", "c", "b"])).toEqual(["a", "b", "c"]);
});
test("Array ya sin duplicados", () => {
  expect(removeDuplicates([1, 2, 3])).toEqual([1, 2, 3]);
});',
    75,
    10
  );

END $$;
