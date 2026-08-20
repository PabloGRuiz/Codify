-- ==============================================================================
-- 🌐 CODIFY SEED: MÓDULO 3 - PROTOTIPADO WEB INTERACTIVO (10 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 3 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  web_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
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
    'Aprende desarrollo web profesional: Estructura semántica HTML5, estilos CSS3 modernos, diseño adaptable con Flexbox, manipulación del DOM en vivo y manejo de eventos.',
    1
  )
  RETURNING id INTO web_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Estructura Básica HTML5 (Los Cimientos de la Web)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 1: Estructura Básica HTML5',
    'Crea un encabezado h1 y un párrafo p y agrégalos dinámicamente a la página.',
    $THEORY$
### 🌐 1. Los Cimientos de la Web: ¿Qué es HTML5?
Imagina que construir un sitio web es como construir una casa:
- **HTML5** son los ladrillos, vigas y paredes (la estructura).
- **CSS3** es la pintura y decoración (el diseño).
- **JavaScript** es el sistema eléctrico y las puertas automáticas (la interactividad).

Las dos etiquetas fundamentales para mostrar texto son:
- `<h1>`: El **encabezado principal** del documento.
- `<p>`: Un **párrafo** de texto descriptivo.

---

### 🔨 2. Creación Dinámica de Elementos con JavaScript
Podemos crear elementos HTML desde JavaScript con 3 sencillos pasos:

```js
// 1. Crear el elemento en memoria:
const titulo = document.createElement("h1");

// 2. Asignarle texto o atributos:
titulo.textContent = "Bienvenido a mi Web";

// 3. Insertarlo dentro del documento visible:
document.body.appendChild(titulo);
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar el `appendChild`:** Si creas un elemento con `createElement` pero no lo agregas con `appendChild`, el elemento existirá en la memoria pero será invisible en la pantalla.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `crearEstructuraBase()` que:
1. Cree un elemento `<h1>` con el texto `"Mi Portafolio Web"`.
2. Cree un elemento `<p>` con `id = "presentacion"` y el texto `"Desarrollador en formación"`.
3. Inserte ambos elementos en `document.body` usando `appendChild`.
$THEORY$,
    'web',
    $CODE$function crearEstructuraBase() {
  // 1. Crea el h1 y asígnale su texto:
  
  // 2. Crea el p, asigna su id "presentacion" y su texto:
  
  // 3. Agrega ambos a document.body:
  
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
assert(h1 !== null, "Debe crearse e insertarse un elemento <h1>.");
assert(h1 && h1.textContent === "Mi Portafolio Web", "El <h1> debe contener el texto 'Mi Portafolio Web'.");
assert(p !== null, "Debe crearse un elemento <p> con id 'presentacion'.");
assert(p && p.textContent === "Desarrollador en formación", "El párrafo debe tener el texto 'Desarrollador en formación'.");$TEST$,
    30,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Hipervínculos e Imágenes (a & img)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 2: Enlaces e Imágenes (a & img)',
    'Conecta elementos multimedia usando atributos href y src.',
    $THEORY$
### 🔗 1. Conectando la Web: Enlaces e Imágenes
La Web se llama *Web* (telaraña) porque los sitios están conectados entre sí mediante **hipervínculos**:

1. **`<a>` (Enlaces / Links):**  
   Usa el atributo `href` (*Hypertext Reference*) para indicar la dirección URL a la que viaja el usuario.
2. **`<img>` (Imágenes):**  
   Usa el atributo `src` (*Source*) para indicar la URL de la imagen que debe mostrarse.

---

### 📝 2. Configuración de Atributos en Código
```js
// Crear un enlace:
const enlace = document.createElement("a");
enlace.href = "https://google.com";
enlace.textContent = "Buscar en Google";
document.body.appendChild(enlace);

// Crear una imagen:
const foto = document.createElement("img");
foto.src = "https://midominio.com/avatar.jpg";
document.body.appendChild(foto);
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Confundir `href` con `src`:** Recuerda: `href` es para enlaces `<a>`, mientras que `src` es la fuente de imágenes `<img>` y scripts.

---

### 🎯 Tu Misión de Hoy:
Crea una función `agregarMultimedia()` que agregue a `document.body`:
1. Un elemento `<a>` con `id = "linkCodify"`, `href = "https://codify.dev"` y texto `"Visitar Codify"`.
2. Un elemento `<img>` con `id = "fotoPerfil"` y `src = "https://via.placeholder.com/150"`.
$THEORY$,
    'web',
    $CODE$function agregarMultimedia() {
  // 1. Crea el enlace <a> con id "linkCodify" y href "https://codify.dev":


  // 2. Crea la imagen <img> con id "fotoPerfil" y src "https://via.placeholder.com/150":


  // 3. Inserta ambos en document.body:

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
assert(a !== null, "Debe existir un elemento <a> con id 'linkCodify'.");
assert(a && a.getAttribute("href") === "https://codify.dev", "El atributo href del enlace debe ser 'https://codify.dev'.");
assert(img !== null, "Debe existir un elemento <img> con id 'fotoPerfil'.");
assert(img && img.getAttribute("src") === "https://via.placeholder.com/150", "El atributo src de la imagen debe ser 'https://via.placeholder.com/150'.");$TEST$,
    35,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Listas Desordenadas (ul y li)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 3: Listas Desordenadas (ul y li)',
    'Crea un menú de navegación mediante una lista con elementos li.',
    $THEORY$
### 📋 1. Estructurando Menús y Colecciones
En la web, casi todos los menús de navegación, barras laterales y listas de productos se construyen usando listas HTML:
- **`<ul>` (Unordered List):** La caja contenedora de la lista.
- **`<li>` (List Item):** Cada uno de los ítems individuales dentro de la lista.

---

### 🔄 2. Creando Listas con Bucles
Para no repetir código manualmente, podemos recorrer un arreglo de textos y crear los `<li>` en automático:

```js
const contenedorLista = document.createElement("ul");
const opciones = ["Inicio", "Servicios", "Contacto"];

opciones.forEach(texto => {
  const item = document.createElement("li");
  item.textContent = texto;
  contenedorLista.appendChild(item); // Se inserta dentro del ul
});

document.body.appendChild(contenedorLista);
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `crearMenu()` que:
1. Cree un elemento `<ul>` con `id = "menuNav"`.
2. Cree 3 elementos `<li>` con los textos: `"Inicio"`, `"Proyectos"` y `"Contacto"`.
3. Inserte los 3 `<li>` dentro del `<ul>`.
4. Finalmente, inserte el `<ul>` en `document.body`.
$THEORY$,
    'web',
    $CODE$function crearMenu() {
  // 1. Crea el elemento ul con id "menuNav":
  
  // 2. Crea los 3 li con "Inicio", "Proyectos", "Contacto" y agrégalos al ul:
  
  // 3. Agrega el ul al document.body:
  
}$CODE$,
    $CODE$function crearMenu() {
  const ul = document.createElement("ul");
  ul.id = "menuNav";
  const items = ["Inicio", "Proyectos", "Contacto"];
  items.forEach(texto => {
    const li = document.createElement("li");
    li.textContent = texto;
    ul.appendChild(li);
  });
  document.body.appendChild(ul);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
crearMenu();
const ul = document.getElementById("menuNav");
assert(ul !== null, "Debe existir un elemento <ul> con id 'menuNav'.");
const lis = ul.querySelectorAll("li");
assert(lis.length === 3, "La lista debe contener exactamente 3 elementos <li>.");
assert(lis[0].textContent === "Inicio" && lis[1].textContent === "Proyectos" && lis[2].textContent === "Contacto", "Los textos de los <li> deben ser 'Inicio', 'Proyectos' y 'Contacto'.");$TEST$,
    40,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Estilos CSS (Color, Fondo y Alineación)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 4: Estilos CSS (Color y Fondo)',
    'Aplica estilos visuales básicos a un elemento mediante la propiedad style.',
    $THEORY$
### 🎨 1. Dando Vida Visual: Estilos en JavaScript
**CSS** nos permite cambiar la apariencia de cualquier elemento. Desde JavaScript, podemos alterar los estilos directamente a través de la propiedad `.style`.

Propiedades visuales esenciales:
- `elemento.style.color`: Cambia el color del texto (ej: `"white"`, `"#ff0055"`).
- `elemento.style.backgroundColor`: Cambia el color del fondo.
- `elemento.style.textAlign`: Alinea el texto (`"center"`, `"left"`, `"right"`).

---

### ⚠️ Regla de Oro: camelCase en JavaScript
En archivos CSS puros se escribe con guiones: `background-color` o `text-align`.  
¡Pero en JavaScript los guiones no se permiten! Por eso se escribe en **camelCase**:
- `backgroundColor`
- `textAlign`
- `fontSize`

```js
const tarjeta = document.createElement("div");
tarjeta.style.color = "white";
tarjeta.style.backgroundColor = "#0f172a";
tarjeta.style.textAlign = "center";
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `aplicarEstilosBase(elemento)` que reciba un elemento HTML y le configure:
- `color`: con el valor `"white"`
- `backgroundColor`: con el valor `"#1e1e2e"`
- `textAlign`: con el valor `"center"`
$THEORY$,
    'web',
    $CODE$function aplicarEstilosBase(elemento) {
  // Configura color, backgroundColor y textAlign aquí:
  
}$CODE$,
    $CODE$function aplicarEstilosBase(elemento) {
  elemento.style.color = "white";
  elemento.style.backgroundColor = "#1e1e2e";
  elemento.style.textAlign = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
aplicarEstilosBase(div);
assert(div.style.color === "white", "El estilo color debe ser 'white'.");
assert(div.style.backgroundColor === "rgb(30, 30, 46)" || div.style.backgroundColor === "#1e1e2e", "El backgroundColor debe ser '#1e1e2e'.");
assert(div.style.textAlign === "center", "El textAlign debe ser 'center'.");$TEST$,
    45,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: El Modelo de Caja CSS (Box Model, Padding y Bordes)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 5: El Modelo de Caja CSS (Box Model)',
    'Configura el espacio interno (padding), esquinas redondeadas y cursor de un botón.',
    $THEORY$
### 📦 1. El Modelo de Caja: Anatomía de un Botón
Todo en la web es una **caja rectangular**. 
Imagina una caja de encomienda:
- **Contenido:** El texto del botón.
- **Padding:** El acolchado interno entre el texto y el borde.
- **Border:** El marco exterior de la caja.
- **BorderRadius:** Qué tan redondeadas son las esquinas.

---

### 🔘 2. Estilizando un Botón Moderno
```js
const boton = document.createElement("button");
boton.style.padding = "12px 24px";  // 12px arriba/abajo, 24px izquierda/derecha
boton.style.borderRadius = "8px";   // Esquinas redondeadas
boton.style.border = "none";        // Sin borde tosco por defecto
boton.style.cursor = "pointer";     // Muestra la manito del ratón al pasar por encima
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar las unidades:** Escribir `boton.style.padding = 12;` (sin `"px"` o comillas) será ignorado por el navegador. Siempre debe ser un texto con unidad: `"12px"`.

---

### 🎯 Tu Misión de Hoy:
Crea una función `estilizarBoton(boton)` que aplique sobre el elemento `boton`:
- `padding = "12px 24px"`
- `borderRadius = "8px"`
- `border = "none"`
- `cursor = "pointer"`
$THEORY$,
    'web',
    $CODE$function estilizarBoton(boton) {
  // Aplica los estilos del Box Model aquí:
  
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
assert(btn.style.padding === "12px 24px", "El padding debe ser '12px 24px'.");
assert(btn.style.borderRadius === "8px", "El borderRadius debe ser '8px'.");
assert(btn.style.border === "none" || btn.style.borderStyle === "none" || btn.style.borderWidth === "0px" || btn.style.cssText.includes("border") || btn.style.border.includes("none"), "El border debe ser 'none'.");
assert(btn.style.cursor === "pointer", "El cursor debe ser 'pointer'.");$TEST$,
    50,
    5
  );


  -- ============================================================================
  -- LECCIÓN 6: Layouts Modernos con Flexbox
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 6: Flexbox y Alineación Horizontal',
    'Alinea elementos dentro de un contenedor usando display flex.',
    $THEORY$
### 📐 1. Flexbox: Distribución Perfecta de Espacios
¿Cómo logramos que el logotipo de una web quede a la izquierda y el menú de navegación a la derecha, perfectamente centrados en la misma línea?

La respuesta es **CSS Flexbox**. Al aplicar `display = "flex"` a un contenedor padre, sus hijos se acomodan automáticamente en fila.

---

### 🧭 2. Las 3 Propiedades Clave de Flexbox
1. **`display = "flex"`:** Activa el motor flexible en el contenedor.
2. **`justifyContent = "space-between"`:** Empuja el primer elemento al extremo izquierdo y el último al extremo derecho, dejando el espacio en el medio.
3. **`alignItems = "center"`:** Centra todos los elementos verticalmente para que queden alineados.

```js
const barraNav = document.createElement("nav");
barraNav.style.display = "flex";
barraNav.style.justifyContent = "space-between";
barraNav.style.alignItems = "center";
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `convertirEnFlex(contenedor)` que asigne a `contenedor.style`:
- `display = "flex"`
- `justifyContent = "space-between"`
- `alignItems = "center"`
$THEORY$,
    'web',
    $CODE$function convertirEnFlex(contenedor) {
  // Aplica las 3 reglas de Flexbox aquí:
  
}$CODE$,
    $CODE$function convertirEnFlex(contenedor) {
  contenedor.style.display = "flex";
  contenedor.style.justifyContent = "space-between";
  contenedor.style.alignItems = "center";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const div = document.createElement("div");
convertirEnFlex(div);
assert(div.style.display === "flex", "display debe ser 'flex'.");
assert(div.style.justifyContent === "space-between", "justifyContent debe ser 'space-between'.");
assert(div.style.alignItems === "center", "alignItems debe ser 'center'.");$TEST$,
    60,
    6
  );


  -- ============================================================================
  -- LECCIÓN 7: Selección Dinámica del DOM (getElementById)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 7: Selección Dinámica del DOM',
    'Busca un elemento existente en la página y actualiza su contenido de texto.',
    $THEORY$
### 🔍 1. El Control Remoto del DOM
El **DOM (Document Object Model)** es el árbol de elementos de la página.  
Para cambiar un texto en vivo (como el estado de una conexión o el nombre de un usuario), primero debemos **encontrar el elemento** en la pantalla y luego **modificarlo**.

---

### 🎯 2. Buscar por ID con `document.getElementById`
Cada elemento puede tener un identificador único (`id`). Con `document.getElementById("miId")` obtenemos una referencia directa al elemento:

```js
// Buscar el elemento con id "mensajeBienvenida":
const etiqueta = document.getElementById("mensajeBienvenida");

// Si existe, modificamos su texto:
if (etiqueta) {
  etiqueta.textContent = "¡Bienvenido de vuelta, Alex!";
}
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Poner el símbolo `#`:** Escribir `document.getElementById("#miId")` fallará. La función ya sabe que busca un ID, por lo que se escribe solo `"miId"`.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `actualizarMensaje(nuevoTexto)` que:
1. Busque el elemento con `id = "statusApp"`.
2. Si el elemento existe, actualice su propiedad `textContent` con el valor de `nuevoTexto`.
$THEORY$,
    'web',
    $CODE$function actualizarMensaje(nuevoTexto) {
  // 1. Busca el elemento #statusApp:
  
  // 2. Modifica su textContent:
  
}$CODE$,
    $CODE$function actualizarMensaje(nuevoTexto) {
  const el = document.getElementById("statusApp");
  if (el) {
    el.textContent = nuevoTexto;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = document.createElement("p");
p.id = "statusApp";
document.body.appendChild(p);
actualizarMensaje("Sistema Activo");
assert(p.textContent === "Sistema Activo", "Debe actualizar el textContent de #statusApp con el nuevo texto.");
actualizarMensaje("Conectado");
assert(p.textContent === "Conectado", "Debe permitir actualizar el texto múltiples veces.");
document.body.removeChild(p);$TEST$,
    65,
    7
  );


  -- ============================================================================
  -- LECCIÓN 8: Eventos del Usuario (Click Listener)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 8: Eventos del Usuario (Click Listener)',
    'Escucha el clic de un botón y ejecuta una función de respuesta.',
    $THEORY$
### 👆 1. Interactividad Real: Escuchadores de Eventos
Una página web no es solo para mirar; es para **interactuar**. Cuando el usuario hace clic en un botón, mueve el ratón o presiona una tecla, el navegador genera un **Evento**.

---

### 👂 2. El Método `addEventListener`
Podemos indicarle a cualquier elemento que se quede "escuchando" pacientemente a que ocurra una acción del usuario:

```js
const botonGuardar = document.getElementById("btnGuardar");

botonGuardar.addEventListener("click", function() {
  console.log("¡El usuario hizo clic!");
});
```

- El primer parámetro es el nombre del evento: `"click"`.
- El segundo parámetro es la **función callback** que se ejecutará en respuesta.

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Escribir `"onclick"` en vez de `"click"`:** En `addEventListener` el nombre del evento es solo `"click"`.
- ❌ **Ejecutar la función con paréntesis al pasarla:** Pasar `callback()` en lugar de `callback`.

---

### 🎯 Tu Misión de Hoy:
Crea una función `conectarBoton(boton, callback)` que reciba un elemento `boton` y una función `callback`:
- Debe agregar un escuchador de evento `"click"` sobre el `boton` para que ejecute `callback` al recibir un clic.
$THEORY$,
    'web',
    $CODE$function conectarBoton(boton, callback) {
  // Agrega el addEventListener de "click" aquí:
  
}$CODE$,
    $CODE$function conectarBoton(boton, callback) {
  boton.addEventListener("click", callback);
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const btn = document.createElement("button");
let ejecutado = false;
conectarBoton(btn, () => { ejecutado = true; });
btn.click();
assert(ejecutado === true, "Al hacer clic sobre el botón se debe ejecutar la función callback.");$TEST$,
    75,
    8
  );


  -- ============================================================================
  -- LECCIÓN 9: Lectura de Campos de Texto (Input Value)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 9: Lectura de Campos de Texto (Input Value)',
    'Obtén el texto ingresado por el usuario en un campo input eliminando espacios innecesarios.',
    $THEORY$
### 📝 1. Capturando Datos del Usuario: `<input>`
En formularios de registro, barras de búsqueda o pantallas de login, los usuarios escriben en cajas de texto `<input>`.

A diferencia de un párrafo o encabezado (donde leemos `.textContent`), en los campos de entrada leemos su propiedad **`.value`**.

---

### 🧹 2. Limpieza de Espacios con `.trim()`
A menudo los usuarios escriben espacios accidentales al inicio o al final (ej: `"  Juan  "`). 
Para limpiar esos espacios invisibles usamos el método `.trim()`:

```js
const inputEmail = document.getElementById("correo");
const emailLimpio = inputEmail.value.trim(); // "usuario@gmail.com"
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `obtenerNombreInput(inputElem)` que reciba un elemento de entrada `inputElem`:
- Si `inputElem` existe, debe retornar su propiedad `.value` limpia de espacios usando `.trim()`.
- Si `inputElem` no existe o es nulo, debe retornar un texto vacío `""`.
$THEORY$,
    'web',
    $CODE$function obtenerNombreInput(inputElem) {
  // Obtén el valor del input y aplica .trim():
  
}$CODE$,
    $CODE$function obtenerNombreInput(inputElem) {
  return inputElem ? inputElem.value.trim() : "";
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const inp = document.createElement("input");
inp.value = "  Codify  ";
assert(obtenerNombreInput(inp) === "Codify", "Debe devolver el valor del input sin los espacios en los extremos ('Codify').");
const inp2 = document.createElement("input");
inp2.value = "Heroe";
assert(obtenerNombreInput(inp2) === "Heroe", "Debe devolver 'Heroe'.");$TEST$,
    85,
    9
  );


  -- ============================================================================
  -- LECCIÓN 10: Proyecto Integrador Web (Tarjeta con Contador de Likes)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    web_module_id,
    'Lección 10: Proyecto Integrador - Tarjeta Interactiva de Perfil',
    'Combina HTML, manipulación del DOM y Event Listeners para crear un contador de Likes en vivo.',
    $THEORY$
### 🏆 1. El Gran Proyecto Integrador Web
¡Felicitaciones por llegar al reto final del Módulo de Prototipado Web! 🎉

Aquí vas a construir el corazón interactivo de cualquier red social moderna: el **botón de Likes en vivo**.

---

### 🧠 2. Cómo Funciona la Lógica de Estado en la Web:
1. **Estado en Memoria:** Guardas una variable `let likes = 0;` afuera de la función de clic.
2. **Escucha de Evento:** Conectas un `addEventListener("click", ...)` al botón.
3. **Actualización:** En cada clic:
   - Incrementas la variable: `likes++`.
   - Actualizas el texto en la pantalla: `spanContador.textContent = likes;`.

```js
function inicializarContador(btn, display) {
  let contador = 0;
  btn.addEventListener("click", () => {
    contador++;
    display.textContent = contador;
  });
}
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `registrarSistemaLikes(botonLike, spanContador)` que:
1. Inicialice una variable local `likes = 0;`.
2. Agregue un escuchador de evento `"click"` sobre `botonLike`.
3. Cada vez que se haga clic en `botonLike`, incremente `likes++` y actualice `spanContador.textContent = likes;`.
$THEORY$,
    'web',
    $CODE$function registrarSistemaLikes(botonLike, spanContador) {
  let likes = 0;
  // Agrega el evento click sobre botonLike para incrementar y actualizar:
  
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
assert(span.textContent === "0", "El contador inicial debe ser 0.");
btn.click();
assert(span.textContent === "1", "Luego del primer clic, el texto debe ser '1'.");
btn.click();
assert(span.textContent === "2", "Luego del segundo clic, el texto debe ser '2'.");
btn.click();
assert(span.textContent === "3", "Luego del tercer clic, el texto debe ser '3'.");$TEST$,
    120,
    10
  );

END $$;
