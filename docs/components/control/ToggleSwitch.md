# ToggleSwitch

Location: `qml/components/control/check/ToggleSwitch.qml`

Minimal on/off switch. Only enabled/disabled + checked state.

## Usage
```qml
LV.ToggleSwitch { checked: true }
```

## Practical Examples

### Example 1: Basic feature toggle
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ToggleSwitch {
    checked: true
    onToggled: console.log("Enabled:", checked)
}
```

### Example 2: Permission-controlled toggle
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    property bool canEdit: false

    LV.ToggleSwitch {
        enabled: canEdit
        checked: false
    }
}
```

### Example 3: Customized visual style
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ToggleSwitch {
    trackWidth: 56
    knobSize: 22
    onColor: "#1E9A4A"
    offColor: "#4B4B4B"
}
```
