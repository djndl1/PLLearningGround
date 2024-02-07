cmake_minimum_required(VERSION 3.13)

project(STCTutorial)

include(ExternalProject)
ExternalProject_Add(STC
  URL ${STCTutorial_SOURCE_DIR}/lib/STC
  INSTALL_COMMAND echo "STC included"
)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(AFTER
  ${STCTutorial_SOURCE_DIR}/include
  ${STCTutorial_SOURCE_DIR}/lib/STC/include)

add_executable(cstr_test src/cstr_test.c)
add_executable(cvec_test src/cvec_test.c)
add_executable(calgo_test src/calgo_test.c)

add_test(cstr_test cstr_test)
