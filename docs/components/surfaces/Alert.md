# Alert

Location: `qml/components/surfaces/Alert.qml`

`Alert` is a centered overlay surface with explicit frame, inner surface, and action layout variants.

## Visual Structure

- Backdrop layer (`backdropColor`, optional background dismiss).
- Framed outer card (`cardFrameColor`, `cardFrameWidth`).
- Inner alert surface (`cardBackgroundColor`).
- App icon block + title/message + action zone.

This framed structure avoids floating-text appearance and matches the current design specification.

## Properties

State and text:
- `open`, `title`, `message`
- `primaryText`, `secondaryText`, `tertiaryText`
- `primaryEnabled`, `secondaryEnabled`, `tertiaryEnabled`

Behavior and layout:
- `dismissOnBackground`
- `useOverlayLayer`
- `minWidth`, `maxWidth`
- `useVerticalActionLayout` (derived when tertiary action exists)

Visual tokens:
- `backdropColor`
- `cardBackgroundColor`
- `cardFrameColor`, `cardFrameWidth`

## Signals

- `primaryClicked()`
- `secondaryClicked()`
- `tertiaryClicked()`
- `dismissed()`

## Usage

```qml
LV.Alert {
    open: appState.alertOpen
    title: "Delete Scene?"
    message: "This action cannot be undone."
    primaryText: "Delete"
    secondaryText: "Cancel"
    onPrimaryClicked: appState.confirmDelete()
    onSecondaryClicked: appState.alertOpen = false
}
```
