# IconMenuButton

Location: `qml/components/control/buttons/IconMenuButton.qml`

Icon + chevron menu button variant aligned with the Figma Button component.

## Properties
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)
- `iconName` (optional icon set name, e.g. `view-more-symbolic-default`)
- `icon.name` (Qt grouped property, optional icon set name)
- `iconSource` (optional explicit URL override)
- `iconGlyph` (optional text fallback)

## Usage
```qml
UIF.IconMenuButton { tone: UIF.AbstractButton.Default }
```

```qml
UIF.IconMenuButton {
    iconName: "view-more-symbolic-borderless"
    tone: UIF.AbstractButton.Borderless
}
```
