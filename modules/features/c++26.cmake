cmake_minimum_required(VERSION 3.26)
project(TestCXX)

# Default to C++23
set(STD_VERSION 23)

# Check if the compiler supports C++26
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-std=c++26" COMPILER_SUPPORTS_CXX26)

if(COMPILER_SUPPORTS_CXX26)
	set(STD_VERSION 26)
endif()

add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_${STD_VERSION})
