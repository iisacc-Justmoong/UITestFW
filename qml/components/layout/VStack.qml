import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // SwiftUI-like API: spacing == -1 uses defaultSpacing; alignment is horizontal only.
    property int spacing: -1
    property int defaultSpacing: 8
    property int alignment: Qt.AlignHCenter
    // alignmentName supports SwiftUI-style names: leading, center, trailing.
    property string alignmentName: ""

    default property alias content: contentColumn.data

    implicitWidth: contentColumn.implicitWidth
    implicitHeight: contentColumn.implicitHeight

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        spacing: root.spacing < 0 ? root.defaultSpacing : root.spacing
    }

    onAlignmentChanged: updateAlignment()
    onAlignmentNameChanged: updateAlignment()
    Component.onCompleted: updateAlignment()

    function updateAlignment() {
        var normalized = normalizeAlignment(root.alignment, root.alignmentName)
        for (var i = 0; i < contentColumn.children.length; i++) {
            var child = contentColumn.children[i]
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
        if (value & Qt.AlignRight)
            return Qt.AlignRight
        if (value & Qt.AlignHCenter)
            return Qt.AlignHCenter
        return Qt.AlignLeft
    }

    function normalizeAlignmentName(name) {
        var token = String(name || "").toLowerCase()
        if (!token)
            return 0
        if (token === "leading")
            return Qt.AlignLeft
        if (token === "center")
            return Qt.AlignHCenter
        if (token === "trailing")
            return Qt.AlignRight
        return 0
    }

    Connections {
        target: contentColumn
        function onChildrenChanged() {
            root.updateAlignment()
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.VStack { spacing: 8; Text { text: "Title" } }
