# Spacer

Location: `qml/components/layout/Spacer.qml`

SwiftUI-style spacer that expands along the stack axis.

## API
- `minLength`

## Usage
```qml
LV.HStack { Text { text: "Left" }; LV.Spacer(); Text { text: "Right" } }
```

## Practical Examples

### Example 1: Push buttons to opposite edges in `HStack`
```qml
import QtQuick
import LVRS 1.0 as LV

LV.HStack {
    LV.LabelButton { text: "Back"; tone: LV.AbstractButton.Default }
    LV.Spacer {}
    LV.LabelButton { text: "Next"; tone: LV.AbstractButton.Accent }
}
```

### Example 2: Reserve minimum space in a `VStack`
```qml
import QtQuick
import LVRS 1.0 as LV

LV.VStack {
    LV.Label { text: "Header"; style: header }
    LV.Spacer { minLength: 24 }
    LV.Label { text: "Footer"; style: description }
}
```

### Example 3: Fill remaining area in an overlay stack
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ZStack {
    Rectangle { anchors.fill: parent; color: LV.Theme.surfaceAlt }
    LV.Spacer {}
    LV.Label { text: "Overlay"; style: caption; anchors.right: parent.right; anchors.bottom: parent.bottom }
}
```
