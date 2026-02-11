function(uifw_add_test test_name test_source)
    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name}
        PRIVATE
            Qt6::Test
            Qt6::Quick
            Qt6::QuickControls2
            UIFramework
            UIFrameworkplugin
            UIFrameworkplugin_init
    )
    add_test(NAME ${test_name} COMMAND ${test_name})
    set_tests_properties(${test_name} PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_CONTROLS_STYLE=Basic"
    )
endfunction()

uifw_add_test(UIFrameworkTests_layout tst_layout.cpp)
uifw_add_test(UIFrameworkTests_eventlistener tst_eventlistener.cpp)
uifw_add_test(UIFrameworkTests_examples tst_examples.cpp)
uifw_add_test(UIFrameworkTests_debug tst_debug.cpp)
uifw_add_test(UIFrameworkTests_import_api tst_import_api.cpp)
uifw_add_test(UIFrameworkTests_runtimeevents tst_runtimeevents.cpp)
uifw_add_test(UIFrameworkTests_backend_io tst_backend_io.cpp)
uifw_add_test(UIFrameworkTests_render_quality tst_render_quality.cpp)
uifw_add_test(UIFrameworkTests_font_policy tst_font_policy.cpp)
uifw_add_test(UIFrameworkTests_navigation_state tst_navigation_state.cpp)
uifw_add_test(UIFrameworkTests_runtime_services tst_runtime_services.cpp)
uifw_add_test(UIFrameworkTests_svg_manager tst_svg_manager.cpp)
uifw_add_test(UIFrameworkTests_platform_integration tst_platform_integration.cpp)
uifw_add_test(UIFrameworkTests_page_router tst_page_router.cpp)
uifw_add_test(UIFrameworkTests_code_editor tst_code_editor.cpp)
uifw_add_test(UIFrameworkTests_text_editor tst_text_editor.cpp)
uifw_add_test(UIFrameworkTests_text_markup tst_text_markup.cpp)
