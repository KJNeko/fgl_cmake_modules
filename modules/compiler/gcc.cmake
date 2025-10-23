
        include(compiler/flags)

		function(CompilerPreSetup)
			if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
				#These two flags added with older gcc versions and Qt causes a compiler segfault -Wmismatched-tags -Wredundant-tags
				# STL has some warnings that prevent -Werror level compilation "-Wnull-dereference"

				# Generic warnings.
				#set(FGL_WARNINGS "-Wall;-Wundef;-Wextra;-Wpedantic")


				AppendWarningFlag("-Wall")
				AppendWarningFlag("-Wundef")
				AppendWarningFlag("-Wextra")
				AppendWarningFlag("-Wpedantic")

				#AppendWarningFlag("-Wno-changes-meaning") # Prevents accidently changing the type of things. Cannot define 1 things as another later
				AppendWarningFlag("-Wdouble-promotion") #Prevents issue where you can do math as a double which might not be intended.
				AppendWarningFlag("-Wnonnull") #Prevents passing null as an argument marked as nonnull attribute
				AppendWarningFlag("-Wnull-dereference") #Warns about a possible null dereference. Compiler checks all possible paths
				# Can't selectively disable this for certian things.
				#AppendWarningFlag("-Wnrvo") #Compiler checks for return value optimization invalidations
				AppendWarningFlag("-Winfinite-recursion") #Warns about infinite recursive calls
				AppendWarningFlag("-Winit-self") #Yells at you if you init something with itself
				AppendWarningFlag("-Wimplicit-fallthrough=4") # Warns about switch statements having a implicit fallthrough. must be marked with [[fallthrough]]
				AppendWarningFlag("-Wignored-qualifiers") #Warns if qualifiers are used in return types. Which are ignored.
				AppendWarningFlag("-Wno-ignored-attributes") #Warns if the compiler ignored an attribute and is unknown to the compiler
				AppendWarningFlag("-Wmain") #Warns if the main function looks odd. (Wrong return type, ect)
				AppendWarningFlag("-Wmisleading-indentation")#Warns if the indentation around an if/conditional could be misleading
				AppendWarningFlag("-Wmissing-attributes") #Warns about missing attributes that are defined with a related function (attributes in the prototype but missing in the definition) (-Wall enabled)
				AppendWarningFlag("-Wmissing-braces") #Warns when initalizing and missing braces during a aggregate or union initalization. (-Wall enabled)
				AppendWarningFlag("-Wmissing-include-dirs") #Warns when missing a include dir that was supplied to the compiler
				AppendWarningFlag("-Wmultistatement-macros") #Warns about odd behaviours with macros being used with conditionals that appear guarded by them
				AppendWarningFlag("-Wparentheses") #Warns about unnecessary parentheses or other weird cases. (Also warns of a case x<=y<=z being seen as (<=y ? 1 : 0) <= z
				AppendWarningFlag("-Wno-self-move") # Prevents moving a value into itself. Which has no effect
				AppendWarningFlag("-Wsequence-point") # Prevents some really weird shit like a = a++. Since due to the order of operations this results in undefined behaviour
				AppendWarningFlag("-Wreturn-type") #Warns when a return type defaults to int.
				AppendWarningFlag("-Wno-shift-count-negative") #Warns when a bitshift count is negative
				AppendWarningFlag("-Wno-shift-count-overflow") #Warns when bitshifting will overflow the width
				AppendWarningFlag("-Wswitch") #Warns when a switch lacks a case for it's given type.
				AppendWarningFlag("-Wswitch-enum") #Warn when a switch misses an enum type in it's case list
				AppendWarningFlag("-Wno-switch-outside-range") #Prevents a case outside of a switch's range.
				AppendWarningFlag("-Wno-switch-unreachable") #Warns when a case value can possible not be reached
				AppendWarningFlag("-Wunused") #Enables a bunch of warnings that relate to things stated but never used.
				AppendWarningFlag("-Wuninitialized") #Warns about values being uninitalized. Where accessing them might be UB in some situations
				AppendWarningFlag("-Wmaybe-uninitialized") #Warns when a value MIGHT not be initalized upon access.
				AppendWarningFlag("-Wunknown-pragmas") #Self explanitory
				AppendWarningFlag("-Wno-prio-ctor-dtor") #Yells about the developer setting priority to compiler reserved values for ctor/dtors
				AppendWarningFlag("-Wstrict-aliasing=3") #Included in -Wall. Prevents aliasing rule breaking
				AppendWarningFlag("-Wstrict-overflow=2") #Trys to hint at using values that won't overflow or will have the smallest chance of overflowing. Example. x+2 > y -> x+1 >= y
				AppendWarningFlag("-Wbool-operation") #Warn against weird operations on the boolean type. Such as bitwise operations ON the bool
				AppendWarningFlag("-Wduplicated-branches") #Warns about branches that appear to do the same thing
				AppendWarningFlag("-Wduplicated-cond") #Warns about a conditional branch having a matching condition for both sides
				AppendWarningFlag("-Wtautological-compare") #Warns when comparing something to itself
				AppendWarningFlag("-Wshadow") #Warns about shadowing any variables
				AppendWarningFlag("-Wfree-nonheap-object") #Warns about freeing a object not on the heap.
				AppendWarningFlag("-Wpointer-arith") #Warns about missuse of 'sizeof' on types with no size. (Such as void)
				AppendWarningFlag("-Wtype-limits") #Warn about comparisons that might be always true/false due to the limitations of a types' ability to display large or small values
				AppendWarningFlag("-Wundef") #Warns about undefined behaviour when evaluating undefined defines
				AppendWarningFlag("-Wcast-qual") #Warns when a cast removes a const attribute from a pointer.
				AppendWarningFlag("-Wcast-align") #Warns when casting can shift a byte boundary for the pointer
				AppendWarningFlag("-Wcast-function-type") #Warns when a function pointer is cast to a incompatable function pointer.
				AppendWarningFlag("-Wwrite-strings") #Warns about string literals to char* conversions
				AppendWarningFlag("-Wclobbered") #Warns about variables that are changed by longjmp or vfork
				AppendWarningFlag("-Wconversion") #Warns about conversions between real and integer numbers and conversions between signed/unsigned numbers
				AppendWarningFlag("-Wdangling-else") #Warns about confusing else statements
				AppendWarningFlag("-Wdangling-pointer=2") #Warns about use of pointers with automatic lifetime
				AppendWarningFlag("-Wempty-body") #Warns about empty conditional bodies
				AppendWarningFlag("-Wfloat-conversion") #Warns about reduction of precision from double -> float conversions
				AppendWarningFlag("-Waddress") #Prevents off uses of addresses
				AppendWarningFlag("-Wlogical-op") #Warns about strange uses of logical operations in expressions
				#TODO: Enable this again when I have time to properly clean it all up. Hiding the functions in a namespace is plenty.
				#AppendWarningFlag("-Wmissing-declarations") #Warns about global functions without any previous declaration
				AppendWarningFlag("-Wmissing-field-initializers") #Warns about a structure missing some fields in it's initalizer
				#Note: padded is for masochists. That's coming from me. Only really enable this if your ready for a fun time.
				#AppendWarningFlag("-Wpadded")
				AppendWarningFlag("-Wredundant-decls") #Warns about declarations that happen more then once.
				AppendWarningFlag("-Wctor-dtor-privacy") #Warns if a class appears unusable due to private ctor/dtors
				AppendWarningFlag("-Wdelete-non-virtual-dtor") #Warns about using `delete` on a class that has virtual functions without a virtual dtor
				# Disabled because of older GCC compilers being unhappy with it
				AppendWarningFlag("-Winvalid-constexpr") #Warns that a function marked as constexpr can't possibly produce a constexpr expression
				AppendWarningFlag("-Wnoexcept") #Warns when a noexcept expression is false due to throwing
				AppendWarningFlag("-Wnoexcept-type")
				AppendWarningFlag("-Wclass-memaccess") #Warns about accessing memory of a class. Which is likely invalid
				AppendWarningFlag("-Wregister") #Warns of use for `register` keyword. Which has been depreicated
				AppendWarningFlag("-Wreorder") # Warns about initlization order being wrong in a class' init list
				AppendWarningFlag("-Wno-pessimizing-move") #Warns about copy elision being prevented my std::move
				AppendWarningFlag("-Wno-redundant-move") #Warns about a std::move being redundant
				AppendWarningFlag("-Wredundant-tags") #Warns about a class-key and enum-key being redundant
				AppendWarningFlag("-Weffc++") #THEEE warning. Forces you to follow c++ guidelines for effective C++
				AppendWarningFlag("-Wold-style-cast") #Warns about using old style C casts
				AppendWarningFlag("-Woverloaded-virtual") #Warns when a function does not overload
				AppendWarningFlag("-Wsign-promo") #Warns about signed promotion without being explicit
				AppendWarningFlag("-Wmismatched-new-delete") #Warns about using new and free instead of new and delete
				AppendWarningFlag("-Wmismatched-tags") #Warns about mismatched tags for an object.
				#AppendWarningFlag("-Wmultiple-inheritance") #Warns about multiple inheritance (Leading to the diamond inheritance model)
				AppendWarningFlag("-Wzero-as-null-pointer-constant") #Warns about using literal zero as a null pointer comparison. Zero might not be nullptr on some machines.
				AppendWarningFlag("-Wcatch-value=3") #Warns about catches not catching by reference.
				AppendWarningFlag("-Wsuggest-final-types") #Self explanatory
				AppendWarningFlag("-Wsuggest-final-methods")# ^
				AppendWarningFlag("-Wsuggest-override")#      ^
				AppendWarningFlag("-Wuse-after-free") #Warns about accessing a value after calling 'free' on it
				AppendWarningFlag("-Wuseless-cast") #Warns about a cast that is useless.

				AppendWarningFlag("-Wno-non-virtual-dtor")

				AppendWarningFlag("-Wno-terminate") # Disables -Wterminate errors, These are kinda weird and I tend to use throw inside of dtors with the intent of it terminating after. So we'll just silence them.

				# Starting other weird flags
				AppendWarningFlag("-fdiagnostics-show-template-tree") # Shows the template diagnostic info as a tree instead.
				AppendWarningFlag("-fdiagnostics-path-format=inline-events")

				list(APPEND FGL_CONFIG "-fconcepts-diagnostics-depth=8")

				string(TOUPPER ${CMAKE_BUILD_TYPE} UPPER_BUILD_TYPE)

				if (DEFINED FGL_ENABLE_UBSAN AND FGL_ENABLE_UBSAN EQUAL 1)
					list(APPEND FGL_CONFIG "-fsanitize=undefined,address,leak,alignment,bounds,vptr")
#					list(APPEND FGL_CONFIG "-fsanitize-trap")
				endif ()

				if (NOT DEFINED FGL_STATIC_ANALYSIS)
					set(FGL_STATIC_ANALYSIS 0)
				endif ()

				if (FGL_STATIC_ANALYSIS EQUAL 1)
					list(APPEND FGL_CONFIG "-fanalyzer")
					#					list(APPEND FGL_CONFIG "-Wanalyzer-too-complex")
					# Breaks more often then it is helpful
					list(APPEND FGL_CONFIG "-Wno-analyzer-use-of-uninitialized-value")
					list(APPEND FGL_CONFIG "-Wno-analyzer-malloc-leak")
				elseif (NOT UPPER_BUILD_TYPE STREQUAL "DEBUG")
					list(APPEND FGL_CONFIG "-flto=auto")
				endif ()

				list(APPEND FGL_CONFIG "-ftree-vectorize")
				list(APPEND FGL_CONFIG "-fmax-errors=2")
				LIST(APPEND FGL_CONFIG "-std=c++23")

				#AppendWarningFlag("-fanalyzer")
				#AppendWarningFlag("-Wanalyzer-too-complex")

				if (DEFINED FGL_STRICT_WARNINGS AND FGL_STRICT_WARNINGS)
					list(APPEND FGL_CONFIG "-Werror")
				endif ()

				# Safe for debug
				#list(APPEND FGL_SHARED_OPTIMIZATION_FLAGS "-fno-rtti")

				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-fdevirtualize-at-ltrans")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-fdevirtualize-speculatively")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-funroll-loops")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-floop-nest-optimize")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-floop-parallelize-all")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-fsplit-paths")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-fstrict-aliasing")
				list(APPEND FGL_GENERAL_OPTIMIZATION_FLAGS "-ftree-vectorize")

				list(APPEND FGL_SHARED_DEBUG "-gdwarf-4")
				list(APPEND FGL_SHARED_DEBUG "-fvar-tracking-assignments")


				# Optimization flags
				set(FGL_FINAL_FLAGS_RELEASE "-O2;-s;${FGL_GENERAL_OPTIMIZATION_FLAGS};${FGL_SHARED_OPTIMIZATION_FLAGS}") # System agonistc flags
				set(FGL_FINAL_FLAGS_RELWITHDEBINFO "-O2;${FGL_GENERAL_OPTIMIZATION_FLAGS};${FGL_SHARED_OPTIMIZATION_FLAGS};${FGL_SHARED_DEBUG}")
				set(FGL_FINAL_FLAGS_DEBUG "-O0;-g;-fstrict-aliasing;-fno-omit-frame-pointer;-ftrapv;-fverbose-asm;-femit-class-debug-always;${FGL_SHARED_DEBUG}") # Debug flags
				set(FGL_FINAL_FLAGS_SYSTEM "-O2;-march=native;-fdeclone-ctor-dtor;-fgcse;-fgcse-las;-fgcse-sm;-ftree-loop-im;-fivopts;-ftree-loop-ivcanon;-fira-hoist-pressure;-fsched-pressure;-fsched-spec-load;-fipa-pta;-s;-ffat-lto-objects;-fno-enforce-eh-specs;-fstrict-enums;${FGL_SHARED_OPTIMIZATION_FLAGS}") # System specific flags. Probably not portable

				list(APPEND FGL_FLAGS ${FGL_CONFIG})
				list(APPEND FGL_FLAGS ${FGL_FINAL_FLAGS_${UPPER_BUILD_TYPE}})
				list(APPEND FGL_FLAGS ${FGL_WARNINGS})

				list(APPEND FGL_CHILD_FLAGS ${FGL_FINAL_FLAGS_${UPPER_BUILD_TYPE}})

				# Final sets
				set(FGL_FLAGS "${FGL_CONFIG};${FGL_FINAL_FLAGS_${UPPER_BUILD_TYPE}};${FGL_WARNINGS}") # Flags for our shit
				set(FGL_FLAGS "${FGL_OPTIMIZATION_FLAGS_${UPPER_BUILD_TYPE}}" PARENT_SCOPE)
				set(FGL_CHILD_FLAGS "${FGL_FINAL_FLAGS_RELEASE}") # Child flags for adding optimization to anything we build ourselves but doesn't follow our standard
				# We use release flags since we really don't need to be using debug flags for anything not ours

				SET_PROPERTY(GLOBAL PROPERTY FGL_FLAGS ${FGL_FLAGS})
				SET_PROPERTY(GLOBAL PROPERTY FGL_CHILD_FLAGS ${FGL_CHILD_FLAGS})

				message("-- FGL_FLAGS: ${FGL_FLAGS}")
				message("-- FGL_CHILD_FLAGS: ${FGL_CHILD_FLAGS}")
			endif ()
		endfunction()


		function(CompilerPostSetup)
		endfunction()