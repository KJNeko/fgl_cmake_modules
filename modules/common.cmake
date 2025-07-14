

include(helpers)
include(git/commit)

if ((${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU") OR (${CMAKE_CXX_PLATFORM_ID} STREQUAL "MinGW"))
	include(compiler/gcc)
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
	include(compiler/clang)
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "MSVC")
	message()
	include(compiler/msvc)
endif ()

if ((WIN32))
	message(DEBUG "Compiling for Windows")
	include(os/win32)
elseif (APPLE)
	message(DEBUG "Compiling for Apple")
	include(os/apple)
elseif (UNIX)
	message(DEBUG "Compiling for Unix")
	include(os/linux)
else ()
	message(DEBUG "Unknown Platform")
endif ()

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/dependencies" ${CMAKE_MODULE_PATH})

message(DEBUG "Leaving ${CMAKE_CURRENT_LIST_FILE}")
