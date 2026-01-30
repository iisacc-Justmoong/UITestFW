# LabelMenuButton

Location: `qml/components/control/buttons/LabelMenuButton.qml`

Menu-style label button with optional badge. Uses the active state to drive emphasis.

## Properties
- `badge`
- `active`
- `useTone` (bool, default false)

## Usage
```qml
UIF.LabelMenuButton { text: "Overview"; badge: "3"; active: true }
```

```qml
UIF.LabelMenuButton {
    text: "All"
    active: false
    useTone: true
    tone: UIF.AbstractButton.Default
}
```
