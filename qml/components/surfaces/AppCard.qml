import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""
    readonly property int cardPadding: 18
    readonly property int sectionSpacing: 10

    default property alias content: contentSlot.data

    implicitWidth: Math.max(
                       280,
                       cardPadding * 2 + Math.max(headerBlock.implicitWidth, contentSlot.childrenRect.width)
                   )
    implicitHeight: cardPadding * 2
                    + headerBlock.implicitHeight
                    + sectionSpacing
                    + separator.height
                    + sectionSpacing
                    + Math.max(1, contentSlot.childrenRect.height)
    clip: true

    radius: Theme.radiusLg
    color: Theme.surfaceSolid
    border.color: Theme.surfaceAlt
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.cardPadding
        spacing: root.sectionSpacing

        ColumnLayout {
            id: headerBlock
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
            id: separator
            Layout.fillWidth: true
            height: 1
            radius: 1
            color: Theme.surfaceSolid
        }

        Item {
            id: contentSlot
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(1, childrenRect.height)
            implicitHeight: Math.max(1, childrenRect.height)
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("AppCard", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppCard { title: "Summary"; subtitle: "Detail" }
