# MVVM Example (Model → ViewModel → QML)

This example is **not built** by default. It exists only to demonstrate the MVVM flow used in this repo:

- **Model (C++)** holds state and emits signals.
- **ViewModel (C++)** exposes model state to QML and provides commands.
- **View (QML)** binds to ViewModel and triggers commands.
- **ViewModelRegistry (C++)** acts as the bridge that hands ViewModels to QML by key.

> This folder is a reference implementation. Do not add it to build targets.

---

## Plain-language explanation (non-developers)

Think of the app like a restaurant:
- **Model** is the kitchen (where the real data lives).
- **ViewModel** is the waiter (it knows how to ask the kitchen and deliver answers).
- **View (QML)** is the menu/table (what the user actually sees and clicks).
- **ViewModels registry** is the host stand (it helps the table find the right waiter).

This example shows how data flows from the kitchen → waiter → table without the table
needing to walk into the kitchen.

---

## Files

### `backend/ExampleModel.h` / `backend/ExampleModel.cpp`
A minimal QObject model with a single property:
- `status` (QString)

It emits `statusChanged()` when the value updates.

### `backend/ExampleViewModel.h` / `backend/ExampleViewModel.cpp`
Wraps the model and exposes:
- `status` (READ-only from the model)
- `simulateWork()` (command that toggles the model state)

It forwards `statusChanged()` to QML.

### `backend/ExampleBootstrap.h` / `backend/ExampleBootstrap.cpp`
Registers the ViewModel into `ViewModels`:

- Retrieves the QML singleton instance of `ViewModels` from the engine
- Constructs `ExampleModel` and `ExampleViewModel`
- Stores the ViewModel by key: `"Example"`

### `qml/Main.qml`
Binds UI to the registered ViewModel:

- Fetches it by key: `UIF.ViewModels.get("Example")`
- Reads `vm.status`
- Calls `vm.simulateWork()`

---

## Why a Registry?

In MVVM, QML should not construct C++ models directly. Instead, the app bootstraps the ViewModels once
and the UI simply **requests them by key**.

`ViewModels` is the bridge that keeps the View layer clean and declarative:

- **C++** controls lifetime and wiring
- **QML** only consumes

---

## How to Wire It in a Real App (Pseudo-Flow)

1) Create the QML engine
2) Register ViewModels
3) Load QML

```cpp
QQmlApplicationEngine engine;
setupExampleViewModel(&engine);
engine.load(QUrl("qrc:/qt/qml/Example/Main.qml"));
```

---

## QML Usage Pattern

```qml
import UIFramework 1.0 as UIF

ApplicationWindow {
    property var vm: UIF.ViewModels.get("Example")

    Column {
        Text { text: vm ? ("Status: " + vm.status) : "No VM" }
        Button { text: "Toggle"; onClicked: vm.simulateWork() }
    }
}
```

---

## Notes / Constraints

- This is **not** a build target.
- The file paths use plain QObject classes for simplicity.
- In real code, ViewModels can expose richer state and commands, but the registration pattern is the same.

---

## Quick Checklist for New ViewModels

- [ ] Create a model with Q_PROPERTY + signals
- [ ] Wrap it in a ViewModel
- [ ] Register it via `ViewModels.set("Key", vm)`
- [ ] Fetch in QML via `ViewModels.get("Key")`



---

# MVVM 예제 (Model → ViewModel → QML)

이 예제는 **기본적으로 빌드되지 않습니다**. 본 저장소에서 사용하는 MVVM 흐름을 설명하기 위한 참고용입니다:

- **Model (C++)**: 상태를 보관하고 시그널을 발생
- **ViewModel (C++)**: Model 상태를 QML에 노출하고 커맨드를 제공
- **View (QML)**: ViewModel에 바인딩하고 커맨드를 호출
- **ViewModelRegistry (C++)**: ViewModel을 QML로 전달하는 브리지(키 기반 조회)

> 이 폴더는 참고용이며, 빌드 타겟에 포함하지 않습니다.

---

## 파일 구성

### `backend/ExampleModel.h` / `backend/ExampleModel.cpp`
단일 프로퍼티를 갖는 최소 모델:
- `status` (QString)

값이 변경되면 `statusChanged()`를 발생합니다.

### `backend/ExampleViewModel.h` / `backend/ExampleViewModel.cpp`
Model을 감싸 QML에 다음을 제공합니다:
- `status` (Model의 값 읽기 전용)
- `simulateWork()` (상태 토글 커맨드)

`statusChanged()` 시그널을 QML로 전달합니다.

### `backend/ExampleBootstrap.h` / `backend/ExampleBootstrap.cpp`
ViewModel을 `ViewModels`에 등록합니다:

- QML 엔진으로부터 `ViewModels` 싱글톤 인스턴스 획득
- `ExampleModel`과 `ExampleViewModel` 생성
- 키 `"Example"`로 등록

### `qml/Main.qml`
등록된 ViewModel을 받아 UI에서 사용:

- `UIF.ViewModels.get("Example")`으로 조회
- `vm.status` 바인딩
- `vm.simulateWork()` 호출

---

## 왜 Registry를 쓰나?

MVVM에서 QML이 C++ 모델을 직접 생성하면 의존성이 늘어나고 구조가 흐트러집니다.
따라서 앱 부트스트랩 단계에서 ViewModel을 생성하고, QML은 **키로 조회**만 하도록 합니다.

`ViewModels`는 이 구조를 유지하는 브리지입니다:

- **C++**에서 생성/수명 관리
- **QML**은 소비만 담당

---

## 실제 앱 연결 흐름 (개념)

1) QML 엔진 생성
2) ViewModel 등록
3) QML 로드

```cpp
QQmlApplicationEngine engine;
setupExampleViewModel(&engine);
engine.load(QUrl("qrc:/qt/qml/Example/Main.qml"));
```

---

## QML 사용 패턴

```qml
import UIFramework 1.0 as UIF

ApplicationWindow {
    property var vm: UIF.ViewModels.get("Example")

    Column {
        Text { text: vm ? ("Status: " + vm.status) : "No VM" }
        Button { text: "Toggle"; onClicked: vm.simulateWork() }
    }
}
```

---

## 참고 / 제약 사항

- 이 예제는 **빌드 대상이 아닙니다**.
- 단순한 QObject 기반으로 작성되어 있습니다.
- 실제 프로젝트에서는 더 많은 상태/명령을 다루지만 등록 패턴은 동일합니다.

---

## 새 ViewModel 작성 체크리스트

- [ ] Q_PROPERTY + 시그널을 가진 Model 생성
- [ ] ViewModel로 래핑
- [ ] `ViewModels.set("Key", vm)` 등록
- [ ] QML에서 `ViewModels.get("Key")`로 조회
