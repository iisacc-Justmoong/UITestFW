# Link

Location: `qml/components/navigation/Link.qml`

Anchor-like control for navigation.

## Properties
- `router`
- `href`
- `targetComponent`
- `replace`

`router` is optional when `Navigator` has a registered `PageRouter`.

## Usage
```qml
LV.Link { href: "/reports"; Text { text: "Reports" } }
```

## Practical Examples

### Example 1: Text-only link
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    text: "Open Reports"
    href: "/reports"
    underline: true
}
```

### Example 2: Link with custom child content
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    href: "/runs"

    Row {
        spacing: 6
        LV.Label { text: "View Runs"; style: body }
        LV.Label { text: "→"; style: body }
    }
}
```

### Example 3: Replace current page and pass params
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    href: "/runs/42"
    params: ({ source: "notifications" })
    replace: true
    text: "Go to latest failed run"
}
```
