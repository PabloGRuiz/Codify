import { AuthForm } from "@/components/auth/AuthForm";
import { Code2 } from "lucide-react";

export default function AuthPage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-background relative overflow-hidden">
      {/* Background Orbs */}
      <div className="absolute top-[-20%] left-[-10%] w-[50%] h-[50%] rounded-full bg-primary/20 blur-[150px] pointer-events-none" />
      <div className="absolute bottom-[-20%] right-[-10%] w-[50%] h-[50%] rounded-full bg-accent/20 blur-[150px] pointer-events-none" />
      
      <div className="z-10 flex flex-col items-center mb-8 animate-float">
        <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shadow-[0_0_30px_rgba(139,92,246,0.5)] mb-4">
          <Code2 size={32} className="text-white" />
        </div>
        <h1 className="text-5xl font-heading font-bold text-white tracking-tight">Codify</h1>
        <p className="text-zinc-400 mt-2 font-sans text-lg">Aprende, Programa y Sube de Nivel</p>
      </div>

      <div className="z-10 w-full max-w-md px-4">
        <AuthForm />
      </div>
    </div>
  );
}
