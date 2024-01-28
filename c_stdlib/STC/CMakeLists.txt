cmake_minimum_required(VERSION 3.13)

project(STCTutorial)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(AFTER
  ${STCTutorial_SOURCE_DIR}/include
  ${STCTutorial_SOURCE_DIR}/lib/STC/include)

add_executable(cstr_test src/cstr_test)

enable_testing()

add_test(cstr_test cstr_test)
