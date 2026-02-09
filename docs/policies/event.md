# Event Policy

**Goal:** Attach behavior without modifying component internals.

## Rule 1 — Use EventListener for ad‑hoc behaviors
- Place `EventListener { ... }` inside any component to bind triggers to actions.
- Avoid adding custom `onClicked` logic to base components unless it is core behavior.

## Rule 2 — Triggers
Supported triggers:
- `clicked`, `pressed`, `released`
- `entered`, `exited`, `hoverChanged`
- `keyPressed`, `keyReleased`

## Rule 3 — Keyboard events
- Parent must be focusable for key triggers to fire.

## Rule 4 — No global side effects by default
- Events should not mutate unrelated state unless explicitly coded in `action`.
