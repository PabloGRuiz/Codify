-- ==============================================================================
-- 🚀 MASTER CURRICULUM SEED SCRIPT FOR CODIFY (25 LECCIONES TOTALES - 4 MÓDULOS)
-- ==============================================================================
-- Este script maestro:
-- 1. Limpia las tablas borrando módulos, retos y el progreso anterior.
-- 2. Inserta Módulo 1 (Curso Inicial - 5 lecciones).
-- 3. Inserta Módulo 2 (Programación Orientada a Objetos POO - 5 lecciones).
-- 4. Inserta Módulo 3 (Prototipado Web Completo HTML/CSS/JS DOM - 10 lecciones).
-- 5. Inserta Módulo 4 (Asincronismo y Consumo de APIs Fetch/Async - 5 lecciones).
-- Total: 4 Módulos y 25 Lecciones gamificadas listas con Unit Tests.
-- ==============================================================================

DO $$
DECLARE
  mod1_id UUID;
  mod2_id UUID;
  mod3_id UUID;
  mod4_id UUID;
BEGIN

  -- ----------------------------------------------------------------------------
  -- 0. LIMPIEZA DE TABLAS DE CONTENIDO
  -- ----------------------------------------------------------------------------
  DELETE FROM public.user_progress;
  DELETE FROM public.challenges;
  DELETE FROM public.modules;

  -- ----------------------------------------------------------------------------
  -- 1. MÓDULO 1: CURSO INICIAL: APRENDE A PROGRAMAR DESDE CERO (5 LECCIONES)
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
- Suma: `+` | Resta: `-` | Multiplicación: `*` | División: `/`

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
assert(precioConDescuento === 150, "precioConDescuento debe ser 150");$TEST$,
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

### 🎯 Tu Misión:
Escribe una función `evaluarPuntaje(puntos)` que devuelva `"Ganador"` si `puntos` es mayor o igual a `100`, y `"Sigue intentando"` en caso contrario.
$THEORY$,
    'logic',
    $CODE$function evaluarPuntaje(puntos) {
  // Tu código aquí
}$CODE$,
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
  -- 2. MÓDULO 2: PROGRAMACIÓN ORIENTADA A OBJETOS (POO - 5 LECCIONES)
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
assert(m.nombre === "Gandalf" && m.hp === 100 && m.mana === 50, "Mago debe heredar de Personaje");
m.lanzarHechizo(o);
assert(m.mana === 30, "Lanzar hechizo resta 20 mana");
assert(o.hp === 10, "Lanzar hechizo resta 40 hp al enemigo");$TEST$,
    100,
    5
  );


  -- ----------------------------------------------------------------------------
  -- 3. MÓDULO 3: PROTOTIPADO WEB COMPLETO (10 LECCIONES)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)',
    'Aprende desarrollo web completo: Etiquetas HTML5, Estilos CSS, Layouts Flexbox, Manipulación del DOM y Eventos.',
    1
  )
  RETURNING id INTO mod3_id;

  -- Web Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 1: Estructura Básica HTML5',
    'Crea un encabezado h1 y un párrafo p en HTML.',
    $THEORY$
### 🌐 Los Cimientos de la Web: HTML5
- `<h1>`: Encabezado principal.
- `<p>`: Párrafo de texto.

### 🎯 Tu Misión:
Crea la función `crearEstructuraBase()` que inserte en `document.body` un `<h1>` con texto `"Mi Portafolio Web"` y un `<p id="presentacion">` con texto `"Desarrollador en formación"`.
$THEORY$,
    'web',
    $CODE$function crearEstructuraBase() {
  // Tu código aquí:
}$CODE$,
    $CODE$function crearEstructuraBase() {
  const h1 = document.createElement("h1");
  h1.textContent = "Mi Portafolio Web";
  const p = document.createElement("p");
  p.id = "presentacion";
  p.textContent = "Desarrollador en formación";
  document.body.appendChild(h1);
  document.body.appendChild(p);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearEstructuraBase();
const h1 = document.querySelector("h1");
const p = document.getElementById("presentacion");
assert(h1 && h1.textContent === "Mi Portafolio Web", "Debe existir h1 con texto 'Mi Portafolio Web'");
assert(p && p.textContent === "Desarrollador en formación", "Debe existir p#presentacion");$TEST$,
    30,
    1
  );

  -- Web Lección 2
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 2: Enlaces e Imágenes (a & img)',
    'Conecta elementos multimedia usando atributos href y src.',
    $THEORY$
### 🔗 Hipervínculos e Imágenes
- `<a>`: Atributo `href` para enlaces.
- `<img>`: Atributo `src` para imágenes.

### 🎯 Tu Misión:
Crea `agregarMultimedia()` que agregue a `document.body` un `<a id="linkCodify">` con `href="https://codify.dev"` y un `<img id="fotoPerfil">` con `src="https://via.placeholder.com/150"`.
$THEORY$,
    'web',
    $CODE$function agregarMultimedia() {
  // Tu código aquí:
}$CODE$,
    $CODE$function agregarMultimedia() {
  const a = document.createElement("a");
  a.id = "linkCodify";
  a.href = "https://codify.dev";
  a.textContent = "Visitar Codify";
  const img = document.createElement("img");
  img.id = "fotoPerfil";
  img.src = "https://via.placeholder.com/150";
  document.body.appendChild(a);
  document.body.appendChild(img);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
agregarMultimedia();
const a = document.getElementById("linkCodify");
const img = document.getElementById("fotoPerfil");
assert(a && a.getAttribute("href") === "https://codify.dev", "Enlace con href correcto");
assert(img && img.getAttribute("src") === "https://via.placeholder.com/150", "Imagen con src correcto");$TEST$,
    35,
    2
  );

  -- Web Lección 3
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 3: Listas Desordenadas (ul y li)',
    'Crea un menú de navegación mediante una lista de elementos.',
    $THEORY$
### 📋 Menús de Navegación
Las listas `<ul>` con elementos `<li>` son ideales para estructurar barras de navegación.

### 🎯 Tu Misión:
Crea `crearMenu()` que agregue un `<ul id="menuNav">` con 3 `<li>`: `"Inicio"`, `"Proyectos"` y `"Contacto"`.
$THEORY$,
    'web',
    $CODE$function crearMenu() {
  // Tu código aquí:
}$CODE$,
    $CODE$function crearMenu() {
  const ul = document.createElement("ul");
  ul.id = "menuNav";
  ["Inicio", "Proyectos", "Contacto"].forEach(t => {
    const li = document.createElement("li");
    li.textContent = t;
    ul.appendChild(li);
  });
  document.body.appendChild(ul);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearMenu();
const ul = document.getElementById("menuNav");
assert(ul !== null, "Existe ul#menuNav");
const lis = ul.querySelectorAll("li");
assert(lis.length === 3, "Tiene 3 elementos li");$TEST$,
    40,
    3
  );

  -- Web Lección 4
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 4: Estilos CSS (Color y Fondo)',
    'Aplica estilos visuales básicos a elementos mediante la propiedad style.',
    $THEORY$
### 🎨 CSS: Dando Vida Visual a la Web
- `color`: Color del texto.
- `backgroundColor`: Color de fondo.
- `textAlign`: Alineación del texto.

### 🎯 Tu Misión:
Crea `aplicarEstilosBase(elemento)` que asigne: `color = "white"`, `backgroundColor = "#1e1e2e"` y `textAlign = "center"`.
$THEORY$,
    'web',
    $CODE$function aplicarEstilosBase(elemento) {
  // Tu código aquí:
}$CODE$,
    $CODE$function aplicarEstilosBase(elemento) {
  elemento.style.color = "white";
  elemento.style.backgroundColor = "#1e1e2e";
  elemento.style.textAlign = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
aplicarEstilosBase(div);
assert(div.style.color === "white", "color debe ser white");
assert(div.style.textAlign === "center", "textAlign debe ser center");$TEST$,
    45,
    4
  );

  -- Web Lección 5
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 5: El Modelo de Caja CSS (Box Model)',
    'Configura el espacio interno (padding) y bordes de un botón.',
    $THEORY$
### 📦 Modelo de Caja (Box Model)
- `padding`: Espacio interior.
- `borderRadius`: Esquinas redondeadas.
- `cursor`: Tipo de puntero del ratón.

### 🎯 Tu Misión:
Crea `estilizarBoton(boton)` que asigne: `padding = "12px 24px"`, `borderRadius = "8px"`, `border = "none"` y `cursor = "pointer"`.
$THEORY$,
    'web',
    $CODE$function estilizarBoton(boton) {
  // Tu código aquí:
}$CODE$,
    $CODE$function estilizarBoton(boton) {
  boton.style.padding = "12px 24px";
  boton.style.borderRadius = "8px";
  boton.style.border = "none";
  boton.style.cursor = "pointer";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const btn = document.createElement("button");
estilizarBoton(btn);
assert(btn.style.padding === "12px 24px", "padding es 12px 24px");
assert(btn.style.borderRadius === "8px", "borderRadius es 8px");$TEST$,
    50,
    5
  );

  -- Web Lección 6
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 6: Flexbox y Alineación Horizontal',
    'Alinea elementos dentro de un contenedor usando display flex.',
    $THEORY$
### 📐 Flexbox
- `display = "flex"`
- `justifyContent = "space-between"`
- `alignItems = "center"`

### 🎯 Tu Misión:
Crea `convertirEnFlex(contenedor)` que asigne en `contenedor.style`: `display = "flex"`, `justifyContent = "space-between"` y `alignItems = "center"`.
$THEORY$,
    'web',
    $CODE$function convertirEnFlex(contenedor) {
  // Tu código aquí:
}$CODE$,
    $CODE$function convertirEnFlex(contenedor) {
  contenedor.style.display = "flex";
  contenedor.style.justifyContent = "space-between";
  contenedor.style.alignItems = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
convertirEnFlex(div);
assert(div.style.display === "flex", "display debe ser flex");
assert(div.style.justifyContent === "space-between", "justifyContent space-between");$TEST$,
    60,
    6
  );

  -- Web Lección 7
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 7: Selección Dinámica del DOM',
    'Busca un elemento existente y cambia su contenido dinámicamente.',
    $THEORY$
### 🔍 Selección del DOM
Usa `document.getElementById("id")` para encontrar un elemento y modificar su `.textContent`.

### 🎯 Tu Misión:
Crea `actualizarMensaje(nuevoTexto)` que busque el elemento `#statusApp` y actualice su `textContent`.
$THEORY$,
    'web',
    $CODE$function actualizarMensaje(nuevoTexto) {
  // Tu código aquí:
}$CODE$,
    $CODE$function actualizarMensaje(nuevoTexto) {
  const el = document.getElementById("statusApp");
  if (el) el.textContent = nuevoTexto;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = document.createElement("p");
p.id = "statusApp";
document.body.appendChild(p);
actualizarMensaje("Sistema Activo");
assert(p.textContent === "Sistema Activo", "Modifica textContent de #statusApp");
document.body.removeChild(p);$TEST$,
    65,
    7
  );

  -- Web Lección 8
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 8: Eventos del Usuario (Click Listener)',
    'Escucha el clic de un botón y ejecuta una función de respuesta.',
    $THEORY$
### 👆 Escuchadores de Eventos
- `addEventListener("click", callback)`

### 🎯 Tu Misión:
Crea `conectarBoton(boton, callback)` que agregue un escuchador del evento `"click"` sobre `boton` llamando a `callback`.
$THEORY$,
    'web',
    $CODE$function conectarBoton(boton, callback) {
  // Tu código aquí:
}$CODE$,
    $CODE$function conectarBoton(boton, callback) {
  boton.addEventListener("click", callback);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const btn = document.createElement("button");
let ok = false;
conectarBoton(btn, () => { ok = true; });
btn.click();
assert(ok === true, "Al hacer clic ejecuta el callback");$TEST$,
    75,
    8
  );

  -- Web Lección 9
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 9: Lectura de Campos de Texto (Input Value)',
    'Obtén el texto ingresado por el usuario en un campo input.',
    $THEORY$
### 📝 Captura de Texto
Leemos la propiedad `.value` de un elemento `<input>`.

### 🎯 Tu Misión:
Crea `obtenerNombreInput(inputElem)` que retorne `inputElem.value.trim()`.
$THEORY$,
    'web',
    $CODE$function obtenerNombreInput(inputElem) {
  // Tu código aquí:
}$CODE$,
    $CODE$function obtenerNombreInput(inputElem) {
  return inputElem ? inputElem.value.trim() : "";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const inp = document.createElement("input");
inp.value = "  Codify  ";
assert(obtenerNombreInput(inp) === "Codify", "Retorna valor limpio sin espacios");$TEST$,
    85,
    9
  );

  -- Web Lección 10
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod3_id,
    'Lección 10: Proyecto Integrador - Tarjeta Interactiva de Perfil',
    'Combina HTML, CSS Flexbox y Event Listeners para crear un contador de Likes en vivo.',
    $THEORY$
### 🏆 Proyecto Integrador Web
Crea la lógica para un botón de **Likes** en una tarjeta interactiva.

### 🎯 Tu Misión:
Crea `registrarSistemaLikes(botonLike, spanContador)` que inicialice `likes = 0`, escuche clics en `botonLike`, incremente `likes++` y actualice `spanContador.textContent = likes`.
$THEORY$,
    'web',
    $CODE$function registrarSistemaLikes(botonLike, spanContador) {
  let likes = 0;
  // Tu código aquí:
}$CODE$,
    $CODE$function registrarSistemaLikes(botonLike, spanContador) {
  let likes = 0;
  botonLike.addEventListener("click", function() {
    likes++;
    spanContador.textContent = likes;
  });
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const btn = document.createElement("button");
const span = document.createElement("span");
span.textContent = "0";
registrarSistemaLikes(btn, span);
btn.click();
assert(span.textContent === "1", "1 clic = 1 like");
btn.click();
assert(span.textContent === "2", "2 clics = 2 likes");$TEST$,
    120,
    10
  );


  -- ----------------------------------------------------------------------------
  -- 4. MÓDULO 4: ASINCRONISMO Y CONSUMO DE APIS (5 LECCIONES)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)',
    'Domina la programación asincrónica en JavaScript: Promesas, consumo de APIs REST con fetch(), async/await y manejo de errores con try/catch.',
    3
  )
  RETURNING id INTO mod4_id;

  -- Modulo 4 / Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod4_id,
    'Lección 1: Creación de Promesas (Promise)',
    'Crea una promesa básica que se resuelva con un mensaje exitoso.',
    $THEORY$
### ⏳ Programación Asincrónica
En el desarrollo web moderno, tareas como pedir datos a un servidor toman tiempo. Usamos **Promesas** para manejar estos procesos.

### 🎯 Tu Misión:
Crea la función `solicitarDatos()` que devuelva una `Promise` que llame a `resolve("Datos Recibidos")`.
$THEORY$,
    'logic',
    $CODE$function solicitarDatos() {
  // Retorna una new Promise aquí:
}$CODE$,
    $CODE$function solicitarDatos() {
  return new Promise((resolve) => {
    resolve("Datos Recibidos");
  });
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const res = solicitarDatos();
assert(res instanceof Promise, "solicitarDatos() debe retornar una Promise");
res.then(val => {
  assert(val === "Datos Recibidos", "La promesa debe resolverse con 'Datos Recibidos'");
});$TEST$,
    40,
    1
  );

  -- Modulo 4 / Lección 2
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod4_id,
    'Lección 2: Consumo de Promesas con .then()',
    'Usa el método .then() para transformar la respuesta de una promesa.',
    $THEORY$
### 🔗 Encadenamiento con `.then()`
Para obtener el valor contenido dentro de una promesa resuelta, usamos el método `.then(resultado => ...)`.

### 🎯 Tu Misión:
Crea la función `procesarRespuesta(promesa)` que consuma la `promesa` recibida por parámetro y devuelva una nueva promesa que convierta el resultado a mayúsculas usando `.toUpperCase()`.
$THEORY$,
    'logic',
    $CODE$function procesarRespuesta(promesa) {
  // Tu código aquí:
}$CODE$,
    $CODE$function procesarRespuesta(promesa) {
  return promesa.then(res => res.toUpperCase());
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = Promise.resolve("codify");
const res = procesarRespuesta(p);
assert(res instanceof Promise, "Debe retornar una promesa");
res.then(val => {
  assert(val === "CODIFY", "La respuesta procesada debe ser 'CODIFY'");
});$TEST$,
    50,
    2
  );

  -- Modulo 4 / Lección 3
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod4_id,
    'Lección 3: Peticiones HTTP con fetch() y JSON',
    'Simula la conversión de una respuesta HTTP a objeto JSON.',
    $THEORY$
### 🌐 La API `fetch()`
`fetch(url)` es la herramienta nativa del navegador para enviar y recibir datos de un servidor externo (API REST). La respuesta se convierte a objeto con `.json()`.

### 🎯 Tu Misión:
Crea una función `parsearRespuestaServidor(respuestaMock)` donde `respuestaMock` contiene el método `.json()` que devuelve una promesa. Tu función debe retornar `respuestaMock.json()`.
$THEORY$,
    'logic',
    $CODE$function parsearRespuestaServidor(respuestaMock) {
  // Tu código aquí:
}$CODE$,
    $CODE$function parsearRespuestaServidor(respuestaMock) {
  return respuestaMock.json();
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const mock = { json: () => Promise.resolve({ ok: true }) };
const res = parsearRespuestaServidor(mock);
assert(res instanceof Promise, "Debe devolver la promesa de .json()");
res.then(data => {
  assert(data.ok === true, "Debe retornar el objeto JSON parseado");
});$TEST$,
    60,
    3
  );

  -- Modulo 4 / Lección 4
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod4_id,
    'Lección 4: Sintaxis Moderna con async / await',
    'Simplifica el código asincrónico escribiendo funciones marcadas con async y usando await.',
    $THEORY$
### ✨ `async` y `await`
Permiten escribir código asincrónico limpio que se lee de forma secuencial.

### 🎯 Tu Misión:
Crea la función `async obtenerPuntajeFinal(promesaPuntos)` que espere el valor numérico de `promesaPuntos` usando `await` y retorne dicho valor sumándole `50`.
$THEORY$,
    'logic',
    $CODE$async function obtenerPuntajeFinal(promesaPuntos) {
  // Tu código aquí:
}$CODE$,
    $CODE$async function obtenerPuntajeFinal(promesaPuntos) {
  const puntos = await promesaPuntos;
  return puntos + 50;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = Promise.resolve(100);
const res = obtenerPuntajeFinal(p);
assert(res instanceof Promise, "Una función async devuelve una promesa");
res.then(val => {
  assert(val === 150, "100 + 50 debe ser 150");
});$TEST$,
    75,
    4
  );

  -- Modulo 4 / Lección 5
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    mod4_id,
    'Lección 5: Proyecto Integrador - Cliente de API Robusto (try / catch)',
    'Construye un conector de API con manejo de errores elegante.',
    $THEORY$
### 🛡️ Robustez con `try / catch`
En las aplicaciones reales, envuelves tus peticiones asincrónicas en bloques `try / catch` para capturar errores de conexión de forma segura.

### 🎯 Tu Misión:
Crea la función `async consultarEstadoServidor(peticionFn)` donde `peticionFn` es una función asincrónica:
1. Dentro de un bloque `try`, ejecuta `await peticionFn()` y retorna `"Servidor Online"`.
2. Dentro del bloque `catch(err)`, retorna `"Error de Conexión"`.
$THEORY$,
    'logic',
    $CODE$async function consultarEstadoServidor(peticionFn) {
  // Tu código con try/catch aquí:
}$CODE$,
    $CODE$async function consultarEstadoServidor(peticionFn) {
  try {
    await peticionFn();
    return "Servidor Online";
  } catch (err) {
    return "Error de Conexión";
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const fnExito = async () => "ok";
const fnFallo = async () => { throw new Error("404"); };

consultarEstadoServidor(fnExito).then(r1 => {
  assert(r1 === "Servidor Online", "En éxito retorna 'Servidor Online'");
});

consultarEstadoServidor(fnFallo).then(r2 => {
  assert(r2 === "Error de Conexión", "En fallo retorna 'Error de Conexión'");
});$TEST$,
    100,
    5
  );

END $$;
