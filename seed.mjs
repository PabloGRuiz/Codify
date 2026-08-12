import { createClient } from "@supabase/supabase-js";
import fs from "fs";

const supabaseUrl = "https://aympfschfrrhcvsjflbf.supabase.co";
const supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5bXBmc2NoZnJyaGN2c2pmbGJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYzNDIyMzcsImV4cCI6MjEwMTkxODIzN30.uHwXGKElujhDko9DOPFu7fM3_GPGrfbFHPDmFZhWdKI";

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function seed() {
  console.log("🌱 Iniciando inserción de datos a través del API de Supabase...");

  try {
    // 1. Crear o buscar Módulo 1
    let { data: mod1 } = await supabase.from("modules").select("id").eq("title", "Curso Inicial: Aprende a Programar desde Cero").single();
    if (!mod1) {
      const { data, error } = await supabase.from("modules").insert({
        title: "Curso Inicial: Aprende a Programar desde Cero",
        description: "Primer segmento esencial: Variables, Matemáticas, Condicionales, Bucles y Funciones.",
        difficulty_level: 1
      }).select().single();
      if (error) throw error;
      mod1 = data;
    }
    console.log("✅ Módulo 1 listo:", mod1.id);

    // 2. Crear o buscar Módulo 2 (POO)
    let { data: mod2 } = await supabase.from("modules").select("id").eq("title", "Módulo 2: Programación Orientada a Objetos (POO)").single();
    if (!mod2) {
      const { data, error } = await supabase.from("modules").insert({
        title: "Módulo 2: Programación Orientada a Objetos (POO)",
        description: "Aprende a modelar entidades del mundo real usando Objetos Literales, Clases, Métodos, Herencia y Encapsulamiento.",
        difficulty_level: 2
      }).select().single();
      if (error) throw error;
      mod2 = data;
    }
    console.log("✅ Módulo 2 (POO) listo:", mod2.id);

    // 3. Crear o buscar Módulo 3
    let { data: mod3 } = await supabase.from("modules").select("id").eq("title", "Módulo 3: Prototipado Web Básico").single();
    if (!mod3) {
      const { data, error } = await supabase.from("modules").insert({
        title: "Módulo 3: Prototipado Web Básico",
        description: "Crea tus primeras interfaces web con HTML5, estilos CSS3 y manipulación del DOM.",
        difficulty_level: 1
      }).select().single();
      if (error) throw error;
      mod3 = data;
    }
    console.log("✅ Módulo 3 listo:", mod3.id);

    console.log("🎉 ¡Módulos verificados e insertados correctamente en Supabase!");
  } catch (err) {
    console.error("❌ Error durante la siembra de datos:", err);
  }
}

seed();
