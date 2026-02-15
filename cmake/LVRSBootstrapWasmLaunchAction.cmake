cmake_minimum_required(VERSION 3.21)

function(_lvrs_wasm_launch_fail message_text)
    message(FATAL_ERROR "LVRS wasm launch: ${message_text}")
endfunction()

function(_lvrs_wasm_collect_html_candidates root_dir out_var)
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

if(NOT DEFINED LVRS_WASM_LAUNCH_SOURCE_DIR OR LVRS_WASM_LAUNCH_SOURCE_DIR STREQUAL "")
    _lvrs_wasm_launch_fail("LVRS_WASM_LAUNCH_SOURCE_DIR is required.")
endif()
if(NOT IS_DIRECTORY "${LVRS_WASM_LAUNCH_SOURCE_DIR}")
    _lvrs_wasm_launch_fail("source directory does not exist: ${LVRS_WASM_LAUNCH_SOURCE_DIR}")
endif()
if(NOT DEFINED LVRS_WASM_LAUNCH_TARGET)
    set(LVRS_WASM_LAUNCH_TARGET "")
endif()
if(NOT DEFINED LVRS_WASM_LAUNCH_HOST OR LVRS_WASM_LAUNCH_HOST STREQUAL "")
    set(LVRS_WASM_LAUNCH_HOST "127.0.0.1")
endif()
if(NOT DEFINED LVRS_WASM_LAUNCH_PORT OR LVRS_WASM_LAUNCH_PORT STREQUAL "")
    set(LVRS_WASM_LAUNCH_PORT "8000")
endif()
if(NOT LVRS_WASM_LAUNCH_PORT MATCHES "^[0-9]+$")
    _lvrs_wasm_launch_fail("LVRS_WASM_LAUNCH_PORT must be numeric: ${LVRS_WASM_LAUNCH_PORT}")
endif()
if(NOT DEFINED LVRS_WASM_LAUNCH_OPEN_BROWSER OR LVRS_WASM_LAUNCH_OPEN_BROWSER STREQUAL "")
    set(LVRS_WASM_LAUNCH_OPEN_BROWSER "ON")
endif()

set(_lvrs_wasm_entry_html "")
set(_lvrs_wasm_metadata_file "${LVRS_WASM_LAUNCH_SOURCE_DIR}/LVRSWasmArtifact.cmake")
if(EXISTS "${_lvrs_wasm_metadata_file}")
    include("${_lvrs_wasm_metadata_file}")
    if(DEFINED LVRS_WASM_ENTRY_HTML
       AND NOT LVRS_WASM_ENTRY_HTML STREQUAL ""
       AND EXISTS "${LVRS_WASM_ENTRY_HTML}")
        set(_lvrs_wasm_entry_html "${LVRS_WASM_ENTRY_HTML}")
    elseif(DEFINED LVRS_WASM_ENTRY_RELATIVE
           AND NOT LVRS_WASM_ENTRY_RELATIVE STREQUAL ""
           AND EXISTS "${LVRS_WASM_LAUNCH_SOURCE_DIR}/${LVRS_WASM_ENTRY_RELATIVE}")
        set(_lvrs_wasm_entry_html "${LVRS_WASM_LAUNCH_SOURCE_DIR}/${LVRS_WASM_ENTRY_RELATIVE}")
    endif()
    unset(LVRS_WASM_ENTRY_HTML)
    unset(LVRS_WASM_ENTRY_RELATIVE)
    unset(LVRS_WASM_ARTIFACT_DIR)
endif()

_lvrs_wasm_collect_html_candidates("${LVRS_WASM_LAUNCH_SOURCE_DIR}" _lvrs_wasm_html_candidates)
if(_lvrs_wasm_entry_html STREQUAL "")
    if(NOT LVRS_WASM_LAUNCH_TARGET STREQUAL "")
        foreach(_lvrs_candidate IN LISTS _lvrs_wasm_html_candidates)
            get_filename_component(_lvrs_candidate_name "${_lvrs_candidate}" NAME)
            if(_lvrs_candidate_name STREQUAL "${LVRS_WASM_LAUNCH_TARGET}.html")
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
    _lvrs_wasm_launch_fail("WASM HTML entry artifact was not found under '${LVRS_WASM_LAUNCH_SOURCE_DIR}'.")
endif()

file(RELATIVE_PATH _lvrs_wasm_entry_relpath "${LVRS_WASM_LAUNCH_SOURCE_DIR}" "${_lvrs_wasm_entry_html}")
if(_lvrs_wasm_entry_relpath MATCHES "^\\.\\./")
    _lvrs_wasm_launch_fail("WASM HTML entry is outside source directory: ${_lvrs_wasm_entry_html}")
endif()
string(REPLACE "\\" "/" _lvrs_wasm_entry_relpath "${_lvrs_wasm_entry_relpath}")
string(REPLACE " " "%20" _lvrs_wasm_entry_urlpath "${_lvrs_wasm_entry_relpath}")
set(_lvrs_wasm_url "http://${LVRS_WASM_LAUNCH_HOST}:${LVRS_WASM_LAUNCH_PORT}/${_lvrs_wasm_entry_urlpath}")

find_program(_lvrs_python NAMES python3 python)
if(NOT _lvrs_python)
    _lvrs_wasm_launch_fail("Python runtime was not found. Install python3 or set PATH.")
endif()

string(TOUPPER "${LVRS_WASM_LAUNCH_OPEN_BROWSER}" _lvrs_open_browser_upper)
if(NOT _lvrs_open_browser_upper MATCHES "^(0|OFF|NO|FALSE)$")
    execute_process(
        COMMAND "${_lvrs_python}" -m webbrowser -t "${_lvrs_wasm_url}"
        RESULT_VARIABLE _lvrs_open_browser_result
        OUTPUT_QUIET
        ERROR_QUIET
    )
    if(NOT _lvrs_open_browser_result EQUAL 0)
        message(STATUS "LVRS wasm launch: browser auto-open failed; open manually -> ${_lvrs_wasm_url}")
    endif()
endif()

message(STATUS "LVRS wasm launch: source -> ${LVRS_WASM_LAUNCH_SOURCE_DIR}")
message(STATUS "LVRS wasm launch: entry  -> ${_lvrs_wasm_entry_relpath}")
message(STATUS "LVRS wasm launch: URL    -> ${_lvrs_wasm_url}")
message(STATUS "LVRS wasm launch: press Ctrl+C to stop the server.")

execute_process(
    COMMAND "${_lvrs_python}" -m http.server "${LVRS_WASM_LAUNCH_PORT}" --bind "${LVRS_WASM_LAUNCH_HOST}"
    WORKING_DIRECTORY "${LVRS_WASM_LAUNCH_SOURCE_DIR}"
    RESULT_VARIABLE _lvrs_serve_result
    COMMAND_ECHO STDOUT
)
if(NOT _lvrs_serve_result EQUAL 0)
    _lvrs_wasm_launch_fail("static server exited with code ${_lvrs_serve_result}.")
endif()
