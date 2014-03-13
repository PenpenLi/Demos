set(TARGETNAME BoostGeneralDemo)

file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

add_executable(${TARGETNAME} ${SRCS} ${INCS})

target_link_libraries(
    ${TARGETNAME}
    common
    log4cplus
    boost_system
    boost_thread
    boost_date_time
)
