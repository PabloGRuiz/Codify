-- ==============================================================================
-- 🛡️ CODIFY SEED: MÓDULO 2 - PROGRAMACIÓN ORIENTADA A OBJETOS (POO)
-- ==============================================================================
-- Este script es 100% INDEPENDIENTE e IDEMPOTENTE.
-- Solo actualiza el Módulo 2 sin borrar ni alterar los demás módulos de tu base de datos.
-- ==============================================================================

DO $$
DECLARE
  poo_module_id UUID;
BEGIN

  -- 1. Limpieza segura EXCLUSIVA de este módulo (evita duplicados al reejecutar)
  DELETE FROM public.user_progress WHERE challenge_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 2: Programación Orientada a Objetos (POO)'
    )
  );
  DELETE FROM public.challenges WHERE module_id IN (
    SELECT id FROM public.challenges WHERE module_id IN (
      SELECT id FROM public.modules WHERE title = 'Módulo 2: Programación Orientada a Objetos (POO)'
    )
  );
  DELETE FROM public.modules WHERE title = 'Módulo 2: Programación Orientada a Objetos (POO)';

  -- 2. Creación del Módulo 2
  INSERT INTO public.modules (title, description, difficulty_level)
  VALUES (
    'Módulo 2: Programación Orientada a Objetos (POO)',
    'Aprende a modelar el mundo real en código: Objetos Literales, métodos, la palabra clave this, Clases con constructores, interacciones de estado y Herencia con extends y super.',
    2
  )
  RETURNING id INTO poo_module_id;


  -- ============================================================================
  -- LECCIÓN 1: Objetos Literales y Estructuras de Datos
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 1: Objetos Literales y Propiedades',
    'Crea un objeto literal llamado "personaje" con las propiedades nombre, hp y nivel.',
    $THEORY$
### 🛡️ 1. Modelando el Mundo Real: ¿Qué es un Objeto?
Hasta ahora guardabas datos en variables individuales:
`const nombre = "Heroe";`  
`let vida = 100;`  
`let nivel = 1;`

Pero en aplicaciones reales y videojuegos, los datos pertenecen a una **misma entidad**. 
Piensa en la **ficha de personaje de un juego de rol** o en el perfil de un usuario: todas las características van agrupadas en un solo lugar.

En JavaScript, un **Objeto Literal** nos permite empaquetar múltiples datos relacionados dentro de llaves `{ }`.

---

### 🔑 2. Anatomía de un Objeto: Claves y Valores
Un objeto está compuesto por pares de **clave : valor** separados por comas:

```js
const naveEspacial = {
  modelo: "Falcon-9",  // Clave: "modelo", Valor: "Falcon-9"
  escudos: 100,        // Clave: "escudos", Valor numérico 100
  hiperpropulsor: true // Booleano
};

// Acceder a una propiedad con la notación de punto (.):
console.log(naveEspacial.modelo);  // Imprime "Falcon-9"
console.log(naveEspacial.escudos); // Imprime 100
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Usar `=` en lugar de `:`:** Escribir `{ nombre = "Heroe" }` (causa error de sintaxis). En objetos siempre se usa dos puntos `:`.
- ❌ **Olvidar las comas:** Separar cada propiedad con una coma `,`.

---

### 🎯 Tu Misión de Hoy:
Crea un objeto literal asignado a la constante `personaje` con exactamente estas 3 propiedades:
- `nombre`: con el texto `"Heroe"`
- `hp`: con el número `100` (puntos de vida)
- `nivel`: con el número `1`
$THEORY$,
    'logic',
    $CODE$// Crea el objeto literal personaje aquí abajo:
const personaje = {

};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  nivel: 1
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje === "object" && personaje !== null, "Debes declarar la constante 'personaje' como un objeto.");
assert(personaje.nombre === "Heroe", "La propiedad 'nombre' debe valer 'Heroe'.");
assert(personaje.hp === 100, "La propiedad 'hp' debe ser igual a 100.");
assert(personaje.nivel === 1, "La propiedad 'nivel' debe ser igual a 1.");$TEST$,
    30,
    1
  );


  -- ============================================================================
  -- LECCIÓN 2: Métodos de Objetos y la palabra clave 'this'
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 2: Métodos y la palabra clave "this"',
    'Agrega un método recibirDanio(cantidad) al objeto personaje que reste vida a su propiedad hp.',
    $THEORY$
### ⚡ 1. Dando Vida a los Objetos: ¿Qué es un Método?
Los objetos no solo almacenan características (datos), ¡también pueden **realizar acciones**!
Cuando una función vive dentro de un objeto, la llamamos **Método**.

---

### 🧭 2. El Poder de la palabra clave `this`
Imagina que estás jugando con tu personaje y un enemigo lo ataca. ¿Cómo sabe el personaje que debe restar vida de **su propia** barra de vida?

Para referirnos a las propiedades del **mismo objeto en el que estamos parados**, usamos la palabra mágica `this` (que significa *"este objeto"*):

```js
const guerrero = {
  nombre: "Kael",
  hp: 80,
  curar: function(puntos) {
    this.hp += puntos; // Modifica el hp de 'este' guerrero
  }
};

guerrero.curar(20);
console.log(guerrero.hp); // Ahora vale 100
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Olvidar el `this.`:** Escribir `hp -= cantidad;` en lugar de `this.hp -= cantidad;`. Sin `this`, JavaScript buscará una variable externa que no existe.

---

### 🎯 Tu Misión de Hoy:
Agrega un método llamado `recibirDanio(cantidad)` dentro del objeto `personaje`:
- El método debe recibir por parámetro un número `cantidad`.
- Debe restar esa `cantidad` al atributo `this.hp`.
$THEORY$,
    'logic',
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  // Agrega el método recibirDanio aquí abajo:
  
};$CODE$,
    $CODE$const personaje = {
  nombre: "Heroe",
  hp: 100,
  recibirDanio: function(cantidad) {
    this.hp -= cantidad;
  }
};$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof personaje.recibirDanio === "function", "El objeto personaje debe tener un método llamado 'recibirDanio'.");
personaje.recibirDanio(30);
assert(personaje.hp === 70, "Al llamar a recibirDanio(30), el hp debe reducirse de 100 a 70.");
personaje.recibirDanio(20);
assert(personaje.hp === 50, "Al volver a recibirDanio(20), el hp debe quedar en 50.");$TEST$,
    40,
    2
  );


  -- ============================================================================
  -- LECCIÓN 3: Clases y el Constructor (El Molde de Objetos)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 3: Clases y el Constructor (class)',
    'Crea la clase Personaje con un constructor que inicialice nombre y hp.',
    $THEORY$
### 🏭 1. La Fábrica de Objetos: ¿Por qué necesitamos Clases?
¿Qué pasaría si tuvieras que crear 500 personajes en tu juego? Escribir 500 objetos literales `{ ... }` a mano sería ineficiente y repetitivo.

Una **Clase (`class`)** es como el **plano de un arquitecto** o el molde de una fábrica: defines las reglas una sola vez y luego puedes fabricar miles de objetos idénticos en estructura pero con datos únicos.

---

### 🏗️ 2. El Método Especial `constructor()`
Dentro de una clase existe una función especial llamada `constructor()`. Se ejecuta automáticamente cada vez que creamos una nueva instancia con la palabra clave `new`:

```js
class Auto {
  constructor(marca, color) {
    this.marca = marca; // Guarda la marca del auto creado
    this.color = color; // Guarda el color
  }
}

// Fabricamos autos usando 'new':
const auto1 = new Auto("Toyota", "Rojo");
const auto2 = new Auto("Tesla", "Negro");

console.log(auto1.marca); // "Toyota"
console.log(auto2.marca); // "Tesla"
```

---

### ⚠️ Errores Comunes de Principiantes
- ❌ **Poner `function constructor()`:** Dentro de una clase **NO** se usa la palabra `function`.
- ❌ **Olvidar `this.` dentro del constructor:** Si no escribes `this.nombre = nombre;`, los datos se perderán al salir del constructor.

---

### 🎯 Tu Misión de Hoy:
Crea la clase `Personaje`:
1. Debe incluir un `constructor(nombre, hp)` que reciba el nombre y los puntos de vida.
2. Dentro del constructor, asigna `this.nombre = nombre;` y `this.hp = hp;`.
$THEORY$,
    'logic',
    $CODE$// Escribe tu clase Personaje aquí abajo:
class Personaje {

}$CODE$,
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}$CODE$,
    $TEST$const assert = (c, m) => { if (!c) throw new Error(m); };
assert(typeof Personaje === "function", "Debes declarar la clase 'Personaje'.");
const p1 = new Personaje("Mago", 80);
assert(p1.nombre === "Mago", "La propiedad 'nombre' de la instancia debe ser 'Mago'.");
assert(p1.hp === 80, "La propiedad 'hp' de la instancia debe ser 80.");
const p2 = new Personaje("Arquero", 90);
assert(p2.nombre === "Arquero" && p2.hp === 90, "La clase debe permitir instanciar múltiples personajes distintos.");$TEST$,
    50,
    3
  );


  -- ============================================================================
  -- LECCIÓN 4: Métodos de Estado y Combate RPG
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 4: Estado del Objeto y Métodos de Combate',
    'Añade métodos estaVivo() y atacar(enemigo, danio) a la clase Personaje.',
    $THEORY$
### ⚔️ 1. Interacción entre Objetos: Duelos de Combate
En la Programación Orientada a Objetos, los objetos pueden **interactuar entre sí**. 
Un personaje puede recibir a otro personaje como parámetro y alterar sus atributos (por ejemplo, restarle vida al atacar).

---

### 🕹️ 2. Métodos de Estado y Métodos de Acción
Dentro de una clase podemos agregar métodos de dos tipos:

1. **Métodos de Estado:** Consultan una condición del propio objeto y devuelven `true` o `false`.
2. **Métodos de Interacción:** Reciben a otro objeto y llaman a sus propiedades o métodos.

```js
class Robot {
  constructor(nombre, energia) {
    this.nombre = nombre;
    this.energia = energia;
  }

  // Método de estado:
  tieneBateria() {
    return this.energia > 0;
  }

  // Método de interacción (recibe a otro robot):
  transferirEnergia(otroRobot, cantidad) {
    this.energia -= cantidad;
    otroRobot.energia += cantidad;
  }
}
```

---

### 🎯 Tu Misión de Hoy:
Añade a la clase `Personaje` los siguientes dos métodos:
1. `estaVivo()`: Debe retornar `true` si `this.hp > 0`, o `false` en caso contrario (`this.hp <= 0`).
2. `atacar(enemigo, danio)`: Debe restarle `danio` a la propiedad `hp` del `enemigo` recibido por parámetro (`enemigo.hp -= danio`).
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }

  // 1. Agrega el método estaVivo() aquí:


  // 2. Agrega el método atacar(enemigo, danio) aquí:

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
assert(p1.estaVivo() === true, "p1.estaVivo() debe ser true cuando su hp es mayor a 0.");
p1.atacar(p2, 40);
assert(p2.hp === -10, "Al atacar con 40 de daño a un enemigo de 30 hp, su hp debe quedar en -10.");
assert(p2.estaVivo() === false, "p2.estaVivo() debe retornar false cuando su hp es menor o igual a 0.");$TEST$,
    60,
    4
  );


  -- ============================================================================
  -- LECCIÓN 5: Herencia y Clases Especializadas (extends & super)
  -- ============================================================================
  INSERT INTO public.challenges (
    module_id, title, description, theory, challenge_type, initial_code, solution_code, test_code, xp_reward, order_index
  ) VALUES (
    poo_module_id,
    'Lección 5: Herencia POO (extends & super)',
    'Crea la clase Mago que herede de Personaje e incluya la propiedad mana y el método lanzarHechizo.',
    $THEORY$
### 🏆 1. El Pilar Maestro de la POO: La Herencia
Imagina que en tu juego quieres agregar **Guerreros, Magos y Arqueros**.
Todos ellos son `Personajes`: todos tienen un `nombre`, puntos de `hp` y pueden `atacar()`.

En lugar de reescribir todo desde cero, usamos la **Herencia (`extends`)**: creamos una clase especializada (clase hija) que **hereda todo** de la clase base (clase madre) y añade habilidades exclusivas.

---

### 🪄 2. Las Dos Palabras Clave: `extends` y `super()`
- **`extends`**: Indica de qué clase madre queremos heredar (`class Mago extends Personaje`).
- **`super(...)`**: Llama al constructor de la clase madre para que ella se encargue de inicializar el `nombre` y el `hp`.

```js
class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

class Mago extends Personaje {
  constructor(nombre, hp, mana) {
    super(nombre, hp); // 1. Delega nombre y hp a la clase Personaje
    this.mana = mana;  // 2. Guarda su atributo especial exclusivo
  }

  lanzarHechizo(enemigo) {
    this.mana -= 20;   // Gasta 20 de mana
    enemigo.hp -= 40;  // Hace 40 de daño
  }
}
```

---

### ⚠️ Regla de Oro en Herencia
- ❌ **Usar `this` antes de `super()`:** En JavaScript es obligatorio llamar a `super(nombre, hp)` antes de usar `this.mana` en el constructor de una clase hija.

---

### 🎯 Tu Misión de Hoy:
1. Crea la clase `Mago` que herede de `Personaje` usando `extends Personaje`.
2. Su `constructor(nombre, hp, mana)` debe llamar a `super(nombre, hp)` y luego asignar `this.mana = mana;`.
3. Añade el método `lanzarHechizo(enemigo)` que reste `20` puntos a `this.mana` y reste `40` puntos a `enemigo.hp`.
$THEORY$,
    'logic',
    $CODE$class Personaje {
  constructor(nombre, hp) {
    this.nombre = nombre;
    this.hp = hp;
  }
}

// Crea la clase Mago que hereda de Personaje aquí abajo:
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
assert(typeof Mago === "function", "Debes declarar la clase 'Mago'.");
const m = new Mago("Gandalf", 100, 50);
const o = new Personaje("Orco", 50);
assert(m instanceof Personaje, "La instancia de Mago debe heredar de Personaje.");
assert(m.nombre === "Gandalf" && m.hp === 100 && m.mana === 50, "Mago debe inicializar nombre, hp y mana correctamente.");
m.lanzarHechizo(o);
assert(m.mana === 30, "Lanzar hechizo debe restar 20 de mana al mago (50 - 20 = 30).");
assert(o.hp === 10, "Lanzar hechizo debe restar 40 de hp al enemigo (50 - 40 = 10).");$TEST$,
    100,
    5
  );

END $$;
