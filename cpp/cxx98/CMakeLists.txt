set(CMAKE_CXX_STANDARD 98)

include_directories(AFTER .)

add_executable(dummy dummy.cc)
add_executable(fib fib.cc)
add_executable(bubble_sort bubble_sort.cc)
add_executable(exclude_words exclude_words.cc)
add_executable(family_names family_names.cc)
add_custom_command(
  TARGET family_names
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy
  ${CMAKE_CURRENT_SOURCE_DIR}/family_names.txt
  ${CMAKE_CURRENT_BINARY_DIR}/family_names.txt
)
add_executable(odd_even_nums odd_even_nums.cc)
add_executable(matrix matrix.cc)
add_executable(LibMat LibMat.cc)
add_executable(number_sequence number_sequence.cc)
