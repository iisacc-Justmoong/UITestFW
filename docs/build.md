# Build and Runtime Setup

## Configure

```bash
cmake -S . -B build \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON
```

## Build

```bash
cmake --build build -j
```

## Run

```bash
cmake --build build --target LVRSExampleVisualCatalog
./build/bin/LVRSExampleVisualCatalog
```

The visual-catalog example target (`LVRSExampleVisualCatalog`) emits the executable as `build/bin/LVRSExampleVisualCatalog`.
The framework library target (`LVRSCore`) itself does not emit a runnable app.

## Test

```bash
ctest --test-dir build --output-on-failure
```

## Build Options

- `LVRS_BUILD_EXAMPLES` (`ON`): build runnable examples.
- `LVRS_BUILD_TESTS` (`ON`): build and register tests.
- `LVRS_ENFORCE_VULKAN` (`ON`): fail CMake configure when the platform-fixed graphics backend requirements are missing.
- `LVRS_FORCE_X86_QT_TOOLS` (`OFF`): run Qt host tools through Rosetta when required.

## Rendering Backend Enforcement

At configure time, when `LVRS_ENFORCE_VULKAN=ON`:

- macOS/iOS must provide Qt Metal support (`QT_FEATURE_metal >= 0`).
- Windows/Linux/Android must provide Qt Vulkan support (`QT_FEATURE_vulkan >= 0`) and a linkable Vulkan runtime target (`Vulkan::Vulkan`).

At runtime:

- macOS/iOS are fixed to Metal.
- Windows/Linux/Android are fixed to Vulkan.
- Other platforms use Qt default backend selection as fallback.
- Startup fails fast if a fixed backend cannot be initialized.

## Notes

- Qt 6.5+ with `Quick` and `QuickControls2` is required.
- Vulkan and Qt feature checks happen in `CMakeLists.txt`.
- Backend selection logic lives in `backend/runtime/vulkanbootstrap.cpp`.
- Downstream app bootstrap template is provided at `main.cpp` (not built by default).
- Recommended reusable bootstrap API is `backend/runtime/appbootstrap.h`.
