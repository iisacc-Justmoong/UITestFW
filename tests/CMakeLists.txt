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
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen"
    )
endfunction()

uifw_add_test(UIFrameworkTests_layout tst_layout.cpp)
uifw_add_test(UIFrameworkTests_eventlistener tst_eventlistener.cpp)
uifw_add_test(UIFrameworkTests_examples tst_examples.cpp)
uifw_add_test(UIFrameworkTests_debug tst_debug.cpp)
