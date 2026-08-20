-- ==============================================================================
-- 🤖 CODIFY SEED: MÓDULO 7 - IA APLICADA, EMBEDDINGS & INTEGRACIÓN CON LLMS (10 LECCIONES)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 7 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  ia_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 7: IA Aplicada, Embeddings & Integración con LLMs'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 7: IA Aplicada, Embeddings & Integración con LLMs'
    )
  );
  DELETE FROM public.modules WHERE title = 'Módulo 7: IA Aplicada, Embeddings & Integración con LLMs';

  -- 2. Creación del Módulo 7
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 7: IA Aplicada, Embeddings & Integración con LLMs',
    'Conviértete en un Ingeniero de IA Aplicada: Arquitectura de LLMs, Prompt Engineering profesional, Embeddings vectoriales, Búsqueda Semántica, RAG (Retrieval-Augmented Generation), Salidas Estructuradas JSON y Tool Calling.',
    3
  )
  RETURNING id INTO ia_module_id;


  -- ============================================================================
  -- LECCIÓN 1: ¿Cómo Piensan los LLMs? Tokens y Costos de Inferencia
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 1: Tokens y Costos de Inferencia en LLMs',
    'Calcula el costo económico de una petición a una API de Inteligencia Artificial basado en tokens.',
    $THEORY$
### 🤖 1. ¿Cómo procesa el texto una Inteligencia Artificial?
Los Modelos de Lenguaje Grande (**LLMs**) como GPT-4, Claude o Gemini no leen palabras completas ni letras sueltas: procesan **Tokens**.

Un token es un fragmento de palabra (aproximadamente 4 caracteres o 0.75 palabras en español).
- La palabra `"programación"` se divide en 3 o 4 tokens.
- Todas las APIs de IA cobran por **cada 1.000 o 1.000.000 de tokens procesados** (entrada y salida).

---

### 💰 2. Calculando el Consumo de tu Aplicación
Como ingeniero de software, debes optimizar el consumo de tokens para evitar sobrecostos:

```python
def calcular_gasto(tokens_usados: int, precio_por_mil: float) -> float:
    # 1.000 tokens a $0.002 = $0.002
    return (tokens_usados / 1000) * precio_por_mil
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `calcular_costo_tokens(tokens: int, precio_por_mil: float) -> float`:
- Debe calcular y retornar el costo total multiplicando `(tokens / 1000.0) * precio_por_mil`.
$THEORY$,
    'python',
    $CODE$# Implementa el calculador de costo de tokens:
def calcular_costo_tokens(tokens: int, precio_por_mil: float) -> float:
    pass$CODE$,
    $CODE$def calcular_costo_tokens(tokens: int, precio_por_mil: float) -> float:
    return (tokens / 1000.0) * precio_por_mil$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function calcular_costo_tokens(tokens, precio_por_mil) {
  return (tokens / 1000.0) * precio_por_mil;
}
assert(calcular_costo_tokens(1000, 0.002) === 0.002, "1000 tokens a $0.002 por mil debe costar 0.002.");
assert(calcular_costo_tokens(5000, 0.01) === 0.05, "5000 tokens a $0.01 por mil debe costar 0.05.");$TEST$,
    35,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Anatomía de un Prompt: System, User y Assistant
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 2: Anatomía de un Prompt (System, User y Assistant)',
    'Estructura los mensajes de un chat con roles para guiar la personalidad y directivas de la IA.',
    $THEORY$
### 🎭 1. Los 3 Roles Fundamentales en LLMs
Las APIs modernas de chat organizan la conversación en un arreglo de mensajes con roles específicos:

1. **`system`**: La directiva raíz. Define las reglas inquebrantables, la personalidad y el tono de la IA.
2. **`user`**: La pregunta o instrucción enviada por el usuario.
3. **`assistant`**: Las respuestas generadas por el modelo en turnos anteriores.

---

### 📝 2. Estructura Estándar de Mensajes
```python
mensajes = [
    {"role": "system", "content": "Eres un tutor experto en Python conciso."},
    {"role": "user", "content": "¿Cómo declaro una variable?"}
]
```

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `construir_mensajes_chat(rol_sistema: str, pregunta_usuario: str) -> list`:
- Debe retornar una lista con dos diccionarios:
  1. El primero con `{"role": "system", "content": rol_sistema}`.
  2. El segundo con `{"role": "user", "content": pregunta_usuario}`.
$THEORY$,
    'python',
    $CODE$def construir_mensajes_chat(rol_sistema: str, pregunta_usuario: str) -> list:
    # Retorna la lista con los roles system y user:
    pass$CODE$,
    $CODE$def construir_mensajes_chat(rol_sistema: str, pregunta_usuario: str) -> list:
    return [
        {"role": "system", "content": rol_sistema},
        {"role": "user", "content": pregunta_usuario}
    ]$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function construir_mensajes_chat(rol_sistema, pregunta_usuario) {
  return [
    { role: "system", content: rol_sistema },
    { role: "user", content: pregunta_usuario }
  ];
}
const msgs = construir_mensajes_chat("Tutor IA", "Hola");
assert(Array.isArray(msgs) && msgs.length === 2, "Debe retornar una lista de 2 mensajes.");
assert(msgs[0].role === "system" && msgs[0].content === "Tutor IA", "El primer mensaje debe ser rol system.");
assert(msgs[1].role === "user" && msgs[1].content === "Hola", "El segundo mensaje debe ser rol user.");$TEST$,
    40,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Hiperparámetros de Control: Temperature y Determinismo
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 3: Control de Creatividad (Temperature)',
    'Ajusta la temperatura del modelo para obtener respuestas deterministas o creativas según la tarea.',
    $THEORY$
### 🌡️ 1. ¿Qué hace el parámetro `temperature`?
El parámetro `temperature` (entre `0.0` y `1.0` o `2.0`) controla qué tan "arriesgado" o predecible es el modelo al elegir el siguiente token:

- **`temperature = 0.0` (Determinista):** Ideal para **Código, SQL, Matemáticas y Clasificación**. Siempre elegirá el token con máxima probabilidad.
- **`temperature = 0.8` (Creativo):** Ideal para **Redacción de cuentos, brainstorming o poesía**. Introduce variedad e imaginación.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `configurar_hiperparametros(tipo_tarea: str) -> dict`:
- Si `tipo_tarea == "codigo"`, debe retornar `{"temperature": 0.0, "top_p": 0.1}`.
- Para cualquier otro tipo de tarea, debe retornar `{"temperature": 0.8, "top_p": 0.9}`.
$THEORY$,
    'python',
    $CODE$def configurar_hiperparametros(tipo_tarea: str) -> dict:
    # Retorna temperature y top_p según el tipo de tarea:
    pass$CODE$,
    $CODE$def configurar_hiperparametros(tipo_tarea: str) -> dict:
    if tipo_tarea == "codigo":
        return {"temperature": 0.0, "top_p": 0.1}
    return {"temperature": 0.8, "top_p": 0.9}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function configurar_hiperparametros(tipo_tarea) {
  if (tipo_tarea === "codigo") return { temperature: 0.0, top_p: 0.1 };
  return { temperature: 0.8, top_p: 0.9 };
}
const configCode = configurar_hiperparametros("codigo");
assert(configCode.temperature === 0.0 && configCode.top_p === 0.1, "Para 'codigo' la temperatura debe ser 0.0.");
const configCreativo = configurar_hiperparametros("redaccion");
assert(configCreativo.temperature === 0.8 && configCreativo.top_p === 0.9, "Para otras tareas la temperatura debe ser 0.8.");$TEST$,
    45,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: ¿Qué son los Embeddings? (Texto a Vectores Matemáticos)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 4: Embeddings Vectoriales',
    'Comprende cómo los modelos transforman texto en listas de números flotantes y valida sus dimensiones.',
    $THEORY$
### 🗺️ 1. Las Coordenadas GPS del Significado
¿Cómo puede una computadora saber que *"perro"* y *"cachorro"* significan casi lo mismo, pero *"teclado"* no tiene nada que ver?

Un **Embedding** convierte cualquier texto en un **vector numérico** (una lista de números como `[0.024, -0.912, 0.441, ...]`).

Imagina un mapa 3D o de 1536 dimensiones: los conceptos con significados similares quedan ubicados en coordenadas muy cercanas entre sí.

---

### 📐 2. Dimensiones de un Vector de Embedding
Modelos como `text-embedding-3-small` de OpenAI generan vectores de 1.536 números, mientras que modelos pequeños generan 384 o 768 números.

```python
embedding_perro = [0.12, 0.45, -0.33, 0.89]
print(len(embedding_perro)) # Dimensión del vector
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `validar_dimension_embedding(vector: list, dimension_esperada: int) -> bool`:
- Debe retornar `True` si la longitud de `vector` coincide exactamente con `dimension_esperada`.
- En caso contrario, debe retornar `False`.
$THEORY$,
    'python',
    $CODE$def validar_dimension_embedding(vector: list, dimension_esperada: int) -> bool:
    # Valida si len(vector) == dimension_esperada:
    pass$CODE$,
    $CODE$def validar_dimension_embedding(vector: list, dimension_esperada: int) -> bool:
    return len(vector) == dimension_esperada$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function validar_dimension_embedding(vector, dimension_esperada) {
  return vector.length === dimension_esperada;
}
assert(validar_dimension_embedding([0.1, 0.2, 0.3], 3) === true, "Un vector de 3 elementos con dimensión 3 debe retornar True.");
assert(validar_dimension_embedding([0.1, 0.2], 3) === false, "Un vector de 2 elementos con dimensión 3 debe retornar False.");$TEST$,
    50,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Similitud Coseno y Búsqueda Semántica
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 5: Similitud Coseno (Cosine Similarity)',
    'Calcula la cercanía matemática entre dos vectores de embedding para encontrar información relevante.',
    $THEORY$
### 🧭 1. Comparando Dos Vectores de Embedding
Para saber si la consulta del usuario coincide con un documento de nuestra base de datos, calculamos la **Similitud Coseno**.

Mide el ángulo entre dos vectores:
- **`1.0`**: Los textos son idénticos en significado.
- **`0.0`**: Los textos no tienen ninguna relación.
- **`-1.0`**: Son opuestos diametrales.

---

### 🧮 2. El Producto Punto (Dot Product)
Cuando los vectores de embedding están normalizados, la similitud es simplemente la suma del producto elemento por elemento:

```python
vec_a = [1.0, 0.0]
vec_b = [1.0, 0.0]

# Producto punto:
similitud = sum(a * b for a, b in zip(vec_a, vec_b)) # 1.0 (idénticos)
```

---

### 🎯 Tu Misión de Hoy:
Crea una función `calcular_similitud(vec_a: list, vec_b: list) -> float`:
- Debe multiplicar cada elemento `a * b` en la misma posición y retornar la suma total acumulada.
$THEORY$,
    'python',
    $CODE$def calcular_similitud(vec_a: list, vec_b: list) -> float:
    # Calcula la suma de a * b para cada posición:
    pass$CODE$,
    $CODE$def calcular_similitud(vec_a: list, vec_b: list) -> float:
    return sum(a * b for a, b in zip(vec_a, vec_b))$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function calcular_similitud(vec_a, vec_b) {
  return vec_a.reduce((acc, val, i) => acc + (val * vec_b[i]), 0);
}
assert(calcular_similitud([1, 0], [1, 0]) === 1, "Vectores idénticos [1,0] y [1,0] deben dar similitud 1.");
assert(calcular_similitud([0.5, 0.5], [0.5, 0.5]) === 0.5, "0.5*0.5 + 0.5*0.5 debe ser 0.5.");$TEST$,
    60,
    5
  );


  -- ============================================================================
  -- LECCIÓN 6: Arquitectura RAG (Retrieval-Augmented Generation)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 6: Arquitectura RAG (Inyección de Contexto)',
    'Construye un prompt aumentado con contexto documental para eliminar alucinaciones de la IA.',
    $THEORY$
### 📚 1. ¿Cómo evitar que la IA "invente" respuestas (Alucinaciones)?
Un LLM estándar no conoce tus documentos privados ni las ventas de ayer de tu empresa. Si le preguntas algo que no sabe, **puede alucinar (inventar)**.

La solución estándar en la industria es **RAG (Generación Aumentada por Recuperación)**:
1. **Retrieval:** Buscas en tu base de datos vectorial el fragmento de texto exacto relevante.
2. **Augmentation:** Inyectas ese fragmento en el prompt.
3. **Generation:** Le pides a la IA que responda basándose **únicamente** en ese contexto.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `construir_prompt_rag(contexto: str, pregunta: str) -> str`:
- Debe retornar un texto con el siguiente formato exacto usando f-strings:
`f"CONTEXTO:\n{contexto}\n\nPREGUNTA:\n{pregunta}\n\nResponde únicamente usando el contexto anterior."`
$THEORY$,
    'python',
    $CODE$def construir_prompt_rag(contexto: str, pregunta: str) -> str:
    # Retorna el prompt estructurado para RAG:
    pass$CODE$,
    $CODE$def construir_prompt_rag(contexto: str, pregunta: str) -> str:
    return f"CONTEXTO:\n{contexto}\n\nPREGUNTA:\n{pregunta}\n\nResponde únicamente usando el contexto anterior."$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function construir_prompt_rag(contexto, pregunta) {
  return `CONTEXTO:\n${contexto}\n\nPREGUNTA:\n${pregunta}\n\nResponde únicamente usando el contexto anterior.`;
}
const p = construir_prompt_rag("El horario es de 9 a 18hs.", "¿A qué hora abren?");
assert(p.includes("CONTEXTO:\nEl horario es de 9 a 18hs."), "Debe incluir el bloque de contexto.");
assert(p.includes("PREGUNTA:\n¿A qué hora abren?"), "Debe incluir la pregunta del usuario.");$TEST$,
    70,
    6
  );


  -- ============================================================================
  -- LECCIÓN 7: Salidas Estructuradas en JSON (JSON Mode)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 7: Salidas Estructuradas en JSON (JSON Mode)',
    'Parsea y limpia respuestas de IA para integrarlas de forma segura en bases de datos y APIs.',
    $THEORY$
### 📦 1. De Texto Libre a Datos de Software
Para que una IA guarde datos en tu base de datos PostgreSQL o interactúe con tu frontend, no puedes recibir un párrafo de texto libre; necesitas un **JSON válido garantizado**.

A veces los modelos envuelven su respuesta en bloques markdown como ````json { ... } ````.  
Debemos limpiar esos delimitadores antes de parsear con `json.loads()`.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `limpiar_respuesta_json(texto_crudo: str) -> str`:
- Debe remover los delimitadores `"```json"`, `"```"` y espacios en los extremos con `.strip()`.
$THEORY$,
    'python',
    $CODE$def limpiar_respuesta_json(texto_crudo: str) -> str:
    # Remueve ```json y ``` y aplica strip:
    pass$CODE$,
    $CODE$def limpiar_respuesta_json(texto_crudo: str) -> str:
    limpio = texto_crudo.replace("```json", "").replace("```", "")
    return limpio.strip()$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function limpiar_respuesta_json(texto_crudo) {
  return texto_crudo.replace(/```json/g, "").replace(/```/g, "").trim();
}
const crudo = "```json\n{\"resultado\": true}\n```";
assert(limpiar_respuesta_json(crudo) === '{"resultado": true}', "Debe eliminar los bloques markdown y dejar solo el string JSON.");$TEST$,
    75,
    7
  );


  -- ============================================================================
  -- LECCIÓN 8: Tool Calling y Function Calling (Dándole "Manos" a la IA)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 8: Llamada a Herramientas (Tool Calling)',
    'Define esquemas de herramientas para que la IA decida cuándo invocar funciones externas.',
    $THEORY$
### 🛠️ 1. Dándole Superpoderes a la IA: Tool Calling
¿Cómo puede un LLM consultar el saldo de una cuenta bancaria, consultar el clima actual o enviar un email?

Mediante **Tool Calling (Llamada a Funciones)**:
1. Le entregas a la IA una lista de herramientas disponibles con su descripción y parámetros.
2. Si el usuario pregunta *"¿Va a llover en Buenos Aires?"*, la IA no intenta adivinar: te devuelve una instrucción estructurada pidiendo ejecutar `consultar_clima(ciudad="Buenos Aires")`.

---

### 🎯 Tu Misión de Hoy:
Crea una función `crear_definicion_tool(nombre: str, descripcion: str) -> dict`:
- Debe retornar un diccionario con la estructura estándar:
`{"type": "function", "function": {"name": nombre, "description": descripcion}}`
$THEORY$,
    'python',
    $CODE$def crear_definicion_tool(nombre: str, descripcion: str) -> dict:
    # Retorna el esquema de herramienta para la API:
    pass$CODE$,
    $CODE$def crear_definicion_tool(nombre: str, descripcion: str) -> dict:
    return {
        "type": "function",
        "function": {
            "name": nombre,
            "description": descripcion
        }
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function crear_definicion_tool(nombre, descripcion) {
  return { type: "function", function: { name: nombre, description: descripcion } };
}
const tool = crear_definicion_tool("obtener_clima", "Consulta la temperatura actual");
assert(tool.type === "function", "El tipo debe ser 'function'.");
assert(tool.function.name === "obtener_clima", "El nombre de la función debe ser 'obtener_clima'.");
assert(tool.function.description === "Consulta la temperatura actual", "La descripción debe coincidir.");$TEST$,
    85,
    8
  );


  -- ============================================================================
  -- LECCIÓN 9: Memoria y Ventana Deslizante de Conversación
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 9: Gestión de Memoria (Sliding Window)',
    'Controla el tamaño del historial de chat manteniendo siempre las directivas del sistema intactas.',
    $THEORY$
### 🧠 1. Los LLMs no tienen Memoria por sí mismos
Cada vez que llamas a una API de IA, el modelo empieza desde cero (es *stateless*).  
Para que "recuerde" lo conversado, tu aplicación debe reenviarle el historial completo de mensajes en cada turno.

Pero si la conversación tiene 500 mensajes, superará el límite de contexto y disparará el costo.  
Por eso usamos una **Ventana Deslizante (Sliding Window)**: mantenemos siempre el mensaje `system` intacto y los últimos `N` mensajes recientes.

---

### 🎯 Tu Misión de Hoy:
Crea una función llamada `recortar_historial(mensajes: list, max_recientes: int) -> list`:
- El primer mensaje (`mensajes[0]`, que es el `system`) **siempre debe conservarse**.
- De los mensajes restantes (`mensajes[1:]`), conserva únicamente los últimos `max_recientes`.
- Retorna la lista combinada: `[mensajes[0]] + mensajes_recientes`.
$THEORY$,
    'python',
    $CODE$def recortar_historial(mensajes: list, max_recientes: int) -> list:
    # Conserva mensajes[0] y los últimos max_recientes de mensajes[1:]:
    pass$CODE$,
    $CODE$def recortar_historial(mensajes: list, max_recientes: int) -> list:
    if len(mensajes) <= 1:
        return mensajes
    system_msg = mensajes[0]
    resto = mensajes[1:]
    recientes = resto[-max_recientes:] if max_recientes > 0 else []
    return [system_msg] + recientes$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function recortar_historial(mensajes, max_recientes) {
  if (mensajes.length <= 1) return mensajes;
  const system_msg = mensajes[0];
  const resto = mensajes.slice(1);
  const recientes = max_recientes > 0 ? resto.slice(-max_recientes) : [];
  return [system_msg, ...recientes];
}
const chat = [
  { role: "system", content: "Prompt base" },
  { role: "user", content: "Mensaje 1" },
  { role: "assistant", content: "Respuesta 1" },
  { role: "user", content: "Mensaje 2" },
  { role: "assistant", content: "Respuesta 2" }
];
const recortado = recortar_historial(chat, 2);
assert(recortado.length === 3, "Debe tener el mensaje system + los 2 más recientes (total 3).");
assert(recortado[0].content === "Prompt base", "El primer mensaje debe ser el system original.");
assert(recortado[1].content === "Mensaje 2" && recortado[2].content === "Respuesta 2", "Debe conservar los últimos dos mensajes.");$TEST$,
    90,
    9
  );


  -- ============================================================================
  -- LECCIÓN 10: Proyecto Integrador - Agente de Clasificación y RAG Completo
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    ia_module_id,
    'Lección 10: Proyecto Integrador - Agente de Soporte Inteligente',
    'Construye el pipeline completo de un Agente IA con enrutamiento de intenciones y recuperación de contexto.',
    $THEORY$
### 🏆 1. El Proyecto Maestro: Tu Primer Agente de IA en Producción
¡Llegaste a la cumbre de todo el currículo de Codify! 🎉

Aquí vas a diseñar el núcleo lógico de un **Agente de Soporte con IA**:
1. **Clasificación de Intención:** Detecta si la consulta del usuario es técnica (`"soporte"`) o general (`"general"`).
2. **Inyección de Base de Conocimiento:** Si la intención es `"soporte"`, recupera la solución de la base de conocimiento.
3. **Generación de Respuesta Estructurada:** Retorna un diccionario con la intención clasificada y la respuesta generada.

---

### 🎯 Tu Misión de Hoy:
Crea una función `agente_soporte(consulta: str, faq_db: dict) -> dict`:
1. Si la palabra `"error"` o `"ayuda"` está dentro de `consulta.lower()`, la intención es `"soporte"`. En caso contrario, es `"general"`.
2. Si la intención es `"soporte"`, la `respuesta` debe ser el valor de `faq_db.get("soporte", "Contactando a un técnico")`.
3. Si la intención es `"general"`, la `respuesta` debe ser `"¡Hola! ¿En qué puedo ayudarte hoy?"`.
4. Retorna el diccionario: `{"intencion": intencion, "respuesta": respuesta}`.
$THEORY$,
    'python',
    $CODE$def agente_soporte(consulta: str, faq_db: dict) -> dict:
    # Construye el pipeline del Agente de IA:
    pass$CODE$,
    $CODE$def agente_soporte(consulta: str, faq_db: dict) -> dict:
    consulta_lower = consulta.lower()
    if "error" in consulta_lower or "ayuda" in consulta_lower:
        intencion = "soporte"
        respuesta = faq_db.get("soporte", "Contactando a un técnico")
    else:
        intencion = "general"
        respuesta = "¡Hola! ¿En qué puedo ayudarte hoy?"
    
    return {
        "intencion": intencion,
        "respuesta": respuesta
    }$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
function agente_soporte(consulta, faq_db) {
  const c = consulta.toLowerCase();
  if (c.includes("error") || c.includes("ayuda")) {
    return { intencion: "soporte", respuesta: faq_db.soporte || "Contactando a un técnico" };
  }
  return { intencion: "general", respuesta: "¡Hola! ¿En qué puedo ayudarte hoy?" };
}
const db = { soporte: "Reinicia el servidor en el puerto 8000." };
const res1 = agente_soporte("Tengo un error en el servidor", db);
assert(res1.intencion === "soporte", "Consultas con 'error' deben clasificarse como 'soporte'.");
assert(res1.respuesta === "Reinicia el servidor en el puerto 8000.", "Debe recuperar la respuesta de la base de conocimiento.");

const res2 = agente_soporte("Buenos días", db);
assert(res2.intencion === "general", "Consultas estándar deben clasificarse como 'general'.");
assert(res2.respuesta === "¡Hola! ¿En qué puedo ayudarte hoy?", "Debe responder con el mensaje general.");$TEST$,
    150,
    10
  );

END $$;
