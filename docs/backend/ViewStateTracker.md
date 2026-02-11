# ViewStateTracker

Location: `backend/navigation/viewstatetracker.h` / `backend/navigation/viewstatetracker.cpp`

Tracks page-unit view states from the app window's page stack.

## States
- `Active`
- `Inactive`
- `Disabled`

## Methods
- `syncStack(entries)` updates states from a stack payload.
- `setViewDisabled(viewId, disabled)` overrides a specific view state.
- `setViewEnabled(viewId, enabled)` helper for enable/disable control.
- `stateOf(viewId)` returns one of `Active`, `Inactive`, `Disabled`.
- `snapshot()` returns full stack and grouped state lists.
- `clear()` clears tracked stack and overrides.

## Properties
- `stack`, `loadedViews`, `activeViews`, `inactiveViews`, `disabledViews`
- `currentActiveView`, `loadedCount`
