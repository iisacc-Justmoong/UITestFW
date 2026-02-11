import QtQuick
import UIFramework 1.0

IconButton {
    id: control

    readonly property bool __isToolbarButton: true
    property int buttonId: -1
    property var toolbar: null

    readonly property bool active: toolbar && toolbar.activeButton === control

    tone: active ? AbstractButton.Accent : AbstractButton.Borderless
    backgroundColorHover: active ? backgroundColor : Theme.surfaceAlt
    backgroundColorPressed: active ? backgroundColor : Theme.surfaceAlt

    onClicked: {
        if (toolbar && toolbar.requestActivate)
            toolbar.requestActivate(control)
    }

    onToolbarChanged: {
        if (toolbar && toolbar.registerButton)
            toolbar.registerButton(control)
    }

    QtObject {
        Component.onCompleted: {
            if (control.toolbar && control.toolbar.registerButton)
                control.toolbar.registerButton(control)
            Debug.log("ToolbarButton", "created")
        }
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ToolbarButton { buttonId: 1; iconName: "view-more-symbolic-default" }
