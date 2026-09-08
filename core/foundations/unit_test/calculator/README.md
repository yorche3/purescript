# Calculator — PureScript

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **PureScript**, usando **Spago** como gestor de paquetes y **test-unit** (`Test.Unit`) como framework de pruebas unitarias.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`spago.yaml`](spago.yaml) | Configuración de **Spago 1.x**: dependencias y target de test (`Test.Main`). |
| [`src/Calculator.purs`](src/Calculator.purs) | Módulo `Calculator` con las 5 operaciones aritméticas. |
| [`test/CalculatorTest.purs`](test/CalculatorTest.purs) | 5 pruebas con `suite`/`test` y `Assert.equal`. |
| [`test/Main.purs`](test/Main.purs) | Punto de entrada de las pruebas (ejecuta la suite). |
| [`.gitignore`](.gitignore) | Ignora `output/`, `.spago/` y `node_modules/`. |

**Estructura de directorios esperada:**

```text
calculator/
├── spago.yaml                    # Configuración de Spago
├── .gitignore                    # Ignora output/ y .spago/
├── src/
│   └── Calculator.purs           # 5 operaciones aritméticas
├── test/
│   ├── Main.purs                 # Punto de entrada de las pruebas
│   └── CalculatorTest.purs       # 5 tests con Test.Unit
├── output/                       # JavaScript generado (no versionado)
└── .spago/                       # Package set descargado (no versionado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto usa **Spago** (gestor de paquetes de PureScript) y **test-unit** (`Test.Unit`), siguiendo el estilo de los proyectos del repositorio:

1. `Calculator` es un módulo con funciones puras `Int -> Int -> Int`; los bucles se expresan con helpers recursivos y `case`.
2. Cada prueba usa `suite`/`test` y verifica con `Assert.equal expected actual`.
3. `spago test` compila `src/` + `test/` y ejecuta el módulo `Test.Main`, que lanza la suite.
4. `multiplication`, `division` y `modulus` se implementan con las estrategias educativas de la especificación (sin usar los operadores `*`, `/` ni `mod` respectivamente).

**EN:** This project uses **Spago** (PureScript's package manager) and **test-unit** (`Test.Unit`), following the style of the repository's projects:

1. `Calculator` is a module with pure `Int -> Int -> Int` functions; loops are expressed with recursive helpers and `case`.
2. Each test uses `suite`/`test` and verifies with `Assert.equal expected actual`.
3. `spago test` compiles `src/` + `test/` and runs the `Test.Main` module, which launches the suite.
4. `multiplication`, `division` and `modulus` are implemented with the educational strategies from the specification (without using the `*`, `/` or `mod` operators respectively).

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `spago.yaml` — Configuración de Spago

**ES:** Declara el paquete, las dependencias y el target de test. `test-unit` va en `test.dependencies` (solo para pruebas).

**EN:** Declares the package, the dependencies, and the test target. `test-unit` goes under `test.dependencies` (test-only).

```yaml
package:
  name: calculator
  dependencies:
    - console
    - effect
    - prelude
  test:
    main: Test.Main
    dependencies:
      - test-unit
workspace:
  packageSet:
    registry: 80.8.1
  extraPackages: {}
```

### `src/Calculator.purs` — Módulo principal

| Operación | Implementación educativa |
| --------- | ------------------------ |
| `addition(a, b)` | Suma directa (`a + b`). |
| `subtraction(a, b)` | Resta directa (`a - b`). |
| `multiplication(a, b)` | Suma repetitiva: acumula `a`, `b` veces (no usa `*`). |
| `division(a, b)` | Resta repetitiva: resta `b` de `a` mientras `a >= b` (no usa `/`). |
| `modulus(a, b)` | Construida sobre `division` y `multiplication` (no usa `mod`). |

```purescript
module Calculator where

import Prelude

addition :: Int -> Int -> Int
addition a b = a + b

subtraction :: Int -> Int -> Int
subtraction a b = a - b

multiplication :: Int -> Int -> Int
multiplication a b = go b 0
  where
  go n acc = case n of
    0 -> acc
    _ -> go (n - 1) (addition acc a)

division :: Int -> Int -> Int
division a b = go a 0
  where
  go n q = case n < b of
    true -> q
    false -> go (subtraction n b) (addition q 1)

modulus :: Int -> Int -> Int
modulus a b = subtraction a (multiplication (division a b) b)
```

### `test/CalculatorTest.purs` y `test/Main.purs` — Pruebas unitarias (Test.Unit)

**ES:** Un `test` por operación, con los mismos casos del pseudocódigo de la especificación. `Test.Main` lanza la suite.

**EN:** One `test` per operation, with the same cases as the specification pseudocode. `Test.Main` launches the suite.

```purescript
module Test.CalculatorTest where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Calculator (addition, subtraction, multiplication, division, modulus)

main :: Effect Unit
main = runTest do
  suite "Calculator" do
    test "addition" do
      Assert.equal 5 (addition 2 3)
    test "subtraction" do
      Assert.equal 3 (subtraction 5 2)
    test "multiplication" do
      Assert.equal 12 (multiplication 3 4)
    test "division" do
      Assert.equal 3 (division 10 3)
    test "modulus" do
      Assert.equal 1 (modulus 10 3)
```

```purescript
module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.CalculatorTest as CalculatorTest

main :: Effect Unit
main = do
  log "🍝"
  CalculatorTest.main
```

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **PureScript** (`purs`, 0.15.x).
- **Spago** 1.x (`spago`).
- **Node.js** (`node`).

```bash
purs --version
spago --version
node --version
```

### Ejecutar las pruebas unitarias / Run tests

```bash
cd purescript/core/foundations/unit_test/calculator
spago test
```

### Salida esperada / Expected output

```text
🍝
- Suite: Calculator
  ✓ Passed: addition
  ✓ Passed: subtraction
  ✓ Passed: multiplication
  ✓ Passed: division
  ✓ Passed: modulus

All 5 tests passed!

✓ Test succeeded for package "calculator".
```

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** El proyecto no usa un `main` propio: el "punto de entrada" es `spago test`, que compila y ejecuta el módulo `Test.Main`. Por eso no se necesita el `run_tests` del pseudocódigo (la especificación lo pide solo si el framework no lo incluye).
- **EN:** The project has no `main` of its own: the "entry point" is `spago test`, which compiles and runs the `Test.Main` module. That's why the pseudocode's `run_tests` is not needed (the specification asks for it only if the framework doesn't include one).
- **ES:** `test-unit` es dependencia exclusiva de `test.dependencies`; la librería `Calculator` es pura (sin efectos) y solo usa `Prelude`.
- **EN:** `test-unit` is an exclusive `test.dependencies` dependency; the `Calculator` library is pure (no effects) and only uses `Prelude`.
- **ES:** Los bucles se escriben con helpers recursivos y `case`, el patrón idiomático en PureScript (que no tiene bucles imperativos).
- **EN:** Loops are written with recursive helpers and `case`, the idiomatic PureScript pattern (which has no imperative loops).
- **ES:** `division` no valida `b == 0` (fuera del alcance de este ejemplo, como indica la especificación).
- **EN:** `division` does not validate `b == 0` (out of scope for this example, as the specification states).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
