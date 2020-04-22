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
echo 'using libkrylov/src/cmplx_sp_test/driver1b_cmplx_sp'  >> ../testing.summary
echo 'on random matrix problem and'  >> ../testing.summary
echo 'with right hand side (rhs) in'  >> ../testing.summary
echo ' libkrylov/src/cmplx_sp_ref/ref_1b/' >> ../testing.summary
echo 'at zero frequency'  >> ../testing.summary
echo 'comparing to exact lagrangians' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_exact_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
rm cmplx_sp_1b_lagr.json
rm cmplx_sp_1b_vecs.json
mv cmplx_sp_npc_driver1b.out cmplx_sp_npc_driver1b.out.old
echo 'solve reference problem with no preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/ref_1b/cmplx_sp_npc_driver1b.out' >> ../testing.summary
echo 'none' | ../../../src/cmplx_sp_test/driver1b_cmplx_sp > cmplx_sp_npc_driver1b.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_npc_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_npc_vecs.json
grep 'Converged' cmplx_sp_npc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_npc_driver1b.out >> ../testing.summary
echo 'lagrangians:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_npc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_apc_driver1b.out cmplx_sp_apc_driver1b.out.old
echo 'solve reference problem with approximate spectra preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/random_1b/cmplx_sp_apc_driver1b.out' >> ../testing.summary
echo 'approx_spectra' | ../../../src/cmplx_sp_test/driver1b_cmplx_sp > cmplx_sp_apc_driver1b.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_apc_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_apc_vecs.json
grep 'Converged' cmplx_sp_apc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_apc_driver1b.out >> ../testing.summary
echo 'lagrangians:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_apc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
mv cmplx_sp_spc_driver1b.out cmplx_sp_spc_driver1b.out.old
echo 'solve reference problem with Jacobi-Davidson preconditioner' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/random_1b/cmplx_sp_spc_driver1b.out' >> ../testing.summary
echo 'sleijpen' | ../../../src/cmplx_sp_test/driver1b_cmplx_sp > cmplx_sp_spc_driver1b.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_spc_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_spc_vecs.json
grep 'Converged' cmplx_sp_spc_driver1b.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_spc_driver1b.out >> ../testing.summary
echo 'lagrangians:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_spc_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Single reference_b test done~~~~~'
