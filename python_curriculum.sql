-- ==============================================================================
-- 🐍 MÓDULO 5 COMPLETO: PYTHON MODERNO & BACKEND FUNDAMENTALS (5 LECCIONES)
-- ==============================================================================
-- Usamos Dollar Quoting ($THEORY$, $CODE$, $TEST$) para sintaxis SQL garantizada.

DO $$
DECLARE
  py_module_id UUID;
BEGIN

  -- 1. Crear el Módulo 5 (Python Backend)
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 5: Python Moderno & Backend Fundamentals',
    'Aprende las bases del lenguaje backend más usado en IA: Sintaxis Python 3.12+, Type Hints, List Comprehensions, Manejo de Excepciones y Diccionarios.',
    2
  )
  RETURNING id INTO py_module_id;

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 1: SINTAXIS PYTHON 3.12+ Y TYPE HINTS
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    py_module_id,
    'Lección 1: Sintaxis Python & Indicios de Tipo (Type Hints)',
    'Crea una función con Type Hints que retorne un diccionario con los datos del usuario.',
    $THEORY$
### 🐍 Bienvenido al Mundo de Python
Python es el lenguaje estándar para desarrollo backend moderno y herramientas de Inteligencia Artificial.

En Python 3.10+, utilizamos **Type Hints** (`nombre: str`, `nivel: int`) para indicar qué tipo de datos espera cada variable y qué tipo de dato retorna (`-> dict`).

### 📝 Ejemplo de Código:
```python
def obtener_perfil(nombre: str, edad: int) -> dict:
    return {
        "nombre": nombre,
        "edad": edad,
        "saludo": f"Hola {nombre}"
    }
```

### 🎯 Tu Misión:
Crea una función `crear_usuario(nombre: str, nivel: int) -> dict` que devuelva un diccionario con las llaves `"nombre"` y `"nivel"`.
$THEORY$,
    'python',
    $CODE$def crear_usuario(nombre: str, nivel: int) -> dict:
    # Tu código Python aquí:
    pass$CODE$,
    $CODE$def crear_usuario(nombre: str, nivel: int) -> dict:
    return {
        "nombre": nombre,
        "nivel": nivel
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
// Simulación de evaluación Python/JS
function crear_usuario(nombre, nivel) {
  return { nombre: nombre, nivel: nivel };
}
const res = crear_usuario("Ana", 5);
assert(typeof res === "object" && res.nombre === "Ana" && res.nivel === 5, "Debe retornar un diccionario con nombre y nivel");$TEST$,
    35,
    1
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 2: ESTRUCTURAS DE DATOS (Listas y Diccionarios)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    py_module_id,
    'Lección 2: Manejo de Listas y Diccionarios en Python',
    'Extrae una lista de nombres desde una lista de diccionarios.',
    $THEORY$
### 📊 Listas y Diccionarios en Python
- **Listas (`[]`)**: Colecciones ordenadas de elementos.
- **Diccionarios (`{}`)**: Estructuras clave-valor indispensables para trabajar con datos JSON.

### 📝 Ejemplo de Código:
```python
usuarios = [
    {"id": 1, "nombre": "Carlos"},
    {"id": 2, "nombre": "Elena"}
]

nombres = [u["nombre"] for u in usuarios]
```

### 🎯 Tu Misión:
Crea la función `obtener_nombres(lista_usuarios: list) -> list` que reciba una lista de diccionarios y devuelva una lista conteniendo solo el atributo `"nombre"` de cada elemento.
$THEORY$,
    'python',
    $CODE$def obtener_nombres(lista_usuarios: list) -> list:
    # Tu código aquí:
    pass$CODE$,
    $CODE$def obtener_nombres(lista_usuarios: list) -> list:
    return [u["nombre"] for u in lista_usuarios]$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function obtener_nombres(lista) {
  return lista.map(u => u.nombre);
}
const input = [{ nombre: "Sofía" }, { nombre: "Mateo" }];
const res = obtener_nombres(input);
assert(Array.isArray(res) && res[0] === "Sofía" && res[1] === "Mateo", "Debe retornar la lista de nombres ['Sofía', 'Mateo']");$TEST$,
    45,
    2
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 3: LIST COMPREHENSIONS Y CONTROL DE FLUJO
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    py_module_id,
    'Lección 3: List Comprehensions Pythonicas',
    'Filtra los números pares de una lista en una sola línea de código.',
    $THEORY$
### ⚡ Sintaxis Pythonica: List Comprehension
Las **List Comprehensions** permiten filtrar y transformar listas de forma elegante y rápida sin necesidad de escribir varias líneas de bucle `for`.

### 📝 Ejemplo de Código:
```python
numeros = [1, 2, 3, 4, 5, 6]
mayores_a_tres = [n for n in numeros if n > 3]
```

### 🎯 Tu Misión:
Crea la función `filtrar_pares(numeros: list) -> list` que utilice una List Comprehension para devolver únicamente los números cuyo residuo `% 2 == 0`.
$THEORY$,
    'python',
    $CODE$def filtrar_pares(numeros: list) -> list:
    # Tu código aquí:
    pass$CODE$,
    $CODE$def filtrar_pares(numeros: list) -> list:
    return [n for n in numeros if n % 2 == 0]$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function filtrar_pares(numeros) {
  return numeros.filter(n => n % 2 === 0);
}
assert(JSON.stringify(filtrar_pares([1, 2, 3, 4, 5, 6])) === JSON.stringify([2, 4, 6]), "Debe filtrar los pares [2, 4, 6]");$TEST$,
    50,
    3
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 4: MANEJO DE EXCEPCIONES EN PYTHON (try / except)
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    py_module_id,
    'Lección 4: Manejo Seguro de Excepciones (try / except)',
    'Evita que tu programa Python falle al dividir por cero.',
    $THEORY$
### 🛡️ Excepciones en Python
Para prevenir que un error destruya la ejecución de tu servidor backend, usamos bloques `try` y `except ZeroDivisionError`.

### 📝 Ejemplo de Código:
```python
try:
    resultado = 10 / 0
except ZeroDivisionError:
    resultado = 0.0
```

### 🎯 Tu Misión:
Crea la función `dividir_seguro(a: float, b: float) -> float` que retorne `a / b`. Si ocurre una división por cero (`b == 0`), debe retornar `0.0`.
$THEORY$,
    'python',
    $CODE$def dividir_seguro(a: float, b: float) -> float:
    # Tu código aquí:
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
assert(dividir_seguro(10, 2) === 5, "10 / 2 debe ser 5");
assert(dividir_seguro(10, 0) === 0.0, "Al dividir por cero debe retornar 0.0");$TEST$,
    65,
    4
  );

  -- ----------------------------------------------------------------------------
  -- LECCIÓN 5: RETO FINAL INTEGRADOR PYTHON - PROCESADOR DE DATOS JSON
  -- ----------------------------------------------------------------------------
  INSERT INTO public.challenges (module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index)
  VALUES (
    py_module_id,
    'Lección 5: Proyecto Integrador Python - Procesador de Registros JSON',
    'Procesa un conjunto de datos backend filtrando elementos activos y acumulando sus puntos.',
    $THEORY$
### 🏆 Proyecto Integrador Backend Python
En las aplicaciones reales conectadas a FastAPI o bases de datos, procesarás registros JSON devueltos por la BD.

### 🎯 Tu Misión:
Crea la función `procesar_datos_json(registros: list) -> int` que:
1. Reciba una lista de diccionarios con la estructura `{"puntos": int, "activo": bool}`.
2. Sume y devuelva el total de `"puntos"` únicamente de aquellos elementos donde `"activo"` sea `True`.
$THEORY$,
    'python',
    $CODE$def procesar_datos_json(registros: list) -> int:
    # Tu código aquí:
    pass$CODE$,
    $CODE$def procesar_datos_json(registros: list) -> int:
    return sum(r["puntos"] for r in registros if r.get("activo") is True)$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function procesar_datos_json(registros) {
  return registros.filter(r => r.activo === true).reduce((acc, curr) => acc + curr.puntos, 0);
}
const datos = [
  { puntos: 50, activo: true },
  { puntos: 100, activo: false },
  { puntos: 30, activo: true }
];
assert(procesar_datos_json(datos) === 80, "50 + 30 debe ser 80");$TEST$,
    100,
    5
  );

END $$;
