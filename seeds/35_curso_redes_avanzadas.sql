-- ==============================================================================
-- 🌐 SGFC SEED: 35 - CURSO AVANZADO: REDES, ARQUITECTURA DE TRAMAS Y ENRUTAMIENTO
-- ==============================================================================
-- 1. Curso: "Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos"
-- 2. 4 Módulos Técnicos Profundos:
--    - M1: La Capa de Enlace & Arquitectura de Tramas Ethernet (Frames, ARP, Switching, VLANs 802.1Q)
--    - M2: Datagrama IP, Subnetting VLSM y Fragmentación L3 (IPv4/IPv6, MTU/MSS, PMTUD, NDP)
--    - M3: Enrutamiento Dinámico, L3 Switching y Alta Disponibilidad (RIB/FIB, OSPF, BGP, STP, FHRP)
--    - M4: Capa de Transporte Avanzada, Protocolos y Análisis con Wireshark (TCP FSM, BBR, QUIC, tcpdump)
-- 3. 16 Lecciones completas con diagramas de cabeceras binarias y cuestionarios interactivos.
-- 4. Certificación Oficial Verificable "CERT-NET-ADV" con banco de 15 preguntas de examen.
-- ==============================================================================

DO $NET_SEED$
DECLARE
  v_author_id UUID;
  v_prereq_id UUID;
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

  -- 2. Obtener ID del curso prerrequisito (Fundamentos de Redes)
  SELECT id INTO v_prereq_id FROM public.courses 
  WHERE title = 'Fundamentos de Redes y Telecomunicaciones' 
  LIMIT 1;

  -- 3. Limpieza idempotente previa si el curso ya existía
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT c.id FROM public.challenges c
    JOIN public.modules m ON c.module_id = m.id
    JOIN public.courses co ON m.course_id = co.id
    WHERE co.title = 'Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos'
  );
  DELETE FROM public.certification_questions WHERE certification_id IN (
    SELECT id FROM public.certifications WHERE code = 'CERT-NET-ADV'
  );
  DELETE FROM public.certifications WHERE code = 'CERT-NET-ADV';
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT m.id FROM public.modules m
    JOIN public.courses co ON m.course_id = co.id
    WHERE co.title = 'Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos'
  );
  DELETE FROM public.modules WHERE course_id IN (
    SELECT id FROM public.courses WHERE title = 'Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos'
  );
  DELETE FROM public.courses WHERE title = 'Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos';

  -- 4. Crear Curso
  INSERT INTO public.courses (
    title,
    description,
    summary,
    tags,
    min_level,
    prerequisite_course_id,
    author_id,
    status
  ) VALUES (
    'Redes Avanzadas: Arquitectura de Tramas, Switching L2, Enrutamiento L3 y Protocolos',
    'Sumérgete en las entrañas de la infraestructura de redes: disección binaria de tramas Ethernet IEEE 802.3, conmutación L2, segmentación con VLANs 802.1Q, fragmentación IP, enrutamiento dinámico con OSPF y BGP, TCP FSM avanzado y análisis forense con Wireshark.',
    $SUMMARY$## 🌐 Redes Avanzadas: De los Bits en el Cable a la Troncal Global de Internet

En el mundo del software moderno, los desarrolladores y arquitectos de sistemas a menudo tratan la red como una "caja negra" mágica que transporta llamadas HTTP o sockets. Sin embargo, cuando los microservicios experimentan latencias inexplicables, se saturan buffers de transmisión, ocurren tormentas de broadcast o fallan túneles VPN, **únicamente los ingenieros que dominan la física y lógica de las tramas y paquetes pueden diagnosticar y resolver la causa raíz**.

Este curso está diseñado para llevarte desde la comprensión superficial de direcciones IP hasta el dominio exhaustivo de las capas de Enlace (L2), Red (L3) y Transporte (L4).

---

### 🎯 Lo que dominarás en este curso:

1. **La Anatomía Exacta de una Trama Ethernet II:** Campos binarios, preámbulos, direcciones MAC OUI vs NIC, EtherTypes y el algoritmo CRC-32/FCS de verificación de integridad.
2. **Conmutación L2 y Segmentación:** Tablas CAM/TCAM, dominios de colisión vs dominios de broadcast, y etiquetado de tramas IEEE 802.1Q (VLANs, Troncales y enrutamiento Inter-VLAN).
3. **Paquetes IP y Fragmentación:** Campos de cabecera IPv4/IPv6, MTU vs MSS, Path MTU Discovery (PMTUD), cálculo binario de VLSM y sumarización CIDR.
4. **Enrutamiento Escalable:** Separación de Control Plane (RIB) y Data Plane (FIB), el algoritmo Dijkstra en OSPF y el protocolo que une el planeta: BGP (Border Gateway Protocol).
5. **Transporte de Alto Rendimiento:** Máquina de estados finitos (FSM) de TCP, Three-way handshake a nivel de bits, control de flujo por ventana deslizante, algoritmos de congestión modernos (Cubic, BBR) y la transición a QUIC / HTTP/3 sobre UDP.
6. **Inspección Forense con Wireshark y tcpdump:** Filtrado BPF avanzado, lectura de volcados hexadecimales e identificación visual de fallas y anomalías de red.
$SUMMARY$,
    ARRAY['Avanzado', 'Redes', 'Infraestructura', 'Protocolos', 'Telecomunicaciones', 'Ciberseguridad'],
    2,
    v_prereq_id,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: LA CAPA DE ENLACE & ARQUITECTURA DE TRAMAS ETHERNET
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 1: La Capa de Enlace & Arquitectura de Tramas Ethernet',
    'Disección byte a byte de tramas Ethernet II, protocolo ARP, tablas CAM en conmutadores L2 y segmentación con VLANs 802.1Q.'
  )
  RETURNING id INTO v_m1_id;

  -- Lección 1.1: Anatomía de la Trama Ethernet II (IEEE 802.3)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '1. Anatomía de la Trama Ethernet II y Campos Binarios',
    'Conoce al milímetro los campos de una trama Ethernet: Preámbulo, SFD, MACs, EtherType, Payload y FCS/CRC.',
    'quiz',
    100,
    $THEORY$# Anatomía de la Trama Ethernet II (DIX / IEEE 802.3)

En la Capa 2 (Enlace de Datos) del modelo OSI, la unidad fundamental de datos (PDU) se denomina **Trama (Frame)**. Toda la información enviada a través de cables de par trenzado, fibra óptica o Wi-Fi se encapsula dentro de esta estructura.

```text
+----------------+-----+-------------+------------+-----------+-------------------+-------------+
|   Preámbulo    | SFD | MAC Destino | MAC Origen | EtherType |   Payload (Datos) |  FCS (CRC)  |
|    7 bytes     | 1 B |   6 bytes   |  6 bytes   |  2 bytes  |  46 a 1500 bytes  |   4 bytes   |
+----------------+-----+-------------+------------+-----------+-------------------+-------------+
```

### 1. Preámbulo (Preamble) y SFD (Start of Frame Delimiter)
- **Preámbulo (7 bytes):** Secuencia de 56 bits alternados `10101010` (`0xAA`). Su función es permitir que el circuito receptor de la tarjeta de red (NIC) sincronice su reloj con la señal física del emisor.
- **SFD (1 byte):** Patrón `10101011` (`0xAB`). El par de bits `11` final indica a la tarjeta de red: *"¡Atención! El siguiente bit es el inicio exacto de la dirección MAC de destino"*.
*Nota: Ni el preámbulo ni el SFD se consideran parte de la longitud oficial de la trama en el buffer del sistema operativo.*

### 2. Direcciones MAC (Media Access Control)
- **Longitud:** 6 bytes (48 bits), expresados en hexadecimal (ej. `00:1A:2B:3C:4D:5E`).
- **OUI (Organizationally Unique Identifier):** Los primeros 3 bytes (24 bits) son asignados por la IEEE al fabricante (Intel, Cisco, Apple, etc.).
- **NIC Identifier:** Los últimos 3 bytes son un número de serie único asignado por el fabricante.
- **Bits especiales en el primer byte:**
  - Bit I/G (Individual/Group): `0` = Unicast, `1` = Multicast/Broadcast (`FF:FF:FF:FF:FF:FF`).
  - Bit U/L (Universal/Local): `0` = Administrado globalmente por IEEE, `1` = Configurado localmente.

### 3. Campo EtherType (2 bytes)
Indica qué protocolo de Capa 3 está encapsulado en el payload. Valores fundamentales:
- `0x0800`: **IPv4** (Internet Protocol v4)
- `0x86DD`: **IPv6** (Internet Protocol v6)
- `0x0806`: **ARP** (Address Resolution Protocol)
- `0x8100`: **VLAN Tagging** (IEEE 802.1Q)

### 4. Payload (Carga Útil) y Padding
- **Tamaño mínimo:** 46 bytes. Si un paquete IP tiene menos de 46 bytes (por ejemplo, un ACK de TCP de 40 bytes), la NIC añade bytes de relleno (**Padding**) de ceros para alcanzar los 46 bytes.
- **Tamaño máximo (MTU):** 1500 bytes por defecto en redes Ethernet estándar.

### 5. FCS (Frame Check Sequence) / CRC-32 (4 bytes)
- Contiene un código de redundancia cíclica calculado mediante el polinomio CRC-32 sobre las direcciones MAC, EtherType y Payload.
- Si el receptor calcula el CRC y no coincide con el FCS recibido, **descarta la trama inmediatamente** en hardware sin notificar a las capas superiores.

### Límites de Tamaño en Ethernet
- **Tamaño Mínimo de Trama:** 6 bytes (Dest) + 6 bytes (Orig) + 2 bytes (EtherType) + 46 bytes (Payload mín.) + 4 bytes (FCS) = **64 bytes**.
- **Tamaño Máximo de Trama (sin VLAN):** 6 + 6 + 2 + 1500 + 4 = **1518 bytes** (1522 bytes con etiqueta 802.1Q).
- **Runt Frame:** Cualquier trama de menos de 64 bytes (generalmente causada por colisiones o hardware defectuoso).
- **Giant / Jumbo Frame:** Tramas que superan los 1518 bytes. Las tramas *Jumbo* configuradas en centros de datos permiten payloads de hasta **9000 bytes** para reducir la carga de CPU por interrupción.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuál es la longitud mínima absoluta que debe tener una trama Ethernet válida para no ser considerada un 'Runt' y descartada?",
        "options": ["46 bytes", "64 bytes", "1500 bytes", "1518 bytes"],
        "correctIndex": 1,
        "explanation": "El estándar Ethernet IEEE 802.3 establece un tamaño mínimo de 64 bytes (14 bytes de cabecera L2 + 46 bytes de payload mínimo + 4 bytes de FCS). Cualquier trama menor es un Runt frame descartado por hardware."
      },
      {
        "id": "q2",
        "question": "Si inspeccionas una trama con Wireshark y el campo EtherType vale 0x0806, ¿qué protocolo contiene el payload?",
        "options": ["IPv4 (Internet Protocol v4)", "IPv6 (Internet Protocol v6)", "ARP (Address Resolution Protocol)", "IEEE 802.1Q (VLAN)"],
        "correctIndex": 2,
        "explanation": "El EtherType 0x0806 identifica paquetes ARP. 0x0800 corresponde a IPv4, 0x86DD a IPv6 y 0x8100 a VLANs 802.1Q."
      },
      {
        "id": "q3",
        "question": "¿Para qué sirve el campo FCS (Frame Check Sequence) al final de la trama Ethernet?",
        "options": [
          "Para cifrar el payload con algoritmo AES-256",
          "Para verificar la integridad matemática de la trama mediante un algoritmo CRC-32",
          "Para almacenar la dirección IP del router de salida",
          "Para sincronizar el reloj de la tarjeta de red antes de transmitir"
        ],
        "correctIndex": 1,
        "explanation": "El FCS contiene un CRC-32 de 4 bytes. Si el cálculo del receptor difiere del valor recibido, la trama se corrompió en el cable y es descartada silenciosamente."
      }
    ]$JSON$,
    1
  );

  -- Lección 1.2: Protocolo ARP y Resolución de Direcciones L2/L3
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '2. Protocolo ARP, ARP Gratuitous y Vulnerabilidades de Enlace',
    'Descubre cómo se mapean direcciones IP a MAC, el formato del paquete ARP y ataques como ARP Spoofing.',
    'quiz',
    100,
    $THEORY$# Protocolo ARP (Address Resolution Protocol - RFC 826)

Las aplicaciones en Internet se comunican mediante direcciones IP lógicas (Capa 3). Sin embargo, en un enlace local Ethernet, **las tarjetas de red solo aceptan tramas destinadas a su propia dirección MAC de hardware (Capa 2)**. 

El protocolo **ARP** es el puente que permite resolver: *"Conozco la IP 192.168.1.50, pero ¿cuál es su dirección MAC para poder enviarle la trama?"*.

---

### 1. El Flujo de Trabajo de ARP

```text
[Host A: 192.168.1.10]                     [Switch L2]                     [Host B: 192.168.1.50]
      |                                         |                                         |
      |-- ARP Request (Broadcast L2) ---------->|                                         |
      |   "¿Quién tiene 192.168.1.50?           |-- Inundación a todos los puertos ------>|
      |    Díselo a 192.168.1.10 (MAC A)"       |   (Destino MAC: FF:FF:FF:FF:FF:FF)      |
      |                                         |                                         |
      |                                         |<-- ARP Reply (Unicast L2) --------------|
      |<-- Reenvío directo a MAC A ------------|    "192.168.1.50 está en MAC B"         |
      |                                         |                                         |
[Guarda en Caché ARP]                                                       [Guarda en Caché ARP]
```

1. **Consulta la Caché ARP:** Antes de enviar nada, Host A revisa su tabla ARP local (`arp -a`). Si la entrada existe y no ha expirado, arma la trama inmediatamente.
2. **ARP Request:** Si no existe, Host A encapsula un paquete ARP Request en una trama Ethernet con:
   - **MAC Destino:** `FF:FF:FF:FF:FF:FF` (Broadcast de Capa 2).
   - **IP Buscada:** `192.168.1.50`.
   Todos los dispositivos de la LAN reciben la trama, pero solo quien tenga esa IP responde.
3. **ARP Reply:** Host B responde mediante un mensaje **Unicast** directo a la dirección MAC de Host A: *"Yo tengo esa IP, mi MAC es 00:11:22:33:44:55"*.
4. **Actualización de Tablas:** Ambos hosts actualizan su caché ARP dinámica (las entradas caducan típicamente en 2 a 20 minutos).

---

### 2. Gratuitous ARP (GARP)
Un paquete ARP no solicitado donde la IP de origen y la IP buscada son la misma. Se utiliza para:
1. **Detección de IPs Duplicadas (DAD):** Si un host recién encendido envía un GARP y recibe respuesta, sabe que otro equipo ya está usando su misma IP en la red.
2. **Alta Disponibilidad (Cluster / VRRP):** Cuando un servidor primario cae, el secundario emite un GARP con la IP virtual para que todos los switches y hosts de la red actualicen instantáneamente su tabla CAM y caché ARP hacia la nueva MAC.

---

### 3. Vulnerabilidades L2: ARP Spoofing / Poisoning
El protocolo ARP original fue diseñado en 1982 **sin autenticación**. Cualquier equipo en la red puede emitir respuestas ARP fraudulentas diciendo: *"Yo soy la IP 192.168.1.1 (el Router Gateway)"*.

- **Ataque Man-in-the-Middle (MitM):** El atacante engaña a la víctima para que le envíe todo el tráfico saliente a él, y engaña al router para que le envíe las respuestas a él.
- **Defensas Modernas:**
  - **DAI (Dynamic ARP Inspection):** Los switches corporativos inspeccionan paquetes ARP y los contrastan con la tabla de asignaciones seguras de **DHCP Snooping**. Si la relación IP/MAC no coincide, el switch descarta el paquete y bloquea el puerto.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Qué dirección MAC de destino utiliza un paquete 'ARP Request' cuando un host necesita averiguar la MAC de otro equipo en su LAN?",
        "options": ["00:00:00:00:00:00", "FF:FF:FF:FF:FF:FF (Broadcast)", "La dirección MAC del Router Default Gateway", "255.255.255.255"],
        "correctIndex": 1,
        "explanation": "Como el emisor desconoce qué equipo físico tiene esa IP, encapsula la consulta en una trama broadcast L2 dirigida a FF:FF:FF:FF:FF:FF para que llegue a todos los dispositivos del segmento local."
      },
      {
        "id": "q2",
        "question": "¿Cuál es una de las funciones principales de un 'Gratuitous ARP' (GARP)?",
        "options": [
          "Establecer una conexión TCP de 3 vías",
          "Detectar direcciones IP duplicadas y anunciar cambios de MAC en entornos de alta disponibilidad",
          "Asignar automáticamente una máscara de subred /24",
          "Descargar la configuración de DNS del servidor"
        ],
        "correctIndex": 1,
        "explanation": "El Gratuitous ARP se emite sin petición previa para anunciar la asociación propia de IP/MAC, permitiendo detectar conflictos de IP o actualizar rápidamente tablas en conmutación por error (failover)."
      },
      {
        "id": "q3",
        "question": "¿Qué tecnología implementan los switches administrables para neutralizar los ataques de ARP Spoofing/Poisoning?",
        "options": ["BGP Peering", "DAI (Dynamic ARP Inspection) combinada con DHCP Snooping", "NAT (Network Address Translation)", "STP (Spanning Tree Protocol)"],
        "correctIndex": 1,
        "explanation": "Dynamic ARP Inspection (DAI) intercepta todos los paquetes ARP en puertos no confiables y descarta las respuestas falsas que no coincidan con la base de datos de DHCP Snooping."
      }
    ]$JSON$,
    2
  );

  -- Lección 1.3: Conmutación L2 (Switching): Tablas CAM y Dominios de Red
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '3. Conmutación L2: Tablas CAM, Flooding y Dominios de Broadcast',
    'Comprende el ciclo de aprendizaje de un Switch L2, colisiones, broadcast y saturación de tablas.',
    'quiz',
    100,
    $THEORY$# Conmutación de Capa 2: La Lógica Interna de un Switch

A diferencia de un primitivo Hub (que simplemente repetía las señales eléctricas por todos los puertos creando colisiones), un **Switch de Capa 2** es un dispositivo inteligente que toma decisiones de reenvío basadas en las direcciones MAC de origen y destino de cada trama.

---

### 1. El Ciclo de Vida del Switch L2
El switch ejecuta 4 operaciones continuas:

```text
[Trama Entrante por Puerto 1] 
         |
         v
1. APRENDER (Learning): 
   Lee la MAC de ORIGEN -> ¿Está en la Tabla CAM? Si no, la anota: (MAC_Origen -> Puerto 1).
         |
         v
2. DECIDIR REENVÍO (Forwarding):
   Lee la MAC de DESTINO:
   - ¿Es Unicast y está en la Tabla CAM en el Puerto 3? -> Envía ÚNICAMENTE por el Puerto 3 (Forward).
   - ¿Es Unicast pero NO está en la Tabla CAM? ---------> Envía por todos los puertos excepto el 1 (Flooding / Inundación).
   - ¿Es Broadcast (FF:FF:FF:FF:FF:FF) o Multicast? ---> Envía por todos los puertos excepto el 1 (Flooding).
   - ¿Está en la tabla en el mismo Puerto 1? -----------> Descarta la trama (Filtering).
```

### 2. La Tabla CAM (Content Addressable Memory)
- Es una memoria asociativa de altísima velocidad que almacena pares `[MAC Address | Puerto | VLAN | Aging Timer]`.
- **Aging Timer:** Si un dispositivo no transmite ninguna trama durante un período (generalmente 300 segundos por defecto en switches empresariales), su entrada se elimina para no desperdiciar memoria.
- **MAC Flooding Attack:** Un atacante llena la tabla CAM con miles de MACs falsas por segundo. Cuando la tabla CAM se satura, el switch entra en modo de fallo seguro (*fail-open*) y comienza a actuar como un Hub, inundando todo el tráfico por todos los puertos, permitiendo al atacante espiar conversaciones. (Mitigación: **Port Security**).

---

### 3. Dominios de Colisión vs Dominios de Broadcast

| Concepto | Dominio de Colisión | Dominio de Broadcast |
| :--- | :--- | :--- |
| **Definición** | Área física donde dos tramas pueden chocar simultáneamente si transmiten a la vez. | Conjunto de dispositivos que reciben cualquier trama broadcast generada por un host. |
| **En Hubs** | Todos los puertos forman un único dominio de colisión (Half-Duplex). | Todos los puertos forman un único dominio de broadcast. |
| **En Switches L2** | **Cada puerto individual es un dominio de colisión separado** (Full-Duplex, 0 colisiones). | Todos los puertos del switch (sin VLANs) forman **un único gran dominio de broadcast**. |
| **En Routers L3** | Cada interfaz es un dominio de colisión independiente. | **Cada interfaz de router rompe y aísla el dominio de broadcast**. |
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Qué ocurre en un switch L2 cuando recibe una trama Unicast cuya MAC de destino NO está registrada en su tabla CAM?",
        "options": [
          "Envía un mensaje de error ICMP Destination Unreachable",
          "Inunda la trama por todos los puertos activos de esa VLAN excepto el puerto de entrada (Unknown Unicast Flooding)",
          "Descarta la trama inmediatamente",
          "Pide al servidor DNS que resuelva la dirección física"
        ],
        "correctIndex": 1,
        "explanation": "Cuando la MAC de destino es desconocida en la tabla CAM, el switch ejecuta 'Flooding' (inundación) hacia todos los demás puertos para asegurarse de que el destinatario la reciba y responda, aprendiendo así su ubicación."
      },
      {
        "id": "q2",
        "question": "En una red Ethernet conmutada moderna operando en modo Full-Duplex mediante switches, ¿cuántos dominios de colisión existen en un switch de 24 puertos?",
        "options": ["1 solo dominio de colisión", "24 dominios de colisión independientes", "Ninguno, las colisiones solo existen en Wi-Fi", "Depende de la cantidad de subredes IP configuradas"],
        "correctIndex": 1,
        "explanation": "Cada puerto individual de un switch L2 constituye su propio dominio de colisión independiente, eliminando las colisiones compartidas del antiguo estándar Half-Duplex."
      },
      {
        "id": "q3",
        "question": "¿Qué dispositivo de red es necesario para dividir y aislar dominios de Broadcast?",
        "options": ["Un Hub pasivo", "Un Switch L2 no administrable", "Un Router de Capa 3 (o segmentación mediante VLANs)", "Un repetidor de señal"],
        "correctIndex": 2,
        "explanation": "Los switches L2 propagan broadcasts por todos sus puertos. Para romper y delimitar un dominio de broadcast se requiere un Router (L3) o la creación de VLANs independientes."
      }
    ]$JSON$,
    3
  );

  -- Lección 1.4: Segmentación L2 con VLANs y Tagging 802.1Q
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '4. Segmentación L2 con VLANs y Tagging IEEE 802.1Q',
    'Aprende a particionar switches lógicamente con VLANs, enlaces troncales y la cabecera 802.1Q.',
    'quiz',
    100,
    $THEORY$# Segmentación de Red con VLANs y Tagging IEEE 802.1Q

Una **VLAN (Virtual Local Area Network)** divide un switch físico en múltiples switches lógicos independientes. Los dispositivos que pertenecen a la VLAN 10 no pueden comunicarse con los de la VLAN 20 en Capa 2, aunque estén enchufados al mismo equipo físico.

---

### 1. Tipos de Puertos en Conmutación

```text
[PC Finanzas]  ---(Acceso VLAN 10)----+
                                      |
[PC Ventas]    ---(Acceso VLAN 20)---[SWITCH 1] ===== TRONCAL 802.1Q ===== [SWITCH 2]
                                      |      (Lleva tráfico de VLAN 10 y 20)   |
[Servidor DMZ] ---(Acceso VLAN 30)----+                                       |
```

1. **Puertos de Acceso (Access Ports):**
   - Conectan dispositivos finales (PCs, impresoras, servidores).
   - Pertenecen a **una única VLAN**.
   - Las tramas que salen hacia la PC son tramas Ethernet estándar **sin etiquetar** (*untagged*); la PC nunca se entera de qué VLAN es.
2. **Puertos Troncales (Trunk Ports):**
   - Conectan switches entre sí o switches con routers.
   - Transportan simultáneamente el tráfico de múltiples VLANs a través de un único cable físico.
   - Requieren un mecanismo para que el switch receptor sepa a qué VLAN pertenece cada trama: **El etiquetado IEEE 802.1Q**.

---

### 2. Formato de la Cabecera IEEE 802.1Q (4 bytes insertados)
Cuando una trama pasa por un enlace troncal, el switch inyecta 4 bytes adicionales entre la MAC de Origen y el EtherType:

```text
+-------------+------------+--------------------+-----------+------------------+
| MAC Destino | MAC Origen |  Etiqueta 802.1Q   | EtherType | Payload y FCS    |
|   6 bytes   |  6 bytes   |      4 bytes       |  2 bytes  |                  |
+-------------+------------+--------------------+-----------+------------------+
                                  |
   +------------------------------+-------------------------------+
   | TPID (16 bits): 0x8100       | TCI: Tag Control Information  |
   +------------------------------+-------------------------------+
                                  |
      +---------------+-------------+--------------------------+
      |  PCP (3 bits) | DEI (1 bit) |   VLAN ID - VID (12 bits)|
      +---------------+-------------+--------------------------+
```

- **TPID (Tag Protocol Identifier - 16 bits):** Vale `0x8100`. Indica que esta trama contiene una etiqueta 802.1Q.
- **PCP (Priority Code Point - 3 bits):** Soporta **Calidad de Servicio (QoS IEEE 802.1p)** con valores de 0 a 7 (para priorizar tráfico sensible como voz sobre IP o video).
- **DEI (Drop Eligible Indicator - 1 bit):** Si se activa (`1`), los switches pueden descartar esta trama en caso de congestión.
- **VID (VLAN Identifier - 12 bits):** Identifica el número de VLAN. Al tener 12 bits ($2^{12} = 4096$), permite valores del **1 al 4094** (los valores 0 y 4095 están reservados).

---

### 3. VLAN Nativa y Enrutamiento Inter-VLAN
- **VLAN Nativa:** En un enlace troncal 802.1Q, el tráfico perteneciente a la VLAN Nativa (por defecto VLAN 1) viaja **sin etiqueta**. Si ambos extremos del cable troncal tienen configuradas distintas VLANs nativas, ocurre una falla grave llamada *Native VLAN Mismatch*.
- **Inter-VLAN Routing:** Como las VLANs aíslan dominios de broadcast, para comunicar la VLAN 10 con la VLAN 20 se requiere obligatoriamente un dispositivo de Capa 3:
  - **Router-on-a-Stick:** Un router conectado al switch mediante un troncal usando subinterfaces virtuales (`Gig0/0.10`, `Gig0/0.20`).
  - **Switch Multicapa (L3 Switch):** Enrutamiento a velocidad de cable mediante interfaces virtuales de switch (**SVI** - *Switch Virtual Interfaces*).
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuántos bits componen el campo VLAN ID (VID) en el encabezado IEEE 802.1Q y cuántas VLANs utilizables permite como máximo?",
        "options": ["8 bits (254 VLANs)", "12 bits (4094 VLANs)", "16 bits (65,534 VLANs)", "32 bits (4 millones de VLANs)"],
        "correctIndex": 1,
        "explanation": "El campo VID consta de 12 bits (2^12 = 4096). Restando los valores reservados 0 y 4095, el estándar permite definir hasta 4094 VLANs utilizables."
      },
      {
        "id": "q2",
        "question": "¿Qué valor hexadecimal adopta el campo TPID (Tag Protocol Identifier) para identificar la presencia de una etiqueta 802.1Q?",
        "options": ["0x0800", "0x86DD", "0x8100", "0xFFFF"],
        "correctIndex": 2,
        "explanation": "El valor 0x8100 en la posición del EtherType señala que la trama contiene un encabezado de etiquetado de VLAN IEEE 802.1Q."
      },
      {
        "id": "q3",
        "question": "¿Cómo se transporta el tráfico de la 'VLAN Nativa' a través de un enlace troncal 802.1Q estándar?",
        "options": [
          "Se cifra mediante un túnel IPsec automático",
          "Viaja sin etiquetar (Untagged), sin los 4 bytes de encabezado 802.1Q",
          "Se descarta obligatoriamente por motivos de seguridad",
          "Lleva siempre el VID 4095"
        ],
        "correctIndex": 1,
        "explanation": "Por compatibilidad histórica, el tráfico de la VLAN Nativa atraviesa los enlaces troncales 802.1Q sin etiqueta añadida (Untagged)."
      }
    ]$JSON$,
    4
  );

  -- ==============================================================================
  -- MÓDULO 2: DATAGRAMA IP, SUBNETTING VLSM Y FRAGMENTACIÓN L3
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 2: Datagrama IP, Subnetting VLSM y Fragmentación L3',
    'Estructura de cabeceras IPv4/IPv6, MTU vs MSS, algoritmos de fragmentación, direccionamiento VLSM y protocolo NDP.'
  )
  RETURNING id INTO v_m2_id;

  -- Lección 2.1: Anatomía del Datagrama IPv4
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '5. Anatomía del Datagrama IPv4 y Campos Binarios',
    'Analiza la cabecera IPv4 bit a bit: IHL, TTL, Protocolos L4 y prevención de bucles infinitos.',
    'quiz',
    100,
    $THEORY$# Anatomía del Datagrama IPv4 (RFC 791)

El protocolo IPv4 opera en la Capa 3 (Red) del modelo OSI. Su misión es el direccionamiento lógico y el enrutamiento de paquetes entre redes remotas de extremo a extremo (*End-to-End*), sin conexión previa y con entrega de mejor esfuerzo (*Best Effort*).

```text
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version|  IHL  |Type of Service|          Total Length         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Identification        |Flags|      Fragment Offset    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Time to Live |    Protocol   |        Header Checksum        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       Source IP Address                       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Destination IP Address                     |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Options (si IHL > 5)       |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### 1. Desglose de Campos Críticos

- **Version (4 bits):** Siempre vale `4` (`0100` en binario) para IPv4.
- **IHL (Internet Header Length - 4 bits):** Expresa la longitud de la cabecera en palabras de 32 bits (4 bytes).
  - El valor mínimo es `5` ($5 \times 4\text{ bytes} = \mathbf{20\text{ bytes}}$), correspondiente a una cabecera estándar sin opciones.
  - El valor máximo es `15` ($15 \times 4 = \mathbf{60\text{ bytes}}$).
- **Type of Service / DSCP & ECN (8 bits):**
  - **DSCP (Differentiated Services Code Point - 6 bits):** Clasificación de Calidad de Servicio (QoS).
  - **ECN (Explicit Congestion Notification - 2 bits):** Permite a los routers avisar a los emisores de congestión sin necesidad de descartar paquetes.
- **Total Length (16 bits):** Tamaño total del datagrama (cabecera + datos). El valor máximo es de $2^{16} - 1 = \mathbf{65,535\text{ bytes}}$.
- **Time to Live (TTL - 8 bits):**
  - Número entero (comúnmente 64, 128 o 255) que **se decrementa en 1 cada vez que el paquete atraviesa un router**.
  - Si el TTL llega a `0`, el router descarta el paquete y envía un mensaje **ICMP Time Exceeded (Tipo 11)** al emisor original. Esto previene que paquetes atrapados en bucles de enrutamiento circulen indefinidamente saturando la red. La herramienta `traceroute` explota este campo enviando paquetes con TTL=1, TTL=2, TTL=3...
- **Protocol (8 bits):** Identifica qué protocolo de Capa 4 espera los datos en el destino:
  - `1`: **ICMP** (Ping, errores de red)
  - `6`: **TCP** (Transmission Control Protocol)
  - `17`: **UDP** (User Datagram Protocol)
  - `89`: **OSPF** (Enrutamiento dinámico)
- **Header Checksum (16 bits):** Suma de verificación computada **exclusivamente sobre la cabecera IP** (no sobre los datos). Como el TTL cambia en cada salto de router, **cada router debe recalcular el checksum** antes de reenviar el paquete.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "Si una cabecera IPv4 no contiene opciones adicionales y tiene la longitud estándar mínima, ¿qué valor tiene su campo IHL?",
        "options": ["20", "5", "4", "15"],
        "correctIndex": 1,
        "explanation": "El campo IHL mide la longitud en palabras de 4 bytes. Para una cabecera mínima de 20 bytes, el valor es 20 / 4 = 5."
      },
      {
        "id": "q2",
        "question": "¿Qué ocurre cuando el valor de TTL (Time to Live) de un paquete IP llega a cero al ingresar a un router intermedio?",
        "options": [
          "El router lo envía al servidor DNS para ser reetiquetado",
          "El router descarta el paquete y emite un mensaje ICMP Time Exceeded hacia el emisor",
          "El router reinicia el TTL a 255 y lo reenvía",
          "Se convierte automáticamente en una trama broadcast"
        ],
        "correctIndex": 1,
        "explanation": "Al llegar a TTL=0, el paquete se destruye para evitar bucles infinitos en la red y se notifica al origen mediante un mensaje ICMP Time Exceeded (Tipo 11)."
      },
      {
        "id": "q3",
        "question": "¿Cuál es el número de protocolo en el encabezado IPv4 que identifica al protocolo TCP?",
        "options": ["1", "6", "17", "80"],
        "correctIndex": 1,
        "explanation": "El protocolo 6 corresponde a TCP, el 17 corresponde a UDP y el 1 corresponde a ICMP. (80 es un puerto de capa de aplicación para HTTP, no un número de protocolo IP)."
      }
    ]$JSON$,
    5
  );

  -- Lección 2.2: Fragmentación L3, MTU vs MSS y PMTUD
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '6. Fragmentación L3, MTU vs MSS y Path MTU Discovery',
    'Domina la relación entre MTU y MSS, los flags DF/MF, el Fragment Offset y por qué evitar la fragmentación.',
    'quiz',
    100,
    $THEORY$# Fragmentación en Capa 3: MTU, MSS y Flags

Diferentes tecnologías de enlace poseen distintos límites máximos sobre el tamaño de la trama que pueden transmitir. Este límite se conoce como **MTU (Maximum Transmission Unit)**.

---

### 1. MTU vs MSS: La Gran Confusión

```text
|<------------------------- MTU Ethernet: 1500 bytes ------------------------->|
+----------------------+----------------------+--------------------------------+
| Cabecera IP (20 B)   | Cabecera TCP (20 B)  |     Datos TCP (MSS: 1460 B)    |
+----------------------+----------------------+--------------------------------+
                       |<---------------- MSS: 1460 bytes -------------------->|
```

- **MTU (Maximum Transmission Unit):** Tamaño máximo del datagrama IP completo (incluyendo cabecera IP + cabecera TCP/UDP + datos) que puede viajar en una trama de Capa 2. En Ethernet estándar es de **1500 bytes**.
- **MSS (Maximum Segment Size):** Tamaño máximo **exclusivo de los datos útiles de Capa 4 (TCP)** que un host está dispuesto a recibir en un segmento, excluyendo las cabeceras IP y TCP:
$$\text{MSS} = \text{MTU} - (\text{Cabecera IP} + \text{Cabecera TCP}) = 1500 - (20 + 20) = \mathbf{1460\text{ bytes}}$$

---

### 2. Los Campos de Fragmentación IPv4
Cuando un router recibe un paquete de 1500 bytes pero debe enviarlo por una interfaz con MTU de 1000 bytes, debe dividirlo en fragmentos utilizando tres campos:

1. **Identification (16 bits):** Un número identificador único compartido por todos los fragmentos que pertenecen al mismo paquete original.
2. **Flags (3 bits):**
   - Bit 0: Reservado (siempre `0`).
   - Bit 1 - **DF (Don't Fragment):** Si vale `1`, prohíbe taxativamente la fragmentación. Si el paquete supera el MTU, el router **lo descarta**.
   - Bit 2 - **MF (More Fragments):** Vale `1` si aún quedan más fragmentos posteriores. Vale `0` en el último fragmento.
3. **Fragment Offset (13 bits):** Indica la posición del fragmento dentro del paquete original, **medida en bloques de 8 bytes (64 bits)**.
   *Por ejemplo: un offset de 185 significa que los datos comienzan en el byte $185 \times 8 = 1480$.*

---

### 3. Por qué la Fragmentación es Crítica y Nociva
- **Riesgo de pérdida:** Si se transmiten 4 fragmentos de un paquete y se pierde 1 solo en el camino, **todo el paquete original queda inservible** y la Capa 4 debe retransmitir todo desde cero.
- **Sobrecarga de CPU:** Los routers intermedios sufren un impacto masivo de rendimiento al fragmentar datagramas en software en lugar de usar conmutación por hardware ASIC.

### 4. PMTUD (Path MTU Discovery - RFC 1191)
Para evitar fragmentar, los sistemas operativos modernos activan el flag **DF = 1** en todos sus paquetes.
- Si un router en el camino no puede reenviar el paquete porque su enlace tiene una MTU menor, lo descarta y responde al emisor con un mensaje:
  **ICMP Tipo 3 Código 4: "Destination Unreachable, Fragmentation Needed and DF set"**, informando la MTU exacta de su enlace.
- El host emisor reduce su MSS automáticamente para adaptarse al cuello de botella sin fragmentar nunca.
- *Atención a los Firewalls:* Si un administrador bloquea todos los mensajes ICMP indiscriminadamente, causa el temido fenómeno de **Black Hole Connection** (las conexiones TCP negocian el handshake pero se congelan cuando intentan transferir datos grandes).
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "En una red Ethernet con MTU estándar de 1500 bytes y cabeceras base de IPv4 (20 bytes) y TCP (20 bytes), ¿cuál es el valor típico de MSS (Maximum Segment Size)?",
        "options": ["1500 bytes", "1460 bytes", "1480 bytes", "1024 bytes"],
        "correctIndex": 1,
        "explanation": "El MSS representa únicamente la carga útil de datos TCP. Se calcula como MTU (1500) - Cabecera IP (20) - Cabecera TCP (20) = 1460 bytes."
      },
      {
        "id": "q2",
        "question": "¿En qué unidades mide la posición de los datos el campo 'Fragment Offset' de la cabecera IPv4?",
        "options": ["En bits individuales", "En bytes individuales", "En bloques de 8 bytes (64 bits)", "En kilobytes"],
        "correctIndex": 2,
        "explanation": "El Fragment Offset mide el desplazamiento de los datos en bloques de 8 octetos (8 bytes). Por ello, el tamaño de cada fragmento previo debe ser múltiplo de 8."
      },
      {
        "id": "q3",
        "question": "¿Qué ocurre si un paquete viaja con el flag DF (Don't Fragment) activado en 1 y se encuentra con un enlace cuyo MTU es menor al tamaño del paquete?",
        "options": [
          "El router ignora el flag y lo fragmenta de todos modos",
          "El router descarta el paquete y devuelve un mensaje ICMP Fragmentation Needed",
          "El paquete se comprime con gzip antes de transmitirse",
          "El router almacena el paquete en caché hasta que el MTU aumente"
        ],
        "correctIndex": 1,
        "explanation": "El flag DF prohíbe fragmentar. Al ser excedido el MTU, el router descarta el paquete y notifica al origen con ICMP Tipo 3, Código 4 (mecanismo base de PMTUD)."
      }
    ]$JSON$,
    6
  );

  -- Lección 2.3: Subnetting Avanzado, VLSM y Sumarización de Rutas
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '7. Subnetting Avanzado, VLSM y Sumarización CIDR',
    'Aprende cálculo binario de máscaras de longitud variable (VLSM) y diseño de enlaces eficientes.',
    'quiz',
    100,
    $THEORY$# Subnetting Avanzado, VLSM y Sumarización de Rutas

En los inicios de Internet (Classful Networking), las redes se dividían rígidamente en Clase A (/8), Clase B (/16) y Clase C (/24). Esto generó un desperdicio colosal de direcciones IPv4. En 1993 se introdujo **CIDR (Classless Inter-Domain Routing - RFC 1519)** y **VLSM (Variable Length Subnet Masking)**.

---

### 1. La Matemática Binaria de las Subredes
Toda dirección IPv4 de 32 bits se divide en dos partes:
`[ Bits de Red (Network) | Bits de Host ]`

La máscara de subred indica cuántos bits pertenecen a la red mediante unos (`1`) continuos.

$$\text{Hosts utilizables por subred} = 2^{h} - 2$$
*(Se restan 2 direcciones: la primera es la **Identificación de Red** con todos los bits de host en 0, y la última es la dirección de **Broadcast** con todos los bits de host en 1).*

| Prefijo CIDR | Máscara Decimal | Bits Host ($h$) | Total IPs ($2^h$) | Hosts Útiles ($2^h - 2$) | Caso de Uso Típico |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **/24** | 255.255.255.0 | 8 | 256 | 254 | Red local de oficina o sede |
| **/27** | 255.255.255.224 | 5 | 32 | 30 | Granja de servidores pequeña |
| **/29** | 255.255.255.248 | 3 | 8 | 6 | Bloque público de DMZ / Firewalls |
| **/30** | 255.255.255.252 | 2 | 4 | 2 | Enlace WAN punto a punto tradicional |
| **/31** | 255.255.255.254 | 1 | 2 | 2 (RFC 3021) | Enlaces punto a punto en routers modernos |
| **/32** | 255.255.255.255 | 0 | 1 | 1 (Host único) | Interfaz Loopback de Router |

---

### 2. VLSM (Variable Length Subnet Masking)
Consiste en **subdividir una subred en subredes más pequeñas con diferentes máscaras**, según la necesidad exacta de cada departamento, evitando desperdiciar bloques enteros:

**Ejemplo Práctico:** Disponemos del bloque `192.168.10.0/24`. Debemos diseñar:
1. **Sede Central:** Requiere 100 hosts $\rightarrow$ Necesitamos $2^7 - 2 = 126$ hosts $\rightarrow$ Usamos **/25** (`192.168.10.0/25`, IPs útiles `.1` a `.126`).
2. **Sucursal A:** Requiere 50 hosts $\rightarrow$ Necesitamos $2^6 - 2 = 62$ hosts $\rightarrow$ Usamos **/26** (`192.168.10.128/26`, IPs útiles `.129` a `.190`).
3. **Enlace WAN P2P:** Conecta Central y Sucursal A (solo 2 IPs) $\rightarrow$ Usamos **/30** (`192.168.10.192/30`, IPs útiles `.193` y `.194`).

---

### 3. Sumarización de Rutas (Route Summarization / Supernetting)
Permite a un router consolidar múltiples rutas contiguas en **un único prefijo resumen**, reduciendo el consumo de memoria RAM en la tabla de enrutamiento y evitando que caídas de enlaces locales causen recálculos en toda la red global.

**Ejemplo de Sumarización:**
- `10.1.0.0/24` = `00001010 . 00000001 . 000000 00 . 00000000`
- `10.1.1.0/24` = `00001010 . 00000001 . 000000 01 . 00000000`
- `10.1.2.0/24` = `00001010 . 00000001 . 000000 10 . 00000000`
- `10.1.3.0/24` = `00001010 . 00000001 . 000000 11 . 00000000`
Los primeros **22 bits** son exactamente idénticos. Por lo tanto, las 4 subredes se resumen como: **`10.1.0.0/22`**.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuántas direcciones IP utilizables para hosts proporciona una subred con máscara /28 (255.255.255.240)?",
        "options": ["16", "14", "30", "6"],
        "correctIndex": 1,
        "explanation": "Un prefijo /28 deja 32 - 28 = 4 bits de host. 2^4 = 16 direcciones totales. Restando la dirección de red y la de broadcast: 16 - 2 = 14 hosts utilizables."
      },
      {
        "id": "q2",
        "question": "En un enlace serial punto a punto que solo conecta dos routers entre sí sin ningún otro equipo, ¿cuál es el prefijo CIDR tradicional más eficiente para no desperdiciar direcciones IP?",
        "options": ["/24", "/29", "/30", "/27"],
        "correctIndex": 2,
        "explanation": "El prefijo /30 proporciona 4 direcciones totales: red, 2 IPs de host (una para cada interfaz de router) y broadcast, siendo la asignación clásica más eficiente."
      },
      {
        "id": "q3",
        "question": "¿Cuál es el beneficio principal de la sumarización de rutas (supernetting) en los routers de una troncal?",
        "options": [
          "Aumenta la velocidad física de la fibra óptica",
          "Reduce drásticamente el tamaño de las tablas de enrutamiento y el consumo de CPU y memoria",
          "Obliga a todas las conexiones a utilizar cifrado TLS",
          "Elimina la necesidad de utilizar switches L2"
        ],
        "correctIndex": 1,
        "explanation": "La sumarización agrupa decenas o miles de rutas en un solo prefijo compacto, lo que disminuye el tamaño de las tablas de enrutamiento y aísla la inestabilidad de rutas locales."
      }
    ]$JSON$,
    7
  );

  -- Lección 2.4: Arquitectura IPv6: Cabecera Simplificada y Neighbor Discovery
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '8. Arquitectura IPv6: Cabecera Fija y Neighbor Discovery Protocol (NDP)',
    'Compara IPv6 frente a IPv4: cabecera fija de 40 bytes, Extension Headers, SLAAC y reemplazo de ARP por NDP.',
    'quiz',
    100,
    $THEORY$# Arquitectura de IPv6: Eficiencia de Hardware y Protocolo NDP

Diseñado para resolver el agotamiento inminente de los 4.294 millones de direcciones de IPv4, **IPv6 (RFC 8200)** no solo expande el espacio a 128 bits ($3.4 \times 10^{38}$ direcciones), sino que rediseñó radicalmente la arquitectura de capa 3 para acelerar el procesamiento en silicio.

---

### 1. Cabecera Base IPv6: Fija de 40 Bytes
A diferencia de IPv4 (cuya cabecera variaba entre 20 y 60 bytes requiriendo que los routers calcularan el campo IHL), IPv6 tiene una cabecera **estrictamente fija de 40 bytes**:

```text
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version| Traffic Class |           Flow Label                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Payload Length        |  Next Header  |   Hop Limit   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                                                               +
|                                                               |
+                         Source Address                        +
|                           (128 bits)                          |
+                                                               +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                                                               +
|                                                               |
+                      Destination Address                      +
|                           (128 bits)                          |
+                                                               +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### Optimizaciones Clave frente a IPv4:
1. **Eliminación del Header Checksum:** Las capas 2 (CRC-32) y 4 (TCP/UDP Checksum) ya validan la integridad. Al quitar el Checksum de Capa 3, **los routers ya no pierden tiempo recalculando sumas en cada salto**.
2. **Hop Limit:** Es el sustituto exacto del TTL de IPv4.
3. **Flow Label (20 bits):** Permite a los conmutadores identificar flujos de paquetes específicos (ej. streaming de video) y mantenerlos en la misma ruta sin tener que inspeccionar las cabeceras de transporte.
4. **Next Header (8 bits):** Reemplaza al campo *Protocol*. Si se requieren opciones adicionales (fragmentación, autenticación IPsec), se encadenan mediante **Extension Headers** después de la cabecera fija, procesadas únicamente por el host de destino.

---

### 2. Muerte del Broadcast y Nacimiento de NDP
En IPv6 **no existe el concepto de Broadcast**. Las difusiones masivas que inundaban redes en IPv4 fueron sustituidas por **Multicast** y **Anycast**.

El protocolo ARP fue completamente eliminado y reemplazado por **NDP (Neighbor Discovery Protocol - RFC 4861)** basado en mensajes ICMPv6:
- **RS (Router Solicitation) y RA (Router Advertisement):** Permite a un dispositivo autoconfigurarse su dirección IP global de forma instantánea sin necesidad de un servidor DHCP (**SLAAC** - *Stateless Address Autoconfiguration*). El router anuncia el prefijo `/64` de la red y el host genera su ID de interfaz.
- **NS (Neighbor Solicitation) y NA (Neighbor Advertisement):** Sustituyen a las consultas ARP tradicionales. En lugar de emitir un broadcast ruidoso a toda la red, la consulta NS se envía a una dirección multicast especial llamada **Solicited-Node Multicast Address**, de modo que solo el equipo objetivo escucha y responde.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuál es el tamaño fijo de la cabecera base de un paquete IPv6 antes de cualquier cabecera de extensión?",
        "options": ["20 bytes", "32 bytes", "40 bytes", "64 bytes"],
        "correctIndex": 2,
        "explanation": "La cabecera base de IPv6 tiene una longitud estricta de 40 bytes. Esta regularidad permite que los circuitos ASIC de los routers procesen paquetes a altísima velocidad sin leer campos de longitud variable."
      },
      {
        "id": "q2",
        "question": "¿Qué campo presente en la cabecera IPv4 fue eliminado en IPv6 para acelerar el enrutamiento en los routers intermedios?",
        "options": ["Source Address", "Header Checksum", "Payload Length", "Hop Limit"],
        "correctIndex": 1,
        "explanation": "El Header Checksum fue eliminado en IPv6 porque las capas 2 y 4 ya verifican la integridad de datos, evitando que cada router tenga que recalcularlo al decrementar el Hop Limit."
      },
      {
        "id": "q3",
        "question": "¿Qué protocolo y mensajes sustituyen a ARP en las redes IPv6 para resolver direcciones físicas de Capa 2?",
        "options": [
          "DHCPv6 Discover y Request",
          "NDP (Neighbor Discovery Protocol) mediante mensajes Neighbor Solicitation (NS) y Neighbor Advertisement (NA)",
          "BGP Update",
          "DNS AAAA Query"
        ],
        "correctIndex": 1,
        "explanation": "En IPv6, NDP reemplaza a ARP utilizando mensajes ICMPv6 Neighbor Solicitation (NS) y Neighbor Advertisement (NA) enviados sobre direcciones multicast específicas."
      }
    ]$JSON$,
    8
  );

  -- ==============================================================================
  -- MÓDULO 3: ENRUTAMIENTO DINÁMICO, L3 SWITCHING Y ALTA DISPONIBILIDAD
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 3: Enrutamiento Dinámico, L3 Switching y Alta Disponibilidad',
    'Diferenciación RIB vs FIB, protocolos IGP (OSPF) y EGP (BGP), prevención de bucles L2 con STP y redundancia FHRP.'
  )
  RETURNING id INTO v_m3_id;

  -- Lección 3.1: Principios de Enrutamiento L3 y Tablas de Ruteo
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '9. Principios de Enrutamiento L3: RIB, FIB y Longest Prefix Match',
    'Conoce la arquitectura interna de un router: Control Plane vs Data Plane, Longest Prefix Match y Distancia Administrativa.',
    'quiz',
    100,
    $THEORY$# Arquitectura de Enrutamiento: Control Plane vs Data Plane

Un router moderno no es un simple programa que busca en una lista secuencial. Para conmutar millones de paquetes por segundo (Terabits/s en troncales), su arquitectura está estrictamente separada en dos planos:

```text
+--------------------------------------------------------------------+
|  PLANO DE CONTROL (Control Plane - CPU / Software)                |
|  - Protocolos de Enrutamiento (OSPF, BGP, RIP)                    |
|  - Construye la RIB (Routing Information Base / Tabla de Rutas)   |
+--------------------------------------------------------------------+
                                |
                   Compilación y Optimización
                                v
+--------------------------------------------------------------------+
|  PLANO DE DATOS (Data Plane / Forwarding Plane - Hardware / ASICs)|
|  - FIB (Forwarding Information Base)                              |
|  - Tabla de Adyacencias (Adjacency Table / MAC rewrite)           |
|  - Reenvío inmediato por hardware (CEF: Cisco Express Forwarding) |
+--------------------------------------------------------------------+
```

---

### 1. La Regla de Oro: Longest Prefix Match (LPM)
Cuando un paquete arriba con una IP de destino, es muy común que **múltiples rutas de la tabla coincidan**. ¿Cuál elige el router?
**El router siempre selecciona la ruta con el prefijo más específico (la máscara de subred más larga / con más bits en 1)**, sin importar el protocolo ni la métrica.

**Ejemplo Práctico:** La tabla de rutas tiene:
1. `0.0.0.0/0` vía Gateway A (Ruta por defecto, longitud 0)
2. `10.0.0.0/8` vía Gateway B (Longitud 8)
3. `10.50.0.0/16` vía Gateway C (Longitud 16)
4. `10.50.20.0/24` vía Gateway D (Longitud 24)

Llega un paquete con destino **`10.50.20.15`**.
Las cuatro rutas coinciden. El router elige sin dudar la **Ruta 4 (`/24`)**, porque 24 es el prefijo más largo y específico (*Longest Prefix Match*).

---

### 2. Distancia Administrativa (AD): La Confiabilidad del Origen
Si dos protocolos distintos (ej. OSPF y BGP) aprenden una ruta **hacia exactamente la misma subred y máscara**, el router utiliza la **Distancia Administrativa (AD)** para desempatar cuál entra a la tabla de enrutamiento (RIB).
*A menor valor numérico, mayor es la confiabilidad de la fuente.*

| Fuente de Enrutamiento | Distancia Administrativa (Cisco Estándar) |
| :--- | :---: |
| **Interfaz Directamente Conectada** | **0** |
| **Ruta Estática** | **1** |
| **BGP Externo (eBGP)** | **20** |
| **EIGRP Interno** | **90** |
| **OSPF** | **110** |
| **IS-IS** | **115** |
| **RIP** | **120** |
| **BGP Interno (iBGP)** | **200** |
| **Inalcanzable / Desconocida** | **255** |
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "Si la tabla de rutas de un router tiene entradas para 192.168.0.0/16, 192.168.1.0/24 y 0.0.0.0/0, ¿qué ruta utilizará para reenviar un paquete con destino 192.168.1.75?",
        "options": [
          "0.0.0.0/0 por ser la ruta predeterminada",
          "192.168.0.0/16 por tener mayor rango de IPs",
          "192.168.1.0/24 debido al principio de Longest Prefix Match (prefijo más específico)",
          "Desechará el paquete por ambigüedad"
        ],
        "correctIndex": 2,
        "explanation": "La regla Longest Prefix Match establece que ante múltiples coincidencias, el router siempre reenvía por la ruta cuya máscara sea más larga y específica (en este caso /24)."
      },
      {
        "id": "q2",
        "question": "Entre una ruta aprendida por OSPF (AD = 110) y una ruta aprendida por eBGP (AD = 20) hacia exactamente el mismo prefijo de red, ¿cuál instalará el router en la RIB?",
        "options": [
          "OSPF porque tiene mayor distancia administrativa",
          "eBGP porque a menor distancia administrativa, mayor es la confiabilidad de la fuente",
          "Ambas en balanceo de carga estricto",
          "Ninguna, genera un conflicto fatal de enrutamiento"
        ],
        "correctIndex": 1,
        "explanation": "La Distancia Administrativa mide la confiabilidad: un valor numérico menor indica mayor prioridad. eBGP (AD 20) prevalece sobre OSPF (AD 110)."
      },
      {
        "id": "q3",
        "question": "¿Qué tabla del Plano de Datos (Data Plane) programa el router en memoria rápida de hardware para realizar el reenvío de paquetes a velocidad de cable?",
        "options": ["La tabla ARP dinámica", "La FIB (Forwarding Information Base)", "La base de datos DNS caché", "El log de eventos Syslog"],
        "correctIndex": 1,
        "explanation": "La FIB (Forwarding Information Base) es la estructura optimizada en el plano de datos que el hardware/ASIC utiliza para conmutar paquetes directamente a velocidad de línea."
      }
    ]$JSON$,
    9
  );

  -- Lección 3.2: Protocolos IGP: Vector Distancia vs Estado de Enlace (OSPF)
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '10. Protocolos IGP: Vector Distancia vs Estado de Enlace (OSPF)',
    'Compara algoritmos de enrutamiento interior, áreas OSPF, algoritmo SPF de Dijkstra y LSAs.',
    'quiz',
    100,
    $THEORY$# Enrutamiento Dinámico Interior (IGP): Vector Distancia vs OSPF

Dentro de una misma organización o red corporativa (**Sistema Autónomo**), se utilizan protocolos de enrutamiento interior (**IGP** - *Interior Gateway Protocol*) para que los routers aprendan automáticamente las mejores rutas y converjan rápidamente ante caídas de enlaces.

---

### 1. Vector Distancia vs Estado de Enlace

| Característica | Vector Distancia (ej. RIP v2) | Estado de Enlace (ej. OSPF v2 / v3) |
| :--- | :--- | :--- |
| **Visión de la Red** | *"Enrutamiento por rumor"*. Cada router solo conoce lo que su vecino directo le dice. | **Visión topológica completa**. Cada router conoce el mapa idéntico de toda la red. |
| **Métrica** | Conteo de saltos (*Hop Count*, máx. 15). Ignora el ancho de banda. | **Costo** basado en el ancho de banda de los enlaces ($\text{Costo} = \frac{10^8}{\text{Bandwidth en bps}}$). |
| **Algoritmo** | Bellman-Ford (lenta convergencia, propenso a bucles). | **Dijkstra SPF (Shortest Path First)** (convergencia casi instantánea). |
| **Actualizaciones** | Envía la tabla completa periódicamente (cada 30s). | Envía actualizaciones incrementales (**LSAs**) solo cuando cambia la topología. |

---

### 2. OSPF (Open Shortest Path First - RFC 2328)
OSPF es el estándar abierto más extendido en redes empresariales y de campus.

#### A. Formación de Vecindades y Paquetes OSPF
Los routers envían paquetes multicast **Hello** (a `224.0.0.5`) cada 10 segundos para descubrirse y mantener el estado `FULL`:
1. **Hello:** Descubrimiento y liveness check.
2. **DBD (Database Description):** Resumen de la base de datos de enlaces.
3. **LSR (Link State Request):** Solicita detalles sobre un enlace específico.
4. **LSU (Link State Update):** Contiene los anuncios de estado de enlace (**LSAs**).
5. **LSAck (Link State Acknowledgment):** Acuse de recibo confiable.

#### B. La LSDB y el Algoritmo Dijkstra
Todos los routers OSPF intercambian LSAs hasta que su **LSDB (Link-State Database)** es idéntica en toda el área. En ese momento, cada router ejecuta el **Algoritmo SPF de Dijkstra** colocándose a sí mismo como raíz de un árbol para calcular el camino más corto y de menor costo acumulado hacia cada subred.

#### C. Diseño Jerárquico en Áreas
Para evitar que redes de miles de routers colapsen recalculando Dijkstra continuamente, OSPF divide la red en **Áreas**:
- **Área 0 (Backbone Area):** El núcleo obligatorio de la red. **Todas las demás áreas deben conectarse físicamente o lógicamente al Área 0**.
- **ABR (Area Border Router):** Router situado en el borde que conecta un área estándar con el Área 0. Limita la propagación de LSAs detalladas, inyectando solo resúmenes.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Qué algoritmo matemático ejecuta OSPF para calcular el camino más corto y eficiente hacia cada subred de la red?",
        "options": ["Algoritmo de Bellman-Ford", "Algoritmo SPF (Shortest Path First) de Dijkstra", "Algoritmo de Floyd-Warshall", "Algoritmo de Diffie-Hellman"],
        "correctIndex": 1,
        "explanation": "OSPF utiliza el algoritmo de Dijkstra (Shortest Path First) sobre su base de datos topológica unificada (LSDB) para calcular las rutas óptimas libres de bucles."
      },
      {
        "id": "q2",
        "question": "¿Cuál es la métrica principal que utiliza OSPF para determinar el costo de un enlace?",
        "options": ["La cantidad de saltos de routers", "El ancho de banda (bandwidth) de la interfaz", "El retardo (delay) en microsegundos", "El uso de CPU del router vecino"],
        "correctIndex": 1,
        "explanation": "OSPF calcula el costo en función inversa del ancho de banda del enlace (Costo = Referencia / Bandwidth), prefiriendo siempre enlaces de alta velocidad sobre líneas lentas."
      },
      {
        "id": "q3",
        "question": "En una arquitectura OSPF multiarea, ¿cuál es el área central obligatoria a la cual deben conectarse todas las demás áreas?",
        "options": ["Área 1", "Área 100", "Área 0 (Backbone Area)", "Área DMZ"],
        "correctIndex": 2,
        "explanation": "El Área 0 (Backbone Area) es el núcleo obligatorio de tránsito en cualquier diseño jerárquico OSPF multiarea."
      }
    ]$JSON$,
    10
  );

  -- Lección 3.3: Protocolo EGP: BGP, Sistemas Autónomos y la Troncal de Internet
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '11. Protocolo EGP: BGP, Sistemas Autónomos y la Troncal de Internet',
    'Descubre el protocolo que une el planeta: Sistemas Autónomos (ASN), políticas eBGP/iBGP y BGP Hijacking.',
    'quiz',
    100,
    $THEORY$# BGP (Border Gateway Protocol): El Pegamento Global de Internet

Mientras que OSPF gestiona el tráfico dentro de una empresa, **BGP-4 (RFC 4271)** es el único protocolo que permite que miles de proveedores de servicios de Internet (ISPs), empresas tecnológicas (Google, Cloudflare, Amazon) y universidades se interconecten a escala planetaria.

---

### 1. Sistemas Autónomos (AS) y ASN
Internet es una "red de redes". Cada entidad participante administra un **Sistema Autónomo (AS - Autonomous System)**: un conjunto de redes IP bajo una política de administración y enrutamiento común.
- Cada AS tiene un número identificador único global denominado **ASN (Autonomous System Number)** asignado por IANA/RIRs:
  - ASN de 16 bits (rango histórico: `1` a `65535`).
  - ASN de 32 bits (soporta más de 4.000 millones de ASNs).
  - ASNs Privados (ej. `64512` a `65534`) para uso interno similar a las IPs privadas RFC 1918.

---

### 2. Protocolo Vector Ruta (Path Vector)
BGP no calcula rutas por velocidad en milisegundos ni por conteo de saltos; **es un protocolo basado en políticas comerciales y longitud de caminos**.
- Para evitar bucles entre países y continentes, cada anuncio de red lleva un atributo fundamental llamado **AS-Path**: la lista ordenada de todos los Sistemas Autónomos por los que ha viajado ese prefijo.
  *Ejemplo:* `AS-Path: 15169 3356 1239` (Google $\rightarrow$ Lumen $\rightarrow$ Sprint).
- Si un router recibe un anuncio que contiene en el AS-Path su propio número de ASN, **lo rechaza de inmediato porque detecta un bucle**.

```text
[AS 15169 (Google)]  ==== eBGP ==== [AS 3356 (Lumen/Level3)] ==== eBGP ==== [AS 7303 (Telecom)]
```

- **eBGP (External BGP):** Conecta routers de dos Sistemas Autónomos distintos (Distancia Administrativa = 20).
- **iBGP (Internal BGP):** Distribuye las rutas de Internet entre los routers de borde dentro del mismo Sistema Autónomo (Distancia Administrativa = 200).
- **Transporte Confiable:** A diferencia de OSPF (que corre directo sobre IP), BGP utiliza una sesión orientada a conexión **TCP sobre el puerto 179**.

---

### 3. Vulnerabilidades Críticas: BGP Hijacking y RPKI
Por diseño original, cualquier router BGP podía anunciar cualquier bloque IP del mundo sin presentar credenciales.
- **BGP Hijacking (Secuestro de Rutas):** Un ISP malicioso (o por un error de configuración de un operador) anuncia un prefijo que no le pertenece (ej. el bloque DNS de Google `8.8.8.0/24`). Como BGP prefiere prefijos más específicos o caminos más cortos, routers de todo el mundo redirigen el tráfico de millones de usuarios hacia el atacante.
- **RPKI (Resource Public Key Infrastructure):** La defensa criptográfica moderna. Utiliza firmas digitales basadas en certificados X.509 (**ROA** - *Route Origin Authorization*) para verificar criptográficamente si el ASN emisor es el dueño legítimo de ese prefijo IP antes de aceptarlo.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Qué protocolo de transporte de Capa 4 y qué puerto utiliza BGP para establecer sus sesiones de peering entre routers vecinos?",
        "options": ["UDP puerto 520", "TCP puerto 179", "ICMP puerto 1", "Encapsulación directa en Ethernet sin Capa 4"],
        "correctIndex": 1,
        "explanation": "BGP utiliza TCP en el puerto 179 para garantizar la entrega confiable y ordenada de sus mensajes de actualización de rutas entre pares."
      },
      {
        "id": "q2",
        "question": "¿Cómo detecta y previene BGP la formación de bucles de enrutamiento a escala global?",
        "options": [
          "Midiendo el tiempo de ping (RTT) hacia cada destino",
          "Revisando el atributo AS-Path: si el router ve su propio ASN en la lista, descarta el anuncio",
          "Limitando el TTL de todos los paquetes a un máximo de 15 saltos",
          "Reiniciando la sesión TCP cada 60 segundos"
        ],
        "correctIndex": 1,
        "explanation": "El atributo AS-Path registra la secuencia de ASNs atravesados. Si un router recibe un prefijo que ya contiene su propio ASN en la lista, sabe que ha dado una vuelta y rechaza la ruta para evitar bucles."
      },
      {
        "id": "q3",
        "question": "¿Qué mecanismo criptográfico moderno permite validar la legitimidad del ASN que origina un prefijo IP para prevenir ataques de BGP Hijacking?",
        "options": ["WPA3 Enterprise", "RPKI (Resource Public Key Infrastructure) con registros ROA", "STP BPDU Guard", "Dynamic ARP Inspection"],
        "correctIndex": 1,
        "explanation": "RPKI (Resource Public Key Infrastructure) valida criptográficamente mediante certificados ROA que un Sistema Autónomo tiene autorización legal para anunciar determinados bloques IP."
      }
    ]$JSON$,
    11
  );

  -- Lección 3.4: Redundancia y Prevención de Bucles: STP y FHRP
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '12. Redundancia de Red: STP (Spanning Tree) y Protocolos FHRP',
    'Evita tormentas de broadcast con STP/RSTP y garantiza alta disponibilidad en gateways con VRRP/HSRP.',
    'quiz',
    100,
    $THEORY$# Redundancia en Redes: Bucles L2 (STP) y Gateways de Alta Disponibilidad (FHRP)

En redes de producción no puede haber puntos únicos de fallo (*SPOF*). Se instalan cables y conmutadores duplicados. Sin embargo, la redundancia sin control genera **catástrofes inmediatas en Capa 2**.

---

### 1. El Peligro Mortal: Bucles de Capa 2 y Tormentas de Broadcast
Las cabeceras IP tienen un campo TTL para morir si entran en un bucle. **¡Las tramas Ethernet de Capa 2 NO tienen ningún campo TTL!**
Si dos switches se conectan con dos cables formando un bucle físico y una PC emite una trama Broadcast (ej. un ARP Request):
1. El Switch A la inunda por el cable 1 y cable 2.
2. El Switch B la recibe y la vuelve a inundar hacia el Switch A.
3. Las tramas se multiplican exponencialmente en microsegundos, saturando el ancho de banda al 100% (**Tormenta de Broadcast**) y reescribiendo continuamente la tabla CAM hasta congelar por completo los procesadores de los switches.

---

### 2. Spanning Tree Protocol (STP - IEEE 802.1D / RSTP 802.1w)
STP resuelve este dilema permitiendo tener cables físicos redundantes mientras **bloquea lógicamente uno de los caminos** para mantener una topología libre de bucles en forma de árbol. Si el enlace principal se corta, el puerto bloqueado se activa automáticamente.

```text
       [Root Bridge (Switch Central)]
             /                  \
   (Root Port)               (Root Port)
           /                      \
      [Switch 2] --- (BLOQUEADO) --- [Switch 3]
                       ^
             Evita el bucle físico
```

#### Elección del Root Bridge:
1. Los switches intercambian tramas especiales llamadas **BPDUs (Bridge Protocol Data Units)**.
2. El switch con el menor **Bridge ID** (compuesto por Prioridad + Dirección MAC) es elegido **Root Bridge** (el rey de la topología).
3. Estados de puerto en RSTP (802.1w, rápida convergencia en menos de 1 segundo):
   - **Root Port:** El puerto con el mejor camino hacia el Root Bridge.
   - **Designated Port:** El puerto que reenvía tráfico en cada segmento de cable.
   - **Alternate / Blocking Port:** El puerto redundante puesto en espera (no reenvía datos).

---

### 3. Redundancia de Primer Salto: FHRP (VRRP y HSRP)
Si una PC tiene configurado como Default Gateway la IP estática `192.168.1.1` (Router 1) y el Router 1 se quema, la PC pierde Internet aunque exista un Router 2 al lado.

Los protocolos **FHRP (First Hop Redundancy Protocol)** crean un **Router Virtual Compartido**:
- **HSRP (Hot Standby Router Protocol):** Propietario de Cisco.
- **VRRP (Virtual Router Redundancy Protocol - RFC 5798):** Estándar abierto IETF.

```text
                [IP Virtual: 192.168.1.1 (Gateway de las PCs)]
                               /             \
       [Router 1 (ACTIVO / MASTER)]       [Router 2 (STANDBY / BACKUP)]
            IP real: .2                        IP real: .3
```
- Ambos routers comparten una IP virtual (`192.168.1.1`) y una MAC virtual especial (ej. `00:00:5E:00:01:XX` en VRRP).
- Las PCs apuntan siempre a la IP virtual.
- El router activo responde al tráfico y envía mensajes *Heartbeat* periódicos al de respaldo. Si el router activo deja de enviar señales durante 3 segundos, el router de respaldo asume la IP y MAC virtual de forma transparente para los usuarios.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Por qué un bucle físico en switches de Capa 2 provoca una 'Tormenta de Broadcast' catastrófica a diferencia de lo que ocurre en Capa 3?",
        "options": [
          "Porque las tramas Ethernet no poseen ningún campo TTL (Time to Live) que limite su tiempo de vida",
          "Porque los cables UTP no soportan más de 100 Mbps",
          "Porque el protocolo ARP prohíbe el uso de fibra óptica",
          "Porque los switches no disponen de memoria RAM"
        ],
        "correctIndex": 0,
        "explanation": "Las tramas Ethernet carecen de un mecanismo de decremento o expiración como el TTL de IP; por ende, un broadcast en bucle circula y se multiplica infinitamente hasta colapsar los conmutadores."
      },
      {
        "id": "q2",
        "question": "¿Cómo elige Spanning Tree Protocol (STP) cuál de los switches de la red actuará como el 'Root Bridge' central?",
        "options": [
          "Selecciona al switch con la dirección IP más alta",
          "Selecciona al switch con el menor Bridge ID (menor prioridad configurada o menor dirección MAC)",
          "Lo elige al azar cada 10 minutos",
          "Siempre elige al switch que tenga mayor cantidad de puertos"
        ],
        "correctIndex": 1,
        "explanation": "El Root Bridge se determina por el menor Bridge ID (Bridge Priority + MAC Address). Los administradores asignan prioridades más bajas (ej. 4096 o 0) a los switches de core para forzar su elección."
      },
      {
        "id": "q3",
        "question": "¿Cuál es el propósito principal de protocolos como VRRP o HSRP en una infraestructura de red?",
        "options": [
          "Aumentar el tamaño de la MTU a 9000 bytes",
          "Proporcionar una IP de Gateway virtual redundante compartida entre dos o más routers para evitar cortes de conexión si uno falla",
          "Reemplazar el protocolo DNS por resolución local",
          "Asignar dinámicamente etiquetas VLAN 802.1Q"
        ],
        "correctIndex": 1,
        "explanation": "VRRP y HSRP proporcionan alta disponibilidad en el primer salto (FHRP) permitiendo que varios routers físicos compartan una IP/MAC virtual que sirve de puerta de enlace ininterrumpida."
      }
    ]$JSON$,
    12
  );

  -- ==============================================================================
  -- MÓDULO 4: CAPA DE TRANSPORTE AVANZADA, PROTOCOLOS Y ANÁLISIS CON WIRESHARK
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 4: Capa de Transporte Avanzada, Protocolos y Análisis con Wireshark',
    'TCP FSM al detalle, control de flujo por ventana deslizante, QUIC (HTTP/3) sobre UDP y análisis forense de tráfico con tcpdump.'
  )
  RETURNING id INTO v_m4_id;

  -- Lección 4.1: TCP Internals: FSM, Handshake y Protección de Secuencia
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '13. TCP Internals: FSM, Handshake de 3 Vías y SYN Cookies',
    'Disecciona la máquina de estados de TCP, números SEQ/ACK relativos vs absolutos y mitigación de SYN Flood.',
    'quiz',
    100,
    $THEORY$# TCP Internals: La Máquina de Estados Finitos (FSM) y Secuencia

El protocolo **TCP (Transmission Control Protocol - RFC 9293)** proporciona un canal de comunicación bidireccional confiable, ordenado y orientado a la conexión sobre una red IP no confiable.

---

### 1. La Cabecera TCP (20 a 60 bytes)
```text
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                        Sequence Number                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Acknowledgment Number                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Data |           |U|A|P|R|S|F|                               |
| Offset| Reserved  |R|C|S|S|Y|I|            Window             |
| (4 b) |   (3 b)   |G|K|H|T|N|N|                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           Checksum            |         Urgent Pointer        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Options (si Data Offset > 5)               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

- **Sequence Number (32 bits):** Número de secuencia que identifica el byte exacto que este segmento representa en el flujo continuo de datos. Se inicializa mediante un valor pseudoaleatorio criptográfico denominado **ISN (Initial Sequence Number)** para evitar que atacantes inyecten paquetes adivinando números de secuencia (*TCP Sequence Prediction Attacks*).
- **Acknowledgment Number (32 bits):** Si el flag `ACK` está activo, indica **el siguiente byte que el receptor espera recibir**.
- **Control Flags (9 bits):**
  - `SYN` (Synchronize): Establece conexión y sincroniza los ISN.
  - `ACK` (Acknowledgment): Valida el campo Acknowledgment Number.
  - `FIN` (Finish): Solicita el cierre limpio y ordenado de la conexión.
  - `RST` (Reset): Aborta y reinicia abruptamente una conexión no válida.
  - `PSH` (Push): Exige a la pila TCP entregar los datos inmediatamente a la aplicación sin esperar a llenar buffers.
  - `URG` (Urgent): Señala datos prioritarios.

---

### 2. Máquina de Estados Finitos (FSM)

```text
      CLIENTE                                               SERVIDOR
         |                                                     |  (LISTEN)
         |--------- 1. SYN (seq = ISN_C) --------------------->|
 (SYN_SENT)                                                    |  (SYN_RCVD)
         |<-------- 2. SYN-ACK (seq = ISN_S, ack = ISN_C + 1) -|
(ESTABLISHED)                                                  |
         |--------- 3. ACK (ack = ISN_S + 1) ----------------->|
         |                                                     | (ESTABLISHED)
```

#### El Cierre y el Estado TIME_WAIT (2MSL):
El cierre formal se ejecuta con 4 pasos (`FIN` $\rightarrow$ `ACK` $\rightarrow$ `FIN` $\rightarrow$ `ACK`).
Quien inicia el cierre entra en el estado **`TIME_WAIT`** y permanece allí durante **2 veces el MSL (Maximum Segment Lifetime)**, típicamente entre 60 y 120 segundos.
*Propósito:* Asegurar que el último `ACK` llegó con éxito y permitir que cualquier paquete rezagado en la red muera antes de que el mismo puerto pueda reutilizarse.

---

### 3. Ataque SYN Flood y Mitigación con SYN Cookies
En un ataque **SYN Flood**, el atacante envía millones de paquetes `SYN` falsificados desde IPs inexistentes. El servidor responde con `SYN-ACK`, crea una entrada en su tabla de conexiones incompletas (*Backlog Queue*) y pasa a estado `SYN_RCVD` esperando un `ACK` que nunca llegará, agotando la memoria del kernel del servidor.

**La Solución: SYN Cookies (RFC 4987)**
- Cuando la cola de conexiones se satura, el kernel del servidor **deja de almacenar estado en memoria**.
- En su lugar, codifica la información de la conexión (IPs, puertos, MSS y timestamp) dentro del propio número de secuencia inicial `ISN` del `SYN-ACK` mediante una función hash criptográfica con clave secreta.
- Cuando el cliente legítimo responde con el `ACK`, el servidor resta 1 al número de acuse, valida la firma criptográfica del hash y recién en ese instante crea la conexión.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuál es la función del estado TCP 'TIME_WAIT' (típicamente de 2MSL) en el extremo que inició el cierre de la conexión?",
        "options": [
          "Descargar los archivos pendientes desde el servidor DNS",
          "Garantizar que el último ACK llegue al destino y disipar paquetes duplicados residuales en la red",
          "Forzar la renegociación inmediata de certificados SSL",
          "Aumentar el tamaño de la ventana de congestión"
        ],
        "correctIndex": 1,
        "explanation": "El estado TIME_WAIT asegura que si el último ACK se perdió, el emisor pueda responder a una retransmisión del FIN del par, y que ningún paquete errante interfiera con una nueva conexión en el mismo puerto."
      },
      {
        "id": "q2",
        "question": "¿Qué flag de la cabecera TCP se utiliza para abortar inmediatamente una conexión errónea o rechazar una solicitud a un puerto cerrado?",
        "options": ["SYN", "FIN", "RST (Reset)", "URG"],
        "correctIndex": 2,
        "explanation": "El flag RST (Reset) indica una terminación anormal inmediata de la conexión o señala al emisor que el puerto de destino no está escuchando."
      },
      {
        "id": "q3",
        "question": "¿Cómo protege el mecanismo de 'SYN Cookies' a un servidor contra ataques de denegación de servicio SYN Flood?",
        "options": [
          "Bloquea el acceso a todas las direcciones IP de origen",
          "Evita reservar memoria en el kernel codificando los parámetros de la conexión dentro del número de secuencia inicial (ISN)",
          "Obliga a la conexión a migrar al protocolo UDP",
          "Aumenta la memoria RAM del servidor de forma virtual"
        ],
        "correctIndex": 1,
        "explanation": "SYN Cookies elimina la reserva prematura de memoria codificando el estado de la conexión en el propio ISN del SYN-ACK. Solo al recibir el ACK final de un cliente real se reserva el socket en el kernel."
      }
    ]$JSON$,
    13
  );

  -- Lección 4.2: Control de Flujo y Control de Congestión en TCP
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '14. Control de Flujo, Sliding Window y Algoritmos de Congestión',
    'Comprende el control de flujo (rwnd), Window Scale y algoritmos de congestión: Reno, Cubic y BBR.',
    'quiz',
    100,
    $THEORY$# Control de Flujo vs Control de Congestión en TCP

Una de las grandes obras de ingeniería de TCP es su capacidad para transmitir datos a la máxima velocidad posible sin ahogar al receptor ni colapsar la infraestructura de los routers de Internet.

---

### 1. Control de Flujo: La Ventana Deslizante (Sliding Window)
El **Control de Flujo** protege **al receptor final**. Evita que un emisor ultra veloz (ej. servidor con fibra de 10 Gbps) sature el buffer de memoria de un receptor lento (ej. un microcontrolador o teléfono con poca RAM).

- El receptor anuncia continuamente en cada paquete el espacio libre en su buffer mediante el campo **Window Size** (`rwnd` - *Receive Window*).
- El emisor solo tiene permitido enviar una cantidad de bytes sin confirmar igual a `rwnd`.
- **TCP ZeroWindow:** Si el receptor se satura, envía `Window Size = 0`. El emisor se detiene de inmediato e inicia el envío periódico de pequeñas sondas (*Zero Window Probes*) hasta que el receptor vuelva a abrir la ventana.

#### Window Scaling Option (RFC 7323)
El campo original de Window Size en la cabecera TCP tiene solo 16 bits ($2^{16} = 65,535\text{ bytes} \approx 64\text{ KB}$).
En redes modernas de fibra óptica transatlánticas con alto producto de retardo y ancho de banda (**BDP** - *Bandwidth-Delay Product*), 64 KB es un límite ridículo que estrangulaba la velocidad.
La opción **Window Scale** se negocia en el Three-way Handshake y define un multiplicador exponencial de hasta $2^{14} = 16,384$, permitiendo ventanas de hasta **1 Gigabyte**.

---

### 2. Control de Congestión: La Salud de la Red
El **Control de Congestión** protege **a la red intermedia**. Evita que millones de emisores saturen los buffers de los routers de tránsito.
El emisor mantiene una variable interna llamada **Ventana de Congestión (`cwnd`)**.
$$\text{Límite de Transmisión Real} = \min(\text{rwnd}, \text{cwnd})$$

```text
Tamaño cwnd
    ^
    |                       / \ (Pérdida)
    |                      /   \_________ (Congestion Avoidance)
    |             /\      /
    |            /  \____/  
    |      /\   /
    |     /  \_/ (Slow Start)
    +----------------------------------------> Tiempo
```

#### Fases Clásicas (TCP Reno):
1. **Slow Start (Arranque Lento):** Comienza con `cwnd = 10 MSS`. Por cada `ACK` recibido, duplica `cwnd` exponencialmente en cada RTT ($1, 2, 4, 8, 16...$).
2. **ssthresh (Slow Start Threshold):** Al alcanzar este umbral, entra en **Congestion Avoidance**, donde crece de forma lineal y conservadora (+1 MSS por RTT).
3. **Pérdida de Paquetes:** Tradicionalmente, TCP interpretaba la pérdida de un paquete como síntoma de router saturado y recortaba drásticamente su velocidad a la mitad (*Multiplicative Decrease*).

---

### 3. La Revolución: De Loss-Based a Google BBR
- **TCP Cubic:** El algoritmo predeterminado en Linux moderno. Utiliza una función cúbica para acelerar la recuperación de la ventana tras una pérdida.
- **Google BBR (Bottleneck Bandwidth and RTT - RFC 9000 era):**
  Los algoritmos antiguos sufrían el problema del **Bufferbloat** (los routers almacenaban megabytes de datos en buffers antes de descartar paquetes, generando latencias enormes de cientos de milisegundos).
  **BBR no se basa en la pérdida de paquetes.** Modela matemáticamente la red midiendo constantemente el **ancho de banda máximo del cuello de botella** y el **tiempo mínimo de ida y vuelta (min RTT)**, inyectando exactamente la cantidad de datos que el tubo puede admitir, logrando latencias ultra bajas y máxima velocidad.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuál es la diferencia fundamental entre el 'Control de Flujo' y el 'Control de Congestión' en TCP?",
        "options": [
          "El control de flujo protege al receptor de ser saturado; el control de congestión protege a los routers de la red de ser colapsados",
          "El control de flujo usa UDP y el control de congestión usa TCP",
          "El control de flujo cifra los datos y el control de congestión comprime los archivos",
          "No hay diferencia, son nombres sinónimos del mismo algoritmo"
        ],
        "correctIndex": 0,
        "explanation": "El control de flujo ajusta la velocidad según el buffer de recepción del host destino (rwnd); el control de congestión ajusta la velocidad según la capacidad de los enlaces intermedios (cwnd)."
      },
      {
        "id": "q2",
        "question": "¿Qué problema resuelve la opción TCP 'Window Scale' negociada durante el handshake inicial?",
        "options": [
          "Permite superar el límite histórico de 64 KB de ventana para aprovechar enlaces modernos de alto ancho de banda y latencia (BDP)",
          "Elimina la necesidad de utilizar números de puerto en TCP",
          "Obliga a que todos los paquetes viajen con el flag PSH activo",
          "Reduce el tamaño de la cabecera IP a 10 bytes"
        ],
        "correctIndex": 0,
        "explanation": "Window Scale multiplica el campo de ventana por un factor de hasta 2^14, permitiendo ventanas de hasta 1 GB ideales para conexiones de fibra transcontinentales."
      },
      {
        "id": "q3",
        "question": "¿En qué se diferencia el algoritmo de congestión moderno BBR (desarrollado por Google) respecto a TCP Reno o Cubic clásicos?",
        "options": [
          "BBR utiliza solo paquetes broadcast",
          "BBR mide el ancho de banda del cuello de botella y el RTT mínimo en lugar de esperar a que ocurra una pérdida de paquetes para reaccionar",
          "BBR desactiva el mecanismo de retransmisión automática",
          "BBR funciona exclusivamente sobre cables de cobre coaxiales"
        ],
        "correctIndex": 1,
        "explanation": "BBR crea un modelo en tiempo real del enlace midiendo el throughput del cuello de botella y la latencia mínima física, evitando el llenado destructivo de buffers (Bufferbloat)."
      }
    ]$JSON$,
    14
  );

  -- Lección 4.3: UDP, QUIC y la Arquitectura de HTTP/3
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '15. UDP, QUIC y la Revolución de HTTP/3',
    'Descubre por qué la web moderna migró a QUIC sobre UDP: 0-RTT, eliminación del Head-of-Line Blocking y migración de conexión.',
    'quiz',
    100,
    $THEORY$# UDP, Protocolo QUIC y la Arquitectura de HTTP/3

Durante más de 30 años, toda la Web (HTTP/1.1 y HTTP/2) funcionó exclusivamente sobre **TCP**. Sin embargo, a medida que el tráfico móvil y la velocidad de la fibra crecieron, las limitaciones estructurales de TCP en el kernel de los sistemas operativos se convirtieron en el principal cuello de botella de Internet (**TCP Ossification**).

La solución fue radical: **Construir un protocolo de transporte confiable de nueva generación implementado en espacio de usuario sobre UDP: QUIC (RFC 9000)**, la base de **HTTP/3**.

---

### 1. El Problema Mortal de HTTP/2: Head-of-Line (HoL) Blocking en TCP
HTTP/2 introdujo multiplexación: docenas de peticiones web (CSS, JS, imágenes) viajan simultáneamente entrelazadas en una única conexión TCP.
- **El fallo de diseño:** Como TCP ve todo como un único flujo secuencial indivisible, **si se pierde un solo paquete en el cable, TCP detiene la entrega de TODO el flujo** hasta que ese paquete perdido se retransmita.
- Un paquete perdido de una imagen secundaria congelaba la carga del código JavaScript principal.

---

### 2. Cómo QUIC Resuelve las Limitaciones de TCP

```text
PILA TRADICIONAL (HTTP/2)                  PILA MODERNA (HTTP/3)
+-----------------------+                  +-----------------------+
|        HTTP/2         |                  |        HTTP/3         |
+-----------------------+                  +-----------------------+
|       TLS 1.3         |                  |         QUIC          |
+-----------------------+                  |  (Criptografía TLS 1.3|
|         TCP           |                  |   nativa integrada)   |
+-----------------------+                  +-----------------------+
|          IP           |                  |         UDP           |
+-----------------------+                  +-----------------------+
```

1. **Streams Verdaderamente Independientes (Cero HoL Blocking):**
   QUIC multiplexa flujos independientes en el espacio de usuario. Si se pierde un paquete del Stream 3, **únicamente el Stream 3 espera la retransmisión**. Los Streams 1, 2, 4 y 5 siguen entregándose al navegador a máxima velocidad sin detenerse.
2. **Handshake Ultrarrápido 0-RTT / 1-RTT:**
   En TCP + TLS 1.3 tradicional se requerían múltiples viajes de ida y vuelta (*Round Trips*) para negociar TCP y luego negociar TLS. QUIC fusiona el handshake de transporte y el de seguridad criptográfica en **una sola fase (1-RTT)**, e incluso permite enviar datos en el primer paquete (**0-RTT**) si el cliente ya visitó el sitio anteriormente.
3. **Migración de Conexión (Connection Migration):**
   Las conexiones TCP están amarradas a una 4-tupla: `(IP_Orig, Puerto_Orig, IP_Dest, Puerto_Dest)`. Si estás en tu casa con Wi-Fi y sales a la calle cambiando a datos móviles 4G/5G, tu IP cambia, la conexión TCP se rompe y las descargas o llamadas se cortan.
   **QUIC utiliza un Connection ID (CID) de 64 bits.** Aunque tu dirección IP o red física cambien, el Connection ID se mantiene y la sesión web, llamada o streaming continúa sin interrumpirse.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Sobre qué protocolo de Capa 4 de la pila tradicional se ejecuta QUIC (la base de HTTP/3)?",
        "options": ["TCP", "UDP", "SCTP", "ICMP"],
        "correctIndex": 1,
        "explanation": "QUIC se implementa sobre UDP en espacio de usuario para sortear la osificación de los kernels de red y permitir despliegues rápidos de innovaciones de transporte."
      },
      {
        "id": "q2",
        "question": "¿Cómo soluciona QUIC el problema de Head-of-Line Blocking que sufría HTTP/2 sobre TCP?",
        "options": [
          "Aumenta la memoria RAM del switch de enlace",
          "Gestiona streams verdaderamente independientes: la pérdida de un paquete solo detiene a su propio flujo sin congelar a los demás",
          "Prohíbe enviar más de un archivo a la vez",
          "Elimina la verificación de paquetes perdidos"
        ],
        "correctIndex": 1,
        "explanation": "Al manejar los streams de forma independiente en Capa de Transporte, la pérdida de un paquete en un recurso solo retrasa a ese stream particular, permitiendo que todos los demás continúen fluyendo sin interrupción."
      },
      {
        "id": "q3",
        "question": "¿Qué característica de QUIC permite que una videollamada o descarga continúe sin cortarse cuando tu teléfono conmuta de Wi-Fi a datos móviles 4G/5G?",
        "options": [
          "El uso de Connection IDs (CID) independientes de la dirección IP de origen",
          "La duplicación de tramas Ethernet en la Capa 2",
          "El protocolo Spanning Tree en la antena de telefonía",
          "El uso de servidores proxy obligatorios"
        ],
        "correctIndex": 0,
        "explanation": "La Migración de Conexión de QUIC identifica la sesión mediante un Connection ID criptográfico de 64 bits en lugar de la dirección IP, permitiendo cambiar de red sin reiniciar la conexión."
      }
    ]$JSON$,
    15
  );

  -- Lección 4.4: Análisis Forense de Tráfico con Wireshark y tcpdump
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m4_id,
    '16. Análisis Forense con Wireshark y Filtros BPF en tcpdump',
    'Domina la captura en servidores headless con tcpdump, filtros BPF y disección de anomalías en Wireshark.',
    'quiz',
    100,
    $THEORY$# Análisis de Tráfico de Red: tcpdump y Wireshark

Cuando un sistema distribuido o API falla intermitentemente y los logs de la aplicación no revelan el problema, el análisis directo de los paquetes en el cable (**Packet Sniffing**) es la única fuente de verdad incontestable: *"Los paquetes nunca mienten"*.

---

### 1. Captura en Servidores Headless con `tcpdump`
En servidores Linux de producción no hay interfaz gráfica. Se utiliza `tcpdump` para volcar el tráfico en formato estándar `.pcap`.

```bash
# Capturar 1000 paquetes en interfaz eth0 filtrando solo tráfico web y guardar en captura.pcap
tcpdump -i eth0 -nn -s 0 -c 1000 -w captura.pcap "tcp port 80 or tcp port 443"

# Inspeccionar paquetes en tiempo real con cabeceras completas y timestamp exacto
tcpdump -i any -nn -tttt "host 192.168.1.50 and not port 22"
```
- Parámetros clave:
  - `-i eth0`: Especifica la interfaz de red (`any` escucha en todas).
  - `-nn`: Desactiva la resolución DNS y de nombres de puertos para no alterar la latencia de captura.
  - `-s 0`: Captura la trama completa (*snaplen*) sin recortar payloads.
  - `-w file.pcap`: Guarda el volcado binario para analizarlo luego en Wireshark.

#### Filtros BPF (Berkeley Packet Filter)
Se evalúan directamente en el kernel antes de copiar el paquete al espacio de usuario:
- `tcp[tcpflags] & (tcp-syn) != 0`: Captura solo solicitudes de conexión iniciales (SYN).
- `ip proto 1`: Captura únicamente tráfico ICMP.
- `net 10.0.0.0/8 and dst port 53`: Consultas DNS hacia la subred corporativa.

---

### 2. Disección y Filtros de Visualización en Wireshark
En Wireshark existen dos tipos de filtros completamente diferentes:
1. **Capture Filters (BPF):** Limitan qué paquetes se graban en el disco.
2. **Display Filters:** Filtran visualmente sobre un archivo `.pcap` ya capturado.
   - `http.response.status_code >= 500`: Muestra solo errores de servidor HTTP.
   - `tcp.analysis.retransmission`: Muestra segmentos que debieron enviarse de nuevo por pérdida en la red.
   - `tcp.flags.reset == 1`: Muestra conexiones abortadas violentamente con RST.
   - `dns.flags.response == 1 and dns.time > 0.1`: Identifica resoluciones DNS que tardaron más de 100 ms.

---

### 3. Patrones Visuales de Anomalías de Red en Wireshark
- **TCP Dup ACK:** El receptor recibe paquetes fuera de orden y repite el último ACK esperando el paquete faltante. Tres Dup ACKs consecutivos disparan una **Retransmisión Rápida (Fast Retransmit)**.
- **TCP Spurious Retransmission:** El emisor reenvió un paquete porque su temporizador expiró, pero el paquete original no se había perdido, solo estaba demorado por alta latencia.
- **TCP ZeroWindow:** El receptor envía `Win=0`. Indica que el proceso receptor (ej. base de datos o servidor web) está colapsado de CPU y no lee los datos del buffer del kernel.
$THEORY$,
    $JSON$[
      {
        "id": "q1",
        "question": "¿Cuál es la diferencia principal entre un 'Capture Filter' y un 'Display Filter' en Wireshark/tcpdump?",
        "options": [
          "El Capture Filter determina qué paquetes se guardan en el archivo de captura; el Display Filter solo filtra qué paquetes se visualizan en pantalla sobre una captura existente",
          "El Display Filter solo funciona con cables de fibra óptica",
          "El Capture Filter descarta paquetes dañando la conexión de red",
          "No hay diferencia, ambos usan la misma sintaxis exacta"
        ],
        "correctIndex": 0,
        "explanation": "Los filtros de captura (BPF) se aplican en el motor del kernel al momento de grabar paquetes en disco. Los filtros de visualización se aplican a posteriori en la interfaz gráfica para analizar la captura."
      },
      {
        "id": "q2",
        "question": "Al analizar una captura con Wireshark, ¿qué síntoma revela un paquete con la etiqueta 'TCP ZeroWindow' emitido por un servidor?",
        "options": [
          "Que el servidor fue hackeado mediante un ataque de fuerza bruta",
          "Que el buffer de recepción del servidor está saturado y no puede recibir más datos hasta vaciar la memoria",
          "Que la tarjeta de red del servidor se ha desconectado físicamente",
          "Que la conexión se ha cifrado con éxito mediante TLS 1.3"
        ],
        "correctIndex": 1,
        "explanation": "TCP ZeroWindow es una alarma de control de flujo donde el receptor anuncia que su buffer de recepción está completamente lleno (0 bytes libres), obligando al emisor a pausar la transmisión."
      },
      {
        "id": "q3",
        "question": "¿Qué comando de tcpdump permite capturar paquetes en la interfaz eth0 guardándolos en un archivo .pcap sin resolver nombres DNS para maximizar el rendimiento?",
        "options": [
          "tcpdump -i eth0 -nn -w captura.pcap",
          "tcpdump --gui --all-packets file.txt",
          "ping -c 100 eth0 > captura.pcap",
          "traceroute -i eth0 -w captura.pcap"
        ],
        "correctIndex": 0,
        "explanation": "El parámetro -i eth0 selecciona la interfaz, -nn previene la sobrecarga de consultas DNS inversas y -w escribe directamente el volcado crudo en formato pcap."
      }
    ]$JSON$,
    16
  );

  -- ==============================================================================
  -- CERTIFICACIÓN OFICIAL VERIFICABLE: CERT-NET-ADV
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
    'Certificación Profesional en Redes Avanzadas y Protocolos',
    'CERT-NET-ADV',
    'Demuestra dominio profesional en la arquitectura binaria de tramas Ethernet, segmentación L2 con VLANs 802.1Q, fragmentación IP, subnetting VLSM, protocolos dinámicos OSPF/BGP, TCP internals y análisis forense con Wireshark.',
    80,
    25,
    500,
    'cyan',
    ARRAY[
      'Arquitectura de Tramas Ethernet IEEE 802.3',
      'Conmutación L2, Tablas CAM y VLANs 802.1Q',
      'Datagramas IPv4/IPv6 y Cabecera Fija',
      'Fragmentación L3, MTU vs MSS y PMTUD',
      'Subnetting Avanzado, VLSM y CIDR',
      'Enrutamiento Dinámico OSPF & BGP Global',
      'TCP FSM, Sliding Window & Algoritmos de Congestión',
      'Protocolo QUIC / HTTP/3 sobre UDP',
      'Análisis Forense con Wireshark & tcpdump'
    ]
  )
  RETURNING id INTO v_cert_id;

  -- Banco de 15 Preguntas del Examen de Certificación
  INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
  (
    v_cert_id,
    'En una trama Ethernet II estándar, ¿cuántos bytes ocupa la cabecera completa de Capa 2 (excluyendo preámbulo y payload pero incluyendo FCS)?',
    ARRAY['14 bytes', '18 bytes', '20 bytes', '64 bytes'],
    1,
    'La cabecera y cola L2 está compuesta por: 6 bytes (MAC Destino) + 6 bytes (MAC Origen) + 2 bytes (EtherType) + 4 bytes (FCS/CRC-32) = 18 bytes totales.'
  ),
  (
    v_cert_id,
    '¿Qué EtherType específico indica que la trama Ethernet encapsula una etiqueta de VLAN bajo el estándar IEEE 802.1Q?',
    ARRAY['0x0800', '0x0806', '0x8100', '0x86DD'],
    2,
    'El valor 0x8100 identifica la presencia de una cabecera de etiquetado 802.1Q de 4 bytes.'
  ),
  (
    v_cert_id,
    'En un ataque de ARP Spoofing / Poisoning, ¿qué vulnerabilidad fundamental del protocolo ARP es aprovechada por el atacante?',
    ARRAY[
      'La falta de cifrado TLS en las peticiones DNS',
      'La ausencia de mecanismos nativos de autenticación en los mensajes ARP Reply que permite enviar respuestas no solicitadas falsas',
      'El uso exclusivo de fibra óptica monomodo',
      'El agotamiento del campo TTL en la cabecera IP'
    ],
    1,
    'El protocolo ARP no valida ni autentica el emisor de los paquetes ARP Reply, permitiendo a cualquier host anunciar asignaciones IP-MAC falsificadas.'
  ),
  (
    v_cert_id,
    '¿Cuál es la función del temporizador de envejecimiento (Aging Timer) en la tabla CAM de un switch de Capa 2?',
    ARRAY[
      'Eliminar las entradas de direcciones MAC que no han transmitido tráfico durante un período para no agotar la memoria',
      'Apagar el switch en caso de alta temperatura',
      'Reiniciar el número de secuencia TCP de las conexiones',
      'Modificar la dirección IP del router cada 5 minutos'
    ],
    0,
    'El Aging Timer (típicamente 300 segundos) borra automáticamente las direcciones MAC inactivas de la tabla CAM para liberar espacio en memoria.'
  ),
  (
    v_cert_id,
    'Si un paquete IPv4 viaja con el flag DF=0 (fragmentación permitida / bandera DF desactivada) y supera el MTU de un enlace, ¿qué campo de la cabecera se utiliza para reordenar los fragmentos en bloques de 8 bytes?',
    ARRAY['Identification', 'Fragment Offset', 'Header Checksum', 'Time to Live'],
    1,
    'El campo Fragment Offset especifica la posición relativa de los datos del fragmento en múltiplos de 8 octetos.'
  ),
  (
    v_cert_id,
    'En una subred IPv4 con prefijo /29, ¿cuántas direcciones IP utilizables para hosts están disponibles tras descontar red y broadcast?',
    ARRAY['30', '14', '6', '2'],
    2,
    'Un prefijo /29 deja 3 bits para hosts (32 - 29 = 3). 2^3 = 8 direcciones totales. Menos red y broadcast: 8 - 2 = 6 direcciones útiles.'
  ),
  (
    v_cert_id,
    '¿Cuál de las siguientes es una mejora de diseño directa introducida en la cabecera base de IPv6 para agilizar la conmutación en hardware?',
    ARRAY[
      'Cabecera fija inmutable de 40 bytes y eliminación del Header Checksum en Capa 3',
      'Aumento del campo TTL a 32 bits',
      'Incorporación de broadcasts ilimitados para toda la subred',
      'Uso obligatorio de direcciones MAC de 128 bits'
    ],
    0,
    'IPv6 posee una longitud fija de 40 bytes y eliminó el Checksum en L3, permitiendo que los circuitos de los routers procesen paquetes a velocidad de silicio sin recalcular sumas.'
  ),
  (
    v_cert_id,
    'De acuerdo con la regla de Longest Prefix Match (LPM), si un router dispone de rutas para 10.0.0.0/8, 10.20.0.0/16 y 10.20.30.0/24, ¿cuál utilizará para un paquete hacia 10.20.30.5?',
    ARRAY['10.0.0.0/8', '10.20.0.0/16', '10.20.30.0/24', 'Descartará el paquete por empate'],
    2,
    'La regla Longest Prefix Match prioriza siempre la coincidencia con la máscara más larga y específica, en este caso /24.'
  ),
  (
    v_cert_id,
    '¿Qué métrica de costo utiliza OSPF para preferir una ruta frente a otra en su algoritmo Shortest Path First?',
    ARRAY[
      'La cantidad total de saltos de routers en el camino',
      'El costo acumulado calculado a partir del ancho de banda (bandwidth) de las interfaces',
      'El número de puerto de destino TCP',
      'El conteo de colisiones registradas en la tabla CAM'
    ],
    1,
    'OSPF calcula el costo en base al ancho de banda de los enlaces mediante una fórmula de referencia (ej. 100 Mbps / Bandwidth).'
  ),
  (
    v_cert_id,
    'En el protocolo BGP, ¿qué atributo obligatorio contiene la lista de Sistemas Autónomos atravesados por un prefijo para prevenir bucles?',
    ARRAY['Next-Hop', 'AS-Path', 'Local Preference', 'MED (Multi-Exit Discriminator)'],
    1,
    'El atributo AS-Path registra cada ASN transitado; si un router detecta su propio ASN en la lista, rechaza el anuncio evitando bucles intercontinentales.'
  ),
  (
    v_cert_id,
    '¿Qué rol cumple el protocolo Spanning Tree (STP IEEE 802.1D / RSTP 802.1w) en una red con enlaces físicos redundantes entre switches?',
    ARRAY[
      'Acelerar la velocidad de descarga mediante compresión L2',
      'Bloquear lógicamente puertos redundantes para evitar tormentas de broadcast y bucles de conmutación infinitos',
      'Asignar direcciones IP a través de DHCP',
      'Cifrar todo el tráfico de la red con algoritmo RSA'
    ],
    1,
    'STP calcula una topología libre de bucles en árbol, deshabilitando lógicamente enlaces redundantes que solo se activan si cae el camino principal.'
  ),
  (
    v_cert_id,
    '¿Qué problema mitiga la tecnología SYN Cookies en un servidor web bajo un ataque de denegación de servicio SYN Flood?',
    ARRAY[
      'Evita el agotamiento de la memoria del kernel codificando el estado de la conexión en el propio número de secuencia inicial (ISN)',
      'Aumenta el ancho de banda del proveedor de Internet',
      'Convierte el tráfico TCP a protocolo UDP automáticamente',
      'Bloquea permanentemente los puertos 80 y 443'
    ],
    0,
    'SYN Cookies evita crear estructuras en la cola de backlog del kernel, codificando los parámetros criptográficamente en el ISN del SYN-ACK.'
  ),
  (
    v_cert_id,
    '¿Cuál es la función del parámetro TCP Window Scale negociado durante el establecimiento de la conexión?',
    ARRAY[
      'Cambiar el tamaño de MTU a 1500 bytes',
      'Permitir multiplicar la ventana de recepción hasta valores de 1 GB, superando el límite original de 64 KB en redes de alto producto ancho de banda-retardo (BDP)',
      'Forzar la retransmisión de todos los paquetes pares',
      'Reducir el tamaño de las cabeceras TCP a 8 bytes'
    ],
    1,
    'Window Scale permite escalar el campo Window Size de 16 bits mediante un factor exponencial para saturar eficientemente enlaces de fibra de alta velocidad.'
  ),
  (
    v_cert_id,
    '¿Por qué QUIC (HTTP/3) sobre UDP elimina por completo el bloqueo de cabeza de línea (Head-of-Line Blocking) presente en HTTP/2 sobre TCP?',
    ARRAY[
      'Porque QUIC no valida si los paquetes llegan al destino',
      'Porque gestiona flujos independientes en espacio de usuario, de modo que la pérdida de un paquete en un flujo no paraliza a los demás',
      'Porque utiliza exclusivamente direcciones IPv6 sin fragmentación',
      'Porque duplica cada paquete enviado por dos interfaces a la vez'
    ],
    1,
    'En QUIC los streams son independientes; si un paquete de un stream se pierde, solo ese stream espera su recuperación, mientras el resto sigue entregándose.'
  ),
  (
    v_cert_id,
    'Al depurar un problema de rendimiento con Wireshark, ¿qué indica la presencia reiterada de paquetes marcados como "TCP Dup ACK"?',
    ARRAY[
      'Que el servidor ha cerrado limpiamente la sesión con un mensaje FIN',
      'Que el receptor está recibiendo paquetes fuera de orden o que un paquete se ha perdido en el tránsito, solicitando al emisor su retransmisión rápida',
      'Que la red opera al 100% de eficiencia sin anomalías',
      'Que el cable Ethernet se encuentra desconectado'
    ],
    1,
    'Los Dup ACKs son emitidos por el receptor cuando detecta un hueco en los números de secuencia recibidos, alertando sobre paquetes perdidos o desordenados para activar Fast Retransmit.'
  );

END $NET_SEED$;
