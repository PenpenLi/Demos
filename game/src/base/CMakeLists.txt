file(GLOB SRCS "./*.cpp")
file(GLOB INCS "./*.h")

#add_definitions(-fPIC)

add_library(base STATIC ${SRCS} ${INCS})

