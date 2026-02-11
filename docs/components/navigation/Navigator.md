# Navigator

Location: `qml/components/navigation/Navigator.qml`

Global navigation delegate for `PageRouter`.

## Concept
- `PageRouter` auto-registers itself to `Navigator` by default.
- Any QML item can navigate in one sentence without router wiring.

## Methods
- `go(path, params)`
- `replace(path, params)`
- `setRoot(path, params)`
- `back()`
- `popToRoot()`
- `goTo(component, params)`
- `replaceWith(component, params)`
- `setRootComponent(component, params)`

## Usage
```qml
UIF.Navigator.go("/reports")
```
