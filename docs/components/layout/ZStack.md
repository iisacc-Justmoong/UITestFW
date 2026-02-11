# ZStack

Location: `qml/components/layout/ZStack.qml`

SwiftUI-style overlay stack.

## API
- `alignmentName`: `topLeading | top | topTrailing | leading | center | trailing | bottomLeading | bottom | bottomTrailing`

## Usage
```qml
LV.ZStack { alignmentName: "topTrailing" }
```

## Practical Examples

### Example 1: Badge overlay
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ZStack {
    width: 120
    height: 48
    alignmentName: "topTrailing"

    Rectangle { anchors.fill: parent; radius: 8; color: LV.Theme.surfaceAlt }
    Rectangle { width: 18; height: 18; radius: 9; color: LV.Theme.accent }
}
```

### Example 2: Loading overlay
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ZStack {
    alignmentName: "center"
    Rectangle { anchors.fill: parent; color: LV.Theme.surfaceGhost }
    LV.Label { text: "Loading..."; style: body }
}
```

### Example 3: Bottom-trailing watermark
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ZStack {
    alignmentName: "bottomTrailing"
    Rectangle { anchors.fill: parent; color: LV.Theme.window }
    LV.Label { text: "v1.2.0"; style: caption }
}
```
