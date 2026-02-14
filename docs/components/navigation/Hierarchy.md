# Hierarchy

Location: `qml/components/navigation/Hierarchy.qml`

Hierarchical outliner panel with toolbar + tree list.

## Developer-first API
- `model`: nested array/object/list-model tree input.
- `activeListItem`, `activeListItemId`, `activeListItemKey`: current selection.
- `expandAll()`, `collapseAll(keepRootExpanded)`: expansion controls.
- `activateListItemById(itemId)`, `activateListItemByKey(itemKey)`: programmatic activation.
- `treeModel`: compatibility alias of `model`.

## Tree Node Shape
```qml
{
    key: "camera",          // optional, stable key
    itemId: 42,              // optional numeric id
    label: "Camera",        // text
    iconName: "camera",     // optional icon name
    iconGlyph: "□",         // optional glyph
    enabled: true,           // optional (default true)
    expanded: false,         // optional (default by autoExpandDepth)
    selected: false,         // optional initial selection
    showChevron: true,       // optional, auto from children when omitted
    children: [ ... ]        // nested nodes
}
```

`model` entries can also be plain strings. For example, `model: ["Overview", "Reports"]`.

## End-user Behavior
- Row click: selection only (does not expand/collapse).
- Chevron click: toggles expand/collapse.
- Up/Down: move selection across visible rows.
- Left: collapse current node or move to parent.
- Right: expand current node or move to first child.
- Active row is auto-scrolled into view.

## Usage
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Hierarchy {
    width: 260
    height: 420

    model: [
        {
            key: "world",
            text: "World",
            icon: "viewMoreSymbolicDefault",
            expanded: true,
            children: [
                { key: "environment", text: "Environment", icon: "viewMoreSymbolicDefault" },
                { key: "characters", text: "Characters", icon: "viewMoreSymbolicBorderless" }
            ]
        }
    ]
}
```
