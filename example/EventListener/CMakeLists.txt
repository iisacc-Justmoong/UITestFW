cmake_minimum_required(VERSION 3.21)
project(UIFrameworkExampleEventListener LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../../ backend_build)

qt_add_executable(UIFrameworkExampleEventListener
    main.cpp
)

qt_add_qml_module(UIFrameworkExampleEventListener
    URI ExampleEventListener
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES
        Main.qml
        BasicClick.qml
        HoverCard.qml
        PressRelease.qml
        RightClick.qml
        KeyPress.qml
        MultiTrigger.qml
)

target_link_libraries(UIFrameworkExampleEventListener
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        UIFramework
)
