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
echo '~~~test_solve_from_random_problem_b~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/real_sp_test/driver1a_real_sp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) made by'  >> ../testing.summary
echo ' libkrylov/src/real_sp_test/problem1b_rand_real_sp' >> ../testing.summary
echo 'at zero frequency'  >> ../testing.summary
../../../src/real_sp_test/problem1b_rand_real_sp
echo 'comparing to exact solutions' >> ../testing.summary
sed '7,11!d' real_sp_1b_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm real_sp_1b_lagr.json
rm real_sp_1b_vecs.json
mv real_sp_npc_driver1b.out real_sp_npc_driver1b.out.old
echo 'solve random problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/random_1b/real_sp_npc_driver1b.out' >> ../testing.summary
echo 'none' | ../../../src/real_sp_test/driver1b_real_sp > real_sp_npc_driver1b.out
mv real_sp_1b_lagr.json real_sp_1b_npc_lagr.json
mv real_sp_1b_vecs.json real_sp_1b_npc_vecs.json
grep 'Converged' real_sp_npc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_npc_driver1b.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' real_sp_1b_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_apc_driver1b.out real_sp_apc_driver1b.out.old
echo 'solve random problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/random_1b/real_sp_apc_driver1b.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/real_sp_test/driver1b_real_sp > real_sp_apc_driver1b.out
mv real_sp_1b_lagr.json real_sp_1b_apc_lagr.json
mv real_sp_1b_vecs.json real_sp_1b_apc_vecs.json
grep 'Converged' real_sp_apc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_apc_driver1b.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' real_sp_1b_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Single random_b test done~~~~~'
