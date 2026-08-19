-- ==============================================================================
-- 🌐 CODIFY SEED: MÓDULO 3 - PROTOTIPADO WEB INTERACTIVO (10 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 3 sin borrar ni alterar los demás módulos.
-- ==============================================================================

DO $$
DECLARE
  web_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)'
  );
  DELETE FROM public.modules WHERE title = 'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)';

  -- 2. Creación del Módulo 3
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)',
    'Aprende desarrollo web completo: Etiquetas HTML5, Estilos CSS, Layouts Flexbox, Manipulación del DOM y Eventos.',
    1
  )
  RETURNING id INTO web_module_id;

  -- Web Lección 1
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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
    web_module_id,
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

END $$;
