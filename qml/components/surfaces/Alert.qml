import QtQuick
import QtQuick.Controls as Controls
import UIFramework 1.0

Item {
    id: root

    property bool open: false
    property string title: "Alert Dialog"
    property string message: "It can have 2 or 3 actions depending on your needs."
    property string primaryText: "Button"
    property string secondaryText: "Button"
    property string tertiaryText: ""
    property bool primaryEnabled: true
    property bool secondaryEnabled: true
    property bool tertiaryEnabled: true
    property bool dismissOnBackground: false
    property bool useOverlayLayer: true
    property int maxWidth: Theme.dialogMaxWidth
    property int minWidth: Theme.dialogMinWidth

    readonly property int preferredWidth: 328
    readonly property int sidePadding: Theme.gap24
    readonly property bool hasSecondaryAction: root.secondaryText.length > 0
    readonly property bool hasTertiaryAction: root.tertiaryText.length > 0
    readonly property bool useVerticalActionLayout: root.hasTertiaryAction

    signal primaryClicked()
    signal secondaryClicked()
    signal tertiaryClicked()
    signal dismissed()

    visible: open
    enabled: open
    anchors.fill: parent
    z: 1000

    property Item _fallbackParent: null

    function refreshLayerParent() {
        const overlayParent = Controls.Overlay.overlay
        const targetParent = useOverlayLayer && overlayParent ? overlayParent : _fallbackParent
        if (targetParent && parent !== targetParent)
            parent = targetParent
    }

    onOpenChanged: {
        if (open)
            refreshLayerParent()
    }

    onParentChanged: {
        if (parent && parent !== Controls.Overlay.overlay)
            _fallbackParent = parent
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.overlayBackdrop
        visible: root.open

        MouseArea {
            anchors.fill: parent
            enabled: root.dismissOnBackground
            onClicked: {
                root.open = false
                root.dismissed()
            }
        }
    }

    Rectangle {
        id: alertCard
        width: Math.min(root.maxWidth,
                        Math.max(root.minWidth,
                                 Math.min(root.preferredWidth,
                                          root.width - (root.sidePadding * 2))))
        radius: Theme.radiusLg
        color: "#282828"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.gap8
            topPadding: 32

            Item {
                width: parent.width
                height: 64

                Rectangle {
                    width: 48
                    height: 48
                    radius: 10
                    anchors.centerIn: parent
                    color: "#C9D4DB"
                    border.width: 4
                    border.color: "#E8F0F5"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: 8
                        color: "#D8E0E6"
                        opacity: 0.42
                    }
                }
            }

            Item {
                width: parent.width
                implicitHeight: textColumn.implicitHeight

                Column {
                    id: textColumn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - (Theme.gap24 * 2)
                    spacing: Theme.gap12

                    Label {
                        style: title2
                        text: root.title
                        visible: root.title.length > 0
                        color: Theme.textPrimary
                        wrapMode: Text.WordWrap
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        style: body
                        text: root.message
                        visible: root.message.length > 0
                        color: Theme.textSecondary
                        wrapMode: Text.WordWrap
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Item {
                width: parent.width
                readonly property real actionContentHeight: root.useVerticalActionLayout
                    ? verticalActions.implicitHeight
                    : root.hasSecondaryAction
                        ? horizontalActions.implicitHeight
                        : singleActionButton.implicitHeight
                implicitHeight: actionContentHeight + (Theme.gap24 * 2)

                Column {
                    id: verticalActions
                    visible: root.useVerticalActionLayout
                    x: Theme.gap24
                    y: Theme.gap24
                    width: parent.width - (Theme.gap24 * 2)
                    spacing: Theme.gap12

                    AlertButton {
                        visible: root.primaryText.length > 0
                        width: parent.width
                        text: root.primaryText
                        tone: AbstractButton.Accent
                        enabled: root.primaryEnabled
                        onClicked: root.primaryClicked()
                    }

                    AlertButton {
                        visible: root.hasSecondaryAction
                        width: parent.width
                        text: root.secondaryText
                        tone: AbstractButton.Default
                        enabled: root.secondaryEnabled
                        onClicked: root.secondaryClicked()
                    }

                    AlertButton {
                        visible: root.hasTertiaryAction
                        width: parent.width
                        text: root.tertiaryText
                        tone: AbstractButton.Default
                        enabled: root.tertiaryEnabled
                        onClicked: root.tertiaryClicked()
                    }
                }

                Row {
                    id: horizontalActions
                    visible: !root.useVerticalActionLayout && root.hasSecondaryAction
                    x: Theme.gap24
                    y: Theme.gap24
                    width: parent.width - (Theme.gap24 * 2)
                    spacing: Theme.gap12
                    readonly property real buttonWidth: (width - spacing) / 2

                    AlertButton {
                        width: horizontalActions.buttonWidth
                        text: root.primaryText
                        tone: AbstractButton.Accent
                        enabled: root.primaryEnabled
                        onClicked: root.primaryClicked()
                    }

                    AlertButton {
                        width: horizontalActions.buttonWidth
                        visible: root.hasSecondaryAction
                        text: root.secondaryText
                        tone: AbstractButton.Default
                        enabled: root.secondaryEnabled
                        onClicked: root.secondaryClicked()
                    }
                }

                AlertButton {
                    id: singleActionButton
                    visible: !root.useVerticalActionLayout && !root.hasSecondaryAction && root.primaryText.length > 0
                    x: Theme.gap24
                    y: Theme.gap24
                    width: parent.width - (Theme.gap24 * 2)
                    text: root.primaryText
                    tone: AbstractButton.Accent
                    enabled: root.primaryEnabled
                    onClicked: root.primaryClicked()
                }
            }
        }
    }

    QtObject {
        Component.onCompleted: {
            root._fallbackParent = root.parent
            root.refreshLayerParent()
            Qt.callLater(root.refreshLayerParent)
            Debug.log("Alert", "created")
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Alert {
//     open: true
//     title: "Alert Dialog"
//     message: "It can have 2 or 3 actions depending on your needs."
//     primaryText: "Button"
//     secondaryText: "Button"
//     tertiaryText: "Button"
// }
