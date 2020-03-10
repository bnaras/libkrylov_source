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
echo 'using libkrylov/src/real_dp_test/test_restart_a_real_dp'  >> ../testing.summary
echo 'on the same problem as the reference test' 
echo 'with the davidson preconditioner' 
cp ../ref_1a/real_dp_1a_prob.json .
rm real_dp_1a_vals.json
rm real_dp_1a_vecs.json
rm *.save
rm *.rstrt
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
echo '4' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_a_restart_0.out real_dp_a_restart_0.out.old
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_c/real_dp_a_restart_0.out' >> ../testing.summary
echo '1' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_0.out
echo '' >> ../testing.summary
rm real_dp_1a_vals.json
rm real_dp_1a_vecs.json
mv real_dp_a_restart_1.out real_dp_a_restart_1.out.old
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_1.out' >> ../testing.summary
echo '1' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_1.out
mv real_dp_1a_vals.json real_dp_1a_1_vals.json
mv real_dp_1a_vecs.json real_dp_1a_1_vecs.json
grep 'Converged' real_dp_a_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_a_restart_1.out >> ../testing.summary
echo 'eigenvalues:' >> ../testing.summary
sed '7,11!d' real_dp_1a_1_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
echo '4' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_a_restart_2.out real_dp_a_restart_2.out.old
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_2.out' >> ../testing.summary
echo '2' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_2.out
mv real_dp_1a_vals.json real_dp_1a_2_vals.json
mv real_dp_1a_vecs.json real_dp_1a_2_vecs.json
grep 'Converged' real_dp_a_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_a_restart_2.out >> ../testing.summary
echo 'eigenvalues:' >> ../testing.summary
sed '7,11!d' real_dp_1a_2_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
echo '4' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_dp_a_restart_3.out real_dp_a_restart_3.out.old
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_a/real_dp_a_restart_3.out' >> ../testing.summary
echo '3' | ../../../src/real_dp_test/test_restart_a_real_dp > real_dp_a_restart_3.out
mv real_dp_1a_vals.json real_dp_1a_3_vals.json
mv real_dp_1a_vecs.json real_dp_1a_3_vecs.json
grep 'Converged' real_dp_a_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_a_restart_3.out >> ../testing.summary
echo 'eigenvalues:' >> ../testing.summary
sed '7,11!d' real_dp_1a_3_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Double restart_a test done~~~~~'
