# LabelMenuButton

Location: `qml/components/control/buttons/LabelMenuButton.qml`

`LabelMenuButton` is a text + chevron menu trigger button.

## Layout Contract

- Fixed visual height: `20px`
- Horizontal padding: `8`
- Vertical padding: `2`
- Spacing: `2`

## Indicator Policy

Indicator icon is selected by tone and enabled state:
- `Disabled` tone/state -> `panDownSymbolicDisabled`
- `Borderless` -> `panDownSymbolicBorderless`
- `Primary`/`Destructive` -> `panDownSymbolicAccent`
- `Default` -> `panDownSymbolicDefault`

## Usage

```qml
LV.LabelMenuButton {
    text: "Menu"
    tone: LV.AbstractButton.Default
}
```
