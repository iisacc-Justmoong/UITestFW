import QtQuick
import LVRS 1.0

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

    function resolveRouter() {
        if (router)
            return router
        if (typeof Navigator !== "undefined" && Navigator && Navigator.router)
            return Navigator.router
        return null
    }

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
            var targetRouter = root.resolveRouter()
            if (!targetRouter)
                return
            if (root.targetComponent) {
                if (root.replace)
                    targetRouter.replaceWith(root.targetComponent, root.params)
                else
                    targetRouter.goTo(root.targetComponent, root.params)
                return
            }
            if (!root.href)
                return
            if (root.replace)
                targetRouter.replace(root.href, root.params)
            else
                targetRouter.go(root.href, root.params)
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("LinkWrapper", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.LinkWrapper { href: "/b"; Rectangle { width: 120; height: 40 } }
