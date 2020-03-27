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
echo '~~~solver_subroutines_test~~~' >> ../testing.summary
mv cmplx_dp_ritz_test.out cmplx_dp_ritz_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/unit_tests/cmplx_dp_ritz_test.out' >> ../testing.summary
../../../src/real_dp_test/test_ritz_cmplx_dp >> cmplx_dp_ritz_test.out
cat cmplx_dp_ritz_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_dp_ritz_test.out >> ../testing.summary
echo '~~~~~Complex Double solver subroutine tests done~~~~~'
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
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~norms_subroutines_test~~~' >> ../testing.summary
mv cmplx_dp_norms_test.out cmplx_dp_norms_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/unit_tests/cmplx_dp_norms_test.out' >> ../testing.summary
../../../src/cmplx_dp_test/test_norms_cmplx_dp >> cmplx_dp_norms_test.out
cat cmplx_dp_norms_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_dp_norms_test.out >> ../testing.summary
echo '~~~~~Complex Double norms subroutine tests done~~~~~'
echo '~~~~~Complex Double Unit tests done~~~~~'

