-- ==============================================================================
-- ⚡ MÓDULO 4 COMPLETO: ASINCRONISMO Y CONSUMO DE APIS (FETCH & ASYNC/AWAIT)
-- ==============================================================================
-- Usamos Dollar Quoting ($THEORY$, $CODE$, $TEST$) para garantizar sintaxis SQL limpia.

DO $$
DECLARE
  async_module_id UUID;
BEGIN

  -- 1. Crear el Módulo 4
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 4: Asincronismo y Consumo de APIs (Fetch & Async/Await)',
    'Domina la programación asincrónica en JavaScript: Promesas, consumo de APIs REST con fetch(), async/await y manejo de errores con try/catch.',
    3
  )
  RETURNING id INTO async_module_id;

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 1: ¿Qué es una Promesa? (resolve y reject)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    async_module_id,
    'Lección 1: Creación de Promesas (Promise)',
    'Crea una promesa básica que se resuelva con un mensaje exitoso.',
    $THEORY$
### ⏳ Programación Asincrónica
En el desarrollo web moderno, tareas como pedir datos a un servidor o leer un archivo toman tiempo. Para no congelar la página, usamos **Promesas**.

Una `Promise` representa un valor que estará disponible ahora, en el futuro o nunca.

### 📝 Ejemplo de Código:
```js
const miPromesa = new Promise((resolve, reject) => {
  const exito = true;
  if (exito) {
    resolve("¡Operación Exitosa!");
  } else {
    reject("Ocurrió un error");
  }
});
```

### 🎯 Tu Misión:
Crea una función `solicitarDatos()` que devuelva una `Promise` que llame a `resolve("Datos Recibidos")`.
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

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 2: Consumiendo Promesas con .then()
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    async_module_id,
    'Lección 2: Consumo de Promesas con .then()',
    'Usa el método .then() para transformar la respuesta de una promesa.',
    $THEORY$
### 🔗 Encadenamiento con `.then()`
Para obtener el valor contenido dentro de una promesa resuelta, usamos el método `.then(resultado => ...)` pasándole una función callback.

### 📝 Ejemplo de Código:
```js
obtenerUsuario()
  .then(usuario => {
    console.log(usuario.nombre);
  });
```

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

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 3: Peticiones HTTP con fetch()
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    async_module_id,
    'Lección 3: Peticiones HTTP con fetch() y JSON',
    'Simula la conversión de una respuesta HTTP a objeto JSON.',
    $THEORY$
### 🌐 La API `fetch()`
`fetch(url)` es la herramienta nativa del navegador para enviar y recibir datos de un servidor externo (API REST).

La respuesta de `fetch` devuelve una promesa que debemos convertir a formato JSON con `.json()`.

### 📝 Ejemplo de Código:
```js
fetch("https://api.ejemplo.com/datos")
  .then(response => response.json())
  .then(data => {
    console.log(data);
  });
```

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
assert(res instanceof Promise, "Debe devolver la promesa del metodo .json()");
res.then(data => {
  assert(data.ok === true, "Debe retornar el objeto JSON parseado");
});$TEST$,
    60,
    3
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 4: Sintaxis Moderna con async / await
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    async_module_id,
    'Lección 4: Sintaxis Moderna con async / await',
    'Simplifica el código asincrónico escribiendo funciones marcadas con async y usando await.',
    $THEORY$
### ✨ `async` y `await`: Código Asincrónico Limpio
La sintaxis `async / await` permite escribir código asincrónico que se lee y comporta como código síncrono tradicional.

- Colocamos la palabra `async` antes de definir la función.
- Usamos `await` antes de una promesa para pausar la ejecución hasta que la promesa se resuelva.

### 📝 Ejemplo de Código:
```js
async function cargarPerfil() {
  const usuario = await obtenerUsuario();
  console.log(usuario.nombre);
}
```

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
assert(res instanceof Promise, "Una función async siempre devuelve una promesa");
res.then(val => {
  assert(val === 150, "100 + 50 debe ser 150");
});$TEST$,
    75,
    4
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 5: RETO FINAL INTEGRADOR - MANEJO DE ERRORES CON TRY / CATCH
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    async_module_id,
    'Lección 5: Proyecto Integrador - Cliente de API Robusto (try / catch)',
    'Construye un conector de API con manejo de errores elegante.',
    $THEORY$
### 🛡️ Robustez con `try / catch`
En el mundo real, los servidores fallan o la conexión a internet puede caerse. Cuando usas `async / await`, envuelves tus peticiones dentro de un bloque `try { ... } catch (error) { ... }` para capturar cualquier fallo de red de forma segura.

### 📝 Ejemplo de Código:
```js
async function conectar() {
  try {
    const respuesta = await fetch("https://api.servidor.com");
    return "Conectado";
  } catch (error) {
    return "Error de Red";
  }
}
```

### 🎯 Tu Misión:
Crea la función `async consultarEstadoServidor(peticionFn)` donde `peticionFn` es una función asincrónica:
1. Dentro de un bloque `try`, ejecuta `await peticionFn()` y retorna `"Servidor Online"`.
2. Dentro del bloque `catch(err)`, retorna `"Error de Conexión"`.
$THEORY$,
    'logic',
    $CODE$async function consultarEstadoServidor(peticionFn) {
  // Usa try y catch aquí:
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
  assert(r1 === "Servidor Online", "En éxito debe retornar 'Servidor Online'");
});

consultarEstadoServidor(fnFallo).then(r2 => {
  assert(r2 === "Error de Conexión", "En fallo debe retornar 'Error de Conexión'");
});$TEST$,
    100,
    5
  );

END $$;
