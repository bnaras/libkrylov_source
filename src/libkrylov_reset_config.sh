#bin/bash
if [[ $1 == "--help" ]];
then
  echo 'libkrylov reconfiguration script: reconfigure.sh'
  echo 'This script regenerates Makefile_*.am from templates,'
  echo 'runs autoreconf,'
  echo "Overwriting the repository's configuration files"
  echo 'Usage:'
  echo 'This script should be used only'
  echo 'if there is some changes to the structure of the library;'
  echo 'for example, new programs or changed file names in library.'
  echo 'do "make_custom.sh --help" to see custom driver installation help.'
  echo 'A fresh git clone is suggested if the BLAS/LAPack dependencies'
  echo 'are to be changed.'
  exit 0
fi
set -e
# check if autoconf tools are installed
if hash autoreconf 2>/dev/null;
then
  echo 'autoconf available'
else
  echo 'autoconf not available, exiting'
  exit 1
fi
if hash automake 2>/dev/null;
then
  echo 'automake available'
else
  echo 'automake not available, exiting'
  exit 1
fi
if hash libtoolize 2>/dev/null;
then
  echo 'libtool available'
else
  echo 'libtool not available, exiting'
  exit 1
fi
# Regenerate all Makefile_*.am to ensure they are consist
cat Makefile_shared.am > Makefile_mkl.am
cat Makefile_mkl_template.am >> Makefile_mkl.am
cat Makefile_shared.am > Makefile_blas.am
cat Makefile_blas_template.am >> Makefile_blas.am
cat Makefile_shared.am > Makefile_blas_free.am
cat Makefile_blas_free_template.am >> Makefile_blas_free.am
echo '----------Regenerated all Makefile.am----------'
cp configure_blas_free.ac configure.ac
cp Makefile_mkl.am Makefile.am
echo '----------copied MKL autoconf files----------'
autoreconf --verbose --install --force
cp configure configure_mkl
#repeated line, not needed
#cp libtool libtool_blas_free
cp Makefile.in Makefile_mkl.in
echo '----------autoconf for MKL done----------'
cp configure_blas.ac configure.ac
cp Makefile_blas.am Makefile.am
echo '----------copied BLAS/LAPack autoconf files----------'
autoreconf --verbose --install --force
cp configure configure_blas
#cp libtool libtool_blas
cp Makefile.in Makefile_blas.in
echo '----------autoconf for BLAS/LAPack done----------'
cp configure_blas_free.ac configure.ac
cp Makefile_blas_free.am Makefile.am
echo '----------copied BLAS-free autoconf files----------'
autoreconf --verbose --install --force
cp configure configure_blas_free
#cp libtool libtool_blas_free
cp Makefile.in Makefile_blas_free.in
echo '----------autoconf for BLAS-free done----------'
rm configure.ac
rm Makefile.am
rm configure
#rm libtool
rm Makefile.in
echo '----------cleaned out configuration files----------'
echo 'All possible autoreconf commands have been done.'
echo 'please verify your changes.'
