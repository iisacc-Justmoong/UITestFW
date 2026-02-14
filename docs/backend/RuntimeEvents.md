# RuntimeEvents

Location: `backend/runtime/runtimeevents.h` / `backend/runtime/runtimeevents.cpp`

`RuntimeEvents` is the runtime daemon singleton that records input, UI lifecycle, and process telemetry.

## Event Domains

- Keyboard: key press/release, pressed key set, active modifier names.
- Pointer: move/press/release/double-click, wheel, hover.
- Context requests: explicit `QEvent::ContextMenu` with reason code.
- Extended pointer families: touch, tablet, native gesture.
- UI lifecycle: child-added, show/hide, destroy tracking.
- Daemon/process: heartbeat, uptime, memory RSS, application active state.

## Health and Event Log APIs

- `snapshot()` returns aggregate runtime state.
- `daemonHealth()` returns daemon status + input snapshot + last event.
- `recentEvents()` returns bounded event history.
- `clearRecentEvents()` resets runtime event buffer.
- `hitTestUiAt(globalX, globalY)` returns object/class/path at pointer coordinate.

## Input State API

- `inputState()` returns:
  - pointer globals
  - pressed mouse button names
  - key state and key codes
  - active modifiers
  - press/release elapsed timings
  - pointer UI hit information (`pointerUi`)

## Signals of Interest

- `eventRecorded(eventData)`
- `daemonHeartbeat(epochMs, uptimeMs, eventSequence)`
- `mousePressed(...)`, `mouseReleased(...)`
- `contextRequested(x, y, modifiers, reason)`
- `uiEvent(eventType, objectName, className, visible)`

## Typical Integration

- `ApplicationWindow` calls `RuntimeEvents.start()` and `RuntimeEvents.attachWindow(window)`.
- `EventListener` listens to `mousePressed` and `contextRequested` for global triggers.
- `Backend` mirrors runtime events into its own cache for backend-first QML reads.

## Notes

- Runtime event names include prefixes such as `key-`, `mouse-`, `touch-`, `tablet-`, `native-gesture`, `context-`, `ui-event`, and `daemon-*`.
- Pointer hit-testing falls back gracefully when a direct Quick-item hit is unavailable.
