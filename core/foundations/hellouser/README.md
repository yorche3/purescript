# Hello, User! — PureScript

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **PureScript**, con un enfoque manual y minimalista.

Lee un nombre desde la entrada estándar y saluda al usuario.

> **ES:** Por la naturaleza del lenguaje (compila a JavaScript y la entrada de línea es asíncrona), la implementación usa el callback de `question` en lugar de una lectura síncrona, pero se mantiene al mínimo: un archivo de configuración y un archivo fuente.
> **EN:** Given the language's nature (it compiles to JavaScript and line input is asynchronous), the implementation uses the `question` callback instead of a synchronous read, but it is kept to a minimum: one config file and one source file.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`spago.yaml`](spago.yaml) | Configuración de **Spago 1.x**: nombre del paquete, dependencias (`console`, `effect`, `prelude`, `node-readline`) y package set. |
| [`src/Main.purs`](src/Main.purs) | Código fuente: módulo `Main` con `main` que pide un nombre y saluda. |
| [`.gitignore`](.gitignore) | Ignora `output/` y `.spago/` (artefactos de compilación). |

**Estructura de directorios esperada:**

```text
hellouser/
├── spago.yaml       # Configuración de Spago
├── .gitignore       # Ignora output/ y .spago/
├── src/
│   └── Main.purs    # Código fuente
├── output/          # JavaScript generado por purs (no versionado)
└── .spago/          # Package set descargado por Spago (no versionado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este programa introduce tres conceptos nuevos respecto a `helloworld`:

1. **Interfaz de lectura** — `createConsoleInterface` crea la interfaz de línea de comandos.
2. **Entrada asíncrona** — `question` imprime el prompt y pasa la respuesta a una continuación (no hay lectura síncrona en PureScript).
3. **Concatenación** — `<>` une cadenas; `log $ "..."` aplica `log` al resultado.

**EN:** This program introduces three new concepts compared to `helloworld`:

1. **Read interface** — `createConsoleInterface` creates the command-line interface.
2. **Asynchronous input** — `question` prints the prompt and passes the answer to a continuation (there is no synchronous read in PureScript).
3. **Concatenation** — `<>` joins strings; `log $ "..."` applies `log` to the result.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p purescript/core/foundations/hellouser/src
   ```

2. Escribir `spago.yaml` y `src/Main.purs`.

3. No se necesita ningún paso adicional: Spago descarga el package set automáticamente en la primera ejecución.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `spago.yaml` — Configuración de Spago

```yaml
package:
  name: hellouser
  dependencies:
    - console
    - effect
    - prelude
    - node-readline
workspace:
  packageSet:
    registry: 80.8.1
  extraPackages: {}
```

### `src/Main.purs` — Módulo principal

**ES:** El flujo del programa es:

1. Crear la interfaz de consola con `createConsoleInterface noCompletion`.
2. Lanzar `question "Enter your name: "` con una continuación que recibe el nombre.
3. Imprimir `"Hello, <nombre>!"` y cerrar la interfaz con `close`.

**EN:** Program flow:

1. Create the console interface with `createConsoleInterface noCompletion`.
2. Launch `question "Enter your name: "` with a continuation that receives the name.
3. Print `"Hello, <name>!"` and close the interface with `close`.

```purescript
module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.ReadLine ( createConsoleInterface, noCompletion, question, close)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  interface # question "Enter your name: " \name -> do
    log $ "Hello, " <> name <> "!"
    close interface
```

| Elemento | Propósito |
|----------|-----------|
| `createConsoleInterface noCompletion` | Crea la interfaz de línea de comandos (sin autocompletado). |
| `interface # question "..." \name -> ...` | Imprime el prompt y entrega la respuesta a la continuación (lambda). |
| `<>` | Operador de concatenación de cadenas (de `Semigroup`). |
| `log $ ...` | Aplica `log` a la cadena; imprime con salto de línea al final. |
| `close interface` | Cierra la interfaz tras saludar (termina el proceso). |

> **ES:** `question` es asíncrono por diseño: el programa continúa dentro del callback cuando el usuario presiona Enter. Por eso el `close` vive dentro de la continuación.
> **EN:** `question` is asynchronous by design: the program continues inside the callback when the user presses Enter. That's why `close` lives inside the continuation.

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
cd purescript/core/foundations/hellouser
spago run
```

### Compilar y ejecutar por separado / Compile & run separately

```bash
cd purescript/core/foundations/hellouser
spago build
node -e "require('./output/Main').main()"
```

### Salida esperada / Expected output

```text
Enter your name: Ada
Hello, Ada!
```

> **ES:** El programa espera a que el usuario escriba su nombre y presione Enter antes de mostrar el saludo.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** `question` recibe una continuación en lugar de devolver la línea: es la forma idiomática de leer entrada en Node/PureScript.
- **EN:** `question` takes a continuation instead of returning the line: it is the idiomatic way to read input in Node/PureScript.
- **ES:** La interfaz debe cerrarse con `close`, o el proceso no termina (la consola queda abierta esperando más preguntas).
- **EN:** The interface must be closed with `close`, or the process does not terminate (the console stays open waiting for more questions).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
