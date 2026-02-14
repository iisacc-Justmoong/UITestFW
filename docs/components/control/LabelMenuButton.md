# LabelMenuButton

Location: `qml/components/control/buttons/LabelMenuButton.qml`

Label + chevron menu button variant aligned with the Figma Button component.

## Properties
- `text`
- `tone` (`Primary`, `Default`, `Borderless`, `Destructive`, `Disabled`)

## Usage
```qml
LV.LabelMenuButton { text: "Open"; tone: LV.AbstractButton.Default }
```

```qml
LV.LabelMenuButton {
    text: "Open"
    tone: LV.AbstractButton.Borderless
}
```

## Practical Examples

### Example 1: Profile menu entry point
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelMenuButton {
    text: "Profile"
    tone: LV.AbstractButton.Default
    onClicked: console.log("Open profile menu")
}
```

### Example 2: Borderless table menu trigger
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelMenuButton {
    text: "Actions"
    tone: LV.AbstractButton.Borderless
    onClicked: console.log("Row action menu")
}
```

### Example 3: Primary menu button for creation flows
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelMenuButton {
    text: "New"
    tone: LV.AbstractButton.Primary
    onClicked: console.log("Choose creation type")
}
```
