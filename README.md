# Libkrylov

Libkrylov is a modular open-source software library for extremely large on-the-fly
matrix computations.

Libkrylov uses the 3-clause BSD license.

## How to build

The library is written in Fortran 2003 and built using cmake. In order to compile and
link the library, you will need:

- [CMake](http://cmake.org/), version 3.5 or higher
- [GNU Make](https://www.gnu.org/software/make/) or [Ninja](https://ninja-build.org/)
  as a primary build tool
- A Fortran 2003 compiler. This source code was so far tested with the 
  [GNU Fortran compiler](https://gcc.gnu.org/fortran/), version 10, and
  [Intel Fortran Compiler Classic](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/fortran-compiler.html), version 2021.1.

CMake uses a separate directory, usually called `build`, to hold all binary files.
The build and installation process is as follows.

- Create a `build` subdirectory in the root of the library repository
  and change into it,
  `mkdir -p build && cd build` 
- Call `cmake` to generate the build files,
  `cmake ..` or `cmake -G Ninja ..` if you want to use Ninja.
  This will generate the build files for the actual build tool, for example,
  GNU Make or Ninja. Note the `..`. This directory argument instructs CMake
  to read the configuration from the `CMakeLists.txt` file in the root
  of the library repository.
- In the previous step, it is possible to add the debug flag 
  `-DCMAKE_BUILD_TYPE=Debug`, 
  for example `cmake -DCMAKE_BUILD_TYPE=Debug ..`.
- Compile the source using CMake by running `cmake --build .` or by directly
  calling `make` or `ninja` (depending what build tool you selected in the
  previous step). In this case, the `.` directory argument points to the
  build directory.
- Verify the correctness of the compilation by running the tests. In the
  build directory, run `ctest` and make sure that all tests pass correctly.
  The tests are simply a collection of Fortran programs in the `tests`
  subdirectory that you can execute and debug individually.
- Install the compiled library under the prefix `<DEST>` by using
  `cmake --install . --prefix <DEST>`. The library will be under `<DEST>/lib`.

You can configure the numeric kinds used in libkrylov by passing flags
to `cmake` at compilation time,
`cmake -DINTEGER_KIND=INT64 -DREAL_KIND=REAL64 -DCOMPLEX_KIND=COMPLEX64 ..`.
The available integer kinds are `INT32`, `INT64` (default). The available
real kinds are `REAL32`, `REAL64` (default), and `REAL128`. The available
complex kinds are `COMPLEX32`, `COMPLEX64` (default), and `COMPLEX128`.

## How to use

The general program structure for using libkrylov is as follows.

```fortran
program use_krylov

  integer :: index, error
  real :: vectors(300), solutions(100), residual_norm

  error = krylov_initialize()
  if (error /= 0) stop 1

  ! Eigenvalue equation on general real space with dimension 100
  ! start with 3 vectors, request 1 solution
  index =  krylov_add_space('r', 's', 'e', 100, 1, 3)
  if (index <= 0) stop 1

  ! Generate initial vectors
  vectors = [(real(i), i = 0, 299)]

  ! Set start vectors for first vector space
  error = krylov_set_real_space_vectors(1, 100, 3, vectors)
  if (error /= 0) stop 1

  ! Call eigensolver
  error = krylov_solve_real_equation(1, multiply)

  ! Check success
  if (error /= 0) stop 1

  ! Retrieve solutions for first vector space
  error =  krylov_get_real_space_solutions(1, 100, 1, solutions)
  if (error /= 0) stop 1

  ! Check last residual norm
  residual_norm = krylov_get_space_last_residual_norm(1)

  ! Do something with the solution
  print *, solutions

  error = krylov_finalize()
  if (error /= 0) stop 1

end program use_krylov
```

The user provides the multiplication function with the following interface (for real-valued problems).
```fortran
function krylov_i_real_multiply(full_dim, subset_dim, vectors, products) result(error)
  integer, intent(in) :: full_dim, subset_dim
  real, intent(in) :: vectors(full_dim, subset_dim)
  real, intent(out) :: products(full_dim, subset_dim)
  integer :: error
end function krylov_i_real_multiply
```
For each of the `subset_dim` vectors with length `full_dim` from the `vectors`
array, the multiplication function should provide the matrix-vector products in
the corresponding location of the `products` array.

Block-structured problems which should be iterated simultaneously for reasons of
efficiency can be solved with the `krylov_solve_real_block_equation` function,
which accepts a block multiplication function with the following interface.
```fortran
function krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, &
                                offsets, vectors, products) result(error)
  integer, intent(in) :: num_spaces, total_size, full_dims(num_spaces), &
                         subset_dims(num_spaces), offsets(num_spaces)
  real, intent(in) :: vectors(total_size)
  real, intent(out) :: products(total_size)
  integer :: error
end function krylov_i_real_block_multiply
```
The block multiplication function should implement the computation of
matrix-vector products for all vector spaces simultaneously. The vectors and
products are laid out consecutively on the respective arrays in the order, in
which the spaces were added. The vectors and products belonging to the space
with the index `i` have the length `full_dims(i)`. Only `subset_dims(i)` of the
vectors are multiplied simultaneously. These vectors are stored on the array
slice `vectors(offsets(i) + 1: offsets(i) + full_dims(i) * subset_dims(i))` with
`1: full_dims(i)` as the leftmost (fastest changing) index. The layout of the
`products` array is identical.

Either multiplication function should return `error < 0` to signal an error.
