# LVRS

LVRS is a Qt 6.5+ UI framework and reference application focused on deterministic rendering, event observability, and reusable QML components.

The repository ships three layers together:
- A reusable static QML module (`LVRS`) with components and C++ singletons.
- A demo executable (`LVRS`) that acts as a visual catalog and runtime console.
- Tests covering event flow, text editing behavior, import API, and backend wiring.

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
  -DLVRS_BUILD_DEMO=ON \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON
```

Build:

```bash
cmake --build build -j
```

Run demo executable:

```bash
./build/bin/LVRS
```

Run tests:

```bash
ctest --test-dir build --output-on-failure
```

## Rendering Backend Policy

At runtime, graphics backend selection is bootstrapped in `main.cpp` via `bootstrapPreferredGraphicsBackend()`.

- Windows/Linux: Vulkan is selected and loader availability is validated.
- macOS: Metal is selected first when Qt Metal support exists; Vulkan (MoltenVK) is fallback.
- If no usable backend is available, app startup fails fast with a clear error message.

Build-time Vulkan enforcement is controlled by:
- `LVRS_ENFORCE_VULKAN` (default `ON`)

When enabled, configure fails if:
- A linkable Vulkan runtime target is unavailable.
- Qt was built without Vulkan support (`QT_FEATURE_vulkan < 0`).

## Project Layout

- `main.cpp`: app entrypoint, backend bootstrap, font loading.
- `backend/`: C++ singletons (`RuntimeEvents`, `Backend`, `RenderMonitor`, `RenderQuality`, etc.).
- `qml/`: QML module entry files and components.
- `qml/Main.qml`: visual catalog with tab pages and EventListener runtime console.
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

`qml/Main.qml` is no longer a single long preview page. It is a tab-oriented design-system console with dedicated pages for:
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
