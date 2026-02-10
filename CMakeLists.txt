cmake_minimum_required(VERSION 3.21)
project(UITestFW LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Test Svg Network)
include(CMakePackageConfigHelpers)

qt_standard_project_setup()

option(UIFRAMEWORK_FORCE_X86_QT_TOOLS "Force Qt host tools to run under x86_64 (Rosetta)" OFF)
option(UIFRAMEWORK_ENABLE_DUMMY_AGL "Provide a dummy AGL framework when the system one is missing" ON)

if(APPLE AND UIFRAMEWORK_ENABLE_DUMMY_AGL)
    if(NOT EXISTS "/System/Library/Frameworks/AGL.framework/AGL")
        set(_uifw_framework_root "${CMAKE_CURRENT_BINARY_DIR}/frameworks")
        set(_uifw_agl_framework "${_uifw_framework_root}/AGL.framework")
        set(_uifw_agl_versions "${_uifw_agl_framework}/Versions")
        set(_uifw_agl_version_a "${_uifw_agl_versions}/A")
        set(_uifw_agl_binary "${_uifw_agl_version_a}/AGL")

        file(MAKE_DIRECTORY "${_uifw_agl_version_a}/Headers")
        file(MAKE_DIRECTORY "${_uifw_agl_version_a}/Resources")
        set(_uifw_agl_rebuild FALSE)
        if(EXISTS "${_uifw_agl_binary}")
            execute_process(
                COMMAND lipo -info "${_uifw_agl_binary}"
                OUTPUT_VARIABLE _uifw_agl_lipo_info
                RESULT_VARIABLE _uifw_agl_lipo_result
            )
            if(NOT _uifw_agl_lipo_result EQUAL 0)
                set(_uifw_agl_rebuild TRUE)
            elseif(CMAKE_OSX_ARCHITECTURES)
                foreach(_uifw_arch IN LISTS CMAKE_OSX_ARCHITECTURES)
                    if(NOT _uifw_agl_lipo_info MATCHES "${_uifw_arch}")
                        set(_uifw_agl_rebuild TRUE)
                    endif()
                endforeach()
            endif()
        else()
            set(_uifw_agl_rebuild TRUE)
        endif()

        if(_uifw_agl_rebuild)
            set(_uifw_agl_stub "${CMAKE_CURRENT_BINARY_DIR}/agl_stub.c")
            file(WRITE "${_uifw_agl_stub}" "void _uifw_dummy_agl(void) {}\n")
            set(_uifw_agl_arch_flags "")
            if(CMAKE_OSX_ARCHITECTURES)
                foreach(_uifw_arch IN LISTS CMAKE_OSX_ARCHITECTURES)
                    list(APPEND _uifw_agl_arch_flags -arch "${_uifw_arch}")
                endforeach()
            endif()
            execute_process(
                COMMAND "${CMAKE_CXX_COMPILER}" ${_uifw_agl_arch_flags} -dynamiclib "${_uifw_agl_stub}" -o "${_uifw_agl_binary}"
                RESULT_VARIABLE _uifw_agl_build_result
            )
            if(NOT _uifw_agl_build_result EQUAL 0)
                message(FATAL_ERROR "Failed to build dummy AGL framework")
            endif()
            file(WRITE "${_uifw_agl_version_a}/Headers/AGL.h" "void _uifw_dummy_agl(void);\n")
            file(WRITE "${_uifw_agl_version_a}/Resources/Info.plist" "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\"><dict><key>CFBundleName</key><string>AGL</string></dict></plist>\n")
        endif()
        if(NOT EXISTS "${_uifw_agl_versions}/Current")
            file(CREATE_LINK "A" "${_uifw_agl_versions}/Current" SYMBOLIC)
        endif()
        if(EXISTS "${_uifw_agl_framework}/AGL")
            file(REMOVE "${_uifw_agl_framework}/AGL")
        endif()
        file(CREATE_LINK "Versions/Current/AGL" "${_uifw_agl_framework}/AGL" SYMBOLIC)
        if(EXISTS "${_uifw_agl_framework}/Headers")
            file(REMOVE_RECURSE "${_uifw_agl_framework}/Headers")
        endif()
        file(CREATE_LINK "Versions/Current/Headers" "${_uifw_agl_framework}/Headers" SYMBOLIC)
        if(EXISTS "${_uifw_agl_framework}/Resources")
            file(REMOVE_RECURSE "${_uifw_agl_framework}/Resources")
        endif()
        file(CREATE_LINK "Versions/Current/Resources" "${_uifw_agl_framework}/Resources" SYMBOLIC)
        set(CMAKE_FRAMEWORK_PATH "${_uifw_framework_root}" ${CMAKE_FRAMEWORK_PATH})
        add_link_options("-F${_uifw_framework_root}")
    endif()
endif()

if(APPLE AND UIFRAMEWORK_FORCE_X86_QT_TOOLS)
    function(_uifw_wrap_qt_tool target)
        get_target_property(_tool_path ${target} IMPORTED_LOCATION)
        if(NOT _tool_path)
            return()
        endif()
        string(REPLACE "::" "_" _tool_name "${target}")
        set(_wrapper "${CMAKE_CURRENT_BINARY_DIR}/${_tool_name}_x86_wrapper")
        file(WRITE "${_wrapper}" "#!/bin/sh\nexec arch -x86_64 \"${_tool_path}\" \"$@\"\n")
        file(CHMOD "${_wrapper}"
            PERMISSIONS
                OWNER_READ OWNER_WRITE OWNER_EXECUTE
                GROUP_READ GROUP_EXECUTE
                WORLD_READ WORLD_EXECUTE
        )
        set_property(TARGET ${target} PROPERTY IMPORTED_LOCATION "${_wrapper}")
    endfunction()

    _uifw_wrap_qt_tool(Qt6::rcc)
    if(TARGET Qt6::qmlcachegen)
        _uifw_wrap_qt_tool(Qt6::qmlcachegen)
    endif()
    if(TARGET Qt6::qmlsc)
        _uifw_wrap_qt_tool(Qt6::qmlsc)
    endif()
    if(TARGET Qt6::qmltyperegistrar)
        _uifw_wrap_qt_tool(Qt6::qmltyperegistrar)
    endif()
endif()

qt_add_library(UIFramework STATIC)
add_library(UIFramework::UIFramework ALIAS UIFramework)

include(${CMAKE_CURRENT_LIST_DIR}/backend/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/qml/CMakeLists.txt)

target_include_directories(UIFramework
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/io>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/fonts>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/platform>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/runtime>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/navigation>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/state>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/graphics>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/backend/text>
        $<INSTALL_INTERFACE:include/UIFramework>
)

qt_add_qml_module(UIFramework
    URI UIFramework
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/UIFramework"
    SOURCES
        ${UIFRAMEWORK_BACKEND_SOURCES}
        ${UIFRAMEWORK_BACKEND_HEADERS}
    QML_FILES
        ${UIFRAMEWORK_QML_FILES}
    RESOURCES
        ${UIFRAMEWORK_RESOURCE_FILES}
)

target_link_libraries(UIFramework
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Qml
        Qt6::Svg
        Qt6::Network
)

option(UIFRAMEWORK_BUILD_DEMO "Build the UITestFW demo application" ON)
option(UIFRAMEWORK_BUILD_TESTS "Build UIFramework tests" ON)

if(UIFRAMEWORK_BUILD_DEMO)
    qt_add_executable(UITestFW
        MANUAL_FINALIZATION
        main.cpp
    )

    qt_add_qml_module(UITestFW
        URI UITestFW
        VERSION 1.0
        RESOURCE_PREFIX "/qt/qml"
        OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/UITestFW"
        QML_FILES
            ${UITESTFW_QML_FILES}
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

if(UIFRAMEWORK_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

set(_uifw_export_targets UIFramework)
if(TARGET UIFramework_resources_1)
    list(APPEND _uifw_export_targets UIFramework_resources_1)
endif()
if(TARGET UIFramework_resources_2)
    list(APPEND _uifw_export_targets UIFramework_resources_2)
endif()

install(TARGETS ${_uifw_export_targets}
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

install(
    DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/backend/
    DESTINATION include/UIFramework/backend
    FILES_MATCHING
        PATTERN "*.h"
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
