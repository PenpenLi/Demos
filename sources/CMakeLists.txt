cmake_minimum_required(VERSION 2.6)

#solution name
project(Demos)

#set(CMAKE_CXX_COMPILER g++)
#output dirs
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/../lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${Demos_SOURCE_DIR}/../bin)

#include dirs
include_directories(
    ${Demos_SOURCE_DIR}/libXLLog4j
)

#lib dirs
link_directories(
    ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
)

#compile options
add_definitions(-g -Wall -O --std=c++11)

add_subdirectory(libXLLog4j)
add_subdirectory(ThriftDemo)
add_subdirectory(boost.general)
