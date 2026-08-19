-- ==============================================================================
-- ⚡ CODIFY SEED: MÓDULO 4 - ASINCRONISMO Y CONSUMO DE APIS (5 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 4 sin borrar ni alterar los demás módulos.
-- ==============================================================================

DO $$
DECLARE
  async_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo
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
    'Domina la programación asincrónica en JavaScript: Promesas, consumo de APIs REST con fetch(), async/await y manejo de errores con try/catch.',
    3
  )
  RETURNING id INTO async_module_id;

  -- Lección 1: Creación de Promesas
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 1: Creación de Promesas (Promise)',
    'Crea una promesa básica que se resuelva con un mensaje exitoso.',
    $THEORY$
### ⏳ Programación Asincrónica
En el desarrollo web moderno, tareas como pedir datos a un servidor toman tiempo. Usamos **Promesas** para manejar estos procesos.

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

  -- Lección 2: Consumo de Promesas con .then()
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
    'Lección 2: Consumo de Promesas con .then()',
    'Usa el método .then() para transformar la respuesta de una promesa.',
    $THEORY$
### 🔗 Encadenamiento con `.then()`
Para obtener el valor contenido dentro de una promesa resuelta, usamos el método `.then(resultado => ...)`.

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

  -- Lección 3: Peticiones HTTP con fetch()
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
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

  -- Lección 4: async / await
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
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

  -- Lección 5: try / catch
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    async_module_id,
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
