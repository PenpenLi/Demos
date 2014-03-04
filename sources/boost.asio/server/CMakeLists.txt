set(TARGETNAME BoostAsioServer)

file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

include_directories(
    ..
)

add_executable(${TARGETNAME} ${SRCS} ${INCS} ${ASIO_COMMON_SRCS} ${ASIO_COMMON_INCS})

target_link_libraries(
    ${TARGETNAME}
    XLLoger
    log4cplus
    boost_system
    boost_thread
    boost_date_time
)
