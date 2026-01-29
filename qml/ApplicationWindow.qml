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

    readonly property int compact: 0
    readonly property int medium: 1
    readonly property int expanded: 2

    readonly property int widthClass: width < 600 ? compact : (width < 1000 ? medium : expanded)
    readonly property int heightClass: height < 600 ? compact : (height < 900 ? medium : expanded)

    readonly property bool isCompact: widthClass === compact || heightClass === compact
    readonly property bool isExpanded: widthClass === expanded && heightClass === expanded


    property int desktopMinWidth: 900
    property int desktopMinHeight: 600
    property int mobileMinWidth: 360
    property int mobileMinHeight: 640
    // Keep view composition identical across platforms; only apply when explicitly enabled.
    property bool usePlatformSafeMargin: false
    property int safeMargin: usePlatformSafeMargin && isMobilePlatform ? 12 : 0

    minimumWidth: isMobilePlatform ? mobileMinWidth : desktopMinWidth
    minimumHeight: isMobilePlatform ? mobileMinHeight : desktopMinHeight

    default property alias content: root.contentItem.data

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
            return widthClass === medium || heightClass === medium
        return false
    }

    padding: root.safeMargin
    QtObject {
        Component.onCompleted: Debug.log("ApplicationWindow", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ApplicationWindow { title: "App" }
