# VStack

Location: `qml/components/layout/VStack.qml`

SwiftUI-style vertical stack.

## API
- `spacing`: -1 for default spacing
- `defaultSpacing`
- `alignmentName`: `leading | center | trailing`

## Usage
```qml
LV.VStack { alignmentName: "leading" }
```

## Practical Examples

### Example 1: Vertical form layout
```qml
import QtQuick
import LVRS 1.0 as LV

LV.VStack {
    spacing: 10
    LV.Label { text: "Create Project"; style: title2 }
    LV.CheckBox { text: "Private repository" }
    LV.ToggleSwitch { checked: true }
}
```

### Example 2: Trailing alignment for numeric content
```qml
import QtQuick
import LVRS 1.0 as LV

LV.VStack {
    alignmentName: "trailing"
    LV.Label { text: "CPU"; style: body }
    LV.Label { text: "68%"; style: header2 }
}
```

### Example 3: Use default spacing token
```qml
import QtQuick
import LVRS 1.0 as LV

LV.VStack {
    spacing: -1
    defaultSpacing: 14
    LV.Label { text: "Step 1"; style: body }
    LV.Label { text: "Step 2"; style: body }
    LV.Label { text: "Step 3"; style: body }
}
```
