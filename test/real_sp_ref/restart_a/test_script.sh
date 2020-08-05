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
echo 'using libkrylov/src/real_sp_test/test_restart_a_real_sp'  >> ../testing.summary
echo 'on the same problem as the reference test' >> ../testing.summary
echo 'with the davidson preconditioner' >> ../testing.summary
cp ../ref_1a/real_sp_1a_prob.json .
rm real_sp_1a_vals.json 2>/dev/null
rm real_sp_1a_vecs.json 2>/dev/null
rm *.save 2>/dev/null
rm *.rstrt 2>/dev/null
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
../../../src/real_sp_test/driver1a_real_sp -irestart 4  > real_sp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_a_restart_0.out real_sp_a_restart_0.out.old 2>/dev/null
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_a_restart_0.out' >> ../testing.summary
../../../src/real_sp_test/driver1a_real_sp -irestart 1 > real_sp_a_restart_0.out
echo '' >> ../testing.summary
rm real_sp_1a_vals.json
rm real_sp_1a_vecs.json
mv real_sp_a_restart_1.out real_sp_a_restart_1.out.old 2>/dev/null
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_1.out' >> ../testing.summary
../../../src/real_sp_test/driver1a_real_sp -irestart 1 > real_sp_a_restart_1.out
mv real_sp_1a_vals.json real_sp_1a_1_vals.json
mv real_sp_1a_vecs.json real_sp_1a_1_vecs.json
grep 'Converged' real_sp_a_restart_1.out >> ../testing.summary
grep 'Final L' real_sp_a_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_a_restart_1.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_sp_test/driver1a_real_sp -irestart 4 > real_sp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_a_restart_2.out real_sp_a_restart_2.out.old 2>/dev/null
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_2.out' >> ../testing.summary
../../../src/real_sp_test/driver1a_real_sp -irestart 2 > real_sp_a_restart_2.out
mv real_sp_1a_vals.json real_sp_1a_2_vals.json
mv real_sp_1a_vecs.json real_sp_1a_2_vecs.json
grep 'Converged' real_sp_a_restart_2.out >> ../testing.summary
grep 'Final L' real_sp_a_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_a_restart_2.out >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_sp_test/driver1a_real_sp -irestart 4 > real_sp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_a_restart_3.out real_sp_a_restart_3.out.old 2>/dev/null
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_a/real_sp_a_restart_3.out' >> ../testing.summary
../../../src/real_sp_test/driver1a_real_sp -irestart 3 > real_sp_a_restart_3.out
mv real_sp_1a_vals.json real_sp_1a_3_vals.json
mv real_sp_1a_vecs.json real_sp_1a_3_vecs.json
grep 'Converged' real_sp_a_restart_3.out >> ../testing.summary
grep 'Final L' real_sp_a_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_a_restart_3.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Single restart_a test done~~~~~'
