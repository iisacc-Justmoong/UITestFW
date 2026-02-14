# Rendering Backend Policy

This document defines how LVRS selects and enforces graphics backends.

## Bootstrap Entry

Runtime backend bootstrap occurs before `QGuiApplication` creation via `lvrs::preApplicationBootstrap()` (`backend/runtime/appbootstrap.cpp`), and is used by app entrypoints such as `example/VisualCatalog/main.cpp`:

- `RenderQuality::configureGlobalDefaults()`
- `lvrs::bootstrapPreferredGraphicsBackend()`

If bootstrap returns unavailable, app exits with error.

## Platform Rules

### macOS / iOS

- Fixed to Metal.
- If Qt Metal support is unavailable, bootstrap fails immediately.

### Windows / Linux / Android

- Fixed to Vulkan.
- Desktop Vulkan platforms validate loader availability before startup continues.

### Other platforms

- No forced backend.
- Qt default backend selection is used.

## Build-Time Enforcement

`CMakeLists.txt` provides `LVRS_ENFORCE_VULKAN` (default `ON`).

When enabled:
- On macOS/iOS, configure fails if Qt Metal support is unavailable.
- On Windows/Linux/Android, configure fails if Vulkan runtime/feature requirements are unavailable.

This enforcement is intentionally strict to surface deployment misconfiguration early.

## Diagnostics

On startup, LVRS logs backend and loader:
- `LVRS graphics backend: metal`
- `LVRS graphics backend: vulkan, loader = ...`

When a fixed backend cannot be initialized, error text includes next-step guidance.

## Related Components

- `backend/runtime/vulkanbootstrap.cpp`
- `backend/runtime/renderquality.cpp`
- `qml/ApplicationWindow.qml` (supersample layer setup)
