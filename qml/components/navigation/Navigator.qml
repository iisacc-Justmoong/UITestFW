pragma Singleton
import QtQuick

QtObject {
    id: root

    property var router: null

    readonly property bool hasRouter: router !== null
    readonly property string currentPath:
        hasRouter && router.currentPath !== undefined ? router.currentPath : ""
    readonly property int depth:
        hasRouter && router.depth !== undefined ? router.depth : 0

    function registerRouter(targetRouter) {
        if (!targetRouter)
            return false
        if (router === targetRouter)
            return true
        router = targetRouter
        return true
    }

    function unregisterRouter(targetRouter) {
        if (!router)
            return
        if (!targetRouter || router === targetRouter)
            router = null
    }

    function canNavigate() {
        return hasRouter && router.go !== undefined
    }

    function go(path, params) {
        if (!canNavigate() || !path)
            return false
        router.go(path, params || ({}))
        return true
    }

    function replace(path, params) {
        if (!canNavigate() || !path)
            return false
        router.replace(path, params || ({}))
        return true
    }

    function setRoot(path, params) {
        if (!canNavigate() || !path)
            return false
        router.setRoot(path, params || ({}))
        return true
    }

    function goTo(component, params) {
        if (!canNavigate() || !component || router.goTo === undefined)
            return false
        router.goTo(component, params || ({}))
        return true
    }

    function replaceWith(component, params) {
        if (!canNavigate() || !component || router.replaceWith === undefined)
            return false
        router.replaceWith(component, params || ({}))
        return true
    }

    function setRootComponent(component, params) {
        if (!canNavigate() || !component || router.setRootComponent === undefined)
            return false
        router.setRootComponent(component, params || ({}))
        return true
    }

    function back() {
        if (!hasRouter || router.back === undefined)
            return false
        router.back()
        return true
    }

    function popToRoot() {
        if (!hasRouter || router.popToRoot === undefined)
            return false
        router.popToRoot()
        return true
    }
}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.Navigator.go("/reports")
