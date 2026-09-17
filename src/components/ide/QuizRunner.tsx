"use client";

import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
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
  Sparkles
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export interface QuizQuestion {
  id: string;
  question: string;
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

          {/* Question Text */}
          <h2 className="text-2xl font-heading font-bold text-white leading-snug">
            {currentQ.question}
          </h2>

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
                <p className="text-xs opacity-90 leading-relaxed">{currentQ.explanation}</p>
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
