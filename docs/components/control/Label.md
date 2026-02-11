# Label

Location: `qml/components/control/display/Label.qml`

Theme text wrapper that provides Figma-mapped typography styles.

## Style API
- `style: title`
- `style: title2`
- `style: header`
- `style: header2`
- `style: body`
- `style: description`
- `style: caption`
- `style: disabled`

## Usage
```qml
LV.Label { text: "Label"; style: body }
```

## Practical Examples

### Example 1: Title and subtitle pair
```qml
import QtQuick
import LVRS 1.0 as LV

Column {
    spacing: 4
    LV.Label { text: "Release 1.2"; style: title }
    LV.Label { text: "Deployment completed"; style: description }
}
```

### Example 2: Wrapped explanatory text
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Label {
    width: 320
    style: body
    wrapMode: Text.WordWrap
    maximumLineCount: 3
    text: "This page displays real-time run metrics and updates automatically every five seconds."
}
```

### Example 3: Disabled-state helper text
```qml
import QtQuick
import LVRS 1.0 as LV

Column {
    spacing: 2
    LV.Label { text: "API Token"; style: header2 }
    LV.Label { text: "Only project owners can edit this field."; style: disabled }
}
```
