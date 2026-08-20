"use client";

import { useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useUser } from "@/hooks/useUser";
import { Code2 } from "lucide-react";

// Rutas públicas que no requieren que el usuario esté autenticado
const PUBLIC_ROUTES = ["/auth"];

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const { user, loading } = useUser();
  const pathname = usePathname();
  const router = useRouter();

  const isPublicRoute = PUBLIC_ROUTES.some((route) => 
    pathname === route || pathname.startsWith(`${route}/`)
  );

  useEffect(() => {
    if (loading) return;

    // 1. Si no hay usuario y está intentando acceder a una ruta protegida -> Redirigir a /auth
    if (!user && !isPublicRoute) {
      router.replace("/auth");
    }

    // 2. Si ya hay usuario autenticado y está en /auth -> Redirigir al dashboard (/)
    if (user && isPublicRoute) {
      router.replace("/");
    }
  }, [user, loading, pathname, isPublicRoute, router]);

  // Pantalla de carga estética mientras verificamos la sesión inicial
  if (loading) {
    return (
      <div className="min-h-screen w-full flex flex-col items-center justify-center bg-background relative overflow-hidden">
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-primary/20 rounded-full blur-[140px] pointer-events-none" />
        
        <div className="flex flex-col items-center gap-4 z-10 animate-pulse">
          <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shadow-[0_0_40px_rgba(139,92,246,0.5)]">
            <Code2 size={32} className="text-white" />
          </div>
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 rounded-full bg-primary animate-bounce [animation-delay:-0.3s]" />
            <div className="w-2 h-2 rounded-full bg-primary animate-bounce [animation-delay:-0.15s]" />
            <div className="w-2 h-2 rounded-full bg-primary animate-bounce" />
          </div>
          <span className="text-sm font-medium text-zinc-400 font-sans tracking-wide">
            Cargando Codify...
          </span>
        </div>
      </div>
    );
  }

  // Si no está autenticado y es ruta protegida, no renderizamos el contenido protegido mientras se redirige
  if (!user && !isPublicRoute) {
    return null;
  }

  // Si está autenticado e intenta ir a /auth, no renderizamos el formulario mientras se redirige
  if (user && isPublicRoute) {
    return null;
  }

  return <>{children}</>;
}
