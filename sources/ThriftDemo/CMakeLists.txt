include_directories("${CMAKE_CURRENT_LIST_DIR}/thrift/gen-cpp")

#file(GLOB THRIFT_SRC "${CMAKE_CURRENT_LIST_DIR}/thrift/gen-cpp/*.cpp")
set(THRIFT_SRC
    thrift/gen-cpp/EchoServer.cpp
    thrift/gen-cpp/EchoServer_constants.cpp
    thrift/gen-cpp/EchoServer_types.cpp
    thrift/gen-cpp/EchoServer.h
    thrift/gen-cpp/EchoServer_constants.h
    thrift/gen-cpp/EchoServer_types.h
)

set(SERVER_SRC
    echoserver.cpp
    ${THRIFT_SRC}
    )
add_executable(echoserver ${SERVER_SRC})
target_link_libraries(echoserver
    common
    thrift
    thriftnb
    log4cplus
    boost_system
    boost_thread
    event
)

set(CLIENT_SRC
    echoclient.cpp
    ${THRIFT_SRC}
    )
add_executable(echoclient ${CLIENT_SRC})
target_link_libraries(echoclient
    common
    thrift
    log4cplus
    boost_system
    boost_thread
)
