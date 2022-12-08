add_artic_test(
    NAME exports-artic
    SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/exports.art ${CMAKE_CURRENT_SOURCE_DIR}/import.art
    REFERENCE ${CMAKE_CURRENT_SOURCE_DIR}/output.ref
)

add_anyopt_test(
    NAME exports-anyopt
    SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/exports.art ${CMAKE_CURRENT_SOURCE_DIR}/import.art
    REFERENCE ${CMAKE_CURRENT_SOURCE_DIR}/output.ref
)
