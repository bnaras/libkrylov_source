# Libkrylov

Libkrylov is a modular open-source software library for extremely large on-the-fly
matrix computations. It is licensed under the 3-clause BSD license.

## How to build and install libkrylov

The library is written in standard Fortran 2003/C99 and built using CMake. In
order to build and install the library, you will need the following tools.

- [CMake](http://cmake.org/), version 3.5 or higher.
- [GNU Make](https://www.gnu.org/software/make/) or [Ninja](https://ninja-build.org/)
  as a primary build tool.
- Fortran 2003/C99 compiler. This source code was tested with the 
  [GNU Fortran compiler](https://gcc.gnu.org/fortran/), version 9, 10, and
  [Intel Fortran Compiler Classic](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/fortran-compiler.html),
  version 2021.1.
- [BLAS](http://www.netlib.org/blas/) and [LAPACK](http://www.netlib.org/lapack/)-compatible
  linear algebra libraries. See
  [CMake documentation](https://cmake.org/cmake/help/latest/module/FindBLAS.html#blas-lapack-vendors)
  for the list of supported BLAS/LAPACK vendors.

CMake supports out-of-source builds, in which the binary artifacts are generated
in a separate directory, usually called `build`. The build and installation
process is as follows.

- Create a `build` subdirectory in the root of the libkrylov repository
  and change into it,
  `mkdir build && cd build` 
- Call `cmake` to generate the build files,
  `cmake ..` or `cmake -G Ninja ..` to use Ninja. This will generate the build
  files for the build tool, GNU Make or Ninja. Note the `..` argument, which
  points to the root of the libkrylov repository.
- Different build types can be specified 
  `-DCMAKE_BUILD_TYPE=<TYPE>`, for example, `Debug`, or `Release`. If the
  build type is `Debug`, additional compiler flags for debugging are enabled.
  See [CMake documentation](https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html)
  for more details.
- Compile the source using CMake by running `cmake --build .` or by directly
  calling the build tool, for example, `make` or `ninja`. Note that here the `.`
  directory argument points to the build directory.
- Run the test suite by calling `ctest` from the build directory.
  The tests are simply a collection of Fortran/C programs in the `tests`
  subdirectory that can be run individually.
- Install the compiled library under the prefix `<DEST>` by using
  `cmake --install . --prefix <DEST>`. The library will be under `<DEST>/lib`.

The data types of libkrylov are completely configurable at compilation time.
The configuration variables are passed to the CMake call, for example,
`cmake -DINTEGER_KIND=<INT> -DREAL_KIND=<REAL> -DCOMPLEX_KIND=<COMPLEX> -DCHARACTER_KIND=<CHAR> -DLOGICAL_KIND=<BOOL> ..`.
The available kinds are summarized in the following table.

| integer       | real            | complex                 | character               | logical               |
| ------------- | --------------- | ----------------------- | ----------------------- | --------------------- |
| `INT32`       | `REAL32`        | `COMPLEX32`             | **`CHARACTER_DEFAULT`** | **`LOGICAL_DEFAULT`** |
| **`INT64`**   | **`REAL64`**    | **`COMPLEX64`**         | `C_CHAR`                | `C_BOOL`              |
| `C_INT`       | `REAL128`       | `COMPLEX128`            |                         |                       |
| `C_LONG`      | `C_FLOAT`       | `COMPLEX_C_FLOAT`       |                         |                       |
| `C_LONG_LONG` | `C_DOUBLE`      | `COMPLEX_C_DOUBLE`      |                         |                       |
|               | `C_LONG_DOUBLE` | `COMPLEX_C_LONG_DOUBLE` |                         |                       |

The default data types are bolded. The types having `C` in their names are included
for calling from C/C++ and correspond to the native C types. Note that native BLAS/LAPACK libraries are not
available for all numerical types.

## How to use libkrylov

### Using libkrylov from Fortran

The general program structure for using libkrylov is as follows.

```fortran
program use_krylov

  integer :: index, error, full_dim, solution_dim, basis_dim
  real :: vectors(300), eigenvalues(1), solutions(100), residual_norm

  error = krylov_initialize()
  if (error /= 0) stop 1

  ! Real symmetric eigenvalue equation of dimension 100
  ! Start with 3 vectors, request 1 solution
  full_dim = 100; solution_dim = 1; basis_dim = 3
  index =  krylov_add_space('r', 's', 'e', full_dim, solution_dim, basis_dim)
  if (index <= 0) stop 1

  ! Generate initial vectors
  vectors = 0.0; vectors(1, 1) = 1.0; vectors(2, 2) = 1.0; vectors(3, 1) = 1.0

  ! Set start vectors for first vector space
  error = krylov_set_real_space_vectors(index, full_dim, basis_dim, vectors)
  if (error /= 0) stop 1

  ! Call solver with user-defined multiplication function
  error = krylov_solve_real_equation(index, real_multiply)

  ! Check success
  if (error /= 0) stop 1

  ! Retrieve eigenvalues
  error = krylov_get_space_eigenvalues(index, solution_dim, eigenvalues)
  if (error /= 0) stop 1

  ! Retrieve solutions
  error =  krylov_get_real_space_solutions(index, full_dim, solution_dim, solutions)
  if (error /= 0) stop 1

  ! Check last residual norm
  residual_norm = krylov_get_space_last_residual_norm(1)

  error = krylov_finalize()
  if (error /= 0) stop 1

end program use_krylov
```

The user provides the multiplication function with the following interface (for real-valued
problems).
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

Block-structured problems that which should be iterated simultaneously for reasons of
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

### Using libkrylov from C/C++

Include the `ckrylov.h` header file to make the libkrylov C API available.

```c
#include <assert.h>
#include <string.h>
#include "ckrylov.h"

int main() {
  int error, index;

  error = ckrylov_initialize();
  assert(error == CKRYLOV_OK);

  /* Real symmetric eigenvalue equation of dimension 4
     Start with 1 vectors, request 1 solution */
  char kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
       equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int full_dim = 4, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  assert(index == 1);

  /* Set initial vector */
  double vectors[] = {1.0, 0.0, 0.0, 0.0};
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors);
  assert(error == CKRYLOV_OK);

  /* Call solver */
  error = ckrylov_solve_real_equation(index, real_multiply);

  /* Check success */
  assert(error == CKRYLOV_OK);

  /* Retrieve eigenvalues */
  double eigenvalues[1];
  error = ckrylov_get_space_eigenvalues(index, solution_dim, eigenvalues);
  assert(error == CKRYLOV_OK);

  /* Retrieve solutions */
  double solutions[4];
  error = ckrylov_get_real_space_solutions(index, full_dim, solution_dim, solutions);
  assert(error == CKRYLOV_OK);

  error = ckrylov_finalize();
  assert (error == CKRYLOV_OK);

  return 0;
}
```

The function signature of the multiplication, for example, `real_multiply` can be found
in the `ckrylov.h` header file.