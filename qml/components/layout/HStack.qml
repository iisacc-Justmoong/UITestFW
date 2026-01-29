import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // SwiftUI-like API: spacing == -1 uses defaultSpacing; alignment is vertical only.
    property int spacing: -1
    property int defaultSpacing: 8
    property int alignment: Qt.AlignVCenter
    // alignmentName supports SwiftUI-style names: top, center, bottom.
    property string alignmentName: ""

    default property alias content: contentRow.data

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    RowLayout {
        id: contentRow
        anchors.fill: parent
        spacing: root.spacing < 0 ? root.defaultSpacing : root.spacing
    }

    onAlignmentChanged: updateAlignment()
    onAlignmentNameChanged: updateAlignment()
    Component.onCompleted: updateAlignment()

    function updateAlignment() {
        var normalized = normalizeAlignment(root.alignment, root.alignmentName)
        for (var i = 0; i < contentRow.children.length; i++) {
            var child = contentRow.children[i]
            if (!child || child.Layout === undefined)
                continue
            if (child.Layout.alignment === 0)
                child.Layout.alignment = normalized
        }
    }

    function normalizeAlignment(value, name) {
        var named = normalizeAlignmentName(name)
        if (named !== 0)
            return named
        if (value & Qt.AlignBottom)
            return Qt.AlignBottom
        if (value & Qt.AlignVCenter)
            return Qt.AlignVCenter
        return Qt.AlignTop
    }

    function normalizeAlignmentName(name) {
        var token = String(name || "").toLowerCase()
        if (!token)
            return 0
        if (token === "top")
            return Qt.AlignTop
        if (token === "center")
            return Qt.AlignVCenter
        if (token === "bottom")
            return Qt.AlignBottom
        return 0
    }

    Connections {
        target: contentRow
        function onChildrenChanged() {
            root.updateAlignment()
        }
    }
    QtObject {
        Component.onCompleted: UIF.Debug.log("HStack", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.HStack { spacing: 12; Text { text: "Left" }; Text { text: "Right" } }
