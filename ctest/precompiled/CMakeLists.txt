add_test(NAME precompiled-test COMMAND anyopt --emit-thorin ${CMAKE_CURRENT_SOURCE_DIR}/test.json) 
add_test(NAME precompiled-main COMMAND anyopt --emit-thorin ${CMAKE_CURRENT_SOURCE_DIR}/main.json) 
