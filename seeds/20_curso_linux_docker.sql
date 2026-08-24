-- ==============================================================================
-- 🚀 CODIFY SEED: 20 - CURSO COMPLETO: VIRTUALIZACIÓN, LINUX & DOCKER
-- ==============================================================================
-- Este script inserta:
-- 1. Curso: "Virtualización, Linux Server & Contenedores con Docker" con Ficha Técnica
-- 2. Prerrequisito enlazado a "Fundamentos IT y Lógica" con Nivel 2 requerido
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

  -- 3. Crear o actualizar el curso de Linux y Docker
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
    'Virtualización, Linux Server & Contenedores con Docker',
    'Domina la infraestructura moderna: aprende a administrar servidores Linux, empaquetar aplicaciones en contenedores Docker y orquestar entornos con Docker Compose.',
    E'## 🚀 Acerca del Curso\n\nEl 90% de los servidores en la nube y los despliegues empresariales corren sobre Linux y contenedores Docker. Este curso te guiará desde los conceptos clave de la terminal de Linux hasta convertirte en un profesional capaz de empaquetar, aislar y orquestar arquitecturas complejas de microservicios.\n\n### 🎯 ¿Qué aprenderás?\n- **Linux Server Administration:** Jerarquía de directorios (FHS), permisos octales (`chmod 755`), propietarios (`chown`), demonios y servicios del sistema (`systemctl`).\n- **Seguridad y Acceso Remoto:** Conexiones encriptadas con SSH, generación de pares de llaves y túneles seguros.\n- **Virtualización vs Contenedores:** Aislamiento a nivel de Kernel (Namespaces y Cgroups) vs Hipervisores Tipo 1 y 2.\n- **Dominio de Docker:** Ciclo de vida de contenedores (`run`, `exec`, `logs`), mapeo de puertos y variables de entorno.\n- **Optimización de Dockerfiles:** Creación de imágenes ligeras, capas de caché, directivas `WORKDIR`, `COPY`, `RUN` y `CMD`.\n- **Persistencia y Redes:** Volúmenes Docker, bind mounts y puentes de red (Bridge Networks).\n- **Orquestación con Docker Compose:** Definición declarativa de arquitecturas multicontenedor (Frontend + Backend + PostgreSQL).\n\n### 👥 ¿A quién está dirigido?\nEstudiantes de sistemas, desarrolladores de software y aspirantes a DevOps / Cloud Engineers.',
    ARRAY['Práctico', 'Linux', 'Docker', 'DevOps', 'Servidores', 'SysAdmin'],
    v_prereq_id,
    2,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Fundamentos de Linux Server y Línea de Comandos
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Fundamentos de Linux Server y Línea de Comandos',
    'Domina la jerarquía del sistema, la administración de usuarios, permisos y servicios esenciales en servidores Linux.',
    '1'
  ) RETURNING id INTO v_mod1_id;

  -- Lección 1.1 (Jerarquía de Directorios FHS)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '1. La Estructura del Sistema de Archivos Linux (FHS)',
    'Aprende dónde se almacenan las configuraciones, registros y ejecutables en Linux.',
    'quiz',
    1,
    50,
    E'### 📁 Filesystem Hierarchy Standard (FHS):\nEn Linux no existen unidades como `C:` o `D:`; todo cuelga de la raíz `/`.\n- `/etc`: Archivos de configuración del sistema (ej: `/etc/nginx/`, `/etc/ssh/`).\n- `/var/log`: Registros y bitácoras del sistema y aplicaciones.\n- `/bin` y `/usr/bin`: Ejecutables y comandos del usuario.\n- `/home`: Directorios personales de cada usuario.',
    '1'
  );

  -- Lección 1.2 (Permisos y chmod/chown)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod1_id,
    '2. Permisos y Notación Octal con `chmod`',
    'Calcula y asigna permisos de Lectura (4), Escritura (2) y Ejecución (1).',
    'logic',
    2,
    60,
    E'### 🔐 Cálculo de Permisos en Linux:\nCada archivo tiene 3 grupos de permisos: **Usuario (Owner)**, **Grupo (Group)** y **Otros (Others)**.\n- **Lectura (r):** 4\n- **Escritura (w):** 2\n- **Ejecución (x):** 1\n\nEjemplo: `rwx r-x r-x` = (4+2+1) (4+0+1) (4+0+1) = `755`',
    '// Retorna el comando para otorgar permisos 755 al script "deploy.sh"
function getChmodCommand(filename) {
  // TODO: Genera el comando chmod
  return `chmod 755 ${filename}`;
}',
    'function getChmodCommand(filename) {
  return `chmod 755 ${filename}`;
}',
    'if (getChmodCommand("deploy.sh") === "chmod 755 deploy.sh") { return true; } throw new Error("Debes retornar chmod 755 deploy.sh");'
  );

  -- Lección 1.3 (Servicios con systemctl)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod1_id,
    '3. Control de Servicios con `systemctl`',
    'Aprende a iniciar, detener y habilitar demonios del sistema con systemd.',
    'quiz',
    3,
    50,
    E'### ⚙️ El Administrador de Servicios Systemd:\n- `systemctl start <servicio>`: Inicia el servicio en este momento.\n- `systemctl enable <servicio>`: Configura el servicio para que arranque automáticamente al encender el servidor.\n- `systemctl status <servicio>`: Muestra si el servicio está activo o tuvo errores.',
    '2'
  );

  -- Lección 1.4 (Acceso Remoto Seguro con SSH)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod1_id,
    '4. Autenticación con Llaves SSH',
    'Aprende a generar llaves criptográficas y conectarte a un servidor remoto de forma segura.',
    'logic',
    4,
    65,
    E'### 🔑 SSH (Secure Shell):\nEn lugar de contraseñas vulnerables, los servidores en producción usan criptografía asimétrica:\n- **Llave privada (`id_rsa`):** Se queda en tu máquina local y NUNCA se comparte.\n- **Llave pública (`id_rsa.pub`):** Se instala en el servidor en el archivo `~/.ssh/authorized_keys`.\n- Comando de conexión: `ssh usuario@ip_servidor`',
    '// Genera la cadena de conexión SSH para el usuario "ubuntu" en la IP "192.168.1.50"
function generateSSHConnection(user, host) {
  return `ssh ${user}@${host}`;
}',
    'function generateSSHConnection(user, host) {
  return `ssh ${user}@${host}`;
}',
    'if (generateSSHConnection("ubuntu", "192.168.1.50") === "ssh ubuntu@192.168.1.50") { return true; } throw new Error("Debes retornar ssh ubuntu@192.168.1.50");'
  );

  -- ==============================================================================
  -- MÓDULO 2: Arquitectura de Docker e Imágenes de Contenedores
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Arquitectura de Docker e Imágenes de Contenedores',
    'Descubre el poder del aislamiento por contenedores, descarga imágenes y gestiona su ciclo de vida.',
    '2'
  ) RETURNING id INTO v_mod2_id;

  -- Lección 2.1 (VMs vs Contenedores)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '5. Máquinas Virtuales vs Contenedores',
    'Comprende por qué los contenedores son más rápidos y ligeros que las máquinas virtuales tradicionales.',
    'quiz',
    5,
    55,
    E'### 🐳 La Gran Diferencia:\n- **Máquinas Virtuales (VM):** Emulan hardware completo e incluyen un sistema operativo invitado (Guest OS) de varios gigabytes.\n- **Contenedores Docker:** Comparten el **Kernel de Linux** del host y usan *Namespaces* (para aislamiento) y *Cgroups* (para límite de recursos de CPU y RAM). Pesan apenas unos megabytes y arrancan en milisegundos.',
    '3'
  );

  -- Lección 2.2 (Ciclo de vida: run, ps, exec, stop)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod2_id,
    '6. Comandos Fundamentales de Docker CLI',
    'Aprende a ejecutar contenedores en segundo plano (detached mode) con `docker run -d`.',
    'logic',
    6,
    65,
    E'### 🚀 Comandos del Ciclo de Vida:\n- `docker run -d --name mi_app nginx`: Descarga y corre Nginx en segundo plano.\n- `docker ps`: Lista los contenedores en ejecución.\n- `docker exec -it mi_app bash`: Abre una terminal interactiva dentro del contenedor.\n- `docker stop mi_app`: Detiene el contenedor de forma segura.',
    '// Retorna el comando para correr un contenedor Nginx en segundo plano con el nombre "servidor_web"
function getRunDetachedCommand(image, containerName) {
  return `docker run -d --name ${containerName} ${image}`;
}',
    'function getRunDetachedCommand(image, containerName) {
  return `docker run -d --name ${containerName} ${image}`;
}',
    'if (getRunDetachedCommand("nginx", "servidor_web") === "docker run -d --name servidor_web nginx") { return true; } throw new Error("Comando incorrecto.");'
  );

  -- Lección 2.3 (Mapeo de Puertos y Variables de Entorno)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '7. Publicación de Puertos y Variables de Entorno',
    'Comprende la sintaxis `-p <puerto_host>:<puerto_contenedor>` para exponer aplicaciones.',
    'quiz',
    7,
    55,
    E'### 🔌 Conectando el Contenedor al Mundo Exterior:\nPor defecto, los puertos de un contenedor están aislados dentro de la red privada de Docker.\n- `-p 8080:80`: Mapea el puerto `8080` de tu máquina real (Host) al puerto `80` interno del contenedor.\n- `-e NODE_ENV=production`: Inyecta variables de entorno a los procesos.',
    '2'
  );

  -- Lección 2.4 (Logs e Inspección)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod2_id,
    '8. Depuración y Análisis de Logs con `docker logs`',
    'Aprende a diagnosticar caídas y mensajes de error en contenedores.',
    'quiz',
    8,
    50,
    E'### 🔍 Inspección en Tiempo Real:\n- `docker logs -f <nombre>`: Sigue en vivo la salida estándar (`stdout`/`stderr`) de la aplicación (como `tail -f`).\n- `docker inspect <nombre>`: Muestra toda la configuración JSON de bajo nivel (IPs, montajes, variables).',
    '1'
  );

  -- ==============================================================================
  -- MÓDULO 3: Creación de Dockerfiles, Volúmenes y Docker Compose
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Creación de Dockerfiles, Volúmenes y Docker Compose',
    'Construye imágenes personalizadas, persiste bases de datos y orquesta sistemas multicontenedor.',
    '3'
  ) RETURNING id INTO v_mod3_id;

  -- Lección 3.1 (Estructura de un Dockerfile)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '9. Anatomía de un Dockerfile Profesional',
    'Aprende el orden óptimo de las directivas `FROM`, `WORKDIR`, `COPY`, `RUN` y `CMD`.',
    'quiz',
    9,
    60,
    E'### 📄 Directivas Esenciales:\n- `FROM node:18-alpine`: Define la imagen base ligera.\n- `WORKDIR /app`: Establece el directorio de trabajo donde se ejecutarán los siguientes comandos.\n- `COPY package*.json ./`: Copia archivos locales a la imagen.\n- `RUN npm install`: Ejecuta comandos durante la fase de **construcción (Build)**.\n- `CMD ["npm", "start"]`: Comando por defecto que se ejecuta al **iniciar el contenedor**.',
    '3'
  );

  -- Lección 3.2 (Persistencia con Volúmenes)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod3_id,
    '10. Persistencia de Datos con Volúmenes de Docker',
    'Evita la pérdida de datos en bases de datos PostgreSQL o MySQL al reiniciar contenedores.',
    'logic',
    10,
    70,
    E'### 💾 ¿Por qué los contenedores son efímeros?\nSi eliminas un contenedor, todos los datos creados dentro de él se destruyen. Los **Volúmenes** desacoplan los datos del ciclo de vida del contenedor.\n- `docker volume create datos_postgres`\n- `docker run -v datos_postgres:/var/lib/postgresql/data postgres`',
    '// Genera el flag de volumen para asociar el volumen "pg_data" a "/var/lib/postgresql/data"
function getVolumeFlag(volName, mountPath) {
  return `-v ${volName}:${mountPath}`;
}',
    'function getVolumeFlag(volName, mountPath) {
  return `-v ${volName}:${mountPath}`;
}',
    'if (getVolumeFlag("pg_data", "/var/lib/postgresql/data") === "-v pg_data:/var/lib/postgresql/data") { return true; } throw new Error("Flag de volumen incorrecto.");'
  );

  -- Lección 3.3 (Redes en Docker)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, solution_code
  ) VALUES (
    v_mod3_id,
    '11. Redes Virtuales y Resolución DNS Interna',
    'Comprende cómo los contenedores se comunican entre sí utilizando sus nombres de servicio como dominios.',
    'quiz',
    11,
    55,
    E'### 🌐 Docker Bridge Networks:\nCuando creas una red de usuario (`docker network create red_app`), Docker incluye un servidor DNS interno embebido.\n\nSi tu backend necesita conectarse a la base de datos, no necesita saber su IP: simplemente apunta al nombre del contenedor (ej: `host: "db"`).',
    '2'
  );

  -- Lección 3.4 (Orquestación con Docker Compose)
  INSERT INTO public.challenges (
    module_id, title, description, challenge_type, order_index, xp_reward, theory, initial_code, solution_code, test_code
  ) VALUES (
    v_mod3_id,
    '12. Orquestación Declarativa con Docker Compose',
    'Define arquitecturas multi-servicio (App + Database) en un único archivo YAML y arráncalas con un comando.',
    'logic',
    12,
    75,
    E'### 🎼 ¿Qué es Docker Compose?\nUna herramienta para definir y ejecutar aplicaciones multi-contenedor mediante un archivo `docker-compose.yml`.\n\n### 🚀 Comandos Clave:\n- `docker compose up -d`: Construye, crea y arranca todos los servicios en segundo plano.\n- `docker compose down`: Detiene y elimina los contenedores y redes creadas.',
    '// Retorna el comando para levantar todos los servicios de Docker Compose en segundo plano
function getComposeUpCommand() {
  return "docker compose up -d";
}',
    'function getComposeUpCommand() {
  return "docker compose up -d";
}',
    'if (getComposeUpCommand() === "docker compose up -d") { return true; } throw new Error("Debes retornar docker compose up -d");'
  );

END $$;
