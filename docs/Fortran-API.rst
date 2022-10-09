***********
Fortran API
***********

The specific data types of the library arguments are set at compile time by
passing the appropriate CMake options. Please refer to the :ref:`data type
table<supported data types>` in the installation guide for the supported
data types.

The input parameters are declared with the Fortran ``intent(in)`` attribute, the
output parameters are declared as ``intent(out)``. With the exception of simple
getter functions, all functions return integer error codes. The return value of
0 indicates successful exit, negative values represent error conditions.  See
the :ref:`table of error codes<error codes>` for the complete listing.

===============================
Initialization and Finalization
===============================

krylov_initialize()
===================
    Initializes libkrylov library. Must be called first before all other
    functions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_finalize()
=================
    Frees all objects and finalizes libkrylov library. Must be call last. No
    functions must be called after the library has been finalized.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

=============
Informational
=============

krylov_get_version(version)
===========================
    Writes libkrylov version number into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``version`` : string version

        **Return:**
            * integer error code

krylov_get_compiled_datetime(compiled_dt)
=========================================
    Writes timestamp of compilation into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``compiled_dt`` : string timestamp

        **Return:**
            * integer error code

krylov_get_current_datetime(current_dt)
=======================================
    Writes timestamp of execution into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``current_dt`` : string timestamp

        **Return:**
            * integer error code

krylov_header()
===============
    Prints libkrylov header to standard output.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_footer()
===============
    Prints libkrylov footer with timestamp to standard output.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

=====================
Default Configuration
=====================
Configuration options of integer, real, string, logical, or enum types may be
set per space. Enum options use short strings as identifier values. Accepted
configuration options and enum values are listed below. Unknown configuration
options are silently ignored. Unknown enum values generate an error.
Default options are defined upon initialization and may be changed by the
user. Changes to default options apply only to spaces defined subsequently.
See the :ref:`Space Operations` section for space-specific configuration.

Preconditioner and orthonormalizer enum options are treated specially.
The default preconditioner and orthonormalizer types can be set normally.
However, setting these options on an existing space has no effect.
For changing the preconditioner or orthonormalizer on an
existing space, use :ref:`krylov_set_space_preconditioner<krylov_set_space_preconditioner(index, preconditioner)>` and
:ref:`krylov_set_space_orthonormalizer<krylov_set_space_orthonormalizer(index, orthonormalizer)>` functions.

Configuration Options
=====================

+---------------------------------+----------+----------------------------------------+
|             **Key**             | **Type** |            **Description**             |
+=================================+==========+========================================+
| max_iterations                  | integer  | Max number of algorithm iterations     |
+---------------------------------+----------+----------------------------------------+
| max_residual_norm               | real     | Max residual norm threshold            |
+---------------------------------+----------+----------------------------------------+
| min_gram_rcond                  | real     | Max inverse Gram condition number      |
+---------------------------------+----------+----------------------------------------+
| min_basis_vector_norm           | real     | Norm threshold for zero vectors        |
+---------------------------------+----------+----------------------------------------+
| min_basis_vector_singular value | real     | Threshold for zero singular values     |
+---------------------------------+----------+----------------------------------------+
| min_diagonal_scaling            | real     | Threshold for diagonal preconditioners |
+---------------------------------+----------+----------------------------------------+

Configuration Enum Values
=========================

+-----------------+----------+-------------------------+
|     **Key**     | **Type** |     Accepted Values     |
+=================+==========+=========================+
| preconditioner  | enum     | 'n', 'c', 'd', 'j', 'a' |
+-----------------+----------+-------------------------+
| orthonormalizer | enum     | 'o', 'n', 's'           |
+-----------------+----------+-------------------------+

krylov_set_defaults()
=====================
    Resets all configuration options to their defaults.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_integer_option(key)
==============================
    Returns the default configuration value of integer option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value

krylov_set_integer_option(key, value)
=====================================
    Sets the default configuration value of integer option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value`` : integer configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_string_option(key, value)
=====================================
    Writes the default configuration value of string option ``key`` to string.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * ``value`` : string configuration value

        **Return:**
            * integer error code

krylov_set_string_option(key, value)
=====================================
    Sets the default configuration value of string option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_length_string_option(key)
=================================
    Gets the length of the default configuration value for string option ``key``.
    Allocating a string of the length returned by this function ensures that
    the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer value length

krylov_get_real_option(key)
============================
    Gets the default configuration value of real option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * real configuration value

krylov_set_real_option(key, value)
==================================
    Sets the default configuration value of real option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value``: real configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_logical_option(key)
=================================
    Gets the default configuration value of logical option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * logical configuration value

krylov_set_logical_option(key, value)
=====================================
    Sets the default configuration value of logical option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value`` : logical configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_enum_option(key, value)
==================================
    Writes the default configuration value of enum option ``key`` into a string.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * ``value`` : string configuration value

        **Return:**
            * integer error code

krylov_set_enum_option(key, value)
==================================
    Sets the default configuration value of enum option ``key`` to ``value``.
    Invalid configuration values generate an error.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_length_enum_option(key)
===============================
    Gets the length of the default configuration value of enum option ``key``.
    Allocating a string of the length returned by this function ensures that
    the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer string length

krylov_define_enum_option(key, values)
======================================
    Sets acceptable default configuration values of the enum configuration
    option ``key``. The acceptable values are provided in the ``values`` string
    and are semicolon-separated.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``values`` : string acceptable values.

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_validate_enum_option(key, value)
=======================================
    Checks if ``value`` is an acceptable default configuration value of the enum
    configuration option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

================
Space Operations
================
libkrylov allows simultaneous iteration for multiple Krylov subspaces
sharing the matrix-vector product function for efficiency. The
``space`` object is the central abstraction in libkrylov and defines
the equation type, preconditioner, and orthonormalizer. Before the
solvers can be called, these parameters must be defined by calling
:ref:`krylov_add_space<krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim)>`.
This function returns an integer space index,
which is used to identify the space in all subsequent operations.
Mixing Krylov subspaces with different sets of parameters is possible.

krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim)
==============================================================================
    Adds new Krylov subspace solver. ``kind``, ``structure``, ``equation``,
    ``full_dim`` cannot be subsequently changed. ``solution_dim`` can be
    increased after the space was created. ``basis_dim`` is updated by the
    algorithm. This function uses default configuration options. Space-specific
    configuration can be changed for an existing space unless noted below. See
    the :ref:`quickstart guide <Quick Start for Fortran Programmers>` for examples.

+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| **Argument** | **Type**         | **Description**                 | **Accepted Values**                                                |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| kind         | character(len=1) | arithmetic kind                 | 'r'=real; 'c'=complex                                              |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| structure    | character(len=1) | structure of coefficient matrix | 's'=symmetric; 'h'=hermitian                                       |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| equation     | character(len=1) | equation type                   | 'e'=eigenproblem; 'l'=linear equation; 'h'=shifted linear equation |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| full_dim     | integer          | coefficient matrix dimension    | integer > 0                                                        |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| solution_dim | integer          | number of solutions             | integer > 0, <= full_dim                                           |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+
| basis_dim    | integer          | number of starting vectors      | integer > 0, <= full_dim                                           |
+--------------+------------------+---------------------------------+--------------------------------------------------------------------+

        **Input Parameters:**
            * ``kind`` : string arithmetic kind
            * ``structure`` : string structure of coefficient matrix
            * ``equation`` : string equation type
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions
            * ``basis_dim`` : integer number of starting subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * index of space created (if > 0) or error code (if < 0)

krylov_get_num_spaces()
=======================
    Total number of spaces.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer number of spaces

krylov_get_space_integer_option(index, key)
===========================================
    Returns the space-specific configuration value of integer option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value

krylov_set_space_integer_option(index, key, value)
==================================================
    Sets the space-specific configuration value of integer option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` :  integer configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_string_option(index, key, value)
=================================================
    Writes the space-specific configuration value of string option ``key`` to
    string.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_set_space_string_option(index, key, value)
=================================================
    Sets the space-specific configuration value of string option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_length_space_string_option(index, key)
==============================================
    Gets the length of the space-specific configuration value for string option
    ``key``. Allocating a string of the length returned by this function ensures
    that the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value length

krylov_get_space_real_option(index, key)
========================================
    Gets the space-specific configuration value of real option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * real configuration value

krylov_set_space_real_option(index, key, value)
==================================================
    Sets the space-specific configuration value of real option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : real configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_logical_option(index, key)
===========================================
    Gets the space-specific configuration value of logical option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * logical configuration value

krylov_set_space_logical_option(index, key, value)
==================================================
    Sets the space-specific configuration value of logical option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : boolean configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_enum_option(index, key, value)
===============================================
    Writes the space-specific configuration value of enum option ``key`` into a
    string.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * ``value`` : string configuration value

        **Return:**
            * integer error code

krylov_set_space_enum_option(index, key, value)
===============================================
    Sets the space-specific configuration value of enum option ``key`` to
    ``value``. Invalid configuration values generate an error.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_length_space_enum_option(index, key)
==================================================
   Gets the length of the space-specific configuration value of enum option
   ``key``. Allocating a string of the length returned by this function ensures
   that the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key

        **Output Parameters:**
            * none

        **Return:**
            * integer string length

krylov_define_space_enum_option(index, key, values)
===================================================
    Sets acceptable space-specific configuration values of the enum
    configuration option ``key``. The acceptable values are provided in the
    ``values`` string and are semicolon-separated.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``values`` : string acceptable values

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_validate_space_enum_option(index, key, value)
====================================================
    Checks if ``value`` is an acceptable space-specific configuration value of
    the enum configuration option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``value`` : string configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_kind(index, kind)
==================================
    Writes arithmetic kind of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``kind`` : string arithmetic kind

        **Return:**
            * integer error code

krylov_get_space_structure(index, structure)
============================================
    Writes matrix structure of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``structure`` : string matrix structure

        **Return:**
            * integer error code

krylov_get_space_equation(index, equation)
==========================================
    Writes equation type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``equation`` : string equation type

        **Return:**
            * integer error code

krylov_get_space_preconditioner(index, preconditioner)
======================================================
    Writes preconditioner type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``preconditioner`` : string preconditioner type. See :ref:`available preconditioners` for definitions.

        **Return:**
            * integer error code

krylov_set_space_preconditioner(index, preconditioner)
======================================================
    Resets the preconditioner type of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``preconditioner`` : string preconditioner type. See :ref:`available preconditioners` for definitions.

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_orthonormalizer(index, orthonormalizer)
========================================================
    Writes preconditioner type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``orthonormalizer`` : string orthonormalizer type. See :ref:`available orthonormalizers` for definitions.

        **Return:**
            * integer error code

krylov_set_space_orthonormalizer(index, orthonormalizer)
========================================================
    Resets the orthonormalizer type of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``orthonormalizer`` : string orthonormalizer type. See :ref:`available orthonormalizers` for definitions.

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_full_dim(index)
================================
    Returns the coefficient matrix dimension of the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer coefficient matrix dimension. See :ref:`krylov_add_space<krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim)>` for more info.

krylov_get_space_solution_dim(index)
====================================
    Returns the number of solutions for the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of solutions. See :ref:`krylov_add_space<krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim)>` for more info.

krylov_get_space_basis_dim(index)
=================================
    Returns the number of subspace vectors in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of subspace vectors. See :ref:`krylov_add_space<krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim)>` for more info.

krylov_get_space_vector_size(index)
===================================
    Returns the length (total number of elements) of the subspace vectors in the
    given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of subspace vectors

krylov_get_space_solution_size(index)
=====================================
    Returns the length (total number of elements) of the solution vectors in the given
    space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of solution vectors

krylov_get_space_eigenvalue_size(index)
=======================================
    Returns the length of the eigenvalues list in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of eigenvalue list

krylov_get_space_rhs_size(index)
================================
    Returns the length (total number of elements) of the right-hand side (RHS) vectors
    in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of RHS vectors

krylov_get_space_eigenvalues(index, solution_dim, eigenvalues)
==============================================================
    Gets the eigenvalues for the given space. Returns an error if the equation
    type is not eigenvalue equation.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``eigenvalues(solution_dim)`` : real eigenvalues

        **Return:**
            * integer error code

krylov_set_space_diagonal(index, full_dim, diagonal)
====================================================
    Set the (true or approximate) matrix diagonal for Davidson preconditioner
    and related methods on the given space. Returns an error if the selected
    preconditioner does not use the diagonal matrix.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``diagonal(full_dim)`` : real diagonal

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_space_shifts(index, solution_dim, shifts)
====================================================
    Gets the shift parameters for shifted linear equations.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``shifts(solution_dim)`` : shift parameters

        **Return:**
            * integer error code

krylov_set_space_shifts(index, solution_dim, shifts)
====================================================
    Sets the shift parameters for shifted linear equations. The shift parameters
    are defined independently per solution, even if they are equal.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions
            * ``shifts(solution_dim)`` : shift parameters

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_real_space_vectors(index, full_dim, basis_dim, vectors)
==================================================================
    Gets subspace vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, basis_dim)`` : real subspace vectors

        **Return:**
            * integer error code

krylov_set_real_space_vectors(index, full_dim, basis_dim, vectors)
==================================================================
    Sets starting subspace vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors
            * ``vectors(full_dim, basis_dim)`` : real subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_set_real_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal)
=================================================================================
    Convenience function for generating starting subspace vectors for the given
    real space from the diagonal. For eigenvalue equations, the starting vectors
    are taken as unit vectors corresponding to the lowest diagonal elements.
    For linear and shifted linear equations, the starting vectors are obtained
    by solving the equation with the diagonal approximation.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors
            * ``diagonal(full_dim)`` : real diagonal

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_resize_real_space_vectors(index, basis_dim)
==================================================
    Updates the number of subspace vectors in the given real space.
    Can only increase the number of subspace vectors at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_real_space_products(index, full_dim, basis_dim, products)
====================================================================
    Gets matrix-vector products of the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``products(full_dim, basis_dim)`` : real matrix-vector products

        **Return:**
            * integer error code

krylov_get_real_space_solutions(index, full_dim, solution_dim, solutions)
=========================================================================
    Gets solutions of the Krylov subspace algorithm for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solution

        **Output Parameters:**
            * ``solutions(full_dim, solution_dim)`` : real solutions

        **Return:**
            * integer error code

krylov_resize_real_space_solutions(index, solution_dim)
=======================================================
    Updates the number of solutions requested for the given real space.
    Can only increase the number of solutions at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_real_space_rhs(index, full_dim, solution_dim, rhs)
=============================================================
    Gets right-hand side (RHS) vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``rhs(full_dim, solution_dim)`` : real RHS

        **Return:**
            * integer error code

krylov_set_real_space_rhs(index, full_dim, solution_dim, rhs)
=============================================================
    Sets right-hand side (RHS) vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions
            * ``rhs(full_dim, solution_dim)`` : real RHS

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)
====================================================================================
    Helper function to get a list of ``subset_dim`` subspace vectors starting
    from offset ``skip_dim`` in the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, subset_dim)`` : real subspace vectors

        **Return:**
            * integer error code

krylov_set_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)
====================================================================================
    Helper function to set a list of ``subset_dim`` subspace vectors starting from
    offset ``skip_dim`` in the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim, subset_dim)`` : real subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products)
======================================================================================
    Helper function to get matrix-vector products for the list of ``subset_dim``
    subspace vectors starting from offset ``skip_dim`` in the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``products(full_dim, subset_dim)`` : real matrix-vector products

        **Return:**
            * integer error code

krylov_set_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products)
======================================================================================
    Helper function to set matrix-vector products for the list of ``subset_dim``
    subspace vectors starting from offset ``skip_dim`` in the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace products
            * ``products(full_dim, subset_dim)`` : real matrix-vector products

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_complex_space_vectors(index, full_dim, basis_dim, vectors)
======================================================================
    Gets subspace vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, basis_dim)`` : complex subspace vectors

        **Return:**
            * integer error code

krylov_set_complex_space_vectors(index, full_dim, basis_dim, vectors)
======================================================================
    Sets starting subspace vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors
            * ``vectors(full_dim, basis_dim)`` :  complex subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_set_complex_space_vectors_from_diagonal(index, full_dim, basis_dim, products)
====================================================================================
    Convenience function for generating starting subspace vectors for the given
    complex space from the diagonal. For eigenvalue equations, the starting vectors
    are taken as unit vectors corresponding to the lowest diagonal elements.
    For linear and shifted linear equations, the starting vectors are obtained
    by solving the equation with the diagonal approximation.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors
            * ``diagonal(full_dim)`` : real diagonal

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_resize_complex_space_vectors(index, basis_dim)
=====================================================
    Updates the number of subspace vectors in the given complex space.
    Can only increase the number of subspace vectors at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_complex_space_products(index, full_dim, basis_dim, products)
=======================================================================
    Gets matrix-vector products of the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``products(full_dim, basis_dim)`` : complex matrix-vector products

        **Return:**
            * integer error code

krylov_get_complex_space_solutions(index, full_dim, solution_dim, solutions)
============================================================================
    Gets solutions of the Krylov subspace algorithm for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``solutions(full_dim, solution_dim)`` : complex solutions

        **Return:**
            * integer error code

krylov_resize_complex_space_solutions(index, solution_dim)
==========================================================
    Updates the number of solutions requested for the given complex space.
    Can only increase the number of solutions at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_complex_space_rhs(index, full_dim, solution_dim, rhs)
================================================================
    Gets right-hand side (RHS) vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``rhs(full_dim, solution_dim)`` : complex RHS

        **Return:**
            * integer error code

krylov_set_complex_space_rhs(index, full_dim, solution_dim, rhs)
================================================================
    Sets right-hand side (RHS) vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions
            * ``rhs(full_dim, solution_dim)`` : complex RHS

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)
=======================================================================================
    Helper function to get a list of ``subset_dim`` subspace vectors starting
    from offset ``skip_dim`` in the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, subset_dim)`` : complex subspace vectors

        **Return:**
            * integer error code

krylov_set_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)
=======================================================================================
    Helper function to set a list of ``subset_dim`` subspace vectors starting from
    offset ``skip_dim`` in the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim, subset_dim)`` : complex subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_get_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products)
=========================================================================================
    Helper function to get matrix-vector products for the list of ``subset_dim``
    subspace vectors starting from offset ``skip_dim`` in the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace products

        **Output Parameters:**
            * ``products(full_dim, subset_dim)`` : complex matrix-vector products

        **Return:**
            * integer error code

krylov_set_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products)
=========================================================================================
    Helper function to set matrix-vector products for the list of ``subset_dim``
    subspace vectors starting from offset ``skip_dim`` in the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``skip_dim`` : integer vector offset
            * ``subset_dim`` : integer number of subspace products
            * ``products(full_dim, subset_dim)`` : complex matrix-vector products

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

================
Block Operations
================

krylov_get_real_block_total_size()
==================================
   Helper function to get the total number of elements of subspace vectors over
   all real spaces. Used in the simultaneous iteration of multiple Krylov
   subspaces. This parameter is passed to the multiplication function
   :ref:`krylov_i_real_block_multiply <krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * number of elements of subspace vectors over all real spaces

krylov_get_real_block_dims(num_spaces, full_dims, subset_dims, offsets)
=======================================================================
    Helper function to get the dimensions and offsets per real space for the
    simultaneous iteration of multiple Krylov subspaces. These parameters are
    passed to the multiplication function
    :ref:`krylov_i_real_block_multiply <krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces

        **Output Parameters:**
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Return:**
            * integer error code

krylov_get_real_block_vectors(num_spaces, full_dims, subset_dims, offsets, vectors)
===================================================================================
    Helper function to get the subspace vectors for all real Krylov subspaces in the
    simultaneous iteration. This function is used by
    :ref:`krylov_i_real_block_multiply <krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Output Parameters:**
            * ``vectors(total_size)`` : real subspace vectors for all real spaces

        **Return:**
            * integer error code

krylov_set_real_block_products(num_spaces, full_dims, subset_dims, offsets, products)
=====================================================================================
    Helper function to set the matrix-vector products for all real Krylov
    subspaces in the simultaneous iteration. This function is used by
    :ref:`krylov_i_real_block_multiply <krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimension per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space
            * ``products(total_size)`` : real matrix-vector products for all real spaces

        **Output Parameters:**
          * none

        **Return:**
            * integer error code

krylov_get_complex_block_total_size()
=====================================
   Helper function to get the total number of elements of subspace vectors over
   all complex spaces. Used in the simultaneous iteration of multiple Krylov
   subspaces. This parameter is passed to the multiplication function
   :ref:`krylov_i_complex_block_multiply <krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * number of elements of subspace vectors over all complex spaces

krylov_get_complex_block_dims(num_spaces, full_dims, subset_dims, offsets)
==========================================================================
    Helper function to get the dimensions and offsets per complex space for the
    simultaneous iteration of multiple Krylov subspaces. These parameters are
    passed to the multiplication function
    :ref:`krylov_i_complex_block_multiply <krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces

        **Output Parameters:**
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Return:**
            * integer error code

krylov_get_complex_block_vectors(num_spaces, full_dims, subset_dims, offsets, vectors)
======================================================================================
    Helper function to get the subspace vectors for all complex Krylov subspaces
    in the simultaneous iteration. This function is used by
    :ref:`krylov_i_complex_block_multiply <krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Output Parameters:**
            * ``vectors(total_size)`` :  real subspace vectors for all complex spaces

        **Return:**
            * integer error code

krylov_set_complex_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products)
====================================================================================================
    Helper function to set the matrix-vector products for all complex Krylov
    subspaces in the simultaneous iteration. This function is used by
    :ref:`krylov_i_complex_block_multiply <krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimension per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space
            * ``products(total_size)`` : real matrix-vector products for all real spaces

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

==================
Calling the Solver
==================

krylov_solve_real_equation(index, real_multiply)
================================================
    Call Krylov subspace solver on the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``real_multiply`` : matrix-vector product function, must comply with :ref:`krylov_i_real_multiply<krylov_i_real_multiply(full_dim, subset_dim, vectors, products)>` interface

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_solve_real_block_equation(real_block_multiply)
=====================================================
    Call simultaneous Krylov subspace solver of all real spaces.

        **Input Parameters:**
            * ``real_block_multiply`` : matrix-vector product function, must comply with :ref:`krylov_i_real_block_multiply<krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>` interface

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_solve_complex_equation(index, complex_multiply)
======================================================
    Call Krylov subspace solver on the given complex space.

        **Input Parameters:**
            * ``index`` : integer
            * ``complex_multiply`` : matrix-vector product function, must comply with :ref:`krylov_i_complex_multiply<krylov_i_complex_multiply(full_dim, subset_dim, vectors, products)>` interface

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

krylov_solve_complex_block_equation(complex_block_multiply)
===========================================================
    Call simultaneous Krylov subspace solver of all complex spaces.

        **Input Parameters:**
            * ``complex_block_multiply`` : matrix-vector product function, must comply with :ref:`krylov_i_complex_block_multiply<krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)>` interface

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

===================
Convergence Control
===================

krylov_get_space_num_iterations(index)
======================================
    Gets the number of iterations performed on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of iterations

krylov_get_space_iteration_basis_dim(index, iter)
=================================================
    Gets the Krylov subspace dimension in the given iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * integer subspace dimension

krylov_get_space_iteration_gram_rcond(index, iter)
==================================================
    Gets the inverse Gram (overlap) matrix condition number in the given iteration
    on the given space. Always equal to 1 in orthonormal Krylov subspace methods.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer index index

        **Output Parameters:**
            * none

        **Return:**
            * real inverse Gram matrix condition number

krylov_get_space_iteration_expectation_vals(index, iter, solution_dim, expectation_vals)
========================================================================================
    Gets expectation values of the coefficient matrix with the solution vectors
    in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``expectation_vals(solution_dim)`` : real expectation values

        **Return:**
            * integer error code

krylov_get_space_iteration_lagrangian(index, iter)
==================================================
    Gets Lagrangian in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * real Lagrangian

krylov_get_space_iteration_residual_norms(index, iter, solution_dim, residual_norms)
====================================================================================
    Get residual norms in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``residual_norms(solution_dim)`` : real residual norms

        **Return:**
            * integer error code

krylov_get_space_iteration_max_residual_norm(index, iter)
=========================================================
    Get max residual norm in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * real max residual norm

krylov_get_space_last_basis_dim(index)
======================================
    Get the number of subspace vectors in the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of subspace vectors

krylov_get_space_last_expectation_vals(index, solution_dim, last_expectation_vals)
==================================================================================
    Gets expectation values of the coefficient matrix with the solution vectors
    in the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``last_expectation_vals(solution_dim)`` : real expectation values

        **Return:**
            * integer error code

krylov_get_space_last_lagrangian(index)
=======================================
    Gets Lagrangian of the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real Lagrangian

krylov_get_space_last_residual_norms(index, solution_dim, last_residual_norms)
==============================================================================
    Get residual norms in the last iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer iteration index

        **Output Parameters:**
            * ``last_residual_norms(solution_dim)`` : real residual norms

        **Return:**
            * integer error code

krylov_get_space_last_max_residual_norm(index)
==============================================
    Get max residual norm in the last iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real max residual norm

krylov_get_space_last_gram_rcond(index)
=======================================
    Gets the inverse Gram (overlap) matrix condition number in the last iteration
    on the given space. Always equal to 1 in orthonormal Krylov subspace methods.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real inverse Gram matrix condition number

krylov_get_space_convergence(index)
===================================
    Gets convergence status of the given space as error code. See :ref:`Error
    Codes` for definitions.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

krylov_get_real_block_convergence()
===================================
    Gets convergence status of the simultaneous Krylov subspace iteration in
    real spaces. See :ref:`Error Codes` for definitions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

krylov_get_complex_block_convergence()
======================================
    Gets convergence status of the simultaneous Krylov subspace iteration in
    complex spaces. See :ref:`Error Codes` for definitions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

================================
Matrix-Vector Product Interfaces
================================

krylov_i_real_multiply(full_dim, subset_dim, vectors, products)
===============================================================
    Matrix-vector product function for a single real space. Should return
    negative error code to signal an error condition.

        **Input Parameters:**
            * ``full_dim`` : integer coefficient matrix dimension
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim,subset_dim)`` : real subspace vectors

        **Output Parameters:**
            * ``products(full_dim,subset_dim)`` : real matrix-vector products

        **Return:**
            * integer error code

krylov_i_real_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)
========================================================================================================
    Matrix-vector product function for multiple real spaces. Should return
    negative error code to signal an error condition.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``total_size`` : integer number of elements of subspace vectors over all real spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space
            * ``vectors(total_size)`` : real subspace vectors for all spaces

        **Output Parameters:**
            * ``products(total_size)`` : real matrix-vector products for all spaces

        **Return:**
            * integer error code

krylov_i_complex_multiply(full_dim, subset_dim, vectors, products)
==================================================================
    Matrix-vector product function for a single complex space. Should return
    negative error code to signal an error condition.

        **Input Parameters:**
            * ``full_dim`` : integer coefficient matrix dimension
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim,subset_dim)`` : complex subspace vectors

        **Output Parameters:**
            * ``products(full_dim,subset_dim)`` : complex matrix-vector products

        **Return:**
            * integer error code

krylov_i_complex_block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)
===========================================================================================================
    Matrix-vector product function for multiple complex spaces. Should return
    negative error code to signal an error condition.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``total_size`` : integer number of elements of subspace vectors over all complex spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space
            * ``vectors(total_size)`` : complex subspace vectors for all spaces

        **Output Parameters:**
            * ``products(total_size)`` : complex matrix-vector products

        **Return:**
            * integer error code

===========
Error Codes
===========
.. list-table::
    :widths: 25 25 25
    :header-rows: 1

    * - Error
      - Description
      - Value
    * - OK
      - Successful exit
      - 0
    * - NO_OPTIONS
      - No configuration options defined
      - -101
    * - NO_SUCH_OPTION
      - Unknown configuration option
      - -102
    * - INVALID_OPTION
      - Invalid configuration value
      - -103
    * - INVALID_KIND
      - Invalid arithmetic kind
      - -104
    * - INVALID_STRUCTURE
      - Invalid structure
      - -105
    * - INVALID_EQUATION
      - Invalid equation type
      - -106
    * - INVALID_DIMENSION
      - Invalid array dimensions
      - -107
    * - INVALID_INPUT
      - Other invalid input
      - -108
    * - NO_SPACES
      - No spaces defined
      - -201
    * - NO_SUCH_SPACE
      - Invalid space index
      - -202
    * - INCOMPATIBLE_SPACE
      - Space incompatible with function call
      - -203
    * - NOTHING_TO_DO
      - No Krylov subspaces defined
      - -204
    * - NO_ITERATIONS
      - No iterations recorded
      - -205
    * - NO_SUCH_ITERATION
      - Invalid iteration index
      - -206
    * - NO_SOLUTIONS
      - No solutions requested
      - -207
    * - NO_SUCH_SOLUTION
      - Invalid solution index
      - -208
    * - INVALID_CONFIGURATION
      - Other invalid configuration
      - -209
    * - INCOMPLETE_CONFIGURATION
      - Other missing configuration
      - -210
    * - INCOMPATIBLE_CONFIGURATION
      - Other invalid configuration
      - -211
    * - INCOMPATIBLE_EQUATION
      - Equation type incompatible with function call
      - -212
    * - INCOMPLETE_EQUATION
      - Missing equation inputs
      - -213
    * - INCOMPATIBLE_PRECONDITIONER
      - Missing preconditioner inputs
      - -214
    * - INCOMPLETE_PRECONDITIONER
      - Preconditioner incompatible with function call
      - -215
    * - INCOMPATIBLE_ORTHONORMALIZER
      - Orthonormalizer incompatible with function call
      - -216
    * - LINEAR_ALGEBRA_ERROR
      - Error in linear algebra calls
      - -301
    * - NOT_CONVERGED
      - No convergence
      - -401
    * - MAX_ITERATIONS_REACHED
      - Maximum number of iterations reached
      - -402
    * - MAX_DIM_REACHED
      - Full dimension of coefficient matrix reached
      - -403
    * - ILL_CONDITIONED
      - Ill-conditioned equation encountered
      - -404
    * - NO_BASIS_UPDATE
      - No linearly independent vectors generated
      - -405
    * - LINEARLY_DEPENDENT_BASIS
      - Linear dependence in subspace vectors
      - -406
    * - KEY_NOT_FOUND
      - Configuration key not found
      - -501
