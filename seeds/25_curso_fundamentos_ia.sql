-- ==============================================================================
-- 🚀 CODIFY SEED: 25 - CURSO COMPLETO: FUNDAMENTOS DE INTELIGENCIA ARTIFICIAL Y LLMS
-- ==============================================================================
-- Este script inserta:
-- 1. Curso: "Fundamentos de Inteligencia Artificial y LLMs" con Ficha Técnica
-- 2. Prerrequisito enlazado a "Fundamentos IT y Lógica"
-- 3. Tres módulos secuenciales con 12 lecciones completas (Teoría + Quizzes)
-- ==============================================================================

DO $$
DECLARE
  v_author_id UUID;
  v_prereq_id UUID;
  v_course_id UUID;
  v_m1_id UUID;
  v_m2_id UUID;
  v_m3_id UUID;
BEGIN

  -- 1. Obtener autor de referencia o admin
  SELECT id INTO v_author_id FROM public.profiles LIMIT 1;
  IF v_author_id IS NULL THEN
    SELECT id INTO v_author_id FROM auth.users LIMIT 1;
  END IF;

  -- 2. Obtener curso prerrequisito
  SELECT id INTO v_prereq_id FROM public.courses WHERE title ILIKE '%Fundamentos IT%' LIMIT 1;

  -- 3. Limpiar curso previo si existe para re-inserción limpia
  DELETE FROM public.courses WHERE title = 'Fundamentos de Inteligencia Artificial y LLMs';

  -- 4. Crear Curso de IA y LLMs
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
    'Fundamentos de Inteligencia Artificial y LLMs',
    'Descubre qué ocurre detrás de las IA modernas: desde el Machine Learning básico hasta la arquitectura Transformer, cálculo de Embeddings, Similitud Coseno, Bases de Datos Vectoriales y sistemas RAG.',
    $SUMMARY$## 🚀 Acerca del Curso

La Inteligencia Artificial ha transformado por completo la industria tecnológica. Sin embargo, para un desarrollador o profesional del software, no basta con consumir una API de OpenAI o Anthropic: es indispensable entender la arquitectura matemática y computacional que hace funcionar a estos modelos.

En este curso aprenderás qué es una red neuronal, cómo se calcula la probabilidad de un token, qué es un vector de embeddings en alta dimensionalidad, cómo funciona la similitud coseno y cómo se construyen sistemas empresariales de Generación Aumentada por Recuperación (RAG).

### 🎯 ¿Qué aprenderás?
- **Machine Learning vs Programación Clásica:** Redes neuronales, funciones de activación, pesos, sesgos y entrenamiento.
- **Modelos de Lenguaje (LLMs):** Qué es un LLM, predicción probabilística de tokens, context window, temperatura y top-p.
- **Embeddings y Espacios Vectoriales:** Representación geométrica del significado semántico en 1536+ dimensiones.
- **Matemáticas de Similitud:** Similitud Coseno ($\cos \theta$), Distancia Euclidiana ($L2$) y Producto Punto.
- **Bases de Datos Vectoriales:** Indexación con HNSW, IVF y motores como ChromaDB, Pinecone y `pgvector`.
- **Arquitectura Transformer:** El revolucionario mecanismo de auto-atención (*Self-Attention*).
- **RAG (Retrieval-Augmented Generation):** Conexión de LLMs a bases de conocimiento privadas para eliminar alucinaciones.
- **Toma de Decisiones de Arquitectura:** Cuándo aplicar Prompt Engineering, RAG o Fine-Tuning.

### 👥 ¿A quién está dirigido?
Programadores, ingenieros de datos y entusiastas de la tecnología que quieran entender la ciencia e ingeniería real detrás de ChatGPT, Claude, Gemini y la IA generativa moderna.$SUMMARY$,
    ARRAY['Teórico', 'Inteligencia Artificial', 'Machine Learning', 'LLM', 'Embeddings', 'Vectores', 'Data Science'],
    v_prereq_id,
    1,
    v_author_id,
    'published'
  )
  RETURNING id INTO v_course_id;

  -- ==============================================================================
  -- MÓDULO 1: Del Machine Learning a los Modelos de Lenguaje (LLMs)
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 1: Del Machine Learning a los Modelos de Lenguaje (LLMs)',
    'Comprende el cambio de paradigma de la programación tradicional hacia las redes neuronales y los modelos de lenguaje.',
    '1'
  ) RETURNING id INTO v_m1_id;

  -- Lección 1.1: Machine Learning y Redes Neuronales
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '1. El Paradigma del Machine Learning y Redes Neuronales',
    'Diferencia entre programación determinista y aprendizaje automático, y cómo aprenden las redes neuronales.',
    'quiz',
    75,
    $THEORY$# El Paradigma del Machine Learning

En la **programación clásica**, un desarrollador escribe reglas manuales (`if/else`, algoritmos) y les introduce datos para obtener respuestas.

En el **Machine Learning (ML)**, invertimos la ecuación: le entregamos al algoritmo **datos de entrada y respuestas deseadas**, y el modelo infiere y ajusta automáticamente las reglas matemáticas para predecir futuros casos.

```
Programación Clásica:  [Reglas] + [Datos]      ---> [Respuestas]
Machine Learning:      [Datos]  + [Respuestas] ---> [Reglas (Modelo)]
```

### 🧠 ¿Cómo funciona una Red Neuronal?
Una red neuronal artificial está compuesta por capas de neuronas conectadas:
1. **Entrada (*Inputs*)**: Los datos numéricos que recibe el modelo.
2. **Pesos (*Weights*) y Sesgos (*Biases*)**: Factores numéricos que multiplican y ajustan la señal de cada conexión.
3. **Función de Activación** (ej. ReLU, Sigmoid): Introduce no-linealidad para permitir modelar relaciones complejas del mundo real.
4. **Retropropagación (*Backpropagation*) y Descenso del Gradiente**: Algoritmo que calcula el error de la predicción y ajusta los millones de pesos en la dirección que minimice el error.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la diferencia fundamental entre la programación clásica y el Machine Learning?","options":["En la programación clásica el ordenador aprende solo, mientras que en ML se escriben todas las reglas a mano","En programación clásica suministramos reglas y datos para obtener respuestas; en ML suministramos datos y respuestas para que el sistema aprenda las reglas","El Machine Learning no utiliza computadoras","La programación clásica solo funciona con números decimales"],"correctIndex":1,"explanation":"El Machine Learning automatiza la creación de reglas analizando patrones a partir de datos y resultados conocidos."},{"id":"q2","question":"¿Qué función cumplen los 'pesos' (weights) dentro de una red neuronal?","options":["Definen el tamaño del archivo en disco","Son parámetros matemáticos ajustables que determinan la fuerza e importancia de la conexión entre neuronas","Miden la velocidad de la tarjeta gráfica","Son los nombres de las variables en memoria"],"correctIndex":1,"explanation":"Los pesos son los valores que el modelo optimiza durante el entrenamiento para ponderar la influencia de cada entrada sobre la predicción."},{"id":"q3","question":"¿Qué algoritmo se utiliza para calcular el error de la red y propagar los ajustes hacia atrás en todas las capas?","options":["QuickSort","Backpropagation (Retropropagación) con Descenso de Gradiente","Algoritmo de Dijkstra","Binary Search"],"correctIndex":1,"explanation":"Backpropagation calcula la derivada del error respecto a cada peso para ajustar los parámetros en la dirección que minimiza la pérdida."}]$JSON$,
    1
  );

  -- Lección 1.2: ¿Qué es un LLM (Large Language Model)?
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '2. ¿Qué es un LLM y cómo genera texto?',
    'Aprende qué es un modelo de lenguaje masivo, el concepto de predicción de próximo token y el alineamiento con RLHF.',
    'quiz',
    75,
    $THEORY$# ¿Qué es un LLM (Large Language Model)?

Un **LLM** (como GPT-4, Claude o LLaMA) es, en su núcleo fundamental, un **motor probabilístico de predicción del siguiente token**.

### 1. El Proceso de Predicción:
Dado un texto de entrada (*Prompt*), el modelo calcula una distribución de probabilidades sobre todo su vocabulario para determinar cuál es la palabra/fragmento más coherente para continuar la secuencia.

```
Entrada: "El cielo durante el día es de color..."
Probabilidades calculadas:
- "azul"   --> 91.4%
- "claro"  --> 5.2%
- "rojo"   --> 0.8%
- "verde"  --> 0.01%
```

### 2. Etapas de Creación de un LLM:
1. **Pre-entrenamiento (*Pre-training*)**: El modelo lee billones de páginas de texto de Internet para aprender sintaxis, hechos y razonamiento general (coste de millones de dólares en GPUs).
2. **Instrucción / Fine-Tuning (*SFT*)**: Se le entrena específicamente con pares de Pregunta/Respuesta para que aprenda a actuar como un asistente.
3. **Alineación con RLHF (*Reinforcement Learning from Human Feedback*)**: Evaluadores humanos puntúan las respuestas para que el modelo sea útil, verídico y seguro.$THEORY$,
    $JSON$[{"id":"q1","question":"A nivel matemático y probabilístico, ¿cuál es la tarea central que ejecuta un LLM?","options":["Consultar una base de datos SQL relacional","Predecir la distribución de probabilidad del siguiente token dado un contexto previo","Ejecutar scripts de JavaScript en un navegador","Calcular rutas GPS"],"correctIndex":1,"explanation":"Los LLMs son modelos autoregresivos que predicen sucesivamente el token más probable basándose en la secuencia de entrada."},{"id":"q2","question":"¿Qué significa el proceso de RLHF en el ciclo de vida de un modelo como ChatGPT o Claude?","options":["Recuperación Local de Hardware Físico","Reinforcement Learning from Human Feedback (Aprendizaje por Refuerzo con Retroalimentación Humana)","Random Linear Hash Function","Reducción Lógica de Hilos de Flujo"],"correctIndex":1,"explanation":"RLHF alinea las respuestas del modelo con la intención humana, mejorando la seguridad y utilidad mediante recompensas basadas en juicio humano."},{"id":"q3","question":"¿Qué representa el número de 'parámetros' de un LLM (ej. 70 mil millones / 70B)?","options":["La cantidad de usuarios concurrentes que soporta","El número de conexiones y pesos matemáticos internos que almacenan el conocimiento aprendido","La cantidad de gigabytes de memoria RAM que requiere para arrancar","El número de idiomas que traduce"],"correctIndex":1,"explanation":"Los parámetros son las variables numéricas (pesos) que configuran la red neuronal y determinan sus patrones de razonamiento."}]$JSON$,
    2
  );

  -- Lección 1.3: Tokens y Ventana de Contexto
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '3. Tokenización y Ventana de Contexto (Context Window)',
    'Entiende cómo los modelos dividen el texto en tokens y qué limitaciones impone la ventana de contexto.',
    'quiz',
    75,
    $THEORY$# Tokenización y Ventana de Contexto

Los modelos de IA no procesan letras ni palabras directamente: procesan **tokens**.

### 1. ¿Qué es un Token?
Un token es una unidad básica de texto (un fragmento de palabra, palabra completa o signo de puntuación) que se asigna a un identificador numérico entero.
- En promedio: **1 token $\approx$ 4 caracteres en inglés o 0.75 palabras**.
- Palabras comunes como `"gato"` suelen ser 1 token (`[4120]`).
- Palabras poco comunes, código o idiomas con alfabetos no latinos pueden dividirse en múltiples subtokens (ej: `"desoxirribonucleico"` $\to$ 4 tokens).

### 2. La Ventana de Contexto (*Context Window*):
Es el límite máximo de tokens (entrada + salida generada) que el modelo puede "ver" y procesar simultáneamente en una sola conversación.
- **GPT-3 (2020)**: 2,048 tokens (~3 páginas).
- **GPT-4 Turbo**: 128,000 tokens (~300 páginas).
- **Gemini 1.5 Pro**: 1,000,000+ tokens (~2,500 páginas de código o libros enteros).

> **Impacto computacional**: El mecanismo de atención tradicional tiene una complejidad computacional cuadrática $O(N^2)$, lo que significa que duplicar la ventana de contexto multiplica por cuatro el coste de memoria y cálculo si no se usan optimizaciones.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Por qué los LLMs utilizan tokenización (como Byte-Pair Encoding) en lugar de procesar palabras completas del diccionario?","options":["Porque los diccionarios ocupan demasiado espacio en disco","Para manejar palabras compuestas, errores ortográficos, neologismos y código desconocido dividiéndolos en sub-palabras eficientes","Porque las computadoras no pueden procesar letras","Para hacer las respuestas intencionadamente más lentas"],"correctIndex":1,"explanation":"La tokenización por sub-palabras permite un vocabulario de tamaño fijo que puede descomponer cualquier texto sin fallar por palabras fuera de vocabulario."},{"id":"q2","question":"Aproximadamente, ¿cuántas palabras en español o inglés equivalen a 1,000 tokens?","options":["10,000 palabras","Aproximadamente 750 palabras","Exactamente 1 palabra","100,000 palabras"],"correctIndex":1,"explanation":"Como regla general de la industria, 1 token equivale a unas 0.75 palabras (o ~4 caracteres). Por tanto 1,000 tokens $\\approx$ 750 palabras."},{"id":"q3","question":"¿Qué ocurre cuando una conversación excede el límite máximo de la ventana de contexto del modelo?","options":["La computadora del usuario se apaga","El modelo no puede 'recordar' ni atender a los tokens más antiguos a menos que se resuman o descarten","El modelo cobra el doble por token","El modelo genera código binario exclusivamente"],"correctIndex":1,"explanation":"Los tokens que caen fuera de la ventana de contexto activa son invisibles para el mecanismo de atención del modelo."}]$JSON$,
    3
  );

  -- Lección 1.4: Hiperparámetros: Temperature, Top-P y Top-K
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m1_id,
    '4. Hiperparámetros de Inferencia: Temperature y Top-P',
    'Controla la creatividad, determinismo y diversidad del texto generado mediante muestreo estadístico.',
    'quiz',
    75,
    $THEORY$# Hiperparámetros de Inferencia

Al consultar un LLM, podemos controlar cómo selecciona el siguiente token a partir de las probabilidades calculadas.

### 1. Temperature (Temperatura):
Controla la "aleatoriedad" o "creatividad" de la distribución de probabilidad (*Softmax*):
- **Temperature = 0.0 (Greedy Sampling)**: El modelo **siempre** elige el token con la probabilidad más alta. Es completamente determinista (ideal para extracción de datos, SQL, código y clasificación).
- **Temperature = 0.7 - 1.0**: Suaviza las diferencias entre probabilidades, permitiendo que tokens creativos o alternativos sean seleccionados (ideal para redacción, lluvia de ideas y ficción).
- **Temperature > 1.5**: Muy aleatorio; produce texto caótico e incoherente.

### 2. Top-P (Nucleus Sampling):
Restringe la selección al subconjunto más pequeño de tokens cuya probabilidad acumulada suma el valor `P`:
- `Top-P = 0.9`: Descarta el 10% de opciones más improbables (la "cola larga" de tokens absurdos) y solo elige entre los candidatos principales.

### 3. Top-K:
Limita la selección a exactamente los `K` tokens más probables (ej. `Top-K = 40`).$THEORY$,
    $JSON$[{"id":"q1","question":"Si necesitas que un modelo genere código SQL estricto o extraiga un JSON de forma totalmente predecible y consistente, ¿qué valor de temperatura es el más adecuado?","options":["Temperature = 2.0","Temperature = 0.0 (o cercano a 0)","Temperature = 1.0","Temperature = -1.0"],"correctIndex":1,"explanation":"Temperature = 0 activa el muestreo codicioso (Greedy), garantizando respuestas deterministas con la opción de mayor probabilidad."},{"id":"q2","question":"¿Qué efecto produce incrementar la temperatura a un valor alto (ej. 1.2)?","options":["El modelo responde más rápido","La distribución de probabilidad se vuelve más plana, generando respuestas más variadas, creativas pero menos predecibles","El modelo reduce el consumo de tokens","El modelo solo responde en mayúsculas"],"correctIndex":1,"explanation":"A mayor temperatura, las opciones con menor probabilidad tienen más chances de ser elegidas, aumentando la creatividad y la variabilidad."},{"id":"q3","question":"¿Cómo funciona la técnica de muestreo Top-P (Nucleus Sampling)?","options":["Selecciona solo las palabras que empiezan con la letra P","Considera únicamente el grupo de tokens principales cuyas probabilidades acumuladas sumen el umbral P (ej. 90%)","Elimina todas las vocales","Duplica el tamaño de la ventana de contexto"],"correctIndex":1,"explanation":"Top-P filtra dinámicamente el vocabulario reteniendo solo los tokens más probables que acumulen el porcentaje P seleccionado."}]$JSON$,
    4
  );

  -- ==============================================================================
  -- MÓDULO 2: Embeddings, Vectores y Similitud Matemática
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 2: Embeddings, Vectores y Similitud Matemática',
    'Domina la representación vectorial del lenguaje, la similitud coseno y las bases de datos vectoriales.',
    '2'
  ) RETURNING id INTO v_m2_id;

  -- Lección 2.1: ¿Qué son los Embeddings?
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '1. ¿Qué son los Embeddings? El Significado en Números',
    'Aprende cómo transformamos texto, imágenes o código en vectores numéricos densos en alta dimensionalidad.',
    'quiz',
    100,
    $THEORY$# ¿Qué son los Embeddings?

Un **Embedding** es una representación numérica (un vector o arreglo de números flotantes) que captura el **significado semántico** de un fragmento de texto en un espacio multidimensional.

### 1. De Palabras a Coordenadas Geométricas:
Un modelo de embedding (como `text-embedding-3-small` de OpenAI o modelos de HuggingFace) convierte un texto en un vector de, por ejemplo, **1,536 dimensiones**:

```
"Perro"  --> [0.024, -0.045, 0.812, ..., -0.119] (1536 números)
"Cachorro"--> [0.021, -0.041, 0.798, ..., -0.115] (Muy cercano a "Perro")
"Automóvil"-> [-0.612, 0.401, -0.120, ..., 0.840] (Muy lejano en el espacio)
```

### 2. Propiedades Mágicas de los Embeddings:
1. **Cercanía por Significado, no por Letras**: `"Médico"` y `"Doctor"` tienen letras distintas pero sus vectores están a milímetros de distancia en el espacio vectorial.
2. **Aritmética Semántica**:
   $$\vec{Rey} - \vec{Hombre} + \vec{Mujer} \approx \vec{Reina}$$
3. **Compresión Universal**: Permite indexar manuales, libros, código fuente y consultas de usuarios para búsqueda semántica.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la función principal de un modelo de Embeddings en el procesamiento del lenguaje natural?","options":["Comprimir un archivo ZIP","Convertir un texto en un vector numérico multidimensional que representa su significado conceptual y semántico","Traducir automáticamente texto de español a código binario de 8 bits","Corregir faltas de ortografía únicamente"],"correctIndex":1,"explanation":"Los embeddings ubican los textos como puntos en un espacio geométrico donde la cercanía física refleja similitud de significado."},{"id":"q2","question":"Si calculamos los embeddings de las frases 'El paciente tiene fiebre' y 'El enfermo presenta temperatura elevada', ¿cómo serán sus vectores?","options":["Estarán extremadamente alejados porque no comparten palabras iguales","Estarán muy cercanos en el espacio vectorial porque expresan el mismo significado semántico","Serán vectores de longitud cero","Darán un error matemático"],"correctIndex":1,"explanation":"Los modelos de embeddings entienden la semántica; por tanto, sinónimos y frases con significado idéntico generan vectores muy próximos."},{"id":"q3","question":"¿Qué tamaño típico suele tener un vector de embeddings en modelos modernos?","options":["1 solo número","Cientos o miles de dimensiones (ej. 768, 1536 o 3072 números de coma flotante)","Exactamente 2 dimensiones (X e Y)","Infinitas dimensiones"],"correctIndex":1,"explanation":"Los embeddings modernos utilizan espacios densos de entre 768 y 3072 dimensiones para capturar matices lingüísticos complejos."}]$JSON$,
    1
  );

  -- Lección 2.2: Similitud Coseno y Métricas de Distancia
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '2. Similitud Coseno y Métricas de Distancia',
    'Aprende la matemática para comparar dos vectores: Similitud Coseno, Distancia Euclidiana y Producto Punto.',
    'quiz',
    100,
    $THEORY$# Similitud Coseno y Métricas de Distancia

Para saber qué tan parecidos son dos textos, comparamos la orientación de sus vectores de embeddings en el espacio.

### 1. Similitud Coseno (*Cosine Similarity*):
Es la métrica reina en IA. Mide el **coseno del ángulo $\theta$** entre dos vectores, ignorando su longitud (magnitud):

$$\text{Similitud Coseno}(A, B) = \cos(\theta) = \frac{A \cdot B}{\|A\| \|B\|}$$

- **$\cos(\theta) = 1.0$ ($0^\circ$)**: Vectores apuntan exactamente en la misma dirección $\to$ **Significado idéntico**.
- **$\cos(\theta) = 0.0$ ($90^\circ$)**: Vectores ortogonales $\to$ **Conceptos independientes / No relacionados**.
- **$\cos(\theta) = -1.0$ ($180^\circ$)**: Vectores en direcciones opuestas $\to$ **Significados opuestos**.

```
Vector A (Pregunta): "¿Cómo reiniciar el router?"
Vector B (Doc 1):    "Pasos para apagar y encender el módem de red." --> Similitud: 0.92
Vector C (Doc 2):    "Receta para preparar tarta de manzana."       --> Similitud: 0.04
```

### 2. Otras Métricas:
- **Distancia Euclidiana ($L2$)**: Mide la distancia geométrica en línea recta entre los dos puntos. Sensible a la longitud del texto.
- **Producto Punto (*Dot Product*)**: Si los vectores están normalizados (longitud = 1), el producto punto es idéntico a la similitud coseno y es ultra rápido de calcular en hardware.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Por qué la Similitud Coseno es preferida sobre la Distancia Euclidiana para comparar embeddings de texto?","options":["Porque la similitud coseno solo mide el ángulo y la dirección semántica, sin verse distorsionada por la longitud o magnitud del texto","Porque la distancia euclidiana no se puede programar","Porque la similitud coseno da siempre números enteros","Porque la similitud coseno solo funciona en dos dimensiones"],"correctIndex":0,"explanation":"La similitud coseno evalúa la orientación del vector semántico; dos textos sobre el mismo tema tendrán un ángulo muy pequeño aunque uno sea más largo."},{"id":"q2","question":"Si la similitud coseno entre la búsqueda de un usuario y un documento da un resultado de 0.95, ¿qué significa?","options":["Que los dos textos son completamente opuestos","Que el documento tiene una relevancia semántica altísima con la consulta del usuario","Que hubo un error de cálculo","Que el documento está corrupto"],"correctIndex":1,"explanation":"Un valor cercano a 1.0 (ángulo cercano a 0 grados) indica máxima coincidencia semántica entre la búsqueda y el documento."},{"id":"q3","question":"¿Cuál es el rango de valores posibles de la función Similitud Coseno?","options":["De 0 a 100","De -1.0 a +1.0","De 0 a infinito","De -100 a +100"],"correctIndex":1,"explanation":"El coseno trigonométrico de cualquier ángulo varía siempre en el intervalo cerrado [-1.0, 1.0]."}]$JSON$,
    2
  );

  -- Lección 2.3: Bases de Datos Vectoriales y Algoritmos ANN
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '3. Bases de Datos Vectoriales e Indexación (ANN / HNSW)',
    'Conoce por qué las bases de datos SQL tradicionales no escalan para vectores y cómo funcionan motores como pgvector o ChromaDB.',
    'quiz',
    100,
    $THEORY$# Bases de Datos Vectoriales

Las bases de datos relacionales tradicionales usan índices B-Tree para buscar números o textos ordenados ($A < B < C$). Pero no pueden ordenar puntos en un espacio de 1,536 dimensiones.

### 1. El Problema de la Fuerza Bruta ($k$-NN):
Si tienes 1 millón de documentos, calcular la similitud coseno de tu pregunta contra cada uno de ellos requiere 1 millón de productos de vectores en cada consulta (demasiado lento).

### 2. Algoritmos de Búsqueda Aproximada (*ANN - Approximate Nearest Neighbors*):
Sacrifican un 1% de precisión matemática a cambio de responder en **milisegundos**:
- **HNSW (*Hierarchical Navigable Small World*)**: Construye un grafo jerárquico multinivel (similar a una lista enlazada por saltos) para navegar rápidamente hacia los vecinos más cercanos.
- **IVF (*Inverted File Index*)**: Agrupa los vectores en clústeres (*Voronoi cells*) y solo busca dentro de los grupos más cercanos.

### 3. Ecosistema de Bases de Datos Vectoriales:
- **Especializadas**: Pinecone, Qdrant, ChromaDB, Milvus, Weaviate.
- **Extensiones sobre BD existentes**: `pgvector` para PostgreSQL (permite guardar vectores y hacer queries vectoriales en tu base de datos Supabase).$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la limitación de los índices tradicionales B-Tree frente a los datos vectoriales de alta dimensionalidad?","options":["Los índices B-Tree solo soportan números negativos","Los índices B-Tree solo pueden ordenar datos unidimensionales escalares y no pueden particionar espacios de 1536 dimensiones","Los índices B-Tree no funcionan en servidores Linux","Los índices B-Tree consumen demasiada energía eléctrica"],"correctIndex":1,"explanation":"B-Tree requiere un orden total unidimensional; en alta dimensionalidad (espacios vectoriales) se requiere indexación geométrica o basada en grafos."},{"id":"q2","question":"¿Qué objetivo persiguen los algoritmos ANN (Approximate Nearest Neighbors) como HNSW?","options":["Encontrar el documento más largo","Encontrar los vectores más similares en milisegundos navegando grafos en lugar de comparar contra toda la base de datos uno por uno","Comprimir las imágenes a formato JPEG","Generar contraseñas aleatorias"],"correctIndex":1,"explanation":"HNSW y los algoritmos ANN indexan el espacio para encontrar los vecinos más cercanos de forma ultra rápida sin fuerza bruta."},{"id":"q3","question":"¿Qué tecnología permite ejecutar búsquedas vectoriales directamente dentro de PostgreSQL y Supabase?","options":["pg_crypto","pgvector","PostGIS","PL/Python"],"correctIndex":1,"explanation":"pgvector es la extensión open-source estándar de PostgreSQL para almacenar vectores y calcular similitud coseno / distancia L2 nativamente con índices HNSW e IVFFlat."}]}$JSON$,
    3
  );

  -- Lección 2.4: Chunking y Particionado Estratégico
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m2_id,
    '4. Estrategias de Chunking y Preprocesamiento',
    'Aprende a fragmentar documentos grandes con solapamiento (overlap) para optimizar la recuperación vectorial.',
    'quiz',
    100,
    $THEORY$# Estrategias de Chunking

No podemos generar un único vector de embedding para un manual técnico de 500 páginas: los detalles específicos se diluirían en un vector genérico y sobrepasaríamos el límite del modelo.

Por eso, dividimos los documentos en **fragmentos (*Chunks*)**.

### 1. El Dilema del Tamaño del Chunk:
- **Chunks muy pequeños (ej: 50 tokens)**: Pierden el contexto circundante (ej. `"El precio es $500"`, ¿pero de qué producto?).
- **Chunks muy grandes (ej: 2,000 tokens)**: Diluyen la similitud semántica y llenan la ventana de contexto del LLM con paja irrelevante.
- **Tamaño ideal habitual**: **300 a 800 tokens**.

### 2. Chunking con Solapamiento (*Chunk Overlap*):
Para evitar que una frase importante quede cortada por la mitad entre dos fragmentos, añadimos un solapamiento (ej. 10% - 20% de overlap):

```
Chunk 1: [Palabras 1 a 500]
Chunk 2: [Palabras 450 a 950]  <-- Palabras 450-500 se repiten para preservar contexto
Chunk 3: [Palabras 900 a 1400]
```

### 3. Chunking Semántico / Estructurado:
En lugar de cortar por número ciego de caracteres, partimos por **secciones Markdown, párrafos o encabezados HTML** (`# Título`, `## Subtítulo`).$THEORY$,
    $JSON$[{"id":"q1","question":"¿Por qué es necesario dividir un documento extenso en fragmentos (chunks) antes de calcular sus embeddings?","options":["Porque los sistemas operativos no permiten archivos mayores a 1 MB","Para mantener una alta especificidad semántica en cada vector y permitir que el sistema recupere solo el párrafo relevante","Para que el texto sea ilegible","Para cambiar el idioma del documento"],"correctIndex":1,"explanation":"Dividir en chunks permite que el embedding represente ideas concretas y precisas, facilitando recuperar exactamente el dato que responde a la pregunta."},{"id":"q2","question":"¿Qué propósito tiene configurar un 'overlap' o solapamiento entre chunks consecutivos?","options":["Duplicar el tamaño de la base de datos a propósito","Evitar la pérdida de significado o fractura de oraciones en los bordes de corte entre fragmentos contiguos","Acelerar el ancho de banda de la red","Traducir las palabras repetidas"],"correctIndex":1,"explanation":"El overlap asegura que las oraciones que cruzan el límite del corte se preserven completas en al menos uno de los fragmentos."},{"id":"q3","question":"¿Qué método de particionado respeta mejor la coherencia del contenido técnico?","options":["Corte arbitrario cada 100 caracteres exactos","Chunking estructurado basado en la sintaxis del documento (encabezados Markdown, párrafos y funciones)","Eliminar todos los saltos de línea","Cortar solo después de números"],"correctIndex":1,"explanation":"El chunking estructurado agrupa bloques con significado completo (ej. una sección con su título y párrafos) preservando la relación lógica."}]}$JSON$,
    4
  );

  -- ==============================================================================
  -- MÓDULO 3: Arquitectura Transformer, RAG y Aplicaciones Modernas
  -- ==============================================================================
  INSERT INTO public.modules (course_id, title, description, difficulty_level)
  VALUES (
    v_course_id,
    'Módulo 3: Arquitectura Transformer, RAG y Aplicaciones Modernas',
    'Conoce el mecanismo de Auto-Atención, el flujo de trabajo de sistemas RAG y la prevención de alucinaciones.',
    '3'
  ) RETURNING id INTO v_m3_id;

  -- Lección 3.1: La Arquitectura Transformer y Auto-Atención
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '1. La Arquitectura Transformer y el Mecanismo de Auto-Atención',
    'Descubre el paper \'Attention Is All You Need\' y cómo las matrices Q, K y V revolucionaron la IA.',
    'quiz',
    125,
    $THEORY$# La Arquitectura Transformer (2017)

Antes de 2017, la IA procesaba texto de forma secuencial (palabra por palabra) usando **RNNs** y **LSTMs**, lo que impedía el entrenamiento en paralelo y causaba que el modelo olvidara el inicio de frases largas.

El paper *"Attention Is All You Need"* (Google Brain) introdujo el **Transformer**, base de GPT, Claude, Gemini, BERT y LLaMA.

### 🧠 El Mecanismo de Auto-Atención (*Self-Attention*):
Permite que cada palabra de una frase analice y pondere su relación con **todas las demás palabras** simultáneamente.

Ejemplo:
> *"El animal no cruzó la calle porque **estaba** demasiado cansado."*

¿A qué se refiere *"estaba"*? ¿Al animal o a la calle?
Mediante matrices de atención:
1. **Query ($Q$)**: Lo que la palabra busca.
2. **Key ($K$)**: Lo que cada palabra ofrece como etiqueta.
3. **Value ($V$)**: El contenido informativo real de la palabra.

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{Q K^T}{\sqrt{d_k}}\right) V$$

El mecanismo asigna un peso altísimo entre *"estaba"* y *"animal"*, resolviendo la ambigüedad al instante y de forma paralelizable en miles de GPUs.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál fue la principal ventaja del Transformer sobre las redes recurrentes anteriores (RNN / LSTM)?","options":["Que consumía menos memoria RAM en teléfonos","Que eliminó el procesamiento secuencial, permitiendo procesar todas las palabras a la vez y entrenar masivamente en paralelo sobre miles de GPUs","Que no utilizaba números flotantes","Que solo funcionaba para traducir inglés"],"correctIndex":1,"explanation":"El paralelismo del Transformer permitió entrenar con billones de tokens de texto, escalando el aprendizaje a niveles nunca antes vistos."},{"id":"q2","question":"En la fórmula de atención de Transformers, ¿qué representan los tres componentes Q, K y V?","options":["Query (Consulta), Key (Clave) y Value (Valor)","Quantum, Kinetic y Velocity","Quick, Kernel y Vector","Question, Knowledge y Variable"],"correctIndex":0,"explanation":"Inspirado en sistemas de búsqueda: Query (lo que se busca), Key (índice identificador) y Value (el valor ponderado final)."},{"id":"q3","question":"¿Qué problema lingüístico resuelve el mecanismo de atención al analizar una frase compleja?","options":["La velocidad de tipeo del teclado","Identificar a qué sujetos o conceptos previos se refieren los pronombres y adjetivos según el contexto de toda la oración","La compresión de archivos de audio","El cálculo del precio de la energía"],"correctIndex":1,"explanation":"La atención dinámica pondera las dependencias a larga distancia entre palabras, resolviendo ambigüedades semánticas con precisión."}]}$JSON$,
    1
  );

  -- Lección 3.2: RAG (Retrieval-Augmented Generation)
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '2. RAG (Retrieval-Augmented Generation): Conectando LLMs a Datos Privados',
    'Domina la arquitectura empresarial más demandada: búsqueda semántica inyectada en el prompt de contexto.',
    'quiz',
    125,
    $THEORY$# RAG (Retrieval-Augmented Generation)

Los LLMs tienen dos grandes problemas en producción:
1. **Corte de Conocimiento (*Knowledge Cutoff*)**: No saben nada de eventos posteriores a su fecha de entrenamiento.
2. **Desconocimiento de Datos Privados**: No conocen los PDFs internos, bases de datos o manuales de tu empresa.

**RAG** soluciona esto sin necesidad de re-entrenar el modelo.

```
                   ┌────────────────────────────────────────┐
                   │        1. BASE DE DATOS VECTORIAL      │
                   │ (Chunks de tus PDFs / Docs de Empresa) │
                   └──────────────────┬─────────────────────┘
                                      │
[Pregunta del Usuario]                │ 3. Recupera los 3 chunks
          │                           │    más relevantes (Top-K)
          ▼                           ▼
[Modelo de Embeddings] ──> [Búsqueda Vectorial]
                                      │
                                      ▼
[Prompt Enriquecido]:
"Responde a la pregunta utilizando ÚNICAMENTE la siguiente información oficial:
--- CONTEXTO RECUPERADO: {chunks} ---
Pregunta: {pregunta_usuario}"
                                      │
                                      ▼
                                   [LLM]
                                      │
                                      ▼
                        [Respuesta Precisa y Citada]
```

### Ventajas de RAG:
- ✅ **Cero reentrenamiento**: Actualizar la información es tan simple como añadir nuevos vectores a la base de datos.
- ✅ **Trazabilidad**: Permite citar la página o documento fuente exacto.
- ✅ **Seguridad**: Permite filtrar vectores según el rol y permisos del usuario.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es el flujo secuencial fundamental de una arquitectura RAG?","options":["El usuario pregunta -> El modelo adivina -> Se guarda en SQL","Pregunta del usuario -> Generar embedding -> Buscar chunks relevantes en BD Vectorial -> Inyectar contexto en el prompt -> LLM genera respuesta fundamentada","Entrenar un modelo desde cero cada vez que el usuario hace una pregunta","Traducir la pregunta a lenguaje ensamblador"],"correctIndex":1,"explanation":"RAG recupera primero la información precisa de una base vectorial y se la entrega al LLM dentro de su prompt como contexto para responder."},{"id":"q2","question":"¿Cuál es la principal ventaja de RAG frente a realizar un Fine-Tuning para actualizar el conocimiento de una empresa?","options":["RAG no requiere GPUs caras para reentrenar y los datos se actualizan en tiempo real simplemente insertando nuevos documentos en la base vectorial","RAG hace que el modelo pese 0 megabytes","RAG no requiere conexión a Internet","El Fine-Tuning es gratuito"],"correctIndex":0,"explanation":"RAG desacopla el conocimiento dinámico del modelo base; actualizar un documento solo requiere re-indexar ese archivo en milisegundos."},{"id":"q3","question":"¿Cómo ayuda RAG a auditar las respuestas en entornos corporativos o legales?","options":["Firmando digitalmente cada token","Permitiendo devolver las referencias, URLs o números de página exactos de donde se extrajo la respuesta","Eliminando la base de datos","Cambiando el color del texto"],"correctIndex":1,"explanation":"Al inyectar fragmentos identificados, el sistema puede mostrar al usuario la fuente original exacta que respalda la respuesta."}]}$JSON$,
    2
  );

  -- Lección 3.3: Alucinaciones en IA y Mitigación
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '3. Alucinaciones en IA: Causas y Técnicas de Mitigación',
    'Comprende por qué los modelos inventan datos con total convicción y qué técnicas existen para mitigarlo.',
    'quiz',
    125,
    $THEORY$# Alucinaciones en Modelos de Lenguaje

Una **alucinación** ocurre cuando un LLM genera información factualmente falsa, inventa referencias inexistentes o afirma hechos erróneos con un tono de total seguridad y elocuencia.

### ❓ ¿Por qué alucinan los LLMs?
1. **Naturaleza Probabilística**: Un LLM no tiene un motor de lógica formal ni una base de datos de "hechos verificados"; su objetivo es generar texto estadísticamente plausible.
2. **Sesgo de Completar**: Si se le pregunta por algo que desconoce, el modelo intentará completar el patrón lingüístico antes que admitir ignorancia (a menos que esté instruido para no hacerlo).
3. **Compresión con Pérdida**: Durante el pre-entrenamiento, el modelo comprime billones de datos en pesos matemáticos, perdiendo detalles hiperespecíficos.

### 🛡️ Técnicas de Mitigación en Producción:
1. **RAG (Grounding)**: Obligar al modelo en las *System Instructions* a responder **únicamente** con el contexto provisto y decir *"No dispongo de esa información"* si no está en el texto.
2. **Cadena de Pensamiento (*Chain-of-Thought / CoT*)**: Indicar al modelo *"Piensa paso a paso antes de responder"*, lo que le permite generar tokens de razonamiento intermedio.
3. **Temperatura Baja ($0.0 - 0.2$)**: Reduce la dispersión estocástica en respuestas que requieran precisión.
4. **Validación de Esquema Estructurado**: Uso de *Function Calling* o *Structured Outputs* (JSON Schema) para evitar respuestas libres descontroladas.$THEORY$,
    $JSON$[{"id":"q1","question":"¿Cuál es la causa técnica principal por la que un LLM puede generar 'alucinaciones'?","options":["Un virus informático en el servidor","Porque los LLMs optimizan la plausibilidad lingüística y probabilística de los tokens, no la verificación de la verdad fáctica","Porque la pantalla del usuario tiene baja resolución","Porque el modelo se queda sin memoria RAM"],"correctIndex":1,"explanation":"El LLM genera la continuación más coherente según sus patrones estadísticos, lo que puede resultar en textos muy convincentes pero falsos."},{"id":"q2","question":"¿Qué instrucción en el System Prompt es una práctica estándar para reducir alucinaciones en un asistente de soporte?","options":["'Responde lo primero que se te ocurra'","'Basa tu respuesta estrictamente en el contexto proporcionado; si la respuesta no se encuentra en el texto, indica claramente que no tienes esa información'","'Inventa una respuesta si no estás seguro'","'Habla como un pirata'"],"correctIndex":1,"explanation":"Restringir el dominio de respuesta (Grounding) y dar permiso explícito para admitir desconocimiento reduce drásticamente las alucinaciones."},{"id":"q3","question":"¿En qué consiste la técnica de 'Chain of Thought' (Cadena de Pensamiento)?","options":["En conectar varias computadoras en anillo","En forzar al modelo a verbalizar y desglosar su razonamiento paso a paso antes de emitir la conclusión final","En encadenar múltiples modelos en paralelo","En borrar la memoria de contexto"],"correctIndex":1,"explanation":"Chain of Thought permite que el modelo use tokens intermedios de cálculo y deducción, aumentando notablemente el acierto en problemas lógicos."}]}$JSON$,
    3
  );

  -- Lección 3.4: Prompt Engineering vs RAG vs Fine-Tuning
  INSERT INTO challenges (module_id, title, description, challenge_type, xp_reward, theory, test_code, order_index)
  VALUES (
    v_m3_id,
    '4. Estrategias: Prompt Engineering vs RAG vs Fine-Tuning',
    'Aprende a elegir la arquitectura correcta para cada caso de negocio evaluando coste, tiempo y mantenimiento.',
    'quiz',
    125,
    $THEORY$# Prompt Engineering vs RAG vs Fine-Tuning

Como arquitecto o desarrollador de software con IA, elegir la herramienta correcta ahorra miles de dólares y meses de desarrollo.

| Criterio | **Prompt Engineering** | **RAG (Recuperación Vectorial)** | **Fine-Tuning (Ajuste Fino)** |
| :--- | :--- | :--- | :--- |
| **Objetivo** | Guiar comportamiento y formato | Añadir conocimiento dinámico/privado | Adaptar tono, estilo o tarea especializada |
| **Coste** | Mínimo ($) | Bajo / Moderado ($$) | Alto ($$$) en cómputo y datasets |
| **Tiempo de Setup** | Minutos | Horas / Días | Días / Semanas |
| **Actualización Datos**| Inmediata en el prompt | Inmediata (insertar en BD vectorial) | Requiere re-entrenamiento completo |
| **Alucinaciones** | Moderadas | Mínimas (con buen contexto) | No elimina alucinaciones por sí solo |

### 🎯 La Regla de Decisión Práctica:
1. **Empieza siempre con Prompt Engineering** (Few-Shot, System Prompts claros).
2. **Si necesitas que la IA conozca documentos propios o datos actualizados $\to$ Implementa RAG**.
3. **Si necesitas que el modelo hable con una jerga muy particular, aprenda un formato de salida complejo o clasifique datos a alta velocidad con un modelo pequeño $\to$ Realiza Fine-Tuning**.$THEORY$,
    $JSON$[{"id":"q1","question":"Si tu empresa tiene 5,000 manuales internos en PDF que cambian semanalmente y necesitas un chatbot para que los empleados consulten políticas, ¿cuál es la solución técnica adecuada?","options":["Fine-Tuning de un modelo open-source cada semana","Implementar un sistema RAG con una base de datos vectorial para indexar los manuales","Escribir los 5,000 PDFs a mano en el System Prompt","Desarrollar un nuevo LLM desde cero"],"correctIndex":1,"explanation":"RAG es la arquitectura ideal para datos dinámicos y documentos privados extensos que cambian con frecuencia."},{"id":"q2","question":"¿Para qué escenario resulta ideal aplicar Fine-Tuning a un modelo de lenguaje?","options":["Para enseñarle noticias de hoy que acaban de ocurrir","Para especializar a un modelo en un estilo de redacción médico particular, un formato de salida compacto o una tarea repetitiva específica","Para evitar pagar licencias de software","Para cambiar el procesador de la máquina"],"correctIndex":1,"explanation":"Fine-Tuning modifica los pesos internos para ajustar el estilo, tono, sintaxis o especialización en una tarea concreta."},{"id":"q3","question":"¿Cuál es el primer paso recomendado según las mejores prácticas antes de invertir recursos en Fine-Tuning o infraestructuras complejas?","options":["Comprar servidores de 50,000 dólares","Comenzar explorando técnicas avanzadas de Prompt Engineering y Few-Shot Learning con modelos existentes","Reescribir toda la aplicación en C++","Entrenar un modelo de 100 billones de parámetros"],"correctIndex":1,"explanation":"El Prompt Engineering es rápido, económico y permite validar si el caso de uso se resuelve antes de incurrir en costes de ingeniería mayores."}]}$JSON$,
    4
  );

  -- Notificación global sobre el nuevo curso disponible
  PERFORM public.broadcast_system_notification(
    '¡Nuevo Curso de IA y LLMs Disponible! 🚀',
    'Aprende Fundamentos de Inteligencia Artificial: Machine Learning, Embeddings, Similitud Coseno, Bases Vectoriales y sistemas RAG.',
    '/cursos/' || v_course_id || '/preview'
  );

END $$;
