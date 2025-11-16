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

	target_compile_features(${NAME} PUBLIC cxx_std_26)
endfunction()

function(SplitDebugSymbols NAME)
	if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
		add_custom_command(TARGET ${NAME} POST_BUILD
				COMMAND ${CMAKE_OBJCOPY} --only-keep-debug $<TARGET_FILE:${NAME}> $<TARGET_FILE:${NAME}>.debug
				COMMAND ${CMAKE_STRIP} --strip-debug --strip-unneeded $<TARGET_FILE:${NAME}>
				COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=$<TARGET_FILE:${NAME}>.debug $<TARGET_FILE:${NAME}>
				COMMENT "Stripping symbols and creating ${NAME}.debug"
		)
	endif ()
endfunction()

function(AddFGLExecutable NAME SRC_SOURCES_LOCATION)
	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)

	file(GLOB_RECURSE UI_SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.ui)

	add_executable(${NAME} ${SOURCES})
	target_sources(${NAME} PUBLIC ${SOURCES})

	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} "")

	set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
	set_target_properties(${NAME} PROPERTIES CXX_STANDARD 23)
	set_target_properties(${NAME} PROPERTIES CXX_STANDARD_REQUIRED ON)
	SetFGLFlags(${NAME})
	AddGitInfo(${NAME})
	target_compile_definitions(${NAME} PRIVATE FGL_BUILD_TYPE="${CMAKE_BUILD_TYPE}")

	SplitDebugSymbols(${NAME})

endfunction()

function(AddFGLLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)

	file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
			${SRC_SOURCES_LOCATION}/**.cpp
			${SRC_SOURCES_LOCATION}/**.hpp
	)

	file(GLOB_RECURSE INCLUDE_HPP_SOURCES CONFIGURE_DEPENDS ${INCLUDE_SOURCES_LOCATION}/**.hpp)

	add_library(${NAME} ${MODE})
	target_sources(${NAME} PRIVATE ${SOURCES})

	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} ${INCLUDE_SOURCES_LOCATION})

	SetFGLFlags(${NAME})
	AddGitInfo(${NAME})
	target_compile_definitions(${NAME} PRIVATE FGL_BUILD_TYPE="${CMAKE_BUILD_TYPE}")

	if (NOT "${MODE}" STREQUAL "OBJECT")
		SplitDebugSymbols(${NAME})
	endif ()
endfunction()

function(AddFGLModule NAME SRC_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES CONFIGURE_DEPENDS ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES CONFIGURE_DEPENDS ${SRC_SOURCES_LOCATION}/**.hpp)
	add_library(${NAME} MODULE ${CPP_SOURCES} ${HPP_SOURCES})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	SetFGLFlags(${NAME})
	AddGitInfo(${NAME})
	target_compile_definitions(${NAME} PRIVATE FGL_BUILD_TYPE="${CMAKE_BUILD_TYPE}")

	SplitDebugSymbols(${NAME})
endfunction()

function(AddFGLChildLibrary NAME MODE SRC_SOURCES_LOCATION INCLUDE_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES ${SRC_SOURCES_LOCATION}/**.hpp)
	file(GLOB_RECURSE INCLUDE_HPP_SOURCES ${INCLUDE_SOURCES_LOCATION}/**.hpp)
	add_library(${NAME} ${MODE} ${CPP_SOURCES} ${HPP_SOURCES} ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PUBLIC ${INCLUDE_SOURCES_LOCATION})
	target_include_directories(${NAME} PRIVATE ${SRC_SOURCES_LOCATION})
	ConfigureFGLTarget(${NAME} ${SRC_SOURCES_LOCATION} ${INCLUDE_SOURCES_LOCATION})

	SplitDebugSymbols(${NAME})
endfunction()
