import QtQuick
import LVRS 1.0

Item {
    id: root

    property var target: null
    property bool guardEnabled: true
    property bool commitOnLocaleChanged: true
    property bool commitOnVisibilityLost: true
    property bool commitOnFocusLost: true
    property bool logCommitEvents: false

    width: 0
    height: 0
    visible: false

    function targetHasComposition() {
        return !!(root.target
                  && root.target.inputMethodComposing !== undefined
                  && root.target.inputMethodComposing)
    }

    function commitComposition(reason) {
        if (!root.guardEnabled || !root.targetHasComposition())
            return
        if (Qt.inputMethod && Qt.inputMethod.commit)
            Qt.inputMethod.commit()
        if (root.logCommitEvents)
            Debug.log("InputMethodGuard", "composition-committed", reason)
    }

    Connections {
        target: Qt.inputMethod
        enabled: root.guardEnabled && root.target !== null
        ignoreUnknownSignals: true
        function onLocaleChanged() {
            if (root.commitOnLocaleChanged)
                root.commitComposition("locale-changed")
        }
        function onVisibleChanged() {
            if (root.commitOnVisibilityLost && !Qt.inputMethod.visible)
                root.commitComposition("ime-hidden")
        }
    }

    Connections {
        target: root.target
        enabled: root.guardEnabled && root.target !== null
        ignoreUnknownSignals: true
        function onActiveFocusChanged() {
            if (!root.commitOnFocusLost || !root.target || root.target.activeFocus === undefined)
                return
            if (!root.target.activeFocus)
                root.commitComposition("focus-lost")
        }
    }
}

// API usage (external):
// import LVRS 1.0 as LV
// LV.InputMethodGuard { target: textInputItem; guardEnabled: true }
