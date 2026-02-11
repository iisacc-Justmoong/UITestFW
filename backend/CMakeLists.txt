set(UIFRAMEWORK_BACKEND_SOURCES
    ${CMAKE_CURRENT_LIST_DIR}/io/backend.cpp
    ${CMAKE_CURRENT_LIST_DIR}/fonts/fontpolicy.cpp
    ${CMAKE_CURRENT_LIST_DIR}/runtime/renderquality.cpp
    ${CMAKE_CURRENT_LIST_DIR}/runtime/runtimeevents.cpp
    ${CMAKE_CURRENT_LIST_DIR}/platform/platforminfo.cpp
    ${CMAKE_CURRENT_LIST_DIR}/runtime/renderingmonitor.cpp
    ${CMAKE_CURRENT_LIST_DIR}/navigation/pagemonitor.cpp
    ${CMAKE_CURRENT_LIST_DIR}/state/viewmodelregistry.cpp
    ${CMAKE_CURRENT_LIST_DIR}/runtime/debuglogger.cpp
    ${CMAKE_CURRENT_LIST_DIR}/graphics/svgmanager.cpp
    ${CMAKE_CURRENT_LIST_DIR}/text/textmarkup.cpp
)

set(UIFRAMEWORK_BACKEND_HEADERS
    ${CMAKE_CURRENT_LIST_DIR}/io/backend.h
    ${CMAKE_CURRENT_LIST_DIR}/fonts/fontpolicy.h
    ${CMAKE_CURRENT_LIST_DIR}/runtime/renderquality.h
    ${CMAKE_CURRENT_LIST_DIR}/runtime/runtimeevents.h
    ${CMAKE_CURRENT_LIST_DIR}/platform/platforminfo.h
    ${CMAKE_CURRENT_LIST_DIR}/runtime/renderingmonitor.h
    ${CMAKE_CURRENT_LIST_DIR}/navigation/pagemonitor.h
    ${CMAKE_CURRENT_LIST_DIR}/state/viewmodelregistry.h
    ${CMAKE_CURRENT_LIST_DIR}/runtime/debuglogger.h
    ${CMAKE_CURRENT_LIST_DIR}/graphics/svgmanager.h
    ${CMAKE_CURRENT_LIST_DIR}/text/textmarkup.h
)

if(APPLE)
    list(APPEND UIFRAMEWORK_BACKEND_SOURCES
        ${CMAKE_CURRENT_LIST_DIR}/platform/nativewindowstyle.mm
    )
else()
    list(APPEND UIFRAMEWORK_BACKEND_SOURCES
        ${CMAKE_CURRENT_LIST_DIR}/platform/nativewindowstyle.cpp
    )
endif()

list(APPEND UIFRAMEWORK_BACKEND_HEADERS
    ${CMAKE_CURRENT_LIST_DIR}/platform/nativewindowstyle.h
)
