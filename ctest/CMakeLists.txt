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

#add_subdirectory(closure-conversion)
#add_subdirectory(full)
add_subdirectory(precompiled)
add_subdirectory(test-bad)
add_subdirectory(test-global-var)
