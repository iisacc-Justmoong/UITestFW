# Overview

LVRS is a Qt 6.5+ QML module that provides a structured UI library and C++ singletons
for common app needs. It is organized by directory and by component.

## QML Import
```qml
import LVRS 1.0 as LV
```

## Main Packages
- `qml/components/control`: reusable controls (buttons, labels)
- `qml/components/layout`: SwiftUI-like layout primitives and scaffolding
- `qml/components/navigation`: stack-based routing and links
- `qml/components/surfaces`: cards and overlay surfaces
- `backend`: C++ singletons and MVVM registry

## Philosophy
- Reusable primitives with consistent styling via `Theme`
- Navigation that blends Svelte-like path syntax with SwiftUI navigation stacks
- MVVM-ready: ViewModels registered in C++, bound per view, and write-owned through permission checks
