# AbstractButton

Location: `qml/components/control/buttons/AbstractButton.qml`

`AbstractButton` is the base control for LVRS button family variants.

## Tone Enum

`AbstractButton.ButtonTone`
- `Primary`
- `Default`
- `Borderless`
- `Destructive`
- `Disabled`

## Interaction Color Policy

- `Primary`: `Theme.primary` family
- `Destructive`: `Theme.danger` family
- `Default`: `Theme.surfaceSolid` with `Theme.surfaceAlt` hover
- `Borderless`: transparent idle, subtle surface hover
- `Default` and `Borderless` pressed state uses `Theme.accentBlueMuted` (not primary blue)

## Sizing and Layout

`AbstractButton` defines generic layout primitives (`horizontalPadding`, `verticalPadding`, `cornerRadius`, `implicitHeight`).
Concrete button components override these values to match Figma-specific size contracts such as fixed height and per-variant vertical padding.

## Effective Enabled State

`effectiveEnabled = enabled && tone !== AbstractButton.Disabled`

The control disables focus/hover behavior when not effectively enabled, and installs a blocking mouse layer to prevent accidental input propagation.

## Usage

```qml
LV.AbstractButton {
    text: "Action"
    tone: LV.AbstractButton.Default
}
```
