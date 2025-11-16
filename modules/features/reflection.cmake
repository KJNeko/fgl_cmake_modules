set(REFLECTION_SRC "${CMAKE_CURRENT_LIST_DIR}/reflection.cpp")

try_compile(HAS_CPP_REFLECTION
		${CMAKE_BINARY_DIR}          # build directory
		${REFLECTION_SRC}            # source file
		CMAKE_FLAGS "-DCMAKE_CXX_STANDARD=26"
		COMPILE_DEFINITIONS "-freflection"
)

if (HAS_CPP_REFLECTION)
	message(STATUS "Compiler supports C++ reflection")
else ()
	message(STATUS "Compiler does NOT support C++ reflection")
endif ()