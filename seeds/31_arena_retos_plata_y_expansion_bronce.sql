-- ==============================================================================
-- ⚔️ SGFC SEED: 31 - ARENA CLASIFICATORIA: EXPANSIÓN BRONCE & MÓDULO PLATA
-- ==============================================================================
-- 1. Expande el pool de Bronce con variedad de retos básicos de lógica y IT.
-- 2. Crea el Módulo exclusivo "Arena de Retos: Rango Plata" con 16 retos avanzados:
--    - Bases de Datos (SQL vs NoSQL, ACID, Índices B-Tree, Normalización)
--    - Redes y Troubleshooting (Modelo OSI 7 capas, flags TCP, DNS, traceroute)
--    - Arquitectura de Computadoras & Hardware (L1/L2/L3, CPU vs GPU, PCIe, Bottlenecks)
--    - Electrónica Básica para Sistemas (Ley de Ohm, Pull-up/down, desacoplo, compuertas)
--    - Algoritmos Complejos con tests unitarios (Two-Sum O(N), Búsqueda Binaria, Matrices 2D)
-- ==============================================================================

DO $ARENA_SEED$
DECLARE
  v_bronze_module_id UUID;
  v_silver_module_id UUID;
BEGIN

  -- 1. Obtener o crear Módulo Bronce
  SELECT id INTO v_bronze_module_id FROM public.modules WHERE title = 'Arena de Retos: Rango Bronce' LIMIT 1;
  IF v_bronze_module_id IS NULL THEN
    INSERT INTO public.modules (title, description, difficulty_level)
    VALUES (
      'Arena de Retos: Rango Bronce',
      'Retos clasificatorios de Rango Bronce: redes elementales, lógica booleana, fundamentos IT y algoritmos esenciales.',
      1
    ) RETURNING id INTO v_bronze_module_id;
  END IF;

  -- 2. Eliminar retos previos de Plata si existían para actualización limpia
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Plata'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Plata'
  );
  DELETE FROM public.modules WHERE title = 'Arena de Retos: Rango Plata';

  -- 3. Crear Módulo Plata
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Arena de Retos: Rango Plata',
    'Retos clasificatorios avanzados de Rango Plata: bases de datos relacionales y NoSQL, troubleshooting de redes y Modelo OSI, hardware, electrónica y algoritmos de complejidad Big-O.',
    2
  ) RETURNING id INTO v_silver_module_id;

  -- ============================================================================
  -- 🥉 EXPANSIÓN DE RETOS BRONCE (Nuevos retos para mayor rotación)
  -- ============================================================================

  -- BRONCE 16: Invertir una Cadena de Texto (Código)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_bronze_module_id,
    'Lógica de Código: Invertir una Cadena',
    'Crea una función que tome un texto y lo devuelva invertido carácter por carácter.',
    '# Manipulación de Cadenas de Texto
En programación, dar vuelta una cadena es un ejercicio clásico para dominar el acceso por índices y bucles decrecientes o métodos de array.

### Tu Misión:
Implementa `invertirTexto(texto)` para que reciba un string y devuelva el texto en orden inverso.
*Ejemplo:* `invertirTexto("codigo")` debe retornar `"ogidoc"`.',
    'javascript',
    'function invertirTexto(texto) {
  // Tu código aquí
}',
    'function invertirTexto(texto) {
  return texto.split("").reverse().join("");
}',
    'test("Inversión de palabra básica", () => {
  expect(invertirTexto("hola")).toBe("aloh");
  expect(invertirTexto("Codify")).toBe("yfidoC");
});
test("Cadenas con espacios", () => {
  expect(invertirTexto("a b c")).toBe("c b a");
});
test("Cadena vacía", () => {
  expect(invertirTexto("")).toBe("");
});',
    75,
    16
  );

  -- BRONCE 17: Contar Vocales (Código)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_bronze_module_id,
    'Lógica de Código: Contar Vocales',
    'Escribe un algoritmo que cuente cuántas vocales (a, e, i, o, u) contiene un texto dado.',
    '# Búsqueda y Filtrado en Texto
Para contar elementos que cumplen una condición, inicializamos un contador en 0 y recorremos la cadena verificando si cada letra pertenece al grupo de vocales.

### Tu Misión:
Implementa `contarVocales(texto)` que devuelva la cantidad total de vocales (mayúsculas o minúsculas) en el texto.
*Ejemplo:* `contarVocales("Murcielago")` debe retornar `5`.',
    'javascript',
    'function contarVocales(texto) {
  // Tu código aquí
}',
    'function contarVocales(texto) {
  const vocales = "aeiouAEIOU";
  let total = 0;
  for (let char of texto) {
    if (vocales.includes(char)) total++;
  }
  return total;
}',
    'test("Vocales en Murcielago", () => {
  expect(contarVocales("Murcielago")).toBe(5);
});
test("Texto sin vocales", () => {
  expect(contarVocales("rhythm")).toBe(0);
});
test("Vocales mayúsculas y minúsculas", () => {
  expect(contarVocales("A E I O U a e i o u")).toBe(10);
});',
    75,
    17
  );

  -- BRONCE 18: ¿Es Palíndromo? (Código)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_bronze_module_id,
    'Lógica de Código: Verificador de Palíndromos',
    'Determina si una palabra se lee exactamente igual de izquierda a derecha que de derecha a izquierda.',
    '# Palíndromos en Informática
Un palíndromo es una palabra o frase que se lee igual en ambos sentidos (ej: "radar", "reconocer", "ana").

### Tu Misión:
Implementa `esPalindromo(palabra)`: retorna `true` si es palíndromo (ignorando mayúsculas y minúsculas), o `false` en caso contrario.',
    'javascript',
    'function esPalindromo(palabra) {
  // Tu código aquí
}',
    'function esPalindromo(palabra) {
  const limpia = palabra.toLowerCase();
  return limpia === limpia.split("").reverse().join("");
}',
    'test("Palabras palíndromas", () => {
  expect(esPalindromo("radar")).toBe(true);
  expect(esPalindromo("Ana")).toBe(true);
  expect(esPalindromo("reconocer")).toBe(true);
});
test("Palabras no palíndromas", () => {
  expect(esPalindromo("computadora")).toBe(false);
  expect(esPalindromo("codigo")).toBe(false);
});',
    75,
    18
  );

  -- ============================================================================
  -- 🥈 MÓDULO PLATA: RETOS AVANZADOS PARA PROFESIONALES DE SISTEMAS
  -- ============================================================================

  -- PLATA 1: Bases de Datos - ACID vs BASE
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Bases de Datos: Propiedades ACID vs Modelo BASE',
    'Analiza la consistencia estricta en sistemas relacionales frente a la consistencia eventual en bases NoSQL.',
    '# Transacciones ACID vs Sistemas Distribuidos BASE

En la arquitectura de datos moderna existen dos filosofías fundamentales para gobernar transacciones:

### 1. Modelo ACID (Bases Relacionales: PostgreSQL, MySQL, Oracle):
- **Atomicidad (A):** La transacción es indivisible. O se ejecutan todas las operaciones con éxito, o se revierte completamente (*Rollback*).
- **Consistencia (C):** La base de datos pasa de un estado válido a otro estado válido, respetando todas las reglas e integridad referencial.
- **Aislamiento (I - *Isolation*):** Las transacciones simultáneas no interfieren entre sí como si se ejecutaran secuencialmente.
- **Durabilidad (D):** Una vez confirmada (*Commit*), los cambios son permanentes y sobreviven a cortes de energía o reinicios del servidor.

### 2. Modelo BASE (Bases NoSQL / Distribuidas: DynamoDB, Cassandra):
- **Basically Available (BA):** Alta disponibilidad del sistema garantizada mediante nodos réplica.
- **Soft state (S):** El estado de los datos puede cambiar con el tiempo sin interacción del usuario debido a la propagación.
- **Eventual consistency (E):** Se garantiza que todos los nodos convergerán con los mismos datos en un punto futuro del tiempo.',
    'quiz',
    85,
    '[{"id":"q1","question":"Si durante una transferencia bancaria entre dos cuentas el servidor sufre un corte eléctrico tras debitar dinero de la cuenta A pero antes de acreditarlo en la cuenta B, ¿qué propiedad de ACID garantiza que los fondos de A no se pierdan y se revierta la operación?","options":["Aislamiento (Isolation)","Atomicidad (Atomicity)","Durabilidad (Durability)","Consistencia Eventual"],"correctIndex":1,"explanation":"La Atomicidad garantiza que la transacción es \"todo o nada\": si un paso falla o se interrumpe, se descartan todos los cambios previos (rollback)."},{"id":"q2","question":"¿Qué característica define al principio de \"Consistencia Eventual\" en sistemas NoSQL distribuidos?","options":["Los datos se sincronizan instantáneamente en cero milisegundos en todos los nodos","Los nodos pueden mostrar datos ligeramente desactualizados durante una ventana de tiempo hasta que las réplicas se sincronicen","La base de datos nunca acepta escrituras simultáneas","Los datos se borran automáticamente tras 24 horas"],"correctIndex":1,"explanation":"Consistencia eventual prioriza disponibilidad: los nodos replican asíncronamente las escrituras hasta que eventualmente todos tienen la última versión."},{"id":"q3","question":"¿Cuál de los siguientes niveles de aislamiento en SQL previene las lecturas sucias (Dirty Reads) al evitar que una transacción lea datos modificados por otra transacción no confirmada?","options":["Read Uncommitted","Read Committed","None","Auto-Sync"],"correctIndex":1,"explanation":"Read Committed garantiza que solo se leen datos que ya hayan hecho COMMIT, bloqueando lecturas intermedias no confirmadas."}]',
    1
  );

  -- PLATA 2: Bases de Datos - Índices B-Tree vs Sequential Scan
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Bases de Datos: Índices B-Tree y Planes de Ejecución',
    'Comprende el impacto del costo de lectura vs escritura de los índices y cómo el optimizador elige entre Index Scan y Seq Scan.',
    '# Optimización de Consultas e Índices B-Tree

Un **Índice B-Tree** (Balanced Tree) es una estructura de datos jerárquica en disco que permite localizar filas en tiempo logarítmico $O(\log N)$ en lugar de examinar cada registro secuencialmente $O(N)$.

### 1. Index Scan vs Sequential Scan:
- **Sequential Scan (Seq Scan):** El motor lee físicamente cada bloque de la tabla de principio a fin. Es eficiente solo en tablas pequeñas o cuando la consulta pide más del 20-30% de los datos de la tabla.
- **Index Scan:** El motor navega el árbol B-Tree buscando los punteros a los bloques de disco exactos donde residen las filas que cumplen la condición.

### 2. La contrapartida de los índices:
Los índices aceleran exponencialmente las lecturas (`SELECT`), pero **ralentizan las operaciones de escritura** (`INSERT`, `UPDATE`, `DELETE`), porque cada inserción obliga a rebalancear y escribir en el árbol del índice en disco.',
    'quiz',
    85,
    '[{"id":"q1","question":"Si ejecutas EXPLAIN ANALYZE en una tabla con 5 millones de filas y observas un \"Seq Scan\" en la columna user_id en lugar de un \"Index Scan\", ¿cuál es la causa más probable?","options":["La tabla está dañada","No existe un índice en esa columna o la columna no tiene llave primaria","El motor de base de datos no soporta índices","El cable de red del servidor está saturado"],"correctIndex":1,"explanation":"Sin un índice creado sobre esa columna, el motor está forzado a escanear linealmente todas las 5 millones de filas en disco."},{"id":"q2","question":"¿Cuál es el principal costo o desventaja de crear 15 índices diferentes en una misma tabla de alta concurrencia?","options":["El espacio en disco es infinito","Se ralentizan drásticamente las operaciones de inserción (INSERT) y actualización (UPDATE) porque cada escritura debe actualizar todos los árboles de índices","Las consultas SELECT fallan con error de sintaxis","Se pierde la compatibilidad con UTF-8"],"correctIndex":1,"explanation":"Cada INSERT o UPDATE requiere actualizar tanto la tabla como cada uno de los índices asociados, generando sobrecarga de I/O en disco."},{"id":"q3","question":"¿Por qué el optimizador de PostgreSQL a veces prefiere un Seq Scan sobre un Index Scan en una tabla pequeña de 100 registros?","options":["Porque el optimizador tiene un error de programación","Porque leer 100 filas continuas en disco en un solo bloque es más rápido que consultar el árbol del índice y luego ir a la tabla","Porque los índices no funcionan en números enteros","Porque las tablas pequeñas solo admiten SQLite"],"correctIndex":1,"explanation":"Para pocas filas, el costo de consultar el árbol del índice y luego buscar los bloques en la tabla es mayor que simplemente leer toda la tabla de una sola pasada."}]',
    2
  );

  -- PLATA 3: Troubleshooting de Redes - Diagnóstico en el Modelo OSI
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Redes: Troubleshooting Técnico en el Modelo OSI',
    'Aprende a localizar la causa raíz de incidentes de conectividad identificando la capa OSI exacta del fallo.',
    '# El Modelo OSI en Diagnóstico de Incidentes de Red

El modelo de 7 capas permite abordar problemas de conectividad de abajo hacia arriba (*Bottom-Up Troubleshooting*):

```
7. Aplicación   (HTTP, DNS, SSH, TLS/Certificados)
6. Presentación (Cifrado, serialización JSON/Protobuf)
5. Sesión       (Mantenimiento de sockets y tokens de sesión)
4. Transporte   (TCP, UDP, Puertos, Flags SYN/RST)
3. Red          (IP, Enrutamiento, Default Gateway, ICMP/Ping)
2. Enlace       (Ethernet, Direcciones MAC, ARP, Switches)
1. Física       (Cables UTP, fibra óptica, voltajes, conectores RJ45)
```

### Síntomas y Capas Clave:
- **"Destination Host Unreachable" o Gateway erróneo:** Capa 3 (Red).
- **"Connection Refused" (Paquete TCP RST recibido):** Capa 4 (Transporte: el host está encendido, pero no hay ningún proceso escuchando en ese puerto).
- **"SSL/TLS Certificate Expired" o Error 502 Bad Gateway:** Capa 7 (Aplicación).
- **LED del puerto Ethernet apagado / Cable dañado:** Capa 1 (Física).',
    'quiz',
    85,
    '[{"id":"q1","question":"Un usuario puede hacer ping a una IP pública (8.8.8.8) exitosamente, pero cuando abre su navegador y escribe www.google.com recibe el error \"ERR_NAME_NOT_RESOLVED\". ¿En qué capa del modelo OSI reside el problema y qué servicio está fallando?","options":["Capa 1 (Física) - Cable de red desconectado","Capa 3 (Red) - Máscara de subred errónea","Capa 7 (Aplicación) - Fallo en el servidor DNS","Capa 2 (Enlace) - Colisión de direcciones MAC"],"correctIndex":2,"explanation":"Si el ping a la IP funciona, las capas 1, 2 y 3 están operativas. El fallo es en la resolución de nombres (DNS), protocolo de Capa 7 (Aplicación)."},{"id":"q2","question":"Al intentar conectar a una base de datos PostgreSQL en el puerto 5432 recibes inmediatamente \"Connection Refused: ECONNREFUSED\". ¿Qué significa este mensaje a nivel de red?","options":["El cable de red está cortado","El host de destino recibió el paquete TCP SYN y respondió con un TCP RST porque ningún proceso está escuchando en el puerto 5432","El disco duro del cliente está lleno","El switch de la red se quedó sin memoria"],"correctIndex":1,"explanation":"Connection Refused significa que el host destino está vivo en Capa 3, pero en Capa 4 la pila TCP rechazó la conexión (RST) al no haber servicio en el puerto."},{"id":"q3","question":"¿Qué comando utilizas para visualizar qué puertos TCP y UDP tiene abiertos tu servidor local y qué procesos específicos los están escuchando?","options":["netstat -tuln (o ss -tuln)","ping -f","traceroute -m","route print -all"],"correctIndex":0,"explanation":"netstat (o el moderno ss en Linux) con las banderas -tuln lista todos los puertos TCP y UDP en estado LISTEN en formato numérico."}]',
    3
  );

  -- PLATA 4: Redes - Handshake TCP y Banderas
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Redes: El Handshake de 3 Vías de TCP y Banderas de Control',
    'Domina la negociación de conexiones TCP, números de secuencia y terminación de sesiones.',
    '# El Protocolo TCP y el Three-Way Handshake

TCP (*Transmission Control Protocol*) es un protocolo orientado a conexión que garantiza entrega ordenada y confiable de bytes.

### 1. Establecimiento de Conexión (3-Way Handshake):
1. **Cliente envía `SYN`:** Solicita sincronización e inicia su número de secuencia inicial ($ISN_C$).
2. **Servidor responde `SYN-ACK`:** Confirma el paquete del cliente ($ACK = ISN_C + 1$) y propone su propio número de secuencia ($ISN_S$).
3. **Cliente responde `ACK`:** Confirma la recepción del servidor ($ACK = ISN_S + 1$). La conexión pasa al estado `ESTABLISHED`.

### 2. Banderas (Flags) Críticas:
- **`SYN`** (*Synchronize*): Inicio de conexión.
- **`ACK`** (*Acknowledge*): Confirmación de datos recibidos.
- **`FIN`** (*Finish*): Cierre ordenado y amistoso de la conexión.
- **`RST`** (*Reset*): Interrupción abrupta o rechazo inmediato de conexión.
- **`PSH`** (*Push*): Indica a la pila que entregue los datos a la aplicación sin esperar llenar el buffer.',
    'quiz',
    85,
    '[{"id":"q1","question":"¿Cuál es el orden exacto de los paquetes intercambiados para iniciar una sesión TCP confiable?","options":["ACK -> SYN -> FIN","SYN -> SYN-ACK -> ACK","SYN -> PSH -> ACK","HELLO -> CONNECT -> ESTABLISHED"],"correctIndex":1,"explanation":"El 3-way handshake de TCP sigue el orden canónico: SYN (cliente), SYN-ACK (servidor), ACK (cliente)."},{"id":"q2","question":"¿Qué paquete TCP envía un servidor web cuando un cliente intenta conectarse a un puerto que está cerrado o cuando un firewall descarta activamente la sesión?","options":["TCP RST (Reset)","TCP FIN (Finish)","TCP SYN","TCP PUSH"],"correctIndex":0,"explanation":"La bandera RST (Reset) aborta o rechaza inmediatamente una conexión indicando que el puerto no está activo o la sesión es ilegítima."},{"id":"q3","question":"¿Qué mecanismo de TCP evita saturar al receptor cuando este procesa datos más lento de lo que el emisor los transmite?","options":["Window Size (Control de Flujo por Ventana Deslizante)","DNS Caching","ARP Spoofing","Subnetting"],"correctIndex":0,"explanation":"El parámetro Window Size en la cabecera TCP informa al emisor cuántos bytes libres quedan en el buffer receptor antes de requerir pausa."}]',
    4
  );

  -- PLATA 5: Hardware - Jerarquía de Memoria y Latencias
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Hardware: Jerarquía de Memorias y Cuellos de Botella',
    'Comprende por qué el software de alto rendimiento se optimiza para la memoria caché L1/L2/L3 y cómo impacta el cuello de botella de la RAM.',
    '# La Pirámide de la Jerarquía de Memorias

El procesador moderno puede ejecutar miles de millones de instrucciones por segundo, pero acceder a datos distantes es órdenes de magnitud más lento:

```
[ Registros del CPU ]     ~0.5 nanosegundos (En el mismo núcleo)
[ Caché L1 (32-64 KB) ]   ~1 nanosegundo
[ Caché L2 (512KB - 1MB)] ~3-4 nanosegundos
[ Caché L3 (16-64 MB) ]   ~10-20 nanosegundos (Compartida entre núcleos)
[ Memoria RAM DDR5 ]      ~60-80 nanosegundos (¡100 veces más lento que L1!)
[ Almacenamiento NVMe ]   ~10,000 - 50,000 nanosegundos (Microsegundos)
[ Disco Mecánico HDD ]    ~5,000,000 - 10,000,000 nanosegundos (Milisegundos)
```

### El Impacto del Cache Miss:
Cuando el procesador no encuentra los datos en L1/L2/L3 (**Cache Miss**), debe detener los ciclos de cómputo esperando que la memoria RAM responda a través del bus del controlador de memoria (*Memory Wall*).',
    'quiz',
    85,
    '[{"id":"q1","question":"En términos de latencia de acceso físico, ¿cuál de las siguientes memorias es la más rápida para la CPU?","options":["Memoria RAM DDR5 a 6000 MHz","Memoria Caché L1 integrada en el silicio del núcleo","SSD NVMe PCIe 4.0","Caché L3 compartida"],"correctIndex":1,"explanation":"La memoria Caché L1 reside directamente en el núcleo del procesador con una latencia de ~1 nanosegundo."},{"id":"q2","question":"¿Qué ocurre cuando la CPU experimenta un \"Cache Miss\" al intentar leer una variable?","options":["El procesador se apaga por sobrecalentamiento","La CPU debe solicitar los datos a la memoria RAM principal, perdiendo cientos de ciclos de reloj esperando la respuesta","El sistema operativo lanza una pantalla azul inmediata","La memoria se formatea"],"correctIndex":1,"explanation":"Un Cache Miss obliga al controlador a buscar los datos en la RAM (mucho más lejana y lenta), deteniendo temporalmente el cómputo."},{"id":"q3","question":"¿Por qué el recorrido de una matriz bidimensional es mucho más rápido iterando por filas continuas en memoria en lugar de saltar aleatoriamente por columnas?","options":["Porque el procesador aprovecha la Localidad Espacial cargando líneas enteras de caché (Cache Lines de 64 bytes)","Porque las filas son más livianas que las columnas","Porque la tarjeta de video prefiere números impares","No hay ninguna diferencia de velocidad"],"correctIndex":0,"explanation":"La Localidad Espacial permite precargar 64 bytes contiguos en la línea de caché. El acceso contiguo genera Cache Hits constantes."}]',
    5
  );

  -- PLATA 6: Hardware - Arquitectura CPU vs GPU
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Hardware: Arquitectura de Procesadores: CPU vs GPU',
    'Diferencia entre el procesamiento secuencial de baja latencia (CPU) y el cómputo masivamente paralelo SIMD (GPU).',
    '# CPU vs GPU: Dos Filosofías de Silicio

### 1. La CPU (Central Processing Unit):
- Optimizada para **baja latencia en tareas secuenciales complejas**.
- Pocos núcleos (4 a 32 núcleos potentes), frecuencias de reloj muy altas (4 a 5.5 GHz).
- Compleja circuitería dedicada a predicción de saltos (*Branch Prediction*), ejecución fuera de orden (*Out-of-Order Execution*) y caches masivas.
- Ideal para sistemas operativos, lógica de negocio y aplicaciones interactivas.

### 2. La GPU (Graphics Processing Unit):
- Optimizada para **alto rendimiento de procesamiento masivo en paralelo** (*High Throughput*).
- Miles de núcleos pequeños y sencillos que ejecutan la misma instrucción sobre millones de datos simultáneos (**SIMD / SIMT**: *Single Instruction, Multiple Data*).
- Diseñada para renderizado 3D, multiplicación de matrices de Inteligencia Artificial (Deep Learning) y procesamiento de señales.',
    'quiz',
    85,
    '[{"id":"q1","question":"¿Por qué el entrenamiento de modelos de Deep Learning (Redes Neuronales) se ejecuta en GPUs en lugar de CPUs tradicionales?","options":["Porque las GPUs tienen más memoria de disco rígido","Porque el entrenamiento consiste en millones de multiplicaciones de matrices que pueden ejecutarse en paralelo en miles de núcleos simultáneamente","Porque las CPUs no soportan números decimales","Porque las GPUs son inmunes a los virus informáticos"],"correctIndex":1,"explanation":"Las operaciones con tensores y matrices se benefician del paralelismo masivo de miles de núcleos SIMD de una GPU."},{"id":"q2","question":"¿Qué técnica utiliza una CPU moderna para adivinar qué rama de un condicional (if/else) se ejecutará antes de que termine de evaluarse la condición, evitando detener el pipeline?","options":["Branch Prediction (Predicción de Saltos)","Direct Memory Access","RAID 0","Overclocking"],"correctIndex":0,"explanation":"El Branch Predictor predice el resultado de bifurcaciones condicionales para mantener el pipeline de ejecución lleno y evitar latencias."},{"id":"q3","question":"¿Qué significa el término \"Thermal Throttling\" en hardware computacional?","options":["El aumento de velocidad del ventilador al 100%","La reducción automática de la frecuencia de reloj del procesador o GPU para evitar daños cuando se alcanzan temperaturas críticas","El congelamiento de los transistores por nitrógeno líquido","Una falla en el conector HDMI"],"correctIndex":1,"explanation":"Thermal Throttling es la protección térmica automática que baja la frecuencia de trabajo para impedir que el silicio se queme al superar ~95-100°C."}]',
    6
  );

  -- PLATA 7: Electrónica Básica - Ley de Ohm y Señales Digitales
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Electrónica: Ley de Ohm y Señales en Sistemas Digitales',
    'Domina la relación entre Voltaje, Corriente y Resistencia en circuitos informáticos y lógica TTL.',
    '# Fundamentos de Electrónica para la Computación

Toda la informática digital es, en última instancia, **física de electrones controlada por semiconductores (transistores MOSFET)**.

### 1. Las Tres Magnitudes de la Ley de Ohm:
- **Voltaje ($V$ o $U$, en Voltios):** La diferencia de potencial o "fuerza" que empuja a los electrones.
- **Corriente ($I$, en Amperios):** El caudal o cantidad de carga eléctrica que fluye por segundo.
- **Resistencia ($R$, en Ohmios $\Omega$):** La oposición que presenta un material al paso de la corriente.

```
V = I · R   <===>   I = V / R   <===>   P = V · I  (Potencia en Watts)
```

---

### 2. Señales Analógicas vs Digitales:
- **Analógica:** Toma infinitos valores continuos en el tiempo (voltaje continuo de 0V a 5V).
- **Digital:** Se discretiza en niveles lógicos binarios:
  - Lógica TTL clásica de 5V: `0V - 0.8V` = `0 lógico` (LOW), `2.0V - 5V` = `1 lógico` (HIGH).
  - Lógica moderna de procesadores: Opera a voltajes ultra bajos (`1.1V - 1.3V`) para reducir drásticamente el calor y consumo de potencia ($P = V^2 / R$).',
    'quiz',
    85,
    '[{"id":"q1","question":"Si un sensor conectado a una placa Raspberry Pi opera a 3.3 Voltios y su circuito consume una corriente de 0.05 Amperios (50 mA), ¿cuál es la resistencia interna equivalente según la Ley de Ohm (R = V / I)?","options":["66 Ohmios","16.5 Ohmios","0.165 Ohmios","660 Ohmios"],"correctIndex":0,"explanation":"R = 3.3V / 0.05A = 66 Ohmios."},{"id":"q2","question":"¿Por qué los procesadores modernos de última generación (Intel Core, AMD Ryzen, Apple Silicon) han reducido su voltaje de trabajo de 5V a cerca de 1.1V?","options":["Porque el voltaje bajo hace que los cables pesen menos","Porque la potencia disipada en calor crece con el cuadrado del voltaje (P ∝ V²), por lo que bajar el voltaje permite triplicar la densidad de transistores sin fundir el chip","Porque a 5V no se pueden escribir números impares","Porque las fuentes de alimentación no tienen transformadores"],"correctIndex":1,"explanation":"La potencia dinámica disipada es proporcional a C · V² · f. Bajar el voltaje reduce cuadráticamente el calor generado por miles de millones de transistores."},{"id":"q3","question":"¿Cuál es la función principal de un condensador de desacoplo (decoupling capacitor) colocado junto al pin de alimentación de un microcontrolador?","options":["Aumentar la velocidad del reloj a infinito","Filtrar el ruido eléctrico y suministrar picos rápidos de corriente para evitar caídas momentáneas de voltaje","Transformar corriente continua en alterna","Almacenar el sistema operativo en memoria flash"],"correctIndex":1,"explanation":"Los condensadores de desacoplo actúan como mini reservorios de energía que estabilizan la línea de alimentación absorbiendo picos de ruido de alta frecuencia."}]',
    7
  );

  -- PLATA 8: Electrónica - Resistencias Pull-Up/Down y Compuertas
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_silver_module_id,
    'Electrónica: Estados Flotantes, Pull-Up y Compuertas Universales',
    'Comprende cómo los pines digitales evitan lecturas erráticas con resistencias pull-up/down y cómo se construyen compuertas lógicas con transistores.',
    '# Estados Flotantes y Lógica a Nivel Transistor

### 1. El Peligro del Pin Flotante (*High-Z / Floating*):
Un pin de entrada digital de un procesador conectado a un botón abierto no lee un cero estricto: actúa como una antena que capta ruido electromagnético ambiental, alternando aleatoriamente entre `0` y `1`.

Para garantizar un estado definido:
- **Resistencia Pull-Up:** Conecta el pin a $V_{CC}$ a través de una resistencia (ej: $10\text{ k}\Omega$). El estado en reposo es `1` (HIGH).
- **Resistencia Pull-Down:** Conecta el pin a Tierra ($GND$). El estado en reposo es `0` (LOW).

---

### 2. Compuertas Universales (NAND y NOR):
Una compuerta **NAND** (Not-AND) es universal: combinando compuertas NAND se puede construir cualquier circuito digital, memoria SRAM (flip-flops) y procesador completo.',
    'quiz',
    85,
    '[{"id":"q1","question":"¿Qué ocurre si dejas un pin de entrada digital de un Arduino o microcontrolador al aire (sin resistencia de pull-up ni pull-down)?","options":["El pin queda en estado flotante (High-Z) y lee valores aleatorios (0 o 1) debido al ruido electromagnético del ambiente","El microcontrolador se quema de inmediato","El pin siempre leerá un 0 perfecto","El pin se convierte en una salida de audio"],"correctIndex":0,"explanation":"Un pin sin referencia queda flotando y su alta impedancia absorbe ruido estático, provocando lecturas erráticas e inestables."},{"id":"q2","question":"¿Por qué la compuerta lógica NAND es considerada una \"Compuerta Lógica Universal\" en la fabricación de microprocesadores?","options":["Porque consume cero energía eléctrica","Porque combinando exclusivamente compuertas NAND es posible recrear cualquier otra compuerta lógica (AND, OR, NOT, XOR) y construir procesadores enteros","Porque es la única compuerta que funciona bajo el agua","Porque solo se fabrica en Japón"],"correctIndex":1,"explanation":"La propiedad de universalidad de NAND (y NOR) permite que toda la lógica de un procesador se fabrique con un único tipo de patrón de transistores."},{"id":"q3","question":"Si una compuerta NAND recibe en sus entradas A=1 y B=1, ¿cuál es su salida?","options":["1","0","Indeterminado","Alta impedancia"],"correctIndex":1,"explanation":"AND produce 1 solo si ambos son 1. Al invertir con NOT (NAND), 1 AND 1 = 1, invertido = 0."}]',
    8
  );

  -- ============================================================================
  -- 💻 CÓDIGO Y ALGORITMOS EXIGENTES (PLATA)
  -- ============================================================================

  -- PLATA 9: Algoritmo Two-Sum en O(N)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_silver_module_id,
    'Algoritmos: Two-Sum en Tiempo Lineal O(N)',
    'Optimiza la búsqueda de dos números que sumen un objetivo pasando de un bucle anidado O(N²) a tiempo O(N) con Map.',
    '# El Problema Two-Sum y la Complejidad Big-O

Dado un arreglo de números enteros y un valor `objetivo`, debes encontrar los **índices** de los dos números que sumados den exactamente el `objetivo`.

### El Enfoque Ingenuo ($O(N^2)$):
Dos bucles anidados comparando cada par. Si el array tiene 100,000 elementos, $100,000^2 = 10,000,000,000$ operaciones (tardaría segundos o minutos).

### La Solución Óptima ($O(N)$):
Usar un diccionario o mapa de hash para recordar en tiempo constante $O(1)$ qué número necesitamos para alcanzar el objetivo:
`complemento = objetivo - numero_actual`

### Tu Misión:
Implementa `twoSum(nums, objetivo)` que retorne un array con los dos índices `[i, j]` que sumen el objetivo. Asume que siempre existe una solución única.',
    'javascript',
    'function twoSum(nums, objetivo) {
  // Resuelve en O(N) usando un Map o un Objeto hash
}',
    'function twoSum(nums, objetivo) {
  const mapa = new Map();
  for (let i = 0; i < nums.length; i++) {
    const complemento = objetivo - nums[i];
    if (mapa.has(complemento)) {
      return [mapa.get(complemento), i];
    }
    mapa.set(nums[i], i);
  }
  return [];
}',
    'test("Two-Sum Caso Base", () => {
  const res = twoSum([2, 7, 11, 15], 9);
  expect(res).toEqual([0, 1]);
});
test("Two-Sum Números en posiciones no iniciales", () => {
  const res = twoSum([3, 2, 4], 6);
  expect(res).toEqual([1, 2]);
});
test("Two-Sum con números duplicados", () => {
  const res = twoSum([3, 3], 6);
  expect(res).toEqual([0, 1]);
});',
    100,
    9
  );

  -- PLATA 10: Algoritmo Búsqueda Binaria O(log N)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_silver_module_id,
    'Algoritmos: Búsqueda Binaria O(log N)',
    'Implementa la búsqueda binaria dividiendo el espacio de búsqueda a la mitad en cada iteración.',
    '# Búsqueda Binaria (Binary Search)

En un arreglo ordenado de menor a mayor, no es necesario mirar uno por uno los elementos ($O(N)$).

La **Búsqueda Binaria** descarta la mitad de los elementos en cada paso comparando con el punto medio:
- Si el elemento del medio es el buscado: terminamos.
- Si el buscado es menor: buscamos en la mitad izquierda.
- Si el buscado es mayor: buscamos en la mitad derecha.

Complejidad temporal: **$O(\log N)$**. Para 1,000,000 de elementos, ¡requiere como máximo solo 20 comparaciones!

### Tu Misión:
Implementa `busquedaBinaria(arr, objetivo)`: retorna el **índice** del elemento si existe, o `-1` si no está en el arreglo.',
    'javascript',
    'function busquedaBinaria(arr, objetivo) {
  // Implementa el algoritmo con punteros izquierda y derecha
}',
    'function busquedaBinaria(arr, objetivo) {
  let izq = 0;
  let der = arr.length - 1;

  while (izq <= der) {
    const medio = Math.floor((izq + der) / 2);
    if (arr[medio] === objetivo) {
      return medio;
    } else if (arr[medio] < objetivo) {
      izq = medio + 1;
    } else {
      der = medio - 1;
    }
  }
  return -1;
}',
    'test("Encontrar elemento en medio", () => {
  expect(busquedaBinaria([1, 3, 5, 7, 9, 11], 7)).toBe(3);
});
test("Encontrar extremos", () => {
  expect(busquedaBinaria([2, 4, 6, 8, 10], 2)).toBe(0);
  expect(busquedaBinaria([2, 4, 6, 8, 10], 10)).toBe(4);
});
test("Elemento inexistente retorna -1", () => {
  expect(busquedaBinaria([10, 20, 30], 25)).toBe(-1);
});',
    100,
    10
  );

  -- PLATA 11: Matrices 2D - Transposición de Matriz
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_silver_module_id,
    'Algoritmos: Transposición de Matrices 2D',
    'Aprende a transformar filas en columnas en arreglos bidimensionales con bucles anidados.',
    '# Matrices Bidimensionales y Transposición

Una matriz de $M \times N$ es un arreglo de arreglos. La **Transposición** ($A^T$) intercambia filas por columnas: el elemento en la posición `[i][j]` pasa a la posición `[j][i]`.

```
Matriz Original (2x3):        Matriz Transpuesta (3x2):
[ [1, 2, 3],                  [ [1, 4],
  [4, 5, 6] ]                   [2, 5],
                                [3, 6] ]
```

### Tu Misión:
Implementa `transponerMatriz(matriz)` que retorne una nueva matriz con las filas y columnas invertidas.',
    'javascript',
    'function transponerMatriz(matriz) {
  // Transpone la matriz 2D
}',
    'function transponerMatriz(matriz) {
  if (!matriz || matriz.length === 0) return [];
  const filas = matriz.length;
  const columnas = matriz[0].length;
  const resultado = [];

  for (let j = 0; j < columnas; j++) {
    const nuevaFila = [];
    for (let i = 0; i < filas; i++) {
      nuevaFila.push(matriz[i][j]);
    }
    resultado.push(nuevaFila);
  }
  return resultado;
}',
    'test("Transposición matriz 2x3 a 3x2", () => {
  const original = [
    [1, 2, 3],
    [4, 5, 6]
  ];
  const esperada = [
    [1, 4],
    [2, 5],
    [3, 6]
  ];
  expect(transponerMatriz(original)).toEqual(esperada);
});
test("Matriz cuadrada 2x2", () => {
  const mat = [[1, 2], [3, 4]];
  expect(transponerMatriz(mat)).toEqual([[1, 3], [2, 4]]);
});',
    100,
    11
  );

  -- PLATA 12: Algoritmos - Elemento Mayoritario (Frecuencias)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_silver_module_id,
    'Algoritmos: Elemento Mayoritario en Arreglos',
    'Identifica el elemento que aparece más de N/2 veces en una colección en tiempo eficiente.',
    '# Detección del Elemento Mayoritario

Dado un arreglo `nums` de tamaño $N$, el elemento mayoritario es aquel que aparece **estrictamente más de $\lfloor N / 2 \rfloor$ veces**.

*Ejemplo:* En `[3, 2, 3]`, $N=3$. La mitad es 1.5. El número `3` aparece 2 veces, por lo que es el mayoritario.

### Tu Misión:
Implementa `elementoMayor(nums)` utilizando un mapa de frecuencias para devolver dicho elemento.',
    'javascript',
    'function elementoMayor(nums) {
  // Cuenta frecuencias y retorna el elemento con más de N/2 apariciones
}',
    'function elementoMayor(nums) {
  const frecuencias = {};
  const umbral = nums.length / 2;

  for (let n of nums) {
    frecuencias[n] = (frecuencias[n] || 0) + 1;
    if (frecuencias[n] > umbral) {
      return n;
    }
  }
  return null;
}',
    'test("Mayoría simple", () => {
  expect(elementoMayor([3, 2, 3])).toBe(3);
});
test("Mayoría en lista larga", () => {
  expect(elementoMayor([2, 2, 1, 1, 1, 2, 2])).toBe(2);
});',
    100,
    12
  );

END $ARENA_SEED$;
