#bin/bash
#this script copies unit test results to a *.old files
#runs all the unit tests from
#their install directory,
#comparing output to references
#in this folder
# NOTE THAT A LIBRARY MUST BE INSTALLED TO EFFECTIVELY
# TEST IT
# run ./quickstart.sh in the main directory
# to install what you need
#
echo '~~~file_test~~~' >> ../testing.summary
../../../src/cmplx_dp_test/test_arrayfile_cmplx_dp >> ../testing.summary
echo '~~~~~Complex Double File tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~basetype_test~~~' >> ../testing.summary
mv cmplx_dp_base_test.out cmplx_dp_base_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/unit_tests/cmplx_dp_base_test.out' >> ../testing.summary
../../../src/cmplx_dp_test/test_basetypes_cmplx_dp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_dp_base_test.out >> ../testing.summary
echo '~~~~~Complex Double type(base) tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~blastype_test~~~' >> ../testing.summary
mv cmplx_dp_blas_test.out cmplx_dp_blas_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/unit_tests/cmplx_dp_blas_test.out' >> ../testing.summary
../../../src/cmplx_dp_test/test_blastypes_cmplx_dp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_dp_blas_test.out >> ../testing.summary
echo '~~~~~Complex Double type(base) array tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~krylov_interface_subroutines_test~~~' >> ../testing.summary
mv cmplx_dp_interface_test.out cmplx_dp_interface_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/cmplx_dp_interface_test.out' >> ../testing.summary
../../../src/cmplx_dp_test/test_libkrylovinterface_cmplx_dp 
echo '~~~~~Complex Double subroutine tests done~~~~~'
grep 'tested' cmplx_dp_interface_test.out >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_dp_interface_test.out >> ../testing.summary
#echo different to reference: >> ../testing.summary
#grep 'different' cmplx_dp_krylov_a_test.out >> ../testing.summary
#echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~~~Complex Double Unit tests done~~~~~'

