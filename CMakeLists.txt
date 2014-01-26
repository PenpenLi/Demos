cmake_minimum_required(VERSION 2.8)

project(Demos)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/bin)

include_directories(${Demos_SOURCE_DIR}/libXLLog4j)
link_directories(${Demos_SOURCE_DIR}/lib)

add_subdirectory(libXLLog4j)
add_subdirectory(ThriftDemo)

