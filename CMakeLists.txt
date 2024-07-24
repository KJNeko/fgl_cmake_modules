cmake_minimum_required(VERSION 3.20)

#set(PROJECT_NAME "MyCXXTemplate")

#project(${PROJECT_NAME} LANGUAGES CXX C)

#set(CMAKE_CXX_STANDARD 23)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/fgl_cmake_modules" ${CMAKE_MODULE_PATH})

include(common)

#PreSetup()

# Example of a 3rd party library (you'd use find_library instead of add_library)
#add_subdirectory(dependencies/example)
#SetDependencyFlags(ExampleDependency)

# Our library example
#AddFGLLibrary(MyLibrary ${CMAKE_CURRENT_SOURCE_DIR}/lib/src ${CMAKE_CURRENT_SOURCE_DIR}/lib/include)

# Our executable example (TargetName, CPP files location, HPP files location)
#AddFGLExecutable(MyApplication ${CMAKE_CURRENT_SOURCE_DIR}/src)

#PostSetup()