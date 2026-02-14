# LabelButton

Location: `qml/components/control/buttons/LabelButton.qml`

`LabelButton` is the text-only button variant built on `AbstractButton`.

## Layout Contract

- Fixed visual height: `20px` (`Theme.gap20`)
- Horizontal padding: `8`
- Vertical padding: `4`
- Corner radius: `Theme.radiusSm`

This contract is intentionally fixed to maintain equal row height across button family previews.

## Tone

Supports `AbstractButton` tones:
- `Primary`
- `Default`
- `Borderless`
- `Destructive`
- `Disabled`

Pressed behavior for `Default` and `Borderless` follows shared base policy (`Theme.accentBlueMuted`).

## Usage

```qml
LV.LabelButton {
    text: "Label"
    tone: LV.AbstractButton.Primary
}
```
