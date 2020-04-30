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
../../../src/real_dp_test/test_arrayfile_real_dp >> ../testing.summary
echo '~~~~~Real Double File tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~basetype_test~~~' >> ../testing.summary
mv real_dp_base_test.out real_dp_base_test.out.old 2>/dev/null
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/unit_tests/real_dp_base_test.out' >> ../testing.summary
../../../src/real_dp_test/test_basetypes_real_dp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_dp_base_test.out >> ../testing.summary
echo '~~~~~Real Double type(base) tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~blastype_test~~~' >> ../testing.summary
mv real_dp_blas_test.out real_dp_blas_test.out.old 2>/dev/null
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/unit_tests/real_dp_blas_test.out' >> ../testing.summary
../../../src/real_dp_test/test_blastypes_real_dp >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_dp_blas_test.out >> ../testing.summary
echo '~~~~~Real Double type(base) array tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~solver_subroutines_test~~~' >> ../testing.summary
mv real_dp_ritz_test.out real_dp_ritz_test.out.old 2>/dev/null
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/unit_tests/real_dp_ritz_test.out' >> ../testing.summary
../../../src/real_dp_test/test_ritz_real_dp >> real_dp_ritz_test.out
cat real_dp_ritz_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_dp_ritz_test.out >> ../testing.summary
echo '~~~~~Real Double solver subroutine tests done~~~~~'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~krylov_interface_subroutines_test~~~' >> ../testing.summary
mv real_dp_interface_test.out real_dp_interface_test.out.old 2>/dev/null
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/real_dp_interface_test.out' >> ../testing.summary
../../../src/real_dp_test/test_libkrylovinterface_real_dp >> ../testing.summary
echo '~~~~~Real Double interface subroutine tests done~~~~~'
echo error statements: >> ../testing.summary
grep 'failed' real_dp_interface_test.out >> ../testing.summary
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' >> ../testing.summary
echo '~~~norms_subroutines_test~~~' >> ../testing.summary
mv real_dp_norms_test.out real_dp_norms_test.out.old 2>/dev/null
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/unit_tests/real_dp_norms_test.out' >> ../testing.summary
../../../src/real_dp_test/test_norms_real_dp >> real_dp_norms_test.out
cat real_dp_norms_test.sum >> ../testing.summary
echo error statements: >> ../testing.summary
grep 'failed' real_dp_norms_test.out >> ../testing.summary
echo '~~~~~Real Double norms subroutine tests done~~~~~'
echo '~~~~~Real Double Unit tests done~~~~~'
