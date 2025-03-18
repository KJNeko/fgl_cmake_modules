cmake_minimum_required(VERSION 3.28)

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
	set(CMAKE_CXX_STANDARD 23)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	file(GLOB_RECURSE M_SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cppm)

	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)

	message("Compiling ${NAME} WITH ${M_SOURCES} as modules")

	add_executable(${NAME})
	target_sources(${NAME} PUBLIC ${SOURCES})
	target_sources(${NAME} PUBLIC FILE_SET modules TYPE CXX_MODULES FILES ${M_SOURCES})

	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	target_link_libraries(${NAME} PRIVATE ${NAME}_MODULES)
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

function(AddFGLChildLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES ${SRC_SOURCES_LOCATION}/**.hpp)
	file(GLOB_RECURSE INCLUDE_HPP_SOURCES ${INCLUDE_SOURCES_LOCATION}/**.hpp)
	add_library(${NAME} ${MODE} ${CPP_SOURCES} ${HPP_SOURCES} ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PUBLIC ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	#	SetFGLFlags(${NAME})
endfunction()
