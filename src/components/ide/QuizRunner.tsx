"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/Button";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { 
  CheckCircle2, 
  XCircle, 
  HelpCircle, 
  Award, 
  ArrowRight, 
  RefreshCw, 
  Lightbulb, 
  PenTool,
  Keyboard,
  Sparkles,
  Copy,
  Check,
  Code2
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export interface QuizQuestion {
  id: string;
  question: string;
  code?: string;
  codeLanguage?: string;
  type?: "choice" | "input";
  options?: string[];
  correctIndex?: number;
  expectedAnswer?: string;
  acceptedAnswers?: string[];
  placeholder?: string;
  inputMode?: "text" | "numeric" | "big-o";
  caseSensitive?: boolean;
  explanation: string;
}

interface QuizRunnerProps {
  questions: QuizQuestion[];
  xpReward: number;
  onComplete: () => void;
  maxAttempts?: number;
  attemptsLeft?: number;
  onFailAttempt?: () => void;
}

// Mezcla las opciones de una pregunta de selección múltiple
function shuffleQuestionOptions(q: QuizQuestion): QuizQuestion {
  if (!q.options || q.options.length <= 1) return q;

  const indexed = q.options.map((opt, idx) => ({
    text: opt,
    isCorrect: idx === (q.correctIndex ?? 0),
  }));

  for (let i = indexed.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [indexed[i], indexed[j]] = [indexed[j], indexed[i]];
  }

  const newOptions = indexed.map((item) => item.text);
  const newCorrectIndex = indexed.findIndex((item) => item.isCorrect);

  return {
    ...q,
    options: newOptions,
    correctIndex: newCorrectIndex >= 0 ? newCorrectIndex : 0,
  };
}

// Preprocesa y detecta código o fórmulas matemáticas en enunciados
function formatQuestionText(text: string): string {
  if (!text) return "";
  let processed = text.replace(/\\r\\n/g, "\n").replace(/\\n/g, "\n");

  // Si no tiene bloques de código con ``` pero contiene código evidente (def, int, while, for...)
  if (!processed.includes("```")) {
    const codeMatch = processed.match(/(Considera [^\n:]+:\s*\n+)([\s\S]*?)(\n\s*(?:Si|¿|Calcula|Dada|En|Entre|\?)[^\n]*[\s\S]*)$/i);
    if (codeMatch) {
      const header = codeMatch[1].trim();
      const code = codeMatch[2].trim();
      const prompt = codeMatch[3].trim();
      
      const lang = code.includes("def ") || code.includes("range(") ? "python" :
                   code.includes("int ") || code.includes("cout") || code.includes("#include") ? "cpp" : "javascript";

      processed = `${header}\n\n\`\`\`${lang}\n${code}\n\`\`\`\n\n${prompt}`;
    }
  }

  // Notaciones matemáticas y superíndices habituales
  processed = processed
    .replace(/\bn\^4\b/g, "n⁴")
    .replace(/\bn\^3\b/g, "n³")
    .replace(/\bn\^2\b/g, "n²")
    .replace(/\bx\^n\b/g, "xⁿ")
    .replace(/\b2\^4\b/g, "2⁴")
    .replace(/\b2\^8\b/g, "2⁸")
    .replace(/\b2\^10\b/g, "2¹⁰")
    .replace(/\$O\(([^$]+)\)\$/g, "`O($1)`")
    .replace(/\$n\s*=\s*(\d+)\$/g, "*n* = $1")
    .replace(/\$([a-zA-Z0-9_+*/^= -]+)\$/g, "*$1*");

  // Resalta la pregunta interrogativa principal si no está ya en negrita
  processed = processed.replace(/(?<!\*)(¿[^?\n]+\?)(?!\*)/g, "**$1**");

  return processed;
}

// Componente interactivo para bloques de código con cabecera y botón de copiado
function CodeSnippetBlock({ code, language }: { code: string; language?: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (e) {
      console.error("Error al copiar código:", e);
    }
  };

  const lines = code.trim().split("\n");
  const displayLang = (language || "código").toUpperCase();

  return (
    <div className="my-4 rounded-2xl overflow-hidden border border-white/10 bg-[#09090f] shadow-2xl transition-all hover:border-white/20">
      {/* Top Bar Header */}
      <div className="bg-black/60 px-4 py-2 border-b border-white/10 flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          {/* Traffic light dots */}
          <div className="flex items-center gap-1.5">
            <div className="w-2.5 h-2.5 rounded-full bg-red-500/70" />
            <div className="w-2.5 h-2.5 rounded-full bg-amber-500/70" />
            <div className="w-2.5 h-2.5 rounded-full bg-emerald-500/70" />
          </div>
          <div className="h-3.5 w-px bg-white/10 mx-1" />
          <div className="flex items-center gap-1.5 text-zinc-400 font-mono text-xs">
            <Code2 size={13} className="text-purple-400" />
            <span className="font-bold tracking-wider text-[11px] text-zinc-300">
              {displayLang}
            </span>
          </div>
        </div>

        <button
          type="button"
          onClick={handleCopy}
          className="flex items-center gap-1.5 text-[11px] font-mono px-2.5 py-1 rounded-lg bg-white/5 hover:bg-white/10 text-zinc-300 hover:text-white transition-all border border-white/5 active:scale-95 cursor-pointer"
          title="Copiar código al portapapeles"
        >
          {copied ? (
            <>
              <Check size={12} className="text-emerald-400" />
              <span className="text-emerald-400 font-bold">Copiado</span>
            </>
          ) : (
            <>
              <Copy size={12} className="text-zinc-400" />
              <span>Copiar</span>
            </>
          )}
        </button>
      </div>

      {/* Code body with line numbers */}
      <div className="flex font-mono text-xs sm:text-sm leading-relaxed overflow-x-auto p-4 bg-[#09090e]">
        <div className="select-none text-zinc-600 text-right pr-3.5 border-r border-white/10 font-mono text-xs space-y-0.5">
          {lines.map((_, i) => (
            <div key={i}>{i + 1}</div>
          ))}
        </div>
        <pre className="pl-4 text-emerald-300 font-mono overflow-x-auto m-0 flex-1 whitespace-pre">
          <code>{code}</code>
        </pre>
      </div>
    </div>
  );
}

// Renderizador visual de preguntas con Markdown y Código
function QuestionContentRenderer({
  question,
  code,
  codeLanguage,
}: {
  question: string;
  code?: string;
  codeLanguage?: string;
}) {
  const formatted = formatQuestionText(question);

  return (
    <div className="space-y-3 font-sans">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          h1: ({ children }) => (
            <h1 className="text-xl sm:text-2xl font-heading font-bold text-white mb-2 leading-snug">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 className="text-lg sm:text-xl font-heading font-bold text-white mb-2 leading-snug">
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 className="text-base sm:text-lg font-heading font-semibold text-purple-300 mb-2">
              {children}
            </h3>
          ),
          p: ({ children }) => (
            <p className="text-base sm:text-lg text-zinc-200 leading-relaxed my-2 font-medium">
              {children}
            </p>
          ),
          blockquote: ({ children }) => (
            <blockquote className="my-3 border-l-4 border-purple-500 bg-purple-500/10 px-4 py-3 rounded-r-xl text-zinc-200 text-sm sm:text-base font-medium">
              {children}
            </blockquote>
          ),
          pre: ({ children }) => <>{children}</>,
          code({ node, className, children, ...props }: any) {
            const match = /language-(\w+)/.exec(className || "");
            const codeString = String(children).replace(/\n$/, "");
            const isBlock = match || codeString.includes("\n");

            if (isBlock) {
              return (
                <CodeSnippetBlock
                  code={codeString}
                  language={match ? match[1] : codeLanguage}
                />
              );
            }

            return (
              <code className="bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-1.5 py-0.5 rounded font-mono text-xs sm:text-sm font-bold mx-0.5 inline-block shadow-sm">
                {children}
              </code>
            );
          },
          strong: ({ children }) => (
            <strong className="text-white font-bold bg-white/10 px-1.5 py-0.5 rounded border border-white/15">
              {children}
            </strong>
          ),
          em: ({ children }) => (
            <em className="text-purple-300 font-serif italic">{children}</em>
          ),
          ul: ({ children }) => (
            <ul className="space-y-1.5 my-2 pl-2 list-none">{children}</ul>
          ),
          ol: ({ children }) => (
            <ol className="space-y-1.5 my-2 pl-4 list-decimal text-zinc-300">{children}</ol>
          ),
          li: ({ children }) => (
            <li className="flex items-start gap-2 text-zinc-200 text-sm sm:text-base leading-relaxed">
              <span className="text-primary font-bold shrink-0 mt-0.5">•</span>
              <div className="flex-1">{children}</div>
            </li>
          ),
        }}
      >
        {formatted}
      </ReactMarkdown>

      {/* Si se pasa un fragmento de código explícito por propiedad */}
      {code && (
        <CodeSnippetBlock code={code} language={codeLanguage} />
      )}
    </div>
  );
}

// Renderizador visual de explicaciones pedagógicas
function ExplanationRenderer({ content }: { content: string }) {
  if (!content) return null;
  const formatted = content
    .replace(/\\r\\n/g, "\n")
    .replace(/\\n/g, "\n")
    .replace(/\$O\(([^$]+)\)\$/g, "`O($1)`")
    .replace(/\$([a-zA-Z0-9_+*/^= -]+)\$/g, "*$1*");

  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      components={{
        p: ({ children }) => (
          <p className="text-xs sm:text-sm leading-relaxed my-1 text-zinc-200">
            {children}
          </p>
        ),
        pre: ({ children }) => <>{children}</>,
        code({ node, className, children, ...props }: any) {
          return (
            <code className="bg-black/40 text-emerald-300 border border-white/10 px-1 py-0.5 rounded font-mono text-xs font-bold mx-0.5 inline-block">
              {children}
            </code>
          );
        },
        strong: ({ children }) => (
          <strong className="text-white font-bold">{children}</strong>
        ),
      }}
    >
      {formatted}
    </ReactMarkdown>
  );
}

// Normaliza respuestas de texto para comparaciones flexibles
function normalizeAnswer(str: string, mode?: "text" | "numeric" | "big-o", caseSensitive?: boolean): string {
  if (!str) return "";
  let res = str.trim();
  if (!caseSensitive) {
    res = res.toLowerCase();
  }

  if (mode === "big-o" || res.startsWith("o(") || res.includes("log") || res.includes("^")) {
    res = res.replace(/\s+/g, " ");
    res = res.replace(/\(\s+/g, "(").replace(/\s+\)/g, ")");
    res = res.replace(/\*\*/g, "^");
    res = res.replace(/\*\s*/g, " ");
  }

  return res.trim();
}

// Verifica si la respuesta tipeada es válida
function checkInputAnswer(userAnswer: string, q: QuizQuestion): boolean {
  if (!userAnswer) return false;
  const userNorm = normalizeAnswer(userAnswer, q.inputMode, q.caseSensitive);
  
  const targets = [
    q.expectedAnswer || "",
    ...(q.acceptedAnswers || [])
  ].filter(Boolean);

  for (const target of targets) {
    const targetNorm = normalizeAnswer(target, q.inputMode, q.caseSensitive);
    if (userNorm === targetNorm) return true;

    // Comparación numérica
    if (q.inputMode === "numeric" || (!isNaN(Number(userNorm)) && !isNaN(Number(targetNorm)))) {
      if (Math.abs(parseFloat(userNorm) - parseFloat(targetNorm)) < 0.0001) {
        return true;
      }
    }

    // Variaciones comunes de Big-O: con o sin "O("
    const strippedUser = userNorm.replace(/^o\((.*)\)$/, "$1").trim();
    const strippedTarget = targetNorm.replace(/^o\((.*)\)$/, "$1").trim();
    if (strippedUser && strippedTarget && strippedUser === strippedTarget) {
      return true;
    }
  }

  return false;
}

export function QuizRunner({ 
  questions, 
  xpReward, 
  onComplete,
  maxAttempts,
  attemptsLeft,
  onFailAttempt
}: QuizRunnerProps) {
  const [shuffledQuestions, setShuffledQuestions] = useState<QuizQuestion[]>(() =>
    questions.map(shuffleQuestionOptions)
  );
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedOption, setSelectedOption] = useState<number | null>(null);
  const [typedAnswer, setTypedAnswer] = useState("");
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [score, setScore] = useState(0);
  const [quizFinished, setQuizFinished] = useState(false);

  useEffect(() => {
    setShuffledQuestions(questions.map(shuffleQuestionOptions));
    setCurrentIndex(0);
    setSelectedOption(null);
    setTypedAnswer("");
    setIsSubmitted(false);
    setScore(0);
    setQuizFinished(false);
  }, [questions]);

  const activeQuestions = shuffledQuestions.length > 0 ? shuffledQuestions : questions;

  const currentQ = activeQuestions[currentIndex] || {
    id: "default",
    question: "¿Cuál es el resultado de typeof [] en JavaScript?",
    options: ["'array'", "'object'", "'list'", "'undefined'"],
    correctIndex: 1,
    explanation: "En JavaScript, los arreglos son un tipo especial de objeto, por lo que typeof [] retorna 'object'."
  };

  const isInputType = currentQ.type === "input" || (!currentQ.options || currentQ.options.length === 0);

  const isCurrentCorrect = isInputType
    ? checkInputAnswer(typedAnswer, currentQ)
    : selectedOption === currentQ.correctIndex;

  const handleSelectOption = (index: number) => {
    if (isSubmitted) return;
    setSelectedOption(index);
  };

  const handleSubmitAnswer = () => {
    if (isInputType) {
      if (!typedAnswer.trim()) return;
      setIsSubmitted(true);
      if (checkInputAnswer(typedAnswer, currentQ)) {
        setScore((prev) => prev + 1);
      }
    } else {
      if (selectedOption === null) return;
      setIsSubmitted(true);
      if (selectedOption === currentQ.correctIndex) {
        setScore((prev) => prev + 1);
      }
    }
  };

  const handleNextQuestion = () => {
    if (currentIndex + 1 < activeQuestions.length) {
      setCurrentIndex((prev) => prev + 1);
      setSelectedOption(null);
      setTypedAnswer("");
      setIsSubmitted(false);
    } else {
      setQuizFinished(true);
      const total = activeQuestions.length || 1;
      const percentage = Math.round((score / total) * 100);
      if (percentage >= 70) {
        onComplete();
      } else if (onFailAttempt) {
        onFailAttempt();
      }
    }
  };

  const handleRetry = () => {
    setShuffledQuestions(questions.map(shuffleQuestionOptions));
    setCurrentIndex(0);
    setSelectedOption(null);
    setTypedAnswer("");
    setIsSubmitted(false);
    setScore(0);
    setQuizFinished(false);
  };

  const total = activeQuestions.length || 1;
  const percentage = Math.round((score / total) * 100);
  const passed = percentage >= 70;

  return (
    <div className="w-full h-full flex flex-col justify-between p-6 bg-[#0d0d11] rounded-2xl border border-white/10 overflow-y-auto">
      
      {!quizFinished ? (
        <div className="space-y-6 max-w-3xl mx-auto w-full py-4">
          
          {/* Header & Question Counter */}
          <div className="flex items-center justify-between border-b border-white/10 pb-4">
            <div className="flex items-center gap-2 text-accent font-bold text-xs uppercase tracking-wider">
              {isInputType ? (
                <>
                  <PenTool size={18} className="text-purple-400" />
                  <span className="text-purple-300">Ejercicio Práctico & Respuesta Libre</span>
                </>
              ) : (
                <>
                  <HelpCircle size={18} />
                  <span>Evaluación Teórica Multiple Choice</span>
                </>
              )}
            </div>
            <span className="text-xs text-zinc-400 font-mono">
              Pregunta {currentIndex + 1} de {activeQuestions.length}
            </span>
          </div>

          {/* Question Text & Code Renderer */}
          <QuestionContentRenderer
            question={currentQ.question}
            code={currentQ.code}
            codeLanguage={currentQ.codeLanguage}
          />

          {/* Formato de Respuesta: Cuadro de Texto vs Opciones Múltiples */}
          {isInputType ? (
            <div className="space-y-4 pt-2">
              <div className="p-4 rounded-xl bg-purple-500/10 border border-purple-500/20 text-xs text-purple-300 flex items-start gap-3">
                <Keyboard size={18} className="text-purple-400 shrink-0 mt-0.5" />
                <div>
                  <span className="font-bold text-foreground block">Resolución Manual o en tu Terminal</span>
                  <span className="text-muted leading-relaxed">
                    Realiza el análisis o cálculo en una hoja o en tu PC y escribe tu respuesta en el cuadro inferior. Presiona <kbd className="px-1.5 py-0.5 bg-white/10 rounded text-foreground font-mono">Enter</kbd> para confirmar.
                  </span>
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-xs font-mono text-zinc-400 block font-semibold uppercase tracking-wider">
                  Tu Respuesta:
                </label>
                <div className="relative">
                  <input
                    type="text"
                    value={typedAnswer}
                    onChange={(e) => !isSubmitted && setTypedAnswer(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === "Enter" && !isSubmitted && typedAnswer.trim()) {
                        handleSubmitAnswer();
                      }
                    }}
                    disabled={isSubmitted}
                    placeholder={currentQ.placeholder || "Escribe tu respuesta aquí (ej: O(n log n), 42)..."}
                    className={`w-full px-4 py-3.5 rounded-xl border font-mono text-sm sm:text-base outline-none transition-all ${
                      isSubmitted
                        ? isCurrentCorrect
                          ? "bg-emerald-950/20 border-emerald-500 text-emerald-300 shadow-[0_0_15px_rgba(52,211,153,0.3)]"
                          : "bg-red-950/20 border-red-500 text-red-300 shadow-[0_0_15px_rgba(239,68,68,0.3)]"
                        : "bg-black/40 border-white/10 text-white focus:border-primary focus:ring-2 focus:ring-primary/20 hover:border-white/20"
                    }`}
                    autoFocus
                  />
                  {isSubmitted && (
                    <div className="absolute right-3.5 top-1/2 -translate-y-1/2">
                      {isCurrentCorrect ? (
                        <CheckCircle2 size={22} className="text-emerald-400" />
                      ) : (
                        <XCircle size={22} className="text-red-400" />
                      )}
                    </div>
                  )}
                </div>
                {!isSubmitted && (
                  <span className="text-[11px] text-muted font-mono block">
                    💡 El evaluador tolera mayúsculas/minúsculas y formatos equivalentes.
                  </span>
                )}
              </div>
            </div>
          ) : (
            <div className="space-y-3 pt-2">
              {(currentQ.options || []).map((opt, idx) => {
                const isSelected = selectedOption === idx;
                const isCorrect = idx === currentQ.correctIndex;

                let btnStyle = "bg-black/40 border-white/10 hover:border-primary/50 text-zinc-300";
                if (isSubmitted) {
                  if (isCorrect) {
                    btnStyle = "bg-emerald-500/20 border-emerald-500 text-emerald-300 font-bold shadow-[0_0_15px_rgba(52,211,153,0.3)]";
                  } else if (isSelected && !isCorrect) {
                    btnStyle = "bg-red-500/20 border-red-500 text-red-300 font-bold";
                  } else {
                    btnStyle = "bg-black/20 border-white/5 text-zinc-600 opacity-50";
                  }
                } else if (isSelected) {
                  btnStyle = "bg-primary/20 border-primary text-primary font-bold shadow-lg";
                }

                return (
                  <button
                    key={idx}
                    onClick={() => handleSelectOption(idx)}
                    className={`w-full p-4 rounded-xl border text-left transition-all flex items-center justify-between gap-4 ${btnStyle}`}
                  >
                    <div className="flex items-center gap-3">
                      <span className="w-7 h-7 rounded-lg bg-white/5 border border-white/10 flex items-center justify-center font-mono text-xs font-bold shrink-0">
                        {String.fromCharCode(65 + idx)}
                      </span>
                      <span className="text-sm font-medium">{opt}</span>
                    </div>

                    {isSubmitted && isCorrect && <CheckCircle2 size={20} className="text-emerald-400 shrink-0" />}
                    {isSubmitted && isSelected && !isCorrect && <XCircle size={20} className="text-red-400 shrink-0" />}
                  </button>
                );
              })}
            </div>
          )}

          {/* Submitted Explanation Feedback */}
          <AnimatePresence>
            {isSubmitted && (
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className={`p-4 rounded-xl border space-y-2 ${
                  isCurrentCorrect
                    ? "bg-emerald-950/20 border-emerald-500/30 text-emerald-300"
                    : "bg-red-950/20 border-red-500/30 text-red-300"
                }`}
              >
                <div className="flex items-center gap-2 font-bold text-sm">
                  <Lightbulb size={16} />
                  <span>{isCurrentCorrect ? "¡Respuesta Correcta!" : "Explicación Pedagógica:"}</span>
                </div>
                {!isCurrentCorrect && isInputType && (
                  <div className="text-xs bg-black/40 p-2.5 rounded-lg border border-red-500/20 font-mono">
                    <span className="text-muted">Respuesta esperada: </span>
                    <strong className="text-emerald-400">
                      {currentQ.expectedAnswer || currentQ.acceptedAnswers?.[0] || "No especificada"}
                    </strong>
                  </div>
                )}
                <ExplanationRenderer content={currentQ.explanation} />
              </motion.div>
            )}
          </AnimatePresence>

          {/* Action Button */}
          <div className="pt-4 flex justify-end">
            {!isSubmitted ? (
              <Button
                size="lg"
                disabled={isInputType ? !typedAnswer.trim() : selectedOption === null}
                onClick={handleSubmitAnswer}
                className="w-full sm:w-auto"
              >
                Confirmar Respuesta
              </Button>
            ) : (
              <Button
                size="lg"
                onClick={handleNextQuestion}
                rightIcon={<ArrowRight size={18} />}
                className="w-full sm:w-auto bg-emerald-500 hover:bg-emerald-600 text-black font-bold border-none"
              >
                {currentIndex + 1 < activeQuestions.length ? "Siguiente Pregunta" : "Finalizar Evaluación"}
              </Button>
            )}
          </div>

        </div>
      ) : (
        /* Quiz Finished Celebration/Failure Screen */
        <div className="text-center py-12 space-y-6 max-w-md mx-auto my-auto">
          {passed ? (
            <>
              <div className="w-20 h-20 bg-emerald-500/20 rounded-full flex items-center justify-center mx-auto border-4 border-emerald-500 shadow-[0_0_30px_rgba(16,185,129,0.3)]">
                <Award size={40} className="text-emerald-400" />
              </div>
              <h3 className="text-3xl font-heading font-bold text-white">¡Evaluación Aprobada!</h3>
              <p className="text-zinc-400 text-sm">
                Has acertado <strong className="text-white font-mono">{score}</strong> de <strong className="text-white font-mono">{activeQuestions.length}</strong> preguntas ({percentage}%).
              </p>
              <div className="bg-black/50 p-4 rounded-xl border border-emerald-500/20 font-bold text-emerald-400 text-lg">
                +{xpReward} XP Ganados
              </div>
              <p className="text-xs text-zinc-500">Tu progreso ha sido guardado exitosamente.</p>
            </>
          ) : (
            <>
              <div className="w-20 h-20 bg-red-500/20 rounded-full flex items-center justify-center mx-auto border-4 border-red-500">
                <XCircle size={40} className="text-red-400" />
              </div>
              <h3 className="text-3xl font-heading font-bold text-white">No se alcanzó el puntaje</h3>
              <p className="text-zinc-400 text-sm">
                Obtuviste <strong className="text-white font-mono">{score}</strong> de <strong className="text-white font-mono">{activeQuestions.length}</strong> ({percentage}%). Se requiere al menos un 70% para aprobar.
              </p>
              <Button size="lg" onClick={handleRetry} leftIcon={<RefreshCw size={18} />} className="w-full">
                Reintentar Evaluación
              </Button>
            </>
          )}
        </div>
      )}

    </div>
  );
}
