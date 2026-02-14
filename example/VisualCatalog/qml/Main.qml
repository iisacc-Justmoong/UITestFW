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
    property string runtimeConsoleFilter: "all"
    property bool runtimeConsolePaused: false
    property bool runtimeConsoleAutoScroll: true
    property int runtimeConsoleMaxRows: 240
    property int runtimeConsoleDroppedCount: 0
    property int runtimeConsoleLastRenderFrameCount: 0
    property int runtimeConsoleLastIngestedSequence: 0
    property int runtimeConsoleLastHeartbeatSequence: 0
    property bool renderPerformanceDegraded: false
    property int renderPerformanceWarnEpochMs: 0
    property int renderPerformanceErrorEpochMs: 0
    property int renderPerformanceRecoveryStartEpochMs: -1
    property var runtimeConsoleRows: []
    property var runtimeConsoleHealth: ({})
    property var runtimeConsoleLastHeartbeat: ({ epochMs: 0, uptimeMs: 0, eventSequence: 0 })
    readonly property int runtimeConsoleTotalCount: runtimeConsoleRows.length
    readonly property int runtimeConsoleVisibleCount: runtimeConsoleCountByFilter(runtimeConsoleFilter)
    readonly property int runtimeConsoleRuntimeCount: runtimeConsoleCountByCategory("runtime")
    readonly property int runtimeConsoleInputCount: runtimeConsoleCountByCategory("input")
    readonly property int runtimeConsoleUiCount: runtimeConsoleCountByCategory("ui")
    readonly property int runtimeConsoleRenderCount: runtimeConsoleCountByCategory("render")
    readonly property int runtimeConsoleNavigationCount: runtimeConsoleCountByCategory("navigation")
    readonly property int runtimeConsoleSystemCount: runtimeConsoleCountByCategory("system")
    property var eventMonitorLastSample: ({ trigger: "boot", source: "system", timestampEpochMs: 0, payload: ({}) })
    property int eventMonitorMaxSamples: 48
    property bool eventMonitorPaused: false
    property bool eventMonitorAutoScroll: true
    readonly property int eventMonitorSampleCount: eventMonitorSamplesModel.count
    property int debuggerMaxRows: 96
    property var debuggerRows: []
    property var debuggerSummary: ({})
    property string debuggerTextFilter: ""
    property string debuggerComponentFilter: ""
    property string debuggerLevelFilter: "all"
    readonly property int debuggerVisibleCount: debuggerRows.length

    ListModel {
        id: eventMonitorSamplesModel
    }
    property int demoPageIndex: 2
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
            tab: "EventListener",
            component: "Event Listener Value Monitor",
            pageDoc: "이벤트 리스너가 반환하는 payload를 중심으로 좌표, 입력 상태, UI hit 정보를 실시간 감시하는 페이지이다.",
            componentDoc: "global/local EventListener 트리거에서 수집한 반환값을 단일 모니터 모델로 집계해 상태 패널과 샘플 리스트로 제공한다.",
            apiDoc: "핵심 API: LV.EventListener(trigger/action/includeUiHit), globalPressedEvent/globalContextEvent, LV.Backend.currentUserInputState()",
            checklist: "트리거별 payload 정확성, 마지막 이벤트 타깃 식별, 입력 상태 동기화, 샘플 누락 여부"
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

    function eventListenerPageIndex() {
        for (let i = 0; i < demoPages.length; i++) {
            if (String(demoPages[i].tab) === "EventListener")
                return i
        }
        return 0
    }

    function openEventListenerConsole() {
        demoPageIndex = eventListenerPageIndex()
    }

    function debuggerApplyFilters() {
        if (!LV.Debug || !LV.Debug.setFilters)
            return
        const levels = debuggerLevelFilter === "all" ? [] : [debuggerLevelFilter]
        const componentToken = String(debuggerComponentFilter || "").trim()
        const components = componentToken.length > 0 ? [componentToken] : []
        LV.Debug.setFilters(levels, components, debuggerTextFilter)
        debuggerRefresh()
    }

    function debuggerRefresh() {
        if (!LV.Debug)
            return
        if (LV.Debug.runtimeCaptureEnabled && LV.Debug.attachRuntimeEvents && !LV.Debug.runtimeAttached)
            LV.Debug.attachRuntimeEvents()
        debuggerSummary = LV.Debug.summary ? LV.Debug.summary() : ({})
        debuggerRows = LV.Debug.filteredEntries ? LV.Debug.filteredEntries(debuggerMaxRows) : []
    }

    function debuggerScheduleRefresh() {
        if (debuggerRefreshTimer.running)
            return
        debuggerRefreshTimer.start()
    }

    function debuggerBootstrap() {
        if (!LV.Debug)
            return
        LV.Debug.verboseOutput = false
        LV.Debug.jsonOutput = false
        LV.Debug.runtimeEchoEnabled = false
        LV.Debug.runtimeEchoMinIntervalMs = Math.max(250, Number(LV.Debug.runtimeEchoMinIntervalMs || 0))
        LV.Debug.stdoutMinimumLevel = "WARN"
        if (LV.Debug.stdoutNoiseReductionEnabled !== undefined)
            LV.Debug.stdoutNoiseReductionEnabled = true
        if (LV.Debug.runtimeCaptureEnabled !== undefined)
            LV.Debug.runtimeCaptureEnabled = true
        if (LV.Debug.attachRuntimeEvents)
            LV.Debug.attachRuntimeEvents()
        debuggerApplyFilters()
    }

    function debuggerApplyRuntimeEchoExclude(rawText) {
        if (!LV.Debug)
            return
        const parts = String(rawText || "").split(",")
        const tokens = []
        for (let i = 0; i < parts.length; i++) {
            const token = String(parts[i]).trim()
            if (token.length > 0)
                tokens.push(token)
        }
        LV.Debug.runtimeEchoExcludeTypes = tokens
        debuggerRefresh()
    }

    function eventMonitorMapHasEntries(mapValue) {
        if (!mapValue)
            return false
        for (const key in mapValue)
            return true
        return false
    }

    function eventMonitorJson(value) {
        try {
            return JSON.stringify(value)
        } catch (e) {
            return String(value)
        }
    }

    function eventMonitorValueText(value) {
        if (value === undefined || value === null)
            return "n/a"
        if (Array.isArray(value))
            return value.length > 0 ? value.join(" + ") : "none"
        if (typeof value === "object")
            return eventMonitorJson(value)
        return String(value)
    }

    function eventMonitorUiTargetText(payload) {
        const source = payload && payload.ui ? payload.ui : ({})
        const path = source.path ? String(source.path) : ""
        const objectName = source.objectName ? String(source.objectName) : ""
        const className = source.className ? String(source.className) : ""
        if (path.length > 0)
            return path
        if (objectName.length > 0 && className.length > 0)
            return className + ":" + objectName
        if (objectName.length > 0)
            return objectName
        if (className.length > 0)
            return className
        return "unknown"
    }

    function eventMonitorInputState() {
        const payload = eventMonitorLastSample && eventMonitorLastSample.payload
            ? eventMonitorLastSample.payload
            : ({})
        if (payload.input && eventMonitorMapHasEntries(payload.input))
            return payload.input
        if (LV.Backend && LV.Backend.currentUserInputState) {
            const backendInput = LV.Backend.currentUserInputState()
            if (eventMonitorMapHasEntries(backendInput))
                return backendInput
        }
        const health = runtimeConsoleHealth || ({})
        return health.input || ({})
    }

    function eventMonitorRecord(trigger, payload, source) {
        const normalizedPayload = payload ? payload : ({})
        const entry = {
            trigger: String(trigger || "unknown"),
            source: source ? String(source) : (normalizedPayload.source ? String(normalizedPayload.source) : "listener"),
            timestampEpochMs: Date.now(),
            payload: normalizedPayload
        }
        eventMonitorLastSample = entry

        if (eventMonitorPaused)
            return

        eventMonitorSamplesModel.append(entry)
        if (eventMonitorSamplesModel.count > eventMonitorMaxSamples) {
            const overflow = eventMonitorSamplesModel.count - eventMonitorMaxSamples
            eventMonitorSamplesModel.remove(0, overflow)
        }
        eventMonitorScrollToBottomIfNeeded()
    }

    function eventMonitorClear() {
        eventMonitorSamplesModel.clear()
        eventMonitorLastSample = ({ trigger: "cleared", source: "system", timestampEpochMs: Date.now(), payload: ({}) })
        eventMonitorScrollToBottomIfNeeded()
    }

    function eventMonitorScrollToBottomIfNeeded() {
        if (!eventMonitorAutoScroll)
            return
        if (!eventMonitorViewport)
            return
        eventMonitorViewport.contentY = Math.max(0, eventMonitorViewport.contentHeight - eventMonitorViewport.height)
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

    function runtimeConsoleTwoDigits(value) {
        return value < 10 ? "0" + value : String(value)
    }

    function runtimeConsoleTimestamp(epochMs) {
        const stamp = Number(epochMs || 0)
        if (stamp <= 0)
            return "--:--:--.---"
        const date = new Date(stamp)
        const hh = runtimeConsoleTwoDigits(date.getHours())
        const mm = runtimeConsoleTwoDigits(date.getMinutes())
        const ss = runtimeConsoleTwoDigits(date.getSeconds())
        const msValue = date.getMilliseconds()
        const mmm = msValue < 10 ? "00" + msValue : (msValue < 100 ? "0" + msValue : String(msValue))
        return hh + ":" + mm + ":" + ss + "." + mmm
    }

    function runtimeConsoleCategoryForType(eventType) {
        const type = String(eventType || "")
        if (type.indexOf("key-") === 0
            || type.indexOf("mouse-") === 0
            || type.indexOf("touch-") === 0
            || type.indexOf("tablet-") === 0
            || type.indexOf("native-gesture") === 0
            || type.indexOf("hover-") === 0
            || type.indexOf("context-") === 0
            || type.indexOf("global-") === 0)
            return "input"
        if (type === "ui-event")
            return "ui"
        if (type.indexOf("render-") === 0)
            return "render"
        if (type.indexOf("route-") === 0 || type.indexOf("viewstack-") === 0)
            return "navigation"
        if (type.indexOf("daemon-") === 0
            || type.indexOf("window-") === 0
            || type.indexOf("catalog-") === 0
            || type.indexOf("counters-") === 0)
            return "runtime"
        return "system"
    }

    function runtimeConsoleCategoryColor(category) {
        if (category === "runtime")
            return LV.Theme.accentBlue
        if (category === "input")
            return LV.Theme.accentOrangeMuted
        if (category === "ui")
            return LV.Theme.accentGreenBright
        if (category === "render")
            return LV.Theme.accentPurple
        if (category === "navigation")
            return LV.Theme.accentYellow
        return LV.Theme.accentGray
    }

    function runtimeConsoleCategoryBackground(category) {
        if (category === "runtime")
            return LV.Theme.accentBlueMuted
        if (category === "input")
            return LV.Theme.accentBrownMuted
        if (category === "ui")
            return LV.Theme.accentGreenMuted
        if (category === "render")
            return LV.Theme.accentPurpleDarker
        if (category === "navigation")
            return LV.Theme.accentBrownDarker
        return LV.Theme.surfaceGhost
    }

    function runtimeConsoleSummaryForEvent(eventType, payload) {
        const type = String(eventType || "unknown")
        if (type === "key-press" || type === "key-release")
            return type + " key=" + (payload.keyName !== undefined ? payload.keyName : (payload.key !== undefined ? payload.key : "n/a"))
        if (type === "mouse-press" || type === "mouse-release" || type === "mouse-move" || type === "hover-move")
            return type + " @" + Math.round(payload.x || 0) + "," + Math.round(payload.y || 0)
                + " -> " + (payload.pointerObjectName || payload.objectName || "unknown")
        if (type === "context-requested" || type === "global-context")
            return type + " reason=" + (payload.reason !== undefined ? payload.reason : "n/a")
        if (type === "ui-event")
            return "ui-event " + (payload.eventType || "unknown")
        if (type === "window-attached")
            return "window attached " + (payload.width || 0) + "x" + (payload.height || 0)
        if (type === "daemon-started" || type === "daemon-stopped")
            return type
        if (type === "render-stats")
            return "render fps=" + Number(payload.fps || 0).toFixed(1)
        if (type === "route-recorded")
            return "route " + (payload.path || "unknown")
        if (type === "viewstack-changed")
            return "viewstack depth=" + (payload.depth !== undefined ? payload.depth : "n/a")
        if (type === "global-pressed")
            return "global pressed @" + Math.round(payload.globalX || 0) + "," + Math.round(payload.globalY || 0)
        return type
    }

    function runtimeConsoleDetailForEvent(payload) {
        if (!payload)
            return ""
        const tokens = []
        if (payload.objectName)
            tokens.push("object=" + payload.objectName)
        if (payload.className)
            tokens.push("class=" + payload.className)
        if (payload.path)
            tokens.push("path=" + payload.path)
        if (payload.pointerPath)
            tokens.push("pointerPath=" + payload.pointerPath)
        if (payload.text)
            tokens.push("text=" + payload.text)
        if (payload.modifiers !== undefined)
            tokens.push("mod=" + payload.modifiers)
        if (payload.activeModifiers !== undefined)
            tokens.push("activeMod=" + payload.activeModifiers)
        if (payload.buttons !== undefined)
            tokens.push("buttons=" + payload.buttons)
        if (payload.pressedMouseButtons && payload.pressedMouseButtons.length !== undefined)
            tokens.push("mouse=" + payload.pressedMouseButtons.join("+"))
        if (payload.pressedKeys && payload.pressedKeys.length !== undefined)
            tokens.push("keys=" + payload.pressedKeys.join("+"))
        if (payload.mouseButtonPressed !== undefined)
            tokens.push("mousePressed=" + payload.mouseButtonPressed)
        if (payload.activePressDurationMs !== undefined)
            tokens.push("pressAgeMs=" + payload.activePressDurationMs)
        if (payload.frameCount !== undefined)
            tokens.push("frames=" + payload.frameCount)
        if (payload.lastFrameMs !== undefined)
            tokens.push("lastFrameMs=" + Number(payload.lastFrameMs).toFixed(2))
        if (payload.depth !== undefined)
            tokens.push("depth=" + payload.depth)
        if (tokens.length > 0)
            return tokens.join(" | ")
        try {
            return JSON.stringify(payload)
        } catch (e) {
            return ""
        }
    }

    function runtimeConsoleRowVisible(row) {
        if (!row)
            return false
        if (runtimeConsoleFilter === "all")
            return true
        return String(row.category) === runtimeConsoleFilter
    }

    function runtimeConsoleCountByCategory(category) {
        let count = 0
        for (let i = 0; i < runtimeConsoleRows.length; i++) {
            const row = runtimeConsoleRows[i]
            if (row && String(row.category) === category)
                count += 1
        }
        return count
    }

    function runtimeConsoleCountByFilter(filterValue) {
        if (filterValue === "all")
            return runtimeConsoleRows.length
        let count = 0
        for (let i = 0; i < runtimeConsoleRows.length; i++) {
            const row = runtimeConsoleRows[i]
            if (row && String(row.category) === filterValue)
                count += 1
        }
        return count
    }

    function runtimeConsoleAppendRow(row) {
        if (!row || runtimeConsolePaused)
            return
        const rows = runtimeConsoleRows.slice()
        rows.push(row)
        if (rows.length > runtimeConsoleMaxRows) {
            const overflow = rows.length - runtimeConsoleMaxRows
            rows.splice(0, overflow)
            runtimeConsoleDroppedCount += overflow
        }
        runtimeConsoleRows = rows
    }

    function runtimeConsoleRecord(category, source, type, payload, sequenceHint, timestampHint, uptimeHint) {
        const sequenceValue = sequenceHint !== undefined && sequenceHint !== null
            ? Number(sequenceHint) : -1
        runtimeConsoleAppendRow({
            category: category || "system",
            source: source || "Main",
            type: type || "unknown",
            sequence: sequenceValue,
            timestampEpochMs: timestampHint !== undefined ? Number(timestampHint) : Date.now(),
            uptimeMs: uptimeHint !== undefined ? Number(uptimeHint) : 0,
            payload: payload || ({}),
            summary: runtimeConsoleSummaryForEvent(type, payload || ({})),
            detail: runtimeConsoleDetailForEvent(payload || ({}))
        })
    }

    function evaluateRenderPerformance() {
        if (!LV.Debug || !LV.RenderMonitor || !LV.RenderMonitor.active)
            return
        const fps = Number(LV.RenderMonitor.fps || 0)
        const lastFrameMs = Number(LV.RenderMonitor.lastFrameMs || 0)
        const frameCount = Number(LV.RenderMonitor.frameCount || 0)
        if (!isFinite(fps) || !isFinite(lastFrameMs) || frameCount <= 0)
            return

        const now = Date.now()
        const severe = (lastFrameMs >= 50.0) || (fps > 0 && fps < 18.0)
        const degraded = (lastFrameMs >= 33.0) || (fps > 0 && fps < 30.0)
        const payload = {
            fps: fps,
            lastFrameMs: lastFrameMs,
            frameCount: frameCount,
            backend: LV.RenderQuality.graphicsBackend || "unknown"
        }

        if (severe) {
            renderPerformanceDegraded = true
            renderPerformanceRecoveryStartEpochMs = -1
            if (now - renderPerformanceErrorEpochMs >= 1600) {
                renderPerformanceErrorEpochMs = now
                LV.Debug.error("RenderMonitor", "render-performance-severe", payload)
            }
            return
        }

        if (degraded) {
            renderPerformanceDegraded = true
            renderPerformanceRecoveryStartEpochMs = -1
            if (now - renderPerformanceWarnEpochMs >= 2000) {
                renderPerformanceWarnEpochMs = now
                LV.Debug.warn("RenderMonitor", "render-performance-degraded", payload)
            }
            return
        }

        if (!renderPerformanceDegraded)
            return

        if (renderPerformanceRecoveryStartEpochMs < 0) {
            renderPerformanceRecoveryStartEpochMs = now
            return
        }

        if (now - renderPerformanceRecoveryStartEpochMs >= 3000) {
            renderPerformanceDegraded = false
            renderPerformanceRecoveryStartEpochMs = -1
            LV.Debug.warn("RenderMonitor", "render-performance-recovered", payload)
        }
    }

    function runtimeConsoleIngestRuntimeEvent(eventData) {
        if (!eventData)
            return
        const seq = eventData.sequence !== undefined ? Number(eventData.sequence) : -1
        if (seq >= 0 && seq <= runtimeConsoleLastIngestedSequence)
            return
        if (seq >= 0)
            runtimeConsoleLastIngestedSequence = seq
        const payload = eventData.payload || ({})
        const type = String(eventData.type || "unknown")
        runtimeConsoleRecord(
            runtimeConsoleCategoryForType(type),
            "RuntimeEvents",
            type,
            payload,
            seq,
            eventData.timestampEpochMs,
            eventData.uptimeMs)
    }

    function runtimeConsoleIngestFromBackend(limit) {
        if (!LV.Backend || !LV.Backend.hookedUserEvents)
            return
        const maxRows = limit !== undefined ? Number(limit) : runtimeConsoleMaxRows
        const rows = LV.Backend.hookedUserEvents(maxRows)
        if (!rows || rows.length === undefined)
            return
        for (let i = 0; i < rows.length; i++)
            runtimeConsoleIngestRuntimeEvent(rows[i])
    }

    function runtimeConsoleIngestPointerEvent(type, eventData) {
        if (!eventData)
            return
        const ui = eventData.ui || ({})
        const input = eventData.input || ({})
        const inputPointerUi = input.pointerUi || ({})
        const payload = {
            globalX: eventData.globalX !== undefined ? eventData.globalX : eventData.x,
            globalY: eventData.globalY !== undefined ? eventData.globalY : eventData.y,
            button: eventData.button !== undefined ? eventData.button : Qt.NoButton,
            buttons: eventData.buttons !== undefined ? eventData.buttons : Qt.NoButton,
            modifiers: eventData.modifiers !== undefined ? eventData.modifiers : Qt.NoModifier,
            objectName: ui.objectName || "",
            className: ui.className || "",
            path: ui.path || "",
            text: ui.text || "",
            mouseButtonPressed: input.mouseButtonPressed !== undefined ? input.mouseButtonPressed : false,
            pressedKeys: input.pressedKeys || [],
            pressedMouseButtons: input.pressedMouseButtons || [],
            activeModifiers: input.activeModifiers !== undefined ? input.activeModifiers : 0,
            activeModifierNames: input.activeModifierNames || [],
            anyKeyPressed: input.anyKeyPressed !== undefined ? input.anyKeyPressed : false,
            activePressDurationMs: input.activePressDurationMs !== undefined ? input.activePressDurationMs : -1,
            pointerObjectName: inputPointerUi.objectName || "",
            pointerClassName: inputPointerUi.className || "",
            pointerPath: inputPointerUi.path || "",
            pointerWindowX: inputPointerUi.windowX !== undefined ? inputPointerUi.windowX : -1,
            pointerWindowY: inputPointerUi.windowY !== undefined ? inputPointerUi.windowY : -1
        }
        runtimeConsoleRecord("input", "ApplicationWindow", type, payload, runtimeConsoleLastIngestedSequence + 1)
    }

    function runtimeConsoleUiTargetText(eventData) {
        const ui = eventData && eventData.ui ? eventData.ui : ({})
        const objectName = ui.objectName ? String(ui.objectName) : ""
        const className = ui.className ? String(ui.className) : ""
        const path = ui.path ? String(ui.path) : ""
        if (path.length > 0)
            return path
        if (objectName.length > 0 && className.length > 0)
            return className + ":" + objectName
        if (objectName.length > 0)
            return objectName
        if (className.length > 0)
            return className
        return "unknown"
    }

    function runtimeConsoleLastEventText() {
        const health = runtimeConsoleHealth || ({})
        const lastEvent = health.lastEvent || ({})
        const type = lastEvent.type ? String(lastEvent.type) : "none"
        const sequence = lastEvent.sequence !== undefined ? String(lastEvent.sequence) : "-"
        const stamp = lastEvent.timestampEpochMs ? runtimeConsoleTimestamp(lastEvent.timestampEpochMs) : "--:--:--.---"
        return "#" + sequence + " " + type + " @ " + stamp
    }

    function runtimeConsoleInputState() {
        const health = runtimeConsoleHealth || ({})
        return health.input || ({})
    }

    function runtimeConsoleListText(values) {
        if (!values || values.length === undefined || values.length === 0)
            return "none"
        return values.join(" + ")
    }

    function runtimeConsolePointerTargetText() {
        const input = runtimeConsoleInputState()
        const ui = input.pointerUi || ({})
        const path = ui.path ? String(ui.path) : ""
        const objectName = ui.objectName ? String(ui.objectName) : ""
        const className = ui.className ? String(ui.className) : ""
        if (path.length > 0)
            return path
        if (objectName.length > 0 && className.length > 0)
            return className + ":" + objectName
        if (objectName.length > 0)
            return objectName
        if (className.length > 0)
            return className
        return "unknown"
    }

    function runtimeConsoleElapsedText(value) {
        if (value === undefined || value === null || Number(value) < 0)
            return "n/a"
        return Number(value).toFixed(0) + "ms"
    }

    function runtimeConsoleMapHasEntries(mapValue) {
        if (!mapValue)
            return false
        for (const key in mapValue)
            return true
        return false
    }

    function runtimeConsoleRefreshHealth() {
        if (LV.Backend && LV.Backend.hookUserEvents && !LV.Backend.userEventHooked)
            LV.Backend.hookUserEvents()
        const daemonHealth = LV.RuntimeEvents.daemonHealth()
        if (LV.Backend && LV.Backend.hookedUserEventSummary) {
            const backendSummary = LV.Backend.hookedUserEventSummary()
            daemonHealth.backend = backendSummary
            if (!runtimeConsoleMapHasEntries(daemonHealth.input) && runtimeConsoleMapHasEntries(backendSummary.input))
                daemonHealth.input = backendSummary.input
        }
        runtimeConsoleHealth = daemonHealth
    }

    function runtimeConsoleBootstrapFromDaemon() {
        runtimeConsoleRefreshHealth()
        if (LV.Backend && LV.Backend.hookUserEvents && !LV.Backend.userEventHooked)
            LV.Backend.hookUserEvents()
        const cached = LV.Backend && LV.Backend.hookedUserEvents
            ? LV.Backend.hookedUserEvents(runtimeConsoleMaxRows)
            : LV.RuntimeEvents.recentEvents()
        if (cached && cached.length !== undefined) {
            for (let i = 0; i < cached.length; i++)
                runtimeConsoleIngestRuntimeEvent(cached[i])
        }
        runtimeConsoleRecord("runtime",
                             "Main",
                             "catalog-monitor-attached",
                             { route: LV.AppState.currentRoute, historyDepth: LV.AppState.pageHistory.length },
                             runtimeConsoleLastIngestedSequence + 1)
    }

    function runtimeConsoleClearRows() {
        runtimeConsoleRows = []
        runtimeConsoleDroppedCount = 0
        runtimeConsoleLastRenderFrameCount = LV.RenderMonitor.frameCount
        runtimeConsoleLastIngestedSequence = LV.RuntimeEvents.eventSequence
        runtimeConsoleLastHeartbeatSequence = LV.RuntimeEvents.eventSequence
        LV.RuntimeEvents.clearRecentEvents()
        if (LV.Backend && LV.Backend.clearHookedUserEvents)
            LV.Backend.clearHookedUserEvents()
        runtimeConsoleRefreshHealth()
    }

    onGlobalPressedEvent: function(eventData) {
        if (demoContextMenu && demoContextMenu.opened && demoContextMenu.dismissIfOutsideGlobalEvent)
            demoContextMenu.dismissIfOutsideGlobalEvent(eventData)
        eventMonitorRecord("globalPressed", eventData, "ApplicationWindow")
        runtimeConsoleIngestPointerEvent("global-pressed", eventData)
    }

    onGlobalContextEvent: function(eventData) {
        if (demoContextMenu && demoContextMenu.opened && demoContextMenu.dismissIfOutsideGlobalEvent)
            demoContextMenu.dismissIfOutsideGlobalEvent(eventData)
        eventMonitorRecord("globalContextRequested", eventData, "ApplicationWindow")
        runtimeConsoleIngestPointerEvent("global-context", eventData)
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
        if (LV.Backend && LV.Backend.hookUserEvents)
            LV.Backend.hookUserEvents()
        LV.Debug.enabled = true
        LV.Debug.log("Main", "visual-catalog-opened")
        debuggerBootstrap()
        eventMonitorRecord("catalogOpened",
                           { route: LV.AppState.currentRoute, source: "main" },
                           "Main")
        runtimeConsoleBootstrapFromDaemon()
        runtimeConsoleLastRenderFrameCount = LV.RenderMonitor.frameCount
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
            root.runtimeConsoleRefreshHealth()
        }
        function onEventRecorded(eventData) {
            root.runtimeConsoleIngestRuntimeEvent(eventData)
            root.runtimeConsoleRefreshHealth()
        }
        function onDaemonHeartbeat(epochMs, uptimeMs, eventSequence) {
            root.runtimeConsoleLastHeartbeat = {
                epochMs: epochMs,
                uptimeMs: uptimeMs,
                eventSequence: eventSequence
            }
            root.runtimeConsoleLastHeartbeatSequence = eventSequence
            root.runtimeConsoleRefreshHealth()
        }
    }

    Connections {
        target: LV.Backend
        ignoreUnknownSignals: true
        function onUserEventHookedChanged() {
            root.runtimeConsoleRefreshHealth()
        }
        function onHookedEventsChanged() {
            root.runtimeConsoleIngestFromBackend(96)
            root.runtimeConsoleRefreshHealth()
        }
    }

    Connections {
        target: LV.Debug
        ignoreUnknownSignals: true
        function onEntriesChanged() {
            root.debuggerScheduleRefresh()
        }
        function onRuntimeAttachedChanged() {
            root.debuggerScheduleRefresh()
        }
        function onRuntimeCaptureEnabledChanged() {
            root.debuggerScheduleRefresh()
        }
        function onPausedChanged() {
            root.debuggerScheduleRefresh()
        }
    }

    Timer {
        id: debuggerRefreshTimer
        interval: 120
        repeat: false
        onTriggered: root.debuggerRefresh()
    }

    Connections {
        target: LV.RenderMonitor
        ignoreUnknownSignals: true
        function onActiveChanged() {
            root.runtimeConsoleRecord("render",
                                      "RenderMonitor",
                                      LV.RenderMonitor.active ? "render-monitor-started" : "render-monitor-stopped",
                                      {
                                          active: LV.RenderMonitor.active,
                                          fps: LV.RenderMonitor.fps,
                                          frameCount: LV.RenderMonitor.frameCount
                                      },
                                      root.runtimeConsoleLastIngestedSequence + 1)
            if (!LV.RenderMonitor.active) {
                root.renderPerformanceDegraded = false
                root.renderPerformanceRecoveryStartEpochMs = -1
            }
        }
        function onStatsChanged() {
            const frameCount = LV.RenderMonitor.frameCount
            if (frameCount > 0 && frameCount - root.runtimeConsoleLastRenderFrameCount < 20)
                return
            root.runtimeConsoleLastRenderFrameCount = frameCount
            root.runtimeConsoleRecord("render",
                                      "RenderMonitor",
                                      "render-stats",
                                      {
                                          fps: LV.RenderMonitor.fps,
                                          frameCount: LV.RenderMonitor.frameCount,
                                          lastFrameMs: LV.RenderMonitor.lastFrameMs
                                      },
                                      root.runtimeConsoleLastIngestedSequence + 1)
            root.evaluateRenderPerformance()
        }
    }

    Connections {
        target: LV.ViewStateTracker
        ignoreUnknownSignals: true
        function onStackChanged() {
            LV.AppState.syncViewStateSnapshot(LV.ViewStateTracker.snapshot())
            const snapshot = LV.ViewStateTracker.snapshot()
            root.runtimeConsoleRecord("navigation",
                                      "ViewStateTracker",
                                      "viewstack-changed",
                                      {
                                          depth: snapshot && snapshot.stack ? snapshot.stack.length : 0,
                                          activeCount: snapshot && snapshot.activeViews ? snapshot.activeViews.length : 0
                                      },
                                      root.runtimeConsoleLastIngestedSequence + 1)
        }
    }

    Connections {
        target: LV.PageMonitor
        ignoreUnknownSignals: true
        function onHistoryChanged() {
            LV.AppState.syncPageHistory(LV.PageMonitor.history)
            const history = LV.PageMonitor.history || []
            root.runtimeConsoleRecord("navigation",
                                      "PageMonitor",
                                      "route-recorded",
                                      {
                                          path: history.length > 0 ? history[history.length - 1] : "",
                                          depth: history.length
                                      },
                                      root.runtimeConsoleLastIngestedSequence + 1)
        }
    }

    Timer {
        interval: 120
        running: true
        repeat: true
        onTriggered: {
            root.runtimeConsoleIngestFromBackend(64)
            root.runtimeConsoleRefreshHealth()
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

                Rectangle {
                    width: parent.width
                    radius: LV.Theme.radiusSm
                    color: LV.Theme.surfaceGhost
                    border.width: 1
                    border.color: root.runtimeConsoleHealth.running ? LV.Theme.success : LV.Theme.danger
                    implicitHeight: runtimeBriefRow.implicitHeight + LV.Theme.gap8 * 2

                    RowLayout {
                        id: runtimeBriefRow
                        x: LV.Theme.gap8
                        y: LV.Theme.gap8
                        width: parent.width - LV.Theme.gap8 * 2
                        spacing: LV.Theme.gap8

                        LV.Label {
                            Layout.fillWidth: true
                            style: description
                            color: LV.Theme.textPrimary
                            text: "EventListener Monitor | running="
                                + (!!root.runtimeConsoleHealth.running)
                                + " seq=" + (root.runtimeConsoleHealth.eventSequence !== undefined ? root.runtimeConsoleHealth.eventSequence : 0)
                                + " samples=" + root.eventMonitorSampleCount
                                + " lastTrigger=" + (root.eventMonitorLastSample && root.eventMonitorLastSample.trigger
                                                      ? root.eventMonitorLastSample.trigger
                                                      : "none")
                        }

                        LV.LabelButton {
                            text: "Open EventListener Monitor"
                            tone: LV.AbstractButton.Default
                            onClicked: root.openEventListenerConsole()
                        }
                    }
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
                    title: "Event Listener Value Monitor"
                    subtitle: "EventListener가 반환하는 payload 중심 실시간 모니터"
                    visible: root.demoPageIndex === 2
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap10

                        Rectangle {
                            id: eventCaptureZone
                            width: parent.width
                            implicitHeight: 86
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            border.width: 1
                            border.color: LV.Theme.accentBlueMuted
                            focus: true
                            activeFocusOnTab: true

                            LV.Label {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: LV.Theme.gap10
                                style: body
                                color: LV.Theme.textPrimary
                                text: "Event Capture Zone: 클릭/휠/키 입력을 여기에서 발생시키면 EventListener 반환값이 아래 모니터로 즉시 반영된다."
                                wrapMode: Text.WordWrap
                            }

                            LV.Label {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: LV.Theme.gap10
                                style: disabled
                                color: LV.Theme.textTertiary
                                text: "mouseInside=" + eventCaptureZoneMouse.containsMouse
                                    + " | monitorSamples=" + root.eventMonitorSampleCount
                                    + " | focus=" + eventCaptureZone.activeFocus
                            }

                            MouseArea {
                                id: eventCaptureZoneMouse
                                anchors.fill: parent
                                acceptedButtons: Qt.AllButtons
                                hoverEnabled: true
                                onPressed: eventCaptureZone.forceActiveFocus()
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "pressed"
                                acceptedButtons: Qt.AllButtons
                                includeBackendSummary: true
                                action: function(eventData) {
                                    root.eventMonitorRecord("pressed", eventData, "CaptureZone")
                                }
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "released"
                                acceptedButtons: Qt.AllButtons
                                includeBackendSummary: true
                                action: function(eventData) {
                                    root.eventMonitorRecord("released", eventData, "CaptureZone")
                                }
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "clicked"
                                acceptedButtons: Qt.AllButtons
                                includeBackendSummary: true
                                action: function(eventData) {
                                    root.eventMonitorRecord("clicked", eventData, "CaptureZone")
                                }
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "hoverChanged"
                                action: function(eventData) {
                                    root.eventMonitorRecord("hoverChanged", eventData, "CaptureZone")
                                }
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "wheel"
                                action: function(wheelEvent) {
                                    root.eventMonitorRecord("wheel",
                                                            {
                                                                x: wheelEvent.x !== undefined ? wheelEvent.x : 0,
                                                                y: wheelEvent.y !== undefined ? wheelEvent.y : 0,
                                                                angleDeltaX: wheelEvent.angleDelta ? wheelEvent.angleDelta.x : 0,
                                                                angleDeltaY: wheelEvent.angleDelta ? wheelEvent.angleDelta.y : 0,
                                                                pixelDeltaX: wheelEvent.pixelDelta ? wheelEvent.pixelDelta.x : 0,
                                                                pixelDeltaY: wheelEvent.pixelDelta ? wheelEvent.pixelDelta.y : 0,
                                                                buttons: wheelEvent.buttons !== undefined ? wheelEvent.buttons : Qt.NoButton,
                                                                modifiers: wheelEvent.modifiers !== undefined ? wheelEvent.modifiers : Qt.NoModifier,
                                                                inverted: wheelEvent.inverted !== undefined ? wheelEvent.inverted : false,
                                                                input: root.eventMonitorInputState()
                                                            },
                                                            "CaptureZone")
                                }
                            }

                            LV.EventListener {
                                anchors.fill: parent
                                trigger: "keyPressed"
                                action: function(keyEvent) {
                                    root.eventMonitorRecord("keyPressed",
                                                            {
                                                                key: keyEvent.key,
                                                                text: keyEvent.text || "",
                                                                modifiers: keyEvent.modifiers !== undefined ? keyEvent.modifiers : Qt.NoModifier,
                                                                autoRepeat: keyEvent.isAutoRepeat === true,
                                                                input: root.eventMonitorInputState()
                                                            },
                                                            "CaptureZone")
                                }
                            }

                        }

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: monitorHeaderColumn.implicitHeight + LV.Theme.gap10 * 2

                            Column {
                                id: monitorHeaderColumn
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
                                        text: "running=" + (!!root.runtimeConsoleHealth.running)
                                            + " | hooked=" + (!!(root.runtimeConsoleHealth.backend && root.runtimeConsoleHealth.backend.hooked))
                                            + " | seq=" + (root.runtimeConsoleHealth.eventSequence !== undefined ? root.runtimeConsoleHealth.eventSequence : 0)
                                            + " | samples=" + root.eventMonitorSampleCount
                                    }

                                    Rectangle {
                                        implicitHeight: 20
                                        implicitWidth: statusLabel.implicitWidth + LV.Theme.gap8 * 2
                                        radius: LV.Theme.radiusSm
                                        color: root.runtimeConsoleHealth.running ? LV.Theme.accentGreenMuted : LV.Theme.accentRedBrownDark
                                        border.width: 1
                                        border.color: root.runtimeConsoleHealth.running ? LV.Theme.success : LV.Theme.danger

                                        LV.Label {
                                            id: statusLabel
                                            anchors.centerIn: parent
                                            style: disabled
                                            color: LV.Theme.textPrimary
                                            text: root.runtimeConsoleHealth.running ? "MONITOR ONLINE" : "MONITOR OFFLINE"
                                        }
                                    }
                                }

                                Flow {
                                    width: parent.width
                                    spacing: LV.Theme.gap6

                                    LV.LabelButton {
                                        text: root.eventMonitorPaused ? "Resume Capture" : "Pause Capture"
                                        tone: root.eventMonitorPaused ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: root.eventMonitorPaused = !root.eventMonitorPaused
                                    }
                                    LV.LabelButton {
                                        text: root.eventMonitorAutoScroll ? "AutoScroll On" : "AutoScroll Off"
                                        tone: root.eventMonitorAutoScroll ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: root.eventMonitorAutoScroll = !root.eventMonitorAutoScroll
                                    }
                                    LV.LabelButton {
                                        text: "Clear Samples"
                                        tone: LV.AbstractButton.Default
                                        onClicked: root.eventMonitorClear()
                                    }
                                    LV.LabelButton {
                                        text: "Refresh Runtime"
                                        tone: LV.AbstractButton.Default
                                        onClicked: root.runtimeConsoleRefreshHealth()
                                    }
                                }
                            }
                        }

                        GridLayout {
                            width: parent.width
                            columns: root.compactGallery ? 1 : 2
                            rowSpacing: LV.Theme.gap8
                            columnSpacing: LV.Theme.gap8

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusMd
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 190

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { width: parent.width; style: body; color: LV.Theme.textPrimary; text: "Last EventListener Return" }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "trigger=" + (root.eventMonitorLastSample.trigger || "none")
                                            + " | source=" + (root.eventMonitorLastSample.source || "n/a")
                                            + " | time=" + root.runtimeConsoleTimestamp(root.eventMonitorLastSample.timestampEpochMs)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "target=" + root.eventMonitorUiTargetText(root.eventMonitorLastSample.payload)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "x=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.x)
                                            + " y=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.y)
                                            + " globalX=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.globalX)
                                            + " globalY=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.globalY)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "button=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.button)
                                            + " buttons=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.buttons)
                                            + " modifiers=" + root.eventMonitorValueText(root.eventMonitorLastSample.payload && root.eventMonitorLastSample.payload.modifiers)
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: LV.Theme.radiusMd
                                color: LV.Theme.surfaceGhost
                                implicitHeight: 190

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: LV.Theme.gap8
                                    spacing: LV.Theme.gap6

                                    LV.Label { width: parent.width; style: body; color: LV.Theme.textPrimary; text: "Input Snapshot" }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "pointerTarget=" + root.runtimeConsolePointerTargetText()
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "mousePressed=" + (!!root.eventMonitorInputState().mouseButtonPressed)
                                            + " | pressedButtons=" + root.eventMonitorValueText(root.eventMonitorInputState().pressedMouseButtons)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "anyKeyPressed=" + (!!root.eventMonitorInputState().anyKeyPressed)
                                            + " | keys=" + root.eventMonitorValueText(root.eventMonitorInputState().pressedKeys)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "activeModifiers=" + root.eventMonitorValueText(root.eventMonitorInputState().activeModifierNames)
                                            + " | pressAge=" + root.runtimeConsoleElapsedText(root.eventMonitorInputState().activePressDurationMs)
                                        wrapMode: Text.WordWrap
                                    }
                                    LV.Label {
                                        width: parent.width
                                        style: disabled
                                        color: LV.Theme.textTertiary
                                        text: "lastPressAgo=" + root.runtimeConsoleElapsedText(root.eventMonitorInputState().mousePressElapsedMs)
                                            + " | lastReleaseAgo=" + root.runtimeConsoleElapsedText(root.eventMonitorInputState().mouseReleaseElapsedMs)
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: 84

                            Column {
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap8
                                spacing: LV.Theme.gap4

                                LV.Label {
                                    width: parent.width
                                    style: body
                                    color: LV.Theme.textPrimary
                                    text: "Last Payload JSON"
                                }
                                LV.Label {
                                    width: parent.width
                                    style: disabled
                                    color: LV.Theme.textTertiary
                                    wrapMode: Text.WordWrap
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                    text: root.eventMonitorJson(root.eventMonitorLastSample.payload || ({}))
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: 260

                            Flickable {
                                id: eventMonitorViewport
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap8
                                clip: true
                                contentWidth: width
                                contentHeight: eventMonitorSampleColumn.implicitHeight
                                boundsBehavior: Flickable.StopAtBounds

                                Column {
                                    id: eventMonitorSampleColumn
                                    width: eventMonitorViewport.width
                                    spacing: LV.Theme.gap6

                                    Repeater {
                                        model: eventMonitorSamplesModel

                                        delegate: Rectangle {
                                            required property string trigger
                                            required property string source
                                            required property double timestampEpochMs
                                            required property var payload
                                            width: parent.width
                                            radius: LV.Theme.radiusSm
                                            color: LV.Theme.surfaceAlt
                                            border.width: 1
                                            border.color: LV.Theme.contextMenuDivider
                                            implicitHeight: sampleColumn.implicitHeight + LV.Theme.gap8 * 2

                                            Column {
                                                id: sampleColumn
                                                anchors.fill: parent
                                                anchors.margins: LV.Theme.gap8
                                                spacing: LV.Theme.gap4

                                                LV.Label {
                                                    width: parent.width
                                                    style: description
                                                    color: LV.Theme.textPrimary
                                                    text: "[" + root.runtimeConsoleTimestamp(timestampEpochMs) + "] "
                                                        + trigger + " @ " + source
                                                    elide: Text.ElideRight
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    text: "target=" + root.eventMonitorUiTargetText(payload)
                                                    wrapMode: Text.WordWrap
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    text: root.eventMonitorJson(payload || ({}))
                                                    wrapMode: Text.WordWrap
                                                }
                                            }
                                        }
                                    }

                                    LV.Label {
                                        width: parent.width
                                        visible: root.eventMonitorSampleCount === 0
                                        style: description
                                        color: LV.Theme.textSecondary
                                        text: "아직 수집된 EventListener 반환값 샘플이 없다."
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                }
                            }

                            LV.WheelScrollGuard {
                                anchors.fill: parent
                                targetFlickable: eventMonitorViewport
                                consumeInside: true
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "Embedded Runtime Debugger"
                    subtitle: "RuntimeEvents + Debug 로그를 통합 수집하는 내장 디버거"
                    visible: root.demoPageIndex === 2
                    Layout.fillWidth: true

                    Column {
                        width: parent.width
                        spacing: LV.Theme.gap8

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: debuggerHeaderColumn.implicitHeight + LV.Theme.gap8 * 2

                            Column {
                                id: debuggerHeaderColumn
                                x: LV.Theme.gap8
                                y: LV.Theme.gap8
                                width: parent.width - LV.Theme.gap8 * 2
                                spacing: LV.Theme.gap6

                                LV.Label {
                                    width: parent.width
                                    style: body
                                    color: LV.Theme.textPrimary
                                    text: "attached=" + (!!root.debuggerSummary.runtimeAttached)
                                        + " | capture=" + (!!root.debuggerSummary.runtimeCaptureEnabled)
                                        + " | runtimeEcho=" + (!!root.debuggerSummary.runtimeEchoEnabled)
                                        + " | paused=" + (!!root.debuggerSummary.paused)
                                        + " | entries=" + (root.debuggerSummary.entryCount !== undefined ? root.debuggerSummary.entryCount : 0)
                                        + " | visible=" + root.debuggerVisibleCount
                                        + " | dropped=" + (root.debuggerSummary.droppedCount !== undefined ? root.debuggerSummary.droppedCount : 0)
                                        + " | seq=" + (root.debuggerSummary.sequence !== undefined ? root.debuggerSummary.sequence : 0)
                                }

                                LV.Label {
                                    width: parent.width
                                    style: disabled
                                    color: LV.Theme.textTertiary
                                    text: "levels: LOG="
                                        + (root.debuggerSummary.levelCounts && root.debuggerSummary.levelCounts.LOG !== undefined ? root.debuggerSummary.levelCounts.LOG : 0)
                                        + " WARN="
                                        + (root.debuggerSummary.levelCounts && root.debuggerSummary.levelCounts.WARN !== undefined ? root.debuggerSummary.levelCounts.WARN : 0)
                                        + " ERROR="
                                        + (root.debuggerSummary.levelCounts && root.debuggerSummary.levelCounts.ERROR !== undefined ? root.debuggerSummary.levelCounts.ERROR : 0)
                                        + " RUNTIME="
                                        + (root.debuggerSummary.levelCounts && root.debuggerSummary.levelCounts.RUNTIME !== undefined ? root.debuggerSummary.levelCounts.RUNTIME : 0)
                                }

                                Flow {
                                    width: parent.width
                                    spacing: LV.Theme.gap6

                                    LV.LabelButton {
                                        text: LV.Debug.paused ? "Resume Debugger" : "Pause Debugger"
                                        tone: LV.Debug.paused ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.paused = !LV.Debug.paused
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.runtimeCaptureEnabled ? "Runtime Capture On" : "Runtime Capture Off"
                                        tone: LV.Debug.runtimeCaptureEnabled ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.runtimeCaptureEnabled = !LV.Debug.runtimeCaptureEnabled
                                            if (LV.Debug.runtimeCaptureEnabled)
                                                LV.Debug.attachRuntimeEvents()
                                            else
                                                LV.Debug.detachRuntimeEvents()
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.runtimeEchoEnabled ? "Runtime Echo On" : "Runtime Echo Off"
                                        tone: LV.Debug.runtimeEchoEnabled ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.runtimeEchoEnabled = !LV.Debug.runtimeEchoEnabled
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.verboseOutput ? "Verbose On" : "Verbose Off"
                                        tone: LV.Debug.verboseOutput ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.verboseOutput = !LV.Debug.verboseOutput
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.jsonOutput ? "JSON On" : "JSON Off"
                                        tone: LV.Debug.jsonOutput ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.jsonOutput = !LV.Debug.jsonOutput
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.enabled ? "Stdout Log On" : "Stdout Log Off"
                                        tone: LV.Debug.enabled ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: LV.Debug.enabled = !LV.Debug.enabled
                                    }

                                    LV.LabelButton {
                                        text: LV.Debug.stdoutNoiseReductionEnabled ? "Noise Filter On" : "Noise Filter Off"
                                        tone: LV.Debug.stdoutNoiseReductionEnabled ? LV.AbstractButton.Primary : LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.stdoutNoiseReductionEnabled = !LV.Debug.stdoutNoiseReductionEnabled
                                            root.debuggerRefresh()
                                        }
                                    }

                                    LV.LabelButton {
                                        text: "Clear Debug Buffer"
                                        tone: LV.AbstractButton.Default
                                        onClicked: {
                                            LV.Debug.clearEntries()
                                            root.debuggerRefresh()
                                        }
                                    }
                                }

                                RowLayout {
                                    width: parent.width
                                    spacing: LV.Theme.gap6

                                    ComboBox {
                                        id: debuggerStdoutLevelBox
                                        Layout.preferredWidth: 130
                                        model: ["LOG", "WARN", "ERROR", "NONE"]
                                        currentIndex: Math.max(0, model.indexOf(LV.Debug.stdoutMinimumLevel))
                                        onActivated: {
                                            LV.Debug.stdoutMinimumLevel = String(currentText)
                                            root.debuggerRefresh()
                                        }
                                    }

                                    ComboBox {
                                        id: debuggerLevelFilterBox
                                        Layout.preferredWidth: 130
                                        model: ["all", "log", "warn", "error", "runtime"]
                                        currentIndex: Math.max(0, model.indexOf(root.debuggerLevelFilter))
                                        onCurrentTextChanged: {
                                            root.debuggerLevelFilter = String(currentText)
                                            root.debuggerApplyFilters()
                                        }
                                    }

                                    TextField {
                                        id: debuggerComponentFilterField
                                        Layout.preferredWidth: 180
                                        placeholderText: "component filter"
                                        text: root.debuggerComponentFilter
                                        selectByMouse: true
                                        onTextChanged: root.debuggerComponentFilter = text
                                        onAccepted: root.debuggerApplyFilters()
                                    }

                                    TextField {
                                        id: debuggerTextFilterField
                                        Layout.fillWidth: true
                                        placeholderText: "text filter"
                                        text: root.debuggerTextFilter
                                        selectByMouse: true
                                        onTextChanged: root.debuggerTextFilter = text
                                        onAccepted: root.debuggerApplyFilters()
                                    }

                                    LV.LabelButton {
                                        text: "Apply"
                                        tone: LV.AbstractButton.Default
                                        onClicked: root.debuggerApplyFilters()
                                    }
                                }

                                RowLayout {
                                    width: parent.width
                                    spacing: LV.Theme.gap6

                                    SpinBox {
                                        id: runtimeEchoIntervalBox
                                        Layout.preferredWidth: 160
                                        from: 0
                                        to: 200
                                        value: LV.Debug.runtimeEchoMinIntervalMs
                                        editable: true
                                        onValueModified: {
                                            LV.Debug.runtimeEchoMinIntervalMs = value
                                            root.debuggerRefresh()
                                        }
                                    }

                                    TextField {
                                        id: runtimeEchoExcludeField
                                        Layout.fillWidth: true
                                        placeholderText: "runtime echo exclude (comma-separated)"
                                        text: LV.Debug.runtimeEchoExcludeTypes ? LV.Debug.runtimeEchoExcludeTypes.join(",") : ""
                                        selectByMouse: true
                                        onAccepted: root.debuggerApplyRuntimeEchoExclude(text)
                                    }

                                    LV.LabelButton {
                                        text: "Apply Echo"
                                        tone: LV.AbstractButton.Default
                                        onClicked: root.debuggerApplyRuntimeEchoExclude(runtimeEchoExcludeField.text)
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            radius: LV.Theme.radiusMd
                            color: LV.Theme.surfaceGhost
                            implicitHeight: 260

                            Flickable {
                                id: debuggerViewport
                                anchors.fill: parent
                                anchors.margins: LV.Theme.gap8
                                clip: true
                                contentWidth: width
                                contentHeight: debuggerColumn.implicitHeight
                                boundsBehavior: Flickable.StopAtBounds

                                Column {
                                    id: debuggerColumn
                                    width: debuggerViewport.width
                                    spacing: LV.Theme.gap6

                                    Repeater {
                                        model: root.debuggerRows

                                        delegate: Rectangle {
                                            required property var modelData
                                            width: parent.width
                                            radius: LV.Theme.radiusSm
                                            color: LV.Theme.surfaceAlt
                                            border.width: 1
                                            border.color: LV.Theme.contextMenuDivider
                                            implicitHeight: debuggerRowColumn.implicitHeight + LV.Theme.gap8 * 2

                                            Column {
                                                id: debuggerRowColumn
                                                anchors.fill: parent
                                                anchors.margins: LV.Theme.gap8
                                                spacing: LV.Theme.gap4

                                                LV.Label {
                                                    width: parent.width
                                                    style: description
                                                    color: LV.Theme.textPrimary
                                                    text: modelData.message ? String(modelData.message) : "debug-entry"
                                                    elide: Text.ElideRight
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    text: "source=" + (modelData.source ? String(modelData.source) : "unknown")
                                                        + " | level=" + (modelData.level ? String(modelData.level) : "none")
                                                        + " | component=" + (modelData.component ? String(modelData.component) : "unknown")
                                                        + " | event=" + (modelData.event ? String(modelData.event) : "unknown")
                                                    wrapMode: Text.WordWrap
                                                }

                                                LV.Label {
                                                    width: parent.width
                                                    style: disabled
                                                    color: LV.Theme.textTertiary
                                                    text: root.eventMonitorJson(modelData.data !== undefined ? modelData.data : ({}))
                                                    wrapMode: Text.WordWrap
                                                }
                                            }
                                        }
                                    }

                                    LV.Label {
                                        width: parent.width
                                        visible: root.debuggerVisibleCount === 0
                                        style: description
                                        color: LV.Theme.textSecondary
                                        text: "아직 수집된 디버거 엔트리가 없다."
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                }
                            }

                            LV.WheelScrollGuard {
                                anchors.fill: parent
                                targetFlickable: debuggerViewport
                                consumeInside: true
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
