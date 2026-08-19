"use client";

import { useState } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Topbar } from "@/components/layout/Topbar";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { useSidebar } from "@/context/SidebarContext";
import { 
  BookOpen, 
  Search, 
  Code2, 
  TerminalSquare, 
  Globe, 
  Cpu, 
  Zap, 
  Copy, 
  Check, 
  ExternalLink,
  ChevronRight,
  ShieldCheck
} from "lucide-react";
import Link from "next/link";
import ReactMarkdown from "react-markdown";

interface DocTopic {
  id: string;
  category: string;
  title: string;
  badge: string;
  summary: string;
  content: string;
}

const DOC_TOPICS: DocTopic[] = [
  {
    id: "js-variables",
    category: "Fundamentos JS",
    title: "Variables, Constantes y Tipos de Datos",
    badge: "Módulo 1",
    summary: "Aprende las diferencias clave entre const, let, tipos primitivos y operaciones aritméticas.",
    content: `### 📦 Variables y Constantes
En JavaScript moderno existen dos formas principales de declarar datos:

- **\`const\`**: Para valores inmutables que no deben reasignarse (ej: URLs, configuraciones, nombres).
- **\`let\`**: Para valores variables que cambiarán con el tiempo (ej: contadores, iteradores, estados).

\`\`\`js
// Ejemplo Práctico:
const appName = "Codify";
let userLevel = 1;
userLevel = userLevel + 1; // 2
\`\`\`

### ➕ Operadores Principales
- **Aritméticos**: \`+\`, \`-\`, \`*\`, \`/\`, \`%\` (módulo).
- **Comparación**: \`===\` (estricto igual), \`!\==\` (diferente), \`>\`, \`<\`, \`>=\`, \`<=\`.
`
  },
  {
    id: "poo-classes",
    category: "Programación Orientada a Objetos",
    title: "Objetos Literales, Clases y Herencia",
    badge: "Módulo 2",
    summary: "Modela entidades del mundo real usando objetos, la palabra clave this, constructores y herencia con extends.",
    content: `### 🛡️ Objetos y la palabra clave \`this\`
Un objeto literal agrupa propiedades y funciones (métodos). Dentro de un método, \`this\` hace referencia al propio objeto.

\`\`\`js
const jugador = {
  nombre: "Heroe",
  hp: 100,
  recibirDanio(cantidad) {
    this.hp -= cantidad;
  }
};
jugador.recibirDanio(20); // hp = 80
\`\`\`

### 🏭 Clases e Herencia (\`class\` & \`extends\`)
Las clases actúan como plantillas para instanciar objetos únicos.

\`\`\`js
class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

class Mago extends Personaje {
  constructor(nombre, hp, mana) {
    super(nombre, hp);
    this.mana = mana;
  }
}
\`\`\`
`
  },
  {
    id: "web-dom",
    category: "Desarrollo Web",
    title: "Estructura HTML5, CSS Flexbox y Manipulación del DOM",
    badge: "Módulo 3",
    summary: "Aprende a seleccionar elementos del DOM, modificar su contenido y alinear vistas con Flexbox.",
    content: `### 🌐 Selección y Modificación del DOM
El DOM (Document Object Model) te permite interactuar dinámicamente con tu HTML desde JavaScript.

\`\`\`js
// Seleccionar por ID
const titulo = document.getElementById("tituloApp");
titulo.textContent = "Bienvenido a Codify";

// Escuchar eventos
const boton = document.querySelector(".btn-submit");
boton.addEventListener("click", () => {
  alert("¡Hiciste clic!");
});
\`\`\`

### 📐 CSS Flexbox Básicos
\`\`\`css
.contenedor-flex {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}
\`\`\`
`
  },
  {
    id: "async-fetch",
    category: "Asincronismo",
    title: "Promesas, fetch() y Sintaxis async / await",
    badge: "Módulo 4",
    summary: "Consume APIs REST de forma segura procesando datos JSON y capturando errores con try/catch.",
    content: `### ⏳ Consumo de APIs con \`async / await\`
\`async / await\` permite escribir código asincrónico limpio y secuencial sin caer en el Callback Hell.

\`\`\`js
async function consultarClima(ciudad) {
  try {
    const response = await fetch(\`https://api.clima.com/data?q=\${ciudad}\`);
    if (!response.ok) throw new Error("Error en la petición");
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Fallo de red:", error.message);
    return null;
  }
}
\`\`\`
`
  },
  {
    id: "python-backend",
    category: "Python & Backend",
    title: "Sintaxis Python 3.12+, Type Hints y Estructuras de Datos",
    badge: "Módulo 5",
    summary: "Guía de referencia para Python moderno: tipado estático, dicts, listas e indicios de tipo (Type Hints).",
    content: `### 🐍 Python Moderno & Type Hints
Python permite añadir notaciones de tipo opcionales que mejoran la seguridad y autocompletado en IDEs.

\`\`\`python
def calcular_total(precio: float, descuento: float = 0.0) -> float:
    return precio * (1.0 - descuento)

# List Comprehensions:
numeros = [1, 2, 3, 4, 5]
pares = [n for n in numeros if n % 2 == 0]
\`\`\`
`
  },
  {
    id: "fastapi-docs",
    category: "APIs & FastAPI",
    title: "Desarrollo de APIs Asincrónicas con FastAPI & Pydantic",
    badge: "Módulo 6",
    summary: "Crea servidores Web de alto rendimiento con FastAPI, esquemas Pydantic y documentación Swagger automática.",
    content: `### ⚡ FastAPI & Pydantic Schemas
FastAPI genera documentación interactiva Swagger (\`/docs\`) automáticamente basándose en modelos de Pydantic.

\`\`\`python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    nombre: str
    precio: float
    en_stock: bool = True

@app.post("/items/")
async def crear_item(item: Item):
    return {"status": "creado", "item": item}
\`\`\`
`
  },
  {
    id: "ia-llm",
    category: "IA Aplicada",
    title: "Integración de LLMs, Structured Outputs y Prompting",
    badge: "Módulo 7",
    summary: "Aprende a conectar la API de Gemini / OpenAI en tus aplicaciones y extraer datos en JSON estricto.",
    content: `### 🤖 Prompt Engineering Estructurado
Al comunicarte con modelos de Inteligencia Artificial (LLMs), los **System Prompts** y la salida formateada son esenciales para construir agentes fiables.

\`\`\`python
# Ejemplo de prompt estructurado con JSON Schema
prompt_sistema = """
Eres un asistente clasificador de soporte técnico.
Devuelve SIEMPRE la respuesta en formato JSON estricto con las llaves:
{"categoria": "Facturacion|Tecnico|General", "prioridad": 1-5}
"""
\`\`\`
`
  }
];

export default function DocsPage() {
  const { isCollapsed } = useSidebar();
  const [selectedTopicId, setSelectedTopicId] = useState<string>("js-variables");
  const [searchQuery, setSearchQuery] = useState("");
  const [copied, setCopied] = useState(false);

  const activeTopic = DOC_TOPICS.find((t) => t.id === selectedTopicId) || DOC_TOPICS[0];

  const filteredTopics = DOC_TOPICS.filter(
    (t) =>
      t.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      t.category.toLowerCase().includes(searchQuery.toLowerCase()) ||
      t.summary.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleCopyCode = () => {
    navigator.clipboard.writeText(activeTopic.content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar />
      <div className={`${isCollapsed ? "md:ml-20" : "md:ml-64"} ml-0 flex-1 flex flex-col min-h-screen relative overflow-hidden transition-all duration-300`}>
        
        {/* Background glow effects */}
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary/20 blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-accent/20 blur-[120px] pointer-events-none" />

        <Topbar />

        <main className="flex-1 p-6 lg:p-8 overflow-y-auto z-10 relative space-y-8 max-w-7xl mx-auto w-full">
          
          {/* Header Banner */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 border-b border-white/10 pb-6">
            <div className="space-y-2">
              <div className="flex items-center gap-2 text-primary font-bold text-xs uppercase tracking-wider">
                <BookOpen size={16} />
                <span>Documentación Oficial & Cheat Sheets</span>
              </div>
              <h1 className="text-3xl lg:text-4xl font-heading font-bold text-white">
                Guías de Estudio & Referencia Técnica
              </h1>
              <p className="text-sm text-zinc-400 max-w-2xl">
                Revisa la documentación oficial de cada módulo, ejemplos de código probados, cheat sheets y patrones de arquitectura para Python, Web, FastAPI e IA.
              </p>
            </div>

            {/* Search Input */}
            <div className="relative w-full md:w-72">
              <Search size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-zinc-400" />
              <input
                type="text"
                placeholder="Buscar tema o tecnología..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-black/60 border border-white/10 rounded-xl pl-10 pr-4 py-2 text-sm text-white outline-none focus:border-primary transition-colors"
              />
            </div>
          </div>

          {/* Main Docs Content Layout */}
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-8 items-start">
            
            {/* Left Col: Topic Navigation list */}
            <Card className="lg:col-span-1 p-4 glass space-y-2 sticky top-24 max-h-[80vh] overflow-y-auto custom-scrollbar">
              <span className="text-xs font-bold text-zinc-400 uppercase tracking-wider px-3 mb-2 block font-mono">
                Temas ({filteredTopics.length})
              </span>
              
              {filteredTopics.map((topic) => {
                const isActive = topic.id === selectedTopicId;
                return (
                  <button
                    key={topic.id}
                    onClick={() => setSelectedTopicId(topic.id)}
                    className={`w-full text-left p-3 rounded-xl transition-all flex flex-col gap-1 border ${
                      isActive
                        ? "bg-primary/20 border-primary/40 text-white shadow-lg"
                        : "bg-black/20 border-white/5 text-zinc-400 hover:text-white hover:bg-white/5"
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-white/5 text-primary">
                        {topic.badge}
                      </span>
                      <ChevronRight size={14} className={isActive ? "text-primary" : "text-zinc-600"} />
                    </div>
                    <h4 className="font-heading font-bold text-sm line-clamp-1">{topic.title}</h4>
                  </button>
                );
              })}
            </Card>

            {/* Right 3 Cols: Selected Doc Detail view */}
            <div className="lg:col-span-3 space-y-6">
              <Card className="p-6 lg:p-8 glass-panel border-t-4 border-t-primary space-y-6 shadow-2xl">
                
                {/* Doc Header */}
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-white/10 pb-6">
                  <div>
                    <span className="text-xs font-bold text-accent uppercase tracking-wider">
                      {activeTopic.category} • {activeTopic.badge}
                    </span>
                    <h2 className="text-2xl lg:text-3xl font-heading font-bold text-white mt-1">
                      {activeTopic.title}
                    </h2>
                    <p className="text-sm text-zinc-400 mt-2 max-w-2xl">
                      {activeTopic.summary}
                    </p>
                  </div>

                  <div className="flex items-center gap-3 shrink-0">
                    <Button 
                      size="sm" 
                      variant="secondary" 
                      onClick={handleCopyCode}
                      leftIcon={copied ? <Check size={16} className="text-emerald-400" /> : <Copy size={16} />}
                    >
                      {copied ? "Copiado" : "Copiar Guía"}
                    </Button>

                    <Link href="/ide">
                      <Button size="sm" leftIcon={<TerminalSquare size={16} />}>
                        Probar en IDE
                      </Button>
                    </Link>
                  </div>
                </div>

                {/* Markdown Content */}
                <div className="prose prose-invert max-w-none text-zinc-300 font-sans leading-relaxed">
                  <ReactMarkdown
                    components={{
                      h3: ({ children }) => (
                        <h3 className="text-xl font-heading font-bold text-white mt-8 mb-4 flex items-center gap-2 border-b border-white/10 pb-2">
                          {children}
                        </h3>
                      ),
                      strong: ({ children }) => (
                        <strong className="text-primary font-bold bg-primary/10 px-2 py-0.5 rounded border border-primary/20">
                          {children}
                        </strong>
                      ),
                      code({ node, className, children, ...props }: any) {
                        const match = /language-(\w+)/.exec(className || "");
                        const codeStr = String(children).replace(/\n$/, "");
                        const isBlock = match || codeStr.includes("\n");

                        if (isBlock) {
                          return (
                            <div className="my-5 rounded-2xl overflow-hidden border border-white/10 bg-[#0d0d11] font-mono text-xs sm:text-sm shadow-xl">
                              <div className="bg-black/60 px-4 py-2 border-b border-white/10 text-xs text-zinc-400 flex items-center justify-between">
                                <span className="font-bold text-primary tracking-wider uppercase text-[11px]">
                                  {match ? match[1] : "EJEMPLO DE CÓDIGO"}
                                </span>
                              </div>
                              <pre className="p-4 overflow-x-auto text-emerald-300 font-mono text-xs sm:text-sm leading-relaxed whitespace-pre m-0">
                                <code>{codeStr}</code>
                              </pre>
                            </div>
                          );
                        }
                        return (
                          <code className="bg-primary/20 text-purple-300 border border-primary/30 px-1.5 py-0.5 rounded font-mono text-xs font-semibold mx-0.5 inline-block">
                            {children}
                          </code>
                        );
                      }
                    }}
                  >
                    {activeTopic.content}
                  </ReactMarkdown>
                </div>

              </Card>
            </div>

          </div>

        </main>
      </div>
    </div>
  );
}
