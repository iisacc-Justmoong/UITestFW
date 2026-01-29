# Routing Policy

**Goal:** Simple stack navigation with Svelte‑style path syntax (navigation rules are not SwiftUI‑bound).

## Rule 1 — Path syntax
Use `/path`, `/segment/[id]`, `/path/[...rest]`.

## Rule 2 — Stack state
`PageRouter.path` represents the navigation stack.

## Rule 3 — Back/undo
`pop()` and `popToRoot()` are the supported undo operations.

## Rule 4 — Component navigation
`goTo(component)` is allowed but is out‑of‑band from path stack unless explicitly documented.
