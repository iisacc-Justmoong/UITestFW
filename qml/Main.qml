pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LVRS as LV

LV.ApplicationWindow {
    id: root
    visible: true
    width: 1480
    height: 980
    title: "UI Framework Visual Catalog"
    subtitle: "컴포넌트 시각 점검용 메인 뷰"
    navItems: LV.AppState.navItems

    readonly property bool compactGallery: width < 1260
    readonly property var accentPreviewTokens: [
        { name: "accentTransparent", hex: "transparent", color: LV.Theme.accentTransparent },
        { name: "accentWhite", hex: "#FFFFFF", color: LV.Theme.accentWhite },
        { name: "accentGrayLight", hex: "#CED0D6", color: LV.Theme.accentGrayLight },
        { name: "accentBlue", hex: "#548AF7", color: LV.Theme.accentBlue },
        { name: "accentRed", hex: "#DB5C5C", color: LV.Theme.accentRed },
        { name: "accentSlate", hex: "#43454A", color: LV.Theme.accentSlate },
        { name: "accentGreen", hex: "#57965C", color: LV.Theme.accentGreen },
        { name: "accentBlueMuted", hex: "#25324D", color: LV.Theme.accentBlueMuted },
        { name: "accentOrangeMuted", hex: "#C77D55", color: LV.Theme.accentOrangeMuted },
        { name: "accentGreenMuted", hex: "#253627", color: LV.Theme.accentGreenMuted },
        { name: "accentYellow", hex: "#F2C55C", color: LV.Theme.accentYellow },
        { name: "accentRedBrownDark", hex: "#402929", color: LV.Theme.accentRedBrownDark },
        { name: "accentGray", hex: "#868A91", color: LV.Theme.accentGray },
        { name: "accentYellowMuted", hex: "#D6AE58", color: LV.Theme.accentYellowMuted },
        { name: "accentBrownMuted", hex: "#45322B", color: LV.Theme.accentBrownMuted },
        { name: "accentPurple", hex: "#A571E6", color: LV.Theme.accentPurple },
        { name: "accentBrownDarker", hex: "#3D3223", color: LV.Theme.accentBrownDarker },
        { name: "accentCharcoal", hex: "#1E1F22", color: LV.Theme.accentCharcoal },
        { name: "accentGrayPale", hex: "#B4B8BF", color: LV.Theme.accentGrayPale },
        { name: "accentBlueBright", hex: "#3574F0", color: LV.Theme.accentBlueBright },
        { name: "accentPurpleDarker", hex: "#2F2936", color: LV.Theme.accentPurpleDarker },
        { name: "accentGrayBright", hex: "#F0F1F2", color: LV.Theme.accentGrayBright },
        { name: "accentRose", hex: "#E55765", color: LV.Theme.accentRose },
        { name: "accentRoseDarker", hex: "#5E3838", color: LV.Theme.accentRoseDarker },
        { name: "accentGrayMuted", hex: "#5A5D63", color: LV.Theme.accentGrayMuted },
        { name: "accentGreenBright", hex: "#55A76A", color: LV.Theme.accentGreenBright },
        { name: "accentRedMuted", hex: "#BD5757", color: LV.Theme.accentRedMuted },
        { name: "accentRedDark", hex: "#9C4E4E", color: LV.Theme.accentRedDark },
        { name: "accentRedDarker", hex: "#7A4343", color: LV.Theme.accentRedDarker },
        { name: "accentSlateMuted", hex: "#6F737A", color: LV.Theme.accentSlateMuted },
        { name: "accentSlateDarker", hex: "#6C707E", color: LV.Theme.accentSlateDarker },
        { name: "accentGreenDarker", hex: "#375239", color: LV.Theme.accentGreenDarker }
    ]

    readonly property var runtimeSnapshot: LV.AppState.runtimeSnapshot
    readonly property var viewStateSnapshot: LV.AppState.viewStateSnapshot
    readonly property bool metricsRenderScaleCompliant:
        effectiveSupersampleScale >= 1.0
        && effectiveSupersampleScale <= LV.RenderQuality.maximumSupersampleScale
    readonly property bool metricsFontFallbackCompliant:
        LV.Theme.fontBody.length > 0
        && LV.FontPolicy.resolveFamily(LV.FontPolicy.preferredFamily).length > 0
    readonly property bool metricsThemeTextCompliant:
        LV.Theme.isThemeTextStyleCompliant(LV.Theme.textTitle, LV.Theme.textTitleWeight, LV.Theme.textTitleStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textTitle2, LV.Theme.textTitle2Weight, LV.Theme.textTitle2StyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textHeader, LV.Theme.textHeaderWeight, LV.Theme.textHeaderStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textHeader2, LV.Theme.textHeader2Weight, LV.Theme.textHeader2StyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textBody, LV.Theme.textBodyWeight, LV.Theme.textBodyStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textDescription, LV.Theme.textDescriptionWeight, LV.Theme.textDescriptionStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textCaption, LV.Theme.textCaptionWeight, LV.Theme.textCaptionStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textDisabled, LV.Theme.textDisabledWeight, LV.Theme.textDisabledStyleName)
    readonly property bool metricsRuntimeCompliant:
        runtimeSnapshot
        && runtimeSnapshot.pid !== undefined
        && runtimeSnapshot.uptimeMs !== undefined
        && runtimeSnapshot.rssBytes !== undefined
    readonly property bool metricsSvgCompliant:
        LV.SvgManager.minimumScale >= 1.0
        && LV.SvgManager.maximumScale >= LV.SvgManager.minimumScale
    readonly property bool metricsPageCompliant:
        LV.AppState.pageHistory.length > 0
        && viewStateSnapshot
        && viewStateSnapshot.stack !== undefined
        && viewStateSnapshot.loadedViews !== undefined
        && viewStateSnapshot.activeViews !== undefined
        && viewStateSnapshot.inactiveViews !== undefined
        && viewStateSnapshot.disabledViews !== undefined
        && viewStateSnapshot.loadedViews.length === viewStateSnapshot.stack.length
        && (viewStateSnapshot.activeViews.length
            + viewStateSnapshot.inactiveViews.length
            + viewStateSnapshot.disabledViews.length) === viewStateSnapshot.loadedViews.length
    readonly property int metricsTotalChecks: 6
    readonly property int metricsPassedChecks:
        (metricsRenderScaleCompliant ? 1 : 0)
        + (metricsFontFallbackCompliant ? 1 : 0)
        + (metricsThemeTextCompliant ? 1 : 0)
        + (metricsRuntimeCompliant ? 1 : 0)
        + (metricsSvgCompliant ? 1 : 0)
        + (metricsPageCompliant ? 1 : 0)
    readonly property bool metricsPass: metricsPassedChecks === metricsTotalChecks
    readonly property string metricsSummary: metricsPassedChecks + "/" + metricsTotalChecks

    function nudgeProgress(delta) {
        LV.AppState.nudgeProgress(delta)
    }

    Component.onCompleted: {
        LV.AppState.bootstrap()
        LV.FontPolicy.enforceApplicationFallback()
        LV.RenderMonitor.attachWindow(root)
        LV.PageMonitor.record("/visual-catalog")
        LV.AppState.syncPageHistory(LV.PageMonitor.history)
        LV.AppState.syncRuntimeSnapshot(LV.RuntimeEvents.snapshot())
        LV.AppState.syncViewStateSnapshot(LV.ViewStateTracker.snapshot())
        LV.Debug.enabled = true
        LV.Debug.log("Main", "visual-catalog-opened")
    }

    Connections {
        target: LV.RuntimeEvents
        ignoreUnknownSignals: true
        function onOsStatsChanged() {
            LV.AppState.syncRuntimeSnapshot(LV.RuntimeEvents.snapshot())
        }
        function onUiChanged() {
            LV.AppState.syncRuntimeSnapshot(LV.RuntimeEvents.snapshot())
        }
        function onRunningChanged() {
            LV.AppState.syncRuntimeSnapshot(LV.RuntimeEvents.snapshot())
        }
    }

    Connections {
        target: LV.ViewStateTracker
        ignoreUnknownSignals: true
        function onStackChanged() {
            LV.AppState.syncViewStateSnapshot(LV.ViewStateTracker.snapshot())
        }
    }

    Connections {
        target: LV.PageMonitor
        ignoreUnknownSignals: true
        function onHistoryChanged() {
            LV.AppState.syncPageHistory(LV.PageMonitor.history)
        }
    }

    LV.Alert {
        id: sampleAlert
        anchors.fill: parent
        open: LV.AppState.alertOpen
        title: "Alert Dialog"
        message: "It can have 2 or 3 actions depending on your needs."
        primaryText: "Button"
        secondaryText: "Button"
        tertiaryText: "Button"
        onPrimaryClicked: LV.AppState.alertOpen = false
        onSecondaryClicked: LV.AppState.alertOpen = false
        onTertiaryClicked: LV.AppState.alertOpen = false
        onDismissed: LV.AppState.alertOpen = false
    }

    LV.ContextMenu {
        id: demoContextMenu
        items: LV.AppState.demoContextMenuItems
    }

    Component {
        id: routeOverview

        Rectangle {
            color: LV.Theme.surfaceGhost
            radius: LV.Theme.radiusMd

            LV.Label {
                anchors.centerIn: parent
                text: "Route: Overview"
                style: body
                color: LV.Theme.textPrimary
            }
        }
    }

    Component {
        id: routeReports

        Rectangle {
            color: LV.Theme.accentTint
            radius: LV.Theme.radiusMd

            LV.Label {
                anchors.centerIn: parent
                text: "Route: Reports"
                style: body
                color: LV.Theme.textPrimary
            }
        }
    }

    Component {
        id: routeRuns

        Rectangle {
            color: LV.Theme.surfaceAlt
            radius: LV.Theme.radiusMd

            LV.Label {
                anchors.centerIn: parent
                text: "Route: Runs"
                style: body
                color: LV.Theme.textPrimary
            }
        }
    }

    Component {
        id: routeSettings

        Rectangle {
            color: LV.Theme.dangerTint
            radius: LV.Theme.radiusMd

            LV.Label {
                anchors.centerIn: parent
                text: "Route: Settings"
                style: body
                color: LV.Theme.textPrimary
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Item {
            width: Math.max(root.width - LV.Theme.gap24 * 2, 960)
            implicitHeight: pageColumn.implicitHeight + LV.Theme.gap24

            ColumnLayout {
                id: pageColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: LV.Theme.gap12
                spacing: LV.Theme.gap12

                LV.AppCard {
                    title: "Overview"
                    subtitle: "컴포넌트 탐색 시작점"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap12

                        LV.Label {
                            width: parent.width
                            style: description
                            color: LV.Theme.textSecondary
                            wrapMode: Text.WordWrap
                            text: "이 페이지는 LVRS의 핵심 컴포넌트를 상태별로 묶어 보여주는 시각 카탈로그이다."
                        }

                        RowLayout {
                            width: parent.width
                            spacing: LV.Theme.gap8

                            LV.LabelButton {
                                text: "Open Alert"
                                tone: LV.AbstractButton.Primary
                                onClicked: LV.AppState.alertOpen = true
                            }

                            LV.LabelButton {
                                id: menuButton
                                text: "Open Context Menu"
                                tone: LV.AbstractButton.Default
                                onClicked: demoContextMenu.openFor(menuButton, 0, menuButton.height + 6)
                            }

                            LV.LabelButton {
                                text: "Stop Monitor"
                                tone: LV.AbstractButton.Default
                                onClicked: LV.RenderMonitor.stop()
                            }

                            LV.LabelButton {
                                text: "Start Monitor"
                                tone: LV.AbstractButton.Default
                                onClicked: LV.RenderMonitor.start()
                            }
                        }

                        RowLayout {
                            width: parent.width
                            spacing: LV.Theme.gap10

                            LV.Label {
                                style: description
                                color: LV.Theme.textSecondary
                                text: "Progress"
                            }

                            Slider {
                                id: progressSlider
                                Layout.fillWidth: true
                                from: Math.min(LV.AppState.progressStart, LV.AppState.progressEnd)
                                to: Math.max(LV.AppState.progressStart, LV.AppState.progressEnd)
                                value: LV.AppState.progressCurrent
                                stepSize: 1
                                onMoved: LV.AppState.progressCurrent = value
                                onValueChanged: {
                                    if (Math.abs(LV.AppState.progressCurrent - value) > 0.000001)
                                        LV.AppState.progressCurrent = value
                                }
                            }

                            LV.LabelButton {
                                text: "-10"
                                tone: LV.AbstractButton.Default
                                onClicked: root.nudgeProgress(-10)
                            }

                            LV.LabelButton {
                                text: "+10"
                                tone: LV.AbstractButton.Default
                                onClicked: root.nudgeProgress(10)
                            }
                        }

                        LV.Label {
                            style: caption
                            color: LV.Theme.textTertiary
                            text: "start=" + LV.AppState.progressStart.toFixed(0)
                                + " end=" + LV.AppState.progressEnd.toFixed(0)
                                + " current=" + LV.AppState.progressCurrent.toFixed(0)
                        }

                        LV.ProgressBar {
                            width: parent.width
                            size: large
                            startValue: LV.AppState.progressStart
                            endValue: LV.AppState.progressEnd
                            currentValue: LV.AppState.progressCurrent
                        }

                        LV.ProgressBar {
                            width: parent.width
                            size: regular
                            startValue: LV.AppState.progressStart
                            endValue: LV.AppState.progressEnd
                            currentValue: LV.AppState.progressCurrent
                        }
                    }
                }

                LV.AppCard {
                    title: "Typography"
                    subtitle: "Label 스타일 스케일"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap8

                        LV.Label { text: "Title"; style: title }
                        LV.Label { text: "Title2"; style: title2 }
                        LV.Label { text: "Header"; style: header }
                        LV.Label { text: "Header2"; style: header2 }
                        LV.Label { text: "Body"; style: body }
                        LV.Label { text: "Description"; style: description }
                        LV.Label { text: "Caption"; style: caption }
                        LV.Label { text: "Disabled"; style: disabled }
                    }
                }

                LV.AppCard {
                    title: "Buttons"
                    subtitle: "Tone별 버튼 패밀리 + 상태 테마 스와치"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap12

                        LV.Label { text: "Primary"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Primary }
                            LV.IconButton { tone: LV.AbstractButton.Primary }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Primary }
                            LV.IconMenuButton { tone: LV.AbstractButton.Primary }
                        }

                        LV.Label { text: "Default"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Default }
                            LV.IconButton { tone: LV.AbstractButton.Default }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Default }
                            LV.IconMenuButton { tone: LV.AbstractButton.Default }
                        }

                        LV.Label { text: "Borderless"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Borderless }
                            LV.IconButton { tone: LV.AbstractButton.Borderless }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Borderless }
                            LV.IconMenuButton { tone: LV.AbstractButton.Borderless }
                        }

                        LV.Label { text: "Destructive"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Destructive }
                            LV.IconButton { tone: LV.AbstractButton.Destructive }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Destructive }
                            LV.IconMenuButton { tone: LV.AbstractButton.Destructive }
                        }

                        LV.Label { text: "Disabled"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Disabled }
                            LV.IconButton { tone: LV.AbstractButton.Disabled }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Disabled }
                            LV.IconMenuButton { tone: LV.AbstractButton.Disabled }
                        }

                        LV.Label { text: "State Swatches"; style: caption; color: LV.Theme.textTertiary }

                        GridLayout {
                            width: parent.width
                            columns: root.compactGallery ? 1 : 2
                            rowSpacing: LV.Theme.gap10
                            columnSpacing: LV.Theme.gap10

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusSm
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { text: "Primary"; style: caption; color: LV.Theme.textSecondary }
                                    Row {
                                        spacing: LV.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.primary; LV.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: Qt.darker(LV.Theme.primary, 1.12); LV.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: Qt.darker(LV.Theme.primary, 1.2); LV.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.subSurface; LV.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusSm
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { text: "Default"; style: caption; color: LV.Theme.textSecondary }
                                    Row {
                                        spacing: LV.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.surfaceSolid; LV.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.surfaceAlt; LV.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.primary; LV.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.subSurface; LV.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusSm
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { text: "Borderless"; style: caption; color: LV.Theme.textSecondary }
                                    Row {
                                        spacing: LV.Theme.gap6
                                        Rectangle {
                                            width: 58
                                            height: 24
                                            radius: LV.Theme.radiusSm
                                            color: "transparent"
                                            border.width: 1
                                            border.color: LV.Theme.surfaceAlt
                                            LV.Label { anchors.centerIn: parent; style: disabled; text: "Base" }
                                        }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.surfaceAlt; LV.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.primary; LV.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle {
                                            width: 58
                                            height: 24
                                            radius: LV.Theme.radiusSm
                                            color: "transparent"
                                            border.width: 1
                                            border.color: LV.Theme.surfaceAlt
                                            LV.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusSm
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { text: "Destructive"; style: caption; color: LV.Theme.textSecondary }
                                    Row {
                                        spacing: LV.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.danger; LV.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: Qt.darker(LV.Theme.danger, 1.12); LV.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: Qt.darker(LV.Theme.danger, 1.2); LV.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: LV.Theme.radiusSm; color: LV.Theme.subSurface; LV.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "Accent Palette"
                    subtitle: "iconset 기반 전체 accent 컬러 프리뷰"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 2 : 3
                        rowSpacing: LV.Theme.gap8
                        columnSpacing: LV.Theme.gap8

                        Repeater {
                            model: root.accentPreviewTokens

                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                implicitHeight: 66
                                radius: LV.Theme.radiusSm
                                color: LV.Theme.surfaceGhost

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap8

                                    Rectangle {
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        radius: LV.Theme.radiusXs
                                        color: modelData.color
                                        border.width: modelData.name === "accentTransparent" ? 1 : 0
                                        border.color: LV.Theme.textTertiary
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: LV.Theme.gap2

                                        LV.Label {
                                            Layout.fillWidth: true
                                            style: caption
                                            text: modelData.name
                                            color: LV.Theme.textSecondary
                                            elide: Text.ElideRight
                                        }
                                        LV.Label {
                                            Layout.fillWidth: true
                                            style: disabled
                                            text: modelData.hex
                                            color: LV.Theme.textTertiary
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "Input Fields"
                    subtitle: "텍스트 입력 상태"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 2
                        rowSpacing: LV.Theme.gap10
                        columnSpacing: LV.Theme.gap10

                        LV.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Placeholder"
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            text: "Filled value"
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            text: "Read only"
                            readOnly: true
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Disabled"
                            enabled: false
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            text: "1024"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            mode: searchMode
                            placeholderText: "Search"
                        }

                        LV.InputField {
                            Layout.fillWidth: true
                            mode: searchMode
                            text: "network logs"
                        }
                    }
                }

                LV.AppCard {
                    title: "Editors"
                    subtitle: "TextEditor와 CodeEditor"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 2
                        rowSpacing: LV.Theme.gap12
                        columnSpacing: LV.Theme.gap12

                        LV.TextEditor {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240
                            editorHeight: 152
                            mode: markdownMode
                            text: "# Notes\\n- Build verification\\n- Visual inspection\\n\\n`Ctrl+Enter` submits."
                            placeholderText: "Write markdown notes"
                        }

                        LV.CodeEditor {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240
                            snippetTitle: "main.qml"
                            snippetLanguage: "QML"
                            text: "import QtQuick\\n\\nRectangle {\\n    width: 160\\n    height: 48\\n    radius: 8\\n}"
                            placeholderText: "Write code"
                        }
                    }
                }

                LV.AppCard {
                    title: "Check Controls"
                    subtitle: "선택형 컴포넌트"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 3
                        rowSpacing: LV.Theme.gap12
                        columnSpacing: LV.Theme.gap12

                        Column {
                            spacing: LV.Theme.gap8
                            LV.Label { text: "CheckBox"; style: caption; color: LV.Theme.textTertiary }
                            LV.CheckBox { text: "On"; checked: true }
                            LV.CheckBox { text: "Off"; checked: false }
                            LV.CheckBox { text: "Disabled"; checked: true; enabled: false }
                        }

                        Column {
                            spacing: LV.Theme.gap8
                            LV.Label { text: "RadioButton"; style: caption; color: LV.Theme.textTertiary }
                            LV.RadioButton { text: "Option A"; checked: true }
                            LV.RadioButton { text: "Option B"; checked: false }
                            LV.RadioButton { text: "Option C"; checked: false; enabled: false }
                        }

                        Column {
                            spacing: LV.Theme.gap8
                            LV.Label { text: "ToggleSwitch"; style: caption; color: LV.Theme.textTertiary }
                            LV.ToggleSwitch { text: "Enabled"; checked: true }
                            LV.ToggleSwitch { text: "Disabled"; checked: false; enabled: false }
                            LV.ToggleSwitch { checked: false }
                        }
                    }
                }

                LV.AppCard {
                    title: "Navigation"
                    subtitle: "Router, Link, List"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap12

                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8

                            LV.Link {
                                text: "Go Overview"
                                to: "/overview"
                            }

                            LV.Link {
                                text: "Go Reports"
                                to: "/reports"
                            }

                            LV.Link {
                                text: "Go Runs"
                                href: "/runs"
                                underline: true
                            }

                            LV.Link {
                                href: "/settings"

                                Rectangle {
                                    width: 148
                                    height: 30
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.surfaceSolid

                                    LV.Label {
                                        anchors.centerIn: parent
                                        style: description
                                        color: LV.Theme.textPrimary
                                        text: "Link -> Settings"
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 170
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            clip: true

                            LV.PageRouter {
                                id: demoRouter
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap8
                                initialPath: "/overview"
                                routes: [
                                    { path: "/overview", component: routeOverview },
                                    { path: "/reports", component: routeReports },
                                    { path: "/runs", component: routeRuns },
                                    { path: "/settings", component: routeSettings }
                                ]
                                onNavigated: function(path, params) {
                                    LV.PageMonitor.record(path)
                                }
                                onNavigationFailed: function(path) {
                                    LV.AppState.currentRoute = "not-found: " + path
                                }
                            }
                        }

                        LV.Label {
                            style: caption
                            color: LV.Theme.textTertiary
                            text: "currentPath = " + LV.AppState.currentRoute
                        }

                        LV.List {
                            width: parent.width
                            items: LV.AppState.demoListItems
                            toolbarIcon1: "viewMoreSymbolicDefault"
                            toolbarIcon2: "viewMoreSymbolicDefault"
                            toolbarIcon3: "viewMoreSymbolicDefault"
                        }
                    }
                }

                LV.AppCard {
                    title: "Layout Primitives"
                    subtitle: "VStack, HStack, ZStack, Spacer"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap12

                        Rectangle {
                            width: parent.width
                            height: 96
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost

                            LV.HStack {
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap10
                                spacing: LV.Theme.gap8

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.accent
                                }

                                LV.Spacer { minLength: 20 }

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.surfaceSolid
                                }

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.danger
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 120
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost

                            LV.ZStack {
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap10

                                Rectangle {
                                    width: 220
                                    height: 80
                                    radius: LV.Theme.radiusMd
                                    color: LV.Theme.surfaceSolid
                                }

                                Rectangle {
                                    width: 140
                                    height: 52
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.accentOverlay
                                }

                                LV.Label {
                                    anchors.centerIn: parent
                                    text: "ZStack"
                                    style: body
                                    color: LV.Theme.textPrimary
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 128
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost

                            LV.VStack {
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap10
                                spacing: LV.Theme.gap6
                                alignmentName: "leading"

                                LV.Label { text: "VStack item A"; style: description }
                                LV.Label { text: "VStack item B"; style: description }
                                LV.Label { text: "VStack item C"; style: description }
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "Hierarchy / Outliner"
                    subtitle: "ToolbarButton x N + HierarchyItem x N"
                    Layout.fillWidth: true

                    Rectangle {
                        width: parent.width
                        height: 360
                        radius: LV.Theme.radiusMd
                        color: LV.Theme.surfaceGhost
                        clip: true

                        LV.Hierarchy {
                            id: hierarchyPreview
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: Math.min(240, parent.width * 0.55)
                            minimumPanelWidth: width
                            minimumPanelHeight: parent.height
                            onToolbarActivated: function(button, buttonId, index) {
                                LV.AppState.hierarchyActiveButtonId = buttonId >= 0 ? buttonId : (index + 1)
                            }
                            toolbarButtons: [
                                LV.ToolbarButton { buttonId: 1; iconName: "viewMoreSymbolicDefault" },
                                LV.ToolbarButton { buttonId: 2; iconName: "viewMoreSymbolicDefault" },
                                LV.ToolbarButton { buttonId: 3; iconName: "viewMoreSymbolicDefault" },
                                LV.ToolbarButton { buttonId: 4; iconName: "viewMoreSymbolicDefault" },
                                LV.ToolbarButton { buttonId: 5; iconName: "viewMoreSymbolicDefault" }
                            ]

                            LV.HierarchyItem { label: "World"; iconGlyph: "□"; showChevron: true; expanded: true; selected: true }
                            LV.HierarchyItem { label: "Environment"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            LV.HierarchyItem { label: "Directional Light"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            LV.HierarchyItem { label: "Sky Light"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            LV.HierarchyItem { label: "Characters"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            LV.HierarchyItem { label: "Player"; iconGlyph: "□"; indentLevel: 2; showChevron: true }
                            LV.HierarchyItem { label: "Camera Boom"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            LV.HierarchyItem { label: "Camera"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            LV.HierarchyItem { label: "Enemies"; iconGlyph: "□"; indentLevel: 2; showChevron: true }
                            LV.HierarchyItem { label: "Enemy_01"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            LV.HierarchyItem { label: "Enemy_02"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            LV.HierarchyItem { label: "Props"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            LV.HierarchyItem { label: "Barrel_A"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            LV.HierarchyItem { label: "Crate_B"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                        }

                        Column {
                            anchors.left: hierarchyPreview.right
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: LV.Theme.gap12
                            spacing: LV.Theme.gap8

                            LV.Label {
                                width: parent.width
                                style: body
                                color: LV.Theme.textPrimary
                                wrapMode: Text.WordWrap
                                text: "툴바는 상단 고정이며 버튼은 단일 선택으로 동작한다."
                            }

                            LV.Label {
                                width: parent.width
                                style: description
                                color: LV.Theme.textSecondary
                                wrapMode: Text.WordWrap
                                text: "activeToolbarButtonId = " + LV.AppState.hierarchyActiveButtonId
                            }

                            LV.Label {
                                width: parent.width
                                style: description
                                color: LV.Theme.textSecondary
                                wrapMode: Text.WordWrap
                                text: "아이템과 아이콘/텍스트는 각각의 컴포넌트 인자로 주입 가능하다."
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "App Scaffold Preview"
                    subtitle: "실제 페이지 골격 미리보기"
                    Layout.fillWidth: true

                    Rectangle {
                        width: parent.width
                        height: 360
                        radius: LV.Theme.radiusMd
                        color: LV.Theme.windowAlt
                        clip: true

                        LV.AppScaffold {
                            id: scaffoldPreview
                            anchors.fill: parent
                            headerTitle: "Scaffold"
                            headerSubtitle: "Nested Preview"
                            navModel: LV.AppState.scaffoldNavModel
                            navIndex: LV.AppState.scaffoldNavIndex
                            onNavActivated: function(index, item) {
                                LV.AppState.selectScaffoldNavIndex(index)
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: LV.Theme.gap10

                                LV.Label {
                                    text: "Selected nav index: " + LV.AppState.scaffoldNavIndex
                                    style: body
                                    color: LV.Theme.textPrimary
                                }

                                LV.Label {
                                    text: "현재 선택된 항목에 따라 내부 콘텐츠를 바꾸는 구조를 점검할 수 있다."
                                    style: description
                                    color: LV.Theme.textSecondary
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    spacing: LV.Theme.gap8

                                    LV.LabelButton {
                                        text: "Action"
                                        tone: LV.AbstractButton.Primary
                                    }

                                    LV.LabelButton {
                                        text: "Secondary"
                                        tone: LV.AbstractButton.Default
                                    }
                                }

                                LV.ProgressBar {
                                    Layout.fillWidth: true
                                    startValue: 0
                                    endValue: 1
                                    currentValue: LV.AppState.scaffoldNavIndex / Math.max(1, LV.AppState.scaffoldNavModel.length - 1)
                                    size: regular
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
