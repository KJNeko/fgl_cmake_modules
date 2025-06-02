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


function(ConfigureFGLTarget NAME SRC_DIR INCLUDE_DIR)
	if (INCLUDE_DIR)
		target_include_directories(${NAME} PUBLIC ${INCLUDE_DIR})
	endif ()

	target_include_directories(${NAME} PRIVATE ${SRC_DIR})
	if (DEFINED FGL_STRICT_WARNINGS AND FGL_STRICT_WARNINGS)
		target_compile_definitions(${NAME} PUBLIC "-DFGL_STRICT_WARNINGS=1")
	endif ()

	set_target_properties(${NAME} PROPERTIES CXX_MODULE_STD 1)
	target_compile_features(${NAME} PUBLIC cxx_std_23)
endfunction()

function(AddFGLExecutable NAME SRC_SOURCES_LOCATION)
	file(GLOB_RECURSE M_SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cppm)

	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)

	add_executable(${NAME} ${SOURCES})
	target_sources(${NAME} PUBLIC ${SOURCES})
	target_sources(${NAME} PUBLIC FILE_SET modules TYPE CXX_MODULES FILES ${M_SOURCES})

	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} "")

	set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
endfunction()

function(AddFGLLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)

	file(GLOB_RECURSE M_SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cppm)

	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)

	file(GLOB_RECURSE INCLUDE_MODULE_SOURCES CONFIGURE_DEPENDS ${INCLUDE_SOURCES_LOCATION}/**.cppm)
	file(GLOB_RECURSE INCLUDE_HPP_SOURCES CONFIGURE_DEPENDS ${INCLUDE_SOURCES_LOCATION}/**.hpp)

	add_library(${NAME} ${MODE})
	target_sources(${NAME} PUBLIC ${SOURCES})
	target_sources(${NAME} PUBLIC FILE_SET modules TYPE CXX_MODULES FILES ${INCLUDE_MODULE_SOURCES})

	message("=== ${NAME} sources ${SOURCES}")
	message("=== ${NAME} sources ${M_SOURCES}")
	message("=== ${NAME} sources ${INCLUDE_MODULE_SOURCES}")
	message("=== ${NAME} sources ${INCLUDE_HPP_SOURCES}")

	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} ${INCLUDE_SOURCES_LOCATION})

	SetFGLFlags(${NAME})
endfunction()

function(AddFGLChildLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES ${SRC_SOURCES_LOCATION}/**.hpp)
	file(GLOB_RECURSE INCLUDE_HPP_SOURCES ${INCLUDE_SOURCES_LOCATION}/**.hpp)
	add_library(${NAME} ${MODE} ${CPP_SOURCES} ${HPP_SOURCES} ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PUBLIC ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} ${INCLUDE_SOURCES_LOCATION})
endfunction()
