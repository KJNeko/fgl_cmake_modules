		function(AppendWarningFlag FLAG_TEXT)
			set(LIST ${FGL_WARNINGS})
			list(APPEND LIST ${FLAG_TEXT})
			set(FGL_WARNINGS ${LIST} PARENT_SCOPE)
		endfunction()

		function(SetFGLFlags TARGET)
			GET_PROPERTY(FGL_FLAGS GLOBAL PROPERTY FGL_FLAGS)
			target_compile_options(${TARGET} PUBLIC ${FGL_FLAGS})
			message("Set target ${TARGET} to use flags\n${FGL_FLAGS}")
		endfunction()

		function(SetDependencyFlags TARGET)
			GET_PROPERTY(FGL_CHILD_FLAGS GLOBAL PROPERTY FGL_CHILD_FLAGS)
			target_compile_options(${TARGET} PUBLIC ${FGL_CHILD_FLAGS})
			message("Set dependency ${TARGET} to use flags\n${FGL_CHILD_FLAGS}")
		endfunction()