-- ==============================================================================
-- 🚀 SGFC SEED: 37 - REESTRUCTURACIÓN TOTAL: LIMPIEZA DE CURSOS Y SUPER CURSO
-- "INTRODUCCIÓN A LA PROGRAMACIÓN: ALGORITMOS, DIAGRAMAS DE FLUJO, LÓGICA Y PYTHON"
-- ==============================================================================
-- Este script ejecuta 2 fases:
--   FASE 1: Limpieza total de todos los cursos previos, módulos de cursos,
--           lecciones/retos de cursos, inscripciones, progreso de cursos y
--           certificaciones (preservando los retos independientes de la Arena).
--   FASE 2: Creación del Curso Troncal Fundacional con 6 Módulos (24 Lecciones):
--           - Módulo 1: Nociones Básicas y Pensamiento Algorítmico
--           - Módulo 2: Diagramado de Flujo (ISO 5807) y Pruebas de Escritorio
--           - Módulo 3: Lógica de Programación y Resolución de Problemas
--           - Módulo 4: Python desde Cero: Variables, Fórmulas y Decisiones
--           - Módulo 5: Repetición en Python: Ciclos while, for y Listas Simples
--           - Módulo 6: Funciones y Retos Clásicos de Programación en Python
--           + Certificación Oficial Verificable "CERT-INTRO-PROG" (15 preguntas).
-- ==============================================================================

DO $REESTRUCTURACION_SEED$
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

  -- ============================================================================
  -- 🧹 FASE 1: LIMPIEZA TOTAL DE TODOS LOS CURSOS EXISTENTES
  -- ============================================================================

  -- 1.1 Limpiar reportes de contenido vinculados a cursos o retos de cursos
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'content_reports') THEN
    DELETE FROM public.content_reports
    WHERE course_id IS NOT NULL
       OR challenge_id IN (
         SELECT c.id FROM public.challenges c
         JOIN public.modules m ON c.module_id = m.id
         WHERE m.course_id IS NOT NULL
       );
  END IF;

  -- 1.2 Limpiar intentos de exámenes, certificados emitidos, preguntas y certificaciones
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'exam_attempts') THEN
    DELETE FROM public.exam_attempts;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'user_certifications') THEN
    DELETE FROM public.user_certifications;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'certification_questions') THEN
    DELETE FROM public.certification_questions;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'certifications') THEN
    DELETE FROM public.certifications;
  END IF;

  -- 1.3 Limpiar progreso de usuarios en retos pertenecientes a cursos
  DELETE FROM public.user_progress
  WHERE challenge_id IN (
    SELECT c.id FROM public.challenges c
    JOIN public.modules m ON c.module_id = m.id
    WHERE m.course_id IS NOT NULL
  );

  -- 1.4 Limpiar inscripciones a cursos
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'course_enrollments') THEN
    DELETE FROM public.course_enrollments;
  END IF;

  -- 1.5 Eliminar todos los retos/lecciones de módulos asociados a cursos
  DELETE FROM public.challenges
  WHERE module_id IN (
    SELECT id FROM public.modules WHERE course_id IS NOT NULL
  );

  -- 1.6 Eliminar todos los módulos asociados a cursos (preserva módulos de Arena donde course_id IS NULL)
  DELETE FROM public.modules WHERE course_id IS NOT NULL;

  -- 1.7 Eliminar todos los cursos
  DELETE FROM public.courses;

  -- ============================================================================
  -- 🏗️ FASE 2: CREACIÓN DEL SUPER CURSO DE INTRODUCCIÓN A LA PROGRAMACIÓN
  -- ============================================================================

  -- Obtener autor de referencia o administrador
  SELECT id INTO v_author_id FROM public.profiles WHERE role = 'admin' LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  END IF;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  INSERT INTO public.courses (
    title,
    description,
    summary,
    tags,
    min_level,
    author_id,
    status
  ) VALUES (
    'Introducción a la Programación: Algoritmos, Diagramas de Flujo, Lógica y Python',
    'El punto de partida definitivo para aprender a programar desde cero absoluto. Domina el pensamiento algorítmico, diseño e interpretación de diagramas de flujo (ISO 5807), pruebas de escritorio, resolución de problemas de lógica y tus primeros programas reales en Python.',
    $SUMMARY$## 🚀 El Curso Troncal para Aprender a Pensar como Programador

El mayor error al aprender a programar es intentar memorizar código sin antes entender **cómo razonar un problema**. Un lenguaje de programación cambia cada pocos años, pero la **lógica algorítmica** es universal y para toda la vida.

Este curso ha sido diseñado desde cero con una metodología progresiva de **4 etapas conectadas**: primero comprendes cómo funciona la memoria y los datos, luego diseñas soluciones visuales con **Diagramas de Flujo**, entrenas tu mente con **Pruebas de Escritorio y Retos de Lógica**, y finalmente das vida a tus ideas escribiendo **código real en Python**.

---

### 🎯 Lo que dominarás paso a paso:

1. **Nociones Básicas de Programación:** Qué es un algoritmo, el modelo Entrada-Proceso-Salida (IPO), cómo funcionan las variables en la memoria RAM, tipos de datos, operadores aritméticos (incluyendo división entera y módulo `%`) y tablas de verdad booleanas (`AND`, `OR`, `NOT`).
2. **Diagramado de Flujo Estándar (ISO 5807):** Lectura y construcción de diagramas con terminales de inicio/fin, paralelogramos de entrada/salida, bloques de proceso, rombos de decisión (`Sí / No`) y ciclos con flechas de retorno.
3. **Pruebas de Escritorio y Lógica de Programación:** Seguimiento manual de variables (*Trace Tables*), contadores vs acumuladores, intercambio de valores (*Swap*), paridad, extracción de dígitos, búsqueda de máximos/mínimos y banderas lógicas (*Flags*).
4. **Programación Práctica en Python Simple:** Traducción directa de tus diagramas de flujo a programas reales en Python: variables, *f-strings*, condicionales (`if / elif / else`), bucles (`while` y `for`), listas básicas y funciones (`def`).$SUMMARY$,
    ARRAY['Fundamentos', 'Algoritmos', 'Diagramas de Flujo', 'Lógica', 'Python', 'Principiantes'],
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ============================================================================
  -- 📦 MÓDULO 1: NOCIONES BÁSICAS Y PENSAMIENTO ALGORÍTMICO
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 1: Nociones Básicas y Pensamiento Algorítmico',
    'Descubre cómo piensa una computadora: algoritmos, el modelo Entrada-Proceso-Salida, variables en memoria RAM, operadores matemáticos y lógica booleana.'
  )
  RETURNING id INTO v_m1_id;

  -- Lección 1.1 (Quiz): ¿Qué es programar? Algoritmos y el Modelo IPO
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m1_id,
    '1.1 ¿Qué es Programar? Algoritmos y el Modelo Entrada-Proceso-Salida',
    'Comprende qué es un algoritmo, sus tres características obligatorias y cómo fluye la información en cualquier programa.',
    'quiz',
    50,
    1,
    $THEORY$# ¿Qué es Programar Realmente?

Muchas personas creen que programar consiste en escribir símbolos extraños en una pantalla negra. En realidad, **programar es el arte de descomponer un problema complejo en pasos pequeños, ordenados y sin ambigüedades** para que una máquina pueda ejecutarlos.

Una computadora es increíblemente rápida, pero **no tiene sentido común ni intuición**: hace *exactamente* lo que le ordenas, ni más ni menos.

---

### 1. ¿Qué es un Algoritmo?

Un **algoritmo** es una secuencia ordenada de pasos que llevan a la solución de un problema. Una receta de cocina o las instrucciones para armar un mueble se parecen a un algoritmo, pero en informática todo algoritmo debe cumplir **3 reglas sagradas**:

- **Preciso:** Cada paso debe ser claro y no dejar lugar a dudas o interpretaciones. No puedes decir *"agrégale un poquito de sal"*; debes decir *"agrega exactamente 5 gramos de sal"*.
- **Definido (Determinista):** Si ejecutas el algoritmo dos veces con los mismos datos de entrada, debe producir exactamente el mismo resultado.
- **Finito:** Debe tener un final. No puede quedarse ejecutando pasos eternamente sin terminar.

---

### 2. El Modelo Universal IPO (Entrada → Proceso → Salida)

Absolutamente todos los programas del mundo —desde una calculadora hasta un videojuego o una inteligencia artificial— funcionan bajo el esquema **IPO** (*Input - Process - Output*):

```flowchart
  ╭──────────────────────╮      ╭──────────────────────╮      ╭──────────────────────╮
  │     1. ENTRADA       │      │      2. PROCESO      │      │      3. SALIDA       │
  │      (Input)         │ ───► │     (Process)        │ ───► │     (Output)         │
  │  Datos e ingredientes│      │ Cálculos y decisiones│      │ Resultado al usuario │
  ╰──────────────────────╯      ╰──────────────────────╯      ╰──────────────────────╯
```

#### Ejemplo cotidiano: Cajero Automático
1. **Entrada:** El usuario inserta su tarjeta, digita su PIN y escribe el monto a retirar (`$50`).
2. **Proceso:** El sistema verifica que el PIN sea correcto, consulta si el saldo es mayor o igual a `$50` y resta `$50` de la cuenta.
3. **Salida:** El cajero entrega los billetes e imprime el comprobante en pantalla.

---

### 3. Lenguaje Máquina vs Lenguajes de Programación

El procesador (CPU) de tu computadora solo entiende electricidad: encendidos y apagados representados con unos y ceros (**Código Binario / Lenguaje Máquina**, como `01001000 01101111`).

Como para los humanos es casi imposible programar escribiendo millones de unos y ceros, creamos los **Lenguajes de Alto Nivel** (como **Python**, JavaScript o C++), que usan palabras cercanas a nuestro idioma y un programa traductor (**Intérprete o Compilador**) se encarga de convertirlos a binario por nosotros.$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuáles son las tres propiedades obligatorias que debe cumplir todo algoritmo informático?",
        "options": [
          "Ser largo, estar escrito en inglés y usar números complejos",
          "Ser preciso, definido (determinista) y finito (tener un final)",
          "Ser infinito, ambiguo y depender de la suerte del procesador",
          "Tener gráficos en 3D, conexión a Internet y base de datos"
        ],
        "correctIndex": 1,
        "explanation": "Todo algoritmo debe ser preciso (sin ambigüedades), definido (misma entrada produce misma salida) y finito (debe terminar en algún momento)."
      },
      {
        "id": "q2",
        "question": "En una aplicación que calcula el promedio de 3 notas de un alumno y muestra si aprobó, ¿cuál es la etapa de PROCESO según el modelo IPO?",
        "options": [
          "Cuando el profesor escribe las 3 notas en el teclado",
          "Sumar las 3 notas, dividir el resultado entre 3 y comparar si el promedio alcanza la nota mínima",
          "Mostrar el cartel verde de 'Aprobado' en la pantalla del celular",
          "Encender el monitor de la computadora"
        ],
        "correctIndex": 1,
        "explanation": "La lectura de las 3 notas es la Entrada, el cálculo matemático y comparación es el Proceso, y mostrar el cartel en pantalla es la Salida."
      },
      {
        "id": "q3",
        "question": "¿Por qué necesitamos un Intérprete o Compilador cuando programamos en un lenguaje como Python?",
        "options": [
          "Porque el procesador (CPU) solo entiende código máquina (binario de 1s y 0s) y necesita traducir nuestras instrucciones",
          "Para corregir faltas de ortografía en los correos electrónicos",
          "Para que la batería de la computadora dure el doble de tiempo",
          "Porque sin él el teclado no puede escribir letras mayúsculas"
        ],
        "correctIndex": 0,
        "explanation": "Los lenguajes de alto nivel están diseñados para ser entendidos por humanos; el intérprete o compilador traduce esas instrucciones al lenguaje máquina que ejecuta la CPU."
      }
    ]$JSON$
  );

  -- Lección 1.2 (Input): Variables, Memoria RAM y Tipos de Datos
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m1_id,
    '1.2 Variables en Memoria RAM, Asignación y Tipos de Datos',
    'Aprende cómo se guardan los datos en memoria, cómo cambian de valor las variables paso a paso y realiza tu primera prueba de escritorio.',
    'input',
    75,
    2,
    $THEORY$# Variables y Tipos de Datos: Las Cajas de la Memoria

Para que un programa pueda hacer cálculos, necesita un lugar donde recordar datos temporalmente mientras trabaja. Ese lugar es la **Memoria RAM**.

---

### 1. ¿Qué es una Variable?

Imagina la memoria RAM como un gran estante lleno de **cajas**. Una **variable** es una caja a la que le pegas una **etiqueta con un nombre** por fuera (el *identificador*) y dentro guardas un **valor**.

```flowchart
   Etiqueta:  edad                 Etiqueta:  puntos
  ┌────────────────────┐          ┌────────────────────┐
  │         20         │          │        150         │
  └────────────────────┘          └────────────────────┘
```

#### Regla clave de las variables:
En una caja **solo cabe un valor a la vez**. Si guardas un nuevo valor en la misma variable, **el valor anterior se borra y es reemplazado por el nuevo**.

---

### 2. La Operación de Asignación (`=` o `←`)

En matemáticas el signo `=` significa igualdad eterna. En programación, el signo `=` (o la flecha `←` en pseudocódigo) significa **ASIGNACIÓN**:
> **Primero se calcula todo lo que está a la DERECHA del signo `=` y el resultado se guarda en la variable de la IZQUIERDA.**

Observa qué ocurre línea por línea en esta **Prueba de Escritorio**:

```python
puntos = 10          # 1. La caja 'puntos' ahora vale 10
bono = 5             # 2. La caja 'bono' ahora vale 5
puntos = puntos + bono  # 3. Derecha: 10 + 5 = 15. Ahora 'puntos' guarda 15
puntos = 3           # 4. Se pisa el 15 anterior. Ahora 'puntos' vale 3
```

---

### 3. Los 4 Tipos de Datos Primitivos Universales

No es lo mismo guardar un número para sumar que guardar el nombre de una persona. En programación existen 4 tipos básicos:

| Tipo de Dato | Nombre en Python | ¿Para qué sirve? | Ejemplos |
| :--- | :--- | :--- | :--- |
| **Entero** | `int` | Números exactos sin coma decimal (positivos, negativos o cero) | `0`, `25`, `-10` |
| **Real / Decimal** | `float` | Números con parte fraccionaria (se usa punto `.`, no coma) | `3.14`, `19.99`, `-0.5` |
| **Texto / Cadena** | `str` | Letras, palabras o símbolos encerrados entre comillas `""` | `"Hola"`, `"Ana"`, `"123"` |
| **Lógico / Booleano** | `bool` | Solo tiene dos valores posibles: Verdadero o Falso | `True`, `False` |

> 💡 **¡Ojo con las comillas!** `25` es un número entero con el que puedes hacer sumas (`25 + 5 = 30`), mientras que `"25"` entre comillas es un **texto** (como el número de una casa).$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Realiza una prueba de escritorio en una hoja siguiendo estas instrucciones paso a paso:\n\n```python\na = 8\nb = 3\na = a + b\nb = a - 2\n```\n\n**¿Qué valor numérico queda guardado dentro de la variable `b` al finalizar la última línea?**",
        "placeholder": "Escribe el número exacto...",
        "expectedAnswer": "9",
        "acceptedAnswers": ["9", "b = 9", "b=9"],
        "inputMode": "numeric",
        "explanation": "Paso 1: a vale 8. Paso 2: b vale 3. Paso 3: a = 8 + 3, por lo que 'a' pasa a valer 11. Paso 4: b = a - 2 -> b = 11 - 2 = 9."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Sigue el valor de la variable `vidas` línea por línea:\n\n```python\nvidas = 3\nvidas = vidas + 2\nvidas = 1\nvidas = vidas + 4\n```\n\n**¿Cuál es el valor final de la variable `vidas`?**",
        "placeholder": "Escribe el número exacto...",
        "expectedAnswer": "5",
        "acceptedAnswers": ["5", "vidas = 5"],
        "inputMode": "numeric",
        "explanation": "En la tercera línea, 'vidas = 1' sobreescribe por completo el valor anterior (que era 5) y deja la variable en 1. Luego, en la última línea, 1 + 4 da como resultado 5."
      }
    ]$JSON$
  );

  -- Lección 1.3 (Input): Aritmética, Precedencia y Operador Módulo (%)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m1_id,
    '1.3 Aritmética de Programación: Precedencia, División Entera y Módulo (%)',
    'Domina el orden en que se calculan las operaciones y descubre el poder secreto del operador módulo (residuo de una división).',
    'input',
    75,
    3,
    $THEORY$# Aritmética para Programadores

Cuando escribes una fórmula en un programa, la computadora no calcula de izquierda a derecha a ciegas: respeta estrictamente la **Jerarquía (Precedencia) de Operadores**.

---

### 1. Orden de Prioridad en una Expresión

1. **Paréntesis `( )`**: Todo lo que esté entre paréntesis se resuelve primero.
2. **Potencias `**` (o `^`)**: Elevar a un exponente (ej: `2 ** 3` es $2^3 = 8$).
3. **Multiplicación `*`, División `/`, División Entera `//` y Módulo `%`**: Tienen el mismo nivel (se evalúan de izquierda a derecha).
4. **Suma `+` y Resta `-`**: Se resuelven al final.

```python
resultado_sin_parentesis = 10 + 2 * 3    # Primero 2 * 3 = 6, luego 10 + 6 = 16
resultado_con_parentesis = (10 + 2) * 3  # Primero (10 + 2) = 12, luego 12 * 3 = 36
```

---

### 2. Los Dos Hermanos Clave: División Entera (`//`) y Módulo (`%`)

Recuerda cuando aprendiste a dividir a mano en la escuela primaria (sin usar decimales). Si repartes **17 caramelos entre 5 amigos**:
- A cada amigo le tocan **3 caramelos enteros** (ese es el **Cociente Entero**).
- Y **sobran 2 caramelos** sin repartir (ese es el **Residuo o Resto**).

```flowchart
       17  │  5   (Divisor)
     - 15  └─────
     ────     3   ──► Cociente Entero:  17 // 5 = 3
        2         ──► Residuo (Módulo): 17 % 5  = 2
```

En programación tenemos un operador para cada uno:
- **`17 / 5`** → `3.4` (División normal con decimales).
- **`17 // 5`** → `3` (**División entera**: descarta la parte decimal y se queda solo con la parte entera).
- **`17 % 5`** → `2` (**Operador Módulo**: devuelve **el sobrante o residuo** de la división entera).

---

### 3. ¿Por qué el Operador Módulo (`%`) es tan importante?

El operador `%` aparece en miles de algoritmos reales:
1. **Saber si un número es Par o Impar:**
   - Si divides cualquier número par entre `2`, nunca sobra nada: `numero % 2` da **`0`**.
   - Si divides un número impar entre `2`, siempre sobra uno: `numero % 2` da **`1`**.
2. **Convertir unidades de tiempo:**
   - Si tienes `130` minutos: `130 // 60` son **`2` horas completas**, y `130 % 60` son los **`10` minutos sobrantes**.$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Calcula a mano respetando la jerarquía de operadores:\n\n```python\nx = 4 + 3 * (10 - 6)\n```\n\n**¿Cuál es el valor numérico exacto de `x`?**",
        "placeholder": "Escribe el resultado...",
        "expectedAnswer": "16",
        "acceptedAnswers": ["16", "x = 16"],
        "inputMode": "numeric",
        "explanation": "1) Primero el paréntesis: (10 - 6) = 4. 2) Luego la multiplicación: 3 * 4 = 12. 3) Finalmente la suma: 4 + 12 = 16."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Si tienes 23 monedas de oro y las guardas en bolsas donde caben exactamente 4 monedas por bolsa:\n\n```python\nsobrantes = 23 % 4\n```\n\n**¿Qué número guarda la variable `sobrantes` (el residuo de dividir 23 entre 4)?**",
        "placeholder": "Escribe el residuo...",
        "expectedAnswer": "3",
        "acceptedAnswers": ["3"],
        "inputMode": "numeric",
        "explanation": "4 * 5 = 20. Al restar 23 - 20, sobran exactamente 3 monedas. Por lo tanto, 23 % 4 es 3."
      }
    ]$JSON$
  );

  -- Lección 1.4 (Input): Lógica Booleana y Tablas de Verdad
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m1_id,
    '1.4 Lógica Booleana: Comparaciones y Tablas de Verdad (AND, OR, NOT)',
    'Aprende cómo los programas evalúan condiciones verdaderas o falsas y cómo combinar reglas lógicas.',
    'input',
    75,
    4,
    $THEORY$# Lógica Booleana: El Cerebro que Toma Decisiones

Para que un programa sea inteligente y tome caminos distintos (por ejemplo, permitir o denegar un pago), necesita hacer **preguntas lógicas** cuya respuesta solo puede ser **`True` (Verdadero)** o **`False` (Falso)**.

---

### 1. Operadores Relacionales (De Comparación)

Sirven para comparar dos valores entre sí:

| Operador | Significado | Ejemplo (`x = 10`) | Resultado |
| :--- | :--- | :--- | :--- |
| `==` | **Igual a** (¡Ojo! Son DOS signos igual) | `x == 10` | `True` |
| `!=` | **Diferente / Distinto de** | `x != 10` | `False` |
| `>` | Mayor estricto que | `x > 10` | `False` (10 no es mayor que 10) |
| `>=` | Mayor o igual que | `x >= 10` | `True` |
| `<` | Menor estricto que | `x < 20` | `True` |
| `<=` | Menor o igual que | `x <= 5` | `False` |

> ⚠️ **Regla de Oro:**
> - Un solo igual (`x = 5`) **guarda** el número 5 en `x` (Asignación).
> - Dos iguales (`x == 5`) **pregunta** si `x` vale 5 (Comparación).

---

### 2. Operadores Lógicos (`AND`, `OR`, `NOT`)

Cuando necesitamos unir dos o más condiciones al mismo tiempo, usamos las **Tablas de Verdad de George Boole**:

#### A) Operador `and` (Y lógico - Exigente)
Solo da `True` si **AMBAS** condiciones se cumplen al mismo tiempo.
- `True and True` → **`True`**
- `True and False` → `False`
- `False and False` → `False`
*Ejemplo:* Para entrar a un vuelo internacional necesitas: `tener_pasaje and tener_pasaporte`. Si te falta aunque sea uno, no viajas.

#### B) Operador `or` (O lógico - Flexible)
Da `True` si **AL MENOS UNA** de las condiciones se cumple.
- `True or False` → **`True`**
- `False or True` → **`True`**
- `True or True` → **`True`**
- `False or False` → `False`
*Ejemplo:* Te hacen descuento en el cine si: `es_miercoles or eres_estudiante`. Con que se cumpla cualquiera de las dos, tienes descuento.

#### C) Operador `not` (NO lógico - Inversor)
Invierte el valor booleano:
- `not True` → `False`
- `not False` → **`True`**$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Analiza las siguientes variables de un jugador y evalúa la condición:\n\n```python\nnivel = 12\ntiene_llave = False\n\npuede_entrar = (nivel >= 10) and (tiene_llave == True)\n```\n\n**¿Qué valor booleano (`True` o `False`) queda guardado en `puede_entrar`?**",
        "placeholder": "Escribe True o False...",
        "expectedAnswer": "False",
        "acceptedAnswers": ["False", "false", "Falso", "falso"],
        "inputMode": "text",
        "explanation": "La primera parte (nivel >= 10) es True porque 12 >= 10. Pero la segunda parte (tiene_llave == True) es False. Como están unidas por 'and' (que exige que ambas sean verdaderas), True and False da como resultado False."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Ahora evalúa esta segunda condición con los mismos datos:\n\n```python\npuntos = 50\nvidas = 0\n\ncontinua_jugando = (puntos >= 100) or not (vidas == 0)\n```\n\n**¿Cuál es el resultado final de `continua_jugando` (`True` o `False`)?**",
        "placeholder": "Escribe True o False...",
        "expectedAnswer": "False",
        "acceptedAnswers": ["False", "false", "Falso", "falso"],
        "inputMode": "text",
        "explanation": "1) (puntos >= 100) es False porque 50 no es >= 100. 2) (vidas == 0) es True, pero al tener un 'not' adelante se invierte a False. 3) Finalmente, False or False da como resultado False."
      }
    ]$JSON$
  );

  -- ============================================================================
  -- 📐 MÓDULO 2: DIAGRAMADO DE FLUJO Y DISEÑO VISUAL (ISO 5807)
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 2: Diagramado de Flujo y Diseño Visual de Algoritmos',
    'Aprende a diseñar y leer algoritmos visualmente con la norma ISO 5807: bloques de proceso, entrada/salida, rombos de decisión y ciclos con pruebas de escritorio.'
  )
  RETURNING id INTO v_m2_id;

  -- Lección 2.1 (Quiz): Simbología Estándar de Diagramas de Flujo
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m2_id,
    '2.1 Simbología de Diagramas de Flujo (ISO 5807): El Mapa de tu Algoritmo',
    'Domina el significado exacto de cada figura geométrica en un diagrama de flujo profesional.',
    'quiz',
    60,
    1,
    $THEORY$# Diagramas de Flujo: Pensar en Imágenes antes de Codificar

Un **Diagrama de Flujo** (*Flowchart*) es la representación gráfica de un algoritmo. Así como un arquitecto dibuja un plano antes de levantar una casa, un programador diseña un diagrama de flujo para visualizar el camino de los datos antes de escribir código.

---

### 1. Los 5 Símbolos Fundamentales (Norma Internacional ISO 5807)

En cualquier universidad o empresa de software del mundo se utilizan exactamente estas **5 figuras geométricas**:

```flowchart
  1. TERMINAL (Óvalo / Cápsula)          2. ENTRADA / SALIDA (Paralelogramo)
       ╭───────────────────╮                  ╱─────────────────────╱
       │   INICIO / FIN    │                 ╱   Leer / Mostrar    ╱
       ╰───────────────────╯                ╱─────────────────────╱
  Marca dónde arranca y dónde            Pedir datos por teclado (Leer) o
  termina exactamente el algoritmo.      mostrar resultados en pantalla.


  3. PROCESO (Rectángulo)                4. DECISIÓN (Rombo / Diamante)
       ┌───────────────────┐                          ╱╲
       │ total ← precio * 2│                        ╱    ╲
       └───────────────────┘                Sí ─── ❬ ¿x>5? ❭ ─── No
  Operaciones matemáticas, cálculos                  ╲    ╱
  internos y asignación de variables.                  ╲╱
                                         Evalúa una condición lógica y divide
                                         el camino en dos ramas (Sí / No).
```

5. **Líneas de Flujo (`│`, `──►`, `▼`):** Flechas que indican el orden exacto de ejecución.

---

### 2. Reglas de Oro para Diagramar Correctamente

1. **Todo diagrama tiene un único `INICIO` arriba y al menos un `FIN` abajo.**
2. **El flujo va de arriba hacia abajo y de izquierda a derecha.**
3. **A un Rectángulo de Proceso (`┌───┐`) entra 1 flecha y sale 1 flecha.**
4. **A un Rombo de Decisión (`◇`) entra 1 flecha por arriba, pero SIEMPRE salen 2 flechas** (una marcada con **Sí / Verdadero** y otra marcada con **No / Falso**).
5. **Las líneas de flujo nunca deben quedar sueltas**: toda rama debe conducir finalmente hacia el bloque `FIN`.$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "En un diagrama de flujo bajo el estándar ISO 5807, ¿qué figura geométrica debes usar para representar la operación matemática `area = base * altura`?",
        "options": [
          "Un Rombo (Diamante)",
          "Un Rectángulo (Bloque de Proceso)",
          "Un Paralelogramo inclinado",
          "Un Óvalo (Terminal)"
        ],
        "correctIndex": 1,
        "explanation": "El Rectángulo es el símbolo universal de Proceso: se utiliza para asignaciones de variables, fórmulas matemáticas y transformaciones internas de datos."
      },
      {
        "id": "q2",
        "question": "¿Para qué se utiliza el símbolo del Paralelogramo inclinado en un diagrama de flujo?",
        "options": [
          "Exclusivamente para evaluar preguntas con respuesta Sí o No",
          "Para marcar el Inicio y el Fin del programa",
          "Para operaciones de Entrada (leer datos del usuario) y Salida (mostrar mensajes o resultados)",
          "Para conectar dos páginas distintas cuando no alcanza la hoja"
        ],
        "correctIndex": 2,
        "explanation": "El Paralelogramo representa cualquier interacción con el exterior: Entrada de datos (Leer/Input) o Salida de información (Mostrar/Imprimir/Output)."
      },
      {
        "id": "q3",
        "question": "¿Cuál es la característica obligatoria de las flechas en un símbolo de Rombo (Decisión)?",
        "options": [
          "No lleva ninguna flecha de salida porque ahí termina el programa",
          "Entra una flecha con la pregunta lógica y salen al menos dos caminos rotulados (Sí / No)",
          "Solo puede usarse para sumar números enteros",
          "Siempre debe ir antes del bloque de INICIO"
        ],
        "correctIndex": 1,
        "explanation": "Todo rombo evalúa una condición booleana, por lo que necesita bifurcar el flujo en dos caminos: uno cuando la condición es Verdadera (Sí) y otro cuando es Falsa (No)."
      }
    ]$JSON$
  );

  -- Lección 2.2 (Input): Diagramas Secuenciales y Prueba de Escritorio
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m2_id,
    '2.2 Diagramas de Flujo Secuenciales y Prueba de Escritorio',
    'Recorre tu primer diagrama de flujo completo desde INICIO hasta FIN rastreando cómo se transforman los datos.',
    'input',
    80,
    2,
    $THEORY$# Estructura Secuencial: Paso a Paso sin Desvíos

Un diagrama de flujo **secuencial** es aquel donde las instrucciones se ejecutan una detrás de otra en línea recta, de arriba hacia abajo, sin bifurcaciones ni repeticiones.

---

### Ejemplo: Calcular el Precio Final con Impuesto

Observa cómo este diagrama lee el precio de un producto, calcula un impuesto del 20%, lo suma al total y muestra el resultado:

```flowchart
               ╭──────────────────────────╮
               │          INICIO          │
               ╰────────────┬─────────────╯
                            ▼
              ╱────────────────────────────╱
             ╱   Leer: precio_base        ╱   ◄── ENTRADA (Ej: el usuario ingresa 200)
            ╱───────────────┬────────────╱
                            ▼
            ┌──────────────────────────────┐
            │ impuesto ← precio_base * 0.20│  ◄── PROCESO 1 (200 * 0.20 = 40)
            └───────────────┬──────────────┘
                            ▼
            ┌──────────────────────────────┐
            │ total ← precio_base + impuesto│ ◄── PROCESO 2 (200 + 40 = 240)
            └───────────────┬──────────────┘
                            ▼
              ╱────────────────────────────╱
             ╱   Mostrar: total           ╱   ◄── SALIDA (Muestra 240 en pantalla)
            ╱───────────────┬────────────╱
                            ▼
               ╭──────────────────────────╮
               │           FIN            │
               ╰──────────────────────────╯
```

---

### ¿Qué es una Prueba de Escritorio (*Desk Check*)?

Una **Prueba de Escritorio** consiste en tomar papel y lápiz, dibujar una columna por cada variable del diagrama e ir anotando cómo cambia su valor al bajar por cada flecha:

| Paso del Diagrama | `precio_base` | `impuesto` | `total` | Salida en Pantalla |
| :--- | :---: | :---: | :---: | :---: |
| 1. `Leer precio_base` | `200` | — | — | — |
| 2. `impuesto ← precio_base * 0.20` | `200` | `40` | — | — |
| 3. `total ← precio_base + impuesto` | `200` | `40` | `240` | — |
| 4. `Mostrar total` | `200` | `40` | `240` | **`240`** |$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Recorre el siguiente diagrama de flujo secuencial suponiendo que en la Entrada el usuario ingresa `horas = 6` y `tarifa = 15`:\n\n```flowchart\n         ╭────────────────────────╮\n         │         INICIO         │\n         ╰───────────┬────────────╯\n                     ▼\n       ╱──────────────────────────╱\n      ╱   Leer: horas, tarifa    ╱\n     ╱───────────────┬──────────╱\n                     ▼\n     ┌────────────────────────────┐\n     │ sueldo_bruto ← horas * tarifa │\n     └───────────────┬────────────┘\n                     ▼\n     ┌────────────────────────────┐\n     │ bono ← 20                  │\n     │ pago_final ← sueldo_bruto + bono │\n     └───────────────┬────────────┘\n                     ▼\n       ╱──────────────────────────╱\n      ╱   Mostrar: pago_final    ╱\n     ╱───────────────┬──────────╱\n                     ▼\n         ╭────────────────────────╮\n         │          FIN           │\n         ╰────────────────────────╯\n```\n\n**¿Qué número exacto se imprime en el bloque `Mostrar: pago_final`?**",
        "placeholder": "Escribe el valor de pago_final...",
        "expectedAnswer": "110",
        "acceptedAnswers": ["110", "$110"],
        "inputMode": "numeric",
        "explanation": "1) Se leen horas = 6 y tarifa = 15. 2) sueldo_bruto = 6 * 15 = 90. 3) bono = 20, y pago_final = 90 + 20 = 110. 4) Se muestra 110."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Observa este segundo diagrama. Si el usuario ingresa `n = 10` en la entrada:\n\n```flowchart\n         ╭────────────────────────╮\n         │         INICIO         │\n         ╰───────────┬────────────╯\n                     ▼\n           ╱──────────────────╱\n          ╱     Leer: n      ╱\n         ╱───────────┬──────╱\n                     ▼\n         ┌────────────────────┐\n         │ a ← n * 3          │\n         │ b ← a - 5          │\n         │ resultado ← b // 5 │\n         └───────────┬────────┘\n                     ▼\n           ╱────────────────────╱\n          ╱ Mostrar: resultado ╱\n         ╱───────────┬────────╱\n                     ▼\n         ╭────────────────────────╮\n         │          FIN           │\n         ╰────────────────────────╯\n```\n\n**¿Qué valor entero muestra el diagrama al final?**",
        "placeholder": "Escribe el resultado...",
        "expectedAnswer": "5",
        "acceptedAnswers": ["5"],
        "inputMode": "numeric",
        "explanation": "Si n = 10: 1) a = 10 * 3 = 30. 2) b = 30 - 5 = 25. 3) resultado = 25 // 5 = 5."
      }
    ]$JSON$
  );

  -- Lección 2.3 (Input): Bifurcaciones y Rombos de Decisión
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m2_id,
    '2.3 Bifurcaciones en Diagramas de Flujo: El Rombo de Decisión',
    'Aprende a seguir caminos condicionales Sí/No y decisiones anidadas dentro de un diagrama de flujo.',
    'input',
    90,
    3,
    $THEORY$# Estructuras Condicionales: Cuando el Camino se Divide

Un programa útil no hace siempre lo mismo: necesita evaluar condiciones y elegir un camino u otro. En un diagrama de flujo, esto se representa con el **Rombo de Decisión**.

---

### 1. Decisión Simple y Doble (`Sí` vs `No`)

Imagina una tienda donde las compras de **`100` dólares o más** reciben un descuento de `25` dólares, pero las compras menores a `100` solo reciben un descuento simbólico de `5` dólares:

```flowchart
                         ╭────────────────────╮
                         │       INICIO       │
                         ╰─────────┬──────────╯
                                   ▼
                       ╱──────────────────────╱
                      ╱     Leer: compra     ╱
                     ╱─────────────┬────────╱
                                   ▼
                                 ╱   ╲
                               ╱       ╲
            ┌───── [ SÍ ] ─── ❬ ¿compra ❭ ─── [ NO ] ─────┐
            │                  ╲ >=100?╱                  │
            ▼                    ╲   ╱                    ▼
  ┌───────────────────┐            ▽            ┌───────────────────┐
  │  descuento ← 25   │                         │  descuento ← 5    │
  └─────────┬─────────┘                         └─────────┬─────────┘
            │                                             │
            └──────────────────────┬──────────────────────┘
                                   ▼
                     ┌───────────────────────────┐
                     │ final ← compra - descuento│
                     └─────────────┬─────────────┘
                                   ▼
                       ╱──────────────────────╱
                      ╱    Mostrar: final    ╱
                     ╱─────────────┬────────╱
                                   ▼
                         ╭────────────────────╮
                         │        FIN         │
                         ╰────────────────────╯
```

Observa dos detalles cruciales:
1. **Los caminos son mutuamente excluyentes:** Si la flecha se va por la izquierda (`[ SÍ ]`), **jamás** pasa por el bloque de la derecha (`[ NO ]`), y viceversa.
2. **Punto de convergencia:** Ambos caminos vuelven a unirse más abajo para calcular `final ← compra - descuento` y terminar ordenadamente.

---

### 2. Decisiones en Cascada (Rombos Anidados)

¿Qué pasa si hay **3 o más caminos posibles**? (Por ejemplo: clasificar una temperatura en *"Frío"*, *"Templado"* o *"Caluroso"*).
Simplemente conectamos la rama **`[ NO ]`** del primer rombo hacia la entrada de un **segundo rombo**.$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Realiza la prueba de escritorio sobre el siguiente diagrama de flujo si el usuario ingresa `edad = 16` y `precio = 50`:\n\n```flowchart\n                       ╭────────────────────╮\n                       │       INICIO       │\n                       ╰─────────┬──────────╯\n                                 ▼\n                    ╱────────────────────────╱\n                   ╱   Leer: edad, precio   ╱\n                  ╱──────────────┬─────────╱\n                                 ▼\n                               ╱   ╲\n            ┌──── [ SÍ ] ──── ❬¿edad < 18?❭ ──── [ NO ] ────┐\n            ▼                  ╲   ╱                        ▼\n  ┌───────────────────┐          ▽                ┌───────────────────┐\n  │ costo ← precio / 2│                           │ costo ← precio - 5│\n  └─────────┬─────────┘                           └─────────┬─────────┘\n            └────────────────────┬──────────────────────────┘\n                                 ▼\n                    ╱────────────────────────╱\n                   ╱     Mostrar: costo     ╱\n                  ╱────────────────────────╱\n```\n\n**¿Qué valor numérico se muestra en `costo`?**",
        "placeholder": "Escribe el valor de costo...",
        "expectedAnswer": "25",
        "acceptedAnswers": ["25", "25.0"],
        "inputMode": "numeric",
        "explanation": "Como edad = 16, la pregunta ¿edad < 18? (¿16 < 18?) es Verdadera (SÍ). El flujo toma el camino izquierdo: costo = 50 / 2 = 25."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Sigue las flechas de este diagrama con dos rombos anidados cuando la entrada es `puntaje = 75`:\n\n```flowchart\n                       ╱────────────────────╱\n                      ╱   Leer: puntaje    ╱\n                     ╱───────────┬────────╱\n                                 ▼\n                               ╱   ╲\n          ┌─── [ SÍ ] ─── ❬¿puntaje >= 90?❭ ─── [ NO ] ───┐\n          ▼                    ╲   ╱                      ▼\n  ┌───────────────┐              ▽                      ╱   ╲\n  │ Rango ← \"ORO\" │                 ┌── [ SÍ ] ── ❬¿puntaje >= 70?❭ ── [ NO ] ──┐\n  └───────┬───────┘                 ▼                   ╲   ╱                   ▼\n          │                 ┌───────────────┐             ▽             ┌───────────────┐\n          │                 │Rango ← \"PLATA\"│                           │Rango ← \"BRONCE\"│\n          │                 └───────┬───────┘                           └───────┬───────┘\n          └─────────────────────────┼───────────────────┬───────────────────────┘\n                                    ▼                   ▼\n                              ╱───────────────────────────────╱\n                             ╱        Mostrar: Rango         ╱\n                            ╱───────────────────────────────╱\n```\n\n**¿Qué palabra exacta se muestra en la salida `Rango`?**",
        "placeholder": "Escribe ORO, PLATA o BRONCE...",
        "expectedAnswer": "PLATA",
        "acceptedAnswers": ["PLATA", "\"PLATA\"", "'PLATA'"],
        "inputMode": "text",
        "explanation": "1) En el primer rombo: ¿75 >= 90? NO. Se desvía a la derecha. 2) En el segundo rombo: ¿75 >= 70? SÍ. Entra al bloque Rango <- 'PLATA'."
      }
    ]$JSON$
  );

  -- Lección 2.4 (Input): Ciclos en Diagramas de Flujo, Contadores y Acumuladores
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m2_id,
    '2.4 Ciclos en Diagramas de Flujo: Contadores y Acumuladores',
    'Descubre cómo una flecha que sube crea un bucle de repetición y aprende a rastrear contadores y acumuladores vuelta por vuelta.',
    'input',
    100,
    4,
    $THEORY$# Estructuras Repetitivas (Ciclos / Bucles) en Diagramas

Imagina que necesitas sumar los números del `1` al `100`. Dibujar 100 rectángulos en una hoja sería una locura. En su lugar, usamos un **Ciclo (Bucle)**: una flecha que **regresa hacia arriba** para repetir un bloque de instrucciones mientras una condición siga siendo verdadera.

---

### 1. Los Dos Roles Más Famosos de la Programación

Dentro de casi todo bucle existen dos tipos de variables que trabajan en equipo:

1. **El Contador (`i` o `cont`):**
   - Sirve para contar **cuántas vueltas** lleva el ciclo.
   - Aumenta en una cantidad fija (casi siempre de 1 en 1): `i ← i + 1`.
2. **El Acumulador (`suma` o `total`):**
   - Es como una alcancía donde vamos sumando valores variables en cada vuelta: `suma ← suma + i`.
   - Casi siempre se inicializa en **`0`** antes de entrar al ciclo.

---

### 2. Anatomía Visual de un Ciclo en un Diagrama de Flujo

Observa cómo este diagrama suma los números del `1` al `3`:

```flowchart
                   ╭──────────────────────╮
                   │        INICIO        │
                   ╰──────────┬───────────╯
                              ▼
               ┌──────────────────────────────┐
               │ suma ← 0                     │  ◄── Inicialización (antes del ciclo)
               │ i ← 1                        │
               └──────────────┬───────────────┘
                              │
        ╔═════════════════════▶──────────────────────┐
        ║                     ▼                      │
        ║                   ╱   ╲                    │
        ║                 ╱       ╲                  │
        ║                ❬ ¿i <= 3?❭ ─── [ NO ] ─────┼───┐ (Cuando i llega a 4,
        ║                 ╲       ╱                  │   │  sale del bucle)
        ║                   ╲   ╱                    │   │
        ║                     │ [ SÍ ]               │   │
        ║                     ▼                      │   │
        ║      ┌──────────────────────────────┐      │   │
        ║      │ suma ← suma + i              │      │   │
        ║      │ i ← i + 1                    │      │   │
        ║      └──────────────┬───────────────┘      │   │
        ║                     │                      │   │
        ╚═════════════════════╝ (Vuelve a preguntar) ┘   │
                                                         ▼
                                           ╱──────────────────────────╱
                                          ╱      Mostrar: suma       ╱
                                         ╱───────────────┬──────────╱
                                                         ▼
                                               ╭──────────────────╮
                                               │       FIN        │
                                               ╰──────────────────╯
```

### Tabla de Prueba de Escritorio (Vuelta por Vuelta):

| Momento | ¿`i <= 3`? | Nuevo `suma` (`suma + i`) | Nuevo `i` (`i + 1`) |
| :--- | :---: | :---: | :---: |
| **Inicio** | — | `0` | `1` |
| **Vuelta 1** (`i = 1`) | `1 <= 3` (**SÍ**) | `0 + 1 = 1` | `2` |
| **Vuelta 2** (`i = 2`) | `2 <= 3` (**SÍ**) | `1 + 2 = 3` | `3` |
| **Vuelta 3** (`i = 3`) | `3 <= 3` (**SÍ**) | `3 + 3 = 6` | `4` |
| **Fin del Ciclo** (`i = 4`) | `4 <= 3` (**NO**) | Sale con **`6`** | `4` |$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Realiza la tabla de seguimiento vuelta por vuelta para el siguiente diagrama cíclico:\n\n```flowchart\n               ┌──────────────────────┐\n               │ total ← 0            │\n               │ k ← 1                │\n               └──────────┬───────────┘\n                          │\n        ╔═════════════════▶\n        ║                 ▼\n        ║               ╱   ╲\n        ║              ❬¿k <= 4?❭ ─── [ NO ] ───► Mostrar: total ───► ( FIN )\n        ║               ╲   ╱\n        ║                 │ [ SÍ ]\n        ║                 ▼\n        ║      ┌──────────────────────┐\n        ║      │ total ← total + 10   │\n        ║      │ k ← k + 1            │\n        ║      └──────────┬───────────┘\n        ╚═════════════════╝\n```\n\n**¿Qué valor numérico se muestra en `total` cuando el flujo toma la rama `[ NO ]` y termina?**",
        "placeholder": "Escribe el valor final de total...",
        "expectedAnswer": "40",
        "acceptedAnswers": ["40"],
        "inputMode": "numeric",
        "explanation": "El ciclo se ejecuta para k = 1, k = 2, k = 3 y k = 4 (4 vueltas en total). En cada vuelta suma 10 a 'total' (0 -> 10 -> 20 -> 30 -> 40). Cuando k pasa a 5, ¿5 <= 4? es NO y muestra 40."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Analiza este segundo diagrama donde la variable `x` se multiplica en cada vuelta:\n\n```flowchart\n               ┌──────────────────────┐\n               │ x ← 2                │\n               └──────────┬───────────┘\n                          │\n        ╔═════════════════▶\n        ║                 ▼\n        ║               ╱   ╲\n        ║              ❬¿x < 15?❭ ─── [ NO ] ───► Mostrar: x ───► ( FIN )\n        ║               ╲   ╱\n        ║                 │ [ SÍ ]\n        ║                 ▼\n        ║      ┌──────────────────────┐\n        ║      │ x ← x * 2            │\n        ║      └──────────┬───────────┘\n        ╚═════════════════╝\n```\n\n**¿Qué valor tiene `x` en el momento exacto en que sale del ciclo por la rama `[ NO ]`?**",
        "placeholder": "Escribe el valor final de x...",
        "expectedAnswer": "16",
        "acceptedAnswers": ["16"],
        "inputMode": "numeric",
        "explanation": "Inicio: x = 2. Vuelta 1: ¿2 < 15? SÍ -> x = 4. Vuelta 2: ¿4 < 15? SÍ -> x = 8. Vuelta 3: ¿8 < 15? SÍ -> x = 16. Luego pregunta: ¿16 < 15? NO, por lo que sale del bucle y muestra 16."
      }
    ]$JSON$
  );

  -- ============================================================================
  -- 🧠 MÓDULO 3: LÓGICA DE PROGRAMACIÓN Y RESOLUCIÓN DE PROBLEMAS
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 3: Lógica de Programación y Resolución de Problemas Clásicos',
    'Entrena los patrones mentales que todo programador usa a diario: intercambio de variables (Swap), extracción de dígitos, búsqueda del mayor y traducción a código.'
  )
  RETURNING id INTO v_m3_id;

  -- Lección 3.1 (Input): El Patrón del Intercambio (Swap)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m3_id,
    '3.1 El Problema de los Dos Vasos: Intercambio de Variables (Swap)',
    'Aprende por qué no puedes intercambiar dos variables directamente y cómo usar una variable auxiliar en memoria.',
    'input',
    80,
    1,
    $THEORY$# El Patrón Clásico de Intercambio (*Swap*)

Uno de los primeros retos de lógica a los que se enfrenta todo programador es el siguiente:
> Tienes dos variables: `a = 10` y `b = 20`. Quieres intercambiar sus contenidos para que `a` quede con `20` y `b` quede con `10`.

---

### 1. El Error del Principiante (La Trampa)

El instinto inicial suele ser escribir esto:
```python
a = 10
b = 20

# ¡ERROR! Intentar intercambiar sin variable auxiliar:
a = b   # Ahora 'a' copia el 20 de 'b'. ¡El 10 original de 'a' se destruyó!
b = a   # Como 'a' ahora vale 20, 'b' vuelve a copiar 20.
```
Resultado del error: tanto `a` como `b` terminan valiendo `20`, y **perdimos el `10` para siempre**.

---

### 2. La Analogía de los Dos Vasos y el Vaso Vacío

Imagina que tienes un **Vaso A con jugo de naranja** y un **Vaso B con agua**. Si viertes el agua directamente dentro del vaso con jugo, se mezclan o se derrama.

¿Cómo lo resuelves en la vida real? **¡Usando un tercer vaso vacío (`aux`)!**

```flowchart
  PASO 1: Guardar A en AUX          PASO 2: Pasar B hacia A           PASO 3: Pasar AUX hacia B
      aux ← a                           a ← b                             b ← aux
  (Salvamos el valor de A)          (Ahora A recibe lo de B)          (B recupera lo que tenía A)
```

En pseudocódigo o Python estándar:
```python
a = 10
b = 20

aux = a   # Paso 1: aux guarda 10 (respaldo seguro)
a = b     # Paso 2: a pasa a valer 20
b = aux   # Paso 3: b recupera el 10 desde aux
```$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Un estudiante olvidó usar una variable auxiliar y escribió este código:\n\n```python\nx = 50\ny = 90\nx = y\ny = x\n```\n\n**¿Qué valor numérico queda guardado en la variable `y` al final?**",
        "placeholder": "Escribe el valor de y...",
        "expectedAnswer": "90",
        "acceptedAnswers": ["90"],
        "inputMode": "numeric",
        "explanation": "Al hacer 'x = y', la variable 'x' pierde el 50 y toma el valor 90. Luego, al hacer 'y = x', copia ese mismo 90 en 'y'. Ambas variables terminan valiendo 90."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Ahora sigue este intercambio triple con una variable `temp`:\n\n```python\na = 5\nb = 12\ntemp = a\na = b\nb = temp + 3\n```\n\n**¿Qué valor numérico tiene `b` al terminar?**",
        "placeholder": "Escribe el valor final de b...",
        "expectedAnswer": "8",
        "acceptedAnswers": ["8"],
        "inputMode": "numeric",
        "explanation": "1) temp guarda el valor original de 'a', que es 5. 2) 'a' toma el valor de 'b' (12). 3) 'b' recibe temp + 3, es decir, 5 + 3 = 8."
      }
    ]$JSON$
  );

  -- Lección 3.2 (Input): Descomposición de Números y Paridad
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m3_id,
    '3.2 Trucos de Lógica Numérica: Paridad, Múltiplos y Extracción de Dígitos',
    'Descubre cómo usar la división entera (//) y el módulo (%) en base 10 para desarmar cualquier número entero.',
    'input',
    85,
    2,
    $THEORY$# Cómo Manipular Números con Lógica Pura

En programación muchas veces necesitamos inspeccionar las propiedades de un número entero sin convertirlo en texto: saber si es múltiplo de otro, o separar sus dígitos uno por uno (como en los validadores de tarjetas de crédito o DNI).

---

### 1. Detector de Múltiplos y Divisibilidad

Un número `A` es **múltiplo** (o divisible exactamente) por otro número `B` si al dividir `A` entre `B` **el residuo es exactamente cero**:

```python
# ¿Es n múltiplo de 3?
n % 3 == 0

# ¿Es n un número PAR? (múltiplo de 2)
n % 2 == 0

# ¿Es n un número IMPAR?
n % 2 != 0   # (o también: n % 2 == 1)
```

---

### 2. El Secreto del Número `10`: Extraer y Recortar Dígitos

Como nuestro sistema numérico es decimal (Base 10), dividir entre `10` tiene un superpoder matemático sobre cualquier número entero positivo (por ejemplo, `n = 487`):

1. **`n % 10` (Módulo 10) → Extrae el ÚLTIMO dígito de la derecha:**
   - `487 % 10` = **`7`** (porque $48 \times 10 = 480$ y sobran $7$).
2. **`n // 10` (División entera entre 10) → Elimina el último dígito:**
   - `487 // 10` = **`48`** (descarta el $7$ y deja el resto del número).

```flowchart
               Número original:  n = 487
                       ┌──────────┴──────────┐
                       ▼                     ▼
                 n % 10 = 7             n // 10 = 48
              (Último dígito)        (Número recortado)
```

Si repites este proceso dentro de un ciclo mientras `n > 0`, ¡puedes extraer todos los dígitos de cualquier número, sumar sus cifras o invertirlo!$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Aplica el truco de Base 10 en una hoja sobre el número `593`:\n\n```python\nnumero = 593\ndigito_derecha = numero % 10\nresto_izquierda = numero // 10\nsuma = digito_derecha + resto_izquierda\n```\n\n**¿Qué valor numérico guarda la variable `suma`?**",
        "placeholder": "Escribe el resultado...",
        "expectedAnswer": "62",
        "acceptedAnswers": ["62"],
        "inputMode": "numeric",
        "explanation": "1) digito_derecha = 593 % 10 = 3 (el último dígito). 2) resto_izquierda = 593 // 10 = 59 (el número sin el último dígito). 3) suma = 3 + 59 = 62."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Rastrea este algoritmo que suma los dígitos de un número de dos cifras (`n = 84`):\n\n```python\nn = 84\nultimo = n % 10\nprimero = n // 10\nnumero_invertido = (ultimo * 10) + primero\n```\n\n**¿Qué número queda almacenado en `numero_invertido`?**",
        "placeholder": "Escribe el número invertido...",
        "expectedAnswer": "48",
        "acceptedAnswers": ["48"],
        "inputMode": "numeric",
        "explanation": "1) ultimo = 84 % 10 = 4. 2) primero = 84 // 10 = 8. 3) numero_invertido = (4 * 10) + 8 = 40 + 8 = 48. ¡Así se invierte un número matemáticamente!"
      }
    ]$JSON$
  );

  -- Lección 3.3 (Input): Búsqueda del Mayor y Banderas Lógicas (Flags)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m3_id,
    '3.3 Patrón del Rey de la Colina (Buscar el Mayor) y Banderas (Flags)',
    'Aprende cómo hace un algoritmo para recordar el valor más alto visto hasta el momento al recorrer datos.',
    'input',
    85,
    3,
    $THEORY$# El Algoritmo del "Rey de la Colina" (Máximo y Mínimo)

Imagina que alguien te dicta 5 números uno por uno y al final debes decir cuál fue el más grande. Tu cerebro no guarda los 5 números: simplemente recuerda **el más grande que ha escuchado hasta ese instante**, y si escucha uno mayor, actualiza su recuerdo.

En programación este patrón se conoce como **Búsqueda de Extremo (Máximo o Mínimo)**:

```flowchart
  1. Tomamos el primer elemento como "campeón provisional":
     mayor_actual ← primer_numero

  2. Por cada nuevo número que llega, preguntamos en un rombo:
     ¿nuevo_numero > mayor_actual?
       ├── [ SÍ ] ──► mayor_actual ← nuevo_numero  (¡Tenemos nuevo campeón!)
       └── [ NO ] ──► No hacemos nada (el campeón actual conserva su trono)
```

---

### Ejemplo de Rastreo Paso a Paso

Busquemos el mayor en la secuencia `[ 14, 28, 9, 35, 20 ]`:

| Número leído | ¿Es mayor que `mayor_actual`? | Valor de `mayor_actual` |
| :--- | :---: | :---: |
| Inicio (1º dato: `14`) | — (Se asigna como campeón inicial) | **`14`** |
| Llega `28` | ¿`28 > 14`? → **SÍ** | **`28`** (Se actualiza) |
| Llega `9` | ¿`9 > 28`? → **NO** | **`28`** (Se mantiene) |
| Llega `35` | ¿`35 > 28`? → **SÍ** | **`35`** (Se actualiza) |
| Llega `20` | ¿`20 > 35`? → **NO** | **`35`** (Ganador final) |

---

### ¿Qué es una Bandera Lógica (*Flag*)?

Una **Bandera (*Flag*)** es una variable booleana (`True` / `False`) que actúa como un interruptor de memoria: empieza en `False` antes de un ciclo, y si durante alguna vuelta ocurre un evento especial (por ejemplo, encontramos un número negativo o un producto sin stock), la levantamos poniéndola en `True`.$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Si aplicas el algoritmo de búsqueda del mayor sobre la secuencia `[ 12, 25, 19, 40, 31, 40, 15 ]`, comenzando con `mayor = 12`:\n\n```python\n# Solo se actualiza si: nuevo_numero > mayor (estrictamente mayor)\n```\n\n**¿Cuántas veces cambia (se actualiza) el valor de la variable `mayor` después de su valor inicial 12?**",
        "placeholder": "Escribe cuántas veces se actualiza...",
        "expectedAnswer": "2",
        "acceptedAnswers": ["2", "2 veces"],
        "inputMode": "numeric",
        "explanation": "Empieza en 12. 1) Con 25: ¿25 > 12? SÍ (1ª actualización, pasa a 25). 2) Con 19: NO. 3) Con 40: ¿40 > 25? SÍ (2ª actualización, pasa a 40). 4) Con 31: NO. 5) Con el segundo 40: ¿40 > 40? NO (porque no es estrictamente mayor). 6) Con 15: NO. Total: 2 actualizaciones."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Observa este algoritmo que busca el MENOR valor (el más pequeño):\n\n```python\nmenor = 50\nfor num in [30, 45, 18, 22, 10, 29]:\n    if num < menor:\n        menor = num\n```\n\n**¿Qué valor queda guardado en `menor` al finalizar el recorrido?**",
        "placeholder": "Escribe el valor final de menor...",
        "expectedAnswer": "10",
        "acceptedAnswers": ["10"],
        "inputMode": "numeric",
        "explanation": "Empieza en 50 -> baja a 30 -> ignora 45 -> baja a 18 -> ignora 22 -> baja a 10 -> ignora 29. El valor mínimo final es 10."
      }
    ]$JSON$
  );

  -- Lección 3.4 (Quiz): De Diagrama y Pseudocódigo a Código Python
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, test_code)
  VALUES (
    v_m3_id,
    '3.4 El Puente Mental: De Diagrama de Flujo y Pseudocódigo a Python',
    'Aprende el diccionario de traducción directa entre figuras de diagrama de flujo, pseudocódigo y Python.',
    'quiz',
    75,
    4,
    $THEORY$# El Diccionario de Traducción a Python

Ya sabes cómo funcionan las variables, las condiciones, los diagramas de flujo y las pruebas de escritorio. ¡Llegó el momento de pasar tus algoritmos a **Python**!

¿Por qué elegimos **Python** para aprender a programar? Porque la sintaxis de Python fue creada para ser prácticamente **idéntica al pseudocódigo**.

---

### Tabla Maestra de Equivalencias

| Figura en Diagrama | Pseudocódigo en Español | Código Real en Python |
| :--- | :--- | :--- |
| **Rectángulo (Asignación)** | `x ← 10` | `x = 10` |
| **Paralelogramo (Salida)** | `Mostrar "Hola"` | `print("Hola")` |
| **Rombo (Decisión Simple)** | `Si edad >= 18 Entonces` | `if edad >= 18:` |
| **Rama Falsa (`[ NO ]`)** | `Sino` | `else:` |
| **Rombo Anidado** | `Sino Si edad >= 12 Entonces` | `elif edad >= 12:` |
| **Ciclo Condicional** | `Mientras i <= 5 Hacer` | `while i <= 5:` |
| **Ciclo Contado** | `Para i desde 1 hasta 5` | `for i in range(1, 6):` |

---

### Las 2 Reglas Sintácticas de Python que Nunca Debes Olvidar

1. **Los Dos Puntos (`:`):**
   Cada vez que abres una estructura de control (`if`, `elif`, `else`, `while`, `for` o una función `def`), la línea **termina obligatoriamente con dos puntos `:`**.
2. **La Sangría (Indentación de 4 espacios):**
   Todo lo que va *adentro* de una decisión o de un bucle debe escribirse corrido **4 espacios hacia la derecha**. Cuando quitas la sangría y vuelves al margen izquierdo, le indicas a Python que ese bloque ya terminó.

```python
if temperatura > 30:
    print("Hace calor")      # Dentro del camino [ SÍ ]
else:
    print("Clima agradable") # Dentro del camino [ NO ]
print("Fin del reporte")     # Fuera del rombo (convergencia)
```$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cómo se traduce al lenguaje Python un Rombo de Decisión que pregunta `¿saldo >= 500?`?",
        "options": [
          "rombo (saldo >= 500) { }",
          "if saldo >= 500:",
          "si saldo = 500 entonces",
          "while saldo == 500;"
        ],
        "correctIndex": 1,
        "explanation": "En Python, las decisiones se escriben con la palabra clave 'if', seguida de la condición y terminando la línea con dos puntos ':'."
      },
      {
        "id": "q2",
        "question": "¿Cómo sabe Python qué instrucciones pertenecen al interior de un bloque `if` o de un ciclo `while`?",
        "options": [
          "Por la sangría (indentación de 4 espacios hacia la derecha) debajo de la línea con dos puntos ':'",
          "Porque se escriben todas en letras mayúsculas",
          "Porque van encerradas entre paréntesis cuadrados [ ]",
          "Porque llevan un signo de dólar $ al principio de cada línea"
        ],
        "correctIndex": 0,
        "explanation": "Python utiliza la indentación (sangría) como estructura sintáctica para delimitar el inicio y el fin de cada bloque de código."
      },
      {
        "id": "q3",
        "question": "En un diagrama de flujo con caminos múltiples (varios rombos en cascada), ¿qué palabra clave usa Python para decir 'Sino, si se cumple esta otra condición'?",
        "options": [
          "otherwise",
          "elif",
          "sino_if",
          "else_when"
        ],
        "correctIndex": 1,
        "explanation": "'elif' es la abreviatura de 'else if' en Python y permite encadenar múltiples preguntas condicionales de forma limpia."
      }
    ]$JSON$
  );

  -- ============================================================================
  -- 🐍 MÓDULO 4: TUS PRIMEROS PROGRAMAS EN PYTHON SIMPLE
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 4: Tus Primeros Programas en Python: Variables, Fórmulas y Decisiones',
    'Pon tus manos en el código: escribe tus primeras funciones simples en Python aplicando el modelo Entrada-Proceso-Salida y los rombos condicionales.'
  )
  RETURNING id INTO v_m4_id;

  -- Lección 4.1 (Python): Variables y Texto Formateado (f-strings)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m4_id,
    '4.1 Tu Primer Código en Python: Variables y Mensajes Dinámicos',
    'Aprende cómo funciona una función en Python y cómo insertar variables dentro de un texto usando f-strings.',
    'python',
    80,
    1,
    $THEORY$# ¡Bienvenido a tu Editor de Código Python!

En este módulo pasarás de leer diagramas a **escribir programas reales en Python**. En la parte derecha tienes tu editor de código y el botón **"Ejecutar"**.

---

### 1. ¿Cómo nos entregan los datos en los ejercicios?

En lugar de pedir datos con el teclado manualmente cada vez, nuestros ejercicios usan una **caja de entrada y salida llamada Función (`def`)**:
- Los datos de **Entrada** llegan entre los paréntesis: `def presentar_jugador(nombre, nivel):`
- Tu **Proceso** ocurre adentro (con 4 espacios de sangría).
- Tu **Salida** se entrega usando la palabra **`return`** (devolver resultado).

```flowchart
  ENTRADA: (nombre, nivel) ──► ┌───────────────────────────────┐ ──► SALIDA: return mensaje
                               │ Tu código dentro de la función│
                               └───────────────────────────────┘
```

---

### 2. Unir Texto y Variables con *f-strings*

En Python, la forma más sencilla de armar una frase mezclando texto con el valor de una variable es poner una letra **`f`** antes de las comillas y colocar las variables entre llaves **`{ }`**:

```python
nombre = "Lucía"
edad = 21

mensaje = f"Hola {nombre}, tienes {edad} años"
# Resultado: "Hola Lucía, tienes 21 años"
```

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `crear_saludo(nombre, puntos)` siguiendo estos dos pasos sencillos:
1. Crea una variable llamada `puntos_totales` que sume **`10`** puntos de regalo a la variable `puntos` que recibes.
2. Devuelve con **`return`** exactamente el siguiente texto usando un *f-string*:
   `f"Hola {nombre}, tienes {puntos_totales} puntos"`

*Ejemplo:* Si `nombre = "Alex"` y `puntos = 40`, tu función debe devolver `"Hola Alex, tienes 50 puntos"`.$THEORY$,
    $INIT$def crear_saludo(nombre, puntos):
    # Paso 1: Suma 10 a la variable 'puntos' y guárdalo en 'puntos_totales'
    puntos_totales = 
    
    # Paso 2: Devuelve el mensaje formateado con return
    return f"Hola {nombre}, tienes {puntos_totales} puntos"
$INIT$,
    $SOL$def crear_saludo(nombre, puntos):
    puntos_totales = puntos + 10
    return f"Hola {nombre}, tienes {puntos_totales} puntos"
$SOL$,
    $TEST$import main

res1 = main.crear_saludo("Alex", 40)
assert res1 == "Hola Alex, tienes 50 puntos", f"Se esperaba 'Hola Alex, tienes 50 puntos', pero tu función devolvió: '{res1}'"

res2 = main.crear_saludo("Sofía", 0)
assert res2 == "Hola Sofía, tienes 10 puntos", f"Para Sofía con 0 puntos iniciales se esperaba 'Hola Sofía, tienes 10 puntos', pero se obtuvo: '{res2}'"

print("✓ ¡Excelente! Tu primer programa en Python funcionó a la perfección.")
$TEST$
  );

  -- Lección 4.2 (Python): Fórmulas Secuenciales en Python
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m4_id,
    '4.2 De Diagrama Secuencial a Python: Calculadora de Cuenta y Propina',
    'Traduce un diagrama de flujo secuencial paso a paso a código Python utilizando operadores aritméticos.',
    'python',
    85,
    2,
    $THEORY$# Traduciendo un Diagrama Secuencial a Python

Veamos cómo un problema de la vida real se diseña primero en un diagrama de flujo y luego se convierte línea por línea en Python.

### El Problema:
Tres o más amigos van a cenar. Conocemos el `monto_comida`, queremos agregarle un **10% de propina** (`monto_comida * 0.10`) y luego dividir el total en partes iguales entre la `cantidad_personas`.

```flowchart
               ╭──────────────────────────────────╮
               │              INICIO              │
               ╰────────────────┬─────────────────╯
                                ▼
             ╱──────────────────────────────────────╱
            ╱  Entrada: monto_comida, personas     ╱
           ╱────────────────────┬─────────────────╱
                                ▼
           ┌──────────────────────────────────────┐
           │ propina ← monto_comida * 0.10        │
           │ total ← monto_comida + propina       │
           │ pago_individual ← total / personas   │
           └────────────────────┬─────────────────┘
                                ▼
             ╱──────────────────────────────────────╱
            ╱  Devolver (return): pago_individual  ╱
           ╱──────────────────────────────────────╱
```

---

### 🎯 Tu Misión en este Ejercicio:

Traduce los 3 pasos del rectángulo de proceso dentro de la función `calcular_pago_por_persona(monto_comida, personas)`:
1. Calcula `propina = monto_comida * 0.10`
2. Calcula `total = monto_comida + propina`
3. Calcula `pago_individual = total / personas` y devuélvelo con `return pago_individual`.$THEORY$,
    $INIT$def calcular_pago_por_persona(monto_comida, personas):
    # 1. Calcula el 10% de propina
    propina = 
    
    # 2. Suma el monto_comida más la propina
    total = 
    
    # 3. Divide el total entre la cantidad de personas y devuélvelo
    pago_individual = 
    return pago_individual
$INIT$,
    $SOL$def calcular_pago_por_persona(monto_comida, personas):
    propina = monto_comida * 0.10
    total = monto_comida + propina
    pago_individual = total / personas
    return pago_individual
$SOL$,
    $TEST$import main

r1 = main.calcular_pago_por_persona(100, 2)
assert abs(r1 - 55.0) < 0.01, f"Para monto 100 entre 2 personas (total 110 con propina), cada uno debe pagar 55.0, pero obtuvimos {r1}"

r2 = main.calcular_pago_por_persona(200, 4)
assert abs(r2 - 55.0) < 0.01, f"Para monto 200 entre 4 personas (total 220 con propina), cada uno debe pagar 55.0, pero obtuvimos {r2}"

print("✓ ¡Perfecto! Tradujiste el diagrama secuencial a Python sin errores.")
$TEST$
  );

  -- Lección 4.3 (Python): Rombos de Decisión con if, elif y else
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m4_id,
    '4.3 Tomando Decisiones en Python: if, elif y else',
    'Convierte un diagrama de flujo con dos rombos de decisión en una estructura condicional en Python.',
    'python',
    90,
    3,
    $THEORY$# Cómo Escribir Decisiones (`if / elif / else`) en Python

Cada rombo de un diagrama de flujo se convierte en un bloque condicional en Python. Veamos cómo clasificar la nota de un examen (`0` a `100`):

```flowchart
                             ╱─────────────────╱
                            ╱   Entrada: nota ╱
                           ╱─────────┬───────╱
                                     ▼
                                   ╱   ╲
            ┌─── [ SÍ ] ─── ❬ ¿nota >= 90? ❭ ─── [ NO ] ───┐
            ▼                      ╲   ╱                   ▼
  ┌────────────────────┐             ▽                   ╱   ╲
  │ return "Excelente" │          ┌─── [ SÍ ] ─── ❬ ¿nota >= 60? ❭ ─── [ NO ] ───┐
  └────────────────────┘          ▼                      ╲   ╱                   ▼
                        ┌────────────────────┐             ▽          ┌────────────────────┐
                        │ return "Aprobado"  │                        │ return "Reprobado" │
                        └────────────────────┘                        └────────────────────┘
```

En Python, este diagrama exacto se escribe así:

```python
if nota >= 90:
    return "Excelente"
elif nota >= 60:
    return "Aprobado"
else:
    return "Reprobado"
```

> 💡 **Recuerda:**
> - `if` evalúa el primer rombo.
> - `elif` evalúa el segundo rombo (solo si el primero fue falso).
> - `else` es el camino final cuando ninguna condición anterior se cumplió (no lleva condición al lado, solo `else:`).

---

### 🎯 Tu Misión en este Ejercicio:

Implementa la función `clasificar_temperatura(grados)` siguiendo estas 3 reglas:
1. Si `grados >= 30`, devuelve `"Caluroso"`.
2. Sino, si `grados >= 15`, devuelve `"Templado"`.
3. En cualquier otro caso (`else`), devuelve `"Frio"` (sin tilde para facilitar la validación).$THEORY$,
    $INIT$def clasificar_temperatura(grados):
    # Escribe tu estructura if / elif / else aquí:
    if grados >= 30:
        return "Caluroso"
    
$INIT$,
    $SOL$def clasificar_temperatura(grados):
    if grados >= 30:
        return "Caluroso"
    elif grados >= 15:
        return "Templado"
    else:
        return "Frio"
$SOL$,
    $TEST$import main

assert main.clasificar_temperatura(35) == "Caluroso", "Para 35 grados debería devolver 'Caluroso'"
assert main.clasificar_temperatura(30) == "Caluroso", "Para 30 grados exactos debería devolver 'Caluroso'"
assert main.clasificar_temperatura(20) == "Templado", "Para 20 grados debería devolver 'Templado'"
assert main.clasificar_temperatura(15) == "Templado", "Para 15 grados exactos debería devolver 'Templado'"
assert main.clasificar_temperatura(5) in ["Frio", "Frío"], "Para 5 grados debería devolver 'Frio'"

print("✓ ¡Rombos de decisión dominados en Python!")
$TEST$
  );

  -- Lección 4.4 (Python): Condiciones Compuestas con and y or
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m4_id,
    '4.4 Reglas Lógicas Compuestas en Python: and y or',
    'Programa un validador de becas académicas combinando múltiples condiciones lógicas en Python.',
    'python',
    90,
    4,
    $THEORY$# Combinando Condiciones en un Mismo Rombo

Muchas veces en la vida real una decisión depende de **dos requisitos al mismo tiempo**. En lugar de hacer muchos `if` uno adentro de otro, usamos los operadores lógicos **`and`** y **`or`** que aprendiste en el Módulo 1:

```python
# Ejemplo: Subir a una montaña rusa requiere tener al menos 12 años Y medir al menos 140 cm
if edad >= 12 and altura >= 140:
    return "Puede subir"
else:
    return "No cumple los requisitos"
```

---

### 🎯 Tu Misión en este Ejercicio:

Una universidad otorga una **Beca de Excelencia** si el estudiante cumple **ambas condiciones al mismo tiempo**:
- Su `promedio` es **mayor o igual a `85`**, **Y (`and`)**
- Su porcentaje de `asistencia` es **mayor o igual a `90`**.

Completa la función `evaluar_beca(promedio, asistencia)`:
- Si cumple ambas condiciones, devuelve `"Beca Aprobada"`.
- De lo contrario (`else`), devuelve `"Beca Rechazada"`.$THEORY$,
    $INIT$def evaluar_beca(promedio, asistencia):
    # Combina ambas condiciones usando el operador 'and'
    if :
        return "Beca Aprobada"
    else:
        return "Beca Rechazada"
$INIT$,
    $SOL$def evaluar_beca(promedio, asistencia):
    if promedio >= 85 and asistencia >= 90:
        return "Beca Aprobada"
    else:
        return "Beca Rechazada"
$SOL$,
    $TEST$import main

assert main.evaluar_beca(90, 95) == "Beca Aprobada", "Con promedio 90 y asistencia 95 debe aprobarse"
assert main.evaluar_beca(85, 90) == "Beca Aprobada", "Con promedio 85 exacto y asistencia 90 exacta debe aprobarse"
assert main.evaluar_beca(95, 80) == "Beca Rechazada", "Con promedio 95 pero asistencia 80 (< 90) debe rechazarse"
assert main.evaluar_beca(70, 100) == "Beca Rechazada", "Con promedio 70 (< 85) aunque tenga asistencia 100 debe rechazarse"

print("✓ ¡Excelente manejo de lógica booleana aplicada en Python!")
$TEST$
  );

  -- ============================================================================
  -- 🔄 MÓDULO 5: REPETICIÓN EN PYTHON: CICLOS WHILE, FOR Y LISTAS SIMPLES
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 5: Repetición en Python: Ciclos while, for y Listas Simples',
    'Automatiza tareas repetitivas traduciendo ciclos con contadores y acumuladores a bucles while, for y recorrido de listas en Python.'
  )
  RETURNING id INTO v_m5_id;

  -- Lección 5.1 (Python): El Bucle while con Contador y Acumulador
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m5_id,
    '5.1 El Bucle while en Python: Contadores y Acumuladores en Acción',
    'Traduce el diagrama de flujo cíclico del Módulo 2 directamente a un bucle while en Python.',
    'python',
    95,
    1,
    $THEORY$# El Ciclo `while` (Mientras) en Python

¿Recuerdas el diagrama de flujo del Módulo 2 donde una flecha volvía a subir para sumar los números desde `1` hasta `n`? En Python ese ciclo se escribe con la palabra **`while`** (*mientras*):

```flowchart
        ┌───────────────────┐
        │ suma ← 0          │
        │ i ← 1             │
        └─────────┬─────────┘
                  ▼
        ╔══════► ╱ ╲
        ║       ❬i<=n❭ ── [ NO ] ──► return suma
        ║        ╲ ╱
        ║         │ [ SÍ ]
        ║         ▼
        ║  ┌──────────────┐
        ║  │ suma ← suma+i│
        ║  │ i ← i + 1    │
        ╚══┴──────────────┘
```

Observa cómo cada bloque del diagrama tiene su línea exacta en Python:

```python
suma = 0          # Acumulador empieza en 0
i = 1             # Contador empieza en 1

while i <= n:     # Rombo del ciclo: Mientras i sea menor o igual a n
    suma = suma + i   # Sumamos i a la alcancía
    i = i + 1         # ¡Muy importante! Avanzamos el contador en 1

return suma       # Fuera del while (sin sangría), devolvemos el total
```

> ⚠️ **¡Cuidado con el Ciclo Infinito!** Si olvidas escribir `i = i + 1` dentro del `while`, la variable `i` valdrá `1` para siempre y el ciclo nunca terminará.

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `sumar_hasta(n)` usando un ciclo `while` para que sume todos los números enteros desde `1` hasta `n` (inclusive) y devuelva el resultado acumulado en `suma`.$THEORY$,
    $INIT$def sumar_hasta(n):
    suma = 0
    i = 1
    
    # Escribe el ciclo while para repetir mientras i <= n:
    while i <= n:
        # 1. Acumula 'i' dentro de 'suma'
        
        # 2. Incrementa 'i' en 1
        
    return suma
$INIT$,
    $SOL$def sumar_hasta(n):
    suma = 0
    i = 1
    while i <= n:
        suma = suma + i
        i = i + 1
    return suma
$SOL$,
    $TEST$import main

assert main.sumar_hasta(3) == 6, f"La suma de 1 + 2 + 3 debe ser 6, pero devolvió {main.sumar_hasta(3)}"
assert main.sumar_hasta(5) == 15, f"La suma de 1 a 5 debe ser 15, pero devolvió {main.sumar_hasta(5)}"
assert main.sumar_hasta(10) == 55, f"La suma de 1 a 10 debe ser 55, pero devolvió {main.sumar_hasta(10)}"

print("✓ ¡Tu primer ciclo while con contador y acumulador funcionó de maravilla!")
$TEST$
  );

  -- Lección 5.2 (Python): El Bucle for y range()
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m5_id,
    '5.2 El Bucle for y range(): Repeticiones Automáticas sin Olvidar el Contador',
    'Descubre cómo el bucle for avanza el contador por ti automáticamente.',
    'python',
    95,
    2,
    $THEORY$# El Ciclo `for`: El Hermano Automático del `while`

Como contar desde un número inicial hasta un número final es tan común en programación, Python ofrece el ciclo **`for`** acompañado de **`range(inicio, fin_excluido)`**, el cual **crea e incrementa el contador automáticamente en cada vuelta**.

---

### ¿Cómo funciona `range(inicio, limite)`?

Un detalle fundamental de `range(a, b)` en Python es que **incluye el número inicial `a`, pero se detiene justo ANTES de `b`**:

```python
# Si queremos que 'i' tome los valores 1, 2, 3, 4 y 5:
for i in range(1, 6):
    print(i)
```
En este ejemplo:
- En la vuelta 1, `i` vale `1`.
- En la vuelta 2, `i` vale `2`... y así hasta `5` (al llegar al `6` se detiene).
- **No necesitas escribir `i = i + 1`**, ¡el `for` lo hace solo!

---

### Ejemplo: Calcular el Factorial de un Número ($n!$)

El factorial de $4$ ($4!$) consiste en multiplicar $1 \times 2 \times 3 \times 4 = 24$.
Nota que como vamos a **multiplicar**, nuestro acumulador (`producto`) debe empezar en **`1`** (porque si empezara en `0`, todo multiplicado por `0` daría `0`):

```python
producto = 1
for i in range(1, n + 1):
    producto = producto * i
return producto
```

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `calcular_factorial(n)` usando un ciclo `for i in range(1, n + 1):` para multiplicar todos los números desde `1` hasta `n` y devolver el resultado.$THEORY$,
    $INIT$def calcular_factorial(n):
    producto = 1
    
    # Recorre con for desde 1 hasta n + 1:
    for i in range(1, n + 1):
        # Multiplica 'producto' por 'i'
        producto = 
        
    return producto
$INIT$,
    $SOL$def calcular_factorial(n):
    producto = 1
    for i in range(1, n + 1):
        producto = producto * i
    return producto
$SOL$,
    $TEST$import main

assert main.calcular_factorial(3) == 6, "3! (1 * 2 * 3) debe ser 6"
assert main.calcular_factorial(4) == 24, "4! (1 * 2 * 3 * 4) debe ser 24"
assert main.calcular_factorial(5) == 120, "5! debe ser 120"
assert main.calcular_factorial(1) == 1, "1! debe ser 1"

print("✓ ¡Ciclo for y range() dominados con éxito!")
$TEST$
  );

  -- Lección 5.3 (Python): Listas en Python y Recorrido Elemento por Elemento
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m5_id,
    '5.3 Listas en Python: Guardar y Recorrer Colecciones de Datos',
    'Aprende a trabajar con listas de valores y a recorrerlas directamente con el ciclo for.',
    'python',
    95,
    3,
    $THEORY$# Listas: Guardar Muchos Datos en una Sola Variable

Hasta ahora cada variable guardaba un único dato. ¿Pero qué hacemos si queremos guardar los precios de 50 productos del supermercado? Usamos una **Lista (`list`)**.

Una **lista** es una fila ordenada de valores encerrados entre **corchetes `[ ]`** y separados por comas:

```python
precios = [10, 25, 15, 40]
```

---

### 1. Operaciones Esenciales con Listas

- **Saber cuántos elementos tiene (`len`):**
  `len(precios)` devuelve `4`.
- **Agregar un nuevo elemento al final (`.append`):**
  `precios.append(50)` agrega el `50` al final de la lista.
- **Recorrer cada elemento con `for`:**
  En Python puedes recorrer los valores de una lista directamente con una frase casi en inglés natural:

```python
precios = [10, 25, 15]
total = 0

for precio in precios:
    total = total + precio   # En cada vuelta, 'precio' toma un valor de la lista (10, luego 25, luego 15)

# Al terminar el ciclo, total vale 50
```

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `sumar_lista(numeros)` que recibe una lista de números (por ejemplo `[4, 8, 2]`):
1. Inicializa un acumulador `suma = 0`.
2. Recorre cada `num` dentro de la lista `numeros` usando un ciclo `for`.
3. Suma cada `num` a tu acumulador `suma` y devuelve el total al final.$THEORY$,
    $INIT$def sumar_lista(numeros):
    suma = 0
    
    # Recorre cada número dentro de la lista 'numeros'
    for num in numeros:
        # Suma 'num' al acumulador 'suma'
        
    return suma
$INIT$,
    $SOL$def sumar_lista(numeros):
    suma = 0
    for num in numeros:
        suma = suma + num
    return suma
$SOL$,
    $TEST$import main

assert main.sumar_lista([10, 20, 30]) == 60, "La suma de [10, 20, 30] debe ser 60"
assert main.sumar_lista([5, 5, 5, 5]) == 20, "La suma de [5, 5, 5, 5] debe ser 20"
assert main.sumar_lista([]) == 0, "La suma de una lista vacía [] debe ser 0"

print("✓ ¡Recorrido de listas con for superado!")
$TEST$
  );

  -- Lección 5.4 (Python): Combinando for + if para Filtrar y Contar en Listas
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m5_id,
    '5.4 El Patrón Maestro: Combinar for + if para Contar Elementos',
    'Une un ciclo for con una decisión if adentro para contar cuántos números pares hay en una lista.',
    'python',
    100,
    4,
    $THEORY$# Combinando Ciclo (`for`) + Decisión (`if`)

El patrón más frecuente en toda la programación consiste en **recorrer una lista con un `for`** y, **adentro de cada vuelta, hacer una pregunta con `if`**.

Observa el diagrama de flujo de este patrón para contar cuántos números de una lista son mayores a `10`:

```flowchart
        ╔══════► Por cada num en la lista:
        ║                 │
        ║                 ▼
        ║               ╱   ╲
        ║              ❬num>10❭ ─── [ SÍ ] ──► contador ← contador + 1
        ║               ╲   ╱                        │
        ║                 │ [ NO ]                   │
        ╚═════════════════┴──────────────────────────┘
```

Y así se ve en Python (nota los **dos niveles de sangría**: 4 espacios para el `for` y 8 espacios para lo que está dentro del `if`):

```python
contador = 0

for num in lista:
    if num > 10:               # 4 espacios (dentro del for)
        contador = contador + 1  # 8 espacios (dentro del if)

return contador
```

---

### 🎯 Tu Misión en este Ejercicio:

¿Recuerdas del Módulo 1 y 3 cómo sabemos si un número es **PAR**? ¡Cuando su residuo al dividir entre 2 es cero (`num % 2 == 0`)!

Completa la función `contar_pares(numeros)` para que recorra la lista `numeros` y cuente cuántos números pares contiene en total.$THEORY$,
    $INIT$def contar_pares(numeros):
    cantidad_pares = 0
    
    for num in numeros:
        # Pregunta con 'if' si 'num' es divisible por 2 (num % 2 == 0):
        if :
            cantidad_pares = cantidad_pares + 1
            
    return cantidad_pares
$INIT$,
    $SOL$def contar_pares(numeros):
    cantidad_pares = 0
    for num in numeros:
        if num % 2 == 0:
            cantidad_pares = cantidad_pares + 1
    return cantidad_pares
$SOL$,
    $TEST$import main

assert main.contar_pares([1, 2, 3, 4, 5, 6]) == 3, "En [1, 2, 3, 4, 5, 6] hay 3 números pares (2, 4 y 6)"
assert main.contar_pares([10, 20, 30, 40]) == 4, "En [10, 20, 30, 40] los 4 son pares"
assert main.contar_pares([7, 9, 11]) == 0, "En [7, 9, 11] hay 0 números pares"

print("✓ ¡Combinaste for + if + operador módulo como un verdadero programador!")
$TEST$
  );

  -- ============================================================================
  -- 🏆 MÓDULO 6: FUNCIONES, LÓGICA EN TEXTOS Y PROYECTO INTEGRADOR EN PYTHON
  -- ============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 6: Funciones, Textos y Retos Integradores en Python',
    'Aprende a modularizar tu lógica, procesar cadenas de texto, resolver el famoso reto FizzBuzz y construir tu primer proyecto integrador.'
  )
  RETURNING id INTO v_m6_id;

  -- Lección 6.1 (Python): Algoritmo del Rey de la Colina en Python (Buscar el Mayor)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m6_id,
    '6.1 Del Papel al Código: Encontrar el Número Mayor de una Lista',
    'Programa por ti mismo el algoritmo del Rey de la Colina que estudiaste en el Módulo 3.',
    'python',
    100,
    1,
    $THEORY$# Programando el Algoritmo de Búsqueda del Mayor

En el Módulo 3 aprendiste en papel cómo encontrar el número más grande de una secuencia sin usar funciones mágicas:
1. Nombramos al primer elemento de la lista (`numeros[0]`) como nuestro `mayor_actual`.
2. Recorremos cada `num` de la lista `numeros`.
3. Si encontramos un `num` que sea mayor que `mayor_actual` (`if num > mayor_actual:`), actualizamos el trono: `mayor_actual = num`.

```python
mayor_actual = numeros[0]   # El índice [0] toma el primer elemento de la lista

for num in numeros:
    if num > mayor_actual:
        mayor_actual = num

return mayor_actual
```

---

### 🎯 Tu Misión en este Ejercicio:

Implementa la función `encontrar_maximo(numeros)` aplicando exactamente el patrón del campeón provisional (`mayor_actual`) para devolver el valor más alto de la lista.$THEORY$,
    $INIT$def encontrar_maximo(numeros):
    # 1. Empezamos tomando el primer elemento de la lista como mayor provisional
    mayor_actual = numeros[0]
    
    # 2. Recorre cada número y actualiza 'mayor_actual' si encuentras uno más grande
    for num in numeros:
        if :
            mayor_actual = 
            
    return mayor_actual
$INIT$,
    $SOL$def encontrar_maximo(numeros):
    mayor_actual = numeros[0]
    for num in numeros:
        if num > mayor_actual:
            mayor_actual = num
    return mayor_actual
$SOL$,
    $TEST$import main

assert main.encontrar_maximo([14, 28, 9, 35, 20]) == 35, "El mayor de [14, 28, 9, 35, 20] es 35"
assert main.encontrar_maximo([-10, -5, -20, -2]) == -2, "Con números negativos [-10, -5, -20, -2] el mayor es -2"
assert main.encontrar_maximo([100]) == 100, "En [100] el mayor es 100"

print("✓ ¡Algoritmo de búsqueda del máximo implementado con éxito!")
$TEST$
  );

  -- Lección 6.2 (Python): Recorrer Textos y Contar Vocales
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m6_id,
    '6.2 Procesamiento de Textos: Contar Vocales en una Palabra',
    'Descubre cómo un texto puede recorrerse letra por letra igual que una lista.',
    'python',
    100,
    2,
    $THEORY$# Los Textos (`str`) como Filas de Letras

En Python, una cadena de texto como `"Hola"` puede recorrerse **letra por letra** con un ciclo `for`, exactamente igual que una lista:

```python
palabra = "Sol"
for letra in palabra:
    print(letra)  # En la vuelta 1 es "S", en la vuelta 2 es "o", en la vuelta 3 es "l"
```

---

### Dos Herramientas Muy Útiles para Textos:

1. **Convertir todo a minúsculas (`.lower()`):**
   Si queremos buscar vocales sin preocuparnos de si están en mayúscula (`"A"`) o minúscula (`"a"`), convertimos el texto primero con `texto.lower()`:
   `"HOLA".lower()` → `"hola"`.
2. **El operador `in` (Pertenece a):**
   Para saber si una letra es una vocal, en lugar de escribir 5 comparaciones con `or`, podemos preguntar:
   ```python
   if letra in "aeiou":
       # ¡La letra es una vocal!
   ```

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `contar_vocales(texto)`:
1. Convierte `texto` a minúsculas con `texto_limpio = texto.lower()`.
2. Recorre cada `letra` en `texto_limpio` y suma `1` a tu contador cada vez que `letra in "aeiou"` sea verdadero.$THEORY$,
    $INIT$def contar_vocales(texto):
    texto_limpio = texto.lower()
    contador = 0
    
    for letra in texto_limpio:
        if letra in "aeiou":
            # Incrementa el contador en 1
            
    return contador
$INIT$,
    $SOL$def contar_vocales(texto):
    texto_limpio = texto.lower()
    contador = 0
    for letra in texto_limpio:
        if letra in "aeiou":
            contador = contador + 1
    return contador
$SOL$,
    $TEST$import main

assert main.contar_vocales("Algoritmo") == 4, "La palabra 'Algoritmo' tiene 4 vocales (A, o, i, o)"
assert main.contar_vocales("PYTHON") == 1, "La palabra 'PYTHON' tiene 1 vocal (O)"
assert main.contar_vocales("Educacion") == 5, "La palabra 'Educacion' tiene 5 vocales"

print("✓ ¡Excelente procesamiento de cadenas de texto en Python!")
$TEST$
  );

  -- Lección 6.3 (Python): El Clásico de Entrevistas: FizzBuzz
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m6_id,
    '6.3 El Clásico de Entrevistas Técnicas: Lógica FizzBuzz',
    'Resuelve el problema de lógica más famoso del mundo cuidando el orden de las preguntas en tu diagrama de flujo.',
    'python',
    110,
    3,
    $THEORY$# El Problema de Lógica Más Famoso: *FizzBuzz*

En miles de entrevistas de trabajo para programadores se hace esta pregunta porque evalúa si sabes **ordenar correctamente los rombos de decisión**.

### Las Reglas de FizzBuzz para un número `n`:
1. Si `n` es múltiplo de **3 Y de 5 al mismo tiempo** (ej: `15`, `30`), devuelve `"FizzBuzz"`.
2. Si `n` es múltiplo **solo de 3** (ej: `3`, `6`, `9`), devuelve `"Fizz"`.
3. Si `n` es múltiplo **solo de 5** (ej: `5`, `10`, `20`), devuelve `"Buzz"`.
4. Si no es múltiplo ni de 3 ni de 5 (ej: `7`), devuelve el número convertido a texto con `str(n)`.

---

### ¿Por qué el orden de los rombos es vital?

Observa qué pasa si preguntas primero `¿n % 3 == 0?` cuando llega el número `15`:
Como `15` sí es divisible por `3`, entraría al primer camino y devolvería `"Fizz"` ¡sin llegar a enterarse de que también era divisible por `5`!

Por eso, en todo diagrama de flujo condicional, **siempre preguntamos primero la condición MÁS ESPECÍFICA (`n % 3 == 0 and n % 5 == 0`)**:

```flowchart
                   ╱────────────────────╱
                  ╱     Entrada: n     ╱
                 ╱──────────┬─────────╱
                            ▼
                          ╱   ╲
    ┌── [ SÍ ] ── ❬¿n%3==0 and n%5==0?❭ ── [ NO ] ──┐
    ▼                     ╲   ╱                      ▼
"FizzBuzz"                  ▽                      ╱   ╲
                            ┌─── [ SÍ ] ─── ❬ ¿n%3==0? ❭ ─── [ NO ] ───┐
                            ▼                      ╲   ╱               ▼
                         "Fizz"                      ▽               ╱   ╲
                                                   ┌── [ SÍ ] ── ❬¿n%5==0?❭ ── [ NO ] ──┐
                                                   ▼                 ╲   ╱              ▼
                                                "Buzz"                 ▽             str(n)
```

---

### 🎯 Tu Misión en este Ejercicio:

Completa la función `evaluar_fizzbuzz(n)` respetando el orden del diagrama de flujo.$THEORY$,
    $INIT$def evaluar_fizzbuzz(n):
    if n % 3 == 0 and n % 5 == 0:
        return "FizzBuzz"
    elif :
        return "Fizz"
    elif :
        return "Buzz"
    else:
        return str(n)
$INIT$,
    $SOL$def evaluar_fizzbuzz(n):
    if n % 3 == 0 and n % 5 == 0:
        return "FizzBuzz"
    elif n % 3 == 0:
        return "Fizz"
    elif n % 5 == 0:
        return "Buzz"
    else:
        return str(n)
$SOL$,
    $TEST$import main

assert main.evaluar_fizzbuzz(15) == "FizzBuzz", "Para 15 (múltiplo de 3 y 5) debe devolver 'FizzBuzz'"
assert main.evaluar_fizzbuzz(30) == "FizzBuzz", "Para 30 debe devolver 'FizzBuzz'"
assert main.evaluar_fizzbuzz(9) == "Fizz", "Para 9 (múltiplo de 3) debe devolver 'Fizz'"
assert main.evaluar_fizzbuzz(10) == "Buzz", "Para 10 (múltiplo de 5) debe devolver 'Buzz'"
assert main.evaluar_fizzbuzz(7) == "7", "Para 7 debe devolver '7'"

print("✓ ¡Superaste el clásico FizzBuzz con lógica impecable!")
$TEST$
  );

  -- Lección 6.4 (Python): Proyecto Integrador de Introducción a la Programación
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, order_index, theory, initial_code, solution_code, test_code)
  VALUES (
    v_m6_id,
    '6.4 Proyecto Final: Sistema Analizador de Calificaciones',
    'Integra variables, acumuladores, contadores, búsqueda de máximo, bucles y condicionales en un solo programa completo.',
    'python',
    150,
    4,
    $THEORY$# 🏆 Proyecto Final Integrador: Analizador Académico

¡Felicitaciones por llegar a la última lección del curso! En este proyecto combinarás **todas las herramientas** que aprendiste desde el Módulo 1 hasta hoy en un solo algoritmo real.

---

### El Problema a Resolver:

Un profesor tiene una lista con las calificaciones finales de sus estudiantes (por ejemplo: `[80, 50, 95, 70]`). Necesita una función llamada `analizar_curso(notas)` que recorra la lista y calcule 3 indicadores:
1. **`promedio`**: La suma de todas las notas dividida entre la cantidad total de notas (`len(notas)`).
2. **`nota_maxima`**: La calificación más alta de la lista.
3. **`aprobados`**: Cuántos estudiantes obtuvieron una nota **mayor o igual a `60`**.

```flowchart
                   ╭───────────────────────────────────╮
                   │     ENTRADA: lista de 'notas'     │
                   ╰─────────────────┬─────────────────╯
                                     ▼
            ┌─────────────────────────────────────────────────┐
            │ Inicializar:                                    │
            │   suma ← 0                                      │
            │   aprobados ← 0                                 │
            │   nota_maxima ← notas[0]                        │
            └────────────────────────┬────────────────────────┘
                                     ▼
            ┌─────────────────────────────────────────────────┐
            │ Ciclo for nota in notas:                        │
            │   1. Sumar 'nota' a 'suma'                      │
            │   2. Si nota >= 60 ──► sumar 1 a 'aprobados'    │
            │   3. Si nota > nota_maxima ──► actualizar máxima│
            └────────────────────────┬────────────────────────┘
                                     ▼
            ┌─────────────────────────────────────────────────┐
            │ Calcular: promedio ← suma / len(notas)          │
            └────────────────────────┬────────────────────────┘
                                     ▼
                   ╭───────────────────────────────────╮
                   │  SALIDA: Diccionario de reporte   │
                   ╰───────────────────────────────────╯
```

---

### 🎯 Tu Misión Final:

Completa la función `analizar_curso(notas)` para que calcule `suma`, `aprobados`, `nota_maxima` y `promedio`, y finalmente devuelva el diccionario con los tres resultados.$THEORY$,
    $INIT$def analizar_curso(notas):
    suma = 0
    aprobados = 0
    nota_maxima = notas[0]
    
    for nota in notas:
        # 1. Acumula la nota en 'suma'
        suma = suma + nota
        
        # 2. Si la nota es >= 60, incrementa 'aprobados' en 1
        if nota >= 60:
            aprobados = 
            
        # 3. Si la nota es mayor que 'nota_maxima', actualiza 'nota_maxima'
        if nota > nota_maxima:
            nota_maxima = 
            
    promedio = suma / len(notas)
    
    return {
        "promedio": promedio,
        "nota_maxima": nota_maxima,
        "aprobados": aprobados
    }
$INIT$,
    $SOL$def analizar_curso(notas):
    suma = 0
    aprobados = 0
    nota_maxima = notas[0]
    
    for nota in notas:
        suma = suma + nota
        if nota >= 60:
            aprobados = aprobados + 1
        if nota > nota_maxima:
            nota_maxima = nota
            
    promedio = suma / len(notas)
    
    return {
        "promedio": promedio,
        "nota_maxima": nota_maxima,
        "aprobados": aprobados
    }
$SOL$,
    $TEST$import main

reporte1 = main.analizar_curso([80, 50, 90, 60])
assert isinstance(reporte1, dict), "La función debe devolver un diccionario"
assert abs(reporte1["promedio"] - 70.0) < 0.01, f"El promedio de [80, 50, 90, 60] debe ser 70.0, pero dio {reporte1['promedio']}"
assert reporte1["nota_maxima"] == 90, f"La nota máxima debe ser 90, pero dio {reporte1['nota_maxima']}"
assert reporte1["aprobados"] == 3, f"La cantidad de aprobados (>= 60) debe ser 3, pero dio {reporte1['aprobados']}"

reporte2 = main.analizar_curso([40, 55, 100, 85, 70])
assert abs(reporte2["promedio"] - 70.0) < 0.01, "El promedio de [40, 55, 100, 85, 70] debe ser 70.0"
assert reporte2["nota_maxima"] == 100, "La nota máxima debe ser 100"
assert reporte2["aprobados"] == 3, "Hay 3 aprobados (100, 85 y 70)"

print("🎉 ¡FELICITACIONES! Completaste el Proyecto Final de Introducción a la Programación.")
$TEST$
  );

  -- ============================================================================
  -- 🎓 FASE 3: CERTIFICACIÓN OFICIAL VERIFICABLE (CERT-INTRO-PROG)
  -- ============================================================================
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
    'Certificación en Fundamentos de Programación, Diagramas de Flujo y Python Inicial',
    'CERT-INTRO-PROG',
    'Acredita el dominio del pensamiento algorítmico, el modelo Entrada-Proceso-Salida, lectura y diseño de diagramas de flujo ISO 5807, pruebas de escritorio, lógica booleana y programación estructurada inicial en Python.',
    80,
    25,
    500,
    'emerald',
    ARRAY[
      'Pensamiento Algorítmico y Modelo IPO',
      'Diagramas de Flujo Estándar ISO 5807',
      'Pruebas de Escritorio y Rastreo de Variables',
      'Lógica Booleana y Aritmética Modular',
      'Programación Estructurada en Python'
    ]
  )
  RETURNING id INTO v_cert_id;

  -- 15 Preguntas de Examen de Certificación
  INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation)
  VALUES
  (
    v_cert_id,
    '¿Cuáles son las tres propiedades esenciales que definen a todo algoritmo informático válido?',
    ARRAY[
      'Preciso (sin ambigüedades), Definido (determinista) y Finito (con un final)',
      'Infinito, escrito en código binario y ejecutado en la nube',
      'Visual, aproximado y dependiente de la velocidad del procesador',
      'Tener al menos 100 líneas de código, usar bases de datos y conexión de red'
    ],
    0,
    'Todo algoritmo debe ser preciso, definido (la misma entrada produce siempre la misma salida) y finito.'
  ),
  (
    v_cert_id,
    'Según el estándar internacional ISO 5807 para Diagramas de Flujo, ¿qué figura representa una pregunta lógica o condición que divide el flujo en Sí y No?',
    ARRAY[
      'El Rectángulo',
      'El Paralelogramo',
      'El Rombo (Diamante)',
      'El Óvalo (Terminal)'
    ],
    2,
    'El Rombo representa un punto de decisión condicional con al menos dos salidas rotuladas (Sí/Verdadero y No/Falso).'
  ),
  (
    v_cert_id,
    'En un diagrama de flujo, ¿qué figura geométrica se utiliza para la operación de asignar el cálculo `total ← precio * cantidad`?',
    ARRAY[
      'El Paralelogramo de Entrada/Salida',
      'El Rectángulo de Proceso',
      'El Rombo de Decisión',
      'El Óvalo de Inicio/Fin'
    ],
    1,
    'El Rectángulo representa cualquier operación interna de proceso, cálculo aritmético o asignación en memoria.'
  ),
  (
    v_cert_id,
    'Realiza la prueba de escritorio: Si inicialmente `x = 10` e `y = 4`, y luego se ejecutan las instrucciones `x = x + y` seguida de `y = x - 2`, ¿qué valor final queda en `y`?',
    ARRAY[
      '8',
      '12',
      '14',
      '6'
    ],
    1,
    'En la primera línea, x pasa a valer 10 + 4 = 14. En la segunda línea, y = 14 - 2 = 12.'
  ),
  (
    v_cert_id,
    '¿Cuál es el resultado exacto de evaluar la expresión aritmética `5 + 2 * (12 - 9)` respetando la precedencia de operadores?',
    ARRAY[
      '21',
      '11',
      '15',
      '9'
    ],
    1,
    'Primero se resuelve el paréntesis (12 - 9) = 3, luego la multiplicación 2 * 3 = 6, y finalmente la suma 5 + 6 = 11.'
  ),
  (
    v_cert_id,
    '¿Qué devuelve el operador módulo `%` en la expresión `19 % 5` y para qué suele utilizarse?',
    ARRAY[
      'Devuelve 3.8 y sirve para calcular promedios con decimales',
      'Devuelve 4 (el residuo o sobrante de dividir 19 entre 5) y es clave para detectar múltiplos o paridad',
      'Devuelve el 19% de 5 como porcentaje financiero',
      'Devuelve 3 (el cociente entero de la división)'
    ],
    1,
    'Como 5 * 3 = 15, al dividir 19 entre 5 sobran 4 unidades. El operador % entrega ese residuo.'
  ),
  (
    v_cert_id,
    '¿Cuál es la condición estándar en Python para verificar si un número entero `n` es PAR?',
    ARRAY[
      'n / 2 == 1',
      'n % 2 == 0',
      'n // 2 == 0',
      'n % 10 == 2'
    ],
    1,
    'Un número es par si al dividirlo entre 2 el residuo es exactamente 0 (n % 2 == 0).'
  ),
  (
    v_cert_id,
    'Si `edad = 20` y `tiene_entrada = False`, ¿cuál es el resultado de evaluar `(edad >= 18) and (tiene_entrada == True)`?',
    ARRAY[
      'True',
      'False',
      '20',
      'Error de sintaxis'
    ],
    1,
    'El operador lógico and exige que AMBAS condiciones sean verdaderas. Como tiene_entrada es False, True and False resulta en False.'
  ),
  (
    v_cert_id,
    '¿Cuál es la diferencia fundamental entre un Contador y un Acumulador dentro de un bucle?',
    ARRAY[
      'El contador incrementa en un valor fijo constante (ej: +1 por vuelta), mientras que el acumulador suma valores variables',
      'El contador solo funciona en bucles for y el acumulador solo en bucles while',
      'El contador guarda textos y el acumulador guarda booleanos',
      'No existe ninguna diferencia, son sinónimos exactos'
    ],
    0,
    'Un contador lleva la cuenta de iteraciones o eventos sumando una constante (como +1), mientras que un acumulador totaliza cantidades variables.'
  ),
  (
    v_cert_id,
    '¿Por qué necesitamos una tercera variable auxiliar (`aux`) para intercambiar los valores de dos variables `a` y `b` de forma tradicional?',
    ARRAY[
      'Porque al hacer `a = b` directamente se sobreescribe y se pierde el valor original que tenía `a`',
      'Porque las computadoras no permiten tener menos de 3 variables por programa',
      'Para que el programa consuma más memoria RAM y se ejecute más rápido',
      'Porque el signo igual solo puede usarse una vez por variable'
    ],
    0,
    'En una variable solo cabe un valor a la vez; si asignamos a = b sin haber respaldado el valor original de a en aux, ese dato se destruye.'
  ),
  (
    v_cert_id,
    'Dado un número entero positivo `n = 749`, ¿qué valores producen respectivamente `n % 10` y `n // 10`?',
    ARRAY[
      'n % 10 da 7 y n // 10 da 49',
      'n % 10 da 9 (último dígito) y n // 10 da 74 (número sin el último dígito)',
      'Ambos dan 74.9',
      'n % 10 da 74 y n // 10 da 9'
    ],
    1,
    'En base 10, el módulo 10 extrae la última cifra de la derecha (9) y la división entera entre 10 recorta esa última cifra dejando 74.'
  ),
  (
    v_cert_id,
    '¿Qué números recorre exactamente la variable `i` en el encabezado `for i in range(1, 5):` en Python?',
    ARRAY[
      '1, 2, 3, 4 y 5',
      '1, 2, 3 y 4 (el límite superior 5 queda excluido)',
      '0, 1, 2, 3, 4 y 5',
      'Solo el 1 y el 5'
    ],
    1,
    'La función range(inicio, fin) comienza en el valor inicial e itera hasta uno antes del valor final (1, 2, 3, 4).'
  ),
  (
    v_cert_id,
    '¿Qué ocurre en un bucle `while i <= 5:` si olvidamos incrementar la variable `i` (`i = i + 1`) dentro del cuerpo del ciclo?',
    ARRAY[
      'Python incrementa la variable automáticamente después de 3 segundos',
      'Se produce un Ciclo Infinito porque la condición nunca deja de ser verdadera',
      'El bucle se ejecuta una sola vez y termina sin errores',
      'La variable i se vuelve negativa'
    ],
    1,
    'A diferencia del bucle for, en un bucle while el programador es responsable de modificar la variable de control para que la condición eventualmente sea falsa.'
  ),
  (
    v_cert_id,
    'En Python, ¿cuál es el propósito de la palabra clave `return` dentro de una función creada con `def`?',
    ARRAY[
      'Borrar todas las variables de la memoria RAM',
      'Reiniciar el programa desde la primera línea',
      'Entregar el resultado final del proceso hacia afuera de la función y finalizar su ejecución',
      'Convertir números decimales en texto'
    ],
    2,
    'La instrucción return representa la Salida formal de una función, devolviendo el valor calculado a quien invocó la función.'
  ),
  (
    v_cert_id,
    'En el problema clásico FizzBuzz, ¿por qué debemos evaluar primero `if n % 3 == 0 and n % 5 == 0:` antes de preguntar `elif n % 3 == 0:`?',
    ARRAY[
      'Porque en una cadena if/elif/else solo se ejecuta la primera rama verdadera; si preguntáramos primero por el 3, el número 15 devolvería solo Fizz sin evaluar si también era múltiplo de 5',
      'Porque Python exige que la palabra and vaya siempre en la primera línea del archivo',
      'Porque el número 3 es menor que el número 5',
      'El orden no importa, daría exactamente el mismo resultado poniéndolo al final'
    ],
    0,
    'En estructuras condicionales excluyentes (if/elif/else), las condiciones más específicas y restrictivas deben evaluarse primero para no ser absorbidas por condiciones más generales.'
  );

END $REESTRUCTURACION_SEED$;
