*****
C API
*****

The specific data type of the library arguments are set at compile type by
passing the appropriate CMake options. Please refer to the :ref:`data type
table<supported data types>` in the installation guide for the supported data
types. The data types containing ``C`` in their name correspond to the native C
types. All function declarations are contained in the ``crkylov.h`` header file.

Input scalar arguments are passed by value in public functions but by reference
in the matrix-vector product interfaces for compatibility with the Fortran API.
Input vector and matrix arguments are passed as constant pointers. Output vector
and matrix arguments are passed as pointers. All matrices are laid out in
column-major order. The matrix-vector products are passed as function pointers.
With the exception of simple getter functions, all functions return integer
error codes. The return value of 0 indicates successful exit, negative values
represent error conditions. The integer constants are listed in the :ref:`table
below <(C) Error Codes>`.

===================================
(C) Initialization and Finalization
===================================

int_t ckrylov_initialize()
==========================
    Initializes libkrylov library. Must be called first before all other
    functions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_finalize()
========================
    Frees all objects and finalizes libkrylov library. Must be call last. No
    functions must be called after the library has been finalized.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

=================
(C) Informational
=================

int_t ckrylov_get_version(char_t \*version, int_t version_len)
==============================================================
    Writes libkrylov version number into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``version`` : string version
            * ``version_len`` : integer version length

        **Return:**
            * integer error code

int_t ckrylov_get_compiled_datetime(char_t \*compiled_dt, int_t compiled_dt_len)
================================================================================
    Writes timestamp of compilation into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``compiled_dt`` : string timestamp
            * ``compiled_dt_len`` : integer timestamp length

        **Return:**
            * integer error code

int_t ckrylov_get_current_datetime(char_t \*current_dt, int_t current_dt_len)
=============================================================================
    Writes timestamp of execution into a string.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * ``current_dt`` : string timestamp
            * ``current_dt_len`` : integer timestamp length

        **Return:**
            * integer error code

int_t ckrylov_header()
======================
    Prints libkrylov header to standard output.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_tckrylov_footer()
=====================
    Prints libkrylov footer with timestamp to standard output.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

=========================
(C) Default Configuration
=========================
Configuration options of integer, real, string, logical, or enum types may be
set per space. Enum options use short strings as identifier values. Accepted
configuration options and enum values are listed below. Unknown configuration
options are silently ignored. Unknown enum values generate an error.
Default options are defined upon initialization and may be changed by the
user. Changes to default options apply only to spaces defined subsequently.
See the :ref:`(C) Space Operations` section for space-specific configuration.

Preconditioner and orthonormalizer enum options are treated specially.
The default preconditioner and orthonormalizer types can be set normally.
However, setting these options on an existing space has no effect.
For changing the preconditioner or orthonormalizer on an
existing space, use :ref:`ckrylov_set_space_preconditioner<ckrylov_set_space_preconditioner>` and
:ref:`ckrylov_set_space_orthonormalizer<ckrylov_set_space_orthonormalizer>` functions.

(C) Configuration Options
=========================

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

(C) Configuration Enum Values
=============================

+-----------------+----------+-------------------------+
|     **Key**     | **Type** |     Accepted Values     |
+=================+==========+=========================+
| preconditioner  | enum     | 'n', 'c', 'd', 'j', 'a' |
+-----------------+----------+-------------------------+
| orthonormalizer | enum     | 'o', 'n', 's'           |
+-----------------+----------+-------------------------+

int_t ckrylov_set_defaults()
============================
    Resets all configuration options to their defaults.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_integer_option(const char_t \*key, int_t key_len)
===================================================================
    Returns the default configuration value of integer option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value

int_t ckrylov_set_integer_option(const char_t \*key, int_t key_len, int_t value)
================================================================================
    Sets the default configuration value of integer option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : integer

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_string_option(const char_t \*key, int_t key_len, char_t \*value, int_t value_len)
===================================================================================================
    Writes the default configuration value of string option ``key`` to string.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Return:**
            * integer error code

int_t ckrylov_set_string_option(const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
=========================================================================================================
    Sets the default configuration value of string option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_length_string_option(const char_t \*key, int_t key_len)
=====================================================================
    Gets the length of the default configuration value for string option ``key``.
    Allocating a string of the length returned by this function ensures that
    the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer value length

real_t ckrylov_get_real_option(const char_t \*key, int_t key_len)
=================================================================
    Gets the default configuration value of real option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * real configuration value

int_t ckrylov_set_real_option(const char_t \*key, int_t key_len, real_t value)
==============================================================================
    Sets the default configuration value of real option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : real configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

bool_t ckrylov_get_logical_option(const char_t \*key, int_t key_len)
====================================================================
    Gets the default configuration value of boolean option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * boolean configuration value

int_t ckrylov_set_logical_option(const char_t \*key, int_t key_len, bool_t value)
=================================================================================
    Sets the default configuration value of boolean option ``key`` to ``value``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : boolean configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_enum_option(const char_t \*key, int_t key_len, const \*char_t value, int_t value_len)
=======================================================================================================
    Writes the default configuration value of enum option ``key`` into a string.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Return:**
            * integer error code

int_t ckrylov_set_enum_option(const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
=======================================================================================================
    Sets the default configuration value of enum option ``key`` to ``value``.
    Invalid configuration values generate an error.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_length_enum_option(const char_t \*key, int_t key_len)
===================================================================
    Gets the length of the default configuration value of enum option ``key``.
    Allocating a string of the length returned by this function ensures that
    the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer string length

int_t ckrylov_define_enum_option(const char_t \*key, int_t key_len, const char_t \*values, int_t values_len)
============================================================================================================
    Sets acceptable default configuration values of the enum configuration
    option ``key``. The acceptable values are provided in the ``values`` string
    and are semicolon-separated.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``values`` : string configuration values
            * ``values_len`` : integer length of string

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_validate_enum_option(const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
============================================================================================================
    Checks if ``value`` is an acceptable default configuration value of the enum
    configuration option ``key``.

        **Input Parameters:**
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

====================
(C) Space Operations
====================
libkrylov allows simultaneous iteration for multiple Krylov subspaces
sharing the matrix-vector product function for efficiency. The
``space`` object is the central abstraction in libkrylov and defines
the equation type, preconditioner, and orthonormalizer. Before the
solvers can be called, these parameters must be defined by calling
:ref:`ckrylov_add_space <ckrylov_add_space>`. This function returns an integer space index,
which is used to identify the space in all subsequent operations.
Mixing Krylov subspaces with different sets of parameters is possible.

.. _ckrylov_add_space:

int_t ckrylov_add_space(const char_t \*kind, int_t kind_len, const char_t \*structure, int_t structure_len, const char_t \*equation, int_t equation_len, int_t full_dim, int_t solution_dim, int_t basis_dim)
=============================================================================================================================================================================================================
    Adds new Krylov subspace solver. ``kind``, ``structure``, ``equation``,
    ``full_dim`` cannot be subsequently changed. ``solution_dim`` can be
    increased after the space was created. ``basis_dim`` is updated by the
    algorithm. This function uses default configuration options. Space-specific
    configuration can be changed for an existing space unless noted below. See
    the :ref:`quickstart guide <Quick Start for C/C++ Programmers>` for examples.

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
            * ``kind_len`` : integer kind length
            * ``structure`` : string structure of coefficient matrix
            * ``structure_len`` : integer structure length
            * ``equation`` : string equation type
            * ``equation_len`` : integer equation length
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions
            * ``basis_dim`` : integer number of starting subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * index of space created (if > 0) or error code (if < 0)

int_t ckrylov_get_num_spaces()
==============================
    Total number of spaces.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer number of spaces

int_t ckrylov_get_space_integer_option(int_t index, const char_t \*key, int_t key_len)
======================================================================================
    Returns the space-specific configuration value of integer option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value

int_t ckrylov_set_space_integer_option(int_t index, const char_t \*key, int_t key_len, int_t value)
===================================================================================================
    Sets the space-specific configuration value of integer option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : integer configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_space_string_option(int_t index, const char_t \*key, int_t key_len, char_t \*value, int_t value_len)
======================================================================================================================
    Writes the space-specific configuration value of string option ``key`` to
    string.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Return:**
            * integer error code

int_t ckrylov_set_space_string_option(int_t index, const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
============================================================================================================================
    Sets the space-specific configuration value of string option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_length_space_string_option(int_t index, const char_t \*key, int_t key_len)
========================================================================================
    Gets the length of the space-specific configuration value for string option
    ``key``. Allocating a string of the length returned by this function ensures
    that the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer configuration value length

real_t ckrylov_get_space_real_option(int_t index, const char_t \*key, int_t key_len)
====================================================================================
    Gets the space-specific configuration value of real option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * real configuration value

int_t ckrylov_set_space_real_option(int_t index, const char_t \*key, int_t key_len, real_t value)
=================================================================================================
    Sets the space-specific configuration value of real option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : real configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

bool_t ckrylov_get_space_logical_option(int_t index, const char_t \*key, int_t key_len)
=======================================================================================
    Gets the space-specific configuration value of boolean option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * boolean configuration value

int_t ckrylov_set_space_logical_option(int_t index, const char_t \*key, int_t key_len, bool_t value)
====================================================================================================
    Sets the space-specific configuration value of logical option ``key`` to
    ``value``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : boolean configuration value

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_space_enum_option(int_t index, const char_t \*key, int_t key_len, char_t value, int_t value_len)
==================================================================================================================
    Writes the space-specific configuration value of enum option ``key`` into a
    string.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Return:**
            * integer error code

int_t ckrylov_set_space_enum_option(int_t index, const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
==========================================================================================================================
    Sets the space-specific configuration value of enum option ``key`` to
    ``value``. Invalid configuration values generate an error.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_length_space_enum_option(int_t index, const char_t \*key, int_t key_len)
======================================================================================
   Gets the length of the space-specific configuration value of enum option
   ``key``. Allocating a string of the length returned by this function ensures
   that the configuration value will not be truncated in the getter function.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length

        **Output Parameters:**
            * none

        **Return:**
            * integer string length

int_t ckrylov_define_space_enum_option(int_t index, const char_t \*key, int_t key_len, const char_t \*values, int_t values_len)
===============================================================================================================================
    Sets acceptable space-specific configuration values of the enum
    configuration option ``key``. The acceptable values are provided in the
    ``values`` string and are semicolon-separated.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer length of string
            * ``values`` : string acceptable values
            * ``values_len`` : integer values length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_validate_space_enum_option(int_t index, const char_t \*key, int_t key_len, const char_t \*value, int_t value_len)
===============================================================================================================================
    Checks if ``value`` is an acceptable space-specific configuration value of
    the enum configuration option ``key``.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``key`` : string configuration key
            * ``key_len`` : integer key length
            * ``value`` : string configuration value
            * ``value_len`` : integer value length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_space_kind(int_t index, char_t \*kind, int_t kind_len)
========================================================================
    Writes arithmetic kind of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``kind`` : string arithmetic kind
            * ``kind_len`` : integer kind length

        **Return:**
            * integer error code

int_t ckrylov_get_space_structure(int_t index, char_t \*structure, int_t structure_len)
=======================================================================================
    Writes matrix structure of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``structure`` : string matrix structure
            * ``structure_len`` : integer structure length

        **Return:**
            * integer error code

int_t ckrylov_get_space_equation(int_t index, char_t \*equation, int_t equation_len)
====================================================================================
    Writes equation type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``equation`` : string equation type
            * ``equation_len`` : integer equation length

        **Return:**
            * integer error code

int_t ckrylov_get_space_preconditioner(int_t index, char_t \*preconditioner, int_t preconditioner_len)
======================================================================================================
    Writes preconditioner type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer

        **Output Parameters:**
            * ``preconditioner`` : string preconditioner type. See :ref:`available preconditioners` for definitions.
            * ``preconditioner_len`` : integer preconditioner length

        **Return:**
            * integer error code

.. _ckrylov_set_space_preconditioner:

int_t ckrylov_set_space_preconditioner(int_t index, const char_t \*preconditioner, int_t preconditioner_len)
============================================================================================================
    Resets the preconditioner type of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``preconditioner`` : string preconditioner type. See :ref:`available preconditioners` for definitions.
            * ``preconditioner_len`` : integer preconditioner length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_space_orthonormalizer(int_t index, char_t \*orthonormalizer, int_t orthonormalizer_len)
=========================================================================================================
    Writes preconditioner type of the given space into a string.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * ``orthonormalizer`` : string orthonormalizer type. See :ref:`available orthonormalizers` for definitions.
            * ``orthonormalizer_len`` : integer orthonormalizer length

        **Return:**
            * integer error code

.. _ckrylov_set_space_orthonormalizer:

int_t ckrylov_set_space_orthonormalizer(int_t index, const char_t \*orthonormalizer, int_t orthonormalizer_len)
===============================================================================================================
    Resets the orthonormalizer type of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``orthonormalizer`` : string orthonormalizer type. See :ref:`available orthonormalizers` for definitions.
            * ``orthonormalizer_len`` : integer orthonormalizer length

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_space_full_dim(int_t index)
=============================================
    Returns the coefficient matrix dimension of the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer coefficient matrix dimension

int_t ckrylov_get_space_solution_dim(int_t index)
=================================================
    Returns the number of solutions for the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of solutions

int_t ckrylov_get_space_basis_dim(int_t index)
==============================================
    Returns the number of subspace vectors in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of subspace vectors

int_t ckrylov_get_space_vector_size(int_t index)
================================================
    Returns the length (total number of elements) of the subspace vectors in the
    given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of subspace vectors

int_t ckrylov_get_space_solution_size(int_t index)
==================================================
    Returns the length (total number of elements) of the solution vectors in the given
    space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of solution vectors

int_t ckrylov_get_space_eigenvalue_size(int_t index)
====================================================
    Returns the length of the eigenvalues list in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of eigenvalue list

int_t ckrylov_get_space_rhs_size(int_t index)
=============================================
    Returns the length (total number of elements) of the right-hand side (RHS) vectors
    in the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer length of RHS vectors


int_t ckrylov_get_space_eigenvalues(int_t index, int_t solution_dim, real_t \*eigenvalues)
==========================================================================================
    Gets the eigenvalues for the given space. Returns an error if the equation
    type is not eigenvalue equation.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``eigenvalues(solution_dim)`` : real eigenvalues

        **Return:**
            * integer error code

int_t ckrylov_set_space_diagonal(int_t index, int_t full_dim, const real_t \*diagonal)
======================================================================================
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

int_t ckrylov_get_space_shifts(int_t index, int_t solution_dim, real_t \*shifts)
================================================================================
    Gets the shift parameters for shifted linear equations.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``shifts(solution_dim)`` : shift parameters

        **Return:**
            * integer error code

int_t ckrylov_set_space_shifts(int_t index, int_t solution_dim, const real_t \*shifts)
======================================================================================
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

int_T ckrylov_get_real_space_vectors(int_t index, int_t full_dim, int_t basis_dim, real_t \*vectors)
====================================================================================================
    Gets subspace vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, basis_dim)`` : real subspace vectors

        **Return:**
            * integer error code

int_t ckrylov_set_real_space_vectors(int_t index, int_t full_dim, int_t basis_dim, const real_t \*vectors)
==========================================================================================================
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

int_t ckrylov_set_real_space_vectors_from_diagonal(int_t index, int_t full_dim, int_t basis_dim, const real_t \*diagonal)
=========================================================================================================================
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

int_t ckrylov_resize_real_space_vectors(int_t index, int_t basis_dim)
=====================================================================
    Updates the number of subspace vectors in the given real space.
    Can only increase the number of subspace vectors at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_real_space_products(int_t index, int_t full_dim, int_t basis_dim, real_t \*products)
======================================================================================================
    Gets matrix-vector products of the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``products(full_dim, basis_dim)`` : real matrix-vector products

        **Return:**
            * integer error code

int_t ckrylov_get_real_space_solutions(int_t index, int_t full_dim, int_t solution_dim, const real_t \*solutions)
=================================================================================================================
    Gets solutions of the Krylov subspace algorithm for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solution

        **Output Parameters:**
            * ``solutions(full_dim, solution_dim)`` : real solutions

        **Return:**
            * integer error code

int_t ckrylov_resize_real_space_solutions(int_t index, int_t solution_dim)
==========================================================================
    Updates the number of solutions requested for the given real space.
    Can only increase the number of solutions at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_real_space_rhs(int_t index, int_t full_dim, int_t solution_dim, real_t \*rhs)
===============================================================================================
    Gets right-hand side (RHS) vectors for the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``rhs(full_dim, solution_dim)`` : real RHS

        **Return:**
            * integer error code

int_t ckrylov_set_real_space_rhs(int_t index, int_t full_dim, int_t solution_dim, const real_t \*rhs)
=====================================================================================================
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

int_t ckrylov_get_real_space_subset_vectors(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, real_t \*vectors)
============================================================================================================================
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

int_t ckrylov_set_real_space_subset_vectors(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, const real_t \*vectors)
==================================================================================================================================
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

int_t ckrylov_get_real_space_subset_products(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, real_t \*products)
==============================================================================================================================
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

int_t ckrylov_set_real_space_subset_products(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, const real_t \*products)
====================================================================================================================================
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

int_t ckrylov_get_complex_space_vectors(int_t index, int_t full_dim, int_t basis_dim, complex_t \*vectors)
==========================================================================================================
    Gets subspace vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``vectors(full_dim, basis_dim)`` : complex subspace vectors

        **Return:**
            * integer error code

int_t ckrylov_set_complex_space_vectors(int_t index, int_t full_dim, int_t basis_dim, const complex_t \*vectors)
================================================================================================================
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

int_t ckrylov_set_complex_space_vectors_from_diagonal(int_t index, int_t full_dim, int_t basis_dim, const real_t \*diagonal)
============================================================================================================================
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

int_t ckrylov_resize_complex_space_vectors(int_t index, int_t basis_dim)
========================================================================
    Updates the number of subspace vectors in the given real space.
    Can only increase the number of subspace vectors at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_complex_space_products(int_t index, int_t full_dim, int_t basis_dim, complex_t \*products)
============================================================================================================
    Gets matrix-vector products of the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``basis_dim`` : integer number of subspace vectors

        **Output Parameters:**
            * ``products(full_dim, basis_dim)`` : complex matrix-vector products

        **Return:**
            * integer error code

int_t ckrylov_get_complex_space_solutions(int_t index, int_t full_dim, int_t solution_dim, complex_t \*solutions)
=================================================================================================================
    Gets solutions of the Krylov subspace algorithm for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``solutions(full_dim, solution_dim)`` : complex solutions

        **Return:**
            * integer error code

int_t ckrylov_resize_complex_space_solutions(int_t index, int_t solution_dim)
=============================================================================
    Updates the number of solutions requested for the given complex space.
    Can only increase the number of solutions at present.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

int_t ckrylov_get_complex_space_rhs(int_t index, int_t full_dim, int_t solution_dim, complex_t \*rhs)
=====================================================================================================
    Gets right-hand side (RHS) vectors for the given complex space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``full_dim`` : integer coefficient matrix dimension
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``rhs(full_dim, solution_dim)`` : complex RHS

        **Return:**
            * integer error code

int_t ckrylov_set_complex_space_rhs(int_t index, int_t full_dim, int_t solution_dim, const complex_t \*rhs)
===========================================================================================================
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

int_t ckrylov_get_complex_space_subset_vectors(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, complex_t \*vectors)
==================================================================================================================================
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

int_t ckrylov_set_complex_space_subset_vectors(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, const complex_t \*vectors)
========================================================================================================================================
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

int_t ckrylov_get_complex_space_subset_products(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, complex_t \*products)
====================================================================================================================================
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

int_t ckrylov_set_complex_space_subset_products(int_t index, int_t full_dim, int_t skip_dim, int_t subset_dim, const complex_t \*products)
==========================================================================================================================================
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

====================
(C) Block Operations
====================

int_t ckrylov_get_real_block_total_size()
=========================================
   Helper function to get the total number of elements of subspace vectors over
   all real spaces. Used in the simultaneous iteration of multiple Krylov
   subspaces. This parameter is passed to the multiplication function
   :ref:`real_block_multiply`.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * number of elements of subspace vectors over all real spaces

int_t ckrylov_get_real_block_dims(int_t num_spaces, int_t \*full_dims, int_t \*subset_dims, int_t \*offsets)
============================================================================================================
    Helper function to get the dimensions and offsets per real space for the
    simultaneous iteration of multiple Krylov subspaces. These parameters are
    passed to the multiplication function :ref:`real_block_multiply <real_block_multiply>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces

        **Output Parameters:**
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Return:**
            * integer error code

int_t ckrylov_get_real_block_vectors(int_t num_spaces, int_t total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, real_t \*vectors)
=====================================================================================================================================================================
    Helper function to get the subspace vectors for all real Krylov subspaces in the
    simultaneous iteration. This function is used by :ref:`real_block_multiply <real_block_multiply>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Output Parameters:**
            * ``vectors(total_size)`` : real subspace vectors for all real spaces

        **Return:**
            * integer error code

int_t ckrylov_set_real_block_products(int_t num_spaces, int_t total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, const real_t \*products)
=============================================================================================================================================================================
    Helper function to set the matrix-vector products for all real Krylov
    subspaces in the simultaneous iteration. This function is used by :ref:`real_block_multiply <real_block_multiply>`.

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

int_t ckrylov_get_complex_block_total_size()
============================================
   Helper function to get the total number of elements of subspace vectors over
   all complex spaces. Used in the simultaneous iteration of multiple Krylov
   subspaces. This parameter is passed to the multiplication function
   :ref:`complex_block_multiply <complex_block_multiply>`.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * number of elements of subspace vectors over all complex spaces

int_t ckrylov_get_complex_block_dims(int_t num_spaces, int_t \*full_dims, int_t \*subset_dims, int_t \*offsets)
===============================================================================================================
    Helper function to get the dimensions and offsets per complex space for the
    simultaneous iteration of multiple Krylov subspaces. These parameters are
    passed to the multiplication function
    :ref:`complex_block_multiply <complex_block_multiply>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces

        **Output Parameters:**
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Return:**
            * integer error code

int_t ckrylov_get_complex_block_vectors(int_t num_spaces, int_t total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, complex_t \*vectors)
===========================================================================================================================================================================
    Helper function to get the subspace vectors for all complex Krylov subspaces
    in the simultaneous iteration. This function is used by
    :ref:`complex_block_multiply <complex_block_multiply>`.

        **Input Parameters:**
            * ``num_spaces`` : integer number of spaces
            * ``full_dims(num_spaces)`` : integer coefficient matrix dimensions per space
            * ``subset_dims(num_spaces)`` : integer number of subspace vectors per space
            * ``offsets(num_spaces)`` : integer offsets per space

        **Output Parameters:**
            * ``vectors(total_size)`` :  real subspace vectors for all complex spaces

        **Return:**
            * integer error code

int_t ckrylov_set_complex_block_products(int_t num_spaces, int_t total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, complex_t \*products)
=============================================================================================================================================================================
    Helper function to set the matrix-vector products for all complex Krylov
    subspaces in the simultaneous iteration. This function is used by
    :ref:`complex_block_multiply <complex_block_multiply>`.

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

======================
(C) Calling the Solver
======================

ckrylov_solve_real_equation(int_t index, int_t (\*real_multiply)(const int_t \*full_dim, const int_t \*subset_dim, const real_t \*vectors, real_t \*products))
==============================================================================================================================================================
    Call Krylov subspace solver on the given real space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``real_multiply`` :  matrix-vector product function, must comply with :ref:`real_multiply<real_multiply>`

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

.. _ckrylov_i_real_block_multiply:

ckrylov_solve_real_block_equation(int_t (\*real_block_multiply)(const int_t \*num_spaces, const int_t \*total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, const real_t \*vectors, real_t \*products))
==========================================================================================================================================================================================================================================
    Call simultaneous Krylov subspace solver of all real spaces.

        **Input Parameters:**
            * ``real_block_multiply`` : matrix-vector product function, must comply with :ref:`real_block_multiply<real_block_multiply>`

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

ckrylov_solve_complex_equation(int_t index, int_t (\*complex_multiply)(const int_t \*full_dim, const int_t \*subset_tim, const complex_t \*vectors, complex_t \*products))
==========================================================================================================================================================================
    Call Krylov subspace solver on the given complex space.

        **Input Parameters:**
            * ``index`` : integer
            * ``complex_multiply`` : matrix-vector product function, must comply with :ref:`complex_multiply<complex_multiply>`

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

ckrylov_solve_complex_block_equation(int_t (\*complex_block_multiply)(const int_t \*num_spaces, const int_t \*total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, const complex_t \*vectors, complex_t \*products))
======================================================================================================================================================================================================================================================
    Call simultaneous Krylov subspace solver of all complex spaces.

        **Input Parameters:**
            * ``complex_block_multiply`` :  matrix-vector product function, must comply with :ref:`complex_block_multiply<complex_block_multiply>`

        **Output Parameters:**
            * none

        **Return:**
            * integer error code

=======================
(C) Convergence Control
=======================

int_t ckrylov_get_space_num_iterations(int_t index)
===================================================
    Gets the number of iterations performed on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of iterations

int_t ckrylov_get_space_iteration_basis_dim(int_t index, int_t iter)
====================================================================
    Gets the Krylov subspace dimension in the given iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * integer subspace dimension

real_t ckrylov_get_space_iteration_gram_rcond(int_t index, int_t iter)
======================================================================
    Gets the inverse Gram (overlap) matrix condition number in the given iteration
    on the given space. Always equal to 1 in orthonormal Krylov subspace methods.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer index index

        **Output Parameters:**
            * none

        **Return:**
            * real inverse Gram matrix condition number

int_t ckrylov_get_space_iteration_expectation_vals(int_t index, int_t iter, int_t solution_dim, real_t \*expectation_vals)
==========================================================================================================================
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

real_t ckrylov_get_space_iteration_lagrangian(int_t index, int_t iter)
======================================================================
    Gets Lagrangian in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * real Lagrangian

int_t ckrylov_get_space_iteration_residual_norms(int_t index, int_t iter,int_t solution_dim, real_t \*residual_norms)
=====================================================================================================================
    Get residual norms in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``residual_norms(solution_dim)`` : real residual norms

        **Return:**
            * integer error code

real_t ckrylov_get_space_iteration_max_residual_norm(int_t index, int_t iter)
=============================================================================
    Get max residual norm in the given iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``iter`` : integer iteration index

        **Output Parameters:**
            * none

        **Return:**
            * real max residual norm

int_t ckrylov_get_space_last_basis_dim(int_t index)
===================================================
    Get the number of subspace vectors in the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer number of subspace vectors

int_t ckrylov_get_space_last_expectation_vals(int_t index, int_t solution_dim, real_t \*expectation_vals)
=========================================================================================================
    Gets expectation values of the coefficient matrix with the solution vectors
    in the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer number of solutions

        **Output Parameters:**
            * ``last_expectation_vals(solution_dim)`` : real expectation values

        **Return:**
            * integer error code

real_t ckrylov_get_space_last_lagrangian(int_t index)
=====================================================
    Gets Lagrangian of the last iteration on the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real Lagrangian

int_t ckrylov_get_space_last_residual_norms(int_t index, int_t solution_dim, real_t \*residual_norms)
=====================================================================================================
    Get residual norms in the last iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index
            * ``solution_dim`` : integer iteration index

        **Output Parameters:**
            * ``last_residual_norms(solution_dim)`` : real residual norms

        **Return:**
            * integer error code

real_t ckrylov_get_space_last_max_residual_norm(int_t index)
============================================================
    Get max residual norm in the last iteration of the given space.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real max residual norm

real_t ckrylov_get_space_last_gram_rcond(int_t index)
=====================================================
    Gets the inverse Gram (overlap) matrix condition number in the last iteration
    on the given space. Always equal to 1 in orthonormal Krylov subspace methods.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * real inverse Gram matrix condition number

int_t ckrylov_get_space_convergence(int_t index)
================================================
    Gets convergence status of the given space as error code. See :ref:`(C) Error Codes`
    for definitions.

        **Input Parameters:**
            * ``index`` : integer space index

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

int_t ckrylov_get_real_block_convergence()
==========================================
    Gets convergence status of the simultaneous Krylov subspace iteration in
    real spaces. See :ref:`(C) Error Codes` for definitions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

int_t ckrylov_get_complex_block_convergence()
=============================================
    Gets convergence status of the simultaneous Krylov subspace iteration in
    complex spaces. See :ref:`(C) Error Codes` for definitions.

        **Input Parameters:**
            * none

        **Output Parameters:**
            * none

        **Return:**
            * integer convergence status

===================================
(C) Matrix-Vector Product Functions
===================================

.. _real_multiply:

int_t (\*real_multiply)(const int_t \*full_dim, const int_t \*subset_dim, const real_t \*vectors, real_t \*products)
====================================================================================================================
    Matrix-vector product function pointer for a single real space. Should
    return negative error code to signal an error condition.

        **Input Parameters:**
            * ``full_dim`` : integer coefficient matrix dimension
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim,subset_dim)`` : real subspace vectors

        **Output Parameters:**
            * ``products(full_dim,subset_dim)`` : real matrix-vector products

        **Return:**
            * integer error code

.. _real_block_multiply:

int_t (\*real_block_multiply)(const int_t \*num_spaces, const int_t \*total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, const real_t \*vectors, real_t \*products)
=======================================================================================================================================================================================================
    Matrix-vector product function pointer for multiple real spaces. Should
    return negative error code to signal an error condition.

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

.. _complex_multiply:

int_t (\*complex_multiply)(const int_t \*full_dim, const int_t \*subset_tim, const complex_t \*vectors, complex_t \*products)
=============================================================================================================================
    Matrix-vector product function pointer for a single complex space. Should
    return negative error code to signal an error condition.

        **Input Parameters:**
            * ``full_dim`` : integer coefficient matrix dimension
            * ``subset_dim`` : integer number of subspace vectors
            * ``vectors(full_dim,subset_dim)`` : complex subspace vectors

        **Output Parameters:**
            * ``products(full_dim,subset_dim)`` : complex matrix-vector products

        **Return:**
            * integer error code

.. _complex_block_multiply:

int_t (\*complex_block_multiply)(const int_t \*num_spaces, const int_t \*total_size, const int_t \*full_dims, const int_t \*subset_dims, const int_t \*offsets, const complex_t \*vectors, complex_t \*products)
================================================================================================================================================================================================================
    Matrix-vector product function pointer for multiple complex spaces. Should
    return negative error code to signal an error condition.

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

===============
(C) Error Codes
===============
.. list-table::
    :widths: 25 25
    :header-rows: 1

    * - Error
      - Description
    * - OK
      - Successful exit
    * - CKRYLOV_NO_OPTIONS
      - No configuration options defined
    * - CKRYLOV_NO_SUCH_OPTION
      - Unknown configuration option
    * - CKRYLOV_INVALID_OPTION
      - Invalid configuration value
    * - CKRYLOV_INVALID_KIND
      - Invalid arithmetic kind
    * - CKRYLOV_INVALID_STRUCTURE
      - Invalid structure
    * - CKRYLOV_INVALID_EQUATION
      - Invalid equation type
    * - CKRYLOV_INVALID_DIMENSION
      - Invalid array dimensions
    * - CKRYLOV_INVALID_INPUT
      - Other invalid input
    * - CKRYLOV_NO_SPACES
      - No spaces defined
    * - CKRYLOV_NO_SUCH_SPACE
      - Invalid space index
    * - CKRYLOV_INCOMPATIBLE_SPACE
      - Space incompatible with function call
    * - CKRYLOV_NOTHING_TO_DO
      - No Krylov subspaces defined
    * - CKRYLOV_NO_ITERATIONS
      - No iterations recorded
    * - CKRYLOV_NO_SUCH_ITERATION
      - Invalid iteration index
    * - CKRYLOV_NO_SOLUTIONS
      - No solutions requested
    * - CKRYLOV_NO_SUCH_SOLUTION
      - Invalid solution index
    * - CKRYLOV_INVALID_CONFIGURATION
      - Other invalid configuration
    * - CKRYLOV_INCOMPLETE_CONFIGURATION
      - Other missing configuration
    * - CKRYLOV_INCOMPATIBLE_CONFIGURATION
      - Other invalid configuration
    * - CKRYLOV_INCOMPATIBLE_EQUATION
      - Equation type incompatible with function call
    * - CKRYLOV_INCOMPLETE_EQUATION
      - Missing equation inputs
    * - CKRYLOV_INCOMPATIBLE_PRECONDITIONER
      - Missing preconditioner inputs
    * - CKRYLOV_INCOMPLETE_PRECONDITIONER
      - Preconditioner incompatible with function call
    * - CKRYLOV_INCOMPATIBLE_ORTHONORMALIZER
      - Orthonormalizer incompatible with function call
    * - CKRYLOV_LINEAR_ALGEBRA_ERROR
      - Error in linear algebra calls
    * - CKRYLOV_NOT_CONVERGED
      - No convergence
    * - CKRYLOV_MAX_ITERATIONS_REACHED
      - Maximum number of iterations reached
    * - CKRYLOV_MAX_DIM_REACHED
      - Full dimension of coefficient matrix reached
    * - CKRYLOV_ILL_CONDITIONED
      - Ill-conditioned equation encountered
    * - CKRYLOV_NO_BASIS_UPDATE
      - No linearly independent vectors generated
    * - CKRYLOV_LINEARLY_DEPENDENT_BASIS
      - Linear dependence in subspace vectors
    * - CKRYLOV_KEY_NOT_FOUND
      - Configuration key not found
