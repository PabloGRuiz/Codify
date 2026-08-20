import { NextResponse } from "next/server";

export const revalidate = 300; // Cache for 5 minutes

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const tag = searchParams.get("tag") || "programming";

  try {
    // Fetch live articles from Dev.to API (reliable, fast, free, no API key required)
    const targetTag = tag === "all" ? "programming" : tag;
    const response = await fetch(
      `https://dev.to/api/articles?tag=${encodeURIComponent(targetTag)}&top=8`,
      {
        headers: {
          "User-Agent": "Codify-Learning-Platform/1.0",
        },
        next: { revalidate: 300 },
      }
    );

    if (!response.ok) {
      throw new Error(`Dev.to API responded with status ${response.status}`);
    }

    const data = await response.json();

    const formattedArticles = data.map((item: any) => ({
      id: item.id,
      title: item.title,
      description: item.description || "Descubre las últimas novedades y mejores prácticas en la industria tecnológica.",
      url: item.url,
      cover_image: item.cover_image || item.social_image || null,
      reading_time_minutes: item.reading_time_minutes || 4,
      published_at: item.published_at,
      tag_list: item.tag_list || [targetTag],
      user: {
        name: item.user?.name || "Tech Author",
        profile_image: item.user?.profile_image_90 || null,
      },
      source: "Dev.to & Tech Pulse",
    }));

    return NextResponse.json({
      success: true,
      articles: formattedArticles,
      tag: targetTag,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    console.error("Error fetching live tech news:", error);

    // Fallback curated news in case of external network timeout
    const fallbackArticles = [
      {
        id: 1,
        title: "FastAPI lanza mejoras masivas de rendimiento y validación con Pydantic v2",
        description: "El framework backend líder en Python optimiza sus serializadores de datos para microservicios de Inteligencia Artificial.",
        url: "https://fastapi.tiangolo.com",
        cover_image: null,
        reading_time_minutes: 5,
        published_at: new Date().toISOString(),
        tag_list: ["python", "fastapi", "backend"],
        user: { name: "Codify Editorial", profile_image: null },
        source: "Tech Pulse",
      },
      {
        id: 2,
        title: "Modelos de Lenguaje y RAG: Cómo los Embeddings están transformando la búsqueda semántica",
        description: "Una guía profunda sobre cómo las bases de datos vectoriales eliminan alucinaciones y aceleran el análisis documental.",
        url: "https://openai.com/research",
        cover_image: null,
        reading_time_minutes: 6,
        published_at: new Date().toISOString(),
        tag_list: ["ai", "llm", "embeddings"],
        user: { name: "AI Research Group", profile_image: null },
        source: "AI Dispatch",
      },
      {
        id: 3,
        title: "Modern JavaScript: Nuevas características de ECMAScript para código asincrónico",
        description: "Exploramos Promise.withResolvers(), iteradores asincrónicos y optimizaciones en el motor V8.",
        url: "https://developer.mozilla.org",
        cover_image: null,
        reading_time_minutes: 4,
        published_at: new Date().toISOString(),
        tag_list: ["javascript", "webdev", "async"],
        user: { name: "Web Standards", profile_image: null },
        source: "Dev Community",
      },
    ];

    return NextResponse.json({
      success: true,
      articles: fallbackArticles,
      isFallback: true,
      timestamp: new Date().toISOString(),
    });
  }
}
