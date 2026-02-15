cmake_minimum_required(VERSION 3.21)

function(_lvrs_export_fail message_text)
    message(FATAL_ERROR "LVRS bootstrap export: ${message_text}")
endfunction()

if(NOT DEFINED LVRS_EXPORT_KIND OR LVRS_EXPORT_KIND STREQUAL "")
    _lvrs_export_fail("LVRS_EXPORT_KIND is required.")
endif()
if(NOT DEFINED LVRS_EXPORT_SOURCE_DIR OR LVRS_EXPORT_SOURCE_DIR STREQUAL "")
    _lvrs_export_fail("LVRS_EXPORT_SOURCE_DIR is required.")
endif()
if(NOT DEFINED LVRS_EXPORT_OUTPUT_DIR OR LVRS_EXPORT_OUTPUT_DIR STREQUAL "")
    _lvrs_export_fail("LVRS_EXPORT_OUTPUT_DIR is required.")
endif()
if(NOT DEFINED LVRS_EXPORT_TARGET)
    set(LVRS_EXPORT_TARGET "")
endif()

if(NOT IS_DIRECTORY "${LVRS_EXPORT_SOURCE_DIR}")
    _lvrs_export_fail("source directory does not exist: ${LVRS_EXPORT_SOURCE_DIR}")
endif()

if(LVRS_EXPORT_KIND STREQUAL "android_studio")
    file(REMOVE_RECURSE "${LVRS_EXPORT_OUTPUT_DIR}")
    file(MAKE_DIRECTORY "${LVRS_EXPORT_OUTPUT_DIR}")
    execute_process(
        COMMAND "${CMAKE_COMMAND}" -E copy_directory "${LVRS_EXPORT_SOURCE_DIR}" "${LVRS_EXPORT_OUTPUT_DIR}"
        RESULT_VARIABLE _lvrs_export_copy_result
    )
    if(NOT _lvrs_export_copy_result EQUAL 0)
        _lvrs_export_fail("failed to copy Android Studio project from '${LVRS_EXPORT_SOURCE_DIR}'.")
    endif()
    message(STATUS "LVRS bootstrap export: Android Studio project -> ${LVRS_EXPORT_OUTPUT_DIR}")
    return()
endif()

if(LVRS_EXPORT_KIND STREQUAL "wasm_site")
    file(GLOB _lvrs_wasm_html_candidates "${LVRS_EXPORT_SOURCE_DIR}/*.html")
    set(_lvrs_wasm_entry_html "")

    if(LVRS_EXPORT_TARGET)
        foreach(_lvrs_candidate IN LISTS _lvrs_wasm_html_candidates)
            get_filename_component(_lvrs_name "${_lvrs_candidate}" NAME)
            if(_lvrs_name STREQUAL "${LVRS_EXPORT_TARGET}.html")
                set(_lvrs_wasm_entry_html "${_lvrs_candidate}")
                break()
            endif()
        endforeach()
    endif()

    if(_lvrs_wasm_entry_html STREQUAL "" AND _lvrs_wasm_html_candidates)
        list(SORT _lvrs_wasm_html_candidates)
        list(GET _lvrs_wasm_html_candidates 0 _lvrs_wasm_entry_html)
    endif()

    if(_lvrs_wasm_entry_html STREQUAL "")
        _lvrs_export_fail("WASM HTML entry artifact was not found under '${LVRS_EXPORT_SOURCE_DIR}'.")
    endif()

    file(REMOVE_RECURSE "${LVRS_EXPORT_OUTPUT_DIR}")
    file(MAKE_DIRECTORY "${LVRS_EXPORT_OUTPUT_DIR}")

    get_filename_component(_lvrs_wasm_entry_name "${_lvrs_wasm_entry_html}" NAME)
    get_filename_component(_lvrs_wasm_entry_stem "${_lvrs_wasm_entry_html}" NAME_WE)
    execute_process(
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_lvrs_wasm_entry_html}" "${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_wasm_entry_name}"
        RESULT_VARIABLE _lvrs_export_copy_result
    )
    if(NOT _lvrs_export_copy_result EQUAL 0)
        _lvrs_export_fail("failed to copy WASM HTML entry '${_lvrs_wasm_entry_html}'.")
    endif()

    set(_lvrs_wasm_asset_patterns
        "${LVRS_EXPORT_SOURCE_DIR}/${_lvrs_wasm_entry_stem}.js"
        "${LVRS_EXPORT_SOURCE_DIR}/${_lvrs_wasm_entry_stem}.wasm"
        "${LVRS_EXPORT_SOURCE_DIR}/${_lvrs_wasm_entry_stem}.worker.js"
        "${LVRS_EXPORT_SOURCE_DIR}/${_lvrs_wasm_entry_stem}*.data"
        "${LVRS_EXPORT_SOURCE_DIR}/qtloader.js"
    )
    foreach(_lvrs_pattern IN LISTS _lvrs_wasm_asset_patterns)
        file(GLOB _lvrs_wasm_assets "${_lvrs_pattern}")
        foreach(_lvrs_asset IN LISTS _lvrs_wasm_assets)
            if(IS_DIRECTORY "${_lvrs_asset}")
                continue()
            endif()
            get_filename_component(_lvrs_asset_name "${_lvrs_asset}" NAME)
            execute_process(
                COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_lvrs_asset}" "${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_asset_name}"
                RESULT_VARIABLE _lvrs_export_copy_result
            )
            if(NOT _lvrs_export_copy_result EQUAL 0)
                _lvrs_export_fail("failed to copy WASM asset '${_lvrs_asset}'.")
            endif()
        endforeach()
    endforeach()

    message(STATUS "LVRS bootstrap export: WASM site -> ${LVRS_EXPORT_OUTPUT_DIR}")
    return()
endif()

if(LVRS_EXPORT_KIND STREQUAL "xcodeproj")
    file(GLOB _lvrs_xcode_candidates LIST_DIRECTORIES true "${LVRS_EXPORT_SOURCE_DIR}/*.xcodeproj")
    set(_lvrs_xcode_project "")

    if(LVRS_EXPORT_TARGET)
        foreach(_lvrs_candidate IN LISTS _lvrs_xcode_candidates)
            get_filename_component(_lvrs_name "${_lvrs_candidate}" NAME)
            if(_lvrs_name STREQUAL "${LVRS_EXPORT_TARGET}.xcodeproj")
                set(_lvrs_xcode_project "${_lvrs_candidate}")
                break()
            endif()
        endforeach()
    endif()

    if(_lvrs_xcode_project STREQUAL "" AND _lvrs_xcode_candidates)
        list(SORT _lvrs_xcode_candidates)
        list(GET _lvrs_xcode_candidates 0 _lvrs_xcode_project)
    endif()

    if(_lvrs_xcode_project STREQUAL "")
        _lvrs_export_fail("xcodeproj artifact was not found under '${LVRS_EXPORT_SOURCE_DIR}'.")
    endif()

    get_filename_component(_lvrs_xcode_name "${_lvrs_xcode_project}" NAME)
    file(REMOVE_RECURSE "${LVRS_EXPORT_OUTPUT_DIR}")
    file(MAKE_DIRECTORY "${LVRS_EXPORT_OUTPUT_DIR}")

    execute_process(
        COMMAND "${CMAKE_COMMAND}" -E copy_directory "${_lvrs_xcode_project}" "${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_xcode_name}"
        RESULT_VARIABLE _lvrs_export_copy_result
    )
    if(NOT _lvrs_export_copy_result EQUAL 0)
        _lvrs_export_fail("failed to copy Xcode project from '${_lvrs_xcode_project}'.")
    endif()

    message(STATUS "LVRS bootstrap export: Xcode project -> ${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_xcode_name}")
    return()
endif()

_lvrs_export_fail("unsupported LVRS_EXPORT_KIND='${LVRS_EXPORT_KIND}'.")
