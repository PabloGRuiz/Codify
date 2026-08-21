-- 14_it_logic_fundamentals.sql
-- Módulo Base: Fundamentos IT y Lógica Computacional
-- Retos diarios por defecto para la Arena para Responsables Informáticos sin experiencia en programación.

DO $$
DECLARE
    v_course_id UUID;
    v_m1_id UUID;
BEGIN
    -- 0. Limpiar versión previa si existiera
    DELETE FROM courses WHERE title = 'Fundamentos IT y Lógica';

    -- 1. Crear el Curso Base
    INSERT INTO courses (title, description, image_url, tags)
    VALUES (
        'Fundamentos IT y Lógica',
        'Conceptos esenciales de informática, hardware, software, y razonamiento lógico-computacional para Responsables Informáticos.',
        '/images/courses/logic.jpg',
        ARRAY['Lógica', 'IT', 'Fundamentos']
    )
    RETURNING id INTO v_course_id;

    -- ==============================================================================
    -- 2. MÓDULO 1: ARENA BASE
    -- ==============================================================================
    INSERT INTO modules (course_id, title, description)
    VALUES (
        v_course_id,
        'Arena de Lógica y Fundamentos',
        'Retos base de lógica y conocimiento general IT que alimentan la rotación de la Arena Diaria.'
    )
    RETURNING id INTO v_m1_id;

    -- Reto 1: Lógica Booleana Básica
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        'Lógica Computacional: Verdadero o Falso',
        'Evalúa escenarios usando operadores lógicos básicos (AND, OR, NOT).',
        'quiz',
        50,
        '# Lógica Computacional Básica

Los ordenadores toman decisiones evaluando condiciones como Verdaderas (True) o Falsas (False) mediante operadores lógicos:

- **AND (Y)**: El resultado es verdadero SOLO si TODAS las condiciones son verdaderas. (Ej: Hace sol AND tengo tiempo = Voy al parque).
- **OR (O)**: El resultado es verdadero si AL MENOS UNA condición es verdadera. (Ej: Es sábado OR es domingo = Fin de semana).
- **NOT (NO)**: Invierte el valor. (Ej: NOT Verdadero = Falso).',
        '[{"id":"q1","question":"Si la condición A es Falsa y la condición B es Verdadera, ¿Cuál es el resultado de (A OR B)?","options":["Falso","Verdadero","Depende del sistema","Error"],"correctIndex":1,"explanation":"El operador OR devuelve Verdadero si al menos una de las condiciones es verdadera."},{"id":"q2","question":"Si tienes un sistema de acceso que requiere (Tarjeta de Identificación AND Huella Dactilar). ¿Qué ocurre si pasas la tarjeta pero la huella falla?","options":["El acceso se permite","El sistema pide contraseña","El acceso se deniega","Se bloquea la puerta para siempre"],"correctIndex":2,"explanation":"El operador AND requiere que ambas condiciones sean verdaderas simultáneamente."}]',
        1
    );

    -- Reto 2: Arquitectura y Hardware
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        'Componentes Core de un Sistema IT',
        'Identifica la función de la RAM, CPU, y almacenamiento secundario en el rendimiento general.',
        'quiz',
        50,
        '# Arquitectura del Computador (Modelo de von Neumann)

Comprender la diferencia entre memoria y almacenamiento es clave para diagnosticar problemas de lentitud:

- **CPU (Procesador)**: El "cerebro". Ejecuta las instrucciones. A más núcleos y frecuencia (GHz), mayor capacidad de procesamiento simultáneo.
- **Memoria RAM**: Memoria "a corto plazo". Almacena temporalmente los datos y programas que se están usando activamente. Es volátil (se borra al apagar). Si se agota, el sistema se vuelve extremadamente lento.
- **Almacenamiento (HDD/SSD)**: Memoria "a largo plazo". Donde se guardan los archivos permanentemente. Los SSD (Estado Sólido) son muchísimo más rápidos que los discos mecánicos (HDD).',
        '[{"id":"q1","question":"Un usuario reporta que su computadora tarda 5 minutos en arrancar Windows y abrir programas, pero una vez abiertos, funciona decentemente. ¿Qué mejora física sería más efectiva?","options":["Cambiar la RAM de 8GB a 16GB","Cambiar el Disco Duro Mecánico (HDD) por un Estado Sólido (SSD)","Instalar un procesador más potente","Cambiar la fuente de poder"],"correctIndex":1,"explanation":"El almacenamiento SSD elimina el cuello de botella físico del HDD, acelerando drásticamente los tiempos de carga y arranque."},{"id":"q2","question":"Si un servidor se reinicia inesperadamente por un corte de luz temporal, ¿qué datos se pierden irreversiblemente si no fueron guardados?","options":["Los archivos en el disco duro","El sistema operativo","Los datos actualmente cargados en la Memoria RAM","La configuración de la placa madre"],"correctIndex":2,"explanation":"La RAM es memoria volátil; requiere energía constante para retener los datos."}]',
        2
    );

    -- Reto 3: Seguridad de la Información Básica
    INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
    VALUES (
        v_m1_id,
        'Cultura de Ciberseguridad',
        'Conceptos de phishing, MFA y respaldos.',
        'quiz',
        50,
        '# Pilares de la Ciberseguridad

Como responsable informático, la cultura de seguridad de los usuarios es la primera línea de defensa.

- **Phishing**: Ingeniería social. Un atacante se hace pasar por una entidad de confianza (banco, soporte técnico) vía email para robar contraseñas.
- **MFA (Multi-Factor Authentication)**: Autenticación de múltiples factores. Requerir no solo "algo que sabes" (contraseña), sino también "algo que tienes" (un código en el celular) o "algo que eres" (biometría).
- **Regla de Respaldo 3-2-1**: Mantener al menos 3 copias de los datos, en 2 medios diferentes, y 1 copia fuera del sitio (en la nube).',
        '[{"id":"q1","question":"¿Qué ataque busca engañar al usuario para que entregue voluntariamente sus credenciales mediante un correo falso?","options":["Ransomware","Fuerza Bruta","Phishing","DDoS"],"correctIndex":2,"explanation":"El Phishing utiliza el engaño psicológico y la suplantación de identidad para que el usuario revele sus datos."},{"id":"q2","question":"Si las contraseñas de tus usuarios son comprometidas (robadas de otra base de datos), ¿Qué política previene que los atacantes puedan iniciar sesión en tus sistemas corporativos?","options":["Requerir contraseñas de 20 caracteres","Obligar a usar Autenticación Multi-Factor (MFA / 2FA)","Cambiar la contraseña cada 30 días","Instalar un antivirus"],"correctIndex":1,"explanation":"Con MFA activado, aunque el atacante tenga la contraseña correcta, no podrá acceder sin el código temporal enviado al celular del usuario."}]',
        3
    );

END $$;
