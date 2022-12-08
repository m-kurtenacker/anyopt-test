cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

project(opti-test CXX)

find_package(AnyDSL_runtime REQUIRED)
include_directories(${AnyDSL_runtime_INCLUDE_DIRS})

anydsl_runtime_wrap(MAIN_PROGRAM
    FRONTEND artic
    NAME opti-test
    ARTIC_FLAGS --log-level info --max-errors 5
    FILES full.art)

add_executable(main ${MAIN_PROGRAM})
target_link_libraries(main ${AnyDSL_runtime_LIBRARIES})
