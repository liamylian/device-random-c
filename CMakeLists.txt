cmake_minimum_required(VERSION 3.0)
project(device_random LANGUAGES C)

# Package support
set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

# Versioning
file (STRINGS ${CMAKE_SOURCE_DIR}/VERSION MODBUS_DOT_VERSION)

# Libraries
find_package (LIBCSDK REQUIRED)
if (NOT LIBCSDK_FOUND)
  message (WARNING "csdk library or header not found")
endif ()

# Set additional C compiler flags
if (DEFINED CMAKE_C_COMPILER_ID)
  if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wstrict-prototypes -Wmissing-prototypes")
    set (CMAKE_C_STANDARD 99)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE")
    set (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -ggdb -O0")
    set (CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -ggdb -O0")
    set (CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2 -DNDEBUG")
    set (CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -O2")
   endif ()
endif ()

file (GLOB C_FILES *.c)
find_library(EDGEX_CSDK_RELEASE_LIB NAMES csdk)
add_executable(device-random ${C_FILES})
target_compile_definitions(device-random PRIVATE VERSION="${MODBUS_DOT_VERSION}")
target_include_directories (device-random PRIVATE .)
target_link_libraries (device-random PUBLIC m PRIVATE ${EDGEX_CSDK_RELEASE_LIB})
install(TARGETS device-random DESTINATION bin)
