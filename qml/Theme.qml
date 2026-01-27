pragma Singleton
import QtQuick

QtObject {
    readonly property bool dark: Qt.application.colorScheme === Qt.ColorScheme.Dark

    property var overrides: ({})

    property string fontBody: overrides.fontBody !== undefined
        ? overrides.fontBody
        : (Qt.platform.os === "osx" ? "SF Pro Text" : Qt.application.font.family)
    property string fontDisplay: overrides.fontDisplay !== undefined
        ? overrides.fontDisplay
        : (Qt.platform.os === "osx" ? "SF Pro Display" : Qt.application.font.family)

    property color window: overrides.window !== undefined ? overrides.window : (dark ? "#0e0f12" : "#f5f5f7")
    property color windowAlt: overrides.windowAlt !== undefined ? overrides.windowAlt : (dark ? "#13161c" : "#eceff3")
    property color surfaceSolid: overrides.surfaceSolid !== undefined ? overrides.surfaceSolid : (dark ? "#1b1f26" : "#ffffff")
    property color surfaceAlt: overrides.surfaceAlt !== undefined ? overrides.surfaceAlt : (dark ? "#15181f" : "#f0f2f6")
    property color glass: overrides.glass !== undefined
        ? overrides.glass
        : (dark ? Qt.rgba(0.12, 0.14, 0.18, 0.75) : Qt.rgba(1, 1, 1, 0.7))

    property color border: overrides.border !== undefined ? overrides.border : (dark ? "#2c323c" : "#d4d7dd")
    property color borderSoft: overrides.borderSoft !== undefined ? overrides.borderSoft : (dark ? "#232730" : "#e4e6ea")

    property color textPrimary: overrides.textPrimary !== undefined ? overrides.textPrimary : (dark ? "#f5f5f7" : "#1d1d1f")
    property color textSecondary: overrides.textSecondary !== undefined ? overrides.textSecondary : (dark ? "#b2b7c2" : "#5c5f66")
    property color textTertiary: overrides.textTertiary !== undefined ? overrides.textTertiary : (dark ? "#8c909a" : "#7a7d83")

    property color accent: overrides.accent !== undefined ? overrides.accent : (dark ? "#0a84ff" : "#007aff")
    property color accentMuted: overrides.accentMuted !== undefined ? overrides.accentMuted : (dark ? "#15335f" : "#d9e8ff")
    property color accentGlow: overrides.accentGlow !== undefined
        ? overrides.accentGlow
        : (dark ? Qt.rgba(0.2, 0.5, 1.0, 0.3) : Qt.rgba(0.2, 0.5, 1.0, 0.2))
    property color onAccent: overrides.onAccent !== undefined ? overrides.onAccent : "#ffffff"

    property color success: overrides.success !== undefined ? overrides.success : (dark ? "#32d74b" : "#34c759")
    property color warning: overrides.warning !== undefined ? overrides.warning : (dark ? "#ffd60a" : "#ff9f0a")
    property color danger: overrides.danger !== undefined ? overrides.danger : (dark ? "#ff453a" : "#ff3b30")

    property int radiusSm: overrides.radiusSm !== undefined ? overrides.radiusSm : 10
    property int radiusMd: overrides.radiusMd !== undefined ? overrides.radiusMd : 14
    property int radiusLg: overrides.radiusLg !== undefined ? overrides.radiusLg : 18
    property int radiusXl: overrides.radiusXl !== undefined ? overrides.radiusXl : 24

    property int headerHeight: overrides.headerHeight !== undefined ? overrides.headerHeight : 64
    property int pageMargin: overrides.pageMargin !== undefined ? overrides.pageMargin : 16
    property int contentMargin: overrides.contentMargin !== undefined ? overrides.contentMargin : 24

    function reset() {
        overrides = {}
    }

    function set(key, value) {
        if (!key)
            return
        var next = {}
        for (var existing in overrides)
            next[existing] = overrides[existing]
        next[key] = value
        overrides = next
    }

    function apply(values) {
        if (!values)
            return
        var next = {}
        for (var existing in overrides)
            next[existing] = overrides[existing]
        for (var key in values)
            next[key] = values[key]
        overrides = next
    }

    function applyCss(cssText) {
        if (!cssText)
            return
        var text = cssText.replace(/\/\*[\s\S]*?\*\//g, "")
        text = text.replace(/[^{}]+{/g, "")
        text = text.replace(/[{}]/g, "\n")
        var segments = text.split(";")
        var updates = {}
        for (var i = 0; i < segments.length; i++) {
            var line = segments[i].trim()
            if (!line)
                continue
            var colon = line.indexOf(":")
            if (colon <= 0)
                continue
            var rawKey = line.slice(0, colon).trim()
            var rawValue = line.slice(colon + 1).trim()
            if (!rawKey || !rawValue)
                continue
            if (rawKey.startsWith("@"))
                continue
            var key = normalizeKey(rawKey)
            if (!key)
                continue
            var value = parseValue(rawValue)
            if (value === undefined)
                continue
            updates[key] = value
        }
        apply(updates)
    }

    function loadCss(sourceUrl) {
        if (!sourceUrl)
            return
        var resolved = Qt.resolvedUrl(sourceUrl)
        var xhr = new XMLHttpRequest()
        xhr.open("GET", resolved)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0)
                    applyCss(xhr.responseText)
            }
        }
        xhr.send()
    }

    function normalizeKey(key) {
        var cleaned = key.trim()
        if (cleaned.startsWith("--"))
            cleaned = cleaned.slice(2)
        if (!cleaned)
            return ""
        var parts = cleaned.split("-")
        if (parts.length === 1)
            return parts[0]
        var camel = parts[0]
        for (var i = 1; i < parts.length; i++) {
            if (!parts[i])
                continue
            camel += parts[i].charAt(0).toUpperCase() + parts[i].slice(1)
        }
        return camel
    }

    function parseValue(value) {
        var cleaned = value.trim()
        if (!cleaned)
            return undefined
        if ((cleaned.startsWith("\"") && cleaned.endsWith("\"")) || (cleaned.startsWith("'") && cleaned.endsWith("'")))
            cleaned = cleaned.slice(1, -1)
        if (cleaned === "true" || cleaned === "false")
            return cleaned === "true"
        if (/^-?\d+(\.\d+)?px$/.test(cleaned))
            return Number(cleaned.slice(0, -2))
        if (/^-?\d+(\.\d+)?$/.test(cleaned))
            return Number(cleaned)
        var rgbMatch = cleaned.match(/^rgba?\(([^)]+)\)$/i)
        if (rgbMatch) {
            var parts = rgbMatch[1].split(",")
            if (parts.length >= 3) {
                var r = Number(parts[0].trim())
                var g = Number(parts[1].trim())
                var b = Number(parts[2].trim())
                var a = parts.length > 3 ? Number(parts[3].trim()) : 1
                var max = Math.max(r, g, b)
                if (max > 1) {
                    r = r / 255
                    g = g / 255
                    b = b / 255
                }
                if (a > 1)
                    a = 1
                return Qt.rgba(r, g, b, a)
            }
        }
        return cleaned
    }
}
