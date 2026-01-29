pragma Singleton
import QtQuick

QtObject {
    readonly property bool dark: true

    readonly property string fontBody: Qt.platform.os === "osx" ? "SF Pro Text" : Qt.application.font.family
    readonly property string fontDisplay: Qt.platform.os === "osx" ? "SF Pro Display" : Qt.application.font.family

    readonly property color window: "#0e0f12"
    readonly property color windowAlt: "#13161c"
    readonly property color surfaceSolid: "#1b1f26"
    readonly property color surfaceAlt: "#15181f"
    readonly property color glass: Qt.rgba(0.12, 0.14, 0.18, 0.75)

    readonly property color border: "#2c323c"
    readonly property color borderSoft: "#232730"

    readonly property color textPrimary: "#f5f5f7"
    readonly property color textSecondary: "#b2b7c2"
    readonly property color textTertiary: "#8c909a"

    readonly property color accent: "#0a84ff"
    readonly property color accentMuted: "#15335f"
    readonly property color accentGlow: Qt.rgba(0.2, 0.5, 1.0, 0.3)
    readonly property color onAccent: "#ffffff"

    readonly property color success: "#32d74b"
    readonly property color warning: "#ffd60a"
    readonly property color danger: "#ff453a"

    readonly property int radiusSm: 10
    readonly property int radiusMd: 14
    readonly property int radiusLg: 18
    readonly property int radiusXl: 24

    readonly property int headerHeight: 64
    readonly property int pageMargin: 16
    readonly property int contentMargin: 24
}

// API usage (external):
// import UIFramework 1.0 as UIF
// Rectangle { color: UIF.Theme.window }
