# WheelScrollGuard

Location: `qml/components/control/util/WheelScrollGuard.qml`

`WheelScrollGuard` isolates wheel scrolling to the intended inner scroll container and prevents scroll bleed into outer windows.

## Behavior

- Detects whether pointer is inside `targetFlickable`.
- Converts wheel delta (`pixelDelta` or `angleDelta`) to content movement.
- Applies bounded `contentY` updates.
- Optionally consumes the event (`consumeInside: true`) to stop parent scroll handling.

## Properties

- `targetFlickable` (Flickable-compatible target)
- `consumeInside` (default `true`)
- `fallbackStep` (pixel step for angle-based wheel events)

## Signal

- `wheelRouted(wheelEvent, delta, previousContentY, nextContentY)`

## Typical Usage

```qml
LV.WheelScrollGuard {
    anchors.fill: parent
    targetFlickable: listViewport
    consumeInside: true
}
```

Used in hierarchy and editor surfaces to enforce deterministic nested scroll behavior.
