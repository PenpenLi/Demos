cmake_minimum_required(VERSION 2.8)

include_directories("${CMAKE_CURRENT_LIST_DIR}/thrift/gen-cpp")

file(GLOB THRIFT_SRC "${CMAKE_CURRENT_LIST_DIR}/thrift/gen-cpp/*.cpp")

set(SERVER_SRC
    echoserver.cpp
    ${THRIFT_SRC}
    )
add_executable(echoserver ${SERVER_SRC})
target_link_libraries(echoserver XLLoger thrift log4cplus)

set(CLIENT_SRC
    echoclient.cpp
    ${THRIFT_SRC}
    )
add_executable(echoclient ${CLIENT_SRC})
target_link_libraries(echoclient XLLoger thrift log4cplus)
