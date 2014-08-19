set(TARGETNAME Client)

file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

include_directories(
    ${PROTO_CPP_DIR}
)

add_executable(${TARGETNAME}
    ${SRCS} ${INCS}
    ${ASIO_COMMON_SRCS} ${ASIO_COMMON_INCS}
    ${PROTO_SRCS} ${PROTO_INCS}
)

target_link_libraries(
    ${TARGETNAME}
    base
    log4cplus
    boost_system
    boost_thread
    boost_date_time
    protobuf
    boost_program_options
)
