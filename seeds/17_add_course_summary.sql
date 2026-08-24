-- ==============================================================================
-- 🚀 CODIFY SEED: 17 - RESÚMENES DETALLADOS DE CURSOS (COURSE SUMMARIES)
-- ==============================================================================
-- Este script:
-- 1. Agrega la columna 'summary' a la tabla 'courses' si no existe.
-- 2. Inyecta resúmenes ricos en formato Markdown en todos los cursos del catálogo.
-- ==============================================================================

DO $$
BEGIN

  -- 1. Añadir columna 'summary' si no existe
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'courses' 
      AND column_name = 'summary'
  ) THEN
    ALTER TABLE public.courses ADD COLUMN summary TEXT;
  END IF;

  -- 2. Inyectar Resumen para: Desarrollo Web Full Stack con IA
  UPDATE public.courses
  SET summary = $SUMMARY$
## 🚀 Acerca de este Bootcamp
El **Bootcamp de Desarrollo Web Full Stack con IA** es nuestro programa insignia diseñado para llevarte desde los fundamentos lógicos hasta la construcción de arquitecturas full stack modernas asistidas por Inteligencia Artificial.

### 🎯 Lo que aprenderás:
- **Fundamentos y Lógica:** Algoritmos, control de flujo, estructuras de datos y buenas prácticas.
- **Programación Orientada a Objetos (POO):** Clases, encapsulamiento, polimorfismo y modelado de dominio.
- **Prototipado Web y DOM:** HTML5 semántico, CSS3 moderno (Flexbox & Grid) e interactividad nativa con JavaScript.
- **Programación Asíncrona:** Promesas, `async/await`, consumo de APIs REST y manejo de eventos complejos.
- **Backend Moderno:** Arquitectura de microservicios y APIs de alto rendimiento con **FastAPI** y **Python**.
- **Ingeniería de IA Integrada:** Integración de modelos LLM, prompts estructurados y pipelines inteligentes en producción.

### 👤 ¿A quién va dirigido?
- Estudiantes y entusiastas que quieren una formación integral de 0 a 100.
- Desarrolladores junior que buscan dominar tanto el frontend como el backend moderno con IA.
$SUMMARY$
  WHERE title = 'Desarrollo Web Full Stack con IA';


  -- 3. Inyectar Resumen para: Fundamentos de Redes y Telecomunicaciones
  UPDATE public.courses
  SET summary = $SUMMARY$
## 📡 Fundamentos de Redes e Infraestructura IT
Domina los cimientos invisibles que hacen posible la comunicación en Internet y las redes corporativas. Desde el cableado estructurado hasta los protocolos de transporte y direccionamiento IP.

### 🎯 Lo que aprenderás:
- **Arquitectura y Topologías:** Clasificación de redes (PAN, LAN, MAN, WAN), topologías físicas/lógicas y dispositivos (Switches, Routers, Access Points).
- **El Modelo OSI & Stack TCP/IP:** Las 7 capas de abstracción, encapsulamiento de tramas, paquetes y segmentos.
- **Direccionamiento y Subnetting:** Clases de direcciones IPv4, máscaras de subred CIDR, cálculo de redes y transición hacia IPv6.
- **Servicios Esenciales de Red:** Protocolos DNS, DHCP, NAT, cortafuegos y resolución de nombres.

### 👤 ¿A quién va dirigido?
- Administradores de sistemas, técnicos IT y responsables de infraestructura informática.
- Desarrolladores que deseen entender a fondo el tráfico web y la seguridad de red.
$SUMMARY$
  WHERE title = 'Fundamentos de Redes y Telecomunicaciones';


  -- 4. Inyectar Resumen para: Fundamentos IT y Lógica
  UPDATE public.courses
  SET summary = $SUMMARY$
## 🧠 Pensamiento Computacional y Fundamentos IT
Desarrolla el razonamiento lógico necesario para resolver problemas tecnológicos complejos y entender el funcionamiento del hardware y software.

### 🎯 Lo que aprenderás:
- **Lógica Booleana y Tablas de Verdad:** Evaluación de condiciones con compuertas lógicas (AND, OR, NOT, XOR).
- **Hardware y Arquitectura de Sistemas:** CPU, registros, memoria RAM, buses de datos y almacenamiento secundario.
- **Resolución de Problemas:** Algoritmos secuenciales, condicionales y optimización de toma de decisiones.

### 👤 ¿A quién va dirigido?
- Personas sin experiencia técnica previa que desean ingresar al mundo de la tecnología.
- Profesionales que buscan una base sólida de razonamiento antes de aprender sintaxis de código.
$SUMMARY$
  WHERE title = 'Fundamentos IT y Lógica';


  -- 5. Inyectar Resumen para: Fundamentos de la Programación Web
  UPDATE public.courses
  SET summary = $SUMMARY$
## 🌐 La Puerta de Entrada al Desarrollo Web Moderno
Aprende a construir la web interactiva desde sus cimientos reales utilizando los tres pilares del desarrollo frontend: **HTML5**, **CSS3** y **JavaScript**.

### 🎯 Lo que aprenderás:
- **Arquitectura Cliente-Servidor:** Peticiones HTTP, DNS, código de estado y ciclo de vida de una página web.
- **Estructura Semántica con HTML5:** Creación de páginas accesibles (a11y), formularios interactivos y optimización para motores de búsqueda (SEO).
- **Diseño Visual con CSS3:** El Box Model, layouts responsivos con **Flexbox**, cuadrículas con **CSS Grid** y variables nativas para temas oscuros.
- **Interactividad con JavaScript:** Selección y mutación en tiempo real del DOM, escucha de eventos y construcción de mini aplicaciones interactivas.

### 👤 ¿A quién va dirigido?
- Principiantes que quieren crear sus primeros sitios y aplicaciones web desde cero.
- Creadores de contenido y diseñadores que buscan tener control total sobre el código web.
$SUMMARY$
  WHERE title = 'Fundamentos de la Programación Web';

END $$;
