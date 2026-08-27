"use client";

import { useState, useEffect, useRef } from "react";
import { 
  Award, 
  Clock, 
  CheckCircle2, 
  XCircle, 
  AlertTriangle, 
  ChevronRight, 
  ChevronLeft, 
  Sparkles, 
  Share2, 
  ExternalLink, 
  X, 
  ShieldCheck, 
  Check, 
  GraduationCap 
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/Button";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/hooks/useUser";
import { Certification, CertificationQuestion, UserCertification } from "@/types";
import Link from "next/link";

interface ExamModalProps {
  isOpen: boolean;
  onClose: () => void;
  certification: Certification;
  courseTitle: string;
  onCertificationAchieved?: (userCert: UserCertification) => void;
}

export function ExamModal({
  isOpen,
  onClose,
  certification,
  courseTitle,
  onCertificationAchieved,
}: ExamModalProps) {
  const { user, profile } = useUser();
  const [phase, setPhase] = useState<"intro" | "exam" | "evaluating" | "result">("intro");
  const [questions, setQuestions] = useState<CertificationQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<{ [qId: string]: number }>({});
  const [timeLeft, setTimeLeft] = useState(certification.time_limit_minutes * 60);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [result, setResult] = useState<{
    passed: boolean;
    score: number;
    correctCount: number;
    totalCount: number;
    verificationCode?: string;
  } | null>(null);

  const timerRef = useRef<NodeJS.Timeout | null>(null);

  // Fetch Questions
  useEffect(() => {
    if (isOpen && certification?.id) {
      const fetchQuestions = async () => {
        const { data, error } = await supabase
          .from("certification_questions")
          .select("*")
          .eq("certification_id", certification.id);

        if (data && data.length > 0) {
          // Shuffle questions for randomized attempt
          const shuffled = [...data].sort(() => Math.random() - 0.5);
          setQuestions(shuffled);
        }
      };
      fetchQuestions();
    }
  }, [isOpen, certification?.id]);

  // Timer logic
  useEffect(() => {
    if (phase === "exam") {
      timerRef.current = setInterval(() => {
        setTimeLeft((prev) => {
          if (prev <= 1) {
            clearInterval(timerRef.current!);
            handleFinishExam(true);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    } else {
      if (timerRef.current) clearInterval(timerRef.current);
    }

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [phase]);

  const handleStartExam = () => {
    if (questions.length === 0) {
      alert("No hay preguntas configuradas para este examen aún.");
      return;
    }
    setTimeLeft(certification.time_limit_minutes * 60);
    setCurrentIndex(0);
    setAnswers({});
    setResult(null);
    setPhase("exam");
  };

  const handleSelectOption = (questionId: string, optionIndex: number) => {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: optionIndex,
    }));
  };

  const generateVerificationCode = () => {
    const rawCode = certification.code ? certification.code.replace("CERT-", "") : "CERT";
    const randomHex = Math.random().toString(36).substring(2, 8).toUpperCase();
    return `CDFY-${rawCode}-${randomHex}`;
  };

  const handleFinishExam = async (forceTimeOut = false) => {
    if (phase !== "exam") return;
    if (timerRef.current) clearInterval(timerRef.current);
    
    if (!forceTimeOut && Object.keys(answers).length < questions.length) {
      const confirmed = confirm(
        `Tienes ${questions.length - Object.keys(answers).length} preguntas sin responder. ¿Deseas enviar el examen de todas formas?`
      );
      if (!confirmed) return;
    }

    setIsSubmitting(true);
    setPhase("evaluating");

    // Calculate score
    let correct = 0;
    questions.forEach((q) => {
      if (answers[q.id] === q.correct_index) {
        correct++;
      }
    });

    const scorePercentage = Math.round((correct / questions.length) * 100);
    const passed = scorePercentage >= certification.min_passing_score;
    const vCode = generateVerificationCode();

    try {
      if (user) {
        // 1. Record Attempt
        await supabase.from("exam_attempts").insert({
          user_id: user.id,
          certification_id: certification.id,
          score: scorePercentage,
          passed: passed,
          total_questions: questions.length,
          correct_answers: correct,
        });

        // 2. If Passed, Issue Certificate and XP
        if (passed) {
          const { data: certData, error: certErr } = await supabase
            .from("user_certifications")
            .upsert({
              user_id: user.id,
              certification_id: certification.id,
              verification_code: vCode,
              score: scorePercentage,
              issued_at: new Date().toISOString(),
            })
            .select("*, certification:certifications(*)")
            .single();

          if (!certErr && certData) {
            // Update User Profile XP
            if (profile) {
              await supabase
                .from("profiles")
                .update({
                  xp: (profile.xp || 0) + certification.xp_reward,
                })
                .eq("id", user.id);
            }

            // Trigger In-App Notification
            await supabase.from("notifications").insert({
              user_id: user.id,
              type: "achievement",
              title: "¡Certificación Oficial Obtenida! 🎓",
              message: `Has aprobado con ${scorePercentage}% el examen de "${certification.title}". Tu certificado oficial ya está disponible en tu perfil.`,
              link: `/certificados/${vCode}`,
            });

            if (onCertificationAchieved) {
              onCertificationAchieved(certData);
            }
          }
        }
      }
    } catch (err) {
      console.error("Error guardando resultado del examen:", err);
    } finally {
      setIsSubmitting(false);
      setResult({
        passed,
        score: scorePercentage,
        correctCount: correct,
        totalCount: questions.length,
        verificationCode: passed ? vCode : undefined,
      });
      setPhase("result");
    }
  };

  const handleResetAndClose = () => {
    if (timerRef.current) clearInterval(timerRef.current);
    setPhase("intro");
    setCurrentIndex(0);
    setAnswers({});
    setResult(null);
    onClose();
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  };

  if (!isOpen) return null;

  const currentQ = questions[currentIndex];
  const answeredCount = Object.keys(answers).length;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-black/85 backdrop-blur-md">
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 15 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 10 }}
          className="relative w-full max-w-2xl bg-[#0e0e14] border border-white/15 rounded-3xl p-5 sm:p-8 shadow-2xl shadow-black/90 overflow-hidden"
        >
          {/* Ambient Glow */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-amber-500/10 rounded-full blur-3xl pointer-events-none" />

          {/* ========================================================================= */}
          {/* FASE 1: INTRODUCCIÓN & REGLAS DEL EXAMEN */}
          {/* ========================================================================= */}
          {phase === "intro" && (
            <div className="space-y-6">
              <div className="flex items-center justify-between border-b border-white/10 pb-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-2xl bg-amber-500/15 border border-amber-500/30 text-amber-400 flex items-center justify-center shadow-lg shadow-amber-500/10">
                    <GraduationCap size={24} />
                  </div>
                  <div>
                    <h3 className="text-lg sm:text-xl font-heading font-bold text-white">
                      Examen de Certificación Oficial
                    </h3>
                    <p className="text-xs text-amber-400 font-semibold">{courseTitle}</p>
                  </div>
                </div>
                <button
                  onClick={handleResetAndClose}
                  className="p-2 text-zinc-400 hover:text-white rounded-lg hover:bg-white/5 transition-colors"
                >
                  <X size={18} />
                </button>
              </div>

              <div className="space-y-3">
                <h4 className="text-sm font-bold text-white">{certification.title}</h4>
                <p className="text-xs text-zinc-300 leading-relaxed">{certification.description}</p>
              </div>

              {/* Badges de Condiciones */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 bg-black/40 p-4 rounded-2xl border border-white/10">
                <div className="text-center space-y-1">
                  <div className="text-[10px] uppercase font-bold text-zinc-500">Preguntas</div>
                  <div className="text-sm font-bold text-white font-mono">{questions.length} preguntas</div>
                </div>
                <div className="text-center space-y-1">
                  <div className="text-[10px] uppercase font-bold text-zinc-500">Tiempo Límite</div>
                  <div className="text-sm font-bold text-amber-400 font-mono flex items-center justify-center gap-1">
                    <Clock size={13} /> {certification.time_limit_minutes} min
                  </div>
                </div>
                <div className="text-center space-y-1">
                  <div className="text-[10px] uppercase font-bold text-zinc-500">Mínimo Aprobatorio</div>
                  <div className="text-sm font-bold text-emerald-400 font-mono">{certification.min_passing_score}%</div>
                </div>
                <div className="text-center space-y-1">
                  <div className="text-[10px] uppercase font-bold text-zinc-500">Recompensa</div>
                  <div className="text-sm font-bold text-primary font-mono">+{certification.xp_reward} XP</div>
                </div>
              </div>

              {/* Requisitos y Competencias */}
              {certification.skills_validated && certification.skills_validated.length > 0 && (
                <div className="space-y-2">
                  <div className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                    Competencias Validadas en este Examen:
                  </div>
                  <div className="flex flex-wrap gap-1.5">
                    {certification.skills_validated.map((skill, idx) => (
                      <span
                        key={idx}
                        className="px-2.5 py-1 rounded-lg bg-white/5 border border-white/10 text-xs font-semibold text-zinc-300"
                      >
                        ✓ {skill}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              {/* Botones */}
              <div className="flex items-center justify-end gap-3 pt-3 border-t border-white/10">
                <Button variant="secondary" size="sm" onClick={handleResetAndClose}>
                  Cancelar
                </Button>
                <Button
                  size="sm"
                  onClick={handleStartExam}
                  leftIcon={<Sparkles size={16} />}
                  className="bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20"
                >
                  Comenzar Examen Oficial 🚀
                </Button>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* FASE 2: EXAMEN EN CURSO */}
          {/* ========================================================================= */}
          {phase === "exam" && currentQ && (
            <div className="space-y-6">
              {/* Header con Cronómetro y Contador */}
              <div className="flex items-center justify-between border-b border-white/10 pb-4">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-1 rounded-lg bg-white/10 text-white text-xs font-bold font-mono">
                    {currentIndex + 1} / {questions.length}
                  </span>
                  <span className="text-xs text-zinc-400 hidden sm:inline">
                    ({answeredCount} respondidas)
                  </span>
                </div>

                {/* Cronómetro */}
                <div
                  className={`flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-bold font-mono border ${
                    timeLeft < 180
                      ? "bg-red-500/20 text-red-400 border-red-500/30 animate-pulse"
                      : "bg-amber-500/10 text-amber-400 border-amber-500/30"
                  }`}
                >
                  <Clock size={14} />
                  <span>{formatTime(timeLeft)}</span>
                </div>
              </div>

              {/* Barra de Progreso */}
              <div className="w-full h-1.5 bg-white/10 rounded-full overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-amber-500 to-primary transition-all duration-300"
                  style={{ width: `${((currentIndex + 1) / questions.length) * 100}%` }}
                />
              </div>

              {/* Enunciado de la Pregunta */}
              <div className="space-y-2 py-2">
                <h4 className="text-base sm:text-lg font-bold text-white leading-snug">
                  {currentQ.question}
                </h4>
              </div>

              {/* Opciones de Respuesta */}
              <div className="space-y-2.5">
                {currentQ.options.map((opt, idx) => {
                  const isSelected = answers[currentQ.id] === idx;
                  return (
                    <button
                      key={idx}
                      type="button"
                      onClick={() => handleSelectOption(currentQ.id, idx)}
                      className={`w-full p-3.5 rounded-2xl border text-left text-xs sm:text-sm font-medium transition-all flex items-center justify-between gap-3 ${
                        isSelected
                          ? "bg-amber-500/15 border-amber-500 text-amber-200 shadow-md shadow-amber-500/10"
                          : "bg-black/40 border-white/10 hover:border-white/20 text-zinc-300 hover:bg-black/60"
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <div
                          className={`w-5 h-5 rounded-full border flex items-center justify-center shrink-0 ${
                            isSelected
                              ? "border-amber-400 bg-amber-400 text-black font-bold text-[10px]"
                              : "border-white/20 text-transparent"
                          }`}
                        >
                          {isSelected && <Check size={12} strokeWidth={3} />}
                        </div>
                        <span>{opt}</span>
                      </div>
                    </button>
                  );
                })}
              </div>

              {/* Navegación y Envío */}
              <div className="flex items-center justify-between pt-4 border-t border-white/10">
                <Button
                  size="sm"
                  variant="secondary"
                  disabled={currentIndex === 0}
                  onClick={() => setCurrentIndex((prev) => prev - 1)}
                  leftIcon={<ChevronLeft size={16} />}
                >
                  Anterior
                </Button>

                {currentIndex < questions.length - 1 ? (
                  <Button
                    size="sm"
                    onClick={() => setCurrentIndex((prev) => prev + 1)}
                    rightIcon={<ChevronRight size={16} />}
                    className="bg-white/10 hover:bg-white/20 text-white"
                  >
                    Siguiente
                  </Button>
                ) : (
                  <Button
                    size="sm"
                    onClick={() => handleFinishExam(false)}
                    isLoading={isSubmitting}
                    leftIcon={<Award size={16} />}
                    className="bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20"
                  >
                    Finalizar y Enviar Examen 🎓
                  </Button>
                )}
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* FASE 3: EVALUACIÓN EN PROCESO */}
          {/* ========================================================================= */}
          {phase === "evaluating" && (
            <div className="py-16 text-center space-y-4">
              <div className="w-14 h-14 rounded-2xl border-4 border-amber-500 border-t-transparent animate-spin mx-auto" />
              <h4 className="text-lg font-bold text-white font-heading">Evaluando Respuestas...</h4>
              <p className="text-xs text-zinc-400">Verificando respuestas contra el banco oficial de Codify.</p>
            </div>
          )}

          {/* ========================================================================= */}
          {/* FASE 4: RESULTADO DEL EXAMEN */}
          {/* ========================================================================= */}
          {phase === "result" && result && (
            <div className="space-y-6 text-center py-2">
              {result.passed ? (
                /* APROBADO */
                <div className="space-y-5">
                  <div className="w-20 h-20 rounded-3xl bg-amber-500/15 border border-amber-500/40 text-amber-400 flex items-center justify-center mx-auto shadow-2xl shadow-amber-500/30 animate-bounce">
                    <Award size={44} />
                  </div>

                  <div className="space-y-1">
                    <span className="text-xs font-bold uppercase tracking-wider text-amber-400 bg-amber-500/10 px-3 py-1 rounded-full border border-amber-500/30">
                      ¡Examen Aprobado! 🎉
                    </span>
                    <h3 className="text-2xl font-heading font-black text-white pt-2">
                      ¡Felicidades, te has certificado!
                    </h3>
                    <p className="text-xs text-zinc-400 max-w-md mx-auto">
                      Has demostrado dominio oficial en {certification.title}.
                    </p>
                  </div>

                  {/* Estadísticas de Aprobación */}
                  <div className="grid grid-cols-3 gap-2 max-w-md mx-auto bg-black/40 p-4 rounded-2xl border border-white/10">
                    <div className="space-y-0.5">
                      <div className="text-[10px] text-zinc-500 font-bold uppercase">Tu Puntuación</div>
                      <div className="text-xl font-bold text-emerald-400 font-mono">{result.score}%</div>
                    </div>
                    <div className="space-y-0.5">
                      <div className="text-[10px] text-zinc-500 font-bold uppercase">Aciertos</div>
                      <div className="text-xl font-bold text-white font-mono">
                        {result.correctCount}/{result.totalCount}
                      </div>
                    </div>
                    <div className="space-y-0.5">
                      <div className="text-[10px] text-zinc-500 font-bold uppercase">Recompensa</div>
                      <div className="text-xl font-bold text-primary font-mono">+{certification.xp_reward} XP</div>
                    </div>
                  </div>

                  {/* Código Único */}
                  {result.verificationCode && (
                    <div className="p-3 bg-white/5 border border-white/10 rounded-xl inline-block text-xs font-mono text-zinc-300">
                      ID de Verificación: <strong className="text-amber-400">{result.verificationCode}</strong>
                    </div>
                  )}

                  {/* Acciones */}
                  <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-2">
                    {result.verificationCode && (
                      <Link href={`/certificados/${result.verificationCode}`} onClick={handleResetAndClose}>
                        <Button
                          size="sm"
                          className="bg-amber-500 hover:bg-amber-600 text-black font-bold shadow-lg shadow-amber-500/20"
                          leftIcon={<GraduationCap size={16} />}
                        >
                          Ver Diploma Oficial 📜
                        </Button>
                      </Link>
                    )}
                    <Button variant="secondary" size="sm" onClick={handleResetAndClose}>
                      Cerrar
                    </Button>
                  </div>
                </div>
              ) : (
                /* REPROBADO */
                <div className="space-y-5">
                  <div className="w-16 h-16 rounded-2xl bg-red-500/15 border border-red-500/30 text-red-400 flex items-center justify-center mx-auto shadow-lg shadow-red-500/20">
                    <XCircle size={36} />
                  </div>

                  <div className="space-y-1">
                    <h3 className="text-xl font-heading font-bold text-white">
                      No se alcanzó el puntaje mínimo
                    </h3>
                    <p className="text-xs text-zinc-400 max-w-sm mx-auto">
                      Obtuviste <strong className="text-white font-mono">{result.score}%</strong> y se requiere un mínimo de <strong className="text-amber-400 font-mono">{certification.min_passing_score}%</strong> para certificar.
                    </p>
                  </div>

                  <div className="p-4 rounded-2xl bg-black/40 border border-white/10 text-xs text-zinc-300 max-w-sm mx-auto leading-relaxed">
                    💡 <strong>Consejo:</strong> Repasa las lecciones y cuestionarios del curso antes de intentar rendir nuevamente el examen.
                  </div>

                  <div className="flex items-center justify-center gap-3 pt-2">
                    <Button variant="secondary" size="sm" onClick={handleResetAndClose}>
                      Volver al Curso
                    </Button>
                    <Button size="sm" onClick={handleStartExam} className="bg-white/10 hover:bg-white/20 text-white">
                      Reintentar Examen 🔄
                    </Button>
                  </div>
                </div>
              )}
            </div>
          )}
        </motion.div>
      </div>
    </AnimatePresence>
  );
}
