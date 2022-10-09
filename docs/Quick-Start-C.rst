*********************************
Quick Start for C/C++ Programmers
*********************************

**Linking C/C++ Code against libkrylov**

Libkrylov is distributed as a single compiled library called ``libkrylov.a`` under
Linux/Unix and a single header file ``ckrylov.h``. Assuming that the library
distribution is found under the directory prefix ``$PREFIX``, you can compile
and link your C/C++ program (``prog.c``) as follows.

::

  gcc -o prog.o prog.c -I $PREFIX/include
  gcc -o prog prog.o -L $PREFIX/lib -lkrylov 

The library path option (``-L``) may be omitted if the library is installed in a
location listed in the ``LD_LIBRARY_PATH`` (Linux) or ``DYLD_LIBRARY_PATH``
(macOS) environment variable.

**Calling libkrylov from C/C++ Code**

Include the ``ckrylov.h`` header file to make the libkrylov C API available.

::

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

The function signature of the multiplication, for example, ``real_multiply`` can be found
in the ``ckrylov.h`` header file.
