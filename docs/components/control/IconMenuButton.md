# IconMenuButton

Location: `qml/components/control/buttons/IconMenuButton.qml`

Icon + chevron menu button variant aligned with the Figma Button component.

## Properties
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)
- `iconName` (optional icon set name, e.g. `view-more-symbolic-default`)
- `icon.name` (Qt grouped property, optional icon set name)
- `iconSource` (optional explicit URL override)
- `iconGlyph` (optional text fallback)

## Usage
```qml
LV.IconMenuButton { tone: LV.AbstractButton.Default }
```

```qml
LV.IconMenuButton {
    iconName: "view-more-symbolic-borderless"
    tone: LV.AbstractButton.Borderless
}
```

## Practical Examples

### Example 1: Sorting menu trigger
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconMenuButton {
    tone: LV.AbstractButton.Default
    iconName: "view-more-symbolic-default"
    onClicked: console.log("Open sort menu")
}
```

### Example 2: Borderless toolbar menu button
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconMenuButton {
    tone: LV.AbstractButton.Borderless
    iconName: "view-more-symbolic-borderless"
    onClicked: console.log("Toolbar menu")
}
```

### Example 3: Disabled menu action
```qml
import QtQuick
import LVRS 1.0 as LV

LV.IconMenuButton {
    tone: LV.AbstractButton.Disabled
    enabled: false
    iconGlyph: "⋯"
}
```
