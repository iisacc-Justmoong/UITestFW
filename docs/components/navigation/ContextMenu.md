# ContextMenu

Location: `qml/components/navigation/ContextMenu.qml`

`ContextMenu` is a popup menu surface with runtime-aware outside-dismiss behavior.

## Core Features

- Item model with string/object/list-model compatibility.
- Divider support (`type: "divider"` or `divider: true`).
- Optional icon/source/key/chevron metadata per item.
- Semi-transparent menu surface (`menuOpacity`, default `0.5`).

## Dismiss Semantics

The menu closes when pointer/context input occurs outside popup bounds.

There are two complementary paths:
- Popup close policy (`CloseOnPressOutside`, `CloseOnReleaseOutside`, etc.).
- Global event bridge via `EventListener` triggers (`globalPressed`, `globalContextRequested`) and `dismissIfOutsideGlobalEvent(eventData)`.

This dual path exists to guarantee closure even in complex overlay/event propagation contexts.

## Key Properties

- `items`
- `autoCloseOnTrigger`
- `dismissOnGlobalPress`
- `dismissOnGlobalContextRequest`
- `menuColor`, `menuOpacity`, `resolvedMenuColor`
- `itemWidth`, `itemSpacing`

## Key Methods

- `openAt(x, y)`
- `openFor(item, x, y)`
- `dismissIfOutsideGlobalEvent(eventData)`

## Signal

- `itemTriggered(index, item)`

## Usage

```qml
LV.ContextMenu {
    id: contextMenu
    items: [
        { id: "copy", label: "Copy", key: "Cmd+C", showChevron: false },
        { type: "divider" },
        { id: "inspect", label: "Inspect", showChevron: false }
    ]
}
```
