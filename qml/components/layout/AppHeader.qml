import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LVRS 1.0

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

            contentItem: Label {
                style: description
                text: menuButton.text
                color: Theme.textPrimary
            }

            background: Rectangle {
                radius: Theme.radiusSm
                color: menuButton.down ? Theme.surfaceAlt : Theme.surfaceSolid
            }

            onClicked: {
                root.menuClicked()
            }
        }

        ColumnLayout {
            spacing: Theme.gap2
            Layout.fillWidth: true

            Label {
                style: title2
                text: root.title
                color: Theme.textPrimary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                style: description
                visible: root.subtitle.length > 0
                text: root.subtitle
                color: Theme.textSecondary
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

}

// API usage (external):
// import LVRS 1.0 as LV
// LV.AppHeader { title: "Dashboard"; subtitle: "Overview" }
