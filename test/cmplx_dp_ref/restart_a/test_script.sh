#bin/bash
#this script copies referemce test results to a *.old files
#runs a driver_1* test from
#its install directory,
#comparing output to references
#in this folder
# NOTE THAT A LIBRARY MUST BE INSTALLED TO EFFECTIVELY
# TEST IT
# run ./libkrylov_quickstart.sh in the main directory
# to install what you need
#
echo '~~~test_restart_from_reference file~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/cmplx_dp_test/test_restart_a_cmplx_dp'  >> ../testing.summary
echo 'on the same problem as the reference test' >> ../testing.summary
echo 'with the davidson preconditioner' >> ../testing.summary
cp ../ref_1a/cmplx_dp_1a_prob.json .
rm cmplx_dp_1a_vals.json 2>/dev/null
rm cmplx_dp_1a_vecs.json 2>/dev/null
rm *.save 2>/dev/null
rm *.rstrt 2>/dev/null
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 4 > cmplx_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_dp_a_restart_0.out cmplx_dp_a_restart_0.out.old 2>/dev/null
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_c/cmplx_dp_a_restart_0.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 1 > cmplx_dp_a_restart_0.out
echo '' >> ../testing.summary
rm cmplx_dp_1a_vals.json
rm cmplx_dp_1a_vecs.json
mv cmplx_dp_a_restart_1.out cmplx_dp_a_restart_1.out.old 2>/dev/null
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_1.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 1 > cmplx_dp_a_restart_1.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_1_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_1_vecs.json
grep 'Converged' cmplx_dp_a_restart_1.out >> ../testing.summary
grep 'Final L' cmplx_dp_a_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_a_restart_1.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 4 > cmplx_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_dp_a_restart_2.out cmplx_dp_a_restart_2.out.old 2>/dev/null
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_2.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 2 > cmplx_dp_a_restart_2.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_2_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_2_vecs.json
grep 'Converged' cmplx_dp_a_restart_2.out >> ../testing.summary
grep 'Final L' cmplx_dp_a_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_a_restart_2.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 4 > cmplx_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_dp_a_restart_3.out cmplx_dp_a_restart_3.out.old 2>/dev/null
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/restart_a/cmplx_dp_a_restart_3.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -irestart 3 > cmplx_dp_a_restart_3.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_3_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_3_vecs.json
grep 'Converged' cmplx_dp_a_restart_3.out >> ../testing.summary
grep 'Final L' cmplx_dp_a_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_a_restart_3.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double restart_a test done~~~~~'
