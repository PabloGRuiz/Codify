-- 13_curso_redes_quiz.sql

DO $$
DECLARE
    v_course_id UUID;
    v_module_1_id UUID;
    v_module_2_id UUID;
    v_module_3_id UUID;
BEGIN
    -- 0. Clean previous incomplete attempts if any
    DELETE FROM courses WHERE title = 'Fundamentos de Redes y Telecomunicaciones';

    -- 1. Create Course
    INSERT INTO courses (title, description, image_url, tags)
    VALUES (
        'Fundamentos de Redes y Telecomunicaciones',
        'Aprende los conceptos teóricos básicos sobre cómo funciona Internet, el modelo OSI, y protocolos de comunicación.',
        '/images/courses/redes.jpg',
        ARRAY['Teórico', 'Redes']
    )
    RETURNING id INTO v_course_id;

    -- 2. Create Modules
    INSERT INTO modules (course_id, title, description)
    VALUES 
        (v_course_id, 'Módulo 1: Introducción a las Redes', 'Conceptos básicos, topologías y componentes.')
    RETURNING id INTO v_module_1_id;

    INSERT INTO modules (course_id, title, description)
    VALUES 
        (v_course_id, 'Módulo 2: El Modelo OSI', 'Análisis detallado de las 7 capas del modelo de referencia OSI.')
    RETURNING id INTO v_module_2_id;

    INSERT INTO modules (course_id, title, description)
    VALUES 
        (v_course_id, 'Módulo 3: Protocolos TCP/IP', 'La suite de protocolos de Internet, direcciones IP y enrutamiento.')
    RETURNING id INTO v_module_3_id;

    -- 3. Create Challenges (Quizzes) for Module 1
    INSERT INTO challenges (
        module_id,
        title,
        description,
        challenge_type,
        xp_reward,
        theory,
        test_code,
        order_index
    )
    VALUES (
        v_module_1_id,
        'Conceptos Básicos de Redes',
        'Evalúa tus conocimientos sobre qué es una red y sus topologías.',
        'quiz',
        100,
        '# Introducción a las Redes\n\nUna red de computadoras es un conjunto de equipos nodos y software conectados entre sí por medio de dispositivos físicos o inalámbricos que envían y reciben impulsos eléctricos, ondas electromagnéticas o cualquier otro medio para el transporte de datos, con la finalidad de compartir información, recursos y ofrecer servicios.\n\n## Topologías Básicas\n- **Bus**: Todos los nodos están conectados a un cable central.\n- **Estrella**: Todos los nodos se conectan a un concentrador o switch central.\n- **Anillo**: Cada nodo se conecta a otros dos, formando un círculo cerrado.\n- **Malla**: Todos los nodos están interconectados entre sí.',
        '[{"id":"q1","question":"¿Cuál es el propósito principal de una red de computadoras?","options":["Aislar computadoras para mejorar la seguridad","Compartir información, recursos y servicios","Consumir más energía eléctrica","Reemplazar el uso de discos duros"],"correctIndex":1,"explanation":"El objetivo principal de una red es conectar dispositivos para compartir recursos y datos de manera eficiente."},{"id":"q2","question":"En una topología en estrella, ¿qué sucede si el concentrador central falla?","options":["Toda la red deja de funcionar","Solo falla un nodo","La red sigue funcionando normalmente","Se convierte en una topología en anillo"],"correctIndex":0,"explanation":"En la topología en estrella, el nodo central es el punto único de fallo. Si se cae, los demás nodos pierden la comunicación."}]',
        1
    );

    -- 4. Create Challenges for Module 2
    INSERT INTO challenges (
        module_id,
        title,
        description,
        challenge_type,
        xp_reward,
        theory,
        test_code,
        order_index
    )
    VALUES (
        v_module_2_id,
        'Las 7 Capas del Modelo OSI',
        'Comprende las diferentes capas de red según el estándar de estandarización OSI.',
        'quiz',
        150,
        '# El Modelo OSI\n\nEl Modelo de Interconexión de Sistemas Abiertos (OSI) es un modelo conceptual creado por la ISO que caracteres y estandariza las funciones de comunicación de un sistema de telecomunicaciones o informático.\n\n## Las 7 Capas:\n1. **Física**: Transmisión de bits a través del medio.\n2. **Enlace de Datos**: Direccionamiento MAC y detección de errores.\n3. **Red**: Direccionamiento IP y enrutamiento.\n4. **Transporte**: Conexión de extremo a extremo y confiabilidad (TCP/UDP).\n5. **Sesión**: Establecimiento, mantenimiento y terminación de sesiones.\n6. **Presentación**: Traducción de datos y cifrado.\n7. **Aplicación**: Interfaz con el usuario final (HTTP, FTP, SMTP).',
        '[{"id":"q1","question":"¿Qué capa del modelo OSI se encarga del enrutamiento y las direcciones IP?","options":["Capa 2: Enlace de Datos","Capa 3: Red","Capa 4: Transporte","Capa 7: Aplicación"],"correctIndex":1,"explanation":"La capa 3 (Red) es responsable del direccionamiento lógico (IP) y del enrutamiento de paquetes entre diferentes redes."},{"id":"q2","question":"¿Qué capa se encarga del cifrado de datos antes de ser enviados a la red?","options":["Capa de Sesión","Capa Física","Capa de Presentación","Capa de Transporte"],"correctIndex":2,"explanation":"La Capa 6 (Presentación) transforma los datos de la aplicación para la red, lo que incluye tareas como el cifrado y la compresión."}]',
        1
    );

    -- 5. Create Challenges for Module 3
    INSERT INTO challenges (
        module_id,
        title,
        description,
        challenge_type,
        xp_reward,
        theory,
        test_code,
        order_index
    )
    VALUES (
        v_module_3_id,
        'Protocolos y Suite TCP/IP',
        'Conceptos básicos de la suite de protocolos de Internet.',
        'quiz',
        150,
        '# TCP/IP\n\nEl Modelo TCP/IP es la arquitectura de red básica de Internet. A diferencia de OSI, TCP/IP es un modelo más práctico que consta de 4 capas: Acceso a la Red, Internet, Transporte y Aplicación.\n\n## Protocolos Clave:\n- **IP (Internet Protocol)**: Enruta los paquetes.\n- **TCP (Transmission Control Protocol)**: Asegura la entrega confiable y ordenada de datos.\n- **UDP (User Datagram Protocol)**: Ofrece entrega rápida sin garantía de confiabilidad, usado en streaming o videojuegos.',
        '[{"id":"q1","question":"¿Cuál es la principal diferencia entre TCP y UDP?","options":["TCP es más rápido que UDP","UDP garantiza la entrega de paquetes, TCP no","TCP asegura la entrega confiable, UDP no","TCP funciona en la capa de red, UDP en la de aplicación"],"correctIndex":2,"explanation":"TCP verifica que todos los paquetes lleguen correctamente, mientras que UDP los envía sin esperar confirmación para priorizar la velocidad."},{"id":"q2","question":"¿Cuántas capas tiene el modelo teórico TCP/IP?","options":["4","7","5","3"],"correctIndex":0,"explanation":"El modelo TCP/IP tradicional tiene 4 capas: Acceso a la Red, Internet, Transporte y Aplicación."},{"id":"q3","question":"¿Qué protocolo utilizarías principalmente para transmitir un partido en vivo de forma fluida?","options":["TCP","HTTP","IP","UDP"],"correctIndex":3,"explanation":"Para streaming de video o audio en vivo se usa UDP porque la pérdida de un paquete ocasional es preferible al retraso que generaría retransmitirlo (como hace TCP)."} ]',
        1
    );

END $$;
