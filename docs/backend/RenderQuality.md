# RenderQuality

Location: `backend/runtime/renderquality.h` / `backend/runtime/renderquality.cpp`

Global render-quality policy for HiDPI and supersampling.

## Purpose
- Apply high-quality defaults at app boot (`MSAA`, text render mode, HiDPI rounding).
- Expose runtime controls to QML for global supersampling and window quality policy.

## Properties
- `enabled`
- `supersampleScale` (`1.0` to `4.0`, default `3.0`)
- `minimumSupersampleScale`, `maximumSupersampleScale`
- `msaaSamples` (default `8`)
- `nativeTextRendering` (default `true`)

## Methods
- `effectiveSupersampleScale()`
- `applyWindow(window)`
- `applyGlobalDefaults()`

## Notes
- `ApplicationWindow` uses this singleton to render the runtime UI through an oversized layer texture (3x by default) and downsample it to the window size.
