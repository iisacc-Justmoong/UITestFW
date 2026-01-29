import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property int spacing: 8
    property int alignment: Qt.AlignVCenter

    default property alias content: contentRow.data

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    RowLayout {
        id: contentRow
        anchors.fill: parent
        spacing: root.spacing
    }

    onAlignmentChanged: updateAlignment()
    Component.onCompleted: updateAlignment()

    function updateAlignment() {
        for (var i = 0; i < contentRow.children.length; i++) {
            var child = contentRow.children[i]
            if (!child || child.Layout === undefined)
                continue
            child.Layout.alignment = root.alignment
        }
    }

    Connections {
        target: contentRow
        function onChildrenChanged() {
            root.updateAlignment()
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.HStack { spacing: 12; Text { text: "Left" }; Text { text: "Right" } }
