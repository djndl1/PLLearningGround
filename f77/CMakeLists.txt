cmake_minimum_required(VERSION 3.23)

project(f77 LANGUAGES Fortran)

set(CMAKE_FORTRAN_COMPILER gfortran)

add_executable(circle src/circle.f)
add_executable(identity_matrix src/identity_matrix.f)
add_executable(io src/io.f)
