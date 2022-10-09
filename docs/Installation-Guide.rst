Installation Guide
******************

Libkrylov is written in standard Fortran 2003/C99 and built using CMake. In
order to build and install the library, you will need the following tools.

- `CMake <http://cmake.org/>`_, version 3.5 or higher.
- `GNU Make <https://www.gnu.org/software/make/>`_ or `Ninja <https://ninja-build.org/>`_
  as a primary build tool.
- Fortran 2003/C99 compiler. This source code was tested with the
  `GNU Fortran compiler <https://gcc.gnu.org/fortran/>`_, version 9, 10, and
  `Intel Fortran Compiler Classic <https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/fortran-compiler.html>`_,
  version 2021.1.
- `BLAS <http://www.netlib.org/blas/>`_ and `LAPACK <http://www.netlib.org/lapack/>`_-compatible
  linear algebra libraries. See
  `CMake documentation <https://cmake.org/cmake/help/latest/module/FindBLAS.html#blas-lapack-vendors>`_
  for the list of supported BLAS/LAPACK vendors.

====================
Building from Source
====================

CMake supports out-of-source builds, in which the binary artifacts are generated
in a separate directory, usually called ``build``. The build and installation
process is as follows.

- Create a ``build`` subdirectory in the root of the libkrylov repository
  and change into it,
  ``mkdir build && cd build``
- Call ``cmake`` to generate the build files,
  ``cmake ..`` or ``cmake -G Ninja ..`` to use Ninja. This will generate the build
  files for the build tool, GNU Make or Ninja. Note the ``..`` argument, which
  points to the root of the libkrylov repository.
- Different build types can be specified
  ``-DCMAKE_BUILD_TYPE=<TYPE>``, for example, ``Debug``, or ``Release``. If the
  build type is ``Debug``, additional compiler flags for debugging are enabled.
  See `CMake documentation`
  for more details.
- Compile the source using CMake by running ``cmake --build .`` or by directly
  calling the build tool, for example, ``make`` or ``ninja``. Note that here the ``.``
  directory argument points to the build directory.
- Run the test suite by calling ``ctest`` from the build directory.
  The tests are simply a collection of Fortran/C programs in the ``tests``
  subdirectory that can be run individually.
- Install the compiled library under the prefix ``<DEST>`` by using
  ``cmake --install . --prefix <DEST>``. The library will be under ``<DEST>/lib``.

====================
Supported Data Types
====================

The data types of libkrylov are completely configurable at compilation time.
The configuration variables are passed to the CMake call, for example,
``cmake -DINTEGER_KIND=<INT> -DREAL_KIND=<REAL> -DCOMPLEX_KIND=<COMPLEX> -DCHARACTER_KIND=<CHAR> -DLOGICAL_KIND=<BOOL> ..``.
The available kinds are summarized in the following table.

+--------------+----------------------+---------------------------+---------------+-------------+
| **integer**  | **real**             | **complex**               | **character** | **logical** |
+==============+======================+===========================+===============+=============+
| ``INT32``    | ``REAL32``           | ``COMPLEX32``             |               |             |
+--------------+----------------------+---------------------------+---------------+-------------+
| ``INT64*``   | ``REAL64*``          | ``COMPLEX64*``            |               |             |
+--------------+----------------------+---------------------------+---------------+-------------+
|              | ``REAL128``          | ``COMPLEX128``            |               |             |
+--------------+----------------------+---------------------------+---------------+-------------+
| ``C_INT``    | ``C_FLOAT``          | ``COMPLEX_C_FLOAT``       | ``C_CHAR``    | ``C_BOOL``  |
+--------------+----------------------+---------------------------+---------------+-------------+
| ``C_FLOAT``  | ``COMPLEX_C_DOUBLE`` | ``COMPLEX_C_DOUBLE``      |               |             |
+--------------+----------------------+---------------------------+---------------+-------------+
| ``C_DOUBLE`` | ``C_LONG_DOUBLE``    | ``COMPLEX_C_LONG_DOUBLE`` |               |             |
+--------------+----------------------+---------------------------+---------------+-------------+

The default data types are marked with an asterisk. The types having ``C`` in their names are included
for calling from C/C++ and correspond to the native C types. Note that native BLAS/LAPACK libraries are not
available for all numerical types.

