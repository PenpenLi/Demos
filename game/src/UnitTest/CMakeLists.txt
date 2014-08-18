file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

add_executable(RunUnitTest ${SRCS} ${INCS})

target_link_libraries(RunUnitTest
    gtest
    base
    log4cplus
    c++
)

add_dependencies(RunUnitTest gtest base)
