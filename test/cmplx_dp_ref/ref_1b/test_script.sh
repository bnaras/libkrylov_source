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
echo 'using libkrylov/src/cmplx_sp_test/driver1b_cmplx_dp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) in'  >> ../testing.summary
echo ' libkrylov/src/cmplx_dp_ref/ref_1b/' >> ../testing.summary
echo 'at zero frequency'  >> ../testing.summary
echo 'Exact Lagrangian:   -5.43760403831519343E-002' >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_dp_1b_vecs.json 2>/dev/null
mv cmplx_dp_npc_driver1b.out cmplx_dp_npc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1b/cmplx_dp_npc_driver1b.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1b_cmplx_dp -precon none > cmplx_dp_npc_driver1b.out
mv cmplx_dp_1b_vecs.json cmplx_dp_1b_npc_vecs.json
grep 'Converged' cmplx_dp_npc_driver1b.out >> ../testing.summary
grep 'Final L' cmplx_dp_npc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_npc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_apc_driver1b.out cmplx_dp_apc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1b/cmplx_dp_apc_driver1b.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1b_cmplx_dp -precon conjugate_gradient > cmplx_dp_apc_driver1b.out
mv cmplx_dp_1b_vecs.json cmplx_dp_1b_apc_vecs.json
grep 'Converged' cmplx_dp_apc_driver1b.out >> ../testing.summary
grep 'Final L' cmplx_dp_apc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_apc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_spc_driver1b.out cmplx_dp_spc_driver1b.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/random_1b/cmplx_dp_spc_driver1b.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1b_cmplx_dp -precon sleijpen> cmplx_dp_spc_driver1b.out
mv cmplx_dp_1b_vecs.json cmplx_dp_1b_spc_vecs.json
grep 'Converged' cmplx_dp_spc_driver1b.out >> ../testing.summary
grep 'Final L' cmplx_dp_spc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_spc_driver1b.out >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double reference_b test done~~~~~'
