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
echo 'using libkrylov/src/real_sp_test/test_restart_c_real_sp'  >> ../testing.summary
echo 'on the same problem as the reference test' >> ../testing.summary
echo 'with the davidson preconditioner' >> ../testing.summary
cp ../ref_1c/real_sp_1c_prob.json .
cp ../ref_1c/real_sp_1c_freq.json .
cp ../ref_1c/real_sp_1c_rhs.json .
rm real_sp_1c_lagr.json 2>/dev/null
rm real_sp_1c_vecs.json 2>/dev/null
rm real_sp_1c_indx.json 2>/dev/null
rm *.save 2>/dev/null
rm *.rstrt 2>/dev/null
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/restart_c/real_dp_c_restart_k.out' >> ../testing.summary
touch kill.libkrylov
../../../src/real_sp_test/driver1c_real_sp -irestart 4 > real_sp_c_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_c_restart_0.out real_sp_c_restart_0.out.old 2>/dev/null
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_0.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -irestart 1 > real_sp_c_restart_0.out
echo '' >> ../testing.summary
rm real_sp_1c_lagr.json
rm real_sp_1c_vecs.json
rm real_sp_1c_indx.json
mv real_sp_c_restart_1.out real_sp_c_restart_1.out.old 2>/dev/null
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_1.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -irestart 1 > real_sp_c_restart_1.out
mv real_sp_1c_lagr.json real_sp_1c_1_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_1_vecs.json
mv real_sp_1c_indx.json real_sp_1c_1_indx.json
grep 'Converged' real_sp_c_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_c_restart_1.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_sp_1c_1_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_1_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_sp_test/driver1c_real_sp -irestart 4 > real_sp_c_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_c_restart_2.out real_sp_c_restart_2.out.old 2>/dev/null
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_2.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -irestart 2 > real_sp_c_restart_2.out
mv real_sp_1c_lagr.json real_sp_1c_2_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_2_vecs.json
mv real_sp_1c_indx.json real_sp_1c_2_indx.json
grep 'Converged' real_sp_c_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_c_restart_2.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_sp_1c_2_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_2_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_sp_test/driver1c_real_sp -irestart 4 > real_sp_c_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_c_restart_3.out real_sp_c_restart_3.out.old 2>/dev/null
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_3.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -irestart 3 > real_sp_c_restart_3.out
mv real_sp_1c_lagr.json real_sp_1c_3_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_3_vecs.json
mv real_sp_1c_indx.json real_sp_1c_3_indx.json
grep 'Converged' real_sp_c_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_c_restart_3.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_sp_1c_3_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_3_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/real_sp_test/driver1c_real_sp -irestart 4> real_sp_c_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv real_sp_c_restart_4.out real_sp_c_restart_4.out.old 2>/dev/null
echo 'restart level 4' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/restart_c/real_sp_c_restart_4.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -irestart 4 > real_sp_c_restart_4.out
mv real_sp_1c_lagr.json real_sp_1c_4_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_4_vecs.json
mv real_sp_1c_indx.json real_sp_1c_4_indx.json
grep 'Converged' real_sp_c_restart_4.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_c_restart_4.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_sp_1c_4_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_4_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Single restart_c test done~~~~~'
