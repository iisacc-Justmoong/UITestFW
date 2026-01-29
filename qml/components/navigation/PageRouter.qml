import QtQuick
import QtQuick.Controls

Item {
    id: root

    property var routes: []
    property string initialPath: "/"
    readonly property string currentPath: stackView.currentItem && stackView.currentItem.routePath !== undefined
        ? stackView.currentItem.routePath
        : ""
    readonly property var currentParams: stackView.currentItem && stackView.currentItem.routeParams !== undefined
        ? stackView.currentItem.routeParams
        : ({})

    property Component notFoundComponent: null
    property url notFoundSource: ""

    readonly property bool canGoBack: stackView.depth > 1

    signal navigated(string path, var params)
    signal navigationFailed(string path)

    function go(path, params) {
        navigate(path, params, false)
    }

    function replace(path, params) {
        navigate(path, params, true)
    }

    function back() {
        if (stackView.depth > 1)
            stackView.pop()
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

    function navigate(path, params, useReplace) {
        var resolved = resolveRoute(path)
        var targetParams = params || (resolved ? resolved.params : {})
        if (!resolved) {
            if (notFoundComponent || notFoundSource) {
                var fallback = notFoundComponent ? notFoundComponent : notFoundSource
                if (useReplace)
                    stackView.replace(fallback, { routePath: normalizePath(path), routeParams: targetParams })
                else
                    stackView.push(fallback, { routePath: normalizePath(path), routeParams: targetParams })
                navigated(normalizePath(path), targetParams)
                return
            }
            navigationFailed(normalizePath(path))
            return
        }
        var route = resolved.route
        var target = route.component ? route.component : route.source
        if (!target) {
            navigationFailed(normalizePath(path))
            return
        }
        if (useReplace)
            stackView.replace(target, { routePath: normalizePath(path), routeParams: targetParams, route: route })
        else
            stackView.push(target, { routePath: normalizePath(path), routeParams: targetParams, route: route })
        navigated(normalizePath(path), targetParams)
    }

    Component.onCompleted: {
        if (initialPath)
            go(initialPath)
    }

    StackView {
        id: stackView
        anchors.fill: parent
        clip: true
        focus: true
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.PageRouter { routes: [{ path: "/", component: homePage }] }
