-- Script SQL para insertar el Curso Desde Cero (5 Lecciones Progresivas con Teoría + Práctica)

DO $$
DECLARE
  base_module_id UUID;
BEGIN
  -- 1. Crear el Módulo Principal "Aprende a Programar desde Cero"
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Curso Inicial: Aprende a Programar desde Cero',
    'Ruta completa para principiantes. Aprende variables, operadores, condicionales, bucles y funciones.',
    1
  )
  RETURNING id INTO base_module_id;

  -- Lección 1: Variables y Constantes
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 1: Variables y Contenedores de Datos',
    'Declara una constante llamada "nombrePlataforma" con valor "Codify" y una variable "nivelInicial" con valor 1.',
    '### 💡 ¿Qué es una Variable?
Una variable es como una **caja etiquetada** en la memoria de la computadora donde guardamos un dato para usarlo después.

En JavaScript usamos dos palabras clave principales:
- `const`: Para valores que **NUNCA cambian** (constantes).
- `let`: Para valores que **pueden cambiar** en el futuro.

### 📝 Ejemplo de Código:
```js
const pais = "Argentina"; // No cambia
let puntos = 0;           // Puede aumentar luego
puntos = 10;
```

### 🎯 Tu Misión:
Declara una constante llamada `nombrePlataforma` asignándole el texto `"Codify"` y una variable llamada `nivelInicial` asignándole el número `1`.',
    'logic',
    '// 1. Declara aquí la constante nombrePlataforma\n\n// 2. Declara aquí la variable nivelInicial\n',
    'const nombrePlataforma = "Codify";\nlet nivelInicial = 1;',
    'const assert = (c, m) => { if (!c) throw new Error(m); };\nassert(typeof nombrePlataforma !== "undefined", "No has declarado la variable nombrePlataforma");\nassert(nombrePlataforma === "Codify", "nombrePlataforma debe valer \'Codify\'");\nassert(typeof nivelInicial !== "undefined", "No has declarado la variable nivelInicial");\nassert(nivelInicial === 1, "nivelInicial debe ser igual a 1");',
    25,
    1
  );

  -- Lección 2: Operaciones Matemáticas
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 2: Operaciones Matemáticas Básicas',
    'Calcula el precio final aplicando un descuento.',
    '### 🔢 Matemáticas en Programación
Las computadoras son calculadoras ultrarrápidas. Podemos hacer operaciones usando los símbolos tradicionales:
- `+` Suma
- `-` Resta
- `*` Multiplicación
- `/` División

### 📝 Ejemplo de Código:
```js
let precio = 100;
let descuento = 20;
let total = precio - descuento; // Vale 80
```

### 🎯 Tu Misión:
Usa las variables `precioOriginal` (100) y `descuento` (20) para calcular `precioFinal` (precioOriginal menos descuento).',
    'logic',
    'const precioOriginal = 100;\nconst descuento = 20;\n\n// Calcula precioFinal aquí:\nlet precioFinal = 0;\n',
    'const precioOriginal = 100;\nconst descuento = 20;\nlet precioFinal = precioOriginal - descuento;',
    'const assert = (c, m) => { if (!c) throw new Error(m); };\nassert(precioFinal === 80, "precioFinal debe ser igual a 80 (100 - 20)");',
    30,
    2
  );

  -- Lección 3: Condicionales If / Else
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 3: Tomando Decisiones (If / Else)',
    'Crea una función que verifique si una persona es mayor de edad (>= 18).',
    '### 🚦 Tomar Decisiones con `if` / `else`
En programación, a menudo queremos que el código haga una cosa u otra según una condición.

- Si la condición es **verdadera** (`true`), ejecuta el bloque `if`.
- Si la condición es **falsa** (`false`), ejecuta el bloque `else`.

### 📝 Ejemplo de Código:
```js
function evaluarClima(temperatura) {
  if (temperatura > 25) {
    return "Hace calor";
  } else {
    return "Hace fresco";
  }
}
```

### 🎯 Tu Misión:
Crea una función llamada `esMayorDeEdad(edad)` que devuelva `true` si la edad es mayor o igual a 18, y `false` en caso contrario.',
    'logic',
    'function esMayorDeEdad(edad) {\n  // Tu código de decisión aquí:\n  \n}\n',
    'function esMayorDeEdad(edad) {\n  if (edad >= 18) {\n    return true;\n  } else {\n    return false;\n  }\n}',
    'const assert = (c, m) => { if (!c) throw new Error(m); };\nassert(esMayorDeEdad(20) === true, "esMayorDeEdad(20) debe devolver true");\nassert(esMayorDeEdad(15) === false, "esMayorDeEdad(15) debe devolver false");\nassert(esMayorDeEdad(18) === true, "esMayorDeEdad(18) debe devolver true");',
    40,
    3
  );

  -- Lección 4: Bucles For
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 4: Repitiendo Tareas con Bucles (Loops)',
    'Escribe una función que sume todos los números desde 1 hasta n.',
    '### 🔄 Repetir código con un Bucle `for`
Un bucle nos permite repetir un bloque de código muchas veces sin tener que escribirlo manualmente.

Estructura de un `for`:
1. `let i = 1`: Dónde empieza el contador.
2. `i <= limite`: Hasta cuándo se repite.
3. `i++`: Incrementa el contador de 1 en 1.

### 📝 Ejemplo de Código:
```js
let suma = 0;
for (let i = 1; i <= 3; i++) {
  suma = suma + i; // 1 + 2 + 3 = 6
}
```

### 🎯 Tu Misión:
Escribe la función `sumarHasta(n)` que reciba un número `n` y devuelva la suma de todos los enteros desde 1 hasta `n`.',
    'logic',
    'function sumarHasta(n) {\n  let total = 0;\n  // Escribe tu bucle for aquí:\n  \n  return total;\n}\n',
    'function sumarHasta(n) {\n  let total = 0;\n  for (let i = 1; i <= n; i++) {\n    total += i;\n  }\n  return total;\n}',
    'const assert = (c, m) => { if (!c) throw new Error(m); };\nassert(sumarHasta(3) === 6, "sumarHasta(3) debe dar 6 (1+2+3)");\nassert(sumarHasta(5) === 15, "sumarHasta(5) debe dar 15 (1+2+3+4+5)");',
    50,
    4
  );

  -- Lección 5: Algoritmo Integrador
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 5: Tu Primer Algoritmo Completo',
    'Combina funciones, arreglos, bucles y condicionales para contar exámenes aprobados (>= 60).',
    '### 🏆 ¡El Desafío Integrador!
¡Felicitaciones! Has llegado a la última lección del curso inicial. Aquí combinarás todo lo aprendido:
- **Funciones**: Para empaquetar tu lógica.
- **Arreglos (`[]`)**: Listas de datos.
- **Bucles (`for`)**: Para recorrer elemento por elemento.
- **Condicionales (`if`)**: Para filtrar solo lo que nos interesa.

### 📝 Ejemplo de Código:
```js
function contarPositivos(numeros) {
  let contador = 0;
  for (let num of numeros) {
    if (num > 0) {
      contador++;
    }
  }
  return contador;
}
```

### 🎯 Tu Misión:
Crea la función `contarAprobados(notas)` que reciba una lista de notas (números) y devuelva cuántas de esas notas son mayores o iguales a 60.',
    'logic',
    'function contarAprobados(notas) {\n  let aprobados = 0;\n  // Recorre el arreglo de notas y cuenta las >= 60:\n  \n  return aprobados;\n}\n',
    'function contarAprobados(notas) {\n  let aprobados = 0;\n  for (let nota of notas) {\n    if (nota >= 60) {\n      aprobados++;\n    }\n  }\n  return aprobados;\n}',
    'const assert = (c, m) => { if (!c) throw new Error(m); };\nassert(contarAprobados([50, 70, 80, 40, 60]) === 3, "Debe haber 3 aprobados (70, 80, 60)");\nassert(contarAprobados([10, 20, 30]) === 0, "Debe haber 0 aprobados");',
    75,
    5
  );

END $$;
