-- ==============================================================================
-- 🌐 CODIFY SEED: 16 - CURSO COMPLETO: FUNDAMENTOS DE LA PROGRAMACIÓN WEB
-- ==============================================================================
-- Curso estructurado en 3 Módulos Progresivos (12 Lecciones Prácticas e Interactivas)
-- Cubre desde el funcionamiento de la Web, HTML5 Semántico, CSS3 Flexbox/Grid
-- hasta manipulación dinámica del DOM y manejo de eventos con JavaScript.
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
        'Aprende a construir la web desde sus cimientos: arquitectura cliente-servidor, HTML5 semántico, maquetación moderna con CSS3 (Flexbox & Grid) y dinamismo interactivo manipulando el DOM con JavaScript.',
        '/images/courses/web-fundamentals.jpg',
        ARRAY['Práctico', 'Web', 'HTML5', 'CSS3', 'JavaScript', 'Frontend'],
        'published'
    )
    RETURNING id INTO v_course_id;

    -- ==============================================================================
    -- 📌 MÓDULO 1: ARQUITECTURA WEB Y ESTRUCTURA SEMÁNTICA (HTML5)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description, difficulty_level)
    VALUES (
        v_course_id,
        'Módulo 1: Arquitectura Web y Estructura con HTML5 Semántico',
        'Comprende cómo viajan los datos en Internet y estructura documentos web accesibles y optimizados para SEO.',
        1
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
        $THEORY$
# 🌐 ¿Cómo funciona la Web en Realidad?

Cada vez que abres tu navegador (Chrome, Firefox, Safari) y escribes `https://codify.dev`, se desata una coreografía de red en milisegundos:

### 1. El Modelo Cliente-Servidor
- **El Cliente (Frontend):** Tu navegador web. Solicita recursos (HTML, imágenes, datos) y se encarga de renderizarlos visualmente.
- **El Servidor (Backend):** Una computadora remota que almacena los archivos y responde a las solicitudes procesando la lógica de negocio y bases de datos.

### 2. El Ciclo de Vida de una Petición (Request / Response)
1. **Resolución DNS (*Domain Name System*):** Traduce el nombre de dominio legible (`codify.dev`) a una dirección IP numérica (`192.0.2.1`).
2. **Petición HTTP/HTTPS (*Request*):** El navegador solicita la página mediante métodos como `GET` (pedir información) o `POST` (enviar datos).
3. **Respuesta del Servidor (*Response*):** El servidor entrega un código de estado (ej: `200 OK`, `404 Not Found`, `500 Server Error`) junto con el archivo HTML.
4. **Renderizado del DOM (*Critical Rendering Path*):** El navegador lee el HTML línea por línea y construye el árbol del DOM (*Document Object Model*).
$THEORY$,
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

    -- Lección 1.2 (Web: Estructura Semántica HTML5)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.2 Estructura Semántica con HTML5',
        'Aprende a maquetar una cabecera, sección principal y pie de página con etiquetas semánticas.',
        'web',
        60,
        2,
        $THEORY$
# 🏗️ HTML5 Semántico: Escribir para Humanos y Motores de Búsqueda

Antes de HTML5, todo se creaba con etiquetas genéricas `<div>`. El **HTML Semántico** introdujo etiquetas con significado propio que mejoran la accesibilidad (lectores de pantalla) y el posicionamiento SEO.

### Etiquetas Semánticas Clave:
- `<header>`: Encabezado del sitio o de una sección (logos, títulos, navegación).
- `<main>`: El contenido central y único de la página.
- `<article>`: Bloque independiente de contenido reutilizable (como un post o noticia).
- `<footer>`: Pie de página (derechos de autor, enlaces legales, redes).

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearLayoutSemantico()` que cree e inserte en `document.body`:
1. Un elemento `<header>` con un `<h1>` dentro cuyo texto sea `"Codify Academy"`.
2. Un elemento `<main>` con un `<p>` dentro con `id = "resumen"` y texto `"Aprende desarrollo web paso a paso"`.
3. Un elemento `<footer>` con `id = "pie"` y texto `"© 2026 Codify"`.
$THEORY$,
        $CODE$function crearLayoutSemantico() {
  // 1. Crea el <header> con su <h1> interior:
  
  // 2. Crea el <main> con su <p id="resumen">:
  
  // 3. Crea el <footer id="pie">:
  
  // 4. Inserta header, main y footer en document.body:

}$CODE$,
        $CODE$function crearLayoutSemantico() {
  const header = document.createElement("header");
  const h1 = document.createElement("h1");
  h1.textContent = "Codify Academy";
  header.appendChild(h1);

  const main = document.createElement("main");
  const p = document.createElement("p");
  p.id = "resumen";
  p.textContent = "Aprende desarrollo web paso a paso";
  main.appendChild(p);

  const footer = document.createElement("footer");
  footer.id = "pie";
  footer.textContent = "© 2026 Codify";

  document.body.appendChild(header);
  document.body.appendChild(main);
  document.body.appendChild(footer);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearLayoutSemantico();
const header = document.querySelector("header");
const h1 = header ? header.querySelector("h1") : null;
const main = document.querySelector("main");
const p = document.getElementById("resumen");
const footer = document.getElementById("pie");

assert(header !== null, "Debe existir un elemento <header> en document.body.");
assert(h1 && h1.textContent === "Codify Academy", "El <header> debe contener un <h1> con el texto 'Codify Academy'.");
assert(main !== null, "Debe existir un elemento <main> en document.body.");
assert(p && p.textContent === "Aprende desarrollo web paso a paso", "El <main> debe contener un <p> con id 'resumen' y texto correcto.");
assert(footer !== null && footer.tagName.toLowerCase() === "footer", "Debe existir un elemento <footer> con id 'pie'.");$TEST$
    );

    -- Lección 1.3 (Web: Formularios y Controles de Usuario)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.3 Formularios Interactivos y Entradas de Datos',
        'Construye un formulario de registro con inputs tipados, labels y botón de envío.',
        'web',
        65,
        3,
        $THEORY$
# 📋 Formularios Web: La Puerta de Entrada a los Datos

Los formularios (`<form>`) permiten al usuario interactuar y enviar información estructurada al servidor:

- `<form>`: Contenedor que agrupa los campos de entrada.
- `<input type="text">`: Entrada de texto estándar.
- `<input type="email">`: Valida automáticamente formato de correo.
- `<input type="password">`: Oculta los caracteres ingresados.
- `<button type="submit">`: Dispara el evento de envío del formulario.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearFormularioRegistro()` que inserte en `document.body`:
1. Un elemento `<form>` con `id = "registroForm"`.
2. Dentro del form, un `<input>` con `id = "emailInput"`, `type = "email"` y `placeholder = "tu@correo.com"`.
3. Dentro del form, un `<button>` con `id = "btnEnviar"`, `type = "submit"` y texto `"Registrarse"`.
$THEORY$,
        $CODE$function crearFormularioRegistro() {
  // 1. Crear el formulario:
  
  // 2. Crear el input de email con sus atributos:
  
  // 3. Crear el botón submit:
  
  // 4. Armar la jerarquía y agregarlo a document.body:

}$CODE$,
        $CODE$function crearFormularioRegistro() {
  const form = document.createElement("form");
  form.id = "registroForm";

  const input = document.createElement("input");
  input.id = "emailInput";
  input.type = "email";
  input.placeholder = "tu@correo.com";

  const btn = document.createElement("button");
  btn.id = "btnEnviar";
  btn.type = "submit";
  btn.textContent = "Registrarse";

  form.appendChild(input);
  form.appendChild(btn);
  document.body.appendChild(form);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearFormularioRegistro();
const form = document.getElementById("registroForm");
const input = document.getElementById("emailInput");
const btn = document.getElementById("btnEnviar");

assert(form !== null, "Debe existir un elemento <form> con id 'registroForm'.");
assert(input !== null && input.getAttribute("type") === "email", "El input debe tener type='email'.");
assert(input && input.getAttribute("placeholder") === "tu@correo.com", "El input debe tener placeholder='tu@correo.com'.");
assert(btn !== null && btn.textContent === "Registrarse", "El botón debe tener el texto 'Registrarse'.");
assert(form.contains(input) && form.contains(btn), "El input y el botón deben estar dentro del formulario.");$TEST$
    );

    -- Lección 1.4 (Web: Enlaces, Imágenes y Accesibilidad a11y)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.4 Hipervínculos, Multimedia y Atributos Alt (a11y)',
        'Integra elementos multimedia respetando las directrices de accesibilidad web.',
        'web',
        60,
        4,
        $THEORY$
# ♿ Accesibilidad y Enlaces en la Web Moderna

Una web profesional debe ser inclusiva para todas las personas:

1. **Atributo `alt` en imágenes (`<img>`):** Describe el contenido visual para lectores de pantalla utilizados por personas con discapacidad visual, y se muestra si la imagen no carga.
2. **Atributo `target="_blank"` y `rel="noopener noreferrer"` en enlaces (`<a>`):** Abre la página en una nueva pestaña protegiendo la seguridad contra ataques de tab-napping.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearTarjetaMultimedia()` que agregue a `document.body`:
1. Un contenedor `<div>` con `id = "card"`.
2. Una imagen `<img>` con `src = "https://picsum.photos/200"`, `alt = "Foto de perfil del desarrollador"` e `id = "avatar"`.
3. Un enlace `<a>` con `id = "portfolioLink"`, `href = "https://github.com"`, `target = "_blank"` y texto `"Ver Repositorio"`.
$THEORY$,
        $CODE$function crearTarjetaMultimedia() {
  // Crea el contenedor #card con la imagen accesible y el enlace externo:

}$CODE$,
        $CODE$function crearTarjetaMultimedia() {
  const card = document.createElement("div");
  card.id = "card";

  const img = document.createElement("img");
  img.id = "avatar";
  img.src = "https://picsum.photos/200";
  img.alt = "Foto de perfil del desarrollador";

  const link = document.createElement("a");
  link.id = "portfolioLink";
  link.href = "https://github.com";
  link.target = "_blank";
  link.textContent = "Ver Repositorio";

  card.appendChild(img);
  card.appendChild(link);
  document.body.appendChild(card);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearTarjetaMultimedia();
const card = document.getElementById("card");
const img = document.getElementById("avatar");
const link = document.getElementById("portfolioLink");

assert(card !== null, "Debe crearse un contenedor <div id='card'>.");
assert(img !== null && img.getAttribute("alt") === "Foto de perfil del desarrollador", "La imagen debe tener un atributo alt descriptivo.");
assert(link !== null && link.getAttribute("target") === "_blank", "El enlace debe tener target='_blank'.");
assert(link && link.textContent === "Ver Repositorio", "El texto del enlace debe ser 'Ver Repositorio'.");$TEST$
    );

    -- ==============================================================================
    -- 🎨 MÓDULO 2: ESTILOS, MAQUETACIÓN Y DISEÑO RESPONSIVO (CSS3)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description, difficulty_level)
    VALUES (
        v_course_id,
        'Módulo 2: Estilos, Cascada y Maquetación Moderna con CSS3',
        'Domina el Box Model, maquetación flexible con Flexbox, grillas con CSS Grid y diseño responsivo.',
        2
    )
    RETURNING id INTO v_m2_id;

    -- Lección 2.1 (Web: Box Model y Estilos Base)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.1 El Modelo de Caja (CSS Box Model)',
        'Aprende a controlar padding, margin, border y box-sizing en tus componentes.',
        'web',
        70,
        1,
        $THEORY$
# 📦 El Modelo de Caja de CSS (Box Model)

Cada elemento HTML en una página web es una **caja rectangular** compuesta por cuatro capas concéntricas:

1. **Content (Contenido):** Donde se dibuja el texto o imagen.
2. **Padding (Relleno interno):** Espacio transparente entre el contenido y el borde.
3. **Border (Borde):** Línea visible alrededor del padding.
4. **Margin (Margen externo):** Espacio que separa a este elemento de los elementos vecinos.

### `box-sizing: border-box`
Por defecto (`content-box`), añadir padding aumenta el ancho total del elemento. Con `border-box`, el ancho especificado incluye el padding y el borde, facilitando cálculos precisos.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearCajaEstilizada()` que cree un elemento `<div>` con `id = "boxHero"` y le aplique los siguientes estilos directos (`style`):
- `backgroundColor = "#1e1e2e"`
- `padding = "20px"`
- `margin = "10px"`
- `borderRadius = "12px"`
- `border = "2px solid #8b5cf6"`
- Inserte el div en `document.body`.
$THEORY$,
        $CODE$function crearCajaEstilizada() {
  // Crea el elemento y asigna sus propiedades de estilo CSS:

}$CODE$,
        $CODE$function crearCajaEstilizada() {
  const box = document.createElement("div");
  box.id = "boxHero";
  box.style.backgroundColor = "#1e1e2e";
  box.style.padding = "20px";
  box.style.margin = "10px";
  box.style.borderRadius = "12px";
  box.style.border = "2px solid #8b5cf6";
  document.body.appendChild(box);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearCajaEstilizada();
const box = document.getElementById("boxHero");
assert(box !== null, "Debe existir un elemento con id 'boxHero'.");
assert(box.style.padding === "20px", "El padding debe ser '20px'.");
assert(box.style.margin === "10px", "El margin debe ser '10px'.");
assert(box.style.borderRadius === "12px", "El borderRadius debe ser '12px'.");$TEST$
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
        $THEORY$
# 📐 Flexbox: El Superpoder de la Alineación

Flexbox (*Flexible Box Layout*) resuelve el problema histórico de alinear elementos en 1 dimensión (fila o columna):

- `display: flex`: Convierte al contenedor en un contenedor flexible.
- `justify-content: space-between | center | flex-start`: Controla la distribución en el eje principal (horizontal por defecto).
- `align-items: center`: Centra los elementos verticalmente en el eje secundario.
- `gap: 16px`: Establece un espacio uniforme entre los hijos flexibles sin necesidad de márgenes manuales.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearBarraNavegacion()` que genere una barra de navegación horizontal:
1. Crea un elemento `<nav>` con `id = "navbar"`.
2. Aplícale estilos flexibles:
   - `display = "flex"`
   - `justifyContent = "space-between"`
   - `alignItems = "center"`
   - `gap = "12px"`
3. Dentro del `<nav>`, agrega dos botones:
   - `<button id="btnLogo">Codify</button>`
   - `<button id="btnLogin">Iniciar Sesión</button>`
4. Inserte el `<nav>` en `document.body`.
$THEORY$,
        $CODE$function crearBarraNavegacion() {
  // Construye la barra de navegación usando Flexbox:

}$CODE$,
        $CODE$function crearBarraNavegacion() {
  const nav = document.createElement("nav");
  nav.id = "navbar";
  nav.style.display = "flex";
  nav.style.justifyContent = "space-between";
  nav.style.alignItems = "center";
  nav.style.gap = "12px";

  const btnLogo = document.createElement("button");
  btnLogo.id = "btnLogo";
  btnLogo.textContent = "Codify";

  const btnLogin = document.createElement("button");
  btnLogin.id = "btnLogin";
  btnLogin.textContent = "Iniciar Sesión";

  nav.appendChild(btnLogo);
  nav.appendChild(btnLogin);
  document.body.appendChild(nav);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearBarraNavegacion();
const nav = document.getElementById("navbar");
const btnLogo = document.getElementById("btnLogo");
const btnLogin = document.getElementById("btnLogin");

assert(nav !== null, "Debe existir un elemento con id 'navbar'.");
assert(nav.style.display === "flex", "El navbar debe tener display: flex.");
assert(nav.style.justifyContent === "space-between", "El navbar debe tener justifyContent: space-between.");
assert(nav.style.alignItems === "center", "El navbar debe tener alignItems: center.");
assert(btnLogo !== null && btnLogin !== null, "Debe contener ambos botones con sus respectivos IDs.");$TEST$
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
        $THEORY$
# 🗂️ CSS Grid: Diseño Bidimensional Poderoso

Mientras que Flexbox trabaja en 1 dimensión, **CSS Grid** organiza filas y columnas simultáneamente:

- `display: grid`: Activa el modo cuadrícula.
- `grid-template-columns: repeat(3, 1fr)`: Crea 3 columnas de igual ancho (`1fr` = una fracción del espacio disponible).
- `gap: 16px`: Espacio entre filas y columnas.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crearGridCursos()` que:
1. Cree un contenedor `<div>` con `id = "cursosGrid"`.
2. Aplique los estilos:
   - `display = "grid"`
   - `gridTemplateColumns = "repeat(3, 1fr)"`
   - `gap = "16px"`
3. Inserte 3 tarjetas `<div>` con la clase `"curso-card"` dentro de la grilla.
4. Inserte la grilla en `document.body`.
$THEORY$,
        $CODE$function crearGridCursos() {
  // Construye la grilla con 3 elementos hijos:

}$CODE$,
        $CODE$function crearGridCursos() {
  const grid = document.createElement("div");
  grid.id = "cursosGrid";
  grid.style.display = "grid";
  grid.style.gridTemplateColumns = "repeat(3, 1fr)";
  grid.style.gap = "16px";

  for (let i = 1; i <= 3; i++) {
    const card = document.createElement("div");
    card.className = "curso-card";
    card.textContent = `Curso ${i}`;
    grid.appendChild(card);
  }

  document.body.appendChild(grid);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearGridCursos();
const grid = document.getElementById("cursosGrid");
assert(grid !== null, "Debe existir un contenedor con id 'cursosGrid'.");
assert(grid.style.display === "grid", "El contenedor debe tener display: grid.");
assert(grid.style.gridTemplateColumns === "repeat(3, 1fr)", "Debe tener gridTemplateColumns: 'repeat(3, 1fr)'.");
const cards = grid.querySelectorAll(".curso-card");
assert(cards.length === 3, "Deben existir exactamente 3 elementos con la clase 'curso-card' dentro de la grilla.");$TEST$
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
        $THEORY$
# 🎨 Variables CSS (CSS Custom Properties)

Las variables CSS permiten reutilizar valores (colores, fuentes, sombras) en toda la hoja de estilos:

```css
:root {
  --primary-color: #8b5cf6;
  --bg-dark: #0f172a;
}

.boton {
  background-color: var(--primary-color);
}
```

En JavaScript, podemos leer y modificar variables CSS en tiempo de ejecución:
```js
document.documentElement.style.setProperty("--primary-color", "#ec4899");
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `aplicarTemaOscuro()` que:
1. Establezca en `document.documentElement.style`:
   - La propiedad CSS `"--bg-color"` con valor `"#09090b"`.
   - La propiedad CSS `"--text-color"` con valor `"#fafafa"`.
2. Cree un elemento `<div id="statusTema">Tema Oscuro Activado</div>` y lo agregue a `document.body`.
$THEORY$,
        $CODE$function aplicarTemaOscuro() {
  // 1. Asigna las variables CSS:
  
  // 2. Crea el indicador visual:

}$CODE$,
        $CODE$function aplicarTemaOscuro() {
  document.documentElement.style.setProperty("--bg-color", "#09090b");
  document.documentElement.style.setProperty("--text-color", "#fafafa");

  const div = document.createElement("div");
  div.id = "statusTema";
  div.textContent = "Tema Oscuro Activado";
  document.body.appendChild(div);
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
aplicarTemaOscuro();
const bgColor = document.documentElement.style.getPropertyValue("--bg-color");
const textColor = document.documentElement.style.getPropertyValue("--text-color");
const statusDiv = document.getElementById("statusTema");

assert(bgColor === "#09090b", "La variable CSS --bg-color debe tener el valor '#09090b'.");
assert(textColor === "#fafafa", "La variable CSS --text-color debe tener el valor '#fafafa'.");
assert(statusDiv !== null && statusDiv.textContent === "Tema Oscuro Activado", "Debe existir <div id='statusTema'> con el texto correcto.");$TEST$
    );

    -- ==============================================================================
    -- ⚡ MÓDULO 3: DINAMISMO, EVENTOS Y MANIPULACIÓN DEL DOM (JAVASCRIPT)
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description, difficulty_level)
    VALUES (
        v_course_id,
        'Módulo 3: Interactividad Dinámica con JavaScript y el DOM',
        'Aprende a transformar páginas estáticas en aplicaciones web reactivas que responden a las acciones del usuario.',
        2
    )
    RETURNING id INTO v_m3_id;

    -- Lección 3.1 (Web: Selección y Modificación del DOM)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.1 Selección y Mutación del DOM con JavaScript',
        'Aprende a encontrar elementos con querySelector y modificar sus clases y atributos.',
        'web',
        75,
        1,
        $THEORY$
# ⚡ El DOM (Document Object Model): La Interfaz Viva

El **DOM** es la representación en memoria que el navegador hace de tu HTML. JavaScript puede interactuar con él:

- `document.querySelector(".mi-clase")`: Encuentra el primer elemento que coincide con el selector CSS.
- `document.querySelectorAll("p")`: Retorna una lista con todos los elementos coincidentes.
- `elemento.classList.add("activo")`: Añade una clase CSS.
- `elemento.classList.remove("oculto")`: Remueve una clase CSS.
- `elemento.classList.toggle("activo")`: Alterna la presencia de la clase.

---

### 🎯 Tu Misión de Hoy:
Crea una función `actualizarPerfilUsuario(nuevoNombre)` que:
1. Busque un elemento `<h1>` con `id = "username"` (créalo primero con texto `"Invitado"` si no existe en el DOM).
2. Modifique su `textContent` al valor de `nuevoNombre`.
3. Le añada la clase CSS `"perfil-verificado"`.
$THEORY$,
        $CODE$function actualizarPerfilUsuario(nuevoNombre) {
  // Busca o crea #username, actualiza su texto y agrégale la clase 'perfil-verificado':

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
        'Haz que tu interfaz reaccione a clicks, teclas y entradas del usuario.',
        'web',
        85,
        2,
        $THEORY$
# 🖱️ Eventos del Navegador: La Base de la Interactividad

Un evento es una señal de que algo ocurrió en la página (el usuario hizo clic, presionó una tecla, envió un formulario):

```js
const boton = document.getElementById("miBoton");

boton.addEventListener("click", (evento) => {
  console.log("¡Hicieron clic en el botón!");
});
```

### Eventos Comunes:
- `"click"`: Cuando se pulsa el botón del ratón.
- `"input"`: Cuando cambia el valor de un campo de texto en tiempo real.
- `"submit"`: Cuando se envía un formulario (recuerda usar `e.preventDefault()` para evitar recargar la página).

---

### 🎯 Tu Misión de Hoy:
Crea una función `inicializarContadorLikes()` que inserte en `document.body`:
1. Un `<button>` con `id = "btnLike"` y texto `"Me gusta (0)"`.
2. Una variable interna que mantenga el conteo de likes (inicia en 0).
3. Un `addEventListener` para el evento `"click"` que, cada vez que se presione el botón, incremente el contador en 1 y actualice el texto a `"Me gusta (X)"`.
$THEORY$,
        $CODE$function inicializarContadorLikes() {
  // Crea el botón e implementa el listener para incrementar los likes al hacer clic:

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
        $THEORY$
# 🔄 Del Dato a la Vista: Renderizado Dinámico

En el desarrollo frontend moderno, las aplicaciones reciben datos (por ejemplo, desde una API en formato JSON) y deben construir la interfaz dinámicamente usando métodos de array como `forEach` o `map`:

```js
const tareas = ["Aprender HTML", "Dominar CSS", "Programar en JS"];
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
1. Cree un elemento `<ul>` con `id = "skillsList"`.
2. Itere sobre el array `habilidades` y por cada una cree un `<li>` con la clase `"skill-badge"` y el texto de la habilidad.
3. Inserte todos los elementos en la lista y finalmente agregue el `<ul>` a `document.body`.
$THEORY$,
        $CODE$function renderizarListaHabilidades(habilidades) {
  // Itera el array y genera la lista dinámica en el DOM:

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
        $THEORY$
# 🏆 ¡El Gran Desafío Final: Tu Primera App Web!

Has recorrido un camino completo:
1. Estructura semántica con HTML5.
2. Diseño adaptable y estilizado con CSS3.
3. Manejo de eventos y reactividad con JavaScript.

Ahora pondrás todo en práctica construyendo un **Mini Gestor de Tareas Interactivo**.

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
  // Implementa la Mini App interactiva de gestión de tareas:

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
