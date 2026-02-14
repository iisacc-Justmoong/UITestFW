pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LVRS as UIF

UIF.ApplicationWindow {
    id: root
    visible: true
    width: 1480
    height: 980
    title: "UI Framework Visual Catalog"
    subtitle: "컴포넌트 시각 점검용 메인 뷰"
    navItems: UIF.AppState.navItems

    readonly property bool compactGallery: width < 1260
    readonly property var accentPreviewTokens: [
        { name: "accentTransparent", hex: "transparent", color: UIF.Theme.accentTransparent },
        { name: "accentWhite", hex: "#FFFFFF", color: UIF.Theme.accentWhite },
        { name: "accentGrayLight", hex: "#CED0D6", color: UIF.Theme.accentGrayLight },
        { name: "accentBlue", hex: "#548AF7", color: UIF.Theme.accentBlue },
        { name: "accentRed", hex: "#DB5C5C", color: UIF.Theme.accentRed },
        { name: "accentSlate", hex: "#43454A", color: UIF.Theme.accentSlate },
        { name: "accentGreen", hex: "#57965C", color: UIF.Theme.accentGreen },
        { name: "accentBlueMuted", hex: "#25324D", color: UIF.Theme.accentBlueMuted },
        { name: "accentOrangeMuted", hex: "#C77D55", color: UIF.Theme.accentOrangeMuted },
        { name: "accentGreenMuted", hex: "#253627", color: UIF.Theme.accentGreenMuted },
        { name: "accentYellow", hex: "#F2C55C", color: UIF.Theme.accentYellow },
        { name: "accentRedBrownDark", hex: "#402929", color: UIF.Theme.accentRedBrownDark },
        { name: "accentGray", hex: "#868A91", color: UIF.Theme.accentGray },
        { name: "accentYellowMuted", hex: "#D6AE58", color: UIF.Theme.accentYellowMuted },
        { name: "accentBrownMuted", hex: "#45322B", color: UIF.Theme.accentBrownMuted },
        { name: "accentPurple", hex: "#A571E6", color: UIF.Theme.accentPurple },
        { name: "accentBrownDarker", hex: "#3D3223", color: UIF.Theme.accentBrownDarker },
        { name: "accentCharcoal", hex: "#1E1F22", color: UIF.Theme.accentCharcoal },
        { name: "accentGrayPale", hex: "#B4B8BF", color: UIF.Theme.accentGrayPale },
        { name: "accentBlueBright", hex: "#3574F0", color: UIF.Theme.accentBlueBright },
        { name: "accentPurpleDarker", hex: "#2F2936", color: UIF.Theme.accentPurpleDarker },
        { name: "accentGrayBright", hex: "#F0F1F2", color: UIF.Theme.accentGrayBright },
        { name: "accentRose", hex: "#E55765", color: UIF.Theme.accentRose },
        { name: "accentRoseDarker", hex: "#5E3838", color: UIF.Theme.accentRoseDarker },
        { name: "accentGrayMuted", hex: "#5A5D63", color: UIF.Theme.accentGrayMuted },
        { name: "accentGreenBright", hex: "#55A76A", color: UIF.Theme.accentGreenBright },
        { name: "accentRedMuted", hex: "#BD5757", color: UIF.Theme.accentRedMuted },
        { name: "accentRedDark", hex: "#9C4E4E", color: UIF.Theme.accentRedDark },
        { name: "accentRedDarker", hex: "#7A4343", color: UIF.Theme.accentRedDarker },
        { name: "accentSlateMuted", hex: "#6F737A", color: UIF.Theme.accentSlateMuted },
        { name: "accentSlateDarker", hex: "#6C707E", color: UIF.Theme.accentSlateDarker },
        { name: "accentGreenDarker", hex: "#375239", color: UIF.Theme.accentGreenDarker }
    ]

    readonly property var runtimeSnapshot: UIF.AppState.runtimeSnapshot
    readonly property var viewStateSnapshot: UIF.AppState.viewStateSnapshot
    readonly property bool metricsRenderScaleCompliant:
        effectiveSupersampleScale >= 1.0
        && effectiveSupersampleScale <= UIF.RenderQuality.maximumSupersampleScale
    readonly property bool metricsFontFallbackCompliant:
        UIF.Theme.fontBody.length > 0
        && UIF.FontPolicy.resolveFamily(UIF.FontPolicy.preferredFamily).length > 0
    readonly property bool metricsThemeTextCompliant:
        UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle, UIF.Theme.textTitleWeight, UIF.Theme.textTitleStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle2, UIF.Theme.textTitle2Weight, UIF.Theme.textTitle2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader, UIF.Theme.textHeaderWeight, UIF.Theme.textHeaderStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader2, UIF.Theme.textHeader2Weight, UIF.Theme.textHeader2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textBody, UIF.Theme.textBodyWeight, UIF.Theme.textBodyStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textDescription, UIF.Theme.textDescriptionWeight, UIF.Theme.textDescriptionStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textCaption, UIF.Theme.textCaptionWeight, UIF.Theme.textCaptionStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textDisabled, UIF.Theme.textDisabledWeight, UIF.Theme.textDisabledStyleName)
    readonly property bool metricsRuntimeCompliant:
        runtimeSnapshot
        && runtimeSnapshot.pid !== undefined
        && runtimeSnapshot.uptimeMs !== undefined
        && runtimeSnapshot.rssBytes !== undefined
    readonly property bool metricsSvgCompliant:
        UIF.SvgManager.minimumScale >= 1.0
        && UIF.SvgManager.maximumScale >= UIF.SvgManager.minimumScale
    readonly property bool metricsPageCompliant:
        UIF.AppState.pageHistory.length > 0
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
        UIF.AppState.nudgeProgress(delta)
    }

    Component.onCompleted: {
        UIF.AppState.bootstrap()
        UIF.FontPolicy.enforceApplicationFallback()
        UIF.RenderMonitor.attachWindow(root)
        UIF.PageMonitor.record("/visual-catalog")
        UIF.AppState.syncPageHistory(UIF.PageMonitor.history)
        UIF.AppState.syncRuntimeSnapshot(UIF.RuntimeEvents.snapshot())
        UIF.AppState.syncViewStateSnapshot(UIF.ViewStateTracker.snapshot())
        UIF.Debug.enabled = true
        UIF.Debug.log("Main", "visual-catalog-opened")
    }

    Connections {
        target: UIF.RuntimeEvents
        ignoreUnknownSignals: true
        function onOsStatsChanged() {
            UIF.AppState.syncRuntimeSnapshot(UIF.RuntimeEvents.snapshot())
        }
        function onUiChanged() {
            UIF.AppState.syncRuntimeSnapshot(UIF.RuntimeEvents.snapshot())
        }
        function onRunningChanged() {
            UIF.AppState.syncRuntimeSnapshot(UIF.RuntimeEvents.snapshot())
        }
    }

    Connections {
        target: UIF.ViewStateTracker
        ignoreUnknownSignals: true
        function onStackChanged() {
            UIF.AppState.syncViewStateSnapshot(UIF.ViewStateTracker.snapshot())
        }
    }

    Connections {
        target: UIF.PageMonitor
        ignoreUnknownSignals: true
        function onHistoryChanged() {
            UIF.AppState.syncPageHistory(UIF.PageMonitor.history)
        }
    }

    UIF.Alert {
        id: sampleAlert
        anchors.fill: parent
        open: UIF.AppState.alertOpen
        title: "Alert Dialog"
        message: "It can have 2 or 3 actions depending on your needs."
        primaryText: "Button"
        secondaryText: "Button"
        tertiaryText: "Button"
        onPrimaryClicked: UIF.AppState.alertOpen = false
        onSecondaryClicked: UIF.AppState.alertOpen = false
        onTertiaryClicked: UIF.AppState.alertOpen = false
        onDismissed: UIF.AppState.alertOpen = false
    }

    UIF.ContextMenu {
        id: demoContextMenu
        items: UIF.AppState.demoContextMenuItems
    }

    Component {
        id: routeOverview

        Rectangle {
            color: UIF.Theme.surfaceGhost
            radius: UIF.Theme.radiusMd

            UIF.Label {
                anchors.centerIn: parent
                text: "Route: Overview"
                style: body
                color: UIF.Theme.textPrimary
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
                text: "Route: Reports"
                style: body
                color: UIF.Theme.textPrimary
            }
        }
    }

    Component {
        id: routeRuns

        Rectangle {
            color: UIF.Theme.surfaceAlt
            radius: UIF.Theme.radiusMd

            UIF.Label {
                anchors.centerIn: parent
                text: "Route: Runs"
                style: body
                color: UIF.Theme.textPrimary
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
                text: "Route: Settings"
                style: body
                color: UIF.Theme.textPrimary
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Item {
            width: Math.max(root.width - UIF.Theme.gap24 * 2, 960)
            implicitHeight: pageColumn.implicitHeight + UIF.Theme.gap24

            ColumnLayout {
                id: pageColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: UIF.Theme.gap12
                spacing: UIF.Theme.gap12

                UIF.AppCard {
                    title: "Overview"
                    subtitle: "컴포넌트 탐색 시작점"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap12

                        UIF.Label {
                            width: parent.width
                            style: description
                            color: UIF.Theme.textSecondary
                            wrapMode: Text.WordWrap
                            text: "이 페이지는 LVRS의 핵심 컴포넌트를 상태별로 묶어 보여주는 시각 카탈로그이다."
                        }

                        RowLayout {
                            width: parent.width
                            spacing: UIF.Theme.gap8

                            UIF.LabelButton {
                                text: "Open Alert"
                                tone: UIF.AbstractButton.Primary
                                onClicked: UIF.AppState.alertOpen = true
                            }

                            UIF.LabelButton {
                                id: menuButton
                                text: "Open Context Menu"
                                tone: UIF.AbstractButton.Default
                                onClicked: {
                                    const origin = menuButton.mapToItem(null, 0, menuButton.height + 6)
                                    demoContextMenu.openAt(origin.x, origin.y)
                                }
                            }

                            UIF.LabelButton {
                                text: "Stop Monitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.stop()
                            }

                            UIF.LabelButton {
                                text: "Start Monitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.start()
                            }
                        }

                        RowLayout {
                            width: parent.width
                            spacing: UIF.Theme.gap10

                            UIF.Label {
                                style: description
                                color: UIF.Theme.textSecondary
                                text: "Progress"
                            }

                            Slider {
                                id: progressSlider
                                Layout.fillWidth: true
                                from: Math.min(UIF.AppState.progressStart, UIF.AppState.progressEnd)
                                to: Math.max(UIF.AppState.progressStart, UIF.AppState.progressEnd)
                                value: UIF.AppState.progressCurrent
                                stepSize: 1
                                onMoved: UIF.AppState.progressCurrent = value
                                onValueChanged: {
                                    if (Math.abs(UIF.AppState.progressCurrent - value) > 0.000001)
                                        UIF.AppState.progressCurrent = value
                                }
                            }

                            UIF.LabelButton {
                                text: "-10"
                                tone: UIF.AbstractButton.Default
                                onClicked: root.nudgeProgress(-10)
                            }

                            UIF.LabelButton {
                                text: "+10"
                                tone: UIF.AbstractButton.Default
                                onClicked: root.nudgeProgress(10)
                            }
                        }

                        UIF.Label {
                            style: caption
                            color: UIF.Theme.textTertiary
                            text: "start=" + UIF.AppState.progressStart.toFixed(0)
                                + " end=" + UIF.AppState.progressEnd.toFixed(0)
                                + " current=" + UIF.AppState.progressCurrent.toFixed(0)
                        }

                        UIF.ProgressBar {
                            width: parent.width
                            size: large
                            startValue: UIF.AppState.progressStart
                            endValue: UIF.AppState.progressEnd
                            currentValue: UIF.AppState.progressCurrent
                        }

                        UIF.ProgressBar {
                            width: parent.width
                            size: regular
                            startValue: UIF.AppState.progressStart
                            endValue: UIF.AppState.progressEnd
                            currentValue: UIF.AppState.progressCurrent
                        }
                    }
                }

                UIF.AppCard {
                    title: "Typography"
                    subtitle: "Label 스타일 스케일"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap8

                        UIF.Label { text: "Title"; style: title }
                        UIF.Label { text: "Title2"; style: title2 }
                        UIF.Label { text: "Header"; style: header }
                        UIF.Label { text: "Header2"; style: header2 }
                        UIF.Label { text: "Body"; style: body }
                        UIF.Label { text: "Description"; style: description }
                        UIF.Label { text: "Caption"; style: caption }
                        UIF.Label { text: "Disabled"; style: disabled }
                    }
                }

                UIF.AppCard {
                    title: "Buttons"
                    subtitle: "Tone별 버튼 패밀리 + 상태 테마 스와치"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap12

                        UIF.Label { text: "Primary"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Primary }
                            UIF.IconButton { tone: UIF.AbstractButton.Primary }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Primary }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Primary }
                        }

                        UIF.Label { text: "Default"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Default }
                            UIF.IconButton { tone: UIF.AbstractButton.Default }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Default }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Default }
                        }

                        UIF.Label { text: "Borderless"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Borderless }
                            UIF.IconButton { tone: UIF.AbstractButton.Borderless }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Borderless }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Borderless }
                        }

                        UIF.Label { text: "Destructive"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Destructive }
                            UIF.IconButton { tone: UIF.AbstractButton.Destructive }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Destructive }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Destructive }
                        }

                        UIF.Label { text: "Disabled"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Disabled }
                            UIF.IconButton { tone: UIF.AbstractButton.Disabled }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Disabled }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Disabled }
                        }

                        UIF.Label { text: "State Swatches"; style: caption; color: UIF.Theme.textTertiary }

                        GridLayout {
                            width: parent.width
                            columns: root.compactGallery ? 1 : 2
                            rowSpacing: UIF.Theme.gap10
                            columnSpacing: UIF.Theme.gap10

                            Rectangle {
                                Layout.fillWidth: true
                                radius: UIF.Theme.radiusSm
                                color: UIF.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: UIF.Theme.gap8
                                    spacing: UIF.Theme.gap6

                                    UIF.Label { text: "Primary"; style: caption; color: UIF.Theme.textSecondary }
                                    Row {
                                        spacing: UIF.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.primary; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: Qt.darker(UIF.Theme.primary, 1.12); UIF.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: Qt.darker(UIF.Theme.primary, 1.2); UIF.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.subSurface; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: UIF.Theme.radiusSm
                                color: UIF.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: UIF.Theme.gap8
                                    spacing: UIF.Theme.gap6

                                    UIF.Label { text: "Default"; style: caption; color: UIF.Theme.textSecondary }
                                    Row {
                                        spacing: UIF.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.surfaceSolid; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.surfaceAlt; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.primary; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.subSurface; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: UIF.Theme.radiusSm
                                color: UIF.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: UIF.Theme.gap8
                                    spacing: UIF.Theme.gap6

                                    UIF.Label { text: "Borderless"; style: caption; color: UIF.Theme.textSecondary }
                                    Row {
                                        spacing: UIF.Theme.gap6
                                        Rectangle {
                                            width: 58
                                            height: 24
                                            radius: UIF.Theme.radiusSm
                                            color: "transparent"
                                            border.width: 1
                                            border.color: UIF.Theme.surfaceAlt
                                            UIF.Label { anchors.centerIn: parent; style: disabled; text: "Base" }
                                        }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.surfaceAlt; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.primary; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle {
                                            width: 58
                                            height: 24
                                            radius: UIF.Theme.radiusSm
                                            color: "transparent"
                                            border.width: 1
                                            border.color: UIF.Theme.surfaceAlt
                                            UIF.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: UIF.Theme.radiusSm
                                color: UIF.Theme.surfaceGhost
                                implicitHeight: 74

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: UIF.Theme.gap8
                                    spacing: UIF.Theme.gap6

                                    UIF.Label { text: "Destructive"; style: caption; color: UIF.Theme.textSecondary }
                                    Row {
                                        spacing: UIF.Theme.gap6
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.danger; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Base" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: Qt.darker(UIF.Theme.danger, 1.12); UIF.Label { anchors.centerIn: parent; style: disabled; text: "Hover" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: Qt.darker(UIF.Theme.danger, 1.2); UIF.Label { anchors.centerIn: parent; style: disabled; text: "Press" } }
                                        Rectangle { width: 58; height: 24; radius: UIF.Theme.radiusSm; color: UIF.Theme.subSurface; UIF.Label { anchors.centerIn: parent; style: disabled; text: "Inactive" } }
                                    }
                                }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Accent Palette"
                    subtitle: "iconset 기반 전체 accent 컬러 프리뷰"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 2 : 3
                        rowSpacing: UIF.Theme.gap8
                        columnSpacing: UIF.Theme.gap8

                        Repeater {
                            model: root.accentPreviewTokens

                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                implicitHeight: 66
                                radius: UIF.Theme.radiusSm
                                color: UIF.Theme.surfaceGhost

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: UIF.Theme.gap8
                                    spacing: UIF.Theme.gap8

                                    Rectangle {
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        radius: UIF.Theme.radiusXs
                                        color: modelData.color
                                        border.width: modelData.name === "accentTransparent" ? 1 : 0
                                        border.color: UIF.Theme.textTertiary
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: UIF.Theme.gap2

                                        UIF.Label {
                                            Layout.fillWidth: true
                                            style: caption
                                            text: modelData.name
                                            color: UIF.Theme.textSecondary
                                            elide: Text.ElideRight
                                        }
                                        UIF.Label {
                                            Layout.fillWidth: true
                                            style: disabled
                                            text: modelData.hex
                                            color: UIF.Theme.textTertiary
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Input Fields"
                    subtitle: "텍스트 입력 상태"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 2
                        rowSpacing: UIF.Theme.gap10
                        columnSpacing: UIF.Theme.gap10

                        UIF.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Placeholder"
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            text: "Filled value"
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            text: "Read only"
                            readOnly: true
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Disabled"
                            enabled: false
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            text: "1024"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            mode: searchMode
                            placeholderText: "Search"
                        }

                        UIF.InputField {
                            Layout.fillWidth: true
                            mode: searchMode
                            text: "network logs"
                        }
                    }
                }

                UIF.AppCard {
                    title: "Editors"
                    subtitle: "TextEditor와 CodeEditor"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 2
                        rowSpacing: UIF.Theme.gap12
                        columnSpacing: UIF.Theme.gap12

                        UIF.TextEditor {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240
                            mode: markdownMode
                            text: "# Notes\\n- Build verification\\n- Visual inspection\\n\\n`Ctrl+Enter` submits."
                            placeholderText: "Write markdown notes"
                        }

                        UIF.CodeEditor {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 240
                            snippetTitle: "main.qml"
                            snippetLanguage: "QML"
                            text: "import QtQuick\\n\\nRectangle {\\n    width: 160\\n    height: 48\\n    radius: 8\\n}"
                            placeholderText: "Write code"
                        }
                    }
                }

                UIF.AppCard {
                    title: "Check Controls"
                    subtitle: "선택형 컴포넌트"
                    Layout.fillWidth: true

                    GridLayout {
                        width: parent.width
                        columns: root.compactGallery ? 1 : 3
                        rowSpacing: UIF.Theme.gap12
                        columnSpacing: UIF.Theme.gap12

                        Column {
                            spacing: UIF.Theme.gap8
                            UIF.Label { text: "CheckBox"; style: caption; color: UIF.Theme.textTertiary }
                            UIF.CheckBox { text: "On"; checked: true }
                            UIF.CheckBox { text: "Off"; checked: false }
                            UIF.CheckBox { text: "Disabled"; checked: true; enabled: false }
                        }

                        Column {
                            spacing: UIF.Theme.gap8
                            UIF.Label { text: "RadioButton"; style: caption; color: UIF.Theme.textTertiary }
                            UIF.RadioButton { text: "Option A"; checked: true }
                            UIF.RadioButton { text: "Option B"; checked: false }
                            UIF.RadioButton { text: "Option C"; checked: false; enabled: false }
                        }

                        Column {
                            spacing: UIF.Theme.gap8
                            UIF.Label { text: "ToggleSwitch"; style: caption; color: UIF.Theme.textTertiary }
                            UIF.ToggleSwitch { text: "Enabled"; checked: true }
                            UIF.ToggleSwitch { text: "Disabled"; checked: false; enabled: false }
                            UIF.ToggleSwitch { checked: false }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Navigation"
                    subtitle: "Router, Link, List"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap12

                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8

                            UIF.Link {
                                text: "Go Overview"
                                to: "/overview"
                            }

                            UIF.Link {
                                text: "Go Reports"
                                to: "/reports"
                            }

                            UIF.Link {
                                text: "Go Runs"
                                href: "/runs"
                                underline: true
                            }

                            UIF.Link {
                                href: "/settings"

                                Rectangle {
                                    width: 148
                                    height: 30
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.surfaceSolid

                                    UIF.Label {
                                        anchors.centerIn: parent
                                        style: description
                                        color: UIF.Theme.textPrimary
                                        text: "Link -> Settings"
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 170
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost
                            clip: true

                            UIF.PageRouter {
                                id: demoRouter
                                anchors.fill: parent
                                anchors.margins: UIF.Theme.gap8
                                initialPath: "/overview"
                                routes: [
                                    { path: "/overview", component: routeOverview },
                                    { path: "/reports", component: routeReports },
                                    { path: "/runs", component: routeRuns },
                                    { path: "/settings", component: routeSettings }
                                ]
                                onNavigated: function(path, params) {
                                    UIF.PageMonitor.record(path)
                                }
                                onNavigationFailed: function(path) {
                                    UIF.AppState.currentRoute = "not-found: " + path
                                }
                            }
                        }

                        UIF.Label {
                            style: caption
                            color: UIF.Theme.textTertiary
                            text: "currentPath = " + UIF.AppState.currentRoute
                        }

                        UIF.List {
                            width: parent.width
                            items: UIF.AppState.demoListItems
                            toolbarIcon1: "viewMoreSymbolicDefault"
                            toolbarIcon2: "viewMoreSymbolicDefault"
                            toolbarIcon3: "viewMoreSymbolicDefault"
                        }
                    }
                }

                UIF.AppCard {
                    title: "Layout Primitives"
                    subtitle: "VStack, HStack, ZStack, Spacer"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap12

                        Rectangle {
                            width: parent.width
                            height: 96
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost

                            UIF.HStack {
                                anchors.fill: parent
                                anchors.margins: UIF.Theme.gap10
                                spacing: UIF.Theme.gap8

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.accent
                                }

                                UIF.Spacer { minLength: 20 }

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.surfaceSolid
                                }

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 28
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.danger
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 120
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost

                            UIF.ZStack {
                                anchors.fill: parent
                                anchors.margins: UIF.Theme.gap10

                                Rectangle {
                                    width: 220
                                    height: 80
                                    radius: UIF.Theme.radiusMd
                                    color: UIF.Theme.surfaceSolid
                                }

                                Rectangle {
                                    width: 140
                                    height: 52
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.accentOverlay
                                }

                                UIF.Label {
                                    anchors.centerIn: parent
                                    text: "ZStack"
                                    style: body
                                    color: UIF.Theme.textPrimary
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 128
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceGhost

                            UIF.VStack {
                                anchors.fill: parent
                                anchors.margins: UIF.Theme.gap10
                                spacing: UIF.Theme.gap6
                                alignmentName: "leading"

                                UIF.Label { text: "VStack item A"; style: description }
                                UIF.Label { text: "VStack item B"; style: description }
                                UIF.Label { text: "VStack item C"; style: description }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Hierarchy / Outliner"
                    subtitle: "ToolbarButton x N + HierarchyItem x N"
                    Layout.fillWidth: true

                    Rectangle {
                        width: parent.width
                        height: 360
                        radius: UIF.Theme.radiusMd
                        color: UIF.Theme.surfaceGhost
                        clip: true

                        UIF.Hierarchy {
                            id: hierarchyPreview
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: Math.min(240, parent.width * 0.55)
                            minimumPanelWidth: width
                            minimumPanelHeight: parent.height
                            onToolbarActivated: function(button, buttonId, index) {
                                UIF.AppState.hierarchyActiveButtonId = buttonId >= 0 ? buttonId : (index + 1)
                            }
                            toolbarButtons: [
                                UIF.ToolbarButton { buttonId: 1; iconName: "viewMoreSymbolicDefault" },
                                UIF.ToolbarButton { buttonId: 2; iconName: "viewMoreSymbolicDefault" },
                                UIF.ToolbarButton { buttonId: 3; iconName: "viewMoreSymbolicDefault" },
                                UIF.ToolbarButton { buttonId: 4; iconName: "viewMoreSymbolicDefault" },
                                UIF.ToolbarButton { buttonId: 5; iconName: "viewMoreSymbolicDefault" }
                            ]

                            UIF.HierarchyItem { label: "World"; iconGlyph: "□"; showChevron: true; expanded: true; selected: true }
                            UIF.HierarchyItem { label: "Environment"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            UIF.HierarchyItem { label: "Directional Light"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            UIF.HierarchyItem { label: "Sky Light"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            UIF.HierarchyItem { label: "Characters"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            UIF.HierarchyItem { label: "Player"; iconGlyph: "□"; indentLevel: 2; showChevron: true }
                            UIF.HierarchyItem { label: "Camera Boom"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            UIF.HierarchyItem { label: "Camera"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            UIF.HierarchyItem { label: "Enemies"; iconGlyph: "□"; indentLevel: 2; showChevron: true }
                            UIF.HierarchyItem { label: "Enemy_01"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            UIF.HierarchyItem { label: "Enemy_02"; iconGlyph: "□"; indentLevel: 3; showChevron: false }
                            UIF.HierarchyItem { label: "Props"; iconGlyph: "□"; indentLevel: 1; showChevron: true }
                            UIF.HierarchyItem { label: "Barrel_A"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                            UIF.HierarchyItem { label: "Crate_B"; iconGlyph: "□"; indentLevel: 2; showChevron: false }
                        }

                        Column {
                            anchors.left: hierarchyPreview.right
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: UIF.Theme.gap12
                            spacing: UIF.Theme.gap8

                            UIF.Label {
                                width: parent.width
                                style: body
                                color: UIF.Theme.textPrimary
                                wrapMode: Text.WordWrap
                                text: "툴바는 상단 고정이며 버튼은 단일 선택으로 동작한다."
                            }

                            UIF.Label {
                                width: parent.width
                                style: description
                                color: UIF.Theme.textSecondary
                                wrapMode: Text.WordWrap
                                text: "activeToolbarButtonId = " + UIF.AppState.hierarchyActiveButtonId
                            }

                            UIF.Label {
                                width: parent.width
                                style: description
                                color: UIF.Theme.textSecondary
                                wrapMode: Text.WordWrap
                                text: "아이템과 아이콘/텍스트는 각각의 컴포넌트 인자로 주입 가능하다."
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "App Scaffold Preview"
                    subtitle: "실제 페이지 골격 미리보기"
                    Layout.fillWidth: true

                    Rectangle {
                        width: parent.width
                        height: 360
                        radius: UIF.Theme.radiusMd
                        color: UIF.Theme.windowAlt
                        clip: true

                        UIF.AppScaffold {
                            id: scaffoldPreview
                            anchors.fill: parent
                            headerTitle: "Scaffold"
                            headerSubtitle: "Nested Preview"
                            navModel: UIF.AppState.scaffoldNavModel
                            navIndex: UIF.AppState.scaffoldNavIndex
                            onNavActivated: function(index, item) {
                                UIF.AppState.selectScaffoldNavIndex(index)
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: UIF.Theme.gap10

                                UIF.Label {
                                    text: "Selected nav index: " + UIF.AppState.scaffoldNavIndex
                                    style: body
                                    color: UIF.Theme.textPrimary
                                }

                                UIF.Label {
                                    text: "현재 선택된 항목에 따라 내부 콘텐츠를 바꾸는 구조를 점검할 수 있다."
                                    style: description
                                    color: UIF.Theme.textSecondary
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    spacing: UIF.Theme.gap8

                                    UIF.LabelButton {
                                        text: "Action"
                                        tone: UIF.AbstractButton.Primary
                                    }

                                    UIF.LabelButton {
                                        text: "Secondary"
                                        tone: UIF.AbstractButton.Default
                                    }
                                }

                                UIF.ProgressBar {
                                    Layout.fillWidth: true
                                    startValue: 0
                                    endValue: 1
                                    currentValue: UIF.AppState.scaffoldNavIndex / Math.max(1, UIF.AppState.scaffoldNavModel.length - 1)
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
