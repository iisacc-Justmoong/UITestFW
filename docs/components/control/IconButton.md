# IconButton

Location: `qml/components/control/buttons/IconButton.qml`

Icon-first button variant aligned with the Figma Button component.

## Properties
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)
- `iconName` (optional icon set name, e.g. `viewMoreSymbolicDefault`)
- `icon.name` (Qt grouped property, optional icon set name)
- `iconSource` (optional explicit URL override)
- `iconGlyph` (optional text fallback)

## Usage
```qml
LV.IconButton { tone: LV.AbstractButton.Accent }
```

```qml
LV.IconButton {
    tone: LV.AbstractButton.Default
    iconName: "panDownSymbolicDefault"
}
```

## Practical Examples

### Example 1: Accent icon action
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconButton {
    tone: LV.AbstractButton.Accent
    iconName: "viewMoreSymbolicDefault"
    onClicked: console.log("Open actions")
}
```

### Example 2: Borderless row action
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconButton {
    tone: LV.AbstractButton.Borderless
    iconName: "panDownSymbolicBorderless"
    onClicked: console.log("Expand row")
}
```

### Example 3: Glyph fallback when icon set is unavailable
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconButton {
    tone: LV.AbstractButton.Default
    iconName: ""
    iconGlyph: "+"
    onClicked: console.log("Create item")
}
```
