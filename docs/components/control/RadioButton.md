# RadioButton

Location: `qml/components/control/check/RadioButton.qml`

Radio indicator component aligned with the Figma `Radio` node (18x18). Supports both `checked/enabled` and compatibility aliases `state/available`.

## Properties
- `checked` / `state`
- `enabled` / `available`
- `text` (optional)

## Usage
```qml
LV.RadioButton { text: "Choice A"; checked: true }
```

```qml
LV.RadioButton { state: true; available: false }
```

## Practical Examples

### Example 1: Simple mode selection
```qml
import QtQuick
import QtQuick.Controls
import LVRS 1.0 as LV

ButtonGroup { id: modeGroup }

Column {
    LV.RadioButton { text: "Daily"; checked: true; ButtonGroup.group: modeGroup }
    LV.RadioButton { text: "Weekly"; ButtonGroup.group: modeGroup }
    LV.RadioButton { text: "Monthly"; ButtonGroup.group: modeGroup }
}
```

### Example 2: Compatibility API (`state`, `available`)
```qml
import QtQuick
import LVRS 1.0 as LV

LV.RadioButton {
    text: "Legacy Option"
    state: true
    available: false
}
```

### Example 3: Data-bound selection card
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    property string environment: "staging"

    Column {
        LV.RadioButton {
            text: "Staging"
            checked: environment === "staging"
            onClicked: environment = "staging"
        }
        LV.RadioButton {
            text: "Production"
            checked: environment === "production"
            onClicked: environment = "production"
        }
    }
}
```
