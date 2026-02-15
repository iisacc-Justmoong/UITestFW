# Platform

Location: `backend/platform/platforminfo.h` / `backend/platform/platforminfo.cpp`

Platform information and runtime-target policy singleton.

## Properties
- `os`, `canonicalOs`, `arch`
- `graphicsBackend`
- `mobile`, `desktop`
- `android`, `ios`, `macos`, `windows`, `linux`
- `metalSupported`, `vulkanSupported`
- `runtimeTargets`, `desktopTargets`, `mobileTargets`
- `runtimeProfiles`

## Runtime Target APIs
- `normalizeTarget(target)`: normalizes aliases (`osx`, `win32`, etc.) to canonical ids.
- `isKnownTarget(target)`
- `targetMatchesCurrent(target)`
- `targetIsMobile(target)`, `targetIsDesktop(target)`
- `supportsTargetGeneration(target)`: checks whether LVRS recognizes the target.
- `backendFeatureReadyFor(target)`: verifies required Qt backend feature (Metal/Vulkan) for a target.
- `graphicsBackendFor(target)`: required render backend for the target.
- `runtimeProfile(target)`: returns a structured profile map used for platform checks and runtime-target guidance.
