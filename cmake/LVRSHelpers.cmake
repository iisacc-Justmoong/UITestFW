include(CMakeParseArguments)

function(_lvrs_internal_append_unique_qml_import_path target path_value)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "lvrs_configure_qml_app() target not found: ${target}")
    endif()

    if(path_value STREQUAL "" OR NOT IS_DIRECTORY "${path_value}")
        return()
    endif()

    get_target_property(_lvrs_existing_import_paths "${target}" QT_QML_IMPORT_PATH)
    if(NOT _lvrs_existing_import_paths OR _lvrs_existing_import_paths STREQUAL "QT_QML_IMPORT_PATH-NOTFOUND")
        set(_lvrs_existing_import_paths "")
    endif()

    set(_lvrs_paths "${_lvrs_existing_import_paths}")
    list(APPEND _lvrs_paths "${path_value}")
    list(REMOVE_DUPLICATES _lvrs_paths)
    set_property(TARGET "${target}" PROPERTY QT_QML_IMPORT_PATH "${_lvrs_paths}")
endfunction()

function(_lvrs_internal_apply_safe_default_output_dirs target)
    get_target_property(_lvrs_runtime_output_dir "${target}" RUNTIME_OUTPUT_DIRECTORY)
    if(NOT _lvrs_runtime_output_dir OR _lvrs_runtime_output_dir STREQUAL "RUNTIME_OUTPUT_DIRECTORY-NOTFOUND")
        # Prevent executable/output name collisions with qt_add_qml_module default OUTPUT_DIRECTORY.
        set_property(TARGET "${target}" PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")
    endif()
endfunction()

function(_lvrs_internal_maybe_link_static_lvrs_plugin target)
    set(_lvrs_plugin_target "")
    if(TARGET LVRSCoreplugin)
        set(_lvrs_plugin_target LVRSCoreplugin)
    elseif(TARGET LVRS::LVRSCoreplugin)
        set(_lvrs_plugin_target LVRS::LVRSCoreplugin)
    endif()

    if(_lvrs_plugin_target STREQUAL "")
        return()
    endif()

    set(_lvrs_is_static_plugin FALSE)
    get_target_property(_lvrs_plugin_type "${_lvrs_plugin_target}" TYPE)
    if(_lvrs_plugin_type STREQUAL "STATIC_LIBRARY")
        set(_lvrs_is_static_plugin TRUE)
    endif()

    if(NOT _lvrs_is_static_plugin)
        get_target_property(_lvrs_plugin_location "${_lvrs_plugin_target}" IMPORTED_LOCATION)
        if(_lvrs_plugin_location
           AND _lvrs_plugin_location MATCHES "\\${CMAKE_STATIC_LIBRARY_SUFFIX}$")
            set(_lvrs_is_static_plugin TRUE)
        endif()
    endif()

    if(_lvrs_is_static_plugin)
        target_link_libraries("${target}" PRIVATE "${_lvrs_plugin_target}")

        get_target_property(_lvrs_plugin_import_injected "${target}" _LVRS_STATIC_PLUGIN_IMPORT_INJECTED)
        if(NOT _lvrs_plugin_import_injected)
            set(_lvrs_plugin_import_source "${CMAKE_CURRENT_BINARY_DIR}/${target}_lvrs_plugin_import.cpp")
            file(WRITE "${_lvrs_plugin_import_source}" "#include <QtPlugin>\nQ_IMPORT_PLUGIN(LVRSPlugin)\n")
            target_sources("${target}" PRIVATE "${_lvrs_plugin_import_source}")
            set_property(TARGET "${target}" PROPERTY _LVRS_STATIC_PLUGIN_IMPORT_INJECTED TRUE)
        endif()
    endif()
endfunction()

function(lvrs_configure_qml_app target)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "lvrs_configure_qml_app() target not found: ${target}")
    endif()

    target_link_libraries("${target}" PRIVATE LVRS::LVRS)
    _lvrs_internal_apply_safe_default_output_dirs("${target}")
    _lvrs_internal_maybe_link_static_lvrs_plugin("${target}")

    # Allow qmlimportscanner and IDE tooling to discover installed LVRS module
    # metadata for downstream package consumers. For in-tree builds this can emit
    # early "qmldir not found" warnings before the module output directory exists.
    get_target_property(_lvrs_package_target_imported LVRS::LVRS IMPORTED)
    if(_lvrs_package_target_imported)
        if(DEFINED LVRS_QML_IMPORT_PATH)
            _lvrs_internal_append_unique_qml_import_path("${target}" "${LVRS_QML_IMPORT_PATH}")
        endif()
        if(DEFINED LVRS_QML_MODULE_PATH)
            _lvrs_internal_append_unique_qml_import_path("${target}" "${LVRS_QML_MODULE_PATH}")
        endif()
    endif()

    # Ensure static QML plugins referenced by LVRS imports are linked/imported
    # when the consuming target is finalized.
    if(COMMAND qt_import_qml_plugins)
        qt_import_qml_plugins("${target}")
    endif()

endfunction()

function(lvrs_add_qml_app)
    set(_lvrs_options "")
    set(_lvrs_one_value_args TARGET URI VERSION ROOT_OBJECT APP_NAME STYLE)
    set(_lvrs_multi_value_args SOURCES QML_FILES RESOURCES)
    cmake_parse_arguments(LVRS_APP
        "${_lvrs_options}"
        "${_lvrs_one_value_args}"
        "${_lvrs_multi_value_args}"
        ${ARGN}
    )

    if(NOT LVRS_APP_TARGET)
        message(FATAL_ERROR "lvrs_add_qml_app() requires TARGET")
    endif()
    if(NOT LVRS_APP_URI)
        message(FATAL_ERROR "lvrs_add_qml_app() requires URI")
    endif()
    if(NOT LVRS_APP_QML_FILES)
        message(FATAL_ERROR "lvrs_add_qml_app() requires at least one QML_FILES entry")
    endif()
    if(NOT TARGET Qt6::Quick OR NOT TARGET Qt6::QuickControls2)
        message(FATAL_ERROR "lvrs_add_qml_app() requires Qt6::Quick and Qt6::QuickControls2 targets. Call find_package(Qt6 ... COMPONENTS Quick QuickControls2) first.")
    endif()

    if(NOT LVRS_APP_VERSION)
        set(LVRS_APP_VERSION "1.0")
    endif()
    if(NOT LVRS_APP_ROOT_OBJECT)
        set(LVRS_APP_ROOT_OBJECT "Main")
    endif()
    if(NOT LVRS_APP_APP_NAME)
        set(LVRS_APP_APP_NAME "${LVRS_APP_TARGET}")
    endif()
    if(NOT LVRS_APP_STYLE)
        set(LVRS_APP_STYLE "Basic")
    endif()

    set(_lvrs_sources ${LVRS_APP_SOURCES})
    if(NOT _lvrs_sources)
        set(LVRS_ENTRY_APP_NAME "${LVRS_APP_APP_NAME}")
        set(LVRS_ENTRY_STYLE "${LVRS_APP_STYLE}")
        set(LVRS_ENTRY_URI "${LVRS_APP_URI}")
        set(LVRS_ENTRY_ROOT_OBJECT "${LVRS_APP_ROOT_OBJECT}")
        set(_lvrs_entry_template "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/LVRSAppEntryPoint.cpp.in")
        if(NOT EXISTS "${_lvrs_entry_template}")
            message(FATAL_ERROR "lvrs_add_qml_app() template not found: ${_lvrs_entry_template}")
        endif()
        set(_lvrs_generated_entry "${CMAKE_CURRENT_BINARY_DIR}/${LVRS_APP_TARGET}_lvrs_entrypoint.cpp")
        configure_file("${_lvrs_entry_template}" "${_lvrs_generated_entry}" @ONLY)
        list(APPEND _lvrs_sources "${_lvrs_generated_entry}")
    endif()

    qt_add_executable(${LVRS_APP_TARGET}
        ${_lvrs_sources}
    )

    set(_lvrs_qml_module_args
        URI ${LVRS_APP_URI}
        VERSION ${LVRS_APP_VERSION}
        RESOURCE_PREFIX "/qt/qml"
        QML_FILES
            ${LVRS_APP_QML_FILES}
    )
    if(LVRS_APP_RESOURCES)
        list(APPEND _lvrs_qml_module_args
            RESOURCES
                ${LVRS_APP_RESOURCES}
        )
    endif()
    qt_add_qml_module(${LVRS_APP_TARGET}
        ${_lvrs_qml_module_args}
    )

    target_link_libraries(${LVRS_APP_TARGET}
        PRIVATE
            Qt6::Quick
            Qt6::QuickControls2
    )
    lvrs_configure_qml_app(${LVRS_APP_TARGET})
endfunction()
