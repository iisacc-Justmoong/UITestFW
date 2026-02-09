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

    implicitHeight: Math.max(Theme.headerMinHeight, contentRow.implicitHeight + Theme.headerExtraHeight)


    background: Rectangle {
        color: Theme.windowAlt
        border.color: Theme.surfaceAlt
        border.width: Theme.strokeThin
    }

    RowLayout {
        id: contentRow
        anchors.fill: parent
        anchors.margins: Theme.gap16
        spacing: Theme.gap12

        ToolButton {
            id: menuButton
            visible: root.menuVisible
            text: "Menu"
            padding: Theme.gap10

            contentItem: Text {
                text: menuButton.text
                color: Theme.textPrimary
                font.family: Theme.fontBody
                font.pixelSize: Theme.textDescription
                font.weight: Theme.textDescriptionWeight
            }

            background: Rectangle {
                radius: Theme.radiusSm
                color: menuButton.down ? Theme.surfaceAlt : Theme.surfaceSolid
                border.color: Theme.surfaceAlt
                border.width: Theme.strokeThin
            }

            onClicked: {
                root.menuClicked()
            }
        }

        ColumnLayout {
            spacing: Theme.gap2
            Layout.fillWidth: true

            Label {
                text: root.title
                color: Theme.textPrimary
                font.family: Theme.fontDisplay
                font.pixelSize: Theme.textDisplay
                font.weight: Theme.textDisplayWeight
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                visible: root.subtitle.length > 0
                text: root.subtitle
                color: Theme.textSecondary
                font.family: Theme.fontBody
                font.pixelSize: Theme.textDescription
                font.weight: Theme.textDescriptionWeight
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        RowLayout {
            id: actionRow
            spacing: Theme.gap8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("AppHeader", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppHeader { title: "Dashboard"; subtitle: "Overview" }
