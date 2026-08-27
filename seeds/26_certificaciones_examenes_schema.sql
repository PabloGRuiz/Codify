-- ==============================================================================
-- 🚀 CODIFY SEED: 26 - SISTEMA DE EXÁMENES Y CERTIFICACIONES OFICIALES VERIFICABLES
-- ==============================================================================
-- 1. Tablas: certifications, certification_questions, user_certifications, exam_attempts
-- 2. Políticas de Seguridad RLS
-- 3. Semillas de Certificaciones y Bancos de Preguntas para cursos clave
-- ==============================================================================

-- 1. Crear Tablas
CREATE TABLE IF NOT EXISTS public.certifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  description TEXT NOT NULL,
  min_passing_score INT DEFAULT 80,
  time_limit_minutes INT DEFAULT 20,
  xp_reward INT DEFAULT 500,
  badge_theme TEXT DEFAULT 'gold', -- 'gold', 'emerald', 'cyan', 'purple', 'crimson'
  skills_validated TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.certification_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  certification_id UUID NOT NULL REFERENCES public.certifications(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  options TEXT[] NOT NULL,
  correct_index INT NOT NULL,
  explanation TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.user_certifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  certification_id UUID NOT NULL REFERENCES public.certifications(id) ON DELETE CASCADE,
  verification_code VARCHAR(32) UNIQUE NOT NULL,
  score INT NOT NULL,
  issued_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, certification_id)
);

CREATE TABLE IF NOT EXISTS public.exam_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  certification_id UUID NOT NULL REFERENCES public.certifications(id) ON DELETE CASCADE,
  score INT NOT NULL,
  passed BOOLEAN NOT NULL,
  total_questions INT NOT NULL,
  correct_answers INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE public.certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certification_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_attempts ENABLE ROW LEVEL SECURITY;

-- 3. Políticas RLS
DROP POLICY IF EXISTS "Lectura pública de certificaciones" ON public.certifications;
CREATE POLICY "Lectura pública de certificaciones" ON public.certifications
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Lectura de preguntas para autenticados" ON public.certification_questions;
CREATE POLICY "Lectura de preguntas para autenticados" ON public.certification_questions
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Lectura pública de certificados de usuarios" ON public.user_certifications;
CREATE POLICY "Lectura pública de certificados de usuarios" ON public.user_certifications
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Insertar certificado propio" ON public.user_certifications;
CREATE POLICY "Insertar certificado propio" ON public.user_certifications
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Lectura de intentos propios" ON public.exam_attempts;
CREATE POLICY "Lectura de intentos propios" ON public.exam_attempts
  FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Insertar intento propio" ON public.exam_attempts;
CREATE POLICY "Insertar intento propio" ON public.exam_attempts
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- 4. Índices de Búsqueda Rápida
CREATE INDEX IF NOT EXISTS idx_cert_course_id ON public.certifications(course_id);
CREATE INDEX IF NOT EXISTS idx_cert_code ON public.certifications(code);
CREATE INDEX IF NOT EXISTS idx_user_certs_user ON public.user_certifications(user_id);
CREATE INDEX IF NOT EXISTS idx_user_certs_vcode ON public.user_certifications(verification_code);
CREATE INDEX IF NOT EXISTS idx_exam_attempts_user_cert ON public.exam_attempts(user_id, certification_id);

-- ==============================================================================
-- 5. SEMILLA: Configuración de Certificaciones y Banco de Preguntas
-- ==============================================================================
DO $SEED_CERTS$
DECLARE
  v_ai_course_id UUID;
  v_cpp_course_id UUID;
  v_net_course_id UUID;
  v_it_course_id UUID;
  
  v_ai_cert_id UUID;
  v_cpp_cert_id UUID;
  v_net_cert_id UUID;
  v_it_cert_id UUID;
BEGIN

  -- 1. Buscar cursos
  SELECT id INTO v_ai_course_id FROM public.courses WHERE title ILIKE '%Inteligencia Artificial%' LIMIT 1;
  SELECT id INTO v_cpp_course_id FROM public.courses WHERE title ILIKE '%C++%' LIMIT 1;
  SELECT id INTO v_net_course_id FROM public.courses WHERE title ILIKE '%Redes%' LIMIT 1;
  SELECT id INTO v_it_course_id FROM public.courses WHERE title ILIKE '%Fundamentos IT%' LIMIT 1;

  -- ----------------------------------------------------------------------------
  -- CERTIFICACIÓN 1: Inteligencia Artificial y LLMs
  -- ----------------------------------------------------------------------------
  IF v_ai_course_id IS NOT NULL THEN
    DELETE FROM public.certifications WHERE code = 'CERT-AI-101';
    
    INSERT INTO public.certifications (
      course_id, title, code, description, min_passing_score, time_limit_minutes, xp_reward, badge_theme, skills_validated
    ) VALUES (
      v_ai_course_id,
      'Certificado Profesional: Inteligencia Artificial, Embeddings y LLMs',
      'CERT-AI-101',
      'Acredita dominio teórico y práctico en redes neuronales, predicción probabilística de tokens, espacios vectoriales, similitud coseno, bases de datos vectoriales y arquitecturas RAG.',
      80,
      20,
      500,
      'cyan',
      ARRAY['Machine Learning', 'LLMs', 'Embeddings', 'Similitud Coseno', 'Bases Vectoriales', 'Transformers', 'RAG']
    ) RETURNING id INTO v_ai_cert_id;

    -- Preguntas del Examen de IA
    INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
    (v_ai_cert_id, '¿Qué mide la Similitud Coseno entre dos vectores de embeddings?', ARRAY['La distancia en línea recta entre sus coordenadas cartesianas', 'El coseno del ángulo entre ambos vectores, evaluando su orientación semántica independientemente de su magnitud', 'La cantidad de memoria RAM que ocupa el archivo', 'El número de palabras que comparten en común'], 1, 'La similitud coseno compara la dirección en el espacio multidimensional, evaluando la cercanía conceptual.'),
    (v_ai_cert_id, '¿Cuál es la función principal de una base de datos vectorial con índice HNSW?', ARRAY['Ejecutar consultas SQL de tipo JOIN más rápido', 'Buscar los vecinos más cercanos en espacios multidimensionales en milisegundos mediante grafos jerárquicos', 'Cifrar contraseñas de usuarios', 'Reducir el tamaño de las imágenes del sitio'], 1, 'HNSW permite búsqueda aproximada de vecinos más cercanos ultra rápida sin necesidad de comparar contra cada vector individualmente.'),
    (v_ai_cert_id, 'En un flujo RAG (Retrieval-Augmented Generation), ¿en qué momento interviene la base de datos vectorial?', ARRAY['Para traducir la respuesta final a otro idioma', 'Para recuperar los fragmentos (chunks) más relevantes según el embedding de la pregunta del usuario y añadirlos al prompt de contexto', 'Para compilar el código TypeScript en el navegador', 'Para almacenar las credenciales de la API'], 1, 'RAG utiliza la base vectorial para extraer el contexto exacto antes de consultar al LLM.'),
    (v_ai_cert_id, '¿Qué efecto tiene establecer el parámetro Temperature = 0.0 en una llamada a un LLM?', ARRAY['El modelo genera respuestas totalmente deterministas eligiendo siempre el token más probable (Greedy Sampling)', 'El modelo genera respuestas sumamente caóticas y aleatorias', 'El modelo no devuelve ningún token', 'La API devuelve un error de timeout'], 0, 'Temperature = 0 desactiva la aleatoriedad, ideal para JSON estructurado, extracción y código.'),
    (v_ai_cert_id, '¿Por qué la arquitectura Transformer superó a las redes RNN y LSTM en procesamiento de lenguaje natural?', ARRAY['Porque no requiere GPUs para ejecutarse', 'Porque su mecanismo de Self-Attention permite analizar todas las palabras simultáneamente y entrenar de forma masivamente paralelizada', 'Porque solo funciona con números enteros', 'Porque almacena las frases en discos duros mecánicos'], 1, 'El mecanismo de auto-atención procesa todas las palabras en paralelo eliminando los cuellos de botella secuenciales.');
  END IF;

  -- ----------------------------------------------------------------------------
  -- CERTIFICACIÓN 2: C++ Básico y POO
  -- ----------------------------------------------------------------------------
  IF v_cpp_course_id IS NOT NULL THEN
    DELETE FROM public.certifications WHERE code = 'CERT-CPP-101';

    INSERT INTO public.certifications (
      course_id, title, code, description, min_passing_score, time_limit_minutes, xp_reward, badge_theme, skills_validated
    ) VALUES (
      v_cpp_course_id,
      'Certificado Profesional: Programación en C++ y Orientación a Objetos',
      'CERT-CPP-101',
      'Acredita competencias en gestión manual y moderna de memoria con punteros inteligentes, RAII, programación orientada a objetos con polimorfismo dinámico y la librería estándar (STL).',
      80,
      20,
      500,
      'purple',
      ARRAY['C++ Moderno', 'Punteros & Memoria', 'std::unique_ptr', 'RAII', 'POO & Polimorfismo', 'STL Containers']
    ) RETURNING id INTO v_cpp_cert_id;

    -- Preguntas del Examen de C++
    INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
    (v_cpp_cert_id, '¿Cuál es la diferencia fundamental entre el paso de un argumento por valor y por referencia constante (const T&)?', ARRAY['Por valor se modifica el original; por referencia constante se crea una copia', 'Por valor se copia todo el objeto en memoria; por referencia constante se accede al original sin permitir modificaciones y evitando la copia', 'Ambos métodos son idénticos en tiempo de ejecución', 'const T& solo funciona con números enteros'], 1, 'const T& evita la sobrecarga de duplicar estructuras pesadas y protege contra modificaciones accidentales.'),
    (v_cpp_cert_id, '¿Qué ventaja ofrece std::unique_ptr frente al uso de punteros crudos (raw pointers) con new/delete?', ARRAY['Permite compartir el mismo recurso en múltiples hilos sin bloqueo', 'Implementa el patrón RAII liberando la memoria automáticamente al salir del ámbito y garantiza propiedad exclusiva sin fugas de memoria', 'Desactiva el recolector de basura del sistema', 'Hace que el código se ejecute en la tarjeta gráfica'], 1, 'std::unique_ptr gestiona la vida del recurso en el Heap automáticamente mediante su destructor.'),
    (v_cpp_cert_id, 'Para habilitar el polimorfismo dinámico y asegurar que se llame al destructor de una clase derivada a través de un puntero base, ¿qué palabra clave es obligatoria?', ARRAY['static', 'virtual (ej. virtual ~Base() = default;)', 'friend', 'extern'], 1, 'El destructor virtual asegura la llamada correcta a los destructores de la jerarquía de herencia.'),
    (v_cpp_cert_id, '¿En qué estructura de memoria se asignan las variables locales estándar declaradas dentro de una función en C++?', ARRAY['Heap', 'Stack (Pila de llamadas)', 'ROM', 'Directorio de archivos'], 1, 'Las variables locales automáticas se reservan en el Stack con liberación instantánea al terminar la función.'),
    (v_cpp_cert_id, '¿Cuál es la complejidad temporal promedio para buscar un elemento por clave en un std::map frente a std::unordered_map?', ARRAY['std::map es O(1) y std::unordered_map es O(N)', 'std::map es O(log N) basado en árbol balanceado; std::unordered_map es O(1) promedio basado en tabla hash', 'Ambos son O(N^2)', 'std::map no permite búsquedas por clave'], 1, 'std::map utiliza un árbol rojo-negro (O(log N)) mientras que unordered_map usa hashing (O(1)).');
  END IF;

  -- ----------------------------------------------------------------------------
  -- CERTIFICACIÓN 3: Redes Informáticas y Protocolos
  -- ----------------------------------------------------------------------------
  IF v_net_course_id IS NOT NULL THEN
    DELETE FROM public.certifications WHERE code = 'CERT-NET-101';

    INSERT INTO public.certifications (
      course_id, title, code, description, min_passing_score, time_limit_minutes, xp_reward, badge_theme, skills_validated
    ) VALUES (
      v_net_course_id,
      'Certificado Profesional: Redes Informáticas, Protocolos y Seguridad',
      'CERT-NET-101',
      'Acredita dominio de la pila TCP/IP, direccionamiento IPv4/IPv6, subredes CIDR, DNS, HTTP/HTTPS y seguridad en capas de transporte.',
      80,
      20,
      500,
      'emerald',
      ARRAY['Modelo OSI & TCP/IP', 'IPv4 & Subnetting CIDR', 'TCP vs UDP', 'DNS & HTTP/3', 'TLS & Criptografía']
    ) RETURNING id INTO v_net_cert_id;

    -- Preguntas del Examen de Redes
    INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
    (v_net_cert_id, '¿Qué diferencia clave existe entre el protocolo TCP y el protocolo UDP en la capa de transporte?', ARRAY['TCP no verifica errores; UDP sí', 'TCP está orientado a conexión con garantía de entrega y control de flujo mediante Three-Way Handshake; UDP es no orientado a conexión y sin confirmación', 'UDP solo transmite texto plano', 'TCP no utiliza números de puerto'], 1, 'TCP garantiza orden y entrega con acuses de recibo; UDP prioriza velocidad y baja latencia.'),
    (v_net_cert_id, 'En una red con máscara de subred /24 (255.255.255.0), ¿cuántas direcciones IP utilizables para hosts existen en total?', ARRAY['256 hosts', '254 hosts (descontando la dirección de red y la de broadcast)', '128 hosts', '1024 hosts'], 1, 'Una subred /24 tiene 256 direcciones totales; se reservan la primera (red) y la última (broadcast), dejando 254 hosts útiles.'),
    (v_net_cert_id, '¿Cuál es el rol del protocolo DNS dentro de la infraestructura de Internet?', ARRAY['Cifrar las contraseñas de las bases de datos', 'Traducir nombres de dominio legibles para humanos (ej: codify.dev) en direcciones IP numéricas que comprenden los enrutadores', 'Asignar ancho de banda prioritario a los navegadores', 'Monitorear la temperatura de los servidores'], 1, 'DNS actúa como la libreta de direcciones de Internet convirtiendo dominios en IPs.'),
    (v_net_cert_id, '¿Qué protocolo de transporte utiliza HTTP/3 para reducir la latencia y eliminar el bloqueo en cabeza de línea (Head-of-Line Blocking)?', ARRAY['TCP clásico', 'QUIC sobre UDP', 'FTP', 'ICMP'], 1, 'HTTP/3 reemplaza TCP por QUIC (basado en UDP) permitiendo multiplexación real sin bloqueos.'),
    (v_net_cert_id, '¿En qué capa del modelo OSI opera un Switch estándar que reenvía tramas según direcciones MAC?', ARRAY['Capa 1 (Física)', 'Capa 2 (Enlace de Datos)', 'Capa 3 (Red)', 'Capa 7 (Aplicación)'], 1, 'Los switches de nivel 2 operan en la capa de Enlace de Datos mediante tramas y tablas MAC.');
  END IF;

  -- ----------------------------------------------------------------------------
  -- CERTIFICACIÓN 4: Fundamentos IT y Lógica
  -- ----------------------------------------------------------------------------
  IF v_it_course_id IS NOT NULL THEN
    DELETE FROM public.certifications WHERE code = 'CERT-IT-101';

    INSERT INTO public.certifications (
      course_id, title, code, description, min_passing_score, time_limit_minutes, xp_reward, badge_theme, skills_validated
    ) VALUES (
      v_it_course_id,
      'Certificado Profesional: Fundamentos de Ingeniería de Software y Lógica',
      'CERT-IT-101',
      'Acredita bases sólidas de pensamiento algorítmico, estructuras de control, tipos de datos y fundamentos computacionales.',
      80,
      20,
      500,
      'gold',
      ARRAY['Pensamiento Algorítmico', 'Tipos de Datos', 'Control de Flujo', 'Estructuras de Datos', 'Buenas Prácticas']
    ) RETURNING id INTO v_it_cert_id;

    -- Preguntas del Examen de IT
    INSERT INTO public.certification_questions (certification_id, question, options, correct_index, explanation) VALUES
    (v_it_cert_id, '¿Qué estructura de datos opera bajo el principio LIFO (Last In, First Out)?', ARRAY['Cola (Queue)', 'Pila (Stack)', 'Lista enlazada circular', 'Árbol binario de búsqueda'], 1, 'El último elemento en ingresar a la pila es el primero en ser extraído (LIFO).'),
    (v_it_cert_id, '¿Cuál es la complejidad temporal de una búsqueda binaria sobre un arreglo ordenado de N elementos?', ARRAY['O(N)', 'O(log N)', 'O(N^2)', 'O(1)'], 1, 'La búsqueda binaria divide el espacio de búsqueda a la mitad en cada paso, logrando O(log N).'),
    (v_it_cert_id, '¿Qué tipo de dato booleano representa la expresión (true && false) || (!false)?', ARRAY['false', 'true', 'null', 'undefined'], 1, '(true && false) es false; (!false) es true; false || true resulta en true.'),
    (v_it_cert_id, '¿Cuál es el propósito fundamental de una función pura en programación?', ARRAY['Modificar variables globales del sistema', 'Devolver siempre el mismo resultado para los mismos argumentos sin causar efectos secundarios externos', 'Imprimir texto en la consola de depuración', 'Conectarse a una base de datos externa'], 1, 'Las funciones puras son deterministas y no alteran el estado fuera de su propio ámbito.'),
    (v_it_cert_id, '¿Qué problema resuelve el uso de Git y sistemas de control de versiones?', ARRAY['Aumentar la velocidad de la memoria RAM', 'Rastrear el historial de cambios en el código, facilitar la colaboración en equipo y permitir ramificaciones (branches)', 'Compilar código JavaScript en tiempo real', 'Eliminar automáticamente bugs del código'], 1, 'Git permite gestionar versiones, colaborar concurrentemente y revertir cambios cuando sea necesario.');
  END IF;

END $SEED_CERTS$;
