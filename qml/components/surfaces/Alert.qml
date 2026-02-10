import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0

Item {
    id: root

    property bool open: false
    property string title: ""
    property string message: ""
    property string primaryText: "OK"
    property string secondaryText: ""
    property bool primaryEnabled: true
    property bool secondaryEnabled: true
    property bool dismissOnBackground: false
    property int maxWidth: Theme.dialogMaxWidth
    property int minWidth: Theme.dialogMinWidth

    signal primaryClicked()
    signal secondaryClicked()
    signal dismissed()

    visible: open
    enabled: open
    anchors.fill: parent


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
        width: Math.min(root.maxWidth, Math.max(root.minWidth, root.width - (Theme.gap24 * 2)))
        radius: Theme.radiusLg
        color: Theme.surfaceSolid
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.gap20
            spacing: Theme.gap12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.gap6

                Label {
                    style: header2
                    text: root.title
                    visible: root.title.length > 0
                    color: Theme.textPrimary
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    style: description
                    text: root.message
                    visible: root.message.length > 0
                    color: Theme.textSecondary
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: Theme.strokeThin
                radius: Theme.strokeThin
                color: Theme.surfaceSolid
                visible: root.primaryText.length > 0 || root.secondaryText.length > 0
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.gap8
                visible: root.primaryText.length > 0 || root.secondaryText.length > 0
                Layout.alignment: Qt.AlignRight

                AbstractButton {
                    id: secondaryButton
                    visible: root.secondaryText.length > 0
                    text: root.secondaryText
                    enabled: root.secondaryEnabled
                    Layout.preferredWidth: Theme.buttonMinWidth
                    backgroundColor: "transparent"
                    backgroundColorHover: Theme.surfaceAlt
                    backgroundColorPressed: Theme.surfaceAlt
                    onClicked: root.secondaryClicked()
                }

                AbstractButton {
                    id: primaryButton
                    text: root.primaryText
                    enabled: root.primaryEnabled
                    Layout.preferredWidth: Theme.buttonMinWidth
                    backgroundColor: Theme.accent
                    backgroundColorHover: Theme.accent
                    backgroundColorPressed: Theme.accent
                    textColor: Theme.textPrimary
                    onClicked: root.primaryClicked()
                }
            }
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("Alert", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Alert { open: true; title: "Delete?"; message: "This cannot be undone." }
