/**
 * Utilidad ligera para formatear fechas relativas en español sin dependencias externas
 */
export function formatTimeAgo(dateInput: string | Date): string {
  try {
    const date = typeof dateInput === "string" ? new Date(dateInput) : dateInput;
    const now = new Date();
    const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000);

    if (diffInSeconds < 60) {
      return "hace unos segundos";
    }

    const diffInMinutes = Math.floor(diffInSeconds / 60);
    if (diffInMinutes < 60) {
      return `hace ${diffInMinutes} ${diffInMinutes === 1 ? "minuto" : "minutos"}`;
    }

    const diffInHours = Math.floor(diffInMinutes / 60);
    if (diffInHours < 24) {
      return `hace ${diffInHours} ${diffInHours === 1 ? "hora" : "horas"}`;
    }

    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays < 30) {
      return `hace ${diffInDays} ${diffInDays === 1 ? "día" : "días"}`;
    }

    const diffInMonths = Math.floor(diffInDays / 30);
    if (diffInMonths < 12) {
      return `hace ${diffInMonths} ${diffInMonths === 1 ? "mes" : "meses"}`;
    }

    const diffInYears = Math.floor(diffInDays / 365);
    return `hace ${diffInYears} ${diffInYears === 1 ? "año" : "años"}`;
  } catch {
    return "hace un momento";
  }
}
