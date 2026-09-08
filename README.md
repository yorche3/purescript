# PureScript

Proyectos en **PureScript**, con programas compilados a JavaScript y ejecutados con **Spago** + **Node.js**, y proyectos con pruebas unitarias usando **test-unit** (`Test.Unit`).

---

## 📂 Módulos / Modules

| Módulo | Descripción |
| ------ | ----------- |
| [`core/foundations/`](core/foundations/) | **Fase 0 — Fundamentos**: `helloworld`, `hellouser`, `unit_test/calculator`, `numbers` |

---

## ▶️ Comenzar / Getting Started

```bash
# Hello, World!
cd core/foundations/helloworld
spago run

# Hello, User!
cd core/foundations/hellouser
spago run

# Calculator Tests
cd core/foundations/unit_test/calculator
spago test

# Numbers Tests
cd core/foundations/numbers
spago test
```

---

## 📦 Requisitos / Requirements

| Herramienta | Instalación |
| ----------- | ----------- |
| [PureScript](https://www.purescript.org/) | `npm install -g purescript` / binario desde [GitHub Releases](https://github.com/purescript/purescript/releases) |
| [Spago](https://github.com/purescript/spago) | `npm install -g spago` |
| [Node.js](https://nodejs.org/) | `sudo apt install nodejs` (Linux) / [Descargar](https://nodejs.org/) |

```bash
# Verificar instalación
purs --version
spago --version
node --version
```

> **ES:** El paquete npm de PureScript es el canal legacy; la vía recomendada es el binario oficial de GitHub Releases.
> **EN:** The PureScript npm package is the legacy channel; the recommended path is the official binary from GitHub Releases.

---

## 🏗️ Tipos de proyecto / Project Types

### 1. Programa simple (módulo `Main` con `spago run`)

**ES:** Un `spago.yaml` mínimo y un módulo `src/Main.purs` con `main :: Effect Unit`. Spago descarga el package set, compila a JavaScript con `purs` y ejecuta el resultado con Node. Ideal para `helloworld` y `hellouser`.

**EN:** A minimal `spago.yaml` and a `src/Main.purs` module with `main :: Effect Unit`. Spago downloads the package set, compiles to JavaScript with `purs`, and runs the result with Node. Ideal for `helloworld` and `hellouser`.

```bash
spago run
```

### 2. Proyecto con pruebas unitarias (test-unit + spago test)

**ES:** Para proyectos que requieren pruebas unitarias, se usa **test-unit** (`suite`/`test`, `Assert.equal`) con el módulo `Test.Main` como punto de entrada. El código fuente se organiza en `src/` y las pruebas en `test/`, con `spago test` como runner.

**EN:** For projects that require unit tests, **test-unit** (`suite`/`test`, `Assert.equal`) is used with the `Test.Main` module as the entry point. Source code goes in `src/` and tests in `test/`, with `spago test` as the runner.

```bash
spago test
```

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*