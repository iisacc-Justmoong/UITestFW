# Hierarchy

Location: `qml/components/navigation/Hierarchy.qml`

`Hierarchy` is a tree-panel component for array/list-like hierarchical models with explicit expand/collapse affordance.

## High-Level API

- `model` (or `treeModel` alias): array/list-model based hierarchical input.
- `activeListItem`, `activeListItemId`, `activeListItemKey`.
- `expandAll()`, `collapseAll(keepRootExpanded)`.
- `activateListItemById(id)`, `activateListItemByKey(key)`.

## Model Roles

`HierarchyList` consumes role-configurable fields:
- `itemIdRole` (default: `itemId`)
- `itemKeyRole` (default: `key`)
- `labelRole`, `iconNameRole`, `iconSourceRole`, `iconGlyphRole`
- `enabledRole`, `expandedRole`, `selectedRole`, `showChevronRole`
- `childrenRole` (default: `children`)

## Interaction Contract

- Row click: activation only.
- Chevron click area: expand/collapse toggle only.
- Keyboard navigation: optional and visibility-aware.

This separation is intentional so parent-item activation never implicitly mutates expansion state.

## Scroll Behavior

The list viewport uses `WheelScrollGuard` with `consumeInside: true`.
This avoids dual scrolling when hierarchy is nested inside another scrollable page.

## Signals

- `toolbarActivated(button, buttonId, index)`
- `listItemActivated(item, itemId, index)`
- `listItemExpanded(item, itemId, index, expanded)`

## Usage

```qml
LV.Hierarchy {
    model: [
        {
            key: "world",
            label: "World",
            expanded: true,
            children: [
                { key: "camera", label: "Main Camera" },
                { key: "lights", label: "Lights" }
            ]
        }
    ]
}
```
