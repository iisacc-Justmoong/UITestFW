pragma Singleton
import QtQuick

QtObject {
    readonly property bool dark: true

    readonly property string fontBody: Qt.platform.os === "osx" ? "SF Pro Text" : Qt.application.font.family
    readonly property string fontDisplay: Qt.platform.os === "osx" ? "SF Pro Display" : Qt.application.font.family

    //Window

    readonly property color window: "#0e0f12"
    readonly property color windowAlt: "#13161c"
    readonly property color surfaceSolid: "#38383c"
    readonly property color surfaceAlt: "#44444b"

    //Text

    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#F6F5F4"
    readonly property color textTertiary: "#DEDDDA"
    readonly property color textSeptenary: "C0BFBC"
    readonly property color textOctonary: "9A9996"

    //Primary

    readonly property color accent: "#007aff"
    readonly property color success: "#32d74b"
    readonly property color warning: "#ffd60a"
    readonly property color danger: "#ff453a"

    //Radius

    readonly property int radiusSm: 4
    readonly property int radiusMd: 8
    readonly property int radiusLg: 12
    readonly property int radiusXl: 16

    //TextSize

    readonly property int textTitle: 26
    readonly property int textTitle2: 22
    readonly property int textHeader: 17
    readonly property int textHeader2: 15
    readonly property int textBody: 13
    readonly property int textDescription: 12
    readonly property int textCaption: 11
}


// API usage (external):
// import UIFramework 1.0 as UIF
// Rectangle { color: UIF.Theme.window }
