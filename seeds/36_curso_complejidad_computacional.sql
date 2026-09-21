-- ==============================================================================
-- ⚡ SGFC SEED: 36 - CURSO: COMPLEJIDAD COMPUTACIONAL Y NOTACIÓN ASINTÓTICA
-- ==============================================================================
-- 1. Curso: "Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP"
-- 2. Sistema de Evaluación por Cuadro de Texto (challenge_type = 'input')
-- 3. 4 Módulos Progresivos:
--    - M1: Fundamentos del Análisis de Algoritmos & Notación Asintótica
--    - M2: Análisis Práctico de Bucles y Estructuras de Datos (Cálculo Manual)
--    - M3: Recursión y Ecuaciones de Recurrencia (Árboles y Teorema Maestro)
--    - M4: Teoría de Complejidad Avanzada y Clases P vs NP
-- 4. 16 Lecciones con teoría profunda y ejercicios prácticos de respuesta tipeada.
-- 5. Certificación Oficial Verificable "CERT-COMPLEXITY" con 15 preguntas de examen.
-- ==============================================================================

DO $COMPLEXITY_SEED$
DECLARE
  v_author_id UUID;
  v_course_id UUID;
  v_m1_id UUID;
  v_m2_id UUID;
  v_m3_id UUID;
  v_m4_id UUID;
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
    WHERE co.title = 'Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP'
  );
  DELETE FROM public.certification_questions WHERE certification_id IN (
    SELECT id FROM public.certifications WHERE code = 'CERT-COMPLEXITY'
  );
  DELETE FROM public.certifications WHERE code = 'CERT-COMPLEXITY';
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT m.id FROM public.modules m
    JOIN public.courses co ON m.course_id = co.id
    WHERE co.title = 'Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP'
  );
  DELETE FROM public.modules WHERE course_id IN (
    SELECT id FROM public.courses WHERE title = 'Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP'
  );
  DELETE FROM public.courses WHERE title = 'Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP';

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
    'Complejidad Computacional y Notación Asintótica: De Big-O a P vs NP',
    'Aprende a medir la eficiencia matemática de algoritmos sin depender del hardware ni del lenguaje. Domina la notación Big-O, análisis de bucles simples y anidados, árboles de recursión, el Teorema Maestro y las clases de complejidad P, NP y NP-Completitud con ejercicios prácticos manuales.',
    $SUMMARY$## ⚡ La Ciencia de Medir Algoritmos: De Big-O a P vs NP

¿Alguna vez te has preguntado por qué un algoritmo tarda 0.01 segundos con 1.000 datos, pero se congela durante 3 horas cuando la entrada sube a 100.000? ¿O por qué tu empresa gasta miles de dólares en servidores adicionales cuando el verdadero problema era un bucle cuadrático $O(n^2)$ oculto en el código?

La **Complejidad Computacional** es el pilar matemático fundamental de las Ciencias de la Computación. Nos permite predecir con exactitud científica cómo escalará el consumo de tiempo y memoria de un programa a medida que el tamaño de entrada $n$ tiende al infinito, sin importar si corre en un smartphone de gama baja o en una supercomputadora cuántica.

---

### 🎯 Lo que dominarás en este curso:

1. **El Modelo Matemático de Computación:** Por qué los benchmarks de tiempo en segundos mienten y cómo contar operaciones elementales sobre el modelo RAM.
2. **Notación Asintótica Rigurosa:** Diferencia matemática formal entre Big-O ($O$, cota superior peor caso), Big-Omega ($\Omega$, cota inferior mejor caso) y Big-Theta ($\Theta$, cota ajustada).
3. **Análisis de Bucles y Series Matemáticas:** Técnicas para deducir la complejidad de bucles dependientes $\sum_{i=1}^n i = \frac{n(n+1)}{2}$, progresiones multiplicativas $O(\log n)$ y trade-offs de memoria auxiliar.
4. **Recursión y Teorema Maestro:** Resolución de ecuaciones de recurrencia mediante árboles de expansión y la fórmula universal del Master Theorem $T(n) = aT(n/b) + f(n)$.
5. **Teoría de Complejidad y Fronteras del Conocimiento:** Las clases de decisión P y NP, reducciones polinomiales, problemas NP-Completos (SAT, TSP, Mochila) y el enigma del Premio del Milenio: ¿$P = NP$?.
6. **Ejercicios Prácticos con Cuadro de Texto:** En cada lección resolverás problemas de análisis a mano o en tu máquina y escribirás la notación exacta en el cuadro interactivo.
$SUMMARY$,
    ARRAY['Algoritmos', 'Matemáticas', 'Complejidad', 'Big-O', 'Ciencias de la Computación', 'Estructuras de Datos'],
    2,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: FUNDAMENTOS DEL ANÁLISIS DE ALGORITMOS & NOTACIÓN ASINTÓTICA
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 1: Fundamentos del Análisis de Algoritmos & Notación Asintótica',
    'El modelo RAM, operaciones elementales, cotas Big-O, Big-Omega y Big-Theta, y las familias de crecimiento.'
  )
  RETURNING id INTO v_m1_id;

  -- Lección 1.1 (Input): ¿Por qué medir operaciones y no segundos?
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '1. El Modelo RAM: Medir Operaciones en vez de Segundos',
    'Descubre por qué medir tiempo en segundos es engañoso y aprende a contar operaciones elementales a mano.',
    'input',
    100,
    $THEORY$# El Modelo RAM y las Operaciones Elementales

Cuando un programador novato quiere saber qué tan rápido es su algoritmo, suele escribir:
```javascript
const inicio = performance.now();
ejecutarAlgoritmo();
const fin = performance.now();
console.log(`Tardó ${fin - inicio} milisegundos`);
```

### ¿Por qué este enfoque es un engaño?
El tiempo en segundos depende de variables externas ajenas a la calidad del algoritmo:
1. La velocidad del procesador y la frecuencia del reloj (2.0 GHz vs 4.5 GHz).
2. Si la CPU está ejecutando otros programas en segundo plano (Spotify, Docker, el navegador).
3. La optimización del compilador / motor JIT y el lenguaje elegido (C++ vs Python).
4. La temperatura del chip y el *thermal throttling*.

---

### El Modelo RAM (Random Access Machine)
En ciencias de la computación utilizamos el **Modelo RAM**, un modelo teórico donde:
- El acceso a cualquier celda de memoria tarda **1 unidad de tiempo constante**.
- Cada **Operación Elemental** cuesta exactamente **1 paso**:
  - Asignación de variable: `x = 5` (1 paso)
  - Operación aritmética básica: `a + b`, `x * y` (1 paso)
  - Comparación lógica: `if (x > 10)` (1 paso)
  - Acceso a un índice de arreglo: `arr[i]` (1 paso)
  - Retorno de función: `return total` (1 paso)

---

### Ejemplo de Conteo Manual:
Analicemos la función para sumar los primeros $n$ números enteros:

```python
def suma_enteros(n):
    total = 0               # 1 asignación
    for i in range(1, n + 1): # Inicialización (1), n comparaciones, n incrementos
        total = total + i   # n sumas + n asignaciones
    return total            # 1 retorno
```

El número total de operaciones elementales es una función exacta:
$$T(n) = 1 + 1 + n + n + n + n + 1 = 4n + 3\text{ operaciones}$$

Si $n = 10$, el algoritmo ejecuta exactamente $4(10) + 3 = 43$ operaciones elementales, sin importar en qué computadora se ejecute.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Considera el siguiente código:\n\n```python\ndef calcular(n):\n    x = 10\n    y = 20\n    total = x + y\n    for i in range(n):\n        total = total + 5\n    return total\n```\n\nSi cada línea elemental dentro del bucle suma 1 operación por iteración y las 3 asignaciones iniciales más el return suman 4 operaciones constantes:\n\n**¿Cuántas operaciones elementales exactas ejecuta la función para n = 100?**",
        "placeholder": "Escribe el número entero exacto...",
        "expectedAnswer": "104",
        "acceptedAnswers": ["104", "104 operaciones", "104 pasos"],
        "inputMode": "numeric",
        "explanation": "Hay 4 operaciones constantes fuera del bucle (x=10, y=20, total=x+y, return total) más 100 operaciones dentro del bucle (1 por cada iteración de n=100). Total: 4 + 100 = 104 operaciones."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "En el modelo teórico RAM de computación, ¿cuál es el costo asintótico en tiempo para acceder a un elemento en un arreglo en una posición conocida arr[i]?",
        "placeholder": "Ej: O(1) o O(n)",
        "expectedAnswer": "O(1)",
        "acceptedAnswers": ["O(1)", "o(1)", "1", "constante", "O( 1 )"],
        "inputMode": "big-o",
        "explanation": "El acceso por índice a memoria en el modelo RAM se realiza mediante aritmética de punteros en tiempo estrictamente constante: O(1)."
      }
    ]$JSON$,
    1
  );

  -- Lección 1.2 (Input): Notación Big-O, Big-Omega y Big-Theta
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '2. Notaciones Asintóticas: Big-O, Big-Omega y Big-Theta',
    'Diferencia formalmente entre cota superior, cota inferior y cota ajustada con ejercicios manuales.',
    'input',
    100,
    $THEORY$# Las Tres Cotas Asintóticas: $O$, $\Omega$ y $\Theta$

Cuando analizamos algoritmos no nos interesa saber si ejecuta 43 o 44 operaciones para $n=10$. Nos interesa **cómo escala la función cuando $n \to \infty$** (análisis asintótico).

Existen tres símbolos matemáticos formales introducidos por Paul Bachmann y Edmund Landau:

```text
Cota Superior (Peor Caso)      Cota Ajustada (Exacta)       Cota Inferior (Mejor Caso)
       f(n) <= c * g(n)            c1*g(n) <= f(n) <= c2*g(n)         f(n) >= c * g(n)
         O (Big-O)                   Theta (Big-Theta)               Omega (Big-Omega)
```

---

### 1. Big-O ($O$): La Cota Superior Asintótica
Garantiza que el algoritmo **nunca tardará más** que un múltiplo de $g(n)$ para valores suficientemente grandes de $n$.
$$\exists c > 0, n_0 > 0 \quad \text{tal que} \quad 0 \le f(n) \le c \cdot g(n) \quad \forall n \ge n_0$$
*Es la métrica más utilizada en ingeniería de software porque representa la garantía del peor escenario posible (Worst-Case Guarantee).*

### 2. Big-Omega ($\Omega$): La Cota Inferior Asintótica
Garantiza que el algoritmo **requerirá al menos** ese esfuerzo.
$$0 \le c \cdot g(n) \le f(n) \quad \forall n \ge n_0$$
*Por ejemplo: cualquier algoritmo de ordenamiento basado en comparaciones requiere como mínimo $\Omega(n \log n)$ comparaciones en el peor caso.*

### 3. Big-Theta ($\Theta$): La Cota Ajustada (Tight Bound)
Existe si y solo si una función está acotada tanto superior como inferiormente por la misma función:
$$f(n) = \Theta(g(n)) \iff f(n) = O(g(n)) \quad \text{y} \quad f(n) = \Omega(g(n))$$
Si una función toma $3n^2 + 5n$, su cota ajustada exacta es $\Theta(n^2)$.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Dada la función de tiempo de ejecución f(n) = 7n^3 + 20n^2 + 100n + 450, ¿cuál es su cota asintótica superior simplificada en notación Big-O?",
        "placeholder": "Ej: O(n^2) o O(n^3)",
        "expectedAnswer": "O(n^3)",
        "acceptedAnswers": ["O(n^3)", "O(n**3)", "n^3", "n**3", "O(n ^ 3)"],
        "inputMode": "big-o",
        "explanation": "En el análisis asintótico se descartan los coeficientes constantes y los términos de menor orden. El término de mayor crecimiento es 7n^3, por lo que la cota Big-O es O(n^3)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Qué símbolo asintótico (O, Omega o Theta) se utiliza formalmente cuando queremos describir la cota ajustada exacta que acota a la función tanto por arriba como por abajo simultáneamente?",
        "placeholder": "Escribe Theta, O o Omega...",
        "expectedAnswer": "Theta",
        "acceptedAnswers": ["Theta", "Big-Theta", "Big Theta", "θ", "Θ"],
        "inputMode": "text",
        "explanation": "La notación Big-Theta (Θ) define una cota asintóticamente ajustada (tight bound), es decir, acota a la función entre dos constantes c1*g(n) y c2*g(n)."
      }
    ]$JSON$,
    2
  );

  -- Lección 1.3 (Input): La Jerarquía de Complejidades
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '3. La Jerarquía de Complejidades: De O(1) a O(n!)',
    'Aprende a reconocer el impacto práctico de cada orden de crecimiento cuando n crece.',
    'input',
    100,
    $THEORY$# La Jerarquía de Órdenes de Complejidad

Para entender por qué Big-O importa tanto en sistemas reales, observa la velocidad con la que explota el número de operaciones para una entrada modesta de $n = 100$:

```text
+-----------------------+-------------------+----------------------------+-----------------------+
| Notación              | Nombre            | Operaciones para n = 100   | Veredicto Práctico    |
+-----------------------+-------------------+----------------------------+-----------------------+
| O(1)                  | Constante         | 1                          | Instantáneo           |
| O(log n)              | Logarítmica       | ~7                         | Ultrarrápido          |
| O(n)                  | Lineal            | 100                        | Excelente             |
| O(n log n)            | Linearítmica      | ~700                       | Muy Bueno (Sorts)     |
| O(n^2)                | Cuadrática        | 10,000                     | Peligroso en prod     |
| O(n^3)                | Cúbica            | 1,000,000                  | Inviable para n grande|
| O(2^n)                | Exponencial       | 1.26 x 10^30               | Colapso absoluto      |
| O(n!)                 | Factorial         | 9.33 x 10^157              | Más que átomos universo|
+-----------------------+-------------------+----------------------------+-----------------------+
```

### Regla Fundamental:
$$O(1) < O(\log n) < O(\sqrt{n}) < O(n) < O(n \log n) < O(n^2) < O(n^3) < O(2^n) < O(n!)$$

- **$O(1)$ Constante:** Acceso a arreglo por índice `arr[i]`, insertar o leer en un HashMap promedio.
- **$O(\log n)$ Logarítmica:** Búsqueda binaria en lista ordenada, balanceo en árboles AVL / Red-Black.
- **$O(n)$ Lineal:** Recorrer una lista completa, encontrar el máximo con un bucle simple.
- **$O(n \log n)$ Linearítmica:** Algoritmos óptimos de ordenamiento por comparación (MergeSort, HeapSort).
- **$O(n^2)$ Cuadrática:** Dos bucles anidados completos, BubbleSort, InsertionSort.
- **$O(2^n)$ Exponencial:** Búsqueda exhaustiva por fuerza bruta de subconjuntos, Torres de Hanói.
- **$O(n!)$ Factorial:** Generar todas las permutaciones de una lista (Viajante de comercio por fuerza bruta).
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Si un algoritmo procesa n = 16 elementos y realiza exactamente 4 operaciones, y con n = 1024 elementos realiza exactamente 10 operaciones, ¿a qué familia de complejidad asintótica pertenece (sabiendo que 2^4 = 16 y 2^10 = 1024)?",
        "placeholder": "Ej: O(n) o O(log n)",
        "expectedAnswer": "O(log n)",
        "acceptedAnswers": ["O(log n)", "O(logn)", "log n", "logn", "O( log n )", "O(log(n))"],
        "inputMode": "big-o",
        "explanation": "Como el número de operaciones equivale a la potencia en base 2 (log2(16) = 4, log2(1024) = 10), la complejidad temporal es logarítmica: O(log n)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Entre O(n^2) y O(n log n), ¿cuál de las dos complejidades es asintóticamente más eficiente (más rápida) cuando n es muy grande?",
        "placeholder": "Escribe O(n log n) o O(n^2)...",
        "expectedAnswer": "O(n log n)",
        "acceptedAnswers": ["O(n log n)", "O(nlogn)", "n log n", "nlogn"],
        "inputMode": "big-o",
        "explanation": "O(n log n) crece mucho más lentamente que O(n^2). Para n = 1.000.000, n log n son unos 20 millones de operaciones, mientras que n^2 son 1 billón de operaciones."
      }
    ]$JSON$,
    3
  );

  -- Lección 1.4 (Input): Reglas de Álgebra Asintótica
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '4. Álgebra Asintótica: Regla de la Suma y del Producto',
    'Aprende a simplificar expresiones complejas identificando términos dominantes e iteraciones anidadas.',
    'input',
    100,
    $THEORY$# Álgebra de Notación Big-O

Para calcular la complejidad de un algoritmo real no necesitas calcular integrales ni límites complejos. Basta con aplicar dos reglas algebraicas fundamentales:

---

### 1. Regla de la Suma (Término Dominante)
Si un algoritmo realiza dos tareas consecutivas independientes:
$$T(n) = T_1(n) + T_2(n) \implies O(T_1(n) + T_2(n)) = \max(O(T_1(n)), O(T_2(n)))$$

**Ejemplo en Código:**
```python
def procesar(lista):
    # Tarea 1: Búsqueda lineal -> O(n)
    for x in lista:
        print(x)
        
    # Tarea 2: Dos bucles anidados -> O(n^2)
    for i in lista:
        for j in lista:
            hacer_algo(i, j)
```
La complejidad total es $O(n + n^2) = \mathbf{O(n^2)}$. El término lineal $n$ se vuelve insignificante comparado con $n^2$ cuando $n$ crece.

---

### 2. Regla del Producto (Bucles Anidados)
Si una tarea se repite dentro de otra tarea:
$$T(n) = T_1(n) \times T_2(n) \implies O(T_1(n) \times T_2(n)) = O(T_1(n)) \times O(T_2(n))$$

**Ejemplo:** Un bucle exterior de $n$ vueltas que en cada iteración llama a una función que tarda $O(\log n)$ resulta en:
$$O(n) \times O(\log n) = \mathbf{O(n \log n)}$$

---

### 3. Ignorar Coeficientes Constantes
Para cualquier constante $k > 0$:
$$O(k \cdot f(n)) = O(f(n))$$
Un algoritmo que realiza $500 \cdot n$ pasos sigue siendo **$O(n)$** lineal. Aunque tarde más en una prueba pequeña, su tasa de crecimiento es idénticamente lineal al duplicar $n$.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Aplica la regla de la suma para simplificar la siguiente función a su cota Big-O dominante:\n\n`f(n) = 3n⁴ + 500n² + 20n + 10000`",
        "placeholder": "Ej: O(n^4)",
        "expectedAnswer": "O(n^4)",
        "acceptedAnswers": ["O(n^4)", "O(n**4)", "n^4", "n**4", "O(n ^ 4)"],
        "inputMode": "big-o",
        "explanation": "El término de mayor exponente y crecimiento más acelerado es 3n^4. Descartando la constante multiplicativa 3 y los términos inferiores, la cota Big-O es O(n^4)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Si un programa ejecuta un bucle de n vueltas, y dentro de cada vuelta ejecuta una búsqueda binaria que tarda O(log n), ¿cuál es la complejidad resultante aplicando la regla del producto?",
        "placeholder": "Ej: O(n log n)",
        "expectedAnswer": "O(n log n)",
        "acceptedAnswers": ["O(n log n)", "O(nlogn)", "n log n", "nlogn", "O(n*log(n))"],
        "inputMode": "big-o",
        "explanation": "Por la regla del producto para operaciones anidadas: O(n) * O(log n) = O(n log n)."
      }
    ]$JSON$,
    4
  );

  -- ==============================================================================
  -- MÓDULO 2: ANÁLISIS PRÁCTICO DE BUCLES Y ESTRUCTURAS DE DATOS
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 2: Análisis Práctico de Bucles y Estructuras de Datos',
    'Deducción manual de bucles lineales, multiplicativos, bucles dependientes y trade-offs de memoria auxiliar.'
  )
  RETURNING id INTO v_m2_id;

  -- Lección 2.1 (Input): Bucles Multiplicativos
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '5. Análisis de Bucles: Saltos Multiplicativos (i *= 2)',
    'Calcula a mano la cantidad exacta de iteraciones cuando la variable de control se multiplica en cada paso.',
    'input',
    100,
    $THEORY$# Bucles Multiplicativos: El Origen de $O(\log n)$

La mayoría de los bucles incrementan su contador con `i++` o `i += 1`, ejecutándose $n$ veces. Pero, ¿qué ocurre cuando el contador no se suma, sino que **se multiplica**?

```javascript
let i = 1;
while (i < n) {
    console.log(i);
    i = i * 2; // Salto multiplicativo
}
```

---

### Análisis Matemático Paso a Paso:
Tracemos los valores sucesivos que adopta la variable `i`:
- Iteración 1: $i = 1 = 2^0$
- Iteración 2: $i = 2 = 2^1$
- Iteración 3: $i = 4 = 2^2$
- Iteración 4: $i = 8 = 2^3$
- Iteración $k$: $i = 2^{k-1}$

El bucle se detiene cuando $i \ge n$, es decir:
$$2^k \approx n$$

Aplicando el logaritmo en base 2 a ambos lados:
$$\log_2(2^k) = \log_2(n) \implies k = \mathbf{\log_2(n)}$$

Por tanto, este bucle ejecuta aproximadamente **$\log_2(n)$ iteraciones**.
- Para $n = 16$: el bucle da 4 vueltas ($1, 2, 4, 8$).
- Para $n = 1.024$: da 10 vueltas.
- Para $n = 1.000.000$: da apenas 20 vueltas.

La complejidad temporal es estrictamente **$O(\log n)$**.

*Nota análoga:* Un bucle que comienza en $n$ y divide a la mitad en cada paso (`i = Math.floor(i / 2)`) hasta llegar a 1 tiene exactamente la misma complejidad: **$O(\log n)$**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Considera el siguiente bucle en C++:\n\n```cpp\nint i = 1;\nwhile (i <= 64) {\n    i = i * 2;\n}\n```\n\n**Calcula a mano:** ¿Cuántas veces exactas se evalúa el cuerpo del bucle (valores i = 1, 2, 4, 8, 16, 32, 64)?",
        "placeholder": "Escribe el número entero exacto...",
        "expectedAnswer": "7",
        "acceptedAnswers": ["7", "7 veces", "7 iteraciones"],
        "inputMode": "numeric",
        "explanation": "El bucle se ejecuta para i = 1 (2^0), 2 (2^1), 4 (2^2), 8 (2^3), 16 (2^4), 32 (2^5) y 64 (2^6). Son exactamente 7 iteraciones antes de que i pase a 128 y termine."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal asintótica en notación Big-O de una función con un bucle que inicia en n y en cada paso divide i entre 3 (i = i / 3) hasta que i sea menor o igual a 1?",
        "placeholder": "Ej: O(n) o O(log n)",
        "expectedAnswer": "O(log n)",
        "acceptedAnswers": ["O(log n)", "O(logn)", "log n", "logn", "O(log3(n))"],
        "inputMode": "big-o",
        "explanation": "Cualquier reducción o incremento multiplicativo sucesivo por una constante (sea 2, 3 o 10) genera una tasa de crecimiento logarítmica: O(log n)."
      }
    ]$JSON$,
    5
  );

  -- Lección 2.2 (Input): Bucles Anidados Dependientes
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '6. Bucles Anidados Dependientes y Series Aritméticas',
    'Aprende a calcular la sumatoria de Gauss cuando el bucle interno depende del índice del externo.',
    'input',
    100,
    $THEORY$# Bucles Anidados Dependientes y Series de Gauss

Un error muy común entre principiantes es asumir que "dos bucles anidados siempre son $n \times n = O(n^2)$". Para demostrarlo rigurosamente, debemos aprender a resolver **bucles dependientes**.

```python
for i in range(n):
    for j in range(i, n):
        operacion_elemental()
```

Observa que el bucle interno **no siempre da $n$ vueltas**. Su número de repeticiones depende del valor actual de `i`:
- Cuando $i = 0$: el bucle $j$ itera $n$ veces.
- Cuando $i = 1$: el bucle $j$ itera $n - 1$ veces.
- Cuando $i = 2$: el bucle $j$ itera $n - 2$ veces.
- ...
- Cuando $i = n - 1$: el bucle $j$ itera $1$ sola vez.

---

### La Sumatoria de Gauss
El número total de ejecuciones es la suma de los primeros $n$ números naturales:
$$S = n + (n - 1) + (n - 2) + \dots + 2 + 1 = \sum_{k=1}^n k$$

La famosa fórmula deducida por Carl Friedrich Gauss establece:
$$\sum_{k=1}^n k = \frac{n(n + 1)}{2} = \frac{n^2 + n}{2} = \mathbf{\frac{1}{2}n^2 + \frac{1}{2}n}$$

Aplicando las reglas asintóticas de Big-O:
1. Descartamos el término lineal de menor orden $\frac{1}{2}n$.
2. Descartamos la constante multiplicativa $\frac{1}{2}$.
3. Resultado final: **$O(n^2)$**.

Aunque ejecuta aproximadamente la mitad de pasos que un bucle $n \times n$ completo, su tasa de crecimiento sigue siendo cuadrática.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Calcula a mano usando la fórmula `n(n + 1) / 2`:\n\n**¿Cuántas operaciones exactas realiza el bucle anidado dependiente si el tamaño de entrada es n = 10?**",
        "placeholder": "Escribe el resultado numérico...",
        "expectedAnswer": "55",
        "acceptedAnswers": ["55", "55 operaciones", "55 pasos"],
        "inputMode": "numeric",
        "explanation": "Aplicando la fórmula de Gauss para n = 10: (10 * 11) / 2 = 110 / 2 = 55 operaciones."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal asintótica en notación Big-O del algoritmo que ejecuta (n^2 + n)/2 operaciones?",
        "placeholder": "Ej: O(n^2)",
        "expectedAnswer": "O(n^2)",
        "acceptedAnswers": ["O(n^2)", "O(n**2)", "n^2", "n**2", "O(n ^ 2)"],
        "inputMode": "big-o",
        "explanation": "Descartando la constante 1/2 y el término lineal de menor orden n/2, la cota asintótica superior es cuadrática: O(n^2)."
      }
    ]$JSON$,
    6
  );

  -- Lección 2.3 (Input): Complejidad Espacial
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '7. Complejidad Espacial: Memoria Auxiliar y Pila de Llamadas',
    'Aprende a medir el consumo de RAM, variables auxiliares y marcos de pila en algoritmos recursivos.',
    'input',
    100,
    $THEORY$# Complejidad Espacial (Space Complexity)

La eficiencia de un algoritmo no se mide únicamente en tiempo de CPU; también se mide en el **consumo de memoria RAM**.

$$\text{Complejidad Espacial Total} = \text{Espacio de Entrada} + \text{Espacio Auxiliar}$$

- **Espacio de Entrada:** La memoria que ocupan los datos originales recibidos (ej. un arreglo de $n$ enteros ocupa $O(n)$).
- **Espacio Auxiliar (Auxiliary Space):** La memoria **extra o temporal** que el algoritmo reserva para hacer sus cálculos. En ingeniería de software, nos enfocamos en el espacio auxiliar.

---

### Espacio In-Place: $O(1)$
Un algoritmo se considera **in-place** si utiliza una cantidad constante de memoria auxiliar, sin importar el tamaño de $n$:
```python
def revertir_arreglo(arr):
    # Solo usa 2 variables puntero (izq, der) y 1 temporal
    izq = 0
    der = len(arr) - 1
    while izq < der:
        arr[izq], arr[der] = arr[der], arr[izq]
        izq += 1
        der -= 1
```
Memoria auxiliar: **$O(1)$**.

---

### La Trampa de la Pila de Recursión (Call Stack)
Muchos programadores olvidan que **cada llamada recursiva crea un marco de pila (Stack Frame)** en la memoria RAM que contiene variables locales y la dirección de retorno.

```python
def cuenta_regresiva(n):
    if n <= 0:
        return
    cuenta_regresiva(n - 1)
```
Aunque no crea ningún arreglo, esta función acumula $n$ llamadas simultáneas en la pila de ejecución antes de retornar:
- Memoria auxiliar en la pila: **$O(n)$**.
- Si $n = 1.000.000$, el programa provocará un fallo por desbordamiento de pila: **Stack Overflow**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Si una función recursiva se llama a sí misma n veces consecutivas antes de alcanzar el caso base, sin crear estructuras de datos en el Heap, ¿cuál es la complejidad espacial auxiliar que consume en la pila de llamadas (Call Stack)?",
        "placeholder": "Ej: O(1) o O(n)",
        "expectedAnswer": "O(n)",
        "acceptedAnswers": ["O(n)", "n", "lineal", "O( n )"],
        "inputMode": "big-o",
        "explanation": "Cada nivel de recursión añade un marco de pila a la memoria. Para n llamadas no resueltas, la memoria consumida en la pila es proporcional a n: O(n)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Un algoritmo que ordena una lista de tamaño n modificando directamente sus elementos en el mismo arreglo original utilizando únicamente dos variables de índice temporales (sin clonar listas), ¿qué orden de complejidad espacial auxiliar consume?",
        "placeholder": "Ej: O(1) o O(n)",
        "expectedAnswer": "O(1)",
        "acceptedAnswers": ["O(1)", "o(1)", "1", "constante", "O( 1 )"],
        "inputMode": "big-o",
        "explanation": "Al operar in-place utilizando una cantidad fija e invariable de variables auxiliares, la complejidad espacial es constante: O(1)."
      }
    ]$JSON$,
    7
  );

  -- Lección 2.4 (Input): Trade-offs de Tiempo vs Espacio
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '8. Trade-offs: Sacrificar Memoria para Acelerar Tiempo',
    'Compara la fuerza bruta frente al uso de tablas Hash (Two-Sum) y entiende la compensación Espacio vs Tiempo.',
    'input',
    100,
    $THEORY$# El Dilema de la Ingeniería: Espacio vs Tiempo (Trade-off)

En la mayoría de los problemas informáticos existe un intercambio inevitable: **puedes hacer que un algoritmo corra mucho más rápido si estás dispuesto a consumir más memoria RAM**, o puedes ahorrar toda la RAM posible a costa de que el algoritmo tarde más tiempo en CPU.

---

### El Caso Clásico: El Problema "Two-Sum"
Dada una lista de $n$ números y un objetivo $T$, encontrar si existen dos números que sumen $T$.

#### Enfoque 1: Fuerza Bruta (Ahorra Memoria, Desperdicia Tiempo)
Compara cada par de números con dos bucles anidados:
```python
def two_sum_bruta(nums, T):
    n = len(nums)
    for i in range(n):
        for j in range(i + 1, n):
            if nums[i] + nums[j] == T:
                return True
    return False
```
- **Tiempo:** $O(n^2)$ (Cuadrático, muy lento para $n = 100.000$).
- **Espacio Auxiliar:** $O(1)$ (No usa memoria extra).

#### Enfoque 2: Tabla Hash / Diccionario (Sacrifica Memoria, Acelera Tiempo)
Almacena los números visitados en una tabla Hash para comprobar en tiempo constante $O(1)$ si el complemento `T - num` ya fue visto:
```python
def two_sum_hash(nums, T):
    vistos = set()
    for num in nums:
        complemento = T - num
        if complemento in vistos: # Búsqueda O(1) en promedio
            return True
        vistos.add(num)
    return False
```
- **Tiempo:** $O(n)$ (¡Lineal, millones de veces más rápido!).
- **Espacio Auxiliar:** $O(n)$ (Almacena hasta $n$ elementos en memoria).
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal en notación Big-O del algoritmo Two-Sum implementado con una Tabla Hash / Set en el caso promedio?",
        "placeholder": "Ej: O(n) o O(n^2)",
        "expectedAnswer": "O(n)",
        "acceptedAnswers": ["O(n)", "n", "lineal", "O( n )"],
        "inputMode": "big-o",
        "explanation": "Al recorrer la lista en una sola pasada y realizar búsquedas de costo promedio O(1) en el HashSet, la complejidad temporal total se reduce a O(n)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad espacial auxiliar del enfoque con Tabla Hash para Two-Sum en el peor de los casos (cuando se almacenan todos los elementos)?",
        "placeholder": "Ej: O(1) o O(n)",
        "expectedAnswer": "O(n)",
        "acceptedAnswers": ["O(n)", "n", "lineal", "O( n )"],
        "inputMode": "big-o",
        "explanation": "En el peor caso se insertan hasta n números en el conjunto de memoria, requiriendo un espacio auxiliar lineal: O(n)."
      }
    ]$JSON$,
    8
  );

  -- ==============================================================================
  -- MÓDULO 3: RECURSIÓN Y ECUACIONES DE RECURRENCIA
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 3: Recursión y Ecuaciones de Recurrencia',
    'Modelado de algoritmos recursivos, árboles de recursión, el Teorema Maestro y algoritmos de ordenamiento.'
  )
  RETURNING id INTO v_m3_id;

  -- Lección 3.1 (Input): Árboles de Recursión
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '9. Árboles de Recursión y Explosión Exponencial',
    'Dibuja y analiza el árbol de llamadas de Fibonacci recursivo para entender por qué explota a O(2^n).',
    'input',
    100,
    $THEORY$# Árboles de Recursión y Explosión Combinatoria

Calcular la complejidad de un bucle es sencillo contando iteraciones. Pero cuando una función se invoca a sí misma múltiples veces, la mejor herramienta para visualizar el costo es el **Árbol de Recursión**.

---

### El Desastre de Fibonacci Ingenuo
Analicemos la función clásica:
```python
def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)
```

Dibujemos el árbol de llamadas para calcular `fib(4)`:
```text
                         fib(4)
                     /            \
               fib(3)              fib(2)
              /      \            /      \
          fib(2)    fib(1)     fib(1)   fib(0)
         /      \
      fib(1)   fib(0)
```

### Análisis de Ramificación:
- En cada nivel del árbol, cada nodo se divide en **2 nuevos subproblemas**.
- Nivel 0: $2^0 = 1$ nodo
- Nivel 1: $2^1 = 2$ nodos
- Nivel 2: $2^2 = 4$ nodos
- Nivel $k$: $2^k$ nodos
- La altura del árbol es aproximadamente $n$.

El número total de nodos es la suma de una serie geométrica:
$$\sum_{k=0}^n 2^k = 2^{n+1} - 1 \implies \mathbf{O(2^n)}$$

Para calcular `fib(50)`, este código realizaría más de **$1.000.000.000.000.000$ de operaciones**, repitiendo los mismos cálculos una y otra vez (por ejemplo, `fib(2)` se calcula 3 veces en el árbol de arriba).
*Solución:* La técnica de **Programación Dinámica / Memoización** guarda los resultados previos reduciendo la complejidad de $O(2^n)$ a **$O(n)$**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "En un árbol binario de recursión completo donde cada llamada se divide en exactamente 2 ramas y la profundidad del árbol es de h = 5 niveles (de nivel 0 a nivel 4), ¿cuántas hojas o nodos existen en el nivel 4 (calculado como 2^4)?",
        "placeholder": "Escribe el número entero exacto...",
        "expectedAnswer": "16",
        "acceptedAnswers": ["16", "16 nodos", "16 hojas"],
        "inputMode": "numeric",
        "explanation": "El nivel 4 de un árbol binario contiene exactamente 2^4 = 16 nodos."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal en notación Big-O del algoritmo recursivo ingenuo para calcular el n-ésimo número de Fibonacci sin memoización?",
        "placeholder": "Ej: O(n^2) o O(2^n)",
        "expectedAnswer": "O(2^n)",
        "acceptedAnswers": ["O(2^n)", "2^n", "O(2**n)", "2**n", "O( 2^n )", "exponencial"],
        "inputMode": "big-o",
        "explanation": "Debido a la doble ramificación recursiva en cada paso, la complejidad temporal crece exponencialmente como O(2^n) (más exactamente proporcional al número áureo O(1.618^n))."
      }
    ]$JSON$,
    9
  );

  -- Lección 3.2 (Input): El Teorema Maestro
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '10. El Teorema Maestro (Master Theorem)',
    'Aprende la fórmula matemática universal para resolver recurrencias del tipo T(n) = aT(n/b) + f(n).',
    'input',
    100,
    $THEORY$# El Teorema Maestro (Master Theorem)

Los algoritmos de **Divide y Vencerás** dividen un problema de tamaño $n$ en $a$ subproblemas de tamaño $n/b$, resolviendo cada uno y combinando las soluciones en tiempo $f(n)$. Su tiempo se describe con la ecuación de recurrencia:

$$T(n) = a \cdot T\left(\frac{n}{b}\right) + O(n^d)$$

- $a \ge 1$: Número de subproblemas recursivos generados.
- $b > 1$: Factor por el cual se divide el tamaño de entrada.
- $d \ge 0$: Exponente del costo de dividir y combinar soluciones ($f(n) = O(n^d)$).

---

### Los 3 Casos del Teorema Maestro
Comparamos el costo de resolver los subproblemas ($n^{\log_b a}$) con el costo del trabajo de combinación ($n^d$):

```text
Caso 1: log_b(a) > d  ===>  T(n) = O( n^(log_b a) )    [La recursión domina]
Caso 2: log_b(a) == d ===>  T(n) = O( n^d * log n )    [Equilibrio perfecto]
Caso 3: log_b(a) < d  ===>  T(n) = O( n^d )            [La combinación domina]
```

---

### Ejemplo Práctico: MergeSort
MergeSort divide la lista en **2 mitades** ($a = 2$, $b = 2$) y combina los resultados en tiempo lineal $O(n)$ ($d = 1$):
$$T(n) = 2 \cdot T\left(\frac{n}{2}\right) + O(n)$$

1. Calculamos: $\log_b a = \log_2 2 = \mathbf{1}$.
2. Comparamos con $d$: $d = \mathbf{1}$.
3. Como $\log_b a = d$ ($1 = 1$), aplica el **Caso 2**:
$$T(n) = O(n^1 \cdot \log n) = \mathbf{O(n \log n)}$$
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "En el algoritmo MergeSort con recurrencia T(n) = 2T(n/2) + O(n), ¿cuál es la complejidad resultante según el Caso 2 del Teorema Maestro?",
        "placeholder": "Ej: O(n log n)",
        "expectedAnswer": "O(n log n)",
        "acceptedAnswers": ["O(n log n)", "O(nlogn)", "n log n", "nlogn", "O(n*log(n))"],
        "inputMode": "big-o",
        "explanation": "Al ser log_b(a) = log_2(2) = 1 y d = 1, ambos valores son iguales (Caso 2), resultando en O(n^d * log n) = O(n log n)."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Si una recurrencia divide un problema en 4 subproblemas del tamaño de la mitad T(n) = 4T(n/2) + O(n), donde log2(4) = 2 y d = 1 (Caso 1, donde log_b a > d), ¿cuál es la complejidad final O(n^(log_b a))?",
        "placeholder": "Ej: O(n^2)",
        "expectedAnswer": "O(n^2)",
        "acceptedAnswers": ["O(n^2)", "O(n**2)", "n^2", "n**2", "O(n ^ 2)"],
        "inputMode": "big-o",
        "explanation": "Al aplicar el Caso 1 del Teorema Maestro con log_2(4) = 2, la recursión domina y la solución es O(n^2)."
      }
    ]$JSON$,
    10
  );

  -- Lección 3.3 (Input): Algoritmos de Ordenamiento
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '11. Algoritmos de Ordenamiento: Mejor, Peor y Caso Promedio',
    'Compara el rendimiento teórico de BubbleSort, QuickSort, MergeSort y HeapSort.',
    'input',
    100,
    $THEORY$# Comparativa Asintótica de Algoritmos de Ordenamiento

Ordenar elementos es la tarea más estudiada de la computación. Ningún algoritmo de ordenamiento basado en comparaciones puede superar la cota teórica inferior de **$\Omega(n \log n)$** en el peor caso.

```text
+-------------------+-----------------+-------------------+-----------------+-----------------+
| Algoritmo         | Mejor Caso      | Caso Promedio     | Peor Caso       | Espacio Auxiliar|
+-------------------+-----------------+-------------------+-----------------+-----------------+
| Bubble Sort       | O(n)            | O(n^2)            | O(n^2)          | O(1)            |
| Insertion Sort    | O(n)            | O(n^2)            | O(n^2)          | O(1)            |
| Merge Sort        | O(n log n)      | O(n log n)        | O(n log n)      | O(n)            |
| Quick Sort        | O(n log n)      | O(n log n)        | O(n^2)          | O(log n)        |
| Heap Sort         | O(n log n)      | O(n log n)        | O(n log n)      | O(1)            |
+-------------------+-----------------+-------------------+-----------------+-----------------+
```

### Las Diferencias Cruciales:
1. **MergeSort:** Es sumamente predecible (siempre $O(n \log n)$ en todos los casos), pero requiere **$O(n)$ de memoria auxiliar** para crear los subarreglos durante el merge.
2. **QuickSort:** En la práctica es el más veloz por su excelente aprovechamiento de la memoria caché. Sin embargo, si el pivote elegido es pésimo (ej. elegir siempre el primer elemento en una lista que ya está ordenada), el árbol se desbalancea y cae a **$O(n^2)$** en el peor caso. (Solución: QuickSort con pivote aleatorio o *Mediana de Tres*).
3. **HeapSort:** Logra lo mejor de ambos mundos: garantiza **$O(n \log n)$ en el peor caso** y opera **in-place con $O(1)$ de memoria**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal en el PEOR caso del algoritmo QuickSort estándar cuando el pivote elegido es el peor posible (partición totalmente desbalanceada)?",
        "placeholder": "Ej: O(n log n) o O(n^2)",
        "expectedAnswer": "O(n^2)",
        "acceptedAnswers": ["O(n^2)", "O(n**2)", "n^2", "n**2", "cuadratica"],
        "inputMode": "big-o",
        "explanation": "Cuando QuickSort genera particiones de tamaño 1 y n-1 en cada llamada, el árbol degenera en una lista enlazada de n niveles, ejecutando O(n^2) comparaciones."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal que garantiza MergeSort en su PEOR caso?",
        "placeholder": "Ej: O(n log n) o O(n^2)",
        "expectedAnswer": "O(n log n)",
        "acceptedAnswers": ["O(n log n)", "O(nlogn)", "n log n", "nlogn"],
        "inputMode": "big-o",
        "explanation": "MergeSort siempre divide exactamente a la mitad sin importar el orden inicial de los datos, garantizando O(n log n) en el mejor, peor y caso promedio."
      }
    ]$JSON$,
    11
  );

  -- Lección 3.4 (Input): Divide y Vencerás: Búsqueda Binaria
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '12. Divide y Vencerás: El Poder de la Búsqueda Binaria',
    'Calcula el número máximo de comparaciones sobre listas gigantes ordenadas y exponenciación rápida.',
    'input',
    100,
    $THEORY$# Divide y Vencerás: Búsqueda Binaria y Exponenciación

El paradigma de **Divide y Vencerás** descompone un problema complejo en subproblemas idénticos más pequeños, reduciendo drásticamente la escala del trabajo.

---

### 1. Búsqueda Binaria en Grandes Volúmenes
Si buscas un número en una lista desordenada de $n = 1.000.000$ de elementos, la búsqueda lineal requiere hasta **1.000.000 de comparaciones** en el peor caso ($O(n)$).

Si la lista está **ordenada**, la búsqueda binaria compara con el elemento central y descarta la mitad completa del espacio de búsqueda en cada paso:
$$\text{Comparaciones máximas} = \lceil \log_2(n) \rceil$$

Para $n = 1.000.000$:
$$\log_2(1.000.000) \approx 19.93 \implies \mathbf{20\text{ comparaciones como máximo}}$$
¡Reducción de 1 millón de pasos a solo 20 pasos!

---

### 2. Exponenciación Binaria Rápida (Binary Exponentiation)
Para calcular $x^n$ de forma ingenua, multiplicas $x$ por sí mismo $n$ veces:
```python
resultado = 1
for _ in range(n):
    resultado *= x  # O(n) multiplicaciones
```

Con divide y vencerás:
- Si $n$ es par: $x^n = (x^{n/2})^2$
- Si $n$ es impar: $x^n = x \times (x^{(n-1)/2})^2$

Para calcular $2^{64}$, el algoritmo ingenuo hace 64 multiplicaciones. El algoritmo binario solo hace **$\approx 6$ multiplicaciones** ($O(\log n)$). Es el algoritmo que sostiene la criptografía RSA en todo Internet.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "Calcula a mano: En una lista ordenada de exactamente n = 128 elementos, ¿cuántas comparaciones como máximo realizará la búsqueda binaria en el peor de los casos (log2(128))?",
        "placeholder": "Escribe el número entero exacto...",
        "expectedAnswer": "7",
        "acceptedAnswers": ["7", "7 comparaciones", "7 pasos"],
        "inputMode": "numeric",
        "explanation": "Como 2^7 = 128, log2(128) = 7. Se requieren como máximo 7 divisiones sucesivas a la mitad para encontrar el elemento o confirmar que no existe."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Cuál es la complejidad temporal en notación Big-O del algoritmo de Exponenciación Rápida (Binary Exponentiation) para calcular x^n?",
        "placeholder": "Ej: O(n) o O(log n)",
        "expectedAnswer": "O(log n)",
        "acceptedAnswers": ["O(log n)", "O(logn)", "log n", "logn"],
        "inputMode": "big-o",
        "explanation": "Al dividir el exponente n a la mitad en cada paso recursivo, la complejidad temporal se reduce de O(n) a O(log n)."
      }
    ]$JSON$,
    12
  );

  -- ==============================================================================
  -- MÓDULO 4: TEORÍA DE COMPLEJIDAD AVANZADA Y CLASES P VS NP
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 4: Teoría de Complejidad Avanzada y Clases P vs NP',
    'Problemas de decisión, verificadores polinomiales, reducciones y el dilema del milenio P vs NP.'
  )
  RETURNING id INTO v_m4_id;

  -- Lección 4.1 (Input): La Clase P
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '13. Problemas de Decisión y la Clase P (Tiempo Polinomial)',
    'Comprende qué significa que un problema sea tratable en tiempo polinomial O(n^k).',
    'input',
    100,
    $THEORY$# Teoría de la Computación: Problemas de Decisión y la Clase P

Hasta ahora hemos estudiado la complejidad de algoritmos específicos. La **Teoría de la Complejidad** da un paso más allá: en lugar de clasificar programas, **clasifica a los problemas matemáticos mismos según su dificultad intrínseca**.

---

### 1. Problemas de Decisión
Para estandarizar el análisis teórico, la mayoría de los problemas se formulan como **Problemas de Decisión**: preguntas cuya respuesta es estrictamente binaria: **SÍ** o **NO**.
- *Versión de Optimización:* "¿Cuál es el camino más corto entre Madrid y Barcelona?"
- *Versión de Decisión:* "¿Existe un camino entre Madrid y Barcelona de longitud menor a 650 km?" (Respuesta: SÍ/NO).

---

### 2. La Clase P (Polynomial Time)
La clase **P** agrupa a todos los problemas de decisión que pueden ser **resueltos por una computadora determinista en tiempo polinomial**:
$$O(n^k) \quad \text{para alguna constante } k \ge 0$$

- $O(n)$ lineal $\in P$
- $O(n^2)$ cuadrático $\in P$
- $O(n^5)$ $\in P$

#### La Importancia de la "Tratabilidad":
En ciencias de la computación, **la clase P se considera el límite de lo computacionalmente tratable (eficiente)**. Si un problema está en P, sabemos que al aumentar el tamaño de entrada $n$, una computadora moderna podrá resolverlo en un tiempo razonable.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Cuál es la letra que identifica a la clase de complejidad que contiene a todos los problemas de decisión resolubles en tiempo polinomial O(n^k)?",
        "placeholder": "Escribe la letra...",
        "expectedAnswer": "P",
        "acceptedAnswers": ["P", "Clase P", "p"],
        "inputMode": "text",
        "explanation": "La clase P (Polynomial Time) representa el conjunto de problemas resolubles en tiempo polinomial en una máquina determinista."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "¿Un algoritmo con complejidad temporal O(n^3) pertenece a la clase de tiempo polinomial P? (Responde 'Si' o 'No')",
        "placeholder": "Si o No...",
        "expectedAnswer": "Si",
        "acceptedAnswers": ["Si", "Sí", "si", "sí", "true"],
        "inputMode": "text",
        "explanation": "Sí, O(n^3) es un polinomio con k = 3, por lo que pertenece a la clase P."
      }
    ]$JSON$,
    13
  );

  -- Lección 4.2 (Input): La Clase NP y el Enigma P vs NP
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '14. La Clase NP y el Enigma del Milenio P vs NP',
    'Descubre qué es un verificador polinomial, por qué resolver es más difícil que verificar y el premio de 1 millón de dólares.',
    'input',
    100,
    $THEORY$# La Clase NP y el Problema del Milenio: ¿$P = NP$?

La clase **NP (Nondeterministic Polynomial Time)** no significa "No Polinomial". Significa: **Problemas resolubles en tiempo polinomial por una máquina de Turing no determinista**.

En términos prácticos y modernos:
> **La clase NP agrupa a los problemas cuya respuesta SÍ puede ser VERIFICADA en tiempo polinomial dado un certificado o prueba (testigo).**

---

### La Gran Asimetría: Resolver vs Verificar
Imagina un juego de **Sudoku** de $n \times n$:
- **Resolver el Sudoku:** Extremadamente difícil. Probar combinaciones por fuerza bruta puede tardar miles de años.
- **Verificar una solución ya completada:** Muy fácil. Basta con revisar en pocos milisegundos que no se repitan números del 1 al 9 en filas, columnas y cuadrantes ($O(n^2)$, tiempo polinomial).

Como todo problema que puede resolverse en tiempo polinomial también puede verificarse en tiempo polinomial:
$$\mathbf{P \subseteq NP}$$
(Todo problema en P está automáticamente dentro de NP).

---

### El Enigma del Milenio: ¿$P = NP$?
En 1971, Stephen Cook y Leonid Levin plantearon la pregunta que hoy ofrece **1 millón de dólares de recompensa** por el Clay Mathematics Institute:
> *"Si una solución puede ser verificada rápidamente en tiempo polinomial, ¿significa que también existe un algoritmo oculto para encontrarla rápidamente desde cero?"*

La inmensa mayoría de los científicos de la computación cree que **$P \neq NP$**: encontrar una cura contra el cáncer o descifrar una clave RSA de 4096 bits es intrínsecamente más difícil que verificar la solución.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Qué significa exactamente la sigla de la clase de complejidad 'NP' en ciencias de la computación?",
        "placeholder": "Escribe el nombre...",
        "expectedAnswer": "Nondeterministic Polynomial Time",
        "acceptedAnswers": [
          "Nondeterministic Polynomial Time",
          "Nondeterministic Polynomial",
          "Tiempo Polinomial No Determinista",
          "Polinomial No Determinista",
          "No Determinista Polinomial"
        ],
        "inputMode": "text",
        "explanation": "NP significa 'Nondeterministic Polynomial time' (Tiempo Polinomial No Determinista), indicando problemas cuya solución puede ser verificada en tiempo polinomial."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "En la relación matemática de inclusión de conjuntos entre P y NP, ¿cuál de los dos conjuntos está contenido dentro del otro? (Responde 'P' si P está dentro de NP, o 'NP' si NP está dentro de P)",
        "placeholder": "P o NP...",
        "expectedAnswer": "P",
        "acceptedAnswers": ["P", "p", "P dentro de NP", "P es subconjunto de NP"],
        "inputMode": "text",
        "explanation": "P es un subconjunto de NP (P ⊆ NP), ya que si un problema puede resolverse en tiempo polinomial, trivialmente también puede verificarse en tiempo polinomial."
      }
    ]$JSON$,
    14
  );

  -- Lección 4.3 (Input): Reducciones y Problemas NP-Completos
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '15. Reducciones Polinomiales y Problemas NP-Completos',
    'Conoce el teorema de Cook-Levin, reducciones A <=p B y problemas famosos: SAT, TSP y Mochila.',
    'input',
    100,
    $THEORY$# Reducciones Polinomiales y Problemas NP-Completos

Dentro de la clase NP existen problemas que son **los más difíciles de toda la categoría**. Si logras resolver eficientemente uno solo de ellos, automáticamente habrás resuelto todos los miles de problemas de NP.

Estos son los **Problemas NP-Completos (NPC)**.

---

### 1. El Concepto de Reducción Polinomial ($A \le_p B$)
Una **reducción en tiempo polinomial** significa que si tenemos un algoritmo para resolver el problema $B$, podemos transformar cualquier instancia del problema $A$ en una instancia de $B$ rápidamente:
> *"El problema A no es más difícil que el problema B".*

### 2. El Teorema de Cook-Levin (1971)
Stephen Cook demostró que el problema **SAT (Satisfacibilidad Booleana)** es NP-Completo. Cualquier problema de NP puede reducirse en tiempo polinomial a una fórmula lógica de variables booleanas con operadores AND, OR y NOT.

### 3. Famosos Problemas NP-Completos:
1. **3-SAT:** Determinar si existe una asignación de verdaderos y falsos para satisfacer una fórmula booleana en forma normal conjuntiva.
2. **TSP (Traveling Salesperson Problem / Viajante de Comercio):** Encontrar la ruta más corta que visite $n$ ciudades exactamente una vez y regrese al origen.
3. **Problema de la Mochila (Knapsack):** Llenar una mochila con un límite de peso maximizando el valor de los objetos seleccionados.
4. **Graph Coloring (Coloreo de Grafos):** Colorear los vértices de un grafo con $k$ colores sin que dos nodos vecinos compartan color.

Si alguien descubriera mañana un algoritmo polinomial $O(n^k)$ para el Viajante de Comercio (TSP), **toda la criptografía RSA que protege las transferencias bancarias e Internet caería al instante**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Cuál fue el primer problema matemático demostrado formalmente como NP-Completo por el Teorema de Cook-Levin en 1971?",
        "placeholder": "Escribe el nombre del problema (ej: SAT)...",
        "expectedAnswer": "SAT",
        "acceptedAnswers": ["SAT", "Boolean Satisfiability", "Satisfacibilidad Booleana", "3-SAT"],
        "inputMode": "text",
        "explanation": "El problema SAT (Boolean Satisfiability) fue el primer problema cuya NP-completitud fue demostrada matemáticamente por Stephen Cook en 1971."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Si se demostrara que un problema NP-Completo como el Viajante de Comercio (TSP) puede resolverse en tiempo polinomial O(n^2), ¿qué conclusión se deduciría sobre el problema P vs NP? (Responde 'P = NP' o 'P != NP')",
        "placeholder": "P = NP o P != NP...",
        "expectedAnswer": "P = NP",
        "acceptedAnswers": ["P = NP", "P=NP", "p = np", "p=np", "P es igual a NP"],
        "inputMode": "text",
        "explanation": "Por definición de NP-completitud, si un solo problema NP-completo pertenece a P, entonces todo problema en NP pertenece a P, demostrando que P = NP."
      }
    ]$JSON$,
    15
  );

  -- Lección 4.4 (Input): Heurísticas y Algoritmos Voraces
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '16. Superando la Intratabilidad: Heurísticas y Algoritmos Voraces',
    'Aprende a resolver problemas NP-Completos en la vida real mediante aproximaciones y algoritmos Greedy.',
    'input',
    100,
    $THEORY$# Superando la Intratabilidad: Heurísticas y Algoritmos Voraces

En la industria del software no podemos decirle a un cliente: *"Tu problema de logística de camiones es NP-Completo, así que no puedo ayudarte"*.

Cuando un problema es NP-Completo y $n$ es grande, abandonamos la búsqueda de la solución perfecta absoluta y adoptamos **estrategias prácticas para encontrar soluciones excelentes en milisegundos**.

---

### 1. Algoritmos Voraces (Greedy Algorithms)
Toman la mejor decisión localmente óptima en cada paso inmediato con la esperanza de llegar a una solución global razonable:
- *Ejemplo en TSP:* "Desde mi ciudad actual, viajo a la ciudad no visitada más cercana".
- **Ventaja:** Corre a velocidad supersónica ($O(n^2)$ o $O(n \log n)$).
- **Desventaja:** Puede quedar atrapado en óptimos locales y no encontrar la ruta perfecta.

---

### 2. Algoritmos de Aproximación
A diferencia de una simple heurística ciega, un **Algoritmo de Aproximación** garantiza matemáticamente que su solución no estará más lejos de un factor $\alpha$ del óptimo real:
$$\text{Costo}(\text{Aproximado}) \le \alpha \cdot \text{Costo}(\text{Óptimo})$$
*Por ejemplo: el algoritmo de Christofides para TSP métrico garantiza una solución a no más del 1.5 veces (50%) del camino mínimo absoluto en tiempo polinomial.*

---

### 3. Metaheurísticas Modernas
- **Algoritmos Genéticos:** Simulan la evolución biológica (mutación, cruce y selección natural de soluciones).
- **Recocido Simulado (Simulated Annealing):** Inspirado en la termodinámica del enfriamiento de metales, permite temporalmente "empeorar" la solución para escapar de pozos locales.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "type": "input",
        "question": "¿Cómo se denominan los algoritmos que en cada paso eligen la mejor opción localmente inmediata sin reconsiderar decisiones pasadas?",
        "placeholder": "Escribe el nombre del enfoque...",
        "expectedAnswer": "Greedy",
        "acceptedAnswers": ["Greedy", "Voraz", "Algoritmo Voraz", "Algoritmos Voraces", "Algoritmo Greedy", "Voraces"],
        "inputMode": "text",
        "explanation": "Los algoritmos voraces (Greedy) toman la decisión local más favorable en cada paso con la expectativa de aproximarse a un resultado óptimo global."
      },
      {
        "id": "q2",
        "type": "input",
        "question": "Si un algoritmo de aproximación tiene un ratio garantizado alfa = 1.5 para un problema de minimización y la solución óptima teórica tiene un costo de 100 km, ¿cuál es el costo máximo garantizado que arrojará el algoritmo?",
        "placeholder": "Escribe el número...",
        "expectedAnswer": "150",
        "acceptedAnswers": ["150", "150 km", "150km"],
        "inputMode": "numeric",
        "explanation": "El costo máximo garantizado es alfa * optimo = 1.5 * 100 = 150 km."
      }
    ]$JSON$,
    16
  );

  -- ==============================================================================
  -- CERTIFICACIÓN OFICIAL VERIFICABLE: CERT-COMPLEXITY
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
    'Certificación en Complejidad Computacional y Análisis de Algoritmos',
    'CERT-COMPLEXITY',
    'Acredita dominio riguroso en notación asintótica Big-O, Big-Omega y Big-Theta, conteo de operaciones sobre el modelo RAM, resolución de recurrencias con el Teorema Maestro, análisis de espacio-tiempo y la teoría de clases P vs NP.',
    80,
    25,
    500,
    'purple',
    ARRAY[
      'Modelo RAM y Operaciones Elementales',
      'Notaciones Asintóticas Big-O, Big-Omega y Big-Theta',
      'Jerarquía de Complejidades de O(1) a O(n!)',
      'Análisis de Bucles Lineales y Multiplicativos',
      'Complejidad Espacial y Pila de Recursión',
      'Árboles de Recursión y Teorema Maestro',
      'Límites de Ordenamiento por Comparación',
      'Clases de Complejidad P, NP y NP-Completitud',
      'Heurísticas y Algoritmos de Aproximación'
    ]
  )
  RETURNING id INTO v_cert_id;

  -- Banco de 15 Preguntas del Examen de Certificación
  INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
  (
    v_cert_id,
    'En el modelo teórico RAM de computación, ¿cuál de las siguientes operaciones se considera de tiempo constante O(1)?',
    ARRAY[
      'Acceder a un elemento en un arreglo mediante su índice numérico arr[i]',
      'Ordenar una lista desordenada de n números enteros',
      'Buscar un elemento en una lista enlazada no ordenada de n nodos',
      'Generar todas las permutaciones de n caracteres'
    ],
    0,
    'El acceso a memoria por índice en un arreglo contiguo se calcula directamente por aritmética de punteros en tiempo constante O(1).'
  ),
  (
    v_cert_id,
    '¿Cuál es la diferencia matemática fundamental entre la notación Big-O y la notación Big-Theta?',
    ARRAY[
      'Big-O solo se aplica a programas escritos en C++',
      'Big-O representa únicamente una cota superior asintótica, mientras que Big-Theta define una cota ajustada exacta que acota tanto superior como inferiormente',
      'Big-Theta solo mide el consumo de memoria RAM',
      'No hay diferencia, son sinónimos absolutos'
    ],
    1,
    'Big-O acota superiormente f(n) <= c*g(n), mientras que Big-Theta garantiza c1*g(n) <= f(n) <= c2*g(n).'
  ),
  (
    v_cert_id,
    'Si un algoritmo ejecuta f(n) = 15n^2 + 100n + 3000 operaciones, ¿cuál es su cota asintótica Big-O?',
    ARRAY['O(n)', 'O(n^2)', 'O(n^3)', 'O(1)'],
    1,
    'El término dominante de mayor tasa de crecimiento es 15n^2; descartando el coeficiente constante se obtiene O(n^2).'
  ),
  (
    v_cert_id,
    '¿Cuál de las siguientes complejidades asintóticas crece más lentamente (es más eficiente) cuando n tiende a infinito?',
    ARRAY['O(n)', 'O(log n)', 'O(n^2)', 'O(n log n)'],
    1,
    'O(log n) crece mucho más lentamente que O(n), O(n log n) o O(n^2).'
  ),
  (
    v_cert_id,
    'Un bucle que inicializa i = 1 y en cada iteración multiplica i por 2 hasta alcanzar n, ¿cuántas iteraciones realiza asintóticamente?',
    ARRAY['O(1)', 'O(log n)', 'O(n)', 'O(n^2)'],
    1,
    'Al duplicar el valor en cada paso (1, 2, 4, 8, ...), el número de iteraciones necesarias para alcanzar n es logarítmico: O(log n).'
  ),
  (
    v_cert_id,
    'Al resolver la sumatoria de Gauss 1 + 2 + 3 + ... + n para n = 20 mediante la fórmula n(n+1)/2, ¿cuál es el valor exacto resultante?',
    ARRAY['200', '210', '400', '190'],
    1,
    '(20 * 21) / 2 = 420 / 2 = 210 operaciones.'
  ),
  (
    v_cert_id,
    '¿Por qué una función recursiva ingenua que se invoca n veces antes de retornar consume espacio auxiliar en memoria aunque no reserve arreglos?',
    ARRAY[
      'Porque el compilador duplica el código fuente en disco',
      'Porque cada llamada recursiva pendiente apila un marco de activación (Stack Frame) en la memoria RAM de la pila de ejecución',
      'Porque el recolector de basura de Java congela la memoria',
      'No consume memoria auxiliar en ningún caso'
    ],
    1,
    'La pila de llamadas (Call Stack) almacena las variables y direcciones de retorno de cada llamada recursiva pendiente, consumiendo O(n) de memoria.'
  ),
  (
    v_cert_id,
    'En el problema Two-Sum, ¿qué trade-off de espacio-tiempo se produce al cambiar de fuerza bruta a una Tabla Hash?',
    ARRAY[
      'Aumenta el tiempo de ejecución a O(n^3) y ahorra memoria',
      'Se reduce el tiempo de O(n^2) a O(n) aumentando el espacio auxiliar de O(1) a O(n)',
      'El algoritmo deja de funcionar para números pares',
      'Se reduce el espacio a O(0) sin alterar el tiempo'
    ],
    1,
    'El uso de la tabla Hash invierte O(n) de memoria RAM para lograr búsquedas constantes en promedio, reduciendo el tiempo de O(n^2) a O(n).'
  ),
  (
    v_cert_id,
    '¿Por qué el algoritmo ingenuo para calcular el n-ésimo número de Fibonacci tiene complejidad temporal exponencial O(2^n)?',
    ARRAY[
      'Porque utiliza multiplicación de matrices',
      'Porque en cada llamada se ramifica en 2 nuevos subproblemas en un árbol binario que recalcula los mismos valores repetidamente',
      'Porque el procesador entra en modo de reposo',
      'Porque el número de Fibonacci supera el tamaño de 64 bits'
    ],
    1,
    'La doble llamada recursiva fib(n-1) + fib(n-2) genera un árbol binario de profundidad n con aproximadamente 2^n nodos redundantes.'
  ),
  (
    v_cert_id,
    'De acuerdo con el Teorema Maestro, la ecuación de recurrencia de MergeSort T(n) = 2T(n/2) + O(n) tiene como solución:',
    ARRAY['O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)'],
    1,
    'Como log_2(2) = 1 y f(n) = O(n^1), aplica el Caso 2 del Teorema Maestro: O(n^1 * log n) = O(n log n).'
  ),
  (
    v_cert_id,
    '¿Cuál es la cota teórica inferior Omega del número de comparaciones en el peor caso para cualquier algoritmo de ordenamiento basado en comparaciones?',
    ARRAY['Omega(1)', 'Omega(log n)', 'Omega(n log n)', 'Omega(n^2)'],
    2,
    'El árbol de decisión de cualquier ordenamiento por comparación tiene al menos n! hojas, lo que impone una cota inferior matemática insuperable de Omega(n log n).'
  ),
  (
    v_cert_id,
    'En una lista ordenada de 1.000.000 de elementos, ¿cuál es el número máximo aproximado de comparaciones que realizará una búsqueda binaria?',
    ARRAY['1.000.000', '500.000', '20', '10.000'],
    2,
    'Como 2^20 = 1.048.576 > 1.000.000, la búsqueda binaria requiere como máximo ceil(log2(1.000.000)) = 20 comparaciones.'
  ),
  (
    v_cert_id,
    '¿Qué define formalmente a la clase de complejidad P en la teoría de la computación?',
    ARRAY[
      'El conjunto de problemas que solo pueden resolverse con computadoras cuánticas',
      'El conjunto de problemas de decisión resolubles por una máquina determinista en tiempo polinomial O(n^k)',
      'Los problemas que no tienen solución matemática conocida',
      'Los problemas que requieren memoria infinita'
    ],
    1,
    'P contiene a los problemas de decisión tratables de forma eficiente en tiempo polinomial O(n^k).'
  ),
  (
    v_cert_id,
    '¿Cuál es la característica definitoria de la clase de complejidad NP?',
    ARRAY[
      'Que sus problemas no pueden resolverse en tiempo polinomial',
      'Que dada una solución propuesta (certificado), esta puede ser verificada en tiempo polinomial',
      'Que solo opera sobre redes neuronales profundas',
      'Que no admite números negativos'
    ],
    1,
    'La clase NP agrupa a los problemas cuya validez puede ser verificada en tiempo polinomial dado un certificado o testigo de la solución.'
  ),
  (
    v_cert_id,
    '¿Qué establece el Teorema de Cook-Levin de 1971?',
    ARRAY[
      'Que todo algoritmo de ordenamiento tarda O(n^2)',
      'Que el problema de satisfacibilidad booleana SAT es NP-Completo y cualquier problema de NP puede reducirse a él en tiempo polinomial',
      'Que las computadoras nunca podrán superar a los humanos',
      'Que la memoria RAM es más rápida que el disco duro'
    ],
    1,
    'Cook y Levin demostraron que SAT es NP-completo, estableciendo el primer punto de referencia universal para la teoría de NP-completitud.'
  );

END $COMPLEXITY_SEED$;
