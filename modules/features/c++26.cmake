cmake_minimum_required(VERSION 3.26)

include(CheckCXXSourceCompiles)

# Test actual compilation of C++26 code
set(CMAKE_REQUIRED_FLAGS "-std=c++26")
check_cxx_source_compiles("
struct A {
    auto operator<=>(const A&) const = default; // C++20/26 feature
};
int main() { A a,b; return (a <=> b) == 0 ? 0 : 1; }
" HAS_CXX26)
set(CMAKE_REQUIRED_FLAGS "")  # reset