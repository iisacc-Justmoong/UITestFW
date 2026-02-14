# HStack

Location: `qml/components/layout/HStack.qml`

SwiftUI-style horizontal stack.

## API
- `spacing`: -1 for default spacing
- `defaultSpacing`
- `alignmentName`: `top | center | bottom`

## Usage
```qml
LV.HStack { alignmentName: "bottom" }
```

## Practical Examples

### Example 1: Horizontal action row
```qml
import QtQuick
import LVRS 1.0 as LV

LV.HStack {
    spacing: 12
    LV.LabelButton { text: "Cancel"; tone: LV.AbstractButton.Default }
    LV.LabelButton { text: "Save"; tone: LV.AbstractButton.Primary }
}
```

### Example 2: Vertical alignment control
```qml
import QtQuick
import LVRS 1.0 as LV

LV.HStack {
    alignmentName: "bottom"
    Rectangle { width: 40; height: 20; color: "#666" }
    Rectangle { width: 40; height: 40; color: "#999" }
    Rectangle { width: 40; height: 60; color: "#CCC" }
}
```

### Example 3: Flexible spacing with `Spacer`
```qml
import QtQuick
import LVRS 1.0 as LV

LV.HStack {
    LV.Label { text: "Left"; style: body }
    LV.Spacer {}
    LV.Label { text: "Right"; style: body }
}
```
