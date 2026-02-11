set(UIFRAMEWORK_QML_FILES
    qml/AppShell.qml
    qml/ApplicationWindow.qml
    qml/Theme.qml
)

set_source_files_properties(qml/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

set(UIFRAMEWORK_DEMO_QML_FILES
    qml/Main.qml
)

include(${CMAKE_CURRENT_LIST_DIR}/components/CMakeLists.txt)
list(APPEND UIFRAMEWORK_QML_FILES ${UIFRAMEWORK_COMPONENT_QML_FILES})

set(UIFRAMEWORK_FONT_RESOURCE_FILES
    resources/font/Pretendard-Black.ttf
    resources/font/Pretendard-Bold.ttf
    resources/font/Pretendard-ExtraBold.ttf
    resources/font/Pretendard-ExtraLight.ttf
    resources/font/Pretendard-Light.ttf
    resources/font/Pretendard-Medium.ttf
    resources/font/Pretendard-Regular.ttf
    resources/font/Pretendard-SemiBold.ttf
    resources/font/Pretendard-Thin.ttf
)

set(UIFRAMEWORK_RESOURCE_FILES
    ${UIFRAMEWORK_COMPONENT_RESOURCE_FILES}
    ${UIFRAMEWORK_FONT_RESOURCE_FILES}
)
