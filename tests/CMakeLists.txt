function(uifw_add_test test_name test_source)
    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name}
        PRIVATE
            Qt6::Test
            Qt6::Quick
            Qt6::QuickControls2
            LVRSCore
    )
    if(LVRS_STATIC_QML_PLUGIN_REQUIRED)
        target_link_libraries(${test_name}
            PRIVATE
                LVRSplugin
                LVRSplugin_init
        )
    endif()
    add_test(NAME ${test_name} COMMAND ${test_name})
    set_tests_properties(${test_name} PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_CONTROLS_STYLE=Basic"
    )
endfunction()

uifw_add_test(LVRSTests_layout tst_layout.cpp)
uifw_add_test(LVRSTests_eventlistener tst_eventlistener.cpp)
uifw_add_test(LVRSTests_examples tst_examples.cpp)
uifw_add_test(LVRSTests_debug tst_debug.cpp)
uifw_add_test(LVRSTests_import_api tst_import_api.cpp)
uifw_add_test(LVRSTests_runtimeevents tst_runtimeevents.cpp)
uifw_add_test(LVRSTests_backend_io tst_backend_io.cpp)
uifw_add_test(LVRSTests_app_state tst_app_state.cpp)
uifw_add_test(LVRSTests_render_quality tst_render_quality.cpp)
uifw_add_test(LVRSTests_font_policy tst_font_policy.cpp)
uifw_add_test(LVRSTests_navigation_state tst_navigation_state.cpp)
uifw_add_test(LVRSTests_runtime_services tst_runtime_services.cpp)
uifw_add_test(LVRSTests_svg_manager tst_svg_manager.cpp)
uifw_add_test(LVRSTests_platform_integration tst_platform_integration.cpp)
uifw_add_test(LVRSTests_page_router tst_page_router.cpp)
uifw_add_test(LVRSTests_code_editor tst_code_editor.cpp)
uifw_add_test(LVRSTests_text_editor tst_text_editor.cpp)
uifw_add_test(LVRSTests_text_markup tst_text_markup.cpp)
