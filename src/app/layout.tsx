import type { Metadata } from "next";
import { Inter, Outfit } from "next/font/google";
import "./globals.css";
import { SidebarProvider } from "@/context/SidebarContext";
import { AuthGuard } from "@/components/auth/AuthGuard";
import { ThemeProvider } from "@/components/theme/ThemeProvider";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "SGFC | Aprende a Programar Jugando",
  description: "Plataforma de microaprendizaje interactivo, POO y IA",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" className={`${inter.variable} ${outfit.variable} antialiased`} suppressHydrationWarning>
      <body className="min-h-screen flex flex-col bg-background text-foreground">
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
          <SidebarProvider>
            <AuthGuard>
              {children}
            </AuthGuard>
          </SidebarProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
