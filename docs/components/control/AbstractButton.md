# AbstractButton

Location: `qml/components/control/buttons/AbstractButton.qml`

Base button for all custom controls. Provides theme-driven colors and padding.

## Key Properties
- `tone` (`AbstractButton.ButtonTone`)
- `effectiveEnabled` (derived: `enabled && tone !== Disabled`)
- `textColor`, `textColorDisabled`
- `backgroundColor`, `backgroundColorHover`, `backgroundColorPressed`, `backgroundColorDisabled`
- `borderColor`, `borderColorHover`, `borderColorDisabled`
- `horizontalPadding`, `verticalPadding`, `cornerRadius`, `borderWidth`

## Tone
`AbstractButton.ButtonTone` supports:
- `Accent`
- `Default`
- `Borderless`
- `Destructive`
- `Disabled`

`enabled` remains consumer-controlled. Use `tone: AbstractButton.Disabled` for a disabled visual style while still being able to override `enabled` as needed.

## Usage
```qml
UIF.AbstractButton { text: "Action"; tone: UIF.AbstractButton.Accent }
```
