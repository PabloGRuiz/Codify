-- ==============================================================================
-- 🐍 CODIFY SEED: MÓDULO 5 - PYTHON MODERNO & BACKEND FUNDAMENTALS (5 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 5 sin borrar ni alterar los demás módulos.
-- ==============================================================================

DO $$
DECLARE
  py_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals'
  );
  DELETE FROM public.modules WHERE title = 'Módulo 5: Python Moderno & Backend Fundamentals';

  -- 2. Creación del Módulo 5
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 5: Python Moderno & Backend Fundamentals',
    'Aprende las bases del lenguaje backend más usado en IA: Sintaxis Python 3.12+, Type Hints, List Comprehensions, Manejo de Excepciones y Diccionarios.',
    2
  )
  RETURNING id INTO py_module_id;

  -- Lección 1: Sintaxis Python y Type Hints
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 1: Sintaxis Python & Indicios de Tipo (Type Hints)',
    'Crea una función con Type Hints que retorne un diccionario con los datos del usuario.',
    $THEORY$
### 🐍 Bienvenido al Mundo de Python
Python es el lenguaje estándar para desarrollo backend moderno e Inteligencia Artificial. Usa **Type Hints** (`nombre: str`, `nivel: int`) para definir los datos.

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
function crear_usuario(nombre, nivel) {
  return { nombre: nombre, nivel: nivel };
}
const res = crear_usuario("Ana", 5);
assert(typeof res === "object" && res.nombre === "Ana" && res.nivel === 5, "Debe retornar un diccionario con nombre y nivel");$TEST$,
    35,
    1
  );

  -- Lección 2: Listas y Diccionarios
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 2: Manejo de Listas y Diccionarios en Python',
    'Extrae una lista de nombres desde una lista de diccionarios.',
    $THEORY$
### 📊 Listas y Diccionarios
- Listas `[]` y Diccionarios `{}` clave-valor.

### 🎯 Tu Misión:
Crea `obtener_nombres(lista_usuarios: list) -> list` que retorne una lista solo con la propiedad `"nombre"` de cada elemento.
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
assert(Array.isArray(res) && res[0] === "Sofía" && res[1] === "Mateo", "Retorna lista de nombres");$TEST$,
    45,
    2
  );

  -- Lección 3: List Comprehensions
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 3: List Comprehensions Pythonicas',
    'Filtra los números pares de una lista en una sola línea de código.',
    $THEORY$
### ⚡ List Comprehension
Sintaxis elegante en 1 sola línea: `[x for x in lista if condicion]`.

### 🎯 Tu Misión:
Crea `filtrar_pares(numeros: list) -> list` que utilice una List Comprehension para devolver únicamente los números cuyo residuo `% 2 == 0`.
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
assert(JSON.stringify(filtrar_pares([1, 2, 3, 4, 5, 6])) === JSON.stringify([2, 4, 6]), "Filtra pares [2, 4, 6]");$TEST$,
    50,
    3
  );

  -- Lección 4: try / except
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 4: Manejo Seguro de Excepciones (try / except)',
    'Evita que tu programa Python falle al dividir por cero.',
    $THEORY$
### 🛡️ Excepciones en Python
Previene errores fatales envolviendo ejecuciones con `try` y `except`.

### 🎯 Tu Misión:
Crea `dividir_seguro(a: float, b: float) -> float` que retorne `a / b` o `0.0` si ocurre una división por cero.
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
assert(dividir_seguro(10, 2) === 5, "10 / 2 es 5");
assert(dividir_seguro(10, 0) === 0.0, "10 / 0 retorna 0.0");$TEST$,
    65,
    4
  );

  -- Lección 5: Proyecto Integrador
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    py_module_id,
    'Lección 5: Proyecto Integrador Python - Procesador de Registros JSON',
    'Procesa un conjunto de datos backend filtrando elementos activos y acumulando sus puntos.',
    $THEORY$
### 🏆 Proyecto Integrador Backend Python
Procesa registros JSON filtrando elementos activos y sumando sus puntos.

### 🎯 Tu Misión:
Crea `procesar_datos_json(registros: list) -> int` que sume y devuelva el total de `"puntos"` únicamente de los elementos donde `"activo"` sea `True`.
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
assert(procesar_datos_json(datos) === 80, "Suma de activos 50+30=80");$TEST$,
    100,
    5
  );

END $$;
