-- ==============================================================================
-- 🐍 CODIFY SEED: MÓDULO 5 - PYTHON MODERNO & BACKEND FUNDAMENTALS (5 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 5 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  py_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals'
    )
  );
  DELETE FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals';

  -- 2. Creación del Módulo 5
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 5: Python Moderno & Backend Fundamentals',
    'Aprende las bases del lenguaje rey del backend y la Inteligencia Artificial: Sintaxis Python 3.12+, Type Hints, Diccionarios y Colecciones, List Comprehensions, manejo de excepciones con try/except y procesamiento JSON.',
    2
  )
  RETURNING id INTO py_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Sintaxis Python & Type Hints (El Lenguaje de la IA y FastAPI)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 1: Sintaxis Python & Indicios de Tipo (Type Hints)',
    'Crea una función con Type Hints que retorne un diccionario con los datos del usuario.',
    $THEORY$
### 🐍 1. El Lenguaje de la Inteligencia Artificial y FastAPI
Python es hoy el lenguaje más popular del mundo para **Ciencia de Datos, Machine Learning y Desarrollo Backend de Alto Rendimiento (FastAPI)**.

A diferencia de JavaScript:
- **No usa llaves `{}` para bloques de código:** Usa **indentación** (sangría de 4 espacios).
- Las funciones se declaran con la palabra clave `def`.

---

### 🏷️ 2. Type Hints: Tipado Claro en Python Moderno
Imagina las **etiquetas de equipaje en un aeropuerto**: si la valija dice claramente `"Destino: Madrid"` y `"Peso: 23kg"`, el sistema de carga nunca se equivoca.

En Python 3.12+, usamos **Type Hints** para documentar qué tipo de datos recibe y entrega una función:

```python
# nombre es de tipo string (str), edad es de tipo entero (int)
# y la función promete retornar un diccionario (dict):
def registrar_jugador(nombre: str, edad: int) -> dict:
    return {
        "nombre": nombre,
        "edad": edad
    }
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar los dos puntos `:` al final de `def`:** En Python, toda declaración de función o condición debe terminar con dos puntos `:`.
- ❌ **Mezclar espacios y tabulaciones:** Mantén siempre 4 espacios consistentes en cada nivel de indentación.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `crear_usuario(nombre: str, nivel: int) -> dict`:
- Debe recibir el parámetro `nombre` de tipo `str` y `nivel` de tipo `int`.
- Debe retornar un diccionario con dos claves: `"nombre"` con el valor del parámetro y `"nivel"` con el valor numérico.
$THEORY$,
    'python',
    $CODE$# Define la función crear_usuario con Type Hints aquí:
def crear_usuario(nombre: str, nivel: int) -> dict:
    pass$CODE$,
    $CODE$def crear_usuario(nombre: str, nivel: int) -> dict:
    return {
        "nombre": nombre,
        "nivel": nivel
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function crear_usuario(nombre, nivel) {
  return { nombre: nombre, nivel: nivel };
}
const res = crear_usuario("Ana", 5);
assert(typeof res === "object" && res !== null, "crear_usuario debe retornar un diccionario/objeto.");
assert(res.nombre === "Ana", "La clave 'nombre' debe coincidir con el parámetro recibido ('Ana').");
assert(res.nivel === 5, "La clave 'nivel' debe coincidir con el parámetro numérico recibido (5).");$TEST$,
    35,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Diccionarios y Colecciones Backend (El Formato Universal JSON)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 2: Manejo de Listas y Diccionarios en Python',
    'Extrae una lista de nombres desde una lista de diccionarios de usuarios.',
    $THEORY$
### 📊 1. Colecciones en Backend: Listas y Diccionarios
En servicios backend y microservicios, casi toda la información que viaja por internet lo hace en forma de **listas de diccionarios** (el equivalente directo a JSON):

- **Listas (`list`):** Colecciones ordenadas entre corchetes `["Ana", "Mateo"]`.
- **Diccionarios (`dict`):** Estructuras de clave-valor entre llaves `{"nombre": "Ana", "rol": "Admin"}`.

---

### 🔍 2. Accediendo a los Datos en Python
Para leer una propiedad dentro de un diccionario en Python, usamos corchetes con el nombre de la clave en comillas:

```python
usuarios = [
    {"nombre": "Sofía", "puntos": 120},
    {"nombre": "Mateo", "puntos": 95}
]

# Acceder al nombre del primer usuario:
primer_nombre = usuarios[0]["nombre"] # "Sofía"
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `obtener_nombres(lista_usuarios: list) -> list`:
- Recibe una lista de diccionarios donde cada elemento tiene la clave `"nombre"`.
- Debe retornar una nueva lista que contenga únicamente los nombres (strings) de cada usuario.
$THEORY$,
    'python',
    $CODE$def obtener_nombres(lista_usuarios: list) -> list:
    # Extrae y retorna una lista con todos los nombres:
    pass$CODE$,
    $CODE$def obtener_nombres(lista_usuarios: list) -> list:
    return [u["nombre"] for u in lista_usuarios]$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function obtener_nombres(lista) {
  return lista.map(u => u.nombre);
}
const input = [{ nombre: "Sofía" }, { nombre: "Mateo" }, { nombre: "Lucas" }];
const res = obtener_nombres(input);
assert(Array.isArray(res), "obtener_nombres debe retornar una lista.");
assert(res.length === 3, "La lista resultante debe contener 3 nombres.");
assert(res[0] === "Sofía" && res[1] === "Mateo" && res[2] === "Lucas", "Los elementos deben ser ['Sofía', 'Mateo', 'Lucas'].");$TEST$,
    45,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: List Comprehensions (Elegancia Pythonica)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 3: List Comprehensions Pythonicas',
    'Filtra los números pares de una lista en una sola línea de código limpia y eficiente.',
    $THEORY$
### ⚡ 1. ¿Qué es el Código "Pythonico"?
En otros lenguajes, para filtrar una lista necesitas crear un arreglo vacío, escribir un bucle `for`, evaluar un `if` y hacer `append` (5 líneas de código).

En Python existe una de sus características más poderosas y amadas por los científicos de datos: la **List Comprehension**.

---

### 🪄 2. Anatomía de una List Comprehension
Te permite transformar o filtrar colecciones en **una sola línea legible**:

```python
numeros = [1, 2, 3, 4, 5, 6]

# Sintaxis: [expresion for elemento in coleccion if condicion]
pares = [n for n in numeros if n % 2 == 0]
# Resultado: [2, 4, 6]
```

- `n`: El valor que queremos guardar en la nueva lista.
- `for n in numeros`: Recorre cada número.
- `if n % 2 == 0`: Filtra solo aquellos cuyo residuo al dividir por 2 sea 0 (números pares).

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `filtrar_pares(numeros: list) -> list`:
- Debe utilizar una List Comprehension para retornar una nueva lista con únicamente los números pares recibidos en `numeros`.
$THEORY$,
    'python',
    $CODE$def filtrar_pares(numeros: list) -> list:
    # Retorna los números pares usando una List Comprehension:
    pass$CODE$,
    $CODE$def filtrar_pares(numeros: list) -> list:
    return [n for n in numeros if n % 2 == 0]$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function filtrar_pares(numeros) {
  return numeros.filter(n => n % 2 === 0);
}
const res1 = filtrar_pares([1, 2, 3, 4, 5, 6]);
assert(JSON.stringify(res1) === JSON.stringify([2, 4, 6]), "Para [1, 2, 3, 4, 5, 6] debe retornar [2, 4, 6].");
const res2 = filtrar_pares([10, 15, 20, 25]);
assert(JSON.stringify(res2) === JSON.stringify([10, 20]), "Para [10, 15, 20, 25] debe retornar [10, 20].");$TEST$,
    50,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Manejo Seguro de Excepciones (try / except)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 4: Manejo Seguro de Excepciones (try / except)',
    'Evita que tu servidor backend falle al ocurrir una división por cero.',
    $THEORY$
### 🛡️ 1. El Disyuntor Eléctrico del Código: Excepciones
En un servidor backend de FastAPI o procesamiento de IA, si un usuario envía datos corruptos o intenta dividir por cero, Python lanzará una **Excepción (`ZeroDivisionError`)**.

Si no capturas esa excepción, **el servidor entero colapsará**.

---

### 🧯 2. Bloque `try / except` en Python
Usamos `try` para intentar la operación y `except` para atrapar el error específico y responder con un valor de contingencia seguro:

```python
def calcular_promedio(total: float, cantidad: int) -> float:
    try:
        return total / cantidad
    except ZeroDivisionError:
        print("⚠️ Advertencia: No se puede dividir por cero.")
        return 0.0
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `dividir_seguro(a: float, b: float) -> float`:
1. Dentro de un bloque `try`, calcula y retorna `a / b`.
2. Si ocurre una excepción `ZeroDivisionError`, atrápala con `except ZeroDivisionError:` y retorna `0.0`.
$THEORY$,
    'python',
    $CODE$def dividir_seguro(a: float, b: float) -> float:
    # Implementa el bloque try / except para ZeroDivisionError:
    pass$CODE$,
    $CODE$def dividir_seguro(a: float, b: float) -> float:
    try:
        return a / b
    except ZeroDivisionError:
        return 0.0$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function dividir_seguro(a, b) {
  if (b === 0) return 0.0;
  return a / b;
}
assert(dividir_seguro(10, 2) === 5, "10 / 2 debe retornar 5.");
assert(dividir_seguro(10, 0) === 0.0, "10 / 0 debe ser capturado y retornar 0.0 de forma segura.");
assert(dividir_seguro(100, 4) === 25, "100 / 4 debe retornar 25.");$TEST$,
    65,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Proyecto Integrador - Procesador de Registros Backend JSON
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 5: Proyecto Integrador Python - Procesador de Registros JSON',
    'Procesa un lote de datos backend filtrando elementos activos y acumulando sus puntos.',
    $THEORY$
### 🏆 1. El Gran Reto Integrador Backend
¡Felicitaciones por llegar a la cumbre del Módulo de Python! 🎉

En el mundo real del análisis de datos y microservicios, una de las tareas más comunes es **procesar lotes de transacciones o usuarios**: recibir un conjunto de registros JSON, filtrar únicamente los registros válidos o activos y calcular estadísticas agregadas.

---

### 🧠 2. Cómo Combinar Filtros y Acumuladores
En Python puedes combinar una List Comprehension con la función incorporada `sum()`:

```python
ventas = [
    {"monto": 100, "aprobada": True},
    {"monto": 50, "aprobada": False},
    {"monto": 200, "aprobada": True}
]

# Sumamos únicamente los montos de las ventas aprobadas:
total = sum(v["monto"] for v in ventas if v.get("aprobada") is True)
print(total) # 300
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `procesar_datos_json(registros: list) -> int`:
- Recibe una lista de diccionarios, donde cada registro contiene las claves `"puntos"` (entero) y `"activo"` (booleano).
- Debe sumar y retornar el total de puntos **únicamente de aquellos registros donde `"activo"` sea `True`**.
$THEORY$,
    'python',
    $CODE$def procesar_datos_json(registros: list) -> int:
    # Filtra los registros activos y suma sus puntos:
    pass$CODE$,
    $CODE$def procesar_datos_json(registros: list) -> int:
    return sum(r["puntos"] for r in registros if r.get("activo") is True)$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function procesar_datos_json(registros) {
  return registros.filter(r => r.activo === true).reduce((acc, curr) => acc + curr.puntos, 0);
}
const lote1 = [
  { puntos: 50, activo: true },
  { puntos: 100, activo: false },
  { puntos: 30, activo: true }
];
assert(procesar_datos_json(lote1) === 80, "La suma de los puntos de registros activos (50 + 30) debe ser 80.");

const lote2 = [
  { puntos: 10, activo: false },
  { puntos: 20, activo: false }
];
assert(procesar_datos_json(lote2) === 0, "Si ningún registro está activo, debe retornar 0.");$TEST$,
    100,
    5
  );

END $$;
