-- 13_curso_redes_quiz.sql
-- Curso Completo: Fundamentos de Redes y Telecomunicaciones
-- 3 Módulos de 4 lecciones cada uno (12 lecciones con teoría profunda y cuestionarios pedagógicos)

DO $$
DECLARE
    v_course_id UUID;
    v_m1_id UUID;
    v_m2_id UUID;
    v_m3_id UUID;
BEGIN
    -- 0. Limpiar versión previa si existiera
    DELETE FROM courses WHERE title = 'Fundamentos de Redes y Telecomunicaciones';

    -- 1. Crear el Curso Oficial de Redes
    INSERT INTO courses (title, description, image_url, tags)
    VALUES (
        'Fundamentos de Redes y Telecomunicaciones',
        'Domina la infraestructura fundamental de Internet. Aprende topologías, hardware de red, el modelo OSI, subnetting IPv4/IPv6, protocolos TCP/UDP, DNS, DHCP y arquitectura de telecomunicaciones.',
        '/images/courses/redes.jpg',
        ARRAY['Teórico', 'Redes', 'Infraestructura', 'Telecomunicaciones']
    )
    RETURNING id INTO v_course_id;

    -- ==============================================================================
    -- 2. MÓDULO 1: ARQUITECTURA, TOPOLOGÍAS Y HARDWARE DE RED
    -- ==============================================================================
    INSERT INTO modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 1: Arquitectura, Topologías y Hardware de Red',
        'Fundamentos físicos, clasificación geográfica, topologías de red y dispositivos de interconexión.'
    )
    RETURNING id INTO v_m1_id;

    -- Lección 1.1: Clasificación de Redes por Alcance Geográfico
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        '1. Clasificación de Redes por Alcance Geográfico',
        'Aprende a diferenciar PAN, LAN, MAN, WAN y WLAN según su cobertura geográfica.',
        'quiz',
        100,
        '# Clasificación de Redes por Extensión Geográfica

Una **red de telecomunicaciones** es un sistema interconectado de dispositivos que comparten datos y recursos mediante enlaces guiados o inalámbricos. Según su radio de cobertura, se clasifican en:

### 1. PAN (Personal Area Network)
- **Alcance**: 1 a 10 metros.
- **Uso típico**: Comunicación entre dispositivos personales (auriculares Bluetooth, reloj inteligente con el smartphone, periféricos).
- **Estándares**: Bluetooth (IEEE 802.15.1), Zigbee.

### 2. LAN (Local Area Network) y WLAN (Wireless LAN)
- **Alcance**: Desde una habitación hasta un edificio completo (hasta unos pocos kilómetros dentro de un campus o empresa).
- **Uso típico**: Redes de hogares, oficinas y universidades. Permiten altísimas tasas de transferencia (1 Gbps a 10 Gbps) y baja latencia.
- **Estándares**: Ethernet cableado (IEEE 802.3) y Wi-Fi (IEEE 802.11).

### 3. MAN (Metropolitan Area Network)
- **Alcance**: Abarca una ciudad o municipio completo (10 a 50 km).
- **Uso típico**: Redes troncales de fibra óptica de proveedores de telecomunicaciones (ISP), red de cámaras de seguridad urbana o televisión por cable.

### 4. WAN (Wide Area Network)
- **Alcance**: Regional, continental o global (miles de kilómetros).
- **Uso típico**: Conectar sucursales bancarias en distintos países o la propia **Internet** (la red WAN pública más grande del mundo). Utiliza cables submarinos, satélites y enlaces de microondas de largo alcance.',
        '[{"id":"q1","question":"¿Qué tipo de red representa Internet en su totalidad?","options":["LAN (Local Area Network)","MAN (Metropolitan Area Network)","WAN (Wide Area Network)","PAN (Personal Area Network)"],"correctIndex":2,"explanation":"Internet es una red WAN (Wide Area Network) global formada por la interconexión de miles de redes autónomas a escala mundial."},{"id":"q2","question":"La red Wi-Fi de tu casa o empresa que conecta computadoras y teléfonos en un mismo edificio es un ejemplo de:","options":["WLAN / LAN","MAN","WAN","SAN"],"correctIndex":0,"explanation":"Una red Wi-Fi residencial u corporativa dentro de un mismo espacio físico es una WLAN (Wireless Local Area Network)."},{"id":"q3","question":"¿Cuál de las siguientes redes tiene el menor alcance físico?","options":["MAN","WAN","LAN","PAN"],"correctIndex":3,"explanation":"La PAN (Personal Area Network) tiene el alcance más corto (generalmente menos de 10 metros, como enlaces Bluetooth)."}]',
        1
    );

    -- Lección 1.2: Topologías de Red Físicas y Lógicas
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        '2. Topologías Físicas y Lógicas',
        'Analiza cómo se disponen los nodos en Bus, Estrella, Anillo y Malla, y su tolerancia a fallos.',
        'quiz',
        100,
        '# Topologías de Red: Físicas y Lógicas

La **topología física** define la disposición geométrica real de los cables y dispositivos, mientras que la **topología lógica** describe el camino que siguen los datos para viajar entre los nodos.

### 1. Topología en Estrella (Star)
- **Estructura**: Cada dispositivo final (host) se conecta mediante un enlace punto a punto dedicado hacia un dispositivo central (Switch o Hub).
- **Ventajas**: Si un cable individual se corta, solo ese nodo se desconecta; el resto de la red sigue operativa. Es la topología estándar de las LANs Ethernet modernas.
- **Desventaja**: Si el nodo central falla, toda la red se cae (punto único de fallo).

### 2. Topología en Bus
- **Estructura**: Todos los nodos comparten un único cable troncal común (backbone) con terminadores en los extremos.
- **Desventajas**: Si el cable troncal se corta en cualquier punto, toda la red deja de funcionar. Alto nivel de colisiones. Prácticamente obsoleta.

### 3. Topología en Anillo (Ring)
- **Estructura**: Cada nodo está conectado exactamente a dos vecinos, formando un bucle cerrado. La información viaja en una única dirección mediante un "token" (Token Ring).
- **Desventajas**: Si un nodo intermedio se apaga o falla, el anillo se rompe a menos que se use un doble anillo redundante (como FDDI).

### 4. Topología en Malla (Mesh)
- **Estructura**: Cada nodo tiene enlaces dedicados directos hacia todos los demás nodos (Malla Completa) o hacia múltiples nodos estratégicos (Malla Parcial).
- **Ventajas**: Máxima redundancia y tolerancia a fallos. Si una ruta se corta, el tráfico se redirige por otra alternativa.
- **Uso**: El núcleo (Core) de Internet y centros de datos críticos.',
        '[{"id":"q1","question":"En las redes Ethernet modernas de oficinas y hogares, ¿cuál es la topología física más utilizada?","options":["Anillo","Bus","Estrella","Malla Completa"],"correctIndex":2,"explanation":"La topología en estrella mediante cables UTP conectados a un Switch central es la estructura estándar de las redes LAN Ethernet actuales."},{"id":"q2","question":"¿Qué topología ofrece la máxima tolerancia a fallos y redundancia de rutas?","options":["Malla (Mesh)","Bus","Estrella simple","Anillo simple"],"correctIndex":0,"explanation":"La topología en malla conecta múltiples nodos entre sí creando rutas alternativas ante la caída de cualquier enlace."},{"id":"q3","question":"¿Cuál es el principal inconveniente de la topología en Bus tradicional?","options":["Requiere demasiados switches","Un corte en el cable troncal desconecta a toda la red","No soporta direcciones IP","Es demasiado costosa de instalar"],"correctIndex":1,"explanation":"En una topología en bus, el cable troncal es compartido; si se corta o falta un terminador, la señal rebota y toda la red queda inoperativa."}]',
        2
    );

    -- Lección 1.3: Dispositivos de Capa de Red: Hubs, Switches y Routers
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        '3. Dispositivos de Interconexión: Hubs, Switches y Routers',
        'Diferencia entre Hubs (Capa 1), Switches (Capa 2) y Routers (Capa 3), y sus dominios de colisión y broadcast.',
        'quiz',
        100,
        '# Dispositivos de Interconexión de Red

Para interconectar dispositivos se utilizan equipos con diferentes niveles de inteligencia y capacidades de procesamiento:

### 1. Hub (Concentrador - Capa 1 Física)
- **Funcionamiento**: Dispositivo no inteligente. Cuando recibe una señal eléctrica en un puerto, la repite por **todos** los demás puertos (inundación o broadcast físico).
- **Problema**: Todos los puertos pertenecen al **mismo dominio de colisión**, lo que genera saturación de tráfico y riesgos de seguridad. Obsoleto hoy en día.

### 2. Switch (Conmutador - Capa 2 Enlace de Datos)
- **Funcionamiento**: Dispositivo inteligente. Inspecciona las **direcciones MAC de origen** de las tramas para aprender en qué puerto físico está conectado cada host, construyendo la **Tabla CAM (MAC Address Table)**.
- **Ventaja**: Reenvía los datos únicamente al puerto de destino correspondiente (Unicast).
- **Segmentación**: Cada puerto de un Switch es un **dominio de colisión independiente**, pero todos sus puertos pertenecen al **mismo dominio de broadcast**.

### 3. Router (Enrutador - Capa 3 Red)
- **Funcionamiento**: Trabaja con **direcciones IP lógicas**. Determina la mejor ruta entre diferentes redes (inter-networking) usando tablas de enrutamiento.
- **Segmentación**: Los routers **separan y detienen los dominios de broadcast**. Un mensaje de broadcast emitido en una LAN no pasará a otra LAN a través del router.',
        '[{"id":"q1","question":"¿Cómo decide un Switch estándar de Capa 2 hacia qué puerto enviar una trama Ethernet?","options":["Consultando el servidor DNS","Consultando su tabla de direcciones MAC (Tabla CAM)","Enviándola siempre a todos los puertos a la vez","Leyendo la dirección IP de destino"],"correctIndex":1,"explanation":"El Switch consulta su tabla CAM interna donde almacena la relación entre direcciones físicas MAC aprendidas y sus puertos correspondientes."},{"id":"q2","question":"¿Qué dispositivo se encarga de segmentar y delimitar los dominios de broadcast en una red?","options":["Hub","Switch no gestionable","Repetidor","Router"],"correctIndex":3,"explanation":"Los Routers operan en Capa 3 y no reenvían paquetes de broadcast de una red a otra, limitando así el dominio de broadcast."},{"id":"q3","question":"¿Cuál es la principal desventaja de un Hub frente a un Switch?","options":["El Hub crea un único dominio de colisión compartido entre todos los puertos","El Hub no admite cables de red","El Hub es más caro que un Switch","El Hub requiere configurar direcciones IP"],"correctIndex":0,"explanation":"El Hub repite cada señal por todos los puertos sin filtrar, haciendo que todos los hosts compitan por el mismo medio (un solo dominio de colisión)."}]',
        3
    );

    -- Lección 1.4: Medios de Transmisión: Cobre, Fibra Óptica e Inalámbrico
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        '4. Medios de Transmisión: UTP, Fibra Óptica y Wi-Fi',
        'Comprende las características del cable UTP/STP, Fibra Monomodo/Multimodo y el espectro inalámbrico.',
        'quiz',
        100,
        '# Medios de Transmisión en Telecomunicaciones

Los medios transportan las señales entre los nodos emisores y receptores. Se dividen en **guiados** (físicos) y **no guiados** (inalámbricos).

### 1. Par Trenzado de Cobre (UTP / STP)
- **Estructura**: 4 pares de hilos de cobre trenzados entre sí para cancelar interferencias electromagnéticas y diafonía (crosstalk).
- **Categorías**: Cat5e (hasta 1 Gbps a 100m), Cat6 (hasta 10 Gbps a 55m), Cat6A (10 Gbps a 100m).
- **Conector estándar**: RJ-45 (normas de ponchado T568A y T568B).
- **Límite de distancia**: Máximo **100 metros** por segmento de cable sin repetidor.

### 2. Fibra Óptica
- **Funcionamiento**: Transmite pulsos de luz modulados a través de un núcleo de vidrio o plástico usando el principio de reflexión interna total. Inmune a interferencias electromagnéticas (EMI).
- **Monomodo (SMF - Single Mode)**: Núcleo muy fino (~9 µm). Utiliza láser. Permite distancias de hasta decenas de kilómetros (enlaces troncales, ISPs).
- **Multimodo (MMF - Multi Mode)**: Núcleo más grueso (~50-62.5 µm). Utiliza LEDs. Para distancias más cortas (hasta 500 metros en centros de datos).

### 3. Medios Inalámbricos (Wi-Fi / Radiofrecuencia)
- **Frecuencias**: 2.4 GHz (mayor alcance y penetración, menor velocidad, más saturada) y 5 GHz / 6 GHz (mayor ancho de banda y velocidad, menor alcance y menor penetración en paredes).',
        '[{"id":"q1","question":"¿Cuál es la distancia máxima recomendada para un tendido de cable Ethernet de par trenzado (UTP) sin repetidores?","options":["50 metros","100 metros","500 metros","1000 metros"],"correctIndex":1,"explanation":"El estándar TIA/EIA establece que el límite máximo de longitud para cable UTP de cobre (incluyendo patch cords) es de 100 metros."},{"id":"q2","question":"¿Por qué la fibra óptica Monomodo es la preferida para enlaces de larga distancia (varios kilómetros)?","options":["Porque utiliza un núcleo diminuto con haz láser que reduce al mínimo la dispersión modal","Porque es de cobre de alta pureza","Porque transmite electricidad sin calentarse","Porque es más flexible que el cable UTP"],"correctIndex":0,"explanation":"La fibra monomodo permite que la luz viaje en un único haz recto, eliminando la dispersión modal y permitiendo distancias de decenas de kilómetros."},{"id":"q3","question":"¿Cuál es la principal ventaja de la banda de 2.4 GHz en Wi-Fi frente a la de 5 GHz?","options":["Mayor velocidad máxima de transferencia","Menor susceptibilidad a interferencias de microondas","Mayor alcance y mejor penetración a través de paredes y obstáculos","Mayor cantidad de canales no solapados"],"correctIndex":2,"explanation":"Las ondas de 2.4 GHz tienen mayor longitud de onda, lo que les permite atravesar mejor obstáculos sólidos y alcanzar mayores distancias que las de 5 GHz."}]',
        4
    );

    -- ==============================================================================
    -- 3. MÓDULO 2: EL MODELO OSI Y ENCAPSULAMIENTO DE DATOS
    -- ==============================================================================
    INSERT INTO modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 2: El Modelo OSI y Encapsulamiento de Datos',
        'Estudio exhaustivo de las 7 capas del modelo OSI, PDUs, direcciones MAC vs IP y conmutación Ethernet.'
    )
    RETURNING id INTO v_m2_id;

    -- Lección 2.1: Las Capas Inferiores del Modelo OSI (Capas 1, 2 y 3)
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m2_id,
        '1. Capas Inferiores: Física, Enlace de Datos y Red',
        'Estudia en profundidad las funciones de las Capas 1, 2 y 3 del modelo de referencia OSI.',
        'quiz',
        100,
        '# El Modelo OSI: Capas 1, 2 y 3

El modelo **OSI (Open Systems Interconnection)** es el marco teórico de 7 capas creado por la ISO para estandarizar la comunicación en redes.

### Capa 1: Capa Física
- **PDU (Protocol Data Unit)**: Bits (ceros y unos).
- **Función**: Conversión de datos en señales eléctricas, ópticas o de radio. Define especificaciones mecánicas y eléctricas (voltajes, conectores, frecuencias).
- **Equipos**: Cables, conectores RJ-45, repetidores, transceivers.

### Capa 2: Capa de Enlace de Datos (Data Link)
- **PDU**: Trama (**Frame**).
- **Función**: Transferencia confiable de datos entre dos nodos conectados al mismo medio físico. Detección y corrección de errores de capa física, control de flujo y direccionamiento físico (**Dirección MAC de 48 bits**, ej: `00:1A:2B:3C:4D:5E`).
- **Subcapas**: **LLC** (Logical Link Control - 802.2) y **MAC** (Media Access Control - 802.3).
- **Equipos**: Switches, tarjetas de red (NIC), Access Points.

### Capa 3: Capa de Red (Network)
- **PDU**: Paquete (**Packet**).
- **Función**: Direccionamiento lógico jerárquico (**Direcciones IPv4 / IPv6**) y determinación de la mejor ruta a través de redes interconectadas (**Enrutamiento**).
- **Protocolos**: IP (IPv4/IPv6), ICMP, ARP, OSPF, BGP.
- **Equipos**: Routers, Switches de Capa 3 (Multicapa).',
        '[{"id":"q1","question":"¿Cuál es la Unidad de Datos de Protocolo (PDU) correspondiente a la Capa 2 (Enlace de Datos)?","options":["Paquete (Packet)","Trama (Frame)","Segmento (Segment)","Bit"],"correctIndex":1,"explanation":"En la Capa 2 la PDU se denomina Trama (Frame), la cual contiene la cabecera con direcciones MAC de origen y destino y el campo FCS para detección de errores."},{"id":"q2","question":"¿En qué capa del modelo OSI opera el protocolo IP y se realiza el enrutamiento de paquetes?","options":["Capa 1 (Física)","Capa 2 (Enlace)","Capa 3 (Red)","Capa 4 (Transporte)"],"correctIndex":2,"explanation":"La Capa 3 (Red) es responsable del direccionamiento IP y del enrutamiento de paquetes entre diferentes redes."},{"id":"q3","question":"¿Qué tipo de dirección tiene 48 bits (6 pares hexadecimales) grabada en el hardware de la tarjeta de red?","options":["Dirección IPv4","Dirección IPv6","Dirección MAC","Puerto TCP"],"correctIndex":2,"explanation":"La dirección MAC (Media Access Control) es un identificador físico de 48 bits asignado por el fabricante de la tarjeta de red."}]',
        1
    );

    -- Lección 2.2: Las Capas Superiores del Modelo OSI (Capas 4, 5, 6 y 7)
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m2_id,
        '2. Capas Superiores: Transporte, Sesión, Presentación y Aplicación',
        'Analiza las responsabilidades de la entrega extremo a extremo, formateo y servicios al usuario.',
        'quiz',
        100,
        '# El Modelo OSI: Capas 4, 5, 6 y 7

Las capas superiores se concentran en la entrega de extremo a extremo entre aplicaciones y la experiencia del usuario final.

### Capa 4: Capa de Transporte
- **PDU**: Segmento (**Segment**) en TCP o Datagrama en UDP.
- **Función**: Segmentación y reensamblado de datos. Provee comunicación de proceso a proceso usando **Números de Puerto** (0 a 65535).
- **Protocolos principales**: **TCP** (orientado a conexión, confiable) y **UDP** (no orientado a conexión, veloz).

### Capa 5: Capa de Sesión
- **Función**: Establece, administra, sincroniza y termina las sesiones de diálogo entre aplicaciones en hosts remotos (control de diálogos dúplex/semi-dúplex, puntos de control).
- **Protocolos**: NetBIOS, RPC, sockets de sesión.

### Capa 6: Capa de Presentación
- **Función**: Actúa como el traductor de la red. Garantiza que la información enviada por la capa de aplicación de un host sea legible por el receptor.
- **Tareas clave**: **Traducción de formatos** (ASCII, UTF-8), **Cifrado/Descifrado** (TLS/SSL) y **Compresión de datos** (JPEG, GZIP).

### Capa 7: Capa de Aplicación
- **Función**: Es la interfaz directa con los programas y usuarios finales. Proporciona servicios de red a las aplicaciones.
- **Protocolos**: HTTP, HTTPS, FTP, SSH, DNS, DHCP, SMTP.',
        '[{"id":"q1","question":"¿En qué capa del modelo OSI se realiza el cifrado y descifrado de datos con TLS/SSL?","options":["Capa de Sesión","Capa de Presentación","Capa de Red","Capa Física"],"correctIndex":1,"explanation":"La Capa 6 (Presentación) es responsable de la sintaxis y semántica de los datos, lo que incluye tareas de cifrado (TLS/SSL) y compresión."},{"id":"q2","question":"Los números de puerto (como el puerto 80 para HTTP o 443 para HTTPS) pertenecen a:","options":["Capa 2 (Enlace)","Capa 3 (Red)","Capa 4 (Transporte)","Capa 1 (Física)"],"correctIndex":2,"explanation":"La Capa 4 (Transporte) utiliza números de puerto para identificar los procesos o aplicaciones de origen y destino en un host."},{"id":"q3","question":"¿Cuál de los siguientes protocolos pertenece a la Capa 7 (Aplicación)?","options":["IPv4","Ethernet","HTTPS","TCP"],"correctIndex":2,"explanation":"HTTPS es un protocolo de nivel de aplicación (Capa 7) utilizado para la transferencia segura de páginas web."}]',
        2
    );

    -- Lección 2.3: Encapsulamiento y Desencapsulamiento de Datos
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m2_id,
        '3. Encapsulamiento y Desencapsulamiento de Datos',
        'Comprende el viaje de los datos a través del stack de protocolos y cómo se agregan cabeceras.',
        'quiz',
        100,
        '# El Proceso de Encapsulamiento

Cuando un usuario envía un mensaje (por ejemplo, escribe un mensaje en WhatsApp o abre una página web), los datos viajan hacia abajo en la pila de protocolos sufriendo el proceso de **Encapsulamiento**.

### Flujo de Encapsulamiento (Emisor):
1. **Datos de Aplicación**: El navegador genera los datos HTTP (`GET /index.html`).
2. **Capa 4 (Transporte)**: Agrega una cabecera de transporte (**Header TCP**) con los puertos origen y destino. Se forma el **Segmento**.
3. **Capa 3 (Red)**: Agrega la cabecera IP (**Header IP**) con la IP origen y destino. Se forma el **Paquete**.
4. **Capa 2 (Enlace)**: Agrega la cabecera Ethernet (**Header MAC**) y un trailer (**FCS / CRC**) para verificación de integridad. Se forma la **Trama (Frame)**.
5. **Capa 1 (Física)**: La trama se codifica y se transmite como una secuencia de **Bits** eléctricos u ópticos por el cable.

### Flujo de Desencapsulamiento (Receptor):
Al llegar al destino, el proceso ocurre en orden inverso: la NIC valida la trama y remueve la cabecera Ethernet, el sistema operativo remueve la cabecera IP, luego valida el puerto TCP y finalmente entrega los datos puros a la aplicación receptora.',
        '[{"id":"q1","question":"¿En qué orden se agregan las cabeceras durante el encapsulamiento de datos al transmitir?","options":["Física -> Enlace -> Red -> Transporte","Transporte (Puertos) -> Red (IP) -> Enlace (MAC)","Red -> Transporte -> Enlace -> Física","Enlace -> Transporte -> Red -> Aplicación"],"correctIndex":1,"explanation":"Los datos bajan por la pila: primero la Capa 4 añade cabecera de Transporte, luego la Capa 3 añade cabecera IP, y finalmente la Capa 2 añade cabecera MAC y trailer FCS."},{"id":"q2","question":"¿Qué información crucial añade la Capa 3 al encapsular un paquete?","options":["Direcciones IP de origen y destino","Direcciones MAC de la tarjeta de red","El código HTML de la página web","El voltaje del cable UTP"],"correctIndex":0,"explanation":"La Capa de Red (IP) adjunta las direcciones lógicas IP de origen y destino necesarias para el enrutamiento."},{"id":"q3","question":"¿Qué componente en la trama de Capa 2 permite al receptor verificar si los datos sufrieron errores o corrupción en el cable?","options":["El preámbulo","El FCS (Frame Check Sequence / CRC)","El puerto TCP","La dirección IP"],"correctIndex":1,"explanation":"El FCS (Frame Check Sequence) al final de la trama contiene un valor matemático CRC para verificar si los bits sufrieron alteraciones durante el viaje físico."}]',
        3
    );

    -- Lección 2.4: Ethernet y Control de Acceso al Medio (CSMA/CD, CSMA/CA y VLANs)
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m2_id,
        '4. Conmutación Ethernet, CSMA/CD y VLANs',
        'Aprende sobre el protocolo Ethernet (IEEE 802.3), prevención de colisiones y segmentación lógica con VLANs.',
        'quiz',
        100,
        '# Ethernet y Tecnologías de Capa 2

**Ethernet (IEEE 802.3)** es la tecnología de red local cableada más extendida en el mundo.

### Control de Acceso al Medio:
- **CSMA/CD (Carrier Sense Multiple Access with Collision Detection)**: Utilizado en redes Ethernet antiguas compartidas (Half-Duplex). Los dispositivos "escuchan" el cable antes de transmitir. Si dos transmiten a la vez (colisión), se detienen, esperan un tiempo aleatorio y retransmiten.
- **Full-Duplex en Switches modernos**: En redes Ethernet con switches actuales, la transmisión y recepción ocurren en pares de cables separados simultáneamente, eliminando las colisiones por completo.
- **CSMA/CA (Collision Avoidance)**: Utilizado en redes inalámbricas Wi-Fi (IEEE 802.11). Dado que no se pueden detectar colisiones en el aire, los hosts piden permiso para transmitir mediante tramas de control RTS/CTS.

### VLANs (Virtual Local Area Networks - IEEE 802.1Q)
- **Definición**: Segmentación lógica de una red física en múltiples redes de difusión separadas dentro de uno o varios switches.
- **Ventajas**:
  - **Seguridad**: Los usuarios de la VLAN de Recursos Humanos no pueden ver el tráfico de la VLAN de Invitados.
  - **Rendimiento**: Reduce el tamaño de los dominios de broadcast.
- **Trunking (Troncal)**: Enlace que transporta el tráfico de múltiples VLANs entre switches mediante una etiqueta (**VLAN Tag** de 802.1Q).',
        '[{"id":"q1","question":"¿Cuál es el principal beneficio de configurar VLANs en un Switch administrable?","options":["Aumentar la velocidad del procesador del switch","Segmentar lógicamente la red para aislar el tráfico de broadcast y mejorar la seguridad","Eliminar la necesidad de tener direcciones IP","Convertir cables de cobre en fibra óptica automáticamente"],"correctIndex":1,"explanation":"Las VLANs dividen un switch físico en múltiples redes lógicas independientes, separando el tráfico por departamentos y reduciendo el broadcast."},{"id":"q2","question":"¿Qué estándar y mecanismo utiliza Wi-Fi para gestionar el acceso al medio compartido?","options":["CSMA/CD (Detección de Colisiones)","CSMA/CA (Evitación de Colisiones - IEEE 802.11)","Token Passing de anillo","Transmisión continua sin control"],"correctIndex":1,"explanation":"Las redes Wi-Fi utilizan CSMA/CA (Carrier Sense Multiple Access with Collision Avoidance) porque no es posible detectar colisiones en el espectro inalámbrico."},{"id":"q3","question":"¿Qué protocolo estándar se utiliza para etiquetar tramas en enlaces troncales (trunk) que transportan múltiples VLANs?","options":["IEEE 802.1Q","IEEE 802.11ax","RIP v2","HTTP 2.0"],"correctIndex":0,"explanation":"El estándar IEEE 802.1Q inserta una etiqueta de 4 bytes en la cabecera Ethernet que indica el VLAN ID al que pertenece la trama."}]',
        4
    );

    -- ==============================================================================
    -- 4. MÓDULO 3: PROTOCOLOS TCP/IP, SUBREDES Y SERVICIOS DE RED
    -- ==============================================================================
    INSERT INTO modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Módulo 3: Protocolos TCP/IP, Subredes y Servicios de Red',
        'Direccionamiento IPv4/IPv6, cálculo de máscaras CIDR, transporte TCP/UDP, DNS, DHCP y NAT.'
    )
    RETURNING id INTO v_m3_id;

    -- Lección 3.1: Direccionamiento IPv4 y Máscaras de Subred
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m3_id,
        '1. Direccionamiento IPv4, Clases y Notación CIDR',
        'Domina la estructura de 32 bits de una dirección IP, máscaras de subred y rangos privados RFC 1918.',
        'quiz',
        100,
        '# Direccionamiento IPv4 y Máscaras de Red

Una dirección **IPv4** es un identificador lógico de **32 bits**, expresado en 4 octetos decimales separados por puntos (ej: `192.168.1.100`).

### Partes de una Dirección IP:
Toda IP se divide en dos componentes determinados por la **Máscara de Subred**:
- **Porción de Red (Network ID)**: Identifica a qué red pertenece el host.
- **Porción de Host (Host ID)**: Identifica al equipo específico dentro de esa red.

### Notación CIDR (Classless Inter-Domain Routing):
Representa la cantidad de bits en 1 de la máscara de subred:
- `/24` = `255.255.255.0` (24 bits de red, 8 bits de host = 254 hosts utilizables).
- `/16` = `255.255.0.0` (16 bits de red, 16 bits de host = 65,534 hosts utilizables).
- `/8` = `255.0.0.0` (8 bits de red, 24 bits de host = 16.7 millones de hosts).

### Rangos de IP Privadas (RFC 1918):
Son direcciones reservadas para redes locales que **no se enrutan en la Internet pública**:
- **Clase A**: `10.0.0.0` a `10.255.255.255` (`10.0.0.0/8`).
- **Clase B**: `172.16.0.0` a `172.31.255.255` (`172.16.0.0/12`).
- **Clase C**: `192.168.0.0` a `192.168.255.255` (`192.168.0.0/16`).

### Direcciones Especiales en una Subred:
- **Dirección de Red**: Todos los bits de host en 0 (ej: `192.168.1.0/24`). No asignable a hosts.
- **Dirección de Broadcast**: Todos los bits de host en 1 (ej: `192.168.1.255/24`). Envía a todos los hosts de la subred.',
        '[{"id":"q1","question":"¿Cuántos bits componen una dirección IPv4 tradicional?","options":["16 bits","32 bits","64 bits","128 bits"],"correctIndex":1,"explanation":"Una dirección IPv4 está compuesta por 32 bits, organizados en 4 octetos de 8 bits cada uno."},{"id":"q2","question":"¿Cuál de las siguientes direcciones IP pertenece al rango privado (RFC 1918) y no es enrutable en Internet?","options":["8.8.8.8","1.1.1.1","192.168.1.254","200.45.120.3"],"correctIndex":2,"explanation":"192.168.1.254 está dentro del rango privado de Clase C (192.168.0.0/16) comúnmente usado en routers domésticos y oficinas."},{"id":"q3","question":"En una subred /24 (255.255.255.0), ¿cuántas direcciones IP son realmente utilizables para asignar a hosts?","options":["256","254","128","512"],"correctIndex":1,"explanation":"De los 256 valores posibles (2^8), se descuentan 2: la dirección de red (.0) y la dirección de broadcast (.255), quedando 254 direcciones útiles."}]',
        1
    );

    -- Lección 3.2: Introducción a IPv6 y Diferencias Fundamentales
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m3_id,
        '2. El Protocolo IPv6 y la Próxima Generación',
        'Conoce la arquitectura de 128 bits de IPv6, eliminación de NAT y notación hexadecimal.',
        'quiz',
        100,
        '# IPv6: La Evolución del Direccionamiento

IPv4 ofrece aproximadamente 4.300 millones de direcciones (`2^32`), las cuales se agotaron oficialmente ante la explosión de dispositivos móviles, servidores e IoT.

### Características de IPv6:
- **Longitud**: **128 bits** (`2^128` direcciones = 340 sextillones de IPs disponibles, prácticamente inagotables).
- **Formato**: 8 grupos (hextetos) de 4 dígitos hexadecimales separados por dos puntos (ej: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`).
- **Reglas de Abreviación**:
  - Se pueden omitir los ceros a la izquierda en cualquier grupo (`0db8` -> `db8`).
  - Se puede reemplazar una secuencia consecutiva de grupos de ceros por dos puntos dobles `::` (solo una vez por dirección).
  - Ejemplo: `2001:db8:85a3::8a2e:370:7334`.

### Ventajas Clave sobre IPv4:
1. **Sin necesidad de NAT**: Cada dispositivo puede tener una IP global pública única, restaurando la conectividad de extremo a extremo.
2. **Autoconfiguración SLAAC**: Permite a los hosts configurar su propia IP sin necesidad de un servidor DHCP obligatorio.
3. **No existen broadcasts**: Se reemplazan por **Multicast** y **Anycast** para optimizar el ancho de banda.',
        '[{"id":"q1","question":"¿Cuántos bits tiene una dirección IPv6?","options":["32 bits","64 bits","128 bits","256 bits"],"correctIndex":2,"explanation":"Una dirección IPv6 tiene 128 bits de longitud, lo que permite un espacio de direccionamiento de aproximadamente 3.4 x 10^38 direcciones."},{"id":"q2","question":"¿Cómo se representa una dirección IPv6?","options":["4 números decimales separados por puntos","8 grupos de 4 dígitos hexadecimales separados por dos puntos","Una cadena binaria de 0 y 1 sin separadores","Nombres de dominio exclusivamente"],"correctIndex":1,"explanation":"IPv6 se escribe en notación hexadecimal en 8 grupos de 16 bits (hextetos) separados por dos puntos (:)."},{"id":"q3","question":"¿Qué tipo de tráfico fue eliminado en IPv6 para evitar inundar la red?","options":["Unicast","Multicast","Broadcast","Anycast"],"correctIndex":2,"explanation":"En IPv6 no existe el tráfico de Broadcast; en su lugar se utiliza Multicast dirigido para una gestión de tráfico mucho más eficiente."}]',
        2
    );

    -- Lección 3.3: Protocolos de Transporte: TCP vs UDP en Profundidad
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m3_id,
        '3. Capa de Transporte: TCP (3-Way Handshake) vs UDP',
        'Analiza el funcionamiento del 3-Way Handshake de TCP, control de flujo y por qué UDP es óptimo para tiempo real.',
        'quiz',
        100,
        '# Protocolos de Transporte: TCP vs UDP

La Capa 4 es responsable de la transferencia de datos entre procesos mediante dos protocolos con filosofías opuestas:

### 1. TCP (Transmission Control Protocol)
- **Características**: Orientado a conexión, confiable, con control de errores y control de flujo.
- **3-Way Handshake (Apretón de manos de 3 vías)**:
  1. **SYN**: El cliente solicita abrir conexión enviando un número de secuencia inicial.
  2. **SYN-ACK**: El servidor responde aceptando y enviando su propio número de secuencia.
  3. **ACK**: El cliente confirma la recepción y la sesión queda establecida.
- **Ventana Deslizante (Sliding Window)**: Ajusta la cantidad de datos que se pueden enviar antes de requerir una confirmación, evitando saturar al receptor.
- **Casos de uso**: Páginas web (HTTP/HTTPS), descarga de archivos, correos electrónicos (SMTP/IMAP), bases de datos y SSH.

### 2. UDP (User Datagram Protocol)
- **Características**: No orientado a conexión (Connectionless), ligero, sin garantías de entrega, sin retransmisión ni control de orden.
- **Ventaja**: Latencia mínima (overhead mínimo de 8 bytes de cabecera vs 20+ bytes de TCP).
- **Casos de uso**: Streaming de video/audio en vivo, llamadas VoIP, videojuegos online multijugador, consultas DNS y SNMP.',
        '[{"id":"q1","question":"¿Cuál es la secuencia correcta de banderas en el 3-Way Handshake de TCP para iniciar una conexión?","options":["ACK -> SYN -> FIN","SYN -> SYN-ACK -> ACK","HELLO -> READY -> OK","RST -> SYN -> ACK"],"correctIndex":1,"explanation":"TCP inicia con SYN (Synchronize), el receptor responde con SYN-ACK (Synchronize-Acknowledge) y el emisor finaliza con ACK (Acknowledge)."},{"id":"q2","question":"¿Por qué una llamada de voz por WhatsApp o Discord utiliza UDP en lugar de TCP?","options":["Porque UDP retransmite los paquetes perdidos automáticamente","Porque UDP prioriza la baja latencia en tiempo real sobre la retransmisión de paquetes perdidos","Porque TCP no funciona con internet móvil","Porque UDP cifra los datos obligatoriamente"],"correctIndex":1,"explanation":"En audio/video en tiempo real, un paquete demorado es inútil; retransmitirlo causaría retrasos y cortes molestos en la conversación."},{"id":"q3","question":"¿Qué tamaño de cabecera fija tiene un paquete UDP comparado con TCP?","options":["UDP tiene solo 8 bytes de cabecera, mientras que TCP tiene mínimo 20 bytes","UDP tiene 100 bytes de cabecera","Ambos tienen exactamente el mismo tamaño","UDP no tiene cabecera"],"correctIndex":0,"explanation":"UDP es extremadamente ligero, con una cabecera de apenas 8 bytes (puerto origen, puerto destino, longitud y checksum)."} ]',
        3
    );

    -- Lección 3.4: Servicios Esenciales: DNS, DHCP, NAT e ICMP
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m3_id,
        '4. Servicios Fundamentales: DNS, DHCP, NAT e ICMP',
        'Descubre cómo funcionan los servicios que hacen posible la navegación en Internet.',
        'quiz',
        100,
        '# Servicios Esenciales de Red

Cuando conectas tu computadora a la red y navegas a un sitio web, múltiples servicios colaboran de forma transparente:

### 1. DHCP (Dynamic Host Configuration Protocol)
- **Función**: Asigna automáticamente direcciones IP, máscara de subred, puerta de enlace (Gateway) y servidores DNS a los hosts.
- **Proceso DORA**:
  1. **Discover**: El cliente envía un broadcast buscando servidores DHCP.
  2. **Offer**: El servidor ofrece una configuración IP disponible.
  3. **Request**: El cliente solicita formalmente la IP ofrecida.
  4. **Acknowledge (ACK)**: El servidor confirma la asignación (concesión o lease time).

### 2. DNS (Domain Name System - Puerto 53 UDP/TCP)
- **Función**: La "guía telefónica" de Internet. Traduce nombres de dominio legibles por humanos (ej: `google.com`) a direcciones IP numéricas (ej: `142.250.190.46`).
- **Registros principales**:
  - **A**: Mapea nombre a IPv4.
  - **AAAA**: Mapea nombre a IPv6.
  - **CNAME**: Alias de otro nombre.
  - **MX**: Servidores de correo electrónico.

### 3. NAT (Network Address Translation)
- **Función**: Permite que múltiples dispositivos de una red local con IPs privadas salgan a Internet compartiendo una única dirección IP pública del router.

### 4. ICMP (Internet Control Message Protocol)
- **Función**: Envío de mensajes de diagnóstico y errores de capa de red.
- **Herramientas**:
  - **Ping** (Echo Request / Echo Reply): Mide latencia y pérdida de paquetes.
  - **Traceroute**: Rastrea la ruta y cada salto de router hasta el destino mediante el campo TTL (Time to Live).',
        '[{"id":"q1","question":"¿Qué protocolo se encarga de traducir un nombre de dominio como ' || quote_literal('codify.com') || ' en una dirección IP?","options":["DHCP","DNS (Domain Name System)","NAT","ARP"],"correctIndex":1,"explanation":"DNS (Domain Name System) resuelve nombres de dominio a direcciones IP para que los clientes puedan conectarse a los servidores web."},{"id":"q2","question":"¿Cuál es el acrónimo de los 4 pasos del proceso de asignación automática de IP en DHCP?","options":["DORA (Discover, Offer, Request, Acknowledge)","CRUD (Create, Read, Update, Delete)","ACID (Atomicity, Consistency, Isolation, Durability)","SYN-ACK-FIN-RST"],"correctIndex":0,"explanation":"El protocolo DHCP utiliza el ciclo DORA: Discover (descubrir), Offer (ofrecer), Request (solicitar) y Acknowledge (confirmar)."},{"id":"q3","question":"¿Qué utilidad de diagnóstico utiliza mensajes ICMP y el campo TTL para mostrar la ruta exacta y cada router por el que pasan los paquetes?","options":["Traceroute (o tracert)","nslookup","ipconfig","telnet"],"correctIndex":0,"explanation":"Traceroute envía paquetes con valores crecientes de TTL para identificar secuencialmente cada salto (hop) de router en el camino."}]',
        4
    );

END $$;
