import QtQuick
import UIFramework 1.0

Item {
    id: control

    property int rowSpacing: 0
    property var activeItem: null
    property int activeItemId: -1

    signal activeChanged(var item, int itemId, int index)

    default property alias items: listColumn.data

    function collectItems() {
        const result = []
        for (let i = 0; i < listColumn.children.length; i++) {
            const child = listColumn.children[i]
            if (child && child.__isHierarchyItem === true)
                result.push(child)
        }
        return result
    }

    function indexOfItem(item) {
        const currentItems = collectItems()
        for (let i = 0; i < currentItems.length; i++) {
            if (currentItems[i] === item)
                return i
        }
        return -1
    }

    function isItemVisible(item) {
        const currentItems = collectItems()
        const itemIndex = indexOfItem(item)
        if (itemIndex <= 0)
            return true

        const currentIndent = Math.max(0, item && item.indentLevel !== undefined ? item.indentLevel : 0)
        if (currentIndent === 0)
            return true

        let requiredIndent = currentIndent
        for (let i = itemIndex - 1; i >= 0 && requiredIndent > 0; i--) {
            const candidate = currentItems[i]
            const candidateIndent = Math.max(0, candidate && candidate.indentLevel !== undefined ? candidate.indentLevel : 0)
            if (candidateIndent < requiredIndent) {
                if (candidate.showChevron && !candidate.expanded)
                    return false
                requiredIndent = candidateIndent
            }
        }
        return true
    }

    function effectiveItemId(item, index) {
        if (item && item.itemId !== undefined && item.itemId >= 0)
            return item.itemId
        return index
    }

    function resolveById(itemId) {
        const currentItems = collectItems()
        for (let i = 0; i < currentItems.length; i++) {
            const item = currentItems[i]
            if (effectiveItemId(item, i) === itemId)
                return item
        }
        return null
    }

    function firstEnabledItem() {
        const currentItems = collectItems()
        for (let i = 0; i < currentItems.length; i++) {
            const item = currentItems[i]
            if (item && item.enabled)
                return item
        }
        return currentItems.length > 0 ? currentItems[0] : null
    }

    function firstInitiallySelectedItem() {
        const currentItems = collectItems()
        for (let i = 0; i < currentItems.length; i++) {
            const item = currentItems[i]
            if (item && item.selected)
                return item
        }
        return null
    }

    function registerItem(item) {
        if (!item)
            return
        if (item.hierarchyList !== control)
            item.hierarchyList = control
        normalizeActiveItem()
    }

    function requestActivate(item) {
        if (!item || !item.enabled)
            return
        if (item.hierarchyList !== control)
            item.hierarchyList = control

        const index = indexOfItem(item)
        if (index < 0)
            return

        if (activeItem === item && activeItemId === effectiveItemId(item, index))
            return

        activeItem = item
        activeItemId = effectiveItemId(item, index)
        activeChanged(item, activeItemId, index)
    }

    function normalizeActiveItem() {
        const currentItems = collectItems()
        if (currentItems.length === 0) {
            activeItem = null
            activeItemId = -1
            return
        }

        for (let i = 0; i < currentItems.length; i++) {
            const item = currentItems[i]
            if (item && item.hierarchyList !== control)
                item.hierarchyList = control
        }

        let targetItem = activeItem
        if (activeItemId >= 0) {
            const byId = resolveById(activeItemId)
            if (byId)
                targetItem = byId
        }

        if (!targetItem || currentItems.indexOf(targetItem) === -1 || !targetItem.enabled)
            targetItem = firstInitiallySelectedItem()
        if (!targetItem || !targetItem.enabled)
            targetItem = firstEnabledItem()

        const targetIndex = indexOfItem(targetItem)
        activeItem = targetItem
        activeItemId = targetItem ? effectiveItemId(targetItem, targetIndex) : -1
    }

    onActiveItemIdChanged: Qt.callLater(normalizeActiveItem)

    implicitWidth: listColumn.implicitWidth
    implicitHeight: listColumn.implicitHeight

    Column {
        id: listColumn
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: control.rowSpacing
    }

    Connections {
        target: listColumn
        function onChildrenChanged() {
            Qt.callLater(control.normalizeActiveItem)
        }
    }

    QtObject {
        Component.onCompleted: {
            control.normalizeActiveItem()
            Debug.log("HierarchyList", "created")
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.HierarchyList { UIF.HierarchyItem { label: "Root" } UIF.HierarchyItem { label: "Child"; indentLevel: 1 } }
