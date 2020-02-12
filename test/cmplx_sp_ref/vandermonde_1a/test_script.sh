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
echo '~~~test_solve_from_vandermonde_problem_a~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/cmplx_sp_test/driver1a_cmplx_sp'  >> ../testing.summary
echo 'on vandermonde matrix problem made by'  >> ../testing.summary
echo ' libkrylov/src/cmplx_sp_test/problem1a_vm_cmplx_sp' >> ../testing.summary
../../../src/cmplx_sp_test/problem1a_vm_cmplx_sp
echo 'comparing to exact solutions' >> ../testing.summary
sed '7,11!d' cmplx_sp_1a_exact_vals.json >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_sp_1a_vals.json
rm cmplx_sp_1a_vecs.json
rm cmplx_sp_1a_npc_vals.json
rm cmplx_sp_1a_npc_vecs.json
rm cmplx_sp_1a_apc_vals.json
rm cmplx_sp_1a_apc_vecs.json
rm cmplx_sp_1a_dpc_vals.json
rm cmplx_sp_1a_dpc_vecs.json
mv cmplx_sp_npc_driver1a.out cmplx_sp_npc_driver1a.out.old
echo 'solve vandermonde problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/vandermonde_1a/cmplx_sp_npc_driver1a.out' >> ../testing.summary
echo 'none' | ../../../src/cmplx_sp_test/driver1a_cmplx_sp > cmplx_sp_npc_driver1a.out
mv cmplx_sp_1a_vals.json cmplx_sp_1a_npc_vals.json
mv cmplx_sp_1a_vecs.json cmplx_sp_1a_npc_vecs.json
grep 'Converged' cmplx_sp_npc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_npc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_sp_1a_npc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_apc_driver1a.out cmplx_sp_apc_driver1a.out.old
echo 'solve vandermonde problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/vandermonde_1a/cmplx_sp_apc_driver1a.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/cmplx_sp_test/driver1a_cmplx_sp > cmplx_sp_apc_driver1a.out
mv cmplx_sp_1a_vals.json cmplx_sp_1a_apc_vals.json
mv cmplx_sp_1a_vecs.json cmplx_sp_1a_apc_vecs.json
grep 'Converged' cmplx_sp_apc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_apc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_sp_1a_apc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_dpc_driver1a.out cmplx_sp_dpc_driver1a.out.old
echo 'solve vandermonde problem with davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/vandermonde_1a/cmplx_sp_dpc_driver1a.out' >> ../testing.summary
echo 'davidson' | ../../../src/cmplx_sp_test/driver1a_cmplx_sp > cmplx_sp_dpc_driver1a.out
mv cmplx_sp_1a_vals.json cmplx_sp_1a_dpc_vals.json
mv cmplx_sp_1a_vecs.json cmplx_sp_1a_dpc_vecs.json
grep 'Converged' cmplx_sp_dpc_driver1a.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_dpc_driver1a.out >> ../testing.summary
echo 'eigenvalues' >> ../testing.summary
sed '7,11!d' cmplx_sp_1a_dpc_vals.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Single vandermonde_a test done~~~~~'
