"use client";

import { useState } from "react";
import { supabase } from "@/lib/supabase";
import { Button } from "../ui/Button";
import { Card } from "../ui/Card";
import { useRouter } from "next/navigation";

export function AuthForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [username, setUsername] = useState("");
  const [isLogin, setIsLogin] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      if (isLogin) {
        const { error } = await supabase.auth.signInWithPassword({
          email,
          password,
        });
        if (error) throw error;
        router.push("/");
      } else {
        const { error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            data: {
              username: username || email.split("@")[0],
            },
          },
        });
        if (error) throw error;
        alert("¡Registro exitoso! Ya puedes iniciar sesión.");
        setIsLogin(true);
      }
    } catch (err: any) {
      setError(err.message || "Ocurrió un error en la autenticación.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="w-full p-8 glass-panel border border-white/10 relative overflow-hidden">
      <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-accent"></div>
      <h2 className="text-3xl font-heading font-bold mb-6 text-center text-transparent bg-clip-text bg-gradient-to-r from-primary to-accent">
        {isLogin ? "Iniciar Sesión" : "Crear Cuenta"}
      </h2>
      
      {error && (
        <div className="mb-4 p-3 bg-red-500/20 border border-red-500/50 rounded-lg text-red-200 text-sm">
          {error}
        </div>
      )}

      <form onSubmit={handleAuth} className="space-y-4">
        {!isLogin && (
          <div>
            <label className="block text-sm font-medium text-zinc-300 mb-1">Username (Apodo de Coder)</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              className="w-full px-4 py-3 rounded-lg bg-black/40 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors text-white"
              placeholder="tu_apodo_cool"
            />
          </div>
        )}
        
        <div>
          <label className="block text-sm font-medium text-zinc-300 mb-1">Email</label>
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full px-4 py-3 rounded-lg bg-black/40 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors text-white"
            placeholder="correo@ejemplo.com"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-zinc-300 mb-1">Contraseña</label>
          <input
            type="password"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-4 py-3 rounded-lg bg-black/40 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors text-white"
            placeholder="••••••••"
          />
        </div>

        <Button
          type="submit"
          className="w-full mt-6 py-6 text-lg"
          isLoading={loading}
        >
          {isLogin ? "Entrar a Programar" : "Empezar la Aventura"}
        </Button>
      </form>

      <div className="mt-6 text-center text-sm text-zinc-400">
        {isLogin ? "¿No tienes cuenta aún? " : "¿Ya eres parte de Codify? "}
        <button
          type="button"
          onClick={() => setIsLogin(!isLogin)}
          className="text-primary hover:text-primary-hover font-semibold transition-colors"
        >
          {isLogin ? "Regístrate aquí" : "Inicia Sesión"}
        </button>
      </div>
    </Card>
  );
}
