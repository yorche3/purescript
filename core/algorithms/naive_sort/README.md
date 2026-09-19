# Naive Sort — PureScript

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **PureScript**, con **Spago 1.x** como gestor de paquetes y **test-unit** (`Test.Unit`) como framework de pruebas unitarias.

Tres algoritmos de ordenación con coste $O(n^2)$: **selection sort**, **bubble sort** e **insertion sort**, todos ordenando de forma ascendente la lista recibida (`List Int`), sin bibliotecas de ordenamiento ni estructuras auxiliares.

La secuencia es **`Data.List`** —la lista *cons* inmutable de la biblioteca estándar— porque PureScript **no admite patrones cons sobre `Array`** y sus accesores del primero y el resto (`uncons`, `head`, `tail`) devuelven `Maybe`, el equivalente a `Option` que esta fase no usa. Con `List`, el recorrido se escribe con los patrones `x : xs` y `Nil`, igual que en **Haskell** y **Elm**.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`spago.yaml`](spago.yaml) | Configuración de **Spago 1.x**: dependencias, target de test y *package set*. |
| [`spago.lock`](spago.lock) | Resolución de dependencias generada por Spago (versionada). |
| [`src/NaiveSort.purs`](src/NaiveSort.purs) | Módulo `NaiveSort` — 3 funciones exportadas + 3 helpers privados. |
| [`test/NaiveSortTests.purs`](test/NaiveSortTests.purs) | Suite única: 3 tests (7 casos cada uno). |
| [`test/Main.purs`](test/Main.purs) | Punto de entrada de las pruebas. |
| [`.gitignore`](.gitignore) | Ignora `output/`, `.spago/` y `node_modules/`. |

**Estructura de directorios esperada:**

```text
naive_sort/
├── spago.yaml                    # Configuración de Spago
├── spago.lock                    # Resolución de dependencias
├── .gitignore                    # Ignora output/, .spago/ y node_modules/
├── src/
│   └── NaiveSort.purs            # 3 funciones + 3 helpers no exportados
├── test/
│   ├── Main.purs                 # Punto de entrada de las pruebas
│   └── NaiveSortTests.purs       # 3 tests, 7 casos cada uno
├── output/                       # JavaScript generado (no versionado)
└── .spago/                       # Package set descargado (no versionado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Sigue el mismo patrón que [`numbers`](../../foundations/numbers/) y [`calculator`](../../foundations/unit_test/calculator/): módulo en `src/`, suites en `test/` y **test-unit**. Los tres helpers (`pickMin`, `bubblePass`, `insert`) quedan **privados** al no aparecer en la lista de exportación del módulo.

**EN:** Follows the same pattern as [`numbers`](../../foundations/numbers/) and [`calculator`](../../foundations/unit_test/calculator/): a module in `src/`, suites in `test/` and **test-unit**. The three helpers (`pickMin`, `bubblePass`, `insert`) stay **private** by not appearing in the module's export list.

**Combinación aplicada:** algoritmo iterativo en el pseudocódigo, sin bucles en PureScript → **1 suite × 3 tests = 3 tests (21 casos)**.

**Applied combination:** iterative algorithm in the pseudocode, no loops in PureScript → **1 suite × 3 tests = 3 tests (21 cases)**.

### Inicialización / Initialization

**ES:** `spago init` genera `spago.yaml`, `.gitignore`, `.purs-repl`, un `src/Main.purs` de ejemplo con `main :: Effect Unit` y un `test/Test/Main.purs`, con el nombre del paquete tomado del directorio, solo las dependencias `console`, `effect` y `prelude`, `test.dependencies` vacío y el *package set* `81.1.0`. Se sustituyó por la convención ya homologada de `numbers/`: el paquete lleva el sufijo `-algorithms` para no colisionar con el paquete `purescript-numbers` del que depende `test-unit`, se añaden `lists` y `foldable-traversable`, el *package set* se fija en `80.8.1` (la versión ya verificada en `numbers/`), se declara `test-unit` como dependencia de test y se elimina el `src/Main.purs` de ejemplo, porque el módulo es una biblioteca.

**EN:** `spago init` generates `spago.yaml`, `.gitignore`, `.purs-repl`, a sample `src/Main.purs` with `main :: Effect Unit` and a `test/Test/Main.purs`, taking the package name from the directory, with only the `console`, `effect` and `prelude` dependencies, an empty `test.dependencies` and the `81.1.0` *package set*. It was replaced by the already homologated `numbers/` convention: the package carries the `-algorithms` suffix so it does not collide with the `purescript-numbers` package that `test-unit` depends on, `lists` and `foldable-traversable` are added, the *package set* is pinned to `80.8.1` (the version already verified in `numbers/`), `test-unit` is declared as a test dependency, and the sample `src/Main.purs` is removed because the module is a library.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `spago.yaml` — Configuración de Spago

**ES:** El paquete se llama `naive-sort-algorithms` (no `naive-sort`, por el mismo motivo que `numbers-algorithms`). `test-unit` va en `test.dependencies`; el paquete no necesita declarar sus propios módulos.

**EN:** The package is named `naive-sort-algorithms` (not `naive-sort`, for the same reason as `numbers-algorithms`). `test-unit` goes under `test.dependencies`; the package does not need to declare its own modules.

```yaml
package:
  name: naive-sort-algorithms
  dependencies:
    - console
    - effect
    - foldable-traversable
    - lists
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

### `src/NaiveSort.purs` — Implementación

**ES:** Las tres funciones reciben una `List Int` y devuelven una lista nueva. Extracto de `selectionSort` y su helper:

**EN:** All three functions take a `List Int` and return a new list. Excerpt from `selectionSort` and its helper:

```purescript
selectionSort :: List Int -> List Int
selectionSort arr = case arr of
  Nil -> Nil
  x : Nil -> x : Nil
  x : xs ->
    let
      Tuple minVal rest = pickMin x xs
    in
      minVal : selectionSort rest
```

### Suites de pruebas — Test.Unit

**ES:** Una única suite con un `test` por función. Los 7 casos viven en una lista de registros compartida y un único helper los recorre para cualquier función:

**EN:** A single suite with one `test` per function. The 7 cases live in a shared list of records and a single helper walks them for any function:

```purescript
assertAllCases :: (List Int -> List Int) -> String -> Aff Unit
assertAllCases sort algorithm =
  for_ cases \testCase -> do
    let
      actual = sort testCase.input
    Assert.assert
      ( algorithm <> " should sort " <> testCase.description
          <> ": expected "
          <> show testCase.expected
          <> " but got "
          <> show actual
      )
      (testCase.expected == actual)
```

**ES:** El helper recibe la función como valor, lo que permite recorrer los casos una sola vez en lugar de repetir las aserciones tres veces.

**EN:** The helper receives the function as a value, which lets it walk the cases once instead of repeating the assertions three times.

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

### Verificación estática / Static check

**ES:** `purs` compila con los avisos activados, así que compilar ya es la verificación estática; el resumen final muestra el recuento por origen (`Src`, `Lib`, `All`):

**EN:** `purs` compiles with warnings enabled, so building already is the static check; the final summary shows the counts per origin (`Src`, `Lib`, `All`):

```bash
cd purescript/core/algorithms/naive_sort
spago build
```

### Ejecutar las pruebas unitarias / Run tests

```bash
cd purescript/core/algorithms/naive_sort
spago test
```

### Salida esperada / Expected output

```text
           Src   Lib   All
Warnings     0     0     0
Errors       0     0     0
✓ Build succeeded.
Running tests for package: naive-sort-algorithms
🍝
- Suite: naive_sort
  ✓ Passed: selection_sort
  ✓ Passed: bubble_sort
  ✓ Passed: insertion_sort
All 3 tests passed!
✓ Test succeeded for package "naive-sort-algorithms".
```

> **ES:** 3 tests en total (uno por algoritmo); los 21 casos viven como `Assert.assert` dentro de ellos (7 por algoritmo), todos pasando.
> **EN:** 3 tests in total (one per algorithm); the 21 cases live as `Assert.assert` checks within them (7 per algorithm), all passing.

> **ES:** Al compilar desde cero, la propia biblioteca `test-unit-17.0.0` emite 15 avisos sobre sus ficheros (10 `UnusedName` y 5 `UnusedDeclaration`, en `.spago/p/test-unit-17.0.0/src/Test/Unit.purs` y `Test/Unit/Assert.purs`); no provienen de este módulo. La columna `Src` —la que cuenta el código propio— marca 0.
> **EN:** When building from scratch, the `test-unit-17.0.0` library itself emits 15 warnings about its own files (10 `UnusedName` and 5 `UnusedDeclaration`, in `.spago/p/test-unit-17.0.0/src/Test/Unit.purs` and `Test/Unit/Assert.purs`); they do not come from this module. The `Src` column — the one counting our own code — reads 0.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Algoritmo | Función | Helper | Entrada ordenada | Entrada invertida |
|-----------|---------|--------|:----------------:|:-----------------:|
| Selection sort | `selectionSort` | `pickMin` | $O(n^2)$ | $O(n^2)$ |
| Bubble sort | `bubbleSort` | `bubblePass` | $O(n)$ (salida temprana) | $O(n^2)$ |
| Insertion sort | `insertionSort` | `insert` | $O(n)$ | $O(n^2)$ |

**ES:** Cada algoritmo tiene su propia estrategia y su propio helper. No comparten ninguno.

**EN:** Each algorithm has its own strategy and its own helper. They share none.

### Casos cubiertos / Covered cases

| # | Entrada | Salida esperada |
|:-:|---------|-----------------|
| 1 | `5 : 2 : 9 : 1 : 5 : 6 : Nil` | `1 : 2 : 5 : 5 : 6 : 9 : Nil` |
| 2 | `1 : 2 : 3 : 4 : 5 : Nil` | `1 : 2 : 3 : 4 : 5 : Nil` |
| 3 | `5 : 4 : 3 : 2 : 1 : Nil` | `1 : 2 : 3 : 4 : 5 : Nil` |
| 4 | `7 : 7 : 7 : 7 : Nil` | `7 : 7 : 7 : 7 : Nil` |
| 5 | `3 : (-1) : 4 : (-5) : 0 : Nil` | `(-5) : (-1) : 0 : 3 : 4 : Nil` |
| 6 | `42 : Nil` | `42 : Nil` |
| 7 | `Nil` | `Nil` |

**ES:** Son los 7 casos obligatorios de la especificación, escritos como listas *cons*. El **caso nulo se omite** (ver la nota correspondiente).

**EN:** These are the 7 mandatory cases from the specification. The **null case is omitted** (see the corresponding note).

---

## 📝 Notas de implementación / Implementation Notes

### 🧬 Listas inmutables: se devuelve una lista nueva / Immutable lists: a new list is returned

**ES:** La especificación pide el ordenamiento *in-place*, pero las listas de PureScript son **inmutables** y el lenguaje no tiene bucles ni asignación, así que ningún algoritmo puede reordenar la secuencia recibida. La especificación admite explícitamente la alternativa («de forma in-place o retornando una copia ordenada según el paradigma del lenguaje»), de modo que las tres funciones construyen y devuelven una **lista nueva** con `:` y el valor de entrada queda intacto. Por eso los tests **no necesitan copiar** el fixture: es imposible que un caso contamine al siguiente.

**EN:** The specification asks for an *in-place* sort, but PureScript lists are **immutable** and the language has no loops or assignment, so no algorithm can reorder the received sequence. The specification explicitly allows the alternative ("in-place or returning a sorted copy depending on the language paradigm"), so all three functions build and return a **new list** with `:` and the input one is left untouched. That is why the tests **need no copy** of the fixture: a case cannot contaminate the next one.

### 🧾 Por qué `List` y no `Array` / Why `List` and not `Array`

**ES:** `Array` es la secuencia contigua de PureScript, pero no permite obtener el primero y el resto sin pasar por un tipo opcional: el compilador **rechaza el patrón cons** sobre un array (`Operator Data.Array.(:) cannot be used in a pattern as it is an alias for function Data.Array.cons`, error `InvalidOperatorInBinder`), sus accesores (`uncons`, `head`, `tail`, `index`, `last`, `init`, `find`) devuelven `Maybe`, y la única alternativa sin `Maybe` es `Data.Array.Partial`, que son funciones **parciales** y exigen `unsafePartial`. `Data.List` sí tiene el constructor cons como dato (`x : xs`, `Nil`) y es la secuencia recursiva idiomática, así que el módulo trabaja con `List Int` y recorre los elementos con patrones, como en **Haskell** y **Elm**: es la misma elección que ya tomaron los demás lenguajes funcionales homologados de esta fase (`[Int]` en Haskell y F#, `List` en Elm, Erlang, Elixir y Gleam).

**EN:** `Array` is PureScript's contiguous sequence, but it cannot provide the first element and the rest without going through an optional type: the compiler **rejects the cons pattern** on an array (`Operator Data.Array.(:) cannot be used in a pattern as it is an alias for function Data.Array.cons`, error `InvalidOperatorInBinder`), its accessors (`uncons`, `head`, `tail`, `index`, `last`, `init`, `find`) return `Maybe`, and the only `Maybe`-free alternative is `Data.Array.Partial`, which are **partial** functions requiring `unsafePartial`. `Data.List` does have the cons constructor as data (`x : xs`, `Nil`) and is the idiomatic recursive sequence, so the module works with `List Int` and walks the elements with patterns, as in **Haskell** and **Elm**: the same choice already made by the other homologated functional languages of this phase (`[Int]` in Haskell and F#, `List` in Elm, Erlang, Elixir and Gleam).

### 🚫 Caso nulo omitido / Null case omitted

**ES:** La especificación pide devolver un indicador de fallo si la entrada es nula o inválida. PureScript **no tiene `null`** y una `List Int` no admite una entrada nula, así que el caso no es representable en la firma. La representación alternativa que menciona la especificación (`Option`/`Maybe` vacío o `Result` de error) queda fuera de alcance porque esta fase todavía no introduce ese tipo. Se conservan los 7 casos obligatorios, y la lista vacía se prueba como caso 7.

**EN:** The specification asks for a failure indicator when the input is null or invalid. PureScript **has no `null`** and a `List Int` does not admit a null input, so the case is not representable in the signature. The alternative representation the specification mentions (empty `Option`/`Maybe` or error `Result`) is out of scope because this phase does not introduce that type yet. The 7 mandatory cases are kept, and the empty list is tested as case 7.

### ➿ Sin bucles: recursión estructural / No loops: structural recursion

**ES:** PureScript no tiene bucles imperativos, así que los tres algoritmos se escriben con **recursión estructural** sobre la lista, usando los patrones cons `x : xs` y `Nil` y las guardas de caso base `Nil`/`x : Nil`, que son el `if n <= 1 return arr` del pseudocódigo: así no se hace trabajo de más. No se usan `uncons` ni ningún tipo opcional.

**EN:** PureScript has no imperative loops, so all three algorithms are written with **structural recursion** over the list, using the `x : xs` and `Nil` cons patterns plus the `Nil`/`x : Nil` base-case matches, which are the pseudocode's `if n <= 1 return arr`: no extra work is done. Neither `uncons` nor any optional type is used.

### 🔁 `bubblePass` y la bandera de intercambio / `bubblePass` and the swap flag

**ES:** `bubbleSort` mantiene la optimización de salida temprana que exige la especificación, pero en lugar de una variable `swapped` la bandera viaja como **segundo componente del `Tuple`** que devuelve `bubblePass`: la pasada compara pares adyacentes (`x > y`), arrastra el mayor al final y devuelve `true` si intercambió algo. El bucle exterior solo vuelve a iterar si la bandera es `true`, que es el `if not swapped then break` del pseudocódigo. Una lista ya ordenada se resuelve en una sola pasada, de modo que el mejor caso es $O(n)$.

**EN:** `bubbleSort` keeps the early-exit optimisation the specification requires, but instead of a `swapped` variable the flag travels as the **second component of the `Tuple`** returned by `bubblePass`: the pass compares adjacent pairs (`x > y`), pushes the maximum to the end and returns `true` if it swapped anything. The outer loop only iterates again when the flag is `true`, which is the pseudocode's `if not swapped then break`. An already sorted list is solved in a single pass, so the best case is $O(n)$.

### 🔀 Estabilidad de `insertionSort` / `insertionSort` stability

**ES:** `insert` coloca el elemento delante del primer mayor o igual (`x <= y`), de modo que los elementos iguales conservan su orden relativo y `insertionSort` es estable. El caso 1 (`5 : 2 : 9 : 1 : 5 : 6 : Nil`, con dos cincos) se beneficia de ello, aunque la comparación de los tests se hace sobre valores y no sobre identidad.

**EN:** `insert` places the element before the first greater-or-equal one (`x <= y`), so equal elements keep their relative order and `insertionSort` is stable. Case 1 (`5 : 2 : 9 : 1 : 5 : 6 : Nil`, with two fives) benefits from it, although the tests compare values rather than identity.

### 🏷️ Naming y visibilidad / Naming and visibility

**ES:** Las funciones usan `camelCase` (`selectionSort`), que es la convención de PureScript, mientras que la especificación las nombra en `snake_case` (`selection_sort`). El nombre de la especificación se conserva como **nombre del test**, de forma que el reporte sigue mostrando `selection_sort`, `bubble_sort` e `insertion_sort`. Los helpers `pickMin`, `bubblePass` e `insert` no se exportan, así que la API pública son exactamente las tres funciones del contrato, y el parámetro de las tres se llama `arr`, el nombre de la documentación. No hay `main()` en el módulo: el punto de entrada es el `main` de `Test.Main`.

**EN:** Functions use `camelCase` (`selectionSort`), which is PureScript's convention, while the specification names them in `snake_case` (`selection_sort`). The specification name is preserved as the **test name**, so the report still shows `selection_sort`, `bubble_sort` and `insertion_sort`. The `pickMin`, `bubblePass` and `insert` helpers are not exported, so the public API is exactly the three contract functions, and all three name their parameter `arr`, the documentation's name. There is no `main()` in the module: the entry point is `Test.Main`'s `main`.

### 🧪 Estructura de los tests / Test structure

**ES:** Una única suite con 3 `test`. Dos detalles importantes: (1) `Assert.equal` **no admite un mensaje**, así que la comparación usa `Assert.assert :: String -> Boolean -> Aff Unit`, con el mensaje **primero**, y el texto del contrato se compone con los valores incluidos; (2) el helper recorre los 7 casos con `for_`, y al primer fallo la aserción lanza y el test se detiene.

**EN:** A single suite with 3 `test`s. Two important details: (1) `Assert.equal` **takes no message**, so the comparison uses `Assert.assert :: String -> Boolean -> Aff Unit`, with the message **first**, and the contract text is composed with the values embedded; (2) the helper walks the 7 cases with `for_`, and on the first failure the assertion throws and the test stops.

```purescript
    Assert.assert
      ( algorithm <> " should sort " <> testCase.description
          <> ": expected "
          <> show testCase.expected
          <> " but got "
          <> show actual
      )
      (testCase.expected == actual)
```

Un fallo se ve así:

```text
  ☠ Failed: selection_sort because selection_sort should sort an unsorted array: expected (1 : 2 : 5 : 5 : 6 : 9 : Nil) but got (9 : 6 : 5 : 5 : 2 : 1 : Nil)
```

### 📍 Desviaciones respecto a la ubicación esperada / Deviations from the expected location

| Especificación | Implementación | Motivo |
|----------------|----------------|--------|
| `src/naive_sort.ext` | `src/NaiveSort.purs` | Los módulos de PureScript van en `PascalCase` y el fichero debe llamarse como el módulo, igual que `Numbers.purs` en `numbers/`. |
| `test/naive_sort_test.ext` | `test/NaiveSortTests.purs` | La convención de `numbers/` es `PascalCase` en plural (`RecursiveTests.purs`, `IterativeTests.purs`). |
| `test/run_tests.ext` | `test/Main.purs` | Spago ejecuta el `main` declarado en `test.main` (`Test.Main`), que lanza la suite. Ni `numbers/` ni `calculator/` incluyen otro runner. |

**ES:** Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para consultar las demás versiones.

**EN:** This project is also implemented in other languages. Explore the main repository to see the other versions.

---

*[← Volver a Algoritmos Puros](../README.md) · [↑ Volver a Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
