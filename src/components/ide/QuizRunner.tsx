"use client";

import { useState } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { CheckCircle2, XCircle, HelpCircle, Award, ArrowRight, RefreshCw, Lightbulb } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export interface QuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
}

interface QuizRunnerProps {
  questions: QuizQuestion[];
  xpReward: number;
  onComplete: () => void;
}

export function QuizRunner({ questions, xpReward, onComplete }: QuizRunnerProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedOption, setSelectedOption] = useState<number | null>(null);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [score, setScore] = useState(0);
  const [quizFinished, setQuizFinished] = useState(false);

  const currentQ = questions[currentIndex] || {
    question: "¿Cuál es el resultado de typeof [] en JavaScript?",
    options: ["'array'", "'object'", "'list'", "'undefined'"],
    correctIndex: 1,
    explanation: "En JavaScript, los arreglos son un tipo especial de objeto, por lo que typeof [] retorna 'object'."
  };

  const handleSelectOption = (index: number) => {
    if (isSubmitted) return;
    setSelectedOption(index);
  };

  const handleSubmitAnswer = () => {
    if (selectedOption === null) return;
    setIsSubmitted(true);
    if (selectedOption === currentQ.correctIndex) {
      setScore((prev) => prev + 1);
    }
  };

  const handleNextQuestion = () => {
    if (currentIndex + 1 < questions.length) {
      setCurrentIndex((prev) => prev + 1);
      setSelectedOption(null);
      setIsSubmitted(false);
    } else {
      setQuizFinished(true);
      const percentage = Math.round((score / questions.length) * 100);
      if (percentage >= 70) {
        onComplete();
      }
    }
  };

  const handleRetry = () => {
    setCurrentIndex(0);
    setSelectedOption(null);
    setIsSubmitted(false);
    setScore(0);
    setQuizFinished(false);
  };

  const percentage = Math.round((score / questions.length) * 100);
  const passed = percentage >= 70;

  return (
    <div className="w-full h-full flex flex-col justify-between p-6 bg-[#0d0d11] rounded-2xl border border-white/10 overflow-y-auto">
      
      {!quizFinished ? (
        <div className="space-y-6 max-w-3xl mx-auto w-full py-4">
          
          {/* Header & Question Counter */}
          <div className="flex items-center justify-between border-b border-white/10 pb-4">
            <div className="flex items-center gap-2 text-accent font-bold text-xs uppercase tracking-wider">
              <HelpCircle size={18} />
              <span>Evaluación Teórica Multiple Choice</span>
            </div>
            <span className="text-xs text-zinc-400 font-mono">
              Pregunta {currentIndex + 1} de {questions.length}
            </span>
          </div>

          {/* Question Text */}
          <h2 className="text-2xl font-heading font-bold text-white leading-snug">
            {currentQ.question}
          </h2>

          {/* Options Grid */}
          <div className="space-y-3 pt-2">
            {currentQ.options.map((opt, idx) => {
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

          {/* Submitted Explanation Feedback */}
          <AnimatePresence>
            {isSubmitted && (
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className={`p-4 rounded-xl border space-y-1 ${
                  selectedOption === currentQ.correctIndex
                    ? "bg-emerald-950/20 border-emerald-500/30 text-emerald-300"
                    : "bg-red-950/20 border-red-500/30 text-red-300"
                }`}
              >
                <div className="flex items-center gap-2 font-bold text-sm">
                  <Lightbulb size={16} />
                  <span>{selectedOption === currentQ.correctIndex ? "¡Respuesta Correcta!" : "Explicación Pedagógica:"}</span>
                </div>
                <p className="text-xs opacity-90 leading-relaxed">{currentQ.explanation}</p>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Action Button */}
          <div className="pt-4 flex justify-end">
            {!isSubmitted ? (
              <Button
                size="lg"
                disabled={selectedOption === null}
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
                {currentIndex + 1 < questions.length ? "Siguiente Pregunta" : "Finalizar Evaluación"}
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
                Has acertado <strong className="text-white font-mono">{score}</strong> de <strong className="text-white font-mono">{questions.length}</strong> preguntas ({percentage}%).
              </p>
              <div className="bg-black/50 p-4 rounded-xl border border-emerald-500/20 font-bold text-emerald-400 text-lg">
                +{xpReward} XP Obtenidos
              </div>
            </>
          ) : (
            <>
              <div className="w-20 h-20 bg-red-500/20 rounded-full flex items-center justify-center mx-auto border-4 border-red-500 shadow-[0_0_30px_rgba(239,68,68,0.3)]">
                <XCircle size={40} className="text-red-400" />
              </div>
              <h3 className="text-3xl font-heading font-bold text-white">Evaluación Reprobada</h3>
              <p className="text-zinc-400 text-sm">
                Has obtenido un <strong className="text-white font-mono">{percentage}%</strong>. Necesitas al menos un 70% para aprobar esta lección.
              </p>
              <Button onClick={handleRetry} className="w-full mt-4 py-3 bg-red-500 hover:bg-red-600 text-white font-bold" leftIcon={<RefreshCw size={18} />}>
                Reintentar Evaluación
              </Button>
            </>
          )}
        </div>
      )}

    </div>
  );
}
