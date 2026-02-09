# LabelMenuButton

Location: `qml/components/control/buttons/LabelMenuButton.qml`

Label + chevron menu button variant aligned with the Figma Button component.

## Properties
- `text`
- `tone` (`Accent`, `Default`, `Borderless`, `Destructive`, `Disabled`)

## Usage
```qml
UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Default }
```

```qml
UIF.LabelMenuButton {
    text: "Open"
    tone: UIF.AbstractButton.Borderless
}
```
