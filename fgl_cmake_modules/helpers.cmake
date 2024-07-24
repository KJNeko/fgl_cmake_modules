

function(PreSetup)
	PlatformPreSetup()
	CompilerPreSetup()
endfunction()

function(PostSetup)
	PlatformPostSetup()
	CompilerPostSetup()
endfunction()

function(AddFGLExecutable NAME SRC_SOURCES_LOCATION)
	file(GLOB_RECURSE CPP_SOURCES ${SRC_SOURCES_LOCATION}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES ${SRC_SOURCES_LOCATION}/**.hpp)
	add_executable(${NAME} ${CPP_SOURCES})
	target_include_directories(${NAME} PRIVATE ${HPP_SOURCES})
	SetFGLFlags(${NAME})
endfunction()

function(AddFGLLibrary NAME MODE SRC_SOURCES HEADER_SOURCES)
	file(GLOB_RECURSE CPP_SOURCES ${SRC_SOURCES}/**.cpp)
	file(GLOB_RECURSE HPP_SOURCES ${HEADER_SOURCES}/**.hpp)
	add_library(${NAME} ${MODE} ${CPP_SOURCES} ${HPP_SOURCES})
	target_include_directories(${NAME} PUBLIC ${HEADER_SOURCES})
	SetFGLFlags(${NAME})
endfunction()