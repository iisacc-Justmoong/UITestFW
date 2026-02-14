# Overview

LVRS is a Qt 6.5+ QML framework with a production-style runtime event daemon and a developer-facing visual catalog.

## Design Goals

- Stable component contracts: reusable controls and navigation primitives.
- Observable runtime: global input/UI/render/navigation events exposed to QML.
- Deterministic rendering policy: explicit backend bootstrap and quality controls.
- Practical integration: installable CMake package with downstream helper API (`lvrs_configure_qml_app`).

## Runtime Model

The runtime model is built around two singleton layers.

- `RuntimeEvents` captures global input, context menu requests, touch/tablet/gesture events, UI lifecycle transitions, idle state, and process metrics.
- `Backend` subscribes to `RuntimeEvents` and maintains a bounded event cache plus summarized input state for low-latency QML consumption.

`EventListener` uses this backend-first state path by default, so high-level components can react consistently without manually wiring every source.

Application entrypoints should use `lvrs::preApplicationBootstrap()` and `lvrs::postApplicationBootstrap()` to apply platform-aware graphics/font defaults in a consistent way. The root template `main.cpp` also supports CLI/env overrides (`--module`, `--root`, `--app-name`, `--style`) for downstream integration.

## UI Model

The QML layer is grouped by concern.

- `control`: buttons, text controls, selection controls, event utilities.
- `layout`: scaffold and stack primitives.
- `navigation`: routing, lists, hierarchy, context menu.
- `surfaces`: overlays and cards.

`example/VisualCatalog/qml/Main.qml` serves as a visual catalog with tab pages and an EventListener runtime console, enabling rapid verification of style tokens, interactions, and event health.

## Key Runtime Guarantees

- Global right-click or context-request events are surfaced through `ApplicationWindow` signals.
- Context menu dismissal is guaranteed when pointer events occur outside popup bounds.
- Nested scroll surfaces can isolate wheel events through `WheelScrollGuard`.
- IME composition state is guarded by `InputMethodGuard` to reduce text corruption on input-method changes.
