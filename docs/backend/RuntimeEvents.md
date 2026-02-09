# RuntimeEvents

Location: `backend/runtimeevents.h` / `backend/runtimeevents.cpp`

Unified runtime listener singleton for global input, UI state, idle tracking, and OS/runtime metrics.

## Covered domains
- Keyboard event listener: key press/release counters and signals
- Mouse cursor event listener: move/press/release tracking and signals
- UI state event listener: created/shown/hidden/destroyed event stream
- Idle tracker: inactivity timing, idle enter/exit signaling
- OS event listener: PID, OS label, app active state, uptime, RSS memory

## Key properties
- Keyboard: `keyPressCount`, `keyReleaseCount`, `lastKey`, `lastKeyText`
- Mouse: `mouseMoveCount`, `mousePressCount`, `mouseReleaseCount`, `lastMouseX`, `lastMouseY`
- UI state: `uiCreatedCount`, `uiShownCount`, `uiHiddenCount`, `uiDestroyedCount`, `lastUiEvent`
- Idle: `idle`, `idleTimeoutMs`, `idleForMs`, `lastActivityEpochMs`
- OS/runtime: `pid`, `osName`, `applicationActive`, `uptimeMs`, `rssBytes`

## Methods
- `start()`, `stop()`
- `attachWindow(window)` for window-scoped UI object lifecycle tracking
- `markActivity()` for explicit user-activity touchpoint
- `resetCounters()`
- `snapshot()`

## Signals
- Keyboard: `keyPressed(...)`, `keyReleased(...)`
- Mouse: `mouseMoved(...)`, `mousePressed(...)`, `mouseReleased(...)`
- UI: `uiEvent(eventType, objectName, className, visible)`
- Idle: `idleEntered()`, `idleExited()`
- OS: `osApplicationStateChanged(state)`, `osStatsChanged()`
