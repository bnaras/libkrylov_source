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
echo 'using libkrylov/src/real_sp_test/driver1c_real_sp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) and freq in'  >> ../testing.summary
echo ' libkrylov/src/real_sp_ref/ref_1c/' >> ../testing.summary
echo 'Exact Lagrangian:   -7.08710551E-02' >> ../testing.summary
echo '' >> ../testing.summary
rm real_sp_1c_lagr.json 2>/dev/null
rm real_sp_1c_vecs.json 2>/dev/null
rm real_sp_1c_indx.json 2>/dev/null
mv real_sp_npc_driver1c.out real_sp_npc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/ref_1c/real_sp_npc_driver1c.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -precon none > real_sp_npc_driver1c.out
mv real_sp_1c_vecs.json real_sp_1c_npc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_npc_indx.json
grep 'Converged' real_sp_npc_driver1c.out >> ../testing.summary
grep 'Final L' real_sp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_npc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_apc_driver1c.out real_sp_apc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/ref_1c/real_sp_apc_driver1c.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -precon conjugate_gradient > real_sp_apc_driver1c.out
mv real_sp_1c_vecs.json real_sp_1c_apc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_apc_indx.json
grep 'Converged' real_sp_apc_driver1c.out >> ../testing.summary
grep 'Final L' real_sp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_apc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_dpc_driver1c.out real_sp_dpc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/ref_1c/real_sp_dpc_driver1c.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -precon davidson > real_sp_dpc_driver1c.out
mv real_sp_1c_vecs.json real_sp_1c_dpc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_dpc_indx.json
grep 'Converged' real_sp_dpc_driver1c.out >> ../testing.summary
grep 'Final L' real_sp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_dpc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv real_sp_spc_driver1c.out real_sp_spc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/real_sp_testing.results/ref_1c/real_sp_spc_driver1c.out' >> ../testing.summary
../../../src/real_sp_test/driver1c_real_sp -precon sleijpen > real_sp_spc_driver1c.out
mv real_sp_1c_vecs.json real_sp_1c_spc_vecs.json
mv real_sp_1c_indx.json real_sp_1c_spc_indx.json
grep 'Converged' real_sp_spc_driver1c.out >> ../testing.summary
grep 'Final L' real_sp_spc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' real_sp_spc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Real Single reference_c test done~~~~~'
