"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { UserCertification } from "@/types";
import { 
  Award, 
  CheckCircle2, 
  ShieldCheck, 
  Calendar, 
  ExternalLink, 
  Printer, 
  Share2, 
  Copy, 
  Check, 
  GraduationCap, 
  ArrowLeft, 
  Sparkles,
  AlertTriangle
} from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/Button";

export default function CertificateValidationPage() {
  const { code } = useParams();
  const [userCert, setUserCert] = useState<UserCertification | null>(null);
  const [loading, setLoading] = useState(true);
  const [copiedLink, setCopiedLink] = useState(false);

  useEffect(() => {
    if (code) {
      fetchCertificate();
    }
  }, [code]);

  const fetchCertificate = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from("user_certifications")
        .select("*, profile:profiles(username, avatar_url), certification:certifications(*, courses(title, description))")
        .eq("verification_code", code)
        .single();

      if (error || !data) {
        setUserCert(null);
      } else {
        setUserCert(data as any);
      }
    } catch (err) {
      console.error("Error validando certificado:", err);
      setUserCert(null);
    } finally {
      setLoading(false);
    }
  };

  const handleCopyLink = () => {
    if (typeof window !== "undefined") {
      navigator.clipboard.writeText(window.location.href);
      setCopiedLink(true);
      setTimeout(() => setCopiedLink(false), 2500);
    }
  };

  const handlePrint = () => {
    if (typeof window !== "undefined") {
      window.print();
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#07070b] flex items-center justify-center p-4">
        <div className="text-center space-y-4">
          <div className="w-14 h-14 rounded-2xl border-4 border-amber-500 border-t-transparent animate-spin mx-auto" />
          <p className="text-sm font-mono text-zinc-400">Verificando autenticidad del certificado en Codify...</p>
        </div>
      </div>
    );
  }

  if (!userCert) {
    return (
      <div className="min-h-screen bg-[#07070b] flex items-center justify-center p-4">
        <div className="max-w-md w-full p-8 rounded-3xl bg-black/60 border border-red-500/30 text-center space-y-5 shadow-2xl">
          <div className="w-16 h-16 rounded-2xl bg-red-500/15 border border-red-500/30 text-red-400 flex items-center justify-center mx-auto shadow-lg shadow-red-500/20">
            <AlertTriangle size={32} />
          </div>
          <div className="space-y-1">
            <h2 className="text-xl font-heading font-bold text-white">Certificado No Encontrado</h2>
            <p className="text-xs text-zinc-400 leading-relaxed">
              El código de verificación <strong className="text-red-300 font-mono">{String(code)}</strong> no corresponde a ningún certificado válido emitido por la plataforma Codify.
            </p>
          </div>
          <Link href="/cursos">
            <Button size="sm" className="bg-primary hover:bg-primary/80 text-white font-bold">
              Explorar Cursos Oficiales
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  const cert = userCert.certification;
  const issueDate = new Date(userCert.issued_at);
  const formattedDate = issueDate.toLocaleDateString("es-ES", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });

  // URL para agregar la certificación a LinkedIn
  const currentUrl = typeof window !== "undefined" ? window.location.href : `https://codify.dev/certificados/${userCert.verification_code}`;
  const linkedInUrl = `https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME&name=${encodeURIComponent(
    cert?.title || "Certificación Codify"
  )}&organizationName=Codify&issueYear=${issueDate.getFullYear()}&issueMonth=${issueDate.getMonth() + 1}&certUrl=${encodeURIComponent(
    currentUrl
  )}&certId=${encodeURIComponent(userCert.verification_code)}`;

  return (
    <div className="min-h-screen bg-[#07070b] text-white p-4 sm:p-8 flex flex-col items-center justify-center relative overflow-hidden">
      {/* Background ambient lighting */}
      <div className="absolute top-[-10%] right-[-10%] w-[50%] h-[50%] rounded-full bg-amber-500/10 blur-[150px] pointer-events-none" />
      <div className="absolute bottom-[-10%] left-[-10%] w-[50%] h-[50%] rounded-full bg-primary/10 blur-[150px] pointer-events-none" />

      {/* Top Header Actions */}
      <div className="w-full max-w-4xl flex items-center justify-between gap-4 mb-6 z-10 print:hidden">
        <Link href="/cursos" className="inline-flex items-center gap-2 text-xs font-semibold text-zinc-400 hover:text-white transition-colors">
          <ArrowLeft size={16} />
          <span>Volver a la plataforma</span>
        </Link>

        <div className="flex items-center gap-2">
          <Button
            size="sm"
            variant="secondary"
            onClick={handleCopyLink}
            leftIcon={copiedLink ? <Check size={14} /> : <Copy size={14} />}
            className="text-xs"
          >
            {copiedLink ? "¡Enlace Copiado!" : "Copiar Enlace"}
          </Button>

          <Button
            size="sm"
            variant="secondary"
            onClick={handlePrint}
            leftIcon={<Printer size={14} />}
            className="text-xs"
          >
            Imprimir / PDF
          </Button>

          <a href={linkedInUrl} target="_blank" rel="noopener noreferrer">
            <Button
              size="sm"
              leftIcon={<ExternalLink size={14} />}
              className="bg-[#0A66C2] hover:bg-[#084e96] text-white font-bold text-xs shadow-lg shadow-[#0A66C2]/20"
            >
              Añadir a LinkedIn
            </Button>
          </a>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* DIPLOMA DIGITAL CODIFY (Imprimible y Verificable) */}
      {/* ========================================================================= */}
      <div className="w-full max-w-4xl relative bg-[#0d0d14] border-2 border-amber-500/30 rounded-3xl p-6 sm:p-12 shadow-[0_0_80px_rgba(245,158,11,0.15)] overflow-hidden print:shadow-none print:border print:m-0 print:p-8">
        {/* Esquinas Doradas Decorativas */}
        <div className="absolute top-4 left-4 w-12 h-12 border-t-2 border-l-2 border-amber-400/60 rounded-tl-xl pointer-events-none" />
        <div className="absolute top-4 right-4 w-12 h-12 border-t-2 border-r-2 border-amber-400/60 rounded-tr-xl pointer-events-none" />
        <div className="absolute bottom-4 left-4 w-12 h-12 border-b-2 border-l-2 border-amber-400/60 rounded-bl-xl pointer-events-none" />
        <div className="absolute bottom-4 right-4 w-12 h-12 border-b-2 border-r-2 border-amber-400/60 rounded-br-xl pointer-events-none" />

        {/* Marca de agua de fondo */}
        <div className="absolute inset-0 flex items-center justify-center opacity-[0.03] pointer-events-none">
          <GraduationCap size={400} />
        </div>

        <div className="relative z-10 text-center space-y-8">
          {/* Header del Certificado */}
          <div className="space-y-2">
            <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-amber-500/10 border border-amber-500/30 text-amber-300 text-xs font-bold font-mono tracking-widest uppercase">
              <Sparkles size={13} />
              Codify Certified Professional
            </div>
            <h1 className="text-2xl sm:text-4xl font-heading font-black tracking-tight text-white uppercase">
              Certificado de Aprobación Oficial
            </h1>
            <p className="text-xs sm:text-sm text-zinc-400 tracking-wider uppercase font-semibold">
              Otorgado por la plataforma de aprendizaje gamificado de ingeniería de software
            </p>
          </div>

          {/* Cuerpo del Diploma */}
          <div className="space-y-4 py-4">
            <p className="text-xs sm:text-sm text-zinc-400 font-serif italic">
              Por haber superado con éxito las evaluaciones y el examen oficial, se acredita a:
            </p>

            <div className="space-y-1">
              <h2 className="text-3xl sm:text-5xl font-heading font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-amber-400 to-amber-100 py-1">
                @{userCert.profile?.username || "Estudiante de Codify"}
              </h2>
              <div className="w-32 h-0.5 bg-gradient-to-r from-transparent via-amber-400 to-transparent mx-auto" />
            </div>

            <p className="text-xs sm:text-sm text-zinc-400 max-w-xl mx-auto leading-relaxed pt-2">
              con la calificación oficial de <strong className="text-emerald-400 font-mono text-base font-bold">{userCert.score}%</strong>, certificando el dominio de las competencias técnicas del programa:
            </p>

            <h3 className="text-xl sm:text-2xl font-heading font-bold text-white max-w-2xl mx-auto pt-1">
              {cert?.title}
            </h3>
          </div>

          {/* Competencias Validadas */}
          {cert?.skills_validated && cert.skills_validated.length > 0 && (
            <div className="space-y-2 pt-2">
              <div className="text-[10px] uppercase font-bold tracking-widest text-zinc-500">
                Habilidades y Competencias Validadas:
              </div>
              <div className="flex flex-wrap justify-center gap-2 max-w-xl mx-auto">
                {cert.skills_validated.map((skill, i) => (
                  <span
                    key={i}
                    className="px-3 py-1 rounded-xl bg-white/5 border border-white/10 text-xs font-semibold text-zinc-300"
                  >
                    ✓ {skill}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* Sello y Footer de Verificación */}
          <div className="pt-8 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-6">
            {/* Sello Oficial */}
            <div className="flex items-center gap-3 text-left">
              <div className="w-14 h-14 rounded-2xl bg-amber-500/20 border-2 border-amber-400 text-amber-400 flex items-center justify-center shrink-0 shadow-lg shadow-amber-500/20">
                <ShieldCheck size={32} />
              </div>
              <div className="space-y-0.5">
                <div className="text-xs font-bold text-white flex items-center gap-1.5">
                  <span>Documento Verificado</span>
                  <CheckCircle2 size={14} className="text-emerald-400" />
                </div>
                <div className="text-[11px] text-zinc-400">
                  Emitido el {formattedDate}
                </div>
              </div>
            </div>

            {/* Código Hash Único */}
            <div className="text-center sm:text-right space-y-1">
              <div className="text-[10px] uppercase font-bold tracking-widest text-zinc-500">
                Identificador Único de Autenticidad
              </div>
              <div className="font-mono text-xs sm:text-sm font-bold text-amber-400 bg-black/40 px-3 py-1.5 rounded-xl border border-white/10 inline-block">
                {userCert.verification_code}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer link */}
      <div className="mt-8 text-center text-xs text-zinc-500 font-mono print:hidden">
        Validación criptográfica respaldada por Codify Learning Engine.
      </div>
    </div>
  );
}
