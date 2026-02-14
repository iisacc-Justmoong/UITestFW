# IconMenuButton

Location: `qml/components/control/buttons/IconMenuButton.qml`

`IconMenuButton` combines an icon glyph/source with a trailing chevron indicator.

## Layout Contract

- Fixed visual height: `20px`
- Horizontal padding: `2`
- Vertical padding: `2`
- Spacing: `4`

## Icon and Indicator Rules

Main icon source resolution:
1. explicit `iconSource`
2. explicit `iconName`
3. grouped icon name (`icon.name`)
4. tone-based fallback icon

Chevron indicator follows the same tone mapping used by `LabelMenuButton`.

Both icon and indicator are processed via `SvgManager.icon(...)` and react to `SvgManager.revision` changes.

## Usage

```qml
LV.IconMenuButton {
    tone: LV.AbstractButton.Borderless
    iconName: "viewMoreSymbolicBorderless"
}
```
