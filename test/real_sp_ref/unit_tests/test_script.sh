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
../../../src/real_sp_test/test_arrayfile_real_sp >> ../testing.summary
echo '~~~~~Real Single File tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~basetype_test~~~' >> ../testing.summary
mv real_sp_base_test.out real_sp_base_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/unit_tests/real_sp_base_test.out' >> ../testing.summary
../../../src/real_sp_test/test_basetypes_real_sp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_sp_base_test.out >> ../testing.summary
echo '~~~~~Real Single type(base) tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~blastype_test~~~' >> ../testing.summary
mv real_sp_blas_test.out real_sp_blas_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/unit_tests/real_sp_blas_test.out' >> ../testing.summary
../../../src/real_sp_test/test_blastypes_real_sp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_sp_blas_test.out >> ../testing.summary
echo '~~~~~Real Single type(base) array tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
#echo '~~~krylov_problem_a_subroutines_test~~~' >> ../testing.summary
#mv real_sp_krylov_a_test.out real_sp_krylov_a_test.out.old
#echo 'test output in' >> ../testing.summary
#echo 'test/real_sp_testing.results/real_sp_krylov_a_test.out' >> ../testing.summary
#../../../src/real_sp_test/test_krylovtypes_a_real_sp > real_sp_krylov_a_test.out
#echo '~~~~~Real Single subroutine tests done~~~~~'
#grep 'tested' real_sp_krylov_a_test.out >> ../testing.summary
#echo error statements: >> ../testing.summary
#grep 'failed' real_sp_krylov_a_test.out >> ../testing.summary
#echo different to reference: >> ../testing.summary
#grep 'different' real_sp_krylov_a_test.out >> ../testing.summary
#echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~~~Real Single Unit tests done~~~~~'

