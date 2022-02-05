project(krylov_examples)

link_libraries(krylov)
include_directories(${libkrylov_BINARY_DIR}/src)

add_executable(ex01 ex01.f90)

add_custom_target(examples)
add_dependencies(examples
  ex01
)
