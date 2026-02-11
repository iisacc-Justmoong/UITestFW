# Link

Location: `qml/components/navigation/Link.qml`

Anchor-like control for navigation.

## Properties
- `router`
- `href`
- `targetComponent`
- `replace`

`router` is optional when `Navigator` has a registered `PageRouter`.

## Usage
```qml
UIF.Link { href: "/reports"; Text { text: "Reports" } }
```
