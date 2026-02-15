cmake_minimum_required(VERSION 3.21)

function(_lvrs_export_fail message_text)
    message(FATAL_ERROR "LVRS bootstrap export: ${message_text}")
endfunction()

function(_lvrs_export_collect_wasm_html_candidates root_dir out_var)
    file(GLOB_RECURSE _lvrs_html_candidates "${root_dir}/*.html")
    set(_lvrs_filtered_candidates "")

    foreach(_lvrs_candidate IN LISTS _lvrs_html_candidates)
        if(IS_DIRECTORY "${_lvrs_candidate}")
            continue()
        endif()
        file(RELATIVE_PATH _lvrs_rel_candidate "${root_dir}" "${_lvrs_candidate}")
        if(_lvrs_rel_candidate MATCHES "(^|/)CMakeFiles/")
            continue()
        endif()
        list(APPEND _lvrs_filtered_candidates "${_lvrs_candidate}")
    endforeach()

    list(REMOVE_DUPLICATES _lvrs_filtered_candidates)
    set(${out_var} ${_lvrs_filtered_candidates} PARENT_SCOPE)
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
    set(_lvrs_wasm_entry_html "")
    set(_lvrs_wasm_metadata_file "${LVRS_EXPORT_SOURCE_DIR}/LVRSWasmArtifact.cmake")
    if(EXISTS "${_lvrs_wasm_metadata_file}")
        include("${_lvrs_wasm_metadata_file}")
        if(DEFINED LVRS_WASM_ENTRY_HTML
           AND NOT LVRS_WASM_ENTRY_HTML STREQUAL ""
           AND EXISTS "${LVRS_WASM_ENTRY_HTML}")
            set(_lvrs_wasm_entry_html "${LVRS_WASM_ENTRY_HTML}")
        elseif(DEFINED LVRS_WASM_ENTRY_RELATIVE
               AND NOT LVRS_WASM_ENTRY_RELATIVE STREQUAL ""
               AND EXISTS "${LVRS_EXPORT_SOURCE_DIR}/${LVRS_WASM_ENTRY_RELATIVE}")
            set(_lvrs_wasm_entry_html "${LVRS_EXPORT_SOURCE_DIR}/${LVRS_WASM_ENTRY_RELATIVE}")
        endif()
        unset(LVRS_WASM_ENTRY_HTML)
        unset(LVRS_WASM_ENTRY_RELATIVE)
        unset(LVRS_WASM_ARTIFACT_DIR)
    endif()

    _lvrs_export_collect_wasm_html_candidates("${LVRS_EXPORT_SOURCE_DIR}" _lvrs_wasm_html_candidates)

    if(_lvrs_wasm_entry_html STREQUAL "")
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
    endif()

    if(_lvrs_wasm_entry_html STREQUAL "")
        _lvrs_export_fail("WASM HTML entry artifact was not found under '${LVRS_EXPORT_SOURCE_DIR}'.")
    endif()

    file(RELATIVE_PATH _lvrs_wasm_entry_relpath "${LVRS_EXPORT_SOURCE_DIR}" "${_lvrs_wasm_entry_html}")
    if(_lvrs_wasm_entry_relpath MATCHES "^\\.\\./")
        _lvrs_export_fail("WASM HTML entry is outside source directory: ${_lvrs_wasm_entry_html}")
    endif()

    file(REMOVE_RECURSE "${LVRS_EXPORT_OUTPUT_DIR}")
    file(MAKE_DIRECTORY "${LVRS_EXPORT_OUTPUT_DIR}")

    set(_lvrs_wasm_asset_patterns
        "${LVRS_EXPORT_SOURCE_DIR}/*.html"
        "${LVRS_EXPORT_SOURCE_DIR}/*.js"
        "${LVRS_EXPORT_SOURCE_DIR}/*.mjs"
        "${LVRS_EXPORT_SOURCE_DIR}/*.cjs"
        "${LVRS_EXPORT_SOURCE_DIR}/*.wasm"
        "${LVRS_EXPORT_SOURCE_DIR}/*.worker.js"
        "${LVRS_EXPORT_SOURCE_DIR}/*.data"
        "${LVRS_EXPORT_SOURCE_DIR}/*.data.*"
        "${LVRS_EXPORT_SOURCE_DIR}/*.mem"
        "${LVRS_EXPORT_SOURCE_DIR}/*.symbols"
        "${LVRS_EXPORT_SOURCE_DIR}/*.json"
        "${LVRS_EXPORT_SOURCE_DIR}/*.css"
        "${LVRS_EXPORT_SOURCE_DIR}/*.map"
        "${LVRS_EXPORT_SOURCE_DIR}/*.png"
        "${LVRS_EXPORT_SOURCE_DIR}/*.jpg"
        "${LVRS_EXPORT_SOURCE_DIR}/*.jpeg"
        "${LVRS_EXPORT_SOURCE_DIR}/*.gif"
        "${LVRS_EXPORT_SOURCE_DIR}/*.svg"
        "${LVRS_EXPORT_SOURCE_DIR}/*.webp"
        "${LVRS_EXPORT_SOURCE_DIR}/*.ico"
        "${LVRS_EXPORT_SOURCE_DIR}/*.ttf"
        "${LVRS_EXPORT_SOURCE_DIR}/*.otf"
        "${LVRS_EXPORT_SOURCE_DIR}/*.woff"
        "${LVRS_EXPORT_SOURCE_DIR}/*.woff2"
    )
    set(_lvrs_wasm_assets "")
    foreach(_lvrs_pattern IN LISTS _lvrs_wasm_asset_patterns)
        file(GLOB_RECURSE _lvrs_pattern_assets "${_lvrs_pattern}")
        foreach(_lvrs_asset IN LISTS _lvrs_pattern_assets)
            if(IS_DIRECTORY "${_lvrs_asset}")
                continue()
            endif()
            list(APPEND _lvrs_wasm_assets "${_lvrs_asset}")
        endforeach()
    endforeach()
    list(REMOVE_DUPLICATES _lvrs_wasm_assets)

    if(NOT _lvrs_wasm_assets)
        _lvrs_export_fail("no exportable WASM site assets were found under '${LVRS_EXPORT_SOURCE_DIR}'.")
    endif()

    foreach(_lvrs_asset IN LISTS _lvrs_wasm_assets)
        file(RELATIVE_PATH _lvrs_asset_relpath "${LVRS_EXPORT_SOURCE_DIR}" "${_lvrs_asset}")
        if(_lvrs_asset_relpath MATCHES "^\\.\\./")
            continue()
        endif()
        if(_lvrs_asset_relpath MATCHES "(^|/)CMakeFiles/")
            continue()
        endif()
        if(_lvrs_asset_relpath MATCHES "(^|/)(CMakeCache\\.txt|cmake_install\\.cmake|Makefile)$")
            continue()
        endif()
        if(_lvrs_asset_relpath MATCHES "\\.(ninja|cmake)$")
            continue()
        endif()

        get_filename_component(_lvrs_asset_output_dir "${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_asset_relpath}" DIRECTORY)
        file(MAKE_DIRECTORY "${_lvrs_asset_output_dir}")
        execute_process(
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_lvrs_asset}" "${LVRS_EXPORT_OUTPUT_DIR}/${_lvrs_asset_relpath}"
            RESULT_VARIABLE _lvrs_export_copy_result
        )
        if(NOT _lvrs_export_copy_result EQUAL 0)
            _lvrs_export_fail("failed to copy WASM asset '${_lvrs_asset}'.")
        endif()
    endforeach()

    if(NOT _lvrs_wasm_entry_relpath STREQUAL "index.html")
        file(WRITE "${LVRS_EXPORT_OUTPUT_DIR}/index.html"
            "<!doctype html>\n"
            "<meta charset=\"utf-8\">\n"
            "<meta http-equiv=\"refresh\" content=\"0; url=${_lvrs_wasm_entry_relpath}\">\n"
            "<script>location.replace(\"${_lvrs_wasm_entry_relpath}\");</script>\n"
        )
    endif()

    file(WRITE "${LVRS_EXPORT_OUTPUT_DIR}/LVRSWasmArtifact.cmake"
        "set(LVRS_WASM_ENTRY_RELATIVE \"${_lvrs_wasm_entry_relpath}\")\n"
    )

    message(STATUS "LVRS bootstrap export: WASM site -> ${LVRS_EXPORT_OUTPUT_DIR}")
    message(STATUS "LVRS bootstrap export: WASM entry -> ${_lvrs_wasm_entry_relpath}")
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
