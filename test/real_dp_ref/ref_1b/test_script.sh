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
echo '~~~test_solve_from_reference file~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/real_dp_test/driver1b_real_dp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) in'  >> ../testing.summary
echo ' libkrylov/src/real_dp_ref/ref_1b/' >> ../testing.summary
echo 'at zero frequency'  >> ../testing.summary
echo 'comparing to exact lagrangians' >> ../testing.summary
sed '7,9!d' real_dp_1b_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm real_dp_1b_vecs.json 2>/dev/null
mv real_dp_npc_driver1b.out real_dp_npc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/random_1b/real_dp_npc_driver1b.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -precon none > real_dp_npc_driver1b.out
mv real_dp_1b_vecs.json real_dp_1b_npc_vecs.json
grep 'Converged' real_dp_npc_driver1b.out >> ../testing.summary
grep 'Final Lagrangian' real_dp_npc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_npc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_apc_driver1b.out real_dp_apc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/random_1b/real_dp_apc_driver1b.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -precon conjugate_gradient > real_dp_apc_driver1b.out
mv real_dp_1b_vecs.json real_dp_1b_apc_vecs.json
grep 'Converged' real_dp_apc_driver1b.out >> ../testing.summary
grep 'Final Lagrangian' real_dp_apc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_apc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_spc_driver1b.out real_dp_spc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/random_1b/real_dp_spc_driver1b.out' >> ../testing.summary
../../../src/real_dp_test/driver1b_real_dp -precon sleijpen > real_dp_spc_driver1b.out
mv real_dp_1b_vecs.json real_dp_1b_spc_vecs.json
grep 'Converged' real_dp_spc_driver1b.out >> ../testing.summary
grep 'Final Lagrangian' real_dp_spc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_spc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Double reference_b test done~~~~~'
