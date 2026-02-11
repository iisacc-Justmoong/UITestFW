import QtQuick
import UIFramework 1.0

Item {
    id: control

    property int rowSpacing: 0

    default property alias items: listColumn.data

    implicitWidth: listColumn.implicitWidth
    implicitHeight: listColumn.implicitHeight

    Column {
        id: listColumn
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: control.rowSpacing
    }

    QtObject {
        Component.onCompleted: Debug.log("HierarchyList", "created")
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.HierarchyList { UIF.HierarchyItem { label: "Root" } UIF.HierarchyItem { label: "Child"; indentLevel: 1 } }
