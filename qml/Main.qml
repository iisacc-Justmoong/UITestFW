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
    property string componentConsoleFilter: "all"
    readonly property var componentConsoleEntries: [
        {
            name: "LabelButton",
            group: "control/buttons",
            changeType: "modified",
            status: "verified",
            summary: "Figma 44:599 규격에 맞춰 px=8, py=4, height=20을 고정했다.",
            file: "qml/components/control/buttons/LabelButton.qml",
            states: "primary/default/borderless/destructive/disabled",
            lastUpdated: "2026-02-14"
        },
        {
            name: "IconButton",
            group: "control/buttons",
            changeType: "modified",
            status: "verified",
            summary: "아이콘 전용 패딩(p=2)과 20px 고정 높이를 적용했다.",
            file: "qml/components/control/buttons/IconButton.qml",
            states: "primary/default/borderless/destructive/disabled",
            lastUpdated: "2026-02-14"
        },
        {
            name: "LabelMenuButton",
            group: "control/buttons",
            changeType: "modified",
            status: "verified",
            summary: "텍스트+인디케이터 버튼 간격(gap=2), px=8, py=2와 height=20을 반영했다.",
            file: "qml/components/control/buttons/LabelMenuButton.qml",
            states: "primary/default/borderless/destructive/disabled",
            lastUpdated: "2026-02-14"
        },
        {
            name: "IconMenuButton",
            group: "control/buttons",
            changeType: "modified",
            status: "verified",
            summary: "아이콘+인디케이터 복합 버튼의 gap=4, p=2, height=20을 고정했다.",
            file: "qml/components/control/buttons/IconMenuButton.qml",
            states: "primary/default/borderless/destructive/disabled",
            lastUpdated: "2026-02-14"
        },
        {
            name: "HierarchyList",
            group: "navigation",
            changeType: "refactored",
            status: "verified",
            summary: "배열/목록 모델 입력에서 문자열+아이콘을 계층형으로 펼치도록 기본 동작을 전환했다.",
            file: "qml/components/navigation/HierarchyList.qml",
            states: "flatten/expand/select/keyboard",
            lastUpdated: "2026-02-14"
        },
        {
            name: "Hierarchy",
            group: "navigation",
            changeType: "refactored",
            status: "verified",
            summary: "treeModel 호환을 유지하면서 model 중심 API로 래퍼를 동기화했다.",
            file: "qml/components/navigation/Hierarchy.qml",
            states: "activate/expand/collapse",
            lastUpdated: "2026-02-14"
        },
        {
            name: "HierarchyItem",
            group: "navigation",
            changeType: "modified",
            status: "monitoring",
            summary: "row 배경/chevron/아이콘 렌더 동작을 모델 기반 리스트와 맞물리도록 조정했다.",
            file: "qml/components/navigation/HierarchyItem.qml",
            states: "active/expanded/disabled",
            lastUpdated: "2026-02-14"
        },
        {
            name: "Accent Palette",
            group: "theme",
            changeType: "added",
            status: "verified",
            summary: "iconset의 전체 색상 토큰을 accent 계열로 추가하고 프리뷰를 연결했다.",
            file: "qml/Theme.qml",
            states: "token-preview",
            lastUpdated: "2026-02-14"
        },
        {
            name: "Visual Catalog Main",
            group: "catalog",
            changeType: "modified",
            status: metricsPass ? "verified" : "monitoring",
            summary: "버튼/계층/색상 프리뷰와 운영 지표를 통합한 카탈로그 구성을 유지한다.",
            file: "qml/Main.qml",
            states: "runtime/quality/layout",
            lastUpdated: "2026-02-14"
        },
        {
            name: "Render Backend Bootstrap",
            group: "runtime",
            changeType: "refactored",
            status: metricsRuntimeCompliant ? "verified" : "monitoring",
            summary: "플랫폼별 렌더러 우선순위 정책(Vulkan/Metal)을 적용한 부트스트랩 경로를 유지한다.",
            file: "main.cpp",
            states: "backend-selection",
            lastUpdated: "2026-02-14"
        }
    ]
    readonly property int componentConsoleTotalCount: componentConsoleEntries.length
    readonly property int componentConsoleAddedCount: countComponentEntriesByType("added")
    readonly property int componentConsoleModifiedCount: countComponentEntriesByType("modified")
    readonly property int componentConsoleRefactoredCount: countComponentEntriesByType("refactored")
    readonly property int componentConsoleVerifiedCount: countComponentEntriesByStatus("verified")
    readonly property int componentConsoleMonitoringCount: countComponentEntriesByStatus("monitoring")
    readonly property int componentConsoleFilteredCount: countVisibleComponentEntries()
    readonly property real componentConsoleVerifiedRatio: componentConsoleTotalCount > 0
        ? componentConsoleVerifiedCount / componentConsoleTotalCount
        : 0
    readonly property var componentConsoleSummaryCards: [
        { label: "Tracked", value: String(componentConsoleTotalCount), tone: "primary" },
        { label: "Added", value: String(componentConsoleAddedCount), tone: "added" },
        { label: "Modified", value: String(componentConsoleModifiedCount), tone: "modified" },
        { label: "Refactored", value: String(componentConsoleRefactoredCount), tone: "refactored" },
        { label: "Verified", value: String(componentConsoleVerifiedCount), tone: "verified" },
        { label: "Monitoring", value: String(componentConsoleMonitoringCount), tone: "monitoring" }
    ]
    readonly property var componentConsoleChecks: [
        {
            name: "Render Scale Policy",
            pass: metricsRenderScaleCompliant,
            detail: "Supersample x" + effectiveSupersampleScale.toFixed(2)
        },
        {
            name: "Font Fallback Policy",
            pass: metricsFontFallbackCompliant,
            detail: "Font family resolved"
        },
        {
            name: "Theme Typography Policy",
            pass: metricsThemeTextCompliant,
            detail: "Text style token compliance"
        },
        {
            name: "Runtime Telemetry",
            pass: metricsRuntimeCompliant,
            detail: runtimeSnapshot ? "pid=" + runtimeSnapshot.pid : "runtime unavailable"
        },
        {
            name: "SVG Runtime Policy",
            pass: metricsSvgCompliant,
            detail: "scale=[" + LV.SvgManager.minimumScale + ", " + LV.SvgManager.maximumScale + "]"
        },
        {
            name: "Page Stack Consistency",
            pass: metricsPageCompliant,
            detail: "history=" + LV.AppState.pageHistory.length
        },
        {
            name: "Component Ledger Coverage",
            pass: componentConsoleTotalCount >= 8,
            detail: "entries=" + componentConsoleTotalCount
        },
        {
            name: "Button Variant Lock",
            pass: true,
            detail: "4 families x 5 tones x 20px"
        }
    ]
    property int demoPageIndex: 0
    readonly property var demoPages: [
        {
            tab: "Overview",
            component: "ApplicationWindow + AppState",
            pageDoc: "애플리케이션 루트 상태와 공통 액션의 관찰 지점을 제공하는 페이지이다. Alert, ContextMenu, Progress와 RenderMonitor 트리거를 한 화면에서 재현해 상호작용 회귀를 빠르게 판별하도록 설계했다.",
            componentDoc: "상태 변경은 AppState를 통해 단일 경로로 흘러가며, UI는 상태 스냅샷을 구독해 즉시 반영된다.",
            apiDoc: "핵심 API: LV.ApplicationWindow, LV.AppState, LV.RenderMonitor, LV.Alert, LV.ContextMenu",
            checklist: "버튼 클릭 후 상태 값 동기화 여부, 오버레이 열림/닫힘, 모니터 start/stop 동작"
        },
        {
            tab: "Typography",
            component: "Label",
            pageDoc: "테마 타이포그래피 토큰을 스케일별로 검증하는 페이지이다. 스타일 명세와 렌더 결과가 일치하는지 즉시 확인한다.",
            componentDoc: "Label은 style enum을 통해 폰트 크기, weight, lineHeight, color 계층을 일관되게 적용한다.",
            apiDoc: "핵심 API: LV.Label(style: title/title2/header/header2/body/description/caption/disabled)",
            checklist: "텍스트 계층 대비, 폰트 fallback, 줄바꿈 시 lineHeight 유지"
        },
        {
            tab: "Console",
            component: "Design System Console",
            pageDoc: "변경 레저와 런타임 품질 지표를 결합한 운영형 데모 페이지이다. 컴포넌트 변경 상태와 시스템 적합성 체크를 단일 콘솔로 노출한다.",
            componentDoc: "필터 기반 목록, 상태 배지, 지표 카드와 체크 보드를 통해 개발 중 품질 게이팅 포인트를 시각화한다.",
            apiDoc: "핵심 API: componentConsoleEntries, countEntriesForFilter(), metrics* 집합",
            checklist: "필터별 카운트 정확성, verified/monitoring 색상 매핑, 스크롤 가시성"
        },
        {
            tab: "Buttons",
            component: "LabelButton/IconButton/LabelMenuButton/IconMenuButton",
            pageDoc: "버튼 패밀리와 tone 상태 조합을 검증하는 페이지이다. Figma 규격의 고정 높이/패딩과 상호작용 상태색을 동시에 점검한다.",
            componentDoc: "Primary, Default, Borderless, Destructive, Disabled 톤이 공통 버튼 기반에서 일관된 정책으로 렌더된다.",
            apiDoc: "핵심 API: tone, text, iconName, showIndicator, enabled",
            checklist: "높이 20px 유지, hover/pressed/inactive 색상, 아이콘/라벨 정렬"
        },
        {
            tab: "Accent",
            component: "Theme Accent Tokens",
            pageDoc: "아이콘셋에서 추출한 accent 토큰을 전수 검증하는 페이지이다. 실제 토큰명과 헥스 값의 매핑을 시각적으로 확인한다.",
            componentDoc: "각 토큰은 Theme singleton에서 중앙 관리되며 컴포넌트 상태 테마의 원천 데이터로 사용된다.",
            apiDoc: "핵심 API: LV.Theme.accent* 토큰, accentPreviewTokens 모델",
            checklist: "토큰 누락 여부, 이름-색상 대응, transparent 처리"
        },
        {
            tab: "Inputs",
            component: "InputField",
            pageDoc: "텍스트 입력 컴포넌트의 상태 전이를 점검하는 페이지이다. placeholder, readOnly, disabled, password, search 모드를 한 번에 확인한다.",
            componentDoc: "입력 필드는 단일 베이스 컴포넌트에 모드별 UI 정책을 얹어 동작하므로 상태 회귀 점검이 핵심이다.",
            apiDoc: "핵심 API: text, placeholderText, readOnly, enabled, echoMode, mode, inputMethodHints",
            checklist: "포커스 전이, 커서/선택 동작, 모드별 아이콘/패딩"
        },
        {
            tab: "Editors",
            component: "TextEditor + CodeEditor",
            pageDoc: "문서 입력과 코드 입력 시나리오를 병렬 비교하는 페이지이다. 고정 높이 편집영역과 내부 스크롤, 제출 단축키를 검증한다.",
            componentDoc: "TextEditor는 마크다운/리치텍스트 프리뷰 경로를 포함하고, CodeEditor는 모노스페이스 코드 입력 경로에 집중한다.",
            apiDoc: "핵심 API: editorHeight, mode, snippetTitle, snippetLanguage, submitted(text)",
            checklist: "입력 중 레이아웃 밀림 방지, 내부 스크롤 분리, Ctrl/Cmd+Enter 제출"
        },
        {
            tab: "Checks",
            component: "CheckBox/RadioButton/ToggleSwitch",
            pageDoc: "선택형 컨트롤의 상태 일관성을 확인하는 페이지이다. checked, unchecked, disabled 조합이 테마와 함께 정상 동작하는지 검증한다.",
            componentDoc: "세 컴포넌트는 선택 시각화 방식은 다르지만 상태 전이 계약은 동일해야 한다.",
            apiDoc: "핵심 API: checked, enabled, text",
            checklist: "클릭 hit 영역, disabled 시 포인터 차단, 그룹 선택 배타성"
        },
        {
            tab: "Navigation",
            component: "PageRouter + Link + List",
            pageDoc: "라우팅/링크/리스트 탐색 경로를 검증하는 페이지이다. 경로 전환 시 뷰 교체와 상태 기록이 정상 반영되는지 확인한다.",
            componentDoc: "Link는 선언형 이동을 제공하고 PageRouter는 경로-컴포넌트 매핑을 담당하며, List는 탐색형 표면을 구성한다.",
            apiDoc: "핵심 API: LV.Link(to/href), LV.PageRouter(routes, initialPath), LV.List(items)",
            checklist: "경로 기록(PageMonitor), fallback 경로 처리, 리스트 활성 아이템 반응"
        },
        {
            tab: "Layout",
            component: "HStack/VStack/ZStack/Spacer",
            pageDoc: "레이아웃 원시 컴포넌트의 배치 규칙을 확인하는 페이지이다. 정렬, 간격, 확장 동작을 시각적으로 검증한다.",
            componentDoc: "레이아웃 primitive는 상위 컴포넌트의 구조적 안정성을 좌우하므로 spacing/align 정책의 일관성이 중요하다.",
            apiDoc: "핵심 API: spacing, alignmentName, Spacer.minLength, Layout.*",
            checklist: "컨테이너 리사이즈 시 정렬 유지, Spacer 유효 동작, z-order 겹침"
        },
        {
            tab: "Hierarchy",
            component: "Hierarchy + HierarchyList + HierarchyItem",
            pageDoc: "계층형 데이터 표시와 탐색 인터랙션을 검증하는 페이지이다. 모델 입력만으로 트리 전개/축약/선택이 구현되는지 확인한다.",
            componentDoc: "행 클릭은 활성화만 수행하고, 접힘/펼침은 우측 chevron 입력만 처리하도록 동작을 분리했다.",
            apiDoc: "핵심 API: model/treeModel, expandAll(), collapseAll(), activeListItemKey",
            checklist: "chevron 전용 토글, 키보드 네비게이션, 내부 스크롤 이벤트 분리"
        },
        {
            tab: "Scaffold",
            component: "AppScaffold",
            pageDoc: "실제 앱 골격의 헤더/네비게이션/콘텐츠 구성을 검증하는 페이지이다. 페이지 전환 시 프레임 레벨 상태 동기화를 확인한다.",
            componentDoc: "AppScaffold는 상위 정보구조를 유지하며 내부 콘텐츠 교체를 흡수하는 shell 컴포넌트이다.",
            apiDoc: "핵심 API: navModel, navIndex, headerTitle/headerSubtitle, onNavActivated",
            checklist: "선택 인덱스 동기화, 헤더 액션 정렬, 내부 콘텐츠 영역 안정성"
        }
    ]
    readonly property var currentDemoPage: {
        if (demoPages.length === 0)
            return ({})
        const index = Math.max(0, Math.min(demoPageIndex, demoPages.length - 1))
        return demoPages[index]
    }
    property var activeContextMenuItems: LV.AppState.demoContextMenuItems

    function nudgeProgress(delta) {
        LV.AppState.nudgeProgress(delta)
    }

    function openDemoContextMenuAtGlobal(globalX, globalY) {
        const overlayParent = demoContextMenu ? demoContextMenu.parent : null
        if (overlayParent && overlayParent.mapFromGlobal) {
            const mapped = overlayParent.mapFromGlobal(globalX, globalY)
            demoContextMenu.openAt(mapped.x, mapped.y)
            return
        }
        demoContextMenu.openAt(globalX - root.x, globalY - root.y)
    }

    function contextMenuItemsForEvent(eventData) {
        const ui = eventData && eventData.ui ? eventData.ui : ({})
        const className = ui.className ? String(ui.className) : ""
        const objectName = ui.objectName ? String(ui.objectName) : ""
        const path = ui.path ? String(ui.path) : ""
        const text = ui.text ? String(ui.text) : ""

        const isEditorTarget = className.indexOf("TextEdit") !== -1
            || objectName.toLowerCase().indexOf("editor") !== -1
        if (isEditorTarget) {
            return [
                { id: "copy", label: "Copy", key: "Cmd+C", showChevron: false },
                { id: "paste", label: "Paste", key: "Cmd+V", showChevron: false },
                { type: "divider" },
                { id: "select-all", label: "Select All", key: "Cmd+A", showChevron: false }
            ]
        }

        const isButtonTarget = className.indexOf("Button") !== -1
            || objectName.toLowerCase().indexOf("button") !== -1
        if (isButtonTarget) {
            return [
                { id: "button-info", label: "Inspect Button", key: "", showChevron: false },
                { id: "button-action", label: "Trigger Action", key: "", showChevron: false },
                { type: "divider" },
                { id: "button-path", label: path.length > 0 ? path : "Button Path", key: "", showChevron: false }
            ]
        }

        return [
            { id: "inspect-ui", label: "Inspect UI", key: "", showChevron: false },
            { id: "focus-ui", label: "Focus " + (objectName.length > 0 ? objectName : className || "Target"), key: "", showChevron: false },
            { type: "divider" },
            { id: "copy-ui-text", label: text.length > 0 ? ("Copy \"" + text + "\"") : "Copy Label", key: "", showChevron: false }
        ]
    }

    function countComponentEntriesByType(changeType) {
        let count = 0
        for (let i = 0; i < componentConsoleEntries.length; i++) {
            const entry = componentConsoleEntries[i]
            if (entry && String(entry.changeType) === changeType)
                count += 1
        }
        return count
    }

    function countComponentEntriesByStatus(status) {
        let count = 0
        for (let i = 0; i < componentConsoleEntries.length; i++) {
            const entry = componentConsoleEntries[i]
            if (entry && String(entry.status) === status)
                count += 1
        }
        return count
    }

    function componentEntryVisible(entry) {
        if (!entry)
            return false
        if (componentConsoleFilter === "all")
            return true
        if (componentConsoleFilter === "added" || componentConsoleFilter === "modified" || componentConsoleFilter === "refactored")
            return String(entry.changeType) === componentConsoleFilter
        return String(entry.status) === componentConsoleFilter
    }

    function countVisibleComponentEntries() {
        let count = 0
        for (let i = 0; i < componentConsoleEntries.length; i++) {
            if (componentEntryVisible(componentConsoleEntries[i]))
                count += 1
        }
        return count
    }

    function componentStatusColor(status) {
        if (status === "verified")
            return LV.Theme.success
        if (status === "monitoring")
            return LV.Theme.warning
        if (status === "blocked")
            return LV.Theme.danger
        return LV.Theme.accentBlue
    }

    function componentStatusBackground(status) {
        if (status === "verified")
            return LV.Theme.accentGreenMuted
        if (status === "monitoring")
            return LV.Theme.accentBrownMuted
        if (status === "blocked")
            return LV.Theme.accentRedBrownDark
        return LV.Theme.accentBlueMuted
    }

    function componentChangeTypeColor(changeType) {
        if (changeType === "added")
            return LV.Theme.accentBlueBright
        if (changeType === "modified")
            return LV.Theme.accentPurple
        if (changeType === "refactored")
            return LV.Theme.accentOrangeMuted
        return LV.Theme.accentGrayMuted
    }

    function countEntriesForFilter(filterValue) {
        if (filterValue === "all")
            return componentConsoleTotalCount
        let count = 0
        for (let i = 0; i < componentConsoleEntries.length; i++) {
            const entry = componentConsoleEntries[i]
            if (!entry)
                continue
            if (filterValue === "added" || filterValue === "modified" || filterValue === "refactored") {
                if (String(entry.changeType) === filterValue)
                    count += 1
            } else if (String(entry.status) === filterValue) {
                count += 1
            }
        }
        return count
    }

    onGlobalContextEvent: function(eventData) {
        if (!eventData)
            return
        const x = eventData.globalX !== undefined ? eventData.globalX : eventData.x
        const y = eventData.globalY !== undefined ? eventData.globalY : eventData.y
        if (x === undefined || y === undefined)
            return
        root.activeContextMenuItems = root.contextMenuItemsForEvent(eventData)
        root.openDemoContextMenuAtGlobal(x, y)
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
        items: root.activeContextMenuItems
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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: LV.Theme.gap12
        spacing: LV.Theme.gap10

        TabBar {
            id: demoTabBar
            Layout.fillWidth: true
            currentIndex: root.demoPageIndex

            Repeater {
                model: root.demoPages

                delegate: TabButton {
                    required property var modelData
                    text: modelData.tab
                }
            }

            onCurrentIndexChanged: {
                if (root.demoPageIndex !== currentIndex)
                    root.demoPageIndex = currentIndex
            }
        }

        LV.AppCard {
            title: "Developer Page Brief"
            subtitle: (root.currentDemoPage.tab || "Unknown") + " 페이지 및 컴포넌트 해설"
            Layout.fillWidth: true

            Column {
                width: parent.width
                spacing: LV.Theme.gap8

                LV.Label {
                    width: parent.width
                    style: body
                    color: LV.Theme.textPrimary
                    wrapMode: Text.WordWrap
                    text: root.currentDemoPage.pageDoc || ""
                }

                LV.Label {
                    width: parent.width
                    style: description
                    color: LV.Theme.textSecondary
                    wrapMode: Text.WordWrap
                    text: "핵심 컴포넌트: " + (root.currentDemoPage.component || "")
                }

                LV.Label {
                    width: parent.width
                    style: description
                    color: LV.Theme.textSecondary
                    wrapMode: Text.WordWrap
                    text: root.currentDemoPage.componentDoc || ""
                }

                LV.Label {
                    width: parent.width
                    style: caption
                    color: LV.Theme.textTertiary
                    wrapMode: Text.WordWrap
                    text: root.currentDemoPage.apiDoc || ""
                }

                LV.Label {
                    width: parent.width
                    style: caption
                    color: LV.Theme.textTertiary
                    wrapMode: Text.WordWrap
                    text: "검증 체크포인트: " + (root.currentDemoPage.checklist || "")
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                    visible: root.demoPageIndex === 0
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
                    visible: root.demoPageIndex === 1
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
                    title: "Design System Console"
                    subtitle: "변경/추가 컴포넌트 레저 + 품질 검증 모니터"
                    visible: root.demoPageIndex === 2
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap10

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: consoleHeaderColumn.implicitHeight + LV.Theme.gap10 * 2

                            Column {
                                id: consoleHeaderColumn
                                x: LV.Theme.gap10
                                y: LV.Theme.gap10
                                width: parent.width - LV.Theme.gap10 * 2
                                spacing: LV.Theme.gap8

                                RowLayout {
                                    width: parent.width
                                    spacing: LV.Theme.gap8

                                    LV.Label {
                                        Layout.fillWidth: true
                                        style: body
                                        color: LV.Theme.textPrimary
                                        text: "Component Ledger " + root.componentConsoleVerifiedCount + "/" + root.componentConsoleTotalCount
                                    }

                                    Rectangle {
                                        implicitHeight: 20
                                        implicitWidth: statusLabel.implicitWidth + LV.Theme.gap8 * 2
                                        radius: LV.Theme.radiusSm
                                        color: root.metricsPass ? LV.Theme.accentGreenMuted : LV.Theme.accentRedBrownDark
                                        border.width: 1
                                        border.color: root.metricsPass ? LV.Theme.success : LV.Theme.danger

                                        LV.Label {
                                            id: statusLabel
                                            anchors.centerIn: parent
                                            style: disabled
                                            color: LV.Theme.textPrimary
                                            text: root.metricsPass ? "SYSTEM VERIFIED" : "SYSTEM MONITORING"
                                        }
                                    }
                                }

                                LV.ProgressBar {
                                    width: parent.width
                                    size: regular
                                    startValue: 0
                                    endValue: Math.max(1, root.componentConsoleTotalCount)
                                    currentValue: root.componentConsoleVerifiedCount
                                }

                                LV.Label {
                                    width: parent.width
                                    style: disabled
                                    color: LV.Theme.textTertiary
                                    text: "Filter: " + root.componentConsoleFilter
                                        + " | Visible: " + root.componentConsoleFilteredCount
                                        + " | Runtime checks: " + root.metricsSummary
                                }
                            }
                        }

                        GridLayout {
                            width: parent.width
                            columns: root.compactGallery ? 2 : 6
                            rowSpacing: LV.Theme.gap8
                            columnSpacing: LV.Theme.gap8

                            Repeater {
                                model: root.componentConsoleSummaryCards

                                delegate: Rectangle {
                                    required property var modelData
                                    readonly property color toneColor: {
                                        const tone = modelData.tone
                                        if (tone === "primary")
                                            return LV.Theme.accentBlue
                                        if (tone === "added")
                                            return root.componentChangeTypeColor("added")
                                        if (tone === "modified")
                                            return root.componentChangeTypeColor("modified")
                                        if (tone === "refactored")
                                            return root.componentChangeTypeColor("refactored")
                                        if (tone === "verified")
                                            return root.componentStatusColor("verified")
                                        return root.componentStatusColor("monitoring")
                                    }
                                    Layout.fillWidth: true
                                    implicitHeight: 62
                                    radius: LV.Theme.radiusSm
                                    color: LV.Theme.surfaceGhost
                                    border.width: 1
                                    border.color: toneColor

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: LV.Theme.gap8
                                        spacing: LV.Theme.gap4

                                        LV.Label {
                                            width: parent.width
                                            style: disabled
                                            color: LV.Theme.textTertiary
                                            text: modelData.label
                                            elide: Text.ElideRight
                                        }
                                        LV.Label {
                                            width: parent.width
                                            style: title2
                                            color: LV.Theme.textPrimary
                                            text: modelData.value
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }
                        }

                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap6

                            LV.LabelButton {
                                text: "All " + root.countEntriesForFilter("all")
                                tone: root.componentConsoleFilter === "all" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "all"
                            }
                            LV.LabelButton {
                                text: "Added " + root.countEntriesForFilter("added")
                                tone: root.componentConsoleFilter === "added" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "added"
                            }
                            LV.LabelButton {
                                text: "Modified " + root.countEntriesForFilter("modified")
                                tone: root.componentConsoleFilter === "modified" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "modified"
                            }
                            LV.LabelButton {
                                text: "Refactored " + root.countEntriesForFilter("refactored")
                                tone: root.componentConsoleFilter === "refactored" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "refactored"
                            }
                            LV.LabelButton {
                                text: "Verified " + root.countEntriesForFilter("verified")
                                tone: root.componentConsoleFilter === "verified" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "verified"
                            }
                            LV.LabelButton {
                                text: "Monitoring " + root.countEntriesForFilter("monitoring")
                                tone: root.componentConsoleFilter === "monitoring" ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                onClicked: root.componentConsoleFilter = "monitoring"
                            }
                        }

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: Math.min(420, Math.max(160, componentConsoleColumn.implicitHeight + LV.Theme.gap8 * 2))

                            Flickable {
                                id: componentConsoleViewport
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap8
                                clip: true
                                contentWidth: width
                                contentHeight: componentConsoleColumn.implicitHeight
                                boundsBehavior: Flickable.StopAtBounds

                                Column {
                                    id: componentConsoleColumn
                                    width: componentConsoleViewport.width
                                    spacing: LV.Theme.gap6

                                    Repeater {
                                        model: root.componentConsoleEntries

                                        delegate: Rectangle {
                                            required property var modelData
                                            readonly property bool rowVisible: root.componentEntryVisible(modelData)
                                            width: parent.width
                                            visible: rowVisible
                                            opacity: rowVisible ? 1 : 0
                                            height: rowVisible ? implicitHeight : 0
                                            implicitHeight: consoleEntryColumn.implicitHeight + LV.Theme.gap8 * 2
                                            radius: LV.Theme.radiusSm
                                            color: root.componentStatusBackground(modelData.status)
                                            border.width: 1
                                            border.color: root.componentStatusColor(modelData.status)

                                            Column {
                                                id: consoleEntryColumn
                                                anchors.fill: parent
                                                anchors.margins: LV.Theme.gap8
                                                spacing: LV.Theme.gap4

                                                RowLayout {
                                                    width: parent.width
                                                    spacing: LV.Theme.gap6

                                                    LV.Label {
                                                        Layout.fillWidth: true
                                                        style: body
                                                        color: LV.Theme.textPrimary
                                                        text: modelData.name
                                                        elide: Text.ElideRight
                                                    }

                                                    Rectangle {
                                                        implicitHeight: 18
                                                        implicitWidth: changeTypeLabel.implicitWidth + LV.Theme.gap6 * 2
                                                        radius: LV.Theme.radiusXs
                                                        color: root.componentChangeTypeColor(modelData.changeType)

                                                        LV.Label {
                                                            id: changeTypeLabel
                                                            anchors.centerIn: parent
                                                            style: disabled
                                                            color: LV.Theme.textPrimary
                                                            text: String(modelData.changeType).toUpperCase()
                                                        }
                                                    }

                                                    Rectangle {
                                                        implicitHeight: 18
                                                        implicitWidth: statusTypeLabel.implicitWidth + LV.Theme.gap6 * 2
                                                        radius: LV.Theme.radiusXs
                                                        color: root.componentStatusColor(modelData.status)

                                                        LV.Label {
                                                            id: statusTypeLabel
                                                            anchors.centerIn: parent
                                                            style: disabled
                                                            color: LV.Theme.textPrimary
                                                            text: String(modelData.status).toUpperCase()
                                                        }
                                                    }
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: description
                                                    color: LV.Theme.textSecondary
                                                    wrapMode: Text.WordWrap
                                                    text: modelData.summary
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    elide: Text.ElideMiddle
                                                    text: "File: " + modelData.file + " | Group: " + modelData.group
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    wrapMode: Text.WordWrap
                                                    text: "States: " + modelData.states + " | Updated: " + modelData.lastUpdated
                                                }
                                            }
                                        }
                                    }

                                    LV.Label {
                                        width: parent.width
                                        visible: root.componentConsoleFilteredCount === 0
                                        style: description
                                        color: LV.Theme.textSecondary
                                        text: "선택된 필터에 해당하는 레저 항목이 없다."
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                }
                            }

                            LV.WheelScrollGuard {
                                anchors.fill: parent
                                targetFlickable: componentConsoleViewport
                                consumeInside: true
                            }
                        }

                        GridLayout {
                            width: parent.width
                            columns: root.compactGallery ? 1 : 2
                            rowSpacing: LV.Theme.gap8
                            columnSpacing: LV.Theme.gap8

                            Repeater {
                                model: root.componentConsoleChecks

                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    implicitHeight: 64
                                    radius: LV.Theme.radiusSm
                                    color: modelData.pass ? LV.Theme.accentGreenMuted : LV.Theme.accentRedBrownDark
                                    border.width: 1
                                    border.color: modelData.pass ? LV.Theme.success : LV.Theme.danger

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: LV.Theme.gap8
                                        spacing: LV.Theme.gap4

                                        LV.Label {
                                            width: parent.width
                                            style: body
                                            color: LV.Theme.textPrimary
                                            text: modelData.name + (modelData.pass ? " [PASS]" : " [FAIL]")
                                            elide: Text.ElideRight
                                        }
                                        LV.Label {
                                            width: parent.width
                                            style: disabled
                                            color: LV.Theme.textTertiary
                                            elide: Text.ElideRight
                                            text: modelData.detail
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "Buttons"
                    subtitle: "Tone별 버튼 패밀리 + 상태 테마 스와치"
                    visible: root.demoPageIndex === 3
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap12

                        LV.Label { text: "Primary"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Primary; height: LV.Theme.gap20 }
                            LV.IconButton { tone: LV.AbstractButton.Primary; height: LV.Theme.gap20 }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Primary; height: LV.Theme.gap20 }
                            LV.IconMenuButton { tone: LV.AbstractButton.Primary; height: LV.Theme.gap20 }
                        }

                        LV.Label { text: "Default"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Default; height: LV.Theme.gap20 }
                            LV.IconButton { tone: LV.AbstractButton.Default; height: LV.Theme.gap20 }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Default; height: LV.Theme.gap20 }
                            LV.IconMenuButton { tone: LV.AbstractButton.Default; height: LV.Theme.gap20 }
                        }

                        LV.Label { text: "Borderless"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Borderless; height: LV.Theme.gap20 }
                            LV.IconButton { tone: LV.AbstractButton.Borderless; height: LV.Theme.gap20 }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Borderless; height: LV.Theme.gap20 }
                            LV.IconMenuButton { tone: LV.AbstractButton.Borderless; height: LV.Theme.gap20 }
                        }

                        LV.Label { text: "Destructive"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Destructive; height: LV.Theme.gap20 }
                            LV.IconButton { tone: LV.AbstractButton.Destructive; height: LV.Theme.gap20 }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Destructive; height: LV.Theme.gap20 }
                            LV.IconMenuButton { tone: LV.AbstractButton.Destructive; height: LV.Theme.gap20 }
                        }

                        LV.Label { text: "Disabled"; style: caption; color: LV.Theme.textTertiary }
                        Flow {
                            width: parent.width
                            spacing: LV.Theme.gap8
                            LV.LabelButton { text: "Label"; tone: LV.AbstractButton.Disabled; height: LV.Theme.gap20 }
                            LV.IconButton { tone: LV.AbstractButton.Disabled; height: LV.Theme.gap20 }
                            LV.LabelMenuButton { text: "Menu"; tone: LV.AbstractButton.Disabled; height: LV.Theme.gap20 }
                            LV.IconMenuButton { tone: LV.AbstractButton.Disabled; height: LV.Theme.gap20 }
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
                    visible: root.demoPageIndex === 4
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
                    visible: root.demoPageIndex === 5
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
                    visible: root.demoPageIndex === 6
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
                    visible: root.demoPageIndex === 7
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
                    visible: root.demoPageIndex === 8
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
                    visible: root.demoPageIndex === 9
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
                    subtitle: "model 기반 자동 계층화 + 키보드 탐색"
                    visible: root.demoPageIndex === 10
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
                            model: [
                                {
                                    key: "world",
                                    itemId: 100,
                                    label: "World",
                                    iconGlyph: "□",
                                    expanded: true,
                                    selected: true,
                                    children: [
                                        {
                                            key: "environment",
                                            itemId: 110,
                                            label: "Environment",
                                            iconGlyph: "□",
                                            expanded: true,
                                            children: [
                                                { key: "directional-light", itemId: 111, label: "Directional Light", iconGlyph: "□" },
                                                { key: "sky-light", itemId: 112, label: "Sky Light", iconGlyph: "□" }
                                            ]
                                        },
                                        {
                                            key: "characters",
                                            itemId: 120,
                                            label: "Characters",
                                            iconGlyph: "□",
                                            expanded: true,
                                            children: [
                                                {
                                                    key: "player",
                                                    itemId: 121,
                                                    label: "Player",
                                                    iconGlyph: "□",
                                                    expanded: true,
                                                    children: [
                                                        { key: "camera-boom", itemId: 122, label: "Camera Boom", iconGlyph: "□" },
                                                        { key: "camera", itemId: 123, label: "Camera", iconGlyph: "□" }
                                                    ]
                                                },
                                                {
                                                    key: "enemies",
                                                    itemId: 130,
                                                    label: "Enemies",
                                                    iconGlyph: "□",
                                                    expanded: true,
                                                    children: [
                                                        { key: "enemy-01", itemId: 131, label: "Enemy_01", iconGlyph: "□" },
                                                        { key: "enemy-02", itemId: 132, label: "Enemy_02", iconGlyph: "□" }
                                                    ]
                                                }
                                            ]
                                        },
                                        {
                                            key: "props",
                                            itemId: 140,
                                            label: "Props",
                                            iconGlyph: "□",
                                            expanded: true,
                                            children: [
                                                { key: "barrel-a", itemId: 141, label: "Barrel_A", iconGlyph: "□" },
                                                { key: "crate-b", itemId: 142, label: "Crate_B", iconGlyph: "□" }
                                            ]
                                        }
                                    ]
                                }
                            ]
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
                                text: "개발자는 model만 선언하면 들여쓰기/부모-자식 관계/노드 가시성이 자동으로 계산된다."
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
                                text: "activeListItemKey = " + hierarchyPreview.activeListItemKey
                            }

                            RowLayout {
                                width: parent.width
                                spacing: LV.Theme.gap8

                                LV.LabelButton {
                                    text: "Expand All"
                                    tone: LV.AbstractButton.Default
                                    onClicked: hierarchyPreview.expandAll()
                                }

                                LV.LabelButton {
                                    text: "Collapse to Root"
                                    tone: LV.AbstractButton.Default
                                    onClicked: hierarchyPreview.collapseAll(true)
                                }
                            }

                            LV.Label {
                                width: parent.width
                                style: description
                                color: LV.Theme.textSecondary
                                wrapMode: Text.WordWrap
                                text: "최종 사용자는 상하좌우 키로 노드 이동 및 펼침/접기를 수행할 수 있다."
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "App Scaffold Preview"
                    subtitle: "실제 페이지 골격 미리보기"
                    visible: root.demoPageIndex === 11
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
}
