file(GLOB SRCS "./src/gtest-all.cc")
file(GLOB INCS "./include/gtest/*.h" "./include/gtest/internal/*.h")

include_directories(
	.
    ./include
)

add_library(gtest STATIC ${SRCS} ${INCS})

