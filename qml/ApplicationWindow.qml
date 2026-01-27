import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Window
import UIFramework 1.0

Controls.ApplicationWindow {
    id: root

    // Platform + size-class signals to mimic media-query style rules.
    readonly property string platform: Qt.platform.os
    readonly property bool isMobilePlatform: platform === "android" || platform === "ios"
    readonly property bool isDesktopPlatform: platform === "osx" || platform === "windows" || platform === "linux"

    readonly property int Compact: 0
    readonly property int Medium: 1
    readonly property int Expanded: 2

    readonly property int widthClass: width < 600 ? Compact : (width < 1000 ? Medium : Expanded)
    readonly property int heightClass: height < 600 ? Compact : (height < 900 ? Medium : Expanded)

    readonly property bool isCompact: widthClass === Compact || heightClass === Compact
    readonly property bool isExpanded: widthClass === Expanded && heightClass === Expanded

    property string styleSheet: ""
    property url styleSheetUrl: ""

    property int desktopMinWidth: 900
    property int desktopMinHeight: 600
    property int mobileMinWidth: 360
    property int mobileMinHeight: 640
    // Keep view composition identical across platforms; only apply when explicitly enabled.
    property bool usePlatformSafeMargin: false
    property int safeMargin: usePlatformSafeMargin && isMobilePlatform ? 12 : 0

    minimumWidth: isMobilePlatform ? mobileMinWidth : desktopMinWidth
    minimumHeight: isMobilePlatform ? mobileMinHeight : desktopMinHeight

    default property alias content: contentSlot.data

    onStyleSheetChanged: Theme.applyCss(styleSheet)
    onStyleSheetUrlChanged: Theme.loadCss(styleSheetUrl)

    function matchesMedia(rule) {
        if (!rule)
            return true
        var token = String(rule).toLowerCase()
        if (token === "mobile")
            return isMobilePlatform
        if (token === "desktop")
            return isDesktopPlatform
        if (token === "compact")
            return isCompact
        if (token === "expanded")
            return isExpanded
        if (token === "medium")
            return widthClass === Medium || heightClass === Medium
        return false
    }

    contentItem: Item {
        anchors.fill: parent
        anchors.margins: root.safeMargin

        Item {
            id: contentSlot
            anchors.fill: parent
        }
    }
}
