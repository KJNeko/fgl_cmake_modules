

function(PreSetup)
	PlatformPreSetup()
	CompilerPreSetup()

	set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/dependencies" ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endfunction()

function(PostSetup)
	PlatformPostSetup()
	CompilerPostSetup()
endfunction()

function(AddFGLExecutable NAME SRC_SOURCES_LOCATION)
	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)
	add_executable(${NAME} ${SOURCES})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
	SetFGLFlags(${NAME})
endfunction()

function(AddFGLLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES CONFIGURE_DEPENDS ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES CONFIGURE_DEPENDS ${SRC_SOURCES_LOCATION}/**.hpp)
	file(GLOB_RECURSE INCLUDE_HPP_SOURCES CONFIGURE_DEPENDS ${INCLUDE_SOURCES_LOCATION}/**.hpp)
	add_library(${NAME} ${MODE} ${CPP_SOURCES} ${HPP_SOURCES} ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PUBLIC ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	SetFGLFlags(${NAME})
endfunction()