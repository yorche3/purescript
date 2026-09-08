# Hello, World! — PureScript

Implementación de la especificación [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) en **PureScript**, con un enfoque manual y minimalista.

> **ES:** Por la naturaleza del lenguaje (compila a JavaScript y necesita un gestor de paquetes), la estructura difiere de la de los lenguajes interpretados/compilados directos, pero se mantiene al mínimo: un archivo de configuración y un archivo fuente.
> **EN:** Given the language's nature (it compiles to JavaScript and needs a package manager), the structure differs from interpreted/directly compiled languages, but it is kept to a minimum: one config file and one source file.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`spago.yaml`](spago.yaml) | Configuración de **Spago 1.x**: nombre del paquete, dependencias (`console`, `effect`, `prelude`) y package set. |
| [`src/Main.purs`](src/Main.purs) | Código fuente: módulo `Main` con `main` que imprime `"Hello, World! from PureScript"`. |
| [`.gitignore`](.gitignore) | Ignora `output/` y `.spago/` (artefactos de compilación). |

**Estructura de directorios esperada:**

```text
helloworld/
├── spago.yaml       # Configuración de Spago
├── .gitignore       # Ignora output/ y .spago/
├── src/
│   └── Main.purs    # Código fuente
├── output/          # JavaScript generado por purs (no versionado)
└── .spago/          # Package set descargado por Spago (no versionado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto usa **Spago** (el gestor de paquetes de PureScript) con la configuración mínima en YAML (formato de Spago 1.x; las versiones 0.x usaban `spago.dhall`/`packages.dhall`, ya migrados). PureScript es un lenguaje funcional puro que compila a JavaScript; `main :: Effect Unit` es el punto de entrada y `spago run` compila y ejecuta el resultado con Node.

**EN:** The project uses **Spago** (PureScript's package manager) with the minimal YAML configuration (Spago 1.x format; 0.x versions used `spago.dhall`/`packages.dhall`, now migrated). PureScript is a pure functional language that compiles to JavaScript; `main :: Effect Unit` is the entry point and `spago run` compiles and runs the result with Node.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p purescript/core/foundations/helloworld/src
   ```

2. Escribir `spago.yaml` y `src/Main.purs`.

3. No se necesita ningún paso adicional: Spago descarga el package set automáticamente en la primera ejecución.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `spago.yaml` — Configuración de Spago

```yaml
package:
  name: helloworld
  dependencies:
    - console
    - effect
    - prelude
workspace:
  packageSet:
    registry: 80.8.1
  extraPackages: {}
```

### `src/Main.purs` — Módulo principal

```purescript
module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = log "Hello, World! from PureScript"
```

| Elemento | Propósito |
|----------|-----------|
| `module Main` | El módulo de entrada debe llamarse `Main`. |
| `main :: Effect Unit` | Punto de entrada: una función de tipo `Effect Unit` (efecto que devuelve unidad). |
| `Effect.Console.log` | Imprime en la consola (stdout) con salto de línea al final. |

> **ES:** En PureScript los efectos son explícitos: imprimir requiere vivir en `Effect`. `log` añade `\n` automáticamente.
> **EN:** In PureScript effects are explicit: printing requires living in `Effect`. `log` appends `\n` automatically.

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

### Compilar y ejecutar en un paso (recomendado) / Compile & run in one step (recommended)

```bash
cd purescript/core/foundations/helloworld
spago run
```

### Compilar y ejecutar por separado / Compile & run separately

```bash
cd purescript/core/foundations/helloworld
spago build
node -e "require('./output/Main').main()"
```

### Salida esperada / Expected output

```text
Hello, World! from PureScript
```

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** El ejecutable final es JavaScript: `purs` compila los módulos a `output/` y Node los ejecuta; Spago orquesta ambos pasos.
- **EN:** The final executable is JavaScript: `purs` compiles the modules to `output/` and Node runs them; Spago orchestrates both steps.
- **ES:** La primera ejecución de `spago run` descarga el package set (registry 80.8.1) a `.spago/`, ya ignorado por git.
- **EN:** The first `spago run` downloads the package set (registry 80.8.1) into `.spago/`, already git-ignored.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
