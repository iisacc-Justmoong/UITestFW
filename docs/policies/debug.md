# Debug Policy

**Goal:** Centralized logging with opt‑in output.

## Rule 1 — All logs go through Debug singleton
Use `UIF.Debug.log|warn|error`.

## Rule 2 — Disabled by default
`UIF.Debug.enabled` defaults to `false`. No output unless explicitly enabled.

## Rule 3 — Lightweight default
Only basic creation logs are emitted at component creation, and only when enabled.

## Rule 4 — Do not block UI
Logging should never block or alter UI behavior.
