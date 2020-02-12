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
echo 'using libkrylov/src/real_dp_test/driver1a_real_dp'  >> ../testing.summary
echo 'on reference matrix problem found in'  >> ../testing.summary
echo ' libkrylov/test/real_dp_ref/ref_1a/real_dp_1a_prob.json' >> ../testing.summary
echo 'comparing to exact solutions' >> ../testing.summary
sed '7,11!d' real_dp_1a_exact_vals.json >> ../testing.summary
echo '' >> ../testing.summary
rm real_dp_1a_vals.json
rm real_dp_1a_vecs.json
rm real_dp_1a_npc_vals.json
rm real_dp_1a_npc_vecs.json
rm real_dp_1a_apc_vals.json
rm real_dp_1a_apc_vecs.json
rm real_dp_1a_dpc_vals.json
rm real_dp_1a_dpc_vecs.json
mv real_dp_npc_driver1a.out real_dp_npc_driver1a.out.old
echo 'solve for reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1a/real_dp_npc_driver1a.out' >> ../testing.summary
echo 'none' | ../../../src/real_dp_test/driver1a_real_dp > real_dp_npc_driver1a.out
mv real_dp_1a_vals.json real_dp_1a_npc_vals.json
mv real_dp_1a_vecs.json real_dp_1a_npc_vecs.json
grep 'Converged' real_dp_npc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_npc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' real_dp_1a_npc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_apc_driver1a.out real_dp_apc_driver1a.out.old
echo 'solve for reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1a/real_dp_apc_driver1a.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/real_dp_test/driver1a_real_dp > real_dp_apc_driver1a.out
mv real_dp_1a_vals.json real_dp_1a_apc_vals.json
mv real_dp_1a_vecs.json real_dp_1a_apc_vecs.json
grep 'Converged' real_dp_apc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_apc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' real_dp_1a_apc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_dpc_driver1a.out real_dp_dpc_driver1a.out.old
echo 'solve for reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1a/real_dp_dpc_driver1a.out' >> ../testing.summary
echo 'davidson' | ../../../src/real_dp_test/driver1a_real_dp > real_dp_dpc_driver1a.out
mv real_dp_1a_vals.json real_dp_1a_dpc_vals.json
mv real_dp_1a_vecs.json real_dp_1a_dpc_vecs.json
grep 'Converged' real_dp_dpc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_dpc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' real_dp_1a_dpc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Double reference tests done~~~~~'
