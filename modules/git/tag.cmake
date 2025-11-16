function(getGitTagVersion)
	execute_process(
			COMMAND git describe --tags --abbrev=0
			WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
			OUTPUT_VARIABLE GIT_TAG_VERSION
			OUTPUT_STRIP_TRAILING_WHITESPACE
			ERROR_QUIET
	)

	if (NOT GIT_TAG_VERSION)
		set(GIT_TAG_VERSION "v0.0.0")
	endif ()

	string(REGEX MATCH "v?([0-9]+)\\.([0-9]+)\\.([0-9]+)" _ ${GIT_TAG_VERSION})
	if (CMAKE_MATCH_1)
		set(VERSION_MAJOR ${CMAKE_MATCH_1})
	else ()
		set(VERSION_MAJOR 0)
	endif ()
	if (CMAKE_MATCH_2)
		set(VERSION_MINOR ${CMAKE_MATCH_2})
	else ()
		set(VERSION_MINOR 0)
	endif ()
	if (CMAKE_MATCH_3)
		set(VERSION_PATCH ${CMAKE_MATCH_3})
	else ()
		set(VERSION_PATCH 0)
	endif ()

	set(GIT_TAG_VERSION ${GIT_TAG_VERSION} PARENT_SCOPE)
	set(VERSION_MAJOR ${VERSION_MAJOR} PARENT_SCOPE)
	set(VERSION_MINOR ${VERSION_MINOR} PARENT_SCOPE)
	set(VERSION_PATCH ${VERSION_PATCH} PARENT_SCOPE)
endfunction()

function(setGitTagVersionDefines TARGET)
	getGitTagVersion()

	message("Adding version info to ${TARGET}")

	target_compile_definitions(${TARGET} PUBLIC
			${TARGET}_MAJOR_VERSION=${VERSION_MAJOR}
			${TARGET}_MINOR_VERSION=${VERSION_MINOR}
			${TARGET}_PATCH_VERSION=${VERSION_PATCH}
	)
endfunction()

function(addGitTagDefine TARGET)
	getGitTag(GIT_TAG)
	setGitTagVersionDefines(${TARGET})
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_TAG="${GIT_TAG}")
endfunction()

function(getIsUnsynced OUTPUT_VARIABLE)
	find_package(Git QUIET)
	if (GIT_FOUND)
		# Get the commit hash of the latest tag
		execute_process(
				COMMAND ${GIT_EXECUTABLE} rev-list -n 1 $ (${GIT_EXECUTABLE} describe --tags --abbrev=0)
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE TAG_COMMIT
				ERROR_VARIABLE GIT_ERROR
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)

		# Get the current commit hash
		execute_process(
				COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE CURRENT_COMMIT
				ERROR_VARIABLE GIT_ERROR2
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)

		if (NOT GIT_ERROR AND NOT GIT_ERROR2)
			if (NOT "${CURRENT_COMMIT}" STREQUAL "${TAG_COMMIT}")
				set(${OUTPUT_VARIABLE} "1" PARENT_SCOPE)
			else ()
				set(${OUTPUT_VARIABLE} "0" PARENT_SCOPE)
			endif ()
		else ()
			set(${OUTPUT_VARIABLE} "-1" PARENT_SCOPE)
		endif ()
	else ()
		set(${OUTPUT_VARIABLE} "-1" PARENT_SCOPE)
	endif ()
endfunction()

function(addGitUnsyncedDefine TARGET)
	getIsUnsynced(GIT_UNSYNCED)
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_UNSYNCED=${GIT_UNSYNCED})
endfunction()