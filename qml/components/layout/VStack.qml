import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property int spacing: 8
    property int alignment: Qt.AlignHCenter

    default property alias content: contentColumn.data

    implicitWidth: contentColumn.implicitWidth
    implicitHeight: contentColumn.implicitHeight

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        spacing: root.spacing
    }

    onAlignmentChanged: updateAlignment()
    Component.onCompleted: updateAlignment()

    function updateAlignment() {
        for (var i = 0; i < contentColumn.children.length; i++) {
            var child = contentColumn.children[i]
            if (!child || child.Layout === undefined)
                continue
            child.Layout.alignment = root.alignment
        }
    }

    Connections {
        target: contentColumn
        function onChildrenChanged() {
            root.updateAlignment()
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.VStack { spacing: 8; Text { text: "Title" } }
