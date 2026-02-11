cmake_minimum_required(VERSION 3.21)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(UIFrameworkExampleTypingPractice LANGUAGES CXX)

    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)

    find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Svg Network)
    qt_standard_project_setup()
endif()

if(NOT TARGET UIFramework)
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../.. backend_build)
endif()

qt_add_executable(UIFrameworkExampleTypingPractice
    main.cpp
)

qt_add_qml_module(UIFrameworkExampleTypingPractice
    URI ExampleTypingPractice
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES
        qml/Main.qml
)

target_link_libraries(UIFrameworkExampleTypingPractice
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        UIFramework
        UIFrameworkplugin
        UIFrameworkplugin_init
)

add_custom_target(run_UIFrameworkExampleTypingPractice
    COMMAND $<TARGET_FILE:UIFrameworkExampleTypingPractice>
    DEPENDS UIFrameworkExampleTypingPractice
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    USES_TERMINAL
)
