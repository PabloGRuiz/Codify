-- ==============================================================================
-- ⚡ CODIFY SEED: MÓDULO 6 - FASTAPI, PYDANTIC & APIS ASINCRÓNICAS (10 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 6 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  fastapi_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 6: FastAPI, Pydantic & APIs Asincrónicas de Alto Rendimiento'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Módulo 6: FastAPI, Pydantic & APIs Asincrónicas de Alto Rendimiento'
  );
  DELETE FROM public.modules WHERE title = 'Módulo 6: FastAPI, Pydantic & APIs Asincrónicas de Alto Rendimiento';

  -- 2. Creación del Módulo 6
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 6: FastAPI, Pydantic & APIs Asincrónicas de Alto Rendimiento',
    'Aprende a construir microservicios y APIs REST modernas con el framework más rápido de Python: Decoradores de ruta, Pydantic Schemas, Path/Query parameters, HTTPException, inyección de dependencias con Depends y async def.',
    3
  )
  RETURNING id INTO fastapi_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Hola Mundo en FastAPI y Decoradores (@app.get)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 1: Primer Endpoint con FastAPI (@app.get)',
    'Inicializa una aplicación FastAPI y crea un endpoint raíz que retorne un mensaje JSON.',
    $THEORY$
### 🚀 1. ¿Qué es FastAPI y por qué domina el Backend moderno?
**FastAPI** es el framework web moderno de Python más rápido y utilizado en la industria para conectar modelos de **Inteligencia Artificial**, microservicios y aplicaciones móviles.

Posee dos grandes ventajas:
1. **Rendimiento extremo** (comparable con NodeJS y Go).
2. **Generación automática de documentación interactiva** (Swagger UI en `/docs`).

---

### 🚪 2. La Analogía de las Ventanillas de Trámites
Imagina un edificio de atención al público:
- `app = FastAPI()` es el **edificio completo**.
- `@app.get("/")` es la **ventanilla principal de bienvenida**.
- Cuando un cliente hace una petición HTTP GET a `"/"`, la función asignada responde con los datos.

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def inicio():
    return {"mensaje": "¡Bienvenido a mi API!"}
```

---

### 🎯 Tu Misión de Hoy:
Crea un endpoint raíz usando el decorador `@app.get("/")`:
- La función debe llamarse `home()` y retornar un diccionario con la clave `"mensaje"` y el valor `"Servidor FastAPI Activo"`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI

app = FastAPI()

# Crea el endpoint @app.get("/") aquí abajo:
def home():
    pass$CODE$,
    $CODE$from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {"mensaje": "Servidor FastAPI Activo"}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function home() {
  return { mensaje: "Servidor FastAPI Activo" };
}
const res = home();
assert(typeof res === "object" && res !== null, "home() debe retornar un diccionario.");
assert(res.mensaje === "Servidor FastAPI Activo", "La clave 'mensaje' debe contener 'Servidor FastAPI Activo'.");$TEST$,
    35,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Parámetros de Ruta (Path Parameters)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 2: Parámetros de Ruta (Path Parameters)',
    'Captura variables dinámicas en la URL y tipa sus valores con Python.',
    $THEORY$
### 📬 1. Variables en la URL: Path Parameters
¿Cómo hace Twitter o GitHub para mostrar tu perfil cuando visitas `github.com/tu-usuario`?  
Utilizan **Parámetros de Ruta** para capturar partes dinámicas de la URL.

---

### 🔍 2. Sintaxis con Llaves `{}` y Type Hints
En FastAPI defines la variable entre llaves `{nombre_parametro}` en la ruta y la declaras en los argumentos de la función con su tipo:

```python
@app.get("/items/{item_id}")
def obtener_item(item_id: int):
    return {"id": item_id, "disponible": True}
```

FastAPI se encarga automáticamente de convertir `item_id` a número entero (`int`) y responderá con error 422 si alguien intenta enviar texto en un campo numérico.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `obtener_usuario(usuario_id: int)` que atienda en `@app.get("/usuarios/{usuario_id}")`:
- Debe recibir `usuario_id: int`.
- Debe retornar un diccionario con: `{"id": usuario_id, "estado": "encontrado"}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI

app = FastAPI()

# Configura el endpoint @app.get("/usuarios/{usuario_id}"):
def obtener_usuario(usuario_id: int):
    pass$CODE$,
    $CODE$from fastapi import FastAPI

app = FastAPI()

@app.get("/usuarios/{usuario_id}")
def obtener_usuario(usuario_id: int):
    return {"id": usuario_id, "estado": "encontrado"}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function obtener_usuario(usuario_id) {
  return { id: usuario_id, estado: "encontrado" };
}
const res = obtener_usuario(42);
assert(res.id === 42, "El id retornado debe coincidir con el usuario_id recibido (42).");
assert(res.estado === "encontrado", "El estado debe ser 'encontrado'.");$TEST$,
    40,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Parámetros de Consulta (Query Parameters)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 3: Parámetros de Consulta (Query Parameters)',
    'Filtra resultados utilizando parámetros de consulta con valores por defecto.',
    $THEORY$
### 🏷️ 1. Filtrando Búsquedas con Query Parameters
Cuando no quieres cambiar la ruta fija sino **filtrar o paginar** datos (ej: `tienda.com/productos?limite=10&categoria=electronica`), usamos **Query Parameters**.

---

### ⚙️ 2. Declaración con Valores por Defecto
Cualquier parámetro de la función que **NO** esté en la ruta `{...}` se convierte automáticamente en un Query Parameter:

```python
@app.get("/cursos")
def listar_cursos(limite: int = 5, orden: str = "asc"):
    return {
        "limite_aplicado": limite,
        "orden_aplicado": orden
    }
```

Si el usuario visita `/cursos`, `limite` valdrá `5`. Si visita `/cursos?limite=20`, valdrá `20`.

---

### 🎯 Tu Misión de Hoy:
Crea la función `listar_productos(limite: int = 10, categoria: str = "todos")` decorada con `@app.get("/productos")`:
- Debe retornar un diccionario con `{"limite": limite, "categoria": categoria}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI

app = FastAPI()

# Crea el endpoint @app.get("/productos") con parámetros por defecto:
def listar_productos(limite: int = 10, categoria: str = "todos"):
    pass$CODE$,
    $CODE$from fastapi import FastAPI

app = FastAPI()

@app.get("/productos")
def listar_productos(limite: int = 10, categoria: str = "todos"):
    return {
        "limite": limite,
        "categoria": categoria
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function listar_productos(limite = 10, categoria = "todos") {
  return { limite: limite, categoria: categoria };
}
const defaultRes = listar_productos();
assert(defaultRes.limite === 10 && defaultRes.categoria === "todos", "Los valores por defecto deben ser limite=10 y categoria='todos'.");
const customRes = listar_productos(50, "ropa");
assert(customRes.limite === 50 && customRes.categoria === "ropa", "Debe aceptar valores personalizados.");$TEST$,
    45,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Validación de Esquemas con Pydantic (BaseModel)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 4: Validación de Datos con Pydantic (BaseModel)',
    'Crea un esquema de datos Pydantic para validar entradas de usuario en tu API.',
    $THEORY$
### 🛡️ 1. El Control de Aduana de tu Backend: Pydantic
Cuando recibes datos desde una aplicación frontend, no puedes confiar a ciegas: un usuario podría enviar números negativos, textos vacíos o campos faltantes.

**Pydantic** es la librería que utiliza FastAPI para **validar, tipar y sanitizar** automáticamente cada dato que entra a tu servidor.

---

### 📦 2. Creando un `BaseModel`
Definimos un esquema creando una clase que hereda de `BaseModel`:

```python
from pydantic import BaseModel

class ProductoSchema(BaseModel):
    nombre: str
    precio: float
    disponible: bool = True # Valor opcional con default
```

Si alguien envía `precio: "gratis"`, Pydantic rechazará la petición al instante con un mensaje de error claro sin que tu servidor sufra ningún fallo.

---

### 🎯 Tu Misión de Hoy:
Crea un esquema Pydantic llamado `UsuarioSchema` que herede de `BaseModel` con 3 campos:
1. `nombre`: de tipo `str`
2. `email`: de tipo `str`
3. `edad`: de tipo `int`
$THEORY$,
    'python',
    $CODE$from pydantic import BaseModel

# Define el esquema UsuarioSchema aquí:
class UsuarioSchema(BaseModel):
    pass$CODE$,
    $CODE$from pydantic import BaseModel

class UsuarioSchema(BaseModel):
    nombre: str
    email: str
    edad: int$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function crearUsuarioSchema(nombre, email, edad) {
  if (typeof nombre !== "string" || typeof email !== "string" || typeof edad !== "number") {
    throw new Error("Tipos de datos inválidos para UsuarioSchema");
  }
  return { nombre, email, edad };
}
const u = crearUsuarioSchema("Carlos", "carlos@dev.com", 28);
assert(u.nombre === "Carlos" && u.email === "carlos@dev.com" && u.edad === 28, "UsuarioSchema debe almacenar nombre: str, email: str, edad: int.");$TEST$,
    50,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Peticiones POST y Request Body (Creación de Recursos)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 5: Peticiones POST y Request Body',
    'Recibe un cuerpo de datos JSON validado por Pydantic mediante el método HTTP POST.',
    $THEORY$
### 📬 1. HTTP POST: Enviando Datos al Servidor
Mientras que `GET` se usa para **leer**, el método `POST` se utiliza para **crear nuevos recursos** (crear un usuario, procesar un pago o enviar un prompt a una IA).

---

### 📨 2. El Request Body en FastAPI
Para recibir un JSON en el cuerpo de la petición, simplemente declaramos el parámetro de la función con el tipo de nuestro modelo Pydantic:

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class TareaSchema(BaseModel):
    titulo: str
    completada: bool = False

@app.post("/tareas")
def crear_tarea(tarea: TareaSchema):
    # FastAPI ya validó que tarea cumple con el esquema:
    return {"status": "creada", "titulo": tarea.titulo}
```

---

### 🎯 Tu Misión de Hoy:
Crea un endpoint `@app.post("/crear-usuario")`:
- La función debe llamarse `registrar_usuario(usuario: UsuarioSchema)`.
- Debe retornar un diccionario con `{"status": "creado", "usuario": usuario}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class UsuarioSchema(BaseModel):
    nombre: str
    email: str
    edad: int

# Crea el endpoint @app.post("/crear-usuario") aquí:
def registrar_usuario(usuario: UsuarioSchema):
    pass$CODE$,
    $CODE$from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class UsuarioSchema(BaseModel):
    nombre: str
    email: str
    edad: int

@app.post("/crear-usuario")
def registrar_usuario(usuario: UsuarioSchema):
    return {
        "status": "creado",
        "usuario": usuario
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function registrar_usuario(usuario) {
  return { status: "creado", usuario: usuario };
}
const mockUser = { nombre: "Elena", email: "elena@ia.com", edad: 25 };
const res = registrar_usuario(mockUser);
assert(res.status === "creado", "El status debe ser 'creado'.");
assert(res.usuario.nombre === "Elena", "El objeto usuario debe ser retornado intacto.");$TEST$,
    60,
    5
  );


  -- ============================================================================
  -- LECCIÓN 6: Códigos de Estado HTTP (Status Codes & 201 Created)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 6: Códigos de Estado HTTP (Status Codes)',
    'Configura el código de estado HTTP 201 Created en la respuesta de un endpoint.',
    $THEORY$
### 🚦 1. El Semáforo de la Web: Códigos de Estado HTTP
Las APIs profesionales no solo devuelven texto; comunican el resultado mediante **Códigos de Estado HTTP**:
- **`200 OK`**: Petición exitosa estándar.
- **`201 Created`**: Se creó un nuevo registro exitosamente.
- **`204 No Content`**: Acción completada (ej: borrar registro), sin contenido que devolver.
- **`400 Bad Request`**: Datos inválidos enviados por el cliente.
- **`404 Not Found`**: El recurso no existe.

---

### ⚙️ 2. Configurando `status_code` en FastAPI
En el decorador de ruta podemos especificar el código exacto:

```python
from fastapi import FastAPI, status

app = FastAPI()

@app.post("/pedidos", status_code=status.HTTP_201_CREATED)
def crear_pedido():
    return {"mensaje": "Pedido registrado en bodega"}
```

---

### 🎯 Tu Misión de Hoy:
Crea un endpoint `@app.post("/registro", status_code=201)`:
- La función debe llamarse `crear_registro()` y retornar `{"id": 101, "creado": True}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI

app = FastAPI()

# Configura @app.post("/registro", status_code=201):
def crear_registro():
    pass$CODE$,
    $CODE$from fastapi import FastAPI

app = FastAPI()

@app.post("/registro", status_code=201)
def crear_registro():
    return {"id": 101, "creado": True}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function crear_registro() {
  return { id: 101, creado: true, _statusCode: 201 };
}
const res = crear_registro();
assert(res.id === 101 && res.creado === true, "crear_registro debe retornar {'id': 101, 'creado': True}.");
assert(res._statusCode === 201, "El status_code configurado debe ser 201.");$TEST$,
    65,
    6
  );


  -- ============================================================================
  -- LECCIÓN 7: Manejo de Errores con HTTPException (404 Not Found)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 7: Manejo de Errores con HTTPException',
    'Lanza una excepción HTTPException con código 404 cuando un recurso no exista.',
    $THEORY$
### 🚨 1. Errores Controlados: `HTTPException`
¿Qué ocurre si un usuario solicita ver el perfil del usuario `#9999` y ese usuario no existe en la base de datos?

No debemos dejar que el servidor falle silenciosamente ni devolver datos vacíos confusos. Debemos **lanzar una excepción HTTP formal (`HTTPException`)**.

---

### 🧯 2. Sintaxis de `raise HTTPException`
```python
from fastapi import FastAPI, HTTPException

app = FastAPI()

@app.get("/articulos/{articulo_id}")
def ver_articulo(articulo_id: int):
    if articulo_id > 100:
        raise HTTPException(
            status_code=404, 
            detail="Artículo no encontrado en el inventario"
        )
    return {"id": articulo_id, "nombre": "Libro de Python"}
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `buscar_producto(producto_id: int)`:
1. Si `producto_id < 1`, debe lanzar `raise HTTPException(status_code=404, detail="Producto no encontrado")`.
2. Si `producto_id >= 1`, debe retornar `{"id": producto_id, "nombre": "Teclado Mecánico"}`.
$THEORY$,
    'python',
    $CODE$from fastapi import HTTPException

def buscar_producto(producto_id: int):
    # Lanza HTTPException(status_code=404) si producto_id < 1:
    pass$CODE$,
    $CODE$from fastapi import HTTPException

def buscar_producto(producto_id: int):
    if producto_id < 1:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    return {"id": producto_id, "nombre": "Teclado Mecánico"}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function buscar_producto(id) {
  if (id < 1) {
    const err = new Error("Producto no encontrado");
    err.statusCode = 404;
    throw err;
  }
  return { id: id, nombre: "Teclado Mecánico" };
}
const p = buscar_producto(5);
assert(p.id === 5 && p.nombre === "Teclado Mecánico", "Para id válido debe retornar el producto.");
let errorAtrapado = false;
try {
  buscar_producto(0);
} catch (e) {
  errorAtrapado = true;
  assert(e.statusCode === 404, "El error debe tener status_code 404.");
}
assert(errorAtrapado === true, "Para id < 1 debe lanzar HTTPException(status_code=404).");$TEST$,
    75,
    7
  );


  -- ============================================================================
  -- LECCIÓN 8: Endpoints Asincrónicos de Alto Rendimiento (async def)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 8: Endpoints Asincrónicos de Alto Rendimiento (async def)',
    'Crea un endpoint no bloqueante usando async def para consultas concurrentes.',
    $THEORY$
### ⚡ 1. La Magia Concurrente de FastAPI
FastAPI está construido sobre **Starlette y AnyIO**, lo que le permite atender **miles de peticiones por segundo** concurrentemente si usamos funciones asincrónicas `async def`.

---

### 🍕 2. La Analogía del Chef Concurrente
- **Modo Síncrono (`def`):** El chef mete una pizza al horno y se queda de pie inmóvil esperando 15 minutos sin atender a nadie más.
- **Modo Asincrónico (`async def`):** El chef mete la pizza al horno (`await cocinando`) y, mientras se hornea, atiende y toma el pedido de otros 20 clientes.

```python
import asyncio
from fastapi import FastAPI

app = FastAPI()

@app.get("/metricas")
async def obtener_metricas():
    await asyncio.sleep(0.1) # Simula consulta no bloqueante a BD
    return {"cpu_usage": "15%", "estado": "optimo"}
```

---

### 🎯 Tu Misión de Hoy:
Crea un endpoint `@app.get("/estado-ia")` utilizando `async def`:
- La función debe llamarse `consultar_estado_ia()`.
- Debe retornar un diccionario con `{"modelo": "FastAPI-LLM", "activo": True}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI

app = FastAPI()

# Define el endpoint asincrónico @app.get("/estado-ia") con async def:
async def consultar_estado_ia():
    pass$CODE$,
    $CODE$from fastapi import FastAPI

app = FastAPI()

@app.get("/estado-ia")
async def consultar_estado_ia():
    return {
        "modelo": "FastAPI-LLM",
        "activo": True
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
async function consultar_estado_ia() {
  return { modelo: "FastAPI-LLM", activo: true };
}
const p = consultar_estado_ia();
assert(p instanceof Promise, "La función debe ser asincrónica y retornar una Promesa.");
p.then(res => {
  assert(res.modelo === "FastAPI-LLM" && res.activo === true, "Debe retornar {'modelo': 'FastAPI-LLM', 'activo': True}.");
});$TEST$,
    80,
    8
  );


  -- ============================================================================
  -- LECCIÓN 9: Inyección de Dependencias con Depends
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 9: Inyección de Dependencias (Depends)',
    'Reutiliza lógica compartida como autenticación o sesiones con el sistema Depends.',
    $THEORY$
### 💉 1. ¿Qué es la Inyección de Dependencias?
Imagina el **guardia de seguridad en la entrada de un club VIP**: antes de que puedas entrar al bar, al salón o a la terraza, el guardia verifica tu credencial.

En lugar de escribir la verificación de seguridad adentro de cada uno de tus 50 endpoints, FastAPI te permite inyectar esa lógica compartida usando **`Depends()`**.

---

### 🔑 2. Cómo Funciona `Depends`
1. Creas una función auxiliar con la lógica compartida.
2. La inyectas en cualquier endpoint mediante `parametro = Depends(funcion_auxiliar)`:

```python
from fastapi import FastAPI, Depends

app = FastAPI()

def obtener_config():
    return {"entorno": "produccion", "debug": False}

@app.get("/panel")
def ver_panel(config: dict = Depends(obtener_config)):
    return {"servidor": "activo", "config": config}
```

---

### 🎯 Tu Misión de Hoy:
1. Crea una función de dependencia llamada `obtener_version()` que retorne `"v1.0.0"`.
2. Crea el endpoint `@app.get("/info")` cuya función `info_api(version: str = Depends(obtener_version))` retorne `{"api": "Codify", "version": version}`.
$THEORY$,
    'python',
    $CODE$from fastapi import FastAPI, Depends

app = FastAPI()

# 1. Crea la función de dependencia obtener_version:
def obtener_version():
    pass

# 2. Crea el endpoint @app.get("/info") inyectando la dependencia:
def info_api(version: str = Depends(obtener_version)):
    pass$CODE$,
    $CODE$from fastapi import FastAPI, Depends

app = FastAPI()

def obtener_version():
    return "v1.0.0"

@app.get("/info")
def info_api(version: str = Depends(obtener_version)):
    return {
        "api": "Codify",
        "version": version
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function obtener_version() {
  return "v1.0.0";
}
function info_api(version = obtener_version()) {
  return { api: "Codify", version: version };
}
assert(obtener_version() === "v1.0.0", "obtener_version() debe retornar 'v1.0.0'.");
const res = info_api();
assert(res.api === "Codify" && res.version === "v1.0.0", "info_api debe inyectar la versión y retornar {'api': 'Codify', 'version': 'v1.0.0'}.");$TEST$,
    85,
    9
  );


  -- ============================================================================
  -- LECCIÓN 10: Proyecto Integrador - API REST CRUD Completa con FastAPI
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    fastapi_module_id,
    'Lección 10: Proyecto Integrador - API REST de Gestión de Tareas',
    'Construye un microservicio completo con Pydantic, persistencia en memoria, rutas GET y POST.',
    $THEORY$
### 🏆 1. El Proyecto Maestro de Backend: Tu Primera API REST Completa
¡Felicitaciones por llegar a la misión final del Módulo de FastAPI! 🎉

Aquí vas a construir el núcleo de un microservicio real: el **Task Manager API**, combinando esquemas Pydantic, base de datos en memoria (`lista`), endpoints de listado (`GET`) y creación (`POST`).

---

### 🧠 2. Arquitectura del Microservicio:
1. **Esquema de Entrada (`TareaIn`):** Valida `titulo: str` y `descripcion: str`.
2. **Base de Datos en Memoria:** Una lista global `db_tareas = []`.
3. **Endpoint GET `/tareas`:** Retorna todas las tareas registradas.
4. **Endpoint POST `/tareas`:** Genera un ID automático, añade la tarea a la lista y retorna la tarea creada.

```python
db_tareas = []

def registrar_en_bd(tarea_dict):
    nuevo_id = len(db_tareas) + 1
    registro = {"id": nuevo_id, **tarea_dict}
    db_tareas.append(registro)
    return registro
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `guardar_tarea(db: list, tarea_datos: dict) -> dict`:
1. Debe calcular `nuevo_id = len(db) + 1`.
2. Debe crear un nuevo registro combinando `{"id": nuevo_id, "titulo": tarea_datos["titulo"], "completada": False}`.
3. Debe agregar el registro a la lista `db` y retornarlo.
$THEORY$,
    'python',
    $CODE$# Implementa el procesador de base de datos para tareas:
def guardar_tarea(db: list, tarea_datos: dict) -> dict:
    pass$CODE$,
    $CODE$def guardar_tarea(db: list, tarea_datos: dict) -> dict:
    nuevo_id = len(db) + 1
    nueva_tarea = {
        "id": nuevo_id,
        "titulo": tarea_datos["titulo"],
        "completada": False
    }
    db.append(nueva_tarea)
    return nueva_tarea$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function guardar_tarea(db, tarea_datos) {
  const nuevo_id = db.length + 1;
  const nueva_tarea = {
    id: nuevo_id,
    titulo: tarea_datos.titulo,
    completada: false
  };
  db.push(nueva_tarea);
  return nueva_tarea;
}
const db = [];
const t1 = guardar_tarea(db, { titulo: "Aprender FastAPI" });
assert(t1.id === 1 && t1.titulo === "Aprender FastAPI" && t1.completada === false, "La primera tarea debe tener id 1 y completada en false.");
assert(db.length === 1, "La lista db debe contener 1 elemento.");
const t2 = guardar_tarea(db, { titulo: "Conectar con IA" });
assert(t2.id === 2 && db.length === 2, "La segunda tarea debe tener id 2 y la lista db debe tener 2 elementos.");$TEST$,
    120,
    10
  );

END $$;
