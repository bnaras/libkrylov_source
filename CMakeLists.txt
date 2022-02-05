cmake_minimum_required(VERSION 3.5)

project(
  libkrylov
  VERSION 1.0.0
  LANGUAGES Fortran C)

enable_testing()

if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Intel")
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -check all -warn all")
elseif("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fcheck=all -Wall")
endif()

find_package(BLAS)
if (NOT ${BLAS_FOUND})
    message(FATAL_ERROR "BLAS library not found")
endif()

find_package(LAPACK)
if (NOT ${LAPACK_FOUND})
  message(FATAL_ERROR "LAPACK library not found")
endif()

add_subdirectory(src)
add_subdirectory(tests)
