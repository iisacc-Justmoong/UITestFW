# IconMenuButton

Location: `qml/components/control/buttons/IconMenuButton.qml`

Icon + chevron menu button variant aligned with the Figma Button component.

## Properties
- `icon`
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)
- `iconSource` (optional override)

## Usage
```qml
UIF.IconMenuButton { tone: UIF.AbstractButton.Default }
```

```qml
UIF.IconMenuButton {
    icon: "⋮"
    tone: UIF.AbstractButton.Borderless
}
```
