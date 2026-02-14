# Event Pipeline

This document describes the runtime event pipeline used by LVRS from daemon capture to UI actions.

## Pipeline Stages

1. **Capture layer**: `RuntimeEvents`
   - Installs app-level event filter.
   - Captures keyboard, pointer, context, touch, tablet, native gesture, and UI lifecycle events.
   - Emits `eventRecorded` and updates `daemonHealth()` / `inputState()`.

2. **Hook/cache layer**: `Backend`
   - `hookUserEvents()` subscribes to runtime event stream.
   - Stores bounded recent events.
   - Maintains type counters and latest input snapshot.

3. **QML listener layer**: `EventListener`
   - For global triggers, subscribes to runtime `mousePressed` / `contextRequested`.
   - Resolves payload input from backend-first state path.
   - Performs UI hit resolution and context dedup.

4. **Application dispatch layer**: `ApplicationWindow`
   - Hosts always-on global listeners.
   - Emits `globalPressedEvent` and `globalContextEvent` at app root.

5. **Feature layer**
   - `ContextMenu`: open/dismiss logic by event target and outside-hit checks.
   - Runtime console in `Main.qml`: renders daemon health and event rows.
   - `WheelScrollGuard`: wheel routing for nested scroll surfaces.

## Why Backend-First

Backend-first payload resolution reduces state skew in heavy event bursts because QML reads a stable cached snapshot rather than racing direct source updates.

## Context Menu Outside Dismiss Flow

- Global press/context event arrives with global coordinates.
- Popup maps coordinates into overlay-local space.
- If point is outside popup rect, menu closes.

This logic is exposed in `ContextMenu.dismissIfOutsideGlobalEvent(eventData)` and reused from `Main.qml` and menu-internal listeners.

## Observability Hooks

The visual catalog event console aggregates:
- daemon running state
- event sequence and recent event count
- pointer target path/class/object
- active press duration and key/modifier states
- route and render monitor events
