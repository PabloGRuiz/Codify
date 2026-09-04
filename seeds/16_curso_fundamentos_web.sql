-- ==============================================================================
-- 🌐 CODIFY SEED: 16 - CURSO MAESTRO: FUNDAMENTOS DE LA PROGRAMACIÓN WEB
-- ==============================================================================
-- Curso profesional con arquitectura de proyectos reales, estructura de carpetas,
-- multi-archivos (HTML, CSS y JS interconectados), evaluación profunda por etapas
-- y referencias a documentación oficial verificada (MDN Web Docs, W3C, WHATWG).
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
        'Domina la arquitectura real de proyectos web: estructura de carpetas profesionales, HTML5 semántico y accesible, maquetación avanzada con CSS3 (Box Model, Flexbox & Grid) y dinamismo con JavaScript conectando múltiples archivos.',
        '/images/courses/web-fundamentals.jpg',
        ARRAY['Web', 'HTML5', 'CSS3', 'JavaScript', 'Frontend', 'Arquitectura'],
        'published'
    )
    RETURNING id INTO v_course_id;

    -- ==============================================================================
    -- 📌 MÓDULO 1: ARQUITECTURA WEB, ESTRUCTURA DE PROYECTOS Y HTML5 SEMÁNTICO
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 1: Arquitectura Web, Estructura de Proyectos y HTML5 Semántico',
        'Aprende cómo funciona la infraestructura de la web, organiza carpetas profesionales y maqueta con etiquetas semánticas y accesibles.'
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
        $THEORY$# 🌐 La Arquitectura de la Web: El Modelo Cliente-Servidor y HTTP

Cada vez que abres tu navegador (Google Chrome, Firefox, Safari) e ingresas una dirección URL como `https://codify.dev`, se desencadena una coreografía de red distribuida en milisegundos a través de la infraestructura global de Internet.

---

### 1. El Modelo Cliente-Servidor (*Client-Server Architecture*)

El desarrollo web moderno descansa sobre la separación de responsabilidades entre dos entidades principales:

1. **El Cliente (*Frontend*):**
   - Es el dispositivo o software con el que interactúa el usuario final (típicamente el navegador web o una aplicación móvil).
   - Su responsabilidad es solicitar información a través de la red, procesar el código de presentación (**HTML5**, **CSS3**, **JavaScript**) y renderizar una interfaz gráfica interactiva.
   - El cliente opera en un entorno controlado denominado *sandbox* para proteger la seguridad del usuario.

2. **El Servidor (*Backend*):**
   - Una computadora o clúster en la nube siempre encendido y accesible a través de una dirección IP pública fija.
   - Su trabajo es escuchar peticiones entrantes, autenticar usuarios, ejecutar la lógica de negocio, interactuar con bases de datos (SQL/NoSQL) y entregar los recursos solicitados.

---

### 2. El Ciclo de Vida de una Petición Web (*Request / Response Cycle*)

El viaje que realiza un paquete de datos desde que pulsas Enter hasta que ves la página en pantalla comprende 4 fases críticas:

```
[ Navegador (Cliente) ] ── (1) DNS Lookup ──> [ Servidor DNS ]
[ Navegador (Cliente) ] ── (2) HTTP GET ────> [ Servidor Web ]
[ Navegador (Cliente) ] <─ (3) 200 OK + HTML ─ [ Servidor Web ]
[ Navegador (Cliente) ] ── (4) Construye DOM/CSSOM y Renderiza
```

1. **Resolución DNS (*Domain Name System*):**
   - Las computadoras se comunican mediante direcciones numéricas IP (ej: `142.250.190.46`). Los humanos recordamos nombres legibles como `codify.dev`.
   - El sistema DNS funciona como la "libreta de contactos" descentralizada de Internet, traduciendo el dominio a la IP del servidor en milisegundos.

2. **Negociación TCP y TLS Handshake (HTTPS):**
   - Se establece una conexión segura y cifrada para garantizar la confidencialidad de los datos.

3. **La Petición HTTP (*HTTP Request*):**
   - El cliente envía un mensaje estructurado con un verbo HTTP:
     - `GET`: Solicitar un recurso (una página, imagen, hoja de estilos).
     - `POST`: Enviar datos para crear un nuevo registro (ej. enviar un formulario de registro).
     - `PUT / PATCH`: Actualizar un registro existente.
     - `DELETE`: Eliminar un recurso.

4. **La Respuesta del Servidor (*HTTP Response*):**
   - El servidor responde con una cabecera y un código de estado (*HTTP Status Code*):
     - `200 OK`: La solicitud fue exitosa y se entrega el contenido.
     - `301 / 302 Redirect`: El recurso se movió a otra URL.
     - `400 Bad Request`: La solicitud del cliente contiene errores.
     - `401 Unauthorized / 403 Forbidden`: Falta autenticación o permisos.
     - `404 Not Found`: El recurso solicitado no existe.
     - `500 Internal Server Error`: Ocurrió un error no controlado en el servidor.

---

### 3. El Camino Crítico de Renderizado (*Critical Rendering Path*)

Una vez que el navegador recibe el archivo HTML:
1. Lee los bytes y genera tokens de etiquetas.
2. Construye el árbol **DOM** (*Document Object Model*).
3. Lee los archivos CSS vinculados y genera el **CSSOM** (*CSS Object Model*).
4. Combina ambos en el **Render Tree** y dibuja (*Paint*) los píxeles en tu pantalla.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: ¿Cómo funciona la Web?](https://developer.mozilla.org/es/docs/Learn/Getting_started_with_the_web/How_the_Web_works)
- [MDN Web Docs: Visión general del protocolo HTTP](https://developer.mozilla.org/es/docs/Web/HTTP/Overview)
- [WHATWG: Estándar del Modelo de Objetos del Documento (DOM)](https://dom.spec.whatwg.org/)$THEORY$,
        $TEST$[
  {
    "id": "q1",
    "question": "¿Cuál es la función principal del sistema DNS en la arquitectura de Internet?",
    "options": [
      "Comprimir imágenes y hojas de estilos para que carguen con menor latencia",
      "Traducir nombres de dominio legibles (ej: codify.dev) a direcciones IP numéricas comprensibles por máquinas",
      "Ejecutar el código JavaScript en el navegador del cliente",
      "Validar contraseñas de usuarios en bases de datos relacionales"
    ],
    "correctIndex": 1,
    "explanation": "El DNS actúa como la libreta telefónica de Internet, resolviendo nombres de dominio a las IPs físicas donde residen los servidores."
  },
  {
    "id": "q2",
    "question": "En el protocolo HTTP, ¿qué método se utiliza típicamente para enviar los datos de un formulario de registro al servidor?",
    "options": [
      "GET",
      "POST",
      "FETCH",
      "PING"
    ],
    "correctIndex": 1,
    "explanation": "El método POST se diseñó para enviar cargas útiles de datos en el cuerpo (body) de la petición HTTP, ideal para crear registros y formularios."
  },
  {
    "id": "q3",
    "question": "¿Qué código de estado HTTP indica que el servidor no pudo encontrar el recurso solicitado?",
    "options": [
      "200 OK",
      "301 Moved Permanently",
      "404 Not Found",
      "500 Internal Server Error"
    ],
    "correctIndex": 2,
    "explanation": "El código 404 Not Found pertenece a la familia 4xx de errores del cliente e indica que la URL no corresponde a ningún recurso existente en el servidor."
  },
  {
    "id": "q4",
    "question": "¿Qué es el DOM (Document Object Model) en el navegador?",
    "options": [
      "Una base de datos SQLite embebida en el disco duro del cliente",
      "La representación en memoria estructurada en forma de árbol que el navegador construye a partir del HTML",
      "Un protocolo de cifrado equivalente a TLS",
      "El lenguaje en el que se programan las hojas de estilo"
    ],
    "correctIndex": 1,
    "explanation": "El DOM es la interfaz de programación y representación en árbol de nodos que el navegador genera al parsear el documento HTML."
  }
]$TEST$
    );

    -- Lección 1.2 (Web Multi-Archivo: Estructura de Proyecto y HTML5 Semántico)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.2 Estructura de Proyectos y HTML5 Semántico',
        'Organiza un proyecto web profesional con HTML5 semántico, doctype moderno y buenas prácticas de carpetas.',
        'web',
        70,
        2,
        $THEORY$# 🏗️ Estructura de Proyectos y HTML5 Semántico

En el mundo profesional, ningún sitio web serio se construye amontonando código en una sola etiqueta o en carpetas desordenadas. Aprender a organizar un proyecto desde el primer día marca la diferencia entre un programador amateur y un desarrollador profesional.

---

### 1. La Estructura Estándar de Carpetas en la Web

Todo proyecto web estático o frontend sigue una convención clara y limpia:

```text
mi-proyecto-web/
├── index.html        <-- Punto de entrada obligatorio del sitio
├── css/              <-- Hojas de estilo organizadas
│   └── styles.css
├── js/               <-- Scripts de interacción y lógica
│   └── app.js
└── assets/           <-- Recursos estáticos (imágenes, fuentes, iconos)
    └── images/
```

#### Reglas de Oro en Nombres de Archivos:
1. **Todo en minúsculas y sin espacios:** Usa `styles.css` o `perfil-usuario.html` (kebab-case). Los servidores Linux diferencian mayúsculas y espacios pueden romper URLs en producción.
2. **`index.html` siempre en la raíz:** Los servidores web (Apache, Nginx, Vercel) buscan automáticamente `index.html` como página de bienvenida predeterminada.

---

### 2. El Esqueleto Estándar de HTML5

Un documento HTML5 válido comienza con el preámbulo que instruye al motor de renderizado a operar en modo de estándares estrictos:

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Codify Academy | Formación Web</title>
</head>
<body>
  <!-- Contenido semántico visible -->
</body>
</html>
```

---

### 3. Etiquetas Semánticas: ¿Por qué no usar solo `<div>`?

Antes de HTML5 (2014), toda la web se maquetaba con etiquetas genéricas `<div class="cabecera">` o `<div class="pie">`. 

El **HTML Semántico** introdujo etiquetas con significado intrínseco que le comunican a los navegadores, motores de búsqueda (Google, Bing) y tecnologías de asistencia (lectores de pantalla para personas con discapacidad visual) qué representa cada sección:

- `<header>`: Cabecera introductoria de la página o de una sección (títulos, logotipo, navegación principal).
- `<nav>`: Contenedor específico para enlaces de navegación.
- `<main>`: El contenido central, dominante y único de la página. Solo debe haber **un elemento `<main>`** por documento.
- `<article>`: Composición autónoma y reutilizable (como un post de blog, una tarjeta de producto o una noticia).
- `<section>`: Agrupación temática genérica de contenido con un encabezado propio.
- `<footer>`: Pie de página con información de autoría, derechos de autor (`©`), enlaces legales y redes sociales.

---

### 🎯 Tu Misión de Hoy:
En el archivo `index.html`, construye una estructura semántica completa y accesible:
1. El boilerplate HTML5 con `<!DOCTYPE html>`, `<html lang="es">`, `<head>` (con `<meta charset="UTF-8">` y `<title>Codify Academy</title>`), y su `<body>`.
2. Dentro del `<body>`:
   - Un `<header>` que contenga un encabezado principal `<h1>Codify Academy</h1>`.
   - Un `<main>` que contenga:
     - Un párrafo `<p id="resumen">` con el texto `"Aprende desarrollo web paso a paso"`.
     - Una `<section id="contenido">` con un encabezado secundario `<h2>Nuestros Cursos</h2>`.
   - Un elemento `<footer id="pie">` con el texto `"© 2026 Codify"`.

> 💡 **Tip:** Observa cómo el Sandbox interpreta tus etiquetas en la pestaña **Vista Previa Web**.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Semántica en HTML](https://developer.mozilla.org/es/docs/Glossary/Semantics#html)
- [MDN Web Docs: Estructuración del documento con HTML5](https://developer.mozilla.org/es/docs/Learn/HTML/Introduction_to_HTML/Document_and_website_structure)
- [W3C: Especificación de Recomendación HTML5.2](https://www.w3.org/TR/html52/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Codify Academy</title>\n</head>\n<body>\n  <!-- 1. Crea el <header> con su <h1> \"Codify Academy\" -->\n\n  <!-- 2. Crea el <main> con <p id=\"resumen\"> y <section id=\"contenido\"> -->\n\n  <!-- 3. Crea el <footer id=\"pie\"> -->\n\n</body>\n</html>"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Codify Academy</title>\n</head>\n<body>\n  <header>\n    <h1>Codify Academy</h1>\n  </header>\n\n  <main>\n    <p id=\"resumen\">Aprende desarrollo web paso a paso</p>\n    <section id=\"contenido\">\n      <h2>Nuestros Cursos</h2>\n    </section>\n  </main>\n\n  <footer id=\"pie\">© 2026 Codify</footer>\n</body>\n</html>"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

// ETAPA 1: Verificación de Archivos del Proyecto
assert(files["index.html"] !== undefined, "Etapa 1 Fallida: Debe existir el archivo 'index.html' en la raíz del proyecto.");
console.log("✓ [Archivos] Archivo index.html detectado correctamente");

// ETAPA 2: Validación de Estructura y Semántica HTML5
const header = document.querySelector("header");
assert(header !== null, "Etapa 2 Fallida: Debe existir un elemento semántico <header> en el <body>.");
const h1 = header.querySelector("h1");
assert(h1 !== null && h1.textContent.trim() === "Codify Academy", "Etapa 2 Fallida: El <header> debe contener un <h1> con el texto exacto 'Codify Academy'.");
console.log("✓ [HTML5] <header> y <h1> estructurados correctamente");

const main = document.querySelector("main");
assert(main !== null, "Etapa 2 Fallida: Debe existir un elemento semántico <main>.");
const pResumen = document.getElementById("resumen");
assert(pResumen !== null && pResumen.textContent.trim() === "Aprende desarrollo web paso a paso", "Etapa 2 Fallida: Debe existir un <p id='resumen'> con el texto 'Aprende desarrollo web paso a paso'.");

const seccion = document.getElementById("contenido");
assert(seccion !== null && seccion.tagName.toLowerCase() === "section", "Etapa 2 Fallida: Debe existir un elemento <section id='contenido'> dentro de <main>.");
const h2 = seccion.querySelector("h2");
assert(h2 !== null && h2.textContent.trim() === "Nuestros Cursos", "Etapa 2 Fallida: La sección debe contener un <h2> con el texto 'Nuestros Cursos'.");
console.log("✓ [HTML5] <main>, párrafo y <section> validados");

const footer = document.getElementById("pie") || document.querySelector("footer");
assert(footer !== null && footer.tagName.toLowerCase() === "footer", "Etapa 2 Fallida: Debe existir un elemento semántico <footer id='pie'>.");
assert(footer.textContent.includes("Codify"), "Etapa 2 Fallida: El footer debe contener el texto de copyright con 'Codify'.");
console.log("✓ [HTML5] <footer> semántico verificado");$TEST$
    );

    -- Lección 1.3 (Web Multi-Archivo: Formularios y Controles Tipados)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.3 Formularios Interactivos y Accesibilidad de Datos',
        'Construye formularios accesibles con labels explícitos, inputs tipados y validación nativa.',
        'web',
        75,
        3,
        $THEORY$# 📋 Formularios Web Profesionales: Captura y Validación de Datos

Los formularios (`<form>`) son el puente de entrada principal mediante el cual los usuarios envían datos desde el cliente hacia el servidor: desde un inicio de sesión hasta transacciones de pago.

---

### 1. La Anatomía de un `<form>` Accesible

Un error común de programadores principiantes es usar inputs sueltos sin su respectiva etiqueta `<label>`.

La etiqueta `<label>` cumple tres propósitos críticos:
1. **Accesibilidad (a11y):** Los lectores de pantalla anuncian la etiqueta cuando el usuario navega con el teclado o invidentes.
2. **Usabilidad:** Al hacer clic sobre el texto de un `<label>`, el cursor se posiciona automáticamente dentro del `<input>` asociado.
3. **Asociación Explícita:** Se vincula mediante el atributo `for` del label coincidiendo con el atributo `id` del input:

```html
<label for="correo">Correo Electrónico:</label>
<input type="email" id="correo" name="email" required placeholder="tu@correo.com">
```

---

### 2. Tipos de Input y Validación Nativa de HTML5

HTML5 incluye un potente motor de validación en el cliente sin requerir JavaScript adicional:

- `type="text"`: Entrada alfanumérica estándar.
- `type="email"`: Valida automáticamente que el valor contenga `@` y un dominio válido.
- `type="password"`: Enmascara los caracteres ingresados por privacidad.
- `type="number"`: Restringe el ingreso a valores numéricos y permite `min` y `max`.
- Atributo `required`: Impide el envío si el campo está en blanco.
- Atributo `placeholder`: Texto de ayuda contextual que desaparece al escribir.

---

### 🎯 Tu Misión de Hoy:
En `index.html`, maqueta un formulario de registro profesional:
1. Un contenedor `<form id="registroForm">`.
2. Dentro del formulario:
   - Un `<label for="emailInput">Correo:</label>`.
   - Un `<input type="email" id="emailInput" name="email" placeholder="tu@correo.com" required>`.
   - Un `<label for="passInput">Contraseña:</label>`.
   - Un `<input type="password" id="passInput" name="password" required>`.
   - Un botón de envío `<button type="submit" id="btnEnviar">Crear Cuenta</button>`.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Guía de formularios HTML](https://developer.mozilla.org/es/docs/Learn/Forms)
- [MDN Web Docs: El elemento `<form>`](https://developer.mozilla.org/es/docs/Web/HTML/Element/form)
- [W3C WAI: Guía de accesibilidad para formularios web](https://www.w3.org/WAI/tutorials/forms/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Registro de Usuario</title>\n</head>\n<body>\n  <h2>Crear Cuenta en Codify</h2>\n\n  <!-- Construye el <form id=\"registroForm\"> con sus labels, inputs tipados y botón -->\n  <form id=\"registroForm\">\n    \n  </form>\n</body>\n</html>"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Registro de Usuario</title>\n</head>\n<body>\n  <h2>Crear Cuenta en Codify</h2>\n\n  <form id=\"registroForm\">\n    <label for=\"emailInput\">Correo:</label>\n    <input type=\"email\" id=\"emailInput\" name=\"email\" placeholder=\"tu@correo.com\" required>\n\n    <label for=\"passInput\">Contraseña:</label>\n    <input type=\"password\" id=\"passInput\" name=\"password\" required>\n\n    <button type=\"submit\" id=\"btnEnviar\">Crear Cuenta</button>\n  </form>\n</body>\n</html>"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const form = document.getElementById("registroForm");
assert(form !== null, "Etapa 1: Debe existir el elemento <form id='registroForm'>.");
console.log("✓ [Formulario] Contenedor <form> encontrado");

const emailInput = document.getElementById("emailInput");
assert(emailInput !== null, "Etapa 2: Debe existir un <input id='emailInput'>.");
assert(emailInput.getAttribute("type") === "email", "Etapa 2: El input de email debe tener type='email'.");
assert(emailInput.hasAttribute("required"), "Etapa 2: El input de email debe incluir el atributo 'required'.");
console.log("✓ [Inputs] Campo de email validado");

const passInput = document.getElementById("passInput");
assert(passInput !== null, "Etapa 2: Debe existir un <input id='passInput'>.");
assert(passInput.getAttribute("type") === "password", "Etapa 2: El input de contraseña debe tener type='password'.");
assert(passInput.hasAttribute("required"), "Etapa 2: El input de contraseña debe ser 'required'.");
console.log("✓ [Inputs] Campo de contraseña validado");

const emailLabel = document.querySelector("label[for='emailInput']");
assert(emailLabel !== null, "Etapa 3: Debe existir un <label for='emailInput'> vinculado al campo de correo.");
const passLabel = document.querySelector("label[for='passInput']");
assert(passLabel !== null, "Etapa 3: Debe existir un <label for='passInput'> vinculado al campo de contraseña.");
console.log("✓ [Accesibilidad a11y] Etiquetas <label> explícitas validadas");

const btn = document.getElementById("btnEnviar");
assert(btn !== null, "Etapa 4: Debe existir un <button id='btnEnviar'>.");
assert(btn.getAttribute("type") === "submit", "Etapa 4: El botón debe tener type='submit'.");
assert(btn.textContent.trim().length > 0, "Etapa 4: El botón debe tener un texto descriptivo.");
console.log("✓ [Controles] Botón de envío submit verificado");$TEST$
    );

    -- Lección 1.4 (Web Multi-Archivo: Multimedia y Directrices de Accesibilidad)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m1_id,
        '1.4 Multimedia Accesible y Enlaces Seguros',
        'Aprende a integrar recursos multimedia cumpliendo las pautas WCAG y seguridad web.',
        'web',
        70,
        4,
        $THEORY$# ♿ Multimedia Accesible y Enlaces Seguros (WCAG)

En la web profesional moderna, la **accesibilidad web (a11y)** no es un extra opcional: es un estándar de la industria y un requisito legal en muchas partes del mundo bajo las pautas **WCAG (*Web Content Accessibility Guidelines*)**.

---

### 1. El Atributo `alt` en Imágenes (`<img>`)

La etiqueta `<img>` es un elemento vacío (*void tag*, no tiene etiqueta de cierre). 

Su atributo más crítico para la accesibilidad es `alt` (*alternative text*):
1. **Para lectores de pantalla:** Las personas con discapacidad visual navegan con software que lee en voz alta el contenido del atributo `alt`.
2. **Conexiones lentas o fallas de red:** Si la imagen no descarga, el navegador muestra el texto alternativo en su lugar.
3. **SEO:** Los motores de búsqueda indexan el contenido visual a través de la descripción semántica de `alt`.

```html
<!-- ❌ Mala práctica: Sin texto alternativo o genérico -->
<img src="foto.jpg" alt="imagen">

<!-- ✅ Buena práctica: Descripción concisa y contextual -->
<img src="avatar.jpg" alt="Fotografía de perfil de Ada Lovelace sonriendo">
```

---

### 2. Enlaces Externos y Seguridad Web

Cuando colocas un enlace `<a>` que apunta a un sitio externo y utilizas `target="_blank"` para abrirlo en una nueva pestaña, expones a tus usuarios a una vulnerabilidad conocida como **Tab-napping**:

El sitio externo puede acceder a la propiedad `window.opener` de tu página y redirigir al usuario a un sitio malicioso o de phishing.

Para mitigar esto, **siempre debes incluir**:
```html
<a href="https://github.com" target="_blank" rel="noopener noreferrer">
  Ver Repositorio
</a>
```
- `noopener`: Impide que la nueva pestaña acceda al objeto `window.opener`.
- `noreferrer`: Evita que el navegador envíe la cabecera HTTP `Referer` protegiendo la privacidad.

---

### 🎯 Tu Misión de Hoy:
En `index.html`:
1. Crea un contenedor `<div id="card">`.
2. Dentro de `#card`:
   - Una imagen `<img id="avatar" src="https://picsum.photos/200" alt="Foto de perfil del desarrollador">`.
   - Un enlace `<a id="portfolioLink" href="https://github.com" target="_blank" rel="noopener noreferrer">Ver Repositorio</a>`.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Imágenes en HTML](https://developer.mozilla.org/es/docs/Learn/HTML/Multimedia_and_embedding/Images_in_HTML)
- [MDN Web Docs: Enlaces en HTML](https://developer.mozilla.org/es/docs/Learn/HTML/Introduction_to_HTML/Creating_hyperlinks)
- [W3C Web Accessibility Initiative (WAI): Introducción a la Accesibilidad](https://www.w3.org/WAI/fundamentals/accessibility-intro/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Tarjeta de Perfil</title>\n</head>\n<body>\n  <!-- Crea la tarjeta #card con la imagen accesible y el enlace seguro -->\n  <div id=\"card\">\n    \n  </div>\n</body>\n</html>"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Tarjeta de Perfil</title>\n</head>\n<body>\n  <div id=\"card\">\n    <img id=\"avatar\" src=\"https://picsum.photos/200\" alt=\"Foto de perfil del desarrollador\">\n    <a id=\"portfolioLink\" href=\"https://github.com\" target=\"_blank\" rel=\"noopener noreferrer\">Ver Repositorio</a>\n  </div>\n</body>\n</html>"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const card = document.getElementById("card");
assert(card !== null, "Etapa 1: Debe existir el contenedor <div id='card'>.");
console.log("✓ [Estructura] Contenedor de tarjeta encontrado");

const img = document.getElementById("avatar") || (card ? card.querySelector("img") : null);
assert(img !== null, "Etapa 2: Debe existir la etiqueta <img> dentro de la tarjeta.");
assert(img.hasAttribute("alt") && img.getAttribute("alt").trim().length > 5, "Etapa 2: La imagen debe incluir un atributo alt descriptivo.");
assert(img.getAttribute("alt") === "Foto de perfil del desarrollador", "Etapa 2: El alt debe ser exactamente 'Foto de perfil del desarrollador'.");
console.log("✓ [Accesibilidad] Imagen con texto alternativo alt verificado");

const link = document.getElementById("portfolioLink") || (card ? card.querySelector("a") : null);
assert(link !== null, "Etapa 3: Debe existir un enlace <a> con id='portfolioLink'.");
assert(link.getAttribute("target") === "_blank", "Etapa 3: El enlace debe tener target='_blank' para abrir en pestaña nueva.");
assert(link.hasAttribute("rel") && link.getAttribute("rel").includes("noopener"), "Etapa 3: Por seguridad el enlace debe incluir rel con 'noopener'.");
assert(link.textContent.trim() === "Ver Repositorio", "Etapa 3: El texto visible del enlace debe ser 'Ver Repositorio'.");
console.log("✓ [Seguridad Web] Enlace externo seguro con target y rel validados");$TEST$
    );

    -- ==============================================================================
    -- 🎨 MÓDULO 2: ARQUITECTURA DE ESTILOS Y MAQUETACIÓN MODERNA CON CSS3
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 2: Arquitectura de Estilos y Maquetación Moderna con CSS3',
        'Aprende a separar estilos en archivos externos, domina el Box Model, maquetación flexible con Flexbox y grillas con CSS Grid.'
    )
    RETURNING id INTO v_m2_id;

    -- Lección 2.1 (Multi-Archivo: Vinculación Externa de CSS y Box Model)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.1 Separación de Archivos CSS y el Box Model',
        'Crea y vincula un archivo styles.css externo mediante <link> y domina el modelo de caja.',
        'web',
        85,
        1,
        $THEORY$# 🎨 Separación de Responsabilidades y el Modelo de Caja (CSS Box Model)

En proyectos reales, los estilos nunca deben mezclarse con la estructura HTML mediante etiquetas `<style>` incrustadas o estilos en línea (`style="..."`). 

El principio fundamental del desarrollo web es la **separación de responsabilidades (*Separation of Concerns*)**:
- **HTML:** Estructura y contenido semántico.
- **CSS:** Presentación visual, colores y maquetación.
- **JavaScript:** Comportamiento y dinamismo interactivo.

---

### 1. Vinculación de Hojas de Estilo Externas

Para conectar una hoja de estilos externa almacenada en la carpeta `css/` con tu documento `index.html`, utilizamos la etiqueta `<link>` en el `<head>`:

```html
<head>
  <link rel="stylesheet" href="css/styles.css">
</head>
```
- `rel="stylesheet"`: Le indica al navegador la relación del recurso con el documento.
- `href="css/styles.css"`: La ruta relativa hacia el archivo CSS en la estructura del proyecto.

---

### 2. El Modelo de Caja de CSS (*Box Model*)

Cada elemento visible en el navegador es conceptualmente una **caja rectangular** con cuatro capas:

```text
+---------------------------+
|          Margin           |  <-- Espacio transparente exterior
|  +---------------------+  |
|  |       Border        |  |  <-- Borde visible alrededor del padding
|  |  +---------------+  |  |
|  |  |    Padding    |  |  |  <-- Relleno interno transparente
|  |  |  +---------+  |  |  |
|  |  |  | Content |  |  |  |  <-- Texto, imágenes o hijos
|  |  |  +---------+  |  |  |
|  |  +---------------+  |  |
|  +---------------------+  |
+---------------------------+
```

1. **Content:** El área de contenido (ancho `width` y alto `height`).
2. **Padding:** El colchón o aire interno entre el contenido y el borde.
3. **Border:** Línea perimetral visible (`border: 2px solid #8b5cf6`).
4. **Margin:** El espacio exterior que separa a este elemento de las cajas adyacentes.

#### La regla indispensable: `box-sizing: border-box`
Por defecto en CSS antiguo (`content-box`), si defines un `width: 300px` y agregas `padding: 20px`, el ancho real de la caja se vuelve `340px`, rompiendo tus diseños. Con `border-box`, el ancho total siempre respetará los `300px`.

---

### 🎯 Tu Misión de Hoy:
Este es tu **primer reto multi-archivo**:
1. En `index.html`:
   - En el `<head>`, vincula el archivo de estilos externo usando:
     `<link rel="stylesheet" href="css/styles.css">`.
   - En el `<body>`, crea un contenedor `<div id="boxHero">Box Model Profesional</div>`.
2. En la pestaña `css/styles.css`:
   - Configura el selector `#boxHero` con:
     - `background-color: #1e1e2e;`
     - `color: #ffffff;`
     - `padding: 24px;`
     - `margin: 16px;`
     - `border: 2px solid #8b5cf6;`
     - `border-radius: 12px;`
     - `box-sizing: border-box;`

> 🚀 **Novedad en el IDE:** ¡Cambia entre la pestaña `index.html` y `css/styles.css` en la barra superior para editar cada archivo!

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: El modelo de caja](https://developer.mozilla.org/es/docs/Learn/CSS/Building_blocks/The_box_model)
- [MDN Web Docs: Cómo estructurar CSS](https://developer.mozilla.org/es/docs/Learn/CSS/First_steps/How_CSS_is_structured)
- [W3C: Especificación del Modelo de Caja CSS](https://www.w3.org/TR/css-box-3/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>CSS Box Model</title>\n  <!-- 1. Vincula el archivo externo css/styles.css con <link rel=\"stylesheet\"> -->\n\n</head>\n<body>\n  <!-- 2. Crea el elemento <div id=\"boxHero\"> -->\n\n</body>\n</html>",
    "css/styles.css": "/* Escribe los estilos para #boxHero aquí */\n#boxHero {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "css/styles.css",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>CSS Box Model</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <div id=\"boxHero\">Box Model Profesional</div>\n</body>\n</html>",
    "css/styles.css": "/* Estilos del Box Model Profesional */\n#boxHero {\n  background-color: #1e1e2e;\n  color: #ffffff;\n  padding: 24px;\n  margin: 16px;\n  border: 2px solid #8b5cf6;\n  border-radius: 12px;\n  box-sizing: border-box;\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

// ETAPA 1: Estructura de Archivos
assert(files["index.html"] !== undefined, "Etapa 1: Debe existir el archivo 'index.html'.");
const hasCssFile = files["css/styles.css"] !== undefined || files["styles.css"] !== undefined;
assert(hasCssFile, "Etapa 1: Debe existir el archivo de estilos 'css/styles.css' en el proyecto.");
console.log("✓ [Archivos] Proyecto multi-archivo con index.html y css/styles.css verificado");

// ETAPA 2: Vinculación de Recursos
const linkTag = document.querySelector("link[rel='stylesheet']");
assert(linkTag !== null, "Etapa 2: Debe existir una etiqueta <link rel='stylesheet'> en el <head> de index.html.");
const href = linkTag.getAttribute("href") || "";
assert(href.includes("styles.css"), "Etapa 2: La etiqueta <link> debe apuntar al archivo CSS (href='css/styles.css').");
console.log("✓ [Vinculación] Hoja de estilos externa correctamente vinculada con <link>");

// ETAPA 3: Elemento DOM
const box = document.getElementById("boxHero");
assert(box !== null, "Etapa 3: Debe existir el elemento con id='boxHero' en el body.");
console.log("✓ [DOM] Elemento #boxHero detectado en el documento");

// ETAPA 4: Evaluación de Estilos CSS
const cssContent = files["css/styles.css"] || files["styles.css"] || "";
assert(cssContent.includes("#boxHero"), "Etapa 4: El archivo css/styles.css debe incluir una regla para el selector '#boxHero'.");
assert(cssContent.includes("padding") && cssContent.includes("24px"), "Etapa 4: Debes definir 'padding: 24px' en css/styles.css.");
assert(cssContent.includes("margin") && cssContent.includes("16px"), "Etapa 4: Debes definir 'margin: 16px' en css/styles.css.");
assert(cssContent.includes("border-radius") && cssContent.includes("12px"), "Etapa 4: Debes definir 'border-radius: 12px' en css/styles.css.");
console.log("✓ [CSS] Propiedades del Box Model (padding, margin, border-radius) aplicadas exitosamente");$TEST$
    );

    -- Lección 2.2 (Multi-Archivo: Maquetación Flexible con CSS Flexbox)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.2 Maquetación con CSS Flexbox en 1 Dimensión',
        'Construye barras de navegación y componentes alineados con display: flex y gap.',
        'web',
        90,
        2,
        $THEORY$# 📐 CSS Flexbox: El Superpoder de la Alineación Unidimensional

Antes de Flexbox (2009), alinear vertical u horizontalmente dos elementos en CSS requería trucos sucios con `float: left`, `clear: both` y tablas invisibles.

**Flexbox (*Flexible Box Layout*)** revolucionó el diseño web permitiendo que un contenedor distribuya el espacio entre sus elementos hijos de manera predecible y fluida a lo largo de un **eje principal** (fila o columna).

---

### 1. El Contenedor Flexible (*Flex Container*)

Para activar Flexbox, simplemente aplicamos en el contenedor:
```css
.contenedor {
  display: flex;
}
```
Automáticamente, todos los hijos directos se convierten en **elementos flexibles (*flex items*)** alineados en fila horizontal.

---

### 2. Propiedades Clave de Flexbox

#### A. `justify-content` (Alineación en el Eje Principal)
Controla cómo se distribuye el espacio sobrante horizontalmente:
- `flex-start`: Elementos pegados al inicio (izquierda).
- `center`: Elementos agrupados en el centro.
- `flex-end`: Elementos pegados al final (derecha).
- `space-between`: Primer elemento a la izquierda, último a la derecha, y espacio distribuido de forma idéntica entre los intermedios (ideal para barras de navegación).

#### B. `align-items` (Alineación en el Eje Transversal)
Controla la alineación vertical de los elementos:
- `center`: Centrado vertical perfecto de todos los hijos.
- `stretch` (por defecto): Estira los elementos para llenar la altura máxima.

#### C. `gap` (Espaciado Moderno)
- `gap: 16px;`: Define la distancia exacta entre elementos hijos sin necesidad de aplicar `margin-right` manual ni lidiar con el último elemento.

---

### 🎯 Tu Misión de Hoy:
Construye una barra de navegación profesional multi-archivo:
1. En `index.html`:
   - Vincula `css/styles.css` con `<link rel="stylesheet" href="css/styles.css">`.
   - Crea un elemento `<nav id="navbar">`.
   - Dentro del `<nav>`, agrega:
     - Un `<div id="logo">Codify</div>`.
     - Un `<div id="navLinks">`: con dos enlaces `<a href="#cursos">Cursos</a>` y `<a href="#comunidad">Comunidad</a>`.
     - Un botón `<button id="btnLogin">Ingresar</button>`.
2. En `css/styles.css`:
   - Configura `#navbar` con:
     - `display: flex;`
     - `justify-content: space-between;`
     - `align-items: center;`
     - `padding: 16px 24px;`
     - `background-color: #0d0d11;`
   - Configura `#navLinks` con:
     - `display: flex;`
     - `gap: 16px;`

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Conceptos básicos de Flexbox](https://developer.mozilla.org/es/docs/Learn/CSS/CSS_layout/Flexbox)
- [CSS-Tricks: Una guía completa de Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
- [W3C: Especificación Flexible Box Layout Nivel 1](https://www.w3.org/TR/css-flexbox-1/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Navbar con Flexbox</title>\n  <!-- Vincula css/styles.css -->\n\n</head>\n<body>\n  <!-- Crea el <nav id=\"navbar\"> con logo, navLinks y btnLogin -->\n  <nav id=\"navbar\">\n    \n  </nav>\n</body>\n</html>",
    "css/styles.css": "/* Escribe las reglas de Flexbox para #navbar y #navLinks */\n#navbar {\n  \n}\n\n#navLinks {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "css/styles.css",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Navbar con Flexbox</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <nav id=\"navbar\">\n    <div id=\"logo\">Codify</div>\n    <div id=\"navLinks\">\n      <a href=\"#cursos\">Cursos</a>\n      <a href=\"#comunidad\">Comunidad</a>\n    </div>\n    <button id=\"btnLogin\">Ingresar</button>\n  </nav>\n</body>\n</html>",
    "css/styles.css": "/* Estilos de Barra de Navegación Flexbox */\n#navbar {\n  display: flex;\n  justify-content: space-between;\n  align-items: center;\n  padding: 16px 24px;\n  background-color: #0d0d11;\n}\n\n#navLinks {\n  display: flex;\n  gap: 16px;\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

// ETAPA 1: Archivos y Vinculación
assert(files["index.html"] !== undefined && (files["css/styles.css"] !== undefined || files["styles.css"] !== undefined), "Etapa 1: Deben existir index.html y css/styles.css.");
const link = document.querySelector("link[rel='stylesheet']");
assert(link !== null, "Etapa 1: Debe existir la etiqueta <link rel='stylesheet'>.");
console.log("✓ [Archivos] Archivos vinculados correctamente");

// ETAPA 2: Estructura HTML de Navegación
const navbar = document.getElementById("navbar");
assert(navbar !== null, "Etapa 2: Debe existir el elemento <nav id='navbar'>.");
const logo = document.getElementById("logo");
assert(logo !== null, "Etapa 2: Debe existir <div id='logo'> dentro del navbar.");
const navLinks = document.getElementById("navLinks");
assert(navLinks !== null, "Etapa 2: Debe existir <div id='navLinks'> con los enlaces.");
const btnLogin = document.getElementById("btnLogin");
assert(btnLogin !== null, "Etapa 2: Debe existir <button id='btnLogin'>.");
console.log("✓ [HTML] Estructura de la barra de navegación completada");

// ETAPA 3: Propiedades Flexbox
const cssContent = files["css/styles.css"] || files["styles.css"] || "";
assert(cssContent.includes("display") && cssContent.includes("flex"), "Etapa 3: Debes aplicar 'display: flex' en tus estilos.");
assert(cssContent.includes("justify-content") && cssContent.includes("space-between"), "Etapa 3: #navbar debe tener 'justify-content: space-between'.");
assert(cssContent.includes("align-items") && cssContent.includes("center"), "Etapa 3: #navbar debe tener 'align-items: center'.");
assert(cssContent.includes("gap"), "Etapa 3: #navLinks debe utilizar la propiedad 'gap'.");
console.log("✓ [Flexbox] Alineación horizontal (space-between) y vertical (center) validadas");$TEST$
    );

    -- Lección 2.3 (Multi-Archivo: Grillas Bidimensionales con CSS Grid)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.3 Grillas Bidimensionales con CSS Grid',
        'Organiza catálogos y tarjetas en filas y columnas simultáneas con grid-template-columns.',
        'web',
        90,
        3,
        $THEORY$# 🗂️ CSS Grid: Diseño Bidimensional a Escala

Mientras que **Flexbox** está optimizado para acomodar elementos en **una sola dimensión** (o una fila o una columna), **CSS Grid Layout** es el primer sistema nativo diseñado específicamente para controlar **dos dimensiones simultáneamente** (filas y columnas al mismo tiempo).

---

### 1. Conceptos Fundamentales de CSS Grid

```css
.catalogo {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}
```

1. `display: grid`: Transforma al elemento en un contenedor de cuadrícula.
2. `grid-template-columns`: Define cuántas columnas componen la grilla y el ancho de cada una.
3. La unidad `fr` (*Fractional Unit*):
   - Representa una fracción del espacio libre disponible en el contenedor.
   - `repeat(3, 1fr)` es equivalente a escribir `1fr 1fr 1fr`: tres columnas de ancho exactamente idéntico que se adaptan fluidamente a la pantalla.
4. `gap: 20px`: Espaciado homogéneo entre filas y columnas de la cuadrícula.

---

### 2. Flexbox vs. CSS Grid: ¿Cuándo usar cuál?

- **Usa Flexbox cuando:** Tengas una barra de navegación, botones juntos, elementos lineales o quieras alinear un contenido al centro vertical de una tarjeta.
- **Usa CSS Grid cuando:** Tengas una cuadrícula de productos, tarjetas de cursos, galerías de fotos o el layout global de la página con barra lateral y contenido.

---

### 🎯 Tu Misión de Hoy:
1. En `index.html`:
   - Vincula `css/styles.css`.
   - Crea un contenedor `<div id="cursosGrid">`.
   - Dentro del contenedor, inserta 3 tarjetas `<div class="curso-card">`:
     - La primera con texto `"Curso 1: HTML5"`.
     - La segunda con texto `"Curso 2: CSS3"`.
     - La tercera con texto `"Curso 3: JavaScript"`.
2. En `css/styles.css`:
   - Aplica a `#cursosGrid`:
     - `display: grid;`
     - `grid-template-columns: repeat(3, 1fr);`
     - `gap: 20px;`
   - Aplica a `.curso-card`:
     - `background-color: #18181b;`
     - `padding: 20px;`
     - `border-radius: 8px;`
     - `border: 1px solid rgba(255, 255, 255, 0.1);`

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Conceptos básicos de Grid Layout](https://developer.mozilla.org/es/docs/Learn/CSS/CSS_layout/Grids)
- [CSS-Tricks: Guía completa de CSS Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)
- [W3C: CSS Grid Layout Module Nivel 2](https://www.w3.org/TR/css-grid-2/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Catálogo con CSS Grid</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <!-- Crea el <div id=\"cursosGrid\"> con 3 <div class=\"curso-card\"> -->\n  <div id=\"cursosGrid\">\n    \n  </div>\n</body>\n</html>",
    "css/styles.css": "/* Define la grilla con grid-template-columns y estilos de tarjeta */\n#cursosGrid {\n  \n}\n\n.curso-card {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "css/styles.css",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Catálogo con CSS Grid</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <div id=\"cursosGrid\">\n    <div class=\"curso-card\">Curso 1: HTML5</div>\n    <div class=\"curso-card\">Curso 2: CSS3</div>\n    <div class=\"curso-card\">Curso 3: JavaScript</div>\n  </div>\n</body>\n</html>",
    "css/styles.css": "/* Estilos de la Cuadrícula 2D */\n#cursosGrid {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  gap: 20px;\n}\n\n.curso-card {\n  background-color: #18181b;\n  padding: 20px;\n  border-radius: 8px;\n  border: 1px solid rgba(255, 255, 255, 0.1);\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const grid = document.getElementById("cursosGrid");
assert(grid !== null, "Etapa 1: Debe existir el contenedor <div id='cursosGrid'> en index.html.");

const cards = grid.querySelectorAll(".curso-card");
assert(cards.length === 3, "Etapa 1: Deben existir exactamente 3 elementos con clase 'curso-card' dentro de #cursosGrid.");
console.log("✓ [HTML] 3 tarjetas de curso estructuradas en el catálogo");

const cssContent = files["css/styles.css"] || files["styles.css"] || "";
assert(cssContent.includes("display") && cssContent.includes("grid"), "Etapa 2: El archivo CSS debe incluir 'display: grid' en #cursosGrid.");
assert(cssContent.includes("grid-template-columns"), "Etapa 2: Debes definir 'grid-template-columns' para las 3 columnas.");
assert(cssContent.includes("gap"), "Etapa 2: Debes utilizar la propiedad 'gap' para el espaciado de la grilla.");
console.log("✓ [CSS Grid] Cuadrícula bidimensional 3x1 configurada con fractional units (fr)");$TEST$
    );

    -- Lección 2.4 (Multi-Archivo: Variables CSS y Sistema de Temas)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m2_id,
        '2.4 Variables CSS (Custom Properties) y Temas',
        'Crea tokens de diseño reutilizables con variables nativas en el pseudo-selector :root.',
        'web',
        85,
        4,
        $THEORY$# 🎨 Variables CSS (*Custom Properties*) y Sistemas de Diseño

En aplicaciones web de mediana y gran escala, cambiar un color principal puede requerir modificar cientos de líneas de código si los valores hexadecimales están escritos a mano (*hardcoded*).

Las **Variables CSS (*CSS Custom Properties*)** permiten almacenar valores reutilizables (colores, tipografías, sombras, radios de borde) en una única fuente de verdad.

---

### 1. Declaración Global en `:root`

El pseudo-selector `:root` coincide con el elemento raíz del documento (`<html>`), pero tiene mayor especificidad. Es el lugar estándar para declarar variables globales:

```css
:root {
  --primary-color: #8b5cf6;
  --bg-dark: #09090b;
  --text-light: #fafafa;
  --border-radius: 12px;
}
```
> **Nota de sintaxis:** Todas las variables CSS deben comenzar obligatoriamente con dos guiones medios `--`.

---

### 2. Uso con la Función `var()`

Para consumir una variable en cualquier regla:
```css
.boton-principal {
  background-color: var(--primary-color);
  color: var(--text-light);
  border-radius: var(--border-radius);
}
```

---

### 🎯 Tu Misión de Hoy:
1. En `index.html`:
   - Vincula `css/styles.css`.
   - Crea un elemento `<div id="statusTema">Tema Oscuro Activado</div>`.
2. En `css/styles.css`:
   - Declara en `:root`:
     - `--bg-color: #09090b;`
     - `--text-color: #fafafa;`
     - `--primary-accent: #8b5cf6;`
   - Aplica a `#statusTema`:
     - `background-color: var(--bg-color);`
     - `color: var(--text-color);`
     - `border: 2px solid var(--primary-accent);`
     - `padding: 16px;`
     - `border-radius: 8px;`

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Uso de propiedades personalizadas de CSS](https://developer.mozilla.org/es/docs/Web/CSS/Using_CSS_custom_properties)
- [W3C: CSS Custom Properties for Cascading Variables Module Nivel 1](https://www.w3.org/TR/css-variables-1/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "css/styles.css",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Variables CSS</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <div id=\"statusTema\">Tema Oscuro Activado</div>\n</body>\n</html>",
    "css/styles.css": "/* Declara las variables en :root y aplícalas en #statusTema */\n:root {\n  \n}\n\n#statusTema {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "css/styles.css",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Variables CSS</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <div id=\"statusTema\">Tema Oscuro Activado</div>\n</body>\n</html>",
    "css/styles.css": ":root {\n  --bg-color: #09090b;\n  --text-color: #fafafa;\n  --primary-accent: #8b5cf6;\n}\n\n#statusTema {\n  background-color: var(--bg-color);\n  color: var(--text-color);\n  border: 2px solid var(--primary-accent);\n  padding: 16px;\n  border-radius: 8px;\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const cssContent = files["css/styles.css"] || files["styles.css"] || "";
assert(cssContent.includes(":root"), "Etapa 1: Debes declarar el bloque :root en tu archivo CSS.");
assert(cssContent.includes("--bg-color") && cssContent.includes("#09090b"), "Etapa 1: La variable --bg-color debe estar definida en :root con '#09090b'.");
assert(cssContent.includes("--text-color") && cssContent.includes("#fafafa"), "Etapa 1: La variable --text-color debe estar definida en :root con '#fafafa'.");
assert(cssContent.includes("--primary-accent") && cssContent.includes("#8b5cf6"), "Etapa 1: La variable --primary-accent debe estar definida en :root con '#8b5cf6'.");
console.log("✓ [Tokens de Diseño] Variables globales :root correctamente declaradas");

assert(cssContent.includes("var(--bg-color)"), "Etapa 2: Debes consumir var(--bg-color) en #statusTema.");
assert(cssContent.includes("var(--text-color)"), "Etapa 2: Debes consumir var(--text-color) en #statusTema.");
assert(cssContent.includes("var(--primary-accent)"), "Etapa 2: Debes consumir var(--primary-accent) en el borde de #statusTema.");

const statusDiv = document.getElementById("statusTema");
assert(statusDiv !== null, "Etapa 3: Debe existir <div id='statusTema'> en el DOM.");
console.log("✓ [CSS Variables] Variables consumidas dinámicamente con var()");$TEST$
    );

    -- ==============================================================================
    -- ⚡ MÓDULO 3: JAVASCRIPT DINÁMICO, EVENTOS Y PROYECTO INTEGRADOR
    -- ==============================================================================
    INSERT INTO public.modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 3: Dinamismo con JavaScript y Proyecto Integrador Multi-Archivo',
        'Conecta HTML, CSS y JS en una arquitectura desacoplada: manipula el DOM, escucha eventos y construye una aplicación completa.'
    )
    RETURNING id INTO v_m3_id;

    -- Lección 3.1 (Multi-Archivo: Separación de Lógica en js/app.js y Manipulación del DOM)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.1 Separación de Lógica en js/app.js y Mutación del DOM',
        'Vincula scripts externos con <script src="js/app.js"> y modifica elementos en tiempo real.',
        'web',
        85,
        1,
        $THEORY$# ⚡ Separación de Lógica en `js/app.js` y el DOM Dinámico

Hasta ahora tu página web tiene estructura (**HTML**) y diseño estético (**CSS**). Ahora aprenderás a transformar páginas estáticas en **aplicaciones web interactivas** utilizando **JavaScript**.

---

### 1. Vinculación de Scripts Externos

Al igual que separamos las hojas de estilos en `css/styles.css`, la lógica de programación se ubica en su propia carpeta `js/app.js` y se vincula en `index.html`:

```html
<body>
  <!-- Todo el contenido visual aquí -->

  <!-- Vinculación del script justo antes de cerrar el body -->
  <script src="js/app.js"></script>
</body>
```
> **¿Por qué al final del `<body>`?** Porque el navegador lee el código de arriba a abajo. Si colocas el script antes de que los elementos HTML se hayan dibujado, `document.querySelector` devolverá `null` porque los elementos aún no existen en el DOM.

---

### 2. Métodos Esenciales de Manipulación del DOM

1. `document.getElementById("id")`: Encuentra un elemento por su identificador único.
2. `document.querySelector(".clase")`: Busca con cualquier selector CSS.
3. `elemento.textContent = "Nuevo Texto"`: Cambia de forma segura el texto visible sin riesgo de inyecciones XSS.
4. `elemento.classList.add("activo")` / `elemento.classList.remove("oculto")`: Añade o retira clases CSS dinámicamente.

---

### 🎯 Tu Misión de Hoy:
1. En `index.html`:
   - Vincula `js/app.js` mediante `<script src="js/app.js"></script>`.
   - Crea un elemento `<h1 id="username">Invitado</h1>`.
2. En `js/app.js`:
   - Escribe una función `actualizarPerfil(nuevoNombre)` que:
     - Obtenga el elemento con `id="username"`.
     - Actualice su `textContent` al valor de `nuevoNombre`.
     - Le agregue la clase CSS `"verificado"`.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Manipulando documentos (Introducción al DOM)](https://developer.mozilla.org/es/docs/Learn/JavaScript/Client-side_web_APIs/Manipulating_documents)
- [MDN Web Docs: Document.querySelector()](https://developer.mozilla.org/es/docs/Web/API/Document/querySelector)
- [WHATWG: Estándar del DOM Vivo](https://dom.spec.whatwg.org/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>DOM con JavaScript</title>\n</head>\n<body>\n  <h1 id=\"username\">Invitado</h1>\n\n  <!-- Vincula el script js/app.js antes del cierre de body -->\n\n</body>\n</html>",
    "js/app.js": "// Implementa la función actualizarPerfil(nuevoNombre)\nfunction actualizarPerfil(nuevoNombre) {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>DOM con JavaScript</title>\n</head>\n<body>\n  <h1 id=\"username\">Invitado</h1>\n\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "js/app.js": "function actualizarPerfil(nuevoNombre) {\n  const userEl = document.getElementById(\"username\");\n  if (userEl) {\n    userEl.textContent = nuevoNombre;\n    userEl.classList.add(\"verificado\");\n  }\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

// ETAPA 1: Vinculación del Script
assert(files["index.html"] !== undefined, "Etapa 1: Debe existir el archivo 'index.html'.");
assert(files["js/app.js"] !== undefined || files["app.js"] !== undefined, "Etapa 1: Debe existir el archivo de script 'js/app.js'.");
const scriptTag = document.querySelector("script[src*='app.js']");
assert(scriptTag !== null, "Etapa 1: index.html debe incluir <script src='js/app.js'></script>.");
console.log("✓ [Archivos] Script externo js/app.js correctamente vinculado con <script>");

// ETAPA 2: Ejecución de la Función y Mutación del DOM
const heading = document.getElementById("username");
assert(heading !== null, "Etapa 2: Debe existir el elemento con id='username' en el body.");

const jsCode = files["js/app.js"] || files["app.js"] || "";
assert(jsCode.includes("function actualizarPerfil"), "Etapa 2: js/app.js debe definir la función 'actualizarPerfil'.");

// Ejecutar función en el contexto del sandbox
const fn = new Function("document", `${jsCode}\nactualizarPerfil("Ada Lovelace");`);
fn(document);

assert(heading.textContent === "Ada Lovelace", "Etapa 3: El textContent de #username debe actualizarse a 'Ada Lovelace'.");
assert(heading.classList.contains("verificado"), "Etapa 3: Debe agregarse la clase CSS 'verificado' al elemento #username.");
console.log("✓ [JavaScript DOM] Modificación de texto y clases en tiempo real comprobada");$TEST$
    );

    -- Lección 3.2 (Multi-Archivo: Eventos del Navegador addEventListener)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.2 Escucha de Eventos y Reactividad (addEventListener)',
        'Responde a interacciones del usuario en tiempo real sin recargar la página.',
        'web',
        95,
        2,
        $THEORY$# 🖱️ La Arquitectura Orientada a Eventos: `addEventListener`

El navegador opera bajo un modelo de programación basado en eventos: el código no se ejecuta solo una vez al cargar, sino que queda "escuchando" silenciosamente a la espera de que el usuario interactúe.

---

### 1. El Método Estándar `addEventListener`

```javascript
const boton = document.getElementById("miBoton");

boton.addEventListener("click", (evento) => {
  console.log("¡El usuario hizo clic en el botón!");
});
```

#### Parámetros:
1. **Tipo de evento:** Una cadena con el nombre del evento (ej: `"click"`, `"input"`, `"submit"`).
2. **Función manejadora (*Callback*):** La función que se ejecutará cada vez que el evento ocurra.

---

### 2. Manejo de Estado en Memoria

Para crear componentes como contadores o carritos de compras, combinamos variables de estado en JavaScript con actualización del DOM:

```javascript
let contador = 0;

boton.addEventListener("click", () => {
  contador++;
  contadorDisplay.textContent = contador;
});
```

---

### 🎯 Tu Misión de Hoy:
1. En `index.html`:
   - Vincula `js/app.js`.
   - Crea un botón `<button id="btnLike">Me gusta (0)</button>`.
2. En `js/app.js`:
   - Implementa un contador de likes reactivo:
     - Obtén la referencia del botón `#btnLike`.
     - Mantén una variable `likes = 0`.
     - Agrega un `addEventListener("click", ...)` que en cada pulsación aumente los likes y actualice el texto del botón a `"Me gusta (X)"`.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Introducción a los eventos](https://developer.mozilla.org/es/docs/Learn/JavaScript/Building_blocks/Events)
- [MDN Web Docs: EventTarget.addEventListener()](https://developer.mozilla.org/es/docs/Web/API/EventTarget/addEventListener)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Eventos en JS</title>\n</head>\n<body>\n  <!-- Crea el botón #btnLike con texto \"Me gusta (0)\" y vincula js/app.js -->\n  <button id=\"btnLike\">Me gusta (0)</button>\n\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "js/app.js": "// Obtén #btnLike y añade el addEventListener para incrementar los likes\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Eventos en JS</title>\n</head>\n<body>\n  <button id=\"btnLike\">Me gusta (0)</button>\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "js/app.js": "const btnLike = document.getElementById(\"btnLike\");\nlet likes = 0;\n\nif (btnLike) {\n  btnLike.addEventListener(\"click\", () => {\n    likes++;\n    btnLike.textContent = `Me gusta (${likes})`;\n  });\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const btn = document.getElementById("btnLike");
assert(btn !== null, "Etapa 1: Debe existir el elemento <button id='btnLike'> en index.html.");
assert(btn.textContent.trim() === "Me gusta (0)", "Etapa 1: El texto inicial debe ser 'Me gusta (0)'.");
console.log("✓ [DOM] Botón inicial encontrado");

const jsCode = files["js/app.js"] || files["app.js"] || "";
assert(jsCode.includes("addEventListener") && jsCode.includes("click"), "Etapa 2: Debes utilizar addEventListener('click', ...) en js/app.js.");

// Ejecutar el script y disparar eventos simulados
const runner = new Function("document", "window", jsCode);
runner(document, window);

btn.click();
assert(btn.textContent.trim() === "Me gusta (1)", "Etapa 3: Tras el primer clic el botón debe decir 'Me gusta (1)'.");
btn.click();
assert(btn.textContent.trim() === "Me gusta (2)", "Etapa 3: Tras el segundo clic el botón debe decir 'Me gusta (2)'.");
console.log("✓ [Eventos] Reactividad y despacho de clics comprobados");$TEST$
    );

    -- Lección 3.3 (Multi-Archivo: Renderizado Dinámico de Datos con Arrays)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.3 Renderizado Dinámico de Datos (Arrays a HTML)',
        'Transforma arreglos de datos en listas visuales en el DOM con document.createElement.',
        'web',
        95,
        3,
        $THEORY$# 🔄 Del Dato a la Vista: Renderizado Dinámico

En el desarrollo frontend moderno, las aplicaciones rara vez tienen el contenido escrito a mano en el HTML. En su lugar, reciben colecciones de datos (arreglos de usuarios, productos, mensajes) desde una base de datos o API y los renderizan dinámicamente en el DOM.

---

### 1. El Patrón de Construcción de Elementos

```javascript
const tecnologias = ["HTML5", "CSS3", "JavaScript"];
const contenedor = document.getElementById("lista");

tecnologias.forEach((tech) => {
  // 1. Crear el nodo en memoria
  const li = document.createElement("li");

  // 2. Asignar atributos y contenido
  li.className = "item-tech";
  li.textContent = tech;

  // 3. Insertarlo en el árbol del DOM
  contenedor.appendChild(li);
});
```

---

### 🎯 Tu Misión de Hoy:
1. En `index.html`:
   - Vincula `js/app.js`.
   - Crea un contenedor `<ul id="skillsList"></ul>`.
2. En `js/app.js`:
   - Escribe una función `renderizarHabilidades(listaDatos)` que:
     - Obtenga `#skillsList`.
     - Limpie su contenido previo (`innerHTML = ""`).
     - Itere sobre `listaDatos` y para cada elemento cree un `<li class="skill-badge">` con su texto correspondiente y lo inserte en `#skillsList`.

---

### 📚 Documentación Oficial Recomendada:
- [MDN Web Docs: Document.createElement()](https://developer.mozilla.org/es/docs/Web/API/Document/createElement)
- [MDN Web Docs: Node.appendChild()](https://developer.mozilla.org/es/docs/Web/API/Node/appendChild)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Renderizado Dinámico</title>\n</head>\n<body>\n  <h2>Habilidades Técnicas</h2>\n  <ul id=\"skillsList\"></ul>\n\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "js/app.js": "// Implementa renderizarHabilidades(listaDatos)\nfunction renderizarHabilidades(listaDatos) {\n  \n}\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "js/app.js",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Renderizado Dinámico</title>\n</head>\n<body>\n  <h2>Habilidades Técnicas</h2>\n  <ul id=\"skillsList\"></ul>\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "js/app.js": "function renderizarHabilidades(listaDatos) {\n  const ul = document.getElementById(\"skillsList\");\n  if (!ul) return;\n  ul.innerHTML = \"\";\n\n  listaDatos.forEach((tech) => {\n    const li = document.createElement(\"li\");\n    li.className = \"skill-badge\";\n    li.textContent = tech;\n    ul.appendChild(li);\n  });\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

const ul = document.getElementById("skillsList");
assert(ul !== null, "Etapa 1: Debe existir el elemento <ul id='skillsList'> en index.html.");

const jsCode = files["js/app.js"] || files["app.js"] || "";
assert(jsCode.includes("function renderizarHabilidades"), "Etapa 2: Debe existir la función renderizarHabilidades en js/app.js.");

// Probar con array de prueba
const runner = new Function("document", `${jsCode}\nrenderizarHabilidades(["HTML5", "CSS3", "JavaScript", "TypeScript"]);`);
runner(document);

const items = ul.querySelectorAll(".skill-badge");
assert(items.length === 4, "Etapa 3: Deben renderizarse exactamente 4 elementos con clase 'skill-badge'.");
assert(items[0].textContent === "HTML5" && items[3].textContent === "TypeScript", "Etapa 3: El contenido de los <li> debe coincidir con el array.");
console.log("✓ [Render Dinámico] Arrays convertidos a nodos DOM con appendChild()");$TEST$
    );

    -- Lección 3.4 (Proyecto Integrador Completo: Mini App Web en 3 Archivos)
    INSERT INTO public.challenges (
        module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
    ) VALUES (
        v_m3_id,
        '3.4 🏆 Proyecto Integrador: Mini App Web Completa en 3 Archivos',
        'Integra la arquitectura web completa: HTML5 semántico, CSS3 estilizado y JavaScript interactivo en 3 archivos sincronizados.',
        'web',
        150,
        4,
        $THEORY$# 🏆 El Proyecto Integrador: Tu Primera Aplicación Web Completa

Has recorrido el camino completo de los **Fundamentos de la Programación Web**:
1. **HTML5:** Estructura semántica, formularios y accesibilidad a11y.
2. **CSS3:** Arquitectura externa, Box Model, Flexbox y Grid.
3. **JavaScript:** DOM API, escucha de eventos y renderizado de datos.

Ha llegado el momento de unir todas las piezas en un **Proyecto Web Real** de 3 archivos interconectados.

---

### 📁 Estructura del Proyecto

```text
todo-app/
├── index.html        <-- Estructura y vinculación
├── css/styles.css    <-- Estilos, diseño responsivo y flexbox
└── js/app.js         <-- Manejo de eventos y dinamismo
```

---

### 🎯 Requisitos de la Aplicación:

#### 1. En `index.html`:
- Vincula `css/styles.css` mediante `<link rel="stylesheet" href="css/styles.css">`.
- Crea un contenedor principal `<div id="todoApp">`:
  - Un encabezado `<h1>Gestor de Tareas</h1>`.
  - Un contenedor de entrada `<div id="inputGroup">`:
    - `<input id="taskInput" type="text" placeholder="Escribe una tarea...">`.
    - `<button id="btnAddTask">Agregar</button>`.
  - Una lista vacía `<ul id="taskList"></ul>`.
- Vincula `js/app.js` mediante `<script src="js/app.js"></script>`.

#### 2. En `css/styles.css`:
- `#todoApp`: fondo oscuro `#0d0d11`, `padding: 24px`, `border-radius: 12px`, `border: 1px solid rgba(255, 255, 255, 0.1)`.
- `#inputGroup`: `display: flex;` y `gap: 12px;`.
- `button#btnAddTask`: `background-color: #8b5cf6;`, `color: #ffffff;`, `border: none;`, `padding: 8px 16px;`, `border-radius: 6px;`.

#### 3. En `js/app.js`:
- Escucha el evento `"click"` en `#btnAddTask`.
- Si `#taskInput` tiene texto (no vacío):
  - Crea un nuevo elemento `<li>`.
  - Asigna el texto ingresado.
  - Insértalo en `#taskList`.
  - Limpia el campo de texto (`input.value = ""`).

---

### 📚 Documentación Oficial y Recursos para Continuar tu Aprendizaje:
- [MDN Web Docs: Guía Completa de Desarrollo Frontend](https://developer.mozilla.org/es/docs/Learn)
- [W3C: Estándares Abiertos para el Futuro de la Web](https://www.w3.org/standards/)
- [web.dev de Google: Buenas Prácticas Modernas](https://web.dev/learn/)$THEORY$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Mi Gestor de Tareas</title>\n  <!-- 1. Vincula css/styles.css -->\n\n</head>\n<body>\n  <!-- 2. Crea el contenedor #todoApp con inputGroup, taskInput, btnAddTask y taskList -->\n  <div id=\"todoApp\">\n    <h1>Gestor de Tareas</h1>\n    \n  </div>\n\n  <!-- 3. Vincula js/app.js -->\n\n</body>\n</html>",
    "css/styles.css": "/* Estilos de la aplicación en css/styles.css */\n#todoApp {\n  \n}\n\n#inputGroup {\n  \n}\n\n#btnAddTask {\n  \n}\n",
    "js/app.js": "// Manejo de eventos para agregar tareas en js/app.js\n"
  }
}$CODE$,
        $CODE${
  "type": "project",
  "activeFile": "index.html",
  "files": {
    "index.html": "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n  <meta charset=\"UTF-8\">\n  <title>Mi Gestor de Tareas</title>\n  <link rel=\"stylesheet\" href=\"css/styles.css\">\n</head>\n<body>\n  <div id=\"todoApp\">\n    <h1>Gestor de Tareas</h1>\n    <div id=\"inputGroup\">\n      <input id=\"taskInput\" type=\"text\" placeholder=\"Escribe una tarea...\">\n      <button id=\"btnAddTask\">Agregar</button>\n    </div>\n    <ul id=\"taskList\"></ul>\n  </div>\n\n  <script src=\"js/app.js\"></script>\n</body>\n</html>",
    "css/styles.css": "/* Estilos de la aplicación Todo */\n#todoApp {\n  background-color: #0d0d11;\n  padding: 24px;\n  border-radius: 12px;\n  border: 1px solid rgba(255, 255, 255, 0.1);\n  max-width: 480px;\n  margin: 20px auto;\n  color: #f4f4f5;\n}\n\n#inputGroup {\n  display: flex;\n  gap: 12px;\n  margin-bottom: 16px;\n}\n\n#taskInput {\n  flex: 1;\n  background: #18181b;\n  border: 1px solid #3f3f46;\n  color: white;\n  padding: 8px 12px;\n  border-radius: 6px;\n  outline: none;\n}\n\n#btnAddTask {\n  background-color: #8b5cf6;\n  color: #ffffff;\n  border: none;\n  padding: 8px 16px;\n  border-radius: 6px;\n  cursor: pointer;\n  font-weight: bold;\n}\n\n#taskList {\n  list-style: none;\n  padding: 0;\n  margin: 0;\n}\n\n#taskList li {\n  background: #18181b;\n  padding: 8px 12px;\n  border-radius: 6px;\n  margin-bottom: 8px;\n  border-left: 3px solid #8b5cf6;\n}\n",
    "js/app.js": "const btnAddTask = document.getElementById(\"btnAddTask\");\nconst taskInput = document.getElementById(\"taskInput\");\nconst taskList = document.getElementById(\"taskList\");\n\nif (btnAddTask && taskInput && taskList) {\n  btnAddTask.addEventListener(\"click\", () => {\n    const texto = taskInput.value.trim();\n    if (texto.length > 0) {\n      const li = document.createElement(\"li\");\n      li.textContent = texto;\n      taskList.appendChild(li);\n      taskInput.value = \"\";\n    }\n  });\n}\n"
  }
}$CODE$,
        $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };

// ETAPA 1: Verificación de los 3 Archivos
assert(files["index.html"] !== undefined, "Etapa 1: Debe existir el archivo 'index.html'.");
assert(files["css/styles.css"] !== undefined || files["styles.css"] !== undefined, "Etapa 1: Debe existir el archivo 'css/styles.css'.");
assert(files["js/app.js"] !== undefined || files["app.js"] !== undefined, "Etapa 1: Debe existir el archivo 'js/app.js'.");
console.log("✓ [Arquitectura] Estructura de 3 archivos (HTML, CSS, JS) validada");

// ETAPA 2: Vinculación Cruzada
const linkTag = document.querySelector("link[rel='stylesheet']");
assert(linkTag !== null, "Etapa 2: index.html debe vincular la hoja de estilos con <link rel='stylesheet'>.");
const scriptTag = document.querySelector("script[src*='app.js']");
assert(scriptTag !== null, "Etapa 2: index.html debe vincular el script con <script src='js/app.js'></script>.");
console.log("✓ [Vinculación] Recursos externos (CSS y JS) correctamente enlazados");

// ETAPA 3: Estructura DOM
const app = document.getElementById("todoApp");
const inputGroup = document.getElementById("inputGroup");
const taskInput = document.getElementById("taskInput");
const btnAddTask = document.getElementById("btnAddTask");
const taskList = document.getElementById("taskList");

assert(app !== null, "Etapa 3: Debe existir <div id='todoApp'>.");
assert(inputGroup !== null, "Etapa 3: Debe existir <div id='inputGroup'>.");
assert(taskInput !== null, "Etapa 3: Debe existir <input id='taskInput'>.");
assert(btnAddTask !== null, "Etapa 3: Debe existir <button id='btnAddTask'>.");
assert(taskList !== null, "Etapa 3: Debe existir <ul id='taskList'>.");
console.log("✓ [DOM] Componentes visuales de la aplicación presentes");

// ETAPA 4: Reglas CSS
const cssContent = files["css/styles.css"] || files["styles.css"] || "";
assert(cssContent.includes("#inputGroup") && cssContent.includes("display") && cssContent.includes("flex"), "Etapa 4: #inputGroup debe usar display: flex en css/styles.css.");
assert(cssContent.includes("#btnAddTask"), "Etapa 4: #btnAddTask debe tener estilos personalizados.");
console.log("✓ [Estilos CSS] Maquetación Flexbox y diseño visual completados");

// ETAPA 5: Comportamiento Interactivo y Lógica JS
const jsCode = files["js/app.js"] || files["app.js"] || "";
const runner = new Function("document", "window", jsCode);
runner(document, window);

taskInput.value = "Aprender Arquitectura Web";
btnAddTask.click();

const items = taskList.querySelectorAll("li");
assert(items.length === 1, "Etapa 5: Al hacer clic en agregar debe crearse un nuevo <li>.");
assert(items[0].textContent.trim() === "Aprender Arquitectura Web", "Etapa 5: El texto del <li> debe coincidir con la tarea.");
assert(taskInput.value === "", "Etapa 5: El input debe limpiarse tras agregar la tarea.");
console.log("✓ [Interactividad JS] Creación dinámica de tareas y reseteo de input verificado");
console.log("🏆 ¡PROYECTO INTEGRADOR COMPLETADO CON ÉXITO!");$TEST$
    );

END $$;
