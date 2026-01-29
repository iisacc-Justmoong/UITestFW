import QtQuick
import QtQuick.Layouts
import UIFramework 1.0 as UIF

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

        if (parent.__isZStack === true) {
            anchors.fill = parent
            return
        }

        if (stackAxis === "vertical") {
            _fillHeight = true
            _minHeight = minLength
            return
        }
        if (stackAxis === "horizontal") {
            _fillWidth = true
            _minWidth = minLength
            return
        }

        var className = parent.metaObject ? parent.metaObject.className : ""
        if (className.indexOf("RowLayout") !== -1) {
            _fillWidth = true
            _minWidth = minLength
        } else if (className.indexOf("ColumnLayout") !== -1) {
            _fillHeight = true
            _minHeight = minLength
        }
    }
    QtObject {
        Component.onCompleted: UIF.Debug.log("Spacer", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Spacer { minLength: 12 }
