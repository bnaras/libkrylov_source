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
echo '~~~test_solve_from_random_problem_c~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/real_sp_test/driver1c_real_sp'  >> ../testing.summary
echo 'on random matrix problem, frequency and'  >> ../testing.summary
echo 'with right hand side (rhs) made by'  >> ../testing.summary
echo ' libkrylov/src/real_sp_test/problem1c_rand_real_sp' >> ../testing.summary
../../../src/real_sp_test/problem1c_rand_real_sp
echo 'comparing to exact solutions' >> ../testing.summary
echo 'grouped by frequency:' >> ../testing.summary
sed '7,8!d' real_sp_1c_freq.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm real_sp_1c_lagr.json
rm real_sp_1c_vecs.json
rm real_sp_1c_indx.json
mv real_sp_npc_driver1c.out real_sp_npc_driver1c.out.old
echo 'solve random problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/random_1c/real_sp_npc_driver1c.out' >> ../testing.summary
echo 'none' | ../../../src/real_sp_test/driver1c_real_sp > real_sp_npc_driver1c.out
mv real_sp_1c_lagr.json real_sp_1c_npc_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_npc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_npc_indx.json
grep 'Converged' real_sp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_npc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' real_sp_1c_npc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_apc_driver1b.out real_sp_apc_driver1b.out.old
echo 'solve random problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/random_1c/real_sp_apc_driver1c.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/real_sp_test/driver1c_real_sp > real_sp_apc_driver1c.out
mv real_sp_1c_lagr.json real_sp_1c_apc_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_apc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_apc_indx.json
grep 'Converged' real_sp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_apc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' real_sp_1c_apc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_dpc_driver1c.out real_sp_dpc_driver1c.out.old
echo 'solve random problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/random_1c/real_sp_dpc_driver1c.out' >> ../testing.summary
echo 'davidson' | ../../../src/real_sp_test/driver1c_real_sp > real_sp_dpc_driver1c.out
mv real_sp_1c_lagr.json real_sp_1c_dpc_lagr.json
mv real_sp_1c_vecs.json real_sp_1c_dpc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_dpc_indx.json
grep 'Converged' real_sp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_dpc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' real_sp_1c_dpc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_sp_1c_dpc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Single random_c test done~~~~~'
