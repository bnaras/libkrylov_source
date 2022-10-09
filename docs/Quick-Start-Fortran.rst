***********************************
Quick Start for Fortran Programmers
***********************************

**Linking Fortran Code against libkrylov**

Libkrylov is distributed as a single compiled library called ``libkrylov.a``
under Linux/Unix. Assuming that the library distribution is found under the
directory prefix ``$PREFIX``, you can compile and link your Fortran program
(``prog.f90``) as follows.

::

   gfortran -o prog prog.f90 -L $PREFIX/lib -lkrylov

The library path option (``-L``) may be omitted if the library is installed in a
location listed in the ``LD_LIBRARY_PATH`` (Linux) or ``DYLD_LIBRARY_PATH``
(macOS) environment variable.

**Calling libkrylov from Fortran Code**

The general program structure for using libkrylov is as follows.

.. code-block:: fortran

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


The user provides the multiplication function with the following interface (for real-valued
problems).

.. code-block:: fortran

  function krylov_i_real_multiply(full_dim, subset_dim, vectors, products) result(error)
    integer, intent(in) :: full_dim, subset_dim
    real, intent(in) :: vectors(full_dim, subset_dim)
    real, intent(out) :: products(full_dim, subset_dim)
    integer :: error
  end function krylov_i_real_multiply

For each of the ``subset_dim`` vectors with length ``full_dim`` from the ``vectors``
array, the multiplication function should provide the matrix-vector products in
the corresponding location of the ``products`` array.

Block-structured problems that which should be iterated simultaneously for reasons of
efficiency can be solved with the ``krylov_solve_real_block_equation`` function,
which accepts a block multiplication function with the following interface.

.. code-block:: fortran

  function krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, &
                                  offsets, vectors, products) result(error)
    integer, intent(in) :: num_spaces, total_size, full_dims(num_spaces), &
                          subset_dims(num_spaces), offsets(num_spaces)
    real, intent(in) :: vectors(total_size)
    real, intent(out) :: products(total_size)
    integer :: error
  end function krylov_i_real_block_multiply

The block multiplication function should implement the computation of
matrix-vector products for all vector spaces simultaneously. The vectors and
products are laid out consecutively on the respective arrays in the order, in
which the spaces were added. The vectors and products belonging to the space
with the index ``i`` have the length ``full_dims(i)``. Only ``subset_dims(i)`` of the
vectors are multiplied simultaneously. These vectors are stored on the array
slice ``vectors(offsets(i) + 1: offsets(i) + full_dims(i) * subset_dims(i))`` with
``1: full_dims(i)`` as the leftmost (fastest changing) index. The layout of the
``products`` array is identical.

Either multiplication function should return ``error < 0`` to signal an error.

