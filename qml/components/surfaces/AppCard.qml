import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""

    default property alias content: contentSlot.data

    radius: Theme.radiusLg
    color: Theme.surfaceSolid
    border.color: Theme.surfaceAlt
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 10

        ColumnLayout {
            spacing: 4
            Layout.fillWidth: true

            Label {
                text: root.title
                color: Theme.textPrimary
                font.family: Theme.fontDisplay
                font.pixelSize: 17
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

        Rectangle {
            Layout.fillWidth: true
            height: 1
            radius: 1
            color: Theme.surfaceSolid
        }

        Item {
            id: contentSlot
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("AppCard", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppCard { title: "Summary"; subtitle: "Detail" }
