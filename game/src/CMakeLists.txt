cmake_minimum_required(VERSION 2.6)

# todo(lxb): cross platforms
set(CMAKE_CONFIGURATION_TYPES Debug;Release)
#set(CMAKE_OSX_DEPLOYMENT_TARGET 10.7)
set(CMAKE_OSX_ARCHITECTURES x86_64)

#output dirs
# First for the generic no-config case (e.g. with mingw)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${game_SOURCE_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${game_SOURCE_DIR}/../lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${game_SOURCE_DIR}/../bin)
# Second, for multi-config builds (e.g. msvc)
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${game_SOURCE_DIR}/../bin)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${game_SOURCE_DIR}/../lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${game_SOURCE_DIR}/../lib)
endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )

set(3RD_DIR ${game_SOURCE_DIR}/3rd)

# todo(lxb): cross platform
#include dirs
include_directories(
    ${game_SOURCE_DIR}/base
    ${3RD_DIR}/gtest/include
    /usr/local/include
)

#lib dirs
link_directories(
    ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    /usr/local/lib
)

#proto code
set(PROTO_CPP_DIR ${game_SOURCE_DIR}/ProtocolBuffer/cpp)
file(GLOB PROTO_INCS "${PROTO_CPP_DIR}/*.h")
file(GLOB PROTO_SRCS "${PROTO_CPP_DIR}/*.cc")

#compile options
add_definitions(
    -std=c++11
    -stdlib=libc++
    -v
)

# solution name
project(game)

# subdirs
add_subdirectory(3rd)
add_subdirectory(base)
add_subdirectory(UnitTest)
