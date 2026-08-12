-- Script SQL para insertar el Módulo 2: Programación Orientada a Objetos (POO)
-- Usamos Dollar Quoting ($THEORY$, $CODE$, $TEST$) para garantizar sintaxis 100% válida en PostgreSQL / Supabase.

DO $$
DECLARE
  poo_module_id UUID;
BEGIN
  -- 1. Crear el Módulo 2 "Programación Orientada a Objetos (POO)"
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 2: Programación Orientada a Objetos (POO)',
    'Aprende a modelar entidades del mundo real y videojuegos usando Objetos Literales, Clases, Métodos, Herencia y Encapsulamiento.',
    2
  )
  RETURNING id INTO poo_module_id;

  -- Lección 1: Objetos Literales
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 1: Objetos Literales y Propiedades',
    'Crea un objeto literal llamado "personaje" con las propiedades nombre, hp y nivel.',
    $THEORY$
### 🛡️ ¿Qué es un Objeto Literal?
En el mundo real, los objetos tienen **características** (propiedades). Por ejemplo, un personaje de un videojuego tiene un *nombre*, *puntos de vida (hp)* y un *nivel*.

En JavaScript, un **Objeto Literal** nos permite agrupar múltiples datos relacionados dentro de llaves `{ }`.

### 📝 Ejemplo de Código:
```js
const auto = {
  marca: "Toyota",
  modelo: "Corolla",
  velocidad: 120
};

// Acceder a una propiedad:
console.log(auto.marca); // "Toyota"
```

### 🎯 Tu Misión:
Crea un objeto literal asignado a la constante `personaje` con las siguientes 3 propiedades:
- `nombre`: `"Heroe"`
- `hp`: `100`
- `nivel`: `1`
$THEORY$,
    'logic',
    $CODE$// Crea el objeto literal personaje aquí:
const personaje = {

};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  nivel: 1
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje === "object" && personaje !== null, "personaje debe ser un objeto");
assert(personaje.nombre === "Heroe", "personaje.nombre debe ser 'Heroe'");
assert(personaje.hp === 100, "personaje.hp debe ser 100");
assert(personaje.nivel === 1, "personaje.nivel debe ser 1");$TEST$,
    30,
    1
  );

  -- Lección 2: Métodos de Objetos y 'this'
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 2: Métodos y la palabra clave "this"',
    'Agrega un método recibirDanio(cantidad) al objeto personaje que reste vida a su propiedad hp.',
    $THEORY$
### ⚡ Métodos y la palabra clave `this`
Los objetos no solo guardan datos, ¡también pueden realizar **acciones**! Una función dentro de un objeto se llama **Método**.

Para que un método pueda acceder o modificar las propias propiedades de su objeto, utilizamos la palabra clave `this`.

### 📝 Ejemplo de Código:
```js
const auto = {
  velocidad: 0,
  acelerar: function(incremento) {
    this.velocidad = this.velocidad + incremento;
  }
};

auto.acelerar(50);
console.log(auto.velocidad); // 50
```

### 🎯 Tu Misión:
Agrega un método llamado `recibirDanio(cantidad)` al objeto `personaje` que reste la `cantidad` recibida a `this.hp`.
$THEORY$,
    'logic',
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  // Agrega el método recibirDanio aquí:
  
};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  recibirDanio: function(cantidad) {
    this.hp -= cantidad;
  }
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje.recibirDanio === "function", "recibirDanio debe ser una función/método del objeto");
personaje.recibirDanio(30);
assert(personaje.hp === 70, "Luego de recibirDanio(30), hp debe valer 70");$TEST$,
    40,
    2
  );

  -- Lección 3: Tu Primera Clase (class y constructor)
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 3: Clases y el Constructor (class)',
    'Crea la clase Personaje con un constructor que asigne nombre y hp.',
    $THEORY$
### 🏭 Clases: El Molde para Crear Objetos
Imagínate que quieres crear 100 personajes para tu juego. En lugar de escribir 100 objetos a mano, creamos una **Clase** (una fábrica o molde).

Con la palabra clave `class` y el método especial `constructor()`, podemos instanciar objetos únicos usando `new`.

### 📝 Ejemplo de Código:
```js
class Auto {
  constructor(marca, velocidad) {
    this.marca = marca;
    this.velocidad = velocidad;
  }
}

// Crear instancias:
const auto1 = new Auto("Ford", 100);
const auto2 = new Auto("Tesla", 150);
```

### 🎯 Tu Misión:
Crea la clase `Personaje` con un `constructor(nombre, hp)` que inicialice las propiedades `this.nombre` y `this.hp`.
$THEORY$,
    'logic',
    $CODE$// Escribe tu clase Personaje aquí:
class Personaje {

}$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p = new Personaje("Mago", 80);
assert(p.nombre === "Mago", "El nombre de la instancia debe ser 'Mago'");
assert(p.hp === 80, "El hp de la instancia debe ser 80");$TEST$,
    50,
    3
  );

  -- Lección 4: Métodos de Estado y Combate
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 4: Estado del Objeto y Métodos de Combate',
    'Añade métodos estaVivo() y atacar(enemigo, danio) a la clase Personaje.',
    $THEORY$
### ⚔️ Métodos e Interacción entre Objetos
Las clases pueden tener métodos que evalúen el **estado del objeto** o que interactúen con **otros objetos de la misma clase**.

### 📝 Ejemplo de Código:
```js
class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }

  estaVivo() {
    return this.hp > 0;
  }

  atacar(enemigo, danio) {
    enemigo.hp -= danio;
  }
}
```

### 🎯 Tu Misión:
Añade a la clase `Personaje`:
1. El método `estaVivo()` que devuelva `true` si `this.hp > 0` o `false` si es `<= 0`.
2. El método `atacar(enemigo, danio)` que le reste `danio` a la propiedad `hp` del `enemigo`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }

  // Agrega estaVivo() y atacar(enemigo, danio) aquí:

}$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }

  estaVivo() {
    return this.hp > 0;
  }

  atacar(enemigo, danio) {
    enemigo.hp -= danio;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const p1 = new Personaje("Guerrero", 100);
const p2 = new Personaje("Orco", 30);
assert(p1.estaVivo() === true, "p1.estaVivo() debe ser true cuando hp > 0");
p1.atacar(p2, 40);
assert(p2.hp === -10, "Luego del ataque de 40, p2.hp debe valer -10");
assert(p2.estaVivo() === false, "p2.estaVivo() debe ser false cuando hp <= 0");$TEST$,
    60,
    4
  );

  -- Lección 5: Herencia (extends y super) - Reto Integrador POO
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 5: Herencia POO (extends & super)',
    'Crea la clase Mago que herede de Personaje e incluya la propiedad mana y el método lanzarHechizo.',
    $THEORY$
### 🏆 Herencia: Reutilizando Código con `extends`
La **Herencia** nos permite crear una clase especializada a partir de una clase base.

- Usamos `extends` para indicar de qué clase heredamos.
- Usamos `super(...)` dentro del constructor para llamar al constructor de la clase madre.

### 📝 Ejemplo de Código:
```js
class Mago extends Personaje {
  constructor(nombre, hp, mana) {
    super(nombre, hp); // Hereda nombre y hp de Personaje
    this.mana = mana;
  }

  lanzarHechizo(enemigo) {
    this.mana -= 20;
    enemigo.hp -= 40;
  }
}
```

### 🎯 Tu Misión:
1. Crea la clase `Mago` que extienda de `Personaje`.
2. Su constructor debe recibir `(nombre, hp, mana)`, llamar a `super(nombre, hp)` y guardar `this.mana`.
3. Añade el método `lanzarHechizo(enemigo)` que reste `20` a `this.mana` y reste `40` a `enemigo.hp`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

// Crea la clase Mago que hereda de Personaje aquí:
$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

class Mago extends Personaje {
  constructor(nombre, hp, mana) {
    super(nombre, hp);
    this.mana = mana;
  }

  lanzarHechizo(enemigo) {
    this.mana -= 20;
    enemigo.hp -= 40;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
const m = new Mago("Gandalf", 100, 50);
const o = new Personaje("Orco", 50);
assert(m.nombre === "Gandalf" && m.hp === 100 && m.mana === 50, "Mago debe heredar nombre y hp de Personaje y guardar mana");
m.lanzarHechizo(o);
assert(m.mana === 30, "Lanzar hechizo debe restar 20 de mana");
assert(o.hp === 10, "Lanzar hechizo debe restar 40 de hp al enemigo");$TEST$,
    100,
    5
  );

END $$;
