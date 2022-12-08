add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/test_exports-artic
    COMMAND $<TARGET_FILE:artic> ${CMAKE_CURRENT_SOURCE_DIR}/exports.art ${CMAKE_CURRENT_SOURCE_DIR}/import.art --emit-llvm -o test_exports-artic
    COMMAND $<TARGET_FILE:clang> test_exports-artic.ll -o test_exports-artic
    DEPENDS artic clang ${CMAKE_CURRENT_SOURCE_DIR}/exports.art ${CMAKE_CURRENT_SOURCE_DIR}/import.art
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/exports.thorin.json
    COMMAND $<TARGET_FILE:artic> ${CMAKE_CURRENT_SOURCE_DIR}/exports.art --emit-json -o exports
    DEPENDS artic ${CMAKE_CURRENT_SOURCE_DIR}/exports.art
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/import.thorin.json
    COMMAND $<TARGET_FILE:artic> ${CMAKE_CURRENT_SOURCE_DIR}/import.art --emit-json -o import
    DEPENDS artic ${CMAKE_CURRENT_SOURCE_DIR}/import.art
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/test_exports-anyopt
    COMMAND $<TARGET_FILE:anyopt> exports.thorin.json import.thorin.json --emit-llvm -o test_exports-anyopt
    COMMAND $<TARGET_FILE:clang> test_exports-anyopt.ll -o test_exports-anyopt
    DEPENDS anyopt clang exports.thorin.json import.thorin.json
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


add_custom_target(test_target_exports-artic ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/test_exports-artic)
add_custom_target(test_target_exports-anyopt ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/test_exports-anyopt)


add_test(NAME exports-artic
    COMMAND
        ${CMAKE_COMMAND}
        "-DTEST_NAME=exports-artic"
        "-DTEST_EXECUTABLE=${CMAKE_CURRENT_BINARY_DIR}/test_exports-artic"
        "-DTEST_REFERENCE=${CMAKE_CURRENT_SOURCE_DIR}/output.ref"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_test(NAME exports-anyopt
    COMMAND
        ${CMAKE_COMMAND}
        "-DTEST_NAME=exports-anyopt"
        "-DTEST_EXECUTABLE=${CMAKE_CURRENT_BINARY_DIR}/test_exports-anyopt"
        "-DTEST_REFERENCE=${CMAKE_CURRENT_SOURCE_DIR}/output.ref"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
