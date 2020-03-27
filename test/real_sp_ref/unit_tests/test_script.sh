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
echo '~~~solver_subroutines_test~~~' >> ../testing.summary
mv real_sp_ritz_test.out real_sp_ritz_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/unit_tests/real_sp_ritz_test.out' >> ../testing.summary
../../../src/real_sp_test/test_ritz_real_sp >> real_sp_ritz_test.out
cat real_sp_ritz_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_sp_ritz_test.out >> ../testing.summary
echo '~~~~~Real Single solver subroutine tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~krylov_interface_subroutines_test~~~' >> ../testing.summary
mv real_sp_interface_test.out real_sp_interface_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/unit_tests/real_sp_interface_test.out' >> ../testing.summary
../../../src/real_sp_test/test_libkrylovinterface_real_sp
echo '~~~~~Real Single subroutine tests done~~~~~'
grep 'tested' real_sp_interface_test.out >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_sp_interface_test.out >> ../testing.summary
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~norms_subroutines_test~~~' >> ../testing.summary
mv real_sp_norms_test.out real_sp_norms_test.out.old
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/unit_tests/real_sp_norms_test.out' >> ../testing.summary
../../../src/real_sp_test/test_norms_real_sp >> real_sp_norms_test.out
cat real_sp_norms_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_sp_norms_test.out >> ../testing.summary
echo '~~~~~Real Single norms subroutine tests done~~~~~'
echo '~~~~~Real Single Unit tests done~~~~~'
