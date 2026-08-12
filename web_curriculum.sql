-- ==============================================================================
-- 🌐 MÓDULO 3 COMPLETO: PROTOTIPADO WEB BÁSICO Y AVANZADO (10 LECCIONES)
-- ==============================================================================
-- Usamos Dollar Quoting ($THEORY$, $CODE$, $TEST$) para evitar errores de comillas.

DO $$
DECLARE
  web_module_id UUID;
BEGIN

  -- 1. Crear o buscar el Módulo 3
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 3: Prototipado Web Interactivo (HTML5, CSS3 & JS DOM)',
    'Aprende desarrollo web desde cero: Etiquetas HTML5, Estilos CSS, Layouts con Flexbox, Manipulación del DOM y Eventos.',
    1
  )
  RETURNING id INTO web_module_id;

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 1: ESTRUCTURA BÁSICA HTML5 (Encabezados y Párrafos)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 1: Estructura Básica HTML5',
    'Crea un encabezado h1 y un párrafo p en HTML.',
    $THEORY$
### 🌐 Los Cimientos de la Web: HTML5
HTML es el lenguaje de etiquetas que estructura todo el contenido de una página web.

- `<h1>`: Se usa para el **título principal** de la página.
- `<p>`: Se usa para los **párrafos de texto**.

### 📝 Ejemplo de Código:
```html
<h1>Mi Primera Página Web</h1>
<p id="bio">¡Hola! Estoy aprendiendo programación en Codify.</p>
```

### 🎯 Tu Misión:
Crea una función JS `crearEstructuraBase()` que inserte en el `document.body`:
1. Un encabezado `<h1>` con el texto `"Mi Portafolio Web"`.
2. Un párrafo `<p>` con el id `"presentacion"` y el texto `"Desarrollador en formación"`.
$THEORY$,
    'web',
    $CODE$function crearEstructuraBase() {
  // Escribe tu código para modificar document.body aquí:
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
assert(h1 && h1.textContent === "Mi Portafolio Web", "Debe existir un <h1> con texto 'Mi Portafolio Web'");
assert(p && p.textContent === "Desarrollador en formación", "Debe existir un <p id='presentacion'> con texto 'Desarrollador en formación'");$TEST$,
    30,
    1
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 2: ENLACES E IMÁGENES (<a> y <img>)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 2: Enlaces e Imágenes (a & img)',
    'Conecta elementos multimedia usando atributos href y src.',
    $THEORY$
### 🔗 Hipervínculos e Imágenes
- `<a>`: Crea hipervínculos hacia otros sitios mediante el atributo `href`.
- `<img>`: Muestra imágenes en pantalla usando los atributos `src` (ruta) y `alt` (texto alternativo).

### 📝 Ejemplo de Código:
```html
<a href="https://codify.dev" target="_blank">Ir a Codify</a>
<img src="avatar.jpg" alt="Foto de Perfil" id="fotoPerfil" />
```

### 🎯 Tu Misión:
Crea la función `agregarMultimedia()` que agregue al `document.body`:
1. Un enlace `<a>` con id `"linkCodify"`, href `"https://codify.dev"` y texto `"Visitar Codify"`.
2. Una imagen `<img>` con id `"fotoPerfil"` y src `"https://via.placeholder.com/150"`.
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
assert(a && a.getAttribute("href") === "https://codify.dev", "El enlace id 'linkCodify' debe tener href='https://codify.dev'");
assert(img && img.getAttribute("src") === "https://via.placeholder.com/150", "La imagen id 'fotoPerfil' debe tener src correcto");$TEST$,
    35,
    2
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 3: LISTAS Y NAVEGACIÓN (<ul> y <li>)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 3: Listas Desordenadas (ul y li)',
    'Crea un menú de navegación mediante una lista de elementos.',
    $THEORY$
### 📋 Listas en HTML
Las listas desordenadas `<ul>` (Unordered List) se usan habitualmente para estructurar menús de navegación en sitios web.

Cada elemento de la lista se define con la etiqueta `<li>` (List Item).

### 📝 Ejemplo de Código:
```html
<ul id="menuNav">
  <li>Inicio</li>
  <li>Servicios</li>
</ul>
```

### 🎯 Tu Misión:
Crea una función `crearMenu()` que construya dentro de `document.body` una lista `<ul id="menuNav">` con 3 elementos `<li>`: `"Inicio"`, `"Proyectos"` y `"Contacto"`.
$THEORY$,
    'web',
    $CODE$function crearMenu() {
  // Tu código aquí:
}$CODE$,
    $CODE$function crearMenu() {
  const ul = document.createElement("ul");
  ul.id = "menuNav";
  ["Inicio", "Proyectos", "Contacto"].forEach(texto => {
    const li = document.createElement("li");
    li.textContent = texto;
    ul.appendChild(li);
  });
  document.body.appendChild(ul);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearMenu();
const ul = document.getElementById("menuNav");
assert(ul !== null, "Debe existir un elemento <ul id='menuNav'>");
const lis = ul.querySelectorAll("li");
assert(lis.length === 3, "El menú debe contener exactamente 3 elementos <li>");
assert(lis[0].textContent === "Inicio" && lis[1].textContent === "Proyectos" && lis[2].textContent === "Contacto", "Los ítems del menú deben ser Inicio, Proyectos y Contacto");$TEST$,
    40,
    3
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 4: ESTILOS CSS INICIALES (Colores y Fondo)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 4: Estilos CSS (Color y Fondo)',
    'Aplica estilos visuales básicos a elementos mediante la propiedad style.',
    $THEORY$
### 🎨 CSS: Dando Vida Visual a la Web
CSS (Cascading Style Sheets) controla la estética de los elementos HTML:
- `color`: Define el color del texto.
- `backgroundColor`: Define el color de fondo.
- `textAlign`: Alinea el texto (`"center"`, `"left"`, `"right"`).

### 🎯 Tu Misión:
Crea una función `aplicarEstilosBase(elemento)` que reciba un elemento HTML y le aplique:
- `color = "white"`
- `backgroundColor = "#1e1e2e"`
- `textAlign = "center"`
$THEORY$,
    'web',
    $CODE$function aplicarEstilosBase(elemento) {
  // Aplica los 3 estilos CSS al objeto elemento.style aquí:
}$CODE$,
    $CODE$function aplicarEstilosBase(elemento) {
  elemento.style.color = "white";
  elemento.style.backgroundColor = "#1e1e2e";
  elemento.style.textAlign = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
aplicarEstilosBase(div);
assert(div.style.color === "white", "El estilo color debe ser 'white'");
assert(div.style.backgroundColor === "rgb(30, 30, 46)" || div.style.backgroundColor === "#1e1e2e", "El backgroundColor debe ser '#1e1e2e'");
assert(div.style.textAlign === "center", "El textAlign debe ser 'center'");$TEST$,
    45,
    4
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 5: EL MODELO DE CAJA CSS (Margin, Padding y Border)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 5: El Modelo de Caja CSS (Box Model)',
    'Configura el espacio interno (padding) y bordes de un botón.',
    $THEORY$
### 📦 El Modelo de Caja CSS (Box Model)
Cada elemento en una página web es una caja rectangular compuesta por:
1. **Content**: El contenido (texto/imagen).
2. **Padding**: Espacio interior entre el contenido y el borde.
3. **Border**: El borde alrededor del elemento.
4. **Margin**: Espacio exterior fuera del borde.

### 🎯 Tu Misión:
Crea una función `estilizarBoton(boton)` que aplique a un elemento `<button>`:
- `padding = "12px 24px"`
- `borderRadius = "8px"`
- `border = "none"`
- `cursor = "pointer"`
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
assert(btn.style.padding === "12px 24px", "padding debe ser '12px 24px'");
assert(btn.style.borderRadius === "8px", "borderRadius debe ser '8px'");
assert(btn.style.cursor === "pointer", "cursor debe ser 'pointer'");$TEST$,
    50,
    5
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 6: LAYOUT MODERNO CON CSS FLEXBOX
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 6: Flexbox y Alineación Horizontal',
    'Alinea elementos dentro de un contenedor usando display flex.',
    $THEORY$
### 📐 Flexbox: Diseños Modernos y Responsivos
Flexbox permite alinear elementos en fila o columna de forma limpia y flexible.

Propiedades clave:
- `display: "flex"`
- `justifyContent: "space-between"` (distribuye espacio)
- `alignItems: "center"` (centra verticalmente)

### 🎯 Tu Misión:
Crea una función `convertirEnFlex(contenedor)` que configure en `contenedor.style`:
- `display = "flex"`
- `justifyContent = "space-between"`
- `alignItems = "center"`
$THEORY$,
    'web',
    $CODE$function convertirEnFlex(contenedor) {
  // Configura los estilos flexbox aquí:
}$CODE$,
    $CODE$function convertirEnFlex(contenedor) {
  contenedor.style.display = "flex";
  contenedor.style.justifyContent = "space-between";
  contenedor.style.alignItems = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
convertirEnFlex(div);
assert(div.style.display === "flex", "display debe ser 'flex'");
assert(div.style.justifyContent === "space-between", "justifyContent debe ser 'space-between'");
assert(div.style.alignItems === "center", "alignItems debe ser 'center'");$TEST$,
    60,
    6
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 7: SELECCIÓN Y MODIFICACIÓN DEL DOM DESDE JS
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 7: Selección Dinámica del DOM',
    'Busca un elemento existente y cambia su contenido dinámicamente.',
    $THEORY$
### 🔍 Seleccionando Elementos en el DOM
Con `document.getElementById("miId")` o `document.querySelector(".miClase")`, JavaScript puede localizar cualquier elemento de la página e interactuar con él en tiempo real.

### 🎯 Tu Misión:
Crea una función `actualizarMensaje(nuevoTexto)` que busque el elemento con id `"statusApp"` y actualice su `textContent` con `nuevoTexto`.
$THEORY$,
    'web',
    $CODE$function actualizarMensaje(nuevoTexto) {
  // Tu código aquí:
}$CODE$,
    $CODE$function actualizarMensaje(nuevoTexto) {
  const elem = document.getElementById("statusApp");
  if (elem) {
    elem.textContent = nuevoTexto;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = document.createElement("p");
p.id = "statusApp";
document.body.appendChild(p);
actualizarMensaje("Sistema Conectado");
assert(p.textContent === "Sistema Conectado", "El textContent de #statusApp debe ser 'Sistema Conectado'");
document.body.removeChild(p);$TEST$,
    65,
    7
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 8: MANEJO DE EVENTOS (addEventListener)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 8: Eventos del Usuario (Click Listener)',
    'Escucha el clic de un botón y ejecuta una función de respuesta.',
    $THEORY$
### 👆 Reaccionando a Interacciones del Usuario
El método `addEventListener("click", callback)` registra un escuchador que se ejecuta automáticamente cuando el usuario hace clic sobre un botón o elemento.

### 📝 Ejemplo de Código:
```js
const miBoton = document.getElementById("btnAccion");
miBoton.addEventListener("click", function() {
  console.log("¡Hicieron clic!");
});
```

### 🎯 Tu Misión:
Crea una función `conectarBoton(boton, callback)` que registre un escuchador de evento `"click"` sobre el `boton` ejecutando la función `callback`.
$THEORY$,
    'web',
    $CODE$function conectarBoton(boton, callback) {
  // Añade el addEventListener aquí:
}$CODE$,
    $CODE$function conectarBoton(boton, callback) {
  boton.addEventListener("click", callback);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const btn = document.createElement("button");
let ejecutado = false;
conectarBoton(btn, () => { ejecutado = true; });
btn.click();
assert(ejecutado === true, "Al hacer clic en el botón debe ejecutarse la función callback");$TEST$,
    75,
    8
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 9: FORMULARIOS E INPUTS DE USUARIO (<input> y .value)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 9: Lectura de Campos de Texto (Input Value)',
    'Obtén el texto ingresado por el usuario en un campo input.',
    $THEORY$
### 📝 Capturando Datos con Inputs
Los elementos `<input type="text">` permiten al usuario escribir datos. Desde JavaScript leemos su contenido mediante la propiedad `.value`.

### 🎯 Tu Misión:
Crea una función `obtenerNombreInput(inputElem)` que retorne el valor ingresado en `inputElem.value` de forma limpia (sin espacios extra al inicio/final usando `.trim()`).
$THEORY$,
    'web',
    $CODE$function obtenerNombreInput(inputElem) {
  // Retorna inputElem.value limpio aquí:
}$CODE$,
    $CODE$function obtenerNombreInput(inputElem) {
  return inputElem ? inputElem.value.trim() : "";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const inp = document.createElement("input");
inp.value = "   Pablo   ";
assert(obtenerNombreInput(inp) === "Pablo", "Debe retornar el valor del input sin espacios ('Pablo')");$TEST$,
    85,
    9
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 10: RETO FINAL INTEGRADOR - TARJETA INTERACTIVA DE PERFIL (MINI-WEB)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    web_module_id,
    'Lección 10: Proyecto Integrador - Tarjeta Interactiva de Perfil',
    'Combina HTML, CSS Flexbox y Event Listeners para crear un contador de Likes en vivo.',
    $THEORY$
### 🏆 Proyecto Integrador del Módulo Web
¡Felicitaciones por llegar a la lección final! En este proyecto integrador combinarás todo lo aprendido:
- HTML5 para estructurar una tarjeta de usuario.
- CSS Flexbox para centrar y estilizar los elementos.
- JavaScript y Eventos para hacer que el botón de **"Dar Like"** funcione e incremente el contador dinámicamente.

### 🎯 Tu Misión:
Crea una función `registrarSistemaLikes(botonLike, spanContador)` que:
1. Mantenga una variable interna `likes = 0`.
2. Escuche el evento `"click"` sobre `botonLike`.
3. En cada clic, incremente `likes++` y actualice `spanContador.textContent = likes`.
$THEORY$,
    'web',
    $CODE$function registrarSistemaLikes(botonLike, spanContador) {
  let likes = 0;
  // Registra el escuchador de eventos click aquí:
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
assert(span.textContent === "1", "Luego de 1 clic, spanContador debe valer '1'");
btn.click();
assert(span.textContent === "2", "Luego de 2 clics, spanContador debe valer '2'");$TEST$,
    120,
    10
  );

END $$;
