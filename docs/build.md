# Build and Runtime Setup

## Configure

```bash
cmake -S . -B build
```

## Build

```bash
cmake --build build -j
```

## Run

```bash
cmake -S . -B build-dev \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON
cmake --build build-dev --target LVRSExampleVisualCatalog
./build-dev/bin/LVRSExampleVisualCatalog
```

The visual-catalog example target (`LVRSExampleVisualCatalog`) emits the executable as `build-dev/bin/LVRSExampleVisualCatalog`.
The framework library target (`LVRSCore`) itself does not emit a runnable app.

## Test

```bash
ctest --test-dir build-dev --output-on-failure
```

## Build Options

- `LVRS_BUILD_EXAMPLES` (`OFF`): build runnable examples.
- `LVRS_BUILD_TESTS` (`OFF`): build and register tests.
- `LVRS_INSTALL_QML_MODULE` (`ON`): install QML module artifacts (`qmldir`, qmltypes, plugin, QML files) under `<prefix>/lib/qt6/qml/LVRS`.
- `LVRS_ENFORCE_VULKAN` (`ON`): fail CMake configure when the platform-fixed graphics backend requirements are missing.
- `LVRS_FORCE_X86_QT_TOOLS` (`OFF`): run Qt host tools through Rosetta when required.

## Downstream CMake Integration

Install LVRS into a prefix first:

```bash
cmake -S . -B build-install \
  -DLVRS_BUILD_EXAMPLES=OFF \
  -DLVRS_BUILD_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX=/path/to/lvrs-prefix
cmake --build build-install -j
cmake --install build-install
```

Then, in any Qt Quick project:

```cmake
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)
find_package(LVRS CONFIG REQUIRED)

qt_add_executable(MyApp main.cpp)
qt_add_qml_module(MyApp
    URI MyApp
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES Main.qml
)

lvrs_configure_qml_app(MyApp)
```

Set `CMAKE_PREFIX_PATH` to the install prefix (`/path/to/lvrs-prefix`) when configuring the downstream project.
`lvrs_configure_qml_app()` sets `QT_QML_IMPORT_PATH` for LVRS and applies a default executable output directory (`<build>/bin`) when unset, avoiding target-name collisions with QML module output folders.

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
