-- ==============================================================================
-- ⚡ CODIFY SEED: MÓDULO 4 - ASINCRONISMO Y CONSUMO DE APIS (5 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 4 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  async_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)'
  );
  DELETE FROM public.modules WHERE title = 'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)';

  -- 2. Creación del Módulo 4
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)',
    'Domina la programación asincrónica en JavaScript: Promesas, encadenamiento .then(), consumo de APIs REST con fetch(), async/await moderno y manejo robusto de errores con try/catch.',
    3
  )
  RETURNING id INTO async_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Creación de Promesas (Promise, resolve y reject)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 1: Creación de Promesas (Promise)',
    'Crea una promesa básica que se resuelva con un mensaje exitoso.',
    $THEORY$
### ⏳ 1. ¿Por qué necesitamos Código Asincrónico?
En programación síncrona tradicional, cada línea de código se ejecuta una tras otra de inmediato.  
Pero en la web real, operaciones como **pedir datos a un servidor en Japón**, **leer un archivo pesado** o **esperar la respuesta de una IA** toman tiempo (milisegundos o segundos).

Si JavaScript se quedara "congelado" esperando esa respuesta, la pantalla del usuario no respondería.  
Por eso usamos la **Programación Asincrónica**.

---

### 🍔 2. La Analogía del Ticket de Restaurante
Imagina que vas a pedir una hamburguesa:
1. Pagas en la caja. No te dan la hamburguesa en ese milisegundo.
2. Te entregan un **ticket con número o un buscapersonas (buzzer)**.
3. Ese ticket es una **Promesa (`Promise`)**: garantiza que en el futuro tu pedido estará listo (`resolve`) o que te avisarán si hubo un problema con la cocina (`reject`).
4. Mientras tanto, puedes ir a sentarte y revisar tu celular sin quedarte inmóvil.

---

### 📜 3. Creando una Promesa en JavaScript
Una `Promise` se crea con `new Promise((resolve, reject) => { ... })`:

```js
const pedirComida = new Promise((resolve, reject) => {
  const comidaLista = true;
  if (comidaLista) {
    resolve("🍔 Hamburguesa entregada con éxito");
  } else {
    reject("❌ Se agotaron los ingredientes");
  }
});
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `solicitarDatos()` que devuelva una nueva `Promise`:
- Dentro de la promesa, llama a la función `resolve` pasándole el texto `"Datos Recibidos"`.
$THEORY$,
    'logic',
    $CODE$function solicitarDatos() {
  // Retorna una new Promise que ejecute resolve("Datos Recibidos"):
  
}$CODE$,
    $CODE$function solicitarDatos() {
  return new Promise((resolve) => {
    resolve("Datos Recibidos");
  });
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const res = solicitarDatos();
assert(res instanceof Promise, "solicitarDatos() debe retornar una instancia de Promise.");
res.then(val => {
  assert(val === "Datos Recibidos", "La promesa debe resolverse con el texto 'Datos Recibidos'.");
});$TEST$,
    40,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Consumo y Transformación con .then()
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 2: Consumo de Promesas con .then()',
    'Usa el método .then() para transformar la respuesta de una promesa.',
    $THEORY$
### 🔗 1. Desempaquetando Promesas: El Método `.then()`
Cuando tienes una promesa en tus manos, el valor **aún no está listo**.  
Para decirle a JavaScript: *"Oye, en cuanto la promesa se resuelva, haz esto con el resultado"*, usamos el método **`.then()`**.

---

### 📦 2. Encadenamiento y Transformación de Datos
Imagina una **cadena de montaje postal**:
1. Llega el paquete crudo.
2. En el primer `.then()`, abres el paquete y transformas su contenido.
3. El valor que retornas dentro del `.then()` se convierte automáticamente en una nueva promesa lista para el siguiente paso.

```js
function obtenerNombreUsuario() {
  return Promise.resolve("carlos");
}

// Consumir y transformar:
obtenerNombreUsuario()
  .then(nombre => {
    return nombre.toUpperCase(); // Devuelve "CARLOS"
  })
  .then(nombreEnMayusculas => {
    console.log("Usuario procesado:", nombreEnMayusculas);
  });
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar el `return` dentro del `.then()`:** Si no retornas el valor transformado, el siguiente paso de la cadena recibirá `undefined`.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `procesarRespuesta(promesa)` que reciba una `promesa`:
- Debe consumir esa `promesa` usando `.then(...)`.
- Dentro del `.then`, debe transformar el resultado recibido convirtiéndolo a mayúsculas con `.toUpperCase()` y retornarlo.
$THEORY$,
    'logic',
    $CODE$function procesarRespuesta(promesa) {
  // Consume la promesa con .then() y retorna el texto en .toUpperCase():
  
}$CODE$,
    $CODE$function procesarRespuesta(promesa) {
  return promesa.then(res => res.toUpperCase());
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = Promise.resolve("codify");
const res = procesarRespuesta(p);
assert(res instanceof Promise, "procesarRespuesta debe retornar una promesa.");
res.then(val => {
  assert(val === "CODIFY", "La respuesta de la promesa procesada debe ser 'CODIFY' en mayúsculas.");
});$TEST$,
    50,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Peticiones HTTP a Servidores con fetch() y .json()
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 3: Peticiones HTTP con fetch() y JSON',
    'Simula la conversión de una respuesta de servidor a un objeto JSON usable.',
    $THEORY$
### 🌐 1. La Herramienta Universal: `fetch()`
¿Cómo se comunica una aplicación web con el mundo exterior (servidores de clima, bases de datos o pasarelas de pago)?

Usamos la función nativa **`fetch(url)`**, que envía una petición HTTP a través de internet y nos devuelve una promesa con la respuesta del servidor.

---

### 📦 2. El Proceso en Dos Pasos de `fetch`
Cuando un servidor responde, no envía inmediatamente un objeto de JavaScript; envía un paquete con cabeceras de red y un cuerpo de texto sin procesar.

Por eso, leer datos de una API siempre requiere **dos pasos**:
1. **`fetch(url)`**: Esperar la conexión con el servidor.
2. **`.json()`**: Convertir el texto crudo recibido en un objeto o arreglo de JavaScript.

```js
fetch("https://api.github.com/users/octocat")
  .then(respuesta => {
    return respuesta.json(); // Paso crucial: convierte a JSON
  })
  .then(datosUsuario => {
    console.log(datosUsuario.login); // Ahora sí tenemos el objeto con sus datos
  });
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `parsearRespuestaServidor(respuestaMock)`:
- El parámetro `respuestaMock` simula una respuesta de servidor y contiene el método `.json()`.
- Tu función debe ejecutar y retornar `respuestaMock.json()`.
$THEORY$,
    'logic',
    $CODE$function parsearRespuestaServidor(respuestaMock) {
  // Llama y retorna el método .json() del objeto respuestaMock:
  
}$CODE$,
    $CODE$function parsearRespuestaServidor(respuestaMock) {
  return respuestaMock.json();
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const mock = { json: () => Promise.resolve({ ok: true, status: 200 }) };
const res = parsearRespuestaServidor(mock);
assert(res instanceof Promise, "parsearRespuestaServidor debe retornar la promesa devuelta por .json().");
res.then(data => {
  assert(data.ok === true && data.status === 200, "Debe resolver con el objeto JSON { ok: true, status: 200 }.");
});$TEST$,
    60,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Sintaxis Moderna con async y await
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 4: Sintaxis Moderna con async / await',
    'Simplifica el código asincrónico escribiendo funciones marcadas con async y pausando la ejecución con await.',
    $THEORY$
### ✨ 1. La Revolución de `async` y `await`
Encadenar múltiples `.then()` puede volverse confuso cuando tienes 4 o 5 llamadas a servidores seguidas.

Para solucionar esto, JavaScript introdujo una sintaxis elegante que te permite escribir código asincrónico **como si fuera código secuencial tradicional**:

1. **`async`**: Se coloca antes de `function` para indicar que la función trabaja con procesos asincrónicos.
2. **`await`**: Se coloca antes de una promesa para pausar la ejecución en esa línea hasta que el valor esté disponible.

---

### 📝 2. Comparación: .then() vs async/await
```js
// Modo antiguo con .then():
function cargarPuntosViejo() {
  return pedirPuntos().then(puntos => {
    return puntos + 10;
  });
}

// Modo moderno con async/await (mucho más limpio):
async function cargarPuntosNuevo() {
  const puntos = await pedirPuntos(); // Espera el resultado limpiamente
  return puntos + 10;
}
```

---

### ⚠️ Reglas Importantes
- ❌ **`await` solo vive dentro de `async`:** No puedes usar la palabra `await` dentro de una función regular que no tenga la palabra `async` al inicio.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `async function obtenerPuntajeFinal(promesaPuntos)`:
1. Debe pausar la ejecución y esperar el valor numérico de `promesaPuntos` usando `await`.
2. Debe retornar ese valor numérico sumándole `50`.
$THEORY$,
    'logic',
    $CODE$async function obtenerPuntajeFinal(promesaPuntos) {
  // 1. Espera el valor de promesaPuntos con await:
  
  // 2. Retorna el valor sumándole 50:
  
}$CODE$,
    $CODE$async function obtenerPuntajeFinal(promesaPuntos) {
  const puntos = await promesaPuntos;
  return puntos + 50;
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p1 = Promise.resolve(100);
const res1 = obtenerPuntajeFinal(p1);
assert(res1 instanceof Promise, "Una función marcada con async siempre retorna una promesa.");
res1.then(val => {
  assert(val === 150, "Para un puntaje de 100, debe retornar 150 (100 + 50).");
});
const p2 = Promise.resolve(0);
obtenerPuntajeFinal(p2).then(val => {
  assert(val === 50, "Para un puntaje de 0, debe retornar 50.");
});$TEST$,
    75,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Cliente de API Robusto y Manejo de Errores (try / catch)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 5: Proyecto Integrador - Cliente de API Robusto (try / catch)',
    'Construye un conector de API profesional capaz de capturar caídas de red de forma segura.',
    $THEORY$
### 🛡️ 1. El Cinturón de Seguridad del Backend: `try / catch`
En el mundo real, internet no es 100% confiable:
- El servidor del cliente puede estar caído (error 500).
- El usuario puede perder conexión Wi-Fi en un túnel.
- Una URL puede no existir (error 404).

Si no proteges tus peticiones asincrónicas, un solo error de conexión **romperá toda la aplicación web** del usuario.

---

### 🧯 2. Cómo Funciona el Bloque `try / catch`
- **Bloque `try`:** *"Intenta ejecutar este código que podría fallar..."*
- **Bloque `catch`:** *"Si algo sale mal, no explotes; atrapa el error y ofrece una respuesta alternativa segura."*

```js
async function consultarClima() {
  try {
    const respuesta = await fetch("https://api.clima.com/actual");
    const datos = await respuesta.json();
    return datos.temperatura;
  } catch (error) {
    console.error("No pudimos conectar con el satélite:", error.message);
    return "Servicio temporalmente no disponible";
  }
}
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `async function consultarEstadoServidor(peticionFn)` donde `peticionFn` es una función asincrónica:
1. Dentro de un bloque `try`, ejecuta `await peticionFn()` y retorna el texto `"Servidor Online"`.
2. Dentro del bloque `catch (error)`, captura el fallo y retorna el texto `"Error de Conexión"`.
$THEORY$,
    'logic',
    $CODE$async function consultarEstadoServidor(peticionFn) {
  // Envuelve la ejecución de await peticionFn() dentro de un try / catch:
  
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
const fnFallo = async () => { throw new Error("Connection Refused 500"); };

consultarEstadoServidor(fnExito).then(r1 => {
  assert(r1 === "Servidor Online", "Cuando la petición tiene éxito, debe retornar 'Servidor Online'.");
});

consultarEstadoServidor(fnFallo).then(r2 => {
  assert(r2 === "Error de Conexión", "Cuando la petición lanza un error, debe atraparlo en el catch y retornar 'Error de Conexión'.");
});$TEST$,
    100,
    5
  );

END $$;
