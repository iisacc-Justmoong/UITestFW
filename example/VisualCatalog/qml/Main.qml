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
    subtitle: "Main view for visual component inspection"
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
            pageDoc: "This page provides observability points for application root state and common actions. It reproduces Alert, ContextMenu, Progress, and RenderMonitor triggers on one screen to quickly identify interaction regressions.",
            componentDoc: "State changes flow through AppState as a single path, and the UI reflects updates immediately by subscribing to state snapshots.",
            apiDoc: "Core API: LV.ApplicationWindow, LV.AppState, LV.RenderMonitor, LV.Alert, LV.ContextMenu",
            checklist: "State synchronization after button clicks, overlay open/close behavior, monitor start/stop behavior"
        },
        {
            tab: "Typography",
            component: "Label",
            pageDoc: "This page validates theme typography tokens across scales and immediately verifies rendered output against style specifications.",
            componentDoc: "Label applies font size, weight, lineHeight, and color hierarchy consistently through the style enum.",
            apiDoc: "Core API: LV.Label(style: title/title2/header/header2/body/description/caption/disabled)",
            checklist: "Text hierarchy contrast, font fallback behavior, lineHeight preservation during wrapping"
        },
        {
            tab: "EventListener",
            component: "Event Listener Value Monitor",
            pageDoc: "This page monitors coordinates, input state, and UI hit information in real time based on payloads returned by EventListener.",
            componentDoc: "Payloads collected from global/local EventListener triggers are aggregated into a single monitor model and presented as status panels and sample lists.",
            apiDoc: "Core API: LV.EventListener(trigger/action/includeUiHit), globalPressedEvent/globalContextEvent, LV.Backend.currentUserInputState()",
            checklist: "Per-trigger payload accuracy, last event target identification, input state synchronization, missing sample detection"
        },
        {
            tab: "Buttons",
            component: "LabelButton/IconButton/LabelMenuButton/IconMenuButton",
            pageDoc: "This page validates button-family and tone-state combinations. It checks fixed Figma height/padding and interaction state colors together.",
            componentDoc: "Primary, Default, Borderless, Destructive, and Disabled tones render with a consistent policy on a shared button base.",
            apiDoc: "Core API: tone, text, iconName, showIndicator, enabled",
            checklist: "Maintain 20px height, hover/pressed/inactive colors, icon/label alignment"
        },
        {
            tab: "Accent",
            component: "Theme Accent Tokens",
            pageDoc: "This page performs full verification of accent tokens extracted from the icon set. It visually validates mapping between token names and hex values.",
            componentDoc: "Each token is centrally managed in the Theme singleton and used as source data for component state themes.",
            apiDoc: "Core API: LV.Theme.accent* tokens, accentPreviewTokens model",
            checklist: "Token coverage, name-color mapping, transparent handling"
        },
        {
            tab: "Inputs",
            component: "InputField",
            pageDoc: "This page checks state transitions of text input components. It verifies placeholder, readOnly, disabled, password, and search modes together.",
            componentDoc: "Input fields layer mode-specific UI policies on a single base component, so state regression checks are critical.",
            apiDoc: "Core API: text, placeholderText, readOnly, enabled, echoMode, mode, inputMethodHints",
            checklist: "Focus transitions, cursor/selection behavior, mode-specific icon/padding"
        },
        {
            tab: "Editors",
            component: "TextEditor + CodeEditor",
            pageDoc: "This page compares document-input and code-input scenarios in parallel. It validates fixed editor height, internal scrolling, and submit shortcuts.",
            componentDoc: "TextEditor includes markdown/rich-text preview paths, while CodeEditor focuses on monospace code input paths.",
            apiDoc: "Core API: editorHeight, mode, snippetTitle, snippetLanguage, submitted(text)",
            checklist: "Prevent layout push during typing, isolate internal scrolling, Ctrl/Cmd+Enter submit"
        },
        {
            tab: "Checks",
            component: "CheckBox/RadioButton/ToggleSwitch",
            pageDoc: "This page verifies state consistency of selectable controls. It checks whether checked, unchecked, and disabled combinations work correctly with theme behavior.",
            componentDoc: "These three components use different selection visualizations but must share the same state-transition contract.",
            apiDoc: "Core API: checked, enabled, text",
            checklist: "Click hit area, pointer blocking in disabled state, group-selection exclusivity"
        },
        {
            tab: "Navigation",
            component: "PageRouter + Link + List",
            pageDoc: "This page validates routing, link, and list-navigation flows. It confirms view replacement and state recording during route transitions.",
            componentDoc: "Link provides declarative navigation, PageRouter maps routes to components, and List builds navigation surfaces.",
            apiDoc: "Core API: LV.Link(to/href), LV.PageRouter(routes, initialPath), LV.List(items)",
            checklist: "Route history (PageMonitor), fallback-route handling, active list-item response"
        },
        {
            tab: "Layout",
            component: "HStack/VStack/ZStack/Spacer",
            pageDoc: "This page verifies layout-primitives placement rules and visually checks alignment, spacing, and expansion behavior.",
            componentDoc: "Layout primitives determine structural stability of upper components, so spacing/align policy consistency is important.",
            apiDoc: "Core API: spacing, alignmentName, Spacer.minLength, Layout.*",
            checklist: "Alignment preservation during container resize, Spacer validity, z-order overlap"
        },
        {
            tab: "Hierarchy",
            component: "Hierarchy + HierarchyList + HierarchyItem",
            pageDoc: "This page validates hierarchical data presentation and navigation interaction. It checks whether tree expand/collapse/select is driven purely by model input.",
            componentDoc: "Row clicks only activate items, while collapse/expand is handled only by right-side chevron interaction.",
            apiDoc: "Core API: model/treeModel, expandAll(), collapseAll(), activeListItemKey",
            checklist: "Chevron-only toggle, keyboard navigation, internal scroll-event isolation"
        },
        {
            tab: "Scaffold",
            component: "AppScaffold",
            pageDoc: "This page validates header, navigation, and content composition of a real app shell. It checks frame-level state synchronization during page transitions.",
            componentDoc: "AppScaffold preserves top-level information structure and absorbs inner-content replacement as a shell component.",
            apiDoc: "Core API: navModel, navIndex, headerTitle/headerSubtitle, onNavActivated",
            checklist: "Selected-index synchronization, header action alignment, inner content-area stability"
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
            subtitle: (root.currentDemoPage.tab || "Unknown") + " page and component guide"
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
                    text: "Core components: " + (root.currentDemoPage.component || "")
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
                    text: "Validation checkpoints: " + (root.currentDemoPage.checklist || "")
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
                    subtitle: "Component exploration starting point"
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
                            text: "This page is a visual catalog that groups core LVRS components by state."
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
                    subtitle: "Label style scale"
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
                    subtitle: "Real-time monitor focused on payloads returned by EventListener"
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
                                text: "Event Capture Zone: Trigger click/wheel/key input here and EventListener return values are reflected immediately in the monitor below."
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
                                        text: "No EventListener return-value samples have been collected yet."
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
                    subtitle: "Built-in debugger that aggregates RuntimeEvents + Debug logs"
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
                                        text: "No debugger entries have been collected yet."
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
                    subtitle: "Button families by tone + state-theme swatches"
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
                    subtitle: "Full accent color preview based on iconset"
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
                    subtitle: "Text input states"
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
                    subtitle: "TextEditor and CodeEditor"
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
                    subtitle: "Selectable components"
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
                    subtitle: "Model-based automatic hierarchy + keyboard navigation"
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
                                text: "Developers only declare the model; indentation, parent-child relationships, and node visibility are computed automatically."
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
                                text: "End users can move between nodes and expand/collapse with arrow keys."
                            }
                        }
                    }
                }

                LV.AppCard {
                    title: "App Scaffold Preview"
                    subtitle: "Real app shell preview"
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
                                    text: "This lets you inspect a structure that switches inner content based on the currently selected item."
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
