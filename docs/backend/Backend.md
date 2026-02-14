# Backend

Location: `backend/io/backend.h` / `backend/io/backend.cpp`

`Backend` is the bridge singleton for filesystem helpers and runtime-event hook caching.

## Responsibilities

- File IO helpers for QML (`saveTextFile`, `readTextFile`, `ensureDir`, `writableLocation`).
- Runtime event subscription (`hookUserEvents`) to `RuntimeEvents::eventRecorded`.
- Bounded cache of hooked events with per-type counters.
- Current input-state relay for QML consumers (`currentUserInputState`).

## Hook Lifecycle

- `hookUserEvents()` resolves the `RuntimeEvents` singleton, calls `start()`, then subscribes.
- Existing runtime recent events are ingested into backend cache immediately.
- `unhookUserEvents()` disconnects runtime subscriptions.
- `clearHookedUserEvents()` clears cache and summaries.

## Key Properties

- `userEventHooked` (bool)
- `hookedEventCount` (int)
- `hookedEventCapacity` (int, bounded)
- `lastHookedEvent` (map)
- `lastHookedInputState` (map)
- `lastError` (string)

## Key Methods

- `hookUserEvents()`
- `unhookUserEvents()`
- `hookedUserEvents(limit = -1)`
- `hookedUserEventSummary()`
- `currentUserInputState()`
- `clearHookedUserEvents()`

## QML Usage

```qml
import LVRS 1.0 as LV

Component.onCompleted: {
    if (!LV.Backend.hookUserEvents())
        console.warn("hook failed", LV.Backend.lastError)
}

property var inputState: LV.Backend.currentUserInputState()
property var recent: LV.Backend.hookedUserEvents(64)
```
