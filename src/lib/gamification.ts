/**
 * 🎮 CODIFY GAMIFICATION & PROGRESSION ENGINE
 * Sistema de cálculo de niveles, curvas de experiencia progresiva (RPG)
 * y rotación determinista de retos diarios.
 */

// Curva de progresión de niveles (XP acumulada necesaria para alcanzar cada nivel)
const LEVEL_THRESHOLDS = [
  0,      // Nivel 1 (0 - 249 XP)
  250,    // Nivel 2 (250 - 599 XP)
  600,    // Nivel 3 (600 - 1099 XP)
  1100,   // Nivel 4 (1100 - 1799 XP)
  1800,   // Nivel 5 (1800 - 2799 XP)
  2800,   // Nivel 6 (2800 - 4199 XP)
  4200,   // Nivel 7 (4200 - 5999 XP)
  6000,   // Nivel 8 (6000 - 8499 XP)
  8500,   // Nivel 9 (8500 - 11999 XP)
  12000,  // Nivel 10 (12000 - 16999 XP)
  17000,  // Nivel 11
  23000,  // Nivel 12
  30000,  // Nivel 13
  40000,  // Nivel 14
  55000,  // Nivel 15 (Gran Maestro Coder)
];

export interface LevelInfo {
  level: number;
  totalXp: number;
  currentLevelMinXp: number;
  nextLevelMinXp: number;
  xpInLevel: number;
  xpRequiredForNextLevel: number;
  progressPercentage: number;
  xpRemaining: number;
}

export function getLevelInfo(totalXpInput: number | null | undefined): LevelInfo {
  const totalXp = Math.max(0, totalXpInput || 0);

  let level = 1;
  while (level < LEVEL_THRESHOLDS.length && totalXp >= LEVEL_THRESHOLDS[level]) {
    level++;
  }

  const currentLevelMinXp = LEVEL_THRESHOLDS[level - 1] || 0;
  const nextLevelMinXp = LEVEL_THRESHOLDS[level] || currentLevelMinXp + 3000;

  const xpInLevel = totalXp - currentLevelMinXp;
  const xpRequiredForNextLevel = nextLevelMinXp - currentLevelMinXp;
  const progressPercentage = Math.min(100, Math.max(0, Math.round((xpInLevel / xpRequiredForNextLevel) * 100)));
  const xpRemaining = Math.max(0, nextLevelMinXp - totalXp);

  return {
    level,
    totalXp,
    currentLevelMinXp,
    nextLevelMinXp,
    xpInLevel,
    xpRequiredForNextLevel,
    progressPercentage,
    xpRemaining,
  };
}

/**
 * Obtiene los 3 índices de retos que rotan hoy según la fecha actual.
 * @param totalChallenges Cantidad total de retos en el pool
 * @param date Fecha a evaluar (por defecto hoy)
 */
export function getDailyChallengeIndices(totalChallenges: number, date: Date = new Date()): number[] {
  if (totalChallenges <= 3) {
    return Array.from({ length: totalChallenges }, (_, i) => i);
  }

  // Obtener el día del año como semilla determinista
  const start = new Date(date.getFullYear(), 0, 0);
  const diff = date.getTime() - start.getTime();
  const oneDay = 1000 * 60 * 60 * 24;
  const dayOfYear = Math.floor(diff / oneDay);

  const idx1 = dayOfYear % totalChallenges;
  const idx2 = (dayOfYear * 3 + 1) % totalChallenges;
  const idx3 = (dayOfYear * 7 + 3) % totalChallenges;

  // Garantizar que no haya índices duplicados
  const selected = new Set<number>([idx1]);
  
  let candidate2 = idx2;
  while (selected.has(candidate2)) {
    candidate2 = (candidate2 + 1) % totalChallenges;
  }
  selected.add(candidate2);

  let candidate3 = idx3;
  while (selected.has(candidate3)) {
    candidate3 = (candidate3 + 1) % totalChallenges;
  }
  selected.add(candidate3);

  return Array.from(selected);
}
