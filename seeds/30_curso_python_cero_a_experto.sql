-- ==============================================================================
-- 🐍 SGFC SEED: 30 - CURSO COMPLETO: PYTHON MODERNO DE CERO A EXPERTO
-- ==============================================================================
-- 1. Curso: "Python Moderno: De Cero a Experto"
-- 2. 6 Módulos Secuenciales Progresivos (de novato a profesional)
-- 3. 20 Lecciones completas (Teoría detallada, Quizzes y Retos de Código Python con tests nativos)
-- 4. Reto Final Integrador Multi-Archivo (models.py, services.py, main.py)
-- 5. Certificación Oficial Verificable "Certificación Profesional en Python Moderno" (20 preguntas)
-- ==============================================================================

DO $PYTHON_COURSE_SEED$
DECLARE
  v_author_id UUID;
  v_course_id UUID;
  v_m1_id UUID;
  v_m2_id UUID;
  v_m3_id UUID;
  v_m4_id UUID;
  v_m5_id UUID;
  v_m6_id UUID;
  v_cert_id UUID;
BEGIN

  -- 1. Obtener autor de referencia o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Limpieza idempotente previa si el curso ya existía
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT c.id FROM public.challenges c
    JOIN public.modules m ON c.module_id = m.id
    JOIN public.courses co ON m.course_id = co.id
    WHERE co.title = 'Python Moderno: De Cero a Experto'
  );
  DELETE FROM public.certification_questions WHERE certification_id IN (
    SELECT id FROM public.certifications WHERE code = 'CERT-PY-PRO'
  );
  DELETE FROM public.certifications WHERE code = 'CERT-PY-PRO';
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT m.id FROM public.modules m
    JOIN public.courses co ON m.course_id = co.id
    WHERE co.title = 'Python Moderno: De Cero a Experto'
  );
  DELETE FROM public.modules WHERE course_id IN (
    SELECT id FROM public.courses WHERE title = 'Python Moderno: De Cero a Experto'
  );
  DELETE FROM public.courses WHERE title = 'Python Moderno: De Cero a Experto';

  -- 3. Crear Curso
  INSERT INTO public.courses (
    title,
    description,
    summary,
    tags,
    min_level,
    author_id,
    status
  ) VALUES (
    'Python Moderno: De Cero a Experto',
    'Aprende Python desde sus cimientos más elementales con analogías intuitivas para principiantes, hasta dominar la arquitectura moderna: estructuras de datos complejas, POO avanzada, type hints, dataclasses, pattern matching, concurrencia con asyncio y un proyecto modular multi-archivo evaluado en tiempo real.',
    $SUMMARY$## 🚀 Acerca del Curso

Python es el lenguaje de programación más popular y versátil del planeta: utilizado por gigantes como Google, Netflix, Instagram y la NASA para desarrollo backend, inteligencia artificial, ciencia de datos, automatización de sistemas y ciberseguridad.

Este curso fue diseñado con una premisa clara: **cualquier persona puede aprender a programar si los conceptos se explican de forma visual, amigable y progresiva**. No asumimos conocimientos matemáticos avanzados ni experiencia previa en desarrollo. Partiremos desde qué es una variable y cómo piensa una computadora, hasta construir sistemas modulares con las características más potentes de **Python 3.10, 3.11 y 3.12+**.

---

### 🎯 ¿Qué aprenderás?

1. **Fundamentos sin frustración:** Variables, tipos de datos primitivos, operadores matemáticos y la lógica de toma de decisiones (`if`, `elif`, `else`).
2. **Colecciones en memoria:** Listas, tuplas, diccionarios asociativos y conjuntos (`set`). Búsquedas rápidas y *List Comprehensions* elegantes.
3. **Funciones y Buenas Prácticas:** Modularidad con `def`, parámetros flexibles (`*args`, `**kwargs`), alcance de variables y manejo profesional de excepciones (`try / except / finally`).
4. **Programación Orientada a Objetos (POO):** Clases, instancias, el rol de `self`, métodos mágicos (`__str__`, `__len__`), encapsulamiento con `@property`, herencia y polimorfismo.
5. **Python Moderno:** Tipado estático con *Type Hints*, clases de datos con `@dataclass`, coincidencia de patrones con `match / case`, generadores (`yield`) y programación asíncrona con `asyncio`.
6. **Proyecto Integrador Multi-Archivo:** Construcción de un sistema real en el IDE dividido en múltiples archivos (`models.py`, `services.py`, `main.py`) con importaciones locales y suite de pruebas unitarias automáticas.

---

### 👥 ¿A quién está dirigido?

- Personas sin experiencia previa o con conocimientos mínimos que deseen aprender a programar con bases sólidas y sin malas prácticas.
- Desarrolladores que vienen de otros lenguajes (JavaScript, C++, Java, PHP) y quieren dominar la sintaxis nativa y modismos pythónicos.
- Futuros ingenieros de backend, científicos de datos o entusiastas de la IA que necesitan bases robustas en Python.$SUMMARY$,
    ARRAY['Python', 'Backend', 'POO', 'Asyncio', 'Modern Python', 'Multi-archivo', 'Dataclasses', 'Algoritmos'],
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- 📌 MÓDULO 1: PRIMEROS PASOS: VARIABLES, TIPOS Y DECISIONES
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Primeros Pasos: Variables, Tipos y Decisiones',
    'Descubre el lenguaje más legible del mundo. Aprende qué es una variable, cómo manipular texto y números, y cómo hacer que tu programa tome decisiones.',
    1
  ) RETURNING id INTO v_m1_id;

  -- Lección 1.1 (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code
  ) VALUES (
    v_m1_id,
    '1.1 ¿Qué es Python y el Zen de la Legibilidad?',
    'Comprende cómo ejecuta el código el intérprete de Python y por qué la indentación sustituye a las llaves.',
    'quiz',
    50,
    1,
    $THEORY$# ¿Qué es Python y por qué es tan especial?

Bienvenido al fascinante mundo de la programación. Python fue creado a finales de los años 80 por **Guido van Rossum** con una meta muy particular: **hacer que el código sea tan fácil de leer y escribir como el inglés cotidiano**.

---

### 1. ¿Cómo funciona un lenguaje interpretado?

En lenguajes como C++ o Rust, el código debe compilarse previamente a archivos binarios antes de poder ejecutarse. Python es un **lenguaje interpretado**: existe un programa llamado **intérprete de Python** que lee tus instrucciones línea por línea y las traduce en tiempo real para el procesador.

```
Tu archivo (.py)  --->  Intérprete de Python  --->  Ejecución inmediata
print("Hola Mundo")     (Lee y ejecuta línea a línea)
```

---

### 2. La regla sagrada: La Indentación (Sangría)

En la mayoría de los lenguajes (como JavaScript, Java o C#), los bloques de código se encierran entre llaves `{ }`. En Python **no existen las llaves para bloques de código**: la jerarquía se define mediante **la sangría (4 espacios en blanco)**.

```python
# En Python, el espacio en blanco tiene significado sintáctico
if usuario_autenticado:
    print("Acceso concedido")  # Esta línea está DENTRO del if por la sangría
print("Fin de verificación")   # Esta línea se ejecuta SIEMPRE porque no tiene sangría
```

---

### 3. El "Zen de Python" (*PEP 20*)

Si abres una terminal de Python y escribes `import this`, verás los principios de diseño que guían a la comunidad:
- *Bello es mejor que feo.*
- *Explícito es mejor que implícito.*
- *Simple es mejor que complejo.*
- *La legibilidad cuenta.*$THEORY$,
    '[{"id":"q1","question":"¿Cómo delimita Python los bloques de código dentro de estructuras como condicionales o funciones?","options":["Mediante llaves { }","Mediante la indentación (espacios de sangría consistentes)","Con etiquetas de cierre como end if o finish","Con puntos y comas al final de cada bloque"],"correctIndex":1,"explanation":"Python utiliza la sangría (típicamente 4 espacios) para saber qué líneas pertenecen a un bloque de código determinado."},{"id":"q2","question":"¿Cuál es el rol del intérprete de Python?","options":["Generar un archivo ejecutable binario .exe permanente","Leer y ejecutar las instrucciones escritas en código Python línea por línea","Dar formato estético a las páginas web","Comprimir imágenes antes de guardarlas"],"correctIndex":1,"explanation":"El intérprete lee y ejecuta directamente el código fuente sin requerir un proceso de compilación manual previo."},{"id":"q3","question":"¿Cuál de los siguientes es un principio fundamental del Zen de Python (PEP 20)?","options":["Complejo es mejor que simple","El código debe usar tantas abreviaturas como sea posible","La legibilidad cuenta","Siempre es mejor usar código críptico para proteger la propiedad intelectual"],"correctIndex":2,"explanation":"\"Readability counts\" (La legibilidad cuenta) es uno de los mantras centrales de la filosofía de diseño de Python."}]'
  );

  -- Lección 1.2 (Código Python: Variables y Tipos)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m1_id,
    '1.2 Variables y Tipos Primitivos en Acción',
    'Crea variables con enteros, decimales, texto y booleanos, calculando el precio final con descuento.',
    'python',
    75,
    2,
    $THEORY$# Variables y Tipos de Datos Primitivos

Imagina una **variable** como una caja con una etiqueta adhesiva pegada por fuera. Dentro de la caja guardas un dato en la memoria RAM, y la etiqueta te permite acceder a él cuando lo necesites.

---

### 1. Tipado Dinámico pero Fuerte

En Python no necesitas declarar qué tipo de dato guardará una variable (como `int x`). Python lo deduce automáticamente (**tipado dinámico**):

```python
edad = 25              # int (número entero)
precio = 19.99         # float (número decimal)
nombre = "Carlos"      # str (cadena de texto / string)
es_estudiante = True   # bool (booleano: True o False con mayúscula inicial)
```

> ⚠️ **Importante:** Python tiene **tipado fuerte**. No puedes sumar texto con números mágicamente (`"5" + 2` da un error `TypeError`). Debes convertir explícitamente: `int("5") + 2` o `str(2)`.

---

### 2. Formateo Moderno con *f-strings*

La forma más moderna y legible de combinar variables con texto en Python (disponible desde Python 3.6+) son las **f-strings** (strings con prefijo `f` y variables entre llaves `{}`):

```python
producto = "Teclado Mecánico"
costo = 45.50
print(f"El {producto} cuesta ${costo:.2f}")
# Salida: El Teclado Mecánico cuesta $45.50
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `calcular_ficha_producto(nombre, precio_base, porcentaje_descuento, disponible)` para que calcule el `precio_final` restando el descuento y devuelva un diccionario con la siguiente estructura:
```python
{
    "nombre": nombre,
    "precio_final": precio_con_descuento,  # float
    "disponible": disponible              # bool
}
```
*Ejemplo:* Si `precio_base = 100.0` y `porcentaje_descuento = 20.0`, el descuento es `100.0 * (20.0 / 100) = 20.0`, por lo que `precio_final = 80.0`.$THEORY$,
    'def calcular_ficha_producto(nombre: str, precio_base: float, porcentaje_descuento: float, disponible: bool) -> dict:
    # 1. Calcula el descuento y el precio final
    # 2. Retorna el diccionario con las claves: "nombre", "precio_final", "disponible"
    pass',
    'def calcular_ficha_producto(nombre: str, precio_base: float, porcentaje_descuento: float, disponible: bool) -> dict:
    descuento = precio_base * (porcentaje_descuento / 100.0)
    precio_final = precio_base - descuento
    return {
        "nombre": nombre,
        "precio_final": round(precio_final, 2),
        "disponible": disponible
    }',
    'import main

resultado = main.calcular_ficha_producto("Auriculares Pro", 100.0, 15.0, True)
assert isinstance(resultado, dict), "La función debe retornar un diccionario."
assert "nombre" in resultado, "El diccionario debe contener la clave ''nombre''."
assert "precio_final" in resultado, "El diccionario debe contener la clave ''precio_final''."
assert "disponible" in resultado, "El diccionario debe contener la clave ''disponible''."
assert resultado["nombre"] == "Auriculares Pro", "El nombre debe coincidir con el argumento recibido."
assert abs(resultado["precio_final"] - 85.0) < 0.01, f"Se esperaba precio_final 85.0 pero se obtuvo {resultado[''precio_final'']}."
assert resultado["disponible"] is True, "El campo disponible debe ser True."

resultado2 = main.calcular_ficha_producto("Monitor 4K", 400.0, 50.0, False)
assert abs(resultado2["precio_final"] - 200.0) < 0.01, "Error calculando descuento del 50%."
assert resultado2["disponible"] is False, "El campo disponible debe ser False."
print("✓ Cálculo de ficha de producto validado con éxito.")'
  );

  -- Lección 1.3 (Código Python: Operadores y Aritmética)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m1_id,
    '1.3 Operadores Aritméticos y Lógica Booleana',
    'Domina la división entera, módulo, potencias y las compuertas lógicas and, or y not.',
    'python',
    75,
    3,
    $THEORY$# Operadores Aritméticos y Lógicos en Python

Python no es solo un lenguaje de propósito general; es una de las calculadoras más precisas y elegantes del mundo de la informática.

---

### 1. Operadores Aritméticos Especiales:

| Operador | Nombre | Ejemplo | Resultado |
| :--- | :--- | :--- | :--- |
| `/` | División decimal clásica | `7 / 2` | `3.5` (siempre devuelve `float`) |
| `//` | División entera (piso / *floor*) | `7 // 2` | `3` (descarta los decimales) |
| `%` | Módulo o residuo | `7 % 2` | `1` (el sobrante de la división) |
| `**` | Potenciación | `2 ** 3` | `8` ($2^3 = 2 \times 2 \times 2$) |

---

### 2. Operadores Lógicos Booleanos:

A diferencia de C o JavaScript que usan `&&`, `||` y `!`, Python utiliza palabras en inglés puro:
- **`and`**: Verdadero solo si **ambas** condiciones son `True`.
- **`or`**: Verdadero si **al menos una** condición es `True`.
- **`not`**: Invierte el valor lógico (`not True` resulta en `False`).

---

### 🎯 Tu Misión en este Reto:
Escribe una función `es_acceso_valido(edad: int, tiene_membresia: bool, esta_bloqueado: bool) -> bool` que determine si un usuario puede ingresar a una plataforma exclusiva:
- El usuario debe tener **18 años o más**.
- Debe contar con membresía activa (`tiene_membresia is True`).
- Y **no** debe estar bloqueado (`esta_bloqueado is False`).$THEORY$,
    'def es_acceso_valido(edad: int, tiene_membresia: bool, esta_bloqueado: bool) -> bool:
    # Retorna True si cumple todos los requisitos, False en caso contrario
    pass',
    'def es_acceso_valido(edad: int, tiene_membresia: bool, esta_bloqueado: bool) -> bool:
    return edad >= 18 and tiene_membresia and not esta_bloqueado',
    'import main

assert main.es_acceso_valido(20, True, False) is True, "Un usuario de 20 años con membresía y sin bloqueo debe tener acceso (True)."
assert main.es_acceso_valido(17, True, False) is False, "Un menor de 18 años no debe tener acceso (False)."
assert main.es_acceso_valido(25, False, False) is False, "Un usuario sin membresía no debe tener acceso (False)."
assert main.es_acceso_valido(30, True, True) is False, "Un usuario bloqueado no debe tener acceso bajo ninguna circunstancia (False)."
assert main.es_acceso_valido(18, True, False) is True, "Con exactamente 18 años el acceso debe ser concedido."
print("✓ Validación de reglas booleanas completada exitosamente.")'
  );

  -- Lección 1.4 (Código Python: Control de Flujo con if/elif/else)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m1_id,
    '1.4 Estructuras de Decisión: if, elif y else',
    'Aprende a bifurcar el flujo de ejecución evaluando condiciones jerárquicas.',
    'python',
    75,
    4,
    $THEORY$# Estructuras de Decisión: if, elif y else

Un programa informático sin condicionales sería una línea recta aburrida que siempre hace lo mismo. Las estructuras de decisión permiten que el software actúe según los datos que recibe.

---

### 1. La Sintaxis:

```python
puntaje = 85

if puntaje >= 90:
    clasificacion = "Sobresaliente"
elif puntaje >= 70:
    clasificacion = "Aprobado"
elif puntaje >= 50:
    clasificacion = "En Recuperación"
else:
    clasificacion = "Reprobado"
```

- **`if`**: La primera condición que se evalúa.
- **`elif`** (*else if*): Se evalúa únicamente si las condiciones anteriores resultaron falsas. Puedes tener tantos `elif` como necesites.
- **`else`**: El comodín final que se ejecuta si ninguna de las condiciones anteriores se cumplió.

---

### 🎯 Tu Misión en este Reto:
Implementa la función `categorizar_temperatura(grados_celsius: float) -> str` que devuelva una descripción según la escala:
- Menor o igual a `0`: `"Congelante"`
- Entre `0.1` y `15.0` inclusive: `"Frío"`
- Entre `15.1` y `25.0` inclusive: `"Templado"`
- Entre `25.1` y `35.0` inclusive: `"Cálido"`
- Mayor a `35.0`: `"Extremo"`$THEORY$,
    'def categorizar_temperatura(grados_celsius: float) -> str:
    # Evalúa el valor de grados_celsius y retorna el string correspondiente
    pass',
    'def categorizar_temperatura(grados_celsius: float) -> str:
    if grados_celsius <= 0:
        return "Congelante"
    elif grados_celsius <= 15.0:
        return "Frío"
    elif grados_celsius <= 25.0:
        return "Templado"
    elif grados_celsius <= 35.0:
        return "Cálido"
    else:
        return "Extremo"',
    'import main

assert main.categorizar_temperatura(-5) == "Congelante", "-5° debe ser ''Congelante''"
assert main.categorizar_temperatura(0) == "Congelante", "0° debe ser ''Congelante''"
assert main.categorizar_temperatura(10) == "Frío", "10° debe ser ''Frío''"
assert main.categorizar_temperatura(15.0) == "Frío", "15.0° debe ser ''Frío''"
assert main.categorizar_temperatura(22) == "Templado", "22° debe ser ''Templado''"
assert main.categorizar_temperatura(25.0) == "Templado", "25.0° debe ser ''Templado''"
assert main.categorizar_temperatura(30) == "Cálido", "30° debe ser ''Cálido''"
assert main.categorizar_temperatura(35.0) == "Cálido", "35.0° debe ser ''Cálido''"
assert main.categorizar_temperatura(40) == "Extremo", "40° debe ser ''Extremo''"
print("✓ Clasificador de temperatura validado correctamente.")'
  );

  -- ==============================================================================
  -- 📌 MÓDULO 2: COLECCIONES DE DATOS Y BUCLES (ITERACIONES)
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Colecciones de Datos y Bucles (Iteraciones)',
    'Domina la manipulación de conjuntos de información en memoria: listas dinámicas, tuplas inmutables, diccionarios clave-valor, sets y bucles avanzados con comprehensions.',
    2
  ) RETURNING id INTO v_m2_id;

  -- Lección 2.1 (Código Python: Listas y Slicing)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m2_id,
    '2.1 Listas y Tuplas: Indexación y Slicing Avanzado',
    'Aprende a acceder a elementos con índices negativos y extraer sub-secuencias con slicing.',
    'python',
    75,
    1,
    $THEORY$# Listas y Tuplas en Python

Cuando necesitas guardar más de un dato en una sola variable, recurres a las **colecciones**. Las dos secuencias más comunes son las listas y las tuplas:

- **`list` (Lista):** Colección ordenada y **mutable** (puedes agregar, modificar o quitar elementos con corchetes `[...]`).
- **`tuple` (Tupla):** Colección ordenada e **inmutable** (una vez creada con paréntesis `(...)`, sus elementos no pueden cambiar). Son más ligeras y seguras para datos fijos como coordenadas `(x, y)`.

---

### 1. Indexación Negativa y Slicing:

En Python no necesitas calcular `len(lista) - 1` para obtener el último elemento; puedes usar índices negativos:

```python
numeros = [10, 20, 30, 40, 50]
print(numeros[-1])  # 50 (el último)
print(numeros[-2])  # 40 (el penúltimo)
```

El **Slicing** (*rebanado*) permite extraer porciones usando la sintaxis `lista[inicio:fin:paso]`:
- `inicio`: Índice donde arranca (incluido).
- `fin`: Índice donde termina (**excluido**).
- `paso`: Cada cuántos elementos avanzar (por defecto 1).

```python
letras = ["a", "b", "c", "d", "e"]
print(letras[1:4])   # ['b', 'c', 'd']
print(letras[:3])    # ['a', 'b', 'c'] (desde el inicio hasta el índice 3 excluido)
print(letras[::-1])  # ['e', 'd', 'c', 'b', 'a'] (¡invertir la lista entera!)
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `analizar_secuencia(elementos: list) -> dict`:
- `primero`: El primer elemento de la lista.
- `ultimo`: El último elemento (usando índice negativo).
- `medio`: Los elementos centrales excluyendo el primero y el último (usando slicing `[1:-1]`).
- `invertida`: La lista completa invertida con slicing `[::-1]`.
*(Si la lista tiene menos de 2 elementos, `medio` debe ser una lista vacía `[]`).* $THEORY$,
    'def analizar_secuencia(elementos: list) -> dict:
    # Retorna un diccionario con las claves: "primero", "ultimo", "medio", "invertida"
    pass',
    'def analizar_secuencia(elementos: list) -> dict:
    if not elementos:
        return {"primero": None, "ultimo": None, "medio": [], "invertida": []}
    return {
        "primero": elementos[0],
        "ultimo": elementos[-1],
        "medio": elementos[1:-1] if len(elementos) > 2 else [],
        "invertida": elementos[::-1]
    }',
    'import main

datos = [10, 20, 30, 40, 50]
res = main.analizar_secuencia(datos)

assert res["primero"] == 10, "El primero debe ser 10."
assert res["ultimo"] == 50, "El último debe ser 50."
assert res["medio"] == [20, 30, 40], "Los elementos del medio deben ser [20, 30, 40]."
assert res["invertida"] == [50, 40, 30, 20, 10], "La lista invertida debe ser [50, 40, 30, 20, 10]."

datos_cortos = [1, 2]
res_cortos = main.analizar_secuencia(datos_cortos)
assert res_cortos["medio"] == [], "Con 2 elementos no hay elementos centrales."
print("✓ Análisis y slicing de listas comprobado.")'
  );

  -- Lección 2.2 (Código Python: Diccionarios y Sets)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m2_id,
    '2.2 Diccionarios y Conjuntos (Sets): Mapeos y Unicidad',
    'Aprende a buscar información en tiempo constante con diccionarios y eliminar duplicados con sets.',
    'python',
    75,
    2,
    $THEORY$# Diccionarios y Conjuntos (*Sets*)

Mientras que una lista ordena datos por posiciones numéricas (`0, 1, 2...`), un **Diccionario** (`dict`) los asocia mediante **parejas de clave-valor** (*Key-Value*).

```python
usuario = {
    "username": "ada_lovelace",
    "email": "ada@algorithm.org",
    "rol": "admin"
}
# Acceso seguro con .get() (evita que el programa se rompa si la clave no existe):
print(usuario.get("email"))          # 'ada@algorithm.org'
print(usuario.get("telefono", "N/A")) # 'N/A' (valor por defecto)
```

---

### Conjuntos (*Sets*):
Un **`set`** es una colección de elementos **únicos** y desordenados. Es la forma más rápida y pythónica de eliminar elementos repetidos de una lista:

```python
numeros_repetidos = [1, 2, 2, 3, 4, 4, 4, 5]
sin_duplicados = list(set(numeros_repetidos))
# Resultado: [1, 2, 3, 4, 5]
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `contar_frecuencias_y_unicos(palabras: list[str]) -> dict`:
Debe devolver un diccionario con dos claves:
1. `"unicas"`: Un `set` o lista con todas las palabras distintas convertidas a minúsculas.
2. `"conteo"`: Un diccionario donde cada clave sea una palabra en minúsculas y su valor sea cuántas veces apareció en la lista.

*Ejemplo:* Para `["Python", "es", "genial", "python", "es", "rapido"]`
- `unicas`: `{"python", "es", "genial", "rapido"}`
- `conteo`: `{"python": 2, "es": 2, "genial": 1, "rapido": 1}`$THEORY$,
    'def contar_frecuencias_y_unicos(palabras: list) -> dict:
    # Retorna {"unicas": set_de_palabras, "conteo": dict_de_frecuencias}
    pass',
    'def contar_frecuencias_y_unicos(palabras: list) -> dict:
    palabras_limpias = [p.lower() for p in palabras]
    unicas = set(palabras_limpias)
    conteo = {}
    for p in palabras_limpias:
        conteo[p] = conteo.get(p, 0) + 1
    return {
        "unicas": unicas,
        "conteo": conteo
    }',
    'import main

entrada = ["Python", "es", "genial", "python", "es", "rapido"]
res = main.contar_frecuencias_y_unicos(entrada)

assert "unicas" in res and "conteo" in res, "El diccionario debe contener ''unicas'' y ''conteo''."
assert len(res["unicas"]) == 4, f"Se esperaban 4 palabras únicas, se obtuvieron {len(res[''unicas''])}."
assert res["conteo"]["python"] == 2, "La palabra ''python'' debe tener frecuencia 2."
assert res["conteo"]["es"] == 2, "La palabra ''es'' debe tener frecuencia 2."
assert res["conteo"]["genial"] == 1, "La palabra ''genial'' debe tener frecuencia 1."
print("✓ Diccionarios de frecuencias y sets validados exitosamente.")'
  );

  -- Lección 2.3 (Código Python: Bucles for, while y range)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m2_id,
    '2.3 Bucles e Iteraciones: for, while y enumerate',
    'Aprende a iterar sobre secuencias, controlar ciclos con condiciones y utilizar enumerate().',
    'python',
    75,
    3,
    $THEORY$# Bucles e Iteraciones en Python

En Python, el bucle `for` no funciona con índices numéricos arcaicos como en C (`for (int i=0; i<n; i++)`). En Python, **el bucle `for` itera directamente sobre los elementos de cualquier colección** (*For-each*).

---

### 1. La Función `range()`:
Genera una secuencia aritmética en memoria de forma ultra eficiente:
```python
for i in range(5):        # Genera: 0, 1, 2, 3, 4
    print(f"Iteración {i}")

for n in range(10, 20, 2): # De 10 a 18 avanzando de 2 en 2
    print(n)
```

---

### 2. La Joya de Python: `enumerate()`:
¿Necesitas tanto el índice como el elemento mientras recorres una lista? Nunca uses `range(len(lista))`; usa la función integrada `enumerate()`:

```python
tareas = ["Diseñar DB", "Crear API", "Escribir Tests"]
for indice, tarea in enumerate(tareas, start=1):
    print(f"{indice}. {tarea}")
# Salida:
# 1. Diseñar DB
# 2. Crear API
# 3. Escribir Tests
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `formatear_ranking(participantes: list[str]) -> list[str]`:
Recibe una lista de nombres ordenados por puntaje y devuelve una nueva lista de cadenas formateadas con el puesto que ocupa cada uno:
`"1. Nombre"`, `"2. Nombre"`, `"3. Nombre"`, etc. Usando `enumerate(..., start=1)`. Si la lista está vacía, devuelve `[]`.$THEORY$,
    'def formatear_ranking(participantes: list[str]) -> list[str]:
    # Utiliza enumerate para generar ["1. Juan", "2. Maria", ...]
    pass',
    'def formatear_ranking(participantes: list[str]) -> list[str]:
    return [f"{pos}. {nombre}" for pos, nombre in enumerate(participantes, start=1)]',
    'import main

participantes = ["Ana", "Beto", "Carla", "David"]
ranking = main.formatear_ranking(participantes)

assert isinstance(ranking, list), "Debe devolver una lista."
assert len(ranking) == 4, "Debe tener 4 elementos."
assert ranking[0] == "1. Ana", "El primer puesto debe ser ''1. Ana''."
assert ranking[1] == "2. Beto", "El segundo puesto debe ser ''2. Beto''."
assert ranking[3] == "4. David", "El cuarto puesto debe ser ''4. David''."
assert main.formatear_ranking([]) == [], "Una lista vacía debe retornar una lista vacía."
print("✓ Generación de ranking con enumerate() verificada con éxito.")'
  );

  -- Lección 2.4 (Código Python: List Comprehensions)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m2_id,
    '2.4 Comprensión de Listas (List Comprehensions)',
    'Escribe código limpio, pythónico y veloz transformando y filtrando colecciones en una sola línea.',
    'python',
    75,
    4,
    $THEORY$# Comprensión de Listas (*List Comprehensions*)

Las *List Comprehensions* son una de las características más queridas por la comunidad de desarrolladores de Python. Permiten transformar y filtrar una lista en una única línea expresiva y altamente optimizada por el intérprete.

---

### Comparación Directa:

**Forma tradicional (4 líneas):**
```python
cuadrados = []
for x in range(10):
    if x % 2 == 0:
        cuadrados.append(x ** 2)
```

**Forma Pythónica con List Comprehension (1 línea):**
```python
cuadrados = [x ** 2 for x in range(10) if x % 2 == 0]
# Resultado: [0, 4, 16, 36, 64]
```

La anatomía de una List Comprehension es:
`[expresion_de_salida for elemento in iterable if condicion_opcional]`

---

### 🎯 Tu Misión en este Reto:
Implementa la función `filtrar_y_transformar_precios(precios: list[float], factor_impuesto: float, precio_minimo: float) -> list[float]`:
Utilizando una **list comprehension**, toma cada precio de la lista `precios`:
1. Solo conserva los precios que sean mayores o iguales a `precio_minimo`.
2. Aplica el impuesto multiplicando el precio por `factor_impuesto`.
3. Redondea cada resultado a 2 decimales usando `round(..., 2)`.

*Ejemplo:* `precios = [10.0, 50.0, 100.0]`, `factor_impuesto = 1.21`, `precio_minimo = 50.0`
- `10.0` queda descartado porque es menor a `50.0`.
- `50.0 * 1.21 = 60.5`
- `100.0 * 1.21 = 121.0`
- Resultado: `[60.5, 121.0]`$THEORY$,
    'def filtrar_y_transformar_precios(precios: list[float], factor_impuesto: float, precio_minimo: float) -> list[float]:
    # Aplica una list comprehension con filtro y transformación
    pass',
    'def filtrar_y_transformar_precios(precios: list[float], factor_impuesto: float, precio_minimo: float) -> list[float]:
    return [round(p * factor_impuesto, 2) for p in precios if p >= precio_minimo]',
    'import main

precios = [10.0, 50.0, 100.0, 5.0, 200.0]
resultado = main.filtrar_y_transformar_precios(precios, 1.21, 50.0)

assert len(resultado) == 3, f"Se esperaban 3 elementos filtrados, se obtuvieron {len(resultado)}."
assert resultado[0] == 60.5, f"50 * 1.21 debe ser 60.5, se obtuvo {resultado[0]}."
assert resultado[1] == 121.0, f"100 * 1.21 debe ser 121.0, se obtuvo {resultado[1]}."
assert resultado[2] == 242.0, f"200 * 1.21 debe ser 242.0, se obtuvo {resultado[2]}."

# Caso lista vacía
assert main.filtrar_y_transformar_precios([], 1.10, 10.0) == [], "Debe manejar listas vacías."
print("✓ List Comprehensions validadas con éxito.")'
  );

  -- ==============================================================================
  -- 📌 MÓDULO 3: FUNCIONES, MODULARIDAD Y MANEJO ROBUSTO DE ERRORES
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Funciones, Modularidad y Manejo Robusto de Errores',
    'Aprende a estructurar código reutilizable: argumentos dinámicos (*args, **kwargs), control de excepciones profesional con try/except y uso de la librería estándar.',
    3
  ) RETURNING id INTO v_m3_id;

  -- Lección 3.1 (Código Python: Funciones y Scope)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m3_id,
    '3.1 Funciones: Retorno Múltiple y Ámbito de Variables',
    'Comprende cómo retornar múltiples valores empaquetados en tuplas y evitar efectos secundarios.',
    'python',
    75,
    1,
    $THEORY$# Funciones en Python y Retorno Múltiple

Una función es un bloque de código reutilizable al que le asignas un nombre con la palabra clave `def`.

---

### 1. El superpoder de Python: Retorno Múltiple

En muchos lenguajes tradicionales, una función solo puede retornar un único valor físico. En Python, puedes separar múltiples valores por coma en el `return`, y Python los empaqueta automáticamente en una **tupla**:

```python
def obtener_min_max(numeros):
    return min(numeros), max(numeros)

# Desempaquetado limpio al llamar a la función:
minimo, maximo = obtener_min_max([10, 5, 80, 3, 45])
print(f"Mínimo: {minimo}, Máximo: {maximo}")
# Mínimo: 3, Máximo: 80
```

---

### 2. Valores por Defecto en Parámetros:

Puedes definir valores predeterminados para parámetros opcionales al final de la lista de argumentos:

```python
def saludar(nombre, prefijo="Hola"):
    return f"{prefijo}, {nombre}!"

saludar("Lucas")           # 'Hola, Lucas!'
saludar("Ana", "Buen día") # 'Buen día, Ana!'
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `calcular_estadisticas_basicas(valores: list[float]) -> tuple[float, float, float]`:
Recibe una lista de números y retorna una tupla con exactamente 3 valores:
`(promedio, valor_minimo, valor_maximo)`
- Si la lista está vacía, debe retornar `(0.0, 0.0, 0.0)`.
- El promedio debe redondearse a 2 decimales.$THEORY$,
    'def calcular_estadisticas_basicas(valores: list[float]) -> tuple[float, float, float]:
    # Retorna (promedio, minimo, maximo)
    pass',
    'def calcular_estadisticas_basicas(valores: list[float]) -> tuple[float, float, float]:
    if not valores:
        return (0.0, 0.0, 0.0)
    promedio = round(sum(valores) / len(valores), 2)
    return (promedio, min(valores), max(valores))',
    'import main

datos = [10.0, 20.0, 30.0, 40.0]
prom, minimo, maximo = main.calcular_estadisticas_basicas(datos)

assert prom == 25.0, f"El promedio esperado era 25.0, se obtuvo {prom}."
assert minimo == 10.0, f"El mínimo esperado era 10.0, se obtuvo {minimo}."
assert maximo == 40.0, f"El máximo esperado era 40.0, se obtuvo {maximo}."

vacio = main.calcular_estadisticas_basicas([])
assert vacio == (0.0, 0.0, 0.0), "Con lista vacía debe retornar (0.0, 0.0, 0.0)."
print("✓ Retorno múltiple y desempaquetado de tuplas validado.")'
  );

  -- Lección 3.2 (Código Python: *args y **kwargs)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m3_id,
    '3.2 Argumentos Flexibles: *args y **kwargs',
    'Aprende a construir funciones que reciben cualquier cantidad de parámetros posicionales y con nombre.',
    'python',
    75,
    2,
    $THEORY$# Argumentos Variables: *args y **kwargs

¿Qué pasa si estás creando una función que debe sumar números, pero no sabes si el usuario enviará 2, 5 o 100 números? Aquí es donde brillan los operadores de desempaquetado:

---

### 1. `*args` (Argumentos Posicionales Ilimitados):
El prefijo `*` empaqueta todos los argumentos posicionales adicionales en una **tupla**:

```python
def sumar_todo(*numeros):
    # 'numeros' llega como una tupla: (1, 2, 3, 4)
    return sum(numeros)

sumar_todo(1, 2)          # 3
sumar_todo(5, 10, 15, 20) # 50
```

---

### 2. `**kwargs` (Keyword Arguments Ilimitados):
El prefijo `**` empaqueta todos los argumentos con nombre adicionales en un **diccionario**:

```python
def crear_perfil(username, **detalles):
    # 'detalles' es un diccionario: {"pais": "Argentina", "nivel": 5}
    print(f"Usuario: {username}")
    for clave, valor in detalles.items():
        print(f"  {clave}: {valor}")

crear_perfil("dev_python", pais="Argentina", nivel=5, activo=True)
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `generar_registro_log(nivel: str, *mensajes: str, **metadatos) -> dict`:
- `nivel`: Nivel de severidad en mayúsculas (ej: `"INFO"`, `"ERROR"`).
- `*mensajes`: Concatena todos los mensajes recibidos separados por un espacio en blanco `" "`.
- `**metadatos`: Cualquier metadato adicional pasado por nombre (ej: `modulo="auth"`, `ip="192.168.1.1"`).
- Devuelve un diccionario con la estructura:
```python
{
    "nivel": nivel.upper(),
    "mensaje": " ".join(mensajes),
    "metadatos": metadatos
}
```$THEORY$,
    'def generar_registro_log(nivel: str, *mensajes: str, **metadatos) -> dict:
    # Construye el registro estructurado
    pass',
    'def generar_registro_log(nivel: str, *mensajes: str, **metadatos) -> dict:
    return {
        "nivel": nivel.upper(),
        "mensaje": " ".join(mensajes),
        "metadatos": metadatos
    }',
    'import main

log = main.generar_registro_log("error", "Fallo", "al", "conectar", "a", "la", "DB", host="db.internal", intentos=3)

assert log["nivel"] == "ERROR", "El nivel debe estar en mayúsculas (ERROR)."
assert log["mensaje"] == "Fallo al conectar a la DB", f"Mensaje incorrecto: {log[''mensaje'']}."
assert log["metadatos"]["host"] == "db.internal", "Falta metadato host."
assert log["metadatos"]["intentos"] == 3, "Falta metadato intentos."
print("✓ Integración de *args y **kwargs validada correctamente.")'
  );

  -- Lección 3.3 (Código Python: Excepciones try/except)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m3_id,
    '3.3 Manejo Seguro de Excepciones: try, except y finally',
    'Protege tu aplicación contra fallos imprevistos y captura errores específicos con elegancia.',
    'python',
    75,
    3,
    $THEORY$# Manejo de Excepciones en Python

En software profesional, las cosas fallan: conexiones a internet que se cortan, archivos que no existen o usuarios que escriben letras donde se esperaba un número.

Si no manejas estos casos, Python interrumpe abruptamente el programa arrojando un **Traceback**.

---

### La Estructura Completa:

```python
try:
    # Código riesgoso que podría lanzar un error
    resultado = 100 / int(entrada_usuario)
except ValueError:
    # Se ejecuta si entrada_usuario no era un número válido
    print("Por favor escribe un número entero.")
except ZeroDivisionError:
    # Se ejecuta si intentaron dividir por cero
    print("No es posible dividir por cero.")
except Exception as e:
    # Atrapa cualquier otro error imprevisto
    print(f"Ocurrió un error inesperado: {e}")
else:
    # Se ejecuta SOLAMENTE si el bloque try NO arrojó ningún error
    print(f"Cálculo exitoso: {resultado}")
finally:
    # Se ejecuta SIEMPRE, haya fallado o no (ideal para cerrar archivos o conexiones)
    print("Operación finalizada.")
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función `convertir_y_dividir(dividendo_str: str, divisor_str: str) -> dict`:
- Intenta convertir ambos argumentos a `float` y calcular `dividendo / divisor`.
- Si tiene éxito: retorna `{"exito": True, "resultado": round(division, 2), "error": None}`.
- Si falla por conversión de texto (`ValueError`): retorna `{"exito": False, "resultado": None, "error": "Formato numérico inválido"}`.
- Si falla por división por cero (`ZeroDivisionError`): retorna `{"exito": False, "resultado": None, "error": "División por cero no permitida"}`.$THEORY$,
    'def convertir_y_dividir(dividendo_str: str, divisor_str: str) -> dict:
    # Implementa el bloque try/except capturando ValueError y ZeroDivisionError
    pass',
    'def convertir_y_dividir(dividendo_str: str, divisor_str: str) -> dict:
    try:
        a = float(dividendo_str)
        b = float(divisor_str)
        return {"exito": True, "resultado": round(a / b, 2), "error": None}
    except ValueError:
        return {"exito": False, "resultado": None, "error": "Formato numérico inválido"}
    except ZeroDivisionError:
        return {"exito": False, "resultado": None, "error": "División por cero no permitida"}',
    'import main

ok = main.convertir_y_dividir("10", "2")
assert ok["exito"] is True and ok["resultado"] == 5.0, "10 / 2 debe dar 5.0 con éxito True."

zero = main.convertir_y_dividir("10", "0")
assert zero["exito"] is False and zero["error"] == "División por cero no permitida", "Debe capturar división por cero."

bad = main.convertir_y_dividir("diez", "dos")
assert bad["exito"] is False and bad["error"] == "Formato numérico inválido", "Debe capturar error de formato."
print("✓ Captura granular de excepciones verificada con éxito.")'
  );

  -- Lección 3.4 (Quiz: Librería Estándar)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code
  ) VALUES (
    v_m3_id,
    '3.4 La Librería Estándar: "Baterías Incluidas"',
    'Aprende a importar módulos de la potente biblioteca estándar de Python sin instalar nada externo.',
    'quiz',
    50,
    4,
    $THEORY$# Las "Baterías Incluidas" de Python

Uno de los lemas históricos de Python es que viene con **"baterías incluidas"**: su biblioteca estándar posee cientos de módulos listos para usar sin necesidad de instalar librerías de terceros con `pip`.

---

### Módulos Esenciales:

1. **`math`:** Funciones matemáticas avanzadas (`math.sqrt(16)` para raíz cuadrada, `math.pi`, `math.ceil()`).
2. **`random`:** Generación de números aleatorios y selección de elementos (`random.randint(1, 6)`, `random.choice(lista)`).
3. **`datetime`:** Manejo riguroso de fechas y horas (`datetime.datetime.now()`, `datetime.timedelta(days=7)`).
4. **`json`:** Serialización y deserialización de datos JSON (`json.loads()` y `json.dumps()`).
5. **`pathlib`:** Manipulación moderna y orientada a objetos de rutas de archivos en el sistema operativo (`Path("carpeta") / "archivo.txt"`).$THEORY$,
    '[{"id":"q1","question":"¿Qué módulo estándar de Python debes importar para manipular fechas y horas del sistema?","options":["timekeeper","datetime","clock","dates"],"correctIndex":1,"explanation":"El módulo datetime es el estándar en Python para fechas, horas y cálculos de intervalos temporales."},{"id":"q2","question":"¿Qué función del módulo json se utiliza para convertir un string en formato JSON a un diccionario nativo de Python?","options":["json.stringify()","json.loads()","json.to_dict()","json.parse()"],"correctIndex":1,"explanation":"json.loads() (\"load string\") toma una cadena de texto JSON y la convierte en estructuras de datos de Python (dict, list, etc.)."},{"id":"q3","question":"¿Cuál es la forma recomendada y moderna en Python 3 para manejar rutas de archivos entre Windows y Linux de forma portable?","options":["pathlib.Path","os.strings","filemanager","sys.routes"],"correctIndex":0,"explanation":"pathlib ofrece una interfaz orientada a objetos limpia y portable para gestionar rutas sin preocuparse por barras diagonales (\\ o /)."}]'
  );

  -- ==============================================================================
  -- 📌 MÓDULO 4: PROGRAMACIÓN ORIENTADA A OBJETOS (POO) EN PYTHON
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 4: Programación Orientada a Objetos (POO) en Python',
    'Modela el mundo real con clases e instancias: el rol de self, métodos mágicos (dunder methods), encapsulamiento con @property y jerarquías de herencia.',
    3
  ) RETURNING id INTO v_m4_id;

  -- Lección 4.1 (Código Python: Clases, __init__ y self)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m4_id,
    '4.1 Clases, Objetos y el Constructor __init__',
    'Aprende a diseñar planos de objetos con atributos de instancia y métodos asociados.',
    'python',
    75,
    1,
    $THEORY$# Programación Orientada a Objetos: Clases y self

La **Programación Orientada a Objetos (POO)** es un paradigma que nos permite agrupar datos (atributos) y comportamientos (métodos) en una única entidad llamada **Objeto**.

- **Clase (`class`):** El plano arquitectónico o molde.
- **Objeto / Instancia:** La casa real construida a partir de ese plano.

---

### ¿Qué diablos es `self`?
En Python, cada método dentro de una clase recibe automáticamente como primer parámetro la **instancia concreta sobre la que se está ejecutando**. Por convención universal, ese primer parámetro se llama siempre **`self`**.

```python
class CuentaBancaria:
    # El método constructor que se ejecuta al crear la cuenta:
    def __init__(self, titular: str, saldo_inicial: float = 0.0):
        self.titular = titular      # Atributo de instancia
        self.saldo = saldo_inicial  # Atributo de instancia

    def depositar(self, monto: float):
        if monto > 0:
            self.saldo += monto
            return True
        return False
```

---

### 🎯 Tu Misión en este Reto:
Crea la clase `CuentaBancaria`:
- `__init__(self, titular: str, saldo_inicial: float = 0.0)`: Guarda `titular` y `saldo`.
- `depositar(self, monto: float) -> bool`: Si `monto > 0`, suma al saldo y retorna `True`; si no, retorna `False`.
- `retirar(self, monto: float) -> bool`: Si `monto > 0` y `self.saldo >= monto`, descuenta el monto y retorna `True`; en caso contrario retorna `False`.$THEORY$,
    'class CuentaBancaria:
    # Define __init__, depositar y retirar
    pass',
    'class CuentaBancaria:
    def __init__(self, titular: str, saldo_inicial: float = 0.0):
        self.titular = titular
        self.saldo = float(saldo_inicial)

    def depositar(self, monto: float) -> bool:
        if monto > 0:
            self.saldo += monto
            return True
        return False

    def retirar(self, monto: float) -> bool:
        if monto > 0 and self.saldo >= monto:
            self.saldo -= monto
            return True
        return False',
    'import main

cuenta = main.CuentaBancaria("Martín Gómez", 500.0)
assert cuenta.titular == "Martín Gómez", "El titular debe coincidir con el constructor."
assert cuenta.saldo == 500.0, "El saldo inicial debe ser 500.0."

# Depósito válido
assert cuenta.depositar(200.0) is True, "El depósito de 200 debe ser exitoso."
assert cuenta.saldo == 700.0, "El saldo debe ser 700.0 tras el depósito."

# Retiro válido
assert cuenta.retirar(300.0) is True, "El retiro de 300 debe ser exitoso."
assert cuenta.saldo == 400.0, "El saldo debe ser 400.0 tras el retiro."

# Retiro inválido por fondos insuficientes
assert cuenta.retirar(1000.0) is False, "No debe permitir retirar más del saldo disponible."
assert cuenta.saldo == 400.0, "El saldo no debe cambiar tras un retiro fallido."
print("✓ Clase y métodos de CuentaBancaria validados con éxito.")'
  );

  -- Lección 4.2 (Código Python: Dunder Methods)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m4_id,
    '4.2 Métodos Mágicos (Dunder Methods): __str__ y __len__',
    'Personaliza cómo se representan y miden tus objetos usando métodos especiales con doble guión bajo.',
    'python',
    75,
    2,
    $THEORY$# Métodos Mágicos (*Dunder Methods*)

En Python, los métodos que empiezan y terminan con doble guión bajo (`__`) se conocen como **Dunder Methods** (*Double Under*). El intérprete los invoca automáticamente ante ciertas operaciones estándar.

---

### Los más utilizados:

1. **`__str__(self)`:** Define qué texto legible para humanos se muestra cuando haces `print(objeto)` o `str(objeto)`.
2. **`__repr__(self)`:** Representación formal e inequívoca del objeto (útil para depuración).
3. **`__len__(self)`:** Permite que tu objeto responda a la función universal `len(objeto)`.
4. **`__eq__(self, otro)`:** Permite comparar si dos objetos son iguales con `objeto1 == objeto2`.

```python
class Carrito:
    def __init__(self):
        self.productos = []

    def __len__(self):
        return len(self.productos)

    def __str__(self):
        return f"Carrito con {len(self)} productos"
```

---

### 🎯 Tu Misión en este Reto:
Crea la clase `Biblioteca`:
- `__init__(self, nombre: str)`: Inicializa `self.nombre = nombre` y una lista vacía `self.libros = []`.
- `agregar_libro(self, titulo: str)`: Agrega el título a la lista `self.libros`.
- `__len__(self) -> int`: Retorna la cantidad de libros que contiene la biblioteca.
- `__str__(self) -> str`: Retorna el formato: `"Biblioteca [nombre] con [cantidad] libros"` (ej: `"Biblioteca Central con 3 libros"`).$THEORY$,
    'class Biblioteca:
    # Implementa __init__, agregar_libro, __len__ y __str__
    pass',
    'class Biblioteca:
    def __init__(self, nombre: str):
        self.nombre = nombre
        self.libros = []

    def agregar_libro(self, titulo: str):
        self.libros.append(titulo)

    def __len__(self) -> int:
        return len(self.libros)

    def __str__(self) -> str:
        return f"Biblioteca {self.nombre} con {len(self)} libros"',
    'import main

biblio = main.Biblioteca("Nacional")
assert len(biblio) == 0, "Una biblioteca nueva debe tener longitud 0."
assert str(biblio) == "Biblioteca Nacional con 0 libros", f"Representación str incorrecta: {str(biblio)}."

biblio.agregar_libro("Don Quijote")
biblio.agregar_libro("Cien Años de Soledad")

assert len(biblio) == 2, "La longitud debe ser 2 tras agregar 2 libros."
assert str(biblio) == "Biblioteca Nacional con 2 libros", "Representación str con 2 libros incorrecta."
print("✓ Métodos mágicos __len__ y __str__ validados con éxito.")'
  );

  -- Lección 4.3 (Código Python: @property y Encapsulamiento)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m4_id,
    '4.3 Encapsulamiento Pythónico con @property',
    'Valida datos de manera elegante sin necesidad de getters y setters pesados al estilo Java.',
    'python',
    75,
    3,
    $THEORY$# Encapsulamiento Pythónico: El decorador @property

En lenguajes como Java o C++, para proteger un atributo se vuelve privado y se crean métodos `getPrecio()` y `setPrecio()`. En Python, este estilo se considera poco idiomático.

Python ofrece el decorador **`@property`**, que permite acceder a un método **como si fuera un atributo directo**, pero ejecutando validaciones de fondo:

```python
class Termostato:
    def __init__(self, temp: float):
        self._temperatura = temp  # Guión bajo indica atributo privado por convención

    @property
    def temperatura(self) -> float:
        return self._temperatura

    @temperatura.setter
    def temperatura(self, nuevo_valor: float):
        if nuevo_valor < -273.15:
            raise ValueError("No puede existir temperatura por debajo del cero absoluto.")
        self._temperatura = nuevo_valor

t = Termostato(20.0)
t.temperatura = 25.0    # Ejecuta el setter automáticamente
print(t.temperatura)    # 25.0
```

---

### 🎯 Tu Misión en este Reto:
Crea la clase `Producto`:
- `__init__(self, nombre: str, precio: float)`: Asigna `self.nombre = nombre` y utiliza la propiedad `precio` para asignarlo.
- Crea la propiedad `@property precio(self) -> float`: Retorna el precio interno `_precio`.
- Crea el setter `@precio.setter`: Si el nuevo precio es menor o igual a 0, lanza `ValueError("El precio debe ser mayor a cero.")`. Si es válido, guarda en `self._precio`.$THEORY$,
    'class Producto:
    # Implementa __init__, @property precio y @precio.setter
    pass',
    'class Producto:
    def __init__(self, nombre: str, precio: float):
        self.nombre = nombre
        self.precio = precio

    @property
    def precio(self) -> float:
        return self._precio

    @precio.setter
    def precio(self, valor: float):
        if valor <= 0:
            raise ValueError("El precio debe ser mayor a cero.")
        self._precio = float(valor)',
    'import main

prod = main.Producto("Café de Especialidad", 15.5)
assert prod.nombre == "Café de Especialidad"
assert prod.precio == 15.5

# Actualizar precio válido
prod.precio = 18.0
assert prod.precio == 18.0

# Validar que rechaza precios inválidos con ValueError
try:
    prod.precio = -5.0
    assert False, "Debió arrojar ValueError para precio negativo."
except ValueError as e:
    assert "El precio debe ser mayor a cero" in str(e)

try:
    prod.precio = 0
    assert False, "Debió arrojar ValueError para precio cero."
except ValueError as e:
    assert "El precio debe ser mayor a cero" in str(e)

print("✓ Encapsulamiento y validación con @property y setter exitosos.")'
  );

  -- Lección 4.4 (Código Python: Herencia y super())
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m4_id,
    '4.4 Herencia, Polimorfismo y super()',
    'Reutiliza lógica común extendiendo clases base y aprovechando la delegación con super().',
    'python',
    75,
    4,
    $THEORY$# Herencia y Polimorfismo en Python

La **Herencia** permite crear una nueva clase (subclase o clase hija) que hereda todos los atributos y métodos de una clase existente (superclase o clase padre).

---

### La Función `super()`:
Permite invocar el constructor o métodos de la clase padre sin duplicar código:

```python
class Empleado:
    def __init__(self, nombre: str, salario_base: float):
        self.nombre = nombre
        self.salario_base = salario_base

    def calcular_pago(self) -> float:
        return self.salario_base

class Gerente(Empleado):
    def __init__(self, nombre: str, salario_base: float, bono: float):
        super().__init__(nombre, salario_base)  # Invoca al padre
        self.bono = bono

    def calcular_pago(self) -> float:
        return super().calcular_pago() + self.bono  # Polimorfismo
```

---

### 🎯 Tu Misión en este Reto:
1. Crea la clase `Vehiculo`:
   - `__init__(self, marca: str, modelo: str)`
   - `describir(self) -> str`: Devuelve `f"{self.marca} {self.modelo}"`
2. Crea la subclase `VehiculoElectrico(Vehiculo)`:
   - `__init__(self, marca: str, modelo: str, capacidad_bateria_kwh: float)`: Llama a `super().__init__(marca, modelo)` y almacena `self.capacidad_bateria_kwh = capacidad_bateria_kwh`.
   - Sobrescribe `describir(self) -> str`: Devuelve `f"{super().describir()} (Batería: {self.capacidad_bateria_kwh} kWh)"`.$THEORY$,
    'class Vehiculo:
    pass

class VehiculoElectrico(Vehiculo):
    pass',
    'class Vehiculo:
    def __init__(self, marca: str, modelo: str):
        self.marca = marca
        self.modelo = modelo

    def describir(self) -> str:
        return f"{self.marca} {self.modelo}"

class VehiculoElectrico(Vehiculo):
    def __init__(self, marca: str, modelo: str, capacidad_bateria_kwh: float):
        super().__init__(marca, modelo)
        self.capacidad_bateria_kwh = float(capacidad_bateria_kwh)

    def describir(self) -> str:
        return f"{super().describir()} (Batería: {self.capacidad_bateria_kwh} kWh)"',
    'import main

v = main.Vehiculo("Toyota", "Corolla")
assert v.describir() == "Toyota Corolla", "El método describir de Vehiculo es incorrecto."

ve = main.VehiculoElectrico("Tesla", "Model 3", 75.0)
assert isinstance(ve, main.Vehiculo), "VehiculoElectrico debe ser una instancia de Vehiculo."
assert ve.describir() == "Tesla Model 3 (Batería: 75.0 kWh)", f"Descripción eléctrica incorrecta: {ve.describir()}."
print("✓ Herencia y delegación con super() validadas exitosamente.")'
  );

  -- ==============================================================================
  -- 📌 MÓDULO 5: PYTHON MODERNO Y AVANZADO (PYTHON 3.10+)
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 5: Python Moderno y Avanzado (Python 3.10+)',
    'Escribe código con el estándar industrial contemporáneo: anotaciones de tipos estrictas, dataclasses, pattern matching estructural (match/case), generadores y concurrencia con asyncio.',
    3
  ) RETURNING id INTO v_m5_id;

  -- Lección 5.1 (Quiz: Type Hints)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code
  ) VALUES (
    v_m5_id,
    '5.1 Type Hints Estáticos y Anotaciones Modernas',
    'Comprende cómo los Type Hints mejoran el autocompletado, la documentación y previenen bugs en proyectos grandes.',
    'quiz',
    50,
    1,
    $THEORY$# Type Hints y Tipado Estático en Python Moderno

Aunque Python sigue siendo un lenguaje dinámico en tiempo de ejecución, desde Python 3.5 en adelante incorporó **Type Hints** (Anotaciones de Tipos), que se han convertido en el estándar indiscutible en empresas de tecnología.

---

### ¿Por qué todo el mundo usa Type Hints hoy?
1. **Autocompletado infalible en tu editor (VS Code, Cursor, PyCharm).**
2. **Documentación viva sin comentarios obsoletos.**
3. **Análisis estático de errores con herramientas como Mypy, Pyright o Pydantic.**

```python
# Sintaxis moderna (Python 3.10+ con operador | para uniones):
def buscar_usuario(user_id: int) -> dict | None:
    if user_id > 0:
        return {"id": user_id, "nombre": "Sofía"}
    return None
```$THEORY$,
    '[{"id":"q1","question":"¿Afectan las anotaciones de tipos (Type Hints) el rendimiento de ejecución en tiempo de ejecución de Python puro?","options":["Sí, hacen que Python corra el doble de lento","No, el intérprete las ignora en ejecución; sirven para análisis estático, herramientas y documentación","Sí, compilan el código a C++ automáticamente","Hacen obligatorio el uso de Java"],"correctIndex":1,"explanation":"Los Type Hints no alteran la ejecución en runtime; su poder radica en el análisis estático (Mypy/Pydantic) y el soporte en IDEs."},{"id":"q2","question":"A partir de Python 3.10, ¿cómo se expresa de forma concisa que una variable puede ser int o None?","options":["int | None","int or None","Union[int, null]","Nullable<int>"],"correctIndex":0,"explanation":"Python 3.10 introdujo el operador pipe | para uniones de tipos, permitiendo escribir int | None de forma limpia."},{"id":"q3","question":"¿Qué librería moderna del ecosistema Python utiliza intensivamente Type Hints para validación de esquemas y parsing de datos?","options":["Pydantic","jQuery","TensorFlow 1","Lodash"],"correctIndex":0,"explanation":"Pydantic (la base de frameworks como FastAPI) utiliza Type Hints para validar y transformar datos en tiempo real."}]'
  );

  -- Lección 5.2 (Código Python: Dataclasses)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m5_id,
    '5.2 Clases de Datos Modernas: @dataclass',
    'Genera clases limpias con constructor, representación y comparación automática en una fracción de código.',
    'python',
    75,
    2,
    $THEORY$# Clases de Datos Modernas: @dataclass

¿Cansado de escribir clases aburridas donde solo repites `self.a = a`, `self.b = b` en el `__init__`?

Desde Python 3.7 existe el decorador **`@dataclass`** (en el módulo estándar `dataclasses`). Al colocarlo sobre una clase con anotaciones de tipo, Python genera automáticamente por ti:
- El constructor `__init__()`.
- La representación legible `__repr__()`.
- La comparación de igualdad por valor `__eq__()`.

```python
from dataclasses import dataclass

@dataclass
class Coordenada:
    latitud: float
    longitud: float
    etiqueta: str = "Punto de Interés"

c1 = Coordenada(-34.6037, -58.3816, "Obelisco")
c2 = Coordenada(-34.6037, -58.3816, "Obelisco")
print(c1)        # Coordenada(latitud=-34.6037, longitud=-58.3816, etiqueta='Obelisco')
print(c1 == c2)  # True (¡compara sus valores automáticamente!)
```

---

### 🎯 Tu Misión en este Reto:
Define una `@dataclass` llamada `ItemPedido`:
- `codigo: str`
- `cantidad: int`
- `precio_unitario: float`
- Agrega un método regular `subtotal(self) -> float` que retorne `round(self.cantidad * self.precio_unitario, 2)`.
- Si `cantidad <= 0` o `precio_unitario < 0`, el método `subtotal()` debe arrojar `ValueError("Valores numéricos inválidos")`.$THEORY$,
    'from dataclasses import dataclass

# Implementa la @dataclass ItemPedido
',
    'from dataclasses import dataclass

@dataclass
class ItemPedido:
    codigo: str
    cantidad: int
    precio_unitario: float

    def subtotal(self) -> float:
        if self.cantidad <= 0 or self.precio_unitario < 0:
            raise ValueError("Valores numéricos inválidos")
        return round(self.cantidad * self.precio_unitario, 2)',
    'import main

item1 = main.ItemPedido(codigo="A-101", cantidad=3, precio_unitario=25.50)
assert item1.codigo == "A-101"
assert item1.cantidad == 3
assert item1.precio_unitario == 25.50
assert item1.subtotal() == 76.50, f"Subtotal esperado 76.50, obtenido {item1.subtotal()}."

# Prueba de __repr__ automático
assert "A-101" in repr(item1), "dataclass debe generar __repr__ automáticamente."

# Prueba de __eq__ automático
item2 = main.ItemPedido(codigo="A-101", cantidad=3, precio_unitario=25.50)
assert item1 == item2, "Dos dataclasses con mismos valores deben ser iguales (==)."

# Prueba de validación en subtotal
item_invalido = main.ItemPedido(codigo="B-202", cantidad=-1, precio_unitario=10.0)
try:
    item_invalido.subtotal()
    assert False, "Debió arrojar ValueError por cantidad negativa."
except ValueError:
    pass

print("✓ @dataclass ItemPedido y método subtotal validados.")'
  );

  -- Lección 5.3 (Código Python: Pattern Matching match/case)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m5_id,
    '5.3 Pattern Matching Estructural: match / case',
    'Aprende a reemplazar cadenas complejas de if/elif con la característica más potente de Python 3.10.',
    'python',
    75,
    3,
    $THEORY$# Pattern Matching Estructural (`match / case`)

Introducido en **Python 3.10** (*PEP 634*), el **Pattern Matching Estructural** no es un simple `switch` como en otros lenguajes: permite descomponer y analizar la forma, tipos y contenido de los datos.

```python
def procesar_comando(comando: dict) -> str:
    match comando:
        case {"accion": "mover", "direccion": ("norte" | "sur" | "este" | "oeste") as d}:
            return f"Moviéndose hacia el {d}"
        case {"accion": "atacar", "poder": p} if p > 50:
            return f"¡Ataque crítico de poder {p}!"
        case {"accion": "atacar", "poder": p}:
            return f"Ataque regular de poder {p}"
        case _:
            return "Comando no reconocido"
```

- `_` actúa como caso por defecto (*wildcard*).
- Puedes usar condiciones con `if` (*guards*).

---

### 🎯 Tu Misión en este Reto:
Implementa la función `procesar_respuesta_http(respuesta: dict) -> str` usando `match / case`:
- `{"status": 200, "data": datos}` -> retorna `f"Éxito: {datos}"`
- `{"status": 404}` -> retorna `"Error: Recurso no encontrado"`
- `{"status": 500, "mensaje": msg}` -> retorna `f"Error del servidor: {msg}"`
- Para cualquier otra estructura -> retorna `"Respuesta desconocida"`$THEORY$,
    'def procesar_respuesta_http(respuesta: dict) -> str:
    # Utiliza match / case para evaluar la estructura del diccionario
    pass',
    'def procesar_respuesta_http(respuesta: dict) -> str:
    match respuesta:
        case {"status": 200, "data": datos}:
            return f"Éxito: {datos}"
        case {"status": 404}:
            return "Error: Recurso no encontrado"
        case {"status": 500, "mensaje": msg}:
            return f"Error del servidor: {msg}"
        case _:
            return "Respuesta desconocida"',
    'import main

assert main.procesar_respuesta_http({"status": 200, "data": "Perfil de usuario"}) == "Éxito: Perfil de usuario"
assert main.procesar_respuesta_http({"status": 404}) == "Error: Recurso no encontrado"
assert main.procesar_respuesta_http({"status": 500, "mensaje": "Base de datos desconectada"}) == "Error del servidor: Base de datos desconectada"
assert main.procesar_respuesta_http({"status": 401, "extra": 123}) == "Respuesta desconocida"
print("✓ Pattern Matching estructural match/case validado con éxito.")'
  );

  -- Lección 5.4 (Código Python: Generadores y Context Managers)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m5_id,
    '5.4 Generadores con yield y Context Managers con with',
    'Aprende a procesar millones de datos sin desbordar la memoria RAM usando generadores perezosos.',
    'python',
    75,
    4,
    $THEORY$# Generadores (`yield`) y Context Managers (`with`)

### 1. Generadores: Memoria Eficiente (*Lazy Evaluation*)
Si creas una lista con 10 millones de números (`[x for x in range(10_000_000)]`), tu computadora consumirá cientos de megabytes de memoria RAM.

Un **Generador** no calcula todos los datos a la vez; produce el siguiente valor **únicamente cuando se le solicita** mediante la palabra clave **`yield`**:

```python
def contador_infinito(inicio=0):
    n = inicio
    while True:
        yield n
        n += 1

gen = contador_infinito(1)
print(next(gen))  # 1
print(next(gen))  # 2
# ¡Consume memoria casi nula!
```

---

### 2. Context Managers (`with`):
Garantizan la liberación de recursos (cerrar archivos, desconectar sockets, liberar bloqueos) automáticamente al salir del bloque:

```python
# Abre el archivo y lo cierra automáticamente incluso si ocurre un error adentro
with open("datos.txt", "w") as f:
    f.write("Hola")
```

---

### 🎯 Tu Misión en este Reto:
Implementa la función generadora `generar_pares_hasta(limite: int)`:
- Es un generador (`yield`) que produce todos los números pares desde `0` hasta `limite` (inclusive).
- *Ejemplo:* Para `limite = 6`, al iterar debe producir sucesivamente: `0, 2, 4, 6`.$THEORY$,
    'def generar_pares_hasta(limite: int):
    # Utiliza un bucle y yield para generar los números pares
    pass',
    'def generar_pares_hasta(limite: int):
    for i in range(0, limite + 1, 2):
        yield i',
    'import main
import types

gen = main.generar_pares_hasta(6)
assert isinstance(gen, types.GeneratorType), "La función debe ser un generador (debe utilizar yield)."

valores = list(gen)
assert valores == [0, 2, 4, 6], f"Se esperaba [0, 2, 4, 6], se obtuvo {valores}."

gen2 = main.generar_pares_hasta(7)
assert list(gen2) == [0, 2, 4, 6], "Para límite 7 los pares deben llegar hasta 6."
print("✓ Generador con yield validado con éxito.")'
  );

  -- ==============================================================================
  -- 📌 MÓDULO 6: PROYECTO INTEGRADOR MULTI-ARCHIVO Y CERTIFICACIÓN
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 6: Proyecto Integrador Multi-Archivo y Certificación',
    'Aplica todo lo aprendido en un proyecto de software real con arquitectura modular de 3 archivos en simultáneo (models.py, services.py y main.py), culminando con tu Certificación Oficial.',
    3
  ) RETURNING id INTO v_m6_id;

  -- Lección 6.1 (Proyecto Integrador Multi-Archivo en el IDE)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_m6_id,
    '6.1 Proyecto Integrador: Sistema Modular de Pedidos y Almacén',
    'Construye un sistema profesional coordinando 3 archivos en simultáneo: models.py, services.py y main.py.',
    'python',
    150,
    1,
    $THEORY$# Proyecto Integrador Multi-Archivo: Sistema de Almacén y Pedidos

En el mundo profesional nunca programas todo en un solo archivo gigante de 5000 líneas. Los sistemas reales se dividen en **módulos independientes y desacoplados**:

```
mi_sistema/
├── models.py     # Define las estructuras de datos (Producto, Pedido)
├── services.py   # Define la lógica de negocio (AlmacenService, stock, cobro)
└── main.py       # Punto de entrada que orquesta la aplicación
```

---

### 📂 Estructura de Archivos en tu Editor:

En el panel superior del editor puedes navegar entre los 3 archivos del proyecto:

1. **`models.py`**:
   - Una excepción personalizada `StockInsuficienteError(Exception)`.
   - Una `@dataclass` llamada `Producto` con: `id: str`, `nombre: str`, `precio: float`, `stock: int`.
   - Una `@dataclass` llamada `ItemPedido` con: `producto: Producto`, `cantidad: int`.

2. **`services.py`**:
   - La clase `AlmacenService`:
     - `__init__(self)`: Inicializa un diccionario `self.catalogo = {}`.
     - `agregar_producto(self, producto: Producto)`: Registra el producto en el catálogo por su `id`.
     - `buscar_producto(self, producto_id: str) -> Producto | None`: Retorna el producto o `None`.
     - `procesar_pedido(self, items: list[ItemPedido], porcentaje_descuento: float = 0.0) -> float`:
       - Verifica que haya suficiente stock para cada item. Si alguno no alcanza, lanza `StockInsuficienteError(f"Stock insuficiente para {item.producto.nombre}")`.
       - Descuenta el stock de cada producto.
       - Calcula el costo total sumando `item.producto.precio * item.cantidad`.
       - Aplica el descuento si existe y devuelve el total final redondeado a 2 decimales.

3. **`main.py`**:
   - Importa las clases de `models` y `services`.
   - Define la función `ejecutar_sistema_demo() -> dict` que instancia un almacén, añade 2 productos ("Notebook", "Mouse"), procesa un pedido de prueba y retorna un resumen con los totales.$THEORY$,
    $CODE${"activeFile":"models.py","files":{"models.py":"from dataclasses import dataclass\n\nclass StockInsuficienteError(Exception):\n    \"\"\"Excepción lanzada cuando no hay stock suficiente.\"\"\"\n    pass\n\n@dataclass\nclass Producto:\n    id: str\n    nombre: str\n    precio: float\n    stock: int\n\n@dataclass\nclass ItemPedido:\n    producto: Producto\n    cantidad: int\n","services.py":"from models import Producto, ItemPedido, StockInsuficienteError\n\nclass AlmacenService:\n    def __init__(self):\n        self.catalogo: dict[str, Producto] = {}\n\n    def agregar_producto(self, producto: Producto) -> None:\n        # Registra el producto en el catálogo usando su id\n        self.catalogo[producto.id] = producto\n\n    def buscar_producto(self, producto_id: str) -> Producto | None:\n        # Busca el producto por id\n        return self.catalogo.get(producto_id)\n\n    def procesar_pedido(self, items: list[ItemPedido], porcentaje_descuento: float = 0.0) -> float:\n        # 1. Verificar que haya stock suficiente para cada item\n        #    Si no alcanza, lanzar StockInsuficienteError\n        # 2. Descontar el stock de cada producto\n        # 3. Calcular el total sumando (precio * cantidad) de cada item\n        # 4. Aplicar porcentaje_descuento y retornar round(total, 2)\n        pass\n","main.py":"from models import Producto, ItemPedido, StockInsuficienteError\nfrom services import AlmacenService\n\ndef ejecutar_sistema_demo() -> dict:\n    almacen = AlmacenService()\n    \n    p1 = Producto(id=\"PROD-1\", nombre=\"Notebook Gamer\", precio=1200.0, stock=5)\n    p2 = Producto(id=\"PROD-2\", nombre=\"Mouse Inalámbrico\", precio=30.0, stock=10)\n    \n    almacen.agregar_producto(p1)\n    almacen.agregar_producto(p2)\n    \n    pedido = [\n        ItemPedido(producto=p1, cantidad=1),\n        ItemPedido(producto=p2, cantidad=2)\n    ]\n    \n    total = almacen.procesar_pedido(pedido, porcentaje_descuento=10.0)\n    \n    return {\n        \"almacen\": almacen,\n        \"total_pagado\": total,\n        \"stock_restante_p1\": p1.stock,\n        \"stock_restante_p2\": p2.stock\n    }\n\nif __name__ == \"__main__\":\n    res = ejecutar_sistema_demo()\n    print(\"Demo completada:\", res)\n"}}$CODE$,
    $CODE${"activeFile":"models.py","files":{"models.py":"from dataclasses import dataclass\n\nclass StockInsuficienteError(Exception):\n    \"\"\"Excepción lanzada cuando no hay stock suficiente.\"\"\"\n    pass\n\n@dataclass\nclass Producto:\n    id: str\n    nombre: str\n    precio: float\n    stock: int\n\n@dataclass\nclass ItemPedido:\n    producto: Producto\n    cantidad: int\n","services.py":"from models import Producto, ItemPedido, StockInsuficienteError\n\nclass AlmacenService:\n    def __init__(self):\n        self.catalogo: dict[str, Producto] = {}\n\n    def agregar_producto(self, producto: Producto) -> None:\n        self.catalogo[producto.id] = producto\n\n    def buscar_producto(self, producto_id: str) -> Producto | None:\n        return self.catalogo.get(producto_id)\n\n    def procesar_pedido(self, items: list[ItemPedido], porcentaje_descuento: float = 0.0) -> float:\n        for item in items:\n            if item.producto.stock < item.cantidad:\n                raise StockInsuficienteError(f\"Stock insuficiente para {item.producto.nombre}\")\n        \n        subtotal = 0.0\n        for item in items:\n            item.producto.stock -= item.cantidad\n            subtotal += item.producto.precio * item.cantidad\n            \n        descuento = subtotal * (porcentaje_descuento / 100.0)\n        return round(subtotal - descuento, 2)\n","main.py":"from models import Producto, ItemPedido, StockInsuficienteError\nfrom services import AlmacenService\n\ndef ejecutar_sistema_demo() -> dict:\n    almacen = AlmacenService()\n    \n    p1 = Producto(id=\"PROD-1\", nombre=\"Notebook Gamer\", precio=1200.0, stock=5)\n    p2 = Producto(id=\"PROD-2\", nombre=\"Mouse Inalámbrico\", precio=30.0, stock=10)\n    \n    almacen.agregar_producto(p1)\n    almacen.agregar_producto(p2)\n    \n    pedido = [\n        ItemPedido(producto=p1, cantidad=1),\n        ItemPedido(producto=p2, cantidad=2)\n    ]\n    \n    total = almacen.procesar_pedido(pedido, porcentaje_descuento=10.0)\n    \n    return {\n        \"almacen\": almacen,\n        \"total_pagado\": total,\n        \"stock_restante_p1\": p1.stock,\n        \"stock_restante_p2\": p2.stock\n    }\n\nif __name__ == \"__main__\":\n    res = ejecutar_sistema_demo()\n    print(\"Demo completada:\", res)\n"}}$CODE$,
    'import models
import services
import main

# Test 1: Verificar existencia y estructura de models.py
assert hasattr(models, "Producto"), "models.py debe definir la clase Producto."
assert hasattr(models, "ItemPedido"), "models.py debe definir la clase ItemPedido."
assert hasattr(models, "StockInsuficienteError"), "models.py debe definir StockInsuficienteError."

p = models.Producto(id="T-1", nombre="Teclado", precio=50.0, stock=10)
item = models.ItemPedido(producto=p, cantidad=2)
assert item.producto.nombre == "Teclado", "La clase ItemPedido debe referenciar al Producto."

# Test 2: Verificar lógica de AlmacenService en services.py
srv = services.AlmacenService()
srv.agregar_producto(p)
assert srv.buscar_producto("T-1") == p, "buscar_producto debe encontrar el producto por su id."
assert srv.buscar_producto("INEXISTENTE") is None, "buscar_producto con id no registrado debe devolver None."

# Test 3: Procesamiento exitoso de pedido con descuento
total = srv.procesar_pedido([item], porcentaje_descuento=10.0)
# Subtotal: 50 * 2 = 100. Con 10% descuento = 90.0
assert abs(total - 90.0) < 0.01, f"Total esperado 90.0, obtenido {total}."
assert p.stock == 8, f"El stock debió decrementar a 8, pero quedó en {p.stock}."

# Test 4: Verificar excepción de stock insuficiente
item_exceso = models.ItemPedido(producto=p, cantidad=20)
try:
    srv.procesar_pedido([item_exceso])
    assert False, "Debió lanzar StockInsuficienteError por exceso de cantidad sobre stock."
except models.StockInsuficienteError:
    pass

# Test 5: Ejecución del flujo orquestado en main.py
demo = main.ejecutar_sistema_demo()
assert "total_pagado" in demo, "ejecutar_sistema_demo debe retornar total_pagado."
assert demo["stock_restante_p1"] == 4, "El stock de Notebook Gamer debe quedar en 4."
assert demo["stock_restante_p2"] == 8, "El stock de Mouse debe quedar en 8."
print("🎉 ¡PROYECTO INTEGRADOR MULTI-ARCHIVO VALIDADO AL 100%! 🎉")'
  );

  -- ==============================================================================
  -- 5. SEMILLA: CERTIFICACIÓN OFICIAL VERIFICABLE "PYTHON PROFESSIONAL DEVELOPER"
  -- ==============================================================================
  INSERT INTO public.certifications (
    course_id,
    title,
    code,
    description,
    min_passing_score,
    time_limit_minutes,
    xp_reward,
    badge_theme,
    skills_validated
  ) VALUES (
    v_course_id,
    'Certificación Profesional en Python Moderno',
    'CERT-PY-PRO',
    'Certificación oficial verificable que acredita competencias avanzadas en el lenguaje Python: tipado estático, colecciones y algoritmos, POO rigurosa, dataclasses, pattern matching, concurrencia con asyncio y arquitectura de proyectos modulares multi-archivo.',
    80,
    20,
    750,
    'emerald',
    ARRAY['Python 3.12', 'POO Avanzada', 'Dataclasses', 'Type Hints', 'Arquitectura Modular', 'Asyncio', 'Clean Code', 'Manejo de Excepciones']
  )
  RETURNING id INTO v_cert_id;

  -- Banco de 20 preguntas desafiantes para la Certificación Oficial
  INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
  (v_cert_id, '¿Qué imprime la siguiente instrucción en Python: type(5 / 2)?', ARRAY['<class ''int''>', '<class ''float''>', '<class ''double''>', '<class ''decimal''>'], 1, 'En Python 3, el operador de división simple / siempre devuelve un número de punto flotante (float), incluso si la división es exacta.'),
  (v_cert_id, '¿Cuál es la diferencia fundamental entre una lista y una tupla en Python?', ARRAY['Las listas son inmutables y las tuplas mutables', 'Las listas son mutables (modificables) y las tuplas son inmutables', 'Las tuplas no permiten elementos repetidos', 'Las listas solo aceptan números enteros'], 1, 'Las listas pueden modificar su contenido en memoria, mientras que las tuplas no pueden alterarse una vez instanciadas.'),
  (v_cert_id, '¿Qué valor retorna la expresión: [x for x in [1, 2, 3, 4] if x % 2 == 0]?', ARRAY['[1, 3]', '[2, 4]', '[True, False]', '4'], 1, 'La list comprehension filtra únicamente los elementos donde el módulo 2 es igual a 0 (números pares).'),
  (v_cert_id, 'En una función en Python, ¿cómo se capturan argumentos arbitrarios con nombre (keyword arguments)?', ARRAY['*args', '**kwargs', '&kwargs', '...params'], 1, 'El prefijo de doble asterisco **kwargs empaqueta todos los argumentos con nombre en un diccionario.'),
  (v_cert_id, '¿Qué ocurre en un bloque try/except si se incluye una cláusula else?', ARRAY['Se ejecuta siempre al final', 'Se ejecuta únicamente si NO ocurrió ninguna excepción en el bloque try', 'Se ejecuta solo si ocurrió una excepción no capturada', 'Es un error de sintaxis'], 1, 'La cláusula else en un try se ejecuta exactamente cuando el bloque try finaliza de manera limpia y sin errores.'),
  (v_cert_id, '¿Qué método mágico (dunder method) se invoca cuando ejecutamos len(mi_objeto)?', ARRAY['__size__', '__count__', '__len__', '__length__'], 2, 'El método __len__ define la respuesta del objeto a la función universal len().'),
  (v_cert_id, '¿Para qué sirve el decorador @property en una clase de Python?', ARRAY['Para convertir una clase en estática', 'Para definir un getter accesible como atributo que puede incluir validaciones', 'Para encriptar la memoria del proceso', 'Para obligar a compilar a binario'], 1, '@property permite exponer un método como un atributo de lectura limpia y asociar validadores con su setter.'),
  (v_cert_id, '¿Qué ventaja principal ofrece el decorador @dataclass del módulo dataclasses?', ARRAY['Genera automáticamente constructores __init__, __repr__ y métodos de igualdad por valor', 'Hace que el código corra en GPU', 'Convierte el código a JavaScript', 'Impide la herencia de clases'], 0, '@dataclass elimina el código repetitivo generando __init__, __repr__ y __eq__ a partir de anotaciones de tipos.'),
  (v_cert_id, '¿En qué versión de Python se introdujo el Pattern Matching Estructural (match / case)?', ARRAY['Python 2.7', 'Python 3.6', 'Python 3.10', 'Python 3.12'], 2, 'Python 3.10 introdujo oficialmente el operador match/case según la especificación PEP 634.'),
  (v_cert_id, '¿Qué palabra clave convierte a una función normal en una función generadora perezosa en memoria?', ARRAY['generate', 'yield', 'lazy', 'return_stream'], 1, 'La palabra clave yield pausa la función y produce valores uno a uno bajo demanda sin consumir memoria masiva.'),
  (v_cert_id, '¿Qué hace la función super() en la Programación Orientada a Objetos de Python?', ARRAY['Otorga permisos de administrador al script', 'Permite invocar métodos e inicializadores de la clase base padre', 'Optimiza los ciclos del CPU', 'Reinicia la máquina virtual'], 1, 'super() delega la llamada a la clase padre en la jerarquía de herencia (MRO).'),
  (v_cert_id, '¿Cuál es el propósito del archivo __init__.py en una carpeta de Python?', ARRAY['Es un archivo de configuración obligatorio del sistema operativo', 'Marca al directorio como un paquete Python importable', 'Es un virus informático común', 'Contiene la licencia del autor'], 1, '__init__.py le indica a Python que la carpeta debe ser tratada como un paquete o módulo de importación.'),
  (v_cert_id, '¿Qué imprime: bool([]) y bool([0])?', ARRAY['True y True', 'False y False', 'False y True', 'True y False'], 2, 'Una lista vacía [] es considerada Falsy (False), mientras que una lista con un elemento [0] es considerada Truthy (True).'),
  (v_cert_id, '¿Cómo se garantiza que un archivo se cierre siempre tras ser utilizado incluso si ocurre un error?', ARRAY['Usando la sentencia with open(...)', 'Llamando a system.close()', 'Escribiendo exit() al final', 'No es posible garantizarlo'], 0, 'La declaración with utiliza el protocolo de Context Manager (__enter__ y __exit__) para garantizar el cierre del recurso.'),
  (v_cert_id, '¿Qué operador de Python 3.10+ reemplaza a Union[int, str] en anotaciones de tipos?', ARRAY['int & str', 'int | str', 'int || str', 'int ^ str'], 1, 'El operador pipe | permite definir uniones de tipos limpias como int | str.'),
  (v_cert_id, '¿Cuál es la función del módulo asyncio en Python moderno?', ARRAY['Hacer cálculos matemáticos con matrices', 'Proveer una infraestructura de bucle de eventos para concurrencia asíncrona', 'Diseñar interfaces visuales para móviles', 'Gestionar bases de datos relacionales'], 1, 'asyncio implementa el bucle de eventos (event loop) y palabras clave async/await para operaciones asíncronas no bloqueantes.'),
  (v_cert_id, 'Si en Python intentas modificar un string con s[0] = "A", ¿qué sucede?', ARRAY['El string se actualiza normalmente', 'Se lanza un TypeError porque los strings son inmutables', 'Se borra el resto del string', 'Se convierte en una lista'], 1, 'En Python los strings son completamente inmutables; intentar asignar a un índice lanza TypeError.'),
  (v_cert_id, '¿Qué método de diccionario permite obtener un valor o un valor por defecto sin arrojar KeyError?', ARRAY['dict.fetch()', 'dict.get()', 'dict.find()', 'dict.pull()'], 1, 'El método .get(clave, defecto) retorna el valor asociado o el valor por defecto si la clave no existe.'),
  (v_cert_id, '¿Qué diferencia hay entre is y == en Python?', ARRAY['Son exactamente sinónimos', '== compara igualdad de valor y is compara identidad en memoria (mismo objeto)', 'is es solo para números y == para texto', '== está deprecado'], 1, '== verifica si los valores son equivalentes, mientras que is verifica si ambas variables apuntan exactamente a la misma dirección de memoria.'),
  (v_cert_id, 'En un proyecto multi-archivo con models.py en la misma carpeta, ¿cómo se importa la clase Producto?', ARRAY['import models.Producto()', 'from models import Producto', 'include "models.py"', 'using models::Producto'], 1, 'from models import Producto es la sintaxis pythónica estándar para importar una entidad desde un módulo local.');

END $PYTHON_COURSE_SEED$;
