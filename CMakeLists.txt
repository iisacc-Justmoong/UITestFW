cmake_minimum_required(VERSION 3.31)
project(UITestFW LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup()

qt_add_library(UIFramework STATIC)

qt_add_qml_module(UIFramework
    URI UIFramework
    VERSION 1.0
    QML_FILES
        qml/AppShell.qml
        qml/ApplicationWindow.qml
        qml/Theme.qml
        qml/components/AppCard.qml
        qml/components/AppHeader.qml
        qml/components/AppScaffold.qml
)

target_link_libraries(UIFramework
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)

qt_add_executable(UITestFW
    main.cpp
)

qt_add_qml_module(UITestFW
    URI UITestFW
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(UITestFW
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        UIFramework
)
