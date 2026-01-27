pragma Singleton
import QtQuick

QtObject {
    readonly property bool dark: Qt.application.colorScheme === Qt.ColorScheme.Dark

    readonly property string fontBody: Qt.platform.os === "osx" ? "SF Pro Text" : Qt.application.font.family
    readonly property string fontDisplay: Qt.platform.os === "osx" ? "SF Pro Display" : Qt.application.font.family

    readonly property color window: dark ? "#0e0f12" : "#f5f5f7"
    readonly property color windowAlt: dark ? "#13161c" : "#eceff3"
    readonly property color surfaceSolid: dark ? "#1b1f26" : "#ffffff"
    readonly property color surfaceAlt: dark ? "#15181f" : "#f0f2f6"
    readonly property color glass: dark ? Qt.rgba(0.12, 0.14, 0.18, 0.75) : Qt.rgba(1, 1, 1, 0.7)

    readonly property color border: dark ? "#2c323c" : "#d4d7dd"
    readonly property color borderSoft: dark ? "#232730" : "#e4e6ea"

    readonly property color textPrimary: dark ? "#f5f5f7" : "#1d1d1f"
    readonly property color textSecondary: dark ? "#b2b7c2" : "#5c5f66"
    readonly property color textTertiary: dark ? "#8c909a" : "#7a7d83"

    readonly property color accent: dark ? "#0a84ff" : "#007aff"
    readonly property color accentMuted: dark ? "#15335f" : "#d9e8ff"
    readonly property color accentGlow: dark ? Qt.rgba(0.2, 0.5, 1.0, 0.3) : Qt.rgba(0.2, 0.5, 1.0, 0.2)
    readonly property color onAccent: "#ffffff"

    readonly property color success: dark ? "#32d74b" : "#34c759"
    readonly property color warning: dark ? "#ffd60a" : "#ff9f0a"
    readonly property color danger: dark ? "#ff453a" : "#ff3b30"

    readonly property int radiusSm: 10
    readonly property int radiusMd: 14
    readonly property int radiusLg: 18
    readonly property int radiusXl: 24

    readonly property int headerHeight: 64
    readonly property int pageMargin: 16
    readonly property int contentMargin: 24
}
