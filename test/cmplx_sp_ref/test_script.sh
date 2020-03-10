#bin/bash
mv testing.summary testing.summary.old
cp -r ../cmplx_sp_ref/* .
# run tests and get output into the right places
echo 'libkrylov tests' >> testing.summary
echo ' on complex matrix elements at single precision' >> testing.summary
cd unit_tests
./test_script.sh
cd ../ref_1a
./test_script.sh
cd ../restart_a
./test_script.sh
#cd ../random_1a
#./test_script.sh
#cd ../vandermonde_1a
#./test_script.sh
cd ../ref_1b
./test_script.sh
cd ../restart_b
./test_script.sh
#cd ../random_1b
#./test_script.sh
cd ../ref_1c
./test_script.sh
cd ../restart_c
./test_script.sh
#cd ../random_1c
#./test_script.sh
cd ..
echo '~all Complex Single Precision Tests done~'
echo '~echoing test summary~'
cat testing.summary

