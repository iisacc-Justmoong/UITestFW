import QtQuick
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
    property int maxWidth: 360
    property int minWidth: 280

    signal primaryClicked()
    signal secondaryClicked()
    signal dismissed()

    visible: open
    enabled: open
    anchors.fill: parent


    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)
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
        width: Math.min(root.maxWidth, Math.max(root.minWidth, root.width - 48))
        radius: Theme.radiusLg
        color: Theme.surfaceSolid
        border.color: Theme.border
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Label {
                    text: root.title
                    visible: root.title.length > 0
                    color: Theme.textPrimary
                    font.family: Theme.fontDisplay
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    text: root.message
                    visible: root.message.length > 0
                    color: Theme.textSecondary
                    font.family: Theme.fontBody
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                radius: 1
                color: Theme.borderSoft
                visible: root.primaryText.length > 0 || root.secondaryText.length > 0
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                visible: root.primaryText.length > 0 || root.secondaryText.length > 0
                Layout.alignment: Qt.AlignRight

                AbstractButton {
                    id: secondaryButton
                    visible: root.secondaryText.length > 0
                    text: root.secondaryText
                    enabled: root.secondaryEnabled
                    Layout.preferredWidth: 100
                    backgroundColor: "transparent"
                    backgroundColorHover: Theme.surfaceAlt
                    backgroundColorPressed: Theme.surfaceAlt
                    borderColor: Theme.border
                    onClicked: root.secondaryClicked()
                }

                AbstractButton {
                    id: primaryButton
                    text: root.primaryText
                    enabled: root.primaryEnabled
                    Layout.preferredWidth: 100
                    backgroundColor: Theme.accent
                    backgroundColorHover: Theme.accent
                    backgroundColorPressed: Theme.accentMuted
                    textColor: Theme.onAccent
                    borderWidth: 0
                    onClicked: root.primaryClicked()
                }
            }
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Alert { open: true; title: "Delete?"; message: "This cannot be undone." }
