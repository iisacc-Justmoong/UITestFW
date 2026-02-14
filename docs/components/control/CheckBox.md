# CheckBox

Location: `qml/components/control/check/CheckBox.qml`

Checkbox with label.

## Usage
```qml
LV.CheckBox { text: "Remember me"; checked: true }
```

## Practical Examples

### Example 1: Bind to a preference flag
```qml
import QtQuick
import LVRS 1.0 as LV

QtObject { id: settings; property bool autoSave: true }

LV.CheckBox {
    text: "Enable Auto Save"
    checked: settings.autoSave
    onToggled: settings.autoSave = checked
}
```

### Example 2: Gate an action with policy agreement
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    property bool accepted: false

    LV.CheckBox {
        text: "I agree to the data policy"
        checked: accepted
        onToggled: accepted = checked
    }

    LV.LabelButton {
        anchors.top: parent.top
        anchors.topMargin: 40
        text: "Continue"
        tone: LV.AbstractButton.Primary
        enabled: accepted
    }
}
```

### Example 3: Checklist generated from model data
```qml
import QtQuick
import LVRS 1.0 as LV

ListModel {
    id: featureModel
    ListElement { name: "Crash Reports"; enabled: true }
    ListElement { name: "Usage Analytics"; enabled: false }
    ListElement { name: "Weekly Summary"; enabled: true }
}

Column {
    spacing: 8
    Repeater {
        model: featureModel
        delegate: LV.CheckBox {
            text: name
            checked: enabled
            onToggled: featureModel.setProperty(index, "enabled", checked)
        }
    }
}
```
