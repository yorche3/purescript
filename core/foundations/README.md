# 🚀 Fundamentos / Foundations — PureScript

Implementación de los ejercicios de la sección [Fundamentos / Foundations](https://yorche3.github.io/programming_languages/core/foundations/) del repositorio principal en **PureScript**.

> **ES:** Por la naturaleza del lenguaje (compila a JavaScript y necesita un gestor de paquetes), los proyectos usan la configuración minimalista de **Spago 1.x**: un `spago.yaml` y un módulo fuente (o suites `test/` para los módulos con pruebas).
> **EN:** Given the language's nature (it compiles to JavaScript and needs a package manager), projects use the minimal **Spago 1.x** configuration: one `spago.yaml` and one source module (or `test/` suites for the modules with tests).

---

## 📖 Descripción / Description

**ES:** Esta sección reúne los conceptos esenciales para empezar a trabajar con **PureScript**. Cubre desde los programas más básicos (`Hello, World!` y `Hello, User!`) hasta la implementación de una calculadora con pruebas unitarias y algoritmos numéricos en tres enfoques progresivos (recursivo directo, recursivo con acumulador e iterativo).

**EN:** This section brings together the essential concepts to start working with **PureScript**. It covers everything from the most basic programs (`Hello, World!` and `Hello, User!`) to the implementation of a calculator with unit tests and numerical algorithms in three progressive approaches (direct recursion, accumulator recursion, and iterative).

---

## 📁 Estructura / Structure

```text
purescript/
└── core/
    └── foundations/
        ├── README.md              # Este archivo / This file
        ├── helloworld/            # 01_Hello_World — Primer programa
        │   ├── spago.yaml
        │   ├── src/Main.purs
        │   └── README.md
        ├── hellouser/             # 02_Hello_User — Entrada y salida
        │   ├── spago.yaml
        │   ├── src/Main.purs
        │   └── README.md
        ├── unit_test/
        │   └── calculator/        # 03_Unit_Test_Calculator — Pruebas unitarias
        │       ├── spago.yaml
        │       ├── src/Calculator.purs
        │       ├── test/
        │       │   ├── Main.purs
        │       │   └── CalculatorTest.purs
        │       └── README.md
        └── numbers/               # 04_Numbers — Algoritmos numéricos
            ├── spago.yaml
            ├── src/Numbers.purs
            ├── test/
            │   ├── Main.purs
            │   ├── RecursiveTests.purs
            │   └── IterativeTests.purs
            └── README.md
```

---

## 🔢 Progresión / Progression

| Especificación | Proyecto | Conceptos | Tests | Dependencias externas |
| -------------- | -------- | --------- | :---: | :-------------------: |
| [`01_Hello_World`](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | [`helloworld/`](helloworld/) | `main :: Effect Unit`, `Effect.Console.log`, Spago | — | ❌ Solo paquetes del registry |
| [`02_Hello_User`](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | [`hellouser/`](hellouser/) | `question` (continuación), `<>`, `Node.ReadLine` | — | ❌ Solo paquetes del registry |
| [`03_Unit_Test_Calculator`](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | [`unit_test/calculator/`](unit_test/calculator/) | Test.Unit, `suite`/`test`, `Assert.equal`, helpers con `case` | 5 | ✅ test-unit (solo test) |
| [`04_Numbers`](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) | [`numbers/`](numbers/) | Recursión, acumuladores, `foldl`, `Tuple`, TCO | 10 | ✅ test-unit (solo test) |

---

## 🛠️ Enfoque general / General Approach

**ES:** Los proyectos en esta sección siguen un patrón progresivo:

1. **Hello World** y **Hello User**: Un módulo `Main` con `main :: Effect Unit`, ejecutado con `spago run`. Configuración mínima en `spago.yaml`.
2. **Calculator**: Primer proyecto con suite de pruebas (**test-unit**). Introduce la separación `src/` + `test/` y `spago test` como punto de entrada.
3. **Numbers**: Expande el patrón de Calculator a dos suites de prueba (una por enfoque probado). PureScript **no garantiza TCO** (compila a JS), por lo que `_acc` se conserva como puente didáctico sin pruebas propias: `_rec` + `_ite` = 10 tests (22 casos).

**EN:** The projects in this section follow a progressive pattern:

1. **Hello World** and **Hello User**: A `Main` module with `main :: Effect Unit`, run with `spago run`. Minimal configuration in `spago.yaml`.
2. **Calculator**: First project with a test suite (**test-unit**). Introduces the `src/` + `test/` separation and `spago test` as the entry point.
3. **Numbers**: Expands the Calculator pattern to two test suites (one per tested approach). PureScript **does not guarantee TCO** (compiles to JS), so `_acc` is kept as an educational bridge without dedicated tests: `_rec` + `_ite` = 10 tests (22 cases).

---

## 🚀 Ejecución rápida / Quick Start

### Hello World

```bash
cd purescript/core/foundations/helloworld
spago run
```

### Hello User

```bash
cd purescript/core/foundations/hellouser
spago run
```

### Calculator (pruebas)

```bash
cd purescript/core/foundations/unit_test/calculator
spago test
```

### Numbers (pruebas)

```bash
cd purescript/core/foundations/numbers
spago test
```

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
