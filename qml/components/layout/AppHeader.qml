import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0

ToolBar {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool menuVisible: false

    signal menuClicked()

    default property alias actions: actionRow.data

    implicitHeight: Theme.headerHeight

    background: Rectangle {
        color: Theme.glass
        border.color: Theme.border
        border.width: 1
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        ToolButton {
            visible: root.menuVisible
            text: "Menu"
            padding: 10

            contentItem: Text {
                text: control.text
                color: Theme.textPrimary
                font.family: Theme.fontBody
                font.pixelSize: 12
                font.weight: Font.Medium
            }

            background: Rectangle {
                radius: Theme.radiusSm
                color: control.down ? Theme.surfaceAlt : Theme.surfaceSolid
                border.color: Theme.border
                border.width: 1
            }

            onClicked: root.menuClicked()
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Label {
                text: root.title
                color: Theme.textPrimary
                font.family: Theme.fontDisplay
                font.pixelSize: 20
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                visible: root.subtitle.length > 0
                text: root.subtitle
                color: Theme.textSecondary
                font.family: Theme.fontBody
                font.pixelSize: 12
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        RowLayout {
            id: actionRow
            spacing: 8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppHeader { title: "Dashboard"; subtitle: "Overview" }
