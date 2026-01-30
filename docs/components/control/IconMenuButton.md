# IconMenuButton

Location: `qml/components/control/buttons/IconMenuButton.qml`

Menu-style icon button with optional badge. Uses the active state to drive emphasis.

## Properties
- `icon`
- `badge`
- `active`
- `useTone` (bool, default false)

## Usage
```qml
UIF.IconMenuButton { icon: "●"; badge: "3"; active: true }
```

```qml
UIF.IconMenuButton {
    icon: "⚙"
    active: false
    useTone: true
    tone: UIF.AbstractButton.Borderless
}
```
