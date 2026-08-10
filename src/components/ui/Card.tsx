import { ReactNode } from "react";

interface CardProps {
  children: ReactNode;
  className?: string;
  variant?: "default" | "glass";
}

export function Card({ children, className = "", variant = "default" }: CardProps) {
  const baseStyles = "rounded-xl overflow-hidden";
  const variants = {
    default: "bg-card text-card-foreground border border-border shadow-lg",
    glass: "glass-panel text-white"
  };

  return (
    <div className={`${baseStyles} ${variants[variant]} ${className}`}>
      {children}
    </div>
  );
}
