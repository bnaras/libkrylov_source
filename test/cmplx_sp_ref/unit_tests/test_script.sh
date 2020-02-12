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
../../../src/cmplx_sp_test/test_arrayfile_cmplx_sp >> ../testing.summary
echo '~~~~~Complex Single File tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~basetype_test~~~' >> ../testing.summary
mv cmplx_sp_base_test.out cmplx_sp_base_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/unit_tests/cmplx_sp_base_test.out' >> ../testing.summary
../../../src/cmplx_sp_test/test_basetypes_cmplx_sp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_sp_base_test.out >> ../testing.summary
echo '~~~~~Complex Single type(base) tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~blastype_test~~~' >> ../testing.summary
mv cmplx_sp_blas_test.out cmplx_sp_blas_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/unit_tests/cmplx_sp_blas_test.out' >> ../testing.summary
../../../src/cmplx_sp_test/test_blastypes_cmplx_sp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' cmplx_sp_blas_test.out >> ../testing.summary
echo '~~~~~Complex Single type(base) array tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
#echo '~~~krylov_problem_a_subroutines_test~~~' >> ../testing.summary
#mv cmplx_sp_krylov_a_test.out cmplx_sp_krylov_a_test.out.old
#echo 'test output in' >> ../testing.summary
#echo 'test/cmplx_sp_testing.results/cmplx_sp_krylov_a_test.out' >> ../testing.summary
#../../../src/cmplx_sp_test/test_krylovtypes_a_cmplx_sp > cmplx_sp_krylov_a_test.out
#echo '~~~~~Complex Single subroutine tests done~~~~~'
#grep 'tested' cmplx_sp_krylov_a_test.out >> ../testing.summary
#echo error statements: >> ../testing.summary
#grep 'failed' cmplx_sp_krylov_a_test.out >> ../testing.summary
#echo different to reference: >> ../testing.summary
#grep 'different' cmplx_sp_krylov_a_test.out >> ../testing.summary
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~~~Complex Single Unit tests done~~~~~'

