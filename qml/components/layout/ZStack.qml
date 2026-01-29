import QtQuick

Item {
    id: root

    property int alignment: Qt.AlignCenter

    default property alias content: contentLayer.data

    implicitWidth: contentLayer.childrenRect.width
    implicitHeight: contentLayer.childrenRect.height

    Item {
        id: contentLayer
        anchors.fill: parent
    }

    onAlignmentChanged: updateAlignment()
    Component.onCompleted: updateAlignment()

    function updateAlignment() {
        for (var i = 0; i < contentLayer.children.length; i++) {
            var child = contentLayer.children[i]
            if (!child || !child.anchors)
                continue
            child.anchors.left = undefined
            child.anchors.right = undefined
            child.anchors.top = undefined
            child.anchors.bottom = undefined
            child.anchors.horizontalCenter = undefined
            child.anchors.verticalCenter = undefined

            if (root.alignment & Qt.AlignHCenter)
                child.anchors.horizontalCenter = contentLayer.horizontalCenter
            else if (root.alignment & Qt.AlignRight)
                child.anchors.right = contentLayer.right
            else
                child.anchors.left = contentLayer.left

            if (root.alignment & Qt.AlignVCenter)
                child.anchors.verticalCenter = contentLayer.verticalCenter
            else if (root.alignment & Qt.AlignBottom)
                child.anchors.bottom = contentLayer.bottom
            else
                child.anchors.top = contentLayer.top
        }
    }

    Connections {
        target: contentLayer
        function onChildrenChanged() {
            root.updateAlignment()
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ZStack { Rectangle { width: 40; height: 40 } }
