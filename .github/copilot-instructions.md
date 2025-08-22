# Copilot Instructions for AI Coding Agents — cbjavaloader

## What this project is

- A ColdBox module that embeds and exposes the JavaLoader library so CFML apps can dynamically load/compile Java classes and JARs.
- Key pieces: `ModuleConfig.cfc` (module settings & DSL registration), `models/Loader.cfc` (public module API), `models/javaloader/` (JavaLoader, JavaProxy, JavaCompiler implementations), and `test-harness/` (integration test app).

## Quick dev workflows (explicit)

- Install deps: run the CommandBox installer at repo root and for the test harness:
  ```bash
  box install
  cd test-harness && box install
  ```
- Build module (packaging, docs):
  ```bash
  box task run taskFile=build/Build.cfc :projectName=`package show slug` :version=`package show version`
  ```
- Run tests (TestBox via provided VS Code tasks or CLI):
  ```bash
  box testbox run bundles=test-harness/tests --!recurse
  # or use the workspace VS Code task "Run TestBox Bundle"
  ```

## Project-specific conventions & patterns

- WireBox DSL: `ModuleConfig.cfc` registers a custom DSL `javaloader` via `wireBox.registerDSL(...)`. Use inject="javaloader:ClassName" for DSL injections.
- Main WireBox mappings: `binder.map("jl@cbjavaloader")` (internal JavaLoader) and `loader@cbjavaloader` (public module proxy, see `models/Loader.cfc`). Use `getWireBox().getInstance("loader@cbjavaloader")` in tests or handlers.
- Persistent loader instance: `models/Loader.cfc` stores the JavaLoader instance in `server` scope under a hashed static key and uses `lock` for safe init/re-init — avoid re-instantiating directly; call `Loader.setup(moduleSettings)` or `Loader.getJavaLoader()`.
- Java compilation: `models/javaloader/JavaCompiler.cfc` expects a JVM `tools.jar` compiler on the classpath; compiled jars are placed by default in `models/javaloader/tmp` (see module `settings.compileDirectory`).

## Important files to consult (fast path)

- `ModuleConfig.cfc` — module settings defaults and DSL registration.
- `models/Loader.cfc` — public API that other apps use (`create`, `appendPath`, `getLoadedURLs`).
- `models/javaloader/JavaLoader.cfc` — upstream JavaLoader implementation (large file, primary behavior).
- `models/javaloader/JavaCompiler.cfc` — dynamic compilation logic and compiler discovery.
- `build/Build.cfc` and `box.json` — packaging, test runner URL and build scripts used by CI.
- `test-harness/` — runnable ColdBox app for integration tests; `test-harness/tests/specs/LoaderTest.cfc` shows expected behavior usage.

## Integration points & external dependencies

- JARs bundled under `models/javaloader/lib/` and `models/javaloader/support/*/lib/`; additional jars for testing live in `test-harness/jars/`.
- The module relies on CommandBox and TestBox for build/test automation. CI uses `.github/workflows/*` (see repo root).

## Safety, edge cases, and constraints agents must respect

- Do not remove or replace the `server`-scoped loader without using the `Loader` API — other code/tests expect the single instance.
- Java compilation may fail when the JVM compiler is not available; surface clear errors and point to `JavaCompiler.cfc` and `tools.jar` classpath as remediation.

## Examples (from repo)

- Injecting via DSL (see README & examples):
  ```cfml
  property name="hello" inject="javaloader:HelloWorld";
  // or via WireBox mapping
  property name="javaloader" inject="loader@cbjavaloader";
  ```
- Module settings (place in your app `ColdBox.cfc` under `moduleSettings.cbJavaLoader`): see `ModuleConfig.cfc` for keys like `loadPaths`, `sourceDirectories`, `compileDirectory`, `trustedSource`.

## What to do next when editing code

- When changing public behavior in `Loader.cfc` or DSL registration in `ModuleConfig.cfc`, update `test-harness/tests/specs/LoaderTest.cfc` or add a spec demonstrating the change.
- Run `box testbox ...` after edits and ensure `test-harness` runner URL in `box.json` matches `build/Build.cfc` test runner if you rely on build tasks.

Please review and tell me if you'd like added examples (e.g., a minimal handler that uses the loader), or if I should fold in more lines from the module-template instructions.