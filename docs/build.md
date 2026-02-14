# Build and Runtime Setup

## Configure

```bash
cmake -S . -B build \
  -DLVRS_BUILD_DEMO=ON \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON
```

## Build

```bash
cmake --build build -j
```

## Run

```bash
./build/bin/LVRS
```

The demo target (`LVRSDemo`) is configured to emit the executable as `build/bin/LVRS`.

## Test

```bash
ctest --test-dir build --output-on-failure
```

## Build Options

- `LVRS_BUILD_DEMO` (`ON`): build the visual-catalog application.
- `LVRS_BUILD_EXAMPLES` (`ON`): build runnable examples.
- `LVRS_BUILD_TESTS` (`ON`): build and register tests.
- `LVRS_ENFORCE_VULKAN` (`ON`): fail CMake configure when Vulkan-capable dependencies are missing.
- `LVRS_FORCE_X86_QT_TOOLS` (`OFF`): run Qt host tools through Rosetta when required.

## Rendering Backend Enforcement

At configure time, when `LVRS_ENFORCE_VULKAN=ON`:

- A linkable Vulkan runtime target must exist (`Vulkan::Vulkan`).
- Qt Vulkan feature must be enabled (`QT_FEATURE_vulkan >= 0`).

At runtime:

- macOS prefers Metal, then Vulkan fallback.
- Other platforms prefer Vulkan.
- Startup fails fast if no backend can be initialized.

## Notes

- Qt 6.5+ with `Quick` and `QuickControls2` is required.
- Vulkan and Qt feature checks happen in `CMakeLists.txt`.
- Backend selection logic lives in `backend/runtime/vulkanbootstrap.cpp`.
