# EventListener

Location: `qml/components/control/util/EventListener.qml`

Lightweight event listener you can embed inside any component to attach trigger → action behavior
without modifying the parent component.

## Triggers
- `clicked`
- `pressed`
- `released`
- `entered`
- `exited`
- `hoverChanged`
- `keyPressed`
- `keyReleased`

## Properties
- `trigger` (string)
- `action` (function)
- `payload` (object)
- `enabled` (bool)
- `acceptedButtons` (Qt.MouseButton)

## Usage
```qml
UIF.Label {
    text: "Click me"
    UIF.EventListener {
        trigger: "clicked"
        action: () => console.log("clicked")
    }
}
```

## Notes
- `EventListener` attaches a `MouseArea` to the parent bounds.
- For keyboard triggers, `EventListener` requests focus automatically when enabled.
