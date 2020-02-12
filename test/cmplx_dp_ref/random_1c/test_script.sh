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
echo 'using libkrylov/src/cmplx_dp_test/driver1c_cmplx_dp'  >> ../testing.summary
echo 'on random matrix problem, frequency and'  >> ../testing.summary
echo 'with right hand side (rhs) made by'  >> ../testing.summary
echo ' libkrylov/src/cmplx_dp_test/problem1c_rand_cmplx_dp' >> ../testing.summary
../../../src/cmplx_dp_test/problem1c_rand_cmplx_dp
echo 'comparing to exact solutions' >> ../testing.summary
echo 'grouped by frequency:' >> ../testing.summary
sed '7,8!d' cmplx_dp_1c_freq.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_dp_1c_lagr.json
rm cmplx_dp_1c_vecs.json
rm cmplx_dp_1c_indx.json
mv cmplx_dp_npc_driver1c.out cmplx_dp_npc_driver1c.out.old
echo 'solve random problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1c/cmplx_dp_npc_driver1c.out' >> ../testing.summary
echo 'none' | ../../../src/cmplx_dp_test/driver1c_cmplx_dp > cmplx_dp_npc_driver1c.out
mv cmplx_dp_1c_lagr.json cmplx_dp_1c_npc_lagr.json
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_npc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_npc_indx.json
grep 'Converged' cmplx_dp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_npc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_npc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_apc_driver1c.out cmplx_dp_apc_driver1c.out.old
echo 'solve random problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1c/cmplx_dp_apc_driver1c.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/cmplx_dp_test/driver1c_cmplx_dp > cmplx_dp_apc_driver1c.out
mv cmplx_dp_1c_lagr.json cmplx_dp_1c_apc_lagr.json
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_apc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_apc_indx.json
grep 'Converged' cmplx_dp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_apc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_apc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_dpc_driver1c.out cmplx_dp_dpc_driver1c.out.old
echo 'solve random problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1c/cmplx_dp_dpc_driver1c.out' >> ../testing.summary
echo 'davidson' | ../../../src/cmplx_dp_test/driver1c_cmplx_dp > cmplx_dp_dpc_driver1c.out
mv cmplx_dp_1c_lagr.json cmplx_dp_1c_dpc_lagr.json
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_dpc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_dpc_indx.json
grep 'Converged' cmplx_dp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_dpc_driver1c.out >> ../testing.summary
echo 'frequency:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_dpc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' cmplx_dp_1c_dpc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double random_c test done~~~~~'
