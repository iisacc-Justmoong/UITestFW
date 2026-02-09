# Theme

`Theme` is a QML singleton used across all components. It defines:

- Fonts (`fontBody`, `fontDisplay`)
- Colors (`window`, `windowAlt`, `subSurface`, `surfaceSolid`, `surfaceAlt`, text/accent/success/warning/danger tokens)
- Radii (`radiusSm`, `radiusMd`, ...)
- Text sizes (`textTitle`, `textHeader`, `textBody`, ...)

Usage:
```qml
import UIFramework 1.0 as UIF

Rectangle { color: UIF.Theme.window }
```
