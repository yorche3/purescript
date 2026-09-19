# Algorithms Pure — PureScript

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **PureScript**: ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan sobre **listas** (`Data.List`, tipo `List`), que en PureScript **son inmutables**, **se recorren recursivamente con patrones cons** (no hay bucles ni asignación) y **no admiten `null`**.

---

## 📂 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `spago test` + test-unit | 3 | ✅ |

---

## 📁 Estructura / Structure

```text
algorithms/
└── naive_sort/                      # 05_Naive_Sort
    ├── spago.yaml                   # Configuración de Spago
    ├── spago.lock                   # Resolución de dependencias (versionada)
    ├── .gitignore                   # Ignora output/, .spago/ y node_modules/
    ├── src/
    │   └── NaiveSort.purs           # 3 funciones del contrato + 3 helpers
    ├── test/
    │   ├── Main.purs                # Punto de entrada de las pruebas
    │   └── NaiveSortTests.purs      # 3 tests × 7 casos
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | PureScript 0.15.x compilado a JavaScript y ejecutado con Node.js |
| **CLI** | `spago test` |
| **Gestor de paquetes** | Spago 1.x, con el *package set* del registro fijado en `80.8.1` (la versión ya verificada en `foundations/numbers/`) |
| **Andamiaje** | `spago init` genera `spago.yaml`, `.gitignore`, `.purs-repl` y un `src/Main.purs` de ejemplo; se sustituye por la convención de [`foundations/numbers/`](../foundations/numbers/) |
| **Framework de tests** | test-unit (`Test.Unit`), declarado en `test.dependencies` |
| **Runner** | `test/Main.purs` (módulo `Test.Main`), declarado como `test.main` en `spago.yaml`; no hay fichero aparte |
| **Separación** | `src/` (módulos) ↔ `test/` (suites y punto de entrada) |
| **Nombre del paquete** | Sufijo `-algorithms` (`naive-sort-algorithms`), para no colisionar con el paquete `purescript-numbers` del que depende `test-unit` |
| **Secuencia** | `Data.List` (`List Int`), no `Array`: el compilador **rechaza el patrón cons sobre `Array`** (`InvalidOperatorInBinder`) y sus accesores (`uncons`, `head`, `tail`, `index`) devuelven `Maybe`, el `Option` que esta fase no usa |
| **Iteración** | Recursión estructural con los patrones cons `x : xs` y `Nil`; PureScript no tiene bucles ni asignación |
| **Indexación** | No aplica: se trabaja con patrones cons (cabeza y cola) y recursión, no con índices |
| **API** | Una función pura por algoritmo: `List Int -> List Int`; los helpers no se exportan |
| **Inmutabilidad** | Las listas no se pueden mutar, así que se devuelve una lista nueva; los tests no necesitan copiar el fixture |
| **Naming** | `camelCase` para funciones (`selectionSort`), con el nombre de la especificación (`selection_sort`) conservado como nombre del test |
| **Nulabilidad** | No hay `null`; el caso nulo no es representable en la firma y se omite |
| **Mensajes de aserción** | `Assert.equal` no admite mensaje, así que la comparación usa `Assert.assert :: String -> Boolean -> Aff Unit` con el mensaje primero |
| **Verificación estática** | `spago build`: `purs` compila con los avisos activados y el resumen muestra el recuento por origen (`Src`/`Lib`/`All`) |
| **Artefactos** | `output/`, `.spago/` y `node_modules/` — ignorados por el `.gitignore` del módulo; `spago.lock` **sí** se versiona |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort
spago test
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).
👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
