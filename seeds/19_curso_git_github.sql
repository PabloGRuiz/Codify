-- ==============================================================================
-- 🚀 CODIFY SEED: 19 - CURSO COMPLETO: CONTROL DE VERSIONES CON GIT & GITHUB
-- ==============================================================================
-- Este script inserta:
-- 1. Curso: "Control de Versiones Profesional con Git & GitHub" con Ficha Técnica
-- 2. Prerrequisito enlazado a "Fundamentos IT y Lógica" (o inicial)
-- 3. Tres módulos pedagógicos estructurados
-- 4. Doce lecciones interactivas (Teoría, Quizzes y Prácticas)
-- ==============================================================================

DO $$
DECLARE
  v_author_id UUID;
  v_prereq_id UUID;
  v_course_id UUID;
  v_mod1_id UUID;
  v_mod2_id UUID;
  v_mod3_id UUID;
BEGIN

  -- 1. Obtener autor de referencia o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Obtener curso prerrequisito (Fundamentos IT y Lógica)
  SELECT id INTO v_prereq_id FROM public.courses WHERE title ILIKE '%Fundamentos IT%' LIMIT 1;

  -- 3. Crear o actualizar el curso de Git & GitHub
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
    'Control de Versiones Profesional con Git & GitHub',
    'Domina el estándar absoluto de la industria del software: control de versiones local, ramas estratégicas, resolución de conflictos, repositorios remotos y colaboración con Pull Requests en GitHub.',
    E'## 🚀 Acerca del Curso\n\nEl control de versiones es la habilidad no negociable más importante para cualquier desarrollador, DevOps o administrador de sistemas. En este curso aprenderás desde cómo funciona el modelo de almacenamiento interno de Git (árboles, blobs y commits) hasta estrategias avanzadas de colaboración en equipo con GitHub.\n\n### 🎯 ¿Qué aprenderás?\n- **El Modelo de 3 Árboles:** Working Directory, Staging Area (Index) y Repositorio Local (`HEAD`).\n- **Commits Profesionales:** Buenas prácticas de mensajes atómicos y semánticos (Conventional Commits).\n- **Ramas y Estrategias de Integración:** Creación de branches, fusiones Fast-Forward, 3-Way Merges y resolución manual de conflictos.\n- **Operaciones de Rescate:** Uso de `git stash` para pausar tareas, `git diff`, `git log` interactivo y `reset` vs `revert`.\n- **Flujo de Trabajo Colaborativo:** Clonación, remotos (`origin`), sincronización (`fetch`, `pull`, `push`), bifurcaciones (Forks) y Pull Requests en GitHub.\n\n### 👥 ¿A quién está dirigido?\nEstudiantes y profesionales que quieran dejar de usar "carpetas_final_v2_definitivo" y adoptar el estándar profesional de la ingeniería de software moderna.',
    ARRAY['Práctico', 'Git', 'GitHub', 'DevOps', 'Herramientas', 'Colaboración'],
    v_prereq_id,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Fundamentos y Flujo de Trabajo Local
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Fundamentos y Flujo de Trabajo Local',
    'Comprende el ciclo de vida de los archivos, la preparación de cambios y la creación de un historial sólido.',
    '1'
  ) RETURNING id INTO v_mod1_id;

  -- Lección 1.1 (Teoría + Quiz)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '1. ¿Qué es Git y el Modelo de Tres Estados?',
    'Comprende la diferencia entre Git y GitHub y los 3 estados: Working Directory, Staging y Repositorio.',
    'quiz',
    1,
    50,
    E'### 🧠 ¿Qué es Git?\nGit es un sistema de **control de versiones distribuido**. Esto significa que cada desarrollador tiene una copia completa del historial en su propia máquina.\n\n### 📂 Los Tres Estados de Git:\n1. **Working Directory (Directorio de Trabajo):** Tus archivos reales en el disco.\n2. **Staging Area (Área de Preparación / Index):** Un archivo intermedio que define qué cambios exactos entrarán en el próximo commit.\n3. **Repository (.git directory):** Donde Git almacena permanentemente las instantáneas (commits) de tu proyecto.',
    '2'
  );

  -- Lección 1.2 (Práctica de comandos)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod1_id,
    '2. Inicialización y Estado del Repositorio',
    'Inicializa un nuevo repositorio Git y analiza el estado de los archivos no rastreados.',
    'logic',
    2,
    60,
    E'### 💻 Comandos Básicos de Inicio:\n- `git init`: Crea un nuevo repositorio local inicializando la carpeta oculta `.git/`.\n- `git status`: Informa qué archivos han sido modificados, añadidos al staging o no rastreados (untracked).\n- `git add <archivo>` o `git add .`: Mueve cambios al Staging Area.',
    '// Simula la secuencia de comandos correcta para inicializar y preparar todos los archivos
function getGitInitCommands() {
  return [
    // TODO: Escribe los dos primeros comandos esenciales
  ];
}',
    'function getGitInitCommands() {
  return ["git init", "git add ."];
}',
    'const cmds = getGitInitCommands(); if (cmds[0] === "git init" && cmds[1] === "git add .") { return true; } throw new Error("Debes retornar [\"git init\", \"git add .\"]");'
  );

  -- Lección 1.3 (Commits y Buenas Prácticas)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '3. Creación de Commits Atómicos y Semánticos',
    'Aprende a capturar instantáneas con `git commit -m` siguiendo el estándar Conventional Commits.',
    'quiz',
    3,
    50,
    E'### 📦 ¿Qué es un Commit?\nUn commit es un snapshot inmutable del proyecto en un momento dado, identificado por un hash SHA-1 (o SHA-256).\n\n### ✍️ Conventional Commits:\n- `feat: nueva funcionalidad`\n- `fix: corrección de un bug`\n- `docs: cambios en la documentación`\n- `refactor: reestructuración de código sin cambiar comportamiento`',
    '1'
  );

  -- Lección 1.4 (Archivos Ignorados con .gitignore)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod1_id,
    '4. Ignorar Archivos y Secretos con .gitignore',
    'Aprende a proteger credenciales, dependencias pesadas y archivos temporales del repositorio.',
    'logic',
    4,
    65,
    E'### 🔒 ¿Por qué usar .gitignore?\nNunca debes subir a Git:\n- Dependencias instalables (`node_modules/`, `venv/`)\n- Variables de entorno y secretos (`.env`, `.env.local`)\n- Archivos de compilación (`dist/`, `build/`)\n- Archivos del sistema operativo (`.DS_Store`, `Thumbs.db`)',
    '// Retorna una lista con las 3 reglas indispensables que todo .gitignore de proyecto web debe contener
function getStandardGitIgnoreRules() {
  return [];
}',
    'function getStandardGitIgnoreRules() {
  return ["node_modules", ".env", "dist"];
}',
    'const rules = getStandardGitIgnoreRules(); if (rules.includes("node_modules") && rules.includes(".env")) { return true; } throw new Error("Debe incluir node_modules y .env");'
  );

  -- ==============================================================================
  -- MÓDULO 2: Ramas Estratégicas y Resolución de Conflictos
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Ramas Estratégicas y Resolución de Conflictos',
    'Aprende a trabajar en paralelo sin romper la rama principal y a resolver conflictos de código.',
    '2'
  ) RETURNING id INTO v_mod2_id;

  -- Lección 2.1 (Creación y Cambio de Ramas)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '5. Gestión de Ramas (Branches)',
    'Aprende cómo funcionan los punteros de ramas y el comando moderno `git switch`.',
    'quiz',
    5,
    50,
    E'### 🌿 ¿Qué es una Rama en Git?\nEn Git, una rama es simplemente un **puntero móvil y ligero** que apunta al último commit de esa línea de desarrollo.\n\n### 🔄 Comandos Clave:\n- `git branch <nombre>`: Crea una nueva rama.\n- `git switch <nombre>`: Cambia a la rama especificada (reemplazo moderno de `git checkout`).\n- `git switch -c <nombre>`: Crea y se posiciona en la nueva rama en un solo paso.',
    '3'
  );

  -- Lección 2.2 (Tipos de Merge: Fast-Forward vs 3-Way)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '6. Estrategias de Fusión: Fast-Forward vs 3-Way Merge',
    'Comprende cómo Git integra el código de dos ramas diferentes.',
    'quiz',
    6,
    55,
    E'### 🔀 Tipos de Fusión (Merge):\n1. **Fast-Forward Merge:** Si la rama principal no tiene commits nuevos desde que se creó la rama secundaria, Git simplemente mueve el puntero hacia adelante.\n2. **3-Way Merge (True Merge):** Si ambas ramas tienen commits independientes, Git crea un nuevo **Merge Commit** que une ambos historiales.',
    '1'
  );

  -- Lección 2.3 (Resolución de Conflictos)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod2_id,
    '7. Anatomía y Resolución de Conflictos',
    'Aprende a interpretar los marcadores `<<<<<<<`, `=======` y `>>>>>>>` al resolver un conflicto.',
    'logic',
    7,
    70,
    E'### ⚔️ ¿Por qué ocurre un Conflicto?\nCuando dos ramas modifican **la misma línea de un archivo** de manera diferente, Git detiene el merge y te pide que decidas qué versión mantener.\n\n### 📄 Marcadores de Conflicto:\n```text\n<<<<<<< HEAD (Tu versión actual)\nconst port = 3000;\n=======\nconst port = 8080;\n>>>>>>> feature/new-port (Versión entrante)\n```',
    '// Resuelve el conflicto seleccionando el puerto unificado 8080
function resolvePortConflict(conflictText) {
  // TODO: Retorna la línea final limpia sin marcadores de conflicto
  return "const port = 8080;";
}',
    'function resolvePortConflict(conflictText) {
  return "const port = 8080;";
}',
    'if (resolvePortConflict("") === "const port = 8080;") { return true; } throw new Error("Debes retornar la línea resuelta.");'
  );

  -- Lección 2.4 (Guardado Temporal con Git Stash)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '8. Pausar y Guardar Cambios con `git stash`',
    'Aprende a guardar cambios no confirmados para cambiar de rama rápidamente.',
    'quiz',
    8,
    50,
    E'### 📦 ¿Para qué sirve `git stash`?\nSi estás a mitad de una tarea y necesitas cambiar de rama con urgencia para corregir un bug, `git stash` guarda tus modificaciones en un espacio temporal y deja tu directorio de trabajo limpio.\n\n- `git stash`: Guarda el trabajo actual.\n- `git stash pop`: Restaura y elimina el último estado guardado.',
    '2'
  );

  -- ==============================================================================
  -- MÓDULO 3: Colaboración Remota y GitHub
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Colaboración Remota y GitHub',
    'Sincroniza proyectos con repositorios remotos, domina el flujo de Pull Requests y técnicas avanzadas.',
    '3'
  ) RETURNING id INTO v_mod3_id;

  -- Lección 3.1 (Remotos: origin, fetch, pull, push)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '9. Sincronización Remota: Fetch, Pull y Push',
    'Comprende la diferencia fundamental entre `git fetch` y `git pull`.',
    'quiz',
    9,
    55,
    E'### 🌐 Operaciones Remotas:\n- `git remote add origin <URL>`: Vincula tu repositorio local con el servidor en la nube (GitHub).\n- `git push -u origin <rama>`: Sube tus commits locales al servidor remoto.\n- `git fetch`: Descarga los cambios del servidor **sin** fusionarlos con tu código.\n- `git pull`: Realiza un `git fetch` seguido automáticamente de un `git merge`.',
    '4'
  );

  -- Lección 3.2 (Pull Requests y Code Reviews en GitHub)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '10. El Flujo de Pull Requests y Revisión de Código',
    'Aprende cómo los equipos de ingeniería proponen, discuten y aprueban cambios antes del merge.',
    'quiz',
    10,
    55,
    E'### 🤝 ¿Qué es un Pull Request (PR)?\nUn Pull Request es una solicitud formal en GitHub para que otros miembros del equipo revisen tu rama de características antes de que se fusione con la rama de producción (`main`).\n\nPermite:\n- Ejecutar pruebas automáticas de CI/CD.\n- Dejar comentarios línea por línea.\n- Proteger la rama principal contra errores humanos.',
    '1'
  );

  -- Lección 3.3 (Git Rebase vs Git Merge)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '11. Reorganización del Historial: Rebase vs Merge',
    'Comprende cuándo usar `git rebase` para mantener un historial lineal y limpio.',
    'quiz',
    11,
    60,
    E'### 📜 Merge vs Rebase:\n- `git merge`: Preserva la historia exacta y crea un commit de fusión explícito.\n- `git rebase`: Mueve la base de tu rama al commit más reciente de `main`, reescribiendo los commits para que el historial parezca una línea recta y limpia.\n\n⚠️ **Regla de Oro:** ¡Nunca hagas rebase sobre una rama pública compartida por otros desarrolladores!',
    '2'
  );

  -- Lección 3.4 (Cherry-Pick y Deshacer Cambios)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod3_id,
    '12. Cirugía de Código con `cherry-pick` y `revert`',
    'Aprende a aplicar commits específicos de otra rama y a deshacer cambios en producción de forma segura.',
    'logic',
    12,
    75,
    E'### 🍒 Comandos de Precisión:\n- `git cherry-pick <hash>`: Toma un commit específico de cualquier rama y lo aplica directamente en tu rama actual.\n- `git revert <hash>`: Crea un **nuevo commit** que invierte exactamente los cambios de un commit anterior, ideal para deshacer errores en ramas públicas sin alterar el historial.',
    '// Retorna el comando de Git para deshacer de forma segura un commit con hash "abc1234"
function getSafeRevertCommand(commitHash) {
  // TODO: Genera el comando de revert
  return `git revert ${commitHash}`;
}',
    'function getSafeRevertCommand(commitHash) {
  return `git revert ${commitHash}`;
}',
    'if (getSafeRevertCommand("abc1234") === "git revert abc1234") { return true; } throw new Error("Debes retornar git revert <hash>");'
  );

END $$;
