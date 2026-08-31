-- ==============================================================================
-- 🌐 CODIFY SEED: 16 - CURSO COMPLETO: FUNDAMENTOS DE LA PROGRAMACIÓN WEB
-- ==============================================================================
-- Curso estructurado en 3 Módulos Progresivos (12 Lecciones Prácticas e Interactivas)
-- Módulo 1: HTML5 Puro (Estructura, Semántica, Formularios, a11y)
-- Módulo 2: CSS3 Moderno (Box Model, Flexbox, CSS Grid, Variables)
-- Módulo 3: JavaScript & DOM (Manipulación del DOM, Eventos, Mini-Apps)
-- ==============================================================================

DO $$
DECLARE
    v_course_id UUID;
    v_m1_id UUID;
    v_m2_id UUID;
    v_m3_id UUID;
BEGIN

    -- 0. Limpieza segura previa (Idempotente)
    DELETE FROM public.user_progress WHERE challenge_id IN (
        SELECT c.id FROM public.challenges c
        JOIN public.modules m ON c.module_id = m.id
        JOIN public.courses co ON m.course_id = co.id
        WHERE co.title = 'Fundamentos de la Programación Web'
    );
    DELETE FROM public.challenges WHERE module_id IN (
        SELECT m.id FROM public.modules m
        JOIN public.courses co ON m.course_id = co.id
        WHERE co.title = 'Fundamentos de la Programación Web'
    );
    DELETE FROM public.modules WHERE course_id IN (
        SELECT id FROM public.courses WHERE title = 'Fundamentos de la Programación Web'
    );
    DELETE FROM public.courses WHERE title = 'Fundamentos de la Programación Web';

    -- 1. Creación del Curso
    INSERT INTO public.courses (title, description, image_url, tags, status)
    VALUES (
        'Fundamentos de la Programación Web',
        'Aprende a construir la web desde sus cimientos: arquitectura cliente-servidor, HTML5 semántico directo, maquetación moderna con CSS3 (Flexbox & Grid) y dinamismo interactivo manipulando el DOM con JavaScript.',
        '/images/courses/web-fundamentals.jpg',
        ARRAY['Práctico', 'Web', 'HTML5', 'CSS3', 'JavaScript', 'Frontend'],
        'published'
    )
    RETURNING id INTO v_course_id;

    -- ==============================================================================
    -- 📌 MÓDULO 1: ARQUITECTURA WEB Y ESTRUCTURA SEMÁNTICA (HTML5 PURO)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 1: Arquitectura Web y Estructura con HTML5 Semántico',
        'Comprende cómo viajan los datos en Internet y estructura documentos web con etiquetas semánticas y accesibles.'
    )
    RETURNING id INTO v_m1_id;

    -- Lección 1.1 (Quiz: Arquitectura Web y Protocolo HTTP)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code
    ) VALUES (
        v_m1_id,
        '1.1 ¿Cómo funciona la Web? Cliente, Servidor y HTTP',
        'Descubre los conceptos esenciales detrás de las peticiones web, DNS y el ciclo Request-Response.',
        'quiz',
        50,
        1,
        $THEORY$# 🌐 ¿Cómo funciona la Web en Realidad?

Cada vez que abres tu navegador (Chrome, Firefox, Safari) y escribes `https://codify.dev`, se desata una coreografía de red en milisegundos:

### 1. El Modelo Cliente-Servidor
- **El Cliente (Frontend):** Tu navegador web. Solicita recursos (HTML, imágenes, datos) y se encarga de renderizarlos visualmente.
- **El Servidor (Backend):** Una computadora remota que almacena los archivos y responde a las solicitudes procesando la lógica de negocio y bases de datos.

### 2. El Ciclo de Vida de una Petición (Request / Response)
1. **Resolución DNS (*Domain Name System*):** Traduce el nombre de dominio legible (`codify.dev`) a una dirección IP numérica (`192.0.2.1`).
2. **Petición HTTP/HTTPS (*Request*):** El navegador solicita la página mediante métodos como `GET` (pedir información) o `POST` (enviar datos).
3. **Respuesta del Servidor (*Response*):** El servidor entrega un código de estado (ej: `200 OK`, `404 Not Found`, `500 Server Error`) junto con el archivo HTML.
4. **Renderizado del DOM (*Critical Rendering Path*):** El navegador lee el HTML línea por línea y construye el árbol del DOM (*Document Object Model*).$THEORY$,
        $TEST$[
  {
    "id": "q1",
    "question": "¿Cuál es la función principal del sistema DNS en Internet?",
    "options": [
      "Comprimir imágenes para que carguen más rápido",
      "Traducir nombres de dominio a direcciones IP comprensibles por máquinas",
      "Ejecutar el código JavaScript en el servidor",
      "Encriptar la contraseña de los usuarios"
    ],
    "correctIndex": 1,
    "explanation": "El DNS actúa como la libreta de contactos de Internet, traduciendo nombres como google.com a su dirección IP numérica."
  },
  {
    "id": "q2",
    "question": "En el modelo Cliente-Servidor, ¿cuál es el rol principal del navegador web?",
    "options": [
      "Almacenar las bases de datos de todos los usuarios",
      "Actuar como cliente: solicitar, interpretar y renderizar el contenido HTML, CSS y JS",
      "Asignar direcciones IP a los servidores",
      "Compilar el código fuente de los servidores"
    ],
    "correctIndex": 1,
    "explanation": "El navegador es el cliente que envía peticiones HTTP y dibuja la interfaz para el usuario."
  }
]$TEST$
    );

    -- Lección 1.2 (Web: Estructura Semántica HTML5 Directo)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.2 Estructura Semántica con HTML5',
        'Escribe directamente las etiquetas semánticas de HTML5 para estructurar una página web.',
        'web',
        60,
        2,
        $THEORY$# 🏗️ HTML5 Semántico: Escribir para Humanos y Motores de Búsqueda

Antes de HTML5, todo se creaba con etiquetas genéricas `<div>`. El **HTML Semántico** introdujo etiquetas con significado propio que mejoran la accesibilidad (lectores de pantalla) y el posicionamiento SEO.

### Etiquetas Semánticas Clave:
- `<header>`: Encabezado del sitio o de una sección (logos, títulos, navegación).
- `<main>`: El contenido central y único de la página.
- `<article>`: Bloque independiente de contenido reutilizable (como un post o noticia).
- `<footer>`: Pie de página (derechos de autor, enlaces legales, redes).

---

### 🎯 Tu Misión de Hoy:
Escribe la estructura semántica en HTML directamente:
1. Un elemento `<header>` con un `<h1>` interior con el texto `"Codify Academy"`.
2. Un elemento `<main>` con un párrafo `<p id="resumen">` con el texto `"Aprende desarrollo web paso a paso"`.
3. Un elemento `<footer id="pie">` con el texto `"© 2026 Codify"`.

> 💡 **Nota:** ¡Escribe directamente el código HTML en el editor! El navegador lo renderizará en vivo en la pestaña de Vista Previa.$THEORY$,
        $CODE$<!-- 1. Crea el <header> con su <h1> "Codify Academy" -->


<!-- 2. Crea el <main> con su <p id="resumen"> -->


<!-- 3. Crea el <footer id="pie"> -->
$CODE$,
        $CODE$<header>
  <h1>Codify Academy</h1>
</header>

<main>
  <p id="resumen">Aprende desarrollo web paso a paso</p>
</main>

<footer id="pie">© 2026 Codify</footer>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const header = document.querySelector("header");
const h1 = header ? header.querySelector("h1") : null;
const main = document.querySelector("main");
const p = document.getElementById("resumen");
const footer = document.getElementById("pie") || document.querySelector("footer");

assert(header !== null, "Debe existir un elemento <header>.");
assert(h1 && h1.textContent.trim() === "Codify Academy", "El <header> debe contener un <h1> con el texto 'Codify Academy'.");
assert(main !== null, "Debe existir un elemento <main>.");
assert(p && p.textContent.trim() === "Aprende desarrollo web paso a paso", "El <main> debe contener un <p> con id='resumen' y texto 'Aprende desarrollo web paso a paso'.");
assert(footer !== null && footer.tagName.toLowerCase() === "footer", "Debe existir un elemento <footer>.");
assert(footer && footer.textContent.includes("Codify"), "El footer debe contener el texto de copyright.");$TEST$
    );

    -- Lección 1.3 (Web: Formularios HTML5 Directos)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.3 Formularios Interactivos y Entradas de Datos',
        'Construye un formulario HTML5 con inputs tipados, placeholder y botón de envío.',
        'web',
        65,
        3,
        $THEORY$# 📋 Formularios Web: La Puerta de Entrada a los Datos

Los formularios (`<form>`) permiten al usuario interactuar y enviar información estructurada al servidor:

- `<form>`: Contenedor que agrupa los campos de entrada.
- `<input type="text">`: Entrada de texto estándar.
- `<input type="email">`: Valida automáticamente formato de correo.
- `<input type="password">`: Oculta los caracteres ingresados.
- `<button type="submit">`: Dispara el evento de envío del formulario.

---

### 🎯 Tu Misión de Hoy:
Escribe el formulario directamente en HTML:
1. Una etiqueta `<form id="registroForm">`.
2. Dentro del formulario:
   - Un campo `<input type="email" id="emailInput" placeholder="tu@correo.com" />`.
   - Un `<button type="submit" id="btnEnviar">Registrarse</button>`.
$THEORY$,
        $CODE$<!-- Construye el formulario con id="registroForm", su input email y botón submit -->
<form id="registroForm">
  <!-- Agrega tu input con type="email", id="emailInput" y placeholder="tu@correo.com" -->

  <!-- Agrega tu botón con type="submit", id="btnEnviar" y texto "Registrarse" -->

</form>$CODE$,
        $CODE$<form id="registroForm">
  <input type="email" id="emailInput" placeholder="tu@correo.com" />
  <button type="submit" id="btnEnviar">Registrarse</button>
</form>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const form = document.getElementById("registroForm") || document.querySelector("form");
const input = document.getElementById("emailInput") || (form ? form.querySelector("input") : null);
const btn = document.getElementById("btnEnviar") || (form ? form.querySelector("button") : null);

assert(form !== null, "Debe existir un elemento <form id='registroForm'>.");
assert(input !== null, "Debe existir un campo <input> dentro del formulario.");
assert(input && input.getAttribute("type") === "email", "El input debe tener type='email'.");
assert(input && input.getAttribute("placeholder") === "tu@correo.com", "El input debe tener placeholder='tu@correo.com'.");
assert(btn !== null, "Debe existir un <button> dentro del formulario.");
assert(btn && btn.textContent.trim() === "Registrarse", "El botón debe tener el texto 'Registrarse'.");
assert(btn && btn.getAttribute("type") === "submit", "El botón debe tener type='submit'.");$TEST$
    );

    -- Lección 1.4 (Web: Enlaces, Imágenes y Accesibilidad a11y)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.4 Hipervínculos, Multimedia y Atributos Alt (a11y)',
        'Integra elementos multimedia y enlaces respetando las directrices de accesibilidad web.',
        'web',
        60,
        4,
        $THEORY$# ♿ Accesibilidad y Enlaces en la Web Moderna

Una web profesional debe ser inclusiva para todas las personas:

1. **Atributo `alt` en imágenes (`<img>`):** Describe el contenido visual para lectores de pantalla utilizados por personas con discapacidad visual, y se muestra si la imagen no carga.
2. **Atributo `target="_blank"` y `rel="noopener noreferrer"` en enlaces (`<a>`):** Abre la página en una nueva pestaña protegiendo la seguridad contra ataques de tab-napping.

---

### 🎯 Tu Misión de Hoy:
Escribe la tarjeta multimedia en HTML directamente:
1. Un contenedor `<div id="card">`.
2. Dentro de la tarjeta:
   - Una imagen `<img>` con `id="avatar"`, `src="https://picsum.photos/200"` y `alt="Foto de perfil del desarrollador"`.
   - Un enlace `<a>` con `id="portfolioLink"`, `href="https://github.com"`, `target="_blank"` y el texto `"Ver Repositorio"`.
$THEORY$,
        $CODE$<!-- Crea la tarjeta multimedia con imagen accesible y enlace externo -->
<div id="card">
  <!-- Agrega la etiqueta <img> con src, alt="Foto de perfil del desarrollador" e id="avatar" -->

  <!-- Agrega la etiqueta <a> con href, target="_blank", id="portfolioLink" y texto "Ver Repositorio" -->

</div>$CODE$,
        $CODE$<div id="card">
  <img id="avatar" src="https://picsum.photos/200" alt="Foto de perfil del desarrollador" />
  <a id="portfolioLink" href="https://github.com" target="_blank">Ver Repositorio</a>
</div>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const card = document.getElementById("card");
const img = document.getElementById("avatar") || (card ? card.querySelector("img") : null);
const link = document.getElementById("portfolioLink") || (card ? card.querySelector("a") : null);

assert(card !== null, "Debe crearse un contenedor <div id='card'>.");
assert(img !== null, "Debe existir un elemento <img> dentro de la tarjeta.");
assert(img && img.getAttribute("alt") === "Foto de perfil del desarrollador", "La imagen debe tener el atributo alt='Foto de perfil del desarrollador'.");
assert(link !== null, "Debe existir un elemento <a> dentro de la tarjeta.");
assert(link && link.getAttribute("target") === "_blank", "El enlace debe tener target='_blank'.");
assert(link && link.textContent.trim() === "Ver Repositorio", "El texto del enlace debe ser 'Ver Repositorio'.");$TEST$
    );

    -- ==============================================================================
    -- 🎨 MÓDULO 2: ESTILOS, MAQUETACIÓN Y DISEÑO RESPONSIVO (CSS3)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 2: Estilos, Cascada y Maquetación Moderna con CSS3',
        'Domina el Box Model, maquetación flexible con Flexbox, grillas con CSS Grid y diseño responsivo.'
    )
    RETURNING id INTO v_m2_id;

    -- Lección 2.1 (Web: Box Model con CSS)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.1 El Modelo de Caja (CSS Box Model)',
        'Aprende a controlar padding, margin, border y bordes redondeados con reglas CSS.',
        'web',
        70,
        1,
        $THEORY$# 📦 El Modelo de Caja de CSS (Box Model)

Cada elemento HTML en una página web es una **caja rectangular** compuesta por cuatro capas concéntricas:

1. **Content (Contenido):** Donde se dibuja el texto o imagen.
2. **Padding (Relleno interno):** Espacio transparente entre el contenido y el borde.
3. **Border (Borde):** Línea visible alrededor del padding.
4. **Margin (Margen externo):** Espacio que separa a este elemento de los elementos vecinos.

```css
#boxHero {
  background-color: #1e1e2e;
  padding: 20px;
  margin: 10px;
  border: 2px solid #8b5cf6;
  border-radius: 12px;
}
```

---

### 🎯 Tu Misión de Hoy:
Crea un `<div id="boxHero">` y añade un bloque `<style>` aplicando los siguientes estilos al selector `#boxHero`:
- `background-color: #1e1e2e;`
- `padding: 20px;`
- `margin: 10px;`
- `border-radius: 12px;`
- `border: 2px solid #8b5cf6;`
$THEORY$,
        $CODE$<style>
  #boxHero {
    /* TODO: Define background-color (#1e1e2e), padding (20px), margin (10px), border-radius (12px) y border (2px solid #8b5cf6) */

  }
</style>

<div id="boxHero">
  Caja con Box Model Estilizado
</div>$CODE$,
        $CODE$<style>
  #boxHero {
    background-color: #1e1e2e;
    padding: 20px;
    margin: 10px;
    border-radius: 12px;
    border: 2px solid #8b5cf6;
  }
</style>

<div id="boxHero">
  Caja con Box Model Estilizado
</div>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const box = document.getElementById("boxHero");
assert(box !== null, "Debe existir un elemento con id='boxHero'.");

const style = window.getComputedStyle(box);
assert(style.padding === "20px" || box.style.padding === "20px", "El padding debe ser 20px.");
assert(style.margin === "10px" || box.style.margin === "10px", "El margin debe ser 10px.");
assert(style.borderRadius === "12px" || box.style.borderRadius === "12px", "El border-radius debe ser 12px.");$TEST$
    );

    -- Lección 2.2 (Web: Flexbox)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.2 Maquetación con CSS Flexbox',
        'Domina display: flex, justify-content y align-items para alinear elementos fácilmente.',
        'web',
        80,
        2,
        $THEORY$# 📐 Flexbox: El Superpoder de la Alineación

Flexbox (*Flexible Box Layout*) resuelve el problema histórico de alinear elementos en 1 dimensión (fila o columna):

- `display: flex`: Convierte al contenedor en un contenedor flexible.
- `justify-content: space-between | center | flex-start`: Controla la distribución en el eje principal (horizontal por defecto).
- `align-items: center`: Centra los elementos verticalmente en el eje secundario.
- `gap: 12px`: Establece un espacio uniforme entre los hijos flexibles sin necesidad de márgenes manuales.

---

### 🎯 Tu Misión de Hoy:
Crea una barra de navegación con Flexbox:
1. Una etiqueta `<nav id="navbar">` con dos botones interiores:
   - `<button id="btnLogo">Codify</button>`
   - `<button id="btnLogin">Iniciar Sesión</button>`
2. En el bloque `<style>`, aplica al selector `#navbar`:
   - `display: flex;`
   - `justify-content: space-between;`
   - `align-items: center;`
   - `gap: 12px;`
$THEORY$,
        $CODE$<style>
  #navbar {
    /* TODO: Aplica display flex, justify-content space-between, align-items center y gap 12px */

  }
</style>

<nav id="navbar">
  <button id="btnLogo">Codify</button>
  <button id="btnLogin">Iniciar Sesión</button>
</nav>$CODE$,
        $CODE$<style>
  #navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
  }
</style>

<nav id="navbar">
  <button id="btnLogo">Codify</button>
  <button id="btnLogin">Iniciar Sesión</button>
</nav>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const nav = document.getElementById("navbar") || document.querySelector("nav");
const btnLogo = document.getElementById("btnLogo");
const btnLogin = document.getElementById("btnLogin");

assert(nav !== null, "Debe existir un elemento <nav id='navbar'>.");
const style = window.getComputedStyle(nav);
assert(style.display === "flex" || nav.style.display === "flex", "El navbar debe tener display: flex.");
assert(style.justifyContent === "space-between" || nav.style.justifyContent === "space-between", "El navbar debe tener justify-content: space-between.");
assert(style.alignItems === "center" || nav.style.alignItems === "center", "El navbar debe tener align-items: center.");
assert(btnLogo !== null && btnLogin !== null, "Debe contener ambos botones (<button id='btnLogo'> y <button id='btnLogin'>).");$TEST$
    );

    -- Lección 2.3 (Web: CSS Grid)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.3 Grillas Bidimensionales con CSS Grid',
        'Crea una cuadrícula de cursos con grid-template-columns y gap.',
        'web',
        80,
        3,
        $THEORY$# 🗂️ CSS Grid: Diseño Bidimensional Poderoso

Mientras que Flexbox trabaja en 1 dimensión, **CSS Grid** organiza filas y columnas simultáneamente:

- `display: grid`: Activa el modo cuadrícula.
- `grid-template-columns: repeat(3, 1fr)`: Crea 3 columnas de igual ancho (`1fr` = una fracción del espacio disponible).
- `gap: 16px`: Espacio entre filas y columnas.

---

### 🎯 Tu Misión de Hoy:
1. Crea un contenedor `<div id="cursosGrid">` con 3 elementos `<div class="curso-card">` en su interior.
2. En la sección `<style>`, aplica a `#cursosGrid`:
   - `display: grid;`
   - `grid-template-columns: repeat(3, 1fr);`
   - `gap: 16px;`
$THEORY$,
        $CODE$<style>
  #cursosGrid {
    /* TODO: Aplica display grid, grid-template-columns repeat(3, 1fr) y gap 16px */

  }
  .curso-card {
    background: #18181b;
    padding: 16px;
    border-radius: 8px;
  }
</style>

<div id="cursosGrid">
  <!-- TODO: Agrega 3 tarjetas con clase "curso-card" -->

</div>$CODE$,
        $CODE$<style>
  #cursosGrid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
  }
  .curso-card {
    background: #18181b;
    padding: 16px;
    border-radius: 8px;
  }
</style>

<div id="cursosGrid">
  <div class="curso-card">Curso 1: HTML5</div>
  <div class="curso-card">Curso 2: CSS3</div>
  <div class="curso-card">Curso 3: JavaScript</div>
</div>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const grid = document.getElementById("cursosGrid");
assert(grid !== null, "Debe existir un contenedor con id='cursosGrid'.");

const style = window.getComputedStyle(grid);
assert(style.display === "grid" || grid.style.display === "grid", "El contenedor debe tener display: grid.");
const cards = grid.querySelectorAll(".curso-card");
assert(cards.length >= 3, "Deben existir al menos 3 elementos con la clase 'curso-card' dentro de la grilla.");$TEST$
    );

    -- Lección 2.4 (Web: Variables CSS y Temas)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.4 Variables CSS (Custom Properties) y Dark Mode',
        'Aprende a definir y consumir variables CSS para tematización dinámica.',
        'web',
        75,
        4,
        $THEORY$# 🎨 Variables CSS (CSS Custom Properties)

Las variables CSS permiten centralizar valores (colores, tipografía, espacios) para reutilizarlos en toda la hoja de estilos:

```css
:root {
  --bg-color: #09090b;
  --text-color: #fafafa;
}

#statusTema {
  background-color: var(--bg-color);
  color: var(--text-color);
}
```

---

### 🎯 Tu Misión de Hoy:
1. En el bloque `<style>`, define en el pseudo-selector `:root`:
   - `--bg-color: #09090b;`
   - `--text-color: #fafafa;`
2. Aplica estas variables en `#statusTema` usando `var(--bg-color)` y `var(--text-color)`.
3. Crea el elemento `<div id="statusTema">Tema Oscuro Activado</div>`.
$THEORY$,
        $CODE$<style>
  :root {
    /* TODO: Define las variables --bg-color (#09090b) y --text-color (#fafafa) */

  }

  #statusTema {
    /* TODO: Aplica las variables con var(--bg-color) y var(--text-color) */

    padding: 12px;
    border-radius: 8px;
  }
</style>

<div id="statusTema">Tema Oscuro Activado</div>$CODE$,
        $CODE$<style>
  :root {
    --bg-color: #09090b;
    --text-color: #fafafa;
  }

  #statusTema {
    background-color: var(--bg-color);
    color: var(--text-color);
    padding: 12px;
    border-radius: 8px;
  }
</style>

<div id="statusTema">Tema Oscuro Activado</div>$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const statusDiv = document.getElementById("statusTema");
assert(statusDiv !== null, "Debe existir un elemento <div id='statusTema'>.");
assert(statusDiv.textContent.includes("Tema Oscuro Activado"), "El elemento debe contener el texto 'Tema Oscuro Activado'.");$TEST$
    );

    -- ==============================================================================
    -- ⚡ MÓDULO 3: DINAMISMO, EVENTOS Y MANIPULACIÓN DEL DOM (JAVASCRIPT)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 3: Interactividad Dinámica con JavaScript y el DOM',
        'Aprende a transformar páginas estáticas en aplicaciones web reactivas que responden a las acciones del usuario.'
    )
    RETURNING id INTO v_m3_id;

    -- Lección 3.1 (Web: Selección y Modificación del DOM)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.1 Selección y Mutación del DOM con JavaScript',
        'Aprende a encontrar elementos con querySelector y modificar sus clases y textos dinámicamente.',
        'web',
        75,
        1,
        $THEORY$# ⚡ El DOM (Document Object Model): La Interfaz Viva

¡Ahora que ya dominas HTML y CSS, es hora de darles vida con **JavaScript**!

El **DOM** es el árbol de objetos que el navegador genera a partir de tu HTML:
- `document.querySelector("#miId")`: Encuentra el primer elemento que coincide con el selector.
- `elemento.textContent = "Nuevo Texto"`: Actualiza el texto visible.
- `elemento.classList.add("activo")`: Añade una clase CSS dinámica.

---

### 🎯 Tu Misión de Hoy:
Crea una función `actualizarPerfilUsuario(nuevoNombre)` que:
1. Busque un elemento `<h1>` con `id="username"` (si no existe, créalo con `document.createElement("h1")` y añádelo a `document.body`).
2. Actualice su `textContent` al valor de `nuevoNombre`.
3. Le añada la clase CSS `"perfil-verificado"`.
$THEORY$,
        $CODE$function actualizarPerfilUsuario(nuevoNombre) {
  // TODO:
  // 1. Busca o crea #username
  // 2. Asigna el nuevoNombre a su textContent
  // 3. Agrégale la clase CSS 'perfil-verificado'

}$CODE$,
        $CODE$function actualizarPerfilUsuario(nuevoNombre) {
  let userHeading = document.getElementById("username");
  if (!userHeading) {
    userHeading = document.createElement("h1");
    userHeading.id = "username";
    document.body.appendChild(userHeading);
  }
  userHeading.textContent = nuevoNombre;
  userHeading.classList.add("perfil-verificado");
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
actualizarPerfilUsuario("Ada Lovelace");
const heading = document.getElementById("username");
assert(heading !== null, "Debe existir un elemento con id 'username'.");
assert(heading.textContent === "Ada Lovelace", "El texto de #username debe actualizarse al nombre provisto.");
assert(heading.classList.contains("perfil-verificado"), "Debe contener la clase CSS 'perfil-verificado'.");$TEST$
    );

    -- Lección 3.2 (Web: Escucha de Eventos y Manejadores)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.2 Escucha de Eventos y Reactividad (addEventListener)',
        'Haz que tu interfaz reaccione a clicks y acciones del usuario en tiempo real.',
        'web',
        85,
        2,
        $THEORY$# 🖱️ Eventos del Navegador: La Base de la Interactividad

Un evento es una señal de que algo ocurrió en la página (el usuario hizo clic, presionó una tecla, etc.):

```js
const boton = document.getElementById("miBoton");

boton.addEventListener("click", () => {
  console.log("¡Hicieron clic!");
});
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `inicializarContadorLikes()` que inserte en `document.body`:
1. Un `<button id="btnLike">` con texto inicial `"Me gusta (0)"`.
2. Una variable interna que mantenga el conteo de likes.
3. Un `addEventListener` para `"click"` que en cada pulsación incremente el contador y actualice el texto a `"Me gusta (X)"`.
$THEORY$,
        $CODE$function inicializarContadorLikes() {
  // TODO:
  // 1. Crea el botón #btnLike con texto "Me gusta (0)"
  // 2. Crea la variable interna de conteo
  // 3. Agrega addEventListener("click", ...) para incrementar y actualizar el texto

}$CODE$,
        $CODE$function inicializarContadorLikes() {
  let count = 0;
  const btn = document.createElement("button");
  btn.id = "btnLike";
  btn.textContent = "Me gusta (0)";

  btn.addEventListener("click", () => {
    count++;
    btn.textContent = `Me gusta (${count})`;
  });

  document.body.appendChild(btn);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
inicializarContadorLikes();
const btn = document.getElementById("btnLike");
assert(btn !== null, "Debe existir un botón con id 'btnLike'.");
assert(btn.textContent === "Me gusta (0)", "El texto inicial debe ser 'Me gusta (0)'.");
btn.click();
assert(btn.textContent === "Me gusta (1)", "Tras un click, el texto debe ser 'Me gusta (1)'.");
btn.click();
assert(btn.textContent === "Me gusta (2)", "Tras dos clicks, el texto debe ser 'Me gusta (2)'.");$TEST$
    );

    -- Lección 3.3 (Web: Renderizado Dinámico de Listas)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.3 Renderizado Dinámico de Datos (Arrays a HTML)',
        'Transforma arreglos de datos en elementos de interfaz de usuario de forma dinámica.',
        'web',
        90,
        3,
        $THEORY$# 🔄 Del Dato a la Vista: Renderizado Dinámico

En el desarrollo frontend, recibimos datos de bases de datos o APIs (formato JSON) y construimos la interfaz dinámicamente iterando sobre arrays:

```js
const tareas = ["HTML", "CSS", "JS"];
const lista = document.createElement("ul");

tareas.forEach((tarea) => {
  const item = document.createElement("li");
  item.textContent = tarea;
  lista.appendChild(item);
});
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `renderizarListaHabilidades(habilidades)` que:
1. Cree un elemento `<ul id="skillsList">`.
2. Itere sobre el array `habilidades` creando para cada una un `<li class="skill-badge">` con su texto correspondiente.
3. Inserte el `<ul>` en `document.body`.
$THEORY$,
        $CODE$function renderizarListaHabilidades(habilidades) {
  // TODO:
  // 1. Crea <ul id="skillsList">
  // 2. Itera sobre habilidades y agrega cada <li class="skill-badge">
  // 3. Añade la lista al DOM

}$CODE$,
        $CODE$function renderizarListaHabilidades(habilidades) {
  const ul = document.createElement("ul");
  ul.id = "skillsList";

  habilidades.forEach((skill) => {
    const li = document.createElement("li");
    li.className = "skill-badge";
    li.textContent = skill;
    ul.appendChild(li);
  });

  document.body.appendChild(ul);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
renderizarListaHabilidades(["HTML5", "CSS3", "JavaScript", "TypeScript"]);
const ul = document.getElementById("skillsList");
assert(ul !== null, "Debe existir un elemento con id 'skillsList'.");
const items = ul.querySelectorAll(".skill-badge");
assert(items.length === 4, "Debe haber exactamente 4 elementos con clase 'skill-badge'.");
assert(items[0].textContent === "HTML5" && items[3].textContent === "TypeScript", "Los textos de los items deben coincidir con el array provisto.");$TEST$
    );

    -- Lección 3.4 (Reto Final: Proyecto Completo - Mini App Web Interactiva)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.4 🏆 Reto Final: Mini Gestor de Tareas Interactivo',
        'Integra HTML semántico, estilos dinámicos, eventos y manipulación del DOM en un proyecto completo.',
        'web',
        120,
        4,
        $THEORY$# 🏆 ¡El Gran Desafío Final: Tu Primera App Web!

Has recorrido un camino completo:
1. **HTML5:** Estructura semántica, formularios y etiquetas directas.
2. **CSS3:** Box Model, Flexbox, Grid y variables.
3. **JavaScript:** Manipulación dinámica del DOM y manejo de eventos.

---

### 🎯 Requisitos de la Mini App:
Crea una función `iniciarAppTareas()` que inserte en `document.body`:
1. Un contenedor `<div id="todoApp">`.
2. Dentro del contenedor:
   - Un campo de texto `<input id="taskInput" placeholder="Nueva tarea...">`.
   - Un botón `<button id="btnAddTask">Agregar</button>`.
   - Una lista vacía `<ul id="taskList"></ul>`.
3. Cuando se haga clic en `#btnAddTask`:
   - Si `#taskInput` tiene texto (no vacío), crea un `<li>` con ese texto, agrégalo a `#taskList` y limpia el campo de texto (`input.value = ""`).
$THEORY$,
        $CODE$function iniciarAppTareas() {
  // TODO:
  // 1. Crea el contenedor #todoApp con #taskInput, #btnAddTask y #taskList
  // 2. Al hacer clic en #btnAddTask, añade la tarea a la lista y limpia el input

}$CODE$,
        $CODE$function iniciarAppTareas() {
  const container = document.createElement("div");
  container.id = "todoApp";

  const input = document.createElement("input");
  input.id = "taskInput";
  input.placeholder = "Nueva tarea...";

  const btn = document.createElement("button");
  btn.id = "btnAddTask";
  btn.textContent = "Agregar";

  const ul = document.createElement("ul");
  ul.id = "taskList";

  btn.addEventListener("click", () => {
    const valor = input.value.trim();
    if (valor.length > 0) {
      const li = document.createElement("li");
      li.textContent = valor;
      ul.appendChild(li);
      input.value = "";
    }
  });

  container.appendChild(input);
  container.appendChild(btn);
  container.appendChild(ul);
  document.body.appendChild(container);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
iniciarAppTareas();
const app = document.getElementById("todoApp");
const input = document.getElementById("taskInput");
const btn = document.getElementById("btnAddTask");
const ul = document.getElementById("taskList");

assert(app !== null && input !== null && btn !== null && ul !== null, "Todos los elementos requeridos (app, input, botón y lista) deben existir.");
input.value = "Estudiar Frontend";
btn.click();
const items = ul.querySelectorAll("li");
assert(items.length === 1, "Debe haberse agregado un elemento <li> a la lista.");
assert(items[0].textContent === "Estudiar Frontend", "El texto de la tarea agregada debe coincidir.");
assert(input.value === "", "El input debe quedar limpio tras agregar la tarea.");$TEST$
    );

END $$;
