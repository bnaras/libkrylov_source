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
echo 'using libkrylov/src/cmplx_dp_test/driver1a_cmplx_dp'  >> ../testing.summary
echo 'on reference matrix problem found in'  >> ../testing.summary
echo ' libkrylov/test/cmplx_dp_ref/ref_1a/cmplx_dp_1a_prob.json' >> ../testing.summary
echo 'comparing to exact solutions' >> ../testing.summary
sed '7,11!d' cmplx_dp_1a_exact_vals.json >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_dp_1a_vals.json 2>/dev/null
rm cmplx_dp_1a_vecs.json 2>/dev/null
mv cmplx_dp_npc_driver1a.out cmplx_dp_npc_driver1a.out.old 2>/dev/null
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1a/cmplx_dp_npc_driver1a.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -precon none > cmplx_dp_npc_driver1a.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_npc_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_npc_vecs.json
grep 'Converged' cmplx_dp_npc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_npc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1a_npc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_apc_driver1a.out cmplx_dp_apc_driver1a.out.old 2>/dev/null
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1a/cmplx_dp_apc_driver1a.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -precon approx_spectra > cmplx_dp_apc_driver1a.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_apc_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_apc_vecs.json
grep 'Converged' cmplx_dp_apc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_apc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1a_apc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_dpc_driver1a.out cmplx_dp_dpc_driver1a.out.old 2>/dev/null
echo 'solve reference problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1a/cmplx_dp_dpc_driver1a.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -precon davidson > cmplx_dp_dpc_driver1a.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_dpc_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_dpc_vecs.json
grep 'Converged' cmplx_dp_dpc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_dpc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1a_dpc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_dp_spc_driver1a.out cmplx_dp_spc_driver1a.out.old 2>/dev/null
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_dp_testing.results/ref_1a/cmplx_dp_spc_driver1a.out' >> ../testing.summary
../../../src/cmplx_dp_test/driver1a_cmplx_dp -precon sleijpen> cmplx_dp_spc_driver1a.out
mv cmplx_dp_1a_vals.json cmplx_dp_1a_spc_vals.json
mv cmplx_dp_1a_vecs.json cmplx_dp_1a_spc_vecs.json
grep 'Converged' cmplx_dp_spc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_dp_spc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_dp_1a_spc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Double reference_a tests done~~~~~'
