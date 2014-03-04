file(GLOB ASIO_COMMON_INCS "./*.h")
file(GLOB ASIO_COMMON_SRCS "./*.cpp")

add_subdirectory(server)
add_subdirectory(client)