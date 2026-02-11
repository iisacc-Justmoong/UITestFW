# EventListener

Location: `qml/components/control/util/EventListener.qml`

Lightweight event listener you can embed inside any component to attach trigger → action behavior
without modifying the parent component.

## Triggers
- `clicked`
- `pressed`
- `released`
- `entered`
- `exited`
- `hoverChanged`
- `keyPressed`
- `keyReleased`

## Properties
- `trigger` (string)
- `action` (function)
- `payload` (object)
- `enabled` (bool)
- `acceptedButtons` (Qt.MouseButton)

## Usage
```qml
LV.Label {
    text: "Click me"
    LV.EventListener {
        trigger: "clicked"
        action: () => console.log("clicked")
    }
}
```

## Notes
- `EventListener` attaches a `MouseArea` to the parent bounds.
- For keyboard triggers, `EventListener` requests focus automatically when enabled.

## Practical Examples

### Example 1: Add click behavior to a passive label
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Label {
    text: "Open Report"
    style: title2

    LV.EventListener {
        trigger: "clicked"
        action: () => LV.Navigator.go("/reports")
    }
}
```

### Example 2: Keyboard trigger inside a focusable panel
```qml
import QtQuick
import LVRS 1.0 as LV

Rectangle {
    width: 360
    height: 80
    color: LV.Theme.surfaceAlt

    LV.Label { anchors.centerIn: parent; text: "Press Enter"; style: body }

    LV.EventListener {
        trigger: "keyPressed"
        action: (event) => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                console.log("Enter pressed")
        }
    }
}
```

### Example 3: Global context menu trigger
```qml
import QtQuick
import LVRS 1.0 as LV

LV.EventListener {
    trigger: "globalContextRequested"
    action: (event) => console.log("Context requested at", event.globalX, event.globalY)
}
```
