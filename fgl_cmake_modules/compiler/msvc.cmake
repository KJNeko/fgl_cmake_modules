function(CompilerPreSetup)
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

		set(FGL_FLAGS "${CMAKE_CXX_FLAGS}" PARENT_SCOPE)
		set(FGL_CHILD_FLAGS "${CMAKE_CXX_FLAGS}" PARENT_SCOPE)
	endif ()
endfunction()

function(CompilerPostSetup)

endfunction()
