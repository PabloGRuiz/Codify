-- ==============================================================================
-- 🚀 MASTER CURRICULUM SEED SCRIPT FOR CODIFY
-- ==============================================================================
-- Este script:
-- 1. Limpia las tablas borrando módulos, retos y el progreso anterior.
-- 2. Inserta los 3 Módulos oficiales sin duplicados.
-- 3. Inserta las 13 lecciones prácticas completas con sus Unit Tests ocultos.
-- ==============================================================================

DO $$
DECLARE
  mod1_id UUID;
  mod2_id UUID;
  mod3_id UUID;
BEGIN

  -- ----------------------------------------------------------------------------
  -- 0. LIMPIEZA DE TABLAS DE CONTENIDO
  -- ----------------------------------------------------------------------------
  DELETE FROM public.user_progress;
  DELETE FROM public.challenges;
  DELETE FROM public.modules;

  -- ----------------------------------------------------------------------------
  -- 1. MÓDULO 1: CURSO INICIAL: APRENDE A PROGRAMAR DESDE CERO
  -- ----------------------------------------------------------------------------
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Curso Inicial: Aprende a Programar desde Cero',
    'Primer segmento esencial: Variables, Matemáticas, Condicionales, Bucles y Funciones.',
    1
  )
  RETURNING id INTO mod1_id;

  -- Modulo 1 / Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod1_id,
    'Lección 1: Variables y Contenedores de Datos',
    'Declara una constante llamada "nombrePlataforma" con valor "Codify" y una variable "nivelInicial" con valor 1.',
    $THEORY$
### 📦 ¿Qué es una Variable?
Piensa en una variable como una **caja etiquetada** donde guardas información para usarla después.

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
Declara una constante llamada `nombrePlataforma` asignándole el texto `"Codify"` y una variable llamada `nivelInicial` asignándole el número `1`.
$THEORY$,
    'logic',
    $CODE$// Declara tus variables aquí abajo:
$CODE$,
    $CODE$const nombrePlataforma = "Codify";
let nivelInicial = 1;$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof nombrePlataforma !== "undefined", "Falta declarar la constante nombrePlataforma");
assert(nombrePlataforma === "Codify", "nombrePlataforma debe ser exactamente 'Codify'");
assert(typeof nivelInicial !== "undefined", "Falta declarar la variable nivelInicial");
assert(nivelInicial === 1, "nivelInicial debe ser igual a 1");$TEST$,
    25,
    1
  );

  -- Modulo 1 / Lección 2
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod1_id,
    'Lección 2: Operaciones Matemáticas Básicas',
    'Calcula el precio final aplicando un descuento.',
    $THEORY$
### ➕ Operadores Matemáticos
JavaScript te permite hacer cálculos como una calculadora:
- Suma: `+`
- Resta: `-`
- Multiplicación: `*`
- División: `/`

### 📝 Ejemplo de Código:
```js
const precioBase = 100;
const descuento = 20;
const precioFinal = precioBase - descuento; // 80
```

### 🎯 Tu Misión:
Se te da una variable `precioOriginal = 200`. Crea una variable `precioConDescuento` que contenga el resultado de restar `50` a `precioOriginal`.
$THEORY$,
    'logic',
    $CODE$const precioOriginal = 200;
// Crea la variable precioConDescuento aquí:
$CODE$,
    $CODE$const precioOriginal = 200;
const precioConDescuento = precioOriginal - 50;$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof precioConDescuento !== "undefined", "Falta declarar precioConDescuento");
assert(precioConDescuento === 150, "precioConDescuento debe ser 150 (200 - 50)");$TEST$,
    30,
    2
  );

  -- Modulo 1 / Lección 3
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod1_id,
    'Lección 3: Tomando Decisiones (If / Else)',
    'Escribe una condición para verificar si un jugador gana o pierde.',
    $THEORY$
### 🚦 Condicionales (if / else)
Los programas toman decisiones evaluando si algo es verdadero (`true`) o falso (`false`).

### 📝 Ejemplo de Código:
```js
let vida = 50;
if (vida > 0) {
  console.log("Sigue vivo");
} else {
  console.log("Game Over");
}
```

### 🎯 Tu Misión:
Escribe una función `evaluarPuntaje(puntos)` que devuelva `"Ganador"` si `puntos` es mayor o igual a `100`, y `"Sigue intentando"` en caso contrario.
$THEORY$,
    'logic',
    $CODE$function evaluarPuntaje(puntos) {
  // Tu código aquí
}
$CODE$,
    $CODE$function evaluarPuntaje(puntos) {
  if (puntos >= 100) {
    return "Ganador";
  } else {
    return "Sigue intentando";
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof evaluarPuntaje === "function", "evaluarPuntaje debe ser una función");
assert(evaluarPuntaje(120) === "Ganador", "evaluarPuntaje(120) debe devolver 'Ganador'");
assert(evaluarPuntaje(80) === "Sigue intentando", "evaluarPuntaje(80) debe devolver 'Sigue intentando'");$TEST$,
    40,
    3
  );

  -- Modulo 1 / Lección 4
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod1_id,
    'Lección 4: Repetición y Bucles (for loop)',
    'Suma los números del 1 al 5 usando un bucle for.',
    $THEORY$
### 🔄 Bucles `for`
Cuando necesitas repetir una tarea varias veces, usas un bucle.

### 📝 Ejemplo de Código:
```js
for (let i = 1; i <= 3; i++) {
  console.log("Vuelta " + i);
}
```

### 🎯 Tu Misión:
Crea una función `sumarHastaCinco()` que use un bucle para sumar los números del 1 al 5 y devuelva el total (15).
$THEORY$,
    'logic',
    $CODE$function sumarHastaCinco() {
  let suma = 0;
  // Escribe tu bucle for aquí
  return suma;
}$CODE$,
    $CODE$function sumarHastaCinco() {
  let suma = 0;
  for (let i = 1; i <= 5; i++) {
    suma += i;
  }
  return suma;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof sumarHastaCinco === "function", "sumarHastaCinco debe ser una función");
assert(sumarHastaCinco() === 15, "sumarHastaCinco() debe devolver 15");$TEST$,
    50,
    4
  );

  -- Modulo 1 / Lección 5
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod1_id,
    'Lección 5: Reto Final del Segmento 1',
    'Crea una función contarPositivos(numeros) que cuente cuántos números mayores a 0 hay en una lista.',
    $THEORY$
### 🏆 Reto Final del Segmento Inicial
Aquí combinarás todo lo aprendido: Funciones, Arreglos (`[]`), Bucles (`for`) y Condicionales (`if`).

### 🎯 Tu Misión:
Crea la función `contarPositivos(numeros)` que reciba una lista de números y devuelva cuántos de ellos son mayores que 0.
$THEORY$,
    'logic',
    $CODE$function contarPositivos(numeros) {
  let contador = 0;
  // Tu código aquí
  return contador;
}$CODE$,
    $CODE$function contarPositivos(numeros) {
  let contador = 0;
  for (let num of numeros) {
    if (num > 0) {
      contador++;
    }
  }
  return contador;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof contarPositivos === "function", "contarPositivos debe ser una función");
assert(contarPositivos([1, -2, 3, 0, 5]) === 3, "Debe devolver 3 para [1, -2, 3, 0, 5]");
assert(contarPositivos([-1, -5]) === 0, "Debe devolver 0 para [-1, -5]");$TEST$,
    75,
    5
  );


  -- ----------------------------------------------------------------------------
  -- 2. MÓDULO 2: PROGRAMACIÓN ORIENTADA A OBJETOS (POO)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 2: Programación Orientada a Objetos (POO)',
    'Aprende a modelar entidades del mundo real usando Objetos Literales, Clases, Métodos, Herencia y Encapsulamiento.',
    2
  )
  RETURNING id INTO mod2_id;

  -- Modulo 2 / Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod2_id,
    'Lección 1: Objetos Literales y Propiedades',
    'Crea un objeto literal llamado "personaje" con las propiedades nombre, hp y nivel.',
    $THEORY$
### 🛡️ ¿Qué es un Objeto Literal?
En JavaScript, un **Objeto Literal** nos permite agrupar múltiples datos relacionados dentro de llaves `{ }`.

### 🎯 Tu Misión:
Crea un objeto literal asignado a la constante `personaje` con las propiedades: `nombre: "Heroe"`, `hp: 100` y `nivel: 1`.
$THEORY$,
    'logic',
    $CODE$const personaje = {
  // Escribe las propiedades aquí:
};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  nivel: 1
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje === "object" && personaje !== null, "personaje debe ser un objeto");
assert(personaje.nombre === "Heroe", "personaje.nombre debe ser 'Heroe'");
assert(personaje.hp === 100, "personaje.hp debe ser 100");
assert(personaje.nivel === 1, "personaje.nivel debe ser 1");$TEST$,
    30,
    1
  );

  -- Modulo 2 / Lección 2
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod2_id,
    'Lección 2: Métodos y la palabra clave "this"',
    'Agrega un método recibirDanio(cantidad) al objeto personaje.',
    $THEORY$
### ⚡ Métodos y `this`
Una función dentro de un objeto se llama **Método**. Para acceder a las propiedades de ese mismo objeto se usa `this`.

### 🎯 Tu Misión:
Agrega un método `recibirDanio(cantidad)` al objeto `personaje` que reste la `cantidad` recibida a `this.hp`.
$THEORY$,
    'logic',
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  // Agrega el método recibirDanio aquí:
};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  recibirDanio: function(cantidad) {
    this.hp -= cantidad;
  }
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje.recibirDanio === "function", "recibirDanio debe ser un método del objeto");
personaje.recibirDanio(30);
assert(personaje.hp === 70, "Luego de recibirDanio(30), hp debe valer 70");$TEST$,
    40,
    2
  );

  -- Modulo 2 / Lección 3
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod2_id,
    'Lección 3: Clases y el Constructor (class)',
    'Crea la clase Personaje con un constructor que asigne nombre y hp.',
    $THEORY$
### 🏭 Clases: El Molde para Crear Objetos
Con la palabra clave `class` y el método especial `constructor()`, podemos instanciar múltiples objetos con `new`.

### 🎯 Tu Misión:
Crea la clase `Personaje` con un `constructor(nombre, hp)` que inicialice `this.nombre` y `this.hp`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  // Escribe el constructor aquí
}$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = new Personaje("Mago", 80);
assert(p.nombre === "Mago", "El nombre de la instancia debe ser 'Mago'");
assert(p.hp === 80, "El hp de la instancia debe ser 80");$TEST$,
    50,
    3
  );

  -- Modulo 2 / Lección 4
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod2_id,
    'Lección 4: Estado del Objeto y Métodos de Combate',
    'Añade métodos estaVivo() y atacar(enemigo, danio) a la clase Personaje.',
    $THEORY$
### ⚔️ Métodos de Estado
Añade a la clase `Personaje`:
1. `estaVivo()`: Devuelve `true` si `this.hp > 0`, o `false` de lo contrario.
2. `atacar(enemigo, danio)`: Resta `danio` a la propiedad `hp` de `enemigo`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
  // Agrega estaVivo() y atacar(enemigo, danio) aquí:
}$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }

  estaVivo() {
    return this.hp > 0;
  }

  atacar(enemigo, danio) {
    enemigo.hp -= danio;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p1 = new Personaje("Guerrero", 100);
const p2 = new Personaje("Orco", 30);
assert(p1.estaVivo() === true, "p1.estaVivo() debe ser true");
p1.atacar(p2, 40);
assert(p2.hp === -10, "p2.hp debe ser -10");
assert(p2.estaVivo() === false, "p2.estaVivo() debe ser false");$TEST$,
    60,
    4
  );

  -- Modulo 2 / Lección 5
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod2_id,
    'Lección 5: Herencia POO (extends & super)',
    'Crea la clase Mago que herede de Personaje e incluya la propiedad mana y el método lanzarHechizo.',
    $THEORY$
### 🏆 Herencia con `extends`
La herencia permite crear clases especializadas reutilizando una clase base. Usamos `super(...)` para invocar al constructor padre.

### 🎯 Tu Misión:
Crea la clase `Mago` que extienda de `Personaje` con constructor `(nombre, hp, mana)` y método `lanzarHechizo(enemigo)` que reste 20 de mana a `this.mana` y 40 de vida al `enemigo`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

// Crea la clase Mago aquí:
$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

class Mago extends Personaje {
  constructor(nombre, hp, mana) {
    super(nombre, hp);
    this.mana = mana;
  }

  lanzarHechizo(enemigo) {
    this.mana -= 20;
    enemigo.hp -= 40;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const m = new Mago("Gandalf", 100, 50);
const o = new Personaje("Orco", 50);
assert(m.nombre === "Gandalf" && m.hp === 100 && m.mana === 50, "Mago debe heredar de Personaje y tener mana");
m.lanzarHechizo(o);
assert(m.mana === 30, "Lanzar hechizo resta 20 mana");
assert(o.hp === 10, "Lanzar hechizo resta 40 hp al enemigo");$TEST$,
    100,
    5
  );


  -- ----------------------------------------------------------------------------
  -- 3. MÓDULO 3: PROTOTIPADO WEB BÁSICO (HTML / CSS / JS)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 3: Prototipado Web Básico',
    'Crea tus primeras interfaces web con HTML5, estilos CSS3 y manipulación del DOM.',
    1
  )
  RETURNING id INTO mod3_id;

  -- Modulo 3 / Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 1: Estructura HTML y Selección del DOM',
    'Obtén un elemento por su ID y cambia su contenido usando textContent.',
    $THEORY$
### 🌐 Manipulación del DOM
El DOM (Document Object Model) es el árbol de elementos de la página web. Con JavaScript podemos seleccionar elementos con `document.getElementById()` y modificar su texto.

### 🎯 Tu Misión:
Crea una función `cambiarTitulo(nuevoTexto)` que busque el elemento con id `"titulo"` y cambie su `textContent` por `nuevoTexto`.
$THEORY$,
    'logic',
    $CODE$function cambiarTitulo(nuevoTexto) {
  // Tu código aquí:
}$CODE$,
    $CODE$function cambiarTitulo(nuevoTexto) {
  const el = document.getElementById("titulo");
  if (el) el.textContent = nuevoTexto;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const dummy = document.createElement("h1");
dummy.id = "titulo";
document.body.appendChild(dummy);
cambiarTitulo("Hola Codify");
assert(dummy.textContent === "Hola Codify", "El textContent del elemento #titulo debe ser 'Hola Codify'");
document.body.removeChild(dummy);$TEST$,
    35,
    1
  );

END $$;
