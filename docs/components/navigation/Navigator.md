# Navigator

Location: `qml/components/navigation/Navigator.qml`

Global navigation delegate for `PageRouter`.

## Concept
- `PageRouter` auto-registers itself to `Navigator` by default.
- Any QML item can navigate in one sentence without router wiring.

## Methods
- `go(path, params)`
- `replace(path, params)`
- `setRoot(path, params)`
- `back()`
- `popToRoot()`
- `goTo(component, params)`
- `replaceWith(component, params)`
- `setRootComponent(component, params)`

## Usage
```qml
LV.Navigator.go("/reports")
```

## Practical Examples

### Example 1: One-line global navigation
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LabelButton {
    text: "Open Reports"
    tone: LV.AbstractButton.Accent
    onClicked: LV.Navigator.go("/reports")
}
```

### Example 2: Back stack controls
```qml
import QtQuick
import LVRS 1.0 as LV

Row {
    spacing: 8
    LV.LabelButton { text: "Back"; onClicked: LV.Navigator.back() }
    LV.LabelButton { text: "Root"; onClicked: LV.Navigator.popToRoot() }
}
```

### Example 3: Navigate to a component object
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    Component { id: localPage; Rectangle { color: LV.Theme.surfaceAlt } }

    LV.LabelButton {
        text: "Open Local Page"
        onClicked: LV.Navigator.goTo(localPage, { from: "quick-action" })
    }
}
```
