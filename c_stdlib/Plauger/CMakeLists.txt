cmake_minimum_required(VERSION 3.13)

project(PlaugerLibc)

include_directories(BEFORE SYSTEM include)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(PlaugerLibc
  src/assert.c
)

add_executable(tassert
  test/tassert.c)
target_link_libraries(tassert PlaugerLibc)

enable_testing()
add_test(assert_test tassert)
