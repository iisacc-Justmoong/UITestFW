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
    title: "UI Framework Visual Catalog"
    subtitle: "컴포넌트 시각 점검용 메인 뷰"
    navItems: [
        { label: "Overview", icon: "◉", badge: "1" },
        { label: "Controls", icon: "▣", badge: "5" },
        { label: "Navigation", icon: "⇄", badge: "2" },
        { label: "Layout", icon: "◫", badge: "2" }
    ]

    property bool alertOpen: false
    property real progressStart: 0
    property real progressEnd: 100
    property real progressCurrent: 46
    property string currentRoute: "/overview"
    property int scaffoldNavIndex: 0
    property int hierarchyActiveButtonId: 1
    readonly property bool compactGallery: width < 1260

    property var scaffoldNavModel: [
        { label: "Overview", icon: "◉", badge: "4" },
        { label: "Runs", icon: "▣", badge: "9" },
        { label: "Devices", icon: "⌘", badge: "2" },
        { label: "Settings", icon: "⚙", badge: "1" }
    ]

    property var demoListItems: [
        { label: "Overview", detail: "Cmd+1", selected: true, showChevron: true },
        { label: "Reports", detail: "Cmd+2", showChevron: true },
        { label: "Settings", detail: "Cmd+,", showChevron: false }
    ]

    property var demoContextMenuItems: [
        { id: "new", label: "New Run", key: "Cmd+N", showChevron: false },
        { id: "open", label: "Open Recent", key: "Cmd+O", showChevron: true },
        { type: "divider" },
        { id: "archive", label: "Archive", key: "Cmd+E", showChevron: false }
    ]

    function clampProgress(value) {
        const minValue = Math.min(progressStart, progressEnd)
        const maxValue = Math.max(progressStart, progressEnd)
        return Math.max(minValue, Math.min(maxValue, value))
    }

    function nudgeProgress(delta) {
        progressCurrent = clampProgress(progressCurrent + delta)
    }

    onProgressStartChanged: progressCurrent = clampProgress(progressCurrent)
    onProgressEndChanged: progressCurrent = clampProgress(progressCurrent)

    Component.onCompleted: {
        UIF.FontPolicy.enforceApplicationFallback()
        UIF.RenderMonitor.attachWindow(root)
        UIF.PageMonitor.record("/visual-catalog")
        UIF.Debug.enabled = true
        UIF.Debug.log("Main", "visual-catalog-opened")
    }

    UIF.Alert {
        id: sampleAlert
        anchors.fill: parent
        open: root.alertOpen
        title: "Alert Dialog"
        message: "It can have 2 or 3 actions depending on your needs."
        primaryText: "Button"
        secondaryText: "Button"
        tertiaryText: "Button"
        onPrimaryClicked: root.alertOpen = false
        onSecondaryClicked: root.alertOpen = false
        onTertiaryClicked: root.alertOpen = false
        onDismissed: root.alertOpen = false
    }

    UIF.ContextMenu {
        id: demoContextMenu
        items: root.demoContextMenuItems
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
                            text: "이 페이지는 UIFramework의 핵심 컴포넌트를 상태별로 묶어 보여주는 시각 카탈로그이다."
                        }

                        RowLayout {
                            width: parent.width
                            spacing: UIF.Theme.gap8

                            UIF.LabelButton {
                                text: "Open Alert"
                                tone: UIF.AbstractButton.Accent
                                onClicked: root.alertOpen = true
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
                                from: Math.min(root.progressStart, root.progressEnd)
                                to: Math.max(root.progressStart, root.progressEnd)
                                value: root.progressCurrent
                                stepSize: 1
                                onMoved: root.progressCurrent = value
                                onValueChanged: {
                                    if (Math.abs(root.progressCurrent - value) > 0.000001)
                                        root.progressCurrent = value
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
                            text: "start=" + root.progressStart.toFixed(0)
                                + " end=" + root.progressEnd.toFixed(0)
                                + " current=" + root.progressCurrent.toFixed(0)
                        }

                        UIF.ProgressBar {
                            width: parent.width
                            size: large
                            startValue: root.progressStart
                            endValue: root.progressEnd
                            currentValue: root.progressCurrent
                        }

                        UIF.ProgressBar {
                            width: parent.width
                            size: regular
                            startValue: root.progressStart
                            endValue: root.progressEnd
                            currentValue: root.progressCurrent
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
                    subtitle: "Tone별 버튼 패밀리"
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: UIF.Theme.gap12

                        UIF.Label { text: "Accent"; style: caption; color: UIF.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: UIF.Theme.gap8
                            UIF.LabelButton { text: "Label"; tone: UIF.AbstractButton.Accent }
                            UIF.IconButton { tone: UIF.AbstractButton.Accent }
                            UIF.LabelMenuButton { text: "Menu"; tone: UIF.AbstractButton.Accent }
                            UIF.IconMenuButton { tone: UIF.AbstractButton.Accent }
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

                            UIF.NavigationLink {
                                text: "Go Overview"
                                to: "/overview"
                                router: demoRouter
                            }

                            UIF.NavigationLink {
                                text: "Go Reports"
                                to: "/reports"
                                router: demoRouter
                            }

                            UIF.Link {
                                text: "Go Runs"
                                href: "/runs"
                                router: demoRouter
                                underline: true
                            }

                            UIF.LinkWrapper {
                                href: "/settings"
                                router: demoRouter

                                Rectangle {
                                    width: 148
                                    height: 30
                                    radius: UIF.Theme.radiusSm
                                    color: UIF.Theme.surfaceSolid

                                    UIF.Label {
                                        anchors.centerIn: parent
                                        style: description
                                        color: UIF.Theme.textPrimary
                                        text: "Wrapper -> Settings"
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
                                    root.currentRoute = path
                                }
                                onNavigationFailed: function(path) {
                                    root.currentRoute = "not-found: " + path
                                }
                            }
                        }

                        UIF.Label {
                            style: caption
                            color: UIF.Theme.textTertiary
                            text: "currentPath = " + root.currentRoute
                        }

                        UIF.List {
                            width: parent.width
                            items: root.demoListItems
                            toolbarIcon1: "view-more-symbolic-default"
                            toolbarIcon2: "view-more-symbolic-default"
                            toolbarIcon3: "view-more-symbolic-default"
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
                                root.hierarchyActiveButtonId = buttonId >= 0 ? buttonId : (index + 1)
                            }
                            toolbarButtons: [
                                UIF.ToolbarButton { buttonId: 1; iconName: "view-more-symbolic-default" },
                                UIF.ToolbarButton { buttonId: 2; iconName: "view-more-symbolic-default" },
                                UIF.ToolbarButton { buttonId: 3; iconName: "view-more-symbolic-default" },
                                UIF.ToolbarButton { buttonId: 4; iconName: "view-more-symbolic-default" },
                                UIF.ToolbarButton { buttonId: 5; iconName: "view-more-symbolic-default" }
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
                                text: "activeToolbarButtonId = " + root.hierarchyActiveButtonId
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
                            navModel: root.scaffoldNavModel
                            navIndex: root.scaffoldNavIndex
                            onNavActivated: function(index, item) {
                                root.scaffoldNavIndex = index
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: UIF.Theme.gap10

                                UIF.Label {
                                    text: "Selected nav index: " + root.scaffoldNavIndex
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
                                        tone: UIF.AbstractButton.Accent
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
                                    currentValue: root.scaffoldNavIndex / Math.max(1, root.scaffoldNavModel.length - 1)
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
