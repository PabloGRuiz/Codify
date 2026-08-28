-- ==============================================================================
-- 🚀 CODIFY SEED: 19 - CURSO TEÓRICO COMPLETO: CONTROL DE VERSIONES CON GIT & GITHUB
-- ==============================================================================
-- Curso 100% interactivo mediante cuestionarios profundos (quizzes con 5+ preguntas por lección)
-- Diseñado para preparar al estudiante en el uso de repositorios y publicación de Proyectos Integradores.

DO $SEED_GIT$
DECLARE
  v_author_id UUID;
  v_prereq_id UUID;
  v_course_id UUID;
  v_mod1_id UUID;
  v_mod2_id UUID;
BEGIN

  -- 1. Obtener autor de referencia o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Obtener curso prerrequisito (Fundamentos IT y Lógica)
  SELECT id INTO v_prereq_id FROM public.courses WHERE title ILIKE '%Fundamentos IT%' LIMIT 1;

  -- 3. Limpiar curso previo si existe para regenerarlo limpio
  DELETE FROM public.courses WHERE title ILIKE '%Git & GitHub%' OR title ILIKE '%Control de Versiones%';

  -- 4. Crear el Curso Oficial de Git & GitHub
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
    'Control de Versiones y Repositorios con Git & GitHub',
    'Aprende desde cero qué es un repositorio, el ciclo de vida de los archivos, ramas, resolución de conflictos y cómo publicar tus proyectos en GitHub para la comunidad.',
    E'## 🚀 Acerca del Curso\n\nEl control de versiones con Git es el pilar indispensable de todo desarrollador de software. Este curso teórico y conceptual te enseñará la totalidad de los comandos fundamentales, el ciclo de vida de los datos y el flujo de trabajo para crear, clonar y publicar repositorios en GitHub.',
    ARRAY['Teórico', 'Git', 'GitHub', 'DevOps', 'Herramientas', 'Colaboración'],
    v_prereq_id,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Concepto de Repositorio y Flujo de Trabajo Local
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 1: Repositorios, Estados y Comandos Esenciales',
    'Comprende qué es un repositorio, la arquitectura interna de Git y los comandos del día a día.'
  ) RETURNING id INTO v_mod1_id;

  -- LECCIÓN 1.1: ¿Qué es un Repositorio y el Control de Versiones?
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_mod1_id,
    '1. ¿Qué es un Repositorio y el Control de Versiones?',
    'Comprende por qué necesitamos Git, qué es un repositorio y cómo almacena el historial de forma inmutable.',
    'quiz',
    100,
    $THEORY$# ¿Qué es un Repositorio y el Control de Versiones?

El **control de versiones** es un sistema que registra los cambios realizados sobre un conjunto de archivos a lo largo del tiempo, permitiendo recuperar versiones específicas en cualquier momento.

---

### 1. El Problema del Guardado Manual
Antes del control de versiones, los programadores guardaban copias manuales como:
`proyecto_v1.zip`, `proyecto_final.zip`, `proyecto_final_FINAL_ahora_si.zip`.

Este método presenta fallas críticas:
- No se sabe **quién** hizo qué cambio ni **por qué**.
- Es imposible trabajar en equipo sobre el mismo archivo sin sobrescribir el trabajo del compañero.
- No hay forma segura de volver atrás si algo se rompe.

---

### 2. ¿Qué es un Repositorio (Repo)?
Un **repositorio** es una estructura de datos que almacena el árbol completo de archivos de tu proyecto junto con todo el historial cronológico e inmutable de modificaciones.

- **Carpeta `.git`:** Cuando inicializas un repositorio, Git crea una carpeta oculta llamada `.git/` en la raíz. Todo el historial, ramas, configuraciones y registros viven dentro de este directorio.
- **Snapshots (Instantáneas):** A diferencia de otros sistemas antiguos que guardaban diferencias parciales (deltas), Git almacena el estado completo de los archivos como **instantáneas en miniatura** a través de commits.

---

### 3. Sistema Distribuido vs Centralizado
Git es un sistema **distribuido (DVCS)**:
- Cada desarrollador que clona un repositorio descarga una **copia completa y exacta** de toda la base de datos del proyecto con todo su historial.
- Si el servidor central (como GitHub) se cayera, cualquier copia local de cualquier programador puede usarse para restaurar el repositorio por completo.
$THEORY$,
    $QUIZ$[
      {
        "id": "q1",
        "question": "¿Qué es un repositorio en Git?",
        "options": [
          "Un servidor en la nube exclusivo para ejecutar código",
          "Una carpeta que contiene los archivos de un proyecto junto con todo el historial de cambios guardado en el directorio oculto .git",
          "Un archivo comprimido .zip que no se puede modificar",
          "Un lenguaje de programación para automatizar despliegues"
        ],
        "correctIndex": 1,
        "explanation": "Un repositorio es el contenedor del proyecto que almacena los archivos y la base de datos de historial completa en el directorio .git."
      },
      {
        "id": "q2",
        "question": "¿Qué significa que Git sea un sistema de control de versiones 'distribuido'?",
        "options": [
          "Que solo existe una única copia del proyecto alojada en un servidor central obligatorio",
          "Que cada desarrollador tiene una copia local completa del historial y no depende de conexión constante para trabajar y hacer commits",
          "Que divide el código en fragmentos aleatorios entre varias computadoras",
          "Que requiere de Internet continuo para registrar cualquier cambio local"
        ],
        "correctIndex": 1,
        "explanation": "En Git, cada clon es un repositorio completo con todo el historial, lo que permite trabajar localmente y otorga máxima redundancia."
      },
      {
        "id": "q3",
        "question": "¿Dónde almacena Git internamente toda la información del historial, ramas y configuraciones de un repositorio local?",
        "options": [
          "En el registro del sistema operativo Windows/Linux",
          "En una carpeta oculta en la raíz del proyecto llamada .git",
          "En un archivo de texto llamado config.txt",
          "En la memoria RAM temporal que se borra al apagar el equipo"
        ],
        "correctIndex": 1,
        "explanation": "Toda la 'magia' y base de datos de Git reside dentro del directorio .git ubicado en la raíz del proyecto."
      },
      {
        "id": "q4",
        "question": "¿Cómo almacena Git conceptualmente la información en cada commit?",
        "options": [
          "Como instantáneas (snapshots) del estado del proyecto en ese instante",
          "Como simples diferencias de texto línea por línea aisladas",
          "Como capturas de pantalla de la interfaz gráfica",
          "Como grabaciones de video de la pantalla del desarrollador"
        ],
        "correctIndex": 0,
        "explanation": "Git modela sus datos como un conjunto de instantáneas (snapshots) de un sistema de archivos en miniatura."
      },
      {
        "id": "q5",
        "question": "¿Cuál es la principal desventaja de controlar versiones mediante nombres manuales de carpetas (ej. proyecto_v2_final)?",
        "options": [
          "Ocupa menos espacio en disco",
          "No permite trazabilidad de autoría, imposibilita el trabajo en paralelo y no garantiza integridad del historial",
          "Hace que el código se compile más rápido",
          "Es incompatible con editores de texto"
        ],
        "correctIndex": 1,
        "explanation": "Las copias manuales generan desorden, pérdida de código por sobreescritura y nula visibilidad sobre quién cambió qué y por qué."
      }
    ]$QUIZ$,
    1
  );

  -- LECCIÓN 1.2: El Ciclo de Vida de los Archivos y los Tres Estados de Git
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_mod1_id,
    '2. Los 3 Estados de Git y el Ciclo de Vida de Archivos',
    'Domina los estados: Working Directory, Staging Area y Repositorio, junto a los comandos init, add, status y commit.',
    'quiz',
    100,
    $THEORY$# Los Tres Estados de Git y Comandos Esenciales

Para entender Git, es indispensable comprender las **tres zonas** por las que viaja tu código antes de quedar registrado en la historia del proyecto.

---

### 1. Las Tres Áreas de Git
1. **Working Tree (Directorio de Trabajo):**
   Es la copia de los archivos en tu disco donde estás escribiendo código. Aquí los archivos pueden estar modificados, pero Git aún no los tiene preparados para guardar.
2. **Staging Area / Index (Área de Preparación):**
   Es una zona intermedia donde seleccionas con precisión quirúrgica **cuáles cambios específicos** formarán parte del siguiente commit.
3. **Git Directory / Repository (`HEAD`):**
   Es la base de datos permanente donde los commits quedan guardados de forma inmutable.

```text
[ Working Tree ]  --( git add )-->  [ Staging Area ]  --( git commit )-->  [ Repository (.git) ]
```

---

### 2. Ciclo de Vida de un Archivo
- **Untracked (No rastreado):** Archivo nuevo que Git nunca ha visto.
- **Tracked (Rastreado):** Archivo que ya forma parte del repositorio.
  - **Unmodified (Sin cambios):** Idéntico al último commit.
  - **Modified (Modificado):** Se ha editado en el Working Tree.
  - **Staged (Preparado):** Listo en el Staging Area para el próximo commit.

---

### 3. Comandos Esenciales del Día a Día
- **`git init`**: Inicializa un repositorio Git nuevo en la carpeta actual.
- **`git status`**: El comando más usado; muestra el estado actual (archivos modificados, en staging o untracked).
- **`git add <archivo>`**: Añade un archivo específico al Staging Area.
- **`git add .`**: Añade **todos** los archivos modificados y nuevos del directorio actual al Staging Area.
- **`git commit -m "mensaje"`**: Empaqueta todo lo que está en Staging Area y crea un commit permanente con un mensaje explicativo.
$THEORY$,
    $QUIZ$[
      {
        "id": "q1",
        "question": "¿Cuál es el propósito del 'Staging Area' (Área de Preparación) en Git?",
        "options": [
          "Compilar el código antes de ejecutarlo",
          "Permitir al desarrollador seleccionar y organizar exactamente qué cambios modificados se incluirán en el próximo commit",
          "Subir el código a GitHub inmediatamente sin confirmación",
          "Eliminar archivos temporales de forma irreversible"
        ],
        "correctIndex": 1,
        "explanation": "El Staging Area actúa como un filtro donde eliges qué archivos formarán parte del siguiente commit de forma atómica y ordenada."
      },
      {
        "id": "q2",
        "question": "¿Qué comando se utiliza para comenzar a rastrear un nuevo proyecto e inicializar la carpeta .git?",
        "options": [
          "git start",
          "git create",
          "git init",
          "git new-repo"
        ],
        "correctIndex": 2,
        "explanation": "git init inicializa un nuevo repositorio de Git en el directorio de trabajo actual."
      },
      {
        "id": "q3",
        "question": "Si acabas de modificar 'index.html' y ejecutas 'git add index.html', ¿a qué estado pasa el archivo?",
        "options": [
          "Untracked",
          "Staged (Preparado en el Staging Area)",
          "Committed (Guardado en el repositorio)",
          "Ignored"
        ],
        "correctIndex": 1,
        "explanation": "git add traslada las modificaciones del archivo al Staging Area (estado 'staged'), listo para ser commiteado."
      },
      {
        "id": "q4",
        "question": "¿Qué comando te permite verificar en cualquier momento qué archivos están modificados, cuáles están en staging y en qué rama estás?",
        "options": [
          "git status",
          "git check",
          "git info",
          "git list"
        ],
        "correctIndex": 0,
        "explanation": "git status es el comando fundamental de inspección que detalla el estado actual del Working Tree y del Staging Area."
      },
      {
        "id": "q5",
        "question": "¿Qué realiza la instrucción 'git commit -m \"feat: agregar login de usuarios\"'?",
        "options": [
          "Sube los cambios a los servidores de GitHub",
          "Crea una instantánea permanente en el historial local con todos los archivos que estaban en el Staging Area",
          "Borra los archivos no confirmados",
          "Descarga la última versión de internet"
        ],
        "correctIndex": 1,
        "explanation": "git commit empaqueta los cambios del Staging Area en un commit con un identificador único (hash) y un mensaje descriptivo en el repositorio local."
      }
    ]$QUIZ$,
    2
  );

  -- LECCIÓN 1.3: Buenas Prácticas de Commits, .gitignore e Inspección
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_mod1_id,
    '3. Buenas Prácticas de Commits, .gitignore y git log',
    'Aprende a escribir mensajes atómicos, proteger secretos y dependencias con .gitignore y auditar la historia con git log y git diff.',
    'quiz',
    100,
    $THEORY$# Buenas Prácticas: Commits Atómicos, .gitignore y Logs

Un buen historial en Git debe ser claro y legible como un libro técnico. Para lograrlo, seguimos estándares de la industria.

---

### 1. Commits Atómicos y Mensajes Semánticos
Un **commit atómico** significa que cada commit debe resolver **una sola tarea o funcionalidad lógica**.
- ❌ **Mal commit:** Un solo commit con 40 archivos cambiados con mensaje `"cambios"`, `"arreglos varios"` o `"asdf"`.
- ✅ **Buen commit:** Commits pequeños y concisos siguiendo convenciones como **Conventional Commits**:
  - `feat: implementar autenticación con JWT`
  - `fix: corregir cálculo de impuestos en el checkout`
  - `docs: actualizar guía de instalación en README`
  - `refactor: optimizar consulta de usuarios`

---

### 2. El Archivo `.gitignore`
Es un archivo de texto especial ubicado en la raíz del proyecto que le indica a Git qué archivos o carpetas **debe ignorar por completo** y jamás rastrear ni subir.

#### ¿Qué DEBE ir en `.gitignore`?
- **Dependencias pesadas:** `node_modules/`, `vendor/`, `venv/`.
- **Variables de entorno y secretos:** `.env`, `.env.local`, llaves privadas (API keys, passwords de BD).
- **Carpetas de compilación o build:** `dist/`, `build/`, `.next/`, `target/`.
- **Archivos del sistema operativo:** `.DS_Store`, `Thumbs.db`.

> ⚠️ **Regla de Oro:** ¡Nunca subas contraseñas, tokens o archivos `.env` a Git! Una vez subidos al historial, quedan expuestos públicamente.

---

### 3. Inspección del Historial
- **`git log`**: Muestra la lista cronológica de todos los commits realizados, su autor, fecha y hash único.
- **`git log --oneline --graph`**: Visualización compacta y gráfica del árbol de commits.
- **`git diff`**: Muestra las diferencias exactas línea por línea entre lo que modificaste y el último commit guardado.
- **`git restore <archivo>`**: Descarta los cambios no guardados en el Working Tree y restaura el archivo al estado del último commit.
$THEORY$,
    $QUIZ$[
      {
        "id": "q1",
        "question": "¿Por qué es crucial crear un archivo '.gitignore' en la raíz de un proyecto de software?",
        "options": [
          "Para acelerar la velocidad de internet",
          "Para evitar rastrear y subir dependencias pesadas (node_modules), archivos de compilación y secretos sensibles (.env)",
          "Para impedir que otros usuarios descarguen el código",
          "Porque sin ese archivo Git no permite hacer commits"
        ],
        "correctIndex": 1,
        "explanation": ".gitignore previene que subamos archivos innecesarios, carpetas gigantescas de dependencias o credenciales críticas a los repositorios."
      },
      {
        "id": "q2",
        "question": "¿Cuál de los siguientes es un ejemplo de mensaje de commit siguiendo el estándar profesional de 'Conventional Commits'?",
        "options": [
          "cambios_viernes",
          "fix: corregir validación de email en formulario de registro",
          "arreglando cosas que se rompieron",
          "final 2"
        ],
        "correctIndex": 1,
        "explanation": "'fix: corregir validación...' sigue la convención semántica indicando tipo (fix), ámbito y descripción precisa de la acción."
      },
      {
        "id": "q3",
        "question": "¿Qué comando te permite examinar el historial cronológico completo de commits con su autor, fecha y mensaje?",
        "options": [
          "git history",
          "git log",
          "git audit",
          "git records"
        ],
        "correctIndex": 1,
        "explanation": "git log es el comando para revisar la cronología de commits y metadatos del repositorio."
      },
      {
        "id": "q4",
        "question": "¿Qué muestra el comando 'git diff'?",
        "options": [
          "La diferencia de velocidad entre dos computadoras",
          "Los cambios exactos línea por línea entre tu código actual en el directorio de trabajo y el último commit",
          "La lista de usuarios conectados a la red",
          "El espacio restante en el disco duro"
        ],
        "correctIndex": 1,
        "explanation": "git diff compara el estado actual contra el último commit (o el staging) mostrando líneas añadidas (+) y eliminadas (-)."
      },
      {
        "id": "q5",
        "question": "Si modificaste un archivo por error y deseas descartar tus cambios en el Working Tree para que vuelva al estado del último commit, ¿qué comando utilizas?",
        "options": [
          "git delete <archivo>",
          "git restore <archivo>",
          "git undo-all",
          "git clean-hard"
        ],
        "correctIndex": 1,
        "explanation": "git restore <archivo> descarta las modificaciones no preparadas del archivo seleccionado, devolviéndolo a su último estado confirmado."
      }
    ]$QUIZ$,
    3
  );

  -- ==============================================================================
  -- MÓDULO 2: Ramas, Resolución de Conflictos y GitHub
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description)
  VALUES (
    v_course_id,
    'Módulo 2: Ramas, Conflictos y Trabajo Remoto en GitHub',
    'Aprende a trabajar con branches, resolver conflictos y dominar el flujo con GitHub.'
  ) RETURNING id INTO v_mod2_id;

  -- LECCIÓN 2.1: Gestión de Ramas (Branches) y Fusiones (Merges)
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_mod2_id,
    '4. Ramas (Branches), Integración y Conflictos',
    'Comprende qué es una rama, cómo aislar funcionalidades y cómo resolver conflictos al fusionar código.',
    'quiz',
    100,
    $THEORY$# Ramas (Branches), Integración y Conflictos

Las **ramas (branches)** son una de las características más potentes de Git: permiten bifurcar la línea principal de desarrollo para trabajar en nuevas funciones o experimentos sin poner en riesgo el código estable en producción.

---

### 1. ¿Qué es una Rama en Git?
En Git, una rama es simplemente un **puntero móvil y ligero** que apunta a un commit específico. Crear una rama es una operación casi instantánea que no duplica archivos en tu disco.

- **`main` (o `master`):** Es la rama principal por defecto que contiene el código estable y listo para producción.
- **Ramas de funcionalidad (`feature branches`):** Ej. `feature/login`, `fix/nav-bug`. Aquí desarrollas tus cambios aislados.

---

### 2. Comandos para Gestionar Ramas
- **`git branch`**: Lista todas las ramas locales existentes y marca con un `*` en cuál te encuentras.
- **`git branch <nombre>`**: Crea una nueva rama pero no se mueve a ella.
- **`git switch <nombre>`** (o `git checkout <nombre>`): Cambia tu espacio de trabajo a la rama indicada.
- **`git switch -c <nombre>`** (o `git checkout -b <nombre>`): **Crea y salta** a la nueva rama en un solo paso.
- **`git merge <rama-origen>`**: Estando parado en la rama destino (ej. `main`), integra los commits de la rama origen.

---

### 3. Tipos de Merge y Conflictos
1. **Fast-Forward Merge:** Ocurre cuando la rama destino no ha recibido commits nuevos desde que se creó la rama secundaria. Git simplemente avanza el puntero hacia adelante.
2. **3-Way Merge (Merge Commit):** Ocurre cuando ambas ramas avanzaron de forma independiente. Git genera un commit especial de unión que tiene dos padres.
3. **Conflictos de Fusión:** Ocurre cuando dos ramas modificaron **las mismas líneas del mismo archivo** de manera distinta.
   Git pausa el merge e inserta **marcadores de conflicto**:
   ```text
   <<<<<<< HEAD (Tu rama actual)
   const apiUrl = "https://api.empresa.com";
   =======
   const apiUrl = "https://staging.empresa.com";
   >>>>>>> feature/api-staging (Rama entrante)
   ```
   **Solución:** El desarrollador edita el archivo, elige la versión correcta (o combina ambas), elimina los marcadores (`<<<<<<<`, `=======`, `>>>>>>>`), hace `git add <archivo>` y finaliza con `git commit`.
$THEORY$,
    $QUIZ$[
      {
        "id": "q1",
        "question": "¿Qué es conceptualmente una 'rama' (branch) en Git?",
        "options": [
          "Una copia física duplicada de toda la carpeta del proyecto en otra partición del disco",
          "Un puntero ligero y móvil que hace referencia al último commit de una línea de desarrollo independiente",
          "Un archivo ejecutable que compila el código",
          "Un permiso de administrador en GitHub"
        ],
        "correctIndex": 1,
        "explanation": "Las ramas en Git son punteros extremadamente ligeros que apuntan a un commit, permitiendo ramificar el trabajo sin coste de rendimiento."
      },
      {
        "id": "q2",
        "question": "¿Cuál es el comando moderno para crear una nueva rama llamada 'feature/perfil' y posicionarse inmediatamente en ella?",
        "options": [
          "git create branch feature/perfil",
          "git switch -c feature/perfil",
          "git branch --goto feature/perfil",
          "git make feature/perfil"
        ],
        "correctIndex": 1,
        "explanation": "git switch -c <nombre> (o git checkout -b <nombre>) crea la rama y se posiciona en ella de manera inmediata."
      },
      {
        "id": "q3",
        "question": "Si estás en la rama 'main' y deseas fusionar los cambios de la rama 'feature/login', ¿qué comando ejecutas?",
        "options": [
          "git merge feature/login",
          "git combine feature/login into main",
          "git pull feature/login",
          "git join feature/login"
        ],
        "correctIndex": 0,
        "explanation": "Estando ubicado en la rama receptora ('main'), el comando 'git merge feature/login' integra el historial de la rama secundaria."
      },
      {
        "id": "q4",
        "question": "¿Por qué ocurre un conflicto de fusión (merge conflict) en Git?",
        "options": [
          "Porque se terminó el espacio en disco",
          "Porque dos ramas modificaron las mismas líneas del mismo archivo de forma diferente y Git no puede decidir automáticamente cuál versión mantener",
          "Porque los nombres de las ramas son idénticos",
          "Porque el archivo .gitignore está vacío"
        ],
        "correctIndex": 1,
        "explanation": "Los conflictos suceden ante modificaciones superpuestas en las mismas líneas; Git requiere que un humano decida qué código conservar."
      },
      {
        "id": "q5",
        "question": "Al resolver un conflicto en un archivo, ¿qué debes hacer con los marcadores '<<<<<<< HEAD', '=======' y '>>>>>>>'?",
        "options": [
          "Dejarlos en el código para que el compilador los interprete",
          "Borrarlos manualmente tras dejar el código final resuelto y luego hacer git add y git commit",
          "Renombrar el archivo a .conflict",
          "Reiniciar la computadora"
        ],
        "correctIndex": 1,
        "explanation": "Los marcadores de conflicto son indicadores visuales temporales que deben eliminarse completamente antes de confirmar el merge."
      }
    ]$QUIZ$,
    4
  );

  -- LECCIÓN 2.2: Trabajo con Repositorios Remotos en GitHub y Proyectos Integradores
  INSERT INTO public.challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_mod2_id,
    '5. Repositorios Remotos en GitHub y Publicación de Proyectos',
    'Aprende a vincular tu repo local con GitHub, sincronizar cambios con push y pull, y el flujo para publicar Proyectos Integradores en Codify.',
    'quiz',
    100,
    $THEORY$# Trabajo Remoto con GitHub y Publicación de Proyectos

Hasta ahora hemos trabajado con Git en tu computadora local. Sin embargo, para colaborar con otros programadores, tener respaldo en la nube y **publicar tus Proyectos Integradores en la comunidad de Codify**, necesitamos conectar Git con **GitHub**.

---

### 1. Git vs GitHub: La Diferencia Fundamental
- **Git:** Es la herramienta de software (CLI) que se ejecuta en tu máquina para registrar versiones.
- **GitHub:** Es una plataforma web en la nube que aloja repositorios Git remotos, facilitando la colaboración, revisión de código y portafolios públicos.

---

### 2. Flujo Completo: De Proyecto Local a GitHub
1. **Crear repositorio en GitHub:** En tu cuenta de GitHub creas un nuevo repositorio (ej. `mi-proyecto-integrador`).
2. **Vincular el remoto local:**
   ```bash
   git remote add origin https://github.com/tu-usuario/mi-proyecto-integrador.git
   ```
   - `origin` es el alias o apodo estándar que se le da a la URL del servidor remoto principal.
3. **Subir los cambios por primera vez:**
   ```bash
   git push -u origin main
   ```
   - `-u` (upstream) vincula tu rama local `main` con la rama remota `main` de GitHub.

---

### 3. Comandos de Sincronización Remota
- **`git clone <url>`**: Descarga un repositorio remoto completo de GitHub a tu computadora local en una carpeta nueva.
- **`git push`**: Sube tus commits locales hacia el repositorio remoto en GitHub.
- **`git pull`**: Descarga e integra automáticamente los commits nuevos que otros hayan subido al repositorio remoto hacia tu rama local (`git fetch` + `git merge`).
- **`git remote -v`**: Lista los alias y URLs de los repositorios remotos configurados.

---

### 4. Flujo para Proyectos Integradores en Codify
Para presentar y validar tus **Proyectos Integradores** en el Foro de Codify:
1. Creas el código de tu proyecto en tu editor local.
2. Inicializas Git (`git init`), preparas archivos (`git add .`) y confirmas (`git commit -m "feat: proyecto final"`).
3. Creas un repositorio público en tu cuenta de GitHub.
4. Conectas el remoto (`git remote add origin ...`) y subes tu código (`git push -u origin main`).
5. Copias el enlace público de tu repositorio de GitHub y lo compartes en el Foro de Codify para que los profesores y la comunidad evalúen tu proyecto.
$THEORY$,
    $QUIZ$[
      {
        "id": "q1",
        "question": "¿Cuál es la diferencia principal entre Git y GitHub?",
        "options": [
          "Git es para Windows y GitHub es para Mac",
          "Git es la herramienta de control de versiones que corre localmente; GitHub es una plataforma en la nube que aloja y comparte repositorios Git remotos",
          "Son exactamente lo mismo con dos nombres comerciales",
          "GitHub es un lenguaje de programación derivado de Git"
        ],
        "correctIndex": 1,
        "explanation": "Git es el motor de control de versiones local; GitHub es el servicio de alojamiento en la nube para colaborar y compartir esos repositorios."
      },
      {
        "id": "q2",
        "question": "¿Qué comando se utiliza para descargar una copia completa de un repositorio existente de GitHub a tu máquina?",
        "options": [
          "git download <url>",
          "git clone <url>",
          "git copy-repo <url>",
          "git get <url>"
        ],
        "correctIndex": 1,
        "explanation": "git clone descarga todo el repositorio remoto, archivos y base de datos histórica a una carpeta local."
      },
      {
        "id": "q3",
        "question": "¿Qué comando asocia tu repositorio local con una URL remota en GitHub asignándole el alias estándar 'origin'?",
        "options": [
          "git link <url>",
          "git remote add origin <url>",
          "git connect-github <url>",
          "git server set <url>"
        ],
        "correctIndex": 1,
        "explanation": "git remote add origin <url> vincula el alias 'origin' con la dirección del repositorio en GitHub."
      },
      {
        "id": "q4",
        "question": "¿Qué comando envía tus commits locales recién confirmados hacia el repositorio remoto en GitHub?",
        "options": [
          "git push",
          "git pull",
          "git upload",
          "git send"
        ],
        "correctIndex": 0,
        "explanation": "git push transfiere los commits de tu rama local a la rama correspondiente en el servidor remoto."
      },
      {
        "id": "q5",
        "question": "En Codify, ¿cuál es el requisito y flujo indispensable para entregar un Proyecto Integrador ante la comunidad y los profesores?",
        "options": [
          "Enviar un archivo comprimido .zip por correo electrónico privado",
          "Tener el proyecto versionado con Git, publicado en un repositorio público de GitHub y compartir su enlace en el Foro de Codify",
          "Pegar miles de líneas de código en un mensaje de chat",
          "Subir capturas de pantalla a redes sociales"
        ],
        "correctIndex": 1,
        "explanation": "El estándar profesional exige publicar el proyecto en un repositorio público de GitHub con su historial de Git y compartir el link para revisión."
      }
    ]$QUIZ$,
    5
  );

END $SEED_GIT$;
