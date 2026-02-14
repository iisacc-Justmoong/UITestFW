# LVRS

LVRS is a Qt 6.5+ UI framework focused on deterministic rendering, event observability, and reusable QML components.

The repository ships three layers together:
- A reusable static QML module (`LVRS`) with components and C++ singletons.
- Runnable example applications under `example/`, including the visual-catalog demo.
- Tests covering event flow, text editing behavior, import API, and backend wiring.

The framework target itself does not build an application executable; all runnable apps are example targets.

## Requirements

- CMake 3.21+
- C++20 compiler
- Qt 6.5+
- Qt modules: `Quick`, `QuickControls2`, `Qml`, `Svg`, `Network`, `Test`
- Vulkan SDK/runtime available to CMake when `LVRS_ENFORCE_VULKAN=ON` (default)

## Build and Run

Configure:

```bash
cmake -S . -B build \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON
```

Build:

```bash
cmake --build build -j
```

Run visual-catalog demo:

```bash
cmake --build build --target LVRSExampleVisualCatalog
./build/bin/LVRSExampleVisualCatalog
```

Run tests:

```bash
ctest --test-dir build --output-on-failure
```

## Rendering Backend Policy

At runtime, graphics backend selection is bootstrapped through `backend/runtime/appbootstrap.*` from each app entrypoint.

- macOS/iOS: Metal is fixed.
- Windows/Linux/Android: Vulkan is fixed and runtime loader availability is validated on desktop Vulkan platforms.
- Other platforms: Qt default backend selection is used as fallback.
- If a fixed backend cannot be initialized, app startup fails fast with a clear error message.

Build-time backend enforcement is controlled by:
- `LVRS_ENFORCE_VULKAN` (default `ON`)

When enabled, configure fails if:
- The platform-fixed backend requirements are not satisfied (`QT_FEATURE_metal` for macOS/iOS, `QT_FEATURE_vulkan` and Vulkan runtime for Windows/Linux/Android).

## Project Layout

- `backend/`: C++ singletons (`RuntimeEvents`, `Backend`, `RenderMonitor`, `RenderQuality`, etc.).
- `backend/runtime/appbootstrap.h`, `backend/runtime/appbootstrap.cpp`: reusable pre/post app bootstrap API for downstream apps.
- `qml/`: QML module entry files and components.
- `main.cpp`: downstream app template entrypoint (reference only, not built by framework CMake targets). CLI/env override로 `module/root/app-name/style`을 주입할 수 있다.
- `example/VisualCatalog/main.cpp`: visual-catalog app entrypoint, backend bootstrap, font loading.
- `example/VisualCatalog/qml/Main.qml`: visual catalog with tab pages and EventListener runtime console.
- `resources/iconset/`: SVG icon source set used for theme accent extraction.
- `tests/`: Qt tests for components and runtime services.
- `docs/`: full technical documentation index.

## Event and Input Architecture

The event system now centers on a daemon-style flow:

1. `RuntimeEvents` installs a global event filter and records input/UI lifecycle events.
2. `Backend.hookUserEvents()` subscribes to the runtime stream and keeps a bounded cache.
3. `EventListener` consumes backend state first (`currentUserInputState()`), then runtime fallback.
4. `ApplicationWindow` emits `globalPressedEvent` and `globalContextEvent`.
5. UI features such as `ContextMenu`, runtime console, and hierarchy scroll guards are driven from this unified stream.

## Main Visual Catalog

`example/VisualCatalog/qml/Main.qml` is a tab-oriented design-system console with dedicated pages for:
- Overview
- Typography
- EventListener console
- Buttons
- Accent tokens
- Inputs / Editors
- Checks
- Navigation
- Layout
- Hierarchy
- Scaffold

The runtime console section exposes daemon health, event sequence, pointer target, pressed keys/buttons, and recent route/render events.

## Documentation

Start at:
- `docs/README.md`

Key references:
- `docs/architecture/event-pipeline.md`
- `docs/architecture/rendering-backend.md`
- `docs/backend/RuntimeEvents.md`
- `docs/backend/Backend.md`
- `docs/components/control/EventListener.md`
- `docs/components/navigation/ContextMenu.md`
- `docs/components/navigation/Hierarchy.md`
- `docs/components/control/InputMethodGuard.md`
