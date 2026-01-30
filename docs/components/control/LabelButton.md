# LabelButton

Location: `qml/components/control/buttons/LabelButton.qml`

Text-only button styled like a link.

## Properties
- `useTone` (bool, default false)
- `tone` (optional, when `useTone: true`)

## Usage
```qml
UIF.LabelButton { text: "Learn more" }
```

```qml
UIF.LabelButton { text: "Delete"; useTone: true; tone: UIF.AbstractButton.Destructive }
```
