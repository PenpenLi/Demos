set(TARGETNAME BoostAsioClient)

file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

include_directories(
    ..
)

add_executable(${TARGETNAME} ${SRCS} ${INCS})

target_link_libraries(
    ${TARGETNAME}
    XLLoger
    log4cplus
    boost_system
    boost_thread
    boost_date_time
)
