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
echo 'using libkrylov/src/cmplx_dp_test/driver1a_cmplx_dp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) made by'  >> ../testing.summary
echo ' libkrylov/src/cmplx_dp_test/problem1b_rand_cmplx_dp' >> ../testing.summary
echo 'at zero frequency'  >> ../testing.summary
../../../src/cmplx_dp_test/problem1b_rand_cmplx_dp
rm cmplx_dp_1b_freq.json
echo 'comparing to exact solutions' >> ../testing.summary
sed '7,11!d' cmplx_dp_1b_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_dp_1b_lagr.json
rm cmplx_dp_1b_vecs.json
rm cmplx_dp_1b_npc_lagr.json
rm cmplx_dp_1b_npc_vecs.json
rm cmplx_dp_1b_apc_lagr.json
rm cmplx_dp_1b_apc_vecs.json
rm cmplx_dp_1b_dpc_lagr.json
rm cmplx_dp_1b_dpc_lagr.json
mv cmplx_dp_npc_driver1b.out cmplx_dp_npc_driver1b.out.old
echo 'solve random problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1b/cmplx_dp_npc_driver1b.out' >> ../testing.summary
echo 'none' | ../../../src/cmplx_dp_test/driver1b_cmplx_dp > cmplx_dp_npc_driver1b.out
mv cmplx_dp_1b_lagr.json cmplx_dp_1b_npc_lagr.json
mv cmplx_dp_1b_vecs.json cmplx_dp_1b_npc_vecs.json
grep 'Converged' cmplx_dp_npc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_npc_driver1b.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1b_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_apc_driver1b.out cmplx_dp_apc_driver1b.out.old
echo 'solve random problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1b/cmplx_dp_apc_driver1b.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/cmplx_dp_test/driver1b_cmplx_dp > cmplx_dp_apc_driver1b.out
mv cmplx_dp_1b_lagr.json cmplx_dp_1b_apc_lagr.json
mv cmplx_dp_1b_vecs.json cmplx_dp_1b_apc_vecs.json
grep 'Converged' cmplx_dp_apc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_apc_driver1b.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1b_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double random_b test done~~~~~'
