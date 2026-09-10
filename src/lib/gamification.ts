/**
 * 🎮 SGFC GAMIFICATION & PROGRESSION ENGINE
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

export type ArenaRank = "unranked" | "bronce" | "plata" | "oro";

export interface ArenaRankInfo {
  rank: ArenaRank;
  label: string;
  badge: string;
  color: string;
  nextRankLabel: string | null;
  streak: number;
  requiredStreak: number;
  streakPercentage: number;
  inPromotion: boolean;
}

export function getArenaRankInfo(rankInput?: string | null, streakInput?: number | null): ArenaRankInfo {
  const rank = (rankInput?.toLowerCase() || "unranked") as ArenaRank;
  const streak = Math.max(0, streakInput || 0);
  const inPromotion = (rank === "bronce" || rank === "plata") && streak >= 3;

  switch (rank) {
    case "oro":
      return {
        rank: "oro",
        label: "Oro",
        badge: "🥇",
        color: "text-amber-400 border-amber-500/30 bg-amber-500/10",
        nextRankLabel: null,
        streak: streak,
        requiredStreak: 3,
        streakPercentage: Math.min(100, Math.round((streak / 3) * 100)),
        inPromotion: false,
      };
    case "plata":
      return {
        rank: "plata",
        label: "Plata",
        badge: "🥈",
        color: "text-slate-300 border-slate-400/30 bg-slate-400/10",
        nextRankLabel: "Oro",
        streak: Math.min(3, streak),
        requiredStreak: 3,
        streakPercentage: inPromotion ? 100 : Math.round((Math.min(3, streak) / 3) * 100),
        inPromotion,
      };
    case "bronce":
      return {
        rank: "bronce",
        label: "Bronce",
        badge: "🥉",
        color: "text-amber-600 border-amber-600/30 bg-amber-600/10",
        nextRankLabel: "Plata",
        streak: Math.min(3, streak),
        requiredStreak: 3,
        streakPercentage: inPromotion ? 100 : Math.round((Math.min(3, streak) / 3) * 100),
        inPromotion,
      };
    case "unranked":
    default:
      return {
        rank: "unranked",
        label: "Sin Rango",
        badge: "🔰",
        color: "text-zinc-400 border-zinc-500/30 bg-zinc-500/10",
        nextRankLabel: "Bronce",
        streak: 0,
        requiredStreak: 1,
        streakPercentage: 0,
        inPromotion: false,
      };
  }
}

/**
 * Calcula la promoción o avance de racha tras resolver un reto de la arena exitosamente.
 * Si el usuario ya tiene 3 victorias consecutivas (en fase de promoción),
 * esta victoria corresponde al reto del tier superior y confirma el ascenso.
 */
export function calculateArenaPromotion(currentRankInput?: string | null, currentStreakInput?: number | null): {
  newRank: ArenaRank;
  newStreak: number;
  promoted: boolean;
  message: string;
} {
  const currentRank = (currentRankInput?.toLowerCase() || "unranked") as ArenaRank;
  const currentStreak = Math.max(0, currentStreakInput || 0);

  if (currentRank === "unranked") {
    // Primer reto completado -> Asigna Bronce inmediatamente
    return {
      newRank: "bronce",
      newStreak: 0,
      promoted: true,
      message: "¡Bienvenido a la Arena! Has obtenido tu rango inicial de Bronce 🥉",
    };
  }

  if (currentRank === "bronce") {
    // Si ya estaba en racha 3/3, este fue su Desafío de Promoción del tier Plata
    if (currentStreak >= 3) {
      return {
        newRank: "plata",
        newStreak: 0, // Inicia en 0/3 en Plata (el reto de promo no suma para el siguiente)
        promoted: true,
        message: "🏆 ¡DESAFÍO DE PROMOCIÓN SUPERADO! Has vencido el reto de tier superior y alcanzado el rango Plata 🥈.",
      };
    }

    const nextStreak = currentStreak + 1;
    if (nextStreak >= 3) {
      return {
        newRank: "bronce",
        newStreak: 3,
        promoted: false,
        message: "🔥 ¡3 VICTORIAS CONSECUTIVAS! Has clasificado a la FASE DE PROMOCIÓN hacia Plata ⚔️. Tu próximo reto será el examen de ascenso.",
      };
    }

    return {
      newRank: "bronce",
      newStreak: nextStreak,
      promoted: false,
      message: `¡Gran victoria! Racha consecutiva: ${nextStreak}/3 hacia la Promoción de Plata.`,
    };
  }

  if (currentRank === "plata") {
    // Si ya estaba en racha 3/3, este fue su Desafío de Promoción del tier Oro
    if (currentStreak >= 3) {
      return {
        newRank: "oro",
        newStreak: 0, // Inicia en 0 en Oro (ascenso limpio)
        promoted: true,
        message: "🏆 ¡DESAFÍO DE PROMOCIÓN SUPERADO! Has vencido el reto de tier superior y alcanzado el rango de Oro 🥇!",
      };
    }

    const nextStreak = currentStreak + 1;
    if (nextStreak >= 3) {
      return {
        newRank: "plata",
        newStreak: 3,
        promoted: false,
        message: "🔥 ¡3 VICTORIAS CONSECUTIVAS! Has clasificado a la FASE DE PROMOCIÓN hacia Oro ⚔️. Tu próximo reto será el examen de ascenso.",
      };
    }

    return {
      newRank: "plata",
      newStreak: nextStreak,
      promoted: false,
      message: `¡Gran victoria! Racha consecutiva: ${nextStreak}/3 hacia la Promoción de Oro.`,
    };
  }

  // Si ya es Oro
  const nextStreak = currentStreak + 1;
  return {
    newRank: "oro",
    newStreak: nextStreak,
    promoted: false,
    message: `¡Victoria en Rango Oro 🥇! Racha invicto: ${nextStreak} victorias consecutivas en la cumbre.`,
  };
}

/**
 * Calcula el resultado de fallar un reto en la Arena (agotar los 3 intentos).
 * Resetea la racha hacia el siguiente rango a 0 para impedir el ascenso.
 */
export function calculateArenaFailure(currentRankInput?: string | null, currentStreakInput?: number | null): {
  newRank: ArenaRank;
  newStreak: number;
  message: string;
} {
  const currentRank = (currentRankInput?.toLowerCase() || "unranked") as ArenaRank;
  const currentStreak = Math.max(0, currentStreakInput || 0);
  const wasInPromo = currentStreak >= 3;

  return {
    newRank: currentRank,
    newStreak: 0,
    message: wasInPromo
      ? "Has caído en el Desafío de Promoción. Tu racha clasificatoria se reinicia a 0/3. ¡Reagrúpate y vuelve a intentarlo!"
      : (currentRank === "unranked"
        ? "Has agotado tus 3 intentos en este reto. ¡Sigue practicando para alcanzar Bronce!"
        : "Has agotado tus 3 intentos. Tu racha clasificatoria se reinicia a 0/3."),
  };
}
