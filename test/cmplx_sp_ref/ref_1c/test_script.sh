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
echo 'using libkrylov/src/cmplx_sp_test/driver1c_cmplx_sp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) and freq in'  >> ../testing.summary
echo ' libkrylov/src/cmplx_sp_ref/ref_1c/' >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_sp_1c_vecs.json 2>/dev/null
rm cmplx_sp_1c_indx.json 2>/dev/null
mv cmplx_sp_npc_driver1c.out cmplx_sp_npc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/ref_1c/cmplx_sp_npc_driver1c.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1c_cmplx_sp -precon none > cmplx_sp_npc_driver1c.out
mv cmplx_sp_1c_vecs.json cmplx_sp_1c_npc_vecs.json
mv cmplx_sp_1c_indx.json cmplx_sp_1c_npc_indx.json
grep 'Converged' cmplx_sp_npc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_sp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_npc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_apc_driver1c.out cmplx_sp_apc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/ref_1c/cmplx_sp_apc_driver1c.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1c_cmplx_sp -precon conjugate_gradient > cmplx_sp_apc_driver1c.out
mv cmplx_sp_1c_vecs.json cmplx_sp_1c_apc_vecs.json
mv cmplx_sp_1c_indx.json cmplx_sp_1c_apc_indx.json
grep 'Converged' cmplx_sp_apc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_sp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_apc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_dpc_driver1c.out cmplx_sp_dpc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/ref_1c/cmplx_sp_dpc_driver1c.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1c_cmplx_sp -precon davidson > cmplx_sp_dpc_driver1c.out
mv cmplx_sp_1c_vecs.json cmplx_sp_1c_dpc_vecs.json
mv cmplx_sp_1c_indx.json cmplx_sp_1c_dpc_indx.json
grep 'Converged' cmplx_sp_dpc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_sp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_dpc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_spc_driver1c.out cmplx_sp_spc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/ref_1c/cmplx_sp_spc_driver1c.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1c_cmplx_sp -precon sleijpen > cmplx_sp_spc_driver1c.out
mv cmplx_sp_1c_vecs.json cmplx_sp_1c_spc_vecs.json
mv cmplx_sp_1c_indx.json cmplx_sp_1c_spc_indx.json
grep 'Converged' cmplx_sp_spc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_sp_spc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_spc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Single reference_c test done~~~~~'
