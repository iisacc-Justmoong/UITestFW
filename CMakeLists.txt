cmake_minimum_required(VERSION 3.21)
project(UITestFW LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)
include(CMakePackageConfigHelpers)

qt_standard_project_setup()

qt_add_library(UIFramework STATIC)
add_library(UIFramework::UIFramework ALIAS UIFramework)

target_include_directories(UIFramework
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
        $<INSTALL_INTERFACE:include/UIFramework>
)

qt_add_qml_module(UIFramework
    URI UIFramework
    VERSION 1.0
    SOURCES
        backend.h
        backend.cpp
        platforminfo.h
        platforminfo.cpp
    QML_FILES
        qml/AppShell.qml
        qml/ApplicationWindow.qml
        qml/Theme.qml
        qml/components/AppCard.qml
        qml/components/AppHeader.qml
        qml/components/AppScaffold.qml
)

target_link_libraries(UIFramework
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Qml
)

option(UIFRAMEWORK_BUILD_DEMO "Build the UITestFW demo application" ON)

if(UIFRAMEWORK_BUILD_DEMO)
    qt_add_executable(UITestFW
        MANUAL_FINALIZATION
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

    set_target_properties(UITestFW PROPERTIES
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
    )

    if(IOS)
        set(UIFRAMEWORK_IOS_BUNDLE_ID "" CACHE STRING "Override iOS bundle identifier for UITestFW demo")
        if(UIFRAMEWORK_IOS_BUNDLE_ID)
            set_target_properties(UITestFW PROPERTIES
                XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "${UIFRAMEWORK_IOS_BUNDLE_ID}"
            )
        endif()
    endif()

    qt_finalize_executable(UITestFW)
endif()

install(TARGETS UIFramework
    EXPORT UIFrameworkTargets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include/UIFramework
)

install(EXPORT UIFrameworkTargets
    NAMESPACE UIFramework::
    DESTINATION lib/cmake/UIFramework
)

qt_install_qml_module(UIFramework)

install(FILES
    backend.h
    platforminfo.h
    DESTINATION include/UIFramework
)

configure_package_config_file(
    "${CMAKE_CURRENT_LIST_DIR}/cmake/UIFrameworkConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/UIFrameworkConfig.cmake"
    INSTALL_DESTINATION lib/cmake/UIFramework
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/UIFrameworkConfigVersion.cmake"
    VERSION 1.0.0
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/UIFrameworkConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/UIFrameworkConfigVersion.cmake"
    DESTINATION lib/cmake/UIFramework
)
