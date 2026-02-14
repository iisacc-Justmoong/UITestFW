# AbstractButton

Location: `qml/components/control/buttons/AbstractButton.qml`

Base button for all custom controls. Provides theme-driven colors and padding.

## Key Properties
- `tone` (`AbstractButton.ButtonTone`)
- `effectiveEnabled` (derived: `enabled && tone !== Disabled`)
- `textColor`, `textColorDisabled`
- `backgroundColor`, `backgroundColorHover`, `backgroundColorPressed`, `backgroundColorDisabled`
- `horizontalPadding`, `verticalPadding`, `cornerRadius`

## Tone
`AbstractButton.ButtonTone` supports:
- `Primary`
- `Default`
- `Borderless`
- `Destructive`
- `Disabled`

`enabled` remains consumer-controlled. Use `tone: AbstractButton.Disabled` for a disabled visual style while still being able to override `enabled` as needed.

## Usage
```qml
LV.AbstractButton { text: "Action"; tone: LV.AbstractButton.Primary }
```

## Practical Examples

### Example 1: Primary action button
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AbstractButton {
    text: "Create Run"
    tone: LV.AbstractButton.Primary
    onClicked: console.log("Run created")
}
```

### Example 2: Destructive action with explicit state
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AbstractButton {
    text: "Delete Project"
    tone: LV.AbstractButton.Destructive
    enabled: canDelete
}
```

### Example 3: Disabled style for read-only screens
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AbstractButton {
    text: "Sync"
    tone: LV.AbstractButton.Disabled
    enabled: false
}
```
