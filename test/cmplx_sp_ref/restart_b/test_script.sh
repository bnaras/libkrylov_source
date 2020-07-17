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
echo '~~~test_restart_from_reference file~~~' >> ../testing.summary
echo '' >> ../testing.summary
echo 'using libkrylov/src/cmplx_sp_test/test_restart_b_cmplx_sp'  >> ../testing.summary
echo 'on the same problem as the reference test' >> ../testing.summary
echo 'with the approximate spectra preconditioner' >> ../testing.summary
cp ../ref_1b/cmplx_sp_1b_prob.json .
cp ../ref_1b/cmplx_sp_1b_rhs.json .
rm cmplx_sp_1b_lagr.json 2>/dev/null
rm cmplx_sp_1b_vecs.json 2>/dev/null
rm *.save 2>/dev/null
rm *.rstrt 2>/dev/null
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 4 > cmplx_sp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_sp_b_restart_0.out cmplx_sp_b_restart_0.out.old 2>/dev/null
echo 'generating save file for' >> ../testing.summary
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_0.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 1 > cmplx_sp_b_restart_0.out
echo '' >> ../testing.summary
rm cmplx_sp_1b_lagr.json
rm cmplx_sp_1b_vecs.json
mv cmplx_sp_b_restart_1.out cmplx_sp_b_restart_1.out.old 2>/dev/null
echo 'restart level 1' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_1.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 1 > cmplx_sp_b_restart_1.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_1_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_1_vecs.json
grep 'Converged' cmplx_sp_b_restart_1.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_b_restart_1.out >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_1_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 4 > cmplx_sp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_sp_b_restart_2.out cmplx_sp_b_restart_2.out.old 2>/dev/null
echo 'restart level 2' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_2.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 2 > cmplx_sp_b_restart_2.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_2_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_2_vecs.json
grep 'Converged' cmplx_sp_b_restart_2.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_b_restart_2.out >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_2_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 4 > cmplx_sp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_sp_b_restart_3.out cmplx_sp_b_restart_3.out.old 2>/dev/null
echo 'restart level 3' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_3.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 3 > cmplx_sp_b_restart_3.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_3_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_3_vecs.json
grep 'Converged' cmplx_sp_b_restart_3.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_b_restart_3.out >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_3_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo 'generating restart files for' >> ../testing.summary
echo 'restart levels' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_k.out' >> ../testing.summary
touch kill.libkrylov
rm *.save
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 4 > cmplx_sp_b_restart_k.out
echo '' >> ../testing.summary
rm kill.libkrylov
mv cmplx_sp_b_restart_4.out cmplx_sp_b_restart_4.out.old 2>/dev/null
echo 'restart level 4' >> ../testing.summary
echo 'test output in' >> ../testing.summary
echo 'test/cmplx_sp_testing.results/restart_b/cmplx_sp_b_restart_4.out' >> ../testing.summary
../../../src/cmplx_sp_test/driver1b_cmplx_sp -irestart 4 > cmplx_sp_b_restart_4.out
mv cmplx_sp_1b_lagr.json cmplx_sp_1b_4_lagr.json
mv cmplx_sp_1b_vecs.json cmplx_sp_1b_4_vecs.json
grep 'Converged' cmplx_sp_b_restart_4.out >> ../testing.summary
echo 'error statments:' >> ../testing.summary
grep 'failed' cmplx_sp_b_restart_4.out >> ../testing.summary
echo 'lagrangian:' >> ../testing.summary
sed '7,9!d' cmplx_sp_1b_4_lagr.json >> ../testing.summary
echo '' >> ../testing.summary
echo '~~~~~Complex Single restart_b test done~~~~~'
