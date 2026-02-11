pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework as UIF

UIF.ApplicationWindow {
    id: root
    visible: true
    width: 1480
    height: 980
    title: ""

    property bool alertOpen: false
    property int eventClickCount: 0
    property int eventPressCount: 0
    property int eventReleaseCount: 0
    property int eventEnterCount: 0
    property int eventExitCount: 0
    property int eventHoverChangeCount: 0
    property int eventKeyPressCount: 0
    property int eventKeyReleaseCount: 0
    property bool eventHoverInside: false
    property string eventLastKey: "none"
    property string eventLastTrigger: "none"
    property bool metricsRenderScaleCompliant: UIF.RenderQuality.enabled
        && UIF.RenderQuality.effectiveSupersampleScale() >= UIF.RenderQuality.minimumSupersampleScale
        && UIF.RenderQuality.effectiveSupersampleScale() <= UIF.RenderQuality.maximumSupersampleScale
        && UIF.RenderQuality.msaaSamples >= 0
        && UIF.RenderQuality.msaaSamples <= 16
    property bool metricsFontFallbackCompliant: UIF.FontPolicy.effectiveFamily.length > 0
        && UIF.FontPolicy.resolveFamily("") === UIF.FontPolicy.effectiveFamily
    property bool metricsThemeTextCompliant: UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle, UIF.Theme.textTitleWeight, UIF.Theme.textTitleStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle2, UIF.Theme.textTitle2Weight, UIF.Theme.textTitle2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader, UIF.Theme.textHeaderWeight, UIF.Theme.textHeaderStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader2, UIF.Theme.textHeader2Weight, UIF.Theme.textHeader2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textBody, UIF.Theme.textBodyWeight, UIF.Theme.textBodyStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textDescription, UIF.Theme.textDescriptionWeight, UIF.Theme.textDescriptionStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textCaption, UIF.Theme.textCaptionWeight, UIF.Theme.textCaptionStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textDisabled, UIF.Theme.textDisabledWeight, UIF.Theme.textDisabledStyleName)
    property bool metricsRuntimeCompliant: UIF.RuntimeEvents.running
        && UIF.RuntimeEvents.idleTimeoutMs >= 250
        && UIF.RuntimeEvents.osSampleIntervalMs >= 250
        && UIF.RuntimeEvents.pid > 0
        && UIF.RuntimeEvents.osName.length > 0
    property bool metricsSvgCompliant: UIF.SvgManager.minimumScale >= 1.0
        && UIF.SvgManager.maximumScale >= UIF.SvgManager.minimumScale
        && UIF.SvgManager.cacheSize >= 0
    property bool metricsPageCompliant: UIF.PageMonitor.count >= 1
        && UIF.PageMonitor.current.length > 0
    property int metricsTotalChecks: 6
    property int metricsPassedChecks: (metricsRenderScaleCompliant ? 1 : 0)
        + (metricsFontFallbackCompliant ? 1 : 0)
        + (metricsThemeTextCompliant ? 1 : 0)
        + (metricsRuntimeCompliant ? 1 : 0)
        + (metricsSvgCompliant ? 1 : 0)
        + (metricsPageCompliant ? 1 : 0)
    property bool metricsPass: metricsPassedChecks === metricsTotalChecks
    property string metricsSummary: metricsPassedChecks + "/" + metricsTotalChecks
    property var runtimeSnapshot: ({})
    property string demoContextMenuLastAction: "none"
    property var demoContextMenuItems: [
        { id: "open", label: "Label", key: "key", showChevron: true },
        { id: "rename", label: "Label", key: "key", enabled: false, showChevron: true },
        { id: "pin", label: "Label", key: "key", selected: true, showChevron: true },
        { type: "divider" },
        { id: "delete", label: "Label", key: "key", showChevron: false }
    ]

    function openDemoContextMenuAtGlobal(globalX, globalY) {
        if (!demoContextMenu.parent) {
            demoContextMenu.openAt(globalX, globalY)
            return
        }
        const localPoint = demoContextMenu.parent.mapFromGlobal(globalX, globalY)
        demoContextMenu.openAt(localPoint.x, localPoint.y)
    }

    function openDemoContextMenuAtLocal(localX, localY) {
        demoContextMenu.openAt(localX, localY)
    }

    function textModeName(mode) {
        if (mode === textEditorPreview.plainTextMode)
            return "plainTextMode"
        if (mode === textEditorPreview.markdownMode)
            return "markdownMode"
        if (mode === textEditorPreview.richTextMode)
            return "richTextMode"
        return "unknown"
    }

    Component.onCompleted: {
        UIF.FontPolicy.enforceApplicationFallback()
        UIF.Debug.enabled = true
        UIF.Debug.log("Main", "test-app-opened")
        UIF.Debug.log("Main", "font-family", UIF.FontPolicy.effectiveFamily)
        UIF.RenderMonitor.attachWindow(root)
        UIF.PageMonitor.record("/test-app")
        root.runtimeSnapshot = UIF.RuntimeEvents.snapshot()
    }

    Timer {
        id: metricsSampler
        interval: 500
        repeat: true
        running: true
        onTriggered: root.runtimeSnapshot = UIF.RuntimeEvents.snapshot()
    }

    UIF.Alert {
        id: sampleAlert
        anchors.fill: parent
        open: root.alertOpen
        title: "Sample Alert"
        message: "Alert component preview"
        primaryText: "Close"
        secondaryText: "Cancel"
        onPrimaryClicked: {
            root.alertOpen = false
        }
        onSecondaryClicked: {
            root.alertOpen = false
        }
        onDismissed: {
            root.alertOpen = false
        }
    }

    UIF.ContextMenu {
        id: demoContextMenu
        items: root.demoContextMenuItems
        onItemTriggered: function(index, item) {
            const actionId = item && item.id !== undefined ? item.id : ("item-" + index)
            root.demoContextMenuLastAction = actionId
        }
    }

    TapHandler {
        id: defaultContextMenuHandler
        acceptedButtons: Qt.RightButton
        onTapped: function(eventPoint) {
            const localX = eventPoint.position.x
            const localY = eventPoint.position.y
            root.eventLastTrigger = "context-menu @" + Math.round(localX) + "," + Math.round(localY)
            root.openDemoContextMenuAtLocal(localX, localY)
        }
    }

    Component {
        id: routeOverview
        Rectangle {
            color: UIF.Theme.surfaceGhost
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Overview"
                color: UIF.Theme.textPrimary
                style: body
            }
        }
    }

    Component {
        id: routeReports
        Rectangle {
            color: UIF.Theme.accentTint
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Reports"
                color: UIF.Theme.textPrimary
                style: body
            }
        }
    }

    Component {
        id: routeSettings
        Rectangle {
            color: UIF.Theme.dangerTint
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Settings"
                color: UIF.Theme.textPrimary
                style: body
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Item {
            width: Math.max(root.width - 24, 1040)
            implicitHeight: gallery.implicitHeight + 24

            GridLayout {
                id: gallery
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: UIF.Theme.gap12
                columns: width >= 1320 ? 2 : 1
                rowSpacing: UIF.Theme.gap12
                columnSpacing: UIF.Theme.gap12

                UIF.AppCard {
                    title: "Runtime"
                    subtitle: "Backend singletons and monitoring"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: UIF.Theme.gap8
                        Layout.fillWidth: true

                        UIF.Label {
                            text: "Platform: " + UIF.Platform.os + " / " + UIF.Platform.arch
                            color: UIF.Theme.textPrimary
                            style: body
                        }

                        UIF.Label {
                            text: "RenderMonitor: active=" + UIF.RenderMonitor.active
                                + " fps=" + Number(UIF.RenderMonitor.fps).toFixed(1)
                                + " frameMs=" + Number(UIF.RenderMonitor.lastFrameMs).toFixed(2)
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "PageMonitor: current=" + UIF.PageMonitor.current
                                + " count=" + UIF.PageMonitor.count
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Metrics coverage: " + root.metricsSummary + (root.metricsPass ? " PASS" : " FAIL")
                            color: root.metricsPass ? UIF.Theme.success : UIF.Theme.danger
                            style: description
                        }

                        UIF.Label {
                            text: "RenderQuality: enabled=" + UIF.RenderQuality.enabled
                                + " scale=" + Number(UIF.RenderQuality.effectiveSupersampleScale()).toFixed(2)
                                + " range=" + Number(UIF.RenderQuality.minimumSupersampleScale).toFixed(2)
                                + "~" + Number(UIF.RenderQuality.maximumSupersampleScale).toFixed(2)
                                + " msaa=" + UIF.RenderQuality.msaaSamples
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "RuntimeEvents: key=" + UIF.RuntimeEvents.keyPressCount + "/" + UIF.RuntimeEvents.keyReleaseCount
                                + " mouse=" + UIF.RuntimeEvents.mouseMoveCount + "/" + UIF.RuntimeEvents.mousePressCount + "/" + UIF.RuntimeEvents.mouseReleaseCount
                                + " ui=" + UIF.RuntimeEvents.uiCreatedCount + "/" + UIF.RuntimeEvents.uiShownCount + "/" + UIF.RuntimeEvents.uiHiddenCount + "/" + UIF.RuntimeEvents.uiDestroyedCount
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Runtime snapshot: pid=" + UIF.RuntimeEvents.pid
                                + " idleMs=" + UIF.RuntimeEvents.idleForMs
                                + " uptimeMs=" + (root.runtimeSnapshot.uptimeMs !== undefined ? root.runtimeSnapshot.uptimeMs : 0)
                                + " rssBytes=" + UIF.RuntimeEvents.rssBytes
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Checks: scale=" + (root.metricsRenderScaleCompliant ? "OK" : "FAIL")
                                + " font=" + (root.metricsFontFallbackCompliant ? "OK" : "FAIL")
                                + " text=" + (root.metricsThemeTextCompliant ? "OK" : "FAIL")
                                + " runtime=" + (root.metricsRuntimeCompliant ? "OK" : "FAIL")
                                + " svg=" + (root.metricsSvgCompliant ? "OK" : "FAIL")
                                + " page=" + (root.metricsPageCompliant ? "OK" : "FAIL")
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap8

                            UIF.LabelButton {
                                text: "Open Alert"
                                tone: UIF.AbstractButton.Accent
                                onClicked: root.alertOpen = true
                            }

                            UIF.LabelButton {
                                text: "Stop RenderMonitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.stop()
                            }

                            UIF.LabelButton {
                                text: "Start RenderMonitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.start()
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Component State Matrix"
                    subtitle: "All framework components and high-level states"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    GridLayout {
                        columns: width >= 1320 ? 2 : 1
                        rowSpacing: UIF.Theme.gap6
                        columnSpacing: UIF.Theme.gap10
                        Layout.fillWidth: true

                        UIF.Label {
                            text: "Windows: ApplicationWindow(root)=" + root.visible
                                + " Alert(open)=" + sampleAlert.open
                                + " AppScaffold(navOpen)=" + scaffoldPreview.navigationOpen
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Buttons: Label/Icon/LabelMenu/IconMenu shown with Accent, Default, Borderless, Destructive, Disabled"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Inputs: AbstractInputBar, InputField, TextEditor, CodeEditor shown with Empty/Filled/ReadOnly/Disabled variants"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Checks: CheckBox, RadioButton, ToggleSwitch shown with checked/unchecked/disabled states"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Layout: AppHeader, AppScaffold, VStack, HStack, ZStack, Spacer active in test app"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Navigation: PageRouter(path=" + demoRouter.path.join("/")
                                + "), Link, LinkWrapper, NavigationLink, ContextMenu active"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Surface: AppCard and Alert active, Label style tokens applied across all cards"
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Event listener states: trigger=" + root.eventLastTrigger
                                + " key=" + root.eventLastKey
                            color: UIF.Theme.textSecondary
                            style: description
                        }
                    }
                }

                UIF.AppCard {
                    title: "Buttons"
                    subtitle: "4 types x 5 states (20 cases)"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    GridLayout {
                        columns: 4
                        rowSpacing: UIF.Theme.gap10
                        columnSpacing: UIF.Theme.gap24
                        Layout.fillWidth: true

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Accent }
                        UIF.IconButton { tone: UIF.AbstractButton.Accent }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Accent }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Accent }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Default }
                        UIF.IconButton { tone: UIF.AbstractButton.Default }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Default }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Default }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Borderless }
                        UIF.IconButton { tone: UIF.AbstractButton.Borderless }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Borderless }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Borderless }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Destructive }
                        UIF.IconButton { tone: UIF.AbstractButton.Destructive }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Destructive }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Destructive }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Disabled }
                        UIF.IconButton { tone: UIF.AbstractButton.Disabled }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Disabled }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Disabled }
                    }
                }

                UIF.AppCard {
                    title: "Input Fields"
                    subtitle: "5 types x 4 states (20 cases)"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    GridLayout {
                        columns: 5
                        rowSpacing: UIF.Theme.gap8
                        columnSpacing: UIF.Theme.gap10
                        Layout.fillWidth: true

                        UIF.Label {
                            text: "Type"
                            color: UIF.Theme.textOctonary
                            style: description
                        }
                        UIF.Label {
                            text: "Empty"
                            color: UIF.Theme.textOctonary
                            style: description
                        }
                        UIF.Label {
                            text: "Filled"
                            color: UIF.Theme.textOctonary
                            style: description
                        }
                        UIF.Label {
                            text: "ReadOnly"
                            color: UIF.Theme.textOctonary
                            style: description
                        }
                        UIF.Label {
                            text: "Disabled"
                            color: UIF.Theme.textOctonary
                            style: description
                        }

                        UIF.Label { text: "Text"; color: UIF.Theme.textPrimary; style: description }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "Placeholder" }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "Typed value" }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "Typed value"; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "Placeholder"; enabled: false }

                        UIF.Label { text: "Search"; color: UIF.Theme.textPrimary; style: description }
                        UIF.InputField {
                            Layout.preferredWidth: UIF.Theme.inputWidthMd
                            placeholderText: "Search"
                            leadingItems: Item {
                                width: UIF.Theme.iconSm
                                height: UIF.Theme.iconSm

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: UIF.Theme.inputWidthMd
                            text: "network logs"
                            leadingItems: Item {
                                width: UIF.Theme.iconSm
                                height: UIF.Theme.iconSm

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: UIF.Theme.inputWidthMd
                            text: "network logs"
                            readOnly: true
                            leadingItems: Item {
                                width: UIF.Theme.iconSm
                                height: UIF.Theme.iconSm

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: UIF.Theme.inputWidthMd
                            placeholderText: "Search"
                            enabled: false
                            leadingItems: Item {
                                width: UIF.Theme.iconSm
                                height: UIF.Theme.iconSm

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        UIF.Label { text: "Password"; color: UIF.Theme.textPrimary; style: description }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "Password"; echoMode: TextInput.Password }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "password123"; echoMode: TextInput.Password }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "password123"; echoMode: TextInput.Password; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "Password"; echoMode: TextInput.Password; enabled: false }

                        UIF.Label { text: "URL"; color: UIF.Theme.textPrimary; style: description }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "https://example.com"; inputMethodHints: Qt.ImhUrlCharactersOnly }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "https://api.local/v1"; inputMethodHints: Qt.ImhUrlCharactersOnly }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "https://api.local/v1"; inputMethodHints: Qt.ImhUrlCharactersOnly; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "https://example.com"; inputMethodHints: Qt.ImhUrlCharactersOnly; enabled: false }

                        UIF.Label { text: "Numeric"; color: UIF.Theme.textPrimary; style: description }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "0"; inputMethodHints: Qt.ImhDigitsOnly }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "1024"; inputMethodHints: Qt.ImhDigitsOnly }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; text: "1024"; inputMethodHints: Qt.ImhDigitsOnly; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: UIF.Theme.inputWidthMd; placeholderText: "0"; inputMethodHints: Qt.ImhDigitsOnly; enabled: false }
                    }
                }

                UIF.AppCard {
                    title: "Text Editors"
                    subtitle: "AbstractInputBar, TextEditor, CodeEditor with live state"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: UIF.Theme.gap8
                        Layout.fillWidth: true

                        GridLayout {
                            columns: width >= 1320 ? 3 : 1
                            rowSpacing: UIF.Theme.gap8
                            columnSpacing: UIF.Theme.gap10
                            Layout.fillWidth: true

                            ColumnLayout {
                                spacing: UIF.Theme.gap6
                                Layout.fillWidth: true

                                UIF.Label {
                                    text: "AbstractInputBar"
                                    color: UIF.Theme.textSecondary
                                    style: description
                                }

                                UIF.AbstractInputBar {
                                    id: abstractInputPreview
                                    Layout.fillWidth: true
                                    placeholderText: "Type and observe state"
                                    text: "base input"
                                }
                            }

                            ColumnLayout {
                                spacing: UIF.Theme.gap6
                                Layout.fillWidth: true

                                UIF.Label {
                                    text: "TextEditor"
                                    color: UIF.Theme.textSecondary
                                    style: description
                                }

                                UIF.TextEditor {
                                    id: textEditorPreview
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 190
                                    mode: plainTextMode
                                    showRenderedOutput: true
                                    text: "Hello **bold**"
                                }
                            }

                            ColumnLayout {
                                spacing: UIF.Theme.gap6
                                Layout.fillWidth: true

                                UIF.Label {
                                    text: "CodeEditor"
                                    color: UIF.Theme.textSecondary
                                    style: description
                                }

                                UIF.CodeEditor {
                                    id: codeEditorPreview
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 190
                                    snippetTitle: "snippet.ts"
                                    snippetLanguage: "TypeScript"
                                    text: "const ready = true;\nconsole.log(ready)"
                                }
                            }
                        }

                        UIF.Label {
                            text: "AbstractInputBar state: focused=" + abstractInputPreview.focused
                                + " readOnly=" + abstractInputPreview.readOnly
                                + " enabled=" + abstractInputPreview.enabled
                                + " length=" + abstractInputPreview.text.length
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "TextEditor state: mode=" + root.textModeName(textEditorPreview.mode)
                                + " empty=" + textEditorPreview.empty
                                + " previewVisible=" + textEditorPreview.previewVisible
                                + " normalizedLen=" + textEditorPreview.normalizedInput.length
                                + " renderedLen=" + textEditorPreview.renderedOutput.length
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "CodeEditor state: empty=" + codeEditorPreview.empty
                                + " wrapMode=" + codeEditorPreview.wrapMode
                                + " textFormat=" + codeEditorPreview.textFormat
                                + " snippetHeader=" + codeEditorPreview.showSnippetHeader
                                + " length=" + codeEditorPreview.text.length
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap8

                            UIF.LabelButton {
                                text: "Plain"
                                tone: UIF.AbstractButton.Default
                                onClicked: textEditorPreview.mode = textEditorPreview.plainTextMode
                            }

                            UIF.LabelButton {
                                text: "Markdown"
                                tone: UIF.AbstractButton.Default
                                onClicked: textEditorPreview.mode = textEditorPreview.markdownMode
                            }

                            UIF.LabelButton {
                                text: "Rich"
                                tone: UIF.AbstractButton.Default
                                onClicked: textEditorPreview.mode = textEditorPreview.richTextMode
                            }

                            UIF.LabelButton {
                                text: textEditorPreview.showRenderedOutput ? "Hide Preview" : "Show Preview"
                                tone: UIF.AbstractButton.Borderless
                                onClicked: textEditorPreview.showRenderedOutput = !textEditorPreview.showRenderedOutput
                            }

                            UIF.LabelButton {
                                text: "Reset Snippet"
                                tone: UIF.AbstractButton.Borderless
                                onClicked: codeEditorPreview.text = "const ready = true;\nconsole.log(ready)"
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Check Controls"
                    subtitle: "CheckBox, RadioButton, ToggleSwitch"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: UIF.Theme.gap8
                        Layout.fillWidth: true

                        RowLayout {
                            spacing: UIF.Theme.gap10
                            UIF.CheckBox { text: "Check On"; checked: true }
                            UIF.CheckBox { text: "Check Off"; checked: false }
                            UIF.CheckBox { text: "Check Disabled"; checked: true; enabled: false }
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap10
                            UIF.RadioButton { checked: true; enabled: true }
                            UIF.RadioButton { checked: false; enabled: true }
                            UIF.RadioButton { checked: true; enabled: false }
                            UIF.RadioButton { checked: false; enabled: false }
                            UIF.RadioButton { text: "Radio Label"; checked: true }
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap10
                            UIF.ToggleSwitch { checked: true }
                            UIF.ToggleSwitch { checked: false }
                            UIF.ToggleSwitch { checked: true; enabled: false }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Layout Primitives"
                    subtitle: "VStack, HStack, ZStack, Spacer"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: UIF.Theme.gap10
                        Layout.fillWidth: true

                        UIF.VStack {
                            spacing: UIF.Theme.gap6
                            alignmentName: "leading"
                            Layout.fillWidth: true
                            Rectangle { width: 110; height: 24; radius: UIF.Theme.radiusBase; color: UIF.Theme.surfaceAlt }
                            Rectangle { width: 140; height: 24; radius: UIF.Theme.radiusBase; color: UIF.Theme.surfaceSolid }
                        }

                        UIF.HStack {
                            spacing: UIF.Theme.gap6
                            alignmentName: "center"
                            Layout.fillWidth: true
                            Rectangle { width: 80; height: 22; radius: UIF.Theme.radiusBase; color: UIF.Theme.surfaceAlt }
                            UIF.Spacer { minLength: 24 }
                            Rectangle { width: 80; height: 22; radius: UIF.Theme.radiusBase; color: UIF.Theme.accent }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 120
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost

                            UIF.ZStack {
                                anchors.fill: parent
                                alignmentName: "center"
                                Rectangle { width: 80; height: 80; radius: UIF.Theme.radiusMd; color: UIF.Theme.accentOverlay }
                                Rectangle { width: 52; height: 52; radius: UIF.Theme.radiusMd; color: UIF.Theme.dangerOverlay }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Navigation"
                    subtitle: "PageRouter, Link, NavigationLink, LinkWrapper, ContextMenu"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: UIF.Theme.gap8
                        Layout.fillWidth: true

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 160
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost

                            UIF.PageRouter {
                                id: demoRouter
                                anchors.fill: parent
                                anchors.margins: UIF.Theme.gap8
                                routes: [
                                    { path: "/overview", component: routeOverview },
                                    { path: "/reports", component: routeReports },
                                    { path: "/settings", component: routeSettings }
                                ]
                                initialPath: "/overview"
                            }
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap10

                            UIF.NavigationLink {
                                text: "Overview"
                                to: "/overview"
                                router: demoRouter
                            }

                            UIF.Link {
                                text: "Reports"
                                href: "/reports"
                                router: demoRouter
                            }

                            UIF.LinkWrapper {
                                router: demoRouter
                                href: "/settings"
                                Rectangle {
                                    width: 130
                                    height: 30
                                    radius: UIF.Theme.radiusBase
                                    color: UIF.Theme.surfaceSolid
                                    UIF.Label {
                                        anchors.centerIn: parent
                                        text: "Settings (wrap)"
                                        color: UIF.Theme.textPrimary
                                        style: description
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 92
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceSolid

                            UIF.Label {
                                anchors.centerIn: parent
                                text: "Default context menu active (last=" + root.demoContextMenuLastAction + ")"
                                color: UIF.Theme.textPrimary
                                style: description
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Header"
                    subtitle: "AppHeader action slot"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 96

                    UIF.AppHeader {
                        anchors.fill: parent
                        title: "Header Preview"
                        subtitle: "Action slot + menu button"
                        menuVisible: true
                        onMenuClicked: UIF.Debug.log("Header", "menu-clicked")

                        UIF.LabelButton {
                            text: "Action"
                            tone: UIF.AbstractButton.Borderless
                            onClicked: UIF.Debug.log("Header", "action-clicked")
                        }
                    }
                }

                UIF.AppCard {
                    title: "Scaffold"
                    subtitle: "Embedded AppScaffold preview"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns
                    Layout.preferredHeight: 420

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: UIF.Theme.radiusMd
                        color: UIF.Theme.surfaceGhost
                        clip: true

                        UIF.AppScaffold {
                            id: scaffoldPreview
                            anchors.fill: parent
                            headerTitle: "Scaffold Preview"
                            headerSubtitle: "Navigation + content"
                            navModel: [
                                { label: "Overview", icon: "◉", badge: "4" },
                                { label: "Reports", icon: "▣", badge: "2" },
                                { label: "Settings", icon: "⚙", badge: "1" }
                            ]
                            navTitle: "Preview"

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: UIF.Theme.gap8

                                UIF.Label {
                                    text: "Scaffold content slot"
                                    color: UIF.Theme.textPrimary
                                    style: body
                                }

                                UIF.HStack {
                                    spacing: UIF.Theme.gap8
                                    Rectangle { width: 90; height: 28; radius: UIF.Theme.radiusBase; color: UIF.Theme.accent }
                                    Rectangle { width: 90; height: 28; radius: UIF.Theme.radiusBase; color: UIF.Theme.surfaceSolid }
                                }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Event Listener"
                    subtitle: "EventListener trigger and state coverage"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: UIF.Theme.gap8
                        Layout.fillWidth: true

                        GridLayout {
                            columns: width >= 1320 ? 3 : 2
                            rowSpacing: UIF.Theme.gap8
                            columnSpacing: UIF.Theme.gap8
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "clicked (" + root.eventClickCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "clicked"
                                    action: function(mouse) {
                                        root.eventClickCount += 1
                                        root.eventLastTrigger = "clicked @" + mouse.x + "," + mouse.y
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "pressed (" + root.eventPressCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "pressed"
                                    action: function(mouse) {
                                        root.eventPressCount += 1
                                        root.eventLastTrigger = "pressed @" + mouse.x + "," + mouse.y
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "released (" + root.eventReleaseCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "released"
                                    action: function(mouse) {
                                        root.eventReleaseCount += 1
                                        root.eventLastTrigger = "released @" + mouse.x + "," + mouse.y
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "entered (" + root.eventEnterCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "entered"
                                    action: function() {
                                        root.eventEnterCount += 1
                                        root.eventHoverInside = true
                                        root.eventLastTrigger = "entered"
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "exited (" + root.eventExitCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "exited"
                                    action: function() {
                                        root.eventExitCount += 1
                                        root.eventHoverInside = false
                                        root.eventLastTrigger = "exited"
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceSolid

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "hoverChanged (" + root.eventHoverChangeCount + ")"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    trigger: "hoverChanged"
                                    action: function(payload) {
                                        root.eventHoverChangeCount += 1
                                        root.eventHoverInside = payload.containsMouse
                                        root.eventLastTrigger = "hoverChanged=" + payload.containsMouse
                                    }
                                }
                            }
                        }

                        RowLayout {
                            spacing: UIF.Theme.gap8
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 56
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceGhost

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "Key Press Surface"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    id: keyPressListener
                                    trigger: "keyPressed"
                                    action: function(event) {
                                        root.eventKeyPressCount += 1
                                        root.eventLastKey = "pressed " + event.key
                                        root.eventLastTrigger = "keyPressed " + event.key
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton
                                    onClicked: keyPressListener.forceActiveFocus()
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 56
                                radius: UIF.Theme.radiusMd
                                color: UIF.Theme.surfaceGhost

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "Key Release Surface"
                                    color: UIF.Theme.textPrimary
                                    style: description
                                }

                                UIF.EventListener {
                                    id: keyReleaseListener
                                    trigger: "keyReleased"
                                    action: function(event) {
                                        root.eventKeyReleaseCount += 1
                                        root.eventLastKey = "released " + event.key
                                        root.eventLastTrigger = "keyReleased " + event.key
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton
                                    onClicked: keyReleaseListener.forceActiveFocus()
                                }
                            }
                        }

                        UIF.Label {
                            text: "Pointer state: hoverInside=" + root.eventHoverInside
                                + " hoverChanged=" + root.eventHoverChangeCount
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Key state: press=" + root.eventKeyPressCount
                                + " release=" + root.eventKeyReleaseCount
                                + " lastKey=" + root.eventLastKey
                            color: UIF.Theme.textSecondary
                            style: description
                        }

                        UIF.Label {
                            text: "Last trigger: " + root.eventLastTrigger
                            color: UIF.Theme.textSecondary
                            style: description
                        }
                    }
                }
            }
        }
    }

    QtObject {
        Component.onCompleted: UIF.Debug.log("Main", "created")
    }
}

// API usage (external):
// import UIFrameworkDemo 1.0
// Main { visible: true }
