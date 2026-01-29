import QtQuick
import UIFramework 1.0

Item {
    id: root

    property var router: null
    property string href: "/"
    property var params: ({})
    property bool replace: false
    property var targetComponent: null

    default property alias content: contentSlot.data

    implicitWidth: contentSlot.childrenRect.width
    implicitHeight: contentSlot.childrenRect.height

    Item {
        id: contentSlot
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true
        onClicked: function(mouse) {
            if (!root.router)
                return
            if (root.targetComponent) {
                if (root.replace)
                    root.router.replaceWith(root.targetComponent, root.params)
                else
                    root.router.goTo(root.targetComponent, root.params)
                return
            }
            if (!root.href)
                return
            if (root.replace)
                root.router.replace(root.href, root.params)
            else
                root.router.go(root.href, root.params)
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("LinkWrapper", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.LinkWrapper { router: pageRouter; href: "/b"; Rectangle { width: 120; height: 40 } }
