-- ==============================================================================
-- 🚀 CODIFY SEED: MÓDULO 1 - CURSO INICIAL: APRENDE A PROGRAMAR DESDE CERO
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 1 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  base_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados si lo ejecutas varias veces)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Curso Inicial: Aprende a Programar desde Cero'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Curso Inicial: Aprende a Programar desde Cero'
  );
  DELETE FROM public.modules WHERE title = 'Curso Inicial: Aprende a Programar desde Cero';

  -- 2. Creación del Módulo 1
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Curso Inicial: Aprende a Programar desde Cero',
    'Ruta pedagógica completa desde cero: Variables, tipos de datos, operaciones, condicionales, bucles for y tu primer algoritmo.',
    1
  )
  RETURNING id INTO base_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Variables y Contenedores de Datos
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 1: Variables y Contenedores de Datos',
    'Declara una constante llamada "nombrePlataforma" con valor "Codify" y una variable "nivelInicial" con valor 1.',
    $THEORY$
### 📦 1. La Memoria de la Computadora: ¿Qué es una Variable?
Imagina que la memoria de tu computadora es un armario lleno de **cajas con etiquetas**. 
Una **variable** es simplemente una de esas cajas donde guardas un dato (un número, una palabra o un valor) para poder usarlo o cambiarlo más adelante en tu programa.

---

### 🔑 2. Las Dos Palabras Clave de JavaScript: `const` y `let`
En la programación moderna existen dos formas de crear estas cajas:

1. **`const` (Constante):**  
   Se usa para valores que **NUNCA deben cambiar** a lo largo del programa (por ejemplo: tu fecha de nacimiento, el nombre de la app o el valor de PI).  
   *Si intentas modificar una constante, JavaScript lanzará un error de protección.*
2. **`let` (Variable reasignable):**  
   Se usa para valores que **SÍ van a cambiar** con el tiempo (por ejemplo: la puntuación de un jugador, la vida de un personaje o el número de vidas).

---

### 📝 3. Tipos de Datos Básicos
- **Textos (Strings):** Siempre van envueltos entre comillas: `"Hola Mundo"` o `'Codify'`.
- **Números (Numbers):** Se escriben directamente sin comillas: `100`, `3.14`, `-5`.
- **Booleanos:** Representan verdad o falsedad: `true` o `false`.

```js
// Ejemplos claros de código:
const nombreJuego = "CyberQuest"; // Texto inmutable
let puntosActuales = 0;           // Número que cambiará
puntosActuales = 50;              // Reasignación válida con let
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar las comillas en los textos:** Escribir `const app = Codify;` en lugar de `const app = "Codify";`.
- ❌ **Intentar reasignar un `const`:** `const nivel = 1; nivel = 2;` (provocará error).

---

### 🎯 Tu Misión de Hoy:
1. Declara una constante llamada `nombrePlataforma` y asígnale el texto `"Codify"`.
2. Declara una variable llamada `nivelInicial` y asígnale el número `1`.
$THEORY$,
    'logic',
    $CODE$// 1. Declara aquí la constante nombrePlataforma:


// 2. Declara aquí la variable nivelInicial:
$CODE$,
    $CODE$const nombrePlataforma = "Codify";
let nivelInicial = 1;$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof nombrePlataforma !== "undefined", "Falta declarar la constante 'nombrePlataforma'.");
assert(nombrePlataforma === "Codify", "La constante 'nombrePlataforma' debe ser exactamente 'Codify'.");
assert(typeof nivelInicial !== "undefined", "Falta declarar la variable 'nivelInicial'.");
assert(nivelInicial === 1, "La variable 'nivelInicial' debe tener el valor numérico 1.");$TEST$,
    25,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Operaciones Matemáticas Básicas
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 2: Operaciones Matemáticas Básicas',
    'Calcula el precio final aplicando un descuento a una variable base.',
    $THEORY$
### 🧮 1. Computadoras como Calculadoras Ultrarrápidas
Todo el software moderno (desde motores de videojuegos hasta tiendas online) realiza millones de operaciones matemáticas por segundo.

JavaScript incluye los operadores aritméticos esenciales:
- **`+` (Suma):** Suma dos números o junta textos.
- **`-` (Resta):** Resta valores.
- **`*` (Multiplicación):** Multiplica factores.
- **`/` (División):** Divide valores.

---

### 📝 2. ¿Cómo Operar con Variables?
En lugar de escribir números fijos, operamos con las **etiquetas** de nuestras variables:

```js
const precioBase = 150;
const impuesto = 30;
const precioTotal = precioBase + impuesto; // Vale 180

const descuento = 50;
const precioConDescuento = precioTotal - descuento; // Vale 130
```

---

### 💡 3. Precedencia de Operadores
Al igual que en la escuela, la multiplicación y división se resuelven antes que la suma y la resta. Si quieres cambiar el orden, utiliza paréntesis `( )`:
```js
const promedio = (10 + 8 + 6) / 3; // Correcto: suma primero, divide después
```

---

### 🎯 Tu Misión de Hoy:
Ya tienes definidas las constantes `precioOriginal` con valor `100` y `descuento` con valor `20`.
- Crea una variable llamada `precioFinal` que guarde el resultado de restar `descuento` a `precioOriginal`.
$THEORY$,
    'logic',
    $CODE$const precioOriginal = 100;
const descuento = 20;

// Calcula precioFinal aquí abajo:
let precioFinal = 0;$CODE$,
    $CODE$const precioOriginal = 100;
const descuento = 20;
let precioFinal = precioOriginal - descuento;$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof precioFinal !== "undefined", "Debes declarar la variable 'precioFinal'.");
assert(precioFinal === 80, "precioFinal debe valer exactamente 80 (100 - 20).");$TEST$,
    30,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Tomando Decisiones (If / Else)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 3: Tomando Decisiones (If / Else)',
    'Crea una función que verifique si una persona es mayor de edad (edad >= 18).',
    $THEORY$
### 🚦 1. La Lógica Condicional: El Cerebro del Software
Los programas inteligentes toman caminos diferentes dependiendo de las condiciones.
Imagina un semáforo:
- **SI** la luz es verde ➡️ Avanzar.
- **SI NO** ➡️ Detenerse.

En JavaScript usamos la estructura **`if` / `else`**:

```js
if (condicion) {
  // Código que se ejecuta si la condición es VERDADERA (true)
} else {
  // Código que se ejecuta si la condición es FALSA (false)
}
```

---

### ⚖️ 2. Operadores de Comparación Esenciales
- **`===`**: Exactamente igual (en valor y tipo).
- **`!==`**: Distinto / No igual.
- **`>` / `<`**: Mayor que / Menor que.
- **`>=` / `<=`**: Mayor o igual / Menor o igual.

---

### 📝 3. Funciones que Toman Decisiones
Una **función** es un bloque de código reutilizable que recibe datos (parámetros) y devuelve un resultado con `return`:

```js
function evaluarTemperatura(grados) {
  if (grados > 30) {
    return "Hace mucho calor";
  } else {
    return "Clima agradable";
  }
}
```

---

### ⚠️ Error Frecuente
- ❌ **Confundir `=` con `===`:**  
  Un solo `=` sirve para **guardar datos** (`let x = 10;`), mientras que `===` sirve para **comparar** (`if (x === 10)`).

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `esMayorDeEdad(edad)` que reciba un número `edad`:
- Si `edad` es mayor o igual a `18` (`edad >= 18`), debe devolver `true`.
- En caso contrario, debe devolver `false`.
$THEORY$,
    'logic',
    $CODE$function esMayorDeEdad(edad) {
  // Escribe tu estructura if / else aquí:
  
}$CODE$,
    $CODE$function esMayorDeEdad(edad) {
  if (edad >= 18) {
    return true;
  } else {
    return false;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof esMayorDeEdad === "function", "esMayorDeEdad debe ser una función.");
assert(esMayorDeEdad(20) === true, "esMayorDeEdad(20) debe retornar true.");
assert(esMayorDeEdad(15) === false, "esMayorDeEdad(15) debe retornar false.");
assert(esMayorDeEdad(18) === true, "esMayorDeEdad(18) debe retornar true para el caso límite.");$TEST$,
    40,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Automatización con Bucles (for loop)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 4: Repitiendo Tareas con Bucles (Loops)',
    'Escribe una función que sume todos los números consecutivos desde 1 hasta n.',
    $THEORY$
### 🔄 1. El Poder de la Automatización: El Bucle `for`
¿Qué pasaría si tuvieras que sumar los números del 1 al 1000? Escribir `1 + 2 + 3 + 4...` a mano sería agotador y propenso a errores.

Un **bucle `for`** permite repetir una acción tantas veces como le indiquemos de forma instantánea.

---

### 🔍 2. Anatomía de un Bucle `for` en 3 Pasos
La estructura de un `for` se divide en tres partes separadas por punto y coma `;`:

```js
for (let i = 1; i <= 5; i++) {
  // Bloque que se repetirá 5 veces
}
```

1. **Inicialización (`let i = 1`):** Se crea una variable contadora `i` y se le da su valor de inicio.
2. **Condición de parada (`i <= 5`):** El bucle seguirá ejecutándose mientras esta condición sea verdadera.
3. **Paso o incremento (`i++`):** Al terminar cada vuelta, `i++` le suma `1` a `i`.

---

### 📊 3. El Patrón del Acumulador
Para ir sumando valores a medida que el bucle avanza, creamos una variable acumuladora **afuera del bucle**:

```js
function sumarPrimerosTres() {
  let acumulador = 0; // Se crea antes de empezar
  for (let i = 1; i <= 3; i++) {
    acumulador = acumulador + i; // 0 + 1 = 1 -> 1 + 2 = 3 -> 3 + 3 = 6
  }
  return acumulador; // Retorna 6 al finalizar todas las vueltas
}
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `sumarHasta(n)` que reciba un número `n` y devuelva la suma de todos los números desde `1` hasta `n`:
- Ejemplo: Si `n = 3`, suma `1 + 2 + 3` y devuelve `6`.
- Ejemplo: Si `n = 5`, suma `1 + 2 + 3 + 4 + 5` y devuelve `15`.
$THEORY$,
    'logic',
    $CODE$function sumarHasta(n) {
  let total = 0;
  // Escribe tu bucle for aquí abajo:
  
  return total;
}$CODE$,
    $CODE$function sumarHasta(n) {
  let total = 0;
  for (let i = 1; i <= n; i++) {
    total += i;
  }
  return total;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof sumarHasta === "function", "sumarHasta debe ser una función.");
assert(sumarHasta(3) === 6, "sumarHasta(3) debe devolver 6 (1 + 2 + 3).");
assert(sumarHasta(5) === 15, "sumarHasta(5) debe devolver 15 (1 + 2 + 3 + 4 + 5).");
assert(sumarHasta(1) === 1, "sumarHasta(1) debe devolver 1.");$TEST$,
    50,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Reto Final Integrador - Tu Primer Algoritmo
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    base_module_id,
    'Lección 5: Tu Primer Algoritmo Completo',
    'Combina funciones, arreglos, bucles for y condicionales para contar exámenes aprobados (>= 60).',
    $THEORY$
### 🏆 1. El Gran Reto Integrador
¡Felicitaciones por llegar a la lección final del Módulo Inicial! 🎉

Aquí vas a combinar los 4 pilares fundamentales de la ingeniería de software:
1. **Funciones:** Para empaquetar una tarea reutilizable.
2. **Arreglos (`Array []`):** Listas ordenadas que contienen múltiples datos (ej: `[70, 45, 90, 60]`).
3. **Bucles (`for...of`):** Para recorrer cada nota de la lista de forma moderna y limpia.
4. **Condicionales (`if`):** Para evaluar si cada nota califica como aprobada.

---

### 🎓 2. Recorrer Listas Modernamente con `for...of`
En JavaScript moderno, podemos recorrer una lista elemento por elemento de forma super intuitiva:

```js
const edades = [12, 25, 18, 30];
let mayores = 0;

for (let edad of edades) {
  if (edad >= 18) {
    mayores++; // Suma 1 al contador
  }
}
// mayores valdrá 3
```

---

### 📋 3. Estrategia Paso a Paso para Resolver el Reto:
1. Declara una variable `aprobados = 0` antes de comenzar a iterar.
2. Usa un bucle `for (let nota of notas)` para examinar cada calificación.
3. Dentro del bucle, usa un `if (nota >= 60)` para detectar si la nota es aprobatoria.
4. Si la condición se cumple, incrementa tu contador: `aprobados++`.
5. Al final de la función, haz `return aprobados;`.

---

### 🎯 Tu Misión:
Crea la función `contarAprobados(notas)` que reciba una lista de números `notas` y devuelva la cantidad total de notas que son mayores o iguales a `60`.
$THEORY$,
    'logic',
    $CODE$function contarAprobados(notas) {
  let aprobados = 0;
  // 1. Recorre la lista de notas con un bucle
  // 2. Si la nota es >= 60, incrementa aprobados
  
  return aprobados;
}$CODE$,
    $CODE$function contarAprobados(notas) {
  let aprobados = 0;
  for (let nota of notas) {
    if (nota >= 60) {
      aprobados++;
    }
  }
  return aprobados;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof contarAprobados === "function", "contarAprobados debe ser una función.");
assert(contarAprobados([50, 70, 80, 40, 60]) === 3, "Para [50, 70, 80, 40, 60] debe devolver 3 (70, 80 y 60).");
assert(contarAprobados([10, 20, 30]) === 0, "Para [10, 20, 30] debe devolver 0.");
assert(contarAprobados([100, 90, 85]) === 3, "Para [100, 90, 85] debe devolver 3.");$TEST$,
    75,
    5
  );

END $$;
