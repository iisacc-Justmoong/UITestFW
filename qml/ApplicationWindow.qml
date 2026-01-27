import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Window
import UIFramework 1.0

Controls.ApplicationWindow {
    id: root

    readonly property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"

    property string styleSheet: ""
    property url styleSheetUrl: ""

    property int desktopMinWidth: 900
    property int desktopMinHeight: 600
    property int mobileMinWidth: 360
    property int mobileMinHeight: 640
    property int safeMargin: isMobile ? 12 : 0

    minimumWidth: isMobile ? mobileMinWidth : desktopMinWidth
    minimumHeight: isMobile ? mobileMinHeight : desktopMinHeight

    default property alias content: contentSlot.data

    color: Theme.window
    font.family: Theme.fontBody

    palette.window: Theme.window
    palette.windowText: Theme.textPrimary
    palette.base: Theme.surfaceSolid
    palette.alternateBase: Theme.surfaceAlt
    palette.text: Theme.textPrimary
    palette.button: Theme.surfaceSolid
    palette.buttonText: Theme.textPrimary
    palette.highlight: Theme.accent
    palette.highlightedText: Theme.onAccent

    onStyleSheetChanged: Theme.applyCss(styleSheet)
    onStyleSheetUrlChanged: Theme.loadCss(styleSheetUrl)

    contentItem: Item {
        anchors.fill: parent
        anchors.margins: root.safeMargin

        Item {
            id: contentSlot
            anchors.fill: parent
        }
    }
}
