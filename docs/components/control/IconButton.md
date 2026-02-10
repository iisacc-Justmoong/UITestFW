# IconButton

Location: `qml/components/control/buttons/IconButton.qml`

Icon-first button variant aligned with the Figma Button component.

## Properties
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)
- `iconName` (optional icon set name, e.g. `view-more-symbolic-default`)
- `icon.name` (Qt grouped property, optional icon set name)
- `iconSource` (optional explicit URL override)
- `iconGlyph` (optional text fallback)

## Usage
```qml
UIF.IconButton { tone: UIF.AbstractButton.Accent }
```

```qml
UIF.IconButton {
    tone: UIF.AbstractButton.Default
    iconName: "pan-down-symbolic-default"
}
```
