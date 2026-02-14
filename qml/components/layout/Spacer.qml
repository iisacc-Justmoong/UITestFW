import QtQuick
import QtQuick.Layouts
import LVRS 1.0

Item {
    id: root

    // SwiftUI-like API: minLength applies along the stack axis.
    property int minLength: 0
    // Used by VStack/HStack to force axis without relying on parent meta info.
    property string stackAxis: ""

    implicitWidth: 0
    implicitHeight: 0

    Layout.fillWidth: root._fillWidth
    Layout.fillHeight: root._fillHeight
    Layout.minimumWidth: root._minWidth
    Layout.minimumHeight: root._minHeight

    property bool _fillWidth: false
    property bool _fillHeight: false
    property int _minWidth: 0
    property int _minHeight: 0

    onMinLengthChanged: updateLayout()
    onStackAxisChanged: updateLayout()
    onParentChanged: updateLayout()
    Component.onCompleted: updateLayout()

    function updateLayout() {
        _fillWidth = false
        _fillHeight = false
        _minWidth = 0
        _minHeight = 0
        anchors.fill = null

        if (!parent)
            return

        var className = parent.metaObject ? parent.metaObject.className : ""
        var inLayout = className.indexOf("RowLayout") !== -1 || className.indexOf("ColumnLayout") !== -1
        if (!(parent.__isVStack === true || parent.__isHStack === true || inLayout) && stackAxis !== "")
            stackAxis = ""

        if (parent.__isZStack === true) {
            anchors.fill = parent
            return
        }

        var resolvedAxis = stackAxis
        if (resolvedAxis === "") {
            if (parent.__isVStack === true || (parent.parent && parent.parent.__isVStack === true))
                resolvedAxis = "vertical"
            else if (parent.__isHStack === true || (parent.parent && parent.parent.__isHStack === true))
                resolvedAxis = "horizontal"
        }

        if (resolvedAxis === "vertical") {
            _fillHeight = true
            _minHeight = minLength
            return
        }
        if (resolvedAxis === "horizontal") {
            _fillWidth = true
            _minWidth = minLength
            return
        }

        if (className.indexOf("RowLayout") !== -1) {
            _fillWidth = true
            _minWidth = minLength
        } else if (className.indexOf("ColumnLayout") !== -1) {
            _fillHeight = true
            _minHeight = minLength
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("Spacer", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as LV
// LV.Spacer { minLength: 12 }
