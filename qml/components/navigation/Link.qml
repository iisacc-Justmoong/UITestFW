import QtQuick
import UIFramework 1.0

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
    cursorShape: Qt.PointingHandCursor
    background: Item { }

    onClicked: {
        if (!router)
            return
        if (targetComponent) {
            if (replace)
                router.replaceWith(targetComponent, params)
            else
                router.goTo(targetComponent, params)
            return
        }
        if (!href)
            return
        if (replace)
            router.replace(href, params)
        else
            router.go(href, params)
    }

    contentItem: Item {
        id: contentRoot
        implicitWidth: Math.max(textFallback.implicitWidth, contentSlot.childrenRect.width)
        implicitHeight: Math.max(textFallback.implicitHeight, contentSlot.childrenRect.height)

        Item {
            id: contentSlot
            anchors.fill: parent
        }

        Text {
            id: textFallback
            visible: contentSlot.children.length === 0
            text: control.text
            color: control.enabled
                ? (control.hovered ? control.hoverColor : control.linkColor)
                : control.disabledColor
            font.family: Theme.fontBody
            font.pixelSize: 12
            font.weight: Font.Medium
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
// import UIFramework 1.0 as UIF
// UIF.Link { href: "/reports"; router: pageRouter; Text { text: "Reports" } }
