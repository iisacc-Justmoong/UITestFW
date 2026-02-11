# LVRS

LVRS is a Qt 6 QML UI framework and app-shell library. It provides reusable controls, layout primitives, routing, runtime singletons, and an MVVM registry with view-level ownership and write permissions.

## 1) Requirements

- CMake 3.21+
- C++20 compiler
- Qt 6.5+
- Qt modules: `Quick`, `QuickControls2`, `Qml`, `Svg`, `Network`, `Test`

## 2) Build and Run from Source

Build demo, examples, and tests:

```bash
cmake -S . -B build \
  -DLVRS_BUILD_DEMO=ON \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON

cmake --build build -j
```

Run the demo app:

```bash
./build/LVRS
# On macOS bundles:
open ./build/LVRS.app
```

Run tests:

```bash
ctest --test-dir build --output-on-failure
```

## 3) Install

### 3-1. Install Script (recommended)

```bash
./install.sh
```

Default install outputs:

- CMake package prefix: `~/.local/LVRS`
- Source snapshot: `~/.local/LVRS/src/LVRS`

### 3-2. Manual Install

```bash
cmake -S . -B build-install \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local/LVRS" \
  -DLVRS_BUILD_DEMO=OFF \
  -DLVRS_BUILD_EXAMPLES=OFF \
  -DLVRS_BUILD_TESTS=OFF

cmake --build build-install -j
cmake --install build-install
```

## 4) Start a New App Project

The most reliable integration path is to include LVRS as a subdirectory, so static plugin targets are linked automatically.

### 4-1. `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.21)
project(MyLvrsApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Svg Network)
qt_standard_project_setup()

# Example: LVRS vendored under external/LVRS
add_subdirectory(external/LVRS lvrs_build)

qt_add_executable(MyLvrsApp
    main.cpp
)

qt_add_qml_module(MyLvrsApp
    URI MyLvrsApp
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(MyLvrsApp
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        LVRS
        LVRSplugin
        LVRSplugin_init
)
```

### 4-2. `main.cpp`

```cpp
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("MyLvrsApp"), QStringLiteral("Main"));
    return app.exec();
}
```

### 4-3. `qml/Main.qml`

```qml
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 760
    title: "My LVRS App"
    subtitle: "Starter"

    Component {
        id: homePage
        Rectangle { color: LV.Theme.surfaceAlt }
    }

    Component {
        id: reportsPage
        Rectangle { color: LV.Theme.surfaceGhost }
    }

    LV.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [
            { path: "/", component: homePage, viewModelKey: "HomeVM", writable: true },
            { path: "/reports", component: reportsPage, viewModelKey: "ReportsVM" }
        ]
    }

    Component.onCompleted: {
        // Global one-line navigation delegation
        LV.Navigator.go("/reports")
    }
}
```

## 5) MVVM Starter API

`ViewModels` manages view-to-viewmodel bindings, ownership, and write authorization.

- `LV.ViewModels.bindView(viewId, key, writable)`
- `LV.ViewModels.getForView(viewId)`
- `LV.ViewModels.canWrite(viewId, key?)`
- `LV.ViewModels.updateProperty(viewId, property, value)`
- `LV.ViewModels.ownerOf(key)`

QML example:

```qml
property string viewId: "/overview"
property var vm: LV.ViewModels.getForView(viewId)

Component.onCompleted: LV.ViewModels.bindView(viewId, "OverviewVM", true)

function renameStatus() {
    LV.ViewModels.updateProperty(viewId, "status", "Working")
}
```

## 6) Repository Layout

- Backend runtime and singletons: `backend/`
- QML module: `qml/`
- Runnable examples: `example/`
- Test suite: `tests/`
- Detailed docs index: `docs/README.md`
