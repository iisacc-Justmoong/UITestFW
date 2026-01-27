# Repository Guidelines

## Project Structure & Module Organization
- `main.cpp` boots the Qt application and loads the QML module entrypoint.
- `qml/` holds UI source. `qml/Main.qml` is the app window root.
- `qml/components/` contains reusable UI building blocks (e.g., `AppScaffold.qml`).
- `CMakeLists.txt` defines the build, Qt modules, and QML module metadata.
- `cmake-build-debug/` is a local build output folder (generated; do not edit by hand).

## Build, Test, and Development Commands
- Configure: `cmake -S . -B build`  
  Generates build files in `./build`.
- Build: `cmake --build build`  
  Compiles the C++ target and QML module.
- Run: `./build/UITestFW`  
  Launches the Qt Quick UI.

_No automated tests are set up yet._

## Coding Style & Naming Conventions
- Indentation: 4 spaces for C++ and QML (match existing files).
- QML components: `PascalCase` filenames (e.g., `AppHeader.qml`).
- Properties and IDs: `camelCase` (e.g., `headerTitle`, `contentWrap`).
- Keep UI colors and spacing centralized within components when practical.
- Prefer Qt Quick Controls 2 types (`ApplicationWindow`, `ToolBar`, `Drawer`).

## Testing Guidelines
- No test framework is configured. If you add tests, document:
  - Framework choice (e.g., Qt Test).
  - How to run them (`ctest`, etc.).
  - Naming conventions (e.g., `test_*.cpp`).

## Commit & Pull Request Guidelines
- This repository is not currently a Git repo; no commit history exists.
- If you initialize Git, use clear, action‑oriented commit messages (e.g., "Add AppScaffold layout").
- For PRs, include:
  - A short summary of UI/behavior changes.
  - Screenshots or recordings for UI updates.
  - Any build or platform notes (Qt version, OS).

## Configuration Notes
- Requires Qt 6.5+ with `QtQuick` and `QtQuickControls2`.
- Keep generated build artifacts out of source control (e.g., `build/`, `cmake-build-*`).
