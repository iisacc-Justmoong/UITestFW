set(UIFRAMEWORK_QML_FILES
    qml/AppShell.qml
    qml/ApplicationWindow.qml
    qml/Theme.qml
)

set_source_files_properties(qml/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

set(UITESTFW_QML_FILES
    qml/Main.qml
)

include(${CMAKE_CURRENT_LIST_DIR}/components/CMakeLists.txt)
list(APPEND UIFRAMEWORK_QML_FILES ${UIFRAMEWORK_COMPONENT_QML_FILES})
set(UIFRAMEWORK_RESOURCE_FILES
    ${UIFRAMEWORK_COMPONENT_RESOURCE_FILES}
)
