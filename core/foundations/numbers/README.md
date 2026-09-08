# Numbers — PureScript

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **PureScript**, usando **Spago** como gestor de paquetes y **test-unit** (`Test.Unit`) como framework de pruebas unitarias.

Tres enfoques de implementación para los mismos 5 algoritmos: **recursivo directo** (`Rec`), **recursivo con acumulador** (`Acc`) e **iterativo** (`Ite`).

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`spago.yaml`](spago.yaml) | Configuración de **Spago 1.x**: dependencias (`arrays`, `foldable-traversable`, `tuples`…) y target de test. |
| [`src/Numbers.purs`](src/Numbers.purs) | Módulo `Numbers` — 15 funciones (3 enfoques × 5 algoritmos); los helpers `_help` no se exportan. |
| [`test/RecursiveTests.purs`](test/RecursiveTests.purs) | Suite recursiva: 5 tests (11 casos). |
| [`test/IterativeTests.purs`](test/IterativeTests.purs) | Suite iterativa: 5 tests (11 casos). |
| [`test/Main.purs`](test/Main.purs) | Punto de entrada de las pruebas (lanza ambas suites). |
| [`.gitignore`](.gitignore) | Ignora `output/`, `.spago/` y `node_modules/`. |

**Estructura de directorios esperada:**

```text
numbers/
├── spago.yaml                    # Configuración de Spago
├── .gitignore                    # Ignora output/ y .spago/
├── src/
│   └── Numbers.purs              # 15 funciones + helpers no exportados
├── test/
│   ├── Main.purs                 # Punto de entrada de las pruebas
│   ├── RecursiveTests.purs       # Tests recursivos (5 tests, 11 casos)
│   └── IterativeTests.purs       # Tests iterativos (5 tests, 11 casos)
├── output/                       # JavaScript generado (no versionado)
└── .spago/                       # Package set descargado (no versionado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Sigue el mismo patrón que [`calculator`](../unit_test/calculator/): módulo en `src/`, suites en `test/` y **test-unit**. Las 15 funciones se organizan en 3 grupos por enfoque:

| Enfoque | Sufijo | Ejemplo | ¿Tiene tests directos? |
| ------- | ------ | ------- | :---------------------: |
| Recursivo directo | `...Rec` | `fibonacciRec(n)` | ✅ Sí |
| Recursivo con acumulador | `...Acc` | `fibonacciAcc(n)` | ❌ No (ver nota TCO) |
| Iterativo | `...Ite` | `fibonacciIte(n)` | ✅ Sí |

**EN:** Follows the same pattern as [`calculator`](../unit_test/calculator/): a module in `src/`, suites in `test/`, and **test-unit**. The 15 functions are organized into 3 groups by approach:

| Approach | Suffix | Example | Direct tests? |
| -------- | ------ | ------- | :-----------: |
| Direct recursion | `...Rec` | `fibonacciRec(n)` | ✅ Yes |
| Accumulator recursion | `...Acc` | `fibonacciAcc(n)` | ❌ No (see TCO note) |
| Iterative | `...Ite` | `fibonacciIte(n)` | ✅ Yes |

**Combinación aplicada:** TCO ❌ + iteración ✅ (combinadores `fold`) → `_rec` + `_ite` = **2 suites × 5 tests = 10 tests (22 casos)**.

**Applied combination:** No TCO + iteration ✅ (`fold` combinators) → `_rec` + `_ite` = **2 suites × 5 tests = 10 tests (22 cases)**.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `spago.yaml` — Configuración de Spago

**ES:** El paquete se llama `numbers-algorithms` (no `numbers`, para no colisionar con el paquete `purescript-numbers` que usa `test-unit`). `test-unit` y `numbers` van en `test.dependencies`.

**EN:** The package is named `numbers-algorithms` (not `numbers`, to avoid colliding with the `purescript-numbers` package used by `test-unit`). `test-unit` and `numbers` go under `test.dependencies`.

```yaml
package:
  name: numbers-algorithms
  dependencies:
    - arrays
    - console
    - effect
    - foldable-traversable
    - prelude
    - tuples
  test:
    main: Test.Main
    dependencies:
      - test-unit
      - numbers
workspace:
  packageSet:
    registry: 80.8.1
  extraPackages: {}
```

### `src/Numbers.purs` — Implementación

**ES:** Cada algoritmo tiene 3 implementaciones en un único archivo. Los helpers `_help` quedan **privados** al no aparecer en la lista de exportación del módulo. Por ejemplo, `fibonacci`:

**EN:** Each algorithm has 3 implementations in a single file. The `_help` helpers stay **private** by not appearing in the module's export list. For example, `fibonacci`:

```purescript
-- Enfoque recursivo directo / Direct recursion
fibonacciRec :: Int -> Int
fibonacciRec n = case n <= 1 of
  true -> n
  false -> fibonacciRec (n - 1) + fibonacciRec (n - 2)

-- Enfoque con acumulador / Accumulator recursion
fibonacciAcc :: Int -> Int
fibonacciAcc n = fibonacciAccHelp n 0 1

fibonacciAccHelp :: Int -> Int -> Int -> Int
fibonacciAccHelp n acc2 acc1 = case n <= 0 of
  true -> acc2
  false -> case n <= 2 of
    true -> acc1 + acc2
    false -> fibonacciAccHelp (n - 1) acc1 (acc1 + acc2)

-- Enfoque iterativo / Iterative
fibonacciIte :: Int -> Int
fibonacciIte n = case n <= 1 of
  true -> n
  false -> snd (foldl fibStep (Tuple 0 1) (range 2 n))
  where
  fibStep (Tuple acc2 acc1) _ = Tuple acc1 (acc1 + acc2)
```

| Algoritmo | `Rec` | `Acc` | `Ite` |
| --------- | ----- | ----- | ----- |
| `sumOfFirstN` | `n + sumRec(n-1)` | helper con `acc + n` | `foldl` sobre `range 1 n` |
| `factorial` | `n * factRec(n-1)` | helper con `acc * n` | `foldl` sobre `range 2 n` |
| `fibonacci` | `fibRec(n-1) + fibRec(n-2)` | helper con `acc2, acc1` | `foldl` con `Tuple` de estado |
| `greatestCommonDivisor` | Euclides recursivo | helper (Euclides) | helper de cola (idioma de bucle) |
| `leastCommonMultiple` | `(a*b) / gcdRec` | `(a*b) / gcdAcc` | `(a*b) / gcdIte` |

### Suites de pruebas — Test.Unit

**ES:** Dos suites, una por enfoque probado. Cada suite agrupa un `test` por función (5 por suite); los 11 casos del pseudocódigo viven como `Assert.equal` dentro de ellos (22 en total).

**EN:** Two suites, one per tested approach. Each suite groups one `test` per function (5 per suite); the specification pseudocode's 11 cases live as `Assert.equal`s within them (22 in total).

```purescript
test "fibonacciRec" do
  Assert.equal 0 (fibonacciRec 0)
  Assert.equal 1 (fibonacciRec 1)
  Assert.equal 8 (fibonacciRec 6)
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
cd purescript/core/foundations/numbers
spago test
```

### Salida esperada / Expected output

```text
🍝
- Suite: Numbers recursive
  ✓ Passed: sumOfFirstNRec
  ✓ Passed: factorialRec
  ✓ Passed: fibonacciRec
  ✓ Passed: greatestCommonDivisorRec
  ✓ Passed: leastCommonMultipleRec

All 5 tests passed!
- Suite: Numbers iterative
  ✓ Passed: sumOfFirstNIte
  ✓ Passed: factorialIte
  ✓ Passed: fibonacciIte
  ✓ Passed: greatestCommonDivisorIte
  ✓ Passed: leastCommonMultipleIte

All 5 tests passed!

✓ Test succeeded for package "numbers-algorithms".
```

> **ES:** 10 tests en total (5 por suite); los 22 casos viven como `Assert.equal` dentro de ellos, todos pasando.
> **EN:** 10 tests in total (5 per suite); the 22 cases live as `Assert.equal`s within them, all passing.

---

## 🔁 Sobre recursión con acumulador y Tail Call Optimization (TCO)

**ES:**
Tail recursion ocurre cuando la llamada recursiva es la última acción que ejecuta una función; después de la llamada no hay más instrucciones. La recursión con acumulador consigue esto pasando el estado previo como parámetro, sin dejar trabajo pendiente en la pila.

En PureScript, **no se garantiza TCO**: el compilador emite JavaScript y no garantiza la eliminación de llamadas de cola (V8 tampoco implementa *proper tail calls*), por lo que una recursión profunda puede desbordar la pila. La versión con acumulador se conserva únicamente con fines educativos, como puente conceptual entre la recursión directa (`_rec`) y la versión iterativa (`_ite`). Como no hay un beneficio práctico de rendimiento garantizado, **no se desarrollan pruebas unitarias específicas para las funciones `_acc`**. Su comportamiento queda validado a través de las suites recursiva e iterativa, que ejercitan los mismos resultados.

**EN:**
Tail recursion occurs when the recursive call is the last action executed by a function; after the call there are no more instructions. Accumulator recursion achieves this by passing the previous state as a parameter, leaving no pending work on the stack.

In PureScript, **TCO is not guaranteed**: the compiler emits JavaScript and does not guarantee tail-call elimination (V8 does not implement *proper tail calls* either), so deep recursion can overflow the stack. The accumulator version is kept purely for educational purposes, as a conceptual bridge between direct recursion (`_rec`) and the iterative version (`_ite`). Since there is no guaranteed performance benefit, **no dedicated unit tests are written for the `_acc` functions**. Their behavior is validated through the recursive and iterative suites, which exercise the same results.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** El proyecto no usa un `main` propio: el "punto de entrada" es `spago test`, que compila y ejecuta el módulo `Test.Main`. Por eso no se necesita el `run_tests` del pseudocódigo (la especificación lo pide solo si el framework no lo incluye).
- **EN:** The project has no `main` of its own: the "entry point" is `spago test`, which compiles and runs the `Test.Main` module. That's why the pseudocode's `run_tests` is not needed (the specification asks for it only if the framework doesn't include one).
- **ES:** PureScript no tiene bucles imperativos: `_ite` usa el combinador `foldl` sobre `range` (iteración explícita) y, para el MCD, recursión de cola como idioma de bucle.
- **EN:** PureScript has no imperative loops: `_ite` uses the `foldl` combinator over `range` (explicit iteration) and, for GCD, tail recursion as the loop idiom.
- **ES:** Los helpers `_help` no se exportan (quedan fuera de la lista de exportación), por lo que son privados del módulo.
- **EN:** The `_help` helpers are not exported (excluded from the export list), so they are private to the module.
- **ES:** `Int / Int` en PureScript es división entera, por lo que el MCM es exacto; `mod` es euclidiano (correcto para operandos positivos).
- **EN:** `Int / Int` in PureScript is integer division, so LCM is exact; `mod` is Euclidean (correct for positive operands).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
