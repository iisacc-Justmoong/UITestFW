import QtQuick
import LVRS 1.0

Item {
    id: control

    property color dividerColor: Theme.surface
    property int thickness: 1
    property int verticalPadding: 1

    implicitWidth: 220
    implicitHeight: thickness + (verticalPadding * 2)

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: control.thickness
        color: control.dividerColor
    }

    QtObject {
        Component.onCompleted: Debug.log("MenuDivider", "created")
    }
}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.MenuDivider { }
