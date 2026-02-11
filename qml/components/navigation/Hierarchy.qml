import QtQuick
import QtQuick.Controls
import UIFramework 1.0

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
    default property alias listItems: hierarchyList.items

    signal toolbarActivated(var button, int buttonId, int index)
    signal listItemActivated(var item, int itemId, int index)

    implicitWidth: minimumPanelWidth
    implicitHeight: minimumPanelHeight
    color: panelColor
    clip: true

    HierarchyToolbar {
        id: toolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 10
        onActiveChanged: control.toolbarActivated(button, buttonId, index)
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
            onActiveChanged: control.listItemActivated(item, itemId, index)
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("Hierarchy", "created")
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Hierarchy {
//     toolbarButtons: [UIF.ToolbarButton { buttonId: 1 }, UIF.ToolbarButton { buttonId: 2 }]
//     UIF.HierarchyItem { label: "Root"; showChevron: true }
//     UIF.HierarchyItem { label: "Child"; indentLevel: 1 }
// }
