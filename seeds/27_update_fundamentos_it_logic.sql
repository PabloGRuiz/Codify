-- ==============================================================================
-- 🚀 CODIFY SEED: 27 - MIGRACIÓN / ACTUALIZACIÓN: CURSO FUNDAMENTOS IT Y LÓGICA
-- ==============================================================================
-- Este script actualiza el curso existente "Fundamentos IT y Lógica"
-- sincronizándolo de forma 100% coherente con el Examen Integrador (CERT-IT-101).
--
-- Estructura: 3 Módulos Progresivos con 12 Lecciones Interactivas completas.
-- ==============================================================================

DO $$
DECLARE
  v_author_id UUID;
  v_course_id UUID;
  v_m1_id UUID;
  v_m2_id UUID;
  v_m3_id UUID;
BEGIN

  -- 1. Obtener autor de referencia o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Limpiar versión previa si existiera para re-inserción limpia
  DELETE FROM public.courses WHERE title = 'Fundamentos IT y Lógica';

  -- 3. Crear el Curso Base con Ficha Técnica Detallada
  INSERT INTO public.courses (
    title,
    description,
    summary,
    image_url,
    tags,
    prerequisite_course_id,
    min_level,
    author_id,
    status
  ) VALUES (
    'Fundamentos IT y Lógica',
    'Desarrolla el pensamiento computacional y los cimientos de la ingeniería de software: lógica booleana, arquitectura de hardware y memoria, algoritmos, complejidad Big-O, estructuras de datos (Pilas LIFO, Colas FIFO, Listas), funciones puras y control de versiones.',
    $SUMMARY$## 🧠 Pensamiento Computacional y Fundamentos IT

Este curso es el pilar fundamental para toda la plataforma y prepara al estudiante para aprobar con distinción el **Examen Integrador y Certificación Profesional (CERT-IT-101)**.

Aprenderás no solo a razonar lógicamente como un ingeniero de software, sino a comprender cómo los ordenadores procesan datos, gestionan la memoria y resuelven problemas mediante algoritmos óptimos.

### 🎯 Lo que aprenderás:
- **Lógica Proposicional y Álgebra de Boole:** Tablas de verdad, operadores `AND`, `OR`, `NOT`, `XOR` y evaluación de condiciones compuestas.
- **Arquitectura de Hardware y Memoria:** CPU (ALU, Registros, núcleos), memoria RAM (volatilidad y direccionamiento) vs almacenamiento SSD/HDD.
- **Representación Binaria y Codificación:** Bits, bytes, sistema hexadecimal y codificación ASCII/UTF-8.
- **Estructuras de Datos Lineales:** Pilas (*Stack* con principio **LIFO**) vs Colas (*Queue* con principio **FIFO**), Arreglos (*Arrays*) vs Listas Enlazadas.
- **Algoritmos y Complejidad Big-O:** Búsqueda Lineal $O(N)$ vs Búsqueda Binaria $O(\log N)$ sobre arreglos ordenados.
- **Ingeniería de Software Limpia:** Funciones puras (determinismo sin efectos secundarios) vs mutación global.
- **Colaboración y Seguridad:** Control de versiones con Git (commits, ramas), autenticación MFA y la regla de respaldos 3-2-1.

### 👤 ¿A quién va dirigido?
- Estudiantes que inician su camino en programación e informática.
- Desarrolladores que buscan consolidar sus bases de ciencia de la computación antes de abordar cursos avanzados.$SUMMARY$,
    '/images/courses/logic.jpg',
    ARRAY['Lógica', 'IT', 'Fundamentos', 'Estructuras de Datos', 'Algoritmos'],
    NULL,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Pensamiento Computacional, Lógica Booleana y Arquitectura Hardware
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Pensamiento Computacional, Lógica Booleana y Arquitectura Hardware',
    'Domina las tablas de verdad, el álgebra de Boole y los componentes físicos del computador.',
    '1'
  ) RETURNING id INTO v_m1_id;

  -- Lección 1.1: Álgebra de Boole y Operadores Lógicos
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '1. Lógica Proposicional y Álgebra de Boole',
    'Aprende a evaluar expresiones lógicas compuestas con operadores AND, OR, NOT y XOR.',
    'quiz',
    75,
    $THEORY$# Lógica Computacional y Álgebra de Boole

Los ordenadores toman decisiones evaluando condiciones booleanas que resultan en **Verdadero (True / 1)** o **Falso (False / 0)**.

### ⚙️ Operadores Lógicos Fundamentales:
1. **AND (&& / Y):** Verdadero **únicamente si TODAS** las condiciones son verdaderas.
   - `true && true` = `true`
   - `true && false` = `false`
2. **OR (|| / O):** Verdadero si **al menos UNA** de las condiciones es verdadera.
   - `false || true` = `true`
   - `false || false` = `false`
3. **NOT (! / NO):** Invierte el valor lógico.
   - `!true` = `false`
   - `!false` = `true`
4. **XOR (O Exclusivo):** Verdadero si las entradas son **diferentes** entre sí.

### 📐 Precedencia de Operadores:
Al evaluar expresiones complejas, el operador `NOT (!)` tiene mayor prioridad, seguido de `AND (&&)`, y finalmente `OR (||)`. Se utilizan paréntesis para forzar el orden deseado:
- Ejemplo: `(true && false) || (!false)`
  - Paso 1: `(true && false)` evalúa a `false`.
  - Paso 2: `!false` evalúa a `true`.
  - Paso 3: `false || true` resulta finalmente en **`true`**.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es el resultado de evaluar la expresión booleana: (true && false) || (!false)?","options":["false","true","null","undefined"],"correctIndex":1,"explanation":"(true && false) da false; (!false) da true; finalmente false || true resulta en true."},{"id":"q2","question":"Si tienes la condición (A OR B), ¿en qué único caso el resultado será Falso?","options":["Cuando A es Verdadero y B es Falso","Cuando ambas condiciones A y B son Falsas","Cuando A es Falso y B es Verdadero","Cuando ambas son Verdaderas"],"correctIndex":1,"explanation":"El operador OR solo devuelve Falso cuando todas sus entradas son simultáneamente Falsas."},{"id":"q3","question":"Un sistema de seguridad concede acceso si el usuario es (Administrador OR (TieneLlave AND HuellaValida)). Si el usuario NO es Administrador, tiene la llave pero la huella falla, ¿qué ocurre?","options":["Se concede el acceso","El acceso se deniega","El sistema se bloquea","Se activa la alarma de intrusión"],"correctIndex":1,"explanation":"(TieneLlave AND HuellaValida) da Falso porque la huella falló. Como tampoco es Administrador, False OR False da Falso y el acceso se deniega."}]$JSON$,
    1
  );

  -- Lección 1.2: Arquitectura del Computador y Modelo von Neumann
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '2. Arquitectura del Computador y Modelo von Neumann',
    'Comprende el ciclo Fetch-Decode-Execute, la CPU, la memoria RAM y el almacenamiento.',
    'quiz',
    75,
    $THEORY$# Arquitectura del Computador y Memoria

El **Modelo de von Neumann** define la arquitectura básica de casi todas las computadoras modernas:

```
[ Dispositivos Entrada ] ---> [ CPU (ALU + Unidad Control + Registros) ] ---> [ Dispositivos Salida ]
                                              ^
                                              | (Bus de Datos/Direcciones)
                                              v
                                     [ Memoria Principal (RAM) ]
```

### 🧠 Componentes Esenciales:
1. **CPU (Unidad Central de Procesamiento):** El cerebro que ejecuta instrucciones mediante el ciclo *Fetch* (buscar instrucción), *Decode* (decodificar) y *Execute* (ejecutar).
   - **ALU (Unidad Aritmético-Lógica):** Realiza operaciones matemáticas y lógicas.
   - **Registros:** Celdas de memoria ultra rápidas situadas dentro del mismo chip de la CPU.
2. **Memoria RAM (Random Access Memory):**
   - Memoria **volátil** de acceso aleatorio a ultra alta velocidad.
   - Almacena las variables y programas que se están ejecutando en este momento. Al apagar el equipo, su contenido se borra por completo.
3. **Almacenamiento Secundario (SSD / HDD):**
   - Memoria **no volátil** a largo plazo. Los discos de estado sólido (SSD NVMe) superan por órdenes de magnitud la velocidad de los discos mecánicos tradicionales (HDD).$THEORY$,
    $JSON$[{"id":"q1","question":"Si un servidor sufre un corte de energía inesperado, ¿qué datos se pierden irreversiblemente si no fueron guardados en disco?","options":["Los archivos en el disco SSD","Los archivos de configuración del sistema operativo","Los datos y estados de programas cargados en la Memoria RAM","El firmware de la placa madre"],"correctIndex":2,"explanation":"La memoria RAM es volátil: requiere suministro eléctrico continuo para mantener sus celdas de memoria cargadas."},{"id":"q2","question":"¿Cuál es el orden correcto de las tres fases del ciclo fundamental de ejecución de instrucciones de la CPU?","options":["Execute -> Fetch -> Decode","Fetch (Búsqueda) -> Decode (Decodificación) -> Execute (Ejecución)","Compile -> Link -> Run","Read -> Write -> Delete"],"correctIndex":1,"explanation":"La CPU primero busca la instrucción en memoria (Fetch), la interpreta en su unidad de control (Decode) y finalmente la procesa en la ALU (Execute)."},{"id":"q3","question":"¿Dónde se encuentran las unidades de almacenamiento con el tiempo de acceso más rápido de todo el sistema informático?","options":["En la memoria RAM DDR5","En los discos SSD NVMe PCIe 4.0","En los Registros internos integrados directamente en la CPU","En la memoria Flash USB"],"correctIndex":2,"explanation":"Los registros de la CPU operan a la misma velocidad de reloj del procesador (fracciones de nanosegundo), superando a cualquier memoria externa."}]$JSON$,
    2
  );

  -- Lección 1.3: Sistema Binario, Hexadecimal y Codificación
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '3. Sistema Binario, Hexadecimal y Codificación de Datos',
    'Aprende cómo los ceros y unos representan números, colores y caracteres en ASCII y UTF-8.',
    'quiz',
    75,
    $THEORY$# Representación de Datos: Binario y Hexadecimal

A nivel físico, los transistores solo entienden dos estados eléctricos: voltaje alto (**1**) y voltaje bajo (**0**).

### 🔢 Unidades de Información:
- **Bit:** La unidad mínima (0 o 1).
- **Byte:** Un grupo de **8 bits**. Con 8 bits podemos representar $2^8 = 256$ valores distintos (del `0` al `255`).

### 🔠 Sistemas Numéricos:
1. **Binario (Base 2):** Usa dígitos `0` y `1`.
   - Ejemplo: `00001010` en binario = $0\cdot2^7 + 0\cdot2^6 + 0\cdot2^5 + 0\cdot2^4 + 1\cdot2^3 + 0\cdot2^2 + 1\cdot2^1 + 0\cdot2^0 = 8 + 2 = 10$ en decimal.
2. **Hexadecimal (Base 16):** Usa los dígitos `0-9` y las letras `A-F` (donde A=10, B=11, C=12, D=13, E=14, F=15). Cada dígito hexadecimal representa exactamente **4 bits (un nibble)**.
   - Ejemplo: `#FF` en hexadecimal = `255` en decimal.

### 📜 Codificación de Caracteres:
- **ASCII:** Estándar original de 7 bits para el alfabeto inglés (128 caracteres).
- **UTF-8:** Estándar moderno de tamaño variable (1 a 4 bytes) capaz de representar cualquier símbolo, emoji y carácter de todos los idiomas del mundo.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuántos valores diferentes se pueden representar exactamente con 1 Byte (8 bits)?","options":["128 valores","256 valores (del 0 al 255)","1024 valores","64 valores"],"correctIndex":1,"explanation":"2 elevado a la potencia 8 es igual a 256 combinaciones distintas."},{"id":"q2","question":"¿Por qué el sistema Hexadecimal es ampliamente utilizado por los desarrolladores y sistemas de computación?","options":["Porque los procesadores solo entienden hexadecimal","Porque permite representar de forma compacta y legible secuencias de 4 bits con un solo carácter (0-F)","Porque hace que los programas se ejecuten más rápido","Porque elimina los errores de redondeo"],"correctIndex":1,"explanation":"Un byte (8 bits) se representa exactamente con dos caracteres hexadecimales (ej: 11111111 = FF), facilitando la lectura humana de memoria y colores."},{"id":"q3","question":"¿Qué ventaja ofrece el estándar de codificación UTF-8 frente a ASCII tradicional?","options":["Ocupa siempre la mitad de espacio en disco","Soporta millones de caracteres internacionales, tildes y emojis con compatibilidad retroactiva con ASCII","No requiere memoria RAM para procesarse","Solo funciona con números enteros"],"correctIndex":1,"explanation":"UTF-8 es universal, soporta caracteres de cualquier idioma del planeta y preserva compatibilidad con ASCII para los primeros 128 caracteres."}]$JSON$,
    3
  );

  -- Lección 1.4: Sistemas Operativos, Procesos y Memoria Virtual
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '4. Sistemas Operativos, Kernel y Gestión de Procesos',
    'Comprende el rol del Kernel, la diferencia entre procesos e hilos (threads) y la memoria virtual.',
    'quiz',
    75,
    $THEORY$# El Sistema Operativo y el Kernel

El **Sistema Operativo (SO)** es el software base que administra los recursos de hardware y proporciona servicios a las aplicaciones.

### 🛡️ El Kernel (Núcleo):
Es el corazón del SO que opera en modo privilegiado (*Ring 0*). Controla:
- La asignación de tiempo de CPU a cada programa.
- La protección de memoria entre aplicaciones para que un fallo en un programa no congele todo el computador.
- La comunicación con periféricos mediante *Drivers*.

### ⚡ Procesos vs Hilos (Threads):
- **Proceso:** Un programa en ejecución que tiene su propio espacio de memoria aislado asignado por el SO.
- **Hilo (Thread):** La unidad más pequeña de ejecución dentro de un proceso. Múltiples hilos dentro del mismo proceso **comparten la misma memoria**, lo que permite tareas concurrentes ultra rápidas pero requiere sincronización cuidadosa.

### 🗂️ Memoria Virtual y Paginación:
El SO crea la ilusión de que cada proceso tiene una memoria continua y gigantesca traduciendo direcciones virtuales a direcciones físicas reales (RAM o disco mediante *Swap* / Archivo de paginación).$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la diferencia principal entre un Proceso y un Hilo (Thread)?","options":["Un proceso no consume CPU; un hilo sí","Un proceso tiene su propio espacio de memoria aislado; los hilos de un mismo proceso comparten el mismo espacio de memoria","Los hilos solo se usan en teléfonos móviles","Un proceso solo puede tener un único hilo siempre"],"correctIndex":1,"explanation":"Los procesos están aislados entre sí para seguridad; los hilos son sub-tareas livianas dentro de un proceso que comparten memoria común."},{"id":"q2","question":"¿Cuál es la responsabilidad primordial del Kernel en un sistema operativo?","options":["Diseñar la interfaz gráfica y los iconos del escritorio","Actuar como intermediario seguro gestionando la CPU, la memoria y el acceso al hardware para las aplicaciones","Compilar el código fuente de los desarrolladores","Crear páginas web interactivas"],"correctIndex":1,"explanation":"El Kernel es el núcleo del SO responsable de la gestión de memoria, planificación de procesos y seguridad en el acceso al hardware."},{"id":"q3","question":"¿Qué mecanismo utiliza el sistema operativo cuando la memoria RAM física se llena por completo?","options":["Apaga automáticamente el computador","Utiliza la Memoria Virtual / Swap trasladando páginas de memoria inactivas al disco secundario","Borra los archivos del usuario","Duplica la frecuencia del procesador"],"correctIndex":1,"explanation":"La memoria virtual permite extender la RAM utilizando espacio en disco (Swap), evitando que el sistema se quede sin memoria a costa de mayor lentitud."}]$JSON$,
    4
  );

  -- ==============================================================================
  -- MÓDULO 2: Algoritmos, Estructuras de Datos y Complejidad
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Algoritmos, Estructuras de Datos y Complejidad',
    'Aprende cómo organizar datos en memoria y analizar la eficiencia de los algoritmos con Big-O.',
    '2'
  ) RETURNING id INTO v_m2_id;

  -- Lección 2.1: Algoritmos y Control de Flujo
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '5. Pensamiento Algorítmico y Control de Flujo',
    'Aprende a formular algoritmos deterministas usando estructuras secuenciales, condicionales e iterativas.',
    'quiz',
    75,
    $THEORY$# ¿Qué es un Algoritmo?

Un **algoritmo** es una secuencia finita, ordenada y no ambigua de pasos e instrucciones que resuelven un problema o realizan un cómputo.

### 🧱 Las Tres Estructuras de Control Fundamentales:
1. **Secuencia:** Ejecución de instrucciones una tras otra en orden lineal.
2. **Selección (Condicionales `if / else`, `switch`):** Bifurcación del flujo según si una condición booleana es verdadera o falsa.
3. **Iteración (Bucles `for`, `while`):** Repetición de un bloque de código mientras se cumpla una condición de parada.

### ⚠️ Propiedades Clave de un Buen Algoritmo:
- **Finitud:** Debe terminar tras un número concreto de pasos (¡cuidado con los bucles infinitos!).
- **Determinismo:** Con las mismas entradas, siempre produce exactamente las mismas salidas.
- **Eficiencia:** Resuelve el problema utilizando la menor cantidad de tiempo y memoria posible.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Qué condición es indispensable para evitar que un bucle 'while' se convierta en un bucle infinito que congele el sistema?","options":["Que contenga al menos 10 instrucciones dentro","Que dentro del bucle ocurra una modificación que eventualmente haga que la condición de repetición sea Falsa","Que utilice números decimales","Que se ejecute en un servidor en la nube"],"correctIndex":1,"explanation":"Si el estado de la condición de control nunca cambia a Falso, el bucle continuará repitiéndose indefinidamente."},{"id":"q2","question":"¿Cuál de las siguientes afirmaciones describe mejor a un algoritmo 'determinista'?","options":["Un algoritmo que genera números aleatorios cada vez","Un algoritmo que ante los mismos datos de entrada produce siempre de manera predecible el mismo resultado","Un algoritmo que no puede ser traducido a código","Un algoritmo que nunca se detiene"],"correctIndex":1,"explanation":"El determinismo garantiza que el comportamiento del algoritmo sea predecible y reproducible ante entradas idénticas."},{"id":"q3","question":"¿Cuál es la estructura de control adecuada cuando se conoce de antemano el número exacto de iteraciones a realizar?","options":["Bucle 'for' con contador","Estructura 'switch / case'","Sentencia 'goto'","Bucle infinito"],"correctIndex":0,"explanation":"El bucle 'for' inicializa una variable de conteo, evalúa el límite y avanza el paso en cada ciclo de forma controlada."}]$JSON$,
    5
  );

  -- Lección 2.2: Pilas (Stack) vs Colas (Queue)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '6. Estructuras de Datos Lineales: Pilas (Stack) y Colas (Queue)',
    'Comprende a fondo los principios LIFO (Last-In First-Out) y FIFO (First-In First-Out).',
    'quiz',
    80,
    $THEORY$# Pilas (Stack) vs Colas (Queue)

Las estructuras de datos organizan y almacenan datos en memoria según reglas de acceso específicas.

---

### 🥞 1. Pila (*Stack*): Principio LIFO
**LIFO = Last In, First Out (El último en entrar es el primero en salir).**
- Imagina una pila de platos: el último plato que colocas arriba es el primero que debes retirar.
- **Operaciones:**
  - `push(elemento)`: Agrega un elemento en el tope de la pila.
  - `pop()`: Remueve y devuelve el elemento del tope.
  - `peek()`: Consulta el elemento del tope sin removerlo.
- **Casos de Uso Reales:**
  - El botón "Atrás" del navegador web (historial de páginas).
  - La función "Deshacer" (Ctrl+Z) en editores de texto.
  - La **Pila de Llamadas (*Call Stack*)** de ejecución de funciones en lenguajes como C++, JavaScript y Python.

---

### 🎟️ 2. Cola (*Queue*): Principio FIFO
**FIFO = First In, First Out (El primero en entrar es el primero en salir).**
- Imagina una fila en el supermercado o en el banco: la primera persona en llegar es la primera en ser atendida.
- **Operaciones:**
  - `enqueue(elemento)`: Encola un elemento al final de la fila.
  - `dequeue()`: Atiende y remueve el elemento al frente de la fila.
- **Casos de Uso Reales:**
  - Colas de impresión de documentos en un servidor.
  - Procesamiento asíncrono de mensajes y solicitudes de red en orden de llegada.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Qué estructura de datos opera bajo el principio LIFO (Last In, First Out)?","options":["Cola (Queue)","Pila (Stack)","Lista enlazada circular","Árbol binario de búsqueda"],"correctIndex":1,"explanation":"En una Pila (Stack), el último elemento agregado con 'push' es el primero en ser extraído con 'pop' (LIFO)."},{"id":"q2","question":"¿Qué estructura de datos es la más adecuada para modelar el sistema de turnos de una impresora compartida en red?","options":["Pila (Stack)","Cola (Queue / FIFO)","Matriz bidimensional","Grafo no dirigido"],"correctIndex":1,"explanation":"Los trabajos de impresión deben procesarse en estricto orden de llegada: el primer documento enviado es el primero en imprimirse (FIFO)."},{"id":"q3","question":"Cuando un programa ejecuta funciones recursivas o anidadas, ¿en qué estructura de memoria guarda el sistema operativo las direcciones de retorno de cada función?","options":["En una Cola FIFO","En el Call Stack (Pila de llamadas LIFO)","En un archivo de texto en disco","En una tabla hash estática"],"correctIndex":1,"explanation":"El Call Stack almacena los marcos de llamadas apilados: la última función invocada debe resolverse antes de que la función que la llamó pueda continuar."}]$JSON$,
    6
  );

  -- Lección 2.3: Arreglos (Arrays) vs Listas Enlazadas
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '7. Arreglos en Memoria vs Listas Enlazadas',
    'Compara el almacenamiento contiguo en memoria frente a nodos enlazados por punteros.',
    'quiz',
    75,
    $THEORY$# Arreglos (Arrays) vs Listas Enlazadas (Linked Lists)

### 📊 Arreglos (Arrays):
Un arreglo almacena elementos del mismo tipo en un **bloque contiguo de memoria RAM**.
- **Acceso por índice:** Instantáneo ($O(1)$) mediante aritmética de direcciones: $\text{Dirección} = \text{Inicio} + (\text{Índice} \times \text{Tamaño})$.
- **Desventaja:** Insertar o eliminar elementos en el medio requiere desplazar todos los elementos posteriores ($O(N)$), y su tamaño suele ser fijo.

```
Array en Memoria: [ Elemento 0 ][ Elemento 1 ][ Elemento 2 ][ Elemento 3 ]
Direcciones:      0x1000        0x1004        0x1008        0x100C
```

### 🔗 Listas Enlazadas (Linked Lists):
Una lista enlazada está compuesta por **Nodos dispersos en memoria**. Cada nodo contiene:
1. El **Dato**.
2. Un **Puntero/Referencia** que indica la dirección en memoria del siguiente nodo.

```
[ Nodo A | Next ] ---> [ Nodo B | Next ] ---> [ Nodo C | null ]
(Dirección 0x1A0)      (Dirección 0x5F2)      (Dirección 0x33B)
```

- **Ventaja:** Inserción y eliminación rápida sin necesidad de memoria contigua.
- **Desventaja:** Para acceder al elemento 50, se debe recorrer secuencialmente desde el inicio ($O(N)$).$THEORY$,
    $JSON$[{"id":"q1","question":"¿Por qué el acceso a un elemento por su índice (ej: array[4]) es instantáneo O(1) en un arreglo tradicional?","options":["Porque el procesador adivina la posición","Porque los elementos residen en posiciones contiguas de memoria y su dirección física se calcula con una simple multiplicación matemática","Porque las listas enlazadas son más lentas","Porque se almacena en disco duro"],"correctIndex":1,"explanation":"Al estar contiguos en memoria, la posición exacta se calcula instantáneamente sumando al puntero base el índice multiplicado por el tamaño de cada elemento."},{"id":"q2","question":"¿Qué ventaja estructural ofrece una Lista Enlazada frente a un Arreglo de tamaño fijo?","options":["Permite acceso aleatorio por índice en O(1)","Permite crecer dinámicamente e insertar nodos en cualquier posición sin necesidad de reservar un bloque de memoria contiguo","Ocupa menos memoria total que un arreglo","No utiliza punteros"],"correctIndex":1,"explanation":"Las listas enlazadas asignan nodos dinámicamente en cualquier ubicación disponible de la memoria Heap y los unen mediante punteros."},{"id":"q3","question":"¿Cuál es la principal desventaja de las Listas Enlazadas respecto al uso de memoria caché del procesador?","options":["No pueden almacenar cadenas de texto","Al estar los nodos dispersos en memoria, sufren penalizaciones por fallos de caché (Cache Misses) al no aprovechar la localidad espacial","Requieren reiniciar el equipo para liberarse","Solo funcionan en sistemas operativos de 32 bits"],"correctIndex":1,"explanation":"Los arreglos aprovechan la caché de la CPU porque al leer un elemento, los datos contiguos se cargan juntos; los nodos dispersos de las listas provocan saltos de memoria."}]$JSON$,
    7
  );

  -- Lección 2.4: Búsqueda y Complejidad Algorítmica (Big O)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '8. Búsqueda y Complejidad Algorítmica (Notación Big O)',
    'Aprende a calcular la eficiencia de la Búsqueda Binaria O(log N) frente a la Búsqueda Lineal O(N).',
    'quiz',
    80,
    $THEORY$# Complejidad Algorítmica y Notación Big O

La **Notación Big O** mide cómo escala el tiempo de ejecución o el uso de memoria de un algoritmo a medida que el tamaño de los datos de entrada ($N$) crece hacia el infinito.

```
Eficiencia:  O(1) [Excelente] < O(log N) [Muy Bueno] < O(N) [Aceptable] < O(N^2) [Inviable a gran escala]
```

---

### 🔍 Comparativa de Algoritmos de Búsqueda:

#### 1. Búsqueda Lineal ($O(N)$):
- Revisa elemento por elemento desde el primero hasta el último.
- En una lista de $1.000.000$ de elementos, en el peor caso requiere **$1.000.000$ de comparaciones**.

#### 2. Búsqueda Binaria ($O(\log N)$):
- **Requisito Obligatorio:** El arreglo debe estar previamente **ORDENADO**.
- **Funcionamiento:** Compara el elemento buscado con el valor central del arreglo. Si es menor, descarta toda la mitad derecha; si es mayor, descarta la mitad izquierda. Repite el proceso dividiendo el espacio a la mitad en cada paso.
- En una lista de $1.000.000$ de elementos, ¡requiere como máximo **solo 20 comparaciones**! ($\log_2(1.000.000) \approx 20$).$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la complejidad temporal de una búsqueda binaria sobre un arreglo ordenado de N elementos?","options":["O(N)","O(log N)","O(N^2)","O(1)"],"correctIndex":1,"explanation":"La búsqueda binaria divide el espacio de búsqueda a la mitad en cada paso iterativo, logrando una complejidad logarítmica O(log N)."},{"id":"q2","question":"¿Cuál es el requisito indispensable e ineludible para poder aplicar el algoritmo de Búsqueda Binaria?","options":["Que la lista tenga números negativos","Que el arreglo de datos esté estrictamente ordenado","Que la lista tenga menos de 100 elementos","Que los datos estén guardados en una base de datos SQL"],"correctIndex":1,"explanation":"Si los datos no están ordenados, no es posible descartar con certeza la mitad de los elementos al comparar contra el elemento central."},{"id":"q3","question":"Si un algoritmo tiene una complejidad temporal de O(1), ¿qué significa respecto a su tiempo de ejecución?","options":["Que tarda exactamente 1 segundo en terminar","Que el tiempo de ejecución es constante e independiente del tamaño de la entrada de datos (N)","Que solo puede ejecutarse una sola vez","Que realiza N operaciones lineales"],"correctIndex":1,"explanation":"O(1) representa tiempo constante: la operación tarda lo mismo sin importar si el conjunto de datos tiene 10 o 10.000.000 de elementos."}]$JSON$,
    8
  );

  -- ==============================================================================
  -- MÓDULO 3: Paradigmas, Funciones Puras, Git y Ciberseguridad
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Paradigmas, Funciones Puras, Git y Ciberseguridad',
    'Aprende buenas prácticas de ingeniería de software, arquitectura limpia, control de versiones y seguridad.',
    '3'
  ) RETURNING id INTO v_m3_id;

  -- Lección 3.1: Funciones Puras y Modularidad
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '9. Funciones Puras, Inmutabilidad y Modularidad',
    'Descubre por qué las funciones sin efectos secundarios son la base del software robusto y testeable.',
    'quiz',
    80,
    $THEORY$# Funciones Puras y Principios de Modularidad

En el desarrollo de software profesional, la **previsibilidad** y la **ausencia de efectos secundarios inesperados** son cruciales.

### ✨ ¿Qué es una Función Pura (*Pure Function*)?
Una función es pura si cumple estrictamente dos condiciones:
1. **Determinismo Idéntico:** Para los mismos argumentos de entrada, **siempre devuelve exactamente el mismo valor de salida**.
2. **Cero Efectos Secundarios (*No Side Effects*):** No modifica ninguna variable global externa, no muta los parámetros recibidos por referencia, ni altera el estado del sistema fuera de su propio ámbito local.

```javascript
// ✅ Función PURA: No altera nada externo y siempre devuelve el mismo resultado
function calcularTotal(precio, impuesto) {
  return precio + (precio * impuesto);
}

// ❌ Función IMPURA: Modifica una variable global externa y depende de la hora actual
let balanceGlobal = 1000;
function transferirImpuro(monto) {
  balanceGlobal -= monto; // Efecto secundario: muta estado externo
  console.log("Transferencia realizada a las: " + new Date());
}
```

### 🎯 Beneficios de las Funciones Puras:
- Fáciles de someter a **pruebas unitarias (Unit Tests)** automatizadas.
- Libres de condiciones de carrera (*Race Conditions*) en entornos concurrentes y multi-hilo.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es el propósito fundamental de una función pura en programación?","options":["Modificar variables globales del sistema para compartir datos","Devolver siempre el mismo resultado para los mismos argumentos sin causar efectos secundarios externos","Imprimir texto en la consola de depuración","Conectarse directamente a una base de datos externa"],"correctIndex":1,"explanation":"Las funciones puras son deterministas y aisladas: facilitan el testing, evitan bugs por estado compartido y no mutan variables externas."},{"id":"q2","question":"¿Cuál de los siguientes comportamientos convierte a una función en 'impura'?","options":["Retornar la suma de dos números recibidos por parámetro","Modificar el valor de una variable global declarada fuera de la función","Declarar una variable local temporal dentro de la función","Tener una sentencia 'return'"],"correctIndex":1,"explanation":"Modificar el estado global o externo constituye un efecto secundario (side effect) que rompe la pureza de la función."},{"id":"q3","question":"¿Qué ventaja clave ofrecen las funciones puras al momento de escribir pruebas unitarias automatizadas?","options":["Que se ejecutan en servidores web automáticamente","Que no requieren configurar estados globales complejos ni mocks porque solo dependen de sus argumentos de entrada","Que eliminan la necesidad de compilar el código","Que no consumen memoria RAM"],"correctIndex":1,"explanation":"Al depender exclusivamente de sus parámetros, probar una función pura solo requiere pasarle entradas y verificar que la salida coincida con la esperada."}]$JSON$,
    9
  );

  -- Lección 3.2: Tipos de Datos y Estructuras Compuestas
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '10. Tipos Primitivos, Diccionarios y Tablas Hash',
    'Comprende cómo se representan números, textos y mapas clave-valor en memoria.',
    'quiz',
    75,
    $THEORY$# Tipos de Datos y Estructuras Clave-Valor

### 📦 1. Tipos de Datos Primitivos:
- **Enteros (`int`):** Números sin decimales (`-42`, `0`, `100`).
- **Flotantes (`float` / `double`):** Números con punto decimal en formato IEEE 754 (`3.14159`).
- **Booleanos (`bool`):** Verdadero o Falso (`true` / `false`).
- **Caracteres (`char`):** Un solo símbolo o letra (`'A'`, `'9'`).

---

### 🗝️ 2. Estructuras Clave-Valor (Mapas / Diccionarios / Hash Tables):
Almacenan pares formados por una **Clave única (*Key*)** y su **Valor asociado (*Value*)**.
- Ejemplo: `{"usuario": "alex", "nivel": 5, "activo": true}`
- **¿Cómo logran acceso $O(1)$ promedio?**
  Utilizan una **Función Hash** matemática que convierte la clave en un índice numérico de memoria, permitiendo recuperar o modificar el valor de forma instantánea sin necesidad de recorrer toda la estructura.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Qué estructura de datos permite asociar valores a claves únicas con un tiempo promedio de búsqueda e inserción de O(1)?","options":["Lista enlazada simple","Tabla Hash (Diccionario / Mapa clave-valor)","Pila LIFO","Árbol de decisión"],"correctIndex":1,"explanation":"Las Tablas Hash transforman la clave en un índice directo de memoria mediante una función hash, permitiendo acceso promedio O(1)."},{"id":"q2","question":"¿Qué tipo de dato primitivo es el más adecuado para representar si un usuario ha verificado o no su correo electrónico?","options":["Entero de 64 bits","Booleano (Boolean: true/false)","Cadena de texto (String)","Flotante (Float)"],"correctIndex":1,"explanation":"Un booleano almacena de forma óptima estados binarios (verdadero o falso, sí o no)."},{"id":"q3","question":"¿Qué ocurre en una Tabla Hash cuando dos claves diferentes generan exactamente el mismo índice de memoria mediante la función hash?","options":["El programa se cierra con error","Ocurre una Colisión Hash, la cual se resuelve mediante técnicas como encadenamiento (Chaining) o direccionamiento abierto","Se sobreescribe irreversiblemente el primer dato","Se bloquea la base de datos"],"correctIndex":1,"explanation":"Las colisiones son naturales en funciones hash y las estructuras modernas las resuelven eficientemente mediante listas de encadenamiento o sondeo."}]$JSON$,
    10
  );

  -- Lección 3.3: Control de Versiones con Git y Colaboración
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '11. Control de Versiones Profesional con Git',
    'Aprende por qué Git es el estándar no negociable de la industria para colaborar y rastrear código.',
    'quiz',
    75,
    $THEORY$# Control de Versiones con Git

**Git** es un sistema de control de versiones distribuido creado por Linus Torvalds en 2005.

### ❓ ¿Qué problemas fundamentales resuelve Git?
1. **Historial Completo e Inmutable:** Cada cambio confirmado (*Commit*) guarda quién modificó qué, cuándo y por qué (mensaje de commit), identificado por un hash criptográfico.
2. **Ramificaciones (*Branches*):** Permite a múltiples desarrolladores trabajar en nuevas características de forma paralela y aislada sin alterar la rama de producción (`main`).
3. **Fusiones (*Merges*) y Resolución de Conflictos:** Integra cambios concurrentes y señala colisiones exactas si dos personas modifican la misma línea de código.
4. **Respaldo y Reversión Segura:** Permite volver a cualquier estado funcional anterior si un error se introduce en producción.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Qué problema resuelve fundamentalmente el uso de Git y sistemas de control de versiones?","options":["Aumentar la velocidad física de la memoria RAM","Rastrear el historial de cambios en el código, facilitar la colaboración en equipo y permitir ramificaciones (branches) seguras","Compilar código JavaScript en tiempo real en el navegador","Eliminar automáticamente bugs del código"],"correctIndex":1,"explanation":"Git permite gestionar el ciclo de vida del código, auditar cambios, trabajar en equipo en ramas aisladas y revertir errores."},{"id":"q2","question":"¿Qué representa un 'Commit' en la arquitectura de Git?","options":["Una conexión remota a un servidor SSH","Una instantánea (snapshot) inmutable del proyecto en un momento dado con autor, fecha y hash único","Un archivo comprimido .zip en el escritorio","Un error de sintaxis en el código"],"correctIndex":1,"explanation":"Un commit es una captura inmutable del estado exacto del repositorio que conforma el árbol del historial del proyecto."},{"id":"q3","question":"¿Cuál es la ventaja de utilizar 'Ramas' (Branches) al desarrollar una nueva funcionalidad en un equipo?","options":["Que el código se ejecuta más rápido","Permite desarrollar y probar la nueva función de forma aislada sin afectar la versión estable principal (main) hasta que esté lista y revisada","Evita tener que escribir pruebas unitarias","Elimina la necesidad de usar contraseñas"],"correctIndex":1,"explanation":"Las ramas aíslan el trabajo en curso, permitiendo experimentar y validar código antes de integrarlo a la rama principal mediante un Merge o Pull Request."}]$JSON$,
    11
  );

  -- Lección 3.4: Ciberseguridad, Autenticación MFA y Respaldos 3-2-1
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '12. Pilares de la Ciberseguridad y Resiliencia de Datos',
    'Domina la Tríada CIA, la autenticación multi-factor (MFA), prevención de phishing y la regla 3-2-1.',
    'quiz',
    80,
    $THEORY$# Pilares de la Ciberseguridad y Resiliencia IT

La seguridad informática no es un producto, sino un proceso integral de diseño y buenas prácticas.

### 🛡️ 1. La Tríada CIA:
- **Confidencialidad:** La información solo es accesible por personas autorizadas (cifrado, permisos).
- **Integridad:** La información es verídica, exacta y no ha sido alterada o corrompida por terceros (hashes, firmas digitales).
- **Disponibilidad:** Los sistemas y datos están accesibles para los usuarios cuando los necesitan (redundancia, alta disponibilidad).

---

### 🔑 2. Autenticación Multi-Factor (MFA / 2FA):
Requiere verificar la identidad combinando al menos **dos factores distintos**:
1. **Algo que sabes:** Contraseña o PIN.
2. **Algo que tienes:** Teléfono móvil (código TOTP de Google Authenticator), token físico o llave de seguridad FIDO2.
3. **Algo que eres:** Huella dactilar, reconocimiento facial (biometría).

---

### 💾 3. La Regla de Respaldo 3-2-1:
Para garantizar que nunca se pierda información crítica:
- Mantener **3 copias** de los datos importantes.
- En **2 medios de almacenamiento diferentes** (ej: disco local y NAS).
- Con al menos **1 copia fuera del sitio (*Offsite*)**, como un almacenamiento seguro en la nube.$THEORY$,
    $JSON$[{"id":"q1","question":"Si las contraseñas de tus usuarios son filtradas en una brecha externa, ¿qué política de seguridad previene que los atacantes accedan a las cuentas corporativas?","options":["Requerir contraseñas de 25 caracteres","Exigir Autenticación Multi-Factor (MFA / 2FA) obligatoria","Cambiar el fondo de pantalla del servidor","Instalar más memoria RAM"],"correctIndex":1,"explanation":"Con MFA activo, el atacante no podrá iniciar sesión solo con la contraseña porque le faltará el segundo factor físico o biométrico."},{"id":"q2","question":"¿Qué establece el pilar de 'Integridad' dentro de la clásica Tríada CIA de seguridad informática?","options":["Que los datos estén disponibles los 365 días del año","Garantizar que la información sea exacta, confiable y que no haya sido modificada o adulterada de forma no autorizada","Que el código esté escrito en lenguaje C++","Que la red tenga una velocidad superior a 1 Gbps"],"correctIndex":1,"explanation":"La integridad asegura la exactitud y consistencia de los datos, protegiéndolos contra modificaciones no autorizadas o corrupción."},{"id":"q3","question":"Según la regla de respaldos 3-2-1 para protección contra desastres o ransomware, ¿cuál es la distribución exigida?","options":["3 servidores, 2 administradores y 1 contraseña","3 copias de los datos, en 2 medios de almacenamiento diferentes, con al menos 1 copia fuera del sitio (Offsite / Nube)","3 contraseñas, 2 usuarios y 1 firewall","3 discos duros idénticos conectados a la misma computadora"],"correctIndex":1,"explanation":"La regla 3-2-1 garantiza resiliencia total frente a fallos de hardware, incendios o ataques de ransomware al tener copias diversificadas y aisladas geográficamente."}]$JSON$,
    12
  );

END $$;
