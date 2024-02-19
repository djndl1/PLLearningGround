cmake_minimum_required(VERSION 3.25)

project(CPPTutorial)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(cxx98)
add_subdirectory(boost)

add_custom_target(
  doc
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMAND doxygen doc/config
)
