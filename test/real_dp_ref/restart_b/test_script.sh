#bin/bash
#this script copies referemce test results to a *.old files
#runs a driver_1* test from
#its install directory,
#comparing output to references
#in this folder
# NOTE THAT A LIBRARY MUST BE INSTALLED TO EFFECTIVELY
# TEST IT
# run ./quickstart.sh in the main directory
# to install what you need
#
echo '~~~test_restart_from_reference file~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/real_dp_test/test_restart_b_real_dp'  >> ../testing.summary
echo 'on the same problem as the reference test' >> ../testing.summary
echo 'with the approximate spectra preconditioner' >> ../testing.summary
cp ../ref_1b/real_dp_1b_prob.json .
cp ../ref_1b/real_dp_1b_rhs.json .
rm real_dp_1b_vecs.json 2>/dev/null
rm *.save 2>/dev/null
rm *.rstrt 2>/dev/null
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
../../../src/real_dp_test/driver1b_real_dp -irestart 4 > real_dp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_b_restart_0.out real_dp_b_restart_0.out.old 2>/dev/null
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_0.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -irestart 1 > real_dp_b_restart_0.out
echo '' >> ../testing.summary
rm real_dp_1b_vecs.json
mv real_dp_b_restart_1.out real_dp_b_restart_1.out.old 2>/dev/null
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_1.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -irestart 1 > real_dp_b_restart_1.out
mv real_dp_1b_vecs.json real_dp_1b_1_vecs.json
grep 'Converged' real_dp_b_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_b_restart_1.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_dp_test/driver1b_real_dp -irestart 4 > real_dp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_b_restart_2.out real_dp_b_restart_2.out.old 2>/dev/null
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_2.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -irestart 2 > real_dp_b_restart_2.out
mv real_dp_1b_vecs.json real_dp_1b_2_vecs.json
grep 'Converged' real_dp_b_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_b_restart_2.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_dp_test/driver1b_real_dp -irestart 4 > real_dp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_b_restart_3.out real_dp_b_restart_3.out.old 2>/dev/null
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_3.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -irestart 3 > real_dp_b_restart_3.out
mv real_dp_1b_vecs.json real_dp_1b_3_vecs.json
grep 'Converged' real_dp_b_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_b_restart_3.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_dp_test/driver1b_real_dp -irestart 4 > real_dp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_b_restart_4.out real_dp_b_restart_4.out.old 2>/dev/null
echo 'restart level 4' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_b/real_dp_b_restart_4.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -irestart 4 > real_dp_b_restart_4.out
mv real_dp_1b_vecs.json real_dp_1b_4_vecs.json
grep 'Converged' real_dp_b_restart_4.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_b_restart_4.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Double restart_b test done~~~~~'
