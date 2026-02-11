import QtQuick
import LVRS 1.0

AbstractButton {
    id: control

    property var router: null
    property string href: "/"
    property var params: ({})
    property bool replace: false
    property var targetComponent: null

    property color linkColor: Theme.accent
    property color hoverColor: Theme.textPrimary
    property color disabledColor: Theme.textTertiary
    property bool underline: false

    default property alias content: contentSlot.data

    hoverEnabled: true
    background: Item { }

    function resolveRouter() {
        if (router)
            return router
        if (typeof Navigator !== "undefined" && Navigator && Navigator.router)
            return Navigator.router
        return null
    }

    onClicked: {
        var targetRouter = resolveRouter()
        if (!targetRouter)
            return
        if (targetComponent) {
            if (replace)
                targetRouter.replaceWith(targetComponent, params)
            else
                targetRouter.goTo(targetComponent, params)
            return
        }
        if (!href)
            return
        if (replace)
            targetRouter.replace(href, params)
        else
            targetRouter.go(href, params)
    }

    contentItem: Item {
        id: contentRoot
        implicitWidth: Math.max(textFallback.implicitWidth, contentSlot.childrenRect.width)
        implicitHeight: Math.max(textFallback.implicitHeight, contentSlot.childrenRect.height)

        Item {
            id: contentSlot
            anchors.fill: parent
        }

        Label {
            style: description
            id: textFallback
            visible: contentSlot.children.length === 0
            text: control.text
            color: control.enabled
                ? (control.hovered ? control.hoverColor : control.linkColor)
                : control.disabledColor
            font.underline: control.underline
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("Link", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.Link { href: "/reports"; UIF.Label { text: "Reports"; style: description } }
