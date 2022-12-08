cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
project(opti-test)

include(CTest)

find_package(AnyDSL_runtime REQUIRED)
include_directories(${AnyDSL_runtime_INCLUDE_DIRS})

function (add_failure_test)
    cmake_parse_arguments(test "" "NAME" "COMMAND" ${ARGN})
    add_test(NAME ${test_NAME} COMMAND ${test_COMMAND})
    set_tests_properties(${test_NAME} PROPERTIES WILL_FAIL TRUE)
endfunction()

function (add_artic_test)
    cmake_parse_arguments(test "" "NAME;REFERENCE" "SOURCE_FILES;ARGS" ${ARGN})

    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME}
        COMMAND $<TARGET_FILE:artic> ${test_SOURCE_FILES} --emit-llvm -o test_${test_NAME}
        COMMAND $<TARGET_FILE:clang> test_${test_NAME}.ll -o test_${test_NAME}
        DEPENDS artic clang ${test_SOURCE_FILES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )

    add_custom_target(test_target_${test_NAME} ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME})

    add_test(NAME ${test_NAME}
        COMMAND
            ${CMAKE_COMMAND}
            "-DTEST_NAME=${test_NAME}"
            "-DTEST_EXECUTABLE=${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME}"
            "-DTEST_REFERENCE=${test_REFERENCE}"
            "-DTEST_ARGS=${test_ARGS}"
            -P ${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endfunction()

function (add_anyopt_test)
    cmake_parse_arguments(test "" "NAME;REFERENCE" "SOURCE_FILES;ARGS" ${ARGN})

    set(_json_files "")

    foreach(_it ${test_SOURCE_FILES})
        get_filename_component(_it_file ${_it} NAME_WE)

        add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/test_${_it_file}.thorin.json
            COMMAND $<TARGET_FILE:artic> ${_it} --emit-json -o test_${_it_file}
            DEPENDS artic ${_it}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

        list(APPEND _json_files "${CMAKE_CURRENT_BINARY_DIR}/test_${_it_file}.thorin.json")
    endforeach()

    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME}
        COMMAND $<TARGET_FILE:anyopt> ${_json_files} --emit-llvm -o test_${test_NAME}
        COMMAND $<TARGET_FILE:clang> test_${test_NAME}.ll -o test_${test_NAME}
        DEPENDS anyopt clang ${_json_files}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )

    add_custom_target(test_target_${test_NAME} ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME})

    add_test(NAME ${test_NAME}
        COMMAND
            ${CMAKE_COMMAND}
            "-DTEST_NAME=${test_NAME}"
            "-DTEST_EXECUTABLE=${CMAKE_CURRENT_BINARY_DIR}/test_${test_NAME}"
            "-DTEST_REFERENCE=${test_REFERENCE}"
            "-DTEST_ARGS=${test_ARGS}"
            -P ${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
endfunction()

#add_subdirectory(closure-conversion)
add_subdirectory(full)
add_subdirectory(precompiled)
add_subdirectory(test-bad)
add_subdirectory(test-global-var)
