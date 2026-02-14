# Event Policy

Goal: keep interaction behavior deterministic by routing all high-level UI reactions through unified runtime event sources.

## Rule 1: Prefer EventListener over ad-hoc local handlers

Attach `EventListener` where possible instead of scattering custom event plumbing across components.

## Rule 2: Use global triggers for cross-surface behaviors

For overlays, context menus, and app-wide shortcuts, use:
- `globalPressed`
- `globalContextRequested`

This ensures behavior remains valid regardless of local mouse area nesting.

## Rule 3: Backend-first input state

When consuming event payloads, prefer `Backend.currentUserInputState()` path (default in `EventListener`) to avoid state skew under rapid event bursts.

## Rule 4: Outside-dismiss behaviors must be coordinate-based

Dismiss logic for menus/dialog-like surfaces must be based on global coordinates mapped to overlay-local geometry, not local-only click assumptions.

## Rule 5: Nested scroll isolation is mandatory

Components with internal `Flickable` regions must install wheel guards to prevent parent and child scroll surfaces from reacting simultaneously.

## Rule 6: Text input composition safety

Text-entry controls must include IME composition guards (`InputMethodGuard`) so locale/input-method transitions commit composition safely.
