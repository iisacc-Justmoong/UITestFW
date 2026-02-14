# LabelButton

Location: `qml/components/control/buttons/LabelButton.qml`

Text button variant aligned with the Figma Button component.

## Properties
- `text`
- `tone` (`Primary`, `Default`, `Borderless`, `Destructive`, `Disabled`)

## Usage
```qml
LV.LabelButton { text: "Button"; tone: LV.AbstractButton.Primary }
```

```qml
LV.LabelButton { text: "Button"; tone: LV.AbstractButton.Borderless }
```

## Practical Examples

### Example 1: Primary form submit
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelButton {
    text: "Save Changes"
    tone: LV.AbstractButton.Primary
    onClicked: console.log("Saved")
}
```

### Example 2: Secondary borderless action
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelButton {
    text: "Learn More"
    tone: LV.AbstractButton.Borderless
    onClicked: LV.Navigator.go("/docs")
}
```

### Example 3: Destructive operation with safety flag
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    property bool canDelete: false

    LV.LabelButton {
        text: "Delete Resource"
        tone: LV.AbstractButton.Destructive
        enabled: canDelete
    }
}
```
