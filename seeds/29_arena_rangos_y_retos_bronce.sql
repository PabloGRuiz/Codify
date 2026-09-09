-- ==============================================================================
-- ⚔️ SGFC SEED: 29 - SISTEMA DE ARENA: RANGOS Y 15 RETOS EXCLUSIVOS DE BRONCE
-- ==============================================================================
-- 1. Añade columnas de rango (arena_rank, arena_streak) a profiles si no existen.
-- 2. Crea el Módulo Exclusivo 'Arena de Retos: Rango Bronce' (no ligado a cursos).
-- 3. Inserta 15 retos exclusivos para Bronce:
--    - 3 Retos de Redes Básico (Quiz)
--    - 3 Retos de Lógica Proposicional (Quiz)
--    - 3 Retos de Fundamentos IT (Quiz)
--    - 6 Retos de Lógica de Programación (Código JavaScript con tests unitarios)
-- ==============================================================================

-- 1. Actualizar esquema de profiles
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS arena_rank TEXT DEFAULT 'unranked',
ADD COLUMN IF NOT EXISTS arena_streak INTEGER DEFAULT 0;

DO $$
DECLARE
  v_arena_module_id UUID;
BEGIN

  -- 2. Limpiar versión previa del módulo de Bronce de la Arena para evitar duplicados
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Bronce'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.modules WHERE title = 'Arena de Retos: Rango Bronce'
  );
  DELETE FROM public.modules WHERE title = 'Arena de Retos: Rango Bronce';

  -- 3. Crear el Módulo Exclusivo de Bronce de la Arena
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Arena de Retos: Rango Bronce',
    'Retos exclusivos diarios para el Rango Bronce: redes elementales, lógica booleana, fundamentos IT y algoritmos esenciales.',
    1
  )
  RETURNING id INTO v_arena_module_id;

  -- ============================================================================
  -- CATEGORÍA 1: REDES BÁSICO (CUESTIONARIOS / QUIZ)
  -- ============================================================================

  -- RETO 1: Puertos y Protocolos Esenciales
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Redes: Puertos y Protocolos Esenciales',
    'Identifica los números de puerto estándar de los servicios de red más comunes en Internet.',
    '# Puertos y Protocolos en Redes
En las redes TCP/IP, los **puertos** (capa de transporte) permiten a un sistema operativo saber a qué aplicación o servicio específico debe entregar un paquete de datos entrante.

### Puertos estándar comunes (Well-Known Ports):
- **Puerto 80**: HTTP (tráfico web sin cifrar).
- **Puerto 443**: HTTPS (tráfico web seguro cifrado mediante TLS/SSL).
- **Puerto 22**: SSH (*Secure Shell*, administración remota segura de servidores).
- **Puerto 53**: DNS (*Domain Name System*, traducción de nombres de dominio a direcciones IP).
- **Puerto 21**: FTP (*File Transfer Protocol*).',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Qué puerto estándar utiliza el protocolo HTTPS para comunicaciones web seguras?","options":["Puerto 80","Puerto 443","Puerto 22","Puerto 8080"],"correctIndex":1,"explanation":"El puerto 443 es el estándar universal para HTTPS (HTTP sobre TLS)."},{"id":"q2","question":"Si deseas conectarte de forma remota y segura a la terminal de un servidor Linux, ¿qué puerto y protocolo utilizas?","options":["Puerto 21 - FTP","Puerto 53 - DNS","Puerto 22 - SSH","Puerto 25 - SMTP"],"correctIndex":2,"explanation":"SSH (Secure Shell) utiliza por defecto el puerto 22 para túneles y consolas remotas seguras."},{"id":"q3","question":"¿Cuál es el servicio responsable de resolver nombres como www.google.com en una IP y qué puerto ocupa?","options":["DNS en el puerto 53","DHCP en el puerto 67","HTTP en el puerto 80","SNMP en el puerto 161"],"correctIndex":0,"explanation":"DNS (Domain Name System) utiliza el puerto 53 (habitualmente sobre UDP y TCP) para resolución de nombres."}]',
    1
  );

  -- RETO 2: Direcciones IP Privadas vs Públicas
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Redes: Direcciones IP Privadas vs Públicas',
    'Diferencia entre el direccionamiento local de tu red LAN y el direccionamiento enrutado en la WAN.',
    '# Direcciones IP: Públicas vs Privadas
El estándar **RFC 1918** reserva rangos específicos de direcciones IPv4 para uso exclusivo en redes privadas locales (LAN). Estas direcciones **nunca son enrutadas directamente en la Internet pública**.

### Rangos Privados RFC 1918:
- **Clase A**: `10.0.0.0` a `10.255.255.255` (usado comúnmente en grandes corporaciones).
- **Clase B**: `172.16.0.0` a `172.31.255.255`.
- **Clase C**: `192.168.0.0` a `192.168.255.255` (el más habitual en routers domésticos y pequeñas empresas).

### Mecanismo NAT:
Para que los dispositivos con IP privada puedan navegar por Internet, el router aplica **NAT (Network Address Translation)**, traduciendo las IPs privadas en la única IP pública asignada por el proveedor (ISP).',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Cuál de las siguientes direcciones es una dirección IP privada típica de una red doméstica?","options":["8.8.8.8","192.168.1.50","1.1.1.1","142.250.190.46"],"correctIndex":1,"explanation":"El bloque 192.168.0.0/16 está reservado para redes privadas según el estándar RFC 1918."},{"id":"q2","question":"¿Qué tecnología permite a múltiples computadoras con IPs privadas compartir una sola IP pública para navegar en Internet?","options":["NAT (Network Address Translation)","VLAN (Virtual LAN)","DHCP Relay","VPN (Virtual Private Network)"],"correctIndex":0,"explanation":"NAT traduce las direcciones de origen privadas a la IP pública del router para que el tráfico circule por Internet."},{"id":"q3","question":"¿Qué ocurre si un paquete con dirección de destino 10.0.0.5 intenta salir a los enrutadores centrales de Internet?","options":["Llega al servidor de Google","Es descartado por los routers públicos porque no es enrutable en WAN","Se convierte automáticamente en una IP pública","Genera un bucle infinito"],"correctIndex":1,"explanation":"Los routers de Internet descartan de inmediato los paquetes dirigidos a rangos de IP privadas (RFC 1918)."}]',
    2
  );

  -- RETO 3: Máscaras de Subred y Gateway
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Redes: Máscaras de Subred y Gateway',
    'Aprende cómo un host sabe si otro equipo está dentro de su red local o si debe recurrir a la puerta de enlace.',
    '# Máscara de Subred y Puerta de Enlace (Default Gateway)

### 1. La Máscara de Subred:
Indica qué porción de una dirección IP identifica a la **red** y qué porción identifica al **host individual**.
- Una máscara típica `255.255.255.0` (notación CIDR `/24`) significa que los primeros 24 bits pertenecen a la red y los últimos 8 bits a los hosts locales (hasta 254 computadoras).

### 2. Default Gateway (Puerta de Enlace):
Es la dirección IP del router local. Cuando una computadora necesita comunicarse con una IP que **no pertenece a su misma subred**, envía los paquetes al Default Gateway para que este se encargue de encaminarlos.',
    'quiz',
    60,
    '[{"id":"q1","question":"Si tu IP es 192.168.1.15 y tu máscara es 255.255.255.0 (/24), ¿cuál de los siguientes equipos está en tu misma red local?","options":["192.168.2.15","192.168.1.200","10.0.0.1","172.16.1.15"],"correctIndex":1,"explanation":"Ambos comparten los primeros 3 octetos (192.168.1), por lo que pertenecen a la misma subred local."},{"id":"q2","question":"¿Qué función cumple la dirección configurada como Default Gateway en tu adaptador de red?","options":["Asignar nombres de dominio","Servir de salida hacia redes externas e Internet cuando el destino no es local","Filtrar únicamente correos spam","Acelerar la memoria RAM de la tarjeta de red"],"correctIndex":1,"explanation":"El Default Gateway es el router local que canaliza y enruta paquetes hacia otras redes o Internet."},{"id":"q3","question":"¿Cuántos hosts utilizables ofrece una subred con máscara estándar /24 (255.255.255.0)?","options":["256","254 (restando dirección de red y broadcast)","128","512"],"correctIndex":1,"explanation":"Con 8 bits para hosts existen 256 combinaciones, pero se reservan la primera (.0 de red) y la última (.255 de broadcast), quedando 254 útiles."}]',
    3
  );

  -- ============================================================================
  -- CATEGORÍA 2: LÓGICA PROPOSICIONAL (CUESTIONARIOS / QUIZ)
  -- ============================================================================

  -- RETO 4: Operador XOR y Tablas de Verdad
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica Proposicional: Operador XOR',
    'Domina la disyunción exclusiva (XOR) y su comportamiento frente a valores lógicos booleanos.',
    '# Disyunción Exclusiva: El Operador XOR
A diferencia del `OR` inclusivo (que es verdadero si al menos uno o ambos operandos son verdaderos), el **XOR (Exclusive OR)** es verdadero **única y exclusivamente si uno de los operandos es verdadero y el otro es falso**.

### Tabla de Verdad de XOR (⊕):
| A | B | A XOR B |
|---|---|---------|
| 0 | 0 | **0 (Falso)** |
| 0 | 1 | **1 (Verdadero)** |
| 1 | 0 | **1 (Verdadero)** |
| 1 | 1 | **0 (Falso)** |

En criptografía y paridad de redes, XOR es fundamental porque aplicar XOR dos veces con la misma clave devuelve el valor original (`(A ⊕ B) ⊕ B = A`).',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Cuál es el resultado de evaluar (True XOR True)?","options":["True","False","Null","Undefined"],"correctIndex":1,"explanation":"XOR es falso si ambas entradas son idénticas. Solo es True cuando exactamente uno de los valores es True."},{"id":"q2","question":"¿En cuál de las siguientes situaciones XOR evalúa a True?","options":["A = False, B = False","A = True, B = True","A = True, B = False","Ninguna de las anteriores"],"correctIndex":2,"explanation":"Cuando las entradas difieren (una verdadera y una falsa), el resultado de XOR es True."},{"id":"q3","question":"Si tenemos la expresión booleana: (False XOR True) AND (True XOR False), ¿cuál es el resultado final?","options":["False","True","Indeterminado","Error de sintaxis"],"correctIndex":1,"explanation":"(False XOR True) = True; (True XOR False) = True; True AND True = True."}]',
    4
  );

  -- RETO 5: Leyes de De Morgan
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica Proposicional: Leyes de De Morgan',
    'Aprende a simplificar y transformar expresiones lógicas negadas complejas en condiciones equivalentes.',
    '# Leyes de De Morgan en Informática
Las Leyes de De Morgan son reglas de transformación de lógica proposicional que permiten simplificar condiciones complejas en código (como sentencias `if`).

### Las dos leyes fundamentales:
1. **La negación de una conjunción es la disyunción de las negaciones:**
   `!(A && B) === (!A || !B)`
2. **La negación de una disyunción es la conjunción de las negaciones:**
   `!(A || B) === (!A && !B)`

### Ejemplo en código:
Negar "El usuario es mayor de edad Y tiene saldo":
`!(edad >= 18 && saldo > 0)` equivale a: `(edad < 18 || saldo <= 0)`.',
    'quiz',
    60,
    '[{"id":"q1","question":"Según las leyes de De Morgan, ¿a qué equivale la expresión !(A && B)?","options":["!A && !B","!A || !B","A || B","!(A) && B"],"correctIndex":1,"explanation":"La negación de un AND convierte la operación en un OR de las variables negadas: !A || !B."},{"id":"q2","question":"¿Cuál es la expresión simplificada equivalente a !(esActivo || tienePermiso)?","options":["!esActivo && !tienePermiso","!esActivo || !tienePermiso","esActivo && tienePermiso","!esActivo == tienePermiso"],"correctIndex":0,"explanation":"Negar una disyunción resulta en la conjunción de ambas negaciones: !esActivo && !tienePermiso."},{"id":"q3","question":"Si una condición dice !(x > 5 && y == 10), ¿cuándo evaluará a True?","options":["Solo cuando x > 5 y además y == 10","Cuando x <= 5 O bien y != 10","Nunca, siempre es False","Solo cuando x y son números negativos"],"correctIndex":1,"explanation":"Por De Morgan: !(x > 5 && y == 10) es equivalente a (x <= 5 || y != 10)."}]',
    5
  );

  -- RETO 6: Implicación Lógica y Tablas de Verdad
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica Proposicional: Condicional e Implicación',
    'Comprende cómo funciona el condicional material Si P entonces Q (P → Q) en la lógica de sistemas.',
    '# Implicación Lógica: Si P entonces Q (P → Q)
En lógica proposicional, la condicional **P → Q** representa: "Si ocurre la premisa P, entonces se deduce la conclusión Q".

### Regla de oro de la implicación:
Una implicación **solo es falsa en un único caso**: cuando la premisa P es Verdadera, pero la conclusión Q resulta Falsa. Si la premisa de partida es Falsa, la implicación se considera formalmente verdadera por vaciedad (*verdad vacua*).

### Equivalencia booleana:
`(P → Q)` es exactamente equivalente a: **`(!P || Q)`**.',
    'quiz',
    60,
    '[{"id":"q1","question":"¿En qué único caso la proposición condicional (P → Q) es FALSA?","options":["Cuando P es Falsa y Q es Falsa","Cuando P es Verdadera y Q es Falsa","Cuando P es Falsa y Q es Verdadera","Cuando P y Q son Verdaderas"],"correctIndex":1,"explanation":"Una promesa solo se rompe si se cumple la condición inicial P pero no se cumple el resultado esperado Q."},{"id":"q2","question":"¿Cuál de las siguientes expresiones en código equivale lógicamente a (P → Q)?","options":["P && Q","!P || Q","!P && !Q","P == Q"],"correctIndex":1,"explanation":"La equivalencia clásica del condicional es !P || Q."},{"id":"q3","question":"Si P es False y Q es False, ¿cuál es el valor de verdad de (P → Q)?","options":["False","True","Indeterminado","Error lógico"],"correctIndex":1,"explanation":"Cuando el antecedente P es False, la implicación siempre es True."}]',
    6
  );

  -- ============================================================================
  -- CATEGORÍA 3: FUNDAMENTOS IT BÁSICOS (CUESTIONARIOS / QUIZ)
  -- ============================================================================

  -- RETO 7: Unidades de Almacenamiento y Bits
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Fundamentos IT: Unidades de Almacenamiento',
    'Distingue con precisión entre bits, bytes, kilobytes, gigabytes y tasas de transferencia.',
    '# Unidades de Información en Computación

### 1. Bits vs Bytes:
- **1 Bit (b)**: La unidad mínima de información (0 o 1).
- **1 Byte (B)** con B mayúscula: Conjunto de **8 bits**. Puede representar un caracter en código ASCII.

### 2. Escala de Almacenamiento:
- **1 Kilobyte (KB)** = 1,024 Bytes.
- **1 Megabyte (MB)** = 1,024 KB.
- **1 Gigabyte (GB)** = 1,024 MB.
- **1 Terabyte (TB)** = 1,024 GB.

### 3. Velocidad de Internet vs Descarga:
Las velocidades de los proveedores de Internet se expresan en **Megabits por segundo (Mbps)**. Para saber la velocidad teórica de descarga en Megabytes por segundo (MB/s), se divide por 8:
`100 Mbps / 8 = 12.5 MB/s`.',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Cuántos bits componen exactamente 1 Byte?","options":["4 bits (Nibble)","8 bits","16 bits","1024 bits"],"correctIndex":1,"explanation":"1 Byte está formado universalmente por 8 bits."},{"id":"q2","question":"Si tu conexión de red descarga a 80 Mbps (Megabits por segundo), ¿cuál es la tasa teórica en Megabytes por segundo?","options":["80 MB/s","10 MB/s","40 MB/s","8 MB/s"],"correctIndex":1,"explanation":"80 Mbps divididos entre 8 bits por byte da 10 MB/s."},{"id":"q3","question":"¿Cuántos Megabytes (MB) equivalen a 2 Gigabytes (GB) en el sistema binario computacional?","options":["2000 MB","2048 MB","1024 MB","4096 MB"],"correctIndex":1,"explanation":"2 GB equivalen a 2 * 1024 = 2048 MB."}]',
    7
  );

  -- RETO 8: Memoria RAM vs Almacenamiento No Volátil
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Fundamentos IT: Memoria RAM vs Almacenamiento',
    'Comprende el rol de la memoria de trabajo temporal frente a los medios de almacenamiento masivo.',
    '# Jerarquía de Almacenamiento: RAM vs Discos (SSD/HDD)

### 1. Memoria RAM (Random Access Memory):
- **Características**: Ultrarrápida, de acceso aleatorio directo por la CPU.
- **Volatilidad**: Es **volátil**. Si el equipo se apaga o reinicia, todos los datos almacenados en la RAM se borran de inmediato.
- **Función**: Alojar el sistema operativo y las aplicaciones que están actualmente en ejecución.

### 2. Almacenamiento Persistente (SSD, NVMe, HDD):
- **Características**: No volátil. Conserva los datos permanentemente aunque no reciba energía eléctrica.
- **Velocidad**: Aunque los SSDs NVMe son muy rápidos, siguen siendo órdenes de magnitud más lentos que la memoria RAM.',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Qué significa que la memoria RAM sea una memoria ''volátil''?","options":["Que se degrada físicamente con rapidez","Que pierde todo su contenido cuando se interrumpe la energía eléctrica","Que almacena virus con facilidad","Que cambia de velocidad según la temperatura"],"correctIndex":1,"explanation":"La volatilidad significa que requiere energía continua para mantener la información cargada en sus celdas."},{"id":"q2","question":"¿Cuál es el componente encargado de guardar tus archivos, documentos y fotos de forma permanente?","options":["Memoria RAM","Almacenamiento secundario (SSD / Disco Duro)","Memoria Caché L1","Registro de instrucción de la CPU"],"correctIndex":1,"explanation":"Los discos SSD y HDD son dispositivos de almacenamiento no volátil diseñados para guardar información a largo plazo."},{"id":"q3","question":"¿Por qué el procesador no lee los programas directamente desde el disco SSD en lugar de cargarlos en la RAM?","options":["Porque el SSD no tiene capacidad suficiente","Porque la RAM es miles de veces más rápida y ofrece latencias de acceso ínfimas que la CPU necesita","Porque los discos SSD no son compatibles con sistemas operativos modernos","Porque la RAM contiene el firmware de la BIOS"],"correctIndex":1,"explanation":"La RAM provee anchos de banda enormes y latencias de nanosegundos, indispensables para alimentar el ciclo de reloj de la CPU."}]',
    8
  );

  -- RETO 9: Comandos Básicos de Consola / Terminal
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, xp_reward, test_code, order_index
  ) VALUES (
    v_arena_module_id,
    'Fundamentos IT: Comandos Esenciales de Terminal',
    'Conoce los comandos universales de CLI que todo profesional de informática utiliza a diario.',
    '# Comandos Esenciales de la Línea de Comandos (CLI)
La interfaz de línea de comandos es la herramienta indispensable para administración de servidores, diagnóstico de redes y desarrollo de software.

### Comandos Clave:
- **`pwd`** (*Print Working Directory*): Muestra la ruta de la carpeta actual donde estás posicionado.
- **`ls`** (Linux/Mac) / **`dir`** (Windows): Lista los archivos y subdirectorios de la carpeta.
- **`cd <carpeta>`** (*Change Directory*): Cambia al directorio indicado (`cd ..` sube un nivel hacia la carpeta padre).
- **`mkdir <nombre>`** (*Make Directory*): Crea una nueva carpeta.
- **`ping <host/ip>`**: Envía paquetes ICMP para comprobar si un equipo de red está accesible y medir el tiempo de respuesta (latencia).',
    'quiz',
    60,
    '[{"id":"q1","question":"¿Qué comando utilizas en Linux/macOS para saber en qué carpeta exacta te encuentras situado actualmente?","options":["whereami","pwd","cd","locate"],"correctIndex":1,"explanation":"pwd (print working directory) imprime en pantalla la ruta absoluta del directorio actual de trabajo."},{"id":"q2","question":"¿Cuál es el comando utilizado para diagnosticar si un servidor remoto está encendido y responde por red mediante paquetes ICMP?","options":["ping","traceroute","netstat","curl"],"correctIndex":0,"explanation":"El comando ping envía paquetes de eco ICMP para verificar conectividad y latencia entre dos puntos de red."},{"id":"q3","question":"Para retroceder al directorio padre inmediatamente superior en la terminal, ¿qué comando se escribe?","options":["cd ..","cd back","backdir","exit"],"correctIndex":0,"explanation":"cd .. es el estándar en todos los sistemas operativos (Windows, Linux, macOS) para subir un nivel en el árbol de directorios."}]',
    9
  );

  -- ============================================================================
  -- CATEGORÍA 4: LÓGICA DE PROGRAMACIÓN (CÓDIGO JAVASCRIPT CON TESTS)
  -- ============================================================================

  -- RETO 10: Clasificador de Par o Impar
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: ¿Es Par o Impar?',
    'Escribe una función que determine si un número entero dado es par utilizando el operador de residuo.',
    '# El Operador Módulo o Residuo (%)
El operador `%` calcula el resto que queda al dividir un número entero por otro.

### Regla matemática:
Un número es **par** si al dividirlo por 2 su residuo es exactamente `0`.
Si el residuo es `1` o `-1`, el número es **impar**.

### Tu Misión:
Implementa la función `esPar(n)` para que retorne `true` si `n` es par, y `false` si es impar.',
    'javascript',
    'function esPar(n) {
  // Tu código aquí
}',
    'function esPar(n) {
  return n % 2 === 0;
}',
    'test("Números pares positivos", () => {
  expect(esPar(4)).toBe(true);
  expect(esPar(100)).toBe(true);
});
test("Números impares positivos", () => {
  expect(esPar(7)).toBe(false);
  expect(esPar(1)).toBe(false);
});
test("Cero es par", () => {
  expect(esPar(0)).toBe(true);
});',
    75,
    10
  );

  -- RETO 11: Sumatoria de Números en un Rango
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: Sumatoria en un Rango',
    'Crea un algoritmo que sume todos los números enteros comprendidos entre inicio y fin inclusive.',
    '# Acumuladores y Bucles
Un patrón clásico en programación consiste en inicializar una variable acumuladora en `0` y recorrer con un ciclo `for` un rango de números sumando cada valor iterado.

### Tu Misión:
Implementa la función `sumarRango(inicio, fin)` que sume todos los números enteros desde `inicio` hasta `fin` (ambos inclusive).

*Ejemplo:* `sumarRango(1, 4)` debe devolver `10` (1 + 2 + 3 + 4).',
    'javascript',
    'function sumarRango(inicio, fin) {
  // Tu código aquí
}',
    'function sumarRango(inicio, fin) {
  let total = 0;
  for (let i = inicio; i <= fin; i++) {
    total += i;
  }
  return total;
}',
    'test("Suma rango 1 a 4", () => {
  expect(sumarRango(1, 4)).toBe(10);
});
test("Suma rango 3 a 5", () => {
  expect(sumarRango(3, 5)).toBe(12);
});
test("Rango de un solo número", () => {
  expect(sumarRango(5, 5)).toBe(5);
});',
    75,
    11
  );

  -- RETO 12: Filtrar Números Positivos
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: Filtrar Positivos',
    'Recibe un arreglo de números y devuelve un nuevo arreglo que contenga únicamente los valores estrictamente mayores a cero.',
    '# Filtrado de Arreglos
En programación, procesar listas descartando elementos que no cumplen un criterio es fundamental. Puedes resolver esto con un bucle `for` tradicional o con el método funcional `.filter()`.

### Tu Misión:
Implementa la función `filtrarPositivos(numeros)` que reciba un arreglo con números positivos, negativos y ceros, devolviendo únicamente aquellos estrictamente mayores a 0 (`n > 0`).',
    'javascript',
    'function filtrarPositivos(numeros) {
  // Tu código aquí
}',
    'function filtrarPositivos(numeros) {
  return numeros.filter(n => n > 0);
}',
    'test("Filtra números mixtos", () => {
  expect(filtrarPositivos([-2, 5, 0, -8, 12])).toEqual([5, 12]);
});
test("Arreglo con solo negativos devuelve vacío", () => {
  expect(filtrarPositivos([-1, -3, -5])).toEqual([]);
});
test("Arreglo con solo positivos", () => {
  expect(filtrarPositivos([1, 2, 3])).toEqual([1, 2, 3]);
});',
    75,
    12
  );

  -- RETO 13: Conteo de Ocurrencias de una Letra
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: Contar Ocurrencias de un Caracter',
    'Cuenta cuántas veces aparece una letra específica dentro de una cadena de texto (sin distinguir mayúsculas de minúsculas).',
    '# Recorrido de Cadenas de Texto
Las cadenas de texto (*strings*) pueden indexarse y recorrerse de forma similar a los arreglos.

### Tu Misión:
Escribe la función `contarLetra(texto, letra)` que reciba un texto y una letra, y devuelva la cantidad de veces que aparece dicha letra. La búsqueda no debe distinguir mayúsculas de minúsculas (`"A"` debe contar igual que `"a"`).',
    'javascript',
    'function contarLetra(texto, letra) {
  // Tu código aquí
}',
    'function contarLetra(texto, letra) {
  const target = letra.toLowerCase();
  let count = 0;
  for (const char of texto.toLowerCase()) {
    if (char === target) count++;
  }
  return count;
}',
    'test("Cuenta letra repetida", () => {
  expect(contarLetra("computadora", "o")).toBe(2);
});
test("No distingue mayúsculas", () => {
  expect(contarLetra("Antigravity", "a")).toBe(2);
});
test("Letra no existente devuelve 0", () => {
  expect(contarLetra("servidor", "z")).toBe(0);
});',
    75,
    13
  );

  -- RETO 14: Validador de Longitud de Clave Segura
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: Validador de Clave',
    'Verifica que una contraseña cumpla con la longitud mínima requerida y no contenga espacios en blanco.',
    '# Validación de Entradas de Usuario
Los sistemas informáticos requieren validar que los datos cumplan políticas de seguridad antes de ser procesados o almacenados.

### Criterios de Validación:
1. La clave debe tener al menos **8 caracteres de longitud** (`clave.length >= 8`).
2. No debe contener espacios en blanco (`!clave.includes(" ")`).

### Tu Misión:
Implementa la función `validarClave(clave)` que devuelva `true` si cumple ambos criterios y `false` en caso contrario.',
    'javascript',
    'function validarClave(clave) {
  // Tu código aquí
}',
    'function validarClave(clave) {
  if (typeof clave !== "string") return false;
  return clave.length >= 8 && !clave.includes(" ");
}',
    'test("Clave válida de más de 8 caracteres", () => {
  expect(validarClave("segura123")).toBe(true);
});
test("Clave demasiado corta", () => {
  expect(validarClave("abc12")).toBe(false);
});
test("Clave con espacios no es válida", () => {
  expect(validarClave("clave con espacio")).toBe(false);
});',
    75,
    14
  );

  -- RETO 15: Encontrar el Número Mayor de una Lista
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    v_arena_module_id,
    'Lógica de Código: Buscar el Número Mayor',
    'Encuentra el valor numérico más alto dentro de un arreglo sin usar funciones externas de ordenación.',
    '# Algoritmos de Búsqueda Lineal de Extremos
Para encontrar el valor máximo de un arreglo:
1. Asume que el primer elemento es el máximo provisional (`let max = nums[0]`).
2. Recorre el resto del arreglo.
3. Si encuentras un elemento mayor al máximo actual, actualiza `max`.
4. Al terminar el ciclo, devuelve `max`.

### Tu Misión:
Crea la función `encontrarMayor(numeros)` que reciba un arreglo no vacío de números y devuelva el número de mayor valor.',
    'javascript',
    'function encontrarMayor(numeros) {
  // Tu código aquí
}',
    'function encontrarMayor(numeros) {
  let max = numeros[0];
  for (let i = 1; i < numeros.length; i++) {
    if (numeros[i] > max) {
      max = numeros[i];
    }
  }
  return max;
}',
    'test("Encuentra el mayor en números positivos", () => {
  expect(encontrarMayor([3, 15, 7, 2, 9])).toBe(15);
});
test("Funciona con números negativos", () => {
  expect(encontrarMayor([-10, -5, -20, -1])).toBe(-1);
});
test("Arreglo de un elemento", () => {
  expect(encontrarMayor([42])).toBe(42);
});',
    75,
    15
  );

END $$;
