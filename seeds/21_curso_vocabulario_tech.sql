-- ==============================================================================
-- 🚀 CODIFY SEED: 21 - CURSO: JERGA Y VOCABULARIO TECH: EL IDIOMA DE LA INDUSTRIA IT
-- ==============================================================================
-- Este script inserta:
-- 1. Curso: "Jerga y Vocabulario Tech: El Idioma de la Industria IT"
-- 2. Sin prerrequisito (Curso Inicial / Nivel 1)
-- 3. Tres módulos pedagógicos:
--    - Módulo 1: El Lenguaje del Código y Desarrollo
--    - Módulo 2: Infraestructura, Servidores y el Spanglish IT
--    - Módulo 3: Dinámica de Equipos, Metodologías y Roles
-- 4. Doce lecciones interactivas con casos de la vida real
-- ==============================================================================

DO $$
DECLARE
  v_author_id UUID;
  v_course_id UUID;
  v_mod1_id UUID;
  v_mod2_id UUID;
  v_mod3_id UUID;
BEGIN

  -- 1. Obtener autor o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Insertar el curso
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
    'Jerga y Vocabulario Tech: El Idioma de la Industria IT',
    'Aprende el vocabulario real que se habla en empresas de software: anglicismos, siglas, términos de desarrollo, metodologías ágiles y el spanglish técnico explicado de forma clara y humana.',
    E'## 🚀 Acerca del Curso\n\n¿Escuchaste hablar de *deployar*, *hacer un rollback*, *revisar un PR* o *levantar un ticket* y te sonó a otro idioma? ¡No te preocupes! La tecnología moderna tiene su propio dialecto: una mezcla dinámica de inglés técnico, siglas crípticas y términos adaptados al español.\n\nEste curso está especialmente pensado para **principiantes, personas en reconversión laboral y adultos** que quieren ponerse al día con la terminología actual sin tecnicismos innecesarios ni barreras de entrada.\n\n### 🎯 ¿Qué aprenderás?\n- **El Lenguaje del Código:** Diferencias claras entre Frontend, Backend, Full Stack, Frameworks, Librerías, APIs, Bugs, Fixes y Refactors.\n- **El "Spanglish" de Infraestructura:** Qué significa *deployar*, *buildear*, *crashear*, ambientes *Local*, *Dev*, *Staging*, *Producción* y computación *Cloud*.\n- **Cultura y Metodología de Equipos:** Términos de agilidad como *Sprints*, *Dailies*, *Backlogs*, *Code Reviews*, *Pull Requests* y los roles clave (*Tech Lead, Product Owner, QA, DevOps*).\n- **Vocabulario de Negocio y Producto:** Comprender qué es un *MVP*, un *Deadline* y qué piden los *Stakeholders*.\n\n### 👥 ¿A quién está dirigido?\nCualquier persona que esté dando sus primeros pasos en el mundo de la tecnología o que trabaje en áreas afines (ventas, diseño, gestión) y necesite comunicarse con fluidez con equipos técnicos.',
    ARRAY['Teórico', 'Vocabulario', 'Introductorio', 'Cultura IT', 'Primeros Pasos'],
    NULL,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: El Lenguaje del Código y Desarrollo
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: El Lenguaje del Código y Desarrollo',
    'Comprende las piezas de construcción del software y los términos cotidianos de los programadores.',
    '1'
  ) RETURNING id INTO v_mod1_id;

  -- Lección 1.1: Frontend vs Backend vs Full Stack
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '1. ¿Quién es quién? Frontend, Backend y Full Stack',
    'Descubre cómo se dividen las responsabilidades en una aplicación moderna.',
    'quiz',
    1,
    50,
    E'### 🎨 Frontend vs ⚙️ Backend vs 🌐 Full Stack\n\n- **Frontend (Cliente):** Todo lo que el usuario ve y con lo que interactúa en su pantalla (botones, animaciones, formularios, diseño web).\n- **Backend (Servidor):** El "motor detrás de escena". Procesa la lógica, gestiona las bases de datos, valida contraseñas y realiza cálculos seguros.\n- **Full Stack:** Un desarrollador que tiene conocimientos tanto de Frontend como de Backend y puede construir una aplicación de punta a punta.',
    '2'
  );

  -- Lección 1.2: Librería vs Framework vs API
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '2. Los Bloques: Librería, Framework, SDK y API',
    'Aprende a diferenciar las herramientas y puentes que usan los desarrolladores.',
    'quiz',
    2,
    50,
    E'### 🧱 Piezas de Construcción:\n\n- **Librería (Library):** Una colección de funciones prediseñadas que tú llamas cuando las necesitas (tú tienes el control).\n- **Framework (Marco de trabajo):** Una estructura completa con reglas obligatorias donde el framework toma el control y tú completas los huecos.\n- **API (Interfaz de Programación de Aplicaciones):** El "mozo del restaurante" que conecta dos sistemas (ej: pagar con MercadoPago o ver el clima en Google Maps).\n- **SDK (Software Development Kit):** Una caja de herramientas completa que incluye librerías, APIs y documentación para una plataforma específica.',
    '3'
  );

  -- Lección 1.3: Bugs, Fixes, Hotfixes y Refactor
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '3. Errores y Mejoras: Bug, Fix, Hotfix y Refactoring',
    'Aprende qué significa cuando algo falla o cuando se limpia el código.',
    'quiz',
    3,
    50,
    E'### 🐞 Vocabulario de Mantenimiento:\n\n- **Bug (Bicho):** Un error o defecto en el código que hace que la aplicación no funcione como se esperaba.\n- **Fix / Bugfix:** La corrección o solución aplicada para eliminar ese bug.\n- **Hotfix:** Una reparación de emergencia y ultra rápida que se sube directo a producción porque algo crítico se rompió.\n- **Refactor (Refactorización):** Reescribir y limpiar el código interno para que sea más legible y rápido, **sin cambiar lo que el usuario ve por fuera**.',
    '1'
  );

  -- Lección 1.4: Hardcodear, Boilerplate y Legacy Code
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod1_id,
    '4. Buenas y Malas Prácticas: Hardcodear y Boilerplate',
    'Identifica la mala práctica de "hardcodear" y el código base repetitivo.',
    'logic',
    4,
    60,
    E'### ⚠️ Términos Clave de Código:\n\n- **Hardcodear (Hardcode):** Escribir valores fijos directamente en el código (como contraseñas, URLs o nombres) en lugar de usar variables o configuraciones dinámicas. ¡Es una mala práctica!\n- **Boilerplate:** Código estándar y repetitivo que se necesita para inicializar un proyecto antes de empezar a programar lo real.\n- **Legacy Code (Código Heredado):** Código antiguo que funciona, pero nadie quiere tocar porque es difícil de entender o usa tecnologías del pasado.',
    '// Identifica si un valor está hardcodeado o viene de una variable de entorno segura
function isHardcodedSecret(apiKey) {
  // Si la clave empieza con un texto fijo como "12345_clave_secreta", es inseguro (hardcodeado)
  return apiKey === "12345_clave_secreta";
}',
    'function isHardcodedSecret(apiKey) {
  return apiKey === "12345_clave_secreta";
}',
    'if (isHardcodedSecret("12345_clave_secreta") === true && isHardcodedSecret(process.env.API_KEY || "otro") === false) { return true; } throw new Error("Debe detectar el valor hardcodeado");'
  );

  -- ==============================================================================
  -- MÓDULO 2: Infraestructura, Servidores y el Spanglish IT
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Infraestructura, Servidores y el Spanglish IT',
    'Descubre el significado de los verbos inventados en IT y cómo se publican las aplicaciones.',
    '1'
  ) RETURNING id INTO v_mod2_id;

  -- Lección 2.1: Deployar, Buildear y Rollback
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '5. Los Verbos Tech: Deployar, Buildear y Rollback',
    'Comprende el proceso de empaquetar y publicar aplicaciones.',
    'quiz',
    5,
    50,
    E'### 🚀 Los Verbos más Usados en IT:\n\n- **Buildear (Build):** Compilar, empaquetar y optimizar el código fuente para transformarlo en archivos listos para funcionar.\n- **Deployar (Deploy / Despliegue):** Subir y activar la nueva versión de tu aplicación en un servidor para que los usuarios puedan usarla.\n- **Rollback (Volver atrás):** Revertir de emergencia la aplicación a la versión anterior estable cuando un deploy nuevo introduce errores graves.',
    '3'
  );

  -- Lección 2.2: Ambientes de Trabajo (Local, Dev, Staging, Prod)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '6. ¿Dónde corre la app? Local, Dev, Staging y Producción',
    'Aprende los distintos niveles de prueba antes de llegar a los usuarios reales.',
    'quiz',
    6,
    55,
    E'### 🚦 Los 4 Ambientes Tradicionales:\n\n1. **Local (localhost):** Tu propia computadora. Solo tú puedes ver y romper lo que estás haciendo.\n2. **Desarrollo (Dev):** Servidor interno donde el equipo junta y prueba las nuevas funciones.\n3. **Staging (Pre-producción):** Una réplica casi exacta del entorno real para hacer pruebas finales de calidad (QA).\n4. **Producción (Prod):** ¡El sistema en vivo! Donde los clientes y usuarios reales interactúan. Nadie debe experimentar directamente en producción.',
    '4'
  );

  -- Lección 2.3: Cloud, On-Premise, SaaS y Serverless
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '7. ¿Dónde vive la app? Cloud, On-Premise y SaaS',
    'Desmitifica la "nube" y los modelos de servicio actuales.',
    'quiz',
    7,
    50,
    E'### ☁️ La Nube y Servidores:\n\n- **La Nube (Cloud):** Servidores y centros de datos gigantes administrados por empresas como Amazon (AWS), Google Cloud o Microsoft Azure que alquilas bajo demanda.\n- **On-Premise (Local):** Tener tus propios servidores físicos instalados en la oficina o edificio de tu empresa.\n- **SaaS (Software as a Service):** Software listo para usar en la web mediante suscripción (ej: Spotify, Notion, Slack).\n- **Serverless:** Ejecutar código sin tener que configurar ni preocuparte por el sistema operativo del servidor.',
    '1'
  );

  -- Lección 2.4: Hosting, Dominio, DNS y SSL
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '8. Dominio, Hosting, DNS y Certificado SSL',
    'La analogía de la casa para entender cómo funciona la web.',
    'quiz',
    8,
    50,
    E'### 🏡 La Analogía de la Casa:\n\n- **Hosting (Alojamiento):** El terreno y la casa física donde guardas tus muebles (archivos y bases de datos).\n- **Dominio:** La dirección postal fácil de recordar (ej: `google.com` o `codify.com`).\n- **DNS (Domain Name System):** La guía telefónica que traduce `google.com` a la dirección IP numérica del servidor (`142.250.190.46`).\n- **SSL (HTTPS):** El candado de seguridad que encripta los datos que viajan entre el usuario y la web para que nadie los espíe.',
    '2'
  );

  -- ==============================================================================
  -- MÓDULO 3: Dinámica de Equipos, Metodologías y Roles
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Dinámica de Equipos, Metodologías y Roles',
    'Aprende cómo se organizan los equipos de ingeniería, qué hace cada rol y el flujo diario de trabajo.',
    '1'
  ) RETURNING id INTO v_mod3_id;

  -- Lección 3.1: Scrum, Sprints, Dailies y Backlog
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '9. Metodologías Ágiles: Scrum, Sprints y Dailies',
    'Comprende cómo los equipos dividen el trabajo en bloques de 1 a 2 semanas.',
    'quiz',
    9,
    55,
    E'### 🏃‍♂️ Agilidad y Scrum:\n\n- **Sprint:** Un ciclo de trabajo corto (habitualmente 2 semanas) donde el equipo se compromete a entregar un conjunto de tareas terminadas.\n- **Daily (Reunión Diaria):** Una reunión rápida de 15 minutos de pie donde cada miembro responde: ¿Qué hice ayer? ¿Qué haré hoy? ¿Tengo algún bloqueo?\n- **Backlog:** La lista priorizada de todas las tareas, ideas y funciones pendientes por hacer en el proyecto.',
    '1'
  );

  -- Lección 3.2: Roles en IT (Tech Lead, PO, QA, DevOps)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '10. El Mapa de Roles: ¿Quién es quién en el equipo?',
    'Aprende qué responsabilidades tiene cada puesto en una empresa tecnológica.',
    'quiz',
    10,
    55,
    E'### 👥 Roles Principales:\n\n- **Tech Lead (Líder Técnico):** El referente que toma decisiones de arquitectura y guía técnicamente a los desarrolladores.\n- **Product Owner (PO) / Product Manager (PM):** Representa la voz del negocio y del usuario, decidiendo **qué** se construye y en qué orden.\n- **QA Tester (Quality Assurance):** Especialista en probar el software, encontrar bugs y asegurar que cumpla con los estándares de calidad.\n- **DevOps:** Ingeniero encargado de los despliegues, servidores, automatización y que la app esté siempre activa.\n- **UX/UI Designer:** Diseña la experiencia de usuario (UX) y la interfaz visual interactiva (UI).',
    '3'
  );

  -- Lección 3.3: Pull Requests, Code Reviews y Merges
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '11. El Filtro de Calidad: Pull Request y Code Review',
    'Cómo colaboran los programadores sin pisarse los cambios.',
    'quiz',
    11,
    55,
    E'### 🤝 Colaboración Segura:\n\n- **Pull Request (PR):** Cuando un programador termina su tarea en su rama propia, abre un PR pidiéndole al equipo que revise sus cambios.\n- **Code Review (Revisión de Código):** Otros programadores leen el código propuesto, dejan sugerencias, detectan posibles bugs y lo aprueban.\n- **Merge:** Una vez aprobado, el código se fusiona con la rama principal del proyecto.',
    '2'
  );

  -- Lección 3.4: MVP, Deadline, Stakeholders y Onboarding
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod3_id,
    '12. De la Idea al Negocio: MVP, Deadline y Stakeholders',
    'Los conceptos de negocio que todo profesional del software debe dominar.',
    'logic',
    12,
    70,
    E'### 💼 Vocabulario de Negocio y Lanzamiento:\n\n- **MVP (Minimum Viable Product / Producto Mínimo Viable):** La versión más simple y básica de un producto que se lanza para validar con usuarios reales si la idea funciona.\n- **Deadline:** La fecha límite innegociable de entrega de un proyecto o hito.\n- **Stakeholders:** Las partes interesadas en el éxito del proyecto (clientes, directores, inversores).\n- **Onboarding:** El proceso de inducción y bienvenida para que una nueva persona se integre rápido al equipo.',
    '// Traduce un término clave al concepto correcto
function getBusinessTermDefinition(term) {
  if (term === "MVP") return "Producto Mínimo Viable";
  if (term === "Deadline") return "Fecha Límite";
  return "Desconocido";
}',
    'function getBusinessTermDefinition(term) {
  if (term === "MVP") return "Producto Mínimo Viable";
  if (term === "Deadline") return "Fecha Límite";
  return "Desconocido";
}',
    'if (getBusinessTermDefinition("MVP") === "Producto Mínimo Viable" && getBusinessTermDefinition("Deadline") === "Fecha Límite") { return true; } throw new Error("Definición incorrecta");'
  );

END $$;
