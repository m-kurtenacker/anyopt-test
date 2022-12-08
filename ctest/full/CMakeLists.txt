add_artic_test(
    NAME full-artic
    SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/full.art ${CMAKE_CURRENT_SOURCE_DIR}/exports.art
    ARGS 44
    REFERENCE ${CMAKE_CURRENT_SOURCE_DIR}/output.ref
)

add_anyopt_test(
    NAME full-anyopt
    SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/full.art ${CMAKE_CURRENT_SOURCE_DIR}/exports.art
    ARGS 44
    REFERENCE ${CMAKE_CURRENT_SOURCE_DIR}/output.ref
)
