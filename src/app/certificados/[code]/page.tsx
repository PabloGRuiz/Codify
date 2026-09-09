"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { UserCertification } from "@/types";
import { 
  ShieldCheck, 
  ExternalLink, 
  Printer, 
  Copy, 
  Check, 
  ArrowLeft, 
  AlertTriangle,
  Award
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
      <div className="min-h-screen bg-background flex items-center justify-center p-4">
        <div className="text-center space-y-4">
          <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto" />
          <p className="text-sm font-mono text-zinc-500">Verificando autenticidad en SGFC...</p>
        </div>
      </div>
    );
  }

  if (!userCert) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center p-4">
        <div className="max-w-md w-full p-8 rounded-xl bg-card border border-border text-center space-y-5 shadow-sm">
          <div className="w-16 h-16 rounded-full bg-danger/10 text-danger flex items-center justify-center mx-auto">
            <AlertTriangle size={32} />
          </div>
          <div className="space-y-1">
            <h2 className="text-xl font-heading font-bold text-foreground">Certificado No Encontrado</h2>
            <p className="text-sm text-zinc-500 leading-relaxed">
              El código de verificación <strong className="font-mono text-danger">{String(code)}</strong> no corresponde a ningún certificado válido en SGFC.
            </p>
          </div>
          <Link href="/cursos">
            <Button size="sm" className="w-full">
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

  const currentUrl = typeof window !== "undefined" ? window.location.href : `https://codify.dev/certificados/${userCert.verification_code}`;
  const linkedInUrl = `https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME&name=${encodeURIComponent(
    cert?.title || "Certificación SGFC"
  )}&organizationName=SGFC&issueYear=${issueDate.getFullYear()}&issueMonth=${issueDate.getMonth() + 1}&certUrl=${encodeURIComponent(
    currentUrl
  )}&certId=${encodeURIComponent(userCert.verification_code)}`;

  return (
    <div className="min-h-screen bg-background text-foreground p-4 sm:p-8 flex flex-col items-center py-12">
      {/* Top Header Actions */}
      <div className="w-full max-w-4xl flex items-center justify-between gap-4 mb-8 print:hidden">
        <Link href="/cursos" className="inline-flex items-center gap-2 text-sm font-medium text-zinc-500 hover:text-foreground transition-colors">
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
            {copiedLink ? "Copiado" : "Copiar Enlace"}
          </Button>

          <Button
            size="sm"
            variant="secondary"
            onClick={handlePrint}
            leftIcon={<Printer size={14} />}
            className="text-xs"
          >
            Imprimir PDF
          </Button>

          <a href={linkedInUrl} target="_blank" rel="noopener noreferrer">
            <Button
              size="sm"
              leftIcon={<ExternalLink size={14} />}
              className="bg-[#0A66C2] hover:bg-[#084e96] text-white font-semibold text-xs border-none"
            >
              Añadir a LinkedIn
            </Button>
          </a>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* CERTIFICADO PROFESIONAL */}
      {/* ========================================================================= */}
      <div className="w-full max-w-4xl bg-card border border-border rounded-lg shadow-md p-8 sm:p-16 relative overflow-hidden print:shadow-none print:border-0 print:p-0">
        {/* Subtle decorative border line inside */}
        <div className="absolute inset-4 border border-border rounded pointer-events-none opacity-50" />
        
        <div className="relative z-10 text-center space-y-10">
          
          {/* Header */}
          <div className="space-y-4">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 text-primary mb-2">
              <Award size={32} />
            </div>
            <h1 className="text-3xl sm:text-4xl font-serif font-bold text-foreground uppercase tracking-wide">
              Certificado de Finalización
            </h1>
            <p className="text-sm text-zinc-500 uppercase tracking-widest font-semibold">
              SGFC Academy
            </p>
          </div>

          {/* Body */}
          <div className="space-y-6">
            <p className="text-sm text-zinc-500 italic font-serif">
              Se otorga el presente certificado a:
            </p>

            <h2 className="text-4xl sm:text-5xl font-heading font-bold text-foreground">
              {userCert.profile?.username || "Estudiante de SGFC"}
            </h2>

            <div className="w-24 h-[1px] bg-border mx-auto my-4" />

            <p className="text-sm text-zinc-500 max-w-2xl mx-auto leading-relaxed">
              Por haber completado exitosamente los requerimientos académicos y superado la evaluación con una calificación de <strong className="text-foreground">{userCert.score}%</strong>, demostrando dominio en:
            </p>

            <h3 className="text-2xl font-semibold text-foreground max-w-2xl mx-auto">
              {cert?.title}
            </h3>
          </div>

          {/* Competencias */}
          {cert?.skills_validated && cert.skills_validated.length > 0 && (
            <div className="pt-4 space-y-3">
              <div className="text-[11px] uppercase font-bold tracking-widest text-zinc-400">
                Competencias Validadas
              </div>
              <div className="flex flex-wrap justify-center gap-2 max-w-xl mx-auto">
                {cert.skills_validated.map((skill, i) => (
                  <span
                    key={i}
                    className="px-3 py-1 bg-secondary text-secondary-foreground text-xs font-medium rounded border border-border"
                  >
                    {skill}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* Footer Signatures and Validation */}
          <div className="pt-16 mt-8 flex flex-col sm:flex-row items-end justify-between gap-8 border-t border-border">
            
            <div className="flex flex-col items-center gap-2">
              <div className="w-40 h-10 border-b border-border flex items-end justify-center pb-1">
                <span className="font-serif italic text-xl text-zinc-400">Dirección Académica</span>
              </div>
              <span className="text-xs text-zinc-500 uppercase tracking-wider">SGFC</span>
            </div>

            <div className="flex flex-col items-center sm:items-end text-center sm:text-right space-y-2">
              <div className="flex items-center gap-2 text-success">
                <ShieldCheck size={20} />
                <span className="text-sm font-bold uppercase tracking-wider">Validado Oficialmente</span>
              </div>
              <div className="text-xs text-zinc-500 space-y-1">
                <p>Fecha de emisión: <span className="font-medium text-foreground">{formattedDate}</span></p>
                <p>ID de Credencial: <span className="font-mono font-medium text-foreground">{userCert.verification_code}</span></p>
              </div>
            </div>

          </div>
        </div>
      </div>

      <div className="mt-8 text-center text-xs text-zinc-500 print:hidden">
        Verificación en línea: codify.dev/certificados/{userCert.verification_code}
      </div>
    </div>
  );
}
