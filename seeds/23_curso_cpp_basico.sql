-- ==============================================================================
-- 🚀 CODIFY SEED: 23 - CURSO COMPLETO: FUNDAMENTOS DE PROGRAMACIÓN EN C++
-- ==============================================================================
-- Este script inserta:
-- 1. Curso: "Fundamentos de Programación en C++" con Ficha Técnica
-- 2. Prerrequisito enlazado a "Fundamentos IT y Lógica"
-- 3. Tres módulos secuenciales con 12 lecciones completas (Teoría + Quizzes)
-- ==============================================================================

DO $$
DECLARE
  v_author_id UUID;
  v_prereq_id UUID;
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

  -- 2. Obtener curso prerrequisito (Fundamentos IT o Inicial)
  SELECT id INTO v_prereq_id FROM public.courses WHERE title ILIKE '%Fundamentos IT%' LIMIT 1;

  -- 3. Limpiar curso previo si existe para re-inserción limpia
  DELETE FROM public.courses WHERE title = 'Fundamentos de Programación en C++';

  -- 4. Crear Curso de C++
  INSERT INTO public.courses (
    title,
    description,
    summary,
    tags,
    prerequisite_course_id,
    min_level,
    author_id,
    status
  ) VALUES (
    'Fundamentos de Programación en C++',
    'Aprende uno de los lenguajes más rápidos, potentes y demandados del mundo: arquitectura del compilador, sintaxis moderna, gestión de memoria (Stack vs Heap), punteros, referencias, Programación Orientada a Objetos (POO) y la STL.',
    E'## 🚀 Acerca del Curso\n\nC++ es el estándar indiscutible de la industria para desarrollo de sistemas operativos, motores de videojuegos (Unreal Engine), navegadores web, bases de datos y sistemas de alto rendimiento y baja latencia.\n\nEn este curso aprenderás desde la estructura básica de compilación hasta la gestión rigurosa de memoria, punteros, referencias, clases y contenedores estándar de la STL.\n\n### 🎯 ¿Qué aprenderás?\n- **El Modelo de Compilación:** Preprocesador (`#include`, `#define`), Compilación a código objeto y Linker.\n- **Sintaxis y Tipado Fuerte:** Tipos primitivos, modificadores, deducción de tipos con `auto` y control de flujo.\n- **Funciones y Paso de Parámetros:** Paso por valor, paso por referencia (`&`) y optimización con `const &`.\n- **Memoria y Punteros:** El Stack vs el Heap, aritmética de punteros, desreferenciación (`*`), `nullptr`, `new` y `delete`.\n- **POO y RAII:** Encapsulamiento (`class` vs `struct`), constructores, destructores, herencia y polimorfismo con `virtual`.\n- **Standard Template Library (STL):** Uso de `std::vector`, `std::string`, `std::map` y algoritmos de ordenación.\n\n### 👥 ¿A quién está dirigido?\nEstudiantes y desarrolladores que quieran dominar los fundamentos de la computación a bajo nivel, comprender cómo funciona la memoria real del procesador y escribir código ultra eficiente.',
    ARRAY['Teórico', 'C++', 'Backend', 'Sistemas', 'Rendimiento', 'Algoritmos'],
    v_prereq_id,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Sintaxis Base, Tipos de Datos y Control de Flujo
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Sintaxis Base, Tipos de Datos y Control de Flujo',
    'Domina la estructura de un ejecutable en C++, el flujo de entrada/salida estándar y las estructuras de decisión.',
    '1'
  ) RETURNING id INTO v_m1_id;

  -- Lección 1.1: Estructura de un Programa C++ e I/O
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '1. Estructura de un Programa en C++ e I/O',
    'Comprende la función main, los encabezados del preprocesador y los streams std::cout y std::cin.',
    'quiz',
    75,
    E'# Estructura de un Programa en C++

C++ es un lenguaje compilado directamente a código máquina nativo. Cada programa ejecutable debe contener exactamente una función de entrada llamada `main()`.

### 1. El Programa Mínimo:
```cpp
#include <iostream> // Directiva del preprocesador para entrada y salida

int main() {
    std::cout << "¡Hola, Codify!" << std::endl;
    return 0; // 0 indica terminación exitosa al sistema operativo
}
```

### 2. Elementos Clave:
- **`#include <iostream>`**: Incluye la biblioteca estándar de flujo de datos (*Input/Output Stream*).
- **`std::cout`**: Flujo de salida estándar (*Character Output*), normalmente conectado a la consola.
- **`<<`**: Operador de inserción en el flujo.
- **`std::cin`**: Flujo de entrada estándar (*Character Input*) para leer datos del teclado mediante el operador de extracción `>>`.
- **`std::endl`**: Inserta un salto de línea (`\\n`) y vacía el búfer de salida (*flush*).',
    '[{"id":"q1","question":"¿Cuál es el punto de entrada obligatorio en todo ejecutable estándar de C++?","options":["void init()","int main()","void start()","int EntryPoint()"],"correctIndex":1,"explanation":"La función obligatoria de entrada definida por el estándar de C++ es int main()."},{"id":"q2","question":"¿Qué operador se utiliza para enviar datos hacia el flujo de consola std::cout?","options":["Operador de inserción <<","Operador de extracción >>","Operador de flecha ->","Operador de asignación ="],"correctIndex":0,"explanation":"std::cout utiliza el operador de inserción << para enviar texto y variables a la consola."},{"id":"q3","question":"¿Qué diferencia existe entre utilizar std::endl y el carácter \"\\n\"?","options":["No existe ninguna diferencia","std::endl además de insertar un salto de línea fuerza el vaciado del búfer (flush)","std::endl solo funciona en Windows","\"\\n\" no es válido en C++"],"correctIndex":1,"explanation":"std::endl inserta \\n y ejecuta un flush explícito en el búfer de salida."}]',
    1
  );

  -- Lección 1.2: Tipos Primitivos, Variables y Modificadores
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '2. Tipos de Datos Primitivos y Modificadores',
    'Aprende sobre enteros, flotantes, caracteres, booleanos, modificadores const y unsigned.',
    'quiz',
    75,
    E'# Tipos de Datos Primitivos en C++

C++ es un lenguaje con **tipado estático y fuerte**: el tipo de cada variable se determina en tiempo de compilación y no puede cambiar.

### 1. Tipos Fundamentales:
- **`int`**: Números enteros (habitualmente 4 bytes, ej: `42`).
- **`double`**: Números en coma flotante de doble precisión (8 bytes, ej: `3.14159`).
- **`float`**: Coma flotante de simple precisión (4 bytes).
- **`char`**: Un único carácter ASCII (1 byte, ej: `\'A\'`).
- **`bool`**: Valor booleano (`true` o `false`, 1 byte).

### 2. Modificadores de Tipo:
- **`unsigned`**: Solo admite números positivos (duplica el rango positivo al no requerir bit de signo).
- **`const`**: Declara una variable como de **solo lectura**. Su valor no puede modificarse tras su inicialización.
- **`auto` (C++11)**: El compilador deduce automáticamente el tipo a partir de la expresión de inicialización.',
    '[{"id":"q1","question":"Si declaramos una variable como \'const int MAX_USERS = 100;\', ¿qué ocurre si intentamos hacer \'MAX_USERS = 200;\' más adelante?","options":["El valor se actualiza correctamente","Ocurre un error en tiempo de compilación","Ocurre una advertencia en tiempo de ejecución","La variable pasa a ser de tipo float"],"correctIndex":1,"explanation":"Las variables declaradas con const son inmutables; cualquier intento de reasignación genera un error de compilación."},{"id":"q2","question":"¿Qué efecto tiene aplicar el modificador \'unsigned\' a una variable entera?","options":["Permite almacenar números negativos mayores","Hace que solo admita valores positivos, duplicando el límite superior positivo","Convierte el entero a decimal","Hace que la variable sea constante"],"correctIndex":1,"explanation":"unsigned elimina el bit de signo negativo, permitiendo que todos los bits representen valores positivos (ej. 0 a 4,294,967,295 en 32 bits)."},{"id":"q3","question":"¿Para qué se introdujo la palabra clave \'auto\' en el estándar C++11?","options":["Para ejecutar bucles automáticos","Para que el compilador deduzca automáticamente el tipo de la variable según su valor de inicialización","Para crear variables globales","Para acelerar la velocidad del procesador"],"correctIndex":1,"explanation":"auto permite la inferencia de tipos en tiempo de compilación basándose en el valor asignado."}]',
    2
  );

  -- Lección 1.3: Operadores y Expresiones
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '3. Operadores Aritméticos, Lógicos y Ternario',
    'Conoce los operadores de C++, evaluación de cortocircuito y el operador condicional ternario.',
    'quiz',
    75,
    E'# Operadores en C++

Los operadores permiten realizar cálculos matemáticos, comparaciones y evaluaciones lógicas.

### 1. Operadores Principales:
- **Aritméticos**: `+`, `-`, `*`, `/`, `%` (módulo o resto de división entera).
- **Incremento/Decremento**: `++x` (pre-incremento) y `x++` (post-incremento).
- **Relacionales**: `==`, `!=`, `<`, `>`, `<=`, `>=`.
- **Lógicos**: `&&` (AND), `||` (OR), `!` (NOT).

### 2. Evaluación de Cortocircuito (*Short-circuit evaluation*):
En expresiones lógicas:
- En `A && B`, si `A` es falso, `B` **nunca se evalúa**.
- En `A || B`, si `A` es verdadero, `B` **nunca se evalúa**.

### 3. Operador Ternario:
```cpp
int edad = 20;
std::string estado = (edad >= 18) ? "Mayor de edad" : "Menor de edad";
```',
    '[{"id":"q1","question":"¿Cuál es el resultado de la expresión entera en C++: \'7 / 2\'?","options":["3.5","3","4","Error de sintaxis"],"correctIndex":1,"explanation":"Al dividir dos números enteros en C++, se realiza una división entera que trunca los decimales, dando como resultado 3."},{"id":"q2","question":"¿Qué valor tendrá \'y\' tras ejecutar \'int x = 5; int y = ++x;\'?","options":["5","6","4","Indefinido"],"correctIndex":1,"explanation":"El pre-incremento (++x) incrementa x a 6 y luego devuelve el nuevo valor para asignarlo a y."},{"id":"q3","question":"¿Qué propiedad caracteriza a la evaluación de cortocircuito en expresiones con \'||\'?","options":["Siempre evalúa ambos lados obligatoriamente","Si el primer operando es verdadero, el segundo operando no se ejecuta","Convierte el resultado a entero","Invierte el valor de las variables"],"correctIndex":1,"explanation":"En una disyunción lógica (||), si el primer término es verdadero, la condición completa ya es verdadera y se omite la evaluación del segundo operando."}]',
    3
  );

  -- Lección 1.4: Estructuras de Control y Bucles Modernos
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '4. Estructuras de Control y Bucles Modernos',
    'Aprende condicionales switch-case y bucles clásicos y basados en rango (range-based for).',
    'quiz',
    75,
    E'# Estructuras de Control en C++

Las estructuras de control permiten dirigir el flujo de ejecución del programa.

### 1. Condicionales:
```cpp
if (nivel >= 10) {
    std::cout << "Nivel Avanzado";
} else if (nivel >= 5) {
    std::cout << "Nivel Intermedio";
} else {
    std::cout << "Nivel Inicial";
}
```

### 2. Sentencia `switch / case`:
Se utiliza para comparar una variable contra múltiples valores constantes:
```cpp
switch (opcion) {
    case 1: std::cout << "Iniciar"; break; // ¡break es crucial para evitar fall-through!
    case 2: std::cout << "Opciones"; break;
    default: std::cout << "Desconocido";
}
```

### 3. Bucles en C++:
- **`for` clásico**: `for (int i = 0; i < 5; ++i) { ... }`
- **`while`**: Se repite mientras la condición sea verdadera.
- **`do-while`**: Se ejecuta al menos una vez antes de verificar la condición.
- **Range-based `for` (C++11)**: Itera sobre colecciones de forma limpia:
```cpp
int numeros[] = {10, 20, 30, 40};
for (int n : numeros) {
    std::cout << n << " ";
}
```',
    '[{"id":"q1","question":"¿Qué ocurre si omites la instrucción \'break;\' al final de un bloque \'case\' dentro de un switch en C++?","options":["El código no compila","Ocurre \'fall-through\', ejecutándose también el siguiente case de forma continua","El programa termina inmediatamente","Se genera un bucle infinito"],"correctIndex":1,"explanation":"Sin break, la ejecución continúa secuencialmente en el siguiente bloque case (comportamiento conocido como fall-through)."},{"id":"q2","question":"¿Cuál es la principal garantía del bucle \'do-while\' frente al bucle \'while\' ordinario?","options":["Es más rápido","Se ejecuta al menos una vez antes de evaluar la condición","No requiere llaves de bloque","Solo admite variables enteras"],"correctIndex":1,"explanation":"do-while evalúa la condición al final de la iteración, garantizando que su cuerpo se ejecute al menos una vez."},{"id":"q3","question":"¿Cómo se escribe un bucle basado en rango (range-based for) para recorrer una lista de enteros en C++11?","options":["for (int i = 0; i < list.size; i++)","for (int item : lista)","foreach (item in lista)","loop (lista as item)"],"correctIndex":1,"explanation":"La sintaxis de range-based for en C++11 es for (tipo elemento : coleccion)."}]',
    4
  );

  -- ==============================================================================
  -- MÓDULO 2: Funciones, Memoria, Punteros y Referencias
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Funciones, Memoria, Punteros y Referencias',
    'Comprende cómo el procesador gestiona el Stack vs Heap, punteros, referencias y punteros inteligentes.',
    '2'
  ) RETURNING id INTO v_m2_id;

  -- Lección 2.1: Declaración, Definición y Paso por Valor
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '1. Funciones: Declaración vs Definición y Paso por Valor',
    'Aprende sobre prototipos de funciones, modularización y cómo el paso por valor realiza copias.',
    'quiz',
    100,
    E'# Funciones en C++

Las funciones permiten encapsular lógica reutilizable y dividir programas en componentes modulares.

### 1. Prototipo (Declaración) vs Definición:
En C++, una función debe ser conocida por el compilador antes de poder ser invocada.
- **Prototipo (Header / Arriba)**: `int sumar(int a, int b);`
- **Definición**:
```cpp
int sumar(int a, int b) {
    return a + b;
}
```

### 2. Paso por Valor (*Pass by Value*):
Por defecto, cuando pasas un argumento a una función, C++ crea una **copia exacta e independiente** de ese dato:
```cpp
void duplicar(int x) {
    x = x * 2; // Solo modifica la copia local en el Stack de la función
}
```
Si la variable original fuera un objeto grande (como un vector con 1 millón de elementos), copiarlo por valor tendría un alto coste de rendimiento.',
    '[{"id":"q1","question":"¿Por qué se utilizan prototipos de funciones en C++?","options":["Para que el compilador conozca la firma de la función antes de su implementación completa","Para reservar memoria en el disco","Para obligar a que la función sea pública","Para evitar el uso de variables globales"],"correctIndex":0,"explanation":"Los prototipos informan al compilador del nombre, parámetros y tipo de retorno de la función antes de que sea llamada en el código."},{"id":"q2","question":"Si pasas una variable a una función por valor y la modificas dentro de la función, ¿qué le ocurre a la variable original?","options":["Se modifica permanentemente","Permanece inalterada porque la función solo modificó una copia local","Se convierte en puntero","Se elimina de la memoria"],"correctIndex":1,"explanation":"El paso por valor genera una copia en la pila (Stack); los cambios dentro de la función no afectan la variable original."},{"id":"q3","question":"¿Cuál es el principal inconveniente de pasar estructuras u objetos muy pesados por valor?","options":["Genera errores de compilación","Provoca una penalización de rendimiento y memoria por tener que duplicar todos los datos","No se pueden retornar valores","Requiere reiniciar el programa"],"correctIndex":1,"explanation":"Copiar objetos grandes requiere asignar memoria y copiar byte a byte, lo que degrada el rendimiento de la aplicación."}]',
    1
  );

  -- Lección 2.2: Paso por Referencia y const Reference
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '2. Referencias y Paso por const Reference',
    'Optimiza el paso de parámetros utilizando alias en memoria y evitando copias innecesarias.',
    'quiz',
    100,
    E'# Referencias en C++

Una **referencia** es un alias o nombre alternativo para una variable existente en memoria. No ocupa un espacio nuevo; apunta directamente a la misma celda de memoria.

### 1. Sintaxis de una Referencia (`&`):
```cpp
int a = 10;
int& ref = a; // ref es un alias directo de 'a'
ref = 25;     // Ahora 'a' también vale 25
```

### 2. Paso por Referencia:
Permite que una función modifique la variable original sin crear copias:
```cpp
void duplicar(int& x) {
    x *= 2; // Modifica la variable original
}
```

### 3. El Estándar Profesional: `const T&`:
Cuando queremos pasar un objeto grande de forma ultra rápida sin copiarlo, pero **sin permitir que la función lo altere accidentalmente**, usamos **const reference**:
```cpp
void imprimirTexto(const std::string& texto) {
    // texto no se copia (0 overhead) y no se puede modificar
    std::cout << texto << std::endl;
}
```',
    '[{"id":"q1","question":"¿Qué es conceptualmente una referencia en C++?","options":["Una copia en el disco","Un alias o apodo directo a una variable existente en memoria","Un tipo de dato decimal","Una función recursiva"],"correctIndex":1,"explanation":"Una referencia (&) actúa como un alias para una variable ya creada, compartiendo su misma dirección de memoria."},{"id":"q2","question":"¿Cuál es el patrón recomendado en C++ para pasar objetos grandes a funciones evitando copias y protegiéndolos contra modificaciones?","options":["Paso por valor ordinario","Paso por const reference (const Tipo&)","Paso por puntero nulo","Paso por macro"],"correctIndex":1,"explanation":"const Tipo& garantiza cero copias de memoria (máxima velocidad) y previene cualquier mutación no deseada."},{"id":"q3","question":"¿Puede una referencia en C++ ser reasignada para apuntar a otra variable distinta tras haber sido inicializada?","options":["Sí, en cualquier momento","No, una vez ligada a una variable, siempre referenciará a esa misma celda de memoria","Solo si es de tipo const","Solo dentro de bucles"],"correctIndex":1,"explanation":"Las referencias deben inicializarse al crearse y no pueden reasignarse para apuntar a otra variable."}]',
    2
  );

  -- Lección 2.3: Punteros, Direcciones de Memoria y Desreferenciación
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '3. Punteros, Operador Dirección (&) y Desreferenciación (*)',
    'Domina la manipulación directa de direcciones de memoria, el operador flecha y el puntero nullptr.',
    'quiz',
    100,
    E'# Punteros en C++

Un **puntero** es una variable que almacena la **dirección física de memoria** de otra variable.

### 1. Operadores Fundamentales:
- **`&` (Dirección de)**: Obtiene la dirección hexadecimal donde reside una variable en la RAM.
- **`*` (Desreferenciación)**: Accede al valor almacenado en la dirección a la que apunta el puntero.

### 2. Ejemplo Práctico:
```cpp
int numero = 42;
int* ptr = &numero; // ptr almacena la dirección de 'numero' (ej: 0x7ffee4)

std::cout << ptr;   // Imprime la dirección: 0x7ffee4
std::cout << *ptr;  // Imprime el valor: 42 (desreferenciación)

*ptr = 99;          // Modifica el valor de 'numero' a través del puntero
```

### 3. Punteros Nulos (`nullptr`):
En C++ moderno (C++11), nunca se debe dejar un puntero sin inicializar. Si no apunta a nada, se asigna `nullptr`:
```cpp
int* p = nullptr;
if (p != nullptr) {
    // Seguro para desreferenciar
}
```',
    '[{"id":"q1","question":"¿Qué almacena exactamente una variable de tipo puntero (ej. int* ptr)?","options":["El valor numérico de la variable","La dirección de memoria donde reside otra variable","El tamaño del ejecutable","El nombre del archivo fuente"],"correctIndex":1,"explanation":"Un puntero guarda como dato la dirección de memoria física (dirección en la RAM) de otra entidad."},{"id":"q2","question":"Si tenemos \'int x = 10; int* p = &x;\', ¿qué expresión modifica el valor de \'x\' a través del puntero?","options":["p = 20;","&p = 20;","*p = 20;","x* = 20;"],"correctIndex":2,"explanation":"El operador de desreferenciación (*p) permite leer y modificar el valor almacenado en la dirección apuntada."},{"id":"q3","question":"¿Cuál es el valor estándar en C++11 para indicar que un puntero no apunta a ninguna dirección válida?","options":["NULL_PTR","0x00","nullptr","void"],"correctIndex":2,"explanation":"nullptr es el literal tipado de puntero nulo introducido en C++11 que reemplaza al macro NULL heredado de C."}]',
    3
  );

  -- Lección 2.4: Memoria Dinámica: Stack vs Heap y Smart Pointers
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '4. Stack vs Heap, new/delete y Smart Pointers',
    'Entiende la gestión de memoria dinámica, fugas de memoria y punteros inteligentes std::unique_ptr.',
    'quiz',
    100,
    E'# Gestión de Memoria Dinámica: Stack vs Heap

En C++, el programa dispone de dos zonas principales de memoria para datos:

### 1. El Stack (Pila):
- **Características**: Ultra rápido, gestionado automáticamente por el procesador.
- **Ciclo de vida**: Las variables locales se destruyen automáticamente al salir del ámbito (`{}`).
- **Limitación**: Tamaño fijo y relativamente pequeño (riesgo de *Stack Overflow*).

### 2. El Heap (Montículo):
- **Características**: Gran capacidad de almacenamiento, asignado manualmente en tiempo de ejecución.
- **Sintaxis Clásica**:
```cpp
int* p = new int(100); // Reserva memoria en el Heap
// ... usar p ...
delete p;              // ¡Obligatorio! Si no se libera, ocurre una fuga de memoria (Memory Leak)
p = nullptr;
```

### 3. Punteros Inteligentes Modernos (`std::unique_ptr`):
En C++ moderno (C++14), casi nunca usamos `new`/`delete` manualmente. Usamos **Smart Pointers** (`<memory>`) que liberan la memoria automáticamente al salir del scope:
```cpp
#include <memory>
auto ptr = std::make_unique<int>(100); // Se destruye y libera solo (Memory-Safe)
```',
    '[{"id":"q1","question":"¿Qué ocurre cuando una variable local declarada en el Stack sale de su ámbito (scope de llaves)?","options":["Permanece en memoria para siempre","Se destruye automáticamente y su memoria se recupera de inmediato","Se traslada al Heap","Provoca una fuga de memoria"],"correctIndex":1,"explanation":"La memoria del Stack se libera de forma automática e instantánea al salir del bloque de código donde fue declarada."},{"id":"q2","question":"¿Qué problema crítico ocurre si reservas memoria en el Heap con \'new\' pero nunca llamas a \'delete\'?","options":["Segmentation fault instantáneo","Fuga de memoria (Memory Leak), consumiendo RAM progresivamente sin liberarla","El compilador borra el archivo","El programa no compila"],"correctIndex":1,"explanation":"No liberar la memoria asignada dinámicamente provoca que el proceso retenga RAM indefinidamente (fuga de memoria)."},{"id":"q3","question":"¿Qué ventaja ofrece \'std::unique_ptr\' frente a un puntero crudo tradicional?","options":["Es más lento pero usa menos bits","Gestiona la propiedad exclusiva y libera automáticamente la memoria al salir de ámbito evitando fugas","Permite duplicar punteros nulos","Solo funciona con números enteros"],"correctIndex":1,"explanation":"std::unique_ptr implementa el principio RAII, eliminando la necesidad de llamar a delete manualmente y evitando fugas de memoria."}]',
    4
  );

  -- ==============================================================================
  -- MÓDULO 3: Programación Orientada a Objetos y la STL
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Programación Orientada a Objetos y la STL',
    'Modela sistemas con Clases, RAII, Herencia, Polimorfismo y aprovecha los contenedores estándar de C++.',
    '3'
  ) RETURNING id INTO v_m3_id;

  -- Lección 3.1: Clases, Structs y Encapsulamiento
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '1. Clases, Structs y Modificadores de Acceso',
    'Aprende a diseñar tipos de datos propios con atributos privados y métodos públicos.',
    'quiz',
    125,
    E'# Clases y Encapsulamiento en C++

La Programación Orientada a Objetos (POO) permite agrupar datos (atributos) y las funciones que los manipulan (métodos) en una sola entidad.

### 1. `struct` vs `class`:
En C++, la **única diferencia técnica** entre un `struct` y un `class` es su visibilidad por defecto:
- En un `struct`, los miembros son **`public`** por defecto.
- En un `class`, los miembros son **`private`** por defecto.

### 2. Modificadores de Acceso:
- **`public`**: Accesible desde cualquier parte del código.
- **`private`**: Solo accesible desde los métodos internos de la propia clase.
- **`protected`**: Accesible desde la propia clase y sus clases hijas (herencia).

```cpp
class Jugador {
private:
    int salud = 100; // Encapsulado

public:
    void recibirDanio(int puntos) {
        salud -= puntos;
        if (salud < 0) salud = 0;
    }

    int obtenerSalud() const {
        return salud;
    }
};
```',
    '[{"id":"q1","question":"¿Cuál es la única diferencia sintáctica y de diseño entre una \'struct\' y una \'class\' en C++?","options":["Las structs no pueden tener métodos","En una struct los miembros son públicos por defecto, mientras que en una class son privados por defecto","Las structs se guardan en el disco y las clases en la RAM","Las clases no soportan herencia"],"correctIndex":1,"explanation":"En C++, struct y class son idénticas salvo porque struct tiene acceso public por defecto y class tiene acceso private por defecto."},{"id":"q2","question":"¿Qué principio de la POO se aplica al declarar los atributos como \'private\' y proveer métodos públicos para interactuar con ellos?","options":["Herencia","Encapsulamiento","Polimorfismo","Compilación cruzada"],"correctIndex":1,"explanation":"El encapsulamiento protege el estado interno de un objeto controlando cómo se lee y modifica desde el exterior."},{"id":"q3","question":"¿Qué indica la palabra clave \'const\' al final de un método como \'int getX() const;\'?","options":["Que el método devuelve una constante obligatoriamente","Que el método garantiza que no modificará ningún atributo del objeto","Que el método es estático","Que solo se puede llamar una vez"],"correctIndex":1,"explanation":"Un método const garantiza al compilador que no alterará el estado interno de la instancia sobre la que se invoca."}]',
    1
  );

  -- Lección 3.2: Constructores, Destructores y Principio RAII
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '2. Constructores, Destructores y el Principio RAII',
    'Conoce el ciclo de vida de los objetos y la técnica fundamental de gestión de recursos de C++.',
    'quiz',
    125,
    E'# Constructores, Destructores y RAII

### 1. Constructor:
Se ejecuta automáticamente en el momento en que se instancia un objeto. Sirve para inicializar su estado:
```cpp
class Archivo {
public:
    // Constructor
    Archivo(const std::string& ruta) {
        std::cout << "Abriendo archivo: " << ruta << std::endl;
    }
};
```

### 2. Destructor (`~NombreClase`):
Se ejecuta automáticamente cuando el objeto llega al final de su ciclo de vida y sale de ámbito:
```cpp
    // Destructor
    ~Archivo() {
        std::cout << "Cerrando archivo y liberando recursos." << std::endl;
    }
```

### 3. El Principio RAII (*Resource Acquisition Is Initialization*):
Es el pilar maestro de C++:
- Todo recurso (memoria dinámica, sockets de red, archivos abiertos, hilos, mutexes) se adquiere en el constructor y se libera automáticamente en el destructor.
- Esto garantiza que **nunca haya fugas de recursos**, incluso si ocurren excepciones en el código.',
    '[{"id":"q1","question":"¿Cuándo se ejecuta el destructor de un objeto en C++?","options":["Solo cuando el usuario presiona Ctrl+C","Automáticamente cuando el objeto sale de ámbito (scope) o se destruye","Antes del constructor","Solo si ocurre un error"],"correctIndex":1,"explanation":"El destructor (~Clase) se invoca de forma determinista y automática cuando la vida útil del objeto concluye."},{"id":"q2","question":"¿Qué significa el acrónimo RAII en el diseño de software con C++?","options":["Random Access Internet Interface","Resource Acquisition Is Initialization","Read All Internal Inputs","Runtime Automatic Instruction Invocation"],"correctIndex":1,"explanation":"RAII (Resource Acquisition Is Initialization) vincula el ciclo de vida de un recurso con el tiempo de vida de un objeto en el Stack."},{"id":"q3","question":"¿Cómo se define sintácticamente el destructor de una clase llamada \'ConexionDB\'?","options":["void delete()","~ConexionDB()","destroy ConexionDB()","void cleanup()"],"correctIndex":1,"explanation":"Los destructores en C++ tienen el mismo nombre de la clase precedido por el símbolo virgulilla (~)."}]',
    2
  );

  -- Lección 3.3: Herencia y Polimorfismo (virtual y override)
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '3. Herencia y Polimorfismo con virtual y override',
    'Aprende a reutilizar código mediante clases base y permitir comportamiento polimórfico en tiempo de ejecución.',
    'quiz',
    125,
    E'# Herencia y Polimorfismo en C++

La herencia permite crear clases derivadas a partir de una clase base. El polimorfismo permite tratar a objetos derivados a través de punteros o referencias de la clase base.

### 1. Herencia Básica:
```cpp
class Animal {
public:
    virtual void hacerSonido() const {
        std::cout << "Sonido genérico" << std::endl;
    }
    virtual ~Animal() = default; // ¡Siempre destructor virtual en clases base!
};

class Perro : public Animal {
public:
    void hacerSonido() const override {
        std::cout << "¡Guau guau!" << std::endl;
    }
};
```

### 2. Claves del Polimorfismo:
- **`virtual`**: Indica que un método puede ser sobrescrito por clases hijas y se resolverá dinámicamente en tiempo de ejecución mediante la tabla virtual (*vtable*).
- **`override`**: Palabra clave que verifica en tiempo de compilación que realmente estás sobrescribiendo un método virtual de la clase padre.',
    '[{"id":"q1","question":"¿Para qué se utiliza la palabra clave \'virtual\' en un método de una clase base?","options":["Para que el método no se pueda llamar","Para habilitar el despacho dinámico en tiempo de ejecución (polimorfismo)","Para hacer el código más lento a propósito","Para obligar a que la función sea inline"],"correctIndex":1,"explanation":"virtual permite que al invocar el método a través de un puntero a la clase base, se ejecute la versión de la clase derivada real."},{"id":"q2","question":"¿Por qué es fundamental que una clase base con métodos virtuales tenga su destructor declarado como \'virtual\'?","options":["Para evitar fugas de memoria al eliminar un objeto derivado a través de un puntero de la clase base","Para que el compilador no genere warnings de formato","Porque de lo contrario no compila","Para acelerar la CPU"],"correctIndex":0,"explanation":"Si el destructor de la clase base no es virtual, al hacer \'delete punteroBase\' solo se ejecutará el destructor padre, dejando sin liberar los recursos del hijo."},{"id":"q3","question":"¿Qué beneficio aporta la palabra clave \'override\' al sobrescribir un método en C++11?","options":["Permite omitir el tipo de retorno","El compilador valida que el método coincida exactamente con la firma de un método virtual de la clase base","Evita que otras clases hereden","Hace que la función sea privada"],"correctIndex":1,"explanation":"override previene errores tipográficos o discrepancias de firma al obligar al compilador a comprobar la existencia del método base."}]',
    3
  );

  -- Lección 3.4: Contenedores Estándar de la STL (vector, string, map)
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '4. La Biblioteca Estándar (STL): std::vector, string y map',
    'Aprende a utilizar las estructuras de datos más potentes de la Standard Template Library de C++.',
    'quiz',
    125,
    E'# La Standard Template Library (STL)

La STL proporciona estructuras de datos y algoritmos genéricos optimizados listos para producción.

### 1. `std::vector` (Arreglo Dinámico):
Es el contenedor por defecto en C++. Almacena elementos en memoria contigua y crece automáticamente:
```cpp
#include <vector>

std::vector<int> notas = {10, 8, 9};
notas.push_back(7); // Añade al final
std::cout << "Total: " << notas.size() << " | Primero: " << notas[0];
```

### 2. `std::unordered_map` / `std::map` (Diccionarios Clave-Valor):
Permiten asociar claves únicas con valores:
```cpp
#include <unordered_map>

std::unordered_map<std::string, int> inventario;
inventario["pociones"] = 5;
inventario["oro"] = 120;
```

### 3. Algoritmos Estándar (`<algorithm>`):
```cpp
#include <algorithm>
std::sort(notas.begin(), notas.end()); // Ordena el vector en O(N log N)
```',
    '[{"id":"q1","question":"¿Cuál es el contenedor de secuencia más utilizado y recomendado por defecto en C++ moderno?","options":["Arreglos estáticos de C (int arr[])","std::vector","std::list","std::forward_list"],"correctIndex":1,"explanation":"std::vector es el contenedor estándar recomendado gracias a su memoria contigua, excelente rendimiento de caché y tamaño dinámico."},{"id":"q2","question":"¿Qué método de \'std::vector\' se utiliza para insertar un elemento al final de la colección?","options":["insertHead()","push_back()","appendItem()","enqueue()"],"correctIndex":1,"explanation":"push_back() (o emplace_back()) añade un nuevo elemento al final del vector, redimensionando la capacidad si es necesario."},{"id":"q3","question":"¿Cómo se ordena un \'std::vector<int> v\' utilizando la librería de algoritmos estándar?","options":["v.sort();","std::sort(v.begin(), v.end());","std::order(v);","sort_array(v);"],"correctIndex":1,"explanation":"std::sort(v.begin(), v.end()) aplica una ordenación altamente optimizada basada en iteradores sobre el rango especificado."}]',
    4
  );

  -- Notificación global sobre el nuevo curso disponible
  PERFORM public.broadcast_system_notification(
    '¡Nuevo Curso de C++ Disponible! 🚀',
    'Aprende Fundamentos de C++ Moderno: compilación, Stack vs Heap, punteros, referencias, POO con RAII y la STL.',
    '/cursos/' || v_course_id || '/preview'
  );

END $$;
