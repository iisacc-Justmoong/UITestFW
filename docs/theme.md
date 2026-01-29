# Theme

`Theme` is a QML singleton used across all components. It defines:

- Fonts (`fontBody`, `fontDisplay`)
- Colors (window, surface, text, accent, success/warning/danger)
- Radii (`radiusSm`, `radiusMd`, ...)
- Spacing (`pageMargin`, `contentMargin`)

Usage:
```qml
import UIFramework 1.0 as UIF

Rectangle { color: UIF.Theme.window }
```

Overriding:
```qml
UIF.Theme.set("accent", "#ff6f61")
UIF.Theme.apply({ radiusMd: 20 })
```
