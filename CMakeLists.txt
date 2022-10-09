cmake_minimum_required(VERSION 3.5)

project(
  libkrylov
  VERSION 1.0.0
  LANGUAGES Fortran C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED TRUE)

enable_testing()

if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Intel")
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -check all -warn all")
elseif("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fcheck=all -Wall")
endif()

find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)

# Set up code coverage
option(CODE_COVERAGE "GNU-based code coverage" OFF)
if (NOT CMAKE_GCOV_TOOL)
    set(CMAKE_GCOV_TOOL gcov)
endif()
if (NOT CMAKE_LCOV_TOOL)
    set(CMAKE_LCOV_TOOL lcov)
endif()
set(GCOV_PROGRAM_NAME ${CMAKE_GCOV_TOOL} CACHE STRING "Name of GNU code coverage analysis tool.")
set(LCOV_PROGRAM_NAME ${CMAKE_LCOV_TOOL} lcov CACHE STRING "Name of GNU code coverage visualization tool.")
if(CODE_COVERAGE)
  set(CMAKE_BUILD_TYPE Debug)
  if(NOT ("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU"))
    message(FATAL_ERROR "Code coverage requires the GNU Fortran compiler! Aborting...")
  endif()
  add_compile_options(-fprofile-arcs -ftest-coverage -O0)
  add_link_options(-fprofile-arcs -ftest-coverage -lgcov)
  find_program(GCOV_PATH ${GCOV_PROGRAM_NAME})
  find_program(LCOV_PATH ${LCOV_PROGRAM_NAME})
  if(NOT GCOV_PATH)
    message(FATAL_ERROR "${GCOV_PROGRAM_NAME} not found! Aborting...")
  endif()
  if(NOT LCOV_PATH)
    message(FATAL_ERROR "${LCOV_PROGRAM_NAME} not found! Aborting...")
  endif()
  configure_file("${CMAKE_SOURCE_DIR}/cmake/CTestCustom.cmake" "${CMAKE_BINARY_DIR}/CTestCustom.cmake")
endif()

add_subdirectory(src)
add_subdirectory(tests)
