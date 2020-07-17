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
echo 'using libkrylov/src/real_dp_test/driver1c_real_dp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) and freq in'  >> ../testing.summary
echo ' libkrylov/src/real_dp_ref/ref_1c/' >> ../testing.summary
echo 'comparing to exact solutions' >> ../testing.summary
echo ' freq:' >> ../testing.summary
sed '7,8!d' real_dp_1c_freq.json >> ../testing.summary
echo ' lagrangian:' >> ../testing.summary
sed '7,12!d' real_dp_1c_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm real_dp_1c_lagr.json 2>/dev/null
rm real_dp_1c_vecs.json 2>/dev/null
rm real_dp_1c_indx.json 2>/dev/null
mv real_dp_npc_driver1c.out real_dp_npc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1c/real_dp_npc_driver1c.out' >> ../testing.summary
../../../src/real_dp_test/driver1c_real_dp -precon none > real_dp_npc_driver1c.out
mv real_dp_1c_lagr.json real_dp_1c_npc_lagr.json
mv real_dp_1c_vecs.json real_dp_1c_npc_vecs.json
mv real_dp_1c_indx.json real_dp_1c_npc_indx.json
grep 'Converged' real_dp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_npc_driver1c.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_dp_1c_npc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_dp_1c_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_apc_driver1c.out real_dp_apc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1c/real_dp_apc_driver1c.out' >> ../testing.summary
../../../src/real_dp_test/driver1c_real_dp -precon approx_spectra > real_dp_apc_driver1c.out
mv real_dp_1c_lagr.json real_dp_1c_apc_lagr.json 
mv real_dp_1c_vecs.json real_dp_1c_apc_vecs.json
mv real_dp_1c_indx.json real_dp_1c_apc_indx.json
grep 'Converged' real_dp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_apc_driver1c.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_dp_1c_apc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_dp_1c_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_dpc_driver1c.out real_dp_dpc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1c/real_dp_dpc_driver1c.out' >> ../testing.summary
../../../src/real_dp_test/driver1c_real_dp -precon davidson > real_dp_dpc_driver1c.out
mv real_dp_1c_lagr.json real_dp_1c_dpc_lagr.json
mv real_dp_1c_vecs.json real_dp_1c_dpc_vecs.json
mv real_dp_1c_indx.json real_dp_1c_dpc_indx.json
grep 'Converged' real_dp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_dpc_driver1c.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_dp_1c_dpc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_dp_1c_dpc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv real_dp_spc_driver1c.out real_dp_spc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_dp_testing.results/ref_1c/real_dp_spc_driver1c.out' >> ../testing.summary
../../../src/real_dp_test/driver1c_real_dp -precon sleijpen > real_dp_spc_driver1c.out
mv real_dp_1c_lagr.json real_dp_1c_spc_lagr.json
mv real_dp_1c_vecs.json real_dp_1c_spc_vecs.json
mv real_dp_1c_indx.json real_dp_1c_spc_indx.json
grep 'Converged' real_dp_spc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_dp_spc_driver1c.out >> ../testing.summary
echo 'for frequencies:' >> ../testing.summary
sed '7,12!d' real_dp_1c_spc_indx.json >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,12!d' real_dp_1c_spc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Double reference_c test done~~~~~'
