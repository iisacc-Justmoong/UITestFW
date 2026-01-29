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
UIF.Alert { open: true; title: "Delete?"; message: "This cannot be undone." }
```
