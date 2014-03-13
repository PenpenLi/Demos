include_directories(
    ${Demos_SOURCE_DIR}/gtest/include
    ${Demos_SOURCE_DIR}/boost.asio
)

file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

add_executable(RunUnitTest ${SRCS} ${INCS})

target_link_libraries(RunUnitTest
    gtest
    common
    log4cplus
    pthread
    boost_system
    boost_thread
    common
    curl
)
