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
echo 'using libkrylov/src/cmplx_dp_test/driver1c_cmplx_dp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) and freq in'  >> ../testing.summary
echo ' libkrylov/src/cmplx_dp_ref/ref_1c/' >> ../testing.summary
echo 'Exact Lagrangian:   -5.92007058838526778E-002' >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_dp_1c_vecs.json 2>/dev/null
rm cmplx_dp_1c_indx.json 2>/dev/null
mv cmplx_dp_npc_driver1c.out cmplx_dp_npc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1c/cmplx_dp_npc_driver1c.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1c_cmplx_dp -precon none > cmplx_dp_npc_driver1c.out
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_npc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_npc_indx.json
grep 'Converged' cmplx_dp_npc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_dp_npc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_npc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_apc_driver1c.out cmplx_dp_apc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1c/cmplx_dp_apc_driver1c.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1c_cmplx_dp -precon conjugate_gradient > cmplx_dp_apc_driver1c.out
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_apc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_apc_indx.json
grep 'Converged' cmplx_dp_apc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_dp_apc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_apc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_dpc_driver1c.out cmplx_dp_dpc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1c/cmplx_dp_dpc_driver1c.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1c_cmplx_dp -precon davidson > cmplx_dp_dpc_driver1c.out
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_dpc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_dpc_indx.json
grep 'Converged' cmplx_dp_dpc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_dp_dpc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_dpc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_spc_driver1c.out cmplx_dp_spc_driver1c.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1c/cmplx_dp_spc_driver1c.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1c_cmplx_dp -precon sleijpen > cmplx_dp_spc_driver1c.out
mv cmplx_dp_1c_vecs.json cmplx_dp_1c_spc_vecs.json
mv cmplx_dp_1c_indx.json cmplx_dp_1c_spc_indx.json
grep 'Converged' cmplx_dp_spc_driver1c.out >> ../testing.summary
grep 'Final L' cmplx_dp_spc_driver1c.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_spc_driver1c.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double reference_c test done~~~~~'
