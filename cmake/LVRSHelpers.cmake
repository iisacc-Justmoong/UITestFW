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

function(lvrs_configure_qml_app target)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "lvrs_configure_qml_app() target not found: ${target}")
    endif()

    target_link_libraries("${target}" PRIVATE LVRS::LVRS)
    _lvrs_internal_apply_safe_default_output_dirs("${target}")

    # Allow qmlimportscanner and IDE tooling to discover installed LVRS module metadata.
    if(DEFINED LVRS_QML_IMPORT_PATH)
        _lvrs_internal_append_unique_qml_import_path("${target}" "${LVRS_QML_IMPORT_PATH}")
    endif()
    if(DEFINED LVRS_QML_MODULE_PATH)
        _lvrs_internal_append_unique_qml_import_path("${target}" "${LVRS_QML_MODULE_PATH}")
    endif()

endfunction()
