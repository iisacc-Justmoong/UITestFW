import QtQuick
import QtQuick.Controls
import LVRS 1.0

Rectangle {
    id: control

    property int minimumPanelWidth: 200
    property int minimumPanelHeight: 530
    property color panelColor: Theme.subSurface
    property bool clipList: true

    property alias toolbarButtons: toolbar.buttons
    property alias activeToolbarButton: toolbar.activeButton
    property alias activeToolbarButtonId: toolbar.activeButtonId
    property alias activeListItem: hierarchyList.activeItem
    property alias activeListItemId: hierarchyList.activeItemId
    property alias activeListItemKey: hierarchyList.activeItemKey
    property alias model: hierarchyList.model
    property alias treeModel: hierarchyList.model
    property alias autoExpandDepth: hierarchyList.autoExpandDepth
    property alias keyboardListNavigationEnabled: hierarchyList.keyboardNavigationEnabled
    default property alias listItems: hierarchyList.items

    signal toolbarActivated(var button, int buttonId, int index)
    signal listItemActivated(var item, int itemId, int index)
    signal listItemExpanded(var item, int itemId, int index, bool expanded)

    implicitWidth: minimumPanelWidth
    implicitHeight: minimumPanelHeight
    color: panelColor
    clip: true

    function ensureListItemVisible(itemY, itemHeight) {
        const contentTop = listViewport.contentY
        const contentBottom = contentTop + listViewport.height
        const targetTop = Math.max(0, itemY - Theme.gap4)
        const targetBottom = itemY + itemHeight + Theme.gap4

        if (targetTop < contentTop) {
            listViewport.contentY = targetTop
            return
        }

        if (targetBottom > contentBottom) {
            const nextContentY = targetBottom - listViewport.height
            const maxContentY = Math.max(0, listViewport.contentHeight - listViewport.height)
            listViewport.contentY = Math.max(0, Math.min(nextContentY, maxContentY))
        }
    }

    function expandAll() {
        hierarchyList.expandAll()
    }

    function collapseAll(keepRootExpanded) {
        hierarchyList.collapseAll(keepRootExpanded)
    }

    function activateListItemById(itemId) {
        return hierarchyList.activateById(itemId)
    }

    function activateListItemByKey(itemKey) {
        return hierarchyList.activateByKey(itemKey)
    }

    HierarchyToolbar {
        id: toolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 10
        onActiveChanged: function(button, buttonId, index) {
            control.toolbarActivated(button, buttonId, index)
        }
    }

    Flickable {
        id: listViewport
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        clip: control.clipList
        contentWidth: width
        contentHeight: hierarchyList.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        HierarchyList {
            id: hierarchyList
            width: listViewport.width
            onActiveChanged: function(item, itemId, index) {
                control.listItemActivated(item, itemId, index)
            }
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }

    WheelScrollGuard {
        anchors.fill: parent
        targetFlickable: listViewport
        consumeInside: true
    }

    Connections {
        target: hierarchyList
        function onEnsureVisibleRequested(y, height) {
            control.ensureListItemVisible(y, height)
        }
        function onExpansionChanged(item, expanded, index) {
            control.listItemExpanded(item, hierarchyList.effectiveItemId(item, index), index, expanded)
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("Hierarchy", "created")
    }
}

// API usage (external):
// import LVRS 1.0 as LV
// LV.Hierarchy {
//     toolbarButtons: [LV.ToolbarButton { buttonId: 1 }, LV.ToolbarButton { buttonId: 2 }]
//     model: [
//         { key: "root", label: "Root", expanded: true, children: [{ key: "child", label: "Child" }] }
//     ]
// }
