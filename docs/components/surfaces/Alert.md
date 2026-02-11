# Alert

Location: `qml/components/surfaces/Alert.qml`

Centered overlay alert (not a popup). Apple-like layout.

## Properties
- `open`, `title`, `message`
- `primaryText`, `secondaryText`
- `primaryEnabled`, `secondaryEnabled`
- `dismissOnBackground`

## Usage
```qml
LV.Alert { open: true; title: "Delete?"; message: "This cannot be undone." }
```

## Practical Examples

### Example 1: Two-button confirm dialog
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Alert {
    open: showDeleteDialog
    title: "Delete this run?"
    message: "This action cannot be undone."
    primaryText: "Delete"
    secondaryText: "Cancel"
    onPrimaryClicked: console.log("Deleted")
    onSecondaryClicked: showDeleteDialog = false
}
```

### Example 2: Three-action flow (vertical buttons)
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Alert {
    open: true
    title: "Choose next step"
    message: "You can save, discard, or continue editing."
    primaryText: "Save"
    secondaryText: "Discard"
    tertiaryText: "Keep Editing"
}
```

### Example 3: Background dismiss behavior
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Alert {
    open: isVisible
    title: "Session Timeout"
    message: "Click outside to close this notice."
    primaryText: "OK"
    dismissOnBackground: true
    onDismissed: isVisible = false
}
```
