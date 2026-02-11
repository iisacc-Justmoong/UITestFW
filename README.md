# LVRS

LVRS는 Qt 6 기반의 QML UI 프레임워크이자 앱 셸 라이브러리이다. 레이아웃, 내비게이션, 공통 컨트롤, 런타임 싱글턴, MVVM 뷰모델 레지스트리를 함께 제공하며, 목표는 신규 앱의 시작 비용을 줄이고 일관된 화면 구조를 빠르게 구성하는 데 있다.

## 1) 요구 환경

- CMake 3.21 이상
- C++20 컴파일러
- Qt 6.5 이상
- Qt 모듈: `Quick`, `QuickControls2`, `Qml`, `Svg`, `Network`, `Test`

## 2) 저장소 빌드 및 실행

LVRS 데모 앱, 예제, 테스트를 포함한 전체 빌드 절차는 다음과 같다.

```bash
cmake -S . -B build \
  -DLVRS_BUILD_DEMO=ON \
  -DLVRS_BUILD_EXAMPLES=ON \
  -DLVRS_BUILD_TESTS=ON

cmake --build build -j
```

데모 실행은 빌드 산출물에 따라 아래 중 하나를 사용한다.

```bash
./build/LVRS
# 또는 macOS 번들 환경에서는
open ./build/LVRS.app
```

테스트 실행:

```bash
ctest --test-dir build --output-on-failure
```

## 3) 설치

### 3-1. 통합 설치 스크립트 사용

프로젝트 루트에서 아래를 실행하면 사용자 영역에 설치된다.

```bash
./install.sh
```

설치 결과:

- CMake 패키지 프리픽스: `~/.local/LVRS`
- 소스 스냅샷: `~/.local/LVRS/src/LVRS`

### 3-2. 수동 설치

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

## 4) 신규 앱 프로젝트 시작 예제

아래 예제는 LVRS를 프로젝트에 직접 포함(`add_subdirectory`)하는 시작점이다. 정적 QML 플러그인 타깃까지 안전하게 링크하기 위해 이 경로를 권장한다.

### 4-1. `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.21)
project(MyLvrsApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Svg Network)
qt_standard_project_setup()

# LVRS 소스를 외부 디렉터리에 두었을 때의 예시
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
import LVRS 1.0 as UIF

UIF.ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 760
    title: "My LVRS App"
    subtitle: "Starter"

    Component {
        id: homePage
        Rectangle { color: UIF.Theme.surfaceAlt }
    }

    Component {
        id: reportsPage
        Rectangle { color: UIF.Theme.surfaceGhost }
    }

    UIF.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [
            { path: "/", component: homePage, viewModelKey: "HomeVM", writable: true },
            { path: "/reports", component: reportsPage, viewModelKey: "ReportsVM" }
        ]
    }

    Component.onCompleted: {
        // 라우터를 직접 전달하지 않아도 전역 Navigator가 페이지 이동을 위임한다.
        UIF.Navigator.go("/reports")
    }
}
```

## 5) MVVM 시작 API

LVRS의 `ViewModels` 싱글턴은 뷰-뷰모델 바인딩, 소유권, 쓰기 권한을 함께 제공한다.

- `UIF.ViewModels.bindView(viewId, key, writable)`
- `UIF.ViewModels.getForView(viewId)`
- `UIF.ViewModels.canWrite(viewId, key?)`
- `UIF.ViewModels.updateProperty(viewId, property, value)`
- `UIF.ViewModels.ownerOf(key)`

QML 예시:

```qml
property string viewId: "/overview"
property var vm: UIF.ViewModels.getForView(viewId)

Component.onCompleted: UIF.ViewModels.bindView(viewId, "OverviewVM", true)

function renameStatus() {
    UIF.ViewModels.updateProperty(viewId, "status", "Working")
}
```

## 6) 주요 경로

- 백엔드: `backend/`
- QML 모듈: `qml/`
- 예제: `example/`
- 테스트: `tests/`
- 상세 문서 인덱스: `docs/README.md`
