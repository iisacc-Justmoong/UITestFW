# Rendering Backend Policy

This document defines how LVRS selects and enforces graphics backends.

## Bootstrap Entry

Runtime backend bootstrap occurs before `QGuiApplication` creation in `main.cpp`:

- `RenderQuality::configureGlobalDefaults()`
- `lvrs::bootstrapPreferredGraphicsBackend()`

If bootstrap returns unavailable, app exits with error.

## Platform Rules

### macOS

- Prefer Metal when `QT_FEATURE_metal > 0`.
- If Metal unavailable but Qt Vulkan is enabled, try Vulkan fallback (MoltenVK).
- Vulkan fallback attempts loader discovery (`QT_VULKAN_LIB`, Homebrew paths, default symbols).

### Windows / Linux

- Prefer Vulkan.
- Runtime checks loader availability before startup continues.

## Build-Time Enforcement

`CMakeLists.txt` provides `LVRS_ENFORCE_VULKAN` (default `ON`).

When enabled:
- Configure fails if no linkable Vulkan runtime target exists.
- Configure fails if Qt was built without Vulkan support.

This enforcement is intentionally strict to surface deployment misconfiguration early.

## Diagnostics

On startup, LVRS logs backend and loader:
- `LVRS graphics backend: metal`
- `LVRS graphics backend: vulkan, loader = ...`

When backend cannot be initialized, error text includes next-step guidance (for example MoltenVK loader hints).

## Related Components

- `backend/runtime/vulkanbootstrap.cpp`
- `backend/runtime/renderquality.cpp`
- `qml/ApplicationWindow.qml` (supersample layer setup)
