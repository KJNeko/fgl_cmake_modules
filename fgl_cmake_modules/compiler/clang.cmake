
        include(compiler/flags)

        function(CompilerPreSetup)
            if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

                # Generic warnings.
                set(FGL_WARNINGS "-Wall -Wundef -Wextra -Wpedantic")

                #AppendFlag("-Wno-changes-meaning") # Prevents accidently changing the type of things. Cannot define 1 things as another later
                AppendFlag("-Wdouble-promotion") #Prevents issue where you can do math as a double which might not be intended.
                AppendFlag("-Wnonnull") #Prevents passing null as an argument marked as nonnull attribute
                AppendFlag("-Wnull-dereference") #Warns about a possible null dereference. Compiler checks all possible paths
                # Can't selectively disable this for certian things.
                #AppendFlag("-Wnrvo") #Compiler checks for return value optimization invalidations
                AppendFlag("-Winfinite-recursion") #Warns about infinite recursive calls
                AppendFlag("-Winit-self") #Yells at you if you init something with itself
                AppendFlag("-Wimplicit-fallthrough=4") # Warns about switch statements having a implicit fallthrough. must be marked with [[fallthrough]]
                AppendFlag("-Wignored-qualifiers") #Warns if qualifiers are used in return types. Which are ignored.
                AppendFlag("-Wno-ignored-attributes") #Warns if the compiler ignored an attribute and is unknown to the compiler
                AppendFlag("-Wmain") #Warns if the main function looks odd. (Wrong return type, ect)
                AppendFlag("-Wmisleading-indentation")#Warns if the indentation around an if/conditional could be misleading
                AppendFlag("-Wmissing-attributes") #Warns about missing attributes that are defined with a related function (attributes in the prototype but missing in the definition) (-Wall enabled)
                AppendFlag("-Wmissing-braces") #Warns when initalizing and missing braces during a aggregate or union initalization. (-Wall enabled)
                AppendFlag("-Wmissing-include-dirs") #Warns when missing a include dir that was supplied to the compiler
                AppendFlag("-Wmultistatement-macros") #Warns about odd behaviours with macros being used with conditionals that appear guarded by them
                AppendFlag("-Wparentheses") #Warns about unnecessary parentheses or other weird cases. (Also warns of a case x<=y<=z being seen as (<=y ? 1 : 0) <= z
                AppendFlag("-Wno-self-move") # Prevents moving a value into itself. Which has no effect
                AppendFlag("-Wsequence-point") # Prevents some really weird shit like a = a++. Since due to the order of operations this results in undefined behaviour
                AppendFlag("-Wreturn-type") #Warns when a return type defaults to int.
                AppendFlag("-Wno-shift-count-negative") #Warns when a bitshift count is negative
                AppendFlag("-Wno-shift-count-overflow") #Warns when bitshifting will overflow the width
                AppendFlag("-Wswitch") #Warns when a switch lacks a case for it's given type.
                AppendFlag("-Wswitch-enum") #Warn when a switch misses an enum type in it's case list
                AppendFlag("-Wno-switch-outside-range") #Prevents a case outside of a switch's range.
                AppendFlag("-Wno-switch-unreachable") #Warns when a case value can possible not be reached
                AppendFlag("-Wunused") #Enables a bunch of warnings that relate to things stated but never used.
                AppendFlag("-Wuninitialized") #Warns about values being uninitalized. Where accessing them might be UB in some situations
                AppendFlag("-Wmaybe-uninitialized") #Warns when a value MIGHT not be initalized upon access.
                AppendFlag("-Wunknown-pragmas") #Self explanitory
                AppendFlag("-Wno-prio-ctor-dtor") #Yells about the developer setting priority to compiler reserved values for ctor/dtors
                AppendFlag("-Wstrict-aliasing=3") #Included in -Wall. Prevents aliasing rule breaking
                AppendFlag("-Wstrict-overflow=2") #Trys to hint at using values that won't overflow or will have the smallest chance of overflowing. Example. x+2 > y -> x+1 >= y
                AppendFlag("-Wbool-operation") #Warn against weird operations on the boolean type. Such as bitwise operations ON the bool
                AppendFlag("-Wduplicated-branches") #Warns about branches that appear to do the same thing
                AppendFlag("-Wduplicated-cond") #Warns about a conditional branch having a matching condition for both sides
                AppendFlag("-Wtautological-compare") #Warns when comparing something to itself
                AppendFlag("-Wshadow") #Warns about shadowing any variables
                AppendFlag("-Wfree-nonheap-object") #Warns about freeing a object not on the heap.
                AppendFlag("-Wpointer-arith") #Warns about missuse of 'sizeof' on types with no size. (Such as void)
                AppendFlag("-Wtype-limits") #Warn about comparisons that might be always true/false due to the limitations of a types' ability to display large or small values
                AppendFlag("-Wundef") #Warns about undefined behaviour when evaluating undefined defines
                AppendFlag("-Wcast-qual") #Warns when a cast removes a const attribute from a pointer.
                AppendFlag("-Wcast-align") #Warns when casting can shift a byte boundary for the pointer
                AppendFlag("-Wcast-function-type") #Warns when a function pointer is cast to a incompatable function pointer.
                AppendFlag("-Wwrite-strings") #Warns about string literals to char* conversions
                AppendFlag("-Wclobbered") #Warns about variables that are changed by longjmp or vfork
                AppendFlag("-Wconversion") #Warns about conversions between real and integer numbers and conversions between signed/unsigned numbers
                AppendFlag("-Wdangling-else") #Warns about confusing else statements
                AppendFlag("-Wdangling-pointer=2") #Warns about use of pointers with automatic lifetime
                AppendFlag("-Wempty-body") #Warns about empty conditional bodies
                AppendFlag("-Wfloat-conversion") #Warns about reduction of precision from double -> float conversions
                AppendFlag("-Waddress") #Prevents off uses of addresses
                AppendFlag("-Wlogical-op") #Warns about strange uses of logical operations in expressions
                #TODO: Enable this again when I have time to properly clean it all up. Hiding the functions in a namespace is plenty.
                #AppendFlag("-Wmissing-declarations") #Warns about global functions without any previous declaration
                AppendFlag("-Wmissing-field-initializers") #Warns about a structure missing some fields in it's initalizer
                #Note: padded is for masochists. That's coming from me. Only really enable this if your ready for a fun time.
                #AppendFlag("-Wpadded")
                AppendFlag("-Wredundant-decls") #Warns about declarations that happen more then once.
                AppendFlag("-Wctor-dtor-privacy") #Warns if a class appears unusable due to private ctor/dtors
                AppendFlag("-Wdelete-non-virtual-dtor") #Warns about using `delete` on a class that has virtual functions without a virtual dtor
                # Disabled because of older GCC compilers being unhappy with it
                AppendFlag("-Winvalid-constexpr") #Warns that a function marked as constexpr can't possibly produce a constexpr expression
                AppendFlag("-Wnoexcept") #Warns when a noexcept expression is false due to throwing
                AppendFlag("-Wnoexcept-type")
                AppendFlag("-Wclass-memaccess") #Warns about accessing memory of a class. Which is likely invalid
                AppendFlag("-Wregister") #Warns of use for `register` keyword. Which has been depreicated
                AppendFlag("-Wreorder") # Warns about initlization order being wrong in a class' init list
                AppendFlag("-Wno-pessimizing-move") #Warns about copy elision being prevented my std::move
                AppendFlag("-Wno-redundant-move") #Warns about a std::move being redundant
                AppendFlag("-Wredundant-tags") #Warns about a class-key and enum-key being redundant
                AppendFlag("-Weffc++") #THEEE warning. Forces you to follow c++ guidelines for effective C++
                AppendFlag("-Wold-style-cast") #Warns about using old style C casts
                AppendFlag("-Woverloaded-virtual") #Warns when a function does not overload
                AppendFlag("-Wsign-promo") #Warns about signed promotion without being explicit
                AppendFlag("-Wmismatched-new-delete") #Warns about using new and free instead of new and delete
                AppendFlag("-Wmismatched-tags") #Warns about mismatched tags for an object.
                #AppendFlag("-Wmultiple-inheritance") #Warns about multiple inheritance (Leading to the diamond inheritance model)
                AppendFlag("-Wzero-as-null-pointer-constant") #Warns about using literal zero as a null pointer comparison. Zero might not be nullptr on some machines.
                AppendFlag("-Wcatch-value=3") #Warns about catches not catching by reference.
                AppendFlag("-Wsuggest-final-types") #Self explanatory
                AppendFlag("-Wsuggest-final-methods")# ^
                AppendFlag("-Wsuggest-override")#      ^
                AppendFlag("-Wuse-after-free") #Warns about accessing a value after calling 'free' on it
                AppendFlag("-Wuseless-cast") #Warns about a cast that is useless.

                # Starting other weird flags
                AppendFlag("-fdiagnostics-show-template-tree") # Shows the template diagnostic info as a tree instead.
                AppendFlag("-fdiagnostics-path-format=inline-events")

                set(FGL_CONFIG "-std=c++23 -fmax-errors=6 -fconcepts-diagnostics-depth=8 -flto=auto -ftree-vectorize")

                if (DEFINED USE_WERROR)
                    set(FGL_CONFIG "${FGL_CONFIG} -Werror")
                endif ()

                # Safe for debug
                set(FGL_SHARED_OPTIMIZATION_FLAGS "-fno-rtti")

                set(FGL_GENERAL_OPTIMIZATION_FLAGS "-fdevirtualize-at-ltrans -fdevirtualize-speculatively -funroll-loops -floop-nest-optimize -floop-parallelize-all -fsplit-paths -fstrict-aliasing -ftree-vectorize")

                set(FGL_SHARED_DEBUG "-gdwarf-4 -fvar-tracking-assignments")

                # Optimization flags
                set(FGL_OPTIMIZATION_FLAGS_RELEASE "-O2 -s ${FGL_GENERAL_OPTIMIZATION_FLAGS} ${FGL_SHARED_OPTIMIZATION_FLAGS}") # System agonistc flags
                set(FGL_OPTIMIZATION_FLAGS_RELWITHDEBINFO "-O2 ${FGL_GENERAL_OPTIMIZATION_FLAGS} ${FGL_SHARED_OPTIMIZATION_FLAGS} ${FGL_SHARED_DEBUG}")
                set(FGL_OPTIMIZATION_FLAGS_DEBUG "-O0 -g -fstrict-aliasing -fno-omit-frame-pointer -ftrapv -fverbose-asm -femit-class-debug-always ${FGL_SHARED_DEBUG}") # Debug flags
                set(FGL_OPTIMIZATION_FLAGS_SYSTEM "-O2 -march=native -fdeclone-ctor-dtor -fgcse -fgcse-las -fgcse-sm -ftree-loop-im -fivopts -ftree-loop-ivcanon -fira-hoist-pressure -fsched-pressure -fsched-spec-load -fipa-pta -s -ffat-lto-objects -fno-enforce-eh-specs -fstrict-enums ${FGL_SHARED_OPTIMIZATION_FLAGS}") # System specific flags. Probably not portable

                # Final sets
                set(FGL_FLAGS "${FGL_CONFIG} ${FGL_OPTIMIZATION_FLAGS_${UPPER_BUILD_TYPE}} ${FGL_WARNINGS}" PARENT_SCOPE) # Flags for our shit
                #set(FGL_FLAGS "${FGL_OPTIMIZATION_FLAGS_${UPPER_BUILD_TYPE}}" PARENT_SCOPE)
                set(FGL_CHILD_FLAGS "${FGL_OPTIMIZATION_FLAGS_RELEASE}" PARENT_SCOPE) # Child flags for adding optimization to anything we build ourselves but doesn't follow our standard
                # We use release flags since we really don't need to be using debug flags for anything not ours
            endif ()
        endfunction()

        function(CompilerPostSetup)

        endfunction()