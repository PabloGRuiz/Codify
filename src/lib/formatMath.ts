/**
 * 🧮 SGFC MATHEMATICAL & MARKDOWN NOTATION FORMATTER
 * Convierte expresiones LaTeX, símbolos griegos, notación Big-O y fórmulas
 * matemáticas en texto formateado de alta legibilidad para Markdown y React.
 */

export function formatMathAndMarkdown(content: string): string {
  if (!content) return "";

  return content
    // Normalizar saltos de línea y tablas markdown colapsadas
    .replace(/\\r\\n/g, "\n")
    .replace(/\\n/g, "\n")
    .replace(/\|\s*\|\s*/g, "|\n| ")
    .replace(/\|\s*:\-\-/g, "\n| :--")

    // Comandos de formato LaTeX
    .replace(/\\mathbf\{([^}]+)\}/g, "**$1**")
    .replace(/\\mathit\{([^}]+)\}/g, "*$1*")
    .replace(/\\text\{([^}]+)\}/g, "$1")

    // Letras griegas asintóticas y matemáticas (mayúsculas y minúsculas)
    .replace(/\\Omega\b/g, "Ω")
    .replace(/\\omega\b/g, "ω")
    .replace(/\\Theta\b/g, "Θ")
    .replace(/\\theta\b/g, "θ")
    .replace(/\\Sigma\b/g, "Σ")
    .replace(/\\sigma\b/g, "σ")
    .replace(/\\Delta\b/g, "Δ")
    .replace(/\\delta\b/g, "δ")
    .replace(/\\alpha\b/g, "α")
    .replace(/\\beta\b/g, "β")
    .replace(/\\gamma\b/g, "γ")
    .replace(/\\lambda\b/g, "λ")
    .replace(/\\mu\b/g, "μ")
    .replace(/\\pi\b/g, "π")
    .replace(/\\epsilon\b/g, "ε")
    .replace(/\\phi\b/g, "ϕ")

    // Fracciones y funciones matemáticas
    .replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, "($1 / $2)")
    .replace(/\\sum(?:_\{[^}]+\}|\^[^\s]+|\s)*\s*/g, "∑ ")
    .replace(/\\prod(?:_\{[^}]+\}|\^[^\s]+|\s)*\s*/g, "∏ ")
    .replace(/\\sqrt\{([^}]+)\}/g, "√($1)")

    // Logaritmos y constantes
    .replace(/\$\\log_2\(([^)]+)\)\s*\\approx\s*([^$]+)\$/g, "log₂($1) ≈ $2")
    .replace(/\\log_2\b/g, "log₂")
    .replace(/\\log\b/g, "log")
    .replace(/\$1\.000\.000\$/g, "1.000.000")

    // Operadores y relaciones lógicas
    .replace(/\\approx\b/g, "≈")
    .replace(/\\cdot\b/g, "·")
    .replace(/\\times\b/g, "×")
    .replace(/\\le_p\b|\\le_\{p\}/g, "≤ₚ")
    .replace(/\\le(q)?\b/g, "≤")
    .replace(/\\ge(q)?\b/g, "≥")
    .replace(/\\ne(q)?\b/g, "≠")
    .replace(/\\infty\b/g, "∞")
    .replace(/\\in\b/g, "∈")
    .replace(/\\notin\b/g, "∉")
    .replace(/\\subset(eq)?\b/g, "⊆")
    .replace(/\\implies\b/g, "⇒")
    .replace(/\\iff\b/g, "⇔")
    .replace(/\\forall\b/g, "∀")
    .replace(/\\exists\b/g, "∃")
    .replace(/\\(c)?dots\b/g, "…")

    // Superíndices matemáticos comunes
    .replace(/\bn\^4\b/g, "n⁴")
    .replace(/\bn\^3\b/g, "n³")
    .replace(/\bn\^2\b/g, "n²")
    .replace(/\bn\^k\b/g, "nᵏ")
    .replace(/\bx\^n\b/g, "xⁿ")
    .replace(/\b2\^n\b/g, "2ⁿ")
    .replace(/\b2\^4\b/g, "2⁴")
    .replace(/\b2\^8\b/g, "2⁸")
    .replace(/\b2\^\{?10\}?\b/g, "2¹⁰")
    .replace(/\b2\^\{?16\}?\b/g, "2¹⁶")
    .replace(/\b2\^\{?32\}?\b/g, "2³²")

    // Formateo de notación asintótica Big-O
    .replace(/\$O\(\\log\s*N\)\$/gi, "`O(log N)`")
    .replace(/\$O\(N\s*\\log\s*N\)\$/gi, "`O(N log N)`")
    .replace(/\$O\(([^$]+)\)\$/g, "`O($1)`")
    .replace(/\$O\$/g, "`O`")
    .replace(/\$N\$/g, "*N*")
    .replace(/\$n\$/g, "*n*")

    // Fórmulas matemáticas en bloque: $$ ... $$
    .replace(/\$\$\s*([\s\S]*?)\s*\$\$/g, "\n\n> **$1**\n\n")

    // Fórmulas matemáticas en línea: $ ... $ (eliminar signos de dólar envolventes)
    .replace(/\$([^$\n]+)\$/g, "$1");
}
