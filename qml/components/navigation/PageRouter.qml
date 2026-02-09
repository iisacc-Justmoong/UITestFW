import QtQuick
import QtQuick.Controls
import UIFramework 1.0

Item {
    id: root

    property var routes: []
    property string initialPath: "/"
    // SwiftUI-like navigation stack (array of path strings or { path, params } entries).
    property var path: []
    property string _currentPath: ""
    property var _currentParams: ({})
    readonly property string currentPath: _currentPath
    readonly property var currentParams: _currentParams

    property Component notFoundComponent: null
    property url notFoundSource: ""

    readonly property bool canGoBack: stackView.depth > 1
    readonly property int depth: stackView.depth

    signal navigated(string path, var params)
    signal navigationFailed(string path)
    signal componentNavigated(var component)

    function go(path, params) {
        navigate(path, params, "push")
    }

    function replace(path, params) {
        navigate(path, params, "replace")
    }

    function setRoot(path, params) {
        navigate(path, params, "set")
    }

    function goTo(component, params) {
        navigateComponent(component, params, "push")
    }

    function replaceWith(component, params) {
        navigateComponent(component, params, "replace")
    }

    function setRootComponent(component, params) {
        navigateComponent(component, params, "set")
    }

    function back() {
        pop()
    }

    function push(path, params) {
        navigate(path, params, "push")
    }

    function pop() {
        if (stackView.depth > 1) {
            stackView.pop()
            if (path.length > 1) {
                var nextPath = path.slice(0, path.length - 1)
                setPathInternal(nextPath)
                applyCurrentFromPathEntry(nextPath[nextPath.length - 1])
            } else if (path.length === 1) {
                applyCurrentFromPathEntry(path[0])
            } else {
                setCurrent("", {})
            }
        }
    }

    function popToRoot() {
        if (stackView.depth > 1) {
            stackView.pop(stackView.get(0))
            if (path.length > 0) {
                setPathInternal([path[0]])
                applyCurrentFromPathEntry(path[0])
            } else {
                setCurrent("", {})
            }
        }
    }

    function normalizePath(path) {
        var value = String(path || "/")
        if (!value.startsWith("/"))
            value = "/" + value
        if (value.length > 1 && value.endsWith("/"))
            value = value.slice(0, -1)
        return value
    }

    function matchRoute(path, routePath) {
        var normalizedPath = normalizePath(path)
        var normalizedRoute = normalizePath(routePath)
        if (normalizedRoute === "/")
            return normalizedPath === "/" ? ({}) : null

        var pathSegments = normalizedPath.slice(1).split("/")
        var routeSegments = normalizedRoute.slice(1).split("/")
        var params = {}
        var pIndex = 0

        for (var rIndex = 0; rIndex < routeSegments.length; rIndex++) {
            var segment = routeSegments[rIndex]
            var isParam = segment.startsWith("[") && segment.endsWith("]")
            if (isParam) {
                var key = segment.slice(1, -1)
                if (key.startsWith("...")) {
                    var restKey = key.slice(3)
                    params[restKey] = pathSegments.slice(pIndex).join("/")
                    pIndex = pathSegments.length
                    return pIndex <= pathSegments.length ? params : null
                }
                if (pIndex >= pathSegments.length)
                    return null
                params[key] = pathSegments[pIndex]
                pIndex += 1
                continue
            }
            if (pIndex >= pathSegments.length || pathSegments[pIndex] !== segment)
                return null
            pIndex += 1
        }

        if (pIndex !== pathSegments.length)
            return null
        return params
    }

    function resolveRoute(path) {
        var normalizedPath = normalizePath(path)
        if (!routes)
            return null
        var list = routes.length !== undefined ? routes : routes
        var count = list.length !== undefined ? list.length : list.count
        for (var i = 0; i < count; i++) {
            var route = list.length !== undefined ? list[i] : list.get(i)
            if (!route || !route.path)
                continue
            var params = matchRoute(normalizedPath, route.path)
            if (params !== null)
                return { route: route, params: params }
        }
        return null
    }

    function navigate(path, params, mode) {
        var resolved = resolveRoute(path)
        var targetParams = params || (resolved ? resolved.params : {})
        var normalized = normalizePath(path)
        if (!resolved) {
            if (notFoundComponent || notFoundSource) {
                var fallback = notFoundComponent ? notFoundComponent : notFoundSource
                if (mode === "replace")
                    stackView.replace(fallback)
                else if (mode === "set") {
                    stackView.clear()
                    stackView.push(fallback)
                } else {
                    stackView.push(fallback)
                }
                updatePathStack(normalized, targetParams, mode)
                setCurrent(normalized, targetParams)
                navigated(normalized, targetParams)
                return
            }
            navigationFailed(normalized)
            return
        }
        var route = resolved.route
        var target = route.component ? route.component : route.source
        if (!target) {
            navigationFailed(normalized)
            return
        }
        if (mode === "replace") {
            stackView.replace(target)
        } else if (mode === "set") {
            stackView.clear()
            stackView.push(target)
        } else {
            stackView.push(target)
        }
        updatePathStack(normalized, targetParams, mode)
        setCurrent(normalized, targetParams)
        navigated(normalized, targetParams)
    }

    function navigateComponent(component, params, mode) {
        if (!component)
            return
        var targetParams = params || {}
        if (mode === "replace") {
            stackView.replace(component, targetParams)
        } else if (mode === "set") {
            stackView.clear()
            stackView.push(component, targetParams)
        } else {
            stackView.push(component, targetParams)
        }
        setCurrent("", targetParams)
        componentNavigated(component)
    }

    Component.onCompleted: {
        if (initialPath)
            setRoot(initialPath)
    }

    StackView {
        id: stackView
        anchors.fill: parent
        clip: true
        focus: true
    }

    property bool _syncingPath: false

    onPathChanged: {
        if (_syncingPath)
            return
        rebuildFromPath()
    }

    function rebuildFromPath() {
        if (!path || path.length === 0)
            return
        _syncingPath = true
        stackView.clear()
        for (var i = 0; i < path.length; i++) {
            var entry = path[i]
            var entryPath = typeof entry === "string" ? entry : entry.path
            var entryParams = typeof entry === "object" && entry.params !== undefined ? entry.params : undefined
            var resolved = resolveRoute(entryPath)
            var normalized = normalizePath(entryPath)
            if (!resolved) {
                var fallback = notFoundComponent ? notFoundComponent : notFoundSource
                if (fallback)
                    stackView.push(fallback)
                else
                    navigationFailed(normalized)
                continue
            }
            var target = resolved.route.component ? resolved.route.component : resolved.route.source
            if (!target) {
                navigationFailed(normalized)
                continue
            }
            stackView.push(target)
        }
        _syncingPath = false
        applyCurrentFromPathEntry(path[path.length - 1])
    }

    function setPathInternal(nextPath) {
        _syncingPath = true
        path = nextPath
        _syncingPath = false
    }

    function applyCurrentFromPathEntry(entry) {
        if (entry === undefined || entry === null) {
            setCurrent("", {})
            return
        }
        if (typeof entry === "string") {
            setCurrent(normalizePath(entry), {})
            return
        }
        if (typeof entry === "object") {
            setCurrent(
                normalizePath(entry.path !== undefined ? entry.path : "/"),
                entry.params !== undefined ? entry.params : ({})
            )
            return
        }
        setCurrent("", {})
    }

    function setCurrent(pathValue, params) {
        if (pathValue === undefined || pathValue === null || pathValue === "")
            _currentPath = ""
        else
            _currentPath = normalizePath(pathValue)
        _currentParams = params !== undefined ? params : ({})
    }

    function createPathEntry(pathValue, params) {
        if (pathValue && typeof pathValue === "object" && pathValue.path !== undefined) {
            return {
                path: normalizePath(pathValue.path),
                params: pathValue.params !== undefined ? pathValue.params : ({})
            }
        }
        return {
            path: normalizePath(pathValue),
            params: params !== undefined ? params : ({})
        }
    }

    function updatePathStack(pathValue, params, mode) {
        var nextEntry = createPathEntry(pathValue, params)
        if (mode === "set" || path.length === 0) {
            setPathInternal([nextEntry])
        } else if (mode === "replace") {
            if (path.length === 0)
                setPathInternal([nextEntry])
            else {
                var next = path.slice(0)
                next[next.length - 1] = nextEntry
                setPathInternal(next)
            }
        } else {
            var nextPush = path.slice(0)
            nextPush.push(nextEntry)
            setPathInternal(nextPush)
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("PageRouter", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.PageRouter { routes: [{ path: "/", component: homePage }] }
