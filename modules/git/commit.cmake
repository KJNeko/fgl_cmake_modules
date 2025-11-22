function(getCommitHash OUTPUT_VARIABLE)
	find_package(Git QUIET)
	if (GIT_FOUND)
		execute_process(
				COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE GIT_HASH
				ERROR_VARIABLE GIT_ERROR
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)
		if (NOT GIT_ERROR)
			set(${OUTPUT_VARIABLE} ${GIT_HASH} PARENT_SCOPE)
		else ()
			set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
		endif ()
	else ()
		set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
	endif ()
endfunction()

function(getBranchName OUTPUT_VARIABLE)
	find_package(Git QUIET)
	if (GIT_FOUND)
		execute_process(
				COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE GIT_BRANCH
				ERROR_VARIABLE GIT_ERROR
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)
		if (NOT GIT_ERROR)
			set(${OUTPUT_VARIABLE} ${GIT_BRANCH} PARENT_SCOPE)
		else ()
			set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
		endif ()
	else ()
		set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
	endif ()
endfunction()

function(getGitTag OUTPUT_VARIABLE)
	find_package(Git QUIET)
	if (GIT_FOUND)
		execute_process(
				COMMAND ${GIT_EXECUTABLE} describe --tags --always
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE GIT_TAG
				ERROR_VARIABLE GIT_ERROR
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)
		if (NOT GIT_ERROR)
			set(${OUTPUT_VARIABLE} ${GIT_TAG} PARENT_SCOPE)
		else ()
			set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
		endif ()
	else ()
		set(${OUTPUT_VARIABLE} "unknown" PARENT_SCOPE)
	endif ()
endfunction()

function(addGitCommitDefine TARGET)
	getCommitHash(GIT_HASH)
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_COMMIT="${GIT_HASH}")
endfunction()

function(addGitBranchDefine TARGET)
	getBranchName(GIT_BRANCH)
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_BRANCH="${GIT_BRANCH}")
endfunction()


function(getIsDirty OUTPUT_VARIABLE)
	find_package(Git QUIET)
	if (GIT_FOUND)
		execute_process(
				COMMAND ${GIT_EXECUTABLE} status --porcelain
				WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				OUTPUT_VARIABLE GIT_STATUS
				ERROR_VARIABLE GIT_ERROR
				OUTPUT_STRIP_TRAILING_WHITESPACE
				ERROR_STRIP_TRAILING_WHITESPACE
		)
		if (NOT GIT_ERROR)
			if (GIT_STATUS)
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

function(addGitDirtyDefine TARGET)
	getIsDirty(GIT_DIRTY)
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_DIRTY=${GIT_DIRTY})
	target_compile_definitions(${TARGET} PRIVATE FGL_GIT_IS_DIRTY=1)
endfunction()

include(modules/git/tag.cmake)

function(AddGitInfo TARGET)
	addGitCommitDefine(${TARGET})
	addGitBranchDefine(${TARGET})
	addGitDirtyDefine(${TARGET})
	addGitTagDefine(${TARGET})
	addGitUnsyncedDefine(${TARGET})
endfunction()
